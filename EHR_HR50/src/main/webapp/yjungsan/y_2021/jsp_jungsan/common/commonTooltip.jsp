<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>

<style type="text/css">
	.tooltip_custom { vertical-align: middle; }
	.ui-tooltip-custom { padding: 10px; border: 4px solid #ddd; border-radius: 5px; background:#fff; }
	
</style>

<script type="text/javascript">
<!--
// 계산내역 ToolTip 셋팅 공통함수
function setTooltip_yjungsan(objId, text) {
    $(".tooltip_custom").tooltip({
    	content: function() {
    		return $(this).prop("title");
    	},
        tooltipClass: "ui-tooltip-custom"
    });

    // src속성이 있으면 유지, 없으면 default src속성 셋팅.
    if($("#"+objId).attr("src") == null || $("#"+objId).attr("src") == "undefined") {
		$("#"+objId).attr("src", "/yjungsan/common_jungsan/images/icon/icon_excla.png");
	}

	$("#"+objId).attr("title", text);
}
//-->
</script>
