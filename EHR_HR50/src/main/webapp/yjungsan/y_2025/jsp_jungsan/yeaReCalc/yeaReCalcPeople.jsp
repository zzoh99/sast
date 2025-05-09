<%@page import="java.text.SimpleDateFormat"%>
<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>재정산대상자관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%

	String ssnSearchType = (String)session.getAttribute("ssnSearchType");
	Date today = new Date();
	SimpleDateFormat date = new SimpleDateFormat("yyyy");
	//이번년도
	String toYear = date.format(today);

	//3년전
	Calendar mon = Calendar.getInstance();
	mon.add(Calendar.YEAR , -3);
	String beforeYear = new java.text.SimpleDateFormat("yyyy").format(mon.getTime());

%>
<script type="text/javascript">
	$(function() {
		$("#searchWorkYy").val("<%=yeaYear%>") ;
		$("#searchYear").val("<%=yeaYear%>") ;
        
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",                   Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"선택",		            Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"set_final",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"삭제",                  Type:"<%=sDelTy%>",   Hidden:1,  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",                  Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"년도",                  Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"work_yy",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"재정산\n상태",	        Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"pay_people_status",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"재정산\n마감",            Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",        ColMerge:0,   SaveName:"final_close_yn",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N"},
            {Header:"성명",                  Type:"Popup",     Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"name",                  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100, FontColor:"#0000ff" },
            {Header:"사번",                  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"sabun",                 KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"정산구분",               Type:"Combo",       Hidden:0,  Width:80,     Align:"Center",    ColMerge:0,   SaveName:"adjust_type_nm", KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"정산구분",		        Type:"Text",		Hidden:1,  Width:80,	Align:"Center",	 ColMerge:1,   SaveName:"adjust_type", KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
            {Header:"재정산\n구분",            Type:"Combo",		Hidden:0,  Width:70,	Align:"Center",	 ColMerge:0,   SaveName:"gubun",	      KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"재정산\n차수",	        Type:"Int",		    Hidden:0,  Width:60,	Align:"Center",	 ColMerge:0,   SaveName:"re_seq",	      KeyField:0,				Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },            
            {Header:"사업장",                 Type:"Text",            Hidden:0,  Width:80,     Align:"Center",    ColMerge:1,   SaveName:"business_place_nm",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사업장코드",              Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"business_place_cd",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"정산코드",               Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"pay_action_cd",         KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"조직코드",               Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"org_cd",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"부서명",                Type:"Text",      Hidden:0,  Width:120,  Align:"Left",          ColMerge:0,   SaveName:"org_nm",                KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"세액계산방식",            Type:"Combo",     Hidden:0,  Width:110,  Align:"Center",        ColMerge:0,   SaveName:"tax_type",              KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:35 },
            {Header:"외국인\n단일세율적용",     Type:"Combo",     Hidden:0,  Width:110,  Align:"Center",        ColMerge:0,   SaveName:"foreign_tax_type",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
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
            {Header:"귀속시작일",            Type:"Date",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"adj_s_ymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:8 },
            {Header:"귀속종료일",            Type:"Date",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"adj_e_ymd",          KeyField:0,   CalcLogic:"",   Format:"Ymd",     PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:8 },
            {Header:"신고제외\n여부",         Type:"CheckBox",  Hidden:0,  Width:100,   Align:"Center",        ColMerge:0,   SaveName:"except_yn",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1, TrueValue:"Y", FalseValue:"N"},            
            {Header:"재정산\n추징일",	    Type:"Date",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"re_ymd", 			KeyField:0,	Format:"Ymd",   PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
			{Header:"재정산\n사유",	    Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"re_reason", 		KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"재정산\n메모",	    Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"memo",  		    KeyField:0,	Format:"",      PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }			

			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var payPeopleStatusList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00125"), "");
        var nationalCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","H20295"), "");
		var foreignTaxTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y&searchYear=<%=yeaYear%>","C00170"), "");
		var taxTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00450"), "");
		var adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
				
        sheet1.SetColProperty("pay_people_status", {ComboText:"|삭제됨|"+payPeopleStatusList[0], ComboCode:"|-DDD|"+payPeopleStatusList[1]} );        
		sheet1.SetColProperty("national_cd",    {ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );
		sheet1.SetColProperty("foreign_tax_type",    {ComboText:"|"+foreignTaxTypeList[0], ComboCode:"|"+foreignTaxTypeList[1]} );
		sheet1.SetColProperty("tax_type",    {ComboText:"|"+taxTypeList[0], ComboCode:"|"+taxTypeList[1]} );
        sheet1.SetColProperty("adjust_type_nm",  	{ComboText:"|연말정산|퇴직정산", ComboCode:"|1|3"});
		sheet1.SetColProperty("gubun", 	            {ComboText:"|최종|수정(이력)",        ComboCode:"|F|H"});
		
		$("#searchAdjustType").html(adjustTypeList[2]).val("");
		
        // 사업장(권한 구분)
		var ssnSearchType  = "<%=ssnSearchType%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize); sheetInit();
        
		<%-- 속도저하 때문에 아래와 같이 변경 20240710
		//해당 년도의 재정산 차수 리스트 조회
		var strUrl = "<%=jspPath%>/yeaCalcSearch/yeaCalcSearchRst.jsp?cmd=selectYeaReSeqList&searchYear=<%=yeaYear%>" ;
		var searchReSeq = stfConvCode( codeList(strUrl,"") , "");   			
		$("#searchReSeq").html(searchReSeq[2]); //전체로 초기 세팅 --%>
		var searchReSeq = "";
		for (var i=1; i<11; i++) { // 디폴트로 10회차까지 표시
			searchReSeq = searchReSeq + "<option value='" + i + "'>" + i + "회차</option>";
		}
		$("#searchReSeq").html(searchReSeq); //전체로 초기 세팅
		$("#searchReSeq").select2({
		placeholder: "전체"
		, maximumSelectionSize:5
		});
		
		doAction1("Search");
				
	});

	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
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

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
        case "Search":      //조회        
        	var param = $("#sheetForm").serialize() 
        	          + "&mSearchReSeq="+($("#searchReSeq").val()==null?"":getMultiSelect($("#searchReSeq").val()));
            sheet1.DoSearch( "<%=jspPath%>/yeaReCalc/yeaReCalcPeopleRst.jsp?cmd=selectYeaReCalcPeopleList", param);
            break;
        case "Save":        //저장
        	sheet1.DoSave( "<%=jspPath%>/yeaReCalc/yeaReCalcPeopleRst.jsp?cmd=saveYeaReCalcPeople", $("#sheetForm").serialize() );
            break;
        case "chgFinal":    //최종으로변경    		
            var retVailid = isSetFinal() ; // "최종으로변경"할 대상이 선택됐는지 체크
        
        	if (retVailid == 0) {
        		alert("최종으로 변경할 수정(이력)이 선택되지 않았습니다.\n최종으로 변경할 수정(이력)을 먼저 선택하십시오.") ;
        		return;
        	} else if (retVailid < 0) {
        		alert("동일 대상의 수정(이력)이 중복 선택 되었습니다.\n최종 자료로 변경할 수정(이력)을 대상자별 한 건만 선택하십시오.") ;
        		return;
        	} else if (!confirm("수정(이력) 자료를 최종 자료로 변경하시겠습니까? (총 " + retVailid + "인)")) {
        		return;
        	}
        	
        	sheet1.DoSave( "<%=jspPath%>/yeaReCalc/yeaReCalcPeopleRst.jsp?cmd=chgFinalYeaReCalcPeople", { Param : $("#sheetForm").serialize(), Quest : 0 } );
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

            if(Code == 1) {
            	var rowCnt = sheet1.RowCount()+1;
                for(var i = 1; i < rowCnt; i++) {
                	if ( "-DDD" == sheet1.GetCellValue(i,"pay_people_status") ) {
	    				sheet1.SetRowEditable(i, 0);  //실제 삭제할 경우 원본 자료 매핑에 문제가 있음. 플래그 처리로 변경. 20241119
						sheet1.SetRowFontColor(i, "#CCCCCC");
						sheet1.SetCellFontColor(i, "pay_people_status", "#000000");
	    			} else {
	                	//마감이거나, 최초 정상 계산건은 수정할 수 없음.
	   					if ( "Y" == sheet1.GetCellValue(i,"final_close_yn") || "1" == sheet1.GetCellValue(i,"re_seq") ) {
	   						sheet1.SetRowEditable(i, 0);
	   	    			}
	
	   	    			if ( "F" == sheet1.GetCellValue(i,"gubun") ) {
	   	   				    // 최종은 폰트색상 파란색
	   						sheet1.SetCellFontColor(i, "gubun",  "#0000FF");
	   						sheet1.SetCellFontColor(i, "re_seq", "#0000FF");
	   	    			} else {
	   	    			    //수정(이력)은 "최종으로변경" 선택할 수 있도록.
	   	    				sheet1.SetCellEditable(i, "set_final", 1);
	   	    			}
	    			}
                }
            }
            sheetResize();
        } catch (ex) {
            alert("OnSearchEnd Event Error : " + ex);
        }
    }

	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
        	alertMessage(Code, Msg, StCode, StMsg);

            if(Code == 1) {
                doAction1("Search") ;
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
	
	var gPRow  = "";
	var pGubun = "";

	//팝업 클릭시 발생
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
            }
        } catch (ex) {
            alert("OnPopupClick Event Error : " + ex);
        }
    }

	//값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value, OldValue) {
		//저장 시 날짜 시작/종료 Validation 20240717
	  	try {
			if(Col == sheet1.SaveNameCol("reduce_s_ymd")){
				// 시작일이 종료일보다 클 경우
				if(sheet1.GetCellValue(Row, "reduce_e_ymd") !== ""){
					if(isAfter(sheet1.GetCellValue(Row, "reduce_s_ymd"),sheet1.GetCellValue(Row, "reduce_e_ymd"))){
						alert("감면기간 시작일은 종료일보다 이전이어야 합니다.");
						sheet1.SetCellValue(Row, "reduce_s_ymd", OldValue);
						return false;
					}
				}
			}else if(Col == sheet1.SaveNameCol("reduce_e_ymd")){
				// 시작일이 종료일보다 클 경우
				if(sheet1.GetCellValue(Row, "reduce_s_ymd") !== ""){
					if(isAfter(sheet1.GetCellValue(Row, "reduce_s_ymd"),sheet1.GetCellValue(Row, "reduce_e_ymd"))){
						alert("감면기간 시작일은 종료일보다 이전이어야 합니다.");
						sheet1.SetCellValue(Row, "reduce_e_ymd", OldValue);
						return false;
					}
				}
			}else if(Col == sheet1.SaveNameCol("adj_s_ymd")){
				// 시작일이 종료일보다 클 경우
				if(sheet1.GetCellValue(Row, "adj_e_ymd") !== ""){
					if(isAfter(sheet1.GetCellValue(Row, "adj_s_ymd"),sheet1.GetCellValue(Row, "adj_e_ymd"))){
						alert("귀속시작일은 종료일보다 이전이어야 합니다.");
						sheet1.SetCellValue(Row, "adj_s_ymd", OldValue);
						return false;
					}
				}
			}
			else if(Col == sheet1.SaveNameCol("adj_e_ymd")){
				// 시작일이 종료일보다 클 경우
				if(sheet1.GetCellValue(Row, "adj_s_ymd") !== ""){
					if(isAfter(sheet1.GetCellValue(Row, "adj_s_ymd"),sheet1.GetCellValue(Row, "adj_e_ymd"))){
						alert("귀속시작일은 종료일보다 이전이어야 합니다.");
						sheet1.SetCellValue(Row, "adj_e_ymd", OldValue);
						return false;
					}
				}
			}
		} catch (e) {
			
		}	
	}
	
	// 일자 비교 함수
	function isAfter(date1, date2) {
	    return date1*1 > date2*1;
	}

	// "최종으로변경"할 대상이 선택됐는지 체크
	function isSetFinal() {		
    	var cntSel = 0;
		var arr = new Array();
    	
        for(var i = 1; i < sheet1.RowCount()+1; i++) {    		
			if ( "Y" == sheet1.GetCellValue(i,"set_final") ) {
	    		var thisVal = sheet1.GetCellValue(i,"adjust_type_nm") + "_" + sheet1.GetCellValue(i,"sabun") ;
	    		
				if (i > 1) { //처음은 중복체크 스킵
					for(var j = 0; j < arr.length; j++) {
						if (arr[j] == thisVal) { //중복
							cntSel = -1;
						    return cntSel ;
						}
					}
				}
				arr.push(thisVal);
				cntSel++;
   			}
        }
        
	    return cntSel ;
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
	
	//	"최종" 일 경우 차수를 선택하는 selectbox 비활성화 처리. (차수는 수정(이력) 에서만 부여되기 때문에 최종에서는 의미가 없음)
    function searchGubun_onChange() {
		var searchGubun = $("#searchGubun").val();
		
    	/* searchReSeq 콤보박스는 Select2 플러그인을 사용하여 다중선택콤보로 커스텀 UI가 적용되어 있음. (위 338 라인)
    	---------------------------------------------------------------------------------------------
    	<select> 요소에 스타일과 기능을 추가하면 기본적으로 HTML <select> 요소의 UI가 Select2의 커스텀 UI로 대체되므로
    	disabled를 설정하려면 Select2 API를 통해 해당 상태를 전달해야 함. 
    	(Select2는 자체적으로 UI를 관리하며, 기본 <select> 요소의 disabled 상태를 감지하지 않음.) */
		if(searchGubun == "F") {
			$('#searchReSeq').val(null).trigger('change'); // 선택된 옵션을 초기화하고 Select2에 변경사항을 알림
			$('#searchReSeq').prop('disabled', true);      // 기본 select 요소 비활성화
		} else {
			$('#searchReSeq').prop('disabled', false);
		}
		
		// 설정한 내용을 기준으로 Select2 인스턴스를 다시 초기화하여 반영
   		$("#searchReSeq").select2({
		  	  placeholder: "전체" // 아무것도 선택되지 않았을 때 표시할 텍스트
			, maximumSelectionSize:5
		});
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
    <input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="">
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <div class="sheet_search outer">
        <div>
        <table>
			<tr>
			    <td><span>귀속년도</span>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				</td>
				<td><span>정산구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" class="box"></select>
				</td>
				<td>
                    <span>재정산</span>
                    <select id="searchGubun" name ="searchGubun" class="box" onChange="javascript:searchGubun_onChange()">
                    	<option value="">전체</option>
                    	<option value="F">최종</option>
                    	<option value="H">수정(이력)</option>
                    </select>
                    <select id="searchReSeq" name="searchReSeq" multiple></select>
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box"></select>
                </td>
				<td><span>사번/성명</span>
                <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td>
					<span>조회기준</span>
					<select id="searchDDD" name ="searchDDD" onChange="javascript:doAction1('Search');" class="box">
						<option value="">삭제자료포함</option>
						<option value="1" selected="selected">삭제자료제외</option>
						<option value="2">삭제자료만</option>
					</select>
				</td>
				<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
				
			</tr>
        </table>
        </div>
    </div>
    
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li id="strSheetTitle" class="txt">재정산대상자</li>
            <li class="btn">
                <font class='blue'>[재정산계산]이 <strong>마감</strong>되었거나, 최초원본(<strong>1차수</strong>), 최종 자료는 수정할 수 없습니다. </font>
                <span>사번/성명 </span>
                <input id="findName" name ="findName" type="text" class="text w90" onKeyUp="check_Enter();" />
                <a onclick="javascript:findName();" onFocus="this.blur()" href="javascript:void(0);" class="basic btn-white ico-search no-text"></a>
                <a href="javascript:doAction1('Save')"  class="basic btn-save authA">저장</a>
                <a href="javascript:doAction1('chgFinal')"  class="basic btn-red out-line authA">최종으로변경</a>
                <a href="javascript:doAction1('Down2Excel')"    class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</form>
</div>
</body>
</html>