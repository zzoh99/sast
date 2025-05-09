<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>휴가계획검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var searchApplSabun = "";

	$(function() {
		$("#searchYear").val("${curSysYear}");

		var arg = p.window.dialogArguments;
		if( arg != undefined ) {
			searchApplSabun 	= arg["searchApplSabun"];
		}else{
		    if(p.popDialogArgument("searchApplSabun")!=null)		searchApplSabun  	= p.popDialogArgument("searchApplSabun");
	    }
		$("#searchApplSabun").val(searchApplSabun);

		var data = ajaxCall("${ctx}/VacationApp.do?cmd=getVacationAppDetPlanPopupMap", "searchApplSabun="+searchApplSabun, false);

		if ( data != null && data.DATA != null ){
			$("#name"	).val(data.DATA.name);
			$("#orgNm"	).val(data.DATA.orgNm);
		}

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"시작일자",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"종료일자",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"총일수",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totalDays",	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"적용일수",	Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"days",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"비고",		Type:"Text",	Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
			{Header:"SEQ",		Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
			{Header:"사번",		Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
			{Header:"신청순번",	Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $("#name, #searchYear").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
		    sheet1.DoSearch( "${ctx}/VacationApp.do?cmd=getVacationAppDetPlanPopupList", $("#sheet1Form").serialize());
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
			returnData(Row);
		}catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}

   function select() {
      var row = sheet1.GetSelectRow();

      if (row < 1){
    	  alert("선택한 정보가 없습니다.");
    	  return;
      }
      returnData(row);
   }

	function returnData(Row){
    	var returnValue = [];
 		returnValue["sdate"] = sheet1.GetCellValue(Row,"sdate");
 		returnValue["edate"] = sheet1.GetCellValue(Row,"edate");
 		returnValue["sdateFormat"] = sheet1.GetCellText(Row,"sdate");
 		returnValue["edateFormat"] = sheet1.GetCellText(Row,"edate");

//  		p.window.returnValue = returnValue;
 		if(p.popReturnValue) p.popReturnValue(returnValue);
 		p.window.close();
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>휴가계획</li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
				<input id="searchApplSabun" name="searchApplSabun" type="hidden" value="">

                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
						<th>소속</th>
                        <td>
                        	<input id="orgNm" name ="orgNm" type="text" class="text readonly" readonly />
                        </td>
						<th>사번/성명</th>
                        <td>
                        	<input id="name" name ="name" type="text" class="text readonly" readonly />
                        </td>
						<th>년도</th>
                        <td>
                        	<input id="searchYear" name ="searchYear" type="text" class="text" />
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
	                        <li id="txt" class="txt">휴가계획</li>
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
	                    <a href="javascript:select();" class="pink large">선택</a>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>



