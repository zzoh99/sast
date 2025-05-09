<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head><title>자원예약신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<!-- <script type="text/javascript" src="/common/js/jquery/fullcalendar.min.js"></script>
<link rel="stylesheet" href="/common/css/fullcalendar.css" /> -->
<!-- 2020.08.28 Calendar 라이브러리 버전 1.6 => 5.3으로 교체 -->
<script type="text/javascript" src="/common/js/jquery/fullCalendar_5.3.0.js"></script>
<link rel="stylesheet" href="/common/css/fullCalendar_5.3.0.css" />
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var calendar;
var reqParam = "";
	$(function() {
		
		//기준년월
		$("#searchYm").datepicker2({ymonly:true, onReturn: getCommonCodeList});
		$("#searchYm").keyup(function() {
			if (event.keyCode == 13) {
				searchCalendar() ;
			}
		}) ;
 
		//자원종류 //장소 
		$("#searchResTypeCd, #searchResLocationCd").change(function() {
			searchCalendar();
			setResSeqCombo();
		});
		
		//자원명
		$("#searchResSeq").change(function() {
			searchCalendar();
		});
		
		getCommonCodeList();
		setResSeqCombo();
		
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
	        /* eventColor: function(event) {
	        	//alert(event);
	        }
			, */
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
		            url: '${ctx}/ReservationApp.do?cmd=getReservationAppList',
		            type : "post",
		            dataType: 'json',
		            data: {
		            	// 파라메터로 year, month를 보냄
		                searchYm: year+""+month,
		                searchResTypeCd: $("#searchResTypeCd").val(),
		                searchResLocationCd: $("#searchResLocationCd").val(),
		                searchResSeq: $("#searchResSeq").val()
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
		                        title: $(this).attr('resNm')+' '+(($(this).attr('dayYn') == 'Y' ? '(종일)' : $(this).attr('sTime')+'~'+$(this).attr('eTime'))) +$(this).attr('title'),
		                        start: $(this).attr('ymd')+( ($(this).attr('dayYn') != 'Y' && $(this).attr('sTime')) ? 'T'+$(this).attr('sTime') : '' ),
		                          end: $(this).attr('eYmd')+( ($(this).attr('dayYn') != 'Y' && $(this).attr('eTime')) ? 'T'+$(this).attr('eTime') : $(this).attr('ymd') != $(this).attr('eYmd') ? 'T23:59:59' : '' ),
		                           id: $(this).attr('applSeq'),
		                        extendedProps: { 
		                        	applSeq : $(this).attr('applSeq')
							    },
			                    seq: $(this).attr('seq')
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
   		
	});

	function getCommonCodeList() {
		let searchYm = $("#searchYm").val();
		let baseSYmd = "";
		let baseEYmd = "";

		if (searchYm !== "") {
			baseSYmd = searchYm + "-01";
			baseEYmd = getLastDayOfMonth(searchYm);
		}

		//공통코드 한번에 조회
		let grpCds = "T90010,B52010,B52020";
		let params = "grpCd=" + grpCds + "&baseSYmd=" + baseSYmd + "&baseEYmd=" + baseEYmd;
		let codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y", params, false).codeList, "");

		$("#week").html(codeLists["T90010"][2]); //요일
		$("#searchResTypeCd").html(codeLists["B52010"][2]);//자원종류
		$("#searchResLocationCd").html(codeLists["B52020"][2]); //자원위치
	}

	function getLastDayOfMonth(yearMonth) {
		const [year, month] = yearMonth.split('-').map(Number);
		const lastDate = new Date(year, month, 0);

		const yearStr = lastDate.getFullYear().toString();
		const monthStr = (lastDate.getMonth() + 1).toString().padStart(2, '0');
		const dayStr = lastDate.getDate().toString().padStart(2, '0');

		return yearStr + '-' + monthStr + '-' + dayStr;
	}

	function searchCalendar() {

		//라이크검색 자체가 들어가도록함. - xml안에서 처리가 불가능하여 이곳에 구현
		/* $('#calendar').fullCalendar( 'gotoDate', $("#searchYm").val().substring(0,4) , $("#searchYm").val().substring(5,7)-1, '19' );
		$('#calendar').fullCalendar('refetchEvents'); */
		calendar.gotoDate( $("#searchYm").val() );
		calendar.refetchEvents();
	}

    //$('#calendar').fullCalendar('refetchEvents');
	
    function setResSeqCombo(){
		//자원명
		reqParam ="&searchResTypeCd="+$("#searchResTypeCd").val()
		             +"&searchResLocationCd="+$("#searchResLocationCd").val();
        var resSeqList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReservationAppResCdList"+reqParam,false).codeList
        		      , "note,resTypeNm,resLocationNm", "");
        
		$("#resSeq").html(resSeqList[2]);
		$("#resSeq").change(function(){
			$("#span_note").html(replaceAll($("#resSeq option:selected").attr("note"), "\n", "<br>"));
			$("#span_resTypeNm").html($("#resSeq option:selected").attr("resTypeCd"));
			$("#span_resLocationNm").html($("#resSeq option:selected").attr("resLocationNm"));
		
		});

		$("#searchResSeq").html("<option value=''>전체</option>"+resSeqList[2]);

		$("#resSeq").change();
    }
	
	// 상세/등록	
	function detailPopup(event, info){
		
		var applSeq = "";
		if (null != event){
			applSeq = event.event.extendedProps.applSeq;
		}
		
		var selectDate = "";
        if (null != info){
        	 selectDate = info.dateStr ;
        	 
             if( "${curSysYyyyMMddHyphen}" > selectDate ) { //과거일자 수정 불가.
                 alert("당일 이후부터 신청 할 수 있습니다.");
                 return;
             }
         }
         
		let param  = {
			applSeq : applSeq
	      , selectDate : selectDate
	      , reqParam : reqParam
	    };
		
	    let layerModal = new window.top.document.LayerModal({
	            id : 'reservationAppLayer'
	          , url : '/ReservationApp.do?cmd=viewReservationAppLayer'
	          , parameters : param 
	          , width : 840
	          , height : 720
	          , title : '자원예약신청'
	          , trigger :[
	              {
	                  name : 'reservationAppTrigger'
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
</head>
<body>
<div class="wrapper">
    <select id="week" name="week" class="hide"></select>
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='114470' mdef='기준년월'/></th>
			<td><input type="text" id="searchYm" value="<%=DateUtil.getCurrentTime("yyyy-MM")%>" name="searchYm" class="date" /></td>
			<th><tit:txt mid='resType' mdef='자원종류'/></th>
			<td>
				<select id="searchResTypeCd" name="searchResTypeCd"></select>
			</td>
			<th><tit:txt mid='resLocation' mdef='장소'/></th>
			<td>
				<select id="searchResLocationCd" name="searchResLocationCd"></select>
			</td>
			<th><tit:txt mid='resSeqNm' mdef='자원명'/></th>
			<td>
				<select id="searchResSeq" name="searchResSeq"></select>
			</td>
			<td><a href="javascript:searchCalendar();" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a></td>
		</tr>
		</table>
		</div>
	</div>

	<div id='calendar'></div>
</div>
</body>
</html>