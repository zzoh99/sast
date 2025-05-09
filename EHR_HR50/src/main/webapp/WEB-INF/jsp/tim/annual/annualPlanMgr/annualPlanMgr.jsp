<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {


		$("#year").keyup(function() {
			makeNumber(this,'A');
		});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='vacReceiveSymd' mdef='접수기간|시작일'/>",	Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"vacReceiveSymd",	KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='vacReceiveEymd' mdef='접수기간|종료일'/>",	Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"vacReceiveEymd",	KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='vacPlanNm' mdef='휴가계획명|휴가계획명'/>",	Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"vacPlanNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='vacStdSymd' mdef='연차기간|시작일'/>",		Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"vacStdSymd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='vacStdEymd' mdef='연차기간|종료일'/>",		Type:"Date",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"vacStdEymd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='closeYnV4' mdef='마감여부|마감여부'/>",		Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"closeYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10, DefaultValue:"N" },
			{Header:"대상자기준|조건검색명",									Type:"Popup",		Hidden:0, 	Width:200,  Align:"Left",	ColMerge:0,	SaveName:"searchDesc",		KeyField:0,	Format:"", 		UpdateEdit:1,   InsertEdit:1 },
  			{Header:"대상자기준|조건검색\n코드",								Type:"Text",		Hidden:0, 	Width:60,  	Align:"Center",	ColMerge:0,	SaveName:"searchSeq",		KeyField:0,	Format:"", 		UpdateEdit:1,   InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",					Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"bigo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"SEQ|SEQ",													Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"seq",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetMergeSheet( msHeaderOnly);

		sheet1.SetColProperty("closeYn", 		{ComboText:"<tit:txt mid='114369' mdef='마감'/>|<tit:txt mid='2017083001026' mdef='미마감'/>", ComboCode:"Y|N"} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $("#name").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/AnnualPlanMgr.do?cmd=getAnnualPlanMgrList",$("#searchForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			break;
		case "Save":
			IBS_SaveName(document.searchForm,sheet1);
			sheet1.DoSave( "${ctx}/AnnualPlanMgr.do?cmd=saveAnnualPlanMgr",$("#searchForm").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "seq", "");
			break;
		break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
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
	
	// 셀 변경 시 
	function sheet1_OnChange(Row, Col, Value) {
		try {
			if (sheet1.ColSaveName(Col) == "searchSeq") {
				sheet1.SetCellValue(Row, "searchDesc", "");
			}
		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}
	
	// 셀 팝업 클릭 시
	function sheet1_OnPopupClick(Row, Col) {
		try {
			if(sheet1.ColSaveName(Col) == "searchDesc") { //대상자기준 조건검색
				new window.top.document.LayerModal({
					id : 'pwrSrchMgrLayer'
					, url : '/Popup.do?cmd=viewPwrSrchMgrLayer'
					, parameters : {
						srchBizCd: "08",
						srchType: "3",
						srchDesc: "대상"
					}
					, width : 850
					, height : 620
					, title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>'
					, trigger :[
						{
							name : 'pwrTrigger'
							, callback : function(result){
								sheet1.SetCellValue(Row, "searchSeq", result.searchSeq, {event: 0});
								sheet1.SetCellValue(Row, "searchDesc", result.searchDesc);
							}
						}
					]
				}).show();
			}

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="searchForm" name="searchForm">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='114464' mdef='조회년도'/></th>
			<td>
				<input id="year" name="year" type="text" class="text center required w60" maxlength="4" value="${curSysYear}"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid="search" mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='annualPlanMgr' mdef='연차휴가계획기준관리'/></li>
			<li class="btn">
				<span class="bold">* 대상자기준을 입력하지 않을 경우 모든 임직원이 연차휴가계획신청 대상자입니다.</span>
				<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='download' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>