<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
    <title></title>
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
    <link rel="stylesheet" type="text/css" href="/assets/css/welfare_psnm.css"/>
    <script src="${ctx}/assets/plugins/lottie-web-5.7.14/lottie.min.js"></script>
    <script>
        $(function () {
            const widgetsData = [
                {
                    category: "균형있는 삶",
                    color: "red",
                    items: [
                        { id:"clock", title: "휴가", sub: "(연차/반차/반반차)", imgUrl:"clock.json" , desc: "신체적 피로를 회복하고 여가 및 문화활동에 기여하는 제도", dialogdesc: "구성원에게 근로 의무를 면제하여 신체적 피로를 회복하고 여가 및 문화활동에 기여하는 제도입니다. ", iframeSrc:"${ctx}/list09.do?cmd=viewRed01" },
                        { id:"crown", title: "장기근속휴가", imgUrl:"crown.json" , desc: "회사에 지속적으로 근속(근무)했을 때 이를 보상하거나 격려하기 위해 제공되는 휴가 제도", dialogdesc:"회사에 지속적으로 근속(근무)했을 때, 이를 보상하거나 격려하기 위해 제공되는 휴가 제도를 말합니다.", iframeSrc:"${ctx}/list09.do?cmd=viewRed02" },
                        { id:"heart1", title: "가족돌봄 휴가", imgUrl:"heart.json" , desc: "가족이 질병, 사고, 노령으로 인해 돌봄이 필요한 경우에 사용할 수 있는 휴가 제도", dialogdesc:"가족(부모, 자녀, 배우자, 배우자의 부모)이 질병, 사고, 노령으로 인해 돌봄이 필요한 경우에 사용할 수 있는 휴가 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewRed03" },
                        { id:"idea", title: "가족돌봄 휴직", imgUrl:"idea.json" , desc: "가족이 질병, 사고, 노령으로 인해 돌봄이 필요한 경우에 사용할 수 있는 휴직 제도",dialogdesc:"가족(부모, 자녀, 배우자, 배우자의 부모)이 질병, 사고, 노령으로 인해 돌봄이 필요한 경우에 사용할 수 있는 휴직 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewRed04" },
                        { id:"mountain", title: "가족돌봄 근로시간 단축", imgUrl:"mountain.json" , desc: "가족이 질병, 사고, 노령으로 인해 돌봄이 필요한 경우에 사용할 수 있는 휴직 제도", dialogdesc: "가족(부모, 자녀, 배우자, 배우자의 부모)이 질병, 사고, 노령으로 인해 돌봄이 필요한 경우에 사용할 수 있는 근로시간 단축 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewRed05"},
                        { id:"bookmark", title: "보건휴가", imgUrl:"bookmark.json" , desc: "생리중인 여성구성원의 신체적/정신적 건강을 보호하기 위하여 사용할 수 있는 휴가",dialogdesc:"생리중인 여성구성원의 신체적 / 정신적 건강을 보호하기 위하여 사용할 수 있는 휴가입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewRed06" },
                        { id:"plant", title: "콘도 및 리조트", imgUrl:"plant.json" , desc: "구성원들의 Refresh 및 저렴한 비용으로 콘도를 이용할 수 있도록 지원하는 제도", dialogdesc:"구성원들의 Refresh 및 저렴한 비용으로 콘도를 이용할 수 있도록 지원하는 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewRed07" },
                        { id:"love-chat", title: "사내 동호회", imgUrl:"love-chat.json" , desc: "취미 활동, 스포츠, 문화 활동 등을 공유하고 즐길 수 있도록 지원하는 제도",dialogdesc:"구성원들이 자발적으로 참여하여 취미 활동, 스포츠, 문화 활동 등을 공유하고 즐길 수 있도록 하여 구성원 간의 소통을 촉진하고, 조직 내에서 협력과 친목을 도모하는 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewRed08" },
                        { id:"coffee-cup", title: "카페테리아", imgUrl:"coffee-cup.json" , desc: "구성원들이 식사와 음료를 편리하게 해결할 수 있도록 제공되는 공간",dialogdesc:"마포T타운 내 구성원들이 식사와 음료를 편리하게 해결할 수 있도록 제공되는 공간이며, 편의성과 원활한 소통을 위해 제공됩니다.", iframeSrc:"${ctx}/list09.do?cmd=viewRed09"  },
                    ],
                },
                {
                    category: "건강한 삶",
                    color: "blue",
                    items: [
                        { id:"thumbs-up", title: "건강검진", imgUrl:"thumbs-up.json" , desc: "구성원과 가족의 건강 상태 확인과 질병의 예방 및 조기 발견을 목적으로한 복리후생제도", dialogdesc:"구성원과 가족의 건강 상태 확인과 질병의 예방 및 조기 발견을 목적으로한 복리후생제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewBlue01" },
                        { id:"chatting", title: "심리상담 서비스", imgUrl:"chatting.json" , desc: "일과 삶의 불균형을 해소하고 업무만족도를 높일 수 있는 전문 상담서비스를 제공", dialogdesc:"직장 내 문제 뿐만 아니라 구성원의 심리/정서에 영향을 주는 스트레스, 개인적인 인간관계, 부부/자녀 문제 등 다양한 고민에 도움을 줌으로써 일과 삶의 불균형을 해소하고 업무만족도를 높일 수 있는 전문 상담서비스를 제공합니다.", iframeSrc:"${ctx}/list09.do?cmd=viewBlue02" },
                        { id:"piggy-bank", title: "단체(상해/질병)보험", imgUrl:"piggy-bank.json" , desc: "다양한 보험혜택을 제공해 구성원의 신체적/경제적 안정을 도모하고자 하는 제도", dialogdesc: "회사가 구성원의 다양한 보험혜택을 제공해 구성원의 신체적 / 경제적 안정을 도모하고자 하는 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewBlue03" },
                        { id:"alarm", title: "병가", imgUrl:"alarm.json" , desc: "질병이나 부상으로 인해 정상적으로 업무를 수행할 수 없는 경우 휴가를 부여받는 제도", dialogdesc:"구성원이 질병이나 부상으로 인해 정상적으로 업무를 수행할 수 없는 경우, 치료와 회복을 목적으로 일정 기간 동안 휴가를 부여받는 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewBlue04" },
                        { id:"presentation-board", title: "사사휴직", imgUrl:"presentation-board.json" , desc: "질병이나 부상으로 인해 정상적으로 업무를 수행할 수 없는 경우 휴가를 부여받는 제도", dialogdesc:"구성원이 질병이나 부상으로 인해 정상적으로 업무를 수행할 수 없는 경우, 치료와 회복을 목적으로 일정 기간 동안 휴가를 부여받는 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewBlue05" },
                        { id:"notepad", title: "유사산휴가", imgUrl:"notepad.json" , desc: "임신 중인 구성원이 유산 또는 사산한 경우 사용할 수 있는 휴가", dialogdesc:"임신 중인 구성원이 유산 또는 사산한 경우 사용할 수 있는 휴가입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewBlue06" },
                        { id:"heart2", title: "난임치료 휴가", imgUrl:"heart.json" , desc: "체외 수정, 인공수정 등 난임 치료를 위해 사용할 수 있는 휴가", dialogdesc:"체외 수정, 인공수정 등 난임 치료를 위해 사용할 수 있는 휴가입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewBlue07" },
                        { id:"dumbbell", title: "사내헬스장(actium)", imgUrl:"dumbbell.json" , desc: "구성원들의 건강 증진과 복리후생을 위해 사내에 헬스장을 설치하고 운영하는 공간", dialogdesc:"구성원들의 건강 증진과 복리후생을 위해 사내에 헬스장을 설치하고 운영하는 공간입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewBlue08" },
                    ],
                },
                {
                    category: "함께하는 삶",
                    color: "yellow",
                    items: [
                        { id:"time-table", title: "산전 후 휴가", imgUrl:"time-table.json" , desc: "임신과 출산을 한 여성 구성원의 건강을 보호하고, 출산 전후로 충분히 휴식을 취할 수 있도록 제공", dialogdesc:"임신과 출산을 한 여성 구성원의 건강을 보호하고, 출산 전후로 충분히 휴식을 취할 수 있도록 제공되는 휴가입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewYellow01" },
                        { id:"team", title: "육아휴직", imgUrl:"team.json" , desc: "자녀의 양육을 위해 일정기간 동안 휴직할 수 있는 제도", dialogdesc:"자녀의 양육을 위해 일정기간 동안 휴직할 수 있는 제도를 의미합니다.", iframeSrc:"${ctx}/list09.do?cmd=viewYellow02" },
                        { id:"calendar", title: "배우자 출산휴가", imgUrl:"calendar.json" , desc: "구성원의 배우자가 출산한 경우 사용가능하며, 남성 구성원에 한하여 사용할 수 있는 휴가", dialogdesc:"구성원의 배우자가 출산한 경우 사용가능하며, 남성 구성원에 한하여 사용할 수 있는 휴가입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewYellow03" },
                        { id:"search", title: "태아검진휴가", imgUrl:"search.json" , desc: "임신한 여성 구성원이 임산부 정기건강진단을 받기 위한 경우", dialogdesc:"임신한 여성 구성원이 임산부 정기건강진단을 받기 위한 경우 사용가능한 휴가입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewYellow04" },
                        { id:"time", title: "임신기 근로기간 단축", imgUrl:"time.json" , desc: "임신 12주 이내 또는 36주 이후의 근로자가 일일 2시간의 근로시간을 단축할 수 있는 제도", dialogdesc:"임신 12주 이내 또는 36주 이후의 근로자가 일일 2시간의 근로시간을 단축할 수 있는 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewYellow05" },
                        { id:"setting", title: "육아기 근로시간 단축", imgUrl:"setting.json" , desc: "영유아 양육을 위하여 근로시간을 단축해 출산 후 회복 및 자녀를 양육할 수 있도록 돕는 제도", dialogdesc:"구성원의 영유아 양육을 위하여 근로시간을 단축해 출산 후 회복 및 자녀를 양육할 수 있도록 돕는 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewYellow06" },
                        { id:"location-pin", title: "(행복타운) 어린이집", imgUrl:"location-pin.json" , desc: "구성원의 아이들이 바른 인성을 가진 어린이로 성장 할 수 있도록 지원하는 제도", dialogdesc:"우리 회사는 구성원의 아이들이 바른 인성을 가진 어린이로 성장 할 수 있도록 직장어린이집을 운영하고 있습니다.", iframeSrc:"${ctx}/list09.do?cmd=viewYellow07" },
                        { id:"shopping-bag", title: "자녀출산 축하선물", imgUrl:"shopping-bag.json" , desc: "자녀를 출산한 구성원을 축하하고, 육아에 필요한 물품을 지원하는 제도", dialogdesc:"자녀를 출산한 구성원을 축하하고, 육아에 필요한 물품을 지원하는 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewYellow08" },
                    ],
                },
                {
                    category: "풍요로운 삶",
                    color: "olive",
                    items: [
                        { id:"file-folder", title: "경조금 / 경조휴가", imgUrl:"file-folder.json" , desc: "구성원 본인이나 구성원 가족의 경조 발생시 회사가 지원하는 금전적 혜택 및 휴가를 의미", dialogdesc:"구성원 본인이나 구성원 가족의 경조 (결혼, 출산, 장례 등) 발생시 회사가 지원하는 금전적 혜택 및 휴가를 의미합니다.", iframeSrc:"${ctx}/list09.do?cmd=viewOlive01" },
                        { id:"smiley-emoji", title: "베네피아" , sub: "(선택적 복리후생비)", imgUrl:"smiley-emoji.json" , desc: "일정 금액의 복리후생 포인트를 제공", dialogdesc:"일정 금액의 복리후생 포인트를 제공하고, 구성원 본인의 필요와 선호에 따라 다양한 복리후생 항목 중 원하는 서비스를 선택해 이용할 수 있도록 하는 제도를 의미합니다.", iframeSrc:"${ctx}/list09.do?cmd=viewOlive02" },
                        { id:"mobile", title: "통신비 지원", imgUrl:"mobile.json" , desc: "구성원의 업무상 발생하는 통신비 지원을 통한 요금부담을 경감하는 제도", dialogdesc:"구성원의 업무상 발생하는 통신비 지원을 통한 요금부담을 경감하는 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewOlive03" },
                        { id:"bitcoin", title: "SKT 멤버십", imgUrl:"bitcoin.json" , desc: "SKT 멤버십", dialogdesc:"SKT 통신사를 사용하는 구성원에게 보다 높은 제휴 할인 및 적립 혜택을 드리는 복리후생 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewOlive04" },
                        { id:"dollar-coin", title: "사내대출", imgUrl:"dollar-coin.json" , desc: "구성원을 위해 저금리로 생활자금을 최소 100만원에서 최대 3,000만원까지 대여하는 제도", dialogdesc:"구성원을 위해 저금리로 생활자금을 최소 100만원에서 최대 3,000만원까지 대여하는 제도입니다.", iframeSrc:"${ctx}/list09.do?cmd=viewOlive05" },
                        { id:"gift-box", title: "명절선물", imgUrl:"gift-box.json" , desc: "구성원에게 노력과 기여에 대한 감사를 표현하는 방법으로, 설 및 추석에 SKT에서 명절선물을 지급", dialogdesc:"구성원에게 노력과 기여에 대한 감사를 표현하는 방법으로, 설 및 추석에 SKT에서 명절선물을 지급합니다.", iframeSrc:"${ctx}/list09.do?cmd=viewOlive06" },
                    ],
                },
            ];

            // 실행
            renderWidgets(widgetsData);
        })

        // 위젯 그리기
        function renderWidgets(data) {
            const container = document.querySelector(".main_tab_content");
            const dialogBox = document.getElementById("dialogBox");
            const breadcrumb = document.getElementById("breadcrumb");
            const dialogTitle = document.getElementById("dialog-title");
            const dialogDesc = document.getElementById("dialog-desc");
            const dialogImage = document.getElementById("dialog-img");
            const dialogBody = document.getElementById("dialog-body");
            // const closeDialog = document.getElementById("closeDialog");

            // 모달 열기 함수
            function openDialog(category, title, desc, sub, imgUrl , iframeSrc, id) {
                // Breadcrumb 업데이트
                breadcrumb.innerHTML = `${'${category}'} > <span>${'${title}'} ${'${sub ? ` ${sub}` : ""}'}</span>`;
                dialogTitle.textContent = title;
                dialogDesc.textContent = desc;

                // Lottie 애니메이션 렌더링
                if (imgUrl) {
                    // 기존 컨텐츠 초기화
                    dialogImage.innerHTML = `<div id="lottie-${'${id}'}" style="width: 80px; height: 80px;"></div>`;
                    lottie.loadAnimation({
                        container: document.getElementById(`lottie-${'${id}'}`), // ID로 컨테이너 찾기
                        renderer: 'svg',
                        loop: true,
                        autoplay: true,
                        path: getLottiePath(imgUrl),
                    });
                } else {
                    dialogImage.innerHTML = "애니메이션을 로드할 수 없습니다.";
                }

                // iframe 업데이트
                if (iframeSrc) {
                    dialogBody.innerHTML = `<iframe src="${'${iframeSrc}'}" frameborder="0" style="width: 100%; height: 320px;" allowfullscreen></iframe>`;
                } else {
                    dialogBody.innerHTML = "해당 콘텐츠를 로드할 수 없습니다.";
                }

                // 모달 보이기
                dialogBox.style.display = "block";
            }

            // 모달 닫기 함수
            function closeDialogHandler() {
                dialogBox.style.display = "none";
            }

            // 닫기 버튼 클릭 이벤트
            // closeDialog.addEventListener("click", closeDialogHandler);

            // 배경 클릭 이벤트
            window.addEventListener("click", (event) => {
                if (event.target === dialogBox) {
                    closeDialogHandler();
                }
            });

            // Lottie 애니메이션 경로 생성 함수 추가
            function getLottiePath(filename) {
                // 여기에 Lottie 파일의 기본 경로 추가
                return `/common/images/widget/psnm/lottie/${'${filename}'}`;
            }

            data.forEach((category) => {
                // 카테고리 헤더
                const categoryHeader = document.createElement("div");
                categoryHeader.className = "widget_container bg-white";
                categoryHeader.innerHTML = `<div class="widget-title color-${'${category.color}'}">${'${category.category}'}</div>`;
                container.appendChild(categoryHeader);

                // 위젯 목록
                const widgetWrap = document.createElement("div");
                widgetWrap.className = "widget_container wel-widget-wrap";

                category.items.forEach((item) => {
                    const widget = document.createElement("div");
                    widget.className = "wel-widget";

                    const lottieHtml = `<div class="img-wrap" id="lottie-${'${item.id}'}"></div>`;

                    widget.innerHTML = `
           			  <div class="chip-wrap">
           			    <span class="chip color-${'${category.color}'}">${'${category.category}'}</span>
           			  </div>
           			  ${'${lottieHtml}'}
           			  <div class="title">
           			    ${'${item.title}'}${'${item.sub ? `<span class="sub">${item.sub}</span>` : ""}'}
           			  </div>
           			  <div class="desc">${'${item.desc}'}</div>
           			`;

                    lottie.loadAnimation({
                        container: document.getElementById(`lottie-${'${item.id}'}`),
                        renderer: 'svg',
                        loop: true,
                        autoplay: true,
                        path: getLottiePath(item.imgUrl), // 여기서 전체 경로 생성
                    });

                    widget.addEventListener("click", () => {
                        openDialog(category.category, item.title, item.dialogdesc, item.sub, item.imgUrl, item.iframeSrc, getLottiePath(item.imgUrl),);
                    });

                    setTimeout(() => {
                        lottie.loadAnimation({
                            container: document.getElementById(`lottie-${'${item.id}'}`),
                            renderer: "svg",
                            loop: true,
                            autoplay: true,
                            path: getLottiePath(item.imgUrl),
                        });
                    }, 0);

                    widgetWrap.appendChild(widget);
                });

                container.appendChild(widgetWrap);
            });
        }
    </script>
<body class="iframe_content">
<div class="main_tab_content sub_menu_container">
    <div class="header">
        <div class="title_wrap">
            <i class="mdi-ico filled">volunteer_activism</i>
            <span>복리후생</span>
        </div>
    </div>
</div>
<!-- 모달 구조 -->
<div id="dialogBox" class="dialog-box">
    <div class="dialog-content">
        <div id="breadcrumb" class="breadcrumb"></div>
        <!-- <span id="closeDialog" class="close">&times;</span> -->
        <div class="dialog-header">
            <div class="img-wrap" id="dialog-img"></div>
            <div class="inner-wrap">
                <div id="dialog-title" class="dialog-title"></div>
                <div id="dialog-desc" class="dialog-desc"></div>
            </div>
        </div>
        <div class="dialog-body" id="dialog-body"></div>
    </div>
</div>
</body>
</html>