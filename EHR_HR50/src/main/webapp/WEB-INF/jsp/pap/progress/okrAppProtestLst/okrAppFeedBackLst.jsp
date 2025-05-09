<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<title>이의제기결과</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	$(function() {
		
		//평가명
		var appraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListOkr&searchAppStepCd=5",false).codeList, ""); // 평가명
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='appraisalNmV1' mdef='평가명|평가명'/>",			Type:"Text",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",				Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='nameV3' mdef='성명|성명'/>",					Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV6' mdef='소속|소속'/>",				Type:"Text",		Hidden:0,					Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV1' mdef='직위|직위'/>",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='2023082501114' mdef='평가등급|최종'/>",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appFinalClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},

			{Header:"<sht:txt mid='2023082501121' mdef='이의제기|세부\n내역'/>",		Type:"Image",		Hidden:0,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"fbDetail", Cursor:"Pointer" },
			{Header:"<sht:txt mid='2023082501120' mdef='이의제기|상태'/>",				Type:"Combo",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fbStatusCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"이의제기|1차의견",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"memo1st"},
			{Header:"이의제기|1차답변",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback1st"},
			{Header:"이의제기|1차답변자사번",	Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback1stSabun"},
			{Header:"이의제기|1차파일순번",	Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq1st"},
			{Header:"이의제기|2차의견",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"memo2nd"},
			{Header:"이의제기|2차답변",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback2nd"},
			{Header:"이의제기|2차답변자사번",	Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback2ndSabun"},
			{Header:"이의제기|2차파일순번",	Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq2nd"},
			{Header:"이의제기|3차의견",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"memo3rd"},
			{Header:"이의제기|3차답변",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback3rd"},
			{Header:"이의제기|3차답변자사번",	Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback3rdSabun"},
			{Header:"이의제기|3차파일순번",	Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq3rd"},

			{Header:"이의제기|허용여부",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"이의제기|허용시작일",		Type:"Date",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionWorkSdate",	KeyField:0, Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"이의제기|허용종료일",		Type:"Date",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionWorkEdate",	KeyField:0, Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			
			{Header:"평가ID|평가ID",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"평가소속|평가소속",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("fbDetail",1);
		
		var comboList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10020"), "전체"); // 이의제기상태(P10020)
		sheet1.SetColProperty("fbStatusCd", {ComboText: "|"+comboList[0], ComboCode: "|"+comboList[1]} );
		
		var appSeqCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=Y","P00003"), ""); // 평가차수(P00003)
		$("#searchAppSeqCd").html(appSeqCdList[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//성명,사번
		$("#searchAppSabun").val("${sessionScope.ssnSabun}");
		$("#searchAppName").val("${sessionScope.ssnName}");
		$("#searchKeyword").val("${sessionScope.ssnName}");
		$("#span_searchAppName").html("${sessionScope.ssnName}");
		
		$("#searchAppraisalCd").html(appraisalCd[2]);
		
		$("#searchNameSabun, #searchAppOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); 
				$(this).focus(); 
			}
		});
		
		$("#searchAppraisalCd").bind("change",function(event){
			doAction1("Search");
		});
		
		setEmpPage();
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	
			if($("#searchAppSabun").val() == "") {
				$("#searchAppSabun").val("${sessionScope.ssnSabun}");
			}
			sheet1.DoSearch( "${ctx}/OkrAppProtestLst.do?cmd=getOkrFeedbackSessionAllLst", $("#empForm").serialize() ); 
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function exception_chk(Row){
		if(sheet1.GetCellValue(Row, "exceptionYn") == "Y"){
			var date = new Date();
			if(makeDateFormat(sheet1.GetCellValue(Row, "exceptionWorkSdate")) != false && makeDateFormat(sheet1.GetCellValue(Row, "exceptionWorkEdate")) != false) {
				if (date < makeDateFormat(sheet1.GetCellValue(Row, "exceptionWorkSdate"))) {
					alert("<msg:txt mid='2023082501119' mdef='이의제기는 이의제기 허용시작일 이전에 할 수 없습니다.'/>");
					return 0;
				} else if (date > makeDateFormat(sheet1.GetCellValue(Row, "exceptionWorkEdate"))) {
					alert("<msg:txt mid='2023082501118' mdef='확인 및 입력할 수 있는 기간이 아닙니다!'/>");
					return 0;
				}
			}else{
				alert("<msg:txt mid='2023082501117' mdef='이의제기 허용시작일 또는 종료일이 없습니다.\n관리자에게 문의하세요.'/>");
				return 0;
			}
			return 2;
		}else{
			alert("<msg:txt mid='2023082501116' mdef='이의제기가 허용되지 않는 평가입니다.'/>");
			return 0;
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(Row <= 1) return;
			if(sheet1.ColSaveName(Col) == "fbDetail" ){
				/* 이의제기 조건 체크 */
				var chkData = exception_chk(Row);
				var protestFeedBackYn;
				var saveBtnYn = 'N';

				/* if(chkData == 0) {
					return;
				}else if(chkData == 1){
					saveBtnYn		= 'N';
				}else if(chkData == 2){
					saveBtnYn		= 'Y';
					if(sheet1.GetCellValue(Row, "fbStatusCd") == "13" || sheet1.GetCellValue(Row, "fbStatusCd") == "23" || sheet1.GetCellValue(Row, "fbStatusCd") == "99") {
						saveBtnYn	= 'N';
					}
				} */
				
				if(!isPopup()) {return;}
				var url = "${ctx}/OkrAppProtestLst.do?cmd=viewOkrAppProtestLstComment";
				var args = new Array();

				args["searchAppraisalCd"]		= sheet1.GetCellValue(Row, "appraisalCd");
				args["searchSabun"]				= sheet1.GetCellValue(Row, "sabun");
				args["searchAppOrgCd"]			= sheet1.GetCellValue(Row, "appOrgCd");
				args["fbStatusCd"]				= sheet1.GetCellValue(Row, "fbStatusCd");
				args["memo1st"]					= sheet1.GetCellValue(Row, "memo1st");
				args["feedback1st"]				= sheet1.GetCellValue(Row, "feedback1st");
				args["fileSeq1st"]				= sheet1.GetCellValue(Row, "fileSeq1st");
				args["memo2nd"]					= sheet1.GetCellValue(Row, "memo2nd");
				args["feedback2nd"]				= sheet1.GetCellValue(Row, "feedback2nd");
				args["fileSeq2nd"]				= sheet1.GetCellValue(Row, "fileSeq2nd");
				args["memo3rd"]					= sheet1.GetCellValue(Row, "memo3rd");
				args["feedback3rd"]				= sheet1.GetCellValue(Row, "feedback3rd");
				args["fileSeq3rd"]				= sheet1.GetCellValue(Row, "fileSeq3rd");
				args["feedback1stSabun"]		= sheet1.GetCellValue(Row, "feedback1stSabun");
				args["feedback2ndSabun"]		= sheet1.GetCellValue(Row, "feedback2ndSabun");
				args["feedback3rdSabun"]		= sheet1.GetCellValue(Row, "feedback3rdSabun");
				args["saveBtnYn"]				= saveBtnYn;
				args["adminCheck"]				= "admin";
				gPRow = "";
				pGubun = "okrAppProtestLstCommentView";

				openPopup(url,args,800,480);
			} else if(sheet1.ColSaveName(Col) == "detail" ){
				
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchAppName").val($("#searchKeyword").val());
		$("#span_searchAppName").val($("#searchKeyword").val());
		$("#searchAppSabun").val($("#searchUserId").val());
		$("#searchAppOrgCd").val($("#headOrgCd").val());
		$("#appOrgNm").val($("#headOrgNm").val());
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "okrAppProtestLstCommentView"){
			doAction1("Search");
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<form id="empForm" name="empForm" >
	<input type="hidden" name="searchAppOrgCd"		id="searchAppOrgCd"	 />
	<input type="hidden" name="appOrgNm"			id="appOrgNm"	 />
	
	<!-- 호출 팝업 넘겨줄 키 값 -->
	<input type="hidden" id="exceptionSdateValue" name="exceptionSdateValue" value=""/>
	<input type="hidden" id="exceptionEdateValue" name="exceptionEdateValue" value=""/>
	
	<!-- 조회영역 > 성명 자동완성 관련 추가 -->
	<input type="hidden" name="searchEmpType"		id="searchEmpType" value="I"/>
	<input type="hidden" name="searchUserId"		id="searchUserId" value="" />
	<input type="hidden" name="searchUserEnterCd"	id="searchUserEnterCd" value="" />
	<input type="hidden" name="headOrgCd"			id="headOrgCd"	 />
	<input type="hidden" name="headOrgNm"			id="headOrgNm"	 />
	<!-- 조회영역 > 성명 자동완성 관련 추가 -->
		
	<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span><tit:txt mid='111888' mdef='평가명'/></span>
							<select id="searchAppraisalCd" name="searchAppraisalCd"></select>
						</td>
						<!-- <td>
							<span>평가차수</span>
							<select id="searchAppSeqCd" name="searchAppSeqCd"></select>
						</td> -->
						<td>
							<span class="w90"><tit:txt mid='113683' mdef='평가자'/> <tit:txt mid='103880' mdef='성명'/></span>
							<input id="searchAppSabun" name ="searchAppSabun" type="hidden" />

<c:choose>
	<c:when test="${ssnPapAdminYn == 'Y'}">
							<input id="searchAppName" name ="searchAppName" type="hidden" />
							<input type="text" id="searchKeyword"  name="searchKeyword" class="text w100" style="ime-mode:active"/>
	</c:when>
	<c:otherwise>
							<input id="searchAppName" name ="searchAppName" type="hidden" />
							<input id="searchKeyword" name ="searchKeyword" type="hidden" />
							<span id="span_searchAppName" class="txt pap_span"></span>
	</c:otherwise>
</c:choose>
						</td>
					</tr>
					<tr>
						<td>
							<span><tit:txt mid='appCoachingApr1' mdef='피평가자'/></span>
							<input id="searchNameSabun" name="searchNameSabun" type="text" class="text w100" />
						</td>
						<td>
							<span><tit:txt mid='104279' mdef='소속'/></span>
							<input id="searchAppOrgNm" name="searchAppOrgNm" type="text" class="text w100" style="ime-mode:active"/>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
						</td>
					</tr>					
				</table>
			</div>
		</div>
	</form>
		<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='2023082801368' mdef='이의제기결과'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>