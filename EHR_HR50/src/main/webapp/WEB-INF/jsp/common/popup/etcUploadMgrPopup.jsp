<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script src="/common/plugin/IBLeaders/Upload/js/sheetuploadpackage.js"></script>
<script src="/common/plugin/IBLeaders/Upload/js/createIBUpload.js"></script>
<script src="/common/plugin/IBLeaders/Upload/js/IBUploadInfo.js"></script>
<script type="text/javascript">
alert("<msg:txt mid='109824' mdef='공통 사용안함으로 용도확인필요.'/>");
var supUpload = null;
var uploadProgramPath2 = "";
var fileS = "";
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
		]; IBS_InitSheet(supSheet2, initdata);supSheet2.SetEditableColorDiff (0);supSheet2.SetVisible(true);
		

		
		supSheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		$(window).smartresize(sheetResize); sheetInit();
		doAction2("Search");


		$(".close").click(function() {
	    	p.self.close();
	    });

	});
	function upLoadInit2(fileSeq,filePath){
		if( fileSeq == "" || fileSeq == null ){
		}else{
			//$("#uploadForm2>#fileSeq2").val(fileSeq);
			fileS = fileSeq;
		}
		uploadProgramPath2 = "${ctx}/Upload.do?cmd=uploadAction&fileSeq="+fileS+"&work="+filePath+"&";
		doAction2("Search");
	}
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":  supSheet2.DoSearch( "${ctx}/Upload.do?cmd=getFileList", "fileSeq="+fileS ); break;
		}
    }
	function supSheet2_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
		  	if(supSheet2.RowCount() == 0) {
		    	//alert("<msg:txt mid='alertAuthEmp1' mdef='대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.'/>");
		  	}
		  	supSheet2.FocusAfterProcess = false;
			setSheetSize(supSheet2);
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	

	//흠..

	function supSheet2_OnMouseMove(Button, Shift, X, Y) {
		try {
			var Row = supSheet2.MouseRow();
			var Col = supSheet2.MouseCol();

			if(supSheet2.GetCellValue(Row, "download") != ""){
				supSheet2.SetDataLinkMouse("download", 1);
			}else{
				supSheet2.SetDataLinkMouse("download", 0);
			}

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}


	function supSheet2_OnClick(Row, Col, Value) {
		try{

			if(Row > 0 && supSheet2.ColSaveName(Col) == "download" ){
/* 				// 제주항공 전용 인터페이스 모듈 사용, 제주항공이 아닌경우 삭제해야 하는 코드 Start by JSG
				if("${uiInfo.applCd}" == "22" || "${uiInfo.applCd}" == "29") {
					//그룹웨어 인증
					loginFile() ;
					window.open( supSheet2.GetCellValue(Row, "filePath") ) ;
				}
				// 제주항공 전용 인터페이스 모듈 사용, 제주항공이 아닌경우 삭제해야 하는 코드 End by JSG
				else {
					IBU_DOWNLOAD(Row); //원래소스
				}
 */
                IBU_DOWNLOAD2(Row); //원래소스
			}

		}catch(ex){alert("OnClick Event Error : " + ex);}

	}

	function supSheet2_OnResize(lWidth, lHeight) {
		try { setSheetSize(supSheet2); }catch(ex){alert("OnResize Event Error : " + ex); }
	}


</script>

<div id="fileDiv">
	  
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='fileSeq2' mdef='유의사항첨부파일'/></li>
					<li class="btn">
						<table cellpadding="0" cellspacing="0" style="overflow:hidden;">
							<tr>
							<%-- 
							<td style="padding-right:3px">
								<script>createIBUpload("mainUpload", "73px", "23px");</script>
							</td>
							--%>
							<td>
							<!--
							<a href="javascript:IBU_DOWNLOAD();" class="basic"><tit:txt mid='download' mdef='다운로드'/></a>
							 -->
							</td>
							</tr>
						</table>
					</li>
				</ul>
				</div>
			</div>
			<script>createIBSheet("supSheet2","100px%","100px");</script>
		</td>
	</tr>
	</table>
</div>
