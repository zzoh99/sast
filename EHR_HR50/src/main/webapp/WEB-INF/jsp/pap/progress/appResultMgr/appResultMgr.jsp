<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	
	var classCdList         = null;		// 선택평가의 평가등급 코드 목록(TPAP110)
	var allClassCdList      = null;		// 전체평가등급(P00001)
	var allCompClassCdList  = null;		// 전체역량평가등급(P00002)
	var usedClassCdList     = null;		// 사용평가등급(P00001)
	var usedCompClassCdList = null;		// 사용평가등급(P00001)
	
	var colLength = 0;
	
	$(function() {
		
<c:if test="${ ssnGrpCd eq '30' || authPg eq 'R' }">
		$("#btnInsert").hide();
		$("#btnSave").hide();
</c:if>

//=========================================================================================================================================

		/*
		allClassCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), ""); // 전체평가등급(P00001)
		allCompClassCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00002"), ""); // 전체역량평가등급(P00002)
		usedClassCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y&visualYn=Y","P00001"), ""); // 사용평가등급(P00001)
		usedCompClassCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y&visualYn=Y","P00002"), ""); // 사용역량평가등급(P00002)
		*/

//=========================================================================================================================================
	
		var initdata = {};
		initdata.Cfg = {FrozenCol:8,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chk",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"\n확정\n여부|\n확정\n여부",	Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"confirmYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"성명|성명",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번|사번",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"호칭|호칭",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가소속|평가소속",		Type:"Popup",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직급|직급",			Type:"Text",	Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위|직위",			Type:"Text",	Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책|직책",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가그룹|1차",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appGroupNm1st",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가그룹|2차",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appGroupNm2nd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가그룹|3차",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appGroupNm3rd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가그룹|최종",		Type:"Popup",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appGroupNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"점수\n상세|점수\n상세",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"평간Sheet구분|평간Sheet구분",	Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSheetType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"평가방법|평가방법",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appMethodCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			
			// 본인평가
			{Header:"본인평가|업적점수 ",	Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"mboTAppSelfPoint",	KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"본인평가|역량점수 ",	Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"compTSelfPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"본인평가|업적등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"mboSelfClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"본인평가|역량등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"compSelfClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			// 1차평가
			{Header:"1차평가|업적점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"mboTApp1stPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"1차평가|역량점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"compT1stPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"1차평가|업적등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"mbo1stClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"1차평가|역량등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"comp1stClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"1차평가|종합등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"app1stClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			// 2차평가
			{Header:"2차평가|업적점수 ",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"mboTApp2ndPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"2차평가|역량점수 ",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"compT2ndPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"2차평가|업적등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"mbo2ndClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"2차평가|역량등급 ",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"comp2ndClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"2차평가|종합등급 ",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"app2ndClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			// 3차평가
			{Header:"3차평가|업적점수 ",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"mboTApp3rdPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"3차평가|역량점수 ",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"compT3rdPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"3차평가|업적등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"mbo3rdClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"3차평가|역량등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"comp3rdClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"3차평가|종합등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"app3rdClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			// 합산(반영비율적용)
			{Header:"합산|업적점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"mboAppSumPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"합산|역량점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"compAppSumPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"합산|합산점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"appSumPoint",			KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"합산|업적등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"mboAppSumClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"합산|역량등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"compAppSumClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"합산|합산등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"appSumClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			// 합산_부서이동
			{Header:"합산|업적점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"lastMboPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"합산|역량점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"lastCompPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"합산|합산점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"lastPoint",			KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"합산|업적등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"lastMboClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"합산|역량등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"lastCompClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"합산|합산등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"lastClassCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			// 조정
			{Header:"조정|업적점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"adtMboPoint",			KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"조정|역량점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"adtCompPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"조정|조정점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"adtPoint",			KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"조정|업적등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"adtMboClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"조정|역량등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"adtCompClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"조정|조정등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"adtClassCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			// 최종
			{Header:"최종|업적점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"finalMboPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"최종|역량점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"finalCompPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"최종|최종점수",		Type:"Float",	Hidden:1,	Width:90,	Align:"Right",	ColMerge:0,	SaveName:"finalPoint",			KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"최종|업적등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"finalMboClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"최종|역량등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"finalCompClassCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"최종|최종등급",		Type:"Combo",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"finalClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			
			{Header:"비고|비고",			Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"memo",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			
			{Header:"이의제기|이의제기",		Type:"Image",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail1", Cursor:"Pointer" },
			{Header:"이의제기|내용(업적)",	Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"protestMemoMbo",		KeyField:0, Edit:0},
			{Header:"이의제기|내용(역량)",	Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"protestMemoComp",		KeyField:0, Edit:0},
			{Header:"이의제기|허용시작일",	Type:"Date",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionSdate", Format:"Ymd"},
			{Header:"이의제기|허용종료일",	Type:"Date",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"exceptionEdate", Format:"Ymd"},
			
			// 사용안함
			{Header:"1차조정|업적점수",		Type:"Float",	Hidden:1,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"mboTAdt1stPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"1차조정|역량점수",		Type:"Float",	Hidden:1,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"compTAdt1stPoint",	KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"2차조정|업적점수",		Type:"Float",	Hidden:1,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"mboTAdt2ndPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			{Header:"2차조정|역량점수",		Type:"Float",	Hidden:1,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"compTAdt2ndPoint",	KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6,	MinimumValue:0,	MaximumValue:100.00},
			// 사용안함
			{Header:"조정|조정",			Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adt1stClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"조정|조정",			Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adt2ndClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"조정|조정",			Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adt3rdClassCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			// 사용안함
			{Header:"최종순위|KPI",		Type:"Int",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"mboAppRank",			KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:25},
			{Header:"최종순위|역량",		Type:"Int",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"compAppRank",			KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:25},
			{Header:"최종순위|종합",		Type:"Int",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appRank",			    KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:25},
			
			// Hidden 컬럼
			{Header:"평가그룹코드|평가그룹코드",	Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:1,	SaveName:"appGroupCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가ID|평가ID",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속코드|평가소속코드",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직급코드|직급코드",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직위코드|직위코드",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직책코드|직책코드",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직군코드|직군코드",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직군명|직군명",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"마지막평가차수|마지막평가차수",Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"lastAppSeqCd",KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		colLength = initdata.Cols.length;
		
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
        //sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_print.png");
		sheet1.SetDataLinkMouse("detail",1);
		sheet1.SetDataLinkMouse("detail1",1);

		var sheetTypeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20005"), "전체");
		var methodCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10006"), "전체");

		sheet1.SetColProperty("appSheetType"  , { ComboText : "|" + sheetTypeCdList[0],		ComboCode : "|" + sheetTypeCdList[1]    });
		sheet1.SetColProperty("appMethodCd"   , { ComboText : "|" + methodCdList[0], 		ComboCode : "|" + methodCdList[1]       });
		
		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name"      , rv["name"]);
						sheet1.SetCellValue(gPRow,"sabun"     , rv["sabun"]);
						sheet1.SetCellValue(gPRow,"orgNm"     , rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"orgCd"     , rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"appOrgCd"  , rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"appOrgNm"  , rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"jikchakCd" , rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow,"jikchakNm" , rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"jikweeCd"  , rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow,"jikweeNm"  , rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow,"jikgubCd"  , rv["jikgubCd"]);
						sheet1.SetCellValue(gPRow,"jikgubNm"  , rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow,"gempYmd"   , rv["gempYmd"]);
						sheet1.SetCellValue(gPRow,"empYmd"    , rv["empYmd"]);
						sheet1.SetCellValue(gPRow,"workType"  , rv["workType"]);
						sheet1.SetCellValue(gPRow,"workTypeNm", rv["workTypeNm"]);
					}
				}
			]
		});
		
		$("#searchAppSheetType").html(sheetTypeCdList[2]);
		$("#searchAppMethodCd").html(methodCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();
	});

	$(function() {
		// 조회조건 이벤트 등록
		$("#searchAppraisalCd").bind("change", function(event) {
			$("#searchCloseYn").val("");
			
			// 평가구분에 따른 업적,역량평가대상자여부 컬럼 출력 여부 설정
			var appTypeCd = $(this).val().substring(2,3);
			$("#searchAppTypeCd").val(appTypeCd);
			
			var mboHdn = 0;
			var compHdn = 0;
			var totHdn = 0;
			
			if (appTypeCd == "C") {			// 종합평가
				//mboHdn = 0;
				mboHdn = 1;
				//compHdn = 0;
				compHdn = 1;
				totHdn = 0;
			} else if (appTypeCd == "A") {	// 성과평가
				mboHdn = 0;
				compHdn = 1;
				totHdn = 1;
			} else if (appTypeCd == "B") {	// 역량평가
				mboHdn = 1;
				compHdn = 0;
				totHdn = 1;
			}
			
			//-------------------------------- 본인평가 --------------------------------
			sheet1.SetColHidden("mboTAppSelfPoint",		mboHdn & totHdn);	// 본인평가|업적점수
			sheet1.SetColHidden("compTSelfPoint",		compHdn & totHdn);	// 본인평가|역량점수
			sheet1.SetColHidden("mboSelfClassCd",		mboHdn);	// 본인평가|업적등급
			sheet1.SetColHidden("compSelfClassCd",		compHdn);	// 본인평가|역량등급
			
			//-------------------------------- 1차평가 --------------------------------
			sheet1.SetColHidden("mboTApp1stPoint",		mboHdn & totHdn);	// 1차평가|업적점수
			sheet1.SetColHidden("compT1stPoint",		compHdn & totHdn);	// 1차평가|역량점수
			sheet1.SetColHidden("mbo1stClassCd",		mboHdn);	// 1차평가|업적등급
			sheet1.SetColHidden("comp1stClassCd",		compHdn);	// 1차평가|역량등급
			sheet1.SetColHidden("app1stClassCd",		1);	// 1차평가|종합등급
			
			//-------------------------------- 2차평가 --------------------------------
			sheet1.SetColHidden("mboTApp2ndPoint",		mboHdn & totHdn);	// 2차평가|업적점수
			sheet1.SetColHidden("compT2ndPoint",		compHdn & totHdn);	// 2차평가|역량점수
			sheet1.SetColHidden("mbo2ndClassCd",		mboHdn);	// 2차평가|업적등급
			sheet1.SetColHidden("comp2ndClassCd",		compHdn);	// 2차평가|역량등급
			sheet1.SetColHidden("app2ndClassCd",		1);	// 2차평가|종합등급
			
			//-------------------------------- 3차평가 --------------------------------
			sheet1.SetColHidden("mboTApp3rdPoint",		mboHdn & totHdn);	// 3차평가|업적점수
			sheet1.SetColHidden("compT3rdPoint",		compHdn & totHdn);	// 3차평가|역량점수
			sheet1.SetColHidden("mbo3rdClassCd",		mboHdn);	// 3차평가|업적등급
			sheet1.SetColHidden("comp3rdClassCd",		compHdn);	// 3차평가|역량등급
			sheet1.SetColHidden("app3rdClassCd",		1);	// 3차평가|종합등급
			
			//-------------------------------- 합산(반영비율적용) --------------------------------
			sheet1.SetColHidden("mboAppSumPoint",		1);	// 합산|업적점수
			sheet1.SetColHidden("compAppSumPoint",		1);	// 합산|역량점수
			sheet1.SetColHidden("appSumPoint",			1);	// 합산|종합점수
			sheet1.SetColHidden("mboAppSumClassCd",		1);	// 합산|업적등급
			sheet1.SetColHidden("compAppSumClassCd",	1);	// 합산|역량등급
			sheet1.SetColHidden("appSumClassCd",		1);	// 합산|종합등급
			
			//-------------------------------- 합산_부서이동 --------------------------------
			sheet1.SetColHidden("lastMboPoint",			mboHdn);	// 합산|업적점수
			sheet1.SetColHidden("lastCompPoint",		compHdn);	// 합산|역량점수
			sheet1.SetColHidden("lastPoint",			totHdn);	// 합산|종합점수
			sheet1.SetColHidden("lastMboClassCd",		mboHdn);	// 합산|업적등급
			sheet1.SetColHidden("lastCompClassCd",		compHdn);	// 합산|역량등급
			//sheet1.SetColHidden("lastClassCd",			totHdn);	// 합산|종합등급
			
			//-------------------------------- 조정 --------------------------------
			sheet1.SetColHidden("adtMboPoint",			mboHdn);	// 조정|업적점수
			sheet1.SetColHidden("adtCompPoint",			compHdn);	// 조정|역량점수
			sheet1.SetColHidden("adtPoint",				totHdn);	// 조정|종합점수
			sheet1.SetColHidden("adtMboClassCd",		mboHdn);	// 조정|업적등급
			sheet1.SetColHidden("adtCompClassCd",		compHdn);	// 조정|역량등급
			//sheet1.SetColHidden("adtClassCd",			totHdn);	// 조정|종합등급
			
			//-------------------------------- 최종 --------------------------------
			sheet1.SetColHidden("finalMboPoint",		mboHdn);	// 최종|업적점수
			sheet1.SetColHidden("finalCompPoint",		compHdn);	// 최종|역량점수
			sheet1.SetColHidden("finalPoint",			totHdn);	// 최종|종합점수
			sheet1.SetColHidden("finalMboClassCd",		mboHdn);	// 최종|업적등급
			sheet1.SetColHidden("finalCompClassCd",		compHdn);	// 최종|역량등급
			//sheet1.SetColHidden("finalClassCd",			totHdn);	// 최종|종합등급
			
			var data = ajaxCall("${ctx}/AppResultMgr.do?cmd=getAppResultMgrMap", $("#srchFrm").serialize(), false);
			
			if (data != null && data.map != null) {
				$("#searchCloseYn").val(data.map.closeYn);
			}
			
			/*
			//var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, " ");
			var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppGradeRateStdClassItemListForCode&searchAppraisalCd=" + $("#searchAppraisalCd").val(), false).codeList, "");
			var comboTextList = "";
			var comboCodeList = "";
			
			if(classCdList[0] != "") {
				comboTextList = classCdList[0];
				comboCodeList = classCdList[1];
			} else {
				// 역량평가인 경우
				if(appTypeCd == "B") {
					comboTextList = allCompClassCdList[0];
					comboCodeList = allCompClassCdList[1];
				} else {
					comboTextList = allClassCdList[0];
					comboCodeList = allClassCdList[1];
				}
			}
			*/

			// 평가등급코드 조회 Start
			var classCdListsParam = "queryId=getAppClassMgrCdListBySeq&searchAppStepCd=5";
				classCdListsParam += "&searchAppraisalCd=" + $(this).val();
				classCdListsParam += "&searchAppTypeCd=" + $("#searchAppTypeCd").val();
			classCdList = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", classCdListsParam, false).codeList, "");
			
			//-------------------------------- 본인평가 --------------------------------
			sheet1.SetColProperty("mboSelfClassCd"   , { ComboText : "|"+classCdList["0"][0], ComboCode : "|"+classCdList["0"][1] });
			sheet1.SetColProperty("compSelfClassCd"  , { ComboText : "|"+classCdList["0"][0], ComboCode : "|"+classCdList["0"][1] });
			
			//-------------------------------- 1차평가 --------------------------------
			sheet1.SetColProperty("mbo1stClassCd"    , { ComboText : "|"+classCdList["1"][0], ComboCode : "|"+classCdList["1"][1] });
			sheet1.SetColProperty("comp1stClassCd"   , { ComboText : "|"+classCdList["1"][0], ComboCode : "|"+classCdList["1"][1] });
			sheet1.SetColProperty("app1stClassCd"    , { ComboText : "|"+classCdList["1"][0], ComboCode : "|"+classCdList["1"][1] });
			
			//-------------------------------- 2차평가 --------------------------------
			sheet1.SetColProperty("mbo2ndClassCd"    , { ComboText : "|"+classCdList["2"][0], ComboCode : "|"+classCdList["2"][1] });
			sheet1.SetColProperty("comp2ndClassCd"   , { ComboText : "|"+classCdList["2"][0], ComboCode : "|"+classCdList["2"][1] });
			sheet1.SetColProperty("app2ndClassCd"    , { ComboText : "|"+classCdList["2"][0], ComboCode : "|"+classCdList["2"][1] });
			
			//-------------------------------- 3차평가 --------------------------------
			sheet1.SetColProperty("mbo3rdClassCd"    , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			sheet1.SetColProperty("comp3rdClassCd"   , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			sheet1.SetColProperty("app3rdClassCd"    , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			
			//-------------------------------- 합산(반영비율적용) --------------------------------
			sheet1.SetColProperty("mboAppSumClassCd" , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			sheet1.SetColProperty("compAppSumClassCd", { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			sheet1.SetColProperty("appSumClassCd"    , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			
			//-------------------------------- 합산_부서이동 --------------------------------
			sheet1.SetColProperty("lastMboClassCd"   , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			sheet1.SetColProperty("lastCompClassCd"  , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			sheet1.SetColProperty("lastClassCd"      , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			
			//-------------------------------- 조정 --------------------------------
			sheet1.SetColProperty("adtMboClassCd"    , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			sheet1.SetColProperty("adtCompClassCd"   , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			sheet1.SetColProperty("adtClassCd"       , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			
			//-------------------------------- 최종 --------------------------------
			sheet1.SetColProperty("finalMboClassCd"  , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			sheet1.SetColProperty("finalCompClassCd" , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			sheet1.SetColProperty("finalClassCd"     , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			
			//-------------------------------- 사용안함 --------------------------------
			sheet1.SetColProperty("adt1stClassCd"    , { ComboText : "|"+classCdList["1"][0], ComboCode : "|"+classCdList["1"][1] });
			sheet1.SetColProperty("adt2ndClassCd"    , { ComboText : "|"+classCdList["2"][0], ComboCode : "|"+classCdList["2"][1] });
			sheet1.SetColProperty("adt3rdClassCd"    , { ComboText : "|"+classCdList["6"][0], ComboCode : "|"+classCdList["6"][1] });
			
			setAppGroupCdCombo();
		});

		$("#searchAppGroupCd").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchAppMethodCd, #searchAppSheetType, #searchProtestYn").change(function(){
			doAction1("Search");
		});

		$("#searchNameSabun, #searchAppOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		//평가코드
		var appraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCd[2]);
		$("#searchAppraisalCd").change();
		
	});

	//평가소속 setting(평가명 change, 성명 팝업 선택 후)
	function setAppGroupCdCombo() {
		$("#searchAppGroupCd").html("");
		
		var param = "queryId=getAppGroupCdList&searchAppraisalCd="+$("#searchAppraisalCd").val();
		param += "&searchAppStepCd=5";
		//param += "&searchAppSeqCd=2";
		
<c:if test="${ ssnGrpCd eq '30' || authPg eq 'R' }">
		param += "&searchAppSabun=${ssnSabun}";
</c:if>

		var appGroupCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&", param, false).codeList, "전체");

		$("#searchAppGroupCd").html(appGroupCdList[2]);
		$("#searchAppGroupCd").change();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			
			var param = $("#srchFrm").serialize();
<c:if test="${ ssnGrpCd eq '30' || authPg eq 'R' }">
			param += "&searchAppGroupByAppSabunYn=Y";
</c:if>
			sheet1.DoSearch( "${ctx}/AppResultMgr.do?cmd=getAppResultMgrList", param );
			break;
		case "Save":
			if ( $("#searchCloseYn").val() == "Y" ) {
				alert("해당 평가가 마감되었습니다.");
				return;
			}
			if(sheet1.FindStatusRow("I") != ""){
				if(!dupChk(sheet1,"appraisalCd|sabun|appOrgCd", true, true)){break;}
			}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AppResultMgr.do?cmd=saveAppResultMgr", $("#srchFrm").serialize());
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "appraisalCd",	$("#searchAppraisalCd").val());
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "Print": //출력
			rdPopup();
			break;
		}
	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(){
		if(!isPopup()) {return;}

		var w 		= 1200;
		var h 		= 950;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		var rdMrd   = "pap/progress/AppReport_HR.mrd";
		var rdTitle = "평가출력물";
		var rdParam = "";

		var searchAppraisalCdSAbunAppOrgCd_s = "";

		for ( var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++ ) {
			if ( sheet1.GetCellValue(i, "chk") == 0 ) continue;
			searchAppraisalCdSAbunAppOrgCd_s = searchAppraisalCdSAbunAppOrgCd_s + "('" + $("#searchAppraisalCd").val() + "', '"+ sheet1.GetCellValue(i, "sabun") +"', '"+ sheet1.GetCellValue(i, "appOrgCd") +"'),";
		}

		if ( searchAppraisalCdSAbunAppOrgCd_s == "" ) {
			alert("선택된 피평가자가 없습니다.");
			return;
		}

		searchAppraisalCdSAbunAppOrgCd_s = searchAppraisalCdSAbunAppOrgCd_s.substr(0, searchAppraisalCdSAbunAppOrgCd_s.length-1);

		rdParam  = rdParam +"[${ssnEnterCd}] "; //회사코드
		rdParam  = rdParam +"[5] "; //단계
		rdParam  = rdParam +"[6] "; //차수
		rdParam  = rdParam +"["+ searchAppraisalCdSAbunAppOrgCd_s +"] "; //피평가자 사번, 평가소속
		rdParam  = rdParam +"[Y] "; //최종결과출력

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

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			if($("#searchCloseYn").val() == "Y") {
				for(var i = 0; i < sheet1.LastCol(); i++) {
					if(i != 3) {
						sheet1.SetColEditable(i,false);
					}
				}
			} else {
				// 평가구분에 따른 업적,역량평가대상자여부 컬럼 출력 여부 설정
				var appTypeCd = $("#searchAppraisalCd").val().substring(2,3);
				for (var i = sheet1.HeaderRows(); i < sheet1.RowCount() + sheet1.HeaderRows(); i++) {
					if(sheet1.GetCellValue(i, "confirmYn") == "Y") {
						for(var j = 0; j < sheet1.LastCol(); j++) {
							if(j != 3) {
								sheet1.SetCellEditable(i,j,false);
							}
						}
					}
				}
			}
			
<c:if test="${ ssnGrpCd eq '30' || authPg eq 'R' }">
			if( sheet1.RowCount() > 0 ) {
				sheet1.SetEditable(true);
				sheet1.SetColHidden([
				    {Col: "sDelete", Hidden:1},
				    {Col: "sStatus", Hidden:1},
				    {Col: "confirmYn", Hidden:1}
				]);

				for(var j = 0; j < colLength; j++) {
					//console.log( sheet1.GetColHidden(j) + ", " + sheet1.GetCellEditable(i, j) );
					if( sheet1.GetColHidden(j) == 0 && sheet1.GetColEditable(j) == 1 ) {
						if( sheet1.ColSaveName(0, j) != "chk" ) {
							sheet1.SetColEditable(j, 0);
						}
					}
				}
			}
</c:if>

			//sheetResize();
			sheet1.FitColWidth();
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
			if ( Code != "-1" ) doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function chkdate(Row){
        var date = new Date();
        /* 날짜 테스트용 */
        //date = makeDateFormat("2017-06-25");

        if(makeDateFormat(sheet1.GetCellValue(Row, "exceptionSdate")) != false && makeDateFormat(sheet1.GetCellValue(Row, "exceptionEdate")) != false) {
            if (date < makeDateFormat(sheet1.GetCellValue(Row, "exceptionSdate"))) {
                alert("이의제기 피드백은 허용시작일 이전에 작성 할 수 없습니다.");
                return 0;
            } else if (date > makeDateFormat(sheet1.GetCellValue(Row, "exceptionEdate"))) {
                alert("확인 및 입력할 수 있는 기간이 아닙니다!");
                return 0;
            }
        }else{
            alert("이의제기 허용시작일 또는 종료일이 없습니다.\n관리자에게 문의하세요.");
            return 0;
        }
        return 2;
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet1.ColSaveName(Col) == "detail" && sheet1.GetCellValue(Row, "sStatus") != "I" ){
				if(!isPopup()) {return;}
				var args = new Array();
				args["searchAppraisalCd"] = sheet1.GetCellValue(Row, "appraisalCd");
				args["searchSabun"] = sheet1.GetCellValue(Row, "sabun");
				gPRow = Row;
				pGubun = "appResultMgrDetailPopup";
				openPopup("${ctx}/AppResultMgr.do?cmd=viewAppResultMgrDetailPopup", args, "1470","450");

			}else if(sheet1.ColSaveName(Col) == "detail1"){
                if(!isPopup()) {return;}
                var protestYn;
                var protestFeedBackYn;
				var saveBtnYn;

                var chk = chkdate(Row);
                if(chk == 0){
                    return;
                }else if(chk == 1){
                    protestYn			= 'N'
                    protestFeedBackYn	= 'N'
                    saveBtnYn			= 'N'
                }else if(chk == 2){
                    protestYn			= 'N'
                    protestFeedBackYn	= 'Y'
                    saveBtnYn			= 'Y'
                }

                var url = "${ctx}/AppFeedBackLst.do?cmd=viewAppFeedBackLstComment";
                var args = new Array();

                args["searchAppraisalCd"] 		= sheet1.GetCellValue(Row, "appraisalCd");
                args["searchSabun"]       		= sheet1.GetCellValue(Row, "sabun");
                args["searchAppOrgCd"]    		= sheet1.GetCellValue(Row, "appOrgCd");
                args["protestYn"]         		= protestYn;
                args["protestMemoMbo"]       	= sheet1.GetCellValue(Row, "protestMemoMbo");
                args["protestMemoComp"]       	= sheet1.GetCellValue(Row, "protestMemoComp");
                args["protestMemoFeedBackYn"]   = protestFeedBackYn;
                args["saveBtnYn"]   			= saveBtnYn;

                gPRow = "";
                pGubun = "apFeedBackLstCommentView";
                openPopup(url,args,500,850);
            }
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{
			if( sheet1.ColSaveName(Col) == "appOrgNm" ) {

				if(!isPopup()) {return;}

				var args	= new Array();
				args["searchAppraisalCd"] 	= $("#searchAppraisalCd").val();
				args["searchAppStepCd"] 	= "5";

				let layerModal = new window.top.document.LayerModal({
					id : 'orgBasicPapCreateLayer'
					, url : '/AppPeopleMgr.do?cmd=viewOrgBasicPapCreateLayer'
					, parameters : args
					, width : 680
					, height : 520
					, title : '조직 리스트 조회'
					, trigger :[
						{
							name : 'orgBasicPapCreateLayerTrigger'
							, callback : function(rv){
								sheet1.SetCellValue(Row,"appOrgNm",(rv["orgNm"]));
								sheet1.SetCellValue(Row,"appOrgCd",(rv["orgCd"]));
							}
						}
					]
				});
				layerModal.show();
			} else if( sheet1.ColSaveName(Col) == "appGroupNm" ) {
				if(!isPopup()) {return;}

				var args = new Array();
				args["searchAppraisalCd"] = sheet1.GetCellValue(Row, "appraisalCd");
				args["searchAppSeqCd"] = sheet1.GetCellValue(Row, "lastAppSeqCd");
				//args["searchAppSeqCd"] = "2";

				let modalLayer = new window.top.document.LayerModal({
					id: 'appPeopleMgrLayer',
					url: '${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleMgrLayer',
					parameters: args,
					width: 500,
					height: 600,
					title: '평가그룹조회',
					trigger: [
						{
							name: 'appPeopleMgrLayerTrigger',
							callback: function(rv) {
								sheet1.SetCellValue(Row,"appGroupCd",(rv["appGroupCd"]));
								sheet1.SetCellValue(Row,"appGroupNm",(rv["appGroupNm"]));
							}
						}
					]
				});
				modalLayer.show();
			}

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 소속 팝업
	function orgSearchPopup() {
		if(!isPopup()) {return;}

		let orgLayer = new window.top.document.LayerModal({
			id : 'orgLayer'
			, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R'
			, parameters : {}
			, width : 840
			, height : 800
			, title : '조직 리스트 조회'
			, trigger :[
				{
					name : 'orgTrigger'
					, callback : function(result) {
						if (result && result[0]) {
							$("#searchAppOrgCd").val(result[0].orgCd);
							$("#searchAppOrgNm").val(result[0].orgNm);
							doAction1("Search");
						} else {
							$("#searchAppOrgCd").val("");
							$("#searchAppOrgNm").val("");
						}
					}
				}
			]
		});
		orgLayer.show();

	}

	function grpPopup() {
		if(!isPopup()) {return;}

		var args = new Array();
		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		args["searchAppSeqCd"] = "2";

		gPRow = "";
		pGubun = "appResultMgrGrpPopup";

		openPopup("${ctx}/AppResultMgr.do?cmd=viewAppResultMgrGrpPopup", args, "840","450");
	}

	// 평가등급 복사
	function copyClassCd(sAction, type) {
		switch (sAction) {
		case "Copy":
			var sourceClassCol = $("#sourceClassCol").val();
			var targetClassCol = $("#targetClassCol").val();
			
			if( sourceClassCol != "" && targetClassCol != "" ) {
				if( sourceClassCol != targetClassCol ) {
					for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
						sheet1.SetCellValue(i, targetClassCol, sheet1.GetCellValue(i, sourceClassCol));
					}
				} else {
					alert("원본과 복사대상이 동일합니다.");
				}
			}
			
			break;
		case "Adt":
			if(confirm("평가가 2차까지 시행된 경우 2차평가등급이, 3차까지 시행된 경우 3차평가등급이 조정평가등급으로 복사됩니다.\n\n진행하시겠습니까?")) {
				var mbo2ndClassCd, mbo3rdClassCd = "";
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
					mbo2ndClassCd = sheet1.GetCellValue(i, "mbo2ndClassCd");
					mbo3rdClassCd = sheet1.GetCellValue(i, "mbo3rdClassCd");
					
					if( mbo3rdClassCd != "" ) {
						sheet1.SetCellValue(i, "adtClassCd", mbo3rdClassCd);
					} else if( mbo2ndClassCd != "" ) {
						sheet1.SetCellValue(i, "adtClassCd", mbo2ndClassCd);
						
					}
				}
			}
			break;
		case "Final":
			if(confirm("평가가 2차까지 시행된 경우 2차평가등급이, 3차까지 시행된 경우 3차평가등급이 최종평가등급으로 복사됩니다.\n\n진행하시겠습니까?")) {
				var mbo2ndClassCd, mbo3rdClassCd = "";
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
					mbo2ndClassCd = sheet1.GetCellValue(i, "mbo2ndClassCd");
					mbo3rdClassCd = sheet1.GetCellValue(i, "mbo3rdClassCd");
					
					if( mbo3rdClassCd != "" ) {
						sheet1.SetCellValue(i, "finalClassCd", mbo3rdClassCd);
					} else if( mbo2ndClassCd != "" ) {
						sheet1.SetCellValue(i, "finalClassCd", mbo2ndClassCd);
						
					}
				}
			}
			break;
		}		
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchCloseYn" name="searchCloseYn" />
		<input type="hidden" id="searchAppTypeCd" name="searchAppTypeCd" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd">
							</select>
						</td>
						<td class="hide">
							<span>소속 </span>
							<input id="searchAppOrgCd" name ="searchAppOrgCd" type="hidden" class="text" readOnly />
							<!-- <input id="searchAppOrgNm" name ="searchAppOrgNm" type="text" class="text readonly" readOnly /> -->
							<a onclick="javascript:orgSearchPopup('primary');" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchAppOrgCd,#searchAppOrgNm').val('');" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td>
							<span class="w45">소속</span>
							<input id="searchAppOrgNm" name="searchAppOrgNm" type="text" class="text" />
						</td>
						<td>
							<span>성명/사번</span>
							<input id="searchNameSabun" name="searchNameSabun" type="text" class="text" />
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>
							<span>평가그룹 </span>
							<select id="searchAppGroupCd" name="searchAppGroupCd"></select>
						</td>
						<td class="hide">
							<span>평가방법</span>
							<select name="searchAppMethodCd" id="searchAppMethodCd">
							</select>
						</td>
						<td class="hide">
							<span>평가Sheet구분</span>
							<select name="searchAppSheetType" id="searchAppSheetType">
							</select>
						</td>
						<td>
							<span>이의제기</span>
							<select name="searchProtestYn" id="searchProtestYn">
							<option value="">전체</option>
							<option value="Y">Y</option>
							<option value="N">N</option>
							</select>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
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
							<li id="txt" class="txt">평가결과관리</li>
							<li class="btn">
<%-- 무신사 추가 평가등급 복사 Start --%>
<c:if test="${ ssnGrpCd ne '30' && authPg eq 'A'}">
<%--
								<span class="f_point f_bold">평가등급복사</span>
								<select id="sourceClassCol" name="sourceClassCol">
									<option value="mbo1stClassCd">1차</option>
									<option value="mbo2ndClassCd">2차</option>
									<option value="mbo3rdClassCd" selected="selected">3차</option>
									<option value="adtClassCd">조정</option>
									<option value="finalClassCd">최종</option>
								</select>
								→
								<select id="targetClassCol" name="targetClassCol">
									<option value="mbo1stClassCd">1차</option>
									<option value="mbo2ndClassCd">2차</option>
									<option value="mbo3rdClassCd">3차</option>
									<option value="adtClassCd" selected="selected">조정</option>
									<option value="finalClassCd">최종</option>
								</select>
								<a href="javascript:copyClassCd('Copy')" 	class="basic authA" id="btnCopyClassCd">등급일괄복사</a>
								<a href="javascript:copyClassCd('Adt')" 	class="basic authA" id="btnCopyClassCdAdt">등급복사(조정)</a>
								<a href="javascript:copyClassCd('Final')" 	class="button authA" id="btnCopyClassCdFinal">등급복사(최종)</a>
--%>
</c:if>
<%-- End 무신사 추가 평가등급 복사 --%>
								<!--a href="javascript:grpPopup();" 		class="button authA">평가그룹결과</a-->
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
								<a href="javascript:doAction1('Insert')" 		class="btn outline_gray authA" id="btnInsert">입력</a>
								<a href="javascript:doAction1('Print')" 		class="btn outline_gray authR">출력</a>
								<a href="javascript:doAction1('Save')" 			class="btn filled authA" id="btnSave">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>