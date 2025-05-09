<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	var contents = "";
	var contentsEng = "";
	var fileSeq = "";

	var arg = p.window.dialogArguments;

	$(function() {
		$(".close").click(function() {
			p.self.close();
		});

	    if( arg != undefined ) {
	    	contents 	= arg["etcNote"];
	    	contentsEng	= arg["etcNoteEng"];
	    	fileSeq 	= arg["fileSeq"];
	    }else{
	    	if(p.popDialogArgument("etcNote")!=null)		contents  	= p.popDialogArgument("etcNote");
	    	if(p.popDialogArgument("etcNoteEng")!=null)		contentsEng	= p.popDialogArgument("etcNoteEng");
	    	if(p.popDialogArgument("fileSeq")!=null)		fileSeq  	= p.popDialogArgument("fileSeq");
	    }

	    $("#fileSeq").val(fileSeq);
		$("#contents").val(contents);
		$("#contentsEng").val(contentsEng);
		$("#contents").maxbyte(4000);
		$("#contentsEng").maxbyte(4000);

	});

	function setValue(){
   		var rv = new Array(1);
   		rv["contents"] = $("#contents").val();
   		rv["contentsEng"] = $("#contentsEng").val();
   		rv["fileSeq"] = $("#fileSeq").val();

   		p.popReturnValue(rv);
   		p.window.close();
	}

	function filePopup() {
		if(!isPopup()) {return;}

		var param = [];
		param["fileSeq"] = $("#fileSeq").val();
		openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg=A", param, "740","620", function(rv) {
			$("#fileSeq").val(rv["fileSeq"]);
		});
	}


</script>

</head>
<body>
	<div class="wrapper popup_scroll">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='appEtcNotePop' mdef='유의사항 등록'/></li>
				<li class="close"></li>
			</ul>
		</div>
	       <div class="popup_main">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="sheet_title">
							<ul>
								<%-- <li id="txt" class="txt"><tit:txt mid='112983' mdef='한글'/></li> --%>
								<li id="txt" class="txt"><tit:txt mid='psnlWorkScheduleMgr2' mdef='유의사항'/></li>
								<li class="btn">
									<input type="hidden" id="fileSeq" name="fileSeq"/>
									<btn:a href="javascript:filePopup();" css="basic authA" mid='btnFileV1' mdef="파일첨부"/>
								</li>
							</ul>
						</div>
					</td>
				</tr>
			</table>
			<table class="table">
				<tbody>
					<tr>
						<td>
							<textarea id="contents" name="contents" class="text required w100p" rows="30"></textarea>
						</td>
					</tr>
				</tbody>
			</table>
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main hide">
				<tr>
					<td>
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"><tit:txt mid='113341' mdef='영문'/></li>
							</ul>
						</div>
					</td>
				</tr>
			</table>
			<table class="table hide">
				<tbody>
					<tr>
						<td>
							<textarea id="contentsEng" name="contentsEng" class="text required w100p" rows="10"></textarea>
						</td>
					</tr>
				</tbody>
			</table>


			<div class="popup_button outer">
			<ul>
				<li>
					<btn:a href="javascript:setValue();" css="pink large" mid='110716' mdef="확인"/>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
			</div>
		</div>
	</div>
</body>
</html>
