<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>공통신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		if( "${applTypeCd}" == "DATA"){
			init_sheetData(); 
		}else {
			init_sheetHtml(); 
		}

 		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "R10010";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		
		sheet1.SetColProperty("applStatusCd",  	{ComboText:"|"+codeLists["R10010"][0], ComboCode:"|"+codeLists["R10010"][1]} );//  신청상태
		//==============================================================================================================================
			
		$(window).smartresize(sheetResize); sheetInit();

		setEmpPage();
	});
	
	function init_sheetHtml(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,    Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,    Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"삭제",		Type:"Html",		Hidden:0,	 Width:45,              Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 },

			{Header:"세부\n내역",	Type:"Image",	Hidden:0, Width:45,	 Align:"Center", SaveName:"detail",			KeyField:0,	Format:"",		Edit:0 },
			{Header:"신청일",		Type:"Date",	Hidden:0, Width:80,	 Align:"Center", SaveName:"applYmd",		KeyField:0,	Format:"Ymd",	Edit:0 },
			{Header:"신청상태",	Type:"Combo",	Hidden:0, Width:80,	 Align:"Center", SaveName:"applStatusCd",	KeyField:0,	Format:"",		Edit:0 },
			{Header:"제목",		Type:"Text",	Hidden:1, Width:200, Align:"Left",   SaveName:"title",	 		KeyField:0,Format:"",       Edit:0 },

  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"sabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applCd"}

  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
  		
  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
	}
	
	//
	function init_sheetData(){
		var titleList = ajaxCall("${ctx}/ComApr.do?cmd=getComAprTitleList", $("#sheet1Form").serialize(), false);
		if (titleList != null && titleList.DATA != null) {
			sheet1.Reset();

			var v=0;
			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:4}; 
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [];
			initdata.Cols[v++]  = {Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 };
			initdata.Cols[v++]  = {Header:"삭제|삭제",				Type:"${sDelTy}", Hidden:1,						Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 };
			initdata.Cols[v++]  = {Header:"상태|상태",				Type:"${sSttTy}", Hidden:1,						Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 };
			initdata.Cols[v++]  = {Header:"삭제|삭제",				Type:"Html",	  Hidden:0,	 					Width:45,           Align:"Center",	ColMerge:0,	SaveName:"btnDel",  Sort:0 };
			//기본항목
			initdata.Cols[v++]  = {Header:"세부\n내역|세부\n내역", Type:"Image",  	Hidden:0, Width:45,  	Align:"Center", ColMerge:0,  SaveName:"detail",     	Edit:0 };
			initdata.Cols[v++]  = {Header:"신청일|신청일",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applYmd", 		Format:"Ymd", Edit:0};
			initdata.Cols[v++]  = {Header:"신청상태|신청상태",		Type:"Combo",  	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"applStatusCd",	Edit:0 };
			//Hidden
  			initdata.Cols[v++]  = {Header:"applInSabun",	Hidden:1, SaveName:"applCd"};
  			initdata.Cols[v++]  = {Header:"applInSabun",	Hidden:1, SaveName:"applInSabun"};
  			initdata.Cols[v++]  = {Header:"applSeq",		Hidden:1, SaveName:"applSeq"};
  			initdata.Cols[v++]  = {Header:"applCd",			Hidden:1, SaveName:"applCd"};

			for(var i = 0; i<titleList.DATA.length; i++) {
				var columnNm = titleList.DATA[i].columnNm;
				if( columnNm.length > 4 && titleList.DATA[i].columnWidth <= 100){
					columnNm = columnNm.substring(0, 4) + "\n" + columnNm.substring(4);
				}
				var sHeader = "신청내용|"+columnNm;
				var sSaveName = "data"+titleList.DATA[i].layoutSeq;
				var sSaveName2 = "dataNm"+titleList.DATA[i].layoutSeq;
				var sWidth = titleList.DATA[i].columnWidth;
				var sAlign = titleList.DATA[i].columnAlign;
				if(sWidth == "") sWidth = "100";
				if( titleList.DATA[i].columnTypeCd == "Combo" ){
					initdata.Cols[v++]  = {Header:sHeader, Type:"Text", Hidden:0, Width:sWidth, Align:sAlign, SaveName:sSaveName2, Edit:0 };
				}else{
					initdata.Cols[v++]  = {Header:sHeader, Type:"Text", Hidden:0, Width:sWidth, Align:sAlign, SaveName:sSaveName, Edit:0 };
				}
				if( titleList.DATA[i].columnTypeCd == "Popup" ){
					initdata.Cols[v++]  = {Header:sHeader, Type:"Text", Hidden:0, Width:sWidth, Align:sAlign, SaveName:sSaveName2, Edit:0 };
				}
			}

	  		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
			sheet1.SetDataLinkMouse("detail", 1);
			
			//==============================================================================================================================

		}
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/ComApp.do?cmd=getComAppList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
        	break;	
        case "Save": //임시저장의 경우 삭제처리만함.      
			if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}  
       		IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/ComApp.do?cmd=deleteComApp", $("#sheet1Form").serialize(), -1, 0); 
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
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "detail" ) {
		    	showApplPopup( Row );

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
	function showApplPopup( Row) {

		if(!isPopup()) {return;}
		
		var args = new Array(5);
		var auth    = "A"
		  , applSeq = ""
		  , applInSabun = "${ssnSabun}" 
		  , applYmd = "${curSysYyyyMMdd}"
			  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
				  , initFunc = 'initLayer'
		  , applCd  = $("#searchApplCd").val();
		  
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

			args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
			initFunc = 'initResultLayer';
		}else{
			if( applCd == "" ){
				alert("신청서종류를 선택 해주세요.");
				return;
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
			};
		/*
		url += "&searchApplCd="+applCd
			+ "&searchApplSeq="+applSeq
			+ "&adminYn=N"
			+ "&authPg="+auth
			+ "&searchSabun="+applInSabun // 신청 내용을 입력 하는 사람
			+ "&searchApplSabun="+$("#searchUserId").val()// 대상자 사번
			+ "&searchApplYmd="+applYmd;
		*/
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
		<input type="hidden" id="searchGubun" name="searchGubun"  value="APP"/>
		<input type="hidden" id="searchSabun"  name="searchSabun" value=""/>
		<input type="hidden" id="searchApplCd" name="searchApplCd" value="${applCd}"/>
	</form>
	
	<div class="sheet_title inner">
		<ul>
			<li class="txt">${applNm}</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray" >다운로드</a>
				<a href="javascript:showApplPopup(-1);" 		class="btn filled" >신청</a>
				<a href="javascript:doAction1('Search')" 		class="btn dark" >조회</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			

</body>
</html>
