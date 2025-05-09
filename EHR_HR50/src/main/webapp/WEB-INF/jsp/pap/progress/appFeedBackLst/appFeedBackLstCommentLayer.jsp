<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>이의제기</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">
	<%--var p = eval("${popUpStatus}");--%>
	$(function() {
		modal = window.top.document.LayerModalUtility.getModal('appFeedBackLstCommentLayer');

	    if( modal != undefined ) {
		    $("#searchAppraisalCd").val(modal.parameters.searchAppraisalCd);
		    $("#searchSabun").val(modal.parameters.searchSabun);
		    $("#searchAppOrgCd").val(modal.parameters.searchAppOrgCd);
		    $("#protestYn").val(modal.parameters.protestYn);
		    $("#protestMemoMbo").val(modal.parameters.protestMemoMbo);
		    $("#protestMemoComp").val(modal.parameters.protestMemoComp);
            $("#protestMemoFeedBackYn").val(modal.parameters.protestMemoFeedBackYn);
	    }
	    if($("#protestYn").val() == "" || $("#protestYn").val() == "N"){
	    	$("#protestMemoMbo").attr("readonly",true).addClass("readonly");
            $("#protestMemoComp").attr("readonly",true).addClass("readonly");
	    }
	    if($("#protestMemoFeedBackYn").val() == "" || $("#protestMemoFeedBackYn").val() == "N") {
            $("#protestFeedback").attr("readonly", true).addClass("readonly");
        }
        if(modal.parameters.saveBtnYn == 'N'){
            $("#btnSave").hide();
		}

        loadData();
    });

	function loadData() {
		var data = ajaxCall("${ctx}/AppFeedBackLst.do?cmd=getAppFeedBackCommentLstList", $("#srchFrm").serialize(), false);
		// 조회된 데이터가 없을 경우 저장을 하도록 하는 것으로 보아 팝업으로 넘어온 protestMemo를 저장하는 것으로 보임
		// 따라서 조회된 데이터가 없다면 무조건 저장을 하는 것이 아니라 팝업으로 넘어온 protestMemo에 값이 있을 경우에만 저장하도록 변경
		if (data.DATA == null) {
			if (!isWhitespace($("#protestMemoMbo").val()) || !isWhitespace($("#protestMemoComp").val())) {
				data = ajaxCall("${ctx}/AppFeedBackLst.do?cmd=saveAppFeedBackLstComment", $("#srchFrm").serialize(), false);
				if (data.Result.Code == -1) {
					//alert(data.Result.Message);
				} else {
					//var rv = new Array();
					//rv["Code"] = data.Result.Code;
					//alert("기초자료가 생성 되었습니다.");
				}
			}
		} else {
			$("#protestMemoMbo").val(data.DATA.protestMemoMbo);
			$("#protestMemoComp").val(data.DATA.protestMemoComp);
			$("#protestFeedback").val(data.DATA.protestFeedback);
		}
	}

    function setValue() {
		/*
		if( $("#protestMemoMbo").val().trim() == "" ){
			alert("의견을 입력 해주세요.");
			$("#protestMemoMbo").focus();
			return;
		}
		*/
		if(!confirm("제출 하시겠습니까?"))	return;

		var data = ajaxCall("${ctx}/AppFeedBackLst.do?cmd=saveAppFeedBackLstComment",$("#srchFrm").serialize(),false);
		if(data.Result.Code == -1) {
			alert(data.Result.Message);
		} else {
			var rv = {};
			rv["Code"] = data.Result.Code;
			alert("저장 되었습니다.");

			var rtnModal = window.top.document.LayerModalUtility.getModal('appFeedBackLstCommentLayer');
			rtnModal.fire("appFeedBackLstCommentLayerTrigger", rv).hide();
    	}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="sStatus"           		name="sStatus"  value="U" />
		<input type="hidden" id="searchAppraisalCd" 		name="searchAppraisalCd" />
		<input type="hidden" id="searchSabun" 	    		name="searchSabun" />
		<input type="hidden" id="searchAppOrgCd"    		name="searchAppOrgCd" />
		<input type="hidden" id="protestYn"         		name="protestYn" />
		<input type="hidden" id="protestMemoFeedBackYn"     name="protestMemoFeedBackYn" />
		<input type="hidden" id="s_SAVENAME"     			name="s_SAVENAME" />

			<table class="table">
			<tbody>
				<colgroup>
					<col width="100%" />
				</colgroup>
				<tr>
					<td>
						<ul>
							<li>이의제기(업적평가)</li>
							<li class="close"></li>
						</ul>
					</td>
				</tr>
				<tr>
					<td class="content">
						<textarea id="protestMemoMbo" name="protestMemoMbo" rows="9" class="${textCss} w100p"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						<ul>
							<li>이의제기(역량평가)</li>
							<li class="close"></li>
						</ul>
					</td>
				</tr>
				<tr>
					<td class="content">
						<textarea id="protestMemoComp" name="protestMemoComp" rows="9" class="${textCss} w100p"></textarea>
					</td>
				</tr>
				<tr>
					<td>
						<ul>
							<li>피드백 내역</li>
							<li class="close"></li>

						</ul>
					</td>
				</tr>
				<tr>
					<td class="content">
						<textarea id="protestFeedback" name="protestFeedback" rows="9" class="${textCss} w100p"></textarea>
					</td>
				</tr>
			</tbody>
		</table>
		</form>
	</div>
	<div class="modal_footer">
		<a href="javascript:setValue();" id="btnSave" class="btn filled">저장</a>
		<a href="javascript:closeCommonLayer('appFeedBackLstCommentLayer')" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>