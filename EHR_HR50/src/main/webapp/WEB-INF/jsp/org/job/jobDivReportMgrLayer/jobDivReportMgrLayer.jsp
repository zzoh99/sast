<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<script type="text/javascript">

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('jobDivReportMgrLayer');
		var arg = modal.parameters;

		createIBSheet3(document.getElementById('jobDivReportMgrLayerSht1-wrap'), "jobDivReportMgrLayerSht1", "100%", "100%","${ssnLocaleCd}");
		createIBSheet3(document.getElementById('jobDivReportMgrLayerSht2-wrap'), "jobDivReportMgrLayerSht2", "100%", "100%","${ssnLocaleCd}");


		// 트리레벨 정의
		$("#btnPlus").toggleClass("minus");

		$("#btnPlus").click(function() {
			//jobDivReportMgrLayerSht1.ShowTreeLevel(-1);
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?jobDivReportMgrLayerSht1.ShowTreeLevel(-1):jobDivReportMgrLayerSht1.ShowTreeLevel(0, 1);
		});
		$("#btnStep1").click(function()	{
			//jobDivReportMgrLayerSht1.ShowTreeLevel(0, 1);
			$("#btnPlus").removeClass("minus");
			jobDivReportMgrLayerSht1.ShowTreeLevel(0, 2);
		});
		$("#btnStep2").click(function()	{
			//jobDivReportMgrLayerSht1.ShowTreeLevel(1,2);
			$("#btnPlus").removeClass("minus");
			jobDivReportMgrLayerSht1.ShowTreeLevel(2,3);
		});
		$("#btnStep3").click(function()	{
			//jobDivReportMgrLayerSht1.ShowTreeLevel(-1);
			if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				jobDivReportMgrLayerSht1.ShowTreeLevel(-1);
			}
		});
		
		$("#findText").bind("keyup",function(event){
	    	if( event.keyCode == 13){ findOrgNm() ; }
	    });
		
		init_jobDivReportMgrLayerSht1();
		init_jobDivReportMgrLayerSht2();
		
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
	});
	
	// jobDivReportMgrLayerSht1 조직도
	function init_jobDivReportMgrLayerSht1() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
				{Header:"No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"조직코드",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"조직명",		Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,	Cursor:"Pointer",    TreeCol:1,  LevelSaveName:"sLevel" },
				{Header:"조직장성명",	Type:"Text",      Hidden:0,  Width:80,    Align:"Left",  ColMerge:0,   SaveName:"chiefName",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
				{Header:"최종갱신일",	Type:"Date",      Hidden:0,  Width:80,    Align:"Left",  ColMerge:0,   SaveName:"lastYmd",    Format:"Ymd", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			
			]; IBS_InitSheet(jobDivReportMgrLayerSht1, initdata);jobDivReportMgrLayerSht1.SetVisible(true);jobDivReportMgrLayerSht1.SetCountPosition(4);
	}
	
	// jobDivReportMgrLayerSht2 부서원 직무분장표
	function init_jobDivReportMgrLayerSht2(){
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7};	// ColMerge=1 하면 merge 됨
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"Hidden",			Type:"Text",   		Hidden:1, SaveName:"sabun"},
			{Header:"세부\n내역",		Type:"Image",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"detail",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			
			{Header:"성명",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"직책",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"직위",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"대표직무",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"직무",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종갱신일",	Type:"Date",	Hidden:1, 	Width:80,	Align:"Center", ColMerge:1, SaveName:"applYmd",		Format:"Ymd",	Edit:0 },
			
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"orgCd"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"jobCdNm"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"orgNm"}
			
		]; IBS_InitSheet(jobDivReportMgrLayerSht2, initdata1);jobDivReportMgrLayerSht2.SetEditable("${editable}");
		
		jobDivReportMgrLayerSht2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		jobDivReportMgrLayerSht2.SetDataLinkMouse("detail",1);
		
		// 콥보 리스트
		/* ########################################################################################################################################## */
		var jobCdParam = "&searchJobType=10030&codeType=1";
		var jobCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		jobDivReportMgrLayerSht2.SetColProperty("jobCd", {ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );
		jobDivReportMgrLayerSht2.SetColProperty("jobNm", {ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );
		/* ########################################################################################################################################## */

	}
	
	function doAction1(sAction) {
		switch (sAction) {
			// 조직도 조회
			case "Search": 	 	
				var sXml = jobDivReportMgrLayerSht1.DoSearch( "${ctx}/JobDivReportMgr.do?cmd=getJobDivReportMgrList", $("#jobDivReportMgrLayerForm").serialize() );
				jobDivReportMgrLayerSht1.LoadSearchData(sXml);
				break;
		}
	}
	
	// jobDivReportMgrLayerSht1 이벤트 조회 후 에러 메시지
	function jobDivReportMgrLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			$('#searchOrgCd').val(jobDivReportMgrLayerSht1.GetCellValue(1,"orgCd"));
			getSheetData();
			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function jobDivReportMgrLayerSht1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			$('#searchOrgCd').val(jobDivReportMgrLayerSht1.GetCellValue(Row,"orgCd"));
// 		    if(Row > 0 && jobDivReportMgrLayerSht1.ColSaveName(Col) == "orgNm"){
		    	doAction2("Search");
// 		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	function getSheetData(){
		doAction2("Search");
	}
	
	function doAction2(sAction) {
		
		switch (sAction) {
			
			case "Search":
				
				var row = jobDivReportMgrLayerSht1.GetSelectRow();
				if(row == 0) {
					return;
				}
				
				$('#orgCd').val(jobDivReportMgrLayerSht1.GetCellValue(row,"orgCd"));
				
				var sXml = jobDivReportMgrLayerSht1.GetSearchData("${ctx}/JobDivReportApp.do?cmd=getJobRegAppList2", $("#jobDivReportMgrLayerForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				jobDivReportMgrLayerSht2.LoadSearchData(sXml);
				break;
			case "Down2Excel":	
				//삭제/상태/hidden 지우고 엑셀내려받기
				var downcol = makeHiddenSkipCol(jobDivReportMgrLayerSht2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				jobDivReportMgrLayerSht2.Down2Excel(param);
				break;
		}
	}
	
	// jobDivReportMgrLayerSht2 이벤트 조회 후 에러 메시지
	function jobDivReportMgrLayerSht2_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
		var startRow = jobDivReportMgrLayerSht1.GetSelectRow()+1 ;
		startRow = (startRow >= jobDivReportMgrLayerSht1.LastRow() ? 1 : startRow ) ;
		var selectPosition = jobDivReportMgrLayerSht1.FindText("orgNm", $("#findText").val(), startRow, 2) ;
		if(selectPosition == -1) {
			jobDivReportMgrLayerSht1.SetSelectRow(1) ;
			alert("<msg:txt mid='alertOrgTotalMgrV2' mdef='마지막에 도달하여 최상단으로 올라갑니다.'/>") ;
		} else {
			jobDivReportMgrLayerSht1.SetSelectRow(selectPosition) ;
		}
		$('#searchOrgCd').val(jobDivReportMgrLayerSht1.GetCellValue(selectPosition,"orgCd"));
		getSheetData();
	}
	
	// 셀 클릭시 발생
	function jobDivReportMgrLayerSht2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < jobDivReportMgrLayerSht2.HeaderRows() ) return;
			
		    if( jobDivReportMgrLayerSht2.ColSaveName(Col) == "detail" ) {
		    	showApplPopup( Row );
		    }else if( jobDivReportMgrLayerSht2.ColSaveName(Col) == "btnDel" && Value != ""){
				jobDivReportMgrLayerSht2.SetCellValue(Row, "sStatus", "D");
// 				doAction1("Save");
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
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer';
		
		args["applStatusCd"] = "11";
		
		if( Row > -1  ){
			if(jobDivReportMgrLayerSht2.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = jobDivReportMgrLayerSht2.GetCellValue(Row,"applSeq");
			applInSabun = jobDivReportMgrLayerSht2.GetCellValue(Row,"applInSabun");
			applYmd     = jobDivReportMgrLayerSht2.GetCellValue(Row,"applYmd");
			args["applStatusCd"] = jobDivReportMgrLayerSht2.GetCellValue(Row, "applStatusCd");
			initFunc = 'initResultLayer';
		}
		var p = {
				searchApplCd: '180'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applInSabun
			  , searchApplYmd: applYmd 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '근태신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}
	
	function jobDivReportMgrLayerSht2_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		}
		catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}
	
	function returnFindUser(Row,Col){
		
	    if(jobDivReportMgrLayerSht2.RowCount() <= 0) {
	    	return;
	    }

    	var returnValue = new Array(1);
    	
    	var row = jobDivReportMgrLayerSht2.GetSelectRow();
		if(row == 0) {
			return;
		}
		
		returnValue["jobCd"] = jobDivReportMgrLayerSht2.GetCellValue(row,"jobCd");
		returnValue["jobCdNm"] = jobDivReportMgrLayerSht2.GetCellValue(row,"jobCdNm");
		returnValue["orgNm"] = jobDivReportMgrLayerSht2.GetCellValue(row,"orgNm");
		returnValue["orgCd"] = jobDivReportMgrLayerSht2.GetCellValue(row,"orgCd");

		const modal = window.top.document.LayerModalUtility.getModal('jobDivReportMgrLayer');
		modal.fire('jobDivReportMgrLayerTrigger', returnValue).hide();
	}

</script>
</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
		<div class="modal_body ">
		<form name="jobDivReportMgrLayerForm" id="jobDivReportMgrLayerForm" method="post">
			<input type="hidden" id="orgCd" name="orgCd">
			<input type="hidden" id="searchOrgCd" name="searchOrgCd">
			<input type="hidden" id="jobCd" name="jobCd">
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<colgroup>
				<col width="40%" />
				<col width="60%" />
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
					<div id="jobDivReportMgrLayerSht1-wrap"></div>
				</td>
			
				<td class="sheet_right">
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt">부서원 직무분장표</li>
							<li class="btn" style="display: none;">
								<a href="javascript:doAction2('Down2Excel')" 	class="basic" >다운로드</a>
							</li>
						</ul>
						</div>
					</div>
					<div id="jobDivReportMgrLayerSht2-wrap"></div>
				</td>
			</tr>
		</table>
        </div>

		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('jobDivReportMgrLayer');" css="gray large" mid='110881' mdef="닫기"/>
		</div>
    </div>
</body>
</html>