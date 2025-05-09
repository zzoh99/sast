<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var ssnSearchType = "${ssnSearchType}";

	$(function() {
		var initdata = {};
		//initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:4, MergeSheet:msHeaderOnly + msPrevColumnMerge};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:100, FrozenCol:13, MergeSheet:msHeaderOnly + msBaseColumnMerge};
		initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",  		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	MinWidth:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			//{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",   	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),MinWidth:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			//{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",   	Type:"${sSttTy}",	Hidden:0,					MinWidth:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },

			//{Header:"근무지코드",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:1,	SaveName:"locationCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			//{Header:"근무지",		Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:1,	SaveName:"locationNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			//{Header:"조직",		Type:"Text",	Hidden:1,	MinWidth:150,	Align:"Left",	ColMerge:1,	SaveName:"priorOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사진|사진",		Type:"Image",	Hidden:0,   MinWidth:55,   Align:"Center", ColMerge:0, SaveName:"photo",		UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
			{Header:"사번|사번",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명|성명",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"names",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"현 소속 (현재일 기준)|소속코드",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"현 소속 (현재일 기준)|소속",	Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현 소속 (현재일 기준)|직책",	Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현 소속 (현재일 기준)|직위",	Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현 소속 (현재일 기준)|직급",	Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현 소속 (현재일 기준)|직무",	Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"현 소속 (현재일 기준)|직군",	Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"현 소속 (현재일 기준)|사원구분",	Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"현 소속 (현재일 기준)|재직상태",	Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"기준 소속 (기준일 기준)|소속",		Type:"Text",	Hidden:0,	MinWidth:100,	Align:"Center",	ColMerge:0,	SaveName:"befOrgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, ColMerge:0 },
			{Header:"기준 소속 (기준일 기준)|직책",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"befJikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, ColMerge:0 },
			{Header:"기준 소속 (기준일 기준)|직위",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"befJikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, ColMerge:0 },
			{Header:"기준 소속 (기준일 기준)|직급",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"befJikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, ColMerge:0 },
			{Header:"기준 소속 (기준일 기준)|직무",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"befJobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, ColMerge:0 },
			{Header:"기준 소속 (기준일 기준)|직군",		Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"befWorkTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10, ColMerge:0 },
			{Header:"기준 소속 (기준일 기준)|사원구분",	Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"befManageNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"기준 소속 (기준일 기준)|재직상태",	Type:"Text",	Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"befStatusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|발령시작일",	Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"기준 소속 (기준일 기준)|발령종료일",	Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"기준 소속 (기준일 기준)|근무일수",	Type:"Int",		Hidden:0,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"dayCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|변경항목",	Type:"Text",	Hidden:0,	MinWidth:150,	Align:"Left",	ColMerge:0,	SaveName:"chgItemList",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"기준 소속 (기준일 기준)|본사/지점",	Type:"Combo",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"inoutType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|조직구분",	Type:"Combo",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"objectType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|조직업무구분",	Type:"Combo",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"orgWorkCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준 소속 (기준일 기준)|지점분류",	Type:"Combo",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"groupTypeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"기준 소속 (기준일 기준)|모지점",		Type:"Text",	Hidden:1,	MinWidth:60,	Align:"Center",	ColMerge:0,	SaveName:"mBranchNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"조회권한",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"authYn", UpdateEdit:0 }

			];IBS_InitSheet(sheet1, initdata);
			sheet1.SetEditable(false);
			sheet1.SetVisible(true);
			sheet1.SetCountPosition(4);
			sheet1.FitColWidth();
			sheet1.SetEditableColorDiff(0); //기본색상 출력

		var jobCdList		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getJobCdList",false).codeList, "");
		sheet1.SetColProperty("jobCd", {ComboText:"|"+jobCdList[0], ComboCode:"|"+jobCdList[1]});

		getStatusCd();

		//$("#searchStatusCd").val("AA");
		$("#searchStatusCd").select2({
			//placeholder: "전체",
			maximumSelectionSize:100
		});
		$("#searchStatusCd").select2("val", ["AA","CA"]);

		$("#sdate, #edate").datepicker2();
		
		$("#searchYmd").val("${curSysYyyyMMddHyphen}") ;//현재년월 세팅
		$("#searchBaseYmd").val("${curSysYyyyMMddHyphen}") ;//현재년월 세팅
		
		if("${ssnAdminYn}" == "Y") {
			$("#searchYmd").datepicker2({
				onReturn: getStatusCd
			});
		}else{
			$("#searchYmd").datepicker2({
				startdate:"searchBaseYmd",
				onReturn: getStatusCd
				});
		}
		
		$("#searchYmd").bind("change",function(event){
			if($("#searchYmd").val() > $("#searchBaseYmd").val() && $("#searchYmd").val().length ==10 && "${ssnAdminYn}" != "Y" ) {
				//alert("오늘 이전 날짜로 입력해주세요.");
				$("#searchYmd").val($("#searchBaseYmd").val()); 
				return;
			}
				
		});
		

		$("#searchOrgNm, #searchSabunName").on("keyup", function(e) {
			if(e.keyCode == 13) {
				doAction("Search");
			}
		});

		$("#searchPhotoYn").on("click", function(e) {
			//doAction("Search");
			
			if($("#searchPhotoYn").is(":checked") == true) {
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			} else {
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}
			
		});
		
		$("#searchPhotoYn").attr('checked', 'checked');
		
		/*
		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}
		*/
		/*
		$("#checkExcept1, #checkExcept2, #checkExcept3").on("click", function(e) {
			//doAction("Search");
		});
*/
		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		sheet1.SetAutoRowHeight(0);
		sheet1.SetDataRowHeight(60);

		$(window).smartresize(sheetResize);
		sheetInit();
		//doAction("Search");
	});

	function getStatusCd() {
		// 재직상태
		let baseSYmd = $("#searchYmd").val();
		const searchStatusCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd), "전체");
		$("#searchStatusCd").html(searchStatusCdList[2]);
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchYmd").val();

		// 직책코드(H20020)
		var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020", baseSYmd), "");
		sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

		// 직위코드(H20030)
		var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030", baseSYmd), "");
		sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

		// 직구분코드(H10050)
		var workType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050", baseSYmd), "");
		sheet1.SetColProperty("workType", {ComboText:workType[0], ComboCode:workType[1]});

		// 직급코드(H20010)
		var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010", baseSYmd), " ");
		sheet1.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});

		// 사원구분코드(H10030)
		var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030", baseSYmd), "");
		sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});

		// 재직상태코드(H10010)
		var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd), "");
		sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

		// 본사지점구분(W20050)
		var inoutType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "W20050", baseSYmd), "");
		sheet1.SetColProperty("inoutType", {ComboText:"|"+inoutType[0], ComboCode:"|"+inoutType[1]});

		// 조직구분(W20030)
		var objectType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "W20030", baseSYmd), "");
		sheet1.SetColProperty("objectType", {ComboText:"|"+objectType[0], ComboCode:"|"+objectType[1]});

		// 조직업무구분(W20070)
		var orgWorkCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "W20070", baseSYmd), "");
		sheet1.SetColProperty("orgWorkCd", {ComboText:"|"+orgWorkCd[0], ComboCode:"|"+orgWorkCd[1]});

		// 조직그룹분류(W20060)
		var groupTypeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "W20060", baseSYmd), "");
		sheet1.SetColProperty("groupTypeCd", {ComboText:"|"+groupTypeCd[0], ComboCode:"|"+groupTypeCd[1]});
	}

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			getCommonCodeList();
			$("#statusCd").val(($("#searchStatusCd").val()==null?"":getMultiSelect($("#searchStatusCd").val())));
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
			//sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getEmpOrdItemSrchList", $("#empForm").serialize() ); break;
			sheet1.DoSearch( "${ctx}/EmpOrdItemSrch.do?cmd=getEmpOrdItemSrchVer2List", $("#empForm").serialize() ); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			var d = new Date();
			var fName = "발령항목이력조회_" + d.getTime();
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

			if($("#searchPhotoYn").is(":checked") == true) {
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			} else {
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}

			//sheet1.SetCellFont("FontSize", sheet1.HeaderRows(), "workHist1", sheet1.HeaderRows()+sheet1.RowCount(), "workHist2", 10);
			sheet1.SetCellFont("FontSize", sheet1.HeaderRows(), "careerHist", sheet1.HeaderRows()+sheet1.RowCount(), "careerHist", 10);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
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
		if(sheet1.ColSaveName(Col) == "photo" || sheet1.ColSaveName(Col) == "names"){
			
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
			alert("<msg:txt mid='109611' mdef='권한이 없거나 존재하지 않는 메뉴입니다.'/>");
			return;
		}

    	var lvl 		= prgData.map.lvl;
    	var menuId		= prgData.map.menuId;
		var menuNm 		= prgData.map.menuNm;
		var menuNmPath	= prgData.map.menuNmPath;
		var prgCd 		= prgData.map.prgCd;
		var mainMenuNm 	= prgData.map.mainMenuNm;
		var surl      	= prgData.map.surl;
		parent.openContent(menuNm,prgCd,location,surl,menuId,paramObj);
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form id="empForm" name="empForm" >
			<input type="hidden" id="except1" name="except1"/>
			<input type="hidden" id="except2" name="except2"/>
			<input type="hidden" id="except3" name="except3"/>	
			<input type="hidden" id="searchBaseYmd" name="searchBaseYmd"/>		
		
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>기준일자</th>
							<td>
								<input id="searchYmd" name="searchYmd" maxlength="10" type="text" class="text date2 required" value="${curSysYyyyMMddHyphen}"/>
							</td>
							<th>발령기간</th>
							<td>
								<input id="sdate" name="sdate" maxlength="10" type="text" class="text date2" value=""/>
								~
								<input id="edate" name="edate" maxlength="10" type="text" class="text date2" value=""/>
							</td>
						</tr>
						<tr>
							<th>소속</th>
							<td>
								<input type="text" id="searchOrgNm" name="searchOrgNm" class="text" value="" />
							</td>
							<th>사번/성명</th>
							<td>
								<input type="text" id="searchSabunName" name="searchSabunName" class="text" value="" />&nbsp;&nbsp;&nbsp;
							</td>
							<th>재직구분</th>
							<td>
								<select id="searchStatusCd" name="searchStatusCd" class="box" multiple></select>
								<input type="hidden" id="statusCd" name="statusCd"/>
							</td>
						</tr>
						<tr>
							<td>
								<input id="searchOrgCd" name="searchOrgCd" type="checkbox" class="checkbox" checked="checked"  value="Y"/>
								<font style="vertical-align:middle;">&nbsp;<b>소속</b></font>&nbsp;&nbsp;&nbsp;
								<input id="searchJikchakCd" name="searchJikchakCd" type="checkbox" class="checkbox"  value="Y"/>
								<font style="vertical-align:middle;">&nbsp;<b>직책</b></font>&nbsp;&nbsp;&nbsp;
								<input id="searchJikweeCd" name="searchJikweeCd" type="checkbox" class="checkbox"  value="Y"/>
								<font style="vertical-align:middle;">&nbsp;<b>직위</b></font>&nbsp;&nbsp;&nbsp;
							</td>
							<td>
								<input id="searchJikgubCd" name="searchJikgubCd" type="checkbox" class="checkbox"  value="Y"/>
								<font style="vertical-align:middle;">&nbsp;<b>직급</b></font>&nbsp;&nbsp;&nbsp;
								<input id="searchJobCd" name="searchJobCd" type="checkbox" class="checkbox"  value="Y"/>
								<font style="vertical-align:middle;">&nbsp;<b>직무</b></font>&nbsp;&nbsp;&nbsp;
								<input id="searchWorkType" name="searchWorkType" type="checkbox" class="checkbox"  value="Y"/>
								<font style="vertical-align:middle;">&nbsp;<b>직군</b></font>&nbsp;&nbsp;&nbsp;
								<input id="searchManageCd" name="searchManageCd" type="checkbox" class="checkbox"  value="Y"/>
								<font style="vertical-align:middle;">&nbsp;<b>사원구분</b></font>&nbsp;&nbsp;&nbsp;
							</td>
							<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
							<td><input id="searchPhotoYn" name="searchPhotoYn" type="checkbox" class="checkbox" value="Y"/></td>
							<td colspan="2">
								<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
							</td>
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
								<li class="txt">발령항목이력조회</li>
								<li class="btn">
									<btn:a href="javascript:doAction('Down2Excel')" 	css="btn outline-gary authA" mid='down2excel' mdef="다운로드"/>
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