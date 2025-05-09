<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
// 		$("#sdate").datepicker2({startdate:"sdate"});	//수정불가하도록 처리[21.05.24]
// 		$("#edate").datepicker2({enddate:"edate"});		//수정불가하도록 처리[21.05.24]

		$("#baseDate").datepicker2();
        //$("#baseDate").val( "${curSysYyyyMMddHyphen}" );
        
		//조직도 select box
		var searchSdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList, "");	//조직도
		$("#searchSdate").html(searchSdate[2]);
		//$("#baseDate").val(formatDate(searchSdate[1].split("|")[0], "-"));
		$("#baseDate").val( "${curSysYyyyMMddHyphen}" );
		
		
		//조직원을 가져올 때 과거 / 미래 조직도에 따라 Sdate를 넣을지 Sysdate를 넣을지 구분하기 위하여 Edate도 불러온다. by JSG
		var searchEdate = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeEdate",false).codeList, "");	//조직도종료일
		$("#searchEdate").html(searchEdate[2]);

		var result = ajaxCall("${ctx}/SuccKeyOrgMgr.do?cmd=getorgTotalMgrMemoTORG103",queryId="getorgTotalMgrMemoTORG103",false);
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
	    var grpCds = "W20010,W20050,W20030,H20020,H20030,H20010,R10010";
	    codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
		locationCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, " ");	//LOCATION

		$("#orgType").html(codeLists["W20010"][2]);
		$("#inoutType").html(codeLists["W20050"][2]);
		$("#objectType").html(codeLists["W20030"][2]);
		$("#locationCd").html(locationCd[2]);
		

	    init_sheet1(); //조직도
	    //init_sheet2(); //지직원
	    //init_sheet3(); //조직이력
	    //init_sheet4(); //조직장
	    //init_sheet5(); //R&R
	    //init_sheet6();  //공동조직장
	    init_licenseSheet(); //자격/면허
	    init_capaSheet(); //역량
	    init_keywordSheet(); // 키워드
	    
		$(window).smartresize(userSheetResize); userSheetInit();
		doAction1("Search");
		
        $(".tab_bottom li").click(function() {
            $('.tab_bottom li').removeClass('active');
            $(this).addClass('active');
        });
        
        doActionJob("Search");
        doActionLicense("Search");
        doActionCapa("Search");
        doActionKeyword("Search");
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
			{Header:"<sht:txt mid='orgType' mdef='조직유형'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"orgType",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='inoutType' mdef='내외구분'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"inoutType",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='inoutTypeV2' mdef='조직구분'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"objectType",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"sdate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",			Type:"Date",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"edate",        KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='locationCd' mdef='근무지'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"locationCd",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"memo",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"Key Position",			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"succOx",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100},
			{Header:"Key Position",			Type:"CheckBox",      Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"succYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, TrueValue:"Y", FalseValue:"N"  }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

	}

	//--------------------------
	// sheet2 조직원
	//--------------------------
	function init_sheet2() {

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='detailV1' mdef='프로필'/>",		Type:"Image",     	Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun", UpdateEdit:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name", UpdateEdit:0 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"alias", UpdateEdit:0 },
			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",		Type:"Text",		Hidden:0,	Width:150,			Align:"Left",	ColMerge:0,	SaveName:"orgNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"statusNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:Number("${jwHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm", UpdateEdit:0 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4); 
		sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
	}

	//--------------------------
	// sheet3 조직개편
	//--------------------------
	function init_sheet3() {
		initdata = {};
		initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sdateV6' mdef='조직개편일|조직개편일'/>",				Type:"Date",     Hidden:0,  Width:90,   Align:"Center",  	ColMerge:1,   SaveName:"sdate",             KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='num' mdef='순번|순번'/>",							Type:"Text",     Hidden:1,  Width:30,   Align:"Center",    	ColMerge:1,   SaveName:"num",         		KeyField:0,   CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='detailV2' mdef='통합/\n분할내역|통합/\n분할내역'/>",		Type:"Image",    Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='changeGubun' mdef='변경구분|변경구분'/>",					Type:"Combo",    Hidden:0,  Width:80,   Align:"Center",  	ColMerge:1,   SaveName:"changeGubun",       KeyField:1,   CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='appOrgCdV2' mdef='조직코드|조직코드'/>",					Type:"Text",     Hidden:0,  Width:80,   Align:"Center",    	ColMerge:1,   SaveName:"orgCd",             KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgNmPre' mdef='조직명|변경전'/>",						Type:"Popup",	 Hidden:0,  Width:150,  Align:"Left",    	ColMerge:1,   SaveName:"orgNmPre",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='orgNmAfter' mdef='조직명|변경후'/>",						Type:"Text",     Hidden:0,  Width:150,  Align:"Left",    	ColMerge:1,   SaveName:"orgNmAfter",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='orgEngNmPre' mdef='영문조직명|변경전'/>",					Type:"Text",     Hidden:0,  Width:150,  Align:"Left",    	ColMerge:1,   SaveName:"orgEngNmPre",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='orgEngNmAfter' mdef='영문조직명|변경후'/>",					Type:"Text",     Hidden:0,  Width:150,  Align:"Left",    	ColMerge:1,   SaveName:"orgEngNmAfter",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='priorOrgCdPre' mdef='상위조직|변경전(코드)'/>",				Type:"Text",     Hidden:0,  Width:80,   Align:"Center",    	ColMerge:1,   SaveName:"priorOrgCdPre",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='priorOrgNmPre' mdef='상위조직|변경전(명)'/>",					Type:"Text",     Hidden:0,  Width:150,  Align:"Left",    	ColMerge:1,   SaveName:"priorOrgNmPre",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='priorOrgCdAfter' mdef='상위조직|변경후(코드)'/>",				Type:"Text",     Hidden:0,  Width:80,   Align:"Center",    	ColMerge:1,   SaveName:"priorOrgCdAfter",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='priorOrgNmAfter' mdef='상위조직|변경후(명)'/>",					Type:"Popup",	 Hidden:0,  Width:150,  Align:"Left",    	ColMerge:1,   SaveName:"priorOrgNmAfter",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='objectTypeV1' mdef='조직구분|조직구분'/>", 					Type:"Combo",    Hidden:0,  Width:60,  	Align:"Center",  	ColMerge:1,   SaveName:"objectType",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='inoutTypeV1' mdef='내외구분|내외구분'/>",					Type:"Combo",    Hidden:0,  Width:60,  	Align:"Center",  	ColMerge:1,   SaveName:"inoutType",    		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='orgTypeV1' mdef='조직유형|조직유형'/>",					Type:"Combo",    Hidden:0,  Width:60,  	Align:"Center",  	ColMerge:1,   SaveName:"orgType",      		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='locationCdV6' mdef='LOCATION|LOCATION'/>", 			Type:"Combo",    Hidden:0,  Width:80,  	Align:"Center",   	ColMerge:1,   SaveName:"locationCd",   		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='directYnV1' mdef='직속\n여부|직속\n여부'/>",				Type:"Combo",    Hidden:1,  Width:60,   Align:"Center",  	ColMerge:1,   SaveName:"directYn",          KeyField:0,   CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='orderSeq' mdef='순서|순서'/>",						Type:"Int",      Hidden:0,  Width:30,   Align:"Center",   	ColMerge:1,   SaveName:"seq",               KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='orgLevelV1' mdef='화상조직도\n레벨|화상조직도\n레벨'/>",		Type:"Int",      Hidden:0,  Width:60,   Align:"Center",   	ColMerge:1,   SaveName:"orgLevel",          KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
			{Header:"<sht:txt mid='memoV7' mdef='설명|설명'/>",						Type:"Text",     Hidden:0,  Width:200,  Align:"Left",    	ColMerge:1,   SaveName:"memo",             	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 }
		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable(false);sheet3.SetVisible(true);sheet3.SetCountPosition(4);sheet3.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		sheet3.SetColProperty("changeGubun", 		{ComboText:"|조직신설|조직명칭변경|상부조직변동|조직폐지|조직통합|조직분할", ComboCode:"|1|2|3|4|5|6"} );	//변경구분
		sheet3.SetColProperty("orgType", 			{ComboText:"|"+codeLists["W20010"][0], ComboCode:"|"+codeLists["W20010"][1]} );	//조직유형
		sheet3.SetColProperty("inoutType", 			{ComboText:"|"+codeLists["W20050"][0], ComboCode:"|"+codeLists["W20050"][1]} );	//내외구분
		sheet3.SetColProperty("objectType", 		{ComboText:"|"+codeLists["W20030"][0], ComboCode:"|"+codeLists["W20030"][1]} );	//조직구분
		sheet3.SetColProperty("locationCd", 		{ComboText:"|"+locationCd[0], ComboCode:"|"+locationCd[1]} );	//LOCATION

		sheet3.SetColProperty("directYn", {ComboText:"|YES|NO", ComboCode:"|Y|N"} );


	}

	//--------------------------
	// sheet4 조직장
	//--------------------------
	function init_sheet4() {
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",	Type:"Date",      	Hidden:0,  Width:100,    Align:"Center",    ColMerge:0,   SaveName:"sdate",	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",	Type:"Date",      	Hidden:0,  Width:100,    Align:"Center",    ColMerge:0,   SaveName:"edate",	KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",		Type:"Text",    	Hidden:1,  Width:0,     Align:"Left",    ColMerge:0,   SaveName:"orgCd", 	KeyField:1,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,  Width:60,	Align:"Center",	 ColMerge:0,   SaveName:"sabun", 	KeyField:1,	  UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,  Width:60,	Align:"Center",	 ColMerge:0,   SaveName:"name", 	UpdateEdit:0, InsertEdit:1 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",		Hidden:Number("${aliasHdn}"),  Width:60,	Align:"Center",	 ColMerge:0,   SaveName:"alias", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",	Type:"Text",		Hidden:1,  Width:100,	Align:"Left",	 ColMerge:0,   SaveName:"orgNm", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Combo",		Hidden:0,  Width:80,	Align:"Center",	 ColMerge:0,   SaveName:"jikchakCd",UpdateEdit:1, InsertEdit:1 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Combo",		Hidden:Number("${jwHdn}"),  Width:80,	Align:"Center",	 ColMerge:0,   SaveName:"jikweeCd", UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Combo",		Hidden:Number("${jgHdn}"),  Width:80,	Align:"Center",	 ColMerge:0,   SaveName:"jikgubCd", UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='jobCdV1' mdef='직무코드'/>",	Type:"Text",		Hidden:1,  Width:60,	Align:"Center",	 ColMerge:0,   SaveName:"jobCd", 	UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='jobCd' mdef='직무'/>",		Type:"Text",		Hidden:0,  Width:100,	Align:"Left",	 ColMerge:0,   SaveName:"jobNm", 	UpdateEdit:0, InsertEdit:0 }
		]; IBS_InitSheet(sheet4, initdata);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(4);
		sheet4.SetColProperty("jikchakCd", 			{ComboText:"|"+codeLists["H20020"][0], ComboCode:"|"+codeLists["H20020"][1]} );	//직책구분
		sheet4.SetColProperty("jikweeCd", 			{ComboText:"|"+codeLists["H20030"][0], ComboCode:"|"+codeLists["H20030"][1]} );	//직위구분
		sheet4.SetColProperty("jikgubCd", 			{ComboText:"|"+codeLists["H20010"][0], ComboCode:"|"+codeLists["H20010"][1]} );	//직급구분

		//Autocomplete
		$(sheet4).sheetAutocomplete({
			Columns: [{   ColSaveName : "name"  //조직장
					    , CallbackFunc: function(returnValue){
		      				var rv = $.parseJSON('{' + returnValue+ '}');
		      				sheet4.SetCellValue(gPRow, "sabun", 	rv["sabun"]);
		      				sheet4.SetCellValue(gPRow, "name", 		rv["name"]);
		      				sheet4.SetCellValue(gPRow, "jikgubCd", 	rv["jikgubCd"]);
		      				sheet4.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
		      				sheet4.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
		  				  }
			          }]
		});

	}

	//--------------------------
	// sheet5
	//--------------------------
	function init_sheet5() {
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"세부n내역|세부n내역",Type:"Image",     	Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
			{Header:"<sht:txt mid='sDate' mdef='시작일자|시작일자'/>",Type:"Date",      	Hidden:1,  Width:60,    Align:"Left",    ColMerge:0,   SaveName:"sDate",	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='appOrgNmV4' mdef='조직명|조직명'/>",	Type:"Text",    	Hidden:1,  Width:0,     Align:"Left",    ColMerge:0,   SaveName:"orgCd", 	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='wYmd' mdef='작성일자|작성일자'/>",Type:"Date",      	Hidden:0,  Width:60,    Align:"Center",    ColMerge:0,   SaveName:"wYmd",	KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='jikgubCdV3' mdef='작성자|직급'/>",	 Type:"Combo",		Hidden:0,  Width:60,	Align:"Center",	 ColMerge:0,   SaveName:"jikgubCd", UpdateEdit:0 },
			{Header:"<sht:txt mid='sSabun' mdef='작성자|사번'/>",	 Type:"Text",		Hidden:0,  Width:80,	Align:"Center",	 ColMerge:0,   SaveName:"sSabun", UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='nameV4' mdef='작성자|성명'/>",	 Type:"Text",		Hidden:0,  Width:80,	Align:"Center",	 ColMerge:0,   SaveName:"name", UpdateEdit:0, InsertEdit:1 },
			{Header:"작성자|호칭", Type:"Text",		Hidden:Number("${aliasHdn}"),  Width:80,	Align:"Center",	 ColMerge:0,   SaveName:"alias", UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='jikgubCdV3' mdef='작성자|직급'/>", Type:"Text",		Hidden:Number("${jgHdn}"),  Width:80,	Align:"Center",	 ColMerge:0,   SaveName:"jikgubCd", UpdateEdit:0, InsertEdit:0 },
			{Header:"<sht:txt mid='jikweeNm_V5' mdef='작성자|직위'/>", Type:"Text",		Hidden:Number("${jwHdn}"),  Width:80,	Align:"Center",	 ColMerge:0,   SaveName:"jikweeCd", UpdateEdit:0, InsertEdit:0 },
			{Header:"승인상태|승인상태",Type:"Combo",		Hidden:0,  Width:60,	Align:"Center",	 ColMerge:0,   SaveName:"applStatusCd", UpdateEdit:0 },
			{Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",	 	 Type:"Text",		Hidden:0,  Width:80,	Align:"Center",	 ColMerge:0,   SaveName:"note", UpdateEdit:0, InsertEdit:1 }
		]; IBS_InitSheet(sheet5, initdata);sheet5.SetEditable("${editable}");sheet5.SetVisible(true);sheet5.SetCountPosition(4); sheet5.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		var applStatusCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=commonCodeList","R10010"), "");	//신청서상태코드
		sheet5.SetColProperty("applStatusCd", {ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );	    //신청서상태코드
		sheet5.SetColProperty("jikgubCd", 	  {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]} );	//직급구분
		sheet5.SetColProperty("jikweeCd", 	  {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]} );	//직위구분
		// 헤더 머지
		sheet5.SetMergeSheet( msHeaderOnly);
	}
	
	//--------------------------
	// sheet6
	//--------------------------
	function init_sheet6() {
        initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",       Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",     Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",     Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"<sht:txt mid='departmentV1' mdef='부서'/>",     Type:"Text",        Hidden:1,  Width:0,     Align:"Left",    ColMerge:0,   SaveName:"orgCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",     Type:"Text",        Hidden:0,  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"sabun",    KeyField:1,   UpdateEdit:0, InsertEdit:0 },
            {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",     Type:"Text",       Hidden:0,  Width:50,    Align:"Center",  ColMerge:0,   SaveName:"name",     KeyField:0,   UpdateEdit:0, InsertEdit:1 },
            {Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",   Type:"Text",        Hidden:Number("${aliasHdn}"),  Width:50,    Align:"Center",  ColMerge:0,   SaveName:"alias",    KeyField:0,   UpdateEdit:0, InsertEdit:0 },
            {Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",   Type:"Text",        Hidden:1,  Width:100,   Align:"Left",    ColMerge:0,   SaveName:"orgNm",    KeyField:0,   UpdateEdit:0, InsertEdit:0 },
            {Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",     Type:"Text",        Hidden:Number("${jgHdn}"),  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"jikgubNm", KeyField:0,   UpdateEdit:0, InsertEdit:0 },
            {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",     Type:"Text",        Hidden:Number("${jwHdn}"),  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"jikweeNm", KeyField:0,   UpdateEdit:0, InsertEdit:0 },
            {Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",     Type:"Text",        Hidden:0,  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"jikchakNm", KeyField:0,   UpdateEdit:0, InsertEdit:0 },
            {Header:"<sht:txt mid='sYmd' mdef='시작일자'/>", Type:"Date",        Hidden:0,  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"sdate",    KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eYmd' mdef='종료일자'/>", Type:"Date",        Hidden:0,  Width:60,    Align:"Center",  ColMerge:0,   SaveName:"edate",    KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }
        ]; IBS_InitSheet(sheet6, initdata);sheet6.SetEditable("${editable}");sheet6.SetVisible(true);sheet6.SetCountPosition(4);
        
		//Autocomplete	
		$(sheet6).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet6.SetCellValue(gPRow,"sabun", rv["sabun"]);
						sheet6.SetCellValue(gPRow,"name", rv["name"]);
						sheet6.SetCellValue(gPRow,"alias", rv["name"]);
						sheet6.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
						sheet6.SetCellValue(gPRow,"jikweeNm", rv["jikweeNm"]);
						sheet6.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);
					}
				}
			]
		});
	}

    //--------------------------
    // licenseSheet 자격
    //--------------------------
   function init_licenseSheet() {
        //자격/면허
        initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No",           Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"삭제",           Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"상태",           Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },

            {Header:"조직코드",     Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"타입코드",     Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"typeCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"타입명",     Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"typeNm",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"자격증 명",        Type:"Popup",     Hidden:0,  Width:150,  Align:"Left",  ColMerge:0,   SaveName:"itemNm",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"자격증코드",        Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"itemCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:15 },
            {Header:"등급",           Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"licenseGrade",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"필요/권장\n여부",    Type:"Combo",     Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"reqGb",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },

            {Header:"시작일자",         Type:"Date",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",       KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"종료일자",     Type:"Date",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"순서",           Type:"Int",       Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",         KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },
            {Header:"작성자",          Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkid",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"작성일",          Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"chkdate",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
            ]; IBS_InitSheet(licenseSheet, initdata);licenseSheet.SetEditable("${editable}");licenseSheet.SetVisible(true);licenseSheet.SetCountPosition(4);

        licenseSheet.SetColProperty("reqGb",          {ComboText:"|필요|권장", ComboCode:"|N|P"} );
    }
	    
    
   //--------------------------
   // init_capaSheet 역량  
   //--------------------------
    function init_capaSheet() {
	    //역량요건
	    initdata = {};
	    initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
	    initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	    initdata.Cols = [
	        {Header:"<sht:txt mid='sNo' mdef='No'/>",       Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
	        {Header:"<sht:txt mid='sDelete' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
	        {Header:"<sht:txt mid='statusCd' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
	
	        {Header:"조직코드",     Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"타입코드",     Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"typeCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"타입명",     Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"typeNm",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"<sht:txt mid='competencyCd' mdef='역량코드'/>",    Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"itemCd",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"<sht:txt mid='competencyNm' mdef='역량명'/>",     Type:"Popup",     Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"itemNm",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='mainAppType' mdef='역량구분'/>", Type:"Combo",     Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"competencyGb",KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
	        {Header:"<sht:txt mid='demandLevel' mdef='요구수준'/>", Type:"Text",      Hidden:1,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"demandLevel", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
	        {Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>",     Type:"Date",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",       KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
	        {Header:"<sht:txt mid='edateV3' mdef='종료일자'/>", Type:"Date",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
	        {Header:"<sht:txt mid='seqV2' mdef='순서'/>",     Type:"Int",       Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",         KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
	    ]; IBS_InitSheet(capaSheet, initdata);capaSheet.SetEditable("${editable}");capaSheet.SetVisible(true);capaSheet.SetCountPosition(4);
	
	    var competencyGb    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");   //역량구분
	    capaSheet.SetColProperty("competencyGb",            {ComboText:competencyGb[0], ComboCode:competencyGb[1]} );   //역량구분
    }
   
    //--------------------------
    // init_keywordSheet 역량  
    //--------------------------
     function init_keywordSheet() {
         //역량요건
         initdata = {};
         initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22};
         initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
         initdata.Cols = [
             {Header:"<sht:txt mid='sNo' mdef='No'/>",       Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
             {Header:"<sht:txt mid='sDelete' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
             {Header:"<sht:txt mid='statusCd' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
     
             {Header:"조직코드",     Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"orgCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
             {Header:"타입코드",     Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"typeCd",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
             {Header:"타입명",     Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"typeNm",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
             {Header:"<sht:txt mid='competencyCd' mdef='키워드코드'/>",    Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"itemCd",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='competencyNm' mdef='키워드명'/>",     Type:"Popup",     Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"itemNm",KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
             {Header:"<sht:txt mid='sdateV4' mdef='시작일자'/>",     Type:"Date",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sdate",       KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='edateV3' mdef='종료일자'/>", Type:"Date",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"edate",       KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
             {Header:"<sht:txt mid='seqV2' mdef='순서'/>",     Type:"Int",       Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",         KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 }
         ]; IBS_InitSheet(keywordSheet, initdata);keywordSheet.SetEditable("${editable}");keywordSheet.SetVisible(true);keywordSheet.SetCountPosition(4);
     
         var competencyGb    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");   //역량구분
         keywordSheet.SetColProperty("competencyGb",            {ComboText:competencyGb[0], ComboCode:competencyGb[1]} );   //역량구분
     }
   
	//-----------------------------------------------------------------------------------
	//		Sheet1 Action
	//-----------------------------------------------------------------------------------
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": 	 	
				if(!checkList()) return ;
				sheet1.DoSearch( "${ctx}/SuccKeyOrgMgr.do?cmd=getSuccKeyOrgMgrList", $("#srchFrm").serialize() );
				break;
			case "Save":
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/SuccKeyOrgMgr.do?cmd=saveSuccKeyOrgMgr", $("#srchFrm").serialize() ); 
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
					sheet2.DoSearch( "${ctx}/SuccKeyOrgMgr.do?cmd=getOrgMeberList1", $("#srchFrm").serialize() );
				} else {
					sheet2.DoSearch( "${ctx}/SuccKeyOrgMgr.do?cmd=getOrgMeberList2", $("#srchFrm").serialize() );
				}
				break;
			case "Down2Excel":	
				sheet1.Down2Excel(); 
				break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		Sheet3 Action
	//-----------------------------------------------------------------------------------
	
	function doAction3(sAction) {
		switch (sAction) {
			case "Search": 	 	
				sheet3.DoSearch( "${ctx}/SuccKeyOrgMgr.do?cmd=getOrgHistoryList", $("#srchFrm").serialize(),1 ); 
				break;
			case "Down2Excel":	
				sheet3.Down2Excel(); 
				break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		Sheet4 Action
	//-----------------------------------------------------------------------------------
	function doAction4(sAction) {
		switch (sAction) {
			case "Insert":		
				var row = sheet4.DataInsert(0);
				sheet4.SetCellValue(row, "orgCd",sheet1.GetCellValue(sheet1.GetSelectRow(),"orgCd"));
				sheet4.SetCellValue(row, "orgNm",sheet1.GetCellValue(sheet1.GetSelectRow(),"orgNm"));
				sheet4.SelectCell(row, 3); 
				break;
			case "Search": 	 	
				sheet4.DoSearch( "${ctx}/SuccKeyOrgMgr.do?cmd=getOrgChiefList", $("#srchFrm").serialize() ); 
				break;
			case "Save":		
				IBS_SaveName(document.srchFrm,sheet4);
				sheet4.DoSave( "${ctx}/SuccKeyOrgMgr.do?cmd=saveOrgChiefList", $("#srchFrm").serialize() ); 
				break ;
			case "Down2Excel":	
				sheet4.Down2Excel(); 
				break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		Sheet5 Action
	//-----------------------------------------------------------------------------------
	function doAction5(sAction) {
		switch (sAction) {
			case "Search": 	 	
				sheet5.DoSearch( "${ctx}/SuccKeyOrgMgr.do?cmd=getOrgRNRList", $("#srchFrm").serialize() ); 
				break;
			case "Down2Excel":	
				sheet5.Down2Excel(); 
			break;
		}
	}

	//-----------------------------------------------------------------------------------
	//		Sheet6 Action
	//-----------------------------------------------------------------------------------
    function doAction6(sAction) {
        switch (sAction) {
	        case "Insert":
	        	var row = sheet6.DataInsert(0);
	        	// 조직정보 세팅
	        	sheet6.SetCellValue(row, "orgCd", sheet1.GetCellValue(sheet1.GetSelectRow(),"orgCd"));
	        	sheet6.SetCellValue(row, "orgNm", sheet1.GetCellValue(sheet1.GetSelectRow(),"orgNm"));
	        	sheet6.SelectCell(row, 4);
	        break;
	        case "Search":      
	        	sheet6.DoSearch( "${ctx}/SuccKeyOrgMgr.do?cmd=getOrgChiefList2", $("#srchFrm").serialize() ); 
	        	break;
	        case "Save":
	                            
	        	if (!dupChk(sheet6, "sdate", false, true)) {break;}
	                            
	        	IBS_SaveName(document.srchFrm,sheet6);
	                            
	        	sheet6.DoSave( "${ctx}/SuccKeyOrgMgr.do?cmd=saveOrgChiefList2", $("#srchFrm").serialize() ); 
	        	break ;
	        case "Copy":        
	        	sheet6.DataCopy(); 
	        	break;
	        case "Down2Excel":  
	        	sheet6.Down2Excel(); 
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
			if (Msg != "") { alert(Msg); }
			userSheetResize();
			
		} catch (ex) { alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
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
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}


	//-----------------------------------------------------------------------------------
	//		sheet3 이벤트
	//-----------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } userSheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	//통합변경이력
	function sheet3_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{

			if( sheet3.ColSaveName(Col) == "detail" ) {
				if((sheet3.GetCellValue(Row,"changeGubun") == "5" || sheet3.GetCellValue(Row,"changeGubun") == "6") ){

					if(!isPopup()) {return;}

					var sdate = sheet3.GetCellValue(Row, "sdate");
					var num   = sheet3.GetCellValue(Row, "num");

					var w 		= 750;
					var h 		= 500;
					var url 	= "${ctx}/OrgMgrDet.do?cmd=viewOrgMgrDet&authPg=R";
					var args 	= new Array();
					args["searchSdate"] = sdate;
					args["searchNum"]   = num;

					gPRow = Row;
					pGubun = "viewOrgMgrDet";

					openPopup(url,args,w,h);
				}else{
					alert("<msg:txt mid='alertOrgTotalMgrV1' mdef='변경구분이 조직통합,조직분할인 경우에만 통합/분할 내역을 조회 할 수 합니다.'/>");
				}
			}
		}catch(ex){alert("sheet1_OnClick Event Error : " + ex);}
	}
	//-----------------------------------------------------------------------------------
	//		sheet4 이벤트
	//-----------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } userSheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

  	function sheet4_OnPopupClick(Row, Col){
  	  	try{
  	    	if(sheet4.ColSaveName(Col) == "name") {
  	    		//empSearchPopup(Row,Col);
 	    	}
  	  	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
  	}

    //-----------------------------------------------------------------------------------
	//		sheet5 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet5_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } $("#findText").focus() ; userSheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction5("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	//-----------------------------------------------------------------------------------
	//		sheet6 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
    function sheet6_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } userSheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet6_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } doAction6("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

    function sheet6_OnPopupClick(Row, Col){
        try{
            if(sheet6.ColSaveName(Col) == "name") {
                //empSearchPopup2(Row,Col);
            }
        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

    //-----------------------------------------------------------------------------------
    //      licenseSheet 이벤트
    //-----------------------------------------------------------------------------------

    // 조회 후 에러 메시지
    function licenseSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } userSheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function licenseSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { 
        	if (Msg != "") { alert(Msg); }
        	userSheetResize();
        
        } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

    
    function licenseSheet_OnPopupClick(Row,Col) {
        try {
            if( licenseSheet.ColSaveName(Col) == "itemNm" ) {
                if(!isPopup()) {return;}

                gPRow = Row;
                pGubun = "licensePopup";

                licensePopup(Row,Col);

            }
        } catch (ex) {
            alert("OnPopup Event Error : " + ex);
        }
    }

    // 자격증검색 팝입
    function licensePopup(Row, Col) {
        let layerModal = new window.top.document.LayerModal({
              id : 'hrmLicenseLayer'
            , url : '/PsnalLicense.do?cmd=viewHrmLicenseLayer&authPg=${authPg}'
            , parameters  : {
                gubun : ""
            }
            , width : 800
            , height : 520
            , title : '자격증 검색'
            , trigger :[
                {
                      name : 'hrmLicenseTrigger'
                    , callback : function(result){
                        licenseSheet.SetCellValue(gPRow, "itemCd", result.code);
                        licenseSheet.SetCellValue(gPRow, "itemNm", result.codeNm);
                    }
                }
            ]
        });
        layerModal.show();
    }
    
    //-----------------------------------------------------------------------------------
    //      capaSheet 이벤트
    //-----------------------------------------------------------------------------------

    // 조회 후 에러 메시지
    function capaSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } userSheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function capaSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } userSheetResize(); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

    //팝업 클릭시 발생
    function capaSheet_OnPopupClick(Row,Col) {
        try {
            if( capaSheet.ColSaveName(Col) == "itemNm" ) {
                competencySchemePopup(Row) ;
            }
        } catch (ex) {
            alert("OnPopup Event Error : " + ex);
        }
    }

    //  역량분류표 조회
    function competencySchemePopup(Row){
        try{
            if(!isPopup()) {return;}

            gPRow = Row;
            pGubun = "competencySchemePopup";
            var args    = new Array();

            var win = openPopup("/Popup.do?cmd=competencySchemePopup&authPg=R", args, "740","720");
        }catch(ex){
            alert("Open Popup Event Error : " + ex);
        }
    }
    
    //-----------------------------------------------------------------------------------
    //      keywordSheet 이벤트
    //-----------------------------------------------------------------------------------

    // 조회 후 에러 메시지
    function keywordSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } userSheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function keywordSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } userSheetResize(); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

    //팝업 클릭시 발생
    function keywordSheet_OnPopupClick(Row,Col) {
        try {
            if( keywordSheet.ColSaveName(Col) == "itemNm" ) {
                gPRow = Row;
            	showKeywordLayer(Row, Col) ;
            }
        } catch (ex) {
            alert("OnPopup Event Error : " + ex);
        }
    }
    
    // keyword layer
    function showKeywordLayer(Row, Col) {
        let layerModal = new window.top.document.LayerModal({
            id : 'keywordLayer'
            , url : '/SpecificEmpSrch.do?cmd=viewSpecificEmpSrchNewKeywordLayer&authPg=R'
            , parameters : {
                searchDesc : $('#searchTypeNm').val()
            }
            , width : 500
            , height : 420
            , title : '키워드'
            , trigger :[
                {
                    name : 'keywordLayerTrigger'
                    , callback : function(result){
                    	keywordSheet.SetCellValue(gPRow, "itemCd", keywordSheet.RowCount());
                        keywordSheet.SetCellValue(gPRow, "itemNm", result.searchDesc);
                    }
                }
            ]
        });
        layerModal.show();
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
		$('#inoutType').val(sheet1.GetCellValue(row,"inoutType"));
		$('#objectType').val(sheet1.GetCellValue(row,"objectType"));
		$('#orgType').val(sheet1.GetCellValue(row,"orgType"));
		$('#sdate').val(sheet1.GetCellText(row,"sdate"));
		$('#edate').val(sheet1.GetCellText(row,"edate"));
		$('#locationCd').val(sheet1.GetCellValue(row,"locationCd"));
		$('#memo').val(sheet1.GetCellValue(row,"memo"));
		
		if (sheet1.GetCellValue(row,"succYn") == "Y"){
			$('#succYn').prop('checked', true);
		}else {
			$('#succYn').prop('checked', false);
		}

		$(window).smartresize(userSheetResize); userSheetInit();

		//doAction2("Search");
		//doAction3("Search");
		//doAction4("Search");
		//doAction6("Search");
		//doAction5("Search");
        
        doActionJob("Search");
        doActionLicense("Search");
        doActionCapa("Search");
        doActionKeyword("Search");
	}

	// 폼에서 시트으로 세팅.
	function setSheetData() {

		var row = sheet1.GetSelectRow();
		if(row == 0) {
			return;
		}
		
        if($("#succYn").is(":checked") == true){
            sheet1.SetCellValue(row,"succYn", "Y");
        }else {
        	sheet1.SetCellValue(row,"succYn", "N");
        }


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


  	function empSearchPopup(Row, Col){
  		if(!isPopup()) {return;}

		var url 	= "/Popup.do?cmd=employeePopup&authPg=A";
		var args 	= new Array();

  		gPRow = Row;
  		pGubun = "employeePopup";

		openPopup(url, args, "840","520");
  	}

    function empSearchPopup2(Row, Col){
        if(!isPopup()) {return;}

        var url     = "/Popup.do?cmd=employeePopup&authPg=A";
        var args    = new Array();

        gPRow = Row;
        pGubun = "employeePopup2";

        openPopup(url, args, "840","520");
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

        if(pGubun == "employeePopup"){
	  	  	sheet4.SetCellValue(gPRow, "sabun",rv["sabun"]);
		    sheet4.SetCellValue(gPRow, "name",rv["name"]);
		    sheet4.SetCellValue(gPRow, "jikchakCd",rv["jikchakCd"]);
		    sheet4.SetCellValue(gPRow, "jikweeCd",rv["jikweeCd"]);
		    sheet4.SetCellValue(gPRow, "jikgubCd",rv["jikgubCd"]);
		    sheet4.SetCellValue(gPRow, "orgCd",sheet1.GetCellValue(sheet1.GetSelectRow(),"orgCd"));
		    sheet4.SetCellValue(gPRow, "orgNm",sheet1.GetCellValue(sheet1.GetSelectRow(),"orgNm"));
		    sheet4.SetCellValue(gPRow, "jobCd",rv["jobCd"]);
		    sheet4.SetCellValue(gPRow, "jobNm",rv["jobNm"]);
        } else if(pGubun == "viewOrgMgrDet") {
			doAction1("Search");
        } else if(pGubun == "employeePopup2"){
            sheet6.SetCellValue(gPRow, "sabun",rv["sabun"]);
            sheet6.SetCellValue(gPRow, "name",rv["name"]);
            sheet6.SetCellValue(gPRow, "jikweeNm",rv["jikweeNm"]);
            sheet6.SetCellValue(gPRow, "jikgubNm",rv["jikgubNm"]);
            sheet6.SetCellValue(gPRow, "jikchakNm",rv["jikchakNm"]);
            sheet6.SetCellValue(gPRow, "orgCd",sheet1.GetCellValue(sheet1.GetSelectRow(),"orgCd"));
            sheet6.SetCellValue(gPRow, "orgNm",sheet1.GetCellValue(sheet1.GetSelectRow(),"orgNm"));
        } else if(pGubun == "competencySchemePopup") {
        	capaSheet.SetCellValue(gPRow, "itemCd",       rv["competencyCd"]);
        	capaSheet.SetCellValue(gPRow, "itemNm",       rv["competencyNm"]);
        	capaSheet.SetCellValue(gPRow, "competencyGb",       rv["mainAppType"]);
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
	
	/* 탭 안의 Sheet 높이가 자동으로 100%이 안되므로 수동 처리 함. 2020.06.01*/
	function userSheetResize(){
		
		sheetResize();
		$(".ibsheet").each(function() {
	        if($(this).attr("fixed") == "false" && this.id != "DIV_sheet1") {
	        	var h = $(this).height();
	            $(this).height(h-350); //조직기본정보 높이 차감
	        }
		});
	}
	
	/* 탭 안의 Sheet 높이가 자동으로 100%이 안되므로 수동 처리 함. 2020.06.01*/
	function userSheetInit(){
		sheetInit();
		$(".ibsheet").each(function() {
	        if($(this).attr("fixed") == "false" && this.id != "DIV_sheet1") {
	        	var h = $(this).height();
	            $(this).height(h-350);  //조직기본정보 높이 차감
	        }
		});
	}
	
    function clickTabs(tabNum) {

        var tabId = 'tabs-' + tabNum;
        $('.tab_content').addClass('hide');
        $('#' + tabId).removeClass('hide');
        onTabResize();
    }
    
    //팝업 클릭시 발생
    function jobPopup(param) {
        if(!isPopup()) {return;}
        var layer = new window.top.document.LayerModal({
            id : 'jobPopupLayer'
            , url : "${ctx}/Popup.do?cmd=jobPopup&authPg=${authPg}"
            , parameters: param
            , width : 740
            , height : 720
            , title : "직무 리스트 조회"
            , trigger :[
                {
                    name : 'jobPopupTrigger'
                    , callback : function(rv){
                        $("#itemCd").val(rv.jobCd);
                        $("#itemNm").val(rv.jobNm);
                    }
                }
            ]
        });
        layer.show();
    }
    
    //직무
    function doActionJob(sAction) {
    	switch (sAction) {
        case "Search":
            $('#searchTypeCd').val("J");
            $("#itemCd").val("");
            $("#itemNm").val("");
            var result = ajaxCall( "${ctx}/SuccKeyOrgMgr.do?cmd=getSuccKeyDetailMap", $("#srchFrm").serialize(), false ).DATA;
            
            if (null != result){
            	if (null != result.itemCd){
                    $("#itemCd").val(result.itemCd);
                    $("#itemNm").val(result.itemNm);
            	}
            }
            break;
            
        case "Save":
        	var param = 
        	{
   	            orgCd :  $("#searchOrgCd").val(),
   		        typeCd : "J",
   		        typeNm : "직무",
   		        itemCd : $("#itemCd").val(),
   		        itemNm : $("#itemNm").val()

        	}

            var result = ajaxCall("${ctx}/SuccKeyOrgMgr.do?cmd=saveSuccKeyJob", param, false);
            if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
                if (parseInt(result["Result"]["Code"]) > 0) {
                    alert("<msg:txt mid='alertSaveOkV1' mdef='저장 되었습니다.'/>");
                } else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
                    alert(result["Result"]["Message"]);
                }
            } else {
                alert("<msg:txt mid='109500' mdef='저장 오류입니다.'/>");
            }
            //IBS_SaveName(document.srchFrm,sheet4);
            //sheet4.DoSave( "${ctx}/SuccKeyOrgMgr.do?cmd=saveSuccKeyDetail", $("#jobFrm").serialize() ); 
        break ;
    	}
    }
    
    //자격면허
    function doActionLicense(sAction) {
        switch (sAction) {
        case "Search":
            $('#searchTypeCd').val("L");
            licenseSheet.DoSearch( "${ctx}/SuccKeyOrgMgr.do?cmd=getSuccKeyDetailList", $("#srchFrm").serialize() ); break;
        case "Save":
             IBS_SaveName(document.srchFrm,licenseSheet);
             licenseSheet.DoSave( "${ctx}/SuccKeyOrgMgr.do?cmd=saveSuccKeyDetail", $("#srchFrm").serialize() ); break;
        case "Insert":
            var row = licenseSheet.DataInsert(0);
            licenseSheet.SetCellValue(row,"orgCd",$("#searchOrgCd").val());
            licenseSheet.SetCellValue(row,"typeCd","L");
            licenseSheet.SetCellValue(row,"typeNm","자격증");
            break;
        }
    }

    
    //역량
    function doActionCapa(sAction) {
        switch (sAction) {
        case "Search":
            $('#searchTypeCd').val("C");
            capaSheet.DoSearch( "${ctx}/SuccKeyOrgMgr.do?cmd=getSuccKeyDetailList", $("#srchFrm").serialize() ); 
            break;
        case "Save":
            IBS_SaveName(document.srchFrm,capaSheet);
            capaSheet.DoSave( "${ctx}/SuccKeyOrgMgr.do?cmd=saveSuccKeyDetail", $("#srchFrm").serialize() ); 
            break;
        case "Insert":
            var row = capaSheet.DataInsert(0);
            capaSheet.SetCellValue(row,"orgCd",$("#searchOrgCd").val());
            capaSheet.SetCellValue(row,"typeCd","C");
            capaSheet.SetCellValue(row,"typeNm","역량");
            break;
        }
    }
    
    //키워드
    function doActionKeyword(sAction) {
        switch (sAction) {
        case "Search":
            $('#searchTypeCd').val("K");
            keywordSheet.DoSearch( "${ctx}/SuccKeyOrgMgr.do?cmd=getSuccKeyDetailList", $("#srchFrm").serialize() ); 
            break;
        case "Save":
            IBS_SaveName(document.srchFrm,keywordSheet);
            keywordSheet.DoSave( "${ctx}/SuccKeyOrgMgr.do?cmd=saveSuccKeyDetail", $("#srchFrm").serialize() ); 
            break;
        case "Insert":
            var row = keywordSheet.DataInsert(0);
            keywordSheet.SetCellValue(row,"orgCd",$("#searchOrgCd").val());
            keywordSheet.SetCellValue(row,"typeCd","K");
            keywordSheet.SetCellValue(row,"typeNm","키워드");
            break;
        }
    }
</script>
</head>
<body class="hidden" onload="startView()" >
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchOrgCd" name="searchOrgCd">
		<input type="hidden" id="searchTypeCd" name="searchTypeCd">
		<input type="hidden" id="searchSht2Gbn" name="searchSht2Gbn">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
	                    <td>
                        <span><tit:txt mid='104535' mdef='기준일'/></span>
                             <input type="text" id="baseDate" name="baseDate" class="date" value="" />
                        </td>
						<td>
							<span>조직도명 </span>
							
							<!-- <input id="searchOrgChartNm" name="searchOrgChartNm" type="text" class="text readonly required" style="width: 250px;" readonly value="${chartMap.orgChartNm}" /> -->
							<!-- <input type="hidden" id="searchSdate" name="searchSdate" value="${chartMap.sdate}" /> -->
                            <select id="searchSdate" name ="searchSdate" class="w250" value="${chartMap.sdate}" ></select>
							<!-- <a onclick="javascript:searchSdatePopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> -->
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
		<col width="450px" />
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
						<input id="findText" name="findText" type="text" class="text" class="text" >
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
								<span id="orgCd" name="orgCd"></span>
							</td>
							<th><tit:txt mid='104514' mdef='조직명'/></th>
							<td>
								<span id="orgNm" name="orgNm" type="text"></span>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='113225' mdef='조직유형'/></th>
							<td>
								<select id="orgType" name="orgType" disabled>
								</select>
							</td>
							<th><tit:txt mid='112508' mdef='시작일/종료일'/></th>
							<td>
								<input id="sdate" name="sdate" type="text" class="text" readonly> ~ <input id="edate" name="edate" type="text" class="text" readonly/>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='112176' mdef='내외구분'/></th>
							<td>
								<select id="inoutType" name="inoutType" disabled>
								</select>
							</td>
							<th><tit:txt mid='104281' mdef='근무지'/></th>
							<td>
								<select id="locationCd" name="locationCd" disabled>
								</select>
							</td>
						</tr>
						<tr>
							<th><tit:txt mid='114269' mdef='조직구분'/></th>
							<td>
								<select id="objectType" name="objectType" disabled>

								</select>
							</td>
							<th>Key Position</th>
							<td>
							   <input type="checkbox" class="checkbox" id="succYn" name="succYn" value="Y" style="vertical-align:middle;"/>
								<!-- <select id="succYn" name="succYn">
								    <option value = ''>선택</option>
									<option value = 'Y'>Y</option>
									<option value = 'N'>N</option>
								</select> -->
							</td>
						</tr>
					</table>
			</form>
			<div style="position:absolute;left:450px;top:355px;bottom:0px;right:0;">
				<div id="tabs"  style="height:100%;border:none;">
					<div class='ui-tabs-nav-line'></div> <!-- 탭 하단 라인 -->

					<ul class="tab_bottom">
						<!-- <li onclick="onTabResize();"><btn:a href="#tabs-1" mid='111382' mdef="조직원"/></li>
						<li onclick="onTabResize();" style="display:none"><btn:a href="#tabs-2" mid='111533' mdef="조직이력"/></li>
						<li onclick="onTabResize();"><btn:a href="#tabs-3" mid='111226' mdef="조직장"/></li>
						<li onclick="onTabResize();"><btn:a href="#tabs-5" mid='111227' mdef="공동조직장(화상조직도)"/></li> -->
						<!-- <li onclick="onTabResize();"><btn:a href="#tabs-4" mid='111383' mdef="조직 R&R"/></li> -->
						<li onclick="clickTabs('6');"><btn:a href="#tabs-6" mid='110942' mdef="직무"/></li>
                        <li onclick="clickTabs('7');"><btn:a href="#tabs-7" mid='110942' mdef="자격"/></li>
                        <li onclick="clickTabs('8');"><btn:a href="#tabs-8" mid='111071' mdef="역량"/></li>
                        <li onclick="clickTabs('9');"><btn:a href="#tabs-9" mid='111071' mdef="keyword"/></li>
					</ul>

<!--  
					<div id="tabs-1">
                        
						<div class="sheet_title inner">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='orgEmpNm' mdef='조직원'/></li>
								<li class="btn">
								    <input type="checkbox" class="checkbox" id="searchType" name="searchType" onClick="doAction2('Search');" style="vertical-align:middle;"/>&nbsp;<b><tit:txt mid='104304' mdef='하위조직포함'/></b>&nbsp;
									<btn:a href="javascript:doAction2('Search')" 	css="basic authR" mid='110697' mdef="조회"/>
									<a href="javascript:doAction2('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
								</li>
							</ul>
						</div>
						<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
					</div>

					<div id="tabs-2">
						<div class="inner">
							<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='orgTotalMgrT2' mdef='조직이력'/></li>
								<li class="btn">
									<btn:a href="javascript:doAction3('Search')" 	css="basic authR" mid='110697' mdef="조회"/>
									<a href="javascript:doAction3('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
								</li>
							</ul>
							</div>
						</div>
						<script type="text/javascript"> createIBSheet("sheet3", "100%", "100%", "${ssnLocaleCd}"); </script>
					</div>

					<div id="tabs-3">
						<div class="inner">
							<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='orgTotalMgrT3' mdef='조직장'/></li>
								<li class="btn">
									<btn:a href="javascript:doAction4('Search')" 	css="basic authR" mid='110697' mdef="조회"/>
									<btn:a href="javascript:doAction4('Insert')" css="basic authA" mid='110700' mdef="입력"/>-->
									<!-- <btn:a href="javascript:doAction4('Copy')" 	css="basic authA" mid='110696' mdef="복사"/> -->
<%-- 									<btn:a href="javascript:doAction4('Save')" 	css="basic authA" mid='110708' mdef="저장"/> --%>
<!-- 									<a href="javascript:doAction4('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
								</li>
							</ul>
							</div>
						</div>
						<script type="text/javascript"> createIBSheet("sheet4", "100%", "100%"); </script>
					</div>
					<div id="tabs-4" class="hide">
						<div class="inner">
							<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='113226' mdef='조직 R&R'/></li>
								<li class="btn">
									<a href="javascript:doAction5('Search')" 	class="basic authR"><tit:txt mid='104081' mdef='조회'/></a>
									<a href="javascript:doAction5('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
								</li>
							</ul>
							</div>
						</div>
						<script type="text/javascript"> createIBSheet("sheet5", "100%", "100%", "${ssnLocaleCd}"); </script>
					</div>
                    <div id="tabs-5">
                        <div class="inner">
                            <div class="sheet_title">
                            <ul>
                                <li id="txt" class="txt">공동조직장(화상조직도)&nbsp;&nbsp;<font color="red" style="font-size:11px;"><tit:txt mid='114663' mdef='☞화상조직도에 공동조직장으로 표기.'/></font></li>
								<%-- <li id="txt" class="txt"> <font color="red" style="font-size:11px;">☞화상조직도에 공동조직장으로 표기.</font> </li> --%>
                                <li class="btn">
                                    <btn:a href="javascript:doAction6('Search')"    css="basic authR" mid='110697' mdef="조회"/> -->
<%--                                     <btn:a href="javascript:doAction6('Insert')" css="basic authA" mid='110700' mdef="입력"/> --%>
<%--                                     <btn:a href="javascript:doAction6('Copy')"  css="basic authA" mid='110696' mdef="복사"/> --%>
<%--                                     <btn:a href="javascript:doAction6('Save')"  css="basic authA" mid='110708' mdef="저장"/> --%>
<!--                                    <a href="javascript:doAction6('Down2Excel')"    class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
                                </li>
                            </ul>
                            </div>
                        </div>
                        <script type="text/javascript"> createIBSheet("sheet6", "100%", "100%", "${ssnLocaleCd}"); </script>
                    </div>
                     --> 
                    <div id="tabs-6" class="tab_content">
                        <div class="inner"> 
                            <div class="sheet_title ">
	                            <ul>
	                               <li class="txt">직무</li>
	                                <li class="btn">
	                                    <btn:a href="javascript:doActionJob('Save');"    css="basic authA" mid='110708' mdef="저장"/>
	                                </li>
	                            </ul>
                            </div>
		                    <table class="table w100p" id="htmlTable">
		                        <colgroup>
		                            <col width="10%" />
		                        </colgroup>
		                        <tr>
		                            <td>
		                                <input id="itemCd" name="itemCd" type="text" readonly/>
		                                <input id="itemNm" name="itemNm" type="text">
		                                <a onclick="javascript:jobPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
		                            </td>
		                        </tr>
		                    </table>
                        </div>
                    </div>
                    
                    <div id="tabs-7" class="tab_content hide" >
		                <div class="inner">
		                    <div class="sheet_title">
		                    <ul>
		                        <li class="txt">자격증</li>
		                        <li class="btn">
		                            <a href="javascript:doActionLicense('Search')"   class="basic authR">조회</a>
		                            <a href="javascript:doActionLicense('Insert')"   class="basic authA">입력</a>
		                            <a href="javascript:doActionLicense('Save')"     class="basic authA">저장</a>
		                        </li>
		                    </ul>
		                    </div>
		                    <script type="text/javascript"> createIBSheet("licenseSheet", "100%", "93%", "${ssnLocaleCd}"); </script>
                        </div>

                    </div>
                    
                    <div id="tabs-8" class="tab_content hide">
                        <div class="inner">
                            <div class="sheet_title">
                            <ul>
                                <li class="txt"><tit:txt mid='jobMgrTab5' mdef='역량요건'/></li>
                                <li class="btn">
                                    <btn:a href="javascript:doActionCapa('Search')"  css="basic authR" mid='search' mdef="조회"/>
                                    <btn:a href="javascript:doActionCapa('Insert')" css="basic authA" mid='insert' mdef="입력"/>
                                    <btn:a href="javascript:doActionCapa('Save')"  css="basic authA" mid='save' mdef="저장"/>
                                </li>
                            </ul>
                            </div>
                        </div>
                        <script type="text/javascript"> createIBSheet("capaSheet", "100%", "100%", "${ssnLocaleCd}"); </script>
                    </div>
                    
                    <div id="tabs-9" class="tab_content hide">
                        <div class="inner">
                            <div class="sheet_title">
                            <ul>
                                <li class="txt">keyword</li>
                                <li class="btn">
                                    <btn:a href="javascript:doActionKeyword('Search')"  css="basic authR" mid='search' mdef="조회"/>
                                    <btn:a href="javascript:doActionKeyword('Insert')" css="basic authA" mid='insert' mdef="입력"/>
                                    <btn:a href="javascript:doActionKeyword('Save')"  css="basic authA" mid='save' mdef="저장"/>
                                </li>
                            </ul>
                            </div>
                        </div>
                        <script type="text/javascript"> createIBSheet("keywordSheet", "100%", "100%", "${ssnLocaleCd}"); </script>
                    </div>
				</div> <!--  tabs -->
			</div>
		</td>
	</tr>
	</table>
</div>
</body>
</html>
