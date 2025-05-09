<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript" src="/common/js/jquery/fullCalendar_5.3.0.js"></script>
<link rel="stylesheet" href="/common/css/fullCalendar_5.3.0.css" />

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {

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
		    displayEventTime: false,
		    eventOrder: 'start,-duration,allDay,seq',  //eventOrder: 'start,-duration,allDay,title',
	        // json 데이터 불러오기
	        // 월이 변경될때마다 호출됨
			events: function(info, successCallback, failureCallback) {
				var year = String(info.end.getFullYear());
				var month = String(info.end.getMonth());

				if(Number(month) < 10) {
					month = "0"+month;
				}
				
				if(Number(month) == 0) {
					year = String(Number(year) - 1);
					month = "12";
				}
				
				progressBar(true);
		        $.ajax({
		            url: '${ctx}/PsnlCalendar.do?cmd=getPsnlCalendarList',
		            type : "post",
		            dataType: 'json',
		            data: {
		            	// 파라메터로 year, month를 보냄
		                inYm: year+""+month,
		                searchSabun: $("#searchSabun").val(),
		                searchOrgCd: $("#searchOrgCd").val(),
		                multiManageCd : $("#multiManageCd").val()
		            },
		            // 에러시 이벤트
		            error: function() {
		            	progressBar(false);
						alert('error!');
					},
					// 데이터 성공시 이벤트
		            success: function(doc) {
		                var events = [];

		                $(doc.DATA).each(function() {
		                	if($(this).attr('gubun') == '1') { //회사휴일
			                    events.push({
			                        title: $(this).attr('title'),
			                        start: $(this).attr('sYmd'),
			                        end: $(this).attr('eYmd'),
			                      	display : 'list-item',
			                      	className: 'holDay',
					                seq: $(this).attr('seq')
			                    });
		                	}else if($(this).attr('gubun') == '2') { //출퇴근 시간
			                    events.push({
			                        title: $(this).attr('title'),
			                        start: $(this).attr('sYmd'),
			                        end: $(this).attr('eYmd'),
			                      	display : 'list-item',
					                seq: $(this).attr('seq')
			                    });
		                	}else{    
			                    events.push({
			                        title: $(this).attr('title'),
			                        start: $(this).attr('sYmd'),
			                        end: $(this).attr('eYmd'),
			                        textColor: 'white',
					                seq: $(this).attr('seq')
			                    });
		                		
		                	}
		                });
		                successCallback(events);
		                progressBar(false);
		            }
		        });
		    }
		}); //new FullCalendar end
		
		calendar.render();
	});

	// 초기화
	function clearCode() {
		$('#searchName').val("");
		$('#searchSabun').val("");

		calendar.refetchEvents();
	}

	// 사원 팝업
	function showEmployeePopup() {
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "employeePopup";

        var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=R", "", "740","520");

        calendar.refetchEvents();
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup"){
			$('#searchName').val(rv["name"]);
			$('#searchSabun').val(rv["sabun"]);
	    }
	}

</script>
<style type="text/css">
.fc-daygrid-event-dot {
/*  border: 4px solid #ff3535 !important;
  border: calc(var(--fc-daygrid-event-dot-width, 8px) / 2) solid var(--fc-event-border-color, #ff3535 !important);
*/  
}
</style>
</head>
<body>
<div class="wrapper">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='empNm' mdef='성명'/></th>
			<td>
		<c:choose>
			<c:when test="${authPg == 'A'}">
				<input id="searchName" name="searchName" type="text" class="text readonly" value="${sessionScope.ssnName}"/>
				<input id="searchSabun" name="searchSabun" type="hidden" class="text" value="${sessionScope.ssnSabun}"/>
				<!--  <a href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				<a href="javascript:clearCode();" class="button7"><img src="/common/images/icon/icon_undo.png"/></a> -->
			</c:when>
			<c:otherwise>
				<input id="searchName" name="searchName" type="text" class="text readonly" value="${sessionScope.ssnName}" readonly/>
				<input id="searchSabun" name="searchSabun" type="hidden" class="text" value="${sessionScope.ssnSabun}"/>
			</c:otherwise>
		</c:choose>
			</td>
		</tr>
		</table>
		</div>
	</div>

	<div id='calendar'></div>
</div>
</body>
</html>