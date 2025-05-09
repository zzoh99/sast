<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='sepEleMgr' mdef='퇴직금항목관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 퇴직금항목관리
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",			Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"elementCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementNm",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
		{Header:"<sht:txt mid='elementEngV1' mdef='영문항목명'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementEng",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='reportNmV1' mdef='Report명'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"reportNm",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='deductionType' mdef='항목분류'/>",			Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementType",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='elementLinkTypeV1' mdef='항목Link유형'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"elementLinkType",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='priorityV1' mdef='계산순위'/>",			Type:"Int",			Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"priority",		KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='udfCdV1' mdef='배치작업코드'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"udfCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='udfNmV1' mdef='배치작업'/>",			Type:"Popup",		Hidden:0,					Width:180,			Align:"Left",	ColMerge:0,	SaveName:"udfNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
		{Header:"<sht:txt mid='afUdfCd' mdef='후속배치작업코드'/>",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"afUdfCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='afUdfNm' mdef='후속배치작업'/>",		Type:"Popup",		Hidden:0,					Width:180,			Align:"Left",	ColMerge:0,	SaveName:"afUdfNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
		{Header:"<sht:txt mid='updownTypeV1' mdef='절상/사구분'/>",		Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"updownType",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='updownUnitV2' mdef='절상/사단위'/>",		Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"updownUnit",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='resultYn' mdef='최종결과\n발생여부'/>",	Type:"CheckBox",	Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"resultYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"<sht:txt mid='printYn' mdef='출력여부'/>",			Type:"CheckBox",	Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"reportYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"<sht:txt mid='tmpUseYn' mdef='사용여부'/>",			Type:"CheckBox",	Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"useYn",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"<sht:txt mid='exceptYn' mdef='예외여부'/>",			Type:"CheckBox",	Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"exceptYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"<sht:txt mid='exPayCdYn' mdef='제외\n급여코드'/>",		Type:"Text",		Hidden:1,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"exPayCdYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
		{Header:"<sht:txt mid='exPayCdYn' mdef='제외\n급여코드'/>",		Type:"Image",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"exPayCdYnImg",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
		{Header:"<sht:txt mid='attribute1' mdef='필드1'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attribute1",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='attribute2V1' mdef='필드2'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attribute2",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='attribute3V1' mdef='필드3'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attribute3",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='attribute4V1' mdef='필드4'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attribute4",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='attribute5V1' mdef='필드5'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attribute5",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='attribute6V1' mdef='필드6'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attribute6",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='attribute7V1' mdef='필드7'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attribute7",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='attribute8V2' mdef='필드8'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attribute8",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='attribute9V1' mdef='필드9'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attribute9",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='attribute10V1' mdef='필드10'/>",			Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"attribute10",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='resultTableNm' mdef='결과반영TABLE명'/>",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"resultTableNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
		{Header:"<sht:txt mid='resultColumnNm' mdef='결과반영COLUMN명'/>",	Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"resultColumnNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
		{Header:"<sht:txt mid='sysYnV1' mdef='시스템자료여부'/>",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sysYn",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 }
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	sheet1.SetDataLinkMouse("exPayCdYnImg", 1);
	sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_x.png");
	sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 퇴직항목구분(C00755)
	var elementType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00755"), "");
	sheet1.SetColProperty("elementType", {ComboText:"|"+elementType[0], ComboCode:"|"+elementType[1]});

	// 퇴직금항목링크유형(C00770)
	var elementLinkType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00770"), "");
	sheet1.SetColProperty("elementLinkType", {ComboText:"|"+elementLinkType[0], ComboCode:"|"+elementLinkType[1]});

	// 절상/사구분(C00005)
	var updownType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00005"), "");
	sheet1.SetColProperty("updownType", {ComboText:"|"+updownType[0], ComboCode:"|"+updownType[1]});

	// 절상/사단위(C00006)
	var updownUnit = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "C00006"), "");
	sheet1.SetColProperty("updownUnit", {ComboText:"|"+updownUnit[0], ComboCode:"|"+updownUnit[1]});

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#elementNm").on("keyup", function(e) {
		if (e.keyCode === 13)
			doAction1("Search");
	})

	doAction1("Search");
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/SepEleMgr.do?cmd=getSepEleMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 중복체크
			if(!dupChk(sheet1, "elementCd", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepEleMgr.do?cmd=saveSepEleMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "sysYn", "N");
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "exPayCdYn", "0");
			sheet1.SetCellValue(Row, "exPayCdYnImg", "0");
			sheet1.SelectCell(Row, 2);
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		// Insert KEY
		if (Shift == 1 && KeyCode == 45) {
			doAction("Insert");
		}
		// Delete KEY
		if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
			sheet1.SetCellValue(Row, "sStatus", "D");
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

function sheet1_OnClick(Row, Col, Value) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if(Row > 0) {
			if (colName == "sDelete") {
				// 시스템자료여부 확인
				if (sheet1.GetCellValue(Row, "sysYn") == "Y") {
					alert("<msg:txt mid='alertNotSysDelete' mdef='해당자료는 시스템자료이므로 삭제할 수 없습니다.'/>");
					sheet1.SetCellValue(Row, "sDelete", "");
					sheet1.SetCellValue(Row, "sStatus", "");
				}
			} else if (colName == "exPayCdYnImg") {
				if (sheet1.GetCellValue(Row, "sStatus") == "R" || sheet1.GetCellValue(Row, "sStatus") == "U") {
					sepEleMgrExPayCdPopup(Row);
				}
			}
		}
	}catch(ex) {alert("OnClick Event Error : " + ex);}
}

function sheet1_OnPopupClick(Row, Col) {
	try{
		var colName = sheet1.ColSaveName(Col);
		if(colName == "udfNm"||colName == "afUdfNm") {
			// 배치작업코드검색 팝업
			payUdfMasterSearchPopup(Row, Col, colName);
		}
	}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

// 배치작업코드검색 팝업
function payUdfMasterSearchPopup(Row, Col, colName) {
	let callback = null;
	if(colName === 'udfNm'){
		callback = function(parameters){
			sheet1.SetCellValue(Row, "udfCd",   parameters.udfCd);
			sheet1.SetCellValue(Row, "udfNm",   parameters.description);
		};
	}else{
		callback = function(parameters){
			sheet1.SetCellValue(Row, "afUdfCd",  parameters.udfCd);
			sheet1.SetCellValue(Row, "afUdfNm",  parameters.description);
		}
	}

	let layerModal = new window.top.document.LayerModal({
		id : 'udfMasterLayer'
		, url : '/PayUdfMasterPopup.do?cmd=viewPayUdfMasterLayer&authPg=R'
		, parameters : {}
		, width : 860
		, height : 520
		, title : '<tit:txt mid='payUdfMasterPop' mdef='사용자정의 함수 조회'/>'
		, trigger :[
			{
				name : 'udfMasterTrigger'
				, callback : callback
			}
		]
	});
	layerModal.show();
}

// 제외급여코드 팝업
function sepEleMgrExPayCdPopup(Row) {
	let layerModal = new window.top.document.LayerModal({
		id : 'sepElePayLayer'
		, url : '/SepEleMgr.do?cmd=viewSepEleMgrExPayCdLayer&authPg=${authPg}'
		, parameters : {
			elementCd : sheet1.GetCellValue(Row, "elementCd")
		}
		, width : 500
		, height : 520
		, title : '<tit:txt mid='sepEleMgrExPayCdPopup' mdef='제외급여코드'/>'
		, trigger :[
			{
				name : 'sepElePayTrigger'
				, callback : function(parameters){
					if(parameters && parameters.changeYn === "Y")
						doAction1('Search');
				}
			}
		]
	});
	layerModal.show();
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='eleGroupMgr2' mdef='항목명'/></th>
						<td>
							<input type="text" id="elementNm" name="elementNm" class="text" value="" style="width:120px;ime-mode:active" />
						</td>
						<th><tit:txt mid='111965' mdef='사용여부'/></th>
						<td>
							<select id="useYn" name="useYn">
								<option value=""><tit:txt mid='103895' mdef='전체'/></option>
								<option value="Y"><tit:txt mid='113321' mdef='사용'/></option>
								<option value="N"><tit:txt mid='112598' mdef='사용안함'/></option>
							</select>
						</td>
						<th><tit:txt mid='113865' mdef='발생여부'/></th>
						<td>
							<select id="resultYn" name="resultYn">
								<option value=""><tit:txt mid='103895' mdef='전체'/></option>
								<option value="Y"><tit:txt mid='113321' mdef='사용'/></option>
								<option value="N"><tit:txt mid='112598' mdef='사용안함'/></option>
							</select>
						</td>
						<th><tit:txt mid='113164' mdef='출력여부'/></th>
						<td>
							<select id="reportYn" name="reportYn">
								<option value=""><tit:txt mid='103895' mdef='전체'/></option>
								<option value="Y"><tit:txt mid='113321' mdef='사용'/></option>
								<option value="N"><tit:txt mid='112598' mdef='사용안함'/></option>
							</select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" css="button" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="top">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='114209' mdef='퇴직금항목관리 '/> </li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')"			css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
