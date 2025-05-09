<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html>
<html class="hidden">
<head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <title>개인근무유형 상세</title>
<%--    <script type="text/javascript" src="/assets/plugins/slick-1.8.1/slick.min.js"></script>--%>

    <!-- 개별 화면 script -->
    <script type="text/javascript">
        var wtmShiftSchMgrChipLayer = {
            modalId: 'wtmShiftSchMgrChipLayer',
            existsChips: [],
            init: async function() {
                const chipList = await this.getChipList();
                this.setChipList(chipList);

                this.addEvent();
            },
            $getChipLayerList: function() {
                return $('.att-type-list');
            },
            getChipList: async function() {
                const data = await callFetch("${ctx}/WtmShiftSchMgr.do?cmd=getWorkScheduleList", "workClassCd=" + $("#searchWorkClassCd").val());
                if (data.isError) {
                    alert(data.errMsg);
                    return null;
                }

                return data.DATA;
            },
            setChipList: function(chipList) {
                $(".type-title .cnt").text(chipList.length);

                for (const chip of chipList) {
                    // 이미 부모창에 존재하는 chip 은 제외하고 표시.
                    const isExistsChip = wtmShiftSchMgrChipLayer.existsChips.filter(eChip => eChip.workSchCd === chip.workSchCd).length > 0;
                    if (isExistsChip) continue;

                    this.$getChipLayerList().append(this.getChipHtml());
                    const $last = this.$getChipLayerList().children().last();
                    $last.attr("title", chip.workSchNm);
                    $last.find('.text').text(chip.workSchSrtNm);
                    $last.find('.attend-chip').addClass(chip.color);
                    $last.find('.attend-chip').data("workSchCd", chip.workSchCd);
                    $last.find('.attend-chip').data("color", chip.color);
                    $last.on("click", function() {
                        wtmShiftSchMgrChipLayer.$getChipLayerList().children().removeClass("selected");
                        $(this).addClass("selected");
                    })
                }
            },
            getChipHtml: function() {
                return `<li>
                            <div class="attend-chip sch">
                                <span class="text ellipsis"></span>
                            </div>
                        </li>`;
            },
            addEvent: function() {
                $("#btnClose").on("click", function() {
                    const modal = window.top.document.LayerModalUtility.getModal(wtmShiftSchMgrChipLayer.modalId);
                    modal.hide();
                })

                $("#btnComplete").on("click", function() {
                    const modal = window.top.document.LayerModalUtility.getModal(wtmShiftSchMgrChipLayer.modalId);
                    const $selectedLi = wtmShiftSchMgrChipLayer.$getChipLayerList().children(".selected");
                    const obj = {
                        workSchCd: $selectedLi.find(".attend-chip").data("workSchCd"),
                        workSchSrtNm: $selectedLi.find(".text").text(),
                        color: $selectedLi.find(".attend-chip").data("color")
                    }
                    modal.fire('wtmShiftSchMgrChipLayerTrigger', obj).hide();
                })
            }
        };

        $(function() {
            const modal = window.top.document.LayerModalUtility.getModal(wtmShiftSchMgrChipLayer.modalId);
            const args = modal.parameters;
            $("#searchWorkClassCd").val(args.workClassCd);
            wtmShiftSchMgrChipLayer.existsChips = args.chips;

            wtmShiftSchMgrChipLayer.init();
        })
    </script>
</head>
<body>
    <div class="wrapper modal_layer">
        <div class="modal_body att-type">
            <input type="hidden" id="searchWorkClassCd" name="searchWorkClassCd"/>
            <p class="type-title">전체 근무유형<span class="cnt"></span><span class="unit">개</span></p>
            <div class="type-box mt-8">
                <p class="type-desc"><span class="req"></span>근무유형 항목을 선택해주세요.</p>
                <ul class="att-type-list mt-12">
                </ul>
            </div>
        </div>
        <div class="modal_footer">
            <a id="btnClose" href="#" class="btn outline_gray">닫기</a>
            <a id="btnComplete" href="#" class="btn filled">선택완료</a>
        </div>
    </div>
</body>
</html>