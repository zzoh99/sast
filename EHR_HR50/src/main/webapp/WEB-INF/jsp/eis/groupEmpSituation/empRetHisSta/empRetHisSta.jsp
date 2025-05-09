<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> 
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchart.js" type="text/javascript"></script>
<script src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchartinfo.js" type="text/javascript"></script>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">
var result1;
var result2;
	$(function() {
        $("#searchYyyy").val("<%=DateUtil.getThisYear()%>") ;//현재년월 세팅
        
        $("#searchYyyy").keyup(function() {
            makeNumber(this,'A');
        })
        $("#searchYyyy").bind("keyup",function(event){
            if( event.keyCode == 13){
            	CallChart1();
                $(this).focus();
            }
        });
        
		CallChart1();
	});
	
	function CallChart1()
	{
		// 차트 Copyright 설정
		
		//차트 타입 지정
		//myChart1.SetDefaultSeriesType(IBChartType.COLUMN);
		//myChart1.SetLegend(false) ;
		//차트 데이터 지정
		//연령별 데이터
		$("#paYnVal").val($("#paYn").is(":checked")==true?"Y":"");
		result1 = ajaxCall("${ctx}/EmpRetHisSta.do?cmd=getEmpRetHisStaList2",$("#srchFrm").serialize(),false);
		var interval = -1;
		 var $timer = $("#timer");
         interval = setInterval(function() {
        	 drawChartForAnime1(result1) ;
        	 clearInterval(interval);
         },400);
	}
	

	function drawChartForAnime1(result1) {
		var Yaxis = myChart2.GetYAxis(0);
		Yaxis.SetTickInterval(500);
		Yaxis.SetAxisTitle({Enabled:true, Text:"인원(명)"});
		//myChart2.setPlot({PointPlacement:"on"});
		var plot = new LinePlotOptions();
		plot.SetStacking(null);
		plot.SetDataLabels(true,IBAlign.CENTER,0,-20,'#333333');
		myChart2.SetColumnPlotOptions(plot);
		myChart2.SetDefaultSeriesType(IBChartType.COLUMN);
		
		var pieChartTitle = '인원현황' ;
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
		
		var chkCnt = 0;
		
		for(var i = 0; i < result1["DATA"].length; i++) {
			if(result1["DATA"][i]["cnt"] == "0") continue ;
			
			if(chkCnt>0){
               data +=      "                , {AXISLABEL:'"+result1["DATA"][i]["codeNm"]+"', " ;
            }else{
               data +=      "                 {AXISLABEL:'"+result1["DATA"][i]["codeNm"]+"', " ;
            }
			
			data += 		"					  SERIES:[";
			data += 		"					          { LEGENDLABEL:'총인원(남자)', STACK:'ss', POINTLABEL:'', VALUE:"+result1["DATA"][i]["mCnt"]+"}";
			data += 		"					          ,{ LEGENDLABEL:'총인원(여자)', STACK:'ssa', POINTLABEL:'', VALUE:"+result1["DATA"][i]["wCnt"]+"}";
			data += 		"					          ,{ LEGENDLABEL:'총인원', STACK:'ss', POINTLABEL:'', VALUE:"+result1["DATA"][i]["cnt"]+"}";
			data += 		"					          ,{ LEGENDLABEL:'입사자', STACK:'zz', POINTLABEL:'', VALUE:"+result1["DATA"][i]["enterCnt"]+"}";
			data += 		"					          ,{ LEGENDLABEL:'퇴사자', STACK:'zzz', POINTLABEL:'', VALUE:"+result1["DATA"][i]["enterCnt2"]+"}";
			data += 		"					          ,{ SERIESTYPE: 'line',LEGENDLABEL:'총인원', STACK:'zzz', POINTLABEL:'', VALUE:"+result1["DATA"][i]["cnt"]+"}";
			data += 		"				 			 ] ";
			
			
			data +=      "                    } ";
            
            chkCnt++;
		}
		
		data += 		"				 ] ";
		data += 		"	  }";
		data += 		"}";
		data += 	"}";
		//myChart2.SetDefaultSeriesType(IBStacking.NORMAL);
		//myChart2.SetPlotOptions({ Column:{ Stacking:true } }); 
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
		
		//$("#jikgubCd").val(($("#searchJikgubCd").val()==null?"":getMultiSelect($("#searchJikgubCd").val())));
		//$("#workType").val(($("#searchWorkType").val()==null?"":getMultiSelect($("#searchWorkType").val())));
		//$("#manageCd").val(($("#searchManageCd").val()==null?"":getMultiSelect($("#searchManageCd").val())));
		//$("#jikweeCd").val(($("#searchJikweeCd").val()==null?"":getMultiSelect($("#searchJikweeCd").val())));
		
		
		//CallChart1() ;
		//CallChart2() ;
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
						<th><tit:txt mid='103774' mdef='기준년도 '/></th>
				        <td>
				             <input class="text w70 center" type="text" id=searchYyyy name="searchYyyy" size="10" maxlength="9">
				             
				        </td>
						<th>파견자포함</th>
						<td>
							<input id="paYn" name="paYn" type="checkbox" style="vertical-align:middle;"/>
							<input type="hidden" id="paYnVal" name="paYnVal">
							<a href="javascript:CallChart1();"        class="button authR"><tit:txt mid='104081' mdef='조회'/></a>
						</td>						        
					</tr>
				</table>										
			</div>
		</div>
	</form>
	
	
	<table class="sheet_main">
	    <tr height="10">
	    </tr>
        <tr>
			<td style="height: 450px;">
				<span id="chart1" style="display: block;">
					<script type="text/javascript"> createIBChart("myChart2", "100%", "450px"); </script>
				</span>
			</td>
        </tr>
    </table>
	
	
	<%-- 
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" >
		<colgroup>
			<col width="100%" />
<!-- 			<col width="*" /> -->
		</colgroup>
<!-- 		<tr><td colspan="2">&nbsp;</td></tr> -->
		<tr><td >&nbsp;</td></tr>
		<tr>
			<td style="height: 500px;">
				<span id="chart1" style="display: block;">
					<script type="text/javascript"> createIBChart("myChart2", "100%", "500px"); </script>
				</span>
			</td>
		</tr>
	</table>
	--%>
</div>
</body>
</html>
