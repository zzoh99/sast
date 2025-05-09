<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='112573' mdef='설문지 상세 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/js/ui/jquery.progressbar.min.js" type="text/javascript" charset="utf-8"></script>
<style type="text/css">
		 .ctxt{font-size:12px; color:#5f6164; vertical-align:top;}
</style>

<script type="text/javascript">
var researchSeq	= null;
var researchNm	= null;

var titleTemp 	= "<tr class='popup_support01'><td><p>#no#.#title#</p></td><td align='right' style='cusor:hand;'><img id='#qSeq#X' src='${ctx}/common/images/icon/icon_up.png' class='up'/></td></tr>";
var textAreaTemp= "<tr name='tr#qSeq#X'><td colspan='2'><textarea id='textarea#qSeq#' style='width:99%;height:100px;' readonly>#text#</textarea></td> </tr>";
var checkTemp 	= "<tr name='tr#qSeq#X'><td style='align:left;width:79%'><label ><span class='ctxt'>#itemSeq#.#itemNm#</span></label></td><td style='align:left;width:20%;'><span class='progressBar' id='progress#qSeq#X#itemSeq#'></span></td></tr>";
var radioTemp 	= "<tr name='tr#qSeq#X'><td style='align:left;width:79%'><label ><span class='ctxt'>#itemSeq#.#itemNm#</span></label></td><td style='align:left;width:20%;'><span class='progressBar' id='progress#qSeq#X#itemSeq#'></span></td></tr>";

var question 	= null;
var questionDesc= null;
var p = eval("${popUpStatus}");

$(function(){
	var arg = p.popDialogArgumentAll();
	researchSeq = arg["researchSeq"];
	researchNm 	= arg["researchNm"];
 	$("#researchSeq").val(researchSeq);
 	$("#title").html(researchNm);
	$(".close").click(function(){
		p.self.close();
	});

	question 		= ajaxCall("${ctx}/ResearchApp.do?cmd=getResearchAppQuestionResultList",$("#researchSeq").serialize(),false);
	if( null == question)return;
	if(null == question.DATA || question.DATA.length < 1) return;
	question = question.DATA;

	questionDesc	= ajaxCall("${ctx}/ResearchApp.do?cmd=getResearchAppQuestionResultDescList",$("#researchSeq").serialize(),false);
	if( null == questionDesc)return;
	if(null == questionDesc.DATA || questionDesc.DATA.length < 1) return;
	questionDesc = questionDesc.DATA;

	var oIdx = 0;
	var rSeq = 0;
	var iSeq = 0;
	var tmpTxt = "";
	var desc = "";
	for(var i=0; i < question.length; i++){
		rSeq 	= Number(question[i].questionSeq);
		iSeq 	= Number(question[i].itemSeq);
		tmpTxt 	= "";
		if(oIdx != rSeq) {
			tmpTxt = titleTemp
				.replace(/#no#/g,question[i].questionNo)
				.replace(/#title#/g,question[i].questionNm)
				.replace(/#qSeq#/g,rSeq)
			;
			oIdx = rSeq;
			$("#progressTable").append(tmpTxt);
		}
		if(question[i].questionItemCd == "10"){
			tmpTxt = radioTemp
				.replace(/#qSeq#/g,rSeq)
				.replace(/#itemSeq#/g,iSeq)
				.replace(/#itemNm#/g,question[i].itemNm)
			;$("#progressTable").append(tmpTxt);
			$("#progress"+rSeq+"X"+iSeq).progressBar(Number(question[i].answerAverage));
		}
		else if(question[i].questionItemCd == "20"){
			tmpTxt = checkTemp
				.replace(/#qSeq#/g,rSeq)
				.replace(/#itemSeq#/g,iSeq)
				.replace(/#itemNm#/g,question[i].itemNm)
			;$("#progressTable").append(tmpTxt);
			$("#progress"+rSeq+"X"+iSeq).progressBar(Number(question[i].answerAverage));
		}
		else if(question[i].questionItemCd == "30"){
			desc = "";
			for(var x=0; x<questionDesc.length; x++){
				if(questionDesc[x].questionSeq == rSeq){
					desc += questionDesc[x].answer+"\n==========================================================\n";
				}
			}
			tmpTxt = textAreaTemp
				.replace(/#qSeq#/g,rSeq)
				.replace(/#text#/g,desc)
			;$("#progressTable").append(tmpTxt);
		}

	}
	$("img").click(function(){
		var id=$(this).attr("id");
		if($(this).attr("class")=="up"){
			$(this).removeClass("up").addClass("down");
			$(this).attr("src","${ctx}/common/images/icon/icon_down.png");
			$("[name=tr"+id+"]").hide();
		}else if($(this).attr("class")=="down"){
			$(this).removeClass("down").addClass("up");
			$(this).attr("src","${ctx}/common/images/icon/icon_up.png");
			$("[name=tr"+id+"]").show();
		}
	});
});
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='112919' mdef='설문지작성'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="title" class="txt"></li>
								<li class="btn">
								</li>
							</ul>
						</div>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<div id="appContent" class="support_scroll" style="line-height:15px;width:100%">
						<table id='progressTable' style='width:100%'>
						</table>
					</div>
				</td>
			</tr>

		</table>
		<form id="form" name="form" >
			<input id="researchSeq" name="researchSeq"  type="hidden"/>
			<input id="sendData" 	name="sendData" 	type="hidden"/>
		</form>



		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='close' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
