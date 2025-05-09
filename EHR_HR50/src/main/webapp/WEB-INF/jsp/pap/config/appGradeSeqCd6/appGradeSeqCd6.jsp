<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>배분결과(3차)</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

var appraisalCdList = null;
var orgGradeCdList  = null;
var sChkList        = null;


	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

//=========================================================================================================================================

		appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "");
		orgGradeCdList  = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00010"), "전체");//등급(P00010)
		sChkList        = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S90005"), "전체");//Y/N(S90005)

		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchOrgGradeCd").html(orgGradeCdList[2]);
		$("#searchSChk").html(sChkList[2]);
		
		/* 무신사 추가 조직평가등급 미사용으로 인하여 기본값 설정 */
		$("#searchOrgGradeCd").val("20");

//=========================================================================================================================================

		$("#searchAppGroupNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가ID코드(TPAP101)",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10  },
			{Header:"평가대상그룹(TPAP133)",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10  },
			{Header:"평가대상그룹명",				Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"appGroupNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직평가등급",				Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgGradeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10  },
			{Header:"계획 총원",					Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"totCntPlan",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"동일\n여부",					Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sChk",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"3차 총원",					Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"totCntExec",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("orgGradeCd", 		{ComboText:"|"+orgGradeCdList[0], 		ComboCode:"|"+orgGradeCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

	});

	// 시트 재설정
	function initSheet1() {
		var bcc = "#fdf0f5";

		// 시트 초기화
		sheet1.Reset();

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No|No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제|삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태|상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가ID코드(TPAP101)",					Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10  },
			{Header:"평가대상그룹(TPAP133)",					Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10  },
			{Header:"평가대상그룹명|평가대상그룹명|평가대상그룹명",	Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"appGroupNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조직평가등급|조직평가등급|조직평가등급",		Type:"Combo",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgGradeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10  },
			{Header:"계획|총원|총원",							Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"totCntPlan",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		];

		// 컬럼 추가
		var appClassCdList = "";
		var data = ajaxCall("${ctx}/AppGradeRateStd.do?cmd=getAppGradeRateStdClassItemList",$("#sendForm").serialize(),false);
		if(data != null && data != undefined && data.DATA != null && data.DATA != undefined && data.DATA.length > 0) {
			var item = null;
			
			// [계획] 등급배분 컬럼 셋팅
			for(var i = 0; i < data.DATA.length; i++) {
				item = data.DATA[i];
				var colHeaderNm = "계획|" + item.appClassNm;
				var colSaveNm = "plan_";
				
				// 컬럼 정보 추가
				initdata1.Cols.push({Header:colHeaderNm + "|인원", Type:"Int", Hidden:1, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm + (i+1),          KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:6 });
				initdata1.Cols.push({Header:colHeaderNm + "|최소", Type:"Int", Hidden:0, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm + "min_" + (i+1), KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:6 });
				initdata1.Cols.push({Header:colHeaderNm + "|최대", Type:"Int", Hidden:0, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm + "max_" + (i+1), KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:6 });
				
				if(i > 0) {
					appClassCdList += "@";
				}
				appClassCdList += item.appClassCd;
			}
			
			// 동일여부 컬럼 추가
			initdata1.Cols.push({Header:"동일\n여부|동일\n여부|동일\n여부",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sChk",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
			// 3차 총원 컬럼 추가
			initdata1.Cols.push({Header:"3차|총원|총원",					Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"totCntExec",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	BackColor:bcc });

			// [3차] 등급배분 컬럼 셋팅
			for(var i = 0; i < data.DATA.length; i++) {
				item = data.DATA[i];
				var colHeaderNm = "3차|" + item.appClassNm + "|" + item.appClassNm;
				var colSaveNm   = "exec_" + (i+1);
				
				// 컬럼 정보 추가
				initdata1.Cols.push({Header:colHeaderNm, Type:"Int", Hidden:0, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm, KeyField:0, Format:"", PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:6, BackColor:bcc });
			}
			
			// 기타 컬럼 추가
			initdata1.Cols.push({Header:"계획인원수meta|인원",		Type:"Text", 	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"cntArrPlan",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"계획인원수meta|최소",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"minCntArrPlan",	KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"계획인원수meta|최대",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"maxCntArrPlan",	KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
			initdata1.Cols.push({Header:"3차인원수meta|인원",		Type:"Text", 	Hidden:1,	 Width:60,	Align:"Center", ColMerge:0, SaveName:"cntArrExec",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
		}
		
		// 시트 컬럼 재설정 적용
		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		
		sheet1.SetDataLinkMouse("totCntPlan", 1);
		sheet1.SetDataLinkMouse("totCntExec", 1);
		
		sheet1.SetCellBackColor(0, "totCntExec",  bcc);
		sheet1.SetCellBackColor(1, "totCntExec",  bcc);
		sheet1.SetCellBackColor(2, "totCntExec",  bcc);
		
		if(data != null && data != undefined && data.DATA != null && data.DATA != undefined && data.DATA.length > 0) {
			item = null;
			// [3차] 등급배분 컬럼 셋팅
			for(var i = 0; i < data.DATA.length; i++) {
				item = data.DATA[i];
				colSaveNm   = "exec_" + (i+1);
				sheet1.SetCellBackColor(0, colSaveNm, bcc);
				sheet1.SetCellBackColor(1, colSaveNm, bcc);
				sheet1.SetCellBackColor(2, colSaveNm, bcc);
			}
		}

		sheet1.SetColProperty("orgGradeCd", 		{ComboText:"|"+orgGradeCdList[0], 		ComboCode:"|"+orgGradeCdList[1]} );

		$(window).smartresize(sheetResize);
		sheetInit();
		
		$("#appClassCdList").val(appClassCdList);
	}
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				initSheet1();
				sheet1.DoSearch( "${ctx}/AppGradeSeqCd6.do?cmd=getAppGradeSeqCd6List", $("#sendForm").serialize() );
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			// 세부 등급별 인원수 데이터 삽입 처리
			if(sheet1.RowCount() > 0) {
				var headerArr = $("#appClassCdList").val().split("@");
				// [계획] 평가등급별 인원 수 설정
				for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
					var cntArr = sheet1.GetCellValue( i, "cntArrPlan" );
					var minCntArr = sheet1.GetCellValue( i, "minCntArrPlan" );
					var maxCntArr = sheet1.GetCellValue( i, "maxCntArrPlan" );
					
					if(cntArr != "" || minCntArr != "" || maxCntArr != "") {
						var valArr = cntArr.split("@");
						var minValArr = minCntArr.split("@");
						var maxValArr = maxCntArr.split("@");
						for(var j = 0; j < headerArr.length; j++) {
							//console.log("plan_" + (j+1) + " :: " + headerArr[j] + " :: " + valArr[j]);
							if( valArr != null && valArr != undefined && valArr[j] != null && valArr[j] != undefined ) {
								sheet1.SetCellValue( i, "plan_" + (j+1), valArr[j] );
							}
							if( minValArr != null && minValArr != undefined && minValArr[j] != null && minValArr[j] != undefined ) {
								sheet1.SetCellValue( i, "plan_min_" + (j+1), minValArr[j] );
							}
							if( maxValArr != null && maxValArr != undefined && maxValArr[j] != null && maxValArr[j] != undefined ) {
								sheet1.SetCellValue( i, "plan_max_" + (j+1), maxValArr[j] );
							}
						}
						sheet1.SetCellValue( i, "sStatus", "R" );
					}
				}
				
				// [3차] 평가등급별 인원 수 설정
				for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
					var cntArr = sheet1.GetCellValue( i, "cntArrExec" );

					if(cntArr != "") {
						var valArr = cntArr.split("@");
						//var minValArr = minCntArr.split("@");
						//var maxValArr = maxCntArr.split("@");
						for(var j = 0; j < headerArr.length; j++) {
							//console.log("exec_" + (j+1) + " :: " + headerArr[j] + " :: " + valArr[j]);
							if( valArr != null && valArr != undefined && valArr[j] != null && valArr[j] != undefined ) {
								sheet1.SetCellValue( i, "exec_" + (j+1), valArr[j] );
							}
						}
						sheet1.SetCellValue( i, "sStatus", "R" );
					}
				}
			}
			
			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if( Row >= sheet1.HeaderRows() ) {
				if(sheet1.ColSaveName(Col) == "totCntPlan" || sheet1.ColSaveName(Col) == "totCntExec"){
					if(!isPopup()) {return;}
	
					<%--var args = new Array();--%>
					<%--args["searchAppraisalCd"] = sheet1.GetCellValue(Row, "appraisalCd");--%>
					<%--args["searchAppSeqCd"] = "6";--%>
					<%--args["searchAppGroupCd"] = sheet1.GetCellValue(Row, "appGroupCd");--%>

					<%--openPopup("${ctx}/AppGradeRateMgr.do?cmd=viewAppGradeOrgRateMgrPop",args,1000,500);--%>


					var layer = new window.top.document.LayerModal({
						id : 'appGradeOrgRateMgrLayer'
						, url : '/AppGradeSeqCd2.do?cmd=viewAppGradeOrgRateMgrLayer'
						, parameters: {
							searchAppraisalCd : sheet1.GetCellValue(Row, "appraisalCd"),
							searchAppSeqCd : "6",
							searchAppGroupCd : sheet1.GetCellValue(Row, "appGroupCd")
						}
						, width : 1000
						, height : 500
						, title : "평가그룹인원 팝업"
						, trigger :[
							{
								name : 'appGradeOrgRateMgrLayerTrigger'
								, callback : function(rv){
									doAction1("Search");
								}
							}
						]
					});
					layer.show();

				}
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<input type="hidden" id="appClassCdList" name="appClassCdList" />
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td>
				<span>평가명</span>
				<select id="searchAppraisalCd" name="searchAppraisalCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td>
				<span>평가대상그룹명</span>
				<input id="searchAppGroupNm" name="searchAppGroupNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td class="hide"><!-- 무신사 추가 조직평가등급 미사용 -->
				<span>조직평가등급</span>
				<select id="searchOrgGradeCd" name="searchOrgGradeCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td class="hide"><!-- 무신사 추가 조직평가등급 미사용 -->
				<span>동일여부</span>
				<select id="searchSChk" name="searchSChk" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">배분결과(3차)</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "kr"); </script>
</div>
</body>
</html>
