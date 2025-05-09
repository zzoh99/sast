<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>로그인메뉴관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<link rel="stylesheet" type="text/css" href="/common/css/font-awesome.css">
	<style>
		p.icon { font-size: 35px; color: #333; height: 80px; line-height: 80px; }
	</style>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});
//=========================================================================================================================================
		var searchGrpCd      = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLoginMenuMgrGrpCdComboList",false).codeList, "");
		var searchMenuGrpCd  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S90300"), "<tit:txt mid='103895' mdef='전체'/>");//그룹코드(S90300)
		$("#searchGrpCd").html(searchGrpCd[2]);
		$("#oldGrpCd").html(searchGrpCd[2]);
		$("#copyGrpCd").html(("<option value=''>선택</option>"+searchGrpCd[2]));
		$("#hdnCopyGrpCd").hide();
//=========================================================================================================================================\

		var initdata0 = {};
		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata0.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"grpCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"그룹",												Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"menuGrpCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='reportNm' mdef='출력명'/>",			Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"prtMenuNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300,	MultiLineText:1 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",			Type:"Text",		Hidden:1,Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"이미지\r\nPATH",										Type:"Popup",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"imgPath",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"이미지",												Type:"Image",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"img",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	ImgWidth:60},
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Int",				Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"orderNo",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet0, initdata0);sheet0.SetEditable("${editable}");sheet0.SetVisible(true);sheet0.SetCountPosition(4);

		sheet0.SetAutoRowHeight(0);
		sheet0.SetDataRowHeight(80);
		sheet0.SetColProperty("menuGrpCd", 				{ComboText:"|"+searchMenuGrpCd[0], ComboCode:"|"+searchMenuGrpCd[1]} );
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"grpCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"그룹",												Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"menuGrpCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='menuSeq_V2267' mdef='메뉴순번'/>",		Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"seqNo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='reportNm' mdef='출력명'/>",			Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"prtMenuNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",			Type:"Text",		Hidden:1,Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"이미지\r\nCLASS",									Type:"Popup",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"imgClass",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"이미지",												Type:"Html",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"img",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	ImgWidth:60},
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",			Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"orderNo",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetAutoRowHeight(0);
		sheet1.SetDataRowHeight(80);
		sheet1.SetColProperty("menuGrpCd", 				{ComboText:"|"+searchMenuGrpCd[0], ComboCode:"|"+searchMenuGrpCd[1]} );

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"grpCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='menuSeq_V2267' mdef='메뉴순번'/>",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seqNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"그룹",												Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"menuGrpCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"프로그램Code",										Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prgCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"mainMenuCd",										Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mainMenuCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='prgNmV1' mdef='프로그램명'/>",			Type:"PopupEdit",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"prgNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='reportNm' mdef='출력명'/>",			Type:"Text",		Hidden:0,	Width:140,	Align:"Left",	ColMerge:0,	SaveName:"prtMenuNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300 },
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",			Type:"Text",		Hidden:1,Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사용\r\n여부",										Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"강조\r\n표시\r\n여부",									Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"strYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",			Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"orderNo",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		doAction0("Search");
		doAction1('Search');
	});
	
	//Sheet0 Action
	function doAction0(sAction) {
		switch (sAction) {
		case "Search":
						if(!checkList()) return ;
						sheet0.RemoveAll();
						sheet0.DoSearch( "${ctx}/LoginMenuMgr.do?cmd=getLoginMenuMgrFirstList", $("#searchForm").serialize() );
						break;
		case "Save":
						if(!dupChk(sheet0,"menuGrpCd", true, true)){break;}
						IBS_SaveName(document.searchForm,sheet0);
						sheet0.DoSave( "${ctx}/LoginMenuMgr.do?cmd=saveLoginMenuMgrFirst", $("#searchForm").serialize());
						break;
		case "Insert":
						var row = sheet0.DataInsert(0);
						sheet0.SetCellValue(row, "grpCd", $("#searchGrpCd option:selected").val());
						break;
		case "Copy":
						var row = sheet0.DataCopy();
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet0, ['Html']);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet0.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						sheet0.LoadExcel(params);
						break;
		case "DownTemplate":
						sheet0.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"",ExcelFontSize:"9",ExcelRowHeight:"20"});
						break;
		}
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

						if(!checkList()) return ;
						$('#pSeqNo').val("");
						sheet1.RemoveAll();
						sheet2.RemoveAll();
						sheet1.DoSearch( "${ctx}/LoginMenuMgr.do?cmd=getLoginMenuMgrSecondList", $("#searchForm").serialize() );
						break;
		case "Save":
						//if(!dupChk(sheet1,"seqNo|menuGrpCd", true, true)){break;}
						IBS_SaveName(document.searchForm,sheet1);
						sheet1.DoSave( "${ctx}/LoginMenuMgr.do?cmd=saveLoginMenuMgrSecond", $("#searchForm").serialize());
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
						sheet1.SetCellValue(row, "grpCd", $("#searchGrpCd option:selected").val());
						break;
		case "Copy":
						var row = sheet1.DataCopy();
						sheet1.SetCellValue( row, "seqNo", "" );
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1, ['Html']);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
						sheet1.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						sheet1.LoadExcel(params);
						break;
		case "DownTemplate":
						sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"", ExcelFontSize:"9", ExcelRowHeight:"20"});
						break;
		}
	}

	//sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":

						if(!checkList()) return ;
						sheet2.DoSearch( "${ctx}/LoginMenuMgr.do?cmd=getLoginMenuMgrThirdList", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!dupChk(sheet2,"seqNo|menuGrpCd|prgCd", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet2);
						sheet2.DoSave( "${ctx}/LoginMenuMgr.do?cmd=saveLoginMenuMgrThird", $("#sendForm").serialize());
						break;
		case "Insert":
						var sRow = sheet1.FindStatusRow("I|U|D");

						if ( sRow != "" ){
							alert("입력저장 또는 삭제중인행이 있습니다. \r\n저장 후 진행하시기바랍니다.");
							break;
						}

						
						var grpCd      = $("#pGrpCd").val();
						var seqNo = $("#pSeqNo").val();
						var menuGrpCd  = $("#pMenuGrpCd").val();


						if ( grpCd == "" || seqNo == "" || menuGrpCd == "" ){

							alert("선택된 메뉴명이 없습니다.");
							break;

						}else{

							var row = sheet2.DataInsert(0);
							sheet2.SetCellValue( row, "grpCd", grpCd);
							sheet2.SetCellValue( row, "seqNo", seqNo);
							sheet2.SetCellValue( row, "menuGrpCd", menuGrpCd);
						}
						break;
		case "Copy":
						var sRow = sheet1.FindStatusRow("I|U|D");
						if ( sRow != "" ){
							alert("입력저장 또는 삭제중인행이 있습니다. \r\n저장 후 진행하시기바랍니다.");
							break;
						}
						var seqNo = $("#pSeqNo").val();
						var menuGrpCd = $("#pMenuGrpCd").val();
						if ( seqNo == "" || menuGrpCd == "" ){

							alert("선택된 메뉴명이 없습니다.");
							break;

						}
						var row = sheet2.DataCopy();
						break;

						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet2, ['Html']);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
						sheet2.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						sheet2.LoadExcel(params);
						break;
		case "DownTemplate":
						sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"", ExcelFontSize:"9", ExcelRowHeight:"20"});
						break;
		}
	}
	
	//그룹간 복사
	function doAction3(sAction) {
		switch (sAction) {
		case "View":
						$("#hdnCopyGrpCd").show();
						$("#oldGrpCd").val($("#searchGrpCd").val());
						break;
		case "Copy":
						var tarGrpCd = $("select[name=copyGrpCd] option:selected").val();
						var tarGrpCdText = $("select[name=copyGrpCd] option:selected").text();
						var oldGrpCd = $("select[name=oldGrpCd] option:selected").val();
						var oldGrpCdText = $("select[name=oldGrpCd] option:selected").text();
						
						if(!tarGrpCd){ break; }
						if (confirm(oldGrpCdText+" 그룹의 메인관리 정보를 \n"+tarGrpCdText+" 그룹으로 복사 하시겠습니까?\n(기존 데이터는 삭제됩니다.)")) {
							
							// 메인관리 그룹간 복사
							var result = ajaxCall("${ctx}/LoginMenuMgr.do?cmd=copyLoginMenuMgr", "oldGrpCd="+oldGrpCd+"&tarGrpCd="+tarGrpCd, false);
	
							if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
								if (parseInt(result["Result"]["Code"]) >= 0) {
									alert("메인그룹관리 정보를 복사 하였습니다.");
									$("#searchGrpCd").val(tarGrpCd);
									doAction0("Search");
									doAction1('Search');
								} else if (result["Result"]["Message"] != null) {
									alert(result["Result"]["Message"]);
								}
							} else {
								alert("메인그룹관리 정보 복사 오류입니다.");
							}
						}
						$("#copyGrpCd").val("");
						$("#hdnCopyGrpCd").hide();
						break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet0_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet0_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction0("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet0_OnClick(Row, Col, Value) {
		try{
			if(sheet0.ColSaveName(Col) == "imgPath" && Row >= sheet0.HeaderRows()){
				if(!isPopup()) {return;}
				var title = "이미지관리";
		  		var w 		= 800;
				var h 		= 750;
				var url 	= "${ctx}/LoginMenuMgr.do?cmd=viewLoginMenuFirstLayer&authPg=${authPg}";
				var layerModal = new window.top.document.LayerModal({
					  id : 'loginMenuFirstLayer',
					  parameters : {"imgPath" : sheet0.GetCellValue(Row, 'imgPath')},
					  url : url,
					  width : w, 
					  height : h,
					  title : title,
					  trigger: [
						  {
							  name: 'loginMenuFirstLayerTrigger',
							  callback: function(rv) {
								  sheet0.SetCellValue(Row, "imgPath", rv.imgPath);
								  sheet0.SetCellValue(Row, "img",	  rv.imgPath);
							  }
						  }
					  ]
				});
				layerModal.show();
			}
		} catch(ex) { alert("OnClick Event Error : " + ex); }
	}
	
	function sheet0_OnPopupClick(Row, Col){
		try{
			var colName = sheet0.ColSaveName(Col), args = {};
			if (sheet0.ColSaveName(Col) == "languageNm" && Row >= sheet0.HeaderRows() ) {
				if(!isPopup()) {return;}
				const parameters = {keyLevel : 'tsys975'
								  , keyId : 'languageCd'
								  , keyText : 'prtMenuNm'
								  , keyNm: 'languageNm'};
				var layerModal = new window.top.document.LayerModal({
					id : 'dictLayer', 
					url : '/DictMgr.do?cmd=viewDictLayer', 
					parameters : parameters, 
					width : 1000, 
					height : 650, 
					title : "<tit:txt mid='104444' mdef='사전 검색'/>",
					trigger :[
						{
							name : 'dictTrigger', 
							callback : function(result){
								sheet0.SetCellValue(Row, 'languageCd', result.keyId);
								var chkData = { "keyLevel": parameters.keyLevel, "languageCd": result.keyId};
								var dtWord = ajaxCall( "${ctx}/LangId.do?cmd=getLangCdTword",chkData,false);
								sheet0.SetCellValue(Row, 'languageNm', dtWord.map.seqNumTword);
							}
						}
					]
				});
				layerModal.show();
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function sheet0_OnChange(Row, Col, Value){
		try {
			if ( sheet0.ColSaveName(Col) == "languageNm" ){
				if ( sheet0.GetCellValue( Row, Col ) == "" ){
					sheet0.SetCellValue( Row, "languageCd", "");
				}
			}
		} catch(ex){
			alert("OnChange Event Error : " + ex);
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
	
	function sheet1_OnClick(Row, Col, Value) {
		try{

			if(sheet1.ColSaveName(Col) == "imgClass" && Row >= sheet1.HeaderRows()){
				if(!isPopup()) {return;}
				var url = '/LoginMenuMgr.do?cmd=viewLoginMenuSecondLayer&authPg=${authPg}';
				var w = 800;
				var h = 750;
				var title = '이미지 선택';
				var layerModal = new window.top.document.LayerModal({
					id : 'loginMenuSecondLayer',
					parameters : {"imgClass" : sheet1.GetCellValue(Row, 'imgClass')},
					url : url, 
					width : w, 
					height : h, 
					title : title,
					trigger :[
						{
							name : 'loginMenuSecondLayerTrigger', 
							callback : function(rv){
								sheet1.SetCellValue(Row, "imgClass", rv.imgClass);
								sheet1.SetCellValue(Row, "img", '<p class="icon"><i class="'+ rv.imgClass + '"></i></p>');
							}
						}
					]
				});
				layerModal.show();
			}
			
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	function sheet1_OnPopupClick(Row, Col){
		try{
			var colName = sheet1.ColSaveName(Col), args = {};
			
			if (sheet1.ColSaveName(Col) == "languageNm" && Row >= sheet1.HeaderRows() ) {
				if(!isPopup()) {return;}
				const parameters = {keyLevel: 'tsys973', keyId: 'languageCd', keyNm: 'languageNm', keyText: 'prtMenuNm'};
				var layerModal = new window.top.document.LayerModal({
					id : 'dictLayer', 
					url : '/DictMgr.do?cmd=viewDictLayer', 
					parameters : parameters, 
					width : 1000, 
					height : 650, 
					title : "<tit:txt mid='104444' mdef='사전 검색'/>",
					trigger :[
						{
							name : 'dictTrigger', 
							callback : function(result){
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

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{

			if( OldRow != NewRow ) {

				var grpCd = sheet1.GetCellValue(NewRow,"grpCd");
				var seqNo = sheet1.GetCellValue(NewRow,"seqNo");
				var menuGrpCd = sheet1.GetCellValue(NewRow,"menuGrpCd");

				if ( grpCd != "" || seqNo != "" || menuGrpCd != "" ){
					$('#pGrpCd').val(grpCd);
					$('#pSeqNo').val(seqNo);
					$('#pMenuGrpCd').val(menuGrpCd);
					doAction2("Search");
				}else{
					$('#pGrpCd').val("");
					$('#pSeqNo').val("");
					$('#pMenuGrpCd').val("");
				}
			}

		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
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
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	
	function sheet2_OnPopupClick(Row, Col){
		try{
			var ColName = sheet2.ColSaveName(Col)
			var colName = sheet2.ColSaveName(Col), args = {};
			if (ColName == "languageNm" && Row >= sheet2.HeaderRows() ) {
				if(!isPopup()) {return;}
				const parameters = {keyLevel: 'tsys974', keyId: 'languageCd', keyNm: 'languageNm', keyText: 'prgNm'};
				var layerModal = new window.top.document.LayerModal({
					id : 'dictLayer', 
					url : '/DictMgr.do?cmd=viewDictLayer', 
					parameters : parameters, 
					width : 1000, 
					height : 650, 
					title : "<tit:txt mid='104444' mdef='사전 검색'/>",
					trigger :[
						{
							name : 'dictTrigger', 
							callback : function(result){
								sheet2.SetCellValue(Row, 'languageCd', result.keyId);
								var chkData = { "keyLevel": parameters.keyLevel, "languageCd": result.keyId};
								var dtWord = ajaxCall( "${ctx}/LangId.do?cmd=getLangCdTword",chkData,false);
								sheet2.SetCellValue(Row, 'languageNm', dtWord.map.seqNumTword);
							}
						}
					]
				});
				layerModal.show();
			}
			
			if(	ColName == "prgNm"	) {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "ReqDefinitionMgrPop";

				var title = "<tit:txt mid='104233' mdef='메뉴명'/>";
				var w = 840;
				var h = 820;
				var url = "/ReqDefinitionMgr.do?cmd=viewReqDefinitionMgrLayer";
				var layerModal = new window.top.document.LayerModal({
					id : 'reqDefinitionMgrLayer', 
					url : url,  
					width : w, 
					height : h, 
					title : title,
					trigger :[
						{
							name : 'reqDefinitionMgrLayerTrigger', 
							callback : function(rv){
								sheet2.SetCellValue(Row, "prgCd",		rv.prgCd	);
								sheet2.SetCellValue(Row, "prgNm",		rv.menuNm );
								sheet2.SetCellValue(Row, "prtMenuNm",	rv.menuNm );
								sheet2.SetCellValue(Row, "mainMenuCd",  rv.mainMenuCd );
							}
						}
					]
				});
				layerModal.show();
				
				//openPopup("/ReqDefinitionMgr.do?cmd=viewReqDefinitionMgrPop",	args, "840","820");
			}
			
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function sheet2_OnChange(Row, Col, Value){
		try {
			if ( sheet2.ColSaveName(Col) == "languageNm" ){
				if ( sheet2.GetCellValue( Row, Col ) == "" ){
					sheet2.SetCellValue( Row, "languageCd", "");
				}
			}
			
		} catch(ex){
			alert("OnChange Event Error : " + ex);
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
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

<form name="sendForm" id="sendForm" method="post">
	<input type="hidden" id="pGrpCd" name="searchGrpCd" value="" />
	<input type="hidden" id="pSeqNo" name="searchSeqNo" value="" />
	<input type="hidden" id="pMenuGrpCd" name="searchMenuGrpCd" value="" />
</form>

<form name="searchForm" id="searchForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='authorityV1' mdef='권한그룹'/></th>
			<td>
				<select id="searchGrpCd" name="searchGrpCd" class="box" onchange="javascript:doAction0('Search');doAction1('Search');"></select>
			</td>
			<td>
				<a href="javascript:doAction0('Search');doAction1('Search');" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a>
			</td>
			<td colspan="2">
				<a href="javascript:doAction3('View');" class="btn filled"><tit:txt mid='110696' mdef='권한복사'/></a>
			</td>
		</tr>
		<tr id="hdnCopyGrpCd">
			<th>From &nbsp; &nbsp;</th>
			<td>
				<select id="oldGrpCd" name="oldGrpCd" class="box"></select>
			</td>
			<td style="padding-left: 35px;"><img src="/common/images/sub/ico_arrow2.png"/></td>
			<th>To</th>
			<td>
				<select id="copyGrpCd" name="copyGrpCd" class="box" onchange="javascript:doAction3('Copy');"></select>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="33%" />
			<col width="35%" />
			<col width="32%" />
		</colgroup>
		<tr>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">메인그룹관리</li>
						<li class="btn">
							<a href="javascript:doAction0('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<!-- <a href="javascript:doAction1('DownTemplate')" 	class="btn outline-gray authA"><tit:txt mid='113684' mdef='양식다운로드'/></a> -->
							<!-- <a href="javascript:doAction1('LoadExcel')" 	class="btn outline-gray authA"><tit:txt mid='104242' mdef='업로드'/></a> -->
							<a href="javascript:doAction0('Copy')" 			class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
							<a href="javascript:doAction0('Insert')" 		class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
							<a href="javascript:doAction0('Save')" 			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet0", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">메인세부그룹 Master </li>
						<li class="btn">
							<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<!-- <a href="javascript:doAction1('DownTemplate')" 	class="btn outline-gray authA"><tit:txt mid='113684' mdef='양식다운로드'/></a> -->
							<!-- <a href="javascript:doAction1('LoadExcel')" 	class="btn outline-gray authA"><tit:txt mid='104242' mdef='업로드'/></a> -->
							<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
							<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
							<a href="javascript:doAction1('Save')" 			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>

			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">메인세부그룹 Detail </li>
						<li class="btn">
							<a href="javascript:doAction2('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<!-- <a href="javascript:doAction2('DownTemplate')" 	class="btn outline-gray authA"><tit:txt mid='113684' mdef='양식다운로드'/></a> -->
							<!-- <a href="javascript:doAction2('LoadExcel')" 	class="btn outline-gray authA"><tit:txt mid='104242' mdef='업로드'/></a> -->
							<a href="javascript:doAction2('Copy')" 			class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
							<a href="javascript:doAction2('Insert')" 		class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
							<a href="javascript:doAction2('Save')" 			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
