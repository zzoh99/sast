<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<link rel="stylesheet" href="/common/css/dotum.css" />
<link rel="stylesheet" href="/common/theme1/css/style.css" />
<script type="text/javascript" src="/common/js/jquery/1.9.0/jquery.min.js"></script>
<script type="text/javascript" src="/common/js/ui/1.10.0/jquery-ui.min.js"></script>
<script type="text/javascript" src="/common/js/jquery/datepicker_lang_KR.js"></script>
<script type="text/javascript" src="/common/js/jquery/jquery.datepicker.js"></script>
<script type="text/javascript" src="/common/js/common.js"></script>

<!-- 달력 사용시 스크립트 추가 -->
<script type="text/javascript" src="/common/js/jquery/fullcalendar.min.js"></script>

<!-- 달력 사용시 css 추가 -->
<link rel="stylesheet" href="/common/css/fullcalendar.css" />

<script type="text/javascript">
	$(document).ready(function () {
		var date = new Date();
		var d = date.getDate();
		var m = date.getMonth();
		var y = date.getFullYear();
		
		$('#calendar').fullCalendar({
			header: {
				left: '',
				center: 'prev ,title, next',
				right: ''
			},
			titleFormat : "yyyy. MMMM월",
			monthNames: [
			             '<span class="header_month">1</span>',
			             '<span class="header_month">2</span>',
			             '<span class="header_month">3</span>',
			             '<span class="header_month">4</span>',
			             '<span class="header_month">5</span>',
			             '<span class="header_month">6</span>',
			             '<span class="header_month">7</span>',
			             '<span class="header_month">8</span>',
			             '<span class="header_month">9</span>',
			             '<span class="header_month">10</span>',
			             '<span class="header_month">11</span>',
			             '<span class="header_month">12</span>'
			             ],
			dayNamesShort: ['일요일', '월요일', '화요일', '수요일', '목요일', '금요일', '토요일'],
			editable: false,
			
			// 일정 클릭시 이벤트
            eventClick: function(event) {
            	// 일정 클릭시 등록된 url로 팝업 띄움
            	alert( event.url );
            	return false;
            },
            // json 데이터 불러오기
            // 월이 변경될때마다 호출됨
			events: function(start, end, callback) {
		        $.ajax({
		            url: '/html/sample/myfeed.txt',
		            dataType: 'json',
		            data: {
		            	// 파라메터로 year, month를 보냄
		                year: end.getFullYear(),
		                month: end.getMonth()-1
		            },
		            // 에러시 이벤트
		            error: function() {
						alert('error!');
					},
					// 데이터 성공시 이벤트
		            success: function(doc) {
		                var events = [];
		                $(doc).each(function() {
		                    events.push({
		                        title: $(this).attr('title'),
		                        start: $(this).attr('start'),
		                        end: $(this).attr('end'),
		                        url: $(this).attr('url')
		                    });
		                });
		                callback(events);
		            }
		        });
		    }

		});
	});
</script>
<body>
<h3><tit:txt mid='104333' mdef='### 달력 ###'/></h3>
<div id='calendar'></div>
</body>
</html>
