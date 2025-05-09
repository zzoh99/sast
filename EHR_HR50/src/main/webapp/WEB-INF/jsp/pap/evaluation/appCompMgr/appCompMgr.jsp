<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var calcPoint = "|compPoint1001|+|compPoint1002|+|compPoint1003|+|compPoint1004|+|compPoint1005|+|compPoint1006|+|compPoint1007|";
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
   			{Header:"No",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제",	Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",	Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"평가부서코드",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"평가부서",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"성명",				Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"사번",				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"직위",				Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"직책",				Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

   			{Header:"정직성",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compCd1001",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
   			{Header:"정직성점수",		Type:"AutoAvg",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compPoint1001",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"성과지향",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compCd1002",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
   			{Header:"성과지향점수",		Type:"AutoAvg",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compPoint1002",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"팀워크",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compCd1003",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
   			{Header:"팀워크점수",		Type:"AutoAvg",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compPoint1003",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"문제해결",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compCd1004",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
   			{Header:"문제해결점수",		Type:"AutoAvg",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compPoint1004",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"동기부여",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compCd1005",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
   			{Header:"동기부여점수",		Type:"AutoAvg",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compPoint1005",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"전문가의식",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compCd1006",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
   			{Header:"전문가의식점수",	Type:"AutoAvg",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compPoint1006",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"의사소통",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compCd1007",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
   			{Header:"의사소통점수",		Type:"AutoAvg",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compPoint1007",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			
   			{Header:"1차평가승인코드",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"lastStatusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

   			{Header:"합계",				Type:"AutoAvg",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"totalPoint",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10, CalcLogic:calcPoint }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(1);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		var searchClassCd  = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "전체");//등급(P00001)
		sheet1.SetColProperty("compCd1001",	{ComboText:"|"+searchClassCd[0], ComboCode:"|"+searchClassCd[1]});
		sheet1.SetColProperty("compCd1002",	{ComboText:"|"+searchClassCd[0], ComboCode:"|"+searchClassCd[1]});
		sheet1.SetColProperty("compCd1003",	{ComboText:"|"+searchClassCd[0], ComboCode:"|"+searchClassCd[1]});
		sheet1.SetColProperty("compCd1004",	{ComboText:"|"+searchClassCd[0], ComboCode:"|"+searchClassCd[1]});
		sheet1.SetColProperty("compCd1005",	{ComboText:"|"+searchClassCd[0], ComboCode:"|"+searchClassCd[1]});
		sheet1.SetColProperty("compCd1006",	{ComboText:"|"+searchClassCd[0], ComboCode:"|"+searchClassCd[1]});
		sheet1.SetColProperty("compCd1007",	{ComboText:"|"+searchClassCd[0], ComboCode:"|"+searchClassCd[1]});

		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //짝수번째 데이터 행의 기본 배경색
		$(window).smartresize(sheetResize); sheetInit();
	});
	
	$(function() {
		//조회조건 제어
		if ( "${sessionScope.ssnPapAdminYn}" == "Y" ) {
			$("#btnAppSabunPop").show();
			$("#btnAppSabunClear").show();
		} else {
			$("#btnAppSabunPop").hide();
			$("#btnAppSabunClear").hide();
		}

		// 조회조건 이벤트 등록
		$("#searchAppraisalCd").bind("change",function(event){
			setAppGroupCdCombo();
		});

		$("#searchAppGroupCd").bind("change",function(event){
			doAction("Search");
		});

		//성명,사번
		$("#searchAppSabun").val("${sessionScope.ssnSabun}");
		$("#searchAppName").val("${sessionScope.ssnName}");
		$("#span_searchAppName").html("${sessionScope.ssnName}");
		$("#searchAppOrgNm").html("${sessionScope.ssnOrgNm}");
		$("#searchAppJikgubNm").html("${sessionScope.ssnJikgubNm}");
		$("#searchAppJikweeNm").html("${sessionScope.ssnJikweeNm}");
		$("#searchAppJikchakNm").html("${sessionScope.ssnJikchakNm}");

		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListSeqMbo&" + $("#srchFrm").serialize(),false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchAppraisalCd").change();
	});

	//평가소속 setting(평가명 change, 성명 팝업 선택 후)
	function setAppGroupCdCombo() {
		$("#searchAppGroupCd").html("");

		var appGroupCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&"
				,"queryId=getAppGroupCdList&searchAppraisalCd="+$("#searchAppraisalCd").val()
					+"&searchAppSabun="+$("#searchAppSabun").val()
					+"&searchAppStepCd="+$("#searchAppStepCd").val()
					+"&searchAppSeqCd="+$("#searchAppSeqCd").val()
				,false).codeList, "전체");
		$("#searchAppGroupCd").html(appGroupCdList[2]);
		$("#searchAppGroupCd").change();
	}

	//사원 팝업
	function employeePopup(){
		try{
			if(!isPopup()) {return;}
			var args = new Array();

			gPRow = "";
			pGubun = "searchEmployeePopup";

			openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");

		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// sheet 조회
			sheet1.DoSearch( "${ctx}/AppCompMgr.do?cmd=getAppCompMgrList", $("#srchFrm").serialize() );
			
			if($("#searchAppGroupCd").val() == ""){
				$("#dupInfoReal").hide();
				$("#avgPoint").hide();
				if ($("#searchAppSeqCd").val() == "1" && $("#searchAppSabun").val() != ""){	//평가그룹이 없어도 1차평가때는 평가그룹별 평균을 보여준다
					$("#avgPointAll").show();
				}
			} else {
				$("#dupInfoReal").show();
				$("#avgPoint").show();
				$("#avgPointAll").hide();
			}
			break;
			
		case "Save":
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AppCompMgr.do?cmd=saveAppCompMgr", $("#srchFrm").serialize());
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
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if($("#searchAppSeqCd").val() == "1") {
			    var result = ajaxCall("${ctx}/App1st2nd.do?cmd=getApp1st2ndPointInfoMap", $("#srchFrm").serialize(), false);
			    if (result != null && result.map != null ) {
			    	$("#avgPoint").text(result.map.avgPoint);
			    	$("#avgPointAll").text(result.map.avgPointAll);
			        confirmInfo2 = result.map.avgPoint;
			    }
			}
			
			// 합계행 전이
			sheet1.SetSumValue("compCd1001", sheet1.GetSumText("compPoint1001"));
			sheet1.SetSumValue("compCd1002", sheet1.GetSumText("compPoint1002"));
			sheet1.SetSumValue("compCd1003", sheet1.GetSumText("compPoint1003"));
			sheet1.SetSumValue("compCd1004", sheet1.GetSumText("compPoint1004"));
			sheet1.SetSumValue("compCd1005", sheet1.GetSumText("compPoint1005"));
			sheet1.SetSumValue("compCd1006", sheet1.GetSumText("compPoint1006"));
			sheet1.SetSumValue("compCd1007", sheet1.GetSumText("compPoint1007"));
			
			// 합계행 merge
			sheet1.SetSumValue("sNo","항목별 평균");
			sheet1.SetMergeCell(sheet1.LastRow(), 0, 1, 8);
			
			// 등급수정 가능여부
			for (var Row = 1 ; Row < sheet1.RowCount() + 1 ; Row++) {
				// LAST_STATUS_CD --1차평가승인코드 : '25', '99' 이면 수정 불가
				if (sheet1.GetCellValue(Row, "lastStatusCd") == "25" || sheet1.GetCellValue(Row, "lastStatusCd") == "99") {
					sheet1.SetCellEditable(Row, "compCd1001", false);
					sheet1.SetCellEditable(Row, "compCd1002", false);
					sheet1.SetCellEditable(Row, "compCd1003", false);
					sheet1.SetCellEditable(Row, "compCd1004", false);
					sheet1.SetCellEditable(Row, "compCd1005", false);
					sheet1.SetCellEditable(Row, "compCd1006", false);
					sheet1.SetCellEditable(Row, "compCd1007", false);
				}
			}
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	//합계행에 값이 바뀌었을 때 이벤트가 발생한다. 
	function sheet1_OnChangeSum(Row, Col) {
		switch(sheet1.ColSaveName(Col)) {
		case "compPoint1001":
			sheet1.SetSumValue("compCd1001", sheet1.GetSumText("compPoint1001"));
			break;
		case "compPoint1002":
			sheet1.SetSumValue("compCd1002", sheet1.GetSumText("compPoint1002"));
			break;
		case "compPoint1003":
			sheet1.SetSumValue("compCd1003", sheet1.GetSumText("compPoint1003"));
			break;
		case "compPoint1004":
			sheet1.SetSumValue("compCd1004", sheet1.GetSumText("compPoint1004"));
			break;
		case "compPoint1005":
			sheet1.SetSumValue("compCd1005", sheet1.GetSumText("compPoint1005"));
			break;
		case "compPoint1006":
			sheet1.SetSumValue("compCd1006", sheet1.GetSumText("compPoint1006"));
			break;
		case "compPoint1007":
			sheet1.SetSumValue("compCd1007", sheet1.GetSumText("compPoint1007"));
			break;
		}
	}
	
	//셀의 값을 편집 완료하고, 기존 값이 변경되었을 때 이벤트가 발생한다.
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		var SaveName = sheet1.ColSaveName(Col);
		var compCdColArr = ["compCd1001","compCd1002","compCd1003","compCd1004","compCd1005","compCd1006","compCd1007"];
		var compPointColArr = ["compPoint1001","compPoint1002","compPoint1003","compPoint1004","compPoint1005","compPoint1006","compPoint1007"];
		
		var index = $.inArray(SaveName, compCdColArr);
		if (index != -1) {
			var params = {
				searchAppClassCd : sheet1.GetCellValue(Row, compCdColArr[index]),
				searchAppraisalCd : $("#searchAppraisalCd").val(),
				searchCompCd : SaveName.substr(6, 4),
				searchAppOrgCd : sheet1.GetCellValue(Row, "appOrgCd"),
				searchSabun : sheet1.GetCellValue(Row, "sabun")
			}
			
		    var result = ajaxCall("${ctx}/AppCompMgr.do?cmd=getAppCompCdToPoint", params, false);
		    if (result != null && result.map != null ) {
				sheet1.SetCellValue(Row, compPointColArr[index], result.map.point);
		    }
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue + '}');

		if (pGubun == "searchEmployeePopup") {
			$("#searchAppName").val(rv["name"]);
			$("#span_searchAppName").html(rv["name"]);
			$("#searchAppSabun").val(rv["sabun"]);
			$("#searchAppOrgNm").html(rv["orgNm"]);
			$("#searchAppJikgubNm").html(rv["jikgubNm"]);
			$("#searchAppJikweeNm").html(rv["jikweeNm"]);
			$("#searchAppJikchakNm").html(rv["jikchakNm"]);
			setAppGroupCdCombo();
		}
	}
	//평가자 성명 삭제 시
	function clearAppName() {
		$("#searchAppSabun, #searchAppName").val("");
		$("#span_searchAppName,#searchAppOrgNm, #searchAppJikgubNm, #searchAppJikweeNm,#searchAppJikchakNm").html("");
		setAppGroupCdCombo();
	}

	//일괄승인
	function Approval(appSeq) {
		if ($("#searchAppSabun").val() == "") {
			alert("평가자를 선택 해주세요.");
			return;
		}

		if (sheet1.RowCount("R") == 0) {
			alert("승인할 데이터가 존재하지 않습니다.");
			return;
		}

		if (appSeq == "1") { // P_PAPN_1ST_APP_ALL

			if (confirm("일괄승인을 진행하시겠습니까?")) {
				var data = ajaxCall("${ctx}/App1st2nd.do?cmd=prcApp1stAppAll", $("#srchFrm").serialize(), false);
				if (data.Result.Code == null) {
					alert("일괄 승인이 완료되었습니다.");
					doAction("Search");
				} else {
					alert(data.Result.Message);
				}
			} else {
				return;
			}

		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" name="searchAppStepCd"		id="searchAppStepCd"	value="5" />
		<input type="hidden" name="searchAppSeqCd"		id="searchAppSeqCd"	value="1" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select id="searchAppraisalCd" name="searchAppraisalCd"></select>
						</td>
						<td>
							<span>평가자 성명 </span>
							<input id="searchAppSabun" name ="searchAppSabun" type="hidden" />

<c:choose>
	<c:when test="${ssnPapAdminYn == 'Y' || ssnGrpCd == '10'}">
							<input id="searchAppName" name ="searchAppName" type="text" class="text readonly " readonly />
							<a onclick="javascript:employeePopup();" class="button6" id="btnAppSabunPop"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="clearAppName();" class="button7" id="btnAppSabunClear"><img src="/common/images/icon/icon_undo.png"/></a>

	</c:when>
	<c:otherwise>
							<input id="searchAppName" name ="searchAppName" type="hidden" />
							<span id="span_searchAppName" class="txt"></span>
	</c:otherwise>
</c:choose>
						</td>
						<td>
							<span>평가그룹 </span>
							<select id="searchAppGroupCd" name="searchAppGroupCd"></select>
						</td>
						<td></td>
					</tr>
					<tr>
						<td>
							<span>평가자 소속</span>
							<span id="searchAppOrgNm" class="txt"></span>
						</td>

	<c:if test="${ssnJikweeUseYn == 'Y'}">
						<td>
						 	<span>평가자 직위 </span>
							<span id="searchAppJikweeNm" class="txt"></span>
						 </td>
	</c:if>
	<c:if test="${ssnJikgubUseYn == 'Y'}">
						<td>
							<span>평가자 직급</span>
							<span id="searchAppJikgubNm" class="txt"></span>
						</td>
	</c:if>
						<td>
							<span>평가자 직책</span>
							<span id="searchAppJikchakNm" class="txt"></span>
						</td>
						<td>
							<a href="javascript:doAction('Search')" id="btnSearch" class="button" >조회</a>
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
							<li id="txt" class="txt">역량평가 &nbsp;&nbsp;<span id="avgPoint" style="color:red; font-size:14px"></span>
							<span id="avgPointAll" style="color:red; font-size:14px"></span>
							</li>
							<li class="btn">
						        <a href="javascript:doAction('Save');" 			class="button authA btnApproval">저장</a>
						        <a href="javascript:Approval('1');"				class="button authA btnApproval" id="btnApproval">일괄승인</a>
								<a href="javascript:doAction('Down2Excel');" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>