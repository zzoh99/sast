<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>개인연금기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

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
		
		//Sheet 초기화
		init_sheet1();init_sheet2();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");


	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"직급|직급",			Type:"Combo",		Hidden:0,				Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			
			{Header:"지원금액|지원금액",		Type:"Int",			Hidden:0,				Width:80,	Align:"Right",	ColMerge:0,	SaveName:"compMon",		KeyField:0,	Format:"#,###\\원",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"대상자|대상자선택",		Type:"Popup",		Hidden:0, 				Width:200,  Align:"Center",	ColMerge:0,	SaveName:"searchDesc",	KeyField:0,	Format:"", 			PointCount:0,	UpdateEdit:1,   InsertEdit:1 },
			{Header:"대상자|조건검색순번",	Type:"Text",		Hidden:0,				Width:80,	Align:"Center",	ColMerge:0,	SaveName:"searchSeq",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"시작일|시작일",		Type:"Date",		Hidden:"${sDelHdn}",	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1 , EndDateCol:"edate"},
			{Header:"종료일|종료일",		Type:"Date",		Hidden:"${sDelHdn}",	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 , StartDateCol:"sdate"},
			
			{Header:"비고|비고",			Type:"Text",		Hidden:0,				Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
			//Hidden
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	}

	function getCommonCodeList() {
		//공통코드 한번에 조회
		var grpCds = "H20010,B65110";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + $("#searchYmd").val();
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");
		sheet1.SetColProperty("jikgubCd",  	{ComboText:"|"+codeLists["H20010"][0], ComboCode:"|"+codeLists["H20010"][1]} ); //직급코드
		sheet2.SetColProperty("code",  	{ComboText:"|"+codeLists["B65110"][0], ComboCode:"|"+codeLists["B65110"][1]} ); //개인연금 상품코드
	}

	//Sheet 초기화
	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			//{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"상품명|상품명",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"code",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"급여항목|회사지원금",	Type:"Popup",		Hidden:0, 	Width:150,  Align:"Center",	ColMerge:0,	SaveName:"elementNm1",		KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
  			{Header:"급여항목|회사지원금",	Type:"Text",		Hidden:1, 	Width:100,  Align:"Center",	ColMerge:0,	SaveName:"elementCd1",		KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
  			{Header:"급여항목|본인부담금",	Type:"Popup",		Hidden:0, 	Width:150,  Align:"Center",	ColMerge:0,	SaveName:"elementNm2",		KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
  			{Header:"급여항목|본인부담금",	Type:"Text",		Hidden:1, 	Width:100,  Align:"Center",	ColMerge:0,	SaveName:"elementCd2",		KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
			
			{Header:"비고|비고",			Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note3",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
			//Hidden
			
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(0);

	}
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				getCommonCodeList();
				sheet1.DoSearch( "${ctx}/PsnalPenStd.do?cmd=getPsnalPenStdList", $("#sheet1Form").serialize() );
				doAction2("Search");
				break;
			case "Save":
				if(!chkInVal()){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/PsnalPenStd.do?cmd=savePsnalPenStd", $("#sheet1Form").serialize());
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

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/PsnalPenStd.do?cmd=getPsnalPenStdList2", $("#sheet1Form").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form,sheet2);
				sheet2.DoSave( "${ctx}/PsnalPenStd.do?cmd=savePsnalPenStd2", $("#sheet1Form").serialize());
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

	//팝업 컬럼 클릭 시
	function sheet1_OnPopupClick(Row, Col){
		try{
			if(sheet1.ColSaveName(Col) == "searchDesc") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "pwrSrchMgrPopup";

				var args 	= new Array();
				
				//var rv = openPopup("/Popup.do?cmd=pwrSrchMgrPopup", args, "850","620");
               let layerModal = new window.top.document.LayerModal({
                   id : 'pwrSrchMgrLayer'
                   , url : '/Popup.do?cmd=viewPwrSrchMgrLayer'
                   , parameters : args
                   , width : 850
                   , height : 620
                   , title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>'
                   , trigger :[
                       {
                           name : 'pwrTrigger'
                           , callback : function(result){
                               sheet1.SetCellValue(Row, "searchSeq",   result.searchSeq);
                               sheet1.SetCellValue(Row, "searchDesc", result.searchDesc);
                          }
                       }
                  ]
              });
              layerModal.show();
			}

			
		} catch(ex){alert("OnPopupClick Event Error : " + ex);}
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
			if( Code > -1 ) doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//팝업 컬럼 클릭 시
	function sheet2_OnPopupClick(Row, Col){
		try{
			if(sheet2.ColSaveName(Col) == "elementNm1") { //급여항목

				if(!isPopup()) {return;}

				var args 	= new Array();
				gPRow = Row;
				pGubun = "payElementPopup1";
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
				
			}else if(sheet2.ColSaveName(Col) == "elementNm2") { //급여항목

				if(!isPopup()) {return;}

				var args 	= new Array();
				gPRow = Row;
				pGubun = "payElementPopup2";
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
			
		} catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	//팝업 콜백
	function getReturnValue(rv) {
		//var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "pwrSrchMgrPopup"){
			sheet1.SetCellValue(gPRow, "searchSeq", 	rv["searchSeq"] );
			sheet1.SetCellValue(gPRow, "searchDesc",	rv["searchDesc"] );
		}else if (pGubun == "payElementPopup1") { // 급여항목 팝업
			sheet2.SetCellValue(gPRow, "elementCd1", rv["resultElementCd"], 0);
			sheet2.SetCellValue(gPRow, "elementNm1", rv["resultElementNm"]);
		}else if (pGubun == "payElementPopup2") { // 급여항목 팝업
			sheet2.SetCellValue(gPRow, "elementCd2", rv["resultElementCd"], 0);
			sheet2.SetCellValue(gPRow, "elementNm2", rv["resultElementNm"]);
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
				<a href="javascript:doAction1('Search')" class="button">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li class="txt">개인연금 급여항목</li>
				<li class="btn">
					<a href="javascript:doAction2('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction2('Save');" 		class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "200px"); </script>
	</div>

	<div class="sheet_title inner">
		<ul>
			<li class="txt">개인연금기준관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
				<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
				<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>
