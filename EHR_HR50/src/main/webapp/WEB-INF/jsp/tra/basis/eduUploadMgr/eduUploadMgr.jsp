<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>교육과정업로드</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var strOptionAll = "<option value=''>전체</option>";


	$(function() {

		$("#searchEduSYmd").datepicker2({startdate:"searchEduEYmd", onReturn: getCommonCodeList}).val("${curSysYear}-01-01");
		$("#searchEduEYmd").datepicker2({enddate:"searchEduSYmd", onReturn: getCommonCodeList}).val("${curSysYear}-12-31");
		

		$("#searchEduCourseNm, #searchEduOrgNm, #searchEduSYmd, #searchEduEYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchInOutType, #searchEduBranchCd, #searchEduMBranchCd, #searchEduMethodCd, #searchEduStatusCd, #searchEduEvtStatusCd, #searchMandatoryYn").bind("change",function(event){
			doAction1("Search"); 
		});
		
		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

	});

	//교육과정 Sheet
	function init_sheet1(){
		var initdata = {};
		initdata.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			//교육과정정보
			{Header:"과정코드|과정코드",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
			{Header:"과정명|과정명",			Type:"Text",		Hidden:0,	Width:230,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"과정상태|과정상태",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduStatusCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사내/외|사내/외",			Type:"Combo",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"inOutType",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"시행방법|시행방법",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduMethodCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"교육구분|교육구분",			Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduBranchCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"교육분류|교육분류",			Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduMBranchCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"교육기관|교육기관코드",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"교육기관|교육기관명",		Type:"Popup",		Hidden:0,	Width:110,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"관련직무|직무코드",			Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"jobCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"관련직무|직무명",			Type:"Popup",		Hidden:0,	Width:110,	Align:"Left",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"강의난이도|강의난이도",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduLevel",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"필수여부|필수여부",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"mandatoryYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			//교육회차
			{Header:"회차명|회차명",			Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"eduEventNm",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
			{Header:"회차상태|회차상태",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduEvtStatusCd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"교육신청|신청일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applSYmd",		KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, EndDateCol:"applEYmd"},
			{Header:"교육신청|마감일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applEYmd",		KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, StartDateCol:"applSYmd"},
			{Header:"교육기간|시작일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduSYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, EndDateCol:"eduEYmd"},
			{Header:"교육기간|종료일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduEYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, StartDateCol:"eduSYmd"},
			{Header:"교육기간|시작시간",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduSHm",			KeyField:0,	CalcLogic:"",	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5},	
			{Header:"교육기간|종료시간",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduEHm",			KeyField:0,	CalcLogic:"",	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5},	
			{Header:"교육기간|총 일수",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduDay",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3},	
			{Header:"교육기간|총 시간",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduHour",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3},	
			{Header:"교육장소|교육장소",			Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"eduPlace",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
			{Header:"수강인원\n(명)|수강인원\n(명)",
											Type:"Int",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"maxPerson",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3},	
			{Header:"결과보고\nSKIP여부|결과보고\nSKIP여부", 		
											Type:"CheckBox",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"resultAppSkipYn",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,		TrueValue:"Y",	FalseValue:"N",		HeaderCheck:1},	
			{Header:"만족도조사\nSKIP여부|만족도조사\nSKIP여부", 	
											Type:"CheckBox",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"eduSatiSkipYn",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,		TrueValue:"Y",	FalseValue:"N",		HeaderCheck:1},	
			{Header:"교육비|통화단위",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"currencyCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"교육비|인당교육비",			Type:"Int",			Hidden:1,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"perExpenseMon",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"교육비|실교육비",			Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"realExpenseMon",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"교육비|고용보험적용여부",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"laborApplyYn",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},	
			{Header:"교육비|환급금액",			Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"laborMon",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	

			{Header:"담당내역|사번",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mngSabun",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13},	
			{Header:"담당내역|성명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mngName",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},	
			{Header:"담당내역|소속",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"mngOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},	
			{Header:"담당내역|연락처",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mngTelNo",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},	
			
			{Header:"보상종류|보상종류",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduRewardCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"보상내역|보상내역",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduRewardCnt",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},	
			{Header:"비고|비고",				Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"evtNote",			KeyField:0,					Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},	

			//Hidden
			{Header:"Hidden", Hidden:1, SaveName:"eduEventSeq"},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,	"${ctx}/common/images/icon/icon_popup.png");
		getCommonCodeList();
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchEduSYmd").val();
		let baseEYmd = $("#searchEduEYmd").val();

		//공통코드 한번에 조회
		let grpCds = "L20020,L10010,L10015,L10050,L10170,H20300,L10190,S10030,L10110,L10090";
		let params = "useYn=Y&grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "");

		sheet1.SetColProperty("inOutType", 		{ComboText:"|"+codeLists["L20020"][0], ComboCode:"|"+codeLists["L20020"][1]} );// L20020 사내/외 구분
		sheet1.SetColProperty("eduBranchCd", 	{ComboText:"|"+codeLists["L10010"][0], ComboCode:"|"+codeLists["L10010"][1]} );// L10010 교육구분코드
		sheet1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+codeLists["L10015"][0], ComboCode:"|"+codeLists["L10015"][1]} );// L10015 교육분류코드
		sheet1.SetColProperty("eduMethodCd", 	{ComboText:"|"+codeLists["L10050"][0], ComboCode:"|"+codeLists["L10050"][1]} );// L10050 교육시행방법코드
		sheet1.SetColProperty("eduStatusCd", 	{ComboText:"|"+codeLists["L10170"][0], ComboCode:"|"+codeLists["L10170"][1]} );// L10170 교육과정상태코드
		sheet1.SetColProperty("foreignCd", 		{ComboText:"|"+codeLists["H20300"][0], ComboCode:"|"+codeLists["H20300"][1]} );// H20300 외국어종류
		sheet1.SetColProperty("eduLevel", 		{ComboText:"|"+codeLists["L10090"][0], ComboCode:"|"+codeLists["L10090"][1]} );// L10090 강의난이도

		sheet1.SetColProperty("eduEvtStatusCd", {ComboText:"|"+codeLists["L10190"][0], ComboCode:"|"+codeLists["L10190"][1]} );// L10190 회차상태
		sheet1.SetColProperty("currencyCd", 	{ComboText:"|"+codeLists["S10030"][0], ComboCode:"|"+codeLists["S10030"][1]} );// S10030 통화단위
		sheet1.SetColProperty("eduRewardCd", 	{ComboText:"|"+codeLists["L10110"][0], ComboCode:"|"+codeLists["L10110"][1]} );// L10110 보상종류

		$("#searchInOutType").html(strOptionAll+codeLists["L20020"][2]);
		$("#searchEduBranchCd").html(strOptionAll+codeLists["L10010"][2]);
		$("#searchEduMBranchCd").html(strOptionAll+codeLists["L10015"][2]);
		$("#searchEduMethodCd").html(strOptionAll+codeLists["L10050"][2]);
		$("#searchEduStatusCd").html(strOptionAll+codeLists["L10170"][2]);
		$("#searchEduEvtStatusCd").html(strOptionAll+codeLists["L10190"][2]);

	}

	function chkInVal(sAction) {
		
		switch (sAction) {
			case "Search" :
				if( $("#searchEduSYmd").val() != "" && $("#searchEduEYmd").val() != "" ){
					if(!checkFromToDate($("#searchEduSYmd"), $("#searchEduEYmd"), "교육시작일", "교육시작일", "YYYYMMDD")) {
						$("#searchEduEYmd").focus();
						$("#searchEduEYmd").select();
						return false;
					}
				}
				break;
			case "Save" :
				for (var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++) {
					if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
						if (sheet1.GetCellValue(i, "eduSYmd") != null && sheet1.GetCellValue(i, "eduEYmd") != "") {
							var sdate = sheet1.GetCellValue(i, "eduSYmd");
							var edate = sheet1.GetCellValue(i, "eduEYmd");
							if (parseInt(sdate) > parseInt(edate)) {
								alert("<msg:txt mid='110396' mdef='교육기간 시작일자가 종료일자보다 큽니다.'/>");
								sheet1.SelectCell(i, "eduEYmd");
								return false;
							}
						}
					}

					if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
						if (sheet1.GetCellValue(i, "applSYmd") != null && sheet1.GetCellValue(i, "applEYmd") != "") {
							var sdate = sheet1.GetCellValue(i, "applSYmd");
							var edate = sheet1.GetCellValue(i, "applEYmd");
							if (parseInt(sdate) > parseInt(edate)) {
								alert("<msg:txt mid='110396' mdef='교육신청 신청일이 마감일보다 큽니다.'/>");
								sheet1.SelectCell(i, "applEYmd");
								return false;
							}
						}
					}
				}
				break;
		}
		return true;
	}

	//---------------------------------------------------------------------------------------------------------------
	//Sheet1 Actionx
	//---------------------------------------------------------------------------------------------------------------
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if(!chkInVal(sAction)){break;}
				sheet1.DoSearch( "${ctx}/EduUploadMgr.do?cmd=getEduUploadMgrList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!chkInVal(sAction)){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/EduUploadMgr.do?cmd=saveEduUploadMgr", $("#sheet1Form").serialize());
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;

			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;
			case "DownTemplate":
				// 양식다운로드
				var downcol = makeHiddenSkipCol(sheet1);
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:downcol});

				break;
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

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
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	// 셀 팝업 클릭 시
	function sheet1_OnPopupClick(Row, Col) {
		try {
			if (sheet1.ColSaveName(Col) == "eduOrgNm") {  //교육기관 선택
				if (!isPopup()) {  return; }

				gPRow = Row;
				pGubun = "eduOrgPopup";

				let eduOrgLayer = new window.top.document.LayerModal({
					id: 'eduOrgLayer',
					url: '/Popup.do?cmd=viewEduOrgLayer&authPg=R',
					parameters: {},
					width: 620,
					height: 570,
					title: '교육기관 리스트 조회',
					trigger :[
						{
							name : 'eduOrgLayerTrigger',
							callback : function(rv){
								sheet1.SetCellValue(gPRow, "eduOrgCd", rv["eduOrgCd"]);
								sheet1.SetCellValue(gPRow, "eduOrgNm", rv["eduOrgNm"]);
							}
						}
					]
				});

				eduOrgLayer.show();
				
			} else if (sheet1.ColSaveName(Col) == "jobNm") {  //관련직무
				if (!isPopup()) {  return; }
				gPRow = Row;
				pGubun = "jobPopup";

				let jobLayer = new window.top.document.LayerModal({
					id : 'jobPopupLayer'
					, url : '/Popup.do?cmd=jobPopup&authPg=R'
					, parameters : {}
					, width : 740
					, height : 720
					, title : '직무 리스트 조회'
					, trigger :[
						{
							name : 'jobPopupTrigger'
							, callback : function(rv){
								sheet1.SetCellValue(gPRow, "jobCd", rv["jobCd"]);
								sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"]);
							}
						}
					]
				});
				jobLayer.show();
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}


	// 셀 클릭 시
	function sheet1_OnClick(Row, Col, Value) {
		try {
			if( Row < sheet1.HeaderRows() ) return;

			var saveName = sheet1.ColSaveName(Col);
			if (saveName == "selectImg" ) { // 

				if ( sheet1.FindStatusRow("I|U|D") != "" ) {
					alert("입력 또는 수정중인 항목이 존재합니다. 저장 먼저 해주세요.");
					return;
				}

				if (!isPopup()) { return; }

				var args = new Array();
				args["eduSeq"] 		= sheet1.GetCellValue(Row, "eduSeq");
				args["eduCourseNm"] = sheet1.GetCellValue(Row, "eduCourseNm");
				args["authPg"] 		= "A";

				gPRow = Row;
				pGubun = "viewEduMgrComptyPop";

				openPopup( "${ctx}/EduCourseMgr.do?cmd=viewEduMgrComptyPop",args, "900", "600");
			}

		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	// 엑셀업로드 후
	function sheet1_OnLoadExcel(result) {
		try {
			//for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
			//	sheet2.SetCellValue(i, "eduSeq", $("#searchEduSeq").val(), 0 );
			//}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	//---------------------------------------------------------------------------------------------------------------
	// 팝업 콜백 함수.
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue + '}');

		if (pGubun == "eduMgrPopup") {  //교육상세 팝업
			
			doAction1("Search");
			
		}else if (pGubun == "employeePopup") {
			sheet2.SetCellValue(gPRow, "mngName", rv["name"]);
			sheet2.SetCellValue(gPRow, "mngSabun", rv["sabun"]);
			sheet2.SetCellValue(gPRow, "mngOrgNm", rv["orgNm"]);
			sheet2.SetCellValue(gPRow, "mngTelNo", rv["officeTel"]);
			

		} else if (pGubun == "eduOrgPopup") { // 교육기관 팝업
			sheet1.SetCellValue(gPRow, "eduOrgCd", rv["eduOrgCd"]);
			sheet1.SetCellValue(gPRow, "eduOrgNm", rv["eduOrgNm"]);

		}
	}
	
	//검색 - 교육기관 팝업
	function doSearchEduOrgNm() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "searchEduOrgPopup";

		let eduOrgLayer = new window.top.document.LayerModal({
			id: 'eduOrgLayer',
			url: '/Popup.do?cmd=viewEduOrgLayer&authPg=R',
			parameters: {},
			width: 620,
			height: 570,
			title: '교육기관 리스트 조회',
			trigger :[
				{
					name : 'eduOrgLayerTrigger',
					callback : function(rv){
						$("#searchEduOrgNm").val( rv["eduOrgNm"] );
					}
				}
			]
		});

		eduOrgLayer.show();
	}
	

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>과정명</th>
			<td>
				<input type="text" id="searchEduCourseNm" name="searchEduCourseNm" class="text w150" style="ime-mode:active;"/>
			</td>
			<th>교육기관</th>
			<td>
				<input id="searchEduOrgNm" name ="searchEduOrgNm" type="text" class="text w100" readonly />
				<a href="javascript:doSearchEduOrgNm();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				<a onclick="$('#searchEduOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
			</td>
			<th>교육분류</th>
			<td>
				<select id="searchEduMBranchCd" name="searchEduMBranchCd"></select>
			</td>
			<th>사내/외</th>
			<td>
				<select id="searchInOutType" name="searchInOutType"></select>
			</td>
		</tr>
		<tr>
			<th>과정상태</th>
			<td>
				<select id="searchEduStatusCd" name="searchEduStatusCd"></select>
			</td>
			<th>교육구분</th>
			<td>
				<select id="searchEduBranchCd" name="searchEduBranchCd"></select>
			</td>
			<th>시행방법</th>
			<td>
				<select id="searchEduMethodCd" name="searchEduMethodCd"></select>
			</td>
			<th>필수여부</th>
			<td>
				<select id="searchMandatoryYn" name="searchMandatoryYn" />
					<option value="">전체</option>
					<option value="Y">필수</option>
					<option value="N">선택</option>
				</select>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		<tr>
			<th>회차상태</th>
			<td>
				<select id="searchEduEvtStatusCd" name="searchEduEvtStatusCd"></select>
			</td>
			<th>교육시작일</th>
			<td>
				<input id="searchEduSYmd" name="searchEduSYmd" type="text" size="10" class="date2" value=""/>
				~ <input id="searchEduEYmd" name="searchEduEYmd" type="text" size="10" class="date2" value=""/>
			</td>
		</tr>
		</table>	
	</div>
	<!-- 조회조건 끝 -->
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">교육과정업로드</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('DownTemplate')"	class="btn outline-gray authA">양식다운로드</a>
					<a href="javascript:doAction1('LoadExcel')"		class="btn outline-gray authA">업로드</a>
					<a href="javascript:doAction1('Save')" 			class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	
</div>
</body>
</html>
