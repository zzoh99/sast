<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow      = "";
	var pGubun     = "";
	var resultCode = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' 			mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' 		mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd' 		mdef='상태'/>",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='2018080300019' 	mdef='어학코드'/>",			Type:"Text",		Hidden:0,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"code",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='fTestCd' 		mdef='어학시험명'/>",		Type:"Text",		Hidden:0,		Width:150,			Align:"Center",	ColMerge:0,	SaveName:"codeNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
			{Header:"<sht:txt mid='languageCd' 		mdef='어휘코드'/>",		Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='languageNm' 		mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	UpdateEdit:1,	InsertEdit:1},
			{Header:"<sht:txt mid='2018080300021' 	mdef='레벨판정구분'/>",		Type:"Combo",		Hidden:0,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"note2",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='codeIdx' mdef='코드순번'/>",		Type:"Text",		Hidden:1,	Width:0, Align:"Center",	ColMerge:0,	SaveName:"codeIdx",	UpdateEdit:0, InsertEdit:0},
			{Header:"<sht:txt mid='sYmd' mdef='시작일'/>",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, EndDateCol: "eYmd" },
			{Header:"<sht:txt mid='eYmd' mdef='종료일'/>",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, StartDateCol: "sYmd" },
			{Header:"<sht:txt mid='bigoV2' 			mdef='비고'/>",				Type:"Text",		Hidden:0,		Width:100,			Align:"Center",	ColMerge:0,	SaveName:"note3",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNoV1' 			mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDeleteV1'		mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatusV1' 		mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"어학코드|어학코드",											Type:"Text",		Hidden:1,						Width:100,			Align:"Center",	ColMerge:0,	SaveName:"fTestCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='2018080300024'	mdef='등급범위|등급범위'/>",	Type:"Combo",		Hidden:0,						Width:100,			Align:"Center",	ColMerge:0,	SaveName:"levelCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"SEQ|SEQ",												Type:"Text",		Hidden:1,						Width:150,			Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='2018080300025' 	mdef='등급범위|최소'/>",	Type:"Text",		Hidden:0,						Width:100,			Align:"Center",	ColMerge:0,	SaveName:"minPoint",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='2018080300026' 	mdef='등급범위|최대'/>",	Type:"Text",		Hidden:0,						Width:100,			Align:"Center",	ColMerge:0,	SaveName:"maxPoint",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"어학수당|어학수당",	 										Type:"Int",			Hidden:0,						Width:60,			Align:"Right",	ColMerge:0,	SaveName:"testForeignPay",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },

			{Header:"<sht:txt mid='2018080300027' 	mdef='정렬순서|정렬순서'/>",	Type:"Text",		Hidden:0,						Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orderSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='bigo' 			mdef='비고|비고'/>",		Type:"Text",		Hidden:0,						Width:100,			Align:"Center",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var gubunCd   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20308"), "");
		var gradeCd   = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20305"), "");

		sheet1.SetColProperty("note2", 		{ComboText:gubunCd[0], ComboCode:gubunCd[1]} );
		sheet2.SetColProperty("levelCd", 	{ComboText:gradeCd[0], ComboCode:gradeCd[1]} );

		//어학수당등급코드
		var params     = "&selectGroupCode=H20305";
			resultCode = ajaxCall("${ctx}/GrpCdMgr.do?cmd=getGrpCdMgrDetailList"+params,"",false);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	$(function() {

        $("#searchCodeNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	function chkInVal() {
		// 시작일자와 종료일자 체크
		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "eYmd") != null && sheet1.GetCellValue(i, "eYmd") != "") {
					var sdate = sheet1.GetCellValue(i, "sYmd");
					var edate = sheet1.GetCellValue(i, "eYmd");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "eYmd");
						return false;
					}
				}
			}
		}
		return true;
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/ForeignGradeMgr.do?cmd=getForeignGradeMgrList1",$("#sheet1Form").serialize());
			break;
		case "Save":
			if(!dupChk(sheet1,"code", true, true)){break;}
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/ForeignGradeMgr.do?cmd=saveForeignGradeMgr1", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet1 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.SetFocusAfterProcess(0);

			var selRow = sheet1.GetSelectRow();
			var code = sheet1.GetCellValue(selRow, "code");

			$("#searchFTestCd").val(code);

			sheet2.DoSearch( "${ctx}/ForeignGradeMgr.do?cmd=getForeignGradeMgrList2",$("#sheet1Form").serialize());
			break;
		case "Save":
			if(!dupChk(sheet2,"fTestCd|levelCd|minPoint", true, true)){break;}

			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/ForeignGradeMgr.do?cmd=saveForeignGradeMgr2", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var selRow = sheet1.GetSelectRow();
			var code = sheet1.GetCellValue(selRow, "code");
			var lvlGubun = sheet1.GetCellValue(selRow, "note2");
			var status = sheet1.GetCellValue(selRow, "sStatus");

			if(status != "R") {
				alert("<msg:txt mid='alertInputAfterSave' mdef='입력중인 데이터가 있습니다. 저장후 입력하여 주십시오.'/>");
				return;
			}

			var row = sheet2.DataInsert(0);
			sheet2.SetCellValue(row, "fTestCd", code);
			sheet2.SetCellValue(row, "seq", "");

			//어학수당 셋팅
//			var params     = "&selectGroupCode=H20305";
//			var resultCode = ajaxCall("${ctx}/GrpCdMgr.do?cmd=getGrpCdMgrDetailList"+params,"",false);
			sheet2.SetCellValue(row, "testForeignPay", resultCode.DATA[0].numNote);

			break;
		case "Copy":
			var row = sheet2.DataCopy();
			sheet2.SetCellValue(row, "seq", "");
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
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

	//키를 눌렀을때 발생.
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "languageNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"languageCd","");
					sheet1.SetCellValue(Row,"languageNm","");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol, isDelete){
		try{
			if((isDelete != true && OldRow != NewRow) || isDelete == true) {
				doAction2("Search");
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if (sheet1.ColSaveName(Col) == "languageNm") {
				lanuagePopup(Row, "sheet1", "tsys005", "languageCd", "languageNm", "codeNm");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			var selRow = sheet1.GetSelectRow();
			var lvlGubun = sheet1.GetCellValue(selRow, "note2");

			if(lvlGubun == "P") {
				sheet2.SetColEditable("maxPoint",true);
			} else {
				sheet2.SetColEditable("maxPoint",false);
			}

//			var params     = "&selectGroupCode=H20305";
//			var resultCode = ajaxCall("${ctx}/GrpCdMgr.do?cmd=getGrpCdMgrDetailList"+params,"",false);

			for (var i=sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++) {
				var levelCd = sheet2.GetCellValue(i, "levelCd");
				for(var j=0; j<resultCode.DATA.length; j++) {
					var resultLevelCd = resultCode.DATA[j].code;
					var resultNumNote = isEmpty(resultCode.DATA[j].numNote) ? "" : resultCode.DATA[j].numNote;

					if(levelCd == resultLevelCd) {
						sheet2.SetCellValue(i, "testForeignPay", resultNumNote);
						sheet2.SetCellValue(i, "sStatus",   	 "R");
					}
				}
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 값이 바뀔때 발생
	function sheet2_OnChange(Row, Col, Value) {
		try {
			var sSaveName = sheet2.ColSaveName(Col);

			if(sSaveName == "levelCd") {
//				var params     = "&selectGroupCode=H20305";
//				var resultCode = ajaxCall("${ctx}/GrpCdMgr.do?cmd=getGrpCdMgrDetailList"+params,"",false);

				sheet2.SetCellValue(Row, "testForeignPay", "");
				var levelCd = sheet2.GetCellValue(Row, "levelCd");
				for(var i=0; i<resultCode.DATA.length; i++) {
					var resultLevelCd = resultCode.DATA[i].code;
					var resultNumNote = isEmpty(resultCode.DATA[i].numNote) ? "" : resultCode.DATA[i].numNote;

					if(levelCd == resultLevelCd) {
						sheet2.SetCellValue(Row, "testForeignPay", isEmpty(resultNumNote) ? "" : resultNumNote);
					}
				}
			}
		} catch(ex) {
			alert("OnChange Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="searchFTestCd" name="searchFTestCd" value="" />
	<input type="hidden" id="deleteType" name="deleteType" value="" />
	<input id="selectGroupCode" name="selectGroupCode" type="hidden" value="H20305"/>

	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='2018080300028' mdef='어학시험명'/></th>
			<td>
				<input id="searchCodeNm" name="searchCodeNm" type="text" class="text"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	<!-- <div class="inner"> -->
</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='2018080300029' mdef='어학코드'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				<!-- <btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='copy' mdef="복사"/> -->
				<btn:a href="javascript:doAction1('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='2018080300030' mdef='등급코드'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction2('Down2Excel');" css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
				<!-- <btn:a href="javascript:doAction2('Copy');" css="btn outline-gray authA" mid='copy' mdef="복사"/> -->
				<btn:a href="javascript:doAction2('Insert');" css="btn outline-gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction2('Save');" css="btn filled authA" mid='save' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
