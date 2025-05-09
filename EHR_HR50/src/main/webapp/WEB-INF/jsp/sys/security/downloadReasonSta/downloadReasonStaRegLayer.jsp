<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<script type="text/javascript">

		$(function() {
			const modal = window.top.document.LayerModalUtility.getModal('downloadReasonStaRegLayer');

			$("#prgCd").val(modal.parameters.prgCd);
			$("#fileNm").val(modal.parameters.fileNm);
			$("#sheetId").val(modal.parameters.sheetId);
		});

		function setValue() {
			if( $("#reason").val().trim() == "" ){
				alert("사유는 반드시 입력해 주세요.");
				$("#reason").focus();
				return;
			}

			if(confirm("다운로드 하시겠습니까?"))	{
				var data = ajaxCall("${ctx}/DownloadReasonSta.do?cmd=regDownloadReasonSta",$("#downloadReasonStaRegLayerFrm").serialize(),false);
				if(data.Result.Code == -1) {
					alert(data.Result.Message);
				} else {
					var msg = data.Result.Message;

					if( data.tempPassword != undefined && data.tempPassword != null ) {
						msg += "\n\n다운로드 파일은 비밀번호가 설정된 상태이며,\n아래 발급된 임시비밀번호를 통해 열람 가능합니다.";
						msg += "\n\n* 임시비밀번호 : " + data.tempPassword + "\n\n";
					}

					alert(msg);

					const modal = window.top.document.LayerModalUtility.getModal('downloadReasonStaRegLayer');
					modal.fire('downloadReasonStaRegLayerTrigger', "OK").hide();
				}
			}
		}
	</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="downloadReasonStaRegLayerFrm" name="downloadReasonStaRegLayerFrm" >
			<input type="hidden" id="prgCd"    name="prgCd"    value="" />
			<input type="hidden" id="fileNm"   name="fileNm"   value="" />
			<input type="hidden" id="sheetId"  name="sheetId"  value="" />
			<div class="f_s14">
				※ 현재 다운로드 하실려는 내용에 <span class="f_bold f_red">개인정보</span>가 <span class="f_bold f_red">포함</span>되어 있습니다.<br />
				&nbsp;&nbsp;&nbsp;&nbsp;다운로드를 진행 하시기 위해서는 <span class="f_bold f_red">사유 등록</span>이 <span class="f_bold f_red">필요</span>합니다.
			</div>
			<table class="table mat15">
				<tbody>
				<colgroup>
					<col width="100px" />
					<col width="*" />
				</colgroup>
				<tr>
					<th>사유</th>
					<td class="content">
						<textarea id="reason" name="reason" rows="8" class="${textCss} w100p"></textarea>
					</td>
				</tr>
				</tbody>
			</table>
		</form>
	</div>
	<div class="modal_footer">
		<a href="javascript:setValue();" id="prcCall" class="btn filled">확인</a>
		<a href="javascript:closeCommonLayer('downloadReasonStaRegLayer');" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>
