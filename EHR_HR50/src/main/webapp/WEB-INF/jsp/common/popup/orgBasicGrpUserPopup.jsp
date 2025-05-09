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
	var p = eval("${popUpStatus}");

	$(function() {

		$("#chkVisualYn").html("<option value=''>전체</option> <option value='Y'>사용</option> <option value='N'>사용안함</option>"); // 보여주기여부

		var enterCd = "";
		var chkVisualYn	= "";

		var arg = p.popDialogArgumentAll();
	    if( arg != undefined ) {

	    	enterCd    = arg["enterCd"];
	    	chkVisualYn= arg["chkVisualYn"];


		    if (chkVisualYn != null && chkVisualYn != "") {
		    	$("#chkVisualYn").val(chkVisualYn);
		    }
	    }

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
				{Header:"<sht:txt mid='orgSchemeUseYn' mdef='현조직도\n사용여부'/>", 	Type:"CheckBox",  Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgSchemeUseYn",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1,	TrueValue:"1", FalseValue:"0" },
				{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",      Type:"Text",      Hidden:0,  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"orgCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",        Type:"Text",      Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
				{Header:"<sht:txt mid='orgFullNm' mdef='조직명(FULL)'/>",  Type:"Text",      Hidden:1,  Width:180,  Align:"Left",    ColMerge:0,   SaveName:"orgFullNm",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"<sht:txt mid='orgEngNm' mdef='조직명(영문)'/>",  Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgEngNm",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"<sht:txt mid='orgType' mdef='조직유형'/>",      Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgType",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='inoutType' mdef='내외구분'/>",          Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"inoutType",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
				{Header:"<sht:txt mid='inoutTypeV2' mdef='조직구분'/>",          Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"objectType",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
				{Header:"<sht:txt mid='telNoV2' mdef='대표전화번호'/>",  Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"telNo",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
				{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",      Type:"Text",      Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"sdate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",      Type:"Text",      Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"edate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='coTelNo' mdef='내선번호'/>",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"coTelNo",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
				{Header:"<sht:txt mid='locationCdV3' mdef='LOCATION'/>",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"locationCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:7 },
				{Header:"<sht:txt mid='mission' mdef='조직목적'/>",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"mission",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
				{Header:"<sht:txt mid='roleMemo' mdef='조직역할'/>",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"roleMemo",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
				{Header:"<sht:txt mid='keyJobMemo' mdef='조직KEYJOB'/>",    Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"keyJobMemo",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
				{Header:"<sht:txt mid='deptchiefreg' mdef='부서장등록'/>",    Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"deptchiefreg", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		];
		IBS_InitSheet(mySheet, initdata);

		mySheet.SetCountPosition(4);

	    $(window).smartresize(sheetResize); sheetInit();
	    $("#searchBaseDate").datepicker2();

	    doAction("Search");

	    $(".close").click(function() {
	    	p.self.close();
	    });


        $("#searchBaseDate,#searchOrgNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
        });

		$("#chkVisualYn").change(function(){
			doAction("Search");
		});

	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			mySheet.DoSearch( "${ctx}/Popup.do?cmd=getOrgBasicGrpUserPopupList", $("#mySheetForm").serialize() );
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

	function mySheet_OnDblClick(Row, Col){
		var rv = new Array(9);
		rv["orgCd"] 	= mySheet.GetCellValue(Row, "orgCd");
		rv["orgNm"]		= mySheet.GetCellValue(Row, "orgNm");

		rv["sdate"]		= mySheet.GetCellValue(Row, "sdate");
		rv["edate"]		= mySheet.GetCellValue(Row, "edate");

		rv["orgEngNm"]		= mySheet.GetCellValue(Row, "orgEngNm");
		rv["orgType"]		= mySheet.GetCellValue(Row, "orgType");
		rv["inoutType"]		= mySheet.GetCellValue(Row, "inoutType");
		rv["objectType"]		= mySheet.GetCellValue(Row, "objectType");
		rv["locationCd"]		= mySheet.GetCellValue(Row, "locationCd");

		p.popReturnValue(rv);
		p.window.close();
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='orgSchList' mdef='조직 리스트 조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm" tabindex="1">
            <input type="hidden" id="searchEnterCd" name="searchEnterCd" />
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					<th><tit:txt mid='104352' mdef='기준일자'/></th>
                       <td> 
                            <input type="text" id="searchBaseDate" name="searchBaseDate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
                       </td>
                       <th><tit:txt mid='104514' mdef='조직명'/></th>
					   <td>  <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" /> </td>
					   <!-- <td> <th><tit:txt mid='114509' mdef='보여주기여부 '/></th> <select id="chkVisualYn" name="chkVisualYn"></td> -->
                       <td>
						<a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
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
						<li id="txt" class="txt"><tit:txt mid='orgSchList' mdef='조직 리스트 조회'/></li>
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



