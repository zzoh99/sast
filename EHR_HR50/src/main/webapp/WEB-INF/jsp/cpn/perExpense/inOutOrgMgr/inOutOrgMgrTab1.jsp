<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>전출입관리</title>
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

            $("#pSearchYm").val($("#searchYm", parent.document).val().replace(/-/g,""));

            var initdata1 = {};
            initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
            initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

            initdata1.Cols = [
                {Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"삭제",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
                {Header:"상태",				Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

                {Header:"결산년월",					Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"month",							KeyField:1,	Format:"Ym",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7 },
                {Header:"이전월급여회계Location",	Type:"Text",		Hidden:0,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"lastCostLocation",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
                {Header:"이전월급여회계사업부",		Type:"Text",		Hidden:1,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"lastCostDivision",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:32 },
                {Header:"이전월급여회계부서",			Type:"Text",		Hidden:0,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"lastCostDepartment",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:32 },
                {Header:"이전월급여비용구분",			Type:"Text",		Hidden:1,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"lastCostClass",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:32 },
                {Header:"당월급여회계Location",	Type:"Text",		Hidden:0,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"costLocation",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
                {Header:"당월급여회계사업부",			Type:"Text",		Hidden:1,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"costDivision",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:32 },
                {Header:"당월급여회계부서",			Type:"Text",		Hidden:0,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"costDepartment",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:32 },
                {Header:"급여작업일자",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"effectiveDate",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
                {Header:"사번",						Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",							KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
                {Header:"성명",						Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"employeeName",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
                {Header:"퇴직\n충당금",				Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"expectedMonthSepSalary",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"휴가\n보상비",				Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"expectedPaidAlrBonus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"퇴직보험",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sepInsurance",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"퇴직연금",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sepPension",					KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"국민연금\n전환금",			Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sepNpReimb",					KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"종장대",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"houseloanComp",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"압류금",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"garnishmentBalance",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
                {Header:"생성일자",					Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"creationDate",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
            ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

            $(window).smartresize(sheetResize); sheetInit();
            doAction1("Search");

        });

        //Sheet1 Action
        function doAction1(sAction) {
            switch (sAction) {
                case "Search":
                    if(!checkList()) return ;
                    $("#pSearchYm").val($("#searchYm", parent.document).val().replace(/-/g,""));
                    sheet1.RemoveAll();
                    sheet1.DoSearch( "${ctx}/InOutOrgMgr.do?cmd=getInOutOrgMgrTab1List", $("#sendForm").serialize() );
                    break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet1);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
                    sheet1.Down2Excel(param);

                    break;
                case "Create":

                    var searchYm = $("#searchYm", parent.document).val();
                    if ( searchYm == "" ){
                        alert("결산년월은 필수값입니다.");
                        break;
                    }

                    if ( !confirm("대상자생성 하시겠습니까?")){break;}

                    progressBar(true, "대상자생성 중입니다.");

                    $.ajax({
                        url : "${ctx}/InOutOrgMgr.do?cmd=inOutOrgMgrPrc1",
                        type : "post",
                        dataType : "json",
                        async : true,
                        data : $("#sendForm").serialize(),
                        success : function(result) {

                            progressBar(false);
                            console.log(result);
                            if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
                                if (result["Result"]["Code"] == "") {
                                    alert("대상자생성이 완료되었습니다.");
                                    doAction1("Search");
                                } else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
                                    alert(result["Result"]["Message"]);
                                    doAction1("Search");
                                }
                            } else {
                                alert("대상자생성 시 오류가 발생하였습니다.");
                            }
                        },
                        error : function(jqXHR, ajaxSettings, thrownError) {
                            progressBar(false);
                            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
                        }
                    });

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

        function getReturnValue(returnValue) {

            var rv = $.parseJSON('{'+ returnValue+'}');

        }
    </script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form name="sendForm" id="sendForm" method="post">
        <input type="hidden" id="pSearchYm" name="pSearchYm" />
    </form>
    <div class="inner">
        <div class="sheet_title">
            <ul>
                <li class="txt">전출입 대상자 조회</li>
                <li class="btn">
                    <a href="javascript:doAction1('Create');" 			class="basic authA">대상자생성</a>
                    <a href="javascript:doAction1('Down2Excel');" 		class="basic authR">다운로드</a>
                </li>
            </ul>
        </div>
    </div>

    <script type="text/javascript"> createIBSheet("sheet1", "100%", "88%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
