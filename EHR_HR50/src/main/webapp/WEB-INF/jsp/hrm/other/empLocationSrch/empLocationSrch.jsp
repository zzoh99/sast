<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<!DOCTYPE html>
<html>
<head><title>임직원 Location 현황</title>
    <%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
    <!-- Custom Theme Style -->
    <link href="${ ctx }/common/css/cmpEmp/custom.min.css" rel="stylesheet">
    <link href="${ ctx }/common/css/cmpEmp/isu_dashboard.css" rel="stylesheet">
    <%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp" %>
    <%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp" %>
    <script src="${ctx}/common/plugin/D3/d3.min.js" type="text/javascript"></script>
    <script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=645ce29c983df95fdd72d9be1902574b&libraries=services,clusterer"></script>
    <link rel="stylesheet" type="text/css" href="${ ctx }/common/plugin/Blueprints/css/component.css"/>
    <script type="text/javascript">
        var map = {};
        var clusterer = {};
        var markers = [];

        $(function() {

            setLocationCombo();

            $("#searchDate").datepicker2({
               onReturn:function(date) {
                   doAction1("Search");
               }
            });

            $("#searchDate").bind("keydown", function(event) {
                if(event.keyCode == 13) {
                    doAction1("Search");
                    $(this).focus();
                }
            });

            $("#searchLocCd").bind("change", function() {
                doAction1("Search");
            })

            showMap();
            map.relayout();
            makeClusterer();
            setMapData();

            init_sheet1();
            $(window).smartresize(sheetResize); sheetInit();

            doAction1("Search");

        });

        //Location 콤보
        function setLocationCombo() {
            var locCd = convCode(ajaxCall("${ctx}/EmpLocationSrch.do?cmd=getLocationCdNm", "searchDate=" + $("#searchDate").val(), false).DATA, "");
            $("#searchLocCd").html(locCd[2]);
        }

        //Location별 인원
        function init_sheet1() {
            var initdata1 = {};
            initdata1.Cfg = {SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly, FrozenCol:4};
            initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

            initdata1.Cols = [
                {Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
                {Header:"부서",				Type:"Text",	Hidden:0,	Width:"120",	Align:"Center",	ColMerge:0,	SaveName:"orgNm"},
                {Header:"사번",				Type:"Text",	Hidden:0,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
                {Header:"성명",				Type:"Text",	Hidden:0,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"name"},
                {Header:"직급",				Type:"Text",	Hidden:0,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm"},
                {Header:"직위",				Type:"Text",	Hidden:0,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm"},
                {Header:"직책",				Type:"Text",	Hidden:0,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm"},
                {Header:"직군",				Type:"Text",	Hidden:0,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm"},
                {Header:"사원구분",				Type:"Text",	Hidden:0,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"manageNm"},
                {Header:"근속년월",				Type:"Text",	Hidden:0,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"workPeriod"},
                //{Header:"Location코드",				Type:"Text",	Hidden:1,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"locationCd"},
                //{Header:"Location명",				Type:"Text",	Hidden:1,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"locationNm"},
                //{Header:"Location주소",				Type:"Text",	Hidden:1,	Width:"100",	Align:"Center",	ColMerge:0,	SaveName:"addr"}
            ]; IBS_InitSheet(sheet1, initdata1); sheet1.SetEditable("${editable}");sheet1.SetVisible(true); sheet1.SetCountPosition(4);
            sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor());
        }

        //Sheet1 Action
        function doAction1(sAction) {
            switch(sAction) {
                case "Search":
                    sheet1.DoSearch("${ctx}/EmpLocationSrch.do?cmd=getLocationEmpInfo", $("#sheet1Form").serialize(), 1);
                    break;
            }
        }

        //---------------------------------------------------------------------------------------------------------------
        // sheet1 Event
        //---------------------------------------------------------------------------------------------------------------

        //조회 후 에러 메시지
        function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
            try{
                if(Msg != "") {
                    alert(Msg);
                }
                sheetResize();
            } catch(ex) {
                alert("OnSearchEnd Event Error : " + ex);
            }
        }


        //---------------------------------------------------------------------------------------------------------------
        // Kakao Map
        //---------------------------------------------------------------------------------------------------------------

        //지도 생성
        function showMap(){
            var container = document.getElementById('locMap');
            var options={
                center: new kakao.maps.LatLng(36.2683, 127.6358),
                level: 13
            };
            map = new kakao.maps.Map(container, options);
        }

        //클러스터러 생성
        function makeClusterer(){
            clusterer = new kakao.maps.MarkerClusterer({
               map: map,
               averageCenter: true,
               minLevel: 10
            });
            clusterer.setGridSize(1);  //마커 중심으로 상하좌우 5px 이내에 다른 카머가 존재하면 클러스터 구성
        }

        //Location 데이터 호출 및 가공
        function setMapData() {
            var data = ajaxCall("${ctx}/EmpLocationSrch.do?cmd=getMapClusterData", "searchDate=" + $("#searchDate").val(), false);
            makeMarkers(data);
        }

        //클러스터러 마커 생성
        const makeMarkers = async (data) => {
            for(var i = 0, dlen = data.DATA.length; i<dlen; i++){
                const pos = await getMarkerPosition(data.DATA[i].addr);     //Location 위/경도
                for(var j = 0, locCnt = data.DATA[i].cnt; j<locCnt; j++){   //Location별 인원수만큼 마커 생성
                    var marker = new kakao.maps.Marker({
                        position: new kakao.maps.LatLng(pos.Ma, pos.La)
                    })
                    markers.push(marker);
                }
            }
            await clusterer.addMarkers(markers);
        }

        //주소 -> 위/경도 변환
        function getMarkerPosition(addr){
            var geocoder = new kakao.maps.services.Geocoder();
            var pos = {};

            return new Promise((resolve, reject) => {
                if(addr) {
                    geocoder.addressSearch(addr.trim(), function(result, status) {
                        if(status === kakao.maps.services.Status.OK) {
                            pos = new kakao.maps.LatLng(result[0].y, result[0].x);
                            resolve(pos);
                        }
                    })
                }
            })
        }

    </script>
</head>
<body class="bodywrap">
<div class="wrapper">
    <form id="sheet1Form" name="sheet1Form">
    <div class="sheet_search outer">
        <table>
            <colgroup>
                <col width="10%"/>
                <col width="20%"/>
                <col width="10%"/>
                <col width="*"/>
            </colgroup>
            <tr>
                <th><tit:txt mid='104535' mdef='기준일'/></th>
                <td>
                    <input id="searchDate" name="searchDate" type="text" class="date2 required" value="${curSysYyyyMMdd}" />
                </td>
                <th><tit:txt mid="104535" mdef="Location"/></th>
                <td>
                    <select id="searchLocCd" name="searchLocCd"></select>
                </td>
            </tr>
        </table>
    </div>
    </form>
    <table class="sheet_main">
    <colgroup>
        <col width="65%"/>
        <col width="35%"/>
        <col width="*"/>
    </colgroup>
    <tr>
        <td>
            <div class="inner">
                <div class="sheet_title">
                    <ul><li class="txt">배치 인원</li></ul>
                </div>
            </div>
            <script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}");</script>
        </td>
        <td class="sheet_right">
            <div class="inner">
                <div class="sheet_title">
                    <ul><li class="txt">Location 인원 현황</li></ul>
                </div>
                <div class="map_container">
                    <div id="locMap" style="width: 500px; height: 600px"></div>
                </div>
            </div>
        </td>
    </tr>
    </table>
</div>
</body>
</html>