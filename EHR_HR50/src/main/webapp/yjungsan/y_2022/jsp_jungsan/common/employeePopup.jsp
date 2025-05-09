<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>임직원 팝업</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");

	$(function() {
		var arg = p.window.dialogArguments;

		//배열 선언
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",		Hidden:0,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"사번",			Type:"Text",			Hidden:0,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"sabun", 	UpdateEdit:0 },
			{Header:"성명",			Type:"Text",			Hidden:0,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"name", 	UpdateEdit:0 },
			{Header:"부서",			Type:"Text",			Hidden:0,	Width:200,				Align:"Left",	ColMerge:0,	SaveName:"org_nm", 		UpdateEdit:0 },
			{Header:"직책",			Type:"Text",			Hidden:0,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"jikchak_nm", 	UpdateEdit:0 },
			{Header:"직위",			Type:"Text",			Hidden:0,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"jikwee_nm", 	UpdateEdit:0 },
			{Header:"재직\n상태",		Type:"Text",			Hidden:0,	Width:45,				Align:"Center",	ColMerge:0,	SaveName:"status_nm", 	UpdateEdit:0 }

		];IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);

		$(window).smartresize(sheetResize);
		sheetInit();
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
			if( ( $.trim( $("#searchKeyword").val( )) ) == "" ){
					alert("성명 또는 사번을 입력하세요.");
				$("#searchKeyword").focus();
			}else{
			    sheet1.DoSearch( "<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectList&queryId=getEmployeeList", $("#srchFrm").serialize() );
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

    	var returnValue = new Array(26);
    	$("#searchUserId").val(sheet1.GetCellValue(Row,"sabun"));

    	var user = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap&queryId=getEmployeeDetailList",$("#srchFrm").serialize(),false);

    	if(user.Message != null && user.Message.length > 0) {
    		alert(user.Message);
    		return;
    	}

    	if(user.Data != null && user.Data != "undefine")
    		user = user.Data;

    	returnValue["sabun"] 			= user.sabun;
 		returnValue["name"] 				= user.name;
 		returnValue["jikchak_cd"] 		= user.jikchak_cd;
 		returnValue["jikchak_nm"] 		= user.jikchak_nm;
 		returnValue["jikwee_cd"] 		= user.jikwee_cd;
 		returnValue["jikwee_nm"] 		= user.jikwee_nm;
 		returnValue["jikgub_cd"] 		= user.jikgub_cd;
 		returnValue["jikgub_nm"] 		= user.jikgub_nm;
		returnValue["manage_cd"]		= user.manage_cd;
		returnValue["manage_nm"]		= user.manage_nm;
 		returnValue["work_type"] 		= user.work_type;
 		returnValue["work_type_nm"] 	= user.work_type_nm;
		returnValue["org_cdd"]    		= user.org_cdd;
		returnValue["org_nm"]    		= user.org_nm;
		returnValue["status_cd"]		= user.status_cd;
		returnValue["status_nm"]		= user.status_nm;
		returnValue["job_cd"]			= user.job_cd;
		returnValue["job_nm"]			= user.job_nm;
		returnValue["location_cd"]		= user.location_cd;
		returnValue["res_no"]			= user.res_no;
		returnValue["business_place_cd"]= user.business_place_cd;

		//p.window.returnValue = returnValue;
		if(p.popReturnValue) p.popReturnValue(returnValue);
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>사원조회</li>
                <!--<li class="close"></li>-->
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
                <input type="hidden" id="searchEnterCd" name="searchEnterCd" value=""/>
                <input type="hidden" id="searchStatusCd" name="searchStatusCd" value="RA"/>
                <input type="hidden" id="searchUserId" name="searchUserId" />
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                        <td> <span>성명/사번</span> <input id="searchKeyword" name ="searchKeyword" type="text" class="text" /> </td>
                        <td> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('RA');" checked="checked" type="radio"  class="radio"/> 퇴직자 제외</td>
                        <td> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('A');" type="radio" class="radio"/> 퇴직자 포함</td>
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