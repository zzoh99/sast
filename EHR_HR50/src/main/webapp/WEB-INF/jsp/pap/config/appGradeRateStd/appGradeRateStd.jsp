<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>배분기준표</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

var appraisalCdList = null;
var orgGradeCdList  = null;

	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

//=========================================================================================================================================

		appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "");
		orgGradeCdList  = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00010"), "전체");//조직평가등급코드(P00010)

		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchOrgGradeCd").html(orgGradeCdList[2]);
		
		/* 무신사 추가 조직평가등급 미사용으로 인하여 기본값 설정 */
		$("#searchOrgGradeCd").val("20");

//=========================================================================================================================================

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		
		// 평가등급 항목 관리 시트 설정
		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가명",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가등급코드",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"평가등급코드명",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appClassNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"순번",				Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고",				Type:"Text",	Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
		]; IBS_InitSheet(sheetItem, initdata1);sheetItem.SetEditable("${editable}");sheetItem.SetVisible(true);sheetItem.SetCountPosition(4);
		sheetItem.SetColProperty("appraisalCd", 	{ComboText:"|"+appraisalCdList[0],		 	ComboCode:"|"+appraisalCdList[1]} );
		
		//var appClassCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "P00001"), "");	// 평가등급
		//sheetItem.SetColProperty("appClassCd", {ComboText:appClassCd[0], ComboCode:appClassCd[1]});

		// 배분 기준표 시트 설정
		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가명",				Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"조직평가등급",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgGradeCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"총인원",				Type:"Int",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgInwon",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 }
			/*
			{Header:"S등급인원",		Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroupSCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"A등급인원",		Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroupACnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"B등급인원",		Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroupBCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"C등급인원",		Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"D등급인원",		Type:"Int",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroupDCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고",			Type:"Text",	Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 }
			*/
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetColProperty("appraisalCd", 	{ComboText:"|"+appraisalCdList[0],		 	ComboCode:"|"+appraisalCdList[1]} );
		sheet1.SetColProperty("orgGradeCd", 	{ComboText:"|"+orgGradeCdList[0],		 	ComboCode:"|"+orgGradeCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
		doActionItem("Search");

		$("").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				if(!checkList()) return ;
				sheet1.DoSearch( "${ctx}/AppGradeRateStd.do?cmd=getAppGradeRateStdList", $("#sendForm").serialize() );
				break;
			case "Save":
				if(!dupChk(sheet1,"appraisalCd|orgGradeCd|orgInwon", true, true)){break;}
				
				/* 무신사 등급별 인원수 범위 개념 적용으로 인하여 총인원과 계획인원 비교 체크 미사용 처리
				if(sheet1.RowCount() > 0) {
					var invalidSNos = "";
					for(var i = 1; i < sheet1.RowCount()+1; i++) {
						var orgInwon = sheet1.GetCellValue(i, "orgInwon");
						var totCalc  = sheet1.GetCellValue(i, "totCalc");
						
						if(orgInwon != totCalc) {
							if( invalidSNos != "" ) {
								invalidSNos += ", ";
							}
							invalidSNos += sheet1.GetCellValue(i, "sNo");
						}
					}
					
					if(invalidSNos != "") {
						alert("[ " + invalidSNos + " ] 행에 입력하신 등급별 계획인원의 수가 총인원수와 일치하지 않습니다.");
						break;
					}
				}
				*/
				
				IBS_SaveName(document.sendForm,sheet1);
				sheet1.DoSave( "${ctx}/AppGradeRateStd.do?cmd=saveAppGradeRateStd", $("#sendForm").serialize());
				break;
			case "Insert":
				if(sheetItem.RowCount() > 0) {
					if(!checkList()) return ;
					var row = sheet1.DataInsert(0);
					sheet1.SetCellValue( row, "appraisalCd", $("#searchAppraisalCd").val());
					/* 무신사 추가 조직평가등급 미사용으로 인하여 기본값 설정 */
					sheet1.SetCellValue( row, "orgGradeCd", "20");
				} else {
					alert("선택된 평가에 해당하는 평가등급항목 내역이 존재하지 않습니다.")
				}
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1, ExcelFontSize:"9", ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
			case "LoadExcel":
				if(sheetItem.RowCount() > 0) {
					if(!checkList()) return ;
					var params = {Mode:"HeaderMatch", WorkSheetNo:1};
					sheet1.LoadExcel(params);
				} else {
					alert("선택된 평가에 해당하는 평가등급항목 내역이 존재하지 않습니다.")
				}
				break;
			case "DownTemplate":
				//var	downCols = "orgGradeCd|orgInwon|appGroupSCnt|appGroupACnt|appGroupBCnt|appGroupCCnt|appGroupDCnt|note";
				var downCols = makeHiddenSkipCol(sheet1);
				downCols = downCols.substring(4, downCols.length); // No, 평가명 제외
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:downCols, ExcelFontSize:"9", ExcelRowHeight:"20", FileName : "배분기준표_Template_${ssnEnterCd}_" + $("#searchAppraisalCd").val()});
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
				for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
					var cntArr = sheet1.GetCellValue( i, "cntArr" );
					var minCntArr = sheet1.GetCellValue( i, "minCntArr" );
					var maxCntArr = sheet1.GetCellValue( i, "maxCntArr" );
					
					if(cntArr != "" || minCntArr != "" || maxCntArr != "") {
						var valArr = cntArr.split("@");
						var minValArr = minCntArr.split("@");
						var maxValArr = maxCntArr.split("@");
						
						for(var j = 0; j < headerArr.length; j++) {
							//console.log("appClassCd_" + (j+1) + " :: " + headerArr[j] + " :: " + valArr[j]);
							if( valArr != null && valArr != undefined && valArr[j] != null && valArr[j] != undefined ) {
								sheet1.SetCellValue( i, "appClassCd_" + (j+1), valArr[j] );
							}
							if( minValArr != null && minValArr != undefined && minValArr[j] != null && minValArr[j] != undefined ) {
								sheet1.SetCellValue( i, "appClassCd_min_" + (j+1), minValArr[j] );
							}
							if( maxValArr != null && maxValArr != undefined && maxValArr[j] != null && maxValArr[j] != undefined ) {
								sheet1.SetCellValue( i, "appClassCd_max_" + (j+1), maxValArr[j] );
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 엑셀 업로드 후 처리
	function sheet1_OnLoadExcel(Result, Code, Msg) {
		if (!Result) {
			alert('엑셀 로딩중 오류가 발생하였습니다.');
		}
		try {
			if(sheet1.RowCount() > 0) {
				for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
					sheet1.SetCellValue( i, "appraisalCd", $("#searchAppraisalCd").val() );
					/* 무신사 추가 조직평가등급 미사용으로 인하여 기본값 설정 */
					sheet1.SetCellValue( i, "orgGradeCd", "20" );
				}
			}
		} catch (ex) {
			alert("OnLoadExcel Event Error " + ex);
		}
	}


	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

	}

	
	// 배분기준표 컬럼 재설정
	function initSheet1() {
		// 시트 초기화
		sheet1.Reset();
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata1.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가명|평가명",			Type:"Combo",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"조직평가등급|조직평가등급",	Type:"Combo",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgGradeCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"총인원|총인원",			Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orgInwon",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 }
		];
		
		// 컬럼 추가
		var appClassCdList = "";
		var totCalcTxt = "";
		for(var i = 1; i < sheetItem.RowCount()+1; i++) {
			var colHeaderNm = sheetItem.GetCellValue(i, "appClassNm");
			var colSaveNm = "appClassCd_";
			
			// 컬럼 정보 추가
			initdata1.Cols.push({Header:colHeaderNm + "|인원", Type:"Int", Hidden:1, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm + i,          KeyField:0, Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:6 });
			initdata1.Cols.push({Header:colHeaderNm + "|최소", Type:"Int", Hidden:0, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm + "min_" + i, KeyField:1, Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:6 });
			initdata1.Cols.push({Header:colHeaderNm + "|최대", Type:"Int", Hidden:0, Width:60, Align:"Center", ColMerge:0, SaveName:colSaveNm + "max_" + i, KeyField:1, Format:"", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:6 });
			
			if(i > 1) {
				appClassCdList += "@";
				totCalcTxt += "+";
			}
			appClassCdList += sheetItem.GetCellValue(i, "appClassCd");
			totCalcTxt += "|" + colSaveNm + i + "|";
		}
		
		// 컬럼 정보 추가
		initdata1.Cols.push({Header:"등급별\n계획인원|등급별\n계획인원",	Type:"Int",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"totCalc",			KeyField:0,	CalcLogic:totCalcTxt,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 });
		initdata1.Cols.push({Header:"비고|비고",						Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 });
		initdata1.Cols.push({Header:"인원수meta|인원",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"cntArr",			KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
		initdata1.Cols.push({Header:"인원수meta|최소",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"minCntArr",		KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
		initdata1.Cols.push({Header:"인원수meta|최대",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center", ColMerge:0, SaveName:"maxCntArr",		KeyField:0, Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0 });
		
		// 시트 컬럼 재설정 적용
		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 콤보박스 컬럼 설정
		sheet1.SetColProperty("appraisalCd", 	{ComboText:"|"+appraisalCdList[0],		ComboCode:"|"+appraisalCdList[1]} );
		sheet1.SetColProperty("orgGradeCd", 	{ComboText:"|"+orgGradeCdList[0],		ComboCode:"|"+orgGradeCdList[1]} );
		
		// 저장 시 분할 저장 설정
		IBS_setChunkedOnSave("sheet1", {
			chunkSize : 25
		});
		
		$(window).smartresize(sheetResize);
		sheetInit();
		
		$("#appClassCdList").val(appClassCdList);
	}
	

	//sheetItem Action
	function doActionItem(sAction) {
		switch (sAction) {
			case "Search":
				if(!checkList()) return ;
				sheetItem.DoSearch( "${ctx}/AppGradeRateStd.do?cmd=getAppGradeRateStdClassItemList", $("#sendForm").serialize() );
				break;
			case "Save":
				if(!dupChk(sheetItem,"appraisalCd|appClassCd", true, true)){break;}
				if(!dupChk(sheetItem,"appraisalCd|seq", true, true)){break;}
				IBS_SaveName(document.sheetItemForm,sheetItem);
				sheetItem.DoSave( "${ctx}/AppGradeRateStd.do?cmd=saveAppGradeRateStdClassItem", $("#sheetItemForm").serialize());
				break;
			case "Insert":
				if(!checkList()) return ;
				var row = sheetItem.DataInsert(0);
				sheetItem.SetCellValue( row, "appraisalCd", $("#searchAppraisalCd").val());
				break;
			case "Copy":
				var row = sheetItem.DataCopy();
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheetItem_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			// sheet1 재설정
			initSheet1();
			
			if(sheetItem.RowCount() > 0) {
				doAction1("Search");
			}
			
			sheetResize();
		} catch (ex) {
			alert("sheetItem OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheetItem_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doActionItem("Search");
		} catch (ex) {
			alert("sheetItem OnSaveEnd Event Error " + ex);
		}
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
						<select id="searchAppraisalCd" name="searchAppraisalCd" class="box required" onchange="javascript:doActionItem('Search');"></select>
					</td>
					<td class="hide"><!-- 무신사 추가 조직평가등급 미사용 -->
						<span>조직평가등급</span>
						<select id="searchOrgGradeCd" name="searchOrgGradeCd" class="box" onchange="javascript:doActionItem('Search');"></select>
					</td>
					<td>
						<a href="javascript:doActionItem('Search');" class="btn dark authR">조회</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
<!--  평가등급항목관리 시트 관련 -->
				<form name="sheetItemForm" id="sheetItemForm" method="post"></form>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">평가등급항목</li>
						<li class="btn">
							<a href="javascript:doActionItem('Copy')"		class="btn outline-gray authA">복사</a>
							<a href="javascript:doActionItem('Insert')"		class="btn outline-gray authA">입력</a>
							<a href="javascript:doActionItem('Save')"		class="btn filled authA">저장</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheetItem", "100%", "40%", "kr"); </script>
<!--  평가등급항목관리 시트 관련 -->
			</td>
		</tr>
		<tr>
			<td>
				<div class="inner mat10">
					<div class="sheet_title">
					<ul>
						<li class="txt">배분기준표</li>
						<li class="btn">
							<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
							<a href="javascript:doAction1('DownTemplate')" 	class="btn outline-gray authA">양식다운로드</a>
							<a href="javascript:doAction1('LoadExcel')" 	class="btn outline-gray authA">업로드</a>
							<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
							<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
							<a href="javascript:doAction1('Save')" 			class="btn filled authA">저장</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "60%", "kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
