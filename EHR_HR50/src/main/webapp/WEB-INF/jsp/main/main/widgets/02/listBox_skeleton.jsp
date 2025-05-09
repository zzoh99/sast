<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 3개년 채용 지수
	 */
	
	// 위젯 사이즈별 로드
	function init_listBox203(size) {
		if (size == "normal"){
			widget203.makeMini();
			widget203.setDataMini();
		} else if (size == ("wide")){
			widget203.makeWide();
			widget203.setDataWide();
			widget203.drawChart();
		}
	}

	var widget203 = {
		size: null,

		elemId: 'widget203',  // 위젯 엘리면트 id
		$widget: null,

		companyYearlyTrendsValues: null,  // 채용 지수 관련 데이터

		// 내부 변수들
		infoTitles: ['채용 성공률', '선발률', '수용률', '안정도', '기초율'],
	 	curInfoIdx: 0,
	 	curYear: null,
	 	curYearIdx: 0,

	 	// 작은 위젯 마크업 생성
	 	makeMini: function(){
	 		var html = '<div class="widget_header">'
		 		+ '</div>';

 			document.getElementById(this.elemId).innerHTML = html;
	 	},

	 	// 작은 위젯 데이터 표시
		setDataMini: function(){
			/**
			 {
              	"totalCnt": 90,  // 총 지원자
                "year": "2023",
                "rate": 70,  // 채용 성공률
                "remainCnt": 12,  // 잔류자
                "stabilityCnt": 23,  // 1년 이상 근속자
                "selectionCnt": 45,  // 합격자
                "acceptanceCnt": 35,  // 최종 입사자
                "successBaseCnt": 17  // 직무수행 성공자
              },
			 */
			if(this.companyYearlyTrendsValues == null) {
				this.companyYearlyTrendsValues = ajaxCall('/getListBox203List.do', '', false).data.companyYearlyTrendsValues.data;
				this.curYear = this.companyYearlyTrendsValues[0].year;
			}
	 	},

		// 와이드 위젯 마크업 생성
		makeWide: function(){
	 		var html = '<div class="widget_header">'
		 		+ '</div>';

 			document.getElementById(this.elemId).innerHTML = html;

		},

		// 와이드 위젯 데이터 표시
		setDataWide: function(){
			/**
			 {
             	"totalCnt": 90,  // 총 지원자
               "year": "2023",
               "rate": 70,  // 채용 성공률
               "remainCnt": 12,  // 잔류자
               "stabilityCnt": 23,  // 1년 이상 근속자
               "selectionCnt": 45,  // 합격자
               "acceptanceCnt": 35,  // 최종 입사자
               "successBaseCnt": 17  // 직무수행 성공자
             },
			 */
			if(this.companyYearlyTrendsValues == null) {
				this.companyYearlyTrendsValues = ajaxCall('/getListBox203List.do', '', false).data.companyYearlyTrendsValues.data;
				this.curYear = this.companyYearlyTrendsValues[0].year;
			}
		},


		/**
		 * 필요 내부 함수들 선언
		 */
// 		 makeIncreDecreHTML: function(ratio){
	
// 		 }

		/** */
		

		// UI 설정
		setUI: function(){

		},

		// UI 이벤트 설저
		setUIEvent: function(){

		},
		

		// 차트 그리기
// 		drawChart: function(){

// 		}
		
	}

	
</script>
<div class="widget" id="widget704"></div>

<script>
	// DOM 로드 후에 UI 설정
	$(document).ready(function () {
		widget203.$widget = $('#'+ widget203.elemId);

		widget203.setUI(); // UI생성
		widget203.setUIEvent(); // 이벤트 할당
	});
</script>