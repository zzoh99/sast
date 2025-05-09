<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%
String uploadType = "pht003";
request.setAttribute("uploadType", uploadType);
FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> 
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>



<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>

<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />
<script type="text/javascript">
    var p = eval("${popUpStatus}");
    var pGubun = {};
    var EMP_FIELD_INFO = {};
    var arg = ""

    $(function() {
        const modal = window.top.document.LayerModalUtility.getModal('empPictureChangeReqLayer');
        arg = modal.parameters;
        
        //$("#empForm").append("<input type='hidden' id='s_SAVENAME' name='s_SAVENAME'/>");    
        $("#empForm").append("<input type='hidden' id='applYmd' name='applYmd' value='${curSysYyyyMMdd}'/>");
        $("#empForm").append("<input type='hidden' id='applStatusCd' name='applStatusCd' value='1'/>");//1:신청
        $("#sabun").val(arg.sabun);
        $("#txtSabun").text(arg.sabun);
        $("#txtName").text(arg.name);
        
        //현재 사진 조회
        downloadFile("orgPhoto","&searchKeyword="+$("#sabun").val());
        
        var options = $.extend(true, ${fConfig}, {
            context:"${ctx}",
            event:{
                success: function(jsonData) {
                    if(jsonData.data !== undefined && jsonData.data !== null && jsonData.data.length > 0) {
                        var data = jsonData.data[0];
                        
                        $("#fileSeq", "#uploadForm").val(data.fileSeq);
                        $("#seqNo", "#uploadForm").val(data.seqNo);
                        downloadFile("applPhoto","&fileSeq=" + data.fileSeq + "&seqNo=" + data.seqNo);
                        
                    }
                },
                error: function(jsonData) {
                    alert(jsonData.msg);
                }
            }
        }),
        params = {
                'uploadType' :"${uploadType}",
                'fileSeq' : '',
                'searchKeyword' : $("#sabun").val()
            };

        $("#fileuploader").fileupload("init", options, params);
        

    });

    
    function doAction1(sAction){
        switch (sAction) {
            case "Save":
                if($("#fileSeq").val() == ""){
                    alert("'파일선택'버튼을 클릭하여 신청할 이미지를 선택하세요.");
                    break;
                }
//                 ajaxCall2("${ctx}/PsnalBasicInf.do?cmd=saveEmpPictureChangeReq",$("#uploadForm").serializeObjet(),true
                ajaxCall2("${ctx}/PsnalBasicInf.do?cmd=saveEmpPictureChangeReq",$("#uploadForm").serialize(),true
                        ,function(){
                            progressBar(true) ;
                        }
                        ,function(data){
                            progressBar(false) ;

                            alert(data.Result.Message);
                            if(data.Result.Code>0)closeCommonLayer('empPictureChangeReqLayer');
                        }
                );
            break;
            
        }
    }
    
    function downloadFile(objid, params){//
        $("#"+objid).attr("src", "${ctx}/EmpPhotoOut.do?t=" + new Date().getTime() + params);
    }
</script>

</head>
<body class="bodywrap">
    
    <div class="wrapper modal_layer">
        
        <div class="modal_body">
            <form id="uploadForm" name="uploadForm" method="post">
            <input type="hidden" name="utype" id="utype" value="applpicture" />
            <input type="hidden" name="sabun" id="sabun"/>
            <input type="hidden" name="filename" id="filename"/>
            <input type="hidden" name="fileSeq" id="fileSeq"/>
            <input type="hidden" name="seqNo" id="seqNo"/>
            <input type="hidden" name="applYmd" id="applYmd" value="${curSysYyyyMMdd}"/>
            <input type="hidden" name="applStatusCd" id="applStatusCd" value="1"/>
            <input type="hidden" name="returnMessage" id="returnMessage"/>
            <input type="hidden" name="errorLog" id="errorLog"/>
            <input type="hidden" name="memo" id="memo"/>
            <input type="hidden" name="imageType" id="imageType" value="1"/>
            <div class="layerTitle-wrap">
            	<tit:txt mid='112027' mdef='개인이미지 수정신청'/>
            	<button id='fileuploader' class="ml-auto" align='right'></button>
            </div>
            </form>
        
            <div>
                    
                <table border="0" cellpadding="0" cellspacing="0" class="default inner fixed">
                <colgroup>                    
                    <col width="20%" />
                    <col width="" />
                </colgroup>
                <tr>
                    
                    <th><tit:txt mid='103975' mdef='사번'/></th>
                    <td><span id="txtSabun"></span></td>
                </tr>
                <tr>
                    <th><tit:txt mid='103880' mdef='성명'/></th>
                    <td><span id="txtName"></span></td>
                </tr>
                <tr>
                    <td colspan="2" class="">
                    	<p class="desc">
						- 권장사이즈 : 180px * 270px 입니다.<br/>
						- 확장자 : jpg,jpeg,png 만 가능합니다.(ex) aa.jpg, aa.jpeg, aa.png<br/>
						</p>
                    </td>
                </tr>
                </table>
                <table border="0" cellpadding="0" cellspacing="0" class="default" id="empTable">
                    <colgroup>
                        <col width="50%" />
                        <col width="" />
                    </colgroup>
                    <tr>                        
                        <th style="text-align:center;"><tit:txt mid='113079' mdef='신청전 이미지'/></th>
                        <th style="text-align:center;"><tit:txt mid='112368' mdef='신청 이미지'/></th>
                    </tr>
                    <tr>
                        <td align=center>
                            <table>
                                <tr>
                                    <td>
                                        <img id="orgPhoto" src="/common/images/common/img_photo.gif" id="photo" width="110" height="165" onerror="javascript:this.src='/common/images/common/img_photo.gif'">    
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td align=center>
                            <table>
                                <tr>
                                    <td>
                                        <img id="applPhoto" src="/common/images/common/img_photo.gif" id="photo" width="110" height="165" onerror="javascript:this.src='/common/images/common/img_photo.gif'">    
                                    </td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                </table>
                
            </div>
        </div>
        <div class="modal_footer">
        	<a href="javascript:doAction1('Save');" class="btn filled"><tit:txt mid='104394' mdef='수정신청'/></a>
            <a href="javascript:closeCommonLayer('empPictureChangeReqLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
        </div>
    </div>
    </body>
</html>
