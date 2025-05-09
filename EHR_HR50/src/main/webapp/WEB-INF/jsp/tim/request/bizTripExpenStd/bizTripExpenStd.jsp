<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>출장비기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var codeLists;

	$(function() {
		//TAB
		$("#tabs").tabs();
		$("#tabsIndex").val('0');

		//initTabsLine(); //탭 하단 라인 추가
		
		//기준일자
		$("#searchYmd").datepicker2();

		getCommonCodeList();
		//Sheet 초기화
		init_sheet1();
		init_sheet2();
		init_sheet3();

		$(window).smartresize(sheetResize); sheetInit();
		
		doSearchAll();
	});

	function getCommonCodeList() {
		//공통코드 한번에 조회
		let baseSYmd = $("#searchYmd").val();
		let grpCds = "T85200,S10030,T00862,T85101,H20010";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd;
		codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");
	}

	//[유류비기준관리] Sheet 초기화 
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"유류구분|유류구분",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gubunCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"시작일|시작일",		 	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"종료일|종료일",		 	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"단가|단가",				Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"unitPrice",	KeyField:0,	Format:"##,###\\ 원",PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"최소주행거리|최소주행거리",	Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"lmtDistDriv",	KeyField:0,	Format:"##\\ km",	PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"비고|비고",			 	Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1, EditLen:2000 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("gubunCd",  	{ComboText:"|"+codeLists["T85200"][0], ComboCode:"|"+codeLists["T85200"][1]} ); //유류구분 
		
	}

	
	//[환율기준관리] Sheet 초기화 
	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"통화구분|통화구분",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gubunCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"시작일|시작일",		 	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"종료일|종료일",		 	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"환율|환율",				Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"exchgRate",	KeyField:0,	Format:"##,###\\ 원",PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"비고|비고",			 	Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1, EditLen:2000 }
			
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
			
		sheet2.SetColProperty("gubunCd",  	{ComboText:"|"+codeLists["S10030"][0], ComboCode:"|"+codeLists["S10030"][1]} ); //통화 
		
	}
	//[여비기준관리] Sheet 초기화 
	function init_sheet3(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"출장구분|출장구분",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bizCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"여비구분|여비구분",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gubunCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"적용순서|적용순서",			Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"직책|직책",				Type:"Popup",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"직위|직위",				Type:"Popup",		Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"직급|직급",				Type:"Popup",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"통화단위|통화단위",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"currencyCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"지급한도|지급한도",			Type:"Int",			Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"lmtPayMon",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },

			{Header:"시작일|시작일",		 	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"종료일|종료일",		 	Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"비고|비고",			 	Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1, EditLen:2000 },

			{Header:"Hidden", Hidden:1,	 SaveName:"seq"},
			{Header:"Hidden", Hidden:1,	 SaveName:"jikchakCd"},
			{Header:"Hidden", Hidden:1,	 SaveName:"jikweeCd"},
			{Header:"Hidden", Hidden:1,	 SaveName:"jikgubCd"},
		]; IBS_InitSheet(sheet3, initdata1);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);
		
		sheet3.SetColProperty("bizCd",  	{ComboText:"|"+codeLists["T00862"][0], ComboCode:"|"+codeLists["T00862"][1]} ); //출장구분 
		sheet3.SetColProperty("gubunCd",  	{ComboText:"|"+codeLists["T85101"][0], ComboCode:"|"+codeLists["T85101"][1]} ); //여비구분 
		sheet3.SetColProperty("currencyCd", {ComboText:"|"+codeLists["S10030"][0], ComboCode:"|"+codeLists["S10030"][1]} ); //통화단위 
		
		
		
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/BizTripExpenStd.do?cmd=getBizTripExpenStdOilList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/BizTripExpenStd.do?cmd=saveBizTripExpenStdOil", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				//sheet1.SetCellValue(row, "useYn", "Y");
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
	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				sheet2.DoSearch( "${ctx}/BizTripExpenStd.do?cmd=getBizTripExpenStdExcList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form,sheet2);
				sheet2.DoSave( "${ctx}/BizTripExpenStd.do?cmd=saveBizTripExpenStdExc", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet2.DataInsert(0);
				break;
			case "Copy":
				var row = sheet2.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
				break;
		}
	}


	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
			case "Search":
				sheet3.DoSearch( "${ctx}/BizTripExpenStd.do?cmd=getBizTripExpenStdLmtList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if(!dupChk(sheet3,"bizCd|gubunCd|orderSeq", true, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet3);
				sheet3.DoSave( "${ctx}/BizTripExpenStd.do?cmd=saveBizTripExpenStdLmt", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet3.DataInsert(-1);
				break;
			case "Copy":
				var row = sheet3.DataCopy();
				sheet3.SetCellValue(row, "seq", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet3);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet3.Down2Excel(param);
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
			/*
			sheet1.ShowFooterRow([{
	            "gubunCd": "입력 시 주의사항",
	            "gubunCd#ColSpan": 6,
	            "gubunCd#Align": "Left",
	            "gubunCd#FontColor": "Blue"
	        }, {
	            "gubunCd": "주의사항 주의사항.....",
	            "gubunCd#ColSpan": 6,
	            "gubunCd#Align": "Left",
	            "gubunCd#FontColor": "Blue"
	       
	        }]);*/
		  
		} catch (ex) {
			alert("sheet1_OnSearchEnd Event Error : " + ex);
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
			alert("sheet1_OnSaveEnd Event Error " + ex);
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
		} catch (ex) {
			alert("sheet2_OnSearchEnd Event Error : " + ex);
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
			alert("sheet2_OnSaveEnd Event Error " + ex);
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet3 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("sheet3_OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction3("Search");
		} catch (ex) {
			alert("sheet3_OnSaveEnd Event Error " + ex);
		}
	}

	function sheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {

			$(".cb-Div").hide();
			if (Row < sheet3.HeaderRows() ) return;
			
			if ( sheet3.ColSaveName(Col) == "jikchakNm") {  //직책명
				gPRow = Row;
				showMultiComboBox(sheet3, "jikchakCd", "jikchakNm", "comboBox1", "H20020");

			}else if ( sheet3.ColSaveName(Col) == "jikweeNm") {  //직위명
				gPRow = Row;
				showMultiComboBox(sheet3, "jikweeCd", "jikweeNm", "comboBox2", "H20030");
				
			}else if ( sheet3.ColSaveName(Col) == "jikgubNm") {  //직급명
				gPRow = Row;
				showMultiComboBox(sheet3, "jikgubCd", "jikgubNm", "comboBox3", "H20010");
			}
			
		} catch (ex) {
			alert("sheet3_OnClick Event Error : " + ex);
		}
	}

	//멀티 콤보 선택
	function showMultiComboBox(sheet, saveNameCd, saveNameNm, divId, grcode){
		try {
			
			var comboBoxDiv = $("#"+divId);
			if( !comboBoxDiv.length ) { //최초 생성 시

				var comboBoxDiv = $("<div id='"+divId+"'>").addClass("cb-Div");	
				$("body").append(comboBoxDiv);

				//직책콤보
				var comboObj = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", grcode);
				var strHtml = "<ul>"; 
				for(var i in comboObj){
					strHtml +="<li class='cb-li'><input type='checkbox' class='cb-chk' id='sel"+comboObj[i].code+"' code='"+comboObj[i].code+"' codeNm='"+comboObj[i].codeNm+"' onclick='this.checked=!this.checked;'/> "+comboObj[i].codeNm+"</li>"; 
			    }
				strHtml += "</ul>";
				$(comboBoxDiv).html(strHtml);

				//콤보박스 외 다른 곳 클릭 시 콤보박스 감추기 
				$(document).click(function(e){
					if( !$(e.target).hasClass("GMCell") && !$(e.target).hasClass("cb-li") && !$(e.target).hasClass("cb-chk") ){
						$(".cb-Div").hide();
				    }
				});
			
				//콤보박스 Row 클릭 시
				$("#"+divId+" li").click(function() {
					if( $(this).find("input").is(":checked") ){
						$(this).find("input").prop( "checked", false );
					}else{
						$(this).find("input").prop( "checked", true );
					}

					var chkCode = "", chkCodeNm = "";
					$("#"+divId+" li :input:checked").each(function(){
						chkCode += $(this).attr("code") +",";
						chkCodeNm += $(this).attr("codeNm") +",";
					});
					sheet.SetCellValue(gPRow, saveNameCd, chkCode.substring(0, chkCode.length-1 ));
					sheet.SetCellValue(gPRow, saveNameNm, chkCodeNm.substring(0, chkCodeNm.length-1 ));
				});
				
			}
			
			// 시트데이터 셋팅
			var dataCode = ","+sheet.GetCellValue(gPRow, saveNameCd)+",";
			$("#"+divId+" li :input").each(function(){
				if( dataCode.indexOf( ","+$(this).attr("code")+"," ) > -1 ){
					$(this).prop( "checked", true );
				}else{
					$(this).prop( "checked", false );
				}
			});
			

			//팝업위치
			var itop = $("#DIV_"+sheet3.id).offset().top + sheet.RowTop(gPRow) + sheet.GetRowHeight(gPRow);
			var ileft = sheet.ColLeft(saveNameNm);
			var iwidth = sheet.GetColWidth(saveNameNm)-2;
			/* 박스 크기가 브라우저에 넘치는지 체크 해서 위치 다시 잡기*/
			
			var ibottom = itop + $(".cb-Div").height();
			if( ibottom > $("body").height() ){
				itop = $("#DIV_"+sheet3.id).offset().top + sheet.RowTop(gPRow) - $(".cb-Div").height() - 2;
			}
			$("#"+divId).css("top", itop).css("left", ileft).css("width", iwidth).show();
				
			
		} catch (ex) {
			alert("showMultiComboBox Script Error : " + ex);
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// TAB 
	//---------------------------------------------------------------------------------------------------------------
	function moveTab(idx){
		$("#tabsIndex").val(idx);
		$("#tabs").tabs( "option", "active", idx );

		sheetResize();
	}

	function doSearchAll() {
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	}
	
</script>
<style type="text/css">
.cb-Div {position: absolute; top:0; left:0; width:120px; height:200px; border:1px solid #b1b1b1; background-color:#FFF;z-index:999;display:none; overflow-y:auto;}
.cb-Div li {padding :2px 0 2px 10px;}
.cb-Div li:hover { background-color: #FFF5C8; }
</style>
</head>
<body class="bodywrap">
<div class="wrapper">

<form name="sheet1Form" id="sheet1Form" method="post">
	<input type="hidden" id="searchItemCd" name="searchItemCd" />
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준일자</th>
			<td>
				<input type="text" id="searchYmd" name="searchYmd" class="date2" value="${curSysYyyyMMddHyphen}"/>
			</td>
			<td>
				<a href="javascript:doSearchAll()" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
</form>
<div class="h10 outer"></div>	
<div id="tabs" class="tab">
	<div class="ui-tabs-nav-line"></div> <!-- 탭 하단 라인 -->
	<ul class="outer hide">
		<li><a href="#tabs-0" onclick="javascript:moveTab(0)" >유류비/환율</a></li>
		<li><a href="#tabs-1" onclick="javascript:moveTab(1)" >출장여비지급기준</a></li>
	</ul>
	<div id="tabs-0">
		<div>
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt">유류비</li>
						<li class="btn">
							<a href="javascript:doAction1('Insert')" 		class="btn outline_gray authA">입력</a>
							<a href="javascript:doAction1('Copy')" 			class="btn outline_gray authA">복사</a>
							<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
							<a href="javascript:doAction1('Down2Excel');" 	class="btn outline_gray authR">다운로드</a>
						</li>
					</ul>
				</div>
			</div>

			<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>
		</div>

		<div>
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt">환율</li>
						<li class="btn">
							<a href="javascript:doAction2('Insert')" 		class="btn outline_gray authA">입력</a>
							<a href="javascript:doAction2('Copy')" 			class="btn outline_gray authA">복사</a>
							<a href="javascript:doAction2('Save');" 		class="btn filled authA">저장</a>
							<a href="javascript:doAction2('Down2Excel');" 	class="btn outline_gray authR">다운로드</a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>
		</div>
	
	</div>
	<div id="tabs-1">

		<div class="sheet_title inner">
			<ul>
				<li class="txt">출장여비지급기준</li>
				<li class="btn">
					<a href="javascript:doAction3('Insert')" 		class="btn outline_gray authA">입력</a>
					<a href="javascript:doAction3('Copy')" 			class="btn outline_gray authA">복사</a>
					<a href="javascript:doAction3('Save');" 		class="btn filled authA">저장</a>
					<a href="javascript:doAction3('Down2Excel');" 	class="btn outline_gray authR">다운로드</a>
				</li>
			</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet3", "100%", "100%"); </script>		
	
	</div>
</div>	
</div>
</body>
</html>
