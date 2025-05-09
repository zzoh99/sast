<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>교육이력관리 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");
var arg = p.popDialogArgumentAll();
var authPg	= arg["authPg"];
var sheet1	= p.popDialogSheet(arg["sheet1"]);
var Row		= arg["Row"];
var gPRow = "";
var pGubun = "";

$(function(){
	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
	/*
	$("#eduBranchCd").bind("change", function() {
		$("#eduMBranchCd").html("");

		if ( $("#eduBranchCd").val() == "" ) return;

		var eduMBranchCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"
				,"queryId=getComCodeNoteList&searchGrcodeCd=L10015&searchUseYn=Y&searchNote1="+$("#eduBranchCd").val(),false).codeList, " ");

		if ( !eduMBranchCdList ) $("#eduMBranchCd").html("");
		else $("#eduMBranchCd").html(eduMBranchCdList[2]);
	});
	*/
	var eduMethodCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10050"), " "); /* 시행방법 */
	var inOutTypeList 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L20020"), " "); /* 사내외구분 */
	var eduBranchCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10010"), " "); /* 교육구분 */

	var currencyCdList 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S10030"), " "); //통화단위
	var eduRewardCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10110"), " "); //보상내역

	$("#eduMethodCd").html(eduMethodCdList[2]);
	$("#inOutType").html(inOutTypeList[2]);
	$("#eduBranchCd").html(eduBranchCdList[2]);
	$("#currencyCd").html(currencyCdList[2]);
	$("#eduRewardCd").html(eduRewardCdList[2]);

	// 최대길이
	$("#unconfirmReason").maxbyte(1000);

	//금액
	$('#perExpenseMon').mask('000,000,000,000,000', {reverse: true});
	$('#laborMon').mask('000,000,000,000,000', {reverse: true});

	// 숫자만 입력가능
	$("#eduHour, #eduAppPoint").keyup(function() {
		makeNumber(this,'A');
	});

	// 달력
	$("#eduSYmd").datepicker2({startdate:"eduEYmd"});
	$("#eduEYmd").datepicker2({enddate:"eduSYmd"});
});

$(function(){
	$("#eduSeq").val( sheet1.GetCellValue(Row, "eduSeq") );
	$("#eduCourseNm").val( sheet1.GetCellValue(Row, "eduCourseNm") );
	$("#eduEventSeq").val( sheet1.GetCellValue(Row, "eduEventSeq") );
	$("#eduEventSub").val( sheet1.GetCellValue(Row, "eduEventSub") );
	$("#eduEventNm").val( sheet1.GetCellValue(Row, "eduEventNm") );
	$("#eduOrgCd").val( sheet1.GetCellValue(Row, "eduOrgCd") );
	$("#eduOrgNm").val( sheet1.GetCellValue(Row, "eduOrgNm") );
	$("#eduBranchCd").val( sheet1.GetCellValue(Row, "eduBranchCd") ); //$("#eduBranchCd").change();
	$("#eduMBranchCd").val( sheet1.GetCellValue(Row, "eduMBranchCd") );
	$("#searchEduMBranchNm").val( sheet1.GetCellValue(Row, "eduMBranchNm") );
	$("#eduMethodCd").val( sheet1.GetCellValue(Row, "eduMethodCd") );
	$("#eduPlaceEtc").val( sheet1.GetCellValue(Row, "eduPlaceEtc") );
	$("#eduPlace").val( sheet1.GetCellValue(Row, "eduPlace") );
	$("#inOutType").val( sheet1.GetCellValue(Row, "inOutType") );
	$("#mandatoryYn").val( sheet1.GetCellValue(Row, "mandatoryYn") );
	$("#eduSYmd").val( sheet1.GetCellText(Row, "eduSYmd") );
	$("#eduEYmd").val( sheet1.GetCellText(Row, "eduEYmd") );
	$("#eduHour").val( sheet1.GetCellValue(Row, "eduHour") );
	$("#currencyCd").val( sheet1.GetCellValue(Row, "currencyCd") );
	$("#perExpenseMon").val( sheet1.GetCellValue(Row, "perExpenseMon") );
	$("#laborApplyYn").val( sheet1.GetCellValue(Row, "laborApplyYn") );
	$("#laborMon").val( sheet1.GetCellValue(Row, "laborMon") );
	$("#eduRewardCd").val( sheet1.GetCellValue(Row, "eduRewardCd") );
	$("#eduRewardCnt").val( sheet1.GetCellValue(Row, "eduRewardCnt") );
	$("#name").val( sheet1.GetCellValue(Row, "name") );
	$("#sabun").val( sheet1.GetCellValue(Row, "sabun") );
	$("#orgNm").val( sheet1.GetCellValue(Row, "orgNm") );
	$("#jikweeNm").val( sheet1.GetCellValue(Row, "jikgubNm") );
	$("#eduConfirmType").val( sheet1.GetCellValue(Row, "eduConfirmType") );
	$("#eduAppPoint").val( sheet1.GetCellValue(Row, "eduAppPoint") );
	$("#unconfirmReason").val( sheet1.GetCellValue(Row, "unconfirmReason") );

});

function doOk() {
	if ( $("#eduAppPoint").val() > "100" ) {
		alert("<msg:txt mid='alertEduHistoyLst1' mdef='교육평가점수는 100점을 넘을 수 없습니다.'/>");
		return;
	}

	//sheet1.SetCellValue(Row, "eduSeq", $("#eduSeq").val() );
	sheet1.SetCellValue(Row, "eduCourseNm", $("#eduCourseNm").val() );
	//sheet1.SetCellValue(Row, "eduEventSeq", $("#eduEventSeq").val() );
	//sheet1.SetCellValue(Row, "eduEventSub", $("#eduEventSub").val() );
	sheet1.SetCellValue(Row, "eduEventNm", $("#eduEventNm").val() );
	sheet1.SetCellValue(Row, "eduOrgCd", $("#eduOrgCd").val() );
	sheet1.SetCellValue(Row, "eduOrgNm", $("#eduOrgNm").val() );
	sheet1.SetCellValue(Row, "eduBranchCd", $("#eduBranchCd").val() );
	sheet1.SetCellValue(Row, "eduMBranchCd", $("#eduMBranchCd").val() );
	sheet1.SetCellValue(Row, "eduMBranchNm", $("#searchEduMBranchNm").val() );

	sheet1.SetCellValue(Row, "eduMethodCd", $("#eduMethodCd").val() );
	sheet1.SetCellValue(Row, "eduPlaceEtc", $("#eduPlaceEtc").val() );
	sheet1.SetCellValue(Row, "eduPlace", $("#eduPlace").val() );
	sheet1.SetCellValue(Row, "inOutType", $("#inOutType").val() );
	sheet1.SetCellValue(Row, "mandatoryYn", $("#mandatoryYn").val() );

	sheet1.SetCellValue(Row, "eduSYmd", $("#eduSYmd").val() );
	sheet1.SetCellValue(Row, "eduEYmd", $("#eduEYmd").val() );
	sheet1.SetCellValue(Row, "eduHour", $("#eduHour").val() );

	sheet1.SetCellValue(Row, "currencyCd", $("#currencyCd").val() );
	sheet1.SetCellValue(Row, "perExpenseMon", $("#perExpenseMon").val() );
	sheet1.SetCellValue(Row, "laborApplyYn", $("#laborApplyYn").val() );
	sheet1.SetCellValue(Row, "laborMon", $("#laborMon").val() );

	sheet1.SetCellValue(Row, "eduRewardCd", $("#eduRewardCd").val() );
	sheet1.SetCellValue(Row, "eduRewardCnt", $("#eduRewardCnt").val() );

	sheet1.SetCellValue(Row, "name", $("#name").val() );
	sheet1.SetCellValue(Row, "sabun", $("#sabun").val() );
	//sheet1.SetCellValue(Row, "orgNm", $("#orgNm").val() );
	//sheet1.SetCellValue(Row, "jikweeNm", $("#jikweeNm").val() );

	sheet1.SetCellValue(Row, "eduConfirmType", $("#eduConfirmType").val() );
	sheet1.SetCellValue(Row, "eduAppPoint", $("#eduAppPoint").val() );
	sheet1.SetCellValue(Row, "unconfirmReason", $("#unconfirmReason").val() );

	var rv = new Array();

	p.popReturnValue(rv);
	p.window.close();
}

function openEduOrg() {
	if(!isPopup()) {return;}

	gPRow = "";
	pGubun = "eduOrgPopup";

	openPopup("${ctx}/Popup.do?cmd=eduOrgPopup&authPg=R", "", "550","520");
}

function openEmployee() {
	if(!isPopup()) {return;}

	gPRow = "";
	pGubun = "employeePopup";

	openPopup("${ctx}/Popup.do?cmd=employeePopup&authPg=R", "", "840","520");
}

function doSearchEduMBranchNm() {
	if(!isPopup()) {return;}

	gPRow = "";
	pGubun = "eduMBranchPopup";

	openPopup("/Popup.do?cmd=eduMBranchPopup&authPg=R", "", "550","520");
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "eduOrgPopup"){
    	$("#eduOrgNm").val(rv["eduOrgNm"]);
    	$("#eduOrgCd").val(rv["eduOrgCd"]);
    } else if(pGubun == "employeePopup") {
        $("#name").val( rv["name"] ) ;
        $("#sabun").val( rv["sabun"] ) ;
        $("#orgNm").val( rv["orgNm"] ) ;
        $("#jikweeNm").val( rv["jikgubNm"] ) ;
    } else if(pGubun == "eduMBranchPopup") {
    	$("#searchEduMBranchNm").val(rv["eduMBranchNm"]);
    	$("#eduMBranchCd").val(rv["eduMBranchCd"]);
    }
}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='eduHistoryLstPop' mdef='교육이력관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='eduEventMgrPopV1' mdef='교육과정 기본내역'/></li>
			</ul>
		</div>
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="15%" />

				<col width="15%" />
				<col width="15%" />

				<col width="15%" />
				<col width="15%" />

				<col width="15%" />
				<col width="15%" />
			</colgroup>
			<tr>
				<th><tit:txt mid='104168' mdef='과정명'/></th>
				<td colspan="5">
					<input type="hidden" id="eduSeq" name="eduSeq" />
					<input id="eduCourseNm" name="eduCourseNm" type="text" class="text w100p" />
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104070' mdef='회차명'/></th>
				<td colspan="5">
					<input id="eduEventSeq" name="eduEventSeq" type="hidden"/>
					<input id="eduEventSub" name="eduEventSub" type="hidden"/>
					<input id="eduEventNm" name="eduEventNm" type="text" class="text w100p" />
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='eduOrgPopV1' mdef='교육기관'/></th>
				<td colspan="5">
					<input id="eduOrgCd" name="eduOrgCd" type="hidden"/>
					<input id="eduOrgNm" name="eduOrgNm" type="text" class="text w90p readonly" readonly />
					<a href="javascript:openEduOrg();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104566' mdef='교육구분'/></th>
				<td>
					<select id="eduBranchCd" name="eduBranchCd" class="w100p">
					</select>
				</td>
				<th><tit:txt mid='eduMBranchPopV1' mdef='교육분류'/></th>
				<td><input type="hidden" id="eduMBranchCd" name="eduMBranchCd">
					<input id="searchEduMBranchNm" name="searchEduMBranchNm" type="text" class="text w60" />
					<a href="javascript:doSearchEduMBranchNm();" class="button6">
						<img src="/common/${theme}/images/btn_search2.gif"/>
					</a>
				</td>
				<th><tit:txt mid='112703' mdef='시행방법'/></th>
				<td>
					<select id="eduMethodCd" name="eduMethodCd" class="w100p">
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104078' mdef='교육장소'/></th>
				<td>
					<input id="eduPlaceEtc" name="eduPlaceEtc" type="hidden"/>
					<input id="eduPlace" name="eduPlace" type="text" class="text w100p" />
				</td>
				<th><tit:txt mid='103997' mdef='구분'/></th>
				<td>
					<select id="inOutType" name="inOutType">
					</select>
				</td>
				<th><tit:txt mid='201705040000019' mdef='필수여부'/></th>
				<td>
					<select id="mandatoryYn" name="mandatoryYn">
						<option value="Y">YES</option>
						<option value="N">NO</option>
					</select>
				</td>
			</tr>
		</table>
		<table width=100%>
			<colgroup>
				<col width="39%" />
				<col width="5px" />
				<col width="%" />
			</colgroup>
			<tr>
				<td>
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='eduEventMgrPopV2' mdef='교육기간'/></li>
						</ul>
					</div>
					<table class="table">
						<colgroup>
							<col width="20%" />
							<col width="%" />
						</colgroup>
						<tr>
							<th><tit:txt mid='104497' mdef='시작일'/></th>
							<td>
								<input type="text" id="eduSYmd" name="eduSYmd" class="date2"/>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='111909' mdef='종료일'/></th>
							<td>
								<input type="text" id="eduEYmd" name="eduEYmd" class="date2"/>
								<input type="text" id="eduHour" name="eduHour" class="text w50 center"/>시간
							</td>
						</tr>
					</table>
				</td>
				<td></td>
				<td>
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='eduAppDetOutSideV3' mdef='교육비용'/></li>
						</ul>
					</div>
					<table class="table">
						<colgroup>
							<col width="25%" />
							<col width="25%" />
							<col width="20%" />
							<col width="%" />
						</colgroup>
						<tr>
							<th><tit:txt mid='114146' mdef='통화'/></th>
							<td>
								<select id="currencyCd" name="currencyCd">
								</select>
							</td>
							<th><tit:txt mid='titPerPerson' mdef='인당교육비'/></th>
							<td>
								<input type="text" id="perExpenseMon" name="perExpenseMon" class="text w100p right"/>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='114516' mdef='고용보험적용'/></th>
							<td>
								<select id="laborApplyYn" name="laborApplyYn">
									<option value="Y" selected>YES</option>
									<option value="N">NO</option>
								</select>
							</td>
							<th><tit:txt mid='114147' mdef='환급금액'/></th>
							<td>
								<input type="text" id="laborMon" name="laborMon" class="text w100p right"/>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td>
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='eduEventMgrPopV8' mdef='보상'/></li>
						</ul>
					</div>
					<table class="table">
						<colgroup>
							<col width="20%" />
							<col width="%" />
						</colgroup>
						<tr>
							<th><tit:txt mid='113921' mdef='종류'/></th>
							<td>
								<select id="eduRewardCd" name="eduRewardCd">
								</select>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='titRewardDetails' mdef='내역'/></th>
							<td>
								<input type="text" id="eduRewardCnt" name="eduRewardCnt" class="text w100p"/>
							</td>
						</tr>
					</table>
				</td>
				<td></td>
				<td>
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='eduHistoryLstPopV5' mdef='수강자 정보'/></li>
						</ul>
					</div>
					<table class="table">
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="%" />
						</colgroup>
						<tr>
							<th><tit:txt mid='103880' mdef='성명'/></th>
							<td>
								<input type="text" id="name" name="name" class="text readonly w90" readonly />
								 <a href="javascript:openEmployee();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							</td>
							<th><tit:txt mid='103975' mdef='사번'/></th>
							<td>
								<input type="text" id="sabun" name="sabun" class="text w100p readonly " readonly/>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='104279' mdef='소속'/></th>
							<td>
								<input type="text" id="orgNm" name="orgNm" class="text w100p readonly " readonly />
							</td>
							<th><tit:txt mid='104471' mdef='직급'/></th>
							<td>
								<input type="text" id="jikweeNm" name="jikweeNm" class="text w100p readonly " readonly />
							</td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt"><tit:txt mid='eduHistoryLstPopV6' mdef='교육인정'/></li>
			</ul>
		</div>
		<table class="table">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="%" />
			</colgroup>
			<tr>
				<th>교육수료구분</th>
				<td>
					<select id="eduConfirmType" name="eduConfirmType">
						<option value="" selected> </option>
						<option value="1" >수료</option>
						<option value="0" >미수료</option>
						<option value="2" >미입과</option>
					</select>
				</td>
				<th>교육평가점수</th>
				<td>
					<input type="text" id="eduAppPoint" name="eduAppPoint" class="text w100p right"/>
				</td>
			</tr>
			<tr>
				<th>미수료사유</th>
				<td colspan=3>
					<textarea id="unconfirmReason" name="unconfirmReason" class="text w100p" rows=2></textarea>
				</td>
			</tr>
		</table>

		<div class="popup_button">
			<ul>
				<li>
					<a href="javascript:doOk();" class="pink large authA"><tit:txt mid='104435' mdef='확인'/></a>
					<a href="javascript:p.self.close();" class="gray large authR"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
