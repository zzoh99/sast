<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<title>경력목표 세부내역</title>
<script type="text/javascript">

	$(function(){
		var careerTargetTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00001"), "");
		$("#searchCareerTargetType").html(careerTargetTypeCd[2]);

		const modal = window.top.document.LayerModalUtility.getModal('careerTargetDetailLayer');

		var careerTargetType = modal.parameters.careerTargetType || '';
		var useYn            = modal.parameters.useYn || '';
		var careerTargetNm   = modal.parameters.careerTargetNm || '';
		var careerTargetDesc = modal.parameters.careerTargetDesc || '';
		var g1StepDesc       = modal.parameters.g1StepDesc || '';
		var g1NeedDesc       = modal.parameters.g1NeedDesc || '';
		var g2StepDesc       = modal.parameters.g2StepDesc || '';
		var g2NeedDesc       = modal.parameters.g2NeedDesc || '';
		var g3StepDesc       = modal.parameters.g3StepDesc || '';
		var g3NeedDesc       = modal.parameters.g3NeedDesc || '';
		var limitCnt         = modal.parameters.limitCnt || '';

		$("#searchCareerTargetType").val(careerTargetType) ;
		$("#limitCnt").val(limitCnt) ;
		$("#useYn").val(useYn);
		$("#careerTargetNm").val(careerTargetNm);
		$("#careerTargetDesc").html(careerTargetDesc);

		// 숫자만 입력
		$("#bankNum,#companyNum,#faxNo,#telNo,#telHp").keyup(function() {
		     makeNumber(this,'A') ;
		 });
	
		if($("#nationalCd").val()!="") $("#nationalCd").val("KR").prop("selected",true);
	
	});

	function setValue() {
		let returnValue = {
			careerTargetType : $("#searchCareerTargetType").val(),
			useYn : $("#useYn").val(),
			careerTargetNm : $("#careerTargetNm").val(),
			careerTargetDesc : $("#careerTargetDesc").val(),
			g1StepDesc : $("#g1StepDesc").val(),
			g1NeedDesc : $("#g1NeedDesc").val(),
			g2StepDesc : $("#g2StepDesc").val(),
			g2NeedDesc : $("#g2NeedDesc").val(),
			g3StepDesc : $("#g3StepDesc").val(),
			g3NeedDesc : $("#g3NeedDesc").val(),
			limitCnt : $("#limitCnt").val()
		};

		const modal = window.top.document.LayerModalUtility.getModal('careerTargetDetailLayer');
		modal.fire('careerTargetDetailLayerTrigger', returnValue).hide();
	}
	
	var gPRow = "";
	var pGubun = "";
	
	// 팝업 클릭시 발생
	<%--function zipCodePopup() {--%>
	<%--	if(!isPopup()) {return;}--%>
	
	<%--	pGubun = "viewZipCodePopup";--%>
	<%--	openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");--%>
	<%--}--%>
	
	<%--//팝업 콜백 함수.--%>
	<%--function getReturnValue(returnValue) {--%>
	<%--	var rv = $.parseJSON('{' + returnValue+ '}');--%>
	
	<%--    if(pGubun == "viewZipCodePopup"){--%>
	<%--    	$("#zip").val(rv["zip"]);--%>
	<%--    	$("#curAddr1").html(rv["resDoroFullAddr"]);--%>
	<%--    }--%>
	<%--}--%>

</script>
</head>
<body class="bodywrap">
<form id="srchFrm" name="srchFrm" method="post">
<input type=hidden id="fileSeq"   	name="fileSeq">
</form>
<div class="wrapper modal_layer">
	<div class="modal_body">
		<table class="table">
			<colgroup>
				<col width="15%" />
				<col width="20%" />
				<col width="15%" />
				<col width="15%" />
				
			</colgroup>
			<tr>
				<th><tit:txt mid='' mdef='경력목표분류'/></th>
				<td>
					<%--<input id="eduOrgCd" name="eduOrgCd" type="hidden" class="text" style="width:50%;"/>--%>
					<select id="searchCareerTargetType" name="searchCareerTargetType">
					</select>

				</td>

				<th><tit:txt mid='' mdef='적정인원'/></th>
				<td>
					<input id="limitCnt" name="limitCnt" type="text" style="text-align:center;ime-mode:active;width:40px !important;"> 명
				</td>

				<th><tit:txt mid='' mdef='사용여부'/></th>
				<td>
					<select id="useYn" name="useYn" class="box2" >
						<option value="N">사용안함</option>
						<option value="Y">사용</option>
					</select>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='' mdef='경력목표'/></th>
				<td colspan="5">
					<%--<input id="eduOrgCd" name="eduOrgCd" type="hidden" class="text" style="width:50%;"/>--%>
					<input id="careerTargetNm" name="careerTargetNm" type="text" class="text" style="width:99%;"/>
				</td>
			</tr>

			<tr>
				<th><tit:txt mid='' mdef='경력목표 개요'/></th>
				<td colspan="5">
					<textarea id="careerTargetDesc" name="careerTargetDesc" rows="10" class="text w100p" ></textarea>

				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:setValue();" css="btn filled" mid='110716' mdef="확인"/>
		<btn:a href="javascript:closeCommonLayer('careerTargetDetailLayer');" css="gray large authR" mid='110881' mdef="닫기"/>
	</div>
</div>

</body>
</html>
