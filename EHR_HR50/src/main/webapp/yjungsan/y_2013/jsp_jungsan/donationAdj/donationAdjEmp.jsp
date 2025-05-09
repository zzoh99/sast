<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기부금조정명세(개인별)</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		$("#searchSabun").val( $("#searchUserId").val() ) ;
		$("#searchYear").val("<%=yeaYear%>") ;
		
		// 1번 그리드
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
   			{Header:"No|No",						Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"연도|연도",		    			Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"work_yy",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
			{Header:"정산구분|정산구분",		    		Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"adjust_type",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"성명|성명",		    			Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"name",			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"사번|사번",		    			Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"sabun",			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"기부금명세사번|기부금명세사번",		    Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"adj_sabun",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"기부금액|기부금액",		    		Type:"Int",      	Hidden:0,  Width:100,	Align:"daRight",    ColMerge:1,   SaveName:"donation_mon",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"전년까지\n공제된금액|전년까지\n공제된금액",	Type:"Int",      	Hidden:0,  Width:100,	Align:"daRight",    ColMerge:1,   SaveName:"prev_dDed_mon",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"공제대상\n금액|공제대상\n금액",			Type:"Int",      	Hidden:0,  Width:100,	Align:"daRight",    ColMerge:1,   SaveName:"cur_ded_mon",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"해당연도\n공제금액|해당연도\n공제금액",		Type:"Int",      	Hidden:0,  Width:100,	Align:"daRight",    ColMerge:1,   SaveName:"ded_mon",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"해당연도에 공제받지 못한 금액|소멸금액",		Type:"Int",      	Hidden:0,  Width:100,	Align:"daRight",    ColMerge:1,   SaveName:"extinction_mon",KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
			{Header:"해당연도에 공제받지 못한 금액|이월금액",		Type:"Int",      	Hidden:0,  Width:100,	Align:"daRight",    ColMerge:1,   SaveName:"carried_mon",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 2번 그리드
        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata2.Cols = [
 			{Header:"No|No",						Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"대상연도|대상연도",					Type:"Text",    Hidden:0,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"work_yy",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
            {Header:"정산구분|정산구분",					Type:"Text",    Hidden:1,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"adjust_type",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"사번|사번",						Type:"Text",    Hidden:1,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"sabun",				KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"기부금종류|기부금종류",				Type:"Combo",   Hidden:0,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"contribution_cd",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"기부연도|기부연도",					Type:"Text",	Hidden:0,  Width:80,	Align:"Center",		ColMerge:1,   SaveName:"donation_yy",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
            {Header:"기부금액|기부금액",					Type:"Int",		Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"donation_mon",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"전년까지\n공제된금액|전년까지\n공제된금액",	Type:"Int",		Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"prev_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"공제대상\n금액|공제대상\n금액",			Type:"Int",     Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"cur_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"해당연도\n공제금액|해당연도\n공제금액",		Type:"Int",     Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"ded_mon",			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"해당연도에 공제받지 못한금액|소멸금액",		Type:"Int",     Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"extinction_mon",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"해당연도에 공제받지 못한금액|이월금액",		Type:"Int",     Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"carried_mon",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		var contributionCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00307"), "");
		
		sheet2.SetColProperty("contribution_cd",    {ComboText:"|"+contributionCdList[0], ComboCode:"|"+contributionCdList[1]} );

        $(window).smartresize(sheetResize); sheetInit();
        
        doAction1("Search");
	});
	
	$(function(){
		$("#searchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus();
			}
		});
	});

    //Sheet Action1
    function doAction1(sAction) {
        switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/donationAdj/donationAdjEmpRst.jsp?cmd=selectDonationAdjEmpList", $("#sheetForm").serialize(), 1); 
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
        }
    }

    //Sheet Action2
    function doAction2(sAction) {

		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "<%=jspPath%>/donationAdj/donationAdjEmpRst.jsp?cmd=selectDonationAdjEmpDetailList", $("#sheetForm").serialize(), 1); 
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet2.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
			
			if(Code == 1) {
				doAction2("Search");
			}
			
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}

    // 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
   		try { 
   			alertMessage(Code, Msg, StCode, StMsg);
   			sheetResize(); 
   		} catch (ex) { 
   			alert("OnSearchEnd Event Error : " + ex); 
   		}
    }
    
	//성명 바뀌면 호출
	function setEmpPage() {
		$("#searchSabun").val( $("#searchUserId").val() );
		doAction1("Search");
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<%@ include file="../common/include/employeeHeaderYtax.jsp"%>

    <div class="sheet_search outer">
    <form id="sheetForm" name="sheetForm" >
    	<input type="hidden" id="searchSabun" name="searchSabun" value ="" />
        <div>
        <table>
        <tr>
            <td>
            	<span>연도</span>
				<input id="searchYear" name ="searchYear" type="text" class="text center" maxlength="4" style="width:35px" value="<%=yeaYear%>"/>
			</td>
            <td>
            	<a href="javascript:doAction1('Search');" class="button">조회</a>
            </td>
        </tr>
        </table>
        </div>
    </form>
    </div>

    <div class="outer">
        <div class="sheet_title">
        <ul>
        	<li class="txt">기부금조정명세
            <li class="btn">
              <a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "50%"); </script>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">기부금조정명세 상세내역</li>
            <li class="btn">
              <a href="javascript:doAction2('Down2Excel')" class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>

</div>
</body>
</html>