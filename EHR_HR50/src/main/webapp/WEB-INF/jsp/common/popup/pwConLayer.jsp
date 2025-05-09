<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {

		//레이어 숨김
		$(".returnDiv").hide();

		//로그인 아이디 패스워드 엔터 체크
		$("#confirmPwd").bind("keyup",function(event){
			if( event.keyCode == 13 ){
				goConfirm();
			}
		});

		//입력할때 레이어 숨김
		$("#confirmPwd").keypress(function(e) {
			$(".returnDiv").hide();
		});
	});


	function goConfirm(){

		if($("#confirmPwd").val() == "") {
			$("#confirmPwd").focus();
			return;
		}

		var count = ajaxCall("${ctx}/UserMgr.do?cmd=pwdConfirm",$("#srchFrm").serialize(),false);
		if(count.result != null && count.result != "undefine") count = count.result[0].cnt;

		if(count == 0){
	        $(".returnDiv").show();
	    	$("#confirmPwd").focus();
		} else if(count > 0){

			const modal = window.top.document.LayerModalUtility.getModal('pwConLayer');
			modal.fire('pwConLayerTrigger', {
				result : "Y"
			}).hide();
		} else {
			alert("결과가 존재하지 않습니다.");
		}
	}
</script>

<body>

<div class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<div class="popup_password">
				<form id="srchFrm" name="srchFrm" >
					<table border="0" cellpadding="0" cellspacing="0" class="default">
						<tr>
							<th><span><tit:txt mid='103915' mdef='이름'/></span></th>
							<td><span>${ssnName}</span></td>
						</tr>

						<tr>
							<th><span><tit:txt mid='103975' mdef='사번'/></span></th>
							<td><span>${ssnSabun}</span></td>
						</tr>
						<tr>
							<th><span><tit:txt mid='113098' mdef='비밀번호'/></span></th>
							<td><input type="password" name="confirmPwd" id="confirmPwd"></td>
						</tr>
					</table>
				</form>

				<div class="returnDiv">
					<img src="/common/images/icon/icon_excla.png" />비밀번호가 일치하지 않습니다.
				</div>
			</div>
		</div>
		<div class="modal_footer">
			<a href="javascript:goConfirm();" class="btn filled"><tit:txt mid='pwdConfirmPop' mdef='비밀번호 확인'/></a>
			<btn:a href="javascript:closeCommonLayer('pwConLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
	</div>
</div>

</body>
</html>
