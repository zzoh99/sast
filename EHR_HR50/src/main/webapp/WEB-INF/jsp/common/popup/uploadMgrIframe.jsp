<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@ page import="com.hr.common.util.StringUtil"%>
<%
String uploadType = (String)request.getAttribute("uploadType");

if( StringUtil.stringValueOf(uploadType).length() == 0 ) {
	uploadType = request.getParameter("uploadType");
}

if( StringUtil.stringValueOf(uploadType).length() > 0 ) {
   request.setAttribute("uploadType", uploadType);
}

FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>

<link rel="stylesheet" href="${ctx}/common/plugin/IBLeaders/Upload/css/jquery.contextMenu.min.css" />
<link rel="stylesheet" href="${ctx}/common/plugin/IBLeaders/Upload/js/Main/ibupload.css" />
<script type="text/javascript" src="${ctx}/common/plugin/IBLeaders/Upload/js/jquery/1.10.4/jquery.contextMenu.min.js" charset="utf-8"></script>
<script type="text/javascript" src="${ctx}/common/plugin/IBLeaders/Upload/js/jquery/1.10.4/jquery.blockUI.js" charset="utf-8"></script>
<script type="text/javascript" src="${ctx}/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="${ctx}/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>
<script type="text/javascript" src="${ctx}/common/plugin/IBLeaders/Upload/js/ibupload.js"></script>
<script type="text/javascript" src="${ctx}/common/plugin/IBLeaders/Upload/js/ibuploadinfo.js"></script>
  
<script>
	$(function(){

		var fConfig = {fileCount : 5, fileSize : 10 * 1024 * 1024, extExtension : "doc,docx,xls,xlsx,ppt,pptx,pdf,zip,jpeg,jpg,png,bmp,gif"};
<c:if test="${ !empty fConfig && fConfig ne '' }">
			fConfig = ${fConfig};
</c:if>
		
		var contextMenuItems = {
				"download": {name: "다운로드(D)", icon: "", accesskey: "d"},
				"sep1": "---------",
				"viewtype": {
								"name": "보기",
								"items": {
											"icon": {"name": "아이콘 (C)", accesskey: "c"},
											"list": {"name": "간단히 (L)", accesskey: "l"},
											"detail": {"name": "자세히 (D)", accesskey: "d"}
										 }
							 }
		}
		
		var dragDropUplaod = false;
		if("${authPg}" == "A"){
			dragDropUplaod = true;
			contextMenuItems.sep2    = "---------";
			contextMenuItems.add     = {name: "추가 (A)", icon: "", accesskey: "a"};
			contextMenuItems.delete = {name: "삭제 (R)", icon: "delete", accesskey: "r"};
		}
		
		// 첨부파일 목록 보기 모드 변경
		$("input[name=uploadFileViewType]", "#fileDiv").on("click", function(e) {
			$("#myUpload").IBUpload("iconMode", $(this).val());
		});

		// 업로드 컨트롤 초기화
		$("#myUpload").IBUpload({
			uploadServerUrl : "/fileuploadJFileUpload.do?cmd=ibupload&"+$("#uploadForm").serialize(),
			iconMode :"detail", //보기 모드 (icon,list,detail)
			theme :"Main", //기본 테마 폴더
			headerText : {
				"icon32" : "",
				"icon16" : "",
				"name"   : "파일명",
				"date"   : "업로드 일자",
				"type"   : "파일 유형",
				"size"   : "파일 용량",
				"state"  : "상태"
			},
			autoUpload:true, //자동 업로드 기능 사용 여부
			useDragDrop:dragDropUplaod, // 파일 드레그 드롭 기능 사용
			limitFileCount:Number(fConfig.fileCount), // 제한수
			limitFileCountOnce:Number(fConfig.fileCount), // 제한수 한번에 여러개 업로드시
			limitFileSize:Number(fConfig.fileSize), // 제한용량
			limitFileTotalSize:Number(fConfig.fileSize) * Number(fConfig.fileCount), // 총제한용량
			onContextMenu: function(key) { //마우스 우측버튼 메뉴 선택에 따른 이벤트
				doIBUAction(key);
			},
			contextMenuItems: contextMenuItems,
			//====================================================================================================
			// 파일을 추가하기 직전에 발생하는 이벤트에서 파일 차단
			//====================================================================================================
			onBeforeAddFile: function(Reserved, tryAddFiles) {
				//console.log('tryAddFiles', tryAddFiles);
				var isValid = true;
				if( fConfig != null && fConfig != undefined && fConfig.extExtension != null && fConfig.extExtension != undefined ) {
					var _extRegExp = new RegExp(fConfig.extExtension.split(",").join("|"), "i");
					var fileSplit = null;
					var fileExt = "";
					var extsArr = fConfig.extExtension.split(",");
					
					for (var i = 0; i < tryAddFiles.length; i++) {
						fileExt = "";
						
						if(tryAddFiles[i].name.indexOf(".") > -1) {
							fileSplit = tryAddFiles[i].name.split('.');
							if (fileSplit.length > 1) {
								fileExt = fileSplit[fileSplit.length - 1];
							} 
						}
						
						if( fileExt != "" ) {
							if( (_extRegExp != null && !_extRegExp.test(fileExt)) ) {
								alert(fileExt + " 확장자는 지원하지 않는 확장자(타입) 입니다.\n\n* 파일명 : " + tryAddFiles[i].name + "\n* 업로드 가능 확장자 : [" + fConfig.extExtension + "]");
								isValid = false;
								break;
							}
						}
					}
				}
				
				if( !isValid ) {
					return true;
				}
			},
			onUploadFinish: function(serverResponseObject , replacedResponseObject){
				if(serverResponseObject.code == "success" && serverResponseObject.data.length){
					$("#uploadForm>#fileSeq").val(serverResponseObject.data[0].fileSeq);
					doIBUAction("search");
					$("#myUpload").IBUpload("uploadServerUrl", "/fileuploadJFileUpload.do?cmd=ibupload&"+$("#uploadForm").serialize());
				}
			},
			onDblClick:function(uploadid){
				doIBUAction("download");
			},
		});

		$(window).smartresize(resizeIframeHeight);
		resizeIframeHeight();

		initButtonEvent();
		doIBUAction("search");
	});

	//================================================================================
	// 웹페이지 버튼 기능 처리
	//================================================================================
	function doIBUAction(sAction) {
		const $myUpload = $("#myUpload");
		const $uploadForm = $("#uploadForm");
		switch (sAction) {
			case "add":
				//업로드 지정
				$myUpload.IBUpload("uploadServerUrl", "/fileuploadJFileUpload.do?cmd=ibupload&" + $uploadForm.serialize());
				//화면에 파일을 추가한다.
				$myUpload.IBUpload("add");
				break;

			case "delete":
				var i = 0;
				var fileList = [];
				var params = [];
				fileList = $myUpload.IBUpload('fileList');
				if (fileList.length > 0 && confirm("선택된 파일을 삭제를 하시겠습니까?")) {
					//선택 파일 객체생성
					for (i = fileList.length - 1; i >= 0; i--) { // 반드시 역순으로 돌아야 제거 직후에 자료가 밀리거  당겨지는 일이 없다.
						if ($myUpload.IBUpload('selectedIndex', {index: i}) == true) { // jpg 파일들 중에서 선택된 파일들만 모두 제거
							var item = {};
							fileList[i].upType = $uploadForm.find("#uploadType").val();
							fileList[i].work = $("#work").val();
							params.push(fileList[i]);
						}
					}
					//화면에서 파일을 삭제한다.
					$myUpload.IBUpload("delete");

					$.filedelete($uploadForm.find("#uploadType").val(), params, function (code, message) {
						if(code == "success") {
							var msg = (message ? message : "<msg:txt mid='' mdef='파일이 삭제되었습니다.'/>");
							//alert(msg);
						} else {
							var msg = (message ? message : "<msg:txt mid='errorDelete2' mdef='삭제에 실패하였습니다.'/>");
							alert(msg);
						}
					});
					
				}
				break;

			//autoUpload : false일 시 사용	
			case "upload":
				//서버로 전송할 파라미터
				//$("#myUpload").IBUpload("extendParamUpload", $("#uploadForm").serialize());
				$myUpload.IBUpload("uploadServerUrl", "/fileuploadJFileUpload.do?cmd=ibupload&" + $uploadForm.serialize());
				//서버에 파일을 전송 한다.(파일 저장/삭제)
				$myUpload.IBUpload("upload", {
					onUploadData: function (files) {
						alert('서버 응답 처리 로직이 변경되었습니다 ');
					},
					callback: function (files) {
						alert('서버에 업로드를 처리한 직후 입니다.');
					}
				});
				break;

			case "download":
				var i = 0;
				var fileList = [];
				var params = [];
				fileList = $myUpload.IBUpload('fileList');
				for (i = fileList.length - 1; i >= 0; i--) { // 반드시 역순으로 돌아야 제거 직후에 자료가 밀리거  당겨지는 일이 없다.
					if ($myUpload.IBUpload('selectedIndex', {index: i})) { // jpg 파일들 중에서 선택된 파일들만 모두 제거
						var item = {};
						item.fileSeq = $uploadForm.find("#fileSeq").val();
						item.uploadType = $uploadForm.find("#uploadType").val();
						item.work = $("#work").val();
						item.seqNo = fileList[i].url;
						
						params.push(item);
					}
				}

				$.filedownload($uploadForm.find("#uploadType").val(), params);
				break;
			case "downloadAll":
				
				var i = 0;
				var fileList = [];
				var params = [];
				fileList = $myUpload.IBUpload('fileList');
				if(fileList.length > 0) {
					for (i = fileList.length-1; i >= 0; i--) { // 반드시 역순으로 돌아야 제거 직후에 자료가 밀리거  당겨지는 일이 없다.
						var item = {};
						item.fileSeq = $uploadForm.find("#fileSeq").val();
						item.uploadType = $uploadForm.find("#uploadType").val();
						item.work = $("#work").val();
						item.seqNo = fileList[i].url;
						
						params.push(item);
					}

					$.filedownload($uploadForm.find("#uploadType").val(), params);
				}
				break;
			case "icon":
			case "list":
			case "detail":
				$myUpload.IBUpload("iconMode", sAction);
				break;
			case "search":
				if ($uploadForm.find("#fileSeq").val() != null && $uploadForm.find("#fileSeq").val() != "") {
					$.ajax({
						type: 'post'
						, async: true
						, dataType:"json"
						, url: 'fileuploadJFileUpload.do?cmd=jIbFileList'
						, data: $uploadForm.serialize()
						, success: function(result) {
							var searchFile = [];
							if(result.data != null && result.data.length > 0) {
								$(result.data).each(function(idx,item) {
									item.size = item.fileSize;
									item.date = item.fileDate;
									item.url  = item.seqNo; //파일 삭제 및 다운로드용 키값
									searchFile.push(item);
								});

								$myUpload.IBUpload("files", searchFile);
								// 업로드 기능을 제공하는 서버 쪽 jsp 프로그램의 경로를 재설정 한다.
								$myUpload.IBUpload("uploadServerUrl", "/fileuploadJFileUpload.do?cmd=ibupload&" + $uploadForm.serialize());

								// 기존에 등록된 파일이 있는 경우 파일 업로드 제한수 재설정
								if( result != null && result != undefined && result.length > 0 ) {
									var limitFileCount = Number(fConfig.fileCount) - result.length;
									$myUpload.IBUpload({
										limitFileCount : limitFileCount,
										limitFileCountOnce : limitFileCount,
										limitFileTotalSize : Number(fConfig.fileSize) * limitFileCount
									});
								}
							}
						}
						, error: function(data, status, err) {
							alert('서버와의 통신이 실패했습니다.');
						}
					});
				}
				break;
			
			case "removeall":
				$myUpload.IBUpload("reset");
				break;

			case "loadView":
				var fileList = $myUpload.IBUpload('fileList');
				var selectedFile = null;

				var selectedCount = 0;
				for (var i = 0; i < fileList.length; i++) {
					if ($myUpload.IBUpload('selectedIndex', {index: i}) === true) {
						selectedCount++;
						if (selectedCount > 1) {
							// 2건 이상 선택된 경우
							alert('미리보기할 파일을 한건만 선택해주세요.');
							return;
						}
						selectedFile = fileList[i];
					}
				}

				if (selectedFile) {
					var fileExt = selectedFile.name.split('.').pop().toLowerCase();

					// 이미지 파일 확장자 목록
					var imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp','pdf'];

					// 확장자가 이미지 파일 목록에 있는지 확인
					if (imageExtensions.includes(fileExt)) {
						var fileURL = encodeURIComponent("${ctx}/AttachFileView.do?enterCd=" + selectedFile.enterCd + "&reqSeq=" + selectedFile.seqNo + "&fileSeq=" + selectedFile.fileSeq + "&fileExt=" + fileExt);
						var winHeight = document.body.clientHeight; // 현재창의 높이
						var winWidth = document.body.clientWidth; // 현재창의 너비

						var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
						var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표

						var popX = winX + (winWidth - 900) / 2;
						var popY = winY + (winHeight - 900) / 2;

						var popupURL = "/Upload.do?cmd=uploadMgrViewPopup&fileURL=" + fileURL + "&fileExt=" + fileExt;

						globalWindowPopup = window.open(popupURL, "uploadMgrViewPopup", "width=815px,height=900px,top="+popY+",left="+popX+",scrollbars=no,resizable=yes,menubar=no");
						globalWindowPopup.focus();
					} else {
						alert('선택된 파일은 미리보기 가능 파일이 아닙니다.');
					}
				} else {
					alert('선택된 파일이 없습니다.');
				}
				break;

			default:
		}
	}

	function initButtonEvent() {
		$("a#fileDelete").off().on("click", function(e) {
			doIBUAction('delete');
		});

		$("a#fileDownload").off().on("click", function(e) {
			doIBUAction('download');
		});

		$("a#addFile").off().on("click", function(e) {
			doIBUAction('add');
		});

		$("a#allFileDownload").off().on("click", function(e) {
			doIBUAction('downloadAll');
		});

		$("a#filePreview").off().on("click", function(e) {
			doIBUAction('loadView');
		});
	}

	/**
	 * 첨부파일 iframe resize
	 */
	function resizeIframeHeight() {
		const windowHeight = document.body.offsetHeight; // iframe 높이
		const innerHeight = document.getElementsByClassName("inner")[0].offsetHeight; // inner(헤더) 높이
		const ibProduct = document.getElementsByClassName("ib_product1")[0]; // IBUpload 상위 노드
		ibProduct.style.height = windowHeight - innerHeight + "px";
	}

	/**
	 * IBUpload fileList 조회
	 */
	function getFileList() {
		return $("#myUpload").IBUpload('fileList');
	}

	/**
	 * fileSeq 조회
	 */
	function getFileSeq() {
		return $("#uploadForm>#fileSeq").val();
	}
</script>
</head>
<body>
	<div id="fileDiv">
		<form id="uploadForm" name="uploadForm">
			<input id="fileSeq" name="fileSeq" type="hidden" value="${param.fileSeq}">
			<input id="uploadType" name="uploadType" type="hidden" value="${uploadType}"/>
			<input id="work" name="work" type="hidden" />
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" style="height: 100%;">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title" style="overflow: hidden;">
							<ul>
								<li class="txt"><tit:txt mid='uploadFile' mdef='첨부파일'/></li>
								<li class="btn">
									<span class="f_point f_bold">보기 모드</span>
									&nbsp;
									<input type="radio" id="uploadFileViewType_icon" name="uploadFileViewType" value="icon" />
									<label class="mar5" for="uploadFileViewType_icon">아이콘</label>
									<input type="radio" id="uploadFileViewType_list" name="uploadFileViewType" value="list" />
									<label class="mar5" for="uploadFileViewType_list">간단히</label>
									<input type="radio" id="uploadFileViewType_detail" name="uploadFileViewType" value="detail" checked="checked" />
									<label class="mar5" for="uploadFileViewType_detail">자세히</label>
									&nbsp;
									<btn:a id="filePreview" css="basic" mid='' mdef="미리보기"/>
									<btn:a id='fileDelete' css="basic authA" mid='fileDelete' mdef="파일삭제"/>
									<btn:a id='fileDownload' css="basic " mid='fileDownload' mdef="다운로드"/>
									<btn:a id='addFile' css="basic authA" mid='addFile' mdef="추가"/>
									<btn:a id='allFileDownload' css="button " mid='allFileDownload' mdef="전체다운로드"/>
								</li>
							</ul>
						</div>
					</div>
					<div class="ib_product1" style="width: 100%;">
						<!--main_content-->
						<div id="myUpload" style="border:1px solid #DADADA;"></div>
					</div>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>