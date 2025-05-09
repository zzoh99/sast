<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<title><tit:txt mid='2023082801338' mdef='개인업무(TASK)실적'/></title>
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
		$("#searchAppStepCd").val(arg["searchAppStepCd"]); //평가단계
		$("#searchAppOrgCd").val(arg["searchAppOrgCd"]); //평가소속
		$("#searchAppSabun").val(arg["searchAppSabun"]); //평가자사번
		$("#searchSabun").val(arg["searchSabun"]); //피평가자사번
		$("#searchPriorSeq").val(arg["searchPriorSeq"]);
		$("#searchSeq").val(arg["searchSeq"]);
		$("#closeYn").val(arg["closeYn"]);	// 마감여부
		$("#searchStatusCd").val(arg["searchStatusCd"]);
		$("#pageGubun").val(arg["pageGubun"]); //페이지 구분

		// 상시성과방법
		var quaCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30004"), "선택"); // 상시평가방법
		$("#quaCd").html( quaCd[2] );

		// 상시기간단위
		var termCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30002"), " "); // 상시기간단위
		$("#termCd").html( termCd[2] );

		// 상시업무수준
		var levelCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30001"), " "); // 상시업무수준
		$("#level1").html( levelCd[2] );
		$("#level2").html( levelCd[2] );
		$("#level3").html( levelCd[2] );
		$("#totalLevel").html( levelCd[2] );

		//직무콤보 조회
		var jobCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getJobCdList",false).codeList, " "); // 직무명
		$("#jobCd").html(jobCdList[2]);
		$("#jobDetailCd").html(jobCdList[2]);

		$("#completeLevel").maxbyte(4000); //완료수준
		$("#contents").maxbyte(4000); //상세내용

		// 닫기 버튼
		$(".close").click(function() 	{
			p.self.close();
		});

		// sheet1 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"업무명",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workTitle", 	KeyField:1},
			{Header:"상시평가방법",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"quaCd",		KeyField:1},
			{Header:"성과관리자",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workManageSabun"},
			{Header:"성과관리자",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workManageName"},
			{Header:"상시기간",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"term"},
			{Header:"상시기간단위",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"termCd"},
			{Header:"상시성과시작일자",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"termSdate"},
			{Header:"상시성과종료일자",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"termEdate"},
			{Header:"완료수준",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"completeLevel"},
			{Header:"수준_적정성",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"level1"},
			{Header:"수준_적시성",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"level2"},
			{Header:"수준_연계성",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"level3"},
			{Header:"종합수준",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"totalLevel"},
			{Header:"직무코드",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jobCd"},
			{Header:"직무세부코드",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jobDetailCd"},
			{Header:"동료",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"coworker"},
			{Header:"핵심과제여부",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"keyTaskYn"},
			{Header:"상세내용",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"contents"},
			{Header:"비고",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"bigo"},
			{Header:"Coworker",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"coworkerList"},

			{Header:"평가ID",			Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"팀목표순번",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorSeq", 	KeyField:1},
			{Header:"업무순번",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq", 		KeyField:1},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(false);sheet1.SetUnicodeByte(3);

		// sheet2 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,SizeMode:2};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='ymdV9' mdef='일자'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='2023082801339' mdef='달성도(%)'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"taskRate",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:3 },
			{Header:"<sht:txt mid='2023082501102' mdef='코멘트'/>",			Type:"Text",	Hidden:0,	Width:470,	Align:"Left",	ColMerge:0,	SaveName:"taskComment",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 },

			{Header:"평가ID",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"팀목표순번",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorSeq", 		KeyField:1},
			{Header:"업무순번",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq", 			KeyField:1},
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetUnicodeByte(3);

		// sheet3 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='ymdV9' mdef='일자'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='2023082501084' mdef='리뷰결과'/>",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"reviewCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='2023082501102' mdef='코멘트'/>",		Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"reviewComment",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082801352' mdef='협의요청내용'/>",Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"conferMemo",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },

			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"팀목표순번",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"priorSeq", 		KeyField:1},
			{Header:"업무순번",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq", 			KeyField:1},
			{Header:"등록순번",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"regSeq"}
		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetUnicodeByte(3);

		$(window).smartresize(sheetResize); sheetInit();

		// 상시평가리뷰결과
		var reviewCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30003"), ""); // 상시평가리뷰결과(P30003)
		sheet3.SetColProperty("reviewCd", 	{ComboText:reviewCdList[0], ComboCode:reviewCdList[1]} );

		if( arg != "undefined" ) {
			authPg = arg["authPg"];

			// 팀과제
			var priorSeqList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getTeamAppPriorSeqList&searchAppraisalCd="+$('#searchAppraisalCd').val()+"&searchAppStepCd="+$('#searchAppStepCd').val()+"&searchSabun="+$('#searchSabun').val()+"&searchAppOrgCd="+$('#searchAppOrgCd').val()+"&searchAppSabun="+$('#searchAppSabun').val(),false).codeList, ""); // 평가명
			$("#priorSeq").html(priorSeqList[2]);

			if (authPg == "A") {

				if($("#searchStatusCd").val() != "31" && $("#searchStatusCd").val() != "35"){
					$(".btn").addClass("hide");
					$("#btnSubmit").addClass("hide");
				}
				
				if($("#pageGubun").val() != "workReg"){
					$("#btnConfer").addClass("hide");
				} else {
					$("#btnConfer").removeClass("hide");
				}

			} else if (authPg == "R"){
				$(".btn").addClass("hide");
				$("#btnConfer").addClass("hide");
				$("#btnSubmit").addClass("hide");
			}
		}

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OkrWorkReg.do?cmd=getOkrWorkRegDet1", $("#srchFrm").serialize() );
			break;
		}
	}

	// Sheet1 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			setSheetToForm();
			doAction2("Search");
			doAction3("Search");
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function setSheetToForm() {
		if(sheet1.SearchRows() > 0) {
			$("#priorSeq").val(sheet1.GetCellValue(sheet1.LastRow(), "priorSeq"));
			$("#seq").val(sheet1.GetCellValue(sheet1.LastRow(), "seq"));
			$("#workTitle").val(sheet1.GetCellValue(sheet1.LastRow(), "workTitle"));
			$("#quaCd").val(sheet1.GetCellValue(sheet1.LastRow(), "quaCd"));
			$("#workManageSabun").val(sheet1.GetCellValue(sheet1.LastRow(), "workManageSabun"));
			$("#workManageName").val(sheet1.GetCellValue(sheet1.LastRow(), "workManageName"));
			$("#term").val(sheet1.GetCellValue(sheet1.LastRow(), "term"));
			$("#termCd").val(sheet1.GetCellValue(sheet1.LastRow(), "termCd"));
			$("#termSdate").val(sheet1.GetCellValue(sheet1.LastRow(), "termSdate"));
			$("#termEdate").val(sheet1.GetCellValue(sheet1.LastRow(), "termEdate"));
			$("#completeLevel").val(sheet1.GetCellValue(sheet1.LastRow(), "completeLevel"));
			$("#level1").val(sheet1.GetCellValue(sheet1.LastRow(), "level1"));
			$("#level2").val(sheet1.GetCellValue(sheet1.LastRow(), "level2"));
			$("#level3").val(sheet1.GetCellValue(sheet1.LastRow(), "level3"));
			$("#totalLevel").val(sheet1.GetCellValue(sheet1.LastRow(), "totalLevel"));
			$("#jobCd").val(sheet1.GetCellValue(sheet1.LastRow(), "jobCd"));
			$("#jobDetailCd").val(sheet1.GetCellValue(sheet1.LastRow(), "jobDetailCd"));
			$("#contents").val(sheet1.GetCellValue(sheet1.LastRow(), "contents"));

			if(sheet1.GetCellValue(sheet1.LastRow(),"keyTaskYn") == "Y") {
				$("#keyTaskYn").attr("checked",true);
			} else {
				$("#keyTaskYn").attr("checked",false);
			}
			$("#coworkerList").val(sheet1.GetCellValue(sheet1.LastRow(), "coworkerList"));
		}
	}

	//sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch("${ctx}/OkrWorkReg.do?cmd=getOkrWorkRegPerDet", $("#srchFrm").serialize());
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
			sheet3.DoSearch("${ctx}/OkrWorkReg.do?cmd=getOkrWorkRegReviewDet", $("#srchFrm").serialize());
			break;

		case "Save":
			IBS_SaveName(document.srchFrm, sheet3);
			sheet3.DoSave("${ctx}/OkrWorkReg.do?cmd=saveOkrWorkRegReview", $("#srchFrm").serialize(),-1,false);
			break;

		case "Insert":
			var Row = sheet3.DataInsert(0);
			sheet3.SetCellValue(Row, "appraisalCd", sheet1.GetCellValue(sheet1.LastRow(), "appraisalCd"));
			sheet3.SetCellValue(Row, "appOrgCd", 	sheet1.GetCellValue(sheet1.LastRow(), "appOrgCd"));
			sheet3.SetCellValue(Row, "sabun", 		sheet1.GetCellValue(sheet1.LastRow(), "sabun"));
			sheet3.SetCellValue(Row, "priorSeq", 	sheet1.GetCellValue(sheet1.LastRow(), "priorSeq"));
			sheet3.SetCellValue(Row, "seq", 		sheet1.GetCellValue(sheet1.LastRow(), "seq"));
			sheet3.SetCellValue(Row, "regYmd", 		"<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
		
			//실적제출과 협의요청일때만 처리
			if (authPg == "A") {
				if($("#searchStatusCd").val() == "31" || $("#searchStatusCd").val() == "35"){
					doAction3("Insert");
				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			
			//확정처리 상태 업데이트
			$("#searchStatusCd").val("99");
			var rtn = ajaxCall("${ctx}/OkrWorkReg.do?cmd=updateOkrWorkStatusCd",$("#srchFrm").serialize(),false);
				
			if(rtn.Result.Code < 1) {
				alert(rtn.Result.Message);
				return false;
			}else{
				alert("<msg:txt mid='2023082801351' mdef='개인업무(TASK) 확정 처리되었습니다.'/>");
				p.popReturnValue([]);
				p.self.close();
			}
			
			if ( Code != -1 ) {
				doAction3("Search");
				// 데이터 1건이상 저장 시 확정처리 가능
				saveYn = "Y";
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 저장
	function setValue() {

		//저장
		try{
			if(confirm("<msg:txt mid='alertPmMbo21' mdef='확정하시겠습니까?'/>")){
				doAction3("Save");
			}
		} catch (ex){
			alert("Script Errors Occurred While Saving." + ex);
			return false;
		}
	}
	
	function setConferMemo(){
		if(!isPopup()) {return;}

		var url = "${ctx}/OkrWorkReg.do?cmd=viewOkrWorkRegReviewPopComment";
 		var args = new Array();

 		args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
 		args["searchAppOrgCd"] = $("#searchAppOrgCd").val();
 		args["searchSabun"] = $("#searchSabun").val();
 		args["searchPriorSeq"] = $("#searchPriorSeq").val();
		args["searchSeq"] = $("#searchSeq").val();
		args["searchRegYmd"] = sheet3.GetCellValue(1, "regYmd");
		args["searchRegSeq"] = sheet3.GetCellValue(1, "regSeq");

 		gPRow = "";
 		pGubun = "okrWorkRegReviewPopComment";

 		openPopup(url,args,500,320);
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
				<li><tit:txt mid='2023082501083' mdef='개인업무(TASK)평가자점검'/></li>
				<li class="close"></li>
			</ul>
		</div>

		<div class="popup_main">
		<form id="srchFrm" name="srchFrm">
		<input id="authPg" 				name="authPg" 				type="hidden" 	value="" />
		<input id="searchAppraisalCd"	name="searchAppraisalCd" 	type="hidden" 	value="" />
		<input id="searchAppStepCd" 	name="searchAppStepCd" 		type="hidden" 	value="" />
		<input id="searchAppOrgCd" 		name="searchAppOrgCd" 		type="hidden" 	value="" />
		<input id="searchAppSabun" 		name="searchAppSabun" 		type="hidden" 	value="" />
		<input id="searchSabun" 		name="searchSabun"		 	type="hidden" 	value="" />
		<input id="searchPriorSeq" 		name="searchPriorSeq" 		type="hidden" 	value="" />
		<input id="searchSeq" 			name="searchSeq" 			type="hidden" 	value="" />
		<input id="searchRegYmd" 		name="searchRegYmd" 		type="hidden" 	value="" />
		<input id="searchRegSeq" 		name="searchRegSeq" 		type="hidden" 	value="" />
		<input id="searchStatusCd" 		name="searchStatusCd" 		type="hidden" 	value="" />
		<input id="closeYn" 			name="closeYn" 				type="hidden" 	value="" />	<!-- 마감여부 -->
		<input id="pageGubun" 			name="pageGubun" 			type="hidden" 	value="" />	<!-- 마감여부 -->

		<table class="table" style="width:100%">
			<tbody>
				<colgroup>
					<col width="13%" />
					<col width="35%" />
					<col width="13%" />
					<col width="*" />
				</colgroup>

				<tr>
					<th><tit:txt mid='2023082801321' mdef='팀목표'/></th>
					<td class="content" colspan="3">
						<select id="priorSeq" name="priorSeq" class="transparent hideSelectButton box w100p disabled" disabled></select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='112534' mdef='업무명'/></th>
					<td class="content" colspan="3">
						<input id="workTitle" name="workTitle" class="text transparent readonly w100p" readonly type="text" />
						<input id="seq" name="seq" type="hidden" readonly />
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='2023082500932' mdef='정성/정량'/></th>
					<td class="content">
						<select id="quaCd" name="quaCd" class="transparent hideSelectButton box w30p disabled" disabled></select>
					</td>
					<th><tit:txt mid='2023082801320' mdef='성과관리자'/></th>
					<td class="content" colspan="3">
						<input id="workManageName" name ="workManageName" type="text" class="text transparent readonly" readonly/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104420' mdef='기간'/></th>
					<td class="content">
						<input id="term" name="term" class="text transparent readonly w20p center" type="text" readonly maxlength="2" />
						<select id="termCd" name="termCd" class="transparent hideSelectButton box w30p disabled" disabled></select>
					</td>
					<th><tit:txt mid='2023082801322' mdef='기간일자'/></th>
					<td class="content" colspan="3">
						<input id="termSdate" name="termSdate" type="text" size="10" class="text transparent readonly" readonly/>  ~
						<input id="termEdate" name="termEdate" type="text" size="10" class="text transparent readonly" readonly/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='2023082801323' mdef='완료수준'/></th>
					<td class="content" colspan="3">
						<textarea id="completeLevel" name="completeLevel" rows="4" class="text transparent readonly w100p" readonly></textarea>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='113600' mdef='수준'/></th>
					<td class="content" colspan="3">
						<tit:txt mid='2023082801329' mdef='적정성'/> <select id="level1" name="level1" class="transparent hideSelectButton box disabled" disabled style="width:95px;" ></select>&nbsp;&nbsp;&nbsp;&nbsp;
						<tit:txt mid='2023082801328' mdef='적시성'/> <select id="level2" name="level2" class="transparent hideSelectButton box disabled" disabled style="width:93px;" ></select>&nbsp;&nbsp;&nbsp;&nbsp;
						<tit:txt mid='2023082801327' mdef='연계성'/> <select id="level3" name="level3" class="transparent hideSelectButton box disabled" disabled style="width:95px;" ></select>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
						<b><tit:txt mid='2023082501238' mdef='종합수준'/></b> <select id="totalLevel" name="totalLevel" class="transparent hideSelectButton box disabled" disabled style="width:95px;"></select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='113439' mdef='직무'/></th>
					<td class="content">
						<select id="jobCd" name="jobCd" class="transparent hideSelectButton box w40p disabled" disabled></select>
						<select id="jobDetailCd" name="jobDetailCd" class="transparent hideSelectButton box w40p disabled" disabled></select>
					</td>
					<th><tit:txt mid='2023082801330' mdef='핵심과제여부'/></th>
					<td class="content">
						<input id="keyTaskYn" name="keyTaskYn" type="checkbox" disabled style="margin-left:5px; vertical-align:middle;" />
					</td>
				</tr>
				<tr>
					<th>Co-worker</th>
					<td class="content" colspan="3">
						<input id="coworkerList" name="coworkerList" class="text transparent readonly w100p" readonly type="text" />
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='112871' mdef='상세내용'/></th>
					<td class="content" colspan="3">
						<textarea id="contents" name="contents" rows="4" class="text transparent readonly w100p" readonly></textarea>
					</td>
				</tr>
			</tbody>
		</table>

		<!-- sheet1 -->
		<div class="hide">
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
		</div>

		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='113922' mdef='실적'/></li>
				</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet2", "100%", "150px","${ssnLocaleCd}"); </script>

		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='2023082801349' mdef='평가자점검'/></li>
					<!-- <li class="btn">
						<a href="javascript:doAction3('Insert')" 	class="basic authA">입력</a>
						<a href="javascript:doAction3('Save')" 		class="basic authA">저장</a>
					</li> -->
				</ul>
			</div>
		</div>
		<script type="text/javascript">createIBSheet("sheet3", "100%", "150px","${ssnLocaleCd}"); </script>

		</form>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:setConferMemo();"	class="pink large hide" id="btnConfer"><tit:txt mid='2023082801348' mdef='협의요청'/></a>
					<a href="javascript:setValue();"		class="pink large" id="btnSubmit"><tit:txt mid='114030' mdef='확정'/></a>
					<a href="javascript:p.self.close();"	class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>