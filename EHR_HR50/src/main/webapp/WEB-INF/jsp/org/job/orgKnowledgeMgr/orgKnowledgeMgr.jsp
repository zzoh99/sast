<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>조직의지식조회</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">

	$(function() {
		// 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
		initIbFileUpload($("#sheetForm"));

		// 파일 목록 변수의 초기화 작업 시점 정의
		// clearBeforeFunc(function object)
		// 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
		//		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
		//	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
		sheet2_OnSearchEnd = clearBeforeFunc(sheet2_OnSearchEnd);
		sheet2_OnSaveEnd = clearBeforeFunc(sheet2_OnSaveEnd)


		//기준일자 날짜형식, 날짜선택 시
		$("#searchBaseDate").datepicker2({
			onReturn:function(){
				doAction1("Search");
			}
		});

		$("#searchBaseDate").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		// 트리레벨 정의
		$("#btnPlus").toggleClass("minus");

		$("#btnPlus").click(function() {
			//sheet1.ShowTreeLevel(-1);
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet1.ShowTreeLevel(-1):sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep1").click(function()	{
			//sheet1.ShowTreeLevel(0, 1);
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(0, 2);
		});
		$("#btnStep2").click(function()	{
			//sheet1.ShowTreeLevel(1,2);
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(2,3);
		});
		$("#btnStep3").click(function()	{
			//sheet1.ShowTreeLevel(-1);
			if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				sheet1.ShowTreeLevel(-1);
			}
		});
		
		$("#findText").bind("keyup",function(event){
	    	if( event.keyCode == 13){ findOrgNm() ; }
	    });
		
		//Sheet 초기화
		init_sheet1();
		init_sheet2();
		
		$("#searchBaseDate").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
	});
	
	// sheet1 조직도
	function init_sheet1() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
				{Header:"No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"조직코드",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"조직명",		Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,	Cursor:"Pointer",    TreeCol:1,  LevelSaveName:"sLevel" },
				{Header:"조직장성명",	Type:"Text",      Hidden:0,  Width:80,    Align:"Left",  ColMerge:0,   SaveName:"chiefName",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
				{Header:"최종갱신일",	Type:"Date",      Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"lastYmd",    Format:"Ymd", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	}

	//Sheet 초기화
	function init_sheet2(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0, FrozenColRight:0};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
			
			{Header:"부서|부서",				Type:"Combo",		Hidden:1,	Width:30,	Align:"Left",	ColMerge:0,	SaveName:"orgCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직무|직무",				Type:"Combo",		Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"필요지식|필요지식", 		Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"knowledge"	,KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4000 },
			{Header:"문서화된 정보|문서화된 정보", Type:"Text",		Hidden:0,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"docInfo"		,KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"저장\n매체|저장\n매체", 	Type:"Combo",		Hidden:0,	Width:25,	Align:"Center",	ColMerge:0,	SaveName:"storageType"	,KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },	
			
			{Header:"접근권한|전체",			Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthAll",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"접근권한|전사",			Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthComp",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"접근권한|본부",			Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthHq",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"접근권한|팀",				Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthTeam",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"접근권한|직무\n유관",		Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthRelate",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			{Header:"접근권한|직무\n담당",		Type:"CheckBox",Hidden:0, 	Width:15 , 	Align:"Center",	ColMerge:0,	SaveName:"accessAuthCharge",	KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			
			{Header:"최신정보\n확보계획|최신정보\n확보계획",Type:"Text",		Hidden:0,	Width:20,	Align:"Left",	ColMerge:0,	SaveName:"infoPlan",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },	
			{Header:"첨부파일|첨부파일",					Type:"Html",		Hidden:0,	Width:20,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		Edit:0 },
			
			{Header:"Hidden",	Hidden:1, SaveName:"sdate" },
			{Header:"Hidden",	Hidden:1, SaveName:"udate" },
			{Header:"Hidden",	Hidden:1, SaveName:"edate" },
			
			{Header:"Hidden",	Hidden:1, SaveName:"fileSeq" },
			{Header:"Hidden",	Hidden:1, SaveName:"seq" }

  		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
  		
  		// 콥보 리스트
		/* ########################################################################################################################################## */
		var orgCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobOrgList", false).codeList
	            , "code,codeNm"
	            , " ");

		sheet2.SetColProperty("orgCd", 		  {ComboText:"|"+orgCd[0], ComboCode:"|"+orgCd[1]} );					   		   //부서
		/* ########################################################################################################################################## */
		
	}

	function getCommonCodeList() {
		let grpCds = "H90014";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchBaseDate").val();
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");

		sheet2.SetColProperty("storageType",  {ComboText:"|"+codeLists["H90014"][0], ComboCode:"|"+codeLists["H90014"][1]} );  //저장매체(H90014)

	}

	//sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			// 조직도 조회
			case "Search":
				clearFileListArr('sheet2'); // 파일 목록 변수의 초기화
				getCommonCodeList();
				var sXml = sheet1.DoSearch( "${ctx}/JobDivReportMgr.do?cmd=getJobDivReportMgrList", $("#sheetForm").serialize()+ "&pageType=0"  );
				sheet1.LoadSearchData(sXml);
				break;
		}
	}

	//sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				clearFileListArr('sheet2'); // 파일 목록 변수의 초기화
				fnJobCd();
				
				var sXml = sheet2.GetSearchData("${ctx}/OrgKnowledgeReg.do?cmd=getOrgKnowledgeRegList", $("#sheetForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet2.LoadSearchData(sXml);
	        	break;	
			case "Insert":
				var Row = sheet2.DataInsert(0);
				sheet2.SetCellValue(Row, "orgCd", $("#orgCd").val());
				sheet2.SetCellValue(Row, "sdate", $("#searchBaseDate").val());
				sheet2.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');

				break;
			case "Copy":
				sheet2.SelectCell(sheet2.DataCopy(), 2);
				sheet2.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				sheet2.SetCellValue(Row, "fileSeq", '');
				break;
	        case "Save":
	        	// 중복체크
				if (!dupChk(sheet2, "orgCd|jobCd|knowledge", false, true)) {break;}
	        	
	        	IBS_SaveName(document.sheetForm,sheet2);
				sheet2.DoSave("${ctx}/OrgKnowledgeReg.do?cmd=saveOrgKnowledgeReg", $("#sheetForm").serialize());
				break;
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2, ['Html']);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param); 
				break;
		}
	}
	
	//-----------------------------------------------------------------------------------
	//		sheet2 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

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


	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			
			if( Row < sheet2.HeaderRows() ) return;
			
		    if( sheet2.ColSaveName(Col) == "detail" ) {
		    	showApplPopup( Row );

		    }else if(sheet2.ColSaveName(Col) == "btnFile"){
		    	if(sheet2.GetCellValue(Row,"btnFile") != ""){

					gPRow = Row;
					pGubun = "viewFilePopup";

					let layerModal = new window.top.document.LayerModal({
						id : 'fileMgrLayer'
						, url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&authPg=A'
						, parameters : {
							fileSeq : sheet2.GetCellValue(Row,"fileSeq"),
							fileInfo: getFileList(sheet2.GetCellValue(Row,"fileSeq")) // 파일 목록 동기화 처리를 위함
						}
						, width : 740
						, height : 420
						, title : '파일 업로드'
						, trigger :[
							{
								name : 'fileMgrTrigger'
								, callback : function(result){
									addFileList(sheet2, gPRow, result); // 작업한 파일 목록 업데이트
									if(result.fileCheck == "exist"){
										sheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
										sheet2.SetCellValue(gPRow, "fileSeq", result.fileSeq);
									}else{
										sheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
										sheet2.SetCellValue(gPRow, "fileSeq", "");
									}
								}
							}
						]
					});
					layerModal.show();
				}
		    }else if(sheet2.ColSaveName(Col) == "accessAuthAll"){
		    	if(sheet2.GetCellValue(Row,"accessAuthAll") == "Y"){
		    		sheet2.SetCellValue(Row, "accessAuthComp", "Y");
		    		sheet2.SetCellValue(Row, "accessAuthHq", "Y");
		    		sheet2.SetCellValue(Row, "accessAuthTeam", "Y");
		    		sheet2.SetCellValue(Row, "accessAuthRelate", "Y");
		    		sheet2.SetCellValue(Row, "accessAuthCharge", "Y");
		    	}else{
		    		sheet2.SetCellValue(Row, "accessAuthComp", "N");
		    		sheet2.SetCellValue(Row, "accessAuthHq", "N");
		    		sheet2.SetCellValue(Row, "accessAuthTeam", "N");
		    		sheet2.SetCellValue(Row, "accessAuthRelate", "N");
		    		sheet2.SetCellValue(Row, "accessAuthCharge", "N");
		    	}
		    	
		    }else if(sheet2.ColSaveName(Col) == "accessAuthComp"){
		    	if(sheet2.GetCellValue(Row,"accessAuthComp") == "Y"){
		    		sheet2.SetCellValue(Row, "accessAuthAll", "N");
		    		sheet2.SetCellValue(Row, "accessAuthHq", "Y");
		    		sheet2.SetCellValue(Row, "accessAuthTeam", "Y");
		    		sheet2.SetCellValue(Row, "accessAuthRelate", "Y");
		    		sheet2.SetCellValue(Row, "accessAuthCharge", "Y");
		    	}else{
		    		sheet2.SetCellValue(Row, "accessAuthAll", "N");
		    		sheet2.SetCellValue(Row, "accessAuthHq", "N");
		    		sheet2.SetCellValue(Row, "accessAuthTeam", "N");
		    		sheet2.SetCellValue(Row, "accessAuthRelate", "N");
		    		sheet2.SetCellValue(Row, "accessAuthCharge", "N");
		    	}
		    }else if(sheet2.ColSaveName(Col) == "accessAuthHq"){
		    	if(sheet2.GetCellValue(Row,"accessAuthHq") == "Y"){
		    		sheet2.SetCellValue(Row, "accessAuthAll", "N");
		    		sheet2.SetCellValue(Row, "accessAuthComp", "N");
		    		sheet2.SetCellValue(Row, "accessAuthTeam", "Y");
		    		sheet2.SetCellValue(Row, "accessAuthRelate", "Y");
		    		sheet2.SetCellValue(Row, "accessAuthCharge", "Y");
		    	}else{
		    		sheet2.SetCellValue(Row, "accessAuthAll", "N");
		    		sheet2.SetCellValue(Row, "accessAuthComp", "N");
		    		sheet2.SetCellValue(Row, "accessAuthTeam", "N");
		    		sheet2.SetCellValue(Row, "accessAuthRelate", "N");
		    		sheet2.SetCellValue(Row, "accessAuthCharge", "N");
		    	}
		    }else if(sheet2.ColSaveName(Col) == "accessAuthTeam"){
		    	if(sheet2.GetCellValue(Row,"accessAuthTeam") == "Y"){
		    		sheet2.SetCellValue(Row, "accessAuthAll", "N");
		    		sheet2.SetCellValue(Row, "accessAuthComp", "N");
		    		sheet2.SetCellValue(Row, "accessAuthHq", "N");
		    		sheet2.SetCellValue(Row, "accessAuthRelate", "Y");
		    		sheet2.SetCellValue(Row, "accessAuthCharge", "Y");
		    	}else{
		    		sheet2.SetCellValue(Row, "accessAuthAll", "N");
		    		sheet2.SetCellValue(Row, "accessAuthComp", "N");
		    		sheet2.SetCellValue(Row, "accessAuthHq", "N");
		    		sheet2.SetCellValue(Row, "accessAuthRelate", "N");
		    		sheet2.SetCellValue(Row, "accessAuthCharge", "N");
		    	}
		    }else if(sheet2.ColSaveName(Col) == "accessAuthRelate"){
		    	if(sheet2.GetCellValue(Row,"accessAuthRelate") == "Y"){
		    		sheet2.SetCellValue(Row, "accessAuthAll", "N");
		    		sheet2.SetCellValue(Row, "accessAuthComp", "N");
		    		sheet2.SetCellValue(Row, "accessAuthHq", "N");
		    		sheet2.SetCellValue(Row, "accessAuthTeam", "N");
		    		sheet2.SetCellValue(Row, "accessAuthCharge", "Y");
		    	}else{
		    		sheet2.SetCellValue(Row, "accessAuthAll", "N");
		    		sheet2.SetCellValue(Row, "accessAuthComp", "N");
		    		sheet2.SetCellValue(Row, "accessAuthHq", "N");
		    		sheet2.SetCellValue(Row, "accessAuthTeam", "N");
		    		sheet2.SetCellValue(Row, "accessAuthCharge", "N");
		    	}
		    }else if(sheet2.ColSaveName(Col) == "accessAuthCharge"){
		    	if(sheet2.GetCellValue(Row,"accessAuthCharge") == "Y"){
		    		sheet2.SetCellValue(Row, "accessAuthAll", "N");
		    		sheet2.SetCellValue(Row, "accessAuthComp", "N");
		    		sheet2.SetCellValue(Row, "accessAuthHq", "N");
		    		sheet2.SetCellValue(Row, "accessAuthTeam", "N");
		    		sheet2.SetCellValue(Row, "accessAuthRelate", "N");
		    	}else{
		    		sheet2.SetCellValue(Row, "accessAuthAll", "N");
		    		sheet2.SetCellValue(Row, "accessAuthComp", "N");
		    		sheet2.SetCellValue(Row, "accessAuthHq", "N");
		    		sheet2.SetCellValue(Row, "accessAuthTeam", "N");
		    		sheet2.SetCellValue(Row, "accessAuthRelate", "N");
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
				sheet2.SetCellValue(gPRow, "btnFile", '<a class="basic">다운로드</a>');
				sheet2.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet2.SetCellValue(gPRow, "btnFile", '<a class="basic">첨부</a>');
				sheet2.SetCellValue(gPRow, "fileSeq", "");
			}
		}
	}
	
	/*엔터검색 by JSG*/
	function findOrgNm() {
		var startRow = sheet1.GetSelectRow()+1 ;
		startRow = (startRow >= sheet1.LastRow() ? 1 : startRow ) ;
		var selectPosition = sheet1.FindText("orgNm", $("#findText").val(), startRow, 2) ;
		if(selectPosition == -1) {
			sheet1.SetSelectRow(1) ;
			alert("<msg:txt mid='alertOrgTotalMgrV2' mdef='마지막에 도달하여 최상단으로 올라갑니다.'/>") ;
		} else {
			sheet1.SetSelectRow(selectPosition) ;
		}
		$('#orgCd').val(sheet1.GetCellValue(selectPosition,"orgCd"));
		getSheetData();
	}
	
	// sheet1 이벤트 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			$('#orgCd').val(sheet1.GetCellValue(1,"orgCd"));
			getSheetData();
			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			$('#orgCd').val(sheet1.GetCellValue(Row,"orgCd"));
// 		    if(Row > 0 && sheet1.ColSaveName(Col) == "orgNm"){
		    	doAction2("Search");
// 		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	function getSheetData(){
		
		var row = sheet1.GetSelectRow();
		
		doAction2("Search");
	}
	
	function fnJobCd(){
		
		var row = sheet1.GetSelectRow();
		
		var jobCdParam = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"+"&orgCd="+sheet1.GetCellValue(row,"orgCd"), "queryId=getJobCdList2", false).codeList
	            , "code,codeNm"
	            , " ");
	   	
		sheet2.SetColProperty("jobCd", 		  {ComboText:"|"+jobCdParam[0], ComboCode:"|"+jobCdParam[1]} );					   //직무코드
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	
	<form id="sheetForm" name="sheetForm" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<input type="hidden" id="searchTitleYn" name="searchTitleYn" value="Y"/>
		<input type="hidden" id="orgCd" name="orgCd">
		
		<div class="sheet_search sheet_search_s outer">
			<div>
				<table>
					<tr>
						<th>기준일</th> 
						<td>
							<input type="text" class="text date2" id="searchBaseDate" name="searchBaseDate" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="30%" />
		<col width="70%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="sheet_title inner">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='112713' mdef='조직도 '/>&nbsp;
						<div class="util">
						<ul>
							<li	id="btnPlus"></li>
							<li	id="btnStep1"></li>
							<li	id="btnStep2"></li>
							<li	id="btnStep3"></li>
						</ul>
						</div>
					</li>
					<li class="btn">
						<tit:txt mid='201705020000185' mdef='명칭검색'/>
						<input id="findText" name="findText" type="text" class="text" class="text" >
					</li>
					<li class="btn">
					</li>
				</ul>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
				<li class="txt">조직의 지식</li>
				<li class="btn">
					<a href="javascript:doAction2('Down2Excel')"	class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
					<a href="javascript:doAction2('Copy')" 			class="btn outline_gray authA"><tit:txt mid='104335' mdef='복사'/></a>
					<a href="javascript:doAction2('Insert')" 		class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
					<a href="javascript:doAction2('Save')" 			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
				</li>
			</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocalCd}"); </script>
		</td>
	</tr>
</table>

</body>
</html>
