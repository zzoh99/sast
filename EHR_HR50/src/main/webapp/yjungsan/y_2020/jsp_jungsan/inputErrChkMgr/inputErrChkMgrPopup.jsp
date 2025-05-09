<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>오류검증항목보기</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");

	$(function() {
		
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			$("#searchYear").val(arg["searchYear"]) ;
		}else{
			var searchYear 	  = "";
			
			searchYear 	  = p.popDialogArgument("searchYear");
			
			$("#searchYear").val(searchYear);   		
		}
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
   			{Header:"No",		Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
 			{Header:"항목코드",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"adj_element_cd", 	UpdateEdit:0 },
 			{Header:"항목명",		Type:"Text",		Hidden:0,	Width:500,	Align:"Left",	ColMerge:0,	SaveName:"adj_element_nm", 	UpdateEdit:0 },
 			{Header:"항목설명",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"element_desc", 	UpdateEdit:0 }
		];IBS_InitSheet(sheet1, initdata1); sheet1.SetEditable(false); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);

		$(window).smartresize(sheetResize);sheetInit();
        
		doAction1("Search") ;
	});
	
	$(function() {
        $("#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction1("Search");
			}
		});

        $(".close").click(function() {
	    	p.self.close();
	    });
	});
	
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			sheet1.DoSearch( "<%=jspPath%>/inputErrChkMgr/inputErrChkMgrRst.jsp?cmd=selectInputErrChkMgrPopupList", $("#sheetForm").serialize() ); 
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
</script>

</head>
<body class="bodywrap">

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>오류검증 항목보기</li>
                <!-- <li class="close"></li>  -->
            </ul>
        </div>
        
        <div class="popup_main">
            <form id="sheetForm" name=""sheetForm"">
            <input id="searchYear" name ="searchYear" type="hidden" />
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                        <td> <span>항목명</span> <input id="searchNm" name ="searchNm" type="text" class="text" /> </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
                        </td>
                    </tr>
                    </table>
                    </div>
                </div>
            
	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">오류검증 항목</li>
					<li class="btn">
						<a href="javascript:doAction1('Down2Excel')" 	class="basic">다운로드</a>
					</li>
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
