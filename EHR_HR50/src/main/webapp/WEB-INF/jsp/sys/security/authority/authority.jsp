<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='authority' mdef='권한그룹관리'/></title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
			{Header:"<sht:txt mid='grpCd' mdef='권한그룹코드'/>",			Type:"Int",			Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"grpCd",		KeyField:1,		CalcLogic:"",   Format:"NullInteger",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",			Type:"Text",		Hidden:0,					Width:155,			Align:"Left",	ColMerge:0,	SaveName:"grpNm",		KeyField:1,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",				Type:"Text",		Hidden:1,Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='commonYnV2' mdef='전직원\n적용여부'/>",	Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"commonYn",	KeyField:0,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='dataRwTypeV1' mdef='데이터권한'/>",		Type:"Combo",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"dataRwType",	KeyField:0,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='enterAllYn' mdef='그룹사\n조회여부'/>",	Type:"Combo",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"enterAllYn",	KeyField:0,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='searchTypeV1' mdef='조회구분'/>",		Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"searchType",	KeyField:0,		CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",			Hidden:0,					Width:40,			Align:"Right",	ColMerge:0,	SaveName:"seq",			KeyField:0,		CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"관리자여부",											Type:"CheckBox",	Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"adminYn",KeyField:0,		CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"퇴직자\n조회여부",                						Type:"CheckBox",    Hidden:0,   				Width:60,   		Align:"Center", ColMerge:0, SaveName:"retSrchYn",   KeyField:0, 	CalcLogic:"",   Format:"",      	  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"미래시점\n조회여부",                						Type:"CheckBox",    Hidden:0,   				Width:60,   		Align:"Center", ColMerge:0, SaveName:"preSrchYn",   KeyField:0, 	CalcLogic:"",   Format:"",      	  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"주민번호\n조회여부",                						Type:"CheckBox",    Hidden:1,   				Width:60,   		Align:"Center", ColMerge:0, SaveName:"resSrchYn",   KeyField:0, 	CalcLogic:"",   Format:"",      	  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"문의/오류접수\r\n사용여부",								Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"errorAccYn",	KeyField:0,		CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N"},
			{Header:"문의/오류접수\r\n관리자여부",								Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Right",	ColMerge:0,	SaveName:"errorAdminYn",KeyField:0,		CalcLogic:"",	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='authGroup' mdef='권한\n범위'/>",			Type:"Image",		Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"authScope",	Sort:0 },
			{Header:"<sht:txt mid='authView' mdef='VIEW'/>",			Type:"Image",		Hidden:1,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"authView",	Sort:0,			Cursor:"Pointer"},
			{Header:"<sht:txt mid='authHelp' mdef='도움말'/>",				Type:"Image",		Hidden:1,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"authHelp",	Sort:0 },
			{Header:"<sht:txt mid='authEnter' mdef='회사\n선택'/>", 		Type:"Image",		Hidden:1,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"authEnter",	Sort:0 },
			{Header:"<sht:txt mid='manCntV1' mdef='등록된\n인원수'/>",		Type:"Text",		Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"manCnt",			KeyField:0,		CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
			{Header:"<sht:txt mid='proCnt' mdef='등록된\n프로그램수'/>",		Type:"Text",		Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"proCnt",			KeyField:0,		CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0 }
		];
		IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4);
		mySheet.SetEditable("${editable}");
		mySheet.SetColProperty("commonYn", {ComboText:"<sht:txt mid='yesOrNo|no' mdef='예|아니오'/>", ComboCode:"Y|N"} );
		mySheet.SetColProperty("dataRwType", {ComboText:"<sht:txt mid='dataRwTypeV3' mdef='읽기/쓰기|읽기'/>", ComboCode:"A|R"} );
		mySheet.SetColProperty("enterAllYn", {ComboText:"<sht:txt mid='yesOrNo|no' mdef='예|아니오'/>", ComboCode:"Y|N"} );
		mySheet.SetColProperty("searchType", {ComboText:"<sht:txt mid='searchTypeV4' mdef='자신만조회|권한범위적용|전사'/>", ComboCode:"P|O|A"} );
		mySheet.SetImageList(0,"/common/images/icon/icon_popup.png");
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
		$(".sheet_search>div>table>tr input[type=text],select").each(function(){
			alert($(this).attr("id")+"  "+$.type($(this)) );
		});

		$("#searchGrpNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search");
				$(this).focus();
			}
		});
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	mySheet.DoSearch( "${ctx}/Authority.do?cmd=getAuthorityList", $("#mySheetForm").serialize() ); break;
		case "Save":
							if(!dupChk(mySheet,"grpCd", true, true)){break;}
							IBS_SaveName(document.mySheetForm,mySheet);
							mySheet.DoSave( "${ctx}/Authority.do?cmd=saveAuthority", $("#mySheetForm").serialize()); break;
		case "Insert":		mySheet.SelectCell(mySheet.DataInsert(0), "column1"); break;
		case "Copy":		mySheet.SelectCell(mySheet.DataCopy(), "column1"); break;
		case "Clear":		mySheet.RemoveAll(); break;
		case "Down2Excel":	mySheet.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; mySheet.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function mySheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function mySheet_OnPopupClick(Row, Col){
		var	args	= new Array();
		try{
			if (mySheet.ColSaveName(Col) == "languageNm") {
				if(!isPopup()) {return;}

				var p = {keyLevel	: "tsys307",
						 keyId		: "languageCd",
						 keyNm		: "languageNm",
						 keyText	: "grpNm"};
				let layerModal = new window.top.document.LayerModal({
					  id : 'dictLayer'
					, url : '/DictMgr.do?cmd=viewDictLayer'
					, parameters : parameters
					, width : 1000
					, height : 650
					, title : "<tit:txt mid='104444' mdef='사전 검색'/>"
					, trigger :[
						{
							name : 'dictTrigger'
							, callback : function(result){
								sheet1.SetCellValue(Row, 'languageCd', result.keyId);
								var chkData = { "keyLevel": parameters.keyLevel, "languageCd": result.keyId};
								var dtWord = ajaxCall( "${ctx}/LangId.do?cmd=getLangCdTword",chkData,false);
								sheet1.SetCellValue(Row, 'languageNm', dtWord.map.seqNumTword);
							}
						}
					]
				});
				layerModal.show();
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function mySheet_OnChange(Row, Col, Value){
		try {
			if ( mySheet.ColSaveName(Col) == "languageNm" ){
				if ( mySheet.GetCellValue( Row, Col ) == "" ){
					mySheet.SetCellValue( Row, "languageCd", "");
				}
			}
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function mySheet_OnClick(Row, Col, Value) {
		try{

			if(Row > 0 && mySheet.ColSaveName(Col) == "authScope" ){
				authScopePopup(Row);
			}
			
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}


	function mySheet_OnMouseMove(Button, Shift, X, Y) {
		try {
			var Row = mySheet.MouseRow();
			var Col = mySheet.MouseCol();

			mySheet.SetDataLinkMouse("authScope", 1);

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}



	function authScopePopup(Row){
		if(!isPopup()) {return;}
		var url 	= "${ctx}/Authority.do?cmd=viewAuthorityAuthLayer&authPg=${authPg}";
		const p = { athGrpCd: mySheet.GetCellValue(Row, "grpCd") };
		var layer = new window.top.document.LayerModal({
			id: 'authorityAuthLayer',
			url: url,
			parameters: p,
			width: 660,
			height: 580,
			title: "<tit:txt mid='authorityAuthPop' mdef='권한범위설정'/>"
		});
		layer.show();
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
						<th><sch:txt mid='grpNm' mdef='권한그룹'/> </th>
						<td>  <input id="searchGrpNm" name ="searchGrpNm" type="text" class="text" /> </td>
						<td> <btn:a href="javascript:doAction('Search');" id="btnSearch" mid="110697" mdef="조회" css="btn dark"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='authority' mdef='권한그룹관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction('Copy');" mid="110696" mdef="복사" css="btn outline-gray authA"/>
								<btn:a href="javascript:doAction('Insert');" mid="110700" mdef="입력" css="btn outline-gray authA"/>
								<btn:a href="javascript:doAction('Save');" mid="110708" mdef="저장" css="btn filled authA"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("mySheet", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
