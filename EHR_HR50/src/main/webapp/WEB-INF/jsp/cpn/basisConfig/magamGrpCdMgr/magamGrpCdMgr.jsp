
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		sheet1.SetDataLinkMouse("detail", 1);

		var initdata = {};
		initdata.Cfg = {FrozenCol:4, SearchMode:smLazyLoad,Page:10};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",     			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",    		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",    		Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='grcodeCd' mdef='그룹\n코드'/>",		Type:"Text",		Hidden:0,	Width:40,		Align:"Center",	ColMerge:0,	SaveName:"grcodeCd",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='grcodeNm' mdef='코드명'/>",		Type:"Text",		Hidden:0,	Width:100,		Align:"Left",	ColMerge:0,	SaveName:"grcodeNm",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500, MultiLineText:1 },

			{Header:"<sht:txt mid='languageCd' mdef='어휘코드'/>",		Type:"Text",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	UpdateEdit:1,	InsertEdit:1},

			{Header:"<sht:txt mid='grcodeFullNm' mdef='코드설명'/>",	Type:"Text",		Hidden:0,	Width:200,		Align:"Left",	ColMerge:0,	SaveName:"grcodeFullNm",KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500, MultiLineText:1	},
			{Header:"<sht:txt mid='grcodeEngNm' mdef='코드영문명'/>",	Type:"Text",		Hidden:1,	Width:0,		Align:"Left",	ColMerge:0,	SaveName:"grcodeEngNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500, MultiLineText:1	},
			{Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",			Type:"Combo",		Hidden:0,	Width:80,		Align:"Center", ColMerge:0,	SaveName:"bizCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"<sht:txt mid='commonYn' mdef='참조여부'/>",		Type:"Combo",		Hidden:0,	Width:80,		Align:"Center", ColMerge:0,	SaveName:"commonYn",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='type' mdef='구분'/>",				Type:"Combo",		Hidden:0,	Width:80,		Align:"Center", ColMerge:0,	SaveName:"type",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='subCnt' mdef='세부\n코드수'/>",		Type:"Text",		Hidden:0,	Width:40,		Align:"Center", ColMerge:0,	SaveName:"subCnt",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }

		];
// 		sheetSplice(initdata.Cols,5,	"${localeCd2}",	"<sht:txt mid='grcodeNm' mdef='코드명'/>",	true);
		IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);
		//구분
		sheet1.SetColProperty("type", {ComboText:"<sht:txt mid='cbGrpCdMgrType' mdef='사용자코드|시스템코드'/>", ComboCode:"C|N"} );

		//참조여부
		sheet1.SetColProperty("commonYn", {ComboText:"Y|N", ComboCode:"Y|N"} );

		//업무구분
		var menuList = convCode( ajaxCall("${ctx}/MagamGrpCdMgr.do?cmd=getMainMuPrgMainMenuList","",false).codeList,"<sht:txt mid='all' mdef='전체'/>");
		sheet1.SetColProperty("bizCd", 			{ComboText:"|" + menuList[0], ComboCode:"|"+menuList[1]} );


		$("#srchBizCd").html(menuList[2]);

		$("#srchBizCd").change(function(){
			doAction1("Search");
		});


		initdata = {};
		initdata.Cfg = {FrozenCol:6, SearchMode:smLazyLoad,Page:32};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='grcodeCdV1' mdef='그룹코드'/>",		Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"grcodeCd",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='grcodeNmV1' mdef='그룹코드명'/>",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"grcodeNm",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500, MultiLineText:1 },
			{Header:"<sht:txt mid='codeV2' mdef='세부\n	코드'/>",		Type:"Text",		Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"code",		KeyField:1,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='codeNmV2' mdef='세부코드명'/>",		Type:"Text",		Hidden:0,	Width:135,	Align:"Left",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500, MultiLineText:1 },

			{Header:"<sht:txt mid='languageCd' mdef='어휘코드'/>",		Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	UpdateEdit:1,	InsertEdit:1},

			{Header:"<sht:txt mid='seqV2' mdef='순서'/>",				Type:"Int",			Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,		CalcLogic:"",	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"<sht:txt mid='visualYn' mdef='보여\n주기'/>",		Type:"Combo",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"visualYn",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='useYn' mdef='사용\n유무'/>",		Type:"Combo",		Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='codeFullNm' mdef='FULL명'/>",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"codeFullNm",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='codeEngNm' mdef='영문명'/>",		Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"codeEngNm",	KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='memoV3' mdef='코드설명'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"<sht:txt mid='note1' mdef='비고1'/>",			Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note1",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"<sht:txt mid='note2' mdef='비고2'/>",			Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note2",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"<sht:txt mid='note3' mdef='비고3'/>",			Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note3",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"<sht:txt mid='note4' mdef='비고4'/>",			Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"note4",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"<sht:txt mid='numNote' mdef='비고(숫자형)'/>",	Type:"Text",		Hidden:0,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"numNote",		KeyField:0,		CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일'/>",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eYmd' mdef='종료일'/>",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
		];
// 		sheetSplice(initdata.Cols,7,	"${localeCd2}",	"<sht:txt mid='codeNmV2' mdef='세부코드명'/>",	true);
		IBS_InitSheet(sheet2, initdata);sheet2.SetCountPosition(4);
			sheet2.SetColProperty("visualYn", {ComboText:"<sht:txt mid='yes|No' mdef='예|아니오'/>", ComboCode:"Y|N"} );
			sheet2.SetColProperty("useYn", {ComboText:"<sht:txt mid='useV1|useV2' mdef='사용|사용안함'/>", ComboCode:"Y|N"} );
			sheet2.SetFocusAfterProcess(0);
 		$(window).smartresize(sheetResize);
		sheetInit();

		$("#srchGrpCd,#srchGrpCodeNm,#srchWithDetailCodeNm,#srchDetailCode,#srchDetailCodeNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#srchType").change(function(){
			doAction1("Search");
		});

		$("#srchUseYn").change(function(){
			doAction1("Search");
		});

		doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if("${result.mainMenuCd}" != 11){
				$("#srchBizCd").attr("disabled",false);
			}
			sheet1.DoSearch( "${ctx}/MagamGrpCdMgr.do?cmd=getGrpCdMgrList", $("#mySheetForm").serialize() );
			"${result.mainMenuCd}" != 11 ? $("#srchBizCd").attr("disabled",true) : "";
			break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
			    if(!dupChk(sheet1,"grcodeCd", true, true)){break;}
			}
// 			sheetLangSave(sheet1,	"tsys001",	"grcodeCd","grcodeNm"	);
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave("${ctx}/MagamGrpCdMgr.do?cmd=saveGrpCdMgr", $("#mySheetForm").serialize() );
		    break;
		case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), 2); break;
		case "Copy":		sheet1.DataCopy();break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			/* if("${result.mainMenuCd}" != 11){
				if(sheet1.GetCellValue(sheet1.GetSelectRow(), "type") == "C"){
					sheet2.SetEditable(true);
					$(".basic").each(function(i,v){
						v.id == "Btn2" ? $(v).show() : "";
					});
				} else {
					sheet2.SetEditable(false);
					$(".basic").each(function(i,v){v.id == "Btn2" ? $(v).hide() : "";});
				}

			} */

			sheet2.DoSearch( "${ctx}/MagamGrpCdMgr.do?cmd=getGrpCdMgrDetailList", $("#mySheetForm").serialize(), "1" );
			break;
		case "Save":
			if(sheet2.FindStatusRow("I") != ""){
			    if(!dupChk(sheet2,"code", true, true)){break;}
			}
// 			sheetLangSave(sheet2,	"tsys005",	"grcodeCd,code","codeNm");
			IBS_SaveName(document.mySheetForm,sheet2);
            sheet2.DoSave("${ctx}/MagamGrpCdMgr.do?cmd=saveGrpCdMgrDetail", $("#mySheetForm").serialize() );
            break;
		case "Insert":		
			var row = sheet2.DataInsert(0);
			sheet2.SetCellValue(row,"grcodeCd",$("#selectGroupCode").val());
			break;
		case "Copy":		sheet2.DataCopy(); break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":	sheet2.Down2Excel(); break;
		}
	}


	// LEFT 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			sheetResize();
			sheet1.LastRow() == 0 ?
			doAction2("Clear") : "";
			sheet1.SelectCell(1, "sStatus");

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// RIGHT 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		selectSheet = sheet1;

		if( OldRow != NewRow ) {
			$("#selectGroupCode").val(sheet1.GetCellValue(NewRow, "grcodeCd"));
			doAction2("Search");
		}
	}

	// LEFT 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// RIGHT 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} if( Number(Code) > 0){doAction2("Search");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		selectSheet = sheet2;
	}

	function sheet1_OnPopupClick(Row, Col){
		var	args	= new Array();
		try{
			if(Row > 0 &&  sheet1.ColSaveName(Col) == "languageNm" ){
				const parameters = {
					keyLevel : 'tsys001'
					, keyId : sheet1.GetCellValue(Row, 'languageCd')
					, keyText : sheet1.GetCellValue(Row, 'grcodeNm')
				};
				let layerModal = new window.top.document.LayerModal({
					id : 'dictLayer'
					, url : '/DictMgr.do?cmd=viewDictLayer'
					, parameters : parameters
					, width : 1000
					, height : 650
					, title : '<tit:txt mid='104444' mdef='사전 검색'/>'
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

	function sheet2_OnPopupClick(Row, Col){
		var	args	= new Array();
		try{
			if(Row > 0 &&  sheet2.ColSaveName(Col) == "languageNm" ){
				const parameters = {
					keyLevel : 'tsys005'
					, keyId : sheet2.GetCellValue(Row, 'languageCd')
					, keyText : sheet2.GetCellValue(Row, 'codeNm')
				};
				let layerModal = new window.top.document.LayerModal({
					id : 'dictLayer'
					, url : '/DictMgr.do?cmd=viewDictLayer'
					, parameters : parameters
					, width : 1000
					, height : 650
					, title : '<tit:txt mid='104444' mdef='사전 검색'/>'
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

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm">
	<input id="selectGroupCode" name="selectGroupCode" type="hidden" />
	<input id="selectMagamCode" name="selectMagamCode" type="hidden" value="1" />
	<div class="sheet_search outer">
		<table>
			<tr>
				<th><sch:txt mid='grpCd' mdef='그룹코드'/></th>
				<td>
					<input id="srchGrpCd" name="srchGrpCd" type="text" class="text" />
				</td>
				<th><sch:txt mid='grpCdNm' mdef='그룹코드명'/></th>
				<td>
					<input id="srchGrpCodeNm" name="srchGrpCodeNm" type="text" class="text" />
				</td>
				<th><sch:txt mid='withDetailCdNm' mdef='포함세부코드명'/></th>
				<td>
					<input id="srchWithDetailCodeNm" name="srchWithDetailCodeNm" type="text" class="text" />
				</td>
				<th><sch:txt mid='type' mdef='구분'/></th>
				<td>
					<select id="srchType" name="srchType" >
						<option value="" selected><sch:txt mid='all' mdef='전체'/> </option>
						<option value="C"><sch:txt mid='grpCdType1' mdef='사용자코드'/></option>
						<option value="N"><sch:txt mid='grpCdType2' mdef='시스템코드'/></option>
					</select>
				</td>
				<th><sch:txt mid='bizCd' mdef='업무구분'/></th>
				<td>  <select id="srchBizCd" name="srchBizCd" > </select> </td>
			</tr>
			<tr>
				<th><sch:txt mid='detailCd' mdef='세부코드'/></th>
				<td>
					<input id="srchDetailCode" name="srchDetailCode" type="text" class="text" />
				</td>
				<th><sch:txt mid='detailCdNm' mdef='세부코드명'/></th>
				<td>
					<input id="srchDetailCodeNm" name="srchDetailCodeNm" type="text" class="text" />
				</td>
				<th><sch:txt mid='useYn' mdef='사용유무'/></th>
				<td>
					<select id="srchUseYn" name="srchUseYn" >
						<option value="" selected><sch:txt mid='all' mdef='전체'/> </option>
						<option value="Y"><sch:txt mid='useY' mdef='사용'/></option>
						<option value="N"><sch:txt mid='useN' mdef='사용안함'/></option>
					</select>
				</td>
				<td colspan="4">
					<btn:a href="javascript:doAction1('Search');" id="srchBtn" mid="search" mdef="조회" css="button"/>
				</td>
			</tr>
		</table>
	</div>
	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='grpCd' mdef='그룹코드'/>	 </li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Save');" id="Btn1" mid="save" mdef="저장" css="basic authA"/>
							<btn:a href="javascript:doAction1('Down2Excel');" id="downBtn" mid="down2excel" mdef="다운로드" css="basic authR"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "30%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='103832' mdef='세부코드 '/></li>
						<li class="btn">
							<btn:a href="javascript:doAction2('Insert');" id="Btn2" mid="insert" mdef="입력" css="basic authA"/>
							<btn:a href="javascript:doAction2('Copy');" id="Btn2" mid="copy" mdef="복사" css="basic authA"/>
							<btn:a href="javascript:doAction2('Save');" id="Btn2" mid="save" mdef="저장" css="basic authA"/>
							<btn:a href="javascript:doAction2('Down2Excel');" id="downBtn" mid="down2excel" mdef="다운로드" css="basic authR"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>
