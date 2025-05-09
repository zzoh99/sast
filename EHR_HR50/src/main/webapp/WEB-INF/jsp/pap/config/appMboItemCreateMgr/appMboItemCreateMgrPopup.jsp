<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>업적평가표생성관리PopUp</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p 	= eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();
	var authPg	="";

	$(function(){
		$(".close").click(function() 	{ p.self.close(); });

		var comboList1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"), ""); // 평가지표구분(P00011)
		$("#appIndexGubunCd").html( comboList1[2] );


		$("#category").maxbyte(1000);
		$("#mboTarget").maxbyte(1000);
		$("#target").maxbyte(1000);

		// 숫자만 입력가능
		$("#seq, #weight").keyup(function() {
			makeNumber(this,'A');
		});

		if( arg != "undefined" ) {
			authPg			= arg["authPg"];

			$("#authPg").val(authPg);
			$("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
			$("#orderSeq").val(arg["orderSeq"]);
			$("#appIndexGubunCd").val(arg["appIndexGubunCd"]);
			$("#mboTarget").val(arg["mboTarget"]);
			$("#kpiNm").val(arg["kpiNm"]);
			$("#formula").val(arg["formula"]);
			$("#baselineData").val(arg["baselineData"]);
			$("#sGradeBase").val(arg["sGradeBase"]);
			$("#aGradeBase").val(arg["aGradeBase"]);
			$("#bGradeBase").val(arg["bGradeBase"]);
			$("#cGradeBase").val(arg["cGradeBase"]);
			$("#dGradeBase").val(arg["dGradeBase"]);
			$("#weight").val(arg["weight"]);
			$("#note").val(arg["note"]);
			$("#seq").val(arg["seq"]);
		}

		if (authPg == "R"){
			$("#closeYn").addClass("hide");
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
		var returnValue = new Array(14);
		returnValue["orderSeq"] = $("#orderSeq").val();
		returnValue["appIndexGubunCd"] = $("#appIndexGubunCd").val();
		returnValue["mboTarget"] = $("#mboTarget").val();
		returnValue["kpiNm"] = $("#kpiNm").val();
		returnValue["formula"] = $("#formula").val();
		returnValue["baselineData"] = $("#baselineData").val();
		returnValue["sGradeBase"] = $("#sGradeBase").val();
		returnValue["aGradeBase"] = $("#aGradeBase").val();
		returnValue["bGradeBase"] = $("#bGradeBase").val();
		returnValue["cGradeBase"] = $("#cGradeBase").val();
		returnValue["dGradeBase"] = $("#dGradeBase").val();
		returnValue["weight"] = $("#weight").val();
		returnValue["note"] = $("#note").val();
		returnValue["seq"] = $("#seq").val();

		p.popReturnValue(returnValue);
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>업적평가표생성관리</li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
		<form id="sheet1Form" name="sheet1Form">
		<input id="authPg" name="authPg" type="hidden" value="" />
        <input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" value="" />
		<table class="table">
			<tbody>
				<colgroup>
					<col width="15%" />
					<col width="50%" />
					<col width="15%" />
					<col width="" />
				</colgroup>

				<tr>
					<th align="center">구분</th>
					<td class="content">
						<select id="appIndexGubunCd" name="appIndexGubunCd" class="box w100p"></select>
					</td>
					<th align="center">순서</th>
					<td class="content">
						<input id="orderSeq" name="orderSeq" class="${textCss} ${readonly} ${required} w100p right" type="text" />
						<input id="seq" name="seq" type="hidden" />
					</td>
				</tr>
				<tr>
					<th align="center">목표명</th>
					<td class="content" colspan=3>
						<textarea id="mboTarget" name="mboTarget" rows="4" class="${textCss} ${readonly} ${required} w100p" ${readonly} ></textarea>
					</td>
				</tr>
				<tr>
					<th align="center">지표명</th>
					<td class="content" colspan=3>
						<textarea id="kpiNm" name="kpiNm" rows="4" class="${textCss} ${readonly} ${required} w100p" ${readonly} ></textarea>
					</td>
				</tr>
				<tr>
					<th align="center">산출근거</th>
					<td class="content" colspan=3>
						<textarea id="formula" name="formula" rows="4" class="${textCss} ${readonly} ${required} w100p" ${readonly} ></textarea>
					</td>
				</tr>
				<tr>
					<th align="center">기준치</th>
					<td class="content">
						<textarea id="baselineData" name="baselineData" rows="4" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea>
					</td>
					<th align="center">가중치</th>
					<td class="content">
						<input id="weight" name="weight" class="${textCss} ${readonly} ${required} w100p right" type="text" />
					</td>
				</tr>
			</tbody>
		</table>
		<table class="table">
			<tr>
				<th colspan="5" class="center"> 평가등급 </th>
			</tr>
			<tr>
				<th class="center" id="thClassCd1"></th>
				<th class="center" id="thClassCd2"></th>
				<th class="center" id="thClassCd3"></th>
				<th class="center" id="thClassCd4"></th>
				<th class="center" id="thClassCd5"></th>
			</tr>
			<tr>
				<td id="tdClassCd1"><textarea id="sGradeBase" name="sGradeBase" rows="7" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea></td>
				<td id="tdClassCd2"><textarea id="aGradeBase" name="aGradeBase" rows="7" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea></td>
				<td id="tdClassCd3"><textarea id="bGradeBase" name="bGradeBase" rows="7" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea></td>
				<td id="tdClassCd4"><textarea id="cGradeBase" name="cGradeBase" rows="7" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea></td>
				<td id="tdClassCd5"><textarea id="dGradeBase" name="dGradeBase" rows="7" class="${textCss} ${required} ${readonly} w100p" ${readonly} ></textarea></td>
			</tr>
		</table>

		</form>
		<div class="popup_button outer">
			<ul>
				<li>
					<span id="closeYn" class="">
					<a href="javascript:setValue();p.self.close();"		class="pink large">확인</a>
					</span>
					<a href="javascript:p.self.close();"		class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>