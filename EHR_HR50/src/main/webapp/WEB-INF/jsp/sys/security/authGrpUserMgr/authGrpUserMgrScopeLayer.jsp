<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html>	<html class="bodywrap">	<head>
<%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>

<%@	include	file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var authGrpUserMgrScopeLayer = { id:'authGrpUserMgrScopeLayer' };
	$(function() {
		createIBSheet3(document.getElementById('authSheet-wrap'), "authSheet", "100%", "100%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('selectSheet-wrap'), "selectSheet", "100%", "100%", "${ssnLocaleCd}");
		const modal = window.top.document.LayerModalUtility.getModal(authGrpUserMgrScopeLayer.id);
		var { searchSabun, searchGrpCd } = modal.parameters;
		$("#searchSabun").val(searchSabun);
		$("#searchGrpCd").val(searchGrpCd);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",  ColMerge:0,   SaveName:"sabun",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 	},
			{Header:"<sht:txt mid='authScopeCdV2' mdef='권한범위코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",  ColMerge:0,   SaveName:"authScopeCd", 	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 	},
			{Header:"<sht:txt mid='authScopeNmV2' mdef='권한범위'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",  ColMerge:0,   SaveName:"authScopeNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100	},
			{Header:"<sht:txt mid='scopeTypeV1' mdef='범위적용구분'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",  ColMerge:0,   SaveName:"scopeType",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 	},
			{Header:"<sht:txt mid='prgUrl' mdef='프로그램URL'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",  ColMerge:0,   SaveName:"prgUrl",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100	},
			{Header:"<sht:txt mid='sqlSyntaxV2' mdef='SQL구문'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",  ColMerge:0,   SaveName:"sqlSyntax",   	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100	},
			{Header:"<sht:txt mid='authScopeCdV3' mdef='테이블명'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",  ColMerge:0,   SaveName:"authScopeCd",  KeyField:0,   CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
			]; IBS_InitSheet(authSheet, initdata);authSheet.SetEditable(false);authSheet.SetVisible(true);authSheet.SetCountPosition(4);

		// sheet 높이 계산
		var authSheetHeight = $(".modal_body").height() - $("#sheetForm").height() - $(".sheet_title").height() - 2;
		authSheet.SetSheetHeight(authSheetHeight);


		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='scopeValue' mdef='권한범위항목값'/>",	Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"scopeValue",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='authScopeNm_V1192' mdef='권한범위항목명'/>",	Type:"Text", 		Hidden:0,  Width:250, Align:"Center",  ColMerge:0,   SaveName:"scopeValueNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='chkV1' mdef='등록'/>",				Type:"CheckBox",  Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"chk",        		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 }
		]; IBS_InitSheet(selectSheet, initdata);selectSheet.SetEditable("${editable}");selectSheet.SetVisible(true);selectSheet.SetCountPosition(4);

		// sheet 높이 계산
		var selectSheetHeight = $(".modal_body").height() - $("#sheetForm").height() - $(".sheet_title").height() - 2;
		selectSheet.SetSheetHeight(selectSheetHeight);

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":		authSheet.DoSearch( "${ctx}/AuthGrpUserMgr.do?cmd=getAuthGrpUserMgrScopePopupSheet1List", $("#sheetForm").serialize() ); break;
		case "Down2Excel":	authSheet.Down2Excel(); break;
		}
	}
	
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			//해당 권한범위의 SQL구문을 변수로 전달
			params = $("#sheetForm").serialize();
			selectSheet.DoSearch( "${ctx}/AuthGrpUserMgr.do?cmd=getAuthGrpUserMgrScopePopupSheet2List", params );
			break;
		case "Save": 		for(i=1; i<=selectSheet.LastRow(); i++){
						        if( selectSheet.GetCellValue(i,"chk") == "1" ) {
						        	selectSheet.SetCellValue(i,"sStatus", "I");
						        } else {
						        	selectSheet.SetCellValue(i,"sStatus", "D");
						        }
							};
							IBS_SaveName(document.sheetForm,selectSheet);
							selectSheet.DoSave( "${ctx}/AuthGrpUserMgr.do?cmd=saveAuthGrpUserMgrScopePopup", $("#sheetForm").serialize()); break;
		case "Clear":		selectSheet.RemoveAll(); break;
		case "Down2Excel":	selectSheet.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; authSheet.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function authSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function authSheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			$("#authScopeCd").val(authSheet.GetCellValue(NewRow, "authScopeCd"));
	    	if( authSheet.GetCellValue(NewRow, "scopeType") == "SQL" ) {
	    		doAction2("Search");
	    	}
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	function authSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( authSheet.GetCellValue(Row, "scopeType") == "PROGRAM" ) {
		    	selectSheet.RemoveAll();
		    	// 프로그램 구현으로 다른 권한범위 설정이 필요한 경우 권한범위(소속) 팝업과 같이 여기에서 구현 하고  AuthTable 에도 로직이 등록 되어야 함. 2013.05.21, 최범수
		    	if( authSheet.GetCellValue(Row, "authScopeCd") == "W10" ) {
		    		authGrpUserMgrScopeOrgPopup(Row);
		    	}

		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function selectSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function selectSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction2("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function selectSheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction2("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && selectSheet.GetCellValue(Row, "sStatus") == "I") {
				selectSheet.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	/**
	 * 권한범위(소속) window open event
	 */
	function authGrpUserMgrScopeOrgPopup(Row){
		if(!isPopup()) {return;}
  		var w 		= 740;
		var h 		= 580;
		var url 	= "${ctx}/AuthGrpUserMgr.do?cmd=viewAuthGrpUserMgrScopeOrgLayer&authPg=${authPg}";
		var title 	= "<tit:txt mid='authGrpUserMgrScopeOrg' mdef='사용자 권한범위 설정(소속)'/>";
		var p = { searchSabun: $("#searchSabun").val(), searchGrpCd: $("#searchGrpCd").val(), authScopeCd: authSheet.GetCellValue(Row, "authScopeCd") };
		var layer = new window.top.document.LayerModal({
			id: 'authGrpUserMgrScopeOrgLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: title
		});
		layer.show();
	}
</script>
</head>
<body class="bodywrap">
	<form id="sheetForm" name="sheetForm">
        <input type="hidden" id="searchSabun"	name="searchSabun">
        <input type="hidden" id="searchGrpCd"	name="searchGrpCd">
        <input type="hidden" id="authScopeCd"	name="authScopeCd">
	</form>
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<colgroup>
				<col width="29%" />
				<col width="2%" />
				<col width="69%" />
			</colgroup>
			<tr>
				<td class="sheet_left">
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='authScopeMgrV2' mdef='권한범위'/></li>
							<li class="btn">
							</li>
							<li class="btn">
							</li>
						</ul>
						</div>
					</div>
					<div id="authSheet-wrap"></div>
					<!-- <script type="text/javascript"> createIBSheet("authSheet", "50%", "100%", "${ssnLocaleCd}"); </script> -->
				</td>
				<td></td>
				<td class="sheet_right">
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='authScopeMgrV1' mdef='권한범위항목'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction2('Save')" 	css="btn filled" mid='110708' mdef="저장"/>
							</li>
						</ul>
						</div>
					</div>
					<div id="selectSheet-wrap"></div>
					<!-- <script type="text/javascript"> createIBSheet("selectSheet", "50%", "100%", "${ssnLocaleCd}"); </script> -->
				</td>
			</tr>
				<tr>
					<td colspan="3">
						<div class="explain inner">
							* 권한범위항목을 하나도 설정하지 않을 경우 본인만 조회됩니다.<br/>
							&nbsp;&nbsp;특정 권한범위 내 모든 권한범위항목에 권한을 부여해야할 경우 <span style="color: red;">전체 선택하여 저장</span>해주시기 바랍니다.
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('authGrpUserMgrScopeLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
	</div>
</body>
</html>



