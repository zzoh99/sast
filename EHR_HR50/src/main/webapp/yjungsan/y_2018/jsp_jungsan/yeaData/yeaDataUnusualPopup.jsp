<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산 특이사항</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");
	
	$(function() {
		
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			$("#searchWorkYy").val(arg["searchWorkYy"]);
			$("#searchAdjustType").val(arg["searchAdjustType"]);
			$("#searchSabun").val(arg["searchSabun"]);
		}else{
			var searchWorkYy 	 = "";
			var searchAdjustType = "";
			var searchSabun      = "";
			
			searchWorkYy 	 = p.popDialogArgument("searchWorkYy");
			searchAdjustType = p.popDialogArgument("searchAdjustType");
			searchSabun      = p.popDialogArgument("searchSabun");
			
			$("#searchWorkYy").val(searchWorkYy);   		
			$("#searchAdjustType").val(searchAdjustType);
			$("#searchSabun").val(searchSabun);   		
		}
		
	    $(".close").click(function() {
	    	p.self.close();
	    });
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0, SaveName:"sNo" },
	        {Header:"삭제",		Type:"<%=sDelTy%>",   Hidden:<%=sDelHdn%>, 	Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0, SaveName:"sDelete" },
	        {Header:"상태",		Type:"<%=sSttTy%>",   Hidden:<%=sSttHdn%>, 	Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0, SaveName:"sStatus" },
	        {Header:"대상년도",		Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"work_yy",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
	        {Header:"정산구분",		Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"adjust_type",	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"사원번호",		Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"sabun",  		KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
	        {Header:"TIP내용",	Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"tip_text",  	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
	        {Header:"CLEAR여부",	Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"clear_yn",  	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }
	    ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetCountPosition(4);
	    
	    $(window).smartresize(sheetResize); sheetInit();
	    doAction1("Search");
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectUnusualPopupList", $("#sheetForm").serialize() );
			break;
	    case "Save":
	    	sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=saveUnusualPopup");
	    	break;
	    case "Insert":
	    	var newRow = sheet1.DataInsert(0) ;
	    	sheet1.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() ) ;
	    	sheet1.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() ) ;
	    	sheet1.SetCellValue( newRow, "sabun", $("#searchSabun").val() ) ;
	    	break;
		}
	}
	
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			
			if(Code == 1 && sheet1.RowCount() > 0) {
				if(sheet1.GetCellValue(sheet1.GetSelectRow(), "clear_yn") == "Y"){
					 $(':checkbox[name=clearYn]').attr('checked', true);
				}
				$("#tipText").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "tip_text")) ;
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			
			if(Code == 1) { 
				p.self.close(); 
			} 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	//데이타 리턴
	function setValue() {
	
		if(sheet1.RowCount() < 1){
			doAction1("Insert");
		}
		
		if($("#clearYn").is(":checked") == true){
			sheet1.SetCellValue(sheet1.GetSelectRow(), "clear_yn", "Y");
		} else {
			sheet1.SetCellValue(sheet1.GetSelectRow(), "clear_yn", "N");
		}
	
		sheet1.SetCellValue(sheet1.GetSelectRow(), "tip_text", $("#tipText").val()) ;
	
		var rv = new Array(1);
		rv["returnValue"] 		= "callSave";
		//p.window.returnValue 	= rv;
		if(p.popReturnValue) p.popReturnValue(rv);
		
		doAction1("Save");
	}

</script>

</head>
<body class="bodywrap">
<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
</form>	
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>연말정산 특이사항</li>
		<li class="close"></li>
	</ul>
	</div>
	<div class="popup_main">
		<table class="table">
		<colgroup>
			<col width="20%" />
			<col width="" />
		</colgroup>
			<tr>
				<td class="title">CLEAR여부</td>
        	    <td class="content">
                	<input type="checkbox" class="checkbox" name="clearYn" id="clearYn" >
            	</td>
			</tr>
			<tr>
				<th>TIP 내용</th>
				<td>
					<textarea id="tipText" name="tipText" rows="10" class="text w100p" maxlength="4000"></textarea>
				</td>
			</tr>
		</table>
		<div class="hide">
			<script type="text/javascript">createIBSheet("sheet1", "100%", "200px"); </script>
		</div>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:setValue();" class="pink large">저장</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>