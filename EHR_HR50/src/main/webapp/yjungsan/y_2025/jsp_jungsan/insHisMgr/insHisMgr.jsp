<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>보험료내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var inputTypeList = null; //자료입력유형 adj_input_type
	var feedbackTypeList = null; //담당자확인(2021.10.25)

	$(function() {
		$("#searchWorkYy").val("<%=yeaYear%>") ;

		//연말정산 보험료 쉬트
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No|No",						Type:"Seq",			Hidden:0,	Width:"45",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제|삭제",						Type:"DelCheck",	Hidden:1,	Width:"50",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",						Type:"Status",		Hidden:1,	Width:"45",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"DOC_SEQ|DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL|DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:40 },
			{Header:"년도|년도",						Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_yy",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분|정산구분",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번|사번",						Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"순서|순서",						Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"seq",				KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"계약자명|계약자명",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"famres_contrt",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"연말정산\n보험구분|연말정산\n보험구분",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"insurance_type",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
			{Header:"피보험자명|피보험자명",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"famres_insured",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"금액자료|직원용",					Type:"AutoSum",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",		KeyField:0,	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35, MinimumValue: 0 },
			{Header:"금액자료|담당자용",					Type:"AutoSum",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",		KeyField:1,	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35, MinimumValue: 0 },
			{Header:"자료입력유형|자료입력유형",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adj_input_type",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부|국세청\n자료여부",	Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자확인|담당자확인",				Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"feedback_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("1");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
        
		inputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00325"), "전체");
		feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00329"), "");

		sheet1.SetColProperty("adj_input_type",	{ComboText:"|"+inputTypeList[0], ComboCode:"|"+inputTypeList[1]} );
		sheet1.SetColProperty("feedback_type",	{ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
		$("#searchInputType").html(inputTypeList[2]);

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();
		
		getCprBtnChk();	
		
		//doAction1("Search");
	});

	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/insHisMgr/insHisMgrRst.jsp?cmd=selectInsHisMgrList", $("#sheetForm").serialize() );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//수정(이력) 관련 세팅
	function getCprBtnChk(){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#searchWorkYy").val()
                   + "&searchAdjustType="
                   + "&searchSabun=" ;
        
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#searchAdjustType").html("");
		} else {   			
  			$("#searchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
  			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>년도</span>
				<%-- 무의미한 분기문 주석 처리 20240919
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				--%>
					<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/>
				<%-- 무의미한 분기문 주석 처리 20240919}else{%>
					<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/>
				<%}--%>
				</td>
				<td><span>정산구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
				<td><span>자료입력유형</span>
					<select id="searchInputType" name ="searchInputType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')" ></select>
                </td>
				<td><span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
			</tr>
		</table>
		</div>
	</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">보험료내역관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>