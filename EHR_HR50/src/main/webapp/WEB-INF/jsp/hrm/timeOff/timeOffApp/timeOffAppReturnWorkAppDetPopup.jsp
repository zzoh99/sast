<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<title><tit:txt mid='104012' mdef='복직신청 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var famSdate 	= "";
var famEdate	= "";
var tDay		= 0;
var saveData	= null;
var restDate	= null;
var conditionEnterCd = ("${conditionEnterCd}" =="")?"${ssnEnterCd}":"${conditionEnterCd}";
var subUrl           = "conditionEnterCd="+conditionEnterCd;
var searchTimeOff = "${etc01}";
var searchSignCnt = "${etc02}";

$(function(){
	$("#conditionEnterCd").val(conditionEnterCd);

	<%--restDate = ajaxCall("${ctx}/GetDataMap.do?cmd=getTimeOffAppReturnWorkAppDetMap",subUrl+"&sabun=${searchApplSabun}",false);--%>

	// if(restDate.DATA){
	// 	$("#restDate").text(restDate.DATA.sdate+" ~ "+restDate.DATA.edate);
	// }
	
	saveData= ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppReturnWorkAppDetSaveMap",$("#sheetForm").serialize(),false);
	if(saveData.DATA){
		$("input:radio[value="+saveData.DATA.returnGb+"]").prop("checked",true);
		$("#returnDate").val(saveData.DATA.returnYmd);
		$("#reason").val(saveData.DATA.refReason);
		$("#etc").val(saveData.DATA.etc);
		
		$("#signYn").val(saveData.DATA.signYn);
		$("#signFileSeq").val(saveData.DATA.signFileSeq);
		
		if(saveData.DATA.signYn =="Y" ){
			$("input:checkbox[id='agreeYn']").prop("checked", true);
		 }
		
	}
	
	if("${authPg}"=="R"){
		$("#reason").addClass("readonly").attr("readOnly","readOnly");
		$("#etc").addClass("readonly").attr("readOnly","readOnly");
		$("#fdReturnCd").addClass("readonly").attr("readOnly","readOnly");
		$("#returnDate").addClass("readonly").attr("readOnly","readOnly");
		$("input:radio").attr("disabled",true);
	}else{
		$("#returnDate").datepicker2();
	}

	parent.iframeOnLoad("200px");
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
});


function setValue(status){
/*	if(status == "21"){//타인신청의 경우
		//첨부파일 1개이상 필수
		if(parent.supSheet.LastRow() <= 0)
		{
			alert("<msg:txt mid='202005200000077' mdef='첨부파일은 필수 입니다.'/>");
			return false;
		}
	}
	*/
	
	if($("#authPg").val() == "A") {
		//if(Number($("#returnDate").val().replace(/-/g,"")) < Number(restDate.DATA.sdate.replace(/-/g,""))) {return alert("<msg:txt mid='109885' mdef='복직예정일은 휴직기간 이전으로 신청할 수 없습니다.'/>");}
		//if(Number($("#returnDate").val().replace(/-/g,"")) > Number(restDate.DATA.edate.replace(/-/g,""))) {return alert("<msg:txt mid='110027' mdef='복직예정일은 휴직기간 이후로 신청할 수 없습니다.'/>"); }

		//if($("#reason").val() == "") {return alert("<msg:txt mid='109728' mdef='복직 사유를 입력하여 주십시오.'/>");}

		if($("#returnDate").val() == "") {
			alert("<msg:txt mid='119927' mdef='복직예정일을 입력하여 주십시오.'/>");
			return false;
		}

		restDate = ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppReturnWorkAppDetMap",$("#sheetForm").serialize(),false).DATA;
		if(!restDate) {
			return alert("<msg:txt mid='110182' mdef='복직 신청 대상 휴직기간이 존재하지 않습니다.'/>");
		}

		if($("#agreeYn").is(":checked")==false) {
			alert("전자서명을 등록해주십시오.");
			return false;
		}else if($("#agreeYn").is(":checked")==true) {
			$("#signYn").val("Y");	// 동의여부
		}

		var rtn = ajaxCall("${ctx}/TimeOffApp.do?cmd=saveTimeOffAppReturnWorkAppDet",$("#sheetForm").serialize(),false);
		if(rtn.Result.Code < 1) {
			alert(rtn.Result.Message);
			return false;
		}
	}

	return true;
}

function doAction2(sAction) {
	switch (sAction) {
		case "Search":		sheet2.DoSearch( "${ctx}/TimeOffApp.do?cmd=getTimeOffAppList", $("#sheetForm").serialize() ); break;
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

//복직 MRD
function showRdPopup(){

	if(!isPopup()) {return;}

	var id 		= 'rdLayer';
	var callback = function(rv) {
		getReturnValue(rv);
	};
	var w 		= 800;
	var h 		= 900;
	var url 	= "${ctx}/viewRdLayer.do";
	var args 	= new Array();
	// args의 Y/N 구분자는 없으면 N과 같음
	var sabun 	= $("#searchApplSabun").val();
	var reqDate = $("#searchApplYmd").val();
	var applSeq = $("#searchApplSeq").val();
	var signFileSeq =  $("#signFileSeq").val();
	
	var sdate = $("#returnDate").val();
	var edate = "";	
	var applCd = $("#searchApplCd").val();
	var retReasonCd = "";
	var note = $("#reason").val();
	
	var rdMrd = "";
	var rdTitle = "";
	var rdParam = "";

	if(signFileSeq =="" || signFileSeq==null){
		pGubun  = "rdSignPopup"

		var data = ajaxCall("/TimeOffApp.do?cmd=getRdRk", $("#sheetForm").serialize()+ "&detType=return", false);
		if ( data != null && data.DATA != null ){
			const rdData = {
				rk : data.DATA.rk
			};
			showRdSignLayer('/TimeOffApp.do?cmd=getAgreeEncryptRd', rdData, null, "휴직동의서");
		}
	}else{
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
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tr class="hide">
					<th><tit:txt mid='103909' mdef='휴직기간'/></th>
					<td>
						<span id="restDate"></span>
					</td>
				</tr>
				<tr class="hide">
					<th><tit:txt mid='104110' mdef='복직구분'/></th>
					<td>
						<fieldset id="fdReturnCd">
							<label><input id="returnCd" name="returnCd" type="radio" value="10" class="valignM" checked > <span><tit:txt mid='104111' mdef='일반복직'/></span></label>
							<label class="mal10"><input id="returnCd2" name="returnCd" type="radio" value="20" class="valignM"> <span><tit:txt mid='104506' mdef='군복직'/></span></label>
						</fieldset>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104402' mdef='복직예정일'/></th>
					<td>
						<input id="returnDate" name="returnDate" type="text" class="date2"/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104013' mdef='복직사유'/></th>
					<td><textarea id="reason" name="reason" rows="5" class="w100p"></textarea></td>
				</tr>
				<tr>
					<th><tit:txt mid='103783' mdef='비고'/></th>
					<td><textarea id="etc" name="etc" rows="5" class="w100p"></textarea></td>
				</tr>
				
				<tr>
					<th>전자서명</th>
					<td>
					<btn:a href="javascript:showRdPopup();"	css="basic" mid='insert' mdef="상세보기" style="background-color: #e1effb;"/>
					<input id="agreeYn" name="agreeYn" type="checkbox" value=""  required disabled/><span> 전자서명여부</span>
					</td>		
				</tr>
			</table>
		</form>
		<div class="hide">
			<script type="text/javascript"> createIBSheet("sheet2", "0", "0", "${ssnLocaleCd}"); </script>
		</div>
	</div>
</div>

</body>
</html>
