<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

    <div id="help_detail_modal">
      <div class="modal_background"> </div>
      <div class="modal max_wide detail_modal">
        <div class="modal_header"><span>도움말</span><i class="mdi-ico modal_close_btn">close</i></div>
        <div class="modal_sub_header">
          <div class="sub_title"></div>
          <div class="btn_area">
<!--             <span class="sub_title_date">작성일:2023-07-20</span> -->
            <span class="modal_btn editor_btn modal_close_btn" onclick="modalScript.actionHelp('D')"><i class="mdi-ico">delete</i>삭제</span>
            <span class="modal_btn editor_btn modal_close_btn" onclick="modalScript.actionHelp('U')"><i class="mdi-ico">drive_file_rename_outline</i>수정</span>
          </div>
        </div>
        <div class="modal_body">
        	<div id="file_area">
        		<%@ include file="/WEB-INF/jsp/common/popup/uploadProcessMapMgrForm.jsp"%>
<%--         	<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%> --%>
        	</div>
      </div>
    </div>
    
<script type="text/javascript">
  var modalScript = {	
    modalOpts: null, // 전달받은 modalOpts (생성시 전달한 값 + target 등 추가된 opts 이다.)
    modal: null,
    procSeq:null,
    fileSeq:"",
    authPg:"",
    init: function (obj) {
      this.modalOpts = obj;
      this.modal = this.modalOpts.target;
      let procViewMode=obj["params"]["procViewMode"];
      this.procSeq=obj["params"]["procSeq"];
      this.fileSeq=obj["params"]["fileSeq"];
      this.authPg=obj["params"]["authPg"];
      
      if(procViewMode=="viewer"){
    	  $(".editor_btn").remove();
      }
      
//       if(obj["params"]["fileSeq"]==""||$('#myUpload').IBUpload('fileList').length < 1){
//     	  $("#file_area").css("display", "none");
//       }
      
      upLoadInit(this.fileSeq);
      $("#help_detail_modal .sub_title").text(obj["params"]["helpTxtTitle"]);
      $('#help_detail_modal .modal_body').prepend('<div id="content_area">'+obj["params"]["helpTxtContent"]+'</div');
    },
    actionHelp:function (action){
    	if(action=="D"){
        	if(!confirm("도움말을 삭제하시겠습니까?")){
        		return;
        	}
    	}
    	this.modalOpts.rtnValue={action:action,procSeq:this.procSeq}
    },
  };
</script>