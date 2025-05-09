<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근로소득 생성</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
 
<script type="text/javascript">
    var p    = eval("<%=popUpStatus%>");
    var arg = p.window.dialogArguments;
    var ymFlag = "";
    var ymMsg  = "";
    $(function(){
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
 
        $("#searchPaySym").datepicker2({ymonly : true});
        $("#searchPayEym").datepicker2({ymonly : true});

        $("#searchPaymentSymd").datepicker2({ymonly : true});
        $("#searchPaymentEymd").datepicker2({ymonly : true});

        $("#searchYMD").datepicker2();
        $("#searchYMD").mask("1111-11-11") ;
        $("#searchYMD").val("<%=yjungsan.util.DateUtil.getDateTime("yyyy-MM-dd")%>");

        $(".close").click(function()  { p.self.close(); });

        var workYy = "";
        var workMm = "";
        var halfType   = "";
        var sendType   = "";
        var incomeType = "";
        var calcType   = "";
        var delYn      = "";
        var businessPlace = "";

        if( arg != undefined ) {
            workYy        = arg["workYy"];
            workYy        = arg["workMm"];
            halfType      = arg["halfType"];
            sendType      = arg["sendType"];
            incomeType    = arg["incomeType"];
            calcType      = arg["calcType"];
            delYn         = arg["delYn"];
            businessPlace = arg["businessPlace"];

            $("#workMm").val(workMm);
            $("#halfType").val(halfType);
            $("#sendType").val(sendType);
            $("#incomeType").val(incomeType);
            $("#calcType").val(calcType);
            $("#delYn").val(delYn);
            $("#businessPlace").val(businessPlace);
        }else{
            if ( p.popDialogArgument("workYy")     !=null ){ workYy      = p.popDialogArgument("workYy"); }
            if ( p.popDialogArgument("workMm")     !=null ){ workMm      = p.popDialogArgument("workMm"); }
            if ( p.popDialogArgument("halfType")   !=null ){ halfType    = p.popDialogArgument("halfType"); }
            if ( p.popDialogArgument("sendType")   !=null ){ sendType    = p.popDialogArgument("sendType"); }
            if ( p.popDialogArgument("incomeType") !=null ){ incomeType  = p.popDialogArgument("incomeType"); }
            if ( p.popDialogArgument("calcType")   !=null ){ calcType    = p.popDialogArgument("calcType"); }
            if ( p.popDialogArgument("delYn")      !=null ){ delYn       = p.popDialogArgument("delYn"); }
            if ( p.popDialogArgument("businessPlace") !=null ){ businessPlace = p.popDialogArgument("businessPlace"); }

            $("#workMm").val(workMm);
            $("#halfType").val(halfType);
            $("#sendType").val(sendType);
            $("#incomeType").val(incomeType);
            $("#calcType").val(calcType);
            $("#delYn").val(delYn);
            $("#businessPlace").val(businessPlace);
        }
        $("#searchPaySym").val(workYy+"-01");
        $("#searchPayEym").val(workYy+"-12");
        $("#searchPaymentSymd").val(workYy+"-01");
        $("#searchPaymentEymd").val(workYy+"-12");
        $("#workYy").val(workYy);

        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"No|No",                 Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:1,   SaveName:"sNo" },
            {Header:"상태|상태",               Type:"<%=sSttTy%>",   Hidden:0,  Width:20, Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},            
            {Header:"생성\n대상|생성\n대상",      Type:"CheckBox", Hidden:0,   Width:30,  Align:"Center", ColMerge:1, SaveName:"chk_yn",           KeyField:0, CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 , TrueValue:"Y" , FalseValue:"N"},
            {Header:"작업일자코드|작업일자코드",    Type:"Text",      Hidden:1,   Width:10,  Align:"Center", ColMerge:1, SaveName:"pay_action_cd",    KeyField:0, CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100},
            {Header:"작업일자명|작업일자명",       Type:"Text",      Hidden:0,   Width:80,  Align:"Left",   ColMerge:1, SaveName:"pay_action_nm",    KeyField:0, CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100},
            {Header:"급여구분|급여구분",          Type:"Combo",     Hidden:0,   Width:50,  Align:"Center", ColMerge:1, SaveName:"pay_cd",           KeyField:0, CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
            {Header:"대상년월|대상년월",          Type:"Date",      Hidden:0,   Width:40,  Align:"Center", ColMerge:1, SaveName:"pay_ym",           KeyField:0, CalcLogic:"",   Format:"Ym",    PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:6},
            {Header:"지급일자|지급일자",          Type:"Date",      Hidden:0,   Width:50,  Align:"Center", ColMerge:1, SaveName:"payment_ymd",      KeyField:0, CalcLogic:"",   Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8},
            {Header:"발령기준일|시작일",          Type:"Date",      Hidden:0,   Width:50,  Align:"Center", ColMerge:1, SaveName:"ord_symd",         KeyField:0, CalcLogic:"",   Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8},
            {Header:"발령기준일|종료일",          Type:"Date",      Hidden:0,   Width:50,  Align:"Center", ColMerge:1, SaveName:"ord_eymd",         KeyField:0, CalcLogic:"",   Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:8},
            {Header:"신고대상년월|신고대상년월",     Type:"Date",      Hidden:0,   Width:70,  Align:"Center", ColMerge:1, SaveName:"ym",               KeyField:0, CalcLogic:"",   Format:"Ym",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:8},
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);        

        var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata2.Cols = [
            {Header:"No",              Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"해제",             Type:"<%=sDelTy%>",   Hidden:0,  Width:40, Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",             Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"항목",             Type:"Combo",        Hidden:0,   Width:80,   Align:"Center", ColMerge:0,   SaveName:"element_cd",       KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"항목명",            Type:"Text",        Hidden:1,   Width:80,   Align:"Center", ColMerge:0,   SaveName:"element_nm",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },            
            {Header:"구분",             Type:"Text",         Hidden:1,   Width:80,   Align:"Center", ColMerge:0,   SaveName:"attribute_8",      KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"구분",             Type:"Text",         Hidden:0,   Width:80,   Align:"Center", ColMerge:0,   SaveName:"attribute_8_nm",   KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"시작일자",          Type:"Text",         Hidden:1,   Width:80,   Align:"Center", ColMerge:0,   SaveName:"sdate",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }            
        ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(true);sheet2.SetVisible(true);sheet2.SetCountPosition(0);     

        //작업일자 sheet
        var payCdList = stfConvCode( ajaxCall("<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=getPayCdList","",false).codeList, "전체");        
        $("#searchPayCd").html(payCdList[2]);
        sheet1.SetColProperty("pay_cd", {ComboText:"|"+payCdList[0], ComboCode:"|"+payCdList[1]} );
        sheet1.SetColProperty("chk_yn", {ComboText:"Y|N", ComboCode:"Y|N"} );

        //인정상여설정 sheet
        var elementCd = stfConvCode( ajaxCall("<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=selectElementCd&searchYMD="+$("#searchYMD").val(),"",false).codeList, "");
        sheet2.SetColProperty("element_cd", {ComboText:"|"+elementCd[0], ComboCode:"|"+elementCd[1]} );

        $(window).smartresize(sheetResize); sheetInit();
        doAction1("Search");
    });

    //Sheet Action First
    function doAction1(sAction) {
        switch (sAction) {
            case "Search":
                if(($("#searchPaySym").val() == "" || $("#searchPaySym").val() == null)
                || ($("#searchPayEym").val() == "" || $("#searchPayEym").val() == null)){
                    alert("귀속년월을 입력해주세요.");
                    return;
                }
                if(($("#searchPaymentSymd").val() == "" || $("#searchPaymentSymd").val() == null)
                || ($("#searchPaymentEymd").val() == "" || $("#searchPaymentEymd").val() == null)){
                    alert("지급년월을 입력해주세요.");
                    return;
                }
                if($("#searchYMD").val() == "" || $("#searchYMD").val() == null){
                    alert("수당 기준일자를 입력해주세요.");
                    return;
                }

                sheet1.DoSearch( "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=selectPayAction", $("#sheet1Form").serialize() ); 
                break;
            case "Save":
                var ym  = "";
                var ym2 = "";
                var ymChk = "";
                var ymChk2 = "";
                var ymChk3 = "";
                var yyyy = $("#workYy").val(); 
                ymFlag = false;
                for(var i=2; i<=sheet1.LastRow(); i++) {

                	if(sheet1.GetCellValue(i,"chk_yn") == "Y"){

	                    ym = sheet1.GetCellValue(i,"ym");
	                    ym2 = ym.substr(0,4);

	                    ymChk  = ym.replace(/\-/g, "");
	                    ymChk2 = ymChk.substr(4,6);
	                    ymChk3 = ymChk2.replace(/^0+/, "");

		                if($("#halfType").val() == "1"){
		                    //상반기
	                        if(yyyy != ym2){
	                        	ymFlag = true;
	                        	ymMsg = "신고대상년월이 귀속년도와 맞지않은 급여가 있습니다. \n신고대상년월을 귀속년도로 해주십시오. ";
	                        	sheet1.SetCellBackColor(i,10,"#FAD5E6") ;
	                        }else{
	                            if(ymChk3 > 6){
	                                ymFlag = true;
	                                ymMsg  = "상반기는 신고대상년월이 "+yyyy+"-01 ~ "+yyyy+"-06 이어야 합니다.\n신고를 원하실 경우 신고대상년월을 변경해 주십시오.";
	                                sheet1.SetCellBackColor(i,10,"#FAD5E6") ;
	                            }	                        	
	                        }
		                }else{
		                	//하반기
                            if(yyyy != ym2){
                            	ymFlag = true;
                            	ymMsg = "신고대상년월이 귀속년도와 맞지않은 급여가 있습니다. \n신고대상년월을 귀속년도로 해주십시오. ";
                                sheet1.SetCellBackColor(i,10,"#FAD5E6") ;
                            }else{
                                if(ymChk3 < 7){
                                    ymFlag = true;
                                    ymMsg  = "하반기는 신고대상년월이 "+yyyy+"-07 ~ "+yyyy+"-12 이어야 합니다.\n신고를 원하실 경우 신고대상년월을 변경해 주십시오.";
                                    sheet1.SetCellBackColor(i,10,"#FAD5E6") ;
                                }
                            }
		                }
	                }
                }
                if(ymFlag){
                	alert(ymMsg);
                	return;
                }
                sheet1.DoSave( "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=saveEtcBouns", $("#sheet1Form").serialize());
                break;
            case "Down2Excel":
                var downcol = makeHiddenSkipCol(sheet1);
                var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
                sheet1.Down2Excel(param,true);
                break;                
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != ""){
                alert(Msg);
            }
            getPayCdChkCnt();
            doAction2("Search");
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
    
    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                 alert(Msg);
                 doAction1("Search");
            }
        } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

    //Sheet Action First
    function doAction2(sAction) {
        switch (sAction) {
            case "Search":
                sheet2.DoSearch( "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=selectEtcBouns", $("#sheet1Form").serialize() );                 
                break;
            case "Insert":
                var newRow = sheet2.DataInsert(0) ;
                sheet2.SetCellValue(newRow, "sStatus", "I");
                sheet2.SetCellValue(newRow, "attribute_8", "C010_15");
                sheet2.SetCellValue(newRow, "attribute_8_nm", "기타소득(인정상여)");
                break;
            case "Save":
                if(!dupChk(sheet2, "element_cd", true, true)) {break;}
                if($("#searchYMD").val() == "" || $("#searchYMD").val() == null){
                    alert("수당 기준일자를 입력해주세요.");
                    return;
                }

                for(var i=1; i<=sheet2.LastRow()+1; i++) {
                     if(sheet2.GetCellValue(i, "sDelete") > 0) {
                           sheet2.SetCellValue( i, "attribute_8" ,"");
                     }
                }
                sheet2.DoSave( "<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=updateEtcBouns", $("#sheet1Form").serialize());
                break;
        }
    }
    // 조회 후 에러 메시지
    function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != ""){
                alert(Msg);
            }
        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
    
    // 저장 후 메시지
    function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            if (Msg != "") {
                 alert(Msg);
            }
            doAction2("Search");
        } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

    // 작업 선택건수 조회
    function getPayCdChkCnt(){
        var payCdChkCnt = ajaxCall("<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=getPayCdChkCnt", $("#sheet1Form").serialize(), false);
        if(payCdChkCnt.Data.chk_cnt > "0"){
            $("#chk_cnt").html("<b>"+ payCdChkCnt.Data.chk_cnt+ "</b>");
        }else{
            $("#chk_cnt").html("<b> 0 </b>");
        }
    }

    // 생성 프로시저 팝업호출
    function callProcPop() {

        if(!confirm("기존내역을 지우고 다시 생성합니다. 진행하시겠습니까?")){
            return;
        }
        var today = new Date();
        var yyyy = today.getFullYear();
        // 정산년도
        var workYy = $("#workYy").val();
        // 정산월
        var workMm = $("#workMm").val();
        // 상/하반기
        var halfType = $("#halfType").val();
        // 지급년도
        var creWorkYy = yyyy;

        $("#creWorkYy").val(creWorkYy);
        $("#workYy").val(workYy);
        $("#workMm").val(workMm);
        $("#delYn").val($("#delYn").val());
        $("#calcType").val($("#calcType").val());
 
        var data = ajaxCall("<%=jspPath%>/simplePymtEarnIncpMgr/simplePymtEarnIncpMgrMonthRst.jsp?cmd=P_CPN_SMPPYM_EMP_2024",$("#sheet1Form").serialize(),false);
               
        if(data.Result.Code == 1) {
            p.self.close();
            var returnValue = new Array()
            returnValue["result"] = "Y";
            
            if(p.popReturnValue) p.popReturnValue(returnValue);
        }else {
            msg = "처리도중 문제발생 : "+data.Result.Message;
        }
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <div class="popup_title">
        <ul>
            <li>근로소득 생성 팝업</li>
        </ul>
    </div>
    <div class="popup_main">
       <form id="sheet1Form" name="sheet1Form" >
           <input id="menuNm" name="menuNm" type="hidden" value ="" />
           <input id="workYy" name="workYy" type="hidden" value ="" />
           <input id="workMm" name="workMm" type="hidden" value ="" />
           <input id="halfType" name="halfType" type="hidden" value ="" />
           <input id="sendType" name="sendType" type="hidden" value ="" />            
           <input id="incomeType" name="incomeType" type="hidden" value="" />
           <input id="creWorkYy" name="creWorkYy" type="hidden" value="" />
           <input id="delYn" name="delYn" type="hidden" value="" />
           <input id="calcType" name="calcType" type="hidden" value="" />
           <input id="businessPlace" name="businessPlace" type="hidden" value="" />
           <div class="sheet_search outer">
               <div>
                   <table>
                   <colgroup>
                    <col width="10%">
                    <col width="10%">
                    <col width="10%">
                    <col width="15%">
                    <col width="25%">
                    <col width="%">
                   </colgroup>
                        <tr>        
                            <td>
                                <span>급여구분</span>
                                <select id="searchPayCd" name ="searchPayCd" onchange="javascript:doAction1('Search');">
                                </select>
                            </td>
                            <td><span>작업대상여부 </span>
                                <select id="searchChkYn" name="searchChkYn" onchange="javascript:doAction1('Search');">
                                    <option value="A">전체</option>
                                    <option value="Y">Y</option>
                                    <option value="N">N</option>
                                </select>
                            </td>                           
                        </tr>
                        <tr>
                            <td><span>귀속년월 </span>
                                <input id="searchPaySym" name="searchPaySym" class="date2" /> ~ <input id="searchPayEym" name="searchPayEym" class="date2" />
                            </td>
                            <td><span>지급년월 </span>
                                <input id="searchPaymentSymd" name="searchPaymentSymd" class="date2" /> ~ <input id="searchPaymentEymd" name="searchPaymentEymd" class="date2" />
                            </td>
                            <td>
                                <a href="javascript:doAction1('Search');" id="btnSearch" class="button">조회</a>
                                <a href="javascript:callProcPop();" id="btnSearch2" class="pink">금액 생성</a>
                            </td>
                        </tr>
                    </table>
               </div>
           </div>
       <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
            <colgroup>
                <col width="70%" />
                <col width="2%" />
                <col width="*%" />
            </colgroup>
            <tr>
                <td>
                     <div class="inner">
                         <div class="sheet_title">
                             <ul>
                                 <li id="txt" class="txt">작업일자</li>
                                 <li class="btn">                    
                                     <span>총&nbsp;<span id="chk_cnt"></span>&nbsp;건 등록되었습니다.</span>&nbsp;                                     
                                     <a href="javascript:doAction1('Save')" class="basic authR">저장</a>
                                     <a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
                                 </li>
                             </ul>
                         </div>
                     </div>
                    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
                </td>
                <td></td>
                <td>
                     <div class="inner">
                         <div class="sheet_title">
                             <ul>
                                 <li id="txt" class="txt">인정상여설정</li>
                                 <li class="btn">
                                     <input id="searchYMD" name="searchYMD" class="date" />                                
                                     <a href="javascript:doAction2('Insert')" class="basic authR">입력</a>
                                     <a href="javascript:doAction2('Save')" class="basic authR">저장</a>
                                 </li>                                 
                             </ul>
                         </div>
                     </div>
                    <script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
                </td>
            </tr>              
        </table>
    </form>
        <div class="popup_button outer">
            <ul>
                <li>
                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
                </li>
            </ul>
        </div>
    </div>
</div>
</body>
</html>