<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>영유아지원금 자녀 조회 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var srchBizCd = null;
	var p = eval("${popUpStatus}");
	/*Sheet 기본 설정 */
	$(function() {
		var arg = p.window.dialogArguments;
		var sType 			= "";
		var topKeyword  	= "";
		var searchEnterCd  	= "";
		var searchSabun  	= "";
	/*Sheet 기본 설정 */
	    if( arg != undefined ) {
	    	sType 	   = arg["sType"];
	    	topKeyword = arg["topKeyword"];
	    	searchEnterCd = arg["searchEnterCd"];
	    	searchSabun = arg["searchSabun"];
	    }else{
			if ( p.popDialogArgument("sType") !=null ) { sType			   				= p.popDialogArgument("sType"); }
			if ( p.popDialogArgument("topKeyword") !=null ) { topKeyword		   		= p.popDialogArgument("topKeyword"); }
			if ( p.popDialogArgument("searchEnterCd") !=null ) { searchEnterCd			= p.popDialogArgument("searchEnterCd"); }
			if ( p.popDialogArgument("searchSabun") !=null ) { searchSabun		    	= p.popDialogArgument("searchSabun"); }
	    }

		$("#searchEmpType").val(sType);
		$("#searchKeyword").val(topKeyword);
		$("#searchEnterCd").val(searchEnterCd);
		$("#searchSabun").val(searchSabun);

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"가족키",	Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"famSeq"},
			{Header:"<sht:txt mid='famCd_V1004' mdef='관계'/>",		Type:"Combo",		Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"famCd"},
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"famNm"},
			{Header:"<sht:txt mid='birYmd' mdef='생년월일'/>",	Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"famYmd"}

		];
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);sheet1.SetEditable(false);
		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20120"), "");
		sheet1.SetColProperty("famCd", 				{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		
		$(window).smartresize(sheetResize);
		sheetInit();

        $(".close").click(function() {
	    	p.self.close();
	    });
        
        doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
			    sheet1.DoSearch( "${ctx}/ChildcareFamPopup.do?cmd=getChildcarePopupList", $("#mySheetForm").serialize(),1 );
	            break;
		}
    }

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
			setSheetSize(sheet1);
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
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
		}
		catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
		finally{
			p.self.close();;
		}
	}

	function returnFindUser(Row,Col){
	    if(sheet1.RowCount() <= 0) {
	    	//alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
	    	return;
	    }
    	var returnValue = new Array(6);

    	returnValue["enterCd"] 		= sheet1.GetCellValue(Row,"enterCd");
    	returnValue["sabun"] 		= sheet1.GetCellValue(Row,"sabun");
 		returnValue["famNm"] 		= sheet1.GetCellValue(Row,"famNm");
 		returnValue["famCd"] 		= sheet1.GetCellValue(Row,"famCd");
 		returnValue["famSeq"] 		= sheet1.GetCellValue(Row,"famSeq");
 		returnValue["famYmd"] 		= sheet1.GetCellValue(Row,"famYmd");


		if(p.popReturnValue) p.popReturnValue(returnValue);
		p.self.close();
	}
	
	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
    function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
        try {
            // Insert KEY
            if (KeyCode == 13) {
                returnFindUser(Row,Col);
            }
            
        } catch (ex) {
            alert("OnKeyDown Event Error : " + ex);
        }
    }
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='schEmployee' mdef='사원조회'/></li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
            <form id="mySheetForm" name="mySheetForm">
                <input type="hidden" id="searchEnterCd" name="searchEnterCd" value=""/>
                <input type="hidden" id="searchStatusCd" name="searchStatusCd" value="RA"/>
                <input type="hidden" id="searchEmpType" name="searchEmpType" value="P"/> <!-- 팝업에서 사용 -->
                <input type="hidden" id="searchUserId" name="searchUserId" />
                <input type="hidden" id="searchSabun" name="searchSabun" />
                <div class="sheet_search outer hide">
                    <div>
                    <table>
                    <tr>
                    	<th><tit:txt mid='112947' mdef='성명/사번'/></th>
                        <td>  <input id="searchKeyword" name ="searchKeyword" type="text" class="text" style="ime-mode:active;"/> </td>
                        <td> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('RA');" checked="checked" type="radio"  class="radio"/> <tit:txt mid='113521' mdef='퇴직자 제외'/></td>
                        <td> <input name="searchStatusRadio" onchange="$('#searchStatusCd').val('A');" type="radio" class="radio"/> <tit:txt mid='114221' mdef='퇴직자 포함'/></td>
                        <td>
                            <a href="javascript:doAction('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
                        </td>
                    </tr>
                    </table>
                    </div>
                </div>

	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">가족조회</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>
