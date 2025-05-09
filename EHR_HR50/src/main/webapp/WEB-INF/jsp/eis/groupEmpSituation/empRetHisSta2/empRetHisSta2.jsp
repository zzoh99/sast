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
var result3;
	$(function() {
        $("#searchYyyy").val("<%=DateUtil.getThisYear()%>") ;//현재년월 세팅

        $("#searchYyyy").keyup(function() {
            makeNumber(this,'A');
        })
        $("#searchYyyy").bind("keyup",function(event){
            if( event.keyCode == 13){
            	searchAllChart();
                $(this).focus();
            }
        });

		var enterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAuthEnterCdList&searchGrpCd=${ssnGrpCd}",false).codeList, "");
		$("#searchAuthEnterCd").html(enterCdList[2]);
		$("#searchAuthEnterCd").select2({
			placeholder: "<tit:txt mid='103895' mdef='전체'/>"
			, maximumSelectionSize:500
			//, width : "300px"
		});
		searchAllChart();
	});

	function CallChart1()
	{
		myChart2.RemoveAll();
		myChart2.SetDefaultSeriesType(IBChartType.LINE);
		//myChart2.SetDefaultSeriesType(IBZoomType.X_AND_Y);
		myChart2.SetLegend(false) ;

		result3 = ajaxCall("${ctx}/EmpRetHisSta2.do?cmd=getEmpRetHisSta2List3",$("#srchFrm").serialize(),false);
		var interval = -1;
		 var $timer = $("#timer");
         interval = setInterval(function() {
        	 drawChartForAnime1(result3) ;
        	 clearInterval(interval);
         },400);
	}

	function drawChartForAnime1(result3) {

		var Yaxis = myChart2.GetYAxis(0);
		Yaxis.SetTickInterval(30);
		Yaxis.SetMin(0);
		Yaxis.SetAxisTitle({Enabled:true, Text:"인원(명)"});

		var pieChartTitle = '인원현황' ;
		var data = "{";
		data += 		"IBCHART: {";
		data += 		"BACKCOLOR: '#FFFFFF',";
		data += 		"BORDERWIDTH: '1',";
		//data += 		"ZOOMTYPE: 'X',";
		data += 		"TITLE: '"+pieChartTitle+"',";
		data += 		"ETCDATA: [ {KEY:'sname', VALUE:'홍길동'},";
		data += 		"			{KEY:'age',   VALUE:'20'}";
		data += 		"		  ],";
		data += 		"DATA: {" ;
		data += 		"		POINTSET:[" ;

		var chkCnt = 0;
		for(var i = 0; i < result3["DATA"].length; i++) { // 조회년도 범위 for

            var paYnVal = $("#paYn").is(":checked")==true?"Y":"";
            result1 = ajaxCall("${ctx}/EmpRetHisSta2.do?cmd=getEmpRetHisSta2List2","paYnVal="+paYnVal+"&yyyy="+result3["DATA"][i]["year"]+"&authEnterCd="+$("#authEnterCd").val()+"&searchGrpCd=${ssnGrpCd}",false);
            
            if (result1["DATA"].length > 0 ){
				if(chkCnt>0){
	               data +=      "                , {AXISLABEL:'"+result3["DATA"][i]["year"]+"', " ;
	            }else{
	               data +=      "                 {AXISLABEL:'"+result3["DATA"][i]["year"]+"', " ;
	            }
	
	            data += 		"					  SERIES:[";
				for(var j = 0; j < result1["DATA"].length; j++){ // 해당년도 회사수  for
					if(j>0){
			            data +=      "                , {LEGENDLABEL:'"+result1["DATA"][j]["alias"]+"', VALUE:'"+result1["DATA"][j]["cnt"]+"'}";
			        }else{
			        	data +=      "                 {LEGENDLABEL:'"+result1["DATA"][j]["alias"]+"', VALUE:'"+result1["DATA"][j]["cnt"]+"'}";
			        }
				}
	
				data += 		"				 			 ] "; /// SERIES:[ end 
				data +=      "                    } ";    /// {AXISLABEL end 
	
	            chkCnt++;
			}
		}

		data += 		"				 ] ";
		data += 		"	  }";
		data += 		"}";
		data += 	"}";
		// JSON 문자열을 읽어서 차트의 기본틀을 생성
		myChart2.GetDataJsonString(data);
	}

	function searchAllChart() {

		if($("#searchYyyy").val() == ""){
			alert("기준년도를 입력하세요");
			return;
		}

		$("#authEnterCd").val(($("#searchAuthEnterCd").val()==null?"":getMultiSelect($("#searchAuthEnterCd").val())));
		CallChart1() ;
	}


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='103774' mdef='기준년도 '/></th>
						<td>
							<input class="text center" type="text" id=searchYyyy name="searchYyyy" size="4" maxlength="4">
						</td>
						<th>
							<span style="padding-left:16.5pt"><tit:txt mid='114232' mdef='회사'/></span>
						</th>
						<td>
							<select id="searchAuthEnterCd" name="searchAuthEnterCd"  multiple></select>
							<input type="hidden" id="authEnterCd" name="authEnterCd" value=""/>
						</td>
						<th>파견자포함</th>
						<td>
							<input id="paYn" name="paYn" type="checkbox" style="vertical-align:middle;"/>
							<input type="hidden" id="paYnVal" name="paYnVal">
						</td>
						<td>
							<a href="javascript:searchAllChart();"        class="btn dark authR"><tit:txt mid='104081' mdef='조회'/></a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" >
		<colgroup>
			<col width="75%" />
<!-- 			<col width="*" /> -->
		</colgroup>
<!-- 		<tr><td colspan="2">&nbsp;</td></tr> -->
		<tr><td >&nbsp;</td></tr>
		<tr>
			<td style="height: 450px;">
				<span id="chart1" style="display: block;">
					<script type="text/javascript"> createIBChart("myChart2", "100%", "450px"); </script>
				</span>
			</td>

		</tr>
	</table>
</div>
</body>
</html>
