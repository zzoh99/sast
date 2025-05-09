<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>교육목적 입력</title>
<script type="text/javascript">
var srchBizCd = null;
$(function() {
    const modal = window.top.document.LayerModalUtility.getModal('eduContentsNoteUpdateLayer');
	var arg = modal.parameters;
	var note = arg["note"];
	var noteText = note.replace(/<br>/gi, "\r\n");

	$("#note").val(noteText);
});

function setValue() {
	var rv = new Array();
	var str = $('#note').val().replace(/\n/g, "<br>");
	rv["note"]			= str;

    const modal = window.top.document.LayerModalUtility.getModal('eduContentsNoteUpdateLayer');
    modal.fire('eduContentsNoteUpdateLayerTrigger', rv).hide();
}

</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
			<p style="font-size:12px; color: red;">* 입력 후 저장을 해주세요 <p>
			<textarea id="note" name="note" class="w100p" style="height:149px; resize: none;"></textarea>
        </div>
        <div class="modal_footer">
            <btn:a href="javascript:closeCommonLayer('eduContentsNoteUpdateLayer');" css="btn outline_gray" mid='close' mdef="닫기"/>
            <btn:a href="javascript:setValue();" css="btn filled" mid='save' mdef="입력"/>
        </div>
    </div>
</body>
</html>