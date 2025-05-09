Apex.theme = {
	mode: "light",
	palette: "palette3"
};
Apex.chart = {
	/** 탭메뉴 전환 시 iframe 리사이즈 이벤트로 인해 오류 발생함에 따라 자동 리사이즈 설정 비활성화 처리 */
	redrawOnWindowResize: false,
	/** 언어 설정 */
	locales : [
		{
		  "name": "ko",
		  "options": {
		    "months": [
		      "1월",
		      "2월",
		      "3월",
		      "4월",
		      "5월",
		      "6월",
		      "7월",
		      "8월",
		      "9월",
		      "10월",
		      "11월",
		      "12월"
		    ],
		    "shortMonths": [
		      "1월",
		      "2월",
		      "3월",
		      "4월",
		      "5월",
		      "6월",
		      "7월",
		      "8월",
		      "9월",
		      "10월",
		      "11월",
		      "12월"
		    ],
		    "days": [
		      "일요일",
		      "월요일",
		      "화요일",
		      "수요일",
		      "목요일",
		      "금요일",
		      "토요일"
		    ],
		    "shortDays": ["일", "월", "화", "수", "목", "금", "토"],
		    "toolbar": {
		      "exportToSVG": "SVG 다운로드",
		      "exportToPNG": "PNG 다운로드",
		      "exportToCSV": "CSV 다운로드",
		      "menu": "메뉴",
		      "selection": "선택",
		      "selectionZoom": "선택영역 확대",
		      "zoomIn": "확대",
		      "zoomOut": "축소",
		      "pan": "패닝",
		      "reset": "원래대로"
		    }
		  }
		},
		{
		  "name": "en",
		  "options": {
		    "months": [
		      "January",
		      "February",
		      "March",
		      "April",
		      "May",
		      "June",
		      "July",
		      "August",
		      "September",
		      "October",
		      "November",
		      "December"
		    ],
		    "shortMonths": [
		      "Jan",
		      "Feb",
		      "Mar",
		      "Apr",
		      "May",
		      "Jun",
		      "Jul",
		      "Aug",
		      "Sep",
		      "Oct",
		      "Nov",
		      "Dec"
		    ],
		    "days": [
		      "Sunday",
		      "Monday",
		      "Tuesday",
		      "Wednesday",
		      "Thursday",
		      "Friday",
		      "Saturday"
		    ],
		    "shortDays": ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
		    "toolbar": {
		      "exportToSVG": "Download SVG",
		      "exportToPNG": "Download PNG",
		      "exportToCSV": "Download CSV",
		      "menu": "Menu",
		      "selection": "Selection",
		      "selectionZoom": "Selection Zoom",
		      "zoomIn": "Zoom In",
		      "zoomOut": "Zoom Out",
		      "pan": "Panning",
		      "reset": "Reset Zoom"
		    }
		  }
		}
	],
	defaultLocale : 'ko'
};
