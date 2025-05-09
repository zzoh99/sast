<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>담당자-임직원 FeedBack</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%
Map paramMap = StringUtil.getRequestMap(request);
Map mp = StringUtil.getParamMapData(paramMap);
String searchWorkYy = (String)mp.get("workYy");
String searchAdjustType = (String)mp.get("adjustType");
String searchSabun = (String)mp.get("sabun");
String searchAuthPg = (String)mp.get("authPg");
%>

<script type="text/javascript">

	$(function() {
		
		$("#searchWorkYy").val("<%=searchWorkYy%>");
		$("#searchAdjustType").val("<%=searchAdjustType%>");
		$("#searchSabun").val("<%=searchSabun%>");
		$("#searchAuthPg").val("<%=searchAuthPg%>");
		
		var managerEditable = "1";
		var employeeEditable = "0";
		if($("#searchAuthPg").val() == "R") {
			var managerEditable = "0";
			var employeeEditable = "1";
		}
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};                                                                                                                                                                                              
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};                                                                                                                                                                          
		initdata1.Cols = [                                                                                                                                                                                                                            
   			{Header:"No",		        Type:"Seq",			Hidden:0,	Width:45,	Align:"Center",		ColMerge:1,	SaveName:"sNo" },
   			{Header:"삭제",		        Type:"DelCheck",	Hidden:1,	Width:45,	Align:"Center",		ColMerge:1,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",				Type:"Status",		Hidden:1,	Width:45,	Align:"Center",		ColMerge:1,	SaveName:"sStatus",	Sort:0 },
            {Header:"대상연도", 			Type:"Text",     	Hidden:1, 	Width:50,	Align:"Center",    	ColMerge:1, SaveName:"work_yy",  		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:4 },
            {Header:"정산구분", 			Type:"Text",     	Hidden:1,  	Width:50,  	Align:"Center",    	ColMerge:1, SaveName:"adjust_type",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:1 },
            {Header:"사번", 				Type:"Text",     	Hidden:1, 	Width:50,  	Align:"Center",    	ColMerge:1, SaveName:"sabun",  			KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:13 },
            {Header:"구분", 				Type:"Combo",    	Hidden:0,  	Width:80,  	Align:"Center",    	ColMerge:1, SaveName:"gubun_cd",  		KeyField:1,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:35 },
            {Header:"구분명", 				Type:"Combo",    	Hidden:1,  	Width:80,  	Align:"Center",    	ColMerge:1, SaveName:"gubun_nm",		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:35 },
            {Header:"확인필요건수", 			Type:"Text",     	Hidden:0,  	Width:70,  	Align:"Center",    	ColMerge:1, SaveName:"detail_cnt",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:20 },
            {Header:"담당자 FeedBack",		Type:"Text",     	Hidden:0,  	Width:200,  Align:"Left",    	ColMerge:1, SaveName:"manager_note",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:managerEditable,	InsertEdit:0,   EditLen:1000, MultiLineText:1 },
            {Header:"직원 FeedBack",   	Type:"Text",     	Hidden:0,  	Width:200,  Align:"Left",    	ColMerge:1, SaveName:"employee_note", 	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:employeeEditable,   InsertEdit:0,   EditLen:1000, MultiLineText:1 }
        ];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetCountPosition(4);
        
        var comboText = ["전체","일반","연금보혐료","보험료","의료비","교육비","주택자금","기부금","개인연금저축","주택마련저축","신용카드","기타"];
        var comboCode = ["","COMM","PENS","INSU","MEDI","EDUC","RENT","DONA","SAVE","HOUS","CARD","ETCC"];
        
		sheet1.SetColProperty("gubun_cd", {ComboText:comboText.join("|") , ComboCode:comboCode.join("|")} );
		sheet1.SetColProperty("gubun_nm", {ComboText:comboText.join("|") , ComboCode:comboCode.join("|")} );
		
		sheet1.SetSendComboData(0,"gubun_nm","Text");
		sheet1.SetEditEnterBehavior("newline");
		sheet1.SetBasicImeMode(1);

		$(comboCode).each(function(index){
			var option = "<option value='"+comboCode[index]+"'>"+comboText[index]+"</option>";
			$("#searchGubunCd").append(option);
		});
        
	    $(window).smartresize(sheetResize); sheetInit();
	    doAction1("Search");
	  
	});
	
	$(function(){
	    $(".close").click(function() {
	    	self.close();
	    });
	    
	    $("#searchGubunCd").change(function() {
	    	doAction1("Search");
	    });
	});
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 		//조회
			sheet1.DoSearch( "<%=jspPath%>/yeaData/yearFeedbackPopupRst.jsp?cmd=selectYeaFeedbackPopupList", $("#sheetForm").serialize());
			break;
        case "Save":
        	sheet1.DoSave( "<%=jspPath%>/yeaData/yearFeedbackPopupRst.jsp?cmd=saveYeaFeedbackPopup", $("#sheetForm").serialize());
        	break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
    } 

	//조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1("Search");
			}
		} catch(ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
</script>

</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>담당자-임직원 FeedBack</li>
				<!--<li class="close"></li>-->
			</ul>
		</div>

        <div class="popup_main">
		    <form id="sheetForm" name="sheetForm">
			<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
			<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
			<input type="hidden" id="searchSabun" name="searchSabun" value="" />
			<input type="hidden" id="searchAuthPg" name="searchAuthPg" value="" />
			<input type="hidden" id="searchTemp" name="searchTemp" value="" />
		    <div class="sheet_search outer">
		        <div>
		        <table>
		        <tr>
		            <td>
		            	<span>구분</span>
		            	<select id="searchGubunCd" name="searchGubunCd">
		            	</select>
					</td>
		            <td>
		            	<a href="javascript:doAction1('Search')" class="button">조회</a>
		            </td>
		        </tr>
		        </table>
		        </div>
		    </div>
		    </form>
        
			<div class="inner">
				<div class="sheet_title">
				<ul>
		            <li class="txt">담당자-임직원 FeedBack</li>
		            <li class="btn">
		              <a href="javascript:doAction1('Save')" class="basic">저장</a>
		              <a href="javascript:doAction1('Down2Excel')" class="basic">다운로드</a>
		            </li>
		        </ul>
		        </div>    
			</div>
			
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
			<div class="popup_button outer">
				<ul>
					<li>
						<a href="javascript:self.close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div>
		</div>	
	</div>
</body>
</html>