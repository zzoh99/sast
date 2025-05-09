<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>성과(보상)항목관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

		{Header:"항목코드",	Type:"Text",	Hidden:0, Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eleCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
		{Header:"항목명",	Type:"Text",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eleNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"SEQ",		Type:"Int",		Hidden:0, Width:60,	Align:"Center",	ColMerge:0,	SaveName:"seq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
		{Header:"비고",		Type:"Text",	Hidden:0, Width:140,Align:"Left",	ColMerge:0,	SaveName:"bigo",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 }
	]; IBS_InitSheet(sheet1,initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	//평가명
	var comboList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchAppTypeCd=C,","queryId=getAppraisalCdList",false).codeList, "");
	$("#searchAppraisalCd").html(comboList1[2]);
	
	$("#searchAppraisalCd").bind("change", function(event) {
		doAction1("Search");
	});
	
	$(window).smartresize(sheetResize);
	sheetInit();
	
	doAction1("Search");
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/MboUploadMgr.do?cmd=getMboUploadMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			if (sheet1.RowCount() - sheet1.RowCount("D") > 20) {
				alert("항목은 20개까지 등록 가능합니다.");
				return;
			}
			
			// 중복체크
			if(!dupChk(sheet1, "eleCd", false, true)) {break;}
			IBS_SaveName(document.sheet1Form,sheet1);  
			sheet1.DoSave("${ctx}/MboUploadMgr.do?cmd=saveMboUploadMgr", $("#sheet1Form").serialize());
			break;
			
		case "Insert":
			var Row = sheet1.DataInsert(0);
			break;

		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 2);
			break;
		case "DeleteAll":
			if (confirm("항목을 전체삭제 하시겠습니까?")){
				var data = ajaxCall("${ctx}/MboUploadMgr.do?cmd=deleteMboUploadMgrAll", $("#sheet1Form").serialize(), false);
				if (data != null) {
					alert(data.Result["Message"]);
					
					if (data.Result["Code"] > 0) {
						doAction1("Search");
					}
				}	
			}
			break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } doAction1('Search');} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

//셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		// Insert KEY
		if (Shift == 1 && KeyCode == 45) {
			doAction1("Insert");
		}
		//Delete KEY
		if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
			sheet1.SetCellValue(Row, "sStatus", "D");
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select id="searchAppraisalCd" name="searchAppraisalCd"></select>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" class="button authR">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="explain outer">
		<div class="title">도움말</div>
		<div class="txt">
			<ul>
				<li>※ 성과항목은 평가당 최대 20개까지 등록 가능합니다.</li>
			</ul>
		</div>
	</div>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">성과(보상)항목관리</li>
							<li class="btn">
								<a href="javascript:doAction1('DeleteAll')"			class="basic authR">전체삭제</a>
								<a href="javascript:doAction1('Insert')"			class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')"				class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')"				class="basic authA">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>