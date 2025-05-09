// form data serialize to json
jQuery.fn.serializeObject = function() {
	var obj = null;
	try {
		// this[0].tagName이 form tag일 경우
		if(this[0].tagName && this[0].tagName.toUpperCase() == "FORM" ) {
			var arr = this.serializeArray();
			if(arr){
				obj = {};
				jQuery.each(arr, function() {
					if( obj[this.name] == undefined ) {
						// obj의 key값은 arr의 name, obj의 value는 value값
						obj[this.name] = this.value;
					} else {
						var valArr = [];
						// 기존에 삽입되었던 값이 배열이 아닌 경우
						if( Array.isArray(obj[this.name]) == false ) {
							valArr.push(obj[this.name]);
						} else {
							valArr = obj[this.name];
						}
						valArr.push(this.value);
						obj[this.name] = valArr;
					}
				});
			}
		}
	}catch(e) {
		alert(e.message);
	}finally  {}
	return obj;
};

//append CSS File
$.loadCSS = function(url) {
	if (!$('link[href="' + url + '"]').length) {
		$("<link>", {
			type : "text/css",
			rel  : "stylesheet",
			href : url
		}).appendTo('head');
	}
};

//append JS File
$.loadJS = function(url) {
	if (!$('script[src="' + url + '"]').length) {
		$("<script>", {
			type    : "text/javascript",
			charset : "UTF-8",
			src     : url
		}).appendTo('head');
	}
};


/***************************************************************************************************************************
 * Load Resource
 ***************************************************************************************************************************/
// Load Apexchart Resource
if( typeof ApexCharts === "undefined" ) {
	if (window.navigator.userAgent.indexOf('MSIE') > -1 || window.navigator.userAgent.indexOf('Trident') > -1) {
		window.Promise || document.write('<script src="/common/plugin/EIS/polyfill/js/polyfill.min.js" type="text/javascript" charset="UTF-8"><\/script>');
		window.Promise || document.write('<script src="/common/plugin/EIS/polyfill/js/classList.js"    type="text/javascript" charset="UTF-8"><\/script>');
		window.Promise || document.write('<script src="/common/plugin/EIS/polyfill/js/findIndex.js"    type="text/javascript" charset="UTF-8"><\/script>');
		window.Promise || document.write('<script src="/common/plugin/EIS/polyfill/js/canvg_umd.js"    type="text/javascript" charset="UTF-8"><\/script>');
	}
	$.loadCSS("/common/plugin/EIS/apexcharts/css/apexcharts_new.css");
	$.loadJS("/common/plugin/EIS/apexcharts/js/apexcharts.min_new.js");
	$.loadJS("/common/plugin/EIS/apexcharts/js/setGlobal.js?ver=" + new Date().getTime());
}
// Load jQCloud Resource
if( typeof jQCloud === "undefined" ) {
	$.loadCSS("/common/plugin/EIS/jQCloud/css/jqcloud.min.css");
	$.loadCSS("/common/plugin/EIS/jQCloud/css/add.css?ver=" + new Date().getTime());
	$.loadJS("/common/plugin/EIS/jQCloud/js/jqcloud.min.js");
}
/***************************************************************************************************************************
 * Load Resource
 ***************************************************************************************************************************/


/**
 * 차트 출력 데이터 SQL 정의 컬럼 상세 정보
 */
var HR_CHART_DATA_SQL_COL = {
	"SERIES_IDX"        : "항목순번",
	"SERIES_NAME"       : "항목명",
	"SERIES_CODE"       : "항목코드 : 항목의 고유 코드값",
	"SERIES_DATA"       : "항목데이터 : 차트에 출력될 수치",
	"SERIES_CHART_TYPE" : "항목차트타입",
	"CATEGORY_LABEL"    : "카테고리 라벨",
	"CATEGORY_COLOR"    : "카테고리 컬러"
};

/** 차트 색상  */
var HR_CHART_COLORS = [
	  "#008FFB", "#00E396", "#FEB019", "#FF4560", "#775DD0"
	, "#4caf50", "#f9ce1d", "#3f51b5", "#03a9f4", "#FF9800"
	, "#33b2df", "#546E7A", "#d4526e", "#13d8aa", "#A5978B"
	, "#4ecdc4", "#c7f464", "#81D4FA", "#546E7A", "#fd6a6a"
	, "#2b908f", "#f9a3a4", "#90ee7e", "#fa4443", "#69d2e7"
	, "#F86624", "#449DD1", "#EA3546", "#662E9B", "#C5D86D"
	, "#D7263D", "#1B998B", "#2E294E", "#F46036", "#E2C044"
	, "#662E9B", "#F86624", "#F9C80E", "#EA3546", "#43BCCD"
	, "#5C4742", "#A5978B", "#8D5B4C", "#5A2A27", "#C4BBAF"
	, "#A300D6", "#7D02EB", "#5653FE", "#2983FF", "#00B1F2"
];

/**
 * 차트 유틸
 */
var HR_CHART_UTIL = {
	
	/** 정의 된 차트 객체 코드 Combo형태로 쓰는 형태로 구성 반환
	 */
	getPluginObjCode : function(str) {
		var convArray = new Array("", "", "");
		if( str == undefined ) str = "";
		
		if( HR_CHART && HR_CHART != null ) {
			var keys = Object.keys(HR_CHART);
			//console.log('[HR_CHART_UTIL.getPluginObjCode] keys', keys);
			
			if( keys && keys != null && keys.length > 0 ) {
				var idx = 0;
				keys.forEach(function(item) {
					if( idx > 0 ) {
						convArray[0] += "|";
						convArray[1] += "|";
					}
					// code_name
					convArray[0] += item;
					// code
					convArray[1] += item;
					// option html element
					convArray[2] += "<option value='"+item+"'>" + item + "</option>";
					idx++;
				})
			}
		} else {
			convArray[0] = "";
			convArray[1] = "";
			convArray[2] = "<option value=''>" + str + "</option>";
		}
		//console.log('[HR_CHART_UTIL.getPluginObjCode] convArray', convArray);
		
		return convArray;
	},
	
	/**
	 * DB 조회 데이터 apex차트용으로 변환
	 */
	convDataForApexFormat : function(data) {
		var result = null;
		if( data && data != null && data.length > 0 ) {
			result = {
				series : [],
				categories : [],
				seriesCode : []
			};
			var tempSeries, tempSeriesCode, prevSeriesIdx = -1;
			data.forEach(function(item){
				if( item.seriesIdx != undefined ) {
					//console.log('[HR_CHART_UTIL.convDataForApexFormat] item', item, 'prevSeriesIdx', prevSeriesIdx);
					
					// 라벨 설정 : seriesIdx 값이 0인 경우에만 진행
					if( item.seriesIdx == 0 ) {
						result.categories.push(item.categoryLabel);
					}
					
					// 컬러 코드 설정
					if( item.categoryColor != undefined && item.categoryColor != null && item.categoryColor !="" ) {
						if( result.colors == undefined ) result.colors = [];
						if( result.colors.length == 0 ) {
							result.colors.push(item.categoryColor);
						} else {
							if( result.colors[result.colors.length - 1] != item.categoryColor ) {
								result.colors.push(item.categoryColor);
							}
						}
					}
					
					if( prevSeriesIdx != item.seriesIdx ) {
						// push series
						if( prevSeriesIdx > -1 ) {
							result.series.push(tempSeries);
							result.seriesCode.push(tempSeriesCode);
						}
						tempSeries = {
							data : []
						};
						tempSeriesCode = {
							code : []
						};
						if( item.seriesName != undefined && item.seriesName != null ) {
							tempSeries.name = item.seriesName;
						}
						if( item.seriesChartType != undefined && item.seriesChartType != null ) {
							tempSeries.type = item.seriesChartType;
						}
					}
					
					// push code & data
					tempSeries.data.push(item.seriesData);
					tempSeriesCode.code.push(item.seriesCode);
					
					prevSeriesIdx = item.seriesIdx;
				}
			});
			if( tempSeries && tempSeries != null ) {
				result.series.push(tempSeries);
			}
			if( tempSeriesCode && tempSeriesCode != null ) {
				result.seriesCode.push(tempSeriesCode);
			}
		}
		return result;
	},
	
	/**
	 * DB 조회 데이터 apex차트 treemap용으로 변환
	 */
	convDataForApexTreemapFormat : function(data) {
		var result = null;
		if( data && data != null && data.length > 0 ) {
			result = {
				series : [],
				categories : [],
				seriesCode : []
			};
			var tempSeries, tempSeriesCode, prevSeriesIdx = -1;
			data.forEach(function(item){
				if( item.seriesIdx != undefined ) {
					//console.log('[HR_CHART_UTIL.convDataForApexTreemapFormat] item', item, 'prevSeriesIdx', prevSeriesIdx);
					
					if( item.categoryColor != undefined && item.categoryColor != null && item.categoryColor !="" ) {
						if( result.colors == undefined ) result.colors = [];
						result.colors.push(item.categoryColor);
					}
					
					if( prevSeriesIdx != item.seriesIdx ) {
						// push series
						if( prevSeriesIdx > -1 ) {
							result.series.push(tempSeries);
							result.seriesCode.push(tempSeriesCode);
						}
						tempSeries = {
							data : []
						};
						tempSeriesCode = {
							code : []
						};
						if( item.seriesName != undefined && item.seriesName != null ) {
							tempSeries.name = item.seriesName;
						}
					}
					
					// push code & data
					tempSeriesCode.code.push(item.seriesCode);
					tempSeries.data.push({
						x: item.categoryLabel,
						y: item.seriesData
					});
					
					prevSeriesIdx = item.seriesIdx;
				}
			});
			if( tempSeries && tempSeries != null ) {
				result.series.push(tempSeries);
			}
			if( tempSeriesCode && tempSeriesCode != null ) {
				result.seriesCode.push(tempSeriesCode);
			}
		}
		return result;
	},
	convDataForApexBubbleFormat : function(data) {
		var result = null;
		if( data && data != null && data.length > 0 ) {
			result = {
				series : [],
				categories : [],
				seriesCode : []
			};
			/*
			// SERIES_IDX, SERIES_NAME : 구분
			// SERIES_CODE : X축
			// SERIES_DATA : Y축
			// CATEGORY_LABEL : Z값
			*/
			var tempSeries, tempSeriesCode, prevSeriesIdx = -1, preSeriesName;
			data.forEach(function(item, idx){
				if( item.seriesIdx != undefined ) {
					//console.log('[HR_CHART_UTIL.convDataForApexTreemapFormat] item', item, 'prevSeriesIdx', prevSeriesIdx);
					
					if( item.categoryColor != undefined && item.categoryColor != null && item.categoryColor !="" ) {
						if( result.colors == undefined ) result.colors = [];
						result.colors.push(item.categoryColor);
					}
					
					if( prevSeriesIdx != item.seriesIdx || data.length == (idx + 1)) {
						// push series
						if( prevSeriesIdx > -1 ) {
					        tempSeries.name.push(preSeriesName);
							result.series.push(tempSeries);
						}
						tempSeries = {
							data : [],
							name : []
						};
					}
					
					// push code & data
					preSeriesName = item.seriesName;
					tempSeries.data.push([item.seriesCode, item.seriesData, item.categoryLabel]);
					
					prevSeriesIdx = item.seriesIdx;
				}
			});
		}
		return result;
	},
	
	/** 옵션 색상 설정
	 */
	setColorsForApex : function(options) {
		// set color
		if( options.colors == undefined || options.colors == null ) {
			var colors = [];
			options.series.forEach(function(item, idx, arr) {
				var colorIdx = idx;
				if( idx > 50 ) {
					colorIdx = idx % HR_CHART_COLORS.length;
				}
				//console.log('colorIdx', colorIdx, HR_CHART_COLORS[colorIdx]);
				colors.push(HR_CHART_COLORS[colorIdx]);
			});
			options.colors = colors;
			//console.log('colors', options.colors);
		}
		return options;
	},
	
	/** Merge Chart Option
	 */
	mergeOption : function(defaultOpt, addOpt) {
		//console.log('[HR_CHART_UTIL.mergeOption] defaultOpt', defaultOpt, 'addOpt', addOpt);
		if( addOpt != undefined && addOpt != null ) {
			// 추가 옵션이 문자열 형태인 경우
			if( typeof addOpt != "object" ) {
				addOpt = eval("(" + addOpt + ")");
			}
			return $.extend(true, defaultOpt, addOpt);
		} else {
			return defaultOpt;
		}
	},
	
	/**
	 * Apexchart 출력
	 */
	renderApexChart : function(targetEleSelector, options) {
		var result = {
			chart : null,
			CODE  : "SUCCESS"
		}, chart;
		try {
			if( options != undefined && options != null ) {
				/* 다운로드 파일명 설정 */
				var fileNm = (options.title != undefined) ? options.title.text : targetEleSelector;
				if( options.chart.toolbar == undefined ) {
					options.chart.toolbar = {
						show: true,
						tools: {
							download: true
						}
					};
				}
				if( options.chart.toolbar.export == undefined ) {
					options.chart.toolbar.export = {
						svg: {},
						png: {},
						csv: {}
					};
				}
				fileNm += "_" +  Math.floor(+ new Date() / 1000);
				options.chart.toolbar.export.svg.filename = fileNm;
				options.chart.toolbar.export.png.filename = fileNm;
				options.chart.toolbar.export.csv.filename = fileNm;
				/* 다운로드 파일명 설정 */
				
				//console.log('[HR_CHART_UTIL.renderApexChart] options', options);
				chart = new ApexCharts($(targetEleSelector).get(0), options);
				chart.render();
				// 리턴 결과 객체에 차트 객체 삽입
				result.chart = chart;
			} else {
				result.CODE  = "EMPTY_OPTION";
			}
		} catch(e) {
			console.log('renderApexChart fail', 'e', e);
			result.chart = null;
			result.CODE  = "FAIL";
		}
		return result;
	},
	
	/**
	 * jQCloud 출력
	 */
	renderJQCloud : function(targetEleSelector, words, options) {
		var result = {
			chart : null,
			CODE  : "SUCCESS"
		}, chart;
		try {
			if( words != undefined && words != null ) {
				console.log('[HR_CHART_UTIL.renderJQCloud] targetEleSelector', targetEleSelector, 'words', words, 'options', options);
				chart = $(targetEleSelector).jQCloud(words, options);
				// 리턴 결과 객체에 차트 객체 삽입
				result.chart = chart;
			} else {
				result.CODE  = "EMPTY_DATA";
			}
		} catch(e) {
			//console.log('renderJQCloud fail', 'e', e);
			result.chart = null;
			result.CODE  = "FAIL";
		}
		return result;
	},
	
	/** 차트 출력 : targetEle 엘리먼트에 지정된 statsCd 통계 코드에 해당하는 차트 출력
	 */
	renderChartByStatsCd : function(targetEle, statsCd, chartSizeW, chartSizeH) {
		var data, ele, defaultSize = 200, chart;
		if( targetEle && targetEle != undefined && statsCd && statsCd != undefined ) {
			data = ajaxCall("/StatsMng.do?cmd=getStatsMngChartDataMap", "searchStatsCd=" + statsCd, false);
			if( data && data != null && data.DATA && data.DATA != null ) {
				// set chart option
				var chartOpt = eval("(" + data.DATA.chartOpt + ")");
				if( chartOpt.chart == undefined ) {
					chartOpt.chart = {};
				}
				
				// set chart size
				chartOpt.chart.width  = ( chartSizeW == undefined ) ? parseInt(data.DATA.chartSizeW) * defaultSize : chartSizeW;
				chartOpt.chart.height = ( chartSizeH == undefined ) ? parseInt(data.DATA.chartSizeH) * defaultSize : chartSizeH;
				
				// render chart
				$(targetEle).css({
					"width" : chartOpt.chart.width + "px"
				});
				
				ele = $(targetEle).get(0);
				
				chart = HR_CHART[data.DATA.pluginObjNm].render(ele, chartOpt, data.LIST);
			}
		}
		return chart;
	},
	
	/** 차트 미리보기 팝업 출력
	 */
	openChartPreviewPop : function(statsCd, statsNm, chartSizeW, chartSizeH, originSizeYn) {
		if( originSizeYn == undefined ) originSizeYn = "Y";
		// 데이터 필수 정의 컬럼 팝업
		if(!isPopup()) {return;}
		var url = '/StatsMng.do?cmd=viewStatsMngPreviewLayer&authPg=R';
		var w, h, defaultSize = 200;
		var title = "차트 미리보기";
		w = 160 + (defaultSize * chartSizeW);
		h = 160 + (defaultSize * chartSizeH);
		var p = {searchStatsCd : statsCd,
				 searchStatsNm : statsNm,
				 chartSizeW    : chartSizeW,
				 chartSizeH    : chartSizeH,
				 originSizeYn  : originSizeYn};
		var layerModal = new window.top.document.LayerModal({
			id : 'statsMngPreviewLayer', 
			url : url, 
			parameters: p,
			width : w,
			height : h,
			title : title
		});
		layerModal.show();
	}
};

/**
 * 차트 정의
 */
var HR_CHART = {
	
	/** Apexchart > Line > Basic
	 */
	APEX_LINE_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_NAME", "SERIES_DATA", "CATEGORY_COLOR", "CATEGORY_LABEL"],
		
		render : function(targetEle, chartOpt, dataList) {
			//console.log("chartOpt", chartOpt);
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'line'
				},
				xaxis: {}
			}, chartOpt);
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			if( data != undefined && data != null ) {
				options.series = data.series;
				options.seriesCode = data.seriesCode;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
	
	/** Apexchart > Area > Basic
	 */
	APEX_AREA_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_NAME", "SERIES_DATA", "CATEGORY_COLOR", "CATEGORY_LABEL"],
		
		render : function(targetEle, chartOpt, dataList) {
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'area'
				},
				xaxis: {}
			}, chartOpt);
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			if( data != undefined && data != null ) {
				options.series = data.series;
				options.seriesCode = data.seriesCode;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
	
	/** Apexchart > Column > Basic
	 */
	APEX_COLUMN_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_NAME", "SERIES_DATA", "CATEGORY_COLOR", "CATEGORY_LABEL"],
		
		// 차트 화면 출력
		render : function(targetEle, chartOpt, dataList) {
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'bar'
				},
				xaxis: {}
			}, chartOpt);
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			if( data != undefined && data != null ) {
				options.series = data.series;
				options.seriesCode = data.seriesCode;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
	
	/** Apexchart > Bar > Basic
	 */
	APEX_BAR_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_NAME", "SERIES_DATA", "CATEGORY_COLOR", "CATEGORY_LABEL"],
		
		render : function(targetEle, chartOpt, dataList) {
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'bar'
				},
				plotOptions: {
					bar: {
						horizontal: true,
					}
				},
				xaxis: {}
			}, chartOpt);
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			if( data != undefined && data != null ) {
				options.series = data.series;
				options.seriesCode = data.seriesCode;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
				if( data.colors != undefined && data.colors != null ) options.colors = data.colors;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
		
	/** Apexchart > Mix > Basic
	 */
	APEX_MIX_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_NAME", "SERIES_DATA", "SERIES_CHART_TYPE", "CATEGORY_COLOR", "CATEGORY_LABEL"],
		
		render : function(targetEle, chartOpt, dataList) {
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'line'
				},
				xaxis: {}
			}, chartOpt);
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			if( data != undefined && data != null ) {
				options.series = data.series;
				options.seriesCode = data.seriesCode;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
				if( data.colors != undefined && data.colors != null ) options.colors = data.colors;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			// setting yaxis
			if( options.yaxis == undefined || options.yaxis == null ) {
				options.yaxis = [];
				options.series.forEach(function(item, idx, arr) {
					options.yaxis.push({
						title: {
							text: item.name
						},
						opposite: (idx > 0) ? true : false
					});
				});
			} else {
				if( typeof options.yaxis === "object" && Array.isArray(options.yaxis) ) {
					options.yaxis.forEach(function(item, idx, arr) {
						// title 설정
						if( item.title == undefined || item.title == null ) item.title = {};
						if( item.title.text == undefined || item.title.text == null ) item.title.text = options.series[idx].name;
						
						// opposite (y축  우측정렬여부) 설정
						if( item.opposite == undefined || item.opposite == null ) {
							item.opposite = (idx > 0) ? true : false;
						}
						
						// merge option
						options.yaxis[idx] = $.extend(true, options.yaxis[idx], item);
					});
				}
			}
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
	
	/** Apexchart > Pie > Basic
	 */
	APEX_PIE_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_DATA", "CATEGORY_LABEL", "CATEGORY_COLOR"],
		
		render : function(targetEle, chartOpt, dataList) {
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'pie'
				}
			}, chartOpt);
			
			if( options.chart.width == 250 && options.chart.height == 250 ) {
				if( options.legend == undefined ) options.legend = {};
				options.legend.show = false;
			}
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			if( data != undefined && data != null ) {
				options.series = data.series[0].data;
				options.seriesCode = data.seriesCode[0].code;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
				if( data.colors != undefined && data.colors != null ) options.colors = data.colors;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
	
	/** Apexchart > Polar Area > Basic
	 */
	APEX_POLAR_AREA_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_DATA", "CATEGORY_LABEL", "CATEGORY_COLOR"],
		
		render : function(targetEle, chartOpt, dataList) {
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'polarArea'
				}
			}, chartOpt);
			
			if( options.chart.width == 250 && options.chart.height == 250 ) {
				if( options.legend == undefined ) options.legend = {};
				options.legend.show = false;
			}
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			if( data != undefined && data != null ) {
				options.series = data.series[0].data;
				options.seriesCode = data.seriesCode[0].code;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
				if( data.colors != undefined && data.colors != null ) options.colors = data.colors;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
		
	/** Apexchart > Radial > Basic
	 */
	APEX_RADIAL_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_DATA", "CATEGORY_LABEL", "CATEGORY_COLOR"],
		
		render : function(targetEle, chartOpt, dataList) {
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'radialBar'
				},
				plotOptions: {
					radialBar: {
						hollow: {
							size: '70%',
						}
					},
				}
			}, chartOpt);
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			if( data != undefined && data != null ) {
				options.series = data.series[0].data;
				options.seriesCode = data.seriesCode[0].code;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
				if( data.colors != undefined && data.colors != null ) options.colors = data.colors;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
	
	/** Apexchart > Radar > Basic
	 */
	APEX_RADAR_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_NAME", "SERIES_DATA", "CATEGORY_LABEL", "CATEGORY_COLOR"],
		
		render : function(targetEle, chartOpt, dataList) {
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'radar'
				},
				dataLabels: {
					enabled: true
				},
				stroke: {
					width: 2
				},
				fill: {
					opacity: 0.2
				},
				markers: {
					size: 4,
					colors: [],
					strokeWidth: 2,
				},
				plotOptions: {
					radar: {
						polygons: {
							strokeColors: "#e9e9e9",
							fill: {
								colors: ["#f8f8f8", "#fff"]
							}
						}
					}
				}
			}, chartOpt);
			
			if( options.chart.width == 250 && options.chart.height == 250 ) {
				if( options.legend == undefined ) options.legend = {};
				options.legend.show = false;
			}
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			if( data != undefined && data != null ) {
				options.series = data.series;
				options.seriesCode = data.seriesCode;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
				if( data.colors != undefined && data.colors != null ) {
					options.colors = data.colors;
					options.markers.colors = data.colors;
				}
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
	
	/** Apexchart > Treemap > Basic
	 */
	APEX_TREEMAP_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_NAME", "SERIES_DATA", "CATEGORY_LABEL", "CATEGORY_COLOR"],
		
		render : function(targetEle, chartOpt, dataList) {
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'treemap',
					offsetX : 0
				},
				legend: {
					show: true,
					itemMargin: {
						vertical: 15
					}
				},
				dataLabels: {
					enabled: true,
					formatter: function(text, op) {
						return [text, op.value];
					}
				},
				plotOptions: {
					treemap: {
						distributed: false,
						enableShades: true
					}
				}
			}, chartOpt);
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexTreemapFormat(dataList);
			
			if( data != undefined && data != null ) {
				options.series = data.series;
				options.seriesCode = data.seriesCode;
				if( data.colors != undefined && data.colors != null ) options.colors = data.colors;
			}
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			if( chart.CODE == "SUCCESS" ) {
				var calOffsetX = 0, chartWidth = $(targetEle).width(), mapWidth = Math.round($(targetEle).find(".apexcharts-grid line:eq(0)").attr("x2"));
				if( mapWidth <= chartWidth ) {
					calOffsetX = (chartWidth - mapWidth)/2;
				} else {
					calOffsetX = (mapWidth - chartWidth)/2;
				}
				//console.log('[APEX_TREEMAP_BASIC] update calOffsetX', calOffsetX);
				chart.chart.updateOptions({
					chart : {
						offsetX : calOffsetX
					}
				});
			}
			return chart;
		}
	},
	/** Apexchart > Funnel > Basic  20240416 추가
	 */
	APEX_FUNNEL_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_NAME", "SERIES_DATA", "CATEGORY_LABEL", "CATEGORY_COLOR"],
		
		render : function(targetEle, chartOpt, dataList) {
			//console.log("chartOpt", chartOpt, dataList);
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'bar',
					height: 350
				},
				legend: {
					show: true,
					itemMargin: {
						vertical: 15
					}
				},
				dataLabels: {
					enabled: true,
	                formatter: function (val, opt) {
	                  return opt.w.globals.labels[opt.dataPointIndex] + ':  ' + val;
	                },
	                dropShadow: {
	                  enabled: true,
	                }
				},
				plotOptions: {
					bar: {
	                  borderRadius: 0,
	                  horizontal: true,
	                  barHeight: '80%',
	                  isFunnel: true,
	                }
				}
			}, chartOpt);
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			console.log("data", data);
			if( data != undefined && data != null ) {
				options.series = data.series;
				options.seriesCode = data.seriesCode;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
	/** Apexchart > Heatmap > Basic  20240416 추가
	 */
	APEX_HEATMAP_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_NAME", "SERIES_DATA", "CATEGORY_LABEL", "CATEGORY_COLOR"],
		
		render : function(targetEle, chartOpt, dataList) {
			//console.log("dataList", dataList);
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'heatmap',
					height: 350
				},
				dataLabels: {
					enabled: true
				},
				xaxis: {}
			}, chartOpt);
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexFormat(dataList);
			console.log("data", data);
			if( data != undefined && data != null ) {
				options.series = data.series;
				options.seriesCode = data.seriesCode;
				if( data.categories != undefined && data.categories != null ) options.labels = data.categories;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
	/** Apexchart > Heatmap > Basic  20240416 추가
	 */
	APEX_BUBBLE_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_IDX", "SERIES_NAME", "SERIES_CODE", "SERIES_DATA", "CATEGORY_LABEL", "CATEGORY_COLOR"],
		// SERIES_IDX, SERIES_NAME : 구분
		// SERIES_CODE : X축
		// SERIES_DATA : Y축
		// CATEGORY_LABEL : Z값
		render : function(targetEle, chartOpt, dataList) {
			var options = HR_CHART_UTIL.mergeOption({
				chart: {
					type: 'bubble',
					height: 350
				},
				dataLabels: {
					enabled: false
				},
				fill: {
				  opacity: 0.8
				},
				xaxis: {}
			}, chartOpt);
			
			// put data
			var data = HR_CHART_UTIL.convDataForApexBubbleFormat(dataList);
			console.log("data", data);
			if( data != undefined && data != null ) {
				options.series = data.series;
			}
			
			// set color
			options = HR_CHART_UTIL.setColorsForApex(options);
			
			var chart = HR_CHART_UTIL.renderApexChart(targetEle, options);
			return chart;
		}
	},
	/** jQCloude
	 */
	JQCLOUD_BASIC : {
		// 데이터 필수 정의 컬럼
		DATA_SQL_SCHEME : ["SERIES_NAME", "SERIES_DATA"],
		
		render : function(targetEle, chartOpt, dataList) {
			var words = [], options = HR_CHART_UTIL.mergeOption({
				delay: 0,
				autoResize: true,
				colors: ["#084081", "#0072bc", "#12b967", "#4bc355", "#85cd44", "#bed732", "#c5d85c", "#cdd987", "#d4dab1", "#dbdbdb"],
				fontSize: {
					from: 0.15,
					to  : 0.05
				}
			}, chartOpt);
			
			// set box size
			options.width = chartOpt.chart.width;
			options.height = chartOpt.chart.height;
			$(targetEle).empty().css({
				"display" : "block",
				"width" : chartOpt.chart.width + "px",
				"height" : chartOpt.chart.height + "px"
			});
			
			// set title
			if( options.title && options.title.text ) {
				options.height -= 31;
				$(targetEle).append($("<div/>", {
					"class" : "header alignL"
				}).css({
					"width" : chartOpt.chart.width + "px",
					"height" : "31px",
					"display" : "flex",
					"justify-content" : "space-between",
					"align-items" : "center"
				}).append(
					$("<span/>", {
						"class" : "title"
					}).css({
						"color" : "#373d3f",
						"font-size" : "14px",
						"font-weight" : "900",
						"font-family" : "Helvetica, Arial, sans-serif",
						"margin-left" : "10px"
					}).text(options.title.text)
				));
			}
			
			$(targetEle).append($("<div/>", {
				"class" : "body"
			}).css({
				"display" : "block",
				"width" : chartOpt.chart.width + "px",
				"height" : chartOpt.chart.height + "px"
			}));
			
			// convert dataList
			var colors = [];
			dataList.forEach(function(item, idx, arr){
				if( item.seriesName != undefined && item.seriesData != undefined ) {
					words.push({
						text: item.seriesName,
						weight: Number(item.seriesData),
						html: {
							title : (item.categoryLabel) ? item.categoryLabel : item.seriesName + " : " + item.seriesData,
							data  : item.seriesData,
							code  : item.seriesCode
						}
					});
				}
				if( item.categoryColor != undefined ) {
					colors.push(item.categoryColor);
				}
			});
			
			/** Set Fix Options */
			options.classPattern = "keyword";
			options.removeOverflowing = true;
			options.steps = 10;
			options.fontSize.from = Number(1/options.steps).toFixed(2);
			//if( options.fontSize.from < 0.15 ) options.fontSize.from = 0.15;
			if( chartOpt.chart.width > chartOpt.chart.height ) {
				//console.log('ratio', (options.height / options.width), 'from', options.fontSize.from);
				options.fontSize.from = options.fontSize.from * (options.height / options.width);
				options.fontSize.from = options.fontSize.from * (1 + ((options.width - options.height) / options.width));
				options.fontSize.from = Number(options.fontSize.from).toFixed(2);
			}
			options.fontSize.to = (options.fontSize.from / 2);
			//console.log('options.fontSize', options.fontSize);
			/** Set Fix Options */
			
			if( colors.length > 0 ) options.colors = colors;
			
			// set callback
			options.afterCloudRender = function() {
				// convert rgb to hex
				var rgb2hex = function(rgb) {
					if ( rgb.search("rgb") == -1 ) {
						return rgb;
					} else {
						rgb = rgb.match(/^rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*(\d+))?\)$/);
						function hex(x) {
							return ("0" + parseInt(x).toString(16)).slice(-2);
						}
						return "#" + hex(rgb[1]) + hex(rgb[2]) + hex(rgb[3]);
					}
				};
				
				$(".keyword", this).each(function(){
					//console.log('keyword color', $(this).css("color"), 'hex', rgb2hex($(this).css("color")));
					// 폰트 색상을 hex로 변환하여 data-color 속성으로 저장
					$(this).attr("data-color", rgb2hex($(this).css("color")));
					// hover 시 이벤트 추가
					$(this).hover(
						function(event){
							$(this).css("background-color", $(this).data("color"));
						},
						function(event){
							$(this).css("background-color", "");
						}
					);
				});
				if( chartOpt.chart.events && chartOpt.chart.events.click ) {
					// put event
					$(".keyword", this).addClass("pointer").on("click", function(e){
						// 실행 함수에 전달될 파라미터 배열
						var callFnArgs = [];
						callFnArgs.push($(this).html());
						callFnArgs.push($(this).attr("data") ? $(this).attr("data") : null);
						callFnArgs.push($(this).attr("code") ? $(this).attr("code") : null);
						callFnArgs.push(options.param);	// 차트 옵션의 파라미터 json 객체
						
						// 차트 옵션  JSON하위 클릭 이벤트로 설정된 function 실행
						chartOpt.chart.events.click.apply(this, callFnArgs);
					});
				}
			};
			
			var chart = HR_CHART_UTIL.renderJQCloud(targetEle + " .body", words, options);
			return chart;
		}
	}
};