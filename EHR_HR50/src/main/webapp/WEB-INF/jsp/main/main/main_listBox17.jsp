<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script type="text/javascript">
function main_listBox17(title, info, classNm, seq ){

	$("#listBox17").attr("seq", seq);

	$.ajax({
		url 		: "${ctx}/getListBox17List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list = rv.DATA;

			if ( list != null ){

				var missionHri = list[0].coreObject;

				$("#missionHri").html("<li>" + missionHri + "</li>");
			}
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});

}
</script>

	<div id="MissionHorizon" lv="17" title="핵심목적" info="핵심목적" class="notice_box" >
		<div >
			<ul class="tt1 header">
				<li class="title" id="title_li17">
					핵심목적
				</li>
			</ul>
			<ul class="tt2" >
				<li>
					<ul id="missionHri">

					</ul>
				</li>
			</ul>
		</div>
	</div>

