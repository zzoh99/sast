<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<title><tit:txt mid='112573' mdef='설문지 상세 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<script type="text/javascript">
	var researchSeq	= null;
	var researchNm	= null;

	var titleTemp 	= "<div class='question-wrap'><div class='num'>Q#no#.</div><p class='question'>#title#</p></div>";
	var textAreaTemp= "<ul id='#qSeq#' class='list-wrap'><textarea id='textarea#qSeq#' style='width:98%;height:50px;'>#text#</textarea></ul>";
	var checkTemp 	= "<ul id='#qSeq#' class='list-wrap'><li><label ><input id='check#qSeq#' name='check#qSeq#' type='checkbox' #checked#	value='#itemSeq#'><span class='ctxt'>#itemNm#</span></label></li></ul>";
	var radioTemp 	= "<ul id='#qSeq#' class='list-wrap'><li><label ><input id='radio#qSeq#' name='radio#qSeq#' type='radio' 	  #checked#	value='#itemSeq#'><span class='ctxt'>#itemNm#</span></label></li></ul>";

	var question 	= null;

	$(function(){
		const modal = window.top.document.LayerModalUtility.getModal('researchAppWriteFormLayer');
		researchSeq = modal.parameters.researchSeq || '';
		researchNm = modal.parameters.researchNm || '';
		memo = modal.parameters.memo || '';
		fileSeq = modal.parameters.fileSeq || '';

		$("#researchSeq").val(researchSeq);
		$("#title").html(researchNm);

		question = ajaxCall("${ctx}/ResearchApp.do?cmd=getResearchAppQuestionFormList",$("#researchSeq").serialize(),false);
		if( null == question)return;
		if(null == question.DATA || question.DATA.length < 1) return;
		question = question.DATA;

		var oIdx = 0;
		var rSeq = 0;
		var tmpTxt = "";
		var radioChk = false;
		for(var i=0; i < question.length; i++){
			rSeq = Number(question[i].questionSeq);
			if(oIdx != rSeq) {
				tmpTxt = titleTemp
						.replace("#no#",question[i].questionNo)
						.replace("#title#",question[i].questionNm)
				;
				$("#appContent").append(tmpTxt);
				oIdx = rSeq;
				if( question[i].questionItemCd == "10"){
					$("#appContent").append("<fieldset id='fieldset"+rSeq+"'></fieldset>");
				}
			}
			if(question[i].questionItemCd == "10"){
				tmpTxt = radioTemp
						.replace(/#qSeq#/g,rSeq)
						.replace(/#itemSeq#/g,question[i].itemSeq)
						.replace(/#itemNm#/g,question[i].itemNm)
						.replace(/#checked#/g,question[i].answer)
				;
				$("#fieldset"+rSeq).append(tmpTxt);
			}
			else if(question[i].questionItemCd == "20"){
				tmpTxt = checkTemp
						.replace(/#qSeq#/g,rSeq)
						.replace(/#itemSeq#/g,question[i].itemSeq)
						.replace(/#itemNm#/g,question[i].itemNm)
						.replace(/#checked#/g,question[i].answer)
				;
				$("#appContent").append(tmpTxt);
			}
			else if(question[i].questionItemCd == "30"){
				tmpTxt = textAreaTemp
						.replace(/#qSeq#/g,rSeq)
						.replace(/#text#/g,question[i].answer);
				;
				$("#appContent").append(tmpTxt);
			}
		}
	});

	function makeSendData(){
		var oIdx 	= 0;
		var rSeq 	= 0;
		var sendTxt = "";
		var deli	= ",";
		var deliEnd	= "@";
		var kcnt = 0;
		var ycnt = 0;
		var Txt = "";


		var chkCnt = 0;

		for(var i=0; i < question.length; i++){
			rSeq = Number(question[i].questionSeq);


			if(oIdx != rSeq) {
				chkCnt++;
				if(question[i].questionItemCd == "10"){
					$("[name='radio"+rSeq+"']:checked").each(function(){
						sendTxt +="10"+deli;
						sendTxt +=researchSeq+deli;
						sendTxt +=rSeq+deli;
						sendTxt +=$(this).val()+deli;
						sendTxt +=$(this).parent().find(".ctxt").html();
						sendTxt +=deliEnd;
						kcnt++;
					});
				}
				else if(question[i].questionItemCd == "20"){
					var gflag = "Y";

					$("[name='check"+rSeq+"']:checked").each(function(){
						sendTxt +="20"+deli;
						sendTxt +=researchSeq+deli;
						sendTxt +=rSeq+deli;
						sendTxt +=$(this).val()+deli;
						sendTxt +=$(this).parent().find(".ctxt").html();
						sendTxt +=deliEnd;
						if(gflag == "Y"){
							kcnt++;
							gflag = "N";
						}
					});


				}
				else if(question[i].questionItemCd == "30"){

					if(($("#textarea"+rSeq).val() !="")){
						sendTxt +="30"+deli;
						sendTxt +=researchSeq+deli;
						sendTxt +=rSeq+deli;
						sendTxt +="1"+deli;
						sendTxt +=$("#textarea"+rSeq).val();
						sendTxt +=deliEnd;
						if($("#textarea"+rSeq).val() !="" && $("#textarea"+rSeq).val() !="" ){
							ycnt++;
						}
					}
				}
				oIdx = rSeq;
			}
		}

		if (kcnt == 0 && ycnt == 0){
			Txt ="false";
		}else{
			Txt = sendTxt.substring(0,sendTxt.length-1);
		}



		if(chkCnt != kcnt+ycnt){
			Txt ="false";
		}

		return Txt ;
	}

	function save(){

		var data = makeSendData();
		if(data=="false"){
			alert("<msg:txt mid='109472' mdef='모든 질문에 답변을 선택 및 입력을 하셔야 합니다'/>");
			return;
		}else{
			$("#sendData").val(data);

			var rtn = ajaxCall("${ctx}/ResearchApp.do?cmd=saveResearchAppWriteForm",$("#form").serialize(),false);

			if(null != rtn && null != rtn.Result){
				if(rtn.Result.Message.length > 0) alert(rtn.Result.Message);
			}
			var returnValue = new Array(2);
			returnValue["result"] 	= "ok";

			const modal = window.top.document.LayerModalUtility.getModal('researchAppWriteFormLayer');
			modal.fire('researchAppWriteFormTrigger', {}).hide();

		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<form id="form" name="form" >
		<input id="researchSeq" name="researchSeq"  type="hidden"/>
		<input id="sendData" 	name="sendData" 	type="hidden"/>
	</form>
	<div class="modal_body survey-wrap">
		<div id="title" class="title"></div>
		<div id="appContent" class="support_scroll" style="line-height:15px;"></div>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('researchAppWriteFormLayer');" css="btn outline_gray" mid='close' mdef="닫기"/>
		<btn:a href="javascript:save();" css="btn filled" mid='ok' mdef="확인"/>
	</div>
</div>
</body>

</html>
