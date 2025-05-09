<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<!-- 상단 사진/기본정보 -->
<input type="hidden" id="setEmpLocaleCd" name="setEmpLocaleCd" value="${ssnLocaleCd}" />
<ul class="header_table outer">
<c:choose>
	<c:when test="${ssnGrpCd == '99'}">
		<li class="photo_group" style="padding-top:20px;">
	</c:when>
	<c:otherwise>
		<li class="photo_group">
	</c:otherwise>
</c:choose>
		<div class="represent_img">
			<img src="/common/images/common/img_photo.gif" alt="대표사진" id="userFace">
		</div>
		<form id="empForm" name="empForm" >
<c:choose>
	<c:when test="${ssnGrpCd == '99'}">
			<input type="hidden" id="searchKeyword" name="searchKeyword" />
			<div style="width:186px;"></div>
	</c:when>
	<c:otherwise>
			<p><input type="text"   id="searchKeyword"  		name="searchKeyword" class="represent_name" style="ime-mode:active"/><img src="/common/images/login/icon_search_g.png"/></p>
	</c:otherwise>
</c:choose>		
			<input type="hidden" id="searchEmpType"  		name="searchEmpType" value="I"/> <!-- Include에서  사용 -->
			<input type="hidden" id="searchStatusCd" 		name="searchStatusCd" value="A" /><!-- in ret -->
			<input type="hidden" id="searchUserEnterCd"   	name="searchUserEnterCd" value="${ssnEnterCd}" />
			<input type="hidden" id="searchUserId"   		name="searchUserId" value="${ssnSabun}" />
			<input type="hidden" id="searchEmpPayType"   	name="searchEmpPayType" value="" />
			<input type="hidden" id="searchCurrJikgubYmd"   name="searchCurrJikgubYmd" value="" />
			<input type="hidden" id="searchWorkYyCnt"   	name="searchWorkYyCnt" value="" />
			<input type="hidden" id="searchWorkMmCnt"   	name="searchWorkMmCnt" value="" />
			<input type="hidden" id="searchSabunRef" 		name="searchSabunRef" value="" />
			<input type="hidden" id="searchAuthUseYn"		name="searchAuthUseYn" value="${searchAuthUseYn}" />
			<input type="hidden" id="searchUserStatusCd"   	name="searchUserStatusCd" value="${ssnStatusCd}" />
		</form>
	</li>
	<li style="vertical-align:top;">
		<dl>
			<dt id="th1_1"><tit:txt mid='103975' mdef='사번'/></dt>
			<dd id="td1_1"><span id="tdSabun" class="point_txt"></span></dd>
		</dl>
		<dl>
			<dt id="th2_1">직급</dt>
			<dd id="td2_1">
				<span id="tdJikgubNm"></span>
				<input type=hidden id="headJikgubNm">
				<input type=hidden id="headJikgubCd">
			</dd>
		</dl>
		<dl>
			<dt id="th3_1">그룹입사일</dt>
			<dd id="td3_1"></dd>
		</dl>
		<dl>
			<dt id="th4_1">근무지</dt>
			<dd id="td4_1"></dd>
		</dl>
		<dl>
			<dt id="th5_1"></dt>
			<dd id="td5_1"></dd>
		</dl>		
	</li>
	<li style="vertical-align:top;">
		<dl>
			<dt id="th1_2">성명</dt>
			<dd id="td1_2"></dd>
		</dl>
		<dl>
			<dt id="th2_2">직책</dt>
			<dd id="td2_2">
			</dd>
		</dl>
		<dl>
			<dt id="th3_2">입사일</dt>
			<dd id="td3_2"></dd>
		</dl>
		<dl>
			<dt id="th4_2">소속발령일</dt>
			<dd id="td4_2"></dd>
		</dl>
		<dl>
			<dt id="th5_2"></dt>
			<dd id="td5_2"></dd>
		</dl>		
	</li>
	<li style="vertical-align:top;">
		<dl>
			<dt id="th1_3">직종</dt>
			<dd id="td1_3"></dd>
		</dl>
		<dl>
			<dt id="th2_3">직무</dt>
			<dd id="td2_3">
				<span id="tdJobNm"></span>
				<input type=hidden id="headJobCd">
				<input type=hidden id="headJobNm">
			</dd>
		</dl>
		<dl>
			<dt id="th3_3">퇴직일</dt>
			<dd id="td3_3"></dd>
		</dl>
		<dl>
			<dt id="th4_3">최종진급일</dt>
			<dd id="td4_3"></dd>
		</dl>
		<dl>
			<dt id="th5_3"></dt>
			<dd id="td5_3"></dd>
		</dl>		
	</li>
	<li style="vertical-align:top;">
		<dl>
			<dt id="th1_4">소속</dt>
			<dd id="td1_4">
				<span id="tdOrgNm"></span>
				<input type=hidden id="headOrgNm">
				<input type=hidden id="headOrgCd">
			</dd>
		</dl>
		<dl>
			<dt id="th2_4">재직상태</dt>
			<dd id="td2_4">
			</dd>
		</dl>
		<dl>
			<dt id="th3_4">채용구분</dt>
			<dd id="td3_4"></dd>
		</dl>
		<dl>
			<dt id="th4_4"></dt>
			<dd id="td4_4"></dd>
		</dl>
		<dl>
			<dt id="th5_4"></dt>
			<dd id="td5_4"></dd>
		</dl>		
	</li>
</ul>
	<%--
	<!-- //상단 사진/기본정보 end -->
	<table border="0" cellpadding="0" cellspacing="0" class="default outer">
	<colgroup>
		<col width="" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="11%" />
		<col width="" />
	</colgroup>
	<tr>
		<td rowspan="4" class="photo">
		<img src="/common/images/common/img_photo.gif" id="userFace" width="80" height="101" />
		</td>
		<th id="th1_1"><tit:txt mid='103880' mdef='성명'/></th>
		<td id="td1_1"><form id="empForm" name="empForm" >
			<input type="text"   id="searchKeyword"  		name="searchKeyword" class="text" style="ime-mode:active"/>
			<input type="hidden" id="searchEmpType"  		name="searchEmpType" value="I"/> <!-- Include에서  사용 -->
			<input type="hidden" id="searchStatusCd" 		name="searchStatusCd" value="A" /><!-- in ret -->
			<input type="hidden" id="searchUserEnterCd"   	name="searchUserEnterCd" value="" />
			<input type="hidden" id="searchUserId"   		name="searchUserId" value="${ssnSabun}" />
			<input type="hidden" id="searchEmpPayType"   	name="searchEmpPayType" value="" />
			<input type="hidden" id="searchCurrJikgubYmd"   name="searchCurrJikgubYmd" value="" />
			<input type="hidden" id="searchWorkYyCnt"   	name="searchWorkYyCnt" value="" />
			<input type="hidden" id="searchWorkMmCnt"   	name="searchWorkMmCnt" value="" />
			<input type="hidden" id="searchSabunRef" 		name="searchSabunRef" value="" />
			</form>
		</td>
		<th id="th1_2">사번 <span id="tdSabun" style="display:none;"></span></th>
		<td id="td1_2">
			<input type=hidden id="headName">	<!-- 사번은  searchUserId 사용 -->
		</td>
		<th id="th1_3"><tit:txt mid='103784' mdef='사원구분'/></th>
		<td id="td1_3"></td>
		<th id="th1_4">직종</th>
		<td id="td1_4"></td>



	</tr>
	<tr>
		<th id="th2_1"><tit:txt mid='104279' mdef='소속'/></th>
		<td id="td2_1">
			<span id="tdOrgNm"></span>
			<input type=hidden id="headOrgNm">
			<input type=hidden id="headOrgCd">
		</td>
		<th id="th2_2"><tit:txt mid='104471' mdef='직급'/></th>
		<td id="td2_2">
			<span id="tdJikgubNm"></span>
			<input type=hidden id="headJikgubNm">
			<input type=hidden id="headJikgubCd">
		</td>
		<th id="th2_3"><tit:txt mid='103785' mdef='직책'/></th>
		<td id="td2_3"></td>
		<th id="th2_4"><tit:txt mid='103973' mdef='직무'/></th>
		<td id="td2_4">
			<span id="tdJobNm"></span>
			<input type=hidden id="headJobCd">
			<input type=hidden id="headJobNm">
		</td>



	</tr>
	<tr>
		<th id="th3_1"><tit:txt mid='104472' mdef='재직상태'/></th>
		<td id="td3_1">
		</td>
		<th id="th3_2"><tit:txt mid='104473' mdef='그룹입사일'/></th>
		<td id="td3_2"></td>
		<th id="th3_3"><tit:txt mid='103881' mdef='입사일'/></th>
		<td id="td3_3"></td>
		<th id="th3_4"><tit:txt mid='104369' mdef='퇴직일'/></th>
		<td id="td3_4"></td>


	</tr>
	<tr>
		<th id="th4_1"><tit:txt mid='104280' mdef='채용구분'/></th>
		<td id="td4_1"></td>
		<th id="th4_2"><tit:txt mid='104281' mdef='근무지'/></th>
		<td id="td4_2"></td>
		<th id="th4_3"><tit:txt mid='103882' mdef='소속발령일'/></th>
		<td id="td4_3"></td>
		<th id="th4_4"><tit:txt mid='103974' mdef='최종진급일'/></th>
		<td id="td4_4"></td>

	</tr>
		<span id="hiddenEle"></span>
		<input type=hidden id="tdStatusCd"> <!-- 지울겁니다. inchuli.07.29  certiApp.jsp 에서 사용중 -->
		<input type=hidden id="headStatusCd">
		<input type=hidden id="headStatusNm">
	</table> --%>
