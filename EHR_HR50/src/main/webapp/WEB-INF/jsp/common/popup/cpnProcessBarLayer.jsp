<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='cpnProcessBarPop' mdef='진행상태'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%--<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>--%>

<style type="text/css">
	div.progress-wrap div.progressbar {height:15px; border-radius:4px; background:#febebe;}
	div.progress-wrap div.progressbar div {width:0; height:15px; border-radius:4px; background:#fc5c5c;}
	div.progress-wrap .point-color {font-size: 13px; font-weight: 500; line-height: 1.85; color: #fc5c5c;}
	div.progress-desc{display:flex; align-items: center;}
	div.progress-desc .ml-auto{margin-left: auto;}
</style>

<script type="text/javascript">
<%--var p = eval("${popUpStatus}");--%>
var t1, t2, t3;
var tcounter = 0;
var actYn;

$(function() {
	// var arg = p.window.dialogArguments;

	const modal = window.top.document.LayerModalUtility.getModal('processBarLayer');
	let prgCd 		= modal.parameters.prgCd || '';
	let payActionCd = modal.parameters.payActionCd || '';
	let payActionNm = modal.parameters.payActionNm || '';
	let businessPlaceCd = modal.parameters.businessPlaceCd || '';
	actYn = modal.parameters.actYn || ''; // 진행상태를 오픈한 방식. 0: 진행상태 버튼 클릭으로 인한 오픈. 1: 계산으로 인한 진행상태창 오픈.

	$("#prgCd").val(prgCd);				// 프로시저
	$("#payActionCd").val(payActionCd);	// 급여계산코드
	$("#payActionNm").val(payActionNm);	// 급여계산명
	$("#businessPlaceCd").val(businessPlaceCd);	// 사업장
	// 분:초 display - 급여계산에만 동작
    if(actYn == 1) timer_start();
	// 프로시저 진행률 조회
    loadXML();

	modal.destroy(function(){
		clearTimeout(t1);
		clearTimeout(t2);
		clearTimeout(t3);
	});
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
		t2 = setTimeout(loadXML, 1000);
	} else {
		$("#workMsg").val("처리 정보가 없습니다.");
        //setProgressPercent(0);
		if (actYn !== "0") {
			t3 = setTimeout(() => {
				const modal = window.top.document.LayerModalUtility.getModal('processBarLayer');
				modal.fire('processBarLayerTrigger').hide();
			}, 1000 );
		}
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
		if (actYn !== "0") {
			t3 = setTimeout(() => {
				const modal = window.top.document.LayerModalUtility.getModal('processBarLayer');
				modal.fire('processBarLayerTrigger').hide();
			}, 1000);
		}
    }
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
<%--	<div class="popup_title">--%>
<%--	<ul>--%>
<%--		<li><tit:txt mid='cpnProcessBarPop' mdef='진행상태'/></li>--%>
<%--		<li class="close"></li>--%>
<%--	</ul>--%>
<%--	</div>--%>
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="payActionCd" name="payActionCd" value="" />
		<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" value="" />
		<input type="hidden" id="prgCd" name="prgCd" value="" />
		<input type="hidden" id="actYn" name="actYn" value="" />
	</form>
	<div class="modal_body">
		<table border="0" cellpadding="0" cellspacing="0" class="table">
		<colgroup>
			<col width="35%" />
			<col width="65%" />
		</colgroup>
		<tr>
			<th id="txt"><tit:txt mid='112689' mdef='지급일'/></th>
			<td><input type="text" id="payActionNm" name="payActionNm" class="text" value="" readonly style="width:230px" /></td>
		</tr>
		<tr>
			<th><tit:txt mid='113772' mdef='진행률'/></th>
			<td><div class="progress-wrap"><div class="progressbar"><div id="progressBar"></div></div>
				<div class="progress-desc"><span id="timer" class="timer"></span><strong id="progressRate" class="point-color rate ml-auto"></strong><span class="point-color right">%</span></div></div>
			</td>
		</tr>
		<tr>
			<th><tit:txt mid='104429' mdef='내용'/></th>
			<td>
				<textarea id="workMsg" name="workMsg" rows="8" class="text w100p" readonly></textarea>
			</td>
		</tr>
		</table>
	</div>
	<div class="modal_footer">
		<%--<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>--%>
		<a href="javascript:closeCommonLayer('processBarLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>
