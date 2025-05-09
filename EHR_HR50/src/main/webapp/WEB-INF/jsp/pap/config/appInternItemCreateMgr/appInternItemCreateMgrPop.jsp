<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");

	$(function() {

		var arg = p.window.dialogArguments;

	    if( arg != undefined ) {
			    $("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
	    }

	    $(".close").click(function() {
	    	p.self.close();
	    });


		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"대분류",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"itemType",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"항목코드",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가역량",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seqNm",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"배점",		Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appBasisPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3 },
			{Header:"평가내용",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"순서",		Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sunbun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		//대분류
		var combocdList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10010"), "");
		sheet1.SetColProperty("itemType", 			{ComboText:combocdList1[0], ComboCode:combocdList1[1]} );

		$("#searchAppraisalCd").change(function(){
			doAction1("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppInternItemMgr.do?cmd=getAppInternItemMgrList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppInternItemMgr.do?cmd=saveAppInternItemMgr", $("#srchFrm").serialize()); break;
		case "Insert":
							var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
							sheet1.SelectCell(Row, "itemType");
							break;
		case "Copy":
							var Row = sheet1.DataCopy();
							sheet1.SetCellValue(Row, "seq", "");
							break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
		break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col){
		try{
			var returnValue = new Array;
			returnValue["seq"] 				= sheet1.GetCellValue(Row,"seq");
			returnValue["internItemType"] 	= sheet1.GetCellValue(Row,"itemType");
			returnValue["internItemNm"] 	= sheet1.GetCellValue(Row,"seqNm");
			returnValue["internItemMemo"] 	= sheet1.GetCellValue(Row,"memo");
			returnValue["appBasisPoint"] 	= sheet1.GetCellValue(Row,"appBasisPoint");
			returnValue["sunbun"] 			= sheet1.GetCellValue(Row,"sunbun");

			p.window.returnValue = returnValue;
		}
		catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
		finally{
			p.self.close();
		}
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>촉탁직평가항목 조회</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id=srchFrm>
	        <input id="searchAppraisalCd" 		name="searchAppraisalCd" 		type="hidden" />
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>

					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
			</td>
		</tr>
		</table>

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