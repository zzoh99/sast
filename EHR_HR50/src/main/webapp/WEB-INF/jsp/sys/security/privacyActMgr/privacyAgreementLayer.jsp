<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>개인정보 보호법</title>
<base target="_self" />
<!-- <link rel="stylesheet" href="/common//css/dotum.css" /> -->
<script type="text/javascript" src="/common/js/jquery/jquery.defaultvalue.js"></script>


<script type="text/javascript">
	var privacyAgreementLayer = {id: 'privacyAgreementLayer'};

	$(function() {
		createIBSheet3(document.getElementById('agrsheet_wrap'), "agrsheet", "100%", "100%", "${ssnLocaleCd}");
		
		const modal = window.top.document.LayerModalUtility.getModal(privacyAgreementLayer.id);
		var {enterCd, infoSeq, subject} = modal.parameters;
		$("#enterCd").val(enterCd);
		$("#infoSeq").val(infoSeq);
		$("#subject").val(subject);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0,AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"Seq",  	Hidden:0,  Width:"50", Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",		Type:"DelCheck", 	Hidden:0,  Width:"50", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태",		Type:"Status", 		Hidden:0,  Width:"50", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"동의여부",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"agreeYn"},
			{Header:"순번",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"infoSeq"},
			{Header:"항목순번",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eleSeq"},
			{Header:"항목개요",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eleSummary"},
			{Header:"항목내용",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eleContents"},
			{Header:"항목타입",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eleType"},
			{Header:"출력순",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq"},
			{Header:"개요",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"subject"},
            {Header:"입력상자높이\n(미입력 기본 8)",			Type:"Int",     Hidden:0,  Width:100,  	Align:"Center", 	ColMerge:0,   SaveName:"colSize",			KeyField:0,   CalcLogic:"",   Format:"##",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"빈라인추가\n(위,아래)",				Type:"Text",   Hidden:0,  Width:80,  	Align:"Center", 	ColMerge:0,   SaveName:"upDown",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"추가갯수",							Type:"Int",     Hidden:0,  Width:80,  	Align:"Center", 	ColMerge:0,   SaveName:"whiteSpace",		KeyField:0,   CalcLogic:"",   Format:"#",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"동의여부",							Type:"CheckBox",     Hidden:0,  Width:80,  	Align:"Center", 	ColMerge:0,   SaveName:"agreeYn623",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" }
		]; IBS_InitSheet(agrsheet, initdata); agrsheet.SetEditable(true);agrsheet.SetCountPosition(4);agrsheet.SetVisible(true);
		agrsheet.SetColProperty("agreeYn", 		{ComboText:"|Y|N", ComboCode:"|Y|N"} );
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	function doAction(sAction) {
		switch (sAction) {
		case "Search":  agrsheet.DoSearch( "${ctx}/PrivacyActMgr.do?cmd=getPrivacyPopupList", $("#srchForm").serialize()); break;
		}
    }
    
	//조회후
	function agrsheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			$("#subject").html(agrsheet.GetCellValue(agrsheet.LastRow(), "subject"));
			creEleSummary();
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function agrsheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
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
		for(var i=1; i <= agrsheet.RowCount(); i++){
			var table = "";
			if ( agrsheet.GetCellValue(i, 'upDown') == 'UP' ){
				if ( agrsheet.GetCellValue(i, 'whiteSpace') > 0 ) {

					for ( var j=0; j <= agrsheet.GetCellValue(i, 'whiteSpace'); j++ ){
						table = table + "<br />";
					}
				}
			}
			table = table + " <table border='0' cellpadding='0' cellspacing='0' class='table' style='margin-top:5px'>";
			table = table + " <tr> ";
			if ( agrsheet.GetCellValue(i, "eleSummary") != "" ){

				table = table + "	<th class='strong' style='font-size:13px' colspan='2'> ";
				table = table + "		" + agrsheet.GetCellValue(i, "eleSummary") + " ";
				table = table + "	</th> ";
			}
			table = table + " </tr> ";
			table = table + " <tr> ";
			table = table + "	<td> ";
			table = table + "		<textarea id='eleContents_" + i + "' name='eleContents_" + i + "' class='readonly w100p' rows='" + (agrsheet.GetCellValue(i, 'colSize') == 0 || agrsheet.GetCellValue(i, 'colSize') == '' ? '8' : agrsheet.GetCellValue(i, 'colSize') ) + "' disabled='disabled'></textarea> ";
			table = table + "	</td> ";
			table = table + " </tr> ";

			if ( agrsheet.GetCellValue(i, 'agreeYn623') == 'Y' ){

				table = table + " <tr> ";
				table = table + "	<td  class='right' > ";
				table = table + "		 <input id='eleSeq_" + i + "' name='eleSeq_" + i + "' rowvalue='" + i + "' type='checkbox' style='vertical-align:middle' onclick='setAgreeYn(this)' /> 동의함 ";
				table = table + "	</td> ";
				table = table + " </tr> ";
			}

			table = table + " </table> ";

			if ( agrsheet.GetCellValue(i, 'upDown') == 'DN' ){
				if ( agrsheet.GetCellValue(i, 'whiteSpace') > 0 ) {

					for ( var j=0; j <= agrsheet.GetCellValue(i, 'whiteSpace'); j++ ){
						table = table + "<br />";
					}
				}
			}
			objDiv.append(table);
			$("#eleContents_"+i).val(agrsheet.GetCellValue(i, "eleContents"));

			agrsheet.SetCellValue(i, "eleSummary", "", 0);
			agrsheet.SetCellValue(i, "eleContents", "", 0);
			agrsheet.SetCellValue(i, "subject", "", 0);
		}
	}

	//동의함 클릭시 데이터 변경
	function setAgreeYn(obj){
		if(obj.checked){
			agrsheet.SetCellValue($(obj).attr("rowvalue"), "agreeYn", "Y");
		} else {
			agrsheet.ReturnData($(obj).attr("rowvalue"));
		}
	}

	//모두 동의
	function setAllAgree(){
		for(var i=1; i <= agrsheet.RowCount(); i++){
			$("#eleSeq_"+i).attr("checked", true);
			agrsheet.SetCellValue(i, "agreeYn", "Y");
		}
	}

	function validation(){
		var retVal = false;
		for(var i=1; i<=agrsheet.RowCount(); i++){
			if(agrsheet.GetCellValue(i, "agreeYn") != "Y"){
				alert("모든 항목에 동의하셔야 합니다.");
				return false;
			} else if(agrsheet.GetCellValue(i, "agreeYn") == "Y"){
				retVal = true;
			}
		}

		return retVal;
	}
</script>

</head>
<body class="bodywrap">

<div class="wrapper modal_layer" style="overflow: auto;">

	<div class="modal_body">
		<form id="srchForm" name="srchForm" method="post">
			<input type="hidden" id="enterCd"  name="enterCd"  />
			<input type="hidden" id="infoSeq"  name="infoSeq"  />
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
		<a href="javascript:closeCommonLayer('privacyAgreementLayer');" class="btn outline_gray">동의하지 않음</a>
		<a href="javascript:closeCommonLayer('privacyAgreementLayer');" class="btn filled">동의함</a>
	</div>
	<div class="hide">
		<div id="agrsheet_wrap"></div>
	</div>

</div>

</body>
</html>