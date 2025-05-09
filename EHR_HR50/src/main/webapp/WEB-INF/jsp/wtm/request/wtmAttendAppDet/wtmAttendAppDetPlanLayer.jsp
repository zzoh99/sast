<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script>
var vacationPlanSheet;
var vacationPlanOption = {
	id: 'wtmAttendAppDetPlanLayer',
	searchApplSabn: ''
};

$(function() {
	vacationPlanOption = { searchApplSabun: '${searchApplSabun}', ...vacationPlanOption };
	$('#vacationPlanSearchYear').val('${curSysYear}');
	var data = ajaxCall("/WtmWorkCalendar.do?cmd=getWtmWorkCalendarDetPlanPopupMap", 'searchApplSabun=' + vacationPlanOption.searchApplSabun, false);
	if ( data && data.DATA ){
		$("#vacationPlanName").val(data.DATA.name);
		$("#vacationPlanOrgNm").val(data.DATA.orgNm);
	}
	$('#vacationPlanName, #vacationPlanSearchYear').bind('keyup', function(e) {
		if (e.keyCode == 13) {
			vacationPlanAction('Search');
		}
	});
	createVacationPlanSheet();
});

function closeVacationPlanLayer() {
	vacationPlanSheet.DisposeSheet(1);
	const modal = window.top.document.LayerModalUtility.getModal(vacationPlanOption.id);
	modal.fire('wtmAttendAppDetPlanTrigger', null).hide();
}

function closeVacationPlanLayerRtnFunc(param) {
	vacationPlanSheet.DisposeSheet(1);
	var p;
	if (param) p = param;
	else {
		var row = vacationPlanSheet.GetSelectRow();
		p = {
			sdate: vacationPlanSheet.GetCellValue(row, 'sdate'),
			edate: vacationPlanSheet.GetCellValue(row, 'edate'),
			sdateFormat: vacationPlanSheet.GetCellText(row, 'sdate'),
			edateFormat: vacationPlanSheet.GetCellText(row, 'edate')
		};
	}
	const modal = window.top.document.LayerModalUtility.getModal(vacationPlanOption.id);
	modal.fire('wtmAttendAppDetPlanTrigger', p).hide();
}

function createVacationPlanSheet() {
	createIBSheet3($('#wtmAttendAppDetLayerSheetArea').get(0), "vacationPlanSheet", "100%", "100%", '${ssnLocaleCd}');
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"시작일자",	Type:"Date",	Hidden:0,	Width:159,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"종료일자",	Type:"Date",	Hidden:0,	Width:159,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
		{Header:"총일수",		Type:"Int",		Hidden:0,	Width:159,	Align:"Right",	ColMerge:0,	SaveName:"totalDays",	KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
		{Header:"적용일수",	Type:"Int",		Hidden:0,	Width:159,	Align:"Right",	ColMerge:0,	SaveName:"days",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
		{Header:"비고",		Type:"Text",	Hidden:0,	Width:158,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
		{Header:"SEQ",		Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
		{Header:"사번",		Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20},
		{Header:"신청순번",	Type:"Text",	Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20}
	]; 
	IBS_InitSheet(vacationPlanSheet, initdata);
	vacationPlanSheet.SetEditable(false);
	vacationPlanSheet.SetVisible(true);
	vacationPlanSheet.SetCountPosition(4);
	vacationPlanSheet.SetSheetHeight(320);
	vacationPlanAction('Search');
}

function vacationPlanAction(action) {
	switch(action) {
	case 'Search':
		const p = {
			searchApplSabun: vacationPlanOption.searchApplSabun,
			orgNm: $('#vacationPlanOrgNm').val(),
			name: $('#vacationPlanName').val(),
			searchYear: $('#vacationPlanSearchYear').val()
		};
		vacationPlanSheet.DoSearch('/WtmWorkCalendar.do?cmd=getWtmWorkCalendarDetPlanPopupList', queryStringToJson(p));
		break;
	case 'Clear':
		vacationPlanSheet.RemoveAll();
		break;
	case 'Down2Excel':
		vacationPlanSheet.Down2Excel();
		break;
	}
}

function vacationPlanSheet_OnSearchEnd(code, msg, status, stmsg) {
	if (msg && msg != '') alert(msg);
}

function vacationPlanSheet_OnDbClick(row, col) {
	var p = {
		sdate: vacationPlanSheet.GetCellValue(row, 'sdate'),
		edate: vacationPlanSheet.GetCellValue(row, 'edate'),
		sdateFormat: vacationPlanSheet.GetCellText(row, 'sdate'),
		edateFormat: vacationPlanSheet.GetCellText(row, 'edate')
	};
	closeVacationPlanLayerRtnFunc(p);	
}

</script>
<div class="wrapper">
    <div class="popup_main">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>소속</th>
                		<td><input id="vacationPlanOrgNm" type="text" class="text readonly" readonly /></td>
						<th>사번/성명</th>
                		<td><input id="vacationPlanName" type="text" class="text readonly" readonly /></td>
						<th>년도</th>
                		<td><input id="vacationPlanSearchYear" type="text" class="text" /></td>
                		<td><a href="javascript:vacationPlanAction('Search')" class="button">조회</a></td>
					</tr>
            	</table>
            </div>
        </div>
     	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
                 			<ul>
                     			<li id="txt" class="txt">휴가계획</li>
                 			</ul>
                 		</div>
             		</div>
             		<div id="wtmAttendAppDetLayerSheetArea"></div>
             	</td>
         	</tr>
     	</table>
     	<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:closeVacationPlanLayerRtnFunc();" class="pink large">선택</a>
                 	<a href="javascript:closeVacationPlanLayer();" class="gray large">닫기</a>
             	</li>
         	</ul>
		</div>
	</div>
</div>