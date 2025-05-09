
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113080' mdef='작업중 .. '/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script>
var p = eval("${popUpStatus}");

//최대 업로드 파일 갯수
var fileMaxCnt = "";
var initRowCnt ;
var fileSeq = "";
//종류가 많아지면 상수화 필요성 있어보임.
var msgDiv = 999;

$(function() {

	var arrParam = p.window.dialogArguments;

	if( arrParam != undefined ){
		fileSeq    = arrParam['fileSeq'];
		fileMaxCnt = arrParam['fileMaxCnt'];
	}else {
// 		if(p.window.arrParam)		fileSeq = p.window.fileSeq.value;
// 		if(p.window.fileMaxCnt)		fileMaxCnt = p.window.fileMaxCnt.value;

		if( p.popDialogArgument("fileSeq") 		!= null ) { fileSeq 	= p.popDialogArgument("fileSeq"); }
		if( p.popDialogArgument("msgDiv") 		!= null ) { msgDiv	 	= p.popDialogArgument("msgDiv"); }	// alert 알림 무시 여부 설정
		if( p.popDialogArgument("fileMaxCnt") 	!= null ) { fileMaxCnt 	= p.popDialogArgument("fileMaxCnt"); }
	}

// 	if(arrParam['fileMaxCnt'] != undefined){
// 		fileMaxCnt = arrParam['fileMaxCnt'];
// 	}else{
// 		if(p.window.fileMaxCnt)		fileMaxCnt = p.window.fileMaxCnt.value;
// 	}

	/*
	var initList   = ajaxCall("${ctx}/fileuploadJFileUpload.do?cmd=jFileList", "fileSeq="+fileSeq,false);
	initRowCnt = initList.data.length;
	*/
	upLoadInit(fileSeq,"");

	var tempAuthPg = "${authPg}";

	if(tempAuthPg == 'R'){
		$("a#uploadBtn").hide();
		$("a#deleteBtn").hide();
		$("div#DIV_mainUpload").hide();
	}

});

function comfirmFileUploadPop(flag){

	var fileCheck  = "non";
	var fileCnt    = 0;

/**	
	for(var i=1; i <= supSheet.LastRow(); i++){
		if(supSheet.GetCellValue(i,"seqNo") != "" ){
			fileCheck = "exist";
			fileCnt  += 1;
		}
	}

	if( supSheet.RowCount("I") > 0 || supSheet.RowCount("U") > 0 || supSheet.RowCount("D") > 0){
		if (flag == "close"){
			if (confirm("업로드 안한 파일이 있습니다. 작업을 계속 하시겠습니까?")){
				return;
			} else {
				p.self.close();
			}

		} else {
			return alert("<msg:txt mid='alertfileUpload1' mdef='선택한 파일을 업로드 하여야 합니다.'/>");
		}
	}

	if(fileMaxCnt !=""){
		if(Number(supSheet.RowCount()) != Number(fileMaxCnt)){
			if (flag == "close"){
				if (confirm("업로드 안한 파일이 있습니다. 작업을 계속 하시겠습니까?")){
					return;
				} else {
					p.self.close();
				}

			} else {
				return alert("<msg:txt mid='alertfileUpload2' mdef='해당 항목은 파일업로드가 필수 입니다.'/>");
			}
		}
	}
*/

	// 파일업로드 관련 변동 사항이 있는지 체크해서 메시지 뿌릴것... 2014.12.29
	//if (initRowCnt != supSheet.RowCount()){
		
	var attFileCnt = $('#myUpload').IBUpload('fileList');

	if(attFileCnt.length > 0){
		fileCheck = "exist";
	}
	
	if(fileMaxCnt !=""){
		if(Number(attFileCnt.length) != Number(fileMaxCnt)){
			if (flag == "close"){
					p.self.close();
			} else {
				return alert("<msg:txt mid='alertfileUpload2' mdef='해당 항목은 파일업로드가 필수 입니다.'/>");
			}
		}
	}
	
	var rv = new Array(2);
	rv["fileSeq"] 		= $("#uploadForm>#fileSeq").val();
	rv["fileCheck"]     = fileCheck;

	if(p.popReturnValue) p.popReturnValue(rv);
// 	p.window.returnValue 	= rv;
	p.window.close();
}


</script>

</head>
<body class="bodywrap">
<c:set var="fileSheetHeight"  value="100%" />
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='fileMgrPop' mdef='파일업로드'/></li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">

		<%//@include file="/WEB-INF/jsp/common/popup/uploadMgrPopup.jsp"%>
		<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>

		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a href="javascript:comfirmFileUploadPop('confirm');" css="pink large" mid='110716' mdef="확인"/>
				<btn:a href="javascript:comfirmFileUploadPop('close');"   css="gray large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>
