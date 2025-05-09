<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>업적평가표생성관리PopUp</title>

<script type="text/javascript">
	<%--var p 	= eval("${popUpStatus}");--%>
	// var arg = p.popDialogArgumentAll();
	var authPg	= "";
	var modal = "";
	$(function(){
		modal = window.top.document.LayerModalUtility.getModal('mboTargetRegPopDetailLayer');

		$(".close").click(function() 	{ closeCommonLayer('mboTargetRegPopDetailLayer'); });

		/* 190529 사용안함처리 : IDS의 경우 MBO 목표유형으로 사용함.
		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"), ""); // 평가지표구분(P00011)
		$("#appIndexGubunCd").html( comboList1[2] );
		*/
		
		var comboListMboType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10009"), ""); // 목표구분(P10009)
		$("#mboType").html( comboListMboType[2] );

		$("#mboTarget").maxbyte(1000);
		$("#kpiNm").maxbyte(1000);
		$("#formula").maxbyte(2000);
		$("#remark").maxbyte(2000);
		$("#mboMidAppResult").maxbyte(1000);
		$("#mboMidApp1stMemo").maxbyte(1000);

		// 숫자만 입력가능
		$("#orderSeq, #weight").keyup(function() {
			makeNumber(this,'A');
		});

		// if( arg != "undefined" ) {
			authPg = modal.parameters.authPg;

			$("#searchAppraisalCd").val(modal.parameters.searchAppraisalCd);
			$("#searchAppStepCd").val(modal.parameters.searchAppStepCd);
			$("#searchAppSeqCd").val(modal.parameters.searchAppSeqCd);
			$("#searchAppStatusCd").val(modal.parameters.searchAppStatusCd);
			$("#orderSeq").val(modal.parameters.orderSeq);
			$("#appIndexGubunNm").val(modal.parameters.appIndexGubunNm);
			$("#mboTarget").val(modal.parameters.mboTarget);
			$("#kpiNm").val(modal.parameters.kpiNm);
			$("#formula").val(modal.parameters.formula);
			$("#baselineData").val(modal.parameters.baselineData);
			$("#sGradeBase").val(modal.parameters.sGradeBase);
			$("#aGradeBase").val(modal.parameters.aGradeBase);
			$("#bGradeBase").val(modal.parameters.bGradeBase);
			$("#cGradeBase").val(modal.parameters.cGradeBase);
			$("#dGradeBase").val(modal.parameters.dGradeBase);
			//$("#weight").val(Number(modal.parameters.weight).toFixed();
			$("#weight").val(modal.parameters.weight);
			$("#remark").val(modal.parameters.remark);
			$("#seq").val(modal.parameters.seq);

			if( modal.parameters.searchAppStepCd == "3" ){
				$("#tr_mboMidAppResult").show();
				$("#mboMidAppResult").val(modal.parameters.mboMidAppResult);
				
				if(modal.parameters.searchAppSeqCd == "" || modal.parameters.searchAppSeqCd == "1") {
					$("#tr_mboMidApp1stMemo").show();
					$("#mboMidApp1stMemo").val(modal.parameters.mboMidApp1stMemo);
					
					// 본인의 목표 및 중간점검 입력 및 수정인 경우
					if(authPg == "A" && modal.parameters.searchAppSeqCd == "") {
						// 승인자 의견 편집 불가능
						if( !$("#mboMidApp1stMemo").hasClass("transparent") ) {
							$("#mboMidApp1stMemo").addClass("transparent");
						}
						if( !$("#mboMidApp1stMemo").hasClass("readonly") ) {
							$("#mboMidApp1stMemo").addClass("readonly");
						}
						$("#mboMidApp1stMemo").attr("readonly", "readonly");
					}
				}
			}

			/* IDS 추가 */
			$("#mboType").val(modal.parameters.mboType);
			//$("#deadlineType").val(arg["deadlineType"]);
			//$("#deadlineTypeTo").val(arg["deadlineTypeTo"]);
			
			//$("#deadlineType").datepicker2({ymonly:true});
			//$("#deadlineTypeTo").datepicker2({ymonly:true});
			
			//if ( arg["seq"] != "" ) {
			//	$("#appIndexGubunCd").attr("readonly", true);
			//	$("#appIndexGubunCd").attr("disabled", true);
			//	$("#appIndexGubunCd").addClass( 'readonly' );
			//}
		// }

		if (authPg == "R"){
			$("#closeYn").addClass("hide");
		}
		
		// [무신사 추가] 중간점검 승인요청 상태에서  1차 평가자의 접근인 경우
		if ( modal.parameters.searchAppStepCd == "3" && modal.parameters.searchAppSeqCd == "1" && modal.parameters.searchAppStatusCd == "21" ) {
			// 승인자 의견 편집 가능
			$("#mboMidApp1stMemo").removeClass("transparent");
			$("#mboMidApp1stMemo").removeClass("readonly");
			$("#mboMidApp1stMemo").removeAttr("readonly");
			
			if($("#closeYn").hasClass("hide")) {
				$("#closeYn").removeClass("hide");
			}
		}
		
		////평가등급기준
		//var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, ""); // 평가등급
		//var clsLst = classCdList[0].split("|");
		//for( var i=0; i<clsLst.length; i++){
		//	$("#thClassCd"+(i+1)).html(clsLst[i]);
		//}
		//var len = clsLst.length;
		//if(classCdList[0] == "" ) len = 0;
		//for( var i=4; len<=i; i--){
		//	$("#thClassCd"+(i+1)).hide();
		//	$("#tdClassCd"+(i+1)).hide();
		//}
	});

	// 리턴함수
	function setValue(){
		var returnValue = new Array(7);

		returnValue["orderSeq"] = $("#orderSeq").val();
		//returnValue["appIndexGubunCd"] = $("#appIndexGubunCd").val();
		returnValue["appIndexGubunNm"] = $("#appIndexGubunNm").val();
		returnValue["mboTarget"] = $("#mboTarget").val();
		returnValue["kpiNm"] = $("#kpiNm").val();
		returnValue["formula"] = $("#formula").val();
		returnValue["baselineData"] = $("#baselineData").val();
		returnValue["sGradeBase"] = $("#sGradeBase").val();
		returnValue["aGradeBase"] = $("#aGradeBase").val();
		returnValue["bGradeBase"] = $("#bGradeBase").val();
		returnValue["cGradeBase"] = $("#cGradeBase").val();
		returnValue["dGradeBase"] = $("#dGradeBase").val();
		returnValue["weight"] =$("#weight").val();
		returnValue["remark"] = $("#remark").val();
		returnValue["seq"] = $("#seq").val();
		returnValue["mboMidAppResult"] = $("#mboMidAppResult").val();
		returnValue["mboType"] = $("#mboType").val();
		//returnValue["deadlineType"] = $("#deadlineType").val();
		//returnValue["deadlineTypeTo"] = $("#deadlineTypeTo").val();
		
		// [무신사 추가] 중간점검 승인요청 상태에서  1차 평가자의 접근인 경우
		if ( modal.parameters.searchAppStepCd == "3" && modal.parameters.searchAppSeqCd == "1" && modal.parameters.searchAppStatusCd == "21" ) {
			returnValue["mboMidApp1stMemo"] = $("#mboMidApp1stMemo").val();
		}

		var rtnModal = window.top.document.LayerModalUtility.getModal('mboTargetRegPopDetailLayer');
		rtnModal.fire("mboTargetRegPopDetailTrigger", returnValue).hide();
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper modal_layer">
		<div class="modal_body">
		<form id="sheet1Form" name="sheet1Form">
			<input id="authPg" name="authPg" type="hidden" value="" />
			<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" value="" />
			<input id="searchAppStepCd" name="searchAppStepCd" type="hidden" value="" />
			<input id="searchAppSeqCd" name="searchAppSeqCd" type="hidden" value="" />
			<input id="searchAppStatusCd" name="searchAppStatusCd" type="hidden" value="" />
			<table class="table">
				<tbody>
					<colgroup>
						<col width="15%" />
						<col width="20%" />
						<col width="15%" />
						<col width="10%" />
						<col width="15%" />
						<col width="15%" />
					</colgroup>
					<tr>
<%-- 190529 사용안함처리 : IDS의 경우 MBO 목표유형으로 사용함.
						<th align="center">구분</th>
						<td class="content">
							<!-- <select id="appIndexGubunCd" name="appIndexGubunCd" class="box w100p"></select> -->
							<input id="appIndexGubunNm" name="appIndexGubunNm" class="${textCss} ${readonly} ${required} w100p right number" type="text"  ${readonly} />
						</td>
--%>
						<th align="center">목표구분</th>
						<td class="content">
							<select id="mboType" name="mboType" class="${selectCss} box w100p" ${disabled}></select>
						</td>
						<th align="center">순서</th>
						<td class="content">
							<input id="orderSeq" name="orderSeq" class="${textCss} ${readonly} ${required} w100p right number" type="text"  ${readonly} />
							<input id="seq" name="seq" type="hidden" />
						</td>
						<th align="center">비중(%)</th>
						<td class="content">
							<input id="weight" name="weight" class="${textCss} ${readonly} ${required} w100p right number" type="text" ${readonly}  />
						</td>
					</tr>
<!-- 201113 사용안함처리
					<tr>
						<th align="center">추진일정</th>
						<td class="content" colspan=5>
							<span>From&nbsp;:&nbsp;</span>
							<input id="deadlineType" name="deadlineType" class="${textCss} ${readonly} ${required} w100" type="text"  ${readonly} />
							<lable>&nbsp;~&nbsp;</lable>
							<span>To&nbsp;:&nbsp;</span>
							<input id="deadlineTypeTo" name="deadlineTypeTo" class="${textCss} ${readonly} ${required} w100" type="text"  ${readonly} />
						</td>
					</tr>
-->					
					<tr>
						<th align="center">목표항목</th>
						<td class="content" colspan=5>
							<textarea id="mboTarget" name="mboTarget" rows="3" class="${textCss} ${readonly} ${required} w100p" ${readonly} ></textarea>
						</td>
					</tr>

					<tr>
						<th align="center">목표달성을<br/>위한<br/>핵심 요인</th>
						<td class="content" colspan=5>
							<textarea id="kpiNm" name="kpiNm" rows="4" class="${textCss} ${readonly} ${required} w100p" ${readonly} ></textarea>
						</td>
					</tr>
 
					<tr>
						<th align="center">달성목표<br/>(정량,최종)</th>
						<td class="content" colspan=5>
							<textarea id="formula" name="formula" rows="5" class="${textCss} ${readonly} ${required} w100p" ${readonly} ></textarea>
						</td>
					</tr>
					<tr>
						<th align="center">중점추진 Activity</th>
						<td class="content" colspan=5>
							<textarea id="remark" name="remark" rows="9" class="${textCss} ${readonly} ${required} w100p" ${readonly} maxlength="1000" ></textarea>
						</td>
					</tr>
					<tr id="tr_mboMidAppResult" style="display:none;">
						<th align="center">중간점검실적</th>
						<td class="content" colspan=5>
							<textarea id="mboMidAppResult" name="mboMidAppResult" rows="4" class="${textCss} ${readonly} ${required} w100p" ${readonly} maxlength="1000" ></textarea>
						</td>
					</tr>
					<tr id="tr_mboMidApp1stMemo" style="display:none;">
						<th align="center">승인자의견</th>
						<td class="content" colspan=5>
							<textarea id="mboMidApp1stMemo" name="mboMidApp1stMemo" rows="4" class="${textCss} ${readonly} ${required} w100p" ${readonly} maxlength="1000" ></textarea>
						</td>
					</tr>
<!-- 201113 사용안함처리
					<tr>
						<th align="center">측정기준</th>
						<td class="content" colspan=5>
							<textarea id="baselineData" name="baselineData" rows="6" class="${textCss} ${readonly} ${required} w100p" ${readonly} maxlength="500" ></textarea>
						</td>
					</tr>
-->					
				</tbody>
			</table>
<!-- 190529 사용안함처리
			<table class="table">
				<tr>
					<th colspan="5" class="center"> 목표수준 </th>
				</tr>
				<tr>
					<th class="center" id="thClassCd1"></th>
					<th class="center" id="thClassCd2"></th>
					<th class="center" id="thClassCd3"></th>
					<th class="center" id="thClassCd4"></th>
					<th class="center" id="thClassCd5"></th>
				</tr>
				<tr>
					<td id="tdClassCd1"><textarea id="sGradeBase" name="sGradeBase" rows="10" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea></td>
					<td id="tdClassCd2"><textarea id="aGradeBase" name="aGradeBase" rows="10" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea></td>
					<td id="tdClassCd3"><textarea id="bGradeBase" name="bGradeBase" rows="10" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea></td>
					<td id="tdClassCd4"><textarea id="cGradeBase" name="cGradeBase" rows="10" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea></td>
					<td id="tdClassCd5"><textarea id="dGradeBase" name="dGradeBase" rows="10" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea></td>
				</tr>
			</table>
 -->
		</form>
	</div>
	<div class="modal_footer">
		<a id="closeYn" href="javascript:setValue();closeCommonLayer('mboTargetRegPopDetailLayer');"	class="btn filled">확인</a>
		<a href="javascript:closeCommonLayer('mboTargetRegPopDetailLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>