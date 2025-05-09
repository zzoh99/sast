<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%
	Map<String, Object> editorMap = new HashMap<String, Object>();
	editorMap.put("formNm", "templateEditFrm");
	editorMap.put("contentNm", "contents");
	request.setAttribute("editor", editorMap);
%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>조건검색코드항목관리 팝업</title>
<script src="${ctx}/common/plugin/ckeditor5/ckeditor.js"></script>
<script type="text/javascript">
	var noticeTemplateMgrEditLayer = { id: 'noticeTemplateMgrEditLayer' };
	var bizCd        = "";
	var bizNm        = "";
	var noticeTypeCd = "";
	var noticeTypeNm = "";
	
	// 에디터 사용 여부
	var isUsingEditor = false;
	var templateData  = null;

	$(function(){
		const modal = window.top.document.LayerModalUtility.getModal(noticeTemplateMgrEditLayer.id);
		bizCd        = modal.parameters.bizCd;
		bizNm        = modal.parameters.bizNm;
		noticeTypeCd = modal.parameters.noticeTypeCd;
		
		if( noticeTypeCd != "" && noticeTypeCd != undefined) {
			var viewAreas = "";
			
			if( noticeTypeCd == "MAIL" ) {
				noticeTypeNm = "메일";
				viewAreas = "#area_title, #area_senderNm, #area_sendMail, #area_editor";
				isUsingEditor = true;
			}
			if( noticeTypeCd == "SMS" ) {
				noticeTypeNm = "SMS";
				viewAreas = "#area_title, #area_senderNm, #area_sendPhone, #area_editor_none";
			}
			if( noticeTypeCd == "LMS" ) {
				noticeTypeNm = "LMS";
				viewAreas = "#area_title, #area_senderNm, #area_sendPhone, #area_editor_none";
			}
			if( noticeTypeCd == "MESSENGER" ) {
				noticeTypeNm = "메신저";
				viewAreas = "#area_title, #area_senderNm, #area_editor_none";
			}
			// 업무 코드 삽입
			$("#bizCd").val(bizCd);
			// 알림유형코드 삽입
			$("#noticeTypeCd").val(noticeTypeCd);
			// 알림 유형 출력
			$("#tit_noticeTypeNm").text("[ " + bizNm + " - " + noticeTypeNm + " ]");
			// 입력항목 출력
			$(viewAreas).removeClass("hide");
		}
		
		// 기존 데이터 폼 세팅
		initData();
	});

	// 기존 데이터 폼 세팅
	function initData() {
		var params  = "&bizCd=" + $("#bizCd").val();
			params += "&noticeTypeCd=" + $("#noticeTypeCd").val();
			params += "&languageCd=" + $("#languageCd").val();
			
		templateData = ajaxCall("${ctx}/NoticeTemplateMgr.do?cmd=getNoticeTemplateData", params, false);
		console.log(templateData)
		console.log(templateData.DATA)
		if( templateData != null && templateData != undefined && templateData.DATA != null && templateData.DATA != undefined ) {
			var data = templateData.DATA;
			$("#templateTitle").val(data.templateTitle);
			$("#senderNm").val(data.senderNm);
			$("#sendPhone").val(data.sendPhone);
			$("#sendMail").val(data.sendMail);
			// 에디터를 사용하는 경우
			if( isUsingEditor ) {
				console.log(data.templateContent)
				$('#modifyContents').val(data.templateContent);
				callIframeBody("authorForm", "authorFrame");
				$('#authorFrame').on("load", function() { setIframeHeight("authorFrame"); });
			} else {
				$("#message").html(data.templateContent);
			}
		}else{
			if( isUsingEditor ) {
				callIframeBody("authorForm", "authorFrame");
				$('#authorFrame').on("load", function () {
					setIframeHeight();
				});
			}
		}
	}
	
	// 저장
	function save() {
		if( confirm("저장 하시겠습니까?") ) {
			// 에디터를 사용하는 경우
			if( isUsingEditor ) {
				// 에디터의 내용 textarea 객체에 삽입
				//$("#content").val(Editor.getContent(true));
				ckReadySave("authorFrame");
				$("#usingEditorYn").val("Y");
			} else {
				$("#content").val('');
				$("#usingEditorYn").val("N");
			}
			// save
			var saveData = ajaxCall("${ctx}/NoticeTemplateMgr.do?cmd=saveNoticeTemplateData", $("form[name=templateEditFrm]").serialize(), false);
			if( saveData != null && saveData != undefined ) {
				alert(saveData.Result.Message);
				if( saveData.Result.Code > -1 ) {
					const p = { pGubun: 'templateEditPop', Code: '1' };
					const modal = window.top.document.LayerModalUtility.getModal(noticeTemplateMgrEditLayer.id);
					modal.fire(noticeTemplateMgrEditLayer.id + 'Trigger', p).hide();
				}
			}
		}
	}
	
	// 서식 전사 배포
	function deployAll() {
		if( templateData == null || templateData == undefined || templateData.DATA == null || templateData.DATA == undefined ) {
			alert("등록된 데이터가 존재하지 않습니다.\n서식 내용을 등록/저장 후 실행 가능합니다.");
		} else {
			if(confirm("선택하신 업무코드의 서식 데이터를 전사로 배포하시겠습니까?\n실행하시면 전체회사 내 업무코드에 해당하는 서색의 내용이 변경됩니다.\n\n배포를 진해하시겠습니까?")) {
				var params  = "bizCd=" + $("#bizCd").val()
					params += "&noticeTypeCd=" + $("#noticeTypeCd").val();
					params += "&languageCd=" + $("#languageCd").val();
				var result = ajaxCall("${ctx}/NoticeTemplateMgr.do?cmd=saveNoticeTemplateDeployAll", params, false);
				if( result != null && result != undefined ) {
					alert(result.Result.Message);
				}
			}
		}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<div class="mab10 alignR">
				<a href="#" onclick="javascript:deployAll();" class="btn filled authA">서식 내용 전체회사 적용</a>
			</div>
			<form id="authorForm" name="form">
				<input type="hidden" id="modifyContents" name="modifyContents"	/>
				<input type="hidden" id="height" name="height" value="250" />
			</form>
			<form id="templateEditFrm" name="templateEditFrm" method="post">
				<input type="hidden" id="bizCd"         name="bizCd" />
				<input type="hidden" id="noticeTypeCd"  name="noticeTypeCd" />
				<input type="hidden" id="languageCd"    name="languageCd"    value="KR" />
				<input type="hidden" id="usingEditorYn" name="usingEditorYn" />
				<input type="hidden" id="ckEditorContentArea" name="content">
				<table class="table">
					<colgroup>
						<col width="15%" />
						<col width="*" />
					</colgroup>
					<tr id="area_title" class="hide">
						<th>제목</th>
						<td>
							<input id="templateTitle" name="templateTitle" type="text" class="text" style="width:99%;" />
						</td>
					</tr>
					<tr id="area_senderNm" class="hide">
						<th>발신자명</th>
						<td>
							<input id="senderNm" name="senderNm" type="text" class="text" style="width:99%;" />
						</td>
					</tr>
					<tr id="area_sendMail" class="hide">
						<th>발신자 메일</th>
						<td>
							<input id="sendMail" name="sendMail" type="text" class="text" style="width:99%;" />
						</td>
					</tr>
					<tr id="area_sendPhone" class="hide">
						<th>발신자 전화번호</th>
						<td>
							<input id="sendPhone" name="sendPhone" type="text" class="text" style="width:99%;" />
						</td>
					</tr>
					<tr id="area_editor" class="hide">
						<th>내용</th>
						<td>
							<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe"></iframe>
						</td>
					</tr>
					<tr id="area_editor_none" class="hide">
						<th>내용</th>
						<td>
							<textarea id="message" name="message" style="width:99%; height:120px;"></textarea>
						</td>
					</tr>
				</table>
			</form>
		</div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('noticeTemplateMgrEditLayer');" class="btn outline_gray">닫기</a>
			<a href="javascript:save();" class="btn filled">저장</a>
		</div>
	</div>
</body>
</html>