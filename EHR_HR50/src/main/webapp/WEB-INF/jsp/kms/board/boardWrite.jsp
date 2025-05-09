<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
	<title><tit:txt mid='112842' mdef='게시판 Writer'/></title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<script src="${ctx}/common/plugin/ckeditor5/ckeditor5-41.4.2/ckeditor.js"></script>
	<style>
		/*CkEditor Setting Style*/
		.ck-sticky-panel__content_sticky {
		    position: relative !important;
		    top: auto !important;
		    width: 100% !important;
		}
		.ck-editor__main {
	    	min-height: 500px;  /* Define minimum height for the entire editor */
		}
		.ck-focused,
		.ck-blurred{
		    min-height: 500px!important;
		    overflow-y: auto;
		}
	</style>
	<%
		request.setAttribute("uploadType", "board001");
	%>
	<script type="text/javascript">
		//CkEditor Setting
		//getData : window.instanceEditor.getData()
		//modify(setData) : window.instanceEditor.setData()
		//save : window.instanceEditor.customMethods.save(form)

		//CKEDITOR 전역 선언
		window.top.CKEDITOR = CKEDITOR;

		$(function(){
			$("#bbsSeq").val("${map.bbsSeq}");
			$("#saveType").val("${map.saveType}");
			$("#bbsCd").val("${map.bbsCd}");
			$("#burl").val("${map.burl}");

			var depth =  ("${param.saveType}"!="reply") ? 0: Number($("#depth").val())+ 1;
			$("#depth").val(depth);

			if("${map.headYn}" == "Y" ){
				var bizCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","${map.head}"), "<tit:txt mid='111914' mdef='선택'/>");	//카테고리
				$("#boardHead").html(bizCd[2]);
			}

			if("${map.saveType}"=="update") {
				htmlLoad();
			}

			//파일첨부
			if("${map.fileYn}" === "Y" ) {
				//file path null 이면 메인메뉴에 해당되는 메뉴에 저장됨
				initFileUploadIframe("boardWriteUploadForm", $("#fileSeq").val(), "board001", "A");
			}

			//공지여부
			if("${map.notifyYn}" == "N" ){
				$("#notifyTermTr").hide();
			} else $("#notifyTermTr").show();
			//목록
			$('#List').click(function(){
				submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardList");
			});

			//작성권한이 'Y' 이거나 관리자권한이 'Y' 이어야 답글 작성가능
			if("${map.manageYn}"=="Y" || "${map.adminYn}"=="Y"){
				$("#topNotifyYnSpan").show();
			} else {
				$("#topNotifyYnSpan").hide();
			}

			$("#boardHead").change(function(){
				var str = $(this).children("option:selected").text();
				var str = (str == "" ) ? "":  str;
				$("#boardHeadNm").val(str);
			});

			$("#notifySdate").datepicker2({startdate:"notifyEdate"});
			$("#notifyEdate").datepicker2({enddate:"notifySdate"});
		});

		<c:if test="${map.checkYn=='Y'}">
		function checkContent() {

			$("#saveType").val("select");
			if("${map.fileYn}" === "Y" ) {
				$("#srchFrm>#fileSeq").val(getFileUploadContentWindow("boardWriteUploadForm").getFileSeq());
			}

			//var f = objToJson($("#srchFrm").serializeArray());
			var f = document.getElementById("srchFrm");
			f.action = "${ctx}/Board.do?cmd=saveBoard"

			if($("#popNotifyYnChk").is(":checked")) {
				$("#popNotifyYn").val("Y");
			} else {
				$("#popNotifyYn").val("N");
			}

			// f.submit();
			// document.getElementById("srchFrm").submit();
			//submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=saveBoard");
			//Editor.save(); // 이 함수를 호출하여 글을 등록하면 된다.

			//CkEditor Setting
			window.instanceEditor.customMethods.save(f);
		}

		function objToJson(formData){
			var data = formData;
			var obj = {};
			$.each(data, function(idx, ele){
				obj[ele.name] = ele.value;
			});
			return obj;
		}

		function list() {

			$("#saveType").val("select");

			var f = document.srchFrm;
			f.action = "${ctx}/Board.do?cmd=getListBoard";
			f.submit();
			//submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=saveBoard");
			//Editor.save(); // 이 함수를 호출하여 글을 등록하면 된다.
		}


		</c:if>

		function htmlLoad(){
			// 입력 폼 값 셋팅
			var data = ajaxCall("${ctx}/Board.do?cmd=getBoardContent",$("#srchFrm").serialize(),false);
			if(data.boMap == null){
				$("#title").val("");
				$("#hiddenContent").html("");
				//Editor.modify({
				//	"content": ""+ " "
				//});

				//CkEditor Setting
				window.modifyData = '';
			}
			else {
				//$("#boardHead").val(data.map.head);
				$("#title").val(data.boMap.title.replace("["+data.boMap.head+"]",""));
				//$("#hiddenContent").html(data.boMap.contents);
				//Editor.modify({
				//	"content": ""+$("#hiddenContent").html()
				//});

				// $('#ckEditorContentArea').val(data.boMap.contents);
				//CkEditor Setting
				window.modifyData = data.boMap.contents;

				//담당자
				$("#contact").val(data.boMap.contact);
				//Tag
				$("#boardTag").val(data.boMap.tag);
				//파일
				$("#fileSeq").val(data.boMap.fileSeq);

				//머릿글 선택
				$("#boardHeadNm").val(data.boMap.head);
				$("#boardHead").val(data.boMap.head).attr("selected", "selected");

				$("#notifySdate").val(data.boMap.notifySdate);
				$("#notifyEdate").val(data.boMap.notifyEdate);
				$("#popNotifyYn").val(data.boMap.popNotifyYn);
				if(data.boMap.popNotifyYn == "Y") {
					$("#popNotifyYnChk").attr("checked", true);
				} else $("#popNotifyYnChk").attr("checked", false);
				$("#topNotifyYn").val(data.boMap.topNotifyYn);
				if(data.boMap.topNotifyYn == "Y") {
					$("#topNotifyYnChk").attr("checked", true);
				} else $("#topNotifyYnChk").attr("checked", false);
			}
		}

		//Sheet1 Action
		function doAction1(sAction) {

			switch (sAction) {
				case "List":
					alert("1");
					$("#saveType").val("select");
					submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardList");
					alert("2");
					break;

					break;
				case "Read":
					$("#saveType").val("select");
					submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardRead");
					break;
			}
		}

	</script>
</head>

<body class="">
<div class="wrapper">
	<table class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">${map.bbsNm}</li>

							<li class="btn">
								<btn:a id="List" css="basic" style="display:none" mid='110938' mdef="목록"/>
								<c:if test="${map.checkYn=='Y'}">
									<c:set var="authPg"	value="A" />
									<btn:a id="Save" onclick="checkContent();" css="basic" mid='110708' mdef="저장"/>
									<btn:a id="List" onclick="list();" css="basic" mid='list' mdef="목록"/>
								</c:if>

							</li>
						</ul>
					</div>
				</div>

				<form id="srchFrm" name="srchFrm" method="post">
					<input type=hidden id=saveType    name="saveType">
					<input type=hidden id=bbsCd 	    name=bbsCd>
					<input type=hidden id=bbsSeq	  	name=bbsSeq>
					<input type=hidden id=burl	  	name=burl>
					<!--
				<input type=hidden id="depth"      	name="depth">
				<input type=hidden id=priorBbsSeq	name=priorBbsSeq>
				<input type=hidden id=masterBbsSeq 	name=masterBbsSeq>
				<input type=hidden id=authPg 	  	name=authPg		value="${param.authPg}">
				-->
					<input type=hidden id="fileSeq"   	name="fileSeq">
					<!--
                    <input type=hidden id="bbsSort"   	name="bbsSort">
                    <input type=hidden id="content"   	name="content">
                    -->

					<%--	//CkEditor Setting--%>
					<input type="hidden" id="ckEditorContentArea" name="content">

					<table class="table">
						<colgroup>
							<col width="100" />
							<col width="" />
						</colgroup>

						<tr <c:if test="${map.headYn!='Y'}">style="display:none""</c:if>>
						<th class="center"><tit:txt mid='113213' mdef='카테고리'/></th>
						<td >
							<select id="boardHead" name="boardHead"></select>
							<input type=hidden  id="boardHeadNm" name="boardHeadNm">
						</td>
						</tr>
						<tr>
							<th class="center"><tit:txt mid='103918' mdef='제목'/></th>
							<td><input type="text" id="title" name="title" class="text w100p" style="max-width: none;">
								<span id="topNotifyYnSpan" name="topNotifyYnSpan" class="hide"><!--  상단공지&nbsp; --><input type="checkbox" id="topNotifyYnChk" name="topNotifyYnChk" class="hide"/>
											<input type="hidden" id="topNotifyYn" name="topNotifyYn" value="" />
										</span>
							</td>
						</tr>
						<tr id="notifyTermTr">
							<th class="center"><tit:txt mid='113374' mdef='공지기간'/></th>
							<td ><input type="text" id="notifySdate" name="notifySdate" class="date2" /> ~ <input type="text" id="notifyEdate" name="notifyEdate" class="date2" />
								&nbsp;&nbsp;&nbsp;
								팝업공지여부&nbsp;<input type="checkbox" id="popNotifyYnChk" name="popNotifyYnChk" />
								<input type="hidden" id="popNotifyYn" name="popNotifyYn" value="" />
							</td>
						</tr>

						<tr <c:if test="${map.contactYn!='Y'}">style="display:none"</c:if>>
							<th class="center"><tit:txt mid='manager' mdef='담당자'/></th>
							<td ><input type="text" id="contact" name="contact" class="text w100p"></td>
						</tr>


						<!--
							<tr>
									<th class="center"><tit:txt mid='113375' mdef='작성자'/></th>
									<td ><input type="text" id="boardWriter" name="boardWriter" class="text w100p"></td>
							</tr>
							-->

						<%--	CkEditor Setting	--%>
						<tr>
							<th class="center"><tit:txt mid='104429' mdef='내용'/></th>
							<td class="include" style="background:#fff;" height="550;">
								<%@ include file="/WEB-INF/jsp/common/plugin/Ckeditor/include_editor.jsp"%>
							</td>
						</tr>

						<tr <c:if test="${map.tagYn!='Y'}">style="display:none"</c:if>>
							<th class="center" >Tag</th>
							<td ><input type="text" id="boardTag" name="boardTag" class="text w100p"></td>
						</tr>
					</table>
				</form>
				<div  style="clear:both;overflow:hidden;<c:if test="${map.fileYn!='Y'}">display:none</c:if>" >
					<iframe id="boardWriteUploadForm" name="boardWriteUploadForm" frameborder="0" class="author_iframe" style="height:200px;"></iframe>
				</div>
				<div id="hiddenContent" Style="display:none"></div>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
