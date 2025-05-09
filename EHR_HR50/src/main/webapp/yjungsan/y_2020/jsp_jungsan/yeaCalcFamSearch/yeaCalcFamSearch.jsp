<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>가족별입력공제현황</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	
	$(function() {	
	
		$("#searchWorkYy").val("<%=yeaYear%>");
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:8, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"정산년도",				Type:"Text",      	Hidden:0,  Width:60,    Align:"Center", 	ColMerge:1,   SaveName:"work_yy",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"정산구분",				Type:"Combo",      	Hidden:0,  Width:60,    Align:"Center", 	ColMerge:1,   SaveName:"adjust_type",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번",				Type:"Text",      	Hidden:0,  Width:80,	Align:"Center", 	ColMerge:1,   SaveName:"sabun",				KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사원성명",				Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"가족주민번호",			Type:"Text",      	Hidden:0,  Width:120,    Align:"Center", 	ColMerge:1,   SaveName:"famres",			KeyField:0,   CalcLogic:"",   Format:"IdNo",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"가족관계",				Type:"Text",      	Hidden:0,  Width:120,    Align:"Center", 	ColMerge:1,   SaveName:"fam_cd_nm",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"가족성명",				Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"fam_nm",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기본공제",				Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"dpndnt_yn",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"배우자공제",			Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"spouse_yn",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"경로우대공제",			Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"senior_yn",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"부녀자공제",			Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"woman_yn",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"자녀양육여부",			Type:"Text",      	Hidden:1,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"child_yn",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"자녀세액여부",			Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"add_child_yn",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },			
			{Header:"출산입양공제",			Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"adopt_born_yn",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"한부모공제",			Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"one_parent_yn",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },	//한부모공제
			{Header:"장애자여부",			Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"hndcp_yn",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"장애구분",         Type:"Combo",       Hidden:0,   Width:300,   Align:"Center", ColMerge:0, SaveName:"hndcp_type",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"장애시작일",			Type:"Date",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"sdate",			KeyField:0,   CalcLogic:"",   Format:"Ymd",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"장애종료일",			Type:"Date",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"edate",			KeyField:0,   CalcLogic:"",   Format:"Ymd",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"보험료공제",			Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"insurance_yn",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"의료비공제",			Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"medical_yn",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"교육공제",				Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"education_yn",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"신용카드등공제",			Type:"Text",      	Hidden:0,  Width:80,    Align:"Center", 	ColMerge:1,   SaveName:"credit_yn",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"국세청_신용카드",		Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right",  	ColMerge:1,   SaveName:"card_nts_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기타_신용카드",				Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"card_mon",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"국세청_직불기명식선불카드",	Type:"AutoSum",      	Hidden:0,  Width:120,    Align:"Right", 	ColMerge:1,   SaveName:"chck_nts_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기타_직불기명식선불카드",		Type:"AutoSum",      	Hidden:0,  Width:120,    Align:"Right", 	ColMerge:1,   SaveName:"check_mon",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"국세청_현금영수증",		Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"bill_nits_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기타_현금영수증",			Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"bill_mon",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"국세청_전통시장사용분",	Type:"AutoSum",      	Hidden:0,  Width:120,    Align:"Right", 	ColMerge:1,   SaveName:"market_nts_mon",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기타_전통시장사용분",			Type:"AutoSum",      	Hidden:0,  Width:120,    Align:"Right", 	ColMerge:1,   SaveName:"market_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"국세청_대중교통이용분",	Type:"AutoSum",      	Hidden:0,  Width:120,    Align:"Right", 	ColMerge:1,   SaveName:"bus_nts_mon",	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },	//국세청_대중교통이용분
			{Header:"기타_대중교통이용분",			Type:"AutoSum",      	Hidden:0,  Width:120,    Align:"Right", 	ColMerge:1,   SaveName:"bus_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },	//대중교통이용분
			{Header:"신용카드등사용공제금액",	Type:"AutoSum",      	Hidden:0,  Width:120,    Align:"Right", 	ColMerge:1,   SaveName:"sum_d0",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"국세청_의료비",			Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"medi_nts_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기타_의료비",				Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"medi_mon",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"의료비공제금액",			Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"sum_d4",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"국세청_교육비",			Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"edu_nts_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기타_교육비",				Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"edu_mon",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"교육비공제금액",			Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"sum_d5",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"국세청_보험료",			Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"insu_nts_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기타_보험료",				Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"insu_mon",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"보험료공제금액",			Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"sum_d6",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"국세청_기부금",			Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"dona_nts_mon",		KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기타_기부금",				Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"dona_mon",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기부금공제금액",			Type:"AutoSum",      	Hidden:0,  Width:100,    Align:"Right", 	ColMerge:1,   SaveName:"sum_d7",			KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		//작업구분
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "전체");
	       
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetColProperty("hndcp_type", {ComboText:"|장애인복지법에 따른 장애인|국가유공자 등 예우 및 지원에 관한 법률에 따른 자|그 외 중증환자", ComboCode:"|1|2|3"} );
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});
	
	$(function() {	

		$("#searchWorkYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ 
				doAction1("Search");
			}
		});

		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search");
			}
		});
		
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 
			sheet1.DoSearch( "<%=jspPath%>/yeaCalcFamSearch/yeaCalcFamSearchRst.jsp?cmd=selectYeaCalcFamSearch", $("#sheetForm").serialize() );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
					    <td>
					    	<span>년도</span>
							<%
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text" maxlength="4" style="width:35px" value="<%=yeaYear%>" />
							<%}else{%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text readonly" maxlength="4" style="width:35px" value="<%=yeaYear%>" readonly/>
							<%}%>					    								
						</td>
						<td>
							<span>작업구분</span>
							<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
						</td>
						<td>
							<span>사번/성명</span>
							<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
						</td>
						<td> 
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> 
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	
    <div class="outer">
        <div class="sheet_title">
        <ul>
			<li id="txt" class="txt">가족별입력공제현황</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
			</li>
        </ul>
        </div>
    </div>
	
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>