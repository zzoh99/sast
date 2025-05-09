<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>명함신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		//Sheet 초기화
		init_sheet();

		$("#searchSdate").datepicker2({startdate:"searchEdate"});
		$("#searchEdate").datepicker2({enddate:"searchSdate"});
		
		var date = new Date();
		
		var lastDay = ( new Date( date.getFullYear(), "12", 0) ).getDate();
		
		$("#searchSdate").val(date.getFullYear()+"-01"+"-01");
		$("#searchEdate").val(date.getFullYear()+"-12"+"-"+lastDay);
		
		doAction1("Search");
		
		// 숫자만 입력가능
		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				doAction1("Search");
			}
		});
		
		$("#searchOorgNm, #searchJobNm, #searchName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	//Sheet 초기화
	function init_sheet(){

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:0, FrozenColRight:0};
	 	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
			
			{Header:"소속|소속",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"사번|사번",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"성명|성명",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"직위|직위",				Type:"Text",   		Hidden:0,	Width:80, 	Align:"Center", ColMerge:0, SaveName:"jikweeNm", 	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"신청일|신청일",			Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"제출\n여부|제출\n여부",	Type:"CheckBox",	Hidden:0, 	Width:50, 	Align:"Center",	ColMerge:0,	SaveName:"applYn",		KeyField:0,	CalcLogic:"", Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50,TrueValue:"Y", FalseValue:"N"},
			
			{Header:"1년|년도",					Type:"Text",   		Hidden:0,	Width:50, 	Align:"Center", ColMerge:0, SaveName:"year1",	 	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"1년|부서",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"1년|직무",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"3년|년도",					Type:"Text",   		Hidden:0,	Width:50, 	Align:"Center", ColMerge:0, SaveName:"year2",	 	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"3년|부서",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"3년|직무",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"5년|년도",					Type:"Text",   		Hidden:0,	Width:50, 	Align:"Center", ColMerge:0, SaveName:"year3",	 	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"5년|부서",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm3",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"5년|직무",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm3",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"5년이후|년도",				Type:"Text",   		Hidden:0,	Width:50, 	Align:"Center", ColMerge:0, SaveName:"year4",	 	KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:0 },
			{Header:"5년이후|부서",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgNm4",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"5년이후|직무",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jobNm4",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"saveAll"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applYmd"}
            
  		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var sXml = sheet1.GetSearchData("${ctx}/JobCDPSurveyMgr.do?cmd=getJobCDPSurveyMgrList", $("#sheetForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet1.LoadSearchData(sXml );
	        	break;	
	        case "Save":      
	       		IBS_SaveName(document.sheetForm,sheet1);
	       		
	       		var rowCnt = sheet1.RowCount();
	       		var aFlag = false;
	       		
	       		for (var h=2; h<=rowCnt+1; h++) {
	       			if(sheet1.GetCellValue(h, "sStatus") == "U"){
	       				
	       				var params = "&searchRegYmd="+sheet1.GetCellValue(h,"regYmd");
	    		    	params += "&searchSabun="+sheet1.GetCellValue(h,"sabun");
	    		    	
	    		    	var data = ajaxCall( "${ctx}/JobCDPSurvey.do?cmd=getJobCDPSurveyApplYnList"+params, $("#sheetForm").serialize(),false);
	    		    	
    		    		if(!data.DATA[0]){
    		    			aFlag = true;
    	 					sheet1.SetCellValue(h,"applYn","N");
    	 					sheet1.SetCellValue(h,"saveAll","");
    			    	}
	    		    	
	       			}
	       		}
	       		
	       		if(aFlag == true){
	       			alert("희망직무조사에 경력개발계획을 먼저 저장 해 주세요.");
	       			return;
	       		}
	       		
	       		sheet1.DoSave("${ctx}/JobCDPSurvey.do?cmd=saveJobCDPSurveyWish", $("#sheetForm").serialize()); 
	       		
	       		aFlag = false;
	       		
	        	break;
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param); 
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
	
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "applYn" ) {
		    	
		    	var params = "&searchRegYmd="+sheet1.GetCellValue(Row,"regYmd");
		    	params += "&searchSabun="+sheet1.GetCellValue(Row,"sabun");
		    	
		    	var data = ajaxCall( "${ctx}/JobCDPSurvey.do?cmd=getJobCDPSurveyApplYnList"+params, $("#sheetForm").serialize(),false);
		    	
		    	if(Value == "Y"){
		    		sheet1.SetCellValue(Row,"saveAll","1");
		    	}else{
		    		sheet1.SetCellValue(Row,"saveAll","");
		    	}
		    	/*
		    	if(!data.DATA[0]){
		    		alert("희망직무조사에 경력개발계획을 먼저 저장 해 주세요.");
 					sheet1.SetCellValue(Row,"applYn","N");
 					sheet1.SetCellValue(Row,"saveAll","");
		    	}
		    	*/
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
</script>

</head>
<body class="hidden">
<div class="wrapper">
	
	<form id="sheetForm" name="sheetForm" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
		
		<div class="sheet_search sheet_search_s outer">
			<div>
				<table>
					<tr>
						<th>신청일자</th> 
						<td>
							<input type="text" id="searchSdate" name="searchSdate" class="date2"  /> ~
							<input type="text" id="searchEdate" name="searchEdate" class="date2" /> 
						</td>
						<th><tit:txt mid='113461' mdef='대상년도 '/></th> 
						<td>
							<input type="text" id="searchYear" name="searchYear" class="date2" value="${curSysYear}" maxlength="4"/>
						</td>
						<th>부서명</th>
						<td>
							<input type="text" id="searchOorgNm" name="searchOorgNm"/>
						</td>
					</tr>
					<tr>
						<th>사번/성명 </th>
						<td>
							<input id="searchName" name ="searchName" type="text" class="text"  />
						</td>
						<th>직무명</th> 
						<td>
							<input id="searchJobNm" name ="searchJobNm" type="text" class="text" /> 
						</td>
						<td colspan="2"><a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">희망직무현황</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')"	class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
					<a href="javascript:doAction1('Save')" 			class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>
