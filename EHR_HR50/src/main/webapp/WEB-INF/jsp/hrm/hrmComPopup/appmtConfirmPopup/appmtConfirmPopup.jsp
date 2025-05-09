<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='112142' mdef='품의서조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var srchBizCd = null;
	var p = eval("${popUpStatus}");
	$(function() {
		var config = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		var info = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		var headers = [
			{Text:"No|기안자|기안자|기안자|기안자|기안자|기안일자|품의번호|품의제목",Align:"Center"},
		    {Text:"No|소속|직책|직위|사번|성명|기안일자|품의번호|품의제목",Align:"Center"}
		];

		var cols = [
			{Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	CalcLogic:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikcheckNm",	KeyField:0,	Format:"",	CalcLogic:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	CalcLogic:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",	KeyField:0,	Format:"",	CalcLogic:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applName",	KeyField:0,	Format:"",	CalcLogic:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:0,	Format:"Ymd",CalcLogic:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Type:"Text",		Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"processNo",	KeyField:0,	Format:"",	CalcLogic:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20 },
			{Type:"Text",		Hidden:0,	Width:110,	Align:"Left",	ColMerge:0,	SaveName:"title",		KeyField:0,	Format:"",	CalcLogic:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		];

		sheet1.SetConfig(config);
		sheet1.InitHeaders(headers, info);
		sheet1.InitColumns(cols);

		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		sheetInit();
		doAction1("Search");
	});

	$(function() {
        $("#processNo, #applName, #title").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

        $(".close").click(function() {
	    	p.self.close();
	    });

		$("#applYmdFrom").datepicker2({startdate:"applYmdTo"});
		$("#applYmdTo").datepicker2({enddate:"applYmdFrom"});

	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회

			if($("#applYmdFrom").val() == "") {
				alert("<msg:txt mid='110328' mdef='기안일을 입력하여 주십시오.'/>");
				$("#applYmdFrom").focus();
				return;
			}
			if($("#applYmdTo").val() == "") {
				alert("<msg:txt mid='110328' mdef='기안일을 입력하여 주십시오.'/>");
				$("#applYmdTo").focus();
				return;
			}

			var param = "applYmdFrom="+$('#applYmdFrom').val().replace(/-/gi,"")
						+ "&applYmdTo="+$('#applYmdTo').val().replace(/-/gi,"")
						+ "&applName="+$('#applName').val()
						+ "&processNo="+$('#processNo').val()
						+ "&title="+$('#title').val();

		    sheet1.DoSearch( "${ctx}/AppmtConfirmPopup.do?cmd=getAppmtConfirmPopupList", param );
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
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
		  	sheet1.FocusAfterProcess = false;
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

    	var returnValue = new Array(1);
 		returnValue["processNo"] = sheet1.GetCellValue(Row,"processNo");
 		returnValue["applSabun"] = sheet1.GetCellValue(Row,"applSabun");
 		returnValue["applName"] = sheet1.GetCellValue(Row,"applName");

 		p.popReturnValue(returnValue);
 		p.window.close();
	}
</script>

</head>
<body class="bodywrap">

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='112142' mdef='품의서조회'/></li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="mySheetForm" name="mySheetForm">
                <input type="hidden" id="srchStatusCd" name="srchStatusCd" value="RA"/>
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
						<th><tit:txt mid='114163' mdef='기안일자'/></th>
                        <td>
                        	<input id="applYmdFrom" name ="applYmdFrom" type="text" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
                        	<input id="applYmdTo" name ="applYmdTo" type="text" class="date2 required" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
                        </td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
                        <td>
                        	<input id="applName" name ="applName" type="text" class="text" />
                        </td>
                        <td>
                        </td>
					</tr>
					<tr>
						<th><tit:txt mid='113517' mdef='품의번호'/></th>
                        <td>
                        	<input id="processNo" name ="processNo" type="text" class="text" />
                        </td>
						<th><tit:txt mid='112477' mdef='품의제목'/></th>
                        <td>
                        	<input id="title" name ="title" type="text" class="text" />
                        </td>
                        <td>
                            <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
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
	                        <li id="txt" class="txt"><tit:txt mid='112142' mdef='품의서조회'/></li>
	                    </ul>
	                    </div>
	                </div>
	                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	                </td>
	            </tr>
	        </table>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>



