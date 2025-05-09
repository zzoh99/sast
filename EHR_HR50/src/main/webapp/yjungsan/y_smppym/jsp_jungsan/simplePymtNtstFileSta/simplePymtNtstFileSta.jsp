<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>간이지급명세서 신고파일확인</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ page import="yjungsan.util.DateUtil"%>

<script type="text/javascript">

	$(function() {
		
		/* 사업장 */
		var businessPlaceList = "";		
		businessPlaceList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBusinessPlaceList","",false).codeList, "전체");
		
		var searchYM = <%=curSysYear%>;
		
		/* 상반기 (2~7월) */
		if(<%=curSysMon%> > 1 && <%=curSysMon%> < 8){
			searchYM = searchYM +"06";
		}
		/* 하반기 (8~1월)*/
		else{
			if(<%=curSysMon%> == 1) {
				searchYM = searchYM - 1;
			}
			searchYM = searchYM + "12";
		}
		/* 근로소득 */
		var declClassList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+searchYM,"YEA003"), "선택");
		$("#declClass").html(declClassList[2]);
		
		
		/* default 현재달에 맞게 */
		var today = new Date();
		var mm = today.getMonth()+1;
		
		/* 상반기 (2~7월) */
		if(mm > 1 && mm < 8){
			$("#searchHalfType01").prop("selected", true);
		}
		/* 하반기 (8~1월)*/
		else{
			$("#searchHalfType02").prop("selected", true);
		}
		
		/* 년도 엔터키 검색 */
		$("#searchYear").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});
		
		/* 사번/성명 엔터키 검색 */
		$("#searchSabunNameAlias").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});
		
		/* 파일 종류 엔터키 검색 */
		$("#fileKind").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});
		
		/* 파일 항목 엔터키 검색 */
		$("#fileItem").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search");  $(this).focus(); }
		});

		$("#declYmdTemp").datepicker2();
		
		/* 제출일자 */
		$("#declYmdTemp").val("<%=curSysYyyyMMddHyphen%>");

        /* 현재년도 */
		$("#searchYear").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy")%>") ;

		/* 사업장 */
	    sheet1.SetColProperty("business_place_cd", 		{ComboText:"|"+businessPlaceList[0], ComboCode:"|"+businessPlaceList[1]} );
		$("#searchBusinessPlace").html(businessPlaceList[2]);


        $(window).smartresize(sheetResize); sheetInit();
 
		doAction1("Search");
	});

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
	        case "Search": 
	        	
	        	sheet1.Reset(); 
	        	sheet2.Reset(); 
	        	
	        	var initdata0 = {};
	    		initdata0.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:2};
	    		initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	    		initdata0.Cols = [
	                    {Header:"No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
	    				{Header:"사번",		    Type:"Text",      	Hidden:1,  	Width:60,	Align:"Center",    	ColMerge:0,   	SaveName:"sabun",   	KeyField:0,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
	    				{Header:"성명",  			Type:"Text",		Hidden:1,  	Width:70,   Align:"Center",		ColMerge:0,   	SaveName:"name",		KeyField:0,   	CalcLogic:"",   Format:"",      	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
	    				
	    				{Header:"컬럼명",  		Type:"Text",		Hidden:1,  	Width:70,   Align:"Center",		ColMerge:0,   	SaveName:"element_nm",	KeyField:0,   	CalcLogic:"",   Format:"",      	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
	    				];
	    		IBS_InitSheet(sheet1, initdata0);
	    		sheet1.SetEditable("<%=editable%>");
	    		sheet1.SetVisible(true);
	    		sheet1.SetCountPosition(4);

	        	sheet1.DoSearch( "<%=jspPath%>/simplePymtNtstFileSta/simplePymtNtstFileStaRst.jsp?cmd=getSimplePymtNtstFileSta01", $("#mySheetForm").serialize() ); 
	        	break;
	        case "Search2":   
	        	sheet2.DoSearch( "<%=jspPath%>/simplePymtNtstFileSta/simplePymtNtstFileStaRst.jsp?cmd=getSimplePymtNtstFileSta02", $("#mySheetForm").serialize() ); 
        	break;	
	        
        }
    }

    

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
				if (Msg != ""){ 
					alert(Msg); 
				}

				var totalCnt = sheet1.LastRow();
				var elementArr = new Array();
				
				for(var i=1; i <= totalCnt; i++){
					elementArr[i] =  sheet1.GetCellValue(i, "element_nm") ;
				}

				var initdata0 = {};
				initdata0.Cfg = {SearchMode:smLazyLoad,Page:22};
				initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
				initdata0.Cols = [
		                {Header:"No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
						{Header:"사번",		    Type:"Text",      	Hidden:0,  	Width:60,	Align:"Center",    	ColMerge:0,   	SaveName:"sabun",   KeyField:0,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
						{Header:"성명",  			Type:"Text",		Hidden:0,  	Width:70,   Align:"Center",		ColMerge:0,   	SaveName:"name",	KeyField:0,   	CalcLogic:"",   Format:"",      	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
						];
				
				if(totalCnt > 0){

					var initdata0 = {};
					initdata0.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:3};
					initdata0.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
					initdata0.Cols = [
			                {Header:"No",			Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
							{Header:"사번",		    Type:"Text",      	Hidden:0,  	Width:60,	Align:"Center",    	ColMerge:0,   	SaveName:"sabun",   KeyField:0,   	CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
							{Header:"성명",  			Type:"Text",		Hidden:0,  	Width:70,   Align:"Center",		ColMerge:0,   	SaveName:"name",	KeyField:0,   	CalcLogic:"",   Format:"",      	PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:500 },
							
							];
					
					for(var i=1; i <= totalCnt; i++){
						initdata0.Cols.push( {Header:elementArr[i] , Type:"Text", MinWidth:80, SaveName: "key_"+i, UpdateEdit:0} );
					}
				}
				
				IBS_InitSheet(sheet2, initdata0);
				sheet2.SetEditable("<%=editable%>");
				sheet2.SetVisible(true);
				sheet2.SetCountPosition(4);
				
				doAction1("Search2");
				
				sheetResize(); 
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
				if (Msg != ""){ 
					alert(Msg); 
				}
				
				sheetResize(); 
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<%-- <%@ include file="/WEB-INF/jsp/common/include/employeeHeaderYtax.jsp"%> --%>

    <div class="sheet_search outer">
    <form id="mySheetForm" name="mySheetForm" >
    <input type="hidden" id="searchSabun" 		name="searchSabun" 		value ="" />
        <div>
        <table>
        <tr>
            <td><span style="margin-right: 2px; padding-left: 21px;">년도</span>
			<input id="searchYear" name ="searchYear" type="text" class="text" maxlength="4" style= "width:65px; padding-left: 35px;"/> </td>
			<td><span>반기구분</span>
				<select id="searchHalfType" name="searchHalfType" onChange="javascript:doAction1('Search')" style="width: 119px;">
	                <option selected="selected" value="">전체</option>
	                <option value="1" id="searchHalfType01">상반기</option>
	                <option value="2" id="searchHalfType02">하반기</option>
	            </select>
			</td>
			<td><span style="margin-right: 1px; padding-left: 11px;">사업장</span>
				<select id="searchBusinessPlace" name ="searchBusinessPlace" onChange="javascript:doAction1('Search')" class="box" style= "width:101px;"></select> 
			</td>
			<td><span>사번/성명</span> 
				<input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text"  style= "width:100px;"/>
			</td>
        </tr>
        <tr>
            <td><span>제출일자</span>
			<input id="declYmdTemp" name ="declYmdTemp" type="text" class="text" maxlength="4" style= "width:80px;"/> </td>
			<td><span>소득구분</span>
				<select id="declClass" name="declClass" style="width: 119px;"> </select>
			</td>
			<td><span>파일종류</span>
			<input id="fileKind" name ="fileKind" type="text" class="text" maxlength="4" style= "width:100px;"/> </td>
			<td><span style="margin-right: -1px; padding-left: 5px;">파일항목</span>
			<input id="fileItem" name ="fileItem" type="text" class="text" maxlength="4" style= "width:101px;"/> </td>
            <td><a href="javascript:doAction1('Search');" class="button">조회</a></td>
        </tr>
        </table>
        </div>
    </form>
    </div>
   
	     

    <script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
    	<tr class="hide">
         <td>
             <script type="text/javascript">createIBSheet("sheet1", "0%", "0%", "kr"); </script>
         </td>
     </tr>

</div>
</body>
</html>