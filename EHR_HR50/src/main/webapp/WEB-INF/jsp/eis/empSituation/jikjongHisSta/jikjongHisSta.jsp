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
var myChart1Data = null;
var myChart1InitData = function(){
	return [[],[],[]];
}
	$(function() {
		$("#searchYmd").mask("1111-11-11");
		$("#searchYmd").datepicker2({ymdonly:true, onReturn:function(){initSearchCombo();}});
		$("#searchYmd").val("<%=DateUtil.getDateTime("yyyy-MM-dd")%>") ;//현재년월 세팅
		$("#searchOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ searchAllChart(); $(this).focus(); }
		});
		$("#searchOrgCd").val("0") ;

		if("${ssnEnterAllYn}" == "Y"){
			$(".spEnterCombo").removeClass("hide");
		}

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

		//구간월수 세팅
		var stdMonthsList = [
			  {code:1, codeNm:1}
			, {code:2, codeNm:2}
			, {code:3, codeNm:3}
			, {code:6, codeNm:6}
			, {code:9, codeNm:9}
			, {code:12, codeNm:12}
		];
		$("#stdMonths").html(convCode(stdMonthsList, "")[2]).val("3").bind("change", function() {
			searchAllChart();
		});

		ChartDesign1();

		CallChart1();
	});

	// 콤보박스 셋팅
	function initSearchCombo() {
		let baseSYmd = $("#searchYmd").val();
		var addParam = "&enterCd="+$("#groupEnterCd").val();

		//직군
		var searchWorkType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList" + addParam,"H10050", baseSYmd), "");
		$("#searchWorkType").html(searchWorkType[2]);
		$("#searchWorkType").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});

		//사원구분
		var searchManageCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList" + addParam,"H10030", baseSYmd), "");
		$("#searchManageCd").html(searchManageCd[2]);
		$("#searchManageCd").select2({
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
		var minusYmd = dateFormatToString(add_months($("#searchYmd").val(), $("#stdMonths").val()*(-1)), "-");
		var minusYmd2 = dateFormatToString(add_months($("#searchYmd").val(), $("#stdMonths").val()*(-2)), "-");
		var param1 = $("#srchFrm").serialize();
		result1 = ajaxCall("${ctx}/JikjongHisSta.do?cmd=getJikjongHisStaList", $("#srchFrm").serialize(), false);
		result2 = ajaxCall("${ctx}/JikjongHisSta.do?cmd=getJikjongHisStaList", param1.replace($("#searchYmd").val(), minusYmd ), false);
		result3 = ajaxCall("${ctx}/JikjongHisSta.do?cmd=getJikjongHisStaList", param1.replace($("#searchYmd").val(), minusYmd2 ), false);
        var interval = -1;
		var $timer = $("#timer");
        interval = setTimeout(function() { drawChartForAnime1(result1, result2, result3, minusYmd, minusYmd2) ;}, 400);
	}

	function drawChartForAnime1(result1, result2, result3, minusYmd, minusYmd2) {
		var pieChartTitle = "직종별 인원변동추이" ;
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
		myChart1Data = null;
		myChart1Data = myChart1InitData();
		for(var i = 0; i < result1["DATA"].length; i++) {
			var codeNm = result1["DATA"][i]["codeNm"];
			result1Cnt = 0;
			result2Cnt = 0;
			result3Cnt = 0;
			if(result1["DATA"][i]){
				result1Cnt = result1["DATA"][i]["cnt"]||"0";
			}
			if(result2["DATA"][i]){
				result2Cnt = result2["DATA"][i]["cnt"]||"0";
			}
			if(result3["DATA"][i]){
				result3Cnt = result3["DATA"][i]["cnt"]||"0";
			}
			if(codeNm == '' || (result1Cnt == "0" && result1Cnt == "0" && result3Cnt == "0")) continue ;
			myChart1Data[0].push(result3["DATA"][i]);
			myChart1Data[1].push(result2["DATA"][i]);
			myChart1Data[2].push(result1["DATA"][i]);

			data += 		"				  {AXISLABEL:'"+codeNm+"', " ;
			data += 		"					  SERIES:[{ LEGENDLABEL:'"+minusYmd2+"', POINTLABEL:'', VALUE:"+result3Cnt+"},{ LEGENDLABEL:'"+minusYmd+"', POINTLABEL:'', VALUE:"+result2Cnt+"}, { LEGENDLABEL:'"+$("#searchYmd").val()+"', POINTLABEL:'', VALUE:"+result1Cnt+"}";
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
		$("#manageCd").val(($("#searchManageCd").val()==null?"":getMultiSelect($("#searchManageCd").val())));
		CallChart1() ;
	}

	function downChart(){
 		myChart1.Down2Image({FileName:"WorktypeHistImage", Type:IBExportType.JPEG, Width:800, Url:"/common/plugin/IBLeaders/Sheet/jsp/Down2Image.jsp"});
	}
	
	function myChart1_OnPointClick(Index, X , Y){
		var url 	= "/Popup.do?cmd=viewCommonEmployeeLayer";
		var title 	= "<tit:txt mid='schEmployee' mdef='사원조회'/>";
		var w = 800;
		var h = 600;
		var p = {manageCdL : $("input[name=manageCd]").val(),
				 workTypeL : $("input[name=workType]").val(),
				 searchYmd : myChart1Data[Index][X]["searchYmd"],
				 jikjongCd : myChart1Data[Index][X]["code"]};
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
	<form id="paramFrm" name="paramFrm" >
		<input id="searchOrgCd" name ="searchOrgCd" type="hidden"/>
	</form>
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>기준일자</th>
				        <td>
				            <input class="text w70 center" type="text" id="searchYmd" name="searchYmd" size="10" maxlength="9">
				        </td>
				        <th>구간월수</th>
						<td>
							<select id="stdMonths" name="stdMonths" ></select>
						</td>
				        <!--
  						<td><span><tit:txt mid='104295' mdef='소속 '/></span>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:148px"/>
							<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						 -->
						<th class="spEnterCombo hide">회사</th>
						<td class="spEnterCombo hide">
							<select id="groupEnterCd" name="groupEnterCd" class="w150"></select>
						</td>
						<th class="hide">소속</th>
						<td class="hide"><input id="searchOrgNm" name="searchOrgNm" type="text" class="text w150" /></td>
						<td>
							<btn:a href="javascript:searchAllChart()" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
						</td>
						<td><a href="javascript:downChart()" id="btnDown" class="btn outline_gray"><tit:txt mid='113874' mdef='이미지다운'/></a></td>
					</tr>
					<tr>
						<th style="padding-left:16.5pt"><tit:txt mid='104089' mdef='직군'/></th>
						<td colspan="6">
							<select id="searchWorkType" name="searchWorkType" multiple></select>
							<input type="hidden" id="workType" name="workType" value=""/>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='103784' mdef='사원구분'/></th>
						<td colspan="6">
							<select id="searchManageCd" name="searchManageCd"" multiple></select>
							<input type="hidden" id="manageCd" name="manageCd" value=""/>
						</td>
					</tr>
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
