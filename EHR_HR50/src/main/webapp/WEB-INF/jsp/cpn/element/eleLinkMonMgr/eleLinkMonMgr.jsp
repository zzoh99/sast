<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:1};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",        Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",      Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"<sht:txt mid='resultV2' mdef='결과'/>",      Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>",  Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"seq",         KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",  Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"elementCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",    Type:"Popup",     Hidden:0,  Width:120,  Align:"Left",    ColMerge:1,   SaveName:"elementNm",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },
            {Header:"<sht:txt mid='basicMon' mdef='금액'/>",      Type:"Float",     Hidden:0,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"basicMon",    KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",  Type:"Text",      Hidden:1,  Width:30,    Align:"Left",    ColMerge:0,   SaveName:"searchSeq",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='searchDesc' mdef='검색설명'/>",  Type:"Popup",     Hidden:0,  Width:256,  Align:"Left",    ColMerge:0,   SaveName:"searchDesc",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1000 },
            {Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",  Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",       KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",  Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(1);sheet1.SetCountPosition(4);

		$("#searchElementNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/EleLinkMonMgr.do?cmd=getEleLinkMonMgrList", $("#sheet1Form").serialize() ); break;
		case "Save":
			if(!dupChk(sheet1,"elementCd|searchSeq|sdate", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/EleLinkMonMgr.do?cmd=saveEleLinkMonMgr", $("#sheet1Form").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
		case "Copy":		sheet1.DataCopy(); sheet1.SetCellValue(sheet1.GetSelectRow(), "seq", "");break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
					var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
					sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	}

    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){

		var colName = sheet1.ColSaveName(Col);
		let parameters = {};
		let layerId = '';
		let url = '';
		let title = '';
		let width = 0;
		let height = 0;
		if(colName === 'elementNm'){
			layerId = 'payElementLayer';
			url = '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=R';
			title = '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>';
			parameters = {
				elementCd : sheet1.GetCellValue(Row, "elementCd")
				, elementNm : sheet1.GetCellValue(Row, "elementNm")
				, searchElementLinkType: "S"
			};
			width = 860;
			height = 520;
		}else if(colName === 'searchDesc'){
			layerId = 'pwrSrchMgrLayer';
			url = '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=R';
			title = '<tit:txt mid='112392' mdef='조건 검색 관리'/>';
			parameters = {
				searchDesc : sheet1.GetCellValue(Row, "searchDesc")
			};
			width = 1100;
			height = 520;
		}else{
			return;
		}

		let layerModal = new window.top.document.LayerModal({
			id : layerId
			, url : url
			, parameters : parameters
			, width : width
			, height : height
			, title : title
			, trigger :[
				{
					name : 'payTrigger'
					, callback : function(result){
						sheet1.SetCellValue(Row, "elementCd", result.resultElementCd);
						sheet1.SetCellValue(Row, "elementNm", result.resultElementNm);
					}
				}
				, {
					name : 'pwrTrigger'
					, callback : function(result){
						sheet1.SetCellValue(Row, "searchSeq", result.searchSeq);
						sheet1.SetCellValue(Row, "searchDesc", result.searchDesc);
					}
				}
			]
		});
		layerModal.show();


        // try{
		//
        //   var colName = sheet1.ColSaveName(Col);
        //   var args    = new Array();
		//
		//
        //   // 항목설명
        //   args["elementCd"]  = sheet1.GetCellValue(Row, "elementCd");
        //   args["elementNm"]  = sheet1.GetCellValue(Row, "elementNm");
        //   //args["callPage"]  = "eleLinkMonMgr"; // SQL 에서 사용
		//
        //   // 대상자검색설명
        //   args["searchSeq"]   = sheet1.GetCellValue(Row, "searchSeq");
        //   args["searchDesc"]  = sheet1.GetCellValue(Row, "searchDesc");
		//
        //   var rv = null;
		//
        //   if(colName == "elementNm") {
        // 	  if(!isPopup()) {return;}
        // 	  gPRow = Row;
        // 	  pGubun = "payElementPopup";
        //       var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=R", args, "740","520");
		// 	  /*
        //       if(rv!=null){
        //           sheet1.SetCellValue(Row, "elementCd",   rv["elementCd"] );
        //           sheet1.SetCellValue(Row, "elementNm",   rv["elementNm"] );
        //       }
		// 	  */
        //   }
        //   else if(colName == "searchDesc") {
        // 	  if(!isPopup()) {return;}
        // 	  gPRow = Row;
        // 	  pGubun = "pwrSrchMgrPopup";
        //       var rv = openPopup("/Popup.do?cmd=pwrSrchMgrPopup&authPg=R", args, "1100","520");
        //       /*
        //       if(rv!=null){
        //           sheet1.SetCellValue(Row, "searchSeq",   rv["searchSeq"] );
        //           sheet1.SetCellValue(Row, "searchDesc",  rv["searchDesc"] );
        //       }
		// 	  */
        //   }else{}
		//
		//
        // }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "payElementPopup"){
            sheet1.SetCellValue(gPRow, "elementCd",   rv["elementCd"] );
            sheet1.SetCellValue(gPRow, "elementNm",   rv["elementNm"] );

	    }else if(pGubun == "pwrSrchMgrPopup"){
            sheet1.SetCellValue(gPRow, "searchSeq",   rv["searchSeq"] );
            sheet1.SetCellValue(gPRow, "searchDesc",  rv["searchDesc"] );
	    }
	}

    // 검색결과 팝업
    function openPwrSrchResultPopup(){
		let layerModal = new window.top.document.LayerModal({
			id : 'pwrResultLayer'
			, url : '${ctx}/PwrSrchResultPopup.do?cmd=viewPwrSrchResultLayer&authPg=${authPg}'
			, parameters : {
				srchSeq : sheet1.GetCellValue(sheet1.GetSelectRow(), "searchSeq")
			}
			, width : 940
			, height : 580
			, title : '검색결과 조회'
		});
		layerModal.show();

        <%--try{--%>

        <%--$("#srchSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "searchSeq"));--%>
        <%--var url	= "${ctx}/PwrSrchResultPopup.do?cmd=pwrSrchResultPopup&authPg=${authPg}";--%>
  		<%--var rv 	= openPopup(url, window, "940","580");--%>

        <%--}catch(ex){alert("Open Popup Event Error : " + ex);}--%>
    }

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	    <input id="srchSeq" name="srchSeq" type="hidden"/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
						<td>  <input id="searchElementNm" name ="searchElementNm" type="text" class="text" /> </td>
						<td> <btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='eleLinkMonMgr' mdef='항목링크(기준금액)'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
                                <btn:a href="javascript:doAction('Save')"   css="basic authA" mid='110708' mdef="저장"/>
                                <btn:a href="javascript:doAction('Down2Excel')"   css="basic authR" mid='110698' mdef="다운로드"/>
                                <btn:a href="javascript:openPwrSrchResultPopup()"   css="basic authR" mid='110710' mdef="검색결과"/>
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
