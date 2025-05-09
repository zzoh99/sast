<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
function main_listBox7(title, info, classNm, seq ){

	$("#listBox7").attr("seq", seq);

	$.ajax({
		url 		: "${ctx}/getListBox7List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list = rv.DATA;
			var tmp = "<tr #URL# alt='#BTITLE#' title='#BTITLE#'><th><div class='limit'><a href='#'>#BTITLE#</a></div></th><td>#BDATE#</td></tr>";
			var str = "";
			for(var i=0; i<list.length; i++){
				tabInfo  = "bbsSeq='"+list[i].bbsSeq+"' ";
				tabInfo += "bbsCd='"+list[i].bbsCd+"' ";

				str += tmp.replace(/#URL#/g,tabInfo)
				          .replace(/#BTITLE#/g,list[i].title)
				          .replace(/#BDATE#/g,list[i].regDate);
			}
			//$(".notice_table").append(str);
			$("#guide").append(str);
			$("#guide tr").click(function(event) {

				if( $(this).attr("bbsSeq") != undefined ) {
					mainOpenNotice( $(this).attr("bbsCd")
								   ,$(this).attr("bbsSeq"));
				}
			});
			// 더보기 링크 클릭 이벤트
			$("#hrGuide").click(function() {
				var goPrgCd = "/Board.do?cmd=viewBoardList||bbsCd=10009";
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
    //var url 	= "/Board.do?cmd=viewBoardReadPopup&";
    //var $form = $('<form></form>');
    //$form.appendTo('body');
    //var param1 	= $('<input name="bbsCd" 	type="hidden" 	value="'+bbsCd+'">');
    //var param2 	= $('<input name="bbsSeq" 	type="hidden" 	value="'+bbsSeq+'">');

    //$form.append(param1).append(param2);
    //url +=$form.serialize() ;
    //openPopup(url, self, "940","780");

	var url 	= "/Board.do?cmd=viewBoardReadPopup&";
	var args 	= new Array();

	args["bbsCd"]  = bbsCd;
	args["bbsSeq"] = bbsSeq;
	args["bbsNm"]  = "HR 가이드";

	openPopup(url,args, "940","780");
}
</script>

						<div id="listBox7" lv="7" info="HR 가이드" class="notice_box">
							<div class="bg"></div>
							<div class="main">
								<ul class="header">
									<li class="title">HR 가이드</li>
									<li id="hrGuide">
										<btn:  mid='111532' mdef="더 보기"/>
										<img src="/common/images/main/ico_notice_link.gif" />
									</li>
								</ul>
								<!--  로딩 s -->
								<div class="main_loading">
									<img src="/common/images/common/top_change.gif"/>
								</div>
								<!--  로딩 e -->
								<table id="guide" class="notice_table">
								</table>
							</div>
						</div>
