<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가ID관리</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
			  		{Header:"No"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
					{Header:"삭제"			,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
					{Header:"상태"			,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
                    {Header:"평가ID"			,Type:"Text",     	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appraisalCd",	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                    {Header:"항목코드"		,Type:"Text",     	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"itemCd",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                    {Header:"항목명"			,Type:"Text",     	Hidden:0,  Width:500,  Align:"Center",	ColMerge:0,   SaveName:"itemNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
                    {Header:"항목값"			,Type:"Image",      Hidden:0,  Width:50,   Align:"Center",	ColMerge:0,   SaveName:"detail",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                    {Header:"순서"			,Type:"Text",      	Hidden:0,  Width:50,   Align:"Center",	ColMerge:0,   SaveName:"sunbun",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
			]; 
			IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);
			
			// 세부내역
			sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
			
			var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchAppTypeCd=E,",false).codeList, "");
		
			$("#searchAppraisalCd").html(famList[2]);

			
			$(window).smartresize(sheetResize); sheetInit();
		    doAction("Search");
	});	

function doAction(sAction){
    //removeErrMsg();
    switch(sAction){
        case "Search":      //조회
            sheet1.DoSearch("${ctx}/AppSelfReportItemMgr.do?cmd=getAppSelfReportItemMgrList", $("#mySheetForm").serialize(), "iPage=1");
            //sheet1.ShowDebugMsg=false;
            break;

        case "Save":        //저장                
                
        		IBS_SaveName(document.mySheetForm,sheet1);
                sheet1.DoSave( "${ctx}/AppSelfReportItemMgr.do?cmd=saveAppSelfReportItemMgr", $("#mySheetForm").serialize()); break;
            break;

        case "Insert":      //입력
            if($("#searchAppraisalCd").val() == ""){
               alert("평가명을 선택 하시기 바랍니다.");
               return;
            }
           
     	    var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
			sheet1.SelectCell(Row, "itemNm"); 
            
			break;
            
        case "Copy":        //행복사
            var Row = sheet1.DataCopy();
            break;

        case "Clear":        //Clear
            sheet1.RemoveAll();
            break;

        case "Down2Excel":  //엑셀내려받기
        	var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param); 
            break;

        case "LoadExcel":   //엑셀업로드
            //excel 자료를 읽어오기 전의 모든 자료는 폼에서 제거한다.
            //sheet1.FileDlgExt = "Excel File(*.xls)|*.xls|모든문서(*.*)|*.*|";
            //sheet1.RemoveAll();
            sheet1.LoadExcel(true,1);
            break;
    }
}

function sheet1_OnClick(Row, Col, Value) {
	try{

		var rv = null;
		var args    = new Array();

		args["appraisalCd"] = sheet1.GetCellValue(Row, "appraisalCd");
		args["itemCd"]   = sheet1.GetCellValue(Row, "itemCd");
		args["itemNm"]   = sheet1.GetCellValue(Row, "itemNm");
		
		if(Row > 0 && sheet1.ColSaveName(Col) == "detail" && sheet1.GetCellValue(Row,"sStatus") != 'I' ){
			var rv = openPopup("/AppSelfReportItemMgr.do?cmd=viewAppSelfReportItemMgrValuePop&authPg=${authPg}", args, "500","520");   
			if(rv!=null){
			}
		}
	}catch(ex){alert("OnClick Event Error : " + ex);}
}

// 대상자생성
function copyItems(){
	var args    = new Array();
    var rv = openPopup("/AppSelfReportItemMgr.do?cmd=viewAppSelfReportItemMgrCopy", args, "600","200"); 
    if(rv != null){
    	$("#searchAppraisalCd").val(rv["appraisalCd"]);
    	 doAction("Search");
    }
}

//저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{ 
		if(Msg != ""){ 
			alert(Msg); 
		} 
		doAction("Search");
	}catch(ex){ 
		alert("OnSaveEnd Event Error " + ex); 
	}
}


</script>


</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd" onChange="javascript:doAction('Search');">
							</select>
						</td>
						<td>
							<a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a>
							<a href="javascript:copyItems()" id="btnSearch" class="button">자기신고서항목복사</a>
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
							<li id="txt" class="txt">자기신고서항목정의</li>
							<li class="btn">
								<a href="javascript:doAction('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction('Down2Excel')" 	class="basic authR">다운로드</a>
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