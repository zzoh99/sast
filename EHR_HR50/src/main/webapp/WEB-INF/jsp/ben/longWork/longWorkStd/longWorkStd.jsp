<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title> 근속포상기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 근속포상기준관리
 * @author JM
-->
<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"근속단위",	Type:"Combo",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"gubun",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"근속기준년",	Type:"Int",			Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"wkpCnt",	KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:23 },
			{Header:"포상구분",	Type:"Combo",		Hidden:0,					Width:150,			Align:"Center", ColMerge:0, SaveName:"prizeCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"포상금액",	Type:"Int",			Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"wkpMon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"휴가일수",	Type:"Int",			Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"wkpDay",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"보상종류",	Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"wkpGift",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"사용여부",	Type:"CheckBox",	Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"useYn",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N",	DefaultValue:"Y" },
			{Header:"비고",		Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"bigo",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 }
		]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

		// 근속단위
		sheet1.SetColProperty("gubun", {ComboText:"|년|개월", ComboCode:"|1|2"});
		
		// 포상구분
		var prizeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLongWorkPrizeCdList",false).codeList, "");	//지표구분
		sheet1.SetColProperty("prizeCd", {ComboText:"|"+prizeCd[0], ComboCode:"|"+prizeCd[1]} );

		$(window).smartresize(sheetResize);
		sheetInit();

		doAction1("Search");
	});

	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch("${ctx}/LongWorkStd.do?cmd=getLongWorkStdList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				// 중복체크
				if(!dupChk(sheet1, "gubun|wkpCnt", false, true)) {break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave("${ctx}/LongWorkStd.do?cmd=saveLongWorkStd", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var Row = sheet1.DataInsert(0);
				sheet1.SetCellValue(Row, "gubun", "1");
				sheet1.SelectCell(Row, 3);
				break;
			case "Copy":
				var Row = sheet1.DataCopy();
				sheet1.SetCellValue(Row, "gubun", "1");
				sheet1.SelectCell(Row, 4);
				break;
			case "Clear":
				sheet1.RemoveAll();
				break;
			case "Down2Excel":
				//삭제/상태/hidden 지우고 엑셀내려받기
				var downcol = makeHiddenSkipCol(sheet1);
				var param = {DownCols:downcol, SheetDesign:1, Merge:1};
				var d = new Date();
				var fName = "근속포상기준관리_" + d.getTime();
				sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
</script>
</head>
<body class="hidden">
	<form id="sheet1Form" name="sheet1Form"></form>
	<div class="wrapper">
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"> 근속포상기준관리</li>
								<li class="btn">
									<a href="javascript:doAction1('Down2Excel')"	class="btn outline-gray authR">다운로드</a>
									<a href="javascript:doAction1('Copy')"			class="btn outline-gray authA">복사</a>
									<a href="javascript:doAction1('Insert')"		class="btn outline-gray authA">입력</a>
									<a href="javascript:doAction1('Save')"			class="btn filled authA">저장</a>
									<a href="javascript:doAction1('Search')"		class="btn dark authA">조회</a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>