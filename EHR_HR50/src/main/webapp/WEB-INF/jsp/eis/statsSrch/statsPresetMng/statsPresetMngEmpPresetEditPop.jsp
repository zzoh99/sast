<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>개인 통계구성 관리</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<link href="${ctx}/common/plugin/EIS/css/chart.css?ver=<%= System.currentTimeMillis()%>" rel="stylesheet" />
<script src="${ctx}/common/plugin/EIS/js/chart.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript" charset="UTF-8"></script>
<!-- Gridstack.js -->
<link rel="stylesheet" href="${ctx}/common/plugin/EIS/gridstack/css/gridstack.css" />
<link rel="stylesheet" href="${ctx}/common/plugin/EIS/gridstack/css/gridstack-extra.css" />
<link rel="stylesheet" href="${ctx}/common/plugin/EIS/css/gridstack.css" />
<script src="${ctx}/common/plugin/EIS/gridstack/js/gridstack-h5.js" type="text/javascript"></script>
<!-- Gridstack.js -->
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
	.slide_breadcrumb {
		height: 30px;
		text-align: center;
	}
	.slide_breadcrumb a {
		display: inline-block;
		width: 10px;
		height: 10px;
		border-radius: 5px;
		background-color: #ababab;
		cursor: pointer;
	}
	.slide_breadcrumb a.active {
		width: 48px;
		background-color: #666;
		background-color: var(--txt_color_base, #666);
	}
	.slide {
		position: relative;
		min-width: 100%;
		width: 100%;
		max-width: 100%;
		height: calc(100vh - 120px);
		max-height: calc(100vh - 120px);
		display: flex;
		justify-content: start;
		overflow: hidden;
	}
	.slide .scene {
		position: absolute;
		top: 0px;
		min-width: 100%;
		width: 100%;
		max-width: 100%;
		height: calc(100vh - 120px);
		max-height: calc(100vh - 120px);
		background-color: #fff;
	}
	.slide .scene.active {
	}
	.slide .scene .w100p {
		width: 100% !important;
	}
	
	#area_layout_set {
		min-height: calc(100vh - 162px);
		max-height: calc(100vh - 162px);
		margin-top: 0px;
	}
	
	.stats-item.dummy {
		background-color: #f6f6f6;
		box-shadow: none;
	}
	
	#area_chartWrap {
		height: calc(100vh - 156px);
		background-color: #f6f6f6;
		border-radius: 8px;
		overflow-x: hidden;
		overflow-y: auto;
		scrollbar-width: thin;
	}
	
	#area_chartWrap #area_chartList {
		margin-top: 30px;
	}
</style>
<!-- Gridstack.js -->
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	// 화면 슬라이드 관련
	var g_slideEle = null;
	// gridstack 관련
	var grid = null, gridMaxColumn = 6, gridSerializedData = [];
	var dummyTitle = "- Blank -";
	// chart 출력 관련
	var g_spaceSize = 30, g_columnCnt = 6, g_defaultSize = 220;
	var g_chartListEle, statsChartData, showPreloader = false;
	
	// GridStack.js 라이브러리가 IE에서는 정상적으로 동작하지 않기에 IE에서 접근 시 윈도우 종료 시킴.
	if (window.navigator.userAgent.indexOf('MSIE') > -1 || window.navigator.userAgent.indexOf('Trident') > -1) {
		alert("Internet Explorer 웹브라우저에서는 지원하지 않는 기능입니다.");
		p.self.close();
	}
	
	$(function() {
		// 닫기 버튼 이벤트
		$(".close").click(function(){
			p.self.close(); 
		});
		
		var arg = p.window.dialogArguments;
		
		// 단계별 화면 전환 관련 설정
		g_slideEle = $(".slide");
		g_slideEle.find(".scene").each(function(idx, item){
			$(this).css({
				"left" : ((idx > 0) ? $(this).width() : 0 ) + "px"
			})
		});
		
		
		// init grid
		grid = GridStack.init({
			minRow: 5, // don't let it collapse when empty
			column: gridMaxColumn,
			cellHeight: 'auto',
			cellHeightThrottle: 100,
			marginTop: '20px',
			marginLeft: '20px',
			resizable: {
				handles: 'all'
			},
			acceptWidgets: true,
			// class that can be dragged from outside
			dragIn: '.dummyWidget',
			// clone or can be your function
			dragInOptions: {
				revert: 'invalid',
				scroll: false,
				appendTo: 'body',
				helper: 'clone'
			}
		});
		grid.on("added removed change resize", function(e, items) {
			var str = '';
			
			if( e.type == "added" ) {
				//console.log('[GridStack] event', e.type, 'items', items, 'gridSerializedData', gridSerializedData);
				items.forEach(function(item, idx, arr) {
					var addEle = $(item.el);
					// 여백 위젯인 경우
					if( addEle.hasClass("dummyWidget") ) {
						addDummyWidget(addEle);
					}
				});
			}
			
			// 빈공간 제거 및 위치 재정렬
			if( $("#widgetReLayoutFlag").is(":checked") ) {
				grid.compact();
			}
			// 저장
			gridSerializedData = grid.save(true, true).children;
		});
		
		// 자동 정렬/재비치 체크박스 change 이벤트
		$("#widgetReLayoutFlag").on("change", function(e){
			if($(this).is(":checked")) {
				grid.compact();
			}
		});
		
		// Set Chart Dashboard
		var scrWidth = screen.availWidth;
		if( scrWidth < 1440 ) {
			g_defaultSize = 180;
		} else if( scrWidth < 1024 ) {
			g_defaultSize = 130;
		}
		g_chartListEle = $("#area_chartList");
		g_chartListEle.css({
			"width" : ((g_defaultSize * g_columnCnt) + ((g_columnCnt + 1) * g_spaceSize)) + "px"
		});
		// Set Chart Dashboard
		
		// 시트 초기화
		initSheet1();
		initSheet2();
		initSheet3();
		
		// 통계구성 목록 조회
		doAction1("Search");
		
	});
	
	// view scene
	function viewScene(flag) {
		var isContinue = true;
		var curActiveSceneEle = g_slideEle.find(".scene.active"), curActiveScene = curActiveSceneEle.attr("id"), left = curActiveSceneEle.width();
		
		// 작업대상 통계구성이 선택되지 않은 경우
		if($("#searchPresetId").val() == "" && sheet1.RowCount() > 0 ) {
			// 작업 통계구성 정보 셋팅
			setWorkPresetInfo(sheet1.GetSelectRow());
		}
		
		// 레이아웃 및 미리보기 화면 전환인 상황에 작업대상 통계구성이 선택되지 않은 경우
		if( (flag == "layoutEdit" || flag == "preview") && ($("#searchPresetId").val() == "") ) {
			alert("작업 대상 통계 구성을 선택해주십시오.");
			isContinue = false;
		}
		
		if( isContinue ) {
			if( !$(".editPresetInfo").hasClass("hide") ) $(".editPresetInfo").addClass("hide");
			
			if( curActiveScene == "layoutEdit" ) {
				if( flag == "presetEdit" ) {
					left = 0 - left;
				}
			} else if( curActiveScene == "preview" ) {
				left = 0 - left;
			}
			
			g_slideEle.find(".scene").css({
				"left" : left + "px"
			});
			
			// 화면 전환 실행
			g_slideEle.find("#" + flag).animate({
				left: "0px"
			}, {
				duration: 400,
				complete: function() {
					g_slideEle.find(".scene.active").removeClass("active");
					$(".slide_breadcrumb a").removeClass("active");
					g_slideEle.find("#" + flag).addClass("active");
					$(".slide_breadcrumb a[slide='" + flag + "']").addClass("active");
					
					// delay
					setTimeout(function(){
						if( flag == "presetEdit" ) {
							$("#searchPresetId").val("");
						}
						if( flag == "layoutEdit" ) {
							if( $(".editPresetInfo").hasClass("hide") ) $(".editPresetInfo").removeClass("hide");
							doAction3("Search");
						}
						if( flag == "preview" ) {
							if( $(".editPresetInfo").hasClass("hide") ) $(".editPresetInfo").removeClass("hide");
							// show preloader
							progressBar(true);
							showPreloader = true;
							// 데이터 조회
							statsChartData = ajaxCall("${ctx}/StatsPresetMng.do?cmd=getStatsPresetMngUseItemDtlData", $("#sheetForm").serialize(), false);
							// 통계 초기화
							initChartDashboard();
						}
					}, 100);
				}
			});
		}
	}
	
	// add dummy widge
	function addDummyWidget(ele) {
		var gid = "__DUMMY_" + Math.floor(+ new Date());
		var widgetEle = $("#template_widget").clone();
		widgetEle.find(".btn_remove_widget").attr("gid", gid);
		widgetEle.find(".statsNm").html(dummyTitle);
		
		if( ele == undefined ) {
			var positionX = 0, positionY = 0, lastWidget;
			if( gridSerializedData.length > 0 ) {
				lastWidget = gridSerializedData[gridSerializedData.length - 1];
				positionY = (lastWidget.y + lastWidget.h) + 1
			}
			
			// add
			grid.addWidget({
				x       : positionX,
				y       : positionY,
				w       : 1,
				h       : 1,
				maxW    : gridMaxColumn,
				maxH    : gridMaxColumn,
				id      : gid,
				content : widgetEle.html()
			});
			
			var addedWidgetEle = $(".grid-stack-item[gs-id='" + gid + "']", ".grid-stack");
			addedWidgetEle.addClass("dummy");
			// 스크롤 이동
			$("#area_layout_set").scrollTop($(".grid-stack").outerHeight());
		} else {
			ele.find(".grid-stack-item-content").html(widgetEle.html());
			ele.attr({
				"gs-id"    : gid,
				"gs-max-w" : gridMaxColumn,
				"gs-max-h" : gridMaxColumn
			});
			ele.addClass("dummy").removeClass("dummyWidget");
		}
	}
	
	// remove widget
	function removeWidget(btnEle) {
		var gid, widgetNode, Row, statsCd, isContinues = true;
		if( btnEle != undefined) {
			gid = $(btnEle).attr("gid"), widgetNode = $(".grid-stack-item[gs-id='" + gid + "']", ".grid-stack");
			
			if( !widgetNode.hasClass("dummy") ) {
				if(!confirm("삭제하시겠습니까?")) {
					isContinues = false;
				}
			}
			
			if( isContinues ) {
				if( widgetNode != undefined && widgetNode != null ) {
					grid.removeWidget(widgetNode.get(0));
					
					// show add button
					var Row, statsCd;
					for(var i = 0; i < sheet2.RowCount(); i++) {
						Row = i + 1;
						statsCd = sheet2.GetCellValue(Row,"statsCd");
						if( gid == statsCd ) {
							sheet2.SetCellValue(Row, "btnAdd", '<a class="basic">추가</a>');
						}
					}
				}
			}
		}
	}
</script>
<!-- [START] SHEET1 -->
<script type="text/javascript">
	// 통계 목록 시트 초기화
	function initSheet1() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"통계구성구분",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"presetTypeCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"통계구성소유",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"presetOwner",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"통계구성ID",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"presetId",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"통계구성명",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"presetNm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"통계구성설명",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"순서",			Type:"Int",			Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"사용여부",			Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"useYn",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"통계구성",			Type:"Image",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"layoutDetail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"미리보기",			Type:"Image",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"previewDetail",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
			{Header:"그룹코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"grpCd",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1 },
			{Header:"사번",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_setup.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_search.png");
		sheet1.SetDataLinkMouse("layoutDetail", 1);
		sheet1.SetDataLinkMouse("previewDetail", 1);
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/StatsPresetMng.do?cmd=getStatsPresetMngEmpList", $("#sheetForm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"presetId", true, true)){break;}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/StatsPresetMng.do?cmd=saveStatsPresetMng", $("#sheetForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "presetTypeCd", "E");
			sheet1.SetCellValue(row, "useYn", "Y");
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		}
	}	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			sheetResize();
		} catch (ex) {
			alert("[Sheet1] OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			if(Code >= 1) {
				doAction1("Search");
			}
		} catch (ex) {
			alert("[Sheet1] OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col){
		try{
			if(Row > 0 && (sheet1.GetCellValue(Row, "sStatus") == "U" || sheet1.GetCellValue(Row, "sStatus") == "R")) {
				// 작업 통계구성 정보 셋팅
				setWorkPresetInfo(Row);
				
				// 레이아웃 구성 클릭 시
				if(sheet1.ColSaveName(Col) == "layoutDetail") {
					viewScene("layoutEdit");
				}
				// 미리보기 클릭 시
				if(sheet1.ColSaveName(Col) == "previewDetail") {
					viewScene("preview");
				}
			}
		} catch(ex){
			alert("[Sheet1] OnClick Event Error : " + ex);
		}
	}
	
	// 작업 통계구성 정보 셋팅
	function setWorkPresetInfo(Row) {
		var presetId = sheet1.GetCellValue(Row,"presetId"), presetNm = sheet1.GetCellValue(Row,"presetNm");
		if(sheet1.GetCellValue(Row, "sStatus") == "U" || sheet1.GetCellValue(Row, "sStatus") == "R") {
			// 통계구성ID값 삽입
			$("#searchPresetId").val(presetId);
			// 현재작업통계구성명 삽입
			$(".editPresetInfo").html($("<span/>", {
				"class" : ""
			}).text("현재 작업중인 통계 구성 : "));
			$(".editPresetInfo").append($("<span/>", {
				"class" : "f_point f_bold"
			}).text(presetNm));
		} else {
			$("#searchPresetId").val("");
			$(".editPresetInfo").empty();
		}
	}
</script>
<!-- [END]   SHEET1 -->
<!-- [START] SHEET2 -->
<script type="text/javascript">
	// 통계 목록 시트 초기화
	function initSheet2() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"통계명",			Type:"Text",		Hidden:0,	Width:170,	Align:"Left",      ColMerge:0,   SaveName:"statsNm" },
			{Header:"기본 크기\n(가로)",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",    ColMerge:0,   SaveName:"chartSizeW" },
			{Header:"기본 크기\n(세로)",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",    ColMerge:0,   SaveName:"chartSizeH" },
			{Header:"사용가능\n여부",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",    ColMerge:0,   SaveName:"useYn" },
			{Header:"추가",			Type:"Html",		Hidden:0,	Width:50,	Align:"Center",    ColMerge:0,   SaveName:"btnAdd" },
			{Header:"미리보기",			Type:"Image",		Hidden:0,	Width:60,	Align:"Center",    ColMerge:0,   SaveName:"previewDetail" },
			{Header:"통계ID",			Type:"Text",		Hidden:1,	Width:180,	Align:"Left",      ColMerge:0,   SaveName:"statsCd" }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetImageList(1,"${ctx}/common/images/icon/icon_preview.png");
		sheet2.SetDataLinkMouse("previewDetail", 1);
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	// Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/StatsPresetMng.do?cmd=getStatsPresetMngAllowStatsList", $("#sheetForm").serialize() );
			break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			var Row, statsCd, useYn;
			for(var i = 0; i < sheet2.RowCount(); i++) {
				Row = i + 1;
				statsCd = sheet2.GetCellValue(Row,"statsCd");
				useYn = sheet2.GetCellValue(Row,"useYn");
				if( ($(".grid-stack-item[gs-id='" + statsCd + "']", ".grid-stack").length == 0)
						&& ( useYn == "Y" ) ) {
					sheet2.SetCellValue(Row, "btnAdd", '<a class="basic">추가</a>');
				}
				sheet2.SetCellValue(Row, "previewDetail", "1");
			}
			
			sheetResize();
		} catch (ex) {
			alert("[Sheet2] OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 셀 클릭시 이벤트
	function sheet2_OnClick(Row, Col, Value) {
		var statsCd, statsNm, chartSizeW, chartSizeH;
		try{
			if(Row >= sheet2.HeaderRows()){
				if(sheet2.GetCellValue(Row,"btnAdd") != ""){
					statsCd = sheet2.GetCellValue(Row,"statsCd");
					statsNm = sheet2.GetCellValue(Row,"statsNm");
					chartSizeW = parseInt(sheet2.GetCellValue(Row,"chartSizeW"));
					chartSizeH = parseInt(sheet2.GetCellValue(Row,"chartSizeH"));
					
					// 추가되지 않은 경우
					if( $(".grid-stack-item[gs-id='" + statsCd + "']", ".grid-stack").length == 0 ) {
						var widgetEle = $("#template_widget").clone();
						widgetEle.find(".btn_remove_widget").attr("gid", statsCd);
						widgetEle.find(".statsNm").html(statsNm);
						widgetEle.find(".statsNm").append($("<button/>", {
							"class" : "basic mal10",
							"onclick" : "javascript:HR_CHART_UTIL.openChartPreviewPop('" + statsCd + "', '" + statsNm + "', " + chartSizeW + ", " + chartSizeH + ", 'N');"
						}).text("preview"));
						
						var positionX = 0, positionY = 0, lastWidget;
						if( gridSerializedData.length > 0 ) {
							lastWidget = gridSerializedData[gridSerializedData.length - 1];
							positionY = (lastWidget.y + lastWidget.h) + 1
						}
						
						// add
						grid.addWidget({
							x       : positionX,
							y       : positionY,
							w       : chartSizeW,
							h       : chartSizeH,
							maxW    : gridMaxColumn,
							maxH    : gridMaxColumn,
							id      : statsCd,
							content : widgetEle.html()
						});
						
						sheet2.SetCellValue(Row, "btnAdd", '');
					} else {
						alert("이미 추가된 통계입니다.");
					}
				}
				
				if(sheet2.ColSaveName(Col) == "previewDetail") {
					HR_CHART_UTIL.openChartPreviewPop(
						  sheet2.GetCellValue(Row,"statsCd")
						, sheet2.GetCellValue(Row,"statsNm")
						, parseInt(sheet2.GetCellValue(Row,"chartSizeW"))
						, parseInt(sheet2.GetCellValue(Row,"chartSizeH"))
					);
				}

			}
		}catch(ex){alert("[Sheet2] OnClick Event Error : " + ex);}
	}
</script>
<!-- [END]   SHEET2 -->
<!-- [START] SHEET3 -->
<script type="text/javascript">
	// 사용 통계 목록 시트 초기화
	function initSheet3() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"통계구성구분",		Type:"Text",		Hidden:1,	ColMerge:0,   SaveName:"presetTypeCd" },
			{Header:"통계구성소유자",		Type:"Text",		Hidden:1,	ColMerge:0,   SaveName:"presetOwner" },
			{Header:"통계구성ID",		Type:"Text",		Hidden:1,	ColMerge:0,   SaveName:"presetId" },
			{Header:"WIDGET ID",	Type:"Text",		Hidden:1,	ColMerge:0,   SaveName:"widgetId" },
			{Header:"통계코드",			Type:"Text",		Hidden:1,	ColMerge:0,   SaveName:"statsCd" },
			{Header:"통계명",			Type:"Text",		Hidden:1,	ColMerge:0,   SaveName:"statsNm" },
			{Header:"순서",			Type:"Int",			Hidden:1,	ColMerge:0,   SaveName:"seq" },
			{Header:"차트 위치 X축 좌표",	Type:"Int",			Hidden:1,	ColMerge:0,   SaveName:"chartPositionX" },
			{Header:"차트 위치 Y축 좌표",	Type:"Int",			Hidden:1,	ColMerge:0,   SaveName:"chartPositionY" },
			{Header:"가로\n사이즈",		Type:"Int",			Hidden:1,	ColMerge:0,   SaveName:"chartSizeW" },
			{Header:"세로\n사이즈",		Type:"Int",			Hidden:1,	ColMerge:0,   SaveName:"chartSizeH" },
			{Header:"여백여부",			Type:"Text",		Hidden:1,	ColMerge:0,   SaveName:"dummyYn" }
		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);
	}
	
	// Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			sheet3.DoSearch( "${ctx}/StatsPresetMng.do?cmd=getStatsPresetMngUseItemList", $("#sheetForm").serialize() );
			break;
		case "Save":
			// remove all rows
			sheet3.RemoveAll();
			
			// grid 자동 정렬 및 위젯 재배치
			grid.compact();
			gridSerializedData = grid.save(true, true).children;
			//console.log('[Save] gridSerializedData', gridSerializedData);
			
			if( gridSerializedData != null && gridSerializedData.length > 0 ) {
				// insert row
				gridSerializedData.forEach(function(item, idx, arr){
					var dummyYn = "N", statsCd, row = sheet3.DataInsert(0);
					
					// 드래그하여 추가된 여백 위젯의 경우 id 속성이 없기 때문에 찾아서 삽입해줌.
					if( item.id == undefined ) {
						item.id = $(".grid-stack-item[gs-x='" + item.x + "'][gs-y='" + item.y + "'][gs-w='" + item.w + "'][gs-h='" + item.h + "']", ".grid-stack").attr("gs-id");
					}
					
					// 여백위젯인 경우
					if( item.id.indexOf("__DUMMY_") == 0 ) {
						dummyYn = "Y"
						statsCd = "";
					} else {
						statsCd = item.id;
					}
					
					sheet3.SetCellValue(row, "presetTypeCd", $("#searchPresetTypeCd").val());
					sheet3.SetCellValue(row, "presetOwner", "");
					sheet3.SetCellValue(row, "presetId", $("#searchPresetId").val());
					sheet3.SetCellValue(row, "widgetId", item.id);
					sheet3.SetCellValue(row, "statsCd", statsCd);
					sheet3.SetCellValue(row, "seq", (idx + 1));
					sheet3.SetCellValue(row, "chartPositionX", item.x);
					sheet3.SetCellValue(row, "chartPositionY", item.y);
					sheet3.SetCellValue(row, "chartSizeW", item.w);
					sheet3.SetCellValue(row, "chartSizeH", item.h);
					sheet3.SetCellValue(row, "dummyYn", dummyYn);
				});
			}
			
			// call save
			IBS_SaveName(document.sheetForm,sheet3);
			sheet3.DoSave( "${ctx}/StatsPresetMng.do?cmd=saveStatsPresetMngUseItem", $("#sheetForm").serialize());
			break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			var widgetEle = $("#template_widget").clone();
			var Row, widgetId, dummyYn, statsCd, statsNm, chartSizeW, chartSizeH, chartPositionX, chartPositionY;
			var serializedData = [];
			for(var i = 0; i < sheet3.RowCount(); i++) {
				Row = i + 1;
				widgetId = sheet3.GetCellValue(Row,"widgetId");
				dummyYn = sheet3.GetCellValue(Row,"dummyYn");
				statsCd = sheet3.GetCellValue(Row,"statsCd");
				statsNm = sheet3.GetCellValue(Row,"statsNm");
				chartSizeW = parseInt(sheet3.GetCellValue(Row,"chartSizeW"));
				chartSizeH = parseInt(sheet3.GetCellValue(Row,"chartSizeH"));
				chartPositionX = parseInt(sheet3.GetCellValue(Row,"chartPositionX"));
				chartPositionY = parseInt(sheet3.GetCellValue(Row,"chartPositionY"));
				
				if( dummyYn == "Y" ) {
					statsNm = dummyTitle;
				}
				
				widgetEle.find(".btn_remove_widget").attr("gid", widgetId);
				widgetEle.find(".statsNm").html(statsNm);
				
				if( dummyYn == "N" ) {
					widgetEle.find(".statsNm").append($("<button/>", {
						"class" : "basic mal10",
						"onclick" : "javascript:HR_CHART_UTIL.openChartPreviewPop('" + statsCd + "', '" + statsNm + "', " + chartSizeW + ", " + chartSizeH + ", 'N');"
					}).text("preview"));
				}
				
				// put item
				serializedData.push({
					x       : chartPositionX,
					y       : chartPositionY,
					w       : chartSizeW,
					h       : chartSizeH,
					maxW    : gridMaxColumn,
					maxH    : gridMaxColumn,
					id      : widgetId,
					content : widgetEle.html()
				});
			}
			
			// load grid
			grid.load(serializedData, true); // update things
			
			$(".grid-stack-item", ".grid-stack").each(function(idx, obj){
				if( $(this).attr("gs-id").indexOf("__DUMMY_") == 0 ) {
					$(this).addClass("dummy");
				}
			});
			
			doAction2("Search");
			
			sheetResize();
		} catch (ex) {
			alert("[Sheet3] OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			if( Code > 0 ) {
				// 새로 조회
				doAction3("Search");
				
				p.popReturnValue();
				
				if(confirm("현 통계구성의 미리보기 단계로 이동하시겠습니까?")) {
					// 미리보기 영역 출력
					viewScene("preview");
				}
			}
		} catch (ex) {
			alert("[Sheet3] OnSaveEnd Event Error " + ex);
		}
	}
</script>
<!-- [END]   SHEET3 -->
<!-- [START] CHART -->
<script type="text/javascript">
	// 통계 초기화
	function initChartDashboard() {
		// 스크롤 상단으로 이동
		g_chartListEle.parent().scrollTop(0);
		// 차트 출력 영역 초기화
		g_chartListEle.empty();
		if( statsChartData != null && statsChartData.LIST != undefined && statsChartData.LIST != null && statsChartData.LIST.length > 0 ) {
			// 1. 차트 박스 레이아웃 추가
			statsChartData.LIST.forEach(function(item, idx, arr){
				// 차트 레이아웃 추가
				if( item.useYn == "Y" ) {
					addChartLayout(item, idx);
				}
			});

			var dataList;
			statsChartData.LIST.forEach(function(item, idx, arr){
				if( item.useYn == "Y" && item.dummyYn == "N" ) {
					dataList = null;
					if( statsChartData.DATA && statsChartData.DATA != null && statsChartData.DATA[item.statsCd] && statsChartData.DATA[item.statsCd] != null ) {
						dataList = statsChartData.DATA[item.statsCd];
					}
					
					// 차트 데이터를 개별로 조회해야 하는 상황이며 데이터 조회 SQL이 존재하는 통계인 경우
					if( statsChartData.DATA.ajaxCallFlag == "Y" && item.existsSql == "Y" ) {
						drawChartBeforeGetData(item);
					} else {
						// 차트 출력
						drawChart(item, dataList);
					}
				}
				
				// destroy preloader
				if( idx > 3 && showPreloader ) {
					progressBar(false);
					showPreloader = false;
				}
			});
			
			var dashboardHeight = $(".stats-item:last", g_chartListEle).position().top;
			dashboardHeight += $(".stats-item:last", g_chartListEle).outerHeight() + 30;
			g_chartListEle.css({
				"height" : dashboardHeight + "px"
			});
		}
		
		// destroy preloader
		if( showPreloader ) {
			setTimeout(function() {
				progressBar(false);
				showPreloader = false;
			}, 250);
		}
	}
	
	// add layout
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
		width  = (g_defaultSize * chartSizeW) + ((chartSizeW - 1) * g_spaceSize);
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
			data: "searchStatsCd=" + statsItem.statsCd,
			success: function(data) {
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
			chartOpt.chart.width  = (g_defaultSize * chartSizeW) + ((chartSizeW - 1) * g_spaceSize) - g_spaceSize;
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
</script>
<!-- [END]   CHART -->
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>개인 통계구성 관리</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="editPresetInfo hide"></div>
	<div class="popup_main">
		<form id="sheetForm" name="sheetForm" tabindex="1">
			<input id="searchPresetTypeCd" name="searchPresetTypeCd" type="hidden" value="E" >
			<input id="searchPresetOwner" name="searchPresetOwner" type="hidden" value="" >
			<input id="searchPresetId" name="searchPresetId" type="hidden" value="" >
		</form>
		<div class="slide">
			<div id="presetEdit" class="scene active">
				<ul class="w100p">
					<li>
						<div class="outer">
							<div class="sheet_title">
								<ul>
									<li class="txt">통계 구성</li>
									<li class="btn">
										<a href="javascript:doAction1('Search')"     class="basic authR">조회</a>
										<a href="javascript:doAction1('Insert')"     class="basic authA">입력</a>
										<a href="javascript:doAction1('Copy')"       class="basic authA">복사</a>
										<a href="javascript:doAction1('Save')"       class="basic authA">저장</a>
									</li>
								</ul>
							</div>
						</div>
					</li>
					<li>
						<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
					</li>
				</ul>
			</div>
			<div id="layoutEdit" class="scene">
				<ul class="w100p">
					<li>
						<div class="sheet_title">
							<ul>
								<li class="txt">레이아웃 구성</li>
								<li class="btn">
									<a href="javascript:viewScene('presetEdit');" class="basic" title="통계 구성"><img src="${ctx}/common/images/icon/icon_prev.png" class="valignM" />통계 구성</a>
									<a href="javascript:viewScene('preview');" class="basic" title="미리보기">미리보기 <img src="${ctx}/common/images/icon/icon_next.png" class="valignM" /></a>
								</li>
							</ul>
						</div>
						<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
							<colgroup>
								<col width="30%">
								<col width="9%">
								<col width="*">
								<col width="5%">
							</colgroup>
							<tr>
								<td class="valignT">
									<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
								</td>
								<td class="alignC valignT">
									<div class="dummyWrap" onclick="javascript:addDummyWidget();">
										<div class="dummyWidget grid-stack-item">
											<div class="grid-stack-item-content">
												<div class="drag mat20 mab20">
													<div class="txt">- Blank -</div>
												</div>
												<div class="info mat20 mab20">
													<span class="f_s20 f_bold">+ 여백 추가</span>
													<br/><br/>
													클릭 혹은 드래그해<br/>추가해주세요.
												</div>
											</div>
										</div>
									</div>
									<div class="widgetReLayout mat10">
										<label>
											<input type="checkbox" id="widgetReLayoutFlag" name="widgetReLayoutFlag" class="checkbox" />
											자동 정렬/재배치
										</label>
									</div>
								</td>
								<td class="padr30" style="overflow-x:hidden">
									<div id="area_layout_set">
										<div class="grid-stack"></div>
									</div>
								</td>
								<td class="alignR valignT">
									<a href="javascript:doAction3('Save');" class="button large w70 h30 f_s16 padt20"><tit:txt mid='104476' mdef='저장'/></a>
								</td>
							</tr>
						</table>
					</li>
				</ul>
			</div>
			<div id="preview" class="scene">
				<ul class="w100p">
					<li>
						<div class="sheet_title">
							<ul>
								<li class="txt">미리보기</li>
								<li class="btn">
									<a href="javascript:viewScene('layoutEdit');" class="basic" title="레이아웃 구성"><img src="${ctx}/common/images/icon/icon_prev.png" class="valignM" />레이아웃 구성</a>
								</li>
							</ul>
						</div>
						<div id="area_chartWrap">
							<div id="area_chartList"></div>
						</div>
					</li>
			</div>
		</ul>
	</div>
	<div class="slide_breadcrumb mat15 outer">
		<a href="javascript:viewScene('presetEdit');" slide="presetEdit" title="통계 구성" class="active"></a>
		<a href="javascript:viewScene('layoutEdit');" slide="layoutEdit" title="레이아웃 구성"></a>
		<a href="javascript:viewScene('preview');"    slide="preview"    title="미리보기"></a>
	</div>
</div>
<div class="hide">
	<script type="text/javascript"> createIBSheet("sheet3", "100%", "0%", "${ssnLocaleCd}"); </script>
</div>
<div id="template_widget" class="hide">
	<ul class="widget">
		<li class="alignR"><button type="button" class="btn_remove_widget fa fa-remove" onclick="javascript:removeWidget(this);"></button></li>
		<li class="alignC contents">
			<div class="statsNm"></div>
		</li>
	</ul>
</div>
</body>
</html>