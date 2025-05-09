<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>1차/2차 KPI 상세 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p 	= eval("${popUpStatus}");
	var arg = p.window.dialogArguments;
	var authPg	= "";

	$(function(){
		$(".close").click(function() 	{ p.self.close(); });
		
		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"), ""); // 평가지표구분(P00011)
		$("#appIndexGubunCd").html( comboList1[2] );
		
		$("#category").maxbyte(1000);
		$("#mboTarget").maxbyte(1000);
		$("#target").maxbyte(1000);
		$("#mboAppResult").maxbyte(500);
		$("#remark").maxbyte(500);
		$('#mboAppSelpPoint').mask('000.00', {reverse: true});
		$('#mboApp1stPoint').mask('000.00', {reverse: true});
		$('#mboApp2ndPoint').mask('000.00', {reverse: true});
		
		// 숫자만 입력가능
		$("#seq, #weight").keyup(function() {
			makeNumber(this,'A');
		});
		
		if( arg != "undefined" ) {
			authPg = arg["authPg"];
			
			$("#appIndexGubunCd").val(arg["appIndexGubunCd"]);
			$("#seq").val(arg["seq"]);
			$("#category").val(arg["category"]);
			$("#mboTarget").val(arg["mboTarget"]);
			$("#target").val(arg["target"]);
			$("#mboAppResult").val(arg["mboAppResult"]);
			$("#remark").val(arg["remark"]);
			$("#weight").val(arg["weight"]);
			$("#mboAppSelpPoint").val(arg["mboAppSelpPoint"]);
			$("#mboApp1stPoint").val(arg["mboApp1stPoint"]);
			$("#mboApp2ndPoint").val(arg["mboApp2ndPoint"]);
			
			if ( arg["searchAppSeqCd"] == "0" ) {
				$('#mboAppSelpPoint').removeAttr("readonly");
				$('#mboAppSelpPoint').removeClass("readonly");
			} else if ( arg["searchAppSeqCd"] == "1" ) {
				$('#mboApp1stPoint').removeAttr("readonly");
				$('#mboApp1stPoint').removeClass("readonly");
			} else {
				$('#mboApp2ndPoint').removeAttr("readonly");
				$('#mboApp2ndPoint').removeClass("readonly");
			}
		}
		
		if (authPg == "R"){
			$("#closeYn").addClass("hide");
		}
	});

	// 리턴함수
	function setValue(){
		var returnValue = new Array(7);
		returnValue["seq"]				= $("#seq").val();
		returnValue["appIndexGubunCd"]	= $("#appIndexGubunCd").val();
		returnValue["category"]			= $("#category").val();
		returnValue["mboTarget"]		= $("#mboTarget").val();
		returnValue["target"]			= $("#target").val();
		returnValue["mboAppResult"]		= $("#mboAppResult").val();
		returnValue["remark"]			= $("#remark").val();
		returnValue["weight"]			= $("#weight").val();
		returnValue["mboAppSelpPoint"]	= $("#mboAppSelpPoint").val();
		returnValue["mboApp1stPoint"]	= $("#mboApp1stPoint").val();
		returnValue["mboApp2ndPoint"]	= $("#mboApp2ndPoint").val();
		
		p.window.returnValue = returnValue;
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>KPI 관리</li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
		<form id="sheet1Form" name="sheet1Form">
		<input id="authPg" name="authPg" type="hidden" value="" />
		
		<table class="table">
			<tbody>
				<colgroup>
					<col width="15%" />
					<col width="20%" />
					<col width="15%" />
					<col width="20%" />
					<col width="15%" />
					<col width="%" />
				</colgroup>

				<tr>
					<th align="center">KPI Goal Seeting</th>
					<td class="content" colspan=3>
						<select id="appIndexGubunCd" name="appIndexGubunCd" class="readonly w100p" disabled></select>
					</td>
					<th align="center">Seq</th>
					<td class="content">
						<input id="seq" name="seq" class="${textCss} readonly ${required} w100p" type="text" readonly disabled />
					</td>
				</tr>
				<tr>
					<th align="center">Category</th>
					<td class="content" colspan=5>
						<textarea id="category" name="category" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
				</tr>
				<tr>
					<th align="center">Description & <br>Indicators</th>
					<td class="content" colspan=5>
						<textarea id="mboTarget" name="mboTarget" rows="4" class="${textCss} readonly w100p" readonly} ></textarea>
					</td>
				</tr>
				<tr>
					<th align="center">Target</th>
					<td class="content" colspan=3>
						<textarea id="target" name="target" rows="4" class="${textCss} readonly w100p" readonly ></textarea>
					</td>
					<th align="center">Weight(%)</th>
					<td class="content">
						<input id="weight" name="weight" class="${textCss} readonly ${required} w100p right" type="text" readonly />
					</td>
				</tr>
				<tr>
					<th align="center">Result</th>
					<td class="content" colspan=3>
						<textarea id="mboAppResult" name="mboAppResult" rows="4" class="${textCss} ${readonly} ${required} w100p" ${readonly} ></textarea>
					</td>
					<th align="center">Remark</th>
					<td class="content">
						<textarea id="remark" name="remark" rows="4" class="${textCss} ${readonly} ${required} w100p" ${readonly} ></textarea>
					</td>
				</tr>
				<tr>
					<th align="center">Self Score</th>
					<td class="content">
						<input id="mboAppSelpPoint" name="mboAppSelpPoint" class="${textCss} readonly ${required} w100p right" type="text" readonly />
					</td>
					<th align="center">1st Score</th>
					<td class="content">
						<input id="mboApp1stPoint" name="mboApp1stPoint" class="${textCss} readonly ${required} w100p right" type="text" readonly />
					</td>
					<th align="center">2nd Score</th>
					<td class="content">
						<input id="mboApp2ndPoint" name="mboApp2ndPoint" class="${textCss} readonly ${required} w100p right" type="text" readonly />
					</td>
				</tr>
			</tbody>
		</table>
		</form>
		<div class="popup_button outer">
			<ul>
				<li>
					<span id="closeYn" class="">
						<a href="javascript:setValue();p.self.close();"		class="pink large">확인</a>
					</span>
					<a href="javascript:p.self.close();"				class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>