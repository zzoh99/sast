<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head> <title><tit:txt mid='2017082300193' mdef='조직원연차계획현황'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript" src="/common/js/jquery/fullCalendar_5.3.0.js"></script>
<link rel="stylesheet" href="/common/css/fullCalendar_5.3.0.css" />

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		
		// 사원구분코드(H10030)
		var manageCd 	= convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
		$("#searchManageCd").html(manageCd[2]);
		$("#searchManageCd").select2({
			placeholder:("${ssnLocaleCd}" != "en_US" ? " 선택" : " Select")
		});

		//기준년월
		$("#searchYm").datepicker2({
			ymonly:true,
			onReturn:function(date){
				setOrgCombo();
				searchCalendar();
			}
		});

		$("#searchYm, #searchSabunName").keyup(function() {
			if (event.keyCode == 13) {
				searchCalendar();
			}
		});

		$("#searchJikchakCd, #searchOrgCd").change(function() {
			searchCalendar();
		});

  		// 직책
  		var jikchakCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchJikchakCd").html(jikchakCdList[2]);

		setOrgCombo();
		$("#searchOrgCd").val("${ssnOrgCd}");
		
		//달력 초기화
		init_calendar();

	}) ;
	//조직콤보
	function setOrgCombo(){
		var orgCd = convCode( ajaxCall("${ctx}/AnnualPlanCalendar.do?cmd=getAnnualPlanCalendarOrgList","searchYmd="+$("#searchYm").val(),false).DATA, "");
		$("#searchOrgCd").html(orgCd[2]);
	}

	function init_calendar() {

		calendar = new FullCalendar.Calendar($('#calendar')[0], {
			
			headerToolbar: {
				left: 'prevYear,prev,next,nextYear today',
		        center: 'title',
		        right: 'dayGridMonth,dayGridWeek,dayGridDay,listMonth'
			},
			initialDate: "${curSysYyyyMMddHyphen}",
			navLinks: true, // can click day/week names to navigate views
		    dayMaxEvents: true, // allow "more" link when too many events
		    editable: false,
		    businessHours: true,
		    displayEventEnd: false,
		    displayEventTime: false,
	        // json 데이터 불러오기
	        // 월이 변경될때마다 호출됨
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

				$("#searchMultiManageCd").val(getMultiSelect($("#searchManageCd").val()));

				progressBar(true);
				$.ajax({
		            url: '${ctx}/AnnualPlanCalendar.do?cmd=getAnnualPlanCalendarList',
		            type : "post",
		            dataType: 'json',
		            data: {
		            	// 파라메터로 year, month를 보냄
		                searchYm: year+""+month,
		                searchSabunName: $("#searchSabunName").val(),
		                searchOrgCd: $("#searchOrgCd").val(),
		                searchMultiManageCd : $("#searchMultiManageCd").val()
		            },
		            // 에러시 이벤트
		            error: function() {
				        progressBar(false) ;
						alert('error!');
					},
					// 데이터 성공시 이벤트
		            success: function(doc) {
		                var events = [];

		                $(doc.DATA).each(function() {
		                	if($(this).attr('holDayYn') != 'N' && $(this).attr('holDayYn') != '' && $(this).attr('gntNm') == '' ) {
			                    events.push({
			                        title: $(this).attr('holDayYn'),
			                        start: $(this).attr('sYmd'),
			                      	display : 'list-item',
			                      	className: 'holDay'
			                      	//display : 'block'
			                    });
		                	}
		                	if($(this).attr('gntNm') != '') {
			                    events.push({
			                        title: $(this).attr('gntNm'),
			                        start: $(this).attr('sYmd'),
			                        end: $(this).attr('eYmd')+($(this).attr('sYmd') != $(this).attr('eYmd') ? 'T23:59:59' : ''),
			                        display : 'auto'
			                        //allDay: true
			                        //className: 'eventColor1',
			                        //textColor: 'white'
			                    });
		                	}
		                });
		                successCallback(events);
				        progressBar(false) ;
		            }
		        });

		    }
		}); //new FullCalendar end
		
		calendar.render();
	}

	function searchCalendar() {
		calendar.gotoDate( $("#searchYm").val() );
		calendar.refetchEvents();
	}
    
</script>
<style type="text/css">
.fc-daygrid-event-dot {
  border: 4px solid #ff3535 !important;
  border: calc(var(--fc-daygrid-event-dot-width, 8px) / 2) solid var(--fc-event-border-color, #ff3535 !important);
}
</style>
</head>
<body>
<div class="wrapper">
	<form id="searchForm" name="searchForm" >
	<input type="hidden" id="searchMultiManageCd" name="searchMultiManageCd" value="" />
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='114470' mdef='기준년월'/></th>
			<td><input type="text" id="searchYm" value="<%=DateUtil.getCurrentTime("yyyy-MM")%>" name="searchYm" class="date" /></td>
			<th class="hide"><tit:txt mid='114017' mdef='직책 '/></th>
			<td class="hide"> <select id="searchJikchakCd" name="searchJikchakCd"> </select> </td>
			<th><tit:txt mid='104295' mdef='소속 '/></th>
			<td>
				<select id="searchOrgCd" name="searchOrgCd"></select>
			</td>
			<th>사번/성명</th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
			</td>
			<th><tit:txt mid='103784' mdef='사원구분'/></th>
			<td>
				<select id="searchManageCd" name="searchManageCd" multiple=""></select>
			</td>
			<td><btn:a href="javascript:searchCalendar();" id="btnSearch" css="button" mid='search' mdef="조회"/> </td>
		</tr>
		</table>
		</div>
	</div>

	<div id='calendar'></div>
	</form>
</div>
</body>
</html>