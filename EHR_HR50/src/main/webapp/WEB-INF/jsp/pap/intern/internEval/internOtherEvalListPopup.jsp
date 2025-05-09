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
		$("#sabun").val(convertParam.sabun)
		$("#appSabun").val(convertParam.sabun)
		$("#appStepCd").val(convertParam.appStepCd);
		$("#appraisalCd").val(convertParam.appraisalCd);
		$("#txt").html(unescape(convertParam.title));
		var title = unescape(convertParam.title)+"|"+unescape(convertParam.title);
	
		var initdata = {};
		initdata.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:0, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:1, Width:40,				Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"피평가자|사번",		Type:"Text",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|성명",		Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|조직",		Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직책",		Type:"Text",		Hidden:0,		Width:60,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직위",		Type:"Text",		Hidden:0,		Width:60,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			//{Header:"차수|차수",			Type:"Int",	  		Hidden:0,  		Width:50,	Align:"center", ColMerge:0, SaveName:"appSeq",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5 },
			//{Header:"순번|순번",			Type:"Int",	  		Hidden:0,  		Width:50,	Align:"center", ColMerge:0, SaveName:"appSeq",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5 },
			//{Header:"점수|점수",			Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"app1stScr",	KeyField:0,				CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			//{Header:"순위|순위",			Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"app1stRk",	KeyField:0,				CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appTypeCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appStepCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appSeqDetail",KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appSabun",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appBetweenYn",KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
		]; 
		if (convertParam.appStepCd == "3") { // 목표합의
			initdata.Cols.push({Header:"주간일지|주차",			Type:"Text",		Hidden:0,		Width:200,	Align:"Center",	ColMerge:0,	SaveName:"examDt",		KeyField:0,		UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"주간일지|작성여부",		Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"examAppStatYn",KeyField:0,	UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"확인|확인",				Type:"Image",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,		Format:"",		Cursor:"Pointer" });
			initdata.Cols.push({Header:"평가상태|평가상태",		Type:"Combo",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appStatCd",	KeyField:0,		UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"평가기간|시작일",		Type:"Date",		Hidden:0,  		Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appStDt",		KeyField:0,		Format:"Ymd",	UpdateEdit:0, 	InsertEdit:0,	PointCount:0,   EditLen:10 });
			initdata.Cols.push({Header:"평가기간|종료일",		Type:"Date",		Hidden:0,  		Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appEndDt",	KeyField:0,		Format:"Ymd",	UpdateEdit:1, 	InsertEdit:0,	PointCount:0,   EditLen:10 });
		} else if (convertParam.appStepCd == "5") { // 중간점검(평가자)
			initdata.Cols.push({Header:"수습개월|수습개월",		Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"internMonths",KeyField:0,				UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"작성|작성",				Type:"Image",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	Format:"",		Cursor:"Pointer" });
			initdata.Cols.push({Header:"평가상태|평가상태",		Type:"Combo",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appStatCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"평가기간|시작일",		Type:"Date",		Hidden:0,  		Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appStDt",		KeyField:1,		Format:"Ymd",			UpdateEdit:0, 	InsertEdit:0,	PointCount:0,   EditLen:10 });
			initdata.Cols.push({Header:"평가기간|종료일",		Type:"Date",		Hidden:0,  		Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appEndDt",	KeyField:0,		Format:"Ymd",			UpdateEdit:0, 	InsertEdit:0,	PointCount:0,   EditLen:10 });
		} else if (convertParam.appStepCd == "7") { // 평가자평가(1차), 평가(2차)는 다른 팝업을 호출.
			initdata.Cols.push({Header:"수습기간|수습기간",				Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"internFt",	KeyField:0,				UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"수습\n연장여부|수습\n연장여부",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"extendYn",	KeyField:0,				UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"평가표\n작성여부|평가표\n작성여부",Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"observeYn",	KeyField:0,				UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"작성|작성",				Type:"Image",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,	Format:"",		Cursor:"Pointer" });
			initdata.Cols.push({Header:"평가상태|평가상태",		Type:"Combo",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appStatCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0});
			initdata.Cols.push({Header:"평가기간|시작일",		Type:"Date",		Hidden:0,  		Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appStDt",		KeyField:1,		Format:"Ymd",			UpdateEdit:0, 	InsertEdit:0,	PointCount:0,   EditLen:10 });
			initdata.Cols.push({Header:"평가기간|종료일",		Type:"Date",		Hidden:0,  		Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appEndDt",		KeyField:0,		Format:"Ymd",			UpdateEdit:0, 	InsertEdit:0,	PointCount:0,   EditLen:10 });
		} 
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);sheet1.SetUnicodeByte(3);
		
		sheet1.FocusAfterProcess = false;
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.FitColWidth();

		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);
		
		var appStatCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20021"), "");	//P20021:평가진행상태
		sheet1.SetColProperty("appStatCd",		{ComboText:appStatCdList[0], ComboCode:appStatCdList[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
		//var param = '${Param}';
		doAction1("Search");
	});
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				var param = "searchText="+$("#searchText").val();
			    sheet1.DoSearch( "${ctx}/InternEval.do?cmd=getInternOtherEvalListPopupList", $("#empForm").serialize());
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
				var appStepCd = sheet1.GetCellValue(i, "appStepCd");
				var examAppStatYn = sheet1.GetCellValue(i, "examAppStatYn");
				var appStatusCd = sheet1.GetCellValue(i, "appStatCd");
				var appSeq = sheet1.GetCellValue(i, "appSeq");
				var appBetweenYn = sheet1.GetCellValue(i, "appBetweenYn"); 
				for (var j=0; j<sheet1.ColCount; j++) {
					if ((appStepCd == "3" && examAppStatYn == "Y" && appBetweenYn == "Y"  && appStatusCd != "30")) {
						sheet1.SetCellFontColor(i, j, "blue");
					} else if (appStepCd == "5" && appBetweenYn == "Y" && appStatusCd != "30") {
						sheet1.SetCellFontColor(i, j, "blue");
					} else if (appStepCd == "7" && appBetweenYn == "Y" && appStatusCd != "30") {
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
				var src = "";
				var height = "";
				var width = "";
				var calFunc;
				var param;
				var title;
				if (sheet1.GetCellValue(Row, "appStepCd") == '3') { // 주간일지확인
					title = "수습 OJT 주간일지 확인";
					src = "InternEval.do?cmd=viewInternSelfEvalDetailPopup"
					width = "90%";
					height= "90%";
					param = {
							appStatus: sheet1.GetCellValue(Row, "appStepCd"),
							sabun: sheet1.GetCellValue(Row, "sabun"),
							appSabun: sheet1.GetCellValue(Row, "appSabun"),
							title: title,
							appraisalCd: sheet1.GetCellValue(Row, "appraisalCd"),
					};
				} else if (sheet1.GetCellValue(Row, "appStepCd") == '5') { // 수습관찰표
					title = "수습관찰표";
					src = "InternEval.do?cmd=viewInternOtherEvalObservePopup"
					width = "80%";
					height= "80%";
					param = {
							appStatus: sheet1.GetCellValue(Row, "appStepCd"),
							sabun: sheet1.GetCellValue(Row, "sabun"),
							appSabun: sheet1.GetCellValue(Row, "appSabun"),
							title: title,
							appraisalCd: sheet1.GetCellValue(Row, "appraisalCd"),
					};
				} else if (sheet1.GetCellValue(Row, "appStepCd") == '7') { // 수습평가표
					title = "수습평가표";
					src = "InternEval.do?cmd=viewInternOtherEvalSheetListPopup"
					width = "70%";
					height= "80%";
					param = {
							appStepCd: sheet1.GetCellValue(Row, "appStepCd"),
							sabun: sheet1.GetCellValue(Row, "sabun"),
							appSabun: sheet1.GetCellValue(Row, "appSabun"),
							title: title,
							appraisalCd: sheet1.GetCellValue(Row, "appraisalCd"),
							appSeqDetail: sheet1.GetCellValue(Row, "appSeqDetail"),
					};
				}
				
				openModalPopup(src, param, width, height
				, function(){
					doAction1("Search");
				}
				, {title:title});				
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
		<input type="hidden" id="appStepCd" name="appStepCd"/>
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



