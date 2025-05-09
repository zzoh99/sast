
// 달력 세팅.
var _today = new Date();
var _current = new Date();

/**
 * 달력 옵션 오브젝트
 * @selectorId 해당 달력이 들어갈 위치의 id (default: calendarId)
 * @useSelect select를 사용할지 여부 (default: true)
 * @selectHtml select를 사용할 경우 html
 * @dayOfWeekText 달력에 표시될 월별 text (
 * @selMonScheDataUrl 선택된 월의 일정이 있는 날짜를 가져오는 url
 * 데이터는 day로 가져와야함.
 * @selDayScheDataUrl 선택한 일에 대한 모든 일정을 가져오는 url
 * @scheduleParam url 호출시에 넘겨야할 데이터 ( 있을 경우에만 사용 )
 * @scheduleDetailData 일정에 마우스를 올렸을 때 표시될 상세 데이터의 정보
 * 예시 > { "t1" : { tmp1:"정보1", tmp2:"정보2" } }로 두면 t1이라는 타입을 가지는 데이터의 tmp1, tmp2의 항목을 가져오고, 이 항목들은 상세정보에서 보여집니다.
 * @setCalHeightFn 높이 지정 함수
 * @scheItemClass 일정화면에서 각 타입별 항목들의 클래스
 * @dayClickBeforeFn 날짜 클릭하고 날짜 표기되기 이전에 실행되는 함수
 * @dayClickAfterFn 날짜 클릭하고 날짜 표기된 이후 실행되는 함수
 * @useSchedule 스케쥴 화면 사용 여부 ( default : true )
 */
var calObj = {
	selectorId : "calendarId",
	useSelect : true,
	selectHtml : "<option value=''>전체</option>",
	dayOfWeekText : { sun:"Sun", mon:"Mon", tue:"Tue", wed:"Wed", thu:"Thu", fri:"Fri", sat:"Sat" },
	selMonScheDataUrl : "",
	selDayScheDataUrl : "",
	scheduleParam : {},
	scheduleDetailData : null,
	setCalHeightFn : function() {},
	scheItemClass : {},
	dayClickBeforeFn : null,
	dayClickAfterFn : null,
	useSchedule : true
};

/**
 * 달력을 그려주는 메소드
 * @param customObj (Object)
 * @returns
 */
function drawCalendar(customObj) {
	if(customObj != null && customObj != undefined) {
		// 오브젝트 병합
		$.extend(calObj, customObj);
	}

	var calHtml = "" +
	"<!-- //스케쥴_달력 시작 -->";

	if(calObj.useSchedule) {
		calHtml += "" +
		"<div id='scheduleDetail' style='z-index:10000;'></div>";
	}

	calHtml += "" +
	"<input type='hidden' id='mainDate' name='mainDate'>" +
	"<div class='calendar_box'>" +
	"	<div class='calendar_header'>" +
	"		<div class='calendar_controls'>" +
	"				<a href='#' class='date_prev'><i class='mdi-ico'>chevron_left</i></a>" +
	"				<span id='searchYm'></span>" +
	"				<a href='#' class='date_next'><i class='mdi-ico'>chevron_right</i></a>" +
	"		</div>";

	if(calObj.useSelect) {
		calHtml += "" +
		"	<div class='calendar_choice' style='##useSelect##'>" +
		"		<select class='custom_select' name='calendarSep' id='calendarSep' onchange='setCalendarSep();'>" +
		"			##selectHtml##" +
		"		</select>" +
		"	</div>"+
		"</div>";
	}

	calHtml += "" +
	"		<!-- 달력 -->" +
	"		<table class='calendar_dates'>" +
	"			<thead>" +
	"				<tr>" +
	"					<th class='sun'>##sun##</th>" +
	"					<th>##mon##</th>" +
	"					<th>##tue##</th>" +
	"					<th>##wed##</th>" +
	"					<th>##thu##</th>" +
	"					<th>##fri##</th>" +
	"					<th class='sat'>##sat##</th>" +
	"				</tr>" +
	"			</thead>" +
	"			<tbody id='calendarDay'>" +
	"			</tbody>" +
	"		</table>" +
	"		<!-- //달력 end -->";

	if(calObj.useSchedule) {
		calHtml += "" +
		"	<div class='schedule'>" +
		"		<!-- 스케줄 -->" +
		"		<h4 class='schedule_date'><span></span></h4>" +
		"		<dl>" +
		"		</dl>" +
		"		<!-- //스케줄 end -->" +
		"	</div>";
	}

	calHtml += "</div>";

	var convText = calHtml.replace(/##prevText##/gi, calObj.prevText)
						.replace(/##nextText##/gi, calObj.nextText)
						.replace(/##useSelect##/gi, ( calObj.useSelect ? "" : "display:none;") )
						.replace(/##selectHtml##/gi, calObj.selectHtml)
						.replace(/##sun##/gi, calObj.dayOfWeekText.sun)
						.replace(/##mon##/gi, calObj.dayOfWeekText.mon)
						.replace(/##tue##/gi, calObj.dayOfWeekText.tue)
						.replace(/##wed##/gi, calObj.dayOfWeekText.wed)
						.replace(/##thu##/gi, calObj.dayOfWeekText.thu)
						.replace(/##fri##/gi, calObj.dayOfWeekText.fri)
						.replace(/##sat##/gi, calObj.dayOfWeekText.sat);

	if(calObj.selectorId != null && calObj.selectorId != undefined) {
		$("#" + calObj.selectorId).html(convText);
		$("#" + calObj.selectorId).addClass("calendar_pop");
		setCalendarPop(calObj.selectorId);
	}
}

/**
 * 달력 셋팅
 * @returns
 */
function setCalendarPop(selectorId) {

	setCalendarDay();

	$(window).resize(function() {
		if(calObj.setCalHeightFn != null) {
			calObj.setCalHeightFn();
		}
		//setCalendarHeight();
	})

	$("#"+selectorId).click(function () {return false;});

	$(document).click();

	$(".date_prev").unbind("click");
	$(".date_prev").click(function() {
		_current = new Date(_current.getFullYear(),parseInt(_current.getMonth()-1),1);
		setCalendarDay();
		calendarFirstDayClick();
		if(calObj.setCalHeightFn != null) {
			calObj.setCalHeightFn();
		}
	});

	$(".date_next").unbind("click");
	$(".date_next").click(function() {
		_current = new Date(_current.getFullYear(),parseInt(_current.getMonth()+1),1);
		setCalendarDay();
		calendarFirstDayClick();
		if(calObj.setCalHeightFn != null) {
			calObj.setCalHeightFn();
		}
	});
}

/**
 * 특정 월로 달력이동
 * @returns
 */
function setCalendarMonth(ym) {
	var year = ym.substring(0, 4);
	var month = ym.substring(4, 6);
	
	_current = new Date(year, month-1, 1);
	setCalendarDay();
	calendarFirstDayClick();
	if(calObj.setCalHeightFn != null) {
		calObj.setCalHeightFn();
	}
}

/**
 * 매달 1일 체크 이벤트
 * @returns
 */
function calendarFirstDayClick() {
	$("#calendarDay tr td").each(function () {
		var tmp = $(this).html();
		if(tmp != "") {
			$(this).click();
			return false;
		}
	});
}

/**
 * 달력 스케쥴 설정.
 * @returns
 */
function setCalendarDay() {
	var month = _current.getMonth()+1;
	var day = _current.getDate();

	month = (month < 10)  ? "0" + month : month  ;

	day = (day < 10)  ?  "0" +day : day;

	$("#mainDate").val( _current.getFullYear() +""+ month +""+ day);

	calObj.scheduleParam["mainDate"] = $("#mainDate").val();
	if(calObj.useSelect)
		calObj.scheduleParam["calendarSep"] = $("#calendarSep").val();

	$.ajax({
		url 		: calObj.selMonScheDataUrl,
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: calObj.scheduleParam,
		success : function(rv) {
			var getDay = rv.DATA;
			var sortData =[];
			$.each(getDay, function(key, val){sortData.push( val.day );});

			var _dayAry = ["일","월","화","수","목","금","토"];
			var _day = _current.getDay();

			$("#searchYm").html(_current.getFullYear() + "년 " + (_current.getMonth()+1) + "월");
			$(".schedule_date").html("<span>"+_current.getDate()+"</span>일 ("+_dayAry[_current.getDay()]+")");

			$("#calendarDay").empty();

			var _date = new Date(_current.getFullYear(),_current.getMonth());
			var _month = _current.getMonth();
			var _class = "";
			var str = "<tr>";

			_date.setDate(1);
			for(var i=0; i<_date.getDay(); i++) {
				str += "<td></td>";
			}

			for( var i=1;i<=31;i++) {
				_class = "";
				_date.setDate(i);

				if( _date.getFullYear()+""+_date.getMonth()+""+_date.getDate() == _today.getFullYear()+""+_today.getMonth()+""+_today.getDate() ) _class = "calendar_on";
				else if( _date.getDay() == 0 ) _class = "sun";
				else if( _date.getDay() == 6 ) _class = "sat";


				if( _month != _date.getMonth()) continue;
				if(_date.getDay() == 0) {
					str += "</tr><tr>";
				}

				if( in_array((i < 10)  ?  "0" +i : i, sortData ) ) {
					_inText = "<span></span>";
				} else {
					_inText = "";
				}
				_inText += i;

				str += "<td id='day"+_date.getDay()+"' day='"+_date.getDay()+"' class='"+_class+"'>"
					+ _inText
					+ "</td>"
					;
			}
			str += "</tr>";
			$("#calendarDay").html(str);
			$("#calendarDay").css("cursor", "pointer");

			// 일 클릭 이벤트
			$("#calendarDay td").click(function() {
				
				//달력, 선택일 강조
				$("#calendarDay td").css("font-weight", "").css("font-size", "13px");
				$(this).css("font-weight", "bold").css("font-size", "14px");

				if(calObj.dayClickBeforeFn != null) {
					var returnObj = {
							date : $("#mainDate").val()
					};
					calObj.dayClickBeforeFn(returnObj);
				}

				$("#mainDate").val( _current.getFullYear() +""+ month +""+ (($(this).text() < 10)  ?  "0" +$(this).text() : $(this).text()) );

				calObj.scheduleParam["mainDate"] = $("#mainDate").val();
				calObj.scheduleParam["calendarSep"] = $("#calendarSep").val();

				if(calObj.useSchedule) {
					// 상세 일정 화면에 일과 요일 표시
					$(".schedule_date").html("<span>"+$(this).text()+"</span>일 ("+_dayAry[$(this).attr("day")]+")");
					// 파라미터 데이터를 url 파라미터 형식으로 변환
					var dataStr = jQuery.param(calObj.scheduleParam);
					// 해당 일자의 스케쥴 데이터 가져오기
					var getOneDay = ajaxCall(calObj.selDayScheDataUrl, dataStr, false).DATA;

					$(".schedule dl dd").remove();

					var listHtml = "";

					// 타입별 분류
					var dayObj = {};
					for( var i = 0 ; i < getOneDay.length ; i++ ) {
						if(dayObj[getOneDay[i].type] == null) {
							dayObj[getOneDay[i].type] = [];
						}

						dayObj[getOneDay[i].type].push(getOneDay[i]);
					}

					$.each(dayObj, function(key, val) {
						listHtml += "<dt class='" + calObj.scheItemClass[key] + "'><span class='" + calObj.scheItemClass[key] + "'></span>" + val[0].typeNm + "</dt>";
						if(val != null) {
							for( var i = 0 ; i < val.length ; i++) {
								listHtml += "<dd t='"+val[i].type;
								$.each(val[i], function(key2, value2) {
									if (key2.toLowerCase()!="title") {
										listHtml += "' " + key2 + "='" + ( value2 == null ? "" : value2 );
									}
								});
								listHtml += "' style='text-align:left;'>-&nbsp;"+val[i].title+"</dd>";
							}
						}
					});

					$(".schedule dl").html(listHtml);

					$(".schedule dl dd").hover(function () {
						var detailHtml = "" +
						"<div class='schedule_detail' style='z-index:10000;'></div>";

						$(this).append(detailHtml);

						var detail = $(this).find("div.schedule_detail");

						var l = $(this).offset().left;
						var t = $(this).offset().top;
						detail.css("left", l+200);
						detail.css("top", t-50);

						var str = "";
						var tp = $(this).attr("t");
						var ddThis = $(this);
						if(calObj.scheduleDetailData != null) {
							$.each(calObj.scheduleDetailData, function(key, value) {
								str += value + " : " + ddThis.attr(key) + "<br>";
							});
						}

						detail.html(str);
						detail.show();
					}, function () {
						$(this).find("div.schedule_detail").remove();
					});

					if(listHtml == "") {
						$(".schedule dl").append("<dd>일정이 없습니다.</dd>");
					}
				}

				if(calObj.dayClickAfterFn != null) {
					var returnObj = {
							date : $("#mainDate").val()
					};
					calObj.dayClickAfterFn(returnObj);
				}
			});

			//calendar_on
			var clickObj = $("#calendarDay .calendar_on");
			if(clickObj.length == 0) {
				calendarFirstDayClick();
			} else {
				clickObj.click();
			}

			if(calObj.setCalHeightFn != null)
				calObj.setCalHeightFn();
		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});
}

/*
 * 넘어온 파라미터로 달력 일정 재조회
 */
function resetCalendarDay(paramObj) {
	var param = calObj.scheduleParam;
	$.extend(calObj.scheduleParam, paramObj);
	
	setCalendarDay();
	calObj.scheduleParam = param;
}

// 상태 변경시 이벤트
function setCalendarSep() {
	var sep = $("#calendarSep").val();

	if(calObj.useSchedule) {
		$(".schedule").show();
	}
	$(".calendar_dates").show();
	$(".calendar_controls").show();
	setCalendarDay();
}

function getMainDate() {
	return $("#mainDate").val();
}