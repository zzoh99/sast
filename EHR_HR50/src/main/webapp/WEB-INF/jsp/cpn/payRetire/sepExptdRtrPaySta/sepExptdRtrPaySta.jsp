<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

    <script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

	<script type="text/javascript">
        var gPRow = "";
        var pGubun = "";
        $(function() {
            $('#searchYmd').datepicker2();

            //사번셋팅
            setEmpPage();
        });

        function doAction1(sAction) {
            switch (sAction) {
                case "Search":
                    doAction1("Clear");

                    $("#sabun"		).val(parent.$("#sabun").val());
                    $("#payActionCd").val(parent.$("#payActionCd").val());

                    // 지급항목/공제내역/급여기초/과표내역/비과세내역 조회
                    var sepSimulationInfo = ajaxCall("${ctx}/SepSimulationMgr.do?cmd=getSepSimulationMgr", $("#sheet1Form").serialize(), false);
                    if (sepSimulationInfo.DATA != null && typeof sepSimulationInfo.DATA != "undefined") {
                        $("#empYmd").html(formatDate(sepSimulationInfo.DATA.empYmd,'-'));
                        $("#rmidYmd").html(sepSimulationInfo.DATA.rmidYmd?formatDate(sepSimulationInfo.DATA.rmidYmd,'-'):'-');
                        $("#sepSymd").html(formatDate(sepSimulationInfo.DATA.sepSymd,'-'));
                        $("#sepEymd").html(formatDate(sepSimulationInfo.DATA.sepEymd,'-'));
                        $("#wkpDCnt").html(sepSimulationInfo.DATA.wkpDCnt);
                        $("#wkpAllDCnt").html(makeComma(sepSimulationInfo.DATA.wkpAllDCnt) + "일");
                        $("#avgMonTit").html(sepSimulationInfo.DATA.avgMonTitle);
                        $("#avgMon").html(sepSimulationInfo.DATA.avgMon.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"원");
                        $("#sepRule").html(sepSimulationInfo.DATA.sepRule);
                        $("#earningMon").html(sepSimulationInfo.DATA.earningMon.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",")+"원");
                        $("#eSepRule").html(sepSimulationInfo.DATA.eSepRule);
                    }
                    break;

                case "Proc":
                    if(!$('#searchYmd').val()){
                        alert('퇴직일을 선택해주세요.');
                        return;
                    }
                    if (!confirm("예상퇴직금을 계산하시겠습니까?")) return;
                    progressBar(true) ;
                    // $('#progressBar').show();

                    setTimeout(
                        function(){

                            const param = {
                                searchSabun: $('#searchSabun').val(),
                                searchYmd: $('#searchYmd').val().replaceAll('-', ''),
                            }
                            var data = ajaxCall("${ctx}/SepSimulationMgr.do?cmd=prcPCpnSepSimulation", param, false);
                            if(data.Result.Code == null) {
                                doAction1("Search");
                                alert("<msg:txt mid='alertPrcJobOk' mdef='작업 완료되었습니다.'/>");
                                progressBar(false) ;
                                // $('#progressBar').hide();
                                $('#sheet1Form').hide();
                                $('#resultCard').show();
                            } else {
                                alert("<msg:txt mid='2021081100939' mdef='처리중 오류가 발생했습니다.'/>\n"+data.Result.Message);
                                progressBar(false) ;
                                // $('#progressBar').hide();
                            }
                        }
                        , 100);
                    break;
                case "Clear":
                    $("#empYmd").val("");
                    $("#rmidYmd").val("");
                    $("#sepSymd").val("");
                    $("#sepEymd").val("");
                    $("#wkpDCnt").val("");
                    $("#avgMon").val("");
                    $("#sepRule").val("");
                    $("#earningMon").val("");
                    $("#eSepRule").val("");
            }
        }


        //인사헤더에서 이름 변경 시 호출 됨
        function setEmpPage() {
            $('#sheet1Form').show();
            $('#resultCard').hide();
            $("#searchSabun").val($("#searchUserId").val());
            // doAction1("Search");
        }
	</script>
</head>
<body class="hidden">
	<div class="wrapper">
        <%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
		<div class="ux_wrapper">
            <div class="page_title mb-12">예상 퇴직금 관리</div>
            <div class="contents severance_wrap">
                <form id="sheet1Form" name="sheet1Form" >
                    <input type="hidden" id="searchSabun" name="searchSabun" class="text" value="" />
                    <div class="w-318 d-flex flex-col align-center ma-auto">
                        <i class="icon calculator mb-16 size-100"></i>
                        <p class="txt_body_m txt_center txt_secondary mb-32">
                            기간을 선택하여 퇴직금 예상 금액을<br />확인해 볼 수 있습니다.
                        </p>
                        <div class="w-full mb-16">
                            <!-- 아래 input, img 태그는 지우시고 기존 개발에서 사용하시는 input.bbit-dp-input 에 .lg.w-full 클래스 추가하시면 됩니다. -->
<%--                            <input type="text" id="searchYmd" name="searchYmd" class="date2 bbit-dp-input lg w-full" maxlength="8" autocomplete="off" placeholder="퇴직일을 선택해주세요">--%>
<%--                            <img class="ui-datepicker-trigger" src="/common/orange/images/calendar.gif" alt="" isshow="0">--%>
                            <div>
                                <input type="text" id="searchYmd" name="searchYmd" class="date2 bbit-dp-input lg w-full" maxlength="8" autocomplete="off" placeholder="퇴직일을 선택해주세요">
                            </div>
                            <div class="input_error_msg txt_body_small">
                                <i class="mdi-ico">error</i>
                                <span>올바른 형식으로 입력해주세요.</span>
                            </div>
                        </div>
                        <button type="button" class="btn lg primary" onclick="doAction1('Proc');">
                            <i class="mdi-ico mr-4">table_view</i>
                            예상 퇴직금 계산하기
                        </button>
                        <!-- 버튼 클릭 시 해당 프로그레스 바 노출, .progress_bar 의 width 값 변경 -->
                        <div class="card shadow cal_card" id="progressBar" style="display: none">
                            <div class="progress mb-16">
                                <div class="progress_bar bg_primary" style="width: 55%"></div>
                            </div>
                            <p class="txt_body_m txt_secondary">
                                <i class="mdi-ico">table_view</i> 퇴직금 예상금액 계산중...
                            </p>
                        </div>
                    </div>

                </form>
                <!-- 계산 완료 시 아래 div로 교체 -->
                <div id="resultCard" style="display:none;">
                    <div class="card rounded-16 pa-32 mb-20">
                        <p class="txt_title_xs sb mb-20 txt_left">근속정보</p>
                        <div class="d-grid grid-cols-6 gap-24">
                            <div class="card bg-white rounded-16 pa-12">
                                <div class="d-flex flex-col align-center gap-4">
                                    <span class="txt_body_m txt_secondary">입사일</span>
                                    <span class="txt_title_xs sb" id="empYmd"></span>
                                </div>
                            </div>
                            <div class="card bg-white rounded-16 pa-12">
                                <div class="d-flex flex-col align-center gap-4">
                                    <span class="txt_body_m txt_secondary">최종 중간 정산일</span>
                                    <span class="txt_title_xs sb" id="rmidYmd"></span>
                                </div>
                            </div>
                            <div class="card bg-white rounded-16 pa-12">
                                <div class="d-flex flex-col align-center gap-4">
                                    <span class="txt_body_m txt_secondary">기산 시작일</span>
                                    <span class="txt_title_xs sb" id="sepSymd"></span>
                                </div>
                            </div>
                            <div class="card bg-white rounded-16 pa-12">
                                <div class="d-flex flex-col align-center gap-4">
                                    <span class="txt_body_m txt_secondary">기산 종료일</span>
                                    <span class="txt_title_xs sb" id="sepEymd"></span>
                                </div>
                            </div>
                            <div class="card bg-white rounded-16 pa-12">
                                <div class="d-flex flex-col align-center gap-4">
                                    <span class="txt_body_m txt_secondary">근속 기간</span>
                                    <span class="txt_title_xs sb" id="wkpDCnt"></span>
                                </div>
                            </div>
                            <div class="card bg-white rounded-16 pa-12">
                                <div class="d-flex flex-col align-center gap-4">
                                    <span class="txt_body_m txt_secondary">근속 일 수</span>
                                    <span class="txt_title_xs sb" id="wkpAllDCnt"></span>
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="card rounded-16 pa-32 mb-20">
                        <p class="txt_title_xs sb mb-20 txt_left">퇴직소득</p>
                        <div class="d-grid grid-cols-2 gap-24">
                            <div class="card bg-white rounded-12 pa-24">
                                <div class="d-flex align-center gap-20 mb-20">
                                    <i class="icon bag_won size-48"></i>
                                    <div>
                                        <p class="txt_title_sm txt_secondary mb-4">일 평균 임금</p>
                                        <p class="txt_title_sm sb" id="avgMon"></p>
                                    </div>
                                </div>
                                <div class="card pa-4-16 txt_body_sm txt_secondary" id="sepRule"></div>
                            </div>
                            <div class="card bg-white rounded-12 pa-24">
                                <div class="d-flex align-center gap-20 mb-20">
                                    <i class="icon gift size-48"></i>
                                    <div>
                                        <p class="txt_title_sm txt_secondary mb-4">퇴직소득</p>
                                        <p class="txt_title_sm sb" id="earningMon"></p>
                                    </div>
                                </div>
                                <div class="card pa-4-16 txt_body_sm txt_secondary" id="eSepRule"></div>
                            </div>
                        </div>
                    </div>

                    <div class="d-flex justify-center">
                        <button type="button" class="btn lg ma-auto" onclick="setEmpPage()">
                            <i class="mdi-ico mr-4">refresh</i>
                           	예상 퇴직금 계산하기
                        </button>
                    </div>
                </div>
            </div>
        </div>
	</div>
</body>
</html>
