<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104037' mdef='워크플로우관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='proCd' mdef='프로세스코드'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"proCd",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10, AcceptKeys:"N|E" },
			{Header:"<sht:txt mid='proNm' mdef='프로세스명'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"proNm",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bizCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",			Type:"Image",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"detail1",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='detail2_V6514' mdef='프로세스정의'/>",		Type:"Image",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"detail2",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='sortSeq' mdef='정렬\n순서'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sortSeq",			KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_info.png");
		sheet1.SetDataLinkMouse("detail1", 1);
		sheet1.SetDataLinkMouse("detail2", 1);

		var bizCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "");

		sheet1.SetColProperty("bizCd",	{ComboText:bizCd[0], ComboCode:bizCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {

        $("#searchProNm").on("keyup",function(event){
        	if(event.keyCode == 13) {
    			doAction1("Search");
        	}
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/Workflow.do?cmd=getWorkflowList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"proCd", true, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/Workflow.do?cmd=saveWorkflowList", $("#sheetForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(Code >= 1) {
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col){
		try{
			if(Row > 0 && (sheet1.GetCellValue(Row, "sStatus") == "U" || sheet1.GetCellValue(Row, "sStatus") == "R")) {
				if(sheet1.ColSaveName(Col) == "detail1") {
					//권한그룹 팝업
					if(!isPopup()) {return;}

					var param = [];
					param["proCd"] = sheet1.GetCellValue(Row,"proCd");

					let modalLayer = new window.top.document.LayerModal({
						id: 'workflowAuthGrpLayer',
						url: '/Workflow.do?cmd=viewWorkflowAuthGrpLayer&authPg=${authPg}',
						parameters: param,
						width: 370,
						height: 550,
						title: "<tit:txt mid='authorityV1' mdef='권한그룹'/>",
					});
					modalLayer.show();

				} else if(sheet1.ColSaveName(Col) == "detail2") {
					//프로세스정의 팝업
					if(!isPopup()) {return;}

					var param = [];
					param["proCd"] = sheet1.GetCellValue(Row,"proCd");

					let modalLayer = new window.top.document.LayerModal({
						id: 'workflowDetLayer',
						url: '/Workflow.do?cmd=viewWorkflowDetLayer&authPg=${authPg}',
						parameters: param,
						width: 1200,
						height: 780,
						title: '워크플로우상세',
					});
					modalLayer.show();
				}
			}
		} catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='114043' mdef='프로세스명'/></th>
				<td>
					<input id="searchProNm" name="searchProNm" type="text" class="text" />
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='110697' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='104037' mdef='워크플로우관리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
