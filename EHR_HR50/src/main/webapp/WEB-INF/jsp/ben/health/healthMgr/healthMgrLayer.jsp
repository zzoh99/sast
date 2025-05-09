<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>건강검진 대상자선택팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('healthMgrLayer');

		var searchYear;
		var arg = modal.parameters;
		searchYear = arg["year"];
		
		$("#searchYear").val(searchYear);

        $("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		createIBSheet3(document.getElementById('healthMgrLayerSht-wrap'), "healthMgrLayerSht", "100%", "100%", "${ssnLocaleCd}");
        init_healthMgrLayerSht();
        doAction1("Search");
	});

	/*
	 * sheet Init
	 */
	function init_healthMgrLayerSht(){
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0, FrozenColRight:6}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			Edit:0},
			{Header:"성명",			Type:"Text",    Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			Edit:0},
			{Header:"부서",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
			{Header:"직책",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
			{Header:"직위",			Type:"Text",   	Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"나이",			Type:"Text",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"age", 		Edit:0},
			
			{Header:"대상자구분",		Type:"Combo",   Hidden:0, Width:70, 	Align:"Center", ColMerge:0,  SaveName:"gubun", 			Edit:0, ComboText:"|본인|배우자", ComboCode:"|0|1"},
			{Header:"대상자명",		Type:"Popup",   Hidden:0, Width:70, 	Align:"Center", ColMerge:0,  SaveName:"famNm", 			Edit:0},
			{Header:"성별",			Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"sexType", 		Edit:0},
			{Header:"선택",			Type:"Html",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"btnSel", 		Edit:0},

			{Header:"Hidden", Hidden:1, SaveName:"famResNo" },
			{Header:"Hidden", Hidden:1, SaveName:"vFamResNo" },
			
		]; IBS_InitSheet(healthMgrLayerSht, initdata1);healthMgrLayerSht.SetEditable(false);healthMgrLayerSht.SetVisible(true);healthMgrLayerSht.SetCountPosition(4);
		
		healthMgrLayerSht.FocusAfterProcess = false;
		healthMgrLayerSht.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
		$(window).smartresize(sheetResize); sheetInit();
		
	}
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			healthMgrLayerSht.DoSearch( "${ctx}/HealthMgr.do?cmd=getHealthMgrPopList", $("#healthMgrLayerShtForm").serialize() );
            break;
		}
    } 
	
	// 조회 후 에러 메시지 
	function healthMgrLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	function healthMgrLayerSht_OnDblClick(Row, Col){
		try{
			var rv = new Array();
			
			rv["sabun"]		= healthMgrLayerSht.GetCellValue(Row, "sabun");
			rv["name"]		= healthMgrLayerSht.GetCellValue(Row, "name");
			rv["orgNm"]		= healthMgrLayerSht.GetCellValue(Row, "orgNm");
			rv["jikchakNm"]	= healthMgrLayerSht.GetCellValue(Row, "jikchakNm");
			rv["jikweeNm"]	= healthMgrLayerSht.GetCellValue(Row, "jikweeNm");
			rv["age"]		= healthMgrLayerSht.GetCellValue(Row, "age");
			rv["gubun"]		= healthMgrLayerSht.GetCellValue(Row, "gubun");
			rv["famNm"]		= healthMgrLayerSht.GetCellValue(Row, "famNm");
			rv["sexType"]	= healthMgrLayerSht.GetCellValue(Row, "sexType");
			rv["resNo"]		= healthMgrLayerSht.GetCellValue(Row, "famResNo");
			rv["vResNo"]	= healthMgrLayerSht.GetCellValue(Row, "vFamResNo");

			const modal = window.top.document.LayerModalUtility.getModal('healthMgrLayer');
			modal.fire('healthMgrLayerTrigger', rv).hide();

		}catch(ex){
	  		alert("OnDblClick Event Error : " + ex);
	  	}
	}

	
</script>

</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="healthMgrLayerShtForm" name="healthMgrLayerShtForm" >
			<div class="sheet_search outer">
				<table>
				<tr>
					<th>기준년도</th>
					<td>
						<input type="text" id="searchYear" name="searchYear" class="date2 readonly" value="" readonly/>
					</td>
					<th>사번/성명</th>
					<td>
						<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
					</td>
					<td>
						<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
					</td>
				</tr>
				</table>
			</div>	
		</form>  
		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">임직원 조회</li>
			</ul>
			</div>
		</div>
		<div id="healthMgrLayerSht-wrap"></div>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('healthMgrLayer')" class=" btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>



