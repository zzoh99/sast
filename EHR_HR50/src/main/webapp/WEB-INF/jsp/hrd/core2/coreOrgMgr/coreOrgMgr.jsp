<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		initTabsLine(); //탭 하단 라인 추가
		$( "#tabs" ).tabs();

		$("#baseDate").datepicker2();

		//조직도 select box
		var searchSdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList, "");	//조직도
		$("#searchSdate").html(searchSdate[2]);
		$("#baseDate").val( "${curSysYyyyMMddHyphen}" );

		//조직원을 가져올 때 과거 / 미래 조직도에 따라 Sdate를 넣을지 Sysdate를 넣을지 구분하기 위하여 Edate도 불러온다. by JSG
		var searchEdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeEdate",false).codeList, "");	//조직도종료일
		$("#searchEdate").html(searchEdate[2]);

		var result = ajaxCall("${ctx}/CoreOrgMgr.do?cmd=getCoreOrgMgrMemoTORG103","",false);
		for(var i = 0; i < result["DATA"].length; i++) {
			if( $("#searchSdate").val() == result["DATA"][i]["code"] ) {
				var memo = result["DATA"][i]["codeNm"] ;
				if(memo != "")	$("#memoText").html("( "+memo+" )") ;
				break ;
			}
		}

		// 트리레벨 정의
		$("#btnPlus").toggleClass("minus");

		$("#btnPlus").click(function() {
			//sheet1.ShowTreeLevel(-1);
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet1.ShowTreeLevel(-1):sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep1").click(function()	{
			//sheet1.ShowTreeLevel(0, 1);
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(0, 2);
		});
		$("#btnStep2").click(function()	{
			//sheet1.ShowTreeLevel(1,2);
			$("#btnPlus").removeClass("minus");
			sheet1.ShowTreeLevel(2,3);
		});
		$("#btnStep3").click(function()	{
			//sheet1.ShowTreeLevel(-1);
			if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				sheet1.ShowTreeLevel(-1);
			}
		});

		$("#searchSdate").bind("change",function(event){
			//현재선택된 Sdate값으로 Edate를 불러오기위해 사용
			$("#searchEdate").val( $.trim( $("#searchSdate option:selected").val()) ) ;
			//메모
			for(var i = 0; i < result["DATA"].length; i++) {
				if( $("#searchSdate").val() == result["DATA"][i]["code"] ) {
					var memo = result["DATA"][i]["codeNm"] ;
					if(memo != "")	$("#memoText").html("( "+memo+" )") ;
					else if(memo == "") $("#memoText").html("") ;
					break ;
				}
			}
			doAction1("Search");
		});

		$("#findText").bind("keyup",function(event){
			if( event.keyCode == 13){ findOrgNm() ; }
		});

		//공통코드 한번에 조회
		const grpCds = "CD1300";
		codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");


		init_sheet1(); //조직도
		init_sheet2(); //핵심인재관리자

		$(window).smartresize(userSheetResize); userSheetInit();

		doAction1("Search");
	});


	//--------------------------
	// sheet1 조직도
	//--------------------------
	function init_sheet1() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='priorOrgCdV1' mdef='상위조직코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"priorOrgCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",			Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,	Cursor:"Pointer",    TreeCol:1,  LevelSaveName:"sLevel" },
			{Header:"<sht:txt mid='chiefSabun' mdef='조직장사번'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"chiefSabun",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='chiefName' mdef='조직장성명'/>",		Type:"Text",      Hidden:0,  Width:80,    Align:"Left",  ColMerge:0,   SaveName:"chiefName",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='orgType' mdef='조직유형'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgTypeNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='inoutType' mdef='내외구분'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"inoutTypeNm",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='inoutTypeV2' mdef='조직구분'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"objectTypeNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"sdate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",			Type:"Date",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"edate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='locationCd' mdef='근무지'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"locationNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"memo",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"해당여부",										Type:"CheckBox",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"targetYn",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1,	FalseValue:"N",	TrueValue:"Y" }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	}

	//--------------------------
	// sheet2 핵심인재관리자
	//--------------------------
	function init_sheet2() {

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='detailV1' mdef='프로필'/>",		Type:"Image",     	Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun", KeyField:1, UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name", UpdateEdit:0, InsertEdit:1 },
			{Header:"orgCd",											Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"orgCd", UpdateEdit:0, InsertEdit:0 },
			{Header:"소속",												Type:"Text",		Hidden:0,	Width:150,			Align:"Left",	ColMerge:0,	SaveName:"orgNm", UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"statusNm", UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm", UpdateEdit:0, InsertEdit:0 },
			{Header:"구분",												Type:"Combo",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"mgrType", KeyField:1, UpdateEdit:0, InsertEdit:1, EditLen:10 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		sheet2.SetColProperty("mgrType",  	{ComboText:"|"+codeLists["CD1300"][0], ComboCode:"|"+codeLists["CD1300"][1]} );

		//Autocomplete
		$(sheet2).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet2.SetCellValue(gPRow, "name",		rv["name"]);
						sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet2.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"]);
						sheet2.SetCellValue(gPRow, "statusNm",	rv["statusNm"]);
					}
				}
			]
		});
	}

	//-----------------------------------------------------------------------------------
	//		Sheet1 Action
	//-----------------------------------------------------------------------------------
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if(!checkList()) return ;
				sheet1.DoSearch( "${ctx}/CoreOrgMgr.do?cmd=getCoreOrgMgrList", $("#srchFrm").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/CoreOrgMgr.do?cmd=saveCoreOrgMgr", $("#srchFrm").serialize() );
				break ;
			case "Down2Excel":
				sheet1.Down2Excel();
				break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		Sheet2 Action
	//-----------------------------------------------------------------------------------
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				//if ($("#searchType").is(":checked")) {
				//조직의 시작~종료일 사이에 현재일자가 들어가는지 아닌지를 구분하여 구분파라매터를 던짐
				if( parseInt("${curSysYyyyMMdd}") >= parseInt( $("#searchEdate").val() ) &&  parseInt("${curSysYyyyMMdd}") <= parseInt( $("#searchEdate option:selected").text() ) ) {
					$("#searchSht2Gbn").val("1") ;//시작~종료일 사이에 오늘이 들어감
				} else {
					$("#searchSht2Gbn").val("0") ;//시작~종료일 사이에 오늘이 들어가지 않음
				}

				if(document.getElementById("searchType").checked == false){
					sheet2.DoSearch( "${ctx}/CoreOrgMgr.do?cmd=getCoreOrgManagerList1", $("#srchFrm").serialize() );
				} else {
					sheet2.DoSearch( "${ctx}/CoreOrgMgr.do?cmd=getCoreOrgManagerList2", $("#srchFrm").serialize() );
				}
				break;
			case "Save":
				IBS_SaveName(document.srchFrm, sheet2);
				sheet2.DoSave( "${ctx}/CoreOrgMgr.do?cmd=saveCoreOrgManagerList", $("#srchFrm").serialize() );
				break ;
			case "Insert":
				const row = sheet2.DataInsert(0);
				sheet2.SetCellValue(row, "orgCd", sheet1.GetCellValue(sheet1.GetSelectRow(), "orgCd"));
				break;
			case "Down2Excel":
				sheet2.Down2Excel();
				break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			$('#searchOrgCd').val(sheet1.GetCellValue(1,"orgCd"));

			getSheetData();
			userSheetResize();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }

	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") alert(Msg);
			if (Code > 0) doAction1("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			$('#searchOrgCd').val(sheet1.GetCellValue(Row,"orgCd"));
			if(Row > 0 && sheet1.ColSaveName(Col) == "orgNm"){
				getSheetData();
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	//-----------------------------------------------------------------------------------
	//		sheet2 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } userSheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(Row > 0 && sheet2.ColSaveName(Col) == "detail"){
				profilePopup(Row) ;
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") alert(Msg);
			if (Code > 0) doAction2("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 시트에서 폼으로 세팅.
	function getSheetData() {
		var row = sheet1.GetSelectRow();
		if(row == 0) {
			return;
		}
		//기본정보 타이틀란에 소속명 표시
		$('#orgNmTxt').html(sheet1.GetCellValue(row,"orgNm"));
		//기본정보란에 표시
		$('#orgCd').html(sheet1.GetCellValue(row,"orgCd"));
		$('#orgNm').html(sheet1.GetCellValue(row,"orgNm"));
		$('#inoutType').html(sheet1.GetCellValue(row,"inoutTypeNm"));
		$('#objectType').html(sheet1.GetCellValue(row,"objectTypeNm"));
		$('#orgType').html(sheet1.GetCellValue(row,"orgTypeNm"));
		$('#sdate').html(sheet1.GetCellText(row,"sdate"));
		$('#edate').html(sheet1.GetCellText(row,"edate"));
		$('#locationCd').html(sheet1.GetCellValue(row,"locationNm"));
		if (sheet1.GetCellValue(row,"targetYn") === "Y")
			$('#targetYn').prop("checked", true);
		else
			$('#targetYn').prop("checked", false);

		doAction2("Search");
	}

	// 폼에서 시트으로 세팅.
	function setSheetData() {

		var row = sheet1.GetSelectRow();
		if(row == 0) {
			return;
		}
		sheet1.SetCellValue(row, "targetYn", $("#targetYn").is(":checked")?"Y":"N" );

		doAction1("Save");
	}

	/**
	 * 조직원 프로필 window open event
	 */
	function profilePopup(Row){
		if(!isPopup()) {return;}

		var w 		= 610;
		var h 		= 450;
		var url 	= "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfileLayer&authPg=${authPg}";
		// var args 	= new Array();
		// args["sabun"] 		= sheet2.GetCellValue(Row, "sabun");

		var p = {
			sabun : sheet2.GetCellValue(Row, "sabun")
		};

		let layerModal = new window.top.document.LayerModal({
			id : 'EmpProfileLayer'
			, url : url
			, parameters : p
			, width : w
			, height : h
			, title : 'Profile'
			, trigger :[
				{
					name : 'EmpProfileTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
		// openPopup(url,args,w,h);
	}

	/*엔터검색 by JSG*/
	function findOrgNm() {
		var startRow = sheet1.GetSelectRow()+1 ;
		startRow = (startRow >= sheet1.LastRow() ? 1 : startRow ) ;
		var selectPosition = sheet1.FindText("orgNm", $("#findText").val(), startRow, 2) ;
		if(selectPosition == -1) {
			sheet1.SetSelectRow(1) ;
			alert("<msg:txt mid='alertOrgTotalMgrV2' mdef='마지막에 도달하여 최상단으로 올라갑니다.'/>") ;
		} else {
			sheet1.SetSelectRow(selectPosition) ;
		}
		$('#searchOrgCd').val(sheet1.GetCellValue(selectPosition,"orgCd"));
		getSheetData();
	}

	/*탭을 여는 경우 시트 리사이징 안되는 문제 해결 by JSG*/
	function onTabResize() {
		$(window).smartresize(userSheetResize); userSheetInit();
	}

	function startView() {
		//바디 로딩 완료후 화면 보여줌(로딩과정에서 화면 이상하게 보이는 현상 해결 by JSG)
		$("#tabs").removeClass("hide");
	}

	function searchSdatePopup(){
		try {
			if(!isPopup()) {return;}

			var args    = new Array();

			gPRow = "";
			pGubun = "searchSdatePopup";

			openPopup("/OrgTotalMgr.do?cmd=viewOrgTotalMgrPop", args, "440","420", function(rv) {
				$("#searchSdate").val(rv.sdate);
				$("#searchOrgChartNm").val(rv.orgChartNm);
				$("#baseDate").val(rv.baseYmd);

				doAction1("Search");
			});
		} catch(ex) { alert("Open Popup Event Error : " + ex); }
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

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



	/* 탭 안의 Sheet 높이가 자동으로 100%이 안되므로 수동 처리 함. 2020.06.01*/
	function userSheetResize(){

		sheetResize();
		const sheetMainH = $(".wrapper").outerHeight(true) - $("#srchFrm").outerHeight(true);
		$(".sheet_main").css("height", sheetMainH + "px");
		const tabDivH = sheetMainH - $("#orgInfoFrm").outerHeight(true);
		$("#tabDiv").css("height", tabDivH + "px");
		$(".ibsheet").each(function() {
			if($(this).attr("fixed") == "false" && this.id != "DIV_sheet1") {
				var h = $(this).height();
				$(this).height(tabDivH-99); //조직기본정보 높이 차감
			}
		});
	}

	/* 탭 안의 Sheet 높이가 자동으로 100%이 안되므로 수동 처리 함. 2020.06.01*/
	function userSheetInit(){

		sheetInit();
		const sheetMainH = $(".wrapper").outerHeight(true) - $("#srchFrm").outerHeight(true);
		$(".sheet_main").css("height", sheetMainH + "px");
		const tabDivH = sheetMainH - $("#orgInfoFrm").outerHeight(true);
		$("#tabDiv").css("height", tabDivH + "px");
		$(".ibsheet").each(function() {
			if($(this).attr("fixed") == "false" && this.id != "DIV_sheet1") {
				var h = $(this).height();
				$(this).height(tabDivH-99);  //조직기본정보 높이 차감
			}
		});
	}
</script>
</head>
<body class="hidden" onload="startView()" >
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchOrgCd" name="searchOrgCd">
		<input type="hidden" id="searchSht2Gbn" name="searchSht2Gbn">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
                        <th><tit:txt mid='104535' mdef='기준일'/></th>
	                    <td>
                             <input type="text" id="baseDate" name="baseDate" class="date" value="" />
                        </td>
						<th>조직도명 </th>
						<td>
							<input id="searchOrgChartNm" name="searchOrgChartNm" type="text" class="text readonly required" style="width: 250px;" readonly value="${chartMap.orgChartNm}" />
							<input type="hidden" id="searchSdate" name="searchSdate" value="${chartMap.sdate}" />

							<a onclick="javascript::searchSDatePopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<!-- <a onclick="$('#searchSdate,#searchOrgChartNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a> -->
						</td>

							<!-- <select id="searchSdate" name ="searchSdate" class="w250"></select> -->

							<span class="hide"><select id="searchEdate" name ="searchEdate"></select></span>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
							&nbsp;&nbsp;&nbsp;<span id="memoText" class="hide"></span>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<table class="sheet_main" style="table-layout: fixed;">
	<colgroup>
		<col width="390px" />
		<col width="*" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="sheet_title inner">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='112713' mdef='조직도 '/>&nbsp;
						<div class="util">
						<ul>
							<li	id="btnPlus"></li>
							<li	id="btnStep1"></li>
							<li	id="btnStep2"></li>
							<li	id="btnStep3"></li>
						</ul>
						</div>
					</li>
					<li class="btn">
						<tit:txt mid='201705020000185' mdef='명칭검색'/>
						<input id="findText" name="findText" type="text" class="text" >
						<!-- <a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a> -->
					</li>
					<li class="btn">
					</li>
				</ul>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>

		<td class="sheet_right">
			<form id="orgInfoFrm" name="orgInfoFrm" >
				<div class="sheet_title ">
					<ul>
						<li class="txt"><tit:txt mid='114268' mdef='기본정보 : '/> <span id="orgNmTxt" name="orgNmTxt"></span></li>
						<li class="btn">
							<btn:a href="javascript:setSheetData();" 	css="basic authA" mid='110708' mdef="저장"/>
						</li>
					</ul>
				</div>
				<table class="table w100p" id="htmlTable">
					<colgroup>
						<col width="12%" />
						<col width="25%" />
						<col width="16%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th><tit:txt mid='113573' mdef='조직코드'/></th>
						<td>
							<span id="orgCd"></span>
						</td>
						<th><tit:txt mid='104514' mdef='조직명'/></th>
						<td>
							<span id="orgNm"></span>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='113225' mdef='조직유형'/></th>
						<td>
							<span id="orgType"></span>
						</td>
						<th><tit:txt mid='112508' mdef='시작일/종료일'/></th>
						<td>
							<span id="sdate"></span> ~ <span id="edate"></span>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='112176' mdef='내외구분'/></th>
						<td>
							<span id="inoutType"></span>
						</td>
						<th><tit:txt mid='104281' mdef='근무지'/></th>
						<td>
							<span id="locationCd"></span>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='114269' mdef='조직구분'/></th>
						<td>
							<span id="objectType"></span>
						</td>
						<th>해당여부</th>
						<td>
							<input type="checkbox" id="targetYn" name="targetYn" class="checkbox"/>
						</td>
					</tr>
				</table>
			</form>
			<div id="tabDiv">
				<div id="tabs" style="height:100%;border:none;">
					<div class='ui-tabs-nav-line'></div> <!-- 탭 하단 라인 -->

					<ul class="tab_bottom">
						<li onclick="onTabResize();"><a href="#tabs-1">핵심인재관리자</a></li>
					</ul>

					<div id="tabs-1">
						<div class="sheet_title inner">
							<ul>
								<li id="txt" class="txt">핵심인재관리자</li>
								<li class="btn">
								    <input type="checkbox" class="checkbox" id="searchType" name="searchType" onClick="doAction2('Search');" style="vertical-align:middle;"/>&nbsp;<b><tit:txt mid='104304' mdef='하위조직포함'/></b>&nbsp;
									<btn:a href="javascript:doAction2('Search')" 	css="basic authR" mid='110697' mdef="조회"/>
									<btn:a href="javascript:doAction2('Insert')" 	css="basic authA" mid='110700' mdef="입력"/>
									<btn:a href="javascript:doAction2('Save')" 	css="basic authA" mid='110708' mdef="저장"/>
									<a href="javascript:doAction2('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
								</li>
							</ul>
						</div>
						<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
					</div>
				</div> <!--  tabs -->
			</div>
		</td>
	</tr>
	</table>
</div>
</body>
</html>
