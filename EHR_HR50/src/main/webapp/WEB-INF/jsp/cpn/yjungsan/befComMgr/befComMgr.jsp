<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>종전근무지관리</title>
	<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<script src="${ctx}/common/js/employeeHeaderYtax.js" type="text/javascript" charset="utf-8"></script>
	<style>
		.red {
			color: #ff5c5c;
		}
	</style>
<script type="text/javascript">
var gPRow  = "";
var pGubun = "";
var isTarget = true;
var curRow = "";
    $(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD

		let now = new Date();
		$("#srchYear").val(now.getFullYear() - 1);

        // 1번 그리드
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"No",                    Type:"${sNoTy}",   Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",                  Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",                  Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"세부\n내역",  			 Type:"Image",     Hidden:0,  Width:50,    Align:"Center", ColMerge:0, SaveName:"selectImg",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, Cursor:"Pointer" },
            {Header:"년도",                  Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"workYy",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"정산구분",              Type:"Combo",     Hidden:0,  Width:60,    Align:"Left",   ColMerge:0, SaveName:"adjustType",         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사번",                  Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"sabun",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"순서",                  Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"seq",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"근무처명(1)",           Type:"Text",      Hidden:0,  Width:80,    Align:"Left",   ColMerge:0, SaveName:"enterNm",            KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"납세\n조합구분",        Type:"CheckBox",  Hidden:0,  Width:70,    Align:"Center", ColMerge:0, SaveName:"napseYn",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,    EditLen:100, TrueValue:"Y", FalseValue:"N" },

            {Header:"사업자등록번호(3)",                    Type:"Text",    Hidden:0,  Width:120,   Align:"Center", ColMerge:0, SaveName:"enterNo",            KeyField:1,   CalcLogic:"",   Format:"SaupNo",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"근무기간\n시작일(11)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"workSYmd",          KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"근무기간\n종료일(11)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"workEYmd",          KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"감면기간\n시작일(12)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"reduceSYmd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"감면기간\n종료일(12)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"reduceEYmd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"급여액(13)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"payMon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"상여액(14)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"bonusMon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"인정상여(15)",                         Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etcBonusMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"주식매수선택권\n행사이익(15-1)",       Type:"AutoSum", Hidden:0,  Width:100,   Align:"Right",  ColMerge:0, SaveName:"stockBuyMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"우리사주조합\n인출금(15-2)",           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"stockUnionMon",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"임원퇴직소득금액\n한도초과액(15-3)",   Type:"AutoSum", Hidden:0,  Width:100,   Align:"Right",  ColMerge:0, SaveName:"imwonRetOverMon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"소득세(73-79)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"incomeTaxMon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"지방소득세(73-80)",                       Type:"AutoSum", Hidden:0,  Width:100,    Align:"Right",  ColMerge:0, SaveName:"inhbtTaxMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"농특세(73-81)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"ruralTaxMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"국민연금",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"penMon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"사립학교\n교직원연금",                 Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etcMon1",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"공무원연금",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etcMon2",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"군인연금",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etcMon3",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"별정우체국연금",                       Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etcMon4",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"건강보험",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"helMon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"고용보험",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"empMon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"국외비과세(18)",                       Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxAbroadMon",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"식대비과세",                       Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxFoodMon",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"생산직비과세(18-1)",                   Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxWorkMon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"출산보육\n비과세(18-2)",               Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxBabyMon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"연구보조\n비과세(18-4)",               Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxResearchMon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"외국인\n비과세",                       Type:"AutoSum", Hidden:1,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxFornMon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"취재수당\n비과세(18-6)",                     Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxReporterMon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"수련보조수당\n비과세(19)",             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxTrainMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"기타\n비과세",             Type:"AutoSum", Hidden:1,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notaxEtcMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"결정세액(72)",             	 Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"finTotTaxMon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true); sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

        sheet1.SetCountPosition(4);

        // 2번 그리드
        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata2.Cols = [
            {Header:"No",        Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",       Type:"${sDelTy}", Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",       Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"년도",       Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"workYy",       KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"근무처명",    Type:"Text",        Hidden:0,  Width:40,    Align:"Center", ColMerge:0,   SaveName:"enterNm",       KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"정산구분",   Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"adjustType",   KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"사번",       Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"sabun",         KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"순서",       Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"seq",           KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"정산항목",   Type:"Combo",       Hidden:0,  Width:80,    Align:"Left",   ColMerge:0,   SaveName:"adjElementCd",KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"총액",		Type:"Int",		Hidden:0,  Width:80,   Align:"Right",  ColMerge:0,   SaveName:"mon",				KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"비과세or감면세액", Type:"Int", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0,   SaveName:"notaxMon",     KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
	        {Header:"과세액",		Type:"Int",		Hidden:0,  Width:80,   Align:"Right",  ColMerge:0,   SaveName:"taxMon",			KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 }
        ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);

        sheet2.SetCountPosition(4);

		let adjustTypeList = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd=C00303",false).codeList, "전체");
		sheet1.SetColProperty("adjustType",    {ComboText:"|"+adjustTypeList["C00303"][0], ComboCode:"|"+adjustTypeList["C00303"][1]} );

		let adjTypeCmbList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"queryId=getNoTaxCodeList",false).codeList, "");
		sheet2.SetColProperty("adjElementCd",    {ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );

		$("#srchAdjustType").html(adjustTypeList["C00303"][2]).val("1");
        $("#srchSabun").val( $("#searchUserId").val() );

        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    $(function() {
        $("#srchYear").bind("keyup",function(event){
            makeNumber(this,"A");
            if( event.keyCode == 13){
                doAction1("Search");
                $(this).focus();
            }
        });
    });

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            if($("#srchYear").val() == "") {
                alert("대상년도를 입력하여 주십시오.");
                return;
            }

			let adjTypeCmbList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&srchWorkYy="+$("#srchYear").val(),"queryId=getNoTaxCodeList",false).codeList, "");
			sheet2.SetColProperty("adjElementCd",    {ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );

            sheet1.DoSearch( "/BefComMgr.do?cmd=getBefComMgr", $("#srchFrm").serialize(), 1 );
            break;
        case "Save":
        	if(!isTarget) {
        		alert($("#srchYear").val()+" "+$("#srchAdjustType option:selected").text()+" 대상자가 아닙니다.");
        		break;
        	}
			IBS_SaveName(document.srchFrm, sheet1);
            sheet1.DoSave("/BefComMgr.do?cmd=saveBefComMgr", $("#srchFrm").serialize());
            break;
        case "Insert":
        	if(!isTarget) {
        		alert($("#srchYear").val()+" "+$("#srchAdjustType option:selected").text()+" 대상자가 아닙니다.");
        		break;
        	}
            if($("#srchYear").val() == "") {
                alert("년도를 입력하여 주십시오.");
                return ;
            }

            if($("#srchAdjustType").val() == "") {
                alert("정산구분을 선택 후 입력 할 수 있습니다.");
                return ;
            }

            var newRow = sheet1.DataInsert(0);
       		sheet1.SetCellValue(newRow, "workYy", 	$("#srchYear").val());
       		sheet1.SetCellValue(newRow, "adjustType", $("#srchAdjustType").val());
       		sheet1.SetCellValue(newRow, "sabun", 		$("#srchSabun").val());
       		sheet1.SetCellValue(newRow, "selectImg", "0");
       		doAction2("Clear");

            // openBefComMgrPopup(newRow);

            break;
        case "Copy":
        	if(!isTarget) {
        		alert($("#srchYear").val()+" "+$("#srchAdjustType option:selected").text()+" 대상자가 아닙니다.");
        		break;
        	}
        	var Row = sheet1.DataCopy();
            sheet1.SetCellValue(Row, "seq", "");

            openBefComMgrPopup(Row);

            break;
        case "Clear":
            sheet1.RemoveAll();
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
            sheet1.Down2Excel(param);
            break;
        }
    }

    //Sheet Action Second
    function doAction2(sAction) {

        switch (sAction) {
        case "Search":
            var param = "srchWorkYy="+sheet1.GetCellValue(sheet1.GetSelectRow(), "workYy")
                        +"&srchAdjustType="+sheet1.GetCellValue(sheet1.GetSelectRow(), "adjustType")
                        +"&srchSabun="+sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun")
                        +"&srchSeq="+sheet1.GetCellValue(sheet1.GetSelectRow(), "seq");

            sheet2.DoSearch( "/BefComMgr.do?cmd=getBefComMgrNoTax", param, 1);
            break;
        case "Save":
        	if(!isTarget) {
        		alert($("#srchYear").val()+" "+$("#srchAdjustType option:selected").text()+" 대상자가 아닙니다.");
        		break;
        	}
			IBS_SaveName(document.srchFrm, sheet2);
            sheet2.DoSave( "/BefComMgr.do?cmd=saveBefComMgrNoTax",$("#srchFrm").serialize());
            break;
        case "Insert":
        	if(!isTarget) {
        		alert($("#srchYear").val()+" "+$("#srchAdjustType option:selected").text()+" 대상자가 아닙니다.");
        		break;
        	}
            if( sheet1.GetSelectRow() <= 0 ){
                alert("상단의 종전근무지관리를 선택하여 주십시오.");
            } else if( sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I" ) {
                alert("상단의 종전근무지관리 입력상태 데이터에는\n하단의 종전근무지비과세를 입력 할 수 없습니다.");
            } else{
                var newRow = sheet2.DataInsert(0);

                sheet2.SetCellValue(newRow, "workYy", sheet1.GetCellValue(sheet1.GetSelectRow(), "workYy") );
                sheet2.SetCellValue(newRow, "adjustType", sheet1.GetCellValue(sheet1.GetSelectRow(), "adjustType") );
                sheet2.SetCellValue(newRow, "sabun", sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun") );
                sheet2.SetCellValue(newRow, "seq", sheet1.GetCellValue(sheet1.GetSelectRow(), "seq") );
            }
            break;
        case "Copy":
        	if(!isTarget) {
        		alert($("#srchYear").val()+" "+$("#srchAdjustType option:selected").text()+" 대상자가 아닙니다.");
        		break;
        	}
            sheet2.DataCopy();
            break;
        case "Clear":
            sheet2.RemoveAll();
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet2);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
            sheet2.Down2Excel(param);
            break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
			if (Msg != "") {
				alert(Msg);
			}
			getYeaCloseYn();
            sheetResize();

            if(Code == 0 && sheet1.SearchRows() == 0) {
            	doAction2("Search");
            }

        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
			if (Msg != "") {
				alert(Msg);
			}
			if(Code == 1) {
                doAction1("Search");
            }
        } catch(ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
        try{
            if(sheet1.GetSelectRow() > 0 && OldRow != NewRow) {
                doAction2('Search');
            }
            curRow = NewRow;
        } catch(ex){
            alert("OnSelectCell Event Error : " + ex);
        }
    }

    function sheet1_OnClick(Row, Col, Value){
	   	try{
		   	if( sheet1.ColSaveName(Col) == "select_img" ) {
		   		openBefComMgrPopup(Row);
		   	}

	   	}catch(ex){alert("OnClick Event Error : " + ex);}
   	}

    // 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
        	// checkCloseBtn(); //2019-11-14. 권한에 따라 버튼 처리

            var chkCnt1 = 0;
            var chkCnt2 = 0;
            var chkCnt3 = 0;

            var sheet1Seq = "";
			var sheet2Seq = "";
			var findTxt   = "";
			var alertMsg  = "";

			if(curRow > -1){

				sheet1Seq = sheet1.GetCellValue(curRow, "seq");

				if(sheet1.GetCellValue(curRow, "reduceSYmd") == "" && sheet1.GetCellValue(curRow, "reduceEYmd") == ""){
	                   if(sheet2.RowCount() > 0){
	                        for (i = 1; i < sheet2.RowCount()+1; i++){
	                            sheet2Seq = sheet2.GetCellValue(i, "seq");
	                            findTxt  = sheet2.GetCellText(i, "adjElementCd");
	                            if(sheet1Seq == sheet2Seq){
	                                if(findTxt.indexOf("감면") != -1){
	                                	chkCnt1++;
	                                }else{
	                                	chkCnt3++;
	                                }
	                            }
	                        }
	                    }else{
	                    	chkCnt3++;
	                    }
	            } else if((sheet1.GetCellValue(curRow, "reduceSYmd") == "" && sheet1.GetCellValue(curRow, "reduceEYmd") != "") ||
                          (sheet1.GetCellValue(curRow, "reduceSYmd") != "" && sheet1.GetCellValue(curRow, "reduceEYmd") == "")){
	            	if(sheet2.RowCount() > 0){
                        for (j = 1; j < sheet2.RowCount()+1; j++){
                            sheet2Seq = sheet2.GetCellValue(j, "seq");
                            findTxt  = sheet2.GetCellText(j, "adjElementCd");
                            if(sheet1Seq == sheet2Seq){
                                if(findTxt.indexOf("감면") != -1){
                                	if(sheet1.GetCellValue(curRow, "reduceSYmd") == ""){
                                		alertMsg = "감면기간 시작일을 입력해주세요.";
									}
                                	if(sheet1.GetCellValue(curRow, "reduceEYmd") == ""){
                                		alertMsg = "감면기간 종료일을 입력해주세요.";
									}
                                	chkCnt2++;
                                }else{
                                	chkCnt3++;
                                }
                            }
                        }
                    }else{
                    	chkCnt3++;
                    }
	            }else{
	            	if(sheet1.GetCellValue(curRow, "reduceSYmd") != "" && sheet1.GetCellValue(curRow, "reduceEYmd") != ""){
	                    if(sheet2.RowCount() > 0){
	                    	for (k = 1; k < sheet2.RowCount()+1; k++){
	                    		sheet2Seq = sheet2.GetCellValue(k, "seq");
	                    		findTxt   = sheet2.GetCellText(k, "adjElementCd");
	                    		if(sheet1Seq == sheet2Seq){
	                    			if(findTxt.indexOf("감면") != -1){
	                    				chkCnt3++;
	                    			}
	                    		}
	                    	}
	                    }
	            	}
	            }
			    if(chkCnt1 > 0){
			    	alert("감면기간을 입력해주세요.");
			    	return;
			    }else if(chkCnt2 > 0 ){
	        		alert(alertMsg);
	        		return;
	        	}else{
	        		if(chkCnt3 == 0){
	                    alert("감면기간이 존재합니다. \n하단 기타소득에 해당하는 감면 소득구분명 및 금액을 넣어주십시오.");
	                    return;
	                }
	        	}
        	}

			if (Msg != "") {
				alert(Msg);
			}
            sheetResize();
        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
			if (Msg != "") {
				alert(Msg);
			}
            if(Code == 1) {
                doAction2("Search");
            }
        } catch(ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
    // 값이 바뀔때 발생
    function sheet1_OnChange(Row, Col, Value) {
        try{
            var workSYmd =  sheet1.GetCellValue(Row, "workSYmd"); //근무기간시작일
            var workEYmd =  sheet1.GetCellValue(Row, "workEYmd"); //근무기간종료일
            var reSYmd =  sheet1.GetCellValue(Row, "reduceSYmd"); //감면기간시작일
            var reEYmd =  sheet1.GetCellValue(Row, "reduceEYmd"); //감면기간종료일

            //귀속년도 체크 param
            var workSYy = workSYmd.substring(0,4);
            var workEYy = workEYmd.substring(0,4);
            var resSYy = reSYmd.substring(0,4);
            var resEYy = reEYmd.substring(0,4);

            if(sheet1.ColSaveName(Col)  == "workSYmd") {
                if($("#srchYear").val() != workSYy && workSYy != ""){
                    alert("근무기간시작, 종료일은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+".01.01 ~ "+$("#srchYear").val()+".12.31");
                    sheet1.SetCellValue(Row, "workSYmd", "");
                    return;
                }
                if(workSYmd != "" && workEYmd != ""){
                    if(workSYmd > workEYmd){
                        alert("근무기간 시작일자는 근무기간 종료일자보다 작아야합니다.");
                        sheet1.SetCellValue(Row, "workSYmd", "");
                        return;
                    }
                }
            }
            if(sheet1.ColSaveName(Col)  == "workEYmd") {
                if($("#srchYear").val() != workEYy && workEYy != ""){
                    alert("근무기간시작, 종료일은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+".01.01 ~ "+$("#srchYear").val()+".12.31");
                    sheet1.SetCellValue(Row, "workEYmd", "");
                    return;
                }
                if(workSYmd != "" && workEYmd != ""){
                    if(workSYmd > workEYmd){
                        alert("근무기간 시작일자는 근무기간 종료일자보다 작아야합니다.");
                        sheet1.SetCellValue(Row, "workEYmd", "");
                        return;
                    }
                }
            }

            /* 감면기간 체크 */
			var flagMsg = "";
			if(sheet1.ColSaveName(Col)  == "reduceSYmd"){
				var redSFlag = true;
				if(reSYmd != ""){
					if($("#srchYear").val() != resSYy){
						//귀속년도가 아닐경우
						flagMsg = "감면기간시작, 종료일은 귀속연도에 포함되어야 합니다.";
						sheet1.SetCellValue(Row, "reduceSYmd", "");
						redSFlag = false;
					}else{
						//귀속년도일 경우
						if(!(reSYmd >= workSYmd && reSYmd <= workEYmd)){
							//근무기간에 포함되지 않을 경우
							flagMsg = "감면기간시작, 종료일은 근무기간에 포함되어야 합니다.";
							sheet1.SetCellValue(Row, "reduceSYmd", "");
							redSFlag = false;
						}else{
							if(reEYmd != "" && !(reSYmd <= reEYmd)){
								//종료일보다 적지 않을경우
								flagMsg = "감면기간 시작일은 감면기간 종료일자보다 작아야합니다.";
								sheet1.SetCellValue(Row, "reduceSYmd", "");
								redSFlag = false;
							}
						}
					}
				}
			}

			if(sheet1.ColSaveName(Col)  == "reduceEYmd"){
				var redEFlag = true;
				if(reEYmd != ""){
					if($("#srchYear").val() != resEYy){
						//귀속년도가 아닐경우
						flagMsg = "감면기간시작, 종료일은 귀속연도에 포함되어야 합니다.";
						sheet1.SetCellValue(Row, "reduceEYmd", "");
						redEFlag = false;
					}else{
						//귀속년도일 경우
						if(!(reEYmd >= workSYmd && reEYmd <= workEYmd)){
							//근무기간에 포함되지 않을 경우
							flagMsg = "감면기간시작, 종료일은 근무기간에 포함되어야 합니다.";
							sheet1.SetCellValue(Row, "reduceEYmd", "");
							redEFlag = false;
						}else{
							if(reSYmd != "" && !(reSYmd <= reEYmd)){
								//종료일보다 적지 않을경우
								flagMsg = "감면기간 시작일은 감면기간 종료일자보다 작아야합니다.";
								sheet1.SetCellValue(Row, "reduceEYmd", "");
								redEFlag = false;
							}
						}
					}
				}
			}
			if(!redSFlag && flagMsg != ""){
				alert(flagMsg);
				return;
			}else if(!redEFlag && flagMsg != ""){
				alert(flagMsg);
				return;
			}else{
				return;
			}
        } catch(ex) {
            alert("OnChange Event Error : " + ex);
        }
    }

	function sheet2_OnChange(Row, Col, Value) {
		try{
			if(sheet2.ColSaveName(Col) == "adjElementCd"){
				if(sheet2.GetCellValue(Row, "adjElementCd") == "C010_20" ||
						sheet2.GetCellValue(Row, "adjElementCd") == "C010_22" ||
						sheet2.GetCellValue(Row, "adjElementCd") == "C010_15" ){
						sheet2.SetCellEditable(Row, "mon", false);
						sheet2.SetCellValue(Row, "mon", "0");
				}else{
					sheet2.SetCellEditable(Row, "mon", true);
				}
			}

			var params = "searchWorkYy="+$("#srchYear").val();
		    params += "&searchStdCd="+sheet2.GetCellValue(Row, "adjElementCd");

			var result = ajaxCall("BefComMgr.do?cmd=getTaxYn",params,false).DATA;

			if(result != null && result.code == "Y"){
				// 총액 = 과세액 (mon == tax_mon)
				sheet2.SetCellValue(Row, "taxMon"  ,sheet2.GetCellValue(Row, "mon"));
				sheet2.SetCellValue(Row, "notaxMon",		"0"                     );
			}else{
				// 총액 = 비과세액or감면세액 (mon == notax_mon)
				sheet2.SetCellValue(Row, "notaxMon",sheet2.GetCellValue(Row, "mon"));
				sheet2.SetCellValue(Row, "taxMon"  ,		"0"                     );
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

    // 헤더에서 호출
    function setEmpPage() {
        $("#srchSabun").val( $("#searchUserId").val() );
        doAction1("Search");
    }

    function openBefComMgrPopup(Row) {
		if(!isPopup()) {return;}

		var w 		= 1050;
		var h 		= 580;
		var url 	= "/BefComMgr.do?cmd=viewBefComMgrPopup";
		var args 	= new Array();
		args["enterNm"]			= sheet1.GetCellValue(Row, "enterNm");
		args["napseYn"]			= sheet1.GetCellValue(Row, "napseYn");
		args["enterNo"]			= sheet1.GetCellValue(Row, "enterNo");
		args["workSYmd"]			= sheet1.GetCellValue(Row, "workSYmd");
		args["workEYmd"]			= sheet1.GetCellValue(Row, "workEYmd");
		args["reduceSYmd"]		= sheet1.GetCellValue(Row, "reduceSYmd");
		args["reduceEYmd"]		= sheet1.GetCellValue(Row, "reduceEYmd");
		args["payMon"]				= sheet1.GetCellValue(Row, "payMon");
		args["bonusMon"]			= sheet1.GetCellValue(Row, "bonusMon");
		args["etcBonusMon"]		= sheet1.GetCellValue(Row, "etcBonusMon");
		args["stockBuyMon"]		= sheet1.GetCellValue(Row, "stockBuyMon");
		args["stockUnionMon"]		= sheet1.GetCellValue(Row, "stockUnionMon");
		args["imwonRetOverMon"]	= sheet1.GetCellValue(Row, "imwonRetOverMon");
		args["incomeTaxMon"]		= sheet1.GetCellValue(Row, "incomeTaxMon");
		args["inhbtTaxMon"]		= sheet1.GetCellValue(Row, "inhbtTaxMon");
		args["ruralTaxMon"]		= sheet1.GetCellValue(Row, "ruralTaxMon");
		args["penMon"]				= sheet1.GetCellValue(Row, "penMon");
		args["etc_mon1"]			= sheet1.GetCellValue(Row, "etc_mon1");
		args["etc_mon2"]			= sheet1.GetCellValue(Row, "etc_mon2");
		args["etc_mon3"]			= sheet1.GetCellValue(Row, "etc_mon3");
		args["etc_mon4"]			= sheet1.GetCellValue(Row, "etc_mon4");
		args["hel_mon"]				= sheet1.GetCellValue(Row, "hel_mon");
		args["emp_mon"]				= sheet1.GetCellValue(Row, "emp_mon");
		args["notaxAbroadMon"]	= sheet1.GetCellValue(Row, "notaxAbroadMon");
		args["notaxWorkMon"]		= sheet1.GetCellValue(Row, "notaxWorkMon");
		args["notaxBabyMon"]		= sheet1.GetCellValue(Row, "notaxBabyMon");
		args["notaxResearchMon"]	= sheet1.GetCellValue(Row, "notaxResearchMon");
		args["notaxReporterMon"]	= sheet1.GetCellValue(Row, "notaxReporterMon");
		args["notaxTrainMon"]		= sheet1.GetCellValue(Row, "notaxTrainMon"); /* 2019.12.09.수련보조수당 비과세 */
		args["notaxEtcMon"]		= sheet1.GetCellValue(Row, "notaxEtcMon");   /* 2019.12.09.기타 비과세 */
		args["finTotTaxMon"]		= sheet1.GetCellValue(Row, "finTotTaxMon");   /* 2022.12.26.결정세액 */
		args["notaxFoodMon"]		= sheet1.GetCellValue(Row, "notaxFoodMon");

		gPRow = Row;
		pGubun = "befComMgrPopup";

		var rv = openPopup(url,args,w,h);
    }

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "befComMgrPopup" ){
			var Row = gPRow;
			sheet1.SetCellValue(Row, "enterNm", rv["enterNm"] );
			sheet1.SetCellValue(Row, "napseYn", rv["napseYn"] );
			sheet1.SetCellValue(Row, "enterNo", rv["enterNo"] );
			sheet1.SetCellValue(Row, "workSYmd", rv["workSYmd"] );
			sheet1.SetCellValue(Row, "workEYmd", rv["workEYmd"] );
			sheet1.SetCellValue(Row, "reduceSYmd", rv["reduceSYmd"] );
			sheet1.SetCellValue(Row, "reduceEYmd", rv["reduceEYmd"] );
			sheet1.SetCellValue(Row, "payMon", rv["payMon"] );
			sheet1.SetCellValue(Row, "bonusMon", rv["bonusMon"] );
			sheet1.SetCellValue(Row, "etcBonusMon", rv["etcBonusMon"] );
			sheet1.SetCellValue(Row, "stockBuyMon", rv["stockBuyMon"] );
			sheet1.SetCellValue(Row, "stockUnionMon", rv["stockUnionMon"] );
			sheet1.SetCellValue(Row, "imwonRetOverMon", rv["imwonRetOverMon"] );
			sheet1.SetCellValue(Row, "incomeTaxMon", rv["incomeTaxMon"] );
			sheet1.SetCellValue(Row, "inhbtTaxMon", rv["inhbtTaxMon"] );
			sheet1.SetCellValue(Row, "ruralTaxMon", rv["ruralTaxMon"] );
			sheet1.SetCellValue(Row, "penMon", rv["penMon"] );
			sheet1.SetCellValue(Row, "etcMon1", rv["etcMon1"] );
			sheet1.SetCellValue(Row, "etcMon2", rv["etcMon2"] );
			sheet1.SetCellValue(Row, "etcMon3", rv["etcMon3"] );
			sheet1.SetCellValue(Row, "etcMon4", rv["etcMon4"] );
			sheet1.SetCellValue(Row, "helMon", rv["helMon"] );
			sheet1.SetCellValue(Row, "empMon", rv["empMon"] );
			sheet1.SetCellValue(Row, "notaxAbroadMon", rv["notaxAbroadMon"] );
			sheet1.SetCellValue(Row, "notaxWorkMon", rv["notaxWorkMon"] );
			sheet1.SetCellValue(Row, "notaxBabyMon", rv["notaxBabyMon"] );
			sheet1.SetCellValue(Row, "notaxResearchMon", rv["notaxResearchMon"] );
			sheet1.SetCellValue(Row, "notaxReporterMon", rv["notaxReporterMon"] );
			sheet1.SetCellValue(Row, "notaxTrainMon", rv["notaxTrainMon"] ); /* 2019.12.09.수련보조수당 비과세 */
			sheet1.SetCellValue(Row, "notaxEtcMon", rv["notaxEtcMon"] );     /* 2019.12.09.기타 비과세 */
			sheet1.SetCellValue(Row, "finTotTaxMon", rv["finTotTaxMon"] );     /* 2022.12.26.결정세액 */
			sheet1.SetCellValue(Row, "notaxFoodMon", rv["notaxFoodMon"] );
		}
	}

	//2019-11-14. 권한에 따라 버튼 처리
	<%--function checkCloseBtn(){--%>
	<%--	var yeaCloseParam = "searchWorkYy="+$("#srchYear").val()+"&searchAdjustType="+$("#srchAdjustType").val()+"&searchSabun="+$("#srchSabun").val();--%>
    <%--    var yeaCloseInfo = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectYeaDataDefaultInfo", yeaCloseParam,false);--%>

    <%--    if(yeaCloseInfo.Result.Code == 1) {--%>
	<%--		if(yeaCloseInfo.Data.final_close_yn == "Y" || yeaCloseInfo.Data.apprv_yn == "Y"|| yeaCloseInfo.Data.input_close_yn == "Y") {--%>
	<%--			if(yeaCloseInfo.Data.final_close_yn == "Y" || yeaCloseInfo.Data.apprv_yn == "Y"){--%>
	<%--				//최종마감 또는 관리자 마감일때 버튼 미노출--%>
	<%--				$("#btn_1").hide();--%>
	<%--	            $("#btn_2").hide();--%>
	<%--	            sheet1.SetEditable(0);--%>
	<%--	            sheet2.SetEditable(0);--%>
	<%--			} else if(yeaCloseInfo.Data.input_close_yn == "Y" && comSearchType == 'P'){--%>
	<%--				//본인마감이고 조회구분이 '자신만 조회'일때 버튼 미노출--%>
	<%--				$("#btn_1").hide();--%>
	<%--	            $("#btn_2").hide();--%>
	<%--	            sheet1.SetEditable(0);--%>
	<%--	            sheet2.SetEditable(0);--%>
	<%--			} else {--%>
	<%--				$("#btn_1").show();--%>
	<%--	            $("#btn_2").show();--%>
	<%--	            sheet1.SetEditable(1);--%>
	<%--	            sheet2.SetEditable(1);--%>
	<%--			}--%>
	<%--		} else {--%>
	<%--			$("#btn_1").show();--%>
	<%--            $("#btn_2").show();--%>
	<%--            sheet1.SetEditable(1);--%>
	<%--            sheet2.SetEditable(1);--%>
	<%--		}--%>
	<%--	}--%>
	<%--}--%>

	//마감정보 조회
	function getYeaCloseYn() {
		var closeYn = "N";
		var yeaCloseInfo = getYearDefaultInfoObj();

		$("#closeYnFont").hide();

		if(yeaCloseInfo != null) {
			isTarget = true;
			if(typeof yeaCloseInfo.sabun == "undefined") {
				closeYn = "Y";
				isTarget = false;
				$("#tdStatusView").html("<font size=2><b>[<font class='red'>대상자가 아닙니다.</font>]</b></font>");
			} else if(yeaCloseInfo.finalCloseYn == "Y" || yeaCloseInfo.apprvYn == "Y"|| yeaCloseInfo.inputCloseYn == "Y") {
				closeYn = "Y";
				if(yeaCloseInfo.finalCloseYn == "Y"){
					$("#tdStatusView").html("<font size=2><b>[현재 <font class='red'>최종마감</font> 상태입니다.]</b></font>");
				} else if(yeaCloseInfo.apprvYn == "Y"){
					$("#tdStatusView").html("<font size=2><b>[현재 <font class='red'>담당자마감</font> 상태입니다.]</b></font>");
				} else if(yeaCloseInfo.inputCloseYn == "Y"){
					$("#tdStatusView").html("<font size=2><b>[현재 <font class='red'>본인마감</font> 상태입니다.]</b></font>");
					$("#closeYnFont").show();
				}
			} else {
				closeYn = "N";
				$("#tdStatusView").html("<font size=2><b>[현재 <font class='red'>본인 마감전</font> 상태입니다.]</b></font>");
			}
		}

		return closeYn;
	}

	//기본정보 조회
	function getYearDefaultInfoObj() {
		var param = "searchWorkYy="+$("#srchYear").val();
	    param += "&searchAdjustType="+$("#srchAdjustType").val();
	    param += "&searchSabun="+$("#srchSabun").val();

		return ajaxCall("BefComMgr.do?cmd=getYeaDataDefaultInfo", param,false).DATA;
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">

		<%@ include file="/WEB-INF/jsp/common/include/employeeHeaderYtax.jsp"%>
		<div class="sheet_search outer">
			<form id="srchFrm" name="srchFrm">
			<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
			<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
			<input type="hidden" id="srchSabun" name="srchSabun" value="" />
			<input type="hidden" id="menuNm" name="menuNm" value="" />
				<div>
					<table>
						<tr>
							<td>
							<span>대상년도</span>
							<%
								if (!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd"))
								&& !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd"))
								&& !"SHN".equals(session.getAttribute("ssnEnterCd"))) {
							%>
								<input id="srchYear" name="srchYear" type="text" class="text center" maxlength="4" style="width: 10%"/>
							<%}else{%>
								<input id="srchYear" name="srchYear" type="text" class="text center readonly" maxlength="4" style="width: 10%" readonly />
							<%}%>
							</td>
							<td><span>작업구분</span> <select id="srchAdjustType"
								name="srchAdjustType" onChange="javascript:doAction1('Search')"
								class="box"></select></td>
							<td><a href="javascript:doAction1('Search')" class="button">조회</a>
							</td>
						</tr>
					</table>
				</div>
			</form>
		</div>

		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li class="txt">종전근무지관리 <span class="txt red">※ 소득세 및
							지방소득세는 결정세액을 입력하여 주십시오.(차감징수세액 아님)</span>
					</li>
					<li class="btn"><span id="btn_1">
					        <font id="closeYnFont" class="blue" style="display: none;"><b>[본인마감] 되었습니다</b></font>&nbsp;&nbsp;
					        <a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
							<a href="javascript:doAction1('Copy')" class="basic authA">복사</a>
							<a href="javascript:doAction1('Save')" class="basic btn-save authA">저장</a>
					</span> <a href="javascript:doAction1('Down2Excel')" class="basic btn-download authR">다운로드</a>
					</li>
				</ul>
			</div>
		</div>

		<script type="text/javascript">
			createIBSheet("sheet1", "100%", "50%");
		</script>
		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li class="txt">종전근무지기타소득
						<span class="txt red">※ 감면금액이 있을경우 상단에 감면기간 시작일, 종료일을 기입해 주십시오.</span>
					</li>
					<li class="btn"><span id="btn_2">
					        <a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
							<a href="javascript:doAction2('Copy')" class="basic authA">복사</a>
							<a href="javascript:doAction2('Save')" class="basic btn-save authA">저장</a>
					</span> <a href="javascript:doAction2('Down2Excel')" class="basic btn-download authR">다운로드</a>
					</li>
				</ul>
			</div>
		</div>
		<script type="text/javascript">
			createIBSheet("sheet2", "100%", "50%");
		</script>

	</div>
</body>
</html>