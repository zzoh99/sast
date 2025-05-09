<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html>	<html class="bodywrap">	<head>
<%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		var searchSabun = "";
		var searchGrpCd = "";
		var arg = p.window.dialogArguments;

	    if( arg != undefined ) {
	    	searchSabun    = arg["searchSabun"];
	    	searchGrpCd    = arg["searchGrpCd"];
	    }else{
	    	if(p.popDialogArgument("searchSabun")!=null)		searchSabun  	= p.popDialogArgument("searchSabun");
	    	if(p.popDialogArgument("searchGrpCd")!=null)		searchGrpCd  	= p.popDialogArgument("searchGrpCd");
	    }

		$("#searchSabun").val(searchSabun);
		$("#searchGrpCd").val(searchGrpCd);

		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, ChildPage:1};
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
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='scopeValue' mdef='권한범위항목값'/>",	Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"scopeValue",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='authScopeNm_V1192' mdef='권한범위항목명'/>",	Type:"Text", 		Hidden:0,  Width:250, Align:"Center",  ColMerge:0,   SaveName:"scopeValueNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='chkV1' mdef='등록'/>",				Type:"CheckBox",  Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"chk",        		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":		sheet1.DoSearch( "${ctx}/AuthGrpUserMgr.do?cmd=getAuthGrpUserMgrScopePopupSheet1List", $("#sheetForm").serialize() ); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		}
	}
	//Example Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			//해당 권한범위의 SQL구문을 변수로 전달
			params = $("#sheetForm").serialize();
			sheet2.DoSearch( "${ctx}/AuthGrpUserMgr.do?cmd=getAuthGrpUserMgrScopePopupSheet2List", params );
			break;
		case "Save": 		for(i=1; i<=sheet2.LastRow(); i++){
						        if( sheet2.GetCellValue(i,"chk") == "1" ) {
						        	sheet2.SetCellValue(i,"sStatus", "I");
						        } else {
						        	sheet2.SetCellValue(i,"sStatus", "D");
						        }
							};
							IBS_SaveName(document.sheetForm,sheet2);
							sheet2.DoSave( "${ctx}/AuthGrpUserMgr.do?cmd=saveAuthGrpUserMgrScopePopup", $("#sheetForm").serialize()); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":	sheet2.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			$("#authScopeCd").val(sheet1.GetCellValue(NewRow, "authScopeCd"));

	    	if( sheet1.GetCellValue(NewRow, "scopeType") == "SQL" ) {
	    		doAction2("Search");
	    	}
	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( sheet1.GetCellValue(Row, "scopeType") == "PROGRAM" ) {
		    	sheet2.RemoveAll();
		    	// 프로그램 구현으로 다른 권한범위 설정이 필요한 경우 권한범위(소속) 팝업과 같이 여기에서 구현 하고  AuthTable 에도 로직이 등록 되어야 함. 2013.05.21, 최범수
		    	if( sheet1.GetCellValue(Row, "authScopeCd") == "W10" ) {
		    		authGrpUserMgrScopeOrgPopup(Row);
		    	}

		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction2("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction2("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
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
		var url 	= "${ctx}/AuthGrpUserMgr.do?cmd=viewAuthGrpUserMgrScopeOrgPopup&authPg=${authPg}";
		var args 	= new Array();
		args["searchSabun"] 	= $("#searchSabun").val();
		args["searchGrpCd"] 	= $("#searchGrpCd").val();
		args["authScopeCd"] 	= sheet1.GetCellValue(Row, "authScopeCd");

		openPopup(url,args,w,h);
	}
</script>
</head>
<body class="bodywrap">
	<form id="sheetForm" name="sheetForm">
        <input type="hidden" id="searchSabun"	name="searchSabun">
        <input type="hidden" id="searchGrpCd"	name="searchGrpCd">
        <input type="hidden" id="authScopeCd"	name="authScopeCd">
	</form>
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='authGrpUserMgrScope' mdef='사용자 권한범위 설정'/></li>
				<li	class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<colgroup>
				<col width="30%" />
				<col width="70%" />
			</colgroup>
			<tr>
				<td class="sheet_left">
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='authScopeMgrV2' mdef='권한범위'/></li>
							<li class="btn">
								<!-- <a href="javascript:doAction1('Search')" 	class="basic"><tit:txt mid='104081' mdef='조회'/></a> -->
							</li>
							<li class="btn">
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
				</td>
				<td class="sheet_right">
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='authScopeMgrV1' mdef='권한범위항목'/></li>
							<li class="btn">
								<!-- <btn:a href="javascript:doAction2('Search')" 	css="basic" mid='110697' mdef="조회"/> -->
								<btn:a href="javascript:doAction2('Save')" 	css="basic" mid='110708' mdef="저장"/>
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
			</table>
			<div class="popup_button outer">
				<ul>
					<li><btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>



