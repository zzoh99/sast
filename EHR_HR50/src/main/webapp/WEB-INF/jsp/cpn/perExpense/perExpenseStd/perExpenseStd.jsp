<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>결산기준관리</title>
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

            $("#searchYyyy").mask("1111");

            var initdata1 = {};
            initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
            initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

            initdata1.Cols = [
                {Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
                {Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

                {Header:"선택|선택",									Type:"Radio",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"chk",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1,  RadioIcon:0 },
                {Header:"결산년월|결산년월",							Type:"Date",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ym",					KeyField:1,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:7 },
                {Header:"임금인상\n기준일자|임금인상\n기준일자",		Type:"Date",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"stdDate",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
                {Header:"예상임금\n인상율(%)|예상임금\n인상율(%)",Type:"Int",				Hidden:0,	Width:80,	Align:"Right",		ColMerge:0,	SaveName:"expIncRate",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"실임금인상율(%)|사무",						Type:"Int",				Hidden:0,	Width:80,	Align:"Right",		ColMerge:0,	SaveName:"realIncRate1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"실임금인상율(%)|기사",						Type:"Int",				Hidden:0,	Width:80,	Align:"Right",		ColMerge:0,	SaveName:"realIncRate2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"인건비\n형성|인건비\n형성",				Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dataCreYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
                {Header:"전표생성|전표생성",							Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"stateCreYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
                {Header:"전표전송|전표전송",							Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"stateSendYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }
            ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

            var initdata2 = {};
            initdata2.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
            initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

            initdata2.Cols = [
                {Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"삭제",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
                {Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

                {Header:"월",				Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ym",			KeyField:1,	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:7 },
                {Header:"임원(%)",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"rate1",		KeyField:0,	Format:"Integer",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"사무직(%)",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"rate2",		KeyField:0,	Format:"Integer",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
                {Header:"기사직(%)",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"rate3",		KeyField:0,	Format:"Integer",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
            ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

            $(window).smartresize(sheetResize); sheetInit();


            $("#searchYyyy").bind("keyup",function(event){
                if( event.keyCode == 13){
                    doAction1("Search");
                    doAction2("Search");
                }
            });

            doAction1("Search");
            doAction2("Search");

        });

        //Sheet1 Action
        function doAction1(sAction) {
            switch (sAction) {
                case "Search":
                    if(!checkList()) return ;
                    sheet1.RemoveAll();
                    sheet1.DoSearch( "${ctx}/PerExpenseStd.do?cmd=getPerExpenseStdLeftList", $("#sendForm").serialize() );
                    break;
                case "Save":
                    if(!dupChk(sheet1,"ym", true, true)){break;}
                    IBS_SaveName(document.sendForm,sheet1);
                    sheet1.DoSave( "${ctx}/PerExpenseStd.do?cmd=savePerExpenseStdLeft", $("#sendForm").serialize());
                    break;
                case "Insert":
                    if(!checkList()) return ;

                    let lastYm, date;
                    if (sheet1.RowCount() > 0) {
                        lastYm = sheet1.GetCellValue(sheet1.LastRow(), "ym");

                        const lastYy = Number(lastYm.substring(0, 4));
                        const lastMm = Number(lastYm.substring(4, 6));
                        if (lastMm >= 12) {
                            alert("더이상 추가할 수 없습니다.");
                            return;
                        }

                        date = new Date(Number(lastYy), lastMm-1);
                        date.setMonth(date.getMonth() + 1);
                    } else {
                        date = new Date();
                    }

                    const mm = date.getMonth() + 1;
                    const newDate = date.getFullYear() + "" + ( mm >= 10 ? mm : "0" + mm );

                    const row = sheet1.DataInsert(-1);
                    sheet1.SetCellValue(row, "ym", newDate);

                    sheet1.SetCellValue(row, "stdDate", $("#searchYyyy").val() + "0301");
                    sheet1.SetCellValue(row, "expIncRate", "5");
                    break;
                case "Copy":
                    if(!checkList()) return ;
                    sheet1.DataCopy();
                    break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet1);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
                    sheet1.Down2Excel(param);

                    break;
                case "Create":

                    if ( sheet1.FindStatusRow("I|U|D") !== "" ) {
                        alert("입력/수정/삭제 중인 행이 있습니다. 저장 후 다시 시도해주세요.");
                        break;
                    }

                    if ( sheet1.FindCheckedRow("chk") === "" ) {
                        alert("결산년월을 선택해주세요.");
                        break;
                    }

                    if ( !confirm("데이터생성 하시겠습니까?")) {
                        break;
                    }

                    progressBar(true, "데이터 생성중입니다.");

                    IBS_SaveName(document.sendForm,sheet1);

                    var saveStr = sheet1.GetSaveString({Col:"chk"});
                    saveStr = saveStr.replace("sStatus=R","sStatus=U");

                    var saveStr2 =$("#sendForm").serialize();

                    if(saveStr == "KeyFieldError" || saveStr == ""){
                        progressBar(false);
                        return;
                    }

                    $.ajax({
                        url : "${ctx}/PerExpenseStd.do?cmd=savePerExpenseStdPrc",
                        type : "post",
                        dataType : "json",
                        async : true,
                        data : saveStr+"&"+saveStr2,
                        success : function(result) {

                            progressBar(false);
                            console.log(result);
                            if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
                                if (result["Result"]["Code"] == "0") {
                                    alert("데이터 생성이 완료되었습니다.");
                                    doAction1("Search");
                                } else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
                                    alert(result["Result"]["Message"]);
                                    doAction1("Search");
                                }
                            } else {
                                alert("데이터 생성 오류입니다.");
                            }
                        },
                        error : function(jqXHR, ajaxSettings, thrownError) {
                            progressBar(false);
                            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
                        }
                    });

                    break;
                case "StateCre":

                    if ( sheet1.FindStatusRow("I|U|D") !== "" ) {
                        alert("입력, 저장 또는 삭제중인 행이 있습니다.");
                        break;
                    }

                    if ( sheet1.FindCheckedRow("chk") === "" ) {
                        alert("결산년월을 선택해주세요.");
                        break;
                    }

                    var cnt = 0;

                    $(sFindRow.split("|")).each(function(index, value){
                        var dataCreYn = sheet1.GetCellValue( value, "dataCreYn" )
                        if ( dataCreYn == "N" ){
                            cnt++;
                        }
                    });

                    if ( cnt > 0 ){
                        alert("인건비데이터가 생성된 내역만 전표생성 가능합니다.");
                        break;
                    }

                    if ( !confirm("전표생성 하시겠습니까?")){break;}

                    progressBar(true, "전표 생성중입니다.");

                    IBS_SaveName(document.sendForm,sheet1);

                    var saveStr = sheet1.GetSaveString({Col:"chk"})
                    saveStr = saveStr.replace("sStatus=R","sStatus=U");

                    var saveStr2 =$("#sendForm").serialize();

                    if(saveStr == "KeyFieldError" || saveStr == ""){
                        progressBar(false);
                        break;
                    }

                    $.ajax({
                        url : "${ctx}/PerExpenseStd.do?cmd=savePerExpenseStdPrc1",
                        type : "post",
                        dataType : "json",
                        async : true,
                        data : saveStr+"&"+saveStr2,
                        success : function(result) {

                            progressBar(false);
                            if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
                                if (result["Result"]["Code"] == "0") {
                                    alert("전표 생성이 완료되었습니다.");
                                    doAction1("Search");
                                } else if (result["Result"]["Message"] != null && result["Result"]["Message"] != "") {
                                    alert(result["Result"]["Message"]);
                                    doAction1("Search");
                                }
                            } else {
                                alert("전표 생성 오류입니다.");
                            }
                        },
                        error : function(jqXHR, ajaxSettings, thrownError) {
                            progressBar(false);
                            ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
                        }
                    });

                    break;

                case "StateSend":

                    var sFindStatusRow = sheet1.FindStatusRow("I|U|D");

                    if ( sFindStatusRow != "" ){
                        alert("입력, 저장 또는 삭제중인 행이 있습니다.");
                        break;
                    }

                    var sFindRow = sheet1.FindCheckedRow("chk");

                    if ( sFindRow == "" ){
                        alert("결산년월을 선택해주세요.");
                        break;
                    }

                    var cnt = 0;

                    $(sFindRow.split("|")).each(function(index, value){
                        var stateCreYn = sheet1.GetCellValue( value, "stateCreYn" )
                        if ( stateCreYn == "N" ){
                            cnt++;
                        }
                    });

                    if ( cnt > 0 ){
                        alert("전표생성된 내역만 전표전송 가능합니다.");
                        break;
                    }

                    if ( !confirm("전표전송 하시겠습니까?")){break;}

                    $(sFindRow.split("|")).each(function(index, value){

                        var month = sheet1.GetCellValue( value, "ym" );
                        var data = ajaxCall("${ctx}/PerExpenseStd.do?cmd=getPerExpenseStdITFIDMap","month="+month, false).DATA;

                        if ( data != null ){

                            var interfaceId = data.interfaceId;

                            // GL전표 자료 생성
                            var glCreRtn = ajaxCall("${ctx}/GLStatementMgr.do?cmd=gLStatementMgrPrc","interfaceId="+interfaceId, false);

                            if(glCreRtn.Result != null) {
                                // 전표 전송
                                var ifId = "IF_SRD_GHR_ERP_0001"; //GL전표(고정)
                                var rtn = ajaxCall("${ctx}/InterfaceEAI.do?cmd=restApiCall","ifId="+ifId, false);
                                if(rtn.Result.ResultMessage == "S") {
                                    alert("전송 처리되었습니다.");
                                } else {
                                    alert("전송 실패하였습니다.");
                                }
                            }
                        }
                    });

                    break;
            }
        }

        //Sheet2 Action
        function doAction2(sAction) {
            switch (sAction) {
                case "Search":
                    if(!checkList()) return ;
                    sheet2.RemoveAll();
                    sheet2.DoSearch( "${ctx}/PerExpenseStd.do?cmd=getPerExpenseStdRightList", $("#sendForm").serialize() );
                    break;
                case "Save":
                    if(!dupChk(sheet2,"ym", true, true)){break;}
                    IBS_SaveName(document.sendForm,sheet2);
                    sheet2.DoSave( "${ctx}/PerExpenseStd.do?cmd=savePerExpenseStdRight", $("#sendForm").serialize());
                    break;
                case "Down2Excel":
                    var downcol = makeHiddenSkipCol(sheet2);
                    var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
                    sheet2.Down2Excel(param);

                    break;
            }
        }


        // 조회 후 에러 메시지
        function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg !== "") {
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
                if (Msg !== "") {
                    alert(Msg);
                }
                doAction1("Search");
            } catch (ex) {
                alert("OnSaveEnd Event Error " + ex);
            }
        }

        // 변경 이벤트
        function sheet1_OnChange(Row, Col, Value, OldValue) {
            try {
                if (sheet1.ColSaveName(Col) === "chk") {
                    if (Value !== OldValue)
                        sheet1.SetCellValue(Row, "sStatus", "R");
                }
            } catch (ex) {
                alert("OnChange Event Error " + ex);
            }
        }

        // 조회 후 에러 메시지
        function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg !== "") {
                    alert(Msg);
                }

                sheetResize();

            } catch (ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }

        // 저장 후 메시지
        function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
            try {
                if (Msg !== "") {
                    alert(Msg);
                }
                doAction2("Search");
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
                if($(this).val() == null || $(this).val() === ""){
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
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <td>
                            <span>결산년도</span>
                            <input id="searchYyyy" name="searchYyyy" type="text" class="text required" value="${curSysYear}" style="width: 50px;" />
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search');doAction2('Search');" class="button">조회</a>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
            <colgroup>
                <col width="70%" />
                <col width="30%" />
            </colgroup>
            <tr>
                <td class="sheet_left">
                    <div class="inner">
                        <div class="sheet_title">
                            <ul>
                                <li class="txt">결산기준관리</li>
                                <li class="btn">
                                    사번 : <input type="text" id="searchSabun" name="searchSabun" class="text" style="width: 60px;" />
                                    <a href="javascript:doAction1('Create');" 			class="button authA">데이터생성</a>
                                    <a href="javascript:doAction1('StateCre');" 			class="button authA">전표생성</a>
                                    <a href="javascript:doAction1('StateSend');" 		class="button authA">전표전송</a>
                                    <a href="javascript:doAction1('Insert');" 			class="basic authA">입력</a>
                                    <a href="javascript:doAction1('Copy');" 				class="basic authA">복사</a>
                                    <a href="javascript:doAction1('Save');" 				class="basic authA">저장</a>
                                    <a href="javascript:doAction1('Down2Excel');" 		class="basic authR">다운로드</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
                </td>
                <td class="sheet_right">
                    <div class="inner">
                        <div class="sheet_title">
                            <ul>
                                <li class="txt">상여율관리</li>
                                <li class="btn">
                                    <a href="javascript:doAction2('Save');" 			class="basic authA">저장</a>
                                    <a href="javascript:doAction2('Down2Excel');" 		class="basic authR">다운로드</a>
                                </li>
                            </ul>
                        </div>
                    </div>
                    <script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
                </td>
            </tr>
        </table>
    </form>
</div>
</body>
</html>
