<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"구분",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"etcGubunCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"호칭",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속코드",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",	    KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속",			Type:"Popup",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"직급",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위",			Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"점수", 			Type:"Int",	        Hidden:0,   Width:80 ,  Align:"Rigth",  ColMerge:0, SaveName:"etcPoint" ,		KeyField:0,   CalcLogic:"", Format:"Integer", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50},
			{Header:"평가ID코드",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

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
		
		var etcGubunCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P90100"), "전체");
		sheet1.SetColProperty("etcGubunCd", 			{ComboText:"|"+etcGubunCd[0], ComboCode:"|"+etcGubunCd[1]} );

		$("#searchEtcGubunCd").html(etcGubunCd[2]);

		//평가코드
		var appraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCd[2]);
		//$("#searchAppraisalCd").change();

		$("#searchAppraisalCd").change(function(){
			doAction1("Search");
		});

		$("#searchAppOrgNm, #searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/AppEtcResultMgr.do?cmd=getAppEtcResultList", $("#srchFrm").serialize() );
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
			break;
		case "Save":
			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				if(sheet1.GetCellValue(i,"sStatus") == "I" && sheet1.GetCellValue(i,"appraisalCd") == ""){
					sheet1.SetCellValue(i, "appraisalCd", $("#searchAppraisalCd").val());
				}
			}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AppEtcResultMgr.do?cmd=saveAppEtcResultMgr", $("#srchFrm").serialize()); break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:0, DownRows:"0", DownCols:"etcGubunCd|sabun|appOrgCd|etcPoint"});
			break;
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
			if(Msg != ""){
				alert(Msg);
			}
			doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col) {
		try{

			var colName = sheet1.ColSaveName(Col);
			if (Row >= sheet1.HeaderRows()) {
				if (colName == "name") {
					// 사원검색 팝입
					employeePopup(colName, Row);
				}else if(colName == "appOrgNm"){

					employeePopup(colName, Row);
				}
			}
		} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
	}

	//사원 팝업
	function employeePopup(pObjName, pRow){
		try{

				if ( pObjName == "name" ) {
					if(!isPopup()) {return;}

					var args = new Array();

					gPRow = pRow;
					pGubun = "employeePopup";

					openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "740","520");
				}else if( pObjName == "appOrgNm" ) {
					if(!isPopup()) {return;}

					var args	= new Array();
					args["searchAppraisalCd"] 	= $("#searchAppraisalCd").val();
					args["searchAppStepCd"] 	= "5";

					gPRow = pRow;
					pGubun = "orgBasicPapCreatePopup";

					openPopup("/Popup.do?cmd=orgBasicPapCreatePopup", args, "680","520");
				}
		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
			sheet1.SetCellValue(gPRow, "appOrgCd", rv["orgCd"]);
			sheet1.SetCellValue(gPRow, "appOrgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
		} else if(pGubun == "orgBasicPapCreatePopup") {
			sheet1.SetCellValue(gPRow,"appOrgNm",(rv["orgNm"]));
			sheet1.SetCellValue(gPRow,"appOrgCd",(rv["orgCd"]));
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd"></select>
						</td>
						<td>
							<span>소속</span>
							<input id="searchAppOrgNm" name="searchAppOrgNm" type="text" class="text" style="ime-mode:active;" />
						</td>
						<td>
							<span>사번/성명</span>
							<input id="searchNm" name="searchNm" type="text" class="text" style="ime-mode:active;" />
						</td>
						<td>
							<span>구분</span>
							<select id="searchEtcGubunCd" name="searchEtcGubunCd" class="box" onchange="javascript:doAction1('Search');"></select>
						</td>

						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">기타평가점수결과반영</li>
							<li class="btn">
								<a href="javascript:doAction1('DownTemplate')" 	class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
								<a href="javascript:doAction1('Insert')" 	    class="basic authA">입력</a>
								<a href="javascript:doAction1('Save')" 		    class="basic authA">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>