<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113547' mdef='개인신청결재 신청함'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
	    var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:3, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",			Type:"${sDelTy}", 	Hidden:0,  					Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",			Type:"${sSttTy}", 	Hidden:0,  					Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='sdateV8' mdef='대결\n시작일|대결\n시작일'/>",	Type:"Date",    	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"sdate",       		KeyField:1,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100, EndDateCol:"edate" },
			{Header:"<sht:txt mid='edateV5' mdef='대결\n종료일|대결\n종료일'/>",	Type:"Date",     	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"edate",       		KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100, StartDateCol:"sdate" },
			{Header:"<sht:txt mid='deputySabun' mdef='대결자|사번'/>",				Type:"Text",      	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"deputySabun", 		KeyField:1,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='deputyName' mdef='대결자|성명'/>",				Type:"Popup",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"deputyName",      	KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"대결자|호칭",				Type:"Text",      	Hidden:Number("${aliasHdn}"),  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"deputyAlias",     	KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='deputyOrgNm' mdef='대결자|조직'/>",				Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"deputyOrgNm", 		KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='deputyJikgubNm' mdef='대결자|직급'/>",				Type:"Text",      	Hidden:Number("${jgHdn}"),  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"deputyJikgubNm", 	KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"대결자|직위",				Type:"Text",      	Hidden:Number("${jwHdn}"),  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"deputyJikweeNm", 	KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='deputyJikchakNm' mdef='대결자|직책'/>",				Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"deputyJikchakNm",	KeyField:0,	CalcLogic:"",	Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='useYnV2' mdef='사용\n여부|사용\n여부'/>",		Type:"CheckBox",   	Hidden:1,  Width:25,  	Align:"Center",  ColMerge:0,   SaveName:"useYn",			KeyField:0,	CalcLogic:"", 	Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 ,TrueValue:"Y",FalseValue:"N"},
			{Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",					Type:"Text",     	Hidden:0,  Width:100,  	Align:"Center",  ColMerge:0,   SaveName:"memo",				KeyField:0,	CalcLogic:"",	Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetVisible(true);
	    sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");

		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "deputyName",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "deputySabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "deputyName",		rv["name"]);
						sheet1.SetCellValue(gPRow, "deputyOrgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "deputyJikchakNm",	rv["jikchakNm"]);
					}
				}
			]
		});	

	});
	
	function setEmpPage() {
		doAction("Search");
	}

	function chkInVal() {

		for (var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "sdate") != null && sheet1.GetCellValue(i, "edate") != "") {
					var sdate = sheet1.GetCellValue(i, "sdate");
					var edate = sheet1.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='대결 시작일이 종료일보다 큽니다.'/>");
						sheet1.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}

		return true;
}

	function doAction(sAction) {
		switch (sAction) {
		case "Search":  	
			$("#agreeSabun").val($("#searchUserId").val() );
			sheet1.DoSearch( "${ctx}/AppDeputyMgr.do?cmd=getAppDeputyMgrList", $("#sheet1Form").serialize()); 
			break;
		case "Save":
			if(!chkInVal()){break}
			$("#agreeSabun").val($("#searchUserId").val() );
			if(sheet1.FindStatusRow("I") != ""){ 
			    if(!dupChk(sheet1,"sdate", true, true)){break;}
			}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/AppDeputyMgr.do?cmd=saveAppDeputyMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":	 	sheet1.SelectCell(sheet1.DataInsert(0), 6); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
    }	
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); if(sheet1.RowCount()=="0") doAction("Insert"); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnPopupClick(Row, Col){
		try{
			if(!isPopup()) {return;}
			gPRow = Row;
			pGubun = "employeeAllLayer";

			let layerModal = new window.top.document.LayerModal({
				id : 'employeeAllLayer'
				, url : '/Popup.do?cmd=viewEmployeeAllLayer'
				, parameters : {}
				, width : 840
				, height : 520
				, title : '사원조회'
				, trigger :[
					{
						name : 'employeeAllLayerTrigger'
						, callback : function(rv){
							sheet1.SetCellValue(gPRow, "deputySabun",    	rv["sabun"] );
							sheet1.SetCellValue(gPRow, "deputyName",     	rv["name"] );
							sheet1.SetCellValue(gPRow, "deputyAlias",     	rv["alias"] );
							sheet1.SetCellValue(gPRow, "deputyJikchakNm",	rv["jikchakNm"] );
							sheet1.SetCellValue(gPRow, "deputyJikgubNm",	rv["jikgubNm"] );
							sheet1.SetCellValue(gPRow, "deputyJikweeNm",	rv["jikweeNm"] );
							sheet1.SetCellValue(gPRow, "deputyOrgNm",     rv["orgNm"] );
						}
					}
				]
			});
			layerModal.show();
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function getReturnValue(rv) {
	}
</script>
</head>
<body class="bodywrap">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	<div class="wrapper">
		<form id="sheet1Form" name="sheet1Form">
			<input id="agreeSabun" name="agreeSabun" type="hidden"/>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='applBox' mdef='대결자관리'/></li>
								<li class="btn">
<!-- 									<a href="javascript:doAction('Search')" class="button"><tit:txt mid='104081' mdef='조회'/></a> -->
<!-- 									<a href="javascript:doAction('Insert')" class="button"><tit:txt mid='104267' mdef='입력'/></a> -->
									<btn:a href="javascript:doAction('Down2Excel')" mid="110698" mdef="다운로드" css="btn outline-gray"/>
									<btn:a href="javascript:doAction('Save')" mid="110708" mdef="저장" css="btn filled"/>
								</li>
							</ul>
							
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>



