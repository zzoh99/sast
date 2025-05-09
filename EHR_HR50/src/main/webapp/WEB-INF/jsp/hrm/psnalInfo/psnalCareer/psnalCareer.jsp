<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103836' mdef='인사기본(경력)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		// 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
		initIbFileUpload($("#infoFrom"));

		// 파일 목록 변수의 초기화 작업 시점 정의
		// clearBeforeFunc(function object)
		// 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
		//		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
		//	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
		sheet2_OnSearchEnd = clearBeforeFunc(sheet2_OnSearchEnd);
		sheet2_OnSaveEnd = clearBeforeFunc(sheet2_OnSaveEnd)

		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm117"] = sheet2;
		EMP_INFO_CHANGE_TABLE_SHEET["thrm116"] = sheet3;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"경력인정년월",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"totAgreeCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"재직년월",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"총경력년월",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"allCareerCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:9,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",			Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"<sht:txt mid='cmpNm' mdef='직장명'/>",			Type:"Text",      	Hidden:0,  Width:100,   Align:"Left",  ColMerge:0,   SaveName:"cmpNm",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",      	Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"sdate",		KeyField:1,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",		Type:"Date",      	Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"edate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='cmpCd' mdef='직장코드'/>",			Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"cmpCd",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"직장구분",										Type:"Combo",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"cmpDiv",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Left",    ColMerge:0,   SaveName:"deptNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",      	Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='jobNmV1' mdef='담당업무'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jobNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='manageNm_V861' mdef='고용형태'/>",	Type:"Combo",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"manageCd",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='jobCdV2' mdef='담당직무코드'/>",	Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jobCd",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='jobNmBef' mdef='담당직무\n(과거)'/>",Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jobNmBef",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			{Header:"<sht:txt mid='memo2' mdef='퇴직사유'/>",			Type:"Text",      	Hidden:0,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"memo2",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1300 },
			{Header:"<sht:txt mid='agreeRate' mdef='인정\n비율(%)'/>",Type:"Float",      	Hidden:0,  Width:50,    Align:"Center",  ColMerge:0,   SaveName:"agreeRate",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeYymmCnt' mdef='인정경력'/>",	Type:"Text",      	Hidden:1,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"agreeYymmCnt",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"인정경력(년)",									Type:"Int",      	Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"careerYyCnt",		KeyField:0,   CalcLogic:"",   Format:"####",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"인정경력(월)",									Type:"Int",      	Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"careerMmCnt",		KeyField:0,   CalcLogic:"",   Format:"####",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",      	Hidden:0,  Width:200,    Align:"Center",  ColMerge:0,   SaveName:"note",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },

			{Header:"<sht:txt mid='businessNm' mdef='직무상세'/>",	Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"businessNm",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",		Type:"Html",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		];
		IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:9,DataRowMerge:0};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata3.Cols = [
			{Header:"<sht:txt mid='sNo_V' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete _V' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus_V' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun_V' mdef='사번'/>",	Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='eduSeq_V' mdef='순번'/>",		Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },

			{Header:"<sht:txt mid='orgNm_V' mdef='조직명'/>",		Type:"Text",      	Hidden:0,  Width:200,   Align:"Left",  ColMerge:0,   SaveName:"tfOrgNm",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='sdate_V' mdef='시작일'/>",		Type:"Date",      	Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"sdate",		KeyField:1,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='edate_V' mdef='종료일'/>",		Type:"Date",      	Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"edate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='jikchakNm_V' mdef='직책'/>",		Type:"Text",      	Hidden:1,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeNm_V' mdef='직위'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"평가",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"evalTxt",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='jobNm_V' mdef='담당업무'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jobNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='note_V' mdef='비고'/>",			Type:"Text",      	Hidden:0,  Width:200,   Align:"Center",  ColMerge:0,   SaveName:"note",			KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },

		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);

		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		$("#hdnEnterCd").val($("#searchUserEnterCd",parent.document).val());
		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			sheet2.SetEditable(0);
			$(".enterAuthBtn").hide();
		}
		var enterCd = "&enterCd=" + $("#hdnEnterCd").val();

		var userCd11 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H11710"), " ");	//직장구분
		var userCd12 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H10040"), " ");	//고용형태구분
		sheet2.SetColProperty("cmpDiv", 			{ComboText:"|"+userCd11[0], ComboCode:"|"+userCd11[1]} );
		sheet2.SetColProperty("manageCd", 			{ComboText:"|"+userCd12[0], ComboCode:"|"+userCd12[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()
						+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			sheet1.DoSearch( "${ctx}/PsnalCareer.do?cmd=getPsnalCareerUserList", param );
			break;
		case "Save":
			IBS_SaveName(document.infoFrom,sheet1);
			sheet1.DoSave( "${ctx}/PsnalCareer.do?cmd=updatePsnalCareerUser", $("#infoFrom").serialize());
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			clearFileListArr('sheet2'); // 파일 목록 변수의 초기화
			var param = "sabun="+$("#hdnSabun").val()
						+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			sheet2.DoSearch( "${ctx}/PsnalCareer.do?cmd=getPsnalCareerList", param );
			break;
		case "Insert":
			var row = sheet2.DataInsert(0);
			sheet2.SetCellValue(row,"sabun",$("#hdnSabun").val());
			//파일첨부 시작
			sheet2.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
			//파일첨부 끝
			break;
		case "Copy":
			var row = sheet2.DataCopy();
			sheet2.SetCellValue(row, "seq", "");
			sheet2.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
			sheet2.SetCellValue(row, "fileSeq", '');
			break;
		case "Save":
			IBS_SaveName(document.infoFrom,sheet2);
			sheet2.DoSave( "${ctx}/PsnalCareer.do?cmd=savePsnalCareer", $("#infoFrom").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
			break;
		}
	}

	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()
						+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			sheet3.DoSearch( "${ctx}/PsnalBasicInf.do?cmd=getPsnalExperienceList", param );
			break;
		case "Insert":
			var row = sheet3.DataInsert(0);
			sheet3.SetCellValue(row,"sabun",$("#hdnSabun").val());
			break;
		case "Copy":
			var row = sheet3.DataCopy();
			sheet3.SetCellValue(row, "seq", "");
			break;
		case "Save":
			IBS_SaveName(document.infoFrom,sheet3);
			sheet3.DoSave( "${ctx}/PsnalBasicInf.do?cmd=savePsnalExperience", $("#infoFrom").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet3.Down2Excel(param);
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
			getSheetData();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			//파일 첨부 시작
			for(var i = 0; i < sheet2.RowCount(); i++) {

				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(sheet2.GetCellValue(i+1,"fileSeq") == ''){
						sheet2.SetCellValue(i+1, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
						sheet2.SetCellValue(i+1, "sStatus", 'R');
					}else{
						sheet2.SetCellValue(i+1, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
						sheet2.SetCellValue(i+1, "sStatus", 'R');
					}
				}else{
					if(sheet2.GetCellValue(i+1,"fileSeq") != ''){
						sheet2.SetCellValue(i+1, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
						sheet2.SetCellValue(i+1, "sStatus", 'R');
					}
				}
			}

			if("${authPg}" == 'R'){
				sheet2.SetColHidden("cmpCd", 1);
			}

			//파일 첨부 끝
			sheetResize();


		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction3("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet2.GetCellEditable(Row,Col) == true) {
				if(sheet2.ColSaveName(Col) == "jobNm" && KeyCode == 46) {
	            	sheet2.SetCellValue(Row, "jobCd", "");
	            	sheet2.SetCellValue(Row, "jobNm", "");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet2_OnChange(Row, Col, Value) {
		try{
			var colName = sheet2.ColSaveName(Col);
			if( colName == "sdate" || colName == "edate" || colName == "agreeRate") {
				if(sheet2.GetCellValue(Row, "sdate") != "" && sheet2.GetCellValue(Row, "edate") != "") {
					var param = "sdate=" + sheet2.GetCellValue(Row, "sdate")
					            + "&edate=" + sheet2.GetCellValue(Row, "edate")
					            + "&agreeRate=" + sheet2.GetCellValue(Row, "agreeRate")
					            ;
					var resultMap = ajaxCall("${ctx}/PsnalCareer.do?cmd=getPsnalCareerYYMM", param, false);

					if( resultMap.DATA != null ) {
				    	sheet2.SetCellValue(Row, "careerYyCnt", resultMap.DATA.yy);
				    	sheet2.SetCellValue(Row, "careerMmCnt", resultMap.DATA.mm);
			    	}

				}
		    }
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	// 시트에서 폼으로 세팅.
	function getSheetData() {

		var row = sheet1.LastRow();

		if(row == 0) {
			return;
		}

		$('#totAgreeCntTxt').text(sheet1.GetCellValue(row,"totAgreeCnt"));
		$('#workCntTxt').text(sheet1.GetCellValue(row,"workCnt"));
		$('#allCareerCntTxt').text(sheet1.GetCellValue(row,"allCareerCnt"));
	}

	//파일 신청 시작
	function sheet2_OnClick(Row, Col, Value) {
		try{
			if(sheet2.ColSaveName(Col) == "btnFile" && Row >= sheet2.HeaderRows()){
				var param = [];
				param["fileSeq"] = sheet2.GetCellValue(Row,"fileSeq");
				if(sheet2.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup";

					var authPgTemp="${authPg}";
					//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=career", param, "740","620");
	                fileMgrPopup(Row, Col);
				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
    // 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&authPg=${authPg}&uploadType=career'
            , parameters : {
                fileSeq : sheet2.GetCellValue(Row,"fileSeq"),
				fileInfo: getFileList(sheet2.GetCellValue(Row,"fileSeq")) // 파일 목록 동기화 처리를 위함
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
						addFileList(sheet2, Row, result); // 작업한 파일 목록 업데이트
                        if(result.fileCheck == "exist"){
                            sheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
                            sheet2.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            sheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
                            sheet2.SetCellValue(gPRow, "fileSeq", "");
                        }
                    }
                }
            ]
        });
        layerModal.show();
    }
    //파일 신청 끝

</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<div class="wrapper">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
	<div class="outer hide">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='career' mdef='경력'/></li>
		</ul>
		</div>
	</div>

	<form id="infoFrom" name="infoFrom">
		<table border="0" cellpadding="0" cellspacing="0" class="default outer hide">
		<colgroup>
			<col width="13%" />
			<col width="21%" />
			<col width="13%" />
			<col width="21%" />
			<col width="13%" />
			<col width="*" />
		</colgroup>
		<tr>
			<th><tit:txt mid='112207' mdef='인정경력'/></th>
			<td>
				<span id="totAgreeCntTxt"></span>
			</td>
			<th><tit:txt mid='112880' mdef='근속년월'/></th>
			<td>
				<span id="workCntTxt"></span>
			</td>
			<th><tit:txt mid='113619' mdef='총 경력'/></th>
			<td>
				<span id="allCareerCntTxt"></span>
			</td>
		</tr>
		</table>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='career1' mdef='사외경력'/></li>
			<li class="btn _thrm117">
				<btn:a href="javascript:doAction2('Search');" css="btn dark authR" mid='110697' mdef="조회"/>
			<c:if test="${authPg == 'A'}">
				<btn:a href="javascript:doAction2('Insert');" css="btn outline_gray authA enterAuthBtn" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction2('Copy');" css="btn outline_gray authA enterAuthBtn" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction2('Save');" css="btn filled authA enterAuthBtn" mid='110708' mdef="저장"/>
			</c:if>
				<btn:a href="javascript:doAction2('Down2Excel');" css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "${ssnLocaleCd}"); </script>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
	
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='career1' mdef='사내경력'/></li>
			<li class="btn _thrm116">
				<btn:a href="javascript:doAction3('Search');" css="btn dark authR" mid='110697' mdef="조회"/>
			<c:if test="${authPg == 'A'}">
				<btn:a href="javascript:doAction3('Insert');" css="btn outline_gray authA enterAuthBtn" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction3('Copy');" css="btn outline_gray authA enterAuthBtn" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction3('Save');" css="btn filled authA enterAuthBtn" mid='110708' mdef="저장"/>
			</c:if>
				<btn:a href="javascript:doAction3('Down2Excel');" css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	
	<script type="text/javascript"> createIBSheet("sheet3", "100%", "50%", "${ssnLocaleCd}"); </script>
	
</div>
</body>
</html>
