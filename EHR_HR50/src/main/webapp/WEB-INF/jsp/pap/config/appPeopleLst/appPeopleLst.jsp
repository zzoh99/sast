<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>나의평가자</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No"		,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제"		,Type:"${sDelTy}",	Hidden:1, Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },

			{Header:"차수"		,Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chaChk",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가소속"	,Type:"Text",		Hidden:0,	Width:160,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명"		,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번"		,Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"호칭"		,Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속"		,Type:"Text",		Hidden:0,	Width:160,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급"		,Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위"		,Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책"		,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
	});

	$(function() {
		$("#searchAppraisalCd").bind("change",function(event){
		var appStepCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppStepCdList&" + $("#empForm").serialize(),false).codeList, ""); // 평가차수
			if ( !appStepCdList )	$("#searchAppStepCd").html("");
			else							$("#searchAppStepCd").html(appStepCdList[2]);

			$("#searchAppStepCd").change();
		});

		$("#searchAppStepCd").bind("change",function(event){
			var appOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppOrgCdList&" + $("#empForm").serialize(),false).codeList, ""); // 평가차수
			if ( !appOrgCdList )	$("#searchAppOrgCd").html("");
			else							$("#searchAppOrgCd").html(appOrgCdList[2]);

			$("#searchAppOrgCd").change();

		});
		$("#searchAppOrgCd").bind("change",function(event){
			doAction("Search");
		});


		$("#searchName").val("${sessionScope.ssnName}");
		$("#searchKeyword").val("${sessionScope.ssnName}");
		$("#searchSabun").val("${sessionScope.ssnSabun}");
		$("#searchJikgubNm").val("${sessionScope.ssnJikgubNm}");

		//if ( "${sessionScope.ssnPapAdminYn}" == "Y" ) {
		//	$("#btnSabunPop").show();
		//	$("#btnSabunClear").show();
		//} else {
		//	$("#btnSabunPop").hide();
		//	$("#btnSabunClear").hide();
		//}

		//var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, ""); // 평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchAppraisalCd").change();
	});


/**
 * Sheet 각종 처리
 */
function doAction(sAction){
	//removeErrMsg();
	switch(sAction){
		case "Search":		//조회
			sheet1.DoSearch("${ctx}/AppPeopleLst.do?cmd=getAppPeopleLstList", $("#empForm").serialize(), false);
			break;
		case "Save":		//저장
			break;
		case "Insert":		//입력
			var Row = sheet1.DataInsert(0);
			sheet1.SelectCell(Row, 2);
			break;
		case "Copy":		//행복사
			var Row = sheet1.DataCopy();

			sheet1.SelectCell(Row, 2);
			break;

		case "Clear":		//Clear

			sheet1.RemoveAll();
			break;

		case "Down2Excel":	//엑셀내려받기

			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;

		case "LoadExcel":	break;//엑셀업로드
	}
}

// 임직원조회 자동완성 결과 세팅 처리
function setEmpPage(){
	$("#searchName").val($("#searchKeyword").val());
	$("#searchSabun").val($("#searchUserId").val());
	$("#searchJikgubNm").val($("#headJikgubNm").val());	//직위
	$("#searchAppStepCd").change();
	//doAction("Search");
}

//사원 팝입
function employeePopup(){
	try{
		if(!isPopup()) {return;}

		var args = new Array();

		gPRow = "";
		pGubun = "searchEmployeePopup";

		openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");
	}catch(ex){alert("Open Popup Event Error : " + ex);}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{
		if (Msg != "") alert(Msg);
		sheetResize();
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex);
	}
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "searchEmployeePopup"){
		$("#searchName").val(rv["name"]);
		$("#searchSabun").val(rv["sabun"]);
		$("#searchJikgubNm").val(rv["jikgubNm"]);	//직위
		$("#searchAppStepCd").change();
		doAction("Search");
    }
}

</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="empForm" name="empForm" >
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->
		<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/>
		<input type="hidden" id="searchUserId"   name="searchUserId" value="" />
		<input type="hidden" id="searchUserEnterCd"  name="searchUserEnterCd" value="" />
		<input type="hidden" id="headJikgubNm"  name="headJikgubNm" value="" />
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->
	
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd"></select>
						</td>
						<td>
							<span>평가단계</span>
							<select name="searchAppStepCd" id="searchAppStepCd"></select>
						</td>
						<td><span>평가소속 </span>
							<select id="searchAppOrgCd" name="searchAppOrgCd"></select>
						</td>
						<td><span>성명 </span>
							<input id="searchSabun" name ="searchSabun" type="hidden" class="text"	/>
							<input id="searchName" name ="searchName" type="hidden" />
							<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" <c:if test="${sessionScope.ssnPapAdminYn != 'Y'}">readonly</c:if> style="ime-mode:active"/>
							<!-- 자동완성기능 사용으로 인한 주석 처리
							<input id="searchName" name ="searchName" type="text" class="text readonly" readOnly />
							<a onclick="javascript:employeePopup();" class="button6" id="btnSabunPop"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchName,#searchJikgubNm').val('');" class="button7" id="btnSabunClear"><img src="/common/images/icon/icon_undo.png"/></a>
							 -->
						</td>
						<td class="hide">
							<span>직급</span>
							<input id="searchJikgubNm" name ="searchJikgubNm" type="text" class="text readonly" readOnly />
						</td>
						<td>
							<a href="javascript:doAction('Search')" id="btnSearch" class="btn dark authR">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">나의평가자</li>
							<li class="btn">
								<a href="javascript:doAction('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>