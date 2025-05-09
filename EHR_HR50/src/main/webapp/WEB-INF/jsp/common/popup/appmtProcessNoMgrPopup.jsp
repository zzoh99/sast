<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>근무지검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");

	$(function() {
		var arg = p.popDialogArgumentAll();

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
		         		
		         		{Header:"No",		Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
		         		{Header:"삭제",		Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"), Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
		         		{Header:"상태",		Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"), Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
		         		
		         		{Header:"발령번호"		, Type:"Text",    Hidden:0,   Width:120,  	Align:"Center", ColMerge:0, SaveName:"processNo",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
		         		{Header:"발령제목"		, Type:"Text",    Hidden:0,   Width:150,  	Align:"Left", ColMerge:0, SaveName:"processTitle",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		         		{Header:"담당부서"		, Type:"Text",    Hidden:1,   Width:70,  	Align:"Left", ColMerge:0, SaveName:"orgCd",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		         		{Header:"담당부서"		, Type:"Text",    Hidden:0,   Width:120,  	Align:"Left", ColMerge:0, SaveName:"orgNm",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		         		{Header:"담당자사번"	, Type:"Text",    Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"processSabun",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
		         		{Header:"담당자성명"	, Type:"Text",    Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"processName",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },		
		         		{Header:"등록일자"		, Type:"Date",    Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"inputYmd",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		         		{Header:"발령\n처리여부"	, Type:"CheckBox",Hidden:0,   Width:40,  	Align:"Center", ColMerge:0, SaveName:"actionYn",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1 , TrueValue:"Y", FalseValue:"N"},
		         		{Header:"발령처리일자"	, Type:"Date",    Hidden:0,   Width:70,  	Align:"Center", ColMerge:0, SaveName:"actionYmd",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		         		
		         		
		         		
		         		
		         	]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.FocusAfterProcess = false;

		
	
        $(".sheet_search :input").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
        $(".date2").datepicker2();

        $(".close").click(function() {
	    	p.self.close();
	    });
        
        $(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
		    sheet1.DoSearch( "${ctx}/AppmtProcessNoMgr.do?cmd=getAppmtProcessNoMgrList", $("#sheet1Form").serialize());
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
			var returnValue = new Array(1);
	 		returnValue["processNo"] = sheet1.GetCellValue(Row,"processNo");
	 		returnValue["processTitle"] = sheet1.GetCellValue(Row,"processTitle");

	 		p.popReturnValue(returnValue);
	 		p.window.close();
		}catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}

	
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>발령번호검색</li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
				<input id="gubun" name="gubun" type="hidden" value="">
                <div class="sheet_search outer">
                    <table>
                    <tr>
						<th>등록일자</th>
                    	<td>
							<input id="searchFromYmd" 	name="searchFromYmd" type="text" size="10" class="date2" value="<%=DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-12)%>"/> ~
							<input id="searchToYmd" 	name="searchToYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
						</td>
						<th>발령번호</th>
                        <td>
                        	<input id="searchProcessNo" name ="searchProcessNo" type="text" class="text" />
                        </td>
						<th>발령제목</th>
                        <td>
                        	<input id="searchProcessTitle" name ="searchProcessTitle" type="text" class="text" />
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
                        </td>
					</tr>
                    </table>
                </div>
	        </form>

	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>
	                <div class="inner">
	                    <div class="sheet_title">
	                    <ul>
	                        <li id="txt" class="txt">발령번호조회</li>
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



