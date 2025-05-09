<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		$("#searchYm").datepicker2({
			ymonly:true,
			onReturn:function(date){
				doAction1("Search");
			}
		});

		$("#searchYm").bind("keyup", function(event){
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		})

		init_sheet();
		
		
		doAction1("Search");
		
        $(sheet1).sheetAutocomplete({
            Columns: [
                {
                    ColSaveName  : "name",
                    CallbackFunc : function(returnValue){
                        var rv = $.parseJSON('{' + returnValue+ '}');
                        sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
                        sheet1.SetCellValue(gPRow, "name", rv["name"]);
                        sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
                        sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
                        
                        var user = ajaxCall( "${ctx}/CertiApp.do?cmd=getEmployeeInfoMap", "searchSabun="+ rv["sabun"], false);
                        if ( user != null && user.DATA != null ){ 
                            sheet1.SetCellValue(gPRow, "workTypeNm", user.DATA.workTypeNm);
                            sheet1.SetCellValue(gPRow, "manageNm", user.DATA.manageNm);
                            sheet1.SetCellValue(gPRow, "payTypeNm", user.DATA.payTypeNm);
                        }
                    }
                }
            ]
        }); 
	});

	

	function init_sheet(){ 
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"부서",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1},
			{Header:"직급",		Type:"Text",		Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"직군",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"사원구분",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"급여유형",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payTypeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			
			{Header:"근무구분",	Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			{Header:"근무시간",	Type:"Float",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workHour",	KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:1,	InsertEdit:1},
			{Header:"비고",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1},
			
			//Hidden
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"orgCd"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"useYn"},
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//근무코드
		var workCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getWorkCdList"), "");
		sheet1.SetColProperty("workCd", 	{ComboText:workCdList[0], ComboCode:workCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

				if($("#searchYm").val() == ""){
					alert("근무월은 필수조회 조건 입니다.");
					$("searchYm").foccs();
					return false;
				}

				sheet1.DoSearch( "${ctx}/MonthWorkHourUpload.do?cmd=getMonthWorkHourUploadList", $("#sheet1Form").serialize() );

				break;
		case "Save":
			if(!dupChk(sheet1,"sabun|workCd", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/MonthWorkHourUpload.do?cmd=saveMonthWorkHourUpload", $("#sheet1Form").serialize()); 
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SelectCell(Row, "name");
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, "name");
			break;
		case "Clear":		
			sheet1.RemoveAll(); 
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); 
			break;
		case "LoadExcel":	
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
			sheet1.LoadExcel(params); 
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|workCd|workHour"});
			break;
		}
	}


	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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


	function sheet1_OnPopupClick(Row, Col){
		try{
			sheet1.SetBlur();
			if(Row > 0 && sheet1.ColSaveName(Col) == "name"){

				gPRow = Row;
				//showPopup("emp");
			}

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	

	//  팝업
	function showPopup(type) {
    	var args    = new Array();
    	pGubun = type +"Popup";
		switch(type){
			case "emp":  //사원
				openLayerPop("emp");
				break;
		}
	}
	

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');


        if(pGubun == "empPopup"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
			
			var user = ajaxCall( "${ctx}/CertiApp.do?cmd=getEmployeeInfoMap", "searchSabun="+ rv["code"], false);
			if ( user != null && user.DATA != null ){ 
				sheet1.SetCellValue(gPRow, "workTypeNm", user.DATA.jikgubNm);
				sheet1.SetCellValue(gPRow, "manageNm", user.DATA.manageNm);
				sheet1.SetCellValue(gPRow, "payTypeNm", user.DATA.payTypeNm);
			}
			
        }
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<table>
				<tr>
					<th>근무월</th>
					<td>
						<input type="text" id="searchYm" name="searchYm" class="date2 required" value="${curSysYyyyMMHyphen}">
					</td>
					<td> <btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/> </td>
				</tr>
			</table>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">월근무시간업로드</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('DownTemplate')" 	class="btn outline-gray authA">양식다운로드</a>
					<a href="javascript:doAction1('LoadExcel')" class="btn outline-gray authA">업로드</a>
					<a href="javascript:doAction1('Copy')" 	class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>

<!-- 공통코드 레이어 팝업 -->
<%@ include file="/WEB-INF/jsp/common/include/layerPopup.jsp"%>
</body>
</html>