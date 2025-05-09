<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>메뉴검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@page import="java.util.*"%>
<%
	request.setCharacterEncoding("utf-8");
%>
<script type="text/javascript">
	var param = {};	
	var convertParam = {};
	var SAVE_INDEX = -1; //sheet1 save
	
	$(function() {
		param = '${Param}';
		convertParam = convertMap(param);
		$("#sabun").val(convertParam.sabun)
		$("#appSabun").val(convertParam.appSabun)
		$("#appStepCd").val(convertParam.appStatus ? convertParam.appStatus : convertParam.appStepCd);
		$("#appraisalCd").val(convertParam.appraisalCd);
		$("#txt").html(unescape(convertParam.title));
		var title = unescape(convertParam.title)+"|"+unescape(convertParam.title);
	
		var isHidden = $("#appStepCd").val() == 7;
		var initdata = {};
		initdata.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:0, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:1, Width:40,				Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"평가회차|평가회차",			Type:"Text",		Hidden:0,		Width:160,	Align:"Left",	ColMerge:0,	SaveName:"examDt",		KeyField:0,		UpdateEdit:0,	InsertEdit:0},
			{Header:"작성기간|작성기간",			Type:"Text",		Hidden:isHidden,Width:140,	Align:"Left",	ColMerge:0,	SaveName:"appDt",		KeyField:0,		UpdateEdit:0,	InsertEdit:0},
			{Header:"평가방향|평가방향",			Type:"Text",		Hidden:!isHidden,Width:140,	Align:"Left",	ColMerge:0,	SaveName:"appPlanNm",	KeyField:0,		UpdateEdit:0,	InsertEdit:0},
			{Header:"평가\n상태|평가\n상태",		Type:"Combo",		Hidden:0,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appStatCd",	KeyField:0,		UpdateEdit:0,	InsertEdit:0},
			
			
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appStepCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appSeqDetail",KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appSabun",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appBetweenYn",KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appCont",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,	EditLen:4000},
		]; 
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);sheet1.SetUnicodeByte(3);
		
		//sheet1.FocusAfterProcess = false;
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
		var initdata2 = {};
		initdata2.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:1, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:1, Width:40,				Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			<!--{Header:"평가\n영역|평가\n영역",				Type:"Combo",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:1,	SaveName:"appTypeCd",		KeyField:0,		UpdateEdit:0,	InsertEdit:0},-->
			{Header:"평가\n영역|평가\n영역",				Type:"Text	",		Hidden:0,		Width:30,	Align:"Center",	ColMerge:1,	SaveName:"appTypeNm",		KeyField:0,		UpdateEdit:0,	InsertEdit:0,	Wrap:1},
			{Header:"평가항목|평가항목",					Type:"Combo",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:1,	SaveName:"appTypeDetailCd",	KeyField:0,		UpdateEdit:0,	InsertEdit:0},
			{Header:"평가항목|평가항목",					Type:"Text	",		Hidden:0,		Width:400,	Align:"Left",	ColMerge:0,	SaveName:"appClassNm",		KeyField:0,		UpdateEdit:0,	InsertEdit:0,	Wrap:1},
			{Header:"매우\n부족함\n(1)|매우\n부족함\n(1)",	Type:"CheckBox",	Hidden:40,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appScr1",			KeyField:0,		UpdateEdit:0,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N"},
			{Header:"부족함\n(2)|부족함\n(2)",				Type:"CheckBox",	Hidden:0,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appScr2",			KeyField:0,		UpdateEdit:0,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N"},
			{Header:"보통\n(3)|보통\n(3)",					Type:"CheckBox",	Hidden:0,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appScr3",			KeyField:0,		UpdateEdit:0,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N"},
			{Header:"잘함\n(4)|잘함\n(4)",					Type:"CheckBox",	Hidden:0,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appScr4",			KeyField:0,		UpdateEdit:0,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N"},
			{Header:"뛰어남\n(5)|뛰어남\n(5)",				Type:"CheckBox",	Hidden:0,		Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appScr5",			KeyField:0,		UpdateEdit:0,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N"},
			
			//{Header:"차수|차수",			Type:"Int",	  		Hidden:0,  		Width:50,	Align:"center", ColMerge:0, SaveName:"appSeq",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5 },
			//{Header:"순번|순번",			Type:"Int",	  		Hidden:0,  		Width:50,	Align:"center", ColMerge:0, SaveName:"appSeq",		KeyField:0,   			CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:5 },
			//{Header:"점수|점수",			Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"app1stScr",	KeyField:0,				CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			//{Header:"순위|순위",			Type:"Float",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"app1stRk",	KeyField:0,				CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appStepCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appSeqDetail",KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appSabun",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:50,	Align:"Left",	ColMerge:0,	SaveName:"appScr",		KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appMemo",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:0,	SaveName:"appClassCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
		]; 
		IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(true);sheet2.SetVisible(true);sheet2.SetCountPosition(0);sheet2.SetUnicodeByte(3);
		
		//sheet2.FocusAfterProcess = false;
		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함		
		//sheet1.FitColWidth();

		var appStatCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20021"), "");	//P20021:평가진행상태
		sheet1.SetColProperty("appStatCd",		{ComboText:appStatCdList[0], ComboCode:appStatCdList[1]} );
		
		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20020"), "");
		sheet2.SetColProperty("appTypeCd", {ComboText: "|"+comboList1[0], ComboCode: "|"+comboList1[1]} );
		var comboList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20022"), "");
		sheet2.SetColProperty("appTypeDetailCd", {ComboText: "|"+comboList2[0], ComboCode: "|"+comboList2[1]} );		
		
		
		$(window).smartresize(sheetResize); sheetInit();
		//var param = '${Param}';
		doAction1("Search");
	});
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				var param = "searchText="+$("#searchText").val();
			    sheet1.DoSearch( "${ctx}/InternEval.do?cmd=getInternOtherEvalObservePopupList", $("#empForm").serialize());
	            break;
		}
    }
	
	// 조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") {
				alert(Msg);
				return;
			}
			var isAppStep7 = $("#appStepCd").val() == 7;
			var selectRow = null;
			for (i=sheet1.GetDataFirstRow(); i<=sheet1.GetDataLastRow();i++) {
				var appStepCd = sheet1.GetCellValue(i, "appStepCd");
				var examAppStatYn = sheet1.GetCellValue(i, "examAppStatYn");
				var appStatCd = sheet1.GetCellValue(i, "appStatCd");
				var appBetweenYn = sheet1.GetCellValue(i, "appBetweenYn"); 
				for (var j=0; j<sheet1.ColCount; j++) {
					if (appBetweenYn == "Y"  && appStatCd != "30") {
						sheet1.SetCellFontColor(i, j, "blue");
						//sheet1.SetSelectRow(i);
						selectRow = isAppStep7 ? 0 : i;
					} else {
						sheet1.SetCellFontColor(i, j, "black");
					}
				}
				if (appBetweenYn == "Y") {
					selectRow = isAppStep7 ? 0 : i;
				}
			}

			if (SAVE_INDEX > 0) {
				sheet1.SetSelectRow(SAVE_INDEX);
			} else {
				sheet1.SetSelectRow(selectRow);
			}
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	// 클릭 시 
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if (Row < sheet1.GetDataFirstRow() || Row > sheet1.GetDataLastRow()) return false;
			
	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
	  	}
	}
	
	function onView(){
		sheetResize();
	}
	

	//<!--셀에 마우스 클릭했을때 발생하는 이벤트-->
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			var Row = NewRow;
			if (Row < sheet1.GetDataFirstRow() || Row > sheet1.GetDataLastRow()) return false;
			if ( OldRow == NewRow ) return;
			$("#txtAppCont").val(sheet1.GetCellValue(Row, "appCont"));
			$("#appSeqDetail").val(sheet1.GetCellValue(Row, "appSeqDetail"));
			doAction2("Search");
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	
	/*Sheet Action*/
	function doAction2(sAction) {
		switch (sAction) {
			case "Search": //조회
				var param = "searchText="+$("#searchText").val();
			    sheet2.DoSearch( "${ctx}/InternEval.do?cmd=getInternOtherEvalObservePopupList2", $("#empForm").serialize());
	            break;
			case "Save":
			case "Agree":
				var btn = sAction == "Save" ? "btnSave" : sAction == "Agree" ? "btnAgree" : "";
				if (!confirm($("#"+btn).html() + "을(를) 진행하시겠습니까?")) return false;
				$("#appCont").val($("#txtAppCont").val());
				IBS_SaveName(document.empForm,sheet2);  
				sheet2.DoSave("${ctx}/InternEval.do?cmd=saveInternOtherEvalObservePopup&action="+sAction, $("#empForm").serialize(), 0, 0);
				SAVE_INDEX = sheet1.GetSelectRow();
				break;	            
		}
    } 
	
	// 조회 후 에러 메시지 
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") {
				alert(Msg);
			}
			var isOnOff = false;
			for (var i=sheet2.GetDataFirstRow(); i<=sheet2.GetDataLastRow();i++) {
				var row = sheet1.GetSelectRow();
				var appStatCd = sheet1.GetCellValue(row, "appStatCd");
				var appBetweenYn = sheet1.GetCellValue(row, "appBetweenYn"); 
				var isChk = appBetweenYn == "Y" && appStatCd != "30";
				sheet2.SetCellEditable(i, "appScr1", isChk);
				sheet2.SetCellEditable(i, "appScr2", isChk);
				sheet2.SetCellEditable(i, "appScr3", isChk);
				sheet2.SetCellEditable(i, "appScr4", isChk);
				sheet2.SetCellEditable(i, "appScr5", isChk);
				
				if (appBetweenYn == "Y" && appStatCd != "30") {
					isOnOff = true;
				} 
			}
			if ($("#appStepCd").val() == 7) {
				$("#btnSave, #btnAgree").hide();
				$("#txtComent").hide();
				$("#txtAppCont").attr("readonly", true);
				$("#txtAppCont").addClass("transparent");
			} else if (isOnOff) {
				$("#btnSave, #btnAgree").show();
				$("#txtComent").hide();
				$("#txtAppCont").attr("readonly", false);
				$("#txtAppCont").removeClass("transparent");
			} else {
				$("#btnSave, #btnAgree").hide();
				$("#txtComent").show();
				$("#txtAppCont").attr("readonly", true);
				$("#txtAppCont").addClass("transparent");
			}
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	// 클릭 시 
	function sheet2_OnClick(Row, Col, Value) {
		try{
			if (Row < sheet2.GetDataFirstRow() || Row > sheet2.GetDataLastRow()) return false;
			var colName = sheet2.ColSaveName(Col);
				if (colName.startsWith("appScr") == 1) {
					if (sheet2.GetCellEditable(Row, colName))
					unChecked(Row, colName);
					sheet2.SetCellValue(Row, "appScr", Value == "Y" ? colName.substr(-1) : 0);
				}
	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
	  	}
	}
	
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	function unChecked(Row, colName) {
		var arrColName = ["appScr1", "appScr2", "appScr3", "appScr4", "appScr5"];
		
		for (var i=0; i < arrColName.length; i++) {
			if (colName == arrColName[i]) continue;
			sheet2.SetCellValue(Row, arrColName[i], "N", false);
		}
	}
</script>

</head>
<body>
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<input type="hidden" id="sabun" name="sabun"/>
		<input type="hidden" id="appSabun" name="appSabun"/>
		<input type="hidden" id="appStepCd" name="appStepCd"/>
		<input type="hidden" id="appraisalCd" name="appraisalCd"/>
		<input type="hidden" id="appSeqDetail" name="appSeqDetail"/>
		<input type="hidden" id="appCont" name="appCont"/>		
	</form>
	<div style="display: flex;">
		<div style="width:40%">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">수습 관찰표 목록</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>	
		</div>
		<div style="width:20px;">
		</div>	
		<div style="width:calc(60% - 20px); hegiht:100%;">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">수습 관찰표</li>
									<li class="btn">
										<a href="javascript:doAction2('Save')" id="btnSave" class="basic pink" style="display:none;">임시저장</a>
										<a href="javascript:doAction2('Agree')" id="btnAgree" class="basic pink" style="display:none;">확인요청</a>
										<span id="txtComent" style="padding: 5px 5px;color: white;background-color: darkgray;border-radius: 10px; display: none;">관찰표 작성기간이 아닙니다.</span>
									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet2", "100%", "70%","${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			<div style="height:calc(100% - 70%)">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">종합의견</li>
					</ul>
				</div>
				<div style="height:calc(100% - 36px); width:100%; overflow-y: auto;">
					<table name="tableInfo" id="tableInfo" border="0" cellpadding="0" cellspacing="0" class="default" style="width:100%; height:100%;">
							<colgroup>
								<col width="*" />
							</colgroup>	
							<td><textarea id="txtAppCont" name="txtAppCont" class="${textCss} w100p required" ${readonly}  maxlength="1400" style="width:100%; height:90%;"></textarea></td>
					</table>
				</div>
				<!-- <textarea id="txtMemo" name="txtMemo" rows="7" class=" w100p required" ${readonly}  maxlength="4000" ></textarea> -->
			</div>					
		</div>
	</div>
</div>
</body>
</html>



