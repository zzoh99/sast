<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widgetContent20;
var widget20classNm;

var page = 1;
var cntPage20 = 0;
var selectYear20 = "";
var selectMonth20 = "";
var mode20 = "";
var getOneDay2Cnt = "";

function main_listBox20(title, info, classNm, seq ){

	widget20classNm = classNm;

	$("#listBox20").attr("seq", seq);

	loadApp20(1 , 0, classNm);
}


function loadApp20(title, info, classNm, seq ){
	

	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}
	
	$.ajax({
		url 		: "${ctx}/getListBox8List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list20 = rv.DATA;

			var classTypeHtml20;

			getOneDay2Cnt = ajaxCall("/getMainCalendarMap2.do",$("#listBox20Form").serialize(),false).list;

			var year = _current20.getFullYear();
			var year1 = year + 1;
			var year2 = year - 1;

			if(classNm == "box_100"){

				classTypeHtml20 = '<h3 class="main_title_100 img_100_schedule">오늘의 일정</h3>'
					+ '<div class="box100_btn_prev"><a href="javascript:btnUp20()"class="btn_up">이전</a></div>'
					+ '<div class="box100_btn_next"><a href="javascript:btnDw20()" class="btn_down">다음</a></div>'
					+ '<div class="schedule_group">'
					+ '<div class="schedule_form">'
					+ '<select class="selectbox" name="year20" id="year20" onChange="javascript:search20();">'
					+ '<option value="'+year1+'">'+year1+'년</option>'
					+ '<option value="'+year+'">'+year+'년</option>'
					+ '<option value="'+year2+'">'+year2+'년</option>'
					+ '</select>'
					+ '<select class="selectbox" name="month20" id="month20" onChange="javascript:search20();">'
					+ '<option value="01">1월</option>'
					+ '<option value="02">2월</option>'
					+ '<option value="03">3월</option>'
					+ '<option value="04">4월</option>'
					+ '<option value="05">5월</option>'
					+ '<option value="06">6월</option>'
					+ '<option value="07">7월</option>'
					+ '<option value="08">8월</option>'
					+ '<option value="09">9월</option>'
					+ '<option value="10">10월</option>'
					+ '<option value="11">11월</option>'
					+ '<option value="12">12월</option>'
					+ '</select>'
					+ '</div>'
					+ '<ul class="schedule_txt"></ul>'
					+ '</div>';

			} else if(classNm == "box_250"){

				classTypeHtml20 = '<h3 class="main_title_250">오늘의 일정</h3>'
					+ '<div class="schedule_group">'
					+ '<div class="schedule_form">'
					+ '<select class="selectbox" name="year20" id="year20" onChange="javascript:search20();">'
					+ '<option value="'+year1+'">'+year1+'년</option>'
					+ '<option value="'+year+'">'+year+'년</option>'
					+ '<option value="'+year2+'">'+year2+'년</option>'
					+ '</select>'
					+ '<select class="selectbox" name="month20" id="month20" onChange="javascript:search20();">'
					+ '<option value="01">1월</option>'
					+ '<option value="02">2월</option>'
					+ '<option value="03">3월</option>'
					+ '<option value="04">4월</option>'
					+ '<option value="05">5월</option>'
					+ '<option value="06">6월</option>'
					+ '<option value="07">7월</option>'
					+ '<option value="08">8월</option>'
					+ '<option value="09">9월</option>'
					+ '<option value="10">10월</option>'
					+ '<option value="11">11월</option>'
					+ '<option value="12">12월</option>'
					+ '</select>'
					+ '</div>'
					+ '<ul class="schedule_txt">'
					+ '</ul>'
					+ '</div>';


			} else if(classNm == "box_400"){

				classTypeHtml20 = '<h3 class="main_title_400">오늘의 일정</h3>'
					+ '<div class="calendar_date_group">'
					+ '<ul class="calendar_date">'
					+ '<li><a style="cursor:pointer" class="btn_prev_b">이전달</a></li>'
					+ '<li id="calendar_ym" class="calendar_ym"></li>'
					+ '<li><a style="cursor:pointer" class="btn_next_b">다음달</a></li>'
					+ '</ul>'
					+ '<ul class="calendar_today">'
					+ '<li id="calToday"></li>'
					+ '<li><a style="cursor:pointer" class="btn_today">오늘</a></li>'
					+ '</ul>'
					+ '</div>'
					+ '<table class="calendar_table">'
					+ '<caption>개인일정 달력</caption>'
					+ '<thead>'
					+ '<tr><th class="calendar_sun">S</th><th>M</th><th>T</th><th>W</th><th>T</th><th>F</th><th>S</th></tr>'
					+ '</thead>'
					+ '<tbody id="calendarDay"><tbody>'
					+ '</table>'
					+ '<div class="calendar_on" id="calendarDetail">'
					+ '<div class="on_title">'
					+ '<a id="btn_calendar_close" class="btn_calendar_close" style="cursor:pointer">창닫기</a>'
					+ '<p>오늘의 일정</p>'
					+ '<p id="mainDate" class="on_date"></p>'
					+ '</div>'
					+ '<div class="on_txt_group">'
					+ '<ul class="on_txt"></ul>'
					+ '</div>'
					+ '</div>';

			}


			$("#listBox20 > .anchor_of_widget").html(classTypeHtml20);
			$("#listBox20").removeClass();
			$("#listBox20").addClass(classNm);



			var position = $("#month20").on('mouseover', function () {
			    position.find('option:selected').prependTo(position);
			});

			var position2 = $("#year20").on('mouseover', function () {
			    position2.find('option:selected').prependTo(position2);
			});

			setCalendarWidgetApp20(classNm);
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}


function setCalendarWidgetApp20(classNm) {
	/*$("#calendarWidget").click(function() {
		$("#mainCalendar").show();
		indexResize();
	});*/

	initCalendar20(classNm);
	setCalendarDay20(classNm, page);
}

var _today20 = new Date();
var _current20 = new Date();
// 달력 기본설정
function initCalendar20(classNm) {
	/*$("#mainCalendar .close").click(function() {
		$("#mainCalendar").hide();
		indexResize();
	});*/

	$(".calendar_date .btn_prev_b").click(function() {
		_current20 = new Date(_current20.getFullYear(),parseInt(_current20.getMonth()-1),1);
		setCalendarDay20(classNm, page);
	});

	$(".calendar_date .btn_next_b").click(function() {
		_current20 = new Date(_current20.getFullYear(),parseInt(_current20.getMonth()+1),1);
		setCalendarDay20(classNm, page);
	});


	$(".calendar_today .btn_today").click(function() {
		_current20 = _today20;
		setCalendarDay20(classNm, page);
	});

	$("#btn_calendar_close").click(function() {

		$("#calendarDetail").hide();
	});
}

// 달력 날짜 설정
function setCalendarDay20(classNm, page) {

	var month = _current20.getMonth()+1;
	var day = _current20.getDate();

	month = (month < 10)  ? "0" + month : month  ;

	day = (day < 10)  ?  "0" +day : day;

	$("#mainDate", "#listBox20Form").val( _current20.getFullYear() +""+ month +""+ day);
	
	//var getDay = ajaxCall("/getScheduleDay.do",$("#listBox20Form").serialize(),false).DATA;

	$.ajax({
		url 		: "/getScheduleDay.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: $("#listBox20Form").serialize(),
		success : function(rv) {
			var getDay = rv.DATA;

			var sortData =[];
			$.each(getDay, function(key, val){sortData.push( val.day );});

			var _dayAry = ["일","월","화","수","목","금","토"];
			var _day = _current20.getDay();

			$("#calendar_ym").text( _current20.getFullYear() + "." + (_current20.getMonth()+1) );
			$("#calToday").html("<b>" + ( _today20.getMonth()+1) + "." + _today20.getDate() + " (" + _dayAry[_today20.getDay()] + ")</b>")

			$("#calendarDay").empty();

			var _date = new Date(_current20.getFullYear(),_current20.getMonth());
			var _month = _current20.getMonth();
			var _class = "";
			var realDate = 1;
			_date.setDate(1);
			var thisDay = _date.getDay();
			var trHtml = "<tr>";
			var innerHtml = "";

			var isClose = false;

			for( var i = 0 ; i < 42 ; i++) {
				if( i >= thisDay ) {

					isClose = false;

					var isScheduled = false;
					_class = "";
					_date.setDate(realDate);

					if( _date.getFullYear()+""+_date.getMonth()+""+_date.getDate() == _today20.getFullYear()+""+_today20.getMonth()+""+_today20.getDate() ) _class = "blt_calendar_on";
					else if( _date.getDay() == 0 ) _class = "calendar_sun";
					else if( _date.getDay() == 6 ) _class = "calendar_sat";

					if(in_array((realDate < 10)  ?  "0" +realDate : realDate, sortData )) {
						isScheduled = true;
						_class += " clickable";
					}

					if( _month != _date.getMonth()) continue;

					//innerHtml += "<td id='day" + realDate + "' class='" + _class + "'><span day='"+_date.getDay()+"'>"+realDate+"</span></td>";
					innerHtml += "<td id='day" + realDate + "' class='" + _class + "'>";
					if(isScheduled) {
						innerHtml += "<span></span>";
					}
					innerHtml += realDate+"</td>";
					/*$('<td></td>',{
						id: 'day'+i,
						"class": _class
					}).html("<span day='"+_date.getDay()+"'>"+i+"</span>");*/

					if( _date.getDay() == 6) {
						trHtml += innerHtml + "</tr>";
						$("#calendarDay").append(trHtml);
						trHtml = "<tr>";
						innerHtml = "";

						isClose = true;


					}

					realDate++;
				} else {
					innerHtml += "<td></td>";
				}
			}

			if ( isClose != true){

				trHtml += innerHtml + "</tr>";
				$("#calendarDay").append(trHtml);
			}

			if(classNm != "box_400"){

				if(selectYear20 == ""){ $("#year20").val(_current20.getFullYear()); }
				else { $("#year20").val(selectYear20); }

				if(selectMonth20 == ""){ $("#month20").val(month); }
				else { $("#month20").val(selectMonth20); }

				$("#listBox20Form #mainDate").val($("#year20").val() + $("#month20").val());

				var getOneDay2 = "";

				if(classNm == "box_250"){
					getOneDay2 = ajaxCall("/getMainCalendarMap2.do",$("#listBox20Form").serialize(),false).list;
				} else if(classNm == "box_100"){
					getOneDay2 = ajaxCall("/getMainCalendarMap2.do?page="+page+"&countAnniv=2",$("#listBox20Form").serialize(),false).list;
				}


				cntPage20 = Math.ceil(getOneDay2Cnt.length/ 2);

				$(".schedule_txt").html("");

				for( var i = 0 ; i < getOneDay2.length ; i++ ) {
					var strTitle = "";

					strTitle = getOneDay2[i].title;
					//alert("strTitle : " + strTitle );

					if(classNm == "box_250"){
						$(".schedule_txt").append("<li id='schedule"+getOneDay2[i].type+"' class='schedule"+getOneDay2[i].type+"'><span class='schedule_day'>" + strTitle+" </span>" +
								"<span>"+getOneDay2[i].period+"<span/>" +
								"<span class='hide'>" + getOneDay2[i].memo + "</span></li>");

						$(".schedule_txt").show();
					} else if(classNm == "box_100"){

						var scheduleStyle = "";
						if(getOneDay2[i].type == "1"){ scheduleStyle = "schedule0"; }
						else { scheduleStyle = "schedule1"; }

						$(".schedule_txt").append("<li id='schedule"+getOneDay2[i].type+"' class='"+scheduleStyle+"'><span class='schedule_day'>" + strTitle+" </span>" +
								"<span>"+getOneDay2[i].period+"<span/>" +
								"<span class='hide'>" + getOneDay2[i].memo + "</span></li>");

						$(".schedule_txt").hide();

					 	if(mode20 == ""){
						 	$(".schedule_txt").show();
					 	}else if(mode20 == "up"){
					 		$(".schedule_txt").show("slide", {direction: "up" }, "fast");
					 	} else if (mode20 == "dw"){
					 		$(".schedule_txt").show("slide", {direction: "down" }, "fast");
					 	}

					}


				}
			}

			$("#calendarDay td.clickable").click(function() {

				$("#listBox20Form #mainDate").val(_current20.getFullYear()+""+month+""+(($(this).text() < 10)  ?  "0" +$(this).text() : $(this).text()));

				var getOneDay = ajaxCall("/getMainCalendarMap.do",$("#listBox20Form").serialize(),false).list;

				$("#schedule0").html("");
				$("#schedule1").html("");
				$("#schedule2").html("");
				//클릭해서 볼때마다 데이터 쌓이지 않게 초기화

				$(".on_txt").html("");

				for( var i = 0 ; i < getOneDay.length ; i++ ) {
					var strTitle = "";

					strTitle = getOneDay[i].title;
					//alert("strTitle : " + strTitle );

					$(".on_txt").append("<li id='schedule"+getOneDay[i].type+"' class='schedule"+getOneDay[i].type+"'>" +
							strTitle+"<br/>" +
							""+getOneDay[i].period+"" +
							"<span class='hide'>" + getOneDay[i].memo + "</span></li>");


				}
				$("#calendarDetail #mainDate").html( _current20.getFullYear() +"."+ month +"."+ (($(this).text() < 10)  ?  "0" +$(this).text() : $(this).text()) + " (" + _dayAry[_current20.getDay()] + ")" );

				//$(".calendar_on").css("left", $("#cal_div").position().left + 7);
				//$(".calendar_on").css("top",  $("#cal_div").position().top + 15);

				$("#calendarDetail").show();
			});


		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}

function search20(){

	$("#listBox20Form #mainDate").val($("#year20").val() + $("#month20").val());

	var getOneDay2 = ajaxCall("/getMainCalendarMap2.do",$("#listBox20Form").serialize(),false).list;
	$(".schedule_txt").html("");

	for( var i = 0 ; i < getOneDay2.length ; i++ ) {
		var strTitle = "";

		strTitle = getOneDay2[i].title;
		//alert("strTitle : " + strTitle );

		$(".schedule_txt").append("<li id='schedule"+getOneDay2[i].type+"' class='schedule"+getOneDay2[i].type+"'><span class='schedule_day'>" + strTitle+" </span>" +
				"<span>"+getOneDay2[i].period+"<span/>" +
				"<span class='hide'>" + getOneDay2[i].memo + "</span></li>");

		$(".schedule_txt").hide();

	}

	selectYear20 = $("#year20").val();
	selectMonth20 = $("#month20").val();
	setCalendarDay20(widget20classNm, "1");

}


function btnUp20(){

	var box20_page = parseInt($("#box20_page").val(),10);
	box20_page = box20_page - 1;

	if(box20_page >= 1){
		mode20 = "up";
		$("#box20_page").val( box20_page);
		setCalendarDay("box_100", box20_page);
	}

}

function btnDw20(){

	var box20_page = parseInt($("#box20_page").val(),10);

	if(cntPage20 > box20_page){
		box20_page = box20_page + 1;
		$("#box20_page").val( box20_page);
		mode20 = "dw";
		setCalendarDay20("box_100", box20_page);
	}


}

</script>
<input type="hidden" id="box20_page" name="box20_page" value="1" />
<div  id="listBox20" lv="20" info="오늘의 일정" class="notice_box">
	<div class="anchor_of_widget"></div>
	<form id="listBox20Form" name="listBox20Form" method="post"><!-- 메뉴값 넘기기 위한 form 수정 필요  -->
		<input type="hidden" 	id="mainDate"		name="mainDate"	value="${ curSysYear }${ curSysMon }" />
	</form>
</div>

