<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html>
<html class="hidden">
<head><title>임직원 거주지 조회</title>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

    <!-- Custom Theme Style -->
    <link href="${ ctx }/common/css/cmpEmp/custom.min.css" rel="stylesheet">
    <link href="${ ctx }/common/css/cmpEmp/isu_dashboard.css" rel="stylesheet">

    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp" %>
    <script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchart.js" type="text/javascript"></script>
    <script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchartinfo.js" type="text/javascript"></script>
    <script src="${ctx}/common/plugin/D3/d3.min.js" type="text/javascript"></script>
    <script type="text/javascript"
            src="//dapi.kakao.com/v2/maps/sdk.js?appkey=645ce29c983df95fdd72d9be1902574b&libraries=services"></script>

    <link rel="stylesheet" type="text/css" href="${ ctx }/common/plugin/Blueprints/css/component.css"/>
    <script type="text/javascript">

        var map = "";
        var geocoder = "";
        var imageSrc = "https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png";
        var targetMarkerImage = "";
        var markers = [];
        var positions = {};
        var targetMarker = {};
        var polyline = {};
        var customOverlay = {};
        var distanceContent = "";

        $(function () {

            progressBar(true);

            $("#searchName").bind("keyup", function (event) {
                if (event.keyCode == 13) {
                    showEmpList();
                    showMarker();
                }
            });

            $("#searchOrgCd").change(function () {
                console.log('searchOrgCd', $("#searchOrgCd").val());
                showEmpList();
                showMarker();
            });

            setOrgCombo();
            $("#searchOrgCd").val("${ssnOrgCd}");

            $(window).smartresize(boxResize);
            boxResize();

            $("#searchOrgCd").change();
            progressBar(false) ;
            showMap();
            map.relayout();

        });

        //조직콤보
        function setOrgCombo() {
            var all = "";
            if ("${ ssnSearchType }" != "A") {
                all = "전체";
            }

            var orgCd = convCode(ajaxCall("${ctx}/PsnlTimeCalendar.do?cmd=getPsnlTimeCalendarOrgList", "searchYmd=" + $("#searchYmd").val(), false).DATA, all);
            $("#searchOrgCd").html(orgCd[2]);
        }

        // 박스 리사이즈
        function boxResize() {
            var outer_height = getOuterHeight();
            var inner_height = 0;
            var value = 0;
            var box = $("#timelineBox, #timelineBox .list_box");

            inner_height = getInnerHeight(box);
            value = ($(window).height() - outer_height) - inner_height - 60;
            if (value < 100) value = 100;
            box.height(value);
            box.css({
                "max-height": value + "px"
            })
            //alert("window : " + $(window).height() + ", inner_height : " + inner_height + " , outer_height : " + outer_height + ", value : " + value);

            clearTimeout(timeout);
            timeout = setTimeout(addTimeOut, 50);
        }

        // 발령내역 자세히 보기
        function showEmpList() {
            try {
                progressBar(true);
                var html = "";

                $("#detailList").html("");
                var data = ajaxCall("${ctx}/EmpTimelineSrch.do?cmd=getEmpTimelineSrchEmpList", $("#empForm").serialize(), false);
                console.log('show Emp List......',{data});

                var item = null;
                if (data != null && data != undefined && data.DATA != null && data.DATA != undefined) {
                    for (var i = 0; i < data.DATA.length; i++) {
                        item = data.DATA[i];

                        html += "<div class=\'tile-stats card-profile\' sabun='" + item.sabun + "' onclick=\"javascript:showEmpDetailContents('" + item.sabun + "');\">";
                        html += "  <div class=\'profile_img \'>";
                        html += "    <img src=\'/common/images/common/img_photo.gif\'  id='photo" + i + "\' alt=\'Avatar\' title=\'Change the avatar\'>";
                        html += "  </div>";
                        html += "  <div class=\'profile_info\'>";
                        html += "    <p class=\'name\' id=\'tdName" + i + "\'>";
                        html += "      <span class=\'gender\'>(<i class=\'fa fa-male\'></i> 남성)</span>";
                        html += "    </p>";
                        html += "   <ul class=\'profile_desc\'>";
                        html += "      <li id=\'tdSabun" + i + "\'></li>";
                        //html += "      <li id=\'tdEmpYmd"+i+"\'></li>";
                        html += "      <li id=\'tdJikweeNm" + i + "\'></li>";
                        html += "      <li id=\'tdJikchakNm" + i + "\'></li>";
                        html += "      <li id=\'tdOrgNm" + i + "\' class=\'full\'></li>";
                        html += "    </ul>";
                        html += "  </div>";
                        html += "</div>";
                    }
                }

                $("#detailList").html(html);

                /* 데이터 세팅 */
                if (data != null && data != undefined && data.DATA != null && data.DATA != undefined) {
                    for (var i = 0; i < data.DATA.length; i++) {
                        item = data.DATA[i];

                        setImgFile(item.sabun, i);
                        $("#tdSabun" + i).html("사번 : " + item.sabun);
                        $("#tdName" + i).html(item.name);
                        $("#tdOrgNm" + i).html("소속 : " + item.orgNm);
                        //$("#tdEmpYmd"+i).html("입사일 : " + item.empYmd) ;
                        $("#tdJikweeNm" + i).html("직위 : " + item.jikweeNm);
                        $("#tdJikgubNm" + i).html(item.jikgubNm);
                        $("#tdJikjongNm" + i).html("직종 : " + item.jikjongNm);
                        $("#tdJikchakNm" + i).html("직책 : " + item.jikchakNm);
                    }

                    if (data.DATA.length > 0) {
                        $(".card-profile").eq(0).trigger("click");
                    } else {
                        showEmpDetailContents('-1')
                    }
                }
            } catch (ex) {
                progressBar(false);
                alert("showEmpList Event Error : " + ex);
            }
            progressBar(false);
        }

        //사진파일 적용 by
        function setImgFile(sabun, i) {
            $("#photo" + i).attr("src", "${ctx}/EmpPhotoOut.do?searchKeyword=" + sabun);
        }

        // 선택 임직원의 상세 컨텐츠 출력
        function showEmpDetailContents(sabun) {
            $(".card-profile").each(function () {
                if ($(this).attr("sabun") == sabun) {
                    $(this).addClass("choose");
                } else {
                    $(this).removeClass("choose");
                }
            });

            showEmpTimeline(sabun);
            moveMap(sabun);
            getDistanceToTarget(sabun);

        }

        function showEmpTimeline(sabun) {
            var html = "";
            //$("#timelineBox ul.cbp_tmtimeline").html("");
            try {
                var data = ajaxCall("${ctx}/EmpTimelineSrch.do?cmd=getAppmtTimelineSrchTimelineList", $("#empForm").serialize() + "&searchSabun=" + sabun, false);
                //console.log('data', data);

                var item = null;
                if (data != null && data != undefined && data.DATA != null && data.DATA != undefined) {
                    for (var i = 0; i < data.DATA.length; i++) {
                        item = data.DATA[i];
                        html += "<li>";
                        html += "<time class=\"cbp_tmtime\" datetime=\"" + item.monthDay + "\"><span>" + item.year + "</span> <span>" + item.monthDay + "</span></time>";
                        html += "<div class=\"cbp_tmicon\"></div>";
                        html += "<div class=\"cbp_tmlabel\">";
                        html += "<p>" + item.timelineSummary + "</p>";
                        html += "</div>";
                        html += "</li>";
                    }
                }

                //if( html != "" ) {
                $("#timelineBox ul.cbp_tmtimeline").html(html);
                //}

                boxResize();

            } catch (ex) {
                alert("showEmpTimeline Event Error : " + ex);
            }
        }

        //목적지 검색 팝업
        function openZipCodePopup() {
            try {
                if (!isPopup()) {
                    return;
                }

                openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740", "620");

            } catch (ex) {
                alert("OpenPopup Event Error: " + ex);
            }
        }

        //팝업 결과(목적지) 세팅
        function getReturnValue(returnValue) {
            var rv = $.parseJSON('{' + returnValue + '}');

            $("#targetAddress").val(rv.doroAddr)
            $("#targetAddressTxt").val(rv.doroFullAddr);

            if (rv && rv.doroAddr) {

                eraseData("targetMarker");
                eraseData("path");

                geocoder = new kakao.maps.services.Geocoder();
                geocoder.addressSearch(rv.doroAddr, function (result, status) {
                    if (status === kakao.maps.services.Status.OK) {
                        var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                        targetMarker = new kakao.maps.Marker({
                            map: map,
                            position: coords,
                            image: targetMarkerImage
                        });
                        targetMarker.setMap(map);
                        map.panTo(new kakao.maps.LatLng(coords.Ma, coords.La));
                    }
                });
            }
        }

        //지도 생성
        function showMap() {
            var container = document.getElementById('map');
            var options = {
                center: new kakao.maps.LatLng(37.4979045, 126.9911091),
                level: 8,
            };

            map = new kakao.maps.Map(container, options);

            targetMarkerImage = new kakao.maps.MarkerImage(imageSrc, new kakao.maps.Size(24, 35));
        }

        //거주지 마커 표시
        function showMarker() {

            eraseData("marker");
            eraseData("path");

            //부서 직원들의 주소 정보 가져오기
            var data = ajaxCall("${ctx}/EmpAddressSrch.do?cmd=getEmpAddressSrchAddressList", $("#empForm").serialize(), false);

            //주소를 위도, 경도로 변환
            for (var i = 0; i < data.DATA.length; i++) {
                var item = data.DATA[i];
                getMarkerPosition(item)
                    .then(pos => {
                        var marker = new kakao.maps.Marker({
                            map: map,
                            position: pos.latlng,
                            title: pos.title,
                        });
                        markers.push(marker);
                    })
            }
            progressBar(false);
        }

        //비동기 작업 처리
        function getMarkerPosition(item) {
            geocoder = new kakao.maps.services.Geocoder();
            var pos = {};
            var coords = {};

            return new Promise((resolve, reject) => {
                if (item && item.addr1) {
                    geocoder.addressSearch(item.addr1.trim(), function (result, status) {

                        if (status === kakao.maps.services.Status.OK) {
                            coords = new kakao.maps.LatLng(result[0].y, result[0].x);
                            pos = {"title": item.name, "latlng": coords};
                            positions[item.sabun] = pos.latlng;

                            resolve(pos);
                        }
                    });
                }
            });
        }

        //선택한 임직원 주소로 지도 중앙 변경
        function moveMap(sabun) {
            if (positions && positions[sabun]) {
                var moveLatLon = new kakao.maps.LatLng(positions[sabun].Ma, positions[sabun].La);
                map.panTo(moveLatLon);
            }
        }

        //거주지-목적지 사이 거리 측정(Haversine fomula)
        function getDistanceToTarget(sabun) {
            if (positions && positions[sabun] && Object.keys(targetMarker).length > 0) {
                var startX = positions[sabun].Ma;							//거주지 위도
                var startY = positions[sabun].La;								//거주지 경도
                var endX = targetMarker.getPosition().getLat();			//목적지 위도
                var endY = targetMarker.getPosition().getLng();		//목적지 경도

                const radius = 6371;	//지구 반지름
                const toRadian = Math.PI / 180;

                var deltLat = Math.abs(startX - endX) * toRadian;
                var deltLng = Math.abs(startY - endY) * toRadian;

                var squareSinDeltLat = Math.pow(Math.sin(deltLat / 2), 2);
                var squareSinDeltLng = Math.pow(Math.sin(deltLng / 2), 2);

                var squareRoot = Math.sqrt(squareSinDeltLat + Math.cos(startX * toRadian) * Math.cos(endX * toRadian) * squareSinDeltLng)

                var distance = 2 * radius * Math.asin(squareRoot);

                drawPath(startX, startY, endX, endY, distance);
            }
        }

        //직선 경로, 거리 표시
        function drawPath(startX, startY, endX, endY, distance) {

            eraseData("path");

            //경로
            var linePath = [
                new kakao.maps.LatLng(startX, startY),
                new kakao.maps.LatLng(endX, endY)
            ];

            polyline = new kakao.maps.Polyline({
                path: linePath,
                strokeWeight: 3,
                strokeColor: '#ff295e',
                strokeOpacity: 0.7,
                strokeStyle: 'solid'
            });

            polyline.setMap(map);

            distanceContent = '<div class ="label" style="color:white; background-color: #ff2952; padding: 2px; font-weight:500; font-size:12px; border-radius: 10px; opacity: 0.8"><span class="left"></span><span class="center">'
                + Math.round(distance * 100) / 100 + ' km'
                + '</span><span class="right"></span></div>';

            customOverlay = new kakao.maps.CustomOverlay({
                position: new kakao.maps.LatLng(startX, startY),
                content: distanceContent,
                yAnchor: 2.1
            });

            customOverlay.setMap(map);
        }

        //search 조작 시 지도 정보 초기화
        function eraseData(type) {
            switch (type) {
                case "marker":
                    for (var i = 0; i < markers.length; i++) {
                        markers[i].setMap(null);
                    }
                    markers = [];
                    positions = {};
                    break;
                case "path":
                    if (Object.keys(polyline).length > 0) {
                        polyline.setMap(null);
                        customOverlay.setMap(null);
                        polyline = {};
                        customOverlay = {};
                    }
                    break;
                case "targetMarker":
                    if (Object.keys(targetMarker).length > 0) {
                        targetMarker.setMap(null);
                        targetMarker = {};
                    }
                    break;
            }
        }

    </script>
    <style type="text/css">
        .sheet_search, .cbp_tmtimeline * {
            box-sizing: initial;
        }

        #detailList {
            background-color: #f7f7f7;
            padding: 10px;
            border: 1px solid #ebeef3;
            overflow-x: hidden;
            overflow-y: auto;
            min-width: 240px;
        }

        .tile-stats.card-profile {
            padding: 15px;
            cursor: pointer;
        }

        .tile-stats.card-profile.choose {
            background-color: #efefef;
        }

        .tile-stats.card-profile .profile_info {
            width: calc(100% - 81px);
        }

        .tile-stats.card-profile .profile_info .profile_desc {
            width: 100%;
        }

        .tile-stats.card-profile .profile_info .profile_desc li.full {
            width: 100%;
        }

        .tile-stats.card-profile .profile_img img {
            width: 66px;
            height: 99px;
        }

        /* Timeline */
        .cbp_tmtimeline > li .cbp_tmtime span:first-child {
            font-size: 1em;
            line-height: 1em;
        }

        .cbp_tmtimeline > li .cbp_tmtime span:last-child {
            font-size: 1.5em;
            line-height: 1.5em;
        }

        .cbp_tmtimeline > li .cbp_tmicon {
            width: 10px;
            height: 10px;
            line-height: 10px;
            left: 20%;
            margin-left: -12px;
            box-shadow: 0 0 0 4px var(--bg_color_base);
        }

        .cbp_tmtimeline:before {
            width: 5px;
            left: 20%;
        }

        .cbp_tmtimeline > li .cbp_tmlabel {
            margin-right: 5%;
            padding: 1.2em;
        }

        @media screen and (-ms-high-contrast: active), (-ms-high-contrast: none) {
            .cbp_tmtimeline > li .cbp_tmtime {
                padding-right: 45px;
            }
        }

        /* Timeline */

        #map {
            height: 100%;
            width: 100%;
        }

    </style>
</head>
<body class="bodywrap" style="background-color:#fff;">
<div class="wrapper">

    <form id="empForm" name="empForm">
        <input type="hidden" id="searchYmd" name="searchYmd" value="${ curSysYyyyMMdd }"/>
        <div class="sheet_search outer">
            <div>
                <table>
                    <colgroup>
                        <col width="30%"/>
                        <col width="30%"/>
                        <col width="*"/>
                    </colgroup>
                    <tr>
                        <td><span>부서</span>
                            <select id="searchOrgCd" name="searchOrgCd"></select>
                        </td>
                        <td>
                            <span><tit:txt mid='104330' mdef='사번/성명'/></span>
                            <input type="text" id="searchName" name="searchName" class="text"/>
                        </td>
                        <td>
                            <btn:a href="javascript:showEmpList();" css="button" mid='110697' mdef="조회"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="3">
                            <span>목적지</span>
                            <input type="hidden" id="targetAddress" name="targetAddress"/>
                            <input value="도로명주소로 검색" type="text" id="targetAddressTxt" name="targetAddressTxt"
                                   onclick="openZipCodePopup()" size=80/>
                        </td>
                    </tr>
                </table>
            </div>
        </div>
    </form>

    <table id="timelineBox" border="0" cellspacing="0" cellpadding="0" class="sheet_main">
        <colgroup>
            <col width="24%"/>
            <col width="24%"/>
            <col width="*"/>
        </colgroup>
        <tr>
            <td>
                <div class="sheet_title">
                    <ul>
                        <li class="txt">임직원</li>
                        <li class="btn"></li>
                    </ul>
                </div>
                <div id="detailList" class="list_box">
                </div>
            </td>
            <td>
                <div class="sheet_title mal10">
                    <ul>
                        <li class="txt">Timeline</li>
                        <li class="btn"></li>
                    </ul>
                </div>
                <div class="list_box mal10" style="border:1px solid #ebeef3; overflow-y:auto;">
                    <ul class="cbp_tmtimeline"></ul>
                </div>
            </td>
            <td>
                <div class="sheet_title mal10">
                    <ul>
                        <li class="txt">거주지</li>
                    </ul>
                </div>
                <div class="list_box mal10" style="border:1px solid #ebeef3; overflow-y:auto; padding:10px;">
                    <div id="map"></div>
                </div>
            </td>
        </tr>
    </table>
</div>
</body>
</html>
