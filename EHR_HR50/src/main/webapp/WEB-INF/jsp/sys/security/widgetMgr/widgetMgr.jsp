<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='tabId' mdef='위젯코드'/>",	Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"tabId",		UpdateEdit:0,	InsertEdit:1},
			{Header:"<sht:txt mid='L190902000002' mdef='위젯명' />",	Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"tabName",		UpdateEdit:1,	InsertEdit:1},
			{Header:"<sht:txt mid='languageCd' mdef='어휘코드'/>",	Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='ibsImageV3' mdef='세부내역' />",	Type:"Text",		Hidden:0,					Width:150,			Align:"Left",	ColMerge:0,	SaveName:"tabDetail",	UpdateEdit:1,	InsertEdit:1},
			{Header:"<sht:txt mid='L190902000003' mdef='기본순번' />",Type:"Int",			Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"tabSeq",		UpdateEdit:1,	InsertEdit:1},
			{Header:"<tit:txt mid='' mdef='통계여부'/>",		Type:"DummyCheck",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"chkStatsCd",		UpdateEdit:1,	InsertEdit:1, TrueValue:"Y",	FalseValue:"N"},
			{Header:"<tit:txt mid='' mdef='통계명'/>",		Type:"Combo",		Hidden:0,		Edit:0,			Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statsCd",		UpdateEdit:1,	InsertEdit:1},
			{Header:"URL",											Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"tabUrl",		UpdateEdit:1,	InsertEdit:1},
			{Header:"<sht:txt mid='useYnV1' mdef='사용여부' />",		Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"useYn",		UpdateEdit:1,	InsertEdit:1},
			{Header:"<sht:txt mid='prgCdV2' mdef='프로그램' />",		Type:"Popup",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"prgNm",		UpdateEdit:1,	InsertEdit:1},
			{Header:"<tit:txt mid='113332' mdef='메인메뉴'/>",		Type:"Text",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"mainMenuCd",		UpdateEdit:1,	InsertEdit:1},
			{Header:"<tit:txt mid='program' mdef='프로그램'/>",		Type:"Text",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"prgCd",		UpdateEdit:1,	InsertEdit:1}
		];IBS_InitSheet(mySheet, initdata);mySheet.SetCountPosition(4);

		mySheet.SetColProperty("useYn", 		{ComboText:"Yes|No|Fixed", ComboCode:"Y|N|L"} );

		var comboStatsCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWidgetStatCodeList", false).codeList, "");
		mySheet.SetColProperty("statsCd", {ComboText:"|"+comboStatsCd[0], ComboCode:"|"+comboStatsCd[1]} );


		$(window).smartresize(sheetResize);
		sheetInit();

		$("#searchTabName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search");
			}
		});

		$("#searchUseYn").on("change", function(e){
			doAction("Search");
		});

		doAction("Search");
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":		mySheet.DoSearch( "${ctx}/WidgetMgr.do?cmd=getWidgetMgrList", $("#mySheetForm").serialize() ); break;
		case "Down2Excel":	mySheet.Down2Excel(); break;
		case "Save":
			if(!dupChk(mySheet,"tabId", false, true)){break;}
			IBS_SaveName(document.mySheetForm,mySheet);
			mySheet.DoSave( "${ctx}/WidgetMgr.do?cmd=saveWidgetMgr", $("#mySheetForm").serialize()); break;
			break;
		case "Insert":
			var row = mySheet.DataInsert(0);
			mySheet.SetCellValue(row, "tabUrl", "main/main/");
			break;
		case "Copy":
			mySheet.DataCopy();
			break;
		}
	}

	// 조회 후 에러 메시지
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			for ( var i = mySheet.HeaderRows(); i < mySheet.RowCount()+mySheet.HeaderRows(); i++){
				var chkStatsCd=mySheet.GetCellValue(i, "chkStatsCd");
				if(chkStatsCd=="Y"){
		    		mySheet.SetCellEditable(i, "statsCd", 1);

		    	}else{
		    		mySheet.SetCellEditable(i, "statsCd", 0);
		    		mySheet.SetCellValue(i,"statsCd","");
		    	}
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// RIGHT 저장 후 메시지
	function mySheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction("Search");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function mySheet_OnChange(Row, Col, Value) {
		try{
			var colName = mySheet.ColSaveName(Col);
			if( colName == "tabId" ) {
				if(isNumber(Value.substring(7), '')){
					mySheet.SetCellValue(Row, "tabSeq", Value.substring(7));
				}
		    }
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function mySheet_OnPopupClick(Row, Col){
		var	args	= new Array();
		try{
			let colName = mySheet.ColSaveName(Col);
			if(colName === 'languageNm'){
				lanuagePopup(Row, "mySheet", "tsys342", "languageCd", "languageNm", "tabName");
			}else if(colName === 'prgNm'){

				//600x635
				let layerModal = new window.top.document.LayerModal({
					id : 'prgSearchLayer'
					, url : '/Popup.do?cmd=prgSearchLayer'
					, parameters : {}
					, width : 600
					, height : 635
					, title : '프로그램 검색'
					, trigger :[
						{
							name : 'prgSearchTrigger'
							, callback : function(result){
								console.log(result);

								mySheet.SetCellValue(Row, "prgNm", result.menuNm);
								mySheet.SetCellValue(Row, "mainMenuCd", result.mainMenuCd);
								mySheet.SetCellValue(Row, "prgCd", result.prgCd);
							}
						}
					]
				});
				layerModal.show();

			}


			// if (mySheet.ColSaveName(Col) == "languageNm") {
			// 	lanuagePopup(Row, "mySheet", "tsys342", "languageCd", "languageNm", "tabName");
			// }
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 셀 클릭시 발생
	function mySheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < mySheet.HeaderRows() ) return;

			//통계여부
		    if( mySheet.ColSaveName(Col) == "chkStatsCd" ) {
		    	if(Value=="Y"){
		    		mySheet.SetCellEditable(Row, "statsCd", 1);
		    		mySheet.SetCellValue(Row,"tabUrl", "main/main/widgets/stats");
		    	}else{
		    		mySheet.SetCellEditable(Row, "statsCd", 0);
		    		mySheet.SetCellValue(Row,"statsCd","");
		    		mySheet.SetCellValue(Row,"tabUrl", "main/main/");
		    	}

		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);

		}
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm">
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th>위젯 명</th>
					<td>
						<input type="text" class="text" id="searchTabName" name="searchTabName" />
					</td>
					<th><tit:txt mid='111965' mdef='사용여부'/></th>
					<td>
						<select id="searchUseYn" name="searchUseYn" >
							<option value="" ><tit:txt mid='112663' mdef='전체 '/></option>
							<option value="Y" selected ><tit:txt mid='113321' mdef='사용'/></option>
							<option value="N"><tit:txt mid='112598' mdef='사용안함'/></option>
						</select>
					</td>
					<td> <btn:a href="javascript:doAction('Search');" id="btnSearch" css="btn dark" mid='search' mdef="조회"/> </td>
				</tr>
			</table>
			</div>
		</div>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid="L190902000004" mdef="위젯등록" /></li>
								<li class="btn">
									<btn:a href="javascript:doAction('Down2Excel');" 	css="btn outline-gray authR" mid="download" mdef="다운로드"/>
									<btn:a href="javascript:doAction('Copy')" 			css="btn outline-gray authA" mid="copy" mdef="복사"/>
									<btn:a href="javascript:doAction('Insert')" 		css="btn outline-gray authA" mid="insert" mdef="입력"/>
									<btn:a href="javascript:doAction('Save');"       	css="btn filled authA" mid="save" mdef="저장"/>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("mySheet", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
	</form>
</div>
</body>
</html>
