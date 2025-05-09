<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>의료비내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	
	$(function() {
		$("#searchYear").val("<%=yeaYear%>") ;
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,		SaveName:"sNo" },	
			{Header:"상태",			Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,			Width:"<%=sSttWdt%>",	Align:"Center", ColMerge:1, 	SaveName:"sStatus", Sort:0 },
			{Header:"사번",			Type:"Text",		Hidden:0, 						Width:60,				Align:"Center",	ColMerge:1,		SaveName:"sabun",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"성명",			Type:"Text",		Hidden:0, 						Width:70,				Align:"Center",	ColMerge:1,		SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"부서명",			Type:"Text",		Hidden:0, 						Width:90,				Align:"Center",	ColMerge:1,		SaveName:"org_nm",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"우편번호",		Type:"Text",		Hidden:0, 						Width:70,				Align:"Center",	ColMerge:1,		SaveName:"zip",				KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기본주소",		Type:"Text",		Hidden:0, 						Width:80,				Align:"Center",	ColMerge:1,		SaveName:"addr1",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"기본주소상세",		Type:"Text",		Hidden:0, 						Width:0,				Align:"Center",	ColMerge:1,		SaveName:"addr2",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"회사코드",		Type:"Text",		Hidden:1, 						Width:0,				Align:"Center",	ColMerge:1,		SaveName:"enter_cd",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList", "C00303"), "" );		
		var medicalImpCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00308"), "");
		var restrictCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00340"), "");
		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "전체");
		var orgCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=orgList",""), "전체");
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetColProperty("adj_input_type",	{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		
		$("#searchAdjustType").html(adjustTypeList[2]);
		$("#searchInputType").html(adjInputTypeList[2]);
		$("#orgCd").html(orgCd[2]);
		// 사업장
        var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");
        
        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//doAction1("Search");
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
			sheet1.DoSearch( "<%=jspPath%>/yeaAddr/yeaAddrRst.jsp?cmd=selectYeaAddrList", $("#sheetForm").serialize() );
			break;
			
        case "Save":
        	$("#paramAddrGubun").val($("#addrGubun option:selected").val());
        	if(confirm("저장하시겠습니까")){
        		sheet1.DoAllSave( "<%=jspPath%>/yeaAddr/yeaAddrRst.jsp?cmd=saveYeaAddrList", $("#sheetForm").serialize());	
        	}        	
            break;
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			
			if (Code == 1) {
				for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
					if (sheet1.GetCellValue(i, "adj_input_type") == "07") { //PDF
						sheet1.SetRowEditable(i, 0);
					}
				}
			}
			
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
	<input type="hidden" id="paramAddrGubun" name="paramAddrGubun" value=""/>
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>년도</span>
				<input id="searchYear" name ="searchYear" type="text" class="text readonly" maxlength="4" style="width:35px" readonly/> </td>
				
				<td><span>작업구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select> 
				</td>
				<td><span>부서명</span>
					<select id="orgCd" name ="orgCd" class="box"></select> 
				</td>
                <td>
                    <span>급여사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box"></select>
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
				<select id="addrGubun" name="addrGubun" class="box">
					<option value="1">본적</option>
					<option value="2">주민등록증</option>
					<option value="3">현거주지</option>
				</select>
			</li>
			<li class="btn">
				<a href="javascript:doAction1('Save');" class="basic authA">저장</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>