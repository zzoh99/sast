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
    
    $(function() {
        
        var arg = p.window.dialogArguments;

        if( arg != undefined ) {
        	
            $("#searchTaxDocNo").val(arg["tax_doc_no"]);        
            $("#searchBusinessPlaceCd").val(arg["business_place_cd"]);        
            $("#searchLocationCd").val(arg["location_cd"]);
            
        }else{

            var searchTaxDocNo        	= "";
            var searchBusinessPlaceCd   = "";
            var searchLocationCd        = "";
            
            searchTaxDocNo      	= p.popDialogArgument("tax_doc_no");
            searchBusinessPlaceCd	= p.popDialogArgument("business_place_cd");
            searchLocationCd       	= p.popDialogArgument("location_cd");
            
            $("#searchTaxDocNo").val(searchTaxDocNo);           
            $("#searchBusinessPlaceCd").val(searchBusinessPlaceCd);
            $("#searchLocationCd").val(searchLocationCd);
        }
        
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};                                                                                                                                                                                              
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};                                                                                                                                                                          
        initdata1.Cols = [                                                                                                                                                                                                                            
            {Header:"No",                    Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
            {Header:"사번",				Type:"Text",	Hidden:0,  Width:100,  Align:"Center",    	ColMerge:0,   SaveName:"sabun",                 KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"성명",          		Type:"Text",    Hidden:0,  Width:100,  Align:"Center",      ColMerge:0,   SaveName:"name",                 	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"사업장",         	Type:"Text",    Hidden:1,  Width:100,  Align:"Center",      ColMerge:0,   SaveName:"business_place_cd",     KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"location",    		Type:"Text",    Hidden:1,  Width:100,  Align:"Center",      ColMerge:0,   SaveName:"location_cd",         	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"인원구분",    		Type:"Combo",    Hidden:0,  Width:100,  Align:"Center",      ColMerge:0,   SaveName:"emp_type", 	        	KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"과세제외급여",	 	  	Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",       ColMerge:0,   SaveName:"tax_exp_mon",       KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
            {Header:"과세급여",			Type:"AutoSum",     Hidden:0,  Width:100,  Align:"Right",       ColMerge:0,   SaveName:"tax_mon",  	    KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 }                      
            
        ]; IBS_InitSheet(sheet1, initdata1);  sheet1.SetEditable("<%=editable%>"); sheet1.SetCountPosition(4);
        
        sheet1.SetColProperty("emp_type", {ComboText:"|상용직|일용직", ComboCode:"|1|2"});
        
		$("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		
        $(window).smartresize(sheetResize); sheetInit();
        
        
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
        case "Search":      //조회
            sheet1.DoSearch("<%=jspPath%>/earnIncomeTaxMgr/earnIncomeTaxMgrRst.jsp?cmd=getEarnIncomeTaxMgrDtl3EmpPopupList", $("#sheetForm").serialize() );
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
            }
        } catch (ex) { 
            alert("OnSaveEnd Event Error " + ex); 
        }
    }
    
  
</script>

</head>
<body class="bodywrap">
<form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="searchTaxDocNo" name="searchTaxDocNo" value="" />
    <input type="hidden" id="searchBusinessPlaceCd" name="searchBusinessPlaceCd" value="" />
    <input type="hidden" id="searchLocationCd" name="searchLocationCd" value="" />
    <div class="wrapper">
        <div class="popup_title">
        <ul>
            <li id="strTitle">대상자 기준</li>
        </ul>
        </div>
    
        <div class="popup_main">
        <div>
            <table border="0" cellpadding="0" cellspacing="0" class="default outer">
                <tr>
                    <th class="left"> <b><font color='red'>자료생성을 눌렀을 때 생성되는 대상자입니다. 인원 및 금액을 별도 수정하셨다면 다를 수 있습니다.</font></b></th>
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
                                        <span>인원구분</span>
                                    	<select id="searchEmpType" name="searchEmpType" onChange="javascript:doAction1('Search')">
											<option value="">전체</option>
											<option value="1">상용직</option>
											<option value="2">일용직</option>
										</select>
                                        <span>사번/성명</span>
                                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text w90" onKeyUp="check_Enter();" />
                                        <a href="javascript:doAction1('Search')"    class="basic authR">조회</a>
                                        <a href="javascript:doAction1('Down2Excel')"    class="basic authR">다운로드</a>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        <script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
                    </td>
                </tr>
            </table>
            <div class="popup_button outer">
                <ul>
                    <li>
                        <a href="javascript:p.self.close();" class="gray large">닫기</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</form>
</body>
</html>



