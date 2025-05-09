<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='taxTab1Std' mdef='세율관리'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- 날짜 콤보 박스 생성을 위함 -->
<%@ page import="java.util.GregorianCalendar" %>
<%@ page import="java.util.Calendar" %>
<!-- 날짜 콤보 박스 생성을 위함 -->

<script type="text/javascript">
    $(function() {

        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:6};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
                         {Header:"<sht:txt mid='sNo' mdef='No'/>",        Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
                         {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",      Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
                         {Header:"<sht:txt mid='resultV2' mdef='결과'/>",      Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
                         {Header:"<sht:txt mid='sStatus' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
                         {Header:"<sht:txt mid='appraisalYy' mdef='년도'/>",      Type:"Text",      Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"workYy",      KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
                         {Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",      Type:"Text",      Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"taxRateCd",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                         {Header:"<sht:txt mid='taxRateNm' mdef='세율명'/>",    Type:"Text",      Hidden:0,  Width:140,  Align:"Left",    ColMerge:0,   SaveName:"taxRateNm",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
                         {Header:"<sht:txt mid='baseMon' mdef='기준금액'/>",  Type:"Int",       Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"baseMon",     KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
                         {Header:"<sht:txt mid='ratio1' mdef='비율1'/>",     Type:"Float",     Hidden:0,  Width:45,   Align:"Right",   ColMerge:0,   SaveName:"ratio1",       KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
                         {Header:"<sht:txt mid='ratio2' mdef='비율2'/>",     Type:"Float",     Hidden:0,  Width:45,   Align:"Right",   ColMerge:0,   SaveName:"ratio2",       KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:2,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
                         {Header:"<sht:txt mid='applyMon' mdef='적용금액'/>",  Type:"Int",       Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"applyMon",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
                         {Header:"<sht:txt mid='gubunMon' mdef='구분금액'/>",  Type:"Int",       Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"gubunMon",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
                         {Header:"<sht:txt mid='limitAmt' mdef='한도금액'/>",  Type:"Int",       Hidden:0,  Width:55,   Align:"Right",   ColMerge:0,   SaveName:"limitMon",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 }
                     ];

        IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

        // 부모창의 년도
        $("#searchYear").val($("#searchYear", parent.document).val());
        // 부모창의 세율명
        $("#searchTaxRateNm").val($("#searchTaxRateNm", parent.document).val());

        doAction("Search");

        $(".sheet_search>div>table>tr input[type=text],select").each(function(){

        });

        sheet1.SetMergeSheet( msHeaderOnly);

		// 부모창에서 이벤트를 바인드하고 있음
        //$("#searchTaxRateNm").bind("keyup",function(event){
        //    if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
        //});

        $(window).smartresize(sheetResize); sheetInit();
    });

    //Sheet Action
    function doAction(sAction) {

    	// 부모창의 년도
        $("#searchYear").val($("#searchYear", parent.document).val());
        // 부모창의 세율명
        $("#searchTaxRateNm").val($("#searchTaxRateNm", parent.document).val());

        switch (sAction) {
        case "Search":      sheet1.DoSearch( "${ctx}/TaxStd.do?cmd=getTaxTab1StdList", $("#sheetForm").serialize() ); break;
        case "Save":        // 중복체크
				        	if(!dupChk(sheet1,"workYy|taxRateCd", false, true)){break;}
				        	IBS_SaveName(document.sheetForm,sheet1);
				        	sheet1.DoSave( "${ctx}/TaxStd.do?cmd=saveTaxTab1Std", $("#sheetForm").serialize()); break;
        case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), ""); break;
        case "Copy":        sheet1.SelectCell(sheet1.DataCopy(), 9); break;
        case "Clear":       sheet1.RemoveAll(); break;
        case "Down2Excel":  	var downcol = makeHiddenSkipCol(sheet1);
						        var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
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
        try { if (Msg != "") { alert(Msg); } doAction("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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


    // 세율관리 전년도 자료 복사
    function tariffTransData(){

    	// 전 년도를 기준으로 현재 년도로 복사를 한다.
    	var tariffMaxYear = $("#searchYear", parent.document).val();

    	if(tariffMaxYear == -1 || tariffMaxYear == ""){
    		alert("<msg:txt mid='alertNotCopyData' mdef='복사할 자료가 없습니다.'/>");
    	}else{
    		if(confirm((Number(tariffMaxYear)-1)+"년도 자료를 "+ (Number(tariffMaxYear))+"년도로 복사 하시겠습니까?")){

    			var data = ajaxCall("/TaxStd.do?cmd=prcTariffMaxYearCall","tariffMaxYear="+(Number(tariffMaxYear)-1)+"&tableName=TCPN501",false);
    			alert(data.Result.Message);
    			doAction("Search");
    		}
    	}
    }

</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchYear" name="searchYear" value=""/>
    <input type="hidden" id="searchTaxRateNm" name="searchTaxRateNm" value=""/>
    </form>
    <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <tr>
            <td>
                <div class="inner">
                    <div class="sheet_title">
                        <ul>
                            <li id="txt" class="txt"><tit:txt mid='taxTab1Std' mdef='세율관리'/></li>
                            <li class="btn">
                                <btn:a href="javascript:tariffTransData()"   css="basic authA" mid='111156' mdef="전년도 자료복사"/>
                                <btn:a href="javascript:doAction('Insert')" css="basic authA" mid='110700' mdef="입력"/>
                                <btn:a href="javascript:doAction('Copy')"   css="basic authA" mid='110696' mdef="복사"/>
                                <btn:a href="javascript:doAction('Save')"   css="basic authA" mid='110708' mdef="저장"/>
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
