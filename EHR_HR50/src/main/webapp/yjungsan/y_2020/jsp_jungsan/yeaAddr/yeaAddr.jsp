<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산주소반영</title>
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
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,		SaveName:"sNo" },	
			{Header:"상태",			Type:"<%=sSttTy%>", Hidden:1,  						Width:"<%=sSttWdt%>", 	Align:"Center", ColMerge:0,   	SaveName:"sStatus" , Sort:0},
			{Header:"사번",			Type:"Text",		Hidden:0, 						Width:50,				Align:"Center",	ColMerge:1,		SaveName:"sabun",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"성명",			Type:"Text",		Hidden:0, 						Width:50,				Align:"Center",	ColMerge:1,		SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"부서명",		Type:"Text",		Hidden:0, 						Width:60,				Align:"Center",	ColMerge:1,		SaveName:"org_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"우편번호",		Type:"Text",		Hidden:0, 						Width:50,				Align:"Center",	ColMerge:1,		SaveName:"zip",				KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기본주소",		Type:"Text",		Hidden:0, 						Width:150,				Align:"Left",	ColMerge:1,		SaveName:"addr1",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"기본주소상세",	Type:"Text",		Hidden:0, 						Width:0,				Align:"Left",	ColMerge:1,		SaveName:"addr2",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"주소구분",		Type:"Text",		Hidden:1, 						Width:0,				Align:"Center",	ColMerge:1,		SaveName:"addType",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"선택",			Type:"CheckBox",  	Hidden:0,  						Width:30,    			Align:"Center",	ColMerge:1,   	SaveName:"chk",				KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:6 , TrueValue:"Y", FalseValue:"N" }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		// 작업구분
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "전체" );		
		// 주소구분
		var addTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "H20185"), "" );		
		
		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
		var bizPlaceCdList = "";
		
		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");	
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}    			
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
        $("#addType").html(addTypeList[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//doAction1("Search");
	});
	
	$(function() {
		$("#searchSbNm, #searchOrgNm").bind("keyup",function(event){
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
			sheet1.DoSearch( "<%=jspPath%>/yeaAddr/yeaAddrRst.jsp?cmd=selectYeaAddrList", $("#sheetForm").serialize() );
			break;
			
        case "Save":
        	
        	// 저장항목 선택여부
        	var checkYn = "N";
			var rowCnt = sheet1.RowCount();
			for (var i=1; i<=rowCnt; i++) {
				if (sheet1.GetCellValue(i, "chk") == "Y") {
					checkYn = "Y";
					// 주소구분 선택값 저장
					sheet1.SetCellValue(i, "addType", $("#addType").val());
				}
			}
			if (checkYn == "N") {
				alert("저장할 주소가 없습니다.");
				return;
			}
        	
        	if(confirm("저장하시겠습니까?")){
        		sheet1.DoAllSave("<%=jspPath%>/yeaAddr/yeaAddrRst.jsp?cmd=saveYeaAddrList", $("#sheetForm").serialize());
        	}
            break;
		
        case "Down2Excel":
			sheet1.Down2Excel();
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
	
    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            
            if(Code == 1) {
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>년도</span>
				<%
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				%>
					<input id="searchYear" name ="searchYear" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/> 
				<%}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/> 
				<%}%>				
				</td>				
				<td><span>작업구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
				</td>
				<td><span>부서명</span>
					<input id="searchOrgNm" name ="searchOrgNm" class="text" />
				</td>
                <td>
                    <span>급여사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')" ></select>
                </td>
				<td><span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
			</tr>
		</table>
		</div>
	</div>
	</form>
	
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">주소현황</li>
			<li class="btn">
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
				<a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
			</li>
			<li class="btn">
				<select id="addType" name="addType" class="box">
				</select>
			</li>			
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>