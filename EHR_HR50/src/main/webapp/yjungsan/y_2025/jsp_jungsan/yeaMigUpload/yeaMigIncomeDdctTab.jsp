<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<!DOCTYPE html> <html><head> <title>소득공제</title>
<%@ page import="yjungsan.util.*"%>
<%@ page import="java.util.Map"%>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String orgAuthPg = request.getParameter("orgAuthPg");%>

<% String reCalc = (request.getParameter("reCalc")==null) ? "" : removeXSS((String)request.getParameter("reCalc"), "1"); %>
<script type="text/javascript">

	var titleList  = new Array();
	var dataList   = new Array();
	var colCnt = 0;
	var colData = "";
	var adjustTypeList = "";

	$(function() {

		adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00303"), ""); //작업구분(C00303)

		$("#searchWorkYy").val(parent.$("#searchWorkYy").val()) ;

		//소득공제
		var v = 0;
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [];
		initdata.Cols[v++] = {Header:"No",			Type:"<%=sNoTy%>",		Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata.Cols[v++] = {Header:"삭제",			Type:"<%=sDelTy%>",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"workYy",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 };
		initdata.Cols[v++] = {Header:"상태",			Type:"<%=sSttTy%>",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			KeyField:0,	Format:"",  PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata.Cols[v++] = {Header:"회사코드",		Type:"Text",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"enter_cd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata.Cols[v++] = {Header:"귀속년도",		Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"work_yy",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata.Cols[v++] = {Header:"정산코드",				    Type:"Text",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type",	  	    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10  };
		initdata.Cols[v++] = {Header:"정산구분",					Type:"Combo",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"adjust_type_nm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10  };
		initdata.Cols[v++] = {Header:"구분",	 				    Type:"Combo",			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gubun",			    KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10  };
		initdata.Cols[v++] = {Header:"차수",	 				    Type:"Int", 			Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"re_seq",			    KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10  };
		initdata.Cols[v++] = {Header:"사원번호",		Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 };
		initdata.Cols[v++] = {Header:"성명",			Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"f_name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };

		//동적 컬럼 세팅
		var headerList = ajaxCall("<%=jspPath%>/yeaMigUpload/yeaMigUploadRst.jsp?cmd=selectHeaderList", $("#sheetForm").serialize(), false);

		//헤더 세팅
		if (headerList != null && headerList.Data != null) {
			//헤더명 추출
			for(var i=0; i < headerList.Data.length; i++) {
				titleList["headerListNm"] = headerList.Data[i].header_nm.split("|");
				titleList["headerColNm"] = headerList.Data[i].header_col_nm.split("|");
			}
			//동적생성
			for(var i=0; i<titleList["headerListNm"].length; i++){
				var h = i+1;
				initdata.Cols[v++]  = { Header:titleList["headerListNm"][i],	Type:"Int",	Hidden:0,	Width:150,	Align:"Right",	ColMerge:0,	SaveName:titleList["headerColNm"][i],	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 };
			}
			colCnt = titleList["headerListNm"].length;
		}
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);

        //20250414 대량데이터 저장 시, 50건 단위로 분할 처리하도록 사이즈 지정
        try { IBS_setChunkedOnSave("sheet1", { chunkSize : 50 });  } catch(e) { console.info("info", e + ". chunkSize 기능은 [ibsheetinfo.js]의 DoSave 오버라이딩이 필요합니다." ); }     try { sheet1.SetLoadExcelConfig({ "MaxFileSize": 1 /* 1MB */ }); } catch(e) { console.info("info", e + ". MaxFileSize 옵션은 7.0.13.27 버전부터 제공됩니다." ); }
        
		sheet1.SetColProperty("adjust_type_nm",  	{ComboText:"|"+adjustTypeList[0], 		ComboCode:"|"+adjustTypeList[1]});
		sheet1.SetColProperty("gubun", 	            {ComboText:"|최종|수정(이력)",				ComboCode:"|F|H"});		

		<% if ("Y".equals(reCalc)) { %>
		    sheet1.SetColHidden("adjust_type", 0);
			sheet1.SetColHidden("gubun", 0);
			sheet1.SetColHidden("re_seq", 0);
		<% } %>
		
		doAction1("Search");
        $(window).smartresize(sheetResize); sheetInit();
	});

	//조회
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
			if(parent.searchSbNm.value != "" || parent.searchSbNm.value != null){
				$("#searchSbNm").val(parent.searchSbNm.value);
			}
			$("#searchAdjustType").val(parent.searchAdjustType.value);
			sheet1.DoSearch( "<%=jspPath%>/yeaMigUpload/yeaMigUploadRst.jsp?cmd=selectIncomeDdctList", $("#sheetForm").serialize()+"&colCnt="+colCnt );
			break;
		case "Save":
			sheet1.DoSave( "<%=jspPath%>/yeaMigUpload/yeaMigUploadRst.jsp?cmd=saveMigUploadMgr",$("#sheetForm").serialize()+"&colCnt="+colCnt);
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row,"work_yy",parent.$("#searchWorkYy").val(), 0); // change 이벤트는 발생 안 함
			sheet1.SetCellValue(Row,"adjust_type_nm",parent.$("#searchAdjustType").val(), 0);  // change 이벤트는 발생 안 함
			sheet1.SetCellValue(Row,"gubun","F", 0); // 일단 최종으로   // change 이벤트는 발생 안 함
			sheet1.SetCellValue(Row,"re_seq","", 0); // change 이벤트는 1번만 발생
			sheet1.SetCellValue(Row,"adjust_type",parent.$("#searchAdjustType").val(), 0);  // change 이벤트는 발생 안 함
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row,"work_yy",$("#searchWorkYy").val());
			sheet1.SetCellValue(Row,"sabun","");
			sheet1.SetCellValue(Row,"f_name","");
			break;
		case "Down2Template":
            var titleText  = "작성방법 \n 1. 귀속년도, 정산구분, 사원번호는 필수입니다.\n"+
            			     "2.저장시 해당 Row 삭제 저장 후 Upload 해주시기 바랍니다.\n";
			var codeCdNm = "", codeCd = "", codeNm = "";
			codeCdNm = "";
			codeNm = adjustTypeList[0].split("|"); codeCd = adjustTypeList[1].split("|");
			titleText += " 3. 작성기준 \n";
			for ( var i=0; i<codeCd.length; i++ ) {
				if(i == codeCd.length-1){
					codeCdNm += codeCd[i] + "-" + codeNm[i] + "";
				}else{
					codeCdNm += codeCd[i] + "-" + codeNm[i] + " , ";
				}
			}
			titleText += " 정산구분 : " + codeCdNm + " \n";
			var param  = {DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1,DownRows:0,FileName:'Template',SheetName:'sheet1',TitleText:titleText,UserMerge:"0,0,1,61", ExcelRowHeight:100 ,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var	params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//조회
	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
	});

    //조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			//동적 필드 데이터 세팅
			//colDataSet();
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnValidation(Row, Col, Value) {    	
    	<% if ("Y".equals(reCalc)) { %>
			try {
				if ( sheet1.ColSaveName(Col) != "re_seq" ) return;
				if ( sheet1.GetCellValue(Row,"sStatus") == "R" ) return;
				if ( sheet1.GetCellValue(Row,"sStatus") == "D" ) return;
					
				if (sheet1.GetCellValue(Row,"gubun") == "F") // 최종 
				{
					if ( !(typeof Value === 'undefined' || Value == '') ) 
	   				{
	   					alert(Row + " 행 : " + sheet1.GetCellText(Row,"gubun") + "은 차수를 시스템이 자동부여 합니다.");
	   				    sheet1.SetCellValue(Row, "re_seq", "", 0); //change 이벤트 발생 제외
	                    sheet1.SetSelectRow(Row);
	                    sheet1.ValidateFail(1);
	   				}
				} 
				else if (sheet1.GetCellValue(Row,"gubun") == "H") // 이력(수정) 
				{ 
					if (typeof Value !== 'undefined' && Value < 1) 
					{
						alert(Row + " 행 : " + sheet1.GetCellText(Row,"gubun") + "은 1차수 이상부터 등록 가능합니다.");
	                    sheet1.SetSelectRow(Row);
	                    sheet1.ValidateFail(1);
					}
				}
	        } catch(ex) {
	            alert("OnLoadExcel Event Error " + ex);
	        }
	   <% } %>
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

	function sheet1_OnChange(Row, Col, Value){
		if(sheet1.ColSaveName(Col)  == "gubun") {
			if (Value == "F") { // 최종
				sheet1.SetCellValue(Row, "re_seq",  "", 0); //change 이벤트 발생 제외
			}
		}
		if(sheet1.ColSaveName(Col)  == "re_seq") {
			if (sheet1.GetCellValue(Row,"gubun") == "H") { // 이력(수정)
				if (typeof Value !== 'undefined' && Value < 1) {
					alert(sheet1.GetCellText(Row,"gubun") + "은 1차수 이상부터 등록 가능합니다.");
				}
			}
		}
		if(sheet1.ColSaveName(Col)  == "adjust_type_nm" || sheet1.ColSaveName(Col)  == "gubun" || sheet1.ColSaveName(Col)  == "re_seq") {
			if (sheet1.GetCellValue(Row,"gubun") == "H") { // 이력(수정)
				sheet1.SetCellValue(Row, "adjust_type", sheet1.GetCellValue(Row,"adjust_type_nm") + "R" + sheet1.GetCellValue(Row,"re_seq"), 0); //change 이벤트 발생 제외
			} else {
				sheet1.SetCellValue(Row, "adjust_type", sheet1.GetCellValue(Row,"adjust_type_nm"), 0); //change 이벤트 발생 제외
			}
		}
	}

	//동적 필드 데이터 세팅
	function colDataSet(){
		//컬럼 데이터 조회
		colData = ajaxCall("<%=jspPath%>/yeaMigUpload/yeaMigUploadRst.jsp?cmd=getColDataList", 	$("#sheetForm").serialize()+"&colCnt="+colCnt, false);
		
		if (colData != null && colData.Data != null) {
			var colDataLen = colData.Data.length;
			if(colDataLen > 0 ){
				for(var k=1; k<colCnt+1; k++){
					for (var i = 0; i < colDataLen; i++) {
						sheet1.SetCellValue(i+1,"Data_"+k,colData.Data[i].col_data.split("_")[k-1]);
						sheet1.SetCellValue(i+1,"sStatus","R");
					}
				}
			}
		}
	}

    //업로드 완료후 호출
    function sheet1_OnLoadExcel(result) {
    	var errMsg = "";

    	//20250428. 성능저하로 인하여 onChange 이벤트가 가 발생하지 않도록 SetCellValue2 사용
		    try {
	            for(var i = 1; i < sheet1.RowCount()+1; i++) {	            	
	            	<% if (!"Y".equals(reCalc)) { %>
	        	    	sheet1.SetCellValue2(i, "gubun", "F", 0); // 최종 //change 이벤트 발생 제외
	        	    	sheet1.SetCellValue2(i, "re_seq", "", 0); //change 이벤트 발생 제외
	        	    	sheet1.SetCellValue2(i, "adjust_type", sheet1.GetCellValue(i,"adjust_type_nm"), 0); //change 이벤트 발생 제외
	        	    <% } else { %>
		       			if (sheet1.GetCellValue(i,"gubun") == "F") { // 최종
		       				if (typeof sheet1.GetCellValue(i,"re_seq") !== 'undefined') {
		       					if (errMsg != "") errMsg = errMsg + "\n";
		       					errMsg = errMsg + i + " 행 : " + sheet1.GetCellText(i,"gubun") + "은 차수를 시스템이 자동부여 합니다.";
		       				}
		       				sheet1.SetCellValue2(i, "adjust_type", sheet1.GetCellValue(i,"adjust_type_nm"), 0); //change 이벤트 발생 제외
		       			} else if (sheet1.GetCellValue(i,"gubun") == "H") { // 이력(수정)
		       				if (typeof sheet1.GetCellValue(i,"re_seq") !== 'undefined' && sheet1.GetCellValue(i,"re_seq") < 1) {
		       					if (errMsg != "") errMsg = errMsg + "\n";
		       					errMsg = errMsg + i + " 행 : " + sheet1.GetCellText(i,"gubun") + "은 1차수 이상부터 등록 가능합니다.";
		       				}
		       				sheet1.SetCellValue2(i, "adjust_type", sheet1.GetCellValue(i,"adjust_type_nm") + "R" + sheet1.GetCellValue(i,"re_seq"), 0); //change 이벤트 발생 제외
		       			}
	        	    <% } %>
	            }
	            if (errMsg != "") {
	            	alert(errMsg); 
	            }
	        } catch(ex) {
	            alert("OnLoadExcel Event Error " + ex);
	        }
    }
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheetForm" name="sheetForm" >
    <input type="hidden" id="menuNm"  name="menuNm"  value="" />
    <input type="hidden" id="tabNum"  name="tabNum"  value="4"/>
    <input type="hidden" id="searchWorkYy"  	name="searchWorkYy"  	 value=""/>
    <input type="hidden" id="searchAdjustType"  name="searchAdjustType"  value=""/>
    <input type="hidden" id="searchSbNm"  		name="searchSbNm"  		 value=""/>
    <input type="hidden" id="reCalc"  		    name="reCalc"  		     value="<%=reCalc%>"/>
    </form>
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">소득공제</li>
            <li class="btn">
				<a href="javascript:doAction1('Down2Template')"   	class="basic btn-download">양식 다운로드</a>
				<a href="javascript:doAction1('LoadExcel')"   		class="basic btn-upload">업로드</a>
				<a href="javascript:doAction1('Insert')" 			class="basic ">입력</a>
				<a href="javascript:doAction1('Copy')" 				class="basic ">복사</a>
				<a href="javascript:doAction1('Save')" 				class="basic btn-save">저장</a>
				<a href="javascript:doAction1('Down2Excel')" 		class="basic btn-download authR">다운로드</a>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "690px"); </script>
</div>
</body>
</html>