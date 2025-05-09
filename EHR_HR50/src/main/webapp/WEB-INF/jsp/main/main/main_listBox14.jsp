<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
function main_listBox14(title, info, classNm, seq){

	$("#listBox14").attr("seq", seq);

	$.ajax({
		url 		: "${ctx}/getListBox14List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list = rv.DATA;
			if(list.length > 0){
				$("#pass").text(list[0].passEYmd);
			}
			if(list.length > 1){
				$("#visa").text(list[1].passEYmd);
			}
			if(list.length > 2){
				$("#epta").text(list[2].passEYmd);
			}
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
<div id="listBox14" lv="14" info="체크리스트" class="notice_box">
	<div class="bg">
		<div class="ico_write"></div>
	</div>
	<div class="main ">
		<ul class="header">
			<li class="title">체크리스트</li>
		</ul>
		<!--  로딩 s -->
		<div class="main_loading">
			<img src="/common/images/common/top_change.gif"/>
		</div>
		<!--  로딩 e -->
		<table class="pay_table">
		<colgroup>
			<col width="90" />
			<col width="" />
		</colgroup>
		<tr class="title">
			<td>TO/LD Recency</td>
			<td class="left">(yyyy.mm.dd)</td>
		</tr>
		<tr>
			<td class="strong">PASSPORT</td>
			<td id="pass"></td>
		</tr>
		<tr>
			<td class="strong">US VISA</td>
			<td id="visa"></td>
		</tr>
		<tr>
			<td class="strong">ICAO ENG</td>
			<td id="epta"></td>
		</tr>
		</table>
	</div>
</div>
