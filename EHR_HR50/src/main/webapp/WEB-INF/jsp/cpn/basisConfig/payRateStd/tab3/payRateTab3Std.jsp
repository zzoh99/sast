<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"> <head> <title>징계</title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    $(function() {
    	
    	//기준일자
		$("#searchDate").datepicker2();
		$("#searchDate").mask("1111-11-11");
		$("#searchDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
    	
        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:4}; 
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
                {Header:"No",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
                {Header:"삭제",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
                {Header:"결과",       Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
                {Header:"상태",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
                {Header:"급여코드",              	Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"payCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"징계코드",              	Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"punishCd",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"SEQ",                  Type:"Text",      Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"seq",           KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
                {Header:"대상자그룹코드",			Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"searchSeq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
                {Header:"대상자그룹",             Type:"Text",      Hidden:1,  Width:125,  Align:"Left",    ColMerge:0,   SaveName:"searchDesc",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
                {Header:"적용방법",				Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"gntApplyType",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                {Header:"적용항목그룹",           	Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"elementSetCd",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                {Header:"적용항목\n외\n지급여부", 	Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"eleSetExcYn",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
                {Header:"감율(%)",              	Type:"Float",     Hidden:1,  Width:70,   Align:"Right",   ColMerge:1,   SaveName:"minusRate",     KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:6,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                {Header:"지급율(%)",             Type:"Float",     Hidden:0,  Width:70,   Align:"Right",   ColMerge:1,   SaveName:"rate",          KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:6,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                {Header:"시작일자",              	Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"종료일자",				Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
            ];


        IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

        // 급여코드
        var payCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "");
        sheet1.SetColProperty("payCd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]} );
        
        // 징계코드
        var punishCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20270"), "");
        sheet1.SetColProperty("punishCd", {ComboText:"|"+punishCdList[0], ComboCode:"|"+punishCdList[1]} );
        
        // 적용방법
        var gntApplyTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00145"), "");
        sheet1.SetColProperty("gntApplyType", {ComboText:"|"+gntApplyTypeList[0], ComboCode:"|"+gntApplyTypeList[1]} );
        
        // 적용항목 외 적용여부
        sheet1.SetColProperty("eleSetExcYn",          {ComboText:"Y|N", ComboCode:"Y|N"} );
        
        // 적용항목그룹 elementSetCd
        var elementSetCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnElementSetCdList",false).codeList, "");
        sheet1.SetColProperty("elementSetCd", {ComboText:"|"+elementSetCdList[0], ComboCode:"|"+elementSetCdList[1]} );

        
        sheet1.SetMergeSheet( msHeaderOnly);

        $(window).smartresize(sheetResize); sheetInit();
        
        doAction("Search");

        $(".sheet_search>div>table>tr input[type=text],select").each(function(){

        });     
    });
    
    //Sheet Action
    function doAction(sAction) {
        
        switch (sAction) {
        case "Search":      sheet1.DoSearch( "${ctx}/PayRateTab3Std.do?cmd=getPayRateTab3StdList", $("#sheet1Form").serialize() ); break;
        case "Save":        
        	//if(!dupChk(sheet1,"payCd|punishCd|sdate", false, true)){break;}
        	IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/PayRateTab3Std.do?cmd=savePayRateTab3Std", $("#sheet1Form").serialize()); break;
        	//doAction("Search");
        case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), "payCd"); break;
        case "Copy":        
				var Row = sheet1.DataCopy();
		        sheet1.SelectCell(Row, 5);
		      	sheet1.SetCellValue(Row, "seq","");
		      	break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":  	var downcol = makeHiddenSkipCol(sheet1);
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
        try { if (Msg != "") { alert(Msg); doAction("Search");} else{doAction("Search");}} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td>
                <div class="inner">
                	<form id="sheet1Form" name="sheet1Form" >
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt">징계</li>
                            <li class="btn">
                                <span>기준일자</span> 
                                <input type="text" id="searchDate" name="searchDate" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" class="date2" />
                                <a href="javascript:doAction('Search')" class="button">조회</a>
                                <a href="javascript:doAction('Insert')" class="basic authA">입력</a>
                                <a href="javascript:doAction('Copy')"   class="basic authA">복사</a>
                                <a href="javascript:doAction('Save')"   class="basic authA">저장</a>
                                <a href="javascript:doAction('Down2Excel')" class="basic authR">다운로드</a>
                            </li>
                        </ul>
                    </div>
                    </form>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
