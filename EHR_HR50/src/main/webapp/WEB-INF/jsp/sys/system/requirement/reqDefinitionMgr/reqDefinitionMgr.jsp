<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>요구사항관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

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

		//var searchModuleCd    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99995"), "<tit:txt mid='103895' mdef='전체'/>");//모듈코드(S99995)
		//var cModuleCd         = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99995"), "");//모듈코드(S99995)
		var searchModuleCd    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrModuleCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		var cModuleCd         = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrModuleCdList",false).codeList, "");//모듈코드(S99995)

		var searchMainMenuCd  = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrMainMenuCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");//메뉴코드
		var searchGrpCd       = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrGrpCdList",false).codeList, "");//권한코드
		var searchSecCd       = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99993"), "<tit:txt mid='103895' mdef='전체'/>");//개발종류(S99993)
		var searchDevSecCd    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99994"), "<tit:txt mid='103895' mdef='전체'/>");//개발구분(S99994)
		var searchDevStatusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99996"), "");//개발상태(S99996)
		var searchDesignStatusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99996"), "");//설계상태(S99996)

		var plList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAtnatNameList&workCd=20",false).codeList, ""); //PL리스트
		var devList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAtnatNameList&workCd=30",false).codeList, ""); //개발자리스트

		$("#searchModuleCd").html(searchModuleCd[2]);
		$("#cModuleCd").html("<option value='ALL'>전체</option>"+cModuleCd[2]);
		//$("#searchMainMenuCd").html(searchMainMenuCd[2]);
		$("#searchSecCd").html(searchSecCd[2]);
		$("#searchDevSecCd").html(searchDevSecCd[2]);
		$("#searchDevStatusCd").html(searchDevStatusCd[2]+"<option value='empty'>미입력</option>");
		$("#searchDevStatusCd").select2({placeholder:"<tit:txt mid='103895' mdef='전체'/>"});
		$("#searchDesignStatusCd").html(searchDesignStatusCd[2]+"<option value='empty'>미입력</option>");
		$("#searchDesignStatusCd").select2({placeholder:"<tit:txt mid='103895' mdef='전체'/>"});

		$("#cGrpCd").html(searchGrpCd[2]);

//=========================================================================================================================================

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msAll/* msHeaderOnly */,FrozenCol:11};
		initdata1.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			//{Header:"회사구분코드(TORG900)",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"모듈",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"moduleCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"메인메뉴",					Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mainMenuCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"상위메뉴코드",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"priorMenuCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"상위메뉴명",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"priorMenuNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"메뉴코드",					Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"menuCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"메뉴SEQ",				Type:"Int",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"menuSeq",			KeyField:1,	Format:"#####",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='prgNmV2' mdef='메뉴명'/>",					Type:"PopupEdit",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"menuNm",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"권한",					Type:"Combo",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"grpCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='prgCd_V6500' mdef='프로그램ID'/>",				Type:"Text",		Hidden:1,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"prgCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"Process ID",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"priorProId",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"Process",				Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"priorProNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"Program ID",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"proId",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"Program",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"proNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"개발종류",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"secCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"개발구분",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"devSecCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"AS-IS",				Type:"Text",		Hidden:1,	Width:400,	Align:"Left",	ColMerge:0,	SaveName:"asIs",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000, MultiLineText:1, Wrap:0, ToolTip:0 },
			{Header:"TO-BE",				Type:"Text",		Hidden:0,	Width:400,	Align:"Left",	ColMerge:0,	SaveName:"toBe",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000, MultiLineText:1, Wrap:0, ToolTip:0 },
			{Header:"요구사항",					Type:"Text",		Hidden:1,	Width:400,	Align:"Left",	ColMerge:0,	SaveName:"reqCon",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000, MultiLineText:1, Wrap:1, ToolTip:0 },
			{Header:"현업",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"partner",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='chargeNameV2' mdef='담당자'/>",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"perInChar",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='regDate_V4669' mdef='작성일'/>",					Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"writeYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"M/D",				Type:"Float",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"md",		KeyField:0,	Format:"",	PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"설계계획시작일",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"designSdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"설계계획종료일",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"designEdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"설계완료일",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"designFinishYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"설계상태",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"designStatusCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"개발계획시작일",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"planSdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"개발계획종료일",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"planEdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"개발완료일",				Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"finishYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"개발자",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"devName",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"개발상태",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"devStatusCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"변경요구사항",				Type:"Text",		Hidden:0,	Width:400,	Align:"Left",	ColMerge:0,	SaveName:"chReqCon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000, MultiLineText:1, Wrap:1, ToolTip:0 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",					Type:"Text",		Hidden:1,	Width:400,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000, MultiLineText:1, Wrap:1, ToolTip:0 },
			{Header:"<sht:txt mid='chkdateV2' mdef='최종수정시간'/>",				Type:"Text",		Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"최종수정자",				Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkid",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetEditEnterBehavior("newline");

		sheet1.SetColProperty("moduleCd", 		{ComboText:"|"+searchModuleCd[0], 		ComboCode:"|"+searchModuleCd[1]} );
		sheet1.SetColProperty("mainMenuCd", 	{ComboText:"|"+searchMainMenuCd[0], 	ComboCode:"|"+searchMainMenuCd[1]} );
		sheet1.SetColProperty("grpCd", 			{ComboText:"|"+searchGrpCd[0], 			ComboCode:"|"+searchGrpCd[1]} );
		sheet1.SetColProperty("secCd", 			{ComboText:searchSecCd[0], 			ComboCode:searchSecCd[1]} );
		sheet1.SetColProperty("devSecCd", 		{ComboText:searchDevSecCd[0], 		ComboCode:searchDevSecCd[1]} );
		sheet1.SetColProperty("devStatusCd", 	{ComboText:"|"+searchDevStatusCd[0], 	ComboCode:"|"+searchDevStatusCd[1]} );
		sheet1.SetColProperty("designStatusCd", {ComboText:"|"+searchDesignStatusCd[0], 	ComboCode:"|"+searchDesignStatusCd[1]} );
		sheet1.SetColProperty("perInChar", 		{ComboText:"|"+plList[0], 	ComboCode:"|"+plList[1]} );
		sheet1.SetColProperty("devName", 		{ComboText:"|"+devList[0], 	ComboCode:"|"+devList[1]} );

		getManagerList();
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		$("#searchMenuNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if(!checkList()) return ;
						sheet1.RemoveAll();
						$("#multiDevStatusCd").val(getMultiSelect($("#searchDevStatusCd").val()));
						$("#multiDesignStatusCd").val(getMultiSelect($("#searchDesignStatusCd").val()));
						sheet1.DoSearch( "${ctx}/ReqDefinitionMgr.do?cmd=getReqDefinitionMgrList", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!dupChk(sheet1,"moduleCd|mainMenuCd|priorMenuCd|menuCd|menuSeq|grpCd", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet1);
						sheet1.DoSave( "${ctx}/ReqDefinitionMgr.do?cmd=saveReqDefinitionMgr", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
						sheet1.SetCellValue( row, "enterCd", "${ssnEnterCd}");
						break;
		case "Copy":
						var row = sheet1.DataCopy();
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9"/* ,ExcelRowHeight:"40" */, KeyFieldMark:0 };
						sheet1.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						sheet1.LoadExcel(params);
						break;
		case "DownTemplate":
						sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"",ExcelFontSize:"9",ExcelRowHeight:"40"});
						break;
		case "Proc":
						var cModuleCd = $("#cModuleCd option:selected").val();
						var cGrpCd    = $("#cGrpCd option:selected").val();
						var cChkYn    = $("#cChkYn").is(":checked") == true ? "Y" : "N";
						var cMsg      = $("#cChkYn").is(":checked") == true ? "기존 데이터는 유지하여" : "현재 데이터 삭제 후 새로";

						if ( cModuleCd == "" ){
							alert("모듈을 선택하십시오.");
							break;
						}

						if ( cGrpCd == "" ){
							alert("권한을 선택하십시오.");
							break;
						}

						var param = "cModuleCd=" + cModuleCd;
							param = param + "&cGrpCd=" + cGrpCd;
							param = param + "&cChkYn=" + cChkYn;


						if (confirm( cMsg + "\r\n생성하시겠습니까?")) {

							try{

								var rtn = ajaxCall("${ctx}/ReqDefinitionMgr.do?cmd=procP_SYS_REQ_CRE",param,false);

								if(rtn.Result.Code == "") {
									alert(rtn.Result.Message);
									doAction1("Search");
								}else{
									alert(rtn.Result.Message);
									break;
								}
							} catch (ex){
								alert("저장중 스크립트 오류발생." + ex);
							}
						}
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

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {

			if(sheet1.ColSaveName(Col) == "menuNm") {

				if(!isPopup()) {return;}

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

								sheet1.SetCellValue(Row, "mainMenuCd", 	rv["mainMenuCd"]	 );
								sheet1.SetCellValue(Row, "priorMenuCd", 	rv["priorMenuCd"]	 );
								sheet1.SetCellValue(Row, "priorMenuNm", 	rv["priorMenuNm"]	 );
								sheet1.SetCellValue(Row, "menuCd", 		rv["menuCd"]		 );
								sheet1.SetCellValue(Row, "menuSeq", 		rv["menuSeq"]		 );
								sheet1.SetCellValue(Row, "menuNm", 		rv["menuNm"]		 );
								sheet1.SetCellValue(Row, "prgCd", 		rv["prgCd"]			 );
								sheet1.SetCellValue(Row, "grpCd", 		rv["grpCd"]			 );
								sheet1.SetCellValue(Row, "moduleCd", 		rv["moduleCd"]			 );
							}
						}
					]
				});
				layerModal.show();
			}

		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
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

	function getMonthEndDate(year, month) {
		var dt = new Date(year, month, 0);
		return dt.getDate();
	}
	
	function getManagerList() {

		<%--var managerList = ajaxCall("${ctx}/ReqDefinitionMgr.do?cmd=getReqManagerList",param,false);--%>
		
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<input type="hidden" id="multiDevStatusCd" name="multiDevStatusCd" />
	<input type="hidden" id="multiDesignStatusCd" name="multiDesignStatusCd" />
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>모듈</th>
			<td>
				<select id="searchModuleCd" name="searchModuleCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<th class="hide"><tit:txt mid='113332' mdef='메인메뉴'/></th>
			<td class="hide">
				<select id="searchMainMenuCd" name="searchMainMenuCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<th><tit:txt mid='104233' mdef='메뉴명'/></th>
			<td>
				<input id="searchMenuNm" name="searchMenuNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<th>개발종류</th>
			<td>
				<select id="searchSecCd" name="searchSecCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<th>개발구분</th>
			<td>
				<select id="searchDevSecCd" name="searchDevSecCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<th>설계진행상태</th>
			<td>
				<select id="searchDesignStatusCd" name="searchDesignStatusCd" class="box" onchange="javascript:doAction1('Search');" multiple></select>
			</td>
			<th>개발진행상태</th>
			<td>
				<select id="searchDevStatusCd" name="searchDevStatusCd" class="box" onchange="javascript:doAction1('Search');" multiple></select>
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a>
			</td>
		</tr>
		</table>
		</div>
	</div>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">
				요구사항관리
			</li>
			<li class="btn">
			<c:if test="${authPg eq 'A'}">
				<!-- 기존데이터유지 :  --><input class="hide" type="checkbox" id="cChkYn" name="cChkYn" value="Y" checked="checked"  style="position: relative; top: 3px;" />
				모듈 : <select id="cModuleCd" name="cModuleCd" class="box"></select>
				권한 : <select id="cGrpCd" name="cGrpCd" class="box"></select>
			</c:if>
				<a href="javascript:doAction1('Proc');" 			class="btn filled authA"><tit:txt mid='114525' mdef='생성'/></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
				<a href="javascript:doAction1('Down2Excel');" 		class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
				<a href="javascript:doAction1('Insert');" 			class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
				<a href="javascript:doAction1('Save');" 			class="btn soft authA"><tit:txt mid='104476' mdef='저장'/></a>
			</li>
		</ul>
		</div>
	</div>
</form>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
