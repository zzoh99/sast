<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>교육과정관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var codeLists ;
	var strOptionAll = "<option value=''>전체</option>"; 
	var ssnTelNo = "";


	$(function() {
		// 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
		initIbFileUpload($("#sheet1Form"));

		// 파일 목록 변수의 초기화 작업 시점 정의
		// clearBeforeFunc(function object)
		// 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
		//		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
		//	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
		sheet1_OnSearchEnd = clearBeforeFunc(sheet1_OnSearchEnd);
		sheet1_OnSaveEnd = clearBeforeFunc(sheet1_OnSaveEnd)

		//공통코드 한번에 조회
		var grpCds = "L20020,L10010,L10015,L10050,L10170,H20300,L10190,S10030,L10110,L10090";
		codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","useYn=Y&grpCd="+grpCds,false).codeList, "");
		
		//사용자정보 조회
		var user = ajaxCall( "${ctx}/EduCourseMgr.do?cmd=getEduCourseMgrUserInfo", "",false);
		if ( user != null && user.DATA != null ){ 
			ssnTelNo = user.DATA.telNo;
		}
		
		
		$("#searchEduSYmd").datepicker2({startdate:"searchEduEYmd"}).val("${curSysYear}-01-01");
		$("#searchEduEYmd").datepicker2({enddate:"searchEduSYmd"}).val("${curSysYear}-12-31");
		
		$("#searchEduSYmd, #searchEduEYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction2("Search"); $(this).focus(); }
		});

		$("#searchEduCourseNm, #searchEduOrgNm, #searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchInOutType, #searchEduBranchCd, #searchEduMBranchCd, #searchEduMethodCd, #searchEduStatusCd, #searchEduLevel").bind("change",function(event){
			doAction1("Search"); 
		});
		
		$("#searchEduAll").bind("change", function(){
			var selRow = sheet1.GetSelectRow();
			if( $("#searchEduAll").is(":checked") ){
				$("#searchEduSeq").val("");
				$("#spanEduCourseNm").val("");
			}else{
				if( selRow > 0 ){
					$("#searchEduSeq").val(sheet1.GetCellValue(selRow,"eduSeq"));
					$("#spanEduCourseNm").val(sheet1.GetCellValue(selRow,"eduCourseNm"));
				}else{
					$("#searchEduSeq").val("");
					$("#spanEduCourseNm").val("");
				}
			}
			doAction2("Search");
		});

		//Sheet 초기화
		init_sheet1(); init_sheet2();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

	});

	//교육과정 Sheet
	function init_sheet1(){
		var initdata = {};
		initdata.Cfg = {FrozenCol:8,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"관련\n역량",			Type:"Image",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:1,	SaveName:"selectImg",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	Cursor:"Pointer"},	
			{Header:"첨부\n파일",			Type:"Image",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:1,	SaveName:"fileImg",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	Cursor:"Pointer"},	
			{Header:"과정코드",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
			{Header:"과정명",				Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"과정상태",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduStatusCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사내/외",			Type:"Combo",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"inOutType",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"시행방법",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduMethodCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"교육구분",			Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduBranchCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"교육분류",			Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduMBranchCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"교육기관코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduOrgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
			{Header:"교육기관",			Type:"Popup",		Hidden:0,	Width:110,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직무코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
			{Header:"관련직무",			Type:"Popup",		Hidden:0,	Width:110,	Align:"Left",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"필수교육\n강의난이도",	Type:"Combo",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"eduLevel",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			
			{Header:"담당자사번",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:1,	SaveName:"mngSabun",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},	
<c:choose>
	<c:when test="${ssnGrpCd == '10' || ssnGrpCd == '15'}">
			{Header:"담당자성명",			Type:"PopupEdit",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"mngName",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1},	
	</c:when>
	<c:otherwise>
			{Header:"담당자성명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"mngName",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},	
	</c:otherwise>
</c:choose>
			{Header:"담당자소속",			Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:1,	SaveName:"mngOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},	
			{Header:"담당자연락처",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"mngTelNo",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},	
			
			{Header:"필수여부",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"mandatoryYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"비고",				Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },

			//Hidden
			{Header:"Hidden", Hidden:1, SaveName:"fileSeq"},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		sheet1.SetImageList(0,	"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(1,	"${ctx}/common/images/icon/icon_file.png");
		
		sheet1.SetColProperty("inOutType", 		{ComboText:"|"+codeLists["L20020"][0], ComboCode:"|"+codeLists["L20020"][1]} );// L20020 사내/외 구분
		sheet1.SetColProperty("eduBranchCd", 	{ComboText:"|"+codeLists["L10010"][0], ComboCode:"|"+codeLists["L10010"][1]} );// L10010 교육구분코드
		sheet1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+codeLists["L10015"][0], ComboCode:"|"+codeLists["L10015"][1]} );// L10015 교육분류코드
		sheet1.SetColProperty("eduMethodCd", 	{ComboText:"|"+codeLists["L10050"][0], ComboCode:"|"+codeLists["L10050"][1]} );// L10050 교육시행방법코드
		sheet1.SetColProperty("eduStatusCd", 	{ComboText:"|"+codeLists["L10170"][0], ComboCode:"|"+codeLists["L10170"][1]} );// L10170 교육과정상태코드
		sheet1.SetColProperty("foreignCd", 		{ComboText:"|"+codeLists["H20300"][0], ComboCode:"|"+codeLists["H20300"][1]} );// H20300 외국어종류
		sheet1.SetColProperty("eduLevel", 		{ComboText:"|"+codeLists["L10090"][0], ComboCode:"|"+codeLists["L10090"][1]} );// L10090 강의난이도
		
		$("#searchInOutType").html(strOptionAll+codeLists["L20020"][2]);
		$("#searchEduBranchCd").html(strOptionAll+codeLists["L10010"][2]);
		$("#searchEduMBranchCd").html(strOptionAll+codeLists["L10015"][2]);
		$("#searchEduMethodCd").html(strOptionAll+codeLists["L10050"][2]);
		$("#searchEduStatusCd").html(strOptionAll+codeLists["L10170"][2]);
		$("#searchEduLevel").html(strOptionAll+codeLists["L10090"][2]);
	}

	//교육회차 Sheet
	function init_sheet2(){

		var initdata = {};
		initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",		Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",		Align:"Center",		ColMerge:0,		SaveName:"sNo"},	
			{Header:"삭제|삭제",				Type:"${sDelTy}",		Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",		Align:"Center",		ColMerge:0,		SaveName:"sDelete",		Sort:0},	
			{Header:"상태|상태",				Type:"${sSttTy}",		Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",		Align:"Center",		ColMerge:0,		SaveName:"sStatus",		Sort:0},
			
			{Header:"세부\n내역|세부\n내역",		Type:"Image",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:1,	SaveName:"selectImg",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	Cursor:"Pointer"},	
			{Header:"강사\n내역|강사\n내역",		Type:"Image",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:1,	SaveName:"lecturerDetail",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	Cursor:"Pointer"},	
			{Header:"회차명|회차명",			Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:1,	SaveName:"eduEventNm",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
			{Header:"회차상태|회차상태",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduEvtStatusCd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"교육기간|시작일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduSYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, EndDateCol:"eduEYmd"},
			{Header:"교육기간|종료일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduEYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, StartDateCol:"eduSYmd"},
			{Header:"교육기간|시작시간",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduSHm",			KeyField:0,	CalcLogic:"",	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5},	
			{Header:"교육기간|종료시간",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduEHm",			KeyField:0,	CalcLogic:"",	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5},	
			{Header:"교육기간|총 일수",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduDay",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3},	
			{Header:"교육기간|총 시간",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"eduHour",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3},	
			{Header:"교육신청|신청일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"applSYmd",		KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, EndDateCol:"applEYmd"},
			{Header:"교육신청|마감일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"applEYmd",		KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, StartDateCol:"applSYmd"},
			{Header:"교육장소|교육장소",			Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:1,	SaveName:"eduPlace",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
			{Header:"수강인원\n(명)|수강인원\n(명)",
											Type:"Int",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"maxPerson",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3},	
			{Header:"결과보고\nSKIP여부|결과보고\nSKIP여부", 		
											Type:"CheckBox",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"resultAppSkipYn",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,		TrueValue:"Y",	FalseValue:"N",		HeaderCheck:1},	
			{Header:"만족도조사|항목등록",		Type:"Image",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"temp1",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	Cursor:"Pointer"},	
			{Header:"만족도조사|SKIP여부", 		Type:"CheckBox",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"eduSatiSkipYn",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,		TrueValue:"Y",	FalseValue:"N",		HeaderCheck:1},	
			{Header:"교육비|통화단위",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"currencyCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"교육비|교육비용",			Type:"Int",			Hidden:1,	Width:100,	Align:"Right",	ColMerge:1,	SaveName:"perExpenseMon",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"교육비|실교육비",			Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:1,	SaveName:"realExpenseMon",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"교육비|고용보험적용여부",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"laborApplyYn",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},	
			{Header:"교육비|환급금액",			Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:1,	SaveName:"laborMon",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			
			{Header:"보상종류|보상종류",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"eduRewardCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"보상내역|보상내역",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"eduRewardCnt",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},	
			{Header:"비고|비고",				Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"evtNote",			KeyField:0,					Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},	

			//Hidden
			{Header:"Hidden", Hidden:1, SaveName:"eduSeq"},
			{Header:"Hidden", Hidden:1, SaveName:"eduEventSeq"},
			{Header:"Hidden", Hidden:1, SaveName:"eduCourseNm"},
			
		];IBS_InitSheet(sheet2,	initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetImageList(0,	"${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetImageList(1,	"${ctx}/common/images/icon/icon_o.png");
		sheet2.SetImageList(2,	"${ctx}/common/images/icon/icon_x.png");
		
		sheet2.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		
		sheet2.SetUseDefaultTime(0); //디폴트 시간 입력 여부 
		sheet2.SetColProperty("eduEvtStatusCd", {ComboText:"|"+codeLists["L10190"][0], ComboCode:"|"+codeLists["L10190"][1]} );// L10190 회차상태
		sheet2.SetColProperty("currencyCd", 	{ComboText:codeLists["S10030"][0], ComboCode:codeLists["S10030"][1]} );// S10030 통화단위
		sheet2.SetColProperty("eduRewardCd", 	{ComboText:"|"+codeLists["L10110"][0], ComboCode:"|"+codeLists["L10110"][1]} );// L10110 보상종류
		sheet2.SetColProperty("laborApplyYn",	{ComboText:"NO|YES", ComboCode:"N|Y"} );
		
		
	}


	//---------------------------------------------------------------------------------------------------------------
	//Sheet1 Actionx
	//---------------------------------------------------------------------------------------------------------------
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
				sheet1.DoSearch( "${ctx}/EduCourseMgr.do?cmd=getEduCourseMgrList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/EduCourseMgr.do?cmd=saveEduCourseMgrSheet", $("#sheet1Form").serialize());
				break;
			case "InsertPop":
				var args = new Array(3);
				args["eduSeq"]      = "";
				args["eduEventSeq"] = "";
				args["regType"] = "I";
				eduCourseMgrPopup(args);
				break;
			case "Insert":
				var Row = sheet1.DataInsert(0);
				sheet1.SelectCell(Row, "eduCourseNm");
				
				sheet1.SetCellValue(Row, "eduStatusCd", "10030");
				sheet1.SetCellValue(Row, "mngSabun", "${ssnSabun}");
				sheet1.SetCellValue(Row, "mngName", "${ssnName}");
				sheet1.SetCellValue(Row, "mngOrgNm", "${ssnOrgNm}");
				sheet1.SetCellValue(Row, "mngTelNo", ssnTelNo);
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "eduSeq", "");
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
				var downcol = "";
				var stCol = sheet1.SaveNameCol("eduSeq"); //과정코드부터 시작

				for (var i = stCol ; i<=sheet1.LastCol() ; i++){
					var saveNm = sheet1.ColSaveName(i);
					if (sheet1.GetColHidden(i) == 0 || saveNm =="eduOrgCd" || saveNm =="jobCd" ) downcol += "|" + saveNm;
				}
				
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:downcol});

				break;
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	//Sheet2 Action
	//---------------------------------------------------------------------------------------------------------------

	function chkInVal() {
		// 시작일자와 종료일자 체크
		for (var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++) {
			if (sheet2.GetCellValue(i, "sStatus") == "I" || sheet2.GetCellValue(i, "sStatus") == "U") {
				if (sheet2.GetCellValue(i, "eduSYmd") != null && sheet2.GetCellValue(i, "eduEYmd") != "") {
					var sdate = sheet2.GetCellValue(i, "eduSYmd");
					var edate = sheet2.GetCellValue(i, "eduEYmd");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='교육기간 시작일자가 종료일자보다 큽니다.'/>");
						sheet2.SelectCell(i, "eduEYmd");
						return false;
					}
				}
			}

			if (sheet2.GetCellValue(i, "sStatus") == "I" || sheet2.GetCellValue(i, "sStatus") == "U") {
				if (sheet2.GetCellValue(i, "applSYmd") != null && sheet2.GetCellValue(i, "applEYmd") != "") {
					var sdate = sheet2.GetCellValue(i, "applSYmd");
					var edate = sheet2.GetCellValue(i, "applEYmd");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='교육신청 신청일이 마감일보다 큽니다.'/>");
						sheet2.SelectCell(i, "applEYmd");
						return false;
					}
				}
			}
		}
		return true;
	}

	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/EduCourseMgr.do?cmd=getEduEventMgrList", $("#sheet2Form").serialize() );
				break;
			case "Save":
				if(!chkInVal()){break;}
				IBS_SaveName(document.sheet2Form,sheet2);
				sheet2.DoSave( "${ctx}/EduCourseMgr.do?cmd=saveEduEventMgrSheet", $("#sheet2Form").serialize());
				break;
			case "InsertPop":
				if( sheet1.GetSelectRow() <  sheet1.HeaderRows() ) {
					alert("교육과정을 선택 해주세요.");
					return;
				}
				var args = new Array(3);
				args["eduSeq"] 		= sheet1.GetCellValue(sheet1.GetSelectRow(), "eduSeq");
				args["eduEventSeq"] = "";
				args["regType"] = "I";
				eduCourseMgrPopup(args);
				break;
			case "Insert":
				if( sheet1.GetSelectRow() <  sheet1.HeaderRows() ) {
					alert("교육과정을 선택 해주세요.");
					return;
				}
				var Row = sheet2.DataInsert(0);
				sheet2.SetCellValue(Row,"eduSeq",sheet1.GetCellValue(sheet1.GetSelectRow(), "eduSeq"));
				sheet2.SelectCell(Row, "eduEventNm");
				break;
			case "Copy":
				var row = sheet2.DataCopy();
				sheet2.SetCellValue(row, "eduEventSeq", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
				break;

			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet2.LoadExcel(params);
				break;
			case "DownTemplate":
				// 양식다운로드
				var downcol = "";
				var stCol = sheet2.SaveNameCol("eduEventNm"); //회차명부터 시작

				for (var i = stCol ; i<=sheet2.LastCol() ; i++){
					var saveNm = sheet2.ColSaveName(i);
					if (sheet2.GetColHidden(i) == 0 || saveNm == "mngSabun") downcol += "|" + saveNm;
				}
				
				sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:downcol});

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

	// 셀 선택 시 
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			/*
			var sRow = sheet2.FindStatusRow("I|U|D");
			if ( sRow != "" ) {
				alert("입력 수정 중인 데이터가 있습니다.");
				return;
			}*/
			if( sheet1.GetCellValue(NewRow, "sStatus") == "I" ){
				sheet2.RemoveAll();
			}else if( OldRow != NewRow && !$("#searchEduAll").is(":checked") ){
				$("#searchEduAll").change();
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	// 셀 변경 시 
	function sheet1_OnChange(Row, Col, Value) {
		try {/*
			if (sheet1.ColSaveName(Col) == "eduBranchCd") {
				var searchNote1 = sheet1.GetCellValue(Row, Col);
				if (searchNote1 == "")
					searchNote1 = " ";
				var eduMBranchCdList = convCode(ajaxCall( "${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getComCodeNoteList&searchGrcodeCd=L10015&searchUseYn=Y&searchNote1=" + searchNote1, false).codeList, "");
				if (!eduMBranchCdList)
					sheet1.CellComboItem(Row, "eduMBranchCd", { "ComboCode" : "|", "ComboText" : "|" });
				else
					sheet1.CellComboItem(Row, "eduMBranchCd", { "ComboCode" : "|" + eduMBranchCdList[1], "ComboText" : "|" + eduMBranchCdList[0] });
			}*/
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}


	// 셀 팝업 클릭 시
	function sheet1_OnPopupClick(Row, Col) {
		try {

			if( Row < sheet1.HeaderRows() ) return;

			if (sheet1.ColSaveName(Col) == "eduOrgNm") {  //교육기관 선택
				if (!isPopup()) {  return; }

				gPRow = Row;
				pGubun = "eduOrgPopup";
				doSearchEduOrgNm(gPRow, pGubun);
				
			}else if (sheet1.ColSaveName(Col) == "jobNm") {  //관련직무
				if (!isPopup()) {  return; }
				gPRow = Row;
				pGubun = "jobPopup";

				var layer = new window.top.document.LayerModal({
					id : 'jobPopupLayer'
					, url : "${ctx}/Popup.do?cmd=jobPopup&authPg=${authPg}"
					, parameters: {}
					, width : 740
					, height : 720
					, title : "직무 리스트 조회"
					, trigger :[
						{
							name : 'jobPopupTrigger'
							, callback : function(rv){
								sheet1.SetCellValue(gPRow, "jobCd", rv.jobCd);
								sheet1.SetCellValue(gPRow, "jobNm", rv.jobNm);
							}
						}
					]
				});
				layer.show();

				<%--openPopup("${ctx}/Popup.do?cmd=jobPopup", "", "840", "520");--%>
<c:if test="${ssnGrpCd == '10' || ssnGrpCd == '15'}">
			}else if (sheet1.ColSaveName(Col) == "mngName") {  //교육담당자
				if (!isPopup()) { return;}

				gPRow = Row;
				pGubun = "employeePopup";

				let layerModal = new window.top.document.LayerModal({
					id : 'employeeLayer'
					, url : '/Popup.do?cmd=viewEmployeeLayer'
					, parameters : {}
					, width : 840
					, height : 520
					, title : '사원조회'
					, trigger :[
						{
							name : 'employeeTrigger'
							, callback : function(rv){
								sheet1.SetCellValue(gPRow, "mngName", rv.name);
								sheet1.SetCellValue(gPRow, "mngSabun", rv.sabun);
								sheet1.SetCellValue(gPRow, "mngOrgNm", rv.orgNm);
								sheet1.SetCellValue(gPRow, "mngTelNo", rv.officeTel);
							}
						}
					]
				});
				layerModal.show();
				<%--openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "840", "520");--%>
</c:if>				

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

				gPRow = Row;
				pGubun = "eduMgrComptyLayer";

				let url = '/EduCourseMgr.do?cmd=viewEduMgrComptyLayer';
				let p = {
					eduSeq: sheet1.GetCellValue(Row, "eduSeq"),
					eduCourseNm: sheet1.GetCellValue(Row, "eduCourseNm"),
					authPg: 'A'
				}

				let eduMgrComptyLayer = new window.top.document.LayerModal({
					id: 'eduMgrComptyLayer',
					url: url,
					parameters: p,
					width: 800,
					height: 815,
					title: '교육과정 관련역량',
				});
				eduMgrComptyLayer.show();

			} else if (sheet1.ColSaveName(Col) == "fileImg") {  //첨부파일
				if (!isPopup()) {  return; }
			
				gPRow = Row;
				pGubun = "fileMgrPopup";

				let layerModal = new window.top.document.LayerModal({
					id : 'fileMgrLayer'
					, url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&uploadType=eduCourse&authPg=${authPg}'
					, parameters : {
						fileSeq : sheet1.GetCellValue(Row,"fileSeq"),
						fileInfo: getFileList(sheet1.GetCellValue(Row,"fileSeq")) // 파일 목록 동기화 처리를 위함
					}
					, width : 740
					, height : 420
					, title : '파일 업로드'
					, trigger :[
						{
							name : 'fileMgrTrigger'
							, callback : function(result){
								addFileList(sheet1, Row, result); // 작업한 파일 목록 업데이트
								sheet1.SetCellValue(gPRow, "fileSeq", result["fileSeq"]);
							}
						}
					]
				});
				layerModal.show();

			}

		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭 시
	function sheet2_OnClick(Row, Col, Value) {
		try {
			if( Row < sheet2.HeaderRows() ) return;
			
			var saveName = sheet2.ColSaveName(Col);
			
			if (saveName == "selectImg" ) { // 세부내역

				if ( sheet2.FindStatusRow("I|U|D") != "" ) {
					alert("입력 또는 수정중인 항목이 존재합니다. 저장 먼저 해주세요.");
					return;
				}

				var args = new Array(3);
				args["eduSeq"] 		= sheet2.GetCellValue(Row, "eduSeq");
				args["eduEventSeq"] = sheet2.GetCellValue(Row, "eduEventSeq");
				args["regType"] = "U";
				eduCourseMgrPopup(args);
			}else if (saveName == "lecturerDetail" ) { //강사내역

				if ( sheet2.FindStatusRow("I|U|D") != "" ) {
					alert("입력 또는 수정중인 항목이 존재합니다. 저장 먼저 해주세요.");
					return;
				}
			
				if (!isPopup()) { return; }

				var args = new Array();
				args["eduSeq"] 		= sheet2.GetCellValue(Row, "eduSeq");
				args["eduCourseNm"] = sheet2.GetCellValue(Row, "eduCourseNm");
				args["eduEventSeq"] = sheet2.GetCellValue(Row, "eduEventSeq");
				args["eduEventNm"] 	= sheet2.GetCellValue(Row, "eduEventNm");

				gPRow = Row;
				pGubun = "viewEduEventLecturerPopup";

				let modalLayer = new window.top.document.LayerModal({
					id : 'eduEventLecturerLayer'
					, url : "${ctx}/Popup.do?cmd=viewEduEventLecturerLayer&authPg=${authPg}"
					, parameters: args
					, width : 800
					, height : 550
					, title : "강사내역"
					, trigger :[
						{
							name : 'eduEventLecturerLayerTrigger'
							, callback : function(rv){
							}
						}
					]
				});
				modalLayer.show();

			}else if (sheet2.ColSaveName(Col) == "temp1") { //만족도항목관리

				if ( sheet2.FindStatusRow("I|U|D") != "" ) {
					alert("입력 또는 수정중인 항목이 존재합니다. 저장 먼저 해주세요.");
					return;
				}
				if (!isPopup()) { return; }

				var args = new Array();
				args["eduSeq"] 		= sheet2.GetCellValue(Row, "eduSeq");
				args["eduCourseNm"] = sheet2.GetCellValue(Row, "eduCourseNm");
				args["eduEventSeq"] = sheet2.GetCellValue(Row, "eduEventSeq");
				args["eduEventNm"] 	= sheet2.GetCellValue(Row, "eduEventNm");

				let modalLayer = new window.top.document.LayerModal({
					id : 'eduServeryEventMgrLayer'
					, url : "${ctx}/Popup.do?cmd=viewEduServeryEventMgrLayer&authPg=${authPg}"
					, parameters: args
					, width : 900
					, height : 600
					, title : "교육만족도항목관리"
					, trigger :[
						{
							name : 'eduServeryEventMgrLayerTrigger'
							, callback : function(rv){
							}
						}
					]
				});
				modalLayer.show();
			}

		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	// 엑셀업로드 후 저장 처리
	function sheet2_OnLoadExcel(result) {
		try {
			for(var i = sheet2.HeaderRows(); i < sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
				sheet2.SetCellValue(i, "eduSeq", $("#searchEduSeq").val(), 0 );
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	//---------------------------------------------------------------------------------------------------------------
	// 팝업 콜백 함수.
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(rv) {

		if (pGubun == "eduMgrPopup") {  //교육상세 팝업
			
			doAction1("Search");
			
		} else if (pGubun == "searchEduOrgPopup") { // 교육기관 팝업
			$("#searchEduOrgNm").val( rv["eduOrgNm"] );

		} else if (pGubun == "employeePopup") {
			sheet1.SetCellValue(gPRow, "mngName", rv["name"]);
			sheet1.SetCellValue(gPRow, "mngSabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "mngOrgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "mngTelNo", rv["officeTel"]);
			

		} else if (pGubun == "eduOrgPopup") { // 교육기관 팝업
			sheet1.SetCellValue(gPRow, "eduOrgCd", rv["eduOrgCd"]);
			sheet1.SetCellValue(gPRow, "eduOrgNm", rv["eduOrgNm"]);

		} else if (pGubun == "jobPopup") { // 관련직무 팝업
			sheet1.SetCellValue(gPRow, "jobCd", rv["jobCd"]);
			sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"]);
			
		}
	}
	
	
	//---------------------------------------------------------------------------------------------------------------
	// 교육상세 팝업
	//---------------------------------------------------------------------------------------------------------------
	function eduCourseMgrPopup(args) {
		if (!isPopup()) {
			return;
		}

		var sRow1 = sheet1.FindStatusRow("I|U|D");
		var sRow2 = sheet2.FindStatusRow("I|U|D");
		if ( sRow1 != "" || sRow2 != "" ) {
			alert("입력 또는 수정중인 항목이 존재합니다. 저장 먼저 해주세요.");
			return;
		}

		gPRow = -1;
		pGubun = "eduMgrPopup";

		let url = '/EduCourseMgr.do?cmd=viewEduMgrLayer&authPg=${authPg}';
		let p = {
			eduSeq: args["eduSeq"],
			eduEventSeq: args["eduEventSeq"],
			regType: args["regType"]
		}
		let eduMgrLayer = new window.top.document.LayerModal({
			id: 'eduMgrLayer',
			url: url,
			parameters: p,
			width: 1000,
			height: 1000,
			title: '교육과정 세부내역',
			trigger :[
				{
					name : 'eduMgrLayerTrigger',
					callback : function(returnValue){
						getReturnValue(returnValue);
					}
				}
			]
		});

		eduMgrLayer.show();
	}

	//검색 - 교육기관 팝업
	function doSearchEduOrgNm(Row, Gubun) {
		if (!isPopup()) {
			return;
		}

		gPRow = Row;
		pGubun = Gubun;

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
					callback : function(returnValue){
						getReturnValue(returnValue);
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
				<a href="javascript:doSearchEduOrgNm('', 'searchEduOrgPopup');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				<a onclick="$('#searchEduOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
			</td>
			<th>시행방법</th>
			<td>
				<select id="searchEduMethodCd" name="searchEduMethodCd"></select>
			</td>
			<th>사내/외</th>
			<td>
				<select id="searchInOutType" name="searchInOutType"></select>
			</td>
			<th>필수교육 강의난이도</th>
			<td>
				<select id="searchEduLevel" name="searchEduLevel"></select>
			</td>
		</tr>
		<tr>
			<th>교육구분</th>
			<td>
				<select id="searchEduBranchCd" name="searchEduBranchCd"></select>
			</td>
			<th>교육분류</th>
			<td>
				<select id="searchEduMBranchCd" name="searchEduMBranchCd"></select>
			</td>
			<th>과정상태</th>
			<td>
				<select id="searchEduStatusCd" name="searchEduStatusCd"></select>
			</td>
			<th>담당자사번/성명</th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="button">조회</a>
			</td>
		</tr>
		</table>	
	</div>
	<!-- 조회조건 끝 -->
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">교육과정관리</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('DownTemplate')"	class="btn outline-gray authA">양식다운로드</a>
					<a href="javascript:doAction1('LoadExcel')"		class="btn outline-gray authA">엑셀업로드</a>
					<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save')" 			class="btn soft authA">저장</a>
					<a href="javascript:doAction2('InsertPop')" 	class="btn filled authA">회차등록</a>
					<a href="javascript:doAction1('InsertPop')" 	class="btn filled authA">과정등록</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
	
	<form id="sheet2Form" name="sheet2Form" >
		<input type="hidden" id="searchEduSeq" name="searchEduSeq" />
		<div class="sheet_search sheet_search_s outer">
			<table>
			<tr>
				<th>과정명</th>
				<td>
					<input type="text" id="spanEduCourseNm" name="spanEduCourseNm" class="text w250 readonly" readonly />
				</td>
				<th>전체과정</th>
				<td>
					<input type="checkbox" id="searchEduAll" name="searchEduAll" class="checkbox" value="Y" />
				</td>
				<th>교육시작일</th>
				<td>
					<input id="searchEduSYmd" name="searchEduSYmd" type="text" size="10" class="date2" value=""/>
					~ <input id="searchEduEYmd" name="searchEduEYmd" type="text" size="10" class="date2" value=""/>
				</td>
				<td> <btn:a href="javascript:doAction2('Search');" css="btn dark" mid='search' mdef="조회"/> </td>
			</tr>
			</table>
		</div>
	</form>
	<div class="">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">교육회차관리</li>
				<li class="btn">
					<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray">다운로드</a>
					<a href="javascript:doAction2('DownTemplate')"	class="btn outline-gray authA">양식다운로드</a>
					<a href="javascript:doAction2('LoadExcel')"		class="btn outline-gray authA">엑셀업로드</a>
					<a href="javascript:doAction2('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction2('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction2('Save')" 			class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
	
	
</div>
</body>
</html>
