<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>성과(보상)항목관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var eleColNames = "";
$(function() {
	
	var initdata1 = {};
	initdata1.Cfg = {FrozenCol:8, SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

		{Header:"부서",			Type:"Text",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"이름",			Type:"Popup",	Hidden:0, Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"사번",			Type:"Text",	Hidden:0, Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직위",			Type:"Text",	Hidden:0, Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직책",			Type:"Text",	Hidden:0, Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		
		{Header:"비고",			Type:"Text",	Hidden:0, Width:140,Align:"Left",	ColMerge:0,	SaveName:"bigo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
		{Header:"최종수정자",	Type:"Text",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkid",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"최종수정일",	Type:"Date",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	]; IBS_InitSheet(sheet1,initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	//평가명
	var comboList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchAppTypeCd=C,","queryId=getAppraisalCdList",false).codeList, "");
	$("#searchAppraisalCd").html(comboList1[2]);
	
	$("#searchAppraisalCd").bind("change", function(event) {
		doAction1("Search");
	});
	
	$("#searchSabunName").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
	});
	
	$(window).smartresize(sheetResize);
	sheetInit();
	
	doAction1("Search");
});

function initSheet() {
	sheet1.Reset();
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
		{Header:"No",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

		{Header:"부서",			Type:"Text",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"이름",			Type:"Popup",	Hidden:0, Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"사번",			Type:"Text",	Hidden:0, Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직위",			Type:"Text",	Hidden:0, Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직책",			Type:"Text",	Hidden:0, Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; 
	
	var titleHeader = ajaxCall("${ctx}/MboUpload.do?cmd=getMboUploadElmList", $("#sheet1Form").serialize(), false).List;
	eleColNames = "";
	for (var i = 0 ; i < titleHeader.length ; i++) {
		initdata1.Cols.push({Header:titleHeader[i].eleNm, Type:"Float", Hidden:0, Width:60, Align:"Center", ColMerge:0, SaveName:"ele"+(i+1),	KeyField:1,	Format:"",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:6, MaximumValue:999.99 });
		eleColNames += "|ele" + (i+1);
	}
	
	initdata1.Cols.push({Header:"비고",			Type:"Text",	Hidden:0, Width:140,Align:"Left",	ColMerge:0,	SaveName:"bigo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 });
	initdata1.Cols.push({Header:"최종수정자",	Type:"Text",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkid",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 });
	initdata1.Cols.push({Header:"최종수정일",	Type:"Date",	Hidden:0, Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 });

	IBS_InitSheet(sheet1,initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	$(window).smartresize(sheetResize);
	sheetInit();
}

function doAction1(sAction) {
	switch (sAction) {
	case "Search":
		initSheet();
		sheet1.DoSearch( "${ctx}/MboUpload.do?cmd=getMboUploadList", $("#sheet1Form").serialize() ); break;
	case "Save": 		
		if(!dupChk(sheet1,"sabun", false, true)){break;}
		IBS_SaveName(document.sheet1Form,sheet1);  
		sheet1.DoSave( "${ctx}/MboUpload.do?cmd=saveMboUpload", $("#sheet1Form").serialize()); break;
	case "Insert":		
		var newRow = sheet1.DataInsert(0);
		break;
	case "Copy":		sheet1.DataCopy(); break;
	case "Clear":		sheet1.RemoveAll(); break;
    case "Down2Excel":  	
		var downcol = makeHiddenSkipCol(sheet1);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
		sheet1.Down2Excel(param); break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); flag = true; break;
	case "DownTemplate":
		// 양식다운로드
		sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"orgNm|name|sabun|jikweeNm|jikchakNm" + eleColNames + "|bigo", DownHeader:1});
		break;
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
			if (Msg != "") {
				alert(Msg);
			}
			//sheetResize();
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
			doAction1('Search');
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46
					&& sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	//  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	function sheet1_OnPopupClick(Row, Col) {
		try {
			var colName = sheet1.ColSaveName(Col);
			var rv = null;
			if (colName == "name") {
				if(!isPopup()) {return;}
				var w		= 840;
				var h		= 520;
				var url		= "/Popup.do?cmd=employeePopup";
				var args	= new Array();

				gPRow = Row;
				pGubun = "employeePopup";

				openPopup(url+"&authPg=R", args, w, h);
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
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
							<span>피평가자성명/사번</span>
							<input id="searchSabunName" name="searchSabunName" class="text w100" type="text"/>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" class="button authR">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">개인별 성과상세내역</li>
							<li class="btn">
								<a href="javascript:doAction1('DownTemplate')"	class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')"			class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')"			class="basic authA">저장</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
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