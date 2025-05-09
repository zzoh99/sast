<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<title>이의제기</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='appraisalNmV1' mdef='평가명|평가명'/>",			Type:"Text",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgNm_V3431' mdef='소속|소속'/>",				Type:"Text",		Hidden:0,					Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeNm_V10' mdef='직위|직위'/>",				Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='2023082501114' mdef='평가등급|최종'/>",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appFinalClassNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='2023082501122' mdef='상시세부|상시세부'/>",			Type:"Image",		Hidden:0,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail", Cursor:"Pointer" },
			{Header:"<sht:txt mid='2023082501121' mdef='이의제기|세부\n내역'/>",		Type:"Image",		Hidden:0,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"fbDetail", Cursor:"Pointer" },
			{Header:"<sht:txt mid='2023082501120' mdef='이의제기|상태'/>",			Type:"Combo",		Hidden:0,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"fbStatusCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},

				
			{Header:"이의제기|1차의견",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"memo1st"},
			{Header:"이의제기|1차답변",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback1st"},
			{Header:"이의제기|1차답변자사번",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback1stSabun"},
			{Header:"이의제기|1차파일순번",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq1st"},
			{Header:"이의제기|2차의견",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"memo2nd"},
			{Header:"이의제기|2차답변",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback2nd"},
			{Header:"이의제기|2차답변자사번",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback2ndSabun"},
			{Header:"이의제기|2차파일순번",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq2nd"},
			{Header:"이의제기|3차의견",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"memo3rd"},
			{Header:"이의제기|3차답변",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback3rd"},
			{Header:"이의제기|3차답변자사번",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"feedback3rdSabun"},
			{Header:"이의제기|3차파일순번",		Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq3rd"},

			{Header:"이의제기|허용여부",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"이의제기|상시시작일",		Type:"Date",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionWorkSdate",	KeyField:0, Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"이의제기|상시종료일",		Type:"Date",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionWorkEdate",	KeyField:0, Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			
			{Header:"평가ID|평가ID",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"평가소속|평가소속",			Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"사번|사번",				Type:"Text",		Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",1);
		sheet1.SetDataLinkMouse("fbDetail",1);
		
		var comboList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10020"), "전체"); // 이의제기상태(P10020)
		sheet1.SetColProperty("fbStatusCd", {ComboText: "|"+comboList[0], ComboCode: "|"+comboList[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();

		setEmpPage();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OkrAppProtestLst.do?cmd=getOkrAppProtestLstList", $("#srchFrm").serialize() );
			break;
			
		case "Save":
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/OkrAppProtestLst.do?cmd=saveOkrAppProtestLst", $("#srchFrm").serialize());
			break;
			
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0), "col2");
			break;
			
		case "Copy":
			sheet1.DataCopy();
			break;
			
		case "Clear":
			sheet1.RemoveAll();
			break;
			
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
			
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
			break;
			
		case "FeedBackDownLoad" :
			var element = document.createElement('a');
			element.setAttribute('href',"${baseURL}/hrfile/LSE/pap/FeedBack.docx");
			element.setAttribute('download', "FeedBack.docx");
			document.body.appendChild(element);
			element.click();
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
				var saveBtnYn;
				var complateBtnYn;

				if(chkData == 0) {
					return;
				}else if(chkData == 1){
					saveBtnYn		= 'N';
				}else if(chkData == 2){
					saveBtnYn		= 'Y'; //저장버튼
					complateBtnYn	= 'Y'; //신청버튼
					if(sheet1.GetCellValue(Row, "fbStatusCd") == "11" || sheet1.GetCellValue(Row, "fbStatusCd") == "21" || sheet1.GetCellValue(Row, "fbStatusCd") == "31" || sheet1.GetCellValue(Row, "fbStatusCd") == "99") {
						saveBtnYn	= 'N';
						complateBtnYn	= 'N';
					}
				}
				
				if(!isPopup()) {return;}
				var url = "${ctx}/OkrAppProtestLst.do?cmd=viewOkrAppProtestLstComment";
				var args = new Array();
				console.log(sheet1.GetCellValue(Row, "feedback1stSabun"));
				console.log(sheet1.GetCellValue(Row, "feedback2ndSabun"));
				console.log(sheet1.GetCellValue(Row, "feedback3rdSabun"));
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
				args["complateBtnYn"]			= complateBtnYn;
				args["adminCheck"]				= "user";
				gPRow = "";
				pGubun = "okrAppProtestLstCommentView";

				openPopup(url,args,800,480);
			} else if(sheet1.ColSaveName(Col) == "detail" ){
				showDetailPopup('R',Row, sheet1.ColSaveName(Col));
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	var showDetailPopup = function (authPg,Row, btn) {
		if(!isPopup()) {return;}
		
		var args = new Array();
		var url = "";
		var popW = 800;
		var popH = 800;
		
		if(btn == "detail"){ //상세
			url = "${ctx}/OkrAppProtestLst.do?cmd=viewOkrAppProtestDetail";
		}
		
		args["authPg"] = authPg;
		args["pageGubun"] = "workReg";
		args["searchAppraisalCd"] = sheet1.GetCellValue(Row, "appraisalCd");
		args["searchOrgCd"] = sheet1.GetCellValue(Row, "appOrgCd");
		args["searchOrgNm"] = sheet1.GetCellValue(Row, "appOrgNm");
		args["searchJikweeNm"] = sheet1.GetCellValue(Row, "jikweeNm");
		args["searchName"] = $("#searchName").val();
		args["searchSabun"] = $("#searchSabun").val();
		
		gPRow = Row;
		pGubun = "okrAppProtestPop";
		
		openPopup(url,args,popW,popH);
	};

	function setEmpPage() {
		$("#searchSabun").val($("#searchUserId").val());
		$("#searchName").val($("#searchKeyword").val());
		doAction1("Search");
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
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	<input type="hidden" id="searchName" name="searchName" value=""/>
	<!-- 호출 팝업 넘겨줄 키 값 -->
	<input type="hidden" id="exceptionSdateValue" name="exceptionSdateValue" value=""/>
	<input type="hidden" id="exceptionEdateValue" name="exceptionEdateValue" value=""/>
	</form>
		<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='2023082801369' mdef='이의제기'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('FeedBackDownLoad')" css="basic authA" style="background-color:#f379b2; color:#FFF;" mid='2023082701247' mdef="이의제기신청양식"/>
				<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>