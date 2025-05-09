<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp" %>
<script>
    $(document).ready(function() {
        const modal = window.top.document.LayerModalUtility.getModal('wtmPsnlWorkTypeAddTargetLayer');
        const params = modal.parameters;

        const workClassCd = params.workClassCd
        const workGroupCd = params.workGroupCd
        const sabun = params.sabun;

        $(modal.modalWrap).find('#sdate').datepicker2();
        $(modal.modalWrap).find('#edate').datepicker2({
            enddate: "sdate"
        });

        let html = '';
        sabun.forEach(function(item, i){
            html += '<input type="hidden" name="targetList[' + i + '].targetCd" value="' + item + '">';
        });

        $(modal.modalWrap).find('#targets').val(sabun);

        $(modal.modalWrap).find('#saveFrom').append(html);
        $(modal.modalWrap).find('#workClassCd').val(workClassCd);

        $(modal.modalWrap).find('#untilNextWorkYn').on("change", function() {
            if ($(this).is(":checked")) {
                $(modal.modalWrap).find('#edate').val("").parent().hide();
            } else {
                $(modal.modalWrap).find('#edate').val($(modal.modalWrap).find('#sdate').val()).parent().show();
            }
        })

        if(params.workGroupCd){
            const workGroupCdList = ajaxCall("/WtmPsnlWorkTypeMgr.do?cmd=getWtmPsnlWorkGroupCdList", "workClassCd=" + workClassCd, false).DATA;
            workGroupCdList.forEach(function(group){
                if(workGroupCd == group.workGroupCd){
                    $(modal.modalWrap).find('#workGroupNm').val(group.workGroupNm);
                }
            });
            $(modal.modalWrap).find('#workGroupCd').val(params.workGroupCd);
            $(modal.modalWrap).find('.workGroupCd').show();
        }else{
            $(modal.modalWrap).find('.workGroupCd').hide();
        }
    });

    async function saveWorkTarget() {
        const modal = window.top.document.LayerModalUtility.getModal('wtmPsnlWorkTypeAddTargetLayer');

        progressBar(true);
        const param = {
            workClassCd: $(modal.modalWrap).find('#workClassCd').val(),
            workGroupCd: $(modal.modalWrap).find('#workGroupCd').val(),
            sdate: $(modal.modalWrap).find('#sdate').val(),
            edate: $(modal.modalWrap).find('#edate').val(),
            untilNextWorkYn: $(modal.modalWrap).find('#untilNextWorkYn').is(':checked') ? 'Y' : 'N',
            note: $(modal.modalWrap).find('#note').val(),
            targets: $(modal.modalWrap).find('#targets').val()
        };
        const result = await callFetch("/WtmPsnlWorkTypeMgr.do?cmd=saveWtmPsnlWorkTarget", param);
        if (result.isError) {
            alert(result.errMsg);
            progressBar(false);
            return;
        }

        if (result.Code > 0) {
            const modal = window.top.document.LayerModalUtility.getModal('wtmPsnlWorkTypeAddTargetLayer');
            modal.fire('wtmPsnlWorkTypeAddTargetLayerTrigger', '').hide();
        }

        alert(result.Message);
        progressBar(false);
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <form id="saveFrom">
            <input id="targets" name="targets" type="hidden" value="" />
            <input id="workClassCd" name="workClassCd" type="hidden" value="" />
            <div class="table-wrap">
                <table class="basic type5 line-grey">
                    <colgroup>
                        <col width="20%" />
                        <col width="80%" />
                    </colgroup>
                    <tbody>
                    <tr class="workGroupCd">
                        <th>근무조</th>
                        <td>
<%--                            <div class="input-wrap">--%>
<%--                                <select class="custom_select" id="workGroupCd" name="workGroupCd">--%>
<%--                                </select>--%>
<%--                            </div>--%>
                            <div class="input-wrap" style="width: 280px;">
                                <input class="form-input" id="workGroupCd" name="workGroupCd" type="hidden" value="" />
                                <input class="form-input" id="workGroupNm" name="workGroupNm" type="text" value="" readonly/>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>시작일</th>
                        <td>
                            <div class="input-wrap">
                                <div class="date-wrap">
                                    <input class="form-input" id="sdate" name="sdate" type="text" value="${curSysYyyyMMddHyphen}"/>
                                </div>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>종료일</th>
                        <td>
                            <div class="input-wrap">
                                <div class="date-wrap">
                                    <input class="form-input" id="edate" name="edate" type="text" value="2999-12-31" />
                                </div>
                                <input type="checkbox" class="form-checkbox" id="untilNextWorkYn" name="untilNextWorkYn" value="Y" />
                                <label for="untilNextWorkYn">직후 근무유형 전까지</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>비고</th>
                        <td>
                            <div class="input-wrap" style="width: 280px;">
                                <input class="form-input" id="note" name="note" type="text" value="" />
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </div>
        </form>
    </div>
    <div class="modal_footer">
        <a href="javascript:saveWorkTarget()" class="btn filled">저장</a>
    </div>
</div>
</body>
</html>



