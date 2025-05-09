<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head><title>골프장예약신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript" src="/common/js/jquery/fullCalendar_5.3.0.js"></script>
<link rel="stylesheet" href="/common/css/fullCalendar_5.3.0.css" />

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var golfList = ""; 
	$(function() {
		//기준년월
		$("#searchYm").datepicker2({ymonly:true});
		$("#searchYm").keyup(function() {
			if (event.keyCode == 13) {
				searchCalendar();
			}
		});

		$("#searchGolfCd").change(function() {
			searchCalendar();
		});

		
		//요일리스트
 		var weekList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","T90010"), "");
		$("#week").html(weekList[2]);
		
		// 골프장목록
        golfList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getGolfAppGolfCdList",false).codeList
        		      , "golfAddr,golfMon,note"
        		      , "전체");
		$("#searchGolfCd").html(golfList[2]);
		$("#searchGolfCd").bind("change", function(){
			searchCalendar();
		});

		
		calendar = new FullCalendar.Calendar($('#calendar')[0], {
			
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
		    displayEventEnd: false,
		    displayEventTime: true,
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
			events: function(info, successCallback, failureCallback) {
				var y = String(info.end.getFullYear());	var m = String(info.end.getMonth());
				if(Number(m) < 10) { m = "0"+m; }
				if(Number(m) == 00) { y = String(info.end.getFullYear()-1); m = "12"; }
				var tempYm = y+"-"+m;
				/* prev, next 버튼액션으로 인한 변경시 기준년월과 싱크를 맞춤 */
				if($("#searchYm").val() != tempYm) {
					$("#searchYm").val(tempYm);
				}

				var year =  $("#searchYm").val().substring(0,4);//String(end.getFullYear());
				var month = $("#searchYm").val().substring(5,7);//String(end.getMonth());

		        $.ajax({
		            url: '${ctx}/GolfApp.do?cmd=getGolfAppList',
		            type : "post",
		            dataType: 'json',
		            data: {
		            	// 파라메터로 year, month를 보냄
		                searchYm: year+""+month,
		                searchGolfCd: $("#searchGolfCd").val()
		            },
		            // 에러시 이벤트
		            error: function() {
						alert('Error!');
					},
					// 데이터 성공시 이벤트
		            success: function(doc) {
		                var events = [];
		                $(doc.DATA).each(function() {
		                	
		                	var _color ="color-black";
		                	if( $(this).attr('statusCd') == "99" ){
		                		_color ="color-black";
		                	}else if( $(this).attr('statusCd') == "21" ){
		                		_color ="color-blue";
		                	}else if( $(this).attr('statusCd') == "31" ){
		                		_color ="color-purple";
		                	}else if( $(this).attr('statusCd') == "39" ){
		                		_color ="color-gray";
		                	}else if( $(this).attr('statusCd') == "44" ){
		                		_color ="color-red";
		                	}
		                	
		                	events.push({
		                        title: $(this).attr('title'),
		                        start: $(this).attr('ymd'), //+( $(this).attr('reqTimeSt') ? 'T'+$(this).attr('reqTimeSt') : '' ),
		                       // color: _color,
		                        className: _color,
		                      	display : 'list-item',
		                        extendedProps: { 
			                        applSeq : $(this).attr('applSeq'),
			                        viewYn : $(this).attr('viewYn')
							    },
			                    seq: $(this).attr('seq')
		                    });
		                });
		                successCallback(events);
		            }
		        });
		    }
		});
		calendar.render();
	});

	function searchCalendar() {

		//라이크검색 자체가 들어가도록함. - xml안에서 처리가 불가능하여 이곳에 구현
		//$('#calendar').fullCalendar( 'gotoDate', $("#searchYm").val().substring(0,4) , $("#searchYm").val().substring(5,7)-1, '19' );
		calendar.gotoDate( $("#searchYm").val() );
		calendar.refetchEvents();
	}

	// 상세/등록	
	function detailPopup(event, info){
		  
        var applSeq = "";
        var viewYn = "";
        if (null != event){
            applSeq = event.event.extendedProps.applSeq;
            viewYn = event.event.extendedProps.viewYn;
        }
        
        var selectDate = "";
        if (null != info){
             selectDate = info.dateStr ;
             
             if( "${curSysYyyyMMddHyphen}"  >=  selectDate ) { //과거일자 수정 불가.
                 alert("당일 이후부터 신청 할 수 있습니다.");
                 return;
             }
         }
         
        let param  = {
            applSeq : applSeq
          , selectDate : selectDate
          , viewYn : viewYn
          , golfList : golfList[2]
        };
        
        let layerModal = new window.top.document.LayerModal({
                id : 'golfAppLayer'
              , url : '/GolfApp.do?cmd=viewGolfAppLayer'
              , parameters : param 
              , width : 840
              , height : 720
              , title : '골프장예약신청'
              , trigger :[
                  {
                      name : 'golfAppTrigger'
                      , callback : function(result){
                          searchCalendar();
                      }
                  }
              ]
          });
          layerModal.show();
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

.confInfo th {background-color:#fbf3f8 !important; }	
.golfInfo th {background-color:#f9fcfe !important; }	

.color-black { color: #fff; background-color:#808080; }
.color-blue { color: blue; background-color:#ffff00;  }
.color-purple { color: purple; }
.color-gray { color: gray;  text-decoration:line-through!important;}
.color-red { color: red; }
</style>
</head>
<body>
<div class="wrapper">
<select id="week" name="week" class="hide"></select>
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>기준년월</th>
			<td><input type="text" id="searchYm" value="<%=DateUtil.getCurrentTime("yyyy-MM")%>" name="searchYm" class="date" /></td>
			<th>골프장 </th>
			<td>
				<select id="searchGolfCd" name="searchGolfCd"></select>
			</td>
			<td><a href="javascript:searchCalendar();" class="button">조회</a></td>
		</tr>
		</table>
		</div>
	</div>

	<div id='calendar'></div>
</div>
</body>
</html>