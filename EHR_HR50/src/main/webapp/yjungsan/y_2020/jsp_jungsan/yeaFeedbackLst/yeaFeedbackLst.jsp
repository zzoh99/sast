<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>담당자 FeedBack 내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">

	$(function() {	
		$("#searchWorkYy").val("<%=yeaYear%>");
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
   			{Header:"No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
   			{Header:"상태",			Type:"<%=sSttTy%>", Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"대상연도", 		Type:"Text",     	Hidden:1, 	Width:50,	Align:"Center",    	ColMerge:0, SaveName:"work_yy",  		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
            {Header:"정산구분", 		Type:"Combo",     	Hidden:0,  	Width:60,  	Align:"Center",    	ColMerge:0, SaveName:"adjust_type",  	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"부서명", 			Type:"Text",     	Hidden:0,  	Width:70,  	Align:"Center",    	ColMerge:1, SaveName:"org_nm",  		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"성명", 			Type:"Text",     	Hidden:0,  	Width:60,  	Align:"Center",    	ColMerge:1, SaveName:"name",  			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사번", 			Type:"Text",     	Hidden:0, 	Width:60,  	Align:"Center",    	ColMerge:1, SaveName:"sabun",  			KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"전체내역",		Type:"Image",     	Hidden:0,  	Width:50,   Align:"Center",		ColMerge:1,	SaveName:"detail_popup",    KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"Pointer" },
            {Header:"구분", 			Type:"Combo",    	Hidden:0,  	Width:80,  	Align:"Center",    	ColMerge:0, SaveName:"gubun_cd",  		KeyField:1,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"구분명", 			Type:"Combo",    	Hidden:1,  	Width:80,  	Align:"Center",    	ColMerge:1, SaveName:"gubun_nm",		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:35 },
            {Header:"미선택",			Type:"Int",     	Hidden:0, 	Width:60,  	Align:"Center",    	ColMerge:0, SaveName:"cnt_0",  			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"확인완료",		Type:"Int",     	Hidden:0, 	Width:60,  	Align:"Center",    	ColMerge:0, SaveName:"cnt_1",  			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"확인중",			Type:"Int",     	Hidden:0, 	Width:60,  	Align:"Center",    	ColMerge:0, SaveName:"cnt_2",  			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"서류미비",		Type:"Int",     	Hidden:0, 	Width:60,  	Align:"Center",    	ColMerge:0, SaveName:"cnt_3",  			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"공제대상아님",		Type:"Int",     	Hidden:0, 	Width:70,  	Align:"Center",    	ColMerge:0, SaveName:"cnt_4",  			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"입력오류",		Type:"Int",     	Hidden:0, 	Width:60,  	Align:"Center",    	ColMerge:0, SaveName:"cnt_5",  			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"기타",			Type:"Int",     	Hidden:0, 	Width:50,  	Align:"Center",    	ColMerge:0, SaveName:"cnt_6",  			KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"답변여부", 		Type:"Combo",     	Hidden:0,  	Width:60,  	Align:"Center",    	ColMerge:1, SaveName:"reply_yn",  		KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20, DefaultValue:"N" },
            {Header:"담당자멘트",		Type:"Text",     	Hidden:0,  	Width:200,  Align:"Left",    	ColMerge:1, SaveName:"manager_note",  	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:1,	InsertEdit:1,   EditLen:1000, MultiLineText:1 },
            {Header:"직원멘트",		Type:"Text",     	Hidden:0,  	Width:200,  Align:"Left",    	ColMerge:1, SaveName:"employee_note",  	KeyField:0,   CalcLogic:"",   Format:"",    PointCount:0,   UpdateEdit:0,	InsertEdit:0,   EditLen:1000, MultiLineText:1 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		
		
		// 이전 피드백 리스트
        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};                                                                                                                                                                                              
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};                                                                                                                                                                          
        initdata2.Cols = [                                                                                                                                                                                                                            
   			{Header:"No",		        Type:"Seq",			Hidden:0,	Width:45,	Align:"Center",		ColMerge:1,	SaveName:"sNo" },
            {Header:"사번", 				Type:"Text",     	Hidden:1, 	Width:50,  	Align:"Center",    	ColMerge:1, SaveName:"sabun",  			KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:13 },
            {Header:"구분", 				Type:"Combo",    	Hidden:0,  	Width:80,  	Align:"Center",    	ColMerge:1, SaveName:"gubun_cd",  		KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   				InsertEdit:0,   EditLen:35 },
            {Header:"문의일시",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,	SaveName:"employee_chkdate",KeyField:0,	  CalcLogic:"",   Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
            {Header:"답변일시",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,	SaveName:"manager_chkdate",KeyField:0,	  CalcLogic:"",   Format:"YmdHms",PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
            {Header:"담당자 FeedBack",		Type:"Text",     	Hidden:0,  	Width:200,  Align:"Left",    	ColMerge:1, SaveName:"manager_note",  	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,	InsertEdit:0,   EditLen:1000, MultiLineText:1 },
            {Header:"직원 FeedBack",   	Type:"Text",     	Hidden:0,  	Width:200,  Align:"Left",    	ColMerge:1, SaveName:"employee_note", 	KeyField:0,   CalcLogic:"",   Format:"",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000, MultiLineText:1 }
            
        ];IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(false);sheet2.SetCountPosition(0);
		
		
		sheet1.SetImageList(0,"<%=imagePath%>/icon/icon_info.png");
		
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "전체");
		var appTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");

	    var comboText = ["전체","일반","연금","보험료","의료비","교육비","주택자금","기부금","주택/증권저축","신용카드","기타"];
        var comboCode = ["","COMM","PENS","INSU","MEDI","EDUC","RENT","DONA","HOUS","CARD","ETCC"];

		sheet1.SetColProperty("gubun_cd", {ComboText:comboText.join("|") , ComboCode:comboCode.join("|")} );
		sheet1.SetColProperty("gubun_nm", {ComboText:comboText.join("|") , ComboCode:comboCode.join("|")} );
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetSendComboData(0,"gubun_nm","Text");
		sheet1.SetColProperty("reply_yn", {ComboText:"답변완료|미답변", ComboCode:"Y|N"} );
		
		sheet2.SetColProperty("gubun_cd", {ComboText:comboText.join("|") , ComboCode:comboCode.join("|")} );
		sheet2.SetFocusAfterProcess(0);
		
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		$("#searchSuccessType").html("<option value=''>전체</option><option value='0'>미선택</option>"+appTypeList[2]);

		$(comboCode).each(function(index){
			var option = "<option value='"+comboCode[index]+"'>"+comboText[index]+"</option>";
			$("#searchGubunCd").append(option);
		});

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		var bizPlaceCdList = "";
		
		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");	
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}			

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});
	
	$(function() {
		$("#searchWorkYy").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ 
				doAction1('Search'); 
			}
		});
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1('Search');
			}
		});
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if($("#searchWorkYy").val() == "" || $("#searchWorkYy").val().length < 4) { 
				alert("년도를 입력하여 주십시오.");
				return;
			}
			sheet1.DoSearch( "<%=jspPath%>/yeaFeedbackLst/yeaFeedbackLstRst.jsp?cmd=selectYeaFeedbackLstList", $("#sheetForm").serialize() );
			break;
		case "Save": 		
			sheet1.DoSave( "<%=jspPath%>/yeaFeedbackLst/yeaFeedbackLstRst.jsp?cmd=saveYeaFeedback"); 
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
        case "Down2Template":
			var param  = {DownCols:"5|6|8|18",SheetDesign:1,Merge:1,DownRows:"0",ExcelFontSize:"9"
				,TitleText:"",UserMerge :0};
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
        	
        	if(chkRqr()){
	       		 break;
	       	}
        	
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params); 
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
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}

	//클릭시 발생.
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail_popup"){
		    	openFeedbackPopup(Row) ;
		    }
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	//Feedback 팝업
	function openFeedbackPopup(Row) {
		var workYy = sheet1.GetCellValue(Row,"work_yy");
		var adjustType = sheet1.GetCellValue(Row,"adjust_type");
		var sabun = sheet1.GetCellValue(Row,"sabun");
		
		var $form = $('<form></form>');
		$form.attr('method', 'post');
		$form.appendTo('body');
		
		var w 		= 1000;
		var h 		= 700;
		/*
		var workYy = $('<input name="workYy" type="hidden" value="'+ workYy +'">');
		var adjustType = $('<input name="adjustType" type="hidden" value="'+ adjustType +'">');
		var sabun = $('<input name="sabun" type="hidden" value="'+ sabun +'">');
		var authPg = $('<input name="authPg" type="hidden" value="A">');
		$form.append(workYy).append(adjustType).append(sabun).append(authPg);
		*/
		$form.attr('target', 'feedbackPopup');
		$form.attr('action', '<%=jspPath%>/yeaData/yeaFeedbackPopup.jsp?workYy='+ workYy +'&adjustType='+ adjustType +'&sabun='+ sabun +'&authPg=A');
		
		var top = 10;
		var left = 10;
		var Popup = window.open("", "feedbackPopup", "width="+ w +",height="+ h +",scrollbars=yes,resizable=yes, top="+ top +", left="+ left +"");
		Popup.focus();
		
		$form.submit();
	}
	
	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				doAction1('Search'); 
			}
		} catch(ex) { 
			alert("OnSaveEnd Event Error " + ex); 
		}
	}
	
	//업로드 완료후 호출
    function sheet1_OnLoadExcel(result) {
        try {
        	if(sheet1.RowCount() != 0) {
        		var searchWorkYy     = $("#searchWorkYy").val();
        		var searchAdjustType = $("#searchAdjustType").val();
        		
	        	for(var i = 1; i < sheet1.RowCount()+1; i++) {
					sheet1.SetCellValue(i,"work_yy",searchWorkYy);
					sheet1.SetCellValue(i, "adjust_type", searchAdjustType);
					sheet1.SetCellValue(i, "gubun_nm", sheet1.GetCellValue(i, "gubun_cd"));
				}
        	}
        } catch(ex) { 
            alert("OnLoadExcel Event Error " + ex); 
        }
	}
	
  	//클릭시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			
			if(OldRow != NewRow){
				var param = "searchWorkYy="+sheet1.GetCellValue(NewRow, "work_yy")
				+"&searchAdjustType="+sheet1.GetCellValue(NewRow, "adjust_type")
				+"&searchSabun="+sheet1.GetCellValue(NewRow, "sabun")
				+"&searchGubunCd="+sheet1.GetCellValue(NewRow, "gubun_cd");
		
				sheet2.DoSearch( "<%=jspPath%>/yeaData/yearFeedbackPopupRst.jsp?cmd=selectYeaFeedbackPopupHisList", param, 1 );
			}
			
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>년도 </span>
							<%
							if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
							%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text w40 readonly" maxlength="4" readonly/>
							<%}else{%>
								<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text w40 readonly" maxlength="4" readonly/>
							<%}%>							
						</td>
						<td>
							<span>작업구분</span>
							<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')">
							</select> 
						</td>
						<td>
							<span>자료구분</span>
							<select id="searchGubunCd" name ="searchGubunCd">
							</select> 
						</td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>
							<span>담당자확인</span>
							<select id="searchSuccessType" name ="searchSuccessType">
							</select> 
						</td>
		                <td>
		                    <span>사업장</span>
		                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onchange="javascript:doAction1('Search')"></select>
		                </td>
		                <td>
		                	<span>답변여부</span>
							<select id="searchReplyYn" name ="searchReplyYn">
								<option value="">전체</option>
								<option value="Y">답변완료</option>
								<option value="N">미답변</option>
							</select> 
		                </td>
						<td>
							<span>사번/성명 </span>
							<input id="searchSbNm" name ="searchSbNm" type="text" class="text w90"/>
						</td>
						<td> 
							<a href="javascript:doAction1('Search')" class="button">조회</a>
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
							<li id="txt" class="txt">담당자 FeedBack 내역관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Template')" class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
								<a href="javascript:doAction1('Save')" 			class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%"); </script>
			</td>
		</tr>
		
		<tr>
			<td>
			</td>
		</tr>
		
	</table>
	
	<!-- 이전 피드백 Start -->
    <div class="inner">
		<div class="sheet_title">
			<ul>
	            <li class="txt">이전 FeedBack</li>
	        </ul>
	     </div>
	     <script type="text/javascript">createIBSheet("sheet2", "100%", "30%"); </script>
	</div>
	<!-- 이전 피드백 End -->
	
</div>
</body>
</html>