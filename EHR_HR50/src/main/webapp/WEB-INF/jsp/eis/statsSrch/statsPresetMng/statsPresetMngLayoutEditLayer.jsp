<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>통계 레이아웃 구성</title>

<script src="${ctx}/common/plugin/EIS/js/chart.js?ver=<%= System.currentTimeMillis()%>" type="text/javascript"></script>
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

	.widget {border-radius: 0; height:100% !important;}
	a.basic {width:70%; text-align: center; padding: 5px; line-height: 1; height: 100%; border-radius: 6px;}
	.sheet_title {align-items: flex-start !important;}
	.GMSection .GMDataRow , .GMSection .GMDataRow td {height:24px !important;}

</style>
<script type="text/javascript">
	var statsPresetMngLayoutEditLayer = {id: 'statsPresetMngLayoutEditLayer'};
	var grid = null, gridMaxColumn = 6, gridSerializedData = [];
	var dummyTitle = "- Blank -";
	
	// GridStack.js 라이브러리가 IE에서는 정상적으로 동작하지 않기에 IE에서 접근 시 윈도우 종료 시킴.
	if (window.navigator.userAgent.indexOf('MSIE') > -1 || window.navigator.userAgent.indexOf('Trident') > -1) {
		alert("Internet Explorer 웹브라우저에서는 지원하지 않는 기능입니다.");
		const modal = window.top.document.LayerModalUtility.getModal(statsPresetMngLayoutEditLayer.id);
		modal.hide();
	}
	
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal(statsPresetMngLayoutEditLayer.id);
		// 전체화면출력
		modal.makeFull();
		var { searchPresetTypeCd, searchPresetOwner, searchPresetId, searchPresetNm } = modal.parameters;
		$("#searchPresetTypeCd").val(searchPresetTypeCd);
		$("#searchPresetOwner").val(searchPresetOwner);
		$("#searchPresetId").val(searchPresetId);
		$("#searchPresetNm").val(searchPresetNm);
		
		// 현재작업통계구성명 삽입
		$(".editPresetInfo").html($("<span/>", {
			"class" : ""
		}).text("현재 작업중인 통계 구성 : "));
		$(".editPresetInfo").append($("<span/>", {
			"class" : "f_point f_bold"
		}).text(searchPresetNm));
		
		// init grid
		grid = GridStack.init({
			minRow: 5, // don't let it collapse when empty
			column: gridMaxColumn,
			cellHeight: 'auto',
			cellHeightThrottle: 100,
			marginTop: '20px',
			marginLeft: '20px',
			resizable: { handles: 'all'},
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
		
		// 시트 초기화 및 데이터 조회
		initSheet1();
		initSheet2();
		doAction2("Search");
		
	});

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
				"gs-max-w" : gridMaxColumn,
				"gs-max-h" : gridMaxColumn,
				"gs-id"    : gid
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
					for(var i = 0; i < statsheet.RowCount(); i++) {
						Row = i + 1;
						statsCd = statsheet.GetCellValue(Row,"statsCd");
						if( gid == statsCd ) {
							statsheet.SetCellValue(Row, "btnAdd", '<a class="basic">추가</a>');
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
		createIBSheet3(document.getElementById('statsheet_wrap'), "statsheet", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		]; IBS_InitSheet(statsheet, initdata);statsheet.SetEditable("${editable}");statsheet.SetVisible(true);statsheet.SetCountPosition(4);
		statsheet.SetImageList(1,"${ctx}/common/images/icon/icon_preview.png");
		statsheet.SetDataLinkMouse("previewDetail", 1);
		$(window).smartresize(sheetResize); sheetInit();


		var sheetHeight = $(".modal_body").height();
		statsheet.SetSheetHeight(sheetHeight);
	}
	
	// Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			statsheet.DoSearch( "${ctx}/StatsMng.do?cmd=getStatsMngList", $("#sheetForm").serialize() );
			break;
		}
	}
	
	// 조회 후 에러 메시지
	function statsheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			var Row, statsCd, useYn;
			for(var i = 0; i < statsheet.RowCount(); i++) {
				Row = i + 1;
				statsCd = statsheet.GetCellValue(Row,"statsCd");
				useYn = statsheet.GetCellValue(Row,"useYn");
				if( ($(".grid-stack-item[gs-id='" + statsCd + "']", ".grid-stack").length == 0)
						&& ( useYn == "Y" ) ) {
					statsheet.SetCellValue(Row, "btnAdd", '<a class="basic">추가</a>');
				}
				statsheet.SetCellValue(Row, "previewDetail", "1");
			}
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 셀 클릭시 이벤트
	function statsheet_OnClick(Row, Col, Value) {
		var statsCd, statsNm, chartSizeW, chartSizeH;
		try{
			if(Row >= statsheet.HeaderRows()){
				if(statsheet.GetCellValue(Row,"btnAdd") != ""){
					statsCd = statsheet.GetCellValue(Row,"statsCd");
					statsNm = statsheet.GetCellValue(Row,"statsNm");
					chartSizeW = parseInt(statsheet.GetCellValue(Row,"chartSizeW"));
					chartSizeH = parseInt(statsheet.GetCellValue(Row,"chartSizeH"));
					
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
						
						statsheet.SetCellValue(Row, "btnAdd", '');
					} else {
						alert("이미 추가된 통계입니다.");
					}
				}
				
				if(statsheet.ColSaveName(Col) == "previewDetail") {
					HR_CHART_UTIL.openChartPreviewPop(
						  statsheet.GetCellValue(Row,"statsCd")
						, statsheet.GetCellValue(Row,"statsNm")
						, parseInt(statsheet.GetCellValue(Row,"chartSizeW"))
						, parseInt(statsheet.GetCellValue(Row,"chartSizeH"))
					);
				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
</script>
<!-- [END] SHEET1 -->
<!-- [START] SHEET2 -->
<script type="text/javascript">
	// 사용 통계 목록 시트 초기화
	function initSheet2() {
		createIBSheet3(document.getElementById('usesheet_wrap'), "usesheet", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		]; IBS_InitSheet(usesheet, initdata);usesheet.SetEditable("${editable}");usesheet.SetVisible(true);usesheet.SetCountPosition(4);
	}
	
	// Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			usesheet.DoSearch( "${ctx}/StatsPresetMng.do?cmd=getStatsPresetMngUseItemList", $("#sheetForm").serialize() );
			break;
		case "Save":
			// remove all rows
			usesheet.RemoveAll();
			
			// grid 자동 정렬 및 위젯 재배치
			grid.compact();
			gridSerializedData = grid.save(true, true).children;
			//console.log('[Save] gridSerializedData', gridSerializedData);
			
			if( gridSerializedData != null && gridSerializedData.length > 0 ) {
				// insert row
				gridSerializedData.forEach(function(item, idx, arr){
					var dummyYn = "N", statsCd, row = usesheet.DataInsert(0);
					
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
					
					usesheet.SetCellValue(row, "presetTypeCd", $("#searchPresetTypeCd").val());
					usesheet.SetCellValue(row, "presetOwner", $("#searchPresetOwner").val());
					usesheet.SetCellValue(row, "presetId", $("#searchPresetId").val());
					usesheet.SetCellValue(row, "widgetId", item.id);
					usesheet.SetCellValue(row, "statsCd", statsCd);
					usesheet.SetCellValue(row, "seq", (idx + 1));
					usesheet.SetCellValue(row, "chartPositionX", item.x);
					usesheet.SetCellValue(row, "chartPositionY", item.y);
					usesheet.SetCellValue(row, "chartSizeW", item.w);
					usesheet.SetCellValue(row, "chartSizeH", item.h);
					usesheet.SetCellValue(row, "dummyYn", dummyYn);
				});
			}
			// call save
			IBS_SaveName(document.sheetForm,usesheet);
			usesheet.DoSave( "${ctx}/StatsPresetMng.do?cmd=saveStatsPresetMngUseItem", $("#sheetForm").serialize());
			break;
		}
	}
	
	// 조회 후 에러 메시지
	function usesheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			var widgetEle = $("#template_widget").clone();
			var Row, widgetId, dummyYn, statsCd, statsNm, chartSizeW, chartSizeH, chartPositionX, chartPositionY;
			var serializedData = [];
			for(var i = 0; i < usesheet.RowCount(); i++) {
				Row = i + 1;
				widgetId = usesheet.GetCellValue(Row,"widgetId");
				dummyYn = usesheet.GetCellValue(Row,"dummyYn");
				statsCd = usesheet.GetCellValue(Row,"statsCd");
				statsNm = usesheet.GetCellValue(Row,"statsNm");
				chartSizeW = parseInt(usesheet.GetCellValue(Row,"chartSizeW"));
				chartSizeH = parseInt(usesheet.GetCellValue(Row,"chartSizeH"));
				chartPositionX = parseInt(usesheet.GetCellValue(Row,"chartPositionX"));
				chartPositionY = parseInt(usesheet.GetCellValue(Row,"chartPositionY"));
				
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
			
			if( serializedData.length > 0 ) {
				// load grid
				grid.load(serializedData, true); // update things
				
				$(".grid-stack-item", ".grid-stack").each(function(idx, obj){
					if( $(this).attr("gs-id").indexOf("__DUMMY_") == 0 ) {
						$(this).addClass("dummy");
					}
				});
			}
			
			doAction1("Search");
			
			sheetResize();
		} catch (ex) {
			alert("[Sheet2] OnSearchEnd Event Error : " + ex);
		}
	}
	
	// 저장 후 메시지
	function usesheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction2("Search");
		} catch (ex) {
			alert("[Sheet2] OnSaveEnd Event Error " + ex);
		}
	}
</script>
<!-- [END] SHEET2 -->
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="editPresetInfo"></div>
	<div class="modal_body">
		<form id="sheetForm" name="sheetForm" tabindex="1">
			<input id="searchPresetTypeCd" name="searchPresetTypeCd" type="hidden" >
			<input id="searchPresetOwner" name="searchPresetOwner" type="hidden" >
			<input id="searchPresetId" name="searchPresetId" type="hidden" >
			<input id="searchPresetNm" name="searchPresetNm" type="hidden" >
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<colgroup>
				<col width="30%">
				<col width="12%">
				<col width="*">
			</colgroup>
			<tr>
				<td style="vertical-align: top;">
					<!-- <div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt" style="margin-top:0;">통계 목록</li>
							<li class="btn"></li>
						</ul>
						</div>
					</div> -->
					<div id="statsheet_wrap"></div>
					<!-- <script type="text/javascript"> createIBSheet("statsheet", "100%", "100%", "${ssnLocaleCd}"); </script> -->
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
				<td style="overflow-x:hidden; display:flex;">
					<div id="area_layout_set" style="margin-top:0;">
						<div class="grid-stack"></div>
					</div>
				</td>
				<!-- 기존 저장/닫기 버튼 24.2.22 -->
				<!-- <td class="alignC valignT">
					<a href="javascript:doAction2('Save');" class="button large mat40 w70 h30 f_s16 padt20"><tit:txt mid='104476' mdef='저장'/></a>
					<br/>
					<a href="javascript:closeCommonLayer('statsPresetMngLayoutEditLayer');" class="button bg_gray_a large mat20 w70 h30 f_s16 padt20"><tit:txt mid='104157' mdef='닫기'/></a>
				</td> -->
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:doAction2('Save');" class="btn filled"><tit:txt mid='104476' mdef='저장'/></a>
		<a href="javascript:closeCommonLayer('statsPresetMngLayoutEditLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
<div class="hide">
	<div id="usesheet_wrap"></div>
	<!-- <script type="text/javascript"> createIBSheet("usesheet", "100%", "0%", "${ssnLocaleCd}"); </script> -->
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