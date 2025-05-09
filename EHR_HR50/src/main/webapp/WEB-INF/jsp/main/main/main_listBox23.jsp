<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%/*-----------------------------------------------------------------------------
                                                         출근/퇴근
---------------------------------------------------------------------------------*/%>
<script type="text/javascript">
var widgetContent23;
var widget23classNm;

var toTime = "";
var time_seconds = 0;
var isTimeView = false;

function main_listBox23(title, info, classNm, seq ){

	if(classNm == null || classNm == undefined){
		classNm = "box_250";
	}
	
	widget23classNm = classNm;

	$("#listBox23").attr("seq", seq);

	loadApp23(1 , 0, classNm);
}


function loadApp23( page , mode23 , classNm){

	var list = null;
	var ipChk = "Y";		// ipChk N에서 Y로 변경 체크 안함
	isTimeView = false;

	$.ajax({
		url 		: "${ctx}/getListBox23List.do",
		type 		: "post",
		dataType 	: "json",
		async 		: true,
		data 		: "",
		success : function(rv) {
			var list23 = rv.Map[0];

			// ipChk = list23.ipChk;	// ipCk 값 변경하는 부분인데 변경 안하니 제외 시킴

			init_time_listBox23(); //시계초기화

			var inHm = list23.inHm;		
			
			$("#listBox23").removeClass();
			// classNm 1. box_250 , box_400 , box_100
			if(classNm == "box_250"){

				widgetContent23 = '<h3 class="main_title_250">오늘 출근시간</h3>'
						      + '<a  class="btn_main_more pointer" title="더보기" id="workTimeWidget" >더보기</a>'
						      + '<div class="workTime_group">'
						      + '	<h3 id="listBox23Clock1"></h3>'
						      + '</div>'
						      + '<div class="workTime_group">'
						      + '	<ul id="workTime_txt" class="workTime_txt" ></ul>'
						      + '</div>';


			}else if(classNm == "box_400"){
				widgetContent23 = '<h3 class="main_title_400 ">오늘 출근시간</h3>'
				              + '<a  class="btn_main_more pointer" title="더보기" id="workTimeWidget" >더보기</a>'
				     		  //+ '<div class="workTime_img"></div>'

				     		  + '<ul id="box23WeekList" class="main_lst"></ul>'  // 주간 출퇴근시간 list

				      		  + '<div class="workTime_group">'
				      		  + '	<h3 id="listBox23Clock1"></h3>'
				      		  + '   <ul id="workTime_txt" class="workTime_txt"></ul>'
				      		  + '</div>';

			}else{


				widgetContent23 = '<h3 class="main_title_100 img_100_schedule">오늘 출근시간</h3>'
				              + '<a  class="btn_main_more pointer" title="더보기" id="workTimeWidget" >더보기</a>'
				     		  + '<div class="workTime_group">'
				      		  + '	<h3 id="listBox23Clock1"></h3>'
				      		  + '</div>'
				      		  + '<div class="workTime_group">'
				      		  + '	<ul id="workTime_txt" class="workTime_txt" style="'+(( ipChk != "Y" || inHm )?"padding-left:100px;":"")+'"></ul>'
				      		  + '</div>';

			}

			$("#listBox23").addClass(classNm);
			$("#listBox23 > .anchor_of_widget").html(widgetContent23);
				
		
			if( ipChk != "Y" || inHm ){
			 	//시간 숨김
				isTimeView = false;
				$("#listBox23Clock1").hide();
			}
			var str1 = "";
			if( ipChk == "Y"){ //허용된 IP일 경우
				// 출근시간이 있는 경우
				if(inHm) {
					/*str1 +='<li><span><input type="radio" id="rdoJoinTypeA" name="rdoJoinType" value="20" class="rdoJoinType" checked="checked"><label for="rdoJoinTypeA" class="rdoJoinType"> 재택근무 </label></span>'
					str1 +='<span><input type="radio" id="rdoJoinTypeD" name="rdoJoinType" value="35" class="rdoJoinType"><label for="rdoJoinTypeD" class="rdoJoinType"> 현지출퇴근 </label></span></li>';
					str1 += '<li class="btn"><a href="javascript:listBox23_work_in(1);" class="button" >출근</a></li>';*/
					str1 += '<li class="btn hideTime"><a class="basic">출근' + list23.vinHm + '</a></li>';
			         //+ '<li class="btn"><a href="javascript:listBox23_work_in(2);" class="button">퇴근' + list23.ㅃvoutHm + '</a></li>';
				}else{
					// 라디오 버튼 추가 (근태 코드값에 대한 Value 변경)
					str1 +='<li><span><input type="radio" id="rdoJoinTypeA" name="rdoJoinType" value="20" class="rdoJoinType" checked="checked"><label for="rdoJoinTypeA" class="rdoJoinType"> 재택근무 </label></span>'
					str1 +='<span><input type="radio" id="rdoJoinTypeD" name="rdoJoinType" value="35" class="rdoJoinType"><label for="rdoJoinTypeD" class="rdoJoinType"> 현지출퇴근 </label></span></li>';
					// 라디오 버튼 종료
				    str1 += '<li class="btn"><a href="javascript:listBox23_work_in(1);" class="button" >출근</a></li>';
					     //+ '<li class="btn"><a href="javascript:listBox23_work_in(2);" class="button" >퇴근</a></li>'; // [벽산] 퇴근 클릭 안함.
				}				
			}else{
				str1 += '<li class="btn hideTime"><a class="basic">출근' + list23.vinHm + '</a></li>';
   		             //+ '<li class="btn"><a class="basic">퇴근' + list23.voutHm + '</a></li>';
			}
			
			//var str1 = '<li class="txt"> ( I P : ' + list23.ipAddress + ' ) </li>';
			str1 += '<li class="txt spacingN"> ( I P : ' + rv.IPAddr + ' ) </li>';
	

			$("#workTime_txt").html(str1);


			if(classNm == "box_400"){
				// 주간 출퇴근시간 list
				var str = "";
				var tmp = "<li><span class='lst_date'>#DAY#</span>"
						+ "<span class='work_tm alignC pad-x-4 mal5'>#IN_HM#</span>"
						+ "<span class='work_tm alignC pad-x-4 mal5'>#OUT_HM#</span>"
					    + "<span class='work_gnt mal10 bd_r8 bg_orange pad-x-4 f_white'>#GNT_NM#</span></li>";

				var weekList = ajaxCall("${ctx}/getListBox23ListWeekList.do?cmd=getListBox23ListWeekList", "", false).DATA;

				for(var i=0; i< weekList.length; i++){

					var  temp_cont = tmp.replace(/#DAY#/g,weekList[i].shortDay)
					          .replace(/#IN_HM#/g,weekList[i].vinHm)
					          .replace(/#OUT_HM#/g,weekList[i].voutHm)
					          .replace(/#GNT_NM#/g,weekList[i].gntNm)
					          ;
					str += temp_cont;
				}

				$("#box23WeekList").html(str);
			}


			

			//더보기 링크 클릭 이벤트
			$("#workTimeWidget").click(function() {
				var goPrgCd = "WorkTime.do?cmd=viewWorkTime";
				goSubPage("08","","","",goPrgCd);
			});


		},
		error : function(jqXHR, ajaxSettings, thrownError) {
			ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
		}
	});

}


function listBox23_work_in(gubun) {
	isTimeView = false;
	var msg = "출근 처리하시겠습니까?";
	if( gubun == 2 ){
		msg = "퇴근 처리하시겠습니까?";
	}
	if(!confirm(msg)) {
		init_time_listBox23();
		return;
	}
	// 라디오 버튼 체크값 확인
	var today = new Date();
	var month = parseInt(today.getMonth()+1).toString().length == 1 ? '0'+parseInt(today.getMonth()+1).toString() : parseInt(today.getMonth()+1).toString();
	var day = today.getDate().toString().length == 1 ? '0'+today.getDate().toString() : today.getDate();
	var date = today.getFullYear() + '-' + month + '-' + day;
	var radio = $('input[name="rdoJoinType"]:checked').val() === '20'? "gntCd=224&gntGubunCd=20" : "gntCd=172&gntGubunCd=35";
	var params = "gubun=" + gubun + "&"+ radio +'&sYmd='+date+'&eYmd='+date;
	var data = ajaxCall("${ctx}/saveListBox23List.do", params, false); 

    if(data.Result.Code == null ) {
        alert("처리되었습니다.");
		loadApp23(1 , 0, widget23classNm);
    } else {
        alert(data.Result.Message);
		init_time_listBox23();
    }

}


 
//시간 초기화
function init_time_listBox23(){
	var data = ajaxCall( "${ctx}/getListBox23ListStdTime.do?cmd=getListBox23ListStdTime", "",false);
	isTimeView = false;
	//시계
	setTimeout(function(){ 
		toTime = data.DATA.toTime;
		time_seconds = 1;
		isTimeView = true;
		if(isTimeView) go_time_listBox23();
	}, 1100);
}

//시계
function go_time_listBox23() {
	
	if(!isTimeView) return;
		
	time_seconds = time_seconds + 1;
	var now = new Date(toTime);
	now.setTime( now.getTime() + time_seconds * 1000 );
	var year = now.getFullYear(); //년
	var month = now.getMonth(); //월
	var day = now.getDay();  //일
	var hour = addZeros_listBox23(now.getHours(), 2);
	var min = addZeros_listBox23(now.getMinutes(), 2);  //분
	var sec = addZeros_listBox23(now.getSeconds(), 2);  //초

	$("#listBox23Clock1").html(hour+":"+min+":"+sec);
	//id가 clock인 html에 현재시각을 넣음

	setTimeout(function(){ 
		 if(isTimeView) go_time_listBox23();
	}, 1000);
	//1초마다 해당 펑션을 실행함.
	
}

function addZeros_listBox23(num, digit) { // 자릿수 맞춰주기
	var zero = '';
	num = num.toString();

	if (num.length < digit) {
		for (i = 0; i < digit - num.length; i++) {
			zero += '0';
		}
	}

	return zero + num;
}
</script>
<div  id="listBox23" lv="23" info="출근/퇴근" class="notice_box">
	<div class="anchor_of_widget"></div>
</div>


