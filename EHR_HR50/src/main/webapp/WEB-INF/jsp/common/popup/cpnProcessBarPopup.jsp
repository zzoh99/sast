<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='cpnProcessBarPop' mdef='진행상태'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<link rel="stylesheet" href="/common/css/contents.css" />

<script type="text/javascript">
var p = eval("${popUpStatus}");
var t1;
var tcounter = 0;

$(function() {
	var arg = p.window.dialogArguments;
	var prgCd 		= "";
	var payActionCd = "";
	var payActionNm = "";
	var businessPlaceCd = "";
	var actYn = "";
	
    if( arg != undefined ) {
    	prgCd 		= arg["prgCd"];
    	payActionCd = arg["payActionCd"];
    	payActionNm = arg["payActionNm"];
    	businessPlaceCd = arg["businessPlaceCd"];
    	actYn = arg["actYn"];
    }else{
	    if(p.popDialogArgument("prgCd")!=null)				prgCd  			= p.popDialogArgument("prgCd");
	    if(p.popDialogArgument("payActionCd")!=null)		payActionCd  	= p.popDialogArgument("payActionCd");
	    if(p.popDialogArgument("payActionNm")!=null)		payActionNm  	= p.popDialogArgument("payActionNm");
	    if(p.popDialogArgument("businessPlaceCd")!=null)	businessPlaceCd  	= p.popDialogArgument("businessPlaceCd");
	    if(p.popDialogArgument("actYn")!=null)				actYn  				= p.popDialogArgument("actYn");
    }
	
	
	$("#prgCd").val(prgCd);				// 프로시저
	$("#payActionCd").val(payActionCd);	// 급여계산코드
	$("#payActionNm").val(payActionNm);	// 급여계산명
	$("#businessPlaceCd").val(businessPlaceCd);	// 사업장
	$("#actYn").val(actYn);	// 작업실행여부 - 1:실행 / 0:조회
    $(".close").click(function() {
    	p.self.close();
    });

	// 분:초 display
    timer_start();
	// 프로시저 진행률 조회
    loadXML();
	
});

function timer_start(){ //초기 설정함수
    tcounter = 0; //설정
    t1 = setInterval(Timer,1000);
}

function Timer(){
    tcounter = tcounter + 1;
    var temp = Math.floor(tcounter/60); // 분 두자리 계산 mm
    if ( Math.floor(tcounter/60) < 10 ) { temp = '0'+temp; }
        temp = temp + ":";   // mm:ss의 : 이부분추가
    if ( (tcounter%60) < 10 ) { temp = temp + '0'; } // 초 두자리 계산 ss

    temp = temp + (tcounter%60);
    $("#timer").html(temp);
}

// 프로시저 진행률 조회
function loadXML() {
	const p = $("#sheet1Form").serialize();
	var result = ajaxCall("${ctx}/CpnComPopup.do?cmd=getCpnProcessBarComPopupMap", p, false);
	if (result != null && result.Map != null) {
		$("#workMsg").val(result.Map.workMsg);
		var percent = result.Map.workStatus;
		setProgressPercent(result.Map.workStatus);
		if(percent >= 100) return;
		setTimeout(loadXML, 1000);
	} else {
		$("#workMsg").val("처리 정보가 없습니다.");
        setProgressPercent(0);
	}
}

//프로시저 진행률 display
function setProgressPercent(value) {
    var width = Math.round((203-0) / (100-0) * value);
	$("#progressRate").text(value);
	$("#progressBar").width(value+"%");
    if(value == 100) {
    	$("#workMsg").val("완료되었습니다.");
    	clearInterval(t1);
		setTimeout(() => {
			if (p.window.opener.calcComplete) {
	    		p.window.opener.calcComplete();
	        }
		}, 1000 );
    }
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='cpnProcessBarPop' mdef='진행상태'/></li>
		<li class="close"></li>
	</ul>
	</div>
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="payActionCd" name="payActionCd" value="" />
		<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" value="" />
		<input type="hidden" id="prgCd" name="prgCd" value="" />
		<input type="hidden" id="actYn" name="actYn" value="" />
	</form>
	<div class="popup_main">
		<table border="0" cellpadding="0" cellspacing="0" class="table">
		<colgroup>
			<col width="25%" />
			<col width="55%" />
			<col width="20%" />
		</colgroup>
		<tr>
			<th id="txt"><tit:txt mid='112689' mdef='지급일'/></th>
			<td><input type="text" id="payActionNm" name="payActionNm" class="text" value="" readonly style="width:230px" /></td>
			<td id="timer" class="center"></td>
		</tr>
		<tr>
			<th><tit:txt mid='113772' mdef='진행률'/></th>
			<td><div class="progressbar"><div id="progressBar"></div></div></td>
			<td class="center"><span id="progressRate" class="tPink strong"></span> %</td>
		</tr>
		<tr>
			<th><tit:txt mid='104429' mdef='내용'/></th>
			<td colspan="2">
				<textarea id="workMsg" name="workMsg" rows="8" class="text w100p" readonly></textarea>
			</td>
		</tr>
		</table>

		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>
