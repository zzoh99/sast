<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>종전근무지관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow  = "";
var pGubun = "";
var isTarget = true;
var curRow = "";
var copyYn = "";

    $(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD

        // 1번 그리드
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"No",                    Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",                  Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",                  Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"세부\n내역",  			 Type:"Image",     Hidden:0,  Width:50,    Align:"Center", ColMerge:0, SaveName:"select_img",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, Cursor:"Pointer" },
            {Header:"년도",                  Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"work_yy",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"정산구분",              Type:"Combo",     Hidden:0,  Width:150,    Align:"Center",   ColMerge:0, SaveName:"adjust_type",         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사번",                  Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"sabun",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"순서",                  Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"seq",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"근무처명\n(1)",           Type:"Text",      Hidden:0,  Width:80,    Align:"Left",   ColMerge:0, SaveName:"enter_nm",            KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"납세\n조합구분",        Type:"CheckBox",  Hidden:0,  Width:70,    Align:"Center", ColMerge:0, SaveName:"napse_yn",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,    EditLen:100, TrueValue:"Y", FalseValue:"N" },

            {Header:"사업자등록번호\n(3)",                    Type:"Text",    Hidden:0,  Width:120,   Align:"Center", ColMerge:0, SaveName:"enter_no",            KeyField:1,   CalcLogic:"",   Format:"SaupNo",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"근무기간\n시작일(11)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"work_s_ymd",          KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"근무기간\n종료일(11)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"work_e_ymd",          KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"감면기간\n시작일(12)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"reduce_s_ymd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"감면기간\n종료일(12)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"reduce_e_ymd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"급여액\n(13)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"pay_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"상여액\n(14)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"bonus_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"인정상여\n(15)",                         Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etc_bonus_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"주식매수선택권\n행사이익(15-1)",       Type:"AutoSum", Hidden:0,  Width:100,   Align:"Right",  ColMerge:0, SaveName:"stock_buy_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"우리사주조합\n인출금(15-2)",           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"stock_union_mon",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"임원퇴직소득금액\n한도초과액(15-3)",   Type:"AutoSum", Hidden:0,  Width:100,   Align:"Right",  ColMerge:0, SaveName:"imwon_ret_over_mon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            //20240411 "직무발명한도초과액"은 key-in하지 않음. 기타소득의 "직무발명수당" 금액 있으면 세금계산할 때, 종전+주현 한도를 종합 체크해서 과세필드에 자동 업데이트 함
            {Header:"국외근로\n비과세(18)",                       Type:"AutoSum", Hidden:0,  Width:85,    Align:"Right",  ColMerge:0, SaveName:"notax_abroad_mon",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"야간근로(생산)\n비과세(18-1)",         Type:"AutoSum", Hidden:0,  Width:85,    Align:"Right",  ColMerge:0, SaveName:"notax_work_mon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"보육\n비과세(18-2)",               Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_baby_mon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"연구보조(H09)\n비과세(18-4)",               Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_research_mon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"취재수당\n비과세(18-5)",                     Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_reporter_mon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"식대\n비과세(18-40)",                    Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_food_mon",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"수련보조수당\n비과세(19)",             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_train_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"외국인\n비과세",                       Type:"AutoSum", Hidden:1,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_forn_mon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"기타\n비과세",             Type:"AutoSum", Hidden:1,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_etc_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"소득세\n(73행 79열)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"income_tax_mon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"지방소득세\n(73행 80열)",                       Type:"AutoSum", Hidden:0,  Width:100,    Align:"Right",  ColMerge:0, SaveName:"inhbt_tax_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"농특세\n(73행 81열)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"rural_tax_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"국민연금",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"pen_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"공무원연금",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etc_mon2",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"군인연금",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etc_mon3",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"사립학교\n교직원연금",                 Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etc_mon1",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"별정우체국\n연금",                       Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etc_mon4",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"건강보험",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"hel_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"고용보험",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"emp_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"결정세액(72)",             	 Type:"AutoSum", Hidden:1,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"fin_tot_tax_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true); sheet1.SetImageList(0,"<%=imagePath%>/icon/icon_popup.png");

        sheet1.SetCountPosition(4);

        // 2번 그리드
        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata2.Cols = [
            {Header:"No",         Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",       Type:"<%=sDelTy%>", Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",       Type:"<%=sSttTy%>", Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"년도",       Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"work_yy",       KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"근무처명",    Type:"Text",        Hidden:0,  Width:40,    Align:"Center", ColMerge:0,   SaveName:"enter_nm",       KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"정산구분",   Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"adjust_type",   KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"사번",       Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"sabun",         KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"순서",       Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"seq",           KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"정산항목",   Type:"Combo",       Hidden:0,  Width:80,    Align:"Left",   ColMerge:0,   SaveName:"adj_element_cd",KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"총액",		Type:"Int",		Hidden:0,  Width:80,   Align:"Right",  ColMerge:0,   SaveName:"mon",				KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"비과세or감면세액", Type:"Int", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0,   SaveName:"notax_mon",     KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
	        {Header:"과세액",		Type:"Int",		Hidden:0,  Width:80,   Align:"Right",  ColMerge:0,   SaveName:"tax_mon",			KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 }
        ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);

        sheet2.SetCountPosition(4);

        var adjTypeCmbList = stfConvCode( codeList("<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=selectNoTaxCodeList&srchWorkYy="+$("#srchYear").val(),"") , "");

        sheet2.SetColProperty("adj_element_cd",    {ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );
        $("#srchSabun").val( $("#searchUserId").val() );

        $(window).smartresize(sheetResize); sheetInit();
        
		<% if ( "P".equals(String.valueOf(session.getAttribute("ssnSearchType"))) ) { 
			   /*---------------------- 임직원공통 본인만조회 권한일 경우는, 재정산 코드 표시하지 않음 ------------------------*/ %>
		        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00303"), "전체");
		        sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
		        $("#srchAdjustType").html(adjustTypeList[2]).val("1");
		<% } else { %>
		   		getCprBtnChk(); // 관리자나 권한범위 권한일 경우는, 재정산 코드 표시
		<% } %>
        
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

            var adjTypeCmbList = stfConvCode( codeList("<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=selectNoTaxCodeList&srchWorkYy="+$("#srchYear").val(),"") , "");
            sheet2.SetColProperty("adj_element_cd",    {ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );

            sheet1.DoSearch( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=selectBefComMgr", $("#srchFrm").serialize(), 1 );
            break;
        case "Save":
        	if(!isTarget) {
        		alert($("#srchYear").val()+" "+$("#srchAdjustType option:selected").text()+" 대상자가 아닙니다.");
        		break;
        	}
            sheet1.DoSave( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=saveBefComMgr",$("#srchFrm").serialize());
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
       		sheet1.SetCellValue(newRow, "work_yy", 	$("#srchYear").val());
       		sheet1.SetCellValue(newRow, "adjust_type", $("#srchAdjustType").val());
       		sheet1.SetCellValue(newRow, "sabun", 		$("#srchSabun").val());
       		sheet1.SetCellValue(newRow, "select_img", "0");
       		doAction2("Clear");

            openBefComMgrPopup(newRow);

            break;
        case "Copy":
        	if(!isTarget) {
        		alert($("#srchYear").val()+" "+$("#srchAdjustType option:selected").text()+" 대상자가 아닙니다.");
        		break;
        	}
        	copyYn = "Y";
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
            var param = "srchWorkYy="+sheet1.GetCellValue(sheet1.GetSelectRow(), "work_yy")
                        +"&srchAdjustType="+sheet1.GetCellValue(sheet1.GetSelectRow(), "adjust_type")
                        +"&srchSabun="+sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun")
                        //+"&srchSeq="+sheet1.GetCellValue(sheet1.GetSelectRow(), "seq");
                        
            if(copyYn != "Y") {
				param = param+"&srchSeq="+sheet1.GetCellValue(sheet1.GetSelectRow(), "seq");
			} else {
				param = param+"&srchSeq=";
			}

            sheet2.DoSearch( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=selectBefComMgrNoTax", param, 1 );
            break;
        case "Save":
        	if(!isTarget) {
        		alert($("#srchYear").val()+" "+$("#srchAdjustType option:selected").text()+" 대상자가 아닙니다.");
        		break;
        	}
            sheet2.DoSave( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=saveBefComMgrNoTax",$("#srchFrm").serialize());
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

                sheet2.SetCellValue(newRow, "work_yy", sheet1.GetCellValue(sheet1.GetSelectRow(), "work_yy") );
                sheet2.SetCellValue(newRow, "adjust_type", sheet1.GetCellValue(sheet1.GetSelectRow(), "adjust_type") );
                sheet2.SetCellValue(newRow, "sabun", sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun") );
                sheet2.SetCellValue(newRow, "enter_nm", sheet1.GetCellValue(sheet1.GetSelectRow(), "enter_nm") );
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
            alertMessage(Code, Msg, StCode, StMsg);
            getYeaCloseYn();
            sheetResize();

            if(Code == 1 && sheet1.RowCount() == 0) {
            	doAction2("Search");
            }

        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
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
        	checkCloseBtn(); //2019-11-14. 권한에 따라 버튼 처리

            var chkCnt1 = 0;
            var chkCnt2 = 0;
            var chkCnt3 = 0;

            var sheet1Seq = "";
			var sheet2Seq = "";
			var findTxt   = "";
			var alertMsg  = "";
			
			if(curRow != "" && copyYn != "Y"){

				sheet1Seq = sheet1.GetCellValue(curRow, "seq");

				if(sheet1.GetCellValue(curRow, "reduce_s_ymd") == "" && sheet1.GetCellValue(curRow, "reduce_e_ymd") == ""){
	                   if(sheet2.RowCount() > 0){
	                        for (i = 1; i < sheet2.RowCount()+1; i++){
	                            sheet2Seq = sheet2.GetCellValue(i, "seq");
	                            findTxt  = sheet2.GetCellText(i, "adj_element_cd");
	                            if(sheet1Seq == sheet2Seq){
									if(typeof findTxt === "string" && findTxt.indexOf("감면") != -1){
	                                	chkCnt1++;
	                                }else{
	                                	chkCnt3++;
	                                }
	                            }
	                        }
	                    }else{
	                    	chkCnt3++;
	                    }
	            } else if((sheet1.GetCellValue(curRow, "reduce_s_ymd") == "" && sheet1.GetCellValue(curRow, "reduce_e_ymd") != "") ||
                          (sheet1.GetCellValue(curRow, "reduce_s_ymd") != "" && sheet1.GetCellValue(curRow, "reduce_e_ymd") == "")){
	            	if(sheet2.RowCount() > 0){
                        for (j = 1; j < sheet2.RowCount()+1; j++){
                            sheet2Seq = sheet2.GetCellValue(j, "seq");
                            findTxt  = sheet2.GetCellText(j, "adj_element_cd");
                            if(sheet1Seq == sheet2Seq){
								if(typeof findTxt === "string" && findTxt.indexOf("감면") != -1){
                                	if(sheet1.GetCellValue(curRow, "reduce_s_ymd") == ""){
                                		alertMsg = "감면기간 시작일을 입력해주세요.";
									}
                                	if(sheet1.GetCellValue(curRow, "reduce_e_ymd") == ""){
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
	            	if(sheet1.GetCellValue(curRow, "reduce_s_ymd") != "" && sheet1.GetCellValue(curRow, "reduce_e_ymd") != ""){
	                    if(sheet2.RowCount() > 0){
	                    	for (k = 1; k < sheet2.RowCount()+1; k++){
	                    		sheet2Seq = sheet2.GetCellValue(k, "seq");
	                    		findTxt   = sheet2.GetCellText(k, "adj_element_cd");
	                    		if(sheet1Seq == sheet2Seq){
									if(typeof findTxt === "string" && findTxt.indexOf("감면") != -1){
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
			copyYn = "N";

            alertMessage(Code, Msg, StCode, StMsg);
            sheetResize();
        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
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
            var workSYmd =  sheet1.GetCellValue(Row, "work_s_ymd"); //근무기간시작일
            var workEYmd =  sheet1.GetCellValue(Row, "work_e_ymd"); //근무기간종료일
            var reSYmd =  sheet1.GetCellValue(Row, "reduce_s_ymd"); //감면기간시작일
            var reEYmd =  sheet1.GetCellValue(Row, "reduce_e_ymd"); //감면기간종료일

            //귀속년도 체크 param
            var workSYy = workSYmd.substring(0,4);
            var workEYy = workEYmd.substring(0,4);
            var resSYy = reSYmd.substring(0,4);
            var resEYy = reEYmd.substring(0,4);

            if(sheet1.ColSaveName(Col)  == "work_s_ymd") {
                if($("#srchYear").val() != workSYy && workSYy != ""){
                    alert("근무기간시작, 종료일은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+".01.01 ~ "+$("#srchYear").val()+".12.31");
                    sheet1.SetCellValue(Row, "work_s_ymd", "");
                    return;
                }
                if(workSYmd != "" && workEYmd != ""){
                    if(workSYmd > workEYmd){
                        alert("근무기간 시작일자는 근무기간 종료일자보다 작아야합니다.");
                        sheet1.SetCellValue(Row, "work_s_ymd", "");
                        return;
                    }
                }
            }
            if(sheet1.ColSaveName(Col)  == "work_e_ymd") {
                if($("#srchYear").val() != workEYy && workEYy != ""){
                    alert("근무기간시작, 종료일은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+".01.01 ~ "+$("#srchYear").val()+".12.31");
                    sheet1.SetCellValue(Row, "work_e_ymd", "");
                    return;
                }
                if(workSYmd != "" && workEYmd != ""){
                    if(workSYmd > workEYmd){
                        alert("근무기간 시작일자는 근무기간 종료일자보다 작아야합니다.");
                        sheet1.SetCellValue(Row, "work_e_ymd", "");
                        return;
                    }
                }
            }

            /* 감면기간 체크 */
			var flagMsg = "";
			if(sheet1.ColSaveName(Col)  == "reduce_s_ymd"){
				var redSFlag = true;
				if(reSYmd != ""){
					if($("#srchYear").val() != resSYy){
						//귀속년도가 아닐경우
						flagMsg = "감면기간시작, 종료일은 귀속연도에 포함되어야 합니다.";
						sheet1.SetCellValue(Row, "reduce_s_ymd", "");
						redSFlag = false;
					}else{
						//귀속년도일 경우
						if(!(reSYmd >= workSYmd && reSYmd <= workEYmd)){
							//근무기간에 포함되지 않을 경우
							flagMsg = "감면기간시작, 종료일은 근무기간에 포함되어야 합니다.";
							sheet1.SetCellValue(Row, "reduce_s_ymd", "");
							redSFlag = false;
						}else{
							if(reEYmd != "" && !(reSYmd <= reEYmd)){
								//종료일보다 적지 않을경우
								flagMsg = "감면기간 시작일은 감면기간 종료일자보다 작아야합니다.";
								sheet1.SetCellValue(Row, "reduce_s_ymd", "");
								redSFlag = false;
							}
						}
					}
				}
			}

			if(sheet1.ColSaveName(Col)  == "reduce_e_ymd"){
				var redEFlag = true;
				if(reEYmd != ""){
					if($("#srchYear").val() != resEYy){
						//귀속년도가 아닐경우
						flagMsg = "감면기간시작, 종료일은 귀속연도에 포함되어야 합니다.";
						sheet1.SetCellValue(Row, "reduce_e_ymd", "");
						redEFlag = false;
					}else{
						//귀속년도일 경우
						if(!(reEYmd >= workSYmd && reEYmd <= workEYmd)){
							//근무기간에 포함되지 않을 경우
							flagMsg = "감면기간시작, 종료일은 근무기간에 포함되어야 합니다.";
							sheet1.SetCellValue(Row, "reduce_e_ymd", "");
							redEFlag = false;
						}else{
							if(reSYmd != "" && !(reSYmd <= reEYmd)){
								//종료일보다 적지 않을경우
								flagMsg = "감면기간 시작일은 감면기간 종료일자보다 작아야합니다.";
								sheet1.SetCellValue(Row, "reduce_e_ymd", "");
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

	function sheet2_OnChange(Row, Col, Value, OldValue) {
		try{
			if(sheet2.ColSaveName(Col) == "adj_element_cd"){
				if(sheet2.GetCellValue(Row, "adj_element_cd") == "C010_20" ||
						sheet2.GetCellValue(Row, "adj_element_cd") == "C010_22" ||
						sheet2.GetCellValue(Row, "adj_element_cd") == "C010_15" ){
						sheet2.SetCellEditable(Row, "mon", false);
						sheet2.SetCellValue(Row, "mon", "0");
				}
				//출산지원금은 출산지원금내역관리 화면에서 입력 할 수 있도록 체크로직 추가
				else if(sheet2.GetCellValue(Row, "adj_element_cd") == "C010_156" ||
						sheet2.GetCellValue(Row, "adj_element_cd") == "C010_157"){
					alert("출산지원금(Q03, Q04) 관련정보는 \n [소득공제자료관리 > 출산지원금내역관리] 화면에서 입력해 주시길 바랍니다. \n(임직원일 경우 담당자에게 문의 바랍니다.)");
					sheet2.SetCellValue(Row, "adj_element_cd", "");
					return;
				}else if(sheet2.GetCellValue(Row, "adj_element_cd") == "C010_159") {
					//위탁보육료비과세 입력하지 않도록 체크로직 추가
					alert("위탁보육료비과세는 미신고 대상입니다.");
					sheet2.SetCellValue(Row, "adj_element_cd", "");
					return;
				}else{
					sheet2.SetCellEditable(Row, "mon", true);
				}
			}
			
			if(sheet2.ColSaveName(Col) == "mon"||sheet2.ColSaveName(Col) == "sDelete"){
				if(sheet2.GetCellValue(Row, "adj_element_cd") == "C010_156" ||
						sheet2.GetCellValue(Row, "adj_element_cd") == "C010_157"){
					alert("출산지원금(Q03, Q04) 관련정보는 [출산지원금내역관리]화면에서 입력해 주시길 바랍니다. \n(임직원일 경우 담당자에게 문의 바랍니다.)");
					if(sheet2.ColSaveName(Col) == "mon") {
						sheet2.SetCellValue(Row, "mon", OldValue, 0);	
					} else {
						sheet2.SetCellValue(Row, "sDelete", OldValue, 0);	
					}
					return;
				}
			}
			
			var params = "searchWorkYy="+$("#srchYear").val();
		    params += "&searchStdCd="+sheet2.GetCellValue(Row, "adj_element_cd");
		    params += "&queryId=commonSelectTaxYn";

			var result = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params,false);
	
			if(result.Data.code == "Y"){
				// 총액 = 과세액 (mon == tax_mon)
				sheet2.SetCellValue(Row, "tax_mon"  ,sheet2.GetCellValue(Row, "mon"));
				sheet2.SetCellValue(Row, "notax_mon",		"0"                     );
			}else{
				// 총액 = 비과세액or감면세액 (mon == notax_mon)
				sheet2.SetCellValue(Row, "notax_mon",sheet2.GetCellValue(Row, "mon"));
				sheet2.SetCellValue(Row, "tax_mon"  ,		"0"                     );
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

    // 헤더에서 호출
    function setEmpPage() {
        $("#srchSabun").val( $("#searchUserId").val() );
        
   		<% /* 관리자나 권한범위 권한일 경우는, 재정산 코드 표시*/
   		   if ( !"P".equals(String.valueOf(session.getAttribute("ssnSearchType"))) ) { %> 
			getCprBtnChk();
		<% } %>

        curRow = "";
        
        doAction1("Search");
    }

    function openBefComMgrPopup(Row) {
		if(!isPopup()) {return;}

		var w 		= 1050;
		var h 		= 580;
		var url 	= "<%=jspPath%>/befComMgr/befComMgrPopup.jsp?authPg=<%=authPg%>";
		var args 	= new Array();
		args["srchYear"]		    = sheet1.GetCellValue(Row, "work_yy");
		args["enter_nm"]			= sheet1.GetCellValue(Row, "enter_nm");
		args["napse_yn"]			= sheet1.GetCellValue(Row, "napse_yn");
		args["enter_no"]			= sheet1.GetCellValue(Row, "enter_no");
		args["work_s_ymd"]			= sheet1.GetCellValue(Row, "work_s_ymd");
		args["work_e_ymd"]			= sheet1.GetCellValue(Row, "work_e_ymd");
		args["reduce_s_ymd"]		= sheet1.GetCellValue(Row, "reduce_s_ymd");
		args["reduce_e_ymd"]		= sheet1.GetCellValue(Row, "reduce_e_ymd");
		args["pay_mon"]				= sheet1.GetCellValue(Row, "pay_mon");
		args["bonus_mon"]			= sheet1.GetCellValue(Row, "bonus_mon");
		args["etc_bonus_mon"]		= sheet1.GetCellValue(Row, "etc_bonus_mon");
		args["stock_buy_mon"]		= sheet1.GetCellValue(Row, "stock_buy_mon");
		args["stock_union_mon"]		= sheet1.GetCellValue(Row, "stock_union_mon");
		args["imwon_ret_over_mon"]	= sheet1.GetCellValue(Row, "imwon_ret_over_mon");
		args["income_tax_mon"]		= sheet1.GetCellValue(Row, "income_tax_mon");
		args["inhbt_tax_mon"]		= sheet1.GetCellValue(Row, "inhbt_tax_mon");
		args["rural_tax_mon"]		= sheet1.GetCellValue(Row, "rural_tax_mon");
		args["pen_mon"]				= sheet1.GetCellValue(Row, "pen_mon");
		args["etc_mon1"]			= sheet1.GetCellValue(Row, "etc_mon1");
		args["etc_mon2"]			= sheet1.GetCellValue(Row, "etc_mon2");
		args["etc_mon3"]			= sheet1.GetCellValue(Row, "etc_mon3");
		args["etc_mon4"]			= sheet1.GetCellValue(Row, "etc_mon4");
		args["hel_mon"]				= sheet1.GetCellValue(Row, "hel_mon");
		args["emp_mon"]				= sheet1.GetCellValue(Row, "emp_mon");
		args["notax_abroad_mon"]	= sheet1.GetCellValue(Row, "notax_abroad_mon");
		args["notax_work_mon"]		= sheet1.GetCellValue(Row, "notax_work_mon");
		args["notax_baby_mon"]		= sheet1.GetCellValue(Row, "notax_baby_mon");
		args["notax_research_mon"]	= sheet1.GetCellValue(Row, "notax_research_mon");
		args["notax_reporter_mon"]	= sheet1.GetCellValue(Row, "notax_reporter_mon");
		args["notax_train_mon"]		= sheet1.GetCellValue(Row, "notax_train_mon"); /* 2019.12.09.수련보조수당 비과세 */
		args["notax_etc_mon"]		= sheet1.GetCellValue(Row, "notax_etc_mon");   /* 2019.12.09.기타 비과세 */
		args["fin_tot_tax_mon"]		= sheet1.GetCellValue(Row, "fin_tot_tax_mon");   /* 2022.12.26.결정세액 */
		args["notax_food_mon"]		= sheet1.GetCellValue(Row, "notax_food_mon");

		gPRow = Row;
		pGubun = "befComMgrPopup";

		var rv = openPopup(url,args,w,h);
    }

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "befComMgrPopup" ){
			var Row = gPRow;
			sheet1.SetCellValue(Row, "enter_nm", rv["enter_nm"] );
			sheet1.SetCellValue(Row, "napse_yn", rv["napse_yn"] );
			sheet1.SetCellValue(Row, "enter_no", rv["enter_no"] );
			sheet1.SetCellValue(Row, "work_s_ymd", rv["work_s_ymd"] );
			sheet1.SetCellValue(Row, "work_e_ymd", rv["work_e_ymd"] );
			sheet1.SetCellValue(Row, "reduce_s_ymd", rv["reduce_s_ymd"] );
			sheet1.SetCellValue(Row, "reduce_e_ymd", rv["reduce_e_ymd"] );
			sheet1.SetCellValue(Row, "pay_mon", rv["pay_mon"] );
			sheet1.SetCellValue(Row, "bonus_mon", rv["bonus_mon"] );
			sheet1.SetCellValue(Row, "etc_bonus_mon", rv["etc_bonus_mon"] );
			sheet1.SetCellValue(Row, "stock_buy_mon", rv["stock_buy_mon"] );
			sheet1.SetCellValue(Row, "stock_union_mon", rv["stock_union_mon"] );
			sheet1.SetCellValue(Row, "imwon_ret_over_mon", rv["imwon_ret_over_mon"] );
			sheet1.SetCellValue(Row, "income_tax_mon", rv["income_tax_mon"] );
			sheet1.SetCellValue(Row, "inhbt_tax_mon", rv["inhbt_tax_mon"] );
			sheet1.SetCellValue(Row, "rural_tax_mon", rv["rural_tax_mon"] );
			sheet1.SetCellValue(Row, "pen_mon", rv["pen_mon"] );
			sheet1.SetCellValue(Row, "etc_mon1", rv["etc_mon1"] );
			sheet1.SetCellValue(Row, "etc_mon2", rv["etc_mon2"] );
			sheet1.SetCellValue(Row, "etc_mon3", rv["etc_mon3"] );
			sheet1.SetCellValue(Row, "etc_mon4", rv["etc_mon4"] );
			sheet1.SetCellValue(Row, "hel_mon", rv["hel_mon"] );
			sheet1.SetCellValue(Row, "emp_mon", rv["emp_mon"] );
			sheet1.SetCellValue(Row, "notax_abroad_mon", rv["notax_abroad_mon"] );
			sheet1.SetCellValue(Row, "notax_work_mon", rv["notax_work_mon"] );
			sheet1.SetCellValue(Row, "notax_baby_mon", rv["notax_baby_mon"] );
			sheet1.SetCellValue(Row, "notax_research_mon", rv["notax_research_mon"] );
			sheet1.SetCellValue(Row, "notax_reporter_mon", rv["notax_reporter_mon"] );
			sheet1.SetCellValue(Row, "notax_train_mon", rv["notax_train_mon"] ); /* 2019.12.09.수련보조수당 비과세 */
			sheet1.SetCellValue(Row, "notax_etc_mon", rv["notax_etc_mon"] );     /* 2019.12.09.기타 비과세 */
			sheet1.SetCellValue(Row, "fin_tot_tax_mon", rv["fin_tot_tax_mon"] );     /* 2022.12.26.결정세액 */
			sheet1.SetCellValue(Row, "notax_food_mon", rv["notax_food_mon"] );
		}
	}

	//2019-11-14. 권한에 따라 버튼 처리
	function checkCloseBtn(){
		var yeaCloseParam = "searchWorkYy="+$("#srchYear").val()+"&searchAdjustType="+$("#srchAdjustType").val()+"&searchSabun="+$("#srchSabun").val();
        var yeaCloseInfo = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectYeaDataDefaultInfo", yeaCloseParam,false);

        if(yeaCloseInfo.Result.Code == 1) {
			if(yeaCloseInfo.Data.final_close_yn == "Y" || yeaCloseInfo.Data.apprv_yn == "Y"|| yeaCloseInfo.Data.input_close_yn == "Y") {
				if(yeaCloseInfo.Data.final_close_yn == "Y" || yeaCloseInfo.Data.apprv_yn == "Y"){
					//최종마감 또는 관리자 마감일때 버튼 미노출
					$("#btn_1").hide();
		            $("#btn_2").hide();
		            sheet1.SetEditable(0);
		            sheet2.SetEditable(0);
				} else if(yeaCloseInfo.Data.input_close_yn == "Y" && comSearchType == 'P'){
					//본인마감이고 조회구분이 '자신만 조회'일때 버튼 미노출
					$("#btn_1").hide();
		            $("#btn_2").hide();
		            sheet1.SetEditable(0);
		            sheet2.SetEditable(0);
				} else {
					$("#btn_1").show();
		            $("#btn_2").show();
		            sheet1.SetEditable(1);
		            sheet2.SetEditable(1);
				}
			} else {
				$("#btn_1").show();
	            $("#btn_2").show();
	            sheet1.SetEditable(1);
	            sheet2.SetEditable(1);
			}
		}
	}

	//마감정보 조회
	function getYeaCloseYn() {
		var closeYn = "N";
		var yeaCloseInfo = getYearDefaultInfoObj();

		$("#closeYnFont").hide();

		if(yeaCloseInfo.Result.Code == 1) {
			isTarget = true;
			if(typeof yeaCloseInfo.Data.sabun == "undefined") {
				closeYn = "Y";
				isTarget = false;
				$("#tdStatusView").html("<font size=2><b>[<font class='red'>대상자가 아닙니다.</font>]</b></font>");
			} else if(yeaCloseInfo.Data.final_close_yn == "Y" || yeaCloseInfo.Data.apprv_yn == "Y"|| yeaCloseInfo.Data.input_close_yn == "Y") {
				closeYn = "Y";
				if(yeaCloseInfo.Data.final_close_yn == "Y"){
					$("#tdStatusView").html("<font size=2><b>[현재 <font class='red'>최종마감</font> 상태입니다.]</b></font>");
				} else if(yeaCloseInfo.Data.apprv_yn == "Y"){
					$("#tdStatusView").html("<font size=2><b>[현재 <font class='red'>담당자마감</font> 상태입니다.]</b></font>");
				} else if(yeaCloseInfo.Data.input_close_yn == "Y"){
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

		return ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectYeaDataDefaultInfo", param,false);
	}
	
	//수정(이력) 관련 세팅
	function getCprBtnChk(){
	    var params = "&cmbMode=all"
            + "&searchWorkYy=" + $("#srchYear").val()
            + "&searchAdjustType=" 
            + "&searchSabun=" + $("#srchSabun").val(); //사번이 확정되는 [개별] 화면은 대상자별로 조회 가능
	
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#srchAdjustType").html("");
		} else {   			
			$("#srchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
		}
	}	
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">

		<%@ include file="../common/include/employeeHeaderYtax.jsp"%>
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
							<input id="srchYear" name="srchYear" type="text" class="text center readonly" maxlength="4" style="width: 35px" value="<%=yeaYear%>" readonly />
							</td>
							<td><span>정산구분</span> <select id="srchAdjustType"
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