<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가차수반영비율</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No"	,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제"	,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태"	,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },

			{Header:"범위그룹순번"	    ,Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appTRateSeq",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"평가방법"		,Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appMethodCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"범위그룹명"		,Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appTRateNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"범위구분"		,Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"scopeGubun",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"설정기준"		,Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"scope",		Cursor:"Pointer" },

			{Header:"평가ID"			,Type:"Text",	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"appraisalCd",	KeyField:1,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"비고"			,Type:"Text",	Hidden:0,  Width:180,  Align:"Left",  ColMerge:0,   SaveName:"note",			KeyField:0,   CalcLogic:"",   Format:"",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);sheet1.SetVisible(true);

		var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, ""); // 평가명
		$("#searchAppraisalCd").html(famList[2]); //평가명

		//평가방법
		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10006"));
		sheet1.SetColProperty("appMethodCd", 			{ComboText:comboList1[0], ComboCode:comboList1[1]} );

		//sheet1.SetColProperty("scopeGubun", {ComboText:"|전체|범위적용", ComboCode:"|A|O"} );
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("scope", 1);
		sheet1.SetDataLinkMouse("temp2", 1);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"No"	,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제"	,Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태"	,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },

			{Header:"범위항목값"		,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"scopeValue",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"범위항목명"		,Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"scopeValueNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100}
		]; IBS_InitSheet(sheet2, initdata2); sheet2.SetEditable("${editable}"); sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);


		$("#searchAppraisalCd").val($("#searchAppraisalCd", parent.document).val());
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getAppElementMgrTab1", $("#srchFrm").serialize() ); break;
		case "Search2": 	 	sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getAppElementMgrTab1ScopeCd", $("#srchFrm").serialize() ); break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
				if(!dupChk(sheet1,"appraisalCd|appMethodCd", true, true)){break;}
			}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AppElementMgr.do?cmd=saveAppElementMgrTab1", $("#srchFrm").serialize()); break;
		case "Insert":		var Row = sheet1.DataInsert(0);
							sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
							//sheet1.SelectCell(Row, "app1stYn");
							break;
		case "Copy":
			var row = sheet1.DataCopy();
			//sheet1.SelectCell(Row, "app1stYn");
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	function doAction2(sAction){
		switch (sAction) {
		case "Search2": 	sheet2.DoSearch( "${ctx}/GetDataList.do?cmd=getAppElementMgrTab1ScopeCd", $("#srchFrm").serialize() ); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
			sheet2.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			if ( Code != -1 ) doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}


	function sheet1_OnClick(Row, Col, Value) {
		//try{

			if( sheet1.ColSaveName(Col) == "scope" ) {
				if(!isPopup()) {return;}

				if( sheet1.GetCellValue(Row,"sStatus") == "I" ) {
					alert("입력 상태에서는 범위설정을 하실 수 없습니다.");
					return;
				}
				/*
				if(sheet1.GetCellValue(Row,"scopeGubun") != "O") {
					alert("범위구분에서 [범위적용]으로 선택했을 경우만 조회를 할 수 있습니다.");
					return;
				}
				*/
				var args = new Array();
				args["searchUseGubun"] = "MT";
				args["searchItemValue1"] = sheet1.GetCellValue(Row,"appraisalCd");
				args["searchItemValue2"] = sheet1.GetCellValue(Row,"appMethodCd");
				args["searchItemValue3"] = "0";

				openPopup("${ctx}/View.do?cmd=viewAppGroupMgrRngPop&authPg=${authPg}",args,"740","700");
			}

			if(sheet1.GetCellValue(Row, "sStatus") != "I"){
				$("#appMethodCd").val(sheet1.GetCellValue(Row, "appMethodCd"));
				var seqInfo = ajaxCall("${ctx}/GetDataList.do?cmd=getAppElementMgrTab1TblNm", "queryId=getAppElementMgrTab1TblNm&"+ $("#srchFrm").serialize(), false);
				$("#txt1").html("&nbsp;");
				doAction2("Clear");
				$.each(seqInfo.DATA, function(idx, value){
					var tag = $("<a/>", {
						"class":"gray large",
						text:value.authScopeNm,
						scopeCd:value.scopeCd,
						tableNm:value.tableNm,
						click:function(){
								$("#scopeCd").val($(this).attr("scopeCd"));
								$("#tableNm").val($(this).attr("tableNm"));
								$("#txt1 a").attr("class","gray large");
								$(this).attr("class","green large");
								doAction2("Search2");
							}
					});

					$("#txt1").append(tag);
				});

			}
		//}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
	}
</script>


</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
		<input type="hidden" id="appTRateSeq" name="appTRateSeq" />
		<input type="hidden" id="appMethodCd" name="appMethodCd" />
		<input type="hidden" id="tableNm" name="tableNm" />
		<input type="hidden" id="scopeCd" name="scopeCd" />
	</form>

		<table class="sheet_main">
		<colgroup>
			<col width="68%" />
			<col width="32%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt2">&nbsp;</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "70%", "100%","kr"); </script>
			</td>
			<td class="sheet_right">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt1" class="txt2">&nbsp;</li>
							<li class="btn hide">
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "30%", "100%","kr"); </script>
			</td>
		</tr>
		</table>
</div>
</body>
</html>