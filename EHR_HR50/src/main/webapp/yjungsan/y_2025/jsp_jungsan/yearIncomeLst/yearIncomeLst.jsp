<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연간소득현황</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		$("#searchWorkYy").val("<%=yeaYear%>") ;

		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",				Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"대상년도",				Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분",				Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직",				Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"org_nm",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"급여총액",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"pay_mon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"상여총액",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"bonus_mon",			KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"인정상여",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"etc_bonus_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"주식매수선택권행사이익",	Type:"Int",			Hidden:0,	Width:130,	Align:"Right",	ColMerge:0,	SaveName:"stock_buy_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"우리사주조합인출금",		Type:"Int",			Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"stock_union_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"총급여",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"tot_mon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"생산직비과세",			Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"notax_work_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"국외비과세",			Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"notax_abroad_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"식재비과세",			Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"notax_food_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"차량비과세",			Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"notax_car_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"외국인비과세",			Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"notax_forn_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"연구활동비과세",			Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"notax_research_mon",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"보육수당비과세",		Type:"Int",			Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"notax_baby_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"비과세계",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"notax_tot_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"국민연금",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"pen_mon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"건강보험",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"hel_mon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"고용보험",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"emp_mon",				KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소득세",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"income_tax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"지방소득세",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"inhbt_tax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"농특세",				Type:"Int",			Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"rural_tax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"비과세포함총급여",		Type:"Int",			Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"total_tax_mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//작업구분
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "" );

		$("#searchAdjustType").html(adjustTypeList[2]);

        $(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
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
			if($("#searchWorkYy").val() == "") {
				alert("대상년도를 입력하여 주십시오.");
			}

			sheet1.DoSearch( "<%=jspPath%>/yearIncomeLst/yearIncomeLstRst.jsp?cmd=selectYearIncomeLstList", $("#sheetForm").serialize() );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
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
					<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text" maxlength="4" style="width:35px"/>
				</td>
				<td>
					<span>정산구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" class="box"></select>
				</td>
				<td>
					<span>사번/성명</span>
					<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
				</td>
				<td>
					<a href="javascript:doAction1('Search')" class="button">조회</a>
				</td>
			</tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">연간소득현황</li>
            <li class="btn">
				<a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>