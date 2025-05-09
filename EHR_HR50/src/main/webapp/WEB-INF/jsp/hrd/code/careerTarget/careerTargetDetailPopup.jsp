<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>경력목표 세부내역</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function(){
	
		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});


		var careerTargetTypeCd     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","D00001"), "");
		$("#searchCareerTargetType").html(careerTargetTypeCd[2]);

/*
		var nationalCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), "<tit:txt mid='111914' mdef='선택'/>");	//소재국가
		var bankCd		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "<tit:txt mid='111914' mdef='선택'/>");	//은행명
		$("#nationalCd").html(nationalCd[2]);
		$("#bankCd").html(bankCd[2]);

*/


		var args = p.popDialogArgumentAll();

		var careerTargetType = args["careerTargetType"];
		var useYn            = args["useYn"]           ;
		var careerTargetNm   = args["careerTargetNm"]  ;
		var careerTargetDesc = args["careerTargetDesc"];
		var g1StepDesc       = args["g1StepDesc"]      ;
		var g1NeedDesc       = args["g1NeedDesc"]      ;
		var g2StepDesc       = args["g2StepDesc"]      ;
		var g2NeedDesc       = args["g2NeedDesc"]      ;
		var g3StepDesc       = args["g3StepDesc"]      ;
		var g3NeedDesc       = args["g3NeedDesc"]      ;
		var limitCnt         = args["limitCnt"]        ;

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

/*
		if ( $("#companyNum").val() == "" ){
			//alert("사업자등록번호는 필수값입니다.\r\n저장시 확인해주세요.");
			alert("사업자등록번호는 필수값입니다.");
			return;
		}
*/

		var rv = new Array();


		rv["careerTargetType"] = $("#searchCareerTargetType").val();
		rv["useYn"]            = $("#useYn").val();
		rv["careerTargetNm"]   = $("#careerTargetNm").val();
		rv["careerTargetDesc"] = $("#careerTargetDesc").val();
		rv["g1StepDesc"]       = $("#g1StepDesc").val();
		rv["g1NeedDesc"]       = $("#g1NeedDesc").val();
		rv["g2StepDesc"]       = $("#g2StepDesc").val();
		rv["g2NeedDesc"]       = $("#g2NeedDesc").val();
		rv["g3StepDesc"]       = $("#g3StepDesc").val();
		rv["g3NeedDesc"]       = $("#g3NeedDesc").val();
		rv["limitCnt"]         = $("#limitCnt").val();

		p.popReturnValue(rv);
		p.window.close();
	}
	
	var gPRow = "";
	var pGubun = "";
	
	// 팝업 클릭시 발생
	function zipCodePopup() {
		if(!isPopup()) {return;}
	
		pGubun = "viewZipCodePopup";
		openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
	
	    if(pGubun == "viewZipCodePopup"){
	    	$("#zip").val(rv["zip"]);
	    	$("#curAddr1").html(rv["resDoroFullAddr"]);
	    }
	}

</script>
</head>
<body class="bodywrap">
<form id="srchFrm" name="srchFrm" method="post">
<input type=hidden id="fileSeq"   	name="fileSeq">
</form>
<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='' mdef='경력목표 세부내역'/></li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
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
					<input id="limitCnt" name="limitCnt" type="text" onKeyUp="check_Integer(this, '적정인원');" style="text-align:center;ime-mode:active;width:40px !important;"> 명
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
		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:setValue();" css="pink large authA" mid='110716' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large authR" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>

</body>
</html>
