<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>기부금</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
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
			var searchWorkYy     = "";
			var searchAdjustType = "";
			var searchSabun      = "";

			searchWorkYy 	  = p.popDialogArgument("searchWorkYy");
			searchAdjustType  = p.popDialogArgument("searchAdjustType");
			searchSabun       = p.popDialogArgument("searchSabun");

			$("#searchWorkYy").val(searchWorkYy);
			$("#searchAdjustType").val(searchAdjustType);
			$("#searchSabun").val(searchSabun);
		}

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
    		{Header:"No",		        Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
            {Header:"기부금종류", 			Type:"Text",     Hidden:0,  Width:100,  Align:"Left",    	ColMerge:0,   SaveName:"code_nm",  			KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"기부년도", 			Type:"Text",     Hidden:0,  Width:70,  	Align:"Center",    	ColMerge:0,   SaveName:"donation_yy",  		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"기부금액", 			Type:"Int",      Hidden:0,  Width:100,  Align:"Right",    	ColMerge:0,   SaveName:"donation_mon",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"전년까지\n공제된 금액", 	Type:"Int",      Hidden:0,  Width:100,  Align:"Right",    	ColMerge:0,   SaveName:"prev_ded_mon",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"공제대상금액", 			Type:"Int",      Hidden:0,  Width:100,  Align:"Right",    	ColMerge:0,   SaveName:"cur_ded_mon",  		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"해당년도\n공제금액",		Type:"Int",      Hidden:0,  Width:100,  Align:"Right",    	ColMerge:0,   SaveName:"ded_mon",  			KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"소멸금액",   			Type:"Int",      Hidden:0,  Width:100,  Align:"Right",    	ColMerge:0,   SaveName:"extinction_mon", 	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"이월금액",   			Type:"Int",      Hidden:0,  Width:100,  Align:"Right",    	ColMerge:0,   SaveName:"carried_mon",  		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100, BackColor:"#a2d0ff", FontColor:"#000000" }
        ];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetCountPosition(4);

	    $(window).smartresize(sheetResize); sheetInit();
	    doAction("Search");

	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataDonRst.jsp?cmd=selectYeaDataDonPopupList", $("#sheetForm").serialize() );
			break;
		}
    }

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
</script>

</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>기부금 이월자료</li>
				<!--<li class="close"></li>-->
			</ul>
		</div>
		<form id="sheetForm" name="sheetForm" >
			<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
			<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
			<input type="hidden" id="searchSabun" name="searchSabun" value="" />
		</form>
        <div class="popup_main">
			<div class="outer">
				<script type="text/javascript">createIBSheet("sheet1", "100%", "400px"); </script>
			</div>
        </div>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>



