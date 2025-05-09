<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
function main_listBox13(title, info, classNm, seq){

	$("#listBox13").attr("seq", seq);

	/*
	$.ajax({
		url 		: "${ctx}/getListBox13List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list = rv.DATA;
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
	*/
}
function mainOpenNotice(bbsCd,bbsSeq ){

}

$(function() {
	$(".visitingSite").find("div").click( function() {
		var obj = $(this).find("span");
		var url = obj.attr("url");

		if(this.className =="shuttlebus"){
			winPrintPopup(url,"","404","425");
		} else {
			if(url)
				goUrl(url) ;
		}
	});
});
function goUrl(url) {
	if( url == "" ) return ;
	window.open(url) ;
}

</script>
<div id="listBox13" lv="13" info="자주 방문하는 사이트" class="notice_box">
	<div class="bg"></div>
	<div class="main">
		<ul class="header">
			<li class="title">자주 방문하는 사이트</li>
		</ul>
		<!--  로딩 s -->
		<div class="main_loading">
			<img src="/common/images/common/top_change.gif"/>
		</div>
		<!--  로딩 e -->
		<div class="visitingSite widget_con_Wrap">
<!-- 			<div class="mainsite"><span url="http://www.jejuair.net/">제주항공</span></div> -->
<!-- 			<div class="cvs"><span url=" http://vcs.jejuair.net/">화상 솔루션</span></div> -->
<!-- 			<div class="shuttlebus"><span url="http://gw.aekyung.kr/bb/bb_bus_calendar_20101124.jpg">셔틀버스</span></div> -->
<!-- 			<div class="eureka"><span>e-유레카</span></div> -->
			<div class="building"><span url="http://www.idongsung.com/">동성누리</span></div>
			<div class="reading"><span url="http://book.interpark.com/">독서경영</span></div>
<!-- 			<div class="av"><span url="http://www.jejuairav.com/xe/">JEJUAIRAV</span></div> -->
<!-- 			<div class="itservice"><span url="http://itsm.akis.co.kr/main/requestMain.do;jsessionid=384FB6325BBE56ABDF866F60185B2A65">통합IT서비스</span></div> -->
		</div>
	</div>
</div>
