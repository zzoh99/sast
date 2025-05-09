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
		//TAB
		$("#tabs").tabs();

		// 조회조건 이벤트 등록
		$("#searchAppraisalCd").bind("change",function(event){
			setAppOrgCdCombo();
		});

		$("#searchAppOrgCd").bind("change",function(event){
			setAppEmployee();
		});

		//성명,사번
		$("#searchEvaSabun").val("${sessionScope.ssnSabun}");
		$("#searchName").val("${sessionScope.ssnName}");
		$("#searchKeyword").val("${sessionScope.ssnName}");

		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListMbo2&searchAppStepCd="+$('#searchAppStepCd').val(),false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchAppraisalCd").change();
	});

	function init_sheet(){
		if( $("#DIV_sheet1").html().length > 0 ) {
			return;
		}

		//목표등록 시 중간점검 실적 숨김
		var cHdn1= 0;
		if($("#searchAppStepCd").val() == "1"){
			cHdn1= 1;
		}

		var appIndexGubunCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"),""); // 평가지표구분
		
		// 190529 IDS 코드 조회
		var mboTypeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10009"), ""); // 목표구분(P10009)
		var appClassCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), ""); // 평가등급(P00001)
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,MergeSheet:msAll,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"세부\n내역|세부\n내역",	Type:"Image",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"detail",				KeyField:0, UpdateEdit:0,   InsertEdit:0,   Cursor:"Pointer"},
   			{Header:"순서|순서",				Type:"Int",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2},
   			{Header:"구분|구분",				Type:"Combo",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"appIndexGubunCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	ComboText: appIndexGubunCdList[0], ComboCode: appIndexGubunCdList[1]},
   			{Header:"구분|구분",				Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"appIndexGubunNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0	},

			{Header:"목표구분|목표구분",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"mboType",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	ComboText: mboTypeCdList[0], ComboCode: mboTypeCdList[1]},
			{Header:"목표항목|목표항목",			Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:1500},
			
			{Header:"비중(%)|비중(%)",			Type:"AutoSum", Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"weight",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:6, MaximumValue:100, MinimumValue:0},
			{Header:"목표달성을 위한 핵심 요인|목표달성을 위한 핵심 요인",			Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"kpiNm",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:1000},
			{Header:"달성목표(정량,최종)|달성목표(정량,최종)",			Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"formula",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:1500},
			{Header:"중점추진 Activity|중점추진 Activity",			Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"remark",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:1500},

			{Header:"추진일정|From",			Type:"Text",	Hidden:1,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"deadlineType",	KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"추진일정|To",				Type:"Text",	Hidden:1,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"deadlineTypeTo",	KeyField:0,	UpdateEdit:0,	InsertEdit:0 },			
			{Header:"측정기준|측정기준",			Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"baselineData",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:1500},
			
   			{Header:"목표수준|S(100)",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"sGradeBase",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:300},
			{Header:"목표수준|A(90)", 			Type:"Text", 	Hidden:1, 	Width:100, 	Align:"Left", 	ColMerge:0, SaveName:"aGradeBase",		KeyField:0, UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:300},
			{Header:"목표수준|B(80)", 			Type:"Text", 	Hidden:1, 	Width:100, 	Align:"Left", 	ColMerge:0, SaveName:"bGradeBase",		KeyField:0, UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:300},
			{Header:"목표수준|C(70)", 			Type:"Text", 	Hidden:1, 	Width:100, 	Align:"Left", 	ColMerge:0, SaveName:"cGradeBase",		KeyField:0, UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:300},
			{Header:"목표수준|D(60)",		 	Type:"Text",	Hidden:1, 	Width:100, 	Align:"Left", 	ColMerge:0, SaveName:"dGradeBase",		KeyField:0, UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:300},

			{Header:"중간평가|중간평가",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboMidAppSelfClassCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	ComboText: appClassCdList[0], ComboCode: appClassCdList[1]},
			{Header:"중간점검실적|중간점검실적",		Type:"Text",	Hidden:cHdn1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"mboMidAppResult",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:1000},
			{Header:"1차평가|1차평가",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboMidApp1stClassCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	ComboText: appClassCdList[0], ComboCode: appClassCdList[1]},
			{Header:"승인자의견|승인자의견",			Type:"Text",	Hidden:cHdn1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"mboMidApp1stMemo",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:1500},

			{Header:"평가ID",					Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"평가소속",				Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"사원번호",				Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"순서",					Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"},
			{Header:"생성구분코드",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mkGubunCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		sheet1.SetEditEnterBehavior("newline");
		sheet1.SetAutoSumPosition(1);
		sheet1.SetSumValue("sNo", "합계") ;
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //짝수번째 데이터 행의 기본 배경색
		
		//var sheetHeight = $('.wrapper').height() - $('#empForm').height() - $('.tab_bottom').outerHeight(true) - 20;
		$(window).smartresize(sheetResize); sheetInit();
		//sheet1.SetSheetHeight(sheetHeight);
		
	}

	//평가소속 setting(평가명 change, 성명 팝업 선택 후)
	function setAppOrgCdCombo() {
		$("#searchAppOrgCd").html("");

		var appOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&"
				,"queryId=getAppOrgCdListMboTarget"
				+"&searchAppraisalCd="+$("#searchAppraisalCd").val()
				+"&searchSabun="+$("#searchEvaSabun").val()
				+"&searchAppStepCd="+$("#searchAppStepCd").val()
				+"&searchAppYn=Y"
			,false).codeList, ""); // 평가소속

		$("#searchAppOrgCd").html(appOrgCdList[2]);
		$("#searchAppOrgCd").change();
	}

	//피평가자, 평가자정보조회(평가소속 change)
	function setAppEmployee() {
		$("#searchAppSabun").val("");
		$("#searchAppStatusCd").val("");
		$("#searchAppSheetType").val("");

		$("#searchAppName").val("");
		$("#searchJikgubNm").val("");
		$("#searchJikweeNm").val("");
		$("#searchStatus").val("");

		$("#spanBtnComment").hide();

		var data = ajaxCall("${ctx}/EvaMain.do?cmd=getMboTargetRegMapAppEmployee",$("#empForm").serialize(),false);

		if(data != null && data.map != null) {
			$("#searchAppSabun").val(data.map.appSabun);
			$("#searchAppStatusCd").val(data.map.statusCd);
			$("#searchAppSheetType").val(data.map.appSheetType);

			$("#searchAppName").val(data.map.appName);
			$("#searchJikgubNm").val(data.map.jikgubNm);
			$("#searchJikweeNm").val(data.map.jikweeNm);

			$("#searchStatus").val(data.map.statusNm);
			$("#searchAppraisalYn").val(data.map.appraisalYn); //평가완료여부

			if( data.map.commentImg == "Y") {
				$("#spanBtnComment").show();
			}
		}

		init_sheet();
		doAction("Search");
	}

	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchName").val($("#searchKeyword").val());
		$("#searchEvaSabun").val($("#searchUserId").val());
		setAppOrgCdCombo();
	}

	//사원 팝업
	function employeePopup(){
		try{
			if(!isPopup()) {return;}

			var args = new Array();
			//args["topKeyword"] = $("#searchName").val();

			gPRow = "";
			pGubun = "searchEmployeePopup";

			openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			doAction1("Search");
			break;
		case "Down2Excel":
			doAction1("Down2Excel");
			break;
		case "Print":
			rdPopup();
			break;
		}
	}

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/EvaMain.do?cmd=getMboTargetRegList1", $("#empForm").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}

		return true;
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			// 자동생성 ROW 인 경우 수정, 삭제 불가
			for( var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
				if ( sheet1.GetCellValue(i, "mkGubunCd") == "S" ) {
					sheet1.SetRowEditable(i, 0);
					//sheet1.SetCellEditable(i,"sDelete", 1); //수정은 불가하지만 삭제는 가능하도록 수정
					//sheet1.SetCellEditable(i,"mboMidAppResult", 1); //중간점검시 실적은 Editable

				}
			}

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet1.ColSaveName(Col) == "detail" ){
				showDetailPopup(Row);
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	var showDetailPopup = function (Row) {
		var paramName = ["orderSeq"
		                 ,"appIndexGubunNm"
		                 ,"mboTarget"
		                 ,"kpiNm"
		                 ,"formula"
		                 ,"baselineData"
		                 ,"sGradeBase"
		                 ,"aGradeBase"
		                 ,"bGradeBase"
		                 ,"cGradeBase"
		                 ,"dGradeBase"
		                 ,"weight"
		                 ,"remark"
		                 ,"seq"
		                 ,"mboMidAppResult"
		                 ,"mboType"
		                 ,"deadlineType"
		                 ,"deadlineTypeTo"
		                 ,"mboMidApp1stMemo"
		];

		var url = "${ctx}/EvaMain.do?cmd=viewMboTargetRegPopDetail";
		var args = new Array();

		args["authPg"] = "R";

		for (var i=0; i<paramName.length; i++) {
			args[paramName[i]] = sheet1.GetCellValue(Row, paramName[i]);
		}
		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		args["searchAppStepCd"] = $("#searchAppStepCd").val();
		args["searchAppSeqCd"] = $("#searchAppSeqCd").val();
		args["searchAppStatusCd"] = $("#searchAppStatusCd").val();

 		gPRow = Row;
 		pGubun = "mboTargetRegPopDetail";

 		var layer = new window.top.document.LayerModal({
			id : 'mboTargetRegPopDetailLayer'
			, url : "${ctx}/EvaMain.do?cmd=viewMboTargetRegPopDetail"
			, parameters: args
			, width : 1000
			, height : 800
			, title : "MBO관리"
			, trigger :[
				{
					name : 'mboTargetRegPopDetailTrigger'
					, callback : function(rv){
						getReturnValue(rv);
					}
				}
			]
		});
		layer.show();
 		
		//openPopup(url,args,700,800);
	};

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "searchEmployeePopup"){
			$("#searchName").val(rv["name"]);
			$("#searchEvaSabun").val(rv["sabun"]);
			setAppOrgCdCombo();
		}
	}


	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(){
		if(!isPopup()) {return;}

		if ( $("#searchAppOrgCd").val() == ""  ) {
			alert("평가정보가 없습니다.");
			return;
		}

		var w 		= 1200;
		var h 		= 920;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		//var rdMrd   = "pap/progress/AppReport.mrd";
		var rdMrd	= "";
		var rdTitle = "";
		var rdParam = "";

		if($("#searchAppStepCd").val() == "1") {
			//목표승인
			rdMrd = "pap/progress/MboTargetStep1.mrd";
			rdTitle = "목표등록출력물";
		} else {
			//중간점검승인
			rdMrd = "pap/progress/MboTargetStep2.mrd";
			rdTitle = "중간점검출력물";
		}

		rdParam  = rdParam +"[${ssnEnterCd}] "; //회사코드
		rdParam  = rdParam +"["+ $("#searchAppraisalCd").val() +"] "; //평가ID
		//rdParam  = rdParam +"["+ $("#searchAppStepCd").val() +"] "; //단계
		//rdParam  = rdParam +"["+ $("#searchAppSeqCd").val() +"] "; //차수
		rdParam  = rdParam +"[('"+ $("#searchEvaSabun").val() +"', '"+ $("#searchAppOrgCd").val() +"')] "; //피평가자 사번, 평가소속
		
		var imgPath = " " ;
		args["rdTitle"] = rdTitle ;	//rd Popup제목
		args["rdMrd"] =  rdMrd;		//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = rdParam;	//rd파라매터
		args["rdParamGubun"] = "rp";//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;	//툴바여부
		args["rdZoomRatio"] = "100";//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

 		gPRow = "";
 		pGubun = "rdPopup";

		openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}
</script>

</head>
<body class="hidden">
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" name="searchAppStepCd"		id="searchAppStepCd"	value="${map.searchAppStepCd}"/>
		<input type="hidden" name="searchAppSeqCd"		id="searchAppSeqCd"		value="${map.searchAppSeqCd}"/>
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
							<select id="searchAppraisalCd" name="searchAppraisalCd"></select>
						</td>
						<td>
							<span class="w60">평가소속 </span>
							<select id="searchAppOrgCd" name="searchAppOrgCd"></select>
						</td>
						<td>
							<span class="w60">평가자 </span>
							<input id="searchAppName" name ="searchAppName" type="text" class="text readonly" readonly />
						</td>
						<td></td>
					</tr>
					<tr>
						<td>
							<span class="w60">성명 </span>
							<input id="searchEvaSabun" name ="searchEvaSabun" type="hidden" />
				<c:choose>
					<c:when test="${ sessionScope.ssnPapAdminYn == 'Y'}">
							<input id="searchName" name ="searchName" type="hidden" />
							<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/>
							<!-- 자동완성기능 사용으로 인한 주석 처리
							<input id="searchName" name ="searchName" type="text" class="text readonly " readonly />
							<a onclick="javascript:employeePopup();" class="button6" id="btnSabunPop"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchEvaSabun,#searchName').val('');" class="button7" id="btnSabunClear"><img src="/common/images/icon/icon_undo.png"/></a>
							 -->
					</c:when>
					<c:otherwise>
							<input id="searchName" name ="searchName" type="text" class="text readonly" readonly />
							<input id="searchKeyword" name ="searchKeyword" type="hidden" />
					</c:otherwise>
				</c:choose>
						</td>
						<td>
							<a href="javascript:doAction('Search')" id="btnSearch" class="btn dark" >조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div id="tabs">
		<ul class="tab_bottom mb-8">
			<li><a href="#tabs-1" id="tabKpi">업적</a></li>
			<li class="ml-auto">
				<a style="display:none;"></a>
				<a href="javascript:doAction('Down2Excel')"		class="btn outline_gray authR" id="btnDown2Excel">다운로드</a>
				<a href="javascript:doAction('Print');"			class="btn outline_gray authR" id="btnPrint">출력</a>
			</li>
		</ul>

		<div id="tabs-1">
			<script type="text/javascript"> createTabHeightIBsheet("sheet1", "100%", "100%"); </script>
		</div>
	</div>
</div>
</body>
</html>