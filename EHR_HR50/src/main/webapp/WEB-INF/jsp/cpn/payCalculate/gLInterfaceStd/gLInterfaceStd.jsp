<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {	
		//$("#searchSdate").datepicker2({ymdonly:true});
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",             Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",            Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",            Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
	        {Header:"<sht:txt mid='compayGb' mdef='회사구분'/>",             Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"enterCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:16 },
	        {Header:"<sht:txt mid='payCd' mdef='급여구분'/>",             Type:"Combo",     Hidden:0,  Width:100,  Align:"Left",    ColMerge:1,   SaveName:"payCd",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"<sht:txt mid='acctCd' mdef='계정과목'/>",             Type:"Combo",     Hidden:0,  Width:150,  Align:"Left",    ColMerge:1,   SaveName:"acctCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
	        {Header:"<sht:txt mid='elementSetCdV4' mdef='항목그룹'/>",   	       Type:"Combo",     Hidden:0,  Width:150,  Align:"Left",    ColMerge:1,   SaveName:"elementSetCd",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"<sht:txt mid='cDType' mdef='차대\n구분'/>",           Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:1,   SaveName:"cDType",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1 },
		    {Header:"<sht:txt mid='acctType1' mdef='계정유형'/>",		      Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"acctType1",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	        {Header:"<sht:txt mid='acctSType' mdef='집계구분'/>",             Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"acctSType",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	        {Header:"<sht:txt mid='acctLType' mdef='계정대분류'/>",           Type:"Combo",     Hidden:1,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"acctLType",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	        {Header:"<sht:txt mid='acctMType' mdef='임원구분'/>",             Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"acctMType",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	        {Header:"<sht:txt mid='seq' 	  mdef='순서'/>",     	          Type:"Float",      Hidden:0,  Width:40,  Align:"Right",    ColMerge:1,   SaveName:"seq",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='armyMemo' mdef='비고'/>",     	          Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:1,   SaveName:"note",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='acctType1' mdef='계정유형'/>",             Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"gbnType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	        {Header:"<sht:txt mid='acctType2' mdef='분류2'/>",               Type:"Text",      Hidden:0,  Width:40,   Align:"Center",    ColMerge:0,   SaveName:"acctType2",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		    {Header:"<sht:txt mid='acctType3' mdef='분류3'/>",               Type:"Text",      Hidden:0,  Width:40,   Align:"Center",    ColMerge:0,   SaveName:"acctType3",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
        //급여구분
		var payCdList = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		//계정과목코드
        var accCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C14000"), "<tit:txt mid='103895' mdef='전체'/>");
		//차대구분
        var boundary = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C14020"), "<tit:txt mid='103895' mdef='전체'/>");
		//집계구분
        var accStype = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C14100"), "<tit:txt mid='103895' mdef='전체'/>");
		//항목그룹
        var elementSetCdList = 	convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnElementSetCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		//계정대분류(사업장코드)
		//var acctLtypeList = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&mapTypeCd=100","queryId=getTorg109List",false).codeList, "");		
		//직원분류
        var acctMTypeList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C14050"), "");
		//계정유형
        var acctType1List = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C14150"), "");
		
		$("#searchPayCd").html(payCdList[2]);
		$("#searchAccCd").html(accCd[2]);
		$("#searchBoundary").html(boundary[2]);
		$("#searchAccStype").html(accStype[2]);

		sheet1.SetColProperty("payCd", {ComboText:payCdList[0], ComboCode:payCdList[1]});
		sheet1.SetColProperty("acctCd", {ComboText:accCd[0], ComboCode:accCd[1]});
		sheet1.SetColProperty("elementSetCd", {ComboText:elementSetCdList[0], ComboCode:elementSetCdList[1]});
		sheet1.SetColProperty("cDType", {ComboText:boundary[0], ComboCode:boundary[1]});
		//sheet1.SetColProperty("acctLType", {ComboText:acctLtypeList[0], ComboCode:acctLtypeList[1]});
		sheet1.SetColProperty("acctMType", {ComboText:acctMTypeList[0], ComboCode:acctMTypeList[1]});
		sheet1.SetColProperty("acctSType", {ComboText:accStype[0], ComboCode:accStype[1]});
		sheet1.SetColProperty("acctType1", {ComboText:acctType1List[0], ComboCode:acctType1List[1]});

		
		var msg = {};
		setValidate($("#srchFrm"),msg);
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/GLInterfaceStd.do?cmd=getGLInterfaceStdList", $("#srchFrm").serialize() ); 
							break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/GLInterfaceStd.do?cmd=saveGLInterfaceStd", $("#srchFrm").serialize()); 
							break;
		case "Insert":		var Row = sheet1.DataInsert(0) ;
							sheet1.SelectCell(Row, "mapNm"); 
							break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
				
							break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"3|4|5|6|7|8"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search") ; } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}	

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{

	  	}catch(ex){alert("OnClick Event Error : " + ex);}		
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113786' mdef='급여코드'/></th>
						<td>
							<select id="searchPayCd" name ="searchPayCd" onChange="javascript:doAction1('Search')" class="box"></select> 
						</td>
						<th><tit:txt mid='113787' mdef='계정과목'/></th>
						<td>
							<select id="searchAccCd" name ="searchAccCd" onChange="javascript:doAction1('Search')" class="box"></select> 
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='114140' mdef='차대구분'/></th>
						<td>
							<select id="searchBoundary" name ="searchBoundary" onChange="javascript:doAction1('Search')" class="box"></select> 
						</td>
						<th><tit:txt mid='112375' mdef='집계구분'/></th>
						<td>
							<select id="searchAccStype" name ="searchAccStype" onChange="javascript:doAction1('Search')" class="box"></select> 
						</td>
						<td><a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td style="width:65%">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='gLInterfaceStd' mdef='전표처리기준관리'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" 		class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Copy')" 			class="btn outline_gray authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction1('Save')" 			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authA"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
