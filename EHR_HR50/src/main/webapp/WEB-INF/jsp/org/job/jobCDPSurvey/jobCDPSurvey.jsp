<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>희망직무조사</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var pGubun = "";
var pType = "";

	$(function() {
		//Sheet 초기화
		init_sheet();
		
		//사번셋팅
		setEmpPage();

		doAction1("Search");
		
		$("#btnSaveAll").css("display", "none"); 
	});

	//Sheet 초기화
	function init_sheet(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
			
			{Header:"작성일자",		Type:"Date",		Hidden:0, 	Width:100,	 Align:"Center", SaveName:"regYmd",	Format:"Ymd",		UpdateEdit:0,	InsertEdit:1, Edit:0 },
			{Header:"제출일자",		Type:"Date",		Hidden:0, 	Width:100,	 Align:"Center", SaveName:"applYmd",	Format:"Ymd",	UpdateEdit:0,	InsertEdit:1, Edit:0 },
			{Header:"제출여부",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"searchType"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"saveAll"}

  		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
  		
  		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0, FrozenColRight:0};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
			
			{Header:"기간구분",		Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"planYyCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
			{Header:"년도",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"planYy",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
			{Header:"희망부서",		Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
			{Header:"경력계획",		Type:"Popup",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobCdNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },
			{Header:"직무\n기술서",	Type:"Image",	Hidden:0,	Width:10,   Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
			
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"jobCd"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"orgCd"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"regYmd"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"sabun"},
			
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"jobNm"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"jobEngNm"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"jobType"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"memo"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"jobDefine"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"sdate"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"edate"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"academyReq"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"majorReq"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"careerReq"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"otherJobReq"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"note"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"seq"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"majorReq2"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"majorNeed"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"majorNeed2"}
			
  		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
  		
  		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0, FrozenColRight:0};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			
			{Header:"직무",			Type:"Combo",		Hidden:0,  Width:30,	Align:"Center",	 ColMerge:0,   SaveName:"jobCd",		KeyField:0,	  Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"교육기관명",	Type:"Text",      	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"eduOrgNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"교육명",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Left",	 ColMerge:0,   SaveName:"eduCourseNm",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"교육구분",		Type:"Text",      	Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"eduBranchNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
	 		{Header:"이수여부",		Type:"CheckBox",   	Hidden:0,  Width:20,   Align:"Center",  ColMerge:0,   SaveName:"compYn",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, TrueValue:"Y", FalseValue:"N" },
	 		{Header:"신청",			Type:"Html",		Hidden:0,  Width:20,  Align:"Center", ColMerge:0,	SaveName:"btnApp",  		Sort:0},
	 		{Header:"Hidden",	Type:"Text",   Hidden:1, Width:20, SaveName:"cnt"}

  		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);
 
  		// 콥보 리스트
		/* ########################################################################################################################################## */
		var grpCds = "H99010";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
		
		var jobCdParam = "&searchJobType=10030&codeType=1";
		var jobCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		sheet2.SetColProperty("planYyCd",  {ComboText:"|"+codeLists["H99010"][0], ComboCode:"|"+codeLists["H99010"][1]} );  // 기간구분(H99010)
		sheet3.SetColProperty("jobCd", 			{ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );			//직무코드
		/* ########################################################################################################################################## */
						
		$(window).smartresize(sheetResize); sheetInit();
		
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var sXml = sheet1.GetSearchData("${ctx}/JobCDPSurvey.do?cmd=getJobCDPSurveyWishList", $("#sheetForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet1.LoadSearchData(sXml);
	        	break;	
	        case "Save":
	       		IBS_SaveName(document.sheetForm,sheet1);
	       		
	       		var row = sheet1.GetSelectRow();
	       		
	       		if(sheet1.GetCellValue(row,"searchType") == "1"){
	       			/* 신규작성 클릭 이벤트 */
	       			sheet1.DoSave("${ctx}/JobCDPSurvey.do?cmd=saveJobCDPSurveyWish", $("#sheetForm").serialize(), -1, 0);
	       		}else{
	       			
	       			var rowCnt = sheet1.RowCount();
	        		var zFlag = false;
	        		var eFlag = false;
	        		var xFlag = false;
	        		var dFlag = false;
	        		
	        		var msg = "";
	        		
	        		for (var i=1; i<=rowCnt; i++) {
	        			
	        			if(sheet1.GetCellValue(i, "sDelete") == "1"){
	        				dFlag = true;
	        				if(sheet1.GetCellValue(i, "applYn") == "Y"){
	        					zFlag = true;
	        				}
	        			}
	        			
	        			if(sheet1.GetCellValue(i, "sStatus") == "U"){
	        				if(sheet1.GetCellValue(i, "applYn").toUpperCase() != "Y" && sheet1.GetCellValue(i, "applYn").toUpperCase() != "N"){
	        					eFlag = true;
	        				}
	        				
	        				if(sheet1.GetCellValue(i, "applYn").toUpperCase() == "Y"){
	        					
	        					$("#searchRegYmd").val(sheet1.GetCellValue(i,"regYmd"));
	        					
	        					var data = ajaxCall( "${ctx}/JobCDPSurvey.do?cmd=getJobCDPSurveyApplYnList", $("#sheetForm").serialize(),false);
	        					
	        					if(!data.DATA[0]){
	        						xFlag = true;
	        					}
	        					
	        				}
	        				
        					sheet1.SetCellValue(i,"applYn",sheet1.GetCellValue(i, "applYn").toUpperCase());
	        			}
	        			
	        		}
	        		
	        		if(dFlag == true){
	        			msg = "작성하신 경력개발개획 내역이 삭제됩니다. 삭제하시겠습니까?";
	        		}else{
	        			msg = "저장하시겠습니까?";
	        		}
	        		
	        		if(zFlag == true){
        				alert("제출여부가 Y이면 삭제 할 수 없습니다.");
        				return;
        			}
	        		
	        		if(eFlag == true){
        				alert("제출여부가 Y,N으로 입력 해 주세요.");
        				return;
        			}
	        		
	        		if(xFlag == true){
        				alert("경력개발계획을 저장 해 주세요.");
        				return;
        			}
	        		
        			if (confirm(msg)) {
	        			sheet1.DoSave("${ctx}/JobCDPSurvey.do?cmd=saveJobCDPSurveyWish", $("#sheetForm").serialize(), -1, 0);
	        		}else{
//   	        			sheet1.SetCellValue(Row,"searchType","");
	        		}
	       			
	       			zFlag = false;
	       			eFlag = false;
	       			eFlag = false;
	       			xFlag = false;
	       			dFlag = false;
	       			msg = "";
	       		}
	       		
	        	break;
		}
	}
	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				
				var sXml = sheet2.GetSearchData("${ctx}/JobCDPSurvey.do?cmd=getJobCDPSurveyCareerList", $("#sheetForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet2.LoadSearchData(sXml);
	        	break;	
	        case "Save":
	        	
	        	var row = sheet1.GetSelectRow();
		    	
        		if(sheet1.GetCellValue(row,"sStatus") == "I"){
        			alert("희망직무 제출 내역 먼저 저장 해 주세요.");
        			return;
        		}
        		
//         		var rowCnt = sheet2.RowCount();
//         		var tFlag = false;
        		
//         		for (var i=1; i<=rowCnt; i++) {
        			
//         			sheet2.SetCellValue(i,"regYmd",sheet1.GetCellValue(row,"regYmd"));
        			
//         			if(!sheet2.GetCellValue(i, "jobCdNm")){
//         				tFlag = true;
//         			}
//         		}
        		
//         		if(tFlag == true){
//         			alert("경력계획을 선택 해 주세요.");
//         			return;
//         		}
        		
	        	if(confirm("저장하시겠습니까?")){
	        		IBS_SaveName(document.sheetForm,sheet2);
		       		sheet2.DoAllSave("${ctx}/JobCDPSurvey.do?cmd=saveJobCDPSurveyCareer", $("#sheetForm").serialize());
	        	}
	        	
	        	fnApplYn();
	        	
	        	tFlag = false;
	       		 
	        	break;
		}
	}
	
	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
			case "Search":
				var sXml = sheet3.GetSearchData("${ctx}/JobCDPSurvey.do?cmd=getNeedEduListSurvey", $("#sheetForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet3.LoadSearchData(sXml);
	        	break;	
		}
	}
	
	// 신규작성 클릭 이벤트
	function newMake(){
		
		var regDate = replaceAll("<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>", "-","");
		
		var regFlag = false;
		
		var rowCnt = sheet1.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if(sheet1.GetCellValue(i, "regYmd") == regDate){
				regFlag = true;
			}
		}
		
		if(regFlag == true){
			alert("작성일자가 같은 날이 있습니다.");
			return;
		}else{
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row,"searchType","1");
			
			pType = "1";
			
			doAction1("Save");
		}
		
	}
	
	// 신규작성 클릭후 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		
		if( NewRow < sheet1.HeaderRows() ) return;

			if( OldRow != NewRow ) {
				if(!sheet1.GetCellValue(NewRow,"regYmd")){
					sheet1.SetCellValue(NewRow,"sabun",$("#searchSabun").val());
						sheet1.SetCellValue(NewRow,"regYmd","<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
// 					sheet1.SetCellValue(NewRow,"regYmd","2020-08-20");
				}
				
				$("#searchRegYmd").val(sheet1.GetCellValue(NewRow,"regYmd"));
				doAction2("Search");
				
				// sheet2 로드후 적용
				setTimeout(
					function(){
								
						var data = ajaxCall( "${ctx}/JobCDPSurvey.do?cmd=getJobCDPSurveyCareerList", $("#sheetForm").serialize(),false);
						
						if(data.DATA.regYmd == undefined){
							rowAllVal();
						}else if(sheet1.GetCellText(row,"searchType") == "1"){
							rowAllVal();
						}
						
						fnApplYn();
						
					}, 200);
				
			}
		
	}
	
	// 제출여부 체크
	function fnApplYn(){
		
		var row = sheet1.GetSelectRow();
    	
		$("#searchRegYmd").val(sheet1.GetCellValue(row,"regYmd"));
		
		var data = ajaxCall( "${ctx}/JobCDPSurvey.do?cmd=getJobCDPSurveyApplYnList", $("#sheetForm").serialize(),false);
		
		if(data.DATA[0]){
			if(data.DATA[0].applYn == "N"){
				$("#btnSaveAll").css("display", "block");
				$("#btnSaveAll").val("1");
			}else{
				$("#btnSaveAll").css("display", "none");
			}
		}
		
	}
	
	// sheet2 Row 입력
	function rowAllVal(){
		
		var row = sheet1.GetSelectRow();
		var rowCnt = sheet2.RowCount();
		var searchDate = "";
		
		if( sheet1.GetCellValue(row, "regYmd") && sheet1.GetCellValue(row, "regYmd") != ''){
			searchDate =  sheet1.GetCellValue(row, "regYmd");
		}else {
			searchDate = "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>";

		}

		for (var i=1; i<=rowCnt; i++) {
			sheet2.SetCellValue(i,"sabun",$("#searchSabun").val());
			sheet2.SetCellValue(i,"regYmd", searchDate);
// 					sheet2.SetCellValue(i,"regYmd","2020-08-20");
			
		}
	}
	
	//인사헤더에서 이름 변경 시 호출 됨 
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	$("#searchApplSabun").val($("#searchUserId").val());
    	doAction1("Search");
    	sheet2.RemoveAll();
    	sheet3.RemoveAll();
    }
	
 	// 팝업 클릭시 발생
	function sheet2_OnPopupClick(Row,Col) {
		try {
			if(sheet2.ColSaveName(Col) == "jobCdNm") {
				if(!isPopup()) {return;}

	            pGubun = "jobDivReportMgrPopup";

				var jobMgrLayer = new window.top.document.LayerModal({
					id: 'jobDivReportMgrLayer',
					url: "/JobDivReportMgrPopup.do?cmd=viewJobDivReportMgrLayer",
					parameters: {},
					width: 1000,
					height: 600,
					title: '부서별 직무분담표',
					trigger: [
						{
							name: 'jobDivReportMgrLayerTrigger',
							callback: function(rv) {
								getReturnValue(rv);
							}
						}
					]
				});

				jobMgrLayer.show();

	            
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
 	
 	// 팝업 리턴 값
	function getReturnValue(rv) {
		var row = sheet2.GetSelectRow();
		if(row == 0) {
			return;
		}
		
		if(pGubun == "jobDivReportMgrPopup"){
			sheet2.SetCellValue(row, "jobCd",	rv["jobCd"] );
			sheet2.SetCellValue(row, "jobCdNm",	rv["jobCdNm"] );
			sheet2.SetCellValue(row, "orgNm",	rv["orgNm"] );
			sheet2.SetCellValue(row, "orgCd",	rv["orgCd"] );
			
			$("#jobTitle").html(sheet2.GetCellValue(row,"jobCdNm")+" ");
			
			$("#jobCd").val(rv["jobCd"]);
			 
			doAction3("Search");
		}

	}
 	
 	// 최종제출 이벤트
 	function saveAll(){
 		var row = sheet1.GetSelectRow();
		sheet1.SetCellValue(row,"saveAll","1");
		
		var rowCnt = sheet2.RowCount();
		var tFlag = false;
		
		for (var i=1; i<=rowCnt; i++) {
			
			sheet2.SetCellValue(i,"regYmd",sheet1.GetCellValue(row,"regYmd"));
			
			if(!sheet2.GetCellValue(i, "jobCdNm")){
				tFlag = true;
			}
		}
		
		if(tFlag == true){
			alert("경력계획을 모두 기입 해 주세요.");
			return;
		}
		
		IBS_SaveName(document.sheetForm,sheet1);
		if (confirm("저장하시겠습니까?")) {
			sheet1.DoSave("${ctx}/JobCDPSurvey.do?cmd=saveJobCDPSurveyWish", $("#sheetForm").serialize(), -1, 0);
		}else{
			sheet1.SetCellValue(row,"saveAll","");
		}
		
 	}
	
 	// sheet1 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
 		try {
 			if (Msg != "") {
 				alert(Msg);
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
				
				if(!pType == "1"){
					alert(Msg); 
				}
			} 
			if( Code > -1 ) doAction1("Search"); 
							sheet2.RemoveAll();
							sheet3.RemoveAll();
							$("#btnSaveAll").css("display", "none");
							
							pType = "";
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
 	
	// sheet2 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {try {if (Msg != "") {alert(Msg);}sheetResize();} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }}
	
	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			if( Code > -1 ) doAction2("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	// 경력개발계획 클릭 이벤트
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		
		if( NewRow < sheet1.HeaderRows() ) return;
		
			if( OldRow != NewRow ) {
				if(sheet2.GetCellValue(NewRow,"jobCdNm")){
					$("#jobTitle").html(sheet2.GetCellValue(NewRow,"jobCdNm")+" ");
					$("#jobCd").val(sheet2.GetCellValue(NewRow,"jobCd"));
					doAction3("Search");
				}else{
					sheet3.RemoveAll();
				}
			}
	}
	
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if (Row > 0 && sheet2.ColSaveName(Col) == "detail") {
				jobMgrPopup(Row);
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	/**
	 * 상세내역 window open event
	 */
	function jobMgrPopup(Row) {
		if (!isPopup()) {
			return;
		}

		var w = 1000;
		var h = 720;
		var url = "/Popup.do?cmd=viewJobMgrLayer&authPg=R";
		<%--var url = "${ctx}/JobMgr.do?cmd=viewJobMgrPopup&authPg=${authPg}";--%>
		var p = {
			jobCd : sheet2.GetCellValue(Row, "jobCd"),
			jobNm : sheet2.GetCellValue(Row, "jobNm"),
			jobEngNm : sheet2.GetCellValue(Row, "jobEngNm"),
			jobType : sheet2.GetCellValue(Row, "jobType"),
			memo : sheet2.GetCellValue(Row, "memo"),
			jobDefine : sheet2.GetCellValue(Row, "jobDefine"),
			sdate : sheet2.GetCellText(Row, "sdate"),
			edate : sheet2.GetCellText(Row, "edate"),
			academyReq : sheet2.GetCellValue(Row, "academyReq"),
			majorReq : sheet2.GetCellValue(Row, "majorReq"),
			careerReq : sheet2.GetCellValue(Row, "careerReq"),
			otherJobReq : sheet2.GetCellValue(Row, "otherJobReq"),
			note : sheet2.GetCellValue(Row, "note"),
			seq : sheet2.GetCellValue(Row, "seq"),
			majorReq2 : sheet2.GetCellValue(Row, "majorReq2"),
			majorNeed : sheet2.GetCellValue(Row, "majorNeed"),
			majorNeed2 : sheet2.GetCellValue(Row, "majorNeed2")
		}

		gPRow = Row;
		pGubun = "jobMgrPopup";
		// openPopup(url, args, w, h);

		var jobMgrLayer = new window.top.document.LayerModal({
			id: 'jobMgrLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: '직무기술서',
			trigger: [
				{
					name: 'jobMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});

		jobMgrLayer.show();
	}

	// sheet3 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
			
			var rowCnt = sheet3.RowCount();
    		for (var i=1; i<=rowCnt; i++) {
    			
    			if(sheet3.GetCellValue(i, "compYn") == "N" && sheet3.GetCellValue(i, "cnt") > 0){
    				sheet3.SetCellValue(i, "btnApp", "<a class='btn soft' style='height:17px;padding:0px 10px 2px 10px'>신청</a>");
    			}
    			
    		}
			
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	// 경력개발계획 클릭 이벤트
	function sheet3_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		
		if( NewRow < sheet1.HeaderRows() ) return;
		
			if( sheet3.ColSaveName(NewCol) == "btnApp" && sheet3.GetCellValue(NewRow, "compYn") == "N" && sheet3.GetCellValue(i, "cnt") > 0) {
		        if(typeof goSubPage == 'undefined') {
		            // 서브페이지에서 서브페이지 호출
		            if(typeof window.top.goOtherSubPage == 'function') {
		                window.top.goOtherSubPage("", "", "", "", "EduApp.do?cmd=viewEduApp");
		            }
		        } else {
		            goSubPage("", "", "", "", "EduApp.do?cmd=viewEduApp");
		        }
			}
	}
</script>
</head>
<body class="hidden">

<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="sheetForm" name="sheetForm" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<input type="hidden" id="searchApplSabun" name="searchApplSabun" value=""/>
		<input type="hidden" id="searchRegYmd" name="searchRegYmd" value=""/>
		<input type="hidden" id="jobCd" name="jobCd" value=""/>
	</form>
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="35%" />
		<col width="65%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td class="top">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li class="txt"><span>희망직무 제출 내역</span></li>
									<li class="btn">
										<a href="javascript:doAction1('Save')" 		class="btn soft authA"><tit:txt mid='104476' mdef='저장'/></a>
										<a href="javascript:newMake();" 	class="btn soft" >신규작성</a>
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet1", "100%", "40%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td class="top">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li class="txt"><span>경력개발계획</span></li>
									<li class="btn">
										<btn:a href="javascript:doAction2('Save')" 	css="btn soft authA" mid='110708' mdef="저장"/>
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr style="height: 20px;"></tr>
				<tr>
					<td class="top">
						<div align="center" id="btnSaveAll">
							<ul>
								<li class="btn">
									<a href="javascript:saveAll()" class="btn filled" >최종제출</a>
								</li>
							</ul>
						</div>
					</td>
				</tr>
			</table>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><span id="jobCdTxt" name="jobCdTxt"><span id="jobTitle"></span><span>직무별 필요교육</span></span></li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet3", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>

</body>
</html>
