<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>임직원 팝업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%String ownerOnlyYn = request.getParameter("ownerOnlyYn");%>
<%String earnerCd = request.getParameter("earnerCd");%>
<%String searchName = request.getParameter("searchName");%>

<script type="text/javascript">
	var ownerOnlyYn = "<%=removeXSS(ownerOnlyYn, '1')%>";
	var earnerCd = "<%=removeXSS(earnerCd, '1')%>";
	var searchName = "<%=searchName%>";
	var p = eval("<%=popUpStatus%>");
	
	$(function() {
		var arg = p.window.dialogArguments;

		//배열 선언				
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",		Hidden:0,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"사업장",		Type:"Combo",			Hidden:0,	Width:20,				Align:"Center",	ColMerge:0,	SaveName:"business_place_cd", 	UpdateEdit:0 },
 			{Header:"사번",			Type:"Text",			Hidden:0,	Width:20,				Align:"Center",	ColMerge:0,	SaveName:"sabun", 	UpdateEdit:0 },
			{Header:"성명",			Type:"Text",			Hidden:0,	Width:30,				Align:"Center",	ColMerge:0,	SaveName:"name", 	UpdateEdit:0 },
			{Header:"주민번호",		Type:"Text",			Hidden:0,	Width:30,				Align:"Center",	ColMerge:0,	SaveName:"res_no", 	UpdateEdit:0  , Format:"IdNo"},
			{Header:"재직상태",		Type:"Text",			Hidden:0,	Width:30,				Align:"Center",	ColMerge:0,	SaveName:"status_nm", 	UpdateEdit:0 },
 			{Header:"임직원\n구분",	Type:"CheckBox",		Hidden:0,	Width:40,				Align:"Center",	ColMerge:0,	SaveName:"employee_yn", UpdateEdit:0, TrueValue:"Y", FalseValue:"N" }
		];IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);
		
		// 사업장(TCPN121)
		var bizPlaceCd = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList", "getBizPlaceCdList") , "");
		sheet1.SetColProperty("business_place_cd", {ComboText:"|"+bizPlaceCd[0], ComboCode:"|"+bizPlaceCd[1]});
		
		$(window).smartresize(sheetResize);
		sheetInit();
		
		if(ownerOnlyYn == "Y") {
			$("#chkArea1").hide();
			$("#chkArea2").hide();
		}
		
		$("#searchEarnerCd").val(earnerCd);
		if(searchName != "") {
			$("#searchKeyword").val(searchName);
			doAction("Search");
		}
		
		//doAction("Search");
	});
	
	$(function() {
		$("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction("Search");
			}
		});

		$(".close").click(function() {
			p.self.close();
		});
	});
	
	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": //조회
			if($("#searchStatusCd").val() != "X" && $("#searchKeyword").val() == "") {
				alert("성명 또는 사번을 입력하세요.");
				$("#searchKeyword").focus();
			} else {
				sheet1.DoSearch( "<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectList&queryId=getOwnerList", $("#srchFrm").serialize() );	
			}
			break;
		}
    } 
	
	// 	조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			alertMessage(Code, Msg, StCode, StMsg);
			if(sheet1.RowCount() == 0) {
				//alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
			}
			sheet1.FocusAfterProcess = false;
			setSheetSize(sheet1);
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//높이 또는 너비가 변경된 경우 각 컬럼의 너비를 새로 맞춘다.
	//setSheetSize(sheet1);   
	function sheet1_OnResize(lWidth, lHeight) {
		try {
			setSheetSize(sheet1);
		} catch (ex) {
			alert("OnResize Event Error : " + ex);
		}
	}
	
	function sheet1_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		} catch(ex){
			alert("OnDblClick Event Error : " + ex);
		} finally{
			p.self.close();; 
		}
	}
	
	function returnFindUser(Row,Col){
	    if( sheet1.GetCellValue(1,0) == undefined ) {
	         alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
	        return;
	    }
	    if(sheet1.RowCount() <= 0) {
	      alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
	      return;
	    }
	    
    	var returnValue = new Array(5);
    	$("#searchUserId").val(sheet1.GetCellValue(Row,"sabun"));
    	
    	var user = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap&queryId=getOwnerDetailList",$("#srchFrm").serialize(),false);
    	
    	if(user.Message != null && user.Message.length > 0) {
    		alert(user.Message);
    		return;
    	}
    	
    	if(user.Data != null && user.Data != "undefine") 
    		user = user.Data;
    	
    	returnValue["sabun"] 			= user.sabun;
 		returnValue["name"] 			= user.name;
		returnValue["res_no"]			= user.res_no;
		returnValue["business_place_cd"]= user.business_place_cd;
		returnValue["earner_type"]		= user.earner_type;
		returnValue["regino"]			= user.regino;
		returnValue["earner_nm"]		= user.earner_nm;
		returnValue["earner_eng_nm"]	= user.earner_eng_nm;
		returnValue["citizen_type"]		= user.citizen_type;
		returnValue["residency_type"]	= user.residency_type;
		returnValue["residence_cd"]		= user.residence_cd;
		returnValue["bi_name_yn"]		= user.bi_name_yn;
		returnValue["addr"]				= user.addr;
		returnValue["bank_cd"]			= user.bank_cd;
		returnValue["account_no"]		= user.account_no;
		
		//p.window.returnValue = returnValue;
		if(p.popReturnValue) p.popReturnValue(returnValue);
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>임직원조회</li>
                <!--<li class="close"></li>-->
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
                <input type="hidden" id="searchEnterCd" name="searchEnterCd" value=""/> 
                <input type="hidden" id="searchStatusCd" name="searchStatusCd" value="A"/>
                <input type="hidden" id="searchUserId" name="searchUserId" />
                <input type="hidden" id="searchEarnerCd" name="searchEarnerCd" />  
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                        <td> <span>성명/사번</span> <input id="searchKeyword" name ="searchKeyword" type="text" class="text" /> </td>
                        <td id = "chkArea1"> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('X');" type="radio"  class="radio"/> 임직원 제외</td>
                        <td id = "chkArea2"> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('A');" checked="checked" type="radio" class="radio"/> 임직원 포함</td>
                        <td>
                            <a href="javascript:doAction('Search')" id="btnSearch" class="button">조회</a>
                        </td>
                    </tr>
                    </table>
                    </div>
                </div>
            
	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">사원조회</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

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