<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>인적공제</title>
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
    var helpText1;
    var helpText2;
    //기준년도
    var systemYY;
    //총급여
    var paytotMonStr;
    //총급여 확인 버튼 보여주기 유무 정보에 따라 컨트롤
    var yeaMonShowYn;
    
    var zipcodePg = "";
    
    //기본공제 붉은색 표시 시 원래 색상 돌리기 위한 array
    var defaultColor = new Array();
    //기본공제 미체크->체크 여부를 확인하기 위한 array
    var defaultValue = new Array();
    
    //기본정보
    $(function() {

        $("#searchWorkYy").val($("#searchWorkYy", parent.document).val());
        $("#searchAdjustType").val($("#searchAdjustType", parent.document).val());
        $("#searchSabun").val($("#searchSabun", parent.document).val());
        systemYY = $("#searchWorkYy", parent.document).val();

        //기본정보 조회(도움말 등등).
        initDefaultData();
        
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

    //쉬트 초기화
    $(function() {

        //쉬트 초기화.
        var initdata1 = {};
        initdata1.Cfg = {FrozenCol:8,SearchMode:smLazyLoad,Page:22};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata1.Cols = [
            {Header:"No",             Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"삭제",           Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"상태",           Type:"<%=sSttTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"년도",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"work_yy",             KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분",            Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adjust_type",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"사번",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"sabun",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
            {Header:"관계",                Type:"Combo",       Hidden:0,   Width:100,   Align:"Center", ColMerge:0, SaveName:"fam_cd",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"성명",                Type:"Text",        Hidden:0,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"fam_nm",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"주민등록번호",        Type:"Text",        Hidden:0,    Width:110,   Align:"Center", ColMerge:0, SaveName:"famres",              KeyField:1, Format:"IdNo",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200, FullInput:1 },
            {Header:"주민등록번호\n체크",   Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"famresChk",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"만 나이",                Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"age",                 KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"연령대",              Type:"Combo",       Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"age_type",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"학력",                Type:"Combo",       Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"aca_cd",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"기본\n공제",          Type:"CheckBox",    Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"dpndnt_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"배우자\n공제",        Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"spouse_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"경로\n우대",          Type:"CheckBox",    Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"senior_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"장애인\n공제",        Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"hndcp_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"장애\n구분",          Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"hndcp_type",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"부녀자\n공제",         Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"woman_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"사업장",              Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"business_place_cd",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"보험료",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"insurance_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"의료비",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"medical_yn",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"교육비",              Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"education_yn",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"신용\n카드등",        Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"credit_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"우편번호",            Type:"Popup",       Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"zip",                 KeyField:0, Format:"PostNo",PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:6 },
            {Header:"주소",                Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"addr1",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"상세주소",            Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"addr2",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
            {Header:"다른곳에 등록된 수",  Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:0, SaveName:"incnt",               KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"6세이하\n자녀양육",   Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"child_yn",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"출산/입양\n공제",      Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"adopt_born_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"자녀 순서",          Type:"Combo",       Hidden:0,   Width:75,   Align:"Center", ColMerge:0, SaveName:"child_order",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"한부모\n공제",        Type:"CheckBox",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"one_parent_yn",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"전년도\n대상여부",    Type:"Text",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"pre_equals_yn",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"확정 여부",           Type:"Text",    Hidden:1,   Width:50,   Align:"Center", ColMerge:0, SaveName:"input_status",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N" }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var famCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00309"), "");
        var acaCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","H20130"), "");
        var childOrder = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00326"), "");
        
        sheet1.SetColProperty("child_order", {ComboText:"|"+childOrder[0], ComboCode:"|"+childOrder[1]} );
        sheet1.SetColProperty("fam_cd", {ComboText:"|"+famCdList[0], ComboCode:"|"+famCdList[1]} );
        sheet1.SetColProperty("aca_cd", {ComboText:"|"+acaCdList[0], ComboCode:"|"+acaCdList[1]} );
        sheet1.SetColProperty("hndcp_type", {ComboText:"|장애인복지법에 따른 장애인|국가유공자 등 예우 및 지원에 관한 법률에 따른 자|그 외 중증환자", ComboCode:"|1|2|3"} );
        sheet1.SetColProperty("age_type", {ComboText:"|만18세미만|만20세미만|만60세이상", ComboCode:"|18-|20-|60+"} );

		/*2015.12.17 MODIFY 우편번호 개편 디비 적용여부에 따라 우편번호 화면 분기됨. (시스템사용기준 : ZIPCODE_REF_YN) */
		var zipcodeRefYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=ZIPCODE_REF_YN", "queryId=getSystemStdData",false).codeList;
		if ( zipcodeRefYn != null && zipcodeRefYn.length>0) {
			if(zipcodeRefYn[0].code_nm == "Y") {
                zipcodePg = "Ref";
            } else if(zipcodeRefYn[0].code_nm == "W") {
                zipcodePg = "new";
            }
		}
		
        $(window).smartresize(sheetResize);
        sheetInit();

        checkWoman();
        parent.doSearchCommonSheet();
        doAction1("Search");
    });

    //sheet1 action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            //인적공제 조회
            sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=selectYeaDataPerList", $("#sheetForm").serialize() );
            break;
        case "Save":
            if(!parent.checkClose())return;

        	var saveMsgYn = "N" ;
        	
            for(var row = 1; row <= sheet1.GetTotalRows(); row++) {
                if( sheet1.GetCellValue(row, "famres") != "" ) {
                    //연령계산
                    var age = 0 ;
                    if( sheet1.GetCellValue(row, "famres").substring(6,7) == "3"
                            || sheet1.GetCellValue(row, "famres").substring(6,7) == "4"
                            || sheet1.GetCellValue(row, "famres").substring(6,7) == "7"
                            || sheet1.GetCellValue(row, "famres").substring(6,7) == "8"  ) {
                        age = systemYY - parseInt("20" + sheet1.GetCellValue(row, "famres").substring(0,2) , 10) ;
                    } else {
                        age = systemYY - parseInt("19" +  sheet1.GetCellValue(row, "famres").substring(0,2) , 10) ;
                    }

                    if( sheet1.GetCellValue(row, "fam_cd") == "1" || sheet1.GetCellValue(row, "fam_cd") == "2" ) {
                        if( sheet1.GetCellValue(row, "dpndnt_yn") == "Y" && sheet1.GetCellValue(row, "hndcp_yn") == "N" ) {
                            if(age < 60) {
                                alert("직계존속 연령은 만 60세 이상이어야 합니다. <"+sheet1.GetCellValue(row, "fam_nm")+">") ;
                                return ;
                            }
                        }
                    }

                    if( sheet1.GetCellValue(row, "fam_cd") == "4" || sheet1.GetCellValue(row, "fam_cd") == "5" ) {
                        if( sheet1.GetCellValue(row, "dpndnt_yn") == "Y" && sheet1.GetCellValue(row, "hndcp_yn") == "N" ) {
                            if(age > 20) {
                                alert( "직계비속 연령은 만 20세 이하이어야 합니다. <"+sheet1.GetCellValue(row, "fam_nm")+">" ) ;
                                return ;
                            }
                        }
                    }
                    
                    /*
                    라. 저장시 "장애인공제"에 체크되어 있는 상태에서 "장애 구분"이 미 선택되어 있으면, 다음 안내 멘트와 함께 저장 불가
                        "장애인공제 대상자의 장애구분을 선택하여 주시기 바랍니다."  
                    */
                    if ( sheet1.GetCellValue(row, "hndcp_yn") == "Y" && sheet1.GetCellValue(row, "hndcp_type") == "" ) {
                        alert("장애인공제 대상자의 장애구분을 선택하여 주시기 바랍니다.");
                        return;
                    }
                    
                    /*
                    마. 저장시 "기본공제" 대상자로 체크되어 있는데, "장애인공제"에 체크가 안되어 있고, "장애 구분"에 체크되어 있으면, 다음 안내 멘트와 함께 저장 불가
                        "장애 구분이 선택된 기본 공제 대상자는 장애인공제 대상자입니다. 장애인공제에 클릭하여 주시거나, 장애구분을 선택하지 마십시오."
                    */
                    if ( sheet1.GetCellValue(row, "dpndnt_yn") == "Y" && sheet1.GetCellValue(row, "hndcp_yn") == "N" && sheet1.GetCellValue(row, "hndcp_type") != "" ) {
                        alert("장애 구분이 선택된 기본 공제 대상자는 장애인공제 대상자입니다. 장애인공제에 클릭하여 주시거나, 장애구분을 선택하지 마십시오.");
                        return;
                    }
                    
                }
                /*기본공제가 미체크에서 체크 된 경우를 발라내어 해당 경우에 다른 저장 경고메시지를 뿌릴 수 있도록 한다.(수정시만 해당됨)*/
                if( (sheet1.GetCellValue(row, "dpndnt_yn") != defaultValue[row] && 
                	sheet1.GetCellValue(row, "dpndnt_yn") == "Y" && 
                	sheet1.GetCellValue(row, "sStatus") == "U") || (sheet1.GetCellValue(row, "sStatus") == "I" && sheet1.GetCellValue(row, "dpndnt_yn") == "Y") ) {
                	saveMsgYn = "Y" ;
                }
                
                if(sheet1.GetCellValue(row, "adopt_born_yn") == "Y" && sheet1.GetCellValue(row, "child_order") == ""){
                	alert("출산입양 공제 항목이 선택 되어 있을 경우, 자녀 순서를 선택하여 주시기 바랍니다.");
                	return;
                }
            }
            
            if( saveMsgYn == "Y") {
            	if( !confirm("기본공제 및 추가공제 사항의 요건을\n정확히 확인하여 주시기 바랍니다.\n저장 하시겠습니까? ") ) return ;
                sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=saveYeaDataPer", "", -1, false);
                
            } else {
                sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=saveYeaDataPer");
            	
            }
            
            
            break;
        case "Insert":
            if(!parent.checkClose())return;

            var newRow = sheet1.DataInsert(0) ;
            sheet1.SetCellBackColor( newRow, "dpndnt_yn", "#FF0000" );
            sheet1.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
            sheet1.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
            sheet1.SetCellValue( newRow, "sabun", $("#searchSabun").val() );

            sheet1.SetCellBackColor( newRow, "last_fam_yn", "#6CC5EA" );
            sheet1.SetCellValue( newRow, "last_fam_yn", "N" );
            
            sheet1.SetCellEditable(newRow,"child_order", 0) ;

            sheet1.SelectCell(newRow, 2) ;
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param);
            break;
        case "confirm":
        	
        	if(!confirm($("#authText").text() + " 하시겠습니까?")){
                break;
            }
        	
        	var inputStatus = "1";
        	
        	if($("#authText").text() == "확정") {
                inputStatus = "1";  	 
        	} else {
        		inputStatus = "0";
        	}
        	
        	var params = "input_status=" + inputStatus;
                params += "&work_yy="+$("#searchWorkYy").val();
                params += "&adjust_type="+$("#searchAdjustType").val();
                params += "&sabun="+$("#searchSabun").val();
            
            var result1 = ajaxCall("<%=jspPath%>/yeaData/yeaDataPerRst.jsp?cmd=saveYeaDataPerConfirm",params,false);
            
            if( result1.Result.Code == "1") {
                doAction1("Search");
            }
            
        	break;
        }
    }

    //여자인지 남자인지 체크하여 부여자가장 yeaSheet6 컬럼 보여주지 않기
    function checkWoman() {
        var resNo = $("#searchRegNo", parent.document).val();

        if(resNo != "") {
            var flag = resNo.substring(6,7);
            if(flag == "1" || flag == "3" || flag == "5" || flag == "7"){
                sheet1.SetCellEditable(1,"woman_yn", 0) ;
                sheet1.SetColHidden("woman_yn", 1) ;
            }else{
                sheet1.SetColHidden("woman_yn", 0) ;
            }
        }
    }

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if (Code == 1) {
            	//sheetSet() ;
                var loop = sheet1.LastRow();
                for(loop = 1 ; loop <= sheet1.LastRow() ; loop++){

                    //본인이면은
                    if(sheet1.GetCellValue(loop, "famres") == $("#searchRegNo", parent.document).val()){
                        sheet1.SetCellEditable(loop, "fam_cd", 0);
                        sheet1.SetCellEditable(loop, "dpndnt_yn", 0);
                        sheet1.SetCellEditable(loop, "spouse_yn", 0);
                        sheet1.SetCellEditable(loop, "woman_yn", 1);
                        sheet1.SetCellEditable(loop, "one_parent_yn", 1);
                        
                        sheet1.SetCellEditable(loop, "child_yn", 0);
                        sheet1.SetCellEditable(loop, "adopt_born_yn", 0);
                        

                        if(sheet1.GetCellValue(loop,"famres").substring(6,7) == "3" || sheet1.GetCellValue(loop,"famres").substring(6,7) == "4"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7" || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8") {
                            age = systemYY - parseInt("20"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
                        } else {
                            age = systemYY - parseInt("19"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
                        }
                        //경로우대 체크
                        if( sheet1.GetCellValue(loop,"famres").substring(6,7) == "1"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "3"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "5"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7" ){
                            if( age >= 70){
                                //sheet1.SetCellValue(loop,"senior_yn", "Y") ;
                                sheet1.SetCellEditable(loop, "senior_yn", 1) ;
                            } else{
                                sheet1.SetCellValue(loop,"senior_yn", "N") ;
                                sheet1.SetCellEditable(loop, "senior_yn", 0) ;
                            }
                        } else if( sheet1.GetCellValue(loop,"famres").substring(6,7) == "2"
                                || sheet1.GetCellValue(loop,"famres").substring(6,7) == "4"
                                || sheet1.GetCellValue(loop,"famres").substring(6,7) == "6"
                                || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8" ){
                            if( age >= 70){
                                //sheet1.SetCellValue(loop,"senior_yn", "Y") ;
                                sheet1.SetCellEditable(loop, "senior_yn", 1) ;
                            } else{
                                sheet1.SetCellValue(loop,"senior_yn", "N") ;
                                sheet1.SetCellEditable(loop, "senior_yn", 0) ;
                            }
                        }
                    } else{
                        sheet1.SetCellEditable(loop, "woman_yn", 0) ;
                        sheet1.SetCellEditable(loop, "one_parent_yn", 0);
                        resetCheckCtr(loop);
                    }
                    
                    /*
                    //주민번호 체크
                    var rResNo = sheet1.GetCellValue(loop,"famres");

                    //외국인 주민번호 체크
                    if(sheet1.GetCellValue(loop,"famres").substring(6,7) == "5"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "6"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7"
                            || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8"){

                        if(fgn_no_chksum(rResNo) != true){
                        	sheet1.SetCellValue(loop,"famresChk", "부적합");
                        	sheet1.SetCellValue(loop,"sStatus", "R");
                        }
                    } else {
                        if(checkRegNo(rResNo.substring(0,6), rResNo.substring(6,13)) != true){
                        	sheet1.SetCellValue(loop,"famresChk", "부적합");
                        	sheet1.SetCellValue(loop,"sStatus", "R");
                        }
                    }
                    */
                    
                    //나이, 연령대
                    var age = 0;
                    if(sheet1.GetCellValue(loop,"famres").substring(6,7) == "3"
					        || sheet1.GetCellValue(loop,"famres").substring(6,7) == "4"
					        || sheet1.GetCellValue(loop,"famres").substring(6,7) == "7"
					        || sheet1.GetCellValue(loop,"famres").substring(6,7) == "8") {
					    age = systemYY - parseInt("20"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
					} else {
					    age = systemYY - parseInt("19"+sheet1.GetCellValue(loop, "famres").substring(0,2), 10);
					}
                    sheet1.SetCellValue(loop, "age", age);
                    if ( age < 18 ) sheet1.SetCellValue(loop, "age_type", "18-");
                    else if ( age < 20 ) sheet1.SetCellValue(loop, "age_type", "20-");
                    else if ( 60 <= age ) sheet1.SetCellValue(loop, "age_type", "60+");
                    else sheet1.SetCellValue(loop, "age_type", "");
                    
                    sheet1.SetCellValue(loop,"sStatus", "R");
                    
                    defaultColor[loop] = sheet1.GetCellBackColor(loop, "dpndnt_yn") ;
                    defaultValue[loop] = sheet1.GetCellValue(loop, "dpndnt_yn") ;
                    
                    if( sheet1.GetCellValue(loop,"dpndnt_yn") == "N" ) {
                    	sheet1.SetCellBackColor(loop,"dpndnt_yn", "#FF0000") ;
                    } else {
                    	sheet1.SetCellBackColor(loop,"dpndnt_yn", defaultColor[loop]) ;
                    }
                }
                
                // 확정 관련 로직 구현
                if( sheet1.GetCellValue(1, "input_status").substring(0,1) == "1" ){
                	$("#authText").text("확정 취소");
                	
                	$("#btnInsert").hide();
                	$("#btnSave").hide();
                	
                	sheet1.SetEditable(false);
                } else if (sheet1.GetCellValue(1, "input_status").substring(0,1) != "1") {
                	$("#authText").text("확정");
                	
                	$("#btnInsert").show();
                    $("#btnSave").show();
                    
                    sheet1.SetEditable(true);
                }                
                
                // 탭처리 
                $("#inputStatus", parent.document).val(sheet1.GetCellValue(1, "input_status"));
            }
            sheetResize();
            
            sheet1.FitSize(0, 1);
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    //저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            parent.getYearDefaultInfoObj();
            if(Code == 1) {
                parent.doSearchCommonSheet();
                doAction1("Search") ;
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    var gPRow  = "";
    var pGubun = "";
    
    //팝업 클릭시 발생.
    function sheet1_OnPopupClick(Row, Col){
        try{
            
            if(Row > 0 && sheet1.ColSaveName(Col) == "zip" ){
                
                if(!isPopup()) {return;}
                gPRow = Row;
                pGubun = "zipCodePopup";
                
        		/*2015.12.17 MODIFY 우편번호 개편 디비 적용여부에 따라 우편번호 화면 분기됨. (시스템사용기준 : ZIPCODE_REF_YN) */
				var rst = "";
		        if(zipcodePg != "new") {
		            rst = openPopup("<%=jspPath%>/common/zipCode"+zipcodePg+"Popup.jsp", "", "740","620");
		        }else{
		            rst = openPopup("<%=jspPath%>/common/newZipCodePopup.jsp", "", "740","620");
		        }
                /*
                if(rst != null){
                    sheet1.SetCellValue(Row,"zip",rst[0]);
                    sheet1.SetCellValue(Row,"addr1",rst[1]);
                    sheet1.SetCellValue(Row,"addr2",rst[2]);
                }
                */
            }
        } catch(ex){
            alert("OnPopupClick Event Error : " + ex);
        }
    }

    function getReturnValue(returnValue) {

        var rst = $.parseJSON('{'+ returnValue+'}');

        if ( pGubun == "zipCodePopup" ){
            //우편번호조회
            if(zipcodePg != "new"){
            	$("#zipCode").val(rst.zip);
                $("#addr1").val(rst.doroAddr);
                $("#addr2").val(rst.detailAddr);
            }else {
                $("#zipCode").val(rst.zip);
                $("#addr1").val(rst.doroAddr);
                $("#addr2").val(rst.detailAddr);
            }
            
        }
    }
    
    //변경시 발생.
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try{
            /*
            한부모공제 클릭시 부녀자공제에 체크되어 있으면, 안내멘트(부녀자공제와 한부모공제는 동시에 선택할 수 없습니다. 한부모공제를 선택하시겠습니까?)
            */
            if(sheet1.ColSaveName(Col) == "woman_yn" || sheet1.ColSaveName(Col) == "one_parent_yn") {
                if(sheet1.GetCellValue(Row, "one_parent_yn") == "Y" && sheet1.GetCellValue(Row, "woman_yn") == "Y"){

                    if(sheet1.ColSaveName(Col) == "woman_yn" ) alert("부녀자공제와 한부모공제는 동시에 선택할 수 없습니다. 한부모공제를 선택 해제 하여 주십시요.");
                    else                                       alert("부녀자공제와 한부모공제는 동시에 선택할 수 없습니다. 부녀자공제를 선택 해제 하여 주십시요.");

                    sheet1.SetCellValue(sheet1.GetSelectRow(), sheet1.ColSaveName(Col), "N") ;
                }
            }
            
            if(sheet1.ColSaveName(Col) == "fam_cd") {
                if((sheet1.GetCellValue(Row, "fam_cd") == "4" || sheet1.GetCellValue(Row, "fam_cd") == "5") && sheet1.GetCellValue(Row, "adopt_born_yn") == "Y"){
                    sheet1.SetCellEditable(Row, "child_order", 1) ;
                } else {
                    sheet1.SetCellEditable(Row, "child_order", 0) ;
                    sheet1.SetCellValue(Row, "child_order","") ;
                }
            }
            
            if(sheet1.ColSaveName(Col) == "one_parent_yn") {
            	
            	var chkYn = "N";
            	for(var i=1; i <= sheet1.LastRow(); i++){
            		
                    if(Row != i && sheet1.GetCellValue(i,"fam_cd") == '4' && sheet1.GetCellValue(i,"dpndnt_yn") == 'Y'){
                    	chkYn = "Y";
                    }
                }
            	
            	if(chkYn == 'N' && sheet1.GetCellValue(Row,"one_parent_yn")=='Y'){
            		
            		alert("한부모 공제는 직계비속(자녀,입양자)이면서 기본공제로 등록되어 있을 경우에만 가능 합니다. ");
            		sheet1.SetCellValue(Row,"one_parent_yn", "") ;
            		return false;
            		
            	}
            	
            	if(sheet1.GetCellValue(Row,"one_parent_yn")=='Y'){
	            	for(var i=1; i <= sheet1.LastRow(); i++){
	                    if(Row != i && sheet1.GetCellValue(i,"fam_cd") == '3'){
	                    	alert("한부모 공제는 배우자가 없는 경우에만 가능 합니다. ");
	                		sheet1.SetCellValue(Row,"one_parent_yn", "") ;
	                		return false;
	                    }
	                }
            	}
            	
            }
            
            if(sheet1.ColSaveName(Col) == "dpndnt_yn") {
                
                var chkYn = "N";
                for(var i=1; i <= sheet1.LastRow(); i++){
                    
                    if(Row != i && sheet1.GetCellValue(i,"fam_cd") == '4' && sheet1.GetCellValue(i,"dpndnt_yn") == 'Y'){
                        chkYn = "Y";
                    }
                }
                
                if(chkYn == 'N'){
                    sheet1.SetCellValue(Row,"one_parent_yn", "") ;
                    for(var i=1; i <= sheet1.LastRow(); i++){
                    	sheet1.SetCellValue(i,"one_parent_yn", "") ;
                    }
                }
            }
            

            if(sheet1.ColSaveName(Col) == "woman_yn") {
                if(sheet1.GetCellValue(Row, "woman_yn") == "Y"){
                    
                    if(paytotMonStr != ""){
                        if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 41470588 ) {
                            alert("근로소득금액 3,000만원(총급여만으로는 41,470,588원) 이하인 자에 한해 부녀자 공제가 가능합니다.");
                            sheet1.SetCellValue(sheet1.GetSelectRow(),"woman_yn", "N") ;
                            sheet1.SetCellEditable(sheet1.GetSelectRow(),"woman_yn", 0);
                            return;
                        } 
                    }
                    
                    if( confirm("부녀자공제는 근로자본인이 기혼인 여성이거나 혹은  미혼이면서 기본공제를 받는 부양가족이 존재할 경우에 해당합니다.\n근로소득금액 3,000만원(총급여만으로는 41,470,588원) 이하인 자에 한해 가능합니다.\n부녀자 공제를 선택 하시겠습니까?")){
                        sheet1.SetCellValue(sheet1.GetSelectRow(),"woman_yn", "Y") ;
                    } else{
                        sheet1.SetCellValue(sheet1.GetSelectRow(),"woman_yn", "N") ;
                    }
                }
            }

            if(sheet1.ColSaveName(Col) == "dpndnt_yn" || sheet1.ColSaveName(Col) == "spouse_yn"){
            	if ( sheet1.GetCellValue(Row,"fam_cd") == '3' && Value == "Y" ) {
	            	for(var i=1; i <= sheet1.LastRow(); i++){
	                    if(Row != i && sheet1.GetCellValue(i,"one_parent_yn") == 'Y'){
	                    	alert("한부모 공제는 배우자가 없는 경우에만 가능 합니다. ");
	                		sheet1.SetCellValue(Row, Col, OldValue, 0) ;
	                		return;
	                    }
	                }
            	}
            }
            
            if(sheet1.ColSaveName(Col) == "dpndnt_yn" || sheet1.ColSaveName(Col) == "hndcp_yn"){
                resetCheckCtr(Row);
            } else if(sheet1.ColSaveName(Col) == "fam_cd"){
                sheet1.SetCellValue(Row,"dpndnt_yn","N");
                sheet1.SetCellEditable(Row,"dpndnt_yn", 1);

                //가족관계를 본인으로 입력할 때 기존에 등록된 본인이 있는지 체크
                var chk = "Y";
                if(sheet1.GetCellValue(Row,"fam_cd") == "0"){
                    // 본인은 무조건 기본공제 체크한다.
                    sheet1.SetCellValue(Row,"dpndnt_yn","Y");
                    sheet1.SetCellEditable(Row,"dpndnt_yn", 0);
                    
                    for(var i=1; i <= sheet1.LastRow(); i++){

                        if(Row != i && sheet1.GetCellValue(Row,"fam_cd") == sheet1.GetCellValue(i,"fam_cd")){
                            chk = "N";
                        }
                    }

                    if(chk == "N"){
                        alert("이미 가족관계(본인)가 등록되어 있습니다. 다시 입력해 주십시요.");
                        sheet1.SetCellValue(Row,"fam_cd", "") ;
                        return;
                    } else {
                        checkFamCd(Row);
                    }
                }
                //가족관계를 배우자으로 입력할 때 기존에 등록된 배우자가 있는지 체크
                else if(sheet1.GetCellValue(Row,"fam_cd") == "3"){

                    for(var i=1; i <= sheet1.LastRow(); i++){

                        if(Row != i && sheet1.GetCellValue(Row,"fam_cd") == sheet1.GetCellValue(i,"fam_cd")){
                            chk = "N";
                        }
                    }

                    if(chk == "N"){
                        alert("이미 가족관계(배우자)가 등록되어 있습니다. 다시 입력해 주십시요.");
                        sheet1.SetCellValue(Row,"fam_cd", "") ;
                        return;
                    } else {
                        checkFamCd(Row);
                    }
                } else {
                    checkFamCd(Row);
                }

            } else if(sheet1.ColSaveName(Col) == "famres"){

                if(sheet1.GetCellValue(Row,"famres")!= ""){
                    //주민번호 유효성체크
                    //  var fResNo = sheet1.GetCellValue(Row,"famres").substring(0,6);
                    var rResNo = sheet1.GetCellValue(Row,"famres");

                    //외국인 주민번호 체크
                    if(sheet1.GetCellValue(Row,"famres").substring(6,7) == "5"
                            || sheet1.GetCellValue(Row,"famres").substring(6,7) == "6"
                            || sheet1.GetCellValue(Row,"famres").substring(6,7) == "7"
                            || sheet1.GetCellValue(Row,"famres").substring(6,7) == "8"){

                        if(fgn_no_chksum(rResNo) == true){
                            checkFamCd(Row);
                        } else{
                            if ( !confirm("등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?") ) sheet1.SetCellValue(Row,"famres", "") ;
                        }
                    } else {
                        //if(isValid_socno_sheet(rResNo) == true){
                        if(checkRegNo(rResNo.substring(0,6), rResNo.substring(6,13)) == true){
                            checkFamCd(Row);
                        } else{
                            if ( !confirm("주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?") ) sheet1.SetCellValue(Row,"famres", "") ;
                        }
                    }
                    
                    var age = 0;
                    if(sheet1.GetCellValue(Row,"famres").substring(6,7) == "3"
					        || sheet1.GetCellValue(Row,"famres").substring(6,7) == "4"
					        || sheet1.GetCellValue(Row,"famres").substring(6,7) == "7"
					        || sheet1.GetCellValue(Row,"famres").substring(6,7) == "8") {
					    age = systemYY - parseInt("20"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
					} else {
					    age = systemYY - parseInt("19"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
					}
                    sheet1.SetCellValue(Row, "age", age);
                    if ( age < 18 ) sheet1.SetCellValue(Row, "age_type", "18-");
                    else if ( age < 20 ) sheet1.SetCellValue(Row, "age_type", "20-");
                    else if ( 60 <= age ) sheet1.SetCellValue(Row, "age_type", "60+");
                    else sheet1.SetCellValue(Row, "age_type", "");
                        
                }
            }
            if(sheet1.ColSaveName(Col) == "dpndnt_yn" ){
                if( sheet1.GetCellValue(Row,"dpndnt_yn") == "Y"){
                    if(sheet1.GetCellValue(Row,"fam_cd") != "0"){ //본인이 아닌 경우 체크
                        if(sheet1.GetCellValue(Row,"famres") =='' || sheet1.GetCellValue(Row,"fam_cd") == ''){
                           alert('가족관계 및 주민번호를 먼저 입력하셔야 합니다');
                           sheet1.SetCellValue(Row,"dpndnt_yn", "N") ;
                           return;
                        }
                    }
                    
                    var flag = false;
                    if( confirm("기본 공제 선택시 대상자의 연간소득금액의 합계액이\n" +
                    		    "1백만원 이하이고 (근로소득만 있는 경우 총급여액 5백만원),\n" + 
                    		    "다른 가족과 중복공제가 되지 않았음을\n" + 
                    		    "확인한 후 공제 여부를 결정하여 주십시오.\n\n" +
                    		    "기본공제를 선택 하시겠습니까?\n" +
                    		    "* 연간소득금액이란? 근로·연금·기타·퇴직·양도소득의 합산금액")){
                        flag = true;
                    } else{
                        sheet1.SetCellValue(sheet1.GetSelectRow(),"dpndnt_yn", "N") ;
                    }

                    if(sheet1.GetCellValue(Row,"fam_cd") == "3"){
                    	
                    	
                        if(flag) {
                        	sheet1.SetCellValue(sheet1.GetSelectRow(),"spouse_yn", "Y") ;
                            sheet1.SetCellEditable(sheet1.GetSelectRow(),"spouse_yn", 0) ;
                        } else {
                        	sheet1.SetCellValue(sheet1.GetSelectRow(),"dpndnt_yn", "N") ;
                            sheet1.SetCellEditable(sheet1.GetSelectRow(),"spouse_yn", 0) ;
                        }
                        
                        //배우자 나이체크 후 경로우대 여부 판단
                        var spouse_age = 0;
                        if(sheet1.GetCellValue(Row,"famres").substring(6,7) == "3"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "4"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "7"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "8") {
                            spouse_age = systemYY - parseInt("20"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
                        } else {
                            spouse_age = systemYY - parseInt("19"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
                        }
                        if( spouse_age >= 70 && flag){
                            sheet1.SetCellValue(Row,"senior_yn", "Y") ;
                            sheet1.SetCellEditable(Row, "senior_yn", 0) ;
                        } else{
                            sheet1.SetCellValue(Row,"senior_yn", "N") ;
                            sheet1.SetCellEditable(Row, "senior_yn", 0) ;
                        }
                    //수급자의 경우 경로우대 체크
                    } else if(sheet1.GetCellValue(Row,"fam_cd") == "7" && flag ){
                        //배우자 나이체크 후 경로우대 여부 판단
                        var sugub_age = 0;
                        if(sheet1.GetCellValue(Row,"famres").substring(6,7) == "3"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "4"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "7"
                                || sheet1.GetCellValue(Row,"famres").substring(6,7) == "8") {
                            sugub_age = systemYY - parseInt("20"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
                        } else {
                            sugub_age = systemYY - parseInt("19"+sheet1.GetCellValue(Row, "famres").substring(0,2), 10);
                        }
                        if( sugub_age >= 70){
                            sheet1.SetCellValue(Row,"senior_yn", "Y") ;
                            sheet1.SetCellEditable(Row, "senior_yn", 0) ;
                        } else{
                            sheet1.SetCellValue(Row,"senior_yn", "") ;
                            sheet1.SetCellEditable(Row, "senior_yn", 0) ;
                        }
                    }
                } else{
                    sheet1.SetCellValue(sheet1.GetSelectRow(),"spouse_yn", "N") ;
                    sheet1.SetCellEditable(sheet1.GetSelectRow(),"spouse_yn", 0) ;
                    return;
                }
            }

            if(sheet1.ColSaveName(Col) == "dpndnt_yn" && (Value == "Y" || Value == "1")){
                if(sheet1.GetCellValue(Row,"hndcp_yn") == "Y") {
                    alert(" 기본공제대상조건(도움말참조)이 아닌 인원에 대한 기본공제는 \n [장애인] 만 해당합니다. \n 기본공제대상여부를 확인바랍니다."
                        + "\n 장애인일 경우에는 장애구분에 해당 코드를 선택하셔야 합니다."
                    );
                }
            }
            
            if ( sheet1.ColSaveName(Col) == "hndcp_yn" ) {
                if ( sheet1.GetCellValue(Row,"hndcp_yn") == "Y" ) {
                    if ( sheet1.GetCellValue(Row, "hndcp_type") == "" ) sheet1.SetCellValue(Row, "hndcp_type", "1");
                } else {
                    sheet1.SetCellValue(Row, "hndcp_type", "");
                }
            }
            
            if ( sheet1.ColSaveName(Col) == "fam_nm" ) {
                if ( !checkMetaChar(sheet1.GetCellValue(Row,"fam_nm")) ) {
                    alert("특수문자는 입력 할 수 없습니다.");
                    sheet1.SetCellValue(Row,Col,"");
                }
            }
            
            if ( sheet1.ColSaveName(Col) == "child_order") {
            	var target = sheet1.GetCellValue(Row,Col); 
            	var chkFlag = true;
            	
           		for(var i = 1; i <= sheet1.LastRow(); i++){

                    if(i != Row && target == sheet1.GetCellValue(i,Col) && target != "A5" && target != ""){
                        chkFlag = false;
                    }
                }
           		
           		if(!chkFlag){
           	        alert("자녀 순서를 확인하시기 바랍니다.\n셋째 이상을 제외한 값을 중복으로 입력 하실 수 없습니다.");
           	        sheet1.SetCellValue(Row,Col,"");
           	        return;
           		}
            }
            
            if( sheet1.ColSaveName(Col) == "adopt_born_yn") {
            	sheet1.SetCellEditable(Row,"child_order", sheet1.GetCellValue(Row,Col) == "Y" ? 1 : 0) ;
            	if(sheet1.GetCellValue(Row,Col) != "Y") { 
            		   sheet1.SetCellValue(Row,"child_order", "") ;
            	}
            }
        } catch(ex){
            alert("OnChange Event Error : " + ex);
        }
    }

    function sheet1_OnClick(Row, Col, Value){
	   	try{
	   		//기본공제 미체크에 대하여 붉은색 표기 및 체크시 붉은색 표기 해제 원래색상 돌리기 by JSG 20161201
            if ( sheet1.ColSaveName(Col) == "dpndnt_yn" ) {
	            if( sheet1.GetCellValue(Row, Col) == "N" ) {
	            	sheet1.SetCellBackColor(Row, Col, "#FF0000") ;
	            } else {
	            	sheet1.SetCellBackColor(Row, Col, defaultColor[Row]) ;
	            }
            }
	   	}catch(ex){alert("OnClick Event Error : " + ex);}
   	}
        
    //기본정보 조회(도움말 등등).
    function initDefaultData() {
        var params1 = "searchWorkYy="+$("#searchWorkYy").val();
        params1 += "&adjProcessCd=A010";
        params1 += "&queryId=getYeaDataHelpText";

        var params2 = "searchWorkYy="+$("#searchWorkYy").val();
        params2 += "&adjProcessCd=A020";
        params2 += "&queryId=getYeaDataHelpText";

        //개인별 총급여
        var params3 = "searchWorkYy="+$("#searchWorkYy").val();
        params3 += "&searchAdjustType="+$("#searchAdjustType").val();
        params3 += "&searchSabun="+$("#searchSabun").val();
        params3 += "&queryId=getYeaDataPayTotMon";

        var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params1,false);
        var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params2,false);
        var result3 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",params3+"&searchNumber=1",false);
        
        helpText1 = result1.Data.help_text1 + result1.Data.help_text2 + result1.Data.help_text3;
        helpText2 = result2.Data.help_text1 + result2.Data.help_text2 + result2.Data.help_text3;
        paytotMonStr = nvl(result3.Data.paytot_mon,"");
        
        //총급여 확인 버튼 유무
        var result4 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
        yeaMonShowYn = nvl(result4[0].code_nm,"");
    }

    //연말정산 안내
    function yeaDataExpPopup(title, helpText, height, width){
        var url     = "<%=jspPath%>/common/yeaDataExpPopup.jsp";
        openYeaDataExpPopup(url, width, height, title, helpText);
    }

    //기본자료 설정.
    function sheetSet(){
        var comSheet = parent.commonSheet;

        if(comSheet.RowCount() > 0){
            $("input[id='A010_03']:input[value='"+comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A010_03"),"data_yn")+"']").attr("checked",true);
            $("input[id='A020_07']:input[value='"+comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A020_07"),"data_yn")+"']").attr("checked",true);
            $("input[id='A020_14']:input[value='"+comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A020_14"),"data_yn")+"']").attr("checked",true);
            $("#A010_05").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A010_05"),"data_cnt") );
            $("#A010_07").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A010_07"),"data_cnt") );
            $("#A010_09").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A010_09"),"data_cnt") );
            $("#A020_03").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A020_03"),"data_cnt") );
            $("#A020_05").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "A020_05"),"data_cnt") );
            $("#B000_10").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "B000_10"),"data_cnt") );
            $("#B001_20").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "B001_20"),"data_cnt") );
            $("#B001_30").val( comSheet.GetCellValue(comSheet.FindText("adj_element_cd", "B001_30"),"data_cnt") );
            
            
        }else{
            $("#A010_05").val( "0" ) ;
            $("#A010_07").val( "0" ) ;
            $("#A010_09").val( "0" ) ;
            $("#A020_03").val( "0" ) ;
            $("#A020_05").val( "0" ) ;
            $("#B000_10").val( "0" ) ;
            $("#B001_20").val( "0" ) ;
            $("#B001_30").val( "0" ) ;
        }
    }

    //가족사항 등록및수정시(sheet1)시 부양가족체크 여부에 따라 체크박스 Editable 여부확인
    function resetCheckCtr(row){
//alert("resetCheckCtr 00");
        sheet1.SetCellEditable(row, "spouse_yn", 0) ;
        sheet1.SetCellEditable(row, "senior_yn", 0) ;
        sheet1.SetCellEditable(row, "hndcp_yn", 0) ;
        
        sheet1.SetCellEditable(row, "child_yn", 0) ;
        sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;

        if(sheet1.GetCellValue(row, "dpndnt_yn") == "Y"){
            sheet1.SetCellEditable(row, "hndcp_yn", 1);
            checkFamCd(row);
        } else{
            checkFamCd(row);
        }
    }

    //가족사항 등록및수정시(sheet1)시 가족관계에 따라 체크박스 Editable 여부확인
    function checkFamCd(row){
/**
alert("checkFamCd 00");
alert("famres ="+ sheet1.GetCellValue(row,"famres")
    + "\n fam_cd ="+ sheet1.GetCellValue(row,"fam_cd")
);
/**/
        age = 0;
        if(sheet1.GetCellValue(row,"famres").substring(6,7) == "3"
                || sheet1.GetCellValue(row,"famres").substring(6,7) == "4"
                || sheet1.GetCellValue(row,"famres").substring(6,7) == "7"
                || sheet1.GetCellValue(row,"famres").substring(6,7) == "8") {
            age = systemYY - parseInt("20"+sheet1.GetCellValue(row, "famres").substring(0,2), 10);
        } else {
            age = systemYY - parseInt("19"+sheet1.GetCellValue(row, "famres").substring(0,2), 10);
        }

        //부양가족인지 확인
        if(sheet1.GetCellValue(row, "dpndnt_yn") == "Y"){
            //경로우대,자녀양육비 체크 가능한지
            if(sheet1.GetCellValue(row,"famres") != ""){
                if(sheet1.GetCellValue(row,"fam_cd") == "1"
                        || sheet1.GetCellValue(row,"fam_cd") == "2"){ //(소득자의 직계존속 : 1, 배우자의 직계존속 : 2)
                    sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                    sheet1.SetCellValue(row,"spouse_yn", "N") ;

                    if(age < 60){
                        sheet1.SetCellValue(row, "hndcp_yn", "Y") ;
                    }
                    
                    sheet1.SetCellEditable(row, "child_yn", 0) ;
                    sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    sheet1.SetCellValue(row,"child_yn", "N") ;
                    
                } else if(sheet1.GetCellValue(row,"fam_cd") == "4" || sheet1.GetCellValue(row,"fam_cd") == "5"){
                    sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                    sheet1.SetCellValue(row,"spouse_yn", "N") ;

                    if(age > 20){
                        sheet1.SetCellValue(row, "hndcp_yn", "Y") ;
                    }
                    
                    if( age <= 6){
                        sheet1.SetCellEditable(row, "child_yn", 1) ;
                        if(sheet1.GetCellValue(row, "sStatus") != "R"){
                            if(sheet1.GetCellValue(row,"child_yn")=="N"){
                                //if(confirm('자녀양육을 선택 하시겠습니까?')){
                                    sheet1.SetCellValue(row,"child_yn", "Y") ;
                                //}
                            }
                        }
                    } else{
                        sheet1.SetCellEditable(row, "child_yn", 0) ;
                    }
                  //직계 비속일 경우에 입양_출산 체크를 한다.
                    if( age <= 20){
                        //출산입양체크
                        if( age == 0){
                            sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                            sheet1.SetCellValue(row,"adopt_born_yn", "Y") ;
                            sheet1.SetCellEditable(row,"child_order", 1) ;
                        } else{
                            sheet1.SetCellEditable(row, "adopt_born_yn", 1) ;
                        }
                    } else{
                        sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    }
                    
                } else if(sheet1.GetCellValue(row,"fam_cd") == "6") {  //형제자매 : 6
                    if(age > 20 && age < 60){
                        sheet1.SetCellValue(row, "hndcp_yn", "Y") ;
                    }
                
                    sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    sheet1.SetCellEditable(row, "child_yn", 0) ;
                    sheet1.SetCellValue(row,"child_yn", "N") ;
                  
                    sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                    sheet1.SetCellValue(row,"spouse_yn", "N") ;
                } else if(sheet1.GetCellValue(row,"fam_cd") == "0"){      //본인 : 0
                    sheet1.SetCellEditable(row, "fam_cd", 0) ;
                    sheet1.SetCellEditable(row, "dpndnt_yn", 0) ;
                    sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                    sheet1.SetCellEditable(row, "woman_yn", 1) ;
                    
                    sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    sheet1.SetCellEditable(row, "child_yn", 0) ;
                    
                } else if(sheet1.GetCellValue(row,"fam_cd") == "3"){      //배우자 : 3
                    sheet1.SetCellEditable(row, "dpndnt_yn", 1) ;
                    sheet1.SetCellEditable(row, "spouse_yn", 1) ;
                    
                    sheet1.SetCellEditable(row, "child_yn", 0) ;
                    sheet1.SetCellValue(row,"child_yn", "N") ;
                    
                } else if(sheet1.GetCellValue(row,"fam_cd") == "8"){      //위탁아동 : 8
                   if( age < 18){  //아동복지법상 18세 미만
                        sheet1.SetCellEditable(row, "dpndnt_yn", 1) ;
                        sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                        sheet1.SetCellEditable(row, "woman_yn", 0) ;
                        sheet1.SetCellEditable(row, "hndcp_yn", 1) ;
                        
                        sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;

                        if( age <= 6){
                            sheet1.SetCellEditable(row, "child_yn", 1) ;
                            if(sheet1.GetCellValue(row, "sStatus")!="R"){
                                if(sheet1.GetCellValue(row,"child_yn")=="N"){
                                	//if(confirm('자녀양육을 선택 하시겠습니까?')){
                                        sheet1.SetCellValue(row,"child_yn", "Y") ;
                                    //}
                                }
                            }
                        } else{
                            sheet1.SetCellEditable(row, "child_yn", 0) ;
                        }
                    }
                    if(age >= 18){
                        sheet1.SetCellValue(row, "hndcp_yn", "Y") ;
                    }
                } else if(sheet1.GetCellValue(row,"fam_cd") == "7"){      //수급자 : 7
                    sheet1.SetCellEditable(row, "spouse_yn", 0) ;
                    sheet1.SetCellEditable(row, "senior_yn", 0) ;
                    sheet1.SetCellEditable(row, "woman_yn", 0) ;
                    sheet1.SetCellEditable(row, "hndcp_yn", 1);
                    
                    sheet1.SetCellEditable(row, "child_yn", 0) ;
                    sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    
                    sheet1.SetCellValue(row,"spouse_yn", "N") ;
                    sheet1.SetCellValue(row,"woman_yn", "N") ;
                    
                    sheet1.SetCellValue(row,"child_yn", "N") ;
                    sheet1.SetCellValue(row,"adopt_born_yn", "N") ;
                    
                    
                } else{                                            //기타 : 7
                    sheet1.SetCellEditable(row, "senior_yn", 0) ;
                    sheet1.SetCellEditable(row, "hndcp_yn", 0) ;
                    sheet1.SetCellValue(row,"hndcp_yn", "N") ;
                    
                    sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                    sheet1.SetCellValue(row,"hndcp_yn", "N") ;
                    
                }//end if(가족관계)

                /*공통적으로 기본공제 대상자중에 70세이상이면 경로우대*/
                if( age >= 70){
                    sheet1.SetCellEditable(row, "senior_yn", 0) ;
                    sheet1.SetCellValue(row,"senior_yn", "Y") ;
                } else{
                    sheet1.SetCellEditable(row, "senior_yn", 0) ;
                    sheet1.SetCellValue(row,"senior_yn", "N") ;
                }

            }//end if(주민등록번호 입력여부)
        } else{
            //가족관계확인해서 남남인경우..
            if(sheet1.GetCellValue(row,"fam_cd") == "1" || sheet1.GetCellValue(row,"fam_cd") == "2" || sheet1.GetCellValue(row,"fam_cd") == "4" || sheet1.GetCellValue(row,"fam_cd") == "5" ||
               sheet1.GetCellValue(row,"fam_cd") == "6" || sheet1.GetCellValue(row,"fam_cd") == "3" || sheet1.GetCellValue(row,"fam_cd") == "7" || sheet1.GetCellValue(row,"fam_cd") == "8"){

                sheet1.SetCellEditable(row, "senior_yn", 0) ;
                sheet1.SetCellValue(row,"senior_yn", "N") ;
                sheet1.SetCellValue(row,"spouse_yn", "N") ;
                sheet1.SetCellEditable(row, "hndcp_yn", 0) ;
                sheet1.SetCellValue(row,"hndcp_yn", "N") ;
                
                sheet1.SetCellEditable(row, "child_yn", 0) ;
                sheet1.SetCellEditable(row, "adopt_born_yn", 0) ;
                sheet1.SetCellValue(row,"adopt_born_yn", "N") ;
                
                if(sheet1.GetCellValue(row,"fam_cd") == "4" || sheet1.GetCellValue(row,"fam_cd") == "5"){
                    if( age <= 6){
                        //sheet1.SetCellEditable(row, "child_yn", 1) ;
                        if(sheet1.GetCellValue(row, "sStatus")!="R"){
                            if(sheet1.GetCellValue(row,"child_yn")=="Y"){
                            	sheet1.SetCellValue(row,"child_yn", "N") ;
//                                 if(confirm('자녀양육 선택을 해제 하시겠습니까?')){
//                                     sheet1.SetCellValue(row,"child_yn", "N") ;
//                                 }
                            }
                        }
                    }else{
                        sheet1.SetCellEditable(row, "child_yn", 0) ;
                        sheet1.SetCellValue(row,"child_yn", "N") ;
                    }
                }
                
            }//end if(가족관계코드 비교)
        }
    }

    function sheetChangeCheck() {
        var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D");
        if ( 0 < iTemp ) return true;
        return false;
    }

    //[총급여] 보이기
    function paytotMonView(){
        if(paytotMonStr != ""){
            if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 41470588 ) {
                $("#span_paytotMonView").html("<B>YES</B>&nbsp;<a href='javascript:paytotMonViewClose()' ><font color='red'>[닫기]</font></a>") ;
            } else {
                $("#span_paytotMonView").html("<B>NO</B>&nbsp;<a href='javascript:paytotMonViewClose()' ><font color='red'>[닫기]</font></a>") ;
            }
        } else {
            alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
        }
    }
    
    //[총급여] 닫기
    function paytotMonViewClose(){
        $("#span_paytotMonView").html("");
    }

    function openYeaDataPerBefPopup(){
    	var searchWorkYy = parseInt($("#searchWorkYy").val(), 10) - 1;
    	
    	var w 		= 900;
		var h 		= 580;
		var url 	= "<%=jspPath%>/yeaData/yeaDataPerBefPopup.jsp?authPg=R";
		var args 	= new Array();
		args["searchWorkYy"]		= searchWorkYy ;
		args["searchAdjustType"]	= $("#searchAdjustType").val() ;
		args["searchSabun"]		= $("#searchSabun").val() ;
		
		if(!isPopup()) {return;}
		var rv = openPopup(url,args,w,h);
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
            <li class="txt">기본공제
                <a href="javascript:yeaDataExpPopup('기본공제', helpText1, 550);"       class="cute_gray authR">기본공제 안내</a>
            </li>
            <li class="btn">
            <a href="javascript:doAction1('confirm');" class="button authA"><b id="authText">확정</b></a>
            </li>
        </ul>
        </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
    <colgroup>
        <col width="20%" />
        <col width="30%" />
        <col width="20%" />
        <col width="30%" />
    </colgroup>
    <tr>
        <th class="center">배우자 공제 여부</th>
        <th class="center">직계존속</th>
        <th class="center">직계비속, 입양자, 위탁아동, 수급자</th>
        <th class="center">형제자매</th>
    </tr>
    <tr>
        <td class="center">
            <input name="A010_03" id="A010_03" type="radio" class="radio" value="Y" disabled />&nbsp;예
            <input name="A010_03" id="A010_03" type="radio" class="radio" value="N" disabled />&nbsp;아니오
        </td>
        <td class="right">
            <input name="A010_05" type="text" class="text w25p right transparent" id="A010_05" readonly /> 명
        </td>
        <td class="right">
            <input id="A010_07" name="A010_07" type="text" class="text w25p right transparent" readOnly />명
        </td>
        <td class="right">
            <input id="A010_09" name="A010_09" type="text" class="text w25p right transparent" readOnly />명
        </td>
    </tr>
    </table>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">추가공제
                <a href="javascript:yeaDataExpPopup('추가공제', helpText2, 590, 650);"       class="cute_gray authR">추가공제 안내</a>
            </li>
        </ul>
        </div> 
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer ">
    <colgroup>
        <col width="14%" />
        <col width="14%" />
        <col width="14%" />
        <col width="14%" />
        <col width="14%" />
        <col width="14%" />
        <col width="14%" />
    </colgroup>
    <tr>
        <th class="center">경로우대공제</th>
        <th class="center">장애인공제</th>
        <th class="center">부녀자공제여부</th>
        <th class="center">한부모공제여부</th>
        <th class="center">자녀세액공제</th>
        <th class="center">6세이하자녀양육세액공제</th>
        <th class="center">출산입양세액공제</th>
    </tr>
    <tr>
        <td class="right">
            <input name="A020_03" type="text" class="text w25p right transparent" id="A020_03" readonly /> 명
        </td>
        <td class="right">
            <input name="A020_05" type="text" class="text w25p right transparent" id="A020_05" readonly /> 명
        </td>
        <td class="center">
            <input name="A020_07" id="A020_07" type="radio" class="radio" value="Y" disabled />&nbsp;예
            <input name="A020_07" id="A020_07" type="radio" class="radio" value="N" disabled />&nbsp;아니오
        </td>
        <td class="center">
            <input name="A020_14" id="A020_14" type="radio" class="radio" value="Y" disabled />&nbsp;예
            <input name="A020_14" id="A020_14" type="radio" class="radio" value="N" disabled />&nbsp;아니오
        </td>
        <td class="right">
            <input name="B000_10" type="text" class="text w25p right transparent" id="B000_10" readonly /> 명
        </td>
        
        <td class="right">
            <input id="B001_20" name="B001_20" type="text" class="text w25p right transparent"  readonly /> 명
        </td>
        <td class="right">
            <input id="B001_30" name="B001_30" type="text" class="text w25p right transparent"  readonly /> 명
        </td>
        
        
        
        
    </tr>
    </table>
 
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">인적공제
                <span id="paytotMonViewYn">
                    <a href="javascript:paytotMonView();" class="basic authA"><b><font color="red">[근로소득금액 3000만원 초과여부]</font></b></a>
                </span>
                <span id="span_paytotMonView" ></span>
            </li>
            <li class="btn">
            <a href="javascript:openYeaDataPerBefPopup();" class="button authA"><b>과거 인적공제 현황</b></a>
            <span id="btnDisplayYn02">
            <a href="javascript:doAction1('Search');"   class="basic authR" id="btnSearch">조회</a>
            <a href="javascript:doAction1('Insert');"   class="basic authA" id="btnInsert">입력</a>
            <a href="javascript:doAction1('Save');"     class="basic authA" id="btnSave">저장</a>
            </span>
        </li>
        </ul>
        </div>
    </div>
    <div style="height:290px">
    <script type="text/javascript">createIBSheet("sheet1", "100%", "290px"); </script>
    </div>
</div>
</body>
</html>