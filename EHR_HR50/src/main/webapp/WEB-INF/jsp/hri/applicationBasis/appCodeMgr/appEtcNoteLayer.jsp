<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    //var p = eval("${popUpStatus}");
    var gPRow = "";
    var pGubun = "";
    var contents = "";
    var contentsEng = "";
    var fileSeq = "";

    $(function() {
        
        const modal = window.top.document.LayerModalUtility.getModal('appEtcNoteLayer');

        contents     = modal.parameters.etcNote || '';
        contentsEng  = modal.parameters.etcNoteEng || '';
        fileSeq      = modal.parameters.fileSeq || '';
        var fileBtnNm      = modal.parameters.fileBtnNm || '';
        
        $(".close").click(function() {
            closeCommonLayer('appEtcNoteLayer');
        });

        $("#fileSeq").val(fileSeq);
        $("#contents").val(contents);
        $("#contentsEng").val(contentsEng);
        $("#contents").maxbyte(4000);
        $("#contentsEng").maxbyte(4000);

    });

    function setValue(){
        const modal = window.top.document.LayerModalUtility.getModal('appEtcNoteLayer');
        console.log($("#fileSeq").val());
        modal.fire('appEtcNoteTrigger', {
              contents : $("#contents").val()
            , contentsEng :  $("#contentsEng").val()
            , fileSeq : $("#fileSeq").val()
        }).hide();
    }

    function filePopup() {
        if(!isPopup()) {return;}

        var param = [];
        param["fileSeq"] = $("#fileSeq").val();

        var url =  '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=A';
        var param = { fileSeq: $("#fileSeq").val() };
        let layerModal = new window.top.document.LayerModal({
            id : 'fileMgrLayer'
          , url : url
          , parameters : param
          , width : 740
          , height : 620
          , title : '파일 업로드'
          , trigger :[
              {
                    name : 'fileMgrTrigger'
                  , callback : function(result){
                        $("#fileSeq").val(result.fileSeq);
                  }
              }
          ]
      });
      layerModal.show();
    }

</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <table  border="0" cellspacing="0" cellpadding="0" class="sheet_main">
                <tr>
                    <td>
                        <div class="inner">
                            <div class="sheet_title">
                                <ul>
                                    <li id="txt" class="txt"><tit:txt mid='psnlWorkScheduleMgr2' mdef='유의사항'/></li>
                                    <li class="btn">
                                        <input type="hidden" id="fileSeq" name="fileSeq"/>
                                        <btn:a href="javascript:filePopup();" css="basic" mid='btnFileV1' mdef="파일첨부"/>
                                    </li>
                               </ul>
                            </div>
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
        </div>
        
        <div class="modal_footer">
            <btn:a href="javascript:setValue();" css="btn filled" mid='110716' mdef="확인"/>
            <btn:a href="javascript:closeCommonLayer('appEtcNoteLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
        </div>
    </div>
</body>
</html>
