<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<base target="_self" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='smsSend' mdef='SMS 발신'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
$(document).ready(function(){
	if('${param.recruitYn}'=='Y'){
		$("#recruitShow").show();
	}
	//전형단계
	var searchRecruitStepCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F65030"), " ");
	$("#searchRecruitStep").html(searchRecruitStepCd[2]);

	//합격불합격 여부
	$("#searchRecruitPassYn").html("<option value='Y'>합격</option> <option value='N'>불합격</option>");
});
var p = eval("${popUpStatus}");
$(function(){
	var arg_bizCd = "";
	var names = "";
	var handPhones = "";
	var arg = p.popDialogArgumentAll();
	
	if( arg != undefined ) {
		names	  		= arg["names"];
		handPhones	  	= arg["handPhones"];
		arg_bizCd 		= arg["bizCd"];
	}
	reciveSms(names,handPhones);

	// DOM 생성 완료 시 화면 숨김
	$("#reserve_info").hide();

	var bizCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10060"), "<tit:txt mid='111914' mdef='선택'/>");
	$("#bizCd").html(bizCd[2]);
	$("#bizCd").val(arg_bizCd);

////////////////////////
////////////////////////
    $('.remaining').each(function () {
     // count 정보 및 count 정보와 관련된 textarea/input 요소를 찾아내서 변수에 저장한다.
     var $maxcount = $('.maxcount', this);
     var $count = $('.count', this);
     //var $input = $(this).prev();
     var $input = $("#context");

     // .text()가 문자열을 반환하기에 이 문자를 숫자로 만들기 위해 1을 곱한다.
     var maximumByte = $maxcount.text() * 1;

     // update 함수는 keyup, paste, input 이벤트에서 호출한다.
     var update = function (){

	     var before = $count.text() * 1;
	     var str_len = $input.val().length;
	     var cbyte = 0;
	     var li_len = 0;

	     for(i=0;i<str_len;i++){
	     	var ls_one_char = $input.val().charAt(i);
	   		if(escape(ls_one_char).length > 4){
	        	cbyte +=3; //한글이면 2를 더한다
	       	}else{
	        	cbyte++; //한글아니면 1을 다한다
	       	}
	   		if(cbyte <= maximumByte){
	        	li_len = i + 1;
	       	}
		}
	    // 사용자가 입력한 값이 제한 값을 초과하는지를 검사한다.
	    if (parseInt(cbyte) > parseInt(maximumByte)) {
			alert('<msg:txt mid='alertNumLetters' mdef='허용된 글자수가 초과되었습니다.\r\n\n초과된 부분은 자동으로 삭제됩니다.'/>');
			var str = $input.val();
			var str2 = $input.val().substr(0, li_len);
			$input.val(str2);

			var cbyte = 0;
			for(i=0;i<$input.val().length;i++){
				var ls_one_char = $input.val().charAt(i);
				if(escape(ls_one_char).length > 4){
					cbyte +=3; //한글이면 2를 더한다
				}else{
					cbyte++; //한글아니면 1을 다한다
				}
			}
		}
	    $count.text(cbyte);
	};

    // input, keyup, paste 이벤트와 update 함수를 바인드한다
	$input.bind('input keyup keydown paste change', function () {
    	setTimeout(update, 0);
    });
        update();
	});

////////////////////////////
////////////////////////////



	// radio change 이벤트
	$("input[name=reserve]").change(function() {
		var radioValue = $(this).val();
		if (radioValue == "2") {
			$("#reserve_info").show();
			$("#mmsYn").val("Y");
		}
		else{
			$("#reserve_info").hide();
			$("#mmsYn").val("N");
		}
	});


	$("#reserve_day").datepicker2();
	$("#reserve_time").mask("11:11");


	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});


});


function reciveSms(names, handPhones){

	var rNm   = names.split("|");
	var rSms = handPhones.split("|");

	for(i = 0; i < rSms.length; i++) {
		name = rNm[i]+"("+rSms[i]+")";
		value = rSms[i];
		$("#recevers").get(0).options[i] = new Option(name,value);
	}
}

function fnSend(){
	pSendSms();
}

function pSendSms(){
	if($("#context").val()==""){
		alert('<msg:txt mid='alertInputContext' mdef='내용을 입력해주세요.'/>');
		$("#context").focus();
		return;
	}
	if($("#fromSms").val()==""){
		alert('<msg:txt mid='alertFromSmsNum' mdef='발신자 전화번호가 없습니다.\n인사정보에서 핸드폰 번호를 등록후 재로그인해주세요.'/>');
		return;
	}
	var receversList = new Array();
	var receverStr = "";

	for(i = 0; i < $("#recevers").get(0).length; i++) {
		receversList[i] =  $("#recevers").get(0).options[i].value;
	}

	for(var i=0; i< receversList.length; i++){
		if(receverStr != ""){
			receverStr += "^";
		}
		receverStr += receversList[i];
	}

	$("#enterCd").val("${ssnEnterCd}");
	$("#sender").val("${ssnSabun}");
	$("#title").val("SMS 발신");
	$("#receverStr").val(receverStr); //보낼사람
	
	result = ajaxCall("/Send.do?cmd=callSms",$("#dataForm").serialize(),false);

	if(result["result"]["code"] == "S"){
		alert("<msg:txt mid='errorSmsSendOk' mdef='발신처리에 성공하였습니다.'/>");
		p.self.close();
	}else{
		alert("sms 발신처리에 실패하였습니다.\n"+result["result"]["Message"]);
	}
}

function smsWordsInput(){
	var param="searchRecruitStep="+$("#searchRecruitStep").val();
		param+="&searchRecruitPassYn="+$("#searchRecruitPassYn").val();
	var result = ajaxCall('${ctx}/RecMailSmsMgr.do?cmd=getRecMailSmsMgrList', param, false);
	if (result.DATA != null && result.DATA.length > 0 && result.DATA[0].sms!="") {
		$("#context").val(result.DATA[0].sms);
	}else{
		alert('등록된 문구가 없습니다.');
	}
	$("#context").change();
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='smsSend' mdef='SMS 발신'/></li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id="dataForm" name="dataForm" >
		<input type=hidden id="enterCd" name="enterCd">
		<input type=hidden id="sender" name="sender">
		<input type=hidden id="title" name="title">
		<c:if test="${!empty ssnSmsSender}">
			<input type=hidden id="fromSms" name="fromSms" value="${ssnSmsSender }" >
		</c:if>
		<c:if test="${empty ssnSmsSender}">
			<input type=hidden id="fromSms" name="fromSms" value="010-8107-9114" >
		</c:if>

		<input type=hidden id="mmsYn" name="mmsYn" value="N" >
		<span style="color: red;font-size: 11px"><tit:txt mid='112397' mdef='※발신자 연락처 변경시 재로그인해야 반영됩니다.'/></span>
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="" />
			</colgroup>
        <tr>
            <th class="center"><tit:txt mid='113784' mdef='발신자'/></th>
	        <c:if test="${!empty ssnSmsSender}">
				<td>발신번호&nbsp;(${ssnSmsSender}) </td>
			</c:if>
			<c:if test="${empty ssnSmsSender}">
				<td>발신번호&nbsp;(010-8107-9114) </td>
			</c:if>
        </tr>
        <tr style="display: none" id="recruitShow">
            <th class="center"><tit:txt mid='112699' mdef='기본서식'/></th>
            <td>
            	<span><tit:txt mid='113039' mdef='전형단계 '/></span> <select id="searchRecruitStep"	name="searchRecruitStep"  onChange="javascript:smsWordsInput();"> </select>
            	<span><tit:txt mid='114461' mdef='합격여부 '/></span> <select id="searchRecruitPassYn" 	name="searchRecruitPassYn" onChange="javascript:smsWordsInput();"> </select>
           	</td>
        </tr>
        <tr style="display: none">
            <th class="center"><tit:txt mid='113458' mdef='업무 구분'/></th>
            <td>
            	<select id="bizCd" name="bizCd">
            	</select>
			</td>
        </tr>
        <tr style="display:none">
            <th class="center"><tit:txt mid='114164' mdef='예약여부'/></th>
            <td>
                <input type="radio" id="reserve" name="reserve" class="radio" value="1" checked> 기본
                <input type="radio" id="reserve" name="reserve" class="radio" value="2" > 예약
            </td>
        </tr>
        <tr id="reserve_info">
            <th  class="center"><tit:txt mid='114545' mdef='예약정보'/></th>
            <td>
            	<input type="text" id="reserve_day" name="reserve_day" size="10" class="date2">
            	&nbsp; 시간&nbsp;:&nbsp;
            	<input type="text" id="reserve_time" name="reserve_time" size="5" class="center">
            </td>
        </tr>
        </table>
		<div class="inner" style="padding-top:10px">
        <table class="default inner fixed">
        <colgroup>
            <col width="40%" />
            <col width="" />
        </colgroup>
        <tr>
            <th class="center"><tit:txt mid='114137' mdef='수신자'/></th>
            <th class="center" >SMS</th>
        </tr>
        <tr>
            <td class="content" valign="top" >
                <select id="recevers" name="recevers" multiple class="w100p" size=14>
                </select>
                <input type="hidden" id="receverStr" name="receverStr">
            </td>
            <td class="content" valign="top">
                <textarea id="context" name="context" rows="13" cols="" class="w100p"   ></textarea><br>
                <span class="remaining">
                <span class="count">0</span>/<span class="maxcount">90</span>Byte
                </span>
            </td>
        </tr>
        </table>
		</div>
		</form>
		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:fnSend();" class="pink large"><tit:txt mid='114142' mdef='발신'/></a>
				<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
			</li>
		</ul>
		</div>
	</div>
</div>

</body>
</html>
