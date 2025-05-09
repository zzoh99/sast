<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113080' mdef='작업중 .. ' /></title>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>

<script>
     //최대 업로드 파일 갯수
    var fileMaxCnt = "";
    var initRowCnt;
    var fileSeq = "";
    //종류가 많아지면 상수화 필요성 있어보임.
    var msgDiv = 999;
    var arrParam = null ;
    
    $(function() {
        const modal = window.top.document.LayerModalUtility.getModal('fileMgrLayer');
        arrParam = {  cmd:        modal.parameters.cmd
                    , authPg:     modal.parameters.authPg
                    , uploadType: modal.parameters.uploadType
                   };
        
        fileSeq    = modal.parameters.fileSeq || '';
        fileMaxCnt = modal.parameters.fileMaxCnt || '';

        const tempAuthPg = arrParam.authPg ? arrParam.authPg : "${authPg}";
        const uploadType = arrParam.uploadType ? arrParam.uploadType : "${paramMap.uploadType}";
        initFileUploadIframe("fileLayerUploadForm", fileSeq, uploadType, tempAuthPg);

        if (tempAuthPg === 'R') {
            $("a#uploadBtn").hide();
            $("a#deleteBtn").hide();
            $("div#DIV_mainUpload").hide();
        }

    });

    function comfirmFileUploadPop(flag) {
        var fileCheck = "non";
        var fileCnt = 0;
        var attFileCnt = getFileUploadContentWindow("fileLayerUploadForm").getFileList();
        if (attFileCnt.length > 0) {
            fileCheck = "exist";
        }

        const modal = window.top.document.LayerModalUtility.getModal('fileMgrLayer');

        if (fileMaxCnt != "") {
            if (Number(attFileCnt.length) != Number(fileMaxCnt)) {
                if (flag == "close") {
                	modal.hide();
                } else {
                    return alert("<msg:txt mid='alertfileUpload2' mdef='해당 항목은 파일업로드가 필수 입니다.'/>");
                }
            }
        }  
		if (flag == 'confirm') {
	        modal.fire('fileMgrTrigger', {
	              fileSeq : getFileUploadContentWindow("fileLayerUploadForm").getFileSeq()
	            , fileCheck : fileCheck
	        }).hide();	
		} else {
			modal.hide();
		}
    }
</script>

</head>
<c:set var="fileSheetHeight" value="100%" />
<div class="wrapper modal_layer">
    <div class="modal_body">
        <iframe id="fileLayerUploadForm" name="fileLayerUploadForm" frameborder="0" class="author_iframe" style="height:250px;"></iframe>
    </div>
    <div class="modal_footer">
	    <btn:a href="javascript:comfirmFileUploadPop('close');"   css="btn outline_gray" mid='110881' mdef="닫기"/>
	    <btn:a href="javascript:comfirmFileUploadPop('confirm');" css="btn filled" mid='110716' mdef="확인"/>
     </div>
</div>
</body>
</html>