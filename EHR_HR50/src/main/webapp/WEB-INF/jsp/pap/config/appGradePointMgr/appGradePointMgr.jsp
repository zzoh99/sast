<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가종류",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appTypeCd",			KeyField:1,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
            {Header:"평가등급",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",			KeyField:1,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
            {Header:"평가등급명",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassNm",			KeyField:1,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
            {Header:"점수",			Type:"Float",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"performancePoint",	KeyField:0,	CalcLogic:"",	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
            {Header:"환산구간_이상",	Type:"Float",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"fromPoint",			KeyField:0,	CalcLogic:"",	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
            {Header:"환산구간_미만",	Type:"Float",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"toPoint",				KeyField:0,	CalcLogic:"",	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
            {Header:"순서",			Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",					KeyField:0,	CalcLogic:"",	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
            {Header:"비고",			Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",				KeyField:0,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//var comboList1 = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y&notCode=D", "P10003"), "");		//평가종류
		var comboList1 = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y", "P10003"), "");		//평가종류
		sheet1.SetColProperty("appTypeCd", 			{ComboText:comboList1[0], ComboCode:comboList1[1]} );

		$("#searchAppTypeCd").html("<option value=''>전체</option>"+comboList1[2]);

		var appClassCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "P00001"), "");	// 평가등급
		sheet1.SetColProperty("appClassCd", {ComboText:appClassCd[0], ComboCode:appClassCd[1]});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppGradePointMgr.do?cmd=getAppGradePointMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							if(sheet1.FindStatusRow("I") != ""){
								if(!dupChk(sheet1,"appTypeCd|appClassCd", true, true)){break;}
							}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppGradePointMgr.do?cmd=saveAppGradePointMgr", $("#srchFrm").serialize()); break;
		case "Insert":
							sheet1.SelectCell(sheet1.DataInsert(0), "appTypeCd");
							break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span>평가종류</span> <select id="searchAppTypeCd" name="searchAppTypeCd" onChange="javaScript:doAction1('Search');"> </select> </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
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
							<li id="txt" class="txt">평가등급별점수관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
								<a href="javascript:doAction1('Copy')" 	class="btn outline-gray authA">복사</a>
								<a href="javascript:doAction1('Insert')" class="btn outline-gray authA">입력</a>
								<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
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