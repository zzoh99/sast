<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var p = eval("${popUpStatus}");
	var sdate1 = "${param.sdate}";
	var versionNm = "${param.versionNm}";
	
	var chooseSheet1RowIdx = -1;
	
	var simulationInfoData = null;
	var appmtApplyChk = 0;
	var changeYn = "N";
	var preSdate = "";

	$(function() {
		
		simulationInfoData = ajaxCall( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationInfo", "sdate="+sdate1, false );
		if(simulationInfoData != null && simulationInfoData.DATA != null) {
			changeYn = simulationInfoData.DATA.changeYn;
			preSdate = simulationInfoData.DATA.preSdate;
		}

		//가발령적용 사용유무
		appmtApplyChk = ajaxCall( "${ctx}/OrgChangeSchemeMgr.do?cmd=getChkApplyYn", "sdate="+sdate1, false );
		if( appmtApplyChk.DATA != "" && parseInt(appmtApplyChk.DATA.cnt) > 0) {
			$("#appmtTr").show();
		}else{
			$("#appmtTr").hide();
		}
		
	
	
		$("#sdate", "#mySheetForm").val(sdate1);
		$("#versionNm", "#mySheetForm").val(versionNm);
		
		// 변경전 조직도 트리레벨 정의
		$("#btnPlus", "#tree_as_is").toggleClass("minus");
		$("#btnPlus", "#tree_as_is").click(function() {
			$("#btnPlus", "#tree_as_is").toggleClass("minus");
			$("#btnPlus", "#tree_as_is").hasClass("minus")?sheet1.ShowTreeLevel(-1):sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep1", "#tree_as_is").click(function()	{
			$("#btnPlus", "#tree_as_is").removeClass("minus");
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2", "#tree_as_is").click(function()	{
			$("#btnPlus", "#tree_as_is").removeClass("minus");
			sheet1.ShowTreeLevel(1,2);
		});
		$("#btnStep3", "#tree_as_is").click(function()	{
			if(!$("#btnPlus", "#tree_as_is").hasClass("minus")){
				$("#btnPlus", "#tree_as_is").toggleClass("minus");
				sheet1.ShowTreeLevel(-1);
			}
		});
		
		// 변경후 조직도 트리레벨 정의
		$("#btnPlus", "#tree_to_be").toggleClass("minus");
		$("#btnPlus", "#tree_to_be").click(function() {
			$("#btnPlus", "#tree_to_be").toggleClass("minus");
			$("#btnPlus", "#tree_to_be").hasClass("minus")?sheet2.ShowTreeLevel(-1):sheet2.ShowTreeLevel(0, 1);
		});
		$("#btnStep1", "#tree_to_be").click(function()	{
			$("#btnPlus", "#tree_to_be").removeClass("minus");
			sheet2.ShowTreeLevel(0, 1);
		});
		$("#btnStep2", "#tree_to_be").click(function()	{
			$("#btnPlus", "#tree_to_be").removeClass("minus");
			sheet2.ShowTreeLevel(1,2);
		});
		$("#btnStep3", "#tree_to_be").click(function()	{
			if(!$("#btnPlus", "#tree_to_be").hasClass("minus")){
				$("#btnPlus", "#tree_to_be").toggleClass("minus");
				sheet2.ShowTreeLevel(-1);
			}
		});
		
		// 최종 조직도 트리레벨 정의
		$("#btnPlus", "#type__result").toggleClass("minus");
		$("#btnPlus", "#type__result").click(function() {
			$("#btnPlus", "#type__result").toggleClass("minus");
			$("#btnPlus", "#type__result").hasClass("minus")?sheet2.ShowTreeLevel(-1):sheet2.ShowTreeLevel(0, 1);
		});
		$("#btnStep1", "#type__result").click(function()	{
			$("#btnPlus", "#type__result").removeClass("minus");
			sheet3.ShowTreeLevel(0, 1);
		});
		$("#btnStep2", "#type__result").click(function()	{
			$("#btnPlus", "#type__result").removeClass("minus");
			sheet3.ShowTreeLevel(1,2);
		});
		$("#btnStep3", "#type__result").click(function()	{
			if(!$("#btnPlus", "#type__result").hasClass("minus")){
				$("#btnPlus", "#type__result").toggleClass("minus");
				sheet3.ShowTreeLevel(-1);
			}
		});
		
		
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msBaseColumnMerge+msHeaderOnly,PrevColumnMergeMode:1};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"시작일",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"상위소속코드",	Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",	KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속코드",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속명",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  TreeCol:1 },
			{Header:"소속 조직원수",	Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"empCount",	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  FontColor:"#787878" }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.ShowTreeLevel(-1);
		
		
		var initdata2 = {};
		initdata2.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msBaseColumnMerge+msHeaderOnly,PrevColumnMergeMode:1};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },			
			{Header:"시작일|시작일",				Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",				KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"상위소속코드|상위소속코드",	Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",			KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속코드|소속코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",				KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속명|소속명",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  TreeCol:1 },
			{Header:"변경구분|변경구분",			Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"changeGubun",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"변경사항|변경사항",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"changeGubunNm",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속 조직원수|개편전",		Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"empCount",			KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  FontColor:"#787878" },
			{Header:"소속 조직원수|전입",			Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"addCount",			KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  FontColor:"#f4617c" },
			{Header:"소속 조직원수|전출",			Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"movedTargetCount",	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  FontColor:"#018ed3" },
			{Header:"소속 조직원수|개편후",		Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"empCountAfter",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  FontColor:"#000000" }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.ShowTreeLevel(-1);
		sheet2.SetSumValue("sNo", "합계") ;
		
		
		var initdata3 = {};
		initdata3.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msBaseColumnMerge+msHeaderOnly,PrevColumnMergeMode:1};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata3.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"시작일",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"상위소속코드",	Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",	KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속코드",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속명",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  TreeCol:1 },
			{Header:"소속 조직원수",	Type:"AutoSum",		Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"empCount",	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,  FontColor:"#787878" }
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable(false);sheet3.SetVisible(true);sheet3.SetCountPosition(4);
		sheet3.ShowTreeLevel(-1);
		
		
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
		doAction2("Search");
		
		if(changeYn == "Y") {
			doAction3("Search");
		} else {
			if($(".type__final").hasClass("hide")) {
				$(".type__final").removeClass("hide");
			}
		}
		
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

	// 가발령 적용 처리
	function appmtApply() {
		if(confirm("기존에 임시저장된 가발령 건들은 삭제됩니다.\n가발령적용 처리 하시겠습니까?")) {
			var data = ajaxCall( "/OrgChangeSchemeMgr.do?cmd=callPrcOrgSimulAppmtApply", $("#mySheetForm").serialize(), false );
			if(data.Result.Message == "" || data.Result.Message == null) {
				alert("정상적으로 처리되었습니다.");
				doAction3("Search");
			} else {
				var msg = data.Result.Message;
				msg = replaceAll( msg, "|n", "\n");
				alert(msg);
			}
		}
	}
	
	// 완료 처리
	function complete() {
		if(confirm("최종 확인 및 완료 처리 하시겠습니까?")) {
			var data = ajaxCall( "/OrgChangeSchemeMgr.do?cmd=callPrcOrgApplyReorg", $("#mySheetForm").serialize(), false );
			if(data.Result.Message == "" || data.Result.Message == null) {
				alert("정상적으로 처리되었습니다.");
				doAction3("Search");
			} else {
				var msg = data.Result.Message;
				msg = replaceAll( msg, "|n", "\n");
				alert(msg);
			}
		}
	}
	
</script>

<!-- [sheet1] Start -->
<script type="text/javascript">
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationOrgCurLastTreeList", $("#mySheetForm").serialize() + "&preSdate=" + preSdate, 1 );
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
				sheet2.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationEmpOrgList", $("#mySheetForm").serialize(), 1 );
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
			var changeGubun      = null;
			var backColor        = null;
			var fontColor        = null;
			var empCount         = 0;
			var addCount         = 0;
			var movedTargetCount = 0;
			var empCountAfter    = 0;
			for(var i = sheet2.HeaderRows(); i <= sheet2.LastRow() - 1; i++){
				changeGubun      = sheet2.GetCellValue(i, "changeGubun");
				empCount         = sheet2.GetCellValue(i, "empCount");
				addCount         = sheet2.GetCellValue(i, "addCount");
				movedTargetCount = sheet2.GetCellValue(i, "movedTargetCount");
				
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
						sheet2.SetCellValue(i, "changeGubunNm", "인원변동");
					}
					sheet2.SetCellFontColor(i, 6, fontColor);
				}
				
				sheet2.SetRangeBackColor(i, 0, i, sheet2.LastCol(), backColor);
				sheet2.SetCellValue(i, "empCountAfter", empCountAfter);
			}
			
			
			if($(".type__to_be").hasClass("hide")) {
				$(".type__to_be").removeClass("hide");
			}
			
			if(changeYn == "N" && $(".type__final").hasClass("hide")) {
				$(".type__final").removeClass("hide");
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
				sheet3.DoSearch( "${ctx}/OrgChangeSchemeMgr.do?cmd=getSchemeSimulationOrgCurLastTreeList", $("#mySheetForm").serialize() + "&preSdate=" + $("#sdate").val(), 1 );
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			if(!$(".type__final").hasClass("hide")) {
				$(".type__final").addClass("hide");
			}
			
			if($(".type__result").hasClass("hide")) {
				$(".type__result").removeClass("hide");
			}
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
</script>
<!-- [sheet2] End -->
</head>
<body class="bodywrap">
	<div class="wrapper">
	
		<form id="mySheetForm" name="mySheetForm" >
			<input type="hidden" id="sdate" name="sdate" />
			<input type="hidden" id="versionNm" name="versionNm" />
			<input type="hidden" id="orgCd" name="orgCd" />
	
			<div class="popup_title bgGray alignR" style="padding:15px 20px;">
				<span class="floatL f_red strong fa-lg">최종확인</span>
				&nbsp;
			</div>
			
			<div class="mat15" style="padding:0 20px;">
				<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
					<colgroup>
						<col width="32%" />
						<col width="2%" />
						<col width="32%" />
						<col width="2%" />
						<col width="32%" />
					</colgroup>
					<tbody>
						<tr>
							<td class="sheet_left">
								<div class="inner">
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">
												변경전 조직도
												<div class="util">
													<ul id="tree_as_is">
														<li	id="btnPlus"></li>
														<li	id="btnStep1"></li>
														<li	id="btnStep2"></li>
														<li	id="btnStep3"></li>
													</ul>
												</div>
											</li>
											<li class="btn">
											</li>
										</ul>
									</div>
								</div>
								<script type="text/javascript"> createIBSheet("sheet1", "30%", "100%", "kr"); </script>
							</td>
							<td></td>
							<td class="type__to_be sheet_right">
								<div class="inner">
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">
												변경후 조직도
												<div class="util">
													<ul id="tree_to_be">
														<li	id="btnPlus"></li>
														<li	id="btnStep1"></li>
														<li	id="btnStep2"></li>
														<li	id="btnStep3"></li>
													</ul>
												</div>
											</li>
											<li class="btn">
											</li>
										</ul>
									</div>
								</div>
								<script type="text/javascript"> createIBSheet("sheet2", "30%", "100%", "kr"); </script>
							</td>
							<td></td>
							<td class="type__final sheet_right alignC valignM hide">
								<table class="table">
										<colgroup>
											<col width="25%" />
											<col width="80px" />
											<col width="*%" />
										</colgroup>
										<tr id="appmtTr" name="appmtTr">
											<th>가발령처리</th>
											<td><btn:a href="javascript:appmtApply();" css="btn filled" mid='110729' mdef="적용"/></td>
											<td style="text-align:left">기존 임시저장건을 지우고 기본적인 발령만 생성하며 <p>세부내역은 확인 및 수정해 주시기 바랍니다.</td>
										</tr>
										<tr>
											<th>최종 확인 및 확정 진행</th>
											<td><btn:a href="javascript:complete();" css="btn filled" mid='110729' mdef="적용"/></td>
											<td style="text-align:left">조직도 이력을 최종버전으로 갱신합니다.</td>
										</tr>
								</table>
							<td class="type__result sheet_right alignC valignM hide">
								<div class="inner">
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">
												최종 조직도
												<div class="util">
													<ul id="tree_to_be">
														<li	id="btnPlus"></li>
														<li	id="btnStep1"></li>
														<li	id="btnStep2"></li>
														<li	id="btnStep3"></li>
													</ul>
												</div>
											</li>
											<li class="btn">
											</li>
										</ul>
									</div>
								</div>
								<script type="text/javascript"> createIBSheet("sheet3", "30%", "100%", "kr"); </script>
							</td>
						</tr>
					</tbody>
				</table>
			</div>
			
		</form>
		
	</div>
</body>
</html>