<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>평가ID관리</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var vSearchEvlYy = "";
	
	$(function() {
			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
			  		{Header:"No"				,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center",		ColMerge:0,   SaveName:"sNo" },
					{Header:"삭제"				,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", 	ColMerge:0,   SaveName:"sDelete" },
					{Header:"상태"				,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", 	ColMerge:0,   SaveName:"sStatus" },
					{Header:"평가명"    			,Type:"Combo",     	Hidden:0,  					Width:100,			Align:"Center", 	ColMerge:0,   SaveName:"appraisalCd",	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,	UpdateEdit:0,   InsertEdit:1,   EditLen:4 },  
					{Header:"평가단계"			,Type:"Combo",     	Hidden:0,  					Width:70,			Align:"Center", 	ColMerge:0,   SaveName:"appStepCd",		KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }, 
					{Header:"평가시행\n시작일"		,Type:"Date",		Hidden:0,  					Width:80,			Align:"Center", 	ColMerge:0,   SaveName:"appAsYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
					{Header:"평가시행\n종료일"		,Type:"Date",		Hidden:0,  					Width:80,			Align:"Center", 	ColMerge:0,   SaveName:"appAeYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
					{Header:"대상자생성\n기준일"	,Type:"Date",		Hidden:0,  					Width:80,			Align:"Center",		ColMerge:0,   SaveName:"dBaseYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"평가차수\n일정"		,Type:"Image",		Hidden:0,  					Width:80,			Align:"Center",		ColMerge:0,   SaveName:"temp1",			KeyField:0,   CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
					{Header:"비고"				,Type:"Text",		Hidden:0,  					Width:100,			Align:"Left",   	ColMerge:0,   SaveName:"note",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
			sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
			
			
			var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppScheduleCodeList&searchEvlYy="+$("#searchEvlYy").val(),false).codeList, "");
			
			sheet1.SetColProperty("appraisalCd", {ComboText:famList[0], ComboCode:famList[1]} );
			
			$("#appraisalCd").html(famList[2]);
			
			var codeList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00005"), "");		//평가단계
			
			sheet1.SetColProperty("appStepCd", {ComboText:codeList1[0], ComboCode:codeList1[1]} );
			
			
			//화살표 조회 방지용
			vSearchEvlYy = $("#searchEvlYy").val();
			
			$("#searchEvlYy").bind("keyup",function(){
				if($(this).val().length == 4 && vSearchEvlYy != $(this).val()){
					var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppScheduleCodeList&searchEvlYy="+$("#searchEvlYy").val(),false).codeList, "");
					$("#appraisalCd").html(famList[2]);
					sheet1.SetColProperty("appraisalCd", {ComboText:famList[0], ComboCode:famList[1]} );
					doAction1("Search");
				}
			});
			
			$(window).smartresize(sheetResize); sheetInit();
		    doAction1("Search");
	});	
</script>

<script type="text/javascript">

//Sheet1 Action
function doAction1(sAction) {
	switch (sAction) {
	case "Search": 	 	sheet1.DoSearch( "${ctx}/AppScheduleMgr.do?cmd=getAppScheduleMgrList", $("#srchFrm").serialize() ); break;
	case "Save": 		
		if (!dupChk(sheet1, "appraisalCd|appStepCd", false, true)) {break;}
		IBS_SaveName(document.srchFrm,sheet1);
		sheet1.DoSave( "${ctx}/AppScheduleMgr.do?cmd=saveAppScheduleMgr", $("#srchFrm").serialize()); break;
	case "Insert":		
		var Row = sheet1.DataInsert(0);
		sheet1.SetCellValue(Row, "appraisalCd", $("#appraisalCd").val());
		sheet1.SelectCell(Row, "appraisalYy"); 
		break;
	case "Copy":		sheet1.DataCopy(); break;
	case "Clear":		sheet1.RemoveAll(); break;
	case "Down2Excel":	
		var downcol = makeHiddenSkipCol(sheet1);
		var param = {DownCols:downcol, SheetDesign:1, Merge:1};
		sheet1.Down2Excel(param); 
	break;
	case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
	}
}

//조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try{ 
		if (Msg != ""){ 
			alert(Msg); 
		} 
		
		sheetResize(); 
	}catch(ex){
		alert("OnSearchEnd Event Error : " + ex); 
	}
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try{ 
		if(Msg != ""){ 
			alert(Msg); 
		} 
		doAction1("Search");
	}catch(ex){ 
		alert("OnSaveEnd Event Error " + ex); 
	}
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
	
	
	if(Row > 0 && sheet1.ColSaveName(Col) == "temp1"){
		if( sheet1.GetCellValue(Row,"sStatus") == "I" ) {
            alert("입력 상태에서는 평가그룹설정을 할 수 없습니다. \n저장 한 후 설정하시기 바랍니다.");
            return;
        } 
		
		var args    = new Array();
        
        args["appraisalCd"]   = sheet1.GetCellValue(Row, "appraisalCd");
        args["appStepCd"]     = sheet1.GetCellValue(Row, "appStepCd");
        args["searchEvlYy"]   = $("#searchEvlYy").val(); 
		
		var rv = openPopup("/AppScheduleMgr.do?cmd=viewAppScheduleMgrPop"+"&authPg=${authPg}", args, "1000","520");   
		if(rv!=null){
			
		}
	}
}




</script>



</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가년도</span>
							<input id="searchEvlYy" name ="searchEvlYy" type="text" class="text" maxlength="4"  value="${curSysYear}" />
						</td>
						<td>
							<span>평가명</span>
							<select name="appraisalCd" id="appraisalCd" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
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
							<li id="txt" class="txt">평가일정관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>