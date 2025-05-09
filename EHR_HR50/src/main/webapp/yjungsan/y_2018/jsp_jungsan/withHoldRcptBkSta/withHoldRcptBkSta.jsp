<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수부</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		
		$("#searchWorkYy").val("<%=yeaYear%>") ;

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
   			{Header:"No",		Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
			{Header:"성명",      	Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"name",       KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"사번",      	Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"sabun",      KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"조직명",		Type:"Text",      	Hidden:0,  Width:100, 	Align:"Center",  ColMerge:0,   SaveName:"org_nm",     KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,	EditLen:100 },
			{Header:"퇴직일",       Type:"Date",        Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"ret_ymd",    KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,    EditLen:100 },
   			{Header:"정산구분",		Type:"Combo",		Hidden:0,  Width:60,	Align:"Center",	 ColMerge:0,	  SaveName:"adjust_type",	 KeyField:0,	        Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"출력순서",		Type:"Text",  		Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"sort_no",    KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100 },		
			{Header:"전체",      	Type:"CheckBox",  	Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"checked",    KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			{Header:"도장출력",      	Type:"CheckBox",  	Hidden:0,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"stamp_chk",  KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:1},
			{Header:"신청상태",      	Type:"CheckBox",  	Hidden:1,  Width:70,	Align:"Center",  ColMerge:0,   SaveName:"",  KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,	EditLen:1}
        ]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var adjustTypeList 	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00303"), "전체");
	    var bizPlaceCdList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList","getBizPlaceCdList") , "전체");

		$("#searchBusinessPlaceCd").html(bizPlaceCdList[2]);
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");
		
		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});
		
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
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
			sheet1.DoSearch( "<%=jspPath%>/withHoldRcptBkSta/withHoldRcptBkStaRst.jsp?cmd=selectWithHoldRcptBkStaList", $("#sheetForm").serialize() );
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

	//출력
	function print(printGbn) {
		
		// 정산구분이 전체일 경우 출력불가
		var searchAdjustType = $("#searchAdjustType").val();
		
		if( searchAdjustType == "" ){
			alert("정산구분을 선택해주세요.");
			return;
		}
		
		var sabuns = "";
		var sortSabuns = "";
		var sortNos = "";
		var stamps = "";
		var checked = "";
		var searchAllCheck = "";
		var sabunCnt = 0;
			
	        if(sheet1.RowCount() != 0) {
		        for(i=1; i<=sheet1.LastRow(); i++) {

		            checked = sheet1.GetCellValue(i, "checked");

		            if (checked == "1" || checked == "Y") {
		                sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
		                sortSabuns += sheet1.GetCellValue( i, "sabun" ) + ",";
		                sortNos += sheet1.GetCellValue( i, "sort_no" ) + ",";
		                stamps += sheet1.GetCellValue( i, "stamp_chk" ) + ",";
		            }
		        }
				
		        if (sabuns.length > 1) {
					sabuns = sabuns.substr(0,sabuns.length-1);
					sortSabuns = sortSabuns.substr(0,sortSabuns.length-1);
					sortNos = sortNos.substr(0,sortNos.length-1);
					stamps = stamps.substr(0,stamps.length-1);
		        }

		        if (sabuns.length < 1) {
		            alert("선택된 사원이 없습니다.");
		            return;
		        }
				//call RD!
		        withHoldRcptBkStaPopup(sabuns, sortSabuns, sortNos, stamps, printGbn) ;			
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
	function withHoldRcptBkStaPopup(sabuns, sortSabuns, sortNos, stamps, printGbn){
  		var w 		= 1040;
		var h 		= 600;
		var url 	= "<%=jspPath%>/common/rdPopup.jsp";
		var args 	= new Array();
		
		var rdFileNm ;
		if($("#searchWorkYy").val() != "" && ( $("#searchWorkYy").val()*1 ) >= 2008 ){
			rdFileNm = "EmpWorkIncomeWithholdReceiptBook_"+$("#searchWorkYy").val()+".mrd";
		} else {
			rdFileNm = "EmpWorkIncomeWithholdReceiptBook.mrd";
		}
		
		var printYmd = $("#searchPrintYMD").val().replace(/-/gi,"");
		var bpCd = $("#searchBusinessPlaceCd").val() ;
		if(bpCd == "") bpCd = "ALL" ;
		var imgPath = '<%=removeXSS(rdStempImgUrl,"filePathUrl")%>';
		var imgFile = '<%=removeXSS(rdStempImgFile,"fileName")%>';
		
		args["rdTitle"] = "원천징수부" ;//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+ rdFileNm; //( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[<%=removeXSS(session.getAttribute("ssnEnterCd"), "1")%>]" 
		                 +"["+$("#searchWorkYy").val()+"]"
		                 +"["+$("#searchAdjustType").val()+"]"
						 +"["+sabuns+"]"
						 +"[]"
						 +"["+bpCd+"]"
						 +"[<%=curSysYyyyMMdd%>]"
						 +"[4]"
						 +"["+sortSabuns+"]"
						 +"["+sortNos+"]"
						 +"["+printYmd+"]"
						 +"["+imgPath+"]"
						 +"["+imgFile+"]"
						 +"["+stamps+"]"
						 +"["+$("#searchPageLimit").val()+"]";//rd파라매터 --%>
						  
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
					<td colspan="3">
						<span>정산구분</span>
						<select id="searchAdjustType" name ="searchAdjustType" onChange="doAction1('Search')" class="box"></select> 
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
						<select id="searchPageLimit" name ="searchPageLimit" onChange="" class="box">
                            <option value="3" selected>3</option>
                            <option value="2" >2</option>
                            <option value="1" >1</option>
                        </select> &nbsp;Page까지
                        <a href="javascript:doAction1('Search')" id="btnSearch" class="button" style="margin-left:100px;">조회</a>
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
								<a href="javascript:print('print')" class="basic authA">출력</a>
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