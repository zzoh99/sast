<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
	/*
	 * 근태 > 연차 보상 비용 현황
	 */

	var widget802 = {
		size: null
	};

	var wokrTypeStand = '';
	var TotMonValue;
	var bfTotMon1Value;
	var bfTotMon2Value;
	var bfTotMon3Value;
	var now = new Date();
	var currentYear = now.getFullYear();
	
	/**
	 * 파라미터에 따른 메서드 선택 
	 * size : 사이즈 (값 "wide" -> wide위젯 메서드 호출, "normal" -> 한칸 위젯 메서드 호출)
	 */
	function init_listBox802(size) {
		widget802.size = size;
		
		if (size == "normal"){
			createWidgetMini802();
			setDataWidgetMini802();
		} else if (size == ("wide")){
			createWidgetWide802();
			setDataWidgetWide802();
		}
	}

	// 위젯 html 코드 생성 + 데이터 넣기
	function createWidgetMini802(){
		var code = 
			'<div class="widget_header">' +
			'  <div class="widget_title">연차 보상 비용 현황</div>' +
			'</div>' +
			'<div class="widget_body attendance_contents annual-status">' +
			'  <div class="container_box">' +
			'    <div class="container_left">' +
			'      <div class="container_info">' +
			'        <span class="info_title">보상 지급 인원<strong class="cnt" id="cntMini"></strong>명</span>' +
			'        <span class="info_title_num" id="totMonMini"><span class="info_title unit"></span></span>' +
			'        <span class="info_title desc">전년대비<strong class="title_green" id="divideTotMon"></strong><span class="info_title desc" id="standard"></span><div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>' +
			'      </div>' +
			'      <div class="info_box">' +
			'        <span class="title_kor">1인당 최대 보상</span><span class="box_bnum" id="maxMonMini"></span><span class="title_kor"></span>' +
			'      </div>' +
			'      <div class="info_box">' +
			'        <span class="title_kor">1인당 최소 보상</span><span class="box_bnum" id="minMonMini"></span><span class="title_kor"></span>' +
			'      </div>' +
			'    </div>' +
			'  </div>' +
			'</div>';
			   
		document.querySelector('#widget802Element').innerHTML = code;
	}

	function setDataWidgetMini802() {

        ajaxCall2("${ctx}/getListBox802List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.vacationLeaveCost) {
                    const vacationLeaveCost = data.data.vacationLeaveCost;

                    if (vacationLeaveCost.data.length > 0){
                        $('#cntMini').text(vacationLeaveCost.data[0].cnt);
                        $('#totMonMini').text(vacationLeaveCost.data[0].totMon);
                        $('#maxMonMini').text(vacationLeaveCost.data[0].maxMon + '만원');
                        $('#minMonMini').text(vacationLeaveCost.data[0].minMon + '만원');

                        if (vacationLeaveCost.data[0].totMon != 0 || vacationLeaveCost.data[0].bfTotMon1 != 0){
                            $('#divideTotMonMini').text(vacationLeaveCost.data[0].totMon/vacationLeaveCost.data[0].bfTotMon1);

                            if (vacationLeaveCost.data[0].totMon > vacationLeaveCost.data[0].bfTotMon1) {
                                $('#standardMini').text('증가');
                            } else if (vacationLeaveCost.data[0].totMon < vacationLeaveCost.data[0].bfTotMon1) {
                                $('#standardMini').text('감소');
                            }else{
                                $('#standardMini').text('');
                            }
                        }
                    }
                }
            })
	}
	
	// wide 위젯 html코드 생성 + 데이터 넣기
	function createWidgetWide802(){
		var code =
			'<div class="widget_header">' +
			'  <div class="widget_title">연차 보상 비용 현황</div>' +
			'</div>' +
			'<div class="widget_body attendance_contents annual-status">' +
			'  <div class="container_box">' +
			'    <div class="container_left">' +
			'      <div class="container_info">' +
			'        <span class="info_title">보상 지급 인원<strong class="cnt" id="cnt"></strong>명</span>' +
			'        <span class="info_title_num" id="totMon"><span class="info_title unit"></span></span>' +
			'        <span class="info_title desc">전년대비<strong class="title_green" id="divideTotMonMini"></strong><span class="info_title desc" id="standardMini"></span><div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>' +
			'      </div>' +
			'      <div class="info_box">' +
			'        <span class="title_kor">1인당 최대 보상</span><span class="box_bnum" id="maxMon"></span><span class="title_kor"></span>' +
			'      </div>' +
			'      <div class="info_box">' +
			'        <span class="title_kor">1인당 최소 보상</span><span class="box_bnum" id="minMon"></span><span class="title_kor"></span>' +
			'      </div>' +
			'    </div>' +
			'    <div class="container_right">' +
			'      <div class="chart-wrap">' +
			'        <div id="annualChart"></div>' +
			'      </div>' +
			'    </div>' +
			'  </div>' +
			'</div>';

		document.querySelector('#widget802Element').innerHTML = code;
	}

	function setDataWidgetWide802() {

        ajaxCall2("${ctx}/getListBox802List.do"
            , ""
            , true
            , null
            , function(data) {
                if (data && data.data && data.data.vacationLeaveCost) {

                    const vacationLeaveCost = data.data.vacationLeaveCost;
                    /* 예시데이터
                    vacationLeaveCost = {
                            data: [
                                {
                                    minMon: 10,
                                    bfPayDay1: "2022",
                                    maxMon: 150,
                                    bfPayDay2: "2021",
                                    totMon: 680,
                                    bfPayDay3: "2020",
                                    cnt: 141,
                                    bfPayDay: "202312",
                                    bfTotMon3: 160,
                                    bfTotMon2: 380,
                                    bfTotMon1: 270
                                }
                            ]
                        }
                     */

                    if (vacationLeaveCost.data.length > 0) {
                        $('#cnt').text(vacationLeaveCost.data[0].cnt);
                        $('#totMon').text(vacationLeaveCost.data[0].totMon);
                        $('#maxMon').text(vacationLeaveCost.data[0].maxMon + '만원');
                        $('#minMon').text(vacationLeaveCost.data[0].minMon + '만원');

                        if (vacationLeaveCost.data[0].totMon == 0 || vacationLeaveCost.data[0].bfTotMon1 == 0){
                            $('#divideTotMonMini').text('-');
                        } else {
                            var text = (vacationLeaveCost.data[0].totMon/vacationLeaveCost.data[0].bfTotMon1, 2).toFixed(2) + '%';
                            $('#divideTotMonMini').text(text);

                            if (vacationLeaveCost.data[0].totMon > vacationLeaveCost.data[0].bfTotMon1) {
                                $('#standardMini').text('증가');
                            } else if (vacationLeaveCost.data[0].totMon < vacationLeaveCost.data[0].bfTotMon1) {
                                $('#standardMini').text('감소');
                            }else{
                                $('#standardMini').text('');
                            }
                        }

                        // 차트데이터
                        TotMonValue = vacationLeaveCost.data[0].totMon;
                        bfTotMon1Value = vacationLeaveCost.data[0].bfTotMon1;
                        bfTotMon2Value = vacationLeaveCost.data[0].bfTotMon2;
                        bfTotMon3Value = vacationLeaveCost.data[0].bfTotMon3;
                    }
                }
            })
	}
</script>
<div class="widget" id="widget802Element"></div>

<script>
	// 차트데이터 
    $(document).ready(function () {
      /* 말풍선 */
      $('.avatar-list .name').mouseover(function(event){
        const xpos = $(this).position().left;
        const ypos = -$(this).parent().position().top;
        // $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
        $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
      });
      $('.avatar-list .name').mouseout(function(event){
        $(this).parent().parent().next().hide();
      });

      /* 말풍선 */
      $('.overtime-work .avatar-list .name').mouseover(function(event){
        const xpos = ($(this).position().left + $(this).width() - 5 );
        const ypos = -($(this).parent().position().top + 33);
        console.log("xpos:"+xpos+"/ ypos:"+ypos);
        // $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
        $(this).parent().parent().next().css( { "display" : 'flex', "margin-left" : xpos + "px", "margin-top" : ypos+"px" });
      });
      $('.overtime-work .avatar-list .name').mouseout(function(event){
        $(this).parent().parent().next().hide();
      });


      /* EIS 근무 위젯 */
      var annualChart = {
        series: [
          {
            data: [bfTotMon3Value, bfTotMon2Value, bfTotMon1Value, TotMonValue],
          },
        ],
        chart: {
          height: 143,
          type: "bar",
          events: {
            click: function (chart, w, e) {
            },
          },
        },
        stroke: {
          width: 1,
        },
        yaxis: {
          show: false,
          tickAmount: 7,
        },
        colors: ["#2570f9"],
        plotOptions: {
          bar: {
            columnWidth: "4px",
            distributed: true,
          },
        },
        dataLabels: {
          enabled: false,
        },
        legend: {
          show: false,
        },
        xaxis: {
          categories: [currentYear-3, currentYear-2, currentYear-1, currentYear],
          labels: {
            style: {
              /* colors: ["#2570f9"], */
              fontSize: "12px",
            },
          },
        },
      };
      if (document.querySelector("#annualChart")) {
        new ApexCharts(
          document.querySelector("#annualChart"),
          annualChart
        ).render();
      }
    });
  </script>