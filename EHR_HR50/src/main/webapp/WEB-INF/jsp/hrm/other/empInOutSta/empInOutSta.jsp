<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var ssnSearchType = "${ssnSearchType}";

	$(function() {
		if("${ssnEnterAllYn}" == "Y"){
			$("#spEnterTxt").removeClass("hide");
		}
		
		/*
		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}
		*/	
		
		$("#searchOrdTypeCd").change(function(){
			$(this).bind("selected").val();

			var searchOrdTypeCd = $(this).val();

			var searchOrdDetailCd = "";
			var searchOrdReasonCd = "";

			if(searchOrdTypeCd != null){
				searchOrdDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&useYn=Y&ordTypeCd="+searchOrdTypeCd ,false).codeList, "전체");
				searchOrdReasonCd  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1="+searchOrdTypeCd, "H40110"), "전체");
			}
			$("#searchOrdDetailCd").html(searchOrdDetailCd[2]);
			$("#searchOrdReasonCd").html(searchOrdReasonCd[2]);
		});
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:4, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",  			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	MinWidth:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo"},
			{Header:"구분",			Type:"Text",      	Hidden:0,  	MinWidth:60,   Align:"Center",  ColMerge:0, SaveName:"gubun", 	KeyField:0, CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사진",			Type:"Image",		Hidden:0,   MinWidth:55,   Align:"Center", ColMerge:0, SaveName:"photo",		UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sabun",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"회사",			Type:"Text",		Hidden:1,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"enterNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"본부",			Type:"Text",		Hidden:1,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"priorOrgNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"소속",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"orgNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직책",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직위",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직급",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"호봉",			Type:"Text",		Hidden:1,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"salClass",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직무",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"jobNm",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직무구분",		Type:"Text",		Hidden:1,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"jobGbn",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"직군",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"workTypeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사원구분",	    Type:"Text",      	Hidden:0,  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"manageNm",      	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
			{Header:"주민번호",		Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"resNo",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"그룹입사일",		Type:"Text",		Hidden:Number("${gempYmdHdn}"),	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"gempYmd",			KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"입사일",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"empYmd",			KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"성별",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"sexTypeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"구소속",			Type:"Text",		Hidden:1,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"base3Cd",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"발령일",			Type:"Text",		Hidden:0,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"ordYmd",			KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"발령명",			Type:"Text",		Hidden:1,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"ordTypeNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"발령상세",	    Type:"Text",      	Hidden:0,   Width:90,	Align:"Center",  ColMerge:0,   SaveName:"ordDetailNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"발령세부",		Type:"Text",		Hidden:1,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"ordReasonNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"퇴직사유",		Type:"Text",		Hidden:1,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"resignReasonNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"이직처",			Type:"Text",		Hidden:1,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"retPathNm",		KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"비고",	    	Type:"Text",        Hidden:0,   Width:150,	Align:"Center",  ColMerge:0,   SaveName:"memo",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"재직여부",		Type:"Text",		Hidden:1,	Width:90,   Align:"Center",  ColMerge:0,   SaveName:"statusGb",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"조회권한",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"authYn", UpdateEdit:0 }
			];IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetCountPosition(4);
		sheet1.FitColWidth();
		
		//sheet1.SetDataLinkMouse("photo",1);	
		//sheet1.SetDataLinkMouse("name",1);	
		
		getCommonCodeList();
		
		//발령상세
		var ordDetailCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList",false).codeList, "");	//발령종류
		sheet1.SetColProperty("ordDetailCd", {ComboText:"|"+ordDetailCdList[0], ComboCode:"|"+ordDetailCdList[1]});

		var userCd1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeCdManagerList&useYn=Y",false).codeList, "전체");	//발령종류

		$("#searchOrdTypeCd").html(userCd1[2]);//검색조건의 발령

		$("#sdate").datepicker2({startdate:"edate", onReturn: getCommonCodeList});
		$("#edate").datepicker2({enddate:"sdate", onReturn: getCommonCodeList});

		$("#searchOrdTypeCd").val($("#searchGubun").val()).change();
		
		$("#searchOrgNm, #searchSabunName").on("keyup", function(e) {
			if(e.keyCode == 13) {
				doAction("Search");
			}
		});
		
		$("#searchGubun").on("change", function(e) {
			$("#searchOrdTypeCd").val($("#searchGubun").val()).change();
		});
/*
		$("#searchPhotoYn").on("click", function(e) {
			doAction("Search");
		});	
		$("#searchPhotoYn").attr('checked', 'checked');*/

		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		//sheet1.SetAutoRowHeight(0);
		//sheet1.SetDataRowHeight(60);
		
		$("#searchPhotoYn").click(function() {
			//doAction1("Search");
        	if($("#searchPhotoYn").is(":checked") == true) {
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			} else {
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}
			
			 sheetResize();
			
		});
		
		$("#searchPhotoYn").attr('checked', 'checked');		
		/*
		$("#checkExcept1, #checkExcept2, #checkExcept3").on("click", function(e) {
			doAction("Search");
		});		
		*/
		$(window).smartresize(sheetResize);
		sheetInit();
		doAction("Search");
	});

	function getCommonCodeList() {
		let baseSYmd = $("#sdate").val();
		let baseEYmd = $("#edate").val();
		// 재직상태
		var searchStatusCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd, baseEYmd), "전체");
		$("#searchStatusCd").html(searchStatusCdList[2]);
		$("#searchStatusCd").select2({
			placeholder: "전체",
			maximumSelectionSize:100
		});

		//직책
		var searchJikchakCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020", baseSYmd, baseEYmd), "");
		$("#searchJikchakCd").html(searchJikchakCd[2]);
		$("#searchJikchakCd").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
		});
		//직위
		var searchJikweeCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030", baseSYmd, baseEYmd), "");
		$("#searchJikweeCd").html(searchJikweeCd[2]);
		$("#searchJikweeCd").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
		});
		//직급
		var searchJikgubCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010", baseSYmd, baseEYmd), "");
		$("#searchJikgubCd").html(searchJikgubCd[2]);
		$("#searchJikgubCd").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
		});
	}


	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			$("#statusCd").val(($("#searchStatusCd").val()==null?"":getMultiSelect($("#searchStatusCd").val())));
			$("#jikchakCd").val(($("#searchJikchakCd").val()==null?"":getMultiSelect($("#searchJikchakCd").val())));
			$("#jikweeCd").val(($("#searchJikweeCd").val()==null?"":getMultiSelect($("#searchJikweeCd").val())));
			$("#jikgubCd").val(($("#searchJikgubCd").val()==null?"":getMultiSelect($("#searchJikgubCd").val())));
			/*
			if($("#checkExcept1").is(":checked") == true){
				$("#except1").val("Y");
			}else{
				$("#except1").val("");
			}	
			
			if($("#checkExcept2").is(":checked") == true){
				$("#except2").val("Y");
			}else{
				$("#except2").val("");
			}	
			
			if($("#checkExcept3").is(":checked") == true){
				$("#except3").val("Y");
			}else{
				$("#except3").val("");
			}				
			*/
			sheet1.DoSearch( "${ctx}/EmpInOutSta.do?cmd=getEmpInoutStaList", $("#empForm").serialize() ); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}

	// 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
    	
        try {
            if (Msg != "") {
                alert(Msg);
            }

            if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);

			}else{
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}

            sheetResize();

        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
				doAction("Search");}
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		//팝업
		if(sheet1.ColSaveName(Col) == "photo" || sheet1.ColSaveName(Col) == "name"){
			var authYn = sheet1.GetCellValue(Row, "authYn");
			
			if(ssnSearchType =="A" ){
				if( "${profilePopYn}"=="Y"){
					
					// 인사기본 팝업 
					var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
		            var args    = new Array();
		            args["sabun"]      = sheet1.GetCellValue(Row, "sabun");
		            args["enterCd"]    = "${ssnEnterCd}";
		            args["empName"]    = sheet1.GetCellValue(Row, "name");
		            args["mainMenuCd"] = "240";	            
		            args["menuCd"]     = "112";
		            args["grpCd"]       = "${ssnGrpCd}";
					openPopup(url,args,"1250","780");
					
				}else{
					var sabun  = sheet1.GetCellValue(Row,"sabun")
					var enterCd =$("#groupEnterCd").val();
					goMenu(sabun, enterCd);
				}
			}else if(ssnSearchType == "P"){
				profilePopup(Row);
			}else if(ssnSearchType == "O"){
				/* 적용안함
				if(authYn == "Y"){
					if( "${profilePopYn}"=="Y"){
						// 인사기본 팝업 
						var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
			            var args    = new Array();
			            args["sabun"]      = sheet1.GetCellValue(Row, "sabun");
			            args["enterCd"]    = "${ssnEnterCd}";
			            args["empName"]    = sheet1.GetCellValue(Row, "name");
			            args["mainMenuCd"] = "240";	            
			            args["menuCd"]     = "112";
			            args["grpCd"]       = "${ssnGrpCd}";
						openPopup(url,args,"1250","780");
						
					}else{
						var sabun  = sheet1.GetCellValue(Row,"sabun")
						var enterCd =$("#groupEnterCd").val();
						goMenu(sabun, enterCd);
					}
				}else{
					profilePopup(Row);
				}
				*/
			}else{
				profilePopup(Row);
			}
			
		}
	}
	
	/**
	 * 조직원 프로필 window open event
	 */
	function profilePopup(Row){
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "viewEmpProfile";

  		var w 		= 610;
		var h 		= 350;
		var url 	= "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
		var args 	= new Array();
		args["sabun"] 		= sheet1.GetCellValue(Row, "sabun");

		var rv = openPopup(url,args,w,h);

	}

	$(function() {

        $("#name").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchYmdFrom").datepicker2({startdate:"searchYmdTo"});
		$("#searchYmdTo").datepicker2({enddate:"searchYmdFrom"});

	});
	
	
	// 비교대상 화면으로 이동
	function goMenu(sabun, enterCd) {

        //비교대상 정보 쿠키에 담아 관리
        var paramObj = [{"key":"searchSabun", "value":sabun},{"key":"searchEnterCd", "value":enterCd}];

        //var prgCd = "View.do?cmd=viewPsnalBasicInf";
        var prgCd = "PsnalBasicInf.do?cmd=viewPsnalBasicInf";
        var location = "인사관리 > 인사정보 > 인사기본";


        var $form = $('<form></form>');
        $form.appendTo('body');
        var param1 	= $('<input name="prgCd" 	type="hidden" 	value="'+prgCd+'">');
        var param2 	= $('<input name="goMenu" 	type="hidden" 	value="Y">');
        $form.append(param1).append(param2);

    	var prgData = ajaxCall("${ctx}/OrgPersonSta.do?cmd=getCompareEmpOpenPrgMap",$form.serialize(),false);

    	if(prgData.map == null) {
			//alert("<msg:txt mid='109611' mdef='권한이 없거나 존재하지 않는 메뉴입니다.'/>");
			profilePopup(sheet1.GetSelectRow());
			return;
		}

		if (typeof goSubPage == 'undefined') {
			// 서브페이지에서 서브페이지 호출
			if (typeof window.top.goOtherSubPage == 'function') {
				window.top.goOtherSubPage("", "", "", "", prgData.map.prgCd);
			}
		} else {
			goSubPage("", "", "", "", prgData.map.prgCd);
		}

    	// var lvl 		= prgData.map.lvl;
    	// var menuId		= prgData.map.menuId;
		// var menuNm 		= prgData.map.menuNm;
		// var menuNmPath	= prgData.map.menuNmPath;
		// var prgCd 		= prgData.map.prgCd;
		// var mainMenuNm 	= prgData.map.mainMenuNm;
		// var surl      	= prgData.map.surl;
		// parent.openContent(menuNm,prgCd,location,surl,menuId,paramObj);
	}	
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="empForm" name="empForm" >
			<input type="hidden" id="except1" name="except1"/>
			<input type="hidden" id="except2" name="except2"/>
			<input type="hidden" id="except3" name="except3"/>		
					
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>발령기간</th>
							<td>
								<input id="sdate" name="sdate" maxlength="10" type="text" class="text date2" value="<%= DateUtil.getCurrentTime("yyyy-01-01")%>"/>
								~
								<input id="edate" name="edate" maxlength="10" type="text" class="text date2" value="<%= DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
							</td>
							<th class="hide">발령</th>
							<td  colspan="2" class="hide">
								<select id="searchOrdTypeCd" name="searchOrdTypeCd"><option value=''>전체</option></select>
								<select id="searchOrdDetailCd" name="searchOrdDetailCd"><option value=''>전체</option></select>
								<select id="searchOrdReasonCd" name="searchOrdReasonCd"><option value=''>전체</option></select>
							</td>
							<th>입/퇴사</th>
							<td>
								<select id="searchGubun" name="searchGubun">
									<option value=''>전체</option>
									<option value='10'>입사자</option>
									<option value='60'>퇴사자</option>
								</select>
							</td>
							<th>소속</th>
							<td>
								<input type="text" id="searchOrgNm" name="searchOrgNm" class="text" value="" />
							</td>
							<th>사번/성명</th>
							<td>
								<input type="text" id="searchSabunName" name="searchSabunName" class="text" value="" />&nbsp;&nbsp;&nbsp;
							</td>							
						</tr>
						<tr>	
							<th>직책</th>						
							<td>
								<select id="searchJikchakCd" name="searchJikchakCd" multiple onChange="javaScript:searchAllChart(); "></select>
								<input type="hidden" id="jikchakCd" name="jikchakCd"/>
							</td>
							<th>직위</th>
							<td>
								<select id="searchJikweeCd" name="searchJikweeCd" multiple onChange="javaScript:searchAllChart(); "></select>
								<input type="hidden" id="jikweeCd" name="jikweeCd"/>
							</td>
							<th>직급</th>
							<td>
								<select id="searchJikgubCd" name="searchJikgubCd"" multiple onChange="javaScript:searchAllChart(); "></select>
								<input type="hidden" id="jikgubCd" name="jikgubCd" value=""/>
							</td>
							<th class="hide">재직구분</th>
							<td class="hide">
								<select id="searchStatusCd" name="searchStatusCd" class="box" multiple></select>
								<input type="hidden" id="statusCd" name="statusCd"/>
							</td>
							<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
							<td>
								<input id="searchPhotoYn" name="searchPhotoYn" type="checkbox" class="checkbox"/>
							</td>	
							<td> <btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
							<!-- 	
							<td>
								<span>제외 :
								<input id="checkExcept1" name="checkExcept1" type="checkbox"  class="checkbox" />&nbsp;휴직자
								<input id="checkExcept2" name="checkExcept2" type="checkbox"  class="checkbox" />&nbsp;등기임원
								<input id="checkExcept3" name="checkExcept3" type="checkbox"  class="checkbox" />&nbsp;인턴		
								</span>
							</td>
							 -->	
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
								<li class="txt">입/퇴사자 현황</li>
								<li class="btn">
									<btn:a href="javascript:doAction('Down2Excel')" 	css="btn outline-gray authA" mid='down2excel' mdef="다운로드"/>
								</li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>