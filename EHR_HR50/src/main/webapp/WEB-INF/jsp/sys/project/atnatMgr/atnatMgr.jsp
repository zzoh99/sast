<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head> <title>수행인력근태</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!-- Jquery -->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%><!-- IBSheet -->
</head>
<script type="text/javascript" src="/common/js/jquery/fullCalendar_5.3.0.js"></script>
<link rel="stylesheet" href="/common/css/fullCalendar_5.3.0.css" />
<script type="text/javascript">
    var calendar;
    $(function () {
        $("#searchYm").datepicker2({ymonly:true});
        $('#searchYm').keyup(() => {
            if(event.keyCode == 13) {
                searchCalendar();
            }
        })

        var grpCds = "T90010,B52010,B52020";
        var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y","grpCd="+grpCds,false).codeList, "");
        $("#week").html(codeLists["T90010"][2]); //요일
        initCalendar();

    })

    function initCalendar() {
        calendar = new FullCalendar.Calendar($('#calendar')[0], {

            //$("#calendar").fullCalendar({
            headerToolbar: {
                left: 'today',
                center: 'prev,title,next',
                right: 'dayGridMonth,dayGridWeek,dayGridDay,listMonth'
            },
            initialDate: "${curSysYyyyMMddHyphen}",
            navLinks: true, // can click day/week names to navigate views
            dayMaxEvents: true, // allow "more" link when too many events
            editable: false,
            businessHours: true,
            displayEventTime: false,
            eventOrder: 'start,-duration,allDay,seq',  //eventOrder: 'start,-duration,allDay,title',

            // 일정 클릭시 이벤트
            eventClick: function(event) {
                // 일정 클릭시 등록된 url로 팝업 띄움
                detailPopup(event);
                return false;
            },
            dateClick: function(info){
                detailPopup(null, info);
            },
            // json 데이터 불러오기
            // 월이 변경될때마다 호출됨
            //events: function(start, end, callback) {
            events: function(info, successCallback, failureCallback) {
                var y = String(info.end.getFullYear());
                var m = String(info.end.getMonth()) ;
                if(Number(m) < 10) { m = "0"+m ; }
                if(Number(m) == 00) { y = String(info.end.getFullYear()-1) ; m = "12"; }
                var tempYm = y+"-"+m ;
                /* prev, next 버튼액션으로 인한 변경시 기준년월과 싱크를 맞춤 */
                if($("#searchYm").val() != tempYm) {
                    $("#searchYm").val(tempYm) ;
                }

                var year =  $("#searchYm").val().substring(0,4);//String(end.getFullYear());
                var month = $("#searchYm").val().substring(5,7);//String(end.getMonth());

                $.ajax({
                    url: '${ctx}/AtnatMgr.do?cmd=getAtnatList',
                    type : "post",
                    dataType: 'json',
                    data: {
                        // 파라메터로 year, month를 보냄
                        searchYm: year+""+month,
                    },
                    // 에러시 이벤트
                    error: function(err) {
                        alert("Error");
                    },
                    // 데이터 성공시 이벤트
                    success: function(doc) {
                        var events = [];
                        $(doc.DATA).each(function() {
                            events.push({
                                title: $(this).attr('name')+ ' - ' + $(this).attr('vacationNm'),
                                start: formatDate($(this).attr('vacationSdate'), '-') + " 00:00:00",
                                end: formatDate($(this).attr('vacationEdate'), '-') + " 24:00:00",
                                id: $(this).attr('applSeq'),
                                extendedProps: {
                                    applSeq : $(this).attr('applSeq')
                                },
                            });
                        });
                        successCallback(events);
                    }
                });
            }
            /* ,
            eventRender: function(event, element) {
                $(element).find("div").attr("alt",event.description);
                $(element).find("div").attr("title",event.description);
            }
        }); */
            /*	년, 월, 일	*/
            //$('#calendar').fullCalendar( 'gotoDate', $("#searchYm").val().substring(0,4) , $("#searchYm").val().substring(5,7)-1, '19' );
        }); //new FullCalendar end

        calendar.render();
    }

    function detailPopup(event, info){

        var applSeq = "";
        if (null != event){
            applSeq = event.event.extendedProps.applSeq;
        }

        var selectDate = "";
        if (null != info){
            selectDate = info.dateStr ;
            /*if( "${curSysYyyyMMddHyphen}" > selectDate ) { //과거일자 수정 불가.
                alert("당일 이후부터 신청 할 수 있습니다.");
                return;
            }*/
        }

        let param  = {
            applSeq : applSeq
            , selectDate : selectDate
        };

        let layerModal = new window.top.document.LayerModal({
            id : 'atnatMgrLayer'
            , url : '/AtnatMgr.do?cmd=viewAtnatMgrLayer'
            , parameters : param
            , width : 840
            , height : 400
            , title : '휴가신청'
            , trigger :[
                {
                    name : 'atnatMgrTrigger'
                    , callback : function(result){
                        searchCalendar();
                    }
                }
            ]
        });
        layerModal.show();
    }

    function searchCalendar() {

        //라이크검색 자체가 들어가도록함. - xml안에서 처리가 불가능하여 이곳에 구현
        /* $('#calendar').fullCalendar( 'gotoDate', $("#searchYm").val().substring(0,4) , $("#searchYm").val().substring(5,7)-1, '19' );
        $('#calendar').fullCalendar('refetchEvents'); */
        calendar.gotoDate( $("#searchYm").val() );
        calendar.refetchEvents();
    }

</script>

<style type="text/css">
    body { font-size: 11px !important; }
    textarea.transparent {
        border:none !important;
        background:none !important;
    }
    .fc-event-title {line-height:18px;}
    .fc-event-title:hover {text-decoration: underline; cursor:pointer;}
    .fc-day:hover {cursor:pointer; background-color:#eefaff;}

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

<body>
    <div class="wrapper">
        <select id="week" name="week" class="hide"></select>
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                        <th>기준년월</th>
                        <td><input type="text" id="searchYm" value="<%=DateUtil.getCurrentTime("yyyy-MM")%>" name="searchYm" class="date" /></td>
                        <td><a href="javascript:searchCalendar();" class="button">조회</a></td>
                    </tr>
                </table>
            </div>
        </div>
        <div id='calendar'></div>
    </div>
</body>