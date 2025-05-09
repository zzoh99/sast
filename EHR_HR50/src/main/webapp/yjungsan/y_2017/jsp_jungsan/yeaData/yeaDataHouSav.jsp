<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>주택마련저축</title>
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
    var helpText2;
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
<%--
        if(orgAuthPg == "A") {
            $("#copyBtn").show() ;
        } else {
            $("#copyBtn").hide() ;
        }
--%>
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

		loadSheet2();
		
        //연말정산 주택마련저축 쉬트
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"No|No",                            Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:1, SaveName:"sNo" },
            {Header:"삭제|삭제",                            Type:"<%=sDelTy%>", Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",   Align:"Center", ColMerge:1, SaveName:"sDelete", Sort:0 },
            {Header:"상태|상태",                            Type:"<%=sSttTy%>", Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",   Align:"Center", ColMerge:1, SaveName:"sStatus", Sort:0 },
			{Header:"DOC_SEQ|DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL|DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
            {Header:"년도|년도",                            Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"work_yy",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:4 },
            {Header:"정산구분|정산구분",                        Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"adjust_type",         KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"사번|사번",                            Type:"Text",        Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"sabun",               KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:13 },
            {Header:"저축구분|저축구분",                        Type:"Combo",       Hidden:0,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"saving_deduct_type",  KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"금융기관|금융기관",                        Type:"Combo",       Hidden:0,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"finance_org_cd",      KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"가입일자|가입일자",                        Type:"Date",       Hidden:0,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"reg_dt",      KeyField:1, Format:"Ymd",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
            {Header:"납입횟수|납입횟수",                        Type:"Int",     Hidden:1,   Width:60,   Align:"Left",   ColMerge:1, SaveName:"paying_num_cd",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"계좌번호\n(또는증권번호)|계좌번호\n(또는증권번호)",Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"account_no",          KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:200 },
            {Header:"금액자료|직원용",                     Type:"AutoSum",         Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"input_mon",           KeyField:0, Format:"#,###",  PointCount:0,   UpdateEdit:<%=inputEdit%>,   InsertEdit:<%=inputEdit%>,   EditLen:35 },
            {Header:"금액자료|담당자용",                        Type:"AutoSum",         Hidden:0,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"appl_mon",            KeyField:1, Format:"#,###",  PointCount:0,   UpdateEdit:<%=applEdit%>,    InsertEdit:<%=applEdit%>,    EditLen:35 },
            {Header:"공제금액|공제금액",                        Type:"AutoSum",         Hidden:1,   Width:60,   Align:"Right",  ColMerge:1, SaveName:"ded_mon",             KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
            {Header:"자료입력유형|자료입력유형",                    Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"adj_input_type",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"국세청\n자료여부|국세청\n자료여부",          Type:"CheckBox",    Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"nts_yn",              KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"담당자확인|담당자확인",          Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"feedback_type",       KeyField:0, Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
        var financeOrgCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&orderBy=code_nm","C00319"), "");
        var savingDeductTypeList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getSavingDeductList","searchGubun=4",false).codeList, "");
        var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");
        
        sheet1.SetColProperty("adj_input_type",     {ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
        sheet1.SetColProperty("finance_org_cd",     {ComboText:"|"+financeOrgCdList[0], ComboCode:"|"+financeOrgCdList[1]} );
        sheet1.SetColProperty("saving_deduct_type", {ComboText:"|"+savingDeductTypeList[0], ComboCode:"|"+savingDeductTypeList[1]} );
        sheet1.SetColProperty("feedback_type",  {ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
        
        $(window).smartresize(sheetResize);
        sheetInit();

        parent.doSearchCommonSheet();
        
        doAction2("Search");
        doAction1("Search");
    });

    //연말정산 주택마련저축
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch( "<%=jspPath%>/yeaData/yeaDataHouSavRst.jsp?cmd=selectYeaDataHouSavList", $("#sheetForm").serialize() +"&searchNote1=4" );
            break;
        case "Save":
            if(!parent.checkClose())return;

            if(!dupChk(sheet1, "saving_deduct_type|finance_org_cd|account_no", true, true)) {break;}

            /*
				31	청약저축
				35	청약저축_2015년이전
				34	근로자주택마련저축
	    	*/
	    	for( var Row = 2; Row <= (sheet1.LastRow() - 1); Row++) {
	    		if( sheet1.GetCellValue(Row, "sStatus") == "R" ) continue;
	    		if( sheet1.GetCellValue(Row, "sStatus") == "D" ) continue;
	    		
		    	var saving_deduct_type = sheet1.GetCellValue(Row, "saving_deduct_type");
		    	var reg_dt = sheet1.GetCellValue(Row, "reg_dt");
		    	if(saving_deduct_type == "31" || saving_deduct_type == "35" || saving_deduct_type == "34") {
		    		if ( houseCnt == "1" ) {
		            	if ( houseOwnerYn != "Y" ) {
		            		alert("연말 현재 세대주인 경우만 등록 가능합니다.");
		            		sheet1.SelectCell(Row, "saving_deduct_type");
		            		return;
		            	}
		            	
		            	if ( "20091231" < reg_dt) {
		            		alert("연중 주택소유가 [1주택]인 경우 가입일자가 2009.12.31 이전인 경우만 등록 가능합니다.");
		            		sheet1.SelectCell(Row, "reg_dt");
		            		return;
		            	}		            	
		    		}
		    		else {
		    			if ( houseCnt == "2" ) {
		    				alert("연중 무주택 또는 연중 주택소유가 [1주택]인 경우 가입일자가 2009.12.31 이전인 경우만 등록 가능합니다.");
			           		sheet1.SelectCell(Row, "saving_deduct_type");
			           		return;
		    			}
		    			else {
			    			if ( saving_deduct_type == "34" && "20091231" < reg_dt) {
			            		alert("가입일자가 2009.12.31 이전인 경우만 등록 가능합니다.");
			            		sheet1.SelectCell(Row, "reg_dt");
			            		return;
			            	}
		    			}
		    		}
		    	} else {
		    		if ( houseCnt != "" && houseCnt != "0" ) {
		           		alert("연중 무주택인 경우만 등록 가능합니다.");
		           		sheet1.SelectCell(Row, "saving_deduct_type");
		           		return;
		    		}
		    	}
            }
            
            tab_setAdjInputType(orgAuthPg, sheet1);

            sheet1.DoSave( "<%=jspPath%>/yeaData/yeaDataHouSavRst.jsp?cmd=saveYeaDataHouSav&orgAuthPg="+orgAuthPg);
            break;
        case "Insert":
            if(!parent.checkClose())return;

            /*
			  주택마련저축 등록시 체크사항에
			  무주택 이면서 세대주 이거나
			  1주택인경우는 가입일자 및 금액 체크 하여 등록가능하도록 합니다. (세대주이고... 가입일자 2009.12.31 이전 이고 주택 금액 3억원 이하 인 경우만 가능)
			  2주택은 등록 불가 합니다. 
            */
            if ( houseCnt == "" || houseCnt == "0" || houseCnt == "1") {
            	if ( houseOwnerYn != "Y" ) {
            		alert("연말 현재  세대주인 경우만 등록 가능합니다.");
            		return;
            	}
            } else if ( houseCnt == "2" ) {
            	alert("연중 2주택은 등록 불가 합니다.");
        		return;
            }
            
            var newRow = sheet1.DataInsert(0) ;
            sheet1.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() );
            sheet1.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() );
            sheet1.SetCellValue( newRow, "sabun", $("#searchSabun").val() );

            tab_clickInsert(orgAuthPg, sheet1, newRow);
            break;
        case "Copy":
        	
        	if(!parent.checkClose())return;

            /*
			  주택마련저축 등록시 체크사항에
			  무주택 이면서 세대주 이거나
			  1주택인경우는 가입일자 및 금액 체크 하여 등록가능하도록 합니다. (세대주이고... 가입일자 2009.12.31 이전 이고 주택 금액 3억원 이하 인 경우만 가능)
			  2주택은 등록 불가 합니다. 
            */
            if ( houseCnt == "" || houseCnt == "0" || houseCnt == "1") {
            	if ( houseOwnerYn != "Y" ) {
            		alert("연말 현재 세대주인 경우만 등록 가능합니다.");
            		return;
            	}
            } else if ( houseCnt == "2" ) {
            	alert("연중 2주택은 등록 불가 합니다.");
        		return;
            }
            
            var newRow = sheet1.DataCopy();
            sheet1.SelectCell(newRow, 2);
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
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
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    //클릭시 발생
    function sheet1_OnClick(Row, Col, Value) {
        try{
			if(sheet1.ColSaveName(Col) == "sDelete" ) {
				tab_clickDelete(sheet1, Row);
				
				/* 금액 및 국세청 자료여부 Editable 풀림 방지*/
				if( sheet1.GetCellValue(Row, "adj_input_type") == "07" ) {
					sheet1.SetCellEditable(Row, "input_mon", 0);
					sheet1.SetCellEditable(Row, "appl_mon", 0);
					sheet1.SetCellEditable(Row, "nts_yn", 0);
					sheet1.SetCellEditable(Row, "reg_dt", 0);
				}
			}
        }catch(ex){
            alert("OnClick Event Error : " + ex);
        }
    }
    
    //값 변경시 발생
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try{            
        	
            //저축구분
            if(sheet1.ColSaveName(Col) == "saving_deduct_type"){
                
                if ( nvl(sheet1.GetCellValue(Row,"saving_deduct_type"), "") == "" ) {
                    return;      

                //2015년도 추가 내역 start
                }else if(sheet1.GetCellValue(Row,"saving_deduct_type") == '31' || sheet1.GetCellValue(Row,"saving_deduct_type") == '32' || sheet1.GetCellValue(Row,"saving_deduct_type") == '35' || sheet1.GetCellValue(Row,"saving_deduct_type") == '36'){
                    var chkFlag = sheet1.GetCellValue(Row,"saving_deduct_type"); 
                    
                    if(houseOwnerYn != 'Y') {
                        //세대주여부
                        alert("연말 현재  세대주일 경우에만 등록 가능합니다.");
                        sheet1.SetCellValue(sheet1.GetSelectRow(),"saving_deduct_type", "") ;
                        return;
                        
                    } else {
                    
	                    //7천만원 초과여부
	                    if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 70000000 ) {
	                    	if(chkFlag == '31' || chkFlag == '32'){
	                    		
	                    		if(chkFlag == '31'){
	                    			alert("총급여 7천만원 미만 자에 한해 청약저축 선택이 가능합니다.\n총급여 7천만원 초과 자는 청약저축_2015년이전 항목을 선택해 주십시요.\n(단, 가입일자가 2014년12월31일 이전인 경우)");
		                        }
		                        
		                        if(chkFlag == '32'){
		                        	alert("총급여 7천만원 미만 자에 한해 주택청약종합저축 선택이 가능합니다.\n총급여 7천만원 초과 자는 주택청약종합저축_2015년이전 항목을 선택해 주십시요.\n(단, 가입일자가 2014년12월31일 이전인 경우)");
		                        } 
	                    		
		                        sheet1.SetCellValue(sheet1.GetSelectRow(),"saving_deduct_type", "") ;
		                        return;
	                    	}                    	
	                    }
	                    else {
	                    	if(chkFlag == '35' || chkFlag == '36'){
		                    	if(chkFlag == '35'){
		                            alert("총급여 7천만원 초과 자에 한해 청약저축_2015년이전 항목 선택이 가능합니다.");
		                        }
		                        
		                        if(chkFlag == '36'){
		                            alert("총급여 7천만원 초과 자에 한해 주택청약종합저축_2015년이전 항목 선택이 가능합니다.");
		                        }           
		                        sheet1.SetCellValue(sheet1.GetSelectRow(),"saving_deduct_type", "") ;
		                        return;
	                    	}
	                    }
                    }
                //2015년도 추가 내역 end 
                }else {
                    
                    if(houseOwnerYn != 'Y') {
                        //세대주여부
                        alert("연말 현재 세대주일 경우에만 등록 가능합니다.");
                        sheet1.SetCellValue(sheet1.GetSelectRow(),"saving_deduct_type", "") ;
                        return;
                        
                    } else {
                        if(sheet1.GetCellValue(Row,"saving_deduct_type")=='33'){  // 장기주택 마련저축일 경우
                            alert('총급여액 8,800만원 이하이며, 2009년 12월31일 이전 가입자만 등록 가능하며,\n 2006년1월1일 이후 가입자인 경우 가입당시 기준시가 3억원 이하여야 합니다.');
                            return;
                        }
                        if(sheet1.GetCellValue(Row,"saving_deduct_type")=='34'){  // 근로자주택 마련저축일 경우
                            alert('근로자주택마련저축은 연중 국민주택규모의 1주택이하 주택 소유자가, 2009년 12월31일 이전 가입했을 경우에만 등록 가능합니다.');
                            return;
                        }
                    }
                }
            }

            if(sheet1.ColSaveName(Col) == "saving_deduct_type" || sheet1.ColSaveName(Col) == "reg_dt"){
            	/*
					31	청약저축
					35	청약저축_2015년이전
					34	근로자주택마련저축
            	*/
            	var saving_deduct_type = sheet1.GetCellValue(Row, "saving_deduct_type");
            	var reg_dt = sheet1.GetCellValue(Row, "reg_dt");
            	
            	
            	if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 70000000 ) {
            		
            		if(saving_deduct_type == "35" || saving_deduct_type == "36") {
            			
            			if ( "20141231" < reg_dt) {
            				alert("총급여 7천만원 초과자는 2014년12월31일 이전 가입자만 가능합니다.");
            				sheet1.SetCellValue(sheet1.GetSelectRow(),"reg_dt", "") ;
	                        return;
            			}            			
            		}
            	}
            	else {            		
            	
	            	if(saving_deduct_type == "31" || saving_deduct_type == "35" || saving_deduct_type == "34") {
	            		if ( houseCnt == "1" ) {
	                    	if ( houseOwnerYn != "Y" ) {
	                    		alert("연말 현재 세대주인 경우만 등록 가능합니다.");
	                    		sheet1.SetCellValue(Row, Col, OldValue, 0);
	                    		return;
	                    	}
	                    	
	                    	if ( "20091231" < reg_dt ) {
	                    		alert("주택소유가 [1주택]인 경우 가입일자가 2009.12.31 이전인 경우만 등록 가능합니다.");
	                    		sheet1.SetCellValue(Row, Col, OldValue, 0);
	                    		return;
	                    	}                    	
	            		}
	            		else {
	            			if ( houseCnt == "2" ) {
			    				alert("연중 무주택 또는 연중 주택소유가 [1주택]인 경우 가입일자가 2009.12.31 이전인 경우만 등록 가능합니다.");
			    				sheet1.SetCellValue(Row, Col, OldValue, 0);
				           		return;
			    			}
			    			else {
		            			//34 근로자주택마련저축
		            			if ( saving_deduct_type == "34" && "20091231" < reg_dt ) {
		                    		alert("가입일자가 2009.12.31 이전인 경우만 등록 가능합니다.");
		                    		sheet1.SetCellValue(Row, Col, OldValue, 0);
		                    		return;
		                    	}
			    			}
	            		}
	            	} else {
	            		if ( houseCnt != "" && houseCnt != "0" ) {
	                   		alert("연중 무주택인 경우만 등록 가능합니다.");
	                   		sheet1.SetCellValue(Row, Col, OldValue, 0);
	                   		return;
	            		}
	            	}
	            }
            }
            	
            inputChangeAppl(sheet1,Col,Row);
        } catch(ex){
            alert("OnChange Event Error : " + ex);
        }
    }

    //기본데이터 조회
    function initDefaultData() {
        //도움말 조회
        var param1 = "searchWorkYy="+$("#searchWorkYy").val();
        param1 += "&queryId=getYeaDataHelpText";

        var result1 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=A070",false);
        helpText = nvl(result1.Data.help_text1,"") + nvl(result1.Data.help_text2,"") + nvl(result1.Data.help_text3,"");
		
		var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param1+"&adjProcessCd=A100",false);
		helpText2 = nvl(result2.Data.help_text1,"") + nvl(result2.Data.help_text2,"") + nvl(result2.Data.help_text3,"");

		
        //개인별 총급여
        var param2 = "searchWorkYy="+$("#searchWorkYy").val();
        param2 += "&searchAdjustType="+$("#searchAdjustType").val();
        param2 += "&searchSabun="+$("#searchSabun").val();
        param2 += "&queryId=getYeaDataPayTotMon";

        var result2 = ajaxCall("<%=jspPath%>/common/commonSelect.jsp?cmd=commonSelectMap",param2+"&searchNumber=1",false);
        paytotMonStr = nvl(result2.Data.paytot_mon,"");

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
        
        //총급여 확인 버튼 유무
        var result4 = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_MON_SHOW_YN", "queryId=getSystemStdData",false).codeList;
        yeaMonShowYn = nvl(result4[0].code_nm,"");
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
            $("#A100_31").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_31"),"input_mon"));
            $("#A100_33").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_33"),"input_mon"));
            $("#A100_34").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_34"),"input_mon"));
            $("#A100_40").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_40"),"input_mon"));
            $("#A100_03").val(comSheet.GetCellText(comSheet.FindText("adj_element_cd", "A100_03"),"input_mon"));
            
        } else {
            $("#A100_31").val("");
            $("#A100_33").val("");
            $("#A100_34").val("");
            $("#A100_40").val("");
            $("#A100_03").val("");
        }
    }

    //연말정산 안내
    function yeaDataExpPopup(title, helpText, height, width){
        var url     = "<%=jspPath%>/common/yeaDataExpPopup.jsp";
        openYeaDataExpPopup(url, width, height, title, helpText);
    }

    function sheetChangeCheck() {
        var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D");
        if ( 0 < iTemp ) return true;
        return false;
    }
    
    //[총급여] 보이기
    function paytotMonView(gubun){
        if(paytotMonStr != ""){
            
            if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 80000000 ) {
                if(gubun == '1'){
                    $("#span_paytotMonView1").html("<B>YES</B>&nbsp;<a href='javascript:paytotMonViewClose(1)' ><font color='red'>[닫기]</font></a>") ; 
                }else{
                    $("#span_paytotMonView2").html("<B>YES</B>&nbsp;<a href='javascript:paytotMonViewClose(2)' ><font color='red'>[닫기]</font></a>") ;
                }
                
            } else {
                if(gubun == '1'){
                    $("#span_paytotMonView1").html("<B>NO</B>&nbsp;<a href='javascript:paytotMonViewClose(1)' ><font color='red'>[닫기]</font></a>") ;
                }else{
                    if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 70000000 ) {
                        $("#span_paytotMonView2").html("<B>YES</B>&nbsp;<a href='javascript:paytotMonViewClose(2)' ><font color='red'>[닫기]</font></a>") ;
                    }else{  
                        $("#span_paytotMonView2").html("<B>NO</B>&nbsp;<a href='javascript:paytotMonViewClose(2)' ><font color='red'>[닫기]</font></a>") ;
                    }
                }
            }
        } else {
            alert("총급여 내역이 없습니다. 관리자에게 문의해 주십시요.");
        }
    }
    
    //[총급여] 닫기
    function paytotMonViewClose(gubun){
        if(gubun == '1'){
            $("#span_paytotMonView1").html("");
        }else{
            $("#span_paytotMonView2").html("");
        }
    }
</script>
<script type="text/javascript">
	function loadSheet2() {		
		//연말정산 연금보험료 쉬트.
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",							Type:"<%=sNoTy%>",	Hidden:<%=sNoHdn%>,	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제|삭제",							Type:"<%=sDelTy%>",	Hidden:<%=sDelHdn%>,Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",	 						Type:"<%=sSttTy%>",	Hidden:<%=sSttHdn%>,Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"DOC_SEQ|DOC_SEQ",				Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"DOC_SEQ_DETAIL|DOC_SEQ_DETAIL",Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"doc_seq_detail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"년도|년도",							Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"work_yy",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"정산구분|정산구분",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"adjust_type",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"사번|사번",							Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"sabun",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"저축구분|저축구분",							Type:"Combo",		Hidden:0,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"saving_deduct_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"퇴직연금\n구분|퇴직연금\n구분",	Type:"Combo",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"ret_pen_type",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },			
			{Header:"금융기관코드|금융기관코드",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"finance_org_cd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"가입일자\n(계약시작일자)|가입일자\n(계약시작일자)",                        Type:"Date",       Hidden:0,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"reg_dt",      KeyField:1, Format:"Ymd",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
			{Header:"가입일자\n(계약시작일자)|가입일자\n(계약시작일자)",                        Type:"Text",       Hidden:1,   Width:60,   Align:"Center",   ColMerge:1, SaveName:"reg_dt2",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8 },
	        {Header:"납입횟수코드|납입횟수코드",					Type:"Text",		Hidden:1,	Width:60,	Align:"Left",	ColMerge:1,	SaveName:"paying_num_cd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"계좌번호\n(또는증권번호)|계좌번호\n(또는증권번호)",Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"account_no",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"금액자료|직원용",						Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"input_mon",			KeyField:0,	Format:"#,###",			PointCount:0,	UpdateEdit:<%=inputEdit%>,	InsertEdit:<%=inputEdit%>,	EditLen:35 },
			{Header:"금액자료|담당자용",						Type:"AutoSum",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"appl_mon",			KeyField:1,	Format:"#,###",			PointCount:0,	UpdateEdit:<%=applEdit%>,	InsertEdit:<%=applEdit%>,	EditLen:35 },
			{Header:"공제금액|공제금액",						Type:"Int",			Hidden:1,	Width:60,	Align:"Right",	ColMerge:1,	SaveName:"ded_mon",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"자료입력유형|자료입력유형",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"adj_input_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"국세청\n자료여부|국세청\n자료여부",			Type:"CheckBox",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"nts_yn",				KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"담당자확인|담당자확인",			Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"feedback_type",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
	
		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00325"), "");
		var financeOrgCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00319"), "");
		var feedbackTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00329"), "");
		var retPenTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00318"), "");
		var savingDeductTypeList2 = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getSavingDeductList","searchGubun=3",false).codeList, "");
        
		sheet2.SetColProperty("adj_input_type",		{ComboText:"|"+adjInputTypeList[0], ComboCode:"|"+adjInputTypeList[1]} );
		sheet2.SetColProperty("finance_org_cd",		{ComboText:"|"+financeOrgCdList[0], ComboCode:"|"+financeOrgCdList[1]} );
		sheet2.SetColProperty("feedback_type",		{ComboText:"|"+feedbackTypeList[0], ComboCode:"|"+feedbackTypeList[1]} );
		sheet2.SetColProperty("ret_pen_type",		{ComboText:"|"+retPenTypeList[0], ComboCode:"|"+retPenTypeList[1]} );
		sheet2.SetColProperty("saving_deduct_type", {ComboText:"|"+savingDeductTypeList2[0], ComboCode:"|"+savingDeductTypeList2[1]} );
        
	}
	
	//연말정산 연금보험료
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "<%=jspPath%>/yeaData/yeaDataHouSavRst.jsp?cmd=selectYeaDataHouSavList", $("#sheetForm").serialize() +"&searchNote1=3" );
			break;
		case "Save":
			if(!parent.checkClose())return;
	
			tab_setAdjInputType(orgAuthPg, sheet2);
	
			for(var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++){
				tab_setAuthEdtitable(orgAuthPg, sheet2, i);				
			}
			
			//sheet2.DoSave( "<%=jspPath%>/yeaData/yeaDataHouSavRst.jsp?cmd=saveYeaDataHouSav");
			sheet2.DoSave("<%=jspPath%>/yeaData/yeaDataPenRst.jsp?cmd=saveYeaDataPen&orgAuthPg="+orgAuthPg);
			break;
		case "Insert":
			if(!parent.checkClose())return;

			var newRow = sheet2.DataInsert(0) ;
			sheet2.SetCellValue( newRow, "work_yy", $("#searchWorkYy").val() ) ;
			sheet2.SetCellValue( newRow, "adjust_type", $("#searchAdjustType").val() ) ;
			sheet2.SetCellValue( newRow, "sabun", $("#searchSabun").val() ) ;
			
			tab_clickInsert(orgAuthPg, sheet2, newRow);
			break;

		case "Down2Excel":
			// 2024.10.02
			// reg_dt컬럼에 Date, Text타입이 둘 다 있을경우 엑셀에서 데이터가 이상하게 보이는 문제가 있어
			// 엑셀 다운시에는 Text타입으로만 받기위해 SetColHidden() 세팅
			// 주의: reg_dt2 는 날짜를 계산하는 부분이 있음으로 Format 변경하면 안됨
			sheet2.SetColHidden("reg_dt", 1);
			sheet2.SetColHidden("reg_dt2", 0);

			var info = {Type: "Text", Align: "Center", Edit: 0};
			sheet2.InitCellProperty(i, "reg_dt", info);

			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet2.Down2Excel(param);

			sheet2.SetColHidden("reg_dt", 0);
			sheet2.SetColHidden("reg_dt2", 1);
			break;
		}
	}
	
	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			
			if(Code == 1) {
				for(var i = sheet2.HeaderRows(); i <= sheet2.LastRow(); i++){
					tab_setAuthEdtitable(orgAuthPg, sheet2, i);
				}
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	//저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			parent.getYearDefaultInfoObj();
			if(Code == 1) {
				parent.doSearchCommonSheet();
				doAction2("Search") ;
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	//값이 바뀔대 발생
	function sheet2_OnChange(Row, Col, Value, OldValue) {
		try{
			if(sheet2.ColSaveName(Col) == "input_mon") {
				sheet2.SetCellValue(Row,"appl_mon", sheet2.GetCellValue(Row,Col)) ;
			}
			
			if(sheet2.ColSaveName(Col) == "saving_deduct_type"){
				
				if ( nvl(sheet2.GetCellValue(Row,"saving_deduct_type"), "") == "" ) {
                    return;
                    
                } else if ( sheet2.GetCellValue(Row,"saving_deduct_type")=='50' ) {  
                    // 장기집합투자증권저축일 경우                    
                    if( ( paytotMonStr.replace(/,/gi, "") *1 ) > 80000000 ) {
                        //8천만원 초과여부
                        alert("총급여 8천만원 미만인 자에 한해 장기집합투자증권저축 선택이 가능합니다.");
                        sheet2.SetCellValue(sheet2.GetSelectRow(),"saving_deduct_type", "") ;
                        return;
                    }                    
                }
			}
			
			/*
			개인연금저축 : 가입일자가 2000년 12월 31일 이후이면 경고창 처리
			장기집합투자증권저축 : 가입일자가 2015년 12월 31일 이후이면 경고창 처리
			*/
			if(sheet2.ColSaveName(Col) == "reg_dt") {
				
				if(sheet2.GetCellValue(Row, "saving_deduct_type") == "21"){
					
					if ( Value.length == 8 && "20001231" < Value ) {
						alert("가입일자는 2000년 12월 31일 이전이어야 합니다.");
						sheet2.SetCellValue(Row, "reg_dt", OldValue);
					}
				}
				if(sheet2.GetCellValue(Row, "saving_deduct_type") == "50"){
					if ( Value.length == 8 && "20151231" < Value ) {
	            		alert("가입일자는 2015년 12월 31일 이전이어야 합니다.");
	            		sheet2.SetCellValue(Row, "reg_dt", OldValue);
	            		return;
	            	} 
				}
			}			
			
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	function sheet2_OnClick(Row, Col, Value) {
		try{
			if(sheet2.ColSaveName(Col) == "sDelete" ) {
				tab_clickDelete(sheet2, Row);
				
				/* 금액 및 국세청 자료여부 Editable 풀림 방지*/
				if( sheet2.GetCellValue(Row, "adj_input_type") == "07" ) {
					sheet2.SetCellEditable(Row, "input_mon", 0);
					sheet2.SetCellEditable(Row, "appl_mon", 0);
					sheet2.SetCellEditable(Row, "nts_yn", 0);
					sheet2.SetCellEditable(Row, "reg_dt", 0);
				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
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

	<table class="table outer yeaData1" style="margin-top:10px !important;">
	    <colgroup>
	        <col width="20%" />
	        <col width="20%" />
	        <col width="20%" />
	        <col width="20%" />
	        <col width="" />
	    </colgroup>
	    <tr>
	        <th class="center" colspan="3" >주택마련저축</th>
	        <th class="center" rowspan="2" >장기집합투자증권저축<br>(2015.12.31 이전 가입)</th>
	        <th class="center" rowspan="2" >개인연금저축<br>(2000.12.31 이전 가입)</th>
	    </tr>
	    <tr>
	        <th class="center">청약저축</th>
	        <th class="center">주택청약종합저축</th>
	        <th class="center">근로자주택마련저축</th>        
	    </tr>
	    <tr>
	        <td class="right">
	            <input id="A100_34" name="A100_34" type="text" class="text w50p right transparent"  readonly /> 원
	        </td>
	        <td class="right">
	            <input id="A100_31" name="A100_31" type="text" class="text w50p right transparent" readOnly /> 원
	        </td>
	        <td class="right">
	            <input id="A100_33" name="A100_33" type="text" class="text w50p right transparent" readOnly /> 원
	        </td>
	        <td class="right">
	            <input id="A100_40" name="A100_33" type="text" class="text w50p right transparent" readOnly /> 원
	        </td>
	        <td class="right">
	            <input id="A100_03" name="A100_03" type="text" class="text w50p right transparent" readOnly /> 원
	        </td>       
	    </tr>
	</table>
	        
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">주택마련저축 
                <span id="paytotMonViewYn2">
                    <a href="javascript:paytotMonView('2');" class="basic authA"><b><font color="red">[총급여 7천만원 초과여부]</font></b></a>
                </span>
                <span id="span_paytotMonView2" ></span>
                <a href="javascript:yeaDataExpPopup('주택자금', helpText, 570)" class="cute_gray authA">주택마련저축 안내</a>
               	 <font color="red" size="2" >주택정보 ☞ <span id="houseInfo"></span></font>
            </li>
            <li class="btn">
	            <a href="javascript:doAction1('Search');" class="basic authR">조회</a>
	            <a href="javascript:doAction1('Insert');" class="basic authA">입력</a>
<%if("Y".equals(adminYn)) {%>
	            <span id="copyBtn">
	            <a href="javascript:doAction1('Copy');" class="basic authA">복사</a>
	            </span>
<%} %>
	            <a href="javascript:doAction1('Save');" class="basic authA">저장</a>
	            <a href="javascript:doAction1('Down2Excel');" class="basic authR">다운로드</a>
	        </li>
        </ul>
        </div>
    </div>
    <div style="height:250px">
    <script type="text/javascript">createIBSheet("sheet1", "100%", "250px"); </script>
    </div>
    
    <div class="sheet_title outer">
        <ul>
            <li class="txt">개인연금저축 / 장기집합투자증권저축 
            	<span id="paytotMonViewYn1">
                    <a href="javascript:paytotMonView('1');" class="basic authA"><b><font color="red">[총급여 8천만원 초과여부]</font></b></a>
                </span>
                <span id="span_paytotMonView1" ></span>
                <a href="javascript:yeaDataExpPopup('개인연금/장기집합저축', helpText2, 500)" class="cute_gray authA">개인연금/장기집합저축 안내</a>
            </li>
            <li class="btn">
            <a href="javascript:doAction2('Search');" class="basic authR">조회</a>
            <a href="javascript:doAction2('Insert');" class="basic authA">입력</a>
            <a href="javascript:doAction2('Save');" class="basic authA">저장</a>
            <a href="javascript:doAction2('Down2Excel');" class="basic authR">다운로드</a>
        </li>
        </ul>
    </div>
    <div style="height:200px">
    <script type="text/javascript">createIBSheet("sheet2", "100%", "200px"); </script>
    </div>
    
</div>
</body>
</html>