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
	$(function() {
		$("#searchYmd").mask("1111-11-11");
		$("#searchYmd").datepicker2({ymdonly:true});
		$("#searchYmd").val("<%=DateUtil.getDateTime("yyyy-MM-dd")%>") ;//현재년월 세팅
		$("#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		$("#searchOrgCd").val("0") ;

		ChartDesign1();
		ChartDesign2();

		searchAllChart() ;
	});
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
		//myChart1.SetBorderColor("#84888B");
		myChart1.SetMainTitle({Enabled:true, Text:"", FontWeight:"bold", Color:"#15498B"});

		var Yaxis = myChart1.GetYAxis(0);
		Yaxis.SetGridLineDashStyle(IBDashStyle.SOLID);
		Yaxis.SetGridLineColor("#C4C9CD");
		Yaxis.SetGridLineWidth(0.5);
		Yaxis.SetLineColor("#9BA3A5");
		Yaxis.SetMinorGridLineWidth(0);
		Yaxis.SetMinorTickInterval(25);
		Yaxis.SetMinorTickLength(2);
		Yaxis.SetMinorTickWidth(1);
		Yaxis.SetMinorTickColor("#7C7C7E");
		Yaxis.SetTickColor("#7C7C7E");
		Yaxis.SetTickInterval(50);
		Yaxis.SetMax(900);
		Yaxis.SetAxisTitle({Enabled:false, Text:""});

		var Xaxis = myChart1.GetXAxis(0);
		Xaxis.SetGridLineWidth(0.5);
		Xaxis.SetGridLineColor("#C4C9CD");
		Xaxis.SetGridLineDashStyle(IBDashStyle.SOLID);
		Xaxis.SetLineColor("#9BA3A5");
		Xaxis.SetMinorTickColor("#7C7C7E");
		Xaxis.SetTickColor("#7C7C7E");
		//Xaxis.SetLabel({Rotation:-30,x:-10,y:20});

		var plotPie = new PiePlotOptions();
		// 파이와 라벨의 거리, 두께, 색, padding, 부드러운 처리
		plotPie.SetDataLabelsConnector(18,1,'',5,true);
		myChart1.SetPiePlotOptions(plotPie);

		myChart1.SetLegend({Align:IBAlign.CENTER, Valign:IBVerticalAlign.BOTTOM, Layout:IBLayout.HORIZONTAL});
		var tooltip = new ToolTip();
		myChart1.SetToolTip({Enabled:true, Shadow:true, Formatter:ToolTipFormatter1, Color:'#000000', FontSize:'13px',FontWeight:'bold'});
	}

	function ToolTipFormatter1(){
		return '<span style="color:#040087;">' + replaceAll(this.point.name,'<br>', '') + '</span><br />' + this.series.name + ' : <b>' + this.y + '</b>' ;
	}

	function CallChart1(Type)
	{
		myChart1.RemoveAll();
		//차트 타입 지정
		myChart1.SetDefaultSeriesType(IBChartType.PIE);
		myChart1.SetLegend(false) ;
		//차트 데이터 지정
		var result1 ;
		result1 = ajaxCall("${ctx}/SchGrpSta.do?cmd=getSchGrpStaList2&searchYmd="+$("#searchYmd").val()+"&searchOrgCd="+$("#searchOrgCd").val()+"&gubun=2",queryId="getSchGrpStaList2",false);
        var interval = -1;
		 var $timer = $("#timer");
         interval = setInterval(function() {
        	 drawChartForAnime1(result1) ;
        	 clearInterval(interval);
         },400);
	}

	function drawChartForAnime1(result1) {
		var pieChartTitle = '최종학력별 인원비율' ;
		var data = "{";
		data += 		"IBCHART: {";
		data += 		"BACKCOLOR: '#FFFFFF',";
		data += 		"BORDERWIDTH: '1',";
		data += 		"TITLE: '"+pieChartTitle+"',";
		//data += 		"SUBTITLE: '통계',";
		data += 		"ETCDATA: [ {KEY:'sname', VALUE:'홍길동'},";
		data += 		"			{KEY:'age',   VALUE:'20'}";
		data += 		"		  ],";
		data += 		"DATA: {" ;
		data += 		"		POINTSET:[" ;
		for(var i = 0; i < result1["DATA"].length; i++) {
			if(result1["DATA"][i]["cnt"] == "0") continue ;
			data += 		"				  {AXISLABEL:'', " ;
			data += 		"					  SERIES:[{ LEGENDLABEL:'인원', POINTLABEL:'"+result1["DATA"][i]["codeNm"]+"<br>("+result1["DATA"][i]["perCnt"]+"%)', VALUE:"+result1["DATA"][i]["cnt"]+"}";
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
		Yaxis.SetGridLineDashStyle(IBDashStyle.SOLID);
		Yaxis.SetGridLineColor("#C4C9CD");
		Yaxis.SetGridLineWidth(0.5);
		Yaxis.SetLineColor("#9BA3A5");
		Yaxis.SetMinorGridLineWidth(0);
		Yaxis.SetMinorTickInterval(25);
		Yaxis.SetMinorTickLength(2);
		Yaxis.SetMinorTickWidth(1);
		Yaxis.SetMinorTickColor("#7C7C7E");
		Yaxis.SetTickColor("#7C7C7E");
		Yaxis.SetTickInterval(10);
		//Yaxis.SetMax(900);
		Yaxis.SetAxisTitle({Enabled:false, Text:""});

		var Xaxis = myChart2.GetXAxis(0);
		Xaxis.SetGridLineWidth(0.5);
		Xaxis.SetGridLineColor("#C4C9CD");
		Xaxis.SetGridLineDashStyle(IBDashStyle.SOLID);
		Xaxis.SetLineColor("#9BA3A5");
		Xaxis.SetMinorTickColor("#7C7C7E");
		Xaxis.SetTickColor("#7C7C7E");
		Xaxis.SetAxisTitle({Enabled:false, Text:""});

		//var Label = {Align:IBAlign.LEFT, Enabled:true, Rotation:90, Step:1};
		//Xaxis.SetLabel(Label);

		var plot = new ColumnPlotOptions();
		plot.SetStacking(null);
		plot.SetDataLabels(true,IBAlign.CENTER,0,-3,'#333333');
		myChart2.SetColumnPlotOptions(plot);

		myChart2.SetLegend({Enabled:false, Align:IBAlign.CENTER, Valign:IBVerticalAlign.BOTTOM, Layout:IBLayout.HORIZONTAL});
		var tooltip = new ToolTip();
		myChart2.SetToolTip({Enabled:true, Shadow:true, Formatter:ToolTipFormatter2, Color:'#000000', FontSize:'13px',FontWeight:'bold'});
	}

	function ToolTipFormatter2(){
		//return '<span style="color:#040087;">' + myChart2.xAxes[0].categories[this.point.x] + '</span><br/>' + this.series.name + ' : <b>' + this.y + '</b>' ;
		return '<span style="color:#040087;">' + replaceAll(this.point.name,'<br>', '') + '</span><br />' + this.series.name + ' : <b>' + this.y + '</b>' ;

	}

	function CallChart2(Type)
	{
		myChart2.RemoveAll();
		//차트 타입 지정
		myChart2.SetDefaultSeriesType(IBChartType.PIE);
		myChart2.SetLegend(false) ;
		//차트 데이터 지정
		var result2 ;
		result2 = ajaxCall("${ctx}/SchGrpSta.do?cmd=getSchGrpStaList2&searchYmd="+$("#searchYmd").val()+"&searchOrgCd="+$("#searchOrgCd").val()+"&gubun=1",queryId="getSchGrpStaList2",false);

		var tot = 0 ;
		for(var i = 0; i < result2["DATA"].length; i++) { tot = tot + result2["DATA"][i]["cnt"] ; }
		var calc = ajaxCall("${ctx}/SchGrpSta.do?cmd=getSchGrpStaListEtc&searchCnt="+tot,queryId="getSchGrpStaListEtc",false);

		$("#totalCnt").text( calc["DATA"][0]["mCnt"] ) ;
		$("#totalPerCnt").text( calc["DATA"][0]["perCnt"] ) ;
		var interval = -1;
		 var $timer = $("#timer");
         interval = setInterval(function() {
        	 drawChartForAnime2(result2) ;
        	 clearInterval(interval);
         },400);

	}
	function drawChartForAnime2(result2) {

		var pieChartTitle = '주요대학교별 인원현황' ;
		var data = "{";
		data += 		"IBCHART: {";
		data += 		"BACKCOLOR: '#FFFFFF',";
		data += 		"BORDERWIDTH: '1',";
		data += 		"TITLE: '"+pieChartTitle+"',";
		//data += 		"SUBTITLE: '통계',";
		data += 		"ETCDATA: [ {KEY:'sname', VALUE:'홍길동'},";
		data += 		"			{KEY:'age',   VALUE:'20'}";
		data += 		"		  ],";
		data += 		"DATA: {" ;
		data += 		"		POINTSET:[" ;
		for(var i = 0; i < result2["DATA"].length; i++) {
			if(result2["DATA"][i]["cnt"] == "0") continue ;
			data += 		"				  {AXISLABEL:'"+result2["DATA"][i]["codeNm"]+"', " ;
			data += 		"					  SERIES:[{ LEGENDLABEL:'인원', POINTLABEL:'"+result2["DATA"][i]["codeNm"]+"<br>("+result2["DATA"][i]["perCnt"]+"%)', VALUE:"+result2["DATA"][i]["cnt"]+"}";
			data += 		"				 			 ] ";
			if(i == result2["DATA"].length || ( i+1 <= result2["DATA"].length && result2["DATA"][i+1]["cnt"] == "0" ) ) {
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
			var args    = new Array();
			var rv = openPopup("/Popup.do?cmd=orgTreePopup", args, "740","520");
            if(rv!=null){
				$("#searchOrgCd").val(rv["orgCd"]);
				$("#searchOrgNm").val(rv["orgNm"]);
				//최상위 레벨 구분 : 최상위 레벨이면 0
				if(rv["priorOrgCd"] == "0") {
				        $("#searchOrgCd").val("0");
				}
				searchAllChart() ;
			}
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

	function searchAllChart() {
		CallChart1() ;
		CallChart2() ;
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
						<th class="title"><tit:txt mid='104004' mdef='검색일자'/></th>
				        <td class="">
				            <input class="text w70 center" type="text" id="searchYmd" name="searchYmd" size="10" maxlength="9">
				        </td>
				        <th><tit:txt mid='104295' mdef='소속 '/></th>
  						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:148px"/>
							<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<td><a href="javascript:searchAllChart()" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" >
		<colgroup>
			<col width="45%" />
			<col width="" />
		</colgroup>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td>
				<script type="text/javascript"> createIBChart("myChart1", "100%", "100%"); </script>
			</td>
			<td>
				<script type="text/javascript"> createIBChart("myChart2", "100%", "100%"); </script>
			</td>
		</tr>
	</table>
	<table border="0" class="sheet_main">
		<tr>
			<td class="right">
				주요대학교 외 : <span id="totalCnt" class="right"></span>명
				(<span id="totalPerCnt"></span>%)
			</td>
		</tr>
	</table>

</div>
</body>
</html>
