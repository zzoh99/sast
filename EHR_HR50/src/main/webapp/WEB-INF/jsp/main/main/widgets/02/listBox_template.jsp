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

			// 함수 내부에서 this 떼고 사용하기 위해 참조함
           	const curInfoIdx = this.curInfoIdx;
           	const curYearIdx = this.curYearIdx;
           	const companyYearlyTrendsValues = this.companyYearlyTrendsValues;
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

			// 함수 내부에서 this 떼고 사용하기 위해 참조함
           	const curInfoIdx = this.curInfoIdx;
           	const curYearIdx = this.curYearIdx;
           	const companyYearlyTrendsValues = this.companyYearlyTrendsValues;
		},

		/**
		 * 필요 내부 함수들 선언
		 */
		// 전년 대비 증감 관련 마크업 표시
		makeIncreDecreHTML: function(ratio){
//	 		console.log('makeIncreDecreHTML ratio', ratio);
			
			let increDecre = ' 동일'; // 증감
			
			if (ratio > 1) {
				increDecre = '<strong class="title_green">'+ ((ratio - 1) * 100).toFixed() +'%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div>';
			} else if (ratio < 1) {
				increDecre = '<strong class="title_red">'+ ((1 - ratio) * 100).toFixed() +'%</strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div>';
			}

			return increDecre;
		},

		/** */


		// UI 설정
		setUI: function(){
			// 드롭다운 관련
			const selectOptions = this.companyYearlyTrendsValues.reduce((a, c) => {
				a += '<div class="option" value="'+ c.year +'">'+ c.year +'년</div>\n';
				return a;
			}, '');

			$('#select203Year').html(selectOptions);
			$('#select203Year .selectedValue').text(this.curYear +'년');
		},

		// UI 이벤트 설저
		setUIEvent: function(){
			const _this = this; // scope 저장
			const $widget = this.$widget;

			// wide 일때 탭 클릭 시
			$widget.on("click", '.tab_menu', function () {
				$(this).siblings().removeClass("active");
				$(this).addClass("active");

// 				var tabId = $(this).attr("id");
				_this.curInfoIdx = $(this).index(); // 선택된 탭의 순서 저장

				_this.setDataWide();
				_this.drawChart(); // 차트 그리기
		  	});

			// 좌우 화살표 관련
			$widget.on('click', '.arrowLeft, .arrowRight', function(){
				const className = $(this).attr('class');
				console.log('$widget.on click className', className);

				if(className == 'arrowLeft'){
					_this.curInfoIdx--;
					if(_this.curInfoIdx < 0){
						_this.curInfoIdx = _this.infoTitles.length - 1;
					} 
				}
				else if(className == 'arrowRight'){
					_this.curInfoIdx++;
					if(_this.curInfoIdx > _this.infoTitles.length - 1){
						_this.curInfoIdx = 0;
					}
				}
								
				$(this).siblings('span').text(_this.infoTitles[_this.curInfoIdx]);

				_this.setDataMini();
			});
			
			// select(드롭다운) 관련
			$widget.on('click', '.select_options > .option', function(){
				var optionValue = $(this).attr('value');
				var optionText = $(this).text();
				console.log('optionValue', optionValue);
				
				_this.curYear = optionValue;
				_this.curYearIdx = $(this).index(); // 선택된 옵션의 순서 저장
				
				$(this).parent().parent().find('.selectedValue').text(optionText);

				_this.setDataMini();
			});
			
			$widget.on('click', '.select_toggle', function (e) {
			    if ($(this).closest(".custom_select").hasClass("disabled")) return;
			    if ($(this).closest(".custom_select").hasClass("readonly")) return;

			    e.stopPropagation();

			    $(".select_options").not($(this).next()).css("visibility", "hidden");
			    $(".select_toggle i")
			      .not($(this).find("i"))
			      .each(function () {
			        if ($(this).text() === "keyboard_arrow_up") {
			          $(this).text("keyboard_arrow_down");
			        } else if ($(this).text() === "arrow_drop_up") {
			          $(this).text("arrow_drop_down");
			        }
			      });

			    let optionsVisibility = $(this).next(".select_options").css("visibility");
			    $(this)
			      .next(".select_options")
			      .css(
			        "visibility",
			        optionsVisibility === "visible" ? "hidden" : "visible"
			      );

			    let icon = $(this).find("i");
			    switch (icon.text()) {
			      case "keyboard_arrow_down":
			        icon.text("keyboard_arrow_up");
			        break;
			      case "keyboard_arrow_up":
			        icon.text("keyboard_arrow_down");
			        break;
			      case "arrow_drop_down":
			        icon.text("arrow_drop_up");
			        break;
			      case "arrow_drop_up":
			        icon.text("arrow_drop_down");
			        break;
			    }
			});

		},


		// 차트 그리기
		drawChart: function(){

		},
		
	}
	
	
</script>
<div class="widget" id="widget203"></div>

<script>
	// DOM 로드 후에 UI 설정
	$(document).ready(function () {
		widget203.$widget = $('#'+ widget203.elemId);

		widget203.setUI(); // UI생성
		widget203.setUIEvent(); // 이벤트 할당
	});
</script>