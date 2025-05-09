<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<%@ page import="com.hr.common.util.DateUtil" %>

<!DOCTYPE html>
<html class="bodywrap">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title>직무기술서</title>
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
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
		var p = eval("${popUpStatus}");
		var selectSheet = null;
		$(function(){
			$( "#tabs" ).tabs();
			$("#sdate").datepicker2({startdate:"sdate"});
			$("#edate").datepicker2({enddate:"edate"});
			var arg = p.popDialogArgumentAll();
			var jobCd  		= arg["jobCd"];
			var jobNm  		= arg["jobNm"];
			var jobEngNm  	= arg["jobEngNm"];
			var jobType		= arg["jobType"];
			var memo		= arg["memo"];
			var jobDefine  	= arg["jobDefine"];
			var sdate  		= arg["sdate"];
			var edate  		= arg["edate"];
			var academyReq  = arg["academyReq"];
			var majorReq  	= arg["majorReq"];
			var careerReq  	= arg["careerReq"];
			var otherJobReq = arg["otherJobReq"];
			var note  		= arg["note"];
			var seq  		= arg["seq"];

			var majorReq2  = arg["majorReq2"];
			var majorNeed  = arg["majorNeed"];
			var majorNeed2  = arg["majorNeed2"];

			var jobTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30010"), "");	//직무형태
			var jikgubReqList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30019"), " ");	//직급요건
			var academyReqList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30018"), " ");	//학력요건
			var careerReqList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30020"), " ");	//경력요건

			$("#jobType").html(jobTypeList[2]);
			$("#academyReq").html(academyReqList[2]);
			$("#careerReq").html(careerReqList[2]);

			$("#searchJobCd").val(jobCd);
			$("#searchSingleJobCd").val(jobCd);
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

			//Cancel 버튼 처리
			$(".close").click(function(){
				p.self.close();
			});
		});

		// 직무기술서 팝업인 경우 어디에서나 직무코드만 Parameter 로 받으면 직무기술서 팝업을 띄울수 있도록 하였으며 세부내역 기능도 할 수 있도록 설계,
		// 직무기술서(세부내역), 직무분류표(직무기술서) 프로그램 에서 호출 하는 경우 비교, CBS, 2013.06.18
		function loadValue() {
			if($("#jobNm").val() == "") 		$("#jobNm").val(sheet1.GetCellValue(1,"jobNm"));
			if($("#jobEngNm").val() == "") 		$("#jobEngNm").val(sheet1.GetCellValue(1,"jobEngNm"));
			if($("#jobType").val() == "") 		$("#jobType").val(sheet1.GetCellValue(1,"jobType"));
			if($("#memo").val() == "") 			$("#memo").val(sheet1.GetCellValue(1,"memo"));
			if($("#jobDefine").val() == "") 	$("#jobDefine").val(sheet1.GetCellValue(1,"jobDefine"));
			if($("#sdate").val() == "") 		$("#sdate").val(sheet1.GetCellText(1,"sdate"));
			if($("#edate").val() == "") 		$("#edate").val(sheet1.GetCellText(1,"edate"));
			if($("#academyReq").val() == "") 	$("#academyReq").val(sheet1.GetCellValue(1,"academyReq"));
			if($("#majorReq").val() == "") 		$("#majorReq").val(sheet1.GetCellValue(1,"majorReq"));
			if($("#careerReq").val() == "") 	$("#careerReq").val(sheet1.GetCellValue(1,"careerReq"));
			if($("#otherJobReq").val() == "") 	$("#otherJobReq").val(sheet1.GetCellValue(1,"otherJobReq"));
			if($("#note").val() == "") 			$("#note").val(sheet1.GetCellValue(1,"note"));
			if($("#seq").val() == "") 			$("#seq").val(sheet1.GetCellValue(1,"seq"));

			if($("#majorReq2").val() == "") 	$("#majorReq2").val(sheet1.GetCellValue(1,"majorReq2"));
			if($("#majorNeed").val() == "") 	$("#majorNeed").val(sheet1.GetCellValue(1,"majorNeed"));
			if($("#majorNeed2").val() == "") 	$("#majorNeed2").val(sheet1.GetCellValue(1,"majorNeed2"));
		}

		function setValue() {
			var rv = new Array(15);
			rv["jobCd"] 		= $("#jobCd").val();
			rv["jobNm"]			= $("#jobNm").val();
			rv["jobEngNm"] 		= $("#jobEngNm").val();
			rv["jobType"] 		= $("#jobType").val();
			rv["memo"]			= $("#memo").val();
			rv["jobDefine"]		= $("#jobDefine").val();
			rv["sdate"]			= $("#sdate").val();
			rv["edate"]			= $("#edate").val();
			rv["academyReq"]	= $("#academyReq").val();
			rv["majorReq"]		= $("#majorReq").val();
			rv["careerReq"]		= $("#careerReq").val();
			rv["otherJobReq"]	= $("#otherJobReq").val();
			rv["note"]			= $("#note").val();
			rv["seq"]			= $("#seq").val();

			rv["majorReq2"]	= $("#majorReq2").val();
			rv["majorNeed"]	= $("#majorNeed").val();
			rv["majorNeed2"]	= $("#majorNeed2").val();

			p.popReturnValue(rv);
			p.window.close();
		}

		$(function() {
			var initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
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
				{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edate' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
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
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			//수행조직
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='orgCdV4' mdef='조직코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='orgNmV7' mdef='수행조직'/>",	Type:"Popup",     Hidden:0,  Width:200,  Align:"Center",  ColMerge:0,   SaveName:"orgNm",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='memoV9' mdef='관련내용'/>",	Type:"Text",      Hidden:0,  Width:300,  Align:"Left",    ColMerge:0,   SaveName:"memo",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000,	MultiLineText:1 },
				{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",   KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",   KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
			]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

			//핵심공통사무
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msPrevColumnMerge + msHeaderOnly};
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

				{Header:"<sht:txt mid='processTxt' mdef='소분류'/>|<sht:txt mid='processTxt' mdef='소분류'/>", 						Type:"Text",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"processText",   KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
				{Header:"<sht:txt mid='output' mdef='산출물'/>|<sht:txt mid='output' mdef='산출물'/>",								Type:"Text",      	Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"output",   KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 },
				{Header:"<sht:txt mid='importance' mdef='중요도'/>|<sht:txt mid='importance' mdef='중요도'/>",						Type:"Combo",       Hidden:0,  Width:45,   Align:"Center",  ColMerge:0,   SaveName:"importance",		KeyField:0,   CalcLogic:"",   Format:"", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },

				{Header:"<sht:txt mid='difficulty' mdef='난이도'/>|<sht:txt mid='difficulty' mdef='난이도'/>",						Type:"Combo",      	Hidden:0,  Width:45,    Align:"Center",  ColMerge:0,   SaveName:"difficulty",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },

				{Header:"<sht:txt mid='roleStep' mdef='역할단계'/>|<sht:txt mid='entry' mdef='Entry'/>",							Type:"CheckBox",  	Hidden:0,  Width:45,   Align:"Center",  	ColMerge:0,   SaveName:"roleEntry", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"1", FalseValue:"0"},
				{Header:"<sht:txt mid='roleStep' mdef='역할단계'/>|<sht:txt mid='jm' mdef='JM'/>",									Type:"CheckBox",  	Hidden:0,  Width:45,   Align:"Center",  	ColMerge:0,   SaveName:"roleJm", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"1", FalseValue:"0"},
				{Header:"<sht:txt mid='roleStep' mdef='역할단계'/>|<sht:txt mid='sm' mdef='SM'/>",									Type:"CheckBox",  	Hidden:0,  Width:45,   Align:"Center",  	ColMerge:0,   SaveName:"roleSm", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"1", FalseValue:"0"},
				{Header:"<sht:txt mid='roleStep' mdef='역할단계'/>|<sht:txt mid='gm' mdef='GM'/>",									Type:"CheckBox",  	Hidden:0,  Width:45,   Align:"Center",  	ColMerge:0,   SaveName:"roleGm", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"1", FalseValue:"0"},

				{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>|<sht:txt mid='sYmdV1' mdef='시작일'/>",								Type:"Date",      	Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edate' mdef='종료일'/>|<sht:txt mid='edate' mdef='종료일'/>",								Type:"Date",      	Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='chkid' mdef='작성자'/>|<sht:txt mid='chkid' mdef='작성자'/>",								Type:"Text",     	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkid",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='chkdate' mdef='작성일'/>|<sht:txt mid='chkdate' mdef='작성일'/>",							Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkdate",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 }

			]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);
			sheet3.SetColProperty("importance", 			{ComboText:"|상|중|하", ComboCode:"|H|M|L"} );	 //중요도
			sheet3.SetColProperty("difficulty", 			{ComboText:"|상|중|하", ComboCode:"|H|M|L"} );	//기술역량 요구수준


			//자격/면허
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"직무코드",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"자격증 명",		Type:"Text",     Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"licenseNm",  	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
				{Header:"자격증코드",		Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"licenseCd",  	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:15 },
				{Header:"등급",			Type:"Text",      Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"licenseGrade",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"필요/권장\n여부",	Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"reqGb",		KeyField:0,   CalcLogic:"",   Format:"",       		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },

				{Header:"시작일자", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"종료일자",		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"순서",			Type:"Int",       Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
				{Header:"작성자",			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkid",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"작성일",			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkdate",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
			]; IBS_InitSheet(sheet41, initdata);sheet41.SetEditable("${editable}");sheet41.SetVisible(true);sheet41.SetCountPosition(4);

			sheet41.SetColProperty("reqGb", 			{ComboText:"|필요|권장", ComboCode:"|N|P"} );


			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
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
				{Header:"시작일자", 		Type:"Date",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"종료일자",		Type:"Date",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"작성자",			Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkid",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"작성일",			Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkdate",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8 },
				{Header:"순서",			Type:"Int",       	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
			]; IBS_InitSheet(sheet42, initdata);sheet42.SetEditable("${editable}");sheet42.SetVisible(true);sheet42.SetCountPosition(4);

			var userCd2 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20307"), "");

			sheet42.SetColProperty("reqGb", 			{ComboText:"|필요|권장", ComboCode:"|N|P"} );
			sheet42.SetColProperty("foreignCd", 		{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );

			//역량요건
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
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
				{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='seqV2' mdef='순서'/>",		Type:"Int",       Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
			]; IBS_InitSheet(sheet5, initdata);sheet5.SetEditable("${editable}");sheet5.SetVisible(true);sheet5.SetCountPosition(4);

			var competencyGb 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");	//역량구분
			sheet5.SetColProperty("competencyGb", 			{ComboText:competencyGb[0], ComboCode:competencyGb[1]} );	//역량구분

			//연관업무_선행직무
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
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
				{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }

			]; IBS_InitSheet(sheet6, initdata);sheet6.SetEditable("${editable}");sheet6.SetVisible(true);sheet6.SetCountPosition(4);
			sheet6.SetColProperty("relatedLevel", 			{ComboText:"|상|중|하", ComboCode:"|H|M|L"} );	//기술역량 요구수준

			//연관업무_후행직무
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
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
				{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }

			]; IBS_InitSheet(sheet7, initdata);sheet7.SetEditable("${editable}");sheet7.SetVisible(true);sheet7.SetCountPosition(4);
			sheet7.SetColProperty("relatedLevel", 			{ComboText:"|상|중|하", ComboCode:"|H|M|L"} );	//기술역량 요구수준

			//이동가능직무_직군내
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"moveJikgunJobCd",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='moveJikgunJobNm' mdef='이동가능직무n(직군내)'/>",	Type:"Popup",     Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"moveJikgunJobNm",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='seqV2' mdef='순서'/>",		Type:"Int",       Hidden:0,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
			]; IBS_InitSheet(sheet8, initdata);sheet8.SetEditable("${editable}");sheet8.SetVisible(true);sheet8.SetCountPosition(4);

			//이동가능직무_직렬내
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"moveJikryulJobCd",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='moveJikryulJobNm' mdef='이동가능직무n(직렬내)'/>",	Type:"Popup",     Hidden:0,  Width:90,  Align:"Left",    ColMerge:0,   SaveName:"moveJikryulJobNm",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='seqV2' mdef='순서'/>",		Type:"Int",       Hidden:0,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
			]; IBS_InitSheet(sheet9, initdata);sheet9.SetEditable("${editable}");sheet9.SetVisible(true);sheet9.SetCountPosition(4);

			// 기술역량
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='competencyText' mdef='역량'/>",	Type:"Text",      Hidden:0,  Width:350,    Align:"Left",  ColMerge:0,   SaveName:"competencyText",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='demandLevel' mdef='요구수준'/>",	Type:"Combo",      Hidden:0,  Width:50,    Align:"Center",  ColMerge:0,   SaveName:"demandLevel",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='seqV2' mdef='순서'/>",		Type:"Int",       Hidden:1,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
			]; IBS_InitSheet(sheet10, initdata);sheet10.SetEditable("${editable}");sheet10.SetVisible(true);sheet10.SetCountPosition(4);
			var demandlevel 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D10066"), "");	//기술역량 요구수준
			//sheet10.SetColProperty("demandLevel", 			{ComboText:"|"+demandlevel[0], ComboCode:"|"+demandlevel[1]} );	//기술역량 요구수준
			sheet10.SetColProperty("demandLevel", 			{ComboText:"|상|중|하", ComboCode:"|H|M|L"} );	//기술역량 요구수준

			// 교육/훈련
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"jobCd",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='eduNm' mdef='과정명'/>",			Type:"Text",      Hidden:0,  Width:300,    Align:"Left",  ColMerge:0,   SaveName:"eduNm",   		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='eduOrg' mdef='시행기관'/>",	Type:"Text",      Hidden:0,  Width:150,    Align:"Left",  ColMerge:0,   SaveName:"eduOrg",   	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>", 	Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sdate",   	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edateV3' mdef='종료일자'/>",	Type:"Date",      Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"edate",   	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='seqV2' mdef='순서'/>",		Type:"Int",       Hidden:1,  Width:30,   Align:"Center",  ColMerge:0,   SaveName:"seq",			KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
			]; IBS_InitSheet(sheet11, initdata);sheet11.SetEditable("${editable}");sheet11.SetVisible(true);sheet11.SetCountPosition(4);


			//kpi 20200414 추가 by lwm
			initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
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


			]; IBS_InitSheet(sheet12, initdata);sheet12.SetEditable("${editable}");sheet12.SetVisible(true);sheet12.SetCountPosition(4);

			$(window).smartresize(sheetResize); sheetInit();
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
				case "Search": 	 	sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrList", $("#srchFrm").serialize() ); break;
				case "Clear":		sheet1.RemoveAll(); break;
				case "Down2Excel":	sheet1.Down2Excel(); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } loadValue(); sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		//수행조직
		function doAction2(sAction) {
			switch (sAction) {
				case "Search": 	 	sheet2.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrOrgList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet2);
					sheet2.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrOrg", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet2.DataInsert(0);
					sheet2.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet2.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet2.SetCellValue(Row, "edate", "99991231");
					sheet2.SelectCell(Row, "orgNm");
					break;
				case "Copy":		sheet2.DataCopy(); break;
				case "Clear":		sheet2.RemoveAll(); break;
				case "Down2Excel":	sheet2.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		function sheet2_OnResize(lWidth, lHeight) {
			try {
				setSheetSize(sheet2);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		// 저장 후 메시지
		function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); doAction2("Search");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		// 팝업 클릭시 발생
		function sheet2_OnPopupClick(Row,Col) {
			try {
				if( sheet2.ColSaveName(Col) == "orgNm" ) {
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
				case "Search": 	 	sheet3.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrTaskList", $("#srchFrm").serialize() ); break;
				case "Save":		if(!dupChk(sheet3,"jobCd|processText", true, true)){break;}
					IBS_SaveName(document.srchFrm,sheet3);
					sheet3.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrTask", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet3.DataInsert(0);
					sheet3.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet3.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet3.SetCellValue(Row, "edate", "99991231");
					sheet3.SelectCell(Row, "taskNm");
					break;
				case "Copy":		var Row = sheet3.DataCopy();
					sheet3.SelectCell(Row, "processCode");
					sheet3.SetCellValue(Row, "processCode",""); break;
				case "Clear":		sheet3.RemoveAll(); break;
				case "Down2Excel":	sheet3.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet3.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction3("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function sheet3_OnResize(lWidth, lHeight) {
			try {
				setSheetSize(sheet3);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function sheet3_OnPopupClick(Row,Col) {
			try {
				if( sheet3.ColSaveName(Col) == "taskNm" ) {
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
				case "Search": 	 	sheet41.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrLicenseList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet41);
					sheet41.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrLicense", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet41.DataInsert(0);
					sheet41.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet41.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet4.SetCellValue(Row, "edate", "99991231");
					sheet41.SetCellValue(Row, "licenseCd", $("#jobCd").val() + '_' + sheet41.LastRow());
					break;
				case "Copy":		sheet41.DataCopy(); break;
				case "Clear":		sheet41.RemoveAll(); break;
				case "Down2Excel":	sheet41.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet41.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet41_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet41_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction41("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function sheet41_OnResize(lWidth, lHeight) {
			try {
				setSheetSize(sheet41);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		function sheet41_OnPopupClick(Row,Col) {
			try {
				if( sheet41.ColSaveName(Col) == "licenseNm" ) {
					gPRow = Row;
					pGubun = "licensePopup";
					var win = openPopup("/HrmLicensePopup.do?cmd=viewHrmLicensePopup&authPg=${authPg}", "", "600","620");
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}


		function doAction42(sAction) {
			switch (sAction) {
				case "Search": 	 	sheet42.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrLgLicenseList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet42);
					sheet42.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrLgLicense", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet42.DataInsert(0);
					sheet42.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet42.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					break;
				case "Copy":		sheet42.DataCopy(); break;
				case "Clear":		sheet42.RemoveAll(); break;
				case "Down2Excel":	sheet42.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet42.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet42_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet42_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction42("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function sheet42_OnResize(lWidth, lHeight) {
			try {
				setSheetSize(sheet42);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		function sheet42_OnPopupClick(Row,Col) {
			try {
				if( sheet42.ColSaveName(Col) == "licenseCd" ) {
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
				case "Search": 	 	sheet5.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrCompetencyList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet5);
					sheet5.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrCompetency", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet5.DataInsert(0);
					sheet5.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet5.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet5.SetCellValue(Row, "edate", "99991231");
					sheet5.SelectCell(Row, "competencyNm");
					break;
				case "Copy":		sheet5.DataCopy(); break;
				case "Clear":		sheet5.RemoveAll(); break;
				case "Down2Excel":	sheet5.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet5.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction5("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function sheet5_OnResize(lWidth, lHeight) {
			try {
				setSheetSize(sheet5);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function sheet5_OnPopupClick(Row,Col) {
			try {
				if( sheet5.ColSaveName(Col) == "competencyNm" ) {
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
				var args    = new Array();

				var win = openPopup("/Popup.do?cmd=competencySchemePopup&authPg=R", args, "740","720");
			}catch(ex){
				alert("Open Popup Event Error : " + ex);
			}
		}

		//연관업무_선행직무
		function doAction6(sAction) {
			switch (sAction) {
				case "Search": 	 	sheet6.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrPriorJobList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet6);
					sheet6.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrPriorJob", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet6.DataInsert(0);
					sheet6.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet6.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet6.SetCellValue(Row, "edate", "99991231");
					sheet6.SelectCell(Row, "priorJobNm");
					break;
				case "Copy":		sheet6.DataCopy(); break;
				case "Clear":		sheet6.RemoveAll(); break;
				case "Down2Excel":	sheet6.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet6.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet6_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet6_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction6("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function sheet6_OnResize(lWidth, lHeight) {
			try {
				setSheetSize(sheet6);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		// 셀에 마우스 클릭했을때 발생하는 이벤트
		function sheet6_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
			try {
				selectSheet = "sheet6";
			} catch (ex) {
				alert("OnSelectCell Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function sheet6_OnPopupClick(Row,Col) {
			try {
				if( sheet6.ColSaveName(Col) == "priorJobNm" ) {
					jobSchemePopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//연관업무_후행직무
		function doAction7(sAction) {
			switch (sAction) {
				case "Search": 	 	sheet7.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrAfterJobList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet7);
					sheet7.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrAfterJob", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet7.DataInsert(0);
					sheet7.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet7.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet7.SetCellValue(Row, "edate", "99991231");
					sheet7.SelectCell(Row, "afterJobNm");
					break;
				case "Copy":		sheet7.DataCopy(); break;
				case "Clear":		sheet7.RemoveAll(); break;
				case "Down2Excel":	sheet7.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet7.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet7_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet7_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction7("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function sheet7_OnResize(lWidth, lHeight) {
			try {
				setSheetSize(sheet7);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		// 셀에 마우스 클릭했을때 발생하는 이벤트
		function sheet7_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
			try {
				selectSheet = "sheet7";
			} catch (ex) {
				alert("OnSelectCell Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function sheet7_OnPopupClick(Row,Col) {
			try {
				if( sheet7.ColSaveName(Col) == "afterJobNm" ) {
					jobSchemePopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//이동가능직무_직군내
		function doAction8(sAction) {
			switch (sAction) {
				case "Search": 	 	sheet8.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrMoveJikgunJobList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet8);
					sheet8.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrMoveJikgunJob", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet8.DataInsert(0);
					sheet8.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet8.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet8.SetCellValue(Row, "edate", "99991231");
					sheet8.SelectCell(Row, "moveJikgunJobNm");
					break;
				case "Copy":		sheet8.DataCopy(); break;
				case "Clear":		sheet8.RemoveAll(); break;
				case "Down2Excel":	sheet8.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet8.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet8_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet8_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction8("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function sheet8_OnResize(lWidth, lHeight) {
			try {
				setSheetSize(sheet8);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		// 셀에 마우스 클릭했을때 발생하는 이벤트
		function sheet8_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
			try {
				selectSheet = "sheet8";
			} catch (ex) {
				alert("OnSelectCell Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function sheet8_OnPopupClick(Row,Col) {
			try {
				if( sheet8.ColSaveName(Col) == "moveJikgunJobNm" ) {
					jobSchemePopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//이동가능직무_직렬내
		function doAction9(sAction) {
			switch (sAction) {
				case "Search": 	 	sheet9.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrMoveJikryulJobList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet9);
					sheet9.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrMoveJikryulJob", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet9.DataInsert(0);
					sheet9.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet9.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet9.SetCellValue(Row, "edate", "99991231");
					sheet9.SelectCell(Row, "moveJikryulJobNm");
					break;
				case "Copy":		sheet9.DataCopy(); break;
				case "Clear":		sheet9.RemoveAll(); break;
				case "Down2Excel":	sheet9.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet9.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet9_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet9_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction9("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		function sheet9_OnResize(lWidth, lHeight) {
			try {
				setSheetSize(sheet9);
			} catch (ex) {
				alert("OnResize Event Error : " + ex);
			}
		}

		// 셀에 마우스 클릭했을때 발생하는 이벤트
		function sheet9_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
			try {
				selectSheet = "sheet9";
			} catch (ex) {
				alert("OnSelectCell Event Error : " + ex);
			}
		}

		//팝업 클릭시 발생
		function sheet9_OnPopupClick(Row,Col) {
			try {
				if( sheet9.ColSaveName(Col) == "moveJikryulJobNm" ) {
					jobSchemePopup(Row) ;
				}
			} catch (ex) {
				alert("OnPopup Event Error : " + ex);
			}
		}

		//역량요건
		function doAction10(sAction) {
			switch (sAction) {
				case "Search": 	 	sheet10.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrSkillCompetencyList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet10);
					sheet10.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrSkillCompetency", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet10.DataInsert(0);
					sheet10.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet10.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet5.SetCellValue(Row, "edate", "99991231");
					//sheet10.SelectCell(Row, "competencyNm");
					break;
				case "Copy":		sheet10.DataCopy(); break;
				case "Clear":		sheet10.RemoveAll(); break;
				case "Down2Excel":	sheet10.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet10.LoadExcel(params); break;
			}
		}

		//조회 후 에러 메시지
		function sheet10_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet10_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction10("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		//직무분류표 조회
		function jobSchemePopup(Row){
			try{
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "jobSchemePopup";

				var args    = new Array();

				var win = openPopup("/Popup.do?cmd=jobSchemePopup&authPg=R", args, "740","720");
			}catch(ex){
				alert("Open Popup Event Error : " + ex);
			}
		}

		function startView() {
			//바디 로딩 완료후 화면 보여줌(로딩과정에서 화면 이상하게 보이는 현상 해결 by JSG)
			$("#tabs").removeClass("hide");
		}
		function clickTabs(sAction) {
			//hide클래스를 없앤 후 시트 리사이즈가 먹지 않는 문제 해결
			$(window).smartresize(sheetResize); sheetInit();
			/*switch (sAction) {
            case "1":doAction1("Search");	break ;
            case "2":doAction2("Search");	break ;
            case "3":doAction3("Search");	break ;
            case "4":doAction4("Search");	break ;
            case "5":doAction5("Search");	break ;
            case "6":doAction6("Search");	break ;
            case "7":doAction7("Search");	break ;
            }*/
		}

		//팝업 콜백 함수.
		function getReturnValue(returnValue) {
			var rv = $.parseJSON('{' + returnValue+ '}');

			if(pGubun == "orgBasicPopup"){
				sheet2.SetCellValue(gPRow, "orgCd",		rv["orgCd"]);
				sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
				sheet2.SetFocusAfterProcess(0);
			} else if(pGubun == "taskPopup") {
				sheet3.SetCellValue(gPRow, "taskCd",		rv["taskCd"]);
				sheet3.SetCellValue(gPRow, "taskNm",		rv["taskNm"]);
				sheet3.SetCellValue(gPRow, "memo",			rv["memo"]);
				sheet3.SetFocusAfterProcess(0);
			} else if(pGubun == "competencySchemePopup") {
				sheet5.SetCellValue(gPRow, "competencyCd",		rv["competencyCd"]);
				sheet5.SetCellValue(gPRow, "competencyNm",		rv["competencyNm"]);
				sheet5.SetCellValue(gPRow, "competencyGb",		rv["mainAppType"]);
			} else if(pGubun == "jobSchemePopup") {
				if( selectSheet == "sheet6" ) {
					sheet6.SetCellValue(gPRow, "priorJobCd",		rv["jobCd"]);
					sheet6.SetCellValue(gPRow, "priorJobNm",		rv["jobNm"]);
				} else if( selectSheet == "sheet7" ) {
					sheet7.SetCellValue(gPRow, "afterJobCd",		rv["jobCd"]);
					sheet7.SetCellValue(gPRow, "afterJobNm",		rv["jobNm"]);
				} else if( selectSheet == "sheet8" ) {
					sheet8.SetCellValue(gPRow, "moveJikgunJobCd",	rv["jobCd"]);
					sheet8.SetCellValue(gPRow, "moveJikgunJobNm",	rv["jobNm"]);
				} else if( selectSheet == "sheet9" ) {
					sheet9.SetCellValue(gPRow, "moveJikryulJobCd",	rv["jobCd"]);
					sheet9.SetCellValue(gPRow, "moveJikryulJobNm",	rv["jobNm"]);
				}
			}else if(pGubun == "licensePopup"){
				sheet41.SetCellValue(gPRow, "licenseCd", rv["code"]);
				sheet41.SetCellValue(gPRow, "licenseNm", rv["codeNm"]);
			}
		}


		//역량요건
		function doAction11(sAction) {
			switch (sAction) {
				case "Search": 	 	sheet11.DoSearch( "${ctx}/GetDataList.do?cmd=getJobMgrEducationList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet11);
					sheet11.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgrEducationList", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet11.DataInsert(0);
					sheet11.SetCellValue(Row, "jobCd", $("#jobCd").val());
					sheet11.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet5.SetCellValue(Row, "edate", "99991231");
					//sheet10.SelectCell(Row, "competencyNm");
					break;
				case "Copy":		sheet11.DataCopy(); break;
				case "Clear":		sheet11.RemoveAll(); break;
				case "Down2Excel":	sheet11.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet11.LoadExcel(params); break;
			}
		}

		//조회 후 에러 메시지
		function sheet11_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet11_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction11("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		var countInt=0;
		var nextKpiCd=0;
		//kpi
		function doAction12(sAction) {
			switch (sAction) {
				case "Search": 	 	sheet12.DoSearch( "${ctx}/GetDataList.do?cmd=getKpiList", $("#srchFrm").serialize() ); break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet12);
					sheet12.DoSave( "${ctx}/SaveData.do?cmd=saveKpiList", $("#srchFrm").serialize() ); break;
				case "Insert":		var row = sheet12.DataInsert(0);
					sheet12.SetCellValue(row, "jobCd", $("#jobCd").val());
					if(countInt==0){
						var aCall = ajaxCall("${ctx}/GetDataMap.do?cmd=getNextKpiCd","",false);
						nextKpiCd = aCall.DATA.nextKpiCd;
						sheet12.SetCellValue(row, "kpiCd", 		nextKpiCd);
						countInt=countInt+1;
					}else{
						nextKpiCd=nextKpiCd*1;
						nextKpiCd=nextKpiCd+1;
						sheet12.SetCellValue(row, "kpiCd", 		nextKpiCd);
					}
					break;
				case "Copy":		sheet12.DataCopy(); break;
				case "Clear":		sheet12.RemoveAll(); break;
				case "Down2Excel":	sheet12.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet12.LoadExcel(params); break;
			}
		}

		//조회 후 에러 메시지
		function sheet12_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet12_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } doAction12("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}



	</script>
</head>
<body class="bodywrap" onload="startView();">

<div class="wrapper popup_scroll">
	<div class="popup_title" >
		<ul>
			<li><tit:txt mid='jobMgr' mdef='직무기술서'/></li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<div id="tabs" class="hide" style="width:100%">
			<ul class="outer tab_bottom">
				<li onclick="clickTabs('1');"><btn:a href="#tabs-1" mid='111330' mdef="기본사항"/></li>
				<!-- <li onclick="clickTabs('2');"><btn:a href="#tabs-2" mid='110779' mdef="수행조직"/></li> -->
				<li onclick="clickTabs('3');"><btn:a href="#tabs-3" mid='111700' mdef="핵심과업"/></li>
				<li onclick="clickTabs('4');"><btn:a href="#tabs-4" mid='110942' mdef="자격요건"/></li>
				<li onclick="clickTabs('5');"><btn:a href="#tabs-5" mid='111071' mdef="역량요건"/></li>
				<li onclick="clickTabs('6');"><btn:a href="#tabs-6" mid='111831' mdef="연관업무"/></li>
				<!-- <li onclick="clickTabs('7');"><a href="#tabs-7"><tit:txt mid='jobMgrTab7' mdef='이동가능직무'/></a></li> -->
				<li onclick="clickTabs('12');"><btn:a href="#tabs-12" mid='111831' mdef="KPI"/></li>
			</ul>
			<div id="tabs-1">
				<table class="table">
					<colgroup>
						<col width="15%" />
						<col width="45%" />
						<col width="10%" />
						<col width="30%" />
					</colgroup>
					<form id="srchFrm" name="srchFrm" >
						<input type="hidden" id="searchJobCd" name="searchJobCd">
						<input type="hidden" id="searchSingleJobCd" name="searchSingleJobCd">
						<input type="hidden" id="jobCd" name="jobCd">
						<input type="hidden" id="ssnSabun" name="ssnSabun" value="${ssnSabun}">
						<input type="hidden" id="ssnEnterCd" name="ssnEnterCd" value="${ssnEnterCd}">
					</form>
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
				<div class="hide"><script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script></div>
			</div>

			<div id="tabs-2" style="display : none;">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='jobMgrTab2' mdef='수행조직'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction2('Search')" 	css="basic authR" mid='search' mdef="조회"/>
								<btn:a href="javascript:doAction2('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction2('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction2('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<a href="javascript:doAction2('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
			</div>

			<div id="tabs-3">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='jobMgrTab3' mdef='핵심과업'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction3('Search')" 	css="basic authR" mid='search' mdef="조회"/>
								<btn:a href="javascript:doAction3('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction3('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction3('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<a href="javascript:doAction3('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet3", "100%", "100%", "${ssnLocaleCd}"); </script>
			</div>

			<div id="tabs-4">

				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">자격증</li>
							<li class="btn">
								<a href="javascript:doAction41('Search')" 	class="basic authR">조회</a>
								<a href="javascript:doAction41('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction41('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction41('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction41('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
					<script type="text/javascript"> createIBSheet("sheet41", "100%", "25%", "${ssnLocaleCd}"); </script>
				</div>


				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">어학</li>
							<li class="btn">
								<a href="javascript:doAction42('Search')" 	class="basic authR">조회</a>
								<a href="javascript:doAction42('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction42('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction42('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction42('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
					<script type="text/javascript"> createIBSheet("sheet42", "100%", "25%", "${ssnLocaleCd}"); </script>
				</div>


				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='jobMgrTab11' mdef='교육/훈련'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction11('Search')" 	css="basic authR" mid='search' mdef="조회"/>
								<btn:a href="javascript:doAction11('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction11('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction11('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<a href="javascript:doAction11('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
					<script type="text/javascript"> createIBSheet("sheet11", "100%", "25%", "${ssnLocaleCd}"); </script>
				</div>

			</div>

			<div id="tabs-5">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='jobMgrTab5' mdef='행동역량요건'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction5('Search')" 	css="basic authR" mid='search' mdef="조회"/>
								<btn:a href="javascript:doAction5('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction5('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction5('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<a href="javascript:doAction5('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet5", "100%", "50%", "${ssnLocaleCd}"); </script>

				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='jobMgrTab10' mdef='기술역량요건'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction10('Search')" 	css="basic authR" mid='search' mdef="조회"/>
								<btn:a href="javascript:doAction10('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction10('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction10('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<a href="javascript:doAction10('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet10", "100%", "50%", "${ssnLocaleCd}"); </script>
			</div>

			<div id="tabs-6">

				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='priorJobNm' mdef='선행직무'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction6('Search')" 	css="basic authR" mid='search' mdef="조회"/>
								<btn:a href="javascript:doAction6('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction6('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction6('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<a href="javascript:doAction6('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet6", "100%", "50%", "${ssnLocaleCd}"); </script>

				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='afterJobNm' mdef='후행직무'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction7('Search')" 	css="basic authR" mid='search' mdef="조회"/>
								<btn:a href="javascript:doAction7('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction7('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction7('Save')" 	css="basic authA" mid='save' mdef="저장"/>
								<a href="javascript:doAction7('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet7", "100%", "50%", "${ssnLocaleCd}"); </script>

			</div>

			<div id="tabs-7" style="display : none;">
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
											<btn:a href="javascript:doAction8('Search')" 	css="basic authR" mid='search' mdef="조회"/>
											<btn:a href="javascript:doAction8('Insert')" css="basic authA" mid='insert' mdef="입력"/>
											<btn:a href="javascript:doAction8('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
											<btn:a href="javascript:doAction8('Save')" 	css="basic authA" mid='save' mdef="저장"/>
											<a href="javascript:doAction8('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
										</li>
									</ul>
								</div>
							</div>
							<script type="text/javascript"> createIBSheet("sheet8", "100%", "100%", "${ssnLocaleCd}"); </script>
						</td>
						<td>&nbsp;</td>
						<td>
							<div class="inner">
								<div class="sheet_title">
									<ul>
										<li id="txt" class="txt"><tit:txt mid='afterJobNm' mdef='후행직무'/></li>
										<li class="btn">
											<btn:a href="javascript:doAction9('Search')" 	css="basic authR" mid='search' mdef="조회"/>
											<btn:a href="javascript:doAction9('Insert')" css="basic authA" mid='insert' mdef="입력"/>
											<btn:a href="javascript:doAction9('Copy')" 	css="basic authA" mid='copy' mdef="복사"/>
											<btn:a href="javascript:doAction9('Save')" 	css="basic authA" mid='save' mdef="저장"/>
											<a href="javascript:doAction9('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
										</li>
									</ul>
								</div>
							</div>
							<script type="text/javascript"> createIBSheet("sheet9", "100%", "100%", "${ssnLocaleCd}"); </script>
						</td>
					</tr>
				</table>
			</div>

			<div id="tabs-12">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='kpiMgrTab2' mdef='KPI'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction12('Search')" 	css="basic authR" mid='search' mdef="조회"/>
								<btn:a href="javascript:doAction12('Insert')" css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction12('Save')" 	css="basic authA" mid='save' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet12", "100%", "100%", "${ssnLocaleCd}"); </script>
			</div>

		</div>

		<div class="popup_button outer">
			<ul>
				<li style="display: flex;justify-content: center;">
					<btn:a href="javascript:setValue();" style="margin-right: 0.1em !;cursor: pointer;text-align: center;overflow: visible;background: #f379b2;color: #fff;display: inline-block;font-size: 12px;padding: 0 20px;height: 28px;line-height: 28px;font-weight: bold;    vertical-align: middle;" css="authA" mid='ok' mdef="확인"/>
					&nbsp;&nbsp;&nbsp;
					<btn:a href="javascript:p.self.close();" style="display: inline-block;font-size: 12px;padding: 0 20px;height: 28px;line-height: 28px;font-weight: 500;font-weight: bold;    margin-right: 0.1em;cursor: pointer;text-align: center;overflow: visible;background: #b8c6cc;    word-break: keep-all;color: #fff" css="authR" mid='close' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>