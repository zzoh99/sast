<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기부금조정명세_전체</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var helpText;
	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchYear").val("<%=yeaYear%>") ;

		// 1번 그리드
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
  			{Header:"No|No",						Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"연도|연도",		    			Type:"Text",	Hidden:1,  Width:80,Align:"Center",    ColMerge:1,   SaveName:"work_yy",			KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"정산구분|정산구분",		    	Type:"Combo",	Hidden:0,  Width:60,Align:"Center",    ColMerge:1,   SaveName:"adjust_type",		KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"성명|성명",		    			Type:"Text",	Hidden:0,  Width:80,Align:"Center",    ColMerge:1,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"사번|사번",		    			Type:"Text",	Hidden:0,  Width:80,Align:"Center",    ColMerge:1,   SaveName:"sabun",				KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"기부금명세사번|기부금명세사번",		    Type:"Text",	Hidden:1,  Width:80,Align:"Center",    ColMerge:1,   SaveName:"adj_sabun",			KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"기부금액|기부금액",		    		Type:"Int",		Hidden:0,  Width:80,Align:"daRight",   ColMerge:1,   SaveName:"donation_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"전년까지\n공제된금액|전년까지\n공제된금액",	Type:"Int",		Hidden:0,  Width:80,Align:"daRight",   ColMerge:1,   SaveName:"prev_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"공제대상\n금액|공제대상\n금액",			Type:"Int",		Hidden:0,  Width:80,Align:"daRight",   ColMerge:1,   SaveName:"cur_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"해당연도\n공제금액|해당연도\n공제금액",		Type:"Int",		Hidden:0,  Width:80,Align:"daRight",   ColMerge:1,   SaveName:"ded_mon",			KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"해당연도에 공제받지 못한 금액|소멸금액",		Type:"Int",		Hidden:0,  Width:80,Align:"daRight",   ColMerge:1,   SaveName:"extinction_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
			{Header:"해당연도에 공제받지 못한 금액|이월금액",		Type:"Int",		Hidden:0,  Width:80,Align:"daRight",   ColMerge:1,   SaveName:"carried_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 }
		];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 2번 그리드
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
			{Header:"No|No",						Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
  			{Header:"삭제|삭제",						Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
  			{Header:"상태|상태",						Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"대상연도|대상연도",					Type:"Text",    Hidden:0,  Width:70,Align:"Center",    ColMerge:1,   SaveName:"work_yy",			KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"정산구분|정산구분",					Type:"Text",    Hidden:1,  Width:70,Align:"Center",    ColMerge:1,   SaveName:"adjust_type",		KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"사번|사번",						Type:"Text",    Hidden:0,  Width:80,Align:"Center",    ColMerge:1,   SaveName:"sabun",				KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"기부금종류|기부금종류",				Type:"Combo",   Hidden:0,  Width:80,Align:"Center",    ColMerge:1,   SaveName:"contribution_cd",	KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"기부연도|기부연도",					Type:"Text",	Hidden:0,  Width:80,Align:"Center",    ColMerge:1,   SaveName:"donation_yy",		KeyField:1,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
            {Header:"기부금액|기부금액",					Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"donation_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"전년까지\n공제된금액|전년까지\n공제된금액",	Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"prev_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"공제대상\n금액|공제대상\n금액",			Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"cur_ded_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"해당연도\n금액|해당연도\n금액",			Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"ded_mon",			KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"해당연도에 공제받지 못한금액|소멸금액",		Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"extinction_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"해당연도에 공제받지 못한금액|이월금액",		Type:"Int",		Hidden:0,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"carried_mon",		KeyField:0,   CalcLogic:"",   Format:"Integer",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"금액값 에디트 여부|금액값 에디트 여부",		Type:"Text",	Hidden:1,  Width:80,Align:"Right",     ColMerge:1,   SaveName:"chg_yn",				KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 }
		];IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		//작업구분
        var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );
        var contributionCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00307"), "" );

        sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
        sheet2.SetColProperty("contribution_cd",    {ComboText:"|"+contributionCdList[0], ComboCode:"|"+contributionCdList[1]} );

        $("#searchAdjustType").html(adjustTypeList[2]).val("1");

    	// 사업장(권한 구분)
    	var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
    	var bizPlaceCdList = "";

    	if(ssnSearchType == "A"){
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
    	}else{
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
    	}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize);
        sheetInit();

        doAction1("Search");

		//양식다운로드 title 정의
		var codeCdNm = "", codeCd = "", codeNm = "";

		codeCdNm = "";
		codeNm = adjustTypeList[0].split("|"); codeCd = adjustTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "정산구분 : " + codeCdNm + "\n";

		codeCdNm = "";
		codeNm = contributionCdList[0].split("|"); codeCd = contributionCdList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "기부금종류 : " + codeCdNm + "\n";
	});

	$(function(){
		$("#searchYear").bind("keyup",function(event){
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
		$("input[name=searchMon]").change(function(){
			doAction1("Search");
		});
	});

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
        	if($("#searchYear").val() == "") {
        		alert("대상연도를 입력하여 주십시오.");
        		return;
        	}
        	sheet1.DoSearch( "<%=jspPath%>/donationAdj/donationAdjAdminRst.jsp?cmd=selectDonationAdjAdminList", $("#sheetForm").serialize(), 1 );
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
        }
    }

    //Sheet Action Second
    function doAction2(sAction) {

		switch (sAction) {
		case "Search":
			var param = "searchYear="+sheet1.GetCellValue(sheet1.GetSelectRow(), "work_yy");
			param += "&searchSabun="+sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun");
			param += "&searchAdjustType="+ sheet1.GetCellValue(sheet1.GetSelectRow(), "adjust_type");
			sheet2.DoSearch( "<%=jspPath%>/donationAdj/donationAdjAdminRst.jsp?cmd=selectDonationAdjAdminDetailList", param, 1 );
       	   	break;
		case "Save":
			for(var i=2; i < sheet2.LastRow()+2; i++){
				if(sheet2.GetCellValue(i, "sStatus") == "I" || sheet2.GetCellValue(i, "sStatus") == "U"){
					if(sheet2.GetCellValue(i, "work_yy")*1 > "<%=yeaYear%>"*1) {
						alert("<%=yeaYear%>년 이후 기부금내역은 입력할 수 없습니다.");
						return;
					}
					if(sheet2.GetCellValue(i, "work_yy") == "<%=yeaYear%>"){
						alert('<%=yeaYear%>년 기부금내역은 기부금관리에서 등록하시기 바랍니다.');
						return;
					}
				}
			}
			sheet2.DoSave( "<%=jspPath%>/donationAdj/donationAdjAdminRst.jsp?cmd=saveDonationAdjAdminDetail",$("#sheetForm").serialize());
			break;
		case "Insert":
			if(sheet1.GetSelectRow() == -1) {
				return;
			}

			if(chkRqr()){
	       		 break;
	       	}

			var newRow = sheet2.DataInsert(0);
			sheet2.SetCellValue(newRow, "work_yy", sheet1.GetCellValue(sheet1.GetSelectRow(), "work_yy") ) ;
			sheet2.SetCellValue(newRow, "sabun", sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun") ) ;
			sheet2.SetCellValue(newRow, "adjust_type", sheet1.GetCellValue(sheet1.GetSelectRow(), "adjust_type") ) ;
			break;
		case "Copy":
			sheet2.DataCopy();
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet2.Down2Excel(param); break;
		case "Down2Template":
			var param  = {DownCols:"3|4|5|6|7|8|9|10|11|12|13",SheetDesign:1,Merge:1,DownRows:'0|1',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,11",menuNm:$(document).find("title").text()};
			sheet2.Down2Excel(param);
			break;
		case "LoadExcel":
       	    var params = {Mode:"HeaderMatch", WorkSheetNo:1};
       	    sheet2.LoadExcel(params);
       	    break;
         }
    }

    function chkRqr(){

        var chkSearchAdjustType    = $("#searchAdjustType").val();

        var chkValue = false;

        if(chkSearchAdjustType == ''){
            alert("정산구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }

        return chkValue;
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();

			if(Code == 1 && sheet1.SearchRows() == 0) {
				doAction2('Search');
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

        	if (Code == 1) {
				var flag = 0 ;
				for(var i = 2; i < sheet2.RowCount()+2; i++ ) {
					if( sheet2.GetCellValue("chg_yn", i) == "Y" ) {
						flag = 1 ;//true
					} else {
						flag = 0 ;//false
					}

					sheet2.SetCellEditable(i, "donation_mon", 	flag);
					sheet2.SetCellEditable(i, "prev_ded_mon", 	flag);
					sheet2.SetCellEditable(i, "cur_ded_mon", 	flag);
					sheet2.SetCellEditable(i, "ded_mon", 		flag);
					sheet2.SetCellEditable(i, "extinction_mon", flag);
					sheet2.SetCellEditable(i, "carried_mon", 	flag);
				}
        	}
        } catch (ex) {
        	alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
        		doAction2("Search");
			}
        } catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
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

    function yeaDataExpPopup(title, helpText, height, width){
        var url     = "<%=jspPath%>/common/yeaDataExpPopup.jsp";

            helpText = "<b>※ 기부금조정명세 입력 안내</b><br>" +
                       "<span style='padding-left:10px;'>* 대상연도 : 연말정산 귀속 대상연도를 나타냅니다.</span><br>" +
                       "<span style='padding-left:10px;'>* 기부연도 : 실제 기부한 연도를 나타냅니다.</span><br>" +
                       "<span style='padding-left:20px;'>안내 : 기부연도 및 대상연도는 당해 귀속연도 이전이어야합니다.(예: 2017귀속 연말정산 => 2016 이하)</span><br>" +
                       "<span style='padding-left:30px;'>2017년의 이월금액은 올해 기부한 금액과 함께 공제금액 정산 후 만들어지므로 입력하실 필요 없습니다.</span><br>";

        openYeaDataExpPopup(url, width, height, title, helpText);
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <div class="sheet_search outer">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <!-- Second Grid 조회 조건 -->
        <div>
        <table>
        <tr>
            <td>
            	<span>연도</span>
				<%
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				%>
					<input id="searchYear" name ="searchYear" type="text" class="text center" maxlength="4" style="width:35px"/>
				<%}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}%>
			</td>
			<td>
				<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
			</td>
			<td>
				<input type="radio" id="searchMon" name="searchMon" class="radio" value="1" checked /> <span>전체</span>
				<input type="radio" id="searchMon" name="searchMon" class="radio" value="2"  /> <span>이월금액 발생자</span>
			</td>
            <td>
                <span>사업장</span>
                <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
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
    </form>
    </div>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">기부금조정명세</li>
            <li class="btn">
              <a href="javascript:doAction1('Down2Excel')"   class="basic btn-download authR">다운로드</a>
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
<!--               <a href="javascript:doAction2('Down2Template')"	class="basic authA">양식 다운로드</a> -->
<!--               <a href="javascript:doAction2('LoadExcel')"   	class="basic authA">업로드</a> -->
              <a href="javascript:doAction2('Insert')" 			class="basic authA">입력</a>
              <a href="javascript:doAction2('Copy')"   			class="basic authA">복사</a>
              <a href="javascript:doAction2('Save')"   			class="basic btn-save authA">저장</a>
              <a href="javascript:doAction2('Down2Excel')"   	class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "50%"); </script>

</div>
</body>
</html>