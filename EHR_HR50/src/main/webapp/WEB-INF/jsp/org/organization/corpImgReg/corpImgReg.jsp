<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%
String uploadType = "company";
request.setAttribute("uploadType", uploadType);
FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112197' mdef='법인이미지관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%--
<script src="http://malsup.github.com/jquery.form.js"></script>
--%>
<!-- <script src="/common/js/jquery/jquery.form-3.51.0.js" type="text/javascript" charset="utf-8"></script> -->
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>

<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />

<script type="text/javascript">
	$(function() {

		//이미지 리스트
		var userCd2 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W10070"), "");
		$("#corpImgCd").html(userCd2[2]);

		//부서코드리스트
		var orgCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getHdCntrCdList",false).codeList, "");
		$("#orgCdTemp").html(orgCdList[2]);

		downloadFile();

		var options = $.extend(true, ${fConfig}, {
			context:"${ctx}",
			event:{
				beforeSubmit: function() {
					var corpImgCd = $("#corpImgCd").val();

					if(corpImgCd == 3){
						$("#orgCd").val($("#orgCdTemp").val());
					}else{
						$("#orgCd").val("0");
					}

					if(corpImgCd == ""){
						alert("<msg:txt mid='alertCorpImgType' mdef='법인이미지 구분을 선택하셔야 합니다.'/>");
						return false;
					}else{
						return true;
					}
				},
				success: function(jsonData) {
					if(jsonData.data !== undefined && jsonData.data !== null && jsonData.data.length > 0) {
						var params = function(p) {
							var rtn = "orgCd="+encodeURIComponent($("#orgCd").val()) + "&logoCd=" + encodeURIComponent($("#logoCd").val());
							$.each(p, function(key, value) {
								rtn += "&" + key + "=" + encodeURIComponent(value);
							});

							return rtn
						}(jsonData.data[0]);

						var result = ajaxCall("/CompanyPhotoSave.do", params, false).result;
						if(result.code == "success") {
							downloadFile();
						} else {
							alert(result.message);
						}
					}
					$("#fileuploader").fileupload("setCount",0);
				},
				error: function(jsonData) {
					alert(jsonData.msg);
				}
			}
		}),
		params = {
				'uploadType' :"${uploadType}",
				//'fileSeq' : '',
				'sabun' : $("#sabun").val()
			};

		$("#fileuploader").fileupload("init", options, params);
	});

	function remove(){
		$("#photo").attr("src","/common/images/common/img_photo.gif");
	}

	function checkExt()
	{
// 	    var IMG_FORMAT = "\.(jpg)$";
// 	    if((new RegExp(IMG_FORMAT, "i")).test($("#uploadFile").val())) return true;

// 	    alert("<msg:txt mid='109332' mdef='jpg 파일만 첨부하실 수 있습니다.'/>");

	    return true;
	}

	function downloadFile(){
		var corpImgCd = $("#corpImgCd").val();

		if(corpImgCd != ""){
			var orgCd = "0";
			if(corpImgCd == 3){
				orgCd = $("#orgCdTemp").val();
			}

			var corpImgCd = $("#corpImgCd").val();
			$("#logoCd").val(corpImgCd);


			$("#photo").attr("src", "${ctx}/OrgPhotoOut.do?logoCd="+$("#logoCd").val()+"&orgCd="+orgCd+"&t=" + (new Date()).getTime() );
		}else{

			alert("<msg:txt mid='alertCorpImgType' mdef='법인이미지 구분을 선택하셔야 합니다.'/>");
		}


	}

	// code 수정
	function codeChg() {
		var corpImgCd = $("#corpImgCd").val();

		$("#logoCd").val(corpImgCd);
		//
		if(corpImgCd == 3){
			$(".orgTr").show();
		}else{
			$(".orgTr").hide();
		}

		downloadFile();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="mySheetForm" name="mySheetForm" >

		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='112529' mdef='법인이미지'/></th>
				<td>
					<select id="corpImgCd" name="corpImgCd" onchange="codeChg();"></select>
				</td>
				<th style="display:none" class="orgTr"><tit:txt mid='113441' mdef='부서'/></th>
				<td style="display:none" class="orgTr">
					<select id="orgCdTemp" name="orgCdTemp" onchange="javaScript:downloadFile();"></select>
				</td>
				<td>
					<btn:a href="javascript:downloadFile();" css="btn dark" mid='110697' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='corpImgReg' mdef='법인로고등록'/></li>

		</ul>
		</div>
			<table border="0" cellpadding="0" cellspacing="0" class="default inner fixed">
				<tr height="150">
					<td align=center width="100px">
						<table>
							<tr>
								<td><img src="/common/images/common/img_photo.gif" id="photo" width="130" height="101" onerror="javascript:this.src='/common/images/common/img_photo.gif'"></td>
							</tr>
						</table>
					</td>
					<td class="h40" style="width:610px;">
					<br/>
						<ul>
							<li class="btn">
								<input type="hidden" id="logoCd" name="logoCd"/>
								<input type="hidden" name="utype" id="utype" value="company" />
								<input type="hidden" name="orgCd" id="orgCd" value="0" />
								<div id='fileuploader' class="fileuploader" align='right' style="padding-top: 5px;"></div>
<!-- 									<a class="basic" onclick="uploadImg();"><tit:txt mid='104242' mdef='업로드'/></a> -->
							</li>
						</ul>
														<br>
							<tit:txt mid='201705020000183' mdef='- 파일명 : JPG, JPEG, GIF, PNG 파일만 가능합니다.'/><br>
							&nbsp;&nbsp;&nbsp;<tit:txt mid='113508' mdef='예'/> logo.gif, logo.jpg, logo1.png<br><br>
							<tit:txt mid='201705020000184' mdef='- 시스템로고 이미지는 가로 세로 비율이 5:1에 최적화 되어 있습니다.'/><br>
							&nbsp;&nbsp;&nbsp;(<tit:txt mid='113508' mdef='예'/>150px X 30px)<br>
					</td>
					</tr>
			</table>
		</div>
	</div>



</body>
</html>
