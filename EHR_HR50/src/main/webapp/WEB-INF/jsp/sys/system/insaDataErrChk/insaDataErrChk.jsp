<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='113262' mdef='인사정보오류검증'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 인사정보오류검증
 * @author SORYU
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var inputFlag = "Y" ;

$(function() {
	$("#searchSabun, #searchGubunCd").bind("keyup",function(event){
		if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
	});

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
		{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",			Type:"Int",			Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='enterCd_V6917' mdef='회사코드'/>",		Type:"Text",		Hidden:0,	Width:70,			Align:"Center",	ColMerge:0,	SaveName:"enterCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='enterCd' mdef='회사명'/>",			Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"enterNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='tableNm_V1010' mdef='관련테이블'/>",		Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"tableNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='chkGubunCd' mdef='구분코드'/>",		Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"chkGubunCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='chkGubunNm' mdef='구분명'/>",			Type:"Text",		Hidden:0,	Width:150,			Align:"Center",	ColMerge:0,	SaveName:"chkGubunNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='mailcont' mdef='내용'/>",			Type:"Text",		Hidden:0,	Width:150,			Align:"Center",	ColMerge:0,	SaveName:"chkText",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='chkType' mdef='결과유형'/>",		Type:"Combo",		Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"chkType",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"<sht:txt mid='ymdV4' mdef='작업일자'/>",		Type:"Date",		Hidden:0,	Width:120,			Align:"Center",	ColMerge:0,	SaveName:"chkdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='chkid_V4699' mdef='작업자'/>",			Type:"Text",		Hidden:0,	Width:70,			Align:"Center",	ColMerge:0,	SaveName:"chkid",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }

	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 회사
	var enterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getEnterCdAllList&enterCd=",false).codeList, ""); //소속사
	sheet1.SetColProperty("enterNm", {ComboText:"|"+enterCdList[0], ComboCode:"|"+enterCdList[1]});

	// 결과유형
	var typeList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "R20070"), "");
	sheet1.SetColProperty("chkType", {ComboText:"|"+typeList[0], ComboCode:"|"+typeList[1]});

	//------------------------------------- 그리드 콤보 -------------------------------------//

	//------------------------------------- 조회조건 콤보 -------------------------------------//
	$("#searchEnterCd").html(enterCdList[2]);
	$("#searchEnterCd").prepend("<option value='ALL'>전체</option>");
	$("#searchType").html(typeList[2]);
	$("#searchType").prepend("<option value='ALL'>전체</option>");

	$(window).smartresize(sheetResize);
	sheetInit();
	doAction1("Search");

});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			sheet1.DoSearch("${ctx}/InsaDataErrChk.do?cmd=getInsaDataErrChkList", $("#sheet1Form").serialize());
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
	try {
		if (Msg != "") {
			alert(Msg);
		} sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {

			alert(Msg);

		} doAction1("Search") ;
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

function callProc(procName) {

	if( !confirm("오류검증작업을 실행하시겠습니까?") ) return ;

	var params = "searchEnterCd="+$("#searchEnterCd").val();

	var ajaxCallCmd = "call"+procName ;

	var data = ajaxCall("/InsaDataErrChk.do?cmd="+ajaxCallCmd,params,false);

	if(data == null || data.Result == null) {
		msg = procName+"를 사용할 수 없습니다." ;
	}

	if(data.Result.Code == null) {
		msg = "오류검증 완료" ;
	} else {
    	msg = "오류검증 도중 : "+data.Result.Message;
	}

	alert( msg ) ;
	doAction1("Search");
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
						<th><tit:txt mid='114232' mdef='회사'/></th>
						<td>  <select id="searchEnterCd" name="searchEnterCd" onchange="doAction1('Search')"> </select> </td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>  <input id="searchSabun" name="searchSabun" type="text" class="text"/> </td>
						<th><tit:txt mid='113628' mdef='구분명'/></th>
						<td>  <input id="searchGubunCd" name="searchGubunCd" type="text" class="text"/> </td>
						<th><tit:txt mid='113971' mdef='결과유형'/></th>
						<td>  <select id="searchType" name="searchType" onchange="doAction1('Search')"> </select> </td>
						<td> <btn:a href="javascript:doAction1('Search')"	css="button authR" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt">인사정보오류검증 <font color="red">[DB Item관리] 업무구분이 SYSTEM, 코드가 ERRCHK로 시작하는 Item 검증</font></li>
							<li class="btn">
								<btn:a href="javascript:callProc('P_SYS_DATA_ERROR_CHECK')"		css="pink authA" mid='110833' mdef="오류검증"/>
								<btn:a href="javascript:doAction1('Down2Excel')"		css="basic authR" mid='110698' mdef="다운로드"/>
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
