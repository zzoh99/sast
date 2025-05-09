<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>건강검진대상자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {

		$("#searchHospNm,#searchSabunName").keyup(function() {
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
		
		//Sheet 초기화
		init_sheet1();

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

	});

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제",			Type:"${sDelTy}", Hidden:Number("${sDelTy}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			KeyField:0, Edit:0},
			{Header:"성명",			Type:"Text",    Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			KeyField:0, Edit:0},
			{Header:"부서",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			KeyField:0, Edit:0},
			{Header:"직책",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		KeyField:0, Edit:0},
			{Header:"직위",			Type:"Text",   	Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		KeyField:0, Edit:0},
			
			{Header:"대상자구분",	Type:"Combo",   Hidden:0, Width:70, 	Align:"Center", ColMerge:0,  SaveName:"gubun", 			KeyField:0, Edit:0, ComboText:"|본인|배우자", ComboCode:"|0|1"},
			{Header:"대상자명",		Type:"Popup",   Hidden:0, Width:70, 	Align:"Center", ColMerge:0,  SaveName:"famNm", 			KeyField:1, UpdateEdit:0,	InsertEdit:1},
			{Header:"성별",			Type:"Text",    Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"sexType", 		KeyField:0, Edit:0},
			{Header:"나이",			Type:"Text",   	Hidden:0, Width:60, 	Align:"Center", ColMerge:0,  SaveName:"age", 			KeyField:0, Edit:0},
			{Header:"주민번호",		Type:"Text",   	Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"vResNo", 		KeyField:1, Format:"######-#", Edit:0},
			{Header:"지원금액",		Type:"Int",   	Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"payMon", 		KeyField:0, UpdateEdit:1,	InsertEdit:1},
			{Header:"병원명",		Type:"Text",   	Hidden:0, Width:150, 	Align:"Left", 	ColMerge:0,  SaveName:"hospNm", 	   KeyField:0, UpdateEdit:1,	InsertEdit:1},
			{Header:"검진일자",		Type:"Date",   	Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"chkYmd", 		KeyField:0, Format:"Ymd", UpdateEdit:1,	InsertEdit:1},
			{Header:"청구금액",		Type:"AutoSum", Hidden:0, Width:100, 	Align:"Center", ColMerge:0,  SaveName:"updMon", 		KeyField:0, UpdateEdit:1,	InsertEdit:1},
			{Header:"비고",			Type:"Text",   	Hidden:0, Width:200, 	Align:"Left", 	ColMerge:0,  SaveName:"note", 			KeyField:0, UpdateEdit:1,	InsertEdit:1},
			
			{Header:"Hidden", Hidden:1, SaveName:"year" },
			{Header:"Hidden", Hidden:1, SaveName:"resNo" },
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

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
				sheet1.DoSearch( "${ctx}/HealthMgr.do?cmd=getHealthMgrList", $("#sheet1Form").serialize() );
				break;
			case "Save":
				if( !checkList() ) return;
				if(!dupChk(sheet1,"sabun|gubun", true, true, true)){break;}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/HealthMgr.do?cmd=saveHealthMgr", $("#sheet1Form").serialize());
				break;
			case "SaveExcel":
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/HealthMgr.do?cmd=saveHealthMgrExcel", $("#sheet1Form").serialize(), -1,0);
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				sheet1_OnPopupClick(row, sheet1.SaveNameCol("famNm"));
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "seq", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
			case "DownTemplate":
				// 양식다운로드
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"famNm|vResNo|hospNm|chkYmd|updMon|note"});

				break;
			case "LoadExcel":
				if( !checkList() ) return;
				var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
				sheet1.LoadExcel(params);
				break;
			case "Prc":
				
				if( !checkList() ) return;

		        if (!confirm("건강검진 대상자를 생성 하시겠습니까?\n(기준년도 대상자 전체 삭제 후 새로 생성 됩니다.)")) return;
				
				progressBar(true) ;
				
				setTimeout(
					function(){
				    	
						var data = ajaxCall("${ctx}/HealthMgr.do?cmd=prcHealthMgr", $("#sheet1Form").serialize(),false);
				    	if(data.Result.Code == null) {
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
			if (sheet1.ColSaveName(Col) == "famNm") {  //대상자 선택
				if( !checkList() ) return;
				if (!isPopup()) {  return; }

				gPRow = Row;

				var args	= new Array();
				args["year"]	= $("#searchYear").val();

				let modalLayer = new window.top.document.LayerModal({
					id: 'healthMgrLayer',
					url: '/HealthMgr.do?cmd=viewHealthMgrLayer',
					parameters: args,
					width: 900,
					height: 520,
					title: '건강검진 대상자 선택',
					trigger: [
						{
							name: 'healthMgrLayerTrigger',
							callback: function(rv) {
								sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"]);
								sheet1.SetCellValue(gPRow, "name", 		rv["name"]);
								sheet1.SetCellValue(gPRow, "orgNm", 	rv["orgNm"]);
								sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
								sheet1.SetCellValue(gPRow, "jikweeNm", 	rv["jikweeNm"]);
								sheet1.SetCellValue(gPRow, "age", 		rv["age"]);
								sheet1.SetCellValue(gPRow, "gubun", 	rv["gubun"]);
								sheet1.SetCellValue(gPRow, "famNm", 	rv["famNm"]);
								sheet1.SetCellValue(gPRow, "sexType", 	rv["sexType"]);
								sheet1.SetCellValue(gPRow, "resNo", 	rv["resNo"]);
								sheet1.SetCellValue(gPRow, "vResNo", 	rv["vResNo"]);
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
	
	// 엑셀업로드 후 저장 처리
	function sheet1_OnLoadExcel(result) {
		try {
			if(result) {
				doAction1("SaveExcel");
			} else {
				alert("엑셀파일 로드 중 오류가 발생하였습니다.");
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
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
					<input type="text" id="searchYear" name="searchYear" class="date2 required w70 center line" value="${curSysYear}" maxlength="4"/>
				</td>
				<th>병원명</th>
				<td>
					<input type="text" id="searchHospNm" name="searchHospNm" class="text" style="ime-mode:active;" />
				</td>
				<th>사번/성명</th>
				<td>
					<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
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
			<li class="txt">건강검진대상자관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
				<a href="javascript:doAction1('DownTemplate')" 	class="btn outline_gray authR">양식다운로드</a>
<%--				<a href="javascript:doAction1('LoadExcel');" 	class="btn outline_gray authR">업로드</a>--%>
				<a href="javascript:doAction1('Copy')" 			class="btn outline_gray authA">복사</a>
				<a href="javascript:doAction1('Insert')" 		class="btn outline_gray authA">입력</a>
				<a href="javascript:doAction1('Save');" 		class="btn soft authA">저장</a>
				<a href="javascript:doAction1('Prc')" 			class="btn filled authA">대상자생성</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
