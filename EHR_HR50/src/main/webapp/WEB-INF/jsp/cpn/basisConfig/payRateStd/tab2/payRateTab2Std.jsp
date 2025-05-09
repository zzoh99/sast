<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"> <head> <title>근태</title>
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
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:9};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
                {Header:"No|No",           Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:1,   SaveName:"sNo" },
                {Header:"삭제|삭제",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:1,   SaveName:"sDelete" , Sort:0},
                {Header:"결과|결과",       Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:1,   SaveName:"sResult" , Sort:0},
                {Header:"상태|상태",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:1,   SaveName:"sStatus" , Sort:0},
                {Header:"급여코드|급여코드",                              Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"payCd",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"근태코드|근태코드",                              Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"gntCd",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"SEQ|SEQ",                                        Type:"Text",      Hidden:1,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"seq",            KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
                {Header:"근태기간|From(초과)",                            Type:"Int",       Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"applyFCnt",      KeyField:1,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
                {Header:"근태기간|To(이하)",                              Type:"Int",       Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"applyTCnt",      KeyField:1,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
                {Header:"대상자그룹코드|대상자그룹코드",                  Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"searchSeq",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
                {Header:"대상자그룹|대상자그룹",                          Type:"Text",      Hidden:1,  Width:125,  Align:"Left",    ColMerge:1,   SaveName:"searchDesc",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
                {Header:"적용방법|적용방법",                              Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"gntApplyType",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                {Header:"일할유형|일할유형",                      Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"periodType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                {Header:"적용항목그룹|적용항목그룹",                      Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"elementSetCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                {Header:"적용항목\n외\n적용여부|적용항목\n외\n적용여부",  Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"eleSetExcYn",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
                {Header:"기간\n반전\n여부|기간\n반전\n여부",  Type:"CheckBox",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"reversePeriodYn",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
                {Header:"감율(%)|감율(%)",                                Type:"Float",     Hidden:0,  Width:80,   Align:"Right",   ColMerge:1,   SaveName:"minusRate",      KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
                {Header:"지급율(%)|지급율(%)",                            Type:"Float",     Hidden:0,  Width:80,   Align:"Right",   ColMerge:1,   SaveName:"rate",           KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
                {Header:"시작일자|시작일자",                              Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"sdate",          KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                {Header:"종료일자|종료일자",                              Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"edate",          KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
                {Header:"1일인정\n횟수|1일인정\n횟수",                    Type:"Int",       Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"oneDays",        KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
                {Header:"적용일수|적용일수",                              Type:"Int",       Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"applyDays",      KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }
            ];


        IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

        // 급여코드
        var payCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList",false).codeList, "");
        sheet1.SetColProperty("payCd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]} );
        
        // 근태코드
        var gntCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnGntCdList",false).codeList, "");
        sheet1.SetColProperty("gntCd", {ComboText:"|"+gntCdList[0], ComboCode:"|"+gntCdList[1]} );
        
        // 적용방법
        var gntApplyTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00145"), "");
        sheet1.SetColProperty("gntApplyType", {ComboText:"|"+gntApplyTypeList[0], ComboCode:"|"+gntApplyTypeList[1]} );
        
        // 일할유형
        var periodTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00013"), "");
        sheet1.SetColProperty("periodType", {ComboText:"|"+periodTypeList[0], ComboCode:"|"+periodTypeList[1]} );        
        
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
        case "Search":      sheet1.DoSearch( "${ctx}/PayRateTab2Std.do?cmd=getPayRateTab2StdList", $("#sheet1Form").serialize() ); break;
        case "Save":        
        	//if(!dupChk(sheet1,"payCd|gntCd|seq|sdate", false, true)){break;}
        	IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/PayRateTab2Std.do?cmd=savePayRateTab2Std", $("#sheet1Form").serialize()); break;
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
        try { if (Msg != "") { alert(Msg); } doAction("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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
                            <li id="txt" class="txt">근태</li>
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
