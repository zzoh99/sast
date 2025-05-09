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
		//성명,사번
		$("#searchAppSabun").val("${sessionScope.ssnSabun}");
		$("#searchAppName").val("${sessionScope.ssnName}");
		$("#searchKeyword").val("${sessionScope.ssnName}");
		$("#span_searchName").html("${sessionScope.ssnName}");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='detail_V3353' mdef='세부\n내역'/>",			Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0, UpdateEdit:0,	InsertEdit:0,	Cursor:"Pointer"},
			{Header:"<sht:txt mid='check' mdef='선택'/>",					Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",			KeyField:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='sabun_V2956' mdef='사번'/>",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='workorgNm' mdef='소속'/>",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='2023082500935' mdef='업무내용'/>",			Type:"Text",		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"workTitle",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000},
			{Header:"<sht:txt mid='stateCdNm' mdef='진행상태'/>",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"평가ID",				Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가소속코드",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"진행상태코드",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"팀목표순번",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorSeq"},
			{Header:"업무순번",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"},
			{Header:"업무진행상태코드",		Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workStatusCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",1);
		
		// 업무진행상태
		var statusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30018"), ""); // 상시평가진행상태(업무)(P30018)
		sheet1.SetColProperty("statusCd", 	{ComboText:statusCdList[0], ComboCode:statusCdList[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListOkr&searchAppStepCd="+$('#searchAppStepCd').val(),false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		setAppPeople();
		
		// 이벤트 setting
		$("#searchAppraisalCd").bind("change",function(event){
			setAppPeople(); //피평가자 리스트
			doAction1("Search");
		});
		$("#searchAppPeople").bind("change",function(event){
			doAction1("Search");
		});
		
		doAction1("Search");
	});

	function setAppPeople() {
		//대상자
		var appPeopleList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOkrAppPeopleList&"+$("#empForm").serialize(),false).codeList, "");
		$("#searchAppPeople").html("");
		$("#searchAppPeople").html(appPeopleList[2]);
	}

	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchAppName").val($("#searchKeyword").val());
		$("#searchAppSabun").val($("#searchUserId").val());
		setAppPeople(); //피평가자 리스트
		doAction1("Search");
	}
	
	//공통 체크
	function commCheck(){
		if($("#searchAppraisalCd").val() == "") {
			alert("<msg:txt mid='110470' mdef='평가명이 존재하지 않습니다.'/>");
			$("#searchAppOrgCd").focus();
			return false;
		}
		
		if($("#searchAppPeople").val() == ""){
			alert("<msg:txt mid='109790' mdef='대상자가 존재하지 않습니다.'/>");
			$("#searchAppOrgCd").focus();
			return false;
		}
		
		return true;
	}

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			
			if(!commCheck()) return;
			
			sheet1.DoSearch( "${ctx}/OkrWorkApr.do?cmd=getOkrWorkAprList", $("#empForm").serialize() );
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

			// 자동생성 ROW 인 경우 수정, 삭제 불가
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				var bHighlight = false;
				var statusCd = sheet1.GetCellValue(i, "statusCd");
				// 21(승인요청)
				if (statusCd == "21"){
					bHighlight = true;
				}
				
				if (bHighlight) {
					sheet1.SetCellFont("FontColor", i, "statusNm", i, "statusNm", "#FF0000");
					sheet1.SetRowBackColor(i, "#F7F8E0");
				}
			}

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if (Row < sheet1.HeaderRows()) return;

			if ( sheet1.ColSaveName(Col) == "detail" ) {

				if ( sheet1.GetCellValue(Row, "statusCd") == "00" || sheet1.GetCellValue(Row, "statusCd") == "11" ) {
					alert("<msg:txt mid='110041' mdef='현재 미제출 또는 작성중 상태입니다.'/>");
					return;
				}

				showDetailPopup('R',Row);
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != "-1" ) doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//일괄승인
	function Approval(){
		if($("#searchAppSabun").val() == "") {
			alert("<msg:txt mid='2023082400807' mdef='평가자를 선택 해주세요.'/>");
			return;
		}

		if( sheet1.RowCount("R") == 0 ){
			alert("<msg:txt mid='110042' mdef='승인할 데이터가 존재하지 않습니다.'/>");
			return;
		}

		var cnt = 0;
		var isAdd = false;
		for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow() ; i++) {
			isAdd = false;
			if(sheet1.GetCellValue(i, "statusCd") == "21") {
				isAdd = true;
			}

			if(isAdd) {
				cnt++;
			}
		}

		if(cnt > 0) {
			var msg = "<msg:txt mid='2023082501081' mdef='일괄승인( #건)을 진행하시겠습니까?'/>";
			var msgResult = msg.replace('#',cnt);
			if(confirm(msgResult)) {
				var data = ajaxCall("${ctx}/OkrWorkApr.do?cmd=prcOkrWorkApr",$("#empForm").serialize(),false);
				if(data.Result.Code == null) {
					alert("<msg:txt mid='109594' mdef='일괄 승인이 완료되었습니다.'/>");
					doAction1("Search");
				} else {
					alert(data.Result.Message);
				}
			} else {
				return;
			}
		} else {
			alert("<msg:txt mid='2023082501080' mdef='일괄승인 정보가 존재하지 않습니다. 피평가자의 평가진행상태를 확인해주시기 바랍니다.'/>");
			return;
		}
	}

	var showDetailPopup = function (authPg,Row) {
		if(!isPopup()) {return;}
		
		var args = new Array();
		var url = url = "${ctx}/OkrWorkReg.do?cmd=viewOkrWorkRegPopDetail";
		args["authPg"] = authPg;
		args["adminCheck"] = "ADMIN";
		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		args["searchAppStepCd"] = $("#searchAppStepCd").val();
		args["searchAppSabun"] = $("#searchAppSabun").val();
		args["searchAppName"] = $("#searchAppName").val();
		args["searchAppOrgCd"] = sheet1.GetCellValue(Row, "appOrgCd");
		args["searchSabun"] = sheet1.GetCellValue(Row, "sabun");
		args["searchPriorSeq"] = sheet1.GetCellValue(Row, "priorSeq");
		args["searchSeq"] = sheet1.GetCellValue(Row, "seq");
		args["searchStatusCd"] = sheet1.GetCellValue(Row, "statusCd");
		
		gPRow = Row;
		pGubun = "okrWorkRegPop";
		
		openPopup(url,args,800,800);
	};

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		
		doAction1("Search");
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
				<span><tit:txt mid='111888' mdef='평가명'/> </span> <select id="searchAppraisalCd" name="searchAppraisalCd" class="required" required> </select>
			</td>
			<td><span><tit:txt mid='113683' mdef='평가자'/> </span>
				<input id="searchAppSabun" name ="searchAppSabun" type="hidden" class="text"	/>
				<input id="searchAppName" name ="searchAppName" type="hidden" class="text"	/>
				<!-- <input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/> -->
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
			<td>
				<span><tit:txt mid='103863' mdef='대상자'/> </span> <select id="searchAppPeople" name="searchAppPeople" class="required" required> </select>
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
					<li class="txt" id="pageTitle"><tit:txt mid='2023082501082' mdef='개인업무(TASK)승인'/></li>
					<li class="btn">
						<btn:a href="javascript:Approval();" css="button authA" mid='110840' mdef="일괄승인"/>
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