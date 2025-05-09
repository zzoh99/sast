<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var weekArr = ["", "일", "월", "화", "수", "목", "금", "토"];

	$(function() {

		//근무조패턴 시작요일 (default 2(월))
		//var data = ajaxCall( "${ctx}/GetDataMap.do?cmd=getSystemStdData", "searchStdCd=TIM_STD_START_WEEK",false);
		
		var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=TIM_STD_START_WEEK", "queryId=getSystemStdData", false).codeList;
		
		if ( data != null && data[0] != null ){
			$("#stdWeek").val(data[0].value);
		}else{
			$("#stdWeek").val("2");
		}
		$("#searchDate").bind("keydown",function(event){
			if( event.keyCode == 13){ doAction2("Search"); $(this).focus(); }
		});

		init_sheet1(); //근무조그룹
		init_sheet2(); //근무시간
		
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});


	//근무조그룹
	function init_sheet1(){
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:5};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No|No|No",							Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태|상태|상태",						Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"근무그룹|근무그룹|근무그룹",				Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workGrpCd",		KeyField:1,	Format:"",			UpdateEdit:0,	InsertEdit:1},
			{Header:"근로\n시간제|근로\n시간제|근로\n시간제",	Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"workOrgTypeCd",	KeyField:1,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"단위\n기간|단위\n기간|단위\n기간",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"intervalCd",		KeyField:1,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"단위기간\n시작일자|단위기간\n시작일자|단위기간\n시작일자",
														Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",			KeyField:1,	Format:"Ymd",		UpdateEdit:1,	InsertEdit:1},
			{Header:"요일|요일|요일",						Type:"Combo",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sdateWeek",		KeyField:0,	Format:"",			UpdateEdit:0,	InsertEdit:0},
			
			{Header:"기본한도(합계)|일|기본", Type:"Float",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sumDayWkLmt",		KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"기본한도(합계)|일|연장", Type:"Float",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sumDayOtLmt",		KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"기본한도(합계)|주|기본", Type:"Float",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sumWeekWkLmt",	KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"기본한도(합계)|주|연장", Type:"Float",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sumWeekOtLmt",	KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"단위기간 평균한도|일|기본", Type:"Float",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"avgDayWkLmt",		KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"단위기간 평균한도|일|연장", Type:"Float",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"avgDayOtLmt",		KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"단위기간 평균한도|주|기본", Type:"Float",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"avgWeekWkLmt",	KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},
			{Header:"단위기간 평균한도|주|연장", Type:"Float",		Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"avgWeekOtLmt",	KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},

			{Header:"출근\n시간\n고정|출근\n시간\n고정|출근\n시간\n고정",
														Type:"CheckBox",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"fixStTimeYn",	KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N", HeaderCheck:0},
			{Header:"퇴근\n시간\n고정|퇴근\n시간\n고정|퇴근\n시간\n고정",
														Type:"CheckBox",	Hidden:0,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"fixEdTimeYn",	KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N", HeaderCheck:0},
			{Header:"비고|비고|비고",						Type:"Text",		Hidden:0,	Width:130,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",			UpdateEdit:1,	InsertEdit:1},

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

		//공통코드 한번에 조회
		var grpCds = "T10002,T90200,T11020";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
		sheet1.SetColProperty("workOrgTypeCd",  {ComboText:"|"+codeLists["T10002"][0], ComboCode:"|"+codeLists["T10002"][1]} ); //근무제
		sheet1.SetColProperty("intervalCd",  	{ComboText:"|"+codeLists["T90200"][0], ComboCode:"|"+codeLists["T90200"][1]} ); //단위기간
		sheet1.SetColProperty("workGrpCd",  	{ComboText:"|"+codeLists["T11020"][0], ComboCode:"|"+codeLists["T11020"][1]} ); //근무조그룹
		
		/*(1:일, 2:월, 3:화, 4:수, 5:목, 6:금, 7:토)*/
		sheet1.SetColProperty("sdateWeek", {ComboText:"|일|월|화|수|목|금|토", ComboCode:"|1|2|3|4|5|6|7"});

	}

	//근무시간 그룹
	function init_sheet2(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"\n삭제|\n삭제",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"근무시간|근무시간",	Type:"Combo",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"timeCd", 		KeyField:1,	UpdateEdit:0,	InsertEdit:1},
			{Header:"약어|약어",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"timeCdShort", KeyField:1,	UpdateEdit:0,	InsertEdit:0},

  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"workGrpCd"},

		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetDataAlternateBackColor(sheet2.GetDataBackColor()); //홀짝 배경색 같게
		sheet2.SetFocusAfterProcess(0);

		var timeCdList    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkTimeCdList", false).codeList, "");
		sheet2.SetColProperty("timeCd",	{ComboText:timeCdList[0], ComboCode:timeCdList[1]} );

		var timeCdList2    = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getWorkTimeCdList&searchShortNameFlag=Y", false).codeList, "");
		sheet2.SetColProperty("timeCdShort",	{ComboText:timeCdList2[0], ComboCode:timeCdList2[1]} );

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var sXml = sheet1.GetSearchData("${ctx}/WorkGrpMgr.do?cmd=getWorkPattenMgrGrpList", $("#sheet1Form").serialize() );
			
			sXml = replaceAll(sXml, "sumDayWkLmtEdit",		"sumDayWkLmt#Edit");
			sXml = replaceAll(sXml, "sumDayOtLmtEdit",		"sumDayOtLmt#Edit");
			sXml = replaceAll(sXml, "sumWeekWkLmtEdit",		"sumWeekWkLmt#Edit");
			sXml = replaceAll(sXml, "sumWeekOtLmtEdit",		"sumWeekOtLmt#Edit");
			sXml = replaceAll(sXml, "avgDayWkLmtEdit",		"avgDayWkLmt#Edit");
			sXml = replaceAll(sXml, "avgDayOtLmtEdit",		"avgDayOtLmt#Edit");
			sXml = replaceAll(sXml, "avgWeekWkLmtEdit",		"avgWeekWkLmt#Edit");
			sXml = replaceAll(sXml, "avgWeekOtLmtEdit",		"avgWeekOtLmt#Edit");

			sheet1.LoadSearchData(sXml );
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/WorkGrpMgr.do?cmd=saveWorkPattenMgrGrp", $("#sheet1Form").serialize());
			break;
		}
	}


	//Sheet3 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			/*입력상태일땐 디테일 조회 안함*/
			if(sheet1.GetCellValue(sheet1.GetSelectRow(),"sStatus") == "I") {doAction2("Clear");return ;}
			sheet2.DoSearch( "${ctx}/WorkGrpMgr.do?cmd=getWorkPattenMgrTimeGrp", $("#sheet1Form").serialize(),1 );
			break;
		case "Save":

			if(!dupChk(sheet2,"timeCd", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/WorkGrpMgr.do?cmd=saveWorkPattenMgrTimeGrp" , $("#sheet1Form").serialize());
			break;
		case "Insert":

			var selectRow = sheet1.GetSelectRow();
			var row = sheet2.DataInsert(0);

			sheet2.SetCellValue(row,"workGrpCd",sheet1.GetCellValue(selectRow,"workGrpCd"));

			break;
		case "Copy":
			sheet2.DataCopy();
			break;
		case "Clear":
			sheet2.RemoveAll();
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
			if( Code > -1 ) {
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					gPRow = NewRow;

					$("#searchWorkGrpCd").val( sheet1.GetCellValue(NewRow,"workGrpCd") );

					doAction2("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}


	function sheet1_OnChange(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "sdate") {
				 
				var d = new Date(sheet1.GetCellText(Row, Col)).getDay()+1;
				sheet1.SetCellValue(Row, "sdateWeek", d);
				 
			}else if(sheet1.ColSaveName(Col) == "intervalCd") {
				if( Number(Value) % 30 == 0 ){ //월단위
					sheet1.SetCellEditable(Row, "sumWeekWkLmt", 0);
					sheet1.SetCellEditable(Row, "sumWeekOtLmt", 0);
					sheet1.SetCellEditable(Row, "avgDayWkLmt", 1);
					sheet1.SetCellEditable(Row, "avgDayOtLmt", 1);
					sheet1.SetCellEditable(Row, "avgWeekWkLmt", 0);
					sheet1.SetCellEditable(Row, "avgWeekOtLmt", 0);

					sheet1.SetCellValue(Row, "sumWeekWkLmt", "", 0);
					sheet1.SetCellValue(Row, "sumWeekOtLmt", "", 0);
					sheet1.SetCellValue(Row, "avgWeekWkLmt", "", 0);
					sheet1.SetCellValue(Row, "avgWeekOtLmt", "", 0);
				}else{ //주단위
					sheet1.SetCellEditable(Row, "sumWeekWkLmt", 1);
					sheet1.SetCellEditable(Row, "sumWeekOtLmt", 1);
					sheet1.SetCellEditable(Row, "avgDayWkLmt", 0);
					sheet1.SetCellEditable(Row, "avgDayOtLmt", 0);
					sheet1.SetCellEditable(Row, "avgWeekWkLmt", 1);
					sheet1.SetCellEditable(Row, "avgWeekOtLmt", 1);
					
					sheet1.SetCellValue(Row, "avgDayWkLmt", "", 0);
					sheet1.SetCellValue(Row, "avgDayOtLmt", "", 0);
				}
			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}

  	function sheet1_OnValidation(Row, Col, Value){
  	  	try{
  	  		if(sheet1.ColSaveName(Col) == "sdateWeek" ) {

  	  			//단위기간
  	  			var ival = parseInt( sheet1.GetCellValue(Row, "intervalCd") );

  	        	if(Value != $("#stdWeek").val() && ival % 7 == 0 ){  //주단위 일때는
  	        		alert("단위기간이 주단위 일 경우 시작일자는 "+weekArr[$("#stdWeek").val()]+"요일이어야 합니다.");
  	        		sheet1.ValidateFail(1);
  	        		sheet1.SelectCell(Row, "sdate");
  	            	return;
  	        	}
  	    	}

  	  	}catch(ex){alert("OnValidation Event Error : " + ex);}
 	}


	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) {

	    		doAction2("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 값 변경시 발생
	function sheet2_OnChange(Row, Col, Value) {
		if ( sheet2.ColSaveName(Col) == "timeCd"){

			sheet2.SetCellValue(Row, "timeCdShort", Value);
		}

	}


	function showHelpPop(){
		$("#heplPop").show();
	}
	function closeHelpPop(){
		$("#heplPop").hide();
	}
</script>
<style type="text/css">
div.explain .txt ul li {font-size:11px; color:#000;padding-top:3px;}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="stdWeek" name="stdWeek" />
	<input type="hidden" id="searchWorkGrpCd" name="searchWorkGrpCd" />
	</form>

	<table class="sheet_main">
	<colgroup>
		<col width="" />
		<col width="20px" />
		<col width="350px" />
	</colgroup>
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">근무그룹</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Search');" css="btn dark authA" mid='search' mdef="조회"/>
						<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
						<a href="javascript:showHelpPop();" class="btn outline_gray authA">근로기준법</a>
					</li>
				</ul>
				</div>
			</div>

			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

			<div class="explain spacingN inner">
				<div class="txt">
					<ul>
						<li><b>단위기간 시작일자: </b>&nbsp;&nbsp;단위기간이 시작하는 일자로 주단위의 경우 "월"요일, 월단위의 경우 "1"일로 설정한다.</li>
						<li><b>기본한도_일_기본 : </b>&nbsp;&nbsp;1일 기본근무 시간 합계 한도</li>
						<li><b>기본한도_일_연장 : </b>&nbsp;&nbsp;1일 연장근무 시간 합계 한도</li>
						<li><b>기본한도_주_기본 : </b>&nbsp;&nbsp;1주 기본근무 시간 합계 한도</li>
						<li><b>기본한도_주_연장 : </b>&nbsp;&nbsp;1주 연장근무 시간 합계 한도</li>
						<li><b>평균한도_일_기본 : </b>&nbsp;&nbsp;단위기간 내 1일 기본근무 시간 평균 한도, 단위기간이 "월"단위 일 때만 설정</li>
						<li><b>평균한도_일_연장 : </b>&nbsp;&nbsp;단위기간 내 1일 연장근무 시간 평균 한도, 단위기간이 "월"단위 일 때만 설정</li>
						<li><b>평균한도_주_기본 : </b>&nbsp;&nbsp;단위기간 내 1주 기본근무 시간 평균 한도, 단위기간이 "주"단위 일 때만 설정</li>
						<li><b>평균한도_주_연장 : </b>&nbsp;&nbsp;단위기간 내 1주 기본근무 시간 평균 한도, 단위기간이 "주"단위 일 때만 설정</li>
						<li><b>출퇴근시간고정 : </b>&nbsp;&nbsp;출근/퇴근시간이 스케쥴 상의 근무시간으로 고정 표시 된다.</li>
						<li><b>* 선택 근로시간제에서는 기본한도는 설정하지 않고 평균한도만 설정 한다.</b></li>
					</ul>
				</div>

			</div>			
		</td>
		<td class="sheet_right"><div style="padding-top:200px;" class="setBtn"><img src="/common/images/sub/ico_arrow2.png"/></div></td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">사용 근무시간</li>
					<li class="btn">
						<btn:a href="javascript:doAction2('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction2('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction2('Save');" css="btn filled authA" mid='save' mdef="저장"/>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>

<div id="heplPop" style="position:absolute; top:150px; left:50%; width:100%; margin-left:-300px;height:250px;background-color:transparent;  display:none; z-index:31;">
	<div class="explain spacingN" style="margin:0;padding:5px;letter-spacing:1; width:720px;height:460px;">
		<div class="popup_title">
			<ul>
				<li id="title-pop">근로기준법 (2020-05-26)</li>
				<i class="mdi-ico" onclick="closeHelpPop()"
				   style="margin-left: auto; font-size: 24px; color: white; cursor: pointer;">close</i>
			</ul>
		</div>
		<div class="h10"></div>
		<div class="noti_icon3"></div>
		<div class="txt" style=" width:700px;height:330px; overflow:auto;">
<b>제50조(근로시간)</b>
<br>① 1주 간의 근로시간은 휴게시간을 제외하고 40시간을 초과할 수 없다.
<br>② 1일의 근로시간은 휴게시간을 제외하고 8시간을 초과할 수 없다.
<br>③ 제1항 및 제2항에 따라 근로시간을 산정하는 경우 작업을 위하여 근로자가 사용자의 지휘ㆍ감독 아래에 있는 대기시간 등은 근로시간으로 본다. <신설 2012. 2. 1., 2020. 5. 26.>
<br><br><b>제51조(탄력적 근로시간제)</b>
<br>① 사용자는 취업규칙(취업규칙에 준하는 것을 포함한다)에서 정하는 바에 따라 2주 이내의 일정한 단위기간을 평균하여 1주 간의 근로시간이 제50조제1항의 근로시간을 초과하지 아니하는 범위에서 특정한 주에 제50조제1항의 근로시간을, 특정한 날에 제50조제2항의 근로시간을 초과하여 근로하게 할 수 있다. 다만, 특정한 주의 근로시간은 48시간을 초과할 수 없다.
<br>② 사용자는 근로자대표와의 서면 합의에 따라 다음 각 호의 사항을 정하면 3개월 이내의 단위기간을 평균하여 1주 간의 근로시간이 제50조제1항의 근로시간을 초과하지 아니하는 범위에서 특정한 주에 제50조제1항의 근로시간을, 특정한 날에 제50조제2항의 근로시간을 초과하여 근로하게 할 수 있다. 다만, 특정한 주의 근로시간은 52시간을, 특정한 날의 근로시간은 12시간을 초과할 수 없다.
<br>1. 대상 근로자의 범위
<br>2. 단위기간(3개월 이내의 일정한 기간으로 정하여야 한다)
<br>3. 단위기간의 근로일과 그 근로일별 근로시간
<br>4. 그 밖에 대통령령으로 정하는 사항
<br>③ 제1항과 제2항은 15세 이상 18세 미만의 근로자와 임신 중인 여성 근로자에 대하여는 적용하지 아니한다.
<br>④ 사용자는 제1항 및 제2항에 따라 근로자를 근로시킬 경우에는 기존의 임금 수준이 낮아지지 아니하도록 임금보전방안(임김보전방안)을 강구하여야 한다.
<br><br><b>제52조(선택적 근로시간제)</b>
<br>사용자는 취업규칙(취업규칙에 준하는 것을 포함한다)에 따라 업무의 시작 및 종료 시각을 근로자의 결정에 맡기기로 한 근로자에 대하여 근로자대표와의 서면 합의에 따라 다음 각 호의 사항을 정하면 1개월 이내의 정산기간을 평균하여 1주간의 근로시간이 제50조제1항의 근로시간을 초과하지 아니하는 범위에서 1주 간에 제50조제1항의 근로시간을, 1일에 제50조제2항의 근로시간을 초과하여 근로하게 할 수 있다.
<br>1. 대상 근로자의 범위(15세 이상 18세 미만의 근로자는 제외한다)
<br>2. 정산기간(1개월 이내의 일정한 기간으로 정하여야 한다)
<br>3. 정산기간의 총 근로시간
<br>4. 반드시 근로하여야 할 시간대를 정하는 경우에는 그 시작 및 종료 시각
<br>5. 근로자가 그의 결정에 따라 근로할 수 있는 시간대를 정하는 경우에는 그 시작 및 종료 시각
<br>6. 그 밖에 대통령령으로 정하는 사항
<br><br><b>제53조(연장 근로의 제한)</b>
<br>① 당사자 간에 합의하면 1주 간에 12시간을 한도로 제50조의 근로시간을 연장할 수 있다.
<br>② 당사자 간에 합의하면 1주 간에 12시간을 한도로 제51조의 근로시간을 연장할 수 있고, 제52조제2호의 정산기간을 평균하여 1주 간에 12시간을 초과하지 아니하는 범위에서 제52조의 근로시간을 연장할 수 있다.
<br>③ 상시 30명 미만의 근로자를 사용하는 사용자는 다음 각 호에 대하여 근로자대표와 서면으로 합의한 경우 제1항 또는 제2항에 따라 연장된 근로시간에 더하여 1주 간에 8시간을 초과하지 아니하는 범위에서 근로시간을 연장할 수 있다. <신설 2018ㆍ3ㆍ20>
<br>1. 제1항 또는 제2항에 따라 연장된 근로시간을 초과할 필요가 있는 사유 및 그 기간
<br>2. 대상 근로자의 범위
<br>④ 사용자는 특별한 사정이 있으면 고용노동부장관의 인가와 근로자의 동의를 받아 제1항과 제2항의 근로시간을 연장할 수 있다. 다만, 사태가 급박하여 고용노동부장관의 인가를 받을 시간이 없는 경우에는 사후에 지체 없이 승인을 받아야 한다. <개정 2010·6·4>
<br>⑤ 노동부장관은 제4항에 따른 근로시간의 연장이 부적당하다고 인정하면 그 후 연장시간에 상당하는 휴게시간이나 휴일을 줄 것을 명할 수 있다. <개정 2018ㆍ3ㆍ20>
<br>⑥ 제3항은 15세 이상 18세 미만의 근로자에 대하여는 적용하지 아니한다. <신설 2018ㆍ3ㆍ20>
		</div>
	</div>
</div>

</body>
</html>