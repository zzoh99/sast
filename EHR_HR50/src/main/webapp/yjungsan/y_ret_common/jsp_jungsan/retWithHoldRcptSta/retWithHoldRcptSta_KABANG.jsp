<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수영수증</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript_KABANG.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		
		$("#searchWorkYy").val("<%=curSysYear%>") ;
		
		//조회건수가 너무 많을 수 있으므로 초기 조회조건에 세팅
		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
 			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
 			{Header:"귀속연월",      	Type:"Text",      	Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"pay_ym",  KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
 			{Header:"퇴직계산일자",     Type:"Date",      	Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"payment_ymd",  KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 }, 			
 			{Header:"급여계산코드",     Type:"Text",      	Hidden:1,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"pay_action_cd",  KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
 			{Header:"성명",			Type:"Popup",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"사번",      	  	Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"sabun",      KeyField:1,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
			{Header:"조직명",      	Type:"Text",      	Hidden:0,  Width:100, 	Align:"Center",  ColMerge:0,   SaveName:"org_nm",     KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,	EditLen:100 },
			{Header:"전체",      	  	Type:"CheckBox",  	Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"checked",    KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },			
			{Header:"도장출력",      	Type:"CheckBox",  	Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"stamp_chk",  KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:1, FalseValue:"''"}			
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var purposeCdList	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYM="+$("#searchWorkYy").val()+"<%=curSysMon%>","C00315"), "");
	    var retPayCdList = convCode( codeList("${pageContext.request.contextPath}/CommonCode.do?cmd=getCommonNSCodeList","getCpnPayCdList&searchRunType='00004'") , "");
		
		$("#searchRetPayCd").html(retPayCdList[2]);
		$("#searchPurposeCd").html(purposeCdList[2]);
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
		
		$("#searchPrintYMD").datepicker2();		
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/retWithHoldRcptSta/retWithHoldRcptStaRst.jsp?cmd=selectRetWithHoldRcptStaList", $("#sheetForm").serialize() );
			break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	var gPRow  = "";
	var pGubun = "";
	
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
				openEmployeePopup(Row) ;
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
	function sheet1_OnLoadExcel() {
		try {
	    	LoadPersonInfo();
		} catch (ex) {
			alert("OnLoadExcel Event Error : " + ex);
		}
	}
	
	// 사원 조회
	function openEmployeePopup(Row){
	    try{
	    	
	    	 if(!isPopup()) {return;}
		     gPRow  = Row;
			 pGubun = "employeePopup";
				 
		     var args    = new Array();
		     var rv = openPopup("<%=jspPath%>/common/employeePopup.jsp?authPg=<%=authPg%>", args, "740","520");
		     /*
		        if(rv!=null){
					sheet1.SetCellValue(Row, "name", 		rv["name"] );
					sheet1.SetCellValue(Row, "sabun", 		rv["sabun"] );
					sheet1.SetCellValue(Row, "org_nm", 		rv["org_nm"] );
					sheet1.SetCellValue(Row, "manage_nm", 	rv["manage_nm"] );
					sheet1.SetCellValue(Row, "stamp_chk", 	'Y' );
		        }
		     */
	    } catch(ex) {
	    	alert("Open Popup Event Error : " + ex);
	    }
	}
	
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "employeePopup" ){
			//사원조회
			sheet1.SetCellValue(gPRow, "name", 		rv["name"] );
			sheet1.SetCellValue(gPRow, "sabun", 	rv["sabun"] );
			sheet1.SetCellValue(gPRow, "org_nm", 	rv["org_nm"] );
			sheet1.SetCellValue(gPRow, "manage_nm", rv["manage_nm"] );
			sheet1.SetCellValue(gPRow, "stamp_chk", 'Y' );
		}
	}
	
	//출력
	function print() {

		if ($("#searchPurposeCd").val() == "") {
			alert("용도를 선택해 주십시오.");
			$("#searchPurposeCd").focus();
			return;

		}
		var sabuns = "";
		var sortSabuns = "";
		var payActionCds = "";
		var stamps = "";
		var checked = "";
		var searchAllCheck = "";
		var sabunCnt = 0;
		
		if(sheet1.RowCount() != 0) {
	        for(i=1; i<=sheet1.LastRow(); i++) {

	            checked = sheet1.GetCellValue(i, "checked");

	            if (checked == "1" || checked == "Y") {
	                sabuns += "'" + sheet1.GetCellValue( i, "sabun" ) + "',";
	                sortSabuns += "" + sheet1.GetCellValue( i, "sabun" ) + ",";
	                if("1" == sheet1.GetCellValue( i, "stamp_chk" )) {
	                	stamps += sheet1.GetCellValue( i, "stamp_chk" ) + ",";
	                } else {
	                	stamps += ",";
	                }
	                payActionCds += "'" + sheet1.GetCellValue( i, "pay_action_cd" ) + "',";	  
	            } 
	        }
	        
	        if (sabuns.length > 1) {
				sabuns = sabuns.substr(0,sabuns.length-1);
				sortSabuns = sortSabuns.substr(0,sortSabuns.length-1);
				payActionCds = payActionCds.substr(0,payActionCds.length-1);
				stamps = stamps.substr(0,stamps.length-1);
				
				sortSabuns = "'" + sortSabuns + "'";
				stamps = "'" + stamps +"'"; 
	        }

	        if (sabuns.length < 1) {
	            alert("선택된 사원이 없습니다.");
	            return;
	        }
			//call RD!
	        retWithHoldRcptStaPopup(sabuns, sortSabuns, payActionCds, stamps) ;
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
	function retWithHoldRcptStaPopup(sabuns, sortSabuns, payActionCds, stamps){
  		var w 		= 800;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		var rdFileNm ;
		
		if($("#searchWorkYy").val() !=null && ( $("#searchWorkYy").val()*1 ) >= 2007 ){
			rdFileNm		= "RetireIncomeWithholdReceipt"+$("#searchReportType").val()+"_"+$("#searchWorkYy").val()+".mrd";
		} else {
			rdFileNm		= "RetireIncomeWithholdReceipt"+$("#searchReportType").val()+".mrd";
		}
		var printYmd = $("#searchPrintYMD").val().replace(/-/gi,"");
		var imgPath = "<%=rdStempImgUrl%>";
		var imgFile = "<%=rdStempImgFile%>";
		var purposeCd = $("#searchPurposeCd").val() ;
		args["rdTitle"] = "퇴직소득명세서" ;//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+ rdFileNm; //( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[<%=session.getAttribute("ssnEnterCd")%>] ["+ payActionCds +"] ["+sabuns+"] [00000] ["+purposeCd+"] ["+imgPath+"]" +
					      "[%] [%] ["+printYmd+"] ["+sortSabuns+"] ["+stamps+"]";//rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율
//alert(args["rdParam"]);		
	    //2011년 이후 연말정산 패치가 될 소지가 있어 아래 로직을 추가 반영한다. 
	    //이수화학의 경우, 파일로 저장할 수 없도록 설정한다. 출력만 가능. 2012-02-23 김명주씨 요청사항.
	    if("ISU_CH" == ("<%=session.getAttribute("ssnEnterCd")%>")) {
			args["rdSaveYn"] 	= "N" ;//기능컨트롤_저장
	    } else {
			args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
	    }
		
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
	
    function LoadPersonInfo()
    {
        var rowSabun = "";
        var enterCd = "";
        if( sheet1.RowCount() != 0 ) {               

            for(i=1; i<=sheet1.LastRow(); i++) {
            	rowSabun = sheet1.GetCellValue( i, "sabun" ) ;
	   	    	var req = ajaxCall("<%=jspPath%>/retWithHoldRcptSta/retWithHoldRcptStaRst.jsp?cmd=selectEmpInfoUsingSabun","searchSabun="+rowSabun,false);
            
				if(req.Result.Code == 1) {
					if(typeof req.Data.name != "undefined") {
		               	sheet1.SetCellValue(i, "name", req.Data.name);
		                sheet1.SetCellValue(i, "sabun", req.Data.sabun);
		                sheet1.SetCellValue(i, "org_nm", req.Data.org_nm);
		                //sheet1.SetCellValue(i, "manage_nm", req.Data.manage_nm);
		                sheet1.SetCellValue(i, "stamp_chk", 1) ;
		                //sheet1.SetCellValue(i, "sort_no", i) ;
					} else {
	                	alert("*사원정보 가저오는 도중 에러 발생*\n - 업로드 된 사번 중 인사정보에 없는 사번이 존재합니다.\n에러가 발생한 사번 => "+rowSabun) ;
	                	return ;
					}
				}
            }
        }
    }
</script>
</head>
<body class="hidden">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
					<td colspan="2">
						<span>대상년도</span>
						<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text w40"/>
						<span>년</span>
						<select id="searchWorkSMm" name ="searchWorkSMm" onChange="" class="box">
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
						<span>월 ~ </span>
						<select id="searchWorkEMm" name ="searchWorkEMm" onChange="" class="box">
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
						<span>용도</span>
						<select id="searchPurposeCd" name ="searchPurposeCd" onChange="" class="box">
						</select> 
					</td>
					<td>
						<span>출력일자 </span>
						<input id="searchPrintYMD" name ="searchPrintYMD" type="text" class="text" value="<%=curSysYyyyMMddHyphen%>"/>
					</td>
				</tr>
				<tr>
					<td>
						<span>사번/성명</span>
						<input id="searchSbNm" name ="searchSbNm" type="text" class="text w60"/>
					</td>
					<td>
						<span>급여구분 </span>
						<select id="searchRetPayCd" name ="searchRetPayCd" class="box"></select>
					</td>
					<td>
						<span>양식</span>
						<select id="searchReportType" name ="searchReportType" onChange="" class="box">
	                        <option value='1'>양식1(법정퇴직급여)</option>
	                        <option value='2'>양식2(법정이외퇴직급여)</option> 
	                        <option value='3'>양식3(퇴직소득과세이연명세서)</option>
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
			<td style="width:65%">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">출력대상자</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')"		class="basic authA">입력</a>
								<a href="javascript:doAction1('Down2Excel')"	class="basic authR">다운로드</a>
								<a href="javascript:print()"					class="basic authA">출력</a>
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