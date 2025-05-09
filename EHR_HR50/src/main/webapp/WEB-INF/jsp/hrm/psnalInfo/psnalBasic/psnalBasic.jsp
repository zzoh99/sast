<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html> <head> <title><tit:txt mid='104039' mdef='인사기본(기본)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>
<script src="/assets/js/utility-script.js?ver=7"></script>
<script type="text/javascript">
	$(function() {
	 	// 사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		// WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래스를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm100"] = sheet1;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='nameV1' mdef='한글성명'/>",										Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='cname' mdef='한자성명'/>",										Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nameCn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ename1' mdef='영문성명'/>",										Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nameUs",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='workYymmCnt' mdef='근속년수'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workYymmCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='totAgreeYymmCnt' mdef='인정년수'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"totAgreeYymmCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='allCareerYymmCnt' mdef='총경력년수'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"allCareerYymmCnt",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='stfType' mdef='채용구분'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"stfType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='stfTypeNm' mdef='채용구분명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"stfTypeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='empType' mdef='입사구분'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='empTypeNm' mdef='입사구분명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empTypeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='traYmd' mdef='면수습일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"traYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='retYmd' mdef='퇴직일'/>",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"<sht:txt mid='memo2' mdef='퇴직사유'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resignReasonNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='famres' mdef='주민등록번호'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sexType' mdef='성별코드'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sexType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sexTypeNm' mdef='성별명'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sexTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='birYmd' mdef='생년월일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='lunType' mdef='음력양력코드'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"lunType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='lunTypeNm' mdef='음력양력코드명'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"lunTypeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='bloodCd' mdef='혈액형'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bloodCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='bloodNm' mdef='혈액형명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bloodNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='wedYn' mdef='결혼여부'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wedYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='wedYnNm' mdef='결혼여부명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wedYnNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='wedYmd' mdef='결혼기념일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wedYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='foreignYn' mdef='외국인여부'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"foreignYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='nationalCd' mdef='국적코드'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='nationalNm' mdef='국적명'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='relCd' mdef='종교'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"relCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='relNm' mdef='종교명'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"relNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='hobby' mdef='취미'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hobby",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='specialityNote' mdef='특기'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"specialityNote",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"<sht:txt mid='gunYn' mdef='군필여부'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gunYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='daltonismCd' mdef='색신'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"daltonismCd"		,KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='daltonismNm' mdef='색신명'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"daltonismNm"		,KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			//{Header:"<sht:txt mid='endWorkDate' mdef='정년도래일'/>",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"endWorkDate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			//{Header:"<sht:txt mid='base1Yn' mdef='운항등급'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			//{Header:"<sht:txt mid='base2Yn' mdef='방송등급'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			//{Header:"<sht:txt mid='base3Yn' mdef='기준여부3'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			//{Header:"<sht:txt mid='base2Cd' mdef='어학특기'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			//{Header:"<sht:txt mid='base3Cd' mdef='정비특기'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='base1Nm' mdef='직급년차_인정년수'/>",	Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			//{Header:"<sht:txt mid='base2Nm' mdef='특수공항자격'/>",	Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base2Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			//{Header:"<sht:txt mid='base3Nm' mdef='기준설명3'/>",		Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Nm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
/*
			   firYmd             "최초입사일",
			 , jikgubYmd          "직급승진일(직급기산일)",
			 , orgMoveYmd         "부서배치일(조회성)",
			 , yearYmd            "연차기산일",
			 , rmidYmd            "퇴직금기산일",
			 , firRmidYmd         "최초퇴직금기산일",
			 , jobYmd             "직무담당일(조회성)",
			 , positionYmd        "보직임명일(조회성)",
			 , executiveYmd       "임원선임일",
			 , conRYmd            "계약시작일",
			 , conEYmd            "계약만료일",
			 , bloodCd            "혈액형(SELECTBOX)
			 , ht                 "신장",
			 , wt                 "체중",
			 , hobby              "취미",
			 , specialityNote     "특기",
			 , relNm              "종교",
			 , eyeL               "시력 좌",
			 , eyeR               "시력 우",
			 , unionYn            "노조가입여부(조회성)",
			 , clubYn             "동호회가입여부(조회성)",
*/

// 추가 STart
			{Header:"최초입사일",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"firYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"직급승진일(직급기산일)",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"부서배치일",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgMoveYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='yearYmd' mdef='연차기산일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"yearYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='rmidYmd_V1' mdef='퇴직금기산일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"rmidYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"최초퇴직금기산일",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"firRmidYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"직무담당일(조회성)",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"보직임명일(조회성)",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"positionYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"임원선임일",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"executiveYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='contractSymd_V796' mdef='계약시작일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"conRYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"계약만료일",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"conEYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"혈액형(SELECTBOX) ",		Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bloodCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='a1101' mdef='신장'/>",					Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ht",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='a1102' mdef='체중'/>",					Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wt",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='hobby' mdef='취미'/>",					Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hobby",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='specialityNote' mdef='특기'/>",					Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"specialityNote",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='relCd' mdef='종교'/>",					Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"relNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"시력 좌",					Type:"Float",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeL",			KeyField:0,	Format:"",		PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"시력 우",					Type:"Float",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eyeR",			KeyField:0,	Format:"",		PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },

// 추가 end

		// JY 추가
		{Header:"입사시학력",				Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empAcaCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"최종학력",					Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"finalAcaCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"최종학교명",				Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"finalSchNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"최종전공명",				Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"finalAcamajNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"입사인정경력(직급명)",		Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1CdNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"정규직전환일",				Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ftWorkYmd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"현 부서배치일",			Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"임금피크제 여부",			Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"peakYn",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"임금피크제 적용일",		Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"peakYmd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"보훈여부",					Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bohunYn",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"장애여부",					Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jangYn",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"노조가입여부(조회성)",		Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"unionYn",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"사우회가입여부",			Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empAccYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"동호회가입여부",			Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"clubYn",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"비상연락망(관계)",			Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gpAddr",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"비상연락망(연락처)",		Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"scAddr",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"비상연락망(성명)",			Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nmAddr",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"회사이메일",				Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"imAddr",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='resignReasonCdV1' mdef='퇴직사유코드'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resignReasonCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='base1CdV1' mdef='직급년차_인정직급'/>",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base1Cd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"나이",						Type:"text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"age",					KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

		//조직사항
		{Header:"<sht:txt mid='orgNm' mdef='소속'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='jikweeNm' mdef='직위'/>",			Type:"Text",	Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='jikchakNm' mdef='직책'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",			Type:"Text",	Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"rk",			Type:"Text",	Hidden:1,	 	SaveName:"rk",		}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		//sheet1.SetFocusAfterProcess(0);

		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		$("#hdnEnterCd").val($("#searchUserEnterCd",parent.document).val());

		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			$("#btnSave").hide();
		}

		var enterCd = "&enterCd="+$("#hdnEnterCd").val();

		//공통코드 한번에 조회
		var grpCds = "H00010,H20290,H40100,F10001,H20460,H20350,H20337,H00030,F10003,H20010,H90014,H90015";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds + enterCd,false).codeList, " ");

		var userCd1 = codeLists["H00010"]; //남/여 구분(1:남 2:여)
		var userCd2 = codeLists["H20290"]; //국적
		var userCd3 = codeLists["H40100"]; //퇴직진로/사유
		var userCd4 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList" + enterCd,false).codeList, "");	//근무지
		var userCd5 = codeLists["F10001"]; //채용구분
		var userCd6 = codeLists["H20460"]; //혈액형
		var userCd7 = codeLists["H20350"]; //종교
		var userCd8 = codeLists["H20337"]; //색신
		var userCd9 = codeLists["H00030"]; //음양구분
		var userCd10 = codeLists["F10003"]; //입사구분

		var userCd11 = codeLists["H20010"];	//직급년차_인정직급
		var userCd12 = codeLists["H90014"];	//어학특기
		var userCd13 = codeLists["H90015"];	//정비특기

		sheet1.SetColProperty("base1Cd", 			{ComboText:"|"+userCd11[0], ComboCode:"|"+userCd11[1]} );
		//sheet1.SetColProperty("base2Cd", 			{ComboText:"|"+userCd12[0], ComboCode:"|"+userCd12[1]} );
		//sheet1.SetColProperty("base3Cd", 			{ComboText:"|"+userCd13[0], ComboCode:"|"+userCd13[1]} );


		if($("#hdnAuthPg").val() == 'A') {
			$("#stfType").html(userCd5[2]);
			$("#empType").html(userCd10[2]);
			$("#sexType").html(userCd1[2]);
			$("#resignReasonCd").html(userCd3[2]);
			$("#lunType").html(userCd9[2]);
			$("#bloodCd").html(userCd6[2]);
			$("#wedYn").html("<option value=''></option><option value='N'><tit:txt mid='112466' mdef='미혼'/><option value='Y'><tit:txt mid='112809' mdef='기혼'/></option>");
			$("#foreignYn").html("<option value=''></option><option value='Y'>Y</option> <option value='N'>N</option>");
			$("#nationalCd").html(userCd2[2]);
			$("#relCd").html(userCd7[2]);
			$("#daltonismCd").html(userCd8[2]);
			//$("#base1Yn").html("<option value=''></option><option value='A'>A</option><option value='B'>B</option><option value='C'>C</option>");
			//$("#base2Yn").html("<option value=''></option><option value='A'>A</option><option value='B'>B</option><option value='C'>C</option>");
			$("#base1Cd").html(userCd11[2]);
			//$("#base2Cd").html(userCd12[2]);
			//$("#base3Cd").html(userCd13[2]);
		}


		setEmpPage();
	});

	function setEmpPage(){
		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		$("#hdnEnterCd").val($("#searchUserEnterCd",parent.document).val());
		doAction1("Search");
	}

	$(function() {
		if($("#hdnAuthPg").val() == 'A') {
			$( "#birYmd" ).datepicker2();
			$( "#gempYmd" ).datepicker2();
			$( "#empYmd" ).datepicker2();
			$( "#wedYmd" ).datepicker2();
			$( "#traYmd" ).datepicker2();
			$( "#retYmd" ).datepicker2();


			/* 추가 start */
			$( "#ht" ).mask("111");
			$( "#wt" ).mask("111");
			$( "#eyeL" ).mask("1.1");
			$( "#eyeR" ).mask("1.1");

			$( "#firYmd" ).datepicker2();
// 			$( "#jikgubYmd" ).datepicker2();
			$( "#yearYmd" ).datepicker2();
			$( "#orgMoveYmd" ).datepicker2();
			//$( "#rmidYmd" ).datepicker2();
// 			$( "#firRmidYmd" ).datepicker2();
			//$( "#jobYmd" ).datepicker2();
			//$( "#positionYmd" ).datepicker2();
// 			$( "#executiveYmd" ).datepicker2();
			//$( "#conRYmd" ).datepicker2();
			//$( "#conEYmd" ).datepicker2();
			/* 추가 end */
		}

        $("#resNo1","#resNo2").bind("keyup",function(event){
        	makeNumber(this,"A");
		});

        // SELECT BOX CHANGE 시 명칭 필드 셋팅
		$("#stfType").bind("change",function(){
			$("#stfTypeNm").val($(this).find(":selected").text());
		});

        // SELECT BOX CHANGE 시 명칭 필드 셋팅
		$("#empType").bind("change",function(){
			$("#empTypeNm").val($(this).find(":selected").text());
		});

		$("#nationalCd").bind("change",function(){
			$("#nationalNm").val($(this).find(":selected").text());
		});

		$("#relCd").bind("change",function(){
			$("#relNm").val($(this).find(":selected").text());
		});

		$("#resignReasonCd").bind("change",function(){
			$("#resignReasonNm").val($(this).find(":selected").text());
		});

		$("#base1Cd").bind("change",function(){
			$("#base1CdNm").val($(this).find(":selected").text());
		});

		$("#resNo1").mask("000000");
		$("#resNo2").mask("0000000");

	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			let surl = window.top.surl.value;

			var param = "sabun="+$("#hdnSabun").val()
				+"&searchUserEnterCd="+$("#hdnEnterCd").val()
				+"&surl="+surl;

			sheet1.DoSearch( "${ctx}/PsnalBasic.do?cmd=getPsnalBasicList", param);
			break;

<c:if test="${authPg == 'A'}">
		case "Save":

			if($.trim($("#name").val()) == "") {
				alert("한글성명은 필수 입력입니다.");
				$("#name").focus();
				return;
			}

			if($.trim($("#empYmd").val()) == "") {
				alert("<msg:txt mid='110177' mdef='입사일은 필수 입력입니다.'/>");
				$("#empYmd").focus();
				return;
			}

			setSheetData();
			IBS_SaveName(document.infoFrom,sheet1);
			sheet1.DoSave( "${ctx}/PsnalBasic.do?cmd=updatePsnalBasic", $("#infoFrom").serialize());
			break;
</c:if>
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			getSheetData();
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

	// 시트에서 폼으로 세팅.
	function getSheetData() {

		var row = sheet1.LastRow();

		if(row == 0) {
			return;
		}

		//기본사항
		$('#name').val(sheet1.GetCellValue(row,"name"));
		$('#nameCn').val(sheet1.GetCellValue(row,"nameCn"));
		$('#nameUs').val(sheet1.GetCellValue(row,"nameUs"));
		$('#gempYmd').val(sheet1.GetCellText(row,"gempYmd"));
		$('#empYmd').val(sheet1.GetCellText(row,"empYmd"));
		$('#workYymmCnt').val(sheet1.GetCellValue(row,"workYymmCnt"));
		$('#totAgreeYymmCnt').text(sheet1.GetCellValue(row,"totAgreeYymmCnt"));
		$('#allCareerYymmCnt').text(sheet1.GetCellValue(row,"allCareerYymmCnt"));
		$('#stfType').val(sheet1.GetCellValue(row,"stfType"));
		$('#stfTypeNm').val(sheet1.GetCellValue(row,"stfTypeNm"));
		$('#empType').val(sheet1.GetCellValue(row,"empType"));
		$('#empTypeNm').val(sheet1.GetCellValue(row,"empTypeNm"));
		$('#traYmd').val(sheet1.GetCellText(row,"traYmd"));
		$('#retYmd').val(sheet1.GetCellText(row,"retYmd"));
		$('#resignReasonCd').val(sheet1.GetCellText(row,"resignReasonCd"));
		$('#resignReasonNm').val(sheet1.GetCellText(row,"resignReasonNm"));
		//$('#endWorkDate').text(sheet1.GetCellText(row,"endWorkDate"));

		if($("#hdnAuthPg").val() == 'A') {
			$('#resNo1').val(sheet1.GetCellValue(row,"resNo").substring(0,6));
			$('#resNo2').val(sheet1.GetCellValue(row,"resNo").substring(6,13));
		} else {
			$('#resNo1').val(sheet1.GetCellValue(row,"resNo").substring(0,6));
			$('#resNo2').val("*******");
		}

		$('#sexType').val(sheet1.GetCellValue(row,"sexType"));
		$('#sexTypeNm').val(sheet1.GetCellValue(row,"sexTypeNm"));
		$('#birYmd').val(sheet1.GetCellText(row,"birYmd"));
		$('#lunType').val(sheet1.GetCellValue(row,"lunType"));
		$('#lunTypeNm').val(sheet1.GetCellValue(row,"lunTypeNm"));
		$('#bloodCd').val(sheet1.GetCellValue(row,"bloodCd"));
		$('#bloodNm').val(sheet1.GetCellValue(row,"bloodNm"));
		$('#wedYn').val(sheet1.GetCellValue(row,"wedYn"));
		$('#wedYnNm').val(sheet1.GetCellValue(row,"wedYnNm"));
		$('#wedYmd').val(sheet1.GetCellText(row,"wedYmd"));
		$('#foreignYn').val(sheet1.GetCellValue(row,"foreignYn"));
		$('#nationalCd').val(sheet1.GetCellValue(row,"nationalCd"));
		$('#nationalNm').val(sheet1.GetCellValue(row,"nationalNm"));
		$('#relCd').val(sheet1.GetCellValue(row,"relCd"));
		$('#relNm').val(sheet1.GetCellValue(row,"relNm"));
		$('#hobby').val(sheet1.GetCellValue(row,"hobby"));
		$('#specialityNote').val(sheet1.GetCellValue(row,"specialityNote"));
		//$('#gunYn').text(sheet1.GetCellValue(row,"gunYn"));
		//$('#daltonismCd').val(sheet1.GetCellValue(row,"daltonismCd"));
		//$('#daltonismNm').val(sheet1.GetCellText(row,"daltonismNm"));

		//$('#base1Yn').val(sheet1.GetCellValue(row,"base1Yn"));
		//$('#base1YnNm').val(sheet1.GetCellValue(row,"base1YnNm"));
		//$('#base2Yn').val(sheet1.GetCellValue(row,"base2Yn"));
		//$('#base2YnNm').val(sheet1.GetCellValue(row,"base2YnNm"));

		//$('#base2Cd').val(sheet1.GetCellValue(row,"base2Cd"));
		//$('#base2CdNm').val(sheet1.GetCellText(row,"base2Cd"));
		//$('#base3Cd').val(sheet1.GetCellValue(row,"base3Cd"));
		//$('#base3CdNm').val(sheet1.GetCellText(row,"base3Cd"));

		$('#base1Nm').val(sheet1.GetCellValue(row,"base1Nm"));
		//$('#base2Nm').val(sheet1.GetCellValue(row,"base2Nm"));

		/*
		   firYmd             "최초입사일",
		 , jikgubYmd          "직급승진일(직급기산일)",
		 , orgMoveYmd         "부서배치일",
		 , yearYmd            "연차기산일",
		 , rmidYmd            "퇴직금기산일",
		 , firRmidYmd         "최초퇴직금기산일",
		 , jobYmd             "직무담당일(조회성)",
		 , positionYmd        "보직임명일(조회성)",
		 , executiveYmd       "임원선임일",
		 , conRYmd            "계약시작일",
		 , conEYmd            "계약만료일",
		 , bloodCd            "혈액형(SELECTBOX)
		 , ht                 "신장",
		 , wt                 "체중",
		 , hobby              "취미",
		 , specialityNote     "특기",
		 , relNm              "종교",
		 , eyeL               "시력 좌",
		 , eyeR               "시력 우",
		 , unionYn            "노조가입여부(조회성)",
		 , clubYn             "동호회가입여부(조회성)",
*/

		$('#firYmd'			).val(sheet1.GetCellText(row,"firYmd"));			// "최초입사일",
		$('#jikgubYmd'		).val(sheet1.GetCellText(row,"jikgubYmd"));			// "직급승진일(직급기산일)",
		$('#orgMoveYmd'		).val(sheet1.GetCellText(row,"orgMoveYmd"));		// "부서배치일",
		$('#yearYmd'		).val(sheet1.GetCellText(row,"yearYmd"));			// "연차기산일",
		$('#rmidYmd'		).val(sheet1.GetCellText(row,"rmidYmd"));			// "퇴직금기산일",
		$('#firRmidYmd'		).val(sheet1.GetCellText(row,"firRmidYmd"));		// "최초퇴직금기산일",
		$('#jobYmd'			).val(sheet1.GetCellText(row,"jobYmd"));			// "직무담당일(조회성)",
		$('#positionYmd'	).val(sheet1.GetCellText(row,"positionYmd"));		// "보직임명일(조회성)",
		$('#executiveYmd'	).val(sheet1.GetCellText(row,"executiveYmd"));		// "임원선임일",
		$('#conRYmd'		).val(sheet1.GetCellText(row,"conRYmd"));			// "계약시작일",
		$('#conEYmd'		).val(sheet1.GetCellText(row,"conEYmd"));			// "계약만료일",
		$('#bloodCd'		).val(sheet1.GetCellValue(row,"bloodCd"));			// "혈액형(SELECTBOX)
		$('#ht'				).val(sheet1.GetCellValue(row,"ht"));				// "신장",
		$('#wt'				).val(sheet1.GetCellValue(row,"wt"));				// "체중",
		$('#hobby'			).val(sheet1.GetCellValue(row,"hobby"));			// "취미",
		$('#specialityNote'	).val(sheet1.GetCellValue(row,"specialityNote"));	// "특기",
		$('#relNm'			).val(sheet1.GetCellValue(row,"relNm"));			// "종교",
		$('#eyeL'			).val(sheet1.GetCellText(row,"eyeL"));				// "시력 좌",
		$('#eyeR'			).val(sheet1.GetCellText(row,"eyeR"));				// "시력 우",

		// JY 추가
		$('#empAcaCd'			).val(sheet1.GetCellValue(row,"empAcaCd"));			// "입사시학력",
		$('#finalAcaCd'			).val(sheet1.GetCellValue(row,"finalAcaCd"));		// "최종학력",
		$('#finalSchNm'			).val(sheet1.GetCellValue(row,"finalSchNm"));		// "최종학교명",
		$('#finalAcamajNm'		).val(sheet1.GetCellValue(row,"finalAcamajNm"));	// "최종전공명",
		$('#base1Cd'			).val(sheet1.GetCellText(row,"base1Cd"));			// 입사인정경력(직급명)
		$('#ftWorkYmd'			).val(sheet1.GetCellText(row,"ftWorkYmd"));			// 정규직전환일
		$('#orgYmd'				).val(formatDate(sheet1.GetCellValue(row,"orgYmd"),"-"));		// "현 부서배치일",
		$('#peakYn'				).val(sheet1.GetCellValue(row,"peakYn"));			// "임금피크제 여부",
		$('#peakYmd'			).val(sheet1.GetCellValue(row,"peakYmd"));			// "임금피크제 적용일",
		$('#bohunYn'			).val(sheet1.GetCellValue(row,"bohunYn"));			// "보훈여부"
		$('#jangYn'				).val(sheet1.GetCellValue(row,"jangYn"));			// "장애인여부"
		$('#unionYn'			).val(sheet1.GetCellValue(row,"unionYn"));			// "노조가입여부(조회성)",
		$('#empAccYn'			).val(sheet1.GetCellValue(row,"empAccYn"));			// "사우회가입여부",
		$('#clubYn'				).val(sheet1.GetCellValue(row,"clubYn"));			// "동호회가입여부(조회성)",
		$('#gpAddr'				).val(sheet1.GetCellValue(row,"gpAddr"));			// "비상연락망(관계)",
		$('#scAddr'				).val(sheet1.GetCellValue(row,"scAddr"));			// "비상연락망(연락처)",
		$('#nmAddr'				).val(sheet1.GetCellValue(row,"nmAddr"));			// "비상연락망(성명)",
		$('#imAddr'				).val(sheet1.GetCellValue(row,"imAddr"));			// "회사이메일",
		$('#base1Cd'			).val(sheet1.GetCellValue(row,"base1Cd"));			// "입사인정경력",
		$('#base1CdNm'			).val(sheet1.GetCellValue(row,"base1CdNm"));		// "입사인정경력명",
		$('#age'				).val(sheet1.GetCellValue(row,"age"));		// "입사인정경력명",
		$('#rk'				).val(sheet1.GetCellValue(row,"rk"));						// "나이",
	}

	// 폼에서 시트로 세팅.
	function setSheetData() {

		var row = sheet1.LastRow();
		console.log($('#stfType').val())

		//기본사항
		sheet1.SetCellValue(row,"name",$('#name').val());
		sheet1.SetCellValue(row,"nameCn",$('#nameCn').val());
		sheet1.SetCellValue(row,"nameUs",$('#nameUs').val());
		sheet1.SetCellValue(row,"gempYmd",formatDate($('#gempYmd').val(),""));
		sheet1.SetCellValue(row,"empYmd",formatDate($('#empYmd').val(),""));
		sheet1.SetCellValue(row,"stfType", $('#stfType').val()?$('#stfType').val():'');
		sheet1.SetCellValue(row,"stfTypeNm", $('#stfTypeNm').val());
		sheet1.SetCellValue(row,"empType", $('#empType').val()?$('#empType').val():'');
		sheet1.SetCellValue(row,"empTypeNm", $('#empTypeNm').val());
		sheet1.SetCellValue(row,"traYmd",formatDate($('#traYmd').val(),""));
		sheet1.SetCellValue(row,"retYmd",formatDate($('#retYmd').val(),""));
		sheet1.SetCellValue(row,"resignReasonCd",$('#resignReasonCd').val());
		sheet1.SetCellValue(row,"resignReasonNm",$('#resignReasonNm').val());
		sheet1.SetCellValue(row,"resNo",$('#resNo1').val()+$('#resNo2').val());
		sheet1.SetCellValue(row,"sexType",$('#sexType').val());
		sheet1.SetCellValue(row,"birYmd",formatDate($('#birYmd').val(),""));
		sheet1.SetCellValue(row,"lunType",$('#lunType').val());
		sheet1.SetCellValue(row,"bloodCd", $('#bloodCd').val());
		sheet1.SetCellValue(row,"wedYn", $('#wedYn').val());
		sheet1.SetCellValue(row,"wedYmd", formatDate($('#wedYmd').val(),""));
		sheet1.SetCellValue(row,"foreignYn", $('#foreignYn').val());
		sheet1.SetCellValue(row,"nationalCd",$('#nationalCd').val());
		sheet1.SetCellValue(row,"nationalNm",$('#nationalNm').val());
		sheet1.SetCellValue(row,"relCd", $('#relCd').val());
		sheet1.SetCellValue(row,"relNm", $('#relNm').val());
		sheet1.SetCellValue(row,"hobby", $('#hobby').val());
		sheet1.SetCellValue(row,"specialityNote", $('#specialityNote').val());
		//sheet1.SetCellValue(row,"daltonismCd", $('#daltonismCd').val());

		//sheet1.SetCellValue(row,"base1Yn", $('#base1Yn').val());
		//sheet1.SetCellValue(row,"base2Yn", $('#base2Yn').val());

		sheet1.SetCellValue(row,"base1Cd", $('#base1Cd').val());
		sheet1.SetCellValue(row,"base1CdNm", $('#base1CdNm').val());
		//sheet1.SetCellValue(row,"base2Cd", $('#base2Cd').val());
		//sheet1.SetCellValue(row,"base3Cd", $('#base3Cd').val());

		sheet1.SetCellValue(row,"base1Nm", $('#base1Nm').val());
		//sheet1.SetCellValue(row,"base2Nm", $('#base2Nm').val());


		/*
		   firYmd             "최초입사일",
		 , jikgubYmd          "직급승진일(직급기산일)",
		 , orgMoveYmd         "부서배치일",
		 , yearYmd            "연차기산일",
		 , rmidYmd            "퇴직금기산일",
		 , firRmidYmd         "최초퇴직금기산일",
		 , jobYmd             "직무담당일(조회성)",
		 , positionYmd        "보직임명일(조회성)",
		 , executiveYmd       "임원선임일",
		 , conRYmd            "계약시작일",
		 , conEYmd            "계약만료일",
		 , bloodCd            "혈액형(SELECTBOX)
		 , ht                 "신장",
		 , wt                 "체중",
		 , hobby              "취미",
		 , specialityNote     "특기",
		 , relNm              "종교",
		 , eyeL               "시력 좌",
		 , eyeR               "시력 우",
		 , unionYn            "노조가입여부(조회성)",
		 , clubYn             "동호회가입여부(조회성)",
*/

		sheet1.SetCellValue(row,"firYmd", 			formatDate($('#firYmd').val(),""));             //"최초입사일",
		sheet1.SetCellValue(row,"jikgubYmd", 		formatDate($('#jikgubYmd').val(),""));          //"직급승진일(직급기산일)",
		sheet1.SetCellValue(row,"orgMoveYmd", 		formatDate($('#orgMoveYmd').val(),""));         //"부서배치일",
		sheet1.SetCellValue(row,"yearYmd", 			formatDate($('#yearYmd').val(),""));            //"연차기산일",
		sheet1.SetCellValue(row,"rmidYmd", 			formatDate($('#rmidYmd').val(),""));            //"퇴직금기산일",
		sheet1.SetCellValue(row,"firRmidYmd", 		formatDate($('#firRmidYmd').val(),""));         //"최초퇴직금기산일",
		sheet1.SetCellValue(row,"jobYmd", 			formatDate($('#jobYmd').val(),""));             //"직무담당일(조회성)",
		sheet1.SetCellValue(row,"positionYmd", 		formatDate($('#positionYmd').val(),""));        //"보직임명일(조회성)",
		sheet1.SetCellValue(row,"executiveYmd", 	formatDate($('#executiveYmd').val(),""));       //"임원선임일",
		sheet1.SetCellValue(row,"conRYmd", 			formatDate($('#conRYmd').val(),""));            //"계약시작일",
		sheet1.SetCellValue(row,"conEYmd", 			formatDate($('#conEYmd').val(),""));            //"계약만료일",
		sheet1.SetCellValue(row,"bloodCd", 			$('#bloodCd').val());            //"혈액형(SELECTBOX)
		sheet1.SetCellValue(row,"ht", 				$('#ht').val());                 //"신장",
		sheet1.SetCellValue(row,"wt", 				$('#wt').val());                 //"체중",
		sheet1.SetCellValue(row,"hobby", 			$('#hobby').val());              //"취미",
		sheet1.SetCellValue(row,"specialityNote", 	$('#specialityNote').val());     //"특기",
		sheet1.SetCellValue(row,"relNm", 			$('#relNm').val());              //"종교",
		sheet1.SetCellValue(row,"eyeL", 			$('#eyeL').val());               //"시력 좌",
		sheet1.SetCellValue(row,"eyeR", 			$('#eyeR').val());               //"시력 우",

		// JY 추가
		sheet1.SetCellValue(row,"empAcaCd", 		$('#empAcaCd').val());             //"입사시학력",
		sheet1.SetCellValue(row,"finalAcaCd", 		$('#finalAcaCd').val());           //"최종학력",
		sheet1.SetCellValue(row,"finalSchNm", 		$('#finalSchNm').val());           //"최종학교명",
		sheet1.SetCellValue(row,"finalAcamajNm", 	$('#finalAcamajNm').val());        //"최종전공명",
		sheet1.SetCellValue(row,"base1CdNm", 		$('#base1CdNm').val());     	   //"입사인정경력(직급명)",
		sheet1.SetCellValue(row,"ftWorkYmd", 		$('#ftWorkYmd').val());     	   //"정규직전환일",
		sheet1.SetCellValue(row,"orgYmd", 			$('#orgYmd').val());     	 	   //"현 부서배치일",
		sheet1.SetCellValue(row,"peakYn", 			$('#peakYn').val());     	 	   //"임금피크제 여부",
		sheet1.SetCellValue(row,"peakYmd", 			$('#peakYmd').val());     	 	   //"임금피크제 적용일",
		sheet1.SetCellValue(row,"bohunYn", 			$('#bohunYn').val());     	 	   //"보훈여부",
		sheet1.SetCellValue(row,"jangYn", 			$('#jangYn').val());     	 	   //"장애인여부",
		sheet1.SetCellValue(row,"unionYn", 			$('#unionYn').val());              //"노조가입여부(조회성)",
		sheet1.SetCellValue(row,"empAccYn", 		$('#empAccYn').val());             //"사우회가입여부",
		sheet1.SetCellValue(row,"clubYn", 			$('#clubYn').val());               //"동호회가입여부(조회성)",
		sheet1.SetCellValue(row,"gpAddr", 			$('#gpAddr').val());               //"비상연락망(관계)",
		sheet1.SetCellValue(row,"scAddr", 			$('#scAddr').val());               //"비상연락망(연락처)",
		sheet1.SetCellValue(row,"nmAddr", 			$('#nmAddr').val());               //"비상연락망(성명)",
		sheet1.SetCellValue(row,"imAddr", 			$('#imAddr').val());               //"회사이메일",
		sheet1.SetCellValue(row,"age", 				$('#age').val());                  //"나이",


		sheet1.SetCellValue(row,"rk", $('#rk').val()); //RD 파라메터

	}

	var pGubun = "";


<c:if test="${authPg == 'A'}">

	/**
	 * 인사카드 RD출력
	 * sabun (string : '사번1','사번2') 인사카드를 출력할 사번
	 * isMasking (boolean) 개인정보 마스킹 여부
	 * printPage# (boolean) 페이지#에 대한 출력여부
	 */
	function rdPopup(param){
		var w    = 900;
		var h    = 700;
		var url  = "${ctx}/RdPopup.do";
		var args = new Array();
		
		var rdMrd           = "";
		var rdTitle         = "";
		var rdParam         = "";
		
		var enterCd = "${ssnEnterCd}";
		var sabun = sheet1.GetCellValue(sheet1.LastRow(),"sabun");
		if( "${ssnEnterCd}" != $("#hdnEnterCd").val() ) {
			enterCd = $("#hdnEnterCd").val();
			sabun = $("#hdnSabun").val();
		}

		//rdMrd   = "hrm/empcard/PersonInfoCard_${ssnEnterCd}.mrd";
		rdMrd   = "hrm/empcard/PersonInfoCardType2_HR.mrd";
		rdTitle = "인사카드";

		rdParam += "[,('" + enterCd + "','" + sabun + "')] ";  // 1.회사코드 및 사번
		rdParam += "[${baseURL}] ";  // 2.이미지 url---3
		rdParam += "[Y] "; //개인정보 마스킹
		rdParam += "[Y] "; //인사기본1
		rdParam += "[Y] "; //인사기본2
		rdParam += "[Y] "; //발령사항
		rdParam += "[Y] "; //교육사항
		rdParam += "[Y] "; // 전체발령체크
		rdParam += "[${ssnEnterCd}] ";  // 8.회사코드
		rdParam += "['${ssnSabun}'] ";  // 9.출력자 사번 어레이
		rdParam += "[${ssnLocaleCd}] ";	// 10.다국어코드
		rdParam += "['${ssnSabun}'] "; //사번
		rdParam += "[Y] "; //평가
		rdParam += "[Y] "; //타부서발령포함
		
		//신규 화면 제어 파라미터들
		rdParam += "[Y] "; //연락처
		rdParam += "[Y] "; //병역
		rdParam += "[Y] "; //학력
		rdParam += "[Y] "; //경력
		rdParam += "[Y] "; //포상
		rdParam += "[Y] "; //징계
		rdParam += "[Y] "; //자격
		rdParam += "[Y] "; //어학
		rdParam += "[Y] "; //가족
		rdParam += "[Y] "; //발령
		rdParam += "[Y] "; //직무

		var imgPath = " " ;
		args["rdTitle"]      = rdTitle ; // rd Popup제목
		args["rdMrd"]        = rdMrd;    // ( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"]      = rdParam;  // rd파라매터
		args["rdParamGubun"] = "rp";     // 파라매터구분(rp/rv)
		args["rdToolBarYn"]  = "Y" ;     // 툴바여부
		args["rdZoomRatio"]  = "100";    // 확대축소비율
		
		args["rdSaveYn"]  = "Y" ;  // 기능컨트롤_저장
		args["rdPrintYn"] = "Y" ;  // 기능컨트롤_인쇄
		args["rdExcelYn"] = "Y" ;  // 기능컨트롤_엑셀
		args["rdWordYn"]  = "Y" ;  // 기능컨트롤_워드
		args["rdPptYn"]   = "Y" ;  // 기능컨트롤_파워포인트
		args["rdHwpYn"]   = "Y" ;  // 기능컨트롤_한글
		args["rdPdfYn"]   = "Y" ;  // 기능컨트롤_PDF
		
		var rv = openPopup(url, args, w, h);  // 알디출력을 위한 팝업창
		if(rv!=null && rv["printResultYn"] == "Y"){
		}
	}

	function copyStep(){
		if(!isPopup()) {return;}

		var args = new Array();
		args["searchResNo"] = sheet1.GetCellValue(1, "resNo");

		var win = openPopup("${ctx}/PsnalBasic.do?cmd=viewPsnalBasicCopyPop&authPg=${authPg}",args,"700","300");
	}
</c:if>
	function getReturnValue(returnValue) {
       	var rv = $.parseJSON('{' + returnValue+ '}');

       	if(pGubun == "rdPopup") {
    		if(rv["printResultYn"] == "Y"){
    		}
       	}

	}

	function numberCheck(obj){
		if(!isNumber(obj.value,'')){
			alert("숫자만 입력해주세요.");
			obj.value="";
			obj.focus();
		}
	}

	function showRd(){

		//암호화 할 데이터 생성
		const data = {
			rk : $("#rk").val()
		};
		window.top.showRdLayer('/PsnalBasic.do?cmd=getEncryptRd', data, null, "인사카드");
	}

</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>

<style type="text/css">
table.default td .ui-datepicker-trigger {margin-left:-1px!important;}
table.default td select { padding:6px 2px 6px 2px;}
table.default td { letter-spacing:normal;}
table.default th { width:120px!important;}
</style>

</head>

<body>
<div class="wrapper">
<form id="infoFrom" name="infoFrom">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="rk" name="rk" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='basicInfo' mdef='기본사항'/></li>
			<li class="btn _thrm100">
			<c:if test="${authPg == 'A'}">
				<!-- <btn:a href="javascript:copyStep();" css="basic authA" mid='111817' mdef="인사정보복사"/> -->
<%--				<btn:a href="javascript:rdPopup();" css="basic" mid='111360' mdef="인사카드출력"/>--%>
				<btn:a href="javascript:showRd();" css="btn outline_gray" mid='111360' mdef="인사카드출력"/>
			</c:if>
				<btn:a href="javascript:doAction1('Search');" css="btn dark authR" mid='110697' mdef="조회"/>
			<c:if test="${authPg == 'A'}">
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='110708' mdef="저장" id="btnSave" />
			</c:if>
			</li>
		</ul>
		</div>
	</div>

		<table class="default personal">
		<tr>
			<th><tit:txt mid='103880' mdef='한글성명'/></th>
<c:choose>
	<c:when test="${authPg == 'A'}">
		<td><input id="name" name="name" type="text" class="${textCss} required w100p" maxlength="30" ${readonly}></td>
	</c:when>
	<c:otherwise>
		<td><input id="name" name="name" type="text" class="${textCss} w100p" maxlength="30" ${readonly}></td>
	</c:otherwise>
</c:choose>
			<th><tit:txt mid='104533' mdef='영문성명'/></th>
			<td><input id="nameUs" name="nameUs" type="text" class="${textCss} w100p" maxlength="50" ${readonly}></td>
			<th><tit:txt mid='104040' mdef='한자성명'/></th>
			<td><input id="nameCn" name="nameCn" type="text" class="${textCss} w100p" maxlength="30" ${readonly}></td>
		</tr>
		<tr>
			<th><tit:txt mid='112880' mdef='근속년수'/></th>
			<td><input id="workYymmCnt" name="workYymmCnt" type="text" class="text transparent w20" readonly>년</td>

			<th><tit:txt mid='104206' mdef='주민등록번호'/></th>
			<td>
				<input id="resNo1" name="resNo1" type="text" class="${textCss} date" maxlength="6" ${readonly} style="width:45px;"> -
				<input id="resNo2" name="resNo2" type="text" class="${textCss} date" maxlength="7" ${readonly} style="width:55px;">
			</td>

			<th><tit:txt mid='104294' mdef='생년월일/나이'/></th>
			<td>
				<input id="birYmd" name="birYmd" type="text" class="${dateCss}" ${readonly} style="width:73px;">
				<c:choose>
					<c:when test="${authPg == 'A'}">
						<select id="lunType" name="lunType" class="box">
						</select>
						<input id="lunTypeNm" name="lunTypeNm" type="hidden" ${readonly}>	<!-- 없음 -->
						&nbsp;만 <input id="age" name="age" type="text" class="text transparent w20" readonly> 세
					</c:when>
					<c:otherwise>
						<input id="lunType" name="lunType" type="hidden" class="${textCss}" ${readonly}>
						<input id="lunTypeNm" name="lunTypeNm" type="hidden" class="${textCss} w20" readonly>
						&nbsp;만 <input id="age" name="age" type="text" class="${textCss} w20" ${readonly} readonly> 세
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104011' mdef='성별'/></th>
			<td>
				<c:choose>
					<c:when test="${authPg == 'A'}">
						<select id="sexType" name="sexType">
						</select>
						<input id="sexTypeNm" name="sexTypeNm" type="hidden" ${readonly}>	<!-- 없음 -->
					</c:when>
					<c:otherwise>
						<input id="sexType" name="sexType" type="hidden" class="${textCss}" ${readonly}>
						<input id="sexTypeNm" name="sexTypeNm" type="text" class="${textCss} w20" readonly>
					</c:otherwise>
				</c:choose>
			</td>
			<th><tit:txt mid='104235' mdef='결혼여부'/></th>
			<td>
				<c:choose>
					<c:when test="${authPg == 'A'}">
						<select id="wedYn" name="wedYn">
						</select>
						<input id="wedYnNm" name="wedYnNm" type="hidden" ${readonly}>	<!-- 없음 -->
					</c:when>
					<c:otherwise>
						<input id="wedYn" name="wedYn" type="hidden" class="${textCss}" ${readonly}>
						<input id="wedYnNm" name="wedYnNm" type="text" class="${textCss}" readonly>
					</c:otherwise>
				</c:choose>
			</td>
<!--
		<tr>
			<th><tit:txt mid='112880' mdef='입사시학력'/></th>
			<td>
				<input id="empAcaCd" name="empAcaCd" type="text" class="text transparent w100p" readonly>
			</td>
			<th><tit:txt mid='112880' mdef='최종학력'/></th>
			<td>
				<input id="finalAcaCd" name="finalAcaCd" type="text" class="text transparent w100p" readonly>
			</td>
			<th><tit:txt mid='112880' mdef='최종학교명'/></th>
			<td>
				<input id="finalSchNm" name="finalSchNm" type="text" class="text transparent w100p" readonly>
			</td>
			<th><tit:txt mid='112880' mdef='최종전공명'/></th>
			<td>
				<input id="finalAcamajNm" name="finalAcamajNm" type="text" class="text transparent w100p" readonly>
			</td>
		</tr>
 -->
			<th><tit:txt mid='112881' mdef='고용구분'/></th>
			<td>
				<c:choose>
					<c:when test="${authPg == 'A'}">
						<select id="stfType" name="stfType"></select>
						<input id="stfTypeNm" name="stfTypeNm" type="hidden" readonly>
					</c:when>
					<c:otherwise>
						<input id="stfTypeNm" name="stfTypeNm" type="text" class="text transparent" readonly style="width:30px">
						<input id="stfType" name="stfType" type="hidden" readonly>
					</c:otherwise>
				</c:choose>
					/
				<c:choose>
					<c:when test="${authPg == 'A'}">
						<select id="empType" name="empType"></select>
						<input id="empTypeNm" name="empTypeNm" type="hidden" readonly>
					</c:when>
					<c:otherwise>
						<input id="empTypeNm" name="empTypeNm" type="text" class="text transparent" readonly style="width:100px">
						<input id="empType" name="empType" type="hidden" readonly>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104473' mdef='그룹입사일'/></th>
			<td>
				<input id="gempYmd" name="gempYmd" type="text" class="${dateCss}" ${readonly} style="width:73px;">
			</td>
			<th><tit:txt mid='103881' mdef='소속입사일'/></th>
			<td>
				<input id="empYmd" name="empYmd" type="text" class="${dateCss}" ${readonly} style="width:73px;">
			</td>
			<th><tit:txt mid='103939' mdef='면수습일'/></th>
			<td>
				<input id="traYmd" name="traYmd" type="text" class="${dateCss}" ${readonly} style="width:73px;">
			</td>
		</tr>
		<tr>
			<th>입사인정경력</th>
			<td>
			    <c:choose>
					<c:when test="${authPg == 'A'}">
				        <select id="base1Cd" name="base1Cd">
						</select>
						<input id="base1CdNm" name="base1CdNm" type="hidden" ${readonly}>		<!-- 없음 -->
						<input id="base1Nm" name="base1Nm" type="text" class="${dateCss}" ${readonly} style="width:20px;" onKeyup="numberCheck(this);"> 년
					</c:when>
					<c:otherwise>
					    <input id="base1CdNm" name="base1CdNm" type="text" class="text transparent" readonly style="width:30px">
						<input id="base1Cd" name="base1Cd" type="hidden" readonly>
						<input id="base1Nm" name="base1Nm" type="text" class="text transparent" readonly style="width:20px;"> 년
					</c:otherwise>
				</c:choose>
			</td>
			<th>계약시작일</th>
			<td>
				<!-- <input id="conRYmd" name="conRYmd" type="text" class="${dateCss}" ${readonly} style="width:73px;"> -->
				<input id="conRYmd" name="conRYmd" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='103875' mdef='계약만료일'/></th>
			<td>
				<!--<input id="conEYmd" name="conEYmd" type="text" class="${dateCss}" ${readonly} style="width:73px;"> -->
				<input id="conEYmd" name="conEYmd" type="text" class="text transparent" readonly>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='112880' mdef='정규직전환일'/></th>
			<td>
				<input id="ftWorkYmd" name="ftWorkYmd" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='112880' mdef='현 부서배치일'/></th>
			<td>
				<input id="orgYmd" name="orgYmd" type="text" class="text transparent" readonly>
			</td>
			<th>현 직급승격일</th>
			<td>
				<input id="jikgubYmd" name="jikgubYmd" type="text" class="text transparent" readonly>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104134' mdef='연차기산일'/></th>
			<td>
				<input id="yearYmd" name="yearYmd" type="text" class="${dateCss}" ${readonly} style="width:73px;">
			</td>
			<th>임원선임일</th>
			<td>
				<input id="executiveYmd" name="executiveYmd" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='rmidYmd_V2' mdef='퇴직금기산일'/></th>
			<td>
				<input id="rmidYmd" name="rmidYmd" type="text" class="text transparent" readonly>
			</td>
		</tr>
		<tr>
			<th>최초퇴직금기산일</th>
			<td>
				<input id="firRmidYmd" name="firRmidYmd" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='104369' mdef='퇴직일'/></th>
			<td>
				<input id="retYmd" name="retYmd" type="text" class="${dateCss}" ${readonly} style="width:73px;">
			</td>
			<th><tit:txt mid='112956' mdef='퇴직사유'/></th>
			<td>
				<c:choose>
					<c:when test="${authPg == 'A'}">
						<select id="resignReasonCd" name="resignReasonCd">
						</select>
						<input id="resignReasonNm" name="resignReasonNm" type="hidden" ${readonly}>
					</c:when>
					<c:otherwise>
						<input id="resignReasonCd" name="resignReasonCd" type="hidden" class="${textCss}" ${readonly}>
						<input id="resignReasonNm" name="resignReasonNm" type="text" class="${textCss}" readonly>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
		<!--
		<tr>
			<th><tit:txt mid='peakYn_V' mdef='임금피크제 여부'/></th>
			<td>
				<input id="peakYn" name="peakYn" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='peakYmd_V' mdef='임금피크제 적용일'/></th>
			<td>
				<input id="peakYmd" name="peakYmd" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='bohunYn_V' mdef='보훈여부'/></th>
			<td>
				<input id="bohunYn" name="bohunYn" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='jangYn_V' mdef='장애여부'/></th>
			<td>
				<input id="jangYn" name="jangYn" type="text" class="text transparent" readonly>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='unionYn_V' mdef='노조가입여부'/></th>
			<td>
				<input id="unionYn" name="unionYn" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='empAccYn_V' mdef='사우회가입여부'/></th>
			<td>
				<input id="empAccYn" name="empAccYn" type="text" class="text transparent" readonly>
			</td>
			<th><tit:txt mid='clubYn_V' mdef='동호회가입여부'/></th>
			<td>
				<input id="clubYn" name="clubYn" type="text" class="text transparent" readonly>
			</td>
		</tr>
		-->
		<tr>
			<th><tit:txt mid='gpAddr_V' mdef='비상연락망(관계)'/></th>
			<td>
				<input id="gpAddr" name="gpAddr" type="text" class="text transparent w100p" readonly>
			</td>
			<th><tit:txt mid='nmAddr_V' mdef='비상연락망(성명)'/></th>
			<td>
				<input id="nmAddr" name="nmAddr" type="text" class="text transparent w100p" maxlength="50" readonly>
			</td>
			<th><tit:txt mid='scAddr_V' mdef='비상연락망(연락처)'/></th>
			<td>
				<input id="scAddr" name="scAddr" type="text" class="text transparent w100p" maxlength="50" readonly>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='imAddr_V' mdef='회사이메일'/></th>
			<td>
				<input id="imAddr" name="imAddr" type="text" class="text transparent w100p" maxlength="50" readonly>
			</td>
		</tr>
		</table>
</form>

	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "0", "0", "${ssnLocaleCd}"); </script>
	</div>
</div>
</body>
</html>