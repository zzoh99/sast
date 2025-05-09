<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인장현황관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		$("#searchStatusCd").bind("change",function(event){
			doAction1("Search");
		});

		//기준일자 날짜형식, 날짜선택 시 
		$("#searchYmd").datepicker2({
			onReturn:function(){
				doAction3("Search");
			}
		});
		//기준일자 날짜형식, 날짜선택 시 
		$("#searchYmd2").datepicker2({
			onReturn:function(){
				doAction1("Search");
			}
		});
		
		
		//조직도 select box
		var searchSdate = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrgSchemeSdate",false).codeList
				        , "edate"
				        , "");	//조직도
		$("#searchSdate").html(searchSdate[2]);

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
			$("#btnPlus").removeClass("minus");
			sheet2.ShowTreeLevel(2,3);
		});
		$("#btnPlus").click(function() {
			$("#btnPlus").toggleClass("minus");
			$("#btnPlus").hasClass("minus")?sheet2.ShowTreeLevel(-1):sheet2.ShowTreeLevel(0, 1);
			
		});
		
	    $("#findText").bind("keyup",function(event){
	    	if( event.keyCode == 13){ findOrgNm() ; }
	    });
		
	    	    
		init_sheet1();init_sheet2();init_sheet3();

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
			
			//Hidden
			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"orgCd"},
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetEditable(0);

		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		$("#searchOrgCd").val(sheet2.GetCellValue(sheet2.GetSelectRow(),"orgCd"));
	}
	
	//인장현황
	function init_sheet1(){ 
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
    		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			
   			{Header:"소속",		Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"등록번호",	Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"sealNo",		KeyField:1,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"등록일자",	Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	UpdateEdit:1,	InsertEdit:1 },
			{Header:"인장상태",	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:1,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"폐기일자",	Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	UpdateEdit:1,	InsertEdit:1 },
			{Header:"폐기반납자",	Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"disSabun",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"폐기반납자",	Type:"Popup",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"disName",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"페기사유",	Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"disReason",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"소각일자",	Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"disYmd",		KeyField:0,	Format:"Ymd",	UpdateEdit:1,	InsertEdit:1 },
			{Header:"첨부파일",	Type:"Html",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		Edit:0 },
			{Header:"메모",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			
			//Hidden
			{Header:"Hidden",	Hidden:1, SaveName:"seq" },
			{Header:"Hidden",	Hidden:1, SaveName:"orgCd" },
			{Header:"Hidden",	Hidden:1, SaveName:"fileSeq" },
				
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		
 		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "B74210";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		
		sheet1.SetColProperty("statusCd", 	{ComboText:codeLists["B74210"][0], ComboCode:codeLists["B74210"][1]} );
		//==============================================================================================================================
		$("#searchStatusCd").html(codeLists["B74210"][2]);
		
	}

	//관리책임자
	function init_sheet3(){ 
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
    		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			
   			{Header:"담당구분",	Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gubun",		KeyField:1,	Format:"",		UpdateEdit:0,	InsertEdit:1 },
   			{Header:"시작일자",	Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:1 },
			{Header:"종료일자",	Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	UpdateEdit:0,	InsertEdit:0 },
			{Header:"사번",		Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"성명",		Type:"Popup",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"직위",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"메모",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },

			//Hidden
			{Header:"Hidden",	Hidden:1, SaveName:"orgCd" },
			{Header:"Hidden",	Hidden:1, SaveName:"seq" },
				
		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(0);

		sheet3.SetColProperty("gubun", 	{ComboText:"|책임자|담당자|", ComboCode:"|1|2|"} );
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/SealMgr.do?cmd=getSealMgrList", $("#sheet1Form").serialize()+"&"+$("#sheet2Form").serialize());
			sheet1.LoadSearchData(sXml );
			break;
		case "Save":
			$("#searchOrgCd").val(sheet2.GetCellValue(sheet2.GetSelectRow(),"orgCd"));

			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/SealMgr.do?cmd=saveSealMgr", $("#sheet1Form").serialize()); break;
		case "Insert":
 			var newRow = sheet1.DataInsert(0);
 			sheet1.SetCellValue(newRow, "orgCd",  sheet2.GetCellValue(sheet2.GetSelectRow(),"orgCd"));
 			sheet1.SetCellValue(newRow, "orgNm",  sheet2.GetCellValue(sheet2.GetSelectRow(),"orgNm"));
			break;
		case "Copy":
			var newRow = sheet1.DataCopy();
			sheet1.SetCellValue(newRow, "seq",  "");
			sheet1.SetCellValue(newRow, "sdate",  "");
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#searchEdate").val($("#searchSdate option:selected").attr("edate"));
			sheet2.DoSearch( "${ctx}/SealMgr.do?cmd=getSealMgrOrgList", $("#sheet2Form").serialize() ); 
			break;
		case "Down2Excel":	
			sheet2.Down2Excel(); 
			break;
		}
	}

	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			sheet3.DoSearch( "${ctx}/SealMgr.do?cmd=getSealMgrMngList", $("#sheet1Form").serialize()+"&searchYmd="+$("#searchYmd").val());
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form, sheet3);
			sheet3.DoSave( "${ctx}/SealMgr.do?cmd=saveSealMgrMng", $("#sheet1Form").serialize() ); 
			break;
		case "Insert":
 			var newRow = sheet3.DataInsert(0);
 			sheet3.SetCellValue(newRow, "orgCd",  sheet2.GetCellValue(sheet2.GetSelectRow(),"orgCd"));
 			sheet3.SetCellValue(newRow, "seq",    sheet2.GetCellValue(sheet2.GetSelectRow(),"seq"));
 			break;
		case "Copy":
			var newRow = sheet3.DataCopy();
			sheet3.SetCellValue(newRow, "edate",  "");
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet3.Down2Excel(param);
			break;
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------
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
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀 선택 시 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{

			if( NewRow < sheet2.HeaderRows() ) return;
			
			if( OldRow != NewRow ){ 
				$("#searchOrgCd").val(sheet1.GetCellValue(NewRow,"orgCd"));
				$("#searchSeq").val(sheet1.GetCellValue(NewRow,"seq"));
				$("#span_orgNm").html(sheet1.GetCellValue(NewRow,"orgNm"));
				$("#span_sealNo").html(sheet1.GetCellValue(NewRow,"sealNo"));
			    doAction3("Search"); 
			}else{
				$("#searchSeq").val("");
				$("#span_orgNm").html("");
				$("#span_sealNo").html("");
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "disName") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "sheet1_employeePopup";
	            var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "740","520");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    
		    if(sheet1.ColSaveName(Col) == "btnFile" ){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){

					gPRow = Row;
					pGubun = "viewFilePopup";
					
					openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg=A&uploadType=benSeal", param, "740","620");
				}

			}
		    
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}  
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	// 셀 선택 시 이벤트
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{

			if( NewRow < sheet2.HeaderRows() ) return;
			
			if( OldRow != NewRow ){ 
				$("#searchOrgCd").val(sheet2.GetCellValue(NewRow,"orgCd"));
			    doAction1("Search"); 
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	
	//명칭검색
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
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet3 Event
	//---------------------------------------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction3("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet3_OnPopupClick(Row,Col) {
		try {
			if(sheet3.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "sheet3_employeePopup";
	            openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "740","520");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//팝업 콜백
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if (pGubun == "sheet1_employeePopup"){
			sheet1.SetCellValue(gPRow, "disSabun",	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "disName",	rv["name"] );
		}else if (pGubun == "sheet3_employeePopup"){
			sheet3.SetCellValue(gPRow, "sabun",	rv["sabun"] );
			sheet3.SetCellValue(gPRow, "name",	rv["name"] );
			sheet3.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
			
		}else if (pGubun == "viewFilePopup"){

			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<a class="sbasic">다운로드</a>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<a class="sbasic">첨부</a>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		}
		
		
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	
	<table class="sheet_main">
	<colgroup>
			<col width="300px" />
			<col width="30px" />
			<col width="" />
		</colgroup>
		<tr>
			<td class="sheet_left" rowspan="2">
			
				<form id="sheet2Form" name="sheet2Form" >
					<input type="hidden" id="searchEdate" name="searchEdate" />
					<div class="sheet_search sheet_search_x">
						<table>
						<tr>
							<td>
								<select id="searchSdate" name ="searchSdate" class="w200"></select>
							</td>
						</tr>
						</table>
					</div>
				</form>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112713' mdef='조직도'/>&nbsp;
								<div class="util">
								<ul>
									<li	id="btnPlus" class="btnClose"></li>
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
							<li class="btn">
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "30%", "100%", "${ssnLocaleCd}"); </script>

			</td>
			<td class="sheet_right" rowspan="2"><div style="padding-top:200px;" class="setBtn"><img src="/common/images/sub/ico_arrow.png"/></div></td>
		
			<td class="sheet_right">
				<form id="sheet1Form" name="sheet1Form" >
					<input type="hidden" id="searchOrgCd" name="searchOrgCd">
					<input type="hidden" id="searchSeq" name="searchSeq">
					
					<div class="sheet_search outer">
						<table>
						<tr>
							<th>기준일자</th>
							<td>
								<input type="text" id="searchYmd2" name="searchYmd2" class="date2" value="${curSysYyyyMMddHyphen}"/>
							</td>
							<td>
								<span><label for="searchOrgType">하위조직포함</label></span>
								<input type="checkbox" id="searchOrgType" name="searchOrgType" value="Y" onclick="doAction1('Search');" />
							</td>
							<th>인장상태</th>
							<td>
								<select id="searchStatusCd" name="searchStatusCd"> </select>
							</td>
							<td>
								<a href="javascript:doAction1('Search');" class="button">조회</a>
							</td>
						</tr>
						</table>
					</div>
				</form>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">인장현황</li>
							<li class="btn">								
								<a href="javascript:doAction1('Insert');" 		class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy');" 		class="basic authA">복사</a>
								<a href="javascript:doAction1('Save');" 		class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<tr>
			<td class="sheet_right">
			
				<div class="sheet_search sheet_search_s inner">
					<table>
					<tr>
						<th>기준일자</th>
						<td>
							<input type="text" id="searchYmd" name="searchYmd" class="date2" value="${curSysYyyyMMddHyphen}"/>
						</td>
						<th>소속</th>
						<td>
							<label id="th_orgNm"></label>
						</td>
						<th>등록번호</th>
						<td>
							<label id="span_sealNo"></label>
						</td>
					</tr>
					</table>
				</div>
				
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">관리자</li>
							<li class="btn">								
								<a href="javascript:doAction3('Insert');" 		class="basic authA">입력</a>
								<a href="javascript:doAction3('Copy');" 		class="basic authA">복사</a>
								<a href="javascript:doAction3('Save');" 		class="basic authA">저장</a>
								<a href="javascript:doAction3('Down2Excel');" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "100%", "50%", "${ssnLocaleCd}"); </script>	
			
			</td>
		</tr>
	</table>
</div>
</body>
</html>