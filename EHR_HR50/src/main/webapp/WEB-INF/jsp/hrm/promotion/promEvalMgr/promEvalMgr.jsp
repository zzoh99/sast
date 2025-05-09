<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>승진급심사관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

	$(function() {
        
		//Sheet 초기화
		init_sheet();
		
		//사번셋팅
		setEmpPage();
	});

	//Sheet 초기화
	function init_sheet() {

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,    Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"승진기준일",	Type:"Date",		Hidden:0, 	Width:90,	Align:"Center", ColMerge:0,	SaveName:"proYmd",				KeyField:0,	Format:"Ymd",	Edit:0 },
			{Header:"사번",		Type:"Text",		Hidden:0, 	Width:70,	Align:"Center", ColMerge:0,	SaveName:"sabun",				KeyField:0,	Edit:0 },
			{Header:"성명",		Type:"Text",		Hidden:0, 	Width:70,	Align:"Center", ColMerge:0,	SaveName:"name",				KeyField:0,	Edit:0 },
			{Header:"입사일",	Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",				KeyField:0,	Format:"Ymd",	Edit:0 },
			{Header:"직위",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Edit:0 },
			{Header:"승진표인트",	Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"total",				KeyField:0,	Edit:0 },
			{Header:"어학",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"langPoint",			KeyField:0,	Edit:0 },
			{Header:"추천",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compAppPoint1Dum",	KeyField:0,	Edit:0 },
			{Header:"교육",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"eduPoint",			KeyField:0,	Edit:0 },
			{Header:"사업개발",	Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"busPoint",			KeyField:0,	Edit:0 },
			{Header:"포상",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"rewardPoint",			KeyField:0,	Edit:0 },
			{Header:"징계",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"guiltPoint",			KeyField:0,	Edit:0 },
			{Header:"근태",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"pmPoint",				KeyField:0,	Edit:0 },
			{Header:"종합점수",	Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"totPoint",			KeyField:0,	Format:"NullInteger",	UpdateEdit:1,	InsertEdit:1 },
			{Header:"심사결과",	Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"lastYn",				KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	FalseValue:"N",	TrueValue:"Y" }
  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
  		
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		$(window).smartresize(sheetResize); sheetInit();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch("${ctx}/PromEvalMgr.do?cmd=getPromEvalMgrList", $("#sheet1Form").serialize());
	        	break;

	        case "Save":
	       		IBS_SaveName(document.sheet1Form,sheet1);
	        	sheet1.DoSave("${ctx}/PromEvalMgr.do?cmd=savePromEvalMgr", $("#sheet1Form").serialize());
	        	break;
	        	
	        case "Down2Excel":
				const downcol = makeHiddenSkipCol(sheet1);
				const param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}
	
	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction1("Search"); 
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	//인사헤더에서 이름 변경 시 호출 됨 
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	doAction1("Search");
    }
	
</script>
</head>
<body class="hidden">
	<div class="wrapper">
		<!-- include 기본정보 page -->
		<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

		<form id="sheet1Form" name="sheet1Form" >
			<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		</form>

		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="txt">승진급심사관리</li>
					<li class="btn">
						<a href="javascript:doAction1('Search')"		class="basic authR">조회</a>
						<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
						<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
					</li>
				</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
	</div>
</body>
</html>