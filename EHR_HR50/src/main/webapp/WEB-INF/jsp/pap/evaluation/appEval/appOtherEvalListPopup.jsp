<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>메뉴검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@page import="java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<script type="text/javascript">
	var param = {};	
	var convertParam = {};
	
	$(function() {
		param = '${Param}';
		convertParam = convertMap(param);
		//$("#sabun").val(convertParam.sabun)
		$("#appSabun").val(convertParam.sabun)
		$("#appTypeCd").val(convertParam.appTypeCd);
		$("#appraisalCd").val(convertParam.appraisalCd);
		$("#txt").html(unescape(convertParam.title));
		var title = unescape(convertParam.title)+"|"+unescape(convertParam.title);
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,Page:50,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:0, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:1, Width:40,				Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"피평가자|평가그룹",
											Type:"Text",		Hidden:0,		Width:180,	Align:"Left",	ColMerge:1,	SaveName:"appGroupNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|평가소속",	Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|사번",		Type:"Text",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|성명",		Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직책명",		Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직위명",		Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가상태|평가상태",	Type:"Text",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appStatusNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			//{Header:"차수|차수",			Type:"Int",	  		Hidden:0,  		Width:50,	Align:"center", ColMerge:0, SaveName:"appSeq",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5 },
			//{Header:"순번|순번",			Type:"Int",	  		Hidden:0,  		Width:50,	Align:"center", ColMerge:0, SaveName:"appSeq",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5 },
			//{Header:"점수|점수",			Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"app1stScr",	KeyField:0,				CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			//{Header:"순위|순위",			Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"app1stRk",	KeyField:0,				CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appTypeCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appSabun",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appGroupCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appStatusCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
		]; 
		if (convertParam.appTypeCd == "01") { // 목표합의
		} else if (convertParam.appTypeCd == "03") { // 중간점검(평가자)
			initdata.Cols.push({Header:"차수|차수",			Type:"Int",	  		Hidden:0,  		Width:50,	Align:"center", ColMerge:0, SaveName:"appSeq",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5 });			
		} else if (convertParam.appTypeCd == "05") { // 평가자평가(1차), 평가(2차)는 다른 팝업을 호출. 
			initdata.Cols.push({Header:"순번|순번",			Type:"Int",	  		Hidden:1,  		Width:50,	Align:"center", ColMerge:0, SaveName:"appSeq",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5 });
			initdata.Cols.push({Header:"점수|점수",			Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"app1stScr",	KeyField:0,				CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 });
			initdata.Cols.push({Header:"순위|순위",			Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"app1stRk",	KeyField:0,				CalcLogic:"",	Format:"NullFloat",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 });
			title = "평가|평가";
		} 
		
		
		initdata.Cols.push({Header:title,				Type:"Image",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",	KeyField:0,	Format:"",		Cursor:"Pointer" });		
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		
		sheet1.FocusAfterProcess = false;
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.FitColWidth();

		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);
		
		$(window).smartresize(sheetResize); sheetInit();
		//var param = '${Param}';
		doAction1("Search");
	});
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				var param = "searchText="+$("#searchText").val();
			    sheet1.DoSearch( "${ctx}/AppEval.do?cmd=getOtherEvalListPopupList1", $("#empForm").serialize());
	            break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param = {DownCols:downcol, SheetDesign:1, Merge:1};
				sheet1.Down2Excel(param);	
				break;
		}
    } 
	
	// 조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") {
				alert(Msg);
				return;
			}

			for (i=sheet1.GetDataFirstRow(); i<=sheet1.GetDataLastRow();i++) {
				var appTypeCd = sheet1.GetCellValue(i, "appTypeCd");
				var appStatusCd = sheet1.GetCellValue(i, "appStatusCd");
				var appSeq = sheet1.GetCellValue(i, "appSeq");
				for (var j=3; j<sheet1.ColCount; j++) {
					if ((appTypeCd == "01" && appStatusCd == "A1") 
							|| (appTypeCd == "03" && appStatusCd == "D1" && appSeq == "1")
							|| (appTypeCd == "03" && appStatusCd == "D2" && appSeq == "2")
							|| (appTypeCd == "05" && appStatusCd == "C1")
						) {
						sheet1.SetCellFontColor(i, j, "blue");
					} else {
						sheet1.SetCellFontColor(i, j, "black");
					}
				}
			}
			
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	// 클릭 시 
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if (Row < 1) return;
			if (sheet1.ColSaveName(Col)=="detail") {
				var args = {};
				var param = {
						appTypeCd: sheet1.GetCellValue(Row, "appTypeCd"),
						sabun: sheet1.GetCellValue(Row, "sabun"),
						appSabun: sheet1.GetCellValue(Row, "appSabun"),
						appraisalCd: sheet1.GetCellValue(Row, "appraisalCd"),
						appGroupCd: sheet1.GetCellValue(Row, "appGroupCd"),
						appSeq: sheet1.GetCellValue(Row, "appSeq"),
						title:unescape(convertParam.title),
				}
				openModalPopup("AppEval.do?cmd=viewAppOtherEvalDetailPopup", param, "99%", "90%"
				, function(){
					doAction1("Search");
				}
				, {title:unescape(convertParam.title)});				
			}
	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
	  	}
	}
	function onView(){
		//console.log("searchMenuLayer.jsp onView()");
		
		sheetResize();
		//setTimeout(function(){ sheetResize(); $("#searchText").focus();},100);
	}
	
	function checkOpenMenu(s, m){
		//console.log( "Check Menu Open !!");
		var isOpen = false;
		$("#subMenuCont>li, #subMenuCont>li>dl>dt, #subMenuCont>li>dl>dt>dd", parent.document).each(function() {
			if( $(this).attr("menuId") == m ) {
				isOpen = true;
			}
		});
		if( isOpen ){
			//console.log( "Check Menu Open !! true");
			parent.openSubMenuCd(s, m);
			return true;
		} else{
			//console.log( "Check Menu Open !! false");
			return setTimeout(function(){ checkOpenMenu(s, m) }, 500 ); 
		}
				
	}
	
</script>

</head>
<body>
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" id="sabun" name="sabun"/>
		<input type="hidden" id="appSabun" name="appSabun"/>
		<input type="hidden" id="appTypeCd" name="appTypeCd"/>
		<input type="hidden" id="appraisalCd" name="appraisalCd"/>	
	</form>
	<!-- 
	<div class="outer">
		<table class="table">
		<colgroup>
			<col width="80" />
			<col width="" />
			<col width="50" />
		</colgroup>
		<tr>
			<th>메뉴명</th>
			<td>
				<input type="text" id="searchText" name="searchText" class="text w90p center" />
			</td>
			<td>
				<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
			</td>
		</tr>
		</table>
	</div>         
	<div class="h10 outer"></div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
	 -->
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"></li>
							<li class="btn">
								<!-- <a href="javascript:doAction1('Search')" class="basic">조회</a> -->
								<a href="javascript:doAction1('Down2Excel')" 	class="basic">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>	
</div>
</body>
</html>



