<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>업적점수결과업로드</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var classCdList = null;	// 선택평가의 평가등급 코드 목록(TPAP110)

	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});


//=========================================================================================================================================

		var searchAppraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, "");
		$("#searchAppraisalCd").html(searchAppraisalCd[2]);

//=========================================================================================================================================



		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가ID",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50 },
			{Header:"소속",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"직급",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

/*
			{Header:"소속코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200 },
			{Header:"직급코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"직책코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"직위",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"직무",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"직무코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"직종",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직군코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workType",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
*/

			{Header:"최종등급",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"finalGrade",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"종합평가등급",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"finalTotalClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"업적평가등급",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"finalMboClassCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"역량평가등급",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"finalCompClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			
			{Header:"다면평가등급",		Type:"Combo",		Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"finalMutualClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"다면평가점수",		Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"finalMutualPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },

			{Header:"수정시간",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",			KeyField:0,	Format:"YmdHms",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"수정자",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkid",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"수정자",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkname",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name", rv["name"]);
						sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"orgCd", rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"appOrgCd", rv["orgCd"]);
						sheet1.SetCellValue(gPRow,"appOrgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow,"jikgubCd", rv["jikgubCd"]);
						sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow,"gempYmd", rv["gempYmd"]);
						sheet1.SetCellValue(gPRow,"empYmd", rv["empYmd"]);
						sheet1.SetCellValue(gPRow,"workType", rv["workType"]);
						sheet1.SetCellValue(gPRow,"workTypeNm", rv["workTypeNm"]);
					}
				}
			]
		});
		
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");

		$("#searchOrgNm, #searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
		$("#searchAppraisalCd").bind("change", function(event){
			// 평가등급코드 조회 Start
			var classCdListsParam = "queryId=getAppClassMgrCdListBySeq&searchAppStepCd=5";
				classCdListsParam += "&searchAppraisalCd=" + $(this).val();
				
			classCdList = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",classCdListsParam,false).codeList, "");
			
			sheet1.SetColProperty("finalGrade",			{ComboText : "|"+classCdList["6"][0],	ComboCode: "|"+classCdList["6"][1]} );
			sheet1.SetColProperty("finalTotalClassCd",	{ComboText : "|"+classCdList["6"][0],	ComboCode: "|"+classCdList["6"][1]} );
			sheet1.SetColProperty("finalMboClassCd",	{ComboText : "|"+classCdList["6"][0],	ComboCode: "|"+classCdList["6"][1]} );
			sheet1.SetColProperty("finalCompClassCd",	{ComboText : "|"+classCdList["6"][0],	ComboCode: "|"+classCdList["6"][1]} );
			sheet1.SetColProperty("finalMutualClassCd",	{ComboText : "|"+classCdList["6"][0],	ComboCode: "|"+classCdList["6"][1]} );
			
			doAction1("Search");
		});
		$("#searchAppraisalCd").change();

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!checkList()) return ;
			sheet1.DoSearch( "${ctx}/AppResultGradeMgr.do?cmd=getAppResultGradeMgrList", $("#sendForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"appraisalCd|sabun", true, true)){break;}
			IBS_SaveName(document.sendForm,sheet1);
			sheet1.DoSave( "${ctx}/AppResultGradeMgr.do?cmd=saveAppResultGradeMgr", $("#sendForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			var searchAppraisalCd = $("#searchAppraisalCd").val();
			sheet1.SetCellValue( row, "appraisalCd", searchAppraisalCd);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			//sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|name|finalGrade|finalTotalClassCd|finalMboClassCd|finalCompClassCd|finalMutualClassCd|finalMutualPoint", ExcelFontSize:"9", ExcelRowHeight:"20", FileName:"평가결과조정마감_양식_" + $("#searchAppraisalCd").val() + ".xlsx"});
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|name|finalGrade|finalMboClassCd|finalCompClassCd", ExcelFontSize:"9", ExcelRowHeight:"20", FileName:"평가결과조정마감_양식_" + $("#searchAppraisalCd").val() + ".xlsx"});
			break;
		}
	}

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
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnLoadExcel(result) {

		if(result) {

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				sheet1.SetCellValue(i, "appraisalCd", $("#searchAppraisalCd").val());
			}

		}

	}


	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
		// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "sheetAutocompleteEmp") {

			sheet1.SetCellValue(gPRow,"name", rv["name"]);
			sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);

			sheet1.SetCellValue(gPRow,"orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow,"orgCd", rv["orgCd"]);

			sheet1.SetCellValue(gPRow,"appOrgCd", rv["orgCd"]);
			sheet1.SetCellValue(gPRow,"appOrgNm", rv["orgNm"]);

			sheet1.SetCellValue(gPRow,"jikchakCd", rv["jikchakCd"]);
			sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);

			sheet1.SetCellValue(gPRow,"jikweeCd", rv["jikweeCd"]);
			sheet1.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);

			sheet1.SetCellValue(gPRow,"jikgubCd", rv["jikgubCd"]);
			sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);

			sheet1.SetCellValue(gPRow,"gempYmd", rv["gempYmd"]);
			sheet1.SetCellValue(gPRow,"empYmd", rv["empYmd"]);

			sheet1.SetCellValue(gPRow,"workType", rv["workType"]);
			sheet1.SetCellValue(gPRow,"workTypeNm", rv["workTypeNm"]);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td>
				<span>평가명</span>
				<select id="searchAppraisalCd" name="searchAppraisalCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td>
				<span>소속</span>
				<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<span>사번/성명</span>
				<input id="searchNm" name="searchNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">최종 평가결과 업로드 - 데이터이관용</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
				<a href="javascript:doAction1('DownTemplate')" 	class="btn outline_gray authA">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="btn outline_gray authA">업로드</a>
				<a href="javascript:doAction1('Copy')" 			class="btn outline_gray authA">복사</a>
				<a href="javascript:doAction1('Insert')" 		class="btn outline_gray authA">입력</a>
				<a href="javascript:doAction1('Save')" 			class="btn filled authA">저장</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>
