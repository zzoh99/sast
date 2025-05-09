<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>차트 관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<link href="${ctx}/common/plugin/EIS/css/chart.css?ver=<%= System.currentTimeMillis()%>" rel="stylesheet" />
<script src="${ctx}/common/plugin/EIS/js/chart.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript" charset="UTF-8"></script>

<!-- Custom Theme Style -->
<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
<link href="${ ctx }/common/css/cmpEmp/isu_dashboard.css" rel="stylesheet">	

<style type="text/css">
	#area_chartWrap {
		height: calc(100% - 127px);
		background-color: #f6f6f6;
		border-radius: 8px;
		overflow-x: hidden;
		overflow-y: auto;
		scrollbar-width: thin;
		justify-content: flex-end;
	}
	#area_chartWrap.sidebarOff {
		justify-content: center;
	}
	#area_chartList {
		margin-top: 20px;
	}
	.stats-item {
		margin-bottom: 25px;
		margin-left: 25px;
	}
	.stats-item.dummy {
		background-color: #f6f6f6;
	}
	
	
	-- 프로필카드 시작
	.sheet_search, .cbp_tmtimeline * {
		box-sizing:initial;
	}
	
	#detailList {
		background-color:#fdfdfd;
		padding:10px;
		border:1px solid #ebeef3;
		overflow-x:hidden;
		overflow-y:auto;
		min-width:240px;
		width : calc(50% - 2px);
		display:inline-block;
	}
	
	.tile-stats.card-profile {
		padding:15px;
	}
	
	.tile-stats.card-profile.choose {
		background-color:#efefef;
	}
	
	.tile-stats.card-profile .profile_info {
		width:calc(100% - 81px);
	}
	
	.tile-stats.card-profile .profile_info .profile_desc {
		width:100%;
	}
	
	.tile-stats.card-profile .profile_info .profile_desc li.full {
		width:100%;
	}
	
	.tile-stats.card-profile .profile_img img {
		width:66px;
		height:99px;
	}
	
	.member_search_wrap {
		position: relative;
		height:50px !important;
		font-size:12px;
		z-index:30;
		letter-spacing: 0px !important;
		text-align:center;
	}
	.member_search_wrap h1>a {
		display: block;
		position:relative;
		top: 0px;
		cursor: pointer;
	}
	.member_search_wrap .member_search {
		float: left;
		position: relative;
		margin: 0px 0px 0px 0px;
		width:97%;
	}
	.member_search_wrap .member_search input {
		position:relative;
		box-sizing: border-box;
		border: 1px solid #e3e7ea;
		border-radius: 50px;
		width: 100%;
		padding: 8px 15px;
		color: #95999c;
		font-size: 12px;
		outline: none;
		z-index:31;
	}
	.member_search_wrap .member_search a { display: inline-block; position:relative;  z-index:32; }
	.member_search_wrap .pointer { cursor:pointer;}
</style>
<script type="text/javascript">
	var pGubun = "";
	var presetCdList = null;
	var g_spaceSize = 25, g_columnCnt = 9, g_defaultSize = 200;
	var g_chartListEle, statsData, showPreloader = false;
	var cur_chart = {};

	$(function() {
	
		initGrid();
		
		// 위젯 기본 사이즈 설정
		setWidgetDefaultSize();
		
		g_chartListEle = $("#area_chartList");
		g_chartListEle.css({
			"width" : "850px"
		});

		$("#area_searchBox").attr("data-height", $("#area_searchBox").outerHeight());
		$("#area_sideBar").css({
			"width" : ($("#area_chartWrap").outerWidth() - $("#area_chartList").outerWidth() - g_spaceSize) + "px",
			"height" : ($("#area_chartWrap").outerHeight() - 40) + "px"
		});
		
		$("#searchYmd").mask("1111-11-11");
		$("#searchYmd").datepicker2({
			ymdonly: true,
			onReturn: function(){
				doAction1("Search");
			}
		});
		
		$("#searchPresetId").on("change", function(e){
			doAction1("Search");
		});
		//사이드바 토글 off
		toggleSideBar();
	
		// 통계구성 콤보박스 초기화
		initPreset();
		
		doAction1("Search");
		
		doAction2("G1020");
		
	});
	
	// 위젯 기본 사이즈 설정
	function setWidgetDefaultSize() {
		var scrWidth = screen.availWidth;
		g_defaultSize = 200;
		if( scrWidth < 1440 ) {
			g_defaultSize = 160;
		} else if( scrWidth < 1024 ) {
			g_defaultSize = 130;
		}
		g_defaultSize = 70;
	}

	
	// 통계구성 콤보박스 초기화
	function initPreset() {
			$("#searchPresetId").html("<option value='직무현황'  presetTypeCd='G' >[그룹] 직무현황</option>");
		
	}

	//sheet2 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if( $("#searchPresetId").val() != "" ) {
				$("#searchPresetTypeCd").val( $("#searchPresetId option:selected").attr("presetTypeCd") );
				
				// show preloader
				progressBar(true);
				showPreloader = true;
				
				// 데이터 조회
				statsData = ajaxCall("${ctx}/StatsPresetMng.do?cmd=getStatsPresetMngUseItemDtlData", $("#sheetForm").serialize(), false);
				
				// 통계 초기화
				initChartDashboard();
				
			} else {
				alert("통계구성을 선택해주십시오.");
			}
			break;
		case "EmpPresetEdit":
			// 데이터 필수 정의 컬럼 팝업
			if(!isPopup()) {return;}
			var url = "/StatsPresetMng.do?cmd=viewStatsPresetMngEmpPresetEditLayer&authPg=${authPg}";
			var w = screen.availWidth - 40;
			var h = screen.availHeight;
			var title = "개인 통계구성 관리";
			var layerModal = new window.top.document.LayerModal({
				id : 'statsPresetMngEmpPresetEditLayer', 
				url : url, 
				width : w,
				height : h,
				title : title,
				trigger: [
					{name: 'statsPresetMngEmpPresetEditLayerTrigger', callback: function() { initPreset(); }}
				]
			});
			layerModal.show();
			break;
		}
	}
	
	function initGrid() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:100,MergeSheet:msAll};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"사업군",			Type:"Text"    ,	Hidden:0,	Width:80,	  ColMerge:1,      Align:"Center",		SaveName:"buNm"},
			{Header:"회사명",			Type:"Text"    ,	Hidden:0,	Width:80,	  ColMerge:1,	   Align:"Center",		SaveName:"enterNm"},
			{Header:"부서",			Type:"Text"    ,	Hidden:0,	Width:120,	  ColMerge:1,	   Align:"Center",		SaveName:"orgNm"},
			{Header:"인원",			Type:"Text"    ,	Hidden:0,	Width:80,	  ColMerge:0,	   Align:"Center",		SaveName:"jobCnt"},
			{Header:"부서코드",		Type:"Text"    ,	Hidden:1,	Width:80,	  ColMerge:0,	   Align:"Center",		SaveName:"orgCd"},
			{Header:"직무코드",		Type:"Text"    ,	Hidden:1,	Width:80,	  ColMerge:0,	   Align:"Center",		SaveName:"jobCd"},
			{Header:"회사코드",		Type:"Text"    ,	Hidden:1,	Width:80,	  ColMerge:0,	   Align:"Center",		SaveName:"enterCd"}
		];

		IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(0);

		$(window).smartresize(sheetResize); 
		sheetInit();
		
	}
	
	function doAction2(sAction) {
		sheet2.DoSearch( "${ctx}/JobStateChart.do?cmd=getJobList", "&jobCd="+sAction );
	}

	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg){
		try {
		    if (Msg != "") {
				alert(Msg);
			}
		    sheet2.SelectCell(1, "orgNm");
			 sheetResize();
		} catch (ex) {
				alert("OnSearchEnd Event Error : " + ex);
	    }
	}
	
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		//행을 클릭했을 때 다른 페이지로 이동하도록 처리
		var colName = sheet2.ColSaveName(NewCol);
        var args    = new Array();
		var selEnterCd = sheet2.GetCellValue(NewRow, "enterCd");
        var selOrgCd   = sheet2.GetCellValue(NewRow, "orgCd");
        var seljobCd   = sheet2.GetCellValue(NewRow, "jobCd");
        $("#enterCd").val(selEnterCd);
        $("#orgCd").val(selOrgCd);
        $("#jobCd").val(seljobCd);

        if((colName == "orgNm" || colName == "jobCnt") && NewRow > 0) {
// 			if(!isPopup()) {return;}

        	var data = ajaxCall("${ctx}/JobStateChart.do?cmd=getJobEmpList", $("#sheetForm").serialize(), false);
        	
        	if(data != null) {
        		createProfile(data);
        		
        	}
//             showRd(Row);
        }        
	}
	
    function createProfile(data) {
    	
    	var ele = "";
    	$("#area_profile").html("");
    	data.DATA.forEach(function(item, idx, arr){
    		
    		ele = "<div id='detailList' class='list_box'> "
            + "  <div class='tile-stats card-profile' style='padding:0px'>"
            + "    <div style='text-align: right; padding:0px'>"
            + "      <a href='javascript:showRd(" + "\""+item.enterCd+ "\", \""+item.sabun+"\");' class='btn' style='border:1px solid #d0d0d0' >Profile Card</a>"
            + "    </div>"
            + "    <div class='profile_img'>"
            + " 	 <img src='${ctx}/EmpPhotoOut.do?searchKeyword=" +item.sabun+ "'  id='photo' alt='Avatar' title='Change the avatar'>"
            + "    </div>"
            + "    <div class='profile_info'>"
            + "      <p class='name' id='tdName'>"
            + "        성명 : " + item.name
            + "      </p>"
            + "      <ul class='profile_desc' style='display: grid'>"
            + "        <li id='tdSabun' >사번 : " +item.sabun+ "</li>"
            + "        <li id='tdJikweeNm'>직위 : " +item.jikweeNm+ "</li>"
            + "        <li id='tdJikchakNm'>직책 : " +item.jikchakNm+ " </li>"
            + "        <li id='tdOrgNm' class='full'>소속 : " + item.enterNm + " / " +item.orgNm+ " </li>"
            + "      </ul>"
            + "    </div>"
            + "  </div>"
		    + "</div>";
			
			$("#area_profile").append(ele);
    	});
    	
    	
    }
    
    function showRd(enterCd, sabun) {
    		var imgPath = " " ;
    		var enterCdSabun = "";
    		var searchSabun = "";
    		enterCdSabun += ",('" + enterCd +"','" + sabun + "')";
    		searchSabun  += "," + sabun;

    		var rdParam ="";
    		
    		rdParam += "["+ enterCdSabun +"] "; //회사코드, 사번
    		rdParam += "[${baseURL}] ";//이미지위치---3
    		rdParam += "[Y] "; //개인정보 마스킹
    		rdParam += "[${ssnEnterCd}] ";
    		rdParam += "[ '${ssnSabun}' ] ";//rdParam  += "["+searchSabun+"]"; // 사번list->세션사번으로 변경(2016.04.14)
    		rdParam += "[${ssnLocaleCd}] ";	// 10.다국어코드
    		rdParam += "['"+ searchSabun +"'] "; //사번
    		/*
    		const data = {
    			rdMrd : '/cpn/payReport/TaxClearanceCertificate.mrd'
    			, parameterType : 'rp'//rp 또는 rv
    			, parameters : parameters
    		};
    		window.top.showRdLayer(data);*/
            const data = {
                    parameters : rdParam
            };
            window.top.showRdLayer('/JobStateChart.do?cmd=getEncryptRd', data);
    	
    }
</script>
<!-- [START] Display Charts -->
<script type="text/javascript">
	// 통계 초기화
	function initChartDashboard() {
		// 스크롤 상단으로 이동
		g_chartListEle.parent().scrollTop(0);
		// 차트 출력 영역 초기화
		g_chartListEle.empty();
		$("#sideBarList").empty();
		cur_chart = {};
		
		if( statsData != null && statsData.LIST != undefined && statsData.LIST != null && statsData.LIST.length > 0 ) {
			// 1. 차트 박스 레이아웃 추가
			statsData.LIST.forEach(function(item, idx, arr){
				// 차트 레이아웃 추가
				if( item.useYn == "Y" ) {
					addChartLayout(item, idx);
				}
			});
			
			// 2. 차트 출력
			var dataList;
			statsData.LIST.forEach(function(item, idx, arr){
				if( item.useYn == "Y" && item.dummyYn == "N" ) {
					dataList = null;
					if( statsData.DATA && statsData.DATA != null && statsData.DATA[item.statsCd] && statsData.DATA[item.statsCd] != null ) {
						dataList = statsData.DATA[item.statsCd];
					}
					
					// 차트 데이터를 개별로 조회해야 하는 상황이며 데이터 조회 SQL이 존재하는 통계인 경우
					if( statsData.DATA.ajaxCallFlag == "Y" && item.existsSql == "Y" ) {
						drawChartBeforeGetData(item);
					} else {
						// 차트 출력
						drawChart(item, dataList);
					}
				}
				
				// 화면 출력 스위치 목록에 추가
				addViewSwitchList(item);
				
				// destroy preloader
				if( idx > 3 && showPreloader ) {
					progressBar(false);
					showPreloader = false;
				}
			});
		}
		
		// view switch event
		$("#sideBarList").find("li").on("click", function(e){
			var chartEle = $("#area_chartList .stats-item[id='" + $(this).attr("widget") + "']");
			if( !$(this).hasClass("hidden") ) {
				// 스크롤 이동
				$("#area_chartWrap").animate({
					"scrollTop" : chartEle.position().top + "px"
				},{
					complete: function(){
						// 차트 위젯인 경우 일정시간동안 클래스 추가 후 제거하여 선택한 위젯 위치 확인 시킴
						if( !chartEle.hasClass("dummy") ) {
							// 클래스 추가
							chartEle.addClass("focus");
							setTimeout(function(){
								// 클래스 제거
								chartEle.removeClass("focus");
							}, 1500);
						}
					}
				});
			}
		});
		$("#sideBarList").find(".check").on("click", function(e){
			window.event.stopPropagation();
			var chartEle = $("#area_chartList .stats-item[id='" + $(this).attr("widget") + "']");
			var parentEle = $(this).parent();
			var fadeTime = (chartEle.hasClass("dummy")) ? 100 : 450;
			if( parentEle.hasClass("hidden") ) {
				chartEle.removeClass("hidden").fadeIn(fadeTime);
				parentEle.removeClass("hidden");
				$(this).removeClass("fa-toggle-off").addClass("fa-toggle-on");
				// 스크롤 이동
				$("#sideBarList").find("li[widget='" + $(this).attr("widget") + "']").trigger("click");
			} else {
				chartEle.addClass("hidden").fadeOut(fadeTime);
				parentEle.addClass("hidden");
				$(this).removeClass("fa-toggle-on").addClass("fa-toggle-off");
			}
		});
		
		// destroy preloader
		if( showPreloader ) {
			setTimeout(function() {
				progressBar(false);
				showPreloader = false;
			}, 250);
		}
	}
	
	// add chart layout
	function addChartLayout(item, statsIdx) {
		var top, left, width, height;
		var widgetId, dummyYn, statsCd, statsNm, chartPositionX, chartPositionY, chartSizeW, chartSizeH;
		widgetId = item.widgetId;
		dummyYn = item.dummyYn;
		statsCd = item.statsCd;
		statsNm = item.statsNm;
		chartPositionX = parseInt(item.chartPositionX);
		chartPositionY = parseInt(item.chartPositionY);
		chartSizeW     = parseInt(item.chartSizeW);
		chartSizeH     = parseInt(item.chartSizeH);
		
		top    = (chartPositionY == 0) ? 0 : (g_defaultSize * chartPositionY) + ((chartPositionY - 1) * g_spaceSize);
		left   = (chartPositionX == 0) ? 0 : (g_defaultSize * chartPositionX) + ((chartPositionX - 1) * g_spaceSize);
// 		width  = (g_defaultSize * chartSizeW) + ((chartSizeW - 1) * g_spaceSize);
		width  = 850;
		height = (g_defaultSize * chartSizeH) + ((chartSizeH - 1) * g_spaceSize);
		
		if( chartPositionY > 0 ) top += g_spaceSize;
		if( chartPositionX > 0 ) left += g_spaceSize;
		
		var itemEle = $("<div/>", {
			"class"    : "stats-item",
			"id"       : widgetId,
			"statsCd"  : statsCd,
			"dummyYn"  : dummyYn,
			"data-w"   : chartSizeW,
			"data-h"   : chartSizeH,
		});
		itemEle.attr({
			"pos-top"  : top,
			"pos-left" : left,
		}).css({
			"width"    : width + "px",
			"height"   : height + "px",
		});
		itemEle.append($("<div/>", {
			"class"    : "chart",
			"id"       : "chart_"+ widgetId
		}));
		
		// 더미 위젯이 아닌 경우
		if( dummyYn == "N" ) {
			itemEle.find(".chart").append($("<img />", {
				"src"   : "${ctx}/common/images/common/loading_s.gif",
				"style" : "display:flex; align-self: center; height: 32px;"
			}));
		} else {
			itemEle.addClass("dummy");
		}
		
		g_chartListEle.append(itemEle);
	}
	
	// 차트 화면 출력 전 데이터 조회 후 차트 출력 처리
	function drawChartBeforeGetData(statsItem) {
		$.ajax({
			url: "${ctx}/StatsMng.do?cmd=getStatsMngChartDataMap",
			type: "post",
			dataType: "json",
			async: true,
			data: "searchStatsCd=" + statsItem.statsCd + "&searchYmd=" + $("#searchYmd").val(),
			success: function(data) {
				//console.log('[drawChartBeforeGetData]', 'statsItem', statsItem, 'data', data);
				if( data && data != null ) {
					var dataList = data.LIST;
					// 차트 화면 출력
					drawChart(statsItem, dataList);
				}
			},
			error: function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});
	}
	
	// 차트 화면 출력
	function drawChart(statsItem, dataList) {
		var chartOpt = {}, dataExists = true, rtnChart;
		
		// set chart option
		if( statsItem.chartOpt && statsItem.chartOpt != "" ) {
			chartOpt = eval("(" + statsItem.chartOpt + ")");
		}
		if( chartOpt.chart == undefined ) {
			chartOpt.chart = {};
		}
		
		// 데이터가 존재하지 않는 경우
		if( dataList == undefined || dataList == null ) {
			dataExists = false;
			if( (statsItem.pluginObjNm.indexOf("APEX") > -1)
					&& (chartOpt.series != undefined && chartOpt.series != null) ) {
				dataExists = true;
			}
		}
		
		if( dataExists ) {
			// set chart size
			var chartSizeW = parseInt(statsItem.chartSizeW), chartSizeH = parseInt(statsItem.chartSizeH);
// 			chartOpt.chart.width  = (g_defaultSize * chartSizeW) + ((chartSizeW - 1) * g_spaceSize) - g_spaceSize;
			chartOpt.chart.width  = 850;
			chartOpt.chart.height = (g_defaultSize * chartSizeH) + ((chartSizeH - 1) * g_spaceSize) - g_spaceSize;
			if( parseInt(statsItem.chartSizeH) == 1 ) {
				chartOpt.chart.height -= (g_spaceSize/2);
			}
			//console.log('[drawChart] chartOpt', chartOpt);
			
			// put param
			chartOpt.param = $("#sheetForm").serializeObject();
			
			// 차트 출력 영역 초기화
			$("#area_chartList .stats-item[id='" + statsItem.statsCd + "'] .chart").empty();
			// render chart
			rtnChart = HR_CHART[statsItem.pluginObjNm].render("#area_chartList .stats-item[id='" + statsItem.statsCd + "'] .chart", chartOpt, dataList);
			
			cur_chart[statsItem.statsCd] = {
				stats : statsItem,
				chart : rtnChart,
				options : chartOpt,
				data : dataList
			};
			//console.log('[drawChart] cur_chart', cur_chart);
		} else {
			$("#area_chartList .stats-item[id='" + statsItem.statsCd + "'] .chart").append(
				$("<ul/>", {
					"class" : "empty"
				}).append(
					$("<li/>", {
						"class" : "f_point f_s14 mar10"
					}).html("[ " + statsItem.statsNm + " ]")
				)
			);
			var msg = "";
			if( !dataExists ) {
				msg = "출력 데이터가 존재하지 않습니다.";
			}
			$("#area_chartList .stats-item[id='" + statsItem.statsCd + "'] .chart .empty").append(
				$("<li/>", {
					"class" : "reason"
				}).html(msg)
			);
		}
	}
	
	// 차트 리사이즈
	function resizeChart() {
		var top, left, width, height, chartWidth, chartHeight;
		var itemEle, widgetId, dummyYn, statsCd, chartPositionX, chartPositionY, chartSizeW, chartSizeH;
		
		if( statsData != null && statsData.LIST != undefined && statsData.LIST != null && statsData.LIST.length > 0 ) {
			statsData.LIST.forEach(function(item, idx, arr){
				
				if( item.useYn == "Y" ) {
					widgetId = item.widgetId;
					dummyYn = item.dummyYn;
					statsCd = item.statsCd;
					chartPositionX = parseInt(item.chartPositionX);
					chartPositionY = parseInt(item.chartPositionY);
					chartSizeW     = parseInt(item.chartSizeW);
					chartSizeH     = parseInt(item.chartSizeH);
					
					top    = (chartPositionY == 0) ? 0 : (g_defaultSize * chartPositionY) + ((chartPositionY - 1) * g_spaceSize);
					left   = (chartPositionX == 0) ? 0 : (g_defaultSize * chartPositionX) + ((chartPositionX - 1) * g_spaceSize);
// 					width  = (g_defaultSize * chartSizeW) + ((chartSizeW - 1) * g_spaceSize);
					width  = 850;
					height = (g_defaultSize * chartSizeH) + ((chartSizeH - 1) * g_spaceSize);
					
					if( chartPositionY > 0 ) top += g_spaceSize;
					if( chartPositionX > 0 ) left += g_spaceSize;
					
					// 위젯 사이즈 변경
					itemEle = $(".stats-item[id='" + widgetId + "']");
					itemEle.attr({
						"pos-top"  : top,
						"pos-left" : left,
					}).css({
						"width"    : width + "px",
						"height"   : height + "px"
					});
					
					// 더미위젯이 아니며 데이터가 존재하는 경우
					if( item.dummyYn == "N" ) {
						chartWidth = width - g_spaceSize;
						chartHeight = height - g_spaceSize;
						if( chartSizeH == 1 ) chartHeight -= (g_spaceSize/2);
						
						if( itemEle.hasClass("hidden") ) {
							itemEle.css({
								"visible" : "hidden",
								"display" : "flex"
							});
						}
						
						// chart update
						if(cur_chart[statsCd].chart.chart.updateOptions) {
							cur_chart[statsCd].chart.chart.updateOptions({
								chart: {
									width: chartWidth,
									height: chartHeight
								}
							});
						} else {
							// JQCloud 라이브러리인 경우
							if( itemEle.find(".jqcloud").length > 0 ) {
								// update options
								cur_chart[statsCd].options = $.extend(true, cur_chart[statsCd].options, {
									chart: {
										width: chartWidth,
										height: chartHeight
									}
								});
								HR_CHART[cur_chart[statsCd].stats.pluginObjNm].render("#area_chartList .stats-item[id='" + statsCd + "'] .chart", cur_chart[statsCd].options, cur_chart[statsCd].data);
							}
						}
						
						if( itemEle.hasClass("hidden") ) {
							itemEle.css({
								"visible" : "",
								"display" : "none"
							});
						}
					}
				}
			});
		}
	}
	
	// 화면 출력 스위치 목록에 추가
	function addViewSwitchList(item) {
		var liEle = $("<li/>", {
			"widget" : item.widgetId
		});
		// 더미 위젯이 아닌 경우
		if( item.dummyYn == "N" ) {
			liEle.append(item.statsNm);
		} else {
			liEle.append("- Blank -");
		}
		liEle.append($("<span/>", {
			"class" : "check fa fa-toggle-on",
			"widget" : item.widgetId
		}));
		$("#sideBarList").append(liEle);
	}
	
	// 검색박스 출력 토글
	function toggleSearchBox() {
		var searchBoxEle = $("#area_searchBox"), searchBoxHeight = searchBoxEle.data("height");
		var sizeBarEle = $("#area_sideBar");
		var iconEle = $(".icon", "#btn_searchBox");
		
		if( iconEle.hasClass("fa-toggle-on") ) {
			iconEle.removeClass("fa-toggle-on").addClass("fa-toggle-off");
			searchBoxEle.fadeOut(function(){
				$("#area_chartWrap").css({
					"height" : "calc(100% - " + (127 - searchBoxHeight) + "px)"
				});
				sizeBarEle.css({
					"top" : (147 - searchBoxHeight) + "px",
					"height" : (sizeBarEle.outerHeight() + searchBoxHeight) + "px"
				});
			});
		} else {
			iconEle.removeClass("fa-toggle-off").addClass("fa-toggle-on");
			sizeBarEle.css({
				"top" : "147px",
				"height" : (sizeBarEle.outerHeight() - searchBoxHeight) + "px"
			});
			searchBoxEle.fadeIn(function(){
				$("#area_chartWrap").css({
					"height" : "calc(100% - 127px)"
				});
			});
		}
	}
	
	// 사이드바 출력 토글
	function toggleSideBar() {
		var sizeBarEle = $("#area_sideBar");
		var iconEle = $(".icon", "#btn_sideBar");
		
		if( iconEle.hasClass("fa-toggle-on") ) {
			// 차트 위젯 기본 사이즈 조정
			g_defaultSize = g_defaultSize + (sizeBarEle.outerWidth() / g_columnCnt);
			
			iconEle.removeClass("fa-toggle-on").addClass("fa-toggle-off");
			
			// 사이드바 화면 미출력
			sizeBarEle.hide();
			g_chartListEle.animate({
				"width" : ((g_defaultSize * g_columnCnt) + ((g_columnCnt + 1) * g_spaceSize)) + "px"
			}, {
				easing: "linear",
				complete: function(){
					// 데시보드 영역 정렬 조건 변경
					$("#area_chartWrap").addClass("sidebarOff");
					// 차트 리사이즈
					resizeChart();
				}
			});
		} else {
			// 차트 위젯 기본 사이즈 조정
			setWidgetDefaultSize();
			
			iconEle.removeClass("fa-toggle-off").addClass("fa-toggle-on");
			// 데시보드 영역 정렬 조건 변경
			$("#area_chartWrap").removeClass("sidebarOff");
			
			g_chartListEle.animate({
				"width" : ((g_defaultSize * g_columnCnt) + ((g_columnCnt + 1) * g_spaceSize)) + "px"
			}, {
				easing: "linear",
				duration: 100,
				complete: function() {
					// 사이드바 화면 출력
					sizeBarEle.show();
					// 차트 리사이즈
					resizeChart();
				}
			});
		}
	}
</script>
<!-- [END] Display Charts -->
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input type="hidden" id="searchPresetTypeCd" name="searchPresetTypeCd" value="" />
		<input type="hidden" id="enterCd" name="enterCd" value="" />
		<input type="hidden" id="orgCd" name="orgCd" value="" />
		<input type="hidden" id="jobCd" name="jobCd" value="" />
		<div id="area_searchBox" class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>기준일자  </th>
						<td>
							<input class="text w70 center" type="text" id="searchYmd" name="searchYmd" size="10" maxlength="9" value="${ curSysYyyyMMddHyphen }"/>
						</td>
						<th>통계구성</th>
						<td>
							<select id="searchPresetId" name="searchPresetId" class="select"></select>
						</td>
						<td>
							<a href="javascript:doAction1('EmpPresetEdit');" class="button">개인 통계구성 관리</a>
							<btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">통계 조회</li>
				<li class="btn">
					<a href="javascript:toggleSearchBox();" id="btn_searchBox" class="mar5">검색박스 <span class="icon fa fa-toggle-on f_s20"></span></a>
					<a href="javascript:toggleSideBar();" id="btn_sideBar">사이드바 <span class="icon fa fa-toggle-on f_s20"></span></a>
				</li>
			</ul>
		</div>
	</div>
	
	
	<div id="area_chartWrap" style="text-align: left;">
		<div id="area_chartList"></div>
		<div id="area_sideBar">
			<ul id="sideBarList"></ul>
		</div>
		<div id="area_grid" style="width:750px; margin-top: 21px; margin-right: 25px; margin-bottom: 25px; margin-left: 25px">
			<script type="text/javascript">createIBSheet("sheet2", "700px", "300px", "${ssnLocaleCd}"); </script>
			<div id="area_profile" style="margin-top: 10px">
				
			</div>
		</div>
	</div>
</div>
</body>
</html>
