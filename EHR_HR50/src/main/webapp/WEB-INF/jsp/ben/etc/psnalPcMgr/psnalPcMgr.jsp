<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>개인PC정보</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

		
		$("#searchSabunName").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		$("#searchStatusCd").bind("change",function(event){
			doAction1("Search");
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
			
			//Hidden
			{Header:"Hidden",	Type:"Text", Hidden:1, SaveName:"orgCd"},
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetEditable(0);

		sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함

	}
	
	//PC현황
	function init_sheet1(){ 
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
    		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			
   			{Header:"소속",		Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"성명",		Type:"Popup",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:1 },
			{Header:"직위",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			
			{Header:"시리얼넘버",	Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"serialNo",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"상태",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:1,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"시작일",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	UpdateEdit:1,	InsertEdit:1 , EndDateCol:"edate"},
			{Header:"종료일",		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	UpdateEdit:1,	InsertEdit:1 , StartDateCol:"sdate"},
			{Header:"제품명",		Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"prodNm",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"유형",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prodType",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"제조업체",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"prodComp",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"제조년월",	Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"prodYm",		KeyField:0,	Format:"Ym",	UpdateEdit:1,	InsertEdit:1 },
			{Header:"프로세서",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"processor",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"RAM",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ram",			KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"메모",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			//Hidden
			{Header:"Hidden",	Hidden:1, SaveName:"seq" },
			{Header:"Hidden",	Hidden:1, SaveName:"orgCd" },
				
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);


 		//==============================================================================================================================
		//공통코드 한번에 조회
		var grpCds = "B74010,B74020";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "전체");
		
		sheet1.SetColProperty("prodType", 	{ComboText:"|"+codeLists["B74010"][0], ComboCode:"|"+codeLists["B74010"][1]} );
		sheet1.SetColProperty("statusCd", 	{ComboText:codeLists["B74020"][0], ComboCode:codeLists["B74020"][1]} );
		//==============================================================================================================================
		$("#searchStatusCd").html(codeLists["B74020"][2]);
		
	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
					var sdate = sheet1.GetCellValue(i, "sdate");
					var edate = sheet1.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/PsnalPcMgr.do?cmd=getPsnalPcMgrList", $("#sheet1Form").serialize()+"&"+$("#sheet2Form").serialize());
			sheet1.LoadSearchData(sXml );
			break;
		case "Save":
			if(!chkInVal()){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PsnalPcMgr.do?cmd=savePsnalPcMgr", $("#sheet1Form").serialize()); break;
		case "Insert":
 			var newRow = sheet1.DataInsert(0);
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
			sheet2.DoSearch( "${ctx}/PsnalPcMgr.do?cmd=getPsnalPcMgrOrgList", $("#sheet2Form").serialize() ); 
			break;
		case "Down2Excel":	
			sheet2.Down2Excel(); 
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

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "employeePopup";
	            //var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "740","520");
		        let layerModal = new window.top.document.LayerModal({
		              id : 'employeeLayer'
		            , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
		            , parameters : {}
		            , width : 740
		            , height : 520
		            , title : '사원조회'
		            , trigger :[
		                {
		                    name : 'employeeTrigger'
		                    , callback : function(result){
		                    	getReturnValue(result);
		                     }
		                 }
		             ]
		         });
		         layerModal.show();
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
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
	
	//팝업 콜백
	function getReturnValue(rv) {
		if (pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name",			rv["name"] );
			sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
			sheet1.SetCellValue(gPRow, "orgCd",			rv["orgCd"] );
		}
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
			<col width="300px" />
			<col width="30px" />
			<col width="" />
		</colgroup>
		<tr>
			<td class="sheet_left">
			
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
			<td class="sheet_right"><div style="padding-top:200px;" class="setBtn"><img src="/common/images/sub/ico_arrow.png"/></div></td>
		
			<td class="sheet_right">
				<form id="sheet1Form" name="sheet1Form" >
					<input type="hidden" id="searchOrgCd" name="searchOrgCd">
					
					<div class="sheet_search outer">
						<table>
						<tr>
							<th>상태</th>
							<td>
								<select id="searchStatusCd" name="searchStatusCd"> </select>
							</td>
							<th>사번/성명</th>
							<td>
								<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
							</td>
							<td>
								<span><label for="searchOrgType">하위조직포함</label></span>
								<input type="checkbox" id="searchOrgType" name="searchOrgType" value="Y" onclick="doAction1('Search');" checked />
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
							<li id="txt" class="txt">개인PC정보</li>
							<li class="btn">								
								<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
								<a href="javascript:doAction1('Copy');" 		class="btn outline-gray authA">복사</a>
								<a href="javascript:doAction1('Insert');" 		class="btn outline-gray authA">입력</a>
								<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
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