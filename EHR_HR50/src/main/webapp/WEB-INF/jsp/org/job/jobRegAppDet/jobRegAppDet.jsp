<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>담당직무신청 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
var pageApply  		 = "${etc01}";

var applStatusCd	 = "";
var applYn	         = "";
var pGubun           = "";
var adminRecevYn     = "N"; //수신자 여부
var gPRow = "";

	$(function() {

		parent.iframeOnLoad(300);
		
		$( "#tabs" ).tabs();
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		
		// 직무내용
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='applYmdV6' mdef='신청일자' />",	Type:"Date",		Hidden:1, 	Width:60,	 Align:"Center", SaveName:"applYmd",		Format:"Ymd",	Edit:0 },
	 		{Header:"<sht:txt mid='applStatusNm' mdef='신청상태' />",	Type:"Combo",		Hidden:1, 	Width:60,	 Align:"Center", SaveName:"applStatusCd",	Format:"",		Edit:0 },
			
			{Header:"<sht:txt mid='mainJobCdYn' mdef='대표직무\n여부'/>",	Type:"CheckBox",Hidden:0,	Width:15,	Align:"Center",	ColMerge:0,	SaveName:"titleYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='jobNm1' mdef='직렬'/>",				Type:"Combo",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"jobMType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='workType' mdef='직종'/>",				Type:"Combo",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"jobDType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jobCd' mdef='직무'/>",				Type:"Combo",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='taskCdV1' mdef='과업'/>",				Type:"Combo",	Hidden:0,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"taskCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"searchApplSeq"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"searchApplSabun"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"orgCd"}
// 			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applYn"}
			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");
		
		// 소지자격
	 	initdata = {};
	 	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

	 	initdata.Cols = [
	 		{Header:"<sht:txt mid='licenseNm' mdef='자격증명'/>", Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"licenseCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	 		{Header:"<sht:txt mid='grade' mdef='등급'/>", 	Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"licenseGrade",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	 		{Header:"<sht:txt mid='officeCd_v' mdef='발급기관'/>", Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"officeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
			
	 	]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");
		
	 	// 필요자격
	 	initdata = {};
	 	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

	 	initdata.Cols = [
	 		{Header:"<sht:txt mid='licenseNm' mdef='자격증명'/>", Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"licenseCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	 		{Header:"<sht:txt mid='grade' mdef='등급'/>", 	Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"licenseGrade",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	 		{Header:"<sht:txt mid='officeCd_v' mdef='발급기관'/>", Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"officeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	 		{Header:"<sht:txt mid='relatedTask' mdef='관련과업'/>", Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"taskNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
			
	 	]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");
		
	 	// 사내경력
	 	initdata = {};
	 	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

	 	initdata.Cols = [
	 		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
	 		{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",		Type:"Text",      	Hidden:0,  Width:80,   Align:"Left",  	ColMerge:0,   SaveName:"tfOrgNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",		Type:"Date",      	Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"sdate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	 		{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",		Type:"Date",      	Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"edate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	 		{Header:"<sht:txt mid='jobNmV1' mdef='담당업무'/>",		Type:"Text",      	Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"jobNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"<sht:txt mid='note' mdef='비고' />",			Type:"Text",      	Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"note",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 }
	 	]; IBS_InitSheet(sheet4, initdata);sheet4.SetEditable("${editable}");
		
	 	// 사외경력
	 	initdata = {};
	 	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

	 	initdata.Cols = [
	 		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
	 		{Header:"<sht:txt mid='enterCd' mdef='회사명'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Left",  ColMerge:0,   SaveName:"cmpNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",		Type:"Date",      	Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"sdate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	 		{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",		Type:"Date",      	Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"edate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	 		{Header:"<sht:txt mid='jobNmV1' mdef='담당업무'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jobNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"<sht:txt mid='note' mdef='비고' />",			Type:"Text",      	Hidden:0,  Width:200,   Align:"Center",  ColMerge:0,   SaveName:"note",			KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 }
			
	 	]; IBS_InitSheet(sheet5, initdata);sheet5.SetEditable("${editable}");
		
	 	// 이수교육
	 	initdata = {};
	 	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

	 	initdata.Cols = [
	 		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
	 		{Header:"<sht:txt mid='eduCourseNm' mdef='과정명'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Left",  ColMerge:0,   SaveName:"eduCourseNm",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"<sht:txt mid='eduOrgNm' mdef='교육기관'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"eduOrgNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"<sht:txt mid='eduBranchCd' mdef='교육구분'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"eduBranchNm",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",		Type:"Date",      	Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"eduSYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	 		{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",		Type:"Date",      	Hidden:0,  Width:90,    Align:"Center",  ColMerge:0,   SaveName:"eduEYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
	 		
	 	]; IBS_InitSheet(sheet6, initdata);sheet6.SetEditable("${editable}");
		
	 	// 필요교육
	 	initdata = {};
	 	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

	 	initdata.Cols = [
	 		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
	 		{Header:"<sht:txt mid='eduCourseNm' mdef='과정명'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Left",  ColMerge:0,   SaveName:"eduCourseNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },		// ?
	 		{Header:"<sht:txt mid='eduOrgNm' mdef='교육기관'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"eduOrgNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },		// ?
	 		{Header:"<sht:txt mid='eduBranchCd' mdef='교육구분'/>",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"eduBranchNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }		// ?
			
	 	]; IBS_InitSheet(sheet7, initdata);sheet7.SetEditable("${editable}");
		
	 	// 요구지식
	 	initdata = {};
	 	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0, FrozenColRight:0};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

	 	initdata.Cols = [
	 		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			
			{Header:"<sht:txt mid='relatedJobV1' mdef='관련직무|관련직무'/>",		Type:"Combo",		Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='knowledge_v' mdef='필요지식|필요지식'/>", 		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"knowledge"	,KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='docInfo_v' mdef='문서화된 정보|문서화된 정보'/>", Type:"Text",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"docInfo"		,KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='storageType_v' mdef='저장매체|저장매체'/>", 	Type:"Combo",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"storageType"	,KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"<sht:txt mid='accessAuthAll_v' mdef='접근권한|전체'/>",			Type:"CheckBox",Hidden:1, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthAll",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='accessAuthComp_v' mdef='접근권한|전사'/>",			Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthComp",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='accessAuthHq_v' mdef='접근권한|본부'/>",			Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthHq",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='accessAuthTeam_v' mdef='접근권한|팀'/>",				Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthTeam",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='accessAuthRelate_v' mdef='접근권한|직무유관'/>",		Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthRelate",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='accessAuthCharge_v' mdef='접근권한|직무담당'/>",		Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthCharge",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			
			{Header:"<sht:txt mid='infoPlan_v' mdef='최신정보\n확보계획|최신정보\n확보계획'/>",Type:"Text",		Hidden:0,	Width:15,	Align:"Center",	ColMerge:0,	SaveName:"infoPlan",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='fileYnV3' mdef='첨부파일|첨부파일'/>",					Type:"Html",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		Edit:0 },
			
			{Header:"Hidden",	Hidden:1, SaveName:"fileSeq" },
			{Header:"Hidden",	Hidden:1, SaveName:"seq" }
			
	 	]; IBS_InitSheet(sheet8, initdata);sheet8.SetEditable("${editable}");
		
		// 콥보 리스트
		/* ########################################################################################################################################## */
		var orgCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"+"&searchApplSabun="+searchApplSabun, "queryId=getJobOrgCdList", false).codeList
	            , "code,codeNm"
	            , " ");
		
// 		var orgCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobOrgList", false).codeList
// 	            , "code,codeNm"
// 	            , " ");
	
		var jobMTypeParam = "&searchJobType=10010&codeType=1";
		var jobMType = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobMTypeParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var jobDTypeParam = "&searchJobType=10020&codeType=1";
		var jobDType = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobDTypeParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var jobCdParam = "&searchJobType=10030&codeType=1";
		var jobCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var taskCdParam = "&searchJobType=10040&codeType=1";
		var taskCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+taskCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		$("#orgCd").html(orgCdList[2]);
		sheet1.SetColProperty("jobMType", 		{ComboText:"|"+jobMType[0], ComboCode:"|"+jobMType[1]} );	//직렬코드
		sheet1.SetColProperty("jobDType", 		{ComboText:"|"+jobDType[0], ComboCode:"|"+jobDType[1]} );	//직종코드
		sheet1.SetColProperty("jobCd", 			{ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );			//직무코드
		sheet1.SetColProperty("taskCd", 		{ComboText:"|"+taskCd[0], ComboCode:"|"+taskCd[1]} );		//과업코드
		
		var grpCds = "H20160,H20161,H20175,H90014";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
		sheet2.SetColProperty("licenseCd",  	{ComboText:"|"+codeLists["H20160"][0], ComboCode:"|"+codeLists["H20160"][1]} ); //자격증(H20160) 
		sheet2.SetColProperty("licenseGrade",  	{ComboText:"|"+codeLists["H20161"][0], ComboCode:"|"+codeLists["H20161"][1]} ); //자격등급(H20161) 
		sheet2.SetColProperty("officeCd",  		{ComboText:"|"+codeLists["H20175"][0], ComboCode:"|"+codeLists["H20175"][1]} ); //발행기관(H20175)
		
		// 필요자격
		sheet3.SetColProperty("licenseCd",  	{ComboText:"|"+codeLists["H20160"][0], ComboCode:"|"+codeLists["H20160"][1]} ); //자격증(H20160) 
// 		sheet3.SetColProperty("licenseGrade",  	{ComboText:"|"+codeLists["H20161"][0], ComboCode:"|"+codeLists["H20161"][1]} ); //자격등급(H20161)
// 		sheet3.SetColProperty("officeCd",  		{ComboText:"|"+codeLists["H20175"][0], ComboCode:"|"+codeLists["H20175"][1]} ); //발행기관(H20175)
		
		// 요구지식
		sheet8.SetColProperty("storageType",  {ComboText:"|"+codeLists["H90014"][0], ComboCode:"|"+codeLists["H90014"][1]} );  //저장매체(H90014)
// 		sheet8.SetColProperty("orgCd", 		  {ComboText:"|"+orgCd[0], ComboCode:"|"+orgCd[1]} );					   		   //부서
		
		/* ########################################################################################################################################## */
		
		$(window).smartresize(sheetResize); sheetInit();
		
		$("#searchApplSeq").val(searchApplSeq);
		$("#searchApplSabun").val(searchApplSabun);
		$("#applYn").val(parent.$("#applYn").val());
		$("#searchApplYmd").val(searchApplYmd);
		$("#authPg").val(authPg);
		$("#pageApply").val(pageApply);
		
	 	applStatusCd = parent.$("#applStatusCd").val();
	 	
	 	applYn = parent.$("#applYn").val(); // 현 결재자와 세션사번이 같은지 여부
	 	
	 	if(applStatusCd == "") {
	 		applStatusCd = "11";
	 	}
		
	 	if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //담당자거나 수신결재자이면
			
	 		if( applStatusCd == "31") { //수신처리중일 때만 지급정보 수정 가능
	 			// 입력버튼 비활성화
	 		}

	 		adminRecevYn = "Y";
	 		parent.iframeOnLoad(300);
			
	 	}
	 	
	 	// 신청, 임시저장
	 	if(authPg != "A") {
	 		// 입력 비활성화
 			$("#btnInsert").attr("disabled", true);
	 	}else{
	 		$("#searchApplyYmd").datepicker2();
	 	}
		
// 	 	R -> 상세페이지
// 	 	A -> 신청,임시저장
// 		apply -> 1: 신청 2:나머지
	 	
	 	doAction1("Search");
		doAction2("Search");
			
		// 부서 이벤트
 		$("#orgCd").change(function() {
			doAction2("Search");
 		});

	});
	
	function startView() {
		//바디 로딩 완료후 화면 보여줌(로딩과정에서 화면 이상하게 보이는 현상 해결 by JSG)
		$("#tabs").removeClass("hide");
	}
	
	function clickTabs(sAction) {
		// setTimeout tab 클릭시 틀어짐 방지
		setTimeout(
			function(){
				if (sAction == "1") {
					// sheet1 - sheet8
					sheet1.SetSheetHeight("180px");
					sheet2.SetSheetHeight("150px");
					sheet3.SetSheetHeight("150px");
				} else if (sAction == "2") {
					sheet4.SetSheetHeight("120px");
					sheet5.SetSheetHeight("120px");
					sheet6.SetSheetHeight("120px");
					sheet7.SetSheetHeight("140px");
				} else if (sAction == "3") {
					sheet8.SetSheetHeight("90%");
				}

				//hide클래스를 없앤 후 시트 리사이즈가 먹지 않는 문제 해결
				$(window).smartresize(sheetResize); sheetInit();
			}, 200);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			
			// 입력 폼 값 셋팅
			var data = ajaxCall( "${ctx}/JobRegApp.do?cmd=getJobRegAppDetMap", $("#searchForm").serialize(),false);
			
			if ( data != null && data.DATA != null ){
				$("#jikchakNm").html(data.DATA.jikchakNm);			// 직책
				$("#worktypeNm").html(data.DATA.worktypeNm);		// 직군
				$("#finalSchNm").html(data.DATA.finalSchNm);		// 최종학교명
				$("#finalAcamajNm").html(data.DATA.finalAcamajNm);	// 최종전공명
				$("#jobNm").html(data.DATA.jobNm);					// 대표직무
				$("#orgCd").val(data.DATA.orgCd);					// 부서
				$("#searchApplyYmd").val(formatDate(data.DATA.applyYmd,"-"));		// 적용일자
				$("#orgCd").change();
				
				var jobCdParam2 = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"+"&orgCd="+data.DATA.orgCd, "queryId=getJobCdList2", false).codeList
			            , "code,codeNm"
			            , " ");
				
				sheet8.SetColProperty("jobCd", 		  {ComboText:"|"+jobCdParam2[0], ComboCode:"|"+jobCdParam2[1]} );					   //직무코드
			}
			
			var param = "sabun="+$("#searchApplSabun").val();
			
			// 소지자격 조회
			sheet2.DoSearch( "${ctx}/PsnalLicense.do?cmd=getPsnalLicenseList", param );
			
			// 사내경력
			sheet4.DoSearch( "${ctx}/PsnalExperience.do?cmd=getPsnalExperienceList", param );
			
			// 사외경력
			sheet5.DoSearch( "${ctx}/PsnalCareer.do?cmd=getPsnalCareerList", param );
			
			break;			
		case "Insert":
			var row = sheet1.DataInsert(0);
			
			sheet1.SetCellEditable(row,"jobDType",false);
			sheet1.SetCellEditable(row,"jobCd",false);
			sheet1.SetCellEditable(row,"taskCd",false);
			
			break;
		}
	}
	
	//Sheet1 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			
			// 직무 리스트
			var sXml = sheet1.GetSearchData("${ctx}/JobRegApp.do?cmd=getJobDutyList", $("#searchForm").serialize()+"&orgCd="+$("#orgCd").val() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml);
			
			break;			
		case "Insert":
			var row = sheet1.DataInsert(0);
			
// 			sheet1.SetCellValue(row,"searchApplSeq",$('#searchApplSeq').val());
			sheet1.SetCellValue(row,"searchApplSabun",$('#searchApplSabun').val());
// 			sheet1.SetCellValue(row,"orgCd",$('#orgCd').val());
			
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			fnComboCall(1);
			fnComboCall(2);
			
			var rowCnt = sheet1.RowCount();
			
			if(authPg == "A"){

				for (var i=1; i<=rowCnt; i++) {
					
					if(pageApply == "1"){
						sheet1.SetCellValue(i,"sStatus","I");
						
// 						sheet1.SetCellValue(i,"searchApplSeq",$('#searchApplSeq').val());
// 						sheet1.SetCellValue(i,"searchApplSabun",$('#searchApplSabun').val());
// 						sheet1.SetCellValue(i,"orgCd",$('#orgCd').val());
						
					}else{
						sheet1.SetCellValue(i,"sStatus","R");
					}
					
				}				
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
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 직무 이벤트
	function sheet1_OnChange(Row, Col, Value){
		try {
			
			var sSaveName = sheet1.ColSaveName(Col);
			
			if(sSaveName == "jobMType"){
				
				var jobMTypeParam = "&searchJobType=10020&codeType=1&searchJobCd="+Value;
				var jobMType = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobMTypeParam, false).codeList
			            , "code,codeNm"
			            , " ");
				
				sheet1.SetCellEditable(Row,"jobDType",true);
				sheet1.SetCellValue(Row,"jobDType","");
				sheet1.CellComboItem(Row,"jobDType",{ComboText:" ", ComboCode:" "});	// 콤보 초기화
				
				if(jobMType[0]){
					sheet1.CellComboItem(Row,"jobDType",{ComboText:"|"+jobMType[0], ComboCode:"|"+jobMType[1]});
				}else{
					sheet1.CellComboItem(Row,"jobDType",{ComboText:" ", ComboCode:" "});	// 콤보 초기화
				}
				
				if(!Value){
					sheet1.CellComboItem(Row,"jobDType",{ComboText:" ", ComboCode:" "});	// 콤보 초기화
					sheet1.CellComboItem(Row,"jobCd",{ComboText:" ", ComboCode:" "});
					sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
					
					sheet1.SetCellEditable(Row,"jobDType",false);
					sheet1.SetCellEditable(Row,"jobCd",false);
					sheet1.SetCellEditable(Row,"taskCd",false);
				}
				
				sheet1.SetCellValue(Row,"searchApplSeq",$('#searchApplSeq').val());
				sheet1.SetCellValue(Row,"searchApplSabun",$('#searchApplSabun').val());
				sheet1.SetCellValue(Row,"orgCd",$('#orgCd').val());
				
				sheet1.CellComboItem(Row,"jobCd",{ComboText:" ", ComboCode:" "});
				sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
				
				sheet1.SetCellEditable(Row,"jobCd",false);
				sheet1.SetCellEditable(Row,"taskCd",false);
			}
			
			if(sSaveName == "jobDType"){
				
				var jobDTypeParam = "&searchJobType=10030&codeType=1&searchJobCd="+Value;
				var jobDType = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobDTypeParam, false).codeList
			            , "code,codeNm"
			            , " ");
				
				sheet1.SetCellEditable(Row,"jobCd",true);
				sheet1.SetCellValue(Row,"jobCd","");
				
				if(jobDType[0]){
					sheet1.CellComboItem(Row,"jobCd",{ComboText:"|"+jobDType[0], ComboCode:"|"+jobDType[1]});
				}else{
					sheet1.CellComboItem(Row,"jobCd",{ComboText:" ", ComboCode:" "});
				}
				
				if(!Value){
					sheet1.CellComboItem(Row,"jobCd",{ComboText:" ", ComboCode:" "});
					sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
					
					sheet1.SetCellEditable(Row,"jobCd",false);
					sheet1.SetCellEditable(Row,"taskCd",false);
				}
				
				sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
				
				sheet1.SetCellEditable(Row,"taskCd",false);
				
			}
		
			if(sSaveName == "jobCd"){
				
				var taskCdParam = "&searchJobType=10040&codeType=1&searchJobCd="+Value;
				var taskCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+taskCdParam, false).codeList
				            , "code,codeNm"
				            , " ");

				sheet1.SetCellEditable(Row,"taskCd",true);
				sheet1.SetCellValue(Row,"taskCd","");
				
				if(taskCd[0]){
					sheet1.CellComboItem(Row,"taskCd",{ComboText:"|"+taskCd[0], ComboCode:"|"+taskCd[1]});
				}else{
					sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
				}
				
				if(!Value){
					sheet1.CellComboItem(Row,"taskCd",{ComboText:" ", ComboCode:" "});
					sheet1.SetCellEditable(Row,"taskCd",false);
				}

				fnComboCall(1);
				
			}
			
			if(sSaveName == "taskCd"){
				fnComboCall(2);
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	function fnComboCall(type){
		
		// 직무 중복값 제거
		var rowCnt = sheet1.RowCount();
        var chk = [];
        var tChk = [];
		
        for (var i=1; i<=rowCnt; i++) {
            if (chk.length == 0) {
                chk.push(sheet1.GetCellValue(i, "jobCd"));
                tChk.push(sheet1.GetCellValue(i, "taskCd"));
            } else {
                var flg = true;
                for (var j = 0; j < chk.length; j++) {
                    if (chk[j] == sheet1.GetCellValue(i, "jobCd")) {
                        flg = false;
                        break;
                    }
                }
                if (flg) {
                    chk.push(sheet1.GetCellValue(i, "jobCd"));
                    tChk.push(sheet1.GetCellValue(i, "taskCd"));
                }
            }
        }

        if(type == "1"){
        	// 조회 조건
    		var param = "jobCd="+chk+"&orgCd="+$("#orgCd").val()+"&searchApplSabun="+$("#searchApplSabun").val()+"&searchApplYmd="+$("#searchApplYmd").val()+"&pageType="+"1";
    		
    		if(chk != ""){
    			// 이수교육	
    			sheet6.DoSearch( "${ctx}/JobRegApp.do?cmd=getTrueEduList", param );

    			// 필요교육
    			sheet7.DoSearch( "${ctx}/JobRegApp.do?cmd=getNeedEduList", param );

    			//요구지식
    			sheet8.DoSearch( "${ctx}/OrgKnowledgeReg.do?cmd=getOrgKnowledgeRegList", param);
    		}else{
    			sheet6.RemoveAll();
    			sheet7.RemoveAll();
    			sheet8.RemoveAll();
    		}
        }else{
        	// 조회 조건
    		var param = "jobCd="+tChk+"&orgCd="+$("#orgCd").val()+"&searchApplSabun="+$("#searchApplSabun").val()+"&searchApplYmd="+$("#searchApplYmd").val()+"&pageType="+"1";
        	
			if(tChk != ""){
    			// 필요자격
    			sheet3.DoSearch( "${ctx}/JobQualificationPopup.do?cmd=getJobQualificationPopupList", param);

    		}else{
    			sheet3.RemoveAll();
    		}
        }
	}

//--------------------------------------------------------------------------------
//  저장 시 필수 입력 및 조건 체크
//--------------------------------------------------------------------------------
function checkList(status) {
	var ch = true;
	
	// 화면의 개별 입력 부분 필수값 체크
	$(".required").each(function(index){
		if($(this).val() == null || $(this).val() == ""){
			alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
			$(this).focus();
			ch =  false;
			return false;
		}

		return ch;
	});
	
	return ch;
}

// 같은직무 체크 하기
function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try {
		if( Row < sheet1.HeaderRows() ) return;
	    
		// 신청, 임시저장
// 		if(authPg == "A") {
// 			var jobCdVal = "";
// 			var titleYnVal = "";
			
// 		    if(sheet1.ColSaveName(Col) == "titleYn" ){
// 		    	titleYnVal = sheet1.GetCellValue(Row,"titleYn");
// 				jobCdVal = sheet1.GetCellValue(Row,"jobCd");
				
// 				var rowCnt = sheet1.RowCount();
// 		        var chk = [];
		        
// 		        for (var i=1; i<=rowCnt; i++) {
// 		            if (chk.length == 0) {
// 		            	if(jobCdVal == sheet1.GetCellValue(i, "jobCd")){
// 		                	if(titleYnVal == "Y"){
// 		                		sheet1.SetCellValue(i,"titleYn","Y");
// 		                	}else{
// 		                		sheet1.SetCellValue(i,"titleYn","N");
// 		                	}
// 		                }
// 		            }
// 		        }
// 			}
// 		}
	    
	} catch (ex) {
		alert("OnClick Event Error : " + ex);
	}
}

// 대표직무 여부 체크
function chkList(){
	var rowCnt = sheet1.RowCount();
	var chk = [];
	var dChk = [];
	var ynFlag = true;
	var dFlag = true;
	
    for (var i=1; i<=rowCnt; i++) {
    	if(sheet1.GetCellValue(i, "sStatus") != "D"){
    		dFlag = false;
    		if (chk.length == 0) {
        		if(sheet1.GetCellValue(i, "titleYn") != "Y"){
               		ynFlag = false;
               	}else{
               		ynFlag = true;
               		chk.push(sheet1.GetCellValue(i, "jobCd"));
               	}
        	}else {
            	if(sheet1.GetCellValue(i, "titleYn") == "Y"){
                   	chk.push(sheet1.GetCellValue(i, "jobCd"));
            	}
            }
    	}else if(sheet1.GetCellValue(i, "sStatus") == "D"){
    		dChk.push(i);
    		ynFlag = true;
    	}
    }
    
    if(rowCnt == 0){
		alert("<msg:txt mid='jobRegAppDetMsg1' mdef='대표직무가 1건 이상 있어야 합니다.'/>");
    	return;
    }
    
    if(dChk.length == rowCnt){
		alert("<msg:txt mid='jobRegAppDetMsg2' mdef='전부 삭제 할 수 없습니다.'/>");
    	return;
    }
    
    if(dFlag == false){
    	if(ynFlag == false){
			alert("<msg:txt mid='jobRegAppDetMsg3' mdef='대표직무 여부를 체크 해 주세요'/>")
        	return;
        }
    	
        if(chk.length != 1){
			alert("<msg:txt mid='jobRegAppDetMsg4' mdef='대표직무 여부는 1개만 가능합니다.'/>")
        	return;
        }
    }
    
    ynFlag =true;
    dFlag = true;
    
    return ynFlag;
    
}
	
//--------------------------------------------------------------------------------
//  임시저장 및 신청 시 호출
//--------------------------------------------------------------------------------
function setValue(status) {
	//전송 전 잠근 계좌선택 풀기
	var returnValue = false;
	try {
		
		//관리자 수신담당자 경우 지급정보 저장
		if( adminRecevYn == "Y" ){

			if( applStatusCd != "31") { //수신처리중이 아니면 저장 처리 하지 않음
				return true;
			}
			
		}else{
			
			if ( authPg == "R" )  {
				return true;
			}
			
			/*
				저장할때    
				신청시 "적용일자"가 이전에 신청한 내역보다 이전이면 신청 안되도록 막아야함  (THRM171의  MAX(APPLY_YMD)로 체크)
			    벨리데이션 체크 해야 함
			*/
			
			// 부서 체크
	        if ( !checkList() ) {
	        	return false;
	        }
	        
	     	// 체크박스에 대한 벨리데이션 체크
	        if ( !chkList() ) {
	        	return false;
	        }
			
			// sheet1 직무, 과업 벨리데이션 체크
	        var rowCnt = sheet1.RowCount();
	    	var ynFlag = true;
	    	
	        for (var i=1; i<=rowCnt; i++) {
	        	if(sheet1.GetCellValue(i, "sStatus") != "D"){
	        		if(sheet1.GetCellValue(i, "jobCd") == ""){
						alert("<msg:txt mid='jobRegAppDetMsg5' mdef='직무를 선택 해 주세요.'/>")
	        			return;
	        		}
	        		
	        		if(sheet1.GetCellValue(i, "taskCd") == ""){
						alert("<msg:txt mid='jobRegAppDetMsg6' mdef='과업을 선택 해 주세요.'/>")
	        			return;
	        		}
	        	}
	        }
	        
	        if ( !fnApplYmdYn() ) {
	        	return false;
	        }
	        
	        if(!dupChk(sheet1,"jobCd|taskCd", true, true)){return;}
	        
	      	//폼에 시트 변경내용 저장
        	IBS_SaveName(document.searchForm,sheet1);
        	var saveStr = sheet1.GetSaveString(0);
			if(saveStr=="KeyFieldError"){
				return false;
			}
			var data = eval("("+sheet1.GetSaveData("${ctx}/JobRegApp.do?cmd=saveJobRegAppDet", saveStr+"&"+$("#searchForm").serialize()+"&orgCd="+$("#orgCd").val())+")");
			
            if(data.Result.Code < 1) {
                alert(data.Result.Message);
				returnValue = false;
            }else{
				returnValue = true;
            }
			
		}    

	} catch (ex){
		alert("Error!" + ex);
		returnValue = false;
	}

	return returnValue;
}

// 적용일자 체크
function fnApplYmdYn(){
	var yn = true;
	var data = ajaxCall( "${ctx}/JobRegApp.do?cmd=getApplYmdYn", $("#searchForm").serialize(),false);
	
	if(data.DATA.length != 0){
		if(data.DATA[0].applyYn == "N"){
			alert("<msg:txt mid='jobRegAppDetMsg7' mdef='적용일자가 신청한 내역보다 이전이면 신청 할 수 없습니다.'/>")
			yn = false;
			return;
		}
	}
	
	return yn;
	
}

//셀 클릭시 발생
function sheet8_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try {
		if( Row < sheet8.HeaderRows() ) return;
	    
	    if(sheet8.ColSaveName(Col) == "btnFile" ){
			var param = [];
			param["fileSeq"] = sheet8.GetCellValue(Row,"fileSeq");
			if(sheet8.GetCellValue(Row,"btnFile") != ""){

				gPRow = Row;
				pGubun = "viewFilePopup";
				
				openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg=A&uploadType=benSeal", param, "740","720");
			}

		}
	    
	} catch (ex) {
		alert("OnClick Event Error : " + ex);
	}
}

//팝업 콜백
function getReturnValue(returnValue) {

	var rv = $.parseJSON('{'+ returnValue+'}');

	if (pGubun == "viewFilePopup"){

		if(rv["fileCheck"] == "exist"){
			sheet8.SetCellValue(gPRow, "btnFile", '<a class="basic">다운로드</a>');
			sheet8.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
		}else{
			sheet8.SetCellValue(gPRow, "btnFile", '');
			sheet8.SetCellValue(gPRow, "fileSeq", "");
		}
	}
}

// sheet2 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {try {if (Msg != "") {alert(Msg);}sheetResize();} catch (ex) {alert("OnSearchEnd Event Error : " + ex);}}
//sheet3 조회 후 에러 메시지
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {try {if (Msg != "") {alert(Msg);}sheetResize();} catch (ex) {alert("OnSearchEnd Event Error : " + ex);}}
//sheet4 조회 후 에러 메시지
function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {try {if (Msg != "") {alert(Msg);}sheetResize();} catch (ex) {alert("OnSearchEnd Event Error : " + ex);}}
//sheet5 조회 후 에러 메시지
function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {try {if (Msg != "") {alert(Msg);}sheetResize();} catch (ex) {alert("OnSearchEnd Event Error : " + ex);}}
//sheet6 조회 후 에러 메시지
function sheet6_OnSearchEnd(Code, Msg, StCode, StMsg) {try {if (Msg != "") {alert(Msg);}sheetResize();} catch (ex) {alert("OnSearchEnd Event Error : " + ex);}}
//sheet7 조회 후 에러 메시지
function sheet7_OnSearchEnd(Code, Msg, StCode, StMsg) {try {if (Msg != "") {alert(Msg);}sheetResize();} catch (ex) {alert("OnSearchEnd Event Error : " + ex);}}
//sheet8 조회 후 에러 메시지
function sheet8_OnSearchEnd(Code, Msg, StCode, StMsg) {try {if (Msg != "") {alert(Msg);}sheetResize();} catch (ex) {alert("OnSearchEnd Event Error : " + ex);}}
	
</script>
</head>
<body class="bodywrap" onload="startView();">

<div class="wrapper">
	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"	name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"	name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"		name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"		name="searchApplYmd"	 value=""/>
	<input type="hidden" id="applYn"			name="applYn"	 		 value=""/>
	<input type="hidden" id="authPg"			name="authPg"	 		 value=""/>
	<input type="hidden" id="pageApply"			name="pageApply"	 	 value=""/>
	<input type="hidden" id="applyYn"			name="applyYn"	 		 value=""/>
		<div id="tabs" class="hide" style="width:100%; height:800px;">
			<ul class="outer tab_bottom">
				<li onclick="clickTabs('1');"><btn:a href="#tabs-1" mid='111330' mdef="기본사항"/></li>
				<li onclick="clickTabs('2');"><btn:a href="#tabs-2" mid='110779' mdef="경력/교육"/></li>
				<li onclick="clickTabs('3');"><btn:a href="#tabs-3" mid='111700' mdef="요구지식"/></li>
			</ul>
			<div id="tabs-1" style="display: none">
				<div class="inner">
				<table class="table">
					<colgroup>
						<col width="10%" />
						<col width="15%" />
						<col width="10%" />
						<col width="15%" />
						<col width="10%" />
						<col width="15%" />
						<col width="10%" />
						<col width="15%" />
					</colgroup>
					<tr>
						<th><tit:txt mid='113441' mdef='부서'/></th>
						<td>
							<select id="orgCd" name="orgCd" class="${selectCss} ${required} " ${disabled}></select>
						</td>
						<th><tit:txt mid='applyDate' mdef='적용일자'/></th>
						<td>
							<input type="text" id="searchApplyYmd" name="searchApplyYmd" class="${dateCss} w80 ${required} " ${disabled} maxlength="10"/>
						</td>
						<th><tit:txt mid='103785' mdef='직책'/></th>
						<td>
							<div id="jikchakNm"></div>
						</td>
						<th><tit:txt mid='104089' mdef='직군'/></th>
						<td style="display: none;">
							<div id="worktypeNm"></div>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='mainJob' mdef='대표직무'/></th>
						<td>
							<div id="jobNm"></div>
						</td>
						<th><tit:txt mid='112880' mdef='최종학교명'/></th>
						<td>
							<div id="finalSchNm"></div>
						</td>
						<th><tit:txt mid='112880' mdef='최종전공명'/></th>
						<td colspan="3">
							<div id="finalAcamajNm"></div>
						</td>
					</tr>
				</table>
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='jobDesc' mdef='직무내용'/></li>
						<li class="btn">
							<btn:a id="btnInsert" href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력" style="margin-right:5px;"/>
						</li>
					</ul>
				</div>
				<div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "180px", "${ssnLocaleCd}"); </script>
				</div>
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='HoldingQual' mdef='소지자격'/></li>
					</ul>
				</div>
				<div>
					<script type="text/javascript"> createIBSheet("sheet2", "100%", "150px", "${ssnLocaleCd}"); </script>
				</div>
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='schLic' mdef='필요자격'/></li>
					</ul>
				</div>
				<div>
					<script type="text/javascript"> createIBSheet("sheet3", "100%", "150px", "${ssnLocaleCd}"); </script>
				</div>
				</div>
			</div>

			<div id="tabs-2" style="display: none">
				<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='career1' mdef='사내경력'/></li>
					</ul>
				</div>
				<div>
					<script type="text/javascript"> createIBSheet("sheet4", "100%", "120px", "${ssnLocaleCd}"); </script>
				</div>
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='career1' mdef='사외경력'/></li>
					</ul>
				</div>
				<div>
					<script type="text/javascript"> createIBSheet("sheet5", "100%", "120px", "${ssnLocaleCd}"); </script>
				</div>
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='compEdu' mdef='이수교육'/></li>
					</ul>
				</div>
				<div>
					<script type="text/javascript"> createIBSheet("sheet6", "100%", "120px", "${ssnLocaleCd}"); </script>
				</div>
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='requiredEdu' mdef='필요교육'/></li>
					</ul>
				</div>
				<div>
					<script type="text/javascript"> createIBSheet("sheet7", "100%", "140px", "${ssnLocaleCd}"); </script>
				</div>
				</div>
			</div>

			<div id="tabs-3" style="display: none">
				<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt">요구지식</li>
					</ul>
				</div>
				<div>
					<script type="text/javascript"> createIBSheet("sheet8", "100%", "90%", "${ssnLocaleCd}"); </script>
				</div>
				</div>
			</div>

		</div>
	</form>
</div>

</body>
</html>
