<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head><title>휴가신청</title>


    <script type="text/javascript">
        $(function() {
            const modal = window.top.document.LayerModalUtility.getModal('atnatMgrLayer');
            var selectDate = modal.parameters.selectDate ;
            var applSeq = modal.parameters.applSeq ;
            // var reqParam = modal.parameters.reqParam ;

            //신청일자
            $("#eYmd").datepicker2();

            setResSeqCombo();

            detailPopup(applSeq, selectDate);
        });

        function setResSeqCombo(reqParam){
            //이름리스트
            var nameList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAtnatNameList",false).codeList, "name", "");
            $('#nameList').html(nameList[2]);
            //휴가구분
            var vacationCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "S20020"), "");
            $("#vacationCd").html(vacationCdList[2]);
        }


        // 상세/등록
        function detailPopup(applSeq, selectDate){
            $("#popFrm")[0].reset();

            if(applSeq != ""){
                // 상세정보 셋팅
                var map = ajaxCall("${ctx}/AtnatMgr.do?cmd=getAtnatAppMap", "searchApplSeq="+applSeq, false);

                $("#applSeq", "#popFrm").val(map.DATA.applSeq);
                $("#nameList", "#popFrm").val(map.DATA.name).change();
                $("#vacationCd", "#popFrm").val(map.DATA.vacationCd).change();
                $("#reason", "#popFrm").val(map.DATA.reason);
                $("#sYmd", "#popFrm").val(formatDate(map.DATA.vacationSdate,"-"));
                $("#span_sYmd", "#popFrm").html(formatDate(map.DATA.vacationSdate,"-"));
                $("#eYmd", "#popFrm").val(formatDate(map.DATA.vacationEdate,"-"));
                $("#nameList", "#popFrm").attr("disabled", true).addClass("transparent").removeClass("required").addClass("hideSelectButton");
            }else if(selectDate != ''){ //신규신청

                $("#applSeq", "#popFrm").val("");
                var reqYmd = selectDate;

                $("#addBtn").show();
                $("#delBtn").hide();

                $("#nameList, #vacationCd, #eYmd").addClass("required").removeAttr("readonly");
                // 신규예약
                $("#sYmd", "#popFrm").val(reqYmd);
                $("#eYmd", "#popFrm").val(reqYmd);
                $("#span_sYmd").html(reqYmd);

                //기본으로 신청자정보는 본인 정보
                $("#reqSabun", "#popFrm").val("${ssnSabun}");
            }
        }

        // 저장
        function checkList(){
            var ch = true;
            // 화면의 개별 입력 부분 필수값 체크
            $(".required").each(function(index){
                if($(this).val() == null || $(this).val() == ""){
                    alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
                    $(this).focus();
                    ch =  false;
                    return false;
                }

                return ch;
            });

            if(!ch) return false;

            if($('#vacationCd').val() == '10' ||$('#vacationCd').val() == '20') {
                var sYmdDate = new Date($('#sYmd').val());
                var eYmdDate = new Date($('#eYmd').val());
                var diff = Math.abs(eYmdDate.getTime() - sYmdDate.getTime());
                diff = Math.ceil(diff / (1000 * 60 * 60 * 24));
                if(diff > 0) {
                    alert('반차는 하루만 선택해 주세요.');
                    $('#eYmd').focus();
                    return ;
                }
            }

            if($('#applSeq').val() == '') {
                var params = "name="+$("#nameList").val()
                    + "&sYmd="+$("#sYmd").val().replace(/-/gi,"")
                    + "&eYmd="+$("#eYmd").val().replace(/-/gi,"");
                var dup = ajaxCall("/AtnatMgr.do?cmd=getAtnatAppDupCheck", params,false);
                if(dup.DATA.dupCnt > 0){
                    alert("해당일자에 휴가가 존재합니다.");
                    return false;
                }
            }

            return true;
        }
        // 저장
        function doSave(sStatus){
            try{
            $("#sStatus").val(sStatus);
                var url;
                if( sStatus == "I" ){
                    if ( !checkList() ) {
                        return;
                    }
                    url = "/AtnatMgr.do?cmd=saveAtnatApp";
                }else if( sStatus == "D" ){
                    if( !confirm("휴가를 취소하시겠습니까?" ) ) return;
                    url = "/AtnatMgr.do?cmd=deleteAtnatApp";
                }

                $("#sYmd").val($("#sYmd").val().replace(/-/gi,""));
                $("#eYmd").val($("#eYmd").val().replace(/-/gi,""));
                $('#name').val($("#nameList").val());
                var result = ajaxCall(url, $("#popFrm").serialize(),false);

                if(result != null && result.Result.Code != null){
                    const modal = window.top.document.LayerModalUtility.getModal('atnatMgrLayer');
                    modal.fire('atnatMgrTrigger', {}).hide();
                    alert("처리되었습니다.");
                }else{
                    alert("처리 중 오류가 발생했습니다.");
                }


            }catch(ex){alert("Save Event Error : " + ex);}
        }

        function closeLayerModal(){
            const modal = window.top.document.LayerModalUtility.getModal('atnatMgrLayer');
            modal.hide();
        }

    </script>
    <style type="text/css">
        body { font-size: 11px !important; }
        textarea.transparent {
            border:none !important;
            background:none !important;
        }

        .resInfo th {background-color:#f9fcfe !important; }

        /*---- checkbox ----*/
        input[type="checkbox"]  {
            display:inline-block; width:20px; height:20px; cursor:pointer; appearance:none;
            -moz-appearance:checkbox; -webkit-appearance:checkbox; margin-top:2px;background:none;
            border: 5px solid red;
        }
        label {
            vertical-align:-2px;padding-right:10px;
        }
    </style>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <!-- 상세조회(등록) 팝업 -->
        <form id="popFrm" name="popFrm" >
            <input type="hidden" id="applSeq" name="applSeq" />
            <input type="hidden" id="sStatus" name="sStatus" />
            <input type="hidden" id="sYmd" name="sYmd" />
            <input type="hidden" id="name" name="name" />
            <table class="default resInfo">
                <%--<colgroup>
                    <col width="100"/>
                    <col width="230"/>
                </colgroup>--%>
                <tr>
                    <th>성명</th>
                    <td colspan="3">
                        <select id="nameList" name="nameList"></select>
                    </td>
                </tr>
                <tr>
                    <th>신청일자</th>
                    <td>
                        <span id="span_sYmd"></span> ~
                        <input type="text" id="eYmd" name="eYmd" class="date2" value=""/>
                    </td>
                    <th>휴가구분</th>
                    <td>
                        <select id="vacationCd" name="vacationCd"></select>
                    </td>
                <tr>
                    <th>사유</th>
                    <td class="content" colspan="3">
                        <textarea id="reason" name="reason" rows="3" class="${textCss} w100p"></textarea>
                    </td>
                </tr>
            </table>
        </form>

    </div>
    <div class="modal_footer">
        <a href="javascript:doSave('I');"       class="btn filled" id="addBtn">신청</a>
        <a href="javascript:doSave('D');"       class="btn filled" id="delBtn">취소</a>
        <a href="javascript:closeLayerModal();"  class="btn outline_gray">닫기</a>
    </div>
</div>
</body>
</html>