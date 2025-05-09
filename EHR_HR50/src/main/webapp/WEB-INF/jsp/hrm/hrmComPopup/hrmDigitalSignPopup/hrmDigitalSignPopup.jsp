<%@ page import="com.hr.common.util.DateUtil" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114643' mdef='전자서명양식검색'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var arg = p.window.dialogArguments;

	$(function() {
		$("#baseDate").datepicker2({ymdonly:true});
		$("#baseDate").val("<%=DateUtil.getCurrentDay()%>") ;//현재년월 세팅
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"formId",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='formNm' mdef='서류종류'/>",	Type:"Text",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"formNm",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",		Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.FocusAfterProcess = false;
		
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});
	
	$(function() {
        $("#codeNm").bind("keyup",function(event){
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
		    sheet1.DoSearch( "${ctx}/HrmDigitalSignPopup.do?cmd=getHrmDigitalSignPopupList", $("#sheet1Form").serialize());
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
	    
    	var returnValue = new Array(1);
 		returnValue["formId"] = sheet1.GetCellValue(Row,"formId");
 		returnValue["formNm"] = sheet1.GetCellValue(Row,"formNm");
 		returnValue["note"] = sheet1.GetCellValue(Row,"note");
        
 		p.window.returnValue = returnValue;                   
 		p.window.close();
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='114643' mdef='전자서명양식검색'/></li>
                <li class="close"></li>
            </ul>
        </div>
        
        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
				<input id="gubun" name="gubun" type="hidden" value="">
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
						<th><tit:txt mid='113194' mdef='양식명'/></th> 
                        <td>
                        	<input id="formNm" name ="formNm" type="text" class="text" />
                        </td>
						<td id="baseDateTd1" class="title"><tit:txt mid='104352' mdef='기준일자'/></td>
				        <td id="baseDateTd2" class="">
				            <input class="text w70 date" type="text" id="baseDate" name="baseDate" size="10" maxlength="9"> 
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
	                        <li id="txt" class="txt"><tit:txt mid='112143' mdef='학교조회'/></li>
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



