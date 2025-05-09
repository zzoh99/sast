<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='payRateTab2Std' mdef='근태'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

    $(function() {

    	//기준일자
    	/*
		$("#searchDate").datepicker2();
		$("#searchDate").mask("1111-11-11");
		$("#searchDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
    	*/

        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:4};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",           Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:1,   SaveName:"sNo" },
				/*
				{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:1,   SaveName:"sDelete" , Sort:0},
				{Header:"<sht:txt mid='sResultV1' mdef='결과|결과'/>",       Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:1,   SaveName:"sResult" , Sort:0},
				{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:1,   SaveName:"sStatus" , Sort:0},
				*/
				{Header:"<sht:txt mid='temp2' mdef='세부\n내역'/>",    	 Type:"Image",     	Hidden:1,  	Width:40,	Align:"Center", ColMerge:0, SaveName:"detail" ,  KeyField:0,   CalcLogic:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0},
				{Header:"<sht:txt mid='chargeSabun' mdef='사번'/>",			 Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
				{Header:"<sht:txt mid='teacherNm' mdef='성명'/>",			 Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		 Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",		 Type:"Text",		Hidden:Number("${jgHdn}"),	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"<sht:txt mid='jikweeNmV8' mdef='직위'/>",		 Type:"Text",		Hidden:Number("${jwHdn}"),	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"<sht:txt mid='orgYn' mdef='소속'/>",			 Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"<sht:txt mid='gntCdV5' mdef='근태코드'/>",         Type:"Combo",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1, SaveName:"gntCd",     	KeyField:1,   CalcLogic:"", Format:"",PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"<sht:txt mid='gntApplyTypeV1' mdef='적용방법'/>",         Type:"Combo",      	Hidden:1,  Width:70,   Align:"Center",  ColMerge:1, SaveName:"gntApplyType",KeyField:0, CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
				{Header:"<sht:txt mid='symd' mdef='적용시작일'/>",		 Type:"Date",		Hidden:0, 	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"symd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
				{Header:"<sht:txt mid='eymd' mdef='적용종료일'/>",		 Type:"Date",		Hidden:0, 	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"eymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
				{Header:"<sht:txt mid='gntCntV3' mdef='적용일수'/>",         Type:"Int",       Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,  SaveName:"gntCnt",      KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1 },
				{Header:"<sht:txt mid='minusRateV1' mdef='감율(%)'/>",      	 Type:"Float",     	Hidden:0, 	Width:75,   Align:"Center", ColMerge:1, SaveName:"minusRate",             KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:6 },
				{Header:"<sht:txt mid='rateV3' mdef='지급율(%)'/>",       Type:"Float",     	Hidden:0, 	Width:75,   Align:"Center", ColMerge:1, SaveName:"rate",             KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:0,   InsertEdit:1,   EditLen:6 },
				{Header:"<sht:txt mid='elementSetCdV3' mdef='적용항목그룹'/>",      Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"elementSetCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"<sht:txt mid='eleSetExcYnV2' mdef='적용항목외\n적용여부'/>",  Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"eleSetExcYn",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1 }
            ];


        IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

        sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

        // 근태코드
        var gntCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnGntCdList",false).codeList, "");
        sheet1.SetColProperty("gntCd", {ComboText:"|"+gntCdList[0], ComboCode:"|"+gntCdList[1]} );

        // 적용방법
        var gntApplyTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00145"), "");
        sheet1.SetColProperty("gntApplyType", {ComboText:"|"+gntApplyTypeList[0], ComboCode:"|"+gntApplyTypeList[1]} );

        // 적용항목급룹
        var elementSetCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnElementSetCdList",false).codeList, "");
        sheet1.SetColProperty("elementSetCd", {ComboText:"|"+elementSetCdList[0], ComboCode:"|"+elementSetCdList[1]} );

        // 적용항목 외 적용여부
        sheet1.SetColProperty("eleSetExcYn",          {ComboText:"Y|N", ComboCode:"Y|N"} );

        sheet1.SetMergeSheet( msHeaderOnly);

        $(window).smartresize(sheetResize); sheetInit();

        doAction("Search");

        $(".sheet_search>div>table>tr input[type=text],select").each(function(){


        });
    });

    //Sheet Action
    function doAction(sAction) {

        switch (sAction) {
        case "Search":      sheet1.DoSearch( "${ctx}/PayDayChkStd.do?cmd=getPayDayChkTab2StdList", $("#mySheetForm", parent.document).serialize()); break;
        case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/PayDayChkStd.do?cmd=savePayDayChkTab2Std", $("#mySheetForm", parent.document).serialize()); break;
        case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), "payCd"); break;
        case "Copy":
        	var Row = sheet1.DataCopy();
	        sheet1.SelectCell(Row, 5);
	      	sheet1.SetCellValue(Row, "seq","");
	      	break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
					sheet1.Down2Excel(param); break;
        case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } else{doAction("Search");}} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	</form>
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td>
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid='payRateTab2Std' mdef='근태'/></li>
                            <li class="btn">
                                <btn:a href="javascript:doAction('Search')" css="btn dark" mid='search' mdef="조회"/>
                                <!--
                                <btn:a href="javascript:doAction('Insert')" css="btn outline_gray authA" mid='insert' mdef="입력"/>
                                <btn:a href="javascript:doAction('Copy')"   css="btn outline_gray authA" mid='copy' mdef="복사"/>
                                <btn:a href="javascript:doAction('Save')"   css="btn filled authA" mid='save' mdef="저장"/>
                                -->
                                <a href="javascript:doAction('Down2Excel')" class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
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