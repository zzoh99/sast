<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>의료비</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%@ include file="yeaDataCommon.jsp"%>

<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<script type="text/javascript">
    var orgAuthPg = "<%=removeXSS(orgAuthPg, '1')%>";
    //도움말
    var helpText;
    //기준년도
    var systemYY;
    //총급여 확인 버튼 보여주기 유무 정보에 따라 컨트롤
    var yeaMonShowYn;
    //총급여
    var paytotMonStr;

    $(function() {
        /*필수 기본 세팅*/
        $("#searchWorkYy").val(     $("#searchWorkYy", parent.document).val()       ) ;
        $("#searchAdjustType").val( $("#searchAdjustType", parent.document).val()   ) ;
        $("#searchSabun").val(      $("#searchSabun", parent.document).val()        ) ;
        systemYY = $("#searchWorkYy", parent.document).val();

        //기본정보 조회(도움말 등등).
        initDefaultData() ;
<%--
        if(orgAuthPg == "A") {
            $("#copyBtn").show() ;
        } else {
            $("#copyBtn").hide() ;
        }
--%>
        //총급여 옵션이 Y이면 총급여 버튼 보여준다.
        if( yeaMonShowYn == "Y"){
        	$("#paytotMonViewYn").show() ;
        }else if(yeaMonShowYn == "A"){
            if(orgAuthPg == "A") {
            	$("#paytotMonViewYn").show() ;
            }else{
            	$("#paytotMonViewYn").hide() ;
            } 
        }else{
        	$("#paytotMonViewYn").hide() ;
        }
    });

    $(function() {
    	<%--
		var inputEdit = 0 ;
		var applEdit = 0 ;
		if( orgAuthPg == "A") {
			inputEdit = 0 ;
			applEdit = 1 ;
		} else {
			inputEdit = 1 ;
			applEdit = 0 ;
		}
--%>
<%
String inputEdit = "0", applEdit = "0";
if( "Y".equals(adminYn) ) {
	inputEdit = "0";
	applEdit = "1";
} else{
	inputEdit = "1";
	applEdit = "0";
}
%>

        //연말정산 가족 쉬트.
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"No",             Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"삭제",           Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"상태",           Type:"<%=sSttTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"년도",           Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"work_yy",             KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분",       Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adjust_type",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"사번",           Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"sabun",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
            {Header:"관계",           Type:"Text",        Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"fam_cd",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"성명",           Type:"Text",        Hidden:0,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"fam_nm",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"주민등록번호",   Type:"Text",        Hidden:0,   Width:90,   Align:"Center", ColMerge:0, SaveName:"famres",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200 },
            {Header:"학력",           Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"aca_cd",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"기본\n공제",     Type:"CheckBox",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"dpndnt_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"배우자\n공제",   Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"spouse_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"경로\n우대",     Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"senior_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"장애인\n공제",   Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"hndcp_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"장애\n구분",     Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"hndcp_type",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"부녀자\n공제",   Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"woman_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"자녀\n양육",     Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"child_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"출산\n입양",     Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"adopt_born_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"사업장",         Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"business_place_cd",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"보험료",         Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"insurance_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"의료비",         Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"medical_yn",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"교육비",         Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"education_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"신용\n카드등",   Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"credit_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        //연말정산 의료비 쉬트
        var initdata2 = {};
        initdata2.Cfg = {FrozenCol:9,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata2.Cols = [
            {Header:"No|No",                                       Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:1, SaveName:"sNo" },
            {Header:"삭제|삭제",                                   Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
            {Header:"상태|상태",                                   Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
			{Header:"DOC_SEQ|DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL|DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
            {Header:"년도|년도",                                   Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"work_yy",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분|정산구분",                           Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"adjust_type",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"사번|사번",                                   Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"sabun",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
            {Header:"순서|순서",                                   Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"seq",             KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"지급일자|지급일자",                           Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"ymd",             KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"성명|성명",                                   Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"fam_nm",          KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200 },
            {Header:"주민등록번호|주민등록번호",                   Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"famres",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"구분|구분",                                   Type:"Combo",       Hidden:0,   Width:100,  Align:"Center", ColMerge:1, SaveName:"special_yn",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1, EditLen:10 },
            {Header:"구분|구분",                                   Type:"Combo",       Hidden:1,   Width:100,  Align:"Center", ColMerge:1, SaveName:"special_yn_old",  KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1, EditLen:10 },
            {Header:"관계|관계",                                   Type:"Combo",       Hidden:0,   Width:70,   Align:"Center", ColMerge:1, SaveName:"adj_fam_cd",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"의료비\n증빙코드|의료비\n증빙코드",               Type:"Combo",       Hidden:0,   Width:70,   Align:"Left",   ColMerge:1, SaveName:"medical_imp_cd",  KeyField:1, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"상세구분|상세구분",                           Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"restrict_cd",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"재가/시설\n급여|재가/시설\n급여",              Type:"Combo",       Hidden:0,   Width:70,   Align:"Center", ColMerge:1, SaveName:"medical_type",    KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"사업자번호|사업자번호",                       Type:"Text",        Hidden:0,   Width:110,   Align:"Center", ColMerge:1, SaveName:"enter_no",        KeyField:0, Format:"SaupNo",PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"상호|상호",                                   Type:"Text",        Hidden:0,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"firm_nm",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:200 },
            {Header:"의료비내용|의료비내용",                       Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"contents",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
            {Header:"건수|건수",                                   Type:"Int",         Hidden:0,   Width:50,   Align:"Right",  ColMerge:1, SaveName:"cnt",             KeyField:1, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"금액자료|직원용",                             Type:"AutoSum",     Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"input_mon",       KeyField:0, Format:"#,###",      PointCount:0,   UpdateEdit:<%=inputEdit%>,   InsertEdit:<%=inputEdit%>,   EditLen:35, MinimumValue: 0 },
            {Header:"금액자료|담당자용",                           Type:"AutoSum",     Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"appl_mon",        KeyField:1, Format:"#,###",      PointCount:0,   UpdateEdit:<%=applEdit%>,    InsertEdit:<%=applEdit%>,    EditLen:35, MinimumValue: 0 },
            {Header:"자료입력유형|자료입력유형",                   Type:"Combo",       Hidden:0,   Width:70,   Align:"Right",  ColMerge:1, SaveName:"adj_input_type",  KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"난임시술비\n해당여부|난임시술비\n해당여부",   Type:"CheckBox",    Hidden:0,   Width:80,   Align:"Center", ColMerge:1, SaveName:"nanim_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"국세청\n자료여부|국세청\n자료여부",           Type:"CheckBox",    Hidden:0,   Width:70,   Align:"Center", ColMerge:1, SaveName:"nts_yn",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"담당자확인|담당자확인",                       Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"feedback_type",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
        ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

        var famList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList",$("#sheetForm").serialize(),false).codeList, "");
        var medicalImpCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00308"), "");
        var restrictCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00340"), "");
        var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
        var famCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00309"), "");
        var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");

        sheet2.SetColProperty("special_yn",     {ComboText:" |65세이상|장애인|건강보험산정특례자|본인", ComboCode:" |B|A|K|C"} );
        sheet2.SetColProperty("special_yn_old", {ComboText:" |65세이상|장애인|건강보험산정특례자|본인", ComboCode:" |B|A|K|C"} );
        
        sheet2.SetColProperty("medical_type",   {ComboText:" |재가급여|시설급여", ComboCode:" |1|2"} );
        sheet2.SetColProperty("fam_nm",         {ComboText:"|"+famList[0], ComboCode:"|"+famList[1]} );
        sheet2.SetColProperty("adj_fam_cd", {ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );

        sheet2.SetColProperty("medical_imp_cd", {ComboText:"|"+medicalImpCdList[0], ComboCode:"|"+medicalImpCdList[1]} );
        sheet2.SetColProperty("restrict_cd",    {ComboText:"|"+restrictCdList[0], ComboCode:"|"+restrictCdList[1]} );
        sheet2.SetColProperty("adj_input_type", {ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
        sheet2.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
        
        sheet2.SetRangeBackColor(0,0,1, sheet2.LastCol(),"<%=headerColorA%>") ;

        $(window).smartresize(sheetResize);
        sheetInit();

        parent.doSearchCommonSheet();
        doAction1("Search");
    });

    //연말정산 가족
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=selectYeaDataPerList", $("#sheetForm").serialize() );
            break;
        }
    }
    

    //연말정산 의료비
    function doAction2(sAction) {
        switch (sAction) {
        case "Search":
            sheet2.DoSearch( "<%=jspPath%>/yeaData/yeaDataMedRst.jsp?cmd=selectYeaDataMedList", $("#sheetForm").serialize() );
            break;
        case "Save":
            if(!parent.checkClose())return;

            //사업자 번호 체크
            for( var i = 2; i < sheet2.LastRow()+2; i++) {
                if(sheet2.GetCellValue(i, "adj_input_type") == "07" || sheet2.GetCellValue(i, "appl_mon") == "0") continue;
            
                if( sheet2.GetCellValue(i, "sStatus") == "U" ||
                    sheet2.GetCellValue(i, "sStatus") == "I" ||
                    sheet2.GetCellValue(i, "sStatus") == "S" ) {

                    if( sheet2.GetCellValue(i, "fam_nm") == "" ) {
                        alert("성명을 선택해 주십시오.") ;
                        sheet2.SelectCell(i, "fam_nm") ;
                        return;
                    }

                    if( sheet2.GetCellValue(i, "medical_imp_cd") == "" ) {
                        alert("의료증빙코드를 입력해 주십시오.") ;
                        sheet2.SelectCell(i, "medical_imp_cd") ;
                        return ;
                    }
                    if( sheet2.GetCellValue(i, "medical_imp_cd") == "4" && sheet2.GetCellValue(i, "medical_type") == "" ) {
                        alert("재가/시설급여에 대한 구분을 선택하세요.") ;
                        sheet2.SelectCell(i, "medical_type") ;
                        return ;
                    }

                    if( sheet2.GetCellValue(i, "medical_imp_cd") != "1" ) {

                        var fResNo = sheet2.GetCellValue(i, "enter_no") ;

                        if( fResNo == "" ) {
                            alert("사업자 번호를 입력해 주십시오.") ;
                            sheet2.SelectCell(i, "enter_no") ;
                            return ;
                        }
                        if( sheet2.GetCellValue(i, "firm_nm") == "" ) {
                            alert("상호를 입력해 주십시오.") ;
                            sheet2.SelectCell(i, "firm_nm") ;
                            return ;
                        }

                        if( parseInt( sheet2.GetCellValue(i, "cnt") , 10) < 1 ) {
                            alert("건수는 0보다 커야합니다.") ;
                            sheet2.SelectCell(i, "cnt") ;
                            return ;
                        }

                        if( sheet2.GetCellValue(i, "medical_imp_cd") == "5" ) {
                            if( sheet2.GetCellValue(i, "restrict_cd") == ""  ) {
                                alert("기타의료비 영수증 상세구분코드를 선택 해 주십시오.") ;
                                sheet2.SelectCell(i, "restrict_cd") ;
                                return ;
                            }
                            if( sheet2.GetCellValue(i, "restrict_cd") == "10" && parseInt( sheet2.GetCellValue(i, "appl_mon") , 10) > 500000  ) {
                                alert("기타의료비 영수증 안경구입비 입력금액 한도는 개인별 최대 50만원까지 가능합니다.") ;
                                return ;
                            }
                        }
                    } else {
                        //sheet2.SetCellValue(i, "enter_no", "") ;
                    }
                }
            }

            tab_setAdjInputType(orgAuthPg, sheet2);

            sheet2.DoSave( "<%=jspPath%>/yeaData/yeaDataMedRst.jsp?cmd=saveYeaDataMed&orgAuthPg="+orgAuthPg);
            break;
        case "Insert":
            if(!parent.checkClose())return;

            var newRow = sheet2.DataInsert(0) ;
            sheet2.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() ) ;
            sheet2.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() ) ;
            sheet2.SetCellValue( newRow, "sabun", $("#searchSabun").val() ) ;
            sheet2.SetCellValue( newRow, "ymd", $("#searchWorkYy").val()+"1231" ) ;

            tab_clickInsert(orgAuthPg, sheet2, newRow);
            break;
        case "Copy":
            var newRow = sheet2.DataCopy();
            sheet2.SelectCell(newRow, 2) ;
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet2);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet2.Down2Excel(param);
            break;
        }
    }

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if(Code == 1) {
                doAction2("Search");
            }
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    //조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if (Code == 1) {
            	var rtn = true;
            	
                for(var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++){
                    rtn = tab_setAuthEdtitable(orgAuthPg, sheet2, i);
                    
                    //구분 헤더에 데이터 있으면 비활성화 없으면 활성화 (예정)
                    /* if(sheet2.GetCellValue(i, "special_yn") == "" || sheet2.GetCellValue(i, "special_yn") == null){
                    	alert("null");
                    	sheet2.SetCellEditable(i,"special_yn", 1);
                    }else{
                    	alert("not null");
                    	sheet2.SetCellEditable(i,"special_yn", 0);
                    } */
                    
                    if ( rtn == false ) {
                    	//PDF입력도  난임시술비 수정 가능하게 수정
                        if ( sheet2.GetCellValue(i, "adj_input_type") == "07" ) {
                        	sheet2.SetCellEditable(i,"nanim_yn", 1) ;
                        	sheet2.SetCellEditable(i,"special_yn", 1) ;
                        }
                    } else {
	                    if(sheet2.GetCellValue(i,"medical_imp_cd") == "1"){
	                        sheet2.SetCellEditable(i,"firm_nm", 0) ;
	                        sheet2.SetCellEditable(i, "restrict_cd", 1) ;
	                        sheet2.SetCellEditable(i,"enter_no", 0);
	                    } else {
	                        sheet2.SetCellEditable(i,"enter_no", 1);
	                    }
	
	                    if( sheet2.GetCellValue(i, "medical_imp_cd") == "4" ) {
	                        sheet2.SetCellEditable(i, "medical_type", 1) ;
	                    } else {
	                        sheet2.SetCellEditable(i, "medical_type", 0) ;
	                    }
	
	                    if( sheet2.GetCellValue(i, "medical_imp_cd") == "5" ) {
	                        sheet2.SetCellEditable(i, "restrict_cd", 1) ;
	                    }
                    }
                }
            }
            sheetResize();
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
        try{
            // 상호에 특수문자 입력 방지
            if ( sheet2.ColSaveName(Col) == "firm_nm" ) {
                if ( !checkMetaChar2(sheet2.GetCellValue(Row,"firm_nm")) ) {
                    alert("특수문자는 입력 할 수 없습니다.");
                    sheet2.SetCellValue(Row,Col,"");
                }
            }

            if ( sheet2.ColSaveName(Col) == "enter_no" ) {
                if ( sheet2.GetCellValue(Row, Col) != "" ) {
                    var fResNo = sheet2.GetCellValue(Row, Col) ;
                    if( !checkBizID(fResNo) ) {
                        if ( !confirm("사업자등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?") ) sheet2.SetCellValue(Row, Col, "") ;
                    }
                }
            }
            
            if(sheet2.ColSaveName(Col) == "fam_nm") {

                sheet2.SetCellValue(Row, "famres", sheet2.GetCellValue(Row, "fam_nm")) ;

                age = 0;
                if(sheet2.GetCellValue(Row,"famres").substring(6,7) == "3" || sheet2.GetCellValue(Row,"famres").substring(6,7) == "4"
                   || sheet2.GetCellValue(Row,"famres").substring(6,7) == "7" || sheet2.GetCellValue(Row,"famres").substring(6,7) == "8") {
                    age = systemYY - parseInt("20"+sheet2.GetCellValue(Row, "famres").substring(0,2), 10);
                }else {
                    age = systemYY - parseInt("19"+sheet2.GetCellValue(Row, "famres").substring(0,2), 10);
                }

                var sht1FamresIdx = sheet1.FindText("famres", sheet2.GetCellText(Row, "famres"));
                var sht1SeniorYn = sheet1.GetCellValue(sht1FamresIdx, "senior_yn");
                var sht1HndcpType = sheet1.GetCellValue(sht1FamresIdx, "hndcp_type");
                var sht1DpndntYn = sheet1.GetCellValue(sht1FamresIdx, "dpndnt_yn");
                var sht1FamCd = sheet1.GetCellText(sht1FamresIdx, "fam_cd");

/*
"의료비 : 이름 선택 후 구분에 나오는 체크로직 확인(구분의 editable 불가)
          => 인적공제의 장애구분 코드가 선택된 사람은 구분에 ""장애인""으로 무조건 선택되도록 수정(65세이상이던 본인이던 무조건 장애인 우선으로 선택되도록 수정)
          => 인적공제의 장애구분 코드가 선택 안된 사람이 본인이면 구분에 아무것도 선택이 안되도록 확인
          => 인적공제의 장애구분 코드가 선택 안된 사람이 본인이 아닌데, 65세 이상이면 ""65세이상""이 선택되도록 수정
*/
                if(sht1HndcpType != ""){
                    sheet2.SetCellText(Row, "special_yn", "장애인") ;
                } else {
                    if(sht1FamCd == "0"){
                        sheet2.SetCellText(Row, "special_yn", "") ;
                    } else {
                        if( age >=65 && sheet2.GetCellValue(Row,"famres") != "" ){
                            sheet2.SetCellText(Row, "special_yn", "65세이상") ;
                        }
                        else {                       
                        	sheet2.SetCellText(Row, "special_yn", "") ;
                        }
                    }
                }

                if(sht1FamresIdx != -1) { // 관계
                	sheet2.SetCellValue(Row, "adj_fam_cd", sht1FamCd) ;
                } else {
                    sheet2.SetCellValue(Row, "adj_fam_cd", "") ;
                }
            }

/*
"의료비 :
         => 장애인코드를 선택할 때, 인적공제의 장애구분 코드가 선택 안된 대상자는 다음 ""인적공제의 장애구분이 등록된 대상자에 한해 선택 가능합니다."" 멘트가 나오면서 선택 불가
         => 65세이상을 선택할 때, 나이가 65세 이상(1948.12.31 이전 출생자)이 아닌 자는 다음 ""인적공제에 등록된 대상자의 나이가 65세 이상이 아닙니다."" 멘트가 나오면서 선택 불가"

         사용자 입력 화면에서도 수정시 구분 선택 가능하도록 수정
*/
            if(sheet2.ColSaveName(Col) == "special_yn"){ 
                age = 0;
                if(sheet2.GetCellValue(Row,"famres").substring(6,7) == "3" || sheet2.GetCellValue(Row,"famres").substring(6,7) == "4"
                   || sheet2.GetCellValue(Row,"famres").substring(6,7) == "7" || sheet2.GetCellValue(Row,"famres").substring(6,7) == "8") {
                    age = systemYY - parseInt("20"+sheet2.GetCellValue(Row, "famres").substring(0,2), 10);
                }else {
                    age = systemYY - parseInt("19"+sheet2.GetCellValue(Row, "famres").substring(0,2), 10);
                }

                var sht1FamresIdx = sheet1.FindText("famres", sheet2.GetCellText(Row, "famres"));
                var sht1SeniorYn = sheet1.GetCellValue(sht1FamresIdx, "senior_yn");
                var sht1HndcpType = sheet1.GetCellValue(sht1FamresIdx, "hndcp_type");
                var sht1DpndntYn = sheet1.GetCellValue(sht1FamresIdx, "dpndnt_yn");
                var sht1FamCd = sheet1.GetCellText(sht1FamresIdx, "fam_cd");
/*장애인 관련 체크 로직 제외 20161130 JSG (해당 부분 주석과 동시에 시트 구분값 수정 가능하게 바꿈)
                if ( sheet2.GetCellText(Row, "special_yn") == "장애인" && sht1HndcpType == "" ) {
                    alert("인적공제의 장애구분이 등록된 대상자에 한해 선택 가능합니다.");
                    sheet2.SetCellText(Row, "special_yn", "") ;
                    return;
                }
*/
                if ( sheet2.GetCellText(Row, "special_yn") == "65세이상" && !( age >=65 && sheet2.GetCellValue(Row,"famres") != "" ) ) {
                    alert("인적공제에 등록된 대상자의 나이가 65세 이상이 아닙니다.");
                    sheet2.SetCellValue(Row, "special_yn", sheet2.GetCellValue(Row, "special_yn_old")) ;
                } else if (
                		sheet2.GetCellText(Row, "special_yn") == "건강보험산정특례자" && 
                		confirm("건강보험산정 특례자란 국민건강 보험법 시행령 제19조제1항에 따라\n"+
                				"중증 질환자, 희귀난치성질환자 또는 결핵환자(치매 제외)로 등록된 사람만 해당 합니다.\n\n"+
                				"해당 사항이 맞는 경우만 입력 바랍니다.\n"+
                				"(본인,65세이상,장애인 대상인 경우 한도 없음 조건은 같으므로 별도 적용되지 않습니다.)") 
                		
                			) {
                	sheet2.SetCellValue(Row, "special_yn", "K") ;
               	}else if ( sheet2.GetCellText(Row, "special_yn") == "장애인" && sht1HndcpType == "" ) {
                    alert("인적공제의 장애구분이 등록된 대상자에 한해 선택 가능합니다.");
                    sheet2.SetCellValue(Row, "special_yn", sheet2.GetCellValue(Row, "special_yn_old")) ;
                } else {
                	sheet2.SetCellValue(Row, "special_yn", sheet2.GetCellValue(Row, "special_yn_old")) ;
                }
                
                if(sheet2.GetCellText(Row, "special_yn") == "") {
                	
                    var sht1FamresIdx = sheet1.FindText("famres", sheet2.GetCellText(Row, "famres"));
                    var sht1SeniorYn = sheet1.GetCellValue(sht1FamresIdx, "senior_yn");
                    var sht1HndcpType = sheet1.GetCellValue(sht1FamresIdx, "hndcp_type");
                    var sht1DpndntYn = sheet1.GetCellValue(sht1FamresIdx, "dpndnt_yn");
                    var sht1FamCd = sheet1.GetCellText(sht1FamresIdx, "fam_cd");
                    
                    if(sht1HndcpType != ""){
	                    sheet2.SetCellText(Row, "special_yn", "장애인") ;
	                } else {
	                    if(sht1FamCd == "0"){
	                        sheet2.SetCellText(Row, "special_yn", "") ;
	                    } else {
	                        if( age >=65 && sheet2.GetCellValue(Row,"famres") != "" ){
	                            sheet2.SetCellText(Row, "special_yn", "65세이상") ;
	                        }
	                        else {                       
	                        	sheet2.SetCellText(Row, "special_yn", "") ;
	                        }
	                    }
	                }
                }

            }

            //의료 증빙코드 관련
            if(sheet2.ColSaveName(Col) == "medical_imp_cd"){
                sheet2.SetCellValue(Row,"medical_type", "") ;
                sheet2.SetCellEditable(Row,"medical_type", 0) ;
                sheet2.SetCellValue(Row,"enter_no", "") ;
                sheet2.SetCellEditable(Row,"enter_no", 0);

                sheet2.SetCellValue(Row,"restrict_cd", "") ;
                sheet2.SetCellEditable(Row,"restrict_cd", 0) ;

                if(sheet2.GetCellValue(Row,"medical_imp_cd")== "1"){ // 국세청제공의료비
                    sheet2.SetCellValue(Row,"restrict_cd", "") ;
                    sheet2.SetCellEditable(Row,"restrict_cd", 1) ;

                    sheet2.SetCellValue(Row,"nts_yn", "Y") ;
                    sheet2.SetCellValue(Row,"enter_no", "") ;
                    sheet2.SetCellEditable(Row,"enter_no", 0) ;
                    sheet2.SetCellEditable(Row,"firm_nm", 0) ;
                    sheet2.SetCellValue(Row,"firm_nm", "") ;
                } else{
                    sheet2.SetCellValue(Row,"nts_yn", "N") ;
                    sheet2.SetCellEditable(Row,"enter_no", 1) ;
                    sheet2.SetCellEditable(Row,"firm_nm", 1) ;

                    sheet2.SetCellValue(Row,"restrict_cd", "") ;
                    sheet2.SetCellEditable(Row,"restrict_cd", 0) ;

                    //노인장기요양비 관련
                    if(sheet2.GetCellValue(Row,"medical_imp_cd")== "4"){
                        sheet2.SetCellEditable(Row,"medical_type", 1) ;
                    }
                    //기타의료비 영수증  관련
                    else if(sheet2.GetCellValue(Row,"medical_imp_cd")== "5"){
                        sheet2.SetCellEditable(Row,"restrict_cd", 1) ;
                        sheet2.SetCellValue(Row,"restrict_cd", "00") ;
                    } else{
                        sheet2.SetCellValue(Row,"medical_type", "") ;
                        sheet2.SetCellEditable(Row,"medical_type", 0) ;
                        sheet2.SetCellValue(Row,"restrict_cd", "") ;
                        sheet2.SetCellEditable(Row,"restrict_cd", 0) ;
                    }
                }
            }

            /* 의료비의 국세청제공의료비를 선택했을때, 안경구입비가 선택 가능하도록 수정, 단 기타의료비를 선택했을 때 안내멘트 나오게 수정
            멘트 : "국세청제공의료비는 안경구입비 여부만 선택해 주시면 됩니다. 안경구입비 이외의 국세청 자료는 상세구분을 선택하지 않으셔도 됩니다." */
            if(sheet2.ColSaveName(Col) == "medical_imp_cd" || sheet2.ColSaveName(Col) == "restrict_cd"){
                if ( sheet2.GetCellValue(Row,"medical_imp_cd") == "1" && !(sheet2.GetCellValue(Row,"restrict_cd") == "" || sheet2.GetCellValue(Row,"restrict_cd") == "10") ) {
                    alert("국세청제공의료비는 안경구입비 여부만 선택해 주시면 됩니다. 안경구입비 이외의 국세청 자료는 상세구분을 선택하지 않으셔도 됩니다");
                    sheet2.SetCellValue(Row,"restrict_cd", "") ;
                }
            }

            inputChangeAppl(sheet2,Col,Row);

            //안경구입비 50만원 한도계산
            if(sheet2.ColSaveName(Col) == "fam_nm" || sheet2.ColSaveName(Col) == "restrict_cd" || sheet2.ColSaveName(Col) == "appl_mon"){

                if(sheet2.GetCellValue(Row,"appl_mon") > 0){
                    if(sheet2.GetCellValue(Row,"restrict_cd") == "10"){
                        var sumData = 0;
                        for(var i=1; i < sheet2.LastRow()+1; i++){
                            if((sheet2.GetCellValue(Row,"fam_nm") == sheet2.GetCellValue(i,"fam_nm")) && (sheet2.GetCellValue(Row,"restrict_cd") == sheet2.GetCellValue(i,"restrict_cd"))){
                                sumData = sumData + parseInt(sheet2.GetCellValue(i,"appl_mon"), 10);
                            }
                        }
                        if(sumData > 500000){
                            alert("안경구입비 한도금액이 초과되었습니다.");
<%--                        if(orgAuthPg == "A"){	--%>
<%							if( "Y".equals(adminYn) ) {	%>
                                sheet2.SetCellValue(Row,"appl_mon", "0") ;
<%                          } else {	%>
                                sheet2.SetCellValue(Row,"input_mon", "0") ;
<%                          }	%>
                            return;
                        }
                    }
                }
            }
        } catch(ex){
            alert("OnChange Event Error : " + ex);
        }
    }

    function sheet2_OnClick(Row, Col, Value) {
        try{
			if(sheet2.ColSaveName(Col) == "sDelete" ) {
				tab_clickDelete(sheet2, Row);
				
				/* 금액 및 국세청 자료여부 Editable 풀림 방지*/
				if( sheet2.GetCellValue(Row, "adj_input_type") == "07" ) {
					
					sheet2.SetCellEditable(Row, "special_yn", 0);
					sheet2.SetCellEditable(Row, "input_mon", 0);
					sheet2.SetCellEditable(Row, "appl_mon", 0);
					sheet2.SetCellEditable(Row, "medical_imp_cd", 0);
					sheet2.SetCellEditable(Row, "firm_nm", 0);
					sheet2.SetCellEditable(Row, "cnt", 0);
				}
			}
        }catch(ex){
            alert("OnClick Event Error : " + ex);
        }
    }

    //특수문자 입력 체크(스페이스 제외)
    function checkMetaChar2(pVal){
        // 특수 문자 모음 
        var num = "{}[]()<>?|`~'!@#$%^&*-+=,.;:\"'\\/";
        var bFlag = true;
        
        for (var i = 0;i < pVal.length;i++){
            if(num.indexOf(pVal.charAt(i)) != -1) bFlag = false;
        }
        
        return bFlag;
    }
    
    //기본데이터 조회
    function initDefaultData() {
        //도움말 조회
        var param1 = "searchWorkYy="+$("#searchWorkYy").val();
        param1 += "&queryId=getYeaDataHelpText";

        var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=B007",false);
        helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");
		
        //안내메세지
        $("#infoLayer").html(helpText).hide();
        //안내-버튼 숨김
		$("#buttonInfoMinus").hide("fast");

        //의료비 항목 - 개인별 총급여
        var param2 = "searchWorkYy="+$("#searchWorkYy").val();
        param2 += "&searchAdjustType="+$("#searchAdjustType").val();
        param2 += "&searchSabun="+$("#searchSabun").val();
        param2 += "&queryId=getYeaDataPayTotMon";

        var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=0.03",false);
        paytotMonStr = nvl(result2.Data.paytot_mon,"");

        //총급여 확인 버튼 유무
        var result3 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
        yeaMonShowYn = nvl(result3[0].code_nm,"");
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
            $("#A050_03").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A050_03") ,"input_mon"));
            $("#A050_05").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A050_05") ,"input_mon"));
            $("#A050_04").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A050_04") ,"input_mon"));
            $("#A050_02").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A050_02") ,"input_mon"));
            $("#A050_07").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A050_07") ,"input_mon"));
            $("#A050_09").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A050_09") ,"input_mon"));
            $("#A050_11").val( comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A050_11") ,"input_mon"));       
        } else {
            $("#A050_03").val("0");
            $("#A050_05").val("0");
            $("#A050_04").val("0");
            $("#A050_02").val("0");
            $("#A050_07").val("0");
            $("#A050_09").val("0");
            $("#A050_11").val("0");
        }
    }

    //연말정산 안내
    function yeaDataExpPopup(title, helpText, height, width){
        var url     = "<%=jspPath%>/common/yeaDataExpPopup.jsp";
        openYeaDataExpPopup(url, width, height, title, helpText);
    }

    //[총급여 3%확인] 보이기
    function paytotMonView(){
        if(paytotMonStr != ""){
            $("#span_paytotMonView").html("<B class='txt'>"+paytotMonStr+"원</B>&nbsp;<a href='javascript:paytotMonViewClose()' ><font color='red' class='txt'>[닫기]</font></a>") ;
        }
        else {
            alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
            return;
        }
    }

    //[총급여 3%확인] 닫기
    function paytotMonViewClose(){
        $("#span_paytotMonView").html("");
    }

    function sheetChangeCheck() {
        var iTemp = sheet2.RowCount("I") + sheet2.RowCount("U") + sheet2.RowCount("D");
        if ( 0 < iTemp ) return true;
        return false;
    }
    
    /* 의료비안내 버튼 기능 */
    $(document).ready(function(){
    	//의료비안내+ 버튼 선택시 의료비안내- 버튼 호출 
    	$("#buttonInfoPlus").live("click",function(){
	    		var btnId = $(this).attr('id'); 
	    		if(btnId == "buttonInfoPlus"){
	    			$("#buttonInfoMinus").show("fast");
	    			$("#buttonInfoPlus").hide("fast");
	    		}
    	});
    	
    	//의료비안내- 버튼 선택시 의료비안내+ 버튼 호출
    	$("#buttonInfoMinus").live("click",function(){
    			var btnId = $(this).attr('id'); 
	    		if(btnId == "buttonInfoMinus"){
	    			$("#buttonInfoPlus").show("fast");
	    			$("#buttonInfoMinus").hide("fast");
	    		}
		});

    	//의료비안내+ 선택시 화면 호출
    	$("#buttonInfoPlus").click(function(){
    		$("#infoLayer").show("fast");
    		$("#infoLayerMain").show("fast");
        });
    	
    	//의료비안내- 선택시 화면 숨김
    	$("#buttonInfoMinus").click(function(){
    		$("#infoLayer").hide("fast");
    		$("#infoLayerMain").hide("fast");
        });
    });
	
	//의료비안내 안내 팝업 실행후 클릭시 창 닫음
    $(document).mouseup(function(e){
    	if(!$("#infoLayer div").is(e.target)&&$("#infoLayer div").has(e.target).length==0){
    		$("#infoLayer").fadeOut();
    		$("#infoLayerMain").fadeOut();
    		$("#buttonInfoMinus").hide("fast");
    		$("#buttonInfoPlus").show("fast");
    	}
    });
</script>
</head>
<body style="overflow-x:hidden;overflow-y:auto;">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
    <input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
    <input type="hidden" id="searchSabun" name="searchSabun" value="" />
    <input type="hidden" id="searchDpndntYn" name="searchDpndntYn" value="" />
    <input type="hidden" id="searchFamCd_s" name="searchFamCd_s" value="" />
    </form>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">의료비
                <span class="txt">※ 총급여 3% 미만의 연간 의료비총액은 공제금액이 발생하지 않습니다.</span>
            <span id="paytotMonViewYn">
                <a href="javascript:paytotMonView();" class="basic authA"><b><font color="red">[총급여 3%확인]</font></b></a>
            </span>
            <span id="span_paytotMonView" ></span>
                <!-- <a href="javascript:yeaDataExpPopup('의료비', helpText, 300);" class="cute_gray authR">의료비 안내 원본</a> -->
                <a href="#layerPopup" class="cute_gray" id="buttonInfoPlus"><b>의료비 안내+</b></a>
	            <a href="#layerPopup" class="cute_gray" id="buttonInfoMinus" style="display:none"><b>의료비 안내-</b></a>
            </li>
        </ul>
        </div>
    </div>
    <!-- Sample Ex&Image Start -->
    <div class="outer" style="display:none" id="infoLayerMain">
    	<table>
    		<tr>
    			<td style="padding:10px 5px 5px 5px;">
    				<div id="infoLayer"></div>
    			</td>
    		</tr>
    	</table>
    </div>
	<!-- Sample Ex&Image End -->
    <table border="0" cellpadding="0" cellspacing="0" class="default outer yeaData2">
    <colgroup>
        <col width="15%" />
        <col width="15%" />
        <col width="15%" />
        <col width="15%" />
        <col width="15%" />
        <col width="15%" />
    </colgroup>
    <tr>
        <th class="center">본인/65세이상 의료비</th>
        <th class="center">건강보험산정특례자 의료비</th>
        <th class="center">장애인 의료비</th>
        <th class="center">일반 의료비</th>
        <th class="center">장기요양급여비(재가급여)</th>
        <th class="center">장기요양급여비(시설급여)</th>
        <th class="center">난임시술비</th>
        
    </tr>
        <tr>
        <td class="right">
            <input id="A050_05" name="A050_05" type="text" class="text w50p right transparent"  readonly /> 원
        </td>
        <td class="right">
            <input id="A050_04" name=""A050_04"" type="text" class="text w50p right transparent"  readonly /> 원
        </td>
        <td class="right">
            <input id="A050_02" name="A050_02" type="text" class="text w50p right transparent"  readonly /> 원
        </td>
        <td class="right">
            <input id="A050_03" name="A050_03" type="text" class="text w50p right transparent" readOnly />원
        </td>
        <td class="right">
            <input id="A050_07" name="A050_07" type="text" class="text w50p right transparent" readOnly />원
        </td>
        <td class="right">
            <input id="A050_09" name="A050_09" type="text" class="text w50p right transparent" readOnly />원
        </td>
        <td class="right">
            <input id="A050_11" name="A050_11" type="text" class="text w50p right transparent"  readonly /> 원
        </td>
    </tr>
    </table>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">※ 안경구입비는 의료증빙 "국세청제공 의료비 > 안경구입비" 또는 "기타의료비 영수증 > 안경구입비"  으로 선택하십시오.(개인별 50만원 한도)</li>
            <li class="btn">
            <a href="javascript:doAction2('Search');" class="basic authR">조회</a>
            <a href="javascript:doAction2('Insert');" class="basic authA">입력</a>
<%if("Y".equals(adminYn)) {%>
            <span id="copyBtn">
            <a href="javascript:doAction2('Copy');" class="basic authA">복사</a>
            </span>
<%} %>
            <a href="javascript:doAction2('Save');" class="basic authA">저장</a>
            <a href="javascript:doAction2('Down2Excel');" class="basic authR">다운로드</a>
        </li>
        </ul>
    </div>
    </div>
    <div style="height:410px">
    <script type="text/javascript">createIBSheet("sheet2", "100%", "410px"); </script>
    </div>
    <span class="hide">
        <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
    </span>
</div>
</body>
</html>