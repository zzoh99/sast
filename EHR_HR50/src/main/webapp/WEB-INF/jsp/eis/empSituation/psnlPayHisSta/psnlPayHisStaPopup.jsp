<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114608' mdef='개인별연봉 변동추이 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchart.js" type="text/javascript"></script>
<script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchartinfo.js" type="text/javascript"></script>

<script type="text/javascript">
var openSheet = null;
var sRow = null;
var p = eval("${popUpStatus}");

var titleNm ;
	$(function(){
		var arg = p.window.dialogArguments;
		if( arg != undefined ) {
			openSheet = arg["sheet1"];
		}else{
			if(p.popDialogSheet("sheet1")!=null)		openSheet  	= p.popDialogSheet("sheet1");
		}
		
		var sRow = openSheet.GetSelectRow();
		
		$("#searchYear"    ).val(openSheet.GetCellValue(sRow,"year"    ));
		$("#searchOrgCd"   ).val(openSheet.GetCellValue(sRow,"orgCd"   ));
		$("#searchJikweeCd").val(openSheet.GetCellValue(sRow,"jikweeCd"));
		
		titleNm = openSheet.GetCellValue(sRow,"orgNm") + "("+openSheet.GetCellValue(sRow,"jikweeNm")+")"
		$("#titleNm").text(titleNm); 
		
		ChartDesign1();
		CallChart1();
		
		$(".close").click(function(){
			p.self.close(); 
		});
		
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
		myChart1.SetMainTitle({Enabled:true, Text:"", FontWeight:"bold", Color:"#15498B"});

		var Yaxis = myChart1.GetYAxis(0);
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
		Yaxis.SetTickInterval(1000);
		Yaxis.SetAxisTitle({Enabled:false, Text:""});
		
		var Xaxis = myChart1.GetXAxis(0);
		Xaxis.SetGridLineWidth(0.5);
		Xaxis.SetGridLineColor("#C4C9CD");
		Xaxis.SetGridLineDashStyle(IBDashStyle.SOLID);
		Xaxis.SetLineColor("#9BA3A5");
		Xaxis.SetMinorTickColor("#7C7C7E");
		Xaxis.SetTickColor("#7C7C7E");
		Xaxis.SetTickInterval(1);
		var Label = {StaggerLines:3, Step:1};
		Xaxis.SetLabel(Label);
		
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
		var param1 = $("#srchFrm").serialize();
		
		result1 = ajaxCall("${ctx}/PsnlPayHisSta.do?cmd=getPsnlPayHisStaPopupList",$("#srchFrm").serialize(),false);
        var interval = -1;
		 var $timer = $("#timer");
         interval = setInterval(function() {
        	 drawChartForAnime1(result1) ;
        	 clearInterval(interval);
         },400);
	}

	function drawChartForAnime1(result1) {
		var pieChartTitle = '개인별연봉 변동추이 ';
		if(result1["DATA"].length == 0) {
			alert('데이터가 존재하지 않습니다.') ;
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
		for(var i = 0; i < result1["DATA"].length; i++) {
			//if(result1["DATA"][i]["cnt"] == "0" && result2["DATA"][i]["cnt"] == "0" && result3["DATA"][i]["cnt"] == "0") continue ;
			data += 		"				  {AXISLABEL:'"+result1["DATA"][i]["name"]+"', " ;
//			data += 		"					  SERIES:[{ LEGENDLABEL:'"+minusYmd2+"', POINTLABEL:'', VALUE:"+result3["DATA"][i]["cnt"]+"},{ LEGENDLABEL:'"+minusYmd+"', POINTLABEL:'', VALUE:"+result2["DATA"][i]["cnt"]+"}, { LEGENDLABEL:'"+$("#searchYmd").val()+"', POINTLABEL:'', VALUE:"+result1["DATA"][i]["cnt"]+"}";
			data += 		"					  SERIES:[";
			data += 		"					          { LEGENDLABEL:'"+result1["DATA"][i]["titleMon1"] +"', POINTLABEL:'', VALUE:"+result1["DATA"][i]["mon1"]+"},";
			data += 		"					          { LEGENDLABEL:'"+result1["DATA"][i]["titleMon2"] +"', POINTLABEL:'', VALUE:"+result1["DATA"][i]["mon2"]+"},";
			data += 		"					          { LEGENDLABEL:'"+result1["DATA"][i]["titleMon3"] +"', POINTLABEL:'', VALUE:"+result1["DATA"][i]["mon3"]+"},";
			data += 		"					          { LEGENDLABEL:'"+result1["DATA"][i]["titleMon4"] +"', POINTLABEL:'', VALUE:"+result1["DATA"][i]["mon4"]+"} ";
			data += 		"				 			 ] ";
			if(i == result1["DATA"].length-1){
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
	function searchAllChart() {
		CallChart1() ;
	}
    
</script>
</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li><tit:txt mid='114609' mdef='개인별연봉 변동추이'/></li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
                <input type="hidden" id="searchYear"     name="searchYear"     /> 
                <input type="hidden" id="searchOrgCd"    name="searchOrgCd"    />
                <input type="hidden" id="searchJikweeCd" name="searchJikweeCd" /> 
	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="titleNm" name="titleNm" class="txt"></li>
				</ul>
				</div>
			</div>
			<span id="chart1" style="display:block;">
				<script type="text/javascript"> createIBChart("myChart1", "100%", "550px"); </script>
			</span>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>
