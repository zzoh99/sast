<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>필수교육대상자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>


<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {

		$("#searchEduCourseNm,#searchSabunName").keyup(function() {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
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

		$("#searchGubunCd, #searchEduAppYn, #searchEduConfYn, #searchReAppYn, #searchJikgubCd").on("change", function(e) {
			doAction1("Search");
		})
		
		$("#searchEduYm").datepicker2({ymonly:true,onReturn:function(){doAction1("Search");}});
		
		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name", rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubYear", rv["jikgubYear"]);
						sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"]);
						sheet1.SetCellValue(gPRow, "statusNm", rv["statusNm"]);
					}
				}
			]
		});
		
	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:6,FrozenColRight:1};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제|삭제",				Type:"${sDelTy}", Hidden:Number("${sDelTy}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"교육구분|교육구분",			Type:"Combo",   Hidden:0, Width:170, 	Align:"Center", ColMerge:0,  SaveName:"gubunCd", 		KeyField:1, UpdateEdit:0,	InsertEdit:1},
			{Header:"대상자|사번",				Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			KeyField:1, Edit:0},
			{Header:"대상자|성명",				Type:"Popup",   Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			KeyField:0, UpdateEdit:0,	InsertEdit:1},
			{Header:"대상자|부서",				Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			KeyField:0, Edit:0},
			{Header:"대상자|직책",				Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		KeyField:0, Edit:0},
			{Header:"대상자|직위",				Type:"Text",   	Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		KeyField:0, Edit:0},
			{Header:"대상자|직급",				Type:"Text",   	Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		KeyField:0, Edit:0},
			{Header:"대상자|직급년차",			Type:"Int",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"jikgubYear", 	KeyField:0, Edit:0},
			{Header:"대상자|직무명",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Center", ColMerge:0,  SaveName:"jobNm", 			KeyField:0, Edit:0},
			{Header:"대상자|조건검색",			Type:"Text",   	Hidden:0, Width:140, 	Align:"Center", ColMerge:0,  SaveName:"searchDesc", 	KeyField:0, Edit:0},
			{Header:"대상자|재직상태",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"statusNm", 		KeyField:0, Edit:0},

			{Header:"필수교육과정|입과순번",		Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"rnum", 			KeyField:0, Edit:0 },
			{Header:"필수교육과정|과정코드",		Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"eduSeq", 		KeyField:0, Edit:0 },
			{Header:"필수교육과정|과정명",		Type:"Popup",   Hidden:0, Width:200, 	Align:"Center", ColMerge:0,  SaveName:"eduCourseNm", 	KeyField:1, 	UpdateEdit:0,	InsertEdit:1},
			{Header:"필수교육과정|과정난이도",		Type:"Combo",	Hidden:0, Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduLevel",		KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0 },
			{Header:"필수교육과정|입과월",		Type:"Date",    Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"eduYm", 			Format:"Ym", 	KeyField:1, UpdateEdit:0,	InsertEdit:0},
			{Header:"필수교육과정|교육시작일",		Type:"Date",    Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"eduSYmd", 		Format:"Ymd", 	KeyField:0, Edit:0 },
			{Header:"필수교육과정|교육종료일",		Type:"Date",    Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"eduEYmd", 		Format:"Ymd", 	KeyField:0, Edit:0 },
			{Header:"필수교육과정|입과여부",		Type:"Image",   Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"eduAppYn", 		KeyField:0, Edit:0 },
			{Header:"필수교육과정|수료여부",		Type:"Image",   Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"eduConfYn", 		KeyField:0, Edit:0 },
			{Header:"비고|비고",				Type:"Text",   	Hidden:0, Width:200, 	Align:"Left", 	ColMerge:0,  SaveName:"note", 			KeyField:0, UpdateEdit:1,	InsertEdit:1},
			{Header:"에러메시지|에러메시지",		Type:"Text",   	Hidden:0, Width:150, 	Align:"Left", 	ColMerge:0,  SaveName:"errNote", 		KeyField:0, Edit:0 },
			//Hidden
			{Header:"Hidden",		Type:"Text",   	Hidden:1, SaveName:"eduEventSeq"},
			{Header:"Hidden",		Type:"Text",   	Hidden:1, SaveName:"year"},
			{Header:"Hidden",		Type:"Text",   	Hidden:1, SaveName:"applSeq"},
			
			{Header:"\n선택|\n선택",			Type:"CheckBox",Hidden:0, Width:55, 	Align:"Center", ColMerge:0,  SaveName:"sel", 			KeyField:0, UpdateEdit:1,	InsertEdit:1},
			
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

 		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_x.png");
 		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_o.png");

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
		let grpCds = "L16010,L10090,H20010";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "전체");
		sheet1.SetColProperty("gubunCd",  	{ComboText:"|"+codeLists["L16010"][0], ComboCode:"|"+codeLists["L16010"][1]} ); //교육구분
		sheet1.SetColProperty("eduLevel",  	{ComboText:"|"+codeLists["L10090"][0], ComboCode:"|"+codeLists["L10090"][1]} ); //과정난이도

		$("#searchGubunCd").html(codeLists["L16010"][2]); //교육구번
		$("#searchJikgubCd").html(codeLists["H20010"][2]); //직급
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
				var sXml = sheet1.GetSearchData("${ctx}/RequiredMgr.do?cmd=getRequiredMgrList", $("#sheet1Form").serialize() );
				sXml = replaceAll(sXml,"rowEdit", "Edit");
				sXml = replaceAll(sXml,"selEdit", "sel#Edit");
				sheet1.LoadSearchData(sXml );
				break;
			case "Save":
				if( !checkList() ) return;
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/RequiredMgr.do?cmd=saveRequiredMgr", $("#sheet1Form").serialize());
				break;
			case "SaveExcel":
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/RequiredMgr.do?cmd=saveRequiredMgrExcel", $("#sheet1Form").serialize(), -1,0);
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				sheet1.SelectCell(row, "name");
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "rnum", "");
				sheet1.SetCellValue(row, "applSeq", "");
				sheet1.SetCellValue(row, "eduEventSeq", "");
				sheet1.SetCellValue(row, "eduSYmd", "");
				sheet1.SetCellValue(row, "eduEYmd", "");
				sheet1.SetCellValue(row, "eduConfYn", "");
				sheet1.SetCellValue(row, "eduAppYn", "");
				sheet1.SetCellValue(row, "errNote", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
			case "DownTemplate":
				// 양식다운로드
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"gubunCd|sabun|eduSeq|eduCourseNm|eduYm"});
				break;
			case "LoadExcel":
				if( !checkList() ) return;
				var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
				sheet1.LoadExcel(params);
				break;
			case "Prc":
				
				if( !checkList() ) return;

		        if (!confirm("필수교육 대상자를 생성 하시겠습니까?\n(이미 생성된 대상자는 삭제 되지 않습니다.)")) return;
				
				progressBar(true, "필수교육 대상자를 생성중입니다.");
				
				setTimeout(
					function(){
				    	
						var data = ajaxCall("${ctx}/RequiredMgr.do?cmd=prcRequiredMgr", $("#sheet1Form").serialize(),false);
				    	if(data.Result.Code == null) {
				    		doAction1("Search");
				    		alert(data.Result.Message);
					    	progressBar(false) ;
				    	} else {
					    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
					    	progressBar(false) ;
				    	}
					}
				, 100);
				break;
			case "SaveApp": // 입과

				if ( sheet1.FindStatusRow("I|D") != "" ) {
					alert("입력 또는 삭제 중인 항목이 존재합니다. 먼저 처리 해주세요.");
					return;
				}
			
		        if (!confirm("선택한 대상자들의 입과 하시겠습니까?")) return;
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/RequiredMgr.do?cmd=saveRequiredMgrApp", $("#sheet1Form").serialize(), "sel", 0);
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
			if( Row < sheet1.HeaderRows() ) return;
			
			if (sheet1.ColSaveName(Col) == "name") {  //대상자 선택
				if (!isPopup()) {  return; }

				gPRow = Row;
				pGubun = "employeePopup";

				let layerModal = new window.top.document.LayerModal({
					id : 'employeeLayer'
					, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
					, parameters : {
						name : sheet1.GetCellValue(Row, "name")
						, sabun : sheet1.GetCellValue(Row, "sabun")
					}
					, width : 840
					, height : 520
					, title : '사원조회'
					, trigger :[
						{
							name : 'employeeTrigger'
							, callback : function(rv){
								sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
								sheet1.SetCellValue(gPRow, "name",		rv["name"] );
								sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
								sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"] );
								sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
								sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"] );
								sheet1.SetCellValue(gPRow, "jikgubYear",rv["jikgubYear"] );
								sheet1.SetCellValue(gPRow, "jobNm",		rv["jobNm"] );
								sheet1.SetCellValue(gPRow, "statusNm",	rv["statusNm"] );
								sheet1.SetCellValue(gPRow, "jikgubYear",rv["jikgubYear"] );
							}
						}
					]
				});
				layerModal.show();
			} else if (sheet1.ColSaveName(Col) == "eduCourseNm") {  //과정선택
				if( !checkList() ) return;
				
				if (!isPopup()) {  return; }

				var args 	= new Array();
				args["searchEduBranchCd"] = "B"; //필수교육
				
				gPRow = Row;
				pGubun = "requiredMgrPop";
				let modalLayer = new window.top.document.LayerModal({
					id: 'requiredMgrLayer',
					url: '/RequiredMgr.do?cmd=viewRequiredMgrLayer&authPg=R',
					parameters: args,
					width: 800,
					height: 620,
					title: '필수교육과정 선택',
					trigger: [
						{
							name: 'requiredMgrLayerTrigger',
							callback: function(rv) {
								sheet1.SetCellValue(gPRow, "eduSeq",		rv["eduSeq"] );
								sheet1.SetCellValue(gPRow, "eduCourseNm",	rv["eduCourseNm"] );
								sheet1.SetCellValue(gPRow, "eduLevel",		rv["eduLevel"] );
								sheet1.SetCellValue(gPRow, "eduYm",			rv["eduYm"] );
							}
						}
					]
				});
				modalLayer.show();
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
				<th>입과월</th>
				<td>
					<input type="text" id="searchEduYm" name="searchEduYm" value="" class="date2"/>
				</td>
				<th><label for="searchReAppYn">재입과대상자</label></th>
				<td>
					<input type="checkbox" id="searchReAppYn" name="searchReAppYn" class="checkbox" value="Y" />
				</td>
			</tr>
			<tr>
				<th>사번/성명</th>
				<td>
					<input type="text" id="searchSabunName" name="searchSabunName" class="text w100" />
				</td>
				<th>직급</th>
				<td>
					<select id="searchJikgubCd" name="searchJikgubCd"></select>
				</td>
				<th>과정명</th>
				<td>
					<input type="text" id="searchEduCourseNm" name="searchEduCourseNm" class="text w150" />
				</td>
				<th>입과여부</th>
				<td>
					<select id="searchEduAppYn" name="searchEduAppYn">
						<option value="">전체</option>
						<option value="1">입과</option>
						<option value="0">미입과</option>
					</select>
				</td>
				<th>수료여부</th>
				<td>
					<select id="searchEduConfYn" name="searchEduConfYn">
						<option value="">전체</option>
						<option value="1">수료</option>
						<option value="0">미수료</option>
					</select>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
				</td>
			</tr>
			</table>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">필수교육대상자관리</li>
			<li class="btn">
				&nbsp;&nbsp;&nbsp;
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline_gray authR">다운로드</a>
				<a href="javascript:doAction1('DownTemplate')" 	class="btn outline_gray authR">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel');" 	class="btn outline_gray authR">업로드</a>
				<a href="javascript:doAction1('Copy')" 			class="btn outline_gray authA">복사</a>
				<a href="javascript:doAction1('Insert')" 		class="btn outline_gray authA">입력</a>
				<a href="javascript:doAction1('Save');" 		class="btn soft authA">저장</a>
				<a href="javascript:doAction1('SaveApp')"		class="btn filled authA">(재)입과</a>
				<a href="javascript:doAction1('Prc')" 			class="btn filled authA">대상자생성</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
