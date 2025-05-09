<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인적사항관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var zipcodePg = "";

    $(function() {
        
        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
			{Header:"No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"), 	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제",			Type:"<%=sDelTy%>",	Hidden:Number("<%=sDelHdn%>"),	Width:"<%=sDelWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"<%=sSttTy%>",	Hidden:Number("<%=sSttHdn%>"),	Width:"<%=sSttWdt%>",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"사원번호",		Type:"Text",		Hidden:0,	Width:90,	Align:"Center",		ColMerge:0,		SaveName:"sabun",				KeyField:1,		Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:90,	Align:"Center",		ColMerge:0,		SaveName:"name",				KeyField:1,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"주민번호",		Type:"Text",		Hidden:0,	Width:110,	Align:"Center",		ColMerge:0,		SaveName:"res_no",				KeyField:1,		Format:"IdNo",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:15 },
			{Header:"입사일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"emp_ymd",				KeyField:1,		Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"그룹입사일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"gemp_ymd",			KeyField:0,		Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"퇴직일",			Type:"Date",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"ret_ymd",				KeyField:0,		Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조직코드",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"org_cd",				KeyField:1,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조직명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"org_nm",				KeyField:1,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:33 },
			{Header:"사업장코드",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"business_place_cd",	KeyField:0,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사업장명",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"business_place_nm",	KeyField:0,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:33 },
			{Header:"사업자등록번호",	Type:"Text",      	Hidden:0,  	Width:120,	Align:"Center", 	ColMerge:0,   	SaveName:"regino",   			KeyField:1, 	Format:"SaupNo",    PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:17 },
			{Header:"외국인여부",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",		ColMerge:0,		SaveName:"foreign_yn",			KeyField:0,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"국적코드",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",		ColMerge:0,		SaveName:"national_cd",			KeyField:0,		Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"주소구분",		Type:"Combo",      	Hidden:0,  	Width:60,   Align:"Center",  	ColMerge:0,   	SaveName:"add_type",			KeyField:1,   	Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"우편번호",		Type:"PopupEdit",   Hidden:0,  	Width:60,   Align:"Center",  	ColMerge:0,   	SaveName:"zip", 				KeyField:0,   	Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
			{Header:"주소",			Type:"Text",      	Hidden:0,  	Width:100,  Align:"Left",    	ColMerge:0,   	SaveName:"addr1",     			KeyField:0,   	Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:166 },
			{Header:"상세주소",		Type:"Text",      	Hidden:0,  	Width:100,  Align:"Center",  	ColMerge:0,   	SaveName:"addr2",  				KeyField:0,   	Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:166 },
			{Header:"비고",			Type:"Text",      	Hidden:1,  	Width:100,  Align:"Center",  	ColMerge:0,   	SaveName:"note",  				KeyField:0,   	Format:"",			PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:166 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);
      	//국적코드
		var nationalCdLst = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","H20290"), "");
      	//주소구분
		var addTypeLst    = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","H20185"), "");

		sheet1.SetColProperty("national_cd", 	{ComboText:"|"+nationalCdLst[0], ComboCode:"|"+nationalCdLst[1]} );
		sheet1.SetColProperty("add_type", 		{ComboText:"|"+addTypeLst[0], ComboCode:"|"+addTypeLst[1]} );
		sheet1.SetColProperty("foreign_yn", 	{ComboText:"|Y|N", ComboCode:"|Y|N"} );

		/*2015.12.17 MODIFY 우편번호 개편 디비 적용여부에 따라 우편번호 화면 분기됨. (시스템사용기준 : ZIPCODE_REF_YN) */
		var zipcodeRefYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=ZIPCODE_REF_YN", "queryId=getSystemStdData",false).codeList;
		if ( zipcodeRefYn != null && zipcodeRefYn.length>0) {
			if(zipcodeRefYn[0].code_nm == "Y") {
				zipcodePg = "Ref";
			}
		}
		
		$("#srchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search"); 
				$(this).focus(); 
			}
		});
		
        $(window).smartresize(sheetResize);
        sheetInit();
        
        doAction1("Search"); 
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch( "<%=jspPath%>/psnalInfo/psnalBasicInfRst.jsp?cmd=selectPsnalBasicInfLst", $("#sheetForm").serialize() ); 
            break;
        case "Save":
        	// 중복체크
			if (!dupChk(sheet1, "sabun", false, true)) {return;}
            sheet1.DoSave( "<%=jspPath%>/psnalInfo/psnalBasicInfRst.jsp?cmd=savePsnalBasicInf"); 
            break;
        case "Insert":
            var Row = sheet1.DataInsert(0) ;
            sheet1.SetCellValue(Row, "national_cd", "KR");
    		sheet1.SetCellValue(Row, "add_type",    "1" );
    		sheet1.SetCellValue(Row, "foreign_yn",  "N" );
            break;
        case "Copy":
            sheet1.DataCopy();
            break;
        case "Clear":
            sheet1.RemoveAll();
            break;
        case "Down2Excel":
        	var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
            sheet1.Down2Excel(param);
            break;
        case "Down2Template":
            var param  = {DownCols:"sabun|name|res_no|emp_ymd|gemp_ymd|ret_ymd|org_cd|org_nm|business_place_cd|business_place_nm|regino|foreign_yn|national_cd|add_type|zip|addr1|addr2",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
                ,TitleText:"",UserMerge :""		
            };
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
            
            sheetResize(); 
        } catch(ex) {
            alert("OnSearchEnd Event Error : " + ex); 
        }
    }

    //저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { 
            alertMessage(Code, Msg, StCode, StMsg);
            if(Code == 1) {
                doAction1("Search"); 
            }
        } catch(ex) { 
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
                openPopup("<%=jspPath%>/common/zipCode"+zipcodePg+"Popup.jsp", "", "740","620");
    		}
        } catch(ex) {
            alert("OnPopupClick Event Error : " + ex);
        }
    }
    
    //값이 바뀔때 발생
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try{
        	if(sheet1.ColSaveName(Col) == "res_no"){

                if(sheet1.GetCellValue(Row,"res_no")!= ""){
                    //주민번호 유효성체크
                    var rResNo = sheet1.GetCellValue(Row,"res_no");

                    //외국인 주민번호 체크
                    if(sheet1.GetCellValue(Row,"res_no").substring(6,7) == "5"
                            || sheet1.GetCellValue(Row,"res_no").substring(6,7) == "6"
                            || sheet1.GetCellValue(Row,"res_no").substring(6,7) == "7"
                            || sheet1.GetCellValue(Row,"res_no").substring(6,7) == "8"){

                        if(fgn_no_chksum(rResNo) == true){
                        } else{
                            if ( !confirm("등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?") ) sheet1.SetCellValue(Row,"res_no", "") ;
                        }
                    } else {
                        if(checkRegNo(rResNo.substring(0,6), rResNo.substring(6,13)) == true){
                        } else{
                            if ( !confirm("주민등록번호가 유효하지 않습니다. 그래도 입력하시겠습니까?") ) sheet1.SetCellValue(Row,"res_no", "") ;
                        }
                    }
                }
            }
        } catch(ex) {
            alert("OnChange Event Error : " + ex);
        }
    }
    
    function getReturnValue(returnValue) {

        var rv = $.parseJSON('{'+ returnValue+'}');

        if(pGubun == "zipCodePopup"){
			sheet1.SetCellValue(gPRow, "zip", rv[0]);
			sheet1.SetCellValue(gPRow, "addr1", rv[1]);
			sheet1.SetCellValue(gPRow, "addr2", rv[2]);
        }
    }
    
    //업로드 완료후 호출
    function sheet1_OnLoadExcel(result) {
        try {

        } catch(ex) { 
            alert("OnLoadExcel Event Error " + ex); 
        }
    }
    
    
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <div class="sheet_search outer">
        <div>
        <table>
            <tr>
                <td><span>사번/성명</span>
                <input id="srchSbNm" name="srchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
                <td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
            </tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">인적사항관리</li>
            <li class="btn">
                <a href="javascript:doAction1('Down2Template')" class="basic authA">양식다운로드</a>
                <a href="javascript:doAction1('LoadExcel')"     class="basic authA">업로드</a>
                <a href="javascript:doAction1('Insert')"        class="basic authA">입력</a>
                <a href="javascript:doAction1('Copy')"          class="basic authA">복사</a>
                <a href="javascript:doAction1('Save')"          class="basic authA">저장</a>
                <a href="javascript:doAction1('Down2Excel')"    class="basic authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>