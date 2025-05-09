<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>일근무조회</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">
var gPRow  = "";
var popGubun = "";
var headerStartCnt = 0;
var ColHidden = 0;
	$(function() {
		
		$("#searchYear").val("${curSysYear}");

		$("#searchYear").bind("keyup",function(event){
			if( $("#searchYear").val().length == 4 ) { 
				initWorkTermCombo(); 
			}
		});
		$("#searchWorTerm").bind("change",function(event){
			
	    	doAction1("Search");
		});
		
        init_sheet();

        setEmpPage();
		
		$(window).smartresize(sheetResize);sheetInit();
	});

	function init_sheet(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:50, FrozenCol:0, MergeSheet:msNone};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
             {Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" }
        ] ; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

        var initdata2 = {}; 
 		initdata2.Cfg = {SearchMode:smLazyLoad,Page:50, FrozenCol:0, MergeSheet:msHeaderOnly};
 		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
 		initdata2.Cols = [
              {Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" },
              {Header:"<sht:txt mid='gubunV7' mdef='구분|구분'/>",				Type:"Text",    Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"gubun",			Format:"", 		UpdateEdit:0, InsertEdit:0},
              {Header:"<sht:txt mid='workPeriod' mdef='근무기간'/>|<sht:txt mid='eduSYmd' mdef='시작일'/>",		Type:"Text",    Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"sdate",			Format:"Ymd", 	UpdateEdit:0, InsertEdit:0},
              {Header:"<sht:txt mid='workPeriod' mdef='근무기간'/>|<sht:txt mid='eYmdV1' mdef='종료일'/>",		Type:"Text",    Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"edate",			Format:"Ymd", 	UpdateEdit:0, InsertEdit:0},
              {Header:"<sht:txt mid='workHourV1' mdef='근무시간'/>|<sht:txt mid='stdWorkHour' mdef='기본근무'/>",		Type:"Text",    Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"workHour",		Format:"", 		UpdateEdit:0, InsertEdit:0/*, BackColor:"#fdf0f5"*/, FontColor:"#0000FF"},
              {Header:"<sht:txt mid='workHourV1' mdef='근무시간'/>|<sht:txt mid='otWorkHourV2' mdef='연장근무'/>",		Type:"Text",    Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"otHour",			Format:"", 		UpdateEdit:0, InsertEdit:0/*, BackColor:"#fdf0f5"*/, FontColor:"#0000FF"},
              
         ] ; IBS_InitSheet(sheet2, initdata2); sheet2.SetCountPosition(0);
         sheet2.SetEditableColorDiff(0); //편집불가 배경색 적용안함
         sheet2.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
         
         sheet2.SetRangeBackColor(0,sheet2.SaveNameCol("workHour"),1,sheet2.SaveNameCol("otHour"), "#fdf0f5");  //분홍이

	}

	/*SETTING HEADER LIST*/
	function searchTitleList() {

		var titleList = ajaxCall("${ctx}/WtmWorkTime.do?cmd=getWtmWorkTimeHeaderList", $("#sheetForm").serialize(), false);
		if (titleList != null && titleList.DATA != null) {

			sheet1.Reset();

			var v=0;
			var initdata1 = {};
			initdata1.Cfg = {MergeSheet:msHeaderOnly,SearchMode:smLazyLoad,Page:50,FrozenCol:3};
			
			initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

			initdata1.Cols = [];
			initdata1.Cols.push({Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" });
			initdata1.Cols.push({Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",				Type:"${sSttTy}",   Hidden:1,  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0});
			initdata1.Cols.push({Header:"<sht:txt mid='ymdV7' mdef='근무일|근무일'/>",			Type:"Text",		Hidden:0,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"vYmd",			KeyField:0,   Format:"", 	Edit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='gubunV7' mdef='구분|구분'/>",				Type:"Text",		Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"dayDiv",		KeyField:0,   Format:"", 	Edit:0 });
			
			initdata1.Cols.push({Header:"<sht:txt mid='gntCd' mdef='근태|근태'/>",				Type:"Text",		Hidden:0,  Width:70,	Align:"Center",	ColMerge:0,   SaveName:"gntCd",			KeyField:0,   Format:"",    Edit:0 });
			initdata1.Cols.push({Header:"근무유형|근무유형",		Type:"Text",		Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"workClassNm",		KeyField:0,   Format:"",    Edit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='stdWorkSTime' mdef='기준시간|출근시간'/>",		Type:"Text",		Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"workShm",		KeyField:0,   Format:"Hm",  Edit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='stdWorkETime' mdef='기준시간|퇴근시간'/>",		Type:"Text",		Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"workEhm",		KeyField:0,   Format:"Hm",  Edit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='rcgnWorkSTime' mdef='인정시간|출근시간'/>",		Type:"Text",		Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"inHm",			KeyField:0,   Format:"Hm",  Edit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='rcgnWorkETime' mdef='인정시간|퇴근시간'/>",		Type:"Text",		Hidden:0,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"outHm",			KeyField:0,   Format:"Hm",  Edit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='rcgnWorkTotal' mdef='인정시간|계'/>",			Type:"Text",		Hidden:1,  Width:50,	Align:"Center",	ColMerge:0,   SaveName:"workTime",		KeyField:0,   Format:"Hm",  Edit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='isNormal_lb_dbl' mdef='정상\n여부|정상\n여부'/>",	Type:"Text",		Hidden:0,  Width:40,	Align:"Center",	ColMerge:0,   SaveName:"workFlag",		KeyField:0,   Format:"",    Edit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='workTime_lb_dbl' mdef='근무\n시간|근무\n시간'/>",	Type:"Text",		Hidden:0,  Width:40,	Align:"Center",	ColMerge:0,   SaveName:"realWorkTime",	KeyField:0,   Format:"Hm",  Edit:0 });
			initdata1.Cols.push({Header:"<sht:txt mid='ymdV7' mdef='근무일|근무일'/>",			Type:"Text",		Hidden:1,  Width:80,	Align:"Center",	ColMerge:0,   SaveName:"ymd",			KeyField:0,   Format:"", 	Edit:0 });

			// TODO: 리포트 별 화면 출력할 수 있는 옵션 추가해야함.

			initdata1.Cols.push({Header:"기본\n근무|기본\n근무",				Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"basicMmW",		KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, });
			initdata1.Cols.push({Header:"연장\n근무|연장\n근무",				Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"otMmW",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, });
			initdata1.Cols.push({Header:"심야\n근무|심야\n근무",				Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"ltnMmW",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, });
			initdata1.Cols.push({Header:"휴일\n기본근무|휴일\n기본근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"basicMmH",		KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, });
			initdata1.Cols.push({Header:"휴일\n연장근무|휴일\n연장근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"otMmH",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, });
			initdata1.Cols.push({Header:"휴일\n심야근무|휴일\n심야근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"ltnMmH",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, });
			initdata1.Cols.push({Header:"휴무일\n기본근무|휴무일\n기본근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"basicMmNh",		KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, });
			initdata1.Cols.push({Header:"휴무일\n연장근무|휴무일\n연장근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"otMmNh",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, });
			initdata1.Cols.push({Header:"휴무일\n심야근무|휴무일\n심야근무",		Type:"Text",		Hidden:0,  		Width:50,   	Align:"Center", 	SaveName:"ltnMmNh",			KeyField:0,  Format:"Hm",   UpdateEdit:0,   InsertEdit:0, });
			initdata1.Cols.push({Header:"지각\n여부|지각\n여부",				Type:"CheckBox",	Hidden:0,		Width:50,   	Align:"Center", 	SaveName:"lateYn",			KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N",	HeaderCheck:0 });
			initdata1.Cols.push({Header:"조퇴\n여부|조퇴\n여부",				Type:"CheckBox",	Hidden:0,		Width:50,   	Align:"Center", 	SaveName:"leaveEarlyYn",	KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N",	HeaderCheck:0 });
			initdata1.Cols.push({Header:"결근\n여부|결근\n여부",				Type:"CheckBox",	Hidden:0,		Width:50,   	Align:"Center", 	SaveName:"absenceYn",		KeyField:0,  Format:"",     UpdateEdit:0,   InsertEdit:0,   TrueValue:"Y", FalseValue:"N",	HeaderCheck:0 });
/*
			headerStartCnt = v;
			var i = 0 ;
			for(; i<titleList.DATA.length; i++) {
				initdata1.Cols[v++] = {Header:titleList.DATA[i].codeNm+"|"+titleList.DATA[i].codeNm, Type:"Text", Hidden:0,	Width:50, Align:"Center", ColMerge:1, SaveName:titleList.DATA[i].saveNameDisp,	KeyField:0,	Format:"Hm", Edit:0 };
			}
			IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
			
			//근무시간
			var timeCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWtmWorkTimeCdList&searchShortNameFlag=Y",false).codeList, "");
			sheet1.SetColProperty("timeCd", 		{ComboText:"|"+timeCdList[0], ComboCode:"|"+timeCdList[1]} );
*/
			IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
			
		}
	}

	//근무기간콤보
	function initWorkTermCombo(){
		if( $("#searchYear").val() == "" || $("#searchYear").val().length != 4 ){
			$("#searchWorTerm").html("");
			return;
		}
		
		var param = "&searchSabun="+$("#searchSabun").val()
		          + "&searchYmd="+$("#searchYear").val()+"0101"
		          + "&searchSelYmd=${curSysYyyyMMdd}"
		          + "&searchYear="+$("#searchYear").val();
		var workTermCdList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTimWeekTermCodeList"+param, false).codeList
				           , "sYmd,eYmd,workGrpNm,workOrgCd,workOrgNm,selYn"
				           , "");
		$("#searchWorTerm").html(workTermCdList[2]);
		
		$("#searchWorTerm").find("option").each(function() {
			 if( $(this).attr("selYn") == "Y"){
				 $(this).attr("selected", "selected");
			 }
		});
	}
	
	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				$("#th01").html($("#searchWorTerm option:selected").text());
				
				$("#workGrpNm").html( $("#searchWorTerm option:selected").attr("workGrpNm") );
				$("#searchSymd").val( $("#searchWorTerm option:selected").attr("sYmd") );
				$("#searchEymd").val( $("#searchWorTerm option:selected").attr("eYmd") );
				
				searchTitleList();
				var sXml = sheet1.GetSearchData("${ctx}/WtmWorkTime.do?cmd=getWtmWorkTimeList", $("#sheetForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sXml = replaceAll(sXml,"ymdFontColor", "vYmd#FontColor");
				sXml = replaceAll(sXml,"dayNmFontColor", "timeCd#FontColor");
				sXml = replaceAll(sXml,"dayDivFontColor", "dayDiv#FontColor");
				sheet1.LoadSearchData(sXml );

		    	doAction2("Search");
				break;
				
			case "Down2Excel":
				var downcol1 = makeHiddenSkipCol(sheet1);
				var downcol2 = makeHiddenSkipCol(sheet2);
				var param1  = {FileName:'개인근무조회',SheetName:'sheet1',DownCols:downcol1,SheetDesign:1,Merge:1, AppendPrevSheet:1};
				var param2  = {FileName:'개인근무조회',SheetName:'sheet1',DownCols:downcol2,SheetDesign:1,Merge:1, AppendPrevSheet:1, DownRows: 'Visible'};
				
				if (ColHidden == 0) {
					sheet1.Down2Excel(param1);
				} else {
					sheet1.Down2ExcelBuffer(true);
					sheet1.Down2Excel(param1); 
					sheet2.Down2Excel(param2); 
					sheet1.Down2ExcelBuffer(false);	
				}
				break;

		}
	}

	
	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
				
			case "Search":
				sheet2.DoSearch( "${ctx}/WtmWorkTime.do?cmd=getWtmWorkTimeList2", $("#sheetForm").serialize() );
				break;

		}
	}
	
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			//현재 날짜 Select
			var findRow = sheet1.FindText("ymd", '<%= DateUtil.getCurrentTime("yyyyMMdd")%>', sheet1.HeaderRows());
			if( findRow > -1 ){
				sheet1.SetSelectRow(findRow+3);sheet1.SetSelectRow(findRow);
			}
/*
			for (var i=1; i<=sheet1.LastRow(); i++){
				if (sheet1.GetCellValue(i, "holidayDiv") == "Y") {
					sheet1.SetCellFontColor(i, "dayNm", "#ef519c");	
					sheet1.SetCellFontColor(i, "dayDiv", "#ef519c");
					sheet1.SetCellFontColor(i, "ymd", "#ef519c");
				}
				
				if (sheet1.GetCellValue(i, "workFlag") == "X") {
					sheet1.SetCellFontColor(i, "workFlag", "red");
				}
				
			}
	*/		
			sheetResize();
			

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			$("#td11").html("");$("#td12").html("");
			$("#td21").html("");$("#td22").html("");
			$("#td31").html("");$("#td32").html("");
					
			for(var i = sheet2.RowCount()+sheet2.HeaderRows(); i > sheet2.HeaderRows()  ; i--) {
				var val = "|"+sheet2.GetCellValue(i, "gubun");
				if( val.indexOf("주차") == -1 ){
					sheet2.SetRowHidden(i, 1);
					
					if( val == "|단위기간" ){
						$("#td11").html(sheet2.GetCellValue(i, "workHour" ));	
						$("#td12").html(sheet2.GetCellValue(i, "otHour" ));
					}
					if( val == "|일 평균" ){
						$("#td21").html(sheet2.GetCellValue(i, "workHour" ));	
						$("#td22").html(sheet2.GetCellValue(i, "otHour" ));
					}
					if( val == "|주 평균" ){
						$("#td31").html(sheet2.GetCellValue(i, "workHour" ));	
						$("#td32").html(sheet2.GetCellValue(i, "otHour" ));
					}
					
				}	
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		
	}
	
	
	function setEmpPage() {

    	$("#searchSabun").val($("#searchUserId").val());

		//근무기간 콤보
		initWorkTermCombo();
		
    	doAction1("Search");

    }
	
</script>
<style type="text/css">
table.table th {text-align:center; padding:5px;letter-spacing:0; height:34px}
table.table th:first-child {border-left:1px solid #e7edf0; }
table.table td {text-align:center;padding:5px;border-right:1px solid #e7edf0;letter-spacing:0; } 
</style>
</head>
<body class="hidden">
<div class="wrapper">
	
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	
	<form id="sheetForm" name="sheetForm" >
		<input type="hidden" id="searchSabun" name="searchSabun" />
		<input type="hidden" id="searchSymd"  name="searchSymd" />
		<input type="hidden" id="searchEymd"  name="searchEymd" />
		
		<div class="sheet_search sheet_search_s outer">
		
			<table>
				<tr>
					<th><tit:txt mid='112528' mdef='기준년도'/></th>
					<td>
						<input type="text" id="searchYear" name="searchYear" class="date2 required w50 line" numberOnly maxLength="4"/>
					</td>
					<th><tit:txt mid="111928" mdef="근무기간" />(<tit:txt mid="termDate" mdef="단위기간"/>)</th>
					<td>
						<select id="searchWorTerm" name="searchWorTerm" class="text required"></select>
					</td>
					<td width="200" class="hide"><span>근무그룹 : </span>
						<label id="workGrpNm"></label>
					</td>
					<td><btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/> </td>
				</tr>
			</table>
		</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='2017083001014' mdef='개인근무조회'/></li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Down2Excel');" 	css="btn outline_gray authR" mid="download" mdef="다운로드"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	
	<div id="infoDiv"  class="outer" style="height:230px">
	
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='workInfo' mdef='근무요약정보'/></li>
			</ul>
		</div>
		<table class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="350px" />
		</colgroup>
		<tr>
			<td>
				<script type="text/javascript">createIBSheet("sheet2", "30%", "170px", "${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right">
				<table class="table">
				<colgroup>
					<col width="60px" /><col width="70px" /><col width="70px" />
				</colgroup>
				<tr><th colspan="3" id="th01"></th></tr>
				<tr><th>&nbsp;</th><th><tit:txt mid="stdWorkHour" mdef="기본근무"/></th><th><tit:txt mid="addHour" mdef="연장근무"/></th></tr>
				<tr><th><tit:txt mid="104481" mdef="합계"/></th><td id="td11"></td><td id="td12"></td></tr>
				<tr><th><tit:txt mid="dailyAvg" mdef="일 평균"/></th><td id="td21"></td><td id="td22"></td></tr>
				<tr><th><tit:txt mid="weeklyAvg" mdef="주 평균"/></th><td id="td31"></td><td id="td32"></td></tr>
				</table>
			</td>
		</tr>
		</table>		
	</div>
	
</div>
</body>
</html>
