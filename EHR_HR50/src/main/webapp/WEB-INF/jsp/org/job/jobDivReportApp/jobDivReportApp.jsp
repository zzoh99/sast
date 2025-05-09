<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>직무분장보고</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">

	$(function() {
		
		//Sheet 초기화
		init_sheet();
		
		//사번셋팅
		setEmpPage();
 		
		// 기간 default 값
		$("#searchFromApplYmd").val("${curSysYear}");
		$("#searchToApplYmd").val("${curSysYear}");

		// 숫자만 입력가능
		$("#searchFromApplYmd, searchToApplYmd").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

	});
	
	
	function init_sheet(){
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7};	// ColMerge=1 하면 merge 됨
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='ibsImageV3' mdef='세부내역' />",		Type:"Image",		Hidden:0,	Width:10,	Align:"Center",	ColMerge:1,	SaveName:"detail",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },

			{Header:"<sht:txt mid='name' 		  mdef='성명' />",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='jikchakNm' mdef='직책'/>",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='mainJobCd' mdef='대표직무'/>",		Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:1,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='jobNm'       mdef='직무'  />",			Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='applyYy' mdef='적용일'/>",		Type:"Date",	Hidden:0, 	Width:20,	Align:"Center", ColMerge:0, SaveName:"applyYmd",	Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='lastUdtDate' mdef='최종갱신일'/>",	Type:"Date",	Hidden:0, 	Width:20,	Align:"Center", ColMerge:0, SaveName:"applYmd",		Format:"Ymd",	Edit:0 },

			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"orgCd"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applStatusCd"}
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"<sht:txt mid='ibsImageV3' mdef='세부내역' />",		Type:"Image",		Hidden:0,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,    Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,    Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"Html",		Hidden:0,	 Width:10,              Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },

			{Header:"<sht:txt mid='applYmdV6' mdef='신청일자' />",		Type:"Date",	Hidden:0, 	Width:20,	Align:"Center",  ColMerge:0, SaveName:"applYmd",		Format:"Ymd",	Edit:0 },		// 없음
			{Header:"<sht:txt mid='applStatusNm' mdef='신청상태' />",		Type:"Combo",	Hidden:0, 	Width:20,	 Align:"Center", ColMerge:0, SaveName:"applStatusCd",	Format:"",		Edit:0 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",			Type:"Text",	Hidden:0, 	Width:30,	 Align:"Left", ColMerge:0, SaveName:"orgNm",			Format:"",		Edit:0 },
			{Header:"<sht:txt mid='applyYy' mdef='적용일'/>",		Type:"Date",	Hidden:0, 	Width:20,	Align:"Center", ColMerge:0, SaveName:"applyYmd",	Format:"Ymd",	Edit:0 },
			
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"jobApplSeq"}
			
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetDataLinkMouse("detail",1);
		sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet2.SetDataLinkMouse("detail",1);
 		
 		// 콥보 리스트
		/* ########################################################################################################################################## */
		var orgCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"+"&searchApplSabun="+$("#searchUserId").val(), "queryId=getJobOrgCdList", false).codeList
	            , "code,codeNm"
	            , " ");
		
		var jobCdParam = "&searchJobType=10030&codeType=1";
		var jobCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		var grpCds = "R10010";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
		sheet2.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );//  신청상태
		
		sheet1.SetColProperty("jobCd", {ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );
		sheet1.SetColProperty("jobNm", {ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );
		$("#orgCd").html(orgCdList[2]);
		/* ########################################################################################################################################## */
 		
	}

	function checkList(){
		if( $("#searchFromApplYmd").val().length != 4 && $("#searchFromApplYmd").val().length != 0 ){
			alert("<msg:txt mid='alertReqYear' mdef='신청년도를 정확히 입력해주세요.'/>");
			$("#searchFromApplYmd").focus();
			return false;
		}

		if( $("#searchToApplYmd").val().length != 4 && $("#searchToApplYmd").val().length != 0 ){
			alert("<msg:txt mid='alertReqYear' mdef='신청년도를 정확히 입력해주세요.'/>");
			$("#searchToApplYmd").focus();
			return false;
		}

		var from = $("#searchFromApplYmd").val();
		var to = $("#searchToApplYmd").val();
		if (parseInt(from) > parseInt(to)) {
			alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
			$("#searchFromApplYmd").focus();
			return false;
		}

		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if( !checkList() ) return;
				var sXml = sheet1.GetSearchData("${ctx}/JobDivReportApp.do?cmd=getJobRegAppList2", $("#sheetForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet1.LoadSearchData(sXml);
				
				var sXml = sheet2.GetSearchData("${ctx}/JobDivReportApp.do?cmd=getJobDivReportAppList", $("#sheetForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet2.LoadSearchData(sXml);
				
	        	break;	
			case "Save": //임시저장의 경우 삭제처리.      
				if( !confirm('<msg:txt mid="alertDelete" mdef="삭제하시겠습니까?" />')) { initDelStatus(sheet2); return;}
	       		IBS_SaveName(document.sheetForm,sheet2);
	        	sheet2.DoSave( "${ctx}/JobDivReportApp.do?cmd=deleteJobDivReportApp", $("#sheetForm").serialize(), -1, 0); 
	        	break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
				break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{

			var saveName = sheet1.ColSaveName(NewCol);
			
			if( OldRow != NewRow && saveName == "detail" ) {
				$("#searchTableNameHidden").val(sheet1.GetCellValue(NewRow, "tableName"));
				doAction1("Search");
			}

	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
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

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	lShowApplPopup( Row );
		    }else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet2.HeaderRows() ) return;
			
		    if( sheet2.ColSaveName(Col) == "detail" ) {
		    	showApplPopup( Row );
		    }else if( sheet2.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet2.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
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
		
		if(sheet1.GetCellValue(Row,"applSeq") == ""){
			alert("<msg:txt mid='jobDivReportAppMsg1' mdef='부서원 직무분장표 등록 해 주세요.'/>")
			return;
		}
		
		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}" 
		  , applYmd = "${curSysYyyyMMdd}"
		  , url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , searchFromApplYmd = $("#searchFromApplYmd").val() 
		  , searchToApplYmd = $("#searchToApplYmd").val()
		  , orgCd = $("#orgCd").val()
		  , apply = 1
		  , initFunc = 'initLayer';
		  
		args["applStatusCd"] = "11";
		if( Row > -1  ){
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet2.GetCellValue(Row,"applSeq");
			applInSabun = sheet2.GetCellValue(Row,"applInSabun");
			applYmd     = sheet2.GetCellValue(Row,"applYmd");
			apply = 2;
			initFunc = 'initResultLayer';
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}

		var p = {
				searchApplCd: '182'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			  , etc01: searchFromApplYmd+"/"+searchToApplYmd+"/"+orgCd
			  , etc02: apply
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
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}
	
	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	
	function lShowApplPopup( Row ) {
		
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
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			initFunc = 'initResultLayer';
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
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
			title: '직무분장보고',
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
	
	//신청 팝업에서  리턴
	function getReturnValue(returnValue) {
		doAction1("Search");
	}
	
	//인사헤더에서 이름 변경 시 호출 됨 
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	
    	var orgCdList = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"+"&searchApplSabun="+$("#searchSabun").val(), "queryId=getJobOrgCdList", false).codeList
            , "code,codeNm"
            , " ");
    	
    	$("#orgCd").html(orgCdList[2]);
    	
    	$("#orgCd option:eq(1)").prop("selected", true);
    	
    	doAction1("Search");
    }
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	
	<form name="sheetForm" id="sheetForm" method="post">
		<input type="hidden" id="searchTableNameHidden" name="searchTableNameHidden">
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th><tit:txt mid='reqYear' mdef='신청년도'/></th>
					<td>
						<input type="text" class="text date2" id="searchFromApplYmd" name="searchFromApplYmd" maxlength="4"/>
						~
						<input type="text" class="text date2" id="searchToApplYmd" name="searchToApplYmd" maxlength="4"/>
					</td>
					<th><tit:txt mid='113441' mdef='부서'/></th>
					<td>
						<select id="orgCd" name="orgCd"></select>
					</td>
					<td><a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a></td>
				</tr>
			</table>
			</div>
		</div>
	</form>

<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="50%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='deptJob' mdef='부서원 직무분장표'/></li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocalCd}"); </script>
		</td>
	
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='jobDivReport' mdef='직무분장보고'/></li>
					<li class="btn">
						<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray" >다운로드</a>
						<a href="javascript:showApplPopup(-1);" 		class="btn filled" >신청</a>
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
