<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>조직 리스트 조회</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
// 	var srchBizCd = null;
// 	var srchTypeCd = null;
	var p = eval("${popUpStatus}");

	$(function() {

		var enterCd = "";

		var arg = p.popDialogArgumentAll();
	    if( arg != undefined ) {
			$("#appraisalCd").val(arg["searchAppraisalCd"]);
			$("#gubun").val(arg["searchGubun"]);
	    	enterCd    = arg["enterCd"];

	    }
	    var shtHid = 1;
	    if( $("#gubun").val() == "2" ) shtHid = 0;

		//$("#searchEnterCd").val(dialogArguments["enterCd"]) ;
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
				{Header:"No",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"삭제",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
				{Header:"상태",       Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
				{Header:"성명",       Type:"Text",      Hidden:0,  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"name",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"사번",       Type:"Text",      Hidden:0,  Width:100,  Align:"Center",    ColMerge:0,   SaveName:"sabun",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
				{Header:"제외사유",   Type:"Text",      Hidden:shtHid,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"memo",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0}
		];
		IBS_InitSheet(mySheet, initdata);

		mySheet.SetCountPosition(4);

	    $(window).smartresize(sheetResize); sheetInit();

	    doAction("Search");

	    $(".close").click(function() {
	    	p.self.close();
	    });


        //$("#searchOrgNm").bind("keyup",function(event){
         //   if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
        //});

	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			if( $("#gubun").val() == "2" ){
				mySheet.DoSearch( "${ctx}/Popup.do?cmd=getAppPeopleShowPopExList", $("#mySheetForm").serialize() );
			}else{
				mySheet.DoSearch( "${ctx}/Popup.do?cmd=getAppPeopleShowPopList", $("#mySheetForm").serialize() );
			}

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

	/*
	function mySheet_OnDblClick(Row, Col){
		var rv = new Array(2);
		rv["orgCd"] 	= mySheet.GetCellValue(Row, "orgCd");
		rv["orgNm"]		= mySheet.GetCellValue(Row, "orgNm");

		p.window.returnValue 	= rv;
		p.window.close();
	}
	*/
</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>대상자보기</li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
				<input type="hidden" name="appraisalCd" id="appraisalCd" />
				<input type="hidden" name="gubun" id="gubun" />
            	<input type="hidden" id="searchEnterCd" name="searchEnterCd" />

			<%--
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					   <td> <span>조직명</span> <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" /> </td>
                       <td>
						<a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a>
					</td>
				</tr>
				</table>
				</div>
			</div>
			--%>
		</form>

		<table class="sheet_main">
			<tr>
				<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">대상자보기</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%","kr"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>



