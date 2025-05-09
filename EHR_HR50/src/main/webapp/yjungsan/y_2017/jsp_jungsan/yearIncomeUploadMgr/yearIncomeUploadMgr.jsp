<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연간소득</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		
		// 1번 그리드
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",				Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"삭제",				Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
			{Header:"상태",				Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"사원번호",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,   SaveName:"sabun",   			KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
			{Header:"성명",			    Type:"PopupEdit",	Hidden:0,  	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"name",   			KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"정산구분",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"adjust_type",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"정산년도",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"work_yy",			KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
			{Header:"년월",				Type:"Date",      	Hidden:0,  	Width:80,	Align:"Center",	ColMerge:0,   SaveName:"ym",   				KeyField:1,   CalcLogic:"",   Format:"Ym",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:6 },
			{Header:"월별\n내역",			Type:"Image",     	Hidden:1,  	Width:60,   Align:"Center",	ColMerge:0,	  SaveName:"detail",          	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"Pointer" },
			{Header:"급여액",				Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"pay_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"상여액",			    Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"bonus_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"인정상여",		    Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"etc_bonus_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"주식매수선택권\n행사이익",	Type:"AutoSum",		Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"stock_buy_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"우리사주조합\n인출금",	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"stock_union_mon",  	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"임원퇴직소득금액\n한도초과액",Type:"AutoSum",   Hidden:0,  	Width:100,	Align:"Right", 	ColMerge:0,   SaveName:"imwon_ret_over_mon",KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"생산\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"notax_work_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국외\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right", 	ColMerge:0,   SaveName:"notax_abroad_mon",  KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"식대\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_food_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"차량\n비과세",	    	Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_car_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"외국인\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_forn_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"연구활동\n비과세",		Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_research_mon",KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"출산보육\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_baby_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"수련보조수당\n비과세",			Type:"AutoSum",		Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_etc_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"일직료\n비과세",		Type:"AutoSum",		Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"notax_nightduty_mon",KeyField:0,  CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국민연금",		    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"pen_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"사립학교교직원연금",		Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon1",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"공무원연금",		    Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon2",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"군인연금",		    Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon3",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"별정우체국연금",		Type:"AutoSum",     Hidden:0,  	Width:120,	Align:"Right",	ColMerge:0,   SaveName:"etc_mon4",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"건강보험",		    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"hel_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"고용보험",		    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"emp_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"소득세",			    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"income_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"지방소득세",			Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",  ColMerge:0,   SaveName:"inhbt_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"농특세",			    Type:"AutoSum",     Hidden:0,  	Width:80,	Align:"Right",  ColMerge:0,   SaveName:"rural_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"감면\n세액",			Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"exmpt_tax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"외국인납세보전",		Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_tax_plus_mon", KeyField:0,   CalcLogic:"",   Format:"Integer",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"국외지급일자",			Type:"Date",     	Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_pay_ymd",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"외화",			    Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", tCount:0,   	UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"원화",			    Type:"AutoSum",     Hidden:1,  	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"frgn_ntax_mon",   	KeyField:0,   CalcLogic:"",   Format:"Integer", tCount:0,   	UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"기부금",				Type:"AutoSum",     Hidden:0, 	Width:80,	Align:"Right",	ColMerge:0,   SaveName:"labor_mon",   		KeyField:0,   CalcLogic:"",   Format:"Integer", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);
			
		sheet1.SetCountPosition(0);
		
		sheet1.SetImageList(0,"<%=imagePath%>/icon/icon_info.png");

		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");

		sheet1.SetColProperty("adjust_type", 		{ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
		$("#srchAdjustType").html(adjustTypeList[2]);

        $("#srchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus(); 
			}
		});
		
		$("#srchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus(); 
			}
		});
		
		$(window).smartresize(sheetResize); sheetInit();
        
		//doAction1("Search");
		
	});
	
    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
        	if($("#srchYear").val() == "") {
        		alert("정산년도를 입력하여 주십시오.");
        		return;
        	}
            sheet1.DoSearch( "<%=jspPath%>/yearIncomeUploadMgr/yearIncomeUploadMgrRst.jsp?cmd=selectYearIncomeUploadMgrLst", $("#srchFrm").serialize() ); 
            break;
        case "Save":
        	// 중복체크
			if (!dupChk(sheet1, "work_yy|adjust_type|sabun|ym", false, true)) {return;}
            sheet1.DoSave( "<%=jspPath%>/yearIncomeUploadMgr/yearIncomeUploadMgrRst.jsp?cmd=saveYearIncomeUploadMgr"); 
            break;
        case "Insert":
            var newRow = sheet1.DataInsert(0) ;
            break;
        case "Copy":
            sheet1.DataCopy();
            break;
        case "Clear":
            sheet1.RemoveAll();
            break;
        case "Down2Excel":
        	var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param);
            break;
        case "Down2Template":
            var param  = {DownCols:"sabun|name|adjust_type|work_yy|ym|pay_mon|bonus_mon|etc_bonus_mon|stock_buy_mon|stock_union_mon|imwon_ret_over_mon|notax_work_mon|notax_abroad_mon|notax_food_mon|notax_car_mon|notax_forn_mon|notax_research_mon|notax_baby_mon|notax_nightduty_mon|pen_mon|etc_mon1|etc_mon2|etc_mon3|etc_mon4|hel_mon|emp_mon|income_tax_mon|inhbt_tax_mon|rural_tax_mon|labor_mon",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
                ,TitleText:"",UserMerge :""		
            };
            sheet1.Down2Excel(param);
            break;
        case "LoadExcel":  
            
            var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
            sheet1.LoadExcel(params); 
            break;
        }
    }
    
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize(); 
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

	// 클릭시 발생.
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		}catch(ex){
			alert("OnSelectCell Event Error : " + ex);
		}
	}
	
	//팝업 클릭시 발생
    function sheet1_OnPopupClick(Row,Col) {
        try {
            if(sheet1.ColSaveName(Col) == "name") {
                openEmployeePopup(Row) ;
            }
        } catch(ex) {
            alert("OnPopupClick Event Error : " + ex);
        }
    }
	
    var gPRow  = "";
    var pGubun = "";
    
    //사원 조회
    function openEmployeePopup(Row){
        try{
            
            if(!isPopup()) {return;}
            gPRow = Row;
            pGubun = "employeePopup";
             
            var args    = new Array();
            var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
         
        } catch(ex) {
            alert("Open Popup Event Error : " + ex);
        }
    }
  
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
            //사원조회
            sheet1.SetCellValue(gPRow, "name",      rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",     rv["sabun"] );
        }
	}
	
	//업로드 완료후 호출
    function sheet1_OnLoadExcel(result) {
        try {

        } catch(ex) { 
            alert("OnLoadExcel Event Error " + ex); 
        }
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
    <div class="sheet_search outer">
        <div>
        <table>
        <tr>
            <td>
            	<span>년도</span>
				<input id="srchYear" name ="srchYear" type="text" class="text" maxlength="4" style="width:35px" value="<%=yeaYear%>"/>
			</td>
			<td>
				<span>작업구분</span>
				<select id="srchAdjustType" name ="srchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
			</td>
			<td>
				<span>사번/성명</span>
				<input id="srchSbNm" name ="srchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
			</td>
            <td>
            	<a href="javascript:doAction1('Search');" class="button">조회</a>
            </td>
        </tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">연간소득</li>
            <li class="btn">
              	<a href="javascript:doAction1('Down2Template')" class="basic authA">양식다운로드</a>
                <a href="javascript:doAction1('LoadExcel')"     class="basic authA">업로드</a>
                <a href="javascript:doAction1('Insert')"        class="basic authA">입력</a>
                <a href="javascript:doAction1('Copy')"          class="basic authA">복사</a>
                <a href="javascript:doAction1('Save')"          class="basic authA">저장</a>
                <a href="javascript:doAction1('Down2Excel')"    class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>