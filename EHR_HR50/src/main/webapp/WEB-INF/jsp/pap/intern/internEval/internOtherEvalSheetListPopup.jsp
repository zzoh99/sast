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
	
	$(function() {
		param = '${Param}';
		convertParam = convertMap(param);
		
		$("#sabun").val(convertParam.sabun)
		$("#appSabun").val(convertParam.appSabun)
		$("#appStepCd").val(convertParam.appStepCd);
		$("#appraisalCd").val(convertParam.appraisalCd);
		$("#appSeqDetail").val(convertParam.appSeqDetail);
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:1, Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:0, Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:1, Width:40,				Align:"Center",	ColMerge:0,	SaveName:"chk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"평가\n영역|평가\n영역",Type:"Text	",		Hidden:0,		Width:30,	Align:"Center",	ColMerge:1,	SaveName:"appTypeNm",		KeyField:0,		UpdateEdit:0,	InsertEdit:0,	Wrap:1},
			{Header:"평가항목|평가항목",	Type:"Combo",		Hidden:0,		Width:60,	Align:"Center",	ColMerge:1,	SaveName:"appTypeDetailCd",	KeyField:0,		UpdateEdit:0,	InsertEdit:0},
			{Header:"평가항목|평가항목",	Type:"Text	",		Hidden:0,		Width:500,	Align:"Left",	ColMerge:0,	SaveName:"appClassNm",		KeyField:0,		UpdateEdit:0,	InsertEdit:0,	Wrap:1},
			{Header:"수습관찰표|1회차평가",	Type:"AutoAvg",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appScrAvg1",		KeyField:0,		CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			{Header:"수습관찰표|2회차평가",	Type:"AutoAvg",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appScrAvg2",		KeyField:0,		CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			{Header:"수습관찰표|평균",		Type:"AutoAvg",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appScrAvg3",		KeyField:0,		CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			{Header:"점수|최종평가",		Type:"AutoAvg",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appScr",			KeyField:1,		CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			{Header:"점수|최종평균",		Type:"AutoAvg",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"appScrAvgAll",	KeyField:0,		CalcLogic:"",	Format:"NullFloat",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:5 },
			
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appTypeCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appStepCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appSeqDetail",KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appClassCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appSabun",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"sabun",	KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
			{Header:"",					Type:"Text",		Hidden:1,		Width:10,	Align:"Left",	ColMerge:1,	SaveName:"appMemo",		KeyField:0,				UpdateEdit:0,	InsertEdit:0 },
		]; 
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		sheet1.FocusAfterProcess = false;
		//sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		//sheet1.FitColWidth();

		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20022"), "");
		sheet1.SetColProperty("appTypeDetailCd", {ComboText: "|"+comboList1[0], ComboCode: "|"+comboList1[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
		//var param = '${Param}';
		doSearchUser(function() {
			doAction1("Search");
		});
	});
	
	function doSearchUser(pbFunc) {		
		try {
			var html = "";
			$("#detailList").html("");
			var data = ajaxCall("${ctx}/InternEval.do?cmd=getInternOtherEvalSheetUserMap", $("#empForm").serialize(), false);
			//console.log('data', data);
			
			/* 데이터 세팅 */
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				Object.entries(data.DATA).forEach(function(item) {
					$("#u"+item[0]).html(item[1]);
				})
			}
			if (typeof pbFunc == "function") pbFunc();
		} catch (ex) {
			alert("doSearchUser Event Error : " + ex);
		}
	}		
	
	function doSearchSch(pbFunc) {		
		try {
			var html = "";
			$("#detailList").html("");
			var data = ajaxCall("${ctx}/InternEval.do?cmd=getInternOtherEvalSheetSchMap", $("#empForm").serialize(), false);
			//console.log('data', data);
			
			/* 데이터 세팅 */
			if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				for (i=sheet1.GetDataFirstRow(); i<=sheet1.GetDataLastRow();i++) {
					if ((data.DATA.yn == "Y")) {
						sheet1.SetCellEditable(i, "appScr", true);
						$("#btnAgree").show();
						$("#txtComent").hide();
					} else {
						sheet1.SetCellEditable(i, "appScr", false);
						$("#btnAgree").hide();
						$("#txtComent").show();
					}
				}				
			}
			if (typeof pbFunc == "function") pbFunc();
		} catch (ex) {
			alert("doSearchUser Event Error : " + ex);
		}
	}		
	
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				var param = "searchText="+$("#searchText").val();
			    sheet1.DoSearch( "${ctx}/InternEval.do?cmd=getInternOtherEvalSheetListPopupList", $("#empForm").serialize());
	            break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param = {DownCols:downcol, SheetDesign:1, Merge:1};
				sheet1.Down2Excel(param);	
				break;
			case "Agree":
				var btn = "btnAgree";
				if (!confirm($("#"+btn).html() + "을(를) 진행하시겠습니까?")) return false;
				//$("#appCont").val($("#txtAppCont").val());
				IBS_SaveName(document.empForm,sheet1);  
				sheet1.DoSave("${ctx}/InternEval.do?cmd=saveInternOtherEvalSheetListPopup&action="+sAction, $("#empForm").serialize(), 0, 0);
				break;
			case "popupObserve":
				var src = "";
				var height = "";
				var width = "";
				var calFunc;
				var param;
				var title;
				title = "관찰표확인";
				src = "InternEval.do?cmd=viewInternOtherEvalObservePopup"
				width = "80%";
				height= "80%";
				var Row = sheet1.GetSelectRow();
				param = {
						appStepCd: $("#appStepCd").val(),
						sabun: $("#sabun").val(),
						appSabun: $("#appSabun").val(),
						title: title,
						appraisalCd:  $("#appraisalCd").val(),
				};
				
				openModalPopup(src, param, width, height
						, function(){
						}
						, {title:title});		
				
		}
    } 
	
	
	// 조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") {
				alert(Msg);
				return;
			}

			doSearchSch();
			
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	function sheet1_OnChange(Row, Col, Value){
		try {
			var sSaveName = sheet1.ColSaveName(Col);

			if( sSaveName == "appScr"){
				var total = 0;
				var i = 0;
				Value = Number(Value);
				total += Value;
				i++;
				if (sheet1.GetCellValue(Row, "appScrAvg3")) {
					total += Number(sheet1.GetCellValue(Row, "appScrAvg3"));
					i++
				}
				sheet1.SetCellValue(Row, "appScrAvgAll", total / i);
			}

		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	// 클릭 시 
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if (Row < 1) return;
			if (sheet1.ColSaveName(Col)=="detail") {
				var src = "";
				var height = "";
				var width = "";
				var calFunc;
				var param;
				var title
				if (sheet1.GetCellValue(Row, "appStepCd") == '3') { // 주간일지확인
					title = "수습 OJT 주간일지 확인";
					src = "InternEval.do?cmd=viewInternSelfEvalDetailPopup"
					width = "90%";
					height= "90%";
					calFunc = function(){
						makeSelfEval();
					};	
					param = {
							appStatus: sheet1.GetCellValue(Row, "appStepCd"),
							sabun: sheet1.GetCellValue(Row, "sabun"),
							appSabun: sheet1.GetCellValue(Row, "appSabun"),
							title: title,
							appraisalCd: sheet1.GetCellValue(Row, "appraisalCd"),
					};
				} else if (sheet1.GetCellValue(Row, "appStepCd") == '5') { // 수습관찰표
					title = "수습관찰표";
					src = "InternEval.do?cmd=viewInternOtherEvalObservePopup"
					width = "70%";
					height= "80%";
					calFunc = function(){
						makeSelfEval();
					};	
					param = {
							appStatus: sheet1.GetCellValue(Row, "appStepCd"),
							sabun: sheet1.GetCellValue(Row, "sabun"),
							appSabun: sheet1.GetCellValue(Row, "appSabun"),
							title: title,
							appraisalCd: sheet1.GetCellValue(Row, "appraisalCd"),
					};
				}
				
				openModalPopup(src, param, width, height
				, function(){
					doAction1("Search");
				}
				, {title:title});				
			}
	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
	  	}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg); 
			} 
			doAction1("Search");
		} 
		catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	function onView(){
		//console.log("searchMenuLayer.jsp onView()");
		
		sheetResize();
		//setTimeout(function(){ sheetResize(); $("#searchText").focus();},100);
	}
	
	function checkOpenMenu(s, m){
		//console.log( "Check Menu Open !!");
		var isOpen = false;
		$("#subMenuCont>li, #subMenuCont>li>dl>dt, #subMenuCont>li>dl>dt>dd", parent.document).each(function() {
			if( $(this).attr("menuId") == m ) {
				isOpen = true;
			}
		});
		if( isOpen ){
			//console.log( "Check Menu Open !! true");
			parent.openSubMenuCd(s, m);
			return true;
		} else{
			//console.log( "Check Menu Open !! false");
			return setTimeout(function(){ checkOpenMenu(s, m) }, 500 ); 
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
		<input type="hidden" id="appCont"	name="appCont	"/>
		
	</form>
	<div id="finInfo" class="outer">
		<div class="sheet_title">
			<ul>
				<li id="" class="txt">인적사항</li>
			</ul>
		</div>
		<table name="tableFinInfo" id="tableFinInfo" border="0" cellpadding="0" cellspacing="0" class="default">
			<colgroup>
				<col width="10%">
				<col width="*">
				<col width="10%">
				<col width="*">
				<col width="10%">
				<col width="*">
			</colgroup>
			<tr>
				<th>소속</th><td id="ujikchakNm" ></td><th>직위</th><td id="ujikweeNm" ></td><th>성명</th><td id="uname" ></td>
			</tr>
			<tr>
				<th>입사일</th><td id="uempYmd" ></td><th>수습기간</th><td id="uinternStEt" colspan="4"></td>
			</tr>
			<tr>
				<th>학력</th><td id="ulastSchNm" colspan="6"></td>
			</tr>
			<tr>
				<th>경력</th><td id="ucmpNm" colspan="6"></td>
			</tr>	
		</table>
	</div>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="" class="txt">평가사항</li>
							<li class="btn">
								<span id="txtComent" style="padding: 5px 5px;color: white;background-color: darkgray;border-radius: 10px; display: none;">수습평가표 작성기간이 아닙니다.</span>
								<a href="javascript:doAction1('popupObserve')" class="basic">수습관찰표</a>
								<a href="javascript:doAction1('Agree')" id="btnAgree" name="btnAgree" class="basic pink">평가완료</a>
							</li>
						</ul>
					</div>
				</div>
				<div class="inner">
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				</div>
			</td>
		</tr>
	</table>	
	<div class="outer">
		<br>
		<div style="border:solid gray 1px; padding: 10px;">
			<ul>
				<li class="txt_sub">
					<b>※ 사용안내</b>	&nbsp;&nbsp;&nbsp;- 평균 3점 이상 : 고용 확정 / 평균 3점 미만 : 고용 취소
			  	</li>	
			</ul>
		</div>
	</div>
</div>
</body>
</html>




