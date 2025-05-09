<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>교육과정 관련역량</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	
	$(function() {
	
		var searchEduSeq, eduCourseNm;
		var arg = p.popDialogArgumentAll();
		if( arg != undefined ) {
			searchEduSeq =	arg["eduSeq"];
			eduCourseNm =	arg["eduCourseNm"];
			
		}else{
			if ( p.popDialogArgument("eduSeq") 		!=null ) { searchEduSeq = p.popDialogArgument("eduSeq") }; 
			if ( p.popDialogArgument("eduCourseNm") !=null ) { eduCourseNm  = p.popDialogArgument("eduCourseNm") }; 
		}
		
		$("#searchEduSeq").val(searchEduSeq);
		$("#eduCourseNm").val(eduCourseNm);

        $("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
        init_sheet1();init_sheet2();
        doAction2("Search");
        doAction1("Search");

		$(window).smartresize(sheetResize); sheetInit();
	});

	/*
	 * sheet Init
	 */
	function init_sheet1(){
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0, FrozenColRight:0}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"역량군",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"priorCompetencyNm",KeyField:0, Format:"",	 UpdateEdit:0,	InsertEdit:0},
			{Header:"역량",		Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"competencyNm", 	KeyField:1, Format:"",	 UpdateEdit:0,	InsertEdit:0},
			{Header:"비고",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",	 UpdateEdit:1,	InsertEdit:1, EditLen:2000 },
			
			{Header:"Hidden", Hidden:1, SaveName:"eduSeq" },
			{Header:"Hidden", Hidden:1, SaveName:"competencyCd" },
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.FocusAfterProcess = false;
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
	}

	function init_sheet2(){
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0, FrozenColRight:2}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"역량군",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"priorCompetencyNm",KeyField:0, Format:"",	 UpdateEdit:0,	InsertEdit:0},
			{Header:"역량",		Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"competencyNm", 	KeyField:1, Format:"",	 UpdateEdit:0,	InsertEdit:0},
			{Header:"선택",		Type:"DummyCheck",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sel" },
			
			{Header:"Hidden", Hidden:1, SaveName:"competencyCd" },
			
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		sheet2.FocusAfterProcess = false;
		
		
	}
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			sheet1.DoSearch( "${ctx}/EduCourseMgr.do?cmd=getEduMgrComptyList", $("#sheet1Form").serialize() );
            break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/EduCourseMgr.do?cmd=saveEduMgrCompty", $("#sheet1Form").serialize());
			break;
		case "Insert":
			//var Row = sheet1.DataInsert();
			//competencyPop(Row);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
    } 
	
	/*Sheet Action*/
	function doAction2(sAction) {
		switch (sAction) {
		case "Search": //조회

			var sXml = sheet2.GetSearchData("${ctx}/EduCourseMgr.do?cmd=getEduMgrComptyStdList", $("#sheet1Form").serialize() );
			sXml = replaceAll(sXml,"rowEdit", "Edit");
			sXml = replaceAll(sXml,"selBackColor", "sel#BackColor");
			sheet2.LoadSearchData(sXml );
            break;
		case "Reg":

			var sRow = sheet2.FindCheckedRow("sel");
			if( sRow == "" ) return; 

			var arrRow = sRow.split("|");
			for(var i=0; i<arrRow.length; i++){  
				var dupChk = fineCompetencyCd( sheet2.GetCellValue(arrRow[i], "competencyCd") );
				if( dupChk == -1 ){
					var Row = sheet1.DataInsert(-1);
					sheet1.SetCellValue(Row, "priorCompetencyNm", sheet2.GetCellValue(arrRow[i], "priorCompetencyNm"));
					sheet1.SetCellValue(Row, "competencyNm", sheet2.GetCellValue(arrRow[i], "competencyNm"));
					sheet1.SetCellValue(Row, "competencyCd", sheet2.GetCellValue(arrRow[i], "competencyCd"));
				}
			}
			
			break;
		}
    } 
	function fineCompetencyCd(str){
		var rs = -1; 
		try{
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				if( $.trim(str) == $.trim(sheet1.GetCellValue(i, "competencyCd"))){
					rs = i;
				}
			}
			
		}catch(e){}
		return rs;
	}

	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			sheet2.CheckAll("sel", 0);       
			sheetResize();
	  	}catch(ex){
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
	
	// 셀 팝업 클릭 시
	function sheet1_OnPopupClick(Row, Col) {
		try {
			if (sheet1.ColSaveName(Col) == "competencyNm") {
				if (!isPopup()) {  return; }
				competencyPop(Row);
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//-----------------------------------------------------------------------------------
	//		sheet2 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지 
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg); 
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	//역량팝업
	function competencyPop(Row){
		if (!isPopup()) {  return; }

		gPRow = Row;
		pGubun = "competencyPop";
		
		var args	= new Array();
		args["selectType"] = "C"; //선택 가능

		openPopup("/Popup.do?cmd=competencySchemePopup", args,"740", "720");
	}
	//---------------------------------------------------------------------------------------------------------------
	// 팝업 콜백 함수.
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue + '}');

		if (pGubun == "competencyPop") { 

			sheet1.SetCellValue(gPRow, "priorCompetencyNm", rv["priorCompetencyNm"]);
			sheet1.SetCellValue(gPRow, "competencyCd", 		rv["competencyCd"]);
			sheet1.SetCellValue(gPRow, "competencyNm", 		rv["competencyNm"]);
			
			
		} 
	}
	
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>교육과정 관련역량</li>
			<li class="close"></li>
		</ul>
	</div>
	
	<div class="popup_main"> 
		<form id="sheet1Form" name="sheet1Form" >
			<input type="hidden" id="searchEduSeq" name="searchEduSeq" />
			<div class="sheet_search outer">
				<table>
				<tr>
					<th>교육과정명</th>
					<td>
						<input type="text" id="eduCourseNm" name="eduCourseNm" class="date2 readonly w350" readonly/>
					</td>
					<td>
						<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
					</td>
				</tr>
				</table>
			</div>	
		</form>  
		
		<table class="sheet_main">
		<colgroup>
			<col width="40%" />
			<col width="20px" />
			<col width="" />
		</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">역량분류표</li>
						<li class="btn">&nbsp;</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "100%"); </script>
			</td>	
			
			<td class="sheet_right">
				<div style="padding-top:200px;" class="setBtn">
					<a href="javascript:doAction2('Reg');"><img src="/common/images/sub/ico_arrow.png"/></a>
				</div>
			</td>
			<td class="sheet_right">	
		
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">교육 관련역량</li>
						<li class="btn">
							<!-- a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
							<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a -->
							<a href="javascript:doAction1('Save');" 		class="basic authA">저장</a>
							<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
			</td>
		</tr>
		</table>		
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large authR">닫기</a>
				</li>
			</ul>
		</div>				
	</div>       
</div>
</body>
</html>



