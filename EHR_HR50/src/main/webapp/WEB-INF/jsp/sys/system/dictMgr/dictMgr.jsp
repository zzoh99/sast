<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='104444' mdef='사전 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var keyLevel  = null;

	/*Sheet 기본 설정 */
	$(function() {

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo"	},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0	},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus",	Sort:0	},
			{Header:"<sht:txt mid='keyLevel' mdef='레벨'/>",	Type:"Combo",		Width:120,	Align:"Left",	SaveName:"keyLevel",	KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",	Type:"Text",		Width:120,	Align:"Left",	SaveName:"keyId",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='keyText' mdef='정의'/>",		Type:"Text",		Width:120,	Align:"Left",	SaveName:"keyText",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,EditLen:3000, MultiLineText:true},
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",		Width:200,	Align:"Left",	SaveName:"keyNote",		UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"<sht:txt mid='keyReadV1' mdef='Memory'/>",	Type:"CheckBox",	Width:50,	Align:"Center",	SaveName:"keyRead",		TrueValue:"0",	FalseValue:"1", DefaultValue:"1"},
			{Header:"tag",	Type:"Text",	Width:50,	Align:"Center",	SaveName:"tag",			KeyField:0,	UpdateEdit:0,	InsertEdit:0,EditLen:2000},
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetCountPosition(4);
		sheet1.SetEditableColorDiff(0);

		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo"	},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0	},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus",	Sort:0	},
			{Header:"<sht:txt mid='keyLevel' mdef='레벨'/>",	Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	SaveName:"keyLevel",	KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",	Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	SaveName:"keyId",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='langCd' mdef='언어'/>",		Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	SaveName:"langCd",			KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='countryCd_V303' mdef='지역'/>",		Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	SaveName:"countryCd",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='LocaleCd' mdef='Locale'/>",	Type:"Combo",		Width:120,	Align:"Center",	SaveName:"localeCd",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='keyText' mdef='정의'/>",		Type:"Text",		Width:120,	Align:"Left",	SaveName:"keyText",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,EditLen:3000, MultiLineText:true},
			{Header:"<sht:txt mid='keyReadV1' mdef='Memory'/>",	Type:"CheckBox",	Width:50,	Align:"Center",	SaveName:"keyRead",		TrueValue:"0",	FalseValue:"1", DefaultValue:"1"}
		];
		IBS_InitSheet(sheet2, initdata);
		sheet2.SetCountPosition(4);
		sheet2.SetEditableColorDiff(0);
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo"	},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0	},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus",	Sort:0	},
			{Header:"<sht:txt mid='keyLevel' mdef='레벨'/>",	Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	SaveName:"keyLevel",	KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",	Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	SaveName:"keyId",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='enterCd_V312' mdef='법인'/>",		Type:"Combo",		Width:120,	Align:"Center",	SaveName:"enterCd",			KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='langCd' mdef='언어'/>",		Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	SaveName:"langCd",			KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='countryCd_V303' mdef='지역'/>",		Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	SaveName:"countryCd",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='LocaleCd' mdef='Locale'/>",	Type:"Combo",		Width:120,	Align:"Center",	SaveName:"localeCd",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='keyText' mdef='정의'/>",		Type:"Text",		Width:120,	Align:"Left",	SaveName:"keyText",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,EditLen:3000, MultiLineText:true},
			{Header:"<sht:txt mid='keyReadV1' mdef='Memory'/>",	Type:"CheckBox",	Width:50,	Align:"Center",	SaveName:"keyRead",		TrueValue:"0",	FalseValue:"1", DefaultValue:"1"}
		];
		IBS_InitSheet(sheet3, initdata);
		sheet3.SetCountPosition(4);
		sheet3.SetEditableColorDiff(0);

		var keyLevelCode = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getKeyLevelList",false).codeList, "<sht:txt mid='check' mdef='선택'/>"); //
		var localeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocaleCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");

		//var langCd      = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L00100"), ""); //언어관리
		//var countryCd   = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLangCountryList",false).codeList, "<tit:txt mid='111914' mdef='선택'/>"); //사용언어국가선택
		var enterCd     = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getEnterList",false).codeList, "<sht:txt mid='check' mdef='선택'/>"); //사용언어국가선택

		sheet1.SetColProperty("keyLevel",{ComboText:"|" + keyLevelCode[0], ComboCode:"|"+keyLevelCode[1]});
		sheet2.SetColProperty("localeCd",      {ComboText:"|"+localeCd[0], ComboCode:"|"+localeCd[1]} ); //로케일
		sheet3.SetColProperty("localeCd",      {ComboText:"|"+localeCd[0], ComboCode:"|"+localeCd[1]} ); //로케일
		sheet3.SetColProperty("enterCd",      {ComboText:"|"+enterCd[0], ComboCode:"|"+enterCd[1]} ); //법인코드

		$("#searchkeyLevel").html(keyLevelCode[2]);

		var keyLevel = $("#searchkeyLevel").val();

		if(keyLevel != null && keyLevel != "") {
			$("#searchkeyLevel option").not("[value='" + keyLevel + "']").remove();
			doAction("Search1");
		}

		$(window).smartresize(sheetResize);
		sheetInit();

		$("#searchkeyText, #searchkeyId, #searchkeyTextLen").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search1");
				$(this).focus();
			}
		});

        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Choice":
				if(p.popReturnValue) p.popReturnValue(sheet1.GetRowData(sheet1.GetSelectRow()));
				p.self.close();
				break;
			case "Search1":
				sheet2.RemoveAll();
				sheet3.RemoveAll();

				sheet1.DoSearch("${ctx}/DictMgr.do?cmd=getDictMgrList&is=_sheet1", $("#srchFrm").serialize());
				break;
			case "Search2":
				var param = $.param(sheet1.GetRowData(sheet1.GetSelectRow()));

				sheet2.DoSearch("${ctx}/DictMgr.do?cmd=getDictMgrList&is=_sheet2", param);
				sheet3.DoSearch("${ctx}/DictMgr.do?cmd=getDictMgrList&is=_sheet3", param);

				break;
			case "Insert1":
				var row = sheet1.DataInsert(0);

				var dtSeq = ajaxCall( "${ctx}/LangId.do?cmd=getSequence","",false);
				var keyId = dtSeq.map.seqNum;

				sheet1.SetCellValue(row, "keyLevel", $("#searchkeyLevel").val());
				sheet1.SetCellValue(row, "keyId", keyId);
				sheet1.SetCellValue(row, "keyRead", 1);

				sheet1.SetRowBackColorI("#FFC296");

				break;
			case "Insert2":
				var row = sheet2.DataInsert(0);
				sheet2.SetCellValue(row, "keyLevel", sheet1.GetCellValue(sheet1.GetSelectRow(), "keyLevel"));
				sheet2.SetCellValue(row, "keyId", sheet1.GetCellValue(sheet1.GetSelectRow(), "keyId"));
				sheet2.SetCellValue(row, "keyRead", 1);

				break;
			case "Insert3":
				var row = sheet3.DataInsert(0);
				sheet3.SetCellValue(row, "keyLevel", sheet1.GetCellValue(sheet1.GetSelectRow(), "keyLevel"));
				sheet3.SetCellValue(row, "keyId", sheet1.GetCellValue(sheet1.GetSelectRow(), "keyId"));
				sheet3.SetCellValue(row, "keyRead", 1);
				break;
			case "Save1":
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/DictMgr.do?cmd=getDictMgrSave&is=_sheet1", $("#srchFrm").serialize());
				break;
			case "Save2":

				if(sheet1.IsDataModified()) {
					alert("<msg:txt mid='109448' mdef='어휘관리 부터 저장하여야 합니다.'/>");
					return;
				} else {
					IBS_SaveName(document.srchFrm,sheet2);
					sheet2.DoSave( "${ctx}/DictMgr.do?cmd=getDictMgrSave&is=_sheet2", $("#srchFrm").serialize());
				}

				break;
			case "Save3":
				if(sheet1.IsDataModified()) {
					alert("<msg:txt mid='109448' mdef='어휘관리 부터 저장하여야 합니다.'/>");
					return;
				} else {
					IBS_SaveName(document.srchFrm,sheet3);
					sheet3.DoSave( "${ctx}/DictMgr.do?cmd=getDictMgrSave&is=_sheet3", $("#srchFrm").serialize());
				}
				break;

			case "Apply":
				if(confirm("적용하시겠습니까?")){
					var	rst = ajaxCall("${ctx}/DictMgr.do?cmd=viewApplyDict","",false);
					alert(rst.Message);
				}
				break;


			case "Clear2":		//Clear
				sheet2.RemoveAll();
				break;
			case "Clear3":		//Clear
				sheet2.RemoveAll();
				break;
		}
	}

	function sheet1_OnChange(Row, Col, Value){
		sheet1.SetRowBackColorU("#FFC296");
	}


	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {

		if(sheet1.GetCellValue(NewRow,"sStatus") != 'I'){
			if(OldRow != NewRow) {
				doAction("Search2");
			}
		}
		else{
			doAction("Clear2");
			doAction("Clear3");
		}
	}

	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			doAction("Search1");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


	function sheet2_OnChange(Row, Col, Value){
		sheet2.SetRowBackColorU("#FFC296");

		if( sheet2.ColSaveName(Col) == "localeCd") {

			var strArray=(sheet2.GetCellValue(Row, "localeCd")).split('_');
			sheet2.SetCellValue(Row, "langCd", strArray[0]);
			sheet2.SetCellValue(Row, "countryCd", strArray[1]);

		}

	}


	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") {alert(Msg);}

			sheet2.SetRowBackColorI("#FFC296");
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}


	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			doAction("Search2");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet3_OnChange(Row, Col, Value){

		sheet3.SetRowBackColorU("#FFC296");
		if( sheet3.ColSaveName(Col) == "localeCd") {

			var strArray=(sheet3.GetCellValue(Row, "localeCd")).split('_');
			sheet3.SetCellValue(Row, "langCd", strArray[0]);
			sheet3.SetCellValue(Row, "countryCd", strArray[1]);

		}
	}


	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
</script>

</head>


<body class="bodywrap">
<div class="wrapper" style="margin:10px;">

	<div class="sheet_search outer">
		<div>
		<form id="srchFrm" name="srchFrm">
		<table border= 0 width=100%>
		<!--
			<colgroup>
				<col width="150px" />
				<col width="150px" />
				<col width="150px" />
				<col width="150px" />
				<col width="" />
				<col width="50px" />
			</colgroup>
	  	
			<tr>
				<td><span><sch:txt mid='keyLevel' mdef='사전레벨'/></span><select	id="searchkeyLevel" name ="searchkeyLevel"/></td>
				<td><span><sch:txt mid='keyId' mdef='어휘코드'/></span><input	id="searchkeyId" name ="searchkeyId" type="text" class="text" /></td>
				<td><span><sch:txt mid='keyText' mdef='사전의미'/></span><input id="searchkeyText" name ="searchkeyText" type="text" class="text"	/></td>
				<td><btn:a href="javascript:doAction('Search1');" id="btnSearch" mid="110697" mdef="조회" css="button"/></td>
				<td></td>
				<td rowspan=2><btn:a href="javascript:doAction('Apply');" mid="110729" mdef="적용" css="pink large"/></td>
			</tr>
			<tr>
				<td colspan="5"><span><sch:txt mid='keyTextLen' mdef='문자길이'/></span><input id="searchkeyTextLen" name ="searchkeyTextLen" type="text" class="text" /></td>
			</tr>
		-->
			<colgroup>
				<col width="50px" />
				<col width="100px" />
				<col width="50px" />
				<col width="100px" />
				<col width="50px" />
				<col width="100px" />
				<col width="50px" />
				<col width="" />
				<col width="50px" />
			</colgroup>
			<tr>
				<th><sch:txt mid='keyLevel' mdef='사전레벨'/></th>
				<td><select	id="searchkeyLevel" name ="searchkeyLevel"/></td>
				<th><sch:txt mid='keyId' mdef='어휘코드'/></th>
				<td><input	id="searchkeyId" name ="searchkeyId" type="text" class="text" /></td>
				<th><sch:txt mid='keyText' mdef='사전의미'/></th>
				<td><input id="searchkeyText" name ="searchkeyText" type="text" class="text"	/></td>
				<td><btn:a href="javascript:doAction('Search1');" id="btnSearch" mid="110697" mdef="조회" css="btn dark"/></td>
				<td></td>
				<td rowspan=2><btn:a href="javascript:doAction('Apply');" mid="110729" mdef="적용" css="btn filled authA"/></td>
			</tr>
			<tr>
				<th><sch:txt mid='keyTextLen' mdef='문자길이'/></th>
				<td><input id="searchkeyTextLen" name ="searchkeyTextLen" type="text" class="text" /></td>
			</tr>
		</table>
		</form>
		</div>
	</div>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">

	<colgroup>
		<col width="" />
		<col width="15px" />
		<col width="" />
	</colgroup>
	<tr>

		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li	id="txt"	class="txt"><tit:txt mid='WordtMgr' mdef='어휘관리'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction('Insert1');" mid="110700" mdef="입력" css="btn outline-gray authA"/>
						<btn:a href="javascript:doAction('Save1');" mid="110708" mdef="저장" css="btn filled authA"/>
					</li>
				</ul>
				</div>
			</div>
			<script	type="text/javascript">createIBSheet("sheet1","50%","100%","${ssnLocaleCd}");</script>
		</td>
		<td></td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li	id="txt" class="txt"><tit:txt mid='DictMgr' mdef='용어관리'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction('Insert2');" mid="110700" mdef="입력" css="btn outline-gray"/>
						<btn:a href="javascript:doAction('Save2');" mid="110708" mdef="저장" css="btn filled"/>
					</li>
				</ul>
				</div>
			</div>
			<div class="inner">
				<script	type="text/javascript">createIBSheet("sheet2","50%","200px","${ssnLocaleCd}");</script>
			</div>

			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li	id="txt" class="txt"><tit:txt mid='EnterDictMgr' mdef='회사별 용어 관리'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction('Insert3');" mid="110700" mdef="입력" css="btn outline-gray"/>
						<btn:a href="javascript:doAction('Save3');" mid="110708" mdef="저장" css="btn filled"/>
					</li>
				</ul>
				</div>
			</div>
			<script	type="text/javascript">createIBSheet("sheet3","50%","100%","${ssnLocaleCd}");</script>
		</td>
	</tr>
	</table>

</div>
</body>
</html>
