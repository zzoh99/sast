<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchart.js" type="text/javascript"></script>
<script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchartinfo.js" type="text/javascript"></script>

<script type="text/javascript">
var chartType = "hist";
var myChart1Data = null;
var myChart2Data = null;
	$(function() {

		$("#searchYyyy").val("<%=DateUtil.getThisYear()%>") ;//현재년월 세팅
		$("#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ searchAllChart(); $(this).focus(); }
		});

		if("${ssnEnterAllYn}" == "Y"){
			$(".spEnterCombo").removeClass("hide");
		}

		$("#searchYyyy").bind("keyup",function(event){
			makeNumber(this,'A');
			if( event.keyCode == 13){
				initSearchCombo();
				searchAllChart();
				$(this).focus();
			}
		});

		$("#searchYyyy").change(function (){
			if($("#searchYyyy").val().length === 4 && $.isNumeric($("#searchYyyy").val()))
				initSearchCombo();
		});

		// 회사코드
		var enterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAuthEnterCdList&searchGrpCd=${ssnGrpCd}",false).codeList, "");
		$("#groupEnterCd").html(enterCdList[2]);
		$("#groupEnterCd").val("${ssnEnterCd}");
		$("#groupEnterCd").bind("change",function(event){
			initSearchCombo();
			searchAllChart();
			$(this).focus();
		});
		
		// 콤보박스 세팅
		initSearchCombo();
		
		//라디오클릭
		$("input[id='chartType']").click(function(){
			if($(this).val() == "hist") {
				chartType = "hist";
			} else {
				chartType = "gubun";
			}
		});

		ChartDesign1();
		ChartDesign2();

		CallChart1();
		CallChart2();

	});

	// 콤보박스 셋팅
	function initSearchCombo() {
		let searchYear = $("#searchYyyy").val();
		let baseSYmd = "";
		let baseEYmd = "";
		if (searchYear !== "") {
			baseSYmd = searchYear + "-01-01";
			baseEYmd = searchYear + "-12-31";
		}
		var addParam = "&enterCd="+$("#groupEnterCd").val();

		//직군
		var searchWorkType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList" + addParam,"H10050", baseSYmd, baseEYmd), "");
		$("#searchWorkType").html(searchWorkType[2]);
		$("#searchWorkType").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});
		
		//성별
		var searchSexType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList" + addParam,"H00010", baseSYmd, baseEYmd), "");
		$("#searchSexType").html(searchSexType[2]);
		$("#searchSexType").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});
		
		// 선택된 회사에서 사용하는 코드 체계가 아닌 경우가 있으므로 기존에 선택된 항목 삭제
		if($(".select2-search-choice").length > 0) {
			$(".select2-search-choice").remove();
		}
	}

	function ChartDesign1() {
		// 차트 Copyright 설정

		myChart1.SetCopyright({enabled:0});
		myChart1.SetPlotBackgroundColor("#F7FAFB");
		myChart1.SetPlotBorderColor("#A9AEB1");
		myChart1.SetPlotBorderWidth(0.5);

		myChart1.SetZoomType(IBZoomType.X_AND_Y);

		var color = new Color();
		color.SetLinearGradient(0, 0, 100, 500);
		color.AddColorStop(0, "#FFFFFF");
		color.AddColorStop(1, "#D3D9E5");
		myChart1.SetBackgroundColor(color);
		myChart1.SetMainTitle({Enabled:true, Text:"", FontWeight:"bold", Color:"#15498B"});

		var Yaxis = myChart1.GetYAxis(0);
		Yaxis.SetGridLineDashStyle(IBDashStyle.SHORT_DASH);
		Yaxis.SetGridLineColor("#C4C9CD");
		Yaxis.SetGridLineWidth(0.5);
		Yaxis.SetLineColor("#9BA3A5");
		Yaxis.SetMinorGridLineWidth(0);
		Yaxis.SetMinorTickInterval(500);
		Yaxis.SetMinorTickLength(2);
		Yaxis.SetMinorTickWidth(1);
		Yaxis.SetMinorTickColor("#7C7C7E");
		Yaxis.SetTickColor("#7C7C7E");
		Yaxis.SetTickInterval(500);
		Yaxis.SetAxisTitle({Enabled:false, Text:""});

		var Xaxis = myChart1.GetXAxis(0);
		Xaxis.SetGridLineWidth(0.5);
		Xaxis.SetGridLineColor("#C4C9CD");
		Xaxis.SetGridLineDashStyle(IBDashStyle.SOLID);
		Xaxis.SetLineColor("#9BA3A5");
		Xaxis.SetMinorTickColor("#7C7C7E");
		Xaxis.SetTickColor("#7C7C7E");
		//누적x, 막대상단 value 표시
		var plot = new ColumnPlotOptions();
		plot.SetStacking(null);
		plot.SetDataLabels(true,IBAlign.CENTER,0,-3,'#333333');
		myChart1.SetColumnPlotOptions(plot);

		myChart1.SetLegend({Enabled:true, Align:IBAlign.CENTER, Valign:IBVerticalAlign.BOTTOM, Layout:IBLayout.HORIZONTAL});

		var tooltip = new ToolTip();
		myChart1.SetToolTip({Enabled:true, Shadow:true, Formatter:ToolTipFormatter, Color:'#000000', FontSize:'13px',FontWeight:'bold'});

	}

	function ToolTipFormatter(){
		return '<span style="color:#040087;">' + myChart1.xAxes[0].categories[this.point.x] + '</span><br/>' + this.series.name + ' : <b>' + this.y + '</b>' ;
	}

	function CallChart1(Type)
	{
		myChart1.RemoveAll();
		//차트 타입 지정
		myChart1.SetDefaultSeriesType(IBChartType.COLUMN);

		//차트 데이터 지정
		//연령별 데이터
		var result1;

		result1 = ajaxCall("${ctx}/RetEmpHisSta.do?cmd=getRetEmpHisStaList2",$("#srchFrm").serialize(),false);
        var interval = -1;
		 var $timer = $("#timer");
         interval = setInterval(function() {
        	 drawChartForAnime1(result1) ;
        	 clearInterval(interval);
         },400);
	}

	function drawChartForAnime1(result1, result2, result3, minusYmd, minusYmd2) {
		var pieChartTitle = "퇴사자 인원변동추이" ;
		if(result1["DATA"].length == 0 && result2["DATA"].length == 0 && result3["DATA"].length == 0) {
			alert("해당 기준일자의 데이터가 존재하지 않습니다.") ;
			return ;
		}
		var data = "{";
		data += 		"IBCHART: {";
		data += 		"BACKCOLOR: '#FFFFFF',";
		data += 		"BORDERWIDTH: '1',";
		data += 		"TITLE: '"+pieChartTitle+"',";
		data += 		"ETCDATA: [ {KEY:'sname', VALUE:'홍길동'},";
		data += 		"			{KEY:'age',   VALUE:'20'}";
		data += 		"		  ],";
		data += 		"DATA: {" ;
		data += 		"		POINTSET:[" ;
		myChart1Data = new Array();
		for(var i = 0; i < result1["DATA"].length; i++) {
			if(result1["DATA"][i]["cnt"] == "0") continue ;
			myChart1Data.push(result1["DATA"][i]);
			data += 		"				  {AXISLABEL:'"+result1["DATA"][i]["codeNm"]+"', " ;
			data += 		"					  SERIES:[{ LEGENDLABEL:'인원', POINTLABEL:'', VALUE:"+result1["DATA"][i]["cnt"]+"}, ";
			data += " 								   { LEGENDLABEL:'퇴사율(%)', POINTLABEL:'', VALUE:"+result1["DATA"][i]["perCnt"]+"}, ";
			data += "									   { LEGENDLABEL:'퇴사인원', POINTLABEL:'', VALUE:"+result1["DATA"][i]["enterCnt"]+"}, ";
			data += "									   { SERIESTYPE: 'line',LEGENDLABEL:'퇴사율(%)', POINTLABEL:'', VALUE:"+result1["DATA"][i]["perCnt"]+"}";
			data += 		"				 			 ] ";
			if(i == result1["DATA"].length-1 || ( i+1 <= result1["DATA"].length && result1["DATA"][i+1]["cnt"] == "0" ) ) {
				data += 		"	   		   }";
			} else {
				data += 		"	   		   },";
			}
		}
		data += 		"				 ] ";
		data += 		"	  }";
		data += 		"}";
		data += 	"}";

		// JSON 문자열을 읽어서 차트의 기본틀을 생성
		myChart1.GetDataJsonString(data);
	}

	function ChartDesign2() {
		// 차트 Copyright 설정

		myChart2.SetCopyright({enabled:0});
		myChart2.SetPlotBackgroundColor("#F7FAFB");
		myChart2.SetPlotBorderColor("#A9AEB1");
		myChart2.SetPlotBorderWidth(0.5);

		myChart2.SetZoomType(IBZoomType.X_AND_Y);

		var color = new Color();
		color.SetLinearGradient(0, 0, 100, 500);
		color.AddColorStop(0, "#FFFFFF");
		color.AddColorStop(1, "#D3D9E5");
		myChart2.SetBackgroundColor(color);
		myChart2.SetMainTitle({Enabled:true, Text:"", FontWeight:"bold", Color:"#15498B"});

		var Yaxis = myChart2.GetYAxis(0);
		Yaxis.SetGridLineDashStyle(IBDashStyle.SHORT_DASH);
		Yaxis.SetGridLineColor("#C4C9CD");
		Yaxis.SetGridLineWidth(0.5);
		Yaxis.SetLineColor("#9BA3A5");
		Yaxis.SetMinorGridLineWidth(0);
		Yaxis.SetMinorTickInterval(25);
		Yaxis.SetMinorTickLength(2);
		Yaxis.SetMinorTickWidth(1);
		Yaxis.SetMinorTickColor("#7C7C7E");
		Yaxis.SetTickColor("#7C7C7E");
		Yaxis.SetTickInterval(30);
		Yaxis.SetAxisTitle({Enabled:false, Text:""});

		var Xaxis = myChart2.GetXAxis(0);
		Xaxis.SetGridLineWidth(0.5);
		Xaxis.SetGridLineColor("#C4C9CD");
		Xaxis.SetGridLineDashStyle(IBDashStyle.SOLID);
		Xaxis.SetLineColor("#9BA3A5");
		Xaxis.SetMinorTickColor("#7C7C7E");
		Xaxis.SetTickColor("#7C7C7E");

		var plotPie = new PiePlotOptions();
// 		파이와 라벨의 거리, 두께, 색, padding, 부드러운 처리
		plotPie.SetDataLabelsConnector(25,1,'',5,true);
		myChart2.SetPiePlotOptions(plotPie);

		myChart2.SetLegend({Enabled:false, Align:IBAlign.CENTER, Valign:IBVerticalAlign.BOTTOM, Layout:IBLayout.HORIZONTAL});
		var tooltip = new ToolTip();
		myChart2.SetToolTip({Enabled:true, Shadow:true, Formatter:ToolTipFormatter2, Color:'#000000', FontSize:'13px',FontWeight:'bold'});
	}
	
	function ToolTipFormatter2(){
		return '<span style="color:#040087;">' + replaceAll(this.point.name,'<br>', '') + '</span><br />' + this.series.name + ' : <b>' + this.y + '</b>' ;
	}
	
	function CallChart2(Type)
	{
		myChart2.RemoveAll();
		//차트 타입 지정
		myChart2.SetDefaultSeriesType(IBChartType.PIE);
		myChart2.SetLegend(false) ;
		//차트 데이터 지정dev
		//연령별 데이터
		var result1 ;
		result1 = ajaxCall("${ctx}/RetEmpHisSta.do?cmd=getRetEmpHisStaList1",$("#srchFrm").serialize(),false);
        var interval = -1;
		 var $timer = $("#timer");
         interval = setInterval(function() {
        	 drawChartForAnime2(result1) ;
        	 clearInterval(interval);
         },400);
	}

	function drawChartForAnime2(result1) {
		var pieChartTitle = "퇴사구분";//'직위별 인원비율' ;

		var totCnt = 0;
		for(var i = 0; i < result1["DATA"].length; i++) {
			totCnt += result1["DATA"][i]["cnt"];
		}
		var pieSubTitle ="(퇴사자 " + totCnt + ")";

		var data = "{";
		data += 		"IBCHART: {";
		data += 		"BACKCOLOR: '#FFFFFF',";
		data += 		"BORDERWIDTH: '1',";
		data += 		"TITLE: '" + $("#searchYyyy").val()+"년도 " +pieChartTitle+ pieSubTitle +"',";
		data += 		"ETCDATA: [ {KEY:'sname', VALUE:'홍길동'},";
		data += 		"			{KEY:'age',   VALUE:'20'}";
		data += 		"		  ],";
		data += 		"DATA: {" ;
		data += 		"		POINTSET:[" ;
		//POINTSLICED OPTION IS VALID FOR THE PIE CHART
		myChart2Data = new Array();
		for(var i = 0; i < result1["DATA"].length; i++) {
			if(result1["DATA"][i]["cnt"] == "0") continue ;
			myChart2Data.push(result1["DATA"][i]);
			data += 		"				  {AXISLABEL:'"+result1["DATA"][i]["codeNm"]+"', " ;
			data += 		"					  SERIES:[{ LEGENDLABEL:'인원', POINTLABEL:'"+result1["DATA"][i]["codeNm"]+"<br>("+result1["DATA"][i]["perCnt"]+"%)', VALUE:"+result1["DATA"][i]["cnt"]+"}";
			data += 		"				 			 ] ";
			if(i == result1["DATA"].length-1) {
				data += 		"	   		   }";
			} else {
				data += 		"	   		   },";
			}
		}
		data += 		"				 ] ";
		data += 		"	  }";
		data += 		"}";
		data += 	"}";

		// JSON 문자열을 읽어서 차트의 기본틀을 생성
		myChart2.GetDataJsonString(data);
	}

	//  소속 팝입
    function orgSearchPopup(){
        try{
        	var w = 740, h = 520;
			var p = { searchEnterCd: $("#groupEnterCd").val() };
			var title = "<tit:txt mid='orgTreePop' mdef='조직도 조회'/>";
			var url = "/Popup.do?cmd=viewOrgTreeLayer";
			var layerModal = new window.top.document.LayerModal({
				id : 'orgTreeLayer', 
				url : url, 
				parameters: p,
				width : w, 
				height : h, 
				title : title,
				trigger: [
					{
						name: 'orgTreeLayerTrigger',
						callback: function(rv) {
							$("#searchOrgCd").val(rv.orgCd);
							$("#searchOrgNm").val(rv.orgNm);
							if(rv.priorOrgCd == "0") { $("#searchOrgCd").val("0"); }
							searchAllChart() ;
						}
					}
				]
			});
			layerModal.show();
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

	function searchAllChart() {

		$("#workType").val(($("#searchWorkType").val()==null?"":getMultiSelect($("#searchWorkType").val())));
		$("#sexType").val(($("#searchSexType").val()==null?"":getMultiSelect($("#searchSexType").val())));

		CallChart1() ;
		CallChart2() ;
	}

	function downChart(){
	 	if(chartType == "hist"){
	 		myChart1.Down2Image({FileName:"ExitHistChartImage", Type:IBExportType.JPEG, Width:800, Url:"/common/plugin/IBLeaders/Sheet/jsp/Down2Image.jsp"});
	 	}else if(chartType == "gubun"){
	 		myChart2.Down2Image({FileName:"ExitGubunChartImage", Type:IBExportType.JPEG, Width:800, Url:"/common/plugin/IBLeaders/Sheet/jsp/Down2Image.jsp"});
	 	}
	}
	function myChart1_OnPointClick(Index,X,Y){
		if(Index == 0 || Index == 2){
			var data = {"searchYmd": myChart1Data[X]["codeNm"]+"1231", "program":"empEmpHisSta"};
			if(Index == 2) data["retYyyy"]=myChart1Data[X]["codeNm"];
			openEmployeePopup(data);
		}
	}
	
	function myChart2_OnPointClick(Index, X , Y){
		var data = {"searchYmd": $("#searchYyyy").val()+"1231"
				    , "retYyyy":$("#searchYyyy").val()+"1231"
				    ,"rrcType": myChart2Data[X]["code"]
			};
		openEmployeePopup(data);
	}
	
	function openEmployeePopup(data){
		var url 	= "/Popup.do?cmd=viewCommonEmployeeLayer";
		var title 	= "<tit:txt mid='schEmployee' mdef='사원조회'/>";
		var w = 800;
		var h = 600;
		var p = {workTypeL: $("input[name=workType]").val(),
				 sexTypeL: $("input[name=sexType]").val(),
				 ...data};
		var layerModal = new window.top.document.LayerModal({
			id : 'commonEmployeeLayer', 
			url : url, 
			parameters: p,
			width : w,
			height : h,
			title : title
		});
		layerModal.show();
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input id="searchOrgCd" name ="searchOrgCd" type="hidden"/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>년도  </th>
				        <td>
				             <input class="text center" type="text" id="searchYyyy" name="searchYyyy" size="4" maxlength= "4">
				        </td>
				        <th class="spEnterCombo hide">회사  </th>
						<td class="spEnterCombo hide">
							<select id="groupEnterCd" name="groupEnterCd" class="w150"></select>
						</td>
						<th class="hide"><tit:txt mid='104295' mdef='소속 '/></th>
						<td class="hide">   <input id="searchOrgNm" name="searchOrgNm" type="text" class="text w150" /> </td>
						<td><btn:a href="javascript:searchAllChart()" id="btnSearch" css="btn dark" mid='search' mdef="조회"/> </td>
						<td> <a href="javascript:downChart()" id="btnDown" class="btn outline_gray"><tit:txt mid='113874' mdef='이미지다운'/></a> </td>
						<td>
							<input type="radio" name="chartType" id="chartType" value="hist" checked/><span>  퇴사자 변동추이</span>
							<input type="radio" name="chartType" id="chartType" value="gubun"/><span>  퇴사구분</span>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='104089' mdef='직군'/></th>
						<td>
							<select id="searchWorkType" name="searchWorkType"" multiple></select>
							<input type="hidden" id="workType" name="workType" value=""/>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='104011' mdef='성별'/></th>
						<td>
							<select id="searchSexType" name="searchSexType"" multiple></select>
							<input type="hidden" id="sexType" name="sexType" value=""/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" >
		<colgroup>
			<col width="55%" />
			<col width="*" />
		</colgroup>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td style="height: 350px;">
				<span id="chart1" >
					<script type="text/javascript"> createIBChart("myChart1", "100%", "400px"); </script>
				</span>
			</td>
			<td style="height: 350px;">
				<span id="chart2" >
					<script type="text/javascript"> createIBChart("myChart2", "100%", "400px"); </script>
				</span>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
