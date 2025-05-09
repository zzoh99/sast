var msnry;
const makedWidgets = ['listBox20', 'listBox8', 'listBox2', 'listBox5', 'listBox6', 'listBox19', 'listBox15', 'listBox10', 'listBox4',
	// 인사
	'listBox201', 'listBox202', 'listBox203', 'listBox204', 'listBox205', 'listBox206', 'listBox207', 'listBox208', 'listBox209', 'listBox210', 'listBox211', 'listBox212',
	// 조직
	'listBox301',
	// 교육
	'listBox501', 'listBox502', 'listBox503', 'listBox504',
	// 성과
	'listBox601', 'listBox602', 'listBox603', 'listBox604', 'listBox605', 'listBox606', 'listBox607', 'listBox608', 'listBox609',
	// 급여
	'listBox701', 'listBox702', 'listBox703', 'listBox704', 'listBox705', 'listBox706', 'listBox707', 'listBox708', 'listBox709', 'listBox710', 'listBox712', 'listBox713', 'listBox714', 'listBox715', 'listBox716', 'listBox717',
	// 근태
	'listBox801', 'listBox802', 'listBox813', 'listBox804', 'listBox814', 'listBox807', 'listBox808', 'listBox809', 'listBox810', 'listBox811', 'listBox812','listBox815',
	// 복리후생
	// 통계
	'listBox1201',
	// 프로세스맵
	'processMap',
	//통계
	'stats01', 'stats02'
];

function createwWidget(menucode) {
	//widget 초기화
	$('div#widgetBody').empty();
	var widgetInitFunctionArray = [];
	var widgets  = ajaxCall("/getWidgetList.do", 'mainMenuCd=' + menucode, false).DATA;
	let minSize = '24';
	let masonry = new Array();
	let itemCount = 4;

	// 위젯 순서 조정
	let chgWidgets = new Array();
	widgets.forEach((widget, idx) => {
		itemCount = menucode === "00" ? 6 : 4;

		const id = widget.tabId;
		const size = id == 'processMap'? widget.tabSize : (id == 'listBox301' || id == 'listBox1201')? 'full': widget.tabSize == '11' ? 'normal'
			:widget.tabSize == '22' ? 'bwide':'wide';

		let colSize = Number(widget.tabSize.substring(1, 2));

		if(masonry.length > 0) {
			for(let i =0; i < masonry.length; i++) {
				const item = masonry[i];
				let flag = false;
				if(item.space - colSize >= 0) {
					chgWidgets.splice(item.colIdx+1, 0, widget);
					masonry[i].colIdx = idx;
					masonry[i].space -= colSize;
					break;
				} else {
					// 마지막까지 위젯이 들이갈 공간이 없는 경우, 다음 row에 입력.
					if(i === masonry.length-1) {
						chgWidgets.push(widget);
						const nextRow = item.row + 1;
						if(masonry.length < nextRow) {
							masonry.push({
								row: nextRow,
								colIdx: idx,
								space: itemCount-colSize
							})
						}
						break;
					}
				}
			}
		} else {
			masonry.push({
				row: 1,
				colIdx: 1,
				space: itemCount-colSize
			})
			chgWidgets.push(widget);
		}
	});
	widgets = chgWidgets;

	//1. 그릴 영역부터 만들기
	//widgets = widgets.filter(w => makedWidgets.indexOf(w.tabId) != -1);
	var widgetHtml = widgets.reduce((a, c, idx) => {
		if (a == '') {
			a += '<div class="swiper-slide">\n';

			if (menucode === "00") {
                a += '<div class="widget_container main">\n';
            } else {
                a += '<div class="widget_container">\n';
            }

		}
		const id = c.tabId;
		const divId = 'widget_' + id;
		const path = c.tabUrl;
		const size = id == 'processMap'? c.tabSize : (id == 'listBox301' || id == 'listBox1201')? 'full': c.tabSize == '11' ? 'normal'
					:c.tabSize == '22' ? 'bwide':'wide';

		a += size == 'full' ? `<div class="widget_wrap row_2 col_4">\n<div id="${divId}" class="widget wide">\n`
			:size == '14' ? `<div class="widget_wrap row_1 col_4">\n<div id="${divId}" class="widget wide">\n`
			:size == '24' ? `<div class="widget_wrap row_2 col_4">\n<div id="${divId}" class="widget wide">\n`
			:size == 'wide' ? `<div class="widget_wrap row_1 col_2">\n<div id="${divId}" class="widget wide">\n`
			:size =='bwide' ? `<div class="widget_wrap row_2 col_2">\n<div id="${divId}" class="widget wide widget_calender long">\n`
			:`<div class="widget_wrap row_1 col_1">\n<div id="${divId}" class="widget">\n`;

		minSize = Number(minSize) > Number(c.tabSize) ? c.tabSize : minSize; // 최소 사이즈 탐색

		/*
			if (makedWidgets.indexOf(id) != -1) {
				widgetInitFunctionArray.push('init_' + id + '("' + size + '","' + menucode + '");');
			}
		*/

		widgetInitFunctionArray.push('init_' + id + '("' + size + '","' + menucode + '");');

		// widget html 삽입
		a += '</div>\n</div>\n';
		if ((idx + 1) == widgets.length) a += '</div>\n</div>';
		return a;
	}, '');

	$('div#widgetBody').html(widgetHtml);
	//2. 각 영역마다 widget html 붙이기 및 초기함수 실행
	widgets.forEach(w => {
		const id = w.tabId;
		const size = w.tabSize == '11' ? 'normal':w.tabSize == '22' ? 'bwide':'wide';
		const divId = 'widget_' + id;
		const mId = menucode;
		const path = w.tabUrl;
		const statsCd = w.statsCd;
		var initFunc = `init_${id}("${size}","${menucode}")`;
		const jspPage=(statsCd==""||null? id : "listBoxStats");
		//const param = 'url=' + encodeURIComponent(path + '/' + id);
		const param = 'url=' + encodeURIComponent(path + '/' + jspPage);
		$('#' + divId).load('/getWidgetToHtml.do', param, function() {
			if(statsCd){
				var widgetChart=new WidgetChart(statsCd, size, divId);
				widgetChart.init();

			}else{
				eval(initFunc);
			}
		});
	});
	
	onMasonly(minSize);
}

function onMasonly(minSize) {

	// 가장 작은 사이즈 기준으로 설정
	let colSize = minSize.substring(1, 2);

	let option = {
		itemSelector: '.widget_wrap',
		percentPosition: true,
		columnWidth: `.col_${colSize}`,
		gutter: 0,
		horizontalOrder: false
	};

	msnry = new Masonry('.widget_container', option);
}

function WidgetChart(statsCd, size, divId){
	var g_defaultSize = 244;
	this.init=function(){
		var param={
			statsCd : statsCd
		}
		var header = ajaxCall( "/WidgetMgr.do?cmd=getStatsWidgetInfo", param, false);
		this.draw(header.DATA);
	}
	this.draw=function(header){
		var chartOpt = eval("(" + header.chartOpt + ")");
		try{
			if( chartOpt.chart == undefined ) {
				chartOpt.chart = {};
			}
			var sizeW = (size == "normal"? 1 : 2);
			var sizeH = 1;

			chartOpt.chart.width = (parseInt(sizeW) * g_defaultSize);
			chartOpt.chart.height = (parseInt(sizeH) * g_defaultSize);

			let d = new Date();
			let ms = d.getTime();

			var widgetId=divId;
			var chartId="chart_"+ms;

			var chartAreaHtml="";
			chartAreaHtml+="<div name='area_chartWrap' class='widget-chart-only'>";
			chartAreaHtml+="<div id='"+chartId+"'></div>";
			chartAreaHtml+="</div>";

			//$("#widget_listBoxStats").attr("id", widgetId);
			$("#"+widgetId).append(chartAreaHtml);

			//차트옵션에서 데이터를 하드코딩했으면 쿼리 데이터는 무시
			if(chartOpt.series) header.data=null;

			var chart = HR_CHART[header.pluginObjNm].render("#"+chartId, chartOpt, header.data);

		}catch(e){
			alert(e.message);
		}
	}
}