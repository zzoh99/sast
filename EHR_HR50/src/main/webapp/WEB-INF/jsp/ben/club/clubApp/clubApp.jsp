<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>동호회신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		//기준일자 날짜형식, 날짜선택 시 
		$("#searchYmd").datepicker2({
			onReturn:function(){
				doAction1("Search");
			}
		});
		
		$("#searchYmd").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		//Sheet 초기화
		init_sheet1(); init_sheet2();
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
		
		doAction2("Search");
		
		setEmpPage();

	});

	//동호회가입현황
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
  			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },

  			{Header:"동호회순번|동호회순번",	Type:"Text",  Hidden:1, Width:45, Align:"Center", ColMerge:1, SaveName:"clubSeq" },
			{Header:"동호회명|동호회명", 		Type:"Text",  Hidden:0, Width:140, Align:"Center", ColMerge:1, SaveName:"clubNm", 		Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"동호회비|동호회비", 		Type:"Int",   Hidden:0, Width:70, Align:"Center", ColMerge:1, SaveName:"clubFee", 		Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"회장|회장",				Type:"Text",  Hidden:0,	Width:80, Align:"Center", ColMerge:1, SaveName:"sabunAName",	Format:"",		UpdateEdit:0, InsertEdit:0 },
			{Header:"총무|총무",				Type:"Text",  Hidden:0,	Width:80, Align:"Center", ColMerge:1, SaveName:"sabunCName",	Format:"",		UpdateEdit:0, InsertEdit:0 },
			{Header:"시작일자|시작일자", 		Type:"Date",  Hidden:0, Width:85, Align:"Center", ColMerge:1, SaveName:"sdate", 		Format:"Ymd", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"종료일자|종료일자", 		Type:"Date",  Hidden:0, Width:85, Align:"Center", ColMerge:1, SaveName:"edate", 		Format:"Ymd", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"급여공제동의일시|급여공제동의일시", 		Type:"Date",  Hidden:0, Width:110, Align:"Center", ColMerge:1, SaveName:"agreeDate", 		Format:"YmdHms", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"서명이미지|서명이미지", 	Type:"Image", Hidden:0, Width:80,Align:"Center", ColMerge:1, SaveName:"fileSeqUrl", 	Format:"", 		UpdateEdit:0, InsertEdit:0, ImgWidth:80, ImgHeight:30},
			{Header:"급여공제동의|급여공제동의",Type:"Html",  Hidden:1,	Width:80, Align:"Center", ColMerge:1, SaveName:"btnAgree",		Format:"",		UpdateEdit:0, InsertEdit:0, Sort:0 },

  			//Hidden
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"fileSeq"},

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);

		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

	}

	//동호회가입/탈퇴신청
	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:1,	                Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:1,	                Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"신청서순번|신청서순번",Type:"Text",  Hidden:1, Width:45, Align:"Center", ColMerge:1, SaveName:"applSeq" },
			{Header:"삭제|삭제",			Type:"Html",  Hidden:0,	Width:45, Align:"Center", ColMerge:1, SaveName:"btnDel",		Format:"",		UpdateEdit:0, InsertEdit:0, Sort:0, Cursor:"Pointer" },
			{Header:"세부\n내역|세부\n내역",Type:"Image", Hidden:0,	Width:45, Align:"Center", ColMerge:1, SaveName:"detail",		Format:"",		UpdateEdit:0, InsertEdit:0, Sort:0, Cursor:"Pointer" },
			{Header:"신청일자|신청일자",	Type:"Date",  Hidden:0,	Width:80, Align:"Center", ColMerge:1, SaveName:"applYmd",		Format:"Ymd",	UpdateEdit:0, InsertEdit:0 },
			{Header:"신청상태|신청상태",	Type:"Combo", Hidden:0,	Width:65, Align:"Center", ColMerge:1, SaveName:"applStatusCd",	Format:"",		UpdateEdit:0, InsertEdit:0 },
			
			{Header:"신청구분|신청구분",	Type:"Combo", Hidden:0,	Width:60, Align:"Center", ColMerge:1, SaveName:"joinType",		Format:"",		UpdateEdit:0, InsertEdit:0 },
			{Header:"동호회명|동호회명", 	Type:"Combo", Hidden:0, Width:90, Align:"Center", ColMerge:1, SaveName:"clubSeq", 		Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"가입일자|가입일자", 	Type:"Date",  Hidden:0, Width:85, Align:"Center", ColMerge:1, SaveName:"sdate", 		Format:"Ymd", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"탈퇴일자|탈퇴일자", 	Type:"Date",  Hidden:0, Width:85, Align:"Center", ColMerge:1, SaveName:"edate", 		Format:"Ymd", 	UpdateEdit:0, InsertEdit:0 },

  			//Hidden
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"applCd"},
  			
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable(0);sheet2.SetVisible(true);sheet2.SetCountPosition(0);
		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet2.SetDataAlternateBackColor(sheet2.GetDataBackColor());
		
		// 세부내역 Image setting 및 mouseover 시 cursor 변경
		sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetDataLinkMouse("detail",1);
		
		//신청구분
 		sheet2.SetColProperty("joinType", {ComboText:"가입|탈퇴", ComboCode:"A|D"} ); //리조트명

 		//공통코드 한번에 조회
 		var grpCds = "R10010";
 		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
 		sheet2.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );
 		
 		var clubCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getClubAppClubCode",false).codeList, "");
 		sheet2.SetColProperty("clubSeq",  {ComboText:"|"+clubCdList[0], ComboCode:"|"+clubCdList[1]} );
 		
	}

	//전체 조회
	function doSearch(){
		doAction1("Search");
		doAction2("Search");
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var sXml = sheet1.GetSearchData("${ctx}/ClubApp.do?cmd=getClubAppedList", $("#sheet1Form").serialize() );
				sheet1.LoadSearchData(sXml );
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
			var sXml = sheet2.GetSearchData("${ctx}/ClubApp.do?cmd=getClubAppList", $("#sheet1Form").serialize() );
			sheet2.LoadSearchData(sXml );
			break;
		case "Save":
			if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet2); return;}
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/ClubApp.do?cmd=deleteClubApp", $("#sheet1Form").serialize(), -1, 0);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
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
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			if( sheet1.ColSaveName(Col) == "btnAgree" && Value.length > 1 ) {
				// 신청 팝업
				showAgreePopup(Row);
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

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction2("Search");
		}
		catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet2.HeaderRows() ) return;

			if( sheet2.ColSaveName(Col) == "detail" ) {
				// 상세보기 팝업
				showApplPopup(Row);

			}else if( sheet2.ColSaveName(Col) == "btnDel" && Value != ""){
				sheet2.SetCellValue(Row, "sStatus", "D");
				doAction2("Save");
			}
		}
		catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//-----------------------------------------------------------------------------------
	//	 팝업
	//-----------------------------------------------------------------------------------
	function showAgreePopup(Row) {

		if(!isPopup()) {return;}

		var args = new Array(5);
		
		pGubun = "signComPopup";
		gPRow = Row;
		
		var url     = "/Popup.do?cmd=signComPopup";

		var result = openPopup(url, args, 400, 240);

	}
	
	function showApplPopup(Row) {

		if(!isPopup()) {return;}

		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}"
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , applCd  = "710"
		  , initFunc = 'initLayer';

		args["applStatusCd"] = "11";

		if( Row > -1  ){
			if(sheet2.GetCellValue(Row, "applStatusCd") != "11") {
				auth = "R";
				url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			}
			applSeq     = sheet2.GetCellValue(Row,"applSeq");
			applInSabun = sheet2.GetCellValue(Row,"applInSabun");
			applYmd     = sheet2.GetCellValue(Row,"applYmd");
			applCd      = sheet2.GetCellValue(Row,"applCd");
			initFunc = 'initResultLayer';
			args["applStatusCd"] = sheet2.GetCellValue(Row, "applStatusCd");
		}

		const p = {
			searchApplCd: applCd,
			searchApplSeq: applSeq,
			adminYn: 'N',
			authPg: auth,
			searchSabun: applInSabun,
			searchApplSabun: $('#searchUserId').val(),
			searchApplYmd: applYmd
		};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '동호회가입/탈퇴신청',
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
		if (pGubun == "signComPopup"){
			var rv = $.parseJSON('{'+ returnValue+'}');
			if(rv && rv["fileSeq"] && gPRow){
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
				
				var param = "&clubSeq="+sheet1.GetCellValue(gPRow, "clubSeq");
				param += "&searchApplSabun="+$("#searchUserId").val();
				param += "&fileSeq="+rv["fileSeq"];
				
		    	var data = ajaxCall("/ClubApp.do?cmd=saveClubAppAgreeInfo", param, false);
				
			}
			
		} 
		doSearch();
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
	
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">동호회가입현황</li>
			<li class="btn">
				<span>기준일자</span>
				<input type="text" id="searchYmd" name="searchYmd" class="date2 w80" value="${curSysYyyyMMddHyphen}"/>
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray">다운로드</a>
				<a href="javascript:doAction1('Search')" 		class="btn dark">조회</a>
			</li>
		</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "150px"); </script>
	
		<div class="sheet_title">
		<ul>
			<li class="txt">동호회가입/탈퇴신청</li>
			<li class="btn">
				<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray">다운로드</a>
				<a href="javascript:showApplPopup(-1);" 		class="btn filled" >신청</a>
				<a href="javascript:doAction2('Search')" 		class="btn dark">조회</a>
			</li>
		</ul>
		</div>
	</div>
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>

	</form>
</div>
</body>
</html>

