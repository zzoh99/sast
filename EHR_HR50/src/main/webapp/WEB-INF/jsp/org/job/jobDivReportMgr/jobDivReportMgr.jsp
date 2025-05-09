<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	$(function() {
		//기준일자 날짜형식, 날짜선택 시
		$("#searchBaseDate").datepicker2({
			onReturn:function(){
				doAction1("Search");
			}
		});

		$("#searchBaseDate").on("keyup", function(event) {
			if( event.keyCode == 13) {
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
		
		$("#searchBaseDate").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		init_sheet1();
		init_sheet2();
		
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
				{Header:"조직코드",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"orgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"조직명",		Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    	ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,	Cursor:"Pointer",    TreeCol:1,  LevelSaveName:"sLevel" },
				{Header:"조직장성명",	Type:"Text",      Hidden:0,  Width:80,   Align:"Left",  	ColMerge:0,   SaveName:"chiefName",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
				{Header:"최종갱신일",	Type:"Date",      Hidden:0,  Width:80,   Align:"Left",  	ColMerge:0,   SaveName:"lastYmd",      Format:"Ymd", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
				{Header:"출력",			Type:"Html",	  Hidden:0,	 Width:50,	 Align:"Center",	ColMerge:0,	  SaveName:"btnPrt",	   KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"chiefSabun"},
				{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"rk"}
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	}
	
	// sheet2 부서원 직무분장표
	function init_sheet2(){
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7};	// ColMerge=1 하면 merge 됨
// 		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"Hidden",			Type:"Text",   Hidden:1, SaveName:"sabun"},
			{Header:"세부\n내역",		Type:"Image",		Hidden:0,	Width:10,	Align:"Center",	ColMerge:1,	SaveName:"detail",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			
			{Header:"성명",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"직책",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"직위",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"대표직무",		Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:1,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"직무",			Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"적용일자",		Type:"Date",	Hidden:0, 	Width:20,	Align:"Center", ColMerge:0, SaveName:"applyYmd",	Format:"Ymd",	Edit:0 },
			{Header:"최종갱신일",	Type:"Date",	Hidden:0, 	Width:20,	Align:"Center", ColMerge:1, SaveName:"applYmd",		Format:"Ymd",	Edit:0 },
			
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"orgCd"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"}
			
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");
		
		sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet2.SetDataLinkMouse("detail",1);
		
		// 콥보 리스트
		/* ########################################################################################################################################## */
		var jobCdParam = "&searchJobType=10030&codeType=1";
		var jobCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		sheet2.SetColProperty("jobCd", {ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );
		sheet2.SetColProperty("jobNm", {ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );
		/* ########################################################################################################################################## */

	}
	
	function doAction1(sAction) {
		switch (sAction) {
			// 조직도 조회
			case "Search": 	 	
				var sXml = sheet1.DoSearch( "${ctx}/JobDivReportMgr.do?cmd=getJobDivReportMgrList", $("#sheetForm").serialize() );
				sheet1.LoadSearchData(sXml);
				break;
		}
	}
	
	// sheet1 이벤트 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			$('#searchOrgCd').val(sheet1.GetCellValue(1,"orgCd"));
			getSheetData();
			sheetResize();
			
			if(sheet1.RowCount() > 0) {
				for(var i = 1; i < sheet1.RowCount()+2; i++) {
					sheet1.SetCellValue(i, "btnPrt", '<a class="basic" onclick="showRdPopup('+i+')">출력</a>');
				}
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			$('#searchOrgCd').val(sheet1.GetCellValue(Row,"orgCd"));
		    if(Row > 0){
		    	doAction2("Search");
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	function getSheetData(){
		doAction2("Search");
	}
	
	function doAction2(sAction) {
		
		switch (sAction) {
			
			case "Search":
				
				var row = sheet1.GetSelectRow();
				if(row == 0) {
					return;
				}
				
				$('#orgCd').val(sheet1.GetCellValue(row,"orgCd"));
				
				var sXml = sheet1.GetSearchData("${ctx}/JobDivReportApp.do?cmd=getJobRegAppList2", $("#sheetForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet2.LoadSearchData(sXml);
				break;
			case "Down2Excel":	
				//삭제/상태/hidden 지우고 엑셀내려받기
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
				break;
		}
	}
	
	// sheet2 이벤트 조회 후 에러 메시지
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
		$('#searchOrgCd').val(sheet1.GetCellValue(selectPosition,"orgCd"));
		getSheetData();
	}
	
	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet2.HeaderRows() ) return;
			
		    if( sheet2.ColSaveName(Col) == "detail" ) {
		    	showApplPopup( Row );
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopup( Row ) {
		if(!isPopup()) {return;}
		
		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}" 
		  , applYmd = "${curSysYyyyMMdd}"
		  , url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer'
		  , sabun = "";
		
		args["applStatusCd"] = "11";
		
		if( Row > -1  ){
			if(sheet2.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet2.GetCellValue(Row,"applSeq");
			applInSabun = sheet2.GetCellValue(Row,"applInSabun");
			applYmd     = sheet2.GetCellValue(Row,"applYmd");
			args["applStatusCd"] = sheet2.GetCellValue(Row, "applStatusCd");
			sabun = sheet2.GetCellValue(Row, "sabun");
			initFunc = 'initResultLayer';
		}
		
		var p = {
				searchApplCd: '180'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: sabun
			  , searchApplYmd: applYmd 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '담당직무신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {

					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}
	
	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(Row){
		
		if(!isPopup()) {return;}

  		var w 		= 800;
		var h 		= 900;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		
		var rdParam = "";
		
		rdParam = "[${ssnEnterCd}]"
				+ "["+$('#searchBaseDate').val()+"]"			/* 기준일 3 */
				+ "["+sheet1.GetCellValue(Row,"orgCd")+"]"		/* 조직코드 4 */
				+ "["+sheet1.GetCellValue(Row,"orgNm")+"]"		/* 조직명 5 */
				+ "["+sheet1.GetCellValue(Row,"chiefName")+"]"	/* 조직장성명 6 */
				+ "[${baseURL}]"
				+ "["+sheet1.GetCellValue(Row,"chiefSabun")+"]";	/* 조직장사번 8 */
				
				
// 		/rp [BS][20200828][BS00000][경영지원팀][양승종][http://210.181.93.68][20030002]
		
		args["rdTitle"]      = "조직" ;	//rd Popup제목
		args["rdMrd"] = "hrm/job/OrgJob.mrd" ;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] 	 = rdParam; //rd파라매터
		args["rdParamGubun"] = "rp";		//파라매터구분(rp/rv)
		args["rdToolBarYn"]  = "Y";			//툴바여부
		args["rdZoomRatio"]  = "100";		//확대축소비율

		args["rdSaveYn"] 	 = "Y";			//기능컨트롤_저장
		args["rdPrintYn"] 	 = "Y";			//기능컨트롤_인쇄
		args["rdExcelYn"] 	 = "Y";			//기능컨트롤_엑셀
		args["rdWordYn"] 	 = "Y";			//기능컨트롤_워드
		args["rdPptYn"] 	 = "Y";			//기능컨트롤_파워포인트
		args["rdHwpYn"] 	 = "Y";			//기능컨트롤_한글
		args["rdPdfYn"] 	 = "Y";			//기능컨트롤_PDF

		gPRow  = "";
		pGubun = "rdPopup";
		
		openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}

	function showRdPopup(Row) {
		var Row = Row;
		const data = {
			rk : sheet1.GetCellValue(Row, 'rk'),
			type : 1
		};

		window.top.showRdLayer('/JobDivReportMgr.do?cmd=getEncryptRd', data, null, "조직");
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	
	<form name="sheetForm" id="sheetForm" method="post">
		<input type="hidden" id="orgCd" name="orgCd">
		<input type="hidden" id="searchOrgCd" name="searchOrgCd">
		<input type="hidden" id="type" name="type" value="1">
		
		<div class="sheet_search outer">
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
					<li class="txt">부서원 직무분장표</li>
					<li class="btn">
						<a href="javascript:doAction2('Down2Excel')" 	class="btn outline_gray" >다운로드</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocalCd}"); </script>
		</td>
	</tr>
</table>
</div>
</body>
</html>
