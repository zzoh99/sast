<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style>
	.button_blue {
		background-color: #2570f9;
		color: white !important;
		border: none;
		padding: 7px 16px;
		border-radius: 10px;
	}
</style>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var p = eval("${popUpStatus}");
	var sdate1 = "${param.sdate}";
	var versionNm = "${param.versionNm}";
	
	var chooseSheet1RowIdx = -1;
	var chooseSheet2RowIdx = -1;
	var chooseSheet3RowIdx = -1;
	var chooseSheet4RowIdx = -1;
	
	var simulationInfoData = null;
	var changeYn = "N";

	$(function() {
		
		simulationInfoData = ajaxCall( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationInfo", "sdate="+sdate1, false );
		if(simulationInfoData != null && simulationInfoData.DATA != null) {
			changeYn = simulationInfoData.DATA.changeYn;
		}
	
		$("#sdate", "#mySheetForm").val(sdate1);
		$("#versionNm", "#mySheetForm").val(versionNm);
		
		// 트리레벨 정의
		$("#btnPlus").toggleClass("minus");

		$("#btnPlus").click(function() {
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet1.ShowTreeLevel(-1):sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep1").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				sheet1.ShowTreeLevel(-1);
			}
		});
		
		// 소속 조직원 검색 입력 항목 키입력 이벤트
		$("#searchKeyword1").bind("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction2("Search");
			}
		});
		
		// 미소속 조직원 검색 입력 항목 키입력 이벤트
		$("#searchKeyword2, #searchOrg2").bind("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction3("Search");
			}
		});
		
		// 조직원 검색 입력 항목 키입력 이벤트
		$("#searchKeyword3, #searchOrg3").bind("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction4("Search");
			}
		});
		
		if(changeYn == "Y") {
			$("#btn__reset, #btn__move_left, #btn__move_right, #btn__delete").hide();
		}
		
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msBaseColumnMerge+msHeaderOnly,PrevColumnMergeMode:1};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },			
			{Header:"시작일|시작일",				Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",				KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"상위소속코드|상위소속코드",	Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",			KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속코드|소속코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",				KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속명|소속명",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  TreeCol:1 },
			{Header:"조직\n변경구분|조직\n변경구분",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"changeGubun",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직\n변경사항|조직\n변경사항",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"changeGubunNm",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속 조직원수|개편전",		Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"empCount",			KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  FontColor:"#787878" },
			{Header:"소속 조직원수|전입",			Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"addCount",			KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  FontColor:"#f4617c" },
			{Header:"소속 조직원수|전출",			Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"movedTargetCount",	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  FontColor:"#018ed3" },
			{Header:"소속 조직원수|개편후",		Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"empCountAfter",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  FontColor:"#000000" }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.ShowTreeLevel(-1);
		sheet1.SetSumValue("sNo", "합계") ;
		
		
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:1,  Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:0,  Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"선택",			Type:"DummyCheck",	Hidden:0,  Width:65,	Align:"Center",		ColMerge:0,   SaveName:"select",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",			Type:"Text",		Hidden:0,  Width:55,	Align:"Center",		ColMerge:0,   SaveName:"sabun",			KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",			Type:"Text",		Hidden:0,  Width:55,	Align:"Center",		ColMerge:0,   SaveName:"name",			KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책코드",		Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikchakCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",			Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikchakNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급코드",		Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"jikgubCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",			Type:"Text",		Hidden:0,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"jikgubNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위코드",		Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위",			Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직군코드",		Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"workType",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직군",			Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"workTypeNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"현소속",		Type:"Text",		Hidden:0,  Width:120,	Align:"Left",		ColMerge:0,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"현소속코드",		Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"orgCd",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"변경소속",		Type:"Text",		Hidden:0,  Width:120,	Align:"Left",		ColMerge:0,   SaveName:"orgNmAfter",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"변경소속코드",	Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"orgCdAfter",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"발령형태",		Type:"Text",		Hidden:1,  Width:0,		Align:"Center",		ColMerge:0,   SaveName:"ordTypeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"발령종류",		Type:"Text",		Hidden:1,  Width:0,		Align:"Center",		ColMerge:0,   SaveName:"ordDetailCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(true);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetFocusAfterProcess(false);


		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata3.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:1,  Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,  Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,  Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"선택",			Type:"DummyCheck",	Hidden:0,  Width:65,	Align:"Center",		ColMerge:0,   SaveName:"select",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",			Type:"Text",		Hidden:0,  Width:55,	Align:"Center",		ColMerge:0,   SaveName:"sabun",			KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",			Type:"Text",		Hidden:0,  Width:55,	Align:"Center",		ColMerge:0,   SaveName:"name",			KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책코드",		Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikchakCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",			Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikchakNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급코드",		Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"jikgubCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",			Type:"Text",		Hidden:0,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"jikgubNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위코드",		Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위",			Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"현소속",		Type:"Text",		Hidden:0,  Width:150,	Align:"Left",		ColMerge:0,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"현소속코드",		Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"orgCd",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"변경소속코드",	Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"orgCdAfter",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable(true);sheet3.SetVisible(true);sheet3.SetCountPosition(4);
		sheet3.SetFocusAfterProcess(false);


		var initdata4 = {};
		initdata4.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata4.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:1,  Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,  Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,  Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"선택",			Type:"DummyCheck",	Hidden:0,  Width:65,	Align:"Center",		ColMerge:0,   SaveName:"select",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"사번",			Type:"Text",		Hidden:0,  Width:55,	Align:"Center",		ColMerge:0,   SaveName:"sabun",			KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",			Type:"Text",		Hidden:0,  Width:55,	Align:"Center",		ColMerge:0,   SaveName:"name",			KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책코드",		Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikchakCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",			Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikchakNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급코드",		Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"jikgubCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",			Type:"Text",		Hidden:0,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"jikgubNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위코드",		Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위",			Type:"Text",		Hidden:1,  Width:60,	Align:"Center",		ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"현소속",		Type:"Text",		Hidden:0,  Width:150,	Align:"Left",		ColMerge:0,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"현소속코드",		Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"orgCd",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"변경소속",		Type:"Text",		Hidden:0,  Width:120,	Align:"Left",		ColMerge:0,   SaveName:"orgNmAfter",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"변경소속코드",	Type:"Text",		Hidden:1,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"orgCdAfter",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
		]; IBS_InitSheet(sheet4, initdata4);sheet4.SetEditable(true);sheet4.SetVisible(true);sheet4.SetCountPosition(4);
		sheet4.SetFocusAfterProcess(false);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
		doAction3("Search");
		
		$("#mode__cart").trigger('click');
	});
	
	// 시트 리사이즈
	function sheetResize() {
		var outer_height = getOuterHeight();
		var inner_height = 0;
		var value = 0;

		$(".ibsheet").each(function() {
			inner_height = getInnerHeight($(this));
			if ($(this).attr("fixed") == "false") {
				value = parseInt(($(window).height() - outer_height) / $(this).attr("sheet_count") - inner_height);
				value -= 85;
				if (value < 100) value = 100;
				$(this).height(value);
			}
		});

		clearTimeout(timeout);
		timeout = setTimeout(addTimeOut, 50);
	}
	
	// 초기화
	function reset() {
		if(confirm("지금까지 진행하신 내용이 초기화됩니다.\n진행하시겠습니까?")) {
			var data = ajaxCall("${ctx}/OrgChangeSchemeMgr.do?cmd=deleteSchemeSimulationEmpAll", $("#mySheetForm").serialize(), false);
			if ( data != null && data != undefined && data.Result != null && data.Result != undefined ) {
				alert(data.Result["Message"]);
				doAction2("Search");
				doAction3("Search");
			}else{
				alert("초기화에 실패하였습니다.");
			}
		}
	}
	
	// 모드 변경
	function toggleMode(mode) {
		if(mode == "cart") {
			$(".type__search").addClass("hide");
			$(".type__cart").removeClass("hide");
		} else {
			$(".type__cart").addClass("hide");
			$(".type__search").removeClass("hide");
			
			// 조회된 목록이 없는 경우 조회 실행.
			if(($("#searchKeyword3").val() == "" || $("#searchOrg3").val() == "") && sheet4.LastRow() == 0) {
				doAction4("Search");
			}
			
		}
		sheetResize();
	}
</script>

<!-- [sheet1] Start -->
<script type="text/javascript">
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationEmpOrgList", $("#mySheetForm").serialize(), 1 );
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			// 변경사항에 따른 출력 변경
			var changeGubun      = null;
			var backColor        = null;
			var fontColor        = null;
			var empCount         = 0;
			var addCount         = 0;
			var movedTargetCount = 0;
			var empCountAfter    = 0;
			for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow() - 1; i++){
				changeGubun      = sheet1.GetCellValue(i, "changeGubun");
				empCount         = sheet1.GetCellValue(i, "empCount");
				addCount         = sheet1.GetCellValue(i, "addCount");
				movedTargetCount = sheet1.GetCellValue(i, "movedTargetCount");
				
				// 개편후 인원수 계산
				empCountAfter = (parseInt(empCount, 10) + parseInt(addCount, 10)) - parseInt(movedTargetCount, 10);
				
				// 1:신규
				// 2:조직명변경
				// 3:상위조직변경
				// 4:폐지
				backColor = "#ffffff";
				if( (changeGubun != "") || (parseInt(addCount) > 0 || parseInt(movedTargetCount) > 0) ) {
					backColor = "";
					if(changeGubun == "1") {
						fontColor = "#000000";
					}else if(changeGubun == "2") {
						fontColor = "#f4617c";
					}else if(changeGubun == "3") {
						fontColor = "#018ed3";
					}else if(changeGubun == "4") {
						fontColor = "#898989";
					}else{
						sheet1.SetCellValue(i, "changeGubunNm", "인원변동");
					}
					sheet1.SetCellFontColor(i, 6, fontColor);
				}
				
				sheet1.SetRangeBackColor(i, 0, i, sheet1.LastCol(), backColor);
				sheet1.SetCellValue(i, "empCountAfter", empCountAfter);
			}
			
			if(chooseSheet1RowIdx > -1) {
				sheet1.SetSelectRow(chooseSheet1RowIdx);
			}
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					
					$("#chooseOrgNm").html("선택 조직 : <strong class='f_point'>" + sheet1.GetCellValue(NewRow, "orgNm") + "</strong>");
					
					// 소속조직원 검색어 입력 객체값 초기화
					$("#searchKeyword1").val("");
					
					// 소속 조직원 조회
					doAction2("Search");
					
					// [OnSearchEnd] 이벤트 후 무조건 첫번째 행이 선택되는 이슈가 있어 두번째행이상 선택 시 선택행 정보 저장 처리함.
					// 첫번째행의 경우 조직이 아닌 회사이기 때문에 선택행 정보를 저장하지 않아도 무방함.
					if(sheet1.GetSelectRow() > 1 ) {
						chooseSheet1RowIdx = NewRow;
					}
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
		}
	}
</script>
<!-- [sheet1] End -->

<!-- [sheet2] Start -->
<script type="text/javascript">

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#orgCd", "#mySheetForm").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"orgCd"));
			sheet2.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationEmpMemberList", $("#mySheetForm").serialize(), 1 );
			break;
		
		case "MoveToMovedTarget":	// 조직이동대상자 목록으로 이동
			if(sheet2.CheckedRows("select") == 0) {
				alert("직원을 선택하세요.");
				return;
			}
			
			for(var i=1; i <= sheet2.LastRow(); i++){
				// 수정처리함
				if(sheet2.GetCellValue(i,"select") == "1"){
					sheet2.SetCellValue(i,"sStatus", "U");
					sheet2.SetCellValue(i,"orgCdAfter", "");
				} else {
					sheet2.SetCellValue(i,"sStatus", "R");
				}
			}
			
			IBS_SaveName(document.mySheetForm,sheet2);
			sheet2.DoSave( "${ctx}/OrgChangeSchemeMgr.do?cmd=saveSchemeSimulationEmp", $("#mySheetForm").serialize());
			break;
			
		case "CancelToSearch":	// 소속변경 취소(검색 지정 방식인 경우 사용)
			if(sheet2.CheckedRows("select") == 0) {
				alert("직원을 선택하세요.");
				return;
			}
			
			for(var i=1; i <= sheet2.LastRow(); i++){
				// 삭제처리함.
				if(sheet2.GetCellValue(i,"select") == "1"){
					sheet2.SetCellValue(i,"sStatus", "D");
					sheet2.SetCellValue(i,"sDelete", 1);
					sheet2.SetCellValue(i,"orgCdAfter", "");
				} else {
					sheet2.SetCellValue(i,"sStatus", "R");
				}
			}
			
			IBS_SaveName(document.mySheetForm,sheet2);
			sheet2.DoSave( "${ctx}/OrgChangeSchemeMgr.do?cmd=saveSchemeSimulationEmp", $("#mySheetForm").serialize());
			break;
			
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			// 변경사항에 따른 출력 변경
			var backColor        = null;

			for(var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++){
				backColor = "#ffffff";
				if(sheet2.GetCellValue(i,"orgNmAfter") != "" ) {
					backColor = "";
				}
				sheet2.SetRangeBackColor(i, 0, i, sheet2.LastCol(), backColor);
			}
			
			if(chooseSheet2RowIdx > -1) {
				sheet2.SetSelectRow(chooseSheet2RowIdx);
			}
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}


	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction1("Search");
			doAction3("Search");
			doAction4("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

</script>
<!-- [sheet2] End -->

<!-- [sheet3] Start -->
<script type="text/javascript">

	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
			case "Search":
				sheet3.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationEmpIndependentMemberList", $("#mySheetForm").serialize(), 1 );
				break;
				
			case "SetOrgCdAfter":	// 변경소속지정 처리
				
				var orgCd = $("#orgCd", "#mySheetForm").val();
				if(orgCd == "") {
					alert("조직을 선택하세요.");
					return;
				}
				
				if(sheet3.CheckedRows("select") == 0) {
					alert("직원을 선택하세요.");
					return;
				}
				
				for(var i=1; i <= sheet3.LastRow(); i++){
					if(sheet3.GetCellValue(i,"select") == "1"){
						// 변경소속이 현소속부서인 경우 삭제 처리.
						if(sheet3.GetCellValue(i, "orgCd") == orgCd) {
							sheet3.SetCellValue(i,"sStatus", "D");
							sheet3.SetCellValue(i,"sDelete", 1);
							sheet3.SetCellValue(i,"orgCdAfter", "");
						} else {
							sheet3.SetCellValue(i,"sStatus", "U");
							sheet3.SetCellValue(i,"orgCdAfter", orgCd);
						}
					} else {
						sheet3.SetCellValue(i,"sStatus", "R");
					}
				}
				
				IBS_SaveName(document.mySheetForm,sheet3);
				sheet3.DoSave( "${ctx}/OrgChangeSchemeMgr.do?cmd=saveSchemeSimulationEmp", $("#mySheetForm").serialize());
				break;
				
			case "Delete":	// 삭제
				if(sheet3.CheckedRows("select") == 0) {
					alert("삭제 대상 직원을 선택하세요.");
					return;
				}
				
				if(confirm("폐쇄 설정된 조직의 조직원인 경우 삭제 대상에서 제외됩니다.\n\n삭제하시겠습니까?")) {
					for(var i=1; i <= sheet3.LastRow(); i++){
						if(sheet3.GetCellValue(i,"select") == "1"){
							sheet3.SetCellValue(i,"sStatus", "D");
							sheet3.SetCellValue(i,"sDelete", 1);
						} else {
							sheet3.SetCellValue(i,"sStatus", "R");
						}
					}
	
					IBS_SaveName(document.mySheetForm,sheet3);
					sheet3.DoSave( "${ctx}/OrgChangeSchemeMgr.do?cmd=saveSchemeSimulationEmp", $("#mySheetForm").serialize());
				}
				break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
	
			doAction1("Search");
			doAction3("Search");
			doAction4("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

</script>
<!-- [sheet3] End -->

<!-- [sheet4] Start -->
<script type="text/javascript">

	//Sheet4 Action
	function doAction4(sAction) {
		switch (sAction) {
			case "Search":
				sheet4.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationEmpMemberSearchList", $("#mySheetForm").serialize(), 1 );
				break;
				
			case "SetOrgCdAfter":	// 변경소속지정 처리
				
				var orgCd = $("#orgCd", "#mySheetForm").val();
				if(orgCd == "") {
					alert("조직을 선택하세요.");
					return;
				}
				
				if(sheet4.CheckedRows("select") == 0) {
					alert("직원을 선택하세요.");
					return;
				}
				
				for(var i=1; i <= sheet4.LastRow(); i++){
					if(sheet4.GetCellValue(i,"select") == "1"){
						// 변경소속이 현소속부서인 경우 삭제 처리.
						if(sheet4.GetCellValue(i, "orgCd") == orgCd) {
							sheet4.SetCellValue(i,"sStatus", "D");
							sheet4.SetCellValue(i,"sDelete", 1);
							sheet4.SetCellValue(i,"orgCdAfter", "");
						} else {
							sheet4.SetCellValue(i,"sStatus", "U");
							sheet4.SetCellValue(i,"orgCdAfter", orgCd);
						}
					} else {
						sheet4.SetCellValue(i,"sStatus", "R");
					}
				}
				
				IBS_SaveName(document.mySheetForm,sheet4);
				sheet4.DoSave( "${ctx}/OrgChangeSchemeMgr.do?cmd=saveSchemeSimulationEmp", $("#mySheetForm").serialize());
				break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
	
			doAction1("Search");
			doAction3("Search");
			doAction4("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

</script>
<!-- [sheet4] End -->
</head>
<body class="bodywrap">
	<div class="wrapper">
	
		<form id="mySheetForm" name="mySheetForm" >
			<input type="hidden" id="sdate" name="sdate" />
			<input type="hidden" id="versionNm" name="versionNm" />
			<input type="hidden" id="orgCd" name="orgCd" />
			
			<div class="sheet_title" style="padding:0px 20px;">
				<ul>
					<li class="txt big">개편안작성[인사]</li>
					<li class="btn">
						<label for="mode__cart"><input type="radio" name="mode" id="mode__cart" class="valignM" value="cart" checked="checked" onclick="javascript:toggleMode('cart');" /> 조직이동대상자 선지정 방식</label>
						<label for="mode__search"><input type="radio" name="mode" id="mode__search" class="valignM" value="search" onclick="javascript:toggleMode('search');" /> 검색 지정 방식</label>
						<a href="javascript:reset();" id="btn__reset" class="btn filled">초기화</a>
					</li>
				</ul>
			</div>
			<div class="mat15" style="padding:0 20px;">
				<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
					<colgroup>
						<col width="32%" />
						<col width="1%" />
						<col width="32%" />
						<col width="3%" />
						<col width="32%" />
					</colgroup>
					<tbody>
						<tr>
							<td class="sheet_left">
								<div class="inner">
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">
												조직도
												<div class="util">
													<ul>
														<li	id="btnPlus"></li>
														<li	id="btnStep1"></li>
														<li	id="btnStep2"></li>
														<li	id="btnStep3"></li>
													</ul>
												</div>
											</li>
											<li class="btn">
												<span id="chooseOrgNm" class="valignM"></span>
												&nbsp;
												<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="새로고침"/>
											</li>
										</ul>
									</div>
								</div>
								<script type="text/javascript"> createIBSheet("sheet1", "30%", "100%", "kr"); </script>
							</td>
							<td>&nbsp;</td>
							<td class="sheet_right">
								<div class="inner">
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">소속 조직원</li>
											<li class="btn">
												<input type="text" name="searchKeyword1" id="searchKeyword1" class="text alignL w150" placeholder="이름/사번" />
												<btn:a href="javascript:doAction2('Search');" css="btn dark" mid='search' mdef="조회"/>
											</li>
										</ul>
									</div>
								</div>
								<script type="text/javascript"> createIBSheet("sheet2", "30%", "100%", "kr"); </script>
							</td>
							<td class="type__cart sheet_right alignC valignM">
								<a href="javascript:doAction3('SetOrgCdAfter');" id="btn__move_left"><img src="/common/images/common/arrow_left1.gif"/></a><br/><br/>
								<a href="javascript:doAction2('MoveToMovedTarget');" id="btn__move_right"><img src="/common/images/common/arrow_right1.gif"/></a>
							</td>
							<td class="type__cart sheet_right">
								<div class="inner">
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">조직이동 대상자</li>
											<li class="btn">
												<span class="strong">이름/사번</span>
												&nbsp;
												<input type="text" name="searchKeyword2" id="searchKeyword2" class="text alignL w100" placeholder="이름/사번" />
												&nbsp;
												<span class="strong">부서명</span>
												&nbsp;
												<input type="text" name="searchOrg2" id="searchOrg2" class="text alignL w100" placeholder="부서명" />
												<btn:a href="javascript:doAction3('Delete');" css="btn filled" mid='search' id="btn__delete" mdef="삭제"/>
												<btn:a href="javascript:doAction3('Search');" css="btn dark" mid='search' mdef="조회"/>
											</li>
										</ul>
									</div>
								</div>
								<script type="text/javascript"> createIBSheet("sheet3", "30%", "100%", "kr"); </script>
							</td>
							<td class="type__search sheet_right alignC valignM hide">
								<a href="javascript:doAction4('SetOrgCdAfter');"><img src="/common/images/common/arrow_left1.gif"/></a><br/><br/>
								<a href="javascript:doAction2('CancelToSearch');"><img src="/common/images/common/arrow_right1.gif"/></a>
							</td>
							<td class="type__search sheet_right hide">
								<div class="inner">
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">검색</li>
											<li class="btn">
												<span class="strong">이름/사번</span>
												&nbsp;
												<input type="text" name="searchKeyword3" id="searchKeyword3" class="text alignL w100" placeholder="이름/사번" />
												&nbsp;
												<span class="strong">부서명</span>
												&nbsp;
												<input type="text" name="searchOrg3" id="searchOrg3" class="text alignL w100" placeholder="부서명" />
												<btn:a href="javascript:doAction4('Search');" css="button" mid='search' mdef="조회"/>
											</li>
										</ul>
									</div>
								</div>
								<script type="text/javascript"> createIBSheet("sheet4", "30%", "100%", "kr"); </script>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
		</form>
		
	</div>
</body>
</html>