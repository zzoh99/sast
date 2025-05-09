<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>PDF이관</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script>

var gPRow = "";
var pGubun = "";

$(function() {

	$("input[type='text']").keydown(function(event){
		if(event.keyCode == 27){
			return false;
		}
	});

	$("#searchWorkYy").mask('0000');

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
	initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:60,			Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

		{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"DummyCheck",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
		{Header:"귀속년도",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workYy",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"출력구분",	Type:"Combo",		Hidden:0,	Width:180,	Align:"Center",	ColMerge:0,	SaveName:"adjustType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"PopupEdit",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='receiveNo' mdef='일련\n번호'/>",	Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"seqNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"이전파일명",	Type:"Text",		Hidden:0,	Width:140,	Align:"Left",	ColMerge:0,	SaveName:"fileNmBefore",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"페이지시작",	Type:"Text",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"pageStart",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"페이지종료",	Type:"Text",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"pageEnd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='filePath_V6225' mdef='파일경로'/>",	Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"filePath",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='fileNm' mdef='파일명'/>",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"fileNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사번없음",	Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"cont",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	//var searchAdjustType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00780"), "");//(C00780)
	var searchAdjustType = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getCommonCodeList&grpCd=C00780&notInCode=",false).codeList, "");
	sheet1.SetColProperty("adjustType", 		{ComboText:"|"+searchAdjustType[0], ComboCode:"|"+searchAdjustType[1]} );

	$("#searchAdjustType").html(searchAdjustType[2]);

	$(window).smartresize(sheetResize); sheetInit();

	$("#searchWorkYy,#searchNm").bind("keyup",function(event){
		if( event.keyCode == 13){
			doAction1("Search");
		}
	});

	$("#searchAdjustType").bind("change",function(event){
		doAction1("Search");
	});

	$("#inputFile").change(function(){

		$("#file").val(this.files && this.files.length ? this.files[0].name : this.value.replace(/^C:\\fakepath\\/i, ''));

	});
});

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {

	case "Search":
					if (!chkInVal(sAction)) {break;}

					sheet1.DoSearch( "${ctx}/PDFReader.do?cmd=getPDFReaderList", $("#sendForm").serialize() );
					break;
					
	case "Save":
					IBS_SaveName(document.sendForm,sheet1);
					sheet1.DoSave( "${ctx}/PDFReader.do?cmd=savePDFReader", $("#sendForm").serialize());
					break;

	case "PDFCreate":

					if (!chkInVal(sAction)) {break;}

					if ( $("#inputFile").val() == "" ) {
						alert("파일을 입력해주세요.");
						break;
					}

					var searchWorkYy = $("#searchWorkYy").val();
					var searchAdjustType = $("#searchAdjustType option:selected").val();

					var param = "&yyyy="+searchWorkYy;
						param = param + "&adjustType="+ searchAdjustType;

					var action = "/PDFReader.do?cmd=createPDFReader" + param;
					$("#pfrm").attr("action", action);
					$("#pfrm").submit();

					break;
					
	case "PDFSubmit":

					if ( !confirm("사번이 있는 자료만 이관되며\r\n기존자료는 삭제됩니다.\r\n이관하시겠습니까?")){
						break;
					}
		
					if (!chkInVal(sAction)) {break;}

					var searchWorkYy = $("#searchWorkYy").val();
					var searchAdjustType = $("#searchAdjustType option:selected").val();

					var param = "&yyyy="+searchWorkYy;
						param = param + "&adjustType="+ searchAdjustType;

					var action = "/PDFReader.do?cmd=insertPDFReaderTCPN574" + param;
					$("#pfrmSb").attr("action", action);
					$("#pfrmSb").submit();

					break;

	case "Down2Excel":
					var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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
/* 		for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
			var sabun = sheet1.GetCellValue(r, "sabun");
			if ( sabun == "" ){
				sheet1.SetRowEditable(r,1);
				sheet1.SetCellEditble(r, "sDelete", 0);
			}else{
				sheet1.SetRowEditable(r,0);
			}
		} */
		sheetResize();
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
		doAction1("Search");
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

function sheet1_OnPopupClick(Row, Col) {
	try{

		var colName = sheet1.ColSaveName(Col);
		if (Row >= sheet1.HeaderRows()) {
			if (colName == "name") {
				empSearchPopup(Row, Col);
			}
		}
	} catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

//사원검색 팝입
function empSearchPopup(Row, Col) {
	if(!isPopup()) {return;}

	var w		= 840;
	var h		= 520;
	var url		= "/Popup.do?cmd=employeePopup";
	var args	= new Array();
	args["sType"] = "G";

	gPRow = Row;
	pGubun = "employeePopup";

	openPopup(url+"&authPg=R", args, w, h);
}

function getReturnValue(returnValue) {

	var rv = $.parseJSON('{'+ returnValue+'}');
	
	if(pGubun == "employeePopup"){
		sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
		sheet1.SetCellValue(gPRow, "name", rv["name"]);
	}
}

function chkInVal(sAction) {
	
	if ($("#searchWorkYy").val() == "") {
		alert("귀속년도를 입력하십시오.");
		$("#searchWorkYy").focus();
		return false;
	}

	return true;
}
</script>

</head>
<body class="bodywrap">
<div class="wrapper">

<form name="sendForm" id="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='114125' mdef='귀속년도'/></th>
			<td>
				<input id="searchWorkYy" name="searchWorkYy" type="text" class="text center required" style="width: 35px;" value="${curSysYear}" />
			</td>
			<th><tit:txt mid='112806' mdef='출력구분'/></th>
			<td>
				<select id="searchAdjustType" name="searchAdjustType" class="box required"></select>
			</td>
			<th>사번유무</th>
			<td>
				<select id="searchSabunNull" name="searchSabunNull" class="box" onchange="javascript:doAction1('Search');">
					<option value="">전체</option>
					<option value="Y">유</option>
					<option value="N">무</option>
				</select>
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchNm" name="searchNm" type="text" class="text" style="ime-mode:active;"/>
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="button"><tit:txt mid='104081' mdef='조회'/></a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>

<form id="pfrm" name="pfrm" target="hiddenIframe" action="/PDFReader.do?cmd=savePDFReader" method="post" enctype="multipart/form-data">
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">PDF이관</li>
				<li class="btn">
					<!-- <a id="btnSave" class="button large"><tit:txt mid='104242' mdef='업로드'/></a> -->
					<input type="hidden" id="yyyy" name="yyyy" value="" />
					<input type="hidden" id="adjustType" name="adjustType" value=""/>
					<input type="file" id="inputFile" name="inputFile" 		class="" accept=".pdf" maxlength="" value="" style="width:550px;" />
					<a href="javascript:doAction1('PDFCreate');"			class="pink large"><tit:txt mid='114525' mdef='생성'/></a>
					<a href="javascript:doAction1('Save');" 				class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
					<!-- <a href="javascript:doAction1('PDF');" 			class="button authA">PDF파일다운로드</a> -->
					<a href="javascript:doAction1('Down2Excel');" 			class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
					<a href="javascript:doAction1('PDFSubmit');"			class="pink large">원천징수영수증파일다운 메뉴에 반영</a>
				</li>
			</ul>
		</div>
	</div>
</form>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
<iframe name="hiddenIframe" id="hiddenIframe" style="display:none;"></iframe>
<form id="pfrmSb" name="pfrmSb" target="hiddenIframe" action="/PDFReader.do?cmd=savePDFReader" method="post" >

</form> -->
</body>
</html>
