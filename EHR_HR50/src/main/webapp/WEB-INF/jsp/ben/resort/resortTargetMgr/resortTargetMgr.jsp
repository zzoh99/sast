<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>리조트지원대상자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();

		$("#searchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchSabunName").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		doAction1("Search");


	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		//MergeSheet:msHeaderOnly => 헤더만 머지
		//HeaderCheck => 헤더에 전체 체크 표시 여부
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,					Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",		Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",		Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"기준년도", 	Type:"Text", 		Hidden:0, 	Width:70, 		Align:"Center", ColMerge:0,	SaveName:"year", 	KeyField:1, Format:"", PointCount:0,	UpdateEdit:0, InsertEdit:1 },
			{Header:"사번", 		Type:"Text", 		Hidden:0, 	Width:80, 		Align:"Center", ColMerge:0,	SaveName:"sabun", 	KeyField:1, Format:"", PointCount:0,	UpdateEdit:0, InsertEdit:1 },
			{Header:"성명",			Type:"Popup",   	Hidden:0, 	Width:80,		Align:"Center", ColMerge:0, SaveName:"name", 	UpdateEdit:0, InsertEdit:1},
			{Header:"부서",			Type:"Text",   		Hidden:0, 	Width:90, 		Align:"Left",   ColMerge:0, SaveName:"orgNm", 	Edit:0},
			{Header:"직위",			Type:"Text",   		Hidden:0, 	Width:80,		Align:"Center", ColMerge:0, SaveName:"jikweeNm",Edit:0},
			{Header:"리조트명",		Type:"Text",   		Hidden:0, 	Width:80,		Align:"Center", ColMerge:0, SaveName:"companyCd",Edit:0},
			{Header:"지점명",		Type:"Text",   		Hidden:0, 	Width:70,		Align:"Left", 	ColMerge:0, SaveName:"resortNm",Edit:0},
			{Header:"객실타입",		Type:"Text",   		Hidden:0, 	Width:150,		Align:"Left", 	ColMerge:0, SaveName:"roomType",Edit:0},
			{Header:"체크인",		Type:"Date",   		Hidden:0, 	Width:80,		Align:"Center", ColMerge:0, SaveName:"sdate",	Format:"Ymd", Edit:0},
			{Header:"체크아웃",		Type:"Date",   		Hidden:0, 	Width:80,		Align:"Center", ColMerge:0, SaveName:"edate",	Format:"Ymd", Edit:0},
			{Header:"회사지원금",	Type:"Int",   		Hidden:0, 	Width:80,		Align:"Right",  ColMerge:0, SaveName:"comMon",	Format:"", Edit:0},
			{Header:"비고", 		Type:"Text", 		Hidden:0, 	Width:300, 		Align:"Left", 	ColMerge:0,	SaveName:"note", 	KeyField:0, Format:"", PointCount:0, 	UpdateEdit:1, InsertEdit:1 },

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/ResortTargetMgr.do?cmd=getResortTargetMgrList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/ResortTargetMgr.do?cmd=saveResortTargetMgr", $("#sheet1Form").serialize());
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
			case "DownTemplate":
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"year|sabun|note"});
				break;
			case "LoadExcel":
				var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
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

			var rv = null;

			if (sheet1.ColSaveName(Col) == "name") {  //대상자 선택

				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "employeePopup";
				var args    = new Array();
				
				//openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");
               let layerModal = new window.top.document.LayerModal({
                      id : 'employeeLayer'
                      , url : '/Popup.do?cmd=viewEmployeeLayer'
                      , parameters : args
                      , width : 840
                      , height : 520
                      , title : '사원조회'
                      , trigger :[
                          {
                              name : 'employeeTrigger'
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
	
	//---------------------------------------------------------------------------------------------------------------
	// 팝업 콜백 함수.
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(rv) {

		//var rv = $.parseJSON('{'+ returnValue+'}');
		if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "name",	rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"] );

			sheet1.SetCellValue(gPRow, "orgNm",	rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
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
			<th>기준년도</th>
			<td>
				<input type="text" id="searchYear" name="searchYear" class="date2 w80 center" maxlength="4"/>
			</td>
			<th>사번/성명</th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text"/>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>

	<div class="sheet_title inner">
		<ul>
			<li class="txt">리조트지원대상자 관리</li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline-gray authR" mid="download" mdef="다운로드"/>
				<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline-gray authR" mid="down2ExcelV1" mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline-gray authR" mid="upload" mdef="업로드"/>
				<btn:a href="javascript:doAction1('Copy');" 		css="btn outline-gray authA" mid="copy" mdef="복사"/>
				<btn:a href="javascript:doAction1('Insert');" 		css="btn outline-gray authA" mid="insert" mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" 		css="btn filled authA" mid="save" mdef="저장"/>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>
