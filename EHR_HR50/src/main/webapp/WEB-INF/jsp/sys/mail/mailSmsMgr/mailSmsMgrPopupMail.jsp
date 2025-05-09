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
	
	var arg = p.popDialogArgumentAll();
	if( arg != "undefined" ) {
		paramBizCd = arg["bizCd"];
	}
	
	if (paramBizCd == "PAP"){
		$("#notiInfo").html("<br>아래 변수를 사용하시면 발송내용설정시 해당 정보로 치환하여 설정되어집니다.<br>" +
				"##평가명##, ##평가단계명##, ##평가차수명##, ##대상자명##<br>");
	} else if (paramBizCd == "STF"){
		$("#notiInfo").html("<br>아래 변수를 사용하시면 발송내용설정시 해당 정보로 치환하여 설정되어집니다.<br>" +
		"##공고명##, ##전형단계명##, ##지원번호##, ##지원자명##<br>");
	}
	
	var queryId = "queryId=tsys700SelectMailCodeList"
				+ "&bizCd="+paramBizCd+"&bizCd1=ETC";
	
	var bizCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", queryId, false).codeList, "<tit:txt mid='111914' mdef='선택'/>");
	$("#bizCd").html(bizCd[2]);
	
	$("#bizCd").change(function(){
		htmlLoad();
	});

    $("#title" ).val($("#hiddenTitle").html());
	
	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
	
	var arg = p.window.dialogArguments;
 
	Editor.modify({
		"content": ""+$("#hiddenContent").html()
	});
	
	//$("#tx_image").addClass("hide"); //에디터 사진첨부 막음

});


function htmlLoad(){
	// 입력 폼 값 셋팅
	var data = ajaxCall("${ctx}/Send.do?cmd=getMailContent",$("#dataForm").serialize(),false);

	if(data.map == null){
		$("#title").val("");
		$("#hiddenContent").html("");
		
		Editor.modify({
			"content": ""+ " "
		});
	}
	else {
		//$("#title").val(data.map.mailTitle);
		//$("#hiddenContent").html(setMailContent(data.map.mailContent));
		$("#hiddenContent").html(data.map.mailContent);
		
		if($("#bizCd").val() == "227"){
			var data = ajaxCall("${ctx}/Send.do?cmd=getMailId",$("#dataForm").serialize(),false);
			if(data.map != null){
				if(data.map.mail != ""){
					$("#fromMail").val(data.map.mail);
				}
			}
		}
		 
		Editor.modify({
			"content": ""+$("#hiddenContent").html()
		});
		
	}
}

//Ok 버튼 처리
function save() {
	
	
	if(validation()){
		$("#searchBizCd").val(paramBizCd);
		
		//이미지 경로 Replace
		var hrDomainReg = new RegExp($("#hrDomain").val(),"gi");
		var convContents = $("#content").val().replace(hrDomainReg,$("#recDomain").val());
		$("#content").val(convContents);
		
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

	var returnFlag = saveContent();
	
	return returnFlag;
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper popup_scroll">

<form id="dataForm" name="dataForm" >
<input type="hidden" id="enterCd" 		name="enterCd"       value="${sessionScope.ssnEnterCd}" />
<input type="hidden" id="sendSeq"       name="sendSeq"       value="${map.sendSeq}" type="hidden" class="text" />
<input type="hidden" id="popupPageFlag" name="popupPageFlag" value="${popupPageFlag}" class="text" />
<input type="hidden" id="hrDomain" 		name="hrDomain" 	 value="${hrDomain}" class="text" />
<input type="hidden" id="recDomain" 	name="recDomain" 	 value="${recDomain}" class="text" />
<input type="hidden" id="searchBizCd" 	name="searchBizCd" />

	<div class="popup_title">
	<ul>
		<li><tit:txt mid='113671' mdef='메일 내용등록'/></li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<table class="table">
			<colgroup>
				<col width="13%" />
				<col width="" />
			</colgroup>
	        <tr>
	            <th class="center"><tit:txt mid='112699' mdef='기본서식'/></th>
				<td >
	            	<select id="bizCd" name="bizCd">
	            	</select>
				</td>
	        </tr>
	        <tr>
	            <th class="center"><tit:txt mid='103918' mdef='제목'/></th>
				<td >
	            	<input type="text" id="title" name="title" class="text w100p" >
				</td>
	        </tr>
			<tr>
				<th class="center"><tit:txt mid='114740' mdef='메일내용'/></th>
				<td >
					<%@ include file="/WEB-INF/jsp/common/plugin/Editor/include_editor.jsp"%>
					<div id="notiInfo" name="notiInfo" class="text">
					</div>
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
		<div id="hiddenContent" name="hiddenContent" Style="display:none">
			${map.contents}
		</div>
		<div id="hiddenTitle" name="hiddenTitle" Style="display:none">${map.title}</div>
	</div>
</form>
</div>
</body>
</html>
