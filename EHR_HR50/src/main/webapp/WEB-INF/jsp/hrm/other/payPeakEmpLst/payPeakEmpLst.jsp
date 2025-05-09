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
		initdata.Cfg = {FrozenCol:11,SearchMode:smLazyLoad,MergeSheet:msPrevColumnMerge + msAll,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",  		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	MinWidth:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo"},

			{Header:"사진",		Type:"Image",	Hidden:0,   MinWidth:55,   Align:"Center", ColMerge:0, SaveName:"photo",		UpdateEdit:0, ImgMinWidth:50, ImgHeight:60},
			{Header:"사번",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속",		Type:"Text",	Hidden:0,	MinWidth:150,	Align:"Center",	ColMerge:1,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책코드",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직책",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직위코드",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직위",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급코드",	Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"직급",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"호봉",		Type:"Text",	Hidden:1,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"salClass",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"재직상태",	Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직무",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직군",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사원구분",	Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"급여유형",	Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"payTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"그룹입사일",	Type:"Date",	Hidden:Number("${gempYmdHdn}"),	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"입사일",		Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"성별",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"sexTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"생년월일",	Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"birYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"나이(만)",		Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"age",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"정년도래일",	Type:"Date",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"endWorkDate",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"임피적용년차",	Type:"Text",	Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"payPeakYear",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 } ,
			{Header:"조회권한",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"authYn", UpdateEdit:0 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetCountPosition(4);
		sheet1.FitColWidth();

		$("#searchYmd").datepicker2({
			onReturn: getCommonCodeList
		});
		getCommonCodeList();

		$("#searchOrgNm, #searchSabunName, #searchWorkPeakYear, #searchWorkPeakYearFrom, #searchWorkPeakYearTo, #searchYmd").on("keyup", function(e) {
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
			sheetResize();
		});
		
		// 사진포함 보여주기
		/*
		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}
		*/
		$("#searchPhotoYn").attr('checked', 'checked');
		/*
		$("#checkExcept1, #checkExcept2, #checkExcept3").on("click", function(e) {
			doAction("Search");
		});		
		*/
		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		sheet1.SetAutoRowHeight(0);
		sheet1.SetDataRowHeight(60);

		$(window).smartresize(sheetResize);
		sheetInit();
		doAction("Search");
	});

	function getCommonCodeList() {
		// 급여유형
		var payTypeList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10110", $("#searchYmd").val()), "");
		$("#searchPayType").html(payTypeList[2]);
		$("#searchPayType").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
		});

		// 직책
		var searchJikchakCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020", $("#searchYmd").val()), "");
		$("#searchJikchakCd").html(searchJikchakCd[2]);
		$("#searchJikchakCd").select2({
			placeholder: "전체",
			maximumSelectionSize:100
		});

		// 직위
		var searchJikweeCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030", $("#searchYmd").val()), "");
		$("#searchJikweeCd").html(searchJikweeCd[2]);
		$("#searchJikweeCd").select2({
			placeholder: "전체",
			maximumSelectionSize:100
		});

		// 직급
		var searchJikgubCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010", $("#searchYmd").val()), "");
		$("#searchJikgubCd").html(searchJikgubCd[2]);
		$("#searchJikgubCd").select2({
			placeholder: "전체",
			maximumSelectionSize:100
		});

		// 사원구분
		var searchManageCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030", $("#searchYmd").val()), "");
		$("#searchManageCd").html(searchManageCd[2]);
		$("#searchManageCd").select2({
			placeholder: "전체",
			maximumSelectionSize:100
		});
	}

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			$("#payType").val(($("#searchPayType").val()==null?"":getMultiSelect($("#searchPayType").val())));
			$("#jikchakCd").val(($("#searchJikchakCd").val()==null?"":getMultiSelect($("#searchJikchakCd").val())));
			$("#jikweeCd").val(($("#searchJikweeCd").val()==null?"":getMultiSelect($("#searchJikweeCd").val())));
			$("#jikgubCd").val(($("#searchJikgubCd").val()==null?"":getMultiSelect($("#searchJikgubCd").val())));		
			$("#manageCd").val(($("#searchManageCd").val()==null?"":getMultiSelect($("#searchManageCd").val())));
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
			sheet1.DoSearch( "${ctx}/PayPeakEmpLst.do?cmd=getPayPeakEmpLstList", $("#sendForm").serialize() ); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));
			break;
		}
	}
	
	// 필수값/유효성 체크
	function chkInVal(sAction) {
		if ($("#searchYmd").val() == "") {
			alert("기준일자를 입력하십시오.");
			$("#searchYmd").focus();
			return false;
		}

		if ($("#searchWorkPeakYearFrom").val() == "") {
			alert("임피기간을 입력하십시오.");
			$("#searchWorkPeakYearFrom").focus();
			return false;
		}
		
		if ($("#searchWorkPeakYearTo").val() == "") {
			alert("임피기간을 입력하십시오.");
			$("#searchWorkPeakYearTo").focus();
			return false;
		}
		
		if ($("#searchWorkPeakYear").val() == "") {
			alert("임피적용 년차를 입력하십시오.");
			$("#searchWorkPeakYear").focus();
			return false;
		}		
		
		return true;

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

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
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
				/*
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
		<form id="sendForm" name="sendForm" >
			<input type="hidden" id="except1" name="except1"/>
			<input type="hidden" id="except2" name="except2"/>
			<input type="hidden" id="except3" name="except3"/>		
					
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>기준일자</th>
							<td>
								<input id="searchYmd" name="searchYmd" maxlength="10" type="text" class="text date2 required" value="${curSysYyyyMMddHyphen}"/>
							</td>
							<th>임피기간</th>
							<td> 
								<input id="searchWorkPeakYearFrom" name ="searchWorkPeakYearFrom" type="text" class="text w30" style="padding:0 5px;" value="55" />세
							~ <input id="searchWorkPeakYearTo" name ="searchWorkPeakYearTo" type="text" class="text w30" style="padding:0 5px;" value="60" />세
							</td>
							<th>임피적용</th>
							<td> 
								<input id="searchWorkPeakYear" name ="searchWorkPeakYear" type="text" class="text w30" style="padding:0 5px;" value="55" />년차
							</td>
							<th>소속</th>
							<td>
								<input type="text" id="searchOrgNm" name="searchOrgNm" class="text" value="" />
							</td>
							<th>사번/성명</th>	
							<td>
								<input type="text" id="searchSabunName" name="searchSabunName" class="text" value="" />
							</td>
							<th class="hide"><tit:txt mid='202007270000002' mdef='부서장제외'/></th>
							<td colspan="3" class="hide">
								<input id="searchCheifYn" name="searchCheifYn" type="checkbox" class="checkbox" value="Y" checked="checked"/>
							</td>
							<!-- 
							<td colspan="2">
								<th>제외 :
								<input id="checkExcept1" name="checkExcept1" type="checkbox"  class="checkbox" />&nbsp;휴직자
								<input id="checkExcept2" name="checkExcept2" type="checkbox"  class="checkbox" />&nbsp;등기임원
								<input id="checkExcept3" name="checkExcept3" type="checkbox"  class="checkbox" />&nbsp;인턴		
								</th>
							</td>
							 -->	
						 	<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
							<td colspan="2">
								<input id="searchPhotoYn" name="searchPhotoYn" type="checkbox" class="checkbox"/>
							</td>						
						</tr>
						<tr>
							<th>직책</th>
							<td>
								<select id="searchJikchakCd" name="searchJikchakCd" class="box" multiple></select>
								<input type="hidden" id="jikchakCd" name="jikchakCd"/>
							</td>
							<th>직위</th>
							<td>
								<select id="searchJikweeCd" name="searchJikweeCd" class="box" multiple></select>
								<input type="hidden" id="jikweeCd" name="jikweeCd"/>
							</td>
							<th>직급</th>
							<td>
								
								<select id="searchJikgubCd" name="searchJikgubCd" class="box" multiple></select>
								<input type="hidden" id="jikgubCd" name="jikgubCd"/>
							</td>
							<th>사원구분</th>
							<td>
								<select id="searchManageCd" name="searchManageCd" class="box" multiple></select>
								<input type="hidden" id="manageCd" name="manageCd"/>
							</td>
							<th>급여유형</th>
							<td>
								<select id="searchPayType" name="searchPayType" class="box" multiple></select>
								<input type="hidden" id="payType" name="payType" />
							</td>
							
							<td class="right" colspan="2">
								<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
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
								<li class="txt">임금피크제관리</li>
								<li class="btn">
									<btn:a href="javascript:doAction('Down2Excel')" 	css="btn outline_gray authA" mid='down2excel' mdef="다운로드"/>
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