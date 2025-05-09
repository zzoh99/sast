<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='mainMnMgr' mdef='메인메뉴관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
   			{Header:"<sht:txt mid='mainMenuCd' mdef='메인메뉴코드'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"mainMenuCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='koKrV4' mdef='메인메뉴명'/>",		Type:"Text",		Hidden:0,	Width:400,	Align:"Center",	ColMerge:0,	SaveName:"mainMenuNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",			Type:"Text",		Hidden:1,Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='authHelp' mdef='도움말'/>",				Type:"Image",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"helpPop",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
   			{Header:"<sht:txt mid='imagePath' mdef='이미지PATH'/>",		Type:"Text",		Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"imagePath",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",					Type:"Text",		Hidden:0,	Width:45,	Align:"Right",	ColMerge:0,	SaveName:"seq",			keyfield:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='useYn' mdef='사용\n유무'/>",			Type:"CheckBox",	Width:50,	Align:"Center",	SaveName:"useYn",		TrueValue:"1",	FalseValue:"0", DefaultValue:"1"}
		];
// 		sheetSplice(initdata.Cols,6, "${localeCd2}", "메인메뉴명", true);
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");

		$("#mainMenuNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/MainMnMgr.do?cmd=getMainMnMgrList", $("#mySheetForm").serialize() ); break;
		case "Save":
// 							sheetLangSave(sheet1, "tsys309", "mainMenuCd","mainMenuNm" );
							IBS_SaveName(document.mySheetForm,sheet1);
							sheet1.DoSave( "${ctx}/MainMnMgr.do?cmd=saveMainMnMgr", $("#mySheetForm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "mainMenuCd"); break;
		//case "Copy":		sheet1.SelectCell(sheet1.DataCopy(), "mainMenuCd"); break;
		//case "Clear":		sheet1.RemoveAll(); break;
		//case "Down2Excel":	sheet1.Down2Excel(); break;
		//case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); } sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col) {
		try {
			if(!isPopup()) {
				return;
			}
			
			var colName = sheet1.ColSaveName(Col), args = {};

			if (colName == "languageNm") {
				if(!isPopup()) {return;}
				args["openSheet"] 	= "sheet1";        //Sheet 명
				args["keyLevel"]	= "tsys309";       //레별
				args["keyId"]		= "languageCd";    //
				args["keyNm"]		= "languageNm";    //
				args["keyText"]		= "mainMenuNm";

				openPopup("/DictMgr.do?cmd=viewDict&is=_popup", args,  "1000","650", function(returnValue) {
					eval(args["openSheet"]).SetCellValue(Row, args["keyId"], returnValue["keyId"]);

					var chkData = { "keyLevel": args["keyLevel"], "languageCd": returnValue["keyId"] };
					var dtWord = ajaxCall( "${ctx}/LangId.do?cmd=getLangCdTword",chkData,false);
					eval(args["openSheet"]).SetCellValue(Row, args["keyNm"], dtWord.map.seqNumTword);
				});
			}

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	function sheet1_OnChange(Row, Col, Value){
		try {
			if ( sheet1.ColSaveName(Col) == "languageNm" ){
				if ( sheet1.GetCellValue( Row, Col ) == "" ){
					sheet1.SetCellValue( Row, "languageCd", "");
				}
			}
			
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><sch:txt mid='mainMenuNm' mdef='메인메뉴명'/></th>
						<td>
							<input id="mainMenuNm" name ="mainMenuNm" type="text" class="text" />
						</td>
						<td>
							<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
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
							<li id="txt" class="txt"><tit:txt mid='mainMnMgr' mdef='메인메뉴관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
