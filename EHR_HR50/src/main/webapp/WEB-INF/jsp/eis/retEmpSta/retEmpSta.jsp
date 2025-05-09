<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
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
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"사진",		Type:"Image",	Hidden:0,   MinWidth:55,   Align:"Center", ColMerge:0, SaveName:"photo",		UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
            {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	    Type:"Text",      Hidden:0,  Width:60,	Align:"Center",  ColMerge:0,   SaveName:"sabun",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	    	Type:"Text",      Hidden:0,  Width:60, Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",	    Type:"Text",      Hidden:0,  Width:150, Align:"Left",  ColMerge:0,   SaveName:"orgNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",      Hidden:0,  Width:60, Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='jikweeNm' mdef='직위'/>",	    	Type:"Text",      Hidden:Number("${jwHdn}"),  Width:80, Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='jikgubNm' mdef='직급'/>",	    	Type:"Text",      Hidden:Number("${jgHdn}"),  Width:80, Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='workTypeNm' mdef='직군'/>",	    Type:"Text",      Hidden:0,  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"workTypeNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='manageNm' mdef='사원구분'/>",	    Type:"Text",      Hidden:0,  Width:80, Align:"Center",  ColMerge:0,   SaveName:"manageNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",	    Type:"Date",      Hidden:1,  Width:90, Align:"Center",  ColMerge:0,   SaveName:"gempYmd",     KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='empYmd' mdef='입사일'/>",	    	Type:"Date",      Hidden:0,  Width:90, Align:"Center",  ColMerge:0,   SaveName:"empYmd",     KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",	    	Type:"Date",      Hidden:0,  Width:90, Align:"Center",  ColMerge:0,   SaveName:"retYmd",     KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='term' mdef='근속년월'/>",		Type:"Text",      Hidden:0,  Width:100, Align:"Center",  ColMerge:0,   SaveName:"term",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='gTerm' mdef='그룹근속년월'/>",	Type:"Text",      Hidden:1,  Width:100, Align:"Center",  ColMerge:0,   SaveName:"gTerm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='memo2' mdef='퇴직사유'/>",	    	Type:"Text",      Hidden:1,  Width:200, Align:"Center",  ColMerge:0,   SaveName:"resignResonNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='ordDetailNm' mdef='퇴직사유'/>",	    	Type:"Text",      Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"ordDetailNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='ordReasonNm' mdef='발령세부사유'/>",	    	Type:"Text",      Hidden:1,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"ordReasonNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='memo' mdef='비고'/>",	    		Type:"Text",      Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"memo",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"조회권한",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"authYn", UpdateEdit:0 }
			
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        sheet1.SetDataLinkMouse("photo",1);	
		sheet1.SetDataLinkMouse("name",1);	

		getCommonCodeList();

		var enterCdList   = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getGroupEnterCdList", false).codeList, "");
		$("#groupEnterCd").html(enterCdList[2]);
		$("#groupEnterCd").val("${ssnEnterCd}");
		$("#groupEnterCd").on("change", function(event) {
				doAction1("Search");
		}).change();

		// 숫자만 입력가능
		$("#searchRecruitYyyyFrom,#searchInMonth").keyup(function() {
		     makeNumber(this,'A');
		 });


		$("#searchName,#searchRecruitYyyyFrom,#searchInMonth,#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
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
			doAction1("Search");
		});        
		*/
		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

		var basicInfo = ajaxCall("${ctx}/RetEmpSta.do?cmd=getRetEmpStaMap", $("#srchFrm").serialize(), false);

		if (basicInfo.DATA != null) {
			$("#nowCnt").html(basicInfo.DATA.nowCnt);
			$("#termCnt").html(basicInfo.DATA.termCnt);
			$("#retireCnt").html(basicInfo.DATA.retireCnt);
			$("#retirePer").html(basicInfo.DATA.retirePer);
		}
	});

	function getCommonCodeList() {
		let baseSYmd = $("#searchYmdFrom").val();
		let baseEYmd = $("#searchYmdTo").val();

		var resultData1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010", baseSYmd, baseEYmd), "");		//직위
		var resultData2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030", baseSYmd, baseEYmd), "");		//사원구분
		var resultData3 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050", baseSYmd, baseEYmd), "");		//직군

		$("#searchJikgubNm").html(resultData1[2]);
		$("#searchJikgubNm").select2({placeholder:" 전체"});

		$("#searchManageCd").html(resultData2[2]);
		$("#searchManageCd").select2({placeholder:" 전체"});

		$("#searchWorkType").html(resultData3[2]);
		$("#searchWorkType").select2({placeholder:" 전체"});
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
							$("#multiJikgubNm").val(getMultiSelect($("#searchJikgubNm").val()));
							$("#multiManageCd").val(getMultiSelect($("#searchManageCd").val()));
							$("#multiWorkType").val(getMultiSelect($("#searchWorkType").val()));
							
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
							sheet1.DoSearch( "${ctx}/RetEmpSta.do?cmd=getRetEmpStaList", $("#srchFrm").serialize() );
							var basicInfo = ajaxCall("${ctx}/RetEmpSta.do?cmd=getRetEmpStaMap", $("#srchFrm").serialize(), false);

							if (basicInfo.DATA != null) {
								$("#nowCnt").html(basicInfo.DATA.nowCnt);
								$("#termCnt").html(basicInfo.DATA.termCnt);
								$("#retireCnt").html(basicInfo.DATA.retireCnt);
								$("#retirePer").html(basicInfo.DATA.retirePer);
							}
							break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/RetEmpSta.do?cmd=saveRetEmpSta", $("#srchFrm").serialize()); break;
		case "Insert":		sheet1.SelectCell(sheet1.DataInsert(0), "col2"); break;
		case "Copy":		sheet1.DataCopy(); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
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

		$("#searchYmdFrom").datepicker2({startdate:"searchYmdTo", onReturn: getCommonCodeList});
		$("#searchYmdTo").datepicker2({enddate:"searchYmdFrom", onReturn: getCommonCodeList});

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
			alert("<msg:txt mid='109611' mdef='권한이 없거나 존재하지 않는 메뉴입니다.'/>");
			return;
		}

		// 서브페이지에서 서브페이지 호출
		if(typeof window.top.goOtherSubPage == 'function') {
			window.top.goOtherSubPage("", "", "", "", prgData.map.prgCd);
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="multiJikgubNm" name="multiJikgubNm"/>
		<input type="hidden" id="multiManageCd" name="multiManageCd"/>
		<input type="hidden" id="multiWorkType" name="multiWorkType"/>
		
		<input type="hidden" id="except1" name="except1"/>
		<input type="hidden" id="except2" name="except2"/>
		<input type="hidden" id="except3" name="except3"/>		
				
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th class="spEnterCombo hide">회사 </th>
						<td class="spEnterCombo hide">
							<select id="groupEnterCd" name="groupEnterCd" class="w150"></select>
						</td>
						<th><tit:txt mid='114619' mdef='기간검색 '/></th>
						<td>  <input id="searchYmdFrom" name ="searchYmdFrom" type="text" class="date2 required"  maxlength="10" value="<%= DateUtil.getCurrentTime("yyyy-01-01")%>"/>
							 &nbsp;~&nbsp;&nbsp;<input id="searchYmdTo" name ="searchYmdTo" type="text" class="date2 required" maxlength="10" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<th>소속  </th>
						<td>  <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" /> </td>	
						<th>성명  </th>					
						<td>  <input id="searchName" name="searchName" type="text" class="text" /></td>
					</tr>
					<tr>	
						<th>사원구분</th>
						<td>  <select id="searchManageCd" name="searchManageCd" multiple> </select> </td>
						<th>직군</th>
						<td>  <select id="searchWorkType" name="searchWorkType" multiple> </select> </td>		
						<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>					
						<td>
							<input id="searchPhotoYn" name="searchPhotoYn" type="checkbox" class="checkbox"/>
						</td>	
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
				<div style="margin-top: 8px">
					<form id="infoFrom" name="infoFrom">
						<table border="0" cellpadding="0" cellspacing="0" class="default outer">
						<colgroup>
							<col width="10%" />
							<col width="15%" />
							<col width="10%" />
							<col width="15%" />
							<col width="10%" />
							<col width="15%" />
							<col width="10%" />
							<col width="*" />
						</colgroup>
						<tr>
							<th class="right"><tit:txt mid='104015' mdef='현재인원'/></th>
							<td class="right" style="padding-right: 20px" >
								<span id="nowCnt" >00</span> 명
							</td>
							<th class="right"><tit:txt mid='114224' mdef='전년말인원'/></th>
							<td class="right" style="padding-right: 20px" >
								<span id="termCnt"></span> 명
							</td>
							<th class="right"><tit:txt mid='112818' mdef='퇴직인원'/></th>
							<td class="right" style="padding-right: 20px" >
								<span id="retireCnt"></span> 명
							</td>
							<th class="right"><tit:txt mid='113180' mdef='퇴직율'/></th>
							<td class="right" style="padding-right: 20px" >
								<span id="retirePer"></span>%
							</td>
						</tr>
						</table>
					</form>
				</div>
			</td>
		</tr>
	</table>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112120' mdef='기간별퇴사자현황'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
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
