<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%
String uploadType = "processMapHelp";
request.setAttribute("uploadType", uploadType);
FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>
<link rel="stylesheet" href="${ctx}/common/plugin/IBLeaders/Upload/css/jquery.contextMenu.min.css" />
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
		
		if(modalScript.authPg == "A"){
			$("a").removeClass("authA");
			dragDropUplaod = true;
			contextMenuItems.sep2    = "---------";
			contextMenuItems.add     = {name: "추가 (A)", icon: "", accesskey: "a"};
			contextMenuItems.delete = {name: "삭제 (R)", icon: "delete", accesskey: "r"};
		}
		
		// 첨부파일 목록 보기 모드 변경
		$("input[name=uploadFileViewType]", "#fileDiv").click(function(){
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
		
		doIBUAction("search");
	});

	//================================================================================
	// 웹페이지 버튼 기능 처리
	//================================================================================
	function doIBUAction(sAction) {
		switch (sAction) {
			case "add":
				//업로드 지정
				$("#myUpload").IBUpload("uploadServerUrl", "/fileuploadJFileUpload.do?cmd=ibupload&"+$("#uploadForm").serialize());
				//화면에 파일을 추가한다.
				$("#myUpload").IBUpload("add");
				break;

			case "delete":

				var i = 0;
				var fileList = [];
				var params = [];
				fileList = $('#myUpload').IBUpload('fileList');
				if(fileList.length > 0 && confirm("선택된 파일을 삭제를 하시겠습니까?")) {
					//선택 파일 객체생성
					for (i = fileList.length-1; i >= 0; i--) { // 반드시 역순으로 돌아야 제거 직후에 자료가 밀리거  당겨지는 일이 없다.
						if ($('#myUpload').IBUpload('selectedIndex', {index:i}) == true ) { // jpg 파일들 중에서 선택된 파일들만 모두 제거
							var item = {};
							fileList[i].upType = $("#uploadForm>#uploadType").val();
							fileList[i].work = $("#work").val();
							params.push(fileList[i]);
						}
					}
					//화면에서 파일을 삭제한다.
					$("#myUpload").IBUpload("delete");
					
					$.filedelete($("#uploadForm>#uploadType").val(), params, function(code, message) {
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
				$("#myUpload").IBUpload("uploadServerUrl", "/fileuploadJFileUpload.do?cmd=ibupload&"+$("#uploadForm").serialize());
				//서버에 파일을 전송 한다.(파일 저장/삭제)
				$("#myUpload").IBUpload("upload", {
					onUploadData: function(files){
						alert('서버 응답 처리 로직이 변경되었습니다 ');
					},
					callback: function(files){
						alert('서버에 업로드를 처리한 직후 입니다.');
					}
				});
				break;

			case "download":
				
				var i = 0;
				var fileList = [];
				var params = [];
				
				fileList = $('#myUpload').IBUpload('fileList');
				for (i = fileList.length-1; i >= 0; i--) { // 반드시 역순으로 돌아야 제거 직후에 자료가 밀리거  당겨지는 일이 없다.
					if ($('#myUpload').IBUpload('selectedIndex', {index:i}) == true ) { // jpg 파일들 중에서 선택된 파일들만 모두 제거
						var item = {};
						item.fileSeq = $("#uploadForm>#fileSeq").val();
						item.uploadType = $("#uploadForm>#uploadType").val();
						item.work = $("#work").val();
						item.seqNo = fileList[i].url;
						
						params.push(item);
					}
				}
				
				$.filedownload($("#uploadForm>#uploadType").val(), params);
				break;
			case "downloadAll":
				
				var i = 0;
				var fileList = [];
				var params = [];
				fileList = $('#myUpload').IBUpload('fileList');
				if(fileList.length > 0){
					for (i = fileList.length-1; i >= 0; i--) { // 반드시 역순으로 돌아야 제거 직후에 자료가 밀리거  당겨지는 일이 없다.
						var item = {};
						item.fileSeq = $("#uploadForm>#fileSeq").val();
						item.uploadType = $("#uploadForm>#uploadType").val();
						item.work = $("#work").val();
						item.seqNo = fileList[i].url;
						
						params.push(item);
					}
					
					$.filedownload($("#uploadForm#uploadType").val(), params);
				}
				break;
			case "icon":
			case "list":
			case "detail":
				$("#myUpload").IBUpload("iconMode",sAction);
				break;
			case "search":
				if($("#uploadForm>#fileSeq").val() != null && $("#uploadForm>#fileSeq").val() != ""){
					$.ajax({
						type: 'post'
						, async: true
						, dataType:"json"
						, url: 'fileuploadJFileUpload.do?cmd=jIbFileList'
						, data: $("#uploadForm").serialize()
						, success: function(result) {
							var searchFile = [];
							if(result.data != null && result.data.length > 0) {
								$(result.data).each(function(idx,item) {
									item.size = item.fileSize;
									item.date = item.fileDate;
									item.url  = item.seqNo; //파일 삭제 및 다운로드용 키값
									searchFile.push(item);
								});

								$("#myUpload").IBUpload("files",searchFile);
								// 업로드 기능을 제공하는 서버 쪽 jsp 프로그램의 경로를 재설정 한다.
								$("#myUpload").IBUpload("uploadServerUrl", "/fileuploadJFileUpload.do?cmd=ibupload&"+$("#uploadForm").serialize());

								// 기존에 등록된 파일이 있는 경우 파일 업로드 제한수 재설정
								if( result != null && result != undefined && result.length > 0 ) {
									var limitFileCount = Number(fConfig.fileCount) - result.length;
									$("#myUpload").IBUpload({
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
				$("#myUpload").IBUpload("reset");
				break;

			default:
		}
	}
	
	//fileSeq가 존재하면 파일을 조회하고 존재하지 않으면 신규fileSeq를 얻는다
	function upLoadInit(fileSeq,filePath){
		if(fileSeq != null && fileSeq != "") {
			$("#uploadForm>#fileSeq").val(fileSeq);
			doIBUAction("search");
		}
	}
</script>
    
<div id="fileDiv" class="mat10">
	<form id="uploadForm" name="uploadForm">
		<input id="fileSeq" name="fileSeq" type="hidden">
		<input id="uploadType" name="uploadType" type="hidden" value="processMapHelp"/>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tbody>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title" style="overflow: hidden;">
						<ul>
							<li class="txt"><tit:txt mid='uploadFile' mdef='첨부파일'/></li>
							<li class="btn">
								<span class="f_point f_bold">보기 모드</span>
								&nbsp;
								<input type="radio" id="uploadFileViewType_icon" name="uploadFileViewType" value="icon"/>
								<label class="mar5" for="uploadFileViewType_icon">아이콘</label>
								<input type="radio" id="uploadFileViewType_list" name="uploadFileViewType" value="list">
								<label class="mar5" for="uploadFileViewType_list">간단히</label>
								<input type="radio" id="uploadFileViewType_detail" name="uploadFileViewType" value="detail" checked="checked" />
								<label class="mar5" for="uploadFileViewType_detail">자세히</label>
								&nbsp;
								<btn:a href="javascript:doIBUAction('delete');"   	 css="basic authA" mid='' mdef="삭제"/>
								<btn:a href="javascript:doIBUAction('download')"  	 css="basic " mid='' mdef="다운로드"/>
								<btn:a href="javascript:doIBUAction('downloadAll')"  css="basic " mid='' mdef="전체다운로드"/>
								<btn:a href="javascript:doIBUAction('add')" 	     css="basic outline_black icon authA" mid='' mdef=""><i class="mdi-ico">add</i>파일첨부</btn:a>
								<!-- <btn:a href="javascript:doIBUAction('upload')" 	     css="basic authA" mid='' mdef="업로드"/> -->
							</li>
						</ul>
					</div>
				</div>
				<div class="ib_product1" style="width: 100%;height:200px">
					<!--main_content-->
					<div  id="myUpload" style="border:1px solid #DADADA;"></div>
				</div>
			</td>
		</tr>
	</tbody>
	</table>
</div>
<!-- 
	<input type="radio" name="rdo" value="아이콘"  onClick="doIBUAction('icon')"  class="radio"   />아이콘
	<input type="radio" name="rdo" value="간단히"  onClick="doIBUAction('list')"  class="radio"/>간단히
	<input type="radio" name="rdo" value="자세히"  onClick="doIBUAction('detail')"  class="radio" checked />자세히
-->
