<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>소득공제서</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		
		$("#searchWorkYy").val("<%=yeaYear%>") ;

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:100,MergeSheet:msHeaderOnly}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
   			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"성명",      	Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  	ColMerge:0,   SaveName:"name",       KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"사번",      	Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  	ColMerge:0,   SaveName:"sabun",      KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"조직명",		Type:"Text",      	Hidden:0,  Width:100, 	Align:"Center",  	ColMerge:0,   SaveName:"org_nm",     KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"퇴직일",     Type:"Date",        Hidden:0,  Width:100,   Align:"Center",  	ColMerge:0,   SaveName:"ret_ymd",    KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"정산구분",		Type:"Combo",		Hidden:0,  Width:60,	Align:"Center",		ColMerge:0,	  SaveName:"adjust_type",	 KeyField:0,	               Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"출력순서",	Type:"Text",  		Hidden:0,  Width:70,	Align:"Center",  	ColMerge:0,   SaveName:"sort_no",    KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },		
			{Header:"전체",      	Type:"CheckBox",  	Hidden:0,  Width:70,	Align:"Center",  	ColMerge:0,   SaveName:"checked",    KeyField:0,   CalcLogic:"",   Format:"",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"파일패스",	Type:"Text",		Hidden:1,	Width:90,	Align:"Center",		ColMerge:0,	  SaveName:"file_path",	 KeyField:0,	               Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"파일명",		Type:"Text",		Hidden:1,	Width:60,	Align:"Center",		ColMerge:0,	  SaveName:"file_name",	 KeyField:0,	               Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"PDF확인", Type:"Html",		Hidden:0,	Width:70,	Align:"Center",		ColMerge:0,	  SaveName:"file_link",	 KeyField:0,	               Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var adjustTypeList 	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "전체");
	    var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");

		$("#searchBusinessPlaceCd").html(bizPlaceCdList[2]);
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		$("#searchMrdType").html("<option value='INCOME'>소득공제서</option><option value='CARD'>신용카드등</option><option value='DONATION'>기부금명세서</option><option value='MEDICAL'>의료비명세서</option>");
		
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		
		$(window).smartresize(sheetResize); sheetInit();

		//doAction1("Search"); 
	});
	
	$(function(){
		$("#searchWorkYy").bind("keyup",function(event){
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
		$("#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ 
				doAction1("Search");
			}
		});
		
		$("#searchAdjustType").bind("change",function(event){
			doAction1("Search");
		}); 
		
		$("#searchPrintYMD").datepicker2();
	});	
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/incomeDeductionSta/incomeDeductionStaRst.jsp?cmd=selectIncomeDeductionStList", $("#sheetForm").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		case "Down2Template":
			var param  = {DownCols:"1|2|6",SheetDesign:1,Merge:1,DownRows:"0",ExcelFontSize:"9"
				,TitleText:"",UserMerge :0};
			sheet1.Down2Excel(param);
			break;
        case "LoadExcel":
        	
        	if(chkRqr()){
                break;
           	}
        	
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; 
			sheet1.LoadExcel(params); 
			break;
		}
	}
	
    function chkRqr(){
        
        var chkSearchAdjustType    = $("#searchAdjustType").val();
        
        var chkValue = false;
        
        if(chkSearchAdjustType == ''){
            alert("정산구분을 선택 후 입력 할 수 있습니다.");
            chkValue = true;
        }
        
        return chkValue;
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			
			if(Code == 1) {
				for(var i = 1; i < sheet1.RowCount()+1; i++) {
					if(sheet1.GetCellValue(i,"sabun"))
					sheet1.SetCellValue(i,"file_link","<a href=\"javascript:openPdfViewPopup('"+sheet1.GetCellValue(i,"sabun")+"','" + sheet1.GetCellValue(i,"adjust_type") +"')\" class='basic'>확인</a>");
				}	
			}
			
			sheetResize();
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
// 	//클릭시 발생
// 	function sheet1_OnClick(Row, Col, Value) {
// 		try{
// 			if(sheet1.ColSaveName(Col) == "file_link") {
// 				//PDF파일 open
// 				openPdfViewPopup(sheet1.GetCellValue(Row,"sabun"));
// 			}
// 		}catch(ex){
// 			alert("OnClick Event Error : " + ex);
// 		}
// 	}

	//출력
	function print() {
		var sabuns = "";
		var sortSabuns = "";
		var sortNos = "";
		var checked = "";
			
	        if(sheet1.RowCount() != 0) {

	        	var printYmd = $("#searchPrintYMD").val().replace(/-/gi,""); 
	        	if ( printYmd == null || printYmd == "" || printYmd.length != 8) {
	        		alert("출력일자를 입력하십시오.");
	        		return;
	        	}
	        	
		        for(i=1; i<=sheet1.LastRow(); i++) {

		            checked = sheet1.GetCellValue(i, "checked");

		            if (checked == "1" || checked == "Y") {
		                sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
		                sortSabuns += sheet1.GetCellValue( i, "sabun" ) + ",";
		                sortNos += sheet1.GetCellValue( i, "sort_no" ) + ",";
		            }
		        }
				
		        if (sabuns.length > 1) {
					sabuns = sabuns.substr(0,sabuns.length-1);
					sortSabuns = sortSabuns.substr(0,sortSabuns.length-1);
					sortNos = sortNos.substr(0,sortNos.length-1);
		        }

		        if (sabuns.length < 1) {
		            alert("선택된 사원이 없습니다.");
		            return;
		        }
		        
		        var searchMrdType = $("#searchMrdType").val();
		        if ( searchMrdType == null || searchMrdType == "" ) {
		        	alert("출력물 종류를 선택하십시오.");
		        	return;
		        } else if ( searchMrdType == "INCOME" ) {
					//소득공제서 call RD!
		        	empIncomeDeductionDeclarationPopup(sabuns, sortSabuns, sortNos) ;
		        } else {
		        	//신용카드등/기부금/의료비  call RD!
		        	doReport(searchMrdType, sabuns, sortSabuns, sortNos);   
		        }
	    } else {

	        alert("선택된 사원이 없습니다.");
	        return;

	    }

	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function empIncomeDeductionDeclarationPopup(sabuns, sortSabuns, sortNos){
  		var w 		= 800;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		
		var rdFileNm ;
		if($("#searchWorkYy").val() != "" && ( $("#searchWorkYy").val()*1 ) >= 2008 ){
			rdFileNm		= "EmpIncomeDeductionDeclaration_"+$("#searchWorkYy").val()+".mrd";
		} else {
			rdFileNm		= "EmpIncomeDeductionDeclaration.mrd";
		}
		
		var printYmd = $("#searchPrintYMD").val().replace(/-/gi,"");
		
		// 정산구분이 전체일 경우 출력불가
		var searchAdjustType = $("#searchAdjustType").val();
		
		if( searchAdjustType == "" ){
			alert("정산구분을 선택해주세요.");
			return;
		}
		
		args["rdTitle"] = "소득공제서" ;//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+ rdFileNm; //( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>] ["+$("#searchWorkYy").val()+"] ["+$("#searchAdjustType").val()+"]"+
		                  "["+sabuns+"] ["+<%=curSysYyyyMMdd%>+"]" +
		                  "[4] ["+sortSabuns+"] ["+sortNos+"] ["+printYmd+"]";//rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율
		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		if(!isPopup()) {return;}
		
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		//if(rv!=null){
			//return code is empty
		//}
	}
	
	/**
	 * 기부금명세서 / 신용카드 등 소득공제 신청서 / 교육비명세서(양식) / 의료비지급명세서 출력
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function doReport(report_type, sabuns, sortSabuns, sortNos){
		
		//rd call info init
		var rdFileNm = "" ;
		var popupTitle = "" ;

		if(report_type == "DONATION") {
			popupTitle = "기부금명세서" ;
			if( ($("#searchWorkYy").val()*1) > 2006 ) {
				rdFileNm = "DonationPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
			} else {
				rdFileNm = "DonationPaymentDescription.mrd" ;
			}
		} else if(report_type == "CARD") {
			popupTitle = "신용카드 등 소득공제 신청서" ;
			rdFileNm = "CardPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
		} else {
			popupTitle = "의료비지급명세서" ;
			rdFileNm = "MedicalPaymentDescription_" + $("#searchWorkYy").val() + ".mrd" ;
		}

		//rd option and params setting
		var w 		= 800;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		
		var printYmd = $("#searchPrintYMD").val().replace(/-/gi,"");
		
		// 정산구분이 전체일 경우 출력불가
		var searchAdjustType = $("#searchAdjustType").val();
		
		if( searchAdjustType == "" ){
			alert("정산구분을 선택해주세요.");
			return;
		}
		
		// args의 Y/N 구분자는 없으면 N과 같음
		//2019-11-12. 기부금 명세서일 경우 2페이지 작성방법이 나오지 않게 할 수 있는 옵션 추가
		args["rdTitle"] = popupTitle ;//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+rdFileNm;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>] ["+$("#searchWorkYy").val()+"] ["+$("#searchAdjustType").val()+"] " +
		                  "["+sabuns+"] [00000] [ALL] " +
		                  "[4] ["+sortSabuns+"] ["+sortNos+"] ["+printYmd+"] [Y]";//rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF

		if(!isPopup()) {return;}
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		//if(rv!=null){
			//return code is empty
		//}
	}
	
	//pdf 업로드 팝업
	function openPdfViewPopup(sabun, adjust_type){
		
		if(!isPopup()) {return;}
		
		var args = [];
		args["searchWorkYy"] = $("#searchWorkYy").val();
		args["searchAdjustType"] = adjust_type;
		args["searchSabun"] = sabun ;
		
		var rv = openPopup("<%=jspPath%>/yeaData/yeaPdfListPopup.jsp?&authPg=A",args,"700","400");		
		
	}

	function sheetChangeCheck() {
		var iTemp = sheet1.RowCount("I") + sheet1.RowCount("U") + sheet1.RowCount("D")
							+ sheet2.RowCount("I") + sheet2.RowCount("U") + sheet2.RowCount("D");
		if ( 0 < iTemp ) return true;
		return false;
	}
	
	//업로드 완료후 호출
    function sheet1_OnLoadExcel(result) {
        try {
        	if(sheet1.RowCount() != 0) {
	        	for(var i = 1; i < sheet1.RowCount()+1; i++) {
					sheet1.SetCellValue(i,"adjust_type", $("#searchAdjustType").val());
					sheet1.SetCellValue(i,"file_link","<a href=\"javascript:openPdfViewPopup('"+sheet1.GetCellValue(i,"sabun")+"','" + $("#searchAdjustType").val() + "')\" class='basic'>보기</a>");
				}
        	}
        } catch(ex) { 
            alert("OnLoadExcel Event Error " + ex); 
        }
    }
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
					<td>
						<span>사업장</span>
						<select id="searchBusinessPlaceCd" name ="searchBusinessPlaceCd" onChange="" class="box"></select> 
					</td>
					<td>
						<span>귀속</span>
						<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text w40"/>
						<span>년</span>
						
						<select id="searchWorkMm" name ="searchWorkMm" onChange="" class="box">
							<option value=""></option>
							<option value="01">01</option>
							<option value="02">02</option>
							<option value="03">03</option>
							<option value="04">04</option>
							<option value="05">05</option>
							<option value="06">06</option>
							<option value="07">07</option>
							<option value="08">08</option>
							<option value="09">09</option>
							<option value="10">10</option>
							<option value="11">11</option>
							<option value="12">12</option>
						</select>
						<span>월</span>
					</td>
					<td>
						<span>정산구분</span>
						<select id="searchAdjustType" name ="searchAdjustType" onChange="doAction1('Search')" class="box"></select> 
					</td>
					<td colspan="2">
						<span>종류</span>
						<select id="searchMrdType" name ="searchMrdType" class="box"></select> 
					</td>
				</tr>
				<tr>
					<td>
						<span>사번/성명</span>
						<input id="searchSbNm" name ="searchSbNm" type="text" class="text w60"/>
					</td>
					<td>
						<span>부서명</span>
						<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text"/>
					</td>
					<td>
						<span>출력일자 </span>
						<input id="searchPrintYMD" name ="searchPrintYMD" type="text" class="text" value="<%=curSysYyyyMMddHyphen%>"/>
					</td>
					<td>
						<span>출력순서</span>
						<select id="searchSort" name ="searchSort" onChange="doAction1('Search')" class="box">
							<option value="1" selected>성명순</option>
	                        <option value="2" >사번순</option>
	                        <option value="3" >부서순</option>
						</select> 
					</td>
					<td>
						<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
					</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">출력대상자</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Template')" class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
								<a href="javascript:print()" class="basic authA">출력</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>