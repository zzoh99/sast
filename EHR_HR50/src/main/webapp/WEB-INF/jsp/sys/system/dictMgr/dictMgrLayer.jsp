<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='104444' mdef='사전 팝업'/></title>
<%--<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>--%>

<script type="text/javascript">
	<%--var p = eval("${popUpStatus}");--%>
	// var openSheet = null;

	var keyLevel = null;
	var keyId    = null;
	var keyText  = null;

	/*Sheet 기본 설정 */
	$(function() {
		createIBSheet3(document.getElementById('dicMgrLayerSheet1-wrap'), "dicMgrLayerSheet1", "100%", "100%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('dicMgrLayerSheet2-wrap'), "dicMgrLayerSheet2", "100%", "100%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('dicMgrLayerSheet3-wrap'), "dicMgrLayerSheet3", "100%", "100%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('dictLayer');
		keyLevel = modal.parameters.keyLevel;
		keyId    = modal.parameters.keyId;
		keyText  = modal.parameters.keyText;
	    if(keyId.length == 0){			
			if(keyText.length > 0){
				$("#searchkeyLevel").val(keyLevel);
				$("#searchkeyText").val(keyText);
				var data = ajaxCall( "${ctx}/DictMgr.do?cmd=getDictMgrList&is=_dicMgrLayerSheet1",$("#srchFrm").serialize() , false);

				if(data == null || data.DATA == ""){
					var dtSeq = ajaxCall( "${ctx}/LangId.do?cmd=getSequence", "", false);
					keyId = dtSeq.map.seqNum;
					$("#searchkeyText").val("");
				}
			}
   	
		}
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			//{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo" },
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='keyLevel' mdef='레벨'/>",	Type:"Text",		Hidden:1, Width:80,	Align:"Left",	SaveName:"keyLevel",	KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",	Type:"Text",		Width:100,	Align:"Left",	SaveName:"keyId",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"<sht:txt mid='keyText' mdef='정의'/>",		Type:"Text",		Width:120,	Align:"Left",	SaveName:"keyText",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,EditLen:3000, MultiLineText:true },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",		Width:100,	Align:"Left",	SaveName:"keyNote",		UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='keyReadV1' mdef='Memory'/>",	Type:"CheckBox",	Width:45,	Align:"Center",	SaveName:"keyRead",		TrueValue:"0",	FalseValue:"1", DefaultValue:"1" }
		];
		IBS_InitSheet(dicMgrLayerSheet1, initdata);
		dicMgrLayerSheet1.SetCountPosition(0);
		dicMgrLayerSheet1.SetEditableColorDiff(0);

		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='keyLevel' mdef='레벨'/>",	Type:"Text",		Hidden:0,	Width:55,	Align:"Center",	SaveName:"keyLevel",	KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",	Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	SaveName:"keyId",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"<sht:txt mid='langCd' mdef='언어'/>",		Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	SaveName:"langCd",			KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"<sht:txt mid='countryCd_V303' mdef='지역'/>",		Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	SaveName:"countryCd",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"Locale",	Type:"Combo",		Width:80,	Align:"Center",	SaveName:"localeCd",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"<sht:txt mid='keyText' mdef='정의'/>",		Type:"Text",		Width:120,	Align:"Left",	SaveName:"keyText",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,EditLen:3000, MultiLineText:true },
			{Header:"<sht:txt mid='keyReadV1' mdef='Memory'/>",	Type:"CheckBox",	Width:50,	Align:"Center",	SaveName:"keyRead",		TrueValue:"0",	FalseValue:"1", DefaultValue:"1" }
		];
		IBS_InitSheet(dicMgrLayerSheet2, initdata);
		dicMgrLayerSheet2.SetCountPosition(0);
		dicMgrLayerSheet2.SetEditableColorDiff(0);
		dicMgrLayerSheet2.SetSheetHeight(139);

		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='keyLevel' mdef='레벨'/>",	Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	SaveName:"keyLevel",	KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",	Type:"Text",		Hidden:1,	Width:120,	Align:"Left",	SaveName:"keyId",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },

			{Header:"<sht:txt mid='enterCd_V312' mdef='법인'/>",		Type:"Combo",		Width:120,	Align:"Center",	SaveName:"enterCd",			KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"<sht:txt mid='langCd' mdef='언어'/>",		Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	SaveName:"langCd",			KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"<sht:txt mid='countryCd_V303' mdef='지역'/>",		Type:"Text",		Hidden:1,	Width:120,	Align:"Center",	SaveName:"countryCd",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },
			{Header:"Locale",	Type:"Combo",		Width:120,	Align:"Center",	SaveName:"localeCd",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,EditLen:100 },

			{Header:"<sht:txt mid='keyText' mdef='정의'/>",		Type:"Text",		Width:120,	Align:"Left",	SaveName:"keyText",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,EditLen:3000, MultiLineText:true },
			{Header:"<sht:txt mid='keyReadV1' mdef='Memory'/>",	Type:"CheckBox",	Width:50,	Align:"Center",	SaveName:"keyRead",		TrueValue:"0",	FalseValue:"1", DefaultValue:"1" }
		];
		IBS_InitSheet(dicMgrLayerSheet3, initdata);
		dicMgrLayerSheet3.SetCountPosition(0);
		dicMgrLayerSheet3.SetEditableColorDiff(0);
		dicMgrLayerSheet3.SetSheetHeight(140);

		var localeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getLocaleCdList", false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		var enterCd  = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getEnterList", false).codeList, "<tit:txt mid='111914' mdef='선택'/>"); //사용언어국가선택

		dicMgrLayerSheet2.SetColProperty("localeCd", {ComboText:"|"+localeCd[0], ComboCode:"|"+localeCd[1]} ); //로케일

		dicMgrLayerSheet3.SetColProperty("localeCd", {ComboText:"|"+localeCd[0], ComboCode:"|"+localeCd[1]} ); //로케일
		dicMgrLayerSheet3.SetColProperty("enterCd", {ComboText:"|"+enterCd[0], ComboCode:"|"+enterCd[1]} ); //법인코드
		$("#searchkeyLevel").val(keyLevel);
		$("#searchkeyId").val(keyId);

		if(keyLevel != null && keyLevel != ""){
			doAction("Search1");
		}
		//sheetInit();

		$("#searchkeyText").bind("keyup",function(event){
			if (event.keyCode == 13) {
				doAction("Search1");
			}
		});

		// $(".close").click(function() {
		// 	p.self.close();
		// });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		const modal = window.top.document.LayerModalUtility.getModal('dictLayer');
		switch (sAction) {
			case "Choice":
				if( dicMgrLayerSheet1.RowCount("I") > 0 || dicMgrLayerSheet1.RowCount("U") > 0 || dicMgrLayerSheet1.RowCount("D") > 0 ||
					dicMgrLayerSheet2.RowCount("I") > 0 || dicMgrLayerSheet2.RowCount("U") > 0 || dicMgrLayerSheet2.RowCount("D") > 0) {
					alert("저장되지 않은 어휘가 있습니다.")
					break;
				}

				// if(p.popReturnValue) p.popReturnValue(dicMgrLayerSheet1.GetRowData(dicMgrLayerSheet1.GetSelectRow()));
				// p.self.close();
				modal.fire('dictTrigger', dicMgrLayerSheet1.GetRowData(dicMgrLayerSheet1.GetSelectRow())).hide();
				break;

			case "Clear": // 어휘코드명 초기화
				// if(p.popReturnValue) p.popReturnValue({"keyId": ""});
				// p.self.close();
				modal.fire('dictTrigger', {'keyId' : ''}).hide();
				break;

			case "Search1":
				dicMgrLayerSheet2.RemoveAll();
				dicMgrLayerSheet3.RemoveAll();

				dicMgrLayerSheet1.DoSearch("${ctx}/DictMgr.do?cmd=getDictMgrList&is=_dicMgrLayerSheet1", $("#srchFrm").serialize());
				break;

			case "Search2":
				var param = $.param(dicMgrLayerSheet1.GetRowData(dicMgrLayerSheet1.GetSelectRow()));

				dicMgrLayerSheet2.DoSearch("${ctx}/DictMgr.do?cmd=getDictMgrList&is=_dicMgrLayerSheet2", param);
				dicMgrLayerSheet3.DoSearch("${ctx}/DictMgr.do?cmd=getDictMgrList&is=_dicMgrLayerSheet3", param);
				break;

			case "Insert1":
				var row = dicMgrLayerSheet1.DataInsert(0);
				
				var dtSeq = ajaxCall( "${ctx}/LangId.do?cmd=getSequence","",false);
				var keyId = dtSeq.map.seqNum;
							
				dicMgrLayerSheet1.SetCellValue(row, "keyLevel",keyLevel);
				dicMgrLayerSheet1.SetCellValue(row, "keyId",   keyId);
				dicMgrLayerSheet1.SetCellValue(row, "keyText", keyText);
				dicMgrLayerSheet1.SetCellValue(row, "keyRead", 1);
				break;

			case "Insert2":
				var row = dicMgrLayerSheet2.DataInsert(0);
				if(dicMgrLayerSheet1.GetCellValue(row, "sStatus") != "R"){ alert("어휘정의를 저장후 수정하세요"); return; }
				dicMgrLayerSheet2.SetCellValue(row, "keyLevel", dicMgrLayerSheet1.GetCellValue(dicMgrLayerSheet1.GetSelectRow(), "keyLevel"));
				dicMgrLayerSheet2.SetCellValue(row, "keyId", dicMgrLayerSheet1.GetCellValue(dicMgrLayerSheet1.GetSelectRow(), "keyId"));
				break;

			case "Insert3":

				var row = dicMgrLayerSheet3.DataInsert(0);
				dicMgrLayerSheet3.SetRowBackColorI("#FFC296");
				if(dicMgrLayerSheet1.GetCellValue(row, "sStatus") != "R"){alert("어휘정의를 저장후 선택하세요");return;}
				dicMgrLayerSheet3.SetCellValue(row, "keyLevel", dicMgrLayerSheet1.GetCellValue(dicMgrLayerSheet1.GetSelectRow(), "keyLevel"));
				dicMgrLayerSheet3.SetCellValue(row, "keyId", dicMgrLayerSheet1.GetCellValue(dicMgrLayerSheet1.GetSelectRow(), "keyId"));

				break;

			case "Save1":
				IBS_SaveName(document.srchFrm,dicMgrLayerSheet1);
				dicMgrLayerSheet1.DoSave( "${ctx}/DictMgr.do?cmd=getDictMgrSave&is=_dicMgrLayerSheet1", $("#srchFrm").serialize());
				break;

			case "Save2":
				if(dicMgrLayerSheet1.IsDataModified()) {
					alert("<msg:txt mid='109448' mdef='어휘관리 부터 저장하여야 합니다.'/>");
					return;
				} else {
					IBS_SaveName(document.srchFrm,dicMgrLayerSheet2);
					dicMgrLayerSheet2.DoSave( "${ctx}/DictMgr.do?cmd=getDictMgrSave&is=_dicMgrLayerSheet2", $("#srchFrm").serialize());
				}

				break;

			case "Save3":
				if(dicMgrLayerSheet1.IsDataModified()) {
					alert("<msg:txt mid='109448' mdef='어휘관리 부터 저장하여야 합니다.'/>");
					return;
				} else {
					IBS_SaveName(document.srchFrm,dicMgrLayerSheet3);
					dicMgrLayerSheet3.DoSave( "${ctx}/DictMgr.do?cmd=getDictMgrSave&is=_dicMgrLayerSheet3", $("#srchFrm").serialize());
				}
				break;
		}
	}


	// 조회 후 에러 메시지
	function dicMgrLayerSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") {alert(Msg);}
			
			if(dicMgrLayerSheet1.RowCount() == 0  && $("#searchkeyText").val() == ""){
				//doAction("Insert1");
				
				var row = dicMgrLayerSheet1.DataInsert(0);
				var keyId = $("#searchkeyId").val();
				
				dicMgrLayerSheet1.SetCellValue(row, "keyLevel",keyLevel);
				dicMgrLayerSheet1.SetCellValue(row, "keyId",   keyId);
				dicMgrLayerSheet1.SetCellValue(row, "keyText", keyText);
				dicMgrLayerSheet1.SetCellValue(row, "keyRead", 1);
			} 
		
			//dicMgrLayerSheet2에 수정사항이 없으면 /.
			if( dicMgrLayerSheet2.RowCount("I") == 0 || dicMgrLayerSheet2.RowCount("U") == 0 || dicMgrLayerSheet2.RowCount("D") == 0){
				doAction("Search2");
			}

			dicMgrLayerSheet1.SetRowBackColorI("#FFC296");
			//sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function dicMgrLayerSheet1_OnChange(Row, Col, Value){
		dicMgrLayerSheet1.SetRowBackColorU("#FFC296");
	}

	function dicMgrLayerSheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {

		if(dicMgrLayerSheet1.GetCellValue(NewRow,"sStatus") != 'I'){
			if(OldRow != NewRow) {
				doAction("Search2");
			}
		} else {
			doAction("Clear2");
			doAction("Clear3");
		}
	}

	function dicMgrLayerSheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			//dicMgrLayerSheet2에 수정사항이 없으면 /.
			doAction("Search1");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function dicMgrLayerSheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") {alert(Msg);}
			dicMgrLayerSheet2.SetRowBackColorI("#FFC296");
			//sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function dicMgrLayerSheet2_OnChange(Row, Col, Value){
		dicMgrLayerSheet2.SetRowBackColorU("#FFC296");
	}

	function dicMgrLayerSheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			doAction("Search2");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function dicMgrLayerSheet3_OnChange(Row, Col, Value){

		dicMgrLayerSheet3.SetRowBackColorU("#FFC296");
		if( dicMgrLayerSheet3.ColSaveName(Col) == "localeCd") {
			var strArray=(dicMgrLayerSheet3.GetCellValue(Row, "localeCd")).split('_');
			dicMgrLayerSheet3.SetCellValue(Row, "langCd", strArray[0]);
			dicMgrLayerSheet3.SetCellValue(Row, "countryCd", strArray[1]);
		}
	}

	function dicMgrLayerSheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
</script>

</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="srchFrm" name="srchFrm">
				<div class="sheet_search outer">
					<div>
						<table>
							<tr>
								<th class="hide"><sch:txt mid='keyLevel' mdef='어휘레벨'/></th>
								<td class="hide">
									<input id="searchkeyLevel" name ="searchkeyLevel" type="text" class="text" />
								</td>
								<th><sch:txt mid='keyId' mdef='어휘코드'/></th>
								<td>
									<input id="searchkeyId" name ="searchkeyId" type="text" class="text" />
								</td>
								<th><sch:txt mid='keyText' mdef='사전의미'/></th>
								<td>
									<input id="searchkeyText" name ="searchkeyText" type="text" class="text" style="ime-mode:active;" />
								</td>
								<td>
									<btn:a href="javascript:doAction('Search1');" id="btnSearch" mid="search" mdef="조회" css="button" />
								</td>
							</tr>
							<tr>
								<th><sch:txt mid='keyTextLen' mdef='어휘길이'/></th>
								<td colspan="4">
									<input id="searchkeyTextLen" name ="searchkeyTextLen" type="text" class="text" />
								</td>
							</tr>
						</table>
					</div>
				</div>
			</form>

			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<colgroup>
					<col width="50%" />
					<col width="50%" />
				</colgroup>
				<tr>
					<td rowspan="2" class="sheet_left">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">어휘정의</li>
									<li class="btn">
									<!--
										<btn:a href="javascript:doAction('Choice');" mid="choice" mdef="선택" css="basic"/>
										<btn:a href="javascript:doAction('Insert1');" mid="110700" mdef="입력" css="basic"/>
									 -->
										<btn:a href="javascript:doAction('Insert1');" mid="insert" mdef="입력" css="basic" />
										<btn:a href="javascript:doAction('Save1');" mid="save" mdef="저장" css="basic" />
									</li>
								</ul>
							</div>
						</div>
						<div id="dicMgrLayerSheet1-wrap"></div>
<%--						<script type="text/javascript">createIBSheet("dicMgrLayerSheet1", "50%", "100%", "${ssnLocaleCd}");</script>--%>
					</td>

					<td class="sheet_right">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">Locale 어휘정의 </li>
									<li class="btn">
										<!--
										<btn:a href="javascript:doAction('Insert2');" mid="110700" mdef="입력" css="basic"/>
										 -->
										<btn:a href="javascript:doAction('Save2');" mid="save" mdef="저장" css="basic" />
									</li>
								</ul>
							</div>
						</div>
						<div id="dicMgrLayerSheet2-wrap" style="height: 120px;"></div>
<%--						<script type="text/javascript">createIBSheet("dicMgrLayerSheet2", "50%", "50%", "${ssnLocaleCd}");</script>--%>
					</td>
				</tr>

				<tr>
					<td class="sheet_right">
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt"><tit:txt mid='EnterDictMgr' mdef='회사별 어휘 정의' /></li>
									<li class="btn">
										<btn:a href="javascript:doAction('Insert3');" mid="insert" mdef="입력" css="basic" />
										<btn:a href="javascript:doAction('Save3');" mid="save" mdef="저장" css="basic" />
									</li>
								</ul>
							</div>
						</div>
						<div id="dicMgrLayerSheet3-wrap" style="height: 120px;"></div>
<%--						<script type="text/javascript">createIBSheet("dicMgrLayerSheet3", "50%", "50%", "${ssnLocaleCd}");</script>--%>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('dictLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
			<a href="javascript:doAction('Clear')" class="btn outline_gray"><msg:txt mid='2018080300046' mdef='어휘코드명 초기화' /></a>
			<a href="javascript:doAction('Choice');" class="btn filled"><tit:txt mid='113749' mdef='적용'/></a>
		</div>
	</div>
</body>
</html>
