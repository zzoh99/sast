<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>소득공제차감업로드</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var helpText;
	var gPRow;
	var adjustTypeList = null;
	var contributionCdList = null;
	var deductionCdList = null;
	var adjElementCdList = null;
	
	$(function() {
		//엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchYear").val("<%=Integer.parseInt(yeaYear) %>") ;

		// 2번 그리드
        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
			{Header:"No",					Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
  			{Header:"삭제",					Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
  			{Header:"상태",					Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
          <%// 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. => initdata 세팅으로 조정
            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.%>  			
            {Header:"대상연도",				Type:"Text",    	Hidden:0,  	Width:25,	Align:"Center", ColMerge:1, SaveName:"work_yy",			KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500, DefaultValue:"<%=yeaYear%>" },
            {Header:"정산구분",				Type:"Combo",    	Hidden:0,  	Width:80,	Align:"Center", ColMerge:1, SaveName:"adjust_type",		KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"성명",                  Type:"Popup",     	Hidden:0,  	Width:50,  	Align:"Center", ColMerge:1, SaveName:"name",            KeyField:0,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"사번",                  Type:"Text",    		Hidden:0,  	Width:50,	Align:"Center", ColMerge:1, SaveName:"sabun",           KeyField:1,   CalcLogic:"",   Format:"",        PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:500 },
            {Header:"명의인",					Type:"Text",		Hidden:0,  	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"fam_nm",			KeyField:1, 				  Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"증빙자료구분",				Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"deduction_cd",	KeyField:1,					  Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
            {Header:"정산항목",				Type:"Combo",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:1,	SaveName:"adj_element_cd",	KeyField:1,	  				  Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
            {Header:"차감금액",             Type:"AutoSum",    Hidden:0,   Width:50,   Align:"Right",  ColMerge:1, SaveName:"ded_mon",     		KeyField:0, 				  Format:"NullInteger",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35},
            {Header:"인적공제\n등록여부",        Type:"Combo",    	Hidden:0,   Width:50,   Align:"Center",  ColMerge:1, SaveName:"fam_yn",     		KeyField:0, 				  Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:35},
            {Header:"비고",			    	Type:"Text",		Hidden:0,   Width:80,  Align:"Center",   	ColMerge:1, SaveName:"memo",			KeyField:0, Format:"",  	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:300 }
		];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
        
		//작업구분
        adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
        contributionCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y&searchYear=<%=yeaYear%>", "YEA300"), "" );
        deductionCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y&searchYear=<%=yeaYear%>", "YEA300"), "" );
        
        var params = "searchWorkYy=" + $('#searchYear').val();
		adjElementCdList = stfConvCode( ajaxCall("<%=jspPath%>/incomeDedLimitMgr/incomeDedLimitMgrRst.jsp?cmd=getDedItemList",params,false).codeList, "");

        sheet1.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
        sheet1.SetColProperty("deduction_cd",    {ComboText:"|"+deductionCdList[0], ComboCode:"|"+deductionCdList[1]} );
        sheet1.SetColProperty("adj_element_cd",    {ComboText:"|"+adjElementCdList[0], ComboCode:"|"+adjElementCdList[1]} );
        sheet1.SetColProperty("fam_yn", {ComboText: "|등록|미등록", ComboCode: "|Y|N"});

        $("#searchAdjustType").html(adjustTypeList[2]).val("1");

    	// 사업장(권한 구분)
    	var ssnSearchType = "<%=ssnSearchType%>";
    	var bizPlaceCdList = "";

    	if(ssnSearchType == "A"){
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
    	}else{
    		bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
    	}

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);

        $(window).smartresize(sheetResize);
        sheetInit();
        
        getCprBtnChk();

        doAction1("Search");
			
		//양식다운로드용 sheet 정의
		templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
		var codeCdNm = "", codeCd = "", codeNm = "";

		codeCdNm = "";
		codeNm = deductionCdList[0].split("|");  
		codeCd = deductionCdList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "증빙자료구분 : " + codeCdNm + "\n";

		codeCdNm = "";
		adjElementCdList = stfConvCode( ajaxCall("<%=jspPath%>/incomeDedLimitMgr/incomeDedLimitMgrRst.jsp?cmd=getDedItemList","searchWorkYy=<%=yeaYear%>&adjProcessCd=B007",false).codeList, "");
		codeNm = adjElementCdList[0].split("|");  
		codeCd = adjElementCdList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "정산항목(의료비) : " + codeCdNm + "\n";

		codeCdNm = "";
		adjElementCdList = stfConvCode( ajaxCall("<%=jspPath%>/incomeDedLimitMgr/incomeDedLimitMgrRst.jsp?cmd=getDedItemList","searchWorkYy=<%=yeaYear%>&adjProcessCd=B009",false).codeList, "");
		codeNm = adjElementCdList[0].split("|");  
		codeCd = adjElementCdList[1].split("|");
		for ( var i=0; i<codeCd.length; i++ ) codeCdNm += codeCd[i] + "-" + codeNm[i] + "\n";
		templeteTitle1 += "정산항목(교육비) : " + codeCdNm + "\n";	
		

	});

	$(function(){
		$("#searchYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
		$("input[name=searchMon]").change(function(){
			doAction1("Search");
		});
	});

    //Sheet Action Second
    function doAction1(sAction) {

		switch (sAction) {
		case "Search":
            if($("#searchYear").val() == "") {
                alert("대상연도를 입력하여 주십시오.");
                return;
            }

            sheet1.DoSearch( "<%=jspPath%>/incomeDedLimitMgr/incomeDedLimitMgrRst.jsp?cmd=selectIncomeDedLimitUploadList", $("#sheetForm").serialize(), 1 );
            break;
		case "Save":
			for(var i=2; i < sheet1.LastRow()+2; i++){
				if(sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U"){
					
				}
			}
			sheet1.DoSave( "<%=jspPath%>/incomeDedLimitMgr/incomeDedLimitMgrRst.jsp?cmd=saveIncomeDedLimitUploadDetail",$("#sheetForm").serialize());
			break;
		case "Insert":
            if($("#searchAdjustType").val() == "") {
                alert("정산구분을 먼저 입력하여 주십시오.");
                return;
            }

			var newRow = sheet1.DataInsert(0);
			sheet1.SetCellValue(newRow, "work_yy", $("#searchYear").val() ) ;
			sheet1.SetCellValue(newRow, "adjust_type", $("#searchAdjustType").val() ) ;
			break;
		case "Copy":
			var newRow = sheet1.DataCopy();
			var flag = 1;
			
   			var dedCd = sheet1.GetCellValue(newRow, "deduction_cd");
   			var params = "searchWorkYy=" + $('#searchYear').val() + "&adjProcessCd=" + dedCd;
   			var adjElementCdList = stfConvCode( ajaxCall("<%=jspPath%>/incomeDedLimitMgr/incomeDedLimitMgrRst.jsp?cmd=getDedItemList",params,false).codeList, "");
   			sheet1.CellComboItem(newRow,"adj_element_cd", {ComboText:"|"+adjElementCdList[0], ComboCode:"|"+adjElementCdList[1]});
   			sheet1.SetCellValue(newRow, "adj_element_cd",  "");
   			
            //sheet1.SetCellEditable(newRow, "prev_ded_mon",   flag);
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param); break;
		case "Down2Template":
			var param  = {DownCols:"adjust_type"
                                    +"|sabun|fam_nm|deduction_cd|adj_element_cd|ded_mon|memo",SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"
				            ,TitleText:templeteTitle1,UserMerge :"0,0,1,6",menuNm:$(document).find("title").text()
			                ,HiddenColumn:1 //  열숨김 반영 여부 (Default: 0)
			                };
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
            if($("#searchAdjustType").val() == "") {
                alert("정산구분을 먼저 입력하여 주십시오.");
                return;
            }

            // 20250418. OnLoadExcel 이벤트에서 RowCount 반복 수행으로 인한 성능저하. case "LoadExcel"의 디폴트 값 세팅으로 개선.
            // 20250502. 시트 7.0.0.0-20131223-17 버전에서는 SetColProperty 로 DefaultValue가 지원되지 않음. 
            //              work_yy     => initdata 세팅으로 조정 
            //              adjust_type => 엑셀 양식에서 key-in으로 조정
            //sheet1.SetColProperty(0, "work_yy", { DefaultValue: $("#searchYear").val() } );
            //sheet1.SetColProperty(0, "adjust_type", { DefaultValue: $("#searchAdjustType").val() } );
            
       	    var params = {Mode:"HeaderMatch", WorkSheetNo:1};
       	    sheet1.LoadExcel(params);
       	    break;
         }
    }

	// 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try {
			alertMessage(Code, Msg, StCode, StMsg);
			
			for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++) {
				if(sheet1.GetCellValue(i, "fam_yn") == "N") {
					sheet1.SetCellBackColor(i, "fam_yn", "#f79eba");
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
        		doAction1("Search");
			}
        } catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
        }
    }

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
	
    function sheet1_OnChange(Row, Col, Value) {
   	 try{
   		var colName = sheet1.ColSaveName(Col);

   		if (Row <= 0) {
   			return;
   		}

   		if (colName == "deduction_cd") {
   			var dedCd = sheet1.GetCellValue(Row, "deduction_cd");
   			var params = "searchWorkYy=" + $('#searchYear').val() + "&adjProcessCd=" + dedCd;
   			var adjElementCdList = stfConvCode( ajaxCall("<%=jspPath%>/incomeDedLimitMgr/incomeDedLimitMgrRst.jsp?cmd=getDedItemList",params,false).codeList, "");
   			sheet1.CellComboItem(Row,"adj_element_cd", {ComboText:"|"+adjElementCdList[0], ComboCode:"|"+adjElementCdList[1]});
   			sheet1.SetCellValue(Row, "adj_element_cd",  "");
   		}

   	 } catch(ex) {alert("OnChange Event Error : " + ex);}
   }
    
    function sheet1_OnClick(Row, Col, Value) {
      	 try{
      		var colName = sheet1.ColSaveName(Col);

      		if (Row <= 0) {
      			return;
      		}

      	 } catch(ex) {alert("OnClick Event Error : " + ex);}
      }

    //사원 조회
    function openEmployeePopup(Row){
        try{

            if(!isPopup()) {return;}
            gPRow = Row;
            pGubun = "employeePopup";

            var url 	= "<%=jspPath%>/incomeDedLimitMgr/incomeDedEmployeePopup.jsp?authPg=<%=authPg%>";
            var args    = new Array();
            args["searchYear"] = $('#searchYear').val();
            args["searchAdjustType"] = $('#searchAdjustType').val();
            var rv = openPopup(url, args, "740","520");
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
        }
		sheet1.SetCellValue(gPRow, "deduction_cd",  "");
        sheet1.SetCellValue(gPRow, "adj_element_cd",  "");
    }
    
  //수정(이력) 관련 세팅
	function getCprBtnChk(){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#searchYear").val() 
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
    <div class="sheet_search outer">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm" name="menuNm" value="" />
    <!-- Second Grid 조회 조건 -->
        <div>
        <table>
        <tr>
            <td>
            	<span>대상연도</span>
				<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
			</td>
			<td>
				<span>정산구분</span>
				<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
			</td>
			<!--
            <td>
                <span>사업장</span>
                <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')"></select>
            </td>
            -->
            <td>
                <span>구분</span>
                <select id="searchGubunCd" name ="searchGubunCd" class="box" onChange="javascript:doAction1('Search')">
                	<option value="">전체</option>
					<option value="B007">의료비</option>
					<option value="B009">교육비</option>
                </select>
            </td>
			<td>
				<span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/>
			</td>
            <td>
            	<a href="javascript:doAction1('Search')" class="button">조회</a>
            </td>
        </tr>
        </table>
        </div>
    </form>
    </div>

    <div class="outer">
        <div class="sheet_title">        
        <ul>
	        <li class="txt" style="color: red;">※ 자료등록에 입력된 항목에서 해당 금액이 차감되어 반영되오니 금액이 정상적으로 등록됐는지 확인 부탁드립니다.</li>
            <li class="btn">
				<a href="javascript:doAction1('Down2Template')"	class="basic btn-download authA">양식 다운로드</a>
				<a href="javascript:doAction1('LoadExcel')"   	class="basic btn-upload authA">업로드</a>
				<a href="javascript:doAction1('Insert')" 			class="basic authA">입력</a>
				<a href="javascript:doAction1('Copy')"   			class="basic authA">복사</a>
				<a href="javascript:doAction1('Save')"   			class="basic btn-save authA">저장</a>
				<a href="javascript:doAction1('Down2Excel')"   	class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

</div>
</body>
</html>