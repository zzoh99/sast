$(document).ready(function () {
  /* 휴가현황 widget */
  var vacationChart = {
    series: [
      {
        name: "Line1",
        data: [10, 61, 15, 31, 89, 12],
      }
    ],
    chart: {
      type: "line",
      zoom: {
        enabled: false,
      },
      height: 110,
      width: 206,
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: "straight",
      width: 1,
    },
    yaxis: {
      show: false,
      tickAmount: 2,
    },
    xaxis: {
      title: {
        text: undefined,
        offsetX: 0,
        offsetY: 0,
        style: {
          color: "#ff0000",
          fontSize: "12px",
          fontFamily: "Helvetica, Arial, sans-serif",
          fontWeight: 600,
          cssClass: "apexcharts-xaxis-title",
        },
      },
      categories: ["1월", "2월", "3월", "4월", "5월", "6월"],
      labels: {
        /**
         * Allows users to apply a custom formatter function to x-axis labels.
         *
         * @param { String } value - The default value generated
         * @param { Number } timestamp - In a datetime series, this is the raw timestamp
         * @param { object } contains dateFormatter for datetime x-axis
         */
        formatter: function (value, timestamp, opts) {
          var nValue = "";
          if (
            value == "2월" ||
            value == "3월" ||
            value == "4월" ||
            value == "5월"
          ) {
          } else {
            nValue = value;
          }
          return nValue;
        },
      },
    },
    grid: {
      position: "back",
      strokeDashArray: 0,
      row: {
        colors: ["transparent", "transparent"],
        opacity: 0.5,
      },
    },
    colors: ["#34c759", "#00ff00"],
    legend: {
      show: false,
    },
    markers: {
      size: 5,
      colors: "#34c759",
      strokeWidth: 0,
      shape: "circle",
      radius: 2,
      offsetX: 0,
      offsetY: 0,
      onClick: undefined,
      onDblClick: undefined,
      showNullDataPoints: true,
      hover: {
        size: undefined,
        sizeOffset: 3,
      },
      discrete: [
        {
          seriesIndex: 0,
          dataPointIndex: 0,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 0,
          dataPointIndex: 1,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 0,
          dataPointIndex: 2,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 0,
          dataPointIndex: 3,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 0,
          dataPointIndex: 5,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 0,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 1,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 2,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 3,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 4,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 5,
          size: 0,
          shape: "circle",
        },
      ],
    },
  };
  if(document.querySelector("#vacationChart")){
    new ApexCharts(
      document.querySelector("#vacationChart"),
      vacationChart
    ).render();
  }

  /* 휴가현황 widget wide */
  var vacationWideChart = {
    series: [
      {
        name: "Line1",
        data: [10, 61, 15, 31, 89, 12],
      }
    ],
    chart: {
      id: "vacationWideChart",
      group: "vacationWideChart",
      type: "line",
      zoom: {
        enabled: false,
      },
      height: 110,
      width: 486,
    },
    dataLabels: {
      enabled: false,
    },
    stroke: {
      curve: "straight",
      width: 1,
    },
    /*title: {
      text: '휴가현황',
      align: 'left'
    },*/
    yaxis: {
      show: false,
      tickAmount: 2,
    },
    xaxis: {
      title: {
        text: undefined,
        offsetX: 0,
        offsetY: 0,
        style: {
          color: "#ff0000",
          fontSize: "12px",
          fontFamily: "Helvetica, Arial, sans-serif",
          fontWeight: 600,
          cssClass: "apexcharts-xaxis-title",
        },
      },
      categories: ["1월", "2월", "3월", "4월", "5월", "6월"],
      labels: {
        /**
         * Allows users to apply a custom formatter function to x-axis labels.
         *
         * @param { String } value - The default value generated
         * @param { Number } timestamp - In a datetime series, this is the raw timestamp
         * @param { object } contains dateFormatter for datetime x-axis
         */
        formatter: function (value, timestamp, opts) {
          return value;
        },
      },
    },
    grid: {
      position: "back",
      strokeDashArray: 0,
      row: {
        colors: ["transparent", "transparent"], // takes an array which will be repeated on columns
        opacity: 0.5,
      },
    },
    colors: ["#34c759", "#00ff00"],
    legend: {
      show: false,
    },
    markers: {
      size: 5,
      colors: "#34c759",
      strokeWidth: 0,
      shape: "circle",
      radius: 2,
      offsetX: 0,
      offsetY: 0,
      onClick: undefined,
      onDblClick: undefined,
      showNullDataPoints: true,
      hover: {
        size: undefined,
        sizeOffset: 3,
      },
      discrete: [
        {
          seriesIndex: 0,
          dataPointIndex: 0,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 0,
          dataPointIndex: 1,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 0,
          dataPointIndex: 2,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 0,
          dataPointIndex: 3,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 0,
          dataPointIndex: 5,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 0,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 1,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 2,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 3,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 4,
          size: 0,
          shape: "circle",
        },
        {
          seriesIndex: 1,
          dataPointIndex: 5,
          size: 0,
          shape: "circle",
        },
      ],
    },
  };
  if(document.querySelector("#vacationWideChart")){
    new ApexCharts(
      document.querySelector("#vacationWideChart"),
      vacationWideChart
    ).render();
  }

  /* 근태마스터 기본근무 */
  var attendanceBasic = {
    series: [{
      data: [21, 22, 10, 28, 16, 21]
    }],
    chart: {
      height: 244,
      type: 'bar',
      events: {
        click: function(chart, w, e) {
          // console.log(chart, w, e)
        }
      }
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
        columnWidth: '4px',
        distributed: true,
      }
    },
    dataLabels: {
      enabled: false
    },
    legend: {
      show: false
    },
    xaxis: {
      categories: [
        '12월',
        '1월',
        '2월',
        '3월',
        '4월',
        '5월',
      ],
      labels: {
        style: {
          /* colors: ["#2570f9"], */
          fontSize: '12px'
        }
      }
    }
  };
  
  if(document.querySelector("#attendanceBasic")){
    new ApexCharts(
      document.querySelector("#attendanceBasic"),
      attendanceBasic
    ).render();
  }

  /* 근태마스터 기본근무 : 내용없음 */
  var attendanceBasicNoData = {
    series: [{
      data: [0, 0, 0, 0, 0, 0]
    }],
    chart: {
      height: 244,
      type: 'bar',
      events: {
        click: function(chart, w, e) {
          // console.log(chart, w, e)
        }
      }
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
        columnWidth: '4px',
        distributed: true,
      }
    },
    dataLabels: {
      enabled: false
    },
    legend: {
      show: false
    },
    xaxis: {
      categories: [
        '12월',
        '1월',
        '2월',
        '3월',
        '4월',
        '5월',
      ],
      labels: {
        style: {
          /* colors: ["#2570f9"], */
          fontSize: '12px'
        }
      }
    }
  };
  
  if(document.querySelector("#attendanceBasicNoData")){
    new ApexCharts(
      document.querySelector("#attendanceBasicNoData"),
      attendanceBasicNoData
    ).render();
  }

  /* 근태마스터 연장근무 */
  var attendanceOvertime = {
    series: [70],
    chart: {
    height: 287,
    type: 'radialBar',
  },
  colors: ["#2570f9"],
  plotOptions: {
    radialBar: {
      hollow: {
        size: '84%',
      }
    },
  },
  dataLabels: {enabled: false},
  labels: [""],
  };

  if(document.querySelector("#attendanceOvertime")){
    new ApexCharts(
      document.querySelector("#attendanceOvertime"),
      attendanceOvertime
    ).render();
  }

  /* 근태마스터 연장근무 : 내용없음 */
  var attendanceOvertimeNoData = {
    series: [0],
    chart: {
    height: 287,
    type: 'radialBar',
  },
  colors: ["#2570f9"],
  plotOptions: {
    radialBar: {
      hollow: {
        size: '84%',
      }
    },
  },
  dataLabels: {enabled: false},
  labels: [""],
  };

  if(document.querySelector("#attendanceOvertimeNoData")){
    new ApexCharts(
      document.querySelector("#attendanceOvertimeNoData"),
      attendanceOvertimeNoData
    ).render();
  }
});