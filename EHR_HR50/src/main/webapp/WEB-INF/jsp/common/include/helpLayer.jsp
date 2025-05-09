<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>도움말</title>
<style>
	.layer-modal-header {border-bottom: 0 !important;}
	.layer-modal-header + div {overflow-y:auto !important;}
	.wrapper.modal_layer .modal_body {height:100%; max-height: calc(100vh - 218px);overflow-y: auto; padding: 28px 32px 40px; border-top:1px solid #e3e3e3;}
	
	.big-title{display:flex; align-items:center; padding-bottom:6px; border-bottom:1px solid #707070;}
	.big-title span{font-size: 20px; font-weight: bold; line-height: 1; letter-spacing: -0.6px; color: #323232;}
	.big-title .mdi-ico{margin: 0px 4px; font-size: 16px; color:#9f9f9f;}
	.big-title>.btn-wrap{margin-left: auto; }
	.editor-wrap{margin-top:12px; background-color:#f8f8f8; width:100%; height: 300px;}
	.dot-list-title{margin-top:20px; font-size: 13px; font-weight: bold; line-height: 1.67;letter-spacing: -0.39px; color: #555;}
	.dot-list li{position:relative; margin-top:6px; padding-left:10px; font-size: 12px; font-weight: 400; line-height: 1.67; letter-spacing: -0.36px; color: #555;}
	.dot-list li::before{content:''; position:absolute; top: 50%; left:0px; margin-top:-1px; display:inline-block; width:4px; height: 4px; background:#555555; border-radius:100%;}
	.dot-list+.btn-title-wrap{margin-top:32px;}
	.btn-title{margin-top:12px; font-size: 13px; font-weight: bold; line-height: 1.54;letter-spacing: -0.39px; color: #555;}
  	.cnt{margin-left:2px;}
  	.point-blue{color:#466ff4;}
  	.file-volume{margin-left:4px; font-size: 12px; font-weight: 600; line-height: 1.67; letter-spacing: -0.36px; color: #b2b2b4;}
  	.save-all{margin-left:8px; font-size: 12px; font-weight: bold; line-height: 1.67; letter-spacing: -0.36px; color: #466ff4;}
  	/* 파일 버튼 타입 */
  	.btn-list-wrap{margin-top:12px; display:flex; flex-wrap:wrap; width: calc(100% + 16px);}
	.btn-list-wrap .item-padding{width:33.333333%; padding-right:16px; padding-bottom:12px;}
	.btn-list-wrap .btn-item{display:flex; align-items: center; padding:12px 14px; border-radius: 8px; border: solid 1px #e0e0e0;}
	.btn-list-wrap .btn-item .inner-wrap{display:flex; align-items: center;}
	.btn-list-wrap .btn-item .ico-file{color:#9e9e9e; font-size:20px; font-weight: 400;}
	.btn-list-wrap .btn-item .file-name{margin-left:8px;}
	.btn-list-wrap .btn-item .ellipsis{width: 266px; white-space: nowrap;overflow: hidden; text-overflow: ellipsis;}
	.btn-list-wrap .btn-item .btn-download{margin-left:auto;}
	.btn-list-wrap .btn-item .btn-download .mdi-ico{font-size: 16px; color:#9e9e9e;}
	/* 파일 리스트 타입 */
	.file-list-wrap{margin-top:8px; width:372px; padding: 12px 20px; border-radius: 8px; border: solid 1px #e0e0e0;}
	.file-list-wrap .list-item{display:flex; align-items: center; margin-top:6px;}
	.file-list-wrap .list-item:first-child{margin-top: 0px;}
	.file-list-wrap .list-item .inner-wrap{display:flex; align-items: center;}
	.file-list-wrap .list-item .ico-file{color:#9e9e9e; font-size:20px; font-weight: 400;}
	.file-list-wrap .list-item .file-name{margin-left:8px;}
	.file-list-wrap .list-item .ellipsis{width: 266px; white-space: nowrap;overflow: hidden; text-overflow: ellipsis;}
	.file-list-wrap .list-item .btn-download{display:flex; align-items: center; margin-left:auto;}
	.file-list-wrap .list-item .btn-download .mdi-ico{font-size: 16px; color:#9e9e9e;}
</style>
	<script type="text/javascript">
		var menuNm;
		$(function () {

			init();
			initEvent();

			searchHelpContent();
			searchHelpFile();
		});

		function init() {
			$("#surlForHelp").val(parent.$("#surl").val());
		}

		function initEvent() {
			$('#btnUpdate').click(function() {
				openMainMuPrgLayer();
			});

			$('#btnDownload').click(function() {
				doDownload();
			});

			$(document).on('click', '#btnDownloadFile', function() {
				downloadFile(this);
			});

			$(document).on('click', '#btnDownloadAll', function() {
				downloadAll();
			});
		}

		function searchHelpContent() {
			try {
				const data = ajaxCall("${ctx}/HelpPopup.do?cmd=getHelpPopupMap",$("#srchForm").serialize(),false).map;
				if (data == null) {
					return;
				}

				$('#helpLocation').html(pageLocation);

				menuNm = data.menuNm;
				let titleTxt = menuNm + " 도움말";
				$('#modal-helpLayer').find('div.layer-modal-header span.layer-modal-title').text(titleTxt);

				$('#mainMenuNm').text(data.mainMenuNm);
				$('#priorMenuNm').text(data.priorMenuNm);
				$('#menuNm').text(data.menuNm);
				$('#prgCd').val(data.prgCd);
				$('#fileSeq').val(data.fileSeq);

				let helpContent = "";
				if ( "${ssnDataRwType}" == "A" ) {
					$("#btnUpdate").show();

					if ( data.mgrHelpYn == "Y" ) {
						helpContent = data.mgrHelp;
					}
				} else {
					$("#btnUpdate").hide();

					if ( data.empHelpYn == "Y" ) {
						helpContent = data.empHelp;
					}
				}

				$('#helpContent').html(helpContent);

				if ( $("#helpContent").html() == "" ) {
					$("#btnDownLoad").hide();
				} else {
					$("#btnDownLoad").show();
				}

			}catch(e){
				alert("doSearch Error:" + e);
			}

		}

		function searchHelpFile() {
			if ($('#fileSeq').val() === null || $('#fileSeq').val() === '') {
				return;
			}

			function successAjax(result) {
				let fileCount = 0;
				let fileTotalSize = 0;
				let fileHtml = '';
				$(result.data).each(function (idx, item) {
					fileCount++;
					fileTotalSize += item.fileSize;

					fileHtml += '<div class="btn-list-wrap">' +
							'	<div class="item-padding">' +
							'		<div class="btn-item" id="fileItem">' +
							'			<span class="inner-wrap">' +
							'				<i class="mdi-ico filled ico-file" title="다운로드">image</i>' +
							'				<span class="file-name ellipsis">' + item.name + '</span>' +
							'			</span>' +
							'			<a href="#" id="btnDownloadFile" class="btn-download"' +
							'data-seq="' + item.seqNo + '">' +
							'       		<i class="mdi-ico" title="다운로드">file_download</i>' +
							'			</a>' +
							'		</div>' +
							'	</div>' +
							'</div>';
				});

				let fileDownloadHtml = '<div class="btn-title-wrap">' +
						'	<div class="btn-title">첨부 ' +
						'		<span class="point-blue cnt">' + fileCount + '</span>개' +
						'		<span class="file-volume">' + convertBytesToKb(fileTotalSize) + 'KB</span>' +
						'		<a id="btnDownloadAll"  style="cursor: pointer;" ><span class="save-all">모두저장</span></a>' +
						'	</div>' +
						'</div>' +
						fileHtml;

				$('#helpDownloadFile').html(fileDownloadHtml);
			}

			$.ajax({
				type: 'post'
				, async: true
				, dataType:"json"
				, url: 'fileuploadJFileUpload.do?cmd=jIbFileList'
				, data: $("#uploadForm").serialize()
				, success: function(result) {
					successAjax(result);
				}, error: function(data, status, err) {
					alert('서버와의 통신이 실패했습니다.');
				}
			});

		}

		function convertBytesToKb(bytes) {
			let kb = bytes / 1024;
			return parseFloat(kb.toFixed(2));
		}

		function doDownload() {
			let helpType = '직원용';
			if ( "${ssnDataRwType}" == "A" ) {
				helpType = '관리자용';
			}

			let fileName = menuNm + "_" + helpType + "_도움말.html";
			let content = $('#helpContent').html();

			$("#tmpFrm").remove();
			let $frm = $('<form id=tmpFrm></form>');
			$frm.attr('action', '${ctx}/HelpPopup.do?cmd=viewHelpPopupDown');
			$frm.attr('method', 'post');
			//$frm.attr('target', 'iFrm');
			$frm.appendTo('body').append("<textarea name='fileName' style='display:none;'>"+ fileName +"</textarea>");
			$frm.appendTo('body').append("<textarea name='content' style='display:none;'>"+ content +"</textarea>");
			$frm.submit();
		}

		function openMainMuPrgLayer() {
			let url = '/MainMuPrg.do?cmd=viewMainMuPrgLayer&authPg=A';
			let p = {
				prgCd : $("#prgCd").val(),
				menuNm : menuNm
			};
			let w = 1500;
			let h = 1000;

			let layerModal = new window.top.document.LayerModal({
				id : 'mainMuPrgLayer'
				, url : url
				, parameters : p
				, width : w
				, height :h
				, title : '도움말 등록'
				, trigger :[
					{
						name : 'mainMuPrgTrigger'
						, callback : function(result){
						}
					}
				]
			});
			layerModal.show();
		}

		function downloadFile(element) {
			let params = [];
			let item = {
				fileSeq : $('#fileSeq').val(),
				seqNo : $(element).data('seq')
			};
			params.push(item);

			$.filedownload($('#uploadType').val(), params);

		}

		function downloadAll() {
			let items = $('.btn-download');
			let params = [];

			// 반드시 역순으로 돌아야 제거 직후에 자료가 밀리거  당겨지는 일이 없다.
			for (let i = items.length - 1; i >=0; i--) {
				let item = {
					fileSeq : $('#fileSeq').val(),
					seqNo : items.eq(i).data('seq'),
					uploadType : $('#uploadType').val()
				};
				params.push(item);
			}

			$.filedownload($('#uploadType').val(), params);
		}

	</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">
		<form id="srchForm" name="srchForm">
			<input type="hidden" name="surl" id="surlForHelp"/>
			<input type=hidden id="prgCd" name="prgCd"/>
		</form>
		<form id="uploadForm" name="uploadForm">
			<input id="fileSeq" name="fileSeq" type="hidden">
			<input id="uploadType" name="uploadType" type="hidden" value="${uploadType}"/>
		</form>
		<div class="modal_body">
			<div class="big-title">
				<span id="helpLocation"></span>
				<div class="btn-wrap">
					<button id="btnUpdate" class="btn outline_gray">수정</button>
					<a href="#" id="btnDownload" class="btn outline_gray">다운로드</a>
				</div>
			</div>

			<div id="helpContent"></div>

			<!-- 파일 버튼 타입 -->
			<div id="helpDownloadFile"></div>
		</div>
	</div>
	<script type="text/javascript" src="${ctx}/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>

</body>

</html>