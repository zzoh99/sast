<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>핵심인재선정</title> <!-- All NEW(4.0) EIS MODULE by JSG -->
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript" src="/common/js/cookie.js"></script>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var sltSch 	= "";
var codeLists;

$(function() {

	// 핵심인재선발조직코드
	const corOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCoreSelectOrgList",false).codeList, "");
	$("#searchCoreOrgCd").html(corOrgCdList[2]);

	//==============================================================================================================================
	//공통코드 한번에 조회
	const grpCds = "CD1301,CD1302";
	codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
	$("#searchCoreTypeCd").html(codeLists["CD1301"][2]);

	//==============================================================================================================================

	$("#searchCoreOrgCd, #searchCoreTypeCd").on("change", function(e) {
		if ($(this).val() !== "")
			doAllSearch();
	});
})
</script>

<!-- sheet1 -->
<script type="text/javascript">
	$(function() {
		initSheet1();
		initSheet2();
		initSheet3();
		$(window).smartresize(sheetResize); sheetInit();
	});

	function initSheet1() {
		// 후보자 표시 IBSheet
		const initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:4};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"\n선택",		Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",		ColMerge:0,	SaveName:"check",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"인사\n카드",	Type:"Image",  		Hidden:0,	Width:40, 	Align:"Center", 	ColMerge:0, SaveName:"btnPrt",		Format:"",		UpdateEdit:0, InsertEdit:0 },
			{Header:"T/P",			Type:"Image",  		Hidden:0,	Width:40, 	Align:"Center", 	ColMerge:0, SaveName:"btnPrt2",		Format:"",		UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='photoV1' mdef='사진'/>",       		Type:"Image",   	Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"소속",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000 },
			{Header:"추천인사번",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"rcmdSabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"추천인",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"rcmdName",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"추천일",		Type:"Date",		Hidden:0, 	Width:80,	 Align:"Center", SaveName:"rcmdYmd",		KeyField:0,	Format:"Ymd",	Edit:0 },
			{Header:"추천사유",		Type:"Text",		Hidden:0, 	Width:120,	 Align:"Left", SaveName:"rcmdReason",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"핵심인재구분",  		Type:"Combo",     	Hidden:0,   Width:80,  Align:"Center",  	ColMerge:0,   SaveName:"coreType",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		sheet1.SetColProperty("coreType", 	{ComboText:"|"+codeLists["CD1301"][0], ComboCode:"|"+codeLists["CD1301"][1]} );

		sheet1.SetAutoRowHeight(0);
        //sheet1.SetDataRowHeight(60);
		sheet1.SetDataLinkMouse("btnPrt", 1);
		sheet1.SetDataLinkMouse("btnPrt2", 1);
		sheet1.SetImageList(0, "${ctx}/common/images/icon/icon_popup.png");
		if ($("#searchCoreOrgCd").val() !== "")
			doAction1('Search');
	}

	function initSheet2() {
		// 핵심인재 표시 IBSheet
		const initdata = {};
		initdata.Cfg = {MergeSheet:msHeaderOnly,SearchMode:smLazyLoad,Page:22,FrozenCol:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",							Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태",							Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"인사\n카드|인사\n카드",				Type:"Image",  		Hidden:0,	Width:40, 	Align:"Center", ColMerge:0, SaveName:"btnPrt",		UpdateEdit:0 },
			{Header:"T/P|T/P",							Type:"Image",  		Hidden:0,	Width:40, 	Align:"Center", ColMerge:0, SaveName:"btnPrt2",		UpdateEdit:0 },
			{Header:"사진|사진",       					Type:"Image",   	Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"사번|사번",							Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"성명|성명",							Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"소속|소속",							Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"직책|직책",							Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"직급|직급",							Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"핵심인재구분|핵심인재구분",  			Type:"Text",     	Hidden:0,   Width:80,  Align:"Center", ColMerge:0, SaveName:"coreTypeNm",  KeyField:0,	UpdateEdit:0,   InsertEdit:0 },
			{Header:"Pool-In|일자",						Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"poolInYmd",	KeyField:0,	Format:"Ymd",	UpdateEdit:0,	EditLen:10 },
			{Header:"Pool-In|순위",						Type:"Int",			Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"rank",		KeyField:0,	Format:"NullInteger", UpdateEdit:1,	EditLen:100 },
			{Header:"Pool-In|비고",						Type:"Text",		Hidden:0, 	Width:100,	Align:"Left", 	ColMerge:0, SaveName:"note",		KeyField:0, UpdateEdit:1,	EditLen:4000 },
			{Header:"Pool-Out|선택",						Type:"DummyCheck",	Hidden:0, 	Width:40,	Align:"Center", ColMerge:0, SaveName:"check",		UpdateEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"Pool-Out|사유",						Type:"Combo",		Hidden:0, 	Width:80,	Align:"Center",	ColMerge:0, SaveName:"poolOutReasonCd", 	KeyField:0,	UpdateEdit:1,	EditLen:10 },
			{Header:"Pool-Out|사유상세",					Type:"Text",		Hidden:0, 	Width:100,	Align:"Left", 	ColMerge:0, SaveName:"poolOutReasonDetail", UpdateEdit:1,	EditLen:4000 },
			{Header:"coreType", 						Type:"Text",     	Hidden:1,   Width:0,    Align:"Center", ColMerge:0, SaveName:"coreType",	KeyField:0 },
			{Header:"seq",  							Type:"Text",     	Hidden:1,   Width:0,	Align:"Center", ColMerge:0, SaveName:"seq",			KeyField:0 }
		];
		IBS_InitSheet(sheet2, initdata);
		sheet2.SetEditable("${editable}");
		sheet2.SetCountPosition(4);
		sheet2.SetUnicodeByte(3);

		sheet2.SetColProperty("poolOutReasonCd", 	{ComboText:"|"+codeLists["CD1302"][0], ComboCode:"|"+codeLists["CD1302"][1]} );

		sheet2.SetDataLinkMouse("btnPrt", 1);
		sheet2.SetDataLinkMouse("btnPrt2", 1);
		sheet2.SetImageList(0, "${ctx}/common/images/icon/icon_popup.png");
		if ($("#searchCoreOrgCd").val() !== "")
			doAction2('Search');
	}

	function initSheet3() {
		// 과거이력 표시 IBSheet
		const initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"사진",       		Type:"Image",   	Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"성명",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"소속",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"직책",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"직급",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"Pool-In일자",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"poolInYmd",	KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
			{Header:"Pool-Out일자",		Type:"Date",		Hidden:0, 	Width:80,	Align:"Center", ColMerge:0,	SaveName:"poolOutYmd",	KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
			{Header:"Pool-Out사유",		Type:"Text",		Hidden:0, 	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"poolOutReasonNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"Pool-Out사유상세",	Type:"Text",		Hidden:0, 	Width:100,	Align:"Left", 	ColMerge:0, SaveName:"poolOutReasonDetail", KeyField:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"핵심인재구분",  		Type:"Text",     	Hidden:1,   Width:0,  Align:"Center", ColMerge:0, SaveName:"coreType",    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"seq",  			Type:"Text",     	Hidden:1,   Width:0,	Align:"Center", ColMerge:0, SaveName:"seq",			KeyField:0 }
		];
		IBS_InitSheet(sheet3, initdata);
		sheet3.SetEditable("${editable}");
		sheet3.SetCountPosition(4);
		sheet3.SetUnicodeByte(3);

		if ($("#searchCoreOrgCd").val() !== "")
			doAction3('Search');
	}

	function openLayerPop(id, content) {
		var oPop = $("#"+ id);
		var oPopBg = oPop.find(".layerBg");
		var oPopContent = oPop.find(".layerContent");
		oPopBg.css('height', $(document).height());
		if ( content != undefined ) {
			oPopContent.html( content );
		}
		oPop.show();
	}

	function closeLayerPop(id){
		$("#"+ id).hide();
	}

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if (!$('#searchCoreOrgCd').val()) {
				alert('핵심인재선발조직을 선택해주세요.');
				$('#searchCoreOrgCd').focus();
				break;
			}
			sheet1.DoSearch( "${ctx}/CoreSelect.do?cmd=getCoreSelectList", $("#searchFrm").serialize() );
			break;

		case "PoolIn":

			const checkedRows = sheet1.FindCheckedRow("check");
			if (!checkedRows) {
				alert('핵심인재 대상을 선택해주세요.');
				return;
			}

			const splitCheckedRows = checkedRows.split("|");
			for (var i = sheet1.GetDataFirstRow() ; i <= sheet1.GetDataLastRow() ; i++) {
				if (splitCheckedRows.includes(i+""))
					sheet1.SetCellValue(i, "sStatus", "U");
			}

			IBS_SaveName(document.searchFrm,sheet1);
			const sheetSaveStr = sheet1.GetSaveString();
			if(sheetSaveStr.match("KeyFieldError")) { return false; }
			const result = ajaxCall("${ctx}/CoreSelect.do?cmd=getCoreSelectIsExistsMap", sheetSaveStr+"&"+$("#searchFrm").serialize(), false);
			if (result.DATA && result.DATA.isExists === "Y") {
				if (!confirm("이미 핵심인재에 포함된 대상자가 있습니다. 계속 추가하시겠습니까?")) {
					break;
				}
			}

			sheet1.DoSave("${ctx}/CoreSelect.do?cmd=saveCoreSelectPoolIn", $("#searchFrm").serialize());
			break;

		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param	= {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg !== "") { alert(Msg); }
			if (Code !== "-1") {
				sheet1.SetDataRowHeight(60);
			}

			sheetResize();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex);
		} finally {closeLayerPop('popWait');}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			if( sheet1.ColSaveName(Col) == "btnPrt" ) {
				showRd(sheet1, Row);
			} else if( sheet1.ColSaveName(Col) == "btnPrt2" ) {
				showProfile(sheet1, Row);
			}
		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg !== "") {
				alert(Msg);
			}

			if (Code > -1) {
				doAllSearch();
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//Sheet Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				if (!$('#searchCoreOrgCd').val()) {
					alert('핵심인재선발조직을 선택해주세요.');
					$('#searchCoreOrgCd').focus();
					break;
				}
				sheet2.DoSearch( "${ctx}/CoreSelect.do?cmd=getCoreSelectList2", $("#searchFrm").serialize() );
				break;

			case "PoolOut":

				const checkedRows = sheet2.FindCheckedRow("check");
				if (!checkedRows) {
					alert('Pool-Out 하기 위한 핵심인재 대상자를 선택해주세요.');
					break;
				}

				const splitCheckedRows = checkedRows.split("|");
				for (var i = sheet2.GetDataFirstRow() ; i <= sheet2.GetDataLastRow() ; i++) {
					if (splitCheckedRows.includes(i)) {
						sheet2.SetCellValue(i, "sStatus", "U");
					}
				}

				IBS_SaveName(document.searchFrm, sheet2);
				sheet2.DoSave("${ctx}/CoreSelect.do?cmd=saveCoreSelectPoolOut", $("#searchFrm").serialize());
				break;

			case "Save":
				IBS_SaveName(document.searchFrm, sheet2);
				sheet2.DoSave("${ctx}/CoreSelect.do?cmd=saveCoreSelect2", $("#searchFrm").serialize());
				break;

			case "Clear":
				sheet2.RemoveAll();
				break;

			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param	= {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet2.Down2Excel(param);
				break;

		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg !== "") { alert(Msg); }
			sheetResize();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg !== "")
				alert(Msg);

			if (Code > 0) {
				doAction1("Search");
				doAction3("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			if( sheet2.ColSaveName(Col) == "btnPrt" ) {
				showRd(sheet2, Row);
			} else if( sheet2.ColSaveName(Col) == "btnPrt2" ) {
				showProfile(sheet2, Row);
			}
		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	//Sheet Action
	function doAction3(sAction) {
		switch (sAction) {
			case "Search":
				if (!$('#searchCoreOrgCd').val()) {
					alert('핵심인재선발조직을 선택해주세요.');
					$('#searchCoreOrgCd').focus();
					break;
				}
				sheet3.DoSearch( "${ctx}/CoreSelect.do?cmd=getCoreSelectList3", $("#searchFrm").serialize() );
				break;

			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet3);
				var param	= {DownCols:downcol,SheetDesign:1,Merge:1};
				sheet3.Down2Excel(param);
				break;

		}
	}

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function doAllSearch() {
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
	}

	/**
	 * 레포트 열기
	 */
	function showRd(sheetObj, Row) {

		const rv = "sabun="+sheetObj.GetCellValue(Row, 'sabun');
		const data = ajaxCall("/CoreSelect.do?cmd=getEmpCardPrtRk", rv, false);
		if ( data && data.DATA && data.DATA.rk ) {
			const rdData = {
				rk : data.DATA.rk
			};
			window.top.showRdLayer('/CoreSelect.do?cmd=getEncryptRd', rdData, null, "인사카드");
		}
	}

	function showProfile(sheetObj, Row) {

		const rv = "sabun="+sheetObj.GetCellValue(Row, 'sabun');
		const data = ajaxCall("/CoreSelect.do?cmd=getEmpCardPrtRk", rv, false);
		if ( data && data.DATA && data.DATA.rk ) {
			const rdData = {
				rk : data.DATA.rk
			};
			window.top.showRdLayer('/CoreSelect.do?cmd=getEncryptRd2', rdData, null, "Talent Profile");
		}
	}

	//비교대상 화면으로 이동
	function goMenu() {

		let sRow = sheet1.FindCheckedRow("check");

		if(sRow == "") {
			alert('비교할 대상이 없습니다.');
			return;
		}
		let arrRow = sRow.split("|");
		if(arrRow.length > 3) {
			alert('인재비교는 최대 3명만 선택 할 수 있습니다.');
			return;
		}

		for(var i = 0; i < arrRow.length; i++) {
			if(arrRow[i] != "") {
				setCookie("CompareEmpN"+(i+1), sheet1.GetCellValue(arrRow[i],"name"), 1000);
				setCookie("CompareEmpS"+(i+1), sheet1.GetCellValue(arrRow[i],"sabun"), 1000);
			}
		}

		// 서브페이지에서 서브페이지 호출
		if(typeof window.top.goOtherSubPage == 'function') {
			window.top.goOtherSubPage("", "", "", "", "CompareEmp.do?cmd=viewCompareEmp");
		}
	}
</script>

</head>
<body class="hidden" onload="">
<div class="wrapper">
	<form id="searchFrm" name="searchFrm">
		<input type="hidden" id="srchSeq" name="srchSeq" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>핵심인재선발조직</th>
						<td>
							<select id="searchCoreOrgCd" name ="searchCoreOrgCd" ></select>
						</td>
						<th>핵심인재구분</th>
						<td>
							<select id="searchCoreTypeCd" name ="searchCoreTypeCd" ></select>
						</td>
						<td>
							<a href="javascript:doAllSearch();" class="button"><tit:txt mid='104081' mdef='조회'/></a>
						</td>
					</tr>
				</table>
			</div>
		</div>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<colgroup>
				<col width="30%" />
				<col width="50px" />
				<col width="" />
			</colgroup>
			<tr>
				<td class="top" rowspan="2">
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">핵심인재후보추천자</li>
								<li class="btn">
									<a href="javascript:doAction1('Search');" class="basic authR"><tit:txt mid='104081' mdef='조회'/></a>
									<a href="javascript:goMenu()" class="button authR">인재비교</a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
				<td>
					<a href="javascript:doAction1('PoolIn');" class="button" title="Pool-In" style="margin-left:6px; margin-bottom:2px;"><i class="fas fa-arrow-right"></i></a>
					<a href="javascript:doAction2('PoolOut');" class="button" title="Pool-Out" style="margin-left:6px; margin-top:2px;"><i class="fas fa-arrow-left"></i></a>
				</td>
				<td class="sheet_right">
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt">핵심인재</li>
								<li class="btn">
									<a href="javascript:doAction2('Search');" class="basic authR">조회</a>
									<%--<a href="javascript:doAction2('PoolOut');" class="button authA">Pool-Out</a>--%>
									<a href="javascript:doAction2('Save')" class="basic authA">저장</a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
			<tr>
				<td></td>
				<td class="sheet_right">
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt">과거이력</li>
								<li class="btn">
									<a href="javascript:doAction3('Search');" class="basic authR">조회</a>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet3", "100%", "50%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
	</form>
</div>
<div id="popWait" class="layerPop" style="display:none; position:absolute; left:0; top:0; width:100%; height:100%; z-index:500;">
	<div class="layerBg" onclick="//closeLayerPop('popWait');" style="position:absolute; left:0; top:0; width:100%; height:100%; z-index:400; background:#000; opacity:.1; filter:alpha(opacity:10);"></div>
	<div class="layerBox" style="position:fixed; left:50%; top:300px; width:240px; margin-left:-180px; padding-bottom:20px; z-index:420; background:#fff;" >
		<div class="layerContent" style="position:relative; padding:20px 20px 20px 20px;"></div>
	</div>
</div>
</body>
</html>
