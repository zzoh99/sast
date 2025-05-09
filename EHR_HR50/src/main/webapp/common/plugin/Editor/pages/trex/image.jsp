<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title> 이미지 첨부</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<script src="/common/plugin/Editor/js/popup.js" type="text/javascript" charset="utf-8"></script>
<link rel="stylesheet" href="/common/plugin/Editor/css/popup.css" type="text/css"  charset="utf-8"/>
<script type="text/javascript">
// <![CDATA[

	var seq     = "";
	var bizPath = "";
	$(function() {
		var options = "";
		try{
			seq     = parent.opener.$("#searchRecSeq").val();
			bizPath = parent.opener.$("#searchBizPath").val();
		} catch(e){}

		if (bizPath == "recfile"){  // 채용공고등록
			options = "<option value='recfile'>채용</option>";
		} else {
			options = "<option value='hrfile'>기타</option>";
		}

		$("#param5").html(options);

        $(".close").click(function() {
	    	self.close();
	    });
	});

	// 파일업로드 이벤트
	function filedone(){

		//폼전송
		var frm;
		frm = $("#imgForm");
		frm.attr("enctype", "multipart/form-data");
		frm.attr("action" , "fileUpload.jsp?p="+$("#param5").val()+"&seq="+seq);
		frm.attr("method" , "post");
		frm.attr("target" , "_self");
		frm.submit();
	}

// ]]>
</script>
</head>
<body>

<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>이미지 첨부</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">

		<div class="explain">
			<div class="title">gif, png, jpeg, bmp, tif 파일만 업로드 가능</div>
			<div class="txt">
				<form id="imgForm" name=imgForm">
				<table border="0">
				    <col width="60" />
				    <col width="60" />
				    <col width="60" />
				    <col width="" />

				    <tr><td>경로 </td><td colspan=3><input type="file" name="filename" size=30 accept=".png, .jpg, .jpeg .bmp .tif" /></td></tr>

				    <tr><td colspan=4><br>너비값과 높이값이 없을경우 자동설정 됩니다.</td>
				    <tr><td>너비 </td><td colspan=3><input type="text" id="param1" name="param1" size="5" /></td></tr>
				    <tr><td>높이 </td><td colspan=3><input type="text" id="param2" name="param2" size="5" /></td></tr>
				    <tr><td>설명 </td><td colspan=3><input type="text" id="param3" name="param3" size=40  /></td></tr>
				    <tr><td>정렬 </td>
				    	<td colspan=3>
						    <select id="param4" name="param4">
				                <option selected="selected" value="C">가운데 정렬</option>
				                <option value="L">좌측 정렬</option>
				                <option value="FL">우측 정렬</option>
				                <option value="FR">양쪽 정렬</option>
				            </select>
				        </td>
				    </tr>
				    <tr><td>업무</td>
				    	<td colspan=3>
						    <select id="param5" name="param5">
				                <option selected="selected" value="hrfile">기타</option>
				                <option value="recfile">채용</option>
				            </select>
				        </td>
				    </tr>
				</table>
				</form>
			</div>
		</div>

		<div class="popup_button">
		<ul>
			<li>
				<a href="javascript:filedone();" class="pink large">등록</a>
				<a href="javascript:self.close();" class="gray large">닫기</a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>

