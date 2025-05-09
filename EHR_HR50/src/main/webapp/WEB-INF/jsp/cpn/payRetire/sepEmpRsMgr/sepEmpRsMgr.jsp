<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>퇴직금기본내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%-- <script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script> --%>
<!--
 * 퇴직금기본내역
 * @author JM
-->
<script type="text/javascript">
//iframe
var newIframe;
var oldIframe;
var iframeIdx;
var gPRow = "";
var pGubun = "";

$(function() {

	var strSdate = "${curSysYyyyMMddHyphen}";
	var strEdate = "${curSysYyyyMMddHyphen}";

	var arrSdate = strSdate.split("-");
	var arrSdat = new Date(arrSdate[0],arrSdate[1]-1,arrSdate[2]);

	arrSdat.setDate(arrSdat.getDate() - 365 );
	var strSdateMinus = arrSdat.getFullYear() + "-" + (arrSdat.getMonth() < 10 ? '0' + (arrSdat.getMonth()+1) : arrSdat.getMonth()+1 ) + "-" + (arrSdat.getDate() < 10 ? '0' + (arrSdat.getDate() ) : arrSdat.getDate());

	$("#searchSDate").val(strSdateMinus);
	$("#searchEDate").val(strEdate);

 	var p = $(top.document);

 	if( p.find(".topFull").hasClass("active") == false ) {
		//p.find("#wrap").addClass("full");
		p.find(".topFull").addClass("active");
		setFullSize = "true";
		p.find(".topFull").click();
	}

	$("input[type='text']").keydown(function(event){
		if(event.keyCode == 27){
			return false;
		}
	});

	$("#searchSDate").datepicker2({startdate:"searchEDate", onReturn: getCommonCodeList});
	$("#searchEDate").datepicker2({enddate:"searchSDate", onReturn: getCommonCodeList});

	var payCdList   = convCode( ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCpnPayCdList&searchRunType=00004,",false).codeList, "");
	$("#searchPayCd").html(payCdList[2]);

	getCommonCodeList();

	newIframe = $('#tabs-1 iframe');
	iframeIdx = 0;

	$( "#tabs" ).tabs({
		beforeActivate: function(event, ui) {
			iframeIdx = ui.newTab.index();
			newIframe = $(ui.newPanel).find('iframe');
			oldIframe = $(ui.oldPanel).find('iframe');
			showIframe();
		}
	});

	$("#searchPayCd, #searchJikweeCd, #searchPayType").bind("change",function(event){
		doAction1("Search");
	});

	$("#searchSDate, #searchEDate, #searchNm").bind("keyup", function(){
		if( event.keyCode == 13){
			doAction1("Search");
		}
	});

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
	initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

	initdata1.Cols = [
		{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

		{Header:"급여코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payActionCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"선택",			Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" , Sort:0 },
		{Header:"마감\n여부",		Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"closeMsg",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"마감여부",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"closeYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"지급일",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"paymentYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사번",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"성명",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"그룹\n입사일",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"입사일",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"퇴사일",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"계산여부",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"calcBtYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"퇴직금\n재계산",	Type:"Html",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"calBtn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	]; IBS_InitSheet(sheetLeft, initdata1);sheetLeft.SetEditable("${editable}");sheetLeft.SetVisible(true);sheetLeft.SetCountPosition(4);

	$(window).smartresize(sheetResize); sheetInit();

	doAction1('Search');

	// 화면 리사이즈
	$(window).resize(setIframeHeight);
	setIframeHeight();

	showIframe();

	// 최근급여일자 조회
	//getCpnLatestPaymentInfo();

});

function getCommonCodeList() {
	let baseSYmd = $("#searchSDate").val();
	let baseEYmd = $("#searchEDate").val();

	var jikweeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030", baseSYmd, baseEYmd), "전체");
	$("#searchJikweeCd").html(jikweeCdList[2]);

	var payTypeList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10110", baseSYmd, baseEYmd), "전체");
	$("#searchPayType").html(payTypeList[2]);
}

// 탭 높이 변경
function setIframeHeight() {
	var iframeTop = $("#tabs ul.tab_bottom").height() + 8;
	var iframHeight = $('.sheet_right').height() - 10;//위 여백 top: 10px
	$(".layout_tabs").each(function() {
		$(this).css("top",iframeTop);
	});

	$(".insa_tab").each(function() {
		$(this).css("height",iframHeight);
	});
}

function showIframe() {
	if(typeof oldIframe != 'undefined') {
		oldIframe.attr("src","${ctx}/common/hidden.html");
	}
	if(iframeIdx == 0) {
		// 기본사항
		newIframe.attr("src","${ctx}/SepEmpRsMgr.do?cmd=viewSepEmpRsMgrBasic&authPg=${authPg}");
	} else if(iframeIdx == 1) {
		// 평균임금
		newIframe.attr("src","${ctx}/SepEmpRsMgr.do?cmd=viewSepEmpRsMgrAverageIncome&authPg=${authPg}");
	} else if(iframeIdx == 2) {
		// 퇴직금계산내역
		newIframe.attr("src","${ctx}/SepEmpRsMgr.do?cmd=viewSepEmpRsMgrSeverancePayCalc&authPg=${authPg}");
	} else if(iframeIdx == 3) {
		// 퇴직종합정산
		newIframe.attr("src","${ctx}/SepEmpRsMgr.do?cmd=viewSepEmpRsMgrRetireCalc&authPg=${authPg}");
	}
}


function getReturnValue(returnValue) {
}

// 필수값/유효성 체크
/* function chkInVal(sAction) {
	if($("#searchUserId").val() == "") {
		alert("대상자를 선택하십시오.");
		$("#tdSabun").focus();
		return false;
	}
	if($("#payActionCd").val() == "") {
		alert("퇴직일자를 선택하십시오.");
		$("#payActionCd").focus();
		return false;
	}
	return true;
} */

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
				if (!chkInVal(sAction)) {break;}
				sheetLeft.DoSearch( "${ctx}/SepEmpRsMgr.do?cmd=getSepEmpRsMgrListLeft", $("#mainForm").serialize() );
				break;
		case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheetLeft);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheetLeft.Down2Excel(param);

				break;
		case "prcP_CPN_SEP_PAY_MAIN":
			// 필수값/유효성 체크
/* 			if (!chkInVal(sAction)) {
				break;
			} */

			var sCheckRow = sheetLeft.FindCheckedRow("ibsCheck");

			if ( sCheckRow == "" ){
				alert("선택된 내역이 없습니다.");
				break;
			}


			if (confirm("선택된 내역으로 퇴직금재계산을 실행하시겠습니까?")) {
				var arrRow = [];

				$(sCheckRow.split("|")).each(function(index,value){
					arrRow[index] = sheetLeft.GetCellValue(value,"payActionCd")+"_"+sheetLeft.GetCellValue(value,"sabun");
				});

				var checkValues = "";

				for(var i=0; i<arrRow.length; i++) {
					if(i != 0) {
						checkValues += ",";
					}
					checkValues += arrRow[i];
				}

				try{
					var prcResult = ajaxCall("${ctx}/SepEmpRsMgr.do?cmd=prcP_CPN_SEP_PAY_MAIN", "checkValues="+checkValues, false);

					if (prcResult != null && prcResult["Result"] != null && prcResult["Result"]["Code"] != null) {
						if (prcResult["Result"]["Code"] == "0") {
							alert("자료생성 되었습니다.");
							// 프로시저 호출 후 재조회
								//$('iframe')[iframeIdx].contentWindow.setEmpPage();
								doAction1("Clear");
								doAction1("Search");

						} else if (prcResult["Result"]["Message"] != null && prcResult["Result"]["Message"] != "") {
							alert(prcResult["Result"]["Message"]);
						}
					} else {
						alert("퇴직금재계산 오류입니다.");
					}
				} catch (ex){
					alert("저장중 스크립트 오류발생." + ex);
				}
			}

			break;

		case "Clear":
			$('iframe')[iframeIdx].contentWindow.doAction1("Clear");
			$('iframe')[iframeIdx].contentWindow.setEmpPage();
			break;
	}
}

// 조회 후 에러 메시지
function sheetLeft_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		for(var i = 1; i < sheetLeft.RowCount()+1; i++) {

			if(sheetLeft.GetCellValue(i,"calcBtYn") == 'Y' ){

				sheetLeft.SetCellEditable(i, "ibsCheck", 1);
/* 				sheetLeft.SetCellValue(i, "calBtn", '<a class="basic" onClick="alert("aa");">계산</a>');
				sheetLeft.SetCellValue(i, "sStatus", 'R'); */
			}else{
				sheetLeft.SetCellEditable(i, "ibsCheck", 0);
			}

			if ( sheetLeft.GetCellValue(i, "closeYn") == "Y" ){
				sheetLeft.SetCellEditable(i, "ibsCheck", 0);
			}else{
				sheetLeft.SetCellEditable(i, "ibsCheck", 1);
			}
		}
		
		var selRow = "";
		selRow = sheetLeft.GetSelectRow();
		if(selRow > 0){
			$("#tdSabun").val(sheetLeft.GetCellValue(selRow, "sabun"));
			$("#payActionCd").val(sheetLeft.GetCellValue(selRow, "payActionCd"));	
		}
				
		sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

function sheetLeft_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try{

		if ( Row > 0 ){
			if( sheetLeft.ColSaveName(Col) != "ibsCheck" && sheetLeft.GetCellValue(Row, "calcBtYn") == "Y") {
				$("#tdSabun").val(sheetLeft.GetCellValue(Row,"sabun"));
				$("#payActionCd").val(sheetLeft.GetCellValue(Row,"payActionCd"));
				setEmpPage();
			}
		}

	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
}

function chkInVal(sAction) {
	if ($("#searchSDate").val() == "" || $("#searchEDate").val() == "") {
		alert("지급일자 기간을 입력하십시오.");
		$("#searchSDate").focus();
		return false;
	}

	return true;
}

//소속 팝입
function orgSearchPopup(){
    try{
    	if(!isPopup()) {return;}

		var args    = new Array();

		gPRow = "";
		pGubun = "searchOrgBasicPopup";

		let layerModal = new window.top.document.LayerModal({
			id : 'orgLayer'
			, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
			, parameters : {}
			, width : 740
			, height : 520
			, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
			, trigger :[
				{
					name : 'orgTrigger'
					, callback : function(result){
						if(!result.length) return;
						$("#searchOrgNm").val(result[0].orgNm);
						$("#searchOrgCd").val(result[0].orgCd);
					}
				}
			]
		});
		layerModal.show();

    }catch(ex){alert("Open Popup Event Error : " + ex);}
}

function setEmpPage() {
	doAction1("Clear");
	$('iframe')[iframeIdx].contentWindow.setEmpPage();
}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<!-- include 기본정보 page -->
	<%-- <%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%> --%>
	<form id="mainForm" name="mainForm">
	<input type="hidden" id="tdSabun" name="tdSabun" class="text" value="" />
	<input type="hidden" id="payActionCd" name="payActionCd" class="text" value="" />
	<div class="sheet_search outer">
		<div>
			<table>
				<tr>
					<th>지급일자</th>
					<td>
						<input type="text" id="searchSDate" name="searchSDate" class="date2 required" value="${curSysYyyyMMddHyphen}" />
						~ <input type="text" id="searchEDate" name="searchEDate" class="date2 required" value="${curSysYyyyMMddHyphen}" />
					</td>
					<th>소속</th>
					<td>
						<input type="hidden" id="searchOrgCd" name="searchOrgCd" class="text" value="" />
						<input type="text" id="searchOrgNm" name="searchOrgNm" class="text" value="" readonly="readonly" style="width:120px" />
						<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif" /></a>
						<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/images/icon/icon_undo.png" /></a>
					</td>
					<th>급여코드</th>
					<td><select id="searchPayCd" name="searchPayCd"></select></td>
				</tr>
				<tr>
					<th>직위</th>
					<td><select id="searchJikweeCd" name="searchJikweeCd"></select>
					</td>
					<th>급여유형</th>
					<td><select id="searchPayType" name="searchPayType"></select></td>
					<th>사번/성명</th>
					<td><input id="searchNm" name="searchNm" type="text" class="text" /></td>
					<td><a href="javascript:doAction1('Search')" class="button">조회</a></td>
<!-- 					<td> <span>급여일자</span> <input type="hidden" id="payActionCd" name="payActionCd" value="" />
						 <input type="text" id="payActionNm" name="payActionNm" class="text required readonly" value="" readonly style="width:180px" />
						 <a onclick="javascript:payActionSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a></td>
					<td> <a href="javascript:doAction1('prcP_CPN_SEP_PAY_MAIN')"	class="basic authA">퇴직금재계산</a> </td> -->
				</tr>
			</table>
		</div>
	</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="35%" />
		<col width="65%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul class="">
					<li id="txt" class="txt">퇴직금내역관리</li>
					<li class="btn">
						<a href="javascript:doAction1('prcP_CPN_SEP_PAY_MAIN');"	class="basic authR">퇴직금재계산</a>
						<a href="javascript:doAction1('Down2Excel')" 				class="basic authR">다운로드</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheetLeft", "100%", "100%","kr"); </script>
		</td>
		<td class="sheet_right">
			<!-- <div style="position:absolute;width:59%;top:83px;bottom:0"> -->
			<div class="insa_tab" style="width: 63%;">
				<div id="tabs" class="tabs">
					<ul class="tab_bottom">
						<li id="tabs1"><a href="#tabs-1">기본사항</a></li>
						<li id="tabs2"><a href="#tabs-2">평균임금</a></li>
						<li id="tabs3"><a href="#tabs-3">퇴직금계산내역</a></li>
						<li id="tabs4"><a href="#tabs-4">퇴직종합정산</a></li>
					</ul>
					<div id="tabs-1">
						<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
					</div>
					<div id="tabs-2">
						<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
					</div>
					<div id="tabs-3">
						<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
					</div>
					<div id="tabs-4">
						<div class="layout_tabs"><iframe src="${ctx}/common/hidden.html" frameborder="0" class="tab_iframes"></iframe></div>
					</div>
				</div>
			</div>
		</td>
	</tr>
</table>
</div>
</body>
</html>
