<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>의료비정산계산내역</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");

	$(function() {

		var arg = p.window.dialogArguments;

		var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:5, DataRowMerge:0};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
                        {Header:"No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
                        {Header:"급여계산명",                          Type:"Text",            Hidden:0,  Width:160,    Align:"Left",      ColMerge:0,   SaveName:"pay_action_nm",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"사번",                          		Type:"Text",            Hidden:0,  Width:60,     Align:"Center",    ColMerge:0,   SaveName:"sabun",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"성명",                          		Type:"Text",            Hidden:0,  Width:60,     Align:"Center",    ColMerge:0,   SaveName:"name",                        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"부서",                          		Type:"Text",            Hidden:0,  Width:150,    Align:"Left",      ColMerge:0,   SaveName:"org_nm",                      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"입사일",                       		Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:0,   SaveName:"emp_ymd",                     KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"퇴사일",                       		Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:0,   SaveName:"ret_ymd",                     KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"직위",                          		Type:"Text",            Hidden:0,  Width:60,     Align:"Center",    ColMerge:0,   SaveName:"jikwee_nm",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"직급",                          		Type:"Text",            Hidden:0,  Width:60,     Align:"Center",    ColMerge:0,   SaveName:"jikgub_nm",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"사업장",                       		Type:"Text",            Hidden:0,  Width:60,     Align:"Center",    ColMerge:0,   SaveName:"business_place_nm",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"연금계좌\n건수",                      Type:"Text",            Hidden:0,  Width:50,     Align:"Center",    ColMerge:0,   SaveName:"account_cnt",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"연금계좌\n확인",                   	Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:0,  SaveName:"confirm_text",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"퇴직급여",                       		Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",    ColMerge:0,   SaveName:"tot_ret_mon",                  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		if( arg != undefined ) {
			$("#searchWorkYy").val(arg["searchWorkYy"]) ;
			$("#searchBizLoc").val(arg["searchBizLoc"]) ;
		}else{
			$("#searchWorkYy").val(p.popDialogArgument("searchWorkYy"));
			$("#searchBizLoc").val(p.popDialogArgument("searchBizLoc"));
		}

        $(window).smartresize(sheetResize);sheetInit();

		doAction1("Search") ;
	});

	$(function() {
        $("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
        // 사업장(권한 구분)
        var ssnSearchType  = "<%=removeXSS(ssnSearchType, '1')%>";
        var payCdList = "";

        if(ssnSearchType == "A"){
            payCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getPayComCodeList","",false).codeList, "전체");
        }else{
            payCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
        }
        $("#searchBizPlaceCd").html(payCdList[2]);

        $(".close").click(function() {
	    	p.self.close();
	    });
	});


	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			sheet1.DoSearch( "<%=jspPath%>/yeaNtsTax/yeaCalcRst.jsp?cmd=selectCalcRetiree", $("#sheetForm").serialize() );
        	break;
		case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param);
            break;
		}
    }

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			if(sheet1.RowCount() > 0) {
				for (i = 1; i < sheet1.RowCount()+1; i++){
	        		if(sheet1.GetCellValue(i, "account_cnt") == "0"){
	        			sheet1.SetCellBackColor( i, 10 ,"#fac49b" );
					}
                    if(sheet1.GetCellValue(i, "confirm_text") == "계좌번호누락"){
                        sheet1.SetCellBackColor( i, 11 ,"#ffb8b8" );
                    }
	        	}
			}

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

</script>

</head>
<body class="bodywrap">
<form id="sheetForm" name="sheetForm">
	<input type="hidden" id="searchWorkYy" name="searchWorkYy" />
	<input type="hidden" id="searchBizLoc" name="searchBizLoc" />
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>퇴직소득 대상자 현황</li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
	        <div class="inner">
	            <div class="sheet_search">
	                <table>
	                    <tr>
	                        <td><span>사번/성명</span>
	                        <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> &nbsp;&nbsp;</td>
                            <td><span>사업장</span>
                                 <select id="searchBizPlaceCd" name="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"> </select>&nbsp;&nbsp;
	                         <td>
	                             <span>연금계좌 건수 여부</span>
	                             <select id="searchPenAcctYn" name="searchPenAcctYn" class="box" onChange="javascript:doAction1('Search')">
	                                 <option value="">전체</option>
	                                 <option value="Y">Y</option>
	                                 <option value="N">N</option>
	                             </select>&nbsp;&nbsp;
	                         </td>
	                         <td>
	                             <span>연금계좌 확인</span>
	                             <select id="searchPenAcctChk" name="searchPenAcctChk" class="box" onChange="javascript:doAction1('Search')">
	                                 <option value="">전체</option>
	                                 <option value="1">정상</option>
	                                 <option value="2">사업자명누락</option>
	                                 <option value="3">계좌번호누락</option>
	                             </select>&nbsp;&nbsp;
	                         </td>
	                        <td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
	                    </tr>
	                </table>
	            </div>
	            <div class="outer">
	                <div id="infoDiv">
	                    <div class="explain">
	                        <div class="txt">
	                            <ul>
	                                <li>퇴직금은 <font style="color:red">'귀속년월'</font>, 퇴직중간정산은 <font style="color:red">'지급년월'</font>이 신고대상입니다</li>
	                                <li>퇴직소득신고를 제외를 원하실 경우 [퇴직금계산] 화면 대상자리스트에 <font style="color:red">'퇴직소득신고제외'</font> 체크 및 저장해주십시오.</li>
	                                <li>연금계좌 오류 및 등록은 [퇴직금] 메뉴 하위에 [연금계좌입금내역], [퇴직세액재계산] 화면등에서 등록 해주시기 바랍니다.</li>
	                            </ul>
	                        </div>
	                    </div>
	                </div>
	                <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	                    <tr>
	                        <td class="top">
	                            <div class="outer">
	                                <div class="sheet_title">
	                                    <ul>
	                                        <li id="strSheetTitle" class="txt">퇴직소득 대상자 현황</li>
	                                        <li class="btn">
	                                            <a href="javascript:doAction1('Down2Excel')"    class="basic btn-download">다운로드</a>
	                                        </li>
	                                    </ul>
	                                </div>
	                            </div>
	                        </td>
	                    </tr>
	                </table>
	            </div>	            
	            <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
	        </div>
        </div>
	</div>
</form>
</body>
</html>
