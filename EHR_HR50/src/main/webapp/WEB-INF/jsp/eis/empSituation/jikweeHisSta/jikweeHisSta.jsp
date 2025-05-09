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
		$("#searchYmd").datepicker2({ymdonly:true, onReturn:function(){searchAllChart();}});
		$("#searchYmd").val("<%=DateUtil.getDateTime("yyyy-MM-dd")%>") ;//현재년월 세팅
		$("#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ searchAllChart(); $(this).focus(); }
		});
		$("#searchOrgCd").val("0") ;

		//직위
		var searchJikgubCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "");
		$("#searchJikgubCd").html(searchJikgubCd[2]);
		$("#searchJikgubCd").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});
		//직종
		var searchWorkType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10050"), "");
		$("#searchWorkType").html(searchWorkType[2]);
		$("#searchWorkType").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});
		//사원구분
		var searchManageCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10030"), "");
		$("#searchManageCd").html(searchManageCd[2]);
		$("#searchManageCd").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});

		ChartDesign1();

		CallChart1();
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
		Yaxis.SetTickInterval(50);
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
		var result1, result2, result3 ;
		var minusYmd = ( parseInt($("#searchYmd").val().substr(0,4))-1 ) + $("#searchYmd").val().substr(4,10) ;
		var minusYmd2 = ( parseInt($("#searchYmd").val().substr(0,4))-2 ) + $("#searchYmd").val().substr(4,10) ;
		var param1 = $("#srchFrm").serialize();

		result1 = ajaxCall("${ctx}/JikweeHisSta.do?cmd=getJikweeHisStaList2",$("#srchFrm").serialize(),false);
		result2 = ajaxCall("${ctx}/JikweeHisSta.do?cmd=getJikweeHisStaList2",param1.replace($("#searchYmd").val(),minusYmd ), false);
		result3 = ajaxCall("${ctx}/JikweeHisSta.do?cmd=getJikweeHisStaList2",param1.replace($("#searchYmd").val(),minusYmd2 ), false);
        var interval = -1;
		 var $timer = $("#timer");
         interval = setInterval(function() {
        	 drawChartForAnime1(result1, result2, result3, minusYmd, minusYmd2) ;
        	 clearInterval(interval);
         },400);
	}

	function drawChartForAnime1(result1, result2, result3, minusYmd, minusYmd2) {
		var pieChartTitle = '직위별 인원변동추이' ;
		if(result1["DATA"].length == 0 && result2["DATA"].length == 0 && result3["DATA"].length == 0) {
			alert('해당 기준일자의 데이터가 존재하지 않습니다.') ;
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
			if(result1["DATA"][i]["cnt"] == "0" && result2["DATA"][i]["cnt"] == "0" && result3["DATA"][i]["cnt"] == "0") continue ;
			data += 		"				  {AXISLABEL:'"+result1["DATA"][i]["codeNm"]+"', " ;
			data += 		"					  SERIES:[{ LEGENDLABEL:'"+minusYmd2+"', POINTLABEL:'', VALUE:"+result3["DATA"][i]["cnt"]+"},{ LEGENDLABEL:'"+minusYmd+"', POINTLABEL:'', VALUE:"+result2["DATA"][i]["cnt"]+"}, { LEGENDLABEL:'"+$("#searchYmd").val()+"', POINTLABEL:'', VALUE:"+result1["DATA"][i]["cnt"]+"}";
			data += 		"				 			 ] ";
			if(i == result1["DATA"].length-1 ) {
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
		$("#jikgubCd").val(($("#searchJikgubCd").val()==null?"":getMultiSelect($("#searchJikgubCd").val())));
		$("#workType").val(($("#searchWorkType").val()==null?"":getMultiSelect($("#searchWorkType").val())));
		$("#manageCd").val(($("#searchManageCd").val()==null?"":getMultiSelect($("#searchManageCd").val())));
		CallChart1() ;
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="paramFrm" name="paramFrm" >
		<input id="searchOrgCd" name ="searchOrgCd" type="hidden"/>
	</form>
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<table>
						<tr>
							<th><tit:txt mid='103906' mdef='기준일자 '/></th>
					        <td>
					            <input class="text w70 center" type="text" id="searchYmd" name="searchYmd" size="10" maxlength="9">
					        </td>
					        <!--
	  						<td><span><tit:txt mid='104295' mdef='소속 '/></span>
								<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:148px"/>
								<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
								<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
							</td>
							 -->
							<th><tit:txt mid='104295' mdef='소속 '/></th>
							<td>
								<input id="searchOrgNm" name="searchOrgNm" type="text" class="text w150" /> 
							</td>
							<td><a href="javascript:searchAllChart()" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a></td>
						</tr>
					</table>
					<table>
						<tr>
							<th style="padding-left:16.5pt"><tit:txt mid='104471' mdef='직급'/></th>
							<td colspan="3">
								<select id="searchJikgubCd" name="searchJikgubCd"" multiple ></select>
								<input type="hidden" id="jikgubCd" name="jikgubCd" value=""/>
							</td>
						</tr>
					</table>
					<table>
						<tr>
							<th style="padding-left:16.5pt">직종</th>
							<td colspan="3">
								<select id="searchWorkType" name="searchWorkType"" multiple></select>
								<input type="hidden" id="workType" name="workType" value=""/>
							</td>
						</tr>
					</table>
					<table>
						<tr>
							<th><tit:txt mid='103784' mdef='사원구분'/></th>
							<td colspan="3">
								<select id="searchManageCd" name="searchManageCd"" multiple></select>
								<input type="hidden" id="manageCd" name="manageCd" value=""/>
							</td>
						</tr>
					</table>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" >
		<colgroup>
			<col width="" />
		</colgroup>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td style="height: 350px;">
				<script type="text/javascript"> createIBChart("myChart1", "100%", "100%"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
