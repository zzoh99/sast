<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
function main_listBox12(title, info, classNm, seq){

	$("#listBox12").attr("seq", seq);

	$.ajax({
		url 		: "${ctx}/getListBox12List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list = rv.DATA;
			var tmp = "<tr #URL# alt='#BTITLE#' title='#BTITLE#'><th><div class='limit'><a href='#' #RECLASS#>#BTITLE#</a></div></th><td>#BDATE#</td></tr>";
			var str = "";
			for(var i=0; i<list.length; i++){
				tabInfo  = "bbsSeq='"+list[i].bbsSeq+"' ";
				tabInfo += "bbsCd='"+list[i].bbsCd+"' ";

				str += tmp.replace(/#URL#/g,tabInfo)
				          .replace(/#BTITLE#/g,list[i].title)
				          .replace(/#RECLASS#/g,((list[i].depth=="1") ? "class='reply'":""))
				          .replace(/#BDATE#/g,list[i].regDate);
			}
			//$(".notice_table").append(str);
			$("#qnaT").append(str);
			$("#qnaT tr").click(function(event) {

				if( $(this).attr("bbsSeq") != undefined ) {
					mainOpenNotice( $(this).attr("bbsCd")
								   ,$(this).attr("bbsSeq"));
				}
			});
			// 더보기 링크 클릭 이벤트
			$("#qnaWidget").click(function() {
				var goPrgCd = "/Board.do?cmd=viewBoardList||bbsCd=10030";
				goSubPage("11","","","",goPrgCd);
			});
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}
function mainOpenNotice(bbsCd,bbsSeq ){
	if(!isPopup()) {return;}
    var url 	= "/Board.do?cmd=viewBoardReadPopup&";
	var args 	= new Array();

	args["bbsCd"]  = bbsCd;
	args["bbsSeq"] = bbsSeq;
	args["bbsNm"]  = "묻고답하기";

	openPopup(url,args, "940","780");
}
</script>
<div id="listBox12" lv="12" title="묻고 답하기" info="HR 관련 질문과 대답" class="notice_box">
	<div class="bg"></div>
	<div class="main">
		<ul class="header">
			<li class="title">묻고답하기</li>
			<li id="qnaWidget"><a ><img src="/common//images/main/ico_notice_link.gif" /></a></li>
		</ul>
		<!--  로딩 s -->
		<div class="main_loading">
			<img src="/common/images/common/top_change.gif"/>
		</div>
		<!--  로딩 e -->
		<table id="qnaT" class="notice_table">
		</table>
	</div>

</div>
