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
var myChart2Data = null;
var chartType = "empType";
	$(function() {
		$("#searchYmd").mask("1111-11-11");
		$("#searchYmd").datepicker2({ymdonly:true, onReturn:function(){initSearchCombo();}});
		$("#searchYmd").val("<%=DateUtil.getDateTime("yyyy-MM-dd")%>") ;//현재년월 세팅
		$("#searchOrgNm, #searchYmd").bind("keyup",function(event){
			if( event.keyCode == 13){ searchAllChart(); $(this).focus(); }
		});
		//$("#searchOrgCd").val("0") ;

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

		//라디오클릭
		$("input[id='chartType']").click(function(){
			if($(this).val() == "empType") {
				chartType = "empType";
			} else {
				chartType = "workY";
			}
		});

		ChartDesign1();
		ChartDesign2();

		searchAllChart() ;
	});

	// 콤보박스 셋팅
	function initSearchCombo() {
		let baseSYmd = $("#searchYmd").val();
		var addParam = "&enterCd="+$("#groupEnterCd").val();

		//직위
		var searchJikweeCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList" + addParam,"H20030", baseSYmd), "");
		$("#searchJikweeCd").html(searchJikweeCd[2]);
		$("#searchJikweeCd").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});
		
		//직급
		var searchJikgubCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList" + addParam,"H20010", baseSYmd), "");
		$("#searchJikgubCd").html(searchJikgubCd[2]);
		$("#searchJikgubCd").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});

		//직책
		var searchJikchakCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList" + addParam,"H20020", baseSYmd), "");
		$("#searchJikchakCd").html(searchJikchakCd[2]);
		$("#searchJikchakCd").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:100
		});

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
		myChart1.SetMainTitle({Enabled:true, Text:"성/연령별", FontWeight:"bold", Color:"#15498B"});

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
		result1 = ajaxCall("${ctx}/MngYearGrpSta.do?cmd=getMngYearGrpStaList2",$("#srchFrm").serialize(),false);
        var interval = -1;
		 var $timer = $("#timer");
         interval = setInterval(function() {
        	 drawChartForAnime1(result1) ;
        	 clearInterval(interval);
         },400);
	}

	function drawChartForAnime1(result1) {
		var pieChartTitle = "사원구분별" ;

		if(result1["DATA"].length == 0){
			result1["DATA"] = [{codeNm:0, perCnt:0, cnt:0}];
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
			data += 		"				  {AXISLABEL:'', " ;
			data += 		"					  SERIES:[{ LEGENDLABEL:'인원', POINTLABEL:'"+result1["DATA"][i]["codeNm"]+"("+result1["DATA"][i]["perCnt"]+"%)"+"', VALUE:"+result1["DATA"][i]["cnt"]+"}";
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
		Yaxis.SetTickInterval(50);
		Yaxis.SetMax(900);
		Yaxis.SetAxisTitle({Enabled:false, Text:""});

		var Xaxis = myChart2.GetXAxis(0);
		Xaxis.SetGridLineWidth(0.5);
		Xaxis.SetGridLineColor("#C4C9CD");
		Xaxis.SetGridLineDashStyle(IBDashStyle.SOLID);
		Xaxis.SetLineColor("#9BA3A5");
		Xaxis.SetMinorTickColor("#7C7C7E");
		Xaxis.SetTickColor("#7C7C7E");
		var SubTitle = {Align: IBAlign.RIGHT};
		myChart2.SetSubTitle(SubTitle);

		myChart2.SetLegend({Align:IBAlign.CENTER, Valign:IBVerticalAlign.BOTTOM, Layout:IBLayout.HORIZONTAL});
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
		//차트 데이터 지정
		var avgTitle = ajaxCall("${ctx}/MngYearGrpSta.do?cmd=getMngYearGrpStaAvgAttYear",$("#srchFrm").serialize(),false);

		var result2 ;
		result2 = ajaxCall("${ctx}/MngYearGrpSta.do?cmd=getMngYearGrpStaList1",$("#srchFrm").serialize(),false);
        var interval = -1;
		 var $timer = $("#timer");
         interval = setInterval(function() {
        	 drawChartForAnime2(result2, avgTitle) ;
        	 clearInterval(interval);
         },400);

	}
	function drawChartForAnime2(result2, avgTitle) {

		var pieChartTitle = '근속년수별' ;

		if(result2["DATA"].length == 0){
			result2["DATA"] = [{codeNm:0, perCnt:0, cnt:0}];
			avgTitle["DATA"] = [{wkpAvgY:0, wkpAvgM:0}];
		}

		var data = "{";
		data += 		"IBCHART: {";
		data += 		"BACKCOLOR: '#FFFFFF',";
		data += 		"BORDERWIDTH: '1',";
		data += 		"TITLE: '"+pieChartTitle+" (평균근속년수  : "+avgTitle["DATA"][0]["wkpAvgY"]+"년 "+avgTitle["DATA"][0]["wkpAvgM"]+"개월)',";
		//data += 		"SUBTITLE: '평균 근속년수 : "+avgTitle["DATA"][0]["wkpAvgY"]+"년 "+avgTitle["DATA"][0]["wkpAvgM"]+"개월',";
		data += 		"ETCDATA: [ {KEY:'sname', VALUE:'홍길동'},";
		data += 		"			{KEY:'age',   VALUE:'20'}";
		data += 		"		  ],";
		data += 		"DATA: {" ;
		data += 		"		POINTSET:[" ;
		myChart2Data = new Array();
		for(var i = 0; i < result2["DATA"].length; i++) {
			if(result2["DATA"][i]["cnt"] == "0") continue ;
			myChart2Data.push(result2["DATA"][i]);
			data += 		"				  {AXISLABEL:'', " ;
			data += 		"					  SERIES:[{ LEGENDLABEL:'인원', POINTLABEL:'"+result2["DATA"][i]["codeNm"]+"<br>("+result2["DATA"][i]["perCnt"]+"%)', VALUE:"+result2["DATA"][i]["cnt"]+"}";
			data += 		"				 			 ] ";
			if(i == result2["DATA"].length-1 || ( i+1 <= result2["DATA"].length && result2["DATA"][i+1]["cnt"] == "0" ) ) {
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
        	if(!isPopup()) {return;}
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

		$("#jikweeCd").val(($("#searchJikweeCd").val()==null?"":getMultiSelect($("#searchJikweeCd").val())));
		$("#jikgubCd").val(($("#searchJikgubCd").val()==null?"":getMultiSelect($("#searchJikgubCd").val())));
		$("#workType").val(($("#searchWorkType").val()==null?"":getMultiSelect($("#searchWorkType").val())));
		$("#manageCd").val(($("#searchManageCd").val()==null?"":getMultiSelect($("#searchManageCd").val())));
		$("#jikchakCd").val(($("#searchJikchakCd").val()==null?"":getMultiSelect($("#searchJikchakCd").val())));

		CallChart1() ;
		CallChart2() ;
	}

	function downChart(){
	 	if(chartType == "empType"){
	 		myChart1.Down2Image({FileName:"EmptypeChartImage", Type:IBExportType.JPEG, Width:800, Url:"/common/plugin/IBLeaders/Sheet/jsp/Down2Image.jsp"});
	 	}else if(chartType == "workY"){
	 		myChart2.Down2Image({FileName:"WorkyearChartImage", Type:IBExportType.JPEG, Width:800, Url:"/common/plugin/IBLeaders/Sheet/jsp/Down2Image.jsp"});
	 	}
	}

	function myChart1_OnPointClick(Index, X , Y){
		openEmployeePopup({"manageCd":myChart1Data[X]["code"]});
	}
	function myChart2_OnPointClick(Index, X , Y){
		openEmployeePopup({"wkpCode":myChart2Data[X]["code"]});
	}
	function openEmployeePopup(data){
		var url 	= "/Popup.do?cmd=viewCommonEmployeeLayer";
		var title 	= "<tit:txt mid='schEmployee' mdef='사원조회'/>";
		var w = 800;
		var h = 600;
		var p = {searchYmd:$("input[name=searchYmd]").val().replace(/-/g,''),
				 jikweeCdL :$("input[name=jikweeCd]").val(),
				 jikgubCdL :$("input[name=jikgubCd]").val(),
				 workTypeL :$("input[name=workType]").val(),
				 manageCdL :$("input[name=manageCd]").val(),
				 jikchakCdL:$("input[name=jikchakCd]").val(),
				 orgCd     :$("input[name=searchOrgCd]").val(),
				 searchType:$("input[name=searchType]").val(),
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
<div class="wrapper" style="height:100vh; overflow-y:auto;">
	<form id="srchFrm" name="srchFrm" >
		<input id="searchOrgCd" name ="searchOrgCd" type="hidden"/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>기준일자</th>
				        <td>
				            <input class="text w70 center" type="text" id="searchYmd" name="searchYmd" size="10" maxlength="9">
				        </td>
				        <th class="spEnterCombo hide">회사</th>
						<td class="spEnterCombo hide">
							<select id="groupEnterCd" name="groupEnterCd" class="w150"></select>
						</td>
						<th><tit:txt mid='104295' mdef='소속 '/></th>
  						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text readonly" readOnly style="width:148px"/>
							<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
							<input type="checkbox" class="checkbox" id="searchType" name="searchType" onclick="javascript:searchAllChart();" style="vertical-align:middle;" checked="checked"/>
							<label for="searchType"><strong>&nbsp;<tit:txt mid='104304' mdef='하위조직포함'/></strong></label>
						</td>
						<td><btn:a href="javascript:searchAllChart()" id="btnSearch" css="btn dark" mid='search' mdef="조회"/></td>
						<td><a href="javascript:downChart()" id="btnDown" class="btn outline_gray"><tit:txt mid='113874' mdef='이미지다운'/></a></td>
						<td>
							<input type="radio" name="chartType" id="chartType" value="empType" checked/><span>  사원구분</span>
							<input type="radio" name="chartType" id="chartType" value="workY"/><span>  근속년수</span>
						</td>
						<!-- <td> <span>소속  </span>  <input id="searchOrgNm" name="searchOrgNm" type="text" class="text w150" /> </td> -->
					</tr>
					<tr>
						<th style="padding-left:16.5pt"><tit:txt mid='104104' mdef='직위'/></th>
						<td colspan="5">
							<select id="searchJikweeCd" name="searchJikweeCd" multiple ></select>
							<input type="hidden" id="jikweeCd" name="jikweeCd" value=""/>
						</td>
					</tr>
					<tr>
						<th style="padding-left:16.5pt"><tit:txt mid='104471' mdef='직급'/></th>
						<td colspan="5">
							<select id="searchJikgubCd" name="searchJikgubCd" multiple ></select>
							<input type="hidden" id="jikgubCd" name="jikgubCd" value=""/>
						</td>
					</tr>
					<tr>
						<th style="padding-left:16.5pt"><tit:txt mid='103785' mdef='직책'/></th>
						<td colspan="5">
							<select id="searchJikchakCd" name="searchJikchakCd" multiple ></select>
							<input type="hidden" id="jikchakCd" name="jikchakCd"/>
						</td>
					</tr>
					<tr>
						<th style="padding-left:16.5pt"><tit:txt mid='104089' mdef='직군'/></th>
						<td colspan="5">
							<select id="searchWorkType" name="searchWorkType"" multiple></select>
							<input type="hidden" id="workType" name="workType" value=""/>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='103784' mdef='사원구분'/></th>
						<td colspan="5">
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
			<col width="55%" />
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
</div>
</body>
</html>
