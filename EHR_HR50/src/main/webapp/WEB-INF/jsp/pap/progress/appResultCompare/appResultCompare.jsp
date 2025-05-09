<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">

	$(function() {

		//평가코드
		var appraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "비교대상 평가를 선택해주십시오.");
		$("#searchAppraisalCd1").html(appraisalCd[2]);
		$("#searchAppraisalCd2").html(appraisalCd[2]);
		$("#searchAppraisalCd3").html(appraisalCd[2]);
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"성명|성명",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",						KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번|사번",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",						KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속|소속",				Type:"Text",		Hidden:0,					Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위|직위",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급|직급",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책|직책",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
		
	});
	
	function initSheet1() {
		// 시트 초기화
		sheet1.Reset();
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22, MergeSheet:msAll};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"성명|성명",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"name",						KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번|사번",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sabun",						KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속|소속",				Type:"Text",		Hidden:0,					Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위|직위",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급|직급",				Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책|직책",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",					KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		];
		
		var firstTitle  = $("#searchAppraisalCd1 option:selected").text(); 
		var secondTitle = $("#searchAppraisalCd2 option:selected").text(); 
		var thirdTitle  = $("#searchAppraisalCd3 option:selected").text(); 

		initdata.Cols.push({Header:firstTitle + "|업적",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"firstFinalMboClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:firstTitle + "|역량",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"firstFinalCompClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:firstTitle + "|다면",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"firstFinalMutualClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:firstTitle + "|최종",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"firstFinalClassNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});

		initdata.Cols.push({Header:secondTitle + "|업적",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"secondFinalMboClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:secondTitle + "|역량",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"secondFinalCompClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:secondTitle + "|다면",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"secondFinalMutualClassNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:secondTitle + "|최종",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"secondFinalClassNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});

		initdata.Cols.push({Header:thirdTitle + "|업적",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"thirdFinalMboClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:thirdTitle + "|역량",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"thirdFinalCompClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:thirdTitle + "|다면",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"thirdFinalMutualClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});
		initdata.Cols.push({Header:thirdTitle + "|최종",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"thirdFinalClassNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0});

		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	// 조회 조건 체크
	function checkSearch() {
		if($("#searchAppraisalCd1").val() == "") {
			alert("첫번째 비교 대상 평가를 선택해주십시오.");
			return false;
		}
		if($("#searchAppraisalCd2").val() == "") {
			alert("두번째 비교 대상 평가를 선택해주십시오.");
			return false;
		}
		if($("#searchAppraisalCd3").val() == "") {
			alert("세번째 비교 대상 평가를 선택해주십시오.");
			return false;
		}
		if($("#searchAppraisalCd1").val() == $("#searchAppraisalCd2").val()) {
			alert("선택하신 첫번째 평가와 두번째 평가가 동일합니다.\n서로 다른 평가를 선택해주십시오.");
			return false;
		}
		if($("#searchAppraisalCd1").val() == $("#searchAppraisalCd3").val()) {
			alert("선택하신 첫번째 평가와 세번째 평가가 동일합니다.\n서로 다른 평가를 선택해주십시오.");
			return false;
		}
		if($("#searchAppraisalCd2").val() == $("#searchAppraisalCd3").val()) {
			alert("선택하신 두번째 평가와 세번째 평가가 동일합니다.\n서로 다른 평가를 선택해주십시오.");
			return false;
		}
		
		var firstAppTypeCd = $("#searchAppraisalCd1").val().substring(2, 3);
		var secondAppTypeCd = $("#searchAppraisalCd2").val().substring(2, 3);
		var thirdAppTypeCd = $("#searchAppraisalCd3").val().substring(2, 3);
		
		if(!(firstAppTypeCd == secondAppTypeCd && secondAppTypeCd == thirdAppTypeCd && thirdAppTypeCd == firstAppTypeCd)) {
			alert("비교 대상 평가의 평가종류가 동일하지 않습니다.\n비교 대상 평가의 평가종류를 동일하게 설정해주시기 바랍니다.");
			return false;
		}
		
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!checkSearch()) {
				break;
			}
			// 타이틀 변경
			initSheet1();

			sheet1.DoSearch( "${ctx}/AppResultCompare.do?cmd=getAppResultCompareList", $("#srchFrm").serialize() ); 
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
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<form id="srchFrm" name="srchFrm" >

	<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span class="w100">첫번째 비교 평가명</span>
							<select name="searchAppraisalCd1" id="searchAppraisalCd1">
							</select>
						</td>
						<td>
							<span class="w100">두번째 비교 평가명</span>
							<select name="searchAppraisalCd2" id="searchAppraisalCd2">
							</select>
						</td>
						<td>
							<span class="w100">세번째 비교 평가명</span>
							<select name="searchAppraisalCd3" id="searchAppraisalCd3">
							</select>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
						</td>
					</tr>					
				</table>
			</div>
		</div>
	</form>
		<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">평가결과비교</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" class="btn outline_gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>