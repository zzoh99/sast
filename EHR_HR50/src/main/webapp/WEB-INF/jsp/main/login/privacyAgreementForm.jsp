 <%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%//@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" 			prefix="c" %>
<c:set var="sessionScope"	scope="session" />
<c:set var="ctx" 			value="${pageContext.request.contextPath}"/>
<c:set var="wfont" 			value="nanum"/>
<c:set var="theme" 			value="white"/>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>개인정보 보호법</title>
<base target="_self" />
<!--   STYLE START	 -->
<link rel="stylesheet" type="text/css" href="/common/css/${wfont}.css">
<link rel="stylesheet" type="text/css" href="/common/${theme}/css/style.css">
<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
<link rel="stylesheet" type="text/css" href="/common/css/util.css" />
<link rel="stylesheet" type="text/css" href="/common/css/override.css" />
<link rel="stylesheet" type="text/css" href="/common/css/mainSub.css" />
<link rel="stylesheet" type="text/css" href="/common/js/contextmenu/jquery.contextMenu.css"/>

<!-- HR UX 개선 신규 CSS -->
<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
<link rel="stylesheet" href="/assets/plugins/swiper-10.2.0/swiper-bundle.min.css" />
<link rel="stylesheet" href="/assets/plugins/jquery-ui-1.13.2/jquery-ui-1.13.2.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/themes/${theme}.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
<link href="${ ctx }/assets/css/modal.css" rel="stylesheet" >
<link href="${ ctx }/assets/css/process_map.css" rel="stylesheet" >
<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css">

<!--   JQUERY	 -->
<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/ui/1.13.2/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.datepicker.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/datepicker_lang_KR.js"	type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/select2.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.defaultvalue.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/jquery/jquery.mask.js" type="text/javascript" charset="utf-8"></script>

<!--   VALIDATION	 -->
<script src="${ctx}/common/js/jquery/jquery.validate.js" type="text/javascript" charset="utf-8"></script>

<!--  COMMON SCRIT -->

<script src="${ctx}/common/js/common.js" type="text/javascript" charset="UTF-8"></script>
<script src="${ctx}/common/js/commonIBSheet.js" type="text/javascript" charset="utf-8"></script>
<script src="${ctx}/common/js/autolink.js"		type="text/javascript" charset="UTF-8"></script>

<script type="text/javascript" src="/common/js/ras/script.js"></script>

<%//@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {

		$(".close").click(function() {
			if(confirm("동의하지 않을 경우 시스템에 로그인 할수 없습니다.\n\n로그인 화면으로 이동하시겠습니까?")){
				//p.window.returnValue=false;
				//p.self.close();
				location.href = "${ctx}/Login.do";
			}
		});


		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"Seq",  	Hidden:0,  Width:"50", Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"DelCheck", 	Hidden:0,  Width:"50", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"Status", 		Hidden:0,  Width:"50", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='agreeYn_V2158' mdef='동의여부'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"agreeYn"},
			{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"infoSeq"},
			{Header:"<sht:txt mid='eleSeq' mdef='항목순번'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eleSeq"},
			{Header:"<sht:txt mid='eleSummary' mdef='항목개요'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eleSummary"},
			{Header:"<sht:txt mid='eleContents' mdef='항목내용'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eleContents"},
			{Header:"<sht:txt mid='eleTypeV1' mdef='항목타입'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eleType"},
			{Header:"<sht:txt mid='orderSeq_V5951' mdef='출력순'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq"},
			{Header:"<sht:txt mid='memoV12' mdef='개요'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"subject"},
			{Header:"입력상자높이\n(미입력 기본 8)",			Type:"Int",     Hidden:0,  Width:100,  	Align:"Center", 	ColMerge:0,   SaveName:"colSize",			KeyField:0,   CalcLogic:"",   Format:"##",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"빈라인추가\n(위,아래)",				Type:"Text",   Hidden:0,  Width:80,  	Align:"Center", 	ColMerge:0,   SaveName:"upDown",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"추가갯수",							Type:"Int",     Hidden:0,  Width:80,  	Align:"Center", 	ColMerge:0,   SaveName:"whiteSpace",		KeyField:0,   CalcLogic:"",   Format:"#",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"동의여부",							Type:"CheckBox",     Hidden:0,  Width:80,  	Align:"Center", 	ColMerge:0,   SaveName:"agreeYn623",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetVisible(true);
		sheet1.SetColProperty("agreeYn", 		{ComboText:"|Y|N", ComboCode:"|Y|N"} );
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");

	});

	function doAction(sAction) {
		switch (sAction) {
		case "Search":  sheet1.DoSearch( "${ctx}/PrivacyAgreement.do?cmd=getPrivacyAgreementList", $("#srchForm").serialize()); break;
		case "Save":
			if(!validation()) return;
			IBS_SaveName(document.srchForm,sheet1);
			sheet1.DoSave("${ctx}/PrivacyAgreement.do?cmd=insertPrivacyAgreement", $("#srchForm").serialize() );
			break;
		}
    }
	//조회후
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			$("#subject").html(sheet1.GetCellValue(sheet1.LastRow(), "subject"));
			creEleSummary();
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(StCode != "-1") {
				location.href = "${ctx}/loginUser.do"; //로그인
			} else{
				alert(Msg);
			}

		} catch (ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	//내부 로직 생성
	function creEleSummary(){
		var objDiv = $("#contents");
		for(var i=1; i <= sheet1.RowCount(); i++){
			var table = "";
			if ( sheet1.GetCellValue(i, 'upDown') == 'UP' ){
				if ( sheet1.GetCellValue(i, 'whiteSpace') > 0 ) {

					for ( var j=0; j <= sheet1.GetCellValue(i, 'whiteSpace'); j++ ){
						table = table + "<br />";
					}
				}
			}
			table = table + " <table border='0' cellpadding='0' cellspacing='0' class='table' style='margin-top:5px'>";
			table = table + " <tr> ";
			if ( sheet1.GetCellValue(i, "eleSummary") != "" ){

				table = table + "	<th class='strong' style='font-size:13px' colspan='2'> ";
				table = table + "		" + sheet1.GetCellValue(i, "eleSummary") + " ";
				table = table + "	</th> ";
			}
			table = table + " </tr> ";
			table = table + " <tr> ";
			table = table + "	<td> ";
			table = table + "		<textarea id='eleContents_" + i + "' name='eleContents_" + i + "' class='readonly w100p' rows='" + (sheet1.GetCellValue(i, 'colSize') == 0 || sheet1.GetCellValue(i, 'colSize') == '' ? '8' : sheet1.GetCellValue(i, 'colSize') ) + "' disabled='disabled'></textarea> ";
			table = table + "	</td> ";
			table = table + " </tr> ";

			if ( sheet1.GetCellValue(i, 'agreeYn623') == 'Y' ){

				table = table + " <tr> ";
				table = table + "	<td  class='right' > ";
				table = table + "		 <input id='eleSeq_" + i + "' name='eleSeq_" + i + "' rowvalue='" + i + "' type='checkbox' style='vertical-align:middle' onclick='setAgreeYn(this)' /> 동의함 ";
				table = table + "	</td> ";
				table = table + " </tr> ";
			}

			table = table + " </table> ";

			if ( sheet1.GetCellValue(i, 'upDown') == 'DN' ){
				if ( sheet1.GetCellValue(i, 'whiteSpace') > 0 ) {

					for ( var j=0; j <= sheet1.GetCellValue(i, 'whiteSpace'); j++ ){
						table = table + "<br />";
					}
				}
			}
			objDiv.append(table);
			$("#eleContents_"+i).val(sheet1.GetCellValue(i, "eleContents"));

			sheet1.SetCellValue(i, "eleSummary", "", 0);
			sheet1.SetCellValue(i, "eleContents", "", 0);
			sheet1.SetCellValue(i, "subject", "", 0);
		}
	}

	//동의함 클릭시 데이터 변경
	function setAgreeYn(obj){
		if(obj.checked){
			sheet1.SetCellValue($(obj).attr("rowvalue"), "agreeYn", "Y");
		} else {
			sheet1.ReturnData($(obj).attr("rowvalue"));
		}
	}

	//모두 동의
	function setAllAgree(){
		for(var i=1; i <= sheet1.RowCount(); i++){
			$("#eleSeq_"+i).attr("checked", true);
			sheet1.SetCellValue(i, "agreeYn", "Y");
		}
	}

	function validation(){
		var retVal = false;
		for(var i=1; i<=sheet1.RowCount(); i++){
			if(sheet1.GetCellValue(i, "agreeYn") != "Y"){
				alert("<msg:txt mid='201707070000010' mdef='모든 항목에 동의하셔야 합니다.'/>");
				return false;
			} else if(sheet1.GetCellValue(i, "agreeYn") == "Y"){
				retVal = true;
			}
		}

		return retVal;
	}
</script>
</head>
<body class="bodywrap">
<div class="popup_title">
	<ul>
		<li><tit:txt mid='113214' mdef='개인정보 보호법'/></li>
	</ul>
</div>
<div class="wrapper modal_layer" style="overflow: auto;">

	<div class="modal_body">
		<form id="srchForm" name="srchForm" method="post">
			<input type="hidden" id="enterCd"  name="enterCd"  />
			<input type="hidden" id="infoSeq" name="infoSeq" value="${sessionScope.ssnPAInfoSeq}">
		</form>
		<!-- 개인정보 보호법 해더  -->
		<table border="0" cellpadding="0" cellspacing="0" class="table">
		<tr class="hide">
			<th class="strong">개  요</th>
		</tr>
		<tr class="hide">
			<td>
				<textarea id="subject" name="subject" class="readonly w100p" rows="8"></textarea>
			</td>
		</tr>
		</table>
		<div id="contents">
		</div>
	</div>
	<div class="modal_footer">
		<a class="btn outline_gray close">동의하지 않음</a>
		<a href="javascript:doAction('Save');" class="btn filled">동의함</a>
	</div>
	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	</div>
</div>
</body>
</html>
