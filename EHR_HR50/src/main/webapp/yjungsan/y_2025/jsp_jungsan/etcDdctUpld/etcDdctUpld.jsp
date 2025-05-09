<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>기타공제내역일괄등록</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
    var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
    var adjElementCdLst = null;
    var adjElementCdLst2 = null;
    var adjustTypeList = null;

    $(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
        $("#searchWorkYy").val("<%=yeaYear%>") ;

        var initdata = {};
        initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata.Cols = [
            {Header:"No",                     Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"삭제",                   Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"상태",                   Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
          <%// 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. => initdata 세팅으로 조정
            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.%>
            {Header:"대상년도",               Type:"Text",      Hidden:1,  Width:60,  Align:"Center",  ColMerge:1,   SaveName:"work_yy",          KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4, DefaultValue:"<%=yeaYear%>" },
            {Header:"정산구분",               Type:"Combo",     Hidden:0,  Width:70,  Align:"Center",  ColMerge:1,   SaveName:"adjust_type",      KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"사번",                   Type:"Text",      Hidden:0,  Width:30,  Align:"Center",  ColMerge:1,   SaveName:"sabun",            KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"성명",                   Type:"Popup",     Hidden:0,  Width:30,  Align:"Center",  ColMerge:1,   SaveName:"name",             KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"소속",                   Type:"Text",      Hidden:0,  Width:50,  Align:"Left",  ColMerge:1,   SaveName:"org_nm",           KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"소득구분명",             Type:"Combo",     Hidden:0,  Width:250, Align:"Left",    ColMerge:1,   SaveName:"adj_element_cd",   KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35 },
            {Header:"금액",                   Type:"Int",       Hidden:0,  Width:100, Align:"Right",   ColMerge:1,   SaveName:"input_mon",        KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
        
        var params = "searchWorkYy="+$("#searchWorkYy").val();

        adjElementCdLst = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchWorkYy="+$("#searchWorkYy").val(),"getEtcDdctUpldAdjElementCdLst") , "전체");
        $("#searchAdjElementCd").html(adjElementCdLst[2]);

        adjElementCdLst2 = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchWorkYy="+$("#searchWorkYy").val(),"getEtcDdctUpldAdjElementCdLst") , "전체");
        sheet1.SetColProperty("adj_element_cd", {ComboText:"|"+adjElementCdLst2[0], ComboCode:"|"+adjElementCdLst2[1]});

        //정산구분
        adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
        $("#searchAdjustType").html(adjustTypeList[2]).val("1");
        sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});

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

        getCprBtnChk();	
        
        //doAction1("Search");
    });

    $(function() {
        $("#searchSbNm").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction1("Search");
                $(this).focus();
            }
        });
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":
            sheet1.DoSearch( "<%=jspPath%>/etcDdctUpld/etcDdctUpldRst.jsp?cmd=selectEtcDdctUpldList", $("#sheetForm").serialize() );
            break;
        case "Save":
            if(!dupChk(sheet1, "sabun|adj_element_cd", false, true)) {break;}
            if (isExElementAdjElementCd()) {
                break;
            }
            sheet1.DoSave( "<%=jspPath%>/etcDdctUpld/etcDdctUpldRst.jsp?cmd=saveEtcDdctUpld",$("#sheetForm").serialize());
            break;
        case "Insert":
            if (isExElementAdjElementCd()) {
                break;
            }
        	if(chkRqr()){
        		 break;
        	}
        	var Row = sheet1.DataInsert(0) ;

            sheet1.SetCellValue( Row, "work_yy", $("#searchWorkYy").val());
            sheet1.SetCellValue( Row, "adjust_type", $("#searchAdjustType").val());
            sheet1.SetCellValue( Row, "adj_element_cd", $("#searchAdjElementCd").val());

            break;
        case "Copy":
            sheet1.DataCopy();
            break;
        case "Clear":
            sheet1.RemoveAll();
            break;
        case "Down2Excel":
            var downcol = makeHiddenSkipCol(sheet1);
            var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};
            sheet1.Down2Excel(param);
            break;
        case "Down2Template":
        	if(chkRqr()){
                break;
            }
        	
        	var param  = {DownCols:"adjust_type"
                                  +"|sabun|input_mon|adj_element_cd",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9",menuNm:$(document).find("title").text()
                                  ,HiddenColumn:1 //  열숨김 반영 여부 (Default: 0)
                                  };
            sheet1.Down2Excel(param);
            break;
        case "LoadExcel":
            if (isExElementAdjElementCd()) {
                break;
            }
        	if(chkRqr()){
                break;
            }

            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.
            // 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. 
            //              work_yy     => initdata 세팅으로 조정 
            //              adjust_type => 엑셀 양식에서 key-in으로 조정
            //              adj_element_cd => 엑셀 양식에서 key-in으로 조정
            //sheet1.SetColProperty(0, "work_yy", { DefaultValue: $("#searchWorkYy").val() } );
            //sheet1.SetColProperty(0, "adjust_type", { DefaultValue: $("#searchAdjustType").val() } );
            //sheet1.SetColProperty(0, "adj_element_cd", { DefaultValue: $("#searchAdjElementCd").val() } );
            
        	var params = {Mode:"HeaderMatch", WorkSheetNo:1};
            sheet1.LoadExcel(params);
            break;

        }
    }

    function chkRqr(){

    	var chkSearchAdjustType    = $("#searchAdjustType").val();
        var chkSearchAdjElementCd  =  $("#searchAdjElementCd").val();
        var chkValue = false;

        if(chkSearchAdjustType == '' || chkSearchAdjElementCd  == ''){
            alert("정산구분 및 구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }

        return chkValue;
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
                doAction1('Search');
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
            if(sheet1.ColSaveName(Col) == "name") {
                openEmployeePopup(Row) ;
            }
        } catch(ex) {
            alert("OnPopupClick Event Error : " + ex);
        }
    }



    //값이 바뀔때 발생
    function sheet1_OnChange(Row, Col, Value, OldValue) {
        try{

        } catch(ex) {
            alert("OnChange Event Error : " + ex);
        }
    }

    // 2024귀속 이후부터 국외근로소득, 외납새액의 수정 및 입력은 "외납세대상자관리"메뉴에서만 가능하도록 알림
    // B010_09	국외근로소득
    // B010_11	외국납부세액
    function isExElementAdjElementCd() {
        if ($("#searchWorkYy").val() != null && $("#searchWorkYy").val() >= "2024") {
            if ($("#searchAdjElementCd").val() == "B010_09" || $("#searchAdjElementCd").val() == "B010_11") {
                alert($("#searchWorkYy").val() + "귀속 "+$("#searchAdjElementCd option:checked").text()+" 자료는 [외납세대상자관리]메뉴를 이용하십시오.");
                return true;
            }
        }
        return false;
    }

    //사원 조회
    function openEmployeePopup(Row){
        try{

            if(!isPopup()) {return;}
            gPRow = Row;
            pGubun = "employeePopup";

            var args    = new Array();
            var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");

        } catch(ex) {
            alert("Open Popup Event Error : " + ex);
        }
    }

    function getReturnValue(returnValue) {

        var rv = $.parseJSON('{'+ returnValue+'}');

        if ( pGubun == "employeePopup" ){
            //사원조회
            sheet1.SetCellValue(gPRow, "name",      rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",     rv["sabun"] );
            sheet1.SetCellValue(gPRow, "org_nm",    rv["org_nm"] );
        }
    }

  //업로드 완료후 호출
    function sheet1_OnLoadExcel(result) {
        try {
            for(var i = 1; i < sheet1.RowCount()+1; i++) {

            	if($("#searchAdjElementCd").val() == "B010_30"
            			|| $("#searchAdjElementCd").val() == "B010_31"
            			|| $("#searchAdjElementCd").val() == "B010_32"
            			|| $("#searchAdjElementCd").val() == "B010_33"){
            		alert("중소기업 취업자감면금액은 연간소득관리 및 종전근무지에서 적용 하여 주시기 바랍니다.");
            		sheet1.RemoveAll();
            		return;
            	}
            }
        } catch(ex) {
            alert("OnLoadExcel Event Error " + ex);
        }
    }
  
  //수정(이력) 관련 세팅
	function getCprBtnChk(){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#searchWorkYy").val() 
                   + "&searchAdjustType="
                   + "&searchSabun=" ;
        
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#searchAdjustType").html("");
		} else {   			
   			$("#searchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
   			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <div class="sheet_search outer">
        <div>
        <table>
            <colgroup>
                <col width="100px;">
                <col width="100px;">
                <col width="*">
            </colgroup>
            <tr>
                <td><span style="padding-right:16px;">년도</span>
				<%-- 무의미한 분기문 주석 처리 20240919
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				--%>
					<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%-- 무의미한 분기문 주석 처리 20240919}else{%>
					<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}--%>
                </td>
                <td><span style="padding-right:11px;">정산구분</span>
                    <select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
                </td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
                </td>
            </tr>
            <tr>
                <td><span>구분</span>
                    <select id="searchAdjElementCd" name ="searchAdjElementCd" onChange="javascript:doAction1('Search')" class="box"></select>
                </td>
                <td><span>사번/성명</span>
                <input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
                <td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
            </tr>
        </table>
        </div>
    </div>
    </form>

    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">기타공제내역일괄등록</li>
            <li class="btn">
                <a href="javascript:doAction1('Down2Template')" class="basic btn-download authA">양식다운로드</a>
                <a href="javascript:doAction1('LoadExcel')"     class="basic btn-upload authA">업로드</a>
                <a href="javascript:doAction1('Insert')"        class="basic authA">입력</a>
                <a href="javascript:doAction1('Copy')"          class="basic authA">복사</a>
                <a href="javascript:doAction1('Save')"          class="basic btn-save authA">저장</a>
                <a href="javascript:doAction1('Down2Excel')"    class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>