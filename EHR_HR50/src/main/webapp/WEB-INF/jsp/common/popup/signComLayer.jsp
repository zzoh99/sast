<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head><title>서명공통팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('signComLayer');
		$("#ifrmSignPad").on( function(){
			$("#ifrmSignPad").contents().find("#description").html("동의하시면 서명을 해주세요.");
			$("#ifrmSignPad").contents().find("#btnSave").html("동의");
		});
	});
	
	//사인패드 서명 후 리턴 
	function returnSignPad(rs){
		
		if(rs.FileSeq !== undefined && rs.FileSeq !== null && rs.FileSeq.length > 0) {
			
			var fileSeq=rs.FileSeq;

	    	var returnValue = new Array(1);
	 		returnValue["fileSeq"] = fileSeq;
	 		
	        const modal = window.top.document.LayerModalUtility.getModal('signComLayer');
	        modal.fire('signComTrigger', {
	        	fileSeq : fileSeq
	        }).hide();

		}else{
			alert("처리 중 오류가 발생했습니다.");
		}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<iframe id="ifrmSignPad" name="ifrmSignPad" src="/Popup.do?cmd=signPadPopup" style="border:0px; width:400px; height:200px;"></iframe>
		</div>        
		<div class="modal_footer">
            <btn:a href="javascript:closeCommonLayer('signComLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
        </div>
	</div>
</body>
</html>
