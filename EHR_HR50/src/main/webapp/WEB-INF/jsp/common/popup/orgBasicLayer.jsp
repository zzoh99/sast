<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='orgSchList' mdef='조직 리스트 조회'/></title>

<script type="text/javascript">
	var multiSelect = "N";
	var chooseOrgCds = "";

	$(function() {
		$("#chkVisualYn").html("<option value=''>전체</option> <option value='Y'>사용</option> <option value='N'>사용안함</option>"); // 보여주기여부

		var enterCd = "";
		var chkVisualYn	= "";

		const modal = window.top.document.LayerModalUtility.getModal('orgLayer');
		if(modal.parameters && modal.parameters.multiSelect) multiSelect = modal.parameters.multiSelect;
		if(modal.parameters && modal.parameters.baseDate) $("#searchBaseDate").val(modal.parameters.baseDate);
		if(modal.parameters && modal.parameters.enterCd) $("#searchEnterCd").val(modal.parameters.enterCd);
		if(modal.parameters && modal.parameters.chooseOrgCds) chooseOrgCds = modal.parameters.chooseOrgCds;

		// var arg = p.popDialogArgumentAll();
		// if( arg != undefined ) {
		//
		// 	enterCd    = arg["enterCd"];
		// 	chkVisualYn= arg["chkVisualYn"];
		//
		//
		// 	if (chkVisualYn != null && chkVisualYn != "") {
		// 		$("#chkVisualYn").val(chkVisualYn);
		// 	}
		//
		// 	if( arg["multiSelect"] != null && arg["multiSelect"] != undefined ) {
		// 		multiSelect = arg["multiSelect"];
		// 	}
		// 	if( arg["chooseOrgCds"] != null && arg["chooseOrgCds"] != undefined ) {
		// 		chooseOrgCds = arg["chooseOrgCds"];
		// 	}
		// 	if( arg["baseDate"] != null && arg["baseDate"] != undefined ) {
		// 		$("#searchBaseDate").val(arg["baseDate"]);
		// 	}
		// 	if( arg["searchOrgNm"] != null && arg["searchOrgNm"] != undefined ) {
		// 		$("#searchOrgNm").val(arg["searchOrgNm"]);
		// 	}
		// }

		//$("#searchEnterCd").val(dialogArguments["enterCd"]) ;
		
		var chooseCheckHidden = (multiSelect == "Y") ? 0 : 1;
		if(multiSelect == "Y") {
			$("#btn_complete").show();
		} else {
			$("#btn_complete").hide();
		}

		createIBSheet3(document.getElementById('mySheet-wrap'), "mySheet", "100%", "100%", "${ssnLocaleCd}");

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), 	Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:1,	Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:1,	Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" },
				{Header:"선택", Type:"DummyCheck",	Hidden:chooseCheckHidden,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chooseYn",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
				{Header:"<sht:txt mid='orgSchemeUseYn' mdef='현조직도\n사용여부'/>", 	Type:"CheckBox",  Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgSchemeUseYn",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1,	TrueValue:"1", FalseValue:"0" },
				{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",      Type:"Text",      Hidden:0,  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"orgCd",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",        Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
				{Header:"<sht:txt mid='orgFullNm' mdef='조직명(FULL)'/>",  Type:"Text",      Hidden:1,  Width:180,  Align:"Left",    ColMerge:0,   SaveName:"orgFullNm",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"<sht:txt mid='orgEngNm' mdef='조직명(영문)'/>",  Type:"Text",      Hidden:1,  Width:150,    Align:"Left",    ColMerge:0,   SaveName:"orgEngNm",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"<sht:txt mid='orgType' mdef='조직유형'/>",      Type:"Combo",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgType",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='inoutType' mdef='내외구분'/>",          Type:"Combo",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"inoutType",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
				{Header:"<sht:txt mid='inoutTypeV2' mdef='조직구분'/>",          Type:"Combo",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"objectType",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
				{Header:"<sht:txt mid='telNoV2' mdef='대표전화번호'/>",  Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"telNo",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
				{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",      Type:"Text",      Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"sdate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",      Type:"Text",      Hidden:0,  Width:80,    Align:"Center",  ColMerge:0,   SaveName:"edate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='coTelNo' mdef='내선번호'/>",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"coTelNo",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
				{Header:"<sht:txt mid='locationCdV3' mdef='LOCATION'/>",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"locationCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:7 },
				{Header:"<sht:txt mid='mission' mdef='조직목적'/>",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"mission",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
				{Header:"<sht:txt mid='roleMemo' mdef='조직역할'/>",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"roleMemo",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
				{Header:"<sht:txt mid='keyJobMemo' mdef='조직KEYJOB'/>",    Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"keyJobMemo",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
				{Header:"<sht:txt mid='deptchiefreg' mdef='부서장등록'/>",    Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"deptchiefreg", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"<sht:txt mid='chiefSabun' mdef='부서장사번'/>",    Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chiefSabun", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"<sht:txt mid='chiefName' mdef='부서장성명'/>",    Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chiefName", vKeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		];
		IBS_InitSheet(mySheet, initdata);

		mySheet.SetCountPosition(4);
		
		var orgType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20010"), "");	//조직유형
		var inoutType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20050"), "");	//내외구분
		var objectType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W20030"), "");	//조직구분
		
		mySheet.SetColProperty("orgType", 			{ComboText:"|"+orgType[0], ComboCode:"|"+orgType[1]} );	//조직유형
		mySheet.SetColProperty("inoutType", 		{ComboText:"|"+inoutType[0], ComboCode:"|"+inoutType[1]} );	//내외구분
		mySheet.SetColProperty("objectType", 		{ComboText:"|"+objectType[0], ComboCode:"|"+objectType[1]} );	//조직구분

	    $(window).smartresize(sheetResize); 
	    sheetInit();
		$("#searchBaseDate").datepicker2();
	    doActionOrg("Search");

        $("#searchBaseDate,#searchOrgNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doActionOrg("Search"); $(this).focus(); }
        });

		$("#chkVisualYn").change(function(){
			doActionOrg("Search");
		});

	});

	/*Sheet Action*/
	function doActionOrg(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			// if ($("#searchOrgSchemeUseYn").is(":checked")) {
			// 	$("#searchOrgSchemeUse").val("1");
			// }else{
			// 	$("#searchOrgSchemeUse").val("");
			// }
		
			mySheet.DoSearch( "${ctx}/Popup.do?cmd=getOrgBasicPopupList", $("#mySheetForm").serialize() );
			break;
		}
    }

	// 	조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
			var rowCnt = mySheet.RowCount();
			//부모창에서 검색값이 넘어와서 값이 1개면 바로 등록되게 추가작업
			if(rowCnt == 1 ){
				mySheet_OnDblClick(1, "");
				return;
			}
			
			if(multiSelect == "Y" && chooseOrgCds != null && chooseOrgCds != "" && chooseOrgCds != undefined ) {
				var checkOrgCds = "|" + chooseOrgCds.replace(/,/g, "|") + "|";
				for(var Row = 1; Row <= mySheet.RowCount(); Row++) {
					if( checkOrgCds.indexOf( "|" + mySheet.GetCellValue(Row, "orgCd") + "|") > -1 && mySheet.GetCellValue(Row, "orgSchemeUseYn") == "1" ) {
						mySheet.SetCellValue(Row, "chooseYn", "Y");
					} else {
						mySheet.SetCellValue(Row, "chooseYn", "N");
					}
				}
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function mySheet_OnDblClick(Row, Col){
		if(multiSelect !== 'N') return;

		const modal = window.top.document.LayerModalUtility.getModal('orgLayer');
		modal.fire('orgTrigger', [{
			orgCd : mySheet.GetCellValue(Row, "orgCd")
			, orgNm : mySheet.GetCellValue(Row, "orgNm")
			, sdate : mySheet.GetCellValue(Row, "sdate")
			, edate : mySheet.GetCellValue(Row, "edate")
			, orgEngNm : mySheet.GetCellValue(Row, "orgEngNm")
			, orgType : mySheet.GetCellValue(Row, "orgType")
			, inoutType : mySheet.GetCellValue(Row, "inoutType")
			, objectType : mySheet.GetCellValue(Row, "objectType")
			, locationCd : mySheet.GetCellValue(Row, "locationCd")
			, chiefSabun : mySheet.GetCellValue(Row, "chiefSabun")
			, chiefName : mySheet.GetCellValue(Row, "chiefName")
		}]).hide();
	}
	
	function setValue1() {
		if(multiSelect !== 'Y') return;
		const modal = window.top.document.LayerModalUtility.getModal('orgLayer');
		let result = [];
		for(var Row = 1; Row <= mySheet.RowCount(); Row++) {
			if( mySheet.GetCellValue(Row, "chooseYn") == "Y" ) {
				result.push({
					"orgCd"	  : mySheet.GetCellValue(Row, "orgCd")
					, "orgNm"	  : mySheet.GetCellValue(Row, "orgNm")
				});
			}
		}
		modal.fire('orgTrigger', result).hide();
	}
</script>

</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
        <div class="modal_body">
			<form id="mySheetForm" name="mySheetForm" tabindex="1">
				<input type="hidden" id="searchEnterCd" name="searchEnterCd" />
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='104352' mdef='기준일자'/></th>
						<td>
							<input type="text" id="searchBaseDate" name="searchBaseDate" class="date2" value="<%= DateUtil.getCurrentTime("yyyy-MM-dd") %>"/>
						</td>
						<th><tit:txt mid='104514' mdef='조직명'/></th>
						<td>  <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" /> </td>
						<!-- <td> <th><tit:txt mid='114509' mdef='보여주기여부 '/></th> <select id="chkVisualYn" name="chkVisualYn"></td> -->
						<th>현조직도사용여부</th>
						<td>
							<input id="searchOrgSchemeUseYn" name="searchOrgSchemeUseYn" type="checkbox" class="checkbox" value="Y"/>
						</td>
						<td>
						<btn:a href="javascript:doActionOrg('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
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
						<div id="mySheet-wrap"></div>
	<%--				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
					</td>
				</tr>
			</table>
		</div>

		<div class="modal_footer">
			<a href="javascript:setValue1();" id="btn_complete" class="button large">선택완료</a>
			<btn:a href="javascript:closeCommonLayer('orgLayer');" css="gray large" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>



