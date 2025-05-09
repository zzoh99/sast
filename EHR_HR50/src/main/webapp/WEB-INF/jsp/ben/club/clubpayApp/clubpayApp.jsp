<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>동호회 지원금신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		init_sheet1();
		
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
		
		setEmpPage();
	});

	//동호회 지원금신청
	function init_sheet1(){

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
			
			{Header:"기준년도|기준년도",	Type:"Text", Hidden:0,	Width:60, Align:"Center", ColMerge:1, SaveName:"year",			Format:"",		UpdateEdit:0, InsertEdit:0 },
			{Header:"분기|분기",			Type:"Combo", Hidden:0,	Width:60, Align:"Center", ColMerge:1, SaveName:"divCd",			Format:"",		UpdateEdit:0, InsertEdit:0 },
			{Header:"동호회명|동호회명",	Type:"Text",  Hidden:0,	Width:140, Align:"Center", ColMerge:1, SaveName:"clubNm",		Format:"",		UpdateEdit:0, InsertEdit:0 },
			{Header:"회장|회장", 			Type:"Text",  Hidden:0, Width:80, Align:"Center", ColMerge:1, SaveName:"sabunAView", 	Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"총무|총무", 			Type:"Text",  Hidden:0, Width:80, Align:"Center", ColMerge:1, SaveName:"sabunCView", 	Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"회원수|회원수", 		Type:"Text",  Hidden:0, Width:80, Align:"Center", ColMerge:1, SaveName:"clubMemCnt", 	Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"신청금액|신청금액", 	Type:"Int",   Hidden:0, Width:80, Align:"Center", ColMerge:1, SaveName:"appMon", 		Format:"", 		UpdateEdit:0, InsertEdit:0 },

  			//Hidden
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"applCd"},
  			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀수색 같게
		
		// 세부내역 Image setting 및 mouseover 시 cursor 변경
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",1);
		
 		//공통코드 한번에 조회
 		var grpCds = "R10010,B50710";
 		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
 		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );
 		sheet1.SetColProperty("divCd",  		{ComboText:"|"+codeLists["B50710"][0], ComboCode:"|"+codeLists["B50710"][1]} );
 		
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/ClubpayApp.do?cmd=getClubpayAppList", $("#sheet1Form").serialize() );
			sheet1.LoadSearchData(sXml );
			break;
		case "Save":
			if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/ClubpayApp.do?cmd=deleteClubpayApp", $("#sheet1Form").serialize(), -1, 0);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
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

	//-----------------------------------------------------------------------------------
	//	 팝업
	//-----------------------------------------------------------------------------------
	
	function showApplPopup(Row) {

		if(!isPopup()) {return;}

		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}"
		  , applYmd = "${curSysYyyyMMdd}"
		  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
		  , applCd  = "712"
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
		
		var divCd = "";
		if( auth == "A" ){
			var data = ajaxCall( "${ctx}/ClubpayApp.do?cmd=getClubpayAppDateChk", $("#searchForm").serialize(),false);
			if ( data != null && data.DATA != null && data.DATA.appDateYn != null && data.DATA.appDateYn == 'N'){
				alert("동호회 지원금 신청기간이 아닙니다.");
				return;
			} else {
				divCd = data.DATA.appDateYn;
			}
		}

		var p = {
				searchApplCd: applCd
			  , searchApplSeq: applSeq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd
			  , etc01: divCd 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '동호회지원금신청',
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
<body class="bodywrap">
<div class="wrapper">
<!-- include 기본정보 page TODO -->
<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form name="sheet1Form" id="sheet1Form" method="post">
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">동호회지원금신청</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray">다운로드</a>
				<a href="javascript:showApplPopup(-1);" 		class="btn filled" >신청</a>
				<a href="javascript:doAction1('Search')" 		class="btn dark">조회</a>
			</li>
		</ul>
		</div>
	</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

	</form>
</div>
</body>
</html>

