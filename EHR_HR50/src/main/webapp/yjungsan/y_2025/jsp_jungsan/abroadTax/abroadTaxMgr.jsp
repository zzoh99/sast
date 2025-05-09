<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>외납세명세조회</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">	
	$(function() {
        $("#menuNm").val($(document).find("title").text());
		$("#searchYear").val("<%=yeaYear%>") ;

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"<%=sDelTy%>",   Hidden:1,  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
   			{Header:"상태|상태",			Type:"<%=sSttTy%>",   Hidden:1,  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			
   			{Header:"대상정보|대상년도",		Type:"Text",      Hidden:0,  Width:60,    Align:"Center",  ColMerge:1,   SaveName:"work_yy",		KeyField:1, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
	        {Header:"대상정보|정산구분",		Type:"Combo",     Hidden:0,  Width:120,    Align:"Center",  ColMerge:1,  SaveName:"adjust_type",	KeyField:1, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"대상정보|성명",		Type:"Popup",	  Hidden:0, 	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상정보|사번",		Type:"Text",	  Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			
			{Header:"대상정보|납부연도",		Type:"Text",	  Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"pay_yy",			KeyField:1, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"대상정보|국가",    Type:"Combo",     Hidden:0,  	Width:70,   Align:"Center", ColMerge:0, SaveName:"national_cd",     KeyField:1, Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"대상정보|외납구분",		Type:"Combo",	  Hidden:0,  	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"gubun",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 }, //TCPN885자료로 조회만. 저장불가.
			
			{Header:"국외원천소득|비용차감후\n금액⑤",  Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"pay_mon",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"국외원천소득|차감대상\n감면액⑧",	Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"reduce_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"국외원천소득|공제대상\n⑨=⑤-⑧",	Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"trg_mon",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"국외원천소득|결손반영\n기준금액 ⑩",Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"base_mon",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			
			{Header:"공제한도|산출세액\n⑪",		Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"clclte_tax_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"공제한도|근로소득금액\n⑫",	Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"income_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"공제한도|공제한도액\n⑬=⑪*⑩/⑫",Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"limit_mon",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			
			//{Header:"공제대상세액|전기누적\n공제액",Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"prev_ded_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"공제대상세액|전기이월액\n⑭",	Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"prev_carried_mon",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"공제대상세액|외납세액\n⑮",	Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"pay_tax_mon",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"공제대상세액|공제대상액\n⑯=⑭+⑮",Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"cur_ded_mon",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
						
			{Header:"세액공제액\n=min(⑯,⑬)|세액공제액\n=min(⑯,⑬)",Type:"Int",Hidden:0,	Width:100,	Align:"Right",	ColMerge:1,	SaveName:"ded_mon",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },

			{Header:"이월배제|한도초과액\n⑰=⑮-⑬",	Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"limit_ov_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"이월배제|배제액(비용)\n⑱",Type:"Int",			Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"exc_tax_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"이월배제|배제액(확정)\n⑲=min(⑰,⑱)",Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"no_carried_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			
			{Header:"이월금액|당기공제한도\n=⑯-⑬-⑲",Type:"Int",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"carried_mon",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"이월금액|세액공제 중\n산출세액 0",Type:"Int",Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"carried_mon_841",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"소멸금액|소멸금액",			Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:1,	SaveName:"extinction_mon",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			
			{Header:"비고|비고",			Type:"Text",		Hidden:0, 	Width:140,	Align:"Left",	ColMerge:1,	SaveName:"memo", KeyField:0, Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }
			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetColProperty("gubun",		{ComboText:"|"+"대납|자납", ComboCode:"|"+"A|B"} );
		
		var nationalCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","H20295"), "");
		sheet1.SetColProperty("national_cd",    {ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

		$(window).smartresize(sheetResize); sheetInit();

		getCprBtnChk();

		doAction1("Search");
		
	});

	$(function() {

		/* 전체 대상자의 자료를 취급하는 곳에는 getCprBtnChk를 동작하지 않도록 함. 동명이인일 때 오작동을 막기 위하여. 20241120
		$("#searchYear, #searchSbNm").change(function(){
			getCprBtnChk();
		}); */
		
		$("#searchYear, #searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
		$("input[name=searchMon]").change(function(){
			doAction1("Search");
		});
	});
	
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/abroadTax/abroadTaxMgrRst.jsp?cmd=selectAbroadTaxMgrList", $("#sheetForm").serialize() );
			break;
			
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
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

	//수정(이력) 관련 세팅
	function getCprBtnChk(){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#searchYear").val() 
                   + "&searchAdjustType="
                   /* 전체 대상자의 자료를 취급하는 곳에는 getCprBtnChk를 동작하지 않도록 함. 동명이인일 때 오작동을 막기 위하여. 20241120
                   + "&searchSabun=" + $("#searchSbNm").val()  */
                   + "&searchSabun="
                   ;
		
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#searchAdjustType").html("");
		} else {   			
			$("#searchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<input type="hidden" id="srchYear" name="srchYear" value="<%=yeaYear%>" /><%-- 현재 메뉴의 귀속년도 --%>
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>대상년도</span>
					<input id="searchYear" name ="searchYear" type="text" class="text center" maxlength="4" style="width:35px"/>
				</td>
				<td><span>정산구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
				<td>
					<label for="searchMon1"><input type="radio" id="searchMon1" name="searchMon" class="radio" value="0" checked /> <span>전체</span></label>
					<label for="searchMon2"><input type="radio" id="searchMon2" name="searchMon" class="radio" value="1"  /> <span>이월금액 발생자</span></label>
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')" ></select>
                </td>
                <td><span>사번/성명</span>
					<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td>
				<td>
					<a href="javascript:doAction1('Search')" id="btnSearch" class="button" >조회</a> </td>
				</td> 
			</tr>
		</table>
		</div>
	</div>
	</form>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">외납세명세조회</li>
			<li class="btn">
				<font class='blue'><strong>[ <%=yeaYear%> 귀속년도 세금계산에 따른 결과(외국납부세액 명세)를 조회하는 화면입니다. ]</strong></font>
            	<%-- 세금계산 시 발생하는 자료 조회 전용 화면
				<a href="javascript:doAction1('Down2Template')"	class="basic btn-download authR">양식다운로드</a>
				<a href="javascript:doAction1('LoadExcel')" 	class="basic btn-upload authA">업로드</a>
				<a href="javascript:doAction1('Insert')" 		class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')" 			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save');" class="basic btn-save authA">저장</a>
				 --%>
 				<a href="javascript:doAction1('Down2Excel')"	class="basic btn-download authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>