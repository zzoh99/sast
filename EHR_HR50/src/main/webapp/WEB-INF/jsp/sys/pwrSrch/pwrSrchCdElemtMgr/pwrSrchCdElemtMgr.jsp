<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='pwrSrchCdElemtMgr' mdef='조건검색코드항목관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
	    sheet1.SetDataLinkMouse("dbItemDesc", 1);
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
		  	{Header:"<sht:txt mid='sNo' mdef='No'/>",  			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",    		Type:"${sDelTy}", 	Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",    		Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
	        {Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"dbItemDesc",		KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:0 },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",		Type:"Text",	Hidden:0,	Width:20,	Align:"Left",	ColMerge:0,	SaveName:"searchItemCd",    KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Left",   ColMerge:0,	SaveName:"searchItemNm",    KeyField:0,	Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='searchItemDesc' mdef='항목설명'/>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Left", 	ColMerge:0,	SaveName:"searchItemDesc",  KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:200 },
		    {Header:"<sht:txt mid='itemMapTypeV2' mdef='맴핑구분'/>", 		Type:"Combo",	Hidden:0,	Width:40,	Align:"Left", 	ColMerge:0,	SaveName:"itemMapType",     KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		    {Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>", 	Type:"Text",	Hidden:0,	Width:70,	Align:"Left",  	ColMerge:0,	SaveName:"prgUrl",          KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		    {Header:"<sht:txt mid='sqlSyntaxV2' mdef='SQL구문'/>", 		Type:"Text",	Hidden:0,	Width:120,	Align:"Left", 	ColMerge:0,	SaveName:"sqlSyntax",       KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 }
 		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4);
	    sheet1.SetColProperty("itemMapType", {ComboText:"SQL|URL| ", ComboCode:"SQL|URL| "} );
	    sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
	    sheet1.SetDataLinkMouse("dbItemDesc",1);

		$("#contentNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search");
				$(this).focus();
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": //조회
 			sheet1.DoSearch( "${ctx}/PwrSrchCdElemtMgr.do?cmd=getPwrSrchCdElemtMgrList", $("#sheet1Form").serialize());
		break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
			    //if(!dupChk(sheet1,"searchItemCd", true, true)){break;}
			}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/PwrSrchCdElemtMgr.do?cmd=savePwrSrchCdElemtMgr", $("#sheet1Form").serialize() );
            break;
        case "Insert":      //입력
            var Row = sheet1.DataInsert(0);
            sheet1.SelectCell(Row, "VIEW_NM");
            break;
        case "Copy":        //행복사
            var Row = sheet1.DataCopy();
            sheet1.SelectCell(Row, 5);
         	sheet1.SetCellValue(Row, "searchItemCd","");
            break;
        case "Clear":        //Clear
            sheet1.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기
            sheet1.Down2Excel();
            break;
        case "LoadExcel":   //엑셀업로드
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
            break;
        case "checkData":
//         	alert( sheetDupCheck(sheet1, "searchItemCd") );

        	dupChk(sheet1, "searchItemCd",false,true);
        	break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 	저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			doAction("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}
	// 	셀에서 키보드가 눌렀을때 발생하는 이벤트
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

	function sheet1_OnClick(Row, Col, Value) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "dbItemDesc"){
		    	codeDetailPopup(Row);
		    	//fnDetailWin(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 상세내역 window open event
	 */
	function codeDetailPopup(Row){
		if(!isPopup()) {return;}
		var title 	= "<tit:txt mid='authScopeMgrPop' mdef='권한범위항목관리 세부내역'/>";
  		var w 		= 640;
		var h 		= 680;
		var url 	= "${ctx}/PwrSrchCdElemtMgr.do?cmd=viewPwrSrchCdElemtMgrLayer&authPg=${authPg}";
		var p = {searchItemCd 	: sheet1.GetCellValue(Row, "searchItemCd"),
				 searchItemNm 	: sheet1.GetCellValue(Row, "searchItemNm"),
				 searchItemDesc 	: sheet1.GetCellValue(Row, "searchItemDesc"),
				 itemMapType 	: sheet1.GetCellValue(Row, "itemMapType"),
				 prgUrl 			: sheet1.GetCellValue(Row, "prgUrl"),
				 sqlSyntax 		: sheet1.GetCellValue(Row, "sqlSyntax")};
		var layer = new window.top.document.LayerModal({
			id: 'pwrSrchCdElemtMgrLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: title,
			trigger: [
				{
					name: 'pwrSrchCdElemtMgrLayerTrigger',
					callback: function(rv) {
						sheet1.SetCellValue(Row, "searchItemNm",   rv["searchItemNm"] );
						sheet1.SetCellValue(Row, "searchItemDesc", rv["searchItemDesc"] );
						sheet1.SetCellValue(Row, "itemMapType",    rv["itemMapType"] );
						sheet1.SetCellValue(Row, "prgUrl", 		   rv["prgUrl"] );
						sheet1.SetCellValue(Row, "sqlSyntax", 	   rv["sqlSyntax"] );
					}
				}
			]
		});
		layer.show();
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">

		<form id="sheet1Form" name="sheet1Form">
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
							<td>
								<input id="contentNm" name ="contentNm" type="text" class="text"/>
							</td>
							<td>
								<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
							</td>
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
								<li id="txt" class="txt"><tit:txt mid='pwrSrchCdElemtMgr' mdef='조건검색코드항목관리'/></li>
								<li class="btn">
									<btn:a href="javascript:doAction('Down2Excel');" css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
				<!-- 					<btn:a href="javascript:doAction('checkData')" css="basic" mid='111268' mdef="체크"/>  -->
									<btn:a href="javascript:doAction('Copy');" css="btn outline-gray authA" mid='110696' mdef="복사"/>
									<btn:a href="javascript:doAction('Insert');" css="btn outline-gray authA" mid='110700' mdef="입력"/>
									<btn:a href="javascript:doAction('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
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



