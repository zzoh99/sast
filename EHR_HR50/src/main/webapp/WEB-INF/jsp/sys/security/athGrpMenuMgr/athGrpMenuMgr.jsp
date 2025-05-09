<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html>	<html class="bodywrap">	<head>
	<%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<%@	include	file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@	include	file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script	type="text/javascript">

	var gPRow = "";
	var pGubun = "";

	$(function() {


		var	initdata = {};
		initdata.Cfg = {FrozenCol:12,SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata.HeaderMode	= {Sort:0,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols =	[
			{Header:"<sht:txt mid='sNo' mdef='No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			//{Header:"<sht:txt mid='chk_V385' mdef='사용'/>",				Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Left", ColMerge:0,	SaveName:"chk",	    KeyField:0,	Format:"",      UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='useYnV3' mdef='사용\n여부'/>",				Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	Format:"",		 UpdateEdit:1,	 InsertEdit:1,	 EditLen:1 },
			{Header:"<sht:txt mid='tmpUseYn' mdef='사용여부'/>",				Type:"DummyCheck",	Hidden:1,	Width:50,	Align:"Left", 	ColMerge:0,	SaveName:"tmpUseYn",	KeyField:0,	Format:"",      UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='mainMenuCd' mdef='메인메뉴코드'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mainMenuCd",	KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='priorMenuCd' mdef='상위메뉴'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"priorMenuCd",	KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='menuCd' mdef='메뉴'/>",					Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuCd",		KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",					Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuSeq",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='authScopeV2' mdef='권한그룹'/>",			Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"grpCd",		    KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",					Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"type",		    KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='koKrV5' mdef='메뉴/프로그램명'/>",			Type:"Text",		Hidden:0,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"menuNm",		KeyField:1,	Format:"",	UpdateEdit:1,	InsertEdit:0,	EditLen:100, TreeCol:1	},
			{Header:"<sht:txt mid='keyIdV1' mdef='어휘코드'/>",				Type:"Text",		Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",			Type:"Popup",		Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Left",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='prgCdV2' mdef='프로그램'/>",				Type:"Text",		Hidden:1,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"prgCd",		    KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='searchSeqV2' mdef='조건검색코드'/>",			Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"searchSeq",	KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='searchDescV1' mdef='조건검색'/>",			Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"searchDesc",	KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='dataPrgType' mdef='적용권한'/>",			Type:"Combo",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"dataPrgType",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='dataPrgTypeV2' mdef='프로그램\n권한'/>",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"dataRwType",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='inqSYmd' mdef='사용시작일'/>",				Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"inqSYmd",		KeyField:0,	Format:"Ymd",	 UpdateEdit:1,	 InsertEdit:1,	 EditLen:10 },
			{Header:"<sht:txt mid='inqEYmd' mdef='사용종료일'/>",				Type:"Date",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"inqEYmd",		KeyField:0,	Format:"Ymd",	 UpdateEdit:1,	 InsertEdit:1,	 EditLen:10 },
			{Header:"<sht:txt mid='cnt' mdef='ONEPAGE\nROWS'/>",			Type:"Int",			Hidden:1,	Width:45,	Align:"Right",  ColMerge:0,	SaveName:"cnt",			KeyField:0,	Format:"Integer",UpdateEdit:1,	 InsertEdit:1,	 EditLen:20	},
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",					Type:"Int",			Hidden:0,	Width:45,	Align:"Right",  ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"Integer",UpdateEdit:1,	 InsertEdit:1,	 EditLen:20	},
			{Header:"<sht:txt mid='popupUseYn' mdef='비밀번호\n    체크여부'/>",	Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"popupUseYn",	KeyField:0,	Format:"",		 UpdateEdit:1,	 InsertEdit:1,	 EditLen:20	},
			{Header:"LANGUAGE_CD_YN",										Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"languageCdYn",	KeyField:0,	Format:"",		 UpdateEdit:1,	 InsertEdit:1,	 EditLen:20	},
			{Header:"최종조회사원\n    유지여부",									Type:"CheckBox",	Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"lastSessionUseYn",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"자신만조회\n    여부(헤더)",								Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"searchUseYn",			KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },

			{Header:"권한대상\n대상자선택",										Type:"Popup",	 	Hidden:0, 	Width:200, Align:"Left",	  SaveName:"authSearchDesc",KeyField:0,	Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"권한대상\n조건검색순번",										Type:"Text",	 	Hidden:1, 	Width:100, Align:"Center", SaveName:"authSearchSeq",	KeyField:0,	Format:"", 		UpdateEdit:0, InsertEdit:0 },

			{Header:"신청서",													Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
		];
//		sheetSplice(initdata.Cols,12, "${localeCd2}", ["메뉴/프로그램명","135","Left"], true);
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);
		sheet1.SetColProperty("type",			  {ComboText:"<sht:txt mid='typeV3' mdef='메뉴|프로그램|조건검색|탭|링크'/>",	ComboCode:"M|P|S|T|L"} );
		sheet1.SetColProperty("dataRwType",	      {ComboText:"<sht:txt mid='dataRwTypeV3' mdef='읽기/쓰기|읽기'/>",			    ComboCode:"A|R"} );
		sheet1.SetColProperty("dataPrgType",	  {ComboText:"<sht:txt mid='dataPrgTypeV1' mdef='사용자권한|프로그램권한'/>",	    ComboCode:"U|P"} );
		sheet1.SetColProperty("popupUseYn",	      {ComboText:"<sht:txt mid='useV1|useV2' mdef='사용|사용안함'/>",				ComboCode:"Y|N"} );
		sheet1.SetTreeCheckActionMode(0);
		sheet1.SetTreeActionMode(1)

		$(window).smartresize(sheetResize);	sheetInit();

		var authGrp 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&queryId=getAthGrpMenuMgrGrpCdList","",false).codeList, "");

		$("#srchAthGrpCd").html(authGrp[2]);

		$("#srchAthGrpCd").change(function(){
			var athGrpcd = $(this).val();
			$("#athGrpCd").val(athGrpcd);
			var menuList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&queryId=getMainMuPrgMainMenuList","",false).codeList, "");
			$("#srchMainMenuCd").html(menuList[2]);

			$("#srchMainMenuCd").change();
		});

		$("#srchAthGrpCd").change();

		$("#oldGrpCd").html(authGrp[2]);
		$("#copyGrpCd").html(("<option value=''>선택</option>"+authGrp[2]));
		$("#hdnCopyGrpCd").hide();

		$("#srchMainMenuCd").change(function(){
			// doAction1("Search");
			var menuCd = $(this).val();
			$("#mainMenuCd").val(menuCd);
			doAction("Search");
		});
		$("#ckUseYn").change(function(){
			doAction("Search");
		});
		doAction("Search");

		$(".close").click(function() {
			p.self.close();
		});

		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});

		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});

		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});

		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});

	});

	function athGrpMenuChange() {

	}

	//Sheet	Action
	function doAction(sAction) {
		switch (sAction) {
			case "Search":		
				
				$("#searchUseYn").val("N");	
				if( $("#ckUseYn").is(":checked") == true) {
					$("#searchUseYn").val("Y");	
				}
				sheet1.DoSearch( "${ctx}/AthGrpMenuMgr.do?cmd=getAthGrpMenuMgrRegPopupList", $("#mySheetForm").serialize()	); 
				break;
			case "Save":
// 				sheetLangSave(sheet1, "tsys311", "mainMenuCd,priorMenuCd,menuCd,menuSeq,grpCd" , "menuNm");
				IBS_SaveName(document.mySheetForm,sheet1);
				sheet1.DoSave( "${ctx}/AthGrpMenuMgr.do?cmd=saveAthGrpMenuMgrRegPopup", $("#mySheetForm").serialize() ); break;

			//case "Insert":		insertAction();	break; //	sheet1.SelectCell(sheet1.DataInsert(0), "column1"); break;
			case "Copy":		sheet1.SelectCell(sheet1.DataCopy(), "column1"); break;
			case "Clear":		sheet1.RemoveAll(); break;
			case "Down2Excel":	sheet1.Down2Excel(); break;
			case "LoadExcel":	var	params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	//그룹간 복사
	function doAction1(sAction) {
		switch (sAction) {
		case "View":
						$("#hdnCopyGrpCd").show();
						$("#oldGrpCd").val($("#srchAthGrpCd").val());
						break;
		case "Copy":
						var tarGrpCd		 	= $("select[name=copyGrpCd] option:selected").val();
						var tarGrpCdText 		= $("select[name=copyGrpCd] option:selected").text();
						var oldGrpCd 			= $("select[name=oldGrpCd] option:selected").val();
						var oldGrpCdText 		= $("select[name=oldGrpCd] option:selected").text();
						var srchMainMenuCd 		= $("select[name=srchMainMenuCd] option:selected").val();
						var srchMainMenuCdText 	= $("select[name=srchMainMenuCd] option:selected").text();

						if(!tarGrpCd){ break; }
						if (confirm(oldGrpCdText+" 그룹의 권한그룹프로그램관리 정보("+srchMainMenuCdText+")를 \n"+tarGrpCdText+" 그룹으로 복사 하시겠습니까?\n(기존 데이터는 삭제됩니다.)")) {

							// 메인관리 그룹간 복사
							var result = ajaxCall("${ctx}/AthGrpMenuMgr.do?cmd=copyAthGrpMenuMgr", "oldGrpCd="+oldGrpCd+"&tarGrpCd="+tarGrpCd+"&srchMainMenuCd="+srchMainMenuCd, false);

							if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
								if (parseInt(result["Result"]["Code"]) >= 0) {
									alert("권한그룹프로그램관리 정보를 복사 하였습니다.");
									$("#srchAthGrpCd").val(tarGrpCd);
									doAction("Search");
								} else if (result["Result"]["Message"] != null) {
									alert(result["Result"]["Message"]);
								}
							} else {
								alert("권한그룹프로그램관리 정보 복사 오류입니다.");
							}
						}
						$("#copyGrpCd").val("");
						$("#hdnCopyGrpCd").hide();
						break;
		}
	}

	function sheet1_OnResize(lWidth, lHeight){
		try{
			}catch(ex){alert("OnResize Event Error : " + ex);}
	}

	// sheet save end event
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg){
		try{
			if (Msg != ""){
				alert(Msg);
				doAction("Search");
			}
		}catch(ex){alert("OnSaveEnd	Event Error	: "	+ ex);}
	}

	// sheet search End Event
	function sheet1_OnSearchEnd(Code, Msg,	StCode,	StMsg){
		try{
			if (Msg != ""){
				alert(Msg);
			}

			sheet1.ShowTreeLevel(-1);
			for(var r = sheet1.HeaderRows(); r<sheet1.LastRow()+sheet1.HeaderRows(); r++){

				var languageCdYn = sheet1.GetCellValue(r, "languageCdYn");

				if ( languageCdYn == "N" ){
					sheet1.SetCellBackColor(r, "languageNm", "#F7F8E0");
				}
			}
		}catch(ex){alert("OnSearchEnd Event	Error :	" +	ex);}
	}

	// sheet1 change event
	function sheet1_OnChange(Row, Col, Value) {
		try {

			if (sheet1.ColSaveName(Col) == "inqSYmd"
					|| sheet1.ColSaveName(Col) == "inqEYmd") {
				//시작일자 종료일자	체크하기
				var message = "권한별프로그램리스트의 ";
				checkNMDate(sheet1, Row, Col, message, "inqSYmd", "inqEYmd");
			}

			if (sheet1.ColSaveName(Col) == "dataPrgType") {
				if (sheet1.GetCellValue(Row, "dataPrgType") == "P") { //프로그램권한
					sheet1.SetCellValue(Row, "dataRwType", "A");
					sheet1.SetCellEditable(Row, "dataRwType", true);
				} else if (sheet1.GetCellValue(Row, "dataPrgType") == "U") { //사용자권한
					sheet1.SetCellValue(Row, "dataRwType", "");
					sheet1.SetCellEditable(Row, "dataRwType", false);
				}
			}

			var searchIncChrnCh = $("#searchIncChrn").is(":checked") == true ? "Y" : "N";
			if (searchIncChrnCh == "Y") {

				var children = sheet1.GetChildRows(Row).split("|");

				if (sheet1.ColSaveName(Col) == "useYn") {

					for (var i = 0; i < children.length; i++) {
						sheet1.SetCellValue(children[i], "useYn", sheet1.GetCellValue(Row, "useYn"));
					}
				}
			}

			if ( sheet1.ColSaveName(Col) == "languageNm" ){
				if ( sheet1.GetCellValue( Row, Col ) == "" ){
					sheet1.SetCellValue( Row, "languageCd", "");
				}
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col) {

		var args = new Array();
		var rv = null;
		try {
			if (sheet1.ColSaveName(Col) == "menuNm") {
				if (!isPopup()) {
					return;
				}
				var rv = openPopup("/Popup.do?cmd=prgMgrPopup", args, "640",
						"520");
				let layerModal = new window.top.document.LayerModal({
		               id : 'prgMgrLayer'
		             , url : "/Popup.do?cmd=viewPrgMgrLayer"
		             , width : 640
		             , height : 520
		             , title : '프로그램관리'
		             , trigger :[
		                 {
		                       name : 'prgMgrTrigger'
		                     , callback : function(rv){
		                    	 sheet1.SetCellValue(Row, "menuNm", rv["menuNm"]);
		             			 sheet1.SetCellValue(Row, "prgCd",  rv["prgCd"]);
		                     }
		                 }
		             ]
		         });
		         layerModal.show();
			}

			if (sheet1.ColSaveName(Col) == "searchDesc") {
				if (!isPopup()) return;
				let layerModal = new window.top.document.LayerModal({
					  id : 'pwrSrchMgrLayer', 
					  url : '/Popup.do?cmd=viewPwrSrchMgrLayer', 
					  width : 1100, 
					  height : 520, 
					  title : '조건 검색 관리', 
					  trigger :[
						{
							name : 'pwrTrigger', 
							callback : function(result){
								sheet1.SetCellValue(Row, "searchSeq", result.searchSeq);
								sheet1.SetCellValue(Row, "searchDesc", result.searchDesc);
							}
						}
					]
				});
				layerModal.show();
			}

			if (sheet1.ColSaveName(Col) == "languageNm") {
				if(!isPopup()) {return;}
				var parameters = {
							keyLevel: 'tsys311',
							keyId: 'languageCd',
							keyNm: 'languageNm',
							keyText: 'menuNm'
						};
				let layerModal = new window.top.document.LayerModal({
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
			if(sheet1.ColSaveName(Col) == "authSearchDesc") {
				if(!isPopup()) {return;}
				var p = {srchBizCd: '11', srchType:'3', srchDesc:'메뉴권한'};
				let layerModal = new window.top.document.LayerModal({
					  id : 'pwrSrchMgrLayer', 
					  url : '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=R', 
					  parameters : p, 
					  width : 850, 
					  height : 620, 
					  title : "<tit:txt mid='112392' mdef='조건 검색 관리'/>", 
					  trigger :[
						  {
							  name : 'pwrTrigger'
							  , callback : function(result){
								  sheet1.SetCellValue(Row, "authSearchSeq",   result.searchSeq);
								  sheet1.SetCellValue(Row, "authSearchDesc", result.searchDesc);
							  }
						  }
					  ]
				  });
				  layerModal.show();
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm">
		<input type="hidden" id="searchUseYn" name="searchUseYn" />
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th><sch:txt mid='grpNm' mdef='권한그룹'/></th>
					<td>
						<select id="srchAthGrpCd" name="srchAthGrpCd"></select>
						<%--<td> <btn:a href="javascript:doAction1('Search');" id="btnSearch" css="button" mid='110697' mdef="조회"/> </td>--%>
					</td>
					<th><tit:txt mid='등록가능메인메뉴' mdef='등록가능메인메뉴'/> </th>
					<td>
						<select id="srchMainMenuCd" name="srchMainMenuCd"></select>
					</td>
					<th><tit:txt mid='111965' mdef='사용여부' /></th>
					<td>
						<input type="checkbox" id="ckUseYn" name="ckUseYn"  style="margin-bottom:-2px;">
					</td>
					<td>
						<btn:a href="javascript:doAction('Search');" id="btnSearch" mid="110697" mdef="조회" css="btn dark"/>
					</td>
					<td>
						<a href="javascript:doAction1('View');" class="button"><tit:txt mid='110696' mdef='권한복사'/></a>
					</td>
				</tr>
				<tr id="hdnCopyGrpCd">
					<td>
						<span>From &nbsp; &nbsp;</span>
						<select id="oldGrpCd" name="oldGrpCd" class="box"></select>
					</td>
					<td style="padding-left: 100px;"><img src="/common/images/sub/ico_arrow2.png"/></td>
					<td colspan="2">
						<span>To</span>
						<select id="copyGrpCd" name="copyGrpCd" class="box" onchange="javascript:doAction1('Copy');"></select>
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
							<li	id="txt" class="txt">
								<tit:txt mid='athGrpMenuMgr' mdef='권한그룹프로그램관리'/>

								<div class="util">
									<ul>
										<li	id="btnPlus"></li>
										<li	id="btnStep1"></li>
										<li	id="btnStep2"></li>
										<li	id="btnStep3"></li>
									</ul>
								</div>
							</li>
							<li	class="btn">
							    <input type="checkbox" class="checkbox" id="searchIncChrn" name="searchIncChrn" style="vertical-align:middle;" checked="checked"/>&nbsp;<b><font style="vertical-align:middle;"><tit:txt mid='112471' mdef='하위포함'/></font></b>&nbsp;
								<btn:a href="javascript:doAction('Down2Excel');" mid="110698" mdef="다운로드" css="btn outline-gray authA"/>
								<btn:a href="javascript:doAction('Save');" mid="110708" mdef="저장" css="btn filled authA"/>
							</li>
						</ul>
					</div>
				</div> <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>
