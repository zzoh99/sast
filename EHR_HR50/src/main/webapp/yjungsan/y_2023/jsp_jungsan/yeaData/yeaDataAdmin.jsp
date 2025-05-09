<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html class="hidden"><head><title>자료등록</title>
<%@ include file="../common/include/session.jsp"%>
<%authPg = "A";%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%-- <%String orgAuthPg = request.getParameter("orgAuthPg");%> --%>
<%
String ssnGrpCd = (String)session.getAttribute("ssnGrpCd");
String ssnEnterCd = (String)session.getAttribute("ssnEnterCd");
%>
<script type="text/javascript">
<%-- var orgAuthPg = "<%=orgAuthPg%>"; --%>
var ssnGrpCd    = "<%=removeXSS(ssnGrpCd,'1')%>";
var ssnEnterCd  = "<%=removeXSS(ssnEnterCd,'1')%>";
var waitFlag	= false;
/* 담당자피드백 오픈여부 */
var feedbackYn = "N";
/* 특이사항 오픈여부 */
var specialYn = "N";

var feedBackMainShowYn = "N"; //피드백 메인 노출 여부

$(function() {
	$("#menuNm").val($(document).find("title").text());

    $("#searchGubunCd").change(function() {
    	doAction1("Search");
    });

});

/* 버튼 기능 */
$(document).ready(function(){
	//담당자피드백+ 버튼 숨기기
	$("#buttonMinus").hide();
	$("#buttonMinusNt").hide();

	/* 담당자 피드백 버튼 Start */
	//담당자피드백+ 버튼 선택시 과거 인적공제 현황- 버튼 호출
	$("#buttonPlus").live("click",function(){
   		var btnId = $(this).attr('id');
   		if(btnId == "buttonPlus"){
   			$("#buttonMinus").show();
   			$("#buttonPlus").hide();
   			$("#buttonPlusNt").show();
   			$("#buttonMinusNt").hide();
   			doAction1("Search");
   			feedbackYn = "Y";
   		}
	});

	//담당자피드백- 버튼 선택시 과거 인적공제 현황+ 버튼 호출
	$("#buttonMinus").live("click",function(){
		var btnId = $(this).attr('id');
   		if(btnId == "buttonMinus"){
   			$("#buttonPlus").show();
   			$("#buttonMinus").hide();
   			feedbackYn = "N";
   		}
	});

	//담당자피드백+ 선택시 화면 호출
	$("#buttonPlus").click(function(){
        $("#feedBackMain").show();
        $("#noticeInfoMain").hide();
        $("#div_insa_tab").css({'top':360});
        feedBackMainShowYn = "Y";
        doAction1("Search");
    });

	//담당자피드백- 선택시 화면 숨김
	$("#buttonMinus").click(function(){
        $("#feedBackMain").hide();
        $("#feedBackPrev").hide();
        $("#div_insa_tab").css({'top':125});
        feedBackMainShowYn = "N";
    });
	/* 담당자 피드백 버튼 End */

	/* 특이사항 버튼 Start */
	//특이사항+ 버튼 선택시 과거 인적공제 현황- 버튼 호출
	$("#buttonPlusNt").live("click",function(){
   		var btnId = $(this).attr('id');
   		if(btnId == "buttonPlusNt"){
   			$("#buttonMinusNt").show();
   			$("#buttonPlusNt").hide();
   			$("#buttonPlus").show();
   			$("#buttonMinus").hide();
   			doAction2("Search");
   			specialYn = "Y";
   		}
	});

	//특이사항- 버튼 선택시 과거 인적공제 현황+ 버튼 호출
	$("#buttonMinusNt").live("click",function(){
		var btnId = $(this).attr('id');
   		if(btnId == "buttonMinusNt"){
   			$("#buttonPlusNt").show();
   			$("#buttonMinusNt").hide();
   			specialYn = "N";
   		}
	});

	//특이사항+ 선택시 화면 호출
	$("#buttonPlusNt").click(function(){
        $("#noticeInfoMain").show();
        $("#feedBackMain").hide();
        $("#feedBackPrev").hide();
        $("#div_insa_tab").css({'top':325});
        feedBackMainShowYn = "N";

    });

	//특이사항- 선택시 화면 숨김
	$("#buttonMinusNt").click(function(){
        $("#noticeInfoMain").hide();
        $("#div_insa_tab").css({'top':125});
    });
	/* 특이사항 버튼 End */

});

//기본자료 공통 쉬트
function createCommonSheet() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
		{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
		{Header:"년도",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
		{Header:"정산구분",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"사번",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"정산항목코드",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adj_element_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"자료여부",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"data_yn",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
		{Header:"자료금액",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"data_mon",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
		{Header:"자료인원",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"data_cnt",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
		{Header:"입력금액",			Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"input_mon",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
		{Header:"사업장코드",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"business_place_cd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(commonSheet, initdata);commonSheet.SetEditable(false);commonSheet.SetVisible(false);commonSheet.SetCountPosition(4);
}

//기본공제,추가공제 조회
function doSearchCommonSheet() {
	commonSheet.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectCommonSheetList", $("#mainForm").serialize() );
}

//기본공제,추가공제 추가
function doInsertCommonSheet(elementCd, inputMonValue) {
	var elementCdIdx = commonSheet.FindText("adj_element_cd", elementCd);

	if(elementCdIdx == -1) {
		var newRow = commonSheet.DataInsert(0);
		commonSheet.SetCellValue( newRow, "adj_element_cd", elementCd ) ;
		commonSheet.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() ) ;
		commonSheet.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() ) ;
		commonSheet.SetCellValue( newRow, "sabun", $("#searchSabun").val() ) ;
		commonSheet.SetCellValue( newRow, "input_mon", inputMonValue ) ;
	} else {
		commonSheet.SetCellValue(elementCdIdx,"input_mon", inputMonValue) ;
	}
}

//기본공제,추가공제 저장
function doSaveCommonSheet() {
	if(!checkClose())return;

	commonSheet.DoSave( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=saveCommonSheet" , $("#mainForm").serialize());
}

//조회 후 에러 메시지
function commonSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		alertMessage(Code, Msg, StCode, StMsg);

		if(Code == 1) {
			getIframeContent(newIframe[0]).sheetSet();
		}
	} catch (ex) {
	}
}

//저장 후 메시지
function commonSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		alertMessage(Code, Msg, StCode, StMsg);
		getYearDefaultInfoObj();
		if(Code == 1) {
			doSearchCommonSheet();
		}
	} catch(ex) {
	}
}

function getIframeContent(ifrm) {
	return ifrm.contentWindow || ifrm.contentDocument;
}

$(function() {
		var managerEditable = "1";
		var employeeEditable = "0";

		if($("#searchAuthPg").val() == "R") {
			var managerEditable = "0";
			var employeeEditable = "1";
		}

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
   			{Header:"No",		        Type:"Seq",			Hidden:0,	Width:45,	Align:"Center",		ColMerge:1,	SaveName:"sNo" },
   			{Header:"삭제",		        Type:"DelCheck",	Hidden:1,	Width:45,	Align:"Center",		ColMerge:1,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",				Type:"Status",		Hidden:1,	Width:45,	Align:"Center",		ColMerge:1,	SaveName:"sStatus",	Sort:0 },
            {Header:"대상연도", 			Type:"Text",     	Hidden:1, 	Width:50,	Align:"Center",    	ColMerge:1, SaveName:"work_yy",  		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:4 },
            {Header:"정산구분", 			Type:"Text",     	Hidden:1,  	Width:50,  	Align:"Center",    	ColMerge:1, SaveName:"adjust_type",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:1 },
            {Header:"사번", 				Type:"Text",     	Hidden:1, 	Width:50,  	Align:"Center",    	ColMerge:1, SaveName:"sabun",  			KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:13 },
            {Header:"구분", 				Type:"Combo",    	Hidden:0,  	Width:80,  	Align:"Center",    	ColMerge:1, SaveName:"gubun_cd",  		KeyField:1,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:35 },
            {Header:"구분명", 				Type:"Combo",    	Hidden:1,  	Width:80,  	Align:"Center",    	ColMerge:1, SaveName:"gubun_nm",		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:35 },
            {Header:"확인필요건수", 			Type:"Text",     	Hidden:0,  	Width:70,  	Align:"Center",    	ColMerge:1, SaveName:"detail_cnt",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:20 },
            {Header:"답변여부", 			Type:"Combo",     	Hidden:0,  	Width:50,  	Align:"Center",    	ColMerge:1, SaveName:"reply_yn",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:20, DefaultValue:"N" },
            {Header:"담당자 FeedBack",		Type:"Text",     	Hidden:0,  	Width:200,  Align:"Left",    	ColMerge:1, SaveName:"manager_note",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:managerEditable,	InsertEdit:0,   EditLen:1000, MultiLineText:1 },
            {Header:"직원 FeedBack",   	Type:"Text",     	Hidden:0,  	Width:200,  Align:"Left",    	ColMerge:1, SaveName:"employee_note", 	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:employeeEditable,   InsertEdit:0,   EditLen:1000, MultiLineText:1 },
            {Header:"바로가기",        	Type:"Html",     	Hidden:0,  	Width:50,  Align:"Center",    	ColMerge:1, SaveName:"btn_link",   KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, MultiLineText:1, Cursor:"pointer" }

        ];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetCountPosition(4);

        var comboText = ["전체","일반","연금보혐료","보험료","의료비","교육비","주택자금","기부금","개인연금저축","주택마련저축","신용카드","기타"];
        var comboCode = ["","COMM","PENS","INSU","MEDI","EDUC","RENT","DONA","SAVE","HOUS","CARD","ETCC"];

		sheet1.SetColProperty("gubun_cd", {ComboText:comboText.join("|") , ComboCode:comboCode.join("|")} );
		sheet1.SetColProperty("gubun_nm", {ComboText:comboText.join("|") , ComboCode:comboCode.join("|")} );
		sheet1.SetColProperty("reply_yn", {ComboText:"답변완료|미답변", ComboCode:"Y|N"} );

		sheet1.SetSendComboData(0,"gubun_nm","Text");
		sheet1.SetEditEnterBehavior("newline");
		sheet1.SetBasicImeMode(1);

		$(comboCode).each(function(index){
			var option = "<option value='"+comboCode[index]+"'>"+comboText[index]+"</option>";
			$("#searchGubunCd").append(option);
		});


	    /* 특이사항 */
	    var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0, SaveName:"sNo" },
	        {Header:"삭제",		Type:"<%=sDelTy%>",   Hidden:<%=sDelHdn%>, 	Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0, SaveName:"sDelete" },
	        {Header:"상태",		Type:"<%=sSttTy%>",   Hidden:<%=sSttHdn%>, 	Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0, SaveName:"sStatus" },
	        {Header:"대상년도",		Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"work_yy",  	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
	        {Header:"정산구분",		Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"adjust_type",	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"사원번호",		Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"sabun",  		KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
	        {Header:"TIP내용",	Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"tip_text",  	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
	        {Header:"CLEAR여부",	Type:"Text",     	Hidden:0,  Width:70,  Align:"Center",    ColMerge:0,   SaveName:"clear_yn",  	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }
	    ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(false);sheet2.SetCountPosition(4);

	 	// 이전 피드백 리스트
        var initdata3 = {};
        initdata3.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
        initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata3.Cols = [
   			{Header:"No",		        Type:"Seq",			Hidden:0,	Width:45,	Align:"Center",		ColMerge:1,	SaveName:"sNo" },
            {Header:"사번", 				Type:"Text",     	Hidden:1, 	Width:50,  	Align:"Center",    	ColMerge:1, SaveName:"sabun",  			KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:13 },
            {Header:"구분", 				Type:"Combo",    	Hidden:0,  	Width:80,  	Align:"Center",    	ColMerge:1, SaveName:"gubun_cd",  		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:35 },
            {Header:"문의일시",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,	SaveName:"employee_chkdate",KeyField:0,	  CalcLogic:"",   Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
            {Header:"답변일시",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,	SaveName:"manager_chkdate",KeyField:0,	  CalcLogic:"",   Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
            {Header:"담당자 FeedBack",		Type:"Text",     	Hidden:0,  	Width:200,  Align:"Left",    	ColMerge:1, SaveName:"manager_note",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,	InsertEdit:0,   EditLen:1000, MultiLineText:1 },
            {Header:"직원 FeedBack",   	Type:"Text",     	Hidden:0,  	Width:200,  Align:"Left",    	ColMerge:1, SaveName:"employee_note", 	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, MultiLineText:1 }

        ];IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable(false);sheet3.SetCountPosition(0);

        sheet3.SetColProperty("gubun_cd", {ComboText:comboText.join("|") , ComboCode:comboCode.join("|")} );
        sheet3.SetFocusAfterProcess(0);
        
        // 개인별 오류검증 내역
        var initdata4 = {};
		initdata4.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata4.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"대상년도",	Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"사번",		Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"구분",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"chk_gubun",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"내용",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"chk_text",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500, ToolTip:1, MultiLineText: 1, EnterMode: 1, Wrap: 1  },
			{Header:"결과유형\n(경고,확인필요 : 오류 X)\n(오류: 신고불가)",		Type:"Combo",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"chk_type",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"순서",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }

        ];IBS_InitSheet(sheet4, initdata4); sheet4.SetEditable(true); sheet4.SetCountPosition(4);
        
        var chkTypeList = new Array(3);
	    chkTypeList[0] = "경고|오류|확인필요";
	    chkTypeList[1] = "W|E|L";
	    chkTypeList[2] = "<option value=''>전체</option>"
						+ "<option value='W'>경고</option>"
						+ "<option value='E'>오류</option>"
						+ "<option value='L'>확인필요</option>"
	    ;

    	sheet4.SetColProperty("chk_type", {ComboText: "|" + chkTypeList[0], ComboCode: "|" + chkTypeList[1]} );

        $(window).smartresize(sheetResize); sheetInit();


	});

/*Sheet Action*/
function doAction1(sAction) {
	switch (sAction) {
	case "Search": 		//조회
		sheet1.DoSearch( "<%=jspPath%>/yeaData/yearFeedbackPopupRst.jsp?cmd=selectYeaFeedbackPopupList", $("#mainForm").serialize());
		break;
    case "Save":
    	sheet1.DoSave( "<%=jspPath%>/yeaData/yearFeedbackPopupRst.jsp?cmd=saveYeaFeedbackPopup", $("#mainForm").serialize());
    	break;
    case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet1);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
		sheet1.Down2Excel(param);
		break;
	}
}

//데이타 리턴
function setValue() {

		if(sheet2.RowCount() < 1){
			doAction2("Insert");
		}

		if($("#clearYn").is(":checked") == true){
			sheet2.SetCellValue(sheet2.GetSelectRow(), "clear_yn", "Y");
		} else {
			sheet2.SetCellValue(sheet2.GetSelectRow(), "clear_yn", "N");
		}
		sheet2.SetCellValue(1, "tip_text", $("#tipText").val()) ;
		doAction2("Save");
}

/*Sheet Action*/
function doAction2(sAction) {
	switch (sAction) {
	case "Search": 		//조회
		sheet2.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectUnusualPopupList", $("#mainForm").serialize() );
		break;
    case "Save":
    	sheet2.DoSave( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=saveUnusualPopup", $("#mainForm").serialize());
    	break;
    case "Insert":
    	var newRow = sheet2.DataInsert(0) ;
    	sheet2.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() ) ;
    	sheet2.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() ) ;
    	sheet2.SetCellValue( newRow, "sabun", $("#searchSabun").val() ) ;
    	break;
	}
}

/*Sheet Action*/
function doAction4(sAction) {
	switch (sAction) {
	case "Search": 		//조회
		sheet4.DoSearch( "<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectErrChkPerMgr", $("#mainForm").serialize());
		break;
    case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet2);
		var param  = {DownCols: downcol, SheetDesign: 1, Merge: 1, menuNm: $(document).find("title").text()};
		sheet4.Down2Excel(param);
		break;
	}
}

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		alertMessage(Code, Msg, StCode, StMsg);
		if(Code == 1) {
			doAction1("Search");
		}
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

//저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		alertMessage(Code, Msg, StCode, StMsg);
		$("#noticeInfoMain").hide();
		$("#div_insa_tab").css({'top':125});
		$("#buttonPlusNt").show();
		$("#buttonMinusNt").hide();

		checkClearYn();
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		for(var i = 1; i < sheet1.RowCount()+1; i++) {
            sheet1.SetCellValue(i,"btn_link","<a href=\"javascript:fn_moveLink('"+i+"')\" class='basic btn-white'>바로가기</a>");

            var managerNote = sheet1.GetCellValue(i,"manager_note");
            var employeeNote = sheet1.GetCellValue(i,"employee_note");

            if($.trim(managerNote).length == 0 && $.trim(employeeNote).length == 0) {
            	sheet1.SetCellValue(i,"reply_yn","");
            }

            sheet1.SetCellValue(i,"sStatus","R");
        }

		if(Code == 1) {
			feedbackImg();
		}

		sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

//클릭시 발생
function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
	try{
		if(sheet1.GetSelectRow() > 0) {
			if(OldRow != NewRow && feedBackMainShowYn == 'Y'){
				var param = "searchWorkYy="+sheet1.GetCellValue(NewRow, "work_yy")
				+"&searchAdjustType="+sheet1.GetCellValue(NewRow, "adjust_type")
				+"&searchSabun="+sheet1.GetCellValue(NewRow, "sabun")
				+"&searchGubunCd="+sheet1.GetCellValue(NewRow, "gubun_cd");

				sheet3.DoSearch( "<%=jspPath%>/yeaData/yearFeedbackPopupRst.jsp?cmd=selectYeaFeedbackPopupHisList", param, 1 );
			}
		}

	}catch(ex){
		alert("OnClick Event Error : " + ex);
	}
}

//조회 후 에러 메시지
function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if(sheet3.RowCount() > 0) {
			showFeedBackPrev();
			sheetResize();
		} else {
			hideFeedBackPrev();
		}

	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

//조회 후 에러 메시지
function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		alertMessage(Code, Msg, StCode, StMsg);
		
		//오류건에 대해서 노란색줄 표시와 빨간색 폰트 처리
		for(var i = 1; i < sheet4.RowCount()+1; i++){
			var chkType = sheet4.GetCellValue(i, "chk_type");
			if(chkType == "E"){
				sheet4.SetRowBackColor(i, "#FFFFCC");
				sheet4.SetCellFontColor(i, "chk_gubun", "#EE0000");	//구분
				sheet4.SetCellFontColor(i, "chk_type", "#EE0000");	//결과유형
			}
		}
		
		sheetResize();
	} catch(ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

function hideFeedBackPrev() {
	$("#div_insa_tab").css({'top':360});
	$("#feedBackPrev").hide();
}

function showFeedBackPrev() {
	$("#div_insa_tab").css({'top':510});
	$("#errChkPrev").hide();
	$("#feedBackPrev").show();
}

function showErrChkPrev() {
	$("#div_insa_tab").css({'top':350});
	$("#feedBackPrev").hide();
	$("#errChkPrev").show();
}

function hideErrChkPrev() {
	$("#div_insa_tab").css({'top':124});
	$("#errChkPrev").hide();
}

function fn_moveLink(Row) {
	var gubunCd = sheet1.GetCellValue(Row, 'gubun_cd');

	    switch(gubunCd){

	    case "COMM": iframeIdx = 0; break;
	    case "PENS": iframeIdx = 3; break;
	    case "INSU": iframeIdx = 3; break;
	    case "MEDI": iframeIdx = 10; break;
	    case "EDUC": iframeIdx = 11; break;
	    case "RENT": iframeIdx = 4; break;
	    case "DONA": iframeIdx = 12; break;
	    case "SAVE": iframeIdx = 6; break;
	    case "HOUS": iframeIdx = 6; break;
	    case "CARD": iframeIdx = 7; break;
	    case "ETCC": iframeIdx = 0; break;
	}

	//마감체크하여 마감되었으면 권한을 R로 넘겨서 수정 못하게 막음
	var authPg = (getYeaCloseYn()=="Y")?"R":"A";
	//원래권한으로 이페이지는 항상 관리자용으로 A이다.
	var orgAuthPg = "<%=authPg%>";

	if(iframeIdx == 0) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddr.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 1) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPer.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 2) {
		// ----------------------------------------------------
		// 20240109 브라우저 버전에 따라 pdf업로드 제어 Start
	    var _ua = navigator.userAgent;
		
		var trident = _ua.match(/Trident\/(\d.\d)/i);
		if( trident != null )
		{
			if( trident[1] == "7.0" || trident[1] == "6.0" || trident[1] == "5.0" || trident[1] == "4.0" ) //IE 11,10,9,8 
			{
				newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf_IE.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
			}
		}
		
		if( navigator.appName == 'Microsoft Internet Explorer' ) //IE 7... 
		{ 
			newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf_IE.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
		}
		else
		{
			newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
		}

		// 20240109 브라우저 버전에 따라 pdf업로드 제어 End
		// ----------------------------------------------------
		
	} else if(iframeIdx == 3) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIns.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 4) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 5) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou2.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 6) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHouSav.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 7) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataCards.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 8) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEtc.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 9) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPen.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 10) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataMed.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 11) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEdu.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 12) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataDon.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 13) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataTax.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 14) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIncomeEach.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 15) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataBefCom.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 16) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPrtView.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 17) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataResultPdf.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	} else if(iframeIdx == 18) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddFile.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
    }

	tabObj.tabs( "option", "active", iframeIdx );

	this.focus();

}

function fnIncomeCalc(){
	//마감체크하여 마감되었으면 권한을 R로 넘겨서 수정 못하게 막음
	var authPg = (getYeaCloseYn()=="Y")?"R":"A";
	//원래권한으로 이페이지는 항상 관리자용으로 A이다.
	var orgAuthPg = "<%=authPg%>";
	//소득공제서 버튼 선택여부
	var incomeParam = "Y";

	newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPrtView.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg+"&incomeParam="+incomeParam);
	tabObj.tabs( "option", "active", 16 );
	this.focus();
}

//조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		alertMessage(Code, Msg, StCode, StMsg);

		if(Code == 1 && sheet2.RowCount() > 0) {
			if(sheet2.GetCellValue(sheet2.GetSelectRow(), "clear_yn") == "Y"){
				 $(':checkbox[name=clearYn]').attr('checked', true);
			} else {
				$(':checkbox[name=clearYn]').attr('checked', false);
			}
			$("#tipText").val(sheet2.GetCellValue(sheet2.GetSelectRow(), "tip_text")) ;
		} else {
			$(':checkbox[name=clearYn]').attr('checked', false);
			$("#tipText").val("") ;
		}
		sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

function linkFeedbackPopup(window, gubun_cd){

		// 링크 이동 후 창 닫기
		//window.close();

		//var comboText = ["전체","일반","연금보혐료","보험료","의료비","교육비","주택자금","기부금","개인연금저축","주택마련저축","신용카드","기타"];
        //var comboCode = ["","COMM","PENS","INSU","MEDI","EDUC","RENT","DONA","SAVE","HOUS","CARD","ETCC"];

	    switch(gubun_cd){
            case "COMM": iframeIdx = 0; break;
            case "PENS": iframeIdx = 3; break;
            case "INSU": iframeIdx = 3; break;
            case "MEDI": iframeIdx = 10; break;
            case "EDUC": iframeIdx = 11; break;
            case "RENT": iframeIdx = 4; break;
            case "DONA": iframeIdx = 12; break;
            case "SAVE": iframeIdx = 6; break;
            case "HOUS": iframeIdx = 6; break;
            case "CARD": iframeIdx = 7; break;
            case "ETCC": iframeIdx = 0; break;
	    }

	    if(checkClearYn()) {
            //마감체크하여 마감되었으면 권한을 R로 넘겨서 수정 못하게 막음
            var authPg = (getYeaCloseYn()=="Y")?"R":"A";
            //원래권한으로 이페이지는 항상 관리자용으로 A이다.
            var orgAuthPg = "<%=authPg%>";
            if(ssnEnterCd == "HENT" && ssnGrpCd == "79"){
            	if(iframeIdx == 0) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddr.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 1) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPer.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 2) { 
                	// ----------------------------------------------------
        			// 20240109 브라우저 버전에 따라 pdf업로드 제어 Start
        		    var _ua = navigator.userAgent;
        			
        			var trident = _ua.match(/Trident\/(\d.\d)/i);
        			if( trident != null )
        			{
        				if( trident[1] == "7.0" || trident[1] == "6.0" || trident[1] == "5.0" || trident[1] == "4.0" ) //IE 11,10,9,8 
        				{
        					newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf_IE.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
        				}
        			}
        			
        			if( navigator.appName == 'Microsoft Internet Explorer' ) //IE 7... 
        			{ 
        				newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf_IE.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
        			}
        			else
        			{
        				newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
        			}

        			// 20240109 브라우저 버전에 따라 pdf업로드 제어 End
        			// ----------------------------------------------------
                } else if(iframeIdx == 3) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIns.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 4) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 5) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou2.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 6) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHouSav.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 7) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataCards.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 8) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEtc.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 9) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPen.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 10) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataMed.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 11) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEdu.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 12) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataDon.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 13) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataTax.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 14) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIncomeEach.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 15) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataBefCom.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 16) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPrtView.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 17) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddFile.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                }
            }else{
            	if(iframeIdx == 0) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddr.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 1) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPer.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 2) {
                	// ----------------------------------------------------
        			// 20240109 브라우저 버전에 따라 pdf업로드 제어 Start
        		    var _ua = navigator.userAgent;
        			
        			var trident = _ua.match(/Trident\/(\d.\d)/i);
        			if( trident != null )
        			{
        				if( trident[1] == "7.0" || trident[1] == "6.0" || trident[1] == "5.0" || trident[1] == "4.0" ) //IE 11,10,9,8 
        				{
        					newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf_IE.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
        				}
        			}
        			
        			if( navigator.appName == 'Microsoft Internet Explorer' ) //IE 7... 
        			{ 
        				newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf_IE.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
        			}
        			else
        			{
        				newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
        			}

        			// 20240109 브라우저 버전에 따라 pdf업로드 제어 End
        			// ----------------------------------------------------
                } else if(iframeIdx == 3) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIns.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 4) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 5) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou2.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 6) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHouSav.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 7) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataCards.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 8) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEtc.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 9) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPen.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 10) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataMed.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 11) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEdu.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 12) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataDon.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 13) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataTax.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 14) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIncomeEach.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 15) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataBefCom.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 16) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPrtView.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 17) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataResultPdf.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 18) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddFile.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                }
            }
        }

	    tabObj.tabs( "option", "active", iframeIdx );

	    this.focus();
	}
	//FAQ 팝업
	function openFaqPop(){
		var inputCdType = "";
        if(ssnEnterCd == "HENT" && ssnGrpCd == "79"){
        	if(iframeIdx == 0) { inputCdType = "10";
            } else if(iframeIdx == 1) { inputCdType = "20";
            } else if(iframeIdx == 2) { inputCdType = "30";
            } else if(iframeIdx == 3) { inputCdType = "40";
            } else if(iframeIdx == 4) { inputCdType = "50";
            } else if(iframeIdx == 5) {
            } else if(iframeIdx == 6) { inputCdType = "60";
            } else if(iframeIdx == 7) { inputCdType = "70";
            } else if(iframeIdx == 8) { inputCdType = "80";
            } else if(iframeIdx == 9) { inputCdType = "90";
            } else if(iframeIdx == 10) { inputCdType = "100";
            } else if(iframeIdx == 11) { inputCdType = "110";
            } else if(iframeIdx == 12) { inputCdType = "120";
            } else if(iframeIdx == 13) { inputCdType = "130";
            } else if(iframeIdx == 14) { inputCdType = "140";
            } else if(iframeIdx == 15) { inputCdType = "150";
            } else if(iframeIdx == 16) { inputCdType = "160";
            } else if(iframeIdx == 17) { inputCdType = "180";
            } else inputCdType = "190";
        }else{
        	if(iframeIdx == 0) { inputCdType = "10";
            } else if(iframeIdx == 1) { inputCdType = "20";
            } else if(iframeIdx == 2) { inputCdType = "30";
            } else if(iframeIdx == 3) { inputCdType = "40";
            } else if(iframeIdx == 4) { inputCdType = "50";
            } else if(iframeIdx == 5) {
            } else if(iframeIdx == 6) { inputCdType = "60";
            } else if(iframeIdx == 7) { inputCdType = "70";
            } else if(iframeIdx == 8) { inputCdType = "80";
            } else if(iframeIdx == 9) { inputCdType = "90";
            } else if(iframeIdx == 10) { inputCdType = "100";
            } else if(iframeIdx == 11) { inputCdType = "110";
            } else if(iframeIdx == 12) { inputCdType = "120";
            } else if(iframeIdx == 13) { inputCdType = "130";
            } else if(iframeIdx == 14) { inputCdType = "140";
            } else if(iframeIdx == 15) { inputCdType = "150";
            } else if(iframeIdx == 16) { inputCdType = "160";
            } else if(iframeIdx == 17) { inputCdType = "170";
            } else if(iframeIdx == 18) { inputCdType = "180";
            } else inputCdType = "190";        	
        }

		var args 	= new Array();
		args["searchWorkYy"]		= $("#searchWorkYy").val() ;
		args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)
		args["searchCdType"]	= inputCdType ;  // FAQ 업무구분

		if(!isPopup()) {return;}
		pGubun = "yeaCalcCreFaqPopup";
		var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCreFaqPopup.jsp?authPg=<%=authPg%>",args,"800","760");

	}
</script>
</head>
<body class="bodywrap">
<input type="hidden" id="defTabWidth" name="defTabWidth" />
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%; z-index:99;"></div>
	<div class="wrapper">
		<%@ include file="../common/include/employeeHeaderYtax.jsp"%>
		<form id="mainForm" name="mainForm">
		<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
		<input type="hidden" id="searchSabun" name="searchSabun" value="" />
		<input type="hidden" id="searchRegNo" name="searchRegNo" value="" />
		<input type="hidden" id="inputStatus" name="inputStatus" value="" />
		<input type="hidden" id="searchAuthPg" name="searchAuthPg" value="A" />
		<input type="hidden" id="searchTemp" name="searchTemp" value="" />
		<input type="hidden" id="paytotMonTemp" name="paytotMonTemp" value="" />
		<input type="hidden" id="searchBusinessCd" name="searchBusinessCd" value="" />
		<input type="hidden" id="menuNm" name="menuNm" value="" />
		
		<div class="sheet_search type2 outer" style="margin-top:8px; ">
			<div class="clearfix">
				<div class="float-left">
					<span name="spanYy" id="spanYy"></span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:showIframe(); doAction2('Search'); doAction1('Search'); getTotPay();" class="box"></select>
					<a href="javascript:void(0);" class="basic btn-white out-line ico-mark" id="buttonPlusNt"><b>특이사항+</b></a>
       				<a href="javascript:void(0);" class="basic btn-white out-line ico-mark" id="buttonMinusNt" style="display:none"><b>특이사항-</b></a>
					<a href="javascript:void(0);" class="basic btn-white out-line ico-bubble" id="buttonPlus"><b>담당자 피드백+</b></a>
       				<a href="javascript:void(0);" class="basic btn-white out-line ico-bubble" id="buttonMinus" style="display:none"><b>담당자 피드백-</b></a>
				</div>
				<div class="float-right">
					<div class="inner" id="div_button">
						<div style="white-space:nowrap;overflow:hidden;">
						<ul>
							<li class="right">
								<span id="span_paytotMonView" style="display:none;"></span>
								<span id="paytotMonViewYn"><a href="javascript:paytotMonView();" class="basic btn-red-outline">총급여확인</a></span>
								<span id="yeaCalcProcPop"><a href="javascript:openProcessStatus();" class="basic btn-white ico-popup">작업현황</a></span>
								<span id="yeaCalcCreFaqPopup"><a href="javascript:openFaqPop();" class="basic btn-white ico-popup">FAQ</a></span>
								<span id="spanMagam" style="display:none;"><a href="javascript:doAction('InputClose');" class="basic ico-finish btn-blue">담당자마감</a></span>
								<span id="spanMagamCancel" style="display:none;"><a href="javascript:doAction('CancelClose');" class="basic ico-finish btn-blue selected">담당자마감취소</a></span>
							</li>
						</ul>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- 담당자피드백 Start -->
		<div class="outer" id="feedBackMain" style="display:none">
			<div class="sheet_title">
				<ul>
		            <li class="txt">담당자-임직원 FeedBack</li>
		            <li class="btn">
		              <span>구분</span>
		              <select id="searchGubunCd" name="searchGubunCd"></select>
		              <a href="javascript:doAction1('Search')" class="basic">조회</a>
		              <a href="javascript:doAction1('Save')" class="basic btn-save">저장</a>
		              <a href="javascript:doAction1('Down2Excel')" class="basic btn-download">다운로드</a>
		            </li>
		        </ul>
		     </div>
		     <script type="text/javascript" >createIBSheet("sheet1", "100%", "200px"); </script>
		</div>

		<!-- 특이사항 Start -->
		<div id="noticeInfoMain" style="display:none">
			<div class="outer" id="">
				<div class="sheet_title">
					<ul>
						<li class="txt">특이사항</li>
						<li class="btn"><a href="javascript:setValue();" class="basic btn-save authA">저장</a></li>
					</ul>
				</div>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="default outer">
				<tr>
					<th>CLEAR여부</th>
					<td class="left"><input type="checkbox" class="checkbox" name="clearYn" id="clearYn" ></td>
				</tr>
				<tr>
					<th>TIP 내용</th>
					<td class="left"><textarea id="tipText" name="tipText" rows="10" class="text w100p" maxlength="4000"></textarea></td>
				</tr>
			</table>
		</div>
		<!-- 특이사항 End -->
		</form>
		<div class="hide">
			<script type="text/javascript">createIBSheet("sheet2", "100%", "200px"); </script>
		</div>

		<!-- 이전 피드백 Start -->
	    <div class="outer" id="feedBackPrev" style="display:none;">
			<div class="sheet_title">
				<ul>
		            <li class="txt">이전 FeedBack</li>
		            <li class="btn"><a href="javascript:hideFeedBackPrev();" class="basic">닫기</a></li>
		        </ul>
		     </div>
		     <script type="text/javascript">createIBSheet("sheet3", "100%", "110px"); </script>
		</div>
		<!-- 이전 피드백 End -->
		
		<!-- 개인별 오류검증내역 Start -->
	    <div class="outer" id="errChkPrev" style="display:none;">
			<div class="sheet_title">
				<ul>
		            <li class="txt">개인별 오류검증내역 <span class="blue">※ 결과유형 중, 오류 건의 경우 조치 후 마감 가능하며, 그 외 유형은 등록된 자료가 이상이 없다면 마감처리가 가능합니다.</span></li>
		            <li class="btn"><a href="javascript:hideErrChkPrev();" class="basic">오류내역 닫기</a></li>
		        </ul>
		     </div>
		     <script type="text/javascript">createIBSheet("sheet4", "100%", "200px"); </script>

		</div>
		<!-- 개인별 오류검증내역 End -->

		<div class="insa_tab" style="top:125px;" id="div_insa_tab">
			<div id="tabs" class="tab"><ul></ul></div>
		</div>
		<div id="tabs" class="tab"><ul></ul></div>
	</div>
	<span class="hide">
		<script type="text/javascript">createIBSheet("commonSheet", "100%", "100%"); </script>
	</span>
	<!-- <div id="div_header_view" class="right" style="position:absolute; top:107px; width:100%;" >
		<a href="javascript:headerView('hide');">▲</a>
	 	<a href="javascript:headerView('show');">▼</a>
	</div> -->
</body>

<script type="text/javascript">
	var newIframe;
	var oldIframe;
	var iframeIdx;
	var tabObj;
	var actionType;	//정산타입 (1.연말정산, 3.퇴직정산)
	var paytotMonStr; //총급여
	var paytotMonTemp; //총급여
	var yeaMonShowYn; //총급여 확인 버튼 보여주기 유무 정보에 따라 컨트롤
	var payActionCd; //연말정산코드
	var payActionNm; //연말정산코드
	var orgAuthPg = "<%=authPg%>";

	var scrollRange = 60;

	$(function() {
		$("#searchSabun").val( $("#searchUserId").val() ) ;
		$("#searchRegNo").val( $("#searchRegNo_").val() ) ;

		//기준년도 조회
		//var baseYear = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEAREND_YY", "queryId=getSystemStdData",false).codeList;
		$("#searchWorkYy").val("<%=yeaYear%>") ;
		$("#spanYy").text( $("#searchWorkYy").val() ) ;
		
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "");
		$("#searchAdjustType").html(adjustTypeList[2]);
		//$("#searchAdjustType_header").html(adjustTypeList[2]);
		
		// 헤더에서 설정한 정산구분 값 세팅
		//setAdjustType();

		tabObj = $( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				if( -1 < ui.oldTab.index() ) {
					try{
						if( $(ui.oldPanel).find('iframe')[0].contentWindow.sheetChangeCheck() ) {
							if ( !confirm("현재 화면에서 저장되지 않은 내역이 있습니다.\n\n무시하고 이동하시겠습니까? ") ) {
								return false;
							}
						}
					} catch(e) {}
				}

				iframeIdx = ui.newTab.index();
				newIframe = $(ui.newPanel).find('iframe');
				oldIframe = $(ui.oldPanel).find('iframe');
				showIframe();
			}
		});

		createCommonSheet();
		createTabFrame();

		getTotPay();//총급여 조회

		//총급여 옵션이 Y이면 총급여 버튼 보여준다.
	    if( yeaMonShowYn == "Y"){
	    	$("#paytotMonViewYn").show() ;
	    }else if(yeaMonShowYn == "A"){
	        if(orgAuthPg == "A") {
	        	$("#paytotMonViewYn").show() ;
	        }else{
	        	$("#paytotMonViewYn").hide() ;
	        }
	    }else{
	    	$("#paytotMonViewYn").hide() ;
	    }

	    getActionCd(); //연말정산 코드 가져오기
		getBizPlCd();  //사업장코드가져오기

	});

	function paytotMonView() {
		//총급여 닫기
		$("#span_paytotMonView").show();
		if(paytotMonStr != ""){
			$("#span_paytotMonView").html("<a href='javascript:paytotMonViewClose()' ><span class='under-line'>닫기</span></a>&nbsp;<span class='no-bold'>"+paytotMonStr+"원</span>&nbsp;");
		//총급여 열기
		} else {
			alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
            return;
		}
	}

	function getTotPay() {//총급여 조회
	    var param2 = "searchWorkYy="+$("#searchWorkYy").val();
	    param2 += "&searchAdjustType="+$("#searchAdjustType").val();
	    param2 += "&searchSabun="+$("#searchSabun").val();
	    param2 += "&queryId=getYeaDataPayTotMon";

	    var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=1",false);
	    paytotMonStr = nvl(result2.Data.paytot_mon,"");
	    paytotMonTemp = nvl(result2.Data.paytot_mon2,"");
	    $("#paytotMonTemp").val(paytotMonTemp) ;
	    $("#span_paytotMonView").html("<a href='javascript:paytotMonViewClose()' ><span class='under-line'>닫기</span></a>&nbsp;<span class='no-bold'>"+paytotMonStr+"원</span>&nbsp;");

  	    //총급여 확인 버튼 유무
        var result3 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
        yeaMonShowYn = nvl(result3[0].code_nm,"");
	}

	//[총급여확인] 닫기
    function paytotMonViewClose(){
    	$("#span_paytotMonView").hide();
    }

	// 탭 생성
	function createTabFrame() {
		if(ssnEnterCd == "HENT" && ssnGrpCd == "79"){
	        tabObj.find(".ui-tabs-nav")
	        .append("<li><a href='#tabs-1' id='tabs1'>기본_주소사항</a></li>")
	        .append("<li><a href='#tabs-2' id='tabs2'>인적공제</a></li>")
	        .append("<li><a href='#tabs-3' id='tabs3'>PDF등록</a></li>")
	        .append("<li><a href='#tabs-4' id='tabs4'>보험료</a></li>")
	        .append("<li><a href='#tabs-5' id='tabs5'>주택자금</a></li>")
	        .append("<li class='hide'><a href='#tabs-6' id='tabs6'>주택자금2</a></li>")
	        .append("<li><a href='#tabs-7' id='tabs7'>저축</a></li>")
	        .append("<li><a href='#tabs-8' id='tabs8'>신용카드</a></li>")
	        .append("<li><a href='#tabs-9' id='tabs9'>기타소득공제</a></li>")
	        .append("<li><a href='#tabs-10' id='tabs10'>연금계좌</a></li>")
	        .append("<li><a href='#tabs-11' id='tabs11'>의료비</a></li>")
	        .append("<li><a href='#tabs-12' id='tabs12'>교육비</a></li>")
	        .append("<li><a href='#tabs-13' id='tabs13'>기부금</a></li>")
	        .append("<li><a href='#tabs-14' id='tabs14'>세액감면/기타세액공제</a></li>")
	        .append("<li><a href='#tabs-15' id='tabs15'>연간소득</a></li>")
	        .append("<li><a href='#tabs-16' id='tabs16'>종전근무지</a></li>")
	        .append("<li><a href='#tabs-17' id='tabs17'>출력</a></li>")
	        .append("<li><a href='#tabs-19' id='tabs19'>증빙자료</a></li>")
	        ;

	        tabObj
	        .append("<div id='tabs-1'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-2'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-3'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-4'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-5'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-6'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-7'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-8'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-9'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-10'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-11'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-12'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-13'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-14'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-15'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-16'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-17'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-19'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        ;
		}else{
			//모의계산,결과 권한 조회
		    var simYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_SIM_YN", "queryId=getSystemStdData",false).codeList;
		    var simYnHide = "";
		    if(simYn[0].code_nm != "N") {
		    	simYnHide ="";
		    } else {
		    	simYnHide ="hide";
		    }
		    
		  	//연간소득 탭 출력유무
			var incomeEachTab = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_PAYTOT_YN", "queryId=getSystemStdData",false).codeList;
			var incomeEachTabHide = "";

			if(incomeEachTab[0].code_nm != "N") {
				incomeEachTabHide ="";
		    } else {
		    	incomeEachTabHide ="hide";
		    }

			//종전근무지 탭 출력유무
			var befComTab = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_PREWORK_YN", "queryId=getSystemStdData",false).codeList;
			var befComTabHide = "";

			if(befComTab[0].code_nm != "N") {
				befComTabHide ="";
		    } else {
		    	befComTabHide ="hide";
		    }
			
	        tabObj.find(".ui-tabs-nav")
	        .append("<li><a href='#tabs-1' id='tabs1'>기본_주소사항</a></li>")
	        .append("<li><a href='#tabs-2' id='tabs2'>인적공제</a></li>")
	        .append("<li><a href='#tabs-3' id='tabs3'>PDF등록</a></li>")
	        .append("<li><a href='#tabs-4' id='tabs4'>보험료</a></li>")
	        .append("<li><a href='#tabs-5' id='tabs5'>주택자금</a></li>")
	        .append("<li class='hide'><a href='#tabs-6' id='tabs6'>주택자금2</a></li>")
	        .append("<li><a href='#tabs-7' id='tabs7'>저축</a></li>")
	        .append("<li><a href='#tabs-8' id='tabs8'>신용카드</a></li>")
	        .append("<li><a href='#tabs-9' id='tabs9'>기타소득공제</a></li>")
	        .append("<li><a href='#tabs-10' id='tabs10'>연금계좌</a></li>")
	        .append("<li><a href='#tabs-11' id='tabs11'>의료비</a></li>")
	        .append("<li><a href='#tabs-12' id='tabs12'>교육비</a></li>")
	        .append("<li><a href='#tabs-13' id='tabs13'>기부금</a></li>")
	        .append("<li><a href='#tabs-14' id='tabs14'>세액감면/기타세액공제</a></li>")
	        .append("<li class='" + incomeEachTabHide + "'><a href='#tabs-15' id='tabs15'>연간소득</a></li>")
	        .append("<li class='" + befComTabHide + "'><a href='#tabs-16' id='tabs16'>종전근무지</a></li>")
	        .append("<li><a href='#tabs-17' id='tabs17'>출력</a></li>")
			.append("<li class='" + simYnHide + "'><a href='#tabs-18' id='tabs18'>세금모의계산</a></li>")
	        .append("<li><a href='#tabs-19' id='tabs19'>증빙자료</a></li>")
	        ;

	        tabObj
	        .append("<div id='tabs-1'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-2'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-3'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-4'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-5'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-6'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-7'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-8'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-9'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-10'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-11'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-12'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-13'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-14'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-15'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-16'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-17'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-18'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        .append("<div id='tabs-19'><div class='layout_tabs'><iframe src='<%=jspPath%>/common/hidden.jsp' frameborder='0' class='tab_iframes'></iframe></div></div>")
	        ;
		}

		$("#tabs")
		.append("<div id='moveL' class='btn-tab-move btn-left'><a href='#' onclick='javascript:moveTabScroll(\"L\"); return false;'></a></div>")
		.append("<div id='moveR' class='btn-tab-move btn-right'><a href='#' onclick='javascript:moveTabScroll(\"R\"); return false;'></a></div>")
		;

		newIframe = $('#tabs-1 iframe');
		iframeIdx = 0;

		tabObj.tabs( "refresh" );
		tabObj.tabs( "option", "active", 0 );

		/* Tab Scroll Button 관련 */
		var tabWidth = 0;
		$(".ui-tabs-nav li").each(function(index, item) {
			tabWidth += $(this).width()+21; //margin +1
		});

		$("#defTabWidth").val(tabWidth);


		if(tabWidth < $(window).width()) {
			$(".ui-tabs-nav").width($(window).width());
		}
		else {
			$(".ui-tabs-nav").width(tabWidth);
		}
		//$(".ui-tabs-nav").width($(window).width());
		$(".ui-tabs-nav").css("position", "absolute");

		setMoveButtonPosition();
	}

	function setMoveButtonPosition() {
		var iframeWidth = $(document).width();
		var tabWidth = parseInt($("#defTabWidth").val());
		var tabLeft = isNaN(parseInt($(".ui-tabs-nav > li").css("left").split("px")[0])) ? 0 : parseInt($(".ui-tabs-nav > li").css("left").split("px")[0]);

		if(iframeWidth < tabWidth+tabLeft+39) {
			$("#moveL").show();
			$("#moveR").show();

			$("#moveL").css("right", "29px");
			$("#moveR").css("right", "0");
		}
		else {
			if(tabLeft < 0) {
				tabLeft = 0;
				$(".ui-tabs-nav > li").css("left", tabLeft);
			}

			$("#moveL").show();
			$("#moveR").show();

			$("#moveL").css("right", "29px");
			$("#moveR").css("right", "0");
			//$("#moveL").css("right", (iframeWidth-tabWidth-tabLeft-19)+"px");
			//$("#moveR").css("right", (iframeWidth-tabWidth-tabLeft-38)+"px");

		}
	}

	function moveTabScroll(param) {
		var docWidth = $(window).width();
		var tabWidth = $(".ui-tabs-nav").width();
		var tabLeft = isNaN(parseInt($(".ui-tabs-nav > li").css("left").split("px")[0])) ? 0 : parseInt($(".ui-tabs-nav > li").css("left").split("px")[0]);

		if(param == "L") {
			if(tabLeft >= 0) {
				return false;
			}
			//$(".ui-tabs-nav").css("left", (tabLeft + scrollRange) + "px");
			$(".ui-tabs-nav > li").animate({left: (tabLeft + scrollRange) + "px"}, 100);
		}
		else if(param == "R") {
			if(tabWidth + tabLeft+39 <= docWidth) {
				return false;
			}
			//$(".ui-tabs-nav").css("left", (tabLeft - scrollRange) + "px");
			$(".ui-tabs-nav > li").animate({left: (tabLeft - scrollRange) + "px"}, 100);
		}
	}

	$(window).resize(function() {
		var timer = setTimeout(function() {
			if(parseInt($("#defTabWidth").val()) < $(window).width()) {
				$(".ui-tabs-nav").width($(window).width());
			}
			else {
				$(".ui-tabs-nav").width($("#defTabWidth").val());
			}
			setMoveButtonPosition();
		}, 100);

		//clearTimeout(timer);
	});

	//탭로딩
	function showIframe() {
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","<%=jspPath%>/common/hidden.jsp");
		}

		if(checkClearYn()) {
			//마감체크하여 마감되었으면 권한을 R로 넘겨서 수정 못하게 막음
			var authPg = (getYeaCloseYn()=="Y")?"R":"A";
			//원래권한으로 이페이지는 항상 관리자용으로 A이다.
			var orgAuthPg = "<%=authPg%>";
	        if(ssnEnterCd == "HENT" && ssnGrpCd == "79"){
                if(iframeIdx == 0) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddr.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 1) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPer.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 2) {
                	// ----------------------------------------------------
        			// 20240109 브라우저 버전에 따라 pdf업로드 제어 Start
        		    var _ua = navigator.userAgent;
        			
        			var trident = _ua.match(/Trident\/(\d.\d)/i);
        			if( trident != null )
        			{
        				if( trident[1] == "7.0" || trident[1] == "6.0" || trident[1] == "5.0" || trident[1] == "4.0" ) //IE 11,10,9,8 
        				{
        					newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf_IE.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
        				}
        			}
        			
        			if( navigator.appName == 'Microsoft Internet Explorer' ) //IE 7... 
        			{ 
        				newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf_IE.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
        			}
        			else
        			{
        				newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
        			}

        			// 20240109 브라우저 버전에 따라 pdf업로드 제어 End
        			// ----------------------------------------------------
                } else if(iframeIdx == 3) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIns.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 4) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 5) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou2.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 6) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHouSav.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 7) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataCards.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 8) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEtc.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 9) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPen.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 10) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataMed.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 11) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEdu.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 12) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataDon.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 13) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataTax.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 14) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIncomeEach.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 15) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataBefCom.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 16) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPrtView.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                } else if(iframeIdx == 17) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddFile.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
                }	        	
	        }else{
	            if(iframeIdx == 0) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddr.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 1) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPer.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 2) {
	            	// ----------------------------------------------------
	    			// 20240109 브라우저 버전에 따라 pdf업로드 제어 Start
	    		    var _ua = navigator.userAgent;
	    			
	    			var trident = _ua.match(/Trident\/(\d.\d)/i);
	    			if( trident != null )
	    			{
	    				if( trident[1] == "7.0" || trident[1] == "6.0" || trident[1] == "5.0" || trident[1] == "4.0" ) //IE 11,10,9,8 
	    				{
	    					newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf_IE.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	    				}
	    			}
	    			
	    			if( navigator.appName == 'Microsoft Internet Explorer' ) //IE 7... 
	    			{ 
	    				newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf_IE.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	    			}
	    			else
	    			{
	    				newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPdf.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	    			}

	    			// 20240109 브라우저 버전에 따라 pdf업로드 제어 End
	    			// ----------------------------------------------------
	            } else if(iframeIdx == 3) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIns.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 4) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 5) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHou2.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 6) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataHouSav.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 7) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataCards.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 8) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEtc.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 9) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPen.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 10) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataMed.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 11) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataEdu.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 12) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataDon.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 13) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataTax.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 14) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataIncomeEach.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 15) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataBefCom.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 16) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataPrtView.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 17) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataResultPdf.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            } else if(iframeIdx == 18) { newIframe.attr("src","<%=jspPath%>/yeaData/yeaDataAddFile.jsp?authPg="+authPg+"&orgAuthPg="+orgAuthPg);
	            }	
	        }
		}

		feedbackImg();
	}

	//성명 바뀌면 호출
	function setEmpPage() {
		$("#searchSabun").val( $("#searchUserId").val() ) ;
		$("#searchRegNo").val( $("#searchRegNo_").val() ) ;
		if(iframeIdx == 0) {
			showIframe();

			//담당자피드백 활성시
			if(feedbackYn == "Y"){
				doAction1("Search");
			}
			//특이사항 활성시
			if(specialYn == "Y"){
				doAction2("Search");
			}
		} else {
			tabObj.tabs( "option", "active", 0 );
		}

		//사업장코드가져오기
		getBizPlCd();
		
		doAction4("Search");
		hideErrChkPrev();
	}

	//기본정보 조회
	function getYearDefaultInfoObj() {
		/*
		Tab별로 카운트 표시
		tabs-1 : 주소사항
		tabs-2 : 인적공제
		tabs-3 : PDF등록
		tabs-4 : 연 금
		tabs-5 : 보험료
		tabs-6 : 주택자금1
		tabs-7 : 주택자금2
		tabs-8 : 저축
		tabs-9 : 카드등
		tabs-10 : 기타공제
		tabs-11 : 의료비
		tabs-12 : 교육비
		tabs-13 : 기부금
		tabs-14 : 세액감면/기타세액공제
		tabs-16 : 종전근무지
		tabs-19 : 증빙자료
		*/

		var param = "searchWorkYy="+$("#searchWorkYy").val() + "&searchAdjustType="+$("#searchAdjustType").val() + "&searchSabun="+$("#searchSabun").val() ;
		var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectTabCnt", param,false);
		if(result.Result.Code == 1) {

			if(result.Data.cnt2 > 0) result.Data.cnt2 = "<font class='red'>"+result.Data.cnt2+"</font>";
			if(result.Data.cnt3 > 0) result.Data.cnt3 = "<font class='red'>"+result.Data.cnt3+"</font>";
			if(result.Data.cnt4 > 0) result.Data.cnt4 = "<font class='red'>"+result.Data.cnt4+"</font>";
			if(result.Data.cnt5 > 0) result.Data.cnt5 = "<font class='red'>"+result.Data.cnt5+"</font>";
			if(result.Data.cnt6 > 0) result.Data.cnt6 = "<font class='red'>"+result.Data.cnt6+"</font>";
			if(result.Data.cnt7 > 0) result.Data.cnt7 = "<font class='red'>"+result.Data.cnt7+"</font>";
			if(result.Data.cnt8 > 0) result.Data.cnt8 = "<font class='red'>"+result.Data.cnt8+"</font>";
			if(result.Data.cnt9 > 0) result.Data.cnt9 = "<font class='red'>"+result.Data.cnt9+"</font>";
			if(result.Data.cnt10 > 0) result.Data.cnt10 = "<font class='red'>"+result.Data.cnt10+"</font>";
			if(result.Data.cnt11 > 0) result.Data.cnt11 = "<font class='red'>"+result.Data.cnt11+"</font>";
			if(result.Data.cnt12 > 0) result.Data.cnt12 = "<font class='red'>"+result.Data.cnt12+"</font>";
			if(result.Data.cnt13 > 0) result.Data.cnt13 = "<font class='red'>"+result.Data.cnt13+"</font>";
			if(result.Data.cnt14 > 0) result.Data.cnt14 = "<font class='red'>"+result.Data.cnt14+"</font>";
			if(result.Data.cnt16 > 0) result.Data.cnt16 = "<font class='red'>"+result.Data.cnt16+"</font>";
			if(result.Data.cnt19 > 0) result.Data.cnt19 = "<font class='red'>"+result.Data.cnt19+"</font>";

			//$("#tabs1").html("주소사항("+result.Data.cnt1+")");
			$("#tabs2").html("인적공제("+result.Data.cnt2+")");
			$("#tabs3").html("PDF등록("+result.Data.cnt3+")");
			$("#tabs4").html("보험료("+result.Data.cnt5+")");
			$("#tabs5").html("주택자금("+result.Data.cnt6+")");
			$("#tabs6").html("주택자금2("+result.Data.cnt7+")");
			$("#tabs7").html("저축("+result.Data.cnt8+")");
			$("#tabs8").html("신용카드("+result.Data.cnt9+")");
			$("#tabs9").html("기타소득공제("+result.Data.cnt10+")");
			$("#tabs10").html("연금계좌("+result.Data.cnt4+")");
			$("#tabs11").html("의료비("+result.Data.cnt11+")");
			$("#tabs12").html("교육비("+result.Data.cnt12+")");
			$("#tabs13").html("기부금("+result.Data.cnt13+")");
			$("#tabs14").html("세액감면/기타세액공제("+result.Data.cnt14+")");
			$("#tabs16").html("종전근무지("+result.Data.cnt16+")");
			$("#tabs19").html("증빙자료("+result.Data.cnt19+")");

			$("#inputStatus").val(result.Data.input_status);
		}
		return ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectYeaDataDefaultInfo", $("#mainForm").serialize(),false);
	}

	//마감정보 조회
	function getYeaCloseYn() {
		var closeYn = "N";
		var yeaCloseInfo = getYearDefaultInfoObj();

		$("#spanMagam").hide();
		$("#spanMagamCancel").hide();

		if(yeaCloseInfo.Result.Code == 1) {
			//2019-11-13. 담당자 마감일때 수정 불가 처리를 위해 font tag에 class 추가(연간소득,종전근무지)
			if(typeof yeaCloseInfo.Data.sabun == "undefined") {
				closeYn = "Y";
				$("#tdStatusView").html("<font class='close_1' size=2><b>[<font class='red'>대상자가 아닙니다.</font>]</b></font>");
			} else if(yeaCloseInfo.Data.final_close_yn == "Y" || yeaCloseInfo.Data.apprv_yn == "Y"|| yeaCloseInfo.Data.input_close_yn == "Y") {
				if(yeaCloseInfo.Data.final_close_yn == "Y"){
					closeYn = "Y";
					$("#tdStatusView").html("<font class='close_4' size=2><b>[현재 <font class='red'>최종마감</font> 상태입니다.]</b></font>");
				} else if(yeaCloseInfo.Data.apprv_yn == "Y"){
					closeYn = "N";
					$("#tdStatusView").html("<font class='close_3' size=2><b>[현재 <font class='red'>담당자마감</font> 상태입니다.]</b></font>");
					$("#spanMagamCancel").show();
				} else if(yeaCloseInfo.Data.input_close_yn == "Y"){
					closeYn = "N";
					$("#tdStatusView").html("<font class='close_2' size=2><b>[현재 <font class='red'>본인마감</font> 상태입니다.]</b></font>");
					$("#spanMagam").show();
				}
			} else {
				closeYn = "N";
				$("#tdStatusView").html("<font class='close_0' size=2><b>[현재 <font class='red'>본인 마감전</font> 상태입니다.]</b></font>");
				$("#spanMagam").show();
			}
		}
		return closeYn;
	}

	//각 업무단에 대상자 및 마감된 자료인지 체크
	function checkClose(){
		var yeaCloseInfo = getYearDefaultInfoObj();

		if(yeaCloseInfo.Result.Code == 1) {
			if(typeof yeaCloseInfo.Data.sabun == "undefined") {
				alert("대상자가 아닙니다.");
				return false;
			} else if(yeaCloseInfo.Data.final_close_yn == "Y") {
				alert("최종 마감된 자료입니다.\n저장 할 수 없습니다.");
				return false;
			}
		}

		return true;
	}

	//각 업무단에 대상자 체크
	function checkPeopleSet(){
		var yeaCloseInfo = getYearDefaultInfoObj();

		if(yeaCloseInfo.Result.Code == 1) {
			if(typeof yeaCloseInfo.Data.sabun == "undefined") {
				alert("대상자가 아닙니다.");
				return false;
			}
		}

		return true;
	}

	//특이사항 표시
	function checkClearYn() {

		var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectCheckClearYn", $("#mainForm").serialize(),false);
		if(result.Result.Code == 1) {
			var temp = nvl(result.Data.clear_yn_str,"1");

			if(temp == "3") {
				<%-- $("#span_clearYnCheck").html("<img src='<%=imagePath%>/icon/ic_st03.gif'  border='0' style='vertical-align:middle;'>"); --%>
				$("#buttonPlusNt").removeClass("notice-red");
				$("#buttonMinusNt").removeClass("notice-red");
				$("#buttonPlusNt").addClass("notice-blue");
				$("#buttonMinusNt").addClass("notice-blue");
			} else if(temp == "2") {
				<%-- $("#span_clearYnCheck").html("<img src='<%=imagePath%>/icon/ic_st02.gif'  border='0' style='vertical-align:middle;'>"); --%>
				$("#buttonPlusNt").addClass("notice-red");
				$("#buttonMinusNt").addClass("notice-red");
				$("#buttonPlusNt").removeClass("notice-blue");
				$("#buttonMinusNt").removeClass("notice-blue");
			} else if(temp == "1") {
				<%-- $("#span_clearYnCheck").html("<img src='<%=imagePath%>/icon/ic_st01.gif'  border='0' style='vertical-align:middle;'>"); --%>
				$("#buttonPlusNt").removeClass("notice-red");
				$("#buttonMinusNt").removeClass("notice-red");
				$("#buttonPlusNt").removeClass("notice-blue");
				$("#buttonMinusNt").removeClass("notice-blue");
			}

			return true;
		}

		return false;
	}

	var pGubun = "";

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "yeaDataUnusualPopup" ){
			showIframe();
		}

		if ( pGubun == "yeaFeedbackPopup" ){
			feedbackImg();
		}
	}

	//action
	function doAction(sAction) {
		switch (sAction) {
		case "InputClose":
			var yeaDefaultInfo = getYearDefaultInfoObj();

			if(typeof yeaDefaultInfo.Data.sabun  == "undefined") {
				alert("대상자가 아닙니다.");
				return;
			}
			if(yeaDefaultInfo.Data.final_close_yn == "Y") {
				alert('최종 마감이 완료된 상태 입니다.');
				return;
			}
			if(yeaDefaultInfo.Data.apprv_yn == "Y") {
				alert('이미 담당자 마감이 완료된 상태 입니다.');
				return;
			}

			if(confirm("입력 마감을 진행하시겠습니까?")) {
				var param = "searchPayActionCd="+yeaDefaultInfo.Data.pay_action_cd
				param += "&searchWorkYy="+yeaDefaultInfo.Data.work_yy
				param += "&searchAdjustType="+yeaDefaultInfo.Data.adjust_type
				param += "&searchSabun="+yeaDefaultInfo.Data.sabun;

				var data = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=prcYeaMgrClose",param,false);
				if(data.Result.Code == 1) {
					showIframe() ;
					
					var errChkPerCnt = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectErrChkPerCnt", $("#mainForm").serialize(), false);
					if((errChkPerCnt != undefined || errChkPerCnt != null) && Number(errChkPerCnt.Data.cnt) > 0) {
						doAction4("Search");
						showErrChkPrev();
					}
					else
						hideErrChkPrev();
				}
			}

	 	   	break;
		case "CancelClose":
			var yeaDefaultInfo = getYearDefaultInfoObj();

			if(typeof yeaDefaultInfo.Data.sabun  == "undefined") {
				alert("대상자가 아닙니다.");
				return;
			}
			if(yeaDefaultInfo.Data.final_close_yn == "Y") {
				alert('최종 마감이 완료된 상태 입니다.');
				return;
			}
			if(yeaDefaultInfo.Data.apprv_yn == "N") {
				alert('마감작업을 진행하지 않았습니다.');
				return;
			}

			if(confirm("마감취소를 진행하시겠습니까?")) {
				var param = "searchPayActionCd="+yeaDefaultInfo.Data.pay_action_cd
				param += "&searchWorkYy="+yeaDefaultInfo.Data.work_yy
				param += "&searchAdjustType="+yeaDefaultInfo.Data.adjust_type
				param += "&searchSabun="+yeaDefaultInfo.Data.sabun;

				var data = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=prcYeaMgrCloseCancel",param,false);
				if(data.Result.Code == 1) {
					showIframe();
				}
			}

	 	   	break;
		case "ResultView":
			var yeaDefaultInfo = getYearDefaultInfoObj();

			if(typeof yeaDefaultInfo.Data.sabun  == "undefined") {
				alert("대상자가 아닙니다.");
				return;
			}
			if(yeaDefaultInfo.Data.final_close_yn == "Y") {
				alert('최종마감된 자료는 결과보기를 할 수 없습니다.');
				return;
			}

			var args = [];
			args["searchWorkYy"]		= $("#searchWorkYy").val() ;
			args["searchAdjustType"]	= $("#searchAdjustType").val() ;
			args["searchSabun"]			= $("#searchSabun").val() ;
			args["searchGubun"]			= "1";

			if(!isPopup()) {return;}
			var rv = openPopup("<%=jspPath%>/yeaData/yeaDataResultPopup.jsp",args,"1000","750");

			break;
		}
	}

	function headerView(type) {
		if ( type == "hide" ) {
			$('#emplyeeHeader, .sheet_search').hide();
			$('#div_header_view').attr('style', 'position:absolute; top:-5px; width:100%;');
			$('#div_insa_tab').attr('style', 'top:8px;');
		} else {
			$('#emplyeeHeader, .sheet_search').show();
			$('#div_header_view').attr('style', 'position:absolute; top:107px; width:100%;');
			$('#div_insa_tab').attr('style', 'top:120px;');
		}
	}

	function feedbackImg() {
		// 담당자 피드백에 직원 피드백은 있고 담당자는 피드백내용 없는게 한개라도 있는 경우
		var result = ajaxCall("<%=jspPath%>/yeaData/yeaDataRst.jsp?cmd=selectFeedbackYn", $("#mainForm").serialize(),false);
		if(result.Result.Code == 1) {
			var temp = nvl(result.Data.yn,"N");
			if(temp == "Y") {
				<%-- $("#span_feedback").html("<img src='<%=imagePath%>/icon/ic_st02.gif'  border='0' style='vertical-align:middle;'>"); --%>
				$("#buttonPlus").addClass("notice-red");
				$("#buttonMinus").addClass("notice-red");
			} else {
				<%-- $("#span_feedback").html("<img src='<%=imagePath%>/icon/ic_st01.gif'  border='0' style='vertical-align:middle;'>"); --%>
				$("#buttonPlus").removeClass("notice-red");
				$("#buttonMinus").removeClass("notice-red");
			}
		}
	}

	//연말정산 코드 가져오기
	function getActionCd(){
	    //연말정산_급여계산 코드,명칭 초기화
	    payActionCd = "";
	    payActionNm = "";

		var paymentInfo = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=selectYeaPayActionInfo", "searchYear="+$("#searchWorkYy").val(), false);

		//연말정산_급여계산 코드,명칭 세팅
		payActionCd = nvl(paymentInfo.Data.pay_action_cd,"");
		payActionNm = nvl(paymentInfo.Data.pay_action_nm,"");
	}

	//작업현황 팝업
	function openProcessStatus(){
		var args 	= new Array();
		args["searchWorkYy"]		= $("#searchWorkYy").val() ;
		args["searchPayActionNm"]	= payActionNm;
		args["searchPayActionCd"]	= payActionCd;
		args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)
		args["searchBizPlaceCd"]	= $("#searchBusinessCd").val() ;//사업장

		if(!isPopup()) {return;}
		pGubun = "yeaCalcCreOptionPopup";
		var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcProcessStatusPopup.jsp?authPg=<%=authPg%>",args,"620","720");
	}

	// 사업장 코드 가져오기
	function getBizPlCd(){

		var params = "&searchSabun="+$("#searchSabun").val();
		params+= "&searchWorkYy="+$("#searchWorkYy").val();
		params+= "&searchAdjustType="+$("#searchAdjustType").val();

	    var bizPlCd = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList"+params, "queryId=getBusinessPlaceList2",false).codeList;
	    if(bizPlCd[0] != null) {
		    $("#searchBusinessCd").val(bizPlCd[0].business_place_cd);
	    }
	    else {
		    $("#searchBusinessCd").val("");
	    }
	}
	
	function setAdjustType() {
		$("#searchAdjustType").val($("#searchAdjustType_header").val());
	}
</script>
</html>