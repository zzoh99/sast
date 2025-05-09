<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>계산방법관리</title>
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
			{Header:"계산식순번",		Type:"Text",		Hidden:1,	Width:0,	Align:"Center",		ColMerge:0,		SaveName:"formula_seq",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:0 },
			{Header:"항목코드",		Type:"Text",		Hidden:1,	Width:0,	Align:"Center",		ColMerge:0,		SaveName:"element_cd",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:0 },
			{Header:"항목명",			Type:"Popup",		Hidden:0,	Width:90,	Align:"Left",		ColMerge:0,		SaveName:"element_nm",			KeyField:1,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:0 },
			{Header:"Report명",		Type:"Text",		Hidden:0,	Width:90,	Align:"Left",		ColMerge:0,		SaveName:"report_nm",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:0 },
			{Header:"항목Link유형",	Type:"Text",		Hidden:0,	Width:80,	Align:"Left",		ColMerge:0,		SaveName:"element_link_type_nm",KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:0 },
			{Header:"검색순번",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",		ColMerge:0,		SaveName:"search_seq",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상자검색설명",	Type:"Popup",		Hidden:0,	Width:130,	Align:"Left",		ColMerge:0,		SaveName:"search_desc",			KeyField:0,		Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"계산방법(기본)",	Type:"Text",      	Hidden:0,  	Width:200,  Align:"Left",  		ColMerge:0,   	SaveName:"formula_ori",  		KeyField:0,   	Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:0 },
			{Header:"계산방법(변경)",	Type:"Text",      	Hidden:0,  	Width:200,  Align:"Left",  		ColMerge:0,   	SaveName:"formula_chg",  		KeyField:0,   	Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"표시여부",		Type:"CheckBox",  	Hidden:0,  	Width:80,   Align:"Center",  	ColMerge:0,   	SaveName:"display_yn",			KeyField:0,   	Format:"",     	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"시작년월",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"s_ym",				KeyField:1,		Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:6 },
			{Header:"종료년월",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"e_ym",				KeyField:0,		Format:"Ym",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:6 },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		$("#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus(); 
			}
		});
		
        $(window).smartresize(sheetResize);
        sheetInit();
        
        getCpnFormulaBtnYn();
        
        doAction1("Search"); 
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        
	        case "Search":
	            sheet1.DoSearch( "<%=jspPath%>/calcExpressionMgr/calcExpressionMgrRst.jsp?cmd=selectCalcExpressionMgrList", $("#sheetForm").serialize() ); 
	            break;
	        case "Save":
	        	// 중복체크
				if (!dupChk(sheet1, "element_cd|search_seq|s_ym", false, true)) {return;}
	            sheet1.DoSave( "<%=jspPath%>/calcExpressionMgr/calcExpressionMgrRst.jsp?cmd=saveCalcExpressionMgr"); 
	            break;
	        case "Insert":
	            var Row = sheet1.DataInsert(0) ;
	            sheet1.SetCellValue(Row, "s_ym", "${ssnBaseDate}".substring(0,6));
	            sheet1.SetCellValue(Row, "display_yn", "Y");
	            
	            break;
	        case "Copy":
	            sheet1.DataCopy();
	            break;
			case "Batch": 		
				showHelpPop();
				break;	      
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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
			if(sheet1.ColSaveName(Col) == "element_nm") {
				openPayElementPopup(Row) ;
			}else if(sheet1.ColSaveName(Col) == "search_desc") {
				openPwrSrchMgrPopup(Row) ;
			}
		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
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
		
	//조건검색 조회
	function openPwrSrchMgrPopup(Row){
	    try{
	    	
	    	if(!isPopup()) {return;}
		    gPRow = Row;
			pGubun = "pwrSrchMgrPopup";
			 
		    var args    = new Array();
		    var rv = openPopup("<%=jspPath%>/calcExpressionMgr/pwrSrchMgrPopup.jsp?authPg=R", args, "1100","520");
		    
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}   
    	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "payElementPopup" ){
			sheet1.SetCellValue(gPRow, "element_cd"				, rv["element_cd"] );
			sheet1.SetCellValue(gPRow, "element_nm"				, rv["element_nm"] );
			sheet1.SetCellValue(gPRow, "element_link_type_nm"	, rv["element_link_type"] );
			sheet1.SetCellValue(gPRow, "report_nm"				, rv["report_nm"] );
		}else if(pGubun == "pwrSrchMgrPopup" ){
			sheet1.SetCellValue(gPRow, "search_seq"				, rv["search_seq"] );
			sheet1.SetCellValue(gPRow, "search_desc"			, rv["search_desc"] );
		}
	}  
	
	//계산방법보기버튼 활성여부 조회
	function getCpnFormulaBtnYn(){

        var formulaYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_FORMULA_BTN_YN", "queryId=getSystemStdData",false).codeList;
        var formulaReYn = "Y";
        
		if(formulaYn[0].code_nm != "N") {
			$("input:radio[name='cpn_formula_btn_yn']:input[value='"+formulaReYn+"']").attr("checked",true);
		} else {
			formulaReYn = "N";
			$("input:radio[name='cpn_formula_btn_yn']:input[value='"+formulaReYn+"']").attr("checked",true);
		}
	}
	
	// 계산방법보기버튼 저장(체크시)
	function saveCpnFormulaBtnYn(){
		
		var params = $("#sheetForm").serialize()+ "&std_cd=CPN_FORMULA_BTN_YN";
		params += "&sStatus=U";	
		params += "&std_cd_value="+$("input:radio[name=cpn_formula_btn_yn]:checked").val();

		ajaxCall("<%=jspPath%>/calcExpressionMgr/calcExpressionMgrRst.jsp?cmd=updateCpnFormulaBtnYn",params,false);
	}		
	
	// 생성
	function batchFormula(strParam){
		if(strParam=="del"){
			if(confirm("모든 자료가 삭제후 재생성 됩니다. 재생성하겠습니까?")){
				
				ajaxCall("<%=jspPath%>/calcExpressionMgr/calcExpressionMgrRst.jsp?cmd=batchCalcExpressionMgrByDel",$("#sheetForm").serialize(),false);
 				closeHelpPop();
 				doAction1("Search");
			}			
			
		}else if(strParam=="new"){
			
			if(confirm(" 기존 자료는 유지되며 신규 생성된 수당/공제 항목에 대해서만 생성됩니다. 생성하겠습니까?")){
				ajaxCall("<%=jspPath%>/calcExpressionMgr/calcExpressionMgrRst.jsp?cmd=batchCalcExpressionMgrByNew",$("#sheetForm").serialize(),false);
 				closeHelpPop();
 				doAction1("Search");
			}				
		}
	}	
	
	function showHelpPop(){
		$("#heplPop").show();
	}
	
	function closeHelpPop(){
		$("#heplPop").hide();
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
                <td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
            </tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">계산방법관리
			 	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;※명세서 내 계산방법보기&nbsp;&nbsp;</span>
			  	<input name ="cpn_formula_btn_yn" type="radio" class="radio" value="Y" onchange="javascript:saveCpnFormulaBtnYn();" />&nbsp;활성		
			 	<input name ="cpn_formula_btn_yn" type="radio" class="radio" value="N" onchange="javascript:saveCpnFormulaBtnYn();"/>&nbsp;숨김
            
            </li>
            <li class="btn">
            	<a href="javascript:doAction1('Batch')"        class="basic authA">생성</a>
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
<div id="heplPop" style="position:absolute; top:90px; left:90%; width:100%; margin-left:-300px;height:230px;background-color:transparent;  display:none; z-index:31;">
	<div class="explain spacingN" style="margin:0;padding:5px;letter-spacing:1; width:200px;height:90px;">
		<div class="popup_title">
			<ul>
				<li id="title-pop">계산방법 생성</li>
				<li class="close" onclick="closeHelpPop()"></li>
			</ul>
		</div>
		<div class="h10"></div>
		<div class="noti_icon3"></div>
		<div class="txt" style=" width:600px;height:380px; overflow:auto;">
		&nbsp;&nbsp;<a href="javascript:batchFormula('del')"        class="basic authA">삭제 후 재생성</a>
		<a href="javascript:batchFormula('new')"        class="basic authA">신규만 생성</a>	
		</div>
	</div>
</div>
</body>
</html>