<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- <%@ page import="com.hr.common.util.DateUtil" %> --%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="/common/js/jquery/select2.js"></script>

<script type="text/javascript">
var pRow = "";
var pGubun = "";

var titleList = new Array();

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:4};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='grcodeCdV1' mdef='그룹코드'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"grpCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
   			{Header:"<sht:txt mid='eleId' mdef='항목ID'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"colId",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
   			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"colName",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
   			{Header:"<sht:txt mid='2017082500492' mdef='항목길이'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"colWidth",		KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:0},
   			{Header:"<sht:txt mid='eleTypeV1' mdef='항목타입'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"colType",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0},
   			{Header:"<sht:txt mid='elementAlign' mdef='정렬'/>",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"colAlign",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0},
   			{Header:"<sht:txt mid='2017082500493' mdef='항목형식'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"colFormat",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0},
   			{Header:"<sht:txt mid='2017082500494' mdef='항목순서'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"colOrder",		KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:0},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		$(window).smartresize(sheetResize); sheetInit();
		// 회사코드
		var grpCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getGrpCdMgrGrpCdList",false).codeList, "");
		$("#searchGrpCd").html(grpCdList[2]).on("change",function(){
			doAction1("Search");
		});
		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "R20100";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		sheet1.SetColProperty("colAlign",  	{ComboText:"|"+codeLists["R20100"][0], ComboCode:"|"+codeLists["R20100"][1]} );// 신청상태
		//==============================================================================================================================
	});

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search":
		sheet1.DoSearch( "${ctx}/EmpList.do?cmd=getEmpListColAttrMgrList", $("#mySheetForm").serialize()	);
		break;
	case "Save":
		//if(!dupChk(sheet1,"grpCd|colId", true, true)){break;}
		IBS_SaveName(document.mySheetForm,sheet1);
		sheet1.DoSave( "${ctx}/EmpList.do?cmd=saveEmpListColAttrMgr", $("#mySheetForm").serialize());
		break;
	case "Down2Excel":
		var downcol = makeHiddenSkipCol(sheet1);
		var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
		sheet1.Down2Excel(param);
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
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}
// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }
		doAction1("Search");
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "orgBasicPopup"){
		$("#searchOrgCd").val(rv["orgCd"]);
		$("#searchOrgNm").val(rv["orgNm"]);
    }
}

</script>



</head>
<body class="hidden">
<div class="wrapper">
<form id="mySheetForm" name="mySheetForm" >
   <div class="sheet_search outer">
       <div>
       <table>
       <tr>
           <th><tit:txt mid='grpCd' mdef='그룹코드'/></th>
           <td>
               <select id="searchGrpCd" name ="searchGrpCd"></select>
           </td>
           <td>
           	   <btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/>
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
							<li id="txt" class="txt">인원명부항목속성</li>
							<li class="btn">
           	  					<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='110708' mdef="저장"/>
           	  					<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
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
