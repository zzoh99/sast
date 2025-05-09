<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>부서별월근태현황 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	
	$(function() {
		createIBSheet3(document.getElementById('wtmOrgMonthWorkStaLayerSheet-wrap'), "wtmOrgMonthWorkStaLayerSheet", "100%", "100%", "kr");

		var ym = "";
		var sabun = "";
		var name = "";
		var orgNm = "";
		var jikgubNm = "";

		var modal = window.top.document.LayerModalUtility.getModal('wtmOrgMonthWorkStaLayer');
		var {ym, sabun, name, orgNm, jikgubNm} = modal.parameters;
		var titleTxt = "개인별 월근태현황"

		$('#modal-wtmOrgMonthWorkStaLayer').find('div.layer-modal-header span.layer-modal-title').text(titleTxt);
		$("#searchYm").val(ym.replace(/-/gi,""));
		$("#searchSabun").val(sabun);
		
        $("#span_ym").html(ym);
        $("#span_name").html(name);
        $("#span_jikgubNm").html(jikgubNm);
        $("#span_orgNm").html(orgNm);

        initSheet();

		var sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
		wtmOrgMonthWorkStaLayerSheet.SetSheetHeight(sheetHeight);

		doAction1("Search");

		$("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search");
			}
		});
	});

	/*
	 * sheet Init
	 */
	function initSheet(){
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			//{Header:"삭제",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			//{Header:"상태",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
            {Header:"근태종류",        Type:"Text",    Hidden:0, Width:200, Align:"Center", ColMerge:1, SaveName:"gntNm",          KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },            {Header:"시작일",         Type:"Date",    Hidden:0, Width:80,  Align:"Center", ColMerge:1, SaveName:"sYmd",           KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
            {Header:"종료일",         Type:"Date",    Hidden:0, Width:80,  Align:"Center", ColMerge:1, SaveName:"eYmd",           KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
            {Header:"적용\n일수",      Type:"Text",    Hidden:0, Width:60,  Align:"Center",  ColMerge:1, SaveName:"closeDay",       KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
  		
        ];

		IBS_InitSheet(wtmOrgMonthWorkStaLayerSheet, initdata);
		wtmOrgMonthWorkStaLayerSheet.SetEditable("${editable}");
		wtmOrgMonthWorkStaLayerSheet.SetVisible(true);
		wtmOrgMonthWorkStaLayerSheet.SetCountPosition(4);

		$(window).smartresize(sheetResize);
		sheetInit();
	}
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			wtmOrgMonthWorkStaLayerSheet.DoSearch( "${ctx}/WtmOrgMonthWorkSta.do?cmd=getWtmOrgMonthWorkStaPopList", $("#mySheetForm").serialize());
            break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(wtmOrgMonthWorkStaLayerSheet);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			wtmOrgMonthWorkStaLayerSheet.Down2Excel(param);
			break;
		}
    } 
	
	

	//-----------------------------------------------------------------------------------
	//		wtmOrgMonthWorkStaLayerSheet 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지 
	function wtmOrgMonthWorkStaLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);    
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
        <form id="mySheetForm" name="mySheetForm" tabindex="1">
	        <input type="hidden" id="searchYm"       name="searchYm" />
	        <input type="hidden" id="searchSabun"    name="searchSabun" />
	        	        
			<div class="sheet_search outer">
				<table>
				<tr>
                    <th>대상년월</th>
                    <td>
                        <label id="span_ym"></label>
                    </td>
					<th>성명</th>
					<td>
						<label id="span_name"></label>
					</td>
					<th>직급</th>
					<td>
						<label id="span_jikgubNm"></label>
					</td>
					<th>소속</th>
					<td>
						<label id="span_orgNm"></label>
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
				<li id="txt" class="txt">개인별  월근태현황</li>
				<li class="btn">&nbsp;</li>
			</ul>
			</div>
		</div>
		<div id="wtmOrgMonthWorkStaLayerSheet-wrap"></div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('wtmOrgMonthWorkStaLayer');" class="gray large">닫기</a>
		</div>
	</div>
</div>
</body>
</html>
