<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/searchEmployee.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:7};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",              Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sabun",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='payActionCd' mdef='급여일자'/>",          Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payActionCd"  ,  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",          Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='elementNm_V3475' mdef='수당항목명'/>",        Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='resultMon' mdef='계산금액'/>",          Type:"Int",   Hidden:0,  Width:80,   Align:"Right",   ColMerge:0,   SaveName:"resultMon",      KeyField:0,   CalcLogic:"",   Format:"NullInteger",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='paymentMon_V4090' mdef='예외금액'/>",          Type:"Int",   Hidden:0,  Width:80,   Align:"Right",   ColMerge:0,   SaveName:"paymentMon",     KeyField:0,   CalcLogic:"",   Format:"NullInteger",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",  Type:"Text",      Hidden:0,  Width:200,    Align:"Left",  ColMerge:0,   SaveName:"note",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='resultYn_V5817' mdef='최종결과생성여부'/>",  Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"resultYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='closeYnV1' mdef='마감여부'/>",  Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"closeYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
			];

		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:7};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",              Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sabun",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='payActionCd' mdef='급여일자'/>",          Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payActionCd"  ,  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",          Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='elementNmV2' mdef='공제항목명'/>",        Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"elementNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='resultMon' mdef='계산금액'/>",          Type:"Int",   Hidden:0,  Width:80,   Align:"Right",   ColMerge:0,   SaveName:"resultMon",      KeyField:0,   CalcLogic:"",   Format:"NullInteger",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='paymentMon_V4090' mdef='예외금액'/>",          Type:"Int",   Hidden:0,  Width:80,   Align:"Right",   ColMerge:0,   SaveName:"paymentMon",     KeyField:0,   CalcLogic:"",   Format:"NullInteger",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",  Type:"Text",      Hidden:0,  Width:200,    Align:"Left",  ColMerge:0,   SaveName:"note",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='resultYn_V5817' mdef='최종결과생성여부'/>",  Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"resultYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='closeYnV1' mdef='마감여부'/>",  Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"closeYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
			];
		IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var userCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","TST01"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("col5", 			{ComboText:"사용|사용안함", ComboCode:"Y|N"} );
		sheet1.SetColProperty("col6", 			{ComboText:userCd[0], ComboCode:userCd[1]} );


		$("#col1,#col2,#col3,#col4").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});


		$(window).smartresize(sheetResize); sheetInit();
// 		doAction1("Search");
	});


	function doSearch(){


		if($('#searchSabunHidden').val() == ""){
			alert("<msg:txt mid='109712' mdef='대상자를 선택 하여 주세요.'/>");
		}else if($('#searchPayActionNmHidden').val() == ""){
			alert("<msg:txt mid='110312' mdef='급여 일자를 선택 하여 주세요.'/>");
		}else{
			doAction1('Search');
			doAction2('Search');
		}
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/PerExceMgr.do?cmd=getPerExceMgrFirstList", $("#empForm").serialize() ); break;
		case "Save":
			IBS_SaveName(document.empForm,sheet1);
			sheet1.DoSave( "${ctx}/PerExceMgr.do?cmd=savePerExceMgrFirst", $("#empForm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/PerExceMgr.do?cmd=getPerExceMgrSecondList", $("#empForm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.empForm,sheet2);
							sheet2.DoSave( "${ctx}/PerExceMgr.do?cmd=savePerExceMgrSecond", $("#empForm").serialize()); break;
		case "Insert":		sheet2.SelectCell(sheet1.DataInsert(0), 4); break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }

		sheetResize();

		var init = {Type: "Int", Align: "Right", Edit: 0};

		for(var Row = 1; Row <= sheet1.RowCount(); Row++){
			if(sheet1.GetCellValue(Row, "closeYn") == "Y"){

				sheet1.InitCellProperty(Row, "paymentMon",  init);
			}

		}


		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();
			var init = {Type: "Int", Align: "Right", Edit: 0};

			for(var Row = 1; Row <= sheet2.RowCount(); Row++){
				if(sheet2.GetCellValue(Row, "closeYn") == "Y"){

					sheet2.InitCellProperty(Row, "paymentMon",  init);
				}

			}
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}


	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } else{doSearch();}} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } else{doSearch();}} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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

    //  사원조회 팝업
    /*
    function openOrgSchemePopup(){
        try{

        	var args    = new Array();
        	var rv = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");
            if(rv!=null){

            	$("#searchName").val(rv["name"]);
            	$("#searchSabunHidden").val(rv["sabun"]);
            }
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }
    */

    //  급여일자 조회 팝업
    function openPayDayPopup(){
        try{
        	if(!isPopup()) {return;}
        	gPRow = "";
        	pGubun = "payDayPopup";
        	var args    = new Array();
        	var rv = openPopup("/PayDayPopup.do?cmd=payDayPopup&authPg=${authPg}", args, "840","520");
            /*
        	if(rv!=null){

            	$("#searchPayActionNmHidden").val(rv["payActionCd"]);
            	$("#searchPayActionNm").val(rv["payActionNm"]);

            }
            */
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "payDayPopup"){

			$("#searchPayActionNmHidden").val(rv["payActionCd"]);
			$("#searchPayActionNm").val(rv["payActionNm"]);

	    }
	}
	// 최근급여일자 조회
	function getCpnLatestPaymentInfo() {
		var procNm = "최근급여일자";
		// 급여구분(C00001-00001.급여)
		var paymentInfo = ajaxCall("${ctx}/CpnQuery.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001", false);

		if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
			$("#searchPayActionNmHidden").val(paymentInfo.DATA[0].payActionCd);
			$("#searchPayActionNm").val(paymentInfo.DATA[0].payActionNm);
		} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
			alert(paymentInfo.Message);
		}
	}

    function bodyOnload() {
    	getCpnLatestPaymentInfo();
    }

	function setEmpPage(){
		$("#searchSabunHidden").val($("#searchUserId").val());
		$("#searchName").val($("#searchKeyword").val());
		doSearch();
	}

</script>
</head>
<body class="hidden" onload="bodyOnload();">

<div class="wrapper">

	<div class="sheet_search outer">
		<form id="empForm" name="empForm" >
		<input type="hidden" id="searchSabunHidden" name="searchSabunHidden" value="" />
		<input type="hidden" id="searchPayActionNmHidden" name="searchPayActionNmHidden" value="" />
			<div>
			<table>
			<tr>
				<!--
				<th><tit:txt mid='112947' mdef='성명/사번'/></th>
				<td>
					<input id="searchName" name="searchName" type="text" class="text" readOnly />
					<a onclick="javascript:openOrgSchemePopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<a onclick="$('#searchSabunHidden,#searchName').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
				</td>
				-->
				<th><tit:txt mid='103880' mdef='성명'/></th>
				<td>
					<input id="searchName" name="searchName" type="hidden"/>
					<input type="text"   id="searchKeyword"  name="searchKeyword" class="text" style="ime-mode:active"/>
					<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/> <!-- Include에서  사용 -->
					<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="A" /><!-- in ret -->
					<input type="hidden" id="searchUserId"   name="searchUserId" value="${ssnSabun}" />
				</td>
				<th><tit:txt mid='104477' mdef='급여일자'/></th>
				<td>
					<input id="searchPayActionNm" name="searchPayActionNm" type="text" style="width:150px;" class="text" readOnly />
					<a onclick="javascript:openPayDayPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					<a onclick="$('#searchPayActionNmHidden,#searchPayActionNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
				</td>
				<td>
					<btn:a onclick="javascript:doSearch();" css="button" mid='110697' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</form>
	</div>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="10" />
		<col width="50%" />
	</colgroup>
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='112443' mdef='수당 예외 항목'/></li>
					<li class="btn">
						<btn:a  onclick="javascript:doAction1('Save')"  css="basic authA" mid='110708' mdef="저장"/>
						<a onclick="javascript:doAction1('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td></td>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='114586' mdef='공제 예외 항목'/></li>
					<li class="btn">
						<btn:a  onclick="javascript:doAction2('Save')"  css="basic authA" mid='110708' mdef="저장"/>
						<a onclick="javascript:doAction2('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>
