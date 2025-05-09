<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>조직별근무조관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var popGubun;

	$(function() {

		
		$("#searchSabunName").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		//조직도 select box
		var searchSdate = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList
				        , "edate"
				        , "");	//조직도
		$("#searchSdate").html(searchSdate[2]);


	    $("#searchYmd").datepicker2({
   			onReturn:function(date){
   				doAction1("Search");
   			}
        });
		$("#searchYmd").bind("keydown",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		
		
		$("#searchWorkteamCd, #searchBizPlaceCd, #searchWorkOrgGubun").bind("change",function(event){
			doAction1("Search");
		});

		$("#searchSdate").bind("change",function(event){
	    	doAction2("Search");
	    });
		
		// 트리레벨 정의
		$("#btnPlus").toggleClass("minus");

		// 트리레벨 정의
		$("#btnStep1").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet2.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			$("#btnPlus").removeClass("minus");
			sheet2.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			if(!$("#btnPlus").hasClass("minus")){
				$("#btnPlus").toggleClass("minus");
				sheet2.ShowTreeLevel(-1);
			}
		});
		$("#btnPlus").click(function() {
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet2.ShowTreeLevel(-1):sheet2.ShowTreeLevel(0, 1);
		});
		
	    $("#findText").bind("keyup",function(event){
	    	if( event.keyCode == 13){ findOrgNm() ; }
	    });
		
	    $("#txtLink").click(function() {
    	
	    	let prgCd = 'OrgMappingMgr.do?cmd=viewOrgMappingMgr';
            window.top.goOtherSubPage("", "", "", "", prgCd);
	    });
	    
		init_sheet1();
		init_sheet2();

		$(window).smartresize(sheetResize); sheetInit();
		doAction2("Search");
		
	});

	
	//조직트리
	function init_sheet2(){ 
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			
			{Header:"조직명",		Type:"Text",		Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",			Cursor:"Pointer",    TreeCol:1,  LevelSaveName:"sLevel" },
			{Header:"기본근무조",	Type:"Text",		Hidden:0,  Width:0,    Align:"Center",	ColMerge:0,   SaveName:"workOrgNm",	 },
			
			//Hidden
			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"orgCd"},
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetEditable(0);

		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함

	}
	
	//근무조관리
	function init_sheet1(){ 
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
    		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"\n삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			
   			{Header:"소속",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"성명",		Type:"Popup",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:1 },
			{Header:"직급",		Type:"Text",		Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"구분",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workOrgGubun",KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"근무조",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workOrgCd",	KeyField:1,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"시작일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	UpdateEdit:1,	InsertEdit:1 },
			{Header:"종료일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
			{Header:"메모",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			//Hidden
			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"mapTypeCd" },
				
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//근무조
		//var workOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTorg109List&mapTypeCd=500",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
		var workOrgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTimWorkTeamCodeList",false).codeList, "전체");
		sheet1.SetColProperty("workOrgCd", 			{ComboText:"|"+workOrgCdList[0], ComboCode:"|"+workOrgCdList[1]} );
		$("#searchWorkteamCd").html(workOrgCdList[2]);

		//구분
		$("#searchWorkOrgGubun").html("<option value=''><tit:txt mid='103895' mdef='전체'/></option><option value='B'><tit:txt mid='104103' mdef='기본'/></option><option value='E'><tit:txt mid='2017082900888' mdef='예외'/></option>");
		sheet1.SetColProperty("workOrgGubun",		{ComboText:"|<tit:txt mid='104103' mdef='기본'/>|<tit:txt mid='2017082900888' mdef='예외'/>", ComboCode:"|B|E"} );

/*
		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}		
		var businessPlaceCd = "";
		if(allFlag) {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장	
		} else {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchBizPlaceCd").html(businessPlaceCd[2]);
*/
		
	}


	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			var sXml = sheet1.GetSearchData("${ctx}/OrgWorkOrgMgr.do?cmd=getOrgWorkOrgMgrList", $("#sheet1Form").serialize()+"&"+$("#sheet2Form").serialize());
			sXml = replaceAll(sXml,"sdateEdit", "sdate#Edit");
			sheet1.LoadSearchData(sXml );
			
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|sdate", false, true)){break;}

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/OrgWorkOrgMgr.do?cmd=saveOrgWorkOrgMgr", $("#sheet1Form").serialize()); break;
		case "Insert":
			//신규로우 생성 및 변경
 			var newRow = sheet1.DataInsert(0);
			sheet1.SetCellValue(newRow, "mapTypeCd",  "500");
			break;
		case "Copy":
			var newRow = sheet1.DataCopy();
			sheet1.SetCellValue(newRow, "sdate",  "");
			sheet1.SetCellEditable(newRow, "sdate",  1);
			sheet1.SetCellValue(newRow, "workOrgGubun",  "E");
			
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchEdate").val($("#searchSdate option:selected").attr("edate"));
			sheet2.DoSearch( "${ctx}/OrgWorkOrgMgr.do?cmd=getOrgWorkOrgMgrOrgList", $("#sheet2Form").serialize() ); 
			break;
		case "Down2Excel":	
			sheet2.Down2Excel(); 
			break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			$('#searchOrgCd').val(sheet2.GetCellValue(1,"orgCd"));
		    doAction1("Search");   
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			$('#searchOrgCd').val(sheet2.GetCellValue(NewRow,"orgCd"));
		    doAction1("Search");
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	

	function findOrgNm() {
		var startRow = sheet2.GetSelectRow()+1 ;
		startRow = (startRow >= sheet2.LastRow() ? 1 : startRow ) ;
		var selectPosition = sheet2.FindText("orgNm", $("#findText").val(), startRow, 2) ;
		if(selectPosition == -1) {
			sheet2.SetSelectRow(1) ;
			alert("<msg:txt mid='alertOrgTotalMgrV2' mdef='마지막에 도달하여 최상단으로 올라갑니다.'/>") ;
		} else {
			sheet2.SetSelectRow(selectPosition) ;
		}
		$('#searchOrgCd').val(sheet2.GetCellValue(selectPosition,"orgCd"));
		doAction1("Search");
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
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
				doAction1('Search');
			}

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
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

	function sheet1_OnClick(Row, Col, Value) {
		try{

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	var gPRow = "";
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}

				gPRow = Row;
				popGubun = "insertE";
	            var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "740","520");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if (popGubun == "insertE"){
			sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name",			rv["name"] );
			sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
			sheet1.SetCellValue(gPRow, "manageNm",		rv["manageNm"] );
	        sheet1.SetCellValue(gPRow, "workTypeNm",	rv["workTypeNm"] );
	        sheet1.SetCellValue(gPRow, "payTypeNm",		rv["payTypeNm"] );
		}else if( popGubun == "O" ){
			$("#searchOrgCd").val(rv["orgCd"]);
        	$("#searchOrgNm").val(rv["orgNm"]);
        	doAction1("Search");
		}else if( popGubun == "E" ){
			$("#searchSabun").val(rv["sabun"]);
			$("#name"       ).val(rv["name"]);
        	doAction1("Search");
		}
	}

	function showOrgPopup(){
		if(!isPopup()) {return;}

		popGubun = "O";
		var rst = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", "", "740","520");
	}

	// 사원 팝업
	function showEmployeePopup() {
		if(!isPopup()) {return;}

		popGubun = "E";
        var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "740","520");
	}


	function clearCode(num){
		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
		} else {
			$("#name").val("");
		}
	}

	function chVisibleType(){
		var oddEvenFlag = 'o';
		var endNumber = 70;
		if($("#visibleType").val() == "wPlace"){
			for(i = 9; i <= endNumber; i++){
				if(oddEvenFlag == 'o'){
					sheet1.SetColHidden(i, 0);
					oddEvenFlag = 'e';
				}else{
					sheet1.SetColHidden(i, 1);
					oddEvenFlag = 'o';
				}
			}
		}else if($("#visibleType").val() == "wTeam"){
			for(i = 9; i <= endNumber; i++){
				if(oddEvenFlag == 'o'){
					sheet1.SetColHidden(i, 1);
					oddEvenFlag = 'e';
				}else{
					sheet1.SetColHidden(i, 0);
					oddEvenFlag = 'o';
				}
			}
		}else{
			for(i = 9; i <= endNumber; i++){
				sheet1.SetColHidden(i, 0);
			}
		}
	}

</script>
<style type="text/css">
a.txt-link{ text-decoration: underline!important;; color:#0000ff!important;; cursor:pointer!important;;}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
			<col width="400px" />
			<col width="30px" />
			<col width="" />
		</colgroup>
		<tr>
			<td class="sheet_left">
			
				<form id="sheet2Form" name="sheet2Form" >
					<input type="hidden" id="searchEdate" name="searchEdate" />
					<div class="sheet_search sheet_search_s inner">
						<table>
						<tr>
							<td>
								<select id="searchSdate" name ="searchSdate" class="w250"></select>
							</td>
						</tr>
						<tr>
							<td>
								<a id="txtLink" class="txt-link">기본근무조 등록</a> 
							</td>
						<tr>
						</table>
					</div>
				</form>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='112713' mdef='조직도'/>&nbsp;
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
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "30%", "100%", "${ssnLocaleCd}"); </script>

			</td>
			<td class="center"><div class="setBtn"><img src="/common/images/sub/ico_arrow.png"/></div></td>
		
			<td class="sheet_right">
				<form id="sheet1Form" name="sheet1Form" >
					<input type="hidden" id="searchOrgCd" name="searchOrgCd">
					<input type="hidden" id="searchSht2Gbn" name="searchSht2Gbn">
					
					<div class="sheet_search inner">
						<table>
						<tr>
							<th><tit:txt mid='104535' mdef='기준일'/> </th>
							<td>
								<input type="text" id="searchYmd" name="searchYmd"  class="date2 required" value="${curSysYyyyMMdd}" />
							</td>
							<th><tit:txt mid='2017082900889' mdef='근무조'/> </th>
							<td>
								<select id="searchWorkteamCd" name="searchWorkteamCd"> </select>
							</td>
							<th><tit:txt mid='2017082900889' mdef='근무조'/><tit:txt mid='113694' mdef='구분'/> </th>
							<td>
								<select id="searchWorkOrgGubun" name="searchWorkOrgGubun"> </select>
							</td>
							
						</tr>
						<tr>
							<th><tit:txt mid='104330' mdef='사번/성명'/> </th>
							<td>
								<input type="text" id="searchSabunName"  name="searchSabunName"  class="text w100"/>
							</td>
							<th><tit:txt mid='2017082900891' mdef='전체이력'/></th>
							<td>	
								<input id="searchHistoryYn" name="searchHistoryYn" type="checkbox" class="checkbox" value="Y" />
							</td>
							<!-- td ><th><tit:txt mid='114399' mdef='사업장'/></th>
								<select id="searchBizPlaceCd" name="searchBizPlaceCd"> </select>
							</td -->
							<th class="hide"><tit:txt mid='2017082900890' mdef='미편성여부'/></th>
							<td class="hide">
								<input id="searchMapCdYn" name="searchMapCdYn" type="checkbox" class="checkbox" value="Y"/>
							</td>
							<th><label for="searchOrgType"><tit:txt mid='104304' mdef='하위조직포함'/></label></th>
							<td>
								<input type="checkbox" id="searchOrgType" name="searchOrgType" value="Y" onclick="doAction1('Search');" />
							</td>
							<td>
								<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
							</td>
						</tr>
						</table>
					</div>
				</form>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='2017082900892' mdef='근무조관리'/></li>
							<li class="btn">								
								<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='download' mdef="다운로드"/>
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