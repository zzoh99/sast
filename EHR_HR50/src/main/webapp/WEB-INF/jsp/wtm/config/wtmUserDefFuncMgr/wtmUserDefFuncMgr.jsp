<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='114529' mdef='사용자정의함수'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
// 하위 그리드 조회 조건 및 입력 값
	$(function() {

        //공통코드 한번에 조회
        var grpCds = "C00025,S80001";
        var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
        console.log(codeLists);

		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata0.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",        Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",      Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"<sht:txt mid='resultV2' mdef='결과'/>",      Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"<sht:txt mid='udfCd' mdef='함수코드'/>",         Type:"Text",      Hidden:0,  Width:150,    Align:"Left",    ColMerge:1,   SaveName:"udfCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='udfNm' mdef='함수명'/>",           Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"udfNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
            {Header:"<sht:txt mid='udfName' mdef='짧은설명'/>",         Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"udfName",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
            {Header:"<sht:txt mid='dataTypeV2' mdef='함수리턴타입'/>",     Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"dataType",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='description' mdef='설명'/>",             Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"description",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
            {Header:"<sht:txt mid='nullAllowYn' mdef='NULL\n허용여부'/>",   Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"nullAllowYn",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='tmpUseYn' mdef='사용여부'/>",         Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"useYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='udfGubunCd' mdef='OBJECT구분'/>",       Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"udfGubunCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
            {Header:"<sht:txt mid='sysYn' mdef='시스템\n자료여부'/>", Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sysYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }
        ];
		IBS_InitSheet(sheet1, initdata0);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// Combo
        sheet1.SetColProperty("dataType",    {ComboText:"|"+codeLists['C00025'][0], ComboCode:"|"+codeLists['C00025'][1]} );
        sheet1.SetColProperty("nullAllowYn", {ComboText:"Y|N", ComboCode:"Y|N"} );
        sheet1.SetColProperty("useYn",       {ComboText:"Y|N", ComboCode:"Y|N"} );
        sheet1.SetColProperty("udfGubunCd",  {ComboText:"Function", ComboCode:"F"} );
        sheet1.SetColProperty("sysYn",       {ComboText:"Y|N", ComboCode:"Y|N"} );

		var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",        Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",      Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"<sht:txt mid='resultV2' mdef='결과'/>",      Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			{Header:"<sht:txt mid='udfCd' mdef='함수코드'/>",      Type:"Text",      Hidden:1,  Width:80,   Align:"Left",    ColMerge:0,   SaveName:"udfCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",          Type:"Text",      Hidden:0,  Width:50,   Align:"Left",    ColMerge:0,   SaveName:"seq",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='udfParamCd' mdef='파라미터코드'/>",  Type:"Combo",     Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"udfParamCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='inOutTypeV4' mdef='INOUT구분'/>",     Type:"Combo",     Hidden:0,  Width:65,   Align:"Left",    ColMerge:0,   SaveName:"inOutType",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='dataTypeV1' mdef='데이터타입'/>",    Type:"Combo",     Hidden:0,  Width:80,   Align:"Left",    ColMerge:0,   SaveName:"dataType",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='description' mdef='설명'/>",          Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"description",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 }
        ];
        IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

        //Combo
        sheet2.SetColProperty("udfParamCd", {ComboText:"|"+codeLists['S80001'][0], ComboCode:"|"+codeLists['S80001'][1]} );
        sheet2.SetColProperty("inOutType",  {ComboText:"|IN|OUT", ComboCode:"|IN|OUT"} );
        sheet2.SetColProperty("dataType",   {ComboText:"|"+codeLists['C00025'][0], ComboCode:"|"+codeLists['C00025'][1]} );

		$("#searchUdfNm").bind("keyup", function(event) {
			if (event.keyCode == 13) {
                doActionFirst("Search");
                $(this).focus();
            }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doActionFirst("Search");
	});

	//Sheet Action
	function doActionFirst(sAction) {
		switch (sAction) {
		case "Search":
            sheet1.DoSearch( "${ctx}/WtmUserDefFuncMgr.do?cmd=getWtmUserDefFuncMgrFirstList", $("#mySheetForm").serialize() ); break;
		case "Save":
        	if(!dupChk(sheet1, "udfCd", false, true)){break;}
        	IBS_SaveName(document.mySheetForm, sheet1);
			sheet1.DoSave( "${ctx}/WtmUserDefFuncMgr.do?cmd=saveWtmUserDefFuncMgrFirst", $("#mySheetForm").serialize()); break;
		case "Insert":
            sheet1.SelectCell(sheet1.DataInsert(0), 4); break;
		case "Copy":
            sheet1.DataCopy(); break;
		case "Clear":
            sheet1.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":
            var params = {Mode:"HeaderMatch", WorkSheetNo:1};
            sheet1.LoadExcel(params);
            break;
		}
	}

    //Sheet Action
    function doActionSecond(sAction) {

        const isEnableInsert = () => {
            if (sheet1.GetSelectRow() < 0) {
                alert("함수 Master 를 선택 후 입력해 주시기 바랍니다.");
                return false;
            } else if (sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I") {
                alert("함수 Master 를 저장 후 입력해주시기 바랍니다.");
                return false;
            } else if (sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "D") {
                alert("함수 Master 를 삭제할 경우 함수 Detail 은 입력할 수 없습니다.");
                return false;
            }

            return true;
        }

        switch (sAction) {
            case "Search":
                sheet2.DoSearch( "${ctx}/WtmUserDefFuncMgr.do?cmd=getWtmUserDefFuncMgrSecondList", $("#mySheetForm").serialize() );
                break;
            case "Save":
                if(!dupChk(sheet2, "seq", false, true)){break;}
                IBS_SaveName(document.mySheetForm, sheet2);
                sheet2.DoSave( "${ctx}/WtmUserDefFuncMgr.do?cmd=saveWtmUserDefFuncMgrSecond", $("#mySheetForm").serialize()); break;
            case "Insert":
                if (isEnableInsert()) {
                    alert("함수 Master를 선택한 후 입력해 주시기 바랍니다.");
                } else {
                    var newRow = sheet2.DataInsert(0);
                    sheet2.SetCellValue(newRow, "udfCd", getUdfCdOfFirstSheet());
                }
                break;
            case "Copy":
                var Row = sheet2.DataCopy();
                sheet2.SelectCell(Row, 5);
                break;
            case "Clear":       sheet2.RemoveAll(); break;
            case "Down2Excel":
                var downcol = makeHiddenSkipCol(sheet2);
                var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
                sheet2.Down2Excel(param); break;
            case "LoadExcel":
                var params = {Mode:"HeaderMatch", WorkSheetNo:1};
                sheet1.LoadExcel(params);
                break;
        }
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }  doActionFirst("Search"); doActionSecond("Search");  } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } doActionSecond("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }


	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doActionFirst("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

   function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
        try {
            if (OldRow == NewRow) return;

            $("#searchUdfCd").val(getUdfCdOfFirstSheet());
            doActionSecond("Search");
        } catch(ex) {
            alert("OnSelectCell Event Error : " + ex);
        }
    }

    function getUdfCdOfFirstSheet() {
        if (sheet1.GetSelectRow() < 0) return "";
        return sheet1.GetCellValue(sheet1.GetSelectRow(), "udfCd");
    }


</script>
</head>
<body class="hidden">
    <div class="wrapper">
        <div class="sheet_search outer">
            <form id="mySheetForm" name="mySheetForm" >
                <input type="hidden" id="searchUdfCd" name="searchUdfCd" value=""/>
                <div>
                    <table>
                        <tr>
                            <th><tit:txt mid='112381' mdef='함수설명'/></th>
                            <td>
                                <input id="searchUdfNm" name="searchUdfNm" type="text" class="text" />
                            </td>
                            <td>
                                <btn:a href="javascript:doActionFirst('Search')" css="button" mid='110697' mdef="조회"/>
                            </td>
                        </tr>
                    </table>
                </div>
            </form>
        </div>
        <div>
            <div class="inner">
                <div class="sheet_title">
                    <ul>
                        <li class="txt"><tit:txt mid='userDefFuncMgr1' mdef='함수 Master'/></li>
                        <li class="btn">
                            <btn:a href="javascript:doActionFirst('Insert')" css="basic authA" mid='110700' mdef="입력"/>
                            <btn:a href="javascript:doActionFirst('Copy')"   css="basic authA" mid='110696' mdef="복사"/>
                            <btn:a href="javascript:doActionFirst('Save')"   css="basic authA" mid='110708' mdef="저장"/>
                            <a href="javascript:doActionFirst('Down2Excel')" class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
                        </li>
                    </ul>
                </div>
            </div>
            <script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
        </div>
        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <colgroup>
            <col width="" />
            <col width="300px" />
        </colgroup>
            <tr>
                <td class="sheet_left">
                    <div class="inner">
                        <div class="sheet_title">
                        <ul>
                            <li class="txt"><tit:txt mid='userDefFuncMgr2' mdef='함수 Detail'/></li>
                            <li class="btn">
                              <btn:a href="javascript:doActionSecond('Insert')" css="basic authA" mid='110700' mdef="입력"/>
                              <btn:a href="javascript:doActionSecond('Copy')"   css="basic authA" mid='110696' mdef="복사"/>
                              <btn:a href="javascript:doActionSecond('Save')"   css="basic authA" mid='110708' mdef="저장"/>
                            </li>
                        </ul>
                        </div>
                    </div>
                    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
                </td>

                <!-- 화면 조정 필요 함 -->
                <td class="top">
                    <div class="h35"></div>
                    <div class="explain">
                        <div class="title"><tit:txt mid='userDefFuncMgr3' mdef='사용자정의함수 사용방법'/></div>
                        <div class="txt">
                            <ul>
                                <li><tit:txt mid='113100' mdef='1. 사용자정의 함수는 항목링크(계산식)에서'/></li>
                                <li><tit:txt mid='113802' mdef='계산식 작성시 항목구분의 선택에의해 사용되어진다.'/></li>
                            </ul>
                        </div>
                    </div>
                </td>
            <!-- 화면 조정 필요 함 -->
            </tr>
        </table>
    </div>
</body>
</html>
