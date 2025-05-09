<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>급여일자 조회</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%
	String runType = (String)request.getParameter("searchRunType");
%>
<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	$(function() {
		var arg = p.window.dialogArguments;

		//배열 선언				
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",		Hidden:0,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"급여일자코드",	Type:"Text",			Hidden:1,	Width:50,				Align:"Center",	ColMerge:0,	SaveName:"pay_action_cd", 	UpdateEdit:0 },
			{Header:"급여연월",			Type:"Date",		Hidden:0,	Width:70,				Align:"Center",	ColMerge:0,	SaveName:"pay_ym", 	KeyField:0,   CalcLogic:"",   Format:"Ym",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"급여계산명",			Type:"Text",		Hidden:0,	Width:120,				Align:"Center",	ColMerge:0,	SaveName:"pay_action_nm", 		UpdateEdit:0 },
			{Header:"지급일자",			Type:"Date",		Hidden:0,	Width:80,				Align:"Center",	ColMerge:0,	SaveName:"payment_ymd",   			KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
		];IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);

		$(window).smartresize(sheetResize);
		setSheetSize(sheet1);
		sheetInit();
	});
	
	$(function() {
		var stDate = "<%=curSysYyyyMMddHyphen%>".split("-");  
		var dt = new Date(stDate[0], stDate[1], stDate[2]);  
		var year = dt.getFullYear()-1; // 년도 구하기  
		var month = dt.getMonth(); // 구하기  
		var month = month + ""; // 문자형태  
		if(month.length == "1") var month = "0" + month; // 두자리 정수형태  
		var beforeMonth = year + "-" + month;  
		
		$("#searchSYm").datepicker2({ymonly:true});
		$("#searchEYm").datepicker2({ymonly:true});
		$("#searchSYm").val(beforeMonth);
		$("#searchEYm").val("<%=curSysYyyyMMHyphen%>");
		
		$("#searchSYm,#searchEYm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction("Search"); 
			}
		});
		
        $(".close").click(function() {
	    	p.self.close();
	    });
        
        doAction("Search"); 
	});
	
	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": //조회
			if( ( $.trim( $("#searchSYm").val( )) ) == ""){
					alert("급여연월을 입력하세요.");
				$("#searchSYm").focus();
			} else if(( $.trim( $("#searchEYm").val( )) ) == ""){
					alert("급여연월을 입력하세요.");
				$("#searchEYm").focus();
			} else{
			    sheet1.DoSearch( "<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectList&queryId=getPayActionCdList", $("#srchFrm").serialize() );
			}
			break;
		}
    } 
	
	// 	조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			alertMessage(Code, Msg, StCode, StMsg);
		  	if(sheet1.RowCount() == 0) {
		    	//alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
		  	}
		  	sheet1.FocusAfterProcess = false;
			setSheetSize(sheet1);
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	//높이 또는 너비가 변경된 경우 각 컬럼의 너비를 새로 맞춘다.
    //setSheetSize(sheet1);   
	function sheet1_OnResize(lWidth, lHeight) {
		try {
			setSheetSize(sheet1);
		} catch (ex) {
			alert("OnResize Event Error : " + ex);
		}
	}
	
	function sheet1_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		} catch(ex){
			alert("OnDblClick Event Error : " + ex);
		} finally{
			p.self.close();; 
		}
	}
	
	function returnFindUser(Row,Col){
	    
    	var returnValue = new Array(4);
    	$("#searchPayActionCd").val(sheet1.GetCellValue(Row,"pay_action_cd"));
    	
    	var payActionInfo = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap&queryId=getPayActionCdDetailList",$("#srchFrm").serialize(),false);
    	
    	if(payActionInfo.Message != null && payActionInfo.Message.length > 0) {
    		alert(payActionInfo.Message);
    		return;
    	}
    	
    	if(payActionInfo.Data != null && payActionInfo.Data != "undefine") 
    		payActionInfo = payActionInfo.Data;
    	
    	returnValue["pay_action_cd"] 	= payActionInfo.pay_action_cd;
 		returnValue["pay_action_nm"] 	= payActionInfo.pay_action_nm;
 		returnValue["pay_ym"] 				= payActionInfo.pay_ym;
 		returnValue["pay_cd"] 				= payActionInfo.pay_cd;
 		returnValue["payment_ymd"] 	= payActionInfo.payment_ymd;
		
		//p.window.returnValue = returnValue;
		if(p.popReturnValue) p.popReturnValue(returnValue);
 		
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>사원조회</li>
                <!--<li class="close"></li>-->
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
                <input type="hidden" id="searchEnterCd" name="searchEnterCd"  value=""/> 
                <input type="hidden" id="searchRunType" name="searchRunType" value="<%=removeXSS(runType, '1')%>"/> 
                <input type="hidden" id="searchPayActionCd" name="searchPayActionCd" /> 
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                        <td> 
                        	<span>급여연월</span> 
                        	<input id="searchSYm" name ="searchSYm" type="text" class="text" />
                        	~ 
                        	<input id="searchEYm" name ="searchEYm" type="text" class="text" />
                        </td>
                        <td>
                            <a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a>
                        </td>
                    </tr>
                    </table>
                    </div>
                </div>
            
	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">급여일자조회</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>