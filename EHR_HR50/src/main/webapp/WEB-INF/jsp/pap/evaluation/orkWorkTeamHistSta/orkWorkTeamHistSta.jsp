<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<title>팀업무이력현황</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		//성명,사번
		$("#searchAppSabun").val("${sessionScope.ssnSabun}");
		$("#searchAppName").val("${sessionScope.ssnName}");
		$("#searchKeyword").val("${sessionScope.ssnName}");
		$("#span_searchName").html("${sessionScope.ssnName}");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",							Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",							Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",							Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='sabun_V2956' mdef='사번'/>",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='workorgNm' mdef='소속'/>",					Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeNm_V7' mdef='직위'/>",							Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"<sht:txt mid='2023082501089' mdef='총점수\n(task종합수준x리뷰결과)'/>",	Type:"Int",			Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"total",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"<sht:txt mid='2023082501088' mdef='총개수'/>",							Type:"Int",			Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"totCnt",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"<sht:txt mid='2023082501087' mdef='평균점수'/>",						Type:"Float",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"avg",			KeyField:0,	Format:"Float",		PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"<sht:txt mid='2023082501086' mdef='순위'/>",							Type:"Int",			Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"rank",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},

			{Header:"평가ID",						Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가소속코드",					Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"팀목표순번",						Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorSeq"},
			{Header:"업무순번",						Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListOkr&searchAppStepCd="+$('#searchAppStepCd').val(),false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		
		//setAppPeople(); //피평가자 리스트
		
		// 이벤트 setting
		$("#searchAppraisalCd").bind("change",function(event){
			//setAppPeople(); //피평가자 리스트
			doAction1("Search");
		});
		
		//$("#searchAppPeople").bind("change",function(event){
		//	doAction1("Search");
		//});
		
		doAction1("Search");
	});

	function setAppPeople() {
		//대상자
		var appPeopleList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOkrAppPeopleList&"+$("#empForm").serialize(),false).codeList, "전체");
		$("#searchAppPeople").html("");
		$("#searchAppPeople").html(appPeopleList[2]);
	}

	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchAppName").val($("#searchKeyword").val());
		$("#searchAppSabun").val($("#searchUserId").val());
		//setAppPeople(); //피평가자 리스트
		doAction1("Search");
	}

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OrkWorkTeamHistSta.do?cmd=getOrkWorkTeamHistStaList", $("#empForm").serialize() );
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
			if (Msg != "") alert(Msg);
			
			//관리자인 경우에만 총점수와 평균점수 노출시킨다.
			if("${ssnAdminYn}" == "Y") {
				sheet1.SetColHidden("total", 0);
				sheet1.SetColHidden("avg", 0);
			} else {
				sheet1.SetColHidden("total", 1);
				sheet1.SetColHidden("avg", 1);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

</script>
</head>

<body class="bodywrap">
<div class="wrapper">
	<form id="empForm" name="empForm" >
	<input type="hidden" name="searchAppStepCd"		id="searchAppStepCd"	value="${map.searchAppStepCd}">
	<!-- 조회영역 > 성명 자동완성 관련 추가 -->
	<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/>
	<input type="hidden" id="searchUserId"   name="searchUserId" value="" />
	<input type="hidden" id="searchUserEnterCd"  name="searchUserEnterCd" value="" />
	<!-- 조회영역 > 성명 자동완성 관련 추가 -->

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td>
				<span><tit:txt mid='111888' mdef='평가명'/></span>
				<select id="searchAppraisalCd" name="searchAppraisalCd" class="required" required> </select>
			</td>
			<td class="hide">
				<span><tit:txt mid='103863' mdef='대상자'/></span>
				<select id="searchAppPeople" name="searchAppPeople" class="required" required> </select>
			</td>
			<td><span><tit:txt mid='113683' mdef='평가자'/></span>
				<input id="searchAppSabun" name ="searchAppSabun" type="hidden" class="text"	/>
				<input id="searchAppName" name ="searchAppName" type="hidden" class="text"	/>
				<!-- <input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/> -->
				<c:choose>
					<c:when test="${ sessionScope.ssnPapAdminYn == 'Y' }">
							<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/>
					</c:when>
					<c:otherwise>
							<input type="hidden" id="searchKeyword" name="searchKeyword" />
							<span id="span_searchName" class="txt pap_span f_normal"></span>
					</c:otherwise>
				</c:choose>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt" id="pageTitle"><tit:txt mid='2023082501091' mdef='팀업무이력현황'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
		</td>
	</tr>
	</table>
</div>

</body>
</html>