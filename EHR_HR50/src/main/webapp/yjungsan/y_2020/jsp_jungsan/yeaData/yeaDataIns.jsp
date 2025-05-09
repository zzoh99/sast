<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>보험료</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
	var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
	//도움말
	var helpText;
	
	//기준년도
	var systemYY;
	
	var famList;

	$(function() {	
		/*필수 기본 세팅*/
		$("#searchWorkYy").val( 	$("#searchWorkYy", parent.document).val() 		) ;
		$("#searchAdjustType").val( $("#searchAdjustType", parent.document).val() 	) ;
		$("#searchSabun").val( 		$("#searchSabun", parent.document).val() 		) ;
		systemYY = $("#searchWorkYy", parent.document).val();
		
		//기본정보 조회(도움말 등등).
		initDefaultData() ;
<%--
		if(orgAuthPg == "A") {
			$("#copyBtn").show() ;
		} else {
			$("#copyBtn").hide() ;
		}
--%>
	});

	$(function() {

		<%--
		var inputEdit = 0 ;
		var applEdit = 0 ;
		if( orgAuthPg == "A") {
			inputEdit = 0 ;
			applEdit = 1 ;
		} else {
			inputEdit = 1 ;
			applEdit = 0 ;
		}
--%>
<%
String inputEdit = "0", applEdit = "0";
if( "Y".equals(adminYn) ) {
	inputEdit = "0";
	applEdit = "1";
} else{
	inputEdit = "1";
	applEdit = "0";
}
%>

		//연말정산 가족 쉬트.
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"년도",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"관계",			Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"fam_cd",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"fam_nm",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"주민등록번호",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"famres",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"학력",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"aca_cd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"기본\n공제",		Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"dpndnt_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"배우자\n공제",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"spouse_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"경로\n우대",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"senior_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"장애인\n공제",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"hndcp_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"장애\n구분",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"hndcp_type",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"부녀자\n공제",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"woman_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"자녀\n양육",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"child_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"출산\n입양",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"adopt_born_yn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"사업장",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"보험료",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"insurance_yn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"의료비",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"medical_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"교육비",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"education_yn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"신용\n카드등",		Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"credit_yn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(false);sheet1.SetCountPosition(4);

		//연말정산 보험료 쉬트
		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"No|No",					Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"DOC_SEQ|DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL|DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"년도|년도",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_yy",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분|정산구분",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사번|사번",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"순서|순서",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"계약자명|계약자명",				Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"famres_contrt",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"연말정산\n보험구분|연말정산\n보험구분",	Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"insurance_type",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"피보험자명|피보험자명",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"famres_insured",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"금액자료|직원용",				Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",		KeyField:0,	Format:"#,###",	PointCount:0,	UpdateEdit:<%=inputEdit%>,	InsertEdit:<%=inputEdit%>,	EditLen:35, MinimumValue: 0 },
			{Header:"금액자료|담당자용",				Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:1,	Format:"#,###",	PointCount:0,	UpdateEdit:<%=applEdit%>,	InsertEdit:<%=applEdit%>,	EditLen:35, MinimumValue: 0 },
			{Header:"자료입력유형|자료입력유형",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부|국세청\n자료여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자확인|담당자확인",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"feedback_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		//대상자 전부 조회
		$("#searchDpndntYn").val("");
		var famAllList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList",$("#sheetForm").serialize(),false).codeList, "");
		//공제대상자만 조회
		$("#searchDpndntYn").val("Y");
		famList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList",$("#sheetForm").serialize(),false).codeList, "");
		
		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
		var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");

		sheet2.SetColProperty("famres_contrt",	{ComboText:"|"+famAllList[0], ComboCode:"|"+famAllList[1]} );
		sheet2.SetColProperty("famres_insured",	{ComboText:"|"+famAllList[0], ComboCode:"|"+famAllList[1]} );
		sheet2.SetColProperty("insurance_type",	{ComboText:"|일반보장성보험료|장애인보장성보험료", ComboCode:"|5|6"} );
		sheet2.SetColProperty("adj_input_type",	{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet2.SetColProperty("feedback_type",	{ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
		
		sheet2.SetRangeBackColor(0,0,1, sheet2.LastCol(),"<%=headerColorA%>") ;
		
		$(window).smartresize(sheetResize);
		sheetInit();
		
		//2020-12-23. 담당자 마감일때 수정 불가 처리
		var empStatus = $("#tdStatusView>font:first", parent.document).attr("class");
		if(orgAuthPg == "A" && (empStatus == "close_3" || empStatus == "close_4")) {
			$("#btnDisplayYn05").hide() ;
            sheet1.SetEditable(false) ;
            sheet2.SetEditable(false) ;
		}
		parent.doSearchCommonSheet();
		doAction1("Search");
	});

	//연말정산가족
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=selectYeaDataPerList", $("#sheetForm").serialize() );
			break;
		}
	}

 	//연말정산 보험료
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "<%=jspPath%>/yeaData/yeaDataInsRst.jsp?cmd=selectYeaDataInsList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!parent.checkClose())return;

			tab_setAdjInputType(orgAuthPg, sheet2);

			sheet2.DoSave( "<%=jspPath%>/yeaData/yeaDataInsRst.jsp?cmd=saveYeaDataIns&orgAuthPg="+orgAuthPg);
			break;
		case "Insert":
			if(!parent.checkClose())return;

			var newRow = sheet2.DataInsert(0) ;
			sheet2.CellComboItem(newRow, "famres_contrt", {ComboText:"|"+famList[0], ComboCode:"|"+famList[1]});
			sheet2.CellComboItem(newRow, "famres_insured", {ComboText:"|"+famList[0], ComboCode:"|"+famList[1]});
			sheet2.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() ) ;
			sheet2.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() ) ;
			sheet2.SetCellValue( newRow, "sabun", $("#searchSabun").val() ) ;

			tab_clickInsert(orgAuthPg, sheet2, newRow);
			break;
		case "Copy":
			var newRow = sheet2.DataCopy();
			sheet2.SelectCell(newRow, 2) ;
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Code == 1) {
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				for(var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++){
					tab_setAuthEdtitable(orgAuthPg, sheet2, i);
				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			parent.getYearDefaultInfoObj();
			if(Code == 1) {
				parent.doSearchCommonSheet();
				doAction2("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//클릭시 발생
	function sheet2_OnClick(Row, Col, Value) {
		try{
			if(sheet2.ColSaveName(Col) == "sDelete" ) {
				tab_clickDelete(sheet2, Row);
				
				/* 금액 및 국세청 자료여부 Editable 풀림 방지*/
				if( sheet2.GetCellValue(Row, "adj_input_type") == "07" ) {
					sheet2.SetCellEditable(Row, "input_mon", 0);
					sheet2.SetCellEditable(Row, "appl_mon", 0);
					sheet2.SetCellEditable(Row, "nts_yn", 0);
				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//값 변경시 발생
	function sheet2_OnChange(Row, Col, Value) {
		try{
			//장애인보장성보험료 선택시 피보험자가 장애 인지 체크
			if(sheet2.ColSaveName(Col) == "insurance_type" || sheet2.ColSaveName(Col) == "famres_insured"){
				if(sheet2.GetCellValue(Row, "insurance_type") == "6"){
					if(sheet2.GetCellValue(Row, "famres_insured") != ""){
						if(sheet1.GetCellValue(sheet1.FindText("famres", sheet2.GetCellValue(Row, "famres_insured")), "hndcp_type") == ""){
							alert("피보험자가 인적공제의 장애구분에 장애코드가 선택되지 않았습니다. ");
							sheet2.SetCellValue(Row, "famres_insured", "") ;
							return;
						}
					}
				}
			}
			inputChangeAppl(sheet2,Col,Row);
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	//기본데이터 조회
	function initDefaultData() {
		var param = "searchWorkYy="+$("#searchWorkYy").val();
		param += "&queryId=getYeaDataHelpText";
		//도움말 조회
		var result = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param+"&adjProcessCd=B005",false);
		helpText = nvl(result.Data.help_text1,"") + nvl(result.Data.help_text2,"") + nvl(result.Data.help_text3,"");
		
		//안내메세지
        $("#infoLayer").html(helpText).hide();
	}

	//직원금액 입력시 담당자금액으로 셋팅 처리
	function inputChangeAppl(shtnm,colValue,rowValue){
		if(shtnm.ColSaveName(colValue) == "input_mon" || shtnm.ColSaveName(colValue) == "use_mon") {
			shtnm.SetCellValue(rowValue,"appl_mon", shtnm.GetCellValue(rowValue,colValue));
		}
	}

	//기본자료 설정.
	function sheetSet(){
		
		var comSheet = parent.commonSheet;

		if(comSheet.RowCount() > 0){
			/*
			$("#A030_01").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_01"),"input_mon" ) );
			$("#A030_11").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_11"),"input_mon" ) );
			$("#A030_12").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_12"),"input_mon" ) );
			$("#A030_02").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_02"),"input_mon" ) );
			$("#A030_13").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A030_13"),"input_mon" ) );
			
			$("#A040_03").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A040_03"),"input_mon" ) );
			$("#A040_04").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A040_04"),"input_mon" ) );
			*/
			$("#A040_05").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A040_05"),"input_mon" ) );
			$("#A040_07").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A040_07"),"input_mon" ) );
			
		} else {
			/*
			$("#A030_01").val("0");
			$("#A030_11").val("0");
			$("#A030_12").val("0");
			$("#A030_02").val("0");
			$("#A030_13").val("0");
			
			$("#A040_03").val("0");
			$("#A040_04").val("0");
			*/
			
			$("#A040_05").val("0");
			$("#A040_07").val("0");
		}
				
		var data2 = ajaxCall("<%=jspPath%>/yeaData/yeaDataInsRst.jsp?cmd=selectYeaDataInsCurMap", $("#sheetForm").serialize(),false);
		if(data2.Result.Message != "") alert(data2.Result.Message);
		if(data2.Result.Code == 1) {
			var map = data2.Data;
						
			$("#A030_01").val( comma(map.pen_mon) );
			$("#A030_11").val( comma(map.etc_mon2) );
			$("#A030_12").val( comma(map.etc_mon3) );
			$("#A030_02").val( comma(map.etc_mon1) );
			$("#A030_13").val( comma(map.etc_mon4) );
			
			$("#A040_03").val( comma(map.hel_mon) );
			$("#A040_04").val( comma(map.emp_mon) );
			
		} else {
			$("#A030_01").val("0");
			$("#A030_11").val("0");
			$("#A030_12").val("0");
			$("#A030_02").val("0");
			$("#A030_13").val("0");
			
			$("#A040_03").val("0");
			$("#A040_04").val("0");
		}

		var data = ajaxCall("<%=jspPath%>/yeaData/yeaDataInsRst.jsp?cmd=selectYeaDataInsBefMap", $("#sheetForm").serialize(),false);
		if(data.Result.Message != "") alert(data.Result.Message);
		if(data.Result.Code == 1) {
			var map = data.Data;
			
			$("#pen_mon").val( comma(map.pen_mon) );
			$("#etc_mon2").val( comma(map.etc_mon2) );
			$("#etc_mon3").val( comma(map.etc_mon3) );
			$("#etc_mon1").val( comma(map.etc_mon1) );
			$("#etc_mon4").val( comma(map.etc_mon4) );
			
			$("#hel_mon").val( comma(map.hel_mon) );
			$("#emp_mon").val( comma(map.emp_mon) );
			
		} else {
			$("#pen_mon").val("0");
			$("#etc_mon2").val("0");
			$("#etc_mon3").val("0");
			$("#etc_mon1").val("0");
			$("#etc_mon4").val("0");
			
			$("#hel_mon").val("0");
			$("#emp_mon").val("0");
		}
		
		$("#sum_row_1_1").val( comma( uncomma($("#A030_01").val()) + uncomma($("#A030_11").val()) + uncomma($("#A030_12").val()) + uncomma($("#A030_02").val()) + uncomma($("#A030_13").val()) ) );
		$("#sum_row_1_2").val( comma( uncomma($("#pen_mon").val()) + uncomma($("#etc_mon2").val()) + uncomma($("#etc_mon3").val()) + uncomma($("#etc_mon1").val()) + uncomma($("#etc_mon4").val()) ) );
		
		$("#sum_col_1_1").val( comma( uncomma($("#A030_01").val()) + uncomma($("#pen_mon").val()) ) );
		$("#sum_col_1_2").val( comma( uncomma($("#A030_11").val()) + uncomma($("#etc_mon2").val()) ) );
		$("#sum_col_1_3").val( comma( uncomma($("#A030_12").val()) + uncomma($("#etc_mon3").val()) ) );
		$("#sum_col_1_4").val( comma( uncomma($("#A030_02").val()) + uncomma($("#etc_mon1").val()) ) );
		$("#sum_col_1_5").val( comma( uncomma($("#A030_13").val()) + uncomma($("#etc_mon4").val()) ) );
		$("#sum_col_1_6").val( comma( uncomma($("#sum_row_1_1").val()) + uncomma($("#sum_row_1_2").val()) ) );
		
		$("#sum_row_2_1").val( comma( uncomma($("#A040_03").val()) + uncomma($("#A040_04").val()) ) );
		$("#sum_row_2_2").val( comma( uncomma($("#hel_mon").val()) + uncomma($("#emp_mon").val()) ) );
		
		$("#sum_col_2_1").val( comma( uncomma($("#A040_03").val()) + uncomma($("#hel_mon").val()) ) );
		$("#sum_col_2_2").val( comma( uncomma($("#A040_04").val()) + uncomma($("#emp_mon").val()) ) );
		$("#sum_col_2_3").val( comma( uncomma($("#sum_row_2_1").val()) + uncomma($("#sum_row_2_2").val()) ) );
		
	}

	//연말정산 안내
	function yeaDataExpPopup(title, helpText, height, width){
		var url 	= "<%=jspPath%>/common/yeaDataExpPopup.jsp";
		openYeaDataExpPopup(url, width, height, title, helpText);
	}

	function sheetChangeCheck() {
		var iTemp = sheet2.RowCount("I") + sheet2.RowCount("U") + sheet2.RowCount("D");
		if ( 0 < iTemp ) return true;
		return false;
	}
	
	function comma(str) {
		if ( str == "" ) return 0;
		
		str = String(str);
		return str.replace(/(\d)(?=(?:\d{3})+(?!\d))/g, '$1,');
	}
	
	function uncomma(str) {
		if ( str == "" ) return 0;
		
		str = String(str);
		str = str.replace(/[^\d]+/g, '');
		
		return parseInt(str, 10);
	}
	
	/* $(function() {
        $('.cute_gray').tooltip({
           items: '*',
           content: helpText,
           show: "slideDown", //show immediately
           open: function(event, ui) {
        	  var $element = $(event.target);
        	  ui.tooltip.click(function () {
                  $element.tooltip('close');
              });
        	  ui.tooltip.css("max-width", "1000px");
        	  ui.tooltip( "open" );
           }
        });
        
        //클릭시 툴팁 실행
        $('.cute_gray').tooltip({          
            disabled: true,
            close: function(event, ui) { $(this).tooltip('disable'); }
        });

      	//클릭시 툴팁 실행
        $('.cute_gray').on('click', function() {
            $(this).tooltip('enable').tooltip('open');
        });
    }) */
    
    /* 보험료 안내 버튼 */
    $(document).ready(function(){
    	
    	$("#lifeInfoMinus").hide("fast");
    	
    	/* 보험료안내 버튼 기능 Start */
    	//안내+ 버튼 선택시 안내- 버튼 호출 
    	$("#lifeInfoPlus").live("click",function(){
	    		var btnId = $(this).attr('id'); 
	    		if(btnId == "lifeInfoPlus"){
	    			$("#lifeInfoMinus").show("fast");
	    			$("#lifeInfoPlus").hide("fast");
	    		}
    	});
    	
    	//안내- 버튼 선택시 안내+ 버튼 호출
    	$("#lifeInfoMinus").live("click",function(){
    			var btnId = $(this).attr('id'); 
	    		if(btnId == "lifeInfoMinus"){
	    			$("#lifeInfoPlus").show("fast");
	    			$("#lifeInfoMinus").hide("fast");
	    		}
		});

    	//안내+ 선택시 화면 호출
    	$("#lifeInfoPlus").click(function(){
    		$("#infoLayer").show("fast");
    		$("#infoLayerMain").show("fast");
        });
    	
    	//안내- 선택시 화면 숨김
    	$("#lifeInfoMinus").click(function(){
    		$("#infoLayer").hide("fast");
    		$("#infoLayerMain").hide("fast");
        });
    	/* 보험료안내 버튼 기능 End */
    });
	
  //기본공제안내 안내 팝업 실행후 클릭시 창 닫음
    $(document).mouseup(function(e){
    	if(!$("#infoLayer div").is(e.target)&&$("#infoLayer div").has(e.target).length==0){
    		$("#infoLayer").fadeOut();
    		$("#infoLayerMain").fadeOut();
    		$("#lifeInfoMinus").hide("fast");
    		$("#lifeInfoPlus").show("fast");
    	}
    });
</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
	<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
	<input type="hidden" id="searchSabun" name="searchSabun" value="" />
	<input type="hidden" id="searchDpndntYn" name="searchDpndntYn" value="Y" />
	<input type="hidden" id="searchFamCd_s" name="searchFamCd_s" value="" />
	</form>
	<!-- Sample Ex&Image Start -->
    <div class="outer" style="display:none" id="infoLayerMain">
    	<table>
    		<tr>
    			<td style="padding:10px 5px 5px 5px;">
    				<div id="infoLayer"></div>
    			</td>
    		</tr>
    	</table>
    </div>
	<!-- Sample Ex&Image End -->
	<table border="0" cellpadding="0" cellspacing="0" class="outer">
	<colgroup>
		<col width="65%" />
		<col width="" />
	</colgroup>
	<tr>
		<td>
			<div class="sheet_title">
				<ul>
					<li class="txt">연금보험료공제</li>
				</ul>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="default yeaData1">
			<colgroup>
				<col width="10%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="15%" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="center"></th>
				<th class="center">국민연금</th>
				<th class="center">공무원연금</th>
				<th class="center">군인연금</th>
				<th class="center">교직원연금</th>
				<th class="center">별정우체국연금</th>
				<th class="center">합계</th>
			</tr>
			<tr>
				<th class="center">주(현)<br/>근무지</th>
				<td class="right"><input id="A030_01" name="A030_01" type="text" class="text w100p right transparent"  readonly/></td>
				<td class="right"><input id="A030_11" name="A030_11" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="A030_12" name="A030_12" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="A030_02" name="A030_02" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="A030_13" name="A030_13" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_row_1_1" name="sum_row_1_1" type="text" class="text w100p right transparent"  readonly /></td>
			</tr>
			<tr>
				<th class="center">종(전)<br/>근무지</th>
				<td class="right"><input id="pen_mon" name="pen_mon" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="etc_mon2" name="etc_mon2" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="etc_mon3" name="etc_mon3" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="etc_mon1" name="etc_mon1" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="etc_mon4" name="etc_mon4" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_row_1_2" name="sum_row_1_2" type="text" class="text w100p right transparent"  readonly /></td>
			</tr>
			<tr>
				<th class="center">전체</th>
				<td class="right"><input id="sum_col_1_1" name="sum_col_1_1" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_col_1_2" name="sum_col_1_2" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_col_1_3" name="sum_col_1_3" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_col_1_4" name="sum_col_1_4" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_col_1_5" name="sum_col_1_5" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_col_1_6" name="sum_col_1_6" type="text" class="text w100p right transparent"  readonly /></td>
			</tr>
			</table>
		</td>
		<td style="padding-left:5px;">
			<div class="sheet_title">
				<ul>
					<li class="txt">특별소득공제</li>
				</ul>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="default yeaData1">
			<colgroup>
				<col width="15%" />
				<col width="28%" />
				<col width="28%" />
				<col width="" />
			</colgroup>
			<tr>
				<th class="center"></th>
				<th class="center">건강보험</th>
				<th class="center">고용보험</th>
				<th class="center">합계</th>
			</tr>
			<tr>
				<th class="center">주(현)<br/>근무지</th>
				<td class="right"><input id="A040_03" name="A040_03" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="A040_04" name="A040_04" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_row_2_1" name="sum_row_2_1" type="text" class="text w100p right transparent"  readonly /></td>
			</tr>
			<tr>
				<th class="center">종(전)<br/>근무지</th>
				<td class="right"><input id="hel_mon" name="hel_mon" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="emp_mon" name="emp_mon" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_row_2_2" name="sum_row_2_2" type="text" class="text w100p right transparent"  readonly /></td>
			</tr>
			<tr>
				<th class="center">전체</th>
				<td class="right"><input id="sum_col_2_1" name="sum_col_2_1" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_col_2_2" name="sum_col_2_2" type="text" class="text w100p right transparent"  readonly /></td>
				<td class="right"><input id="sum_col_2_3" name="sum_col_2_3" type="text" class="text w100p right transparent"  readonly /></td>
			</tr>
			</table>
		</td>
	</tr>
	</table>

	<div class="sheet_title">
		<ul>
			<li class="txt">특별세액공제</li>
		</ul>
	</div>
	<div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">
                ※ 보장성 보험료
                <!-- <a href="javascript:yeaDataExpPopup('보험료', helpText, 270);" class="cute_gray authR"> 보험료안내</a> -->
                <!-- <a href = "#" class="cute_gray" id="cute_gray_authR" >보험료안내</a> -->
                <a href="#layerPopup" class="cute_gray" id="lifeInfoPlus"><b>보험료 안내+</b></a>
	            <a href="#layerPopup" class="cute_gray" id="lifeInfoMinus" style="display:none"><b>보험료 안내-</b></a>
            </li>
        </ul>
        </div>
    </div>
	<table border="0" cellpadding="0" cellspacing="0" class="default outer yeaData2">
		<colgroup>
			<col width="50%" />
			<col width="" />
		</colgroup>
		<tr>
			<th class="center">일반보장성보험료</th>
			<th class="center">장애인전용보장성보험료</th>
		</tr>
		<tr>
			<td class="right"><input id="A040_05" name="A040_05" type="text" class="text w50p right transparent"  readonly /> 원</td>
			<td class="right"><input id="A040_07" name="A040_07" type="text" class="text w50p right transparent"  readonly /> 원</td>
		</tr>
	</table>
	
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"></li>
			<li class="btn">		 	
			<a href="javascript:doAction2('Search');" class="basic authR">조회</a>
			<span id="btnDisplayYn05">
				<a href="javascript:doAction2('Insert');" class="basic authA">입력</a>			
<%if("Y".equals(adminYn)) {%>
			<span id="copyBtn">
			<a href="javascript:doAction2('Copy');" class="basic authA">복사</a>
			</span>
<%} %>			
				<a href="javascript:doAction2('Save');" class="basic authA">저장</a>
			</span>
			<a href="javascript:doAction2('Down2Excel');" class="basic authR">다운로드</a>
		 	
		</li>
		</ul>
	</div>
	</div>
	<div style="height:240px">
	<script type="text/javascript">createIBSheet("sheet2", "100%", "240px"); </script>
	</div>
	<span class="hide">
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
	</span>
</div>
</body>
</html>