<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>필수교육과정 기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {

		// 숫자만 입력가능
		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchYear").change(function () {
			getCommonCodeList();
		});

		$("#searchJobNm, #searchEduCourseNm").keyup(function() {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		//교육구분 선택 시
		$("#searchGubunCd, #searchJikgubCd, #searchEduLevel").on("change", function(e) {
			doAction1("Search");
		})
		
		
		//Sheet 초기화
		init_sheet1();

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

			{Header:"교육구분|교육구분",		Type:"Combo",		Hidden:0,	Width:170,	Align:"Center",	ColMerge:0,	SaveName:"gubunCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"우선\n순위|우선\n순위",	Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			
			{Header:"대상자기준|직급",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"대상자기준|직급년차",	Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubYear",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"대상자기준|직무명",		Type:"Popup",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"대상자기준|직무\n코드",	Type:"Text",		Hidden:0, 	Width:60,  	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"", 			PointCount:0,	UpdateEdit:1,   InsertEdit:1 },
			
  			{Header:"대상자기준|조건검색명",	Type:"Popup",		Hidden:0, 	Width:140,  Align:"Center",	ColMerge:0,	SaveName:"searchDesc",	KeyField:0,	Format:"", 			PointCount:0,	UpdateEdit:1,   InsertEdit:1 },
  			{Header:"대상자기준|조건검색\n코드",	Type:"Text",	Hidden:0, 	Width:60,  	Align:"Center",	ColMerge:0,	SaveName:"searchSeq",	KeyField:0,	Format:"", 			PointCount:0,	UpdateEdit:1,   InsertEdit:1 },
			
			{Header:"입과월|입과월",		Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ym",			KeyField:0,	Format:"##\\월",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"회차\n시작월|회차\n시작월",Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"stMon",		KeyField:1,	Format:"##\\월",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"회차\n종료월|회차\n종료월",Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"edMon",		KeyField:1,	Format:"##\\월",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			
			{Header:"과정코드|과정코드",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduSeq",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1 },
			{Header:"과정명|과정명",		Type:"Popup",		Hidden:0, 	Width:300,  Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",	KeyField:0,	Format:"", 			PointCount:0,	UpdateEdit:1,   InsertEdit:1 },
			{Header:"과정난이도|과정난이도",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduLevel",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"비고|비고",			Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },

  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"year"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"seq"},

  			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		getCommonCodeList();
	}

	function getCommonCodeList() {
		if( $("#searchYear").val() == ""  || $("#searchYear").val().length != 4  ){
			return;
		}

		let searchYear = $("#searchYear").val();
		let baseSYmd = "";
		let baseEYmd = "";
		if (searchYear !== '') {
			baseSYmd = searchYear + "-01-01";
			baseEYmd = searchYear + "-12-31";
		}

		//공통코드 한번에 조회
		let grpCds = "L16010,H20010,L10090";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		const codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");
		sheet1.SetColProperty("gubunCd",  	{ComboText:"|"+codeLists["L16010"][0], ComboCode:"|"+codeLists["L16010"][1]} ); //교육구분
		sheet1.SetColProperty("jikgubCd",  	{ComboText:"|"+codeLists["H20010"][0], ComboCode:"|"+codeLists["H20010"][1]} ); //직급
		sheet1.SetColProperty("eduLevel",  	{ComboText:"|"+codeLists["L10090"][0], ComboCode:"|"+codeLists["L10090"][1]} ); //과정난이도

		// 교육구분
		$("#searchGubunCd").html(codeLists["L16010"][2]);
		// 직급
		$("#searchJikgubCd").html(codeLists["H20010"][2]);
		//과정난이도
		$("#searchEduLevel").html(codeLists["L10090"][2]);
	}


	function checkList(){
		if( $("#searchYear").val() == "" ){
			alert("기준년도를 입력 해주세요");
			$("#searchYear").focus();
			return false;
		}
		if( $("#searchYear").val().length != 4 ){
			alert("기준년도를 정확히 입력 해주세요");
			$("#searchYear").focus();
			return false;
		}
		return true;
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if( !checkList() ) return;
				sheet1.DoSearch( "${ctx}/RequiredStd.do?cmd=getRequiredStdList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if( !checkList() ) return;
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/RequiredStd.do?cmd=saveRequiredStd", $("#sheet1Form").serialize());
				break;
			case "Insert":
				if( !checkList() ) return;
				var row = sheet1.DataInsert(0);
				sheet1.SetCellValue(row, "year", $("#searchYear").val());
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "orderSeq", "");
				sheet1.SetCellValue(row, "seq", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
			case "DownTemplate":
				// 양식다운로드
				var downcol = makeHiddenSkipCol(sheet1);
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:downcol});
				break;
			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;
			case "Prc1":	//전년도 복사

				if( !checkList() ) return;
				if(!confirm("전년도 기준정보를 복사하시겠습니까?\n현재 년도 기준정보는 삭제 됩니다.")) { return ;}

				progressBar(true) ;
				
				setTimeout(
					function(){
						var data = ajaxCall("${ctx}/RequiredStd.do?cmd=saveRequiredStdYear", $("#sheet1Form").serialize(),false);
				    	if(data.Result.Code == null || data.Result.Code > 0) {
				    		doAction1("Search");
				    		alert("정상적으로 처리되었습니다.");
					    	progressBar(false) ;
				    	} else {
					    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
					    	progressBar(false) ;
				    	}
					}
				, 100);
				break;
			case "Prc2":	//회차생성

				if( !checkList() ) return;
				if(!confirm("기준에 따라 회차를 자동으로 생성하시겠습니까?\n이미 생성된 회차는 다시 생성되지 않습니다.")) { return ;}
			
				progressBar(true) ;
				
				setTimeout(
					function(){
						var data = ajaxCall("${ctx}/RequiredStd.do?cmd=prcRequiredStdEvt", $("#sheet1Form").serialize(),false);
						console.log(data)
				    	if(data.Result.Code == null || data.Result.Code == "") {
				    		alert(data.Result.Message);
					    	progressBar(false) ;
				    	} else {
					    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
					    	progressBar(false) ;
				    	}
					}
				, 100);
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
	
	// 셀 변경 시 
	function sheet1_OnChange(Row, Col, Value) {
		try {
			if (sheet1.ColSaveName(Col) == "jobCd") {
				sheet1.SetCellValue(Row, "jobNm", "");
			}
			if (sheet1.ColSaveName(Col) == "searchSeq") {
				sheet1.SetCellValue(Row, "searchDesc", "");
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}
	
	// 셀 팝업 클릭 시
	function sheet1_OnPopupClick(Row, Col) {
		try {
			if (sheet1.ColSaveName(Col) == "eduCourseNm") {  //교육과정명 선택
				if (!isPopup()) {  return; }

				gPRow = Row;
				pGubun = "eduPopup";
				var args 	= new Array();
				args["searchEduMethodCd"] = "A"; //필수교육  

				let modalLayer = new window.top.document.LayerModal({
					id: 'eduCourseLayer',
					url: '/Popup.do?cmd=viewEduCourseLayer&authPg=R',
					parameters: args,
					width: 600,
					height: 630,
					title: '교육과정 리스트 조회',
					trigger: [
						{
							name: 'eduCourseLayerTrigger',
							callback: function(rv) {
								sheet1.SetCellValue(gPRow, "eduCourseNm", rv["eduCourseNm"]);
								sheet1.SetCellValue(gPRow, "eduSeq", rv["eduSeq"]);
								sheet1.SetCellValue(gPRow, "eduLevel", rv["eduLevel"]);
							}
						}
					]
				});
				modalLayer.show();
				
			}else if (sheet1.ColSaveName(Col) == "jobNm") {  //직무
				if (!isPopup()) {  return; }
				gPRow = Row;
				pGubun = "jobPopup";

				var layer = new window.top.document.LayerModal({
					id : 'jobPopupLayer'
					, url : "${ctx}/Popup.do?cmd=jobPopup&authPg=${authPg}"
					, parameters: {}
					, width : 740
					, height : 720
					, title : "직무 리스트 조회"
					, trigger :[
						{
							name : 'jobPopupTrigger'
							, callback : function(rv){
								sheet1.SetCellValue(gPRow, "jobCd", rv["jobCd"], 0);
								sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"]);
							}
						}
					]
				});
				layer.show();
				
			}else if(sheet1.ColSaveName(Col) == "searchDesc") { //조건검색
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "pwrSrchMgrPopup";

				var args    = new Array();
				args["srchBizCd"]   = "05"; // 교육관리

				let layerModal = new window.top.document.LayerModal({
					id : 'pwrSrchMgrLayer'
					, url : '/Popup.do?cmd=viewPwrSrchMgrLayer'
					, parameters : args
					, width : 1100
					, height : 520
					, title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>'
					, trigger :[
						{
							name : 'pwrTrigger'
							, callback : function(rv){
								sheet1.SetCellValue(gPRow, "searchSeq", rv["searchSeq"], 0);
								sheet1.SetCellValue(gPRow, "searchDesc", rv["searchDesc"]);
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
				<input type="text" id="searchYear" name="searchYear" class="text required w70 center" value="${curSysYear}" maxlength="4"/>
			</td>
			<th>교육구분</th>
			<td>
				<select id="searchGubunCd" name="searchGubunCd"></select>
			</td>
			<th>직급</th>
			<td>
				<select id="searchJikgubCd" name="searchJikgubCd"></select>
			</td>
		</tr>
		<tr>
			<th>과정난이도</th>
			<td>
				<select id="searchEduLevel" name="searchEduLevel"></select>
			</td>
			<th>직무명</th>
			<td>
				<input type="text" id="searchJobNm" name="searchJobNm" class="text w150"/>
			</td>
			<th>과정명</th>
			<td>
				<input type="text" id="searchEduCourseNm" name="searchEduCourseNm" class="text w150"/>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="button">조회</a>
			</td>
		</tr>
		</table>
	</div>
	</form>

	<div class="sheet_title inner">
		<ul>
			<li class="txt">필수교육 기준관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction1('DownTemplate')"	class="btn outline-gray authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')"		class="btn outline-gray authA">엑셀업로드</a>
				<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
				<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
				<a href="javascript:doAction1('Save');" 		class="btn soft authA">저장</a>

				<a href="javascript:doAction1('Prc2')"			class="btn filled authA">회차생성</a>
				<a href="javascript:doAction1('Prc1')"			class="btn filled authA">전년도복사</a>
			</li>
		</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>
