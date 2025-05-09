<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- css -->
<link href="/common/plugin/bootstrap/css/bootstrap.min.css" rel="stylesheet">
<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css" />

<script type="text/javascript">

    $(function () {
        const data = ajaxCall('/EvaMain.do?cmd=getEvaGoalCommentRegList', $("#referGoalStaForm").serialize(), false).DATA;
        if(data != null && data !== 'undefined') {
            let html = '';
            for(let i=0; i<data.length; i++) {
                let datetime = new Date().getTime();
                let imageUrl = '/EmpPhotoOut.do?enterCd=' + data[i].enterCd + '&searchKeyword=' + data.sabun + '&t=' + datetime;

                html +=
                    `<div class="row p-0">
                        <p class="thumb"><img src="${'${imageUrl}'}"></p>
                        <div class="d-flex flex-column flex-grow-1">
                            <div class="d-flex pb-2 align-items-center info-wrap">
                                <p class="name">${'${data[i].name}'}</p>
                                <div class="d-flex align-items-center ml-2 info">
                                    <p>${'${data[i].jikweeNm}'}</p>
                                    <p>${'${data[i].orgNm}'}</p>
                                </div>
                                <p class="badge sm green ml-auto">${'${data[i].statusNm}'}</p>
                            </div>
                            <div class="d-flex">
                                <span class="sm-date pr-2">${'${data[i].regTime}'}</span>
                                <div class="box-list flex-grow-1">
                                    <ul>
                                        <li class="md-dot h5 font-weight-normal lh-md">${'${data[i].appComment}'}</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>`
            }
            $("#commentWrap").html(html);
        }
    });
</script>
<form id="referGoalStaForm" name="referGoalStaForm">
    <input type="hidden" id="searchAppStepCd" name="searchAppStepCd" value="${param.searchAppStepCd}"/>
    <input type="hidden" id="searchEvaSabun" name="searchEvaSabun" value="${param.searchEvaSabun}"/>
    <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value="${param.searchAppraisalCd}"/>
    <input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" value="${param.searchAppOrgCd}"/>
    <input type="hidden" id="searchAppStatusCd" name="searchAppStatusCd" value="${param.searchAppStatusCd}"/>
</form>
<div class="hr-container target-modal p-0">
    <div id="commentWrap" class="box box-border d-block target-ing"></div>
</div>

<!-- bootstrap js -->
<script type="text/javascript" src="/common/plugin/bootstrap/js/bootstrap.bundle.min.js"></script>


