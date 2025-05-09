<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>질병코드검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	
	$(function() {
	
		//Sheet 초기화
		init_sheet2();
	
		$(window).smartresize(sheetResize); sheetInit();
		
		
		$("#searchCode,#searchCodeNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
		//doAction1("Search");
	
	});

	//Sheet 초기화
	function init_sheet2(){

		var initdata1 = {};
		//MergeSheet:msHeaderOnly => 헤더만 머지
		//HeaderCheck => 헤더에 전체 체크 표시 여부
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"선택",			Type:"Html",		Hidden:0,		Width:30,			Align:"Center",	ColMerge:0,	SaveName:"btnSelete",	Sort:0, Cursor:"Pointer" },

			{Header:"질병코드", 	Type:"Text", 		Hidden:0, 		Width:60, 			Align:"Center", ColMerge:0,	SaveName:"code", 	KeyField:0, Format:"", PointCount:0,	UpdateEdit:0, InsertEdit:0 },
			{Header:"병명", 		Type:"Text", 		Hidden:0, 		Width:150, 			Align:"left", ColMerge:0,	SaveName:"codeNm", 	KeyField:0, Format:"", PointCount:0,	UpdateEdit:0, InsertEdit:0 },
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/MedApp.do?cmd=getMedCodeMgrList", $("#sheet2Form").serialize() );
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			
			for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows(); i++) {
				sheet2.SetCellValue(i, "btnSelete", '<a class="button">선택</a>');
			}
			
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}	  
	}
	
	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet2.HeaderRows() ) return;
			
		    if( sheet2.ColSaveName(Col) == "btnSelete" ) {
		    	returnData(Row);
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	// row 클릭시 발생
	function sheet2_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet2.HeaderRows() ) return;
			returnData(Row);
		} catch (ex) {
			alert("OnDbClick Event Error : " + ex);
		}
	}

	function returnData(Row){
    	var returnValue = [];
 		returnValue["medCode"] = sheet2.GetCellValue(Row,"code");
 		returnValue["medCodeNm"] = sheet2.GetCellValue(Row,"codeNm");

 		if(p.popReturnValue) p.popReturnValue(returnValue);
 		p.window.close();
	}
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>질병분류코드 검색</li>
			<li class="close"></li>
		</ul>
	</div>
	
	<div class="popup_main"> 
		<form name="sheet2Form" id="sheet2Form" method="post">
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
		<script type="text/javascript">createIBSheet("sheet2", "100%", "100%"); </script>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large authR">닫기</a>
				</li>
			</ul>
		</div>
	</div>       
</div>
</body>
</html>