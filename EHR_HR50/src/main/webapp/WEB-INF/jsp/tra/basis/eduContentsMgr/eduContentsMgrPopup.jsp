<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@page import="java.util.ResourceBundle"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head><title>교육영상 팝업</title>
<%@ include file="/WEB-INF/jsp/tra/basis/eduContentsMgr/metaYt.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%
String uploadType = "edu001";

FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>
<%--<script src="http://www.youtube.com/iframe_api"></script>--%>
<!-- FileUpload javascript libraries ------------------------------------------------------------>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>
<script type="text/javascript" src="/common/plugin/IBLeaders/Org/IBOrgSharp5/lib/jquery.blockUI.js"></script>

<!--  FileUpload css files ------------------------------------------------------------------------->
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />


<style type="text/css">
#eduUrl {

    width:100%;
	
	border-radius:10px; 
    background-color: #70c8d3;

    border: none;

    color:#fff;

    padding: 15px 0;

    text-align: center;

    text-decoration: none;

    display: inline-block;

    font-size: 15px;

    margin: 4px;

    cursor: pointer;

}

</style>

<script type="text/javascript">
var p = eval("${popUpStatus}");
var fileHtml = "";
function openEduLink(){
	window.open($("#eduLink2").val(), '_blank'); 
}
$(function(){
   
	//Cancel 버튼 처리
   $(".close").click(function(){
      p.self.close();
   });

   sheetInit();
   var arg = p.popDialogArgumentAll();
   var fileSeq			= arg["fileSeq"];
//    var eduType			= arg["fileType"];
   var urlLink			= arg["urlLink"];
   var eduLink			= arg["eduLink"];
   var note				= arg["note"];
   var noteText = note.replace(/<br>/gi, "\r\n");

   
   $("#fileSeq").val(fileSeq);
//    $("#fileType").val(eduType);
   $("#urlLink").val(urlLink);
   $("#note").val(noteText);
   $("#eduLink2").val(eduLink);
   
   
   var data = ajaxCall( "${ctx}/EduContentsMgr.do?cmd=getEduContentFileName", $("#uploadForm").serialize(),false);
	if ( data != null && data.DATA != null ){ 
		
		var fileExtension = ['jpg','jpeg','png','gif','bmp','JPG','JPEG','PNG','GIF','BMP'];
		for(var i=0; i < data.DATA.length; i++) {
			if(fileExtension.includes(data.DATA[i].extension)){
				fileHtml +=	"<div>"
				fileHtml += 	"<img style='max-width:600px; height:auto;' src='${ctx}/hrfile/BT/eduContents/"+	
			                      data.DATA[i].fileSeq+"_"+data.DATA[i].rFileNm +"'/>";
				fileHtml +=	"</div>"
			}
				  
		}	
		$("#imgHtml").append(fileHtml);
		
	}

	   if(eduLink == "" || eduLink == null){

	   }else{
		   $("#eduLink").append(
				   '<a href="javascript:openEduLink();" id ="eduUrl">법정이수교육 홈페이지</a>'
// 				   '<btn:a href="javascript:openEduLink();" css="pink large" mid="save" mdef="교육사이트로 이동"/>'
			);   
	   }
//    if(eduType == "유튜브" || eduType == '2'){//교육타입이 유튜브일때
	   if(urlLink == "" || urlLink == null){
		   alert("등록된 동영상 주소가 없습니다.");
	   }else{
   			//youtube동영상 ID를 구하는 정규식
			var regExp = /^.*((youtu.be\/)|(v\/)|(\/u\/\w\/)|(embed\/)|(watch\?))\??v?=?([^#\&\?]*).*/;
			var match = urlLink.match(regExp);
		   
			$("#vRst").append(
				'<iframe width="600" height="300" src="https://www.youtube.com/embed/'+match[7]+'" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>'
			);
			
// 			
	   }
//    	}
//    else{//동영상 첨부일때
//    		var fileType = "";
//    		var rstFileType	= "";
//    		var rstFileNm = "";
//    		var fileNm = ""
//    		var fileNm2 = ""
//    		var vRst = ajaxCall("${ctx}/EduContentsMgr.do?cmd=getVedioContentsMgr",$("#uploadForm").serialize(),false);
// 		var filePath    = vRst.DATA[0].filePath;
// 		var fileSeq		= vRst.DATA[0].fileSeq;
		
		
// 		if(vRst.DATA[0] !== undefined){
// 			if(vRst.DATA[0].sFileNm != "" || vRst.DATA[0].sFileNm != null){
// 				fileNm		= vRst.DATA[0].sFileNm;	//첫번째 파일
// 			}
// 		}
// 		if(vRst.DATA[1] !== undefined){
// 			if(vRst.DATA[1].sFileNm != "" || vRst.DATA[1].sFileNm != null){
// 				fileNm2		= vRst.DATA[1].sFileNm; //두번째 파일
// 			}
// 		}
// 		fileType = fileNm.split('.');
// 		if(fileType[1] != 'asf' || fileType[1] != 'mpeg' || fileType[1] != 'ogg' || fileType[1] != 'rm' || fileType[1] != 'mkv' 
// 			|| fileType[1] != 'avi' || fileType[1] != 'mp4' || fileType[1] != 'mpg' || fileType[1] != 'flv' || fileType[1] != 'wmv' || fileType[1] != 'asf' 
// 			|| fileType[1] != 'asx' || fileType[1] != 'ogm' || fileType[1] != 'ogv' || fileType[1] != 'mov' || fileType[1] != 'webm'){
// 			fileType = fileNm2.split('.');
// 			rstFileType = fileType[1];
// 			rstFileNm 	= fileNm2;
// 		}else{	//동영상 파일인경우
// 			rstFileType = fileType[1];
// 			rstFileNm 	= fileNm;
// 		}
   	   
//    		$("#vRst").append(		//크롬브라우저에서는 mute 기능을 넣어야 autoplay 가능
// 	         '<video id="videoArea" width="600px" height="300px" loop="loop" autoplay="autoplay" controls onended="endVideo()">'+
// 	             '<source src="/hrfile/BT/eduContents/'+rstFileNm+'" type="video/'+rstFileType+'">'+
// 	         '</video>'
// 	   );
   		
// // 		document.getElementById("videoArea").play();
//    	}
});




$(function() {

   var initdata1 = {};
   initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0};
   initdata1.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
   initdata1.Cols = [

      {Header:"No",         Type:"${sNoTy}",   Hidden:0,   Width:"${sNoWdt}",   Align:"Center",   SaveName:"sNo", Sort:0 },
//         {Header:"선택",         Type:"CheckBox",   Hidden:Number("${sDelHdn}"),   Width:45,         Align:"Center",   SaveName:"sChk" , Sort:0},
      {Header:"선택",         Type:"CheckBox",   Hidden:0,   Width:45,         Align:"Center",   SaveName:"sChk" , Sort:0},
      {Header:"상태",         Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),   Width:"${sSttWdt}",   Align:"Center",   SaveName:"sStatus" ,Sort:0 },
//         {Header:"회사명",         Type:"Text",      Hidden:1,   Width:10,         Align:"Center",   SaveName:"enterCd", UpdateEdit:0 },
         {Header:"파일번호",         Type:"Text",      Hidden:1,   Width:20,         Align:"Center",   SaveName:"fileSeq", UpdateEdit:0 },
         {Header:"파일순번",         Type:"Text",      Hidden:1,   Width:5,         Align:"Center",   SaveName:"seqNo",    UpdateEdit:0 },
         {Header:"파일명",         Type:"Text",      Hidden:0,   Width:100,         Align:"Left",   SaveName:"rFileNm", UpdateEdit:0 },
//         {Header:"저장파일명",      Type:"Text",      Hidden:1,   Width:10,         Align:"Left",   SaveName:"sFileNm", UpdateEdit:0 },
      {Header:"용량(KByte)",   Type:"Int",         Hidden:1,   Width:25,         Align:"right",   SaveName:"fileSize",UpdateEdit:0 },
      {Header:"파일크기",         Type:"Int",         Hidden:0,   Width:25,         Align:"right",   SaveName:"vfileSize",UpdateEdit:0, CalcLogic:"|fileSize|/1000", Format:"#,##\\kb" },
      {Header:"등록일",         Type:"Text",      Hidden:0,   Width:50,         Align:"Center",   SaveName:"chkdate", UpdateEdit:0 },
      {Header:"등록자",         Type:"Text",      Hidden:1,   Width:20,         Align:"Center",   SaveName:"chkId",    UpdateEdit:0 },
      {Header:"다운로드",         Type:"Image",      Hidden:0,   Width:40,         Align:"Center",   SaveName:"download",UpdateEdit:0 ,   Cursor:"Pointer", Sort:0}
   ]; IBS_InitSheet(supSheet, initdata1);supSheet.SetEditableColorDiff (0);
   supSheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

   $(window).smartresize(sheetResize);
   sheetInit();
   doFileAction("Search");
   
});




   function upLoadInit(fileSeq,filePath){
      
      if(fileSeq !=- null && fileSeq !== "") {
         $("#uploadForm>#fileSeq").val(fileSeq);
         doFileAction("Search");
      }
   }
   
   function getUpLoadFileSeq(){
      
      return $("#uploadForm>#fileSeq").val();
   }
   
   //첨부파일 관련
   function doFileAction(sAction) {
      switch (sAction) {
         case "Search":  supSheet.DoSearch( "${ctx}/fileuploadJFileUpload.do?cmd=jFileList", $("#uploadForm").serialize() ); break;
         
         case "download" :
            var rows = supSheet.FindCheckedRow("sChk");
            if(rows==""){
               alert("선택된 파일이 없습니다.");
               return;
            }
            if(rows == "" && $("#uploadType").val() != "") {
               if(confirm("전체 다운로드를 하시겠습니까?")) {
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
   
   //-----------------------------------------------------------------------------------
   //      supSheet 이벤트
   //-----------------------------------------------------------------------------------
   function supSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
      try{
         $("#fileuploader").fileupload('setCount', supSheet.RowCount());
           if(supSheet.RowCount() == 0) {
             //alert("대상 직원에 대한 조회 권한이 없거나 해당사원이 존재 하지 않습니다.");
           }
			supSheet.FocusAfterProcess = false;
			setSheetSize(supSheet);
        }catch(ex){
           alert("OnSearchEnd Event Error : " + ex);
        }
   }
   
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
      }catch(ex){
         alert("OnClick Event Error : " + ex);
      }
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
         doAction1("Search");
   }
   
   function supSheet_OnResize(lWidth, lHeight) {
      try { 
         setSheetSize(supSheet); 
      }catch(ex){
         alert("OnResize Event Error : " + ex); 
      }
   }

//    function endVideo(){
	
//    };

</script>
</head>
<body class="bodywrap">
<div class="wrapper" style ="overflow: auto;">
   <div class="popup_title">
      <ul>
         <li>교육영상 </li>
         <li class="close"></li>
      </ul>
   </div>
   <div class="popup_main">
      <div class="outer" style=" text-align: center;">
<!-- 동영상 삽입하는 부분 -->
		 <div id ="imgHtml">
	
	     </div>
         <div id="vRst" name="vRst">
			 
         </div>
        
         
      
      </div>
      <form id="uploadForm" name="uploadForm">
         <input id="fileSeq" name="fileSeq" type="hidden" />
         <input id="uploadType" name="uploadType" type="hidden" value="edu001"/>
      </form>   
      <input id="eduLink2" name="eduLink2" type="hidden" />
      <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
      <tr>
         <th>교육목적</th>
         <td colspan="4">
            <textarea id="note" name="note" class="${textCss} ${readonly}" readonly style="width:99%;height:120px;resize: none;"></textarea>
         </td>
      </tr>
      </table>
      <div id="eduLink" name="eduLink">
			 
      </div>
        
      <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
      <tr>
         <td>
            <div class="outer">
               <div class="sheet_title">
                  <ul>
                     <li id="txt" class="txt">교육자료</li>
                     <li class="btn" style="margin: auto;">
                        <ul>
                           <li style="float: left;">
                              <a href="javascript:doFileAction('download');"  class="basic authA">선택 다운로드</a>
                           </li>
                        </ul>
                     </li>
                  </ul>
               </div>
            </div>
            <script type="text/javascript">createIBSheet("supSheet","100%","30%");</script>
         </td>
      </tr>
   </table>

      <div class="popup_button outer">
         <ul>
            <li>
               <btn:a href="javascript:p.self.close();" css="gray large authR" mid='close' mdef="닫기"/>
            </li>
         </ul>
      </div>
   </div>
</div>

</body>
</html>