<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>퇴직자정산계산</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	//급여계산중이거나, 급여계산취소 중이면 true
	var waitFlag    = false;
	var msg = "";
	
	$(function() {
		$("#searchWorkYy").val("<%=yeaYear%>") ;
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
   			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"마감여부",			Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_close_yn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
   			{Header:"No",			Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },    
   			{Header:"삭제",			Type:"<%=sDelTy%>",   Hidden:Number("<%=sDelHdn%>"),  Width:"<%=sDelWdt%>", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},    
   			{Header:"상태",			Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},    
			{Header:"총인원",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"t_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"대상인원",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"all_811_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"작업대상인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"p_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"작업완료인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"j_cnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"마감인원",			Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_y_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"미마감인원",		Type:"Int",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"final_n_cnt",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("<%=editable%>");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
	
		$(window).smartresize(sheetResize);
		sheetInit();

		getYeaPayActionInfo() ;//연말정산 payActionCd,Nm 가져옴
	});
	
	function doAction1(sAction) {
		switch (sAction) {
	    case "Search":      
	    	sheet1.DoSearch( "<%=jspPath%>/yeaCalcRetire/yeaCalcRetireRst.jsp?cmd=selectYeaCalcRetireSheet1List", $("#sheetForm").serialize() );
	    	break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
	    case "Search":      
	    	sheet2.DoSearch( "<%=jspPath%>/yeaCalcRetire/yeaCalcRetireRst.jsp?cmd=selectYeaCalcRetireSheet2List", $("#sheetForm").serialize() );
	    	break;
		}
	}
		
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				setCloseImg();
			}
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if(Code == 1) {
				setPeopleStatusCnt();
			}
		} catch (ex) { 
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	
	//쉬트 조회
	function sheetSearch() {
		doAction1("Search");
		doAction2("Search");
	}
	
	//최근급여일자 조회
	function getYeaPayActionInfo() {
		
		var paymentInfo = ajaxCall("<%=jspPath%>/yeaCalcRetire/yeaCalcRetireRst.jsp?cmd=selectYeaPayActionInfo", "searchYear="+$("#searchWorkYy").val(), false);

		$("#searchPayActionCd").val(nvl(paymentInfo.Data.pay_action_cd,""));
		$("#searchPayActionNm").val(nvl(paymentInfo.Data.pay_action_nm,""));
		$("#searchWorkYy").val(nvl(paymentInfo.Data.pay_yy,"")) ;
		$("#payYM").val(nvl(paymentInfo.Data.pay_ym,"")) ;
		$("#ordYmd").val(nvl(paymentInfo.Data.ord_ymd,"")) ;
		
		sheetSearch() ;
	}
	
	//마감 체크
	function checkClose(){
		if(sheet1.GetCellValue(1, 'final_close_yn') == "Y") {
			alert("이미 마감되었습니다.");
			return true;
		} else {
			return false;
		}
	}

	//연말정산항목이 존재 확인
	function checkPayActionCd(){
		if($("#searchPayActionCd").val() == ""){
			alert("작업일자가 존재하지 않습니다.");
			return false;
		} else {
			return true;
		}
	}
	
	//연말정산 마감여부 체크
	function setCloseImg(){
		if(sheet1.GetCellValue(1, 'final_close_yn') == "Y") {
			$(':checkbox[name=calcuFinishedImg]').attr('checked', true);
		} else{
			$(':checkbox[name=calcuFinishedImg]').attr('checked', false);
		}	
	}

	//대상 정보
	function setPeopleStatusCnt() {
		$("#peopleTotalCnt").html(sheet2.GetCellText(1, "t_cnt")) ;
		$("#people811Cnt").html(sheet2.GetCellText(1, "all_811_cnt")) ;
		$("#peoplePCnt").html(sheet2.GetCellText(1, "p_cnt")) ;
		$("#peopleJCnt").html(sheet2.GetCellText(1, "j_cnt")) ;
		$("#finalCloseYCnt").html(sheet2.GetCellText(1, "final_y_cnt")) ;
		$("#finalCloseNCnt").html(sheet2.GetCellText(1, "final_n_cnt")) ;
	}
	
	var pGubun = "";
	
	//급여일자 검색 팝입
	function payActionSearchPopup() {
		if(waitFlag) return;

		if(!isPopup()) {return;}
		pGubun = "yeaCalcRetirePayDayViewPopup";
		
		var args = new Array();
		
		var result = openPopup("<%=jspPath%>/yeaCalcRetire/yeaCalcRetirePayDayViewPopup.jsp?authPg=<%=authPg%>",args,"900","580");
		/*
		if (result) {
			$("#searchPayActionCd").val(result["payActionCd"]);
			$("#searchPayActionNm").val(result["payActionNm"]);
			$("#searchWorkYy").val(result["payYm"].substring(0,4)) ;
			$("#payYM").val(result["payYm"].substring(0,4) + "-" + result["payYm"].substring(4,6)) ;
			$("#ordYmd").val(result["ordSymd"].substring(0,4) +"-"+result["ordSymd"].substring(4,6)+"-"+result["ordSymd"].substring(6,8) + " ~ " + result["ordEymd"].substring(0,4) +"-"+result["ordEymd"].substring(4,6)+"-"+result["ordEymd"].substring(6,8)) ;
			sheetSearch() ;
		}
		*/
	}
	
	function getReturnValue(returnValue) {

		var result = $.parseJSON('{'+ returnValue+'}');

		if ( pGubun == "yeaCalcRetirePayDayViewPopup" ){			
			$("#searchPayActionCd").val(result["payActionCd"]);
			$("#searchPayActionNm").val(result["payActionNm"]);
			$("#searchWorkYy").val(result["payYm"].substring(0,4)) ;
			$("#payYM").val(result["payYm"].substring(0,4) + "-" + result["payYm"].substring(4,6)) ;
			$("#ordYmd").val(result["ordSymd"].substring(0,4) +"-"+result["ordSymd"].substring(4,6)+"-"+result["ordSymd"].substring(6,8) + " ~ " + result["ordEymd"].substring(0,4) +"-"+result["ordEymd"].substring(4,6)+"-"+result["ordEymd"].substring(6,8)) ;
			sheetSearch() ;
		} else if ( pGubun == "yeaCalcCrePeoplePopup" ){
			sheetSearch();
		} else if ( pGubun == "yeaCalcCreRePeoplePopup" ){
			sheetSearch();
		} else if ( pGubun == "yeaCalcCreOptionPopup" ){
			sheetSearch();
		}
	}
	
	//작업일자 정의 팝업
	function openRetireSet() {
		if(waitFlag) return;

		var args = new Array();
		
		if(!isPopup()) {return;}
		openPopup("<%=jspPath%>/yeaCalcRetire/yeaCalcRetirePayDayPopup.jsp?authPg=<%=authPg%>",args,"900","580");
	}

	//대상자 기준 팝업
	function openPeopleSet(){
		
		if(waitFlag) return;
	
		if(checkPayActionCd()){
			var args 	= new Array();
			args["searchWorkYy"]		= $("#searchWorkYy").val() ;
			args["searchPayActionNm"]	= $("#searchPayActionNm").val() ;
			args["searchPayActionCd"]	= $("#searchPayActionCd").val() ;
			args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)
			
			if(!isPopup()) {return;}
			pGubun = "yeaCalcCrePeoplePopup";
			var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCrePeoplePopup.jsp?authPg=<%=authPg%>",args,"900","580");
			//sheetSearch();
		}
	}
	
	//재계산 대상자 작업 팝업
	function openYEACalRetry() {
		if(waitFlag) return;
	
		if(checkPayActionCd()){
			var args 	= new Array();
			args["searchWorkYy"]		= $("#searchWorkYy").val() ;
			args["searchPayActionNm"]	= $("#searchPayActionNm").val() ;
			args["searchPayActionCd"]	= $("#searchPayActionCd").val() ;
			args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)
			
			if(!isPopup()) {return;}
			pGubun = "yeaCalcCreRePeoplePopup";
			var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCreRePeoplePopup.jsp?authPg=<%=authPg%>",args,"900","580");
			//sheetSearch() ;
		}	
	}
	
	//옵션설정
	function optPop(){
		var args 	= new Array();
		args["searchWorkYy"]		= $("#searchWorkYy").val() ;
		args["searchPayActionNm"]	= $("#searchPayActionNm").val() ;
		args["searchPayActionCd"]	= $("#searchPayActionCd").val() ;
		args["searchAdjustType"]	= $("#searchAdjustType").val() ;//1 - 연말정산(3은 퇴직)
		
		if(!isPopup()) {return;}
		pGubun = "yeaCalcCreOptionPopup";
		var rv = openPopup("<%=jspPath%>/yeaCalcCre/yeaCalcCreOptionPopup.jsp?authPg=<%=authPg%>",args,"800","750");
		//sheetSearch() ;
	}

	//퇴직자정산 작업
	function doJob(){
	
		if(waitFlag) return;
		if(checkClose()) return;
		
		payFlag = "TRUE";
		taxFlag = "TRUE";
		msg		= "";
		
		if(!$("#payMonChk").is(":checked")){
			if(!$("#taxMonChk").is(":checked")){
				alert("작업을 선택해주세요.");				
				return;
			} else {
				msg = "퇴직정산계산";
				payFlag = "FALSE";
				taxFlag = "TRUE";
			}
		} else {
			msg = "총급여합산";
			if(!$("#taxMonChk").is(":checked")){
				payFlag = "TRUE";
				taxFlag = "FALSE";
	
			} else {
				msg =  "총급여합산,퇴직정산계산";
				payFlag = "TRUE";
				taxFlag = "TRUE";
			}
		}
		
		if(checkPayActionCd()){
			if($("#peoplePCnt").html() == "0"){
				alert("대상인원이 없습니다.");
				return;
			}
			if(confirm($("#searchWorkYy").val()+" 년 "+msg+"을 시작하시겠습니까?")){
				if(taxFlag == "TRUE" && payFlag == "TRUE") {
		   	    	ajaxCall("<%=jspPath%>/yeaCalcRetire/yeaCalcRetireRst.jsp?cmd=prcYearEndMonPayAndTax",$("#sheetForm").serialize()
		   	    			,true
		   	    			,function(){
								waitFlag = true;
								$("#progressCover").show();
		   	    			}
		   	    			,function(){
								waitFlag = false;
								$("#progressCover").hide();
								doAction2('Search');
		   	    			}
		   	    	);					
				} else {
					if(payFlag == "TRUE") {
			   	    	ajaxCall("<%=jspPath%>/yeaCalcRetire/yeaCalcRetireRst.jsp?cmd=prcYearEndMonPay",$("#sheetForm").serialize()
			   	    			,true
			   	    			,function(){
									waitFlag = true;
									$("#progressCover").show();
			   	    			}
			   	    			,function(){
									waitFlag = false;
									$("#progressCover").hide();
									doAction2('Search');
			   	    			}
			   	    	);
					}
					if(taxFlag == "TRUE") {
			   	    	ajaxCall("<%=jspPath%>/yeaCalcRetire/yeaCalcRetireRst.jsp?cmd=prcYearEndTax",$("#sheetForm").serialize()
			   	    			,true
			   	    			,function(){
									waitFlag = true;
									$("#progressCover").show();
			   	    			}
			   	    			,function(){
									waitFlag = false ;
									$("#progressCover").hide();
									doAction2('Search');
			   	    			}
			   	    	);
					}
				}	
			}
		}
	}
	
	//퇴직자정산 작업 취소
	function cancelJob(){
	
		if(waitFlag) return;
		
		if( $("#peopleJCnt").html()*1 <= 0){
			alert("작업완료 인원이 존재하지 않습니다.") ;
			return;
		}
	
		if(checkPayActionCd()){
			if(confirm("퇴직정산계산취소를 시작하시겠습니까?")){
				waitFlag = true;
				ajaxCall("<%=jspPath%>/yeaCalcRetire/yeaCalcRetireRst.jsp?cmd=prcYearEndCenCel",$("#sheetForm").serialize(),false);
	   	    	waitFlag = false ;
	   	    	doAction2('Search') ;
			}
		}
	}
	
	//마감
	function finishAll(){
	
		if(waitFlag) return;
		if(checkClose()) return;
		
		if($("#people811Cnt").html()*1 == 0){
			alert("대상인원이 존재하지 않습니다.\n마감할 수 없습니다.");
			return;
		}
	
		if($("#people811Cnt").html() != $("#peopleJCnt").html()){
			alert("대상인원과 작업완료인원이 일치하지 않습니다.\n마감할 수 없습니다.");
			return;
		}
	
		if(checkPayActionCd()){
			var params = $("#sheetForm").serialize()+"&searchFinalCloseYN=Y";
			//TCPN811 & TCPN983 UPDATE! 
			ajaxCall("<%=jspPath%>/yeaCalcRetire/yeaCalcRetireRst.jsp?cmd=saveFinalCloseYn",params,false);
			
			sheetSearch();
		}
	}
	
	//마감취소
	function cancelAll(){
		
		if(waitFlag) return;
		if(checkPayActionCd()){
	
			//if(sheet1.GetCellValue(1, 'final_close_yn') != "Y"){
			//	alert("마감되지않은 퇴직정산계산작업입니다.");
			//	return;
			//}		
			
			var params = $("#sheetForm").serialize()+"&searchFinalCloseYN=N";
			//TCPN811 & TCPN983 UPDATE! 
			ajaxCall("<%=jspPath%>/yeaCalcRetire/yeaCalcRetireRst.jsp?cmd=saveFinalCloseYn",params,false);
			
			sheetSearch();
		}
	
	}

</script>
</head>
<body class="hidden">
<div id="progressCover" style="display:none;position:absolute;top:0;bottom:0;left:0;right:0;background:url(<%=imagePath%>/common/process.png) no-repeat 50% 50%;"></div>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
		<input type="hidden" id="searchAdjustType" name="searchAdjustType" value="3" />
		<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="">
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="60%" />
			<col width="1%" />
			<col width="39%" />
		</colgroup>
		<tr>
			<td class="top center">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">작업진행순서</li>
					</ul>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default">
					<colgroup>
						<col width="20%" />
						<col width="25%" />
						<col width="20%" />
						<col width="" />
					</colgroup>
					<tr>
						<th class="left" > 작업일자 </th>
						<td class="left" colspan="3"> 
							<input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text w200 readonly transparent" value="" readonly/>
							<a onclick="javascript:payActionSearchPopup();" href="#" class="button6"><img src="<%=imagePath%>/common/btn_search2.gif"/></a> 
						</td>
					</tr>
					<tr>
						<th class="left"> 대상년월 </th>
						<td class="left"> 
							<input type="text" id="payYM" name="payYM" class="text center transparent readonly" value="" readonly />
						</td>
						<th class="left"> 발령기준일 </th>
						<td class="left"> 
							<input type="text" id="ordYmd" name="ordYmd" class="text w100p center transparent readonly" value="" readonly />
						</td>
					</tr>
					<tr>
						<td colspan="4" class="center">
				            <span id="chkTmp1">
			                	<input type="checkbox" class="checkbox" id="payMonChk" name="payMonChk" value="" style="vertical-align:middle;">
				            </span> 
				            총급여합산  
				            <span id="chkTmp2">
				                <input type="checkbox" class="checkbox" id="taxMonChk" name="taxMonChk" value="" style="vertical-align:middle;">
				            </span> 
				            세금계산
							<a href="javascript:doJob();"		class="basic authA">작업</a>
							<a href="javascript:cancelJob();"	class="basic authA">작업취소</a>
						</td>
					</tr>
					<tr>
						<th>총인원</th>
						<td id="peopleTotalCnt" class="right"> </td>
						<th>대상인원</th>
						<td id="people811Cnt" class="right"> </td>
					<tr>
						<th>작업대상인원</th>
						<td id="peoplePCnt" class="right"> </td>
						<th>작업완료인원</th>
						<td id="peopleJCnt" class="right"> </td>
					</tr>
					<tr>
						<th>미마감인원</th>
						<td id="finalCloseNCnt" class="right"> </td>
						<th>마감인원</th>
						<td id="finalCloseYCnt" class="right"> </td>
					</tr>
					<tr>
						<th colspan="4" class="center">퇴직정산 마감여부
							<input type="checkbox" class="checkbox" id="calcuFinishedImg" name="calcuFinishedImg" style="vertical-align:middle;" disabled>
						</th>
					</tr>
					<tr>
						<td colspan="4" class="center">
							<a href="javascript:finishAll();"	class="basic authA">마감</a>
							<a href="javascript:cancelAll();"	class="basic authA">마감취소</a></td>
					</tr>
				</table>
				<div class="outer">
					<ul>
						<li id="txt" class="txt"> </li>
						<li class="btn">
							<a href="javascript:openRetireSet();"		class="basic large">작업일자정의</a>
							<a href="javascript:openPeopleSet();"		class="basic large">대상자기준</a>
							<a href="javascript:openYEACalRetry();"		class="basic large">재계산대상자작업</a>
							<a href="javascript:optPop();"				class="basic large">연말정산옵션</a>
						</li>
					</ul>
				</div>
			</td>
			<td>
			</td>
			<td class="top">
				<div class="h25"></div>
				<div class="explain">
					<div class="title">작업설명</div>
					<div class="txt">
						<ul>
							<li>1. 작업일자정의에서 작업대상년월의 일자를 정의합니다.</li>
					        <li>2. 대상자기준에서 대상자를 등록</li>
					        <li style="padding-left:13px;">작업할 대상자를 선택 저장합니다.</li>
					
					        <li>3. 총급여합산, 세금계산을 체크하여 [작업]을 실행합니다.</li>
					        <li style="padding-left:13px;">총급여합산 : 총급여내역을 가져오며 연급여내역관리에서</li>
					        <li style="padding-left:76px;">확인 및 수정을 하실 수 있습니다.</li>
					
					        <li style="padding-left:13px;">세금계산 : 근로소득세액을 세법에 따라 계산하여</li>
					        <li style="padding-left:63px;"> 기납부세액과의 차감세액을 산출합니다.</li>
					
					        <li>4. 작업이 종료되며는 [마감] 버튼을 클릭하여 마감처리</li>
					        <li>5.  마감후 재작업을 하시려면 [마감취소] 버튼을 눌러</li>
					        <li style="padding-left:13px;">취소 처리후 작업을 하실 수 있습니다.</li>
						</ul>
					</div>
				</div>
			</td>
		</tr>
	</table>
	<span class="hide">
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100px"); </script>
		<script type="text/javascript">createIBSheet("sheet2", "100%", "100px"); </script>
	</span>
</div>
</body>
</html>