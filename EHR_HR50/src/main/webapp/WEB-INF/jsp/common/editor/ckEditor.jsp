<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title>공통신청 세부내역</title>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    <%--//CkEditor Setting--%>
    <script src="${ctx}/common/plugin/ckeditor5/ckeditor5-41.4.2/ckeditor.js"></script>
    <style>
        /*CkEditor Setting Style*/
        .ck-editor__editable {
            min-height: ${param.height}px;
            max-height: ${param.height}px;
        }
        .ck-source-editing-area textarea{
        	min-height: ${param.height}px;
            max-height: ${param.height}px;
            overflow:auto!important;
        }
    </style>
    <script type="text/javascript">
        //CKEDITOR 전역 선언
        window.top.CKEDITOR = CKEDITOR;

        var escapedHtml = `${param.modifyContents}`;
        var contents    = $('<div/>').html(escapedHtml).text();

        $(function() {
            window.modifyData = contents;
            var iframeHeight = document.body.scrollHeight;
            parent.iframeOnLoad(iframeHeight);
        });

        //--------------------------------------------------------------------------------
        //  임시저장 및 신청 시 호출
        //--------------------------------------------------------------------------------
        function setValue() {
            try {
                parent.$("#ckEditorContentArea").val(convertPxToPt(window.instanceEditor.getData()));
            } catch (ex){
                alert("Error!" + ex);
            }
        }

        function getValue() {
            return convertPxToPt(window.instanceEditor.getData());
        }

        function convertPxToPt(html) {
            return html.replace(/font-size:(\d+)px;/g, (match, pxValue) => {
                const ptValue = (pxValue * 0.75).toFixed(2); // 1px -> 0.75pt
                return `font-size:${'${ptValue}'}pt;`;
            });
        }
    </script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form name="editorForm" id="editorForm" method="post">
        <!-- ckEditor -->
        <input type="hidden" id="tmpEditorContentArea" name="tmpEditorContentArea">
        <%@ include file="/WEB-INF/jsp/common/plugin/Ckeditor/include_editor.jsp"%>
    </form>
</div>

</body>
</html>