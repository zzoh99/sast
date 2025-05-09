<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
function main_listBox18(title, info, classNm, seq ){

	$("#listBox18").attr("seq", seq);

	$.ajax({
		url 		: "${ctx}/getListBox18List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list = rv.DATA;

			if ( list != null ){

				var visionHori = list[0].coreValue;

				$("#visionHori").html("<li>" + visionHori + "</li>");
			}
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}
</script>

	<div id="VisionHorizon" lv="18" title="핵심가치" info="핵심가치" class="notice_box">
		<div >
			<ul class="tt1 header">
				<li class="title" id="title_li18">
					핵심가치
				</li>
			</ul>
			<ul class="tt2" >
				<li>
					<ul id="visionHori">
					</ul>
				</li>
			</ul>
		</div>
	</div>
