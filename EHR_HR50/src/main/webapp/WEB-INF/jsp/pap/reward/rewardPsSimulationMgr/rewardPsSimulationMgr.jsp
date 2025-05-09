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
			
			{Header:"시뮬레이션구분",Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"annualPsTypeCd",	KeyField:1,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
            {Header:"년도",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year",			KeyField:1,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4},
            {Header:"제목",			Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"title",			KeyField:0,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300 },
            {Header:"실사용여부",	Type:"CheckBox",Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"useYn",			KeyField:0,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10,	TrueValue:"Y",	FalseValue:"N"},
            {Header:"비고",			Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
            {Header:"시뮬레이션ID",	Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"simulId",			KeyField:0,	CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		
		sheet1.SetColProperty("annualPsTypeCd", {ComboText:"연봉|PS", ComboCode:"10|20"} );
        
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getRewardPsSimulationMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							//if(sheet1.FindStatusRow("I") != ""){
							//	if(!dupChk(sheet1,"appraisalCd|appClassCd", true, true)){break;}
							//}
							if (!isChkYearUseYn()) {
								alert("한 년도에 실사용 여부를 한 개만 체크 할 수 있습니다.")
								return false;
							}
							
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveRewardPsSimulationMgr", $("#srchFrm").serialize()); break;
		case "Insert":
							var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "annualPsTypeCd", $("#searchAnnualPsTypeCd").val());
							sheet1.SelectCell(Row, "annualPsTypeCd");
							break;
		case "Copy":
			var Row = sheet1.DataCopy(); 
			sheet1.SetCellValue(Row, "simulId", "");
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 년도에 1개의 실사용여부만 체크 가능하다
	function isChkYearUseYn() {
		var chkCnt = 0;
		for (var i=sheet1.GetDataFirstRow();i <= sheet1.GetDataLastRow(); i++ ) {
        	chkCnt = 0;
        	var year = sheet1.GetCellValue(i, "year");
        	var simulId = sheet1.GetCellValue(i, "simulId");
        	var useYn = sheet1.GetCellValue(i, "useYn");
        	if (useYn == "Y") {
        		chkCnt = chkCnt + 1; 
        	}
        	for (var j=sheet1.GetDataFirstRow();j <= sheet1.GetDataLastRow(); j++ ) {
        		var year2 = sheet1.GetCellValue(j, "year");
        		var simulId2 = sheet1.GetCellValue(j, "simulId");
            	var useYn2 = sheet1.GetCellValue(j, "useYn");
            	
            	if (simulId == simulId2) {
            		continue;
            	}
            	if (year == year2 && useYn2 == "Y") {
            		chkCnt = chkCnt + 1;
            	}
        	}
        	
        	if (chkCnt > 1) {
        		sheet1.Set
        		return false;
        	}
        	
        }
		return true;
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
						<td> <span>시뮬레이션구분</span> 
							<select id=searchAnnualPsTypeCd name="searchAnnualPsTypeCd" onChange="javaScript:doAction1('Search');">
								<option value="10">연봉</option>
								<option value="20">PS</option> 
							</select> 
						</td>
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