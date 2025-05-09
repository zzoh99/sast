<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>퇴직충당금조회</title>
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

            var searchType 				= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C68310"), "전체");
            var searchAccountDivCd 		= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTorg109List&mapTypeCd=1030",false).codeList, "전체");	//회계사업부
            var searchCostLocationCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTorg109List&mapTypeCd=1040",false).codeList, "전체");	//회계LOCATION

//========================================================================================================================================================================

            var initdata1 = {};
            initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:10};
            initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

            initdata1.Cols = [
                {Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"삭제",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
                {Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

                {Header:"결산년월",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"month",					KeyField:1,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:7 },
                {Header:"사번",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
                {Header:"성명",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"employeeName",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"구분",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gubun",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"회계\n사업부",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"costDivisionCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"회계\nLocation",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"costLocation",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"부서코드",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgCode",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"부서명",				Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgName",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"직위코드",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"직위",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"직계코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"직계",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"재직상태코드",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"상태",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"statusNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

                {Header:"그룹입사일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"originalHireDate",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"현회사입사일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hireDate",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"퇴직기산일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sepStartDate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"퇴직일자",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"actualTerminationDate",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },

                {Header:"근속월수",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"wkpdDaySep",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"퇴직금\n지급여부",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sepPayementFlag",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
                {Header:"퇴직금지급일자",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sepPaidDate",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"DB퇴직금지급액",		Type:"Int",		Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"dbSepPayPaid",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"퇴직금승계액",			Type:"Int",		Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"sepPayTransfer",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"연말퇴충금",			Type:"Int",		Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"expectedTotalSepSalary",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"전년말퇴충금",			Type:"Int",		Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"lastYearTotalSepSalary",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"당해년간퇴충금",		Type:"Int",		Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"expectedAnnualSepSalary",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"전월말당해\n누적퇴충금",	Type:"Int",		Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"expectedLastmonthSepSalary",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"당월말당해\n누적퇴충금",	Type:"Int",		Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"expectedMonthSepSalary",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

                {Header:"당월전입액",			Type:"Int",		Hidden:0,	Width:110,	Align:"Right",	ColMerge:0,	SaveName:"expectedAdjSepSalary",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

                {Header:"당월퇴직추계액",		Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"expectedSepSalary",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"평균임금",				Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"avgSalary",					KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"전월평균임금",			Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"prevAvgSalary",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"평균급여",				Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"avgMth",					KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"평균적치",				Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"avgAlrBonus",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"평균상여",				Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"avgBonus",					KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"퇴직금예외자",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sepExcludingFlag",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
                {Header:"주재여부",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"fseFlag",					KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1 },
                {Header:"비용구분",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"costClassCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"DC전환일",				Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dcChangeDate",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
                {Header:"당월당해\n소득총액"	,	Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"dcYearlySalary",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"전월당해\n소득총액",	Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"lastMonthDcYearlySalary",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"DC전월추계액",			Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"dcLastmonExpectedSepSalary",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"DC당월추계액",			Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"dcExpectedSepSalary",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"DC당월전입액",			Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"dcExpectedAdjSepSalary",		CalcLogic:"|dcExpectedSepSalary|-|dcLastmonExpectedSepSalary|",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"DC미지급리버스",		Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"dcReverseSepSalary",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"DC퇴직금지급액",		Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"dcSepPayPaid",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"DC전년말추계액",		Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"dcLastYearSepSalary",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
                {Header:"DC당해인식전입액",		Type:"Int",		Hidden:0,	Width:110,	Align:"Right",		ColMerge:0,	SaveName:"dcAdjSepSalary",			CalcLogic:"|dcSepPayPaid|-|dcExpectedLastYearSepSalary|",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
            ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

            sheet1.SetColProperty("type", 				{ComboText:"|"+searchType[0], 				ComboCode:"|"+searchType[1]} );
            sheet1.SetColProperty("accountDivCd", 		{ComboText:"|"+searchAccountDivCd[0], 		ComboCode:"|"+searchAccountDivCd[1]} );
            sheet1.SetColProperty("costLocationCd", 	{ComboText:"|"+searchCostLocationCd[0], 	ComboCode:"|"+searchCostLocationCd[1]} );

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
                    sheet1.DoSearch( "${ctx}/RetAllowanceSta.do?cmd=getRetAllowanceStaList", $("#sendForm").serialize() );
                    break;
                case "Save":
                    if(!dupChk(sheet1,"ym|sabun", true, true)){break;}
                    IBS_SaveName(document.sendForm,sheet1);
                    sheet1.DoSave( "${ctx}/RetAllowanceSta.do?cmd=saveRetAllowanceSta", $("#sendForm").serialize());
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

        // 저장 후 메시지
        function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg != "") {
                    alert(Msg);
                }
                doAction1("Search");
            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
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
            try {
                if(!isPopup()) {return;}
                // var args = new Array();
                // gPRow = "";
                // pGubun = "viewRetAllowanceStaPop";
                // args["searchMapTypeCd"] = "1040";
                // args["searchMapTypeNm"] = "회계Location";
                <%--openPopup("${ctx}/RetAllowanceSta.do?cmd=viewRetAllowanceStaPop&authPg=${authPg}", args, "500","700");--%>

                var parameters = {
                    authPg: "${authPg}",
                    searchMapTypeCd: "1040",
                    searchMapTypeNm: "회계Location"
                };
                let layerModal = new window.top.document.LayerModal({
                    id : 'retAllowanceStaLayer'
                    , url : "/RetAllowanceSta.do?cmd=viewRetAllowanceStaLayer"
                    , parameters : parameters
                    , width : 500
                    , height : 700
                    , title : '회계Location 조회'
                    , trigger :[
                        {
                            name : 'retAllowanceStaTrigger'
                            , callback : function(rv){
                                $("#searchCostLocationCd").val(rv["code"]);
                                $("#searchCostLocationNm").val(rv["codeNm"]);
                                doAction1("Search");
                            }
                        }
                    ]
                });
                layerModal.show();

            }catch(ex){
                alert("Open Popup Event Error : " + ex);
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
                        <td><span>회계Location</span>
                            <input type="text" id="searchCostLocationCd" name="searchCostLocationCd" class="text readonly" style="width:100px" readonly="readonly" />
                            <input type="text" id="searchCostLocationNm" name="searchCostLocationNm" class="text readonly" style="width:150px" readonly="readonly" />
                            <a onclick="javascript:retAllowanceStaPop();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
                            <a onclick="$('#searchCostLocationCd,#searchCostLocationNm').val('');doAction1('Search');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
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
                <li class="txt">퇴직충당금조회</li>
                <li class="btn">
                    <a href="javascript:doAction1('Save');" 			class="basic authA">저장</a>
                    <a href="javascript:doAction1('Down2Excel');" 		class="basic authR">다운로드</a>
                </li>
            </ul>
        </div>
    </div>

    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
