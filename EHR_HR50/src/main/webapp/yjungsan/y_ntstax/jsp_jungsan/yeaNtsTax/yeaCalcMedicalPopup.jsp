<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>의료비정산계산내역</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("<%=popUpStatus%>");

	$(function() {

		var arg = p.window.dialogArguments;

		var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:5, DataRowMerge:0};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
                        {Header:"No|No",       Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
                        {Header:"년도|년도",                          Type:"Text",            Hidden:0,  Width:50,     Align:"Center",    ColMerge:1,   SaveName:"work_yy",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"정산구분|정산구분",                     Type:"Text",            Hidden:1,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"adjust_type",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"사번|사번",                          Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"sabun",                         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"성명|성명",                          Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"name",                          KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"부서|부서",                          Type:"Text",            Hidden:0,  Width:100,    Align:"Center",    ColMerge:1,   SaveName:"org_nm",                        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"사업장|사업장",                       Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"business_place_nm",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"입사일|입사일",                       Type:"Text",            Hidden:0,  Width:80,    Align:"Center",    ColMerge:1,   SaveName:"emp_ymd",                       KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"퇴사일|퇴사일",                       Type:"Text",            Hidden:0,  Width:80,    Align:"Center",    ColMerge:1,   SaveName:"ret_ymd",                       KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"총급여|총급여",                       Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"taxable_pay_mon",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"의료비|입금금액",                      Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"appl_mon",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"의료비|공제대상금액",                    Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a050_01_std",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
                        {Header:"의료비|세액공제액",                     Type:"AutoSum",         Hidden:0,  Width:100,    Align:"Right",     ColMerge:1,   SaveName:"a050_01",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//작업구분
        var adjustTypeList;

		if( arg != undefined ) {
			$("#searchWorkYy").val(arg["searchWorkYy"]) ;
			$("#searchAdjustType").val(arg["searchAdjustType"]) ;
			$("#searchBizLoc").val(arg["searchBizLoc"]) ;
			adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+arg["searchWorkYy"],"C00303"), "");
		}else{
			$("#searchWorkYy").val(p.popDialogArgument("searchWorkYy"));
			$("#searchAdjustType").val(p.popDialogArgument("searchAdjustType"));
			$("#searchBizLoc").val(p.popDialogArgument("searchBizLoc"));
			adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear="+p.popDialogArgument("searchWorkYy"),"C00303"), "");
		}

		$("#searchAdjustType").html(adjustTypeList[2]);
		$("#searchDeductYn").val("Y");
		
        $(window).smartresize(sheetResize);sheetInit();

		doAction1("Search") ;
	});

	$(function() {
        $("#searchNm").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction1("Search");
			}
		});

        $(".close").click(function() {
	    	p.self.close();
	    });
	});


	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			sheet1.DoSearch( "<%=jspPath%>/yeaNtsTax/yeaCalcRst.jsp?cmd=selectCalcMedical", $("#sheetForm").serialize() );
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
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
</script>

</head>
<body class="bodywrap">

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>의료비정산계산내역 보기</li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="sheetForm" name="sheetForm">
            <input type="hidden" id="searchWorkYy" name="searchWorkYy" />
            <input type="hidden" id="searchAdjustType" name="searchAdjustType" />
            <input type="hidden" id="searchBizLoc" name="searchBizLoc" />
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
                        <td>
                            <span>사번/성명</span>
                            <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
                        </td>
                        <td>
                            <span>의료비 세액공제여부</span>
                            <select id="searchDeductYn" name ="searchDeductYn" onChange="doAction1('Search');" class="box">
                            	<option value="">전체</option>
                            	<option value="Y">발생</option>
                            	<option value="N">미발생</option>
                            </select>
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
                        </td>
                    </tr>
                    </table>
                    </div>
                </div>

	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">의료비정산계산내역</li>
					<li class="btn">
						<font class='blue'>[지급조서생성시 나오는 총금액은 의료비 세액공제가 발생한 대상자들의 실손의료보험금을 제외한 입금금액의 총합 입니다.]</font>
						<a href="javascript:doAction1('Down2Excel')" 	class="basic btn-download">다운로드</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

	        <!-- <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div> -->
        </div>
    </div>
</body>
</html>
