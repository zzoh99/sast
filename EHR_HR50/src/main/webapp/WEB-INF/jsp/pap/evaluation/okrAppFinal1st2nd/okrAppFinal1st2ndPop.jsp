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
		$("#searchAppOrgCd").val(arg["searchAppOrgCd"]); //평가소속
		$("#searchSabun").val(arg["searchSabun"]); //피평가자사번
		$("#searchAppStatusCd").val(arg["searchAppStatusCd"]); //상태
		$("#searchAppSeqCd").val(arg["searchAppSeqCd"]);
		$("#searchAppStepCd").val(arg["searchAppStepCd"]);
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

			{Header:"<sht:txt mid='fileGubn' mdef='업무명'/>",				Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"workTitle", 		KeyField:0},
			{Header:"<sht:txt mid='notiTypeCd' mdef='유형'/>",				Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"quaCd",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:3 },
			{Header:"<sht:txt mid='2023082501084' mdef='리뷰결과'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reviewCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:3 },
			{Header:"<sht:txt mid='2023082501102' mdef='코멘트'/>",			Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"reviewComment",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 },

			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetUnicodeByte(3);

		// sheet2 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,SizeMode:2};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='appIndexGubunCd_V1134' mdef='구분|구분'/>",			  	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appPerSetCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='2023082400816' mdef='피평가자|주요활동 및 성과'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appPerNote1",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='2023082400815' mdef='피평가자|미흡한과제'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appPerNote2",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082400814' mdef='평가자|강점/개발필요점'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appPerFeedNote1",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082400813' mdef='평가자|주요내용/지원\n필요사항'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appPerFeedNote2",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082801353' mdef='평가자|종합의견'/>",			  		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appPerFeedCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },

			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"}
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetUnicodeByte(3);
		
		// sheet3 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='2023082801360' mdef='피드백'/>",		Type:"Text",	Hidden:1,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"app1stComment",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082801360' mdef='피드백'/>",		Type:"Text",	Hidden:1,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"app2ndComment",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082801360' mdef='피드백'/>",		Type:"Text",	Hidden:1,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"app3rdComment",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082801361' mdef='1차등급'/>",	Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"app1stClassCd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='2023082801362' mdef='2차등급'/>",	Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"app2ndClassCd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='finalClassCdV1' mdef='최종등급'/>",	Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"app3rdClassCd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='2023082801363' mdef='최종상태'/>",	Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appStatusCd",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"}
		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetUnicodeByte(3);
		
		//평가상태코드(P30019)
		var comboList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=A","P00001"), "전체");
		sheet3.SetColProperty("app1stClassCd", {ComboText: "|"+comboList[0], ComboCode: "|"+comboList[1]} );
		sheet3.SetColProperty("app2ndClassCd", {ComboText: "|"+comboList[0], ComboCode: "|"+comboList[1]} );
		sheet3.SetColProperty("app3rdClassCd", {ComboText: "|"+comboList[0], ComboCode: "|"+comboList[1]} );
		
		//평가상태코드(P30019)
		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P30019"), "전체");
		sheet3.SetColProperty("appStatusCd", {ComboText: "|"+comboList1[0], ComboCode: "|"+comboList1[1]} );
		
		if(authPg == "R") {
			$("#btnSave").hide();
		}

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
		}
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OkrAppProtestLst.do?cmd=getOkrWorkPerList", $("#srchFrm").serialize() );
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
			sheet2.DoSearch("${ctx}/OkrAppProtestLst.do?cmd=getOkrWorkFbList", $("#srchFrm").serialize());
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
			sheet3.DoSearch("${ctx}/OkrAppProtestLst.do?cmd=getOkrWorkLastList", $("#srchFrm").serialize());
			break;
			
		case "Save":
			//내용체크
			if(sheet3.RowCount() > 0) {
				for(var i = sheet3.HeaderRows(); i < sheet3.RowCount()+sheet3.HeaderRows(); i++) {
					if($("#searchAppSeqCd").val() == "1") {
						if(sheet3.GetCellValue(i, "app1stClassCd") == "") {
							alert("<msg:txt mid='2023082801366' mdef='1차등급을 선택해주세요.'/>");
							return;
						}
						sheet3.SetCellValue(i, "appStatusCd", "21");
					}else if($("#searchAppSeqCd").val() == "2") {
						if(sheet3.GetCellValue(i, "app2ndClassCd") == "") {
							alert("<msg:txt mid='2023082801365' mdef='2차등급을 선택해주세요.'/>");
							return;
						}
						sheet3.SetCellValue(i, "appStatusCd", "31");
					} else{
						if(sheet3.GetCellValue(i, "app3rdClassCd") == "") {
							alert("<msg:txt mid='2023082801364' mdef='최종등급을 선택해주세요.'/>");
							return;
						}
						sheet3.SetCellValue(i, "appStatusCd", "91");
					}
				}
			}
			
			IBS_SaveName(document.srchFrm,sheet3);
			sheet3.DoSave("${ctx}/OkrAppFinal1st2nd.do?cmd=saveOkrAppFinal", $("#srchFrm").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(sheet3.RowCount() > 0) {
				for(var i = sheet3.HeaderRows(); i < sheet3.RowCount()+sheet3.HeaderRows(); i++) {
					if($("#searchAppSeqCd").val() == "1") {
						sheet3.SetColHidden("app1stComment", 0);
						sheet3.SetColHidden("app1stClassCd", 0);
						sheet3.SetColHidden("app2ndComment", 1);
						sheet3.SetColHidden("app2ndClassCd", 1);
						sheet3.SetColHidden("app3rdComment", 1);
						sheet3.SetColHidden("app3rdClassCd", 1);
						if(authPg == "A") {
							sheet3.SetCellEditable(i, "app1stComment", true);
							sheet3.SetCellEditable(i, "app1stClassCd", true);
						}else{
							sheet3.SetCellEditable(i, "app1stComment", false);
							sheet3.SetCellEditable(i, "app1stClassCd", false);
						}
					}else if($("#searchAppSeqCd").val() == "2") {
						sheet3.SetColHidden("app1stComment", 1);
						sheet3.SetColHidden("app1stClassCd", 0);
						sheet3.SetColHidden("app2ndComment", 0);
						sheet3.SetColHidden("app2ndClassCd", 0);
						sheet3.SetColHidden("app3rdComment", 1);
						sheet3.SetColHidden("app3rdClassCd", 1);
						sheet3.SetCellEditable(i, "app1stComment", false);
						sheet3.SetCellEditable(i, "app1stClassCd", false);
						if(authPg == "A") {
							sheet3.SetCellEditable(i, "app2ndComment", true);
							sheet3.SetCellEditable(i, "app2ndClassCd", true);
						}else{
							sheet3.SetCellEditable(i, "app2ndComment", false);
							sheet3.SetCellEditable(i, "app2ndClassCd", false);
						}
					}else if($("#searchAppSeqCd").val() == "6") {
						sheet3.SetColHidden("app1stComment", 1);
						sheet3.SetColHidden("app1stClassCd", 0);
						sheet3.SetColHidden("app2ndComment", 1);
						sheet3.SetColHidden("app2ndClassCd", 0);
						sheet3.SetColHidden("app3rdComment", 0);
						sheet3.SetColHidden("app3rdClassCd", 0);
						sheet3.SetCellEditable(i, "app1stComment", false);
						sheet3.SetCellEditable(i, "app1stClassCd", false);
						sheet3.SetCellEditable(i, "app2ndComment", false);
						sheet3.SetCellEditable(i, "app2ndClassCd", false);
						if(authPg == "A") {
							sheet3.SetCellEditable(i, "app3rdComment", true);
							sheet3.SetCellEditable(i, "app3rdClassCd", true);
						}else{
							sheet3.SetCellEditable(i, "app3rdComment", false);
							sheet3.SetCellEditable(i, "app3rdClassCd", false);
						}
					}
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
			if(Msg != "") alert(Msg);
			p.popReturnValue([]);
			p.self.close();
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
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
			<input id="searchAppStatusCd"	name="searchAppStatusCd"	type="hidden" 	value="" />
			<input id="searchAppSeqCd"		name="searchAppSeqCd"		type="hidden" 	value="" />
			<input id="searchAppStepCd"		name="searchAppStepCd"		type="hidden" 	value="" />
			
			<table class="table">
				<tbody>
					<colgroup>
						<col width="5%" />
						<col width="10%" />
						<col width="5%" />
						<col width="10%" />
						<col width="5%" />
						<col width="10%" />
						<col width="5%" />
						<col width="10%" />
					</colgroup>
	
					<tr>
						<th class="content"><tit:txt mid='113302' mdef='성명'/></th>
						<td class="content"><span id="span_searchName" class="txt pap_span"></span></td>
						<th class="content"><tit:txt mid='104470' mdef='사번'/></th>
						<td class="content"><span id="span_searchSabun" class="txt pap_span"></span></td>
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
						<li id="txt" class="txt"><tit:txt mid='114661' mdef='실적현황'/></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "150px","${ssnLocaleCd}"); </script>

			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='2023082801355' mdef='분기피드백'/></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet2", "100%", "170px","${ssnLocaleCd}"); </script>
			
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='2023082801367' mdef='최종피드백'/></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet3", "100%", "60px","${ssnLocaleCd}"); </script>
			
		</form>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:doAction3('Save');"	id="btnSave" class="pink large"><tit:txt mid='104476' mdef='저장'/></a>
					<a href="javascript:p.self.close();"	class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>