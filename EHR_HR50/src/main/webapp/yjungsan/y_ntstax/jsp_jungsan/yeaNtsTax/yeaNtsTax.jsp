<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>국세청신고파일작업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");
%>
<style type="text/css">
img {
	vertical-align: middle;
	cursor:pointer;
}
</style>
<script type="text/javascript">
    var reginoList;
	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
        <% String strYearNts = request.getParameter("yearNts"); %>
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=(strYearNts != null && strYearNts.length() > 3) ? strYearNts.substring(0, 4) : ""%>,"C00327"), "");

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		var payCdList = "";

		if(ssnSearchType == "A"){
			payCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getPayComCodeList","",false).codeList, "전체");
		}else{
			payCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}
	    reginoList = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "queryId=getPayComCodeList",false).codeList;

		$("#declClass").html(adjustTypeList[2]);
		$("#bizLoc").html(payCdList[2]);
		
		$("#tgtYear").val(<%=(strYearNts != null && strYearNts.length() > 3) ? strYearNts.substring(0, 4) : ""%>);
		$("#declYmdTemp").val("<%=curSysYyyyMMddHyphen%>");
		$("#srchRegiNo").val("");
		$("#includeText").hide();
	});

	$(function() {
		$("#tgtYear").bind("keyup",function(event){
			makeNumber(this,"A");
		});
		$("#declEmpTel").bind("keyup",function(event){
			makeNumber(this,"B");
		});

		$("#declYmdTemp").datepicker2();

		$("#declClass").bind("change", function() {
			var flag = $("#declClass option:selected").val();
	        if(flag == "3"){
	            $("#btnMed").prop("disabled", true);
	            $("#btnMed").addClass("selected");
	            $("#btnRet").prop("disabled", false);
	        	$("#btnRet").removeClass("selected");
	        	$("#deClDiv").hide();
	        	$("#deClDiv2").hide();
	        	$("#deClDiv3").hide();
	        	$("#deClDiv4").hide();
	        	$("#deClDiv5").hide();
	        	$("#deClDivJ").hide();
	        	$("#deClDivK").hide();
// 	        	$("#deClDiv6").hide();
	        	$("#deClDiv7").hide();
	        	$("#deClDiv9").hide();
	        	$("#deClDiv8").hide();
	        	$("#includeYn").val("Y");
	        	$("#includeText").show();
	        	$("#includeYn").prop("disabled", true);
	        	$("#btnRet").show();
	        } else {
	        	$("#btnMed").prop("disabled", false);
	        	$("#btnMed").removeClass("selected");
	        	$("#btnRet").prop("disabled", true);
	            $("#btnRet").addClass("selected");
	            $("#deClDiv").show();
	        	$("#deClDiv").show();
	        	$("#deClDiv2").show();
	        	$("#deClDiv3").show();
	        	$("#deClDiv4").show();
	        	$("#deClDiv5").show();
	        	$("#btnRet").hide();
	        	
	        	/* 23.12.29 J레코드는 23년 귀속부터 생겼으므로 2023년 이전에는 표기하지 않는다 */
	        	if($("#tgtYear").val() != ""
	        			&& $("#tgtYear").val() != undefined 
	        			&& $("#tgtYear").val() != null 
	        			&& $("#tgtYear").val() >= "2023")
	        		$("#deClDivJ").show();
	        	
	        	
	        	
	        	/* 24.12.16 K레코드는 24년 귀속부터 생겼으므로 2024년 이전에는 표기하지 않는다 */
	        	if($("#tgtYear").val() != ""
	        			&& $("#tgtYear").val() != undefined 
	        			&& $("#tgtYear").val() != null 
	        			&& $("#tgtYear").val() >= "2024")
	        		$("#deClDivK").show();
	        	
	        	
// 	        	$("#deClDiv6").show();
	        	$("#deClDiv7").show();
	        	$("#deClDiv9").show();
	        	$("#deClDiv8").show();
	        	$("#includeText").hide();
	        	$("#includeYn").prop("disabled", false);
	        }
	        
	        if($("#includeYn").val() == '1') {
	        	$("#errChk").prop("disabled", false);			
			} else {
				$("#errChk").prop("checked", false);
				$("#errChk").prop("disabled", true);
			}
		});

		$("#btnRet").hide();
		
		//퇴직소득 대상자 현황 비활성화
		$("#btnRet").prop("disabled", true);
        $("#btnRet").addClass("selected");

        $("#bizLoc").bind("change", function() {
        	$("#srchRegiNo").val("");
        	if($("#bizLoc").val() != "") {
        		if(typeof(reginoList) === "object" && reginoList.length > 0) {
        	    	for(var i=0; i<reginoList.length; i++) {
        	    		if($("#bizLoc").val() == reginoList[i].code) {
        	    			$("#srchRegiNo").val(reginoList[i].regino.replace(/\-/g,''));
        	    			break;
        	    		}
        	    	}
        	    }
        	}
        	//$("#reginoText").html($("#srchRegiNo").val());
		}).change();
        
        // 제출대상기간코드
        var termCodeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+$("#tgtYear").val(),"C00509"), "");
        $("#termCode").append(termCodeList[2]);
        
      	//우리사주배당금비과세 사용 여부
		var wooriYn = ajaxCall("<%=jspPath%>/yeaNtsTax/yeaNtsTaxSCRst.jsp?cmd=chkWooriYn", "1=1",false);

		$("#btnDisplayYn").hide() ;
		if ( wooriYn != null) {
			if(wooriYn.table_yn == "Y") {
				$("#btnDisplayYn").show() ;
			}
		}
	});


	/**
	 * 정산내역 팝업
	 * 2=의료비내역, 4=퇴직소득대상자현황
	 *
	 */
	function openCalcPopup(idx) {

		var flag = $("#declClass option:selected").val();
		if(idx == 2 && flag == "3"){
            alert("퇴직소득을 선택한 경우 의료비명세 생성이 불가합니다.");
            return;
        }

		if(idx == 4 && flag == "1"){
            alert("근로소득을 선택한 경우 퇴직소득 대상자 현황 조회가 불가합니다.");
            return;
        }

		//년도 체크(필수 파라매터)
		if($("#tgtYear").val() == "") {
			alert("년도를 입력하여 주십시오.") ;
			return;
		} else if($("#tgtYear").val().length != 4) {
			alert("년도를 확인하여 주십시오.") ;
			return;
		}

		if($("#declClass").val() == "") {
			alert("구분을 입력하여 주십시오.") ;
			return;
		}

	    try{
			var args    = new Array();
			args["searchWorkYy"]     = $("#tgtYear").val() ;   //대상년도
			args["searchAdjustType"] = $("#declClass").val() ; //작업구분
			args["searchBizLoc"]     = $("#bizLoc").val() ;    //작업장

			if(!isPopup()) {return;}

			switch(idx) {
			case 2:
				//의료비정산계산내역
				openPopup("<%=jspPath%>/yeaNtsTax/yeaCalcMedicalPopup.jsp", args, "1100","600");
				break;
			case 4:
				//퇴직소득 대상자 현황
				openPopup("<%=jspPath%>/yeaNtsTax/yeaCalcRetireePopup.jsp", args, "1100","700");
				break;
			}

	    } catch(ex){
	    	alert("Open Popup Event Error : " + ex);
	    }
	}

	function preOnCreateSpecClick(idx) {
		if(idx == '1' || idx =='3' || idx =='4'){
			if($("#declDept").val() ==''){
			    alert('담당부서를 입력해 주세요') ;
			    return;
			}
			if($("#declEmp").val() ==''){
			    alert('담당자를 입력해 주세요') ;
			    return;
			}
			if($("#declEmpTel").val() ==''){
			    alert('전화번호를 입력해 주세요') ;
			    return;
			}
		}

		var flag = $("#declClass option:selected").val();
		
		if(idx == "2"){
			if(flag == "3"){
				alert("퇴직소득을 선택한 경우 의료비명세 생성이 불가합니다.");
				return;
			}
		}

		if ($("#declYmdTemp").val() == "") {
			alert("대상년도를 입력하십시오.");
			$("#declYmdTemp").focus();
			return;
		}
		if ($("#declYmdTemp").val() == "") {
			alert("제출일자를 입력하십시오.");
			$("#declYmdTemp").focus();
			return;
		}
		
		//1=지급조서, 2=의료비명세, 3=기부금명세

		var msg = "";
		
		if(idx == "1" || idx =="2" || idx =="4"){
			msg = "지급조서 생성하기 전 [연말정산계산] 화면에서 전직원에 대해 \n세금계산을 최종적으로 작업해야 정상 반영됩니다.\n국세청 신고파일을 생성하시겠습니까?";
			if(flag == "3"){
				msg = "지급조서 생성하기 전 [대상자현황] 팝업에서 연금계좌정보 등록 여부 및 퇴직소득 신고대상 확인해주시기 바랍니다.";	
			}
		}
		
		if($("#errChk").is(":checked")) {
			
			if(confirm("오류검증 실행시 기존 오류검증 내용이 삭제 됩니다. \n실행 하시겠습니까?")){
				ajaxCall("<%=jspPath%>/yeaNtsTax/yeaNtsErrChkRst.jsp?cmd=prcInputErrChkMgr", $("#dataForm").serialize()
						,true
						,function(){
							$("#progressCover").show();
						 }
						,function(){
							var errCnt = ajaxCall("<%=jspPath%>/yeaNtsTax/yeaNtsErrChkRst.jsp?cmd=selectInputErrChkMgrList", $("#dataForm").serialize(),false);
							if(errCnt.Data[0].cnt > 0) {
								if(confirm(msg) == false) { 
									$("#progressCover").hide(); 
									return;
								}
								onCreateSpecClick(idx);
							} else {
								if(confirm(msg) == false) { 
									$("#progressCover").hide(); 
									return;
								}
								onCreateSpecClick(idx);
							}
						}
				);
		    }
			return;
		}
		
		if(confirm(msg) == false) return;
	
		onCreateSpecClick(idx);
	}
	
	/**
	 * 국세청 신고자료 생성
	 * 1=지급조서, 2=의료비명세, 3=기부금명세
	 *
	 */
	function onCreateSpecClick(idx) {
		
		var url = "";

		switch(idx) {
		case 1:
			if( $("#declClass").val() == "1" ) {//연말 정산
			    $("#filePrefix").val("C");
			    $("#fileDataType").val("20");
			} else if( $("#declClass").val() == "3" ) {//퇴직소득(법정)
			    $("#filePrefix").val( "EA" );
			    $("#fileDataType").val( "25" );
			}
			url = "<%=jspPath%>/yeaNtsTax/yeaNtsTaxCRst.jsp";
			break;
		case 2:
			$("#filePrefix").val("CA");
			$("#fileDataType").val("26");
			url = "<%=jspPath%>/yeaNtsTax/yeaNtsTaxCARst.jsp";
			break;
		case 3:
			$("#filePrefix").val("H");
			$("#fileDataType").val("27");
			url = "<%=jspPath%>/yeaNtsTax/yeaNtsTaxHRst.jsp";
			break;
		case 4:
			$("#filePrefix").val("SC");
			url = "<%=jspPath%>/yeaNtsTax/yeaNtsTaxSCRst.jsp";
			break;
		default: break;
		}

	    $("#declYmd").val($("#declYmdTemp").val().replace(/\-/g,''));

		var result = ajaxCall(url,$("#dataForm").serialize()
				,true
				,function(){
					$("#progressCover").show();
		 		}
				,function(rstData){
					$("#progressCover").hide();

					if(rstData.Result.Code == 1) {
						//결과 매핑
						callbackResult($("#filePrefix").val(),rstData.Data);
						//파일다운로드
						ntsFileDownload(rstData.Data.serverSaveFileName);
					}else{
						//초기화(2021.10.25)
						dataInit();
					}
 				}
		);
	}

	function callbackResult(filePrefix, data) {
		switch(filePrefix) {
		case 'C':
			$("#resultFile").val(data.viewSaveFileName) ;
			$("#cntA").val(data.recodeCntA);
			$("#cntB").val(data.recodeCntB);
			$("#cntC").val(data.recodeCntC);
			$("#cntD").val(data.recodeCntD);
			$("#cntE").val(data.recodeCntE);
			$("#cntF").val(data.recodeCntF);
			$("#cntG").val(data.recodeCntG);
			$("#cntH").val(data.recodeCntH);
			$("#cntI").val(data.recodeCntI);
			$("#cntJ").val(data.recodeCntJ);
			$("#cntK").val(data.recodeCntK);
			$("#sumPay").val(data.payTotMon);
			$("#sumNoTax").val(data.extTaxAmount);
			$("#sumExTax").val(data.taxExemptTotMon); //감면소득계 추가(2021.11)
			$("#incomeTax").val(data.itaxTotMon);
			break;
		case 'CA':
			$("#resultFileMedical").val(data.viewSaveFileName);
		    $("#cntMedical").val(data.recodeCnt);
		    $("#amtMedical").val(data.totalMon);
		    break;
		case 'SC':
			$("#resultFileEmpStockcal").val(data.viewSaveFileName);
		    $("#cntEmpStockAcal").val(data.recodeCntA);
		    $("#cntEmpStockBcal").val(data.recodeCntB);
		    break;
		case 'H':
			$("#resultFileDonation").val(data.viewSaveFileName);
         	$("#cntDonationA").val(data.recodeCntA);
			$("#cntDonationB").val(data.recodeCntB);
			$("#cntDonationC").val(data.recodeCntC);
			$("#cntDonationD").val(data.recodeCntD);
			$("#totDonationMon").val(data.totDonationMon);
			$("#totDedMon").val(data.totDedMon) ;
			break;
		case 'EA':
			$("#resultFile").val(data.viewSaveFileName) ;
			$("#cntA").val(data.recodeCntA);
			$("#cntB").val(data.recodeCntB);
			$("#cntC").val(data.recodeCntC);
			$("#cntD").val(data.recodeCntD);
			$("#cntE").val(data.recodeCntE);
			$("#cntF").val(data.recodeCntF);
			$("#cntG").val(data.recodeCntG);
			$("#cntH").val(data.recodeCntH);
			$("#cntI").val(data.recodeCntI);
			$("#cntJ").val(data.recodeCntJ);
			$("#cntK").val(data.recodeCntK);
			$("#sumPay").val(data.payTotMon);
			$("#sumNoTax").val(data.extTaxAmount);
			$("#sumExTax").val(data.taxExemptTotMon); //감면소득계 추가(2021.11)
			$("#incomeTax").val(data.itaxTotMon);
			break;
		default: break;
		}
	}

	function ntsFileDownload(fileName) {
		if(fileName != "") {
			$("iframe").attr("src",'<%=jspPath%>/yeaNtsTax/yeaNtsTaxFileDownload.jsp?fileName='+fileName+'&ssnEnterCd=<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>');
		}
	}

	//지급조서 오류유형 팝업
	function openPayRecPop(){
		var args 	= new Array();
		var jspPath = "<%=jspPath%>";
		jspPath = jspPath.replace("y_ntstax","y_"+$("#tgtYear").val());

		args["searchWorkYy"]	= $("#tgtYear").val() ;
		args["searchAdjustType"]= "1";
		args["searchCdType"]	= "190";// 지급조서
		args["searchScrnType"] 	= "y_ntstax";

		if(!isPopup()) {return;}
		pGubun = "yeaCalcCreFaqPopup";
		var rv = openPopup(jspPath+"/yeaCalcCre/yeaCalcCreFaqPopup.jsp?authPg=<%=removeXSS(authPg, '1')%>",args,"800","800");
	}
	//초기화(2021.10.25)
	function dataInit(){
		$("#resultFile").val("") ;
        $("#cntA").val("");
        $("#cntB").val("");
        $("#cntC").val("");
        $("#cntD").val("");
        $("#cntE").val("");
        $("#cntF").val("");
        $("#cntG").val("");
        $("#cntH").val("");
        $("#cntI").val("");
        $("#cntJ").val("");
        $("#cntK").val("");
        $("#sumPay").val("");
        $("#sumNoTax").val("");
        $("#sumExTax").val(""); //감면소득계 추가(2021.11)
        $("#incomeTax").val("");

        if($("#declClass").val() == "3"){
            $("#deClDiv6Txt").text("총급여");
        }else{
        	$("#deClDiv6Txt").text("총급여(전+현)");
        }
        
        if($("#includeYn").val() == '1') {
        	$("#errChk").prop("disabled", false);			
		} else {
			$("#errChk").prop("checked", false);
			$("#errChk").prop("disabled", true);
		}
	}
	
	/* 레코드 상세 팝업  (2022.11.11) */
	function recordDetailPopup(gubun) {
		var args = new Array();
		var declYmdTemp = $("#declYmdTemp").val();
		var chkFlag = false;
	    try{
	    	if(gubun != "A1"){
	    		//지급조서
	    		if($("#resultFile").val() != null && $("#resultFile").val() != ""){
	    			chkFlag = true;
	    		}else{
	    			alert("지급조서생성 이후 조회 가능합니다.");
					return;
	    		}
	    	}else{
	    		//의료비
	    		if($("#resultFileMedical").val() != null && $("#resultFileMedical").val() != ""){
	    			chkFlag = true;
	    		}else{
	    			alert("의료비명세서생성 이후 조회 가능합니다.");
    	    		return;
	    		}
	    	}
	    	
	    	if(chkFlag){
	    		args["popTitle"]	= $("#declClass option:selected").text() +" - "+ gubun+" 레코드"; //팝업명
				args["declClass"]	= $("#declClass option:selected").val();  						//소득 구분
				args["gubun"]     	= gubun;				  				  						//레코드 구분
				args["declYmdTemp"] = declYmdTemp.replaceAll("-","");				  				//제출일자
				args["workYy"] 		= $("#tgtYear").val();				  	  						//대상년도

				if(!isPopup()) {return;}
				openPopup("<%=jspPath%>/yeaNtsTax/yeaNtsTaxPopup.jsp", args, "1100","450");	    		
	    	}

	    } catch(ex){
	    	alert("Open Popup Event Error : " + ex);
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
    <input type="hidden" name="srchRegiNo" id="srchRegiNo"/>
    <input type="hidden" id="menuNm" name="menuNm" value="" />
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="3%" />
			<col width="47%" />
		</colgroup>
		<tr>
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="30%" />
						<col width="70%" />
					</colgroup>
					<tr>
						<th>대상년도</th>
						<td>
							<input type="text" id="tgtYear" name="tgtYear" class="text required w35 center" maxlength="4" value="" validator="required" />
						</td>
					</tr>
					<tr>
						<th>구분</th>
						<td>
							<select id="declClass" name="declClass" onchange="javascript:dataInit();">  </select>
						</td>
					</tr>
					<tr>
					<tr>
						<th>연말/퇴직정산 구분</th>
						<td>
							<select id="includeYn" name="includeYn" onchange="javascript:dataInit();">
								<option value="Y" selected>전체</option>
								<option value="1">연말정산</option>
								<option value="3">퇴직정산</option>
							 </select>
							 <span id="includeText" style="color:blue;">&nbsp&nbsp근로소득만 해당합니다.</span>
						</td>
					</tr>
					<tr>
						<th>사업장</th>
						<td>
							<select id="bizLoc" name="bizLoc" onchange="javascript:dataInit();"> </select>
							<span id="reginoText" style="display: none;"></span>
						</td>
					</tr>
					<tr>
						<th>제출일자</th>
						<td>
							<input type="text" id="declYmdTemp" name="declYmdTemp" class="date2 required" value="" validator="required" /> (예: 2014-01-20)
						</td>
					</tr>
					<tr>
						<th>홈택스ID</th>
						<td>
							<input type="text" id="hometaxId" name="hometaxId" class="text" value="" style="width:150px" />
						</td>
					</tr>
					<tr style="display: none;">
						<th>오류검증 자동진행</th>
                        <td>
							<span>
								<input type="checkbox" class="checkbox" id="errChk" name="errChk" value="N" style="vertical-align: middle;">
								<label>(근로소득 - 연말정산 시에만 선택 가능합니다.)</label>&nbsp;&nbsp;
							</span>
						</td>
                    </tr>
				</table>
			</td>
			<td>
			</td>
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="30%" />
						<col width="70%" />
					</colgroup>
					<tr>
						<th>제출자구분</th>
						<td colspan="3">
							<select id="declPrsnClass" name="declPrsnClass">
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
						<th>자료수정코드</th>
						<td colspan="3">
							<select id="dataModCode" name="dataModCode">
								<option value="101" selected >2바이트 완성형 코드
								<option value="201" >2바이트 조합형 코드
							</select>
						</td>
					</tr>
					<tr>
						<th>제출대상기간코드</th>
						<td colspan="3">
							<select id="termCode" name="termCode">
				                <!-- <option value="1" selected >연간(1.1~12.31)지급분
				                <option value="2">폐업에 의한 수시 제출분  -->
							 </select>
						</td>
					</tr>
					<tr>
						<th>담당부서</th>
						<td colspan="3">
							<input type="text" id="declDept" name="declDept" class="text required" value="" style="width:150px" maxlength="30" />
						</td>
					</tr>
					<tr>
						<th>담당자성명</th>
						<td>
							<input type="text" id="declEmp" name="declEmp" class="text required" value="" style="width:100px" maxlength="20"/>
						</td>
						<th>전화번호</th>
						<td>
							<input type="text" id="declEmpTel" name="declEmpTel" class="text required" value="" style="width:100px" maxlength="15" />
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
						<col width="30%" />
						<col width="70%" />
					</colgroup>
					<tr>
						<td colspan="2" class="center">
							<a href="javascript:preOnCreateSpecClick(1);" class="basic btn-red ico-fileLine authA">지급조서생성</a>
							<a href="javascript:openCalcPopup(4);" class="basic btn-gray selected ico-popup authA" id="btnRet">대상자현황</a><!-- 2019-11-05. 퇴직소득 대상자 현황 추가 -->
							<a href="javascript:openPayRecPop();"class="basic btn-white ico-popup authA">지급조서 오류유형</a>
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
							<%-- <img alt="" src="${ctx}/common/images/icon/icon_popup.png" onclick="recordDetailPopup('A');"> --%>
						</td>
					</tr>
					<tr>
						<th>B 레코드수</th>
						<td>
							<input type="text" id="cntB" name="cntB" class="text right readonly" value="" style="width:150px" readonly />
							<%-- <img alt="" src="${ctx}/common/images/icon/icon_popup.png" onclick="recordDetailPopup('B');"> --%>
						</td>
					</tr>
					<tr>
						<th>C 레코드수</th>
						<td>
							<input type="text" id="cntC" name="cntC" class="text right readonly" value="" style="width:150px" readonly />
							<%-- <img alt="" src="${ctx}/common/images/icon/icon_popup.png" onclick="recordDetailPopup('C');"> --%>
						</td>
					</tr>
					<tr>
						<th>D 레코드수</th>
						<td>
							<input type="text" id="cntD" name="cntD" class="text right readonly" value="" style="width:150px" readonly />
							<%-- <img alt="" src="${ctx}/common/images/icon/icon_popup.png" onclick="recordDetailPopup('D');"> --%>
						</td>
					</tr>
					<div>
					<tr id="deClDiv">
						<th>E 레코드수</th>
						<td>
							<input type="text" id="cntE" name="cntE" class="text right readonly" value="" style="width:150px" readonly />
							<%-- <img alt="" src="${ctx}/common/images/icon/icon_popup.png" onclick="recordDetailPopup('E');"> --%>
						</td>
					</tr>
					<tr id="deClDiv2">
						<th>F 레코드수</th>
						<td>
							<input type="text" id="cntF" name="cntF" class="text right readonly" value="" style="width:150px" readonly />
							<%-- <img alt="" src="${ctx}/common/images/icon/icon_popup.png" onclick="recordDetailPopup('F');"> --%>
						</td>
					</tr>
					<tr id="deClDiv3">
						<th>G 레코드수</th>
						<td>
							<input type="text" id="cntG" name="cntG" class="text right readonly" value="" style="width:150px" readonly />
							<%-- <img alt="" src="${ctx}/common/images/icon/icon_popup.png" onclick="recordDetailPopup('G');"> --%>
						</td>
					</tr>
					</tr>
					<tr id="deClDiv4">
						<th>H 레코드수</th>
						<td>
							<input type="text" id="cntH" name="cntH" class="text right readonly" value="" style="width:150px" readonly />
							<%-- <img alt="" src="${ctx}/common/images/icon/icon_popup.png" onclick="recordDetailPopup('H');"> --%>
						</td>
					</tr>
					</tr>
					<tr id="deClDiv5">
						<th>I 레코드수</th>
						<td>
							<input type="text" id="cntI" name="cntI" class="text right readonly" value="" style="width:150px" readonly />
							<%-- <img alt="" src="${ctx}/common/images/icon/icon_popup.png" onclick="recordDetailPopup('I');"> --%>
						</td>
					</tr>
					
					<!-- 23.12.29 J레코드는 23년 귀속부터 생겼으므로 2023년 이전에는 표기하지 않는다 -->
					<!-- 24.10.22 J레코드는 23년 귀속만 해당함으로 2023년 이외에는 표기하지 않는다 -->
					<% if(strYearNts != null && strYearNts.length() > 3 && strYearNts.substring(0, 4).compareTo("2023") == 0) { %>
					<tr id="deClDivJ">
						<th>J 레코드수</th>
						<td>
							<input type="text" id="cntJ" name="cntJ" class="text right readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
					<% } %>
					<!-- 24.12.16 출산지원금 비과세적용 K레코드 신설 2024 이후부터 표기 -->
					<% if(strYearNts != null && strYearNts.length() > 3 && strYearNts.substring(0, 4).compareTo("2023") == 1) { %>
					<tr id="deClDivK">
						<th>K 레코드수</th>
						<td>
							<input type="text" id="cntK" name="cntK" class="text right readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
					<% } %>
					
					<tr id="deClDiv6">
						<th id="deClDiv6Txt">총급여(전+현)</th>
						<td>
							<input type="text" id="sumPay" name="sumPay" class="text right readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
					<tr id="deClDiv7">
						<th>비과세계(전+현)</th>
						<td>
							<input type="text" id="sumNoTax" name="sumNoTax" class="text right readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
					<!-- 감면소득계 추가(2021.11) -->
                    <tr id="deClDiv9">
                        <th>감면소득계(전+현)</th>
                        <td>
                            <input type="text" id="sumExTax" name="sumExTax" class="text right readonly" value="" style="width:150px" readonly />
                        </td>
                    </tr>
					<tr id="deClDiv8">
						<th>결정소득세</th>
						<td>
							<input type="text" id="incomeTax" name="incomeTax" class="text right readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
				</table>
			</td>
			<td>
			</td>
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="30%" />
						<col width="70%" />
					</colgroup>
					<tr>
						<td colspan="2" class="center">
							<a href="javascript:preOnCreateSpecClick(2);" class="basic btn-red ico-fileLine authA">의료비명세생성</a>
						</td>
					</tr>
					<tr>
						<th>파일명</th>
						<td>
							<input type="text" id="resultFileMedical" name="resultFileMedical" class="text readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
					<tr>
						<th>레코드수</th>
						<td>
							<input type="text" id="cntMedical" name="cntMedical" class="text right readonly" value="" style="width:150px" readonly />
							<%-- <img alt="" src="${ctx}/common/images/icon/icon_popup.png" onclick="recordDetailPopup('A1');"> --%>
						</td>
					</tr>
					<tr>
						<th>총금액</th>
						<td>
							<input type="text" id="amtMedical" name="amtMedical" class="text right readonly" value="" style="width:150px" readonly />
							<a href="javascript:openCalcPopup(2);" class="basic ico-popup authA" id="btnMed">의료비내역</a>
						</td>
					</tr>
				</table>
				<span id="btnDisplayYn">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<tr>
						<td colspan="2" class="center">
							<a href="javascript:preOnCreateSpecClick(4);" class="basic btn-red ico-fileLine authA">우리사주배당비과세생성</a>
						</td>
					</tr>
					<tr>
						<th>파일명</th>
						<td>
							<input type="text" id="resultFileEmpStockcal" name="resultFileEmpStockcal" class="text readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
					<tr>
						<th>A레코드수</th>
						<td>
							<input type="text" id="cntEmpStockAcal" name="cntEmpStockAcal" class="text right readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
					<tr>
						<th>B레코드수</th>
						<td>
							<input type="text" id="cntEmpStockBcal" name="cntEmpStockBcal" class="text right readonly" value="" style="width:150px" readonly />
						</td>
					</tr>
				</table>
				</span>
<!-- 				<table border="0" cellpadding="0" cellspacing="0" class="default"> -->
<!-- 					<colgroup> -->
<!-- 						<col width="30%" /> -->
<!-- 						<col width="70%" /> -->
<!-- 					</colgroup> -->
<!-- 					<tr> -->
<!-- 						<td colspan="2" class="center"> -->
<!-- 							<a href="javascript:onCreateSpecClick(3);" class="basic authA">기부금명세생성</a> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th>파일명</th> -->
<!-- 						<td> -->
<!-- 							<input type="text" id="resultFileDonation" name="resultFileDonation" class="text readonly" value="" style="width:150px" readonly /> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th>A 레코드수</th> -->
<!-- 						<td> <input type="text" id="cntDonationA" name="cntDonationA" class="text right readonly" value="" style="width:150px" readonly /> </td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th>B 레코드수</th> -->
<!-- 						<td> -->
<!-- 							<input type="text" id="cntDonationB" name="cntDonationB" class="text right readonly" value="" style="width:150px" readonly /> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th>C 레코드수</th> -->
<!-- 						<td> -->
<!-- 							<input type="text" id="cntDonationC" name="cntDonationC" class="text right readonly" value="" style="width:150px" readonly /> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th>D 레코드수</th> -->
<!-- 						<td> -->
<!-- 							<input type="text" id="cntDonationD" name="cntDonationD" class="text right readonly" value="" style="width:150px" readonly /> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th>기부금총액</th> -->
<!-- 						<td> -->
<!-- 							<input type="text" id="totDonationMon" name="totDonationMon" class="text right readonly" value="" style="width:150px" readonly /> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 					<tr> -->
<!-- 						<th>공제금액총액</th> -->
<!-- 						<td> -->
<!-- 							<input type="text" id="totDedMon" name="totDedMon" class="text right readonly" value="" style="width:150px" readonly /> -->
<!-- 						</td> -->
<!-- 					</tr> -->
<!-- 				</table> -->
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