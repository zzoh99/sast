<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='cpnProcessBarPop' mdef='진행상태'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">
$(function() {
	const modal = window.top.document.LayerModalUtility.getModal('timProcessBarLayer');
	var arg = modal.parameters;
	var searchWorkGubun 	= "";
	var searchBusinessPlaceCd = "";
	var schYm = "";

    if( arg != undefined ) {
    	searchWorkGubun 		= arg["searchWorkGubun"];
    	searchBusinessPlaceCd   = arg["searchBusinessPlaceCd"];
    	schYm = arg["schYm"];
    }else{
	    if(arg.searchWorkGubun!=null)
			searchWorkGubun	= arg.searchWorkGubun;
	    if(arg.searchBusinessPlaceCd!=null)
			searchBusinessPlaceCd = arg.searchBusinessPlaceCd;
	    if(arg.schYm!=null)
			schYm = arg.schYm;
    }

    $("#searchWorkGubun").val(searchWorkGubun);
    $("#searchBusinessPlaceCd").val(searchBusinessPlaceCd);
    $("#schYm"          ).val(schYm);

    $(".close").click(function() {
		windowClose();
    });

	// 분:초 display
    timer_start();

	// 프로시저 진행률 조회
    loadXML();
});

var t1;

function timer_start(){ //초기 설정함수
	$("#tcounter").val(0); //설정
	setProgressPercent(0);
    t1 = setInterval(Timer,1000);
}

function Timer(){
	var tcounter = Number($("#tcounter").val());
    tcounter = tcounter + 1;
    var temp = Math.floor(tcounter/60); // 분 두자리 계산 mm
    if ( Math.floor(tcounter/60) < 10 ) { temp = '0'+temp; }
        temp = temp + ":";   // mm:ss의 : 이부분추가
    if ( (tcounter%60) < 10 ) { temp = temp + '0'; } // 초 두자리 계산 ss

    temp = temp + (tcounter%60);
    $("#timer").html(temp);
	$("#tcounter").val(tcounter);
}

// 프로시저 진행률 조회
function loadXML() {
	var result = ajaxCall("${ctx}/TimComPopup.do?cmd=getTimProcessBarComPopupMap", $("#sheet1Form").serialize(), false);

	if (result != null && result.DATA != null) {
		//$("#workMsg").val(result.Map.workMsg);
		var percent = result.DATA.workStatus;
		setProgressPercent(result.DATA.workStatus);

		if(percent >= 100) return;
		window.setTimeout(loadXML, 1000); // 1초간격
	} else {
		$("#workMsg").val("처리 정보가 없습니다.");
        setProgressPercent(0);
	}
}

// 프로시저 진행률 display
function setProgressPercent(value) {
    var width = Math.round((203-0) / (100-0) * value);

	$("#progressRate").text(value);
	$("#progressBar").width(value+"%");

    if(value == 100) {
    	$("#workMsg").val("완료되었습니다.");
    }
}

function windowClose(){
	clearInterval(t1);
	const modal = window.top.document.LayerModalUtility.getModal('timProcessBarLayer');
	modal.fire('timProcessBarLayerTrigger', {}).hide();
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="searchWorkGubun" name="searchWorkGubun" value="" />
		<input type="hidden" id="searchBusinessPlaceCd" name="searchBusinessPlaceCd" value="" />
	</form>
	<div class="modal_body">
		<table border="0" cellpadding="0" cellspacing="0" class="table">
		<colgroup>
			<col width="25%" />
			<col width="55%" />
			<col width="20%" />
		</colgroup>
		<tr>
			<th id="txt"><tit:txt mid='114444' mdef='대상년월'/></th>
			<td><input type="text" id="schYm" name="schYm" class="text" value="" readonly style="width:230px" /></td>
			<td id="timer" class="center"></td>
			<input type="hidden" id="tcounter" name="tcounter" value="0" />
		</tr>
		<tr>
			<th><tit:txt mid='113772' mdef='진행률'/></th>
			<td><div class="progressbar"><div id="progressBar"></div></div></td>
			<td class="center"><span id="progressRate" class="tPink strong"></span> %</td>
		</tr>
		<tr>
			<th><tit:txt mid='104429' mdef='내용'/></th>
			<td colspan="2">
				<textarea id="workMsg" name="workMsg" rows="2" class="text w100p" readonly></textarea>
			</td>
		</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:windowClose()" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>
