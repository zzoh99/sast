<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/assets/js/utility-script.js?ver=3"></script>
<script type="text/javascript">

	function search(){

		//좌측 타임라인 초기화
		let leftTimeline = document.getElementById('leftTimeLine');
		leftTimeline.innerHTML = '';
		//상세내역 초기화
		const details = document.getElementById('details');
		details.innerHTML = '';
		//상세내역 일자 초기화
		const detailDate = document.getElementById('detailDate');
		detailDate.innerHTML = '';

		const request = Utils.createRequestParameter({
			searchFrom : $('#searchFrom').val()
			, searchTo : $('#searchTo').val()
			, ordDetailCd : $('#ordDetailCd').val()
			, mainYn : ($("#mainYn").is(":checked")) ? 'Y' : ''
		});
		const response = ajaxCall('${ctx}/AppmtTimelineSrch.do?cmd=getAppmtTimelineList', request, false);
		if(response.Message === '') createLeftTimeline(response.DATA);

		//getAppmtTimelineOrd
		const currDate = new Date();
		const prevDate = new Date();
		prevDate.setMonth(currDate.getMonth() - 1);
		const currentYear = Utils.dateYear(currDate);
		const currentMonth = Utils.dateMonth(currDate);
		const currentDay = Utils.dateDay(currDate);
		const prevYear = Utils.dateYear(prevDate);
		const prevMonth = Utils.dateMonth(prevDate);
		const prevDay = Utils.dateDay(prevDate);

		const request2 = Utils.createRequestParameter({
			searchPrevYmd : prevYear + prevMonth + prevDay
			, searchYmd : currentYear + currentMonth + currentDay
			, searchPrevYm : prevYear + prevMonth
			, searchYm : currentYear + currentMonth
		});
		const response2 = ajaxCall('${ctx}/AppmtTimelineSrch.do?cmd=getAppmtTimelineOrd', request2, false);
		if(response2.Message === '') createEmployeeCount(response2.DATA);
	}

	/**
	 * 좌측 타임라인 요약 생성
	 * @param data
	 */
	function createLeftTimeline(data){

		let idx = 1;
		let sortData = [];
		//ordYmd sorting
		for(let i=0; i<data.length; i++){
			let ordData = getYmdData(sortData, data[i].ordYmd);
			if(ordData){
				ordData.data.push(data[i]);
			}else{
				sortData.push({
					idx : 1
					, ordYmd : data[i].ordYmd
					, data : [data[i]]
				});
				idx++;
			}

		}
		sortData = sortData.sort(function(a, b){
			return b.ordYmd - a.ordYmd;
		});

		let leftTimeline = document.getElementById('leftTimeLine');

		for(let i=0; i<sortData.length; i++){
			//wrapper
			let listWrap = document.createElement('div');
			listWrap.className = 'list';
			//dots
			let line = createLineDot();
			//content
			let contentWrap = document.createElement('div');
			contentWrap.className = 'content_box';
			//date
			let date = document.createElement('div');
			date.className = 'title';
			date.innerText = Utils.addDateSeparator(sortData[i].ordYmd, '.');
			//content
			let content = document.createElement('div');
			content.className = 'content';
			content.style.cursor = 'pointer';
			content.setAttribute('id', sortData[i].ordYmd);
			content.addEventListener('click', function(){
				searchDetail(sortData[i].ordYmd)
			});
			appendSummary(content, sortData[i].data);

			contentWrap.appendChild(date);
			contentWrap.appendChild(content);

			listWrap.appendChild(line);
			listWrap.appendChild(contentWrap);

			leftTimeline.appendChild(listWrap);
		}

		createDynamicDots();
		clickTrigger();
	}
	function getYmdData(data, key){
		for(let i=0; i<data.length; i++){
			if(data[i].ordYmd === key){
				return data[i];
			}
		}
	}
	function appendSummary(parent, data){
		for(let i=0; i<data.length; i++){
			let contentLine = document.createElement('div');
			contentLine.className = 'content_line';
			let ordName = document.createElement('span');
			ordName.className = 'type type1';//todo : ordDetailCd 에 따라 type 변경
			ordName.innerText = data[i].ordDetailNm;
			let name = document.createElement('span');
			name.className = 'name';
			name.innerText = data[i].name;
			let position = document.createElement('span');
			position.className = 'position';
			position.innerText = ' ' + data[i].jikweeNm;
			let dash = document.createElement('span');
			dash.innerText = ' - ';
			let team = document.createElement('span');
			team.className = 'team';
			team.innerText = data[i].orgNm;

			contentLine.appendChild(ordName);
			contentLine.appendChild(name);
			contentLine.appendChild(position);
			contentLine.appendChild(dash);
			contentLine.appendChild(team);

			if(data[i].cnt > 1){
				let cnt = document.createElement('span');
				cnt.innerText = ' 외 ' + (data[i].cnt - 1) + '건';
				contentLine.appendChild(cnt);
			}

			parent.appendChild(contentLine);
		}
	}
	function createLineDot(){
		let lineWrap = document.createElement('div');
		lineWrap.className = 'line';
		const circle = document.createElement('div');
		circle.className = 'time_line_circle';
		let box = document.createElement('div');
		box.className = 'time_line_dot_box';
		const dot = document.createElement('div');
		dot.className = 'time_line_dot';
		box.appendChild(dot);
		lineWrap.appendChild(circle);
		lineWrap.appendChild(box);
		return lineWrap;
	}

	/**
	 * 도트 동적 생성
	 */
	function createDynamicDots(){
		// dot_box 동적 생성
		$(".appointment_master_wrap .time_line_date")
				.find(".list")
				.each(function () {
					const dot_height = 6;
					const box_height = $(this).find(".time_line_dot_box").height();
					const number_dot = Math.floor(box_height / dot_height);

					for (let i = 1; i < number_dot; i++) {
						$(this)
								.find(".time_line_dot_box")
								.append('<div class="time_line_dot"></div>');
					}
				});
	}

	/**
	 * 검색 완료시 첫번째 컨텐츠 클릭 트리거
	 */
	function clickTrigger(){
		const contentList = $('.content', '#leftTimeLine');
		if(contentList.length > 0){
			$(contentList[0]).click();
		}
	}

	function activeList(ordYmd){
		let parent = document.getElementById(ordYmd).parentNode.parentNode.parentNode;
		let list = parent.getElementsByClassName('list');
		Utils.forEach(list, function(ele, idx){
			ele.className = 'list';
		});
		let parentList = document.getElementById(ordYmd).parentNode.parentNode;
		parentList.className = 'list active';
	}

	/**
	 * summary 클릭 이벤트
	 */
	function searchDetail(ordYmd){

		activeList(ordYmd);

		//상세내역 초기화
		const details = document.getElementById('details');
		details.innerHTML = '';
		//상세내역 일자 초기화
		const detailDate = document.getElementById('detailDate');
		detailDate.innerHTML = '';

		const request = {
			ordYmd : ordYmd
			, ordDetailCd : $('#ordDetailCd').val()
			, mainYn : ($("#mainYn").is(":checked")) ? 'Y' : ''
		};
		const response = ajaxCall('${ctx}/AppmtTimelineSrch.do?cmd=getAppmtTimelineDetailList', request, false);
		if(response.Message !== '') return;
		//발령 유형별 정렬
		let sortData = {};
		Utils.forEach(response.DATA, function(data, idx){
			//추가된 발령 유형이 있는 경우 -> 해당 배열에 데이터 추가
			if(sortData.hasOwnProperty(data.ordDetailCd)){
				sortData[data.ordDetailCd].data.push(data);
				sortData[data.ordDetailCd].cnt++;
			}
			//추가된 발령 유형이 없는 경우 -> 새로운 배열 할당
			else{
				sortData[data.ordDetailCd] = {
					ordDetailNm : data.ordDetailNm
					, cnt : 1
					, data : [data]
				};
			}
		});

		//우측 상세 ordYmd 일자 변경
		let date = document.createElement('span');
		date.setAttribute('id', 'selectedOrdYmd');
		date.className = 'date';
		date.innerText = Utils.addDateSeparator(ordYmd, '.');
		let detailText = document.createElement('span');
		detailText.innerText = '상세내역';
		detailDate.appendChild(date);
		detailDate.appendChild(detailText);

		createDetail(sortData);
	}

	/**
	 * 상세내역 생성
	 * @param data
	 */
	function createDetail(data){
		const details = document.getElementById('details');

		for(let key in data){
			let ord = data[key];

			let listWrap = document.createElement('div');
			listWrap.className = 'list type1';
			let title = document.createElement('p');
			title.className = 'title';
			let ordType = document.createElement('span');
			ordType.className = 'details_type';
			ordType.innerText = ord.ordDetailNm;
			let cnt = document.createElement('span');
			cnt.className = 'num';
			cnt.innerText = ' ' + ord.cnt + '건';
			title.appendChild(ordType);
			title.appendChild(cnt);

			listWrap.appendChild(title);

			let content = document.createElement('div');
			content.className = 'content';

			for(let i=0; i<ord.data.length; i++){
				let contentLine = document.createElement('div');
				contentLine.className = 'content_line';

				//프로필 이미지
				let first = document.createElement('div');
				first.className = 'first';
				let profile = document.createElement('div');
				profile.className = 'profile';
				let img = document.createElement('img');
				img.setAttribute('src', '../assets/images/salary_char_0.png');
				img.setAttribute('alt', '');
				profile.appendChild(img);
				first.appendChild(profile);
				//발령 내용 + 이름 + 직위
				let second = document.createElement('div');
				second.className = 'second';
				let type = document.createElement('span');
				type.className = 'type type1';
				type.innerText = ord.data[i].ordDetailNm;
				let nameWrap = document.createElement('p');
				let name = document.createElement('span');
				name.className = 'name';
				name.innerText = ord.data[i].name;
				let jikwee = document.createElement('span');
				jikwee.innerText = ' ' + ord.data[i].jikgubNm;
				nameWrap.appendChild(name);
				nameWrap.appendChild(jikwee);
				second.appendChild(type);
				second.appendChild(nameWrap);
				//사번 + 직책
				let third = document.createElement('div');
				third.className = 'third';
				let sabunWrap = document.createElement('p');
				let sabunIcon = document.createElement('i');
				sabunIcon.className = 'mdi-ico';
				sabunIcon.innerText = 'badge';
				let sabun = document.createElement('span');
				sabun.className = 'num';
				sabun.innerText = ord.data[i].sabun;
				sabunWrap.appendChild(sabunIcon);
				sabunWrap.appendChild(sabun);
				let positionWrap = document.createElement('p');
				let positionIcon = document.createElement('i');
				positionIcon.className = 'mdi-ico';
				positionIcon.innerText = 'assignment_ind';
				let position = document.createElement('span');
				position.className = 'position';
				position.innerText = ord.data[i].jikchakNm;
				positionWrap.appendChild(positionIcon);
				positionWrap.appendChild(position);
				third.appendChild(sabunWrap);
				third.appendChild(positionWrap);
				//메일 + 부서
				let fourth = document.createElement('div');
				fourth.className = 'fourth';
				let emailWrap = document.createElement('p');
				let emailIcon = document.createElement('i');
				emailIcon.className = 'mdi-ico';
				emailIcon.innerText = 'assignment_ind';
				let email = document.createElement('span');
				email.className = 'email';
				email.innerText = (ord.data[i].email === '') ? '-' : ord.data[i].email;
				emailWrap.appendChild(emailIcon);
				emailWrap.appendChild(email);
				let teamWrap = document.createElement('p');
				let teamIcon = document.createElement('i');
				teamIcon.className = 'mdi-ico';
				teamIcon.innerText = 'email';
				let team = document.createElement('span');
				team.className = 'team';
				team.innerText = ord.data[i].orgNm;
				teamWrap.appendChild(teamIcon);
				teamWrap.appendChild(team);
				fourth.appendChild(emailWrap);
				fourth.appendChild(teamWrap);

				contentLine.appendChild(first);
				contentLine.appendChild(second);
				contentLine.appendChild(third);
				contentLine.appendChild(fourth);

				content.appendChild(contentLine);
			}

			listWrap.appendChild(content);
			details.appendChild(listWrap);
		}

	}

	/**
	 * 전사 인원 현황
	 */
	function createEmployeeCount(data){
		for(let i=0; i<data.length; i++){
			let value = calcPercent(data[i].prevMonthCnt, data[i].currMonthCnt);
			let compare = document.createElement('div');

			let percent = document.createElement('span');
			percent.className = 'color';

			let status = document.createElement('span');
			status.className = 'status';

			let iconWrap = document.createElement('div');
			iconWrap.className = 'icon';
			let icon = document.createElement('i');
			icon.className = 'mdi-ico';
			iconWrap.appendChild(icon);

			let person = document.createElement('p');
			person.className = 'person';
			let num = document.createElement('span');
			num.className = 'num';
			num.innerText = data[i].currMonthCnt;
			let numCnt = document.createElement('span');
			numCnt.innerText = '명';
			person.appendChild(num);
			person.appendChild(numCnt);

			compare.innerHTML = '전달대비<br/>';
			compare.appendChild(percent);
			compare.appendChild(status);
			compare.appendChild(iconWrap);
			compare.appendChild(person);

			if(value >= 0){
				compare.className = 'compare increase';
				percent.innerText = value + '%';
				status.innerText = '증가';
				icon.innerText = 'trending_up';
			}else if(value < 0){
				compare.className = 'compare decrease';
				percent.innerText = (value * -1) + '%';
				status.innerText = '감소';
				icon.innerText = 'trending_down';
			}

			if(data[i].code === 'ALL'){
				document.getElementById('allCnt').appendChild(compare);
			}else if(data[i].code === 'EMP'){
				document.getElementById('empCnt').appendChild(compare);
			}else if(data[i].code === 'RET'){
				document.getElementById('retCnt').appendChild(compare);
			}else if(data[i].code === 'PER'){
				document.getElementById('perCnt').appendChild(compare);
			}else if(data[i].code === 'CON'){
				document.getElementById('conCnt').appendChild(compare);
			}
		}
	}
	function calcPercent(prev, curr){
		//증감율 계산
		if(prev === 0 && curr > 0){
			return 100;
		}else if(prev > 0 && curr === 0){
			return -100;
		}else if(prev === 0 && curr === 0){
			return 0;
		}else{
			let val = (curr - prev) / prev * 100;
			return (val === 0) ? 0 : (val).toFixed(2);
		}
	}

	function openSubmenu(menuCd, prgCd){
		window.top.goSubPage(menuCd, "", "", "", prgCd);
	}

	$(document).ready(function () {
		// 채용발령정보등록, 인사발령 입력 모달 발령값 변경

		// 발령 탭메뉴
		// $(".tab_menu").on("click", function () {
		// 	if ($(this).hasClass("summary")) {
		// 		$(".appointment_modal .table_bot").css("display", "revert");
		// 		$(".appointment_modal .sheet_area").css("display", "none");
		// 		$(".appointment_modal table.infant").css("display", "none");
		// 		$(".appointment_modal table.punishment").css("display", "none");
		// 	} else {
		// 		$(".appointment_modal .table_bot").css("display", "none");
		// 		$(".appointment_modal table.infant").css("display", "none");
		// 		$(".appointment_modal table.punishment").css("display", "none");
		// 		$(".appointment_modal .sheet_area").css("display", "revert");
		// 	}
		// });

		$("#searchFrom").val(addDate("m", -12,"${curSysYyyyMMdd}", "-"));

		//// 인사발령 마스터 발령 타임라인
		$(".appointment_master_wrap .time_line_date .list").on("click", function () {
			$(".appointment_master_wrap .time_line_date")
					.find(".list")
					.removeClass("active");
			$(this).addClass("active");
		});

		// 마지막 list의 blank_box 제거
		const lastList = $(".appointment_master_wrap .time_line_date .list").last();
		lastList.find(".blank_box").remove();





		$(".appointment_master_wrap .time_line_date .list i").mouseout(function (e) {
			$(".time_line_info").hide();
		});

		// datepicker
		$("#searchFrom").datepicker2({startdate : 'searchTo'});
		$("#searchTo").datepicker2({enddate : 'searchFrom'});

		//발령 목록
		const ordCodeList = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getOrdDetailCdList", false);
		const conversionCodeList = convCode(ordCodeList.codeList, '${ssnLocaleCd}' !== 'en_US' ? '<tit:txt mid="103895" mdef="전체"/>' : 'All');
		$('#ordDetailCd').html(conversionCodeList[2]);
		<%--var userCd1 = convCode(--%>
		<%--		.codeList--%>
		<%--		, ("${ssnLocaleCd}" != "en_US" ? "<tit:txt mid='103895' mdef='전체'/>" : "All")--%>
		<%--);	//발령종류--%>


		search();
	});

</script>

</head>
<body class="iframe_content">
<div class="main_tab_content main_content tab_layout">

	<!-- main_tab_content -->
	<main class="appointment_master_wrap">
		<div class="header">
			<div class="title_wrap">
				<i class="mdi-ico">badge</i>
				<span>인사 발령 마스터</span>
			</div>
			<!-- 우측 상단 버튼 그룹 -->
			<div class="button_wrap">
				<a href="#" class="btn filled icon_text" onclick="openSubmenu('02', 'RecApplicantReg.do?cmd=viewRecApplicantReg')">
					<i class="mdi-ico round">person_add_alt</i>채용발령
				</a>
				<a href="#"  class="btn filled icon_text" onclick="openSubmenu('02', 'LargeAppmtMgr.do?cmd=viewLargeAppmtMgr')">
					<i class="mdi-ico round">group_add</i>대량발령
				</a>
				<a href="#"  class="btn filled icon_text" onclick="openSubmenu('02', 'ExecAppmt.do?cmd=viewExecAppmt')">
					<i class="mdi-ico round">manage_accounts</i>인사발령
				</a>
			</div>
		</div>
		<table class="sheet_main">
			<colgroup>
				<col width="270px">
				<col width="10px">
				<col width>
			</colgroup>
			<tbody>
			<td>
				<!-- 좌측 레이어 -->
				<div class="container situation">
					<header>
						<i class="mdi-ico">groups</i>전사 인원 현황
					</header>
					<div id="allCnt" class="list">
						<span class="title">재직자수</span>
<%--						<div class="compare decrease">--%>
<%--							전달대비<br/>--%>
<%--							<span class="color">10%</span>--%>
<%--							<span class="status">감소</span>--%>
<%--							<div class="icon">--%>
<%--								<i class="mdi-ico">trending_down</i>--%>
<%--							</div>--%>
<%--							<p class="person">--%>
<%--								<span id="allCnt" class="num">0</span>명--%>
<%--							</p>--%>
<%--						</div>--%>
					</div>
					<div id="empCnt" class="list">
						<span class="title">신규 입사자</span>
<%--						<div class="compare increase">--%>
<%--							전달대비<br/>--%>
<%--							<span class="color">10%</span>--%>
<%--							<span class="status">증가</span>--%>
<%--							<div class="icon">--%>
<%--								<i class="mdi-ico">trending_up</i>--%>
<%--							</div>--%>
<%--							<p class="person">--%>
<%--								<span id="empCnt" class="num">0</span>명--%>
<%--							</p>--%>
<%--						</div>--%>
					</div>
					<div id="retCnt" class="list">
						<span class="title">퇴직자수</span>
<%--						<div class="compare decrease">--%>
<%--							전달대비<br/>--%>
<%--							<span class="color">10%</span>--%>
<%--							<span class="status">감소</span>--%>
<%--							<div class="icon">--%>
<%--								<i class="mdi-ico">trending_down</i>--%>
<%--							</div>--%>
<%--							<p class="person">--%>
<%--								<span id="retCnt" class="num">0</span>명--%>
<%--							</p>--%>
<%--						</div>--%>
					</div>
					<div id="perCnt" class="list">
						<span class="title">정규직</span>
<%--						<div class="compare increase">--%>
<%--							전달대비<br/>--%>
<%--							<span class="color">10%</span>--%>
<%--							<span class="status">증가</span>--%>
<%--							<div class="icon">--%>
<%--								<i class="mdi-ico">trending_up</i>--%>
<%--							</div>--%>
<%--							<p class="person">--%>
<%--								<span id="perCnt" class="num">0</span>명--%>
<%--							</p>--%>
<%--						</div>--%>
					</div>
					<div id="conCnt" class="list">
						<span class="title">계약직</span>
<%--						<div class="compare increase">--%>
<%--							전달대비<br/>--%>
<%--							<span class="color">10%</span>--%>
<%--							<span class="status">증가</span>--%>
<%--							<div class="icon">--%>
<%--								<i class="mdi-ico">trending_up</i>--%>
<%--							</div>--%>
<%--							<p class="person">--%>
<%--								<span id="conCnt" class="num">0</span>명--%>
<%--							</p>--%>
<%--						</div>--%>
					</div>
				</div>
			</td>
			<td></td>
			<td>
				<div class="container">
					<header>
						<i class="mdi-ico">bolt</i>발령 TIME LINE
					</header>
					<table class="basic type5 no_border table_top">
						<colgroup>
							<col width="72px">
							<col width="256px">
							<col width="72px">
							<col width="144px">
							<col width="72px">
							<col width>
						</colgroup>
						<tbody>
						<tr>
							<th>기간</th>
							<td class="two_more">
								<input class="date2 bbit-dp-input"
									   type="text" value="" id="searchFrom" />
								&nbsp;-&nbsp;
								<input class="date2 bbit-dp-input"
									   type="text" id="searchTo" value="${curSysYyyyMMddHyphen}" />
							</td>
							<th><tit:txt mid='ordDetail' mdef='발령'/></th>
							<td>
								<select id="ordDetailCd" class="custom_select">
<%--									<option value="">전체</option>--%>
<%--									<option value="Y">Y</option>--%>
<%--									<option value="N">N</option>--%>
								</select>
							</td>
							<th><tit:txt mid='mainYn' mdef='주요발령'/></th>
							<td class="two_more">
								<input type="checkbox" id="mainYn" class="form-checkbox type1" checked>
<%--								<button class="btn dark check">조회</button>--%>
								<btn:a href="javascript:search();" css="btn filled ml-auto" mid='110697' mdef="조회"/>
							</td>
						</tr>
						</tbody>
					</table>
					<table class="sheet_main white table_bot">
						<colgroup>
							<col width="250px">
							<col width>
						</colgroup>
						<tbody>
						<tr>
							<td>
								<div id="leftTimeLine" class="time_line_date">
									<!-- 좌측 요약 목록 -->
								</div>
							</td>
							<td class="details_wrap">
								<p id="detailDate" class="main_title">
<%--									<span id="selectedOrdYmd" class="date">2023.06.05</span>--%>
<%--									<span>상세내역</span>--%>
								</p>
								<div id="details" class="details">
								</div>
							</td>
						</tr>
						</tbody>
					</table>
				</div>
			</td>
			</tbody>
		</table>
	</main>
</div>
</body>
</html>
