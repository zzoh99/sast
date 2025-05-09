<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>주택자금</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
    var orgAuthPg = "<%=orgAuthPg%>";
    //도움말
    var helpText;
    //기준년도
    var systemYY;
    //총급여
    var paytotMonStr;
    //세대주 여부
    var houseOwnerYn;
    //주택구입일자
    var houseGetYmd;
    //주택면적
    var houseArea;
    //주택공시시가
    var officialPrice;
    //주택수
    var houseCnt;
    //총급여 확인 버튼 보여주기 유무 정보에 따라 컨트롤
    var yeaMonShowYn;

    $(function() {
        /*필수 기본 세팅*/
        $("#searchWorkYy").val(     $("#searchWorkYy", parent.document).val()       ) ;
        $("#searchAdjustType").val( $("#searchAdjustType", parent.document).val()   ) ;
        $("#searchSabun").val(      $("#searchSabun", parent.document).val()        ) ;
        systemYY = $("#searchWorkYy", parent.document).val();

        //기본정보 조회(도움말 등등).
        initDefaultData() ;

        if(orgAuthPg == "A") {
            $("#copyBtn_1").show() ;
        } else {
            $("#copyBtn_1").hide() ;
        }


        if(houseCnt == "0" || houseCnt == "") {
            $("#houseInfo").html("무 주택") ;
        } else if(houseCnt == "2") {
            $("#houseInfo").html("2 주택 이상") ;
        } else {
            if(houseArea == null) houseArea = "" ;
            $("#houseInfo").html("취득일자 : " + houseGetYmd + " / 전용면적 : " + houseArea + "㎡") ;
        }
    });

    var inputEdit = 0 ;
    var applEdit = 0 ;
    var adjInputTypeList;
    var feedbackTypeList;

    if( orgAuthPg == "A") {
        inputEdit = 0 ;
        applEdit = 1 ;
    } else {
        inputEdit = 1 ;
        applEdit = 0 ;
    }

    $(function() {
        parent.doSearchCommonSheet();
        adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00325"), "");
        feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00329"), "");
        loadSheet1();
    });

    function loadSheet1() {

        //임차차입금(대출기관), 저당차입금 이자상환액 쉬트
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"No|No",                                    Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:1, SaveName:"sNo" },
            {Header:"삭제|삭제",                                Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
            {Header:"상태|상태",                                Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
            {Header:"년도|년도",                                Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"work_yy",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분|정산구분",                        Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"adjust_type",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"사번|사번",                                Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"sabun",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
            {Header:"주택자금공제구분|주택자금공제구분",        Type:"Combo",   Hidden:0,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"house_dec_cd",    KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
            {Header:"순번|순번",                                Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"seq",             KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"계약(가입)일|시작일",                      Type:"Date",    Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"con_s_ymd",       KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"계약(가입)일|종료일",                      Type:"Date",    Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"con_e_ymd",       KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"월세액|월세액",                            Type:"Int",     Hidden:1,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"rent_mon",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"해당과세기간임차일수|해당과세기간임차일수",Type:"Int",     Hidden:1,   Width:80,   Align:"Right",  ColMerge:1, SaveName:"tax_day",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"금액자료|직원용",                          Type:"AutoSum", Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"input_mon",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:inputEdit,   InsertEdit:inputEdit,   EditLen:35 },
            {Header:"금액자료|담당자용",                        Type:"AutoSum", Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"appl_mon",        KeyField:1, Format:"",      PointCount:0,   UpdateEdit:applEdit,    InsertEdit:applEdit,    EditLen:35 },
            {Header:"자료입력유형|자료입력유형",                Type:"Combo",   Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"adj_input_type",  KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"담당자확인|담당자확인",                    Type:"Combo",   Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"feedback_type",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var houseDecCdList = stfConvCode( codeList("<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=selectHouseDecCdList&codeType=1&searchYear="+<%=yeaYear%>,""), "");

        sheet1.SetColProperty("adj_input_type",     {ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
        sheet1.SetColProperty("house_dec_cd",       {ComboText:"|"+houseDecCdList[0], ComboCode:"|"+houseDecCdList[1]} );
        sheet1.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );

        $(window).smartresize(sheetResize);
        sheetInit();

        doAction1("Search");
    }

    /*-----------------------------------------------------------------------------------------
    //저당차입금 이자상환액 --- start
    ------------------------------------------------------------------------------------------*/
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=selectYeaDataHouList&codeType=1", $("#sheetForm").serialize() );
            break;
        case "Save":
            if ( !saveBefore(sheet1) ) return;

            sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=saveYeaDataHou");
            break;
        case "Insert":
            if(!parent.checkClose())return;

            var newRow = sheet1.DataInsert(0) ;
            sheet1.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
            sheet1.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
            sheet1.SetCellValue( newRow, "sabun", $("#searchSabun").val() );

            tab_clickInsert(orgAuthPg, sheet1, newRow);
            break;
        case "Copy":
            var newRow = sheet1.DataCopy();
            sheet1.SelectCell(newRow, 2);
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

            if (Code == 1) {
                for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++){
                    if ( !tab_setAuthEdtitable(orgAuthPg, sheet1, i) ) continue;

                    if( sheet1.GetCellValue(i, "house_dec_cd") == "60" ) {
                        sheet1.SetCellEditable(i, "con_s_ymd", 1) ;
                        sheet1.SetCellEditable(i, "con_e_yYmd", 1) ;
                        sheet1.SetCellEditable(i, "rent_mon", 1) ;
                        sheet1.SetCellEditable(i, "tax_day", 1) ;
                    } else {
                        sheet1.SetCellEditable(i, "con_s_Ymd", 0) ;
                        sheet1.SetCellEditable(i, "con_e_ymd", 0) ;
                        sheet1.SetCellEditable(i, "rent_mon", 0) ;
                        sheet1.SetCellEditable(i, "tax_day", 0) ;
                    }
                }
            }
            setSheetSize(sheet1);
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            parent.getYearDefaultInfoObj();
            if(Code == 1) {
                parent.doSearchCommonSheet();
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    //값 변경시 발생
    function sheet1_OnChange(Row, Col, Value) {
        var shtObj = sheet1;

        try{
            if( shtObj.ColSaveName(Col) == "house_dec_cd" ){
                if(shtObj.GetCellValue(Row, "house_dec_cd") == "10" || shtObj.GetCellValue(Row, "house_dec_cd") == "20"){
                    /*  무주택 세대주일 경우  등록 가능 */
                    //if(houseOwnerYn != "Y" || houseCnt != "0") {
                    //무주택일 경우 등록 가능
                    if(houseCnt != "0") {
                        alert("주택임차차입금원리금상환액은 국민주택규모의 세입자로서 무주택자에 한해서 등록 가능합니다. 주소사항 탭의 입력내역을 확인 하십시오.");
                        shtObj.SetCellValue(Row, "house_dec_cd", "") ;
                        return;
                    }
                    if(shtObj.GetCellValue(Row, "house_dec_cd") == "20"){
                        /*  총급여가 5000만원 이하일경우에 등록 가능 , 2012년 개정*/
                        if( (paytotMonStr.replace(/,/gi, "")*1) > 50000000) {
                            alert("주택임차차입금원리금상환액은 총급여액이 50,000,000원 이하인 근로소득자에 한해서 등록 가능합니다. \n 총급여액 : "+paytotMonStr);
                            shtObj.SetCellValue(Row, "house_dec_cd", "") ;
                            return;
                        }
                    }
                }
                else if(shtObj.GetCellValue(Row, "house_dec_cd") == "60" ){
                    /*  무주택 세대주일 경우  등록 가능 */
                    //if(houseOwnerYn != "Y" || houseCnt != "0") {
                    //무주택일 경우 등록 가능
                    if(houseCnt != "0") {
                        alert("월세액공제는 무주택자에 한해서 등록 가능합니다. 주소사항 탭의 입력내역을 확인 하십시오.");
                        shtObj.SetCellValue(Row, "house_dec_cd", "") ;
                        return;
                    }

                    /*  총급여가 7000만원 이하일경우에 등록 가능 , 2012년 개정*/
                    if( (paytotMonStr.replace(/,/gi, "")*1) > 70000000) {
                        alert("월세액공제는 총급여액이 70,000,000원 이하인 근로소득자에 한해서 등록 가능합니다. \n 총급여액 : "+paytotMonStr);
                        shtObj.SetCellValue(Row, "house_dec_cd", "") ;
                        return;
                    }
                }

                if(shtObj.GetCellValue(Row, "house_dec_cd") == "60"){
                    shtObj.SetCellEditable(Row,"con_s_ymd", 1) ;
                    shtObj.SetCellEditable(Row,"con_e_ymd", 1) ;
                    shtObj.SetCellEditable(Row,"rent_mon", 1) ;
                } else if(shtObj.GetCellValue(Row, "house_dec_cd") == "30" || shtObj.GetCellValue(Row, "house_dec_cd") == "40"
                        || shtObj.GetCellValue(Row, "house_dec_cd") == "50" || shtObj.GetCellValue(Row, "house_dec_cd") == "53"
                        || shtObj.GetCellValue(Row, "house_dec_cd") == "55"){
                    shtObj.SetCellEditable(Row,"con_s_ymd", 1) ;
                } else{
                    shtObj.SetCellEditable(Row,"con_s_ymd", 0) ;
                    shtObj.SetCellEditable(Row,"con_e_ymd", 0) ;
                    shtObj.SetCellEditable(Row,"rent_mon", 0) ;
                }
                //장기주택저당차입금이자상환액 체크
                if(shtObj.GetCellValue(Row, "house_dec_cd") == "53"
                        || shtObj.GetCellValue(Row, "house_dec_cd") == "55" ){
                    shtObj.SetCellValue(Row, "con_s_ymd", "") ;

                    /*  무주택 세대주일 경우  등록 가능 */
                    if( houseCnt != '1' && houseCnt != '0') {
                        alert("장기주택저당차입금이자상환액 공제는 1주택  소유자에게만 등록  가능합니다. 주소사항 탭의 소유주택수 내역을 확인 하십시오.");
                        shtObj.SetCellValue(Row, "house_dec_cd", "") ;
                        return;
                    }
                    /*
                    if( houseArea > 100 ) {
                        alert("장기주택저당차입금이자상환액 공제는 국민주택규모(수도권: 85㎡, 수도권외 읍,면 등 : 100㎡)이하로만 등록  가능합니다. 주소사항 탭의 전용면적 내역을 확인 하십시오.");
                        shtObj.SetCellValue(Row, "house_dec_cd", "") ;
                        return;
                    }
                    */
                }
            }
            // 상황기간 체크(이자상환액)
            if( shtObj.ColSaveName(Col) == "con_s_ymd" ){
                if(shtObj.GetCellValue(Row, "house_dec_cd") == "30" && shtObj.GetCellValue(Row, "con_s_ymd") != "" ){
                  if(shtObj.GetCellValue(Row, "con_s_ymd") >'20031231' ){
                      alert('이자상환액(600만원한도)는 2003년 12월31일 이전 가입일만 해당 됩니다');
                      shtObj.SetCellValue(Row, "con_s_ymd", "") ;
                      return;
                  }
                }
            /*
                if(shtObj.GetCellValue(Row, "houseDecCd") == "40" && shtObj.GetCellValue(Row, "conSYmd") != "" ){
                  if( shtObj.GetCellValue(Row, "conSYmd") < '20040101' ){
                      alert('15년이상 30년미만의 이자상환액은 2004-01-01일 이후 가입일만 해당 됩니다');
                      shtObj.GetCellValue(Row, "conSYmd")='';
                      return;
                  }
                }
            */
            }

            if( shtObj.ColSaveName(Col) == "con_s_ymd" || shtObj.ColSaveName(Col) == "con_e_ymd" || shtObj.ColSaveName(Col) == "rent_mon"){

                var message = "계약기간의 ";
                checkNMDate(sheet1, Row, Col, message, "con_s_ymd", "con_e_ymd");

                if(shtObj.GetCellValue(Row, "con_s_ymd") != "" && shtObj.GetCellValue(Row, "con_e_ymd") != ""){

                    var startDate = $("#searchWorkYy").val() + "0101" ;
                    var endDate = $("#searchWorkYy").val() + "1231" ;
                    //임차일수 시작일 셋팅
                    if(startDate < shtObj.GetCellValue(Row, "con_s_ymd")){
                        startDate = shtObj.GetCellValue(Row, "con_s_ymd");
                    }
                    //임차일수 종료일 셋팅
                    if(endDate > shtObj.GetCellValue(Row, "con_e_ymd")){
                        endDate = shtObj.GetCellValue(Row, "con_e_ymd");
                    }

                    //임차일수
                    shtObj.SetCellValue(Row, "tax_day", addDateStr(startDate, endDate)) ;
                }
                else {
                    shtObj.SetCellValue(Row, "tax_day", "") ;
                }

                //직원 입력일때
                if(orgAuthPg != "A"){
                    if(shtObj.GetCellValue(Row, "rent_mon") != "" && shtObj.GetCellValue(Row, "tax_day") != ""){
                        var resultValue = shtObj.GetCellValue(Row, "rent_mon") * (shtObj.GetCellValue(Row, "tax_day") / addDateStr(shtObj.GetCellValue(Row, "con_s_ymd"), shtObj.GetCellValue(Row, "con_e_ymd")));
                        shtObj.SetCellValue(Row, "input_mon", resultValue) ;
                    }
                    else {
                        shtObj.SetCellValue(Row, "input_mon", "") ;
                    }
                }
                //담당자 입력일때
                else {
                    if(shtObj.GetCellValue(Row, "rent_mon") != "" && shtObj.GetCellValue(Row, "tax_day") != ""){
                        var resultValue = shtObj.GetCellValue(Row, "rent_mon") * (shtObj.GetCellValue(Row, "tax_day") / addDateStr(shtObj.GetCellValue(Row, "con_s_ymd"), shtObj.GetCellValue(Row, "con_e_ymd")));
                        shtObj.SetCellValue(Row, "appl_mon", resultValue) ;
                    }
                    else {
                        shtObj.SetCellValue(Row, "appl_mon", "") ;
                    }
                }
            }

            inputChangeAppl(shtObj,Col,Row);
        } catch(ex){
            alert("OnChange Event Error : " + ex);
        }
    }

    function sheet1_OnClick(Row, Col, Value) {
        try{
            if(sheet1.ColSaveName(Col) == "sDelete" ) tab_clickDelete(sheet1, Row);
        }catch(ex){
            alert("OnClick Event Error : " + ex);
        }
    }

    /*-----------------------------------------------------------------------------------------
    //임차차입금(대출기관), 저당차입금 이자상환액 --- end
    ------------------------------------------------------------------------------------------*/





    //기본데이터 조회
    function initDefaultData() {
        //도움말 조회
        var param1 = "searchWorkYy="+$("#searchWorkYy").val();
        param1 += "&queryId=getYeaDataHelpText";

        var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=A070",false);
        helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");

        //개인별 총급여
        var param2 = "searchWorkYy="+$("#searchWorkYy").val();
        param2 += "&searchAdjustType="+$("#searchAdjustType").val();
        param2 += "&searchSabun="+$("#searchSabun").val();
        param2 += "&queryId=getYeaDataPayTotMon";

        var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=1",false);
        paytotMonStr = nvl(result2.Data.paytot_mon,"");

        //총급여 확인 버튼 유무
        var result3 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
        yeaMonShowYn = nvl(result3[0].code_nm,"");

        //세대주 정보
        var param3 = "searchWorkYy="+$("#searchWorkYy").val();
        param3 += "&searchAdjustType="+$("#searchAdjustType").val();
        param3 += "&searchSabun="+$("#searchSabun").val();
        param3 += "&queryId=getYeaHouseOwner";

        var result3 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param3,false);
        houseOwnerYn    = nvl(result3.Data.house_owner_yn,"");
        houseGetYmd     = nvl(result3.Data.house_get_ymd,"");
        houseArea       = nvl(result3.Data.house_area,"");
        officialPrice   = nvl(result3.Data.official_price,"");
        houseCnt        = nvl(result3.Data.house_cnt,"");
    }

    //직원금액 입력시 담당자금액으로 셋팅 처리
    function inputChangeAppl(shtnm,colValue,rowValue){
        if(shtnm.ColSaveName(colValue) == "input_mon" || shtnm.ColSaveName(colValue) == "use_mon") {
            shtnm.SetCellValue(rowValue,"appl_mon", shtnm.GetCellValue(rowValue,colValue));
        }
    }

    //기본자료 설정.
    function sheetSet(){
        var comSheet = parent.commonSheet;

        if(comSheet.RowCount() > 0){
            $("#A070_15").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_15"),"input_mon") );
            $("#A070_17").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_17"),"input_mon") );
            $("#A070_16").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_16"),"input_mon") );
            $("#A070_22").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_22"),"input_mon") );
            $("#A070_23").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_23"),"input_mon") );

            //2015년 추가 내역 Start
            $("#A070_24").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_24"),"input_mon") );
            $("#A070_25").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_25"),"input_mon") );
            $("#A070_26").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_26"),"input_mon") );
            $("#A070_27").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_27"),"input_mon") );
            //2015년 추가 내역 End
        } else {
            $("#A070_15").val("");
            $("#A070_17").val("");
            $("#A070_16").val("");
            $("#A070_22").val("");
            $("#A070_23").val("");

            //2015년 추가 내역 Start
            $("#A070_24").val("");
            $("#A070_25").val("");
            $("#A070_26").val("");
            $("#A070_27").val("");
            //2015년 추가 내역 End

        }
    }

    //연말정산 안내
    function yeaDataExpPopup(title, helpText, height, width){
        var url     = "<%=jspPath%>/common/yeaDataExpPopup.jsp";
        openYeaDataExpPopup(url, width, height, title, helpText);
    }

    function addDateStr(sdate,edate){
        var startDt = new Date(Number(sdate.substring(0,4)),Number(sdate.substring(4,6))-1,Number(sdate.substring(6,8)));
        var endDt = new Date(Number(edate.substring(0,4)),Number(edate.substring(4,6))-1,Number(edate.substring(6,8)));

        resultDt = Math.floor(endDt.valueOf()/(24*60*60*1000)- startDt.valueOf()/(24*60*60*1000)) + 1;
        return resultDt;
    }

    function saveBefore(shtObj) {
        if(!parent.checkClose())return false;

        for( var i = 2; i < shtObj.LastRow()+2; i++) {
            if(shtObj.GetCellValue(i, "adj_input_type") == "07" || shtObj.GetCellValue(i, "appl_mon") == "0") continue;

            if( shtObj.GetCellValue(i, "sStatus") == "U" ||
                shtObj.GetCellValue(i, "sStatus") == "I" ||
                shtObj.GetCellValue(i, "sStatus") == "S" ) {
                if( shtObj.GetCellValue(i, "house_dec_cd") == "20") {
                    /* 무주택 세대주일 경우 등록 가능 */
                    /*
                    if( houseOwnerYn != "Y") {
                        alert( "월세액공제는 무주택 세대주 근로소득자에 한해서 등록 가능합니다. 주소사항 탭의 세대주여부를 확인하십시오." ) ;
                        //shtObj.SetCellValue(i, "house_dec_cd", "") ;
                        return false;
                    }
                    */
                    /* 총급여가 3000만원 이하일경우에 등록 가능 */
                    if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 50000000 ) {
                        alert( "주택입차차입금(거주자간)은 총급여액이 50,000,000원 이하인 근로소득자에 한해서 등록 가능합니다.\n - 총급여액 : "+ paytotMonStr ) ;
                        //shtObj.SetCellValue(i, "house_dec_cd", "") ;
                        return false;
                    }
                }
                else if(shtObj.GetCellValue(i, "house_dec_cd") == "60" ) {
                    /* 무주택 세대주일 경우 등록 가능 */
                    /*
                    if( houseOwnerYn != "Y") {
                        alert( "월세액공제는 무주택 세대주 근로소득자에 한해서 등록 가능합니다. 주소사항 탭의 세대주여부를 확인하십시오." ) ;
                        //shtObj.SetCellValue(i, "house_dec_cd", "") ;
                        return false;
                    }
                    */
                    /* 총급여가 7000만원 이하일경우에 등록 가능 */
                    if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 70000000 ) {
                        alert( "월세액공제는 총급여액이 70,000,000원 이하인 근로소득자에 한해서 등록 가능합니다.\n - 총급여액 : "+ paytotMonStr ) ;
                        //shtObj.SetCellValue(i, "house_dec_cd", "") ;
                        return false;
                    }
                }

                if( shtObj.GetCellValue(i, "house_dec_cd") == "30" || shtObj.GetCellValue(i, "house_dec_cd") == "40" ||
                        shtObj.GetCellValue(i, "house_dec_cd") == "50" || shtObj.GetCellValue(i, "house_dec_cd") == "53" ||
                        shtObj.GetCellValue(i, "house_dec_cd") == "55" ) {
                    /*  이자상환액일 경우 가입시작일  입력  */
                    if( shtObj.GetCellValue(i, "con_s_ymd") == "" ) {
                        alert("계약(가입)시작일을 입력하세요") ;
                        return false;
                    }

                }
            }
        }

        tab_setAdjInputType(orgAuthPg, shtObj);

        return true;
    }

    function sheetChangeCheck() {
        var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D")
        if ( 0 < iTemp ) return true;
        return false;
    }
</script>
</head>
<body  style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">

    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
    <input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
    <input type="hidden" id="searchSabun" name="searchSabun" value="" />
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">주택자금 ☞ <span id="houseInfo"></span>
                <a href="javascript:yeaDataExpPopup('주택자금', helpText, 570);" class="cute_gray authR">주택자금 안내</a>
            </li>
        </ul>
        </div>
    </div>
<!--     <table border="0" cellpadding="0" cellspacing="0" class="default outer"> -->
<!--     <colgroup> -->
<!--         <col width="16%" /> -->
<!--         <col width="16%" /> -->
<!--         <col width="16%" /> -->
<!--         <col width="16%" /> -->
<!--         <col width="16%" /> -->
<!--         <col width="16%" /> -->
<!--     </colgroup> -->
<!--     <tr> -->
<!--         <th class="center" >임차차입금(대출기관)</th> -->
<!--         <td class="right"> -->
<!--             <input id="A070_13" name="A070_13" type="text" class="text w50p right transparent" readonly />원 -->
<!--         </td> -->
<!--         <th class="center" >임차차입금(거주자)</th> -->
<!--         <td class="right"> -->
<!--             <input id="A070_19" name="A070_19" type="text" class="text w50p right transparent" readOnly />원 -->
<!--         </td> -->
<!--         <th class="center" >월세액</th> -->
<!--         <td class="right"> -->
<!--             <input id="A070_10" name="A070_10" type="text" class="text w50p right transparent" readOnly />원 -->
<!--         </td> -->
<!--     </tr> -->
<!--     </table> -->
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
    <colgroup>
        <col width="11%" />
        <col width="11%" />
        <col width="11%" />
        <col width="11%" />
        <col width="11%" />
        <col width="1!%" />
        <col width="11%" />
        <col width="11%" />
        <col width="" />
    </colgroup>
    <tr>
        <th class="center" colspan="9">저당차입금 이자상환액</th>
    </tr>
    <tr>
        <th class="center" colspan="3">2011년 이전 차입분</th>
        <th class="center" colspan="2">2012년 이후 차입분</th>
        <th class="center" colspan="5">2015년 이후 차입분</th>
    </tr>
    <tr>
        <th class="center">15년 미만</th>
        <th class="center">15년~29년</th>
        <th class="center">30년 이상</th>
        <th class="center">고정/비거치 상환</th>
        <th class="center">&nbsp;기타대출&nbsp;</th>
        <th class="center">&nbsp;15년이상 <br/> 고정&비거치 상환&nbsp;</th>
        <th class="center">&nbsp;15년이상 <br/> 고정/비거치 상환&nbsp;</th>
        <th class="center">&nbsp;15년이상 <br/> 기타대출&nbsp;</th>
        <th class="center">&nbsp;10년이상 <br/> 고정/비거치 상환&nbsp;</th>
    </tr>
    <tr>
        <td class="right">
            <input id="A070_17" name="A070_17" type="text" class="text w80 right transparent" readOnly/>원
        </td>
        <td class="right">
            <input id="A070_15" name="A070_15" type="text" class="text w60 right transparent" readOnly />원
        </td>
        <td class="right">
            <input id="A070_16" name="A070_16" type="text" class="text w60 right transparent" readOnly />원
        </td>
        <td class="right">
            <input id="A070_22" name="A070_22" type="text" class="text w80 right transparent" readOnly />원
        </td>
        <td class="right">
            <input id="A070_23" name="A070_23" type="text" class="text w60 right transparent" readOnly />원
        </td>
        <td class="right">
            <input id="A070_24" name="A070_24" type="text" class="text w60 right transparent" readOnly />원
        </td>
        <td class="right">
            <input id="A070_25" name="A070_25" type="text" class="text w60 right transparent" readOnly />원
        </td>
        <td class="right">
            <input id="A070_26" name="A070_26" type="text" class="text w60 right transparent" readOnly />원
        </td>
        <td class="right">
            <input id="A070_27" name="A070_27" type="text" class="text w60 right transparent" readOnly />원
        </td>
    </tr>
    </table>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">
                ※ 저당차입금 이자상환액
            </li>
            <li class="btn">
            <a href="javascript:doAction1('Search');"       class="basic authR">조회</a>
            <a href="javascript:doAction1('Insert');"       class="basic authA">입력</a>
            <span id="copyBtn_1">
            <a href="javascript:doAction1('Copy');"         class="basic authA">복사</a>
            </span>
            <a href="javascript:doAction1('Save');"         class="basic authA">저장</a>
            <a href="javascript:doAction1('Down2Excel');"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <div style="height:250px">
        <script type="text/javascript">createIBSheet("sheet1", "100%", "250px"); </script>
    </div>

<!--     <div class="outer"> -->
<!--         <div class="sheet_title"> -->
<!--         <ul> -->
<!--             <li class="txt"> -->
<!--                 ※ 월세액 :  -->
<!--                 <span>월세액 및 계약기간은 당해년도분이 아니라 전체 계약기간과 총 합계액을 입력하십시오.</span> -->
<!--                 <span id="paytotMonViewYn2"> -->
<!--                     <a href="javascript:paytotMonView(2, 70000000);" class="basic authA"><b><font class="red">[총급여 7천만원 초과여부]</font></b></a> -->
<!--                 </span> -->
<!--                 <span id="span_paytotMonView2" style="padding-right:50px;"></span> -->
<!--             </li> -->
<!--             <li class="btn"> -->
<!--             <a href="javascript:doAction2('Search');"       class="basic authR">조회</a> -->
<!--             <a href="javascript:doAction2('Insert');"       class="basic authA">입력</a> -->
<!--             <span id="copyBtn_2"> -->
<!--             <a href="javascript:doAction2('Copy');"         class="basic authA">복사</a> -->
<!--             </span> -->
<!--             <a href="javascript:doAction2('Save');"         class="basic authA">저장</a> -->
<!--             <a href="javascript:doAction2('Down2Excel');"   class="basic authR">다운로드</a> -->
<!--             </li> -->
<!--         </ul> -->
<!--         </div> -->
<!--     </div> -->
<!--     <div style="height:170px"> -->
<!--         <script type="text/javascript">createIBSheet("sheet2", "100%", "170px"); </script> -->
<!--     </div> -->

<!--     <div class="outer"> -->
<!--         <div class="sheet_title"> -->
<!--         <ul> -->
<!--             <li class="txt"> -->
<!--                 ※ 거주자간 주택임차차입금 원리금 상환액(금전소비대차 계약) : -->
<!--                 <span>해당연도 원리금만 입력하십시오.</span> -->
<!--                 <span id="paytotMonViewYn1"> -->
<!--                     <a href="javascript:paytotMonView(1,50000000);" class="basic authA"><b><font class="red">[총급여 5천만원 초과여부]</font></b></a> -->
<!--                 </span> -->
<!--                 <span id="span_paytotMonView1" ></span> -->
<!--             </li> -->
<!--             <li class="btn"> -->
<!--             <a href="javascript:doAction3('Search');"       class="basic authR">조회</a> -->
<!--             <a href="javascript:doAction3('Insert');"       class="basic authA">입력</a> -->
<!--             <span id="copyBtn_3"> -->
<!--             <a href="javascript:doAction3('Copy');"         class="basic authA">복사</a> -->
<!--             </span> -->
<!--             <a href="javascript:doAction3('Save');"         class="basic authA">저장</a> -->
<!--             <a href="javascript:doAction3('Down2Excel');"   class="basic authR">다운로드</a> -->
<!--             </li> -->
<!--         </ul> -->
<!--         </div> -->
<!--     </div> -->
<!--     <div style="height:170px"> -->
<!--         <script type="text/javascript">createIBSheet("sheet3", "100%", "170px"); </script> -->
<!--     </div> -->


<!--     <table border="0" cellpadding="0" cellspacing="0" class="default outer"> -->
<!--     <colgroup> -->
<!--         <col width="100" /> -->
<!--         <col width="150" /> -->
<!--         <col width="100" /> -->
<!--         <col width="100" /> -->
<!--         <col width="25%" /> -->
<!--         <col width="15%" /> -->
<!--         <col width="" /> -->
<!--     </colgroup> -->
<!--     <tr> -->
<!--         <th class="center" colspan=2>임대인</th> -->
<!--         <th class="center" rowspan=2>주택유형</th> -->
<!--         <th class="center" rowspan=2>주택계약면적</th> -->
<!--         <th class="center" rowspan=2>임대차계약서상주소지</th> -->
<!--         <th class="center" colspan=2>계약서상임대차 계약기간</th> -->
<!--         <th class="center" rowspan=2>전세보증금</th> -->
<!--     </tr> -->
<!--     <tr> -->

<!--         <th class="center" >성명</th> -->
<!--         <th class="center" >주민번호(사업자)</th> -->

<!--         <th class="center">개시일</th> -->
<!--         <th class="center">종료일</th> -->
<!--     </tr> -->
<!--     <tr> -->
<!--         <td class="right"> -->
<!--             <input id="A070_I23" name="A070_I23" type="text" class="text w100p center"  />  -->
<!--         </td> -->
<!--         <td class="right"> -->
<!--             <input id="A070_I24" name="A070_I24" type="text" class="text w100p center"  /> -->
<!--         </td> -->
<!--         <td class="right"> -->
<!--             <select id=A070_I25 name="A070_I25" ></select> -->
<!--         </td> -->
<!--         <td class="right"> -->
<!--             <input id="A070_I26" name="A070_I26" type="text" class="text w100p right" /> -->
<!--         </td> -->
<!--         <td class="right"> -->
<!--             <input id="A070_I27" name="A070_I27" type="text" class="text w100p center"  /> -->
<!--         </td> -->
<!--         <td class="right"> -->
<!--             <input id="A070_I28_1" name="A070_I28_1" type="text" class="date" /> -->
<!--         </td> -->
<!--         <td class="right"> -->
<!--             <input id="A070_I28_2" name="A070_I28_2" type="text" class="date" readOnly /> -->
<!--         </td> -->
<!--         <td class="right"> -->
<!--             <input id="A070_I29" name="A070_I29" type="text" class="text w100p right "  /> -->
<!--         </td> -->
<!--     </tr> -->
<!--     </table> -->


</div>
</body>
</html>