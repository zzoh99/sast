<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>교육과정관리 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	$(function() {
		$('#maxPerson').mask('000,000,000,000,000', {
			reverse : true
		});
		$('#eduBudget').mask('000,000,000,000,000', {
			reverse : true
		});
		$('#eduRewardCnt').mask('000,000,000,000,000', {
			reverse : true
		});

		var eduBranchCd = convCode(codeList(
				"${ctx}/CommonCode.do?cmd=getCommonCodeList", "L10010"), " "); //교육체계구분 res2
		var eduMethodCd = convCode(codeList(
				"${ctx}/CommonCode.do?cmd=getCommonCodeList", "L10050"), ""); //시행방법
		var eduStatusCd = convCode(codeList(
				"${ctx}/CommonCode.do?cmd=getCommonCodeList", "L10170"), ""); //과정상태 res1
		var eduRewardCd = convCode(codeList(
				"${ctx}/CommonCode.do?cmd=getCommonCodeList", "L10110"), ""); //보상종류
		var foreignCd = convCode(codeList(
				"${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20300"), ""); //진행언어
		var eduUnitCd = convCode(codeList(
				"${ctx}/CommonCode.do?cmd=getCommonCodeList", "L10020"), ""); //교육기간단위
		var inOutType = convCode(codeList(
				"${ctx}/CommonCode.do?cmd=getCommonCodeList", "L20020"), ""); //사내외구분
		var mandatoryYn = convCode(codeList(
				"${ctx}/CommonCode.do?cmd=getCommonCodeList", "L20030"), ""); //필수여부   res3

		$("#eduBranchCd").html(eduBranchCd[2]);
		$("#eduMethodCd").html(eduMethodCd[2]);
		$("#eduStatusCd").html(eduStatusCd[2]);
		$("#eduRewardCd").html(eduRewardCd[2]);
		$("#foreignCd").html(foreignCd[2]).val("AO"); // Default 한국어
		$("#eduUnitCd").html(eduUnitCd[2]);
		$("#eduUnitCd").val("3");
		$("#inOutType").html(inOutType[2]);
		$("#mandatoryYn").html(mandatoryYn[2]);

		var arg = p.popDialogArgumentAll();
		var fiYear = arg["fiYear"];
		var eduSeq = arg["eduSeq"];
		var eduMBranchCd = arg["eduMBranchCd"];
		var eduMBranchNm = arg["eduMBranchNm"];
		var eduCourseNm = arg["eduCourseNm"];
		var eduOrgCd = arg["eduOrgCd"];
		var eduOrgNm = arg["eduOrgNm"];
		var eduTarget = arg["eduTarget"];
		var eduCourseSub = arg["eduCourseSub"];
		var eduStatusCd = arg["eduStatusCd"];
		var inOutType = arg["inOutType"];
		var eduMethodCd = arg["eduMethodCd"];
		var eduBranchCd = arg["eduBranchCd"];
		var eduTerm = arg["eduTerm"];
		var eduUnitCd = arg["eduUnitCd"];
		var eduHour = arg["eduHour"];
		var eduSYmd = arg["eduSYmd"];
		var eduEYmd = arg["eduEYmd"];
		var minPerson = arg["minPerson"];
		var maxPerson = arg["maxPerson"];
		var mandatoryYn = arg["mandatoryYn"];
		var foreignCd = arg["foreignCd"];
		var payYn = arg["payYn"];
		var genCredit = arg["genCredit"];
		var wmCredit = arg["wmCredit"];
		var eduRewardCd = arg["eduRewardCd"];
		var eduRewardCnt = arg["eduRewardCnt"];
		var chargeSabun = arg["chargeSabun"];
		var chargeName = arg["chargeName"];
		var orgCd = arg["orgCd"];
		var orgNm = arg["orgNm"];
		//var chargeTel  			= arg["chargeTel"];
		var eduBudget = arg["eduBudget"];
		var eduMemo = arg["eduMemo"];
		var eduCourseGoal = arg["eduCourseGoal"];
		var eduCourseThema = arg["eduCourseThema"];
		var finishCondition = arg["finishCondition"];
		var cnt = arg["cnt"];

		$("#fiYear").val(fiYear);
		$("#eduSeq").val(eduSeq);
		$("#eduCourseNm").val(eduCourseNm);
		$("#eduOrgCd").val(eduOrgCd);
		$("#eduOrgNm").val(eduOrgNm);
		$("#eduTarget").val(eduTarget);
		$("#eduCourseSub").val(eduCourseSub);
		$("#eduStatusCd").val(eduStatusCd);
		$("#inOutType").val(inOutType);
		$("#eduMethodCd").val(eduMethodCd);
		$("#eduBranchCd").val(eduBranchCd);
		//$("#eduBranchCd").change();
		$("#eduMBranchCd").val(eduMBranchCd);
		$("#searchEduMBranchNm").val(eduMBranchNm);
		$("#eduTerm").val(eduTerm)
		$("#eduUnitCd").val(eduUnitCd);
		$("#eduHour").val(eduHour);
		$("#eduSYmd").val(eduSYmd);
		$("#eduEYmd").val(eduEYmd);
		$("#minPerson").val(minPerson);
		$("#maxPerson").val(addComma(maxPerson));
		$("#mandatoryYn").val(mandatoryYn);
		if (foreignCd != "") {
			$("#foreignCd").val(foreignCd);
		}
		$("#payYn").val(payYn);
		$("#genCredit").val(genCredit);
		$("#wmCredit").val(wmCredit);
		$("#eduRewardCd").val(eduRewardCd);
		$("#eduRewardCnt").val(addComma(eduRewardCnt));
		$("#chargeSabun").val(chargeSabun)
		$("#chargeName").val(chargeName);
		$("#orgCd").val(orgCd);
		$("#orgNm").val(orgNm);
		//$("#chargeTel").val(chargeTel);
		$("#eduBudget").val(addComma(eduBudget));
		$("#eduMemo").val(eduMemo);
		$("#eduCourseGoal").val(eduCourseGoal);
		$("#eduCourseThema").val(eduCourseThema);
		$("#finishCondition").val(finishCondition);
		$("#cnt").val(cnt);

		// 숫자만 입력
		/*
		$("#orderSeq").keyup(function() {
		     makeNumber(this,'A') ;
		 });
		 */

		/*date picker*/
		$("#eduSYmd").datepicker2({
			startdate : "eduEYmd"
		});
		$("#eduEYmd").datepicker2({
			enddate : "eduSYmd"
		});
		//Cancel 버튼 처리
		$(".close").click(function() {
			p.self.close();
		});
	});

	function setValue() {
		var rv = new Array();
		rv["fiYear"] = $("#fiYear").val();
		rv["eduSeq"] = $("#eduSeq").val();
		rv["eduMBranchCd"] = $("#eduMBranchCd").val();
		rv["eduMBranchNm"] = $("#searchEduMBranchNm").val();
		rv["eduCourseNm"] = $("#eduCourseNm").val();
		rv["eduOrgCd"] = $("#eduOrgCd").val();
		rv["eduOrgNm"] = $("#eduOrgNm").val();
		rv["eduTarget"] = $("#eduTarget").val();
		rv["eduCourseSub"] = $("#eduCourseSub").val();
		rv["eduStatusCd"] = $("#eduStatusCd").val();
		rv["inOutType"] = $("#inOutType").val();
		rv["eduMethodCd"] = $("#eduMethodCd").val();
		rv["eduBranchCd"] = $("#eduBranchCd").val();
		rv["eduTerm"] = $("#eduTerm").val();
		rv["eduUnitCd"] = $("#eduUnitCd").val();
		rv["eduHour"] = $("#eduHour").val();
		rv["eduSYmd"] = $("#eduSYmd").val();
		rv["eduEYmd"] = $("#eduEYmd").val();
		rv["minPerson"] = $("#minPerson").val();
		rv["maxPerson"] = $("#maxPerson").val();
		rv["mandatoryYn"] = $("#mandatoryYn").val();
		rv["foreignCd"] = $("#foreignCd").val();
		rv["payYn"] = $("#payYn").val();
		rv["genCredit"] = $("#genCredit").val();
		rv["wmCredit"] = $("#wmCredit").val();
		rv["eduRewardCd"] = $("#eduRewardCd").val();
		rv["eduRewardCnt"] = $("#eduRewardCnt").val();
		rv["chargeSabun"] = $("#chargeSabun").val();
		rv["chargeName"] = $("#chargeName").val();
		rv["orgCd"] = $("#orgCd").val();
		rv["orgNm"] = $("#orgNm").val();
		//rv["chargeTel"]         = $("#chargeTel").val() ;
		rv["eduBudget"] = $("#eduBudget").val();
		rv["eduMemo"] = $("#eduMemo").val();
		rv["eduCourseGoal"] = $("#eduCourseGoal").val();
		rv["eduCourseThema"] = $("#eduCourseThema").val();
		rv["finishCondition"] = $("#finishCondition").val();
		rv["cnt"] = $("#cnt").val();
		//var temp = "N" ;
		//$("#mainEduOrgYn").is(":checked") == true ? temp = "Y" : temp = "N" ;
		//	rv["mainEduOrgYn"]    = temp ;

		p.popReturnValue(rv);
		p.window.close();
	}

	function doSearchEduOrgNm() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "eduOrgPopup";

		openPopup("/Popup.do?cmd=eduOrgPopup&authPg=R", "", "650", "520");
	}
	function addComma(n) {
		if (isNaN(n)) {
			return 0;
		}
		var reg = /(^[+-]?\d+)(\d{3})/;
		n += '';
		while (reg.test(n))
			n = n.replace(reg, '$1' + ',' + '$2');
		return n;
	}
	//임직원 찾기 팝업
	function findEmpPopup() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "employeePopup";

		var args = new Array();
		args["topKeyword"] = $("#chargeName").val();
		openPopup("/Popup.do?cmd=employeePopup&authPg=R", args, "840", "520");
	}

	function orgSearchPopup() {
		try {
			if (!isPopup()) {
				return;
			}

			var args = new Array();
			gPRow = "";
			pGubun = "orgBasicPopup";

			openPopup("${ctx}/Popup.do?cmd=orgBasicPopup", args, "740", "520");
		} catch (ex) {
			alert("Open Popup Event Error : " + ex);
		}
	}

	function doSearchEduMBranchNm() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "eduMBranchPopup";

		openPopup("/Popup.do?cmd=eduMBranchPopup&authPg=R", "", "650", "520");
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue + '}');

		if (pGubun == "eduOrgPopup") {
			$("#eduOrgCd").val(rv["eduOrgCd"]);
			$("#eduOrgNm").val(rv["eduOrgNm"]);
		} else if (pGubun == "employeePopup") {
			$("#chargeName").val(rv["name"]);
			$("#chargeSabun").val(rv["sabun"]);
			$("#orgNm").val(rv["orgNm"]);
			$("#orgCd").val(rv["orgCd"]);
		} else if (pGubun == "orgBasicPopup") {
			$("#orgNm").val(rv["orgNm"]);
			$("#orgCd").val(rv["orgCd"]);
		} else if (pGubun == "eduMBranchPopup") {
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
			<li><tit:txt mid='eduCourseMgrPop' mdef='교육과정관리 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<table class="table">
			<colgroup>
				<col width="10%" />
				<col width="15%" />

				<col width="10%" />
				<col width="15%" />

				<col width="10%" />
				<col width="15%" />

				<col width="10%" />
				<col width="%" />
			</colgroup>
			<tr>
				<th><tit:txt mid='104168' mdef='과정명'/></th>
				<td colspan="3"><input id="eduCourseNm" name="eduCourseNm" type="text" class="text" style="width:99%;" /></td>
				<th>과정상태 </th>
				<td><select id="eduStatusCd" name="eduStatusCd" /></select></td>
				<th><tit:txt mid='eduOrgPopV1' mdef='교육기관'/></th>
				<td>
					<input id="eduOrgCd" name="eduOrgCd" type="hidden" class=""/>
					<input id="eduOrgNm" name="eduOrgNm" type="text" class="text w70p"/>
					<a onclick="javascript:doSearchEduOrgNm();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103997' mdef='구분'/></th>
				<td><select id="inOutType" name="inOutType" /></select></td>
				<th><tit:txt mid='112703' mdef='시행방법'/></th>
				<td><select id="eduMethodCd" name="eduMethodCd" /></select></td>
				<th><tit:txt mid='104566' mdef='교육구분'/></th>
				<td><select id="eduBranchCd" name="eduBranchCd" class="w100" /></select></td>
				<th><tit:txt mid='eduMBranchPopV1' mdef='교육분류'/></th>
				<td><input type="hidden" id="eduMBranchCd" name="eduMBranchCd">
					<input id="searchEduMBranchNm" name="searchEduMBranchNm" type="text" class="text w70p" />
					<a onclick="javascript:doSearchEduMBranchNm();return false;" class="button6">
						<img src="/common/${theme}/images/btn_search2.gif"/>
					</a>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='foreignCd' mdef='진행언어'/></th>
				<td><select id="foreignCd" name="foreignCd" /></select></td>
				<th>필수여부 </th>
				<td colspan="5"><select id="mandatoryYn" name="mandatoryYn" /></select></td>
				<th class="hide"><tit:txt mid='201705160000121' mdef='수강인원'/></th>
				<td class="hide"><input id="maxPerson" name="maxPerson" type="text" class="text w100p"/></td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='104497' mdef='시작일'/></th>
				<td><input id="eduSYmd" name="eduSYmd" type="text" size="10" class="date2" /></td>
				<th><tit:txt mid='111909' mdef='종료일'/></th>
				<td><input id="eduEYmd" name="eduEYmd" type="text" size="10" class="date2" /></td>
				<th><tit:txt mid='eduEventMgrPopV2' mdef='교육기간'/></th>
				<td>
					<input id="eduTerm" name="eduTerm" type="text" class="text w50p"/>
					일
					<span style="display: none;"><select id="eduUnitCd" name="eduUnitCd" class="w30p"/></select></span>
				</td>
				<th><tit:txt mid='eduEventMgrPopV4' mdef='총시간'/></th>
				<td><input id="eduHour" name="eduHour" type="text" class="text w50p"/></td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='112704' mdef='과정목표'/></th>
				<td colspan="7">
					<textarea id="eduCourseGoal" name="eduCourseGoal" rows="5" class="text w100p"></textarea>
				</td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='114508' mdef='과정내용'/></th>
				<td colspan="7">
					<textarea id="eduMemo" name="eduMemo" rows="5" class="text w100p"></textarea>
				</td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='201705160000123' mdef='교육대상'/></th>
				<td colspan="3">
					<textarea id="eduTarget" name="eduTarget" rows="5" class="text w100p"></textarea>
				</td>
				<th><tit:txt mid='201705160000124' mdef='이수조건'/></th>
				<td colspan="3">
					<textarea id="finishCondition" name="finishCondition" rows="5" class="text w100p"></textarea>
				</td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='201705160000125' mdef='보상내역'/></th>
				<td>
					<input id="eduRewardCnt" name="eduRewardCnt" type="text" class="text w50p"/>
					<select id="eduRewardCd" name="eduRewardCd" class="w50"/></select>
				</td>
				<th><tit:txt mid='113118' mdef='담당자성명'/></th>
				<td>
					<input id="chargeSabun" name="chargeSabun"  type="hidden" class="text w55p"/>
					<input id="chargeName" name="chargeName" type="text" class="text w70p"/>
					<a href="javascript:findEmpPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
				<th><tit:txt mid='113441' mdef='부서'/></th>
				<td colspan=3>
					<input id="orgCd" name="orgCd" type="hidden" class="text w100p"/>
					<input id="orgNm" name="orgNm" type="text" class="text w70p"/>
					<a onclick="javascript:orgSearchPopup();return false;" class="button6 authA"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
			</tr>
		</table>
		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:setValue();" css="pink large authA" mid='110716' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
