<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기부금조정명세_개별</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var helpText;
	var contributionCdList = null;
	var adjustTypeList = null;

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchSabun").val( $("#searchUserId").val() ) ;
		$("#searchYear").val("<%=yeaYear%>") ;

		// 1번 그리드
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
   			{Header:"No|No",						Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
            {Header:"연도|연도",		    			Type:"Text",      	Hidden:1,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"work_yy",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
			{Header:"정산구분|정산구분",		    	Type:"Combo",      	Hidden:0,  Width:70,	Align:"Center",    	ColMerge:1,   SaveName:"adjust_type",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
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
			{Header:"대상\n연도|대상\n연도",				Type:"Text",    Hidden:0,  Width:45,	Align:"Center",    	ColMerge:1,   SaveName:"work_yy",			KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
            {Header:"정산구분|정산구분",					Type:"Text",    Hidden:1,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"adjust_type",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"사번|사번",						Type:"Text",    Hidden:1,  Width:80,	Align:"Center",    	ColMerge:1,   SaveName:"sabun",				KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"기부금종류|기부금종류",				Type:"Combo",   Hidden:0,  Width:180,	Align:"Center",    	ColMerge:1,   SaveName:"contribution_cd",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"기부\n연도|기부\n연도",				Type:"Text",	Hidden:0,  Width:45,	Align:"Center",		ColMerge:1,   SaveName:"donation_yy",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
            {Header:"기부금액|기부금액",					Type:"Int",		Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"donation_mon",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"전년까지\n공제된금액|전년까지\n공제된금액",	Type:"Int",		Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"prev_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"공제대상\n금액|공제대상\n금액",			Type:"Int",     Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"cur_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"해당연도\n공제금액|해당연도\n공제금액",		Type:"Int",     Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"ded_mon",			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"해당연도에 공제받지 못한금액|소멸금액",		Type:"Int",     Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"extinction_mon",	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"해당연도에 공제받지 못한금액|이월금액",		Type:"Int",     Hidden:0,  Width:80,	Align:"Right",    	ColMerge:1,   SaveName:"carried_mon",		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		contributionCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00307"), "");

		//작업구분
        adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );

		sheet2.SetColProperty("contribution_cd",    {ComboText:"|"+contributionCdList[0], ComboCode:"|"+contributionCdList[1]} );

        $(window).smartresize(sheetResize); sheetInit();

        getCprBtnChk();	
        
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
			sheet1.DoSearch( "<%=jspPath%>/donationAdj/donationAdjEmpRst.jsp?cmd=selectDonationAdjEmpList", $("#sheetForm").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
        }
    }

    //Sheet Action2
    function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "searchYear="+sheet1.GetCellValue(sheet1.GetSelectRow(), "work_yy");
			param += "&searchSabun="+sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun");
			param += "&searchAdjustType="+ sheet1.GetCellValue(sheet1.GetSelectRow(), "adjust_type");

			sheet2.DoSearch( "<%=jspPath%>/donationAdj/donationAdjEmpRst.jsp?cmd=selectDonationAdjEmpDetailList", param);
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
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

    function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if(sheet1.GetSelectRow() > 0 && OldRow != NewRow){
				doAction2('Search');
			}
		} catch(ex){
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	//성명 바뀌면 호출
	function setEmpPage() {
		$("#searchSabun").val( $("#searchUserId").val() );
		getCprBtnChk();
		doAction1("Search");
	}

	function yeaDataExpPopup(title, helpText, height, width){
        var url     = "<%=jspPath%>/common/yeaDataExpPopup.jsp";

            helpText = "<b>※ 기부금조정명세 입력 안내</b><br>" +
        	           "<span style='padding-left:10px;'>* 대상연도 : 연말정산 귀속 대상연도를 나타냅니다.</span><br>" +
        			   "<span style='padding-left:10px;'>* 기부연도 : 실제 기부한 연도를 나타냅니다.</span><br>" +
                       "<span style='padding-left:20px;'>안내 : 기부연도 및 대상연도는 당해 귀속연도 이전이어야합니다.(예: 2017귀속 연말정산 => 2016 이하)</span><br>" +
                       "<span style='padding-left:30px;'>2017년의 이월금액은 올해 기부한 금액과 함께 공제금액 정산 후 만들어지므로 입력하실 필요 없습니다.</span><br>";

        openYeaDataExpPopup(url, width, height, title, helpText);
    }
	
	//수정(이력) 관련 세팅
	function getCprBtnChk(Row){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#searchYear").val() 
                   + "&searchAdjustType="
                   + "&searchSabun="+$("#searchUserId").val();
        
		if (typeof Row != 'undefined' && Row != '') {
			//시트에서 사번이 변경된 경우 해당 사번에 대한 콤보만 재구성
			params = params + sheet1.GetCellValue(Row, "sabun");
		}
		
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#searchAdjustType").html("");
		} else {   			
   			if (typeof Row == 'undefined' || Row == '') {
   				$("#searchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
   				sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
   				   				
   				//양식다운로드용 sheet 정의
   				templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
   				var codeCdNm = "", codeCd = "", codeNm = "";

   				codeCdNm = "";
   				codeNm = adjustTypeList[0].split("|"); codeCd = adjustTypeList[1].split("|");
   				for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
   				templeteTitle1 += "정산구분 : " + codeCdNm + "\n";

   				codeCdNm = "";
   				codeNm = contributionCdList[0].split("|"); codeCd = contributionCdList[1].split("|");
   				for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
   				templeteTitle1 += "기부금종류 : " + codeCdNm + "\n";
   			} else {
   			    //시트에서 사번이 변경된 경우 해당 사번에 대한 콤보만 재구성
   				sheet1.CellComboItem(Row, "adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
   			}
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<%@ include file="../common/include/employeeHeaderYtax.jsp"%>

    <div class="sheet_search outer">
    <form id="sheetForm" name="sheetForm" >
    	<input type="hidden" id="searchSabun" name="searchSabun" value ="" />
    	<input type="hidden" id="menuNm" name="menuNm" value="" />
        <div>
        <table>
        <tr>
            <td>
            	<span>연도</span>
				<%
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				%>
					<input id="searchYear" name ="searchYear" type="text" class="text center" maxlength="4" style="width:35px" value="<%=yeaYear%>"/>
				<%}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" value="<%=yeaYear%>" readonly/>
				<%}%>
			</td>
			<td>
				<span>정산구분</span>
				<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
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
              <a href="javascript:doAction1('Down2Excel')" class="basic btn-download authR">다운로드</a>
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
<!--               <a href="javascript:yeaDataExpPopup('기부금조정명세 입력 안내', helpText, 200, 700)" class="cute_gray authA">입력 안내</a> &nbsp; -->
              <a href="javascript:doAction2('Down2Excel')" class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>

</div>
</body>
</html>