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
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='enterNmV1' mdef='법인명'/>",			Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"enterNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",			Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='alias' mdef='별칭'/>",					Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"alias",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",			Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='enterEngNm' mdef='영문법인명'/>",		Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"enterEngNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='enterNo' mdef='법인등록번호'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"enterNo",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:15 },
			{Header:"<sht:txt mid='president' mdef='대표자성명'/>",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"president",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1   },
			{Header:"<sht:txt mid='epresident' mdef='영문대표자성명'/>",	Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"epresident",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1   },
			{Header:"<sht:txt mid='2017082500554' mdef='대표자직책'/>",		Type:"Text",      Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"presidentJikchak",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1 },
			{Header:"<sht:txt mid='2017082500555' mdef='영문대표자직책'/>",	Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"ePresidentJikchak",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1 },
			{Header:"<sht:txt mid='telNoV2' mdef='대표전화번호'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"telNo",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='faxNoV1' mdef='대표FAX번호'/>", 	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"faxNo",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='affiliation' mdef='계열'/>",			Type:"Combo",     Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"affiliation",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='locationCdV4' mdef='Location'/>",		Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"locationCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='zip' mdef='우편번호'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"zip",          KeyField:0,   CalcLogic:"",   Format:"PostNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
			{Header:"<sht:txt mid='addr' mdef='주소'/>",			Type:"Text",      Hidden:0,  Width:300,  Align:"Left",    ColMerge:0,   SaveName:"addr",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
			{Header:"<sht:txt mid='addrEng' mdef='영문주소'/>",		Type:"Text",      Hidden:0,  Width:300,  Align:"Left",    ColMerge:0,   SaveName:"engAddr",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
			{Header:"<sht:txt mid='tmpUseYn' mdef='사용여부'/>",		Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"useYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",		Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100, EndDateCol: "eYmd" },
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",		Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"eYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100, StartDateCol: "sYmd" },
			{Header:"<sht:txt mid='langUseYn' mdef='다국어\n사용여부'/>", Type:"CheckBox",  Hidden:1,  Width:40 ,  Align:"Center",  ColMerge:0,   SaveName:"langUseYn",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"1", FalseValue:"0" },
			{Header:"<sht:txt mid='domain' mdef='DOMAIN'/>",		Type:"Text",      Hidden:0,  Width:200,	 Align:"Center",  ColMerge:0,   SaveName:"domain",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100},
			{Header:"<sht:txt mid='memoV4' mdef='메모'/>",			Type:"Text",      Hidden:0,  Width:300,  Align:"Center",  ColMerge:0,   SaveName:"memo",  		 KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 ,	MultiLineText:1 },
			{Header:"COPYRIGHT",										Type:"Text",      Hidden:0,  Width:300,  Align:"Center",  ColMerge:0,   SaveName:"copyright",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Text",      Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",  		 KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);

		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='enterNmV1' mdef='법인명'/>",			Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"enterNm",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",			Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",	Hidden:1,Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='alias' mdef='별칭'/>",			Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"alias",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",			Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",	Hidden:1,Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sdate",        KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100, EndDateCol: "edate" },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",			Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"edate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100, StartDateCol: "sdate" },
            {Header:"<sht:txt mid='enterEngNm' mdef='영문법인명'/>",		Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"enterEngNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='enterNo' mdef='법인등록번호'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"enterNo",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:15 },
            {Header:"<sht:txt mid='president' mdef='대표자성명'/>",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"president",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='epresident' mdef='영문대표자성명'/>",	Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"epresident",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='telNoV2' mdef='대표전화번호'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"telNo",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='faxNoV1' mdef='대표FAX번호'/>", 	Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"faxNo",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='affiliation' mdef='계열'/>",			Type:"Combo",     Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"affiliation",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='locationCdV4' mdef='Location'/>",		Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"locationCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='zip' mdef='우편번호'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"zip",          KeyField:0,   CalcLogic:"",   Format:"PostNo",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"<sht:txt mid='addr' mdef='주소'/>",			Type:"Text",      Hidden:0,  Width:300,  Align:"Left",    ColMerge:0,   SaveName:"addr",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"<sht:txt mid='addrEng' mdef='영문주소'/>",		Type:"Text",      Hidden:0,  Width:300,  Align:"Left",    ColMerge:0,   SaveName:"engAddr",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"<sht:txt mid='domain' mdef='DOMAIN'/>",		Type:"Text",      Hidden:0,  Width:200,	 Align:"Center",  ColMerge:0,   SaveName:"domain",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100},
            {Header:"<sht:txt mid='memoV4' mdef='메모'/>",			Type:"Text",      Hidden:0,  Width:300,  Align:"Center",  ColMerge:0,   SaveName:"memo",  		 KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 ,	MultiLineText:1 },
            {Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Text",      Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",  		 KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");
		var affiliationCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90212"), "");

		sheet1.SetColProperty("locationCd", 			{ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]} );
		sheet2.SetColProperty("locationCd", 			{ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]} );

		sheet1.SetColProperty("affiliation", 			{ComboText:"|"+affiliationCd[0], ComboCode:"|"+affiliationCd[1]} );
		sheet2.SetColProperty("affiliation", 			{ComboText:"|"+affiliationCd[0], ComboCode:"|"+affiliationCd[1]} );

		$("#searchEnterNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function chkInVal1() {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet1.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "eYmd") != null && sheet1.GetCellValue(i, "eYmd") != "") {
					var sYmd = sheet1.GetCellValue(i, "sYmd");
					var eYmd = sheet1.GetCellValue(i, "eYmd");
					if (parseInt(sYmd) > parseInt(eYmd)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "eYmd");
						return false;
					}
				}
			}
		}
		return true;
	}
	
	function chkInVal2() {
		// 시작일자와 종료일자 체크
		var rowCnt = sheet2.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (sheet2.GetCellValue(i, "sStatus") == "I" || sheet2.GetCellValue(i, "sStatus") == "U") {
				if (sheet2.GetCellValue(i, "edate") != null && sheet2.GetCellValue(i, "edate") != "") {
					var sdate = sheet2.GetCellValue(i, "sdate");
					var edate = sheet2.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet2.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}
		return true;
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/CorpInfoMgr.do?cmd=getCorpInfoMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
			if (!chkInVal1()) {break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/CorpInfoMgr.do?cmd=saveCorpInfoMgr", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "enterNm"); break;
		case "Copy":
			var Row = sheet1.DataCopy();
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
							break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/CorpInfoMgr.do?cmd=getCorpInfoMgrListDetail", $("#srchFrm").serialize() ); break;
		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal2()) {break;}
			if(!dupChk(sheet2,"sdate", false, true)){break;}
			IBS_SaveName(document.srchFrm,sheet2);
			sheet2.DoSave( "${ctx}/CorpInfoMgr.do?cmd=saveCorpInfoMgrDetail", $("#srchFrm").serialize()); break;
		case "Insert":
							var Row = sheet2.DataInsert(0);
							sheet2.SetCellValue(Row, "enterNm", sheet1.GetCellValue(sheet1.SelectCell(), "enterNm"));
							sheet2.SetCellValue(Row, "sdate", "${curSysYyyyMMdd}");
							sheet2.SetCellValue(Row, "enterEngNm", sheet1.GetCellValue(sheet1.SelectCell(), "enterEngNm"));
							sheet2.SetCellValue(Row, "enterNo", sheet1.GetCellValue(sheet1.SelectCell(), "enterNo"));
							sheet2.SetCellValue(Row, "president", sheet1.GetCellValue(sheet1.SelectCell(), "president"));
							sheet2.SetCellValue(Row, "epresident", sheet1.GetCellValue(sheet1.SelectCell(), "epresident"));
							sheet2.SetCellValue(Row, "telNo", sheet1.GetCellValue(sheet1.SelectCell(), "telNo"));
							sheet2.SetCellValue(Row, "faxNo", sheet1.GetCellValue(sheet1.SelectCell(), "faxNo"));
							sheet2.SetCellValue(Row, "locationCd", sheet1.GetCellValue(sheet1.SelectCell(), "locationCd"));
							sheet2.SetCellValue(Row, "zip", sheet1.GetCellValue(sheet1.SelectCell(), "zip"));
							sheet2.SetCellValue(Row, "addr", sheet1.GetCellValue(sheet1.SelectCell(), "addr"));
							sheet2.SetCellValue(Row, "engAddr", sheet1.GetCellValue(sheet1.SelectCell(), "engAddr"));
							sheet2.SetCellValue(Row, "affiliation", sheet1.GetCellValue(sheet1.SelectCell(), "affiliation"));
							sheet2.SetCellValue(Row, "domain", sheet1.GetCellValue(sheet1.SelectCell(), "domain"));
							sheet2.SetCellValue(Row, "memo", sheet1.GetCellValue(sheet1.SelectCell(), "memo"));
							break;
		case "Copy":
			var Row = sheet2.DataCopy();
			break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction1("Search"); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {

		selectSheet = sheet1;
		if( OldRow != NewRow ) {
			doAction2("Search");
		}
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

	function sheet1_Click(Row, Col, Value) {
		try {
		} catch (ex) {
			alert("Click Event Error : " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value) {
		try {
		    if(Row > 0 && sheet1.ColSaveName(Col) == "locationCd"){
		    	$("#searchLocationCd").val(sheet1.GetCellValue(Row, "locationCd"));
		    	var locationCall =  ajaxCall("${ctx}/CorpInfoMgr.do?cmd=getCorpInfoMgrLocationMap",$("#srchFrm").serialize(),false);

		    	if( locationCall.DATA != null ) {
			    	sheet1.SetCellValue(Row, "zip", locationCall.DATA.zip);
			    	sheet1.SetCellValue(Row, "addr", locationCall.DATA.addr);
			    	sheet1.SetCellValue(Row, "engAddr", locationCall.DATA.engAddr);
		    	}
		    }
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if (sheet1.ColSaveName(Col) == "languageNm") {
				lanuagePopup(Row, "sheet1", "torg900", "languageCd", "languageNm", "enterNm");
			}

			if (sheet1.ColSaveName(Col) == "languageNm2") {
				lanuagePopup(Row, "sheet1", "torg900", "languageCd2", "languageNm2", "alias");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function sheet2_OnPopupClick(Row, Col){
		try{
			if (sheet2.ColSaveName(Col) == "languageNm") {
				lanuagePopup(Row, "sheet2", "torg902", "languageCd", "languageNm", "enterNm");
			}

			if (sheet2.ColSaveName(Col) == "languageNm2") {
				lanuagePopup(Row, "sheet2", "torg902", "languageCd2", "languageNm2", "alias");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function sheet1_OnChange(Row, Col, Value){
		try {
			if ( sheet1.ColSaveName(Col) == "languageNm" ){
				if ( sheet1.GetCellValue( Row, Col ) == "" ){
					sheet1.SetCellValue( Row, "languageCd", "");
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
	
	function sheet2_OnChange(Row, Col, Value){
		try {
			if ( sheet2.ColSaveName(Col) == "languageNm" ){
				if ( sheet2.GetCellValue( Row, Col ) == "" ){
					sheet2.SetCellValue( Row, "languageCd", "");
				}
			}
			
			if ( sheet2.ColSaveName(Col) == "languageNm2" ){
				if ( sheet2.GetCellValue( Row, Col ) == "" ){
					sheet2.SetCellValue( Row, "languageCd2", "");
				}
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="searchLocationCd" name="searchLocationCd">
	<input id="searchEnterNm" name ="searchEnterNm" type="hidden" class="text" />
</form>
<div class="wrapper">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='corpInfoMgr' mdef='법인관리'/></li>
							<li class="btn">
								<!-- <btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/> -->
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Search')" 	css="btn dark authA" mid='110697' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt2" class="txt"><tit:txt mid='112195' mdef='법인 히스토리 관리'/></li>
							<li class="btn">
								<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<btn:a href="javascript:doAction2('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction2('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction2('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
