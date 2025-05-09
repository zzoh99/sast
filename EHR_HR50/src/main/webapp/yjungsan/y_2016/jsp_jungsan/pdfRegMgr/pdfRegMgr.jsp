<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산 기타소득</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>



<script type="text/javascript">
    var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";

    $(function() {  
    	$("#searchWorkYy").val("<%=yeaYear%>") ;

    	
        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No",           Type:"<%=sNoTy%>",  Hidden:<%=sNoHdn%>, Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"년도",         Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"work_yy",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4 },
            {Header:"정산구분",     Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"adjust_type",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"사번",         Type:"Text",        Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"sabun",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"성명",         Type:"Text",        Hidden:0,   Width:70,   Align:"Center", ColMerge:1, SaveName:"name",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"소속",         Type:"Text",        Hidden:0,   Width:100,  Align:"Center", ColMerge:1, SaveName:"org_nm",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
            {Header:"순번",         Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"seq",             KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"자료구분",     Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"doc_type",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"업무구분코드", Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"form_cd",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"업무구분",     Type:"Text",        Hidden:0,   Width:80,   Align:"Center", ColMerge:1, SaveName:"form_nm",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"자료순번",     Type:"Text",        Hidden:1,   Width:60,   Align:"Center", ColMerge:1, SaveName:"doc_seq",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"내용",         Type:"Text",        Hidden:0,   Width:400,  Align:"Left",   ColMerge:1, SaveName:"contents",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
            {Header:"처리상태",     Type:"Combo",       Hidden:0,   Width:60,   Align:"Center", ColMerge:1, SaveName:"status_cd",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"반영제외자",   Type:"Combo",       Hidden:0,   Width:90,   Align:"Center", ColMerge:1, SaveName:"except_gubun",    KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"처리결과",     Type:"Text",        Hidden:0,   Width:180,  Align:"Center", ColMerge:1, SaveName:"error_log",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 }
            ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
        var formCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getPdfFormCdList") , "");    
        sheet1.SetColProperty("status_cd",  {ComboText:"반영|미반영|오류|반영제외", ComboCode:"S|N|E|D"} );
        
        var exceptGubun = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00346"), "");
        //반영제외자
        sheet1.SetColProperty("except_gubun",   {ComboText:"|"+exceptGubun[0], ComboCode:"|"+exceptGubun[1]} );
        
        //$("#searchFormCd").html(formCdList[2]);
        
        $(window).smartresize(sheetResize); 
        sheetInit();
        
        //doAction1("Search");

    });
    
    $(function() {  

        $("#srchSbNm, #searchWorkYy").bind("keyup",function(event){
            if( event.keyCode == 13){ 
                doAction1("Search");
            }
        });
        
        
        $("#searchStatusCd, #searchFormCd").change(function(){
            doAction1("Search");
        });
    });
    
    //Sheet1 Action
    function doAction1(sAction, formCd) {
        switch (sAction) {
        case "Search":   
        	var formCd = $("#searchFormCd").val() ;
			$("#searchFormCd0, #searchFormCd1, #searchFormCd2, #searchFormCd3, #searchFormCd4, #searchFormCd5, #searchFormCd6, #searchFormCd7, #searchFormCd8, #searchFormCd9").val("");
			
			if ( formCd != undefined && formCd != "" ) {
				$("#searchFormCd").val(formCd);
			}
			var arrFormCd = $("#searchFormCd").val().split(",");
			for(var i=0; i<arrFormCd.length; i++) {
				$("#searchFormCd"+ i).val(arrFormCd[i]);
			}
			
            var param = "cmd=search&"+$("#srchFrm").serialize();
            sheet1.DoSearch( "<%=jspPath%>/pdfRegMgr/pdfRegMgrRst.jsp", param );
            break;
            
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
            sheet1.Down2Excel(param);
            break;    
        }
    }

  //조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { 
            alertMessage(Code, Msg, StCode, StMsg);
            sheetResize(); 
        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex); 
        }
    }
   
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
   
        <div class="sheet_search outer">
         <form id="srchFrm" name="srchFrm" >
        <input type="hidden" id="srchOrgCd" name="srchOrgCd" value =""/>
       	<input type="hidden" id="searchFormCd0" name="searchFormCd0" value="" />
		<input type="hidden" id="searchFormCd1" name="searchFormCd1" value="" />
		<input type="hidden" id="searchFormCd2" name="searchFormCd2" value="" />
		<input type="hidden" id="searchFormCd3" name="searchFormCd3" value="" />
		<input type="hidden" id="searchFormCd4" name="searchFormCd4" value="" />
		<input type="hidden" id="searchFormCd5" name="searchFormCd5" value="" />
		<input type="hidden" id="searchFormCd6" name="searchFormCd6" value="" />
		<input type="hidden" id="searchFormCd7" name="searchFormCd7" value="" />
		<input type="hidden" id="searchFormCd8" name="searchFormCd8" value="" />
		<input type="hidden" id="searchFormCd9" name="searchFormCd9" value="" />
            <div>
                <table>
                    <tr>
                        <td>
                            <span>년도</span>
                            <input id="searchWorkYy" name ="searchWorkYy" type="text" class="text readonly" maxlength="4" style="width:35px" readonly />
                        </td>
                        <td>
                            <span>업무구분</span>
							<select id="searchFormCd" name="searchFormCd">
								<option value="">전체</option>
								<option value="0000">인적공제</option>
								<option value="A102Y" selected>보험료</option>
								<option value="B101Y">의료비</option>
								<option value="C101Y,C202Y,C301Y">교육비</option>
								<option value="G104Y">신용카드</option>
								<option value="G304Y">직불카드</option>
								<option value="G205M">현금영수증</option>
								<option value="E102Y,E101Y,F101Y,F102Y">연금계좌</option>
								<option value="J101Y,J203Y,J401Y">주택자금</option>
								<option value="D101Y,J301Y">저축</option>
								<option value="N101Y">장기집합투자증권저축</option>
								<option value="K101M">소기업/소상공인 공제부금</option>
								<option value="L102Y">기부금</option>
							</select>                        
						</td>
                        <td>
                            <span>처리상태</span>
                            <select id="searchStatusCd" name="searchStatusCd">
                                <option value="">전체</option>
                                <option value="S">반영</option>
                                <option value="N">미반영</option>
                                <option value="E">오류</option>
                                <option value="D">반영제외</option>
                            </select> 
                        </td>
                        <td>
                            <span>등록상태</span>
                            <select id="searchRegCd" name="searchRegCd">
                                <option value="">전체</option>
                                <option value="Y" selected >등록</option>
                                <option value="N">미등록</option>
                            </select> 
                        </td>
                        <td>
                            <span>사번/성명</span>
                            <input id="srchSbNm" name ="srchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
                        </td>
                        <td> 
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> 
                        </td>
                    </tr>
                </table>
            </div>
            </form>
        </div>
    
    
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li id="txt" class="txt">PDF등록현황</li>
            <li class="btn">
                
                <a href="javascript:doAction1('Down2Excel');"   class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%");  </script>
</div>
</body>
</html>