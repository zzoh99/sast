<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>채용합격자업로드</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		$("#searchApplYmdFrom").datepicker2({startdate:"searchApplYmdTo"});
		$("#searchApplYmdTo").datepicker2({enddate:"searchApplYmdFrom"});

		$("#searchApplYmdFrom, #searchApplYmdTo, #searchApplSeq, #searchName").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:5,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",						Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"상태",						Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
			{Header:"수험번호", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"applKey", 		KeyField:1, Format:"Number", UpdateEdit:0, InsertEdit:1 },
			{Header:"이름", 						Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"name", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"성별", 						Type:"Combo",	Hidden:0, Width:60, Align:"Center", 	SaveName:"sexType", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"생년월일", 					Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"birYmd", 			KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"나이", 						Type:"Text",	Hidden:0, Width:60, Align:"Center", 	SaveName:"age", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"지원분야 : 1지망", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"applField1", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"지원분야 : 2지망", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"applField2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"지원분야 갯수", 				Type:"Int",		Hidden:0, Width:100, Align:"Center", 		SaveName:"applCnt", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"작성일자", 					Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"regYmd", 			KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"지원서 제출", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"applStatus", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"지원서 제출일자", 				Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"applYmd", 		KeyField:1, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"영문이름", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"nameUs", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"한문이름", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"nameCn", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"희망연봉(만원)", 				Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"hopePay", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"직전연봉(만원)", 				Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"beforePay", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"입사가능일자", 				Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"enterYmd", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"추천인", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"recomName", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"지원경로", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"applPath", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"희망직급", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"hopeJikgub", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"국적", 						Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"nationalCd", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"현주소", 					Type:"Text",	Hidden:0, Width:200, Align:"Center", 		SaveName:"addr", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"이메일", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"psnlEmail", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"핸드폰번호", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"hpTel", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"특기", 						Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"specialityNote", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"취미", 						Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"hobby", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"형제관계", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 		SaveName:"familyInfo", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항1 - 관계", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famCd1", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항1 - 성명", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famNm1", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항1 - 나이(세)", 			Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"famAge1", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항2 - 관계", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famCd2", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항2 - 성명", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famNm2", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항2 - 나이(세)", 			Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"famAge2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항3 - 관계", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famCd3", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항3 - 성명", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famNm3", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항3 - 나이(세)", 			Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"famAge3", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항4 - 관계", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famCd4", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항4 - 성명", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famNm4", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항4 - 나이(세)", 			Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"famAge4", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항5 - 관계", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famCd5", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항5 - 성명", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famNm5", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항5 - 나이(세)", 			Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"famAge5", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항6 - 관계", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famCd6", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항6 - 성명", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"famNm6", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"가족사항6 - 나이(세)", 			Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"famAge6", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"장애여부", 					Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"jangYn", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"보훈여부", 					Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"bohunYn", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"병역구분", 					Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"transferCd", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"복무시작일", 					Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"armySYmd", 		KeyField:0, Format:"Ym", UpdateEdit:1, InsertEdit:1 },
			{Header:"복무종료일", 					Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"armyEYmd", 		KeyField:0, Format:"Ym", UpdateEdit:1, InsertEdit:1 },
			{Header:"제대구분", 					Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"dischargeCd", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"계급", 						Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"armyGradeCd", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"군별", 						Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"armyCd", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"병과", 						Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"armyDCd", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"최종학력", 					Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"finalAcaCd", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"고등학교 - 학교명", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"hAcaSchCd", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"고등학교 - 입학일", 			Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"hAcaSYm", 		KeyField:0, Format:"Ym", UpdateEdit:1, InsertEdit:1 },
			{Header:"고등학교 - 졸업일", 			Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"hAcaEYm", 		KeyField:0, Format:"Ym", UpdateEdit:1, InsertEdit:1 },
			{Header:"고등학교 - 졸업구분", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"hAcaYn", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"고등학교 - 소재지", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"hAcaPlaceNm", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"고등학교 - 계열", 				Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"hAcaLineNm", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"고등학교 - 주간야간", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"hDType", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"최종졸업 대학교명", 			Type:"Combo",	Hidden:0, Width:150, Align:"Center", 	SaveName:"uFinalAcaSchCd", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"최종졸업 대학교 전공", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uFinalAcamajNm", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 학위구분", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaDegCd", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 입학일", 			Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaSYm", 		KeyField:0, Format:"Ym", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 졸업일", 			Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaEYm", 		KeyField:0, Format:"Ym", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 입학편입구분", 		Type:"Combo",	Hidden:0, Width:120, Align:"Center", 	SaveName:"uEntryType", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 졸업구분", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaYn", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 학교명", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaSchCd", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 소재지", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaPlaceNm", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 본교구분", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uEType", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 학과계열", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaLineNm", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 성적", 				Type:"Float",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaPoint", 		KeyField:0, Format:"#.#", UpdateEdit:1, InsertEdit:1 ,EditLen:3},
			{Header:"대학교1 - 만점기준", 			Type:"Float",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaPointManjum", KeyField:0, Format:"#.#", UpdateEdit:1, InsertEdit:1 ,EditLen:3},
			{Header:"대학교1 - 전공구분1", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcamajType", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 전공명1", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcamajCd", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 전공계열1", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcamajLine", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 주야간구분1", 		Type:"Combo",	Hidden:0, Width:120, Align:"Center", 	SaveName:"uAcaDType", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 전공구분2", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uSubmajType", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 전공명2", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uSubmmajCd", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 전공계열2", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uSubmmajLine", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교1 - 주야간구분2", 		Type:"Combo",	Hidden:0, Width:120, Align:"Center", 	SaveName:"uSubDType", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 학위구분", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaDegCd2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 입학일", 			Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaSYm2", 		KeyField:0, Format:"Ym", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 졸업일", 			Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaEYm2", 		KeyField:0, Format:"Ym", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 입학편입구분", 		Type:"Combo",	Hidden:0, Width:120, Align:"Center", 	SaveName:"uEntryType2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 졸업구분", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaYn2", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 학교명", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaSchCd2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 소재지", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaPlaceNm2", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 본교구분", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uEType2", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 학과계열", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaLineNm2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 성적", 				Type:"Float",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaPoint2", 		KeyField:0, Format:"#.#", UpdateEdit:1, InsertEdit:1 ,EditLen:3},
			{Header:"대학교2 - 만점기준", 			Type:"Float",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcaPointManjum2", KeyField:0, Format:"#.#", UpdateEdit:1, InsertEdit:1 ,EditLen:3},
			{Header:"대학교2 - 전공구분1", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcamajType2", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 전공명1", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcamajCd2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 전공계열1", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uAcamajLine2", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 주야간구분1", 		Type:"Combo",	Hidden:0, Width:120, Align:"Center", 	SaveName:"uAcaDType2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 전공구분2", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uSubmajType2", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 전공명2", 			Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uSubmmajCd2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 전공계열2", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uSubmmajLine2", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"대학교2 - 주야간구분2", 		Type:"Combo",	Hidden:0, Width:120, Align:"Center", 	SaveName:"uSubDType2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"최종졸업 대학원명", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"uuFinalAcaSchNm", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"최종졸업 대학원 전공", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"uuFinalAcamajNm", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"총 경력", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"careerTotTerm", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항1 - 고용형태", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerWorkType1", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항1 - 회사명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerCmpNm1", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항1 - 재직기간", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerTerm1", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항1 - 재직기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerSdate1", 	KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항1 - 재직기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerEdate1", 	KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항1 - 부서명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerDeptNm1", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항1 - 직급", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJikweeNm1", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항1 - 담당업무", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJobNm1", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항1 - 퇴직사유", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerMemo1", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항1 - 연봉(만원)", 		Type:"Int",		Hidden:0, Width:120, Align:"Center", 	SaveName:"careerPay1", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항2 - 고용형태", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerWorkType2", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항2 - 회사명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerCmpNm2", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항2 - 재직기간", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerTerm2", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항2 - 재직기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerSdate2", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항2 - 재직기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerEdate2", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항2 - 부서명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerDeptNm2", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항2 - 직급", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJikweeNm2", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항2 - 담당업무", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJobNm2", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항2 - 퇴직사유", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerMemo2", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항2 - 연봉(만원)", 		Type:"Int",		Hidden:0, Width:120, Align:"Center", 	SaveName:"careerPay2", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항3 - 고용형태", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerWorkType3", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항3 - 회사명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerCmpNm3", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항3 - 재직기간", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerTerm3", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항3 - 재직기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerSdate3", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항3 - 재직기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerEdate3", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항3 - 부서명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerDeptNm3", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항3 - 직급", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJikweeNm3", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항3 - 담당업무", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJobNm3", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항3 - 퇴직사유", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerMemo3", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항3 - 연봉(만원)", 		Type:"Int",		Hidden:0, Width:120, Align:"Center", 	SaveName:"careerPay3", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항4 - 고용형태", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerWorkType4", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항4 - 회사명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerCmpNm4", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항4 - 재직기간", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerTerm4", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항4 - 재직기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerSdate4", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항4 - 재직기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerEdate4", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항4 - 부서명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerDeptNm4", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항4 - 직급", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJikweeNm4", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항4 - 담당업무", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJobNm4", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항4 - 퇴직사유", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerMemo4", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항4 - 연봉(만원)", 		Type:"Int",		Hidden:0, Width:120, Align:"Center", 	SaveName:"careerPay4", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항5 - 고용형태", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerWorkType5", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항5 - 회사명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerCmpNm5", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항5 - 재직기간", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerTerm5", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항5 - 재직기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerSdate5", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항5 - 재직기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerEdate5", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항5 - 부서명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerDeptNm5", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항5 - 직급", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJikweeNm5", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항5 - 담당업무", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJobNm5", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항5 - 퇴직사유", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerMemo5", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항5 - 연봉(만원)", 		Type:"Int",		Hidden:0, Width:120, Align:"Center", 	SaveName:"careerPay5", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항6 - 고용형태", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerWorkType6", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항6 - 회사명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerCmpNm6", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항6 - 재직기간", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerTerm6", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항6 - 재직기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerSdate6", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항6 - 재직기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerEdate6", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항6 - 부서명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerDeptNm6", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항6 - 직급", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJikweeNm6", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항6 - 담당업무", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJobNm6", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항6 - 퇴직사유", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerMemo6", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항6 - 연봉(만원)", 		Type:"Int",		Hidden:0, Width:120, Align:"Center", 	SaveName:"careerPay6", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항7 - 고용형태", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerWorkType7", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항7 - 회사명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerCmpNm7", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항7 - 재직기간", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerTerm7", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항7 - 재직기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerSdate7", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항7 - 재직기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerEdate7", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항7 - 부서명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerDeptNm7", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항7 - 직급", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJikweeNm7", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항7 - 담당업무", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJobNm7", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항7 - 퇴직사유", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerMemo7", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항7 - 연봉(만원)", 		Type:"Int",		Hidden:0, Width:120, Align:"Center", 	SaveName:"careerPay7", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항8 - 고용형태", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerWorkType8", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항8 - 회사명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerCmpNm8", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항8 - 재직기간", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerTerm8", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항8 - 재직기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerSdate8", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항8 - 재직기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerEdate8", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항8 - 부서명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerDeptNm8", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항8 - 직급", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJikweeNm8", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항8 - 담당업무", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJobNm8", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항8 - 퇴직사유", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerMemo8", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항8 - 연봉(만원)", 		Type:"Int",		Hidden:0, Width:120, Align:"Center", 	SaveName:"careerPay8", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항9 - 고용형태", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerWorkType9", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항9 - 회사명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerCmpNm9", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항9 - 재직기간", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerTerm9", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항9 - 재직기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerSdate9", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항9 - 재직기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerEdate9", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항9 - 부서명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerDeptNm9", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항9 - 직급", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJikweeNm9", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항9 - 담당업무", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJobNm9", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항9 - 퇴직사유", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerMemo9", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항9 - 연봉(만원)", 		Type:"Int",		Hidden:0, Width:120, Align:"Center", 	SaveName:"careerPay9", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항10 - 고용형태", 		Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerWorkType10", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항10 - 회사명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerCmpNm10", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항10 - 재직기간", 		Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerTerm10", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항10 - 재직기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerSdate10", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항10 - 재직기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"careerEdate10", KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항10 - 부서명", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerDeptNm10", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항10 - 직급", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJikweeNm10", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항10 - 담당업무", 		Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerJobNm10", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항10 - 퇴직사유", 		Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"careerMemo10", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"경력사항10 - 연봉(만원)", 		Type:"Int",		Hidden:0, Width:120, Align:"Center", 	SaveName:"careerPay10", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"총 프로젝트", 					Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"pjCnt", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"프로젝트1 - 제목", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"pjSubject", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"프로젝트1 - 발주처", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"pjOrderNm", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"프로젝트1 - 근무처", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"pjCmpNm", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"프로젝트1 - 수행기간", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"pjTerm", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"프로젝트1 - 수행기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"pjSdate", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"프로젝트1 - 수행기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"pjEdate", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"프로젝트1 - 기여도", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 		SaveName:"pjContribute", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"프로젝트1 - 참여역할", 			Type:"Text",	Hidden:0, Width:100, Align:"Center", 		SaveName:"pjRole", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"프로젝트1 - 주요 업무성과", 		Type:"Text",	Hidden:0, Width:150, Align:"Center", 		SaveName:"pjOutcome", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"외국어", 					Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"fLanguage", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"영어 회화수준", 				Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"speakLevel", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"영어 작문수준", 				Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"writeLevel", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"영어 독해수준", 				Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"readLevel", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"해외경험1 - 목적", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"fPurpose", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"해외경험1 - 국가", 			Type:"Combo",	Hidden:0, Width:120, Align:"Center", 	SaveName:"fNationCd", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"해외경험1 - 체류기간", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"fLiveTerm", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"해외경험1 - 체류기간 시작일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"fSdate", 			KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"해외경험1 - 체류기간 종료일", 	Type:"Date",	Hidden:0, Width:150, Align:"Center", 	SaveName:"fEdate", 			KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"해외경험1 - 경험내용", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"fNote", 			KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"총 자격증 개수", 				Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCnt", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증1 - 명칭", 				Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCd1", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증1 - 발급기관", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licOfficeNm1", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증1 - 등록번호", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licenseNo1", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증1 - 취득일", 			Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licSYmd1", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증2 - 명칭", 				Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCd2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증2 - 발급기관", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licOfficeNm2", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증2 - 등록번호", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licenseNo2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증2 - 취득일", 			Type:"Date",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licSYmd2", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증3 - 명칭", 				Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCd3", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증3 - 발급기관", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licOfficeNm3", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증3 - 등록번호", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licenseNo3", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증3 - 취득일",  			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licSYmd3", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증4 - 명칭",  				Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCd4", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증4 - 발급기관",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licOfficeNm4", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증4 - 등록번호",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseNo4", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증4 - 취득일",  			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licSYmd4", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증5 - 명칭",  				Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCd5", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증5 - 발급기관",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licOfficeNm5", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증5 - 등록번호",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseNo5", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증5 - 취득일",  			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licSYmd5", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증6 - 명칭",  				Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCd6", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증6 - 발급기관",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licOfficeNm6", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증6 - 등록번호",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseNo6", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증6 - 취득일",  			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licSYmd6", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증7 - 명칭",  				Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCd7", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증7 - 발급기관",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licOfficeNm7", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증7 - 등록번호",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseNo7", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증7 - 취득일",  			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licSYmd7", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증8 - 명칭",  				Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCd8", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증8 - 발급기관",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licOfficeNm8", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증8 - 등록번호",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseNo8", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증8 - 취득일",  			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licSYmd8", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증9 - 명칭",  				Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCd9", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증9 - 발급기관",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licOfficeNm9", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증9 - 등록번호",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseNo9", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증9 - 취득일",  			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licSYmd9", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격10 - 명칭",  				Type:"Combo",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseCd10", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증10 - 발급기관",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licOfficeNm10", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증10 - 등록번호",  			Type:"Text",	Hidden:0, Width:100, Align:"Center", 	SaveName:"licenseNo10", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"자격증10 - 취득일",  			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"licSYmd10", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"컴퓨터 활용능력 - 구분", 		Type:"Text",	Hidden:0, Width:150, Align:"Center", 	SaveName:"computerGubun", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"컴퓨터 활용능력 - 프로그램명", 	Type:"Text",	Hidden:0, Width:150, Align:"Center", 	SaveName:"computerLanguage", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"컴퓨터 활용능력 - 활용수준", 		Type:"Text",	Hidden:0, Width:150, Align:"Center", 	SaveName:"computerLevel", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"컴퓨터 활용능력 - 사용기간", 		Type:"Text",	Hidden:0, Width:150, Align:"Center", 	SaveName:"computerTerm", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"총 수상 횟수", 				Type:"Int",		Hidden:0, Width:100, Align:"Center", 	SaveName:"prizeCnt", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력1 - 상 이름", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"prizeCd1", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력1 - 수여기관", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"prizeOfficeNm1", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력1 - 수상일", 			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"prizeYmd1", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력1 - 상세내용", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"apizeMemo1", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력2 - 상 이름", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"prizeCd2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력2 - 수여기관", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"prizeOfficeNm2", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력2 - 수상일", 			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"prizeYmd2", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력2 - 상세내용", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"apizeMemo2", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력3 - 상 이름", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"prizeCd3", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력3 - 수여기관", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"prizeOfficeNm3", 	KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력3 - 수상일", 			Type:"Date",	Hidden:0, Width:120, Align:"Center", 	SaveName:"prizeYmd3", 		KeyField:0, Format:"Ymd", UpdateEdit:1, InsertEdit:1 },
			{Header:"수상경력3 - 상세내용", 			Type:"Text",	Hidden:0, Width:120, Align:"Center", 	SaveName:"apizeMemo3", 		KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"교육 이수사항1 - 교육과정명", 	Type:"Text", Hidden:0, Width:150, Align:"Center", SaveName:"eduNm1", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"교육 이수사항1 - 이수기간", 		Type:"Text", Hidden:0, Width:150, Align:"Center", SaveName:"eduTerm1", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"교육 이수사항1 - 시작일", 		Type:"Date", Hidden:0, Width:150, Align:"Center", SaveName:"eduSdate1", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"교육 이수사항1 - 종료일", 		Type:"Date", Hidden:0, Width:150, Align:"Center", SaveName:"eduEdate1", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"교육 이수사항1 - 교육기관", 		Type:"Text", Hidden:0, Width:150, Align:"Center", SaveName:"eduOffice1", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"교육 이수사항1 - 교육시간", 		Type:"Int",  Hidden:0, Width:150, Align:"Center", SaveName:"eduTime1", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"교육 이수사항1 - 주요내용", 		Type:"Text", Hidden:0, Width:150, Align:"Center",   SaveName:"eduContent", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"학내외활동 - 활동구분", 			Type:"Text", Hidden:0, Width:150, Align:"Center", SaveName:"actType", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"학내외활동 - 직위/역할", 		Type:"Text", Hidden:0, Width:150, Align:"Center", SaveName:"actRole", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"총 봉사활동 참여시간(시간)", 		Type:"Int",  Hidden:0, Width:150, Align:"Center", SaveName:"serveTotTime", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"봉사활동 - 구분", 				Type:"Text", Hidden:0, Width:120, Align:"Center", SaveName:"serveType", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"봉사활동 - 주관기관", 			Type:"Text", Hidden:0, Width:120, Align:"Center", SaveName:"serveOffice", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"봉사활동 - 참여시간(시간)", 		Type:"Int",  Hidden:0, Width:150, Align:"Center", SaveName:"serveTime", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
			{Header:"봉사활동 - 지역", 				Type:"Text", Hidden:0, Width:120, Align:"Center", SaveName:"serveArea", KeyField:0, Format:"", UpdateEdit:1, InsertEdit:1 },
		];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("sexType", 		{ComboText:"|남자|여자", ComboCode:"|1|2"} );
		sheet1.SetColProperty("jangYn", 		{ComboText:"|장애|해당없음", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("bohunYn", 		{ComboText:"|보훈|해당없음", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("hDType", 		{ComboText:"|주간|야간", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("uEntryType", 	{ComboText:"|편입|입학", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("uEntryType2", 	{ComboText:"|편입|입학", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("uEType", 		{ComboText:"|본교|분교", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("uEType2", 		{ComboText:"|본교|분교", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("uAcaDType", 		{ComboText:"|주간|야간", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("uAcaDType2",		{ComboText:"|주간|야간", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("uSubDType", 		{ComboText:"|주간|야간", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("uSubDType2", 	{ComboText:"|주간|야간", ComboCode:"|Y|N"} );

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
	});

	function getCommonCodeList() {
		let baseSYmd = $("#searchApplYmdFrom").val();
		let baseEYmd = $("#searchApplYmdTo").val();

		var nationalCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290", baseSYmd, baseEYmd), "");	//소재국가
		sheet1.SetColProperty("nationalCd", 			{ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );	//소재국가
		sheet1.SetColProperty("fNationCd", 			{ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );	//해외경험1 - 국가

		var famCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20120", baseSYmd, baseEYmd), " ");	//가족관계
		sheet1.SetColProperty("famCd1", 		{ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );
		sheet1.SetColProperty("famCd2", 		{ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );
		sheet1.SetColProperty("famCd3", 		{ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );
		sheet1.SetColProperty("famCd4", 		{ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );
		sheet1.SetColProperty("famCd5", 		{ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );
		sheet1.SetColProperty("famCd6", 		{ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );

		var armyDCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20210", baseSYmd, baseEYmd)); //병과
		sheet1.SetColProperty("armyDCd", 	{ComboText:"|"+armyDCdList[0], ComboCode:"|"+armyDCdList[1]} );

		var transferCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20200", baseSYmd, baseEYmd)); //병역구분
		sheet1.SetColProperty("transferCd", 	{ComboText:"|"+transferCdList[0], ComboCode:"|"+transferCdList[1]} );

		var dischargeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20240", baseSYmd, baseEYmd)); //제대구분
		sheet1.SetColProperty("dischargeCd", 	{ComboText:"|"+dischargeCdList[0], ComboCode:"|"+dischargeCdList[1]} );

		var armyGradeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20220", baseSYmd, baseEYmd)); //계급
		sheet1.SetColProperty("armyGradeCd", 	{ComboText:"|"+armyGradeCdList[0], ComboCode:"|"+armyGradeCdList[1]} );

		var armyCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20230", baseSYmd, baseEYmd)); //군별
		sheet1.SetColProperty("armyCd", 	{ComboText:"|"+armyCdList[0], ComboCode:"|"+armyCdList[1]} );

		var armyDCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20210", baseSYmd, baseEYmd)); //병과
		sheet1.SetColProperty("armyDCd", 	{ComboText:"|"+armyDCdList[0], ComboCode:"|"+armyDCdList[1]} );

		var finalAcaCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20130", baseSYmd, baseEYmd)); //최종학력
		sheet1.SetColProperty("finalAcaCd", 	{ComboText:"|"+finalAcaCdList[0], ComboCode:"|"+finalAcaCdList[1]} );

		var hAcaSchCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=3", "H20145", baseSYmd, baseEYmd)); //고등학교 - 학교명
		sheet1.SetColProperty("hAcaSchCd", 	{ComboText:"|"+hAcaSchCdList[0], ComboCode:"|"+hAcaSchCdList[1]}  );

		var hAcaYnList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "F20140", baseSYmd, baseEYmd)); //고등학교 - 졸업구분
		sheet1.SetColProperty("hAcaYn", 	{ComboText:"|"+hAcaYnList[0], ComboCode:"|"+hAcaYnList[1]} );

		var acaSchCdList1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=4", "H20145", baseSYmd, baseEYmd)); //대학명
		var acaSchCdList2 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=5", "H20145", baseSYmd, baseEYmd)); //대학교명
		var acaSchCdList3 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=6", "H20145", baseSYmd, baseEYmd)); //대학원명(석사)
		var acaSchCdList4 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=7", "H20145", baseSYmd, baseEYmd)); //대학원명(박사)
		//최종졸업 대학교명
		sheet1.SetColProperty("uFinalAcaSchCd", 	{ComboText:"|"+acaSchCdList1[0]+"|"+acaSchCdList2[0]+"|"+acaSchCdList3[0]+"|"+acaSchCdList4[0], ComboCode:"|"+acaSchCdList1[1]+"|"+acaSchCdList2[1]+"|"+acaSchCdList3[1]+"|"+acaSchCdList4[1]} );
		//대학교 - 학교명
		sheet1.SetColProperty("uAcaSchCd", 	{ComboText:"|"+acaSchCdList1[0]+"|"+acaSchCdList2[0]+"|"+acaSchCdList3[0]+"|"+acaSchCdList4[0], ComboCode:"|"+acaSchCdList1[1]+"|"+acaSchCdList2[1]+"|"+acaSchCdList3[1]+"|"+acaSchCdList4[1]} );
		sheet1.SetColProperty("uAcaSchCd2", 	{ComboText:"|"+acaSchCdList1[0]+"|"+acaSchCdList2[0]+"|"+acaSchCdList3[0]+"|"+acaSchCdList4[0], ComboCode:"|"+acaSchCdList1[1]+"|"+acaSchCdList2[1]+"|"+acaSchCdList3[1]+"|"+acaSchCdList4[1]} );

		var uAcaDegCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20140", baseSYmd, baseEYmd)); //대학교1 - 학위구분
		sheet1.SetColProperty("uAcaDegCd", 	{ComboText:"|"+uAcaDegCdList[0], ComboCode:"|"+uAcaDegCdList[1]} );
		sheet1.SetColProperty("uAcaDegCd2", 	{ComboText:"|"+uAcaDegCdList[0], ComboCode:"|"+uAcaDegCdList[1]} );

		var uAcaYnList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "F20140", baseSYmd, baseEYmd)); //대학교 - 졸업구분
		sheet1.SetColProperty("uAcaYn", 	{ComboText:"|"+uAcaYnList[0], ComboCode:"|"+uAcaYnList[1]} );
		sheet1.SetColProperty("uAcaYn2", 	{ComboText:"|"+uAcaYnList[0], ComboCode:"|"+uAcaYnList[1]} );

		var uAcamajCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&orderByName=Y", "H20190", baseSYmd, baseEYmd)); //전공명
		sheet1.SetColProperty("uAcamajCd", 	{ComboText:"|"+uAcamajCdList[0], ComboCode:"|"+uAcamajCdList[1]} );
		sheet1.SetColProperty("uAcamajCd2", 	{ComboText:"|"+uAcamajCdList[0], ComboCode:"|"+uAcamajCdList[1]} );
		sheet1.SetColProperty("uSubmmajCd", 	{ComboText:"|"+uAcamajCdList[0], ComboCode:"|"+uAcamajCdList[1]} );
		sheet1.SetColProperty("uSubmmajCd2", 	{ComboText:"|"+uAcamajCdList[0], ComboCode:"|"+uAcamajCdList[1]} );

		var licenseCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&orderByName=Y", "H20160", baseSYmd, baseEYmd)); //자격증
		sheet1.SetColProperty("licenseCd1", 	{ComboText:"|"+licenseCdList[0], ComboCode:"|"+licenseCdList[1]} );
		sheet1.SetColProperty("licenseCd2", 	{ComboText:"|"+licenseCdList[0], ComboCode:"|"+licenseCdList[1]} );
		sheet1.SetColProperty("licenseCd3", 	{ComboText:"|"+licenseCdList[0], ComboCode:"|"+licenseCdList[1]} );
		sheet1.SetColProperty("licenseCd4", 	{ComboText:"|"+licenseCdList[0], ComboCode:"|"+licenseCdList[1]} );
		sheet1.SetColProperty("licenseCd5", 	{ComboText:"|"+licenseCdList[0], ComboCode:"|"+licenseCdList[1]} );
		sheet1.SetColProperty("licenseCd6", 	{ComboText:"|"+licenseCdList[0], ComboCode:"|"+licenseCdList[1]} );
		sheet1.SetColProperty("licenseCd7", 	{ComboText:"|"+licenseCdList[0], ComboCode:"|"+licenseCdList[1]} );
		sheet1.SetColProperty("licenseCd8", 	{ComboText:"|"+licenseCdList[0], ComboCode:"|"+licenseCdList[1]} );
		sheet1.SetColProperty("licenseCd9", 	{ComboText:"|"+licenseCdList[0], ComboCode:"|"+licenseCdList[1]} );
		sheet1.SetColProperty("licenseCd10", 	{ComboText:"|"+licenseCdList[0], ComboCode:"|"+licenseCdList[1]} );

// 		var prizeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&orderByName=Y", "H20250")); //상이름
// 		sheet1.SetColProperty("prizeCd1", 	{ComboText:"|"+prizeCdList[0], ComboCode:"|"+prizeCdList[1]} );
// 		sheet1.SetColProperty("prizeCd2", 	{ComboText:"|"+prizeCdList[0], ComboCode:"|"+prizeCdList[1]} );
// 		sheet1.SetColProperty("prizeCd3", 	{ComboText:"|"+prizeCdList[0], ComboCode:"|"+prizeCdList[1]} );

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			getCommonCodeList();
			sheet1.DoSearch( "${ctx}/RecApplicantReg.do?cmd=getRecApplicantRegList",$("#sheet1Form").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"applKey", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/RecApplicantReg.do?cmd=saveRecApplicantReg", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert();
			sheet1.SelectCell(row, "applKey");
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "applySeq","");
			sheet1.SetCellValue(row, "visualYn","Y");
			sheet1.SelectCell(row, "applKey");
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "UploadData":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "DownData":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "채용합격자정보등록_" + d.getTime();
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,DownRows:0};
			var d = new Date();
			var fName = "채용합격자정보등록(업로드)_" + d.getTime();
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
			sheetResize();
			
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				if(Code>0){
					alert("저장 되었습니다.");
					doAction1("Search");
				}else{
					alert(saveResultMsg);
				}
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function recSheetSize(){
		for(var i=3; i<sheet1.GetCols().length; i++){
			sheet1.SetColWidth(i,0);
		}
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>지원서 제출일자</th>
			<td>
				<input id="searchApplYmdFrom" name="searchApplYmdFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-60)%>"/> ~
				<input id="searchApplYmdTo" name="searchApplYmdTo" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),+0)%>"/>
			</td>
			<th>수험번호</th>
			<td>
				<input type="text" id="searchApplSeq" name="searchApplSeq" class="text" style="width:100px;"/>
			</td>
			<th>성명</th>
			<td>
				<input id="searchName" name="searchName" type="text" class="text" />
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="button">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" class="basic authR">양식다운로드</a>
				<a href="javascript:doAction1('Clear');" class="basic authR">초기화</a>
				<a href="javascript:doAction1('Insert')" class="basic authR">입력</a>
				<a href="javascript:doAction1('Copy')" 	class="basic authR">복사</a>
				<a href="javascript:doAction1('Save');" class="basic authR">저장</a>
				<a href="javascript:doAction1('UploadData');" class="basic authA">업로드</a>
				<a href="javascript:doAction1('DownData');" class="basic authA">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>