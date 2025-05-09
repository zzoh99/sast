    if (top.location != location) {
        top.location.href = document.location.href ;
  	}

    // 화면 리사이즈
	function indexResize() {
		if( $(window).width() >= 1240 ) $("#index_wrap").addClass("on");
		else $("#index_wrap").removeClass("on");

		//$("#lnb").height($("#container").height());

		var majorMenuHeight = $("#index_wrap").height() - 15;
		//$("#lnb").find("#majorTop").css("height", majorMenuHeight);
	}

	// 메뉴 아이콘 깜빡거림 방지
	var timeout;
	function startTimeout(idx) {
		stopTimeout();
		timeout = setTimeout(hideIcon(idx), 10);
	}

	function stopTimeout() {
		clearTimeout(timeout);
	}

	function hideIcon(idx) {
		//$("#lefticon").hide();
		$("#lefticon li:eq(" + idx + ")").css("visibility", "hidden");
	}

	// 달력 설정
	function setCalendarWidget() {
		/*$("#calendarWidget").click(function() {
			$("#mainCalendar").show();
			indexResize();
		});*/

		initCalendar();
		setCalendarDay();
	}

	var _today = new Date();
	var _current = new Date();
	// 달력 기본설정
	function initCalendar() {
		/*$("#mainCalendar .close").click(function() {
			$("#mainCalendar").hide();
			indexResize();
		});*/

		$(".calendar_date .btn_prev_b").click(function() {
			_current = new Date(_current.getFullYear(),parseInt(_current.getMonth()-1),1);
			setCalendarDay();
		});

		$(".calendar_date .btn_next_b").click(function() {
			_current = new Date(_current.getFullYear(),parseInt(_current.getMonth()+1),1);
			setCalendarDay();
		});


		$(".calendar_today .btn_today").click(function() {
			_current = _today;
			setCalendarDay();
		});

		$("#btn_calendar_close").click(function() {
			$("#calendarDetail").hide();
		});
	}

	// 달력 날짜 설정
	function setCalendarDay() {

		var month = _current.getMonth()+1;
		var day = _current.getDate();

		month = (month < 10)  ? "0" + month : month  ;

		day = (day < 10)  ?  "0" +day : day;

		$("#mainDate").val( _current.getFullYear() +""+ month +""+ day);

		//var getDay = ajaxCall("/getScheduleDay.do",$("#mainForm").serialize(),false).DATA;

		$.ajax({
			url 		: "/getScheduleDay.do",
			type 		: "post", dataType 	: "json", async 		: true, data 		: $("#mainForm").serialize(),
			success : function(rv) {
				var getDay = rv.DATA;

				var sortData =[];
				$.each(getDay, function(key, val){sortData.push( val.day );});

				var _dayAry = ["일","월","화","수","목","금","토"];
				var _day = _current.getDay();

				$("#calendar_ym").text( _current.getFullYear() + "." + (_current.getMonth()+1) );
				$("#calToday").html("<b>" + ( _today.getMonth()+1) + "." + _today.getDate() + " (" + _dayAry[_today.getDay()] + ")</b>")

				$("#calendarDay").empty();

				var _date = new Date(_current.getFullYear(),_current.getMonth());
				var _month = _current.getMonth();
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

						if( _date.getFullYear()+""+_date.getMonth()+""+_date.getDate() == _today.getFullYear()+""+_today.getMonth()+""+_today.getDate() ) _class = "blt_calendar_on";
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

				$("#calendarDay td.clickable").click(function() {
					$("#mainForm #mainDate").val(_current.getFullYear()+""+month+""+(($(this).text() < 10)  ?  "0" +$(this).text() : $(this).text()));

					var getOneDay = ajaxCall("/getMainCalendarMap.do",$("#mainForm").serialize(),false).list;

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
					$("#calendarDetail #mainDate").html( _current.getFullYear() +"."+ month +"."+ (($(this).text() < 10)  ?  "0" +$(this).text() : $(this).text()) + " (" + _dayAry[_current.getDay()] + ")" );

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


	// 스킨 설정
/*	function setSkinWidget(t,f) {

		var cTint= 0;
		var cFint= 0;

		if(t=="theme1") cTint=0;
		if(t=="theme2") cTint=1;
		if(t=="theme3") cTint=2;
		if(t=="theme4") cTint=3;

		if(f=="dotum") cFint=0;
		if(f=="nanum") cFint=1;


		var currentSkin = cTint;
		var currentFont = cFint;

		// 테마 설정 레이어 이벤트 막기
		$("#themeWidgetMain").click(function(){
			return false;
		});

		// 테마 설정 아이콘 클릭 이벤트
		$("#themeWidget").click(function() {
			console.log("click");
			$(document).click();
			// 활성화 된 테마를 설정한다.
			$("#themeWidgetMain div.theme li").each(function() {
				if( $(this).index() == currentSkin ) $(this).find("div").addClass("on");
				else $(this).find("div").removeClass("on");
			});

			$("#themeWidgetMain div.font input").each(function() {
				if( $(this).parent().index() == currentFont ) $(this).attr("checked",true);
				else $(this).attr("checked",false);
			});

			// 테마 설정 레이어 표시
			$("#themeWidgetMain").show();
			$(document).click(function() { $("#themeCancel").click(); });
			return false;
		});

		// 테마 리스트 클릭시 이벤트
		$("#themeWidgetMain div.theme li").click(function() {
			// 테마 리스트의 체크박스를 선택안된 상태로 만든다.
			$("#themeWidgetMain div.theme div").each(function() {
				$(this).removeClass("on");
			});
			// 선택된 테마의 체크박스만 체크 상태로 만든다.
			$(this).find("div").addClass("on");
		});

		// 폰트 리스트 클릭 이벤트
		$("#themeWidgetMain div.font li").click(function() {
			// 폰트 리스트의 체크박스를 선택안된 상태로 만든다.
			$("#themeWidgetMain div.font input").each(function() {
				$(this).attr("checked",false);
			});

			// 선택된 폰트의 체크박스만 체크 상태로 만든다.
			$(this).find("input").attr("checked",true);
			return false;
		});

		$("#themeWidgetMain div.font input").click(function(e) {
			e.stopPropagation();
			$("#themeWidgetMain div.font li:eq(" + $(this).parent().index() + ")").click();
		});

		// 테마 설정 레이어의 확인 클릭시 이벤트
		$("#themeOk").click(function() {
			var valueChanged = false;
			var selectTheme = "";
			var selectFont = "";
			// 현재 선택된 테마를 저장한다.
			$("#themeWidgetMain .theme li").each(function() {
				if( $(this).find("div").hasClass("on") ) {
					if( currentSkin != $(this).index() ) valueChanged = true;
					currentSkin = $(this).index();
					selectTheme = $(this).attr("theme");
				}
			});

			// 현재 선택된 폰트를 저장한다.
			$("#themeWidgetMain .font li").each(function() {
				if( $(this).find("input").attr("checked") ) {
					if( currentFont != $(this).index() ) valueChanged = true;
					currentFont = $(this).index();
					selectFont = $(this).find("input").val();
				}
			});
			// 스킨이나 폰트 값이 변경되었을 경우 변수에 저장후 home으로 이동
			if( valueChanged ) {
				//값 호출 작업 ..

				$("#subThemeType").val(selectTheme);
				$("#subFontType").val(selectFont);

				//저장
				ajaxCall("/UserMgr.do?cmd=userTheme",$("#ssnChangeForm").serialize(),false);
				//submitCall($("#subForm"),"","post","/Main.do");
				//location.href = "/";
				redirect("/", "_top");
			}
			$("#themeCancel").click();
		});

		// 테마 설정 레이어의 취소 클릭시 이벤트
		$("#themeCancel").click(function() {
			// 테마 설정 레이어를 숨겨준다.
			$("#themeWidgetMain").hide();
			$(document).unbind("click");
		});
	}*/


	// Major Menu 조회 및 생성
	function createMajorMenu(){

		//위젯
		var workflowMenuStr = "<li id='quick_menu03'><a id='btnWidget' class='quick_menu03' title='위젯설정'><span>위젯설정</span></a></li>"; // href='javascript:setWidget()'
		$("#workflowMenu").append(workflowMenuStr);
		majorMenuAction();
		
		// 대분류 메뉴 조회
		/*
		$.ajax({
			url 		: "/getMainMajorMenuList.do",
			type 		: "post",dataType: "json",async: true,data:"",
			success : function(rv) {
				var majorMenu 	= rv.result;

				var mainMenuNm 	= "";
				var murl        = "";
				var viewMenuStr = "";
				var leftIconStr = "";

				var workflowMenuStr = "";

				//대분류 메뉴 초기화
				$("#majorMenu1").html("");
				$("#workflowMenu").html("");
				for ( var i = 0; i < majorMenu.length; i++) {
					mainMenuCd 	= majorMenu[i].mainMenuCd;
					grpCd 		= majorMenu[i].grpCd;
					mainMenuNm 	= majorMenu[i].mainMenuNm;
					murl 		= majorMenu[i].murl;

					if(mainMenuCd =="20" ){
						workflowMenuStr +="<li murl='"+murl+"' mainMenuCd='"+mainMenuCd+"' grpCd='"+grpCd+"'><a class='quick_menu01 pointer' title='" + mainMenuNm + "'><span>"+ mainMenuNm +"</span></a></li>";
					}
					else if(mainMenuCd =="21" ){
						workflowMenuStr +="<li murl='"+murl+"' mainMenuCd='"+mainMenuCd+"' grpCd='"+grpCd+"'><a class='quick_menu02 pointer' title='" + mainMenuNm + "'><span>"+ mainMenuNm +"</span></a></li>";
					}
					else{
						viewMenuStr +="<li murl='"+murl+"' mainMenuCd='"+mainMenuCd+"' grpCd='"+grpCd+"' class='pointer'><a class='lnb_off lnb_icon" + mainMenuCd + "' title='"+ mainMenuNm +"'>"+ mainMenuNm +"</a></li>";
					}
				}
				//workflowMenuStr += "<li id='quick_menu03'><a href='javascript:setWidget()' class='quick_menu03' title='위젯설정'><span>위젯설정</span></a></li>"; // href='javascript:setWidget()'
				workflowMenuStr += "<li id='quick_menu03'><a id='btnWidget' class='quick_menu03' title='위젯설정'><span>위젯설정</span></a></li>"; // href='javascript:setWidget()'

				$("#majorMenu1").append(viewMenuStr);
				$("#workflowMenu").append(workflowMenuStr);

				majorMenuAction();
			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});*/

	}


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

		$("a#btnWidget").click(function(e) {
			setWidget();
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


	// 패밀리 사이트 설정
	function setFamilySite() {
		$(".menu_footer>ul>li").click(function() {
			var _no = $(this).index();
			if( _no == 0 ) redirect("http://gw.isu.co.kr", "_blank");
			else if( _no == 1 ) redirect("http://www.credu.com", "_blank");
			else if( _no == 2 ) $("#family").show();	// 패밀리 사이트

		});

		$("#family>ul>li").click(function() {
			var _no = $(this).index();
			if( _no == 0 ) 		redirect("http://www.isu.co.kr", "_blank");
			else if( _no == 1 ) redirect("http://www.isuchemical.com", "_blank");
			else if( _no == 2 ) redirect("http://const.isu.co.kr/", "_blank");
			else if( _no == 3 ) redirect("http://www.petasys.com/", "_blank");
			else if( _no == 4 ) redirect("http://www.isu.co.kr/market/", "_blank");
			else if( _no == 5 ) redirect("http://www.isusystem.com/", "_blank");
			else if( _no == 6 ) redirect("http://www.isuvc.com/", "_blank");
			else if( _no == 7 ) redirect("http://www.abxis.com", "_blank");
			else if( _no == 8 ) redirect("http://www.exachem.co.kr", "_blank");
			else if( _no == 9 ) redirect("http://www.exaboard.com", "_blank");
			else if( _no == 10 ) redirect("http://www.isuexaflex.co.kr", "_blank");
			else if( _no == 11 ) redirect("http://www.todaisu.co.kr/main.asp", "_blank");
			$("#family").hide();
		});
		$("#family img").click(function() {
			$("#family").hide();
		});
	}


	function setDrag() {

		// 탭 드래그, 정렬
		// 개인정보 & 달력 제외
		$( ".anchor_of_widget" ).parent("div").draggable({
			cancel: "#profileBox, select, .box100_btn_prev , .box100_btn_next , span.on , span.off", // , #cal_div
			activeClass : "ui-state-highlight",
			cursor : "move",
			handle : ".anchor_of_widget",
			opacity: 0.7,
			helper : "clone",
			revert : "invalid",
			zIndex : 999
		});
		$( ".anchor_of_widget" ).parent("div").droppable({
		    hoverClass: "drop_hover",
			drop: function( event, ui ) {
				if( ui.draggable.attr("id") == "panalAlertDiv" ){
					return false;
				}
				var draggableId = ui.draggable.attr("id");
				var draggableClass = ui.draggable.attr("class");
				var draggableSeq = ui.draggable.attr("seq");
				var _draggableClass = "";

				if( draggableClass.indexOf("box_100") != -1 ){
					_draggableClass = "100";
				} else if( draggableClass.indexOf("box_250") != -1 ){
					_draggableClass = "250";
				} else {
					_draggableClass = "400";
				}

				var thisId = $(this).attr("id");
				var thisClass = $(this).attr("class");
				var thisSeq   = $(this).attr("seq");
				var _thisClass = "";

				if( thisClass.indexOf("box_100") != -1 ){
					_thisClass = "100";
				} else if( thisClass.indexOf("box_250") != -1 ){
					_thisClass = "250";
				} else {
					_thisClass = "400";
				}

				if( thisId == "profileBox"){ //|| thisId == "cal_div"
					return;
				}

				$(this).after(ui.draggable.clone(false, true));
				$(ui.draggable).after($(this).clone(false, true));

				$(ui.draggable).remove();
				$(this).remove();
				setDrag();
//alert("main_"+ draggableId +"('','', 'box_"+ _thisClass +"','"+ thisSeq + "' );");
//alert("main_"+ thisId +"('','', 'box_"+ _draggableClass +"','"+ draggableSeq + "' );");
				eval("main_"+ draggableId +"('','', 'box_"+ _thisClass +"','"+ thisSeq + "' );");
				eval("main_"+ thisId +"('','', 'box_"+ _draggableClass +"','"+ draggableSeq + "' );");
				//setListLv();

				var widgetIds ="";
				var resultArray = [];

				var arry1 = "";
				var arry2 = "";

				var total = $( ".anchor_of_widget" ).parent("div").length;

				$( ".anchor_of_widget" ).parent("div").each(function(index, value){
					if( $(this).css("display") != "none" ){

						if ( $(this).attr("id")  != undefined && $(this).attr("id") != "undefined"){


							if ( index == total -1 ){
								widgetIds = widgetIds + ($(this).attr("id") + "|" + $(this).attr("seq"));
							}else{
								widgetIds = widgetIds + ($(this).attr("id") + "|" + $(this).attr("seq")+",");
							}

							//resultArray[index] = new mkArr($(this).attr("id"),$(this).attr("seq"));
							arry1 += $(this).attr("id")+"|" ;
							arry2 += $(this).attr("seq")+"|" ;
							//alert($(this).attr("id"));
							//alert($(this).attr("seq"));
						}
					}
				});

				//alert(arry1);
				//alert(arry2);

				/*for ( var i=0; i < resultArray.length; i++ ){

					console.log(resultArray[i]["id"] + " " + resultArray[i]["seq"]);

				}

				console.log("==========top");

				resultArray.sort(function(a, b){
					return a["seq"] - b["seq"];
				});

				for ( var i=0; i < resultArray.length; i++ ){

					console.log( resultArray[i]["id"] + " " + resultArray[i]["seq"]);
					widgetIds+= resultArray[i]["id"] + "|";
				}

				console.log("==========bot");*/

/*				$(resultArray).each(function(index, value){
					widgetIds = widgetIds + (value.id+"|");
				});*/

				$('body').css('cursor', 'default');
				saveWidget(widgetIds);
			}
		});

	}

	function mkArr(id,seq) {
		this.id  = id;
		this.seq = seq;
	}

	// 위젯 팝업
	function setWidget() {
		if(!isPopup()) {return;}

		window.scrollTo(0,0);

		var listAry = [];
		var divClass;
		$(".notice_box, .box_400 , .box_250").each(function() {
			divClass = $(this).css("display")=="none"?"off":"on";
			listAry.push({
				id:$(this).attr("id"),
				title:$(this).attr("title"),
				info:$(this).attr("info"),
				view:divClass
			});
		});

//			var params = {};
//			params.list = listAry;
//			params.func = setItemList;
//			var args = openPopup("/html/popup/widget_popup.html",params,540,587);
//			setItemList(args);

		pGubun = "widjetPopup";
		//openPopup("/widjetPopup.do",self,540,620);
		openPopup("/widjetPopup.do",self,540,520);
		// $("#widgetButton").addClass("on");
	}

	// 리스트 순서 셋팅
	function setListLv() {
		$( ".anchor_of_widget" ).parent("div").each(function() {
			$(this).attr("lv", $(this).index() );
		});
	}

	function setItemList(args) {
		if( args == undefined ) return;
		var tempAry = [];
		var len = args.length;
		var viewCount = 0;
		for( var i=0;i<len;i++ ) {
			$("#"+args[i].id).appendTo( $("#sortable") );
			if( args[i].view == "off" ) $("#"+args[i].id).addClass("hide");
			else {
				$("#"+args[i].id).removeClass("hide");
				viewCount++;
				tempAry.push( args[i].id.substr(7) );
			}
		}

		$("#mainTabSeq").val(tempAry.join(","));


		if( viewCount == 0 ) {
			$("#no_widget").show();
			$("#widgetButton").addClass("on");
		}
		else {
			$("#no_widget").hide();
			$("#widgetButton").removeClass("on");
		}

		indexResize();

		if( $("#cover").length > 0 ) {
			$("#cover").height($("#container").height());
		}
	}

	// 서브페이지로 이동
	function goSubPage(mainMenuCd,priorMenuCd,menuCd,menuSeq,prgCd) {
		//var str = "menuSeq="+menuSeq+"&prgCd="+prgCd ;
		var str = "mainMenuCd="+ mainMenuCd + "&menuSeq="+menuSeq+"&prgCd="+prgCd ;
		var result = ajaxCall("/geSubDirectMap.do",str,false).map;
		if(result==null){
			alert("해당메뉴에 대한 조회 권한이 없습니다.");
			return;
		}
		var form = $('<form></form>');
		form.append('<input type="hidden" name="murl" value="' + result.surl + '" />');
		$('body').append(form);
		submitCall(form,"","post","/Hr.do");
	}

	// 위젯 셋팅
	function setWidgetList(str) {
		var tempAry = [];
		if( str.length > 0 )
			tempAry = str.split(",");

		var widgetAry = [];
		for( var i = 0 ; i < tempAry.length ; i++ ) {
			widgetAry.push({
				id:"listBox"+tempAry[i],
				view:"on"
			});
		};

		for( var i = 0 ; i < 12 ; i++ ) {
			if( str.indexOf(i) == -1 ) {
				widgetAry.push({
					id:"listBox"+i,
					view:"off"
				});
			}
		}
		setItemList(widgetAry);
	}

	function getWidgetValue() {

		setWidgetList( $("#mainTabSeq").val() );
	}

	function getWidgetList(type){
		var widgetList  = ajaxCall("/getWidgetList.do","",false).DATA;
		var tabId 		= null;
		var tabUrl 		= null;
		var seq			= null;
		var tabName		= null;
		var tabDetail	= null;
		var tabClass    = null;

		//console.log(widgetList);
		var _tabClassArry = null;
		if( type == "A" || type == "" ){
			// 100/250/400 "250",
			_tabClassArry = [ "400","400","400",  "250","100",  "250","250","250","250",  "250","250","250","250","250","250","250","250"];
		} else {
			// 100/250/400 "250",
			_tabClassArry = [ "250","250","250",  "250","250",  "250","250","250","250",  "250","250","250","250","250","250","250","250"];
		}
		
		var initFnArrayForWidget = [];
		var cnt = 0;
		for(var i = 0; i<widgetList.length; i++){
			tabId 		= widgetList[i].tabId;
			tabUrl 		= widgetList[i].tabUrl;
			seq 		= widgetList[i].seq;
			tabName 	= widgetList[i].tabName;
			tabDetail 	= widgetList[i].tabDetail;
			tabOnOff 	= widgetList[i].tabOnOff;

			if(tabOnOff != null && ( tabOnOff == "on" || tabOnOff == "fixed" ) ){
				tabClass    = _tabClassArry[cnt];
				addWidget(tabUrl+"main_"+tabId, type, i, tabId, tabClass);
				//eval("main_"+tabId+"('"+tabName+"','"+tabDetail+"', 'box_"+ tabClass +"','" + seq + "' );");
				initFnArrayForWidget.push("main_"+tabId+"('"+tabName+"','"+tabDetail+"', 'box_"+ tabClass +"','" + seq + "' );");
				cnt++;
			}
		}
		
		indexResize();
		
		for(var i = 0; i<widgetList.length; i++){
			eval(initFnArrayForWidget[i]);
		}
	}

	function previewWidget(viewList){
		$("#sortable").empty();
		var tabId 		= null;
		var tabName		= null;
		var tabDetail	= null;
		for(var i = 0; i<viewList.length; i++){
			tabId 		= viewList[i].tabId;
			tabName 	= viewList[i].tabName;
			tabDetail 	= viewList[i].tabDetail;
			addWidget("main/main/main_"+tabId, "", i);
			eval("main_"+tabId+"('"+tabName+"','"+tabDetail+"');");
		}
		indexResize();
	}
	function addWidget(wUrl, type, no, tabId, tabClass){
		$.ajax({
			url : "/getWidgetToHtml.do",
			type : "post",
			dataType : "html",
			async : false,
			data : "url="+wUrl,
			success : function(data) {
				if( type != "A" ){
					$("#sortable").append(data.trim());
				} else {
					if( no != "3" ){
						$("#sortable").append(data.trim());
					} else {
						$(".floatL").append(data.trim());
					}
				}
				if( tabId != undefined && tabId != "" && tabClass != undefined && tabClass != "" ) {
					$("#" + tabId).addClass("box_" + tabClass);
					var loadingImgMarTop = parseInt(Math.round((tabClass - 32) / 2));
					var loadHtml = '<div class="alignC" style="margin-top:'  + loadingImgMarTop + 'px; opacity:0.15;"><img src="/common/images/common/loading_s.gif" width="32" /></div>';
					if( tabId == "listBox22" ) {
						$("#widgetCon19", "#" + tabId).html(loadHtml);
					} else {
						$(".anchor_of_widget", "#" + tabId).html(loadHtml);
					}
					
				}
			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});
	}
	function saveWidget(widgetIds){
		var _widgetType = _ssnWidegtType;

		var saveCnt = ajaxCall("/saveWidget.do","widgetIds="+widgetIds+"&widgetType="+_widgetType,false);
	}

	function setWidgetButton() {
		/*
		if( $("#sortable .notice_box").length == 0 ) {
			$("#no_widget").show();
			$("#widgetButton").addClass("on");
		}
		else {
			$("#no_widget").hide();
			$("#widgetButton").removeClass("on");
		}
		*/
	}

	//주소 및 우편번호 수정
	function setAddressZipCode(sabun) {
		var iframe = document.createElement('iframe');
		var url = '/yjungsan/chgAddress/jsp_jungsan/chgAddress/chkChgAddress.jsp';

		var http = new XMLHttpRequest();
		http.open('HEAD', url, false);
		http.send();
		if(http.status!=200){
			url = '/JSP/yjungsan/chgAddress/jsp_jungsan/chgAddress/chkChgAddress.jsp';
		}

		iframe.className = 'address_iframe';
		iframe.width = '0px';
		iframe.height = '0px';
		iframe.style.display = 'none';
		iframe.setAttribute("src", url);

		document.body.appendChild(iframe);
	}

/* 2022.03.08 사용안함 commonHeader.jsp에서 정의함.
	// 개인별 알림 2020.02.26
	function getPanalAlertList(sabun){
		$("#quick_menu05").hide();

		var isPop = true;

		if( getCookie("panalAlertClose") != null ){
			var today = new Date();

		    var tMonth = today.getMonth() + 1
		    tMonth     = tMonth< 10 ? "0"+tMonth : tMonth;
		    var tDay   = today.getDate()
		    tDay       = tDay < 10 ? "0" + tDay : tDay;

			var cookieValue = sabun +"|"+ today.getFullYear() + tMonth + tDay;

			if (getCookie("panalAlertClose") == cookieValue ){
				// 오늘 하루 그만 보기 이미 체크된 경우면 알림 화면 열지 않게 하기 위함
				isPop = false;
			}
		}

		$.ajax({
			url 		: "/GetDataList.do?cmd=getPanalAlertList",
			type 		: "post",dataType: "json",async: true,data:"",
			success : function(rv) {

				var lst = rv.DATA;
				var str = "";
				for ( var i = 0; i < lst.length; i++) {  //
					str += "<li><a class='li_icon'></a>"+lst[i].title+"&nbsp;<a class='li_link' url='"+lst[i].linkUrl+"'>[바로가기]</a></li>";
				}

				if( str != "") {
					$("#panalAlert").html(str);
					$("#panalAlertDiv").draggable();

					if (isPop){
						setTimeout(function(){
							$(".panalAlert").show();
						},50);
					}


					$(".li_link").click(function(){
						goSubPage('','','','',$(this).attr("url"));
					});
					$(".title_close").click(function(){
						$(".panalAlert").hide();
					});

					setTimeout(function(){$("#quick_menu05").show();},50);

					$("#btnPanalAlert").click(function() {
						if( $(".panalAlert").css("display") == "none" ) {
							$(".panalAlert").show();
						}else{
							$(".panalAlert").hide();
						}
					});
				}else{
					$("#panalAlert").html("");
					$("#quick_menu05").hide();
					$(".panalAlert").hide();
				}
			}
		});
	}

	// 오늘 하루 그만 보기 2020.03.19
	function closePanalAlert(sabun){
		$("#quick_menu05").show();
		$(".panalAlert").hide();

		var today = new Date();

	    var tMonth = today.getMonth() + 1
	    tMonth     = tMonth< 10 ? "0"+tMonth : tMonth;
	    var tDay   = today.getDate()
	    tDay       = tDay < 10 ? "0" + tDay : tDay;

		var cookieValue = sabun +"|"+ today.getFullYear() + tMonth + tDay;

		setCookie("panalAlertClose", cookieValue, 1000);

	}
*/