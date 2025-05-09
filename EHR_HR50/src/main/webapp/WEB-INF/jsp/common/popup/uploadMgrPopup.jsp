<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/common/plugin/IBLeaders/Upload/js/sheetuploadpackage.js"></script>
<script src="/common/plugin/IBLeaders/Upload/js/createIBUpload.js"></script>
<script src="/common/plugin/IBLeaders/Upload/js/IBUploadInfo.js"></script>
<script type="text/javascript">
	alert("<msg:txt mid='110128' mdef='사용하지 안습니다.'/>");
	var srchBizCd = null;
	var supUpload = null;
	var useProgressBar = true;
	var uploadProgramPath = "";
	var filePath = "";
	var fileSeq = "";
	var upType = 2;
	var uploadReady = 0;
	
	/**/
	var GW_DATA = "" ;
	var GW_ID = "" ;
	var GW_PASSWORD = "" ;
	var GW_URL = "" ;
	var GW_INFORM_YN = "N" ;
	var GW_FORM_KEY = "" ;
	/**/
	
	$(function() {
		//업로드타입[이미지 1개만 선택할경우 1]
		$("#upType").val(upType);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"CheckBox",	Hidden:Number("${sDelHdn}"),	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"sChk" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",			Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='enterCd' mdef='회사명'/>",			Type:"Text",		Hidden:1,	Width:10,			Align:"Center",	ColMerge:0,	SaveName:"enterCd", UpdateEdit:0 },
// 			{Header:"<sht:txt mid='fileGubn' mdef='업무명'/>",			Type:"Text",		Hidden:0,	Width:20,			Align:"Center",	ColMerge:0,	SaveName:"fileGubn", UpdateEdit:0 },
 			{Header:"<sht:txt mid='fileSeqV1' mdef='파일번호'/>",		Type:"Text",		Hidden:1,	Width:20,			Align:"Center",	ColMerge:0,	SaveName:"fileSeq", UpdateEdit:0 },
 			{Header:"<sht:txt mid='seqNo' mdef='파일순번'/>",		Type:"Text",		Hidden:1,	Width:5,			Align:"Center",	ColMerge:0,	SaveName:"seqNo", UpdateEdit:0 },
 			{Header:"<sht:txt mid='fileNm' mdef='파일명'/>",			Type:"Text",		Hidden:0,	Width:40,			Align:"Left",	ColMerge:0,	SaveName:"rFileNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='sFileNm' mdef='저장파일명'/>",		Type:"Text",		Hidden:1,	Width:40,			Align:"Left",	ColMerge:0,	SaveName:"sFileNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='filePath' mdef='경로'/>",			Type:"Text",		Hidden:1,	Width:60,			Align:"Left",	ColMerge:0,	SaveName:"filePath", UpdateEdit:0 },
			{Header:"<sht:txt mid='fileSize' mdef='용량(Byte)'/>",	Type:"Int",			Hidden:0,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"fileSize", UpdateEdit:0 },
			{Header:"<sht:txt mid='chkdate' mdef='등록일'/>",			Type:"Text",		Hidden:1,	Width:20,			Align:"Center",	ColMerge:0,	SaveName:"chkdate", UpdateEdit:0 },
			{Header:"<sht:txt mid='chkId' mdef='등록자'/>",			Type:"Text",		Hidden:1,	Width:20,			Align:"Center",	ColMerge:0,	SaveName:"chkId", UpdateEdit:0 },
			{Header:"<sht:txt mid='download' mdef='다운로드'/>",		Type:"Image",		Hidden:0,	Width:20,			Align:"Center",	ColMerge:0,	SaveName:"download", UpdateEdit:0 }
		]; IBS_InitSheet(supSheet, initdata);supSheet.SetEditableColorDiff (0);
		supSheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
		
		
		$(".close").click(function() {
	    	p.self.close();
	    });
		
		if($("#uploadBtn").is(':visible')){
			createIBUpload("mainUpload", "73px", "23px");
		}

	});
	function upLoadInit(fileSeq,filePath){
		if( fileSeq == "" || fileSeq == null ){
			$("#uploadForm>#fileSeq").val(setSeq(fileSeq));
		}else{
			$("#uploadForm>#fileSeq").val(fileSeq);
		}
	
		$("#uploadForm>#work").val(filePath);
		uploadProgramPath = "${ctx}/Upload.do?cmd=uploadAction&fileSeq="+$("#uploadForm>#fileSeq").val()+"&work="+filePath+"&";

		doAction("Search");
	}
	function getUpLoadFileSeq(){
		return $("#uploadForm>#fileSeq").val();
	}
	function doAction(sAction) {
		switch (sAction) {
			case "Search":  supSheet.DoSearch( "${ctx}/Upload.do?cmd=getFileList", $("#uploadForm").serialize() ); break;
		}
    } 
	function supSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
		  	if(supSheet.RowCount() == 0) {
		    	//alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
		  	}
		  	supSheet.FocusAfterProcess = false;
			setSheetSize(supSheet);
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	
	//흠..
	
	function supSheet_OnMouseMove(Button, Shift, X, Y) {
		try {
			var Row = supSheet.MouseRow();
			var Col = supSheet.MouseCol();
			
			if(supSheet.GetCellValue(Row, "download") != ""){
				supSheet.SetDataLinkMouse("download", 1);
			}else{
				supSheet.SetDataLinkMouse("download", 0);
			}
			
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	

	function supSheet_OnClick(Row, Col, Value) {
		try{
			
			if(Row > 0 && supSheet.ColSaveName(Col) == "download" ){
				IBU_DOWNLOAD(Row); //원래소스
			}
			
		}catch(ex){alert("OnClick Event Error : " + ex);}
		
	}

	function supSheet_OnResize(lWidth, lHeight) {
		try { setSheetSize(supSheet); }catch(ex){alert("OnResize Event Error : " + ex); }
	}
	function returnFindUserf(Row,Col){
	}
	
	//IBUpload 초기화 이벤트
	function mainUpload_OnLoad(obj){
try{
		supUpload = obj;
// 		upload_init();
		var intv = window.setInterval(function(){
			if(uploadProgramPath!=""){
				upload_init();
				clearInterval(intv);
			}
		},500);
}catch(e){
	alert(e.message);
}	
	}
	
	function upload_init(){
		//IBUpload 초기화
		init_supUpload();
		supUpload.TotalMaxFileCount= 20;
		supUpload.UploadType = upType; //버튼만 보이기.
	}
	
	function saveFile(){
		//$("#fileSeq").val(fileSeq);
		IBU_SAVE();
			return;
		//init_supUpload();
		//supUpload.ClearList();
	}
	
	/*
	 * 모든 파일이 전송되고 난 이후 발생하는 이벤트
	 * desc: 전송 후 돌려받은 데이터 중 저장된 내용을 시트에 반영한다. 
	 */
// 	function mainUpload_OnUploadFinish() {
// 		try{
// 			doAction("Search");
// 		}catch(e){
// 			alert(e.message);
// 		}
// 	}
	function setSeq(seq){
		var seqNum = ajaxCall("/Sequence.do?seqId=FILE","",false);
		return seqNum.map.seqNum;
	}
	
</script>

<div id="fileDiv"class="wrapper">
	<form id="uploadForm" name="uploadForm" >
		<input id="fileSeq" name="fileSeq" 	type="hidden" />
		<input id="upType"  name="upType"  	type="hidden" />
		<input id="work" 	name="work"     type="hidden" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='uploadFile' mdef='첨부파일'/></li>
					<li class="btn">
						<table cellpadding="0" cellspacing="0" style="overflow:hidden;">
							<tr>
							<td id=uploadMgr style="padding-right:3px"></td>
							
								<script>createIBUpload("mainUpload", "73px", "23px");</script>
							</td>
							<td>
							<a id="uploadBtn" href="javascript:saveFile();" class="basic"><tit:txt mid='104242' mdef='업로드'/></a>
							<!-- 
							<a href="javascript:IBU_DOWNLOAD();" class="basic"><tit:txt mid='download' mdef='다운로드'/></a>
							 -->
							<a id="deleteBtn" href="javascript:IBU_DELETE();" class="basic"><tit:txt mid='113460' mdef='삭제'/></a>
							</td>
							</tr>
						</table>
					</li>
				</ul>
				</div>
			</div>
			<script>createIBSheet("supSheet","100px%","100px");</script>
		</td>
	</tr>
	</table>
</div>

