<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/jquery/jquery.inputmask.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.inputmask.numeric.extensions.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	var mboTargetYn = "N";
	var compTargetYn = "N";

	var allClassCdList = null;			// 전체평가등급(P00001)

	var bLink = false;
	if ( "${map.searchAppraisalCd_sub}" != "" ) {
		bLink = true;
	}

	var hdnType = new Array();
	var updType = new Array();

	$(function() {
		//시트 컬럼 설정 값
		hdnType = [0,0,0,0]; updType = [1,0,0,0];

		if($("#searchAppSeqCd").val() == "0") {  //본인
			hdnType[0] = 0; hdnType[1] = 1; hdnType[2] = 1; hdnType[3] = 1;
			updType[0] = 1; updType[1] = 0; updType[2] = 0; updType[3] = 0;
			$("#btnCompetency").hide();
		} else if($("#searchAppSeqCd").val() == "1") { //1차
			hdnType[0] = 0; hdnType[1] = 0; hdnType[2] = 1; hdnType[3] = 1;
			updType[0] = 0; updType[1] = 1; updType[2] = 0; updType[3] = 0;
		} else if($("#searchAppSeqCd").val() == "2") { //2차
			hdnType[0] = 0; hdnType[1] = 0; hdnType[2] = 0; hdnType[3] = 1;
			updType[0] = 0; updType[1] = 0; updType[2] = 1; updType[3] = 0;
		} else if($("#searchAppSeqCd").val() == "6") { //3차
			hdnType[0] = 0; hdnType[1] = 0; hdnType[2] = 0; hdnType[3] = 0;
			updType[0] = 0; updType[1] = 0; updType[2] = 0; updType[3] = 1;
		}
		
		/* 무신사의 경우 추진실적만 등록하고 차수/목표별 평가는 실행하지 않음. */
		//hdnType[0] = 1;
		//hdnType[1] = 1;
		//hdnType[2] = 1;
	});

	$(function() {
		allClassCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), ""); // 전체평가등급(P00001)

		//TAB
		$("#tabs").tabs();
		$("#tabsIndex").val('0');

		// 조회조건 이벤트 등록
		$("#searchAppraisalCd").bind("change",function(event){
			setAppOrgCdCombo();
		});

		$("#searchAppOrgCd").bind("change",function(event){
			setAppEmployee();
		});

		if(bLink == true) {
			//성명,사번
			$("#searchAppraisalCd").val("${map.searchAppraisalCd_sub}");
			$("#searchAppraisalNm").val("${map.searchAppraisalNm_sub}");
			$("#searchAppOrgCd").val("${map.searchAppOrgCd_sub}");
			$("#searchAppOrgNm").val("${map.searchAppOrgNm_sub}");
			$("#searchAppSeqCd").val("${map.searchAppSeqCd}");
			$("#searchAppSabun").val("${map.searchAppSabun_sub}");
			$("#searchAppName").val("${map.searchAppName_sub}");
			$("#searchEvaSabun").val("${map.searchSabun_sub}");
			$("#searchName").val("${map.searchName_sub}");
			$("#searchKeyword").val("${map.searchName_sub}");

			$("#searchAppOrgCd").change();
		} else {
			//성명,사번
			$("#searchEvaSabun").val("${sessionScope.ssnSabun}");
			$("#searchName").val("${sessionScope.ssnName}");
			$("#searchKeyword").val("${sessionScope.ssnName}");

			//평가명
			var appraisalCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getAppraisalCdListSeqMbo2&" + $("#empForm").serialize(), false).codeList
					, "closeYn,appGradingMethod,note1,note2,note3,note4"
					, "");

			$("#searchAppraisalCd").html(appraisalCdList[2]);

			$("#searchAppraisalCd").change();
		}

		//직무만족도 라디오버튼
		/*var html_jobSatisfactionCd = "";
		var appSeqCdList = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00201",false).codeList;
		for (i = 0; i < appSeqCdList.length; i++) {
			html_jobSatisfactionCd += "<input type='radio' id='jobSatisfactionCd"+(i+1)+"' name='jobSatisfactionCd' value='"+appSeqCdList[i].code+"' >";
			html_jobSatisfactionCd += "<label for='jobSatisfactionCd"+(i+1)+"'>"+appSeqCdList[i].codeNm+"</label>";

		}
		$("#DIV_jobSatisfactionCd").html(html_jobSatisfactionCd);*/
	});


	// Sheet1 init (MBO)
	function init_sheet1(){
		if( $("#DIV_sheet1").html().length > 0 ) {
			doAction1("Search");
			return;
		}

		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"세부\n내역|세부\n내역",						Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, Cursor:"Pointer" },
			{Header:"순서|순서",								Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"구분|구분",								Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:1,	SaveName:"appIndexGubunNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"목표구분|목표구분",							Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mboType",			KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"목표구분|목표구분",							Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mboTypeNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"목표항목|목표항목",							Type:"Text",	Hidden:0,	Width:170,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1500,	MultiLineText:1, Wrap:1},

			{Header:"비중(%)|비중(%)",							Type:"AutoSum", Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"weight",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"NullInteger",	PointCount:2,	EditLen:10},
			{Header:"목표달성을 위한 핵심 요인|목표달성을 위한 핵심 요인",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"kpiNm",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000,	MultiLineText:1, Wrap:1},
			{Header:"달성목표(정량,최종)|달성목표(정량,최종)",		Type:"Text",	Hidden:0,	Width:170,	Align:"Left",	ColMerge:0,	SaveName:"formula",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1500,	MultiLineText:1, Wrap:1},
			{Header:"중점추진 Activity|중점추진 Activity",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"remark",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1500,	MultiLineText:1, Wrap:1},

			/*
			{Header:"추진일정|From",		Type:"Date",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"deadlineType",	KeyField:0,	Format:"Ym",	UpdateEdit:0,	InsertEdit:1 },
			{Header:"추진일정|To",		Type:"Date",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"deadlineTypeTo",	KeyField:0,	Format:"Ym",	UpdateEdit:0,	InsertEdit:1 },
			{Header:"측정기준|측정기준",	Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"baselineData",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:1500},

			{Header:"목표수준|S(100)",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"sGradeBase",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1, Wrap:1 },
			{Header:"목표수준|A(90)",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"aGradeBase",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1, Wrap:1 },
			{Header:"목표수준|B(80)",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"bGradeBase",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1, Wrap:1 },
			{Header:"목표수준|C(70)",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"cGradeBase",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1, Wrap:1 },
			{Header:"목표수준|D(60)",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"dGradeBase",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1, Wrap:1 },
			*/

			// 주의! 이 곳에서의 설정은 Sheet가 처음 로딩될 때만 적용이 되기 때문에 searchAppraisalCd 변경 등으로 인해 바뀌는 설정값 들은 적용이 되지 않는다.
			// 따라서 아래 hdnType, updType값으로 설정하는 사항들은 setSheetColHidden_sheet1 함수에서 최종 설정하므로 아래 Sheet 초기화 시 적용된 사항들은 무시된다.
			// 변경이 필요할 시에는 이곳에서 변경하지 말고 setSheetColHidden_sheet1 함수에서 변경해야 한다!
			{Header:"추진실적|추진실적",			Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"mboMidAppResult",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:2000,	MultiLineText:1, Wrap:1},
			{Header:"추진실적|추진실적",			Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"mboAppResult",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"",				PointCount:0,	EditLen:4000, MultiLineText:1, Wrap:1 },

			{Header:"본인평가|본인점수",			Type:"Int",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboAppSelfPoint",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"NullInteger",	PointCount:0,	EditLen:3},
			{Header:"본인평가|본인등급",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboSelfClassCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0},

			{Header:"1차평가|1차점수",			Type:"Int",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboApp1stPoint",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"NullInteger",	PointCount:0,	EditLen:3},
			{Header:"1차평가|1차등급",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mbo1stClassCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"1차평가|1차의견",			Type:"Text",	Hidden:1,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"mbo1stMemo",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"",				PointCount:0,	EditLen:4000, MultiLineText:1, Wrap:1 },

			{Header:"2차평가|2차점수",			Type:"Int",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboApp2ndPoint",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"NullInteger",	PointCount:0,	EditLen:3},
			{Header:"2차평가|2차등급",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mbo2ndClassCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"2차평가|2차의견",			Type:"Text",	Hidden:1,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"mbo2ndMemo",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"",				PointCount:0,	EditLen:4000, MultiLineText:1, Wrap:1 },

			{Header:"3차평가|3차점수",			Type:"Int",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mboApp3rdPoint",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"NullInteger",	PointCount:0,	EditLen:3},
			{Header:"3차평가|3차등급",			Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mbo3rdClassCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"3차평가|3차의견",			Type:"Text",	Hidden:1,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"mbo3rdMemo",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	Format:"",				PointCount:0,	EditLen:4000, MultiLineText:1, Wrap:1 },

			{Header:"평가ID|평가ID",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사번|사번",				Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속|평가소속",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"순번|순번",				Type:"Int",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"},
			{Header:"생성구분코드|생성구분코드",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mkGubunCd"},
			{Header:"지표구분|지표구분",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appIndexGubunCd"}
		];IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		sheet1.SetEditEnterBehavior("newline");
		sheet1.SetAutoSumPosition(1);
		sheet1.SetSumValue("sNo", "합계") ;
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //짝수번째 데이터 행의 기본 배경색

		// SheetEditable 처리
		setSheetEditable_sheet1();

		// 평가등급기준 및 평가등급코드 셋팅
		setAppClassCd_sheet1();

		// 평가시트에 따라 점수,등급 표시
		setSheetColHidden_sheet1();

		var sheetHeight = $('.wrapper').height() - $('#empForm').height() - $('.tab_bottom').outerHeight(true);
		$(window).smartresize(sheetResize); sheetInit();
		sheet1.SetSheetHeight(sheetHeight);

		doAction1("Search");
	}

	// Sheet2 init (역량)
	function init_sheet2(){
		if( $("#DIV_sheet2").html().length > 0 ) {
			doAction2("Search");
			return;
		}

		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msAll};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"세부\n내역|세부\n내역",		Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1,	Cursor:"Pointer" },
			{Header:"역량종류|역량종류",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"mainAppTypeNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"역량항목|역량항목",			Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"competencyNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가척도|평가척도",			Type:"Text",	Hidden:1,	Width:200,	Align:"Left",	ColMerge:1,	SaveName:"gmeasureMemo",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1 },
			{Header:"역량정의|역량정의",			Type:"Text",	Hidden:0,	Width:450,	Align:"Left",	ColMerge:1,	SaveName:"memo",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1 },

			{Header:"반영\n비율|반영\n비율",		Type:"AutoSum",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appRate",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10,	Format:"Integer",	PointCount:2 },
			{Header:"역량개발계획|역량개발계획",	Type:"Text",	Hidden:1,	Width:140,	Align:"Left",	ColMerge:0,	SaveName:"compDevPlan",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000,	MultiLineText:1, Wrap:1 },
			{Header:"지원요청사항|지원요청사항",	Type:"Text",	Hidden:1,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"reqSupportMemo",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000,	MultiLineText:1, Wrap:1 },

			// 주의! 이 곳에서의 설정은 Sheet가 처음 로딩될 때만 적용이 되기 때문에 searchAppraisalCd 변경 등으로 인해 바뀌는 설정값 들은 적용이 되지 않는다.
			// 따라서 아래 hdnType, updType값으로 설정하는 사항들은 setSheetColHidden_sheet2 함수에서 최종 설정하므로 아래 Sheet 초기화 시 적용된 사항들은 무시된다.
			// 변경이 필요할 시에는 이곳에서 변경하지 말고 setSheetColHidden_sheet2 함수에서 변경해야 한다!
			{Header:"본인평가|본인점수",			Type:"Int",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"compAppSelfPoint",KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:3 },
			{Header:"본인평가|본인등급",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compSelfClassCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"본인평가|본인의견",			Type:"Text",	Hidden:1,	Width:140,	Align:"Left",	ColMerge:0,	SaveName:"compSelfOpinion",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000,	MultiLineText:1, Wrap:1 },

			{Header:"1차평가|1차점수",			Type:"Int",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"compApp1stPoint",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:3 },
			{Header:"1차평가|1차등급",			Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"comp1stClassCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"1차평가|1차의견",			Type:"Text",	Hidden:1,	Width:190,	Align:"Left",	ColMerge:0,	SaveName:"comp1stOpinion",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000,	MultiLineText:1, Wrap:1 },

			{Header:"2차평가|2차점수",			Type:"Int",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"compApp2ndPoint",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:3 },
			{Header:"2차평가|2차등급",			Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"comp2ndClassCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"2차평가|2차의견",			Type:"Text",	Hidden:1,	Width:140,	Align:"Left",	ColMerge:0,	SaveName:"comp2ndOpinion",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000,	MultiLineText:1, Wrap:1 },

			{Header:"3차평가|3차점수",			Type:"Int",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"compApp3rdPoint",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:3 },
			{Header:"3차평가|3차등급",			Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"comp3rdClassCd",	KeyField:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"3차평가|3차의견",			Type:"Text",	Hidden:1,	Width:140,	Align:"Left",	ColMerge:0,	SaveName:"comp3rdOpinion",	KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000,	MultiLineText:1, Wrap:1 },

			{Header:"첨부파일|첨부파일",			Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"filePop",			Sort:0,	Cursor:"Pointer" },
			{Header:"첨부파일|첨부파일",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq"},

			{Header:"평가ID|평가ID",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사번|사번",				Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속|평가소속",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"역량코드|역량코드",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"competencyCd"},
			{Header:"구분|구분",				Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mainAppType"},

			{Header:"역량|역량구분",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"competencyType"},
			{Header:"역량|시작일자",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sdate"},
			{Header:"역량|종료일자",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"edate"},
			{Header:"역량|척도코드",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"gmeasureCd"},
			{Header:"역량|척도명",				Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"gmeasureNm"}
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(0);sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);

		sheet2.SetEditEnterBehavior("newline");
		sheet2.SetSumValue("sNo", "합계") ;
		sheet2.SetImageList(0, "${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetImageList(1, "${ctx}/common/images/icon/icon_file.png");
		sheet2.SetDataAlternateBackColor(sheet2.GetDataBackColor()); //짝수번째 데이터 행의 기본 배경색

		// SheetEditable 처리
		setSheetEditable_sheet2();

		// 평가등급기준 및 평가등급코드 셋팅
		setAppClassCd_sheet2();

		// 평가시트에 따라 점수,등급 표시
		setSheetColHidden_sheet2();

		var sheetHeight = $('.wrapper').height() - $('#empForm').height() - $('.tab_bottom').height()-10;
		$(window).smartresize(sheetResize); sheetInit();
		sheet2.SetSheetHeight(sheetHeight);

		doAction2("Search");
	}

	//평가소속 setting(평가명 change, 성명 팝업 선택 후)
	function setAppOrgCdCombo() {
		var addParams  = "queryId=getAppOrgCdListMboTarget";
			addParams += "&searchAppraisalCd="+$("#searchAppraisalCd").val();
			addParams += "&searchSabun="+$("#searchEvaSabun").val();
			addParams += "&searchAppStepCd="+$("#searchAppStepCd").val();
			addParams += "&searchAppYn=Y";

		// 평가소속 코드 조회
		var appOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&", addParams, false).codeList, "");

		$("#searchAppOrgCd").html("");
		$("#searchAppOrgCd").html(appOrgCdList[2]);

		$("#searchAppOrgCd").change();
	}

	//피평가자, 평가자정보조회(평가소속 change)
	function setAppEmployee() {
		$("#searchAppSabun").val("");
		$("#searchStatusCd").val("");
		$("#searchAppSheetType").val("");

		$("#searchAppName").val("");
		$("#searchJikgubNm").val("");
		$("#searchJikweeNm").val("");
		$("#searchStatus").val("");

		$("#spanBtnComment").hide();

		var data = ajaxCall("${ctx}/EvaMain.do?cmd=getAppSelfMapAppEmployee",$("#empForm").serialize(),false);

		// 업적,역량 평가 해당 여부값 초기화
		mboTargetYn = "N";
		compTargetYn = "N";

		if(data != null && data.map != null) {
			$("#searchAppSabun").val(data.map.appSabun);
			$("#searchStatusCd").val(data.map.statusCd);
			$("#searchAppSheetType").val(data.map.appSheetType);

			$("#searchAppName").val(data.map.appName);
			$("#searchJikgubNm").val(data.map.jikgubNm);
			$("#searchJikweeNm").val(data.map.jikweeNm);
			if( data.map.lastStatusCd == "23" || data.map.lastStatusCd == "33" || data.map.lastStatusCd == "43" ){
				$("#searchStatus").val(data.map.statusNm +"["+data.map.lastStatusNm+"]");
			}else{
				$("#searchStatus").val(data.map.statusNm);
			}

			if( data.map.commentImg == "Y") {
				$("#spanBtnComment").show();
			}

			mboTargetYn = data.map.mboTargetYn;
			if(mboTargetYn == "") mboTargetYn = "N";
			compTargetYn = data.map.compTargetYn;
			if(compTargetYn == "") compTargetYn = "N";

			// MBO 평가 대상자인 경우 탭 출력
			if ( mboTargetYn == "Y" ){
				$("#btnMboTargetYn").show();
				$("#mboTargetYn").val(mboTargetYn);
			}else{
				$("#btnMboTargetYn").hide();
				$("#mboTargetYn").val("");
			}

			// 역량 평가 대상자인 경우 탭 출력
			if (compTargetYn == "Y") {
				$("#btnCompetency").show();
				$("#compTargetYn").val(compTargetYn);
			} else {
				$("#btnCompetency").hide();
				$("#compTargetYn").val("");
			}
		}

		pageAuth();
	}

	// 임직원조회 자동완성 결과 세팅 처리
	function setEmpPage(){
		$("#searchName").val($("#searchKeyword").val());
		$("#searchEvaSabun").val($("#searchUserId").val());
		setAppOrgCdCombo();
	}

	//사원 팝업
	function employeePopup(val){
		try{
			if(!isPopup()) {return;}

			var args = new Array();
			//args["topKeyword"] = $("#searchName").val();

			gPRow = "";
			pGubun = "searchEmployeePopup" + val;

			openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");

		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	//화면 제어 - 최초, 또는 피평가자 변경 시
	function pageAuth() {

		$("#tabs").hide();

		if(mboTargetYn == "Y") {
			setTimeout(function(){init_sheet1();}, 100);
		}
		if(compTargetYn == "Y") {
			setTimeout(function(){init_sheet2();}, 200);
		}

		//탭셋팅
		$($("#tabKpi").parent()).hide();
		$($("#tabCompetency").parent()).hide();
		$("#tabs-1").hide();
		$("#tabs-2").hide();

		var tabEnable = null;
		if (mboTargetYn == "Y" && compTargetYn == "Y") {
			tabEnable = [0,1];
			$($("#tabKpi").parent()).show();
			$($("#tabCompetency").parent()).show();
			//탭출력
			$("#tabs-1").show();
			$("#tabs-2").show();
		} else if(mboTargetYn == "Y" && compTargetYn == "N") {
			tabEnable = [0];
			$($("#tabKpi").parent()).show();
			//탭출력
			$("#tabs-1").show();
		} else if(mboTargetYn == "N" && compTargetYn == "Y") {
			tabEnable = [1];
			$($("#tabCompetency").parent()).show();
			//탭출력
			$("#tabs-2").show();
		}

		if (tabEnable == null) {
			$("#btnPrint").hide();		// 출력
			$("#btnDown2Excel").hide();	// 다운로드
			return;
		}

		$("#btnDown2Excel").show();

		$("#tabs").show();

		$("#tabs").tabs( "enable", tabEnable );
		$("#tabs").tabs( "option", "active", tabEnable[0] );
		$("#tabsIndex").val( "" + tabEnable[0]);

		// 평가등급, 파일순번 조회
		getAppSelfMap1();

		// SheetEditable 처리
		setSheetEditable_sheet1();
		setSheetEditable_sheet2();

		// 평가등급기준 및 평가등급코드 셋팅
		setAppClassCd_sheet1();
		setAppClassCd_sheet2();

		// 평가시트에 따라 점수,등급 표시
		setSheetColHidden_sheet1();
		setSheetColHidden_sheet2();

		//moveTab(0);
	}

	//Tab 선택 시
	function moveTab(tabIdx){
		// 0: MBO, 1:역량, 2:평가의견
		switch(tabIdx){
		case 0: //MBO
			if( !$("#gradeInfoArea").hasClass("hide") ) {
				$("#spanGrade1").show();  //MBO점수
				$("#spanGrade2").hide();
				$("#spanGrade3").hide();
			}
			break;
		case 1://역량
			if( !$("#gradeInfoArea").hasClass("hide") ) {
				$("#spanGrade1").hide();
				$("#spanGrade2").show(); //역량점수
				$("#spanGrade3").hide();
			}
			setTimeout(function(){setSheetSize(sheet2);}, 50);
			break;
		case 2://평가의견
			if( !$("#gradeInfoArea").hasClass("hide") ) {
				$("#spanGrade1").hide();
				$("#spanGrade2").hide();
				$("#spanGrade3").show(); //MBO점수 + 역량점수
			}
			break;
		}
	}

	function setTab(idx){
		$("#tabs").tabs( "option", "active", idx );
		$("#tabsIndex").val(idx);
		moveTab(idx);

		if(idx == 0) setTimeout(function(){setSheetSize(sheet1);}, 50);
		if(idx == 1) setTimeout(function(){setSheetSize(sheet2);}, 50);
	}

	function setSheetEditable_sheet1() {
		if (mboTargetYn == "Y") {
			sheet1.SetEditable(0);
		}
	}

	function setSheetEditable_sheet2() {
		if (compTargetYn == "Y") {
			sheet2.SetEditable(0);
		}
	}

	function setAppClassCd_sheet1() {
		/*
		//평가등급기준 -- 평가종류에 따라 다른 등급을 가져옴.
		var saveNameLst = ["sGradeBase", "aGradeBase", "bGradeBase", "cGradeBase", "dGradeBase"];
		//classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, ""); // 평가등급
		classCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y&visualYn=Y","P00001"), ""); // 평가등급(P00001)
    	clsLst = classCdList[0].split("|");

		for( var i=0; i<clsLst.length ; i++){
			sheet1.SetColHidden(saveNameLst[i], 0 );
			sheet1.SetCellValue(1, saveNameLst[i], clsLst[i] );
		}
		var len = clsLst.length;
		if(classCdList[0] == "" ) len = 0;
		for( var i=len; i<saveNameLst.length ; i++){
			sheet1.SetColHidden(saveNameLst[i], 1 );
		}

		sheet1.SetColProperty("mboSelfClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		sheet1.SetColProperty("mbo1stClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		sheet1.SetColProperty("mbo2ndClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		sheet2.SetColProperty("compSelfClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		sheet2.SetColProperty("comp1stClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		sheet2.SetColProperty("comp2ndClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		*/

		sheet1.SetColProperty("mboSelfClassCd", {ComboText : allClassCdList[0], ComboCode : allClassCdList[1]});
		sheet1.SetColProperty("mbo1stClassCd", {ComboText : allClassCdList[0], ComboCode : allClassCdList[1]});
		sheet1.SetColProperty("mbo2ndClassCd", {ComboText : allClassCdList[0], ComboCode : allClassCdList[1]});
		sheet1.SetColProperty("mbo3rdClassCd", {ComboText : allClassCdList[0], ComboCode : allClassCdList[1]});
	}

	function setAppClassCd_sheet2() {
		sheet2.SetColProperty("compSelfClassCd", {ComboText : allClassCdList[0], ComboCode : allClassCdList[1]});
		sheet2.SetColProperty("comp1stClassCd", {ComboText : allClassCdList[0], ComboCode : allClassCdList[1]});
		sheet2.SetColProperty("comp2ndClassCd", {ComboText : allClassCdList[0], ComboCode : allClassCdList[1]});
		sheet2.SetColProperty("comp3rdClassCd", {ComboText : allClassCdList[0], ComboCode : allClassCdList[1]});
	}

	//평가시트에 따라 점수,등급 표시
	function setSheetColHidden_sheet1() {
		/*
		var cVal = 1, pVal = 1;
		if( $("#searchAppSheetType").val() == "A" ) {   // MBO+역량(점수)
			cVal = 1; pVal = 0;
		}else if( $("#searchAppSheetType").val() == "B" ){ // MBO+역량(등급)
			cVal = 0; pVal = 1;
		}
		switch( $("#searchAppSeqCd").val() ) {
		case "2": //2차평가
			//sheet1.SetColHidden("mbo2ndClassCd", cVal);
			//sheet1.SetColHidden("mboApp2ndPoint", pVal);
			//sheet2.SetColHidden("comp2ndClassCd", cVal);
			sheet2.SetColHidden("compApp2ndPoint", pVal);
		case "1": //1차평가
			sheet1.SetColHidden("mbo1stClassCd", cVal);
			//sheet1.SetColHidden("mboApp1stPoint", pVal);
			sheet2.SetColHidden("comp1stClassCd", cVal);
			sheet2.SetColHidden("compApp1stPoint", pVal);
		case "0": //본인평가
			sheet1.SetColHidden("mboSelfClassCd", cVal);
			//sheet1.SetColHidden("mboAppSelfPoint", pVal);
			sheet2.SetColHidden("compSelfClassCd", cVal);
			sheet2.SetColHidden("compAppSelfPoint", pVal);
			break;
		}
		*/
		/*
		var closeYn = "N";
		if( $("#searchAppraisalCd option:selected") != undefined && $("#searchAppraisalCd option:selected").attr("closeYn") != undefined ) {
			closeYn = $("#searchAppraisalCd option:selected").attr("closeYn");
		}
		*/
		/* 무신사 기준 */
		/*
		switch( $("#searchAppSeqCd").val() ) {
			case "0": //본인평가
				sheet1.SetColEditable("mbo1stMemo", 0);
				// 마감된 평가인 경우 평가의견 컬럼 출력
				if( closeYn == "Y" ) {
					sheet1.SetColHidden("mbo1stMemo", 0);
				} else {
					sheet1.SetColHidden("mbo1stMemo", 1);
				}
				break;
			case "1": //1차평가
				sheet1.SetColHidden("mbo1stMemo", 0);
				break;
			case "2": //2차평가
				break;
			case "6": //3차평가
				break;
		}
		*/

		// mboAppResult (추진실적)
		sheet1.SetColProperty("mboAppResult", {KeyField:0});
		sheet1.SetColEditable("mboAppResult", 0);

		// mboAppSelfPoint(본인평가|평가점수)
		setSheetColProperty(sheet1, "mboAppSelfPoint");

		// mboSelfClassCd (본인평가|평가등급)
		setSheetColProperty(sheet1, "mboSelfClassCd");

		// mboApp1stPoint (1차평가|평가점수)
		setSheetColProperty(sheet1, "mboApp1stPoint");

		// mbo1stClassCd (1차평가|평가등급)
		setSheetColProperty(sheet1, "mbo1stClassCd");

		// mbo1stMemo (1차평가|평가의견) ---> [무신사 기준]으로 되어 있는 원 소스 적용
		setSheetColProperty(sheet1, "mbo1stMemo");

		// mboApp2ndPoint (2차평가|평가점수)
		setSheetColProperty(sheet1, "mboApp2ndPoint");

		// mbo2ndClassCd (2차평가|평가등급)
		setSheetColProperty(sheet1, "mbo2ndClassCd");

		// mbo2ndMemo (2차평가|평가의견)
		//setSheetColProperty(sheet1, "mbo2ndMemo");

		// mboApp3rdPoint (3차평가|평가점수)
		setSheetColProperty(sheet1, "mboApp3rdPoint");

		// mbo3rdClassCd (3차평가|평가등급)
		setSheetColProperty(sheet1, "mbo3rdClassCd");

		// mbo3rdMemo (3차평가|평가의견)
		//setSheetColProperty(sheet1, "mbo3rdMemo");
	}

	//평가시트에 따라 점수,등급 표시
	function setSheetColHidden_sheet2() {
		/*
		var cVal = 1, pVal = 1;
		if( $("#searchAppSheetType").val() == "A" ) {   // MBO+역량(점수)
			cVal = 1; pVal = 0;
		}else if( $("#searchAppSheetType").val() == "B" ){ // MBO+역량(등급)
			cVal = 0; pVal = 1;
		}
		switch( $("#searchAppSeqCd").val() ) {
		case "2": //2차평가
			//sheet1.SetColHidden("mbo2ndClassCd", cVal);
			//sheet1.SetColHidden("mboApp2ndPoint", pVal);
			//sheet2.SetColHidden("comp2ndClassCd", cVal);
			sheet2.SetColHidden("compApp2ndPoint", pVal);
		case "1": //1차평가
			sheet1.SetColHidden("mbo1stClassCd", cVal);
			//sheet1.SetColHidden("mboApp1stPoint", pVal);
			sheet2.SetColHidden("comp1stClassCd", cVal);
			sheet2.SetColHidden("compApp1stPoint", pVal);
		case "0": //본인평가
			sheet1.SetColHidden("mboSelfClassCd", cVal);
			//sheet1.SetColHidden("mboAppSelfPoint", pVal);
			sheet2.SetColHidden("compSelfClassCd", cVal);
			sheet2.SetColHidden("compAppSelfPoint", pVal);
			break;
		}
		*/

		// compAppSelfPoint (본인평가|평가점수)
		setSheetColProperty(sheet2, "compAppSelfPoint");

		// compSelfClassCd (본인평가|평가등급)
		setSheetColProperty(sheet2, "compSelfClassCd");

		// compApp1stPoint (1차평가|평가점수)
		setSheetColProperty(sheet2, "compApp1stPoint");

		// comp1stClassCd (1차평가|평가등급)
		setSheetColProperty(sheet2, "comp1stClassCd");

		// comp1stOpinion (1차평가|평가의견)
		setSheetColProperty(sheet2, "comp1stOpinion");

		// compApp2ndPoint (2차평가|평가점수)
		setSheetColProperty(sheet2, "compApp2ndPoint");

		// comp2ndClassCd (2차평가|평가등급)
		setSheetColProperty(sheet2, "comp2ndClassCd");

		// comp2ndOpinion (2차평가|평가의견)
		//setSheetColProperty(sheet2, "comp2ndOpinion");

		// compApp3rdPoint (3차평가|평가점수)
		setSheetColProperty(sheet2, "compApp3rdPoint");

		// comp3rdClassCd (3차평가|평가등급)
		setSheetColProperty(sheet2, "comp3rdClassCd");

		// comp3rdOpinion (3차평가|평가의견)
		//setSheetColProperty(sheet2, "comp3rdOpinion");
	}

	/**
	 * Sheet Column Property 설정
	 * 평가채점방식, 차수, 마감여부 등을 고려하여 각 컬럼의 Hidden, KeyField, Editable을 설정한다.
	 *
	 * @param sheet : Column Property 설정을 할 Sheet
	 * @param col : Column
	 * @returns
	 */
	function setSheetColProperty(sheet, col) {
		var colLower = col.toLowerCase();

		var seq = -1;
		if (colLower.indexOf('self') >= 0) {
			seq = 0;
		} else if (colLower.indexOf('1st') >= 0) {
			seq = 1;
		} else if (colLower.indexOf('2nd') >= 0) {
			seq = 2;
		} else if (colLower.indexOf('3rd') >= 0) {
			seq = 3;
		} else {
			seq = -1;
		}
		if (seq < 0) return;

		var type = null;
		if (colLower.indexOf('point') >= 0) {
			type = 'p';
		} else if (colLower.indexOf('classcd') >= 0) {
			type = 'c';
		} else if (colLower.indexOf('memo') >= 0 || colLower.indexOf('opinion') >= 0) {
			type = 'm';
		} else {
			type = null;
		}
		if (type == null) return;

		var targetYn = -1;
		if (colLower.indexOf('mbo') >= 0) {
			targetYn = mboTargetYn == "Y" ? 1 : 0;
		} else if (colLower.indexOf('comp') >= 0) {
			targetYn = compTargetYn == "Y" ? 1 : 0;
		}
		if (targetYn < 0) return;

		var closeYn = getSelectAttr("searchAppraisalCd", "closeYn");					// 마감여부
		var appGradingMethod = getSelectAttr("searchAppraisalCd", "appGradingMethod");	// P20007(평가채점방식) : P(점수), C(등급)
		var note1 = parseInt(getSelectAttr("searchAppraisalCd", "note1"), 10);			// [비고1 : 점수 Hidden]
		var note2 = parseInt(getSelectAttr("searchAppraisalCd", "note2"), 10);			// [비고2 : 등급 Hidden]
		var note3 = parseInt(getSelectAttr("searchAppraisalCd", "note3"), 10);			// [비고3 : 점수 Edit]
		var note4 = parseInt(getSelectAttr("searchAppraisalCd", "note4"), 10);			// [비고4 : 등급 Edit]

		switch (type) {
		// Point (평가점수)
		case "p":
			sheet.SetColHidden(col, hdnType[seq] | note1 | (targetYn ^ 1));
			sheet.SetColProperty(col, {KeyField:0});
			sheet.SetColEditable(col, 0);
			break;
		// ClassCd (평가등급)
		case "c":
			sheet.SetColHidden(col, hdnType[seq] | note2 | (targetYn ^ 1));
			sheet.SetColProperty(col, {KeyField:0});
			sheet.SetColEditable(col, 0);
			break;
		// Memo, Opinion (평가의견)
		case "m":
			sheet.SetColHidden(col, (hdnType[seq] & closeYn != "Y") | (targetYn ^ 1));
			sheet.SetColProperty(col, {KeyField:0});
			sheet.SetColEditable(col, 0);
			break;
		default:
			break;
		}
	}

	// 평가등급, 파일순번 조회
	function getAppSelfMap1() {
		/*
		var data = ajaxCall("${ctx}/EvaMain.do?cmd=getAppSelfMap1",$("#empForm").serialize(),false);
		if(data != null && data.map != null) {
			$("#fileSeq").val((data.map.fileSeq==null?'':data.map.fileSeq));

			var spanMboPoint1 = ""; //MBO
			var spanMboPoint2 = ""; //역량
			if($("#searchAppSeqCd").val() == "0") {
				spanMboPoint1 = "본인( "+(data.map.mboTAppSelfPoint==null?'':data.map.mboTAppSelfPoint) +" )";
				spanMboPoint2 = "본인( "+(data.map.compTAppSelfPoint==null?'':data.map.compTAppSelfPoint) +" )";
			} else if($("#searchAppSeqCd").val() == "1") {
				spanMboPoint1 = "본인( "+(data.map.mboTAppSelfPoint==null?'':data.map.mboTAppSelfPoint)+" )";
				spanMboPoint1 += " 1차( "+(data.map.mboTApp1stPoint==null?'':data.map.mboTApp1stPoint)+" )";
				spanMboPoint2 = "본인( "+(data.map.compTAppSelfPoint==null?'':data.map.compTAppSelfPoint)+" )";
				spanMboPoint2 += " 1차( "+(data.map.compTApp1stPoint==null?'':data.map.compTApp1stPoint)+" )";
			} else if($("#searchAppSeqCd").val() == "2") {
				spanMboPoint1 = "본인( "+(data.map.mboTAppSelfPoint==null?'':data.map.mboTAppSelfPoint)+" )";
				spanMboPoint1 += " 1차( "+(data.map.mboTApp1stPoint==null?'':data.map.mboTApp1stPoint)+" )";
				spanMboPoint1 += " 2차( "+(data.map.mboTApp2ndPoint==null?'':data.map.mboTApp2ndPoint) +" )";
				spanMboPoint2 = "본인( "+(data.map.compTAppSelfPoint==null?'':data.map.compTAppSelfPoint)+" )";
				spanMboPoint2 += " 1차( "+(data.map.compTApp1stPoint==null?'':data.map.compTApp1stPoint)+" )";
				spanMboPoint2 += " 2차( "+(data.map.compTApp2ndPoint==null?'':data.map.compTApp2ndPoint) +" )";
			}
			$("#spanMboPoint1").html(spanMboPoint1);
			$("#spanMboPoint2").html(spanMboPoint2);
			$("#spanMboPoint3").html("<b>MBO</b> - "+spanMboPoint1+"&nbsp;&nbsp;&nbsp;<b>역량</b> - "+spanMboPoint2);
		} else {
			$("#spanMboPoint1").html("");
			$("#spanMboPoint2").html("");
			$("#spanMboPoint3").html("");
		}
		*/
	}

	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			if (!commCheck(true)) return;

			getAppSelfMap1();

			if( $("#DIV_sheet1").html().length > 0 ) setTimeout(function(){doAction1("Search");}, 200);
			if( $("#DIV_sheet2").html().length > 0 ) setTimeout(function(){doAction2("Search");}, 400);

			break;

		case "Down2Excel":
			if ( $('#tabsIndex').val() == "0" ) {
				doAction1("Down2Excel");
			}
			if ( $('#tabsIndex').val() == "1" ) {
				doAction2("Down2Excel");
			}
			break;

		case "Comment":	//의견보기
			if(!isPopup()) {return;}

			if (!commCheck(true)) return;

			var args = new Array();

			args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
			args["searchEvaSabun"] = $("#searchEvaSabun").val();
			args["searchAppOrgCd"] = $("#searchAppOrgCd").val();
			args["searchAppStepCd"] = $("#searchAppStepCd").val();

			gPRow = "";
			pGubun = "appSelfPopCommentView";

			// openPopup(url,args,800,520);
			var layer = new window.top.document.LayerModal({
				id : 'appSelfPopCommentViewLayer'
				, url : "${ctx}/EvaMain.do?cmd=viewAppSelfPopCommentView"
				, parameters: args
				, width : 800
				, height : 520
				, title : "의견보기"
				, trigger :[
					{
						name : 'appSelfPopCommentViewTrigger'
						, callback : function(rv){
							getReturnValue(rv);
						}
					}
				]
			});
			layer.show();

			break;
		}
	}

	//공통 체크
	function commCheck(bExcludeStatusCd) {
		if ($("#searchAppraisalCd").val() == "") {
			alert("평가명이 존재하지 않습니다.");
			return false;
		}

		if ($("#searchAppOrgCd").val() == "") {
			alert("평가소속이 존재하지 않습니다.");
			return false;
		}

		if ($("#searchAppName").val() == "") {
			alert("평가자가 존재하지 않습니다.");
			return false;
		}

		if ($("#searchEvaSabun").val() == "") {
			alert("평가 대상자가 존재하지 않습니다.");
			return false;
		}

		// 미완료 : N, 평가완료 : Y
		if ($("#searchStatusCd").val() == "Y" && !bExcludeStatusCd) {
			alert("이미 평가완료된 상태입니다.");
			return false;
		}

		return true;
	}

	//출력
	function rdPopup(){
 		var w 		= 1200;
		var h 		= 950;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();

		var rdMrd   = "pap/progress/AppSelfReport.mrd";
		var rdTitle = "본인평가표출력";
		var rdParam = "";
		var str = "";

		var searchAppraisalCdSAbunAppOrgCd_s = "('" + $("#searchAppraisalCd").val() + "', '"+ $("#searchEvaSabun").val() +"', '"+ $("#searchAppOrgCd").val() +"'),";
		searchAppraisalCdSAbunAppOrgCd_s = searchAppraisalCdSAbunAppOrgCd_s.substr(0, searchAppraisalCdSAbunAppOrgCd_s.length-1);

		rdParam  = rdParam +"[${ssnEnterCd}] "; //회사코드
		rdParam  = rdParam +"[5] "; //단계
		rdParam  = rdParam +"[0] "; // 차수
		rdParam  = rdParam +"["+ searchAppraisalCdSAbunAppOrgCd_s +"] "; //피평가자 사번, 평가소속

		var imgPath = " " ;
		args["rdTitle"]      = rdTitle;	//rd Popup제목
		args["rdMrd"]        = rdMrd;	//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"]      = rdParam;	//rd파라매터
		args["rdParamGubun"] = "rp";	//파라매터구분(rp/rv)
		args["rdToolBarYn"]  = "Y" ;	//툴바여부
		args["rdZoomRatio"]  = "100";	//확대축소비율

		args["rdSaveYn"]     = "Y" ;	//기능컨트롤_저장
		args["rdPrintYn"]    = "Y" ;	//기능컨트롤_인쇄
		args["rdExcelYn"]    = "Y" ;	//기능컨트롤_엑셀
		args["rdWordYn"]     = "Y" ;	//기능컨트롤_워드
		args["rdPptYn"]      = "Y" ;	//기능컨트롤_파워포인트
		args["rdHwpYn"]      = "Y" ;	//기능컨트롤_한글
		args["rdPdfYn"]      = "Y" ;	//기능컨트롤_PDF

		gPRow = "";
		pGubun = "rdPopup";

		openPopup(url,args,w,h);//알디출력을 위한 팝업창

	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "searchEmployeePopup"){
			$("#searchName").val(rv["name"]);
			$("#searchEvaSabun").val(rv["sabun"]);
			setAppOrgCdCombo();
		} else if(pGubun == "appSelfPopDetail") {
			var paramName = ["seq"
				,"orderSeq"
				,"appIndexGubunNm"
				,"mboType"
				,"mboTarget"
				,"weight"
				,"kpiNm"
				,"formula"
				,"remark"
				,"deadlineType"
				,"deadlineTypeTo"
				,"baselineData"
				,"sGradeBase"
				,"aGradeBase"
				,"bGradeBase"
				,"cGradeBase"
				,"dGradeBase"
				,"mboMidAppResult"
				,"mboAppResult"
				,"mboAppSelfPoint"
				,"mboSelfClassCd"
				,"mboApp1stPoint"
				,"mbo1stClassCd"
				,"mbo1stMemo"	// 1차평가의견
				,"mboApp2ndPoint"
				,"mbo2ndClassCd"
				,"mbo2ndMemo"
				,"mboApp3rdPoint"
				,"mbo3rdClassCd"
				,"mbo3rdMemo"
			];

			//for (var i=0; i<paramName.length; i++) {
			//	sheet1.SetCellValue(gPRow, paramName[i], rv[paramName[i]]);
			//}

		 } else if(pGubun == "mboTargetRegFile"){
			if(rv["fileCheck"] == "exist"){
				//sheet2.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				//sheet2.SetCellValue(gPRow, "fileSeq", "");
			}
		}
	}
</script>

<!-- Tap1 Script -->
<script type="text/javascript">
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// sheet 조회
			sheet1.DoSearch( "${ctx}/EvaMain.do?cmd=getAppSelfList1", $("#empForm").serialize() );
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

		return true;
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

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if (Row < sheet1.HeaderRows()) return;

			if(sheet1.ColSaveName(Col) == "detail" && sheet1.GetCellValue(Row, "sStatus") != "" ){
				if(!isPopup()) {return;}

				var paramName = ["seq"
					,"orderSeq"
					,"appIndexGubunNm"
					,"mboType"
					,"mboTarget"
					,"weight"
					,"kpiNm"
					,"formula"
					,"remark"
					,"deadlineType"
					,"deadlineTypeTo"
					,"baselineData"
					,"sGradeBase"
					,"aGradeBase"
					,"bGradeBase"
					,"cGradeBase"
					,"dGradeBase"
					,"mboMidAppResult"
					,"mboAppResult"
					,"mboAppSelfPoint"
					,"mboSelfClassCd"
					,"mboApp1stPoint"
					,"mbo1stClassCd"
					,"mbo1stMemo"	// 1차평가의견
					,"mboApp2ndPoint"
					,"mbo2ndClassCd"
					,"mbo2ndMemo"
					,"mboApp3rdPoint"
					,"mbo3rdClassCd"
					,"mbo3rdMemo"
				];

				var args = {};
				args["searchAppSeqCd"] = $("#searchAppSeqCd").val();

				args["authPg"] = "R";

				for (var i=0; i<paramName.length; i++) {
					args[paramName[i]] = sheet1.GetCellValue(Row, paramName[i]);
				}

				args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
				args["searchAppSheetType"] = $("#searchAppSheetType").val();

				args["closeYn"] = getSelectAttr("searchAppraisalCd", "closeYn");	// 마감여부
				args["appGradingMethod"] = getSelectAttr("searchAppraisalCd", "appGradingMethod");	// P20007(평가채점방식) : P(점수), C(등급)
				args["note1"] = getSelectAttr("searchAppraisalCd", "note1");		// [비고1 : 점수 Hidden]
				args["note2"] = getSelectAttr("searchAppraisalCd", "note2");		// [비고2 : 등급 Hidden]
				args["note3"] = getSelectAttr("searchAppraisalCd", "note3");		// [비고3 : 점수 Edit]
				args["note4"] = getSelectAttr("searchAppraisalCd", "note4");		// [비고4 : 등급 Edit]

				gPRow = Row;
				pGubun = "appSelfPopDetail";

				// openPopup(url,args,700,770);
				var layer = new window.top.document.LayerModal({
					id : 'appSelfPopDetailLayer'
					, url : "${ctx}/EvaMain.do?cmd=viewAppSelfPopDetail"
					, parameters: args
					, width : 1000
					, height : 800
					, title : "KPI관리"
					, trigger :[
						{
							name : 'appSelfPopDetailTrigger'
							, callback : function(rv){
								getReturnValue(rv);
							}
						}
					]
				});
				layer.show();

			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
</script>

<!-- Tap3 Script -->
<script type="text/javascript">
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			// sheet 조회
			sheet2.DoSearch( "${ctx}/EvaMain.do?cmd=getAppSelfList2", $("#empForm").serialize() );
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
		}

		return true;
	}

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

	function sheet2_OnClick(Row, Col, Value) {
		try{
			if (Row >= sheet2.HeaderRows()) {
				if( sheet2.ColSaveName(Col) == "filePop" ) {
					gPRow = Row;
					pGubun = "mboTargetRegFile";
					var authPgTemp="${authPg}";
					if( sheet2.GetEditable() == 0 || $("#searchAppSeqCd").val() != "0" ) authPgTemp = "R";
					else authPgTemp = "A";

					// "R" 고정
					authPgTemp = "R";

					openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&fileSeq="+sheet2.GetCellValue(Row,"fileSeq"), "", "740","270");
				} else if( sheet2.ColSaveName(Col) == "detail" ) {
					competencyMgrPopup(Row);
				}
			} else {
				return;
			}
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	/**
	 * 역량사전 window open event
	 */
	function competencyMgrPopup(Row){
    	if(!isPopup()) {return;}

		var args 	= {};
		args["competencyCd"] 	= sheet2.GetCellValue(Row, "competencyCd");
		args["competencyNm"] 	= sheet2.GetCellValue(Row, "competencyNm");
		args["competencyType"] 	= sheet2.GetCellValue(Row, "competencyType");
		args["mainAppType"] 	= sheet2.GetCellValue(Row, "mainAppType");
		args["sdate"] 			= sheet2.GetCellText(Row, "sdate");
		args["edate"] 			= sheet2.GetCellText(Row, "edate");
		args["memo"] 			= sheet2.GetCellValue(Row, "memo");
		args["gmeasureCd"] 		= sheet2.GetCellValue(Row, "gmeasureCd");
		args["gmeasureNm"] 		= sheet2.GetCellValue(Row, "gmeasureNm");

		var layer = new window.top.document.LayerModal({
			id : 'competencyMgrLayer'
			, url : "${ctx}/CompetencyMgr.do?cmd=viewCompetencyMgrPopup&authPg=R"
			, parameters: args
			, width : 1000
			, height : 720
			, title : "역량사전 세부내역"
			, trigger :[
				{
					name : 'competencyMgrTrigger'
					, callback : function(rv){
						getReturnValue(rv);
					}
				}
			]
		});
		layer.show();

	}
</script>
<style type="text/css">
#spanGrade1 table, #spanGrade2 table, #spanGrade3 table {height:30px;}
#spanGrade1 table td, #spanGrade2 table td, #spanGrade3 table td {color:blue;}

</style>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" id="tabsIndex" name="tabsIndex" value="" />
		<input type="hidden" name="searchAppStepCd"		id="searchAppStepCd"	value="5">
		<input type="hidden" name="searchAppSeqCd"		id="searchAppSeqCd"		value="${map.searchAppSeqCd}">
		<input type="hidden" name="searchAppSabun"		id="searchAppSabun" />
		<input type="hidden" name="searchStatusCd"		id="searchStatusCd" />
		<input type="hidden" name="searchOrgCd"			id="searchOrgCd" />
		<input type="hidden" name="searchOrgNm"			id="searchOrgNm" />
		<input type="hidden" name="searchAppSheetType"	id="searchAppSheetType" />
		<input type="hidden" name="searchAppYn"			id="searchAppYn" />
		<input type="hidden" name="fileSeq"				id="fileSeq" />

		<input type="hidden" name="mboTargetYn"			id="mboTargetYn" />
		<input type="hidden" name="compTargetYn"		id="compTargetYn" />

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
							<select id="searchAppOrgCd" name="searchAppOrgCd"></select>	</td>
						<td class="hide">
							<span class="w60">평가자 </span>
							<input id="searchAppName" name ="searchAppName" type="text" class="text readonly" readonly>

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
							<a onclick="javascript:employeePopup('');" class="button6" id="btnSabunPop"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchEvaSabun,#searchName').val('');" class="button7" id="btnSabunClear"><img src="/common/images/icon/icon_undo.png"/></a>
							 -->
					</c:when>
					<c:otherwise>
							<input id="searchName" name ="searchName" type="text" class="text readonly" readonly>
							<input id="searchKeyword" name ="searchKeyword" type="hidden" />
					</c:otherwise>
				</c:choose>
						</td>

	<c:if test="${ssnJikweeUseYn == 'Y'}">
						<td>
						 	<span class="w60">직위 </span>
						 	<input id="searchJikweeNm" name ="searchJikweeNm" type="text" class="text readonly" readonly>
						 </td>
	</c:if>
	<c:if test="${ssnJikgubUseYn == 'Y'}">
						<td>
							<span class="w60">직급 </span>
							<input id="searchJikgubNm" name="searchJikgubNm" type="text" class="text readonly" readonly>
						</td>
	</c:if>
						<td>
							<a href="javascript:setAppOrgCdCombo();" id="btnSearch" class="btn dark" >조회</a>
							<span id="spanBtnComment" class="btn pap_span">
								<a href="javascript:doAction('Comment')" id="btnComment" class="btn outline_gray" >의견보기</a>
							</span>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

		<div id="tabs">
			<ul class="tab_bottom mb-8">
				<li id="btnMboTargetYn"><a href="#tabs-1" onClick="$('#tabsIndex').val('0');moveTab(0);" id="tabKpi">업적</a></li>
				<li id="btnCompetency"><a href="#tabs-2" onClick="$('#tabsIndex').val('1');moveTab(1);" id="tabCompetency">역량</a></li>
				<li id="gradeInfoArea" class="hide">
					<span id="spanGrade1">
						<table >
							<tr>
								<td>&nbsp;&nbsp;&nbsp; 평가점수 : <span id="spanMboPoint1"></span></td>
							</tr>
						</table>
					</span>
					<span id="spanGrade2">
						<table>
							<tr>
								<td>&nbsp;&nbsp;&nbsp; 평가점수 : <span id="spanMboPoint2"></span></td>
							</tr>
						</table>
					</span>
					<span id="spanGrade3">
						<table>
							<tr>
								<td>&nbsp;&nbsp;&nbsp; 평가점수 : <span id="spanMboPoint3"></span></td>
							</tr>
						</table>
					</span>
				</li>
				<li class="ml-auto">
					<a style="display:none;"></a>
					<a href="javascript:rdPopup();" 				class="basic authR"         id="btnPrint">출력</a>
					<a href="javascript:doAction('Down2Excel')"		class="basic authR" id="btnDown2Excel">다운로드</a>
				</li>
			</ul>

			<div id="tabs-1">
				<script type="text/javascript">createTabHeightIBsheet("sheet1", "100%", "100%"); </script>
			</div>
			<div id="tabs-2">
				<script type="text/javascript"> createTabHeightIBsheet("sheet2", "100%", "100%"); </script>
			</div>
		</div>
</div>
</body>
</html>