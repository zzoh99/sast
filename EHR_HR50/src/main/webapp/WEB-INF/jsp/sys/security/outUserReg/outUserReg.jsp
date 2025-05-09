<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='114013' mdef='외부사용자등록 '/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		$("#searchSabunName,#searchId").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search"); $(this).focus();
			}
		});

		initSheet1();

 		doAction("Search");
	});

	function doAction(sAction) {
		switch (sAction) {
		case "Search": //조회
			doAction1("Search");
			break;
		}
    }
</script>
<script type="text/javascript">
	var gPRow;
	var pGubun = "";

	function initSheet1() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",				Type:"Popup",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
   			{Header:"<sht:txt mid='password' mdef='비밀번호'/>",			Type:"Pass",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"password",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, StaticPassword:0 },
   			{Header:"<sht:txt mid='rockingYn' mdef='잠금'/>",				Type:"CheckBox",  	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"rockingYn",HeaderCheck:0, TrueValue:"Y", FalseValue:"N" },
   			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",				Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",				Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"comNm",		KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",				Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",				Type:"Text",	Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",				Type:"Text",	Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='mailIdV5' mdef='메일'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mailId",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='handPhoneV2' mdef='핸드폰'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"handPhone",	KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"ID",				Type:"Popup",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"id",			KeyField:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
   			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
   			{Header:"<sht:txt mid='pwdChange' mdef='비밀번호\n초기화'/>",		Type:"Image",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pwdReset",	Sort:0,		Cursor:"Pointer" },
   			{Header:"<sht:txt mid='skinType' mdef='스킨타입'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"skinType",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='fontType' mdef='폰트타입'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fontType",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='mainMenuCd_V2273' mdef='메인화면'/>",			Type:"Popup",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mainMenuNm",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='mainMenuCd_V2273' mdef='메인화면'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mainMenuCd",	KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"grpCd",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='dataRwTypeV1' mdef='데이터권한'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"dataRwType",	KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='searchTypeV1' mdef='조회구분'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"searchType",	KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",				Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },

			{Header:"Hidden",	Type:"Text",		Hidden:1,	SaveName:"passUdtYn"},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var grpCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOutUserRegGrpCd",false).codeList, "");

	 	sheet1.SetColProperty("skinType",	{ComboText:"Blue|Navy|Green|Red|Scarlet|White",	ComboCode:"blue|navy|green|red|scarlet|white"} );
	 	sheet1.SetColProperty("fontType", 	{ComboText:"나눔고딕|본고딕|맑은고딕", 			ComboCode:"nanum|notosans|malgun"} );
	 	sheet1.SetColProperty("grpCd",		{ComboText: grpCdList[0],			ComboCode: grpCdList[1]} );
	 	sheet1.SetColProperty("dataRwType", {ComboText:"읽기/쓰기|읽기",			ComboCode:"A|R"} );
	 	sheet1.SetColProperty("searchType", {ComboText:"자신만조회|권한범위적용|전사", ComboCode:"P|O|A"} );

	    $(window).smartresize(sheetResize);

	    sheetInit();
	}

	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			sheet1.DoSearch( "${ctx}/OutUserReg.do?cmd=getOutUserRegList", $("#sheetForm").serialize() );
			break;
		case "Save":        //저장
			var aRow = sheet1.FindStatusRow("I").split(";");
			for(var i=0; i<=aRow.length; i++) {
				if ( sheet1.GetCellValue( aRow[i], "password" ) == "" ) {
					alert("<msg:txt mid='110493' mdef='입력 시에 비밀번호는 필수입니다.'/>");
					return;
				}
			}

	    	IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/OutUserReg.do?cmd=saveOutUserReg", $("#sheetForm").serialize());
	        break;
	    case "Insert":      //입력
			var Row = sheet1.DataInsert(0);
	        break;
	    case "Copy":        //행복사
	    	var Row = sheet1.DataCopy();
	    	sheet1.SetCellValue(Row, "sabun", "");
	    	sheet1.SetCellValue(Row, "id", "");
			sheet1.SetCellValue(Row, "password", "");
			sheet1.SetCellValue(Row, "passUdtYn", "");
	        break;
	    case "Clear":        //Clear
	        sheet1.RemoveAll();
	        break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param	= {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") { alert(Msg); }
			if(Code != "-1") doAction("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "pwdReset"){
		    	if( sheet1.GetCellValue(Row, "sStatus") == "I" ) return;

			    if( confirm("패스워드를 초기화하면\n이전 패스워드로 복구할 수 없습니다.\n초기비밀번호로 초기화 하시겠습니까?") ){
					var result = ajaxCall("${ctx}/UserMgr.do?cmd=setUserMgrPwdInit", "extraYn=Y&sabun="+sheet1.GetCellValue(Row, "sabun"), false).map;
					alert(result.Message);
			    }

		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

  	function sheet1_OnPopupClick(Row, Col){
  	  	try{
  	  		gPRow = Row;

  	  		if(!isPopup()) {return;}
			let searchType = "";
			let w = 500;
			let h = 170;
  	    	if( sheet1.ColSaveName(Col) == "sabun" ) {
				pGubun = "outUserRegSabun";
				searchType = "SABUN";
  	    	} else if( sheet1.ColSaveName(Col) == "id" ) {
				pGubun = "outUserRegId";
				searchType = "ID";
  	    	} else if( sheet1.ColSaveName(Col) == "mainMenuNm" ) {
				pGubun = "outUserRegMainMenuNm";
				w = 640;
				h = 520;
			}

			const p = {searchType: searchType}
			let outUserRegLayer = new window.top.document.LayerModal({
				id: 'outUserRegLayer',
				url: '/OutUserReg.do?cmd=viewOutUserRegLayer',
				parameters: p,
				width: w,
				height: h,
				title: '외부사용자등록 중복체크',
				trigger: [
					{
						name: 'outUserRegTrigger',
						callback: function(rv) {
							getReturnValue(rv);
						}
					}
				]
			});
			outUserRegLayer.show();


  	  	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
  	}

	// 셀 변경 시
	function sheet1_OnChange(Row, Col, Value) {
		try {
			if (sheet1.ColSaveName(Col) == "password") {
				sheet1.SetCellValue(Row, "passUdtYn", "Y");
			}
		} catch (ex) {
			alert("[sheet1] OnChange Event Error : " + ex);
		}
	}

  	function getReturnValue(rv) {
		if(pGubun == "outUserRegSabun") {
			sheet1.SetCellValue(gPRow, "sabun",	rv["searchVal"] );
		} else if (pGubun == "outUserRegId") {
			sheet1.SetCellValue(gPRow, "id",	rv["searchVal"] );
		} else if (pGubun == "outUserRegMainMenuNm") {
			sheet1.SetCellValue(gPRow, "mainMenuNm",	rv["menuNm"] );
			sheet1.SetCellValue(gPRow, "mainMenuCd",	rv["prgCd"] );
		}
  	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th><tit:txt mid='104330' mdef='사번/성명'/></th>
					<td><input id="searchSabunName" name="searchSabunName" type="text" class="text w100" /></td>
					<th>ID</th>
					<td><input id="searchId" name="searchId" type="text" class="text w100" /></td>
					<td><btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/></td>
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
					<li id="txt" class="txt"><tit:txt mid='112934' mdef='외부사용자등록'/></li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
						<btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='110696' mdef="복사"/>
						<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='110700' mdef="입력"/>
						<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
