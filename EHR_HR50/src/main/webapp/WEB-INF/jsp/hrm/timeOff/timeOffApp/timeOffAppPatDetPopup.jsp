<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<title><tit:txt mid='104396' mdef='육아휴직신청 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var famList 	= null;
var famres 		= null;
var famEdate	= "";
var famAge		= 0;
var tDay		= 0;
var famYmd		= "";

// 추가
var today = "${curSysYyyyMMdd}";
//var preRegLimitDays = 30;
var preRegLimitDays = 0;
var defaultSDate = addDate("d", preRegLimitDays, today, "-");
var usedDaysBefore = 0;
var workHourCutSharedDaysBefore = 0;
var remainDaysBefore = 0;

var saveData	= null;
var conditionEnterCd = ("${conditionEnterCd}" =="")?"${ssnEnterCd}":"${conditionEnterCd}";
var subUrl           = "conditionEnterCd="+conditionEnterCd;
var searchTimeOff = "${etc01}";
var searchSignCnt = "${etc02}";

var dayText = "<tit:txt mid='day' mdef='일'/>";

$(function(){
	/*
	var preRegLimit = ajaxCall("${ctx}/GetDataMap.do?cmd=getTimeOffAppPatPreRegLimitDays", "", false);
	if(preRegLimit != null && preRegLimit != undefined && preRegLimit.DATA != null && preRegLimit.DATA != undefined) {
		preRegLimitDays = preRegLimit.DATA.limitDays;
		defaultSDate = addDate("d", preRegLimitDays, today, "-");
	}

	*/
	$("#conditionEnterCd").val(conditionEnterCd);

	selectText = "<sch:txt mid='select' mdef='선택'/>"

	famList = ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppPatDetFamCodeList",$("#sheetForm").serialize(),false).DATA;
	famres 	= convCode( famList, selectText);

	$("#famres").html(famres[2]);
	$("#famres").change(function(){
		$("#famYmd").text("");
		$("#famNm").val("");
		$("#famCd").val("");
		
		sheet1.RemoveAll();
		for(var i=0; i<famList.length; i++){
			if($(this).children("option:selected").text() == famList[i].codeNm){
				famAge 	 = famList[i].age;
				famYmd 	 = famList[i].famYmd;
				$("#famNm").val(famList[i].codeNm);
				$("#famCd").val(famList[i].famCd);

				if(famYmd != "") {
					$("#famYmd").text(famYmd+<msg:txt mid='202005210000108' mdef='" ( 만 "+famAge+"세 )"'/>);
				}
			}
		}
		
		if( $("#sdate").val() == "" ) {
			$("#sdate").val(defaultSDate);
		}

		if($("#famres").val() != ""){
			doAction1("Search");
		} else {
			$("#remainDaysBefore").val("");
			$("#remainDaysBeforeTxt").html("");
			$("#usedDaysBefore").val("");
			$("#usedDaysBeforeTxt").html("");
			$("#workHourCutSharedDaysBefore").val("");
			$("#workHourCutSharedDaysBeforeTxt").html("");
		}
	});

	saveData= ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppPatDetSaveMap",$("#sheetForm").serialize(),false);
	if(saveData.DATA){
		$("#famres option").each(function(){
 			if($(this).text() == saveData.DATA.famNm){
 				$(this).attr("selected", "selected");
 			}
 		});

		for(var i=0; i<famList.length; i++){
			if($("#famres").children("option:selected").text() == famList[i].codeNm){
				famAge 	 = famList[i].age;
				famYmd 	 = famList[i].famYmd;
				if(famYmd != "") {
					$("#famYmd").text(famYmd+<msg:txt mid='202005210000108' mdef='" ( 만 "+famAge+"세 )"'/>);
				}
			}
		}

// 		$("#famres").val(saveData.DATA.famres);
		$("#famCd").val(saveData.DATA.famCd);
		$("#famNm").val(saveData.DATA.famNm);
		$("#sdate").val(saveData.DATA.refSdate);
		$("#edate").val(saveData.DATA.refEdate);
		$("#reason").val(saveData.DATA.refReason);
		$("#etc").val(saveData.DATA.etc);
		$("#signYn").val(saveData.DATA.signYn);
		$("#signFileSeq").val(saveData.DATA.signFileSeq);
		
		if( $("#sdate").val() != "" && $("#edate").val() != "" ) {
			var num = getDaysBetween($("#sdate").val().replace(/-/g,""), $("#edate").val().replace(/-/g,""));
			$("#day").text(num+dayText);
		}
		
		if(saveData.DATA.signYn =="Y" ){
			$("input:checkbox[id='agreeYn']").prop("checked", true);
		 }

		// 잔여 신청가능일수(신청전)
		remainDaysBefore = saveData.DATA.remainDaysBefore;
		// 사용 육아휴직 일수(신청전)
		usedDaysBefore = saveData.DATA.usedDaysBefore;
		// 육아 근로단축 적용 육아휴직일수(신청전)
		workHourCutSharedDaysBefore = saveData.DATA.workHourCutSharedDaysBefore;

		$("#remainDaysBefore").val(remainDaysBefore);
		$("#remainDaysBeforeTxt").html(remainDaysBefore);
		$("#usedDaysBefore").val(usedDaysBefore);
		$("#usedDaysBeforeTxt").html(usedDaysBefore);
		$("#workHourCutSharedDaysBefore").val(workHourCutSharedDaysBefore);
		$("#workHourCutSharedDaysBeforeTxt").html(workHourCutSharedDaysBefore);
	}

	if("${authPg}"=="R"){
		$("#famres").addClass("readonly").attr("disabled","disabled");
		$("#reason").addClass("readonly").attr("readOnly","readOnly");
		$("#etc").addClass("readonly").attr("readOnly","readOnly");
		$("#sdate").addClass("readonly").attr("readOnly","readOnly");
		$("#edate").addClass("readonly").attr("readOnly","readOnly");
		// 버튼 숨김
		$(".btn_use").addClass("hide");
	}else{
		$("#sdate").datepicker2({
			startdate:"edate",
			onReturn: function(date) {
				
				/*var num = getDaysBetween(date.replace(/-/g,""),$("#edate").val().replace(/-/g,""));
				var prev = $("#sdate").attr("prev");
				if( preRegLimitDays > 0 && parseInt(date.replace(/-/g,"")) < parseInt(addDate("d", preRegLimitDays, today, "")) ) {
					alert(<msg:txt mid='202005210000123' mdef='"휴직은 사전신청을 원칙으로 합니다. 휴직 시작일을 조정하여 주십시오."'/>);
					$("#sdate").val(prev);
					num = "";
					$("#day").text("");
				} else {
					$("#day").text(num+dayText);
				}
				tDay = num;
				*/
			}
		});
		$("#edate").datepicker2({
			enddate:"sdate",
			onReturn: function(date) {
				var num = getDaysBetween($("#sdate").val().replace(/-/g,""),date.replace(/-/g,""));
				$("#day").text(num+dayText);
				tDay = num;
			}
		});
	}

	var typeTerm = ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffTypeTermMap",$("#sheetForm").serialize(),false);
	if(typeTerm.DATA){
		$("#limitUnit").val(typeTerm.DATA.limitUnit);
		$("#limitTerm").val(typeTerm.DATA.limitTerm);
	}

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",				Type:"${sNoTy}",  	Hidden:1,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
		{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",		Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
		{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",		Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
		
		{Header:"<sht:txt mid='inOutType' mdef='구분'/>",			Type:"Combo",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"gubun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='priorOrgNm' mdef='구분|구분'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='202005210000126' mdef='신청|신청서순번'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='202005210000133' mdef='신청|신청일'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"<sht:txt mid='2017082400293' mdef='신청|시작일'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='2017082400294' mdef='신청|종료일'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='202005210000129' mdef='발령|시작일'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordSdate",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='202005210000131' mdef='발령|종료일'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordEdate",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='202005210000132' mdef='일수|일수'/>",			Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkBx",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
	]; 
	//IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);

	IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
	
	var applCd		= convCode( ajaxCall("${ctx}/AppBeforeLst.do?cmd=getAppBeforeLstApplCdList",subUrl,false).codeList, "");
	sheet1.SetColProperty("applCd", 	{ComboText:applCd[0], ComboCode:applCd[1]} );

	sheet1.SetColProperty("gubun", 			{ComboText:"|연장|", ComboCode:"1|2|3"} );

	parent.iframeOnLoad("600px");
	
	$(window).smartresize(sheetResize);sheetInit();
	//Cancel 버튼 처리
	$(".close").click(function(){
		self.close();
	});

	var initdata2 = {};
	initdata2.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
	initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata2.Cols = [
		{Header:"rk", Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"rk",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0}

	];IBS_InitSheet(sheet2, initdata2);

	/*
	if(searchTimeOff == "Y"){
		$("#applButton", parent.document).css("display","none");
	}
	
	//임시저장 상태에서 전자서명이 되어있을때 신청 가능하게
	if(searchSignCnt == "Y"){
		$("#appTemporary", parent.document).css("display","none");
	}else{
		if(searchTimeOff != "N"){
			$("#applButton", parent.document).css("display","none");
		}
	}
	*/
	
	if($("#famres").val() != ""){
		doAction1("Search");
	}
});

function doAction1(sAction) {
	switch (sAction) {
	case "Search":
		var params  = "searchApplSabun=" + $("#searchApplSabun").val();
		    params += "&famres=" + encodeURIComponent($("#famres").val());
		    params += "&famCd=" + $("#famCd").val();
		    params += "&famNm=" + $("#famNm").val();
		//sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getTimeOffAppPatDetList", $("#sheetForm").serialize() );
		sheet1.DoSearch( "${ctx}/TimeOffApp.do?cmd=getTimeOffAppPatDetList", params );
		break;
	}
}
function doAction2(sAction) {
	switch (sAction) {
		case "Search":		sheet2.DoSearch( "${ctx}/TimeOffApp.do?cmd=getTimeOffAppList", $("#sheetForm").serialize() ); break;
	}
}

function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		
		// 잔여 신청가능일수(신청전)
		remainDaysBefore = 0;
		// 사용 육아휴직 일수(신청전)
		usedDaysBefore = 0;
		// 육아 근로단축 적용 육아휴직일수(신청전)
		workHourCutSharedDaysBefore = 0;
		
		if(sheet1.SearchRows() > 0) {
			var chkBx = 0;
			for(var i = 2; i < sheet1.RowCount()+2; i++) {
				if("${authPg}" != "R") {
					chkBx = parseInt(sheet1.GetCellValue(i, "chkBx"));
					usedDaysBefore += chkBx;
					
					// 근로시간단축인 경우  [육아 근로단축 적용 육아휴직일수] 에 합산.
					if( sheet1.GetCellValue(i, "gubun") == "3" ) {
						workHourCutSharedDaysBefore += chkBx;
					}
				}
				if(sheet1.GetCellValue(i, "applSeq") == $("#searchApplSeq").val()) {
					sheet1.SetRowBackColor(i, "#ffe0a8")
				}
			}
			sheet1.SetSelectRow(-1);
		}
		
		if("${authPg}" != "R") {
			if( usedDaysBefore > 0 ) {
				remainDaysBefore = 365 - usedDaysBefore;
			} else {
				remainDaysBefore = 365;
			}
			$("#remainDaysBefore").val(remainDaysBefore);
			$("#remainDaysBeforeTxt").html(remainDaysBefore);
			$("#usedDaysBefore").val(usedDaysBefore);
			$("#usedDaysBeforeTxt").html(usedDaysBefore);
			$("#workHourCutSharedDaysBefore").val(workHourCutSharedDaysBefore);
			$("#workHourCutSharedDaysBeforeTxt").html(workHourCutSharedDaysBefore);
		}		
		
		sheetResize();
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		const data = {
			rk : sheet2.GetCellValue(1,"rk")
		};
		window.top.showRdLayer('/TimeOffApp.do?cmd=getEncryptRd', data, null, "휴직원");

	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

function setValue(status){
	//alert($("#famNm").val());
/*
	if(status == "21"){//타인신청의 경우
		//첨부파일 1개이상 필수
		if(parent.supSheet.LastRow() <= 0)
		{
			alert("<msg:txt mid='202005200000077' mdef='첨부파일은 필수 입니다.'/>");
			return false;
		}
	}
	*/
	if($("#authPg").val() == "A") {
		if($("#famres").val() == "") {
			return alert("<msg:txt mid='109390' mdef='대상자명을 선택 하세요.'/>");
		}
		if(famAge > 8) {
			return alert("<msg:txt mid='110452' mdef='육아휴직은 8세 이하의 자녀만 신청 가능합니다.'/>");
		}
		if($("#sdate").val() == "") {
			return alert("<msg:txt mid='109726' mdef='휴직 시작일을 선택해 주세요.'/>");
		}
		if($("#edate").val() == "") {
			return alert("<msg:txt mid='110451' mdef='휴직 종료일을 선택해 주세요.'/>");
		}
		var num = getDaysBetween(formatDate($("#sdate").val(),""),formatDate($("#edate").val(),""));
		if(formatDate($("#sdate").val(),"") != "" && formatDate($("#edate").val(),"") != "") {
			if(num <= 0) {
				alert("<msg:txt mid='109757' mdef='종료일이 시작일보다 작습니다.'/>");
				$("#edate").val("");
				num = "";
				return false;
			}
		}

		var validCnt = ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppDateValideCnt",$("#sheetForm").serialize(),false);
		if(validCnt.DATA){
			if(validCnt.DATA.cnt && validCnt.DATA.cnt > 0) {
				alert("<msg:txt mid='109569' mdef='신청한 기간에 중복된 휴직이 존재합니다.'/>");
				return false;
			}
		}

		/* 한국투자증권의 경우 분할 횟수 제한 없음에 주석처리함.
		var applCnt = 0;
		for(var i=1; i <= sheet1.LastRow(); i++){
			if(sheet1.GetCellValue(i,"gubun") == '1'){
				applCnt += 1;
			}
		}
		if(applCnt > 1){
			return alert("<msg:txt mid='109391' mdef='유아 휴직은 1회 분할 사용가능 합니다.'/>");
		}
		*/
		
		if($("#agreeYn").is(":checked")==false) {
			alert("전자서명을 등록하여 주십시오.");
			return false;
		}else if($("#agreeYn").is(":checked")==true) {
			$("#signYn").val("Y");	// 전자서명여부
		}

		var totalDay = Number(tDay)+sheet1.GetSumValue("chkBx");
		var applTitle = $("#applTitle", parent.document).val();
		var limitTerm = $("#limitTerm").val();

		if(totalDay > limitTerm){
			var max;
			if(Math.floor((limitTerm/365)) > 0){
				max = Math.floor((limitTerm/365))+"<tit:txt mid='103898' mdef='년'/>";
			}else if(Math.floor((limitTerm/30)) > 0){
				max = Math.floor((limitTerm/30))+"<tit:txt mid='2017040700028' mdef='개월'/>";
			}else{
				max = limitTerm + dayText;
			}
			return alert(<msg:txt mid='202005210000101' mdef='applTitle+"의 최대 사용기간은 "+ max +" 입니다."'/>);
		}

		var empYmd = null;
		empYmd= ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppPatDetEmpYmdMap",$("#sheetForm").serialize(),false);
		if(empYmd.DATA){
			$("#empYmdCh").val(empYmd.DATA.empYmdCh);
		}

		$("#famres").attr("disabled",false);

		var rtn = ajaxCall("${ctx}/TimeOffApp.do?cmd=saveTimeOffAppPatDet",$("#sheetForm").serialize(),false);
		if(rtn.Result.Code < 1) {
			alert(rtn.Result.Message);
			return false;
		}
	}

	return true;
}

// 신청 가능일 전부 사용
function useAllApplPossibleDays(useDays) {
	if( $("#famres").val() != "" ) {
		
		if( $("#remainDaysBefore").val() != "" && parseInt($("#remainDaysBefore").val()) > 0 ) {
			var endDate = addDate("d", parseInt(useDays - 1), $("#sdate").val().replace(/-/g,""), "-");
			$("#edate").val(endDate);
			var num = getDaysBetween($("#sdate").val().replace(/-/g,""), endDate.replace(/-/g,""));
			$("#day").text(num+dayText);
			tDay = num;
		} else {
			alert("<msg:txt mid='202005210000113' mdef='신청가능일수가 0일 입니다.\n사용가능한 육아휴직을 모두 소진하셨습니다.'/>");
		}
	} else {
		alert("<msg:txt mid='202005210000115' mdef='대상 자녀를 선택해주십시오.'/>");
	}
}


//날짜 포맷을 적용한다..
function formatDate(strDate, saper) {
	if(strDate == "" || strDate == null) {
		return "";
	}

	if(strDate.length == 10) {
		return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
	} else if(strDate.length == 8) {
		return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
	}
}


//휴직원 MRD
function showRdPopup(){

	if(!isPopup()) {return;}

	var id 		= 'rdLayer';
	var callback = function() {};
	var w 		= 800;
	var h 		= 900;
	var url 	= "${ctx}/viewRdLayer.do";
	var args 	= new Array();

	var sabun 	= $("#searchApplSabun").val();
	var reqDate = $("#searchApplYmd").val();
	var applSeq = $("#searchApplSeq").val();
	var applCd = $("#searchApplCd").val();

	var sdate = $("#sdate").val();
	var edate = $("#edate").val();
	var retReasonCd = "";
	var signFileSeq =  $("#signFileSeq").val();
	var note = $("#reason").val();

	var Row = sheet1.LastRow();
	var rdMrd = "";
	var rdTitle = "";
	var rdParam = "";

	if(signFileSeq =="" || signFileSeq==null){
		pGubun  = "rdSignPopup"

		var data = ajaxCall("/TimeOffApp.do?cmd=getRdRk", $("#sheetForm").serialize() + "&detType=rest", false);
		if ( data != null && data.DATA != null ){
			const rdData = {
				rk : data.DATA.rk
			};
			showRdSignLayer('/TimeOffApp.do?cmd=getAgreeEncryptRd', rdData, null, "휴직원");
		}
	} else {
		doAction2("Search");
	}
}

//팝업 콜백 함수.
function getReturnValue(rv) {
	if(pGubun == "rdSignPopup" && rv["fileSeq"] != undefined){
		$('#signFileSeq').val(rv["fileSeq"]);
		$("input:checkbox[id='agreeYn']").prop("checked", true);
	}  
}

function showRdSignLayer(url, data, opt, title, cW, cH, top, left){
	//암호화 호출
	const result = ajaxTypeJson(url, data, false);

	let layerModal = new window.top.document.LayerModal({
		id : 'rdSignLayer' //식별자ID
		, url : '/viewRdSignLayer.do' //팝업에 띄울 화면 jsp
		, parameters : {
			"p" : result.DATA.path,
			"d" : result.DATA.encryptParameter,
			"o" : opt,
			"u" : url,
			"ud": data
		}
		, width : (cW != null && cW != undefined)?cW:1000
		, height : (cH != null && cH != undefined)?cH:800
		, top : (top != null && top != undefined) ? top : 0
		, left : (left != null && left != undefined) ? left : 0
		, title : (title != null && title != undefined)?title:'-'
		, trigger :[ //콜백
			{
				name : 'rdSignLayerTrigger'
				, callback : function(rv){
					getReturnValue(rv)
				}
			}
		]
	});
	layerModal.show();
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<div>
		<form id="sheetForm" name="sheetForm" >
			<input id="conditionEnterCd" name="conditionEnterCd" type="hidden" value="" />
			<input id="searchApplCd" 	name="searchApplCd" 	type="hidden" value="${searchApplCd}"/>
			<input id="searchApplSeq" 	name="searchApplSeq" 	type="hidden" value="${searchApplSeq}"/>
			<input id="searchApplSeq2" 	name="searchApplSeq2" 	type="hidden" value="${searchApplSeq}"/>
			<input id="searchApplSabun" name="searchApplSabun" 	type="hidden" value="${searchApplSabun}"/>
			<input id="adminYn" 		name="adminYn" 			type="hidden" value="${adminYn}"/>
			<input id="authPg" 			name="authPg" 			type="hidden" value="${authPg}"/>
			<input id="searchApplYmd" 	name="searchApplYmd" 	type="hidden" value="${searchApplYmd}"/>
			<input id="searchSabun" 	name="searchSabun" 		type="hidden" value="${searchSabun}"/>
			<input id="famCd"			name="famCd" 			type="hidden" value=""/>
			<input id="famNm"			name="famNm" 			type="hidden" value=""/>

			<input id="limitUnit"			name="limitUnit" 			type="hidden" value=""/>
			<input id="limitTerm"			name="limitTerm" 			type="hidden" value=""/>
			
			<input id="signYn"			name="signYn" 			type="hidden" value=""/>
			<input id="signFileSeq"		name="signFileSeq" 		type="hidden" value=""/>

			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='appTitle' mdef='신청내용'/></li>
					</ul>
				</div>
			</div>
			<table class="table">
				<colgroup>
					<col width="15%" />
					<col width="35%" />
					<col width="15%" />
					<col width="35%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='104395' mdef='대상자명'/></th>
					<td>
						<select id="famres" name="famres"> </select>
					</td>
					<th><tit:txt mid='104294' mdef='생년월일'/></th>
					<td id="famYmd"></td>
				</tr>
				<tr>
					<th><tit:txt mid='202005210000106' mdef='신청가능일수'/></th>
					<td>
						<input id="remainDaysBefore" name="remainDaysBefore" type="hidden"/>
						<span id="remainDaysBeforeTxt" class="f_red f_bold"></span> <tit:txt mid='day' mdef='일'/>
					</td>
					<th><tit:txt mid='104265' mdef='기육아휴직일수'/></th>
					<td>
						<input id="usedDaysBefore" name="usedDaysBefore" type="hidden"/>
						<span id="usedDaysBeforeTxt" class="f_red f_bold"></span> <tit:txt mid='day' mdef='일'/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='103909' mdef='휴직기간'/></th>
					<td colspan="3">
						<input id="sdate" name="sdate" type="text" class="date2" style="" readonly/>~
						<input id="edate" name="edate" type="text" class="date2" style="" readonly/>
						<span id="day" style="margin-left:10px;"></span>
						<a href="javascript:useAllApplPossibleDays(180);" class="btn_use gray small valignM mal10"><tit:txt mid='202005210000120' mdef='6개월 신청'/></a>
						<a href="javascript:useAllApplPossibleDays(365);" class="btn_use gray small valignM"><tit:txt mid='202005210000121' mdef='1년 신청'/></a>
						<a href="javascript:useAllApplPossibleDays($('#remainDaysBefore').val());" class="btn_use gray small valignM"><tit:txt mid='202005210000122' mdef='신청가능일 전부 신청'/></a>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104299' mdef='휴직사유'/></th>
					<td colspan="3"><textarea id="reason" name="reason" rows="2" class="w100p"></textarea></td>
				</tr>
				<tr>
					<th><tit:txt mid='103783' mdef='비고'/></th>
					<td colspan="3"><textarea id="etc" name="etc" rows="2" class="w100p"></textarea></td>
				</tr>
				<tr>
					<th>전자서명 </th>
					<td>
					<btn:a href="javascript:showRdPopup();"	css="basic" mid='insert' mdef="상세보기" style="background-color: #e1effb;"/>
					<input id="agreeYn" name="agreeYn" type="checkbox" value=""  required disabled/><span> 전자서명 여부</span>
					</td>		
				</tr>
			</table>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='104008' mdef='기신청내용'/></li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
			<div class="hide">
				<script type="text/javascript"> createIBSheet("sheet2", "0", "0", "${ssnLocaleCd}"); </script>
			</div>

		</table>
	</div>
</div>

</body>
</html>
