<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='perContractRdTitle' mdef='급여계약서'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
	        {Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" },
	        {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       	Type:"${sDelTy}",   Hidden:1,  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
	        {Header:"<sht:txt mid='sStatus' mdef='상태'/>",       		Type:"${sSttTy}",   Hidden:1,  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
	        {Header:"전자동의서",   									Type:"Image",   	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"detail",    	KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
	        {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",  		Type:"Text",		Hidden:1,  Width:100,  Align:"Left",	ColMerge:1,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
	        {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",  		Type:"Text",		Hidden:1,  Width:60,   Align:"Center",	ColMerge:1,   SaveName:"sabun",			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
	        {Header:"<sht:txt mid='2017082800789' mdef='계약서 유형'/>",Type:"Combo",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"contType",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
	        {Header:"급여유형",											Type:"Combo",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"payType",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
	        {Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",			Type:"Date",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"sdate",			KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",			Type:"Date",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"edate",			KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			//{Header:"<sht:txt mid='eYmd' mdef='연봉'/>",				Type:"Int",      	Hidden:0,  Width:100,  Align:"Right",   ColMerge:1,   SaveName:"yearMon",		KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
	        {Header:"<sht:txt mid='agreeYnV1' mdef='동의'/>",			Type:"CheckBox",	Hidden:0,  Width:40,   Align:"Center",  ColMerge:1,   SaveName:"agreeYn",		KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	TrueValue:"Y", FalseValue:"N" },
	        {Header:"동의일자",											Type:"Text",    	Hidden:0,  Width:60,   Align:"Center",  ColMerge:1,   SaveName:"agreeDate", 	KeyField:0,   CalcLogic:"",   Format:"YmdHms",   PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
	        {Header:"rdMrd",  											Type:"Text",		Hidden:1,  Width:60,   Align:"Center",	ColMerge:1,   SaveName:"rdMrd",			KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	        {Header:"fileSeq",  Hidden:1, SaveName:"fileSeq"},
         ] ; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
  		sheet1.SetDataLinkMouse("detail", 1);

      	// 계약서 유형
   		var contTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=CPN","Z00001"), "<tit:txt mid='103895' mdef='전체'/>");
   		sheet1.SetColProperty("contType", 			{ComboText:"|"+contTypeList[0], ComboCode:"|"+contTypeList[1]} );
  		/* var payTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10110"), "<tit:txt mid='103895' mdef='전체'/>");
  		sheet1.SetColProperty("payType", 			{ComboText:"|"+payTypeList[0], ComboCode:"|"+payTypeList[1]} ); */

		$(window).smartresize(sheetResize); sheetInit();
		setEmpPage();
	});

	function setEmpPage() {

    	$("#searchSabun").val($("#searchUserId").val());

		doAction("Search");
    }

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/PerContractSrch.do?cmd=getPerContractSrchList", $("#sheetForm").serialize() ); break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PerContractSrch.do?cmd=savePerContractSrch", $("#sheetForm").serialize(), -1, 0); break;
        case "Down2Excel":
        	var downcol = makeHiddenSkipCol(sheet1);
        	sheet1.Down2Excel({DownCols:downcol,SheetDesign:1, Merge:1, DownRows:"0", ExcelFontSize:"9",ExcelRowHeight:"20"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); } sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	    if( sheet1.ColSaveName(Col) == "detail"	&& Row >= sheet1.HeaderRows() ) {
	    	/*계약서 RD팝업*/
	    	rdPopup(Row) ;
	    }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(Row){
		if(!isPopup()) {return;}

  		var w 		= 800;
		var h 		= 1000;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		
		gPRow = Row;
		pGubun = "rdPopup";
		if( sheet1.GetCellValue(Row, "agreeYn") != "Y" ){
			url 	= "${ctx}/RdSignPopup.do";
			pGubun = "rdSignPopup";
		}

		args["rdTitle"] = "급여계약서" ;//rd Popup제목
		args["rdMrd"] = sheet1.GetCellValue(Row, "rdMrd");//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[${ssnEnterCd}] [(('"+sheet1.GetCellValue(Row, "sabun")+"','"+sheet1.GetCellValue(Row, "contType")+"','"+sheet1.GetCellValue(Row, "sdate")+"'))] [${baseURL}]" ; //rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창

		/*
		if(rv!=null){
			//return code is empty
		}
		*/
	}
	//신청 팝업에서  리턴
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{'+ returnValue+'}');
		
		if(pGubun == "rdSignPopup" && rv["fileSeq"] != undefined){
			sheet1.SetCellValue(gPRow, "agreeYn", "Y") ;
			sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]) ;
			doAction("Save");
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="sheetForm" name="sheetForm" >
		<input id="searchSabun"		name="searchSabun"		type="hidden">
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='perContractRdTitle' mdef='급여계약서'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Search')" 	css="basic authA" mid='110697' mdef="조회"/>
								<%-- <btn:a href="javascript:doAction('Save')" 		css="basic authA" mid='110708' mdef="저장"/> --%>
								<a href="javascript:doAction('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
