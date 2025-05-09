<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%
String uploadType = "pht001";
request.setAttribute("uploadType", uploadType);
FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='phtRegLayer' mdef='사진등록'/></title>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />

<script type="text/javascript">
	//var p = eval("${popUpStatus}");
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('phtRegLayer');

		// $(".close,#btn-close").click(function() {
		// 	p.popReturnValue([]);
		// 	p.self.close();
		// });

		// var arg = p.popDialogArgumentAll();
		if( modal != undefined ) {
	    	$("#txtSabun").text(modal.parameters.sabun);
	    	$("#txtName").text(modal.parameters.name);
	    	$("#sabun").val(modal.parameters.sabun);
	    }

	    downloadFile((new Date()).getTime());

		var options = $.extend(true, ${fConfig}, {
			btn : {
				browse : {
					title : "파일선택",
					class : "browse-btn"
				}
			},
			context:"${ctx}",
			event:{
				success: function(jsonData) {
					if(jsonData.data !== undefined && jsonData.data !== null && jsonData.data.length > 0) {
						var params = function(p) {
							var rtn = "sabun="+encodeURIComponent($("#sabun").val()) + "&gubun=1";
							$.each(p, function(key, value) {
								rtn += "&" + key + "=" + encodeURIComponent(value);
							});

							return rtn
						}(jsonData.data[0]);

						var result = ajaxCall("/EmployeePhotoSave.do", params, false).result;
						if(result.code == "success") {
							downloadFile((new Date()).getTime());
						} else {
							alert(result.message);
						}
					}
				},
				error: function(jsonData) {
					alert(jsonData.msg);
				}
			},
			localeCd:"${ssnLocaleCd}"
		}),
		params = {
			'uploadType' :"${uploadType}",
			'fileSeq' : '',
			'sabun' : $("#sabun").val()
		};

		$("#fileuploader").fileupload("init", options, params);
		
	});

	function downloadFile(t){
		$("#photo").attr("src", "${ctx}/EmpPhotoOut.do?_t=" + t + "&searchKeyword="+$("#sabun").val() + "&type=1");
	}
	
	function phtoOnLoad(imgObj) {
		
		if( !$("#area_resize").hasClass("hide") ) {
			$("#area_resize").addClass("hide");
		}
		
		var img = new Image();
		var _width, _height;
		img.src = imgObj.src;
		
		img.onload = function() {
			if( this.width != 70 && this.height != 91 ) {
				//console.log('img', this);
				$("#txt_width").html(this.width);
				$("#txt_height").html(this.height);
				if( this.width > 180 ) {
					$("#btn_resize").removeClass("hide");
				}
				$("#area_resize").removeClass("hide");
			}
		}
	}
	
	function resize() {

		var param = "searchKeyword=" + $("#sabun").val();
		var data = ajaxCall("${ctx}/EmployeePhotoResize.do", param, false);
		if( data != null && data != undefined ) {
			if( data.result.message != null && data.result.message != undefined && data.result.message != "" ) {
				alert(data.result.message);
			}
			if( data.result.code != null && data.result.code != undefined && data.result.code == "success" ) {
				downloadFile((new Date()).getTime());
			}
		}
	}
</script>

<body>
<div class="wrapper modal_layer">
	<div class="modal_body">
<%--		<table class="default inner">--%>
			<colgroup>
				<col width="" />
			</colgroup>
			<tr>
				<td>
					<table border="0" cellpadding="0" cellspacing="0" class="default inner fixed">
					<colgroup>
						<col width="130px" />
						<col width="20%" />
						<col width="%" />
					</colgroup>
					<tr>
						<td rowspan="3" class="photo"><img src="/common/images/common/img_photo.gif" id="photo" width="110" height="165" onerror="javascript:this.src='/common/images/common/img_photo.gif'" onload="javascript:phtoOnLoad(this);" /></td>
						<th><tit:txt mid='103975' mdef='사번'/></th>
						<td><span id="txtSabun"></span></td>
					</tr>
					<tr>
						<th><tit:txt mid='103880' mdef='성명'/></th>
						<td><span id="txtName"></span></td>
					</tr>
					<tr>
						<th colspan="2" class="h40">
							<%--
							- 사이즈 : 80px * 101px 입니다.<br/>
							- 확장자 : jpg,jpeg 만 가능합니다. (ex) aa.jpg, aa.jpeg<br/>
							 --%>
							<div id="area_resize" class="hide">
								사진 실제 크기 : <span id="txt_width" class="f_red"></span> px X <span id="txt_height" class="f_red"></span> px
								&nbsp;&nbsp;
								<a href='javascript:resize();' id="btn_resize" class='button hide'>사진크기조정</a>
							</div>
<%--						</td>--%>
					</tr>
					</table>
					<div class="sheet_title" style="overflow: hidden;">
						<ul>
							<li class="txt"><tit:txt mid='113090' mdef='파일 첨부'/></li>
							<li class="btn">
								<ul>
									<li>
										<div id='fileuploader' class="fileuploader" align='right' style="padding-top: 5px;"></div>
										<input type="hidden" id="sabun" name="sabun" />
									</li>
								</ul>
							</li>
						</ul>
					</div>
				</td>
			</tr>
<%--		</table>--%>
	</div>

	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('phtRegLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>

</body>
</html>
