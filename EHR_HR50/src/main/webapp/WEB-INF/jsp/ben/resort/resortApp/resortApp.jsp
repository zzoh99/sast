<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>리조트신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("#searchYear").val("${curSysYear}");

		//IBSheet 기본 셋팅
		init_sheet1();init_sheet2();

		$(window).smartresize(sheetResize); sheetInit();
		
		setEmpPage();

	});

	//신청내역
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
  			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,	                Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:1,	                Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus",	Sort:0 },

  			{Header:"신청서순번|신청서순번",	Type:"Text",  Hidden:1, Width:45, Align:"Center", ColMerge:1, SaveName:"applSeq" },
			{Header:"리조트신청|삭제",			Type:"Html",  Hidden:0,	Width:45, Align:"Center", ColMerge:1, SaveName:"btnDel",		Format:"",		UpdateEdit:0, InsertEdit:0, Sort:0, Cursor:"Pointer" },
			{Header:"리조트신청|세부\n내역",	Type:"Image", Hidden:0,	Width:45, Align:"Center", ColMerge:1, SaveName:"detail",		Format:"",		UpdateEdit:0, InsertEdit:0, Sort:0, Cursor:"Pointer" },
			{Header:"리조트신청|신청일자",		Type:"Date",  Hidden:0,	Width:80, Align:"Center", ColMerge:1, SaveName:"applYmd",		Format:"Ymd",	UpdateEdit:0, InsertEdit:0 },
			{Header:"리조트신청|신청상태",		Type:"Combo", Hidden:0,	Width:65, Align:"Center", ColMerge:1, SaveName:"applStatusCd",	Format:"",		UpdateEdit:0, InsertEdit:0 },

			{Header:"리조트신청|시즌", 			Type:"Combo", Hidden:0, Width:90, Align:"Center", ColMerge:1, SaveName:"seasonCd", 		Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"리조트신청|희망순번", 		Type:"Combo", Hidden:0, Width:60, Align:"Center", ColMerge:1, SaveName:"hopeCd", 		Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"리조트신청|리조트명", 		Type:"Combo", Hidden:0, Width:90, Align:"Center", ColMerge:1, SaveName:"companyCd", 	Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"리조트신청|지점명", 		Type:"Text",  Hidden:0, Width:110, Align:"Left", ColMerge:1, SaveName:"resortNm", 	Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"리조트신청|객실유형", 		Type:"Text",  Hidden:0, Width:80, Align:"Left", ColMerge:1, SaveName:"roomType", 		Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"리조트신청|사용시작일", 	Type:"Date",  Hidden:0, Width:80, Align:"Center", ColMerge:1, SaveName:"sdate", 		Format:"Ymd", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"리조트신청|사용종료일", 	Type:"Date",  Hidden:1, Width:80, Align:"Center", ColMerge:1, SaveName:"edate", 		Format:"Ymd", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"리조트신청|박수", 			Type:"Text",  Hidden:0, Width:50, Align:"Center", ColMerge:1, SaveName:"days", 			Format:"", 		UpdateEdit:0, InsertEdit:0 },

			{Header:"리조트신청|예약상태", 		Type:"Combo", Hidden:0, Width:70, Align:"Center", ColMerge:1, SaveName:"statusCd", 		Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"리조트신청|예약번호",		Type:"Text",  Hidden:0, Width:110, Align:"Center", ColMerge:1, SaveName:"rsvNo1", 		Format:"", 		UpdateEdit:0, InsertEdit:0 },


  			//Hidden
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"applCd"},

			{Header:"Hidden", 	Type:"Text", Hidden:1, SaveName:"planSeq" },
			

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

		// 세부내역 Image setting 및 mouseover 시 cursor 변경
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetDataLinkMouse("detail",1);


 		//공통코드 한번에 조회
 		var grpCds = "R10010,B49530,B49540,B49520,B49550";
 		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
 		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );
 		
 		sheet1.SetColProperty("seasonCd",  		{ComboText:"|일반|"+codeLists["B49540"][0], ComboCode:"||"+codeLists["B49540"][1]} ); //시즌
 		sheet1.SetColProperty("companyCd",  	{ComboText:"|"+codeLists["B49530"][0], ComboCode:"|"+codeLists["B49530"][1]} ); //리조트명
 		sheet1.SetColProperty("statusCd",  		{ComboText:"|"+codeLists["B49520"][0], ComboCode:"|"+codeLists["B49520"][1]} ); //예약상태
 		sheet1.SetColProperty("hopeCd",  		{ComboText:"|"+codeLists["B49550"][0], ComboCode:"|"+codeLists["B49550"][1]} ); //희망순번

	}

	//리조트신청기간 조회
	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",					Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"신청",					Type:"Html",  	  Hidden:0,	Width:55,  Align:"Center", SaveName:"btnApp",		Format:"",		Edit:0, Sort:0, Cursor:"Pointer" },
			{Header:"시즌구분", 			Type:"Combo",     Hidden:0, Width:90,  Align:"Center", SaveName:"seasonCd",		Format:"", 		Edit:0 },
			{Header:"신청접수기간",			Type:"Date", 	  Hidden:0, Width:80,  Align:"Center", SaveName:"appSdate", 	Format:"Ymd", 	Edit:0 },
			{Header:"신청접수기간",			Type:"Date", 	  Hidden:0, Width:80,  Align:"Center", SaveName:"appEdate", 	Format:"Ymd", 	Edit:0 },
			{Header:"제목",					Type:"Text", 	  Hidden:1, Width:200, Align:"Left",   SaveName:"title", 		Format:"", 		Edit:0 },
			{Header:"사용(예약)가능기간",	Type:"Date", 	  Hidden:0, Width:80,  Align:"Center", SaveName:"useSdate", 	Format:"Ymd", 	Edit:0 },
			{Header:"사용(예약)가능기간",	Type:"Date", 	  Hidden:0, Width:80,  Align:"Center", SaveName:"useEdate", 	Format:"Ymd", 	Edit:0 },
			{Header:"유의사항", 			Type:"Text", 	  Hidden:0, Width:350, Align:"Left",   SaveName:"note", 		Format:"", 		Edit:0 },

			//Hidden
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"planSeq"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"applCd"},

		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable(0);sheet2.SetVisible(true);sheet2.SetCountPosition(0);
		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet2.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		//성수기구분
		var seasonCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "B49540"), "");
 		sheet2.SetColProperty("seasonCd", {ComboText:seasonCdList[0], ComboCode:seasonCdList[1]} ); //시즌구분
	}

	//전체 조회
	function doSearch(){
		doAction2("Search");
		doAction1("Search");
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var sXml = sheet1.GetSearchData("${ctx}/ResortApp.do?cmd=getResortAppList", $("#sheet1Form").serialize() );
				sheet1.LoadSearchData(sXml );
				break;
			case "Save":
				if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/ResortApp.do?cmd=deleteResortApp", $("#sheet1Form").serialize(), -1, 0);
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				
				var data = ajaxCall( "${ctx}/ResortApp.do?cmd=getResortAppTargetYn", $("#sheet1Form").serialize(),false);
				if ( data != null && data.DATA != null && data.DATA.cnt != null && Number(data.DATA.cnt) > 0){
					$("#targetYn").val("Y");
				} else {
					$("#targetYn").val("N");
				}
				
				sheet2.DoSearch( "${ctx}/ResortApp.do?cmd=getResortAppPlanList", $("#sheet1Form").serialize() );
				break;
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		}
		catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		}
		catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;

			if( sheet1.ColSaveName(Col) == "detail" ) {
				// 상세보기 팝업
				showApplPopup(Row);

			}else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
			}
		}
		catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		}
		catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet2.HeaderRows() ) return;

			if( sheet2.ColSaveName(Col) == "btnApp" ) {
				// 신청 팝업
				showApplPopupNew(Row);
			}
		}
		catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopupNew(Row) {

		if(!isPopup()) {return;}

		var args = new Array(5);
		var url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		var initFunc = 'initLayer';
		args["applStatusCd"] = "11";

		var p = {
				searchApplCd: '109'
			  , searchApplSeq: ''
			  , adminYn: 'N'
			  , authPg: 'A'
			  , searchSabun: '${ssnSabun}'
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: '${curSysYyyyMMdd}'
			  , etc01: sheet2.GetCellValue(Row,"planSeq")
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '성수기리조트신청',
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
	
	function showApplPopup(Row) {
		if(!isPopup()) {return;}
		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}"
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , applCd  = "108"
		  , initFunc = 'initLayer';

		args["applStatusCd"] = "11";
		if( Row > -1  ){
			if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";
				url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet1.GetCellValue(Row,"applSeq");
			applInSabun = sheet1.GetCellValue(Row,"applInSabun");
			applYmd     = sheet1.GetCellValue(Row,"applYmd");
			applCd      = sheet1.GetCellValue(Row,"applCd");
			initFunc = 'initResultLayer';
			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		}
		var p = {
				searchApplCd: applCd
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '리조트신청',
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
    	doSearch();
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<!-- include 기본정보 page TODO -->
<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form name="sheet1Form" id="sheet1Form" method="post">
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		<input type="hidden" id="targetYn" name="targetYn" value=""/>
		<input type="hidden" id="sdate" name="sdate" value=""/>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">성수기 리조트신청</li>
			<li class="btn"></li>
		</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "100px"); </script>
	
		<div class="sheet_title">
		<ul>
			<li class="txt">리조트신청</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray">다운로드</a>
				<a href="javascript:showApplPopup(-1);" 		class="btn filled" >리조트신청</a>
				<a href="javascript:doAction1('Search')" 		class="btn dark">조회</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>

