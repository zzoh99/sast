<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<title><tit:txt mid='112139' mdef='휴복직신청 '/></title>
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

var sumDay = 0;

var dayText = "<tit:txt mid='day' mdef='일'/>";

$(function(){

	$("#conditionEnterCd").val(conditionEnterCd);

	saveData= ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppPatDetSaveMap",$("#sheetForm").serialize(),false);
	if(saveData.DATA){
		$("#sdate").val(saveData.DATA.refSdate);
		$("#edate").val(saveData.DATA.refEdate);
		$("#reason").val(saveData.DATA.refReason);
		$("#etc").val(saveData.DATA.etc);
		
		$("#signYn").val(saveData.DATA.signYn);
		$("#signFileSeq").val(saveData.DATA.signFileSeq);
		
		if(saveData.DATA.signYn =="Y" ){
			$("input:checkbox[id='agreeYn']").prop("checked", true);
		 }
		
		// 잔여 신청가능일수(신청전)
//		remainDaysBefore = saveData.DATA.remainDaysBefore;

//		$("#remainDaysBefore").val(remainDaysBefore);
//		$("#remainDaysBeforeTxt").html(remainDaysBefore);
	}
	if("${authPg}"=="R"){
		$("#reason").addClass("readonly").attr("readOnly","readOnly");
		$("#etc").addClass("readonly").attr("readOnly","readOnly");
		$("#sdate").addClass("readonly").attr("readOnly","readOnly");
		$("#edate").addClass("readonly").attr("readOnly","readOnly");
	}else{
		$("#sdate").datepicker2({
			startdate:"edate",
			onReturn: function(date) {
				$("#chkdate").val(date);
				var num = getDaysBetween(date.replace(/-/g,""),$("#edate").val().replace(/-/g,""));
				$("#day").text(num+dayText);
				tDay = num;
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
		$("#limitTerm").val(typeTerm.DATA.limitTerm);
	}
	
	parent.iframeOnLoad("200px");
	//Cancel 버튼 처리
	$(".close").click(function(){
		self.close();
	});
	
	//본인신청시
	/*
	if(searchTimeOff == "Y"){
		$("#applButton", parent.document).css("display","none");
	}
	searchSignCnt ="Y";
	//임시저장 상태에서 전자서명이 되어있을때 신청 가능하게
	if(searchSignCnt == "Y"){
		$("#appTemporary", parent.document).css("display","none");
	}else{
		if(searchTimeOff != "N"){
			$("#applButton", parent.document).css("display","none");
		}
	}
	
	*/
	/* 가족돌봄휴직 */
	if($("#searchApplCd").val() == "157"){
		
		$("#chkdate").val('<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>');
		
		if($("#sdate").val()!="" && $("#edate").val() != ""){
			var num = getDaysBetween($("#sdate").val().replace(/-/g,""), $("#edate").val().replace(/-/g,""));
			$("#day").text(num+dayText);
		}
		
		var yearData= ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppDetSumMap",$("#sheetForm").serialize(),false);
		if(yearData.DATA){
			//신청일수
			sumDay = yearData.DATA.sumDay;
			
			$("#trSumDay").removeClass("hide");
			$("#sumDay").text(90-sumDay+dayText);
		}
	}else if($("#searchApplCd").val() !="155"){
		if($("#sdate").val()!="" && $("#edate").val() != ""){
			var num = getDaysBetween($("#sdate").val().replace(/-/g,""), $("#edate").val().replace(/-/g,""));
			$("#day").text(num+dayText);
		}
	}

	var initdata2 = {};
	initdata2.Cfg = {FrozenCol:0, SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
	initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata2.Cols = [
		{Header:"rk", Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"rk",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0}

	];IBS_InitSheet(sheet2, initdata2);

});

function setValue(status){
	
	if($("#authPg").val() == "A") {
		var limitTerm = $("#limitTerm").val();
		var applTitle = $("#applTitle", parent.document).val();

		if($("#sdate").val() == "") {
			alert("<msg:txt mid='109726' mdef='휴직 시작일을 선택해 주세요.'/>");
			return false;
		}
		if($("#edate").val() == "") {
			alert("<msg:txt mid='110451' mdef='휴직 종료일을 선택해 주세요.'/>");
			return false;
		}

		var validCnt = ajaxCall("${ctx}/TimeOffApp.do?cmd=getTimeOffAppDateValideCnt",$("#sheetForm").serialize(),false);
		if(validCnt.DATA){
			if(validCnt.DATA.cnt && validCnt.DATA.cnt > 0) {
				alert("<msg:txt mid='109569' mdef='신청한 기간에 중복된 휴직이 존재합니다.'/>");
				return false;
			}
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
		
		if($("#searchApplCd").val() == "157"){
			
			var sdate = $("#sdate").val().replace(/-/g, '');  
			var edate = $("#edate").val().replace(/-/g, '');
			
			if(sdate.substr(0, 4) != edate.substr(0, 4)){
				alert("<msg:txt mid='202005210000099' mdef='가족돌봄휴직은 같은 년도에만 사용 가능합니다.'/>");
				return false;
			}
			
			var num = getDaysBetween($("#sdate").val().replace(/-/g,""), $("#edate").val().replace(/-/g,""));
			
			if(num < 30 || (sumDay+num) > 90 ){
				alert("<msg:txt mid='202005210000100' mdef='가족돌봄휴직은 1회 30일 이상 ~ 년 최대 90일만 사용 가능합니다.'/>");
				return false;
			}
		}else{
			if($("#searchApplCd").val() != "155"){		
				if(tDay > limitTerm){
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
			}
		}

		if($("#agreeYn").is(":checked")==false) {
			alert("전자서명을 등록하여 주십시오.");
			return false;
		}else if($("#agreeYn").is(":checked")==true) {
			$("#signYn").val("Y");	// 전자서명여부
		}
		
		
		var rtn = ajaxCall("${ctx}/TimeOffApp.do?cmd=saveTimeOffAppDet",$("#sheetForm").serialize(),false);
		if(rtn.Result.Code < 1) {
			alert(rtn.Result.Message);
			return false;
		}
	}

	return true;
}

// 날짜 포맷을 적용한다..
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
	var applCd = $("#searchApplCd").val();
	var sdate = $("#sdate").val();
	var edate = $("#edate").val();
	var signFileSeq =  $("#signFileSeq").val();
	var retReasonCd = "";
	var note = $("#reason").val();
	
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
			<input id="timeOff" 		name="timeOff" 			type="hidden" value="${timeOff}"/>

			<input id="limitTerm"			name="limitTerm" 	type="hidden" value=""/>
			<input id="chkdate"			name="chkdate" 			type="hidden" value=""/>
			
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
				<tr>
					<th><tit:txt mid='103909' mdef='휴직기간'/></th>
					<td>
						<input id="sdate" name="sdate" type="text" class="date2" /> ~
						<input id="edate" name="edate" type="text" class="date2" />
						<span id="day" style="margin-left:10px;"></span>
					</td>
				</tr>
				<tr id="trSumDay" class="hide">
					<th><tit:txt mid='202005210000106' mdef='신청가능일수'/></th>
					<td><span id="sumDay" style="margin-left:10px;"></span></td>
				</tr>
				<tr>
					<th><tit:txt mid='104299' mdef='휴직사유'/></th>
					<td><textarea id="reason" name="reason" rows="5" class="w100p"></textarea></td>
				</tr>
				<tr>
					<th><tit:txt mid='103783' mdef='비고'/></th>
					<td><textarea id="etc" name="etc" rows="5" class="w100p"></textarea></td>
				</tr>
				<tr>
					<th>전자서명 </th>
					<td>
					<btn:a href="javascript:showRdPopup();"	css="basic" mid='insert' mdef="상세보기" style="background-color: #e1effb;"/>
					<input id="agreeYn" name="agreeYn" type="checkbox" value=""  required disabled/><span> 전자서명 여부</span>
					</td>		
				</tr>
			</table>

			
<div class="hide">
			<div class="h10"></div>
			<div class="sheet_title">
				<ul>
					<li class="txt">유의 사항</li>
				</ul>
			</div>
			<table class="table">
				<colgroup>
					<col width="120px" />
					<col width="100px" />
					<col width="*" />
					<col width="120px" />
				</colgroup>
			<tr>
				<th style="text-align: center;"> 종류</th>
				<th style="text-align: center;"> 유/무급</th>
				<th style="text-align: center;"> 사용 기준</th>
				<th style="text-align: center;"> 증빙 서류</th>
			</tr>
			<tr>
				<td> 육아휴직 </td>
				<td style="text-align: center;">무급</td>
				<td >
					만8세 이하 또는 초등학교 2학년 이하의 자녀를 양육하기 위하여 </br>
					아이 1명당 1년 이하의 기간 사용 가능 (남,녀 근로자 각 1년씩 가능)</br>
					*2회 분할 사용 가능</td>
				<td>출생증명서 또는 가족관계증명서	</td>
			</tr>
			
			<tr>
				<td> 가족돌봄휴직</td>
				<td style="text-align: center;">무급 </td>
				<td>가족의 질병, 사고, 노령 또는 자녀양육을 사유로 연간 최대 90일 이내 사용 가능 </br>
					*1회 분할 사용 가능(30일 이상 사용시)</td>
				<td>가족관계증명서 및 소견서(또는 진단서)	</td>
			</tr>
			</table>
</div>				
			
			
		</form>
		<div class="hide">
			<script type="text/javascript"> createIBSheet("sheet2", "0", "0", "${ssnLocaleCd}"); </script>
		</div>
	</div>
</div>

</body>
</html>
