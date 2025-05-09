<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

	<table cellpadding="0" cellspacing="0" class="default outer">
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
		<th><tit:txt mid='103880' mdef='성명'/></th>
		<td>
			<form id="empForm" name="empForm" > 
			<input type="text"   id="searchKeyword"  name="searchKeyword" class="text" style="ime-mode:active"/>
			<input type="hidden" id="searchEmpType"  name="searchEmpType" value="I"/> <!-- Include에서  사용 -->
			<input type="hidden" id="searchStatusCd" name="searchStatusCd" value="A" /><!-- in ret -->
			<input type="hidden" id="searchUserId"   name="searchUserId" value="${ssnSabun}" />
			<input type="hidden" id="searchRegNo_" 	 name="searchRegNo_">
			</form>
		</td>
		<th><tit:txt mid='103975' mdef='사번'/></th>
		<td id="tdSabun"></td>
		<th><tit:txt mid='103883' mdef='주민번호'/></th>
		<td id="tdResNo"></td>
	</tr>
	<tr>
		<th><tit:txt mid='104279' mdef='소속'/></th>
		<td id="tdOrgNm" colspan="3"></td>
		<th><tit:txt mid='103881' mdef='입사일'/></th>
		<td id="tdEmpYmd"></td>
	</tr>
	<tr>
		<th><tit:txt mid='103786' mdef='상태'/></th>
		<td id="tdStatusView" colspan="3"></td>
		<th><tit:txt mid='104090' mdef='퇴사일'/></th>
		<td id="tdRetYmd"></td>
	</tr>
	</table>
