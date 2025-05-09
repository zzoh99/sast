<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='104252' mdef='조건 검색 관리(Admin)'/></title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var srchBizCd = null;
	var srchTypeCd = null;
	var gPRow = "";
	var pGubun = "";

	/*Sheet 기본 설정 */
	$(function() {
		srchBizCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCommonMainMenuList2&searchMainMenuCd"), "<tit:txt mid='103895' mdef='전체'/>");
		srchTypeCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R20010"), "<tit:txt mid='103895' mdef='전체'/>");
		chartType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99101"), "<tit:txt mid='103895' mdef='전체'/>");

		//Condtion Combo setting
		$("#srchBizCd").html(srchBizCd[2]);	//업무 구분
		$("#srchType").html(srchTypeCd[2]);	//검색 구분

		"${result.mainMenuCd}" == 11 ? "" : $("#srchBizCd").val("${result.mainMenuCd}") ;	//업무 구분
		"${result.mainMenuCd}" == 11 ? "" : $("#srchType").val("2") ;	//검색 구분

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:7, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus"		,Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",		Type:"Image",		Hidden:0,					Width:45,			Align:"Center",	ColMerge:0,	SaveName:"dbItemDesc"	,Sort:0, Cursor:"Pointer" },
			{Header:"<sht:txt mid='searchSeqV1' mdef='검색순번'/>",			Type:"Text",		Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"searchSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='searchType' mdef='검색구분'/>",			Type:"Combo",		Hidden:0,					Width:150,			Align:"Center",	ColMerge:0,	SaveName:"searchType",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='searchDesc' mdef='검색설명'/>",			Type:"Text",		Hidden:0,					Width:150,			Align:"Left",	ColMerge:0,	SaveName:"searchDesc",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='bizCd' mdef='업무구분'/>",				Type:"Combo",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"bizCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='viewCd' mdef='조회업무코드'/>",			Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"viewCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='viewDesc' mdef='조회업무'/>",			Type:"Popup",		Hidden:0,					Width:150,			Align:"Left",	ColMerge:0,	SaveName:"viewDesc",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='chartType' mdef='차트형태'/>",			Type:"Combo",		Hidden:0,					Width:50,			Align:"Left",	ColMerge:0,	SaveName:"chartType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='chartDisValue' mdef='차트수치'/>",		Type:"Text",		Hidden:0,					Width:50,			Align:"Left",	ColMerge:0,	SaveName:"chartDisValue",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:15 },
			{Header:"<sht:txt mid='commonUseYn' mdef='공통사용\n여부'/>",	Type:"Combo",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"commonUseYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='individualYn' mdef='개인별\n/키워드'/>",	Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"individualYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, DefaultValue:"N" },
			{Header:"<sht:txt mid='chkdateV1' mdef='최종수정일'/>",			Type:"Date",		Hidden:1,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"chkdate",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"<sht:txt mid='viewNm' mdef='VIEW_NM'/>",				Type:"Text",		Hidden:1,					Width:0,			Align:"Center",	ColMerge:0,	SaveName:"viewNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='copySearchSeq' mdef='복사_SEARCH_SEQ'/>",Type:"Text",		Hidden:1,					Width:0,			Align:"Center",	ColMerge:0,	SaveName:"copySearchSeq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		];
		//초기화
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetEditable("${editable}");
		sheet1.SetColProperty("bizCd",		{ComboText:"|"+srchBizCd[0],	ComboCode:"|"+srchBizCd[1]} );
		sheet1.SetColProperty("searchType",	{ComboText:"|"+srchTypeCd[0],	ComboCode:"|"+srchTypeCd[1]} );
		sheet1.SetColProperty("commonUseYn",{ComboText:"YES|NO",		ComboCode:"Y|N"} );
		sheet1.SetColProperty("individualYn",{ComboText:"개인별(헤더표시)|키워드",		ComboCode:"Y|K"} );
		sheet1.SetColProperty("chartType",	{ComboText:"|"+chartType[0],	ComboCode:"|"+chartType[1]} );
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetCountPosition(4);

		//sheet1.SetDataLinkMouse("sStatus", 1);
		sheet1.SetDataLinkMouse("dbItemDesc", 1);

		$("#srchBizCd").change(function(){
			doAction("Search");
		});

		$("#srchType").change(function(){
			doAction("Search");
		});

		$("#srchDesc").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			if("${result.mainMenuCd}" != 11) {
				$("#srchBizCd").attr("disabled", false);
				$("#srchType").attr("disabled", false);
			}
			sheet1.DoSearch( "${ctx}/PwrSrchMgr.do?cmd=getPwrSrchMgrList", $("#sheet1Form").serialize() ); break;
		case "Save":
			if(sheet1.FindStatusRow("I") != ""){
			    //if(!dupChk(sheet1,"searchSeq", true, true)){break;}
			}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/PwrSrchMgr.do?cmd=savePwrSrchMgr", $("#sheet1Form").serialize() );
			break;
		case "Insert":		//입력
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "sabun","${ssnSabun}");
			sheet1.SetCellValue(Row, "owner","${ssnName}");
			sheet1.SelectCell(Row, "searchSeq");
			break;
		case "Copy":		//행 복사
			var copySearchSeq = sheet1.GetCellValue(sheet1.GetSelectRow(), "searchSeq");
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "copySearchSeq",copySearchSeq);
			sheet1.SetCellValue(Row, "searchSeq","");
			sheet1.SelectCell(Row, "searchSeq");
			break;
		case "Down2Excel":	//엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
			/*대 메뉴가 '시스템'이 아닌경우 업무구분은 변경불가하며 검색구분은 히든처리
			Ordered - CBS / Coding - JSG*/
			if("${result.mainMenuCd}" != 11) {
				$("#srchBizCd").attr("disabled", true);
				$("#srchType").attr("disabled", true);
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			if( Code > -1 ) doAction("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error "+ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
		    selectSheet = sheet1;
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

  	function sheet1_OnClick(Row, Col, Value){
  		var status = sheet1.GetCellValue(Row,"sStatus") ;
  		var srchType = sheet1.GetCellValue(Row, "searchType");
		try{
			if(Row > 0 && sheet1.ColSaveName(Col) == "dbItemDesc"){
		        if(status != "I" ){
		            if(status != "U"){
		                if( srchType == "2" ){ //업무별 조건검색
		                    if(sheet1.GetCellValue(Row, "viewCd") != ""){
								bizPopup(Row,"${ctx}/PwrSrchBizPopup.do?cmd=viewPwrSrchBizLayer&authPg=${authPg}", 1000, 800);
		                    } else{ alert("조회업무를 먼저 선택 후 저장하세요."); }
		                }else if( srchType == "3"){ //ADMIN 조건검색
		                	adminPopup(Row,"${ctx}/PwrSrchAdminPopup.do?cmd=viewPwrSrchAdminLayer&authPg=${authPg}", 1000, 800);
		                }
		            }else{ alert("<msg:txt mid='alertBeSaveReflectCheckV1' mdef='저장을 먼저하세요.'/>"); }
		        }else{ alert("<msg:txt mid='alertBeSaveReflectCheckV1' mdef='저장을 먼저하세요.'/>"); }
	    	}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
  	function bizPopup(Row, url, w, h){
  		if(!isPopup()) {return;}
  		var title = "<tit:txt mid='104342' mdef='조건 검색 설정'/>";
  		var p = {srchSeq:  sheet1.GetCellValue(Row, 'searchSeq'),
  		  		 viewCd :  sheet1.GetCellValue(Row, 'viewCd'),
  		  		 viewNm :  sheet1.GetCellValue(Row, 'viewNm'),
  		  		 viewDesc: sheet1.GetCellValue(Row, 'viewDesc'),
  		  		 srchDesc: sheet1.GetCellValue(Row, 'searchDesc') };
  		var layer = new window.top.document.LayerModal({
			id: 'pwrSrchBizLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: title
		});
		layer.show();
	}
	
  	function adminPopup(Row, url, w, h){
  		if(!isPopup()) {return;}
  		var searchSeq  = sheet1.GetCellValue( sheet1.GetSelectRow(), "searchSeq" ) ;
		var searchDesc = sheet1.GetCellValue( sheet1.GetSelectRow(), "searchDesc" ) ;
		var chartType  = sheet1.GetCellValue( sheet1.GetSelectRow(), "chartType" ) ;
		const p = { searchSeq, searchDesc, chartType };
		var pwrSrchAdminLayer = new window.top.document.LayerModal({
			id: 'pwrSrchAdminLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: "<tit:txt mid='pwrSrchMgr' mdef='조건검색'/>"
  		});
		pwrSrchAdminLayer.show();
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if(Row > 0 &&  sheet1.ColSaveName(Col) == "viewDesc" ){
				if(!isPopup()) {return;}
				var title = "<tit:txt mid='pwrSrchVwPop1' mdef='업무별 조건검색 뷰항목 조회'/>";
				var url = "${ctx}/PwrSrchVwPopup.do?cmd=viewPwrSrchVwLayer&authPg=${authPg}";
				var w = 720;
				var h = 600;
				var layer = new window.top.document.LayerModal({
					id: 'pwrSrchVwLayer',
					url: url,
					width: w,
					height: h,
					title: title,
					trigger: [
						{
							name: 'pwrSrchVwLayerTrigger',
							callback: function(rv) {
								sheet1.SetCellValue(Row, "viewCd", 	rv["viewCd"] );
								sheet1.SetCellValue(Row, "viewNm", 	rv["viewNm"] );
								sheet1.SetCellValue(Row, "viewDesc",	rv["viewDesc"] );
							}
						}
					]
				});
				layer.show();
				
  		    }
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	function sheet1_OnChange(Row,Col,Value){
		//차트형태 미선택시 차트수치 지움
		if ( sheet1.ColSaveName(Col) == "chartType" && !Value ) {
			sheet1.SetCellValue(Row, "chartDisValue", "");
		}
	}
</script>


</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<input id="userId" name="userId" type="hidden"/>
	<input id="enterCd" name="enterCd" type="hidden"/>
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='114394' mdef='업무구분'/></th>
			<td>
				<select id="srchBizCd" name="srchBizCd" onChange=""></select>
			</td>
			<th><tit:txt mid='112961' mdef='검색구분'/></th>
			<td>
				<select id="srchType" name="srchType" onChange=""></select>
			</td>
			<th>검색순번/<tit:txt mid='112606' mdef='검색설명'/></th>
			<td>
				<input id="srchDesc" name ="srchDesc" type="text" class="text w150" />
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
				<li id="txt" class="txt"><tit:txt mid='pwrSrchMgrAdmin' mdef='조건검색관리(Admin)'/></li>
				<li class="btn">
					<a href="javascript:doAction('Down2Excel')" class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
					<btn:a href="javascript:doAction('Copy')" css="btn outline-gray authA" mid='110696' mdef="복사"/>
					<btn:a href="javascript:doAction('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doAction('Save')" css="btn filled authA" mid='110708' mdef="저장"/>
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



