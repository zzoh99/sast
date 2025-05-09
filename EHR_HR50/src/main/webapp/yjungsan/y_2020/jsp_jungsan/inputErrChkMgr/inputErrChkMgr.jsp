<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기부금내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">

	$(function() {
		$("#searchYear").val("<%=yeaYear%>") ;
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"대상년도",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"사번",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"성명",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"구분",		Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"chk_gubun",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"내용",		Type:"Text",		Hidden:0,	Width:170,	Align:"Left",	ColMerge:0,	SaveName:"chk_text",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"결과유형",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chk_type",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"순서",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//결과유형
        //var chkTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "R20070"), "전체" );		
		    var chkTypeList = new Array(3);
		    chkTypeList[0] = "경고|오류|확인";
		    chkTypeList[1] = "W|E|L";
		    chkTypeList[2] = "<option value=''>전체</option>"
		    								+ "<option value='W'>경고</option>"
		    								+ "<option value='E'>오류</option>"
		    								+ "<option value='L'>확인</option>"
		    ;
		    
        sheet1.SetColProperty("chk_type",    {ComboText:"|"+chkTypeList[0], ComboCode:"|"+chkTypeList[1]} );
		
		$("#searchResultType").html(chkTypeList[2]);

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
        
		doAction1("Search");
	});
	
	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus(); 
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/inputErrChkMgr/inputErrChkMgrRst.jsp?cmd=selectInputErrChkMgrList", $("#sheetForm").serialize() ); 
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize(); 
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}

	//오류검증항목 팝업
	function openInputErrChkMgrPopup() {
		//년도 체크(필수 파라매터)
		if($("#searchYear").val() == "") {
			alert("년도를 입력하여 주십시오.") ;
			return;
		} else if($("#searchYear").val().length != 4) {
			alert("년도를 확인하여 주십시오.") ;
			return;			
		}
		
	    try{
			var args    = new Array();
			args["searchYear"] = $("#searchYear").val() ;
			
			if(!isPopup()) {return;}
			var rv = openPopup("<%=jspPath%>/inputErrChkMgr/inputErrChkMgrPopup.jsp?authPg=<%=authPg%>", args, "740","520");
	    } catch(ex){
	    	alert("Open Popup Event Error : " + ex);
	    }
	}
	
	//오류 검증
	function getErrorCheck(){
	    if(confirm("오류검증 실행시 기존 오류검증 내용이 삭제 됩니다. \n실행 하시겠습니까?")){
			ajaxCall("<%=jspPath%>/inputErrChkMgr/inputErrChkMgrRst.jsp?cmd=prcInputErrChkMgr",$("#sheetForm").serialize()
					,true
					,function(){
						$("#progressCover").show();
					 }
					,function(){
						$("#progressCover").hide();
			    		doAction1("Search");
					}
			);
	    }
	}
</script>
</head>
<body class="bodywrap">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
	<input id="searchAdjustType" name ="searchAdjustType" type="hidden" value="1"/> </td>
	<input id="searchSabun" name ="searchSabun" type="hidden" value=""/> </td>
    <div class="sheet_search outer">
        <div>
        <table>
			<tr>
			    <td>
			    	<span>년도</span>
					<%
					if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
					%>
						<input id="searchYear" name ="searchYear" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/>
					<%}else{%>
						<input id="searchYear" name ="searchYear" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/>
					<%}%>			    						
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onchange="javascript:doAction1('Search')"></select>
                </td>
				<td>
					<span>사번/성명</span>
					<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
				</td>
				<td>
					<span>결과유형</span>
					<select id="searchResultType" name ="searchResultType" onChange="doAction1('Search')" class="box"></select> 
				</td>
				<td>
					<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
				</td>
			</tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">공제자료오류검증</li>
            <li class="btn">
				<a href="javascript:openInputErrChkMgrPopup()" 	class="basic authA">오류검증항목 보기</a>
				<a href="javascript:getErrorCheck()" 			class="basic authA">오류검증</a>
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>