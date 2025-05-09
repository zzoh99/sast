<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>원천징수부</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");%>
<script type="text/javascript">

	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
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

		var adjustTypeList 	= stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00303"), "전체");

		// 사업장(권한 구분)
		var ssnSearchType  = "<%=removeXSS(ssnSearchType,'1')%>";
		var bizPlaceCdList = "";

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

		$("#searchBusinessPlaceCd").html(bizPlaceCdList[2]);
		$("#searchAdjustType").html(adjustTypeList[2]).val("1");

		sheet1.SetColProperty("adjust_type", {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]});

		$(window).smartresize(sheetResize); sheetInit();
		
		//파일생성 사용 여부
		var fileCreYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_PDF_CRE_YN", "queryId=getSystemStdData",false).codeList;

		$("#btnDisplayYn").hide() ;
		if ( fileCreYn != null && fileCreYn.length>0) {
			if(fileCreYn[0].code_nm == "Y") {
				$("#btnDisplayYn").show() ;
			}
		}

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
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,CheckBoxOnValue:"Y",CheckBoxOffValue:"N",menuNm:$(document).find("title").text()};
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
		var sRow         = sheet1.FindCheckedRow("checked");
		var vsCheckArray = sRow.split("|");
		var vsRowCnt   = sheet1.RowCount();

		//출력체크된 로우 갯수 체크

		var sabuns = "";
		var sortSabuns = "";
		var sortNos = "";
		var stamps = "";
		var checked = "";
		var searchAllCheck = "";
		var sabunCnt = 0;
		var vsRowCnt   = sheet1.RowCount();

		if(vsCheckArray.length > 501){
			//출력체크된 로우 갯수 체크
			alert("최대 500개 까지 가능합니다. \n 다시 설정해주세요.");
			$("#searchPrintCheck").val("");
			$("#searchPrintCheck2").val("");
			$("#searchPrintCheck").focus();

			for(var i=1; vsRowCnt >= i; i++){

				sheet1.SetCellValue(i, "checked", "");

			}
			return;

		}
	        if(sheet1.RowCount() != 0) {
		        for(i=1; i<=sheet1.LastRow(); i++) {

		            checked = sheet1.GetCellValue(i, "checked");

		            if (checked == "1" || checked == "Y") {
		                sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
		                sortSabuns += sheet1.GetCellValue( i, "sabun" ) + ",";
		                sortNos += sheet1.GetCellValue( i, "sort_no" ) + ",";
		                if("1" == sheet1.GetCellValue( i, "stamp_chk" )) {
	                        stamps += sheet1.GetCellValue( i, "stamp_chk" ) + ",";
	                    } else {
	                        stamps += ",";
	                    }
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
		var imgPath = "<%=rdStempImgUrl%>";
		var imgFile = "<%=rdStempImgFile%>";

		args["rdTitle"] = "원천징수부" ;//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+ rdFileNm; //( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = "[<%=session.getAttribute("ssnEnterCd")%>]"
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
	
	//출력
	function print2(printGbn) {

		// 정산구분이 전체일 경우 출력불가
		var searchAdjustType = $("#searchAdjustType").val();

		if( searchAdjustType == "" ){
			alert("정산구분을 선택해주세요.");
			return;
		}
		var sRow         = sheet1.FindCheckedRow("checked");
		var vsCheckArray = sRow.split("|");
		var vsRowCnt   = sheet1.RowCount();

		//출력체크된 로우 갯수 체크

		var sabuns = "";
		var sortSabuns = "";
		var sortNos = "";
		var stamps = "";
		var checked = "";
		var searchAllCheck = "";
		var sabunCnt = 0;
		var vsRowCnt   = sheet1.RowCount();
		var sabun = "";
        var empName = "";
        var arrName = "";

		if(vsCheckArray.length > 501){
			//출력체크된 로우 갯수 체크
			alert("최대 500개 까지 가능합니다. \n 다시 설정해주세요.");
			$("#searchPrintCheck").val("");
			$("#searchPrintCheck2").val("");
			$("#searchPrintCheck").focus();

			for(var i=1; vsRowCnt >= i; i++){

				sheet1.SetCellValue(i, "checked", "");

			}
			return;

		}
	        if(sheet1.RowCount() != 0) {
		        for(i=1; i<=sheet1.LastRow(); i++) {

		            checked = sheet1.GetCellValue(i, "checked");

		            if (checked == "1" || checked == "Y") {
		                sabuns += "'"+sheet1.GetCellValue( i, "sabun" ) + "',";
		                arrName += "'"+sheet1.GetCellValue( i, "name" ) + "',";
		                sortSabuns += sheet1.GetCellValue( i, "sabun" ) + ",";
		                sortNos += sheet1.GetCellValue( i, "sort_no" ) + ",";
		                sabun = sheet1.GetCellValue( i, "sabun" ),
	                    empName = sheet1.GetCellValue( i, "name" ),
	                    sabunCnt++;
		                if("1" == sheet1.GetCellValue( i, "stamp_chk" )) {
	                        stamps += sheet1.GetCellValue( i, "stamp_chk" ) + ",";
	                    } else {
	                        stamps += ",";
	                    }
		            }
		        }

		        if (sabuns.length > 1) {
					sabuns = sabuns.substr(0,sabuns.length-1);
					arrName = arrName.substr(0,arrName.length-1);
					sortSabuns = sortSabuns.substr(0,sortSabuns.length-1);
					sortNos = sortNos.substr(0,sortNos.length-1);
					stamps = stamps.substr(0,stamps.length-1);
		        }

		        if (sabuns.length < 1) {
		            alert("선택된 사원이 없습니다.");
		            return;
		        }
				//call RD!
		        withHoldRcptBkStaDownPopup(sabuns, sortSabuns, sortNos, stamps, printGbn, sabun, empName, sabunCnt, arrName) ;
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
	function withHoldRcptBkStaDownPopup(sabuns, sortSabuns, sortNos, stamps, printGbn, sabun, empName, sabunCnt, arrName){
  		var w 		= 900;
		var h 		= 300;
		var url 	= "<%=jspPath%>/withHoldRcptBkSta/callRcptBkInvokerPop.jsp";
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
		var imgPath = "<%=rdStempImgUrl%>";
		var imgFile = "<%=rdStempImgFile%>";

		args["rdTitle"] = "원천징수부" ;//rd Popup제목
		args["rdMrd"] = "<%=cpnYearEndPath%>/"+ rdFileNm; //( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam1"] = "[<%=session.getAttribute("ssnEnterCd")%>]";
		args["rdParam2"] = "["+$("#searchWorkYy").val()+"]";
		args["rdParam3"] = "["+$("#searchAdjustType").val()+"]";
		args["rdParam4"] = "["+sabuns+"]";
		args["rdParam5"] = "[]";
		args["rdParam6"] = "["+bpCd+"]";
		args["rdParam7"] = "[<%=curSysYyyyMMdd%>]";
		args["rdParam8"] = "[4]";
		args["rdParam9"] = "["+sortSabuns+"]";
		args["rdParam10"] = "["+sortNos+"]";
		args["rdParam11"] = "["+printYmd+"]";
		args["rdParam12"] = "["+imgPath+"]";
		args["rdParam13"] = "["+imgFile+"]";
		args["rdParam14"] = "["+stamps+"]";
		args["rdParam15"] = "["+$("#searchPageLimit").val()+"]";//rd파라매터 --%>
		args["sabun"] = sabun;
        args["pSabuns"] = sabuns;
        args["empName"] = empName;
        args["sabunCnt"] = sabunCnt;
        args["rdFileNm"] = rdFileNm;
        args["arrName"] = arrName;
        args["searchWorkYy"] = $("#searchWorkYy").val();

		if(!isPopup()) {return;}
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창
		//if(rv!=null){
			//return code is empty
		//}
	}
	
	
	function doCheckOption(){

		var vnStartNum = $("#searchPrintCheck").val();
		var vnEndNum   = $("#searchPrintCheck2").val();
		var vsRowCnt   = sheet1.RowCount();
		var vsSetNumCnt= vnEndNum - vnStartNum;

		var vsSelect   = $("input[name=PrintCheck]:checked").val();
		var vsSelectVal= "Y";


		if(vsSelect == "stamp_chk"){

			vsSelectVal = "1";

		}

		if(vnStartNum == "" || vnStartNum == 0 || vnStartNum == null){

			alert("시작 값을 설정해주세요.");
			$("#searchPrintCheck").val("");
			$("#searchPrintCheck").focus();
			return;

		}

		if(vnEndNum == "" || vnEndNum == 0 || vnEndNum == null){
			vnEndNum = 500
		}


		if(vsSetNumCnt > 501){
			//출력체크할 ROW 갯수 체크
			alert("최대 500개 까지 가능합니다. \n 다시 설정해주세요.");
			$("#searchPrintCheck").val("");
			$("#searchPrintCheck2").val("");
			$("#searchPrintCheck").focus();
			return;
		}

		for(var i=1; vsRowCnt >= i; i++){

			if(vnStartNum <= i && vnEndNum >= i){

				if(sheet1.GetCellValue(i, vsSelect) == "Y" || sheet1.GetCellValue(i, vsSelect) == "1"){

					sheet1.SetCellValue(i, vsSelect, "");

				}else{

					sheet1.SetCellValue(i, vsSelect, vsSelectVal);

				}

			}

		}

	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="menuNm" name="menuNm" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>

					<td>
						<span>귀속</span>
						<%
						if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
						%>
							<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text w35 center" maxlength="4"/>
						<%}else{%>
							<input id="searchWorkYy" name ="searchWorkYy" type="text" class="text w35 center readonly" maxlength="4" readonly="readonly"/>
						<%}%>
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
                    <td>
                        <span>사업장</span>
                        <select id="searchBusinessPlaceCd" name ="searchBusinessPlaceCd" onChange="" class="box"></select>
                    </td>
					<td colspan="2">
						<span>부서명</span>
						<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text"/>
					</td>
				</tr>
				<tr>
					<td>
						<span>출력일자 </span>
						<input id="searchPrintYMD" name ="searchPrintYMD" type="text" class="date2" value="<%=curSysYyyyMMddHyphen%>"/>
					</td>
					<td colspan="2">
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
					</td>
				    <td>
                        <span>사번/성명</span>
                        <input id="searchSbNm" name ="searchSbNm" type="text" class="text w60"/>
                    </td>
				    <td>
                        <a href="javascript:doAction1('Search')" id="btnSearch" class="button" style="margin-left:10px;">조회</a>
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
							 	<span><strong>출력옵션&nbsp;:</strong>&nbsp;&nbsp;</span>
							  	<input name ="PrintCheck" type="radio" class="radio" value="checked" checked/>&nbsp;출력
							 	<input name ="PrintCheck" type="radio" class="radio" value="stamp_chk"/>&nbsp;도장
								<!-- <span>출력번호</span> -->
								<input id="searchPrintCheck" name ="searchPrintCheck" type="number" class="number" style = "width:30px;" value=""/>
								<span>~</span>
								<input id="searchPrintCheck2" name ="searchPrintCheck2" type="number" class="number" style = "width:30px;" value=""/>
								<a href="javascript:doCheckOption()" class="basic authA">선택</a>
								<a href="javascript:print('print')" class="basic btn-white ico-print authA">출력</a>
								<span id="btnDisplayYn">
                                <a href="javascript:print2('print')" class="basic btn-download authR">PDF파일다운</a>
                                </span>
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