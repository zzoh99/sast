<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>학자금기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	
	//선택된 탭
	var newIframe;
	var oldIframe;
	var iframeIdx;
	
	//Sheet Action
	var selectTab = "tab1";

	$(function() {

		//기준일자 날짜형식, 날짜선택 시 
		$("#searchYmd").datepicker2({
			onReturn:function(){
				doAction1("Search");
			}
		});
		
		//Sheet 초기화
		init_sheet1();
		
		newIframe = $('#tabs-1 iframe');
		iframeIdx = 0;

		$( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				iframeIdx = ui.newTab.index();
				newIframe = $(ui.newPanel).find('iframe');
				oldIframe = $(ui.oldPanel).find('iframe');
				showIframe();
			}
		});

		//탭 높이 변경
		function setIframeHeight() {
			var iframeTop = $("#tabs ul.tab_bottom").height() + 16;
			$(".layout_tabs").each(function() {
				$(this).css("top",iframeTop);
			});
		}

		$(window).smartresize(sheetResize); sheetInit();
		setIframeHeight();
		
		doAction1("Search");

	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"학자금",				Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"schTypeCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"지원구분",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"schSupTypeCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"대상자",				Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famCd",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"근속년수",			Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workYear",		KeyField:0,	Format:"##\\년",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"지원횟수\n(한도)",	Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"lmtAppCnt",		KeyField:0,	Format:"##\\회",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"년간지원\n금액",		Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"lmtYearMon",		KeyField:0,	Format:"#,###\\원",	PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"나이제한\n(만)시작",	Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"stAge",			KeyField:0,	Format:"##\\세",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"나이제한\n(만)종료",	Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edAge",			KeyField:0,	Format:"##\\세",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"회당\n지원금액",		Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applMon",			KeyField:0,	Format:"#,###\\원",	PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"지급률",				Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payRate",			KeyField:0,	Format:"##\\%",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:3 },
			{Header:"시작일자",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 , EndDateCol:"edate"},
			{Header:"종료일자",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 , StartDateCol:"sdate"},
			{Header:"증빙서류",			Type:"Text",		Hidden:0, 	Width:150,  Align:"Left",	ColMerge:0,	SaveName:"evidenceDoc",		KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
			
			{Header:"복리후생마감\n급여항목",	Type:"Popup",		Hidden:0, 	Width:100,  Align:"Center",	ColMerge:0,	SaveName:"elementNm",		KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
			{Header:"복리후생마감\n급여항목",	Type:"Text",		Hidden:1, 	Width:100,  Align:"Center",	ColMerge:0,	SaveName:"elementCd",		KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
			
			{Header:"비고",				Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	}

	function getCommonCodeList1() {
		//공통코드 한번에 조회
		var grpCds = "B60050,B60051,B60030";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchYmd").val();
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");
		sheet1.SetColProperty("schTypeCd",     {ComboText:"|"+codeLists["B60050"][0], ComboCode:"|"+codeLists["B60050"][1]} ); //학자금
		sheet1.SetColProperty("schSupTypeCd",  {ComboText:"|"+codeLists["B60051"][0], ComboCode:"|"+codeLists["B60051"][1]} ); //학자금지원구분
		sheet1.SetColProperty("famCd",         {ComboText:"|"+codeLists["B60030"][0], ComboCode:"|"+codeLists["B60030"][1]} ); //대상자(경조-가족구분)
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
					var sdate = sheet1.GetCellValue(i, "sdate");
					var edate = sheet1.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}
		return true;
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				getCommonCodeList1();
				sheet1.RemoveAll();
				sheet1.DoSearch( "${ctx}/SchStd.do?cmd=getSchStdList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!chkInVal()){break;}
				if(!dupChk(sheet1,"schTypeCd|schSupTypeCd|famCd|sdate", true, true, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/SchStd.do?cmd=saveSchStd", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				break;
			case "Copy":
				var row = sheet1.DataCopy();
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
			
			if( sheet1.RowCount() > 0 ){
				showIframe();
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
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀 팝업 클릭 시
	function sheet1_OnPopupClick(Row, Col) {
		try {
			if(sheet1.ColSaveName(Col) == "elementNm") { //급여항목

				if(!isPopup()) {return;}

				var args 	= new Array();
				gPRow = Row;
				pGubun = "payElementPopup";
				//var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "1020","520");
			    
			    let layerModal = new window.top.document.LayerModal({
			          id : 'payElementLayer'
			        , url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
			        , parameters : args
			        , width : 1020
			        , height : 520
			        , title : '수당,공제 항목'
			        , trigger :[
			            {
			                  name : 'payTrigger'
			                , callback : function(result){
			                    getReturnValue(result);
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
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow == NewRow || sheet1.GetCellValue(NewRow, "sStatus") == "I") return;
			
			if( sheet1.RowCount() > 0 ){
				showIframe();
			}
			
		} catch (ex) {
			alert("[sheet1] OnSelectCell Event Error : " + ex);
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// 팝업 콜백 함수.
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(returnValue) {
		//var rv = $.parseJSON('{' + returnValue + '}');
		var rv = returnValue;

		if (pGubun == "payElementPopup") { // 급여항목 팝업
			sheet1.SetCellValue(gPRow, "elementCd", rv["resultElementCd"], 0);
			sheet1.SetCellValue(gPRow, "elementNm", rv["resultElementNm"]);
		}
	}
	
	function doTabAction() {
		switch (selectTab) {
			case "tab1": tab1.doTabAction('Search'); break;
		}
	}

	function showIframe() {
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","${ctx}/common/hidden.html");
		}
		
		var Row = sheet1.GetSelectRow();
		var schTypeCd = sheet1.GetCellValue(Row, "schTypeCd");
		var schSupTypeCd = sheet1.GetCellValue(Row, "schSupTypeCd");
		var famCd = sheet1.GetCellValue(Row, "famCd");
		var sdate = sheet1.GetCellValue(Row, "sdate");
		var searchYmd = $("#searchYmd").val();
		
		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/SchStd.do?cmd=viewSchTab1Std&authPg=${authPg}&schTypeCd=" + schTypeCd + "&schSupTypeCd=" + schSupTypeCd + "&famCd=" + famCd + "&sdate="+ sdate + "&searchYmd=" + searchYmd);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="sheet1Form" id="sheet1Form" method="post">
		<div class="sheet_search outer">
			<table>
				<tr>
					<th>기준일자</th>
					<td>
						<input type="text" id="searchYmd" name="searchYmd" class="date2" value="${curSysYyyyMMddHyphen}"/>
					</td>
					<td>
						<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
					</td>
				</tr>
			</table>
		</div>
	</form>
	
	<div class="outer">
		<div class="sheet_title">

			<ul>
				<li class="txt">
					학자금기준관리
				</li>
				<span style="font-weight: normal;">(※ 학자금기준관리는 사전에 공통코드관리의 '경조-가족구분' 비고1, 비고2 항목에 '가족관계' 코드 매핑이 필요합니다.)</span>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
	</div>
	
	<div class="innertab inner" style="height:50%;">
		<div id="tabs">
			<ul class="tab_bottom">
				<li><a href="#tabs-1" onclick="javascript:showIframe();">직책별 지원금액</a></li>
			</ul>
			<div id="tabs-1">
				<div  class='layout_tabs'><iframe id="tab1" name="tab1" frameborder='0' class='tab_iframes'></iframe></div>
			</div>
		</div>
	</div>

</div>
</body>
</html>
