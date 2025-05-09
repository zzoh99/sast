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
    var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
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

        //$("#A070_I24").mask('0000000000000', {reverse: true});
        $("#A070_I26").keyup(function(){
            /*정수 10자리, 소수점 3째자리까지 입력되도록*/
            var strReg = /^(\d{1,9}([.]\d{0,3})?)?$/;
            if(!strReg.test( $("#A070_I26").val() )){
                $("#A070_I26").val("");
            }
        });
        $("#A070_I29").mask('000,000,000,000,000', {reverse: true});
        
        $("#A070_I23").change(function(){ sheet3.SetCellValue(sheet3.GetSelectRow(), "name_imdaein", $("#A070_I23").val()); });     
        $("#A070_I24").change(function(){ sheet3.SetCellValue(sheet3.GetSelectRow(), "res_no_imdaein", $("#A070_I24").val()); });       
        $("#A070_I25").change(function(){ sheet3.SetCellValue(sheet3.GetSelectRow(), "house_type", $("#A070_I25").val()); });       
        $("#A070_I26").change(function(){ sheet3.SetCellValue(sheet3.GetSelectRow(), "house_size", $("#A070_I26").val()); });
        $("#A070_I27").change(function(){ sheet3.SetCellValue(sheet3.GetSelectRow(), "address", $("#A070_I27").val()); });      
        $("#A070_I28_1").change(function(){ sheet3.SetCellValue(sheet3.GetSelectRow(), "con_s_ymd_imdae", $("#A070_I28_1").val()); });
        $("#A070_I28_2").change(function(){ sheet3.SetCellValue(sheet3.GetSelectRow(), "con_e_ymd_imdae", $("#A070_I28_2").val()); });      
        $("#A070_I29").change(function(){ sheet3.SetCellValue(sheet3.GetSelectRow(), "bojeong_mon", $("#A070_I29").val()); });
        
        $( "#A070_I28_1" ).datepicker({
            onClose: function( selectedDate ) { // 닫을때 이벤트
                $( "#A070_I28_2" ).datepicker( "option", "minDate", selectedDate );
            }
        });
    
        $( "#A070_I28_2" ).datepicker({
            onClose: function( selectedDate ) {
                $( "#A070_I28_1" ).datepicker( "option", "maxDate", selectedDate );
            }
        });
        
        

        //기본정보 조회(도움말 등등).
        initDefaultData() ;

        if(orgAuthPg == "A") {
            $("#copyBtn_1").show() ;
            $("#copyBtn_2").show() ;
            $("#copyBtn_3").show() ;
        } else {
            $("#copyBtn_1").hide() ;
            $("#copyBtn_2").hide() ;
            $("#copyBtn_3").hide() ;
        }

        //총급여 옵션이 Y이면 총급여 버튼 보여준다.
        if( yeaMonShowYn == "Y"){
        	$("#paytotMonViewYn1").show() ;
            $("#paytotMonViewYn2").show() ;
        }else if(yeaMonShowYn == "A"){
            if(orgAuthPg == "A") {
            	$("#paytotMonViewYn1").show() ;
                $("#paytotMonViewYn2").show() ;
            }else{
            	$("#paytotMonViewYn1").hide() ;
                $("#paytotMonViewYn2").hide() ;
            } 
            
        }else{
        	$("#paytotMonViewYn1").hide() ;
            $("#paytotMonViewYn2").hide() ;
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
    var houseTypeList;

    var loadSheet1Flag = false;
    var loadSheet2Flag = false;
    var loadSheet3Flag = false;
    
    if( orgAuthPg == "A") {
        inputEdit = 0 ;
        applEdit = 1 ;
    } else {
        inputEdit = 1 ;
        applEdit = 0 ;
    }
    
    $(function() {
        parent.doSearchCommonSheet();
        adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
        feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");
        houseTypeList    = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00323"), "");
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
        
        var houseDecCdList = stfConvCode( codeList("<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=selectHouseDecCdList&codeType=4",""), "");

        sheet1.SetColProperty("adj_input_type",     {ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
        sheet1.SetColProperty("house_dec_cd",       {ComboText:"|"+houseDecCdList[0], ComboCode:"|"+houseDecCdList[1]} );
        sheet1.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
        
        $(window).smartresize(sheetResize);
        sheetInit();
        
        doAction1("Search");
    }

    function loadSheet2() {

        //월세액  쉬트
        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata2.Cols = [
            {Header:"No|No",                                        Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:1, SaveName:"sNo" },
            {Header:"삭제|삭제",                                    Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
            {Header:"상태|상태",                                    Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
            {Header:"년도|년도",                                    Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"work_yy",         KeyField:0, Format:"",        UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분|정산구분",                            Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"adjust_type",     KeyField:0, Format:"",        UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"사번|사번",                                    Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"sabun",           KeyField:0, Format:"",        UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
            {Header:"주택자금공제구분|주택자금공제구분",            Type:"Combo",   Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"house_dec_cd",    KeyField:0, Format:"",        UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
            {Header:"순번|순번",                                    Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"seq",             KeyField:0, Format:"",        UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"임대인|성명",                                  Type:"Text",    Hidden:0,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"name_imdaein",    KeyField:1, Format:"",        UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"임대인|주민번호(사업자)",                      Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:1, SaveName:"res_no_imdaein",  KeyField:1, Format:"",        UpdateEdit:1,   InsertEdit:1,   EditLen:200},
            {Header:"주택유형|주택유형",                            Type:"Combo",   Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"house_type",      Format:"",  UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"주택계약\n면적(㎡)|주택계약\n면적(㎡)",        Type:"Float",   Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"house_size",      KeyField:1, Format:"#,###.###", PointCount:3,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"임대차계약서상 주소지|임대차계약서상 주소지",  Type:"Text",    Hidden:0,   Width:90,   Align:"Left",   ColMerge:1, SaveName:"address",         KeyField:1, Format:"",        UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"계약서상임대차계약기간|개시일",                Type:"Date",    Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"con_s_ymd",       KeyField:1, Format:"Ymd",     UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"계약서상임대차계약기간|종료일",                Type:"Date",    Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"con_e_ymd",       KeyField:1, Format:"Ymd",     UpdateEdit:1,   InsertEdit:1,   EditLen:8 },            
            {Header:"연간\n월세액|연간\n월세액",                    Type:"Int",     Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"rent_mon",        KeyField:1, Format:"Integer", UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"해당과세기간임차일수|해당과세기간임차일수",    Type:"Int",     Hidden:1,   Width:80,   Align:"Right",  ColMerge:1, SaveName:"tax_day",         KeyField:0, Format:"",        UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"월세대상금액|직원용",                          Type:"AutoSum", Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"input_mon",       KeyField:0, Format:"",        UpdateEdit:inputEdit,   InsertEdit:inputEdit,   EditLen:35 },
            {Header:"월세대상금액|담당자용",                        Type:"AutoSum", Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"appl_mon",        KeyField:1, Format:"",        UpdateEdit:applEdit,    InsertEdit:applEdit,    EditLen:35 },
            {Header:"자료입력유형|자료입력유형",                    Type:"Combo",   Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"adj_input_type",  KeyField:0, Format:"",        UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"담당자확인|담당자확인",                        Type:"Combo",   Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"feedback_type",   KeyField:0, Format:"",        UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
        ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

        var houseDecCdList = stfConvCode( codeList("<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=selectHouseDecCdList&codeType=2",""), "");

        sheet2.SetColProperty("adj_input_type",     {ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
        sheet2.SetColProperty("house_dec_cd",       {ComboText:houseDecCdList[0], ComboCode:houseDecCdList[1]} );
        sheet2.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
        sheet2.SetColProperty("house_type", {ComboText:"|"+houseTypeList[0], ComboCode:"|"+houseTypeList[1]} );
        
        $(window).smartresize(sheetResize);
        sheetInit();
        
        doAction2("Search");
    }

    function loadSheet3() {
        //거주자간 주택임차차입금 원리금 상환액(금전소비대차 계약) 쉬트
        var initdata3 = {};
        initdata3.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
        initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata3.Cols = [
            {Header:"No|No",                               Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:1, SaveName:"sNo" },
            {Header:"삭제|삭제",                           Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
            {Header:"상태|상태",                           Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
            {Header:"년도|년도",                           Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"work_yy",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분|정산구분",                   Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"adjust_type",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"사번|사번",                           Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"sabun",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
            {Header:"주택자금공제구분|주택자금공제구분",   Type:"Combo",   Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"house_dec_cd",    KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
            {Header:"순번|순번",                           Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"seq",             KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:35 },
            {Header:"대주|성명",                           Type:"Text",    Hidden:0,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"name_daeju",      KeyField:1, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"대주|주민번호",                       Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:1, SaveName:"res_no_daeju",    KeyField:1, Format:"IdNo",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:200, FullInput:1 },
            {Header:"금전소비대차계약기간|시작일",         Type:"Date",    Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"con_s_ymd",       KeyField:1, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"금전소비대차계약기간|종료일",         Type:"Date",    Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"con_e_ymd",       KeyField:1, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"차입금이자율|차입금이자율",           Type:"Float",   Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"chaib_rate",      KeyField:1, Format:"",      PointCount:2,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"원리금|원리금",                       Type:"Int",     Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"wonri_mon",       KeyField:1, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"이자|이자",                           Type:"Int",     Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"ija_mon",         KeyField:1, Format:"Float", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"원리금상환액계|직원용",               Type:"AutoSum", Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"input_mon",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:inputEdit,   InsertEdit:inputEdit,   EditLen:35 },
            {Header:"원리금상환액계|담당자용",             Type:"AutoSum", Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"appl_mon",        KeyField:1, Format:"",      PointCount:0,   UpdateEdit:applEdit,    InsertEdit:applEdit,    EditLen:35 },
            {Header:"자료입력유형|자료입력유형",           Type:"Combo",   Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"adj_input_type",  KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"거주자 주택임차차입금간 구분|거주자 주택임차차입금간 구분",  Type:"Text",    Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"keojuza_gubun",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"담당자확인|담당자확인",               Type:"Combo",   Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"feedback_type",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            
            {Header:"임대인|성명",                         Type:"Text",    Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"name_imdaein",    Format:"",      UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"임대인|주민번호(사업자)",             Type:"Text",    Hidden:1,   Width:70,   Align:"Center", ColMerge:1, SaveName:"res_no_imdaein",  Format:"",      UpdateEdit:1,   InsertEdit:1,   EditLen:20},
            {Header:"주택유형|주택유형",                   Type:"Text",    Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"house_type",      Format:"",      UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"주택계약면적|주택계약면적",           Type:"Float",   Hidden:1,   Width:90,   Align:"Center", ColMerge:1, SaveName:"house_size",      Format:"#,###.###", PointCount:3, UpdateEdit:1, InsertEdit:1,   EditLen:20 },
            {Header:"임대차계약서상 주소지|임대차계약서상 주소지",  Type:"Text",    Hidden:1,   Width:90,   Align:"Center", ColMerge:1, SaveName:"address",         Format:"",  UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"계약서상임대차계약기간|시작일",       Type:"Text",    Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"con_s_ymd_imdae", Format:"Ymd",   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"계약서상임대차계약기간|종료일",       Type:"Text",    Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"con_e_ymd_imdae", Format:"Ymd",   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"전세보증금|전세보증금",               Type:"Text",    Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"bojeong_mon",     Format:"",      UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
            
            
        ]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("<%=editable%>");sheet3.SetVisible(true);sheet3.SetCountPosition(4);

        var houseDecCdList = stfConvCode( codeList("<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=selectHouseDecCdList&codeType=3",""), "");

        sheet3.SetColProperty("adj_input_type",     {ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
        sheet3.SetColProperty("house_dec_cd",       {ComboText:houseDecCdList[0], ComboCode:houseDecCdList[1]} );
        sheet3.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
        
        $("#A070_I25").html("<option value=''>선  택</option>"+houseTypeList[2]);
        
        $(window).smartresize(sheetResize);
        sheetInit();
        
        doAction3("Search");
    }

    /*-----------------------------------------------------------------------------------------
    //임차차입금(대출기관) --- start
    ------------------------------------------------------------------------------------------*/
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=selectYeaDataHouList&codeType=4", $("#sheetForm").serialize() );
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
            if(loadSheet1Flag == false) {
                loadSheet2();
                loadSheet1Flag = true;
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
    
    
    /*-----------------------------------------------------------------------------------------
    //월세액  --- start
    ------------------------------------------------------------------------------------------*/
    function doAction2(sAction) {
        switch (sAction) {
        case "Search":
            sheet2.DoSearch( "<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=selectYeaDataHouList&codeType=2", $("#sheetForm").serialize() );
            break;
        case "Save":
            if ( !saveBefore(sheet2) ) return;
            
            sheet2.DoSave( "<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=saveYeaDataHou");
            break;
        case "Insert":
            if(!parent.checkClose())return;
            if(!rentInputCheck(70000000)) {
                /*
                alert("월세액 및 주택입차차입금(거주자간)의 대상은 다음과 같습니다. 주소사항 탭의 입력 내역을 확인하여 주십시오."
                + "\n 1. 주택수 요건 : 연말 현재 무주택"
                + "\n 2. 주택규모 : 국민주택규모이하(수도권: 85㎡, 수도권외 읍,면 등 : 100㎡)"
                + "\n 3. 종합소득금액 : 4천만원이하인 자(총급여액 : 52,368,421원 수준)");
                */
                
                alert("월세액의 대상은 다음과 같습니다. 주소사항 탭의 입력 내역을 확인하여 주십시오."
                    + "\n 1. 주택수 요건 : 연말 현재 무주택"
                    + "\n 2. 총급여 :7천만원이하인 자");
                
                return;
            }
            
            var newRow = sheet2.DataInsert(0) ;
            sheet2.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
            sheet2.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
            sheet2.SetCellValue( newRow, "sabun", $("#searchSabun").val() );

            tab_clickInsert(orgAuthPg, sheet2, newRow);
            break;
        case "Copy":
            var newRow = sheet2.DataCopy();
            sheet2.SelectCell(newRow, 2);
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet2);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet2.Down2Excel(param);
            break;
        }
    }

    //조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if (Code == 1) {
                for(var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++){
                    if ( !tab_setAuthEdtitable(orgAuthPg, sheet2, i) ) continue;
                    
                    if( sheet2.GetCellValue(i, "adj_input_type") == "02" ) {
                        if(orgAuthPg == "A") {
                            sheet2.SetCellEditable(i, "rent_mon", 1) ;
                        } else {
                            sheet2.SetCellEditable(i, "rent_mon", 0) ;
                        }
                    }
                }
            }
            if(loadSheet2Flag == false) {
                loadSheet3();
                loadSheet2Flag = true;
            }           
            setSheetSize(sheet2);
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            parent.getYearDefaultInfoObj();
            if(Code == 1) {
                parent.doSearchCommonSheet();
                doAction2("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    //값 변경시 발생
    function sheet2_OnChange(Row, Col, Value) {
        var shtObj = sheet2;
        
        // 성명에 특수문자 입력 방지
        if ( shtObj.ColSaveName(Col) == "name_imdaein" ) {
            if ( !checkMetaChar(shtObj.GetCellValue(Row,"name_imdaein")) ) {
                alert("특수문자는 입력 할 수 없습니다.");
                shtObj.SetCellValue(Row,Col,"");
            }
        }
        
        if( shtObj.ColSaveName(Col) == "res_no_imdaein" && shtObj.GetCellValue(Row,"res_no_imdaein")!= "" ){
            //if ( !checkIdNo(shtObj.GetCellValue(Row,"res_no_imdaein")) ) shtObj.SetCellValue(Row,"res_no_imdaein", "");
            Value = Value.replace(/-/gi, '');
            if(Value.length == 10) {
                if ( !checkBizID(shtObj.GetCellValue(Row,"res_no_imdaein")) ) {
                    if(!confirm("사업자등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?")) shtObj.SetCellValue(Row,"res_no_imdaein", "");
                    else {
                        //var info = {Format:"SaupNo"};
                        //shtObj.InitCellProperty(Row, "res_no_imdaein", info);
                        //shtObj.SetCellValue(Row, Col, Value.substr(0,3)+Value.substr(3,2)+Value.substr(5));
                        shtObj.SetCellText(Row, Col, Value.substr(0,3)+"-"+Value.substr(3,2)+"-"+Value.substr(5));
                    }
                } 
            } else if (Value.length == 13) {
                if ( !checkIdNo(shtObj.GetCellValue(Row,"res_no_imdaein")) ) shtObj.SetCellValue(Row,"res_no_imdaein", "");
                else { 
                    //var info = {Format:"IdNo"};
                    //shtObj.InitCellProperty(Row, "res_no_imdaein", info);
                    //shtObj.SetCellValue(Row, Col, Value.substr(0,6)+Value.substr(6));
                    shtObj.SetCellText(Row, Col, Value.substr(0,6)+"-"+Value.substr(6));
                } 
                
            } else {
                alert("입력값의 길이가 주민번호, 사업자등록번호 길이에 부적합합니다.");
                shtObj.SetCellValue(Row, Col, "");
            }           
        }
        
        if( shtObj.ColSaveName(Col) == "con_s_ymd" || shtObj.ColSaveName(Col) == "con_e_ymd" || shtObj.ColSaveName(Col) == "rent_mon"){

            var message = "계약기간의 ";
            checkNMDate(shtObj, Row, Col, message, "con_s_ymd", "con_e_ymd");

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
    }
    
    function sheet2_OnClick(Row, Col, Value) {
        try{
            if(sheet2.ColSaveName(Col) == "sDelete" ) tab_clickDelete(sheet2, Row);
        }catch(ex){
            alert("OnClick Event Error : " + ex);
        }
    }
    
    /*-----------------------------------------------------------------------------------------
    //월세액 --- end
    ------------------------------------------------------------------------------------------*/
    
    
    /*-----------------------------------------------------------------------------------------
    //거주자간 주택임차차입금 원리금 상환액(금전소비대차 계약) --- start
    ------------------------------------------------------------------------------------------*/
    function doAction3(sAction) {
        switch (sAction) {
        case "Search":
            sheet3.DoSearch( "<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=selectYeaDataHouList&codeType=3", $("#sheetForm").serialize() );
            break;
        case "Save":

            var selectRow = sheet3.GetSelectRow();
            
            sheet3.SetCellValue( selectRow, "name_imdaein",     $("#A070_I23").val() );
            sheet3.SetCellValue( selectRow, "res_no_imdaein",   $("#A070_I24").val() );
            sheet3.SetCellValue( selectRow, "house_type",       $("#A070_I25").val() );
            sheet3.SetCellValue( selectRow, "house_szie",       $("#A070_I26").val() );
            sheet3.SetCellValue( selectRow, "address",          $("#A070_I27").val() );
            sheet3.SetCellValue( selectRow, "con_s_ymd_imdae",  $("#A070_I28_1").val() );
            sheet3.SetCellValue( selectRow, "con_e_ymd_imdae",  $("#A070_I28_2").val() );
            sheet3.SetCellValue( selectRow, "bojeong_mon",      $("#A070_I29").val() );
            
            
            if ( !saveBefore(sheet3) ) return;

            sheet3.DoSave( "<%=jspPath%>/yeaData/yeaDataHouRst.jsp?cmd=saveYeaDataHou");
            break;
        case "Insert":
            if(!parent.checkClose())return;
            if(!rentInputCheck(50000000)) {
                
                /*
                alert("월세액 및 주택입차차입금(거주자간)의 대상은 다음과 같습니다. 주소사항 탭의 입력 내역을 확인하여 주십시오."
                    + "\n 1. 주택수 요건 : 연말 현재 무주택"
                    + "\n 2. 주택규모 : 국민주택규모이하(수도권: 85㎡, 수도권외 읍,면 등 : 100㎡)"
                    + "\n 3. 종합소득금액 : 4천만원이하인 자(총급여액 : 52,368,421원 수준)");
                */
                alert("주택입차차입금(거주자간)의 대상은 다음과 같습니다.\n주소사항 탭의 입력 내역을 확인하여 주십시오."
                        + "\n 1. 주택수 요건 : 연말 현재 무주택"
                        + "\n 2. 주택규모 : 국민주택규모이하(수도권: 85㎡, 수도권외 읍,면 등 : 100㎡)"
                        + "\n 3. 총급여 : 5천만원이하인 자");
                return;
            }
            
            var newRow = sheet3.DataInsert(0) ;
            sheet3.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
            sheet3.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
            sheet3.SetCellValue( newRow, "sabun", $("#searchSabun").val() );
            
            sheet3.SetCellValue(newRow, "keojuza_gubun", "1");
            
            tab_clickInsert(orgAuthPg, sheet3, newRow);
            break;
        case "Copy":
            var newRow = sheet3.DataCopy();
            sheet3.SelectCell(newRow, 2);
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet3);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet3.Down2Excel(param);
            break;
        }
    }

    //조회 후 에러 메시지
    function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if (Code == 1) {
                for(var i = sheet3.HeaderRows(); i <= sheet3.LastRow(); i++){
                    if ( !tab_setAuthEdtitable(orgAuthPg, sheet3, i) ) continue;
                    
                    if( sheet3.GetCellValue(i, "adj_input_type") == "02" ) {
                        if(orgAuthPg == "A") {
                            sheet3.SetCellEditable(i, "wonri_mon", 1) ;
                            sheet3.SetCellEditable(i, "ija_mon", 1) ;
                        } else {
                            sheet3.SetCellEditable(i, "wonri_mon", 0) ;
                            sheet3.SetCellEditable(i, "ija_mon", 0) ;
                        }
                    }
                }
            }
            if(loadSheet3Flag == false) {
                //loadSheet4();
                loadSheet3Flag = true;
            }
            
            if(sheet3.RowCount() == 0) {
                $("#A070_I23").val("");
                $("#A070_I24").val("");
                $("#A070_I25").val("");
                $("#A070_I26").val("");
                $("#A070_I27").val("");
                $("#A070_I28_1").val("");
                $("#A070_I28_2").val("");
                $("#A070_I29").val("");
            } else {
                $("#A070_I23").val(sheet3.GetCellValue(sheet3.GetSelectRow(),"name_imdaein"));
                $("#A070_I24").val(sheet3.GetCellValue(sheet3.GetSelectRow(),"res_no_imdaein"));
                $("#A070_I25").val(sheet3.GetCellValue(sheet3.GetSelectRow(),"house_type"));
                $("#A070_I26").val(sheet3.GetCellText(sheet3.GetSelectRow(),"house_size"));
                $("#A070_I27").val(sheet3.GetCellValue(sheet3.GetSelectRow(),"address"));
                $("#A070_I28_1").val(sheet3.GetCellText(sheet3.GetSelectRow(),"con_s_ymd_imdae"));
                $("#A070_I28_2").val(sheet3.GetCellText(sheet3.GetSelectRow(),"con_e_ymd_imdae"));
                $("#A070_I29").val(sheet3.GetCellText(sheet3.GetSelectRow(),"bojeong_mon"));
            }
            
            setSheetSize(sheet3);
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            parent.getYearDefaultInfoObj();
            alertMessage(Code, Msg, StCode, StMsg);

            if(Code == 1) {
                parent.doSearchCommonSheet();
                doAction3("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    //값 변경시 발생
    function sheet3_OnChange(Row, Col, Value) {
        var shtObj = sheet3;
        
        // 성명에 특수문자 입력 방지
        if ( shtObj.ColSaveName(Col) == "name_imdaein" ) {
            if ( !checkMetaChar(shtObj.GetCellValue(Row,"name_imdaein")) ) {
                alert("특수문자는 입력 할 수 없습니다.");
                shtObj.SetCellValue(Row,Col,"");
            }
        }
        
        if( shtObj.ColSaveName(Col) == "res_no_imdaein" && shtObj.GetCellValue(Row,"res_no_imdaein")!= "" ){
            //if ( !checkIdNo(shtObj.GetCellValue(Row,"res_no_imdaein")) ) shtObj.SetCellValue(Row,"res_no_imdaein", "");
            var inputBoxTxt = "";           
            Value = Value.replace(/-/gi, '');
            if(Value.length == 10) {
                if ( !checkBizID(shtObj.GetCellValue(Row,"res_no_imdaein")) ) {
                    if(!confirm("사업자등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?")) shtObj.SetCellValue(Row,"res_no_imdaein", "");
                    else {
                        var info = {Format:"SaupNo"};
                        shtObj.InitCellProperty(Row, "res_no_imdaein", info);
                        //shtObj.SetCellValue(Row, Col, Value.substr(0,3)+Value.substr(3,2)+Value.substr(5));
                        //shtObj.SetCellText(Row, Col, Value.substr(0,3)+"-"+Value.substr(3,2)+"-"+Value.substr(5));
                        inputBoxTxt = Value.substr(0,3)+"-"+Value.substr(3,2)+"-"+Value.substr(5);
                    }
                } 
            } else if (Value.length == 13) {
                if ( !checkIdNo(shtObj.GetCellValue(Row,"res_no_imdaein")) ) shtObj.SetCellValue(Row,"res_no_imdaein", "");
                else { 
                    var info = {Format:"IdNo"};
                    shtObj.InitCellProperty(Row, "res_no_imdaein", info);
                    //shtObj.SetCellValue(Row, Col, Value.substr(0,6)+Value.substr(6));
                    //shtObj.SetCellText(Row, Col, Value.substr(0,6)+"-"+Value.substr(6));
                    inputBoxTxt = Value.substr(0,6)+"-"+Value.substr(6);
                }
                
            } else {
                alert("입력값의 길이가 주민번호, 사업자등록번호 길이에 부적합합니다.");
                shtObj.SetCellValue(Row, Col, "");
            }
            $("#A070_I24").val(inputBoxTxt);
        }
        
        if( shtObj.ColSaveName(Col) == "con_s_ymd" || shtObj.ColSaveName(Col) == "con_e_ymd" ){
            var message = "계약기간의 ";
            checkNMDate(shtObj, Row, Col, message, "con_s_ymd", "con_e_ymd");
        }
        
        if( shtObj.ColSaveName(Col) == "wonri_mon" || shtObj.ColSaveName(Col) == "ija_mon" ){
            var sumValue = shtObj.GetCellValue(Row, "wonri_mon") + shtObj.GetCellValue(Row, "ija_mon");
            
            //직원 입력일때
            if(orgAuthPg != "A"){
                shtObj.SetCellValue(Row, "input_mon", sumValue) ;
            }
            //담당자 입력일때
            else {
                shtObj.SetCellValue(Row, "appl_mon", sumValue) ;
            }
        }
        
        inputChangeAppl(shtObj,Col,Row);
    }
    
    function sheet3_OnClick(Row, Col, Value) {
        try{
            if(sheet3.ColSaveName(Col) == "sDelete" ) tab_clickDelete(sheet3, Row);
            
        }catch(ex){
            alert("OnClick Event Error : " + ex);
        }
    }
    

    function sheet3_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
        try{
            //if(OldRow != NewRow){
                $("#A070_I23").val(sheet3.GetCellValue(NewRow,"name_imdaein"));
                $("#A070_I24").val(sheet3.GetCellValue(NewRow,"res_no_imdaein"));
                $("#A070_I25").val(sheet3.GetCellValue(NewRow,"house_type"));
                $("#A070_I26").val(sheet3.GetCellText(NewRow,"house_size"));
                $("#A070_I27").val(sheet3.GetCellValue(NewRow,"address"));
                $("#A070_I28_1").val(sheet3.GetCellText(NewRow,"con_s_ymd_imdae"));
                $("#A070_I28_2").val(sheet3.GetCellText(NewRow,"con_e_ymd_imdae"));
                $("#A070_I29").val(sheet3.GetCellText(NewRow,"bojeong_mon"));
            //}
        }catch(ex){alert("OnSelectCell Event Error : " + ex);}
    }
    
    /*-----------------------------------------------------------------------------------------
    //거주자간 주택임차차입금 원리금 상환액(금전소비대차 계약) --- end
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
            $("#A070_10").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_10"),"input_mon") );
            $("#A070_13").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_13"),"input_mon") );
            $("#A070_19").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A070_19"),"input_mon") );
        } else {
            $("#A070_10").val("");
            $("#A070_13").val("");
            $("#A070_19").val("");
        }
    }

    //연말정산 안내
    function yeaDataExpPopup(title, helpText, height, width){
        var url     = "<%=jspPath%>/common/yeaDataExpPopup.jsp";
        openYeaDataExpPopup(url, width, height, title, helpText);
    }

    //[총급여] 보이기
    function paytotMonView(obj1, obj2){
        if(paytotMonStr != ""){
            //if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 52368421 ) {
            if( ( paytotMonStr.replace(/,/gi, "") *1 ) > obj2 ) {
                $("#span_paytotMonView"+obj1).html("<B>YES</B>&nbsp;<a href='javascript:paytotMonViewClose("+obj1+")' ><font color='red'>[닫기]</font></a>") ;
            } else {
                $("#span_paytotMonView"+obj1).html("<B>NO</B>&nbsp;<a href='javascript:paytotMonViewClose("+obj1+")' ><font color='red'>[닫기]</font></a>") ;
            }
        } else {
            alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
        }
    }

    //[총급여] 닫기
    function paytotMonViewClose(obj1){
        $("#span_paytotMonView"+obj1).html("");
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
    
    function rentInputCheck(obj) {
        // 월세, 거주자간 주택임차차입금 원리금 상환액(금전소비대차 계약), 거주자간 주택임차차입금 원리금 상환액(임대차 계약)
        /*
        6. 체크로직 : 임대차 계약기간에 따라 직원용 금액이 자동으로 계산되는 로직은 그대로 갖고 오기
        입력버튼을 누를 때, 세대주에 체크 안되어 있거나, 무주택이 아니거나, 총급여액 5천만원이 넘는 자 아래의 안내멘트 추가와 함께 입력불가능
        ""월세액 및 주택입차차입금(거주자간)의 대상은 다음과 같습니다. 주소사항 탭의 입력 내역을 확인하여 주십시오.
        1. 세대주 요건 : 연말 현재 세대주
        2. 주택수 요건 : 연말 현재 무주택
        3. 주택규모 : 국민주택규모이하(수도권: 85㎡, 수도권외 읍,면 등 : 100㎡)
        4. 총급여액 : 5천만원이하인 자""
        */
        
        /*  무주택 세대주일 경우  등록 가능 */
        /* 세대원도 신청 가능하므로 주석처리함(2014.04.16)
        if(houseOwnerYn != "Y" || houseCnt != "0") {
            return false;
        }
        */
        
        //거주자간 주택임차차입금일 경우 국민주택규모이하 체크
        if ( obj == 50000000 ) {
            if( houseArea > 100 ) {
                return false;
            }
        }
            
        /*  총급여가 5000만원 이하일경우에 등록 가능 , 2012년 개정
        if( (paytotMonStr.replace(/,/gi, "")*1) > 52368421) {
            return false;
        }*/
        
        //거주자간 주택임차차입금 원리금 상환액:50000000, 월세액:70000000
        if( (paytotMonStr.replace(/,/gi, "")*1) > obj) {
            return false;
        }
        
        return true;
    }
    
    function checkIdNo(pIdNo) {
        if(pIdNo!= ""){
            //주민번호 유효성체크
            var rResNo = pIdNo;

            //외국인 주민번호 체크
            if(rResNo.substring(6,7) == "5"
                    || rResNo.substring(6,7) == "6"
                    || rResNo.substring(6,7) == "7"
                    || rResNo.substring(6,7) == "8"){

                if(fgn_no_chksum(rResNo) == true){
                } else{
                    return confirm("등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?");
                }
            } else {
                if(checkRegNo(rResNo.substring(0,6), rResNo.substring(6,13)) == true){
                } else{
                    return confirm("주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?");
                }
            }
        }
        
        return true;
    }
    
    function sheetChangeCheck() {
        var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D")
            + sheet2.RowCount("I") + sheet2.RowCount("U") + sheet2.RowCount("D")
            + sheet3.RowCount("I") + sheet3.RowCount("U") + sheet3.RowCount("D");
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
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
    <colgroup>
        <col width="16%" />
        <col width="16%" />
        <col width="16%" />
        <col width="16%" />
        <col width="16%" />
        <col width="16%" />
    </colgroup>
    <tr>
        <th class="center" >임차차입금(대출기관)</th>
        <td class="right">
            <input id="A070_13" name="A070_13" type="text" class="text w50p right transparent" readonly />원
        </td>
        <th class="center" >임차차입금(거주자)</th>
        <td class="right">
            <input id="A070_19" name="A070_19" type="text" class="text w50p right transparent" readOnly />원
        </td>
        <th class="center" >월세액</th>
        <td class="right">
            <input id="A070_10" name="A070_10" type="text" class="text w50p right transparent" readOnly />원
        </td>
    </tr>
    </table>
    
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">
                ※ 임차차입금(대출기관)
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
    <div style="height:300px">
        <script type="text/javascript">createIBSheet("sheet1", "100%", "300px"); </script>
    </div>
    
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt"> 
                ※ 월세액 : 
                <span>월세액 및 계약기간은 당해년도분이 아니라 전체 계약기간과 총 합계액을 입력하십시오.</span>
                <span id="paytotMonViewYn2">
                    <a href="javascript:paytotMonView(2, 70000000);" class="basic authA"><b><font color="red">[총급여 7천만원 초과여부]</font></b></a>
                </span>
                <span id="span_paytotMonView2" style="padding-right:50px;"></span>
            </li>
            <li class="btn">
            <a href="javascript:doAction2('Search');"       class="basic authR">조회</a>
            <a href="javascript:doAction2('Insert');"       class="basic authA">입력</a>
            <span id="copyBtn_2">
            <a href="javascript:doAction2('Copy');"         class="basic authA">복사</a>
            </span>
            <a href="javascript:doAction2('Save');"         class="basic authA">저장</a>
            <a href="javascript:doAction2('Down2Excel');"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div> 
    <div style="height:300px">
        <script type="text/javascript">createIBSheet("sheet2", "100%", "300px"); </script>
    </div>
    
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">
                ※ 거주자간 주택임차차입금 원리금 상환액(금전소비대차 계약) :
                <span>해당연도 원리금만 입력하십시오.</span>
                <span id="paytotMonViewYn1">
                    <a href="javascript:paytotMonView(1,50000000);" class="basic authA"><b><font color="red">[총급여 5천만원 초과여부]</font></b></a>
                </span>
                <span id="span_paytotMonView1" ></span>
            </li>
            <li class="btn">
            <a href="javascript:doAction3('Search');"       class="basic authR">조회</a>
            <a href="javascript:doAction3('Insert');"       class="basic authA">입력</a>
            <span id="copyBtn_3">
            <a href="javascript:doAction3('Copy');"         class="basic authA">복사</a>
            </span>
            <a href="javascript:doAction3('Save');"         class="basic authA">저장</a>
            <a href="javascript:doAction3('Down2Excel');"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <div style="height:300px">
        <script type="text/javascript">createIBSheet("sheet3", "100%", "300px"); </script>
    </div>
    
    
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
    <colgroup>
        <col width="100" />
        <col width="150" />
        <col width="100" />
        <col width="100" />
        <col width="25%" />
        <col width="15%" />
        <col width="" />
    </colgroup>
    <tr>
        <th class="center" colspan=2>임대인</th>
        <th class="center" rowspan=2>주택유형</th>
        <th class="center" rowspan=2>주택계약면적</th>
        <th class="center" rowspan=2>임대차계약서상주소지</th>
        <th class="center" colspan=2>계약서상임대차 계약기간</th>
        <th class="center" rowspan=2>전세보증금</th>
    </tr>
    <tr>

        <th class="center" >성명</th>
        <th class="center" >주민번호(사업자)</th>

        <th class="center">개시일</th>
        <th class="center">종료일</th>
    </tr>
    <tr>
        <td class="right">
            <input id="A070_I23" name="A070_I23" type="text" class="text w100p center"  /> 
        </td>
        <td class="right">
            <input id="A070_I24" name="A070_I24" type="text" class="text w100p center"  />
        </td>
        <td class="right">
            <select id=A070_I25 name="A070_I25" ></select>
        </td>
        <td class="right">
            <input id="A070_I26" name="A070_I26" type="text" class="text w100p right" />
        </td>
        <td class="right">
            <input id="A070_I27" name="A070_I27" type="text" class="text w100p center"  />
        </td>
        <td class="right">
            <input id="A070_I28_1" name="A070_I28_1" type="text" class="date" />
        </td>
        <td class="right">
            <input id="A070_I28_2" name="A070_I28_2" type="text" class="date" readOnly />
        </td>
        <td class="right">
            <input id="A070_I29" name="A070_I29" type="text" class="text w100p right "  />
        </td>
    </tr>
    </table>
        
    
</div>
</body>
</html>