<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style>
	.btn_temp_blue {
		background-color: #2570f9;
		color: white !important;
		border: none;
		padding: 7px 16px;
		border-radius: 10px;
	}
	.btn_temp_white {
		background-color: #FFFFFF;
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
	
	$(function() {
		
		$("input[name=sdate]").val(sdate1);
		$("input[name=versionNm]").val(versionNm);
		
		// 검색 입력 항목 키입력 이벤트
		$("select[name=searchChangeGubun]", "#searchForm1").change(function(){
			doAction1("Search");
		});
		$("input[name=searchOrg]", "#searchForm1").bind("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		// 검색 입력 항목 키입력 이벤트
		$("select[name=searchChangeGubun]", "#searchForm2").change(function(){
			doAction2("Search");
		});
		$("input[name=searchOrg],input[name=searchEmp]", "#searchForm2").bind("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction2("Search");
			}
		});
		
		// 검색 입력 항목 키입력 이벤트
		$("select[name=searchChangeGubun]", "#searchForm3").change(function(){
			doAction3("Search");
		});
		$("input[name=searchOrg],input[name=searchEmp]", "#searchForm3").bind("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction3("Search");
			}
		});

	
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msBaseColumnMerge+msHeaderOnly,PrevColumnMergeMode:1};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No|No",														Type:"${sNoTy}",	Hidden:1,  Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",														Type:"${sSttTy}",	Hidden:1,  Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"조직|조직",														Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"orgNm",				KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"구분\n(신규/이동/폐지/조직명변경)|구분\n(신규/이동/폐지/조직명변경)",	Type:"Text",		Hidden:0,  Width:80,	Align:"Center",		ColMerge:0,   SaveName:"changeGubunNm",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"변경前|소속코드",												Type:"Text",		Hidden:0,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"orgCdPre",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#fafafa" },
			{Header:"변경前|소속명",													Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"orgNmPre",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#fafafa" },
			{Header:"변경後|소속코드",												Type:"Text",		Hidden:0,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"orgCdAfter",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#f6f6f6" },
			{Header:"변경後|소속명",													Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"orgNmAfter",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#f6f6f6" }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetFocusAfterProcess(false);
		
		var initdata2 = {};
		initdata2.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msBaseColumnMerge+msHeaderOnly,PrevColumnMergeMode:1};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No",											Type:"${sNoTy}",	Hidden:1,  Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",											Type:"${sSttTy}",	Hidden:1,  Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"조직|조직",										Type:"Text",		Hidden:0,  Width:80,	Align:"Center",		ColMerge:0,   SaveName:"orgNm",					KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"조직코드|조직코드",								Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"orgCd",					KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"구분\n(신규/폐지/변경)|구분\n(신규/폐지/변경)",		Type:"Text",		Hidden:0,  Width:80,	Align:"Center",		ColMerge:0,   SaveName:"changeGubunNm",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"변경前|성명",									Type:"Text",		Hidden:0,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"chiefNmPre",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#fafafa" },
			{Header:"변경前|사번",									Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"chiefSabunPre",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#fafafa" },
			{Header:"변경前|직위",									Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"chiefJikweeNmPre",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#fafafa" },
			{Header:"변경前|직급",									Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"chiefJikgubNmPre",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#fafafa" },
			{Header:"변경後|성명",									Type:"Text",		Hidden:0,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"chiefNmAfter",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#f6f6f6" },
			{Header:"변경後|사번",									Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"chiefSabunAfter",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#f6f6f6" },
			{Header:"변경後|직위",									Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"chiefJikweeAfter",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#f6f6f6" },
			{Header:"변경後|직급",									Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"chiefJikgubAfter",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#f6f6f6" }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetFocusAfterProcess(false);
		
		var initdata3 = {};
		initdata3.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msBaseColumnMerge+msHeaderOnly,PrevColumnMergeMode:1};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata3.Cols = [
			{Header:"No",											Type:"${sNoTy}",	Hidden:1,  Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",											Type:"${sSttTy}",	Hidden:1,  Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"성명|성명",										Type:"Text",		Hidden:0,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"사번|사번",										Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"sabun",				KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"직위|직위",										Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"jikweeNm",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"직급|직급",										Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"jikgubNm",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"직책|직책",										Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"jikchakNm",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"구분\n(이동/조직명변경)|구분\n(이동/조직명변경)",	Type:"Text",		Hidden:0,  Width:80,	Align:"Center",		ColMerge:0,   SaveName:"changeGubunNm",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#ffffff" },
			{Header:"변경前|소속코드",								Type:"Text",		Hidden:0,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"orgCdPre",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#fafafa" },
			{Header:"변경前|소속명",									Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"orgNmPre",			KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#fafafa" },
			{Header:"변경後|소속코드",								Type:"Text",		Hidden:0,  Width:70,	Align:"Center",		ColMerge:0,   SaveName:"orgCdAfter",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#f6f6f6" },
			{Header:"변경後|소속명",									Type:"Text",		Hidden:0,  Width:90,	Align:"Center",		ColMerge:0,   SaveName:"orgNmAfter",		KeyField:0,   CalcLogic:"",   Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   BackColor:"#f6f6f6" }
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable(false);sheet3.SetVisible(true);sheet3.SetCountPosition(4);
		sheet3.SetFocusAfterProcess(false);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	});
	
	// 시트 리사이즈
	function sheetResize() {
		var outer_height = getOuterHeight();
		var inner_height = 0;
		var value = 0;

		$(".ibsheet").each(function() {
			inner_height = getInnerHeight($(this));
			if ($(this).attr("fixed") == "false") {
				value = parseInt((($(window).height() - outer_height) / 3) - inner_height);
				if (value < 100) value = 100;
				$(this).height(value);
			}
		});

		clearTimeout(timeout);
		timeout = setTimeout(addTimeOut, 50);
	}
	
</script>

<!-- [sheet1] Start -->
<script type="text/javascript">
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationReOrgList1", $("#searchForm1").serialize(), 1 );
				break;
			case "Down2Excel":
				sheet1.Down2Excel({FileName:'[개편현황] 조직변경',SheetName:'조직변경'});
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
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
				sheet2.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationReOrgList2", $("#searchForm2").serialize(), 1 );
				break;
			case "Down2Excel":
				sheet2.Down2Excel({FileName:'[개편현황] 조직장변경',SheetName:'조직장변경'});
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
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
				sheet3.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationReOrgList3", $("#searchForm3").serialize(), 1 );
				break;
			case "Down2Excel":
				sheet3.Down2Excel({FileName:'[개편현황] 인사이동',SheetName:'인사이동'});
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
</script>
<!-- [sheet3] End -->
</head>
<body class="bodywrap">
	<div class="wrapper" style="overflow: auto">
		<div class="sheet_title" style="padding:0px 20px;">
			<ul>
				<li class="txt big">개편현황</li>
			</ul>
		</div>
		
		<div class="mat15" style="padding:0 20px;">

			<div class="outer">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">조직변경</li>
						<li class="btn">
							<form id="searchForm1" name="searchForm1" >
								<input type="hidden" name="sdate" />
								<input type="hidden" name="versionNm" />
								<span class="strong">구분</span>
								&nbsp;
								<select name="searchChangeGubun" class="w150">
									<option value="">-전체-</option>
									<option value="1">신규</option>
									<option value="3">상위조직변경</option>
									<option value="4">폐지</option>
								</select>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<span class="strong">부서명/부서코드</span>
								&nbsp;
								<input type="text" name="searchOrg" class="text alignL w100" placeholder="부서명/부서코드" />
							</form>
							<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray" mid='down2Excel' mdef='다운로드'/>
							<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
						</li>
					</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "25%", "kr"); </script>
			</div>

			<div class="inner mat15">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">조직장변경</li>
						<li class="btn">
							<form id="searchForm2" name="searchForm2" >
								<input type="hidden" name="sdate" />
								<input type="hidden" name="versionNm" />
								<span class="strong">구분</span>
								&nbsp;
								<select name="searchChangeGubun" class="w150">
									<option value="">-전체-</option>
									<option value="1">신규</option>
									<option value="2">변경</option>
									<option value="4">폐지</option>
								</select>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<span class="strong">부서명/부서코드</span>
								&nbsp;
								<input type="text" name="searchOrg" class="text alignL w100" placeholder="부서명/부서코드" />
								&nbsp;&nbsp;&nbsp;&nbsp;
								<span class="strong">성명/사번</span>
								&nbsp;
								<input type="text" name="searchEmp" class="text alignL w100" placeholder="성명/사번" />
							</form>
							<btn:a href="javascript:doAction2('Down2Excel');" 	css="btn outline-gray" mid='down2Excel' mdef='다운로드'/>
							<btn:a href="javascript:doAction2('Search');" css="btn dark" mid='search' mdef="조회"/>
						</li>
					</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "25%", "kr"); </script>
			</div>

			<div class="inner mat15">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">인사이동</li>
						<li class="btn">
							<form id="searchForm3" name="searchForm3" >
								<input type="hidden" name="sdate" />
								<input type="hidden" name="versionNm" />
								<span class="strong">구분</span>
								&nbsp;
								<select name="searchChangeGubun" class="w150">
									<option value="">-전체-</option>
									<option value="1">이동</option>
								</select>
								&nbsp;&nbsp;&nbsp;&nbsp;
								<span class="strong">부서명/부서코드</span>
								&nbsp;
								<input type="text" name="searchOrg" class="text alignL w100" placeholder="부서명/부서코드" />
								&nbsp;&nbsp;&nbsp;&nbsp;
								<span class="strong">성명/사번</span>
								&nbsp;
								<input type="text" name="searchEmp" class="text alignL w100" placeholder="성명/사번" />
							</form>
							<btn:a href="javascript:doAction3('Down2Excel');" 	css="btn outline-gray" mid='down2Excel' mdef='다운로드'/>
							<btn:a href="javascript:doAction3('Search');" css="btn dark" mid='search' mdef="조회"/>
						</li>
					</ul>
				</div>
				<script type="text/javascript"> createIBSheet("sheet3", "100%", "25%", "kr"); </script>
			</div>

		</div>
		
	</div>
</body>
</html>