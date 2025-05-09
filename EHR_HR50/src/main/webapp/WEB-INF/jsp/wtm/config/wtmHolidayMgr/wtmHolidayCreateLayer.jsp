<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp" %>
<!-- 개별 화면 script -->
<script type="text/javascript">
    $(function() {
        const modal = window.top.document.LayerModalUtility.getModal('wtmHolidayCreateLayer');
        const dataCode = modal.parameters.dataCode || '' ;
        const holidayId = modal.parameters.holidayId || '' ;
        const searchYear = modal.parameters.searchYear || '';
        let titleTxt = "공휴일 생성";

        setBizPlaceInput(holidayId);
        initEvent();

        if (holidayId !== '') {
            const param = "searchYear=" + searchYear
                +  "&holidayCd=" + holidayId
            const holidays = ajaxCall("${ctx}/WtmHolidayMgr.do?cmd=getWtmHolidayMgrById", param, false).DATA;
            const holiday = holidays[0];
            $('#searchAppYmd').val(formatDate(holiday.inputDate, "-"));
            $("#repeatEYear").val(parseInt(holiday.yy) + 100);
            $('#bizPlaceText').html(holiday.businessPlaceNm);
            $('#holidayCd').val(holidayId);
            $('input[name="repeatYn"][value="' + holiday.repeatYn + '"]').prop('checked', true);
            $('input[name="gubun"][value="' + holiday.gubun + '"]').prop('checked', true);
            $('input[name="substituteType"][value="' + holiday.substituteType + '"]').prop('checked', true);
            $('input[name=addDaysYn][value=' + holiday.addDaysYn + ']').prop('checked', true);
            $('#holidayNm').html(holiday.holidayNm);
            $('#bizPlaceSelect').val(holiday.businessPlaceCd === 'all' ? '' : holiday.businessPlaceCd);
            $('#holidayAction').text('수정');

            titleTxt = "공휴일 수정";
        }else{
            $('#bizPlaceSelect').val(dataCode === 'all' ? '' : dataCode);
        }

        $('#modal-wtmHolidayCreateLayer').find('div.layer-modal-header span.layer-modal-title').text(titleTxt);

        toggleRepeatYear();
        toggleDateInput();

        const maxDate = ajaxCall("${ctx}/WtmHolidayMgr.do?cmd=getWtmHolidayMgrMaxDate", '', false).DATA;
        $('#maxSunDate').val(maxDate.maxSunDate)
        $('#maxMoonDate').val(maxDate.maxMoonDate)
    });

    function initEvent() {
        $('#repeatEYear').on('input', function() {
            this.value = this.value.replace(/[^0-9]/g, ''); // 숫자가 아닌 문자는 제거
        });

        $('input[name="repeatYn"]').on('change', function() {
            $('#repeatEYear').val('');
            toggleRepeatYear();
        });

        $('input[name="gubun"]').on('change', function() {
            toggleDateInput();
            checkMaxDate();
        });

        $('input[name="repeatEYear"]').on('focusout', function() {
            checkMaxDate();
        });
    }

    function toggleRepeatYear() {
        if ($('#radioy1').is(':checked')) {
            $('#repeatTr').show();
        } else {
            $('#repeatTr').hide();
        }
    }

    function toggleDateInput() {
        const ymd = $('#searchAppYmd').val();

        $("#dateInput").empty();

        $("#dateInput").append(createDateInput());
        // if ($('#radiog2').is(':checked')) {
            $("#searchAppYmd").datepicker2({
                onReturn: function() {
                    if(!$("#repeatEYear").val()){
                        const sYmd = $("#searchAppYmd").val().split('-');
                        const sYear = sYmd[0];

                        const maxSunDate = $('#maxSunDate').val();
                        const maxMoonDate = $('#maxMoonDate').val();
                        const maxYmd = maxSunDate.substring(0,4) + sYmd[1] + sYmd[2];
                        const gubun = $('input[name=gubun]:checked').val();
                        const repeatYn = $('input[name=repeatYn]:checked').val();

                        if(repeatYn == 'Y'){
                            if(gubun == '1'){
                                if(maxYmd < maxSunDate){
                                    $('#repeatEYear').val(maxSunDate.substring(0, 4))
                                }else {
                                    $('#repeatEYear').val(maxSunDate.substring(0, 4)-1)
                                }
                            }else if(gubun == '2'){
                                if(maxYmd < maxMoonDate){
                                    $('#repeatEYear').val(maxMoonDate.substring(0, 4))
                                }else {
                                    $('#repeatEYear').val(maxMoonDate.substring(0, 4)-1)
                                }
                            }
                        }

                        // $("#repeatEYear").val(parseInt(sYear) + 100);
                    }
                    $("#searchAppEYmd").val($(this).val());
                }
            });
        // }

        $('#searchAppYmd').mask('1111-11-11');

        $('#searchAppYmd').val(ymd);
    }

    function setBizPlaceInput() {
        const bizPlaceCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getYeaBizPlaceCdList",false).codeList, "전체");

        let $selectBizPlace = $('#bizPlaceSelect');
        $selectBizPlace.show();
        $selectBizPlace.empty();
        $selectBizPlace.append(bizPlaceCdList[2]);
    }

    function createHoliday() {
        const searchAppYmd = $('#searchAppYmd').val();
        const holidayNm = $('#holidayNm').val();

        if (!searchAppYmd) {
            alert("공휴일 날짜를 입력해주세요.");
            return;
        }

        if (!holidayNm) {
            alert("공휴일명을 입력해주세요.");
            return;
        }
        const result = ajaxCall("/WtmHolidayMgr.do?cmd=saveWtmHolidayMgr", $("#holidayForm").serialize(), false);

        if (result.Result.Code > 0) {
            alert("추가되었습니다.");

            const modal = window.top.document.LayerModalUtility.getModal('wtmHolidayCreateLayer');
            modal.fire('wtmHolidayCreateLayerTrigger', '').hide();
        } else {
            alert(result.Result.Message);
        }
    }

    function createDateInput() {
        return '<input id="searchAppYmd" name="searchAppYmd" type="text" maxlength="10" class="text center date"/>';
    }

    //최대 반복 기간 체크
    function checkMaxDate() {
        const repeatYn = $('input[name=repeatYn]:checked').val();
        const gubun = $('input[name=gubun]:checked').val();
        const searchAppYmd = $('#searchAppYmd').val().split('-');
        const repeatEYear = $('#repeatEYear').val();
        const maxAppYmd = repeatEYear+searchAppYmd[1]+searchAppYmd[2];
        const maxSunDate = $('#maxSunDate').val();
        const maxMoonDate = $('#maxMoonDate').val();
        console.log(repeatYn)
        console.log(gubun)
        console.log(searchAppYmd)
        console.log(repeatEYear)

        if(repeatYn == 'Y' && repeatEYear != '' && searchAppYmd != ''){
            if(gubun == '1' && maxAppYmd > maxSunDate){
                $('#repeatEYear').val(maxSunDate.substring(0, 4) - 1)
                alert('최대 등록 년수를 초과하였습니다.\n관리자에게 문의 바랍니다.');
            }else if(gubun == '2' && maxAppYmd > maxMoonDate){
                $('#repeatEYear').val(maxMoonDate.substring(0, 4) - 1)
                alert('최대 등록 년수를 초과하였습니다.\n관리자에게 문의 바랍니다.');
            }
        }
    }
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
    <div class="modal_body">
        <h2 class="title-wrap">
            <div class="inner-wrap">
                <span class="page-title">추가내용</span>
            </div>
        </h2>
        <div class="table-wrap">
            <form id="holidayForm">
                <input type="hidden" id="holidayCd" name="holidayCd" />
                <input type="hidden" id="maxSunDate" name="maxSunDate" />
                <input type="hidden" id="maxMoonDate" name="maxMoonDate" />
                <table class="basic type5 bt-line bb-line">
                    <colgroup>
                        <col width="15%" />
                        <col width="35%" />
                        <col width="15%" />
                        <col width="35%" />
                    </colgroup>
                    <tbody>
                    <tr>
                        <th>사업장</th>
                        <td colspan="3" id="bizPlaceCd">
                            <select class="custom_select" id="bizPlaceSelect" name="bizPlace"></select>
                        </td>
                    </tr>
                    <tr>
                        <th>음양구분</th>
                        <td>
                            <div class="input-wrap">
                                <input type="radio" name="gubun" id="radiog1" class="form-radio" value="2" />
                                <label for="radiog1">음력</label>
                                <input type="radio" name="gubun" id="radiog2" class="form-radio" value="1" checked/>
                                <label for="radiog2">양력</label>
                            </div>
                        </td>
                        <th>반복설정</th>
                        <td>
                            <div class="input-wrap">
                                <input type="radio" name="repeatYn" id="radioy1" class="form-radio" value="Y"/>
                                <label for="radioy1">매년</label>
                                <input type="radio" name="repeatYn" id="radioy2" class="form-radio" value="N" checked/>
                                <label for="radioy2">안함</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>공휴일여부</th>
                        <td>
                            <div class="input-wrap">
                                <input type="radio" name="holidayYn" id="holidayy1" class="form-radio" value="Y" checked/>
                                <label for="holidayy1">공휴일</label>
                                <input type="radio" name="holidayYn" id="holidayy2" class="form-radio" value="N"/>
                                <label for="holidayy2">공휴일아님</label>
                            </div>
                        </td>
                        <th>앞/뒤추가여부</th>
                        <td>
                            <div class="input-wrap">
                                <input type="radio" name="addDaysYn" id="addDaysYn1" class="form-radio" value="Y"/>
                                <label for="holidayy1">추가</label>
                                <input type="radio" name="addDaysYn" id="addDaysYn2" class="form-radio" value="N" checked/>
                                <label for="holidayy2">추가안함</label>
                            </div>
                        </td>
                    </tr>
                    <tr>
                        <th>공휴일</th>
                        <td colspan="3">
                            <div id="dateInput">
                                <input id="searchAppYmd" name="searchAppYmd" type="text"  maxlength="10" class="text center date"/>
                            </div>
                        </td>
                    </tr>
                    <tr id="repeatTr" style="display: none;">
                        <th>반복기간</th>
                        <td colspan="3">
                            <input id="repeatEYear" name="repeatEYear" type="text"  maxlength="4" class="text center"/>년까지 저장됩니다.
                        </td>
                    </tr>
                    <tr>
                        <th>공휴일명</th>
                        <td colspan="3">
                            <textarea class="form-textarea" id="holidayNm" name="holidayNm"></textarea>
                        </td>
                    </tr>
                    <tr>
                        <th>대체휴일</th>
                        <td colspan="3">
                            <div class="input-wrap">
                                <input type="radio" name="substituteType" id="radioh1" class="form-radio" value="N" checked/>
                                <label for="radioh1">적용안함</label>
                                <input type="radio" name="substituteType" id="radioh2" class="form-radio" value="A"/>
                                <label for="radioh2">일요일</label>
                                <input type="radio" name="substituteType" id="radioh3" class="form-radio" value="B"/>
                                <label for="radioh3">토·일요일</label>
                            </div>
                        </td>
                    </tr>
                    </tbody>
                </table>
            </form>
        </div>
    </div>
    <div class="modal_footer">
        <a href="javascript:closeCommonLayer('wtmHolidayCreateLayer')" class="btn outline_gray">취소</a>
        <a href="javascript:createHoliday()" class="btn filled" id="holidayAction">추가</a>
    </div>
</div>
</body>
</html>



