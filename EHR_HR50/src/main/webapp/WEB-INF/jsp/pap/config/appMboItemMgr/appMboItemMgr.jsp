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
                    {Header:"평가ID"			,Type:"Text",     	Hidden:1,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appraisalCd",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
                    {Header:"항목구분"		,Type:"Combo",     	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"targetType",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
                    {Header:"조직유형"		,Type:"Combo",     	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appOrgType",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
                    {Header:"항목코드"		,Type:"Text",     	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"seq",				KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
                    {Header:"항목명"			,Type:"Text",     	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"seqNm",				KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
                    {Header:"가중치(%)"		,Type:"Text",     	Hidden:0,  Width:100,  Align:"Center",	ColMerge:0,   SaveName:"appBasisPoint",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
                    {Header:"정의"			,Type:"Text",     	Hidden:0,  Width:500,  Align:"Center",	ColMerge:0,   SaveName:"memo",				KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
                    {Header:"측정지표"		,Type:"Text",		Hidden:0,  Width:50,   Align:"Center",	ColMerge:0,   SaveName:"targetIndexKpi",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
                    {Header:"순서"			,Type:"Text",      	Hidden:0,  Width:50,   Align:"Center",	ColMerge:0,   SaveName:"sunbun",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }
			]; 
			IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);
			
			var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppGroupMgrCodeList",false).codeList, "");
		
			var comboList1	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10009")); // 항목구분
			var comboList2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20010")); // 조직유형
			sheet1.SetColProperty("targetType", 			{ComboText:comboList1[0], ComboCode:comboList1[1]} );
			sheet1.SetColProperty("appOrgType", 			{ComboText:comboList2[0], ComboCode:comboList2[1]} );
			
			$("#searchAppraisalCd").html(famList[2]);
			    
			$("#appraisalNm,#appraisalYy").bind("keyup",function(event){
				if( event.keyCode == 13){
					doAction("Search"); $(this).focus();
				}
			});
			$(window).smartresize(sheetResize); sheetInit();
		    doAction("Search");
	});	
</script>

<script type="text/javascript">
/**
 *조회조건 에터키 입력시 조회
 */
function check_Enter(){
    if (event.keyCode==13) doAction("Search");
}

/**
 * Sheet 각종 처리
 */
function doAction(sAction){
    //removeErrMsg();
    switch(sAction){
        case "Search":      //조회
        	//changeCombo();
        	sheet1.DoSearch("${ctx}/AppMboItemMgr.do?cmd=getAppMboItemMgrList", $("#mySheetForm").serialize(), "iPage=1");
            //sheet1.ShowDebugMsg=false;
            break;

        case "Save":        //저장

        	var cntA = 0;
        	var cntB = 0;
        	for(var i = sheet1.HeaderRows ; i < sheet1.RowCount + sheet1.HeaderRows; i++) {
            	if(sheet1.GetCellValue(i, "targetType") == "A") {
            		cntA++;
            	}
            	if(sheet1.GetCellValue(i, "targetType") == "B") {
            		cntB++;
            	}
        	}
        	if(cntA > 1) {
            	alert("통상은 1개이상 입력 불가합니다.");
            	return;
        	}
        	if(cntB > 1) {
            	alert("신규는 1개이상 입력 불가합니다.");
            	return;
        	}        	
            //sheet1.DoSave("AppItem_save.jsp", FormQueryString(document.form), "iPage=1");
            break;

        case "Insert":      //입력
            if(document.all.searchAppraisalCd.value == ""){
               alert("평가명을 선택 하시기 바랍니다.");
               return;
            }
            var Row = sheet1.DataInsert(0);
            break;
            
        case "Copy":        //행복사
            var Row = sheet1.DataCopy();
            break;

        case "Clear":        //Clear
            sheet1.RemoveAll();
            break;

        case "Down2Excel":  //엑셀내려받기
            sheet1.SpeedDown2Excel(true);
            break;

        case "LoadExcel":   //엑셀업로드
            //excel 자료를 읽어오기 전의 모든 자료는 폼에서 제거한다.
            //sheet1.FileDlgExt = "Excel File(*.xls)|*.xls|모든문서(*.*)|*.*|";
            //sheet1.RemoveAll();
            sheet1.LoadExcel(true,1);
            break;
    }
}
</script>

<!-- 조회 후 에러 메시지 -->
<script language="JavaScript" for="sheet1" event="OnSearchEnd(ErrMsg)">
    if (ErrMsg != ""){
        location.href = "/JSP/ErrorPage.jsp?errorMsg="+ErrMsg;
    }
    setSheetSize(this); 
</script>

<Script language="javascript" for="sheet1" event="OnResize(lWidth, lHeight)">
    setSheetSize(this);
</Script>

<!-- 저장 후 에러 메시지 -->
<script language="JavaScript" for="sheet1" event="OnSaveEnd(ErrMsg)">
    if (ErrMsg != ""){
        sendErrMsg(ErrMsg);
        displayErrMsg();
    }else{
        doAction("Search");
    }
</script>

<script language="javascript" for="sheet1" event="OnClick(Row, Col, Value)">
</script>

<script language="javascript" for="sheet1" event="OnValidation(Row, Col, Value)">
    //중복된 값이 존재하는 경우 메시지를 표시하고, 해당 행으로 포커스 옮김
    /**
    if( Col == 4 ) {
        if(colDupCheck(sheet1, "ORG_CD")){
            ValidateFail = false;
        }else{
            ValidateFail = true;
        }
    }
    **/
</script>

<script language="JavaScript">
//검색 select box
function sBox_() {
    var benefitBizCdBox = document.forms["form"].searchAppraisalCd;

<%-- <%  if(resultData != null && resultData.length > 0) {
        for(int i = 0 ; i < resultData.length ; i++) {
%>
                addOption(benefitBizCdBox, "<%=resultData[i][1]%>","<%=resultData[i][0]%>", false);               
<%
        }
    }
%> --%>
}

function changeCombo(){
	var no = document.all.searchAppraisalCd.selectedIndex;
<%-- 	var aTypeComboName = "<%=comboList1[0]%>".replace("통상|신규", "");
	var aTypeComboCd = "<%=comboList1[1]%>".replace("A|B", ""); --%>
	
/* 	if(searchAppTypeCdAry[no] == "F") {
		sheet1.InitDataCombo (0, "targetType", "통상|신규" , "A|B");
	} else if (searchAppTypeCdAry[no] == "A") {
		sheet1.InitDataCombo (0, "targetType", aTypeComboName, aTypeComboCd);
	} */
	
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
							<li id="txt" class="txt">평가그룹설정</li>
							<li class="btn">
								<a href="javascript:doAction('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction('Save')" 	class="basic authA">저장</a>
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