<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<title><tit:txt mid='empPapResultPop1' mdef='평가결과'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p 	= eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	var authPg = "${authPg}";
	var saveYn = "N";

	$(function(){
		//리스트 화면에서 넘어온값 셋팅(상세보기)
		var arg = p.popDialogArgumentAll();
		$("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
		$("#searchAppOrgCd").val(arg["searchOrgCd"]); //평가소속
		$("#searchSabun").val(arg["searchSabun"]); //피평가자사번
		$("#span_searchOrgNm").html(arg["searchOrgNm"]); //평가소속
		$("#span_searchName").html(arg["searchName"]); //피평가자이름
		$("#span_searchJikweeNm").html(arg["searchJikweeNm"]); //직위
		$("#span_searchSabun").html(arg["searchSabun"]); //피평가자사번

		// 닫기 버튼
		$(".close").click(function() 	{
			p.self.close();
		});

		// sheet1 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"<sht:txt mid='fileGubn' mdef='업무명'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"workTitle", 	KeyField:0},
			{Header:"<sht:txt mid='2023082801358' mdef='핵심과제'/>",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"keyTaskYn",	KeyField:0},
			{Header:"<sht:txt mid='2023082801357' mdef='성과관리자'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"workManageName"},
			{Header:"<sht:txt mid='jobNm_V5402' mdef='직무'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobNm"},
			{Header:"<sht:txt mid='2023082501238' mdef='종합수준'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"totalLevel"},
			{Header:"<sht:txt mid='2023082801356' mdef='완료일시'/>",	Type:"Text",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"termEdate"},

			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetUnicodeByte(3);

		// sheet2 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,SizeMode:2};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"<sht:txt mid='fileGubn' mdef='업무명'/>",				Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"workTitle", 		KeyField:0},
			{Header:"<sht:txt mid='notiTypeCd' mdef='유형'/>",				Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"quaCd",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:3 },
			{Header:"<sht:txt mid='2023082501084' mdef='리뷰결과'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reviewCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:3 },
			{Header:"<sht:txt mid='2023082501102' mdef='코멘트'/>",			Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"reviewComment",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 },

			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"}
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetUnicodeByte(3);

		// sheet3 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='appIndexGubunCd_V1134' mdef='구분|구분'/>",			  		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appPerSetCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='2023082400816' mdef='피평가자|주요활동 및 성과'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appPerNote1",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='2023082400815' mdef='피평가자|미흡한과제'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appPerNote2",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082400814' mdef='평가자|강점/개발필요점'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appPerFeedNote1",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082400813' mdef='평가자|주요내용/지원\n필요사항'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appPerFeedNote2",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082801353' mdef='평가자|종합의견'/>",			  		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appPerFeedCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },

			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"}
		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable(false);sheet3.SetVisible(true);sheet3.SetUnicodeByte(3);
		
		// sheet4 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"종합의견",	Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"app3rdComment",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"최종등급",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appFinalClassCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 },

			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"}
		]; IBS_InitSheet(sheet4, initdata);sheet4.SetEditable(false);sheet4.SetVisible(true);sheet4.SetUnicodeByte(3);

		$(window).smartresize(sheetResize); sheetInit();

		doAction("Search");
	});
	
	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			doAction1("Search");
			doAction2("Search");
			doAction3("Search");
			doAction4("Search");
		}
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OkrAppProtestLst.do?cmd=getOkrWorkList", $("#srchFrm").serialize() );
			break;
		}
	}

	// Sheet1 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction2("Search");
			doAction3("Search");
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch("${ctx}/OkrAppProtestLst.do?cmd=getOkrWorkPerList", $("#srchFrm").serialize());
			break;
		}
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

	//sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			sheet3.DoSearch("${ctx}/OkrAppProtestLst.do?cmd=getOkrWorkFbList", $("#srchFrm").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//sheet4 Action
	function doAction4(sAction) {
		switch (sAction) {
		case "Search":
			sheet4.DoSearch("${ctx}/OkrAppProtestLst.do?cmd=getOkrWorkLastList", $("#srchFrm").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		
		if( rv["Code"] != "-1" ){
			p.popReturnValue(rv);
			p.self.close();
		}
	}

</script>


</head>
<body class="bodywrap">

<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='empPapResultPop1' mdef='평가결과'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<form id="srchFrm" name="srchFrm">
			<input id="authPg" 				name="authPg" 				type="hidden" 	value="" />
			<input id="searchAppraisalCd"	name="searchAppraisalCd" 	type="hidden" 	value="" />
			<input id="searchAppOrgCd" 		name="searchAppOrgCd" 		type="hidden" 	value="" />
			<input id="searchSabun" 		name="searchSabun"		 	type="hidden" 	value="" />
			
			<table class="table">
				<tbody>
					<colgroup>
						<col width="15%" />
						<col width="35%" />
						<col width="15%" />
						<col width="35%" />
					</colgroup>
	
					<tr>
						<th class="content"><tit:txt mid='113302' mdef='성명'/></th>
						<td class="content"><span id="span_searchName" class="txt pap_span"></span></td>
						<th class="content"><tit:txt mid='104470' mdef='사번'/></th>
						<td class="content"><span id="span_searchSabun" class="txt pap_span"></span></td>
					</tr>
					<tr>
						<th class="content"><tit:txt mid='114648' mdef='소속'/></th>
						<td class="content"><span id="span_searchOrgNm" class="txt pap_span"></span></td>
						<th class="content"><tit:txt mid='113312' mdef='직위'/></th>
						<td class="content"><span id="span_searchJikweeNm" class="txt pap_span"></span></td>
					</tr>
				</tbody>
			</table>
			
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='2023082801359' mdef='업무현황'/></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "150px","${ssnLocaleCd}"); </script>

			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='114661' mdef='실적현황'/></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet2", "100%", "150px","${ssnLocaleCd}"); </script>

			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='2023082801355' mdef='분기피드백'/></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet3", "100%", "180px","${ssnLocaleCd}"); </script>
			
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='empPapResultPop1' mdef='평가결과'/></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet4", "100%", "70px","${ssnLocaleCd}"); </script>
			
		</form>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();"	class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>