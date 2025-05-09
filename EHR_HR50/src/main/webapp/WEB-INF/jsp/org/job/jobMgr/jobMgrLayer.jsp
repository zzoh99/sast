<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<%@ page import="com.hr.common.util.DateUtil" %>

<!DOCTYPE html>
<html class="bodywrap">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
	<title>직무기술서</title>

	<style type="text/css">
	</style>
	<script type="text/javascript">
		var gPRow = "";
		var pGubun = "";
		var lastRow = 0;

		/*
		 * 핵심공통사무, 자격면허 탭을 제거 함 *
		 * 화면 초기로딩속도를 위하여 Search Action뿐만 아니라
		 * 스크립트 및, HTML화면 그리는 부분도 모두 주석처리 하였음
		 * 다시 살리고자 할 때 참고 할 것 by JSG
		 */
		<%--var p = eval("${popUpStatus}");--%>
		var selectSheet = null;
		$(function(){

			$( "#tabs" ).tabs();

			initSheet();

			const modal = window.top.document.LayerModalUtility.getModal('jobMgrLayer');

			var jobCd  		= modal.parameters.jobCd || '';
			var jobNm  		= modal.parameters.jobNm || '';
			var jobEngNm  	= modal.parameters.jobEngNm || '';
			var jobType		= modal.parameters.jobType || '';
			var memo		= modal.parameters.memo || '';
			var jobDefine  	= modal.parameters.jobDefine || '';
			var sdate  		= modal.parameters.sdate || '';
			var edate  		= modal.parameters.edate || '';
			var academyReq  = modal.parameters.academyReq || '';
			var majorReq  	= modal.parameters.majorReq || '';
			var careerReq  	= modal.parameters.careerReq || '';
			var otherJobReq = modal.parameters.otherJobReq || '';
			var note  		= modal.parameters.note || '';
			var seq  		= modal.parameters.seq || '';

			var majorReq2  =  modal.parameters.ajorReq2 || '';
			var majorNeed  =  modal.parameters.ajorNeed || '';
			var majorNeed2  = modal.parameters.majorNeed2 || '';

			var jobTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30010"), "");	//직무형태
			var jikgubReqList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30019"), " ");	//직급요건
			var academyReqList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30018"), " ");	//학력요건
			var careerReqList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30020"), " ");	//경력요건

			$("#sdate").datepicker2({startdate:"sdate"});
			$("#edate").datepicker2({enddate:"edate"});
			$("#jobType").html(jobTypeList[2]);
			$("#academyReq").html(academyReqList[2]);
			$("#careerReq").html(careerReqList[2]);

			$("#searchJobCd").val(jobCd);
			$("#jobCd").val(jobCd);
			$("#jobNm").val(jobNm);
			$("#jobEngNm").val(jobEngNm);
			$("#jobType").val(jobType);
			$("#memo").val(memo);
			$("#jobDefine").val(jobDefine);
			$("#sdate").val(sdate);
			$("#edate").val(edate);
			$("#academyReq").val(academyReq);
			$("#majorReq").val(majorReq);
			$("#careerReq").val(careerReq);
			$("#otherJobReq").val(otherJobReq);
			$("#note").val(note);
			$("#seq").val(seq);

			$("#majorReq2").val(majorReq2);
			$("#majorNeed").val(majorNeed);
			$("#majorNeed2").val(majorNeed2);

			// 숫자만 입력
			$("#seq").keyup(function() {
				 makeNumber(this,'A') ;
			 });

			$(".tab_bottom li").click(function() {
				$('.tab_bottom li').removeClass('active');
				$(this).addClass('active');
			});
		});

		function initSheet() {
			createIBSheet3(document.getElementById('jobMgrLayerSheet1-wrap'), "jobMgrLayerSheet1", "100%", 		"200px", "${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet2-wrap'), "jobMgrLayerSheet2", "100%", 		"200px", "${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet3-wrap'), "jobMgrLayerSheet3", "100%", 		"100%", "${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet41-wrap'), "jobMgrLayerSheet41", "100%",	"25%", "${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet42-wrap'), "jobMgrLayerSheet42", "100%",	"25%", "${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet11-wrap'), "jobMgrLayerSheet11", "100%",	"25%", "${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet5-wrap'), "jobMgrLayerSheet5", "100%", 		"50%", "${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet10-wrap'), "jobMgrLayerSheet10", "100%",	"50%", "${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet6-wrap'), "jobMgrLayerSheet6", "100%", 		"50%", "${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet7-wrap'), "jobMgrLayerSheet7", "100%", 		"50%","${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet8-wrap'), "jobMgrLayerSheet8", "100%", 		"200px","${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet9-wrap'), "jobMgrLayerSheet9", "100%", 		"200px", "${ssnLocaleCd}");
			createIBSheet3(document.getElementById('jobMgrLayerSheet12-wrap'), "jobMgrLayerSheet12", "100%",	"200px", "${ssnLocaleCd}");
		}

		// 직무기술서 팝업인 경우 어디에서나 직무코드만 Parameter 로 받으면 직무기술서 팝업을 띄울수 있도록 하였으며 세부내역 기능도 할 수 있도록 설계,
		// 직무기술서(세부내역), 직무분류표(직무기술서) 프로그램 에서 호출 하는 경우 비교, CBS, 2013.06.18
		function loadValue() {
			if($("#jobNm").val() == "") 		$("#jobNm").val(jobMgrLayerSheet1.GetCellValue(1,"jobNm"));
			if($("#jobEngNm").val() == "") 		$("#jobEngNm").val(jobMgrLayerSheet1.GetCellValue(1,"jobEngNm"));
			if($("#jobType").val() == "") 		$("#jobType").val(jobMgrLayerSheet1.GetCellValue(1,"jobType"));
			if($("#memo").val() == "") 			$("#memo").val(jobMgrLayerSheet1.GetCellValue(1,"memo"));
			if($("#jobDefine").val() == "") 	$("#jobDefine").val(jobMgrLayerSheet1.GetCellValue(1,"jobDefine"));
			if($("#sdate").val() == "") 		$("#sdate").val(jobMgrLayerSheet1.GetCellText(1,"sdate"));
			if($("#edate").val() == "") 		$("#edate").val(jobMgrLayerSheet1.GetCellText(1,"edate"));
			if($("#academyReq").val() == "") 	$("#academyReq").val(jobMgrLayerSheet1.GetCellValue(1,"academyReq"));
			if($("#majorReq").val() == "") 		$("#majorReq").val(jobMgrLayerSheet1.GetCellValue(1,"majorReq"));
			if($("#careerReq").val() == "") 	$("#careerReq").val(jobMgrLayerSheet1.GetCellValue(1,"careerReq"));
			if($("#otherJobReq").val() == "") 	$("#otherJobReq").val(jobMgrLayerSheet1.GetCellValue(1,"otherJobReq"));
			if($("#note").val() == "") 			$("#note").val(jobMgrLayerSheet1.GetCellValue(1,"note"));
			if($("#seq").val() == "") 			$("#seq").val(jobMgrLayerSheet1.GetCellValue(1,"seq"));

			if($("#majorReq2").val() == "") 	$("#majorReq2").val(jobMgrLayerSheet1.GetCellValue(1,"majorReq2"));
			if($("#majorNeed").val() == "") 	$("#majorNeed").val(jobMgrLayerSheet1.GetCellValue(1,"majorNeed"));
			if($("#majorNeed2").val() == "") 	$("#majorNeed2").val(jobMgrLayerSheet1.GetCellValue(1,"majorNeed2"));
		}

		function setValue() {
			const p = {
				jobCd : $("#jobCd").val(),
				jobNm : $("#jobNm").val(),
				jobEngNm : $("#jobEngNm").val(),
				jobType	: $("#jobType").val(),
				memo : $("#memo").val(),
				jobDefine : $("#jobDefine").val(),
				sdate : $("#sdate").val(),
				edate : $("#edate").val(),
				academyReq : $("#academyReq").val(),
				majorReq : $("#majorReq").val(),
				careerReq : $("#careerReq").val(),
				otherJobReq	: $("#otherJobReq").val(),
				note : $("#note").val(),
				seq	: $("#seq").val(),
				majorReq2 : $("#majorReq2").val(),
				majorNeed : $("#majorNeed").val(),
				majorNeed2 : $("#majorNeed2").val()
			};

			var modal = window.top.document.LayerModalUtility.getModal('jobMgrLayer');
			modal.fire('jobMgrLayerTrigger', p).hide();
		}

		$(function() {
			var initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

				{Header:"<sht:txt mid='priorJobCd' mdef='직무상위코드'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"priorJobCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",		Type:"Text",      Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jobCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='jobNmV2' mdef='직무명'/>",			Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    	ColMerge:0,   SaveName:"jobNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='jobEngNm' mdef='직무명(영문)'/>", 	Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    	ColMerge:0,   SaveName:"jobEngNm",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='jobType' mdef='직무형태'/>",		Type:"Text",      Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jobType",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='memoV8' mdef='직무목표'/>",		Type:"Text",      Hidden:1,  Width:0,  	 Align:"Left",    	ColMerge:0,   SaveName:"memo",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
				{Header:"<sht:txt mid='jobDefine' mdef='직무정의'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"jobDefine",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
				{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
				{Header:"<sht:txt mid='edate' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" },
				{Header:"<sht:txt mid='jikgubReq' mdef='직급요건'/>",  		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jikgubReq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='academyReq' mdef='학력요건'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"academyReq",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='majorReq' mdef='전공요건'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"majorReq",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },

				{Header:"<sht:txt mid='majorReq2' mdef='전공요건2'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"majorReq2",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='majorNeed' mdef='전공 필요여부'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"majorNeed",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='majorNeed2' mdef='전공 필요여부2'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"majorNeed2",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },

				{Header:"<sht:txt mid='careerReq' mdef='경력요건'/>",  		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"careerReq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='otherJobReq' mdef='경력요건(타직무)'/>", Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"otherJobReq",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='note' mdef='비고'/>",  			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"note",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
				{Header:"<sht:txt mid='seqV2' mdef='순서'/>", 			Type:"Int",  	  Hidden:1,  Width:30,   Align:"Center",  	ColMerge:1,   SaveName:"seq",     		KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
			]; IBS_InitSheet(jobMgrLayerSheet1, initdata);jobMgrLayerSheet1.SetVisible(true);jobMgrLayerSheet1.SetCountPosition(4);

			//수행조직
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='orgCdV4' mdef='조직코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='orgNmV7' mdef='수행조직'/>",	Type:"Popup",     Hidden:0,  Width:200,  Align:"Center",  ColMerge:0,   SaveName:"orgNm",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='memoV9' mdef='관련내용'/>",	Type:"Text",      Hidden:0,  Width:300,  Align:"Left",    ColMerge:0,   SaveName:"memo",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000,	MultiLineText:1 },
					{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",   KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",   KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" }
				]; IBS_InitSheet(jobMgrLayerSheet2, initdata);jobMgrLayerSheet2.SetEditable("${editable}");jobMgrLayerSheet2.SetVisible(true);jobMgrLayerSheet2.SetCountPosition(4);

				//핵심공통사무
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msPrevColumnMerge + msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
				initdata.Cols = [
					{Header:"<sht:txt mid='sNo' mdef='No'/>|<sht:txt mid='sNo' mdef='No'/>",										Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete' mdef='삭제'/>|<sht:txt mid='sDelete' mdef='삭제'/>",								Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"<sht:txt mid='statusCd' mdef='상태'/>|<sht:txt mid='statusCd' mdef='상태'/>",								Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
					{Header:"<sht:txt mid='enterCd' mdef='회사코드'/>|<sht:txt mid='enterCd' mdef='회사코드'/>",							Type:"Text",      	Hidden:1,  Width:0,    	Align:"Center",  ColMerge:0,   SaveName:"enterCd",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
					{Header:"<sht:txt mid='processCd' mdef='업무코드'/>|<sht:txt mid='processCd' mdef='업무코드'/>",						Type:"Text",      	Hidden:1,  Width:30,  Align:"Left",    ColMerge:0,   SaveName:"processCode",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
					{Header:"<sht:txt mid='jobCd' mdef='직무코드'/>|<sht:txt mid='jobCd' mdef='직무코드'/>",								Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='task' mdef='대분류'/>|<sht:txt mid='task' mdef='대분류'/>",									Type:"Text",      	Hidden:0,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"task",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='taskWeight' mdef='대분류\n업무비중'/>|<sht:txt mid='taskWeight' mdef='대분류\n업무비중'/>",		Type:"Int",      	Hidden:0,  Width:50,    Align:"Left",    ColMerge:1,   SaveName:"taskweight",  KeyField:0,   CalcLogic:"",   Format:"###\\%",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='activity' mdef='중분류'/>|<sht:txt mid='activity' mdef='중분류'/>",							Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",  ColMerge:1,   SaveName:"activity",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='activityWeight' mdef='중분류\n업무비중'/>|<sht:txt mid='activityWeight' mdef='중분류\n업무비중'/>",	Type:"Int",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"activityweight",KeyField:0,   CalcLogic:"",   Format:"###\\%",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },

					{Header:"<sht:txt mid='processTxt' mdef='소분류'/>|<sht:txt mid='processTxt' mdef='소분류'/>", 						Type:"Text",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"processText",   KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='output' mdef='산출물'/>|<sht:txt mid='output' mdef='산출물'/>",								Type:"Text",      	Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"output",   KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 },
					{Header:"<sht:txt mid='importance' mdef='중요도'/>|<sht:txt mid='importance' mdef='중요도'/>",						Type:"Combo",       Hidden:0,  Width:45,   Align:"Center",  ColMerge:0,   SaveName:"importance",		KeyField:0,   CalcLogic:"",   Format:"", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },

					{Header:"<sht:txt mid='difficulty' mdef='난이도'/>|<sht:txt mid='difficulty' mdef='난이도'/>",						Type:"Combo",      	Hidden:0,  Width:45,    Align:"Center",  ColMerge:0,   SaveName:"difficulty",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },

					{Header:"<sht:txt mid='roleStep' mdef='역할단계'/>|<sht:txt mid='entry' mdef='Entry'/>",							Type:"CheckBox",  	Hidden:0,  Width:45,   Align:"Center",  	ColMerge:0,   SaveName:"roleEntry", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"1", FalseValue:"0"},
					{Header:"<sht:txt mid='roleStep' mdef='역할단계'/>|<sht:txt mid='jm' mdef='JM'/>",									Type:"CheckBox",  	Hidden:0,  Width:45,   Align:"Center",  	ColMerge:0,   SaveName:"roleJm", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"1", FalseValue:"0"},
					{Header:"<sht:txt mid='roleStep' mdef='역할단계'/>|<sht:txt mid='sm' mdef='SM'/>",									Type:"CheckBox",  	Hidden:0,  Width:45,   Align:"Center",  	ColMerge:0,   SaveName:"roleSm", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"1", FalseValue:"0"},
					{Header:"<sht:txt mid='roleStep' mdef='역할단계'/>|<sht:txt mid='gm' mdef='GM'/>",									Type:"CheckBox",  	Hidden:0,  Width:45,   Align:"Center",  	ColMerge:0,   SaveName:"roleGm", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"1", FalseValue:"0"},

					{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>|<sht:txt mid='sYmdV1' mdef='시작일'/>",								Type:"Date",      	Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"<sht:txt mid='edate' mdef='종료일'/>|<sht:txt mid='edate' mdef='종료일'/>",								Type:"Date",      	Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" },
					{Header:"<sht:txt mid='chkid' mdef='작성자'/>|<sht:txt mid='chkid' mdef='작성자'/>",								Type:"Text",     	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkid",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='chkdate' mdef='작성일'/>|<sht:txt mid='chkdate' mdef='작성일'/>",							Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkdate",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 }

				]; IBS_InitSheet(jobMgrLayerSheet3, initdata);jobMgrLayerSheet3.SetEditable("${editable}");jobMgrLayerSheet3.SetVisible(true);jobMgrLayerSheet3.SetCountPosition(4);
				jobMgrLayerSheet3.SetColProperty("importance", 			{ComboText:"|상|중|하", ComboCode:"|H|M|L"} );	 //중요도
				jobMgrLayerSheet3.SetColProperty("difficulty", 			{ComboText:"|상|중|하", ComboCode:"|H|M|L"} );	//기술역량 요구수준


				//자격/면허
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

					{Header:"직무코드",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"자격증코드",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"licenseCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
					{Header:"자격증명", 		Type:"Popup",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"licenseNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
					{Header:"등급",			Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"licenseGrade",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"필요/권장\n여부",Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"reqGb",		KeyField:0,   CalcLogic:"",   Format:"",       		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },

					{Header:"시작일자", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"종료일자",		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" },
					{Header:"순서",			Type:"Int",       Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
					{Header:"작성자",			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkid",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"작성일",			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkdate",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
					]; IBS_InitSheet(jobMgrLayerSheet41, initdata);jobMgrLayerSheet41.SetEditable("${editable}");jobMgrLayerSheet41.SetVisible(true);jobMgrLayerSheet41.SetCountPosition(4);

				jobMgrLayerSheet41.SetColProperty("reqGb", 			{ComboText:"|필요|권장", ComboCode:"|N|P"} );

				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
					{Header:"직무코드",		Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"어학 명",			Type:"Combo",     	Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"foreignCd",  	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"등급/점수",		Type:"Text",      	Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"testPoint",KeyField:1,   CalcLogic:"",   Format:"",        	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:40 },
					{Header:"시험종류",		Type:"Text",      	Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"testKindCd",  KeyField:1,   CalcLogic:"",   Format:"",        	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"시험점수",		Type:"Text",      	Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"foreignLevel",  	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:40 },
					{Header:"필요/권장\n여부",	Type:"Combo",     	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"reqGb",		KeyField:0,   CalcLogic:"",   Format:"",       		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
					{Header:"시작일자", 		Type:"Date",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"종료일자",		Type:"Date",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" },
					{Header:"작성자",			Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkid",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"작성일",			Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkdate",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
					{Header:"순서",			Type:"Int",       	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
				]; IBS_InitSheet(jobMgrLayerSheet42, initdata);jobMgrLayerSheet42.SetEditable("${editable}");jobMgrLayerSheet42.SetVisible(true);jobMgrLayerSheet42.SetCountPosition(4);

				var userCd2 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20307"), "");

				jobMgrLayerSheet42.SetColProperty("reqGb", 			{ComboText:"|필요|권장", ComboCode:"|N|P"} );
				jobMgrLayerSheet42.SetColProperty("foreignCd", 		{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );

				//역량요건
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"competencyCd",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='competencyNm' mdef='역량명'/>",		Type:"Popup",     Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"competencyNm",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='mainAppType' mdef='역량구분'/>",	Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"competencyGb",KeyField:0,   CalcLogic:"",   Format:"",       		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
					{Header:"<sht:txt mid='demandLevel' mdef='요구수준'/>",	Type:"Text",      Hidden:1,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"demandLevel", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000,	MultiLineText:1 },
					{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" },
					{Header:"<sht:txt mid='seqV2' mdef='순서'/>",		Type:"Int",       Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
				]; IBS_InitSheet(jobMgrLayerSheet5, initdata);jobMgrLayerSheet5.SetEditable("${editable}");jobMgrLayerSheet5.SetVisible(true);jobMgrLayerSheet5.SetCountPosition(4);

				var competencyGb 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");	//역량구분
				jobMgrLayerSheet5.SetColProperty("competencyGb", 			{ComboText:competencyGb[0], ComboCode:competencyGb[1]} );	//역량구분

				//연관업무_선행직무
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='priorJobCdV1' mdef='선행직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"priorJobCd",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='priorJobNm' mdef='선행직무'/>",	Type:"Popup",     Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"priorJobNm",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='relatedLevel' mdef='관련도'/>",	Type:"Combo",   Hidden:0,  Width:50,    Align:"Center",  ColMerge:0,   SaveName:"relatedLevel",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='expYears' mdef='경험년수'/>",	Type:"Int",    	Hidden:0,  Width:50,    Align:"Center",  ColMerge:0,   SaveName:"expYears",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='seqV2' mdef='우선순위'/>",		Type:"Int",       Hidden:0,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
					{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" }

				]; IBS_InitSheet(jobMgrLayerSheet6, initdata);jobMgrLayerSheet6.SetEditable("${editable}");jobMgrLayerSheet6.SetVisible(true);jobMgrLayerSheet6.SetCountPosition(4);
				jobMgrLayerSheet6.SetColProperty("relatedLevel", 			{ComboText:"|상|중|하", ComboCode:"|H|M|L"} );	//기술역량 요구수준

				//연관업무_후행직무
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='afterJobCd' mdef='후행직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"afterJobCd",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='afterJobNm' mdef='후행직무'/>",	Type:"Popup",     Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"afterJobNm",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='relatedLevel' mdef='관련도'/>",	Type:"Combo",   Hidden:0,  Width:50,    Align:"Center",  ColMerge:0,   SaveName:"relatedLevel",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='seqV2' mdef='우선순위'/>",		Type:"Int",       Hidden:0,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
					{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" }

				]; IBS_InitSheet(jobMgrLayerSheet7, initdata);jobMgrLayerSheet7.SetEditable("${editable}");jobMgrLayerSheet7.SetVisible(true);jobMgrLayerSheet7.SetCountPosition(4);
				jobMgrLayerSheet7.SetColProperty("relatedLevel", 			{ComboText:"|상|중|하", ComboCode:"|H|M|L"} );	//기술역량 요구수준

				//이동가능직무_직군내
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"moveJikgunJobCd",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='moveJikgunJobNm' mdef='이동가능직무n(직군내)'/>",	Type:"Popup",     Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"moveJikgunJobNm",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" },
					{Header:"<sht:txt mid='seqV2' mdef='순서'/>",		Type:"Int",       Hidden:0,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
				]; IBS_InitSheet(jobMgrLayerSheet8, initdata);jobMgrLayerSheet8.SetEditable("${editable}");jobMgrLayerSheet8.SetVisible(true);jobMgrLayerSheet8.SetCountPosition(4);

				//이동가능직무_직렬내
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"moveJikryulJobCd",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='moveJikryulJobNm' mdef='이동가능직무n(직렬내)'/>",	Type:"Popup",     Hidden:0,  Width:90,  Align:"Left",    ColMerge:0,   SaveName:"moveJikryulJobNm",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" },
					{Header:"<sht:txt mid='seqV2' mdef='순서'/>",		Type:"Int",       Hidden:0,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
				]; IBS_InitSheet(jobMgrLayerSheet9, initdata);jobMgrLayerSheet9.SetEditable("${editable}");jobMgrLayerSheet9.SetVisible(true);jobMgrLayerSheet9.SetCountPosition(4);

				// 기술역량
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='competencyText' mdef='역량'/>",	Type:"Text",      Hidden:0,  Width:350,    Align:"Left",  ColMerge:0,   SaveName:"competencyText",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='demandLevel' mdef='요구수준'/>",	Type:"Combo",      Hidden:0,  Width:50,    Align:"Center",  ColMerge:0,   SaveName:"demandLevel",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" },
					{Header:"<sht:txt mid='seqV2' mdef='순서'/>",		Type:"Int",       Hidden:1,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
				]; IBS_InitSheet(jobMgrLayerSheet10, initdata);jobMgrLayerSheet10.SetEditable("${editable}");jobMgrLayerSheet10.SetVisible(true);jobMgrLayerSheet10.SetCountPosition(4);
				var demandlevel 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D10066"), "");	//기술역량 요구수준
				//jobMgrLayerSheet10.SetColProperty("demandLevel", 			{ComboText:"|"+demandlevel[0], ComboCode:"|"+demandlevel[1]} );	//기술역량 요구수준
				jobMgrLayerSheet10.SetColProperty("demandLevel", 			{ComboText:"|상|중|하", ComboCode:"|H|M|L"} );	//기술역량 요구수준

				// 교육/훈련
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='eduNm' mdef='과정명'/>",			Type:"Text",      Hidden:0,  Width:300,    Align:"Left",  ColMerge:0,   SaveName:"eduNm",   		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='eduOrg' mdef='시행기관'/>",	Type:"Text",      Hidden:0,  Width:150,    Align:"Left",  ColMerge:0,   SaveName:"eduOrg",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, EndDateCol: "edate" },
					{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" },
					{Header:"<sht:txt mid='seqV2' mdef='순서'/>",		Type:"Int",       Hidden:1,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
				]; IBS_InitSheet(jobMgrLayerSheet11, initdata);jobMgrLayerSheet11.SetEditable("${editable}");jobMgrLayerSheet11.SetVisible(true);jobMgrLayerSheet11.SetCountPosition(4);

				//kpi 20200414 추가 by lwm
				initdata = {};
				initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone, AutoFitColWidth:'init|search|resize|rowtransaction'};
				initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata.Cols = [
					{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"13",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
					{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"13",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
					{Header:"<sht:txt mid='statusCd' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"15",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

					{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
					{Header:"<sht:txt mid='kpiCd' mdef='KPI코드'/>",				Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"kpiCd",			KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
					{Header:"<sht:txt mid='kpiNm' mdef='KPI명'/>",				Type:"Text",     	Hidden:0,  Width:80,   Align:"Left",    ColMerge:0,   SaveName:"kpiNm",			KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='kpiFormulaNm' mdef='산식 및 측정기준'/>",	Type:"Text",   		Hidden:0,  Width:100,  Align:"Left",  	ColMerge:0,   SaveName:"kpiFormulaNm",	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"<sht:txt mid='note' mdef='비고'/>",					Type:"Text",    	Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"note",			KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
					{Header:"<sht:txt mid='chkdate' mdef='최종수정일'/>",			Type:"Date",       	Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"chkdate",		KeyField:0,   CalcLogic:"",   Format:"Ymd", 		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
					{Header:"<sht:txt mid='chkId' mdef='수정자'/>", 				Type:"Text",      	Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"chkid",   		KeyField:1,   CalcLogic:"",   Format:"",         	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 }
				]; IBS_InitSheet(jobMgrLayerSheet12, initdata);jobMgrLayerSheet12.SetEditable("${editable}");jobMgrLayerSheet12.SetVisible(true);jobMgrLayerSheet12.SetCountPosition(4);

			// $(window).smartresize(sheetResize);
			sheetInit();
			doAction1("Search");
			//doAction2("Search");
			doAction3("Search");
			doAction41("Search");
			doAction42("Search");
			doAction5("Search");
			doAction6("Search");
			doAction7("Search");
			//doAction8("Search");
			//doAction9("Search");
			doAction10("Search");
			doAction11("Search");
			doAction12("Search");
		});

		//Sheet1 Action
		function doAction1(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet1.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrList", $("#jobMgrLayerForm").serialize()); break;
			case "Clear":		jobMgrLayerSheet1.RemoveAll(); break;
			case "Down2Excel":	jobMgrLayerSheet1.Down2Excel(); break;
			}
		}

		// 조회 후 에러 메시지
		function jobMgrLayerSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } loadValue();
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		//수행조직
		function doAction2(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet2.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrOrgList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet2);
								jobMgrLayerSheet2.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrOrg", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":		var Row = jobMgrLayerSheet2.DataInsert(0);
								jobMgrLayerSheet2.SetCellValue(Row, "jobCd", $("#jobCd").val());
								jobMgrLayerSheet2.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
								//jobMgrLayerSheet2.SetCellValue(Row, "edate", "99991231");
								jobMgrLayerSheet2.SelectCell(Row, "orgNm");
								break;
			case "Copy":		jobMgrLayerSheet2.DataCopy(); break;
			case "Clear":		jobMgrLayerSheet2.RemoveAll(); break;
			case "Down2Excel":	jobMgrLayerSheet2.Down2Excel(); break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet2.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function jobMgrLayerSheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		function jobMgrLayerSheet2_OnResize(lWidth, lHeight) {
			try {
				// setSheetSize(jobMgrLayerSheet2);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		// 저장 후 메시지
		function jobMgrLayerSheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); doAction2("Search");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		// 팝업 클릭시 발생
		function jobMgrLayerSheet2_OnPopupClick(Row,Col) {
			try {
				if( jobMgrLayerSheet2.ColSaveName(Col) == "orgNm" ) {
					orgBasicPopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//  조직코드 조회
		function orgBasicPopup(Row){
			try{
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "orgBasicPopup";

				var args    = new Array();
				var win = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", args, "640","720");
			}catch(ex){
				alert("Open Popup Event Error : " + ex);
			}
		}

		//핵심공통사무
		function doAction3(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet3.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrTaskList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":		//if(!dupChk(jobMgrLayerSheet3,"jobCd|processText", true, true)){break;}
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet3);
								jobMgrLayerSheet3.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrTask", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":		var Row = jobMgrLayerSheet3.DataInsert(0);
								jobMgrLayerSheet3.SetCellValue(Row, "jobCd", $("#jobCd").val());
								jobMgrLayerSheet3.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
								//jobMgrLayerSheet3.SetCellValue(Row, "edate", "99991231");
								jobMgrLayerSheet3.SelectCell(Row, "taskNm");
								break;
			case "Copy":		var Row = jobMgrLayerSheet3.DataCopy();
								jobMgrLayerSheet3.SelectCell(Row, "processCode");
								jobMgrLayerSheet3.SetCellValue(Row, "processCode",""); break;
			case "Clear":		jobMgrLayerSheet3.RemoveAll(); break;
				case "Down2Excel":
				var param = {
					DownCols:makeHiddenSkipCol(jobMgrLayerSheet3),
					SheetDesign:1,
					FileName:"핵심과업_${curSysYyyyMMdd}",
					Merge:1
				};
				jobMgrLayerSheet3.Down2Excel(param);
				break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet3.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function jobMgrLayerSheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
				} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction3("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function jobMgrLayerSheet3_OnResize(lWidth, lHeight) {
			try {
				// setSheetSize(jobMgrLayerSheet3);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function jobMgrLayerSheet3_OnPopupClick(Row,Col) {
			try {
				if( jobMgrLayerSheet3.ColSaveName(Col) == "taskNm" ) {
					taskPopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//  공통사무코드 조회
		function taskPopup(Row){
			try{
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "taskPopup";

				var args    = new Array();
				var win = openPopup("/Popup.do?cmd=taskPopup&authPg=${authPg}", args, "840","720");
			}catch(ex){
				alert("Open Popup Event Error : " + ex);
			}
		}



		//자격면허
		function doAction41(sAction) {
			switch (sAction) {
				case "Search":
					jobMgrLayerSheet41.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrLicenseList", $("#jobMgrLayerForm").serialize() );
					break;
				case "Save":
					IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet41);
					jobMgrLayerSheet41.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrLicense", $("#jobMgrLayerForm").serialize() );
					break;
				case "Insert":
					var Row = jobMgrLayerSheet41.DataInsert(0);
					jobMgrLayerSheet41.SetCellValue(Row, "jobCd", $("#jobCd").val());
					jobMgrLayerSheet41.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					break;
				case "Copy":
					var Row = jobMgrLayerSheet41.DataCopy();
					jobMgrLayerSheet41.SelectCell(Row, "licenseCd");
					jobMgrLayerSheet41.SetCellValue(Row, "licenseCd","");
					break;
				case "Clear":
					jobMgrLayerSheet41.RemoveAll();
					break;
				case "Down2Excel":
					var param = {
						DownCols:makeHiddenSkipCol(jobMgrLayerSheet41),
						SheetDesign:1,
						FileName:"자격증_${curSysYyyyMMdd}",
						Merge:1
					};
					jobMgrLayerSheet41.Down2Excel(param);
					break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet41.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function jobMgrLayerSheet41_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet41_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction41("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function jobMgrLayerSheet41_OnResize(lWidth, lHeight) {
			try {
				// setSheetSize(jobMgrLayerSheet41);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		function jobMgrLayerSheet41_OnPopupClick(Row,Col) {
			try {
				if( jobMgrLayerSheet41.ColSaveName(Col) == "licenseNm" ) {
					gPRow = Row;
					pGubun = "licensePopup";

					let layerModal = new window.top.document.LayerModal({
						id : 'hrmLicenseLayer'
						, url : '/PsnalLicense.do?cmd=viewHrmLicenseLayer&authPg=${authPg}'
						, parameters : {}
						, width : 800
						, height : 520
						, title : '자격증 검색'
						, trigger :[
							{
								name : 'hrmLicenseTrigger'
								, callback : function(result){
									jobMgrLayerSheet41.SetCellValue(gPRow, "licenseCd", result.code);
									jobMgrLayerSheet41.SetCellValue(gPRow, "licenseNm", result.codeNm);
								}
							}
						]
					});
					layerModal.show();
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		// 셀에서 키보드가 눌렀을때 발생하는 이벤트
		function jobMgrLayerSheet41_OnKeyDown(Row, Col, KeyCode, Shift) {
			try {
				if(jobMgrLayerSheet41.GetCellEditable(Row,Col) == true) {
					if(jobMgrLayerSheet41.ColSaveName(Col) == "licenseNm" && KeyCode == 46) {
						jobMgrLayerSheet41.SetCellValue(Row,"licenseCd","");
					}
				}
			} catch (ex) {
				alert("OnKeyDown Event Error : " + ex);
			}
		}

		function doAction42(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet42.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrLgLicenseList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet42);
								jobMgrLayerSheet42.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrLgLicense", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":		var Row = jobMgrLayerSheet42.DataInsert(0);
								jobMgrLayerSheet42.SetCellValue(Row, "jobCd", $("#jobCd").val());
								jobMgrLayerSheet42.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
								break;
			case "Copy":		jobMgrLayerSheet42.DataCopy(); break;
			case "Clear":		jobMgrLayerSheet42.RemoveAll(); break;
			case "Down2Excel":
				var param = {
					DownCols:makeHiddenSkipCol(jobMgrLayerSheet42),
					SheetDesign:1,
					FileName:"어학_${curSysYyyyMMdd}",
					Merge:1
				};
				jobMgrLayerSheet42.Down2Excel(param);
				break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet42.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function jobMgrLayerSheet42_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet42_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction42("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function jobMgrLayerSheet42_OnResize(lWidth, lHeight) {
			try {
				// setSheetSize(jobMgrLayerSheet42);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		function jobMgrLayerSheet42_OnPopupClick(Row,Col) {
			try {
				if( jobMgrLayerSheet42.ColSaveName(Col) == "licenseCd" ) {
					// 팝업 띄우기. competencySchemePopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}


		/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


		//역량요건
		function doAction5(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet5.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrCompetencyList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet5);
								jobMgrLayerSheet5.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrCompetency", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":
				var Row = jobMgrLayerSheet5.DataInsert(0);
				jobMgrLayerSheet5.SetCellValue(Row, "jobCd", $("#jobCd").val());
				jobMgrLayerSheet5.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
				//jobMgrLayerSheet5.SetCellValue(Row, "edate", "99991231");
				//jobMgrLayerSheet5.SelectCell(Row, "competencyNm");
				break;
			case "Copy":		jobMgrLayerSheet5.DataCopy(); break;
			case "Clear":		jobMgrLayerSheet5.RemoveAll(); break;
			case "Down2Excel":
				var param = {
					DownCols:makeHiddenSkipCol(jobMgrLayerSheet5),
					SheetDesign:1,
					FileName:"행동역량요건_${curSysYyyyMMdd}",
					Merge:1
				};
				jobMgrLayerSheet5.Down2Excel(param);
				break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet5.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function jobMgrLayerSheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction5("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function jobMgrLayerSheet5_OnResize(lWidth, lHeight) {
			try {
				// setSheetSize(jobMgrLayerSheet5);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function jobMgrLayerSheet5_OnPopupClick(Row,Col) {
			try {
				if( jobMgrLayerSheet5.ColSaveName(Col) == "competencyNm" ) {
					competencySchemePopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//  역량분류표 조회
		function competencySchemePopup(Row){
			try{
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "competencySchemePopup";

				let competencySchemeLayer = new window.top.document.LayerModal({
					id : 'competencySchemeLayer'
					, url : '/Popup.do?cmd=competencySchemeLayer&authPg=R'
					, parameters : {}
					, width : 700
					, height : 720
					, title : '역량분류표 조회'
					, trigger :[
						{
							name : 'competencySchemeLayerTrigger'
							, callback : function(result){
								getReturnValue(result);
							}
						}
					]
				});
				competencySchemeLayer.show();
			}catch(ex){
				alert("Open Popup Event Error : " + ex);
			}
		}

		//연관업무_선행직무
		function doAction6(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet6.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrPriorJobList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet6);
								jobMgrLayerSheet6.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrPriorJob", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":		var Row = jobMgrLayerSheet6.DataInsert(0);
								jobMgrLayerSheet6.SetCellValue(Row, "jobCd", $("#jobCd").val());
								jobMgrLayerSheet6.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
								//jobMgrLayerSheet6.SetCellValue(Row, "edate", "99991231");
								jobMgrLayerSheet6.SelectCell(Row, "priorJobNm");
								break;
			case "Copy":		jobMgrLayerSheet6.DataCopy(); break;
			case "Clear":		jobMgrLayerSheet6.RemoveAll(); break;
			case "Down2Excel":
				var param = {
					DownCols:makeHiddenSkipCol(jobMgrLayerSheet6),
					SheetDesign:1,
					FileName:"선행직무_${curSysYyyyMMdd}",
					Merge:1
				};
				jobMgrLayerSheet6.Down2Excel(param);
				break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet6.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function jobMgrLayerSheet6_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet6_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction6("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function jobMgrLayerSheet6_OnResize(lWidth, lHeight) {
			try {
				// setSheetSize(jobMgrLayerSheet6);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		// 셀에 마우스 클릭했을때 발생하는 이벤트
		function jobMgrLayerSheet6_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
			try {
				selectSheet = "jobMgrLayerSheet6";
			} catch (ex) {
				alert("OnSelectCell Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function jobMgrLayerSheet6_OnPopupClick(Row,Col) {
			try {
				if( jobMgrLayerSheet6.ColSaveName(Col) == "priorJobNm" ) {
					jobSchemePopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//연관업무_후행직무
		function doAction7(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet7.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrAfterJobList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet7);
								jobMgrLayerSheet7.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrAfterJob", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":		var Row = jobMgrLayerSheet7.DataInsert(0);
								jobMgrLayerSheet7.SetCellValue(Row, "jobCd", $("#jobCd").val());
								jobMgrLayerSheet7.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
								//jobMgrLayerSheet7.SetCellValue(Row, "edate", "99991231");
								jobMgrLayerSheet7.SelectCell(Row, "afterJobNm");
								break;
			case "Copy":		jobMgrLayerSheet7.DataCopy(); break;
			case "Clear":		jobMgrLayerSheet7.RemoveAll(); break;
			case "Down2Excel":
				var param = {
					DownCols:makeHiddenSkipCol(jobMgrLayerSheet7),
					SheetDesign:1,
					FileName:"후행직무_${curSysYyyyMMdd}",
					Merge:1
				};
				jobMgrLayerSheet7.Down2Excel(param);
				break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet7.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function jobMgrLayerSheet7_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet7_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction7("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function jobMgrLayerSheet7_OnResize(lWidth, lHeight) {
			try {
				// setSheetSize(jobMgrLayerSheet7);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		// 셀에 마우스 클릭했을때 발생하는 이벤트
		function jobMgrLayerSheet7_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
			try {
				selectSheet = "jobMgrLayerSheet7";
			} catch (ex) {
				alert("OnSelectCell Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function jobMgrLayerSheet7_OnPopupClick(Row,Col) {
			try {
				if( jobMgrLayerSheet7.ColSaveName(Col) == "afterJobNm" ) {
					jobSchemePopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//이동가능직무_직군내
		function doAction8(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet8.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrMoveJikgunJobList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet8);
								jobMgrLayerSheet8.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrMoveJikgunJob", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":		var Row = jobMgrLayerSheet8.DataInsert(0);
								jobMgrLayerSheet8.SetCellValue(Row, "jobCd", $("#jobCd").val());
								jobMgrLayerSheet8.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
								//jobMgrLayerSheet8.SetCellValue(Row, "edate", "99991231");
								jobMgrLayerSheet8.SelectCell(Row, "moveJikgunJobNm");
								break;
			case "Copy":		jobMgrLayerSheet8.DataCopy(); break;
			case "Clear":		jobMgrLayerSheet8.RemoveAll(); break;
			case "Down2Excel":	jobMgrLayerSheet8.Down2Excel(); break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet8.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function jobMgrLayerSheet8_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet8_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction8("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function jobMgrLayerSheet8_OnResize(lWidth, lHeight) {
			try {
				// setSheetSize(jobMgrLayerSheet8);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		// 셀에 마우스 클릭했을때 발생하는 이벤트
		function jobMgrLayerSheet8_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
			try {
				selectSheet = "jobMgrLayerSheet8";
			} catch (ex) {
				alert("OnSelectCell Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function jobMgrLayerSheet8_OnPopupClick(Row,Col) {
			try {
				if( jobMgrLayerSheet8.ColSaveName(Col) == "moveJikgunJobNm" ) {
					jobSchemePopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//이동가능직무_직렬내
		function doAction9(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet9.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrMoveJikryulJobList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet9);
								jobMgrLayerSheet9.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrMoveJikryulJob", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":		var Row = jobMgrLayerSheet9.DataInsert(0);
								jobMgrLayerSheet9.SetCellValue(Row, "jobCd", $("#jobCd").val());
								jobMgrLayerSheet9.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
								//jobMgrLayerSheet9.SetCellValue(Row, "edate", "99991231");
								jobMgrLayerSheet9.SelectCell(Row, "moveJikryulJobNm");
								break;
			case "Copy":		jobMgrLayerSheet9.DataCopy(); break;
			case "Clear":		jobMgrLayerSheet9.RemoveAll(); break;
			case "Down2Excel":	jobMgrLayerSheet9.Down2Excel(); break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet9.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function jobMgrLayerSheet9_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet9_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction9("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function jobMgrLayerSheet9_OnResize(lWidth, lHeight) {
			try {
				// setSheetSize(jobMgrLayerSheet9);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		// 셀에 마우스 클릭했을때 발생하는 이벤트
		function jobMgrLayerSheet9_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
			try {
				selectSheet = "jobMgrLayerSheet9";
			} catch (ex) {
				alert("OnSelectCell Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function jobMgrLayerSheet9_OnPopupClick(Row,Col) {
			try {
				if( jobMgrLayerSheet9.ColSaveName(Col) == "moveJikryulJobNm" ) {
					jobSchemePopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//역량요건
		function doAction10(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet10.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrSkillCompetencyList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet10);
								jobMgrLayerSheet10.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrSkillCompetency", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":		var Row = jobMgrLayerSheet10.DataInsert(0);
								jobMgrLayerSheet10.SetCellValue(Row, "jobCd", $("#jobCd").val());
								jobMgrLayerSheet10.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
								//jobMgrLayerSheet5.SetCellValue(Row, "edate", "99991231");
								//jobMgrLayerSheet10.SelectCell(Row, "competencyNm");
								break;
			case "Copy":		jobMgrLayerSheet10.DataCopy(); break;
			case "Clear":		jobMgrLayerSheet10.RemoveAll(); break;
			case "Down2Excel":
				var param = {
					DownCols:makeHiddenSkipCol(jobMgrLayerSheet10),
					SheetDesign:1,
					FileName:"기술역량요건_${curSysYyyyMMdd}",
					Merge:1
				};
				jobMgrLayerSheet10.Down2Excel(param);
				break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet10.LoadExcel(params); break;
			}
		}

		//조회 후 에러 메시지
		function jobMgrLayerSheet10_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet10_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction10("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		//직무분류표 조회
		function jobSchemePopup(Row){
			try{
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "jobSchemePopup";

				let jobSchemeLayer = new window.top.document.LayerModal({
					id : 'jobSchemeLayer'
					, url : '/Popup.do?cmd=viewJobSchemeLayer&authPg=R'
					, parameters : {
						searchJobType : '10030',
						detailHidden : 1,
					}
					, width : 800
					, height : 520
					, title : '직무분류표 조회'
					, trigger :[
						{
							name : 'jobSchemeTrigger'
							, callback : function(result){
								getReturnValue(result);
							}
						}
					]
				});
				jobSchemeLayer.show();

			}catch(ex){
				alert("Open Popup Event Error : " + ex);
			}
		}

		function clickTabs(tabNum) {
			//hide클래스를 없앤 후 시트 리사이즈가 먹지 않는 문제 해결
			// switch (sAction) {
			// case "1":doAction1("Search");	break ;
			// case "2":doAction2("Search");	break ;
			// case "3":doAction3("Search");	break ;
			// case "4":doAction4("Search");	break ;
			// case "5":doAction5("Search");	break ;
			// case "6":doAction6("Search");	break ;
			// case "7":doAction7("Search");	break ;
			// }
			var tabId = 'sTabs-' + tabNum;
			$('.tab_content').addClass('hide');
			$('#' + tabId).removeClass('hide');
			sheetResize();
		}

		//팝업 콜백 함수.
		function getReturnValue(rv) {
			if(pGubun == "orgBasicPopup"){
				jobMgrLayerSheet2.SetCellValue(gPRow, "orgCd",		rv["orgCd"]);
				jobMgrLayerSheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
				jobMgrLayerSheet2.SetFocusAfterProcess(0);
			} else if(pGubun == "taskPopup") {
				jobMgrLayerSheet3.SetCellValue(gPRow, "taskCd",		rv["taskCd"]);
				jobMgrLayerSheet3.SetCellValue(gPRow, "taskNm",		rv["taskNm"]);
				jobMgrLayerSheet3.SetCellValue(gPRow, "memo",			rv["memo"]);
				jobMgrLayerSheet3.SetFocusAfterProcess(0);
			} else if(pGubun == "competencySchemePopup") {
				jobMgrLayerSheet5.SetCellValue(gPRow, "competencyCd",		rv["competencyCd"]);
				jobMgrLayerSheet5.SetCellValue(gPRow, "competencyNm",		rv["competencyNm"]);
				jobMgrLayerSheet5.SetCellValue(gPRow, "competencyGb",		rv["mainAppType"]);
			} else if(pGubun == "jobSchemePopup") {
				if( selectSheet == "jobMgrLayerSheet6" ) {
					jobMgrLayerSheet6.SetCellValue(gPRow, "priorJobCd",		rv["jobCd"]);
					jobMgrLayerSheet6.SetCellValue(gPRow, "priorJobNm",		rv["jobNm"]);
				} else if( selectSheet == "jobMgrLayerSheet7" ) {
					jobMgrLayerSheet7.SetCellValue(gPRow, "afterJobCd",		rv["jobCd"]);
					jobMgrLayerSheet7.SetCellValue(gPRow, "afterJobNm",		rv["jobNm"]);
				} else if( selectSheet == "jobMgrLayerSheet8" ) {
					jobMgrLayerSheet8.SetCellValue(gPRow, "moveJikgunJobCd",	rv["jobCd"]);
					jobMgrLayerSheet8.SetCellValue(gPRow, "moveJikgunJobNm",	rv["jobNm"]);
				} else if( selectSheet == "jobMgrLayerSheet9" ) {
					jobMgrLayerSheet9.SetCellValue(gPRow, "moveJikryulJobCd",	rv["jobCd"]);
					jobMgrLayerSheet9.SetCellValue(gPRow, "moveJikryulJobNm",	rv["jobNm"]);
				}
			}else if(pGubun == "licensePopup"){
				jobMgrLayerSheet41.SetCellValue(gPRow, "licenseCd", rv["code"]);
				jobMgrLayerSheet41.SetCellValue(gPRow, "licenseNm", rv["codeNm"]);
			}
		}


		//역량요건
		function doAction11(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet11.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrEducationList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet11);
								jobMgrLayerSheet11.DoSave( "${ctx}/JobMgr.do?cmd=saveJobMgrEducationList", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":		var Row = jobMgrLayerSheet11.DataInsert(0);
								jobMgrLayerSheet11.SetCellValue(Row, "jobCd", $("#jobCd").val());
								jobMgrLayerSheet11.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
								//jobMgrLayerSheet5.SetCellValue(Row, "edate", "99991231");
								//jobMgrLayerSheet10.SelectCell(Row, "competencyNm");
								break;
			case "Copy":		jobMgrLayerSheet11.DataCopy(); break;
			case "Clear":		jobMgrLayerSheet11.RemoveAll(); break;
			case "Down2Excel":
				var param = {
					DownCols:makeHiddenSkipCol(jobMgrLayerSheet11),
					SheetDesign:1,
					FileName:"교육_${curSysYyyyMMdd}",
					Merge:1
				};
				jobMgrLayerSheet11.Down2Excel(param);
				break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet11.LoadExcel(params); break;
			}
		}

		//조회 후 에러 메시지
		function jobMgrLayerSheet11_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet11_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction11("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		var countInt=0;
		var nextKpiCd=0;
		//kpi
		function doAction12(sAction) {
			switch (sAction) {
			case "Search": 	 	jobMgrLayerSheet12.DoSearch( "${ctx}/JobMgr.do?cmd=getKpiList", $("#jobMgrLayerForm").serialize() ); break;
			case "Save":
								IBS_SaveName(document.jobMgrLayerForm,jobMgrLayerSheet12);
								jobMgrLayerSheet12.DoSave( "${ctx}/JobMgr.do?cmd=saveKpiList", $("#jobMgrLayerForm").serialize() ); break;
			case "Insert":		var row = jobMgrLayerSheet12.DataInsert(0);
								jobMgrLayerSheet12.SetCellValue(row, "jobCd", $("#jobCd").val());
								//if(countInt==0){
								//	var aCall = ajaxCall("${ctx}/JobMgr.do?cmd=getNextKpiCd","",false);
								//	nextKpiCd = aCall.DATA.nextKpiCd;
								//	jobMgrLayerSheet12.SetCellValue(row, "kpiCd", 		nextKpiCd);
								//	countInt=countInt+1;
								//}else{
									nextKpiCd=nextKpiCd*1;
									nextKpiCd=nextKpiCd+1;
									jobMgrLayerSheet12.SetCellValue(row, "kpiCd", 		nextKpiCd);
								//}
								break;
			case "Copy":		jobMgrLayerSheet12.DataCopy(); break;
			case "Clear":		jobMgrLayerSheet12.RemoveAll(); break;
			case "Down2Excel":	jobMgrLayerSheet12.Down2Excel(); break;
			case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; jobMgrLayerSheet12.LoadExcel(params); break;
			}
		}

		//조회 후 에러 메시지
		function jobMgrLayerSheet12_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); }
				// sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function jobMgrLayerSheet12_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction12("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}
	</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="jobMgrLayerForm" name="jobMgrLayerForm" >
			<input type="hidden" id="searchJobCd" name="searchJobCd">
			<input type="hidden" id="jobCd" name="jobCd">
			<input type="hidden" id="ssnSabun" name="ssnSabun" value="${ssnSabun}">
			<input type="hidden" id="ssnEnterCd" name="ssnEnterCd" value="${ssnEnterCd}">
		</form>
		<div id="tabs" style="width:100%; height: auto;">
			<ul class="outer tab_bottom">
				<li onclick="clickTabs('01');" class="active">기본사항</li>
				<!-- <li onclick="clickTabs('2');">수행조직</li> -->
				<li onclick="clickTabs('3');">핵심과업</li>
				<li onclick="clickTabs('4');">자격요건</li>
				<li onclick="clickTabs('5');">역량요건</li>
				<li onclick="clickTabs('6');">연관업무</li>
				<!-- <li onclick="clickTabs('7');">이동가능직무</li> -->
				<li onclick="clickTabs('12');">KPI</li>
			</ul>
			<div id="sTabs-01" class="tab_content">
			<table class="table">
				<colgroup>
					<col width="15%" />
					<col width="45%" />
					<col width="10%" />
					<col width="30%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='112031' mdef='직무명'/></th>
					<td>
						<input id="jobNm" name="jobNm" type="text" class="text" style="width:99%;"/>
					</td>
					<th><tit:txt mid='112523' mdef='직무형태'/></th>
					<td>
						<select id="jobType" name="jobType">
						</select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='113604' mdef='직무명(영문)'/></th>
					<td>
						<input id="jobEngNm" name="jobEngNm" type="text" class="text" style="width:99%;"/>
					</td>
					<th><tit:txt mid='112413' mdef='유효기간'/></th>
					<td>
						<input id="sdate" name="sdate" type="text" size="10" class="date2" /> ~
						<input id="edate" name="edate" type="text" size="10" class="date2" />
						<input type="hidden" id="seq" name="seq">
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='112870' mdef='직무정의'/></th>
					<td colspan="4">
						<textarea id="jobDefine" name="jobDefine" style="width:99%;height:150px"></textarea>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='114293' mdef='직무목표'/></th>
					<td colspan="4">
						<textarea id="memo" name="memo" style="width:99%;height:150px"></textarea>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='114295' mdef='학력요건'/></th>
					<td  colspan="4">
						<select id="academyReq" name="academyReq">
						</select>
					</td>
				</tr>

				<tr>
					<th><tit:txt mid='112524' mdef='전공요건'/></th>
					<td>
						<input id="majorReq" name="majorReq" type="text" class="text" style="width:50%;"/>
					</td>
					<th><tit:txt mid='11251555' mdef='선호 필수여부'/></th>
					<td>
						<select id="majorNeed" name="majorNeed">
							<option value='' selected></option>
							<option value='N'>필요</option>
							<option value='P'>선호</option>
						</select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='1125242' mdef='전공요건2'/></th>
					<td>
						<input id="majorReq2" name="majorReq2" type="text" class="text" style="width:50%;"/>
					</td>
					<th><tit:txt mid='112515552' mdef='선호 필수여부'/></th>
					<td>
						<select id="majorNeed2" name="majorNeed2">
							<option value='' selected></option>
							<option value='N'>필요</option>
							<option value='P'>선호</option>
						</select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='113605' mdef='경력요건(타직무)'/></th>
					<td>
						<input id="otherJobReq" name="otherJobReq" type="text" class="text" style="width:50%;"/>
					</td>
					<th><tit:txt mid='112873' mdef='경력요건'/></th>
					<td>
						<select id="careerReq" name="careerReq">
						</select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='103783' mdef='비고'/></th>
					<td colspan="4">
						<textarea id="note" name="note" style="width:99%;height:100px"></textarea>
					</td>
				</tr>
			</table>
				<div id="jobMgrLayerSheet1-wrap-hide" class="hide">
					<div id="jobMgrLayerSheet1-wrap" class="hide"></div>
				</div>
			</div>

			<div id="sTabs-2" style="display : none;">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='jobMgrTab2' mdef='수행조직'/></li>
						<li class="btn">
							<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<btn:a href="javascript:doAction2('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction2('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction2('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
							<btn:a href="javascript:doAction2('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="jobMgrLayerSheet2-wrap"></div>
			</div>

			<div id="sTabs-3" class="tab_content hide">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='jobMgrTab3' mdef='핵심과업'/></li>
						<li class="btn">
							<a href="javascript:doAction3('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<btn:a href="javascript:doAction3('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction3('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction3('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
							<btn:a href="javascript:doAction3('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="jobMgrLayerSheet3-wrap"></div>
			</div>

			<div id="sTabs-4" class="tab_content hide">

				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">자격증</li>
						<li class="btn">
							<a href="javascript:doAction41('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
							<a href="javascript:doAction41('Copy')" 	class="btn outline-gray authA">복사</a>
							<a href="javascript:doAction41('Insert')" class="btn outline-gray authA">입력</a>
							<a href="javascript:doAction41('Save')" 	class="btn filled authA">저장</a>
							<a href="javascript:doAction41('Search')" 	class="btn dark authR">조회</a>
						</li>
					</ul>
					</div>
				</div>
				<div id="jobMgrLayerSheet41-wrap"></div>


				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">어학</li>
						<li class="btn">
							<a href="javascript:doAction42('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
							<a href="javascript:doAction42('Copy')" 	class="btn outline-gray authA">복사</a>
							<a href="javascript:doAction42('Insert')" class="btn outline-gray authA">입력</a>
							<a href="javascript:doAction42('Save')" 	class="btn filled authA">저장</a>
							<a href="javascript:doAction42('Search')" 	class="btn dark authR">조회</a>
						</li>
					</ul>
					</div>
				</div>
				<div id="jobMgrLayerSheet42-wrap"></div>


				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='jobMgrTab11' mdef='교육/훈련'/></li>
						<li class="btn">
							<a href="javascript:doAction11('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<btn:a href="javascript:doAction11('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction11('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction11('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
							<btn:a href="javascript:doAction11('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="jobMgrLayerSheet11-wrap"></div>

			</div>

			<div id="sTabs-5" class="tab_content hide">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='jobMgrTab5' mdef='행동역량요건'/></li>
						<li class="btn">
							<a href="javascript:doAction5('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<btn:a href="javascript:doAction5('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction5('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction5('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
							<btn:a href="javascript:doAction5('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="jobMgrLayerSheet5-wrap"></div>

				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='jobMgrTab10' mdef='기술역량요건'/></li>
						<li class="btn">
							<a href="javascript:doAction10('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<btn:a href="javascript:doAction10('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction10('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction10('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
							<btn:a href="javascript:doAction10('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="jobMgrLayerSheet10-wrap"></div>
			</div>

			<div id="sTabs-6" class="tab_content hide">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='priorJobNm' mdef='선행직무'/></li>
						<li class="btn">
							<a href="javascript:doAction6('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<btn:a href="javascript:doAction6('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction6('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction6('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
							<btn:a href="javascript:doAction6('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="jobMgrLayerSheet6-wrap"></div>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='afterJobNm' mdef='후행직무'/></li>
						<li class="btn">
							<a href="javascript:doAction7('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<btn:a href="javascript:doAction7('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
							<btn:a href="javascript:doAction7('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction7('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
							<btn:a href="javascript:doAction7('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="jobMgrLayerSheet7-wrap"></div>
			</div>

			<div id="sTabs-7" style="display : none;">
				<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<colgroup>
					<col width="50%" />
					<col width="1%" />
					<col width="" />
				</colgroup>
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='priorJobNm' mdef='선행직무'/></li>
								<li class="btn">
									<a href="javascript:doAction8('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
									<btn:a href="javascript:doAction8('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
									<btn:a href="javascript:doAction8('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
									<btn:a href="javascript:doAction8('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
									<btn:a href="javascript:doAction8('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
								</li>
							</ul>
							</div>
						</div>
						<div id="jobMgrLayerSheet8-wrap"></div>
					</td>
					<td>
						<div class="inner">
							<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='afterJobNm' mdef='후행직무'/></li>
								<li class="btn">
									<a href="javascript:doAction9('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
									<btn:a href="javascript:doAction9('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
									<btn:a href="javascript:doAction9('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
									<btn:a href="javascript:doAction9('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
									<btn:a href="javascript:doAction9('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
								</li>
							</ul>
							</div>
						</div>
						<div id="jobMgrLayerSheet9-wrap"></div>
					</td>
				</tr>
				</table>
			</div>

			<div id="sTabs-12" class="tab_content hide">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='kpiMgrTab2' mdef='KPI'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction12('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
							<btn:a href="javascript:doAction12('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
							<btn:a href="javascript:doAction12('Search')" 	css="btn dark authR" mid='search' mdef="조회"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="jobMgrLayerSheet12-wrap"></div>
			</div>
		</div>
	</div>
	<div class="modal_footer">
		<a href="javascript:setValue();" id="prcCall" class="btn filled"><tit:txt mid='104435' mdef='확인'/></a>
		<a href="javascript:closeCommonLayer('jobMgrLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>

</body>
</html>