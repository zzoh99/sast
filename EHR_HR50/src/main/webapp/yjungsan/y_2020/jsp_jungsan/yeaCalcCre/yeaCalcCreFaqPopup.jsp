<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산 패치현황</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");
    var patchSeq = "";
    
    $(function() {
        
    	 var arg = p.window.dialogArguments;
         //작업구분
         var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","YEA005"), "전체");           
         $("#inputCdType").html(adjustTypeList[2]).val("1");
         
         var searchWorkYy        = "";
         var searchAdjustType    = "";
         var searchCdType = "";
         var searchScrnType = "";
         
         if( arg != undefined ) {
             searchWorkYy        = arg["searchWorkYy"];
             searchAdjustType    = arg["searchAdjustType"];
             searchCdType    	 = arg["searchCdType"];
             searchScrnType    	 = arg["searchScrnType"];  
         }else{
             searchWorkYy      = p.popDialogArgument("searchWorkYy");
             searchAdjustType  = p.popDialogArgument("searchAdjustType");
             searchCdType  	   = p.popDialogArgument("searchCdType");
             searchScrnType    = p.popDialogArgument("searchScrnType");
         }
         
         $("#searchWorkYy").val(searchWorkYy);           
         $("#searchAdjustType").val(searchAdjustType);
		 $("#inputCdType").val(searchCdType);
		 if($("#inputCdType").val() > 0){
	   		$("#searchCdValue").val(2);	
 		 }else{
			$("#searchCdValue").val(1);	
		 }
		 if(searchScrnType == "y_ntstax"){
			 $("#strTitle").text("지급조서 오류유형");			 
		 }
         doAction1("Search");
                          
    });
    
    $(function(){
    	var initdata1 = {};
    	initdata1.Cfg = {SearchMode:smLazyLoad,Page:1000,MergeSheet:msAll};
    	initdata1.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
    	initdata1.Cols = [
    		{Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"삭제",		Type:"<%=removeXSS(sDelTy, '1')%>",	Hidden:1,Width:"<%=removeXSS(sDelWdt, '1')%>",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"<%=removeXSS(sSttTy, '1')%>",	Hidden:1,Width:"<%=removeXSS(sSttWdt, '1')%>",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"회사구분",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enter_cd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상년도",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",     KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"정산구분",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"업무코드",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"biz_cd",	    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"업무구분",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"biz_nm",      KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"순번",		Type:"Int",	    Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",	        KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"제목",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"title",	    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"답변",	    Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"reply",	    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"비고",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bigo",	    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"최종수정시간",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",	    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"최종수정자",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkid",	    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(0);
        
        sheet1.SetFocusAfterProcess(0);
        $(window).smartresize(sheetResize); sheetInit();
        
    });
    
    // 제목 검색
    $(function() {
		$("#searchTitle").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
			}
		});
	});
    
    // 조회
    function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcCreRst.jsp?cmd=selectFaqActionInList", $("#sheetForm1").serialize() );
			break;
		}
	}
    
	// 답변 setting
    function sheet2_set(){
		$("#title2").html( sheet1.GetCellValue(1, "title"));
		$("#biz_cd2").html(sheet1.GetCellText(1, "biz_nm"));
		$("#reply2").html( sheet1.GetCellValue(1, "reply"));
    }
    
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			if(Code == 1) {
				sheetResize(); 
				sheet2_set();
			}
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex);
		}
	}    
    
	// 셀이 선택 되었을때 발생한다
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow == NewRow || sheet1.GetCellValue(NewRow, "sStatus") == "I") return;
			// 답변 setting
			$("#title2").html( sheet1.GetCellValue(NewRow, "title"));
			$("#biz_cd2").html(sheet1.GetCellText(NewRow, "biz_nm"));
			$("#reply2").html( sheet1.GetCellValue(NewRow, "reply"));			
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	// 닫기 
    function faqPopupClose() {
    	p.self.close();
    }
	
	//조회조건 
	function selectOnChange(){
		
		var searchOpVaue = $("#inputType option:selected").val();

		if(searchOpVaue == "TIT"){
			$("#searchValue").val(2);
		}else if(searchOpVaue =="REP"){
			$("#searchValue").val(3);
		}else{
			$("#searchValue").val(1);
		}				
	}
	
	//업무구분
	function bizCdSelectOnChnage(){

		if($("#inputCdType").val() > 0){
			$("#searchCdValue").val(2);	
		}else{
			$("#searchCdValue").val(1);	
		}
		doAction1("Search");
	}
	
    $(function() {
		$("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
			}
		});
	});	
</script>

<style type="text/css">
    div.explain {margin: 0px !important;}
	.popup_main TABLE,TH,TD {margin: 0px; padding: 0px; border: 0px; font-size: 12px;}
	
</style>

</head>

<body class="bodywrap">
<form id="sheetForm1" name="sheetForm1" >  
<input type="hidden" id="searchWorkYy" name="searchWorkYy" value=""/>
<input type="hidden" id="searchAdjustType" name="searchAdjustType" value=""/>
<input type="hidden" id="searchValue" name="searchValue" value="1"/>
<input type="hidden" id="searchCdValue" name="searchCdValue" value="1"/>
	<div class="wrapper">
		<div class="popup_title">
		     <ul>
		         <li id="strTitle">연말정산 FAQ</li>
		     </ul>
	    </div>	
		<div class="outer popup_main">
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<td colspan="2">
								<span>업무구분 </span> 
								<select id="inputCdType" name ="inputCdType" onChange="javascript:bizCdSelectOnChnage()" class="box"></select> 
							</td>
							<td>
								<select id="inputType" name ="inputType" onChange="javascript:selectOnChange()" class="box">
							        <option value="All" selected>전체</option>
							        <option value="TIT">제목</option>
							        <option value="REP">답변</option>
								</select>
							</td>
							<td>
								<input id="searchKeyword" name ="searchKeyword" type="text" class="text" style="width:100px"/>
							</td>
							<td>
								<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
							</td>
							<td><p style="color: red"></p></td>
						</tr>
					</table>
				</div>			
			</div>
			</form>
			<div class="outer" >			
				<table border="0" cellspacing="0" cellpadding="0"  class="sheet_main">

					<tr>
						<td>
							<div class="sheet_title">
								<ul>
									<li class="txt">FAQ 내용</li>
									<li class="btn"></li>
								</ul>
							</div>									
						</td>

					</tr>
					<tr>
						<td>
							<script type="text/javascript"> createIBSheet("sheet1", "100%", "325px"); </script>
						</td>						
					</tr>	
					<tr>
						<td>
							<div class="inner">
							<table class="table" style="width: 100%" id="htmlTable">								
								<tr>
									<th>답변</th>
									<td>
										<div class="inner" id="reply2" style="width: 717px; height: 250px"></div> 
										<!--<textarea rows="15" id="reply2" style="margin: 0px; width: 717px; resize: none" disabled="disabled"></textarea>-->
									</td>
								</tr>
							</table>	
							</div>
						</td>
					</tr>
				</table>
		      	 <div class="popup_button"  style="clear: both;">
		         	 <ul>
		             	 <li><a href="javascript:faqPopupClose();" class="gray large">닫기</a></li>
		         	 </ul>
			   	</div>								
			</div>		
       </div>
	</div>

</body>
</html>