<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp" %>
<script type="text/javascript">
    $(function() {
        const modal = window.top.document.LayerModalUtility.getModal('wtmHolidayDeleteLayer'); //모달 선언시 사용한 ID
        const params = modal.parameters;

        init(params);
    });

    async function init(params) {
        if (params) {
            if (params.existsAftYn === "Y") {
                $("#radiog2").parent().show();
            } else {
                $("#radiog2").parent().hide();
            }
        }
    }

    function deleteHoliday() {
        const modal = window.top.document.LayerModalUtility.getModal('wtmHolidayDeleteLayer'); //모달 선언시 사용한 ID
        modal.fire('wtmHolidayDeleteLayerTrigger', {
            type: $('input[name="radiog"]:checked').val(),
        }).hide();
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <ul class="del-radio-wrap">
            <li>
                <input type="radio" name="radiog" id="radiog1" class="form-radio" value="current" checked/>
                <label for="radiog1">해당 일정만</label>
            </li>
            <li style="display: none;">
                <input type="radio" name="radiog" id="radiog2" class="form-radio" value="current_future"/>
                <label for="radiog2">해당 일정 및 향후 일정</label>
            </li>
            <li>
                <input type="radio" name="radiog" id="radiog3" class="form-radio" value="all"/>
                <label for="radiog3">모든 일정</label>
            </li>
        </ul>
    </div>
    <div class="modal_footer">
        <a href="javascript:deleteHoliday();" class="btn filled">삭제</a>
    </div>
</div>
</body>
</html>



