<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>계산방법예외관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    $(function() {
	    $("#srchYmFrom").datepicker2({ymonly:true});    	
	    $("#srchYmTo").datepicker2({ymonly:true});    	    	
        
        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"), 	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"항목코드",		Type:"Text",		Hidden:0,	Width:60,	Align:"Left",		ColMerge:0,		SaveName:"element_cd",			KeyField:1,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:0 },
			{Header:"항목명",			Type:"Popup",		Hidden:0,	Width:130,	Align:"Left",		ColMerge:0,		SaveName:"element_nm",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사원번호",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",		ColMerge:0,		SaveName:"sabun",				KeyField:1,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:0 },
			{Header:"성명",			Type:"Popup",		Hidden:0,	Width:90,	Align:"Center",		ColMerge:0,		SaveName:"name",				KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:0 },
			{Header:"계산방법",		Type:"Text",      	Hidden:0,  	Width:250,  Align:"Left",  		ColMerge:0,   	SaveName:"formula",  			KeyField:1,   	Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"시작년월",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"s_ym",				KeyField:1,		Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:6 },
			{Header:"종료년월",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"e_ym",				KeyField:0,		Format:"Ym",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
			{Header:"적용여부",		Type:"CheckBox",  	Hidden:0,  	Width:80,   Align:"Center",  	ColMerge:0,   	SaveName:"apply_yn",			KeyField:0,   	Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus(); 
			}
		});
		
		$("#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus(); 
			}
		});		
		
        $(window).smartresize(sheetResize);
        sheetInit();
        
        doAction1("Search"); 
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        
	        case "Search":
	            sheet1.DoSearch( "<%=jspPath%>/calcExpressionExclMgr/calcExpressionExclMgrRst.jsp?cmd=selectCalcExpressionExclMgrList", $("#sheetForm").serialize() ); 
	            break;
	        case "Save":
	        	// 중복체크
				if (!dupChk(sheet1, "element_cd|sabun", false, true)) {return;}
	            sheet1.DoSave( "<%=jspPath%>/calcExpressionExclMgr/calcExpressionExclMgrRst.jsp?cmd=saveCalcExpressionExclMgr"); 
	            break;
	        case "Insert":
	            var Row = sheet1.DataInsert(0) ;
	            sheet1.SetCellValue(Row, "apply_yn", "Y") ;
	            sheet1.SetCellValue(Row, "s_ym", "${ssnBaseDate}".substring(0,6));
	            break;
	        case "Copy":
	            sheet1.DataCopy();
	            break;
			case "LoadExcel":   //엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet1.Down2Excel(param);
				break;				
			case "Down2Template":
				downCols = "element_cd|sabun|formula|s_ym|e_ym|apply_yn";
				var param  = {DownCols:downCols,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"};
				sheet1.Down2Excel(param);
				break;	            
        }
    }

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { 
            alertMessage(Code, Msg, StCode, StMsg);
            sheetResize(); 
        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex); 
        }
    }

    //저장 후 메시지
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

    var gPRow  = "";
    var pGubun = "";
    
	//팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}else if(sheet1.ColSaveName(Col) == "element_nm") {
				openPayElementPopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
        
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
	
	//수당 항목조회
	function openPayElementPopup(Row){
	    try{
	    	
	    	if(!isPopup()) {return;}
		    gPRow = Row;
			pGubun = "payElementPopup";
			 
		    var args    = new Array();
		    var rv = openPopup("<%=jspPath%>/calcExpressionMgr/payElementPopup.jsp?authPg=R", args,  "740","520");

	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}   	
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
		}else if ( pGubun == "payElementPopup" ){
			sheet1.SetCellValue(gPRow, "element_cd"				, rv["element_cd"] );
			sheet1.SetCellValue(gPRow, "element_nm"				, rv["element_nm"] );
		}
	}    
    
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <div class="sheet_search outer">
        <div>
        <table>
            <tr>
				<td>
					<span>대상년월 </span>
					<input id="srchYmFrom" name="srchYmFrom" class="date2" />
					~ 
					<input id="srchYmTo" name="srchYmTo" class="date2" />
				</td>
                <td><span>수당</span>
                	<input id="searchNm" name="searchNm" type="text" class="text" maxlength="15" style="width:100px"/> 
                </td>            
                <td><span>사번/성명</span>
	                <input id="searchSbNm" name="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> 
	            </td>
                <td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
            </tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">계산방법예외관리</li>
            <li class="btn">
				<a href="javascript:doAction1('Down2Template')" class="basic authA">양식다운로드</a>
                <a href="javascript:doAction1('Insert')"        class="basic authA">입력</a>
                <a href="javascript:doAction1('Copy')"          class="basic authA">복사</a>
                <a href="javascript:doAction1('Save')"          class="basic authA">저장</a>
				<a href="javascript:doAction1('LoadExcel')"     class="basic authA">업로드</a>
                <a href="javascript:doAction1('Down2Excel')"    class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>