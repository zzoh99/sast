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
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<!--   VALIDATION	 -->
<script src="/common/js/jquery/jquery.validate.js" type="text/javascript" charset="utf-8"></script>

<style type="text/css">
</style>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var bizCd        = "";
	var bizNm        = "";
	var noticeTypeCd = "";
	var noticeTypeNm = "";
	
	// 에디터 사용 여부
	var isUsingEditor = false;
	
	var templateData  = null;

	$(function(){
		var arg = p.window.popDialogArgumentAll();
		
		if( arg != undefined ) {
			bizCd        = arg["bizCd"];
			bizNm        = arg["bizNm"];
			noticeTypeCd = arg["noticeTypeCd"];
		}
		
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
		
		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
	});
	
	
	// 기존 데이터 폼 세팅
	function initData() {
		var params  = "&bizCd=" + $("#bizCd").val();
			params += "&noticeTypeCd=" + $("#noticeTypeCd").val();
			params += "&languageCd=" + $("#languageCd").val();
			
		templateData = ajaxCall("${ctx}/NoticeTemplateMgr.do?cmd=getNoticeTemplateData", params, false);
		if( templateData != null && templateData != undefined && templateData.DATA != null && templateData.DATA != undefined ) {
			var data = templateData.DATA;
			
			$("#templateTitle").val(data.templateTitle);
			$("#senderNm").val(data.senderNm);
			$("#sendPhone").val(data.sendPhone);
			$("#sendMail").val(data.sendMail);
			
			// 에디터를 사용하는 경우
			if( isUsingEditor ) {
				Editor.modify({
					"content": "" + data.templateContent
				});
			} else {
				$("#message").html(data.templateContent);
			}
		}
	}
	
	// 저장
	function save() {
		if( confirm("저장 하시겠습니까?") ) {
			// 에디터를 사용하는 경우
			if( isUsingEditor ) {
				// 에디터의 내용 textarea 객체에 삽입
				
				$("#content").val(Editor.getContent(true));
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
					var rv = new Array();
					rv["pGubun"] = "templateEditPop";
					rv["Code"] = "1";
					p.popReturnValue(rv);
					p.window.close();
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
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><span id="tit_noticeTypeNm"></span> 알림서식편집</li>
				<li class="close"></li>
			</ul>
		</div>
	
		<div class="popup_main">
			<div class="mab10 alignR">
				<a href="#" onclick="javascript:deployAll();" class="button authA">서식 내용 전체회사 적용</a>
			</div>
			<form id="templateEditFrm" name="templateEditFrm" method="post">
				<input type="hidden" id="bizCd"         name="bizCd" />
				<input type="hidden" id="noticeTypeCd"  name="noticeTypeCd" />
				<input type="hidden" id="languageCd"    name="languageCd"    value="KR" />
				<input type="hidden" id="usingEditorYn" name="usingEditorYn" />
				<input type="hidden" id="content" name="content" />
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
							<%@ include file="/WEB-INF/jsp/common/plugin/Editor/include_editor.jsp"%>
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
	
			<div class="popup_button">
				<ul>
					<li>
						<a href="javascript:save();" class="pink large">저장</a>
						<a href="javascript:p.self.close();" class="gray large">닫기</a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>