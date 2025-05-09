<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>권한그룹프로그램관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		sheet1.SetDataLinkMouse("detail", 1);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"세부\n내역",		Type:"Image",		Hidden:0,					Width:45,			Align:"Center",	ColMerge:0,	SaveName:"detail",	Cursor:"Pointer" },
			{Header:"메인메뉴코드",		Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"main_menu_cd" },
			{Header:"[ 등록 메인메뉴 ]",	Type:"Text",		Hidden:0,					Width:185,			Align:"Left",	ColMerge:0,	SaveName:"main_menu_nm",	UpdateEdit:0,	InsertEdit:0}
		];IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"<%=imagePath%>/icon/icon_popup.png");

		var authGrp = stfConvCode( codeList("<%=jspPath%>/auth/athGrpMenuMgrRst.jsp?cmd=selectGrpCdList",""), "");
		
		$("#srchAthGrpCd").html(authGrp[2]);
		$("#srchAthGrpCd").change(function(){
			doAction1("Search");
		});
		
 		$(window).smartresize(sheetResize); sheetInit();
 		
 		doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/auth/athGrpMenuMgrRst.jsp?cmd=selectAthGrpMenuMgrList", $("#sheet1Form").serialize() );
			break;
		case "Down2Excel":
			sheet1.Down2Excel();
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
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
			var args 	= new Array();
			args["athGrpCd"] 	= $("#srchAthGrpCd").val();
			args["mainMenuCd"] 	= sheet1.GetCellValue(Row, "main_menu_cd");
			url = "<%=jspPath%>/auth/athGrpMenuMgrRegPopup.jsp?authPg=<%=authPg%>";

			if(!isPopup()) {return;}
			var rv = openPopup(url, args, "1200","800");
	    }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<td>
						<span>권한그룹</span>
						<select id="srchAthGrpCd" name="srchAthGrpCd"></select>
						<td> <a href="javascript:doAction1('Search');" id="btnSearch" class="button">조회</a> </td>
					</td>
				</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">등록메인메뉴 </li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%"); </script>

</div>
</body>
</html>