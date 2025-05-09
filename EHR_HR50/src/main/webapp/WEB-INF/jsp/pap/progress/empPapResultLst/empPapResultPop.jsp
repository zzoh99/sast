<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>1,2차평가PopUp</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript" src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchart.js"></script>
<script type="text/javascript" src="${ctx}/common/plugin/IBLeaders/Chart/js/ibchartinfo.js"></script>

<script type="text/javascript">
	var p 	= eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"세부\n내역|세부\n내역",	Type:"Image",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"순서|순서",		Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"구분|구분",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:1,	SaveName:"appIndexGubunNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"목표명|목표명",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1 },
			{Header:"KPI|지표명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"kpiNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1 },
			{Header:"KPI|산출근거",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"formula",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1 },
			{Header:"기준치|기준치",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"baselineData",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1 },
			{Header:"평가등급기준|S등급",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"sGradeBase",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1 },
			{Header:"평가등급기준|A등급",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"aGradeBase",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1 },
			{Header:"평가등급기준|B등급",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"bGradeBase",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1 },
			{Header:"평가등급기준|C등급",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"cGradeBase",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1 },
			{Header:"평가등급기준|D등급",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"dGradeBase",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, MultiLineText:1 },
			{Header:"가중치|가중치",		Type:"AutoSum",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"weight",			KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"실적|실적",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mboAppResult",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500, MultiLineText:1 },
			{Header:"평가등급|본인",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"mboSelfClassCd",	KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 , MaximumValue:999},
			{Header:"평가등급|1차",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"mbo1stClassCd",	KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 , MaximumValue:999},
			{Header:"평가등급|2차",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"mbo2ndClassCd",	KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 , MaximumValue:999},
			{Header:"Remark",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"remark",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500, MultiLineText:1 },

			{Header:"평가ID|평가ID",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"평가소속|평가소속",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사번|사번",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"순번|순번",			Type:"Int",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"생성구분코드|생성구분코드",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mkGubunCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"지표구분|지표구분",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appIndexGubunCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);


		initdata.Cols = [
     		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"역량범주",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"mainAppTypeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"역량항목",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"competencyNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"본인",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"compAppSelfPoint",KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
			{Header:"1차",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"compApp1stPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },
			{Header:"2차",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"compApp2ndPoint",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:25 },

   			{Header:"평가ID",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"사원번호",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
   			{Header:"평가부서",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"역량코드",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"competencyCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
   		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);


		sheet1.SetEditEnterBehavior("newline");
		sheet1.SetAutoSumPosition(1);
		sheet1.SetSumValue("sNo", "합계") ;
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",1);

		setAppClassCd();

		$(window).smartresize(sheetResize); sheetInit();
	});


	function setAppClassCd(){

		//평가등급기준 -- 평가종류에 따라 다른 등급을 가져옴.
		var saveNameLst = ["sGradeBase", "aGradeBase", "bGradeBase", "cGradeBase", "dGradeBase"];
		//classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCd&searchAppTypeCd=C,",false).codeList, ""); // 평가등급
		classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, ""); // 평가등급
		clsLst = classCdList[0].split("|");

		for( var i=0; i<clsLst.length ; i++){
			sheet1.SetColHidden(saveNameLst[i], 0 );
			sheet1.SetCellValue(1, saveNameLst[i], clsLst[i] );
		}
		var len = clsLst.length;
		if(classCdList[0] == "" ) len = 0;
		for( var i=len; i<saveNameLst.length ; i++){
			sheet1.SetColHidden(saveNameLst[i], 1 );
		}

		sheet1.SetColProperty("mboSelfClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		sheet1.SetColProperty("mbo1stClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		sheet1.SetColProperty("mbo2ndClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		//sheet2.SetColProperty("compSelfClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		//sheet2.SetColProperty("comp1stClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );
		//sheet2.SetColProperty("comp2ndClassCd", {ComboText:classCdList[0], ComboCode:classCdList[1]} );

	}

	$(function(){
		$(".close").click(function() 	{ p.self.close(); });

		if( arg != "undefined" ) {

			$("#searchAppraisalCd").val(arg["appraisalCd"]);
			$("#searchSabun").val(arg["sabun"]);
			$("#searchAppOrgCd").val(arg["appOrgCd"]);
			$("#searchAppSeqCd").val(arg["searchAppSeqCd"]);
			$("#searchJikgubCd").val(arg["jikgubCd"]);

			$("#tdNameSabun").html(arg["name"] +"/"+ arg["sabun"]);
			$("#tdAppOrgNm").html(arg["appOrgNm"]);
			$("#tdJikweeNm").html(arg["jikweeNm"]);
			$("#tdJikchakNm").html(arg["jikchakNm"]);
			$("#tdGempYmd").html(arg["gempYmd"]);
			$("#tdJikweeYeuncha").html(arg["jikweeYeuncha"]);
			$("#tdAppraisalYy").html(arg["appraisalYy"]);
			$("#spanFinalClassNm").html("종합등급 : "+arg["finalClassNm"]);

/*
			$("#mboRateText").html("");
 			var data = ajaxCall("${ctx}/AppFeedBackLst.do?cmd=getAppFeedBackLstDetailPopRateMap",$("#srchFrm").serialize(),false);

			if(data != null && data.map != null) {
				var mboRate = (data.map.mboRate1*1)+(data.map.mboRate2*1);
				var competencyRate = (data.map.competencyRate1*1)+(data.map.competencyRate2*1);
				var finalMboRate = data.map.mboRate;
				var finalCompetencyRate = data.map.competencyRate;

				var mboRateText = "(종합등급은 업적평가"+ mboRate+"%, 역량평가 "+competencyRate+"%의 기준으로 산출/조정한 1차/2차평가 결과를 각각 ";
				mboRateText += ""+finalMboRate+"%, "+finalCompetencyRate+"%의 비율로 합산하여 계산한 최종등급입니다.)";

				$("#mboRateText").html(mboRateText);
			}
 */
		}

		chartDesign();
		doAction1("Search");
		doAction2("Search");

	});

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
				Name : "본인",
				Data : [],
				DataLabels : {
					Enabled : false,

				}
			},{
				Type : "line",
				Name : "1차",
				Data : [],
				DataLabels : {
					Enabled : false
				}
			},{
				Type : "line",
				Name : "2차",
				Data : [],
				DataLabels : {
					Enabled : false
				}
			}]
		,1);

		myChart.Draw();
	}

	function chartUpdate() {
		//본인평가
		var series1 = myChart.GetSeries(0);
		//1차평가
		var series2 = myChart.GetSeries(1);
		//2차평가
		var series3 = myChart.GetSeries(2);

		if(sheet2.SearchRows() == 0) {
			series1.SetData([],false);
			series2.SetData([],false);
			series3.SetData([],false);
			myChart.SetXAxisLabelsText(0,[]);
		} else {
			var arrSelfPoint = [];
			var arr1stPoint = [];
			var arr2ndPoint = [];
			var arrName = [];

			for(var i = 1; i < sheet2.RowCount()+1; i++) {
				var data1 = sheet2.GetCellValue(i,"compAppSelfPoint");
				var data2 = sheet2.GetCellValue(i,"compApp1stPoint");
				var data3 = sheet2.GetCellValue(i,"compApp2ndPoint");
				var name = sheet2.GetCellValue(i,"competencyNm");

				arrSelfPoint.push({
					name: name,
					y: data1*1
				});
				arr1stPoint.push({
					name: name,
					y: data2*1
				});
				arr2ndPoint.push({
					name: name,
					y: data3*1
				});
				arrName.push(name);
			}

			series1.SetData(arrSelfPoint, false);
			series2.SetData(arr1stPoint, false);
			series3.SetData(arr2ndPoint, false);
			myChart.SetXAxisLabelsText(0,arrName);
		}

		myChart.Draw();
	}

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			// 평가등급, 본인의견 조회
			//var data = ajaxCall("${ctx}/AppFeedBackLst.do?cmd=getAppFeedBackLstDetailPopMap",$("#srchFrm").serialize(),false);
			var data = ajaxCall("${ctx}/EmpPapResultLst.do?cmd=getEmpPapResultPopMap",$("#srchFrm").serialize(),false);
			if(data != null && data.map != null) {
				$("#mboApp1stMemo").val(data.map.mboApp1stMemo);
				$("#mboApp2ndMemo").val(data.map.mboApp2ndMemo);
				$("#compApp1stMemo").val(data.map.compApp1stMemo);
				$("#compApp2ndMemo").val(data.map.compApp2ndMemo);
			} else {
				$("#mboApp1stMemo").val("");
				$("#mboApp2ndMemo").val("");
				$("#compApp1stMemo").val("");
				$("#compApp2ndMemo").val("");
			}

			// sheet 조회
			sheet1.DoSearch( "${ctx}/EmpPapResultLst.do?cmd=getEmpPapResultPopList1", $("#srchFrm").serialize() );
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			// sheet 조회
			sheet2.DoSearch( "${ctx}/EmpPapResultLst.do?cmd=getEmpPapResultPopList2", $("#srchFrm").serialize() );
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			sheetResize();
			chartUpdate();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}


	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet1.ColSaveName(Col) == "detail" && sheet1.GetCellValue(Row, "sStatus") != "" ){
				if(!isPopup()) {return;}

				var paramName = ["seq"
	     			,"appGubunCd"
	     			,"taskDesc"
	     			,"detDesc"
	     			,"remark"
	     			,"mboAppResult"
	     			,"weight"
	     			,"mboAppSelpPoint"
	     			,"mboApp1stPoint"
	     			,"mboApp2ndPoint"
	     			,"orderSeq"
	     		];

	     		var url = "${ctx}/App1st2nd.do?cmd=viewApp1st2ndPopKpiDetail";
	     		var args = new Array();
				args["authPg"] = "R";

	     		for (var i=0; i<paramName.length; i++) {
	     			args[paramName[i]] = sheet1.GetCellValue(Row, paramName[i]);
	     		}

	     		openPopup(url,args,700,450);
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}
</script>

</head>
<body class="bodywrap">

<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li>평가결과</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">

		<form id="srchFrm" name="srchFrm">
			<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" value="" />
			<input id="searchSabun" name="searchSabun" type="hidden" value="" />
			<input id="searchAppOrgCd" name="searchAppOrgCd" type="hidden" value="" />
			<input id="searchAppSeqCd" name="searchAppSeqCd" type="hidden" value="" />
			<input id="searchJikweeCd" name="searchJikweeCd" type="hidden" value="" />
		</form>

		<table border="0" cellpadding="0" cellspacing="0" class="default outer">
		<colgroup>
			<col width="10%" />
			<col width="23%" />
			<col width="10%" />
			<col width="23%" />
			<col width="10%" />
			<col width="" />
		</colgroup>
		<tr>
			<th>성명/사번</th>
			<td id="tdNameSabun"></td>
			<th>소속</th>
			<td id="tdAppOrgNm"></td>
			<th>입사일</th>
			<td id="tdGempYmd"></td>
		</tr>
		<tr>
			<th>직위</th>
			<td id="tdJikweeNm"></td>
			<th>직책</th>
			<td id="tdJikchakNm"></td>
			<th>평가년도</th>
			<td id="tdAppraisalYy"></td>
		</tr>
		</table>

		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">업적</li>
					<li class="btn">
						<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
					</li>
				</ul>
			</div>
		</div>

		<div style="border:1px solid #b1b1b1; padding:5px;">
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "300px"); </script>

			<div class="hide">
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "300px"); </script>
			</div>

			<div class="outer">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">1차평가자의견</li>
					</ul>
				</div>
				<table class="table w100p">
					<tr>
						<td >
							<textarea id="mboApp1stMemo" name="mboApp1stMemo" class="w100p readonly" rows="3" readonly ></textarea>
						</td>
					</tr>
				</table>

				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">2차평가자의견</li>
					</ul>
				</div>
				<table class="table w100p">
					<tr>
						<td >
							<textarea id="mboApp2ndMemo" name="mboApp2ndMemo" class="w100p readonly" rows="3" readonly ></textarea>
						</td>
					</tr>
				</table>
			</div>
		</div>

		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">역량</li>
				</ul>
			</div>

			<div style="border:1px solid #b1b1b1; padding:5px;">
				<table class="table w100p">
					<tr>
						<td style="width:55%;" rowspan="2">
							<script type="text/javascript">createIBChart("myChart", "100%", "300px"); </script>
						</td>
						<td>
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">1차평가자의견</li>
								</ul>
							</div>

							<textarea id="compApp1stMemo" name="compApp1stMemo" class="w100p readonly" rows="7" readonly ></textarea>
						</td>
					</tr>
					<tr>
						<td>
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">2차평가자의견</li>
								</ul>
							</div>
							<textarea id="compApp2ndMemo" name="compApp2ndMemo" class="w100p readonly" rows="7" readonly ></textarea>
						</td>
					</tr>
				</table>
			</div>
			<div style="margin-top:5px;display:none;">
				<font color="ff0000"><span id="spanFinalClassNm">종합등급:</span></font><br/>
				<span id="mboRateText">
					<!-- (종합등급은 업적평가 40%, 역량평가6%의 기준으로 산출/조정한 1차/2차평가 결과를 각각 50%, 50%의 비율로 합산하여 계산한 최종등급입니다.)  -->
				</span>
			</div>
		</div>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>

</div>
</body>
</html>