<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		var initdata = {};
		initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",					Type:"${sNoTy}",		Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",		Align:"Center",		ColMerge:0,		SaveName:"sNo"},	
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",					Type:"${sDelTy}",		Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",		Align:"Center",		ColMerge:0,		SaveName:"sDelete",		Sort:0},	
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",					Type:"${sSttTy}",		Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",		Align:"Center",		ColMerge:0,		SaveName:"sStatus",		Sort:0},
			
			{Header:"<sht:txt mid='eduSeqV4' mdef='과정순번|과정순번'/>",				Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:1,	SaveName:"eduSeq",			KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},	
			{Header:"<sht:txt mid='eduEventSeqV2' mdef='회차순번|회차순번'/>",				Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:1,	SaveName:"eduEventSeq",		KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},	

			{Header:"<sht:txt mid='detail' mdef='세부\n내역|세부\n내역'/>",			Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"selectImg",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},	
			{Header:"<sht:txt mid='lecturerDetail' mdef='강사\n내역|강사\n내역'/>",			Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"lecturerDetail",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},	
			{Header:"만족도항목관리|만족도항목관리",	Type:"Image",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"temp1",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},	
			{Header:"<sht:txt mid='eduCourseNmV2' mdef='과정명|과정명'/>",				Type:"Popup",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:1,	SaveName:"eduCourseNm",		KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},	
			{Header:"<sht:txt mid='eduEventNmV2' mdef='회차명|회차명'/>",				Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:1,	SaveName:"eduEventNm",		KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},	
			{Header:"<sht:txt mid='eduStatusCdV2' mdef='회차상태|회차상태'/>",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduEvtStatusCd",		KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	

			{Header:"만족도조사\r\nskip여부|만족도조사\r\nskip여부",	Type:"CheckBox",		Hidden:0,		Width:100,		Align:"Center",		ColMerge:0,		SaveName:"eduSatiSkipYn",		KeyField:0,		Format:"",				PointCount:0,		UpdateEdit:1,		InsertEdit:1,		EditLen:1,		TrueValue:"Y",	FalseValue:"N",		HeaderCheck:1},	

			{Header:"<sht:txt mid='eduBranchCdV1' mdef='교육구분|교육구분'/>",				Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:1,	SaveName:"eduBranchNm",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},	
			{Header:"<sht:txt mid='eduMBranchCdV2' mdef='교육분류|교육분류'/>",				Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:1,	SaveName:"eduMBranchNm",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},	
			{Header:"<sht:txt mid='eduOrgCdV2' mdef='교육기관코드|교육기관코드'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:1,	SaveName:"eduOrgCd",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"<sht:txt mid='eduOrgNmV2' mdef='교육기관|교육기관'/>",				Type:"Popup",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:1,	SaveName:"eduOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
			{Header:"<sht:txt mid='eduPlaceV2' mdef='교육장소|교육장소'/>",				Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:1,	SaveName:"eduPlace",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
			{Header:"<sht:txt mid='eduDayV2' mdef='교육기간|일'/>",					Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"eduDay",			KeyField:0,	CalcLogic:"",	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3},	
			{Header:"<sht:txt mid='eduHourV3' mdef='교육기간|시간'/>",				Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:1,	SaveName:"eduHour",			KeyField:0,	CalcLogic:"",	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3},	
			{Header:"<sht:txt mid='eduSYmdV3' mdef='교육기간|시작일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduSYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"<sht:txt mid='eduSHmV1' mdef='교육기간|시작시간'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduSHm",			KeyField:0,	CalcLogic:"",	Format:"Hm",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5},	
			{Header:"<sht:txt mid='eduEYmdV3' mdef='교육기간|종료일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"eduEYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"<sht:txt mid='eduEHmV1' mdef='교육기간|종료시간'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduEHm",			KeyField:0,	CalcLogic:"",	Format:"Hm",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5},	
			{Header:"<sht:txt mid='applSYmdV1' mdef='교육신청|신청일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"applSYmd",		KeyField:1,	CalcLogic:"",	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"<sht:txt mid='applEYmdV1' mdef='교육신청|마감일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"applEYmd",		KeyField:1,	CalcLogic:"",	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"<sht:txt mid='maxPersonV2' mdef='수강인원|수강인원'/>",				Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:1,	SaveName:"maxPerson",		KeyField:0,	CalcLogic:"",	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3},	
			{Header:"<sht:txt mid='currencyCdV2' mdef='교육비|통화단위'/>",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"currencyCd",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"교육비|교육비용",				Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:1,	SaveName:"perExpenseMon",	KeyField:0,	CalcLogic:"",	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"<sht:txt mid='realExpenseMonV1' mdef='교육비|실교육비'/>",				Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:1,	SaveName:"realExpenseMon",	KeyField:0,	CalcLogic:"",	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"<sht:txt mid='laborApplyYnV2' mdef='교육비|고용보험적용여부'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"laborApplyYn",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},	
			{Header:"<sht:txt mid='laborMonV2' mdef='교육비|환급금액'/>",				Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:1,	SaveName:"laborMon",		KeyField:0,	CalcLogic:"",	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	

			{Header:"<sht:txt mid='chargeSabunV3' mdef='담당내역|담당자사번'/>",			Type:"Text",	Hidden:0,	Width:0,	Align:"Left",	ColMerge:1,	SaveName:"chargeSabun",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13},	
			{Header:"<sht:txt mid='chargeNameV4' mdef='담당내역|담당자'/>",				Type:"PopupEdit",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"chargeName",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},	
			{Header:"<sht:txt mid='orgCdV9' mdef='담당내역|소속코드'/>",				Type:"Text",	Hidden:0,	Width:0,	Align:"Left",	ColMerge:1,	SaveName:"orgCd",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
			{Header:"<sht:txt mid='orgNmV12' mdef='담당내역|담당소속'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"orgNm",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
			{Header:"<sht:txt mid='chargeTel' mdef='담당내역|연락처'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"telNo",			KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},	
			
			{Header:"<sht:txt mid='eduRewardCdV3' mdef='보상종류|보상종류'/>",				Type:"Combo",	Hidden:0,	Width:140,	Align:"Center",	ColMerge:1,	SaveName:"eduRewardCd",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},	
			{Header:"<sht:txt mid='eduRewardCntV3' mdef='보상내역|보상내역'/>",				Type:"Int",		Hidden:0,	Width:140,	Align:"Center",	ColMerge:1,	SaveName:"eduRewardCnt",	KeyField:0,	CalcLogic:"",	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20},	
			
			{Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",					Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,					Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},	
			{Header:"<sht:txt mid='fileSeqV4' mdef='FILE_SEQ|FILE_SEQ'/>",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"fileSeq",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},	
		];IBS_InitSheet(sheet1,	initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,	"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(1,	"${ctx}/common/images/icon/icon_o.png");
		sheet1.SetImageList(2,	"${ctx}/common/images/icon/icon_x.png");
		
		var list1 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10190"), "<tit:txt mid='103895' mdef='전체'/>"); 	//회차상태
		var list2 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S10030"), ""); 		//통화단위
		var list3 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10110"), ""); 		//

		var list4 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10050"), "<tit:txt mid='103895' mdef='전체'/>"); 	//시행방법
		var list5 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L20020"), "<tit:txt mid='103895' mdef='전체'/>"); 	//사내외구분
		var list6 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10010"), "<tit:txt mid='103895' mdef='전체'/>"); 	//교육체계구분 res2
		var list7 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10015"), "<tit:txt mid='103895' mdef='전체'/>"); 	//교육영역

		$("#searchEduBranchCd").html(list6[2]);
		$("#searchInOutType").html(list5[2]);
		$("#searchEduMethodCd").html(list4[2]);

		sheet1.SetColProperty("eduEvtStatusCd", {ComboText:"|"+list1[0], ComboCode:"|"+list1[1]} );
		sheet1.SetColProperty("currencyCd", 	{ComboText:"|"+list2[0], ComboCode:"|"+list2[1]} );
		sheet1.SetColProperty("eduRewardCd", 	{ComboText:"|"+list3[0], ComboCode:"|"+list3[1]} );
		sheet1.SetColProperty("laborApplyYn",	{ComboText:"YES|NO", ComboCode:"Y|N"} );

		//$("#searchEduStatusCd").html(list3[2]);
		//$("#searchEduMBranchCd").html(list8[2]);
		$("#searchEduEventStatus").html(list1[2]);
		//$("#searchEduEventStatus").val("10030");

		$("#searchEduCourseNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchEduOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchChargeName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchFiYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchEduEventNm").bind("keyup",function(event){
			//makeNumber(this,"A");
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		 $("#searchEduSYmd").datepicker2({startdate:"searchEduEYmd"});
			$("#searchEduEYmd").datepicker2({enddate:"searchEduSYmd"});

		sheet1.SetDataLinkMouse("selectImg", 1);
		sheet1.SetDataLinkMouse("lecturerDetail", 1);
		sheet1.SetDataLinkMouse("temp1", 1);
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});


	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			sheet1.DoSearch("${ctx}/EduEventMgr.do?cmd=getEduEventMgrList", $("#srchFrm").serialize());
			break;
		case "Save": //저장
			IBS_SaveName(document.srchFrm, sheet1);
			sheet1.DoSave("${ctx}/EduEventMgr.do?cmd=saveEduEventMgr", $("#srchFrm").serialize());
			break;

		case "Insert": //입력

			var Row = sheet1.DataInsert(0);
			eduEventMgrPopup(Row);
			break;

		case "Copy": //행복사

			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "eduEventSeq", "");
			sheet1.SetCellValue(Row, "languageCd", "");
			sheet1.SetCellValue(Row, "languageNm", "");
			eduEventMgrPopup(Row);
			//sheet1.SelectCell(Row, "eduEventNm");
			break;

		case "Clear": //Clear

			sheet1.RemoveAll();
			break;

		case "Down2Excel": //엑셀내려받기

			sheet1.Down2Excel({ DownCols : makeHiddenSkipCol(sheet1), SheetDesign : 1, Merge : 1 });
			break;

		case "LoadExcel": //엑셀업로드

			var params = {
				Mode : "HeaderMatch",
				WorkSheetNo : 1
			};
			sheet1.LoadExcel(params);
			break;
		case "Copy2": //회차복사
			if (sheet1.RowCount() > 0) {
				if (sheet1.GetCellValue(sheet1.GetSelectRow(), "sStatus") == "I") {
					alert("<msg:txt mid='alertEduEventMgr1' mdef='저장 후 회차복사 가능합니다.'/>");
					return;
				}
				CenterWin("/JSP/tra/basis/EduEventCreate_popup.jsp?eduSeq="
						+ sheet1.GetCellValue(sheet1.SetSelectRow(), "eduSeq")
						+ "&eduEventSeq="
						+ sheet1.GetCellValue(sheet1.SetSelectRow(), "eduEventSeq"), "EduEventCreate_popup",
						"scrollbars=no, status=no, width=400, height=200, top=0, left=0");
			}
			break;
		}
	}
	
	/**
	 * 상세내역 window open event
	 */
	function eduEventMgrPopup(Row) {
		if (!isPopup()) {
			return;
		}

		//EduCourseDetail.jsp
		var w = 1340;
		var h = 940;
		var url = "${ctx}/EduEventMgr.do?cmd=viewEduEventMgrPopup&authPg=${authPg}";
		var args = new Array();

		args["eduSeq"] = sheet1.GetCellValue(Row, "eduSeq");
		args["eduCourseNm"] = sheet1.GetCellValue(Row, "eduCourseNm");
		args["eduCourseSub"] = sheet1.GetCellValue(Row, "eduCourseSub");
		args["eduEventSeq"] = sheet1.GetCellValue(Row, "eduEventSeq");
		args["eduEventNm"] = sheet1.GetCellValue(Row, "eduEventNm");
		args["eduStatusCd"] = sheet1.GetCellValue(Row, "eduStatusCd");
		args["eduOrgCd"] = sheet1.GetCellValue(Row, "eduOrgCd");
		args["eduOrgNm"] = sheet1.GetCellValue(Row, "eduOrgNm");
		args["eduPlace"] = sheet1.GetCellValue(Row, "eduPlace");
		args["eduPlaceEtc"] = sheet1.GetCellValue(Row, "eduPlaceEtc");
		args["eduDay"] = sheet1.GetCellValue(Row, "eduDay");
		args["eduHour"] = sheet1.GetCellValue(Row, "eduHour");
		args["eduSYmd"] = sheet1.GetCellText(Row, "eduSYmd");
		args["eduSHm"] = sheet1.GetCellText(Row, "eduSHm");
		args["eduEYmd"] = sheet1.GetCellText(Row, "eduEYmd");
		args["eduEHm"] = sheet1.GetCellText(Row, "eduEHm");
		args["applSYmd"] = sheet1.GetCellText(Row, "applSYmd");
		args["applEYmd"] = sheet1.GetCellText(Row, "applEYmd");
		args["minPerson"] = sheet1.GetCellValue(Row, "minPerson");
		args["maxPerson"] = sheet1.GetCellValue(Row, "maxPerson");
		args["lecturerCost"] = sheet1.GetCellValue(Row, "lecturerCost"); /*	추가	*/
		args["establishmentCost"] = sheet1.GetCellValue(Row, "establishmentCost"); /*	추가	*/
		args["foodCost"] = sheet1.GetCellValue(Row, "foodCost"); /*	추가	*/
		args["transpCost"] = sheet1.GetCellValue(Row, "transpCost"); /*	추가	*/
		args["currencyCd"] = sheet1.GetCellValue(Row, "currencyCd");
		args["perExpenseMon"] = sheet1.GetCellValue(Row, "perExpenseMon");
		args["totExpenseMon"] = sheet1.GetCellValue(Row, "totExpenseMon");
		args["laborApplyYn"] = sheet1.GetCellValue(Row, "laborApplyYn");
		args["laborMon"] = sheet1.GetCellValue(Row, "laborMon");
		args["realExpenseMon"] = sheet1.GetCellValue(Row, "realExpenseMon");
		args["chargeSabun"] = sheet1.GetCellValue(Row, "chargeSabun");
		args["chargeName"] = sheet1.GetCellValue(Row, "chargeName");
		args["orgCd"] = sheet1.GetCellValue(Row, "orgCd");
		args["orgNm"] = sheet1.GetCellValue(Row, "orgNm");
		args["telNo"] = sheet1.GetCellValue(Row, "telNo");
		args["eduRewardCd"] = sheet1.GetCellValue(Row, "eduRewardCd");
		args["eduRewardCnt"] = sheet1.GetCellValue(Row, "eduRewardCnt");
		args["sStatus"] = sheet1.GetCellValue(Row, "sStatus");
		args["fileSeq"] = sheet1.GetCellValue(Row, "fileSeq");

		gPRow = Row;
		pGubun = "eduEventMgrPopup";

		openPopup(url, args, w, h);
	}

	function findEmpPopup() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "searchEmployeePopup";

		openPopup("/Popup.do?cmd=employeePopup", "", "840", "520");
	}
	
	function sheet1_OnClick(Row, Col, Value) {
		try {

			if (sheet1.ColSaveName(Col) == "selectImg"
					&& Row >= sheet1.HeaderRows()) {
				eduEventMgrPopup(Row);
			}

			if (sheet1.ColSaveName(Col) == "lecturerDetail"
					&& Row >= sheet1.HeaderRows()) {
				if (!isPopup()) {
					return;
				}

				var cnt = 0;
				for (var r = sheet1.HeaderRows(); r < sheet1.RowCount()
						+ sheet1.HeaderRows(); r++) {
					if (sheet1.GetCellValue(r, "sStatus") != "R") {
						cnt = +1;
					}
				}
				if (cnt > 0) {
					alert("<msg:txt mid='alertInputAfterSaveV5' mdef='입력 또는 수정중인 항목이 존재합니다. 저장 후 이용해주세요.'/>");
					return;
				}
				var args = new Array();
				args["eduSeq"] = sheet1.GetCellValue(Row, "eduSeq");
				args["eduCourseNm"] = sheet1.GetCellValue(Row, "eduCourseNm");
				args["eduEventSeq"] = sheet1.GetCellValue(Row, "eduEventSeq");
				args["eduEventNm"] = sheet1.GetCellValue(Row, "eduEventNm");
				args["authPg"] = "A";

				gPRow = Row;
				pGubun = "viewEduEventLecturerPopup";

				openPopup("/EduEventMgr.do?cmd=viewEduEventLecturerPopup",
						args, "1000", "600");
			}

			if (sheet1.ColSaveName(Col) == "temp1"
					&& Row >= sheet1.HeaderRows()) {
				if (!isPopup()) {
					return;
				}

				var args = new Array();
				args["eduSeq"] = sheet1.GetCellValue(Row, "eduSeq");
				args["eduEventSeq"] = sheet1.GetCellValue(Row, "eduEventSeq");
				args["authPg"] = "A";

				let modalLayer = new window.top.document.LayerModal({
					id : 'eduServeryEventMgrLayer'
					, url : "${ctx}/EduServeryEventMgr.do?cmd=viewEduServeryEventMgrLayer&authPg=${authPg}"
					, parameters: args
					, width : 1000
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

	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				location.href = "/JSP/ErrorPage.jsp?errorMsg=" + ErrMsg;
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				alert(ErrMsg);
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col) {
		try {
			if (sheet1.ColSaveName(Col) == "eduCourseNm") {
				if (!isPopup()) {
					return;
				}

				gPRow = Row;
				pGubun = "eduCoursePopup";

				openPopup("/Popup.do?cmd=eduCoursePopup&authPg=R", "", "650",
						"520");
			}

			if (sheet1.ColSaveName(Col) == "eduOrgNm") {
				if (!isPopup()) {
					return;
				}

				gPRow = Row;
				pGubun = "eduOrgPopup";

				openPopup("/Popup.do?cmd=eduOrgPopup&authPg=R", "", "650",
						"520");
			}

			if (sheet1.ColSaveName(Col) == "orgNm") {
				if (!isPopup()) {
					return;
				}

				gPRow = Row;
				pGubun = "orgBasicPopup";

				openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740",
						"520");
			}

			if (sheet1.ColSaveName(Col) == "chargeName") {
				if (!isPopup()) {
					return;
				}

				gPRow = Row;
				pGubun = "employeePopup";

				openPopup("/Popup.do?cmd=employeePopup", "", "840", "520");
			}

			if (sheet1.ColSaveName(Col) == "languageNm") {
				lanuagePopup(Row, "sheet1", "ttra121", "languageCd",
						"languageNm", "eduEventNm");
			}

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	function sheet1_OnChange(Row, Col, Value){
		try {
			if ( sheet1.ColSaveName(Col) == "languageNm" ){
				if ( sheet1.GetCellValue( Row, Col ) == "" ){
					sheet1.SetCellValue( Row, "languageCd", "");
				}
			}
			
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnValidation(Row, Col, Value) {
		try {
			//ReadDataProperty (Row, Col, dpKeyField) == true : 팝업으로 선택될 컬럼이 입력필수 일 경우만 체크
			if (sheet1.ColSaveName(Col) == "chargeName"
					&& sheet1.GetCellEditable(Row, "chargeName") == true
					&& sheet1.GetCellValue(Row, "chargeName") == ""
					&& sheet1.GetCellProperty(Row, "chargeSabun", "KeyField") == true) {
				if (!isPopup()) {
					return;
				}

				alert("<msg:txt mid='alertNotPopupData' mdef='팝업 데이터가 선택되지 않았습니다.'/>");
				ValidateFail(true);
				sheet1.SelectCell(Row, "chargeName");

				gPRow = Row;
				pGubun = "employeePopup";

				openPopup("/Popup.do?cmd=employeePopup", args, "840", "520");
				return;
			}
		} catch (ex) {
			alert("OnValidation Event Error : " + ex);
		}
	}

	function doSearchEduOrgNm() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "searchEduOrgPopup";

		openPopup("/Popup.do?cmd=eduOrgPopup&authPg=R", "", "650", "520");
	}

	function doSearchEduCourseNm() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "searchEduCoursePopup";

		openPopup("/Popup.do?cmd=eduCoursePopup&authPg=R", "", "650", "520");
	}

	function doSearchEduMBranchNm() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "searchEduMBranchPopup";

		openPopup("/Popup.do?cmd=eduMBranchPopup&authPg=R", "", "650", "520");
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue + '}');

		if (pGubun == "eduEventMgrPopup") {
			sheet1.SetCellValue(gPRow, "eduSeq", rv["eduSeq"]);
			sheet1.SetCellValue(gPRow, "eduCourseNm", rv["eduCourseNm"]);
			sheet1.SetCellValue(gPRow, "eduCourseSub", rv["eduCourseSub"]);
			sheet1.SetCellValue(gPRow, "eduEventSeq", rv["eduEventSeq"]);
			sheet1.SetCellValue(gPRow, "eduEventNm", rv["eduEventNm"]);
			sheet1.SetCellValue(gPRow, "eduStatusCd", rv["eduStatusCd"]);
			sheet1.SetCellValue(gPRow, "eduOrgCd", rv["eduOrgCd"]);
			sheet1.SetCellValue(gPRow, "eduOrgNm", rv["eduOrgNm"]);
			sheet1.SetCellValue(gPRow, "eduPlace", rv["eduPlace"]);
			sheet1.SetCellValue(gPRow, "eduPlaceEtc", rv["eduPlaceEtc"]);
			sheet1.SetCellValue(gPRow, "eduDay", rv["eduDay"]);
			sheet1.SetCellValue(gPRow, "eduHour", rv["eduHour"]);
			sheet1.SetCellValue(gPRow, "eduSYmd", rv["eduSYmd"]);
			sheet1.SetCellValue(gPRow, "eduSHm", rv["eduSHm"]);
			sheet1.SetCellValue(gPRow, "eduEYmd", rv["eduEYmd"]);
			sheet1.SetCellValue(gPRow, "eduEHm", rv["eduEHm"]);
			sheet1.SetCellValue(gPRow, "applSYmd", rv["applSYmd"]);
			sheet1.SetCellValue(gPRow, "applEYmd", rv["applEYmd"]);
			sheet1.SetCellValue(gPRow, "minPerson", rv["minPerson"]);
			sheet1.SetCellValue(gPRow, "maxPerson", rv["maxPerson"]);
			sheet1.SetCellValue(gPRow, "lecturerCost", rv["lecturerCost"]);
			sheet1.SetCellValue(gPRow, "establishmentCost", rv["establishmentCost"]);
			sheet1.SetCellValue(gPRow, "foodCost", rv["foodCost"]);
			sheet1.SetCellValue(gPRow, "transpCost", rv["transpCost"]);
			sheet1.SetCellValue(gPRow, "currencyCd", rv["currencyCd"]);
			sheet1.SetCellValue(gPRow, "perExpenseMon", rv["perExpenseMon"]);
			sheet1.SetCellValue(gPRow, "totExpenseMon", rv["totExpenseMon"]);
			sheet1.SetCellValue(gPRow, "laborApplyYn", rv["laborApplyYn"]);
			sheet1.SetCellValue(gPRow, "laborMon", rv["laborMon"]);
			sheet1.SetCellValue(gPRow, "realExpenseMon", rv["realExpenseMon"]);
			sheet1.SetCellValue(gPRow, "chargeSabun", rv["chargeSabun"]);
			sheet1.SetCellValue(gPRow, "chargeName", rv["chargeName"]);
			sheet1.SetCellValue(gPRow, "orgCd", rv["orgCd"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "telNo", rv["telNo"]);
			sheet1.SetCellValue(gPRow, "eduRewardCd", rv["eduRewardCd"]);
			sheet1.SetCellValue(gPRow, "eduRewardCnt", rv["eduRewardCnt"]);
			sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);

		} else if (pGubun == "searchEmployeePopup") {
			$("#searchChargeName").val(rv["name"]);
			$("#searchChargeSabun").val(rv["sabun"]);
		} else if (pGubun == "eduCoursePopup") {
			sheet1.SetCellValue(gPRow, "eduCourseNm", rv["eduCourseNm"]);
			sheet1.SetCellValue(gPRow, "eduOrgCd", rv["eduOrgCd"]);
			sheet1.SetCellValue(gPRow, "eduOrgNm", rv["eduOrgNm"]);
		} else if (pGubun == "eduOrgPopup") {
			sheet1.SetCellValue(gPRow, "eduOrgCd", rv["eduOrgCd"]);
			sheet1.SetCellValue(gPRow, "eduOrgNm", rv["eduOrgNm"]);
		} else if (pGubun == "orgBasicPopup") {
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "orgCd", rv["orgCd"]);
		} else if (pGubun == "employeePopup") {
			sheet1.SetCellValue(gPRow, "chargeName", rv["name"]);
			sheet1.SetCellValue(gPRow, "chargeSabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "orgCd", rv["orgCd"]);
			sheet1.SetCellValue(gPRow, "telNo", rv["officeTel"]);
		} else if (pGubun == "searchEduOrgPopup") {
			//$("#eduOrgCd").val(rst["eduOrgCd"]);
			$("#searchEduOrgNm").val(rv["eduOrgNm"]);
		} else if (pGubun == "searchEduCoursePopup") {
			//$("#eduOrgCd").val(rst["eduOrgCd"]);
			$("#searchEduCourseNm").val(rv["eduCourseNm"]);
		} else if (pGubun == "searchEduMBranchPopup") {
			$("#searchEduMBranchNm").val(rv["eduMBranchNm"]);
			//$("#searchEduMBranchCd").val(rst["eduMBranchCd"]);
		}
		
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>과정명  </th>
						<td > <input id="searchEduCourseNm" name ="searchEduCourseNm" type="text" class="text w200" /> <a href="javascript:doSearchEduCourseNm();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> </td>
						<th>회차명 </th>
						<td> 
							<input id="searchEduEventSeq" name ="searchEduEventSeq" type="hidden" class="text w100" />
							<input id="searchEduEventNm" name ="searchEduEventNm" type="text" class="text w100" />
						</td>
						<th>회차상태 </th>
						<td> 
							 <select id="searchEduEventStatus" name="searchEduEventStatus">
							 </select>
						</td>
						<th>사내외구분</th>
						<td><select id="searchInOutType" name="searchInOutType"/></select></td>
						<th>시행방법 </th>
						<td>  <select id="searchEduMethodCd" name="searchEduMethodCd"> </select></td>
					</tr>
					<tr>
						<th><tit:txt mid='104497' mdef='시작일'/></th>
						<td><input id="searchEduSYmd" name="searchEduSYmd" type="text" size="10" class="date2" value=""/>
						~ <input id="searchEduEYmd" name="searchEduEYmd" type="text" size="10" class="date2" value=""/></td>
						<th>교육기관 </th>
						<td>  <input id="searchEduOrgNm" name ="searchEduOrgNm" type="text" class="text w100" /> <a href="javascript:doSearchEduOrgNm();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a></td>
						<th class="hide">담당자 </th>
						<td class="hide"> 
							 <input id="searchChargeSabun" name ="searchChargeSabun" type="hidden" class="" />
							 <input id="searchChargeName" name ="searchChargeName" type="text" class="text w100" /> <a href="javascript:findEmpPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> </td>
						<th>교육구분 </th>
						<td>  <select id="searchEduBranchCd" name="searchEduBranchCd"> </select></td>
						<th>교육분류 </th>
						<td> 
							 <input id="searchEduMBranchNm" name="searchEduMBranchNm" type="text" class="text w60" />
							 <a href="javascript:doSearchEduMBranchNm();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/></td>
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
							<li id="txt" class="txt"><tit:txt mid='eduEventMgr' mdef='교육회차관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
