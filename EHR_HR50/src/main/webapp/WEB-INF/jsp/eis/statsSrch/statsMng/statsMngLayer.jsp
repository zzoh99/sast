<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>통계 관리 팝업</title>
<!--  ACE Code Editor SCRIPT -->
<script src="${ctx}/common/plugin/EIS/ace/js/ace.js" type="text/javascript" charset="UTF-8"></script>
<!--  ACE Code Editor SCRIPT -->
<script src="${ctx}/common/plugin/EIS/js/chart.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript"></script>
<style type="text/css">
	.editPresetInfo {
		z-index: 10;
		position: fixed;
		top: 10px;
		right: 50px;
		display: inline-block;
		min-width: 40px;
		text-align: center;
		background-color: #fff;
		height: 28px;
		line-height: 26px;
		border-radius: 14px;
		padding: 0 15px;
	}
	
	.title-wrap .select-wrap{
		width: 200px;
	}
	.chart-size-wrap {
	    display: flex;
	    align-items: baseline;
	    flex-direction: row;
	    gap: 20px;
	  }
	
	  .range-container {
	    display: flex;
	    align-items: center;
	    gap: 10px;
	    flex-direction: column;
	    position: relative;
	  }
	
	  input[type="range"].tick-range {
	    -webkit-appearance: none;
	    width: 300px;
	    height: 6px;
	    background: #ddd;
	    border-radius: 5px;
	    outline: none;
	    transition: background 0.3s;
	  }
	  
	  input[type="range"].tick-range:focus {
		border:0px;
	  }
	
	  input[type="range"].tick-range::-webkit-slider-thumb {
	    -webkit-appearance: none;
	    appearance: none;
	    width: 12px;
	    height: 12px;
	    border-radius: 50%;
	    background: #2570f9;
	    cursor: pointer;
	  }
	
	  .tick-marks {
	    display: flex;
	    justify-content: space-between;
	    width: 300px;
	    padding: 0 2px;
	    position: relative;
	    top: -10px;
	  }
	
	  .tick-marks span {
	    font-size: 12px;
	    color: #666;
	  }
	
	  .range-value {
	    font-weight: bold;
	    color: #333;
	    font-size: 16px;
	  }
	/* tab */
	.ui-tabs:not(.sub_top) .ui-tabs-nav{
		background: rgba(255,255,255,0);
		border:0px;
		border-bottom: 1px solid #dddddd;
	}
	.ui-tabs:not(.sub_top) .ui-tabs-nav li a{
		background: rgba(255,255,255,0);
	}
	
	pre.edit {
		height: calc(100% - 72px);
		border:1px #ddd solid;
		border-radius: 4px;
	}
	
	.popup_contents {
		display: flex;
		justify-content: space-between;
		width: 100%;
		height: calc(100vh - 185px);
	}
	.popup_contents .area_left {
		width: 60%;
	}
	.popup_contents .area_right {
		z-index: 100;
		position: fixed;
		right: 30px;
		min-width: 30%;
		height: calc(100vh - 230px);
		display: flex;
		justify-content: flex-start;
		background: #fff;
	}
	.popup_contents .area_right #area_toolbar {
		width: 31px;
		display: flex;
		justify-content: flex-end;
	}
	.popup_contents .area_right #area_toolbar button {
		width: 24px;
		height: 24px;
		background-color: #f6f6f6;
		border: none;
		border-radius: 6px;
		margin-right: 5px;
		cursor: pointer;
	}
	.popup_contents .area_right #area_toolbar button:hover {
		background-color: #6f6f6f;
		background-color: var(--txt_color_base, #6f6f6f);
		color: #fff;
	}
	.popup_contents .area_right #area_toolbar .btn_expand {
		margin-top: 8px;
		transform: rotate(90deg);
	}
	.popup_contents .area_right #area_previewWrap {
		position: relative;
		display: flex;
		justify-content: flex-start;
		width: 100%;
		height: 100%;
		background-color: #f6f6f6;
		border:1px #c6c6c6 solid;
		border-radius: 8px;
		overflow-x: auto;
		overflow-y: scroll;
	}
	.popup_contents .area_right #area_previewWrap.justCenter {
		justify-content: center;
	}
	.popup_contents .area_right #area_previewWrap #area_chartWrap .chart {
		display: flex;
		align-items: center;
		min-width: 200px;
		border-radius: 8px;
		background-color: #fff;
		box-sizing: border-box;
		box-shadow: 0 4px 12px 0 rgba(0,0,0,0.2);
		margin: 40px;
	}
	.popup_contents .area_right #area_previewWrap #area_chartWrap.alignSelf {
		align-self: center;
	}
</style>
<script type="text/javascript">
	var statsMngLayer = {id: 'statsMngLayer'};
	var g_cellDefaultSize = 120, g_defaultSize = 220;;
	var editor_chartOpt, editor_sqlSyntax, edit_sqlSyntaxSample;
	
	$(function() {
		$("textarea.edit").keydown(function(event){
			// 탭키 누른 경우 탭 입력 처리
			if(event.keyCode == 9){
				var v = this.value, s = this.selectionStart, e = this.selectionEnd;
				this.value = v.substring(0, s)+'\t'+v.substring(e);
				this.selectionStart = this.selectionEnd=s+1;
				return false;
			}
		});

		const modal = window.top.document.LayerModalUtility.getModal(statsMngLayer.id);
        // 전체화면출력
        modal.makeFull();

		var { searchStatsCd, searchStatsNm } = modal.parameters;
		$("#searchStatsCd").val(searchStatsCd);
		$("#searchStatsNm").val(searchStatsNm);
		
		// 현재작업통계구성명 삽입
		$(".editPresetInfo").html($("<span/>", {
			"class" : ""
		}).text("작업 통계 : "));
		$(".editPresetInfo").append($("<span/>", {
			"class" : "f_point f_bold"
		}).text(searchStatsNm));
		
		// Set Event
		$("#chartSizeW, #chartSizeH").on("change", function(e) {
			$(".disp_chartSize").html($("#chartSizeW").val() + " X " + $("#chartSizeH").val());
			// 차트 출력
			previewChart();
		});
		$("#chartCd").on("change", function(e){
			setSampleSqlSyntax($("option:selected", this).attr("pluginObjNm"));
		});
		
		var previewAreaW = ($(".popup_main").width() * 0.4) - 5;
		$(".popup_contents .area_right").attr("data-width", previewAreaW).css({
			"width" : previewAreaW + "px"
		});
		
		// Set Chart Dashboard
		var scrWidth = screen.availWidth;
		if( scrWidth < 1440 ) {
			g_defaultSize = 180;
		} else if( scrWidth < 1024 ) {
			g_defaultSize = 130;
		}
		
		// tab
		$( "#tabs" ).tabs();
		
		// sample_sqlSyntax 코드 에디터 설정
		edit_sqlSyntaxSample = initEditor(edit_sqlSyntaxSample, "edit_sqlSyntaxSample", "sql");
		edit_sqlSyntaxSample.setShowPrintMargin(false);
		edit_sqlSyntaxSample.setReadOnly(true);
		edit_sqlSyntaxSample.blur();
		
		var chartCdList = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getChartItemMngCodeList", false);
		chartCdList = convCodeCols(chartCdList.codeList, "pluginObjNm", "");
		$("#chartCd").html("<option value=''>전체</option>" + chartCdList[2]);
		
		var data = ajaxCall("${ctx}/StatsMng.do?cmd=getStatsMngMap", $("#sendForm").serialize(), false);
		if( data && data != null && data.DATA && data.DATA != null ) {
			$("#chartCd").val(data.DATA.chartCd);
			$("#chartSizeW").val(data.DATA.chartSizeW);
			$("#chartSizeH").val(data.DATA.chartSizeH);
			$("#edit_chartOpt").html(data.DATA.chartOpt);
			$("textarea[name='chartOpt']").val(data.DATA.chartOpt);
			$("#edit_sqlSyntax").html(data.DATA.sqlSyntax);
			$("textarea[name='sqlSyntax']").val(data.DATA.sqlSyntax);
			$(".disp_chartSize").html(data.DATA.chartSizeW + " X " + data.DATA.chartSizeH);
			
			// 지정 차트의 데이터 필수 정의 컬럼 정보 조회
			var pluginObjNm = data.DATA.pluginObjNm
			if( pluginObjNm && pluginObjNm != null && pluginObjNm !="" ) {
				if( (HR_CHART[pluginObjNm] && HR_CHART[pluginObjNm] != null)
						&& (HR_CHART[pluginObjNm].DATA_SQL_SCHEME && HR_CHART[pluginObjNm].DATA_SQL_SCHEME != null) ) {
					var idx = 0;
					HR_CHART[pluginObjNm].DATA_SQL_SCHEME.forEach(function(item){
						if(idx > 0) {
							$("#requiredCols").append(", ");
						}
						$("#requiredCols").append("[" + item + "]");
						idx++;
					});
				}
			}
			
			// 사용 차트에 해당하는 sql 샘플 코드 삽입
			setSampleSqlSyntax(pluginObjNm);
		}
		
		if( $("#edit_chartOpt").html().length == 0 ) {
			$("#edit_chartOpt").html("{}");
		}
		
		// set chartOpt Ace Edit
		editor_chartOpt = initEditor(editor_chartOpt, "edit_chartOpt", "javascript");
		editor_chartOpt.gotoLine(1);
		editor_sqlSyntax = initEditor(editor_sqlSyntax, "edit_sqlSyntax", "sql");
		editor_sqlSyntax.gotoLine(1);
		
		// 차트 출력
		previewChart();
	});

	// 에디터 객체 생성
	function initEditor(obj, name, language) {
		obj = ace.edit(name);
		obj.setTheme("ace/theme/tomorrow");
		obj.session.setMode("ace/mode/" + language);
		obj.session.setOption("useWorker", false);
		// 단축키 명령 제거
		obj.commands.removeCommand('find');
		obj.commands.removeCommand('replace');
		return obj
	}
	
	// 차트 미리보기
	function previewChart() {
		var data = null, srchData = null, isContinue = true;
		var chartOpt = editor_chartOpt.getValue(), sqlSyntax = editor_sqlSyntax.getValue();
		
		// 차트 출력 영역 초기화
		$("#area_chartWrap").empty();
		
		// 차트 설정 JSON의 내용이 있는 경우 진행..
		if( chartOpt == null || chartOpt == "" ) {
			isContinue = false;
		}
		
		if(isContinue) {
			// SQL이 입력되어 있는 경우 데이터 조회
			if( sqlSyntax != null && sqlSyntax != "" ) {
				srchData = ajaxCall("${ctx}/StatsMng.do?cmd=getStatsMngChartDataList", "sqlSyntax=" + encodeURIComponent(sqlSyntax), false);
				//console.log('srchData', srchData);
				if( srchData && srchData.DATA && srchData.DATA != null ) {
					// convert data format
					data = srchData.DATA;
				}
			}
			//console.log('data', data);
			
			// set chart option
			if( chartOpt != null && chartOpt != "" ) {
				chartOpt = eval("(" + chartOpt + ")");
			}
			if( chartOpt.chart == undefined ) {
				chartOpt.chart = {};
			}
			
			// set chart size
			chartOpt.chart.width = (parseInt($("#chartSizeW").val()) * g_defaultSize);
			chartOpt.chart.height = (parseInt($("#chartSizeH").val()) * g_defaultSize);
			
			// 실제 차트 출력 영역 삽입
			$("#area_chartWrap").append($("<div/>", {
				"class" : "chart"
			}).css({
				"width" : chartOpt.chart.width + "px"
			}));
			
			// render chart
			var pluginObjNm = $("#chartCd option:selected").attr("pluginObjNm");
			var chart = HR_CHART[pluginObjNm].render("#area_chartWrap .chart", chartOpt, data);
			
			// 차트 출력 위치 조정
			relayoutChart();
		}
	}
	
	// 차트 미리보기 영역 사이즈 토글
	function togglePreviewSize() {
		var resizeWidth = 0;
		
		if( $(".btn_expand", ".popup_contents").hasClass("fa-expand") ) {
			resizeWidth = $(".popup_main").width() + 1;
		} else {
			resizeWidth = parseInt($(".popup_contents .area_right").data("width"));
		}
		
		$(".popup_contents .area_right").animate({
			width : resizeWidth + "px"
		},{
			start : function() {
				$("#area_chartWrap").fadeOut("fast");
			},
			complete : function() {
				if( $(".btn_expand", ".popup_contents").hasClass("fa-expand") ) {
					// 확대
					$(".btn_expand", ".popup_contents").removeClass("fa-expand").addClass("fa-compress").attr("title", "미리보기 영역 축소");
				} else {
					// 축소
					$(".btn_expand", ".popup_contents").removeClass("fa-compress").addClass("fa-expand").attr("title", "미리보기 영역 확대");
				}
				$("#area_chartWrap").fadeIn();
				// 차트 출력 위치 조정
				relayoutChart();
			}
		})
	}
	
	// 차트 출력 위치 조정
	function relayoutChart() {
		var previewWrapEle = $(".popup_contents #area_previewWrap"), chartWrapEle = $("#area_chartWrap", previewWrapEle), chartEle = $(".chart", chartWrapEle);
		//console.log('[relayoutChart]', 'width', chartEle.width(), 'height', chartEle.height(), 'parent width', previewWrapEle.width(), 'parent height', previewWrapEle.height());
		
		// 차트 너비가 미리보기 영역 너비보다 작은 경우 중앙 정렬
		previewWrapEle.removeClass("justCenter");
		if( chartWrapEle.width() < previewWrapEle.width() ) {
			previewWrapEle.addClass("justCenter");
		}
		// 차트 높이가 미리보기 영역 높이보다 작은 경우 중앙 정렬
		chartWrapEle.removeClass("alignSelf");
		if( chartEle.height() < previewWrapEle.height() ) {
			chartWrapEle.addClass("alignSelf");
		}
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Save":
				// 차트 옵션 JSON, SQL 값 이관
				var chartOpt = editor_chartOpt.getValue(), sqlSyntax = editor_sqlSyntax.getValue();
				$("textarea[name='chartOpt']").val(chartOpt);
				$("textarea[name='sqlSyntax']").val(sqlSyntax);
				if(!checkList()) return ;
				if (confirm( "저장하시겠습니까?")) {
					try{
						var rtn = ajaxCall("${ctx}/StatsMng.do?cmd=saveStatsMngSetting",$("#sendForm").serialize(),false);
						if(rtn.Result.Code > 0) {
							alert(rtn.Result.Message);
						}else{
							alert(rtn.Result.Message);
							return;
						}
						const modal = window.top.document.LayerModalUtility.getModal(statsMngLayer.id);
						modal.fire(statsMngLayer.id + 'Trigger');
						if( confirm("팝업창을 닫으시겠습니까?") ) {
							modal.hide();
						}
					} catch (ex){
						alert("저장중 스크립트 오류발생." + ex);
					}
				}
				break;
		}
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prev().text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}
	
	// set contents sample_sqlSyntax
	function setSampleSqlSyntax(pluginObjNm) {
		var sampleSql = "";
		$("pre.sample_sql").each(function(idx){
			if( $(this).attr("mapping").indexOf(pluginObjNm) > -1 ) {
				sampleSql = $(this).html().trim();
				return false;
			}
		});
		edit_sqlSyntaxSample.setValue(sampleSql);
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="sendForm" name="sendForm" method="POST">
			<input type="hidden" id="searchStatsCd" name="searchStatsCd" value="" />
			<input type="hidden" id="searchStatsNm" name="searchStatsNm" value="" />
	        <div class="editPresetInfo"></div>
			<div class="mab20 title-wrap">
				<!-- 사용 차트 -->
				<strong class="title">사용 차트</strong>
				<div class="select-wrap">
					<select id="chartCd" name="chartCd" class="select mal10 custom_select"></select>
				</div>
				<!-- 차트 크기 설정 -->
				<!-- <span class="mal30"><strong>차트 사이즈</strong></span>
				<span class="mal10">가로</span>
				<input type="range" id="chartSizeW" name="chartSizeW" class="valignM mal5" min="1" max="6" />
				<span class="mal10">세로</span>
				<input type="range" id="chartSizeH" name="chartSizeH" class="valignM mal5" min="1" max="6" />
				<span class="disp_chartSize basic f_point f_s13 mal10"></span> -->
				<div class="chart-size-wrap">
				<span class="">가로</span>
			    <div class="range-container">
			      <input type="range" id="chartSizeW" name="chartSizeW" class="valignM tick-range" min="1" max="6" step="1" value="3">
			      <div class="tick-marks">
			        <span>1</span><span>2</span><span>3</span><span>4</span><span>5</span><span>6</span>
			      </div>
			    </div>
			    <span class="">세로</span>
			    <div class="range-container">
			      <input type="range" id="chartSizeH" name="chartSizeH" class="valignM tick-range" min="1" max="6" step="1" value="2">
			      <div class="tick-marks">
			        <span>1</span><span>2</span><span>3</span><span>4</span><span>5</span><span>6</span>
			      </div>
			    </div>
			    	<span class="disp_chartSize basic f_point f_s13 mal10"></span>
			  	</div>
				<!-- 차트 미리보기 -->
				<a href="javascript:previewChart();" class="btn filled ml-auto">차트 미리보기</a>
			</div>
			<div class="popup_contents">
				<div class="area_left">
					<div id="tabs" class="tab" style="height: calc(100vh - 185px);">
						<ul>
							<li><a href="#tabs-1">차트 옵션 설정</a></li>
							<li><a href="#tabs-2">SQL</a></li>
							<li><a href="#tabs-3">참고 사항</a></li>
						</ul>
						<div id="tabs-1">
							<div class='layout_tabs'>
								<p class="mab10">
									<strong>차트 옵션 JSON</strong>
								</p>
								<pre id="edit_chartOpt" class="edit"></pre>
								<textarea name="chartOpt" class="hide"></textarea>
							</div>
						</div>
						<div id="tabs-2">
							<div class='layout_tabs'>
								<div class="mab20">
									<p class="mab10"><strong>데이터 필수 정의 컬럼</strong></p>
									<p id="requiredCols" style="border:1px #ddd solid; padding:10px;"></p>
								</div>
								<p class="mab10"><strong>SQL</strong></p>
								<pre id="edit_sqlSyntax" class="edit" style="height: calc(100% - 162px);"></pre>
								<textarea name="sqlSyntax" class="hide"></textarea>
							</div>
						</div>
						<div id="tabs-3" >
							<div class='layout_tabs'>
								<h2 class="f_s13 f_bold">1. 사용 차트 라이브러리</h2>
								<div class="mat10 mab30 padl10 padr10">
									<table class="table">
										<colgroup>
											<col width="20%" />
											<col width="15%" />
											<col width="15%" />
											<col width="*" />
										</colgroup>
										<thead>
											<tr>
												<th>라이브러리</th>
												<th>버전</th>
												<th>라이선스</th>
												<th>URL</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td class="f_bold f_point">ApexCharts</td>
												<td>3.41.0</td>
												<td>MIT</td>
												<td>
													<a href="https://apexcharts.com/javascript-chart-demos/" target="_blank">DEMO</a>,
													<a href="https://apexcharts.com/docs/installation/" target="_blank">Document</a>
												</td>
											</tr>
											<tr>
												<td class="f_bold f_point">jQCloud</td>
												<td>2.0.3</td>
												<td>MIT</td>
												<td><a href="http://mistic100.github.io/jQCloud/index.html" target="_blank">Document</a></td>
											</tr>
										</tbody>
									</table>
								</div>
								<h2 class="f_s13 f_bold mab10">2. 선택 차트의 SQL 예시</h2>
								<pre id="edit_sqlSyntaxSample" class="edit" style="height: calc(100% - 224px);"></pre>
							</div>
						</div>
					</div>
				</div>
				<div class="area_right">
					<div id="area_toolbar">
						<button type="button" class="btn_expand fa fa-expand" onclick="javascript:togglePreviewSize();" title="미리보기 영역 확대"></button>
					</div>
					<div id="area_previewWrap">
						<div id="area_chartWrap">
							<div class="chart"></div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
    <div class="modal_footer">
        <a href="javascript:doAction1('Save');" class="btn filled"><tit:txt mid='104476' mdef='저장'/></a>
        <a href="javascript:closeCommonLayer('statsMngLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
    </div>
</div>
<!-- SQL 샘플 [일반] -->
<pre class="sample_sql hide" mapping="APEX_LINE_BASIC APEX_AREA_BASIC APEX_COLUMN_BASIC APEX_BAR_BASIC APEX_RADAR_BASIC">
SELECT SERIES_IDX
     , SERIES_NAME
     , SERIES_DATA
     , CATEGORY_LABEL
     , CATEGORY_COLOR /* 카테고리별 색상을 별도로 지정 시 사용 */
  FROM (
        SELECT 0 AS SERIES_IDX
             , 'series-1' AS SERIES_NAME
             , 40 AS SERIES_DATA
             , '#FDBCD6' AS CATEGORY_COLOR
             , 'category#1' AS CATEGORY_LABEL
          FROM DUAL
         UNION ALL
        SELECT 0 AS SERIES_IDX
             , 'series-1' AS SERIES_NAME
             , 30 AS SERIES_DATA
             , '#FDBCD6' AS CATEGORY_COLOR
             , 'category#2' AS CATEGORY_LABEL
          FROM DUAL
         UNION ALL
        SELECT 0 AS SERIES_IDX
             , 'series-1' AS SERIES_NAME
             , 60 AS SERIES_DATA
             , '#FDBCD6' AS CATEGORY_COLOR
             , 'category#3' AS CATEGORY_LABEL
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 'series-2' AS SERIES_NAME
             , 50 AS SERIES_DATA
             , '#62A4F6' AS CATEGORY_COLOR
             , 'category#1' AS CATEGORY_LABEL
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 'series-2' AS SERIES_NAME
             , 10 AS SERIES_DATA
             , '#62A4F6' AS CATEGORY_COLOR
             , 'category#2' AS CATEGORY_LABEL
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 'series-2' AS SERIES_NAME
             , 30 AS SERIES_DATA
             , '#62A4F6' AS CATEGORY_COLOR
             , 'category#3' AS CATEGORY_LABEL
          FROM DUAL
       )
</pre>
<!-- SQL 샘플 [PIE/Radial] -->
<pre class="sample_sql hide" mapping="APEX_PIE_BASIC APEX_POLAR_AREA_BASIC APEX_RADIAL_BASIC">
SELECT 0 AS SERIES_IDX
     , SERIES_DATA
     , CATEGORY_LABEL
     , CATEGORY_COLOR /* 카테고리별 색상을 별도로 지정 시 사용 */
  FROM (
        SELECT 86 AS SERIES_DATA
             , '1st Progress' AS CATEGORY_LABEL
             , '#00E396' AS CATEGORY_COLOR
          FROM DUAL
         UNION ALL
        SELECT 25 AS SERIES_DATA
             , '2nd Progress' AS CATEGORY_LABEL
             , '#EA3546' AS CATEGORY_COLOR
          FROM DUAL
         UNION ALL
        SELECT 61 AS SERIES_DATA
             , '3rd Progress' AS CATEGORY_LABEL
             , '#7D02EB' AS CATEGORY_COLOR
          FROM DUAL
       )
</pre>
<!-- SQL 샘플 [혼합형] -->
<pre class="sample_sql hide" mapping="APEX_MIX_BASIC">
SELECT SERIES_IDX
     , SERIES_NAME
     , SERIES_DATA
     , SERIES_CHART_TYPE
     , CATEGORY_LABEL
     , CATEGORY_COLOR /* 카테고리별 색상을 별도로 지정 시 사용 */
  FROM (
        SELECT 0 AS SERIES_IDX
             , 'series-1' AS SERIES_NAME
             , 40 AS SERIES_DATA
             , 'column' AS SERIES_CHART_TYPE
             , '#FDBCD6' AS CATEGORY_COLOR
             , 'category#1' AS CATEGORY_LABEL
          FROM DUAL
         UNION ALL
        SELECT 0 AS SERIES_IDX
             , 'series-1' AS SERIES_NAME
             , 30 AS SERIES_DATA
             , 'column' AS SERIES_CHART_TYPE
             , '#FDBCD6' AS CATEGORY_COLOR
             , 'category#2' AS CATEGORY_LABEL
          FROM DUAL
         UNION ALL
        SELECT 0 AS SERIES_IDX
             , 'series-1' AS SERIES_NAME
             , 60 AS SERIES_DATA
             , 'column' AS SERIES_CHART_TYPE
             , '#FDBCD6' AS CATEGORY_COLOR
             , 'category#3' AS CATEGORY_LABEL
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 'series-2' AS SERIES_NAME
             , 50 AS SERIES_DATA
             , 'line' AS SERIES_CHART_TYPE
             , '#62A4F6' AS CATEGORY_COLOR
             , 'category#1' AS CATEGORY_LABEL
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 'series-2' AS SERIES_NAME
             , 10 AS SERIES_DATA
             , 'line' AS SERIES_CHART_TYPE
             , '#62A4F6' AS CATEGORY_COLOR
             , 'category#2' AS CATEGORY_LABEL
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 'series-2' AS SERIES_NAME
             , 30 AS SERIES_DATA
             , 'line' AS SERIES_CHART_TYPE
             , '#62A4F6' AS CATEGORY_COLOR
             , 'category#3' AS CATEGORY_LABEL
          FROM DUAL
       )
</pre>
<!-- SQL 샘플 [트리맵] -->
<pre class="sample_sql hide" mapping="APEX_TREEMAP_BASIC">
SELECT SERIES_IDX
     , SERIES_NAME
     , SERIES_DATA
     , CATEGORY_LABEL
     , CATEGORY_COLOR /* 카테고리별 색상을 별도로 지정 시 사용 */
  FROM (
        SELECT 0 AS SERIES_IDX
             , 86 AS SERIES_DATA
             , 'DESKTOP' AS SERIES_NAME
             , 'Dell' AS CATEGORY_LABEL
             , '#00E396' AS CATEGORY_COLOR
          FROM DUAL
         UNION ALL
        SELECT 0 AS SERIES_IDX
             , 25 AS SERIES_DATA
             , 'DESKTOP' AS SERIES_NAME
             , 'Hp' AS CATEGORY_LABEL
             , '#EA3546' AS CATEGORY_COLOR
          FROM DUAL
         UNION ALL
        SELECT 0 AS SERIES_IDX
             , 61 AS SERIES_DATA
             , 'DESKTOP' AS SERIES_NAME
             , 'LG' AS CATEGORY_LABEL
             , '#7D02EB' AS CATEGORY_COLOR
          FROM DUAL
         UNION ALL
        SELECT 0 AS SERIES_IDX
             , 41 AS SERIES_DATA
             , 'DESKTOP' AS SERIES_NAME
             , 'Samsung' AS CATEGORY_LABEL
             , '#C5D86D' AS CATEGORY_COLOR
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 25 AS SERIES_DATA
             , 'LAPTOP' AS SERIES_NAME
             , 'Hp' AS CATEGORY_LABEL
             , '#5C4742' AS CATEGORY_COLOR
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 61 AS SERIES_DATA
             , 'LAPTOP' AS SERIES_NAME
             , 'Lenovo' AS CATEGORY_LABEL
             , '#449DD1' AS CATEGORY_COLOR
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 41 AS SERIES_DATA
             , 'LAPTOP' AS SERIES_NAME
             , 'LG' AS CATEGORY_LABEL
             , '#A5978B' AS CATEGORY_COLOR
          FROM DUAL
       )
</pre>
<!-- SQL 샘플 [트리맵] -->
<pre class="sample_sql hide" mapping="APEX_FUNNEL_BASIC">
SELECT SERIES_IDX
     , SERIES_NAME
     , SERIES_DATA
  FROM (
  --1380, 1100, 990, 880, 740, 548, 330, 200
        SELECT 0 AS SERIES_IDX
             , 1380 AS SERIES_DATA
             , 'Sourced' AS SERIES_NAME
          FROM DUAL
         UNION ALL
        SELECT 0 AS SERIES_IDX
             , 1100 AS SERIES_DATA
             , 'Screened' AS SERIES_NAME
          FROM DUAL
         UNION ALL
        SELECT 0 AS SERIES_IDX
             , 990 AS SERIES_DATA
             , 'Assessed' AS SERIES_NAME
          FROM DUAL
         UNION ALL
        SELECT 0 AS SERIES_IDX
             , 880 AS SERIES_DATA
             , 'HR Interview' AS SERIES_NAME
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 740 AS SERIES_DATA
             , 'Technical' AS SERIES_NAME
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 548 AS SERIES_DATA
             , 'Verify' AS SERIES_NAME
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 330 AS SERIES_DATA
             , 'Offered' AS SERIES_NAME
          FROM DUAL
         UNION ALL
        SELECT 1 AS SERIES_IDX
             , 200 AS SERIES_DATA
             , 'Hired' AS SERIES_NAME
          FROM DUAL
       )
</pre>
<!-- SQL 샘플 [트리맵] -->
<pre class="sample_sql hide" mapping="APEX_HEATMAP_BASIC">
SELECT B.SERIES_IDX - 1 AS SERIES_IDX
     , A.SERIES_NAME
     , B.SERIES_DATA
     , B.CATEGORY_LABEL
     , ''#fff'' AS CATEGORY_COLOR
  FROM (
        SELECT ''Metric'' || LEVEL AS SERIES_NAME, LEVEL AS SERIES_IDX
        FROM DUAL 
        CONNECT BY ROWNUM <= 9
       ) A
     , (
        SELECT TRUNC(DBMS_RANDOM.VALUE(10, 99)) AS SERIES_DATA
             , ''x''||( MOD(ROWNUM-1, 18) + 1 ) AS CATEGORY_LABEL
             , TRUNC((LEVEL-1) / 18) + 1 SERIES_IDX
        FROM DUAL
        CONNECT BY ROWNUM <= 162
       ) B
WHERE A.SERIES_IDX = B.SERIES_IDX
</pre>
<pre class="sample_sql hide" mapping="APEX_BUBBLE_BASIC">
SELECT SERIES_IDX
     , 'Bubble'||SERIES_IDX AS SERIES_NAME
     , X1 AS SERIES_CODE
     , Y1 AS SERIES_DATA
     , Z1 AS CATEGORY_LABEL
  FROM (
         SELECT TRUNC(DBMS_RANDOM.VALUE(10, 750-75)) AS X1
              , TRUNC(DBMS_RANDOM.VALUE(2, 70)) AS Y1
              , TRUNC(DBMS_RANDOM.VALUE(20, 75)) AS Z1
              , LEVEL AS IDX
              , TRUNC((LEVEL-1) / 20) + 1 AS SERIES_IDX
           FROM DUAL
        CONNECT BY LEVEL <= 80
        )
</pre>
<!-- SQL 샘플 [워드 클라우드] -->
<pre class="sample_sql hide" mapping="JQCLOUD_BASIC">
SELECT SERIES_NAME
     , SERIES_DATA
  FROM (
        SELECT 'JAVA' AS SERIES_NAME
             , 12 AS SERIES_DATA
          FROM DUAL
         UNION ALL
        SELECT 'HTML' AS SERIES_NAME
             , 25 AS SERIES_DATA
          FROM DUAL
         UNION ALL
        SELECT 'JAVASCRIPT' AS SERIES_NAME
             , 5 AS SERIES_DATA
          FROM DUAL
         UNION ALL
        SELECT 'CSS' AS SERIES_NAME
             , 132 AS SERIES_DATA
          FROM DUAL
         UNION ALL
        SELECT 'GO' AS SERIES_NAME
             , 23 AS SERIES_DATA
          FROM DUAL
       )
</pre>
</body>
</html>