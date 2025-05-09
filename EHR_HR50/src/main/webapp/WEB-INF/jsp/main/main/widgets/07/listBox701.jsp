<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 직급대비 급여 상/하위 
	 */
 
	var widget701 = {
		size: null
	};

	var currentJikwee = '';
	var currentDirection = '';
	var currentColor = '';

	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox701(size) {
		widget701.size = size;
		
		if (size == "normal"){
			createWidgetMini701();
			setDataWidgetMini701();
		} else if (size == ("wide")){
			createWidgetWide701();
			setDataWidgetWide701();
		}
	}
	
	/**
	 * 위젯 mini html 코드 생성 
	 * direction : 상/하위에 따른 화살표 방향
	 * color : 상/하위에 따른 숫자동그라미 색깔
	 */	
	function createWidgetMini701(direction, color){
		var code = 
				'<div class="widget_header">' +
                '  <div class="widget_title">직급대비 급여 상/하위</div>' +
              	'</div>' +
				'<div class="widget_body widget-common best-top">' + 
				'  <div class="select-outer">' +
				'    <div class="custom_select no_style">' + 
				'      <button class="select_toggle select_toggle701">' + 
				'        <span id="changeJikwee"></span><i class="mdi-ico">arrow_drop_down</i>' +
				'      </button>' +
				'      <div class="select_options numbers select_options701" style="visibility: hidden;" id="jikweeSelect">' +
				'      </div>' + 
				'    </div>' +
				'    <div class="toggle-wrap"></div>' +
				'  </div>' + 
				'  <div class="bookmarks_title">' +
				'    <a href="#" class="arrowLeft"><i class="mdi-ico">keyboard_arrow_left</i></a>' + 
				'    <span id="topBottom"></span>' + 
				'    <a href="#" class="arrowRight"><i class="mdi-ico">keyboard_arrow_right</i></a>' +
				'  </div>' +
				'  <div class="avatar-list" id="rankList">';
				
		var html = '';
		
		html += 
				'  </div>' +
				'  <div class="speech-bubble">' +
				'    <span class="name">박주호<span class="team divider">Dev 개발/연구팀</span><span class="time divider">124시간 25분</span></span>' +
				'  </div>' +
				'</div>';

		document.querySelector('#widget701Element').innerHTML = code + html;
	}

	/**
	 * 위젯 mini 데이터 넣기  
	 * direction : 상/하위에 따른 화살표 방향 (direction이 'top' -> 상위 , direction이 'bottom' -> 하위)
	 * color : 상/하위에 따른 숫자동그라미 색깔
	 */	
	function setDataWidgetMini701(direction, color, jikwee) {

        ajaxCall2("${ctx}/getListBox701List.do"
            , {jikwee: jikwee}
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.salaryRank) {

                    const salaryRank = data.data.salaryRank;

                    var html = '';

                    if (!direction) {
                        direction = 'top';
                        currentDirection = 'top';
                    }

                    if (!color) {
                        color = 'green';
                        currentColor = 'green';
                    }

                    var length = '';

                    if (direction === "top") {
                        length = salaryRank.dataTop.length;
                    } else if (direction === "bottom") {
                        length = salaryRank.dataBottom.length;
                    }

                    for (var i = 0; i < length; i++) {
                        html +=
                            `<div>
                                 <span class="avatar-wrap">
                                     <span class="tag_icon \${color} round">\${(i+1)}</span>
                                     <span class="avatar">
                                         <img src="/common/images/common/img_photo.gif" id="\${direction}Wide\${(i+1)}">
                                     </span>
                                 </span>
                                 <span class="name" id="\${direction}Name\${(i+1)}"></span>
                                 <span class="team ellipsis" id="\${direction}OrgNm\${(i+1)}"></span>
                             </div>`;
                    }

                    document.querySelector('#rankList').innerHTML = html;

                    if (direction === 'top') {
                        $('#topBottom').text('상위Top 3');
                    } else if (direction === 'bottom') {
                        $('#topBottom').text('하위Top 3');
                    }

                    var jikweeSelectHtml = '';

                    if (salaryRank.companyJikweeList != null) {
                        if (document.getElementById("changeJikwee").textContent.trim() == "") {
                            $('#changeJikwee').text(salaryRank.companyJikweeList[0].jikweeNm);
                        }

                        for (var i = 0; i < salaryRank.companyJikweeList.length; i++) {
                            jikweeSelectHtml += `<div class="option jikwee" value="\${salaryRank.companyJikweeList[i].jikweeCd}">\${salaryRank.companyJikweeList[i].jikweeNm}</div>`;

                        }

                        document.querySelector('#jikweeSelect').innerHTML = jikweeSelectHtml;
                    }

                    if (direction === 'top') {
                        if (salaryRank.dataTop != null) {
                            for (var i = 0; i < salaryRank.dataTop.length; i++) {
                                var $elem = $('#topWide' + (i+1));

                                setSalaryCompareImgFile($elem, salaryRank.dataTop[i].sabun, i+1, salaryRank.enterCd);

                                if (salaryRank.dataTop[i].rank == 1) {
                                    $('#topName1').text(salaryRank.dataTop[i].name);
                                    $('#topOrgNm1').text(salaryRank.dataTop[i].orgNm);
                                } else if (salaryRank.dataTop[i].rank == 2) {
                                    $('#topName2').text(salaryRank.dataTop[i].name);
                                    $('#topOrgNm2').text(salaryRank.dataTop[i].orgNm);
                                } else if (salaryRank.dataTop[i].rank == 3) {
                                    $('#topName3').text(salaryRank.dataTop[i].name);
                                    $('#topOrgNm3').text(salaryRank.dataTop[i].orgNm);
                                }
                            }
                        }
                    } else if (direction === 'bottom') {
                        if (salaryRank.dataBottom != null) {
                            for (var j = 0; j < salaryRank.dataBottom.length; j++) {
                                var $elem = $('#bottomWide' + (j+1));

                                setSalaryCompareImgFile($elem, salaryRank.dataBottom[j].sabun, j+1, salaryRank.enterCd);

                                if (salaryRank.dataBottom[j].rank == 1) {
                                    $('#bottomName1').text(salaryRank.dataBottom[j].name);
                                    $('#bottomOrgNm1').text(salaryRank.dataBottom[j].orgNm);
                                } else if (salaryRank.dataBottom[j].rank == 2) {
                                    $('#bottomName2').text(salaryRank.dataBottom[j].name);
                                    $('#bottomOrgNm2').text(salaryRank.dataBottom[j].orgNm);
                                } else if (salaryRank.dataBottom[j].rank == 3) {
                                    $('#bottomName3').text(salaryRank.dataBottom[j].name);
                                    $('#bottomOrgNm3').text(salaryRank.dataBottom[j].orgNm);
                                }
                            }
                        }
                    }
                }
            })
	}
	
	/*
	 * 위젯 wide html 코드 생성 
	 */
	function createWidgetWide701(){
		var code = 
				'<div class="widget_header toggle-wrap">' +
				'  <div class="widget_title">직급대비 급여 상/하위</div>' +
				'</div>' +
				'<div class="widget_body attendance_contents annual-status overtime-work widget-common best-top">' +
				'  <div class="custom_select no_style">' +
				'    <button class="select_toggle select_toggle701">' +
				'      <span id="changeJikwee">과장</span><i class="mdi-ico">arrow_drop_down</i>' +
				'    </button>' +
				'    <div class="select_options numbers select_options701 style="visibility: hidden;" id="jikweeSelect">' +
				'    </div>' +
				'  </div>' +
				'  <div class="container_box">' +
				'    <div class="container_info avatar-type">' +
				'      <div class="list-title">상위 Top 3<span class="tag_icon green round"><i class="mdi-ico">trending_up</i></span></div>' +
				'      <div class="avatar-list" id="topRankList">';
		
		var topHtml = '';
		var bottomHtml = '';
		
		topHtml += 
			    '      </div>' +
			    '      <div class="speech-bubble">' +
			    '        <span class="name">박주호' +
			    '          <span class="team divider">본부장</span>' +
			    '          <span class="time divider">124시간 25분</span>' +
			    '        </span>' +
			    '      </div>' +
			    '    </div>' +
			    '    <div class="container_info avatar-type">' +
			    '      <div class="list-title">하위 Top 3' +
			    '        <span class="tag_icon red round"><i class="mdi-ico">trending_down</i></span>' +
			    '      </div>' +
			    '      <div class="avatar-list" id="bottomRankList">';

		bottomHtml += 
			   	'      </div>' +
				'      <div class="speech-bubble">' +
				'        <span class="name">박주호<span class="team divider">Dev 개발/연구팀</span><span class="time divider">124시간 25분</span></span>' +
				'      </div>' +
				'    </div>' +
				'  </div>' +
				'</div>';

		document.querySelector('#widget701Element').innerHTML = code + topHtml + bottomHtml;
	}

	// 위젯 wide 데이터 넣기  
	function setDataWidgetWide701(jikwee) {

        ajaxCall2("${ctx}/getListBox701List.do"
            , {jikwee: jikwee}
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.salaryRank) {

                    const salaryRank = data.data.salaryRank;

                    var topHtml = '';
                    var bottomHtml = '';
                    for (var i = 0; i < salaryRank.dataTop.length; i++) {
                        topHtml +=
                            `<div>
                                 <span class="avatar-wrap">
                                     <span class="tag_icon green round">\${(i+1)}</span>
                                     <span class="avatar">
                                         <img src="/common/images/common/img_photo.gif" id="topWide\${(i+1)}">
                                     </span>
                                 </span>
                                 <span class="name" id="topName\${(i+1)}"></span>
                                 <span class="team ellipsis" id="topOrgNm\${(i+1)}"></span>
                             </div>`;
                    }

                    for (var j = 0; j < salaryRank.dataBottom.length; j++) {
                        bottomHtml +=
                            `<div>
                                 <span class="avatar-wrap">
                                     <span class="tag_icon red round">\${(j+1)}</span>
                                     <span class="avatar">
                                         <img src="/common/images/common/img_photo.gif" id="bottomWide\${(j+1)}">
                                     </span>
                                 </span>
                                 <span class="name" id="bottomName\${(j+1)}"></span>
                                 <span class="team ellipsis" id="bottomOrgNm\${(j+1)}"></span>
                             </div>`;
                    }

                    document.querySelector('#topRankList').innerHTML = topHtml;
                    document.querySelector('#bottomRankList').innerHTML = bottomHtml;

                    var jikweeSelectHtml = '';

                    if (salaryRank.companyJikweeList != null){
                        for (var i = 0; i < salaryRank.companyJikweeList.length; i++){
                            jikweeSelectHtml += `<div class="option jikwee" value="\${salaryRank.companyJikweeList[i].jikweeCd}">\${salaryRank.companyJikweeList[i].jikweeNm}</div>`;

                        }

                        document.querySelector('#jikweeSelect').innerHTML = jikweeSelectHtml;
                    }

                    if (salaryRank.dataTop != null) {
                        for (var i = 0; i < salaryRank.dataTop.length; i++) {
                            var $elem = $('#topWide' + (i+1));

                            setSalaryCompareImgFile($elem, salaryRank.dataTop[i].sabun, i+1, salaryRank.enterCd);

                            if (salaryRank.dataTop[i].rank == 1) {
                                $('#topName1').text(salaryRank.dataTop[i].name);
                                $('#topOrgNm1').text(salaryRank.dataTop[i].orgNm);
                            } else if (salaryRank.dataTop[i].rank == 2) {
                                $('#topName2').text(salaryRank.dataTop[i].name);
                                $('#topOrgNm2').text(salaryRank.dataTop[i].orgNm);
                            } else if (salaryRank.dataTop[i].rank == 3) {
                                $('#topName3').text(salaryRank.dataTop[i].name);
                                $('#topOrgNm3').text(salaryRank.dataTop[i].orgNm);
                            }
                        }
                    }

                    if (salaryRank.dataBottom != null) {
                        for (var j = 0; j < salaryRank.dataBottom.length; j++) {
                            var $elem = $('#bottomWide' + (j+1));

                            setSalaryCompareImgFile($elem, salaryRank.dataTop[j].sabun, salaryRank.enterCd);

                            if (salaryRank.dataBottom[j].rank == 1) {
                                $('#bottomName1').text(salaryRank.dataBottom[j].name);
                                $('#bottomOrgNm1').text(salaryRank.dataBottom[j].orgNm);
                            } else if (salaryRank.dataBottom[j].rank == 2) {
                                $('#bottomName2').text(salaryRank.dataBottom[j].name);
                                $('#bottomOrgNm2').text(salaryRank.dataBottom[j].orgNm);
                            } else if (salaryRank.dataBottom[j].rank == 3) {
                                $('#bottomName3').text(salaryRank.dataBottom[j].name);
                                $('#bottomOrgNm3').text(salaryRank.dataBottom[j].orgNm);
                            }
                        }
                    }
                }
            })
	}

	/**
	 * TODO: id 파라미터로 받고 메서드 하나로 합치기
	 * 회사코드, 사번, 현재시간으로 회원 사진 가져오기
	 * enterCD : 회사코드
	 * sabun : 사번
	 */	
	function setSalaryCompareImgFile($elem, sabun, enterCD){
		$elem.attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCD + "&searchKeyword=" + sabun + "&t=" + (new Date()).getTime());
	}

	// 셀렉트 박스 value값 리스트 메서드에 보내기, 왼쪽, 오른쪽 리스트 변경하기 
	$(document).ready(function() {
		var selectToggle = document.querySelector('.select_toggle701');
	    var selectOptions = document.querySelector('.select_options701');

	    $('#widget701Element').on('click', '.select_toggle701', function() {
	    	selectOptions = document.querySelector('.select_options701');
	        if (selectOptions.style.visibility == 'hidden') {
	            selectOptions.style.visibility = 'visible';
	        } else {
	            selectOptions.style.visibility = 'hidden';
	        }
	    });
		
		$('#widget701Element').on('click', '.jikwee', function() {
			var jikweeValue = $(this).attr('value');
			var jikweeText = $(this).text();
			currentJikwee = jikweeValue;
			
			if (widget701.size == "normal"){
				createWidgetMini701(currentDirection, currentColor);
				setDataWidgetMini701(currentDirection, currentColor, currentJikwee);
			} else if (widget701.size == "wide"){
				$('#widget701Element').empty();
				createWidgetWide701();
				setDataWidgetWide701(currentJikwee);
			}

			$('#changeJikwee').text(jikweeText);
			selectOptions.style.visibility = 'hidden';
		});
		
		$('#widget701Element').on('click', '.arrowRight, .arrowLeft', function() {
			if (currentDirection == "top"){
				currentDirection = "bottom";
				currentColor = "red";
				createWidgetMini701(currentDirection, currentColor);
				setDataWidgetMini701(currentDirection, currentColor, currentJikwee);
			} else if (currentDirection == "bottom"){
				currentDirection = "top";
				currentColor = "green";
				createWidgetMini701(currentDirection, currentColor);
				setDataWidgetMini701(currentDirection, currentColor, currentJikwee);
			}
		});
	});

	/**
	 * 직급에 따른 리스트 변경하기
	 * salaryRank : 직급
	 */	
	function setCheckJikwee(salaryRank){

		if (widget701.size = "normal"){

			
		}
		if (salaryRank.dataTop != null){
			for (var i = 0; i < salaryRank.dataTop.length; i++){
				var $elem = $('#topWide' + (i+1));
				
				setSalaryCompareImgFile($elem, salaryRank.dataTop[i].sabun, i+1, salaryRank.enterCd);
	
				if (salaryRank.dataTop[i].rank == 1){
					$('#topName1').text(salaryRank.dataTop[i].name);
					$('#topOrgNm1').text(salaryRank.dataTop[i].orgNm);
				} else if (salaryRank.dataTop[i].rank == 2){
					$('#topName2').text(salaryRank.dataTop[i].name);
					$('#topOrgNm2').text(salaryRank.dataTop[i].orgNm);
				} else if (salaryRank.dataTop[i].rank == 3){
					$('#topName3').text(salaryRank.dataTop[i].name);
					$('#topOrgNm3').text(salaryRank.dataTop[i].orgNm);
				}
			}
		}
		
		if (salaryRank.dataBottom != null){
			for (var j = 0; j < salaryRank.dataBottom.length; j++){
				var $elem = $('#bottomWide' + (j+1));
				
				setSalaryCompareImgFile($elem, salaryRank.dataBottom[j].sabun, j+1, salaryRank.enterCd);
				
				if (salaryRank.dataBottom[j].rank == 1){
					$('#bottomName1').text(salaryRank.dataBottom[j].name);
					$('#bottomOrgNm1').text(salaryRank.dataBottom[j].orgNm);
				} else if (salaryRank.dataBottom[j].rank == 2){
					$('#bottomName2').text(salaryRank.dataBottom[j].name);
					$('#bottomOrgNm2').text(salaryRank.dataBottom[j].orgNm);
				} else if (salaryRank.dataBottom[j].rank == 3){
					$('#bottomName3').text(salaryRank.dataBottom[j].name);
					$('#bottomOrgNm3').text(salaryRank.dataBottom[j].orgNm);
				}
			}
		}
	}
</script>
<div class="widget"  id="widget701Element"></div>