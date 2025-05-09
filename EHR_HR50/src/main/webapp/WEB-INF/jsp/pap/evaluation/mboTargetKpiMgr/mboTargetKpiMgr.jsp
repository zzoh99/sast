<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		// 조회조건 이벤트 등록
		$("#searchAppraisalCd").bind("change",function(event){
			$("#searchAppraisalCd2").val($(this).val());
			setAppOrgCdCombo();
		});

		$("#searchAppOrgCd").bind("change",function(event){
			setAppClassCd();
			setAppEmployee();
		});

		$("#searchSabun").val("${sessionScope.ssnSabun}");
		$("#searchName").val("${sessionScope.ssnName}");
		$("#searchKeyword").val("${sessionScope.ssnName}");
		$("#span_searchName").html("${sessionScope.ssnName}");
		$("#searchAppSabun2").val("${sessionScope.ssnSabun}");

		init_sheet();
		
		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListMbo&searchAppStepCd="+$('#searchAppStepCd').val(),false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchAppraisalCd").change();
		
	});

	function init_sheet(){
		if( $("#DIV_sheet1").html().length > 0 ) {
			return;
		}

		var appIndexGubunCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"),""); // 평가지표구분
		
		// 190529 IDS 코드 조회
		var mboTypeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10009"), ""); // 목표구분(P10009)
		var appClassCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y&visualYn=Y","P00001"), ""); // 평가등급(P00001)

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,MergeSheet:msAll,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"순서",					Type:"Int",		Hidden:0,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",		KeyField:0,	Edit:0 },
			{Header:"구분",					Type:"Combo",	Hidden:1,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"appIndexGubunCd",	KeyField:0,	Edit:0,	ComboText: appIndexGubunCdList[0], ComboCode: appIndexGubunCdList[1]},
			{Header:"구분",					Type:"Text",	Hidden:1,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"appIndexGubunNm",	KeyField:0,	Edit:0	},
			{Header:"목표구분",				Type:"Combo",	Hidden:0,		Width:60,	Align:"Left",	ColMerge:0,	SaveName:"mboType",			KeyField:0,	Edit:0,	ComboText: mboTypeCdList[0], ComboCode: mboTypeCdList[1]},
			{Header:"목표항목",				Type:"Text",	Hidden:0,		Width:120,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",		KeyField:0,	Edit:0,	MultiLineText:1, Wrap:1 },
			{Header:"비중(%)",				Type:"AutoSum", Hidden:0,		Width:30,	Align:"Center",	ColMerge:0,	SaveName:"weight",			KeyField:0,	Format:"Integer",	PointCount:0,	Edit:0 },
			{Header:"목표달성을 위한 핵심 요인",	Type:"Text",	Hidden:0,		Width:150,	Align:"Left",	ColMerge:0,	SaveName:"kpiNm",			KeyField:0,	Edit:0,	MultiLineText:1, Wrap:1 },
			{Header:"달성목표(정량,최종)"	,	Type:"Text",	Hidden:0,		Width:200,	Align:"Left",	ColMerge:0,	SaveName:"formula",			KeyField:0,	Edit:0,	MultiLineText:1, Wrap:1 },
			
			/* hidden column */
			{Header:"평가ID",				Type:"Text",	Hidden:1,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"평가소속",				Type:"Text",	Hidden:1,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"사원번호",				Type:"Text",	Hidden:1,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"순서",					Type:"Text",	Hidden:1,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"},
			{Header:"생성구분코드",			Type:"Text",	Hidden:1,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mkGubunCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		sheet1.SetEditEnterBehavior("newline");
		sheet1.SetAutoSumPosition(1);
		sheet1.SetSumValue("sNo", "합계") ;
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //짝수번째 데이터 행의 기본 배경색
		
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"No",	Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",  	Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"선택",	Type:"${sDelTy}",	Hidden:1, Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태",	Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
			
			{Header:"선택",	Type:"CheckBox",  Hidden:0,  Width:60,	Align:"Center",  ColMerge:0,  SaveName:"designateYn",	KeyField:0,	Format:"",	PointCount:0,  UpdateEdit:1,  InsertEdit:1,  EditLen:1,  TrueValue:"Y",  FalseValue:"N"},
			{Header:"소속",	Type:"Text",      Hidden:0,  Width:60,	Align:"Center",  ColMerge:0,  SaveName:"appOrgNm",		KeyField:0, Format:"",	PointCount:0,  Edit:0 },
			{Header:"성명",	Type:"Text",      Hidden:0,  Width:60,	Align:"Center",  ColMerge:0,  SaveName:"name",			KeyField:0, Format:"",	PointCount:0,  Edit:0 },
			{Header:"직위",	Type:"Text",      Hidden:0,  Width:60,	Align:"Center",  ColMerge:0,  SaveName:"jikweeNm",		KeyField:0, Format:"",	PointCount:0,  Edit:0 },
			{Header:"직책",	Type:"Text",      Hidden:0,  Width:60,	Align:"Center",  ColMerge:0,  SaveName:"jikchakNm",		KeyField:0, Format:"",	PointCount:0,  Edit:0 },
			{Header:"상태",	Type:"Text",      Hidden:0,  Width:60,	Align:"Center",  ColMerge:0,  SaveName:"statusNm",		KeyField:0, Format:"",	PointCount:0,  Edit:0 },
			
			/* hidden */
			{Header:"상태",	Type:"Text",      Hidden:1,  Width:0,	Align:"Center",  ColMerge:0,  SaveName:"statusCd",		KeyField:0, Format:"",	PointCount:0,  Edit:0 },
			{Header:"소속",	Type:"Text",      Hidden:1,  Width:0,	Align:"Center",  ColMerge:0,  SaveName:"appOrgCd",		KeyField:0, Format:"",	PointCount:0,  Edit:0 },
			{Header:"사번",	Type:"Text",      Hidden:1,  Width:0,	Align:"Center",  ColMerge:0,  SaveName:"sabun",			KeyField:0, Format:"",	PointCount:0,  Edit:0 }
		]; IBS_InitSheet(sheet2, initdata2); sheet2.SetEditable("${editable}"); sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);
		
		setAppClassCd();
		
		$(window).smartresize(sheetResize); sheetInit();
	}

	function setAppClassCd(){
/*
		//평가등급기준 -- 평가종류에 따라 다른 등급을 가져옴.
		var saveNameLst = ["sGradeBase", "aGradeBase", "bGradeBase", "cGradeBase", "dGradeBase"];
		classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, ""); // 평가등급
    	clsLst = classCdList[0].split("|");

		sheet1.RenderSheet(0);
		for( var i=0; i<clsLst.length ; i++){
			sheet1.SetColHidden(saveNameLst[i], 0 );
			sheet1.SetCellValue(1, saveNameLst[i], clsLst[i] );
		}
		var len = clsLst.length;
		if(classCdList[0] == "" ) len = 0;
		for( var i=len; i<saveNameLst.length ; i++){
			sheet1.SetColHidden(saveNameLst[i], 1 );
		}
		sheet1.RenderSheet(1);
*/
	}

	//평가소속 setting(평가명 change, 성명 팝업 선택 후)
	function setAppOrgCdCombo() {
		$("#searchAppOrgCd").html("");

		var appOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&"
				,"queryId=getAppOrgCdListMboTarget"
				+"&searchAppraisalCd="+$("#searchAppraisalCd").val()
				+"&searchSabun="+$("#searchSabun").val()
				+"&searchAppStepCd="+$("#searchAppStepCd").val()
				+"&searchAppYn=Y"
			,false).codeList, ""); // 평가소속

		$("#searchAppOrgCd").html(appOrgCdList[2]);
		$("#searchAppOrgCd").change();
	}

	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchName").val($("#searchKeyword").val());
		$("#searchSabun").val($("#searchUserId").val());
		$("#searchAppSabun2").val($("#searchUserId").val());
		setAppOrgCdCombo();
	}

	//피평가자, 평가자정보조회(평가소속 change)
	function setAppEmployee() {
		$("#searchAppSabun").val("");
		$("#searchAppStatusCd").val("");
		$("#searchAppSheetType").val("");

		$("#searchJikgubNm").val("");
		$("#span_searchJikgubNm").html("");
		$("#searchJikweeNm").val("");
		$("#span_searchJikweeNm").html("");

		var data = ajaxCall("${ctx}/EvaMain.do?cmd=getMboTargetRegMapAppEmployee",$("#empForm").serialize(),false);

		if(data != null && data.map != null) {
			$("#searchAppSabun").val(data.map.appSabun);
			$("#searchAppStatusCd").val(data.map.statusCd);
			$("#searchAppSheetType").val(data.map.appSheetType);

			$("#searchJikgubNm").val(data.map.jikgubNm);
			$("#span_searchJikgubNm").html(data.map.jikgubNm);
			$("#searchJikweeNm").val(data.map.jikweeNm);
			$("#span_searchJikweeNm").html(data.map.jikweeNm);

			$("#searchAppraisalYn").val(data.map.appraisalYn); //평가완료여부
		}

		doAction("Search");
	}
	
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			doAction1("Search");
			doAction2("Search");
			break;
		}
	}

</script>

<!-- Tap1 Script -->
<script type="text/javascript">
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/MboTargetKpiMgr.do?cmd=getMboTargetKpiMgrList1", $("#empForm").serialize() );
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			// 자동생성 ROW 인 경우 수정, 삭제 불가
			for( var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
			}

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
 	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					$("#searchSeq2").val(sheet1.GetCellValue(NewRow, "seq"));
					doAction2("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
		}
	}
</script>

<!-- Tap2 Script -->
<script type="text/javascript">
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#desigSabunsOrgs").val('');
			
		    if($("#searchAppSabun2").val() == null || $("#searchAppSabun2").val() == ""){
			   $("#searchAppSabun2").val("${sessionScope.ssnSabun}");
		    };
			
			sheet2.DoSearch( "${ctx}/MboTargetKpiMgr.do?cmd=getMboTargetKpiMgrList2", $("#srchFrm2").serialize() );
			break;
		case "Save":
			/*
			if(!dupChk(sheet2,"appraisalCd|sabun|appOrgCd|competencyCd", true, true)){break;}
			IBS_SaveName(document.empForm,sheet2);
			sheet2.DoSave( "${ctx}/MboTargetReg.do?cmd=saveMboTargetReg2", $("#empForm").serialize());
			*/
			break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(sheet1.GetSelectRow() > 0) {
				for( var i=sheet2.HeaderRows(); i<=sheet2.LastRow(); i++) {
					// 미제출 상태인 경우에만 편집 가능 처리
					if(sheet2.GetCellValue(i, "statusCd") != "11") {
						sheet2.SetRowEditable(i, 0);
					}
				}
			}

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
	}

	function callPrc2() {
		var kpiRow = sheet1.GetSelectRow();
		if( sheet1.RowCount() == 0 || kpiRow < 1 ) {
			alert("선택된 KPI가 없습니다.");
			
		} else {
			var desigSabunsOrgs = "";
			if( sheet2.RowCount() > 0 ) {
				for( var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++) {
					if(sheet2.GetCellValue(i,"designateYn") == "Y"){
						if( desigSabunsOrgs != "" && desigSabunsOrgs.length > 0 ) {
							desigSabunsOrgs += ",";
						}
						desigSabunsOrgs += (sheet2.GetCellValue(i, "sabun") + "_" + sheet2.GetCellValue(i, "appOrgCd"));
					}
				}
			}
			
			if( confirm("저장하시겠습니까?") ) {
				$("#desigSabunsOrgs").val(desigSabunsOrgs);
				
				setTimeout(function(){
					var data = ajaxCall("${ctx}/MboTargetKpiMgr.do?cmd=prcMboTargetKpiMgr",$("#srchFrm2").serialize(),false);
					if(data.Result.Code == null) {
						alert("처리되었습니다.");
						doAction2("Search");
					} else {
						alert(data.Result.Message);
					}
				}, 300);
			}
		}
	}
</script>

</head>
<body class="hidden">
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" id="tabsIndex" name="tabsIndex" value="" />
		<input type="hidden" name="searchAppStepCd"		id="searchAppStepCd"	value="${map.searchAppStepCd}">
		<input type="hidden" name="searchAppSeqCd"		id="searchAppSeqCd"		value="${map.searchAppSeqCd_sub}">
		<input type="hidden" name="searchAppSabun"		id="searchAppSabun" />
		<input type="hidden" name="searchAppStatusCd"	id="searchAppStatusCd" />
		<input type="hidden" name="searchOrgCd"			id="searchOrgCd" />
		<input type="hidden" name="searchOrgNm"			id="searchOrgNm" />
		<input type="hidden" name="searchAppSheetType"	id="searchAppSheetType" />
		<input type="hidden" name="searchAppYn"			id="searchAppYn" />
		<input type="hidden" name="searchAppraisalYn"	id="searchAppraisalYn" />
		
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->
		<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/>
		<input type="hidden" id="searchUserId"   name="searchUserId" value="" />
		<input type="hidden" id="searchUserEnterCd"  name="searchUserEnterCd" value="" />
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->

		<div class="sheet_search sheet_search_w50 outer">
			<div>
				<table>
					<tr>
						<td>
							<span class="w60">평가명 </span>
				<c:choose>
					<c:when test="${map.searchAppraisalCd_sub == null || map.searchAppraisalCd_sub == ''}">
							<select id="searchAppraisalCd" name="searchAppraisalCd"></select>
					</c:when>
					<c:otherwise>
							<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" class="text readonly" readonly>
							<input id="searchAppraisalNm" name="searchAppraisalNm" type="hidden" class="text readonly w80" readonly>
							<span id="span_searchAppraisalNm" class="txt pap_span f_normal"></span>
					</c:otherwise>
				</c:choose>
						</td>
						<td>
							<span class="w60">평가소속 </span>
				<c:choose>
					<c:when test="${map.searchAppraisalCd_sub == null || map.searchAppraisalCd_sub == ''}">
							<select id="searchAppOrgCd" name="searchAppOrgCd"></select>
					</c:when>
					<c:otherwise>
							<input id="searchAppOrgCd" name="searchAppOrgCd" type="hidden" class="text readonly" readonly>
							<input id="searchAppOrgNm" name="searchAppOrgNm" type="hidden" class="text readonly w80" readonly>
							<span id="span_searchAppOrgNm" class="txt pap_span f_normal"></span>
					</c:otherwise>
				</c:choose>
						</td>
						<td>
							<span class="w60">성명 </span>
							<input id="searchSabun" name ="searchSabun" type="hidden" />
							<input id="searchName" name ="searchName" type="hidden" />
				<c:choose>
					<c:when test="${ sessionScope.ssnPapAdminYn == 'Y' && (map.searchAppraisalCd_sub == null || map.searchAppraisalCd_sub == '') }">
							<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/>
					</c:when>
					<c:otherwise>
							<input type="hidden" id="searchKeyword" name="searchKeyword" />
							<span id="span_searchName" class="txt pap_span f_normal"></span>
					</c:otherwise>
				</c:choose>
						</td>
	<c:if test="${ssnJikweeUseYn == 'Y'}">
						<td class="hide">
						 	<span class="w60">직위 </span>
						 	<input id="searchJikweeNm" name ="searchJikweeNm" type="hidden" />
							<span id="span_searchJikweeNm" class="txt pap_span f_normal"></span>
						 </td>
	</c:if>
	<c:if test="${ssnJikgubUseYn == 'Y'}">
						<td class="hide">
						 	<span class="w60">직급 </span>
						 	<input id="searchJikgubNm" name ="searchJikgubNm" type="hidden" />
							<span id="span_searchJikgubNm" class="txt pap_span f_normal"></span>
						 </td>
	</c:if>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="javascript:doAction('Search')" id="btnSearch" class="btn dark" >조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="70%" />
			<col width="15px" />
			<col width="%" />
		</colgroup>
		<tr>
			<td class="">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">KPI</li>
							<li class="btn">
							<span>※피평가자가 "<b class="f_red">미제출</b>" 상태인 경우에만 할당 가능합니다.</span>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
			<td></td>
			<td class="">
				<form id="srchFrm2" name="srchFrm2" >
				<input type="hidden" id="searchAppraisalCd2" name="searchAppraisalCd" />
				<input type="hidden" id="searchAppStepCd2" name="searchAppStepCd" value="${map.searchAppStepCd}" />
				<input type="hidden" id="searchAppSabun2" name="searchAppSabun" />
				<input type="hidden" id="searchSeq2" name="searchSeq" />
				<input type="hidden" id="desigSabunsOrgs" name="desigSabunsOrgs" />
				</form>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">피평가자</li>
							<li class="btn">
								<a href="javascript:callPrc2();"           class="btn filled authA">저장</a>
								<a href="javascript:doAction2('Search');"  class="btn dark">조회</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>