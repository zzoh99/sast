<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='112965' mdef='중앙미디어네트워크'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!-- Jquery -->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%><!-- IBSheet -->
<style type="text/css">
</style>
<script type="text/javascript">
var p = eval("${popUpStatus}");

var paramBizCd = "PAP";
$(function(){
	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
	
	var arg = p.window.dialogArguments;
	
	if( arg != "undefined" ) {
		paramBizCd = arg["bizCd"];
	}
	
    $("#title" ).val($("#hiddenTitle").html());

    $('.remaining').each(function () {
        // count 정보 및 count 정보와 관련된 textarea/input 요소를 찾아내서 변수에 저장한다.
        var $maxcount = $('.maxcount', this);
        var $count = $('.count', this);
        //var $input = $(this).prev();
        var $input = $("#contents");

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
});




//Ok 버튼 처리
function save() {
	
	
	if(validation()){
		$("#searchBizCd").val(paramBizCd);
		var result = ajaxCall("/MailSmsMgr.do?cmd=saveMailSmsMgrPopup",$("#dataForm").serialize(),false);
		if (result != null && result["Result"] != null && result["Result"]["Message"] != null) {
	
			alert(result["Result"]["Message"]);
	
			if(result["Result"]["reload"]  == 'Y'){
	
				p.popReturnValue(result["Result"]);
				p.window.close();
			}
		}else{
	
		}
	}
}

function validation(){

	if($("#contents").val()==""){
		alert('<msg:txt mid='alertInputContext' mdef='내용을 입력해주세요.'/>');
		$("#contents").focus();
		return false;
	}
	return true;
}

</script>
</head>
<body class="bodywrap">
<form id="dataForm" name="dataForm" >
<input type="hidden" id="enterCd" 		name="enterCd"       value="${sessionScope.ssnEnterCd}" />
<input type="hidden" id="sendSeq"       name="sendSeq"       value="${map.sendSeq}" type="hidden" class="text" />
<input type="hidden" id="popupPageFlag" name="popupPageFlag" value="${popupPageFlag}" class="text" />
<input type="hidden" id="hrDomain" 		name="hrDomain" 	 value="${hrDomain}" class="text" />
<input type="hidden" id="recDomain" 	name="recDomain" 	 value="${recDomain}" class="text" />
<input type="hidden" id="searchBizCd" 	name="searchBizCd" />

<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='112578' mdef='SMS 내용등록'/></li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<table class="table">
			<colgroup>
				<col width="20%" />
				<col width="" />
			</colgroup>
	        <tr>
	            <th class="center"><tit:txt mid='103918' mdef='제목'/></th>
				<td >
	            	<input type="text" id="title" name="title" class="text w100p" >
				</td>
	        </tr>
			<tr>
				<th class="center">SMS</th>
				<td >
	                <textarea id="contents" name="contents" rows="13" cols="" class="w100p"   >${map.contents}</textarea><br>
	                <span class="remaining">
	                <span class="count">0</span>/<span class="maxcount">2000</span>Byte
	                </span>
				</td>
			</tr>
		</table>
		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:save();" css="pink large" mid='save' mdef="저장"/>
					<btn:a css="close gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
	<div id="hiddenTitle" name="hiddenTitle" Style="display:none">${map.title}</div>
</div>
</form>
</body>
</html>
