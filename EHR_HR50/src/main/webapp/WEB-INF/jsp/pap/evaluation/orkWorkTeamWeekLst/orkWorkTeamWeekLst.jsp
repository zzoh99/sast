<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<title>팀업무조회</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		//성명,사번
		$("#searchAppSabun").val("${sessionScope.ssnSabun}");
		$("#searchAppName").val("${sessionScope.ssnName}");
		$("#searchKeyword").val("${sessionScope.ssnName}");
		$("#span_searchName").html("${sessionScope.ssnName}");

		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='detail_V3353' mdef='세부\n내역'/>",		Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0, UpdateEdit:0,	InsertEdit:0,	Cursor:"Pointer"},
			{Header:"<sht:txt mid='stateCdNm' mdef='진행상태'/>",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sabun_V2956' mdef='사번'/>",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='workorgNm' mdef='소속'/>",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='2023082500935' mdef='업무내용'/>",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"workTitle",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000},
			{Header:"<sht:txt mid='2023082500936' mdef='기한'/>",			Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"termPeriod",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000},
			{Header:"<sht:txt mid='2023082501084' mdef='리뷰결과'/>",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reviewCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},

			{Header:"평가ID",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가소속코드",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"진행상태코드",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"팀목표순번",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorSeq"},
			{Header:"업무순번",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"},
			{Header:"업무진행상태코드",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workStatusCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",1);
		
		// 업무진행상태
		var statusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30018"), "<tit:txt mid='103895' mdef='전체'/>"); // 상시평가진행상태(업무)(P30018)
		sheet1.SetColProperty("statusCd", 	{ComboText:statusCdList[0], ComboCode:statusCdList[1]} );
		$("#searchStatusCd").html(statusCdList[2]);
		
		// 리뷰결과
		var reviewCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30003"), "<tit:txt mid='103895' mdef='전체'/>"); // 상시평가리뷰결과(P30003)
		sheet1.SetColProperty("reviewCd", 	{ComboText:reviewCdList[0], ComboCode:reviewCdList[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListOkr&searchAppStepCd="+$('#searchAppStepCd').val(),false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		
		setAppPeople(); //피평가자 리스트
		
		// 이벤트 setting
		$("#searchAppraisalCd").bind("change",function(event){
			setAppPeople(); //피평가자 리스트
			doAction1("Search");
		});
		
		//대상자
		$("#searchAppPeople").bind("change",function(event){
			doAction1("Search");
		});
		
		//진행상태
		$("#searchStatusCd").bind("change",function(event){
			doAction1("Search");
		});
		
		$("#searchFrom, #searchTo").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		doAction1("Search");
	});

	//대상자
	function setAppPeople() {
		var appPeopleList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOkrAppPeopleList&"+$("#empForm").serialize(),false).codeList, "");
		$("#searchAppPeople").html("");
		$("#searchAppPeople").html(appPeopleList[2]);
	}

	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchAppName").val($("#searchKeyword").val());
		$("#searchAppSabun").val($("#searchUserId").val());
		setAppPeople(); //피평가자 리스트
		doAction1("Search");
	}

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OrkWorkTeamWeekLst.do?cmd=getOrkWorkTeamWeekList", $("#empForm").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
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

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if (Row < sheet1.HeaderRows()) return;

			if ( sheet1.ColSaveName(Col) == "detail" ) {

				if ( sheet1.GetCellValue(Row, "statusCd") == "31" || sheet1.GetCellValue(Row, "statusCd") == "35" ) {
					showDetailPopup('A',Row);
				} else {
					showDetailPopup('R',Row);
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	var showDetailPopup = function (authPg,Row) {
		if(!isPopup()) {return;}
		
		var args = new Array();
		var url = url = "${ctx}/OkrWorkReg.do?cmd=viewOkrWorkRegReviewPop";
		args["authPg"] = authPg;
		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		args["searchAppStepCd"] = $("#searchAppStepCd").val();
		args["searchAppSabun"] = $("#searchAppSabun").val();
		args["searchAppName"] = $("#searchAppName").val();
		args["searchAppOrgCd"] = sheet1.GetCellValue(Row, "appOrgCd");
		args["searchSabun"] = sheet1.GetCellValue(Row, "sabun");
		args["searchPriorSeq"] = sheet1.GetCellValue(Row, "priorSeq");
		args["searchSeq"] = sheet1.GetCellValue(Row, "seq");
		args["searchStatusCd"] = sheet1.GetCellValue(Row, "statusCd");
		
		gPRow = Row;
		pGubun = "okrWorkRegPop";
		
		openPopup(url,args,800,980);
	};

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		
		doAction1("Search");
	}

</script>
</head>

<body class="bodywrap">
<div class="wrapper">
	<form id="empForm" name="empForm" >
	<input type="hidden" name="searchAppStepCd"		id="searchAppStepCd"	value="${map.searchAppStepCd}">
	<!-- 조회영역 > 성명 자동완성 관련 추가 -->
	<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/>
	<input type="hidden" id="searchUserId"   name="searchUserId" value="" />
	<input type="hidden" id="searchUserEnterCd"  name="searchUserEnterCd" value="" />
	<!-- 조회영역 > 성명 자동완성 관련 추가 -->

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td>
				<span><tit:txt mid='111888' mdef='평가명'/></span>
				<select id="searchAppraisalCd" name="searchAppraisalCd" class="required" required> </select>
			</td>
			<td>
				<span><tit:txt mid='104420' mdef='기간'/></span>
				<input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%= DateUtil.getCurrentTime("yyyy-01-01")%>">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2" value="<%= DateUtil.getCurrentTime("yyyy-12-31")%>">
			</td>
		</tr>
		<tr>
			<td><span><tit:txt mid='113683' mdef='평가자'/></span>
				<input id="searchAppSabun" name ="searchAppSabun" type="hidden" class="text"	/>
				<input id="searchAppName" name ="searchAppName" type="hidden" class="text"	/>
				<!-- <input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/> -->
				<c:choose>
					<c:when test="${ sessionScope.ssnPapAdminYn == 'Y' }">
							<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/>
					</c:when>
					<c:otherwise>
							<input type="hidden" id="searchKeyword" name="searchKeyword" />
							<span id="span_searchName" class="txt pap_span f_normal"></span>
					</c:otherwise>
				</c:choose>
			</td>
			<td>
				<span><tit:txt mid='103863' mdef='대상자'/></span>
				<select id="searchAppPeople" name="searchAppPeople" class="required" required> </select>
			</td>
			<td>
				<span><tit:txt mid='112589' mdef='진행상태'/></span>
				<select id="searchStatusCd" name="searchStatusCd"> </select>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
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
					<li class="txt" id="pageTitle"><tit:txt mid='2023082501085' mdef='팀업무조회'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
	</tr>
	</table>
</div>

</body>
</html>