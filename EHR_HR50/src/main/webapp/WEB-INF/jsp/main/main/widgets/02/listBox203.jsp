<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 인사 > 3개년 채용 지수
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

	const widget203 = {
		size: null,
		
		elemId: 'widget203',  // 위젯 엘리면트 id
		$widget: null,

	 	companyYearlyTrendsValues: null,  // 채용 지수 관련 데이터

	 	// 내부 변수들
	 	infoTitles: ['채용 성공률', '선발률', '수용률', '안정도'],
	 	curInfoIdx: 0,
	 	curYear: null,
	 	curYearIdx: 0,

	 	// 미니 위젯 마크업 생성
	 	makeMini: function(){
			var html = 
				'<div class="widget_header">' +
		        '  <div class="widget_title">3개년 채용 지수</div>' +
		        '</div>' +
		        '<div class="widget_body attendance_contents annual-status recruit-year">' +
		        '  <div class="bookmarks_title">' +
		        '    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' +
		        '    <span>채용 성공률</span>' +
		        '    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
		        '  </div>' +
		        '  <div class="container_left">' +
		        '    <div class="container_info">' +
		        '      <div class="select-outer">' +
		        '        <div class="custom_select no_style">' +
		        '          <button class="select_toggle">' +
		        '            <span class="selectedValue">2023년</span><i class="mdi-ico">arrow_drop_up</i>' +
		        '          </button>' +
		        '          <!-- 개발 시 참고: numbers 클래스 시 날짜 셀렉트에 쓰임 -->' +
		        '          <div class="select_options numbers" id="select203Year">' +
//	 	        '            <div class="option">2023년</div>' +
//	 	        '            <div class="option">2022년</div>' +
//	 	        '            <div class="option">2021년</div>' +
		        '          </div>' +
		        '        </div>' +
		        '      </div>' +
		        '      <span class="info_title_num" id="infoNum203">-<span class="info_title_num unit">%</span></span>' +
		        '      <span class="info_title num-desc" id="infoNumDesc203">-</span>' +
		        '      <span class="info_title desc" id="infoDescTitle203">작년 채용 대비</span>' +
		        '      <span class="info_title desc" id="infoDesc203"><strong class="title_green">10%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>' +
		        '    </div>' +
		        '  </div>' +
		        '</div>';

			document.getElementById(this.elemId).innerHTML = html;
		},

		// 작은 위젯 데이터 표시
		setDataMini: function(){
// 			console.log('setDataMini this.curInfoIdx', this.curInfoIdx);

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

			if(curInfoIdx == 0){ // 채용 성공률 = 잔류자/입사자
				// 올해
				const rate = companyYearlyTrendsValues[curYearIdx].rate; // 채용 성공률
// 				console.log('this.curYearIdx, rate', this.curYearIdx, rate);
				const remainCnt = companyYearlyTrendsValues[curYearIdx].remainCnt; // 최종 입사자
				const acceptanceCnt = companyYearlyTrendsValues[curYearIdx].acceptanceCnt; // 최종 입사자

				// 작년
				const prevYearIdx = this.curYearIdx + 1;
				let rateLast, remainCntLast, acceptanceCntLast;
				let increDecre = '';

				if(companyYearlyTrendsValues[prevYearIdx] != undefined){
					rateLast = companyYearlyTrendsValues[prevYearIdx].rate; // 채용 성공률
// 					remainCntLast = this.companyYearlyTrendsValues[prevYearIdx].remainCnt; // 잔류자
// 					acceptanceCntLast = this.companyYearlyTrendsValues[prevYearIdx].acceptanceCnt; // 최종 입사자

					const ratio = rate / rateLast;
					increDecre = this.makeIncreDecreHTML(ratio); // 증감 설명 마크업
				}

// 				document.getElementById('infoTitle203').innerHTML = '올해 채용 성공률';
				document.getElementById('infoNum203').innerHTML = rate +'<span class="info_title_num unit">%</span>';
				document.getElementById('infoNumDesc203').innerHTML = '잔류자/입사자 '+ remainCnt +'/'+ acceptanceCnt;
				document.getElementById('infoDescTitle203').innerHTML = '작년 채용 대비';
				document.getElementById('infoDesc203').innerHTML = increDecre;
			}
			else if(curInfoIdx == 1){ // 선발률 = 합격자/총 지원자
				// 올해
				const selectionCnt = companyYearlyTrendsValues[curYearIdx].selectionCnt;  // 합격자
				const totalCnt = companyYearlyTrendsValues[curYearIdx].totalCnt;  // 총 지원자
				const rate = selectionCnt / totalCnt;

				// 작년
				const prevYearIdx = curYearIdx + 1;
				let selectionCntLast, totalCntLast, rateLast;
				let increDecre = '';

				if(companyYearlyTrendsValues[prevYearIdx] != undefined){
					selectionCntLast = companyYearlyTrendsValues[prevYearIdx].selectionCnt;  // 합격자
					totalCntLast = companyYearlyTrendsValues[prevYearIdx].totalCnt;  // 총 지원자
					rateLast = selectionCntLast / totalCntLast;

					const ratio = rate / rateLast;
					increDecre = this.makeIncreDecreHTML(ratio); // 증감 설명 마크업
				}

// 				document.getElementById('infoTitle203').innerHTML = '올해 선발률';
				document.getElementById('infoNum203').innerHTML = 
					selectionCnt +'/<span class="info_title_num deno">'+ totalCnt +'</span><span class="info_title unit">명</span>';
				document.getElementById('infoNumDesc203').innerHTML = '합격자/총 지원자';
				document.getElementById('infoDescTitle203').innerHTML = '작년 합격자 대비';
				document.getElementById('infoDesc203').innerHTML = increDecre;
			}
			else if(curInfoIdx == 2){ // 수용률 = 최종 입사자/합격자
				// 올해
				const acceptanceCnt = companyYearlyTrendsValues[curYearIdx].acceptanceCnt; // 최종 입사자
				const selectionCnt = companyYearlyTrendsValues[curYearIdx].selectionCnt;  // 합격자
				const rate = acceptanceCnt / selectionCnt;
				
				// 작년
				const prevYearIdx = curYearIdx + 1;
				let acceptanceCntLast, selectionCntLast, rateLast;
				let increDecre = '';

				if(companyYearlyTrendsValues[prevYearIdx] != undefined){
					acceptanceCntLast = companyYearlyTrendsValues[prevYearIdx].acceptanceCnt; // 최종 입사자
					selectionCntLast = companyYearlyTrendsValues[prevYearIdx].selectionCnt;  // 합격자
					rateLast = acceptanceCntLast / selectionCntLast;

					const ratio = rate / rateLast;
					increDecre = this.makeIncreDecreHTML(ratio); // 증감 설명 마크업
				}

// 				document.getElementById('infoTitle203').innerHTML = '올해 수용률';
				document.getElementById('infoNum203').innerHTML = 
					acceptanceCnt + '/<span class="info_title_num deno">'+ selectionCnt +'</span><span class="info_title unit">명</span>';
				document.getElementById('infoNumDesc203').innerHTML = '최종 입사자/합격자';
				document.getElementById('infoDescTitle203').innerHTML = '작년 최종 입사자 대비';
				document.getElementById('infoDesc203').innerHTML = increDecre;
			}
			else if(curInfoIdx == 3){ // 안정도 = 1년 이상 근속자/최종 입사자
				// 올해
				const stabilityCnt = companyYearlyTrendsValues[curYearIdx].stabilityCnt;  // 1년 이상 근속자
				const acceptanceCnt = companyYearlyTrendsValues[curYearIdx].acceptanceCnt; // 최종 입사자
				const rate = stabilityCnt / acceptanceCnt;
				
				// 작년
				const prevYearIdx = curYearIdx + 1;
				let stabilityCntLast, acceptanceCntLast, rateLast;
				let increDecre = '';

				if(companyYearlyTrendsValues[prevYearIdx] != undefined){
					stabilityCntLast = companyYearlyTrendsValues[prevYearIdx].stabilityCnt;  // 1년 이상 근속자
					acceptanceCntLast = companyYearlyTrendsValues[prevYearIdx].acceptanceCnt; // 최종 입사자
					rateLast = stabilityCntLast / acceptanceCntLast;

					const ratio = rate / rateLast;
					increDecre = this.makeIncreDecreHTML(ratio); // 증감 설명 마크업
				}

// 				document.getElementById('infoTitle203').innerHTML = '올해 기준 안정도';
				document.getElementById('infoNum203').innerHTML = 
					stabilityCnt + '/<span class="info_title_num deno">'+ acceptanceCnt +'</span><span class="info_title unit">명</span>';
				document.getElementById('infoNumDesc203').innerHTML = '1년 이상 근속자/최종입사자';
				document.getElementById('infoDescTitle203').innerHTML = '작년 근속자 대비';
				document.getElementById('infoDesc203').innerHTML = increDecre;
			}
			else if(curInfoIdx == 4){ // 기초율 = 직무수행 성공자/총 지원자
				// 올해
				const successBaseCnt = companyYearlyTrendsValues[curYearIdx].successBaseCnt; // 직무수행 성공자
				const totalCnt = companyYearlyTrendsValues[curYearIdx].totalCnt;  // 총 지원자
				const rate = successBaseCnt / totalCnt;

				// 작년
				const prevYearIdx = curYearIdx + 1;
				let successBaseCntLast, totalCntLast, rateLast;
				let increDecre = '';

				if(companyYearlyTrendsValues[prevYearIdx] != undefined){
					successBaseCntLast = companyYearlyTrendsValues[prevYearIdx].successBaseCnt;  // 직무수행 성공자
					totalCntLast = companyYearlyTrendsValues[prevYearIdx].totalCnt; // 총 지원자
					rateLast = successBaseCntLast / totalCntLast;

					const ratio = rate / rateLast;
					increDecre = this.makeIncreDecreHTML(ratio); // 증감 설명 마크업
				}

// 				document.getElementById('infoTitle203').innerHTML = '올해 기초율';
				document.getElementById('infoNum203').innerHTML = 
					successBaseCnt + '/<span class="info_title_num deno">'+ totalCnt +'</span><span class="info_title unit">명</span>';
				document.getElementById('infoNumDesc203').innerHTML = '직무수행 성공자/총 지원자';
				document.getElementById('infoDescTitle203').innerHTML = '작년 직무수행 성공자 대비';
				document.getElementById('infoDesc203').innerHTML = increDecre;
			}
		},

		// 와이드 위젯 마크업 생성
		makeWide: function(){
			var html =
				'<div class="widget_header">' +
		        '  <div class="widget_title">3개년 채용 지수</div>' +
		        '</div>' +
		        '<div class="widget_body widget-common timeList-widget attendance_contents annual-status index-3year">' +
		        '  <div class="bookmarks_title">' +
		        '    <div class="tab_wrap">' +
		        '      <div class="tab_menu active" id="successRatio">채용 성공률</div>' +
		        '      <div class="tab_menu" id="selectionRatio">선발률</div>' +
		        '      <div class="tab_menu" id="acceptanceRatio">수용률</div>' +
		        '      <div class="tab_menu" id="stability">안정도</div>' +
		        //'      <div class="tab_menu" id="baseRate">기초율</div>' +
		        '    </div>' +
		        '  </div>' +
		        '  <div class="container_box">' +
		        '    <div class="container_left">' +
		        '      <div class="container_info">' +
		        '        <span class="info_title label" id="infoTitle203">-</span>' +
		        '        <span class="info_title_num" id="infoNum203">-<span class="info_title_num unit">%</span></span>' +
//	 	        '        <span class="info_title_num" id="infoNum203">36/<span class="info_title_num deno">40</span><span class="info_title unit">명</span></span>' +
		        '        <span class="info_title num-desc" id="infoNumDesc203"></span>' +
		        '        <span class="info_title desc" id="infoDesc203">작년 채용 대비<strong class="title_green">10%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>' +
//	 	        '        <span class="info_title desc" id="infoDesc203">작년 채용 대비<strong class="title_red">10%</strong>감소<div class="tag_icon red round"><i class="mdi-ico">trending_down</i></div></span>' +
		        '      </div>' +
		        '    </div>' +
		        '    <div class="container_right">' +
		        '      <div class="chart-wrap">' +
		        '        <div id="chart203"></div>' +
		        '      </div>' +
		        '    </div>' +
		        '  </div>' +
		        '</div>';

			document.getElementById(this.elemId).innerHTML = html;
		},

		// 와이드 위젯 데이터 표시
		setDataWide: function(){
			console.log('setDataWide this.curInfoIdx', this.curInfoIdx);
			
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

			if(curInfoIdx == 0){ // 채용 성공률 = 잔류자/입사자
				// 올해
				const rate = companyYearlyTrendsValues[curYearIdx].rate; // 채용 성공률
// 				console.log('curYearIdx, rate', curYearIdx, rate);
				const remainCnt = companyYearlyTrendsValues[curYearIdx].remainCnt; // 최종 입사자
				const acceptanceCnt = companyYearlyTrendsValues[curYearIdx].acceptanceCnt; // 최종 입사자

				// 작년
				const prevYearIdx = curYearIdx + 1;
				let rateLast, remainCntLast, acceptanceCntLast;
				let increDecre = '';

				if(companyYearlyTrendsValues[prevYearIdx] != undefined){
					rateLast = companyYearlyTrendsValues[prevYearIdx].rate; // 채용 성공률
// 					remainCntLast = companyYearlyTrendsValues[prevYearIdx].remainCnt; // 잔류자
// 					acceptanceCntLast = companyYearlyTrendsValues[prevYearIdx].acceptanceCnt; // 최종 입사자

					const ratio = rate / rateLast;
					increDecre = this.makeIncreDecreHTML(ratio); // 증감 설명 마크업
				}
				
				document.getElementById('infoTitle203').innerHTML = '올해 채용 성공률';
				document.getElementById('infoNum203').innerHTML = rate +'<span class="info_title_num unit">%</span>';
				document.getElementById('infoNumDesc203').innerHTML = '잔류자/입사자 '+ remainCnt +'/'+ acceptanceCnt;
// 				document.getElementById('infoDescTitle203').innerHTML = '작년 채용 대비';
				document.getElementById('infoDesc203').innerHTML = '작년 채용 대비'+ increDecre;
			}
			else if(curInfoIdx == 1){ // 선발률 = 합격자/총 지원자
				// 올해
				const selectionCnt = companyYearlyTrendsValues[curYearIdx].selectionCnt;  // 합격자
				const totalCnt = companyYearlyTrendsValues[curYearIdx].totalCnt; // 총 지원자
				const rate = selectionCnt / totalCnt;
				
				// 작년
				const prevYearIdx = curYearIdx + 1;
				let selectionCntLast, totalCntLast, rateLast;
				let increDecre = '';

				if(companyYearlyTrendsValues[prevYearIdx] != undefined){
					selectionCntLast = companyYearlyTrendsValues[prevYearIdx].selectionCnt;  // 합격자
					totalCntLast = companyYearlyTrendsValues[prevYearIdx].totalCnt; // 총 지원자
					rateLast = selectionCntLast / totalCntLast;

					const ratio = rate / rateLast;
					increDecre = this.makeIncreDecreHTML(ratio); // 증감 설명 마크업
				}

				document.getElementById('infoTitle203').innerHTML = '올해 선발률';
				document.getElementById('infoNum203').innerHTML = 
					selectionCnt + '/<span class="info_title_num deno">'+ totalCnt +'</span><span class="info_title unit">명</span>';
				document.getElementById('infoNumDesc203').innerHTML = '합격자/총 지원자';
// 				document.getElementById('infoDescTitle203').innerHTML = '작년 합격자 대비';
				document.getElementById('infoDesc203').innerHTML = '작년 합격자 대비'+ increDecre;
			}
			else if(curInfoIdx == 2){ // 수용률 = 최종 입사자/합격자
				// 올해
				const acceptanceCnt = companyYearlyTrendsValues[curYearIdx].acceptanceCnt; // 최종 입사자
				const selectionCnt = companyYearlyTrendsValues[curYearIdx].selectionCnt;  // 합격자
				const rate = acceptanceCnt / selectionCnt;
				
				// 작년
				const prevYearIdx = curYearIdx + 1;
				let acceptanceCntLast, selectionCntLast, rateLast;
				let increDecre = '';

				if(companyYearlyTrendsValues[prevYearIdx] != undefined){
					acceptanceCntLast = companyYearlyTrendsValues[prevYearIdx].acceptanceCnt; // 최종 입사자
					selectionCntLast = companyYearlyTrendsValues[prevYearIdx].selectionCnt;  // 합격자
					rateLast = acceptanceCntLast / selectionCntLast;

					const ratio = rate / rateLast;
					increDecre = this.makeIncreDecreHTML(ratio); // 증감 설명 마크업
				}
				
				document.getElementById('infoTitle203').innerHTML = '올해 수용률';
				document.getElementById('infoNum203').innerHTML = 
					acceptanceCnt + '/<span class="info_title_num deno">'+ selectionCnt +'</span><span class="info_title unit">명</span>';
				document.getElementById('infoNumDesc203').innerHTML = '최종 입사자/합격자';
// 				document.getElementById('infoDescTitle203').innerHTML = '작년 최종 입사자 대비';
				document.getElementById('infoDesc203').innerHTML = '작년 최종 입사자 대비'+ increDecre;
			}
			else if(curInfoIdx == 3){ // 안정도 = 1년 이상 근속자/최종 입사자
				// 올해
				const stabilityCnt = companyYearlyTrendsValues[curYearIdx].stabilityCnt;  // 1년 이상 근속자
				const acceptanceCnt = companyYearlyTrendsValues[curYearIdx].acceptanceCnt; // 최종 입사자
				const rate = stabilityCnt / acceptanceCnt;
				
				// 작년
				const prevYearIdx = curYearIdx + 1;
				let stabilityCntLast, acceptanceCntLast, rateLast;
				let increDecre = '';

				if(companyYearlyTrendsValues[prevYearIdx] != undefined){
					stabilityCntLast = companyYearlyTrendsValues[prevYearIdx].stabilityCnt;  // 1년 이상 근속자
					acceptanceCntLast = companyYearlyTrendsValues[prevYearIdx].acceptanceCnt; // 최종 입사자
					rateLast = stabilityCntLast / acceptanceCntLast;

					const ratio = rate / rateLast;
					increDecre = this.makeIncreDecreHTML(ratio); // 증감 설명 마크업
				}

				document.getElementById('infoTitle203').innerHTML = '올해 기준 안정도';
				document.getElementById('infoNum203').innerHTML = 
					stabilityCnt + '/<span class="info_title_num deno">'+ acceptanceCnt +'</span><span class="info_title unit">명</span>';
				document.getElementById('infoNumDesc203').innerHTML = '1년 이상 근속자/최종입사자';
// 				document.getElementById('infoDescTitle203').innerHTML = '작년 근속자 대비';
				document.getElementById('infoDesc203').innerHTML = '작년 근속자 대비'+ increDecre;
			}
			else if(curInfoIdx == 4){ // 기초율 = 직무수행 성공자/총 지원자
				// 올해
				const successBaseCnt = companyYearlyTrendsValues[curYearIdx].successBaseCnt; // 직무수행 성공자
				const totalCnt = companyYearlyTrendsValues[curYearIdx].totalCnt;  // 총 지원자
				const rate = successBaseCnt / totalCnt;

				// 작년
				const prevYearIdx = curYearIdx + 1;
				let successBaseCntLast, totalCntLast, rateLast;
				let increDecre = '';

				if(companyYearlyTrendsValues[prevYearIdx] != undefined){
					successBaseCntLast = companyYearlyTrendsValues[prevYearIdx].successBaseCnt;  // 직무수행 성공자
					totalCntLast = companyYearlyTrendsValues[prevYearIdx].totalCnt; // 총 지원자
					rateLast = successBaseCntLast / totalCntLast;

					const ratio = rate / rateLast;
					increDecre = this.makeIncreDecreHTML(ratio); // 증감 설명 마크업-
				}

				document.getElementById('infoTitle203').innerHTML = '올해 기초율';
				document.getElementById('infoNum203').innerHTML = 
					successBaseCnt + '/<span class="info_title_num deno">'+ totalCnt +'</span><span class="info_title unit">명</span>';
				document.getElementById('infoNumDesc203').innerHTML = '직무수행 성공자/총 지원자';
// 				document.getElementById('infoDescTitle203').innerHTML = '작년 직무수행 성공자 대비';
				document.getElementById('infoDesc203').innerHTML = '작년 직무수행 성공자 대비'+ increDecre;
			}

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

		// UI 이벤트 설정
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
				$(this).parent().css("visibility", "hidden");

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
			// 함수 내부에서 this 떼고 사용하기 위해 참조함
           	const curInfoIdx = this.curInfoIdx;
           	const companyYearlyTrendsValues = this.companyYearlyTrendsValues;
           	
			const years = [], data_1 = [], data_2 = [], names = [];

			if(curInfoIdx == 0){ // 채용 성공률 = 잔류자/입사자
				names.push('잔류자');
				names.push('입사자');

				for (var i = 0; i < companyYearlyTrendsValues.length; i++) {
					data_1.push(companyYearlyTrendsValues[i].remainCnt); // 잔류자
					data_2.push(companyYearlyTrendsValues[i].acceptanceCnt); // 최종 입사자
					
					years.push(companyYearlyTrendsValues[i].year);
				}
			}
			else if(curInfoIdx == 1){ // 선발률 = 합격자/총 지원자
				names.push('합격자');
				names.push('총 지원자');

				for (var i = 0; i < companyYearlyTrendsValues.length; i++) {
	            	data_1.push(companyYearlyTrendsValues[i].selectionCnt); // 합격자
	            	data_2.push(companyYearlyTrendsValues[i].totalCnt); // 최종 입사자
	            	years.push(companyYearlyTrendsValues[i].year);
				}
			}
			else if(curInfoIdx == 2){ // 수용률 = 최종 입사자/합격자
				names.push('최종 입사자');
				names.push('합격자');

		        for (var i = 0; i < companyYearlyTrendsValues.length; i++) {
			        data_1.push(companyYearlyTrendsValues[i].acceptanceCnt); // 최종 입사자
			        data_2.push(companyYearlyTrendsValues[i].selectionCnt); // 합격자
		            years.push(companyYearlyTrendsValues[i].year);
		        }
			}
			else if(curInfoIdx == 3){ // 안정도 = 1년 이상 근속자/최종 입사자
				names.push('1년 이상 근속자');
				names.push('최종 입사자');

				for (var i = 0; i < companyYearlyTrendsValues.length; i++) {
					data_1.push(companyYearlyTrendsValues[i].stabilityCnt); // 1년 이상 근속자
		            data_2.push(companyYearlyTrendsValues[i].acceptanceCnt); // 최종 입사자
		            
		            years.push(companyYearlyTrendsValues[i].year);
		        }
			}
			else if(curInfoIdx == 4){ // 기초율 = 직무수행 성공자/총 지원자
				names.push('직무수행 성공자');
				names.push('총 지원자');

				for (var i = 0; i < companyYearlyTrendsValues.length; i++) {
		            data_1.push(companyYearlyTrendsValues[i].successBaseCnt); // 직무수행 성공자
		            data_2.push(companyYearlyTrendsValues[i].totalCnt); // 총 지원자
		            
		            years.push(companyYearlyTrendsValues[i].year);
				}
			}

			var options = {
				series: [{
	                name: names[0], // 색인
	                  data: data_1, // 데이터
	                  color: '#2570f9'
	              }, {
	                name: names[1], // 색인
	                  data: data_2, // 데이터
	                color: '#777777'
	              }],
	            chart: {
	              type: 'bar', 
	                height: 143,
	                width: 238,
	                toolbar: {
	                      show: false
	                  }
	                },
	            plotOptions: {
	              bar: {
	                horizontal: false, 
	                    dataLabels: {
	                      position: 'top',
	                    },
	                    columnWidth: 5,
	              }
	            },
	            legend: {
	              position: 'top',
	                  horizontalAlign: 'right'
	            },
	            dataLabels: {
	              enabled: false,
	                offsetX: -6,
	                style: {
	                  fontSize: '12px',
	                    colors: ['#fff']
	                }
	            },
	            stroke: {
	              show: true,
	                width: 1,
	                colors: ['#fff']
	              },
	            tooltip: {
	              shared: true,
	                intersect: false
	            },
	            xaxis: {
	              categories: years// 연도
	            },
	            yaxis: {
	              show: false,
	              tickAmount: 4,
	            },
	          };

	        document.getElementById("chart203").innerHTML = '';
	        var chart = new ApexCharts(document.getElementById("chart203"), options);
	        chart.render();
		},
		
		
	};
	
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