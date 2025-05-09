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
	<%--var arg = p.popDialogArgumentAll();--%>
	var authPg	= "";
	var modal = "";

	$(function(){
		modal = window.top.document.LayerModalUtility.getModal('appSelfPopDetailLayer');

		$(".close").click(function() 	{ closeCommonLayer('appSelfPopDetailLayer'); });

		var classCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00001"), " ");

		var comboListMboType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10009"), ""); // 목표구분(P10009)
		$("#mboType").html( comboListMboType[2] );

		$("#mboAppResult").maxbyte(4000);
		$("#mbo1stMemo").maxbyte(4000);
		$("#mbo2ndMemo").maxbyte(4000);
		$("#mbo3rdMemo").maxbyte(4000);
		$("#mboSelfClassCd").html(classCdList[2]);
		$("#mbo1stClassCd").html(classCdList[2]);
		$("#mbo2ndClassCd").html(classCdList[2]);
		$("#mbo3rdClassCd").html(classCdList[2]);

		// 숫자만 입력가능
		$("#mboAppSelfPoint, #mboApp1stPoint, #mboApp2ndPoint, #mboApp3rdPoint").keyup(function() {
			makeNumber(this,'A');
		});

		if( modal != "undefined") {
			authPg = modal.parameters.authPg;

			$("#seq").val(modal.parameters.seq);
			$("#orderSeq").val(modal.parameters.orderSeq);
			$("#appIndexGubunNm").val(modal.parameters.appIndexGubunNm);
			$("#mboType").val(modal.parameters.mboType);
			$("#mboTarget").val(modal.parameters.mboTarget);
			$("#weight").val(modal.parameters.weight);
			$("#kpiNm").val(modal.parameters.kpiNm);
			$("#formula").val(modal.parameters.formula);
			$("#remark").val(modal.parameters.remark);
			$("#deadlineType").val(modal.parameters.deadlineType);
			$("#deadlineTypeTo").val(modal.parameters.deadlineTypeTo);
			$("#baselineData").val(modal.parameters.baselineData);
			$("#sGradeBase").val(modal.parameters.sGradeBase);
			$("#aGradeBase").val(modal.parameters.aGradeBase);
			$("#bGradeBase").val(modal.parameters.bGradeBase);
			$("#cGradeBase").val(modal.parameters.cGradeBase);
			$("#dGradeBase").val(modal.parameters.dGradeBase);
			$("#mboMidAppResult").val(modal.parameters.mboMidAppResult);
			$("#mboAppResult").val(modal.parameters.mboAppResult);
			
			$("#mboAppSelfPoint").val(modal.parameters.mboAppSelfPoint);
			$("#mboSelfClassCd").val(modal.parameters.mboSelfClassCd);
			$("#mboApp1stPoint").val(modal.parameters.mboApp1stPoint);
			$("#mbo1stClassCd").val(modal.parameters.mbo1stClassCd);
			$("#mbo1stMemo").val(modal.parameters.mbo1stMemo);
			$("#mboApp2ndPoint").val(modal.parameters.mboApp2ndPoint);
			$("#mbo2ndClassCd").val(modal.parameters.mbo2ndClassCd);
			$("#mbo2ndMemo").val(modal.parameters.mbo2ndMemo);
			$("#mboApp3rdPoint").val(modal.parameters.mboApp3rdPoint);
			$("#mbo3rdClassCd").val(modal.parameters.mbo3rdClassCd);
			$("#mbo3rdMemo").val(modal.parameters.mbo3rdMemo);
			
			$("#searchAppraisalCd").val(modal.parameters.searchAppraisalCd);
			$("#searchAppSheetType").val(modal.parameters.searchAppSheetType);
			$("#closeYn").val(modal.parameters.closeYn);	// 마감여부
			$("#appGradingMethod").val(modal.parameters.appGradingMethod);	// P20007(평가채점방식) : P(점수), C(등급)
			$("#note1").val(modal.parameters.note1);		// [비고1 : 점수 Hidden]
			$("#note2").val(modal.parameters.note2);		// [비고2 : 등급 Hidden]
			$("#note3").val(modal.parameters.note3);		// [비고3 : 점수 Edit]
			$("#note4").val(modal.parameters.note4);		// [비고4 : 등급 Edit]
			
			if ($("#appGradingMethod").val() == null || $("#appGradingMethod").val() == undefined || $("#appGradingMethod").val() == "" || $("#appGradingMethod").val() == "null") $("#appGradingMethod").val("C");
			if ($("#note1").val() == null || $("#note1").val() == undefined || $("#note1").val() == "" || $("#note1").val() == "null") $("#note1").val("1");
			if ($("#note2").val() == null || $("#note2").val() == undefined || $("#note2").val() == "" || $("#note2").val() == "null") $("#note2").val("0");
			if ($("#note3").val() == null || $("#note3").val() == undefined || $("#note3").val() == "" || $("#note3").val() == "null") $("#note3").val("0");
			if ($("#note4").val() == null || $("#note4").val() == undefined || $("#note4").val() == "" || $("#note4").val() == "null") $("#note4").val("1");
			
			/*
			if(arg["searchAppSheetType"] == "A"){  // KPI+역량(점수)
				$("#divClass").hide();
				if ( arg["searchAppSeqCd"] == "0" ) {
					$("#mboAppSelfPoint").val(arg["mboAppSelfPoint"]);
				} else if ( arg["searchAppSeqCd"] == "1" ) {
					$("#mboAppSelfPoint").val(arg["mboAppSelfPoint"]);
					$("#mboApp1stPoint").val(arg["mboApp1stPoint"]);
				} else {
					$("#mboAppSelfPoint").val(arg["mboAppSelfPoint"]);
					$("#mboApp1stPoint").val(arg["mboApp1stPoint"]);
					$("#mboApp2ndPoint").val(arg["mboApp2ndPoint"]);
				}

			}else if(arg["searchAppSheetType"] == "B" ){ // KPI+역량(등급)
				$("#divPoint").hide();

				if ( arg["searchAppSeqCd"] == "0" ) {
					$("#mboSelfClassCd").val(arg["mboSelfClassCd"]);
				} else if ( arg["searchAppSeqCd"] == "1" ) {
					$("#mboSelfClassCd").val(arg["mboSelfClassCd"]);
					$("#mbo1stClassCd").val(arg["mbo1stClassCd"]);
				} else {
					$("#mboSelfClassCd").val(arg["mboSelfClassCd"]);
					$("#mbo1stClassCd").val(arg["mbo1stClassCd"]);
					$("#mbo2ndClassCd").val(arg["mbo2ndClassCd"]);
				}
			}
			*/
			
			// P20007(평가채점방식)
			switch ($("#appGradingMethod").val()) {
			// P(점수)
			case "P":
				$("#divClass").hide();
				// [비고1 : 점수 Hidden]
				if ($("#note1").val() != "0") {
					$("#divPoint").hide();
				} else {
					$("#divPoint").show();
					switch (modal.parameters.searchAppSeqCd) {
					// 본인평가
					case "0":
						$("#mboAppSelfPoint").show();
						$("#mboApp1stPoint").hide();
						$("#mboApp2ndPoint").hide();
						$("#mboApp3rdPoint").hide();
						break;
					// 1차평가
					case "1":
						$("#mboAppSelfPoint").show();
						$("#mboApp1stPoint").show();
						$("#mboApp2ndPoint").hide();
						$("#mboApp3rdPoint").hide();
						break;
					// 2차평가
					case "2":
						$("#mboAppSelfPoint").show();
						$("#mboApp1stPoint").show();
						$("#mboApp2ndPoint").show();
						$("#mboApp3rdPoint").hide();
						break;
					// 3차평가
					case "6":
						$("#mboAppSelfPoint").show();
						$("#mboApp1stPoint").show();
						$("#mboApp2ndPoint").show();
						$("#mboApp3rdPoint").show();
						break;
					default:
						break;
					}
				}
				break;
			// C(등급)
			case "C":
			default:
				$("#divPoint").hide();
				// [비고2 : 등급 Hidden]
				if ($("#note2").val() != "0") {
					$("#divClass").hide();
				} else {
					$("#divClass").show();
					switch (modal.parameters.searchAppSeqCd) {
					// 본인평가
					case "0":
						$("#mboSelfClassCd").show();
						$("#mbo1stClassCd").hide();
						$("#mbo2ndClassCd").hide();
						$("#mbo3rdClassCd").hide();
						break;
					// 1차평가
					case "1":
						$("#mboSelfClassCd").show();
						$("#mbo1stClassCd").show();
						$("#mbo2ndClassCd").hide();
						$("#mbo3rdClassCd").hide();
						break;
					// 2차평가
					case "2":
						$("#mboSelfClassCd").show();
						$("#mbo1stClassCd").show();
						$("#mbo2ndClassCd").show();
						$("#mbo3rdClassCd").hide();
						break;
					// 3차평가
					case "6":
						$("#mboSelfClassCd").show();
						$("#mbo1stClassCd").show();
						$("#mbo2ndClassCd").show();
						$("#mbo3rdClassCd").show();
						break;
					default:
						break;
					}
				}
				break;
			}
			
			if(modal.parameters.searchAppSeqCd == "0") {
				if( modal.parameters.closeYn == "Y" ) {
					$("#tr_mbo1stMemo").show();
				} else {
					$("#tr_mbo1stMemo").hide();
				}
			} else {
				$("#tr_mbo1stMemo").show();
			}
			
			/*
			if (authPg == "A"){

				if(arg["searchAppSheetType"] == "A"){  // KPI+역량(점수)

					if ( arg["searchAppSeqCd"] == "0" ) {
						$("#mboAppSelfPoint").attr("readonly",false).removeClass("readonly");
						$("#mboAppResult").attr("readonly",false).removeClass("readonly");
					} else if ( arg["searchAppSeqCd"] == "1" ) {
						$("#mboApp1stPoint").attr("readonly",false).removeClass("readonly");
					} else {
						$("#mboApp2ndPoint").attr("readonly",false).removeClass("readonly");
					}

				}else if(arg["searchAppSheetType"] == "B" ){ // KPI+역량(등급)

					if ( arg["searchAppSeqCd"] == "0" ) {
						$("#mboSelfClassCd").attr("disabled",false).removeClass("readonly");
						$("#mboAppResult").attr("readonly",false).removeClass("readonly");
					} else if ( arg["searchAppSeqCd"] == "1" ) {
						$("#mbo1stClassCd").attr("disabled",false).removeClass("readonly");
					} else {
						$("#mbo2ndClassCd").attr("disabled",false).removeClass("readonly");
					}
				}
				
				// 본인평가인 경우
				if(arg["searchAppSeqCd"] == "0") {
					// [무신사] 추진실적 편집 가능
					$("#mboAppResult").removeClass("transparent");
					$("#mboAppResult").removeClass("readonly");
					$("#mboAppResult").removeAttr("readonly");
				}
				
				// 1차평가인 경우
				if(arg["searchAppSeqCd"] == "1") {
					// [무신사] 추진실적 편집 가능
					$("#mbo1stMemo").removeClass("transparent");
					$("#mbo1stMemo").removeClass("readonly");
					$("#mbo1stMemo").removeAttr("readonly");
				}
			}
			*/
			
			if (authPg == "A") {
				// P20007(평가채점방식)
				switch ($("#appGradingMethod").val()) {
				// P(점수)
				case "P":
					// [비고3 : 점수 Edit]
					if ($("#note3").val() != "0") {
						switch (modal.parameters.searchAppSeqCd) {
						// 본인평가
						case "0":
							$("#mboAppSelfPoint").attr("disabled",false).attr("readonly",false).removeClass("disabled").removeClass("readonly").removeAttr("disabled").removeAttr("readonly");
							break;
						// 1차평가
						case "1":
							$("#mboApp1stPoint").attr("disabled",false).attr("readonly",false).removeClass("disabled").removeClass("readonly").removeAttr("disabled").removeAttr("readonly");
							break;
						// 2차평가
						case "2":
							$("#mboApp2ndPoint").attr("disabled",false).attr("readonly",false).removeClass("disabled").removeClass("readonly").removeAttr("disabled").removeAttr("readonly");
							break;
						// 3차평가
						case "6":
							$("#mboApp3rdPoint").attr("disabled",false).attr("readonly",false).removeClass("disabled").removeClass("readonly").removeAttr("disabled").removeAttr("readonly");
							break;
						default:
							break;
						}
					}
					break;
				// C(등급)
				case "C":
				default:
					// [비고4 : 등급 Edit]
					if ($("#note4").val() != "0") {
						switch (modal.parameters.searchAppSeqCd) {
						// 본인평가
						case "0":
							$("#mboSelfClassCd").attr("disabled",false).attr("readonly",false).removeClass("disabled").removeClass("readonly").removeAttr("disabled").removeAttr("readonly");
							break;
						// 1차평가
						case "1":
							$("#mbo1stClassCd").attr("disabled",false).attr("readonly",false).removeClass("disabled").removeClass("readonly").removeAttr("disabled").removeAttr("readonly");
							break;
						// 2차평가
						case "2":
							$("#mbo2ndClassCd").attr("disabled",false).attr("readonly",false).removeClass("disabled").removeClass("readonly").removeAttr("disabled").removeAttr("readonly");
							break;
						// 3차평가
						case "6":
							$("#mbo3rdClassCd").attr("disabled",false).attr("readonly",false).removeClass("disabled").removeClass("readonly").removeAttr("disabled").removeAttr("readonly");
							break;
						default:
							break;
						}
					}
					break;
				}
				
				// 본인평가
				if (modal.parameters.searchAppSeqCd == "0") {
					$("#mboAppResult").attr("disabled",false).attr("readonly",false).removeClass("disabled").removeClass("readonly").removeAttr("disabled").removeAttr("readonly").removeClass("transparent");
				}
				
				// 1차평가
				if (modal.parameters.searchAppSeqCd == "1") {
					$("#mbo1stMemo").attr("disabled",false).attr("readonly",false).removeClass("disabled").removeClass("readonly").removeAttr("disabled").removeAttr("readonly").removeClass("transparent");
				}
			}
		}

		if (authPg == "R"){
			$("#btnClose").addClass("hide");
		}

		//평가등급기준
		var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, ""); // 평가등급
		var clsLst = classCdList[0].split("|");
		for( var i=0; i<clsLst.length; i++){
			$("#thClassCd"+(i+1)).html(clsLst[i]);
		}
		var len = clsLst.length;
		if(classCdList[0] == "" ) len = 0;
		for( var i=4; len<=i; i--){
			$("#thClassCd"+(i+1)).hide();
			$("#tdClassCd"+(i+1)).hide();
		}
	});

	// 리턴함수
	function setValue(){
		var returnValue = new Array();
		returnValue["seq"]				= $("#seq").val();
		returnValue["orderSeq"]			= $("#orderSeq").val();
		returnValue["appIndexGubunNm"]	= $("#appIndexGubunNm").val();
		returnValue["mboType"]			= $("#mboType").val();
		returnValue["mboTarget"]		= $("#mboTarget").val();
		returnValue["weight"]			= $("#weight").val();
		returnValue["kpiNm"]			= $("#kpiNm").val();
		returnValue["formula"]			= $("#formula").val();
		returnValue["remark"]			= $("#remark").val();
		returnValue["deadlineType"]		= $("#deadlineType").val();
		returnValue["deadlineTypeTo"]	= $("#deadlineTypeTo").val();
		returnValue["baselineData"]		= $("#baselineData").val();
		returnValue["sGradeBase"]		= $("#sGradeBase").val();
		returnValue["aGradeBase"]		= $("#aGradeBase").val();
		returnValue["bGradeBase"]		= $("#bGradeBase").val();
		returnValue["cGradeBase"]		= $("#cGradeBase").val();
		returnValue["dGradeBase"]		= $("#dGradeBase").val();
		returnValue["mboMidAppResult"]	= $("#mboMidAppResult").val();
		returnValue["mboAppResult"]		= $("#mboAppResult").val();
		returnValue["mboAppSelfPoint"]	= $("#mboAppSelfPoint").val();
		returnValue["mboSelfClassCd"]	= $("#mboSelfClassCd").val();
		returnValue["mboApp1stPoint"]	= $("#mboApp1stPoint").val();
		returnValue["mbo1stClassCd"]	= $("#mbo1stClassCd").val();
		returnValue["mbo1stMemo"]		= $("#mbo1stMemo").val();
		returnValue["mboApp2ndPoint"]	= $("#mboApp2ndPoint").val();
		returnValue["mbo2ndClassCd"]	= $("#mbo2ndClassCd").val();
		returnValue["mbo2ndMemo"]		= $("#mbo2ndMemo").val();
		returnValue["mboApp3rdPoint"]	= $("#mboApp3rdPoint").val();
		returnValue["mbo3rdClassCd"]	= $("#mbo3rdClassCd").val();
		returnValue["mbo3rdMemo"]		= $("#mbo3rdMemo").val();

		var rtnModal = window.top.document.LayerModalUtility.getModal('appSelfPopDetailLayer');
		rtnModal.fire("appSelfPopDetailTrigger", returnValue).hide();
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper modal_layer">
		<div class="modal_body">
		<form id="sheet1Form" name="sheet1Form">
			<input id="authPg" name="authPg" type="hidden" value="" />
			<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" value="" />
			<input id="searchAppSheetType" name="searchAppSheetType" type="hidden" value="" />
			<input id="closeYn" name="closeYn" type="hidden" value="" />	<!-- 마감여부 -->
			<input id="appGradingMethod" name="appGradingMethod" type="hidden" value="" />	<!-- P20007(평가채점방식) : P(점수), C(등급) -->
			<input id="note1" name="note1" type="hidden" value="" />	<!-- [비고1 : 점수 Hidden] -->
			<input id="note2" name="note2" type="hidden" value="" />	<!-- [비고2 : 등급 Hidden] -->
			<input id="note3" name="note3" type="hidden" value="" />	<!-- [비고3 : 점수 Edit] -->
			<input id="note4" name="note4" type="hidden" value="" />	<!-- [비고4 : 등급 Edit] -->

		<table class="table" style="width:100%">
			<tbody>
				<colgroup>
					<col width="15%" />
					<col width="20%" />
					<col width="15%" />
					<col width="15%" />
					<col width="15%" />
					<col width="*" />
				</colgroup>

				<tr>
<%-- 190529 사용안함처리 : IDS의 경우 MBO 목표유형으로 사용함.
					<th>구분</th>
					<td class="content">
						<input id="appIndexGubunNm" name="appIndexGubunNm" class="${textCss} readonly w90p" type="text" readonly />
					</td>
--%>
					<th>목표구분</th>
					<td class="content">
						<select id="mboType" name="mboType" class="${selectCss} box w100p disabled" disabled></select>
					</td>
					<th>순서</th>
					<td class="content">
						<input id="seq" name="seq" type="hidden" />
						<input id="orderSeq" name="orderSeq" class="${textCss} readonly w100p" type="text" readonly />
					</td>
					<th>비중(%)</th>
					<td class="content">
						<input id="weight" name="weight" class="${textCss} readonly w40" type="text" readonly />
					</td>
				</tr>
<!-- 201113 사용안함처리
				<tr>
					<th>추진일정</th>
					<td class="content" colspan=5>
						<span>From&nbsp;:&nbsp;</span>
						<input id="deadlineType" name="deadlineType" class="${textCss} readonly w80" type="text" readonly />
						<lable>&nbsp;~&nbsp;</lable>
						<span>To&nbsp;:&nbsp;</span>
						<input id="deadlineTypeTo" name="deadlineTypeTo" class="${textCss} readonly w80" type="text" readonly />
					</td>
				</tr>
-->					
				<tr>
					<th>목표항목</th>
					<td class="content" colspan=5>
						<textarea id="mboTarget" name="mboTarget" rows="3" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
				<tr>
					<th>목표달성을<br/>위한<br/>핵심 요인</th>
					<td class="content" colspan=5>
						<textarea id="kpiNm" name="kpiNm" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
				<tr>
					<th>달성목표<br/>(정량,최종)</th>
					<td class="content" colspan=5>
						<textarea id="formula" name="formula" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
				<tr>
					<th>중점추진 Activity</th>
					<td class="content" colspan=5>
						<textarea id="remark" name="remark" rows="4" class="${textCss} readonly w100p" readonly maxlength="500" ></textarea>
					</td>
				</tr>
<!-- 201113 사용안함처리
				<tr>
					<th>측정기준</th>
					<td class="content" colspan=5>
						<textarea id="baselineData" name="baselineData" rows="3" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
			</table>
-->
			<table class="table hide">
				<tr>
					<th class="center" colspan="5">평가등급기준</th>
				</tr>
				<tr>
					<th id="thClassCd1"></th>
					<th id="thClassCd2"></th>
					<th id="thClassCd3"></th>
					<th id="thClassCd4"></th>
					<th id="thClassCd5"></th>
				</tr>
				<tr>
					<td id="tdClassCd1" class="content">
						<textarea id="sGradeBase" name="sGradeBase" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
					<td id="tdClassCd2" class="content">
						<textarea id="aGradeBase" name="aGradeBase" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
					<td id="tdClassCd3" class="content">
						<textarea id="bGradeBase" name="bGradeBase" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
					<td id="tdClassCd4" class="content">
						<textarea id="cGradeBase" name="cGradeBase" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
					<td id="tdClassCd5" class="content">
						<textarea id="dGradeBase" name="dGradeBase" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
			</table>
			<table class="table">
				<colgroup>
					<col width="15%" />
					<col width="*" />
				</colgroup>
				<tr class="hide">
					<th>실적(중간점검)</th>
					<td>
						<textarea id="mboMidAppResult" name="mboMidAppResult" rows="5" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
				<tr>
					<th>추진실적</th>
					<td>
						<textarea id="mboAppResult" name="mboAppResult" rows="15" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
				<tr id="tr_mbo1stMemo" style="display:none;">
					<th>1차평가의견</th>
					<td>
						<textarea id="mbo1stMemo" name="mbo1stMemo" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
				<tr id="tr_mbo2ndMemo" style="display:none;">
					<th>2차평가의견</th>
					<td>
						<textarea id="mbo2ndMemo" name="mbo2ndMemo" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
				<tr id="tr_mbo3rdMemo" style="display:none;">
					<th>3차평가의견</th>
					<td>
						<textarea id="mbo3rdMemo" name="mbo3rdMemo" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
			</table>
			<table class="table" id="divClass">
				<tr>
					<th class="center">본인평가(등급)</th>
					<th class="center">1차평가(등급)</th>
					<th class="center">2차평가(등급)</th>
					<th class="center">3차평가(등급)</th>
				</tr>
				<tr>
					<td class="center">
						<select id="mboSelfClassCd" name="mboSelfClassCd" style="" class="${selectCss} readonly" disabled></select>
					</td>
					<td class="center">
						<select id="mbo1stClassCd" name="mbo1stClassCd" style="" class="${selectCss} readonly" disabled></select>
					</td>
					<td class="center">
						<select id="mbo2ndClassCd" name="mbo2ndClassCd" style="" class="${selectCss} readonly" disabled></select>
					</td>
					<td class="center">
						<select id="mbo3rdClassCd" name="mbo3rdClassCd" style="" class="${selectCss} readonly" disabled></select>
					</td>
				</tr>
			</table>
			<table class="table" id="divPoint">
				<tr>
					<th class="center">본인평가(점수)</th>
					<th class="center">1차평가(점수)</th>
					<th class="center">2차평가(점수)</th>
					<th class="center">3차평가(점수)</th>
				</tr>
				<tr>
					<td class="center">
						<input id="mboAppSelfPoint" name="mboAppSelfPoint" class="${textCss} readonly w100" style="text-align:center" readonly/>
					</td>
					<td class="center">
						<input id="mboApp1stPoint" name="mboApp1stPoint" class="${textCss} readonly w100" style="text-align:center" readonly/>
					</td>
					<td class="center">
						<input id="mboApp2ndPoint" name="mboApp2ndPoint" class="${textCss} readonly w100" style="text-align:center" readonly/>
					</td>
					<td class="center">
						<input id="mboApp3rdPoint" name="mboApp3rdPoint" class="${textCss} readonly w100" style="text-align:center" readonly/>
					</td>
				</tr>
			</table>
		</form>
		<div class="modal_footer">
			<a id="btnClose" href="javascript:setValue();closeCommonLayer('appSelfPopDetailLayer');" class="btn filled">확인</a>
			<a href="javascript:closeCommonLayer('appSelfPopDetailLayer');"	class="btn outline_gray">닫기</a>
		</div>
	</div>
</div>
</body>
</html>