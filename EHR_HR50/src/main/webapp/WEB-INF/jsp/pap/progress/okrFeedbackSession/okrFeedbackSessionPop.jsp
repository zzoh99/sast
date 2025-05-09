<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<title><tit:txt mid='2023082801355' mdef='분기피드백'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p 	= eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	var authPg = "${authPg}";
	var statusCd = "";
	var adminCheck = "";

	$(function(){
		//리스트 화면에서 넘어온값 셋팅(상세보기)
		var arg = p.popDialogArgumentAll();
		$("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
		$("#searchAppSabun").val(arg["searchAppSabun"]); //평가자사번
		$("#searchSabun").val(arg["searchSabun"]); //피평가자사번
		$("#searchAppCheckSeq").val(arg["searchAppCheckSeq"]); //분기
		$("#adminCheck").val(arg["adminCheck"]); //분기
		$("#searchWorkStatusCd").val(arg["searchWorkStatusCd"]); //업무진행상태
		
		adminCheck = arg["adminCheck"];
		statusCd = arg["searchWorkStatusCd"];
		
		// 실적분기(P10008)
		var appPerSetCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10008"), "");
		
		// 종합의견(P10007)
		var appPerFeedCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10007"), "");
	
		// 닫기 버튼
		$(".close").click(function() 	{
			p.self.close();
		});

		// sheet1 init
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus V3' mdef='상태|상태'/>",					Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='appIndexGubunCd_V1134' mdef='구분|구분'/>",			  	 Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appPerSetCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='2023082400816' mdef='피평가자|주요활동 및 성과'/>",		  Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"appPerNote1",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082400815' mdef='피평가자|미흡한과제'/>",			  Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"appPerNote2",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082400814' mdef='평가자|강점/개발필요점'/>",			  Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"appPerFeedNote1",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082400813' mdef='평가자|주요내용/지원\n필요사항'/>",	   Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"appPerFeedNote2",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	MultiLineText:1, Wrap:1,	EditLen:4000 },
			{Header:"<sht:txt mid='2023082801353' mdef='평가자|종합의견'/>",			  	  Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appPerFeedCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

			{Header:"평가ID",	Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"사원번호",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"평가소속",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetUnicodeByte(3);

		$(window).smartresize(sheetResize); sheetInit();
		
		sheet1.SetColProperty("appPerSetCd", 	{ComboText:appPerSetCdList[0], ComboCode:appPerSetCdList[1]} );
		sheet1.SetColProperty("appPerFeedCd", 	{ComboText:appPerFeedCdList[0], ComboCode:appPerFeedCdList[1]} );
		
		$("#btnSubmit").hide();
		if(adminCheck == "U") { //피평가자
			if(statusCd == "" || statusCd == "11" ||statusCd == "21" || statusCd == "31") {
				$("#btnSubmit").show();
			}
		}else {
			if(statusCd == "1" || statusCd == "2" ||statusCd == "3" || statusCd == "4") {
				$("#btnSubmit").show();
			}
		}
		
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/OkrFeedbackSession.do?cmd=getOkrFeedbackSessionPopList", $("#srchFrm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.srchFrm, sheet1);
			sheet1.DoSave("${ctx}/OkrFeedbackSession.do?cmd=saveOkrFeedbackSessionPop", $("#srchFrm").serialize(),-1,false);
			break;
		}
	}

	// Sheet1 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			// 자동생성 ROW 인 경우 수정, 삭제 불가
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
				//평가자와 피평가자인 경우 활성화처리
				if($("#adminCheck").val() == "A") { //평가자 및 관리자
					if($("#searchAppCheckSeq").val() == sheet1.GetCellValue(i, "appPerSetCd")) {
						if(statusCd == "1" ||statusCd == "2" || statusCd == "3" || statusCd == "4") {
							sheet1.SetCellEditable(i,"appPerFeedNote1", 1);
							sheet1.SetCellEditable(i,"appPerFeedNote2", 1);
							sheet1.SetCellEditable(i,"appPerFeedCd", 1);
							sheet1.SetCellBackColor(i, "appPerFeedNote1", "#FFFFFF");
							sheet1.SetCellBackColor(i, "appPerFeedNote2", "#FFFFFF");
							sheet1.SetCellBackColor(i, "appPerFeedCd", "#FFFFFF");
						} else {
							sheet1.SetCellEditable(i,"appPerFeedNote1", 0);
							sheet1.SetCellEditable(i,"appPerFeedNote2", 0);
							sheet1.SetCellEditable(i,"appPerFeedCd", 0);
						}
					} else {
						sheet1.SetCellEditable(i,"appPerFeedNote1", 0);
						sheet1.SetCellEditable(i,"appPerFeedNote2", 0);
						sheet1.SetCellEditable(i,"appPerFeedCd", 0);
					}
				} else { //피평가자
					if($("#searchAppCheckSeq").val() == sheet1.GetCellValue(i, "appPerSetCd")) {
						if(statusCd == "" || statusCd == "11" ||statusCd == "21" || statusCd == "31" || statusCd == "41") {
							sheet1.SetCellEditable(i,"appPerNote1", 1);
							sheet1.SetCellEditable(i,"appPerNote2", 1);
							sheet1.SetCellBackColor(i, "appPerNote1", "#FFFFFF");
							sheet1.SetCellBackColor(i, "appPerNote2", "#FFFFFF");
						} else {
							sheet1.SetCellEditable(i,"appPerNote1", 0);
							sheet1.SetCellEditable(i,"appPerNote2", 0);
						}
					} else {
						sheet1.SetCellEditable(i,"appPerNote1", 0);
						sheet1.SetCellEditable(i,"appPerNote2", 0);
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
		try{
			if(Msg != ""){
				alert(Msg);
			}
			
			// 자동생성 ROW 인 경우 수정, 삭제 불가
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
				if($("#searchAppCheckSeq").val() == sheet1.GetCellValue(i, "appPerSetCd")) {
					//평가자와 피평가자인 경우 활성화처리
					if($("#adminCheck").val() == "U") {
						if($("#searchAppCheckSeq").val() == sheet1.GetCellValue(i, "appPerSetCd")) {
							$("#searchWorkStatusCd").val(sheet1.GetCellValue(i, "appPerSetCd"));
							$("#searchAppOrgCd").val(sheet1.GetCellValue(i, "appOrgCd"));
						}
					} else {
						if($("#searchAppCheckSeq").val() == sheet1.GetCellValue(i, "appPerSetCd")) {
							$("#searchWorkStatusCd").val(sheet1.GetCellValue(i, "appPerSetCd")+"1");
							$("#searchAppOrgCd").val(sheet1.GetCellValue(i, "appOrgCd"));
						}
					}
				}
			}
			
			var rtn = ajaxCall("${ctx}/OkrFeedbackSession.do?cmd=updateOkrFeedbackSession",$("#srchFrm").serialize(),false);
				
			if(rtn.Result.Code < 1) {
				alert(rtn.Result.Message);
				return false;
			}else{
				var rv = new Array();
				rv["Code"] = "1";
				
				alert("<msg:txt mid='2023082801354' mdef='분기피드백 등록이 완료되었습니다.'/>");
				p.popReturnValue(rv);
				p.self.close();
			}
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
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='2023082801355' mdef='분기피드백'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<form id="srchFrm" name="srchFrm">
			<input id="authPg" 				name="authPg" 				type="hidden" 	value="" />
			<input id="searchAppraisalCd"	name="searchAppraisalCd" 	type="hidden" 	value="" />
			<input id="searchAppSabun" 		name="searchAppSabun" 		type="hidden" 	value="" />
			<input id="searchSabun" 		name="searchSabun"		 	type="hidden" 	value="" />
			<input id="searchAppCheckSeq" 	name="searchAppCheckSeq" 	type="hidden" 	value="" />
			<input id="adminCheck"			name="adminCheck" 			type="hidden" 	value="" />
			<input id="searchWorkStatusCd"	name="searchWorkStatusCd" 	type="hidden" 	value="" />
			<input id="searchAppOrgCd"		name="searchAppOrgCd" 	type="hidden" 	value="" />
		
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='2023082801355' mdef='분기피드백'/></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}");</script>
		</form>
		
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:doAction1('Save')"	class="pink large" id="btnSubmit"><tit:txt mid='104476' mdef='저장'/></a>
					<a href="javascript:p.self.close();"	class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>