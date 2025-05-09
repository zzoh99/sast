<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	var widget2 = {
		size: null
	};

	// 함수 설명
	function init_listBox701(size) {
		console.log('widget2', widget2);
		console.log('size', size);
		
		if (size === "wide"){
			loadWidget701();
		} else if (size === ("normal")){
			loadWidget701Mini();
		}
	}

	// 함수 설명
	function createWidget(direct, color){
		var code =
			'<div class="widget_body widget-common best-top">' +
			'  <div class="select-outer">' +
			'    <div class="custom_select no_style">' +
			'      <button class="select_toggle">' +
			'        <span>과장</span><i class="mdi-ico">arrow_drop_down</i>' +
			'      </button>' +
			'      <div class="select_options fix_width align_center">' +
			'        <button class="option jikwee" value="B0024">부장</button>' +
			'        <button class="option jikwee" value="B0065">차장</button>' +
			'        <button class="option jikwee" value="B0017">과장</button>' +
			'        <button class="option jikwee" value="B0021">대리</button>' +
			'        <button class="option jikwee" value="B0027">사원</button>' +
			'      </div>' +
			'    </div>' +
			'    <div class="toggle-wrap"></div>' +
			'  </div>' +
			'  <div class="bookmarks_title">' +
 			'    <a href="#"><i class="mdi-ico keyLeft">keyboard_arrow_left</i></a>' +
 			'    <span>상위Top 3</span>' +
 			'    <a href="#"><i class="mdi-ico keyRight">keyboard_arrow_right</i></a>' +
 			'  </div>' +
 			'  <div class="avatar-list">';
 			
		var html = '';

		for (var i = 0; i < 3 ; i++){
			html +=
				'<div>' +
				'  <span class="avatar-wrap">' +
				'    <span class="tag_icon ' + color + ' round">' + i + '</span>' +
				'    <span class="avatar"><img src="/common/images/common/img_photo.gif" id="' + direct + 'Wide' + i + '"></span>' +
				'  </span>' +
				'  <span class="name" id="' + direct + 'Name' + i + '"></span>' +
				'  <span class="team ellipsis" id="' + direct + 'OrgNm' + i + '"></span>' +
				'</div>';

		}

		html +=
			'  </div>' +
			'  <div class="speech-bubble">' +
			'    <span class="name">박주호<span class="team divider">Dev 개발/연구팀</span><span class="time divider">124시간 25분</span></span>' +
		    '  </div>' +
		    '</div>';
		
		document.querySelector('#createWidget').innerHTML = code + html;
	}

	function createWidgetWide(){
		var topHtml = '';
		var bottomHtml = '';
		
		for (var i = 1; i < 4; i++) {
			topHtml += '<div><span class="avatar-wrap"><span class="tag_icon green round">' + i + '</span><span class="avatar"><img'
		        + ' src="/common/images/common/img_photo.gif" id="topWide' + i + '"></span></span><span class="name" id="topName' + i + '"></span><span'
		        + ' class="team ellipsis" id="topOrgNm' + i + '"></span></div>';

		    if (i === 3) {
		    	topHtml += '</div><div class="speech-bubble"><span class="name">박주호<span class="team divider">'
		            	+ '본부장</span><span class="time divider">124시간 25분</span></span></div></div><div class="container_info avatar-type">'
		            	+ '<div class="list-title">하위 Top 3<span class="tag_icon red round"><i class="mdi-ico">trending_down</i></span>'
		            	+ '</div><div class="avatar-list">';
		    }
		}

		for (var k = 0; k < 3; k++) {
			bottomHtml += '<div><span class="avatar-wrap"><span class="tag_icon red round">' + k + '</span><span class="avatar"><img'
		        + ' src="/common/images/common/img_photo.gif" id="bottomWide' + k + '"></span></span><span class="name" id="bottomName' + k + '"></span><span'
		        + ' class="team ellipsis" id="bottomOrgNm' + k + '"></span></div>';

		    if (k === 3) {
		    	bottomHtml += '</div><div class="speech-bubble"><span class="name">박주호<span class="team divider">본부장</span><span'
		            + ' class="time divider">124시간 25분</span></span></div></div></div></div>';
		    }
		}

		var code = '<div class="widget_header toggle-wrap"><div class="widget_title">직급대비 급여 상/하위</div></div>'
		     + '<div class="widget_body attendance_contents annual-status overtime-work widget-common best-top">'
		     + '<div class="custom_select no_style"><button class="select_toggle">'
		     + '<span id="changeJikwee">과장</span><i class="mdi-ico">arrow_drop_down</i></button>'
		     + '<div class="select_options numbers">'
		     + '<button class="option jikwee" value="B0024">부장</button><button class="option jikwee" value="B0065">차장</button>'
		     + '<button class="option jikwee" value="B0017">과장</button><button class="option jikwee" value="B0021">대리</button>'
		     + '<button class="option jikwee" value="B0027">사원</button></div></div>'
		     + '<div class="container_box"><div class="container_info avatar-type">'
		     + '<div class="list-title">상위 Top 3<span class="tag_icon green round"><i class="mdi-ico">trending_up</i></span>'
		     + '</div><div class="avatar-list">'
		     + topHtml + bottomHtml;

		document.querySelector('#createWidget').insertAdjacentHTML('beforeend', code);
	}

	function loadWidget701Mini(check, checkColor){
		const salaryRank = ajaxCall('getListBox701List.do', '', false).data;

		if (typeof check == "undefined" || check == null || check == "") {
			check = 'top';
		}

		if (typeof checkColor == "undefined" || checkColor == null || checkColor == "") {
			checkColor = 'green'; 
		}
		
		createWidget(check, checkColor);

		if (check === 'top'){
			if (salaryRank.salaryRank.dataTop != null){
				for (var i = 0; i < salaryRank.salaryRank.dataTop.length ; i++){
					setWideImgFile(salaryRank.salaryRank.dataTop[i].sabun,i+1,salaryRank.salaryRank.enterCd);
		
					if ( salaryRank.salaryRank.dataTop[i].rank === 1 ){
						$('#topName1').text(salaryRank.salaryRank.dataTop[i].name);
						$('#topOrgNm1').text(salaryRank.salaryRank.dataTop[i].orgNm);
					}else if ( salaryRank.salaryRank.dataTop[i].rank === 2 ){
						$('#topName2').text(salaryRank.salaryRank.dataTop[i].name);
						$('#topOrgNm2').text(salaryRank.salaryRank.dataTop[i].orgNm);
					}else if ( salaryRank.salaryRank.dataTop[i].rank === 3 ){
						$('#topName3').text(salaryRank.salaryRank.dataTop[i].name);
						$('#topOrgNm3').text(salaryRank.salaryRank.dataTop[i].orgNm);
					}
				}
			}
		}else if ( check === 'bottom' ){
			if (salaryRank.salaryRank.dataBottom != null){
				
				for ( var k = 0; k < salaryRank.salaryRank.dataBottom.length ; k++){
					
					setBottomWideImgFile(salaryRank.salaryRank.dataBottom[k].sabun, k+1, salaryRank.salaryRank.enterCd);
					
					if ( salaryRank.salaryRank.dataBottom[k].rank === 1 ){
						$('#bottomName1').text(salaryRank.salaryRank.dataBottom[k].name);
						$('#bottomOrgNm1').text(salaryRank.salaryRank.dataBottom[k].orgNm);
					}else if ( salaryRank.salaryRank.dataBottom[k].rank === 2 ){
						$('#bottomName2').text(salaryRank.salaryRank.dataBottom[k].name);
						$('#bottomOrgNm2').text(salaryRank.salaryRank.dataBottom[k].orgNm);
					}else if ( salaryRank.salaryRank.dataBottom[k].rank === 3 ){
						$('#bottomName3').text(salaryRank.salaryRank.dataBottom[k].name);
						$('#bottomOrgNm3').text(salaryRank.salaryRank.dataBottom[k].orgNm);
					}
				}
			}
		}
	}
	
	function loadWidget701(){

		createWidgetWide();

		const salaryRank = ajaxCall('getListBox701List.do', '', false).data;

		if ( salaryRank.salaryRank.dataTop != null){
			
			for ( var i =0; i < salaryRank.salaryRank.dataTop.length ; i++  ){
	
				setWideImgFile(salaryRank.salaryRank.dataTop[i].sabun,i+1,salaryRank.salaryRank.enterCd);
	
				if ( salaryRank.salaryRank.dataTop[i].rank === 1 ){
					$('#topName1').text(salaryRank.salaryRank.dataTop[i].name);
					$('#topOrgNm1').text(salaryRank.salaryRank.dataTop[i].orgNm);
				}else if ( salaryRank.salaryRank.dataTop[i].rank === 2 ){
					$('#topName2').text(salaryRank.salaryRank.dataTop[i].name);
					$('#topOrgNm2').text(salaryRank.salaryRank.dataTop[i].orgNm);
				}else if ( salaryRank.salaryRank.dataTop[i].rank === 3 ){
					$('#topName3').text(salaryRank.salaryRank.dataTop[i].name);
					$('#topOrgNm3').text(salaryRank.salaryRank.dataTop[i].orgNm);
				}
			}
		}
		if ( salaryRank.salaryRank.dataBottom != null){
			
			for ( var k =0; k < salaryRank.salaryRank.dataBottom.length ; k++  ){
				
				setBottomWideImgFile(salaryRank.salaryRank.dataBottom[k].sabun,k+1,salaryRank.salaryRank.enterCd);
				
				if ( salaryRank.salaryRank.dataBottom[k].rank === 1 ){
					$('#bottomName1').text(salaryRank.salaryRank.dataBottom[k].name);
					$('#bottomOrgNm1').text(salaryRank.salaryRank.dataBottom[k].orgNm);
				}else if ( salaryRank.salaryRank.dataBottom[k].rank === 2 ){
					$('#bottomName2').text(salaryRank.salaryRank.dataBottom[k].name);
					$('#bottomOrgNm2').text(salaryRank.salaryRank.dataBottom[k].orgNm);
				}else if ( salaryRank.salaryRank.dataBottom[k].rank === 3 ){
					$('#bottomName3').text(salaryRank.salaryRank.dataBottom[k].name);
					$('#bottomOrgNm3').text(salaryRank.salaryRank.dataBottom[k].orgNm);
				}
			}
		}
	}
	console.log('오늘',new date().getfullyear())
	
	function setWideImgFile(sabun, i,enterCD){
	    $("#topWide"+i).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCD +"&searchKeyword="+sabun +"&t=" + (new Date()).getTime());
	}

	function setBottomWideImgFile(sabun, i,enterCD){
	    $("#bottomWide"+i).attr("src", "${ctx}/EmpPhotoOut.do?enterCd=" + enterCD +"&searchKeyword="+sabun +"&t=" + (new Date()).getTime());
	}

	$(document).ready(function() {
		$('.jikwee').click(function() {
		    var jikweeValue = $(this).attr('value');

			switch (jikweeValue){
			case 'B0024':
				$('#changeJikwee').text("부장");
				break;
			case 'B0065':
				$('#changeJikwee').text("차장");
				break;
			case 'B0017':
				$('#changeJikwee').text("과장");
				break;
			case 'B0021':
				$('#changeJikwee').text("대리");
				break;
			case 'B0027':
				$('#changeJikwee').text("사원");
				break;
			}
			
		    const { salaryRank } = ajaxCall('/getListBox701List.do', { jikwee: jikweeValue }, false).data;
			setCheckJikwee(salaryRank);

			  $('.select_options.numbers').css('visibility', 'hidden');
		});
	});


	$(document).ready(function() {
		$('.keyRight').click(function() {
		var dir = 'top';
		var color = 'green';
			loadWidget701Mini(dir,color);
		});
	});

	$(document).ready(function() {
		$('.keyLeft').click(function() {
			var dir = 'bottom';
			var color = 'red';
			loadWidget701Mini(dir,color);
		});
	});

	function setCheckJikwee(salaryRank){
		console.log('salaryRank',salaryRank.dataTop);
		if ( salaryRank.dataTop != null){
			
			for ( var i =0; i < salaryRank.dataTop.length ; i++  ){
	
				setWideImgFile(salaryRank.dataTop[i].sabun,i+1,salaryRank.enterCd);
	
				if ( salaryRank.dataTop[i].rank === 1 ){
					$('#topName1').text(salaryRank.dataTop[i].name);
					$('#topOrgNm1').text(salaryRank.dataTop[i].orgNm);
				}else if ( salaryRank.dataTop[i].rank === 2 ){
					$('#topName2').text(salaryRank.dataTop[i].name);
					$('#topOrgNm2').text(salaryRank.dataTop[i].orgNm);
				}else if ( salaryRank.dataTop[i].rank === 3 ){
					$('#topName3').text(salaryRank.dataTop[i].name);
					$('#topOrgNm3').text(salaryRank.dataTop[i].orgNm);
				}
			}
		}
		if ( salaryRank.dataBottom != null){
			
			for ( var k =0; k < salaryRank.dataBottom.length ; k++  ){
				
				setBottomWideImgFile(salaryRank.dataBottom[k].sabun,k+1,enterCd);
				
				if ( salaryRank.dataBottom[k].rank === 1 ){
					$('#bottomName1').text(salaryRank.dataBottom[k].name);
					$('#bottomOrgNm1').text(salaryRank.dataBottom[k].orgNm);
				}else if ( salaryRank.dataBottom[k].rank === 2 ){
					$('#bottomName2').text(salaryRank.dataBottom[k].name);
					$('#bottomOrgNm2').text(salaryRank.dataBottom[k].orgNm);
				}else if ( salaryRank.dataBottom[k].rank === 3 ){
					$('#bottomName3').text(salaryRank.dataBottom[k].name);
					$('#bottomOrgNm3').text(salaryRank.dataBottom[k].orgNm);
				}
			}
		}
	}

</script>
<div class="widget"  id="createWidget">
					</div>