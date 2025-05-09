<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
    <title>상여조정액조회</title>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script type="text/javascript">
        var gPRow = "";
        var pGubun = "";

        $(function() {

            $("input[type='text']").keydown(function(event){
                if(event.keyCode == 27){
                    return false;
                }
            });

            $("#searchYm").datepicker2({ymonly : true});

//========================================================================================================================================================================
            var searchAccountDivCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTorg109List&mapTypeCd=1030",false).codeList, "전체");	//회계사업부
            var searchCostType 		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTorg109List&mapTypeCd=1060",false).codeList, "전체");	//비용구분
//========================================================================================================================================================================

            var initdata1 = {};
            initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:8};
            initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

            initdata1.Cols = [
                {Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"삭제",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
                {Header:"상태",				Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

                {Header:"결산년월",					Type:"Date",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"month",					KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:7 },
                {Header:"사번",						Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",					KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
                {Header:"성명",						Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"employeeName",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"회계사업부",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"costDivisionCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"부서코드",					Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgCode",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"부서",						Type:"Text",	Hidden:0,	Width:150,	Align:"Left",		ColMerge:0,	SaveName:"orgName",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"직위코드",					Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"직위명",					Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"직계코드",					Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"직계",						Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"재직상태코드",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"상태",						Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

                {Header:"그룹입사일",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"originalHireDate",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"현회사입사일",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hireDate",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },

                {Header:"당월까지\n지급총상여",			Type:"Int",		Hidden:0,	Width:120,	Align:"Right",		ColMerge:0,	SaveName:"paidBonus",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"당월까지\n지급총상여율",		Type:"Int",		Hidden:0,	Width:120,	Align:"Right",		ColMerge:0,	SaveName:"paidBonusRate",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"잔여기간\n예상상여",			Type:"Int",		Hidden:0,	Width:120,	Align:"Right",		ColMerge:0,	SaveName:"payableBonus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"잔여기간\n예상상여율",			Type:"Int",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"payableBonusRate",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

                {Header:"연간\n예상상여",				Type:"Int",		Hidden:0,	Width:120,	Align:"Right",		ColMerge:0,	SaveName:"expectedAnnualBonus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"연간\n상여지급율",			Type:"Int",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"expectedAnnualBonusRate",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"당월까지\n예상지급총상여",			Type:"Int",		Hidden:0,	Width:120,	Align:"Right",		ColMerge:0,	SaveName:"expectedPaidBonus",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"당월\n조정상여",				Type:"Int",		Hidden:0,	Width:120,	Align:"Right",		ColMerge:0,	SaveName:"expectedAdjBonus",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"비용구분",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"costClassCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 }
            ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

            //sheet1.SetColProperty("accountDivCd", 		{ComboText:"|"+searchAccountDivCd[0], 		ComboCode:"|"+searchAccountDivCd[1]} );
            //sheet1.SetColProperty("costType", 			{ComboText:"|"+searchCostType[0], 		ComboCode:"|"+searchCostType[1]} );

            $(window).smartresize(sheetResize); sheetInit();

            doAction1("Search");

            $("#searchYm").bind("keyup",function(event){
                if( event.keyCode == 13){
                    doAction1("Search");
                }
            });

        });

        //Sheet1 Action
        function doAction1(sAction) {
            switch (sAction) {
                case "Search":
                    if(!checkList()) return ;
                    sheet1.RemoveAll();
                    sheet1.DoSearch( "${ctx}/BonusAdjustMonSta.do?cmd=getBonusAdjustMonStaList", $("#sendForm").serialize() );
                    break;

                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet1);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
                    sheet1.Down2Excel(param);

                    break;
            }
        }

        // 조회 후 에러 메시지
        function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }

                sheetResize();

            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        // 입력시 조건 체크
        function checkList(){
            var ch = true;
            var exit = false;
            if(exit){return false;}
            // 화면의 개별 입력 부분 필수값 체크
            $(".required").each(function(index){
                if($(this).val() == null || $(this).val() == ""){
                    alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
                    $(this).focus();
                    ch =  false;
                    return false;
                }
            });
            return ch;
        }

        function retAllowanceStaPop(){
            try{

                if(!isPopup()) {return;}
                var args = new Array();
                gPRow = "";
                pGubun = "viewRetAllowanceStaPop";
                args["searchMapTypeCd"] = "1030";
                args["searchMapTypeNm"] = "회계사업부";
                openPopup("${ctx}/RetAllowanceSta.do?cmd=viewRetAllowanceStaPop&authPg=${authPg}", args, "500","700");

            }catch(ex){
                alert("Open Popup Event Error : " + ex);
            }
        }

        function getReturnValue(returnValue) {

            var rv = $.parseJSON('{'+ returnValue+'}');

            if ( pGubun == "viewRetAllowanceStaPop" ){
                $("#searchAccountDivCd").val(rv["code"]);
                $("#searchAccountDivNm").val(rv["codeNm"]);
                doAction1("Search");
            }
        }
    </script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form name="sendForm" id="sendForm" method="post">
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td>
                            <span>결산년월</span>
                            <input id="searchYm" name="searchYm" type="text" class="text required" value="${curSysYyyyMMHyphen}" />
                        </td>
                        <td><span>회계사업부</span>
                            <input type="text" id="searchAccountDivCd" name="searchAccountDivCd" class="text readonly" style="width:100px" readonly="readonly" />
                            <input type="text" id="searchAccountDivNm" name="searchAccountDivNm" class="text readonly" style="width:150px" readonly="readonly" />
                            <a onclick="javascript:retAllowanceStaPop();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
                            <a onclick="$('#searchAccountDivCd,#searchAccountDivNm').val('');doAction1('Search');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search');" class="button">조회</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>
    <div class="inner">
        <div class="sheet_title">
            <ul>
                <li class="txt">상여조정액조회</li>
                <li class="btn">
                    <a href="javascript:doAction1('Down2Excel');" 		class="basic authR">다운로드</a>
                </li>
            </ul>
        </div>
    </div>

    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
