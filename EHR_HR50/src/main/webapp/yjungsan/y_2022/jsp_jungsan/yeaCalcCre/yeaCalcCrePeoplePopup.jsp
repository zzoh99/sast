<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>대상자정보</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");
    var zipcodePg = "";

    $(function() {
    	$("#menuNm").val($(document).find("title").text());
        var arg = p.window.dialogArguments;

        if( arg != undefined ) {
            $("#searchWorkYy").val(arg["searchWorkYy"]);
            $("#searchAdjustType").val(arg["searchAdjustType"]);
            $("#searchSabun").val(arg["searchSabun"]);
            $("#searchPayActionCd").val(arg["searchPayActionCd"]);
            $("#searchPayActionNm").val(arg["searchPayActionNm"]);
            $("#searchBizPlaceCd").val(arg["searchBizPlaceCd"]);

        }else{

            var searchWorkYy        = "";
            var searchAdjustType    = "";
            var searchSabun         = "";
            var searchPayActionCd   = "";
            var searchPayActionNm   = "";
            var searchBusinessCd    = "";

            searchWorkYy      = p.popDialogArgument("searchWorkYy");
            searchAdjustType  = p.popDialogArgument("searchAdjustType");
            searchSabun       = p.popDialogArgument("searchSabun");
            searchPayActionCd = p.popDialogArgument("searchPayActionCd");
            searchPayActionNm = p.popDialogArgument("searchPayActionNm");
            searchBusinessCd  = p.popDialogArgument("searchBizPlaceCd");


            $("#searchWorkYy").val(searchWorkYy);
            $("#searchAdjustType").val(searchAdjustType);
            $("#searchSabun").val(searchSabun);
            $("#searchPayActionCd").val(searchPayActionCd);
            $("#searchPayActionNm").val(searchPayActionNm);
            $("#searchBizPlaceCd").val(searchBusinessCd);
        }

        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"No",                    Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",                  Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",                  Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"년도",                  Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"work_yy",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분",              Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"adjust_type",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"작업\n대상_실제값",     Type:"Text",      Hidden:1,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"pay_people_status",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"작업\n대상",            Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",        ColMerge:0,   SaveName:"pay_people_status_view",KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"작업",                  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"temp",                  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"마감\n여부",            Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",        ColMerge:0,   SaveName:"final_close_yn",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N"},
            {Header:"성명",                  Type:"Popup",     Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"name",                  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100, FontColor:"#0000ff" },
            {Header:"사번",                  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"sabun",                 KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"사업장코드",            Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"business_place_cd",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"정산코드",              Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"pay_action_cd",         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"조직코드",              Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"org_cd",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"부서명",                Type:"Text",      Hidden:0,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"org_nm",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"세액계산방식",          Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"tax_type",              KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:35 },
            {Header:"외국인\n단일세율적용",  Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"foreign_tax_type",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
            {Header:"감면기간F",             Type:"Date",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"reduce_s_ymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:8 },
            {Header:"감면기간T",             Type:"Date",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"reduce_e_ymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:8 },
            {Header:"우편번호",              Type:"Popup",     Hidden:1,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"zip",                   KeyField:0,   CalcLogic:"",   Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:6 },
            {Header:"주소1",                 Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"addr1",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:4000 },
            {Header:"주소2",                 Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"addr2",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:4000 },
            {Header:"inputCloseYn",          Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"input_close_yn",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
            {Header:"apprvYn",               Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"apprv_yn",              KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
            {Header:"houseOwnerYn",          Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"house_owner_yn",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
            {Header:"주택취득일",            Type:"Date",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"house_get_ymd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:8 },
            {Header:"전용면적",              Type:"Float",     Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"house_area",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:35 },
            {Header:"공시시가",              Type:"Int",       Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"official_price",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:35 },
            {Header:"국가코드",              Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"national_cd",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10 },
            {Header:"국가명",                Type:"Text",      Hidden:1,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"national_nm",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100 },
            {Header:"결과확인여부",          Type:"Text",      Hidden:1,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"result_confirm_yn",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
            {Header:"주택소유수",            Type:"Text",      Hidden:1,  Width:100,  Align:"Right",         ColMerge:0,   SaveName:"house_cnt",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:35 },
            {Header:"귀속시작일",            Type:"Date",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"adj_s_ymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"귀속종료일",            Type:"Date",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"adj_e_ymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
            {Header:"신고제외\n여부",         Type:"CheckBox",  Hidden:0,  Width:100,   Align:"Center",        ColMerge:0,   SaveName:"except_yn",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N"},
            {Header:"연말정산계산결과사번",  Type:"Text",      Hidden:1,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"adj_sabun",          KeyField:0,   CalcLogic:"",   Format:"",     		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }

        ]; IBS_InitSheet(sheet1, initdata1);  sheet1.SetEditable("<%=editable%>"); sheet1.SetCountPosition(4);

        var nationalCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","H20295"), "");
        var foreignTaxTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y","C00170"), "");
        var taxTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00450"), "");

        sheet1.SetColProperty("national_cd",    {ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );
        sheet1.SetColProperty("foreign_tax_type",    {ComboText:"|"+foreignTaxTypeList[0], ComboCode:"|"+foreignTaxTypeList[1]} );
        sheet1.SetColProperty("tax_type",    {ComboText:"|"+taxTypeList[0], ComboCode:"|"+taxTypeList[1]} );

        /*2015.12.17 MODIFY 우편번호 개편 디비 적용여부에 따라 우편번호 화면 분기됨. (시스템사용기준 : ZIPCODE_REF_YN) */
		var zipcodeRefYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=ZIPCODE_REF_YN", "queryId=getSystemStdData",false).codeList;
		if ( zipcodeRefYn != null && zipcodeRefYn.length>0) {
			if(zipcodeRefYn[0].code_nm == "Y") {
				zipcodePg = "Ref";
			} else if(zipcodeRefYn[0].code_nm == "W") {
			    zipcodePg = "new";
			}
		}

        $(window).smartresize(sheetResize); sheetInit();

        doAction1("Search");
    });

    $(function(){
        $(".close").click(function() {
            p.self.close();
        });
    });

    //대상자 찾기
    function findName(){
        if($("#findName").val() == "") return;
        var Row = 0;
        if(sheet1.GetSelectRow() < sheet1.LastRow()){
            Row = sheet1.FindText("name", $("#findName").val(), sheet1.GetSelectRow()+1, 2);
            // 사번
            if(Row == -1){
            	Row = sheet1.FindText("sabun", $("#findName").val(), sheet1.GetSelectRow()+1, 2);
            }

            if(Row > 0){
                sheet1.SelectCell(Row,"sabun");
            }else if(Row == -1){
                if(sheet1.GetSelectRow() > 1){
                    Row = sheet1.FindText("sabun", $("#findName").val(), 1, 2);
                    if(Row > 0){
                        sheet1.SelectCell(Row,"sabun");
                    }
                }
            }
        }else{
            Row = -1;
        }

        if(Row > 0){
            sheet1.SelectCell(Row,"name");
        }else if(Row == -1){
            if(sheet1.GetSelectRow() > 1){
                Row = sheet1.FindText("name", $("#findName").val(), 1, 2);
                if(Row > 0){
                    sheet1.SelectCell(Row,"name");
                }
            }
        }
        $("#findName").focus();
    }

    function check_Enter(){
        if (event.keyCode==13) findName();
    }

    /*Sheet Action*/
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":      //조회
            sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcCrePeoplePopupRst.jsp?cmd=selectYeaCalcCrePopupList", $("#sheetForm").serialize() );
            break;
        case "Save":        //저장
        	if(checkYeaCalcCre()) {
        		sheet1.DoSave( "<%=jspPath%>/yeaCalcCre/yeaCalcCrePeoplePopupRst.jsp?cmd=saveYeaCalcCrePopup", $("#sheetForm").serialize());
        	}
            break;
         case "Insert":
            var newRow = sheet1.DataInsert(0) ;
            sheet1.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val());
            sheet1.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val());
            sheet1.SetCellValue( newRow, "pay_action_cd", $("#searchPayActionCd").val());
            sheet1.SetCellEditable(newRow,"final_close_yn", 0);
            sheet1.SelectCell(newRow, 2);
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param);
            break;
        case "Down2Template":
            var param  = {DownCols:"sabun",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"};
            sheet1.Down2Excel(param);
            break;
        case "LoadExcel":
            var params = {Mode:"HeaderMatch", WorkSheetNo:1};
            sheet1.LoadExcel(params);
            break;
        }
    }

    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if(p.popReturnValue) p.popReturnValue("");

            if(Code == 1) {
            	var rowCnt = sheet1.RowCount()+1;
                for(var i = 1; i < rowCnt; i++) {
                    if( sheet1.GetCellValue(i, "pay_people_status") == "2"){

                        sheet1.SetCellValue(i,"pay_people_status_view", 1);
                        sheet1.SetCellEditable(i,"sDelete", 0);
                        sheet1.SetCellEditable(i,"pay_people_status_view", 0);
                        sheet1.SetCellValue(i, "temp", "완료");
                        sheet1.SetCellEditable(i,"name", 0);
                        // 사업장 선택 후 화면 진입시 마감여부 비활성화
                        if($("#searchBizPlaceCd").val().length > 0){
                        	sheet1.SetCellEditable(i,"final_close_yn", 0);
                        }else{
                        	sheet1.SetCellEditable(i,"final_close_yn", 1);
                        }
                    }
                    else if( sheet1.GetCellValue(i, "pay_people_status") == "1" ) {

                    	sheet1.SetCellValue(i,"pay_people_status_view", 1);
                        sheet1.SetCellEditable(i,"final_close_yn", 0);
                    }
                    else {

                    	sheet1.SetCellValue(i,"pay_people_status_view", 0);
                        sheet1.SetCellEditable(i,"final_close_yn", 0);
                    }

                    sheet1.SetCellValue(i, "sStatus", "R");
                }

            }
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
        	alertMessage(Code, Msg, StCode, StMsg);

            if(Code == 1) {
                doAction1("Search") ;
                //return
                //if(p.popReturnValue) p.popReturnValue("");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    function sheet1_OnValidation(Row, Col, Value) {
        try {
            if(sheet1.ColSaveName(Col) == "name"
                    && sheet1.GetCellEditable(Row, "name") == true
                    && sheet1.GetCellValue(Row, "sabun") == "" ) {
                alert("팝업 데이터가 선택되지 않았습니다.");
                sheet1.ValidateFail(1);
            }
        } catch (ex) {
            alert("OnValidation Event Error " + ex);
        }
    }

    var gPRow  = "";
    var pGubun = "";

    // 팝업 클릭시 발생
    function sheet1_OnPopupClick(Row,Col) {
        try {

            if(sheet1.ColSaveName(Col) == "zip") {

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
                    sheet1.SetCellValue(Row, "zip", rst[0]);
                    sheet1.SetCellValue(Row, "addr1", rst[1]);
                    sheet1.SetCellValue(Row, "addr2", rst[2]);
                }
                */
            } else if(sheet1.ColSaveName(Col) == "name") {
                openEmployeePopup(Row) ;
            }
        } catch (ex) {
            alert("OnPopupClick Event Error : " + ex);
        }
    }

    //클릭시 발생
    /*
    function sheet1_OnClick(Row, Col, Value) {
        try{
            if(sheet1.ColSaveName(Col) == "name") {
                openEmployeePopup(Row) ;
            }
        }catch(ex){
            alert("OnClick Event Error : " + ex);
        }
    }
    */

    function sheet1_OnChange(Row, Col){
   		if(sheet1.GetCellValue(Row,"final_close_yn") == "Y"){
       		sheet1.SetCellEditable(Row, "tax_type",0);
       		sheet1.SetCellEditable(Row, "foreign_tax_type",0);
       		sheet1.SetCellEditable(Row, "reduce_s_ymd",0);
       		sheet1.SetCellEditable(Row, "reduce_e_ymd",0);
       		sheet1.SetCellEditable(Row, "zip",0);
       		sheet1.SetCellEditable(Row, "addr1",0);
       		sheet1.SetCellEditable(Row, "addr2",0);
       		sheet1.SetCellEditable(Row, "national_cd",0);
       		sheet1.SetCellEditable(Row, "adj_s_ymd",0);
       		sheet1.SetCellEditable(Row, "adj_e_ymd",0);
       	}else{
       		sheet1.SetCellEditable(Row, "tax_type",1);
       		sheet1.SetCellEditable(Row, "foreign_tax_type",1);
       		sheet1.SetCellEditable(Row, "reduce_s_ymd",1);
       		sheet1.SetCellEditable(Row, "reduce_e_ymd",1);
       		sheet1.SetCellEditable(Row, "zip",1);
       		sheet1.SetCellEditable(Row, "addr1",1);
       		sheet1.SetCellEditable(Row, "addr2",1);
       		sheet1.SetCellEditable(Row, "national_cd",1);
       		sheet1.SetCellEditable(Row, "adj_s_ymd",1);
       		sheet1.SetCellEditable(Row, "adj_e_ymd",1);
       	}


    }
    //사원 조회
    function openEmployeePopup(Row){
        try{
            var args    = new Array();

            if(!isPopup()) {return;}
            gPRow  = Row;
            pGubun = "employeePopup";
            var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");

            /*
            if(rv!=null){
                sheet1.SetCellValue(Row, "business_place_cd", rv["business_place_cd"]);
                sheet1.SetCellValue(Row, "name", rv["name"]);
                sheet1.SetCellValue(Row, "sabun", rv["sabun"]);
                sheet1.SetCellValue(Row, "org_cd", rv["org_cd"]);
                sheet1.SetCellValue(Row, "org_nm", rv["org_nm"]);
            }
            */
        } catch(ex) {
            alert("Open Popup Event Error : " + ex);
        }
    }

    function getReturnValue(returnValue) {
        var rv = $.parseJSON('{'+ returnValue+'}');

        if ( pGubun == "zipCodePopup" ){
            //우편번호조회
            if(zipcodePg != "new") {
            	sheet1.SetCellValue(gPRow, "zip", rv[0]);
                sheet1.SetCellValue(gPRow, "addr1", rv[1]);
                sheet1.SetCellValue(gPRow, "addr2", rv[2]);
            }else{
	            sheet1.SetCellValue(gPRow, "zip", rv.zip);
	            sheet1.SetCellValue(gPRow, "addr1", rv.doroAddr);
	            sheet1.SetCellValue(gPRow, "addr2", rv.detailAddr);
            }
        } else if ( pGubun == "employeePopup" ){
            //사원조회
            sheet1.SetCellValue(gPRow, "business_place_cd", rv["business_place_cd"]);
            sheet1.SetCellValue(gPRow, "name", rv["name"]);
            sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
            sheet1.SetCellValue(gPRow, "org_cd", rv["org_cd"]);
            sheet1.SetCellValue(gPRow, "org_nm", rv["org_nm"]);
        }

        // 연말정산계산에서 선택한 사업장과 다른 사업장의 사용자 선택 시 초기화
        if(rv["business_place_cd"] != $("#searchBizPlaceCd").val() && $("#searchBizPlaceCd").val().length > 0){
        	alert("사업장에 속한 인원이 아닙니다.");
            sheet1.SetCellValue(gPRow, "business_place_cd", "");
            sheet1.SetCellValue(gPRow, "name", "");
            sheet1.SetCellValue(gPRow, "sabun", "");
            sheet1.SetCellValue(gPRow, "org_cd", "");
            sheet1.SetCellValue(gPRow, "org_nm", "");
        }
    }

    //작업 실행.
    function callProcedure(){
        if($("#searchPayActionCd").val() != ""){

            if(sheet1.RowCount() > 0){
                //if(!confirm("이미 대상자가 존재합니다. 덮어쓰시겠습니까?")) return;
                alert("이미 대상자가 존재할 때, 대상자 재생성은 진행되지 않습니다."
                        + "\n => 대상자를 생성하면 기존에 입력된 모든 공제자료가 삭제되기 때문에 주의하셔야합니다."
                        + "\n그래도 대상자를 재생성하셔야 하면, 모든 대상자를 삭제하신 후 생성하여 주시기 바랍니다."
                        + "\n => 직접 삭제할 때도, 모든 공제자료가 삭제되니 주의하시기 바랍니다.");
                return;
            }

            var data = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCrePeoplePopupRst.jsp?cmd=prcCpnYearEndEmp",$("#sheetForm").serialize(),false);

            if(data.Result.Code == 1) {
                doAction1("Search") ;
            }

            if(data.Result.Code == null) {
                alert("작업 완료") ;
            } else {
                msg = "처리도중 문제발생 : "+data.Result.Message;
            }
        }else{
            alert("년도를 선택하세요.");
        }
    }

  //업로드 완료후 호출
    function sheet1_OnLoadExcel(result) {
        try {
            for(var i = 1; i < sheet1.RowCount()+1; i++) {
                sheet1.SetCellValue( i, "work_yy", $("#searchWorkYy").val());
                sheet1.SetCellValue( i, "adjust_type", $("#searchAdjustType").val());
                sheet1.SetCellValue( i, "pay_action_cd", $("#searchPayActionCd").val());
                sheet1.SetCellEditable(i,"final_close_yn", 0);

            }
        } catch(ex) {
            alert("OnLoadExcel Event Error " + ex);
        }
    }

	function checkYeaCalcCre() {
		var arr = new Array();
		var obj = new Object();
		var isExeute = true;
		var type = "";

		for(var i = 1; i < sheet1.RowCount()+1; i++) {
			if( sheet1.GetCellValue(i, "sStatus") == "I") {
				type = "I";
				if($.trim(sheet1.GetCellValue(i, "sabun")).length == 0) {
					alert("사번이 입력되지 않은 행이 존재합니다.");
					isExeute = false;
					break;
				} else {
					isExeute = true;
					obj = new Object();
					obj.sabun = sheet1.GetCellValue(i,"sabun");
					obj.workYy = sheet1.GetCellValue(i,"work_yy");
					obj.adjustType = sheet1.GetCellValue(i,"adjust_type");
					arr.push(obj);
				}
        	}
		}

		if(type != "I") {
			isExeute = true;
		} else {
			if(isExeute) {

				var params = "&pValue=" + JSON.stringify(arr);
				var rtnResult = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcCrePeoplePopupRst.jsp?cmd=checkYeaCalcCrePopup",params,false);

				if(rtnResult.Result.Code == "1"){
					isExeute = true;
				} else {
					isExeute = false;
					if(rtnResult.Result.Code == "-3") {
						if(confirm("대상자 생성 후, 급여일자를 지운것으로 보이는 데이터가 있습니다.\n확인 및 삭제하시겠습니까?")) {

		            		if(!isPopup()) {return false;}
		                	pGubun = "yeaCalcDelPopup";

		                	var args    = new Array();
		                	var sabuns = "";
		                	for(var i = 1; i < sheet1.RowCount()+1; i++) {
		                		if( sheet1.GetCellValue(i, "sStatus") == "I" && sheet1.GetCellValue(i, "sabun") != "") {
		                			sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
		                    	}
		                	}

		                	if (sabuns.length > 1) {
		                        sabuns = sabuns.substr(0,sabuns.length-1);
		                    }

		                	var args = [];
		        			args["searchWorkYy"] = $("#searchWorkYy").val();
		        			args["searchAdjustType"] = $("#searchAdjustType").val();
		        			args["searchSabuns"] = sabuns;

		                    var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCreDeletePopup.jsp?authPg=<%=authPg%>", args, "740","520");

		            	}
					}
				}
			}
		}

		return isExeute;
	}
</script>

</head>
<body class="bodywrap">
<form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
    <input type="hidden" id="searchAdjustType" name="searchAdjustType" value="" />
    <input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="">
    <input type="hidden" id="searchBizPlaceCd" name="searchBizPlaceCd" value="">
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <div class="wrapper">
        <div class="popup_title">
        <ul>
            <li id="strTitle">대상자정보</li>
            <!-- <li class="close"></li>  -->
        </ul>
        </div>

        <div class="popup_main">
        <div>
            <table border="0" cellpadding="0" cellspacing="0" class="default outer">
            <colgroup>
                <col width="25%" />
                <col width="35%" />
                <col width="25%" />
                <col width="" />
            </colgroup>
                <tr>
                    <th class="left"> 작업일자 </th>
                    <td class="left">
                        <input type="text" id="searchPayActionNm" name="searchPayActionNm" value="" class="text w100p readonly transparent" readonly  >
                    </td>
                    <th class="left"> 대상자선정 </th>
                    <td class="center">
                        <a href="javascript:callProcedure();"   class="basic authA">생성</a>
                    </td>
                </tr>
            </table>
        </div>
            <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
                <tr>
                    <td class="top">
                        <div class="outer">
                            <div class="sheet_title">
                                <ul>
                                    <li id="strSheetTitle" class="txt">대상자</li>
                                    <li class="btn">
                                        <span>사번/이름 </span>
                                        <input id="findName" name ="findName" type="text" class="text w90" onKeyUp="check_Enter();" />
                                        <a onclick="javascript:findName();" onFocus="this.blur()" href="javascript:void(0);" class="basic btn-white ico-search no-text"></a>
                                        <a href="javascript:doAction1('Search')"    class="basic authR">조회</a>
                                        <a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a>
                                        <a href="javascript:doAction1('LoadExcel')"     class="basic btn-upload authA">업로드</a>
                                        <a href="javascript:doAction1('Insert')"    class="basic authA">입력</a>
                                        <a href="javascript:doAction1('Save')"  class="basic btn-save authA">저장</a>
                                        <a href="javascript:doAction1('Down2Excel')"    class="basic btn-download authR">다운로드</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
                    </td>
                </tr>
            </table>
            <!-- <div class="popup_button outer">
                <ul>
                    <li>
                        <a href="javascript:p.self.close();" class="gray large">닫기</a>
                    </li>
                </ul>
            </div> -->
        </div>
    </div>
</form>
</body>
</html>



