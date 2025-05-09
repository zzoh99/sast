<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='111900' mdef='승진대상자관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="/common/js/execAppmt.js"></script>
<script type="text/javascript">

	var vSearchEvlYy = "";
	var pGubun = "";
	var POST_ITEMS = [];
	$(function() {
		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}

		$("#searchInfoYn").attr('checked', true);

		// 발령항목 조회
		POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:12};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"${sDelTy}",	Hidden:Number("0"),			Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"${sSttTy}",	Hidden:Number("0"),			Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"승진명부코드|승진명부코드",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pmtCd",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"승진유형|승진유형",				Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pmtType",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"직종유형|직종유형",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pmtPositionType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"현직위|현직위",				Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"oldJikweeCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"승진직위|승진직위",				Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"승진직급|승진직급",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:15 },
			{Header:"사진|사진",			Type:"Image",	Hidden:1,   MinWidth:55,   Align:"Center", ColMerge:0, SaveName:"photo",		UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
			{Header:"사번|사번",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13},
			{Header:"성명|성명",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"승진대상자정보|소속",			Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"승진대상자정보|직책",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"승진대상자정보|직급",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"oldJikgubCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"승진대상자정보|최종승진일",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"pmtCurrYmd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"승진대상자정보|직위\n년차",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pmtCurrYear",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23},
			{Header:"승진대상자정보|체류년한\n충족여부",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"pmtCurrYearYn",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1},
			{Header:"승진대상자정보|그룹입사일",		Type:"Date",	Hidden:Number("${gempYmdHdn}"),	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"승진대상자정보|입사일",			Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"승진대상자정보|근속기간",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workYymmCnt",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"승진대상자정보|나이(만)",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"intAge",			KeyField:0,	Format:"## 세",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:23},

			{Header:"승진대상자정보(Hidden)|소속코드",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"승진대상자정보(Hidden)|직종",			Type:"Combo",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"positionCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"승진대상자정보(Hidden)|그룹근속",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workGYymmCnt",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"승진대상자정보(Hidden)|급여유형",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payTypeNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},

			{Header:"종합평가등급|당해년도",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"종합평가등급|당해년도-1년",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"종합평가등급|당해년도-2년",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd3",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"종합평가등급|당해년도-3년",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd4",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"종합평가등급|당해년도-4년",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd5",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"종합평가등급|당해년도-5년",		Type:"Combo",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd6",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"승진포인트|평가\n평균점수",		Type:"Float",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pmtAppJumsu",		KeyField:0,	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"승진포인트|가점",				Type:"Float",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"prizePoint",		KeyField:0,	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"승진포인트|감점",				Type:"Float",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"punishPoint",		KeyField:0,	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"승진포인트|가감점",				Type:"Float",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"prizePunishPoint",KeyField:0,	CalcLogic:"|prizePoint|+|punishPoint|",	Format:"NullFloat",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:23 },
			{Header:"승진포인트|승진포인트",			Type:"Float",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"pmtAppPoint",		KeyField:0,	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },

			{Header:"포인트서열|포인트서열",			Type:"Int",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"pointRank",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 },
			{Header:"자격증\n취득여부|자격증\n취득여부",Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"licenseYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N" },

			{Header:"승진대상\n여부|승진대상\n여부",	Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"pmtTargetYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"승진\n확정|승진\n확정",			Type:"CheckBox",Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pmtYn",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N" },



			{Header:"발령연계\n처리|발령연계\n처리",	Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"발령연계\n처리|발령연계\n처리",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},

			{Header:"발령|발령",					Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령상세|발령상세",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령일|발령일",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령seq|발령seq",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"발령\n확정여부|발령\n확정여부",	Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1},
			{Header:"발령확정\n여부|발령확정\n여부",	Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage4",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"비고|비고",					Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },

			{Header:"최종학력|최종학력",				Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"acaCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"최종학력|최종학교",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"acaSchNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"최종학력|전공",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"acamajNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},

			{Header:"학력사항|학력 학교 전공 졸업 본분교 주야간 편입 (입학년월~졸업년월)",	Type:"Html",	Hidden:1,	MinWidth:500,	Align:"Left",	ColMerge:0,	SaveName:"schoolHist",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	MultiLineText:1, ToolTip:1 },
			{Header:"경력사항|근무회사 (입사일~퇴사일,근무기간) 근무부서 직위 담당업무",	Type:"Html",	Hidden:1,	MinWidth:500,	Align:"Left",	ColMerge:0,	SaveName:"careerHist",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000,	MultiLineText:1, ToolTip:1 },
			{Header:"자격사항|자격면허 (취득일,갱신일,만료일) 발급기관 자격면허번호",		Type:"Html",	Hidden:1,	MinWidth:500,	Align:"Left",	ColMerge:0,	SaveName:"licenseHist",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, 	MultiLineText:1, ToolTip:1 },
			{Header:"포상사항|포상명 포상일자 포상기관 포상번호 포상사유",				Type:"Html",	Hidden:1,	MinWidth:500,	Align:"Left",	ColMerge:0,	SaveName:"prizeHist",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, 	MultiLineText:1, ToolTip:1 },
			{Header:"징계사항|징계명 (시작일~종료일) 징계기관 징계사유",				Type:"Html",	Hidden:1,	MinWidth:400,	Align:"Left",	ColMerge:0,	SaveName:"punishHist",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, 	MultiLineText:1, ToolTip:1 },

			{Header:"경력사항|타사",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"totAgreeYymmCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"경력사항|현재",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workYymmCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"경력사항|총경력",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"allCareerYymmCnt",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			//Hidden
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"jikgubNm"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"jikweeNm"},
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(1,"/common/images/icon/icon_o.png");
		sheet1.SetImageList(3,"/common/images/icon/icon_popup.png");

		//승진명부코드
		var pmtCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&", "queryId=getPromTargetMgrStdCdList", false).codeList, "");
		sheet1.SetColProperty("pmtCd", {ComboText:"|"+pmtCdList[0], ComboCode:"|"+pmtCdList[1]} );

		//직책코드
		var jikchakCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
		sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCdList[0], ComboCode:"|"+jikchakCdList[1]} );

		//직급코드
		var jikgubCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "전체");
		sheet1.SetColProperty("oldJikgubCd", {ComboText:"|"+jikgubCdList[0], ComboCode:"|"+jikgubCdList[1]} );

		//직위코드
		var jikweeCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "전체");
		sheet1.SetColProperty("oldJikweeCd", {ComboText:"|"+jikweeCdList[0], ComboCode:"|"+jikweeCdList[1]} );

		//승진직위
		sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCdList[0], ComboCode:"|"+jikweeCdList[1]} );

		//승진직급
		var userCd1 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");
		sheet1.SetColProperty("jikgubCd", {ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );

		//평가등급
		var appClassCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "P00001"), "");
		sheet1.SetColProperty("appClassCd1", {ComboText:"|"+appClassCdList[0], ComboCode:"|"+appClassCdList[1]} );
		sheet1.SetColProperty("appClassCd2", {ComboText:"|"+appClassCdList[0], ComboCode:"|"+appClassCdList[1]} );
		sheet1.SetColProperty("appClassCd3", {ComboText:"|"+appClassCdList[0], ComboCode:"|"+appClassCdList[1]} );
		sheet1.SetColProperty("appClassCd4", {ComboText:"|"+appClassCdList[0], ComboCode:"|"+appClassCdList[1]} );
		sheet1.SetColProperty("appClassCd5", {ComboText:"|"+appClassCdList[0], ComboCode:"|"+appClassCdList[1]} );
		sheet1.SetColProperty("appClassCd6", {ComboText:"|"+appClassCdList[0], ComboCode:"|"+appClassCdList[1]} );
		/* sheet1.SetColProperty("mboAppClassCd4", {ComboText:"|"+appClassCdList[0], ComboCode:"|"+appClassCdList[1]} );
		sheet1.SetColProperty("compAppClassCd4", {ComboText:"|"+appClassCdList[0], ComboCode:"|"+appClassCdList[1]} );
		sheet1.SetColProperty("mboAppClassCd5", {ComboText:"|"+appClassCdList[0], ComboCode:"|"+appClassCdList[1]} );
		sheet1.SetColProperty("compAppClassCd5", {ComboText:"|"+appClassCdList[0], ComboCode:"|"+appClassCdList[1]} ); */

		// 직종
		var positionCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20050"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("positionCd", {ComboText:"|"+positionCdList[0], ComboCode:"|"+positionCdList[1]} );

		//승진유형
		//sheet1.SetColProperty("pmtType", {ComboText:"|정기|조기|중도입사", ComboCode:"|A|B|C"} );
		sheet1.SetColProperty("pmtType", {ComboText:"|정기|조기", ComboCode:"|A|B"} );

		//최종학력
		var acaCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20130"), "");
		sheet1.SetColProperty("acaCd", 	{ComboText:"|"+acaCdList[0], ComboCode:"|"+acaCdList[1]} );

		//자격증취득여부(Y/N)
		sheet1.SetColProperty("licenseYn", {ComboText:"N|Y", ComboCode:"N|Y"} );

		//승진대상\n여부
		sheet1.SetColProperty("pmtTargetYn", {ComboText:"N|Y", ComboCode:"N|Y"} );


		//발령
		var TypeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeList&inOrdType=40,",false).codeList, "");
		sheet1.SetColProperty("ordTypeCd",       {ComboText:"|"+TypeCd[0], ComboCode:"|"+TypeCd[1]} );
		//발령상세
		/*
		var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordType=40&useYn=Y",false).codeList, "");
		sheet1.SetColProperty("ordDetailCd",       {ComboText:"|"+ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );
		*/
		/*
		 * 검색조건
		*/

		$("#searchPmtCd").html(pmtCdList[2]);

		//근무지
		/* var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");
		$("#searchLocationCd").html(locationCd[2]);
		$("#searchLocationCd").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
		}); */

		//직종
		var positionCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20050"), "");
		$("#searchPositionCd").html(positionCd[2]);
		$("#searchPositionCd").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
		});

		$("#searchCurrJikwee").html(jikweeCdList[2]);
		$("#searchTarJikwee").html(jikweeCdList[2]);

		$("#searchPmtCd,#searchCurrJikwee, #searchTarJikwee, #searchPmtTargetYn, #searchPmtCurrYearYn, #searchLicenseYn").on("change", function(e) {
			doAction1("Search");
		});

		$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchPhotoYn").on("click", function(e) {
			//doAction1("Search");
			if($("#searchPhotoYn").is(":checked") == true) {
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);

			} else {
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
				if( $("#searchInfoYn").is(":checked") == false){
					sheet1.SetDataRowHeight(60);
				}
			}
		});


		$("#searchInfoYn").on("click", function(e) {

			if($("#searchInfoYn").is(":checked") == true ) {
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("acaCd", 1);
				sheet1.SetColHidden("acaSchNm", 1);
				sheet1.SetColHidden("acamajNm", 1);
				sheet1.SetColHidden("schoolHist", 1);
				sheet1.SetColHidden("careerHist", 1);
				sheet1.SetColHidden("licenseHist", 1);
				sheet1.SetColHidden("prizeHist", 1);
				sheet1.SetColHidden("punishHist",1);
				if($("#searchPhotoYn").is(":checked") == true)  {
					sheet1.SetDataRowHeight(60);
				}

			} else {
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("acaCd", 0);
				sheet1.SetColHidden("acaSchNm", 0);
				sheet1.SetColHidden("acamajNm", 0);
				sheet1.SetColHidden("schoolHist", 0);
				sheet1.SetColHidden("careerHist", 0);
				sheet1.SetColHidden("licenseHist", 0);
				sheet1.SetColHidden("prizeHist", 0);
				sheet1.SetColHidden("punishHist",0);
			}
			//sheetResize();
		});

		//자동완성
		$(sheet1).sheetAutocomplete({
		  	Columns: [{ ColSaveName : "name" }]
		});

		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		sheet1.SetAutoRowHeight(0);
		sheet1.SetDataRowHeight(24);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#isDetYn").is(":checked"))
				$("#searchIsDetYn").val("Y");
			else
				$("#searchIsDetYn").val("N");

			/* if($("#isPassYn").is(":checked"))
				$("#searchIsPassYn").val("Y");
			else
				$("#searchIsPassYn").val("N"); */

			// 승진기준관리 대상년도를 기준으로 Header Text 변경(종합평가등급)
			var thrm440 = ajaxCall("${ctx}/PromStdMgr.do?cmd=getPromStdBaseYmdMap", "pmtCd="+$("#searchPmtCd").val(), false).DATA;

			var curYear = parseInt(thrm440.pmtYyyy);

			var year1Before = curYear -1;
			var year2Before = curYear -2;
			var year3Before = curYear -3;
			var year4Before = curYear -4;
			var year5Before = curYear -5;
			var year6Before = curYear -6;

			// 선택한 년도 매칭
			sheet1.SetCellText(1, "appClassCd1", year1Before+"년");
			sheet1.SetCellText(1, "appClassCd2", year2Before+"년");
			sheet1.SetCellText(1, "appClassCd3", year3Before+"년");
			sheet1.SetCellText(1, "appClassCd4", year4Before+"년");
			sheet1.SetCellText(1, "appClassCd5", year5Before+"년");
			sheet1.SetCellText(1, "appClassCd6", year6Before+"년");


			//$("#locationCd").val(($("#searchLocationCd").val()==null?"":getMultiSelect($("#searchLocationCd").val())));
			//$("#positionCd").val(($("#searchPositionCd").val()==null?"":getMultiSelect($("#searchPositionCd").val())));
			sheet1.DoSearch( "${ctx}/PromTargetMgr.do?cmd=getPromTargetMgrList", $("#mySheetForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"pmtCd|sabun", true, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PromTargetMgr.do?cmd=savePromTargetMgr", $("#mySheetForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SelectCell(row, "name");
			sheet1.SetCellValue(row, "pmtCd" , $("#searchPmtCd").val());
			break;
		case "Proc":
			if(!confirm("대상자를 생성 하시겠습니까? 기존 대상자는 삭제됩니다.")) {
				return;
			}

	    	var data = ajaxCall("/PromTargetMgr.do?cmd=prcPromTargetMgr", "pmtCd="+$("#searchPmtCd").val(), false);

	    	if(data.Result.Code == null) {
	    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
	    	} else {
		    	alert(data.Result.Message);
	    	}

	    	doAction1("Search");
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "승진대상자관리_" + d.getTime();
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				if(sheet1.GetCellValue(i, "ordTypeCd") !=""){
					var lOrdReasonCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd="+ sheet1.GetCellValue(i, "ordTypeCd"), false).codeList, " ");	//발령상세종류

					sheet1.InitCellProperty(i,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
				}
			}


			for(var i = sheet1.HeaderRows() ; i < sheet1.HeaderRows() + sheet1.RowCount() ; i++) {
				if(sheet1.GetCellValue(i, "pmtTargetYn") == "Y") {
					sheet1.SetRowBackColor(i, "#dbfdff");
				}
				if(sheet1.GetCellValue(i, "pmtYn") == "Y"  ) {
					sheet1.SetRowEditable(i, 0);
					sheet1.SetCellEditable(i,"prePostYn",1);
					sheet1.SetCellEditable(i,"pmtYn",1);
				}

				if(sheet1.GetCellValue(i, "prePostYn") == "Y"  ) {
					sheet1.SetRowEditable(i, 0);
				}

				if(sheet1.GetCellValue(i,"ordYn") == "Y") {
					sheet1.SetRowEditable(i,0);
				}
			}

			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnChange(Row, Col, Value){
		try{
			if( sheet1.ColSaveName(Col) == "ordTypeCd" ) {
				var lOrdReasonCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd="+ sheet1.GetCellValue(Row, "ordTypeCd"),false).codeList, " ");	//발령상세종류

				sheet1.InitCellProperty(Row,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
			}



		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}



	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "createRcpt") {
			doAction1('Search');
		} else if(pGubun == "sheetAutocomplete"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
			sheet1.SetCellValue(gPRow, "oldJikweeCd", rv["jikweeCd"]);
			sheet1.SetCellValue(gPRow, "jikgubCd", rv["jikgubCd"]);
			sheet1.SetCellValue(gPRow, "gempYmd", rv["gempYmd"]);
			sheet1.SetCellValue(gPRow, "empYmd", rv["empYmd"]);
			sheet1.SetCellValue(gPRow, "retYmd", rv["retYmd"]);
		}
	}


	function ordBatch(){

		if( sheet1.CheckedRows("prePostYn") == "0") {
			alert("<msg:txt mid='109724' mdef='선택된 자료가 없습니다.'/>");
			return;
		}

		var arrRow = sheet1.FindCheckedRow("prePostYn");
		var errRow = "";

		/* $(arrRow.split("|")).each(function(index,value){
			if(sheet1.GetCellValue(value,"applStatusCd") != 99) {
				errRow = value;
				return false;
			}
		}); */

		var dtlRow ="";
		var ymdRow ="";
		var pmtRow ="";

		$(arrRow.split("|")).each(function(index,value){
			if(sheet1.GetCellValue(value,"ordDetailCd") =="" ) {
				dtlRow = value-1;
				return false;

			}else if(sheet1.GetCellValue(value,"ordYmd") =="" ) {
				ymdRow = value-1;
				return false;

			}else if(sheet1.GetCellValue(value,"pmtYn") =="" ||sheet1.GetCellValue(value,"pmtYn") =="N" ) {
				pmtRow = value-1;
				return false;
			}
		});

		if(dtlRow != "") {
			alert(dtlRow+"행의 발령상세를 선택해주세요.");
			return;
		};
		if(ymdRow != "") {
			alert(ymdRow+"행의 발령일을 입력해주세요.");
			return;
		};

		if(pmtRow != "") {
			alert(pmtRow+"행의 승진 확정후 발령처리하십시오.");
			return;
		};


		if(errRow != "") {
			alert(errRow+"행은 결재완료 상태가 아닙니다.\n발령연계처리는 결재완료 상태에서만 가능합니다.");
			return;
		};

		if(!confirm("발령연계처리 하시겠습니까?")) {
			return;
		}
		IBS_SaveName(document.mySheetForm,sheet1);

		// 발령연계처리
		//var paramStr = setAppmtParamSet(POST_ITEMS, sheet1, null, $("#mySheetForm"));
		//sheet1.DoSave( "${ctx}/RecBasicInfoReg.do?cmd=saveRecBasicInfoRegNew", {Param:$("#mySheetForm").serialize()+paramStr+"&ordGubun=F",Quest:0});
		sheet1.DoSave( "${ctx}/OrdBatch.do?", {Param:$("#mySheetForm").serialize(), Quest:0});
	}


</script>

<style type="text/css">
	.sheet_search table tr:nth-child(2) td:nth-child(4) span::after {
		content:"";
	}

	.sheet_search table tr:nth-child(2) td:nth-child(4) span {
		margin-left:0px;
		margin-right:5px;
		font-weight:bold;
	}
</style>

</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="mySheetForm" name="mySheetForm" >
			<input type="hidden" id="searchIsDetYn" name="searchIsDetYn"/>
			<!-- <input type="hidden" id="searchIsPassYn" name="searchIsPassYn"/> -->
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>승진대상자<br>명부명</th>
							<td>
								<select name="searchPmtCd" id="searchPmtCd" class="box2"></select>
							</td>
							<th class="hide">근무지</th>
							<td class="hide">
								<select id="searchLocationCd" name="searchLocationCd" multiple></select>
								<input type="hidden" id="locationCd" name="locationCd" value=""/>
							</td>
							<th>소속</th>
							<td>
								<input type="text" id="searchOrgNm" name="searchOrgNm" class="text"/>
							</td>
							<th>사번/성명</th>
							<td colspan="2">
								<input type="text" id="searchSabunName" name="searchSabunName" class="text" />
							</td>
							<th>현직위</th>
							<td>
								<select name="searchCurrJikwee" id="searchCurrJikwee" class="box2"></select>
							</td>
							<th>승진직위</th>
							<td>
								<select name="searchTarJikwee" id="searchTarJikwee" class="box2"></select>
							</td>
						</tr>
						<tr>
							<th>승진포인트</th>
							<td>
								<input type="text" id="searchPmtAppPointFrom" name="searchPmtAppPointFrom" size="2" />&nbsp;~&nbsp;<input type="text" id="searchPmtAppPointTo" name="searchPmtAppPointTo" size="2"/>
							</td>
							<th>체류년한<br>충족여부</th>
							<td>
								<select name="searchPmtCurrYearYn" id="searchPmtCurrYearYn" class="box2">
									<option value=''>전체</option>
									<option value='Y'>Y</option>
									<option value='N'>N</option>
									<!-- <option value='R'>검토대상자(중도입사자)</option>	 -->
								</select>
							</td>
							<th class="hide">자격증<br>취득여부</th>
							<td class="hide">
								<select name="searchLicenseYn" id="searchLicenseYn" class="box2">
									<option value=''>전체</option>
									<option value='Y'>Y</option>
									<option value='N'>N</option>
									<!-- <option value='R'>검토대상자(중도입사자)</option>	 -->
								</select>
							</td>
							<th>승진<br>대상여부</th>
							<td>
								<select name="searchPmtTargetYn" id="searchPmtTargetYn" class="box2">
									<option value=''>전체</option>
									<option value='Y'>Y</option>
									<option value='N'>N</option>
									<!-- <option value='R'>검토대상자(중도입사자)</option>	 -->
								</select>
							</td>
							<td>
								<input type="checkbox" id="isDetYn" name="isDetYn" style="vertical-align:middle;"/>&nbsp;<span>승진확정여부</span>
							</td>
							<th><tit:txt mid='112988' mdef='사진포함<br>여부 '/></th>
							<td>
								<input id="searchPhotoYn" name="searchPhotoYn" type="checkbox" class="checkbox"/>
							</td>
							<th><tit:txt mid='112988' mdef='인사사항<br>숨기기'/></th>
							<td>
								<input id="searchInfoYn" name="searchInfoYn" type="checkbox" class="checkbox"/>
							</td>
							<td>
								<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='113242' mdef='승진대상자관리'/></li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
					<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
					<btn:a href="javascript:doAction1('Save');" css="btn soft authA" mid='save' mdef="저장"/>
					<btn:a href="javascript:ordBatch()" css="btn soft authA" mid='110765' mdef="발령연계처리"/>
					<btn:a href="javascript:doAction1('Proc');" id="btnSearch" css="btn filled authA" mid='userCre' mdef="대상자생성"/>
				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	</div>
</body>
</html>
