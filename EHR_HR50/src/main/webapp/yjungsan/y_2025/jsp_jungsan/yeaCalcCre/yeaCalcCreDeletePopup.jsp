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
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",		Hidden:0,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",          Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",          Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
 			{Header:"사번",			Type:"Text",			Hidden:0,	Width:50,				Align:"Center",	ColMerge:0,	SaveName:"sabun", 	UpdateEdit:0 },
			{Header:"성명",			Type:"Text",			Hidden:0,	Width:80,				Align:"Center",	ColMerge:0,	SaveName:"name", 	UpdateEdit:0 },
			{Header:"귀속년도",		Type:"Text",			Hidden:0,	Width:50,				Align:"Center",	ColMerge:0,	SaveName:"work_yy",	UpdateEdit:0 },
			{Header:"정산구분",		Type:"Combo",			Hidden:0,	Width:50,				Align:"Center",	ColMerge:0,	SaveName:"adjust_type",	UpdateEdit:0 },
			{Header:"급여일자코드",		Type:"Text",			Hidden:0,	Width:100,				Align:"Center",	ColMerge:0,	SaveName:"pay_action_cd", 	UpdateEdit:0 }

		];IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);


		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
		sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );

		$(window).smartresize(sheetResize);
		sheetInit();

		var searchWorkYy     	= "";
		var searchAdjustType	= "";
		var searchSabuns      	= "";

		if( arg != undefined ) {
			searchWorkYy      	= arg["searchWorkYy"];
			searchAdjustType  	= arg["searchAdjustType"];
			searchSabuns       	= arg["searchSabuns"];
		}else{
			searchWorkYy      	= p.popDialogArgument("searchWorkYy");
			searchAdjustType  	= p.popDialogArgument("searchAdjustType");
			searchSabuns       	= p.popDialogArgument("searchSabuns");
		}

		$("#searchWorkYy").val(searchWorkYy);
		$("#searchAdjustType").val(searchAdjustType);
		$("#searchSabuns").val(searchSabuns);

		doAction("Search");
	});

	$(function() {
        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": //조회
			sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcCreDeletePopupRst.jsp?cmd=selectYeaCalcList", $("#srchFrm").serialize() );
			break;
		case "Save": //저장
			/*20250423. 버그수정. 삭제 후처리로 동작하는 관련테이블 제거 로직이 [연말정산계산 > (팝업) 대상자 관리]의 삭제로직과 상이함. 해당 로직을 호출하도록 조정. 
			sheet1.DoSave( "<%=jspPath%>/yeaCalcCre/yeaCalcCreDeletePopupRst.jsp?cmd=saveYeaCalcList");*/
            sheet1.DoSave( "<%=jspPath%>/yeaCalcCre/yeaCalcCrePeoplePopupRst.jsp?cmd=saveYeaCalcCrePopup", $("#srchFrm").serialize());
            break;
		}
	}

	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			alertMessage(Code, Msg, StCode, StMsg);
		  	sheet1.SetFocusAfterProcess(0);
			setSheetSize(sheet1);

			if(sheet1.RowCount() == 0) {
				p.self.close();
			}

	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	// 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
        	alertMessage(Code, Msg, StCode, StMsg);

			if(sheet1.RowCount() == 0) {
				p.self.close();
			}else{
				doAction("Search");
			}
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
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
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>연말정산대상자삭제</li>
                <!--<li class="close"></li>-->
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
                <input type="hidden" id="searchWorkYy" name="searchWorkYy" value=""/>
                <input type="hidden" id="searchAdjustType" name="searchAdjustType" value=""/>
                <input type="hidden" id="searchSabuns" name="searchSabuns" value=""/>
	        </form>
			<div class="outer">
                <div class="sheet_title">
                    <ul>
                        <li id="strSheetTitle" class="txt">대상자</li>
                        <li class="btn">
                            <a href="javascript:doAction('Save')"  class="basic authA">저장</a>
                        </li>
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