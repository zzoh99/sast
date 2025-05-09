<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title><span id="titleText">수당,공제 항목</span></title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var srchBizCdList = null;
	var srchTypeCdList = null;
	var p = eval("<%=popUpStatus%>");
	
	$(function() {

		srchBizCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getCommonMainMenuList&searchMainMenuCd="), "전체");
		srchTypeCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+<%=curSysYear%>,"R20010"), "전체");

		$("#srchBizCd").html(srchBizCdList[2]);	//업무 구분
		$("#srchType").html(srchTypeCdList[2]);	//검색 구분

		sheet1.SetDataLinkMouse("sStatus", 1);
	    sheet1.SetDataLinkMouse("dbItemDesc", 1);
	    
		var srchBizCd = "";
		var srchType = "";
		var srchDesc = "";
		var arg = p.window.dialogArguments;
		if( arg != undefined ) {
			 srchBizCd 	  = arg["srchBizCd"];
			 srchType     = arg["srchType"];
			 srchDesc     = arg["srchDesc"];
		}else{
			if ( p.popDialogArgument("srchBizCd")  !=null ) { srchBizCd = p.popDialogArgument("srchBizCd"); }
			if ( p.popDialogArgument("srchType")   !=null ) { srchType  = p.popDialogArgument("srchType"); }
			if ( p.popDialogArgument("srchDesc")   !=null ) { srchDesc  = p.popDialogArgument("srchDesc"); }
		}
		$("#srchBizCd").val(srchBizCd);	//업무 구분
		$("#srchType").val(srchType);	//검색 구분
		$("#srchDesc").val(srchDesc);

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
	        {Header:"No",  				Type:"<%=sNoTy%>",  	Hidden:0,   Width:"<%=sNoWdt%>",  Align:"Center",  ColMerge:0,   SaveName:"sNo", UpdateEdit:0 },
			{Header:"세부\n내역",      	Type:"Image",   Hidden:1,  	Width:40,	Align:"Center",  ColMerge:0,   SaveName:"db_item_desc",	UpdateEdit:0},
			{Header:"검색\n순번",      	Type:"Text",    Hidden:1,  	Width:30,	Align:"Center",  ColMerge:0,   SaveName:"search_seq",    UpdateEdit:0 },
	        {Header:"검색구분",        	Type:"Combo",   Hidden:0,  	Width:130,	Align:"Center",  ColMerge:0,   SaveName:"search_type",   UpdateEdit:0 },
	        {Header:"검색설명",        	Type:"Text",    Hidden:0,  	Width:200,	Align:"Left",    ColMerge:0,   SaveName:"search_desc",   UpdateEdit:0 },
	        {Header:"업무구분",        	Type:"Combo",   Hidden:0, 	Width:110,	Align:"Left",    ColMerge:0,   SaveName:"biz_cd",        UpdateEdit:0 },
	        {Header:"조회업무코드",    		Type:"Text",    Hidden:1,  	Width:0,  	Align:"Left",    ColMerge:0,   SaveName:"view_cd",       UpdateEdit:0 },
	        {Header:"조회업무",        	Type:"Text",    Hidden:0,  	Width:100,	Align:"Left",    ColMerge:0,   SaveName:"view_desc",     UpdateEdit:0 },
	        {Header:"공통사용\n여부",  		Type:"Combo",   Hidden:1,  	Width:0,   Align:"Center",  ColMerge:0,   SaveName:"common_use_yn",   UpdateEdit:0 },
	        {Header:"VIEW_NM",         	Type:"Text",    Hidden:1,  	Width:0,    Align:"Center",  ColMerge:0,   SaveName:"view_nm",       UpdateEdit:0 }
		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}");sheet1.SetEditableColorDiff (0);
     	sheet1.SetColProperty("biz_cd", 		{ComboText:srchBizCdList[0], 	ComboCode:srchBizCdList[1]} );
        sheet1.SetColProperty("search_type", 	{ComboText:srchTypeCdList[0], 	ComboCode:srchTypeCdList[1]} );
        sheet1.SetColProperty("common_use_yn", 	{ComboText:"YES|NO", 		ComboCode:"Y|N"} );
        sheet1.SetImageList(0,"<%=jspPath%>/common/images/icon/icon_popup.png");

		sheet1.SetCountPosition(4);

	    $(window).smartresize(sheetResize); sheetInit();

		$("#srchDesc").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

	    doAction("Search");
	    $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "<%=jspPath%>/calcExpressionMgr/pwrSrchMgrPopupRst.jsp?cmd=selectPwrSrchMgrList", $("#mySheetForm").serialize() ); 
			break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		var rv = new Array(5);
		rv["search_seq"] 		= sheet1.GetCellValue(Row, "search_seq");
		rv["search_desc"]		= sheet1.GetCellValue(Row, "search_desc");
		if(p.popReturnValue) p.popReturnValue(rv);
		p.window.close();
	}

	function init_value() {
		var rv = new Array(5);
		rv["search_seq"] 		= "";
		rv["search_desc"]		= "";
		if(p.popReturnValue) p.popReturnValue(rv);
		p.window.close();
	}

</script>

</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>조건 검색 관리</li>
			</ul>
		</div>

		<div class="popup_main">
			<form id="mySheetForm" name="mySheetForm">
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<td>
							<span>업무구분</span>
							<select id="srchBizCd" name="srchBizCd" onChange=""></select>
						</td>
						<td>
							<span>검색구분</span>
							<select id="srchType" name="srchType" onChange=""></select>
						</td>
						<td>
							<span>검색설명</span>
							<input id="srchDesc" name="srchDesc" type="text" class="text" style="ime-mode:active;" />
						</td>
                        <td>
                            <a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a>
                        </td>	
					</tr>
					</table>
					</div>
				</div>
			</form>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">조건 검색 관리</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
					</td>
				</tr>
			</table>
		</div>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:init_value();" class="blue large">초기화</a>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
			<br>
		</div>
	</div>
</body>
</html>