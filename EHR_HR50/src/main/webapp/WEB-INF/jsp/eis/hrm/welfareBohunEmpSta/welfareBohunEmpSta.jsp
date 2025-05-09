<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
            {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",	    	Type:"Text",      Hidden:0,  Width:150,	Align:"Center",  ColMerge:0,   SaveName:"orgNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	    	Type:"Text",      Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"sabun",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	    	Type:"Text",      Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	    	Type:"Text",      Hidden:0,  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	    	Type:"Text",      Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='empYmd' mdef='입사일'/>",	    Type:"Date",     Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"empYmd",     KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='bohunCd' mdef='보훈구분'/>",	    Type:"Text",      Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"bohunNm",     KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='famCdV1' mdef='보훈관계'/>",	    Type:"Text",      Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"famNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='bohunNo' mdef='보훈번호'/>",Type:"Text",      Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"bohunNo",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
            {Header:"<sht:txt mid='armyMemo' mdef='비고'/>",	    	Type:"Text",      Hidden:0,  Width:150,	Align:"Left",  ColMerge:0,   SaveName:"note",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var resultData1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "<tit:txt mid='103895' mdef='전체'/>");		//직위
		var resultData2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), "<tit:txt mid='103895' mdef='전체'/>");		//사원구분
		var resultData3 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "<tit:txt mid='103895' mdef='전체'/>");		//직군
		
		
		$("#searchJikweeNm").html(resultData1[2]);
		$("#searchManageCd").html(resultData2[2]);
		$("#searchWorkType").html(resultData3[2]);
		
		
		// 숫자만 입력가능
		$("#searchRecruitYyyyFrom,#searchInMonth").keyup(function() {
		     makeNumber(this,'A');
		 });		
		
		
		$("#searchName,#searchRecruitYyyyFrom,#searchInMonth,#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		
		var basicInfo = ajaxCall("${ctx}/WelfareBohunEmpSta.do?cmd=getWelfareBohunEmpStaMap", $("#sheet1Form").serialize(), false);

		if (basicInfo.DATA != null) {
			$("#nowCnt")[0].innerText = basicInfo.DATA.nowCnt;
			$("#lawCnt")[0].innerText = basicInfo.DATA.lawCnt;
			$("#lawPer")[0].innerText = basicInfo.DATA.lawPer;
			$("#nowRctCnt")[0].innerText = basicInfo.DATA.nowRctCnt;
			$("#nowRctPer")[0].innerText = basicInfo.DATA.nowRctPer;
			
			var diffPer = basicInfo.DATA.nowRctPer - basicInfo.DATA.lawPer;
			var diffCnt = eval(basicInfo.DATA.nowRctCnt) - eval(basicInfo.DATA.lawCnt);			
			diffCnt = Round(diffCnt, 1);
			diffPer = Round(diffPer, 1);
			
			if(diffPer < 0){
				$("#diffPer")[0].style.color = "red";
			} else {
				$("#diffPer")[0].style.color = "blue";
			}
			
			if(diffCnt < 0){
				$("#diffCnt")[0].style.color = "red";
			} else {
				$("#diffCnt")[0].style.color = "blue";
			}
			
			$("#diffPer")[0].innerText = diffPer;
			$("#diffCnt")[0].innerText = diffCnt;
			
		}
	});
	
	//특정자리 반올림 
	function Round(n, pos) { 
    	var digits = Math.pow(10, pos); 
 
    	var sign = 1; 
    	if (n < 0) { 
    	sign = -1; 
    	} 
 
    	// 음수이면 양수처리후 반올림 한 후 다시 음수처리 
    	n = n * sign; 
    	var num = Math.round(n * digits) / digits; 
    	num = num * sign; 
 
    	return num.toFixed(pos); 
    } 	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	sheet1.DoSearch( "${ctx}/WelfareBohunEmpSta.do?cmd=getWelfareBohunEmpStaList", $("#srchFrm").serialize() ); break;
		case "Save": 		
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/WelfareBohunEmpSta.do?cmd=saveWelfareBohunEmpSta", $("#srchFrm").serialize()); break;
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
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
		if(sheet1.ColSaveName(Col) == "name"){
			profilePopup(Row);
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
        
		$("#searchYmdFrom").datepicker2({startdate:"searchYmdFrom"});
		$("#searchYmdTo").datepicker2({enddate:"searchYmdTo"});
        
	});

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td> <span><tit:txt mid='103881' mdef='입사일'/></span> <input id="searchYmdFrom" name ="searchYmdFrom" type="text" class="date2 "  maxlength="10" /> </td>
						<td> <span>~ </span> <input id="searchYmdTo" name ="searchYmdTo" type="text" class="date2 " maxlength="10" /> </td>
						<td>
							<input id="statusCd" name="statusCd" type="radio" value="Y" checked><span><tit:txt mid='113521' mdef='퇴직자 제외'/></span>
							<input id="statusCd" name="statusCd"  type="radio" value="N" ><span><tit:txt mid='114221' mdef='퇴직자 포함'/></span>
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td> <span style="padding-left: 8.5pt"><tit:txt mid='104295' mdef='소속 '/></span> <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" /> </td>
						<td style="display:none;"> <span><tit:txt mid='113312' mdef='직위 '/></span> <select id="searchJikweeNm" name="searchJikweeNm"> </select> </td>
						<td> <span><tit:txt mid='112785' mdef='사원구분 '/></span> <select id="searchManageCd" name="searchManageCd"> </select> </td>
						<td> <span><tit:txt mid='104261' mdef='직군 '/></span> <select id="searchWorkType" name="searchWorkType"> </select> </td>
						<td> <span><tit:txt mid='104450' mdef='성명 '/></span> <input id="searchName" name="searchName" type="text" class="text" /></td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
		
	<div style="margin-top: 15px">
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
				<th class="right" rowspan="2"><tit:txt mid='104015' mdef='현재인원'/></th>
				<td class="right" style="padding-right: 20px"  rowspan="2" >
					<span id="nowCnt" ></span> 명
				</td>
				<th class="right"><tit:txt mid='114615' mdef='의무고용율'/></th>
				<td class="right" style="padding-right: 20px" >
					<span id="lawPer"></span> %
				</td>
				<th class="right"><tit:txt mid='113522' mdef='당사고용율'/></th>
				<td class="right" style="padding-right: 20px" >
					<span id="nowRctPer"></span> %
				</td>
				<th class="right"><tit:txt mid='114616' mdef='고용율차이'/></th>
				<td class="right" style="padding-right: 20px" >
					<span id="diffPer"></span> %
				</td>
			</tr>
			<tr>
				<th class="right"><tit:txt mid='113176' mdef='의무고용인원'/></th>
				<td class="right" style="padding-right: 20px" >
					<span id="lawCnt"></span> 명
				</td>
				<th class="right"><tit:txt mid='113881' mdef='당사고용인원'/></th>
				<td class="right" style="padding-right: 20px" >
					<span id="nowRctCnt"></span> 명
				</td>
				<th class="right"><tit:txt mid='112815' mdef='고용인원차이'/></th>
				<td class="right" style="padding-right: 20px" >
					<span id="diffCnt"></span> 명
				</td>
			</tr>
			</table>
		</form>
	</div>
		
		
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='114222' mdef='보훈대상자 고용현황'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "80%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
