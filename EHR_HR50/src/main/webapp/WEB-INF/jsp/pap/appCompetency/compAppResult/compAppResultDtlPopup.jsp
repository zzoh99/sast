<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<script type="text/javascript" src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchart.js"></script>
<script type="text/javascript" src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchartinfo.js"></script>

<script type="text/javascript">

	var checkType="";


	$(function() {

		createIBSheet3(document.getElementById('mysheet-wrap'), "sheet1", "100%", "300px", "${ssnLocaleCd}");
		createIBChart2(document.getElementById('myChart'), "myChart", "100%", "400px" ,"${ssnLocaleCd}");
		var modal = window.top.document.LayerModalUtility.getModal('CompAppResultDtlPopupLayer');

		$("#searchAppraisalCd").val(modal.parameters.searchAppraisalCd);
		$("#searchSabun").val(modal.parameters.searchSabun);
		
    	// 조회조건 이벤트 등록
        $("#searchAppSeqCd").bind("change",function(event){
            doAction1("Search");
        });
		
		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00004&searchUseYn=Y",false).codeList, "");
		$("#searchAppSeqCd").html(appSeqCdList[2]); //평가차수

		var initdata = {};
		initdata.Cfg = {FrozenCol:1,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",			   Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"리더십 역량|리더십 역량",		Type:"Text",		Hidden:0,	Width:120,	Align:"Center", ColMerge:0, SaveName:"ldsCompetencyNm",	 KeyField:0,	UpdateEdit:0,   InsertEdit:0},
			{Header:"다면진단|현재수준",		 	Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMerge:0, SaveName:"avgAppResult",	 KeyField:0,	UpdateEdit:0,   InsertEdit:0},
			{Header:"다면진단|전사평균",		 	Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMerge:0, SaveName:"avgAppResultAll",	 KeyField:0,	UpdateEdit:0,   InsertEdit:0},
			{Header:"다면진단|GAP",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center", ColMerge:0, SaveName:"gap",  			 KeyField:0, 	UpdateEdit:0, 	InsertEdit:0}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
		
		chartDesign();
		doAction1("Search");

	});

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			 sheet1.DoSearch( "${ctx}/CompAppResult.do?cmd=getCompAppResultDtlList", $("#sheet1Form").serialize() );
			 break;
		}
	}
   //조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			sheetResize();
			chartUpdate();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	
	//방사형 차트 디자인.
	function chartDesign() {

		myChart.SetOptions({
			PlotOptions: {
				Line: {
					Tooltip: {
						HeaderFormat : "<span>{point.key}</span><br>"
					}
				}
			},
			XAxis: {
				LineWidth: 0
			},
			YAxis: {
				GridLineInterpolation: "polygon",
				GridLineDashStyle: "solid",
				LineWidth: 0
			}
		});

		myChart.SetToolTipOptions({
			Shared: true
		});

		myChart.SetPolar(true);

		myChart.SetSeriesOptions(
			[{
				Type : "line",
				Name : "다면진단 현재수준",
				Data : [],
				DataLabels : {
					Enabled : false,

				}
			},{
				Type : "line",
				Name : "전사평균",
				Data : [],
				DataLabels : {
					Enabled : false
				}
			}]
		,1);

		myChart.Draw();
	}
	
	function chartUpdate() {
		//다면진단 현재수준
		var series1 = myChart.GetSeries(0);
		//다면진단 전사평균
		var series2 = myChart.GetSeries(1);
		
		var seriesName = "다면진단";
		var seqText = $('#searchAppSeqCd option:checked').text();
		if(seqText != '전체') seriesName = seqText;
		
		series1.SetName(seriesName + ' 현재수준');
		series2.SetName(seriesName + ' 전사평균');

		if(sheet1.SearchRows() == 0) {
			series1.SetData([],false);
			series2.SetData([],false);
			myChart.SetXAxisLabelsText(0,[]);
		} else {
			var arrAppCResult = [];
			var arrAppFResult = [];
			var arrName = [];

			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++) {
				var data1 = sheet1.GetCellValue(i,"avgAppResult");
				var data2 = sheet1.GetCellValue(i,"avgAppResultAll");
				var name = sheet1.GetCellValue(i,"ldsCompetencyNm");

				arrAppCResult.push({
					name: name,
					y: data1*1
				});
				arrAppFResult.push({
					name: name,
					y: data2*1
				});

				arrName.push(name);
			}

			series1.SetData(arrAppCResult, false);
			series2.SetData(arrAppFResult, false);
			myChart.SetXAxisLabelsText(0,arrName);
		}
		
		myChart.UpdateSeries(series1, 0);
		myChart.UpdateSeries(series2, 1);

		myChart.Draw();
		
		//헤더 행 텍스트
		sheet1.SetCellText(0 , 'avgAppResult' , seriesName);
		sheet1.SetCellText(0 , 'avgAppResultAll' , seriesName);
		sheet1.SetCellText(0 , 'gap' , seriesName);
	}
	
	function closeLayer(){

		closeCommonLayer('CompAppResultDtlPopupLayer');
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer" style="overflow-y:auto;">
		<div class="modal_body">
			<form id="sheet1Form" name="sheet1Form" >
				<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/>
				<input type="hidden" id="searchSabun"	   	name="searchSabun"	   	 value=""/>

				<div class="sheet_search sheet_search_w50 outer">
					<table>
						<tr>
							<td>
								<span>평가차수 </span>
								<select name="searchAppSeqCd" id="searchAppSeqCd"></select>
							</td>
						</tr>
					</table>
				</div>
			</form>

			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="outer">
							<div class="sheet_title">
								<ul>
									<li class="txt" id="titleNm">평가항목</li>
									<li class="btn">
									</li>
								</ul>
							</div>
						</div>
						<div id="sheet1_box">
							<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
								<colgroup>
									<col width="50%" />
									<col width="%" />
								</colgroup>
								<tr>
									<td>
										<div id="mysheet-wrap"></div>
									</td>
									<td>
										<div id="myChart"></div>
									</td>
								</tr>
							</table>
						</div>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer">
			<a href="javascript:closeLayer();" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
	</div>
</body>
</html>