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

	var bLink = false;
	var bLoad = true;

	if ( "${map.searchAppraisalCd_back}" != "" ) {
		bLink = true;
	}

	$(function() {
		// 조회조건 이벤트 등록
		$("#searchAppraisalCd").bind("change",function(event){
			doAction("Search");
		});
		$("#searchAppSeqCd").bind("change",function(event){
			doAction("Search");
		});
		
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=D,",false).codeList, "");
		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommonCodeList&grpCd=P00003&note3=N",false).codeList, "전체");

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",   Hidden:1,		   Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",   Hidden:0,		   Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
<c:if test="${map.searchAppSeqCd == '4'}">
			{Header:"선택|선택",			Type:"DummyCheck",	Hidden:0,		Width:50,	Align:"Center", ColMerge:0, SaveName:"chk",			KeyField:0, Format:"",  PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1 },
</c:if>
			{Header:"평가대상|평가대상",		Type:"Combo",	Hidden:0,			Width:70,	Align:"Center", ColMerge:0, SaveName:"appSeqCd",	KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},
			{Header:"성명|성명",			Type:"Text",	Hidden:0,			Width:70,	Align:"Center", ColMerge:0, SaveName:"name",		KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},
			{Header:"사번|사번",			Type:"Text",	Hidden:0,			Width:70,	Align:"Center", ColMerge:0, SaveName:"sabun",		KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},
			{Header:"평가소속|평가소속",		Type:"Text",	Hidden:0,			Width:100,	Align:"Center", ColMerge:0, SaveName:"appOrgNm",	KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},
			{Header:"직위|직위",			Type:"Text",	Hidden:"${jwHdn}",	Width:50,	Align:"Center", ColMerge:0, SaveName:"jikweeNm",	KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},
			{Header:"직군|직군",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center", ColMerge:0, SaveName:"workTypeNm",	KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},
			{Header:"직급|직급",			Type:"Text",	Hidden:"${jgHdn}",	Width:50,	Align:"Center", ColMerge:0, SaveName:"jikgubNm",	KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},
			{Header:"직책|직책",			Type:"Text",	Hidden:0,			Width:50,	Align:"Center", ColMerge:0, SaveName:"jikchakNm",	KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},
			{Header:"평가|평가",			Type:"Image",	Hidden:0,			Width:50,	Align:"Center", ColMerge:0, SaveName:"detail",		KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},
			{Header:"평가|완료\n여부",		Type:"Combo",	Hidden:0,			Width:50,	Align:"Center", ColMerge:0, SaveName:"appraisalYn",	KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},
			{Header:"평가|평가점수",		Type:"Text",	Hidden:0,			Width:70,	Align:"Center", ColMerge:0, SaveName:"appPoint",	KeyField:0, Format:"",  PointCount:0, UpdateEdit:0, InsertEdit:0},

			{Header:"평가ID",				Type:"Text",	Hidden:1,			Width:50,	Align:"Center", ColMerge:0, SaveName:"appraisalCd"},
			{Header:"평가소속",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center", ColMerge:0, SaveName:"appOrgCd"},
			{Header:"사원번호",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center", ColMerge:0, SaveName:"appSabun"},
			{Header:"평가차수",			Type:"Text",	Hidden:1,			Width:50,	Align:"Center", ColMerge:0, SaveName:"appSeqCd"},
			{Header:"1차평가자사번", 		Type:"Text",	Hidden:1,			Width:100,	Align:"Center", ColMerge:0, SaveName:"appSabun1st"},
			{Header:"평가단계",	   		Type:"Text",	Hidden:1,			Width:100,	Align:"Center", ColMerge:0, SaveName:"appStepCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(1);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");
		sheet1.SetDataLinkMouse("detail",1);

//		 var cmbCdLst1  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), "");	 //평가등급
//		 sheet1.SetColProperty("app2ndClassCd",		   {ComboText:"|"+cmbCdLst1[0], ComboCode:"|"+cmbCdLst1[1]} );
//		 sheet1.SetColProperty("app2ndClassCd",		   {ComboText:"|"+cmbCdLst1[0], ComboCode:"|"+cmbCdLst1[1]} );


		sheet1.SetColProperty("appraisalYn",	{ComboText:"Y|N", ComboCode:"Y|N"} );
		sheet1.SetColProperty("appSeqCd",		{ComboText:appSeqCdList[0], ComboCode:appSeqCdList[1]} );
		
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchAppSeqCd").html(appSeqCdList[2]);

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

		//성명,사번
		$("#searchAppSabun").val("${sessionScope.ssnSabun}");
		$("#searchAppName").val("${sessionScope.ssnName}");
		$("#searchKeyword").val("${sessionScope.ssnName}");
		$("#searchAppOrgNm").val("${sessionScope.ssnOrgNm}");
		$("#span_searchAppOrgNm").html("${sessionScope.ssnOrgNm}");
		$("#searchAppJikweeNm").val("${sessionScope.ssnJikweeNm}");
		$("#searchAppJikgubNm").val("${sessionScope.ssnJikgubNm}");
		$("#span_searchAppJikweeNm").html("${sessionScope.ssnJikweeNm}");
		$("#searchAppJikchakNm").val("${sessionScope.ssnJikchakNm}");
		$("#span_searchAppJikchakNm").html("${sessionScope.ssnJikchakNm}");

		if ( bLink != "" ) {
			$("#searchAppSabun").val(decodeURI("${map.searchAppSabun_back}"));
			$("#searchAppName").val(decodeURI("${map.searchAppName_back}"));
			$("#searchKeyword").val("${map.searchAppName_back}");
			$("#searchAppOrgNm").val(decodeURI("${map.searchAppOrgNm_back}"));
			$("#span_searchAppOrgNm").html(decodeURI("${map.searchAppOrgNm_back}"));
			$("#searchAppJikweeNm").val(decodeURI("${map.searchAppJikweeNm_back}"));
			$("#searchAppJikgubNm").val(decodeURI("${map.searchAppJikgubNm_back}"));
			$("#span_searchAppJikweeNm").html(decodeURI("${map.searchAppJikweeNm_back}"));
			$("#searchAppJikchakNm").val(decodeURI("${map.searchAppJikchakNm_back}"));
			$("#span_searchAppJikchakNm").html(decodeURI("${map.searchAppJikchakNm_back}"));
		}

		if ( "${map.searchAppraisalCd_back}" != "" ) {
			$("#searchAppraisalCd").val("${map.searchAppraisalCd_back}");
		}
		$("#searchAppraisalCd").change();
		
	});

	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchAppName").val($("#searchKeyword").val());
		$("#searchAppSabun").val($("#searchUserId").val());
		
		$("#searchAppOrgNm").val($("#headOrgNm").val());
		$("#span_searchAppOrgNm").html($("#headOrgNm").val());
		
		$("#searchAppJikweeNm").val($("#headJikweeNm").val());
		$("#span_searchAppJikweeNm").html($("#headJikweeNm").val());
		
		$("#searchAppJikgubNm").val($("#headJikgubNm").val());
		$("#span_searchAppJikgubNm").html($("#headJikgubNm").val());
		
		$("#searchAppJikchakNm").val($("#headJikchakNm").val());
		$("#span_searchAppJikchakNm").html($("#headJikchakNm").val());

		doAction("Search");
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
			// 사원리스트 조회 전 사진정보부터 이미지 리스트에 셋팅한다.
			//searchEmpImgList() ;

			// sheet 조회
			sheet1.DoSearch( "${ctx}/MltsrcEvltSbjt.do?cmd=getMltsrcEvltSbjtList", $("#empForm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.empForm,sheet1);
			sheet1.DoSave( "${ctx}/MltsrcEvltSbjt.do?cmd=saveMltsrcEvltSbjt", $("#empForm").serialize());
			break;
		case "Clear":
			sheet1.RemoveAll();
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
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if ( sheet1.ColSaveName(Col) == "detail" ) {

				if($("#searchAppSeqCd").val() == "1") {
					if(sheet1.GetCellValue(Row,"mboSelfappraisalYn") != "Y") {
						alert("본인평가를 완료하지 않았습니다.");
						return;
					}
				} else if($("#searchAppSeqCd").val() == "2") {
					if(sheet1.GetCellValue(Row,"mbo1stappraisalYn") != "Y") {
						alert("1차평가를 완료하지 않았습니다.");
						return;
					}
				}

				var appSeqCd = sheet1.GetCellValue( Row, "appSeqCd" );
				if(appSeqCd == "" && $("#searchAppSeqCd").val() != "" ) {
					appSeqCd = $("#searchAppSeqCd").val();
				}
				$("#searchAppraisalCd_back").val($("#searchAppraisalCd").val());
				$("#searchAppSabun_back").val($("#searchAppSabun").val());
				$("#searchAppName_back").val($("#searchAppName").val());
				$("#searchAppSeqCd_back").val(appSeqCd);
				$("#searchAppOrgNm_back").val($("#searchAppOrgNm").val());
				$("#searchAppJikweeNm_back").val($("#searchAppJikweeNm").val());
				$("#searchAppJikgubNm_back").val($("#searchAppJikgubNm").val());
				$("#searchAppJikchakNm_back").val($("#searchAppJikchakNm").val());
				$("#backPage").val("${ctx}/MltsrcEvltSbjt.do?cmd=viewMltsrcEvltSbjt&searchAppSeqCd="+appSeqCd);

				$("#searchAppraisalCd_sub").val($("#searchAppraisalCd").val());
				$("#searchAppraisalNm_sub").val($("#searchAppraisalCd option:selected").text());
				$("#searchAppSabun_sub").val($("#searchAppSabun").val());
				$("#searchAppName_sub").val($("#searchAppName").val());
				$("#searchAppSeqCd_sub").val(sheet1.GetCellValue(Row, "appSeqCd"));
				$("#searchAppOrgCd_sub").val(sheet1.GetCellValue(Row, "appOrgCd"));
				$("#searchAppOrgNm_sub").val(sheet1.GetCellValue(Row, "appOrgNm"));
				$("#searchSabun_sub").val(sheet1.GetCellValue(Row, "sabun"));
				$("#searchName_sub").val(sheet1.GetCellValue(Row, "name"));
				submitCall($("#linkFrm"),"_self","POST", "${ctx}/MltsrcEvlt.do?cmd=viewMltsrcEvlt&searchAppSeqCd=" + appSeqCd);

			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "searchEmployeePopup"){
			$("#searchAppName").val(rv["name"]);
			$("#span_searchAppName").html(rv["name"]);
			$("#searchAppSabun").val(rv["sabun"]);
			$("#searchAppOrgNm").val(rv["orgNm"]);
			$("#span_searchAppOrgNm").html(rv["orgNm"]);
			$("#searchAppJikweeNm").val(rv["jikweeNm"]);
			$("#span_searchAppJikweeNm").html(rv["jikweeNm"]);
			$("#searchAppJikgubNm").val(rv["jikgubNm"]);
			$("#span_searchAppJikgubNm").html(rv["jikgubNm"]);

			$("#searchAppJikchakNm").val(rv["jikchakNm"]);
			$("#span_searchAppJikchakNm").html(rv["jikchakNm"]);
			doAction("Search");
		}
	}

	function rdPopup(){

		if(!isPopup()) {return;}

		var enterCdSabun = "";
		var sRow = sheet1.FindCheckedRow("chk");

		if(sRow == ""){
			alert("<msg:txt mid='109876' mdef='대상자를 선택하세요'/>");
			return;
		}

		$(sRow.split("|")).each(function(index,value){
			if ( index == 0 ){
				enterCdSabun += "'" + sheet1.GetCellValue(value,"appraisalCd") +"_" + sheet1.GetCellValue(value,"sabun") +"_" + sheet1.GetCellValue(value,"appOrgCd") +"_" + sheet1.GetCellValue(value,"appSabun") + "'";
			}else{
				enterCdSabun += ",'" + sheet1.GetCellValue(value,"appraisalCd") +"_" + sheet1.GetCellValue(value,"sabun") +"_" + sheet1.GetCellValue(value,"appOrgCd") +"_" + sheet1.GetCellValue(value,"appSabun") + "'";
			}
		});

		var viewYn1 = "Y";
		var viewYn2 = "Y";
		var viewYn3 = "Y";
		var viewYn4 = "Y";
		var fullApp = "Y";

		var rdMrd = "pap/progress/mltsrcEvltSbjt.mrd";
		var rdTitle = "";
		var rdParam = "";

		rdTitle = "업무협조도평가";
		rdParam  += "["+ enterCdSabun +"] "; //회사코드, 사번
		rdParam  += "["+ viewYn1 +"] "; //인사기본1
		rdParam  += "["+ viewYn2 +"] "; //인사기본2
		rdParam  += "["+ viewYn3 +"] "; //발령사항
		rdParam  += "["+ viewYn4 +"] "; //교육사항
		rdParam  += "["+ fullApp +"] "; // 전체발령체크
		rdParam  += "[${ssnEnterCd}] ";
		rdParam  += "[${ssnLocaleCd}] ";	// 10.다국어코드
		var w 		= 900;
		var h 		= 1100;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();

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

		pGubun = "rdPopup";
		var win = openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" name="searchAppStepCd"	 id="searchAppStepCd"	value="5" />
		<!-- <input type="hidden" name="searchAppSeqCd"	  id="searchAppSeqCd" value="${map.searchAppSeqCd}" /> -->
		
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->
		<input type="hidden" id="searchEmpType"	  name="searchEmpType"	  value="I"/>
		<input type="hidden" id="searchUserId"	   name="searchUserId"	   value="" />
		<input type="hidden" id="searchUserEnterCd"  name="searchUserEnterCd"  value="" />
		<input type="hidden" id="headOrgNm"		  name="headOrgNm"		  value="" />
		<input type="hidden" id="headJikweeNm"	   name="headJikweeNm"	   value="" />
		<input type="hidden" id="headJikgubNm"	   name="headJikgubNm"	   value="" />
		<input type="hidden" id="headJikchakNm"	  name="headJikchakNm"	  value="" />
		<!-- 조회영역 > 성명 자동완성 관련 추가 -->

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span class="w50">평가명 </span>
							<select id="searchAppraisalCd" name="searchAppraisalCd"></select>
						</td>
						<td>
							<span>차수</span>
							<select name="searchAppSeqCd" id="searchAppSeqCd"></select>
						</td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>
							<span class="w50">성명 </span>
							<input id="searchAppSabun" name ="searchAppSabun" type="hidden" />
<c:choose>
	<c:when test="${ssnPapAdminYn == 'Y' || ssnGrpCd == '10'}">
							<input id="searchAppName" name="searchAppName" type="hidden" />
							<input type="text"   id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/>
							<!-- 
							<input id="searchAppName" name="searchAppName" type="text" class="text readonly " readonly />
							<a onclick="javascript:employeePopup();" class="button6" id="btnAppSabunPop"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchAppSabun,#searchAppName').val('');" class="button7" id="btnAppSabunClear"><img src="/common/images/icon/icon_undo.png"/></a>
							&nbsp;&nbsp;&nbsp;&nbsp;
							 -->
	</c:when>
	<c:otherwise>
							<input type="hidden" id="searchKeyword" name="searchKeyword" />
							<input id="searchAppName" name ="searchAppName" type="text" class="text readonly" readonly>
							<b id="span_searchAppName" class="txt hide"></b>
	</c:otherwise>
</c:choose>
						</td>
						<td>
							<span class="w50">소속</span>
							<input id="searchAppOrgNm" name ="searchAppOrgNm" type="hidden"/>
							<b id="span_searchAppOrgNm" class="txt"></b>
						</td>

	<c:if test="${ssnJikweeUseYn == 'Y'}">
						<td>
							<span class="w50">직위</span>
							<input id="searchAppJikweeNm"   name ="searchAppJikweeNm" type="hidden"/>
							<b id="span_searchAppJikweeNm" class="txt"></b>
						</td>
	</c:if>
	<c:if test="${ssnJikgubUseYn == 'Y'}">
						<td>
						 	<span class="w50">직급 </span>
						 	<input id="searchJikgubNm" name ="searchJikgubNm" type="hidden" />
							<b id="span_searchJikgubNm" class="txt"></b>
						 </td>
	</c:if>
						<td>
							<span class="w50">직책</span>
							<input id="searchAppJikchakNm"  name ="searchAppJikchakNm" type="hidden"/>
							<b id="span_searchAppJikchakNm" class="txt"></b>
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
							<li id="txt" class="txt">다면평가</li>
							<li class="btn">
							<c:if test="${map.searchAppSeqCd == '4'}">
								<%--<a href="javascript:rdPopup();"			  id="btnRd"  class="button authR">업무협조도출력</a> --%>
							</c:if>
								<a href="javascript:doAction('Save')"		id="saveBtn"   class="basic authA">저장</a>
								<a href="javascript:doAction('Down2Excel')"	 class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>

</div>

<form id="linkFrm" name="linkFrm" >
	<input type="hidden" name="authPg" id="authPg" value="${authPg}"/>
	<input type="hidden" name="backPage" id="backPage" value=""/>

	<input type="hidden" name="searchAppraisalCd_back"  id="searchAppraisalCd_back" />
	<input type="hidden" name="searchAppSabun_back"	 id="searchAppSabun_back" />
	<input type="hidden" name="searchAppName_back"	  id="searchAppName_back" />
	<input type="hidden" name="searchAppSeqCd_back"	 id="searchAppSeqCd_back" />
	<input type="hidden" name="searchAppOrgNm_back"	 id="searchAppOrgNm_back" />
	<input type="hidden" name="searchAppJikweeNm_back"  id="searchAppJikweeNm_back" />
	<input type="hidden" name="searchAppJikgubNm_back"  id="searchAppJikgubNm_back" />
	<input type="hidden" name="searchAppJikchakNm_back" id="searchAppJikchakNm_back" />

	<input type="hidden" name="searchAppraisalCd_sub"   id="searchAppraisalCd_sub" />
	<input type="hidden" name="searchAppraisalNm_sub"   id="searchAppraisalNm_sub" />
	<input type="hidden" name="searchAppSabun_sub"	  id="searchAppSabun_sub" />
	<input type="hidden" name="searchAppName_sub"	   id="searchAppName_sub" />
	<input type="hidden" name="searchAppSeqCd_sub"	  id="searchAppSeqCd_sub" />
	<input type="hidden" name="searchAppOrgCd_sub"	  id="searchAppOrgCd_sub" />
	<input type="hidden" name="searchAppOrgNm_sub"	  id="searchAppOrgNm_sub" />
	<input type="hidden" name="searchSabun_sub"		 id="searchSabun_sub" />
	<input type="hidden" name="searchName_sub"		  id="searchName_sub" />
</form>

</body>
</html>