<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>다면평가역량PopUp</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var authPg = "${authPg}";

	$(function() {
		$(".close, #close").click(function() {
/* 			if( $('#aComment').val() != $('#searchAComment').val() || $('#cComment').val() != $('#searchCComment').val() ){
				if(!confirm("입력한 내역이 있습니다. 창을 닫으시겠습니까?")) return;
			} */

			p.self.close();
		});

		$("#aComment").maxbyte(2000);
		$("#cComment").maxbyte(2000);

		// 조회조건 값 setting
		var arg = p.window.dialogArguments;
	    if( arg != undefined ) {
			$("#searchWEnterCd").val( arg["wEnterCd"] );
			$("#searchCompAppraisalCd").val( arg["compAppraisalCd"] );
			$("#searchSabun").val( arg["sabun"] );
			$("#searchAppSabun").val( arg["appSabun"] );
			$("#searchAppEnterCd").val( arg["appEnterCd"] );
			$("#searchLdsCompetencyCd").val( arg["ldsCompetencyCd"] );
			$("#searchSeq").val( arg["seq"] );
			
			$("#span_ldsCompetencyNm").val( arg["ldsCompetencyNm"] );
	    }else{
	    	if(p.popDialogArgument("compAppraisalCd")!=null)	$("#searchCompAppraisalCd").val(p.popDialogArgument("compAppraisalCd"));
	    	if(p.popDialogArgument("wEnterCd")!=null)			$("#searchWEnterCd").val(p.popDialogArgument("wEnterCd"));
	    	if(p.popDialogArgument("sabun")!=null)				$("#searchSabun").val(p.popDialogArgument("sabun"));
	    	if(p.popDialogArgument("appSabun")!=null)			$("#searchAppSabun").val(p.popDialogArgument("appSabun"));
	    	if(p.popDialogArgument("appEnterCd")!=null)			$("#searchAppEnterCd").val(p.popDialogArgument("appEnterCd"));
	    	if(p.popDialogArgument("ldsCompetencyCd")!=null)	$("#searchLdsCompetencyCd").val(p.popDialogArgument("ldsCompetencyCd"));
	    	if(p.popDialogArgument("seq")!=null)				$("#searchSeq").val(p.popDialogArgument("seq"));
	    	if(p.popDialogArgument("ldsCompetencyNm")!=null)	$("#span_ldsCompetencyNm").html(p.popDialogArgument("ldsCompetencyNm"));
	    }
	    
	    //authPg가 R이면 모든 케이스 수정 불가능하게
	    if(authPg == "R"){
	    	$('#btnSave').hide();
	    	$('#aComment, #cComment').addClass('readonly');
	    	$('#aComment, #cComment').attr('readonly', true);
	    }

		// 조회
		doAction1("Search");
	});
</script>

<!-- sheet1 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				var result = ajaxCall("${ctx}/CompAppraisal.do?cmd=getCompAppraisalCommentPopMap", $("#srchFrm").serialize(), false).DATA;
				$('#aComment').text(result.aComment == "" || result.aComment == null? "" : result.aComment);
				$('#cComment').text(result.cComment == "" || result.cComment == null? "" : result.cComment);
				break;

			case "Save":		//저장
				if (!confirm("저장하시겠습니까?")){
					break;
				}

				var saveStr = $("#srchFrm").serialize();

				var result = ajaxCall("${ctx}/CompAppraisal.do?cmd=saveCompAppraisalCommentPop", saveStr, false).Result;
				
				if(result.Code == 1) {
					alert(result.Message);
					doAction1("Search");
				}
				doAction1('Search');
				break;
		}
	}

	//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}

			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	//<!-- 저장 후 에러 메시지 -->
	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>역량별 의견</li>
				<li class="close"></li>
			</ul>
		</div>

		<div class="popup_main">
		<form id="srchFrm" name="srchFrm">
		<input id="searchWEnterCd" 			name="searchWEnterCd" 		 type="hidden" value="" />
		<input id="searchCompAppraisalCd" 	name="searchCompAppraisalCd" type="hidden" value="" />
		<input id="searchSabun" 			name="searchSabun" 			 type="hidden" value="" />
		<input id="searchAppEnterCd" 		name="searchAppEnterCd" 	 type="hidden" value="" />
		<input id="searchAppSabun" 			name="searchAppSabun" 		 type="hidden" value="" />
		<input id="searchLdsCompetencyCd" 	name="searchLdsCompetencyCd" type="hidden" value="" />
		<input id="searchSeq" 				name="searchSeq" 			 type="hidden" value="" />

		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><span id='span_ldsCompetencyNm'></span></li>
				</ul>
			</div>
			
			
			<table class="table">
			<tr>
				<td>
					<table class="table w100p">
						<tr>
							<td align="center"  style=" background-color: #bbdefb;"><span class="strong"><font color="blue">장점</font></span></td>
						</tr>
						<tr>
							<td >
								<textarea id="aComment" name="aComment" rows="6" class="w100p ${required}"></textarea>
							</td>
						</tr>
					</table>
				</td>
				<td>
					<table class="table w100p">
						<tr>
							<td align="center" style=" background-color: #bbdefb;"><span class="strong"><font color="blue">개선점</font></span></td>
						</tr>
						<tr>
							<td >
								<textarea id="cComment" name="cComment" rows="6" class="w100p ${required}"></textarea>
							</td>
						</tr>
					</table>
				</td>
			</tr>
			</table>
		</div>
		</form>

		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:doAction1('Save')" id="btnSave"	class="blue large"><tit:txt mid='104476' mdef='저장'/></a>
				<a id="close" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
			</li>
		</ul>
		</div>

	</div>
	
	
</div>
</body>
</html>
