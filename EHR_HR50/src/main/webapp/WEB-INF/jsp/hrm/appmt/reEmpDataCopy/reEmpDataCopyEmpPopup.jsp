<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>합격자정보I/F</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },

			{Header:"일련\n번호",			Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"receiveNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"승인/반려\n여부",		Type:"Combo",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"apprYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			
			{Header:"발령",				Type:"Combo",		Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령상세",				Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령세부사유",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발령일",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령seq",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"입력일",				Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사번",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",				Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"성명(한자)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nameCn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"성명(영문)",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"nameUs",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"주민등록번호",			Type:"Text",		Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:1,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:200 },
			{Header:"최초입사일",			Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"입사일",				Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"발령확정\n여부",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },

			{Header:"전출(퇴직)\n회사",		Type:"Combo",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"전출(퇴직)\n사번",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordEnterSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 }
			
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	
		var ordTypeCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeList&inOrdType=10,",false).codeList, "");//입사 발령형태
		var ordDetailCd = stfConvCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList&inOrdType=10,",false).codeList, "");//입사 발령
		var ordReasonCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1=A", "H40110"), " ");

		//회사코드
		var ordEnterCdList = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W90000")
		var ordEnterCd = stfConvCode(ordEnterCdList , "");
		var searchOrdEnterCdOpt = stfConvCode(ordEnterCdList , "<tit:txt mid='103895' mdef='전체' />");
		$("#searchOrdEnterCd").html(searchOrdEnterCdOpt);

		//발령상세[코드]
		sheet1.SetColProperty("ordTypeCd",		{ComboText:"|"+ordTypeCd[0], ComboCode:"|"+ordTypeCd[1]} );	
		sheet1.SetColProperty("ordDetailCd", 	{ComboText:"|"+ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );
		sheet1.SetColProperty("ordReasonCd",	{ComboText:"|"+ordReasonCd[0], ComboCode:"|"+ordReasonCd[1]} );

		sheet1.SetColProperty("ordEnterCd", 	{ComboText:"|"+ordEnterCd[0], ComboCode:"|"+ordEnterCd[1]} );
		
		$("#searchFromYmd, #searchToYmd").datepicker2();


		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");
	});

	$(function() {		
		$("#searchFromYmd, #searchToYmd, #searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});		
        
        $(".close").click(function() {
	    	p.self.close();
	    });
	});


	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getReEmpDataCopyEmpPopup", $("#sheet1Form").serialize() );

			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			var d = new Date();
			var fName = "excel_" + d.getTime() + ".xlsx";
			sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 }));

			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}

 			sheetResize();

		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function sheet1_OnDblClick(Row, Col){
		var rv = new Array(10);

		rv["sabun"] 			= sheet1.GetCellValue(Row, "sabun");
		rv["ordEnterCd"] 		= sheet1.GetCellValue(Row, "ordEnterCd");
		rv["ordEnterSabun"] 	= sheet1.GetCellValue(Row, "ordEnterSabun");
		rv["name"] 				= sheet1.GetCellValue(Row, "name");
		rv["resNo"] 			= sheet1.GetCellValue(Row, "resNo");

		p.popReturnValue(rv);
		p.window.close();
	}	


</script>
</head>
<body class="bodywrap">

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>재입사 / 사간전입 발령</li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                    	<th class="hide">퇴직(전출)회사 </th>
						<td class="hide">  <select id="searchOrdEnterCd" 	name="searchOrdEnterCd" onChange="javascript:doAction1('Search');"> </select> </td>
						<th><tit:txt mid="104084" mdef="발령일 " /> </th>
						<td> 
							<input type="text" id="searchFromYmd" name ="searchFromYmd" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
							<input type="text" id="searchToYmd" name ="searchToYmd" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),+30)%>"/>
						</td>
						<th>사번/성명</th>
                        <td>
                        	<input id="searchSabunName" name="searchSabunName" type="text" class="text"/>
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
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
	                        <li id="txt" class="txt"> [ 재입사 / 사간전입 ] 발령 </li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel');" class="basic authA">다운로드</a>
							</li>
	                    </ul>
	                    </div>
	                </div>
	                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
	                </td>
	            </tr>
	        </table>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>