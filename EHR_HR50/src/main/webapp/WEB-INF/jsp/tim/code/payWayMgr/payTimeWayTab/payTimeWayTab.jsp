<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근태사항</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"근태명",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"수당",				Type:"Popup",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"수당코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"elementCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"지급구분",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"giveGubun",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"검색설명",			Type:"Popup",		Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"searchNm",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
			{Header:"검색코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"searchSeq",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"지급월",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"의무사용일수",			Type:"Text",		Hidden:1,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"dutyDay",		KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"생성기준",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"comType",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var gntCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCpnGntCdList"), "");
		var comType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10023"), "");

		sheet1.SetColProperty("gntCd", 			{ComboText:"|"+gntCd[0], ComboCode:"|"+gntCd[1]} );
		sheet1.SetColProperty("comType", 		{ComboText:"|"+comType[0], ComboCode:"|"+comType[1]} );
		sheet1.SetColProperty("giveGubun", 		{ComboText:"|월보상|누계보상|보상암함", ComboCode:"|1|3|5"} );
		sheet1.SetColProperty("mm", 			{ComboText:"|1월|2월|3월|4월|5월|6월|7월|8월|9월|10월|11월|12월", ComboCode:"|01|02|03|04|05|06|07|08|09|10|11|12"} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PayTimeWayTab.do?cmd=getPayTimeWayTabList",param );
			break;
		case "Save":

			if(!dupChk(sheet1,"gntCd|searchSeq", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PayTimeWayTab.do?cmd=savePayTimeWayTab", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
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
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
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

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "elementNm" && KeyCode == 46) {
	                sheet1.SetCellValue(Row, "elementNm",	"" );
	                sheet1.SetCellValue(Row, "elementCd",	"" );
				} else if(sheet1.ColSaveName(Col) == "searchNm" && KeyCode == 46) {
	                sheet1.SetCellValue(Row, "searchNm",	"" );
	                sheet1.SetCellValue(Row, "searchSeq",	"" );
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	var gPRow = "";
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			gPRow = Row;
			if(sheet1.ColSaveName(Col) == "elementNm") {
				if(!isPopup()) {return;}
	            //var rst = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", "", "740","520");
				pGubun = "payElementLayer";
	            let layerModal = new window.top.document.LayerModal({
	    			id : 'payElementLayer', 
	    			url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}',
	    			parameters : {}, 
	    			width : 860, 
	    			height : 520, 
	    			title : '<tit:txt mid='payElementPop4' mdef='수당,공제 항목'/>', 
	    			trigger :[
	    				{
	    					name : 'payTrigger', 
	    					callback : function(result){
								const rv = { elementCd: result.resultElementCd, elementNm: result.resultElementNm, sdate: result.sdate };
	    						getReturnValue(rv);
	    					}
	    				}
	    			]
	    		});
	    		layerModal.show();
			} else if(sheet1.ColSaveName(Col) == "searchNm") {
				if(!isPopup()) {return;}
				pGubun = "pwrSrchMgrPopup";
				const url = '/Popup.do?cmd=viewPwrSrchMgrLayer';
				const p = { srchBizCd: '08', srchType: '3', srchDesc: '근태신청' };
				var pwrMgrLayer = new window.top.document.LayerModal({
					id : 'pwrSrchMgrLayer',
					url: url,
					parameters: p,
					width: 850,
					height: 620,
					title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>',
					trigger :[
						{
							name : 'pwrTrigger'
							, callback : function(result){
								getReturnValue(result);
							}
						}
					]
				});
				pwrMgrLayer.show();
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {
		var rv = returnValue;
		if( pGubun == "payElementLayer" ){
			sheet1.SetCellValue(gPRow, "elementCd",		rv["elementCd"] );
            sheet1.SetCellValue(gPRow, "elementNm",		rv["elementNm"] );
		} else if( pGubun == "pwrSrchMgrPopup" ) {
            sheet1.SetCellValue(gPRow, "searchSeq",		rv["searchSeq"] );
            sheet1.SetCellValue(gPRow, "searchNm",		rv["searchDesc"] );
		}
	}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">근태사항</li>
			<li class="btn">
				<a href="javascript:doAction1('Search');" class="btn dark">조회</a>
				<a href="javascript:doAction1('Insert');" class="btn outline_gray authA">입력</a>
				<a href="javascript:doAction1('Copy');" class="btn outline_gray authA">복사</a>
				<a href="javascript:doAction1('Save');" class="btn filled authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" class="btn outline_gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>