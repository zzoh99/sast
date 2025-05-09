<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>일용소득지급조서생성</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<!--
 * 일용소득지급조서생성
 * @author JM
-->
<script type="text/javascript">
$(function() {
	//------------------------------------- 조회조건 콤보 -------------------------------------//
	// 사업장(TORG109)
	var tcpn121Cd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getTorg109List"), "전체");
	$("#businessPlaceCd").html(tcpn121Cd[2]);

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#sendYmd").datepicker2();

	$("#belongYy").bind("keyup",function(event) {
		makeNumber(this, 'A');
	});

	$("#belongYy").val("<%=curSysYear%>");	
	
	//2021.07.12 신고시기
	workPartSet();
});

// 필수값/유효성 체크
function chkInVal(sAction) {
	if ($("#belongYy").val() == "") {
		alert("대상년도를 입력하십시오.");
		$("#belongYy").focus();
		return false;
	}
	if ($("#sendYmd").val() == "") {
		alert("제출일자를 선택하십시오.");
		$("#sendYmd").focus();
		return false;
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "PrcPKG_CPN_DAYTAX_DISK_2010":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			if (confirm("일용소득지급조서 파일을 생성하시겠습니까?")) {

				doAction1("Clear");

				$("#filePrefix").val("I");

				// 일용소득지급조서생성
				var result = ajaxCall("<%=jspPath%>/dayIncomeTaxCre/dayIncomeTaxCreRst.jsp?cmd=PrcPKG_CPN_DAYTAX_DISK_2010", $("#sheet1Form").serialize()					
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
							}
		 				}
				);
			}
			break;

		case "Clear":
			$("#filePrefix").val("");
			$("#fileDataType").val("");
			$("#recodeCntA").val("");
			$("#recodeCntB").val("");
			$("#recodeCntC").val("");
			break;
	}
}


function callbackResult(filePrefix, data) {
	if(data == null) {
		alert("일용소득지급조서생성 오류입니다.");
		return;
	}
	// 일용소득지급조서 생성 완료후 데이타 display
	$("#recodeCntA").val(data.recodeCntA);
	$("#recodeCntB").val(data.recodeCntB);
	$("#recodeCntC").val(data.recodeCntC);
}

function ntsFileDownload(fileName) {
	if(fileName != "") {
		$("iframe").attr("src","<%=jspPath%>/dayIncomeTaxCre/dayIncomeTaxFileDownload.jsp?fileName="+fileName+"&ssnEnterCd=<%=session.getAttribute("ssnEnterCd")%>");
	}
}
//2021.07.12 (지급분기)
function workPartSet(){
       if($("#belongYy").val() == "2021"){
             $("#workPartGubun").val("2");
             $('#termCd').empty();
             $('#termCd').append("<option value='1'>1/4분기(1월~3월)</option>");
             $('#termCd').append("<option value='2'>2/4분기(4월~6월)</option>");
             $('#termCd').append("<option value='07'>7월</option>");
             $('#termCd').append("<option value='08'>8월</option>");
             $('#termCd').append("<option value='09'>9월</option>");
             $('#termCd').append("<option value='10'>10월</option>");
             $('#termCd').append("<option value='11'>11월</option>");
             $('#termCd').append("<option value='12'>12월</option>");
        }else if($("#belongYy").val() > "2021"){
            $("#workPartGubun").val("1");
            $('#termCd').empty();
            $('#termCd').append("<option value='01'>1월</option>");
            $('#termCd').append("<option value='02'>2월</option>");
            $('#termCd').append("<option value='03'>3월</option>");
            $('#termCd').append("<option value='04'>4월</option>");
            $('#termCd').append("<option value='05'>5월</option>");
            $('#termCd').append("<option value='06'>6월</option>");        
            $('#termCd').append("<option value='07'>7월</option>");
            $('#termCd').append("<option value='08'>8월</option>");
            $('#termCd').append("<option value='09'>9월</option>");
            $('#termCd').append("<option value='10'>10월</option>");
            $('#termCd').append("<option value='11'>11월</option>");
            $('#termCd').append("<option value='12'>12월</option>");
        }else{
            $("#workPartGubun").val("3");
            $('#termCd').empty();
            $('#termCd').append("<option value='1'>1/4분기(1월~3월)</option>");
            $('#termCd').append("<option value='2'>2/4분기(4월~6월)</option>");
            $('#termCd').append("<option value='3'>3/4분기(7월~9월)</option>");
            $('#termCd').append("<option value='4'>4/4분기(10월~12월)</option>");
        }   
}
</script>
</head>
<body class="hidden">
<div class="wrapper" id="tableDiv" style="overflow:auto;overflow-x:hidden;border:0px;margin-bottom:0px">
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="filePrefix" name="filePrefix">
	<input type="hidden" id="fileDataType" name="fileDataType">
	<input type="hidden" id="earnerCd" name="earnerCd" value="1">
	<input type="hidden" id="workPartGubun" name="workPartGubun">
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="1%" />
			<col width="49%" />
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
						<td> <input type="text" id="belongYy" name="belongYy" class="text required" maxlength="4" value="" style="width:40px" onchange="workPartSet();" /> </td>
					</tr>
					<tr>
						<th>신고시기</th>
						<td> 
							 <select id="termCd" name="termCd">
								<option value="1">1/4분기(1월~3월)</option>
								<option value="2">2/4분기(4월~6월)</option>
								<option value="3">3/4분기(7월~9월)</option>
								<option value="4">4/4분기(10월~12월)</option>
								<option value="5">폐업에 의한 수시 제출분</option>
							 </select>
						</td>
					<tr>
						<th>사업장</th>
						<td> <select id="businessPlaceCd" name="businessPlaceCd"> </select> </td>
					</tr>
					<tr>
						<th>제출일자</th>
						<td> <input type="text" id="sendYmd" name="sendYmd" class="text date2 required" value="" /> (예: 2005-01-20)  </td>
					</tr>
					<tr>
						<th>홈택스ID</th>
						<td> <input type="text" id="hometaxId" name="hometaxId" class="text" value="" style="width:150px" /> </td>
					</tr>
					<tr>
						<th>세무서코드</th>
						<td> <input type="text" id="taxNo" name="taxNo" class="text" value="" style="width:150px" /> </td>
					</tr>
					<tr>
						<th>이메일</th>
						<td> <input type="text" id="email" name="email" class="text" value="" style="width:150px" /> </td>
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
						<td> <select id="sendType" name="sendType">
								<option value="1">세무대리인
								<option value="2" selected >법인
								<option value="3">개인
							 </select>
						</td>
					</tr>
					<tr>
						<th>세무대리인번호</th>
						<td> <input type="text" id="taxNumber" name="taxNumber" class="text" value="" style="width:150px" /> </td>
					<tr>
						<th>담당소속</th>
						<td> <input type="text" id="orgNm" name="orgNm" class="text" value="" style="width:150px" /> </td>
					</tr>
					<tr>
						<th>담당자성명</th>
						<td> <input type="text" id="name" name="name" class="text" value="" style="width:150px" /> </td>
					</tr>
					<tr>
						<th>전화번호</th>
						<td> <input type="text" id="telNumber" name="telNumber" class="text" value="" style="width:150px" /> </td>
					</tr>
					<tr>
						<td colspan="2"> <a href="javascript:doAction1('PrcPKG_CPN_DAYTAX_DISK_2010')" class="basic authA">지급조서생성</a> </td>
					</tr>
				</table>
			</td>
		</tr>
		<tr style="display:none">
			<td class="top">
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="30%" />
						<col width="70%" />
					</colgroup>
					<tr>
						<th>A 레코드수</th>
						<td> <input type="text" id="recodeCntA" name="recodeCntA" class="text right readonly" value="" style="width:150px" readonly /> </td>
					</tr>
					<tr>
						<th>B 레코드수</th>
						<td> <input type="text" id="recodeCntB" name="recodeCntB" class="text right readonly" value="" style="width:150px" readonly /> </td>
					</tr>
					<tr>
						<th>C 레코드수</th>
						<td> <input type="text" id="recodeCntC" name="recodeCntC" class="text right readonly" value="" style="width:150px" readonly /> </td>
					</tr>
				</table>
			</td>
			<td>
			</td>
			<td>
			</td>
		</tr>		
		<tr>
			<td colspan="3"></td>
		</tr>

	</table>
	</form>
</div>
<iframe src="" frameborder="0" scrolling="no" width="0" height="0" style="display:none"></iframe>
</body>
</html>