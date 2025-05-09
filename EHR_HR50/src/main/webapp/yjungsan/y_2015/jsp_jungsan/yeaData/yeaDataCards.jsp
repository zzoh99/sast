<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>신용카드</title>
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
    //총급여 확인 버튼 유무
    var yeaMonShowYn ;
    //신용,직/선불카드 - 개인별 총급여
    var paytotMonStr ;
    //본인 코드
    var gOwnFamCd;
    
    var famList;

    var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
    
    $(function() {
    	
        /*필수 기본 세팅*/
        $("#searchWorkYy").val(     $("#searchWorkYy", parent.document).val()       ) ;
        $("#searchAdjustType").val( $("#searchAdjustType", parent.document).val()   ) ;
        $("#searchSabun").val(      $("#searchSabun", parent.document).val()        ) ;
        systemYY = $("#searchWorkYy", parent.document).val();

        //기본정보 조회(도움말 등등).
        initDefaultData() ;

        if(orgAuthPg == "A") {
            $("#copyBtn").show() ;
        } else {
            $("#copyBtn").hide() ;
        }
        
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

        var inputEdit = 0 ;
        var applEdit = 0 ;
        if( orgAuthPg == "A") {
            inputEdit = 0 ;
            applEdit = 1 ;
        } else {
            inputEdit = 1 ;
            applEdit = 0 ;
        }
        
        //연말정산 신용카드 쉬트
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msAll};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"No|No",                        Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"삭제|삭제",                       Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
            {Header:"상태|상태",                       Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
            {Header:"년도|년도",                       Type:"Int",         Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"work_yy",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분|정산구분",                  Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"adjust_type",     KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"사번|사번",                       Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"sabun",           KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
            {Header:"순서|순서",                       Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:0, SaveName:"seq",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"명의인|명의인",                     Type:"Combo",      Hidden:0,   Width:80,  	Align:"Center", ColMerge:1, SaveName:"famres",          KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200 },
            {Header:"반기\n구분|반기\n구분",              Type:"Combo",       Hidden:0,   Width:80,   Align:"Center", ColMerge:1, SaveName:"half_gubun",      KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"신용카드\n구분|신용카드\n구분",      	Type:"Combo",       Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"card_type",       KeyField:1, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"카드명|카드명",                    Type:"Text",        Hidden:1,   Width:60,   	Align:"Left",   ColMerge:0, SaveName:"card_enter_nm",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"금액자료|직원용",                   Type:"AutoSum",     Hidden:0,   Width:110,  Align:"Right",  ColMerge:0, SaveName:"use_mon",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:inputEdit,   InsertEdit:inputEdit,   EditLen:35 },
            {Header:"금액자료|담당자용",                  Type:"AutoSum",     Hidden:0,   Width:110,  Align:"Right",  ColMerge:0, SaveName:"appl_mon",        KeyField:1, Format:"",  PointCount:0,   UpdateEdit:applEdit,    InsertEdit:applEdit,    EditLen:35 },
            {Header:"자료입력유형|자료입력유형",          	Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"adj_input_type",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"의료기관\n사용액|의료기관\n사용액",  	Type:"Text",        Hidden:1,   Width:60,   Align:"Right",  ColMerge:0, SaveName:"med_mon",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"회사지원금|회사지원금",              	Type:"Text",        Hidden:1,   Width:60,   Align:"Right",  ColMerge:0, SaveName:"co_deduct_mon",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"국세청\n자료여부|국세청\n자료여부",  	Type:"CheckBox",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"nts_yn",          KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"담당자확인|담당자확인",              	Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"feedback_type",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
        //대상자 전부 조회
        $("#searchFamCd_s").val("");
        var famAllList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeList&queryId=getFamCodeList",$("#sheetForm").serialize(),false).codeList, "");
        //공제대상자만 조회
        $("#searchFamCd_s").val(",'6','7','8'");
        famList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getFamCodeCardList&queryId=getFamCodeCardList",$("#sheetForm").serialize(),false).codeList, "");
        
        //신용카드구분 코드 조회
        var cardTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCardTypeCodeList&useYn=Y&note1=Y","C00305"), "");
        
        // 반기구분 코드 조회
        var halfGubunList    = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&visualYn=Y&useYn=Y","C00304"), "");
        var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
        var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");

        sheet1.SetColProperty("famres",         {ComboText:"|"+famAllList[0], ComboCode:"|"+famAllList[1]} );
        sheet1.SetColProperty("half_gubun",     {ComboText:"|"+halfGubunList[0], ComboCode:"|"+halfGubunList[1]} );
        sheet1.SetColProperty("card_type",      {ComboText:"|"+cardTypeList[0], ComboCode:"|"+cardTypeList[1]} );
        sheet1.SetColProperty("adj_input_type", {ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
        sheet1.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );

        
      	//양식다운로드 title 정의
		var codeCdNm = "", codeCd = "", codeNm = "";
		
		codeCdNm = "";
		codeNm = halfGubunList[0].split("|"); codeCd = halfGubunList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "반기구분 : " + codeCdNm + "\n";
		
		codeCdNm = "";
		codeNm = cardTypeList[0].split("|"); codeCd = cardTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "카드구분 : " + codeCdNm + "\n";
		
		templeteTitle1 += "국세청 자료여부 : Y, N \n";
		
		codeCdNm = "";
		codeNm = feedbackTypeList[0].split("|"); codeCd = feedbackTypeList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "담당자확인 : " + codeCdNm + "\n";
		
		
		
        $(window).smartresize(sheetResize);
        sheetInit();

        parent.doSearchCommonSheet();
        doAction1("Search");
        
    });

    //본인 정보 조회
    function getOwnDataInfo() {
        
        var ownDataInfo = ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectOwnDataInfo", $("#sheetForm").serialize(),false);

        gOwnFamCd = nvl(ownDataInfo.Data.own_fam_cd,"");
    }
    
    //전년도 합계 정보 조회
    function getPreYeaDataInfo_2014() {
        
        var preyeaInfo = ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectPreYeaDataInfo_2014", $("#sheetForm").serialize(),false);

        $("#preTotSum_2014").val(nvl(preyeaInfo.Data.pre_tot_sum,"0"));
        $("#billSum_2014").val(nvl(preyeaInfo.Data.bill_sum,"0"));
        $("#checkSum_2014").val(nvl(preyeaInfo.Data.check_sum,"0")) ;
        $("#marketSum_2014").val(nvl(preyeaInfo.Data.market_sum,"0")) ;
        $("#busSum_2014").val(nvl(preyeaInfo.Data.bus_sum,"0")) ;
        $("#checkBillSum_2014").val(nvl(preyeaInfo.Data.check_bill_sum,"0")) ;
    }
    
    //전년도 합계 정보 조회
	function getPreYeaDataInfo_2013() {
        
        var preyeaInfo = ajaxCall("<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectPreYeaDataInfo_2013", $("#sheetForm").serialize(),false);

        $("#preTotSum_2013").val(nvl(preyeaInfo.Data.pre_tot_sum,"0"));
        $("#billSum_2013").val(nvl(preyeaInfo.Data.bill_sum,"0"));
        $("#checkSum_2013").val(nvl(preyeaInfo.Data.check_sum,"0")) ;
        $("#marketSum_2013").val(nvl(preyeaInfo.Data.market_sum,"0")) ;
        $("#busSum_2013").val(nvl(preyeaInfo.Data.bus_sum,"0")) ;
        $("#checkBillSum_2013").val(nvl(preyeaInfo.Data.check_bill_sum,"0")) ;
    }
    
    //연말정산 신용카드
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            
        	var sumColsInfo = "use_mon|appl_mon"; 
        	//데이터가 너무 세분화 되어 반기로 구분함  
            var info =[{StdCol:"half_gubun", SumCols:sumColsInfo, ShowCumulate:0, CaptionCol:3}];
//             var info =[{StdCol:"card_type", SumCols:sumColsInfo, ShowCumulate:0, CaptionCol:3}];
            sheet1.ShowSubSum(info) ;
            
            sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=selectYeaDataCardsList", $("#sheetForm").serialize() );
            
            //전년도 합계 정보 조회
            getPreYeaDataInfo_2014();
            getPreYeaDataInfo_2013();
            //본인 정보 조회
            getOwnDataInfo();
            
            break;
        case "Save":
            if(!parent.checkClose())return;

            tab_setAdjInputType(orgAuthPg, sheet1);

            //반기구분/신용카드구분 유효성 체크
            if ( validate_chk() ) { 
	            sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataCardsRst.jsp?cmd=saveYeaDataCards");
            }
            break;
        case "Insert":
            if(!parent.checkClose())return;

            var newRow = sheet1.DataInsert(0) ;
            sheet1.CellComboItem(newRow, "famres", {ComboText:"|"+famList[0], ComboCode:"|"+famList[1]});
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
            
        case "Down2Template":
        	
			//금액자료 직원용(11)/담당자용(12)
        	var monTmp      = "|11";
			var feedbackTmp = "";
            if ( orgAuthPg=="A" ) {
            	monTmp = "|12";
            	feedbackTmp = "|17";
            } else {
            	if ( templeteTitle1.indexOf("담당자확인 : ") > -1 ) {
        			templeteTitle1.substring(0, templeteTitle1.indexOf("담당자확인 : "));
            	}
            }
			var param  = {DownCols:"7|8|9"+monTmp+"|16"+feedbackTmp, SheetDesign:1,Merge:1,DownRows:'0|1',ExcelFontSize:"9"
				,TitleText:templeteTitle1,UserMerge :"0,0,1,5"};
			sheet1.Down2Excel(param); 
			break;
			
        case "LoadExcel":  
        	//업로드 시  merge해제
        	sheet1.SetMergeSheet( msHeaderOnly);
        	
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
			sheet1.LoadExcel(params); 
			break;
        }
    }

    //업로드 완료후 호출
    function sheet1_OnLoadExcel(result) {
    	//업로드 시 소계 해제
    	sheet1.HideSubSum();
    	
        try {
            for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
                sheet1.SetCellValue( i, "work_yy", 		$("#searchWorkYy").val() );
                sheet1.SetCellValue( i, "adjust_type", 	$("#searchAdjustType").val() );
                sheet1.SetCellValue( i, "sabun", 		$("#searchSabun").val() );
                
                if ( orgAuthPg=="A" ) { //담당자용
	                sheet1.SetCellValue( i, "adj_input_type", "02" );
                	sheet1.SetCellEditable(i, "feedback_type", 1);
                	
                } else {
                	sheet1.SetCellValue( i, "adj_input_type", "01" );
                	sheet1.SetCellValue( i, "appl_mon", sheet1.GetCellValue(i, "use_mon") );
                	sheet1.SetCellEditable(i, "feedback_type", 0);
                }
            }
            
        } catch(ex) { 
            alert("OnLoadExcel Event Error " + ex); 
        }
    }
    
    //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);

            if (Code == 1) {
                for ( var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++ ) {
                    if ( !tab_setAuthEdtitable(orgAuthPg, sheet1, i) ) continue;

                    if( sheet1.GetCellValue(i, "adj_input_type") == "02" ) {
                        if(orgAuthPg == "A") {
                            sheet1.SetCellEditable(i, "use_mon", 0) ;
                            sheet1.SetCellEditable(i, "half_gubun", 0) ;
                            sheet1.SetCellEditable(i, "card_type", 0) ;
                            sheet1.SetCellEditable(i, "card_enter_nm", 0) ;
                        } else {
                            sheet1.SetCellEditable(i, "use_mon", 0) ;
                            sheet1.SetCellEditable(i, "half_gubun", 0) ;
                            sheet1.SetCellEditable(i, "card_type", 0) ;
                            sheet1.SetCellEditable(i, "card_enter_nm", 0) ;
                        }
                    }

                    if( sheet1.GetCellValue(i, "card_type") == "7") { /* 현금영수증 선택시 국세청 자료여부 선택 불가 */
                        sheet1.SetCellEditable(i, "nts_yn", 0) ;
                    
                    } else if( sheet1.GetCellValue(i, "card_type") == "23") { /* 2013년(본인) 현금영수증 선택시 국세청 자료여부 선택 불가 */
                        sheet1.SetCellEditable(i, "nts_yn", 0) ;
                    }

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
            parent.getYearDefaultInfoObj();
            if(Code == 1) {
                parent.doSearchCommonSheet();
                
                //저장 후 merge
                sheet1.SetMergeSheet(msAll);
                
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    function validate_chk() {
    	
    	try{
	    	for ( var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++ ) {
	    		if ( sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U" ) {
	    			//명의인
	                if ( !famres_chk(i, "Save") ) return false;
	                //반기구분
	                if ( !half_gubun_chk(i, "Save") ) return false;
	                //신용카드구분
	                if ( !card_type_chk(i, "Save") ) return false;
	    		}
	    	}

    	} catch(ex){
            alert("validate_chk Event Error : " + ex);
    		return false;
        }
    	
    	return true;
    }
    
    //값 변경시 발생
    function sheet1_OnChange(Row, Col, Value) {
    	
        try{
            //명의인
            if( sheet1.ColSaveName(Col) == "famres" ) {
            	famres_chk(Row, "OnChange");
            }
            
            //반기구분
            if( sheet1.ColSaveName(Col) == "half_gubun" ) {
            	half_gubun_chk(Row, "OnChange");
            }
            
            //신용카드구분
            if( sheet1.ColSaveName(Col) == "card_type" ) {
            	card_type_chk(Row, "OnChange");
            }

            inputChangeAppl(sheet1,Col,Row);
            
        } catch(ex){
            alert("OnChange Event Error : " + ex);
        }
    }

    function famres_chk(Row, gubun) {
    	
    	// 신용카드구분이 2013 일 경우, 명의인이 본인이 아닌경우
    	var cardType = sheet1.GetCellText(Row, "card_type");
        if( (typeof cardType === "string" && cardType.indexOf("2013") > -1)
            && (sheet1.GetCellValue(Row, "famres") != gOwnFamCd) ) {
            
            alert("2013(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
                    + "\n 1. 명의인 : 본인"
                    + "\n 2. 반기구분 : 2013 전체");
            sheet1.SetCellValue(Row, "card_type", "");
            return false;

        } else if((typeof cardType === "string" && cardType.indexOf("2014") > -1)
            && (sheet1.GetCellValue(Row, "famres") != gOwnFamCd)) {
            // 신용카드구분이 2014 일 경우, 명의인이 본인이 아닌경우
            alert("2014(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
                    + "\n 1. 명의인 : 본인"
                    + "\n 2. 반기구분 : 2014 전체");
            sheet1.SetCellValue(Row, "card_type", "");
            return false;
            
        } else if( (sheet1.GetCellValue(Row, "card_type") == "35" )
            && (sheet1.GetCellValue(Row, "famres") != gOwnFamCd) ) {
            //당해전체30 / 근로기간제외 총사용분35
            alert("근로제공기간 이외 (본인) 신용카드등 사용액의 대상은"
                    + "\n다음과 같습니다."
                    + "\n 1. 명의인 : 본인"
                    + "\n 2. 반기구분 : 당해 전체"
                    + "\n * 종전근무지를 포함하여 2015.1.1 ~ 2015.12.31 기간중 "
                    + "\n   근로하지 아니한 기간에 사용한 본인 신용카드등 사용액");
            sheet1.SetCellValue(Row, "card_type", "");
            return false;
            
        } else if( (sheet1.GetCellValue(Row, "card_type") == "37" )
            && (sheet1.GetCellValue(Row, "famres") != gOwnFamCd) ) {
            //당해하반기20 /근로기간제외 추가공제율사용분37
            alert("근로제공기간 이외 (본인) 추가공제율 사용분의 대상은"
                    + "\n다음과 같습니다."
                    + "\n 1. 명의인 : 본인"
                    + "\n 2. 반기구분 : 당해 상반기, 당해 하반기"
                    + "\n * 종전근무지를 포함하여 2015.1.1 ~ 2015.12.31 기간중 "
                    + "\n   근로하지 아니한 기간에 사용한 본인 추가공제율 사용분");
            sheet1.SetCellValue(Row, "card_type", "");
            return false;
        }
    	return true;
    }
    
	function half_gubun_chk(Row, gubun) {
    	var cardType = sheet1.GetCellText(Row, "card_type");
		if( (typeof cardType === "string" && cardType.indexOf("2013") > -1)
                && (sheet1.GetCellValue(Row, "half_gubun") != "2013") ) {
           // 신용카드구분이 2013 일 경우, 반기구분이 2013이 아닐경우
               
            alert("2013(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
                    + "\n 1. 명의인 : 본인"
                    + "\n 2. 반기구분 : 2013 전체");
            sheet1.SetCellValue(Row, "card_type", "");
            return false;
            
        } else if( (nvl(cardType, "") != "")
                && (typeof cardType === "string" && cardType.indexOf("2013") == -1)
                && (sheet1.GetCellValue(Row, "half_gubun") == "2013") ) {
            // 신용카드구분이 2013이 아닐 경우, 반기구분이 2013일 경우
            
                alert("2013(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
                    + "\n 1. 명의인 : 본인"
                    + "\n 2. 반기구분 : 2013 전체");
                sheet1.SetCellValue(Row, "card_type", "") ;
                return false;
                
        } else if( (typeof cardType === "string" && cardType.indexOf("2014") > -1)
                && (sheet1.GetCellValue(Row, "half_gubun") != "2014") ) {
            // 신용카드구분이 2014 일 경우, 반기구분이 2014이 아닐경우
                
             alert("2014(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
                     + "\n 1. 명의인 : 본인"
                     + "\n 2. 반기구분 : 2014 전체");
             sheet1.SetCellValue(Row, "card_type", "");
             return false;
             
         } else if( (nvl(cardType, "") != "")
                 && (typeof cardType === "string" && cardType.indexOf("2014") == -1)
                 && (sheet1.GetCellValue(Row, "half_gubun") == "2014") ) {
             // 신용카드구분이 2014이 아닐 경우, 반기구분이 2014일 경우
             
                 alert("2014(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
                     + "\n 1. 명의인 : 본인"
                     + "\n 2. 반기구분 : 2014 전체");
                 sheet1.SetCellValue(Row, "card_type", "") ;
                 return false;        
                
        } else if( (cardType == "35" )
                && (sheet1.GetCellValue(Row, "half_gubun") != "30") ) {
            // 신용카드구분이  근로기간제외 총사용분이 아닐 경우, 반기구분이 당해 전체일 경우
                    
                alert("근로제공기간 이외 (본인) 신용카드등 사용액의 대상은"
                    + "\n다음과 같습니다."
                    + "\n 1. 명의인 : 본인"
                    + "\n 2. 반기구분 : 당해 전체"
                    + "\n * 종전근무지를 포함하여 2015.1.1 ~ 2015.12.31 기간중 "
                    + "\n   근로하지 아니한 기간에 사용한 본인 신용카드등 사용액");
                sheet1.SetCellValue(Row, "card_type", "");
                return false; 
                
        } else if( (nvl(cardType, "") != "")
                && (sheet1.GetCellValue(Row, "card_type") != "35" )
                && (sheet1.GetCellValue(Row, "half_gubun") == "30") ) {
            // 신용카드구분이  근로기간제외 총사용분이 아닐 경우, 반기구분이 당해 전체일 경우
            
                alert("근로제공기간 이외 (본인) 신용카드등 사용액의 대상은"
                    + "\n다음과 같습니다."
                    + "\n 1. 명의인 : 본인"
                    + "\n 2. 반기구분 : 당해 전체"
                    + "\n * 종전근무지를 포함하여 2015.1.1 ~ 2015.12.31 기간중 "
                    + "\n   근로하지 아니한 기간에 사용한 본인 신용카드등 사용액");
                sheet1.SetCellValue(Row, "card_type", "") ;
                return false;
                
                
        } else if( (sheet1.GetCellValue(Row, "card_type") == "37" )
                && !(sheet1.GetCellValue(Row, "half_gubun") == "" ||
                		sheet1.GetCellValue(Row, "half_gubun") == "10" || 
                		    sheet1.GetCellValue(Row, "half_gubun") == "20") ) {
            // 신용카드구분이  근로기간제외 추가공제율사용분이 아닐 경우, 반기구분이 당해하반기일 경우
            //당해하반기20 /근로기간제외 추가공제율사용분37
                alert("근로제공기간 이외 (본인) 추가공제율 사용분의 대상은"
                    + "\n다음과 같습니다."
                    + "\n 1. 명의인 : 본인"
                    + "\n 2. 반기구분 : 당해 상반기, 당해 하반기"
                    + "\n * 종전근무지를 포함하여 2015.1.1 ~ 2015.12.31 기간중 "
                    + "\n   근로하지 아니한 기간에 사용한 본인 추가공제율 사용분");
                sheet1.SetCellValue(Row, "card_type", "") ;
                return false;     
                    
        }
		return true;
    }
    
	function card_type_chk(Row, gubun) {
		
		if( sheet1.GetCellValue(Row, "card_type") == "7") { /* 현금영수증 선택시 국세청 자료여부 선택 불가(자료여부 : Y) */
            sheet1.SetCellValue(Row, "nts_yn", "Y") ;
            sheet1.SetCellEditable(Row, "nts_yn", 0) ;
        
        } else if( sheet1.GetCellValue(Row, "card_type") == "23") { /* 2013년(본인) 현금영수증 선택시 국세청 자료여부 선택 불가 */
            sheet1.SetCellValue(Row, "nts_yn", "Y") ;
            sheet1.SetCellEditable(Row, "nts_yn", 0) ;
            
        } else if( sheet1.GetCellValue(Row, "card_type") == "43") { /* 2014년(본인) 현금영수증 선택시 국세청 자료여부 선택 불가 */
            sheet1.SetCellValue(Row, "nts_yn", "Y") ;
            sheet1.SetCellEditable(Row, "nts_yn", 0) ;
            
        } else {
            sheet1.SetCellEditable(Row, "nts_yn", 1) ;
        }
        
		var cardType = sheet1.GetCellText(Row, "card_type");
        if(typeof cardType === "string" && cardType.indexOf("2013") > -1) {
        // 신용카드구분이 2013 일 경우(명의인:본인, 반기구분:2013 전체)
        	
       		if ( sheet1.GetCellValue(Row, "famres") != gOwnFamCd 
       			|| sheet1.GetCellValue(Row, "half_gubun") != "2013") {
       			
	            alert("2013(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
	                    + "\n 1. 명의인 : 본인"
	                    + "\n 2. 반기구분 : 2013 전체");

        		if ( gubun == "OnChange" ) {
	            	sheet1.SetCellValue(Row, "famres", gOwnFamCd) ;
	            	sheet1.SetCellValue(Row, "half_gubun", "2013") ;
        		}
	            return false;
        	}
        	return true;
        
        } else if(typeof cardType === "string" && cardType.indexOf("2014") > -1) {
        	// 신용카드구분이 2014 일 경우(명의인:본인, 반기구분:2014 전체)	
        	
           	if ( sheet1.GetCellValue(Row, "famres") != gOwnFamCd 
           		|| sheet1.GetCellValue(Row, "half_gubun") != "2014") {
           		
           		alert("2014(본인) 신용카드구분의 대상은 다음과 같습니다.\n카드 탭의 입력 내역을 확인하여 주십시오."
   	                    + "\n 1. 명의인 : 본인"
   	                    + "\n 2. 반기구분 : 2014 전체");
   	            
           		if ( gubun == "OnChange" ) {
	   	            sheet1.SetCellValue(Row, "famres", gOwnFamCd) ;
	   	            sheet1.SetCellValue(Row, "half_gubun", "2014") ;
           		}
   	            return false;
           	}
           	return true;
            
        } else if ( sheet1.GetCellValue(Row, "card_type") == "35" ) {
            // 신용카드구분이 근로기간제외 총사용분일 경우(명의인:본인, 반기구분:당해 전체)
            
            if ( sheet1.GetCellValue(Row, "famres") != gOwnFamCd 
            	|| sheet1.GetCellValue(Row, "half_gubun") != "30") {
            	
            	alert("근로제공기간 이외 (본인) 신용카드등 사용액의 대상은"
                        + "\n다음과 같습니다."
                        + "\n 1. 명의인 : 본인"
                        + "\n 2. 반기구분 : 당해 전체"
                        + "\n * 종전근무지를 포함하여 2015.1.1 ~ 2015.12.31 기간중 "
                        + "\n   근로하지 아니한 기간에 사용한 본인 신용카드등 사용액");
                
            	if ( gubun == "OnChange" ) {
	                sheet1.SetCellValue(Row, "famres", gOwnFamCd) ;
	                sheet1.SetCellValue(Row, "half_gubun", "30") ;
            	}
                return false;
            }
            return true;
            
        } else if ( sheet1.GetCellValue(Row, "card_type") == "37" ) {
            // 신용카드구분이 근로기간제외 추가공제율사용분일 경우(명의인:본인, 반기구분:당해하반기)
            //당해하반기20 /근로기간제외 추가공제율사용분37
           	if ( sheet1.GetCellValue(Row, "famres") != gOwnFamCd 
           			|| !(sheet1.GetCellValue(Row, "half_gubun")=="" || 
           					sheet1.GetCellValue(Row, "half_gubun") == "10"||
           					     sheet1.GetCellValue(Row, "half_gubun") == "20")) {
           		
            	alert("근로제공기간 이외 (본인) 추가공제율 사용분의 대상은"
                        + "\n다음과 같습니다."
                        + "\n 1. 명의인 : 본인"
                        + "\n 2. 반기구분 : 당해 상반기, 당해 하반기"
                        + "\n * 종전근무지를 포함하여 2015.1.1 ~ 2015.12.31 기간중 "
                        + "\n   근로하지 아니한 기간에 사용한 본인 추가공제율 사용분");
                
            	if ( gubun == "OnChange" ) {
	                sheet1.SetCellValue(Row, "famres", gOwnFamCd) ;
	                sheet1.SetCellValue(Row, "half_gubun", "") ; 
            	}
               return false;
            }
            return true;
            
        } else {
        	var halfGubun = sheet1.GetCellText(Row, "half_gubun");
            if ( (nvl(cardType, "") != "")
              && (typeof halfGubun === "string" && halfGubun.indexOf("2013") > -1 ) ) {
                
                sheet1.SetCellValue(Row, "half_gubun", "") ;
                return false;
                
            } else if ( (nvl(sheet1.GetCellText(Row, "card_type"), "") != "")
              && (typeof halfGubun === "string" && halfGubun.indexOf("2014") > -1 ) ) {
                
                sheet1.SetCellValue(Row, "half_gubun", "") ;
                return false;
                
            } else if ( (nvl(sheet1.GetCellValue(Row, "card_type"), "") != "")
              && (halfGubun == "30") ) {
                
                sheet1.SetCellValue(Row, "half_gubun", "") ;
                return false;
                
            }
        }
        return true;
	}
	
    function sheet1_OnClick(Row, Col, Value) {
        try{
            if(sheet1.ColSaveName(Col) == "sDelete" ) tab_clickDelete(sheet1, Row);
        }catch(ex){
            alert("OnClick Event Error : " + ex);
        }
    }
    
    //기본데이터 조회
    function initDefaultData() {
        //도움말 조회
        var param1 = "searchWorkYy="+$("#searchWorkYy").val();
        param1 += "&queryId=getYeaDataHelpText";

        var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=A100",false);
        helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");

        //총급여 확인 버튼 유무
        var result2 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
        yeaMonShowYn = nvl(result2[0].code_nm,"");

        //신용,직/선불카드 - 개인별 총급여
        var param2 = "searchWorkYy="+$("#searchWorkYy").val();
        param2 += "&searchAdjustType="+$("#searchAdjustType").val();
        param2 += "&searchSabun="+$("#searchSabun").val();
        param2 += "&queryId=getYeaDataPayTotMon";

        var result3 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=0.25",false);
        paytotMonStr = nvl(result3.Data.paytot_mon,"");
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
            $("#A100_13").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_13"),"input_mon"));
            $("#A100_14").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_14"),"input_mon"));
            $("#A100_15").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_15"),"input_mon"));
            $("#A100_16").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_16"),"input_mon"));
            $("#A100_17").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_17"),"input_mon"));
            $("#A100_22").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_22"),"input_mon"));
        } else {
            $("#A100_13").val("");
            $("#A100_14").val("");
            $("#A100_15").val("");
            $("#A100_16").val("");
            $("#A100_17").val("");
            $("#A100_22").val("");
        }
    }

    //연말정산 안내
    function yeaDataExpPopup(title, helpText, height, width){
        var url     = "<%=jspPath%>/common/yeaDataExpPopup.jsp";
        openYeaDataExpPopup(url, width, height, title, helpText);
    }

    function paytotMonView(){
        if(paytotMonStr != ""){
            $("#span_paytotMonView").html("<B>"+paytotMonStr+"원</B>&nbsp;<a href='javascript:paytotMonViewClose()' ><font color='red'>[닫기]</font></a>") ;
        } else {
            alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
            return;
        }
    }

    function paytotMonViewClose(){
        $("#span_paytotMonView").html("");
    }

    function sheetChangeCheck() {
        var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D");
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
    <input type="hidden" id="searchDpndntYn" name="searchDpndntYn" value="" />
    <input type="hidden" id="searchFamCd_s" name="searchFamCd_s" value=",'6','7','8'" />
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">2015 신용카드<span class="txt"> ※ 총급여 25% 미만의 연간 총액은 공제금액이 발생하지 않습니다.</span>
            <span id="paytotMonViewYn">
                <a href="javascript:paytotMonView();" class="basic authA"><b><font color="red">[총급여 25%확인]</font></b></a>
            </span>
            <span id="span_paytotMonView" ></span>
            <a href="javascript:yeaDataExpPopup('신용카드', helpText, 500)" class="cute_gray authA">신용카드 안내</a>
            </li>
        </ul>
        </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
    <colgroup>
        <col width="17%" />
        <col width="17%" />
        <col width="17%" />
        <col width="17%" />
        <col width="16%" />
        <col width="" />
    </colgroup>
    <tr>
        <th class="center">신용카드</th>
        <th class="center">현금 영수증</th>
        <th class="center">직불카드 등</th>
        <th class="center">전통시장사용분</th>
        <th class="center">대중교통이용분</th>
        <th class="center">사업관련비용</th>
    </tr>
    <tr>
        <td class="right">
            <input id="A100_15" name="A100_15" type="text" class="text w50p right transparent" readonly /> 원
        </td>
        <td class="right">
            <input id="A100_13" name="A100_13" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <td class="right">
            <input id="A100_22" name="A100_22" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <td class="right">
            <input id="A100_14" name="A100_14" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <td class="right">
            <input id="A100_16" name="A100_16" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <td class="right">
            <input id="A100_17" name="A100_17" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
    </tr>
    </table>
    
    <div class="outer">
        <div class="sheet_title">
            <ul>
                <li class="txt">2014 신용카드
                </li>
                <li class="btn right">
                </li>
            </ul>
        </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
    <colgroup>
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />
        <col width="" />
        <!-- col width="" -->
    </colgroup>
    <tr>
        <th class="center">총 사용액</th>
        <th class="center">현금영수증</th>
        <th class="center">직불카드</th>
        <th class="center">전통시장사용분</th>
        <th class="center">대중교통이용분</th>
        <!-- th class="center">체크카드 등 사용액의 50%</th -->
    </tr>
    <tr>
        <td class="right">
            <input id="preTotSum_2014" name="preTotSum_2014" type="text" class="text w50p right transparent" readonly /> 원
        </td>
        <td class="right">
            <input id="billSum_2014" name="billSum_2014" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <td class="right">
            <input id="checkSum_2014" name="checkSum_2014" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <td class="right">
            <input id="marketSum_2014" name="marketSum_2014" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <td class="right">
            <input id="busSum_2014" name="busSum_2014" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <!-- 
        <td class="right">
            <input id="checkBillSum" name="checkBillSum" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
         -->
    </tr>
    </table>
    
    <div class="outer">
        <div class="sheet_title">
            <ul>
                <li class="txt">2013 신용카드
                </li>
                <li class="btn right">
                </li>
            </ul>
        </div>
    </div>
    <table border="0" cellpadding="0" cellspacing="0" class="default outer">
    <colgroup>
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />
        <col width="20%" />
        <col width="" />
        <!-- col width="" -->
    </colgroup>
    <tr>
        <th class="center">총 사용액</th>
        <th class="center">현금영수증</th>
        <th class="center">직불카드</th>
        <th class="center">전통시장사용분</th>
        <th class="center">대중교통이용분</th>
        <!-- th class="center">체크카드 등 사용액의 50%</th -->
    </tr>
    <tr>
        <td class="right">
            <input id="preTotSum_2013" name="preTotSum_2013" type="text" class="text w50p right transparent" readonly /> 원
        </td>
        <td class="right">
            <input id="billSum_2013" name="billSum_2013" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <td class="right">
            <input id="checkSum_2013" name="checkSum_2013" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <td class="right">
            <input id="marketSum_2013" name="marketSum_2013" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <td class="right">
            <input id="busSum_2013" name="busSum_2013" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
        <!-- 
        <td class="right">
            <input id="checkBillSum" name="checkBillSum" type="text" class="text w50p right transparent" readOnly /> 원
        </td>
         -->
    </tr>
    </table>
    
    <div class="outer">
        <div class="sheet_title">
            <ul>
                <li class="txt"> <span class="txt"> ※ [반기구분=당해 전체]는 [신용카드구분=근로제공기간 이외 (본인) 신용카드등 사용액]의 경우에만 선택가능합니다.</span></li>
                <li class="btn">
                <a href="javascript:doAction1('Search');" 		class="basic authR">조회</a>
                <span id="copyBtn">
	                <a href="javascript:doAction1('Down2Template')"	class="basic authA">양식 다운로드</a>
	              	<a href="javascript:doAction1('LoadExcel')"   	class="basic authA">업로드</a>
	                <a href="javascript:doAction1('Copy');" 		class="basic authA">복사</a>
                </span>
                <a href="javascript:doAction1('Insert');" 		class="basic authA">입력</a>
                <a href="javascript:doAction1('Save');" 		class="basic authA">저장</a>
                <a href="javascript:doAction1('Down2Excel');" 	class="basic authR">다운로드</a>
            </li>
            </ul>
        </div>
    </div>
    <div style="height:410px">
    <script type="text/javascript">createIBSheet("sheet1", "100%", "410px"); </script>
    </div>

</div>
</body>
</html>