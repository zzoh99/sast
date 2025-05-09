<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>

<script type="text/javascript">
var widget602 = {
	size: null
};

function init_listBox602(size) {
	widget602.size = size;
	loadWidget602();
}

function loadWidget602() {

  var options = {
    series: [{
      name: '전사', // 색인
      data: [90,85], // 데이터
      color: '#2570f9'
    }, {
      name: '부서', // 색인
      data: [88,80], // 데이터
      color: '#777777'
    }, {
      name: '개인', // 색인
      data: [80, 88], // 데이터
      color: '#F95001'
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
      categories: ['2022','2023']// 연도
    },
    yaxis: {
      show: false,
      tickAmount: 4,
    },
  };

  document.getElementById("annualChart").innerHTML = '';
  var chart = new ApexCharts(document.getElementById("annualChart"), options);
  chart.render();

}
</script>
<div class="widget_header">
  <div class="widget_title">전사 평가 평균</div>
</div>
<div class="widget_body attendance_contents annual-status widget-common overtime-work">
  <div class="container_box" style="padding-top: 0px!important;">
    <div class="container_left">
      <div class="container_info">
        <div class="info_year">2023</div>
        <span class="info_title_num">88<span class="info_title unit">점</span></span>
        <span class="info_title desc">전년대비<strong class="title_green">10%</strong>증가<div class="tag_icon green round"><i class="mdi-ico">trending_up</i></div></span>
      </div>
      <div class="info_box">
        <span class="title_kor">평점 우수팀</span><span class="box_bnum">R&D센터</span>
      </div>
      <div class="info_box">
        <span class="title_kor">평점 최하팀</span><span class="box_bnum">HUB개발팀</span>
      </div>
    </div>
    <div class="container_right">
      <div class="chart-wrap">
        <div id="annualChart" style="min-height: 158px;"></div>
      </div>
    </div>
  </div>
</div>