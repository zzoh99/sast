<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>급여일자 조회</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var p = eval("<%=popUpStatus%>");
var progress = 0;

$(function() {
    $("#workMsg").bind("keyup",function(event){
		if( event.keyCode == 13){
			p.self.close();
		}
	});
});

$(function() {
	$("#workMsg").focus();
	
	var arg = p.window.dialogArguments;
	var prgCd 		= "";
	var payActionCd = "";
	var payActionNm = "";
	var actYn = "";
	
    if( arg != undefined ) {
    	prgCd 		= arg["prgCd"];
    	payActionCd = arg["payActionCd"];
    	payActionNm = arg["payActionNm"];
    	actYn = arg["actYn"];
    } else {
    	prgCd 		= p.popDialogArgument("prgCd");
 		payActionCd = p.popDialogArgument("payActionCd");
 		payActionNm = p.popDialogArgument("payActionNm");
 	    actYn       = p.popDialogArgument("actYn");
    }
	
	$("#prgCd").val(prgCd);				// 프로시저
	$("#payActionCd").val(payActionCd);	// 급여계산코드
	$("#payActionNm").val(payActionNm);	// 급여계산명
	$("#actYn").val(actYn);	// 작업실행여부 - 1:실행 / 0:조회
	
	//$("#prgCd").val(arg["prgCd"]);				// 프로시저
	//$("#payActionCd").val(arg["payActionCd"]);	// 급여계산코드
	//$("#payActionNm").val(arg["payActionNm"]);	// 급여계산명

    $(".close").click(function() {
    	p.self.close();
    });

	// 분:초 display
    timer_start();

	// 프로시저 진행률 조회
    loadXML();

	//실행여부가 1이면 프로시저 실행
	if(actYn == "1") {
		procCall(prgCd);
		/*
		var timer = setInterval(function () {
			procCall(prgCd);
	        clearInterval(timer);
	        }, 1000);
		*/
	}
});

function procCall(prgCd){
	
	// 1. 퇴직금계산 실행
	if(prgCd == "P_CPN_SEP_PAY_MAIN") {
		//ajaxCall("<%=jspPath%>/common/progressPopupRst.jsp?cmd=prcCpnSepPayMain",$("#sheet1Form").serialize(),true);
		
		$.ajax({
			url 		: "<%=jspPath%>/common/progressPopupRst.jsp?cmd=prcCpnSepPayMain",
			type 		: "post",
			dataType 	: "json",
			async 		: true,
			data 		: $("#sheet1Form").serialize(),
			success : function(data) {
				obj = data;
				if(obj != null && obj.Result != null) {
					loadXML();
					alertMessage(obj.Result.Code,obj.Result.Message, "", "");
					p.self.close();
				}
			},
			
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});
	}
	
}

var t1;
var tcounter = 0;

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
	var result = ajaxCall("<%=jspPath%>/common/progressPopupRst.jsp?cmd=getProcessBarpMap", $("#sheet1Form").serialize(), false);
	
	if (result != null) {
		$("#workMsg").val(result.Data.work_msg);
		var percent = result.Data.work_status;
		/*
		alert("result.Data.work_status : " + result.Data.work_status);		
		if(percent != undefined) {
			setProgressPercent(result.Data.work_status);	
		} else {
			percent = 0;
		}
		*/
		setProgressPercent(result.Data.work_status);	
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

	progress = value;
	
	
    if(value == 100) {
    	//$("#workMsg").val("완료되었습니다.");
    	clearInterval(t1);
    }
	
}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>진행상태</li>
		<li class="close"></li>
	</ul>
	</div>
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="payActionCd" name="payActionCd" value="" />
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
			<th id="txt">지급일</th>
			<td><input type="text" id="payActionNm" name="payActionNm" class="text" value="" readonly style="width:230px" /></td>
			<td id="timer" class="center"></td>
		</tr>
		<tr>
			<th>진행률</th>
			<td><div class="progressbar"><div id="progressBar"></div></div></td>
			<td class="center"><span id="progressRate" class="tPink strong"></span> %</td>
		</tr>
		<tr>
			<th>내용</th>
			<td colspan="2">
				<textarea id="workMsg" name="workMsg" rows="8" class="text w100p" readonly></textarea>
			</td>
		</tr>
		</table>

		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:p.self.close();" class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>