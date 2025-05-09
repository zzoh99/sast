<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>질병코드검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	
	$(function() {
		
        const modal = window.top.document.LayerModalUtility.getModal('medAppDetLayer');
		//Sheet 초기화
		init_medAppDetLayerSheet();
		
		$("#searchCode,#searchCodeNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		//Cancel 버튼 처리
		$(".close").click(function(){
			//p.self.close();
			closeMedAppDetLayer();
		});
		//doAction1("Search");
	
	});

	//Sheet 초기화
	function init_medAppDetLayerSheet(){

		createIBSheet3(document.getElementById('medAppDetSheet-wrap'), "medAppDetLayerSheet", "100%", "100%","${ssnLocaleCd}");
		var initdata1 = {};
		//MergeSheet:msHeaderOnly => 헤더만 머지
		//HeaderCheck => 헤더에 전체 체크 표시 여부
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"선택",			Type:"Html",		Hidden:0,		Width:30,			Align:"Center",	ColMerge:0,	SaveName:"btnSelete",	Sort:0, Cursor:"Pointer" },

			{Header:"질병코드", 	Type:"Text", 		Hidden:0, 		Width:60, 			Align:"Center", ColMerge:0,	SaveName:"code", 	KeyField:0, Format:"", PointCount:0,	UpdateEdit:0, InsertEdit:0 },
			{Header:"병명", 		Type:"Text", 		Hidden:0, 		Width:150, 			Align:"left", ColMerge:0,	SaveName:"codeNm", 	KeyField:0, Format:"", PointCount:0,	UpdateEdit:0, InsertEdit:0 },
		]; IBS_InitSheet(medAppDetLayerSheet, initdata1);medAppDetLayerSheet.SetEditable(false);medAppDetLayerSheet.SetVisible(true);medAppDetLayerSheet.SetCountPosition(4);
		
		var sheetHeight = $('.modal_body').height() - $('#medAppDetLayerSheetForm').height()  - $('.sheet_search').height();
	    $(window).smartresize(sheetResize); sheetInit();
		medAppDetLayerSheet.SetSheetHeight(sheetHeight);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				medAppDetLayerSheet.DoSearch( "${ctx}/MedApp.do?cmd=getMedCodeMgrList", $("#medAppDetLayerSheetForm").serialize() );
				break;
		}
	}

	// 조회 후 에러 메시지
	function medAppDetLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			
			for(var i = medAppDetLayerSheet.HeaderRows(); i < medAppDetLayerSheet.RowCount()+medAppDetLayerSheet.HeaderRows(); i++) {
				medAppDetLayerSheet.SetCellValue(i, "btnSelete", '<a class="btn filled">선택</a>');
			}
			
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}	  
	}
	
	// 셀 클릭시 발생
	function medAppDetLayerSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < medAppDetLayerSheet.HeaderRows() ) return;
			
		    if( medAppDetLayerSheet.ColSaveName(Col) == "btnSelete" ) {
		    	returnData(Row);
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	// row 클릭시 발생
	function medAppDetLayerSheet_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < medAppDetLayerSheet.HeaderRows() ) return;
			returnData(Row);
		} catch (ex) {
			alert("OnDbClick Event Error : " + ex);
		}
	}

	function returnData(Row){
		
    	var returnValue = [];
 		returnValue["medCode"] = medAppDetLayerSheet.GetCellValue(Row,"code");
 		returnValue["medCodeNm"] = medAppDetLayerSheet.GetCellValue(Row,"codeNm");

 		/*
 		if(p.popReturnValue) p.popReturnValue(returnValue);
 		p.window.close();*/

        const modal = window.top.document.LayerModalUtility.getModal('medAppDetLayer');
        modal.fire('medAppDetTrigger', returnValue ).hide();
	
	}
	
	function closeMedAppDetLayer() {
	    const modal = window.top.document.LayerModalUtility.getModal('medAppDetLayer');
	    modal.hide();
	}

</script>

</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
	<!-- 
		<div class="popup_title">
			<ul>
				<li>질병분류코드 검색</li>
				<li class="close"></li>
			</ul>
		</div>
	 -->
		<div class="modal_body"> 
			<form name="medAppDetLayerSheetForm" id="medAppDetLayerSheetForm" method="post">
			<div class="sheet_search outer">
				<table>
				<tr>
					<th>질병코드</th>
					<td>
						<input type="text" id="searchCode" name="searchCode" class="text"/>
					</td>
					<th>질병명</th>
					<td>
						<input type="text" id="searchCodeNm" name="searchCodeNm" class="text w150"/>
					</td>
					<td>
						<a href="javascript:doAction1('Search')" class="button">조회</a>
					</td>
				</tr>
				</table>
			</div>
			</form>
			<!-- <div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">질병 조회</li>
				</ul>
				</div>
			</div> -->
			<!-- <script type="text/javascript">createIBSheet("Sheet2, "100%", "100%"); </script> -->
			<div id="medAppDetSheet-wrap"></div>
		</div>       
	</div>
	<div class="modal_footer">
	    <a href="javascript:closeMedAppDetLayer();" class="btn outline_gray">닫기</a>
	 </div>
</body>
</html>