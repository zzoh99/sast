<%---------------------------------------- 변수 설정 ----------------------------------------%>

<c:set var="searchSabun"			value="${param.searchSabun}" />
<c:set var="searchApplSabun"		value="${param.searchApplSabun}" />
<c:set var="searchApplSeq"			value="${param.searchApplSeq}" />
<c:set var="authPg"					value="${param.authPg}" />
<c:set var="adminYn"				value="${param.adminYn}" />
<c:set var="searchApplCd"			value="${param.searchApplCd}" />
<c:set var="searchApplYmd"			value="${param.searchApplYmd}" />
<c:set var="etc01"					value="${param.etc01}" />
<c:set var="etc02"					value="${param.etc02}" />
<c:set var="etc03"					value="${param.etc03}" />

<c:choose>
	<c:when test="${authPg == 'A'}">
		<c:set var="textCss"		value="text" />
		<c:set var="dateCss"  		value="date2" />
		<c:set var="selectDisabled"	value="" />
		<c:set var="radioDisabled"	value="" />
		<c:set var="disabled"		value="" />
		<c:set var="readonly" 		value="" />
		<c:set var="editable" 		value="1" />
		<c:set var="selectCss" 		value="" />
		<c:set var="required" 		value="required" />
	
		<c:set var="sDelTy" value="DelCheck"/><c:set var="sDelHdn" value="0" /><c:set var="sDelWdt" value="55" />
		<c:set var="sRstTy" value="Result" 	/><c:set var="sRstHdn" value="1" /><c:set var="sRstWdt" value="0" />
		<c:set var="sSttTy" value="Status" 	/><c:set var="sSttHdn" value="0" /><c:set var="sSttWdt" value="45" />
	</c:when>
	<c:otherwise>
		<c:set var="textCss" 		value="text transparent" />
		<c:set var="dateCss" 		value="date2 transparent" />
		<c:set var="selectDisabled"	value="disabled" />
		<c:set var="radioDisabled"	value="disabled" />
		<c:set var="disabled"		value="disabled" />
		<c:set var="readonly" 		value="readonly" />
		<c:set var="editable" 		value="0" />
		<c:set var="selectCss" 		value="transparent hideSelectButton " />
		<c:set var="required" 		value="" />

		<c:set var="sDelTy" value="DelCheck"/><c:set var="sDelHdn" value="1" /><c:set var="sDelWdt" value="0" />
		<c:set var="sRstTy" value="Result" 	/><c:set var="sRstHdn" value="1" /><c:set var="sRstWdt" value="0" />
		<c:set var="sSttTy" value="Status" 	/><c:set var="sSttHdn" value="1" /><c:set var="sSttWdt" value="0" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${adminYn == 'Y'}">
		<c:set var="adminTextCss"		value="text" />
		<c:set var="adminDateCss"		value="date2" />
		<c:set var="adminReadonly" 		value="" />
		<c:set var="adminDisabled"		value="" />
		<c:set var="adminSelectCss" 	value="" />
	</c:when>
	<c:otherwise>
		<c:set var="adminTextCss" 		value="text transparent" />
		<c:set var="adminDateCss"		value="date2 transparent" />
		<c:set var="adminReadonly" 		value="readonly" />
		<c:set var="adminDisabled"		value="disabled" />
		<c:set var="adminSelectCss" 	value="transparent hideSelectButton " />
	</c:otherwise>
</c:choose>
