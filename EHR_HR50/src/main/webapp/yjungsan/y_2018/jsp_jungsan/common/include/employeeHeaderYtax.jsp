<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.StringUtil"%>
<%
	String readOnlyParam = request.getParameter("readonly");
%>
	<script src="../../../common_jungsan/js/employeeHeaderYtax.js" type="text/javascript" charset="<%=StringUtil.getPropertiesValue("SYS.ENC")%>"></script>

	<table id="emplyeeHeader" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="10%" />
		<col width="11%" />
		<col width="10%" />
		<col width="11%" />
		<col width="10%" />
		<col width="11%" />
		<col width="" />
	</colgroup>
	<tr>
		<th>성명</th>
		<td>
			<form id="empForm" name="empForm" > 
			<input type="text"   id="searchKeyword"  name="searchKeyword" class="text <%=removeXSS(readOnlyParam, '1')%>" style="ime-mode:active" <%=removeXSS(readOnlyParam, '1')%>/>
			<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="A" />
			<input type="hidden" id="searchUserId"   name="searchUserId" value="<%=removeXSS(session.getAttribute("ssnSabun"), '1')%>" />
			<input type="hidden" id="searchRegNo_" 	 name="searchRegNo_">
			</form>
		</td>
		<th>사번</th>
		<td id="tdSabun"></td>
		<th>주민번호</th>
		<td id="tdResNo"></td>
	</tr>
	<tr>
		<th>부서</th>
		<td id="tdOrgNm"></td>
		<th>입/퇴사일</th>
		<td><span id="tdEmpYmd"></span> / <span id="tdRetYmd"></span></td>
		<th>상태</th>
		<td id="tdStatusView"></td>
	</tr>
	</table>