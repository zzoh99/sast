<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>직무분장보고 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

var searchApplSeq    = "${searchApplSeq}";
var adminYn          = "${adminYn}";
var authPg           = "${authPg}";
var searchApplSabun  = "${searchApplSabun}";
var searchApplInSabun= "${searchApplInSabun}";
var searchApplYmd    = "${searchApplYmd}";
// var applseq1		 = "${etc01}";
// var jobApplSeq		 = "${etc02}";

var etc01	 = "${etc01}";
var etc02	 = "${etc02}";

var applStatusCd	 = "";
var applYn	         = "";
var pGubun           = "";
var adminRecevYn     = "N"; //수신자 여부

	$(function() {
		
		parent.iframeOnLoad(300);
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7};	// ColMerge=1 하면 merge 됨
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1	,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
			{Header:"<sht:txt mid='ibsImageV3' mdef='세부내역' />",		Type:"Image",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:1,	SaveName:"detail",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },

			{Header:"<sht:txt mid='name' 		  mdef='성명' />",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='mainJobCd' mdef='대표직무'/>",		Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:1,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='jobCd' mdef='직무'/>",			Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='applyYy' mdef='적용일'/>",		Type:"Date",	Hidden:0, 	Width:20,	Align:"Center", ColMerge:0, SaveName:"applyYmd",	Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='lastUdtDate' mdef='최종갱신일'/>",	Type:"Date",	Hidden:0, 	Width:20,	Align:"Center", ColMerge:0, SaveName:"applYmd",		Format:"Ymd",	Edit:0 },

			{Header:"Hidden",			Type:"Text",   		Hidden:1, SaveName:"sabun"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"orgCd"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"searchApplSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"jobApplSeq"}

			]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
  		
  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetDataLinkMouse("detail",1);
 		
 		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:7};	// ColMerge=1 하면 merge 됨
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:0	,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
			{Header:"<sht:txt mid='ibsImageV3' mdef='세부내역' />",		Type:"Image",		Hidden:0,	Width:10,	Align:"Center",	ColMerge:1,	SaveName:"detail",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },

			{Header:"<sht:txt mid='name' 		  mdef='성명' />",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",	Hidden:0,	Width:20,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='mainJobCd' mdef='대표직무'/>",		Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:1,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='jobCd' mdef='직무'/>",			Type:"Combo",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='applyYy' mdef='적용일'/>",		Type:"Date",	Hidden:0, 	Width:20,	Align:"Center", ColMerge:0, SaveName:"applyYmd",	Format:"Ymd",	Edit:0 },
			{Header:"<sht:txt mid='lastUdtDate' mdef='최종갱신일'/>",	Type:"Date",	Hidden:0, 	Width:20,	Align:"Center", ColMerge:0, SaveName:"applYmd",		Format:"Ymd",	Edit:0 },

			{Header:"Hidden",			Type:"Text",   		Hidden:1, SaveName:"sabun"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"orgCd"},
			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"searchApplSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"jobApplSeq"}

			]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
			
		var etcVal = etc01.split("/");
		
 		$("#searchFromApplYmd").val(etcVal[0]);
 		$("#searchToApplYmd").val(etcVal[1]);
 		$("#orgCd").val(etcVal[2]);
 		
  		$("#searchApplSeq").val(searchApplSeq);
  		$("#searchApplSabun").val(searchApplSabun);
  		
  		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetDataLinkMouse("detail",1);
  		
  		// 콥보 리스트
		/* ########################################################################################################################################## */
		var jobCdParam = "&searchJobType=10030&codeType=1";
		var jobCd = convCodeCols(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getJobMgrList"+jobCdParam, false).codeList
		            , "code,codeNm"
		            , " ");
		
		sheet1.SetColProperty("jobCd", {ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );
		sheet1.SetColProperty("jobNm", {ComboText:"|"+jobCd[0], ComboCode:"|"+jobCd[1]} );
		/* ########################################################################################################################################## */
		
		$(window).smartresize(sheetResize); sheetInit();
		
		applStatusCd = parent.$("#applStatusCd").val();
	 	applYn = parent.$("#applYn").val(); // 현 결재자와 세션사번이 같은지 여부
		
	 	if(applStatusCd == "") {
	 		applStatusCd = "11";
	 	}
		
	 	if( ( adminYn == "Y" ) || ( applStatusCd == "31"  && applYn == "Y" ) ){ //담당자거나 수신결재자이면
			
	 		if( applStatusCd == "31") { //수신처리중일 때만 지급정보 수정 가능
	 			// 입력버튼 비활성화
	 		}

	 		adminRecevYn = "Y";
	 		parent.iframeOnLoad(300);
			
	 	}
	 	
	 	$("#etc02").val(etc02);
	 	
	 	if(etc02 == 1){
	 		doAction1("Search");
			doAction1("Search2");
	 	}else{
	 		doAction2("Search");
			doAction2("Search2");
	 	}
		
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				$("#type").val("");
				var sXml = sheet1.GetSearchData("${ctx}/JobDivReportApp.do?cmd=getJobDivReportAppDetList", $("#searchForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet1.LoadSearchData(sXml);
	        	break;	
			case "Search2":
				$("#type").val("1");
				var sXml = sheet2.GetSearchData("${ctx}/JobDivReportApp.do?cmd=getJobDivReportAppDetList", $("#searchForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet2.LoadSearchData(sXml);
	        	break;	
		}
	}
	
	//Sheet1 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				$("#type").val("");
				var sXml = sheet1.GetSearchData("${ctx}/JobDivReportApp.do?cmd=getJobDivReportAppDetList2", $("#searchForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet1.LoadSearchData(sXml);
	        	break;	
			case "Search2":
				$("#type").val("1");
				var sXml = sheet2.GetSearchData("${ctx}/JobDivReportApp.do?cmd=getJobDivReportAppDetList2", $("#searchForm").serialize() );
				sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet2.LoadSearchData(sXml);
	        	break;	
		}
	}
	
	// 조회 후 에러 메시지
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
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

//--------------------------------------------------------------------------------
//  저장 시 필수 입력 및 조건 체크
//--------------------------------------------------------------------------------
function checkList(status) {
	var ch = true;

	// 화면의 개별 입력 부분 필수값 체크
	$(".required").each(function(index){
		if($(this).val() == null || $(this).val() == ""){
			alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
			$(this).focus();
			ch =  false;
			return false;
		}

		return ch;
	});

	return ch;
}
	
//--------------------------------------------------------------------------------
//  임시저장 및 신청 시 호출
//--------------------------------------------------------------------------------
function setValue(status) {
	//전송 전 잠근 계좌선택 풀기
	var returnValue = false;
	try {
		
		//관리자 수신담당자 경우 지급정보 저장
		if( adminRecevYn == "Y" ){

			if( applStatusCd != "31") { //수신처리중이 아니면 저장 처리 하지 않음
				return true;
			}
			
		}else{
		
			if ( authPg == "R" )  {
				return true;
			}
			
			var rowCnt = sheet2.RowCount();
	        
			if(rowCnt > 0){

				for (var i=1; i<=rowCnt; i++) {
					sheet2.SetCellValue(i,"sStatus","U");
					sheet2.SetCellValue(i,"searchApplSeq",$('#searchApplSeq').val());
			    }
				
				//폼에 시트 변경내용 저장
	        	IBS_SaveName(document.searchForm,sheet2);
	        	var saveStr = sheet2.GetSaveString(0); 
				if(saveStr=="KeyFieldError"){
					return false;
				}

				var data = eval("("+sheet2.GetSaveData("${ctx}/JobDivReportApp.do?cmd=saveJobDivReportAppDet", saveStr+"&"+$("#searchForm").serialize())+")");
				
	            if(data.Result.Code < 1) {
	                alert(data.Result.Message);
					returnValue = false;
	            }else{
					returnValue = true;
	            }
			}
			
		}    

	} catch (ex){
		alert("Error!" + ex);
		returnValue = false;
	}

	return returnValue;
}

//셀 클릭시 발생
function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	try {
		if( Row < sheet1.HeaderRows() ) return;
		
	    if( sheet1.ColSaveName(Col) == "detail" ) {
	    	showApplPopup( Row);
	    }else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
			sheet1.SetCellValue(Row, "sStatus", "D");
//				doAction1("Save");
	    }
	} catch (ex) {
		alert("OnClick Event Error : " + ex);
	}
}

//-----------------------------------------------------------------------------------
//		신청 팝업
//-----------------------------------------------------------------------------------
function showApplPopup( Row ) {

	if(!isPopup()) {return;}
	
	var args = new Array(5);
	var auth    = "A"
	  , applSeq = ""
	  , applInSabun = "${ssnSabun}" 
	  , applYmd = "${curSysYyyyMMdd}"
	  , url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"
	  , initFunc = 'initLayer';
	
	args["applStatusCd"] = "11";
	
	if( Row > -1  ){
		if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
			auth = "R";  
			url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		}
		applSeq     = sheet1.GetCellValue(Row,"applSeq");
		applInSabun = sheet1.GetCellValue(Row,"applInSabun");
		applYmd     = sheet1.GetCellValue(Row,"applYmd");
		args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		initFunc = 'initResultLayer';
	}
	var p = {
			searchApplCd: '180'
		  , searchApplSeq: applSeq
		  , adminYn: 'N'
		  , authPg: auth
		  , searchSabun: applInSabun
		  , searchApplSabun: applInSabun
		  , searchApplYmd: applYmd 
		};
	var approvalMgrLayer = new window.top.document.LayerModal({
		id: 'approvalMgrLayer',
		url: url,
		parameters: p,
		width: 800,
		height: 815,
		title: '직무분장보고',
		trigger: [
			{
				name: 'approvalMgrLayerTrigger',
				callback: function(rv) {
					getReturnValue(rv);
				}
			}
		]
	});
	approvalMgrLayer.show();
	//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
}
	
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form name="searchForm" id="searchForm" method="post">
	<input type="hidden" id="searchApplSabun"		name="searchApplSabun"	 value=""/>
	<input type="hidden" id="searchApplName"		name="searchApplName"	 value=""/>
	<input type="hidden" id="searchApplSeq"			name="searchApplSeq"	 value=""/>
	<input type="hidden" id="searchApplYmd"			name="searchApplYmd"	 value=""/>
	<input type="hidden" id="applYn"				name="applYn"	 		 value=""/>
	<input type="hidden" id="applseq1"				name="applseq1"	 		 value=""/>
	<input type="hidden" id="searchFromApplYmd"		name="searchFromApplYmd"	 		 value=""/>
	<input type="hidden" id="searchToApplYmd"		name="searchToApplYmd"	 		 value=""/>
	<input type="hidden" id="searchSabun"			name="searchSabun"	 		 value=""/>
	<input type="hidden" id="jobApplSeq"			name="jobApplSeq"	 		 value=""/>
	<input type="hidden" id="divType"				name="divType"	 		 value="Y"/>
	
	<input type="hidden" id="orgCd"				name="orgCd"	 		 value=""/>
	<input type="hidden" id="type"				name="type"	 		 value=""/>
	<input type="hidden" id="etc02"				name="etc02"	 		 value=""/>

		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='jobDivReport' mdef='직무분장보고'/></li>
			</ul>
		</div>
		<div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "80%", "${ssnLocaleCd}"); </script>
		</div>
		<div style="display: none;">
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "80%", "${ssnLocaleCd}"); </script>
		</div>

	</form>
</div>

</body>
</html>
