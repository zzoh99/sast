<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<title>후임자관리 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<c:set var="readonly" value="" />
<c:set var="disabled" value="" />
<c:if test="${authPg ne 'A'}">
	<c:set var="readonly" value="readonly" />
	<c:set var="disabled" value="disabled" />
</c:if>
<style type="text/css">
	.popup_content {
		padding: 20px;
	}
	
	#incomDiv {
		overflow-y: auto;
		overflow-x: hidden;
		height: 98%;
	}
	
	.area_evalResult {
		display: flex;
		justify-content: center;
		align-items: start;
		height: 50px;
		border-radius: 6px;
		background-color: #fafafa;
		margin-bottom: 10px;
		padding: 15px 20px;
	}
	.area_evalResult .evalResultDiv {
		display: flex;
		justify-content: center;
		align-items: center;
		width: calc(100% - 700px);
		height: 50px;
		font-size: 14px;
		font-weight: 600;
	}
	.area_evalResult .area_evalGuide {
		width: 700px;
		height: 50px;
		margin-left: 30px;
	}
	.area_evalResult .area_evalGuide .top span {
		display: inline-block;
		text-align: center;
		width: 40px;
		margin-left: 80px;
	}
	.area_evalResult .area_evalGuide .top span:first-child {
		width: 20px;
		text-align: left;
		margin-left: -3px;
	}
	.area_evalResult .area_evalGuide .mid span {
		display: inline-block;
		width: 120px;
		height: 10px;
		background-color: #eaeaea;
		border-right: 2px #666 solid;
		margin-left: -2px;
	}
	.area_evalResult .area_evalGuide .mid span:first-child {
		margin-left: 0px;
	}
	.area_evalResult .area_evalGuide .bottom {
		position: relative;
	}
	.area_evalResult .area_evalGuide .bottom span.markSpan {
		position: absolute;
		left: 0px;
		width: 20px;
		color: red;
		margin-left: -10px;
		text-align: center;
	}
</style>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	var authPg = "${authPg}";
	var curSysYear = parseInt("${curSysYear}");
	
	$(function(){
		
		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
		
		var arg 		= p.popDialogArgumentAll();
		var enterCd		= arg["enterCd"];
		var pSabun 		= arg["sabun"];
		var pIncomId 	= arg["incomId"];
		var pIncomSeq 	= arg["incomSeq"];
		
		$("#pSabun").val(pSabun);
		$("#pIncomId").val(pIncomId);
		$("#pIncomSeq").val(pIncomSeq);
	
		$("#userFace").attr("src","/EmpPhotoOut.do?enterCd="+enterCd+"&searchKeyword="+pIncomId+"&t=" + (new Date()).getTime());
		var userFace_height = $("#userFace").width() + ($("#userFace").width() * 0.3);
		$("#userFace").height(userFace_height + "px");	
		
		// 그룹코드 조회
		var grpCds = "CD1040,CD1041";
 		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "선택");
		
		$("#incomOut").html(codeLists["CD1040"][2]);
		$("#incomImpact").html(codeLists["CD1041"][2]);
		
		init_sheet1(); // 발령사항
		init_sheet2(); // 경력사항
		//init_sheet3(); // 평가결과
		
		doAction1("Search"); // 발령사항
		doAction2("Search"); // 경력사항
		//doAction3("Search"); // 평가결과
		doAction4("Search"); // 기본사항
		doAction5("Search"); // 평판
		
	});
	
	function init_sheet1() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:7};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"발령",		Type:"Combo",	Hidden:0,	Width:110,	Align:"Left",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령일자",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"부서",		Type:"Text",	Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var userCd1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList",false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//발령종류
		sheet1.SetColProperty("ordDetailCd",	{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function init_sheet2() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"입사일",		Type:"Date",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"sdate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"퇴사일",		Type:"Date",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"edate",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"근무처",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"cmpNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"근무년월수",	Type:"Text",      	Hidden:0,  Width:100,    Align:"Center",  ColMerge:0,   SaveName:"carrerYm",	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"담당업무",		Type:"Text",      	Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"jobNm",		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	function init_sheet3() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"9년전",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year9",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"8년전",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year8",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"7년전",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year7",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"6년전",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year6",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"5년전",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year5",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"4년전",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year4",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"3년전",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year3",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"2년전",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"1년전",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year1",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"당해년도",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"year0",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평균점수",		Type:"Float",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"avgEvalScore",KeyField:0,	Format:"Float",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 }
		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable(false);sheet3.SetVisible(true);sheet3.SetCountPosition(0);
		
		for(var i = 0; i <= 9; i++) {
			sheet3.SetCellText(0, "year" + i, (curSysYear-i));
		}
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			// 성과평점 값 세팅
			var avgEvalScore = sheet3.GetCellValue(1, "avgEvalScore");
			avgEvalScore = (avgEvalScore == -1) ? 0 : avgEvalScore;
			$("#avgEvalScore").text(avgEvalScore);
			
			// 성과평점 위치 표시하기
			markAvgScore(avgEvalScore);
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//성과평점 위치 표시하기
	function markAvgScore(avgEvalScore) {
		var score_left = 0;
		score_left += ((avgEvalScore) * 120) + (avgEvalScore * 2);
		$(".markSpan").css("left", score_left+"px");
	}
	
	// 발령사항 doAction
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var param = "sabun="+$("#pIncomId").val()+"&mainYn=Y";
				sheet1.DoSearch( "${ctx}/PsnalPost.do?cmd=getPsnalPostList", param );
				break;
		}
	}
	
	// 경력사항 doAction
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				var param = "sabun="+$("#pIncomId").val();
				sheet2.DoSearch( "${ctx}/PsnalCareer.do?cmd=getPsnalCareerList", param );
				break;
		}
	}
	
	// 평가결과 doAction
	function doAction3(sAction) {
		switch (sAction) {
			case "Search":
				var param = "pIncomId="+$("#pIncomId").val()+"&curSysYear="+curSysYear;
				sheet3.DoSearch( "${ctx}/IncomingMgr.do?cmd=getIncomingMgrPopupEvalResultList", param );
				break;
		}
	}
	
	// 기본사항 doAction
	function doAction4(sAction) {
		switch (sAction) {
			case "Search":
				// 입력 폼 값 셋팅
				var hrInfo = ajaxCall( "${ctx}/IncomingMgr.do?cmd=getIncomingMgrPopupHrInfoMap",$("#dataForm").serialize(),false);
				var schList = ajaxCall( "${ctx}/IncomingMgr.do?cmd=getIncomingMgrPopupHrInfoSchList",$("#dataForm").serialize(),false);
				
				// 인사정보 세팅
				if( hrInfo.map != null && hrInfo.map.length != 0){
					$("#name").text(hrInfo.map.name);
					$("#sabun").text(hrInfo.map.sabun);
					$("#empYmd").text(hrInfo.map.empYmd);
					$("#empYmd").text(hrInfo.map.empYmd);
					$("#workTerm").text(hrInfo.map.workTerm);
					$("#birYmd").text(hrInfo.map.birYmd);
					$("#jikgubNm").text(hrInfo.map.jikgubNm);
					$("#orgNm").text(hrInfo.map.orgNm);
					$("#stfTypeNm").text(hrInfo.map.stfTypeNm);
					$("#empTypeNm").text(hrInfo.map.empTypeNm);
					$("#acaDegNm").text(hrInfo.map.acaDegNm);
				}
				
				// 학력사항 세팅
				var schNm = "";
				for(var i=0; i<schList.DATA.length; i++) {
					schNm += schList.DATA[i].schNm + "<br>";
				}
				$("#schNm").html(schNm);
				
				break;
		}
	}
	
	// 평판 doAction
	function doAction5(sAction) {
		switch (sAction) {
			case "Search":
				// 입력 폼 값 셋팅
				var data = ajaxCall( "${ctx}/IncomingMgr.do?cmd=getIncomingMgrPopupReputationMap",$("#dataForm").serialize(),false);
				if( data.map != null && data.map.length != 0){
					$("#pIncomId").val(data.map.incomId);
					$("#incomTime").val(data.map.incomTime);
					$("#incomPath").val(data.map.incomPath);
					$("#incomOut").val(data.map.incomOut);
					$("#incomImpact").val(data.map.incomImpact);
					$("#incomRsn").val(data.map.incomRsn);
					$("#incomPros").val(data.map.incomPros);
					$("#incomCons").val(data.map.incomCons);
				}
				break;
			case "Save":
				var rv = ajaxCall( "${ctx}/IncomingMgr.do?cmd=saveIncomingMgrPopup",$("#dataForm").serialize(),false);
				if( rv && rv != null ) {
					alert(rv.Result.Message);
					doAction5("Search");
				}
				break;
		}
	}
	
	function setValue() {
		var rv = new Array();
		p.popReturnValue(rv);
		p.window.close();
	}
	
	//출력
	function print() {
		if(!isPopup()) {return;}
	
		// 파라미터 설정
		var enterCd;	// 그룹코드명
		var pSabun = '';
		var pIncomId  = '';
		var pIncomSeq  = '';
		var rdZoomRatio = 100;
		var rdParam = "";
		
		// 파라미터 가공
		pSabun  	 += "'" + $("#pSabun").val() + "'";
		pIncomId  	 += "'" + $("#pIncomId").val() + "'";
		pIncomSeq  	 += "'" + $("#pIncomSeq").val() + "'";
		
		rdParam += "['${ssnEnterCd}'] [" + pSabun + "] [" + pIncomId + "] [" + pIncomSeq + "] [${baseURL}]" ;
		
		var w 		= 900;
		var h 		= 750;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음
		
		args["rdTitle"] = "후임자 세부내역" ;//rd Popup제목
		args["rdMrd"] = "hrd/incoming/IncomingMgr.mrd" ;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] = rdParam;
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
	
		openPopup(url,args,w,h);//알디출력을 위한 팝업창
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper" id="incomDiv">
	<div class="popup_title">
		<ul>
			<li>후임자관리 세부내역</li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_content">
	
		<form name="dataForm" id="dataForm" method="post">
			<input type="hidden" id="pSabun" 		name="pSabun" 		value=""/> <!-- 부모창에서 넘어온 사번 -->		
			<input type="hidden" id="pIncomSeq"		name="pIncomSeq" 	value=""/> <!-- 부모창에서 넘어온 후보자순번 -->
			<input type="hidden" id="pIncomId" 		name="pIncomId" 	value=""/> <!-- 부모창에서 넘어온 후보자사번 -->
			
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt">기본사항</li>
						<li class="btn"><a href="javascript:print();" class="button">출력</a></li>
					</ul>
				</div>
			</div>
			
			<table border="0" cellpadding="0" cellspacing="0" class="default inner">
				<colgroup>
					<col width="14%" />
					<col width="13%" />
					<col width="30%" />
					<col width="13%" />
					<col width="*" />
				</colgroup>
				<tr>
					<td rowspan="5">
						<img src="/common/images/common/img_photo.gif" alt="대표사진" id="userFace" style="width: 100%;height: 100%;">
					</td>
					<th>성명</th>
					<td>
						<span id="name"></span>
					</td>
					<th>사번</th>
					<td>
						<span id="sabun"></span>
					</td>
				</tr>
				<tr>
					<th>입사일</th>
					<td>
						<span id="empYmd"></span>
					</td>
					<th>근속년수</th>
					<td>
						<span id="workTerm"></span>
					</td>
				</tr>
				<tr>
					<th>생년월일</th>
					<td>
						<span id="birYmd"></span>
					</td>
					<th>직급</th>
					<td>
						<span id="jikgubNm"></span>
					</td>
				</tr>
				<tr>
					<th>부서</th>
					<td>
						<span id="orgNm"></span>
					</td>
					<th>채용/입사구분</th>
					<td>
						<span id="stfTypeNm"></span> 
						/
						<span id="empTypeNm"></span> 
					</td>
				</tr>
				<tr>
					<th>최종학력</th>
					<td>
						<span id="acaDegNm"></span>
					</td>
					<th>학력사항</th>
					<td>
						<span id="schNm"></span>
					</td>
				</tr>
			</table>
			
			<table border="0" cellpadding="0" cellspacing="0" class="sheet_main inner mat10">
				<colgroup>
					<col width="50%" />
					<col width="50%" />
				</colgroup>
				<tr>
					<td class="sheet_left">
						<div class="inner">
							<div class="sheet_title">
							<ul>
								<li class="txt">발령사항</li>
							</ul>
							</div>
						</div>
						<script type="text/javascript"> createIBSheet("sheet1", "100%", "250px", "${ssnLocaleCd}"); </script>
					</td>
					<td class="sheet_right">
						<div class="inner">
							<div class="sheet_title">
							<ul>
								<li class="txt">경력사항</li>
							</ul>
							</div>
						</div>
						<script type="text/javascript"> createIBSheet("sheet2", "100%", "250px", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
			
<%-- 평가 체계가 달라 사용하지 않음
			<div class="inner mat10">
				<div class="sheet_title">
					<ul>
						<li class="txt">평가결과</li>
					</ul>
				</div>
			</div>
			
			<div class="area_evalResult inner">
				<div class="evalResultDiv">
					<span>성과평점&nbsp;:&nbsp;</span>
					<span id="avgEvalScore" class="f_point f_s18"></span>
				</div>
				<div class="area_evalGuide">
					<div class="top">
						<span>0</span>
						<span>D(1)</span>
						<span>C(2)</span>
						<span>B(3)</span>
						<span>A(4)</span>
						<span>S(5)</span>
					</div>
					<div class="mid">
						<span></span>
						<span></span>
						<span></span>
						<span></span>
						<span></span>
					</div>
					<div class="bottom">
						<span class="markSpan">▲</span>
					</div>
				</div>
			</div>
			
			<div>
				<script type="text/javascript"> createIBSheet("sheet3", "100%", "120px", "${ssnLocaleCd}"); </script>
			</div>
--%>
			
			<div class="inner mat10">
				<div class="sheet_title">
					<ul>
						<li class="txt">평판</li>
						<li class="btn">
							<a href="javascript:doAction5('Save');" class="button authA" >저장</a>
							<a href="javascript:doAction5('Search');" class="basic authA" >조회</a>
						</li>
					</ul>
				</div>
			</div>
			<table border="0" cellpadding="0" cellspacing="0" class="default incomTable inner">
				<colgroup>
					<col width="10%" />
					<col width="15%" />
					<col width="25%" />
					<col width="25%" />
					<col width="*" />
				</colgroup>
				<tr>
					<th colspan="2" class="center">항목</th>
					<th class="center">선정사유(구체적으로)</th>
					<th class="center">장점</th>
					<th class="center">보완점</th>
				</tr>
				<tr>
					<th>승계소요시간</th>
					<td>
						<input type="text" id="incomTime" name="incomTime" placeholder="즉시 / OO년 이내" class="text w100p" ${readonly}>
					</td>
					<td rowspan="4">
						<textarea id="incomRsn" name="incomRsn" rows="10" class="w100p" ${readonly}></textarea>
					</td>
					<td rowspan="4">
						<textarea id="incomPros" name="incomPros" rows="10" class="w100p" ${readonly}></textarea>
					</td>
					<td rowspan="4">
						<textarea id="incomCons" name="incomCons" rows="10" class="w100p" ${readonly}></textarea>
					</td>
				</tr>
				<tr>
					<th>경력개발경로</th>
					<td>
						<input type="text" id="incomPath" name="incomPath" placeholder="OO 직무경험 필요" class="text w100p" ${readonly}>
					</td>
				</tr>
				<tr>	
					<th>이탈가능성</th>
					<td>
						<select id="incomOut" name="incomOut" class="w100p" ${disabled}></select>
					</td>
				</tr>
				<tr>	
					<th>이탈시 조직의<br>영향 정도</th>
					<td>
						<select id="incomImpact" name="incomImpact" class="w100p" ${disabled}></select>
					</td>
				</tr>
			</table>
		</form>
		
		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid='close' mdef="닫기"/>
				</li>
			</ul>
		</div>
	
	</div>
	
</div>

</body>
</html>