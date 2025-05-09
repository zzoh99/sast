<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='orgSchList' mdef='조직 리스트 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
// 	var srchBizCd = null;
// 	var srchTypeCd = null;
	var p = eval("${popUpStatus}");

	$(function() {

		var searchYyyy = "";
		var sabun = "";

		var arg = p.window.dialogArguments;
	    if( arg != undefined ) {
	    	searchYyyy = arg["searchYyyy"];
			sabun = arg["sabun"];

	    }else{
	    	if(p.popDialogArgument("searchYyyy")!=null)		searchYyyy  	= p.popDialogArgument("searchYyyy");
	    	if(p.popDialogArgument("sabun")!=null)			sabun  			= p.popDialogArgument("sabun");
	    }

    	$("#searchYyyy").val(searchYyyy);
		$("#year").html(searchYyyy);
		$("#sabun").val(sabun);

		//$("#searchEnterCd").val(dialogArguments["enterCd"]) ;
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
				{Header:"<sht:txt mid='surveyItemType' mdef='분류'/>",			Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"eduGubunCd",  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
				{Header:"<sht:txt mid='eduPoint_V4321' mdef='의무학점'/>",			Type:"Int",       Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"eduPoint",  KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
				{Header:"<sht:txt mid='eduRewardCntV4' mdef='이수학점'/>",			Type:"AutoSum",       Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"getEduPoint",  KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
				{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",				Type:"Text",      Hidden:0,  Width:200,	 Align:"Left",    ColMerge:0,   SaveName:"note",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4000 },
				{Header:"<sht:txt mid='appraisalYy' mdef='년도'/>",				Type:"Text",      Hidden:1,  Width:200,	 Align:"Left",    ColMerge:0,   SaveName:"yy",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 }
		];
		IBS_InitSheet(mySheet, initdata);

		mySheet.SetCountPosition(4);
		mySheet.SetAutoSumPosition(1);
		mySheet.SetSumValue("sNo", "합계") ;
        var list1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L90200"), "");
        mySheet.SetColProperty("eduGubunCd", 			{ComboText:"|"+list1[0], ComboCode:"|"+list1[1]} );

	    $(window).smartresize(sheetResize); sheetInit();

	    doAction("Search");

	    $(".close").click(function() {
	    	p.self.close();
	    });

        /*
        $("#searchOrgNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
        });
		*/
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			mySheet.DoSearch( "${ctx}/Popup.do?cmd=getEduPointPopupList", $("#mySheetForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><span id="year"></span>년도 학점 이수 내역</li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
				<input type="hidden" name="searchYyyy" id="searchYyyy" />
				<input type="hidden" name="sabun" id="sabun" />
		</form>

		<table class="sheet_main">
			<tr>
				<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><span id="spanTot1" style="color:red;"><tit:txt mid='113427' mdef='＊의무학점 총 학점 10점 이상'/></span></li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>



