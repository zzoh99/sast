<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head><title>사용자권한범위관리 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p 	= eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();

	$(function(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'          mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo" },
			{Header:"<sht:txt mid='orgNmV8'      mdef='부서'/>",		Type:"Text",      	Hidden:0,  Width:100,  Align:"Left",    SaveName:"orgNm",       KeyField:0,   Format:"", UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='sabun'        mdef='사번'/>",		Type:"Text",      	Hidden:0,  Width:60,   Align:"Center",  SaveName:"sabun",       KeyField:0,   Format:"", UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='name'         mdef='성명'/>",		Type:"Text",   		Hidden:0,  Width:60,   Align:"Center",  SaveName:"name",        KeyField:0,   Format:"", UpdateEdit:0,   InsertEdit:1 },
			{Header:"<sht:txt mid='jikgubNm'     mdef='직급'/>",		Type:"Text", 		Hidden:0,  Width:60,   Align:"Center",  SaveName:"jikgubNm",    KeyField:0,   Format:"", UpdateEdit:0,   InsertEdit:0 },
			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함


		$(window).smartresize(sheetResize); sheetInit();

		$(".close").click(function() {
			p.self.close();
		});

		if( arg != "undefined" ) {
			$("#searchSabun").val(arg["searchSabun"]);
			$("#searchGrpCd").val(arg["searchGrpCd"]);
		}

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": 	 	
				sheet1.DoSearch( "${ctx}/AuthScopeUserMgr.do?cmd=getAuthScopeUserMgrPopupList", $("#sheet1Form").serialize() ); 
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='L190911000081' mdef='사용자권한범위 대상자 조회' /></li>
				<li class="close"></li>
			</ul>
		</div>

		<div class="popup_main">
			<form id="sheet1Form" name="sheet1Form">
				<input type="hidden" id="searchSabun"	name="searchSabun"	/>
				<input type="hidden" id="searchGrpCd"	name="searchGrpCd"		/>
			</form>

			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='103863' mdef='대상자' /></li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Down2Excel')" css="basic authR" mid='down2excel' mdef="다운로드"/>
						</li>
					</ul>
				</div>
			</div>

			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

			<div class="popup_button outer">
				<ul>
					<li>
						<btn:a href="javascript:p.self.close();" mid="close" mdef="닫기" css="gray large"/>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
</body>
</html>