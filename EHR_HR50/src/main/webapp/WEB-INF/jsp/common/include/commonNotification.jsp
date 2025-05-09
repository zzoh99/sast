<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<c:if test="${ ssnNotificationUseYn eq 'Y' }">
<%--	<script type="text/javascript" src="/common/js/sockjs-client/sockjs.min.js"></script>--%>
	<script type="text/javascript" src="/common/js/commonAlert.js?ver=<%= System.currentTimeMillis() %>"></script>
	<div id="noti-floating">
		<div class="noti-title"><h2 id="notiTitle">noT</h2></div>
		<div class="noti-content"><h2 id="notiContent">noC</h2></div>
		<div class="noti-action">
			<a id="btnOpenNoti" href="javascript:goDirectRecentAlert(recentLink, recentSeq)" class="btn_popW pointer" >바로가기</a>
			<a id="btnReadRecNoti" href="javascript:readRecentAlert(recentSeq)" class="btn_popW pointer" >확인</a>
			<a id="btnDelRecNoti" href="javascript:deleteRecentAlert(recentSeq)" class="btn_popW pointer" >삭제</a>
		</div>
	</div>
</c:if>