<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 인사 > 승진후보자 현황
	 */

	var widget205 = {
		size: null
	};

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox205(size) {
		widget205.size = size;
		
		if (size == "normal"){
			createWidgetMini205();
			setDataWidgetMini205();
		} else if (size == ("wide")){
			createWidgetWide205();
			setDataWidgetWide205();
		}
	}

	// 위젯 mini html 코드 생성 
	function createWidgetMini205(){
		var code = 
						'<div class="widget_header">' +
					    '  <div class="widget_title">승진후보자 현황</div>' +
					    '  <i class="mdi-ico">more_horiz</i>' +
					    '</div>' +
					    '<div class="widget_body widget-common avatar-widget big">' +
					    '  <div class="bookmarks_title select-outer total-title">' +
					    '    <div class="custom_select no_style">' +
					    '      <button class="select_toggle select_toggle205">' +
					    '        <span id="rangeValue">전체</span><i class="mdi-ico">arrow_drop_down</i>' +
					    '      </button>' +
					    '      <!-- 개발 시 참고: numbers 클래스 시 날짜 셀렉트에 쓰임 -->' +
					    '      <div class="select_options numbers select_options205" style="visibility: hidden;">' +
					    '        <div class="option checkRange205" value="all">전체</div>' +
					    '        <div class="option checkRange205" value="team">팀별</div>' +
					    '        <div class="option checkRange205" value="head">본부별</div>' +
					    '      </div>' +
					    '    </div>' +
					    '    <span class="num" id="candidateCnt"></span>' +
					    '    <span class="unit">명</span>' +
					    '  </div>' +
					    '  <div class="bookmarks_wrap">' +
					    '    <div class="bookmark_list" id="candidateList">' +
					    '  </div>' +
			            '</div>';
		
		document.querySelector('#widget205Element').innerHTML = code;    
	}

	/*
	 * 위젯 mini 데이터 넣기  
	 * option -> all: 전체 , head: 본부, team: 팀
	 */
	function setDataWidgetMini205(option){
		const candidate = ajaxCall('getListBox205List.do', {option: option}, false).data.candidate;

		var html = '';

		if (candidate.dataList){
			for (var i = 0; i < candidate.dataList.length; i++){
				html += 
							'      <div>' +
							'        <div class="avatar-wrap">' +
							'          <span class="avatar"><img src="../assets/images/attendance_char_0.png" id="candidateImage' + (i+1) +'"></span>' +
							'        </div>' +
							'        <div class="profile-info">' +
							'          <span class="name" id="candidateName' + (i+1) + '">' +
							'            <span class="position" id="candidateJikwee' + (i+1) + '"></span>' +
							'          </span>' +
							'          <span class="team short ellipsis" id="candidateBuseo' + (i+1) + '"></span>' +
							'        </div>' +
							'      </div>';
			}
			
			document.querySelector('#candidateList').innerHTML = html;
	
			$('#candidateCnt').text(candidate.dataList.length);
			
			for (var i = 0; i < candidate.dataList.length; i++){
				$('#candidateImage'+ (i+1)).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + candidate.dataList[i].sabun + "&t=" + (new Date()).getTime());
		   		$('#candidateName' + (i+1)).text(candidate.dataList[i].name);
		   		$('#candidateBuseo' + (i+1)).text(candidate.dataList[i].buseo);
		   		$('#candidateJikwee' + (i+1)).text(candidate.dataList[i].jikweeNm);
			}
		}
	}

	// 위젯 wide html 코드 생성 
	function createWidgetWide205(){
		var code =
						'<div class="widget_header">' +
						'  <div class="widget_title">승진후보자 현황</div>' +
						'  <i class="mdi-ico">more_horiz</i>' +
						'</div>' +
						'<div class="widget_body widget-common avatar-widget big">' +
						'  <div class="bookmarks_title select-outer total-title">' +
						'    <div class="custom_select no_style">' +
						'      <button class="select_toggle select_toggle205">' +
					    '        <span id="rangeValue">전체</span><i class="mdi-ico">arrow_drop_down</i>' +
					    '      </button>' +
					    '      <div class="select_options numbers select_options205" style="visibility: hidden;">' +
					    '        <div class="option checkRange205" value="all">전체</div>' +
					    '        <div class="option checkRange205" value="team">팀별</div>' +
					    '        <div class="option checkRange205" value="head">본부별</div>' +
						'      </div>' +
						'    </div>' +
						'    <span class="num" id="candidateCntWide"></span>' +
						'    <span class="unit">명</span>' +
						'  </div>' +
						'  <div class="bookmarks_wrap multi-list" id="candidateWideList">' +  
						'  </div>' +
						'</div>';		
			
		document.querySelector('#widget205Element').innerHTML = code;
	}

	/*
	 * 위젯 wide 리스트 직위별 html코드, 데이터 넣기
	 * option 리스트기준 -> all: 전체, team: 팀, head: 본부
	 */
	function setDataWidgetWide205(option){
		const candidate = ajaxCall('getListBox205List.do', {option: option}, false).data.candidate;

		if (candidate.dataList){
			$('#candidateCntWide').text(candidate.dataList.length);
			
			const rangeList = new Array(candidate.data.length);
	
			for (let i = 0; i < candidate.data.length; i++) {
			    rangeList[i] = [];
	
			    // 각 직급별 데이터 생성
			    for (let j = 0; j < candidate.dataList.length; j++) {
			        if (candidate.dataList[j].jikweeNm == candidate.data[i].jikweeNm) {
			            rangeList[i].push(candidate.dataList[j]);
			        }
			    }
	
			    if (rangeList[i].length > 0) {
			        var html = 
							'    <div class="bookmark_inner-wrap">' +
							'      <div class="bookmark_list mt-30" id="promotedLeft' + (i+1) + '">' +
							'        <span class="total">' +
							'          <strong class="list-label" id="promotedName' + (i+1) + '"></strong>' +
							'        </span>' +
							'      </div>' +
							'      <div class="bookmark_list mt-30" id="promotedRight' + (i+1) + '"></div>' +
							'    </div>';
	
			        document.querySelector('#candidateWideList').insertAdjacentHTML('beforeend', html);
	
			        $('#promotedName' + (i+1)).text(candidate.data[i].jikweeNm + ' 승진후보자');
	
					for (let k = 0; k < rangeList[i].length; k++) {
						if ((k+1) % 2 == 1) {
							var sawonImageLeftId = 'sawonImageLeft' + (i+1) + '_' + (k+1); // 고유한 ID 생성
						    var sawonNameLeftId = 'sawonNameLeft' + (i+1) + '_' + (k+1);
						    var sawonJikweeLeftId = 'sawonJikweeLeft' + (i+1) + '_' + (k+1);
						    var sawonBuseoLeftId = 'sawonBuseoLeft' + (i+1) + '_' + (k+1);  
	
						    var innerHtml =   
							'        <div>' +
							'          <div class="avatar-wrap">' +
							'            <span class="avatar"><img src="../assets/images/attendance_char_0.png" id="' + sawonImageLeftId + '"></span>' +
							'          </div>' +
							'          <div class="profile-info">' +
							'            <span class="name" id="' + sawonNameLeftId + '">' +
							'              <span class="position" id="' + sawonJikweeLeftId + '"></span>' +
							'            </span>' +
							'            <span class="team short ellipsis" id="' + sawonBuseoLeftId + '"></span>' +
							'          </div>' +
							'        </div>';
						        
			                document.querySelector('#promotedLeft' + (i+1)).insertAdjacentHTML('beforeend', innerHtml);
	
						    $('#' + sawonImageLeftId).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + rangeList[i][k].sabun + "&t=" + (new Date()).getTime());
						    $('#' + sawonNameLeftId).text(rangeList[i][k].name);
						    $('#' + sawonBuseoLeftId).text(rangeList[i][k].buseo);
						    $('#' + sawonJikweeLeftId).text(rangeList[i][k].jikweeNm);
						    
			            } else if ((k+1) % 2 == 0) {
			            	var candidateImageRightId = 'candidateImageRight' + (i+1) + '_' + (k+1); // 고유한 ID 생성
			                var candidateNameRightId = 'candidateNameRight' + (i+1) + '_' + (k+1);
			                var candidateJikweeRightId = 'candidateJikweeRight' + (i+1) + '_' + (k+1);
			                var candidateBuseoRightId = 'candidateBuseoRight' + (i+1) + '_' + (k+1);
			                
			                var innerHtml = 
							'        <div>' +
							'          <div class="avatar-wrap">' +
							'            <span class="avatar"><img src="../assets/images/attendance_char_0.png" id="' + candidateImageRightId + '"></span>' +
							'          </div>' +
							'          <div class="profile-info">' +
							'            <span class="name" id="' + candidateNameRightId + '">' +
							'              <span class="position" id="' + candidateJikweeRightId + '"></span>' +
							'            </span>' +
							'            <span class="team short ellipsis" id="' + candidateBuseoRightId + '"></span>' +
							'          </div>' +
							'        </div>';
							
			                document.querySelector('#promotedRight' + (i+1)).insertAdjacentHTML('beforeend', innerHtml);
	
			                $('#' + candidateImageRightId).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + candidate.enterCd + "&searchKeyword=" + rangeList[i][k].sabun + "&t=" + (new Date()).getTime());
			                $('#' + candidateNameRightId).text(rangeList[i][k].name);
			                $('#' + candidateBuseoRightId).text(rangeList[i][k].buseo);
			                $('#' + candidateJikweeRightId).text(rangeList[i][k].jikweeNm);
			            }
			        }
			    }
			}
		}
	}

	/*
	 * 전체, 팀별, 본부별 클릭 함수
	 */
	$(document).ready(function() {
		var selectToggle = document.querySelector('.select_toggle205');
	    var selectOptions = document.querySelector('.select_options205');

	    $('#widget205Element').on('click', '.select_toggle205', function() {
	    	var selectOptions = document.querySelector('.select_options205');
	        if (selectOptions.style.visibility == 'hidden') {
	            selectOptions.style.visibility = 'visible';
	        } else {
	            selectOptions.style.visibility = 'hidden';
	        }
	    });

	    $('#widget205Element').on('click', '.checkRange205', function() {
		    var rangeValue = $(this).attr('value');

			switch (rangeValue){
			case 'all':
				$('#rangeValue').text("전체");
				break;
			case 'team':
				$('#rangeValue').text("팀별");
				break;
			case 'head':
				$('#rangeValue').text("본부별");
				break;
			}
			
			if (widget205.size == 'wide'){
				$('#candidateWideList').empty();
				setDataWidgetWide205(rangeValue);
			} else if (widget205.size == 'normal'){
				setDataWidgetMini205(rangeValue);
			} 

			selectOptions.style.visibility = 'hidden';
		});
	});
</script>
<div class="widget" id="widget205Element"></div>