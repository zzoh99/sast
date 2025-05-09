<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head><title>결근대상자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	
	$(function() {
	
		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});
		
		$("#searchFrom, #searchTo, #searchSabunName, #searchOrgNm").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		$("#searchAbsYn").bind("change", function(){
			doAction1("Search");
		});
		
		init_sheet();
		
		doAction1("Search");
	});

	

	function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};//,FrozenCol:1
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
   			{Header:"상태",			Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"사번",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", SaveName:"sabun", 			Edit:0},
			{Header:"성명",			Type:"Text",   	Hidden:0, Width:80,		Align:"Center", SaveName:"name", 			Edit:0},
			{Header:"부서",			Type:"Text",   	Hidden:0, Width:120, 	Align:"Left",   SaveName:"orgNm", 			Edit:0},
			{Header:"직위",			Type:"Text",   	Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"직급",			Type:"Text",   	Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
			{Header:"직책",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", SaveName:"jikchakNm", 		Edit:0},
			{Header:"사원구분",		Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", SaveName:"manageNm", 		Edit:0},
			{Header:"근무일",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", SaveName:"ymd", 			Format:"Ymd", Edit:0},
			{Header:"근무조",			Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", SaveName:"workOrgNm", 		Edit:0},
			{Header:"근무시간",		Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", SaveName:"timeNm", 			Edit:0},
			{Header:"잔여연차",		Type:"Text",   	Hidden:0, Width:80, 	Align:"Center", SaveName:"resCnt",			Edit:0},
			{Header:"근태",			Type:"Text",   	Hidden:1, Width:120, 	Align:"Center", SaveName:"gntNm", 			Edit:0},
			
			{Header:"연차차감",		Type:"CheckBox", Hidden:0, Width:70,	Align:"Center",	SaveName:"gntYn", 	Edit:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"결근처리",		Type:"CheckBox", Hidden:1, Width:70,	Align:"Center",	SaveName:"absYn", 	Edit:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"반영여부",		Type:"Image",	 Hidden:1, Width:60, 	Align:"Center", SaveName:"img",		Edit:0 },
			
			//Hidden
  			{Header:"applSeq",		Type:"Text",   Hidden:1, Width:80 , Align:"Center", ColMerge:0,  SaveName:"applSeq"}
  		];
  		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		sheet1.SetImageList(0,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(1,"/common/images/icon/icon_o.png");
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

		
		$(window).smartresize(sheetResize); sheetInit();
		
	}


	// 필수값/유효성 체크
	function chkInVal() {
		// 시작일자와 종료일자 체크
		if($("#searchFrom").val() == ""){
			alert("근무기간 시작일자를 입력 해주세요.");
			$("#searchFrom").focus();
			return false;
		}
		if($("#searchTo").val() == ""){
			alert("근무기간 종료일자를 입력 해주세요.");
			$("#searchTo").focus();
			return false;
		}

		if ($("#searchFrom").val() != "" && $("#searchTo").val() != "") {
			if (!checkFromToDate($("#searchFrom"),$("#searchTo"),"근무기간","근무기간","YYYYMMDD")) {
				return false;
			}
		}

		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}

			var sXml = sheet1.GetSearchData("${ctx}/DailyAbsMgr.do?cmd=getDailyAbsMgrList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"gntYnEdit", "gntYn#Edit");
			sheet1.LoadSearchData(sXml );
			
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/DailyAbsMgr.do?cmd=saveDailyAbsMgr",$("#sheet1Form").serialize());
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
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				if( sheet1.GetCellValue(i, "gntYn") === "Y" ){
					sheet1.SetCellEditable( i, "gntYn", 0 ); // 연차 차감 항목이 체크되어있으면 수정 불가능 하도록 함
				}
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
	// 값 변경시 발생
	function sheet1_OnChange(Row, Col, Value) {
		try { 
			// 공휴일여부
			if ( sheet1.ColSaveName(Col) == "gntYn" && Value == "Y"){
				sheet1.SetCellValue(Row, "absYn", "N");
			}
			if ( sheet1.ColSaveName(Col) == "absYn" && Value == "Y"){
				sheet1.SetCellValue(Row, "gntYn", "N");
			}
			
		} catch (ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>근무기간</th>
			<td>
				<input type="text" id="searchFrom" name="searchFrom" class="date2 required" value="${curSysYyyyMMddHyphen}">&nbsp;~&nbsp;
				<input type="text" id="searchTo" name="searchTo" class="date2 required" value="${curSysYyyyMMddHyphen}">
			</td>
			<th class="hide">결근처리여부</th>
			<td class="hide">
				<select id="searchAbsYn" name="searchAbsYn">
					<option value="">전체</option>
					<option value="Y">Y</option>
					<option value="N">N</option>
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
				<li id="txt" class="txt">결근대상자관리</li> 
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
