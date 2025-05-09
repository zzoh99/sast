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
			{Header:"평가명",		Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",			KeyField:1,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
            {Header:"평가등급",	Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",			KeyField:1,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
            {Header:"출력코드명",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassNm",			KeyField:1,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
            {Header:"세부설명",	Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"appClassDetailNm",	KeyField:0,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
            
            {Header:"등급점수",	Type:"Float",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"performancePoint",	KeyField:0,	CalcLogic:"",	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
            {Header:"시작점수",	Type:"Float",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"fromPoint",			KeyField:0,	CalcLogic:"",	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
            {Header:"종료점수",	Type:"Float",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"toPoint",				KeyField:0,	CalcLogic:"",	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
            {Header:"포인트",		Type:"Float",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"point",				KeyField:0,	CalcLogic:"",	Format:"NullFloat",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
            {Header:"비고",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",				KeyField:0,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		
		//var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchEvlYy="+$("#searchEvlYy").val()+"&searchAppTypeCd=Z,",false).codeList, "");
		var comboList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType", false).codeList, "");
		
		//var comboList1 = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y&notCode=D", "P10003"), "");		//평가종류
		sheet1.SetColProperty("appraisalCd", {ComboText:"|"+comboList1[0], ComboCode:"|"+comboList1[1]} );
        
		$("#searchAppraisalCd").html(comboList1[2]);

		var appClassCd =            convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "P00001"), "");	// 평가등급
		sheet1.SetColProperty("appClassCd", {ComboText:"|"+appClassCd[0], ComboCode:"|"+appClassCd[1]});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getAppRatingScaleMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							if(sheet1.FindStatusRow("I") != ""){
								if(!dupChk(sheet1,"appraisalCd|appClassCd", true, true)){break;}
							}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveAppRatingScaleMgr", $("#srchFrm").serialize()); break;
		case "Insert":
							var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
							sheet1.SelectCell(Row, "appraisalCd");
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
						<td> <span>평가명</span> <select id="searchAppraisalCd" name="searchAppraisalCd" onChange="javaScript:doAction1('Search');"> </select> </td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
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
							<li id="txt" class="txt">평가척도관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
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