<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='vacationUpdAppDetPop' mdef='휴가내역검색'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.window.dialogArguments;
	var sabun = "";

	$(function() {

	    if( arg != undefined ) {
	    	sabun 	= arg["sabun"];
	    }else{
	    	if(p.popDialogArgument("sabun")!=null)		sabun  	= p.popDialogArgument("sabun");
	    }


		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",                 Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='applYmdV10' mdef='신청일|신청일'/>",         Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='applStatusNmV1' mdef='신청상태|신청상태'/>",     Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='gntNmV1' mdef='근태종류|근태종류'/>",     Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gntCd",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='sdateV15' mdef='신청기간|시작일'/>",       Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='edateV10' mdef='신청기간|종료일'/>",       Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eYmd",			KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='holDayV2' mdef='적용\n일수|적용\n일수'/>", Type:"Text",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"closeDay",			KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
   			{Header:"<sht:txt mid='reasonCdV2' mdef='사유|사유'/>",             Type:"Text",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"gntReqReson",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000 },
   			{Header:"<sht:txt mid='applSeqV11' mdef='신청번호|신청번호'/>",     Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='applSabunV10' mdef='대상자사번|대상자사번'/>", Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='applInSabunV8' mdef='신청자사번|신청자사번'/>", Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
   		];IBS_InitSheet(sheet1, initdata1);

		sheet1.SetEditable(false);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");
		var gntCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getCpnGntCdList&requestNotUseType=N"), "<tit:txt mid='103895' mdef='전체'/>");

		sheet1.SetColProperty("applStatusCd", 	{ComboText:"|"+applStatusCd[0], ComboCode:"|"+applStatusCd[1]} );
		sheet1.SetColProperty("gntCd", 			{ComboText:"|"+gntCd[0], ComboCode:"|"+gntCd[1]} );

		$("#gntCd").html(gntCd[2]);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $(".close").click(function() {
	    	p.self.close();
	    });

		$("#sYmd").datepicker2({
			startdate:"eYmd"
		});

		$("#eYmd").datepicker2({
			enddate:"sYmd"
		});
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			var param = "sabun="+sabun
						+"&gntCd="+$("#gntCd").val()
						+"&sYmd="+$("#sYmd").val().replace(/-/gi,"")
						+"&eYmd="+$("#eYmd").val().replace(/-/gi,"");

		    sheet1.DoSearch( "${ctx}/VacationUpdAppDet.do?cmd=getVacationUpdAppDetPopupList", param);
            break;
        case "Clear":        //Clear
            sheet1.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기
            sheet1.Down2Excel();
            break;
		}
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	// 더블클릭시 발생
	function sheet1_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		}catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}

	function returnFindUser(Row,Col){

    	var returnValue = [];
 		returnValue["gntCd"] = sheet1.GetCellValue(Row,"gntCd");
 		returnValue["sYmd"] = sheet1.GetCellValue(Row,"sYmd");
 		returnValue["eYmd"] = sheet1.GetCellValue(Row,"eYmd");
 		returnValue["closeDay"] = sheet1.GetCellValue(Row,"closeDay");
 		returnValue["applSeq"] = sheet1.GetCellValue(Row,"applSeq");

 		//p.window.returnValue = returnValue;
 		if(p.popReturnValue) p.popReturnValue(returnValue);
 		p.window.close();
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='vacationUpdAppDetPop' mdef='휴가내역검색'/></li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
						<th><tit:txt mid='103963' mdef='근태종류'/></th>
                        <td>
                        	<select id="gntCd" name="gntCd"></select>
                        </td>
						<th><tit:txt mid='104389' mdef='신청일'/></th>
                        <td>
							<input id="sYmd" name="sYmd" type="text" size="10" class="date2 required" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-1)%>"/> ~
							<input id="eYmd" name="eYmd" type="text" size="10" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
                        </td>
                        <td>
                            <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='search' mdef="조회"/>
                        </td>
					</tr>
                    </table>
                    </div>
                </div>
	        </form>

	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>
	                <div class="inner">
	                    <div class="sheet_title">
	                    <ul>
	                        <li id="txt" class="txt"><tit:txt mid='2017082400469' mdef='휴가내역조회'/></li>
	                    </ul>
	                    </div>
	                </div>
	                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
	                </td>
	            </tr>
	        </table>
	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <btn:a href="javascript:p.self.close();" css="gray large" mid="close" mdef="닫기"/>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>



