<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>종전근무지관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>
<%
//우리카드 직원 입력 시 팝업창 안되어지는 현상 으로 인하여 예외 처리 CHK/JSG 20170116
String hideDet = "" ;
if("WC".equals(session.getAttribute("ssnEnterCd")) ) {
	hideDet = "1" ;
} else {
	hideDet = "0" ;
}
%>
<script type="text/javascript">
var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";

var gPRow  = "";
var pGubun = "";

    $(function() {

        // 1번 그리드
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:9, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"No",                    Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
            {Header:"삭제",                  Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
            {Header:"상태",                  Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
            {Header:"세부\n내역",  			Type:"Image",     Hidden:1,  Width:50,   Align:"Center",  ColMerge:0, SaveName:"select_img",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, Cursor:"Pointer" },
            {Header:"년도",                  Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"work_yy",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"정산구분",              Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"adjust_type",         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"사번",                  Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"sabun",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"순서",                  Type:"Text",      Hidden:1,  Width:245,   Align:"Left",   ColMerge:0, SaveName:"seq",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"근무처명(1)",           Type:"Text",      Hidden:0,  Width:80,    Align:"Left",   ColMerge:0, SaveName:"enter_nm",            KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"납세\n조합구분",        Type:"CheckBox",  Hidden:0,  Width:70,    Align:"Center", ColMerge:0, SaveName:"napse_yn",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,    EditLen:100, TrueValue:"Y", FalseValue:"N" },
            
            {Header:"사업자등록번호(3)",                    Type:"Text",    Hidden:0,  Width:120,   Align:"Center", ColMerge:0, SaveName:"enter_no",            KeyField:1,   CalcLogic:"",   Format:"SaupNo",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"근무기간\n시작일(11)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"work_s_ymd",          KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"근무기간\n종료일(11)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"work_e_ymd",          KeyField:1,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"감면기간\n시작일(12)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"reduce_s_ymd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"감면기간\n종료일(12)",                 Type:"Date",    Hidden:0,  Width:90,    Align:"Center", ColMerge:0, SaveName:"reduce_e_ymd",        KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"급여액(13)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"pay_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"상여액(14)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"bonus_mon",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"인정상여(15)",                         Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etc_bonus_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"주식매수선택권\n행사이익(15-1)",       Type:"AutoSum", Hidden:0,  Width:100,   Align:"Right",  ColMerge:0, SaveName:"stock_buy_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"우리사주조합\n인출금(15-2)",           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"stock_union_mon",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"임원퇴직소득금액\n한도초과액(15-3)",   Type:"AutoSum", Hidden:0,  Width:100,   Align:"Right",  ColMerge:0, SaveName:"imwon_ret_over_mon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"소득세(72-78)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"income_tax_mon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"지방소득세(72-79)",                       Type:"AutoSum", Hidden:0,  Width:100,    Align:"Right",  ColMerge:0, SaveName:"inhbt_tax_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"농특세(80)",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"rural_tax_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"국민연금",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"pen_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35},
            {Header:"사립학교\n교직원연금",                 Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etc_mon1",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"공무원연금",                           Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etc_mon2",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"군인연금",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etc_mon3",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"별정우체국연금",                       Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"etc_mon4",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"건강보험",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"hel_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35},
            {Header:"고용보험",                             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"emp_mon",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35},
            {Header:"국외\n비과세(18)",                       Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_abroad_mon",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"생산직\n비과세(18-1)",                   Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_work_mon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"출산보육\n비과세(18-2)",               Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_baby_mon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"연구보조\n비과세(18-4)",               Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_research_mon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"외국인\n비과세",                       Type:"AutoSum", Hidden:1,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_forn_mon",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"취재수당\n비과세(18-6)",                     Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_reporter_mon",  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"수련보조수당\n비과세(19)",             Type:"AutoSum", Hidden:0,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_train_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 },
            {Header:"기타\n비과세",             Type:"AutoSum", Hidden:1,  Width:80,    Align:"Right",  ColMerge:0, SaveName:"notax_etc_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 }
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
            {Header:"정산구분",   Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"adjust_type",   KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"사번",       Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"sabun",         KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"순서",       Type:"Text",        Hidden:1,  Width:80,    Align:"Center", ColMerge:0,   SaveName:"seq",           KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"정산항목",   Type:"Combo",       Hidden:0,  Width:80,    Align:"Left",   ColMerge:0,   SaveName:"adj_element_cd",KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"비과세금액", Type:"Int",         Hidden:0,  Width:80,    Align:"Right",  ColMerge:0,   SaveName:"notax_mon",     KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35, MinimumValue: 0 }
        ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);
        
        sheet2.SetCountPosition(4);
        
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");
        var adjTypeCmbList = stfConvCode( codeList("<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=selectNoTaxCodeList&srchWorkYy="+$("#srchYear").val(),"") , "");

        sheet2.SetColProperty("adj_element_cd",    {ComboText:"|"+adjTypeCmbList[0], ComboCode:"|"+adjTypeCmbList[1]} );
        $("#srchAdjustType").html(adjustTypeList[2]);

        $(window).smartresize(sheetResize); sheetInit();
        
		/*필수 기본 세팅*/
		$("#srchYear").val( $("#searchWorkYy", parent.document).val() ) ;
		$("#srchAdjustType").val( $("#searchAdjustType", parent.document).val() ) ;
		$("#srchSabun").val( $("#searchSabun", parent.document).val() ) ;
		
		//2019-11-13. 담당자 마감일때 수정 불가 처리
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		if(orgAuthPg == "A" && (empStatus == "close_3" || empStatus == "close_4")) {
			$("#btn_1").hide() ;
            $("#btn_2").hide() ;
            sheet1.SetEditable(false) ;
            sheet2.SetEditable(false) ;
		}
<%--
        if(orgAuthPg == "A") {
            $("#btn_1").show() ;
            $("#btn_2").show() ;
            sheet1.SetEditable("<%=editable%>") ;
            sheet2.SetEditable("<%=editable%>") ;
        } else {
            $("#btn_1").hide() ;
            $("#btn_2").hide() ;
            sheet1.SetEditable(false) ;
            sheet2.SetEditable(false) ;
        }
--%>
		
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
            sheet1.DoSave( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=saveBefComMgr"); 
            break;
        case "Insert":  
        	if($("#srchYear").val() == "") {
                alert("년도를 입력하여 주십시오.");
                return ; 
            }
            
        	var newRow = sheet1.DataInsert(0) ;
       		sheet1.SetCellValue(newRow, "work_yy", 	$("#srchYear").val()); 
       		sheet1.SetCellValue(newRow, "adjust_type", $("#srchAdjustType").val()); 
       		sheet1.SetCellValue(newRow, "sabun", 		$("#srchSabun").val()); 
       		sheet1.SetCellValue(newRow, "select_img", "0");
       		doAction2("Clear") ;
       		
            openBefComMgrPopup(newRow);

            break;
        case "Copy":        
        	var Row = sheet1.DataCopy();
            sheet1.SetCellValue(Row, "seq", ""); 
            
            openBefComMgrPopup(Row);
            break;

        case "Clear":       
            sheet1.RemoveAll();
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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
                        +"&srchSeq="+sheet1.GetCellValue(sheet1.GetSelectRow(), "seq");
            
            sheet2.DoSearch( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=selectBefComMgrNoTax", param, 1 ); 
            break;

        case "Save":
            sheet2.DoSave( "<%=jspPath%>/befComMgr/befComMgrRst.jsp?cmd=saveBefComMgrNoTax"); 
            break;
        case "Insert":
            if( sheet1.GetSelectRow() <= 0 ){
                alert("상단의 종전근무지관리를 선택하여 주십시오.");
            } else if( sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I" ) {
                alert("상단의 종전근무지관리 입력상태 데이터에는\n하단의 종전근무지비과세를 입력 할 수 없습니다.");
            } else{
                var newRow = sheet2.DataInsert(0);
            
                sheet2.SetCellValue(newRow, "work_yy", sheet1.GetCellValue(sheet1.GetSelectRow(), "work_yy") );
                sheet2.SetCellValue(newRow, "adjust_type", sheet1.GetCellValue(sheet1.GetSelectRow(), "adjust_type") );
                sheet2.SetCellValue(newRow, "sabun", sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun") );
                sheet2.SetCellValue(newRow, "seq", sheet1.GetCellValue(sheet1.GetSelectRow(), "seq") );
            }
            break;
        case "Copy":
            sheet2.DataCopy();
            break;

        case "Clear":
            sheet2.RemoveAll();
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet2);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet2.Down2Excel(param);
            break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
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
			parent.getYearDefaultInfoObj();
            if(Code == 1) {
				parent.doSearchCommonSheet();
				if("Y" == "<%=adminYn%>") {
					parent.getTotPay() ;
				}
                doAction1("Search");
            }
        } catch(ex) {
            alert("OnSaveEnd Event Error " + ex); 
        }
    }
    // 값이 바뀔때 발생
    function sheet1_OnChange(Row, Col, Value) {
    	try{
	    	var reSYmd =  sheet1.GetCellValue(Row, "reduce_s_ymd"); //감면기간시작일
	    	var reEYmd =  sheet1.GetCellValue(Row, "reduce_e_ymd"); //감면기간종료일
	    	
	    	var subReSYmd = reSYmd.substring(0,4);
	    	var subReEYmd = reEYmd.substring(0,4);
	    	
	    	if(sheet1.ColSaveName(Col)	== "reduce_s_ymd") {	    		
	    		if($("#srchYear").val() != subReSYmd && subReSYmd != ""){
	    			alert("감면기간시작, 종료일은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+".01.01 ~ "+$("#srchYear").val()+".12.31");
	    			sheet1.SetCellValue(Row, "reduce_s_ymd", "");
	    			return;
	    		}
	    		if(reSYmd != "" && reEYmd != ""){
		    		if(reSYmd > reEYmd){
		    			alert("감면기간 시작일자는 감면기간 종료일자보다 작아야합니다.");
		    			sheet1.SetCellValue(Row, "reduce_s_ymd", "");
		    			return;
		    		}	
	    		}
	    	}
	    	if(sheet1.ColSaveName(Col)	== "reduce_e_ymd") {
	    		if($("#srchYear").val() != subReEYmd && subReEYmd != ""){
	    			alert("감면기간시작, 종료일은 귀속연도에 포함되어야 합니다.\n Ex) "+$("#srchYear").val()+".01.01 ~ "+$("#srchYear").val()+".12.31");
	    			sheet1.SetCellValue(Row, "reduce_e_ymd", "");
	    			return;
	    		}
	    		if(reSYmd != "" && reEYmd != ""){
		    		if(reSYmd > reEYmd){
		    			alert("감면기간 종료일자는 감면기간  시작일자보다 커야합니다.");
		    			sheet1.SetCellValue(Row, "reduce_e_ymd", "");
		    			return;
		    		}
	    		}
	    	}
    	} catch(ex) {
            alert("OnChange Event Error : " + ex);
        }
    }    
    function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
        try{
            if(sheet1.GetSelectRow() > 0 && OldRow != NewRow) {
                doAction2('Search');
            }
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
    
    function openBefComMgrPopup(Row) {
		if(!isPopup()) {return;}
		
   		//우리카드 직원 입력 시 팝업창 안되어지는 현상 으로 인하여 예외 처리 CHK/JSG 20170116
   		if("<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>" == "WC") { return ; }
		
   		var w 		= 900;
		var h 		= 580;
		var url 	= "<%=jspPath%>/befComMgr/befComMgrPopup.jsp?authPg=<%=authPg%>";
		var args 	= new Array();
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
		args["notax_etc_mon"]		= sheet1.GetCellValue(Row, "notax_etc_mon"); /* 2019.12.09.기타 비과세 */
		
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
			sheet1.SetCellValue(Row, "notax_etc_mon", rv["notax_etc_mon"] ); /* 2019.12.09.기타 비과세 */
		}
	}
</script>
</head>
<body class="bodywrap" style="overflow-y: auto;">
<div class="wrapper" >

    <div class="sheet_search outer" style="display:none;">
    <form id="srchFrm" name="srchFrm" >
        <input type="hidden" id="srchSabun"         name="srchSabun"        value ="" />
        <div>
        <table>
        <tr>
            <td>
                <span>대상년도</span>
                <input id="srchYear" name ="srchYear" type="text" class="text" maxlength="4" style="width:35px" value="<%=yeaYear%>"/>
            </td>
            <td>
                <span>작업구분</span>
                <select id="srchAdjustType" name ="srchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
            </td>
            <td>
                <a href="javascript:doAction1('Search')" class="button">조회</a>
            </td>
        </tr>
        </table>
        </div>
    </form>
    </div>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">종전근무지관리
            <span class="txt" style="color:red">※ 소득세 및 지방소득세는 결정세액을 입력하여 주십시오.(차감징수세액 아님)</span>
            </li>
            <li class="btn">
            	<a href="javascript:doAction1('Search');" class="button">조회</a>
            	<span id="btn_1">
              		<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
              		<a href="javascript:doAction1('Copy')"   class="basic authA">복사</a>
              		<a href="javascript:doAction1('Save')"   class="basic authA">저장</a>
            	</span>
              	<a href="javascript:doAction1('Down2Excel')"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "250px"); </script>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">종전근무지비과세
            	<span class="txt" style="color:red">※ 감면금액이 있을경우 상단에 감면기간 시작일, 종료일을 기입해 주십시오.</span>
            </li>
            <li class="btn">
            	<span id="btn_2">
              		<a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
              		<a href="javascript:doAction2('Copy')"   class="basic authA">복사</a>
              		<a href="javascript:doAction2('Save')"   class="basic authA">저장</a>
            	</span>
              	<a href="javascript:doAction2('Down2Excel')"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "250px"); </script>

</div>
</body>
</html>