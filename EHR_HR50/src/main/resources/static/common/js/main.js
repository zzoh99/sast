//===================================================   main 신청내역, 결재내역, 급여지급현황 버튼 start =====================================================
	function goAppPage(){
		var goPrgCd = "AppBoxLst.do?cmd=viewAppBoxLst";
		goSubPage("","","","",goPrgCd);
	}
	function goAprPage(){
		var goPrgCd = "AppBeforeLst.do?cmd=viewAppBeforeLst";
		goSubPage("","","","",goPrgCd);
	}
	function goSalPage(){
		var goPrgCd = "PerPayPartiUserSta.do?cmd=viewPerPayPartiUserSta";
		goSubPage("","","","",goPrgCd);
	}
	function mainOpenNoticePop(bbsCd,bbsSeq ){
		var url 	= "/Board.do?cmd=viewBoardReadPopup&";
		var $form = $('<form></form>');
		$form.appendTo('body');
		var param1 	= $('<input name="bbsCd" 	type="hidden" 	value="'+bbsCd+'">');
		var param2 	= $('<input name="bbsSeq" 	type="hidden" 	value="'+bbsSeq+'">');
		$form.append(param1).append(param2);
		url +=$form.serialize() ;
		if(!isPopup()) {return;}
		openPopup(url, self, "940","780");
	}
	function passwordChange(){
		if(!isPopup()) {return;}
		openPopup('/Popup.do?cmd=pwChPopup','',650,320);
	}
//===================================================   main 신청내역, 결재내역, 급여지급현황 버튼 end =====================================================
//===================================================   달력설정 start =====================================================

	var _today = new Date();
	var currentday = new Date();

	// 달력 기본설정
	function initCalendar() {

		$(".calendar_date_box .date_prev").click(function() {
			currentday = new Date(currentday.getFullYear(),parseInt(currentday.getMonth()-1),1);
			setCalendarDay();
		});
		$(".calendar_date_box .date_next").click(function() {
			currentday = new Date(currentday.getFullYear(),parseInt(currentday.getMonth()+1),1);
			setCalendarDay();
		});
		$(".calendar_today .btn_today").click(function() {
			currentday = _today;
			setCalendarDay();
		});
		$("#btn_calendar_close").click(function() {
			$("#calendarDetail").hide();
		});
	}

	// 달력 기본설정
	function setCalendarDay() {

		var month =  currentday.getMonth()+1;
		var day   =  currentday.getDate();
			month = (month < 10)  ? "0" + month : month  ;
			day   = (day < 10)  ?  "0" +day : day;
		$("#mainDate").val( currentday.getFullYear() +""+ month +""+ day);

		$.ajax({
			url 		: "/getScheduleDay.do",
			type 		: "post", dataType 	: "json", async 		: true, data 		: $("#mainForm").serialize(),
			success : function(rv) {
				var getDay = rv.DATA;

				var sortData =[];
				$.each(getDay, function(key, val){sortData.push( val.day );});

				var curMonth = currentday.getMonth()+1;
				curMonth = (curMonth < 10)  ? "0" + curMonth : curMonth  ;

				$("#calendar_ym").text( currentday.getFullYear() + getMsgLanguage({"msgid": "msg.2019061800003", "defaultMsg":"년 "}) + curMonth + getMsgLanguage({"msgid": "msg.2019061800002", "defaultMsg":"월"}));
				$("#calendarDay").empty();

				var _date = new Date(currentday.getFullYear(),currentday.getMonth());
				var _month = currentday.getMonth();
				var _class = "";
				var realDate = 1;
				_date.setDate(1);
				var thisDay = _date.getDay();
				var headerHtml = "<caption>개인일정 달력</caption><thead><tr><th class=\"calendar_week\">S</th><th class=\"calendar_week\">M</th><th class=\"calendar_week\">T</th><th class=\"calendar_week\">W</th><th class=\"calendar_week\">T</th><th class=\"calendar_week\">F</th><th class=\"calendar_week\">S</th></tr></thead><tbody>";
				var trHtml = "<tr>";
				var innerHtml = "";
				var isClose = false;

				for( var i = 0 ; i < 42 ; i++) {
					if( i >= thisDay ) {
						var isScheduled = false;
						isClose = false;_class = "";
						_date.setDate(realDate);
						if( _date.getFullYear()+""+_date.getMonth()+""+_date.getDate() == _today.getFullYear()+""+_today.getMonth()+""+_today.getDate() ) {_class = "calendar_on";
						}else if( _date.getDay() == 0 ){_class = "calendar_sun";
						}else if( _date.getDay() == 6 ){_class = "calendar_sat";}
						if(in_array((realDate < 10)  ?  "0" +realDate : realDate, sortData )) {
							isScheduled = true;
							_class += "";
						}
						if( _month != _date.getMonth()) continue;
						innerHtml += "<td id='day" + realDate + "' class='" + _class + "'>";
						if(isScheduled) {
							if ( _class == "calendar_on"){innerHtml += realDate+"</td>";
							}else{innerHtml += "<span>" +realDate+"</span></td>";}
						}else{
							innerHtml += realDate+"</td>";
						}
						$('<td></td>',{id: 'day'+i,"class": _class}).html("<span day='"+_date.getDay()+"'>"+i+"</span>");

						if( _date.getDay() == 6) {
							trHtml += innerHtml + "</tr></tbody>";
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
					var HTML = headerHtml + trHtml;
					$("#calendarDay").append(HTML);
				}

				$("#calendarDay td").click(function() {

					$("#mainForm #mainDate").val(currentday.getFullYear()+""+month+""+(($(this).text() < 10)  ?  "0" +$(this).text() : $(this).text()));
					var getOneDay = ajaxCall("/getMainCalendarMap.do",$("#mainForm").serialize(),false).list;
					$("#schedule_lst").html("");
					var strScheduleString = "";
					for( var i = 0 ; i < getOneDay.length ; i++ ) {
						var val = "<dt>"+getOneDay[i].title+"</dt><dd>"+getOneDay[i].period+"</dd>"
						strScheduleString = strScheduleString + val;
					}
					$(".schedule_date").html( currentday.getFullYear() +"."+ month +"<strong>"+ (($(this).text() < 10)  ?  "0" +$(this).text() : $(this).text()) + "</strong>" );
					$("#schedule_lst").html(strScheduleString);
					$(".schedule_date").show();
				});
			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			},complete : function() {
				$(".calendar_on").click();
			}
		});
	}
//===================================================   달력설정 end =====================================================
//===================================================   좌측메뉴클릭 start =====================================================
//Major Menu click
function majorMenuAction(){
	$("#majorMenu1>li>a").mouseover(function(event) {
		$(this).addClass("lnb_on");
		$(this).find("a").removeClass("lnb_off").addClass("lnb_on");
	});

	$("#majorMenu1>li>a").mouseout(function(event) {
		$(this).removeClass("lnb_on");
		$(this).find("a").removeClass("lnb_on").addClass("lnb_off");
	});

	$("#majorMenu1>li>a:not(#sampleMenu,#IBSheetMenu)").click(function(){
		$("#murl").val($(this).attr("murl"));
		submitCall($("#mainForm"),"","post","/Hr.do");
	});

	//workflow Menu click
	$(".floating>ul>li:not(#quick_menu03) a").click(function(){
		$("#murl").val($(this).parent().attr("murl"));
		submitCall($("#mainForm"),"","post","/Hr.do");
	});

	$(".lnb_bott_menu a").click(function(){
		$("#murl").val($(this).attr("murl"));
		submitCall($("#mainForm"),"","post","/Hr.do");
	});

	$("#btnMenuUp").click(function(event) {
		var scr = $("#majorTop").scrollTop();
		var scrolled = scr - 95;
		if(!$("#majorTop").is(':animated')) {
			$("#majorTop").stop().animate({
				scrollTop: scrolled
			});
		}
	});

	$("#btnMenuDown").click(function(event) {
		var scr = $("#majorTop").scrollTop();
		var scrolled = scr + 95;
		if(!$("#majorTop").is(':animated')) {
			$("#majorTop").stop().animate({
				scrollTop: scrolled
			});
		}
	});

	$("#majorTop").on("mousewheel DOMMouseScroll", function(event) {
		event.preventDefault();
		var E = event.originalEvent;
		var delta = 0;
		var agent = navigator.userAgent.toLowerCase();

		if (agent.indexOf("firefox") != -1) {
			if(E.detail) {
				delta = E.detail;
			} else {
				delta = E.wheelDelta;
			}
			if(delta < 0) {
				$("#btnMenuUp").click();
			} else {
				$("#btnMenuDown").click();
			}
		}else if (agent.indexOf("chrome") != -1) {
			if(E.detail) {
				delta = E.detail;
			} else {
				delta = E.wheelDelta;
			}
			if(delta < 0) {
				$("#btnMenuDown").click();
			} else {
				$("#btnMenuUp").click();
			}
		}else{
			if(E.deltaY) {
				delta = E.deltaY;
			} else {
				delta = E.wheelDelta;
			}
			if(delta < 0) {
				$("#btnMenuUp").click();
			} else {
				$("#btnMenuDown").click();
			}
		}

		event.stopPropagation();
		event.stopImmediatePropagation();
	});
}
//===================================================   좌측메뉴클릭 end =====================================================
function getPopupList() {
	$.each(_pageObj, function(idx, obj) {
		if(obj.obj.closed) {
			_pageObj.splice(idx, 1);
		}
	});

	return _pageObj;
}
//20200909 로직 추가
//===================================================   main 메인설정 메뉴바인 경우 공지사항 팝업공지 start =====================================================
function mainMenuBarOpenNoticePop(bbsCd, bbsSeq) {

	var url    = "/Board.do?cmd=viewBoardReadPopupEx&";
    var $form  = $('<form></form>');
    	$form.appendTo('body');
    var param1 = $('<input name="bbsCd"  type="hidden" value="'+bbsCd+'">');
    var param2 = $('<input name="bbsSeq" type="hidden" value="'+bbsSeq+'">');
    	$form.append(param1).append(param2);
    	url   += $form.serialize();

	openPopup(url, self, "940","800");
}
//===================================================   main 메인설정 메뉴바인 경우 공지사항 팝업공지 end =====================================================