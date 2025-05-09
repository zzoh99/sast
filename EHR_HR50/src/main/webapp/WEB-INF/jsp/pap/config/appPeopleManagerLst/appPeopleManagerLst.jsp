<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>나의피평가자</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No"			,Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",	Align:"Center", ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제|삭제"		,Type:"${sDelTy}",	Hidden:1, Width:"${sDelWdt}",	Align:"Center", ColMerge:1,	SaveName:"sDelete" },
			{Header:"상태|상태"		,Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:1,	SaveName:"sStatus" },

			{Header:"구분|구분"		,Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"chaChk",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"피평가자|인사정보",Type:"Image",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"피평가자|성명"	,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|사번"	,Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"sabun",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|호칭"	,Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"alias",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|소속"	,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"orgNm",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|직책"	,Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|직급"	,Type:"Text",		Hidden:Number("${jgHdn}"),	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikgubNm",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|직위"	,Type:"Text",		Hidden:Number("${jwHdn}"),	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|입사일"	,Type:"Date",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"empYmd",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");
		sheet1.SetDataLinkMouse("detail",1);
		$(window).smartresize(sheetResize); sheetInit();
		//doAction("Search");
	});

	$(function() {
		$("#searchAppName").val("${sessionScope.ssnName}");
		$("#searchKeyword").val("${sessionScope.ssnName}");
		$("#searchSabun").val("${sessionScope.ssnSabun}");
		$("#searchAppJikgubNm").val("${sessionScope.ssnJikgubNm}");

		$("#searchAppraisalCd").bind("change",function(event){
			var appStepCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppStepCdList&" + $("#empForm").serialize(),false).codeList, ""); // 평가차수
			if ( appStepCdList == false )	$("#searchAppStepCd").html("");
			else							$("#searchAppStepCd").html(appStepCdList[2]);

			$("#searchAppStepCd").change();
		});

		$("#searchAppStepCd").bind("change",function(event){
			var appOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppManagerOrgCdList&" + $("#empForm").serialize(),false).codeList, ""); // 평가차수
			if ( !appOrgCdList )	$("#searchAppOrgCd").html("");
			else							$("#searchAppOrgCd").html("<option value=''>전체</option>"+appOrgCdList[2]);

			$("#searchAppOrgCd").change();

		});
		$("#searchAppOrgCd").bind("change",function(event){
			doAction("Search");
		});


		//if ( "${sessionScope.ssnPapAdminYn}" == "Y" ) {
		//	$("#btnAppSabunPop").show();
		//	$("#btnAppSabunClear").show();
		//} else {
		//	$("#btnAppSabunPop").hide();
		//	$("#btnAppSabunClear").hide();
		//}

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
			sheet1.DoSearch("${ctx}/AppPeopleManagerLst.do?cmd=getAppPeopleManagerLstList", $("#empForm").serialize(), false);
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

//임직원조회 자동완성 결과 세팅 처리
function setEmpPage(){
	$("#searchAppName").val($("#searchKeyword").val());
	$("#searchSabun").val($("#searchUserId").val());
	$("#searchAppJikgubNm").val($("#headJikgubNm").val());	//직위
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

function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try{
		if ( sheet1.ColSaveName(Col) == "detail" ) {

			if(!isPopup()) {return;}

			var args = new Array();
			args["searchSabun"] = sheet1.GetCellValue(Row, "sabun");
			args["mainMenuCd"] = "02";
			args["menuCd"] = "7";

			gPRow = "";
			pGubun = "app1st2ndPopPsnalBasic";

			openPopup("${ctx}/App1st2nd.do?cmd=viewApp1st2ndPopPsnalBasic", args, "1200","520");
		}

	}catch(ex){
		alert("OnClick Event Error : " + ex);
	}
}
//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "searchEmployeePopup"){
		$("#searchAppName").val(rv["name"]);
		$("#searchSabun").val(rv["sabun"]);
		$("#searchAppJikgubNm").val(rv["jikgubNm"]);	//직급
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
							<input id="searchAppName" name ="searchAppName" type="hidden" />
							<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" <c:if test="${sessionScope.ssnPapAdminYn != 'Y'}">readonly</c:if> style="ime-mode:active"/>
							<!-- 자동완성기능 사용으로 인한 주석 처리
							<input id="searchAppName" name ="searchAppName" type="text" class="text readonly" readOnly />
							<a onclick="javascript:employeePopup();" class="button6" id="btnAppSabunPop"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchAppName,#searchAppJikgubNm').val('');" class="button7" id="btnAppSabunClear"><img src="/common/images/icon/icon_undo.png"/></a>
							-->
						</td>
						<td class="hide">
							<span>직급</span>
							<input id="searchAppJikgubNm" name ="searchAppJikgubNm" type="text" class="text readonly" readOnly />
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
							<li id="txt" class="txt">나의피평가자</li>
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