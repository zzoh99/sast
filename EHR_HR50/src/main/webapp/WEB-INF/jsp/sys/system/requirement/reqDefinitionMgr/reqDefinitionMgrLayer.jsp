<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>요구사항관리팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->


<script type="text/javascript">
	var reqDefinitionMgrLayer = { id: 'reqDefinitionMgrLayer' };

	$(function() {
		createIBSheet3(document.getElementById('menusheet_wrap'), "menusheet", "100%", "100%", "${ssnLocaleCd}");
		$("input[type='text']").keydown(function(event){ if(event.keyCode == 27){ return false; } });
//=========================================================================================================================================
		var searchEnterCd     = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionPopMgrEnterCdList&",false).codeList, "");//메뉴코드
		var searchModuleCd    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrModuleCdList",false).codeList, "");//모듈코드(S99995)
		var searchGrpCd       = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrGrpCdList",false).codeList, "");//메뉴코드
		var searchMainMenuCd  = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrMainMenuCdList",false).codeList, "");//메뉴코드

		$("#searchEnterCd").html(searchEnterCd[2]);
		$("#searchEnterCd").val("${ssnEnterCd	}");
		$("#searchGrpCd").html(searchGrpCd[2]);
		$("#searchMainMenuCd").html(searchMainMenuCd[2]);
		$("#searchMainMenuCd").val('02');
//=========================================================================================================================================

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols =	[
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='useYnV3' mdef='사용\n여부'/>",			Type:"CheckBox",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='tmpUseYn' mdef='사용여부'/>",				Type:"DummyCheck",	Hidden:1,	Width:50,	Align:"Left", ColMerge:0,	SaveName:"tmpUseYn",	KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='mainMenuCd' mdef='메인메뉴코드'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	    ColMerge:0,	SaveName:"mainMenuCd",	KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='priorMenuCd' mdef='상위메뉴'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	    ColMerge:0,	SaveName:"priorMenuCd",	KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"상위메뉴명",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	    ColMerge:0,	SaveName:"priorMenuNm",	KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='menuCd' mdef='메뉴'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	    ColMerge:0,	SaveName:"menuCd",		KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	    ColMerge:0,	SaveName:"menuSeq",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	    ColMerge:0,	SaveName:"grpCd",		KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='menuCd' mdef='메뉴'/>",				Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",		ColMerge:0,	SaveName:"moduleCd",	KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"languageCd",				Type:"Text",	Hidden:1,	Width:70,	Align:"Center",		ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",					Type:"Combo",	Hidden:0,	Width:70,	Align:"Center",		ColMerge:0,	SaveName:"type",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='koKrV5' mdef='메뉴/프로그램명'/>",			Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	    ColMerge:0,	SaveName:"menuNm",		KeyField:1,	Format:"",	UpdateEdit:1,	InsertEdit:0,	EditLen:100, TreeCol:1	},
			{Header:"<sht:txt mid='prgCdV2' mdef='프로그램'/>",				Type:"Text",	Hidden:1,	Width:250,	Align:"Left",	    ColMerge:0,	SaveName:"prgCd",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='enterCd_V6917' mdef='회사코드'/>",												Type:"Text",	Hidden:1,	Width:150,	Align:"Center",		ColMerge:0,	SaveName:"enterCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }

		]; IBS_InitSheet(menusheet, initdata1);menusheet.SetEditable(0);menusheet.SetVisible(true);menusheet.SetCountPosition(4);

		menusheet.SetColProperty("moduleCd", 		{ComboText:"|"+searchModuleCd[0], 		ComboCode:"|"+searchModuleCd[1]} );
		menusheet.SetColProperty("type",			{ComboText:"메뉴|프로그램|조건검색|탭",	ComboCode:"M|P|S|T"} );

		$(window).smartresize(sheetResize); sheetInit();
		
		$("#btnPlus").toggleClass("minus");

		// 트리레벨 정의
		$("#btnStep1").click(function()	{
			$("#btnPlus").removeClass("minus");
			menusheet.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			$("#btnPlus").removeClass("minus");
			menusheet.ShowTreeLevel(1, 2);
		});
		$("#btnStep3").click(function()	{
			$("#btnPlus").removeClass("minus");
			menusheet.ShowTreeLevel(2, 3);
		});
		
		$("#btnPlus").click(function() {
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?menusheet.ShowTreeLevel(-1):menusheet.ShowTreeLevel(0, 1);
		});
		
		doAction1("Search");

		$("#searchMenuNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if(!checkList()) return ;
						menusheet.RemoveAll();
						menusheet.DoSearch( "${ctx}/ReqDefinitionMgr.do?cmd=getReqDefinitionMgrPopList", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!dupChk(menusheet,"moduleCd|mainMenuCd|priorMenuCd|menuCd|menuSeq|grpCd", true, true)){break;}
						IBS_SaveName(document.sendForm,menusheet);
						menusheet.DoSave( "${ctx}/ReqDefinitionMgr.do?cmd=saveReqDefinitionMgr", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = menusheet.DataInsert(0);
						break;
		case "Copy":
						var row = menusheet.DataCopy();
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(menusheet);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"40"};
						menusheet.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						menusheet.LoadExcel(params);
						break;
		case "DownTemplate":
						menusheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"",ExcelFontSize:"9",ExcelRowHeight:"40"});
						break;
		}
	}

	// 조회 후 에러 메시지
	function menusheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function menusheet_OnDblClick(Row, Col){
		var type = menusheet.GetCellValue( Row, "type" );
		if ( type == "M"){
			alert("메뉴는 선택할 수 없습니다.");
			return;
		} else {
			const p = { mainMenuCd		: menusheet.GetCellValue(Row, "mainMenuCd"),
						priorMenuCd		: menusheet.GetCellValue(Row, "priorMenuCd"),
						priorMenuNm		: menusheet.GetCellValue(Row, "priorMenuNm"),
						menuCd			: menusheet.GetCellValue(Row, "menuCd"),
						menuSeq			: menusheet.GetCellValue(Row, "menuSeq"),
						menuNm			: menusheet.GetCellValue(Row, "menuNm"),
						prgCd			: menusheet.GetCellValue(Row, "prgCd"),
						languageCd		: menusheet.GetCellValue(Row, "languageCd"),
						grpCd			: menusheet.GetCellValue(Row, "grpCd"),
						moduleCd		: menusheet.GetCellValue(Row, "moduleCd"),
						enterCd			: menusheet.GetCellValue(Row, "enterCd") };
			const modal = window.top.document.LayerModalUtility.getModal(reqDefinitionMgrLayer.id);
			modal.fire(reqDefinitionMgrLayer.id + 'Trigger', p).hide();
		}

	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getMonthEndDate(year, month) {
		var dt = new Date(year, month, 0);
		return dt.getDate();
	}
</script>
</head>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
        <div class="modal_body">
			<form id="sendForm" name="sendForm" tabindex="1">
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<td class="${ ssnErrorAdminYn eq 'Y' ? 'show' : 'hide' }">
							<span><tit:txt mid='104371' mdef='회사명'/></span>
							<select id="searchEnterCd" name="searchEnterCd" class="box" onchange="javascript:doAction1('Search');"></select>
						</td>
						<td>
							<span>모듈</span>
							<select id="searchMainMenuCd" name="searchMainMenuCd" class="box" onchange="javascript:doAction1('Search');"></select>
						</td>
						<td>
							<span>권한</span>
							<select id="searchGrpCd" name="searchGrpCd" onchange="javascript:doAction1('Search');"></select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" id="btnSearch" mid="110697" mdef="조회" css="btn dark"/>
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
								<li class="txt"><tit:txt mid='104233' mdef='메뉴명'/>
								&nbsp;
									<div class="util">
									<ul>
										<li	id="btnPlus"></li>
										<li	id="btnStep1"></li>
										<li	id="btnStep2"></li>
										<li	id="btnStep3"></li>
									</ul>
									</div>
								</li>
								<li class="btn">
									<a href="javascript:doAction1('Down2Excel');" 		class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
									<a href="javascript:doAction1('DownTemplate');" 	class="btn outline-gray authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
									<a href="javascript:doAction1('LoadExcel');" 		class="btn outline-gray authA"><tit:txt mid='104242' mdef='업로드'/></a>
									<a href="javascript:doAction1('Insert');" 			class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
									<a href="javascript:doAction1('Copy');" 			class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
									<a href="javascript:doAction1('Save');" 			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
								</li>
							</ul>
						</div>
					</div>
					<div id="menusheet_wrap"></div>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('reqDefinitionMgrLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
</div>
</body>
</html>
