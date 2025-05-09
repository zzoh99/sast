<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head><title>교육취소신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		$("#searchSYmd").datepicker2({startdate:"searchEYmd"});
		$("#searchEYmd").datepicker2({enddate:"searchSYmd"});

		$("#searchSYmd, #searchEYmd").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		init_sheet();
		
		setEmpPage();
	});

	//시트 초기화
	function init_sheet(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",  Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",			Type:"${sDelTy}", Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",			Type:"${sSttTy}", Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='eduCourseNmV4' mdef='교육과정명|교육과정명'/>",  	Type:"Text",    Hidden:0, Width:250, Align:"Left",   ColMerge:1, SaveName:"eduCourseNm",  	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='inOutCdV1' mdef='사내/외\n구분|사내/외\n구분'/>",  	Type:"Combo",   Hidden:0, Width:70,  Align:"Center", ColMerge:1, SaveName:"inOutType",  	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduMethodCd' mdef='시행방법|시행방법'/>",  	Type:"Combo",   Hidden:1, Width:80,  Align:"Center", ColMerge:1, SaveName:"eduMethodCd",  	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduBranchCdV1' mdef='교육구분|교육구분'/>",  	Type:"Combo",   Hidden:0, Width:120,  Align:"Center", ColMerge:1, SaveName:"eduBranchCd",  	KeyField:0, Format:"",      UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduMBranchCdV2' mdef='교육분류|교육분류'/>",		Type:"Combo",	Hidden:0, Width:150, Align:"Left",	 ColMerge:1, SaveName:"eduMBranchCd",	KeyField:0,	Format:"",		UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduSYmdV3' mdef='교육기간|시작일'/>", 	Type:"Date",    Hidden:0, Width:80,  Align:"Center", ColMerge:1, SaveName:"eduSYmd",  		KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='eduEYmdV3' mdef='교육기간|종료일'/>", 	Type:"Date",    Hidden:0, Width:80,  Align:"Center", ColMerge:1, SaveName:"eduEYmd",  		KeyField:0, Format:"Ymd",   UpdateEdit:0,   InsertEdit:0 },

  			//Hidden
  			{Header:"applSeq",		Hidden:1, SaveName:"applSeq"},
  			{Header:"apApplSeq",	Hidden:1, SaveName:"apApplSeq"},
  			{Header:"sabun",		Hidden:1, SaveName:"sabun"},
  			{Header:"applInSabun",	Hidden:1, SaveName:"applInSabun"},
  			
  			{Header:"<sht:txt mid='eduCancleApp' mdef='교육취소신청|신청'/>",		Type:"Html",	  Hidden:0,	Width:55,    Align:"Center", ColMerge:0, SaveName:"btnApp",  		Sort:0 ,	Cursor:"Pointer"},
			{Header:"<sht:txt mid='eduCancleAppDetail' mdef='교육취소신청|세부\n내역'/>",Type:"Image",	  Hidden:0, Width:45,	 Align:"Center", ColMerge:0, SaveName:"detail",			KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='eduCancleApplYmd' mdef='교육취소신청|신청일'/>",	Type:"Date",	  Hidden:0, Width:80,	 Align:"Center", ColMerge:0, SaveName:"applYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='eduCancleApplStatus' mdef='교육취소신청|신청상태'/>",	Type:"Combo",	  Hidden:0, Width:80,	 Align:"Center", ColMerge:0, SaveName:"applStatusCd",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"<sht:txt mid='eduCancleApplDel' mdef='교육취소신청|삭제'/>",		Type:"Html",	  Hidden:0,	Width:55,    Align:"Center", ColMerge:0, SaveName:"btnDel",  		Sort:0 ,	Cursor:"Pointer"},
   			{Header:"<sht:txt mid='eduCancleReason' mdef='교육취소신청|취소사유'/>",	Type:"Combo",	  Hidden:0,	Width:80,	 Align:"Center", ColMerge:0, SaveName:"gubunCd",		KeyField:0,	Format:"",		Edit:0},
			{Header:"<sht:txt mid='eduCancleReasonDetail' mdef='교육취소신청|취소상세내용'/>",Type:"Text",	  Hidden:0,	Width:250,	 Align:"Left",	 ColMerge:0, SaveName:"appMemo",		KeyField:0,	Format:"",		Edit:0},
			

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(0, "${ctx}/common/images/icon/icon_popup.png");
		
		//공통코드 한번에 조회
		var grpCds = "L20020,L10010,R10010,L10015,L10050,L90100";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		sheet1.SetColProperty("inOutType", 		{ComboText:"|"+codeLists["L20020"][0], ComboCode:"|"+codeLists["L20020"][1]} );// L20020 사내/외 구분
		sheet1.SetColProperty("eduBranchCd", 	{ComboText:"|"+codeLists["L10010"][0], ComboCode:"|"+codeLists["L10010"][1]} );  //  교육구분
		sheet1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+codeLists["L10015"][0], ComboCode:"|"+codeLists["L10015"][1]} );  //  교육분류
		sheet1.SetColProperty("eduMethodCd", 	{ComboText:"|"+codeLists["L10050"][0], ComboCode:"|"+codeLists["L10050"][1]} );  // L10050 교육시행방법코드
		sheet1.SetColProperty("applStatusCd", 	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );  //  결재상태
		sheet1.SetColProperty("gubunCd", 		{ComboText:"|"+codeLists["L90100"][0], ComboCode:"|"+codeLists["L90100"][1]} );

		$(window).smartresize(sheetResize); sheetInit();
	}

	function chkInVal() {

		if ($("#searchSYmd").val() != "" && $("#searchEYmd").val() != "") {
			if (!checkFromToDate($("#searchSYmd"),$("#searchEYmd"),"교육일자","교육일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			sheet1.DoSearch("${ctx}/EduCancelApp.do?cmd=getEduCancelAppList", $("#sheet1Form").serialize());
			break;
		case "Save": // 중복체크
			if( !confirm('<msg:txt mid="alertDelete" mdef="삭제하시겠습니까?" />')) { initDelStatus(sheet1); return;}
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/EduCancelApp.do?cmd=deleteEduCancelApp", $("#sheet1Form").serialize(), -1, 0); 
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); 
			break;
		}
	}
	
	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
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
			if( Code > -1 ) doAction1("Search"); 
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( sheet1.ColSaveName(Col) == "detail" && sheet1.GetCellValue(Row, "applSeq") != "") {
		    	showApplPopup( Row, 1 ); 

			}else if( sheet1.ColSaveName(Col) == "btnApp" && Value != ""){
		    	showApplPopup( Row, 2 );
		    	
			}else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}


	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopup( Row, gubun ) {

		if(!isPopup()) {return;}
		
		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , searchSabun = "${ssnSabun}" 
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , initFunc = 'initLayer';
		  
		args["applStatusCd"] = "11";
		if( gubun == 1){
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";  
				url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			searchSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
			initFunc = 'initResultLayer';
		} 
		var p = {
				searchApplCd: '135'
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: searchSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			  , etc01: sheet1.GetCellValue(Row, "apApplSeq")
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '신청서',
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

	//신청 후 리턴
	function getReturnValue(returnValue) {
		doAction1("Search");
	}

	//인사헤더에서 이름 변경 시 
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	doAction1("Search");
    }
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<div class="explain outer">
			<div style="padding:10px;"><b>교육취소불가</b> : 필수교육, 수료완료, 결과보고진행</div>
		</div>
		<div class="sheet_search sheet_search_s outer">
			<table>
			<tr>
				<th><tit:txt mid='113497' mdef='교육기간 '/></th>
				<td>
					<input id="searchSYmd" name="searchSYmd" type="text" size="10" class="date2" value="<%= DateUtil.getThisYear()+"-01-01"%>"/> ~
					<input id="searchEYmd" name="searchEYmd" type="text" size="10" class="date2" value="<%= DateUtil.getThisYear()+"-12-31"%>"/>
				</td>
				<td> <a href="javascript:doAction1('Search');" class="btn dark" >조회</a> </td>
			</tr>
			</table>
		</div>
	</form>

	<div class="sheet_title inner">
		<ul>
			<li id="txt" class="txt"><tit:txt mid='eduCancleAppV1' mdef='교육취소신청'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			
</div>
</body>
</html>
