<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>국세청신고파일작업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ page import="yjungsan.util.DateUtil"%>

<script type="text/javascript">
var today = new Date();
var mm = today.getMonth()+1;
	$(function() {

		/* 현재년 */
		$("#tgtYear").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>") ;
		
		$("#declYmdTemp").datepicker2();	
		
		$("#declYmdTemp").val("<%=curSysYyyyMMddHyphen%>");
		
		/* 사업장 */
		var payCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getPayComCodeList"), "전체" );
		$("#bizLoc").html(payCdList[2]);
		
		var searchYM = <%=curSysYear%>;
		
		/* 상반기 (2~7월) */
		if(<%=curSysMon%> > 1 && <%=curSysMon%> < 8){
			searchYM = searchYM +"06";
		}
		/* 하반기 (8~1월)*/
		else{
			if(<%=curSysMon%> == 1) {
				searchYM = searchYM - 1;
			}
			searchYM = searchYM + "12";
		}
		
		/* 근로소득 */
		var declClassList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+searchYM,"YEA003"), "선택");
		$("#declClass").html(declClassList[2]);
		
		//2021.07.12 
		workPartSet();

        /* 상반기 (2~7월) */
        if(mm > 1 && mm < 8){
            $("#searchHalfType").val("1");
        }
        /* 하반기 (8~1월)*/
        else{
            if(mm == 1) {
                $("#tgtYear").val($("#tgtYear").val()-1);
            }
            $("#searchHalfType").val("2");
        }
	});
	
	
	
	/**
	 * 국세청 신고자료 생성
	 * 1=지급조서
	 *
	 */ 
	function onCreateSpecClick(idx) {
		
		$("#resultFile").val('');
		$("#cntA").val('');
		$("#cntB").val('');
		$("#cntC").val('');
		$("#taxAmt").val('');
		$("#extTaxAmt").val('');
		$("#incomeTax").val('');
		$("#businessCnt").val('');
		$("#userCnt").val('');

		if(idx == '1'){
			/* 대상년도 */
			if($("#tgtYear").val() ==''){
			    alert('대상년도를 입력해 주십시오') ;
			    $("#tgtYear").focus();
			    return;
			}
			
			/* 소득구분 */
			var flag = $("#declClass option:selected").val();
			
			if(flag == ""){
				alert('소득구분을 선택해 주십시오') ;
				$("#declClass").focus();
				return;
			}
			
			/* 제출일자 */
			if($("#declYmdTemp").val() ==''){
			    alert('제출일자를 입력해 주십시오') ;
			    $("#declYmdTemp").focus();
			    return;
			}
			
			/* 담당부서 */
			if($("#declDept").val() ==''){
			    alert('담당부서를 입력해 주십시오') ;
			    $("#declDept").focus();
			    return;
			}
			
			/* 담당자 성명 */
			if($("#declEmp").val() ==''){
			    alert('담당자 성명을 입력해 주십시오') ;
			    $("#declEmp").focus();
			    return;
			}
			
			/* 전화번호 */
			if($("#declEmpTel").val() ==''){
			    alert('전화번호를 입력해 주십시오') ;
			    $("#declEmpTel").focus();
			    return;
			}
			
		}
		
		//소득구분별 사업장별 마감 체크
		var param = "tgtYear="+$("#tgtYear").val()			// 대상년도
		+"&searchHalfType="+$("#searchHalfType").val()		// 반기구분
		+"&declClass="+$("#declClass").val()				// 소득구분
		+"&bizLoc="+$("#bizLoc").val(); 					// 사업장
		
		var data = ajaxCall("<%=jspPath%>/simplePymtNtsFileMgr/simplePymtNtsFileMgrRst.jsp?cmd=getBizLoc", param,false);

		if(data.Data.cnt < 1) {
			alert($("#tgtYear").val()+"년 "+$('#declClass option:selected').text()+" 사업장("+$('#bizLoc option:selected').text()+")에 대한"+" 마감건이 없습니다.");
			return;
		}
		
		if(confirm("국세청 신고파일을 생성하시겠습니까?") == false) return;
		
		var url = "";
		
		switch(idx) {
		case 1: 
			/* 소득구분 */
			if( $("#declClass").val() == "77" ) {
			    $("#filePrefix").val("SC"); 
			} 
			
			/* 사업소득 */
			else if( $("#declClass").val() == "50" ) {
			    $("#filePrefix").val("SF"); 
			} 
			
			/* 연말정산대상 사업소득 */
			else if( $("#declClass").val() == "61" ) {
			    $("#filePrefix").val("S3"); 
			} 
			
			/* 비거주자의 사업기타 */
			else if( $("#declClass").val() == "49" ) {
			    $("#filePrefix").val("SBI"); 
			} 
			
			url = "<%=jspPath%>/simplePymtNtsFileMgr/simplePymtNtsFileMgrRst.jsp";
			break;
		default: break;
		}
		
	    $("#declYmd").val($("#declYmdTemp").val().replace(/\-/g,''));
		
		var result = ajaxCall(url,$("#dataForm").serialize()					
				,true
				,function(){
					//$("#progressCover").show();
		 		}
				,function(rstData){
					$("#progressCover").hide();
					
					if(rstData.Result.Code == 1) {
	
						//결과 매핑
						callbackResult($("#filePrefix").val(),rstData.Data, $("#declClass").val());
						//파일다운로드
						ntsFileDownload(rstData.Data.serverSaveFileName);
					}
 				}
		);
	}
	
	function callbackResult(filePrefix, data, key) {
		
		$("#resultFile").val(data.viewSaveFileName) ;
		/* $("#resultFile").val(data.serverSaveFileName) ; */
		$("#cntA").val(data.recodeCntA);
		$("#cntB").val(data.recodeCntB);
		$("#cntC").val(data.recodeCntC);
		
		$("#taxAmt").val(data.taxAmt);
		if(key == '77'){
			$("#extTaxAmt").val(data.extTaxAmt);
		}
		$("#incomeTax").val(data.itaxTotMon);
		
		$("#businessCnt").val(data.businessCnt);
		$("#userCnt").val(data.userCnt);
	}
	
	
	function ntsFileDownload(fileName) {
		if(fileName != "") {
			$("iframe").attr("src","<%=jspPath%>/simplePymtNtsFileMgr/simplePymtNtsFileDownload.jsp?fileName="+fileName+"&ssnEnterCd=<%=removeXSS(session.getAttribute("ssnEnterCd"), '1')%>");
		}
	}
	function workPartSet(){
        if($("#tgtYear").val() == "2021"){
        	/*
        	    77 근로소득
        	    50  사업소득
        	    49  비거주자사업기타
        	*/
        	  if($("#declClass").val() == "50"){
        		  //사업소득
        		  $('#searchHalfType').empty();
        		  $('#searchHalfType').append("<option value='1'>상반기</option>");
                  $('#searchHalfType').append("<option value='07'>7월</option>");
                  $('#searchHalfType').append("<option value='08'>8월</option>");
                  $('#searchHalfType').append("<option value='09'>9월</option>");
                  $('#searchHalfType').append("<option value='10'>10월</option>");
                  $('#searchHalfType').append("<option value='11'>11월</option>");
                  $('#searchHalfType').append("<option value='12'>12월</option>");        		  
        	  }else{
        		  //근로소득,비거주자사업기타
        		  $('#searchHalfType').empty();
                  $('#searchHalfType').append("<option value='1'>상반기</option>");
                  $('#searchHalfType').append("<option value='2'>하반기</option>"); 

                  /* 상반기 (2~7월) */
//                   if(mm > 1 && mm < 8){
//                       $("#searchHalfType").val("1");
//                   }
//                   /* 하반기 (8~1월)*/
//                   else{
//                       if(mm == 1) {
//                           $("#tgtYear").val($("#tgtYear").val()-1);
//                       }
//                       $("#searchHalfType").val("2");
//                   }                  
        	  }
         }else if($("#tgtYear").val() > "2021"){
        	 
             if($("#declClass").val() == "50"){
                 //사업소득
                 $('#searchHalfType').empty();
                 $('#searchHalfType').append("<option value='01'>1월</option>");
                 $('#searchHalfType').append("<option value='02'>2월</option>");
                 $('#searchHalfType').append("<option value='03'>3월</option>");
                 $('#searchHalfType').append("<option value='04'>4월</option>");
                 $('#searchHalfType').append("<option value='05'>5월</option>");
                 $('#searchHalfType').append("<option value='06'>6월</option>");        
                 $('#searchHalfType').append("<option value='07'>7월</option>");
                 $('#searchHalfType').append("<option value='08'>8월</option>");
                 $('#searchHalfType').append("<option value='09'>9월</option>");
                 $('#searchHalfType').append("<option value='10'>10월</option>");
                 $('#searchHalfType').append("<option value='11'>11월</option>");
                 $('#searchHalfType').append("<option value='12'>12월</option>");                 
             }else{
                 //근로소득,비거주자사업기타
                 $('#searchHalfType').empty();
                 $('#searchHalfType').append("<option value='1'>상반기</option>");
                 $('#searchHalfType').append("<option value='2'>하반기</option>");
//                  /* 상반기 (2~7월) */
//                  if(mm > 1 && mm < 8){
//                      $("#searchHalfType").val("1");
//                  }
//                  /* 하반기 (8~1월)*/
//                  else{
//                      if(mm == 1) {
//                          $("#tgtYear").val($("#tgtYear").val()-1);
//                      }
//                      $("#searchHalfType").val("2");
//                  }                 
             }
         }else{            
             $('#searchHalfType').empty();
             $('#searchHalfType').append("<option value='1'>상반기</option>");
             $('#searchHalfType').append("<option value='2'>하반기</option>");
             /* 상반기 (2~7월) */
//              if(mm > 1 && mm < 8){
//                  $("#searchHalfType").val("1");
//              }
//              /* 하반기 (8~1월)*/
//              else{
//                  if(mm == 1) {
//                      $("#tgtYear").val($("#tgtYear").val()-1);
//                  }
//                  $("#searchHalfType").val("2");
//              }
         }   
 }	
	
</script>
</head>
<body class="bodywrap" style="overflow-x:hidden;overflow-y:auto;">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
	<form id="dataForm" name="dataForm">
    <input type="hidden" name="filePrefix" id="filePrefix"/>
    <input type="hidden" name="fileDataType" id="fileDataType"/>
    <input type="hidden" name="declYmd" id="declYmd"/>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="48%" />
			<col width="2%" />
			<col width="50%" />
		</colgroup>
		<tr>
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="20%" />
						<col width="30%" />
						<col width="20%" />
						<col width="" />
					</colgroup>
					<tr>
						<th>대상년도</th>
						<td colspan="3">
							<input type="text" id="tgtYear" name="tgtYear" class="text required" value="" style="width:35%; text-align: center;" maxlength="4" onchange="workPartSet();"/>
						</td>					
					</tr>
                    <tr>
                        <th>소득구분</th>
                        <td colspan="3">
                             <select id="declClass" name="declClass" style="width:35%;" class="text required date2" onchange="workPartSet();"> </select>
                        </td>
                    </tr>
					<tr>
                        <th>신고기간</th>
                        <td colspan="3">
                            <select id="searchHalfType" name="searchHalfType" style="width:35%;" class="text required date2" >
                                <option value="1" id="searchHalfType01" selected="selected">상반기</option>
                                <option value="2" id="searchHalfType02">하반기</option>                            
                            </select>
                        </td>
					</tr>
					<tr>
						<th>사업장</th>
						<td colspan="3">
							<select id="bizLoc" name="bizLoc" style="width:35%;" > </select>
						</td>
					</tr>
					<tr>
						<th>제출일자</th>
						<td colspan="3">
							<input type="text" id="declYmdTemp" name="declYmdTemp" class="text required date2" value="" validator="required" style="width:32%;" /> (예: 2014-01-20)
						</td>
					</tr>
					<tr>
						<th>홈택스ID</th>
						<td colspan="3">
							<input type="text" id="hometaxId" name="hometaxId" class="text" value="" style="width:35%;" />
						</td>
					</tr>
				</table>
			</td>
			<td>
			</td>
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default" style="height: 150px;">
					<colgroup>
						<col width="25%" />
						<col width="75%" />
					</colgroup>
					<tr>
						<th>제출자구분</th>
						<td colspan="3"> 
							<select id="declPrsnClass" name="declPrsnClass" style="width: 152px;">
								<option value="1">세무대리인
								<option value="2" selected >법인
								<option value="3">개인
							 </select>
						</td>
					</tr>
					<tr>
						<th>세무대리인번호</th>
						<td colspan="3">
							<input type="text" id="taxProxyNo" name="taxProxyNo" class="text" value="" style="width:150px" maxlength="6"/>
						</td>
					</tr>
					<tr>
						<th>담당부서</th>
						<td colspan="3">
							<input type="text" id="declDept" name="declDept" class="text required" value="" style="width:150px;" maxlength="30" />
						</td>
					</tr>
					<tr>
						<th>담당자성명</th>
						<td>
							<input type="text" id="declEmp" name="declEmp" class="text required" value="" style="width:150px;" maxlength="20"/>
						</td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td>
							<input type="text" id="declEmpTel" name="declEmpTel" class="text required" value="" style="width:150px" maxlength="15" />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="3"></td>
		</tr>
		<tr>
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="25%" />
						<col width="75%" />
					</colgroup>
					<tr>
						<td colspan="2" class="center" >
							<a href="javascript:onCreateSpecClick(1);" style="font-size: 13px;" class="pink authA">지급조서생성</a>
						</td>
					</tr>
					<tr>
						<th>파일명</th>
						<td>
							<input type="text" id="resultFile" name="resultFile" class="text readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
					<tr>
						<th>A 레코드수</th>
						<td>
							<input type="text" id="cntA" name="cntA" class="text right readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
					<tr>
						<th>B 레코드수</th>
						<td>
							<input type="text" id="cntB" name="cntB" class="text right readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
					<tr>
						<th>C 레코드수</th>
						<td>
							<input type="text" id="cntC" name="cntC" class="text right readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
				</table>
			</td>
			<td>
			</td>
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="25%" />
						<col width="75%" />
					</colgroup>
					<tr>
						<td colspan="2" class="center">
							<span style="font-weight:bold; font-size: 20px;">생성 결과</span>
						</td>
					</tr>
					<tr>
						<th>사업장 수</th>
						<td>
							<input type="text" id="businessCnt" name="businessCnt" class="text readonly" value="" style="width:150px; text-align: right;" readonly />
						</td>
					</tr>
					<tr>
						<th>인원 수 (마감된 인원만 생성됩니다)</th>
						<td>
							<input type="text" id="userCnt" name="userCnt" class="text readonly" value="" style="width:150px; text-align: right;" readonly />
						</td>
					</tr>
					<tr>
						<th>과세소득 계</th>
						<td>
							<input type="text" id="taxAmt" name="taxAmt" class="text readonly" value="" style="width:150px; text-align: right;" readonly />
						</td>
					</tr>
					<tr>
						<th>인정상여 계</th>
						<td>
							<input type="text" id="extTaxAmt" name="extTaxAmt" class="text readonly" value="" style="width:150px; text-align: right;" readonly />
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td colspan="3"></td>
		</tr>
	</table>
	</form>
</div>
<iframe id="ntsFileDownloadFrame" src="" frameborder="0" scrolling="no" width="0" height="0" style="display:none"></iframe>
</body>
</html>