<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@page import="java.util.ResourceBundle"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<!-- FileUpload javascript libraries ------------------------------------------------------------>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>
<script type="text/javascript" src="/common/plugin/IBLeaders/Org/IBOrgSharp5/lib/jquery.blockUI.js"></script>

<!--  FileUpload css files ------------------------------------------------------------------------->
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />
<style>
</style>

<script type="text/javascript">
	$(function() {

		<c:if test="${fileBtn!='N'}"><c:set var="sDelHdn" value="0" /></c:if>

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [

			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo", Sort:0 },
// 			{Header:"<sht:txt mid='check' mdef='선택'/>",				Type:"CheckBox",	Hidden:Number("${sDelHdn}"),	Width:45,			Align:"Center",	SaveName:"sChk" , Sort:0},
			{Header:"<sht:txt mid='check' mdef='선택'/>",				Type:"CheckBox",	Hidden:0,	Width:45,			Align:"Center",	SaveName:"sChk" , Sort:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	SaveName:"sStatus" ,Sort:0 },
// 			{Header:"<sht:txt mid='enterCd' mdef='회사명'/>",			Type:"Text",		Hidden:1,	Width:10,			Align:"Center",	SaveName:"enterCd", UpdateEdit:0 },
 			{Header:"<sht:txt mid='fileSeqV1' mdef='파일번호'/>",		Type:"Text",		Hidden:1,	Width:20,			Align:"Center",	SaveName:"fileSeq", UpdateEdit:0 },
 			{Header:"<sht:txt mid='seqNo' mdef='파일순번'/>",			Type:"Text",		Hidden:1,	Width:5,			Align:"Center",	SaveName:"seqNo", 	UpdateEdit:0 },
 			{Header:"<sht:txt mid='fileNm' mdef='파일명'/>",			Type:"Text",		Hidden:0,	Width:100,			Align:"Left",	SaveName:"rFileNm", UpdateEdit:0 },
// 			{Header:"<sht:txt mid='sFileNm' mdef='저장파일명'/>",		Type:"Text",		Hidden:1,	Width:10,			Align:"Left",	SaveName:"sFileNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='fileSize' mdef='용량(Byte)'/>",	Type:"Int",			Hidden:0,	Width:30,			Align:"right",	SaveName:"fileSize",UpdateEdit:0 },
			{Header:"<sht:txt mid='chkdate' mdef='등록일'/>",			Type:"Text",		Hidden:0,	Width:50,			Align:"Center",	SaveName:"chkdate", UpdateEdit:0 },
			{Header:"<sht:txt mid='chkId' mdef='등록자'/>",			Type:"Text",		Hidden:1,	Width:20,			Align:"Center",	SaveName:"chkId", 	UpdateEdit:0 },
			{Header:"<sht:txt mid='download' mdef='다운로드'/>",		Type:"Image",		Hidden:0,	Width:30,			Align:"Center",	SaveName:"download",UpdateEdit:0 ,	Cursor:"Pointer", Sort:0}
		]; IBS_InitSheet(supSheet, initdata);supSheet.SetEditableColorDiff (0);
		supSheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		setSheetSize(supSheet);
		//$(window).smartresize(sheetResize);
		sheetInit();
// 		doFileAction("Search");

		$(".close").click(function() {
			p.self.close();
		});
<c:if test="${authPg == 'A'}">
		var options = $.extend(true, ${fConfig}, {
			btn : {
				browse : {
					title : "<tit:txt mid='201705230000019' mdef='파일선택'/>",
					class : "browse-btn"
				}
			},
			context:"${ctx}",
			event:{
				success: function(jsonData) {
					$.unblockUI();
					if(jsonData.data !== undefined && jsonData.data !== null && jsonData.data.length > 0) {
						$("#uploadForm>#fileSeq").val(jsonData.data[0].fileSeq);
						doFileAction("Search");
						try{
							getFileUploadEnd();//업로드후 리턴
						}catch(e){}
					}
				},
				error: function(jsonData) {
					$.unblockUI();
				},beforeSubmit : function(options) {
					$.blockUI({message:"<img src='/common/images/common/InfLoading.gif'/>",css:{border:'0px solid #ffffff'},overlayCSS:{backgroundColor:"#ffffff"}});
					options.el.hide();
					return true;
				}
			},
			localeCd:"${ssnLocaleCd}"
		}),
		params = {
			'uploadType' : $("#uploadType").val(),
			'fileSeq' : getUpLoadFileSeq
		};

		$("#fileuploader").fileupload("init", options, params);

</c:if>
	});
	function upLoadInit(fileSeq,filePath){
		if(fileSeq !=- null && fileSeq !== "") {
			$("#uploadForm>#fileSeq").val(fileSeq);
			doFileAction("Search");
		}else{
			$("#fileuploader").fileupload('setCount', 0);
			supSheet.RemoveAll();
		}
	}


	var getTopWindow = function () {
	    var win = window.top;
	    while (win.parent.opener) {
	        win = win.parent.opener.top;
	    }
	    return win;
	};

	function getUpLoadFileSeq(){
		return $("#uploadForm>#fileSeq").val();
	}

	function doFileAction(sAction) {
		switch (sAction) {
			case "Search":  supSheet.DoSearch( "${ctx}/fileuploadJFileUpload.do?cmd=jFileList", $("#uploadForm").serialize() ); break;
			case "Del":
				var rows = supSheet.FindCheckedRow("sChk");
				if(rows == "" && $("#uploadType").val() != "") {
					if(confirm("전체 삭제를 하시겠습니까?")) {
						$.filedelete($("#uploadType").val(), {"fileSeq" : $("#fileSeq").val()});
					}
				} else {
					var rowarr = rows.split("|");
					var params = [];

					for(var i=0;i<rowarr.length;i++) {
						params[i] = supSheet.GetRowJson(rowarr[i]);
					}

					$.filedelete($("#uploadType").val(), params, function(code, message) {
						if(code == "success") {
							doFileAction("Search");
						} else {
							var msg = (message ? message : "<msg:txt mid='errorDelete2' mdef='삭제에 실패하였습니다.'/>");
							alert(msg);
						}
					});
				}
				break;
			case "download" :
				var rows = supSheet.FindCheckedRow("sChk");
				if(rows==""){
					alert("<msg:txt mid='2017082300224' mdef='선택된 파일이 없습니다.'/>");
					return;
				}
				if(rows == "" && $("#uploadType").val() != "") {
					if(confirm("<msg:txt mid='fullDownload' mdef='전체 다운로드를 하시겠습니까?'/>")) {
						$.filedownload($("#uploadType").val(), {"fileSeq" : $("#fileSeq").val()});
					}
				} else {
					var rowarr = rows.split("|");
					var params = [];
					for(var i=0;i<rowarr.length;i++) {
						params[i] = supSheet.GetRowJson(rowarr[i]);
					}
					$.filedownload($("#uploadType").val(), params);
				}
				break;
		}
	}

	function supSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
			$("#fileuploader").fileupload('setCount', supSheet.RowCount());
		  	if(supSheet.RowCount() == 0) {
		    	//alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
		  	}
		  	supSheet.FocusAfterProcess = false;
			setSheetSize(supSheet);
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

/*
	function supSheet_OnMouseMove(Button, Shift, X, Y) {
		try {
			//마우스 위치가 12컬럼 일때만 마우스 손가락 모양
			var Row = supSheet.MouseRow();
			var Col = supSheet.MouseCol();
			var sText = supSheet.GetCellValue(Row, Col);

			if(supSheet.MouseCol() == 12 && (sText=="/common/images/icon/icon_popup.png")) {
				supSheet.SetMousePointer("Hand");
			}
			else {
				supSheet.SetMousePointer("Default");
			}
		}catch(ex){alert("OnMouseMove Event Error : " + ex);}
	}
*/

	function supSheet_OnClick(Row, Col, Value) {
		try{
			if(Row > 0 && supSheet.ColSaveName(Col) == "download" ){
				$.filedownload($("#uploadType").val(), supSheet.GetRowJson(Row));
			}
			if(Row > 0 && supSheet.ColSaveName(Col) == "sChk" ){
				if(supSheet.GetCellValue(Row, "sStatus")!="I"){
					supSheet.SetCellValue(Row, "sStatus","");
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}

	}

	// 저장 후 메시지
	function supSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doFileAction("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


	function supSheet_OnResize(lWidth, lHeight) {
		try { setSheetSize(supSheet); }catch(ex){alert("OnResize Event Error : " + ex); }
	}
</script>
<div id="fileDiv">
	<form id="uploadForm" name="uploadForm">
		<input id="fileSeq" name="fileSeq" type="hidden" />
		<input id="uploadType" name="uploadType" type="hidden" value="${uploadType}"/>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title" style="overflow: hidden;">
						<ul>
							<li class="txt"><tit:txt mid='uploadFile' mdef='첨부파일'/></li>
							<li class="btn" style="margin: auto;">
								<ul>
									<c:if test="${fileBtn!='N'}">
										<!-- fileBtn 으로 버튼 숨김처리 -->
										<li style="float: left;">
											<div id='fileuploader' class="fileuploader" align='right' style="padding-top: 1px;"></div>
										</li>
									</c:if>
										<li style="float: left;">
										<a id="downloadBtn" href="javascript:doFileAction('download');" class="basic"><tit:txt mid='114165' mdef='선택다운로드'/></a>
									</li>
									<c:if test="${fileBtn!='N'}">
										<li style="float: left;">
											<c:if test="${authPg == 'A'}">
												<btn:a href="javascript:doFileAction('Del');" css="basic" mid='110763' mdef="삭제"/>
											</c:if>
										</li>
									</c:if>
								</ul>
							</li>
						</ul>
					</div>
				</div> <script>createIBSheet("supSheet","100%","${fileSheetHeight}", "${ssnLocaleCd}");</script>
			</td>
		</tr>
	</table>
</div>
