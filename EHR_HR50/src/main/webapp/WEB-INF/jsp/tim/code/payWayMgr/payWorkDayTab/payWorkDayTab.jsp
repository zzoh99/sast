<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근무일사항</title>
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
			{Header:"근무일집계코드",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workDdCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"수당",				Type:"Popup",		Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"elementNm",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1000 },
			{Header:"수당코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"elementCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//var workDdCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T10019"), "");
		var workDdCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getComCodeListUseYn&searchGrcodeCd=T10019",false).codeList, "전체");

		sheet1.SetColProperty("workDdCd", 			{ComboText:"|"+workDdCd[0], ComboCode:"|"+workDdCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PayWorkDayTab.do?cmd=getPayWorkDayTabList",param );
			break;
		case "Save":

			if(!dupChk(sheet1,"workDdCd|elementCd", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PayWorkDayTab.do?cmd=savePayWorkDayTab", $("#sheet1Form").serialize());
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
			<li class="txt">근무일사항</li>
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