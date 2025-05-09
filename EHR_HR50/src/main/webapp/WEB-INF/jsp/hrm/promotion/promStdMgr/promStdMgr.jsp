<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='114098' mdef='승진기준관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='pmtCd' mdef='승진대상자명부코드'/>",	Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"pmtCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:15 },
			{Header:"<sht:txt mid='pmtNm' mdef='승진대상자명부명'/>",	Type:"Text",		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"pmtNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"승진대상년도",									Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"pmtYyyy",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4,	AcceptKeys:"N" },
			{Header:"<sht:txt mid='sdateV13' mdef='기준일'/>",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"baseYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='tarWorkType' mdef='대상직군'/>",	Type:"Combo",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"tarWorkType",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"평가적용여부",									Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"papYn",		KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	FalseValue:"N", TrueValue:"Y"},
			{Header:"포상가점\n적용여부",									Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"prizeYn",		KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	FalseValue:"N", TrueValue:"Y"},
			{Header:"징계감점\n적용여부",									Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center", ColMerge:0, SaveName:"punishYn",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	FalseValue:"N", TrueValue:"Y"},
			{Header:"자격증가점\n적용여부",									Type:"CheckBox",	Hidden:1,	Width:50,	Align:"Center", ColMerge:0, SaveName:"licenseYn",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	FalseValue:"N", TrueValue:"Y"},
			{Header:"근태감점\n적용여부",									Type:"CheckBox",	Hidden:1,	Width:50,	Align:"Center", ColMerge:0, SaveName:"timYn",		KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10,	FalseValue:"N", TrueValue:"Y"},
			{Header:"<sht:txt mid='sawonCnt' mdef='대상자수'/>",	Type:"Int",			Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"targetNum",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:23 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var userCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "");

		sheet1.SetColProperty("tarWorkType", 		{ComboText:userCd[0], ComboCode:userCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	var newIframe;
	var oldIframe;
	var iframeIdx;

	$(function() {
		newIframe = $('#tabs-1 iframe');
		iframeIdx = 0;

		$( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				iframeIdx = ui.newTab.index();
				newIframe = $(ui.newPanel).find('iframe');
				oldIframe = $(ui.oldPanel).find('iframe');
				showIframe();
			}
		});

        $("#pmtNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

        showIframe();
	});

	function showIframe() {
		if(typeof oldIframe != 'undefined') {
			oldIframe.attr("src","about:blank<%-- /common/hidden.jsp --%>");
		}

		if(iframeIdx == 0) {
			newIframe.attr("src","${ctx}/PromStdMgr.do?cmd=viewPromStdStay&authPg=${authPg}");
		} else if(iframeIdx == 1) {
			newIframe.attr("src","${ctx}/PromStdMgr.do?cmd=viewPromStdJust&authPg=${authPg}");
		}
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PromStdMgr.do?cmd=getPromStdMgrList", $("#mySheetForm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PromStdMgr.do?cmd=savePromStdMgr", $("#mySheetForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"pmtCd","");
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "승진기준관리_" + d.getTime();
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
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
			if(iframeIdx == 0) {
				showIframe();
			} else {
				$( "#tabs" ).tabs({active:0});
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 값 변경시 발생
	function sheet1_OnChange(Row, Col, Value) {
		try {
			if(sheet1.ColSaveName(Col) == "sDelete" && sheet1.GetCellValue(Row,"userCnt") > 0) {
				alert("<msg:txt mid='110443' mdef='승진대상자가 있어 삭제할 수 없습니다.'/>");
				sheet1.SetCellValue(Row,Col,0,0);
			}
		} catch (ex) {
			alert("OnChange Event Error " + ex);
		}
	}

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0 && OldRow != -1) {
				if(OldRow != NewRow) {
					$('iframe')[iframeIdx].contentWindow.doAction1("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
		}
	}

	// 승진기준복사 팝업
	function showCopyPopup() {
		pGubun = "copyPopup";

		let layerModal = new window.top.document.LayerModal({
			id : 'promStdMgrLayer'
			, url : '/PromStdMgr.do?cmd=viewPromStdMgrLayer&authPg=${authPg}'
			, parameters : {}
			, width : 700
			, height : 200
			, title : '과거기준복사'
			, trigger :[
				{
					name : 'promStdMgrLayerTrigger'
					, callback : function(result){
						doAction1('Search');
					}
				}
			]
		});
		layerModal.show();

	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "copyPopup") {
			doAction1("Search");
		}
	}

</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="mySheetForm" name="mySheetForm" onsubmit="return false;">
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='112191' mdef='승진대상자명부명'/></th>
							<td>
								<input id="pmtNm" name="pmtNm" type="text" class="text"/>
							</td>
							<td>
								<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</form>
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='114098' mdef='승진기준관리'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
						<btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:showCopyPopup();" css="btn soft authA" mid='111063' mdef="승진기준복사"/>
						<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
					</li>
				</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		<div class="innertab inner" >
			<div id="tabs" class="tab">
				<ul class="tab_bottom">
					<li><btn:a href="#tabs-1" mid='111824' mdef="승진년차"/></li>
					<li><btn:a href="#tabs-2" mid='111521' mdef="가감점"/></li>
				</ul>
				<div id="tabs-1">
					<div  class="layout_tabs">
						<iframe src='about:blank' frameborder='0' class='tab_iframes'></iframe>
					</div>
				</div>
				<div id="tabs-2">
					<div  class='layout_tabs'>
						<iframe src='about:blank' frameborder='0' class='tab_iframes'></iframe>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
