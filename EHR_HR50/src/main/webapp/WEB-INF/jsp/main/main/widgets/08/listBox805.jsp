<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 근태 > 간주 근로자 현황
	 */

	var widget805 = {
		size: null
	};

	var overRankStandard = '';

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox805(size) {
		widget805.size = size;
		
		if (size == "normal"){
			createWidgetMini805();
			setDataWidgetMini805();
		} else if (size == ("wide")){
			createWidgetWide805();
			setDataWidgetWide805();
		}
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini805(){
		var html =
				'<div class="widget_header">' +
				'  <div class="widget_title">간주 근로자 현황</div>' +
				'</div>' +
				'<div class="widget_body widget-common avatar-widget">' +
				'  <div class="widget_body_title total-title"><span class="label">전체</span><span class="cnt" id="deemedWorkerCnt"></span><span class="unit">명</span></div>' +
				'  <div class="bookmarks_wrap">' +
				'    <div class="bookmark_list" id="deemedWorkerList">' +
				'    </div>' +
				'  </div>' +
				'</div>';

		document.querySelector('#widget805Element').innerHTML = html;
	}

	// 위젯 mini 데이터 넣기  
	function setDataWidgetMini805(){
		const deemedWorker = ajaxCall('getListBox805List.do', '', false).data;

		var html = '';

		for (var i = 0; i < deemedWorker.deemedWorkerData.length; i++){
			html +=
				'      <div>' +
				'        <div class="avatar"><img src="../assets/images/attendance_char_0.png" id="deemedImg' + (i+1) + '"></div>' +
				'        <span class="name" id="deemedName' + (i+1) + '"></span>' +
				'        <span class="position" id="deemedJikwee' + (i+1) + '"></span>' +
				'        <span class="team short" id="deemedOrgNm' + (i+1) + '"></span>' +
				'      </div>';
		}
	
		document.querySelector('#deemedWorkerList').innerHTML = html;

		setDataWidget805(deemedWorker.deemedWorkerData, deemedWorker.enterCd);
	}
	
	// 위젯 wide html 코드 생성
	function createWidgetWide805(){
		var html =
				'<div class="widget_header">' +
				'  <div class="widget_title">간주 근로자 현황</div>' +
				'  <i class="mdi-ico">more_horiz</i>' +
				'</div>' +
				'<div class="widget_body avatar-widget widget-common">' +
				'  <div class="bookmarks_title total-title"><span class="label">전체</span><span class="cnt" id="deemedWorkerCnt"></span><span class="unit">명</span></div>' +
				'  <div class="bookmarks_wrap">' +
				'    <div class="bookmark_list" id="deemedListLeft">' +
				'    </div>' +
				'    <div class="bookmark_list" id="deemedListRight">' +
				'    </div>' +
				'  </div>' +
				'</div>';
		
		document.querySelector('#widget805Element').innerHTML = html;
	}
	
 	// 위젯 wide html 코드 생성
	function setDataWidgetWide805(){
		var deemedWorker = ajaxCall('getListBox805List.do', '', false).data;
		deemedWorker = {
				enterCd: 'HR',
				deemedWorkerData: [
					{orgNm: '경남관리본부', jikweeNm: '차장', name: '강태길', sabun: '101123'},
					{orgNm: '자금팀', jikweeNm: '대리', name: '김원천', sabun: '101130'},
					{orgNm: '경남관리본부', jikweeNm: '사원', name: '김보학', sabun: '101133'},
					{orgNm: '경남관리본부', jikweeNm: '대리', name: '김룡배', sabun: '101136'},
					{orgNm: '경남관리본부', jikweeNm: '사원', name: '김재교', sabun: '101140'},
					{orgNm: '경남관리본부', jikweeNm: '과장', name: '안치미', sabun: '101153'},
				]
			};

		var leftHtml = '';
		var rightHtml = '';
		var deemedCount = deemedWorker.deemedWorkerData.length;
		
		for (var i = 1; i < deemedCount; i+=2){
			leftHtml += 
				'      <div>' +
				'        <div class="avatar"><img src="../assets/images/attendance_char_0.png" id="deemedImg' + i + '"></div>' +
				'        <span class="name" id="deemedName' + i + '"></span>' +
				'        <span class="position" id="deemedJikwee' + i + '"></span>' +
				'        <span class="team short" id="deemedOrgNm' + i + '"></span>' +
				'      </div>';
		}
	
		for (var i = 2; i < deemedCount+1 ; i+=2){
			rightHtml += 
				'      <div>' +
				'        <div class="avatar"><img src="../assets/images/attendance_char_0.png" id="deemedImg' + i + '"></div>' +
				'        <span class="name" id="deemedName' + i + '"></span>' +
				'        <span class="position" id="deemedJikwee' + i + '"></span>' +
				'        <span class="team short" id="deemedOrgNm' + i + '"></span>' +
				'      </div>';
		}

		document.querySelector('#deemedListLeft').innerHTML = leftHtml;
		document.querySelector('#deemedListRight').innerHTML = rightHtml;
		setDataWidget805(deemedWorker.deemedWorkerData, deemedWorker.enterCd);
	}

	function setDeemedImgFile($elem, sabun, enterCd){
		$elem.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCd + "&searchKeyword=" + sabun + "&t=" + (new Date()).getTime());
	}

	function setDataWidget805(deemedData, enterCd){
		for (var i = 0; i < deemedData.length; i++){
			var $elem = $('#deemedImg' + (i+1));
			
			$('#deemedName' + (i+1)).text(deemedData[i].name);
			$('#deemedJikwee' + (i+1)).text(deemedData[i].jikweeNm);
			$('#deemedOrgNm' + (i+1)).text(deemedData[i].orgNm);
			setDeemedImgFile($elem, deemedData[i].sabun, enterCd);
		}
			
		$('#deemedWorkerCnt').text(deemedData.length);
	}
	
</script>
<div class="widget" id="widget805Element"></div>