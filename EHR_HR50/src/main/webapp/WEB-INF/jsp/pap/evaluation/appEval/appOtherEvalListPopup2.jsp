<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>타인평가상세팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var param = {};	
	var convertParam = {};
	var vaControlId;
	var vaViewId;
	
	$(function() {
		param = '${Param}';
		convertParam = convertMap(param);
		$("#appSabun").val(convertParam.sabun);
		$("#sabun").val(convertParam.sabun)
		$("#appTypeCd").val(convertParam.appTypeCd);
		$("#appraisalCd").val(convertParam.appraisalCd);
		var title = param.title + "|" + param.title;
		var initdata = {};
		initdata.Cfg = {SizeMode:0,FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:appTypeCd == "05"?0:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"선택",			Type:"DummyCheck",	Hidden:1, Width:40,				Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"성과배분그룹코드",	Type:"Text",		Hidden:1,		Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appGroupCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"성과배분그룹",		Type:"Text",		Hidden:0,		Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appGroupNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"평가자",			Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"temp",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"평가인원",			Type:"Text",		Hidden:1,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"appCnt",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(0);sheet1.SetUnicodeByte(3);
		
		sheet1.FocusAfterProcess = false;
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);
		
		initSheet2();
		initSheet3();
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
		
	});
	
	function initSheet2() {
		sheet2.Reset();
		var data = ajaxCall("${ctx}/AppEval.do?cmd=getAppGradeRateItemList", $("#empForm").serialize(), false).DATA;
		
		var initdata2 = {};
		initdata2.Cfg = {SizeMode:0,FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:appTypeCd == "05"?0:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"선택",			Type:"DummyCheck",	Hidden:1, Width:40,				Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"평가인원|평가인원",	Type:"Int",	  		Hidden:0,  		Width:80,	Align:"Center", ColMerge:1, SaveName:"orgInwon",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"구분|구분",		Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:1,	SaveName:"gubun1",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"구분|구분",		Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"gubun2",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
		];
		
		
		// 컬럼 추가
		var columns = "";
		for(var i = 0; i < data.length; i++) {
			var colHeaderNm = data[i]["appClassCd"];
			var colSaveNm = "appClassCd_";
			// 컬럼 정보 추가
			initdata2.Cols.push({Header:"인원|"+colHeaderNm, Type:"Int", Hidden:0, Width:60, Align:"Center", ColMerge:0, SaveName:colHeaderNm.toLowerCase(),          KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:6 });
			
			if(i > 0) {
				columns += "@";
			}
			columns += colHeaderNm;
		}		
		$("#columns").val(columns);
		IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(true);sheet2.SetVisible(true);sheet2.SetCountPosition(0);
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	

	function initSheet3() {
		sheet3.Reset();
		
		var initdata2 = {};
		initdata2.Cfg = {SizeMode:0,FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:0,ColResize:1,HeaderCheck:1};
		initdata2.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:appTypeCd == "05"?0:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"선택",			Type:"DummyCheck",	Hidden:1, Width:40,				Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },

			{Header:"피평가자|본부",	Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:1,	SaveName:"orgNm1",		KeyField:0,				UpdateEdit:0,	InsertEdit:0, Wrap:1},
			{Header:"피평가자|실",		Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:1,	SaveName:"orgNm2",		KeyField:0,				UpdateEdit:0,	InsertEdit:0, Wrap:1},
			{Header:"피평가자|팀",		Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:1,	SaveName:"orgNm3",		KeyField:0,				UpdateEdit:0,	InsertEdit:0, Wrap:1},
			{Header:"피평가자|사번",	Type:"Text",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|성명",	Type:"Text",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직책명",	Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"피평가자|직위명",	Type:"Text",		Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가상태코드|평가상태코드",Type:"Text",Hidden:1,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appStatusCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"평가상태|평가상태",Type:"Text",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appStatusNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"1차평가|팀장순위",	Type:"Int",	  		Hidden:0,  		Width:80,	Align:"Right", ColMerge:0, SaveName:"appBoosScr",	KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"1차평가|순위",		Type:"Int",	  		Hidden:0,  		Width:80,	Align:"Right", ColMerge:0, SaveName:"app1stRk",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:0},
			{Header:"2차 평가자\n등급|2차 평가자\n등급",Type:"Combo",Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"app2ndClassCd",KeyField:0,		UpdateEdit:0,	InsertEdit:0},
			{Header:"평가|평가",		Type:"Image",		Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",		KeyField:0,				Cursor:"Pointer" },
			{Header:"우수사항|우수사항",Type:"Text",		Hidden:0,		Width:500,	Align:"Left",	ColMerge:0,	SaveName:"app2ndExceMemo",KeyField:1,			UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1,	EditLen:4000},
			{Header:"보완사항|보완사항",Type:"Text",		Hidden:0,		Width:500,	Align:"Left",	ColMerge:0,	SaveName:"app2ndSuppMemo",KeyField:1,			UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1,	EditLen:4000},
			{Header:"appraisalCd",		Type:"Text",		Hidden:1,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"appraisalCd",KeyField:0,				UpdateEdit:0,	InsertEdit:0},
		];
		
		sheet3.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet3.SetEditArrowBehavior(0);
		IBS_InitSheet(sheet3, initdata2);sheet3.SetEditable(true);sheet3.SetVisible(true);sheet3.SetCountPosition(0);sheet3.SetUnicodeByte(3);
		var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCd&searchAppraisalCd=" + $("#appraisalCd").val(), false).codeList, "");
		sheet3.SetColProperty("app2ndClassCd",		   {ComboText:"|"+classCdList[0], ComboCode:"|"+classCdList[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	// 기간조회
	function showSch(pbFunc) {
		try {
			var html = "";
			
			//$("#detailList").html("");
			var data = ajaxCall("${ctx}/AppEval.do?cmd=getOtherEvalDetailPopupSchList2", $("#empForm").serialize(), false);
			//console.log('data', data);
			var item = null;
			
			/* 데이터 세팅 */
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				item = data.DATA[0];
				if (item.status == "on") { // 기간및 활성화여부에 따른 입력 컨트롤 활성화
					$("#btnSave,#btnAgree").show();
					for(var i = sheet3.GetDataFirstRow(); i <= sheet3.GetDataLastRow() ; i++) {
						if (sheet3.GetCellValue(i, "appStatusCd") == "S1") { // [P10018]S1:2차평가
							sheet3.SetCellEditable(i, "app2ndClassCd", 1);
							sheet3.SetCellEditable(i, "app2ndExceMemo", 1);
							sheet3.SetCellEditable(i, "app2ndSuppMemo", 1);
						}
					}
				} else {
					$("#btnSave,#btnAgree").hide();
				}
			}
			
			if (typeof pbFunc == "function") {
				pbFunc();
			}
		} catch (ex) {
			alert("showSch Event Error : " + ex);
		}		
	}
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				sheet1.RemoveAll();
				var param = "searchText="+$("#searchText").val();
			    sheet1.DoSearch( "${ctx}/AppEval.do?cmd=getAppOtherEvalAppGroup", $("#empForm").serialize());
	            break;
		}
    } 
	
	function doAction2(sAction) {
		switch (sAction) {
			case "Search": //조회
				var param = "appCnt="+sheet1.GetCellValue(sheet1.GetSelectRow(), "appCnt");
			    sheet2.DoSearch( "${ctx}/AppEval.do?cmd=getAppOtherEvalAppRateList&"+param, $("#empForm").serialize());
	            break;
		}
    }
	
	function doAction3(sAction) {
		switch (sAction) {
			case "Search": //조회
				var param = "searchText="+$("#searchText").val();
			    sheet3.DoSearch( "${ctx}/AppEval.do?cmd=getAppOtherEvalListPopup2", $("#empForm").serialize());
	            break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet3);
				var param = {DownCols:downcol, SheetDesign:1, Merge:1};
				sheet3.Down2Excel(param);	
				break;
			case "Save":
			case "Agree":
				var btn = sAction == "Save" ? "btnSave" : sAction == "Agree" ? "btnAgree" : "";
				if (sAction == "Agree") {
					var appCnt = sheet1.GetCellValue(sheet1.GetSelectRow(), "appCnt");
					if (appCnt > 4) { // 4명 이하일 시 체크를 다르게 한다.
						if (!isSheet2Check()) {
							alert("평가등급별 배분인원이 일치하지 않습니다.");
							return false;
						}
					} else {
						if (!isSheet2Check2("cnt", appCnt)) { // 1. 등급별 인원체크 2. 평가인원 및 등급부여 인원 체크
							alert("평가등급별 배분인원이 1명을 초과할 수 없습니다.");
							return false;
						} else if (!isSheet2Check2("total", appCnt)) {
							alert("평가등급별 배분인원이 평가인원과 일치하지 않습니다.");
							return false;
						}
					}
					
					for (var i=sheet3.GetDataFirstRow(); i<=sheet3.GetDataLastRow(); i++) {
						var sStatus = sheet3.GetCellValue(i, "sStatus");
						var app2ndExceMemo = sheet3.GetCellValue(i, "app2ndExceMemo");
						var app2ndSuppMemo = sheet3.GetCellValue(i, "app2ndSuppMemo");
						var headeRowCnt = sheet3.HeaderRows() - 1;

						//if (sStatus == "I" || sStatus == "U") {
						if (!app2ndExceMemo) {
							alert((i - headeRowCnt)+"번째 행의 [우수사항]은(는) 필수 입력 항목 입니다.");
							sheet3.SelectCell(i, "app2ndExceMemo");
							return false;
						} else if (!app2ndSuppMemo) {
							alert((i = headeRowCnt)+"번째 행의 [보완사항]은(는) 필수 입력 항목 입니다.");
							sheet3.SelectCell(i, "app2ndSuppMemo");
							return false;
						} 
					}
				} 

				for (var i=sheet3.GetDataFirstRow(); i<=sheet3.GetDataLastRow(); i++) {
					var sStatus = sheet3.GetCellValue(i, "sStatus");
					var app2ndExceMemo = sheet3.GetCellValue(i, "app2ndExceMemo");
					var app2ndSuppMemo = sheet3.GetCellValue(i, "app2ndSuppMemo");
					var headeRowCnt = sheet3.HeaderRows() - 1;

					if (sStatus == "I" || sStatus == "U") {
						if (!app2ndExceMemo) {
							alert((i - headeRowCnt)+"번째 행의 [우수사항]은(는) 필수 입력 항목 입니다.");
							sheet3.SelectCell(i, "app2ndExceMemo");
							return false;
						} else if (!app2ndSuppMemo) {
							alert((i = headeRowCnt)+"번째 행의 [보완사항]은(는) 필수 입력 항목 입니다.");
							sheet3.SelectCell(i, "app2ndSuppMemo");
							return false;
						}
					}
				}					
				if (!confirm($("#"+btn).html() + "를 진행하시겠습니까?")) return false;
				IBS_SaveName(document.empForm,sheet3);
				sheet3.DoSave("${ctx}/AppEval.do?cmd=saveOtherEvalDetailPopup&action="+sAction, $("#empForm").serialize());
				break;
		}
    }
	
	// 조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg); 
				return;
			}
			sheet1.SelectCell(sheet1.RowCount() > 0 ? 1 : 0, "appGroupNm");
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		if (NewRow < sheet1.GetDataFirstRow() || NewRow > sheet1.GetDataLastRow()) return false;
		if( OldRow != NewRow ) {
			$("#appGroupCd").val(sheet1.GetCellValue(NewRow, "appGroupCd"));
			doAction2("Search");	
			doAction3("Search");
		}
	}
	
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg);
			}
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 조회 후 에러 메시지 
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg); 
				return;
			}
			sheetResize();
			doChangeColor();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg); 
				return;
			}
			showSch();
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	function sheet3_OnChange(Row, Col, Value) {
		 try{
			var sSaveName = sheet3.ColSaveName(Col);
			if(sSaveName == "app2ndClassCd"){
				doChangeTotal();
			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}
	
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg);
			}
			//doAction1("Search");
			doAction2("Search");	
			doAction3("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 클릭 시 
	function sheet3_OnClick(Row, Col, Value, a, b, c) {
		try{
			if (Row < sheet3.GetDataFirstRow() || Row > sheet3.GetDataLastRow()) return false;
			if (sheet3.ColSaveName(Col) == "detail") { 
				openPopup({type:"result", sabun:sheet3.GetCellValue(Row, "sabun")});
			} 
			
	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
	  	}
	}
		
	
	function doChangeTotal() {
		var arrColumns = $("#columns").val().split("@");
		var resultObj = {};
		for (var i=0; i<arrColumns.length; i++) {
			var t = arrColumns[i];
			resultObj[t] = 0;
		}
		for (var i=sheet3.GetDataFirstRow(); i<=sheet3.GetDataLastRow(); i++) {
			var classCd = sheet3.GetCellValue(i, "app2ndClassCd");
			if (classCd) {
				resultObj[classCd]++;
			}
		}
		var totalRow = 0; 
		for (var i=sheet2.GetDataFirstRow(); i<=sheet2.GetDataLastRow(); i++) {
			if ("최종" ==sheet2.GetCellValue(i, "gubun1")) {
				totalRow = i;	
			}
		}
		var keys = Object.keys(resultObj);
		for (var i=0; i<keys.length; i++) {
			sheet2.SetCellValue(totalRow, keys[i].toLowerCase(), resultObj[keys[i]]);
		}
		doChangeColor();		
	}
	
	function doChangeColor() {
		var arrColumns = $("#columns").val().split("@");
		var resultObj = {};
		var chkRow = 0;
		var totalRow = 0;
		
		for (var i=0; i<arrColumns.length; i++) {
			var t = arrColumns[i];
			resultObj[t] = 0;
		}
		
		for (var i=sheet2.GetDataFirstRow(); i<=sheet2.GetDataLastRow(); i++) {
			if ("가이드" ==sheet2.GetCellValue(i, "gubun1") && "인원" ==sheet2.GetCellValue(i, "gubun2")) {
				chkRow = i;	
			}
			if ("최종" ==sheet2.GetCellValue(i, "gubun1")) {
				totalRow = i;	
			}
		}
		
		var keys = Object.keys(resultObj);
		for (var i=0; i<keys.length; i++) {
			if (sheet2.GetCellValue(chkRow, keys[i].toLowerCase()) == sheet2.GetCellValue(totalRow, keys[i].toLowerCase())) {
				sheet2.SetCellFontColor(totalRow, keys[i].toLowerCase(), "black");
			} else {
				sheet2.SetCellFontColor(totalRow, keys[i].toLowerCase(), "red");
			}
		}
	}
	
	function isSheet2Check() {
		var arrColumns = $("#columns").val().split("@");
		var resultObj = {};
		var chkRow = 0;
		var totalRow = 0;
		
		for (var i=0; i<arrColumns.length; i++) {
			var t = arrColumns[i];
			resultObj[t] = 0;
		}
		
		for (var i=sheet2.GetDataFirstRow(); i<=sheet2.GetDataLastRow(); i++) {
			if ("가이드" ==sheet2.GetCellValue(i, "gubun1") && "인원" ==sheet2.GetCellValue(i, "gubun2")) {
				chkRow = i;	
			}
			if ("최종" ==sheet2.GetCellValue(i, "gubun1")) {
				totalRow = i;	
			}
		}
		
		if (chkRow != 0) {
			var keys = Object.keys(resultObj);
			for (var i=0; i<keys.length; i++) {
				if (sheet2.GetCellValue(chkRow, keys[i].toLowerCase()) == sheet2.GetCellValue(totalRow, keys[i].toLowerCase())) {
				} else {
					return false;
				}
			}
		}
		return true;
	}
	
	// 4명 이하일때에는 평가등급배분으로 체크를 안하고 한 등급에 2명이상일 경우만 체크한다.
	// psGubun: cnt, total 
	// appCnt:평가인원
	function isSheet2Check2(psGubun, appCnt) {
		var arrColumns = $("#columns").val().split("@");
		var resultObj = {};
		var chkRow = 0;
		var totalRow = 0;
		
		for (var i=0; i<arrColumns.length; i++) {
			var t = arrColumns[i];
			resultObj[t] = 0;
		}
		
		for (var i=sheet2.GetDataFirstRow(); i<=sheet2.GetDataLastRow(); i++) {
			if ("최종" ==sheet2.GetCellValue(i, "gubun1")) {
				totalRow = i;	
			}
		}
		
		if (totalRow != 0) {
			var totalCnt = 0;
			var keys = Object.keys(resultObj);
			for (var i=0; i<keys.length; i++) {
				if (sheet2.GetCellValue(totalRow, keys[i].toLowerCase()) < 2) {
					totalCnt += Number(sheet2.GetCellValue(totalRow, keys[i].toLowerCase()));
				} else {
					if (psGubun == "cnt") {
						return false;
					}
				}
			}
			if (totalCnt != appCnt && psGubun == "total") {
				return false;
			}
		}
		return true;
	}	
	
	function openPopup(poParam) {
		if (poParam.type) {
			var src = "";
			var title = "";
			var width = 0;
			var height = 0;
			var param = convertParam;
			param["type"] = poParam.type;
			if (poParam.type == "guide") {
				width = "60%";
				height = "60%";
				title = "작성가이드";
				src = "AppEval.do?cmd=viewAppGuidePopup";
			} else if (poParam.type == "result") {
				width = "80%";
				height = "80%";
				title = "평가자평가"
				//param["text"] = poParam["text"];
				src = "AppEval.do?cmd=viewAppSelfEvalDetailPopup";
				param.appStatus = convertParam.appTypeCd;
				param.sabun = poParam.sabun;
			}
			var args = {};
			openModalPopup(src, param, width, height
					, function(){}
			, {title:title});
		}
	}
	
	
</script>
<style type="text/css">
	
</style>
</head>
<body>
<div class="wrapper">
	<form id="empForm" name="empForm" style="height: 100%;">
		<input type="hidden" id="searchYmd" name="searchYmd" value="${ curSysYyyyMMdd }" />
		<input type="hidden" id="sabun" name="sabun"/>
		<input type="hidden" id="appSabun" name="appSabun"/>
		<input type="hidden" id="appTypeCd" name="appTypeCd"/>
		<input type="hidden" id="appraisalCd" name="appraisalCd"/>
		<input type="hidden" id="appGroupCd" name="appGroupCd"/>
		<input type="hidden" id="columns" name="columns"/>
		<div style="display: flow; height: 100%;">
			<div style="display: flex; height: 200px;">
				<div style="width: 30%; height: 100%;">
					<div>
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">평가차수</li>
							</ul>
						</div>
					</div>
					<div>
						<script type="text/javascript">createIBSheet("sheet1", "100%", "calc(200px - 36px)","${ssnLocaleCd}"); </script>
					</div>
				</div>
				<div style="width: 70%; height: 100%;">
					<div>
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">평가등급배분</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet2", "100%", "calc(200px - 36px)","${ssnLocaleCd}"); </script>
				</div>
			</div>
			<div style="width: 100%; height: calc(100% - 200px);">
				<div>
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">평가자평가</li>
							<li id="sheet_btn" class="btn" hide>
								<a href="javascript:openPopup({'type':'guide'})" class="basic">작성가이드</a>
								<a style="display:none;" href="javascript:doAction3('Save')" id="btnSave" class="basic pink" hide>임시저장</a>
								<a style="display:none;" href="javascript:doAction3('Agree')" id="btnAgree" class="basic pink" hide>평가완료</a>
								<a href="javascript:doAction3('Down2Excel')" id="btnExcel" class="basic" hide>다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "100%", "calc(100vh - 236px)","${ssnLocaleCd}"); </script>
			</div>			
		</div>
	</form>
</div>
</body>
</html>



