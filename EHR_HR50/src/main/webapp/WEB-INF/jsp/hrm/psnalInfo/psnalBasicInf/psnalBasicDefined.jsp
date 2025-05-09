<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%---------------------------------------- 인사기본 탭 권한 설정 ----------------------------------------%>
<c:choose>
	<c:when test="${authPg == 'A'}">
		<c:set var="textCss"	value="text" />
		<c:set var="dateCss"  	value="date2" />
		<c:set var="readonly" 	value="" />
		<c:set var="editable" 	value="1" />
		
		<c:set var="sDelTy" value="DelCheck"/><c:set var="sDelHdn" value="0" /><c:set var="sDelWdt" value="55" />
		<c:set var="sRstTy" value="Result" 	/><c:set var="sRstHdn" value="1" /><c:set var="sRstWdt" value="0" />
		<c:set var="sSttTy" value="Status" 	/><c:set var="sSttHdn" value="0" /><c:set var="sSttWdt" value="45" />
	</c:when>
	<c:otherwise>
		<c:set var="textCss" 	value="text transparent" />
		<c:set var="dateCss" 	value="text transparent" />
		<c:set var="readonly" 	value="readonly" />
		<c:set var="editable" 	value="0" />

		<c:set var="sDelTy" value="DelCheck"/><c:set var="sDelHdn" value="1" /><c:set var="sDelWdt" value="0" />
		<c:set var="sRstTy" value="Result" 	/><c:set var="sRstHdn" value="1" /><c:set var="sRstWdt" value="0" />
		<c:set var="sSttTy" value="Status" 	/><c:set var="sSttHdn" value="1" /><c:set var="sSttWdt" value="0" />
	</c:otherwise>
</c:choose>
