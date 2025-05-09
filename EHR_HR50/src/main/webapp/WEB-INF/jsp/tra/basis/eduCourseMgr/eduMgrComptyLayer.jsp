<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		const modal = window.top.document.LayerModalUtility.getModal('eduMgrComptyLayer');
		createIBSheet3(document.getElementById('eduMgrComptyLayerSheet1-wrap'), "eduMgrComptyLayerSheet1", "100%", "100%","${ssnLocaleCd}");
		createIBSheet3(document.getElementById('eduMgrComptyLayerSheet2-wrap'), "eduMgrComptyLayerSheet2", "100%", "100%","${ssnLocaleCd}");

		let searchEduSeq = modal.parameters.eduSeq;
		let eduCourseNm = modal.parameters.eduCourseNm;

		$("#searchEduSeq").val(searchEduSeq);
		$("#eduCourseNm").val(eduCourseNm);

		$("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		init_eduMgrComptyLayerSheet1();init_eduMgrComptyLayerSheet2();

		var sheetHeight = $('.modal_body').height() - $('#eduMgrComptyLayerForm').height() - $('.sheet_title').height();
		eduMgrComptyLayerSheet1.SetSheetHeight(sheetHeight);
		eduMgrComptyLayerSheet2.SetSheetHeight(sheetHeight);


		doAction2("Search");
		doAction1("Search");

		//$(window).smartresize(sheetResize); sheetInit();
	});

	/*
	 * sheet Init
	 */
	function init_eduMgrComptyLayerSheet1(){
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0, FrozenColRight:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"역량군",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"priorCompetencyNm",KeyField:0, Format:"",	 UpdateEdit:0,	InsertEdit:0},
			{Header:"역량",		Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"competencyNm", 	KeyField:1, Format:"",	 UpdateEdit:0,	InsertEdit:0},
			{Header:"비고",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",	 UpdateEdit:1,	InsertEdit:1, EditLen:2000 },

			{Header:"Hidden", Hidden:1, SaveName:"eduSeq" },
			{Header:"Hidden", Hidden:1, SaveName:"competencyCd" },

		]; IBS_InitSheet(eduMgrComptyLayerSheet1, initdata1);eduMgrComptyLayerSheet1.SetEditable("${editable}");eduMgrComptyLayerSheet1.SetVisible(true);eduMgrComptyLayerSheet1.SetCountPosition(4);

		eduMgrComptyLayerSheet1.FocusAfterProcess = false;
		eduMgrComptyLayerSheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

	}

	function init_eduMgrComptyLayerSheet2(){
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0, FrozenColRight:2};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"역량군",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"priorCompetencyNm",KeyField:0, Format:"",	 UpdateEdit:0,	InsertEdit:0},
			{Header:"역량",		Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"competencyNm", 	KeyField:1, Format:"",	 UpdateEdit:0,	InsertEdit:0},
			{Header:"선택",		Type:"DummyCheck",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sel" },

			{Header:"Hidden", Hidden:1, SaveName:"competencyCd" },

		]; IBS_InitSheet(eduMgrComptyLayerSheet2, initdata1);eduMgrComptyLayerSheet2.SetEditable("${editable}");eduMgrComptyLayerSheet2.SetVisible(true);eduMgrComptyLayerSheet2.SetCountPosition(4);

		eduMgrComptyLayerSheet2.FocusAfterProcess = false;
	}

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				eduMgrComptyLayerSheet1.DoSearch( "${ctx}/EduCourseMgr.do?cmd=getEduMgrComptyList", $("#eduMgrComptyLayerForm").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.eduMgrComptyLayerForm,eduMgrComptyLayerSheet1);
				eduMgrComptyLayerSheet1.DoSave( "${ctx}/EduCourseMgr.do?cmd=saveEduMgrCompty", $("#eduMgrComptyLayerForm").serialize());
				break;
			case "Insert":
				//var Row = eduMgrComptyLayerSheet1.DataInsert();
				//competencyPop(Row);
				break;
			case "Copy":
				var row = eduMgrComptyLayerSheet1.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(eduMgrComptyLayerSheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				eduMgrComptyLayerSheet1.Down2Excel(param);
				break;
		}
	}

	/*Sheet Action*/
	function doAction2(sAction) {
		switch (sAction) {
			case "Search": //조회

				var sXml = eduMgrComptyLayerSheet2.GetSearchData("${ctx}/EduCourseMgr.do?cmd=getEduMgrComptyStdList", $("#eduMgrComptyLayerForm").serialize() );
				sXml = replaceAll(sXml,"rowEdit", "Edit");
				sXml = replaceAll(sXml,"selBackColor", "sel#BackColor");
				eduMgrComptyLayerSheet2.LoadSearchData(sXml );
				break;
			case "Reg":

				var sRow = eduMgrComptyLayerSheet2.FindCheckedRow("sel");
				if( sRow == "" ) return;

				var arrRow = sRow.split("|");
				for(var i=0; i<arrRow.length; i++){
					var dupChk = fineCompetencyCd( eduMgrComptyLayerSheet2.GetCellValue(arrRow[i], "competencyCd") );
					if( dupChk == -1 ){
						var Row = eduMgrComptyLayerSheet1.DataInsert(-1);
						eduMgrComptyLayerSheet1.SetCellValue(Row, "priorCompetencyNm", eduMgrComptyLayerSheet2.GetCellValue(arrRow[i], "priorCompetencyNm"));
						eduMgrComptyLayerSheet1.SetCellValue(Row, "competencyNm", eduMgrComptyLayerSheet2.GetCellValue(arrRow[i], "competencyNm"));
						eduMgrComptyLayerSheet1.SetCellValue(Row, "competencyCd", eduMgrComptyLayerSheet2.GetCellValue(arrRow[i], "competencyCd"));
					}
				}

				break;
		}
	}
	function fineCompetencyCd(str){
		var rs = -1;
		try{
			for(var i = eduMgrComptyLayerSheet1.HeaderRows(); i < eduMgrComptyLayerSheet1.RowCount()+eduMgrComptyLayerSheet1.HeaderRows() ; i++) {
				if( $.trim(str) == $.trim(eduMgrComptyLayerSheet1.GetCellValue(i, "competencyCd"))){
					rs = i;
				}
			}

		}catch(e){}
		return rs;
	}

	//-----------------------------------------------------------------------------------
	//		eduMgrComptyLayerSheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function eduMgrComptyLayerSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			eduMgrComptyLayerSheet2.CheckAll("sel", 0);
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}


	// 저장 후 메시지
	function eduMgrComptyLayerSheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 팝업 클릭 시
	function eduMgrComptyLayerSheet1_OnPopupClick(Row, Col) {
		try {
			if (eduMgrComptyLayerSheet1.ColSaveName(Col) == "competencyNm") {
				if (!isPopup()) {  return; }
				competencyPop(Row);
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//-----------------------------------------------------------------------------------
	//		eduMgrComptyLayerSheet2 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function eduMgrComptyLayerSheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//역량팝업
	function competencyPop(Row){
		if (!isPopup()) {  return; }

		gPRow = Row;
		pGubun = "competencyPop";

		var args	= new Array();
		args["selectType"] = "C"; //선택 가능

		openPopup("/Popup.do?cmd=competencySchemePopup", args,"740", "720");
	}
	//---------------------------------------------------------------------------------------------------------------
	// 팝업 콜백 함수.
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue + '}');

		if (pGubun == "competencyPop") {

			eduMgrComptyLayerSheet1.SetCellValue(gPRow, "priorCompetencyNm", rv["priorCompetencyNm"]);
			eduMgrComptyLayerSheet1.SetCellValue(gPRow, "competencyCd", 		rv["competencyCd"]);
			eduMgrComptyLayerSheet1.SetCellValue(gPRow, "competencyNm", 		rv["competencyNm"]);


		}
	}

</script>

</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="eduMgrComptyLayerForm" name="eduMgrComptyLayerForm" >
			<input type="hidden" id="searchEduSeq" name="searchEduSeq" />
			<div class="sheet_search outer">
				<table>
					<tr>
						<th>교육과정명</th>
						<td>
							<input type="text" id="eduCourseNm" name="eduCourseNm" class="date2 readonly w350" readonly/>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</form>

		<table class="sheet_main">
			<colgroup>
				<col width="45%" />
				<col width="20px" />
				<col width="" />
			</colgroup>
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt">역량분류표</li>
								<li class="btn">&nbsp;</li>
							</ul>
						</div>
					</div>
					<div id="eduMgrComptyLayerSheet2-wrap"></div>
				</td>

				<td class="sheet_right">
					<div style="padding-top:200px;" class="setBtn">
						<a href="javascript:doAction2('Reg');"><img src="/common/images/sub/ico_arrow.png"/></a>
					</div>
				</td>
				<td class="sheet_right">

					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt">교육 관련역량</li>
								<li class="btn">
									<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
									<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
								</li>
							</ul>
						</div>
					</div>
					<div id="eduMgrComptyLayerSheet1-wrap"></div>
				</td>
			</tr>
		</table>
	</div>

	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('eduMgrComptyLayer');" css="btn outline_gray" mid="close" mdef="닫기"/>
	</div>
</div>
</body>
</html>