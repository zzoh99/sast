<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>요구사항관리팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

var p = eval("${popUpStatus}");

	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});


		$(".close").click(function() {
			p.self.close();
		});

//=========================================================================================================================================
		var searchEnterCd     = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionPopMgrEnterCdList&",false).codeList, "");//메뉴코드
		//var searchModuleCd    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99995"), "");//모듈코드(S99995)
		var searchModuleCd    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrModuleCdList",false).codeList, "");//모듈코드(S99995)
		var searchGrpCd       = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrGrpCdList",false).codeList, "");//메뉴코드
		var searchMainMenuCd  = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrMainMenuCdList",false).codeList, "");//메뉴코드

		$("#searchEnterCd").html(searchEnterCd[2]);
		$("#searchGrpCd").html(searchGrpCd[2]);
		$("#searchMainMenuCd").html(searchMainMenuCd[2]);
		$("#searchMainMenuCd").val('02');
//=========================================================================================================================================

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols =	[
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			//{Header:"<sht:txt mid='chk_V385' mdef='사용'/>",				Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Left", ColMerge:0,	SaveName:"chk",	    KeyField:0,	Format:"",      UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
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

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("moduleCd", 		{ComboText:"|"+searchModuleCd[0], 		ComboCode:"|"+searchModuleCd[1]} );
		sheet1.SetColProperty("type",			{ComboText:"메뉴|프로그램|조건검색|탭",	ComboCode:"M|P|S|T"} );

		$(window).smartresize(sheetResize); sheetInit();
		
		$("#btnPlus").toggleClass("minus");

		// 트리레벨 정의
		$("#btnStep1").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(1, 2);
		});
		$("#btnStep3").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(2, 3);
			/*if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				sheet1.ShowTreeLevel(-1);
			}*/
		});
		$("#btnPlus").click(function() {
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet1.ShowTreeLevel(-1):sheet1.ShowTreeLevel(0, 1);
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
						sheet1.RemoveAll();
						sheet1.DoSearch( "${ctx}/ReqDefinitionMgr.do?cmd=getReqDefinitionMgrPopList", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!dupChk(sheet1,"moduleCd|mainMenuCd|priorMenuCd|menuCd|menuSeq|grpCd", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet1);
						sheet1.DoSave( "${ctx}/ReqDefinitionMgr.do?cmd=saveReqDefinitionMgr", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
						break;
		case "Copy":
						var row = sheet1.DataCopy();
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"40"};
						sheet1.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						sheet1.LoadExcel(params);
						break;
		case "DownTemplate":
						sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"",ExcelFontSize:"9",ExcelRowHeight:"40"});
						break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col){



		var type = sheet1.GetCellValue( Row, "type" );

		if ( type == "M"){
			alert("메뉴는 선택할 수 없습니다.");
			return;
		}else{

			var rv    =   new Array(9);

			rv["mainMenuCd"]		= sheet1.GetCellValue(Row, "mainMenuCd");
			rv["priorMenuCd"]		= sheet1.GetCellValue(Row, "priorMenuCd");
			rv["priorMenuNm"]		= sheet1.GetCellValue(Row, "priorMenuNm");
			rv["menuCd"]			= sheet1.GetCellValue(Row, "menuCd");
			rv["menuSeq"]			= sheet1.GetCellValue(Row, "menuSeq");
			rv["menuNm"]			= sheet1.GetCellValue(Row, "menuNm");
			rv["prgCd"]				= sheet1.GetCellValue(Row, "prgCd");
			
			rv["languageCd"]				= sheet1.GetCellValue(Row, "languageCd");

			rv["grpCd"]				= sheet1.GetCellValue(Row, "grpCd");
			rv["moduleCd"]			= sheet1.GetCellValue(Row, "moduleCd");

			rv["enterCd"]			= sheet1.GetCellValue(Row, "enterCd");

			p.popReturnValue(rv);
			p.window.close();
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

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

	}
</script>
</head>
</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='104233' mdef='메뉴명'/>
				</li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
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
						<btn:a href="javascript:doAction1('Search');" id="btnSearch" mid="110697" mdef="조회" css="button"/>
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
								<a href="javascript:doAction1('Insert');" 			class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Copy');" 			class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction1('Save');" 			class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('Down2Excel');" 		class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction1('LoadExcel');" 		class="basic authA"><tit:txt mid='104242' mdef='업로드'/></a>
								<a href="javascript:doAction1('DownTemplate');" 	class="basic authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
