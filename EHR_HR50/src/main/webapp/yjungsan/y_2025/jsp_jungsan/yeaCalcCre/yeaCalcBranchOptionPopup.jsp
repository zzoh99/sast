<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>대상자기준</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");
    var zipcodePg = "";
    var codeList;

    $(function() {
    	$("#searchYMD").datepicker2();
    	$("#menuNm").val($(document).find("title").text());
        var arg = p.window.dialogArguments;


        if( arg != undefined ) {
            $("#searchWorkYy").val(arg["searchWorkYy"]);
        }else{
            var searchWorkYy        = "";

            searchWorkYy      = p.popDialogArgument("searchWorkYy");

            $("#searchWorkYy").val(searchWorkYy);
        }

        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"No|No",                 Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제|삭제",               Type:"<%=sDelTy%>",   Hidden:<%=sDelHdn%>,            Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete", Sort:0 },
            {Header:"상태|상태",               Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus", Sort:0 },
            {Header:"사업장|사업장",            Type:"Combo",         Hidden:0,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"business_place_cd",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0 ,  InsertEdit:1,   EditLen:4 },
            {Header:"사업장명|사업장명",         Type:"Combo",         Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"business_place_nm",               KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0 ,  InsertEdit:1,   EditLen:4 },
            {Header:"사업장등록번호|사업장등록번호", Type:"Text",          Hidden:0,  Width:90,  Align:"Center",        ColMerge:0,   SaveName:"base_regino",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
            {Header:"단위과세정보|단위과세여부",    Type:"CheckBox",      Hidden:0,  Width:95,  Align:"Center",        ColMerge:0,   SaveName:"tax_grp_yn",                   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"단위과세정보|주사업장등록번호", Type:"Text",          Hidden:0,  Width:105,  Align:"Center",        ColMerge:0,   SaveName:"regino",                      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
            {Header:"단위과세정보|종사업장일련번호", Type:"Text",          Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"sub_regino",                  KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10},
            {Header:"단위과세정보|SDATE",       Type:"Date",          Hidden:1,  Width:80,  Align:"Center",        ColMerge:0,   SaveName:"org_sdate",                    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"단위과세정보|시작일",        Type:"Date",          Hidden:0,  Width:80,  Align:"Center",        ColMerge:0,   SaveName:"sdate",                    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"단위과세정보|종료일",        Type:"Date",          Hidden:0,  Width:80,  Align:"Center",         ColMerge:0,   SaveName:"edate",                       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 }

        ]; IBS_InitSheet(sheet1, initdata1);  sheet1.SetEditable("<%=editable%>"); sheet1.SetCountPosition(4);

        <%
        if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
        %>
        codeList = codeList("<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=selectBranchPlaceCdList", "");
        <%
        }else{
        %>
        codeList = codeList("<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=selectBranchPlaceCdList_SH", "");
        <%
        }
        %>

        var payPeopleStatusList = stfConvCode(codeList , "");
        
        sheet1.SetColProperty("business_place_cd",    {ComboText:"|"+payPeopleStatusList[0], ComboCode:"|"+payPeopleStatusList[1]} );

        $(window).smartresize(sheetResize); sheetInit();

        var data = ajaxCall("<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=selectBranchDt",$("#sheetForm").serialize(),false);

        $("#searchYMD").val(data.dtList[0].ord_eymd.substring(0,4) + "-" + data.dtList[0].ord_eymd.substring(4,6) + "-" + data.dtList[0].ord_eymd.substring(6,8));


        doAction1("Search");
    });

    $(function(){
        $(".close").click(function() {
            p.self.close();
        });
    });

    /*Sheet Action*/
    function doAction1(sAction) {
        switch (sAction) {
        case "Insert":
        	var newRow = sheet1.DataInsert(0);
        	sheet1.SetCellValue(newRow, "business_place_cd", "");
            break;
        case "Copy":
        	var newRow = sheet1.DataCopy();
            sheet1.SelectCell(newRow, 2);

    		sheet1.SetCellEditable(newRow, "regino", 1); 
    		sheet1.SetCellEditable(newRow, "sdate", 1);
            break;
        case "Search":      //조회

            <%
            if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
            %>
            sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=selectBranchOptionList", $("#sheetForm").serialize());
            <%
            }else{
            %>
            sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=selectBranchOptionList_SH", $("#sheetForm").serialize());
            <%
            }
            %>
            break;
        case "Save":        //저장
            /* 20231207 아래에서 한 번에 중복 체크 (기간중첩도 체크)
            if (!dupChk(sheet1, "business_place_cd|sdate", true, true)) {
            	break;
            }*/
            if (!chkTaxGrpSet()) {
            	break;
            }
        	sheet1.DoSave( "<%=jspPath%>/yeaCalcCre/yeaCalcBranchOptionPopupRst.jsp?cmd=saveBranchOption",$("#sheetForm").serialize());
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
                for(var i = 2; i < sheet1.RowCount()+2; i++) {
                	if (sheet1.GetCellValue(i, "sdate") != "") {
                		//20231205 등록된 세팅은 KEY값 수정 불가. 종료일에 만료일을 설정하든가 아예 삭제하든가 해야 함.
                		sheet1.SetCellEditable(i, "regino", 0); 
                		sheet1.SetCellEditable(i, "sdate", 0);
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

            if(Code == 1) {
                doAction1("Search") ;
                //return
                if(p.popReturnValue) p.popReturnValue("");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }

    //값이 바뀔때 발생
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try {
        	if(sheet1.ColSaveName(Col) == "business_place_cd") {
                sheet1.SetCellValue(Row, "business_place_nm", sheet1.GetCellText(Row, Col));
        		sheet1.SetCellValue(Row, "base_regino", ""); //일단 초기화
        		sheet1.SetCellValue(Row, "regino", "");

                for(var i = 0 ; i < codeList.length ; i++) {
                	if(codeList[i].code == sheet1.GetCellValue(Row, Col)){
                		sheet1.SetCellValue(Row, "base_regino", codeList[i].regino);
                		sheet1.SetCellValue(Row, "regino", codeList[i].regino);
                	}
                }
        	}
        } catch (ex) {
            alert("OnChange Event Error " + ex);
        }
    }

    function sheet1_OnValidation(Row, Col, Value) {
        try {
        	if(sheet1.GetCellValue(Row, "sStatus") == "D") {
                return;
            }
        	
            if(sheet1.GetCellValue(Row, "regino") == "") {
                alert((Row-1) + "행의 주사업장등록번호를 확인하십시오.");
                sheet1.ValidateFail(2);
            	sheet1.SetRowBackColor(Row, "#FACFED");
                return;
            }

            if(sheet1.GetCellValue(Row, "regino").length != 10) {
                alert((Row-1) + "행의 주사업장등록번호 길이를 확인하십시오.(10자리)");
                sheet1.ValidateFail(2);
            	sheet1.SetRowBackColor(Row, "#FACFED");
                return;
            }
            
            if(sheet1.GetCellValue(Row, "tax_grp_yn") == "Y") {
            	if(sheet1.GetCellValue(Row, "regino") == "") {
	                alert((Row-1) + "행의 단위과세여부가 체크 상태입니다.\n주사업장일련번호를 입력하십시오.");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }
	            if(sheet1.GetCellValue(Row, "regino").length != 10) {
	                alert((Row-1) + "행의 단위과세여부가 체크 상태입니다.\n주사업장일련번호 길이를 확인하십시오.(10자리)");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }
            	
	            if(sheet1.GetCellValue(Row, "sub_regino") == "") {
	                alert((Row-1) + "행의 단위과세여부가 체크 상태입니다.\n종사업장일련번호를 입력하십시오.");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }
	            if(sheet1.GetCellValue(Row, "sub_regino").length != 4) {
	                alert((Row-1) + "행의 단위과세여부가 체크 상태입니다.\n종사업장일련번호 길이를 확인하십시오.(4자리)");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }	            
	            if(sheet1.GetCellValue(Row, "sdate") == "") {
	                alert((Row-1) + "행의 단위과세여부가 체크 상태입니다.\n시작일자를 입력하십시오.");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }
	            if(sheet1.GetCellValue(Row, "edate") == "") {
	                alert((Row-1) + "행의 단위과세여부가 체크 상태입니다.\n종료일자를 입력하십시오.");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }
	            if(sheet1.GetCellValue(Row, "sdate") > sheet1.GetCellValue(Row, "edate")) {
	                alert((Row-1) + "행의 시작일자가 종료일자보다 큽니다.\n종료일자를 확인하십시오.");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }
            } else {
            	if(sheet1.GetCellValue(Row, "base_regino") != sheet1.GetCellValue(Row, "regino")) {
	                alert((Row-1) + "행의 사업장등록번호와 주사업장등록번호가 상이합니다.\n단위과세여부에 체크하십시오.");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }
            	if(sheet1.GetCellValue(Row, "sub_regino") != "") {
	                alert((Row-1) + "행의 종사업장일련번호가 기재되어 있습니다.\n단위과세여부에 체크하십시오.");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }
            	if(sheet1.GetCellValue(Row, "sdate") != "") {
            		alert((Row-1) + "행의 시작일자가 있습니다.\n단위과세여부에 체크하십시오.");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }
	            if(sheet1.GetCellValue(Row, "edate") != "") {
	            	alert((Row-1) + "행의 종료일자가 있습니다.\n단위과세여부에 체크하십시오.");
	                sheet1.ValidateFail(2);
	            	sheet1.SetRowBackColor(Row, "#FACFED");
	                return;
	            }
            }            
        } catch (ex) {
            alert("OnValidation Event Error " + ex);
        }
    }
    
	// 20231207. 저장하기에 앞서 세팅된 데이터의 유효성 체크(키중복, 기간중첩 등)
    function chkTaxGrpSet() {    	
    	var dupRow     = "";
        var crrStatus  = ""; var nxtStatus  = "";
        var crrBpCd    = ""; var nxtBpCd    = "";
        var crrRegino  = ""; var nxtRegino  = "";
        var crrReginoS = ""; var nxtReginoS = "";
        var crrSdate   = ""; var nxtSdate   = "";
        var crrEdate   = ""; var nxtEdate   = "";
        
  		outer : 
  		for(var i = 2 ; i < sheet1.RowCount()+2 ; i++) {
  			crrStatus  = sheet1.GetCellValue(i, "sStatus") ;	
  			crrBpCd    = sheet1.GetCellValue(i, "business_place_cd") ;      			
            crrRegino  = sheet1.GetCellValue(i, "regino") ;
            crrReginoS = sheet1.GetCellValue(i, "sub_regino") ;
            crrSdate   = sheet1.GetCellValue(i, "sdate") ;
            crrEdate   = sheet1.GetCellValue(i, "edate") ;
           	
            if ( crrStatus != "D" && crrSdate != "" ) { // 삭제 행은 skip  // 단위과세 설정이 있는 행만 비교 (PK 필수)	            			                	
            	inner : 
            	for(var j = i+1 ; j < sheet1.RowCount()+2 ; j++) {
            		nxtStatus  = sheet1.GetCellValue(j, "sStatus") ;	
            		nxtBpCd    = sheet1.GetCellValue(j, "business_place_cd") ;
                    nxtRegino  = sheet1.GetCellValue(j, "regino") ;
                    nxtReginoS = sheet1.GetCellValue(j, "sub_regino") ;
                    nxtSdate   = sheet1.GetCellValue(j, "sdate") ;
                    nxtEdate   = sheet1.GetCellValue(j, "edate") ;

                    // 서로 다른 행만 비교 // 삭제 행은 skip  // 단위과세 설정이 있는 행만 비교 (PK 필수)
                    if ( i != j && nxtStatus != "D" && nxtSdate != "") {                        	
                    	// key 중복 체크
                    	if ( crrBpCd == nxtBpCd ) { //급여사업장 business_place_cd
                        	if (crrSdate == nxtSdate) { //시작일 중복 체크
                        		dupRow = i;
                        		alert("사업장, 시작일자가 중복된 자료가 있습니다. (" + (i-1) + " 행)");
                				break outer ;
		                	} else if (crrSdate <= nxtEdate && crrEdate >= nxtSdate ) { //기간 중첩 체크
		                		dupRow = i;
		                		alert("사업장이 동일하면서\n기간이 중첩된 자료가 있습니다. (" + (i-1) + " 행)");
		                		break outer ;
		                	}
                    	} else if ( crrRegino == nxtRegino && crrReginoS == nxtReginoS ) { //주사업장,종사업장
	                        	if (crrSdate == nxtSdate) { //시작일 중복 체크
	                        		dupRow = i;
	                        		alert("주사업장, 종사업장, 시작일자가 중복된 자료가 있습니다. (" + (i-1) + " 행)");
	                				break outer ;
			                	} else if (crrSdate <= nxtEdate && crrEdate >= nxtSdate ) { //기간 중첩 체크
			                		dupRow = i;
			                		alert("주사업장, 종사업장이 동일하면서\n기간이 중첩된 자료가 있습니다. (" + (i-1) + " 행)");
			                		break outer ;
			                	}
                       	}
            		}
              	}
           	}
        }
        if (dupRow != "") {
        	sheet1.SetRowBackColor(dupRow, "#FACFED");
        	return false;
        }
    	
        return true ;
    }
    
</script>

</head>
<body class="bodywrap">
<form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
    <input type="hidden" id="searchAdjustType" name="searchAdjustType" value="1" />
    <input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="">
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <div class="wrapper">
        <div class="popup_title">
        <ul>
            <li id="strTitle">사업자 단위과세자 관리</li>
            <!-- <li class="close"></li>  -->
        </ul>
        </div>

        <div class="popup_main">
            <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
                <tr>
                    <td class="top">
                        <div class="outer">
                            <div class="sheet_title">
                                <ul>
                                    <li id="strSheetTitle" class="txt">
                                        <span>* C레코드(C17,C18) 세팅을 위한 사업자 단위과세 정보 등록</span>
                                    </li>
                                    <li class="btn">
                                        <b>기준일자 </b>
                                        <input id="searchYMD" name ="searchYMD" type="text" class="date2" />
                                        <a href="javascript:doAction1('Search')"        class="basic authR">조회</a>
                                        <a href="javascript:doAction1('Insert')"        class="basic authA">입력</a>
                                        <a href="javascript:doAction1('Copy')"          class="basic authA">복사</a>
                                        <a href="javascript:doAction1('Save')"          class="basic btn-save authA">저장</a>
                                        <a href="javascript:doAction1('Down2Excel')"    class="basic btn-download authR">다운로드</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
                        
                        
                        <div class="outer">
                            <div class="sheet_title">
                                <ul>
                                    <li id="strSheetTitle" class="txt">
                                        <span>* 사업장별 주사업장등록번호 변경은 [사업장관리]를 이용하십시오.</span>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        
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



