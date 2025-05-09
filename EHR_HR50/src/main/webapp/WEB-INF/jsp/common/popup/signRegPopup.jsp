<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%
String uploadType = "pht002";
request.setAttribute("uploadType", uploadType);
FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='signReg' mdef='서명등록'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<!-- <script src="http://malsup.github.com/jquery.form.js"></script> -->
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		
		$(".close").click(function() { closePop();});

		var arg = p.popDialogArgumentAll();
		if( arg != undefined ) {
			$("#sabun").val(arg["sabun"]);
			$("#txtSabun").text(arg["sabun"]);
			$("#txtName").text(arg["name"]);
		}

		downloadFile((new Date()).getTime());

		var options =$.extend(true, ${fConfig}, {
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
							var rtn = "sabun="+encodeURIComponent($("#sabun").val()) + "&gubun=2";
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
		$("#photo").attr("src", "${ctx}/EmpPhotoOut.do?_t=" + t + "&searchKeyword="+$("#sabun").val() + "&type=2");
	}

	//사인패드 서명 후 리턴 
	function returnSignPad(rs){
		if(rs.FileSeq !== undefined && rs.FileSeq !== null && rs.FileSeq.length > 0) {
			var params = "sabun="+encodeURIComponent($("#sabun").val()) + "&gubun=2&seqNo=0&fileSeq="+rs.FileSeq;
			var result = ajaxCall("/EmployeePhotoSave.do", params, false).result;
			if(result.code == "success") {
				downloadFile((new Date()).getTime());
				alert("저장 되었습니다.");
			} else {
				alert(result.message);
			}
		}else{
			alert("처리 중 오류가 발생했습니다.");
		}
	}

	//서명삭제
	function doDelSign(){
		try{
			if( !confirm("등록된 서명을 삭제 하시겠습니까?") ) return;
			
			var params = "sabun="+encodeURIComponent($("#sabun").val()) + "&gubun=2";
			var result = ajaxCall("/EmployeePhotoDelete.do", params, false).result;
			if(result.code == "success") {
				downloadFile((new Date()).getTime());
				alert("삭제 되었습니다.");
			} else {
				alert(result.message);
			}
		
		}catch(e){
			alert("처리 중 오류가 발생했습니다.");
		}
	}
	//팝업 닫기
	function closePop(){
		try{
			p.popReturnValue([]);
		}catch(e){}
		p.self.close();
		
	}
</script>

<body>
<div class="popup_widget">
	<div class="popup_title">
		<ul>
			<li><tit:txt mid='signReg' mdef='서명등록'/></li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<table border="0" cellpadding="0" cellspacing="0" class="default inner fixed">
			<colgroup>
				<col width="150px" />
				<col width="20%" />
				<col width="%" />
			</colgroup>
			<tr>
				<td rowspan="3" class="photo" align="center">
					<img src="/common/images/common/img_photo.gif" id="photo" width="100" height="100" onerror="javascript:this.src='/common/images/common/img_photo.gif'">
				</td>
				<th><tit:txt mid='103975' mdef='사번'/></th>
				<td><span id="txtSabun"></span></td>
			</tr>
			<tr>
				<th><tit:txt mid='103880' mdef='성명'/></th>
				<td><span id="txtName"></span></td>
			</tr>
			<tr>
				<td colspan="2" align="right"><a href="javascript:doDelSign();" class="button">서명삭제</a></td>
			</tr>
		</table>
		
		<div class="h10"></div>
		<table class="default inner">
			<colgroup>
				<col width="100%" />
			</colgroup>
			<tr>
				<td>
					<div class="sheet_title" style="overflow: hidden;">
						<ul>
							<li class="txt">1. 파일 첨부<span id="r_nm"></span></li>
							<li class="btn" style="margin: auto;">
								<ul>
									<li style="float: left;">
										<div id='fileuploader' class="fileuploader" align='right' style="padding-top: 5px;"></div>
										<input type="hidden" id="sabun" name="sabun" />
									</li>
								</ul>
							</li>
						</ul>
					</div>
				</td>
			</tr>
		</table>
		
		<div class="h10"></div>
		<table class="default inner">
			<colgroup>
				<col width="100%" />
			</colgroup>
			<tr>
				<td>
					<div class="sheet_title" style="height:100%; overflow: hidden; text-align:center;">
						<ul>
							<li class="txt">2. 직접서명</li>
						</ul>
						<iframe id="ifrm1" name="ifrm1" src="/Popup.do?cmd=signPadPopup" style="border:0px; width:332px; height:220px; margin-left:10px"></iframe>
					</div>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:closePop();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>