<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

            {Header:"<sht:txt mid='jobNmV1' mdef='담당업무'/>",		Type:"Text",     	Hidden:0,  Width:100,  Align:"Center", 		ColMerge:0,   SaveName:"positionNm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",		Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd1",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm1",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      	Hidden:0,	Width:0,    Align:"Center",  	ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"<sht:txt mid='chargeNameV1' mdef='담당자성명'/>",		Type:"Text",     	Hidden:0,	Width:100,  Align:"Center", 	ColMerge:0,   SaveName:"name",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",		Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			//{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
            {Header:"<sht:txt mid='officeTelV2' mdef='사내전화(4자리)'/>",	Type:"Text",     Hidden:0,  Width:100,  Align:"Center", 	ColMerge:0,   SaveName:"officeTel",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20},
            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",      Hidden:0,  Width:45, 	Align:"Center", 	ColMerge:0,   SaveName:"seq",   		KeyField:1,   CalcLogic:"",   Format:"NullInteger",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:2 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(sheet1).sheetAutocomplete({
			Columns: [{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue){
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
					sheet1.SetCellValue(gPRow, "name",		rv["name"]);
					sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
				}
			}]
		});

		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/ContactMgr.do?cmd=getContactMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							if(!dupChk(sheet1,"seq", false, true)){break;}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/ContactMgr.do?cmd=saveContactMgr", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "schGubunCd"); break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue( Row, "languageCd1", "" );
			sheet1.SetCellValue( Row, "languageNm1", "" );
			sheet1.SetCellValue( Row, "languageCd2", "" );
			sheet1.SetCellValue( Row, "languageNm2", "" );
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if (sheet1.ColSaveName(Col) == "languageNm1") {
				lanuagePopup(Row, "sheet1", "tsys985", "languageCd1", "languageNm1", "positionNm");
			}

			if (sheet1.ColSaveName(Col) == "languageNm2") {
				lanuagePopup(Row, "sheet1", "tsys985", "languageCd2", "languageNm2", "name");
			}
			
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}
				
				pGubun = "name";
				gPRow = Row;
	            openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "840","520");
			}
			
		}catch(ex){alert("OnPopupClick Event Error : " + ex); }
	}
	
	function sheet1_OnChange(Row, Col, Value){
		try {
			if ( sheet1.ColSaveName(Col) == "languageNm1" ){
				if ( sheet1.GetCellValue( Row, Col ) == "" ){
					sheet1.SetCellValue( Row, "languageCd1", "");
				}
			}
			
			if ( sheet1.ColSaveName(Col) == "languageNm2" ){
				if ( sheet1.GetCellValue( Row, Col ) == "" ){
					sheet1.SetCellValue( Row, "languageCd2", "");
				}
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	// 팝업 리턴 함수
	function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "sheetAutocomplete") {
        	sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
        	sheet1.SetCellValue(gPRow, "name", rv["name"]);
        }
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
						<th><tit:txt mid='112250' mdef='담당자성명 '/></th>
						<td>  <input id="searchName" name ="searchName" type="text" class="text" /> </td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='contactMgr' mdef='담당자연락처관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
