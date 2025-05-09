// popup 관련 변수
var gPRow = '', pGubun = '';
var progressPop = null;

//대상SHEET, 자료집계SHEET, 예외처리MASTER_SHEET, 예외처리DETAIL SHEET, 급여계산  SHEET 이체자료 SHEET
var targetSheet, dataSheet, exMSheet, exDSheet, calcSheet, transSheet;

let tabMenuIdx = 0;

$(document).ready(function () {
	//1depth 탭
	$('#payTab a').on('click', function() {
		$('#payTab a').removeClass('active');
		$(this).addClass('active');
		const idx = $(this).index('a');
		if (idx == 0) {
			goList();
		} else {
			const title = $(this).find('div b').text();
			$('#contentTitle').text(title);
			$('main.main_tab_content').hide();
			$('main.main_tab_content:eq(' + (idx - 1) + ')').show(100, () => { sheetResize(); });
		}
	});
	
	//급여계산 첫번째 화면 활성화
	$('.target_create_content').show();
	
	//급여계산 2depth 탭
	$('.top_area .tab_wrap .tab_menu').on('click', function() {
		$('.top_area .tab_wrap .tab_menu').removeClass('active');
		$(this).addClass('active');
		const idx = $(this).index('.tab_menu');
		tabMenuIdx = idx;
		$('#payCalcContents section.sheet_section').hide();
		$('#payCalcContents section.sheet_section:eq(' + idx + ')').show(10, () => { sheetResize(); });
		
		if (idx === 0) targetAction('Search');
		if (idx === 3) calcAction('Search');
		setPayAction();
	});
	
	//수당예외처리 action
	$('#exName').on('keyup', function(e) {
		if (e.keyCode == 13) exSearch();
		$(this).focus();
	});
	
	//추가 버튼 활성화
	onTargetAddBtn();
	
	//payAction Data Setting
	setPayAction();
	
	//대상자 SHEET 생성
	createTargetSheet();
	initTargetTabEvent();
	
	//자료집계 SHEET 생성
	createDataSheet();
	
	//예외관리 SHEET 생성
	createExSheet();
	initExTabEvent();
	
	//급여계산 SHEET 생성
	createCalcSheet();
	initCalcTabEvent();
	
	//이체자료 SHEET 생성
	createTransSheet();
	
	$(window).smartresize(sheetResize);
	sheetInit();
});

function goList() {
	const uri = '/PayCalculator.do?cmd=viewPayCalculator';
	const top = window.top;
	const name = window.name;
	if (top.parent) {
		if (typeof top.parent.submitCall != 'undefind') {
			const form = top.parent.$('#subForm');
			top.parent.submitCall(form, name, 'post', uri);
		}
	}
}

/**
 * 기본정보 가져오기
 * 
 * @returns
 */
function getPayAction() {
	var data = ajaxCall(ctx + "/PayCalculator.do?cmd=getPayAction", queryStringToJson({payActionCd: payAction.payActionCd}), false).DATA;
	payAction = data.payAction;
	basic = data.basic;
	setPayAction();
}

function setPayAction() {
	$('#payActionDay').text(payAction.payActionNm);
	$('#payActionCd').val(payAction.payActionCd);
	$('#closeYn').val(payAction.closeYn);
	
	// 급여마감 버튼 처리
	if (tabMenuIdx === 3) {
		// 급여계산 탭
		if(payAction.closeYn === 'N') {
			$('#calcEndBtn').show();
			$('#calcEndCancelBtn').hide();
		} else {
			$('#calcEndBtn').hide();
			$('#calcEndCancelBtn').show();
		}
	} else {
		$('#calcEndBtn').hide();
		$('#calcEndCancelBtn').hide();
	}
}

//대상자 TAB
function onTargetAddBtn() {
	// 드롭다운
	let $addButton = $("#targetAddBtn > button");
	let $options = $("#targetAddBtn > .select_options");
	let $option = $('#targetAddBtn > .select_options > .option');
	
	$addButton.click(function (e) {
	    e.stopPropagation();
	    if ($options.css("visibility") === "hidden") {
	      $options.css("visibility", "visible");
	    } else {
	      $options.css("visibility", "hidden");
	    }
	});
	
	$option.click(function (e) {
		e.stopPropagation();
		$options.css("visibility", "hidden");
	});
	
	$(document).click(function (e) {
	    if (!$(e.target).closest(".custom_select").length) {
	      $options.css("visibility", "hidden");
	    }
	});
}


function createTargetSheet() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:10, SmartResize:1, FrozenCol:10, SizeMode:0};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",		Type:noColTy,	Hidden:noColHdn,	Width:noColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:delColTy,	Hidden:0,					Width:delColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:stColTy,	Hidden:0,					Width:stColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"급여계산코드",	Type:"Text",		Hidden:1,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"payActionCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"작업\n대상",	Type:"CheckBox",	Hidden:1,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"작업",		Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatusText",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"계산/취소",	Type:"Html",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnPrt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"급여사업장",	Type:"Combo",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },		
		{Header:"사번",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"최종작업시간",	Type:"Text",		Hidden:0,	Width:150,			Align:"Center",	ColMerge:0,	SaveName:"chkdate",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },		
		{Header:"주민번호",		Type:"Text",		Hidden:1,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"resNo",				KeyField:0,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"소속",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"코스트센터",	Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"ccCd",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"급여유형",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"호봉",			Type:"Text",		Hidden:0,				Width:60,			Align:"Center",	ColMerge:0,	SaveName:"salClass",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"직위",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직책",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직급",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직무",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jobNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직구분",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"계약유형",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"재직상태",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"statusCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"입사일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"그룹입사일",	Type:"Date",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"퇴사일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"retYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"변경전급여대상자상태",	Type:"Text",	Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"oldPayPeopleStatus",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"계산상태",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"status",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	];
	IBS_InitSheet(targetSheet, initdata); 
	targetSheet.SetCountPosition(4); 
	targetSheet.SetEditable(true);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직구분코드(H10050)
	var workType = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
	targetSheet.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});

	// 직책코드(H20020)
	var jikchakCd = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
	targetSheet.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});
	
	// 직급코드(H20010)
	var jikgubCd = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	targetSheet.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
	targetSheet.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	// 계약유형코드(H10030)
	var manageCd = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	targetSheet.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});
	
	// 급여유형코드(H10110)
	var payType = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H10110"), "");
	targetSheet.SetColProperty("payType", {ComboText:"|"+payType[0], ComboCode:"|"+payType[1]});	

	// 재직상태코드(H10010)
	var statusCd = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
	targetSheet.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

	// 사업장(TCPN121)
	var tcpn121Cd = convCode(ajaxCall(ctx + "/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
	targetSheet.SetColProperty("businessPlaceCd", {ComboText:"|"+tcpn121Cd[0], ComboCode:"|"+tcpn121Cd[1]});

	// 코스트센터(TORG109)
	var torg109Cd = convCode(ajaxCall(ctx + "/CommonCode.do?cmd=getCommonNSCodeList&mapTypeCd=300", "queryId=getTorg109List", false).codeList, "");
	targetSheet.SetColProperty("ccCd", {ComboText:"|"+torg109Cd[0], ComboCode:"|"+torg109Cd[1]});

	$(targetSheet).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue) {
					var rv = $.parseJSON('{' + returnValue+ '}');
					targetSheet.SetCellValue(gPRow, "name",		rv["name"] );
					targetSheet.SetCellValue(gPRow, "sabun",		rv["sabun"] );
					targetSheet.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
					targetSheet.SetCellValue(gPRow, "workType",	rv["workType"] );
					targetSheet.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"] );
					targetSheet.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"] );
					targetSheet.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"] );
					targetSheet.SetCellValue(gPRow, "payType",	rv["payType"] );
					targetSheet.SetCellValue(gPRow, "manageCd",	rv["manageCd"] );
					targetSheet.SetCellValue(gPRow, "statusCd",	rv["statusCd"] );
					targetSheet.SetCellValue(gPRow, "empYmd",	rv["empYmd"] );
					targetSheet.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"] );
					targetSheet.SetCellValue(gPRow, "resNo",	rv["resNo"] );
					targetSheet.SetCellValue(gPRow, "businessPlaceCd",	rv["businessPlaceCd"] );
					targetSheet.SetCellValue(gPRow, "ccCd",	rv["ccCd"] );
					targetSheet.SetCellValue(gPRow, "jobNm",	rv["jobNm"] );
				}
			}
		]
	});
	
	targetAction('Search');
}

function initTargetTabEvent() {
	$("#targetName").on("keyup", function(e) {
		if (e.keyCode === "13") {
			targetAction('Search');
		}
	});
}

function targetParam() {
	return {
		payActionCd: payAction.payActionCd,
		closeYn: payAction.closeYn,
		businessPlaceCd: $('#targetBusinessPlaceCd').val(),
		sabunName: $('#targetName').val()
	};
}

function dataParam() {
	return {
		...payAction,
		businessPlaceCd: $('#dataBusinessPlaceCd').val()
	};
}

function targetAction(action) {
	switch(action) {
		case 'Search': 
			targetSheet.ClearHeaderCheck();
			targetSheet.DoSearch('/PayCalculator.do?cmd=getPayCalcCrePeopleSetList', queryStringToJson(targetParam()));
			break;
		case 'PrcP_CPN_CAL_EMP_INS': 
			if (payAction.closeYn == 'Y') {
				alert('급여가 이미 마감되었습니다.');
				return;
			}
			if (targetSheet.RowCount() > 0 && !confirm('이미 대상자가 존재합니다. 덮어쓰시겠습니까?')) return;
			if (confirm('[작업]을 실행하시겠습니까?')) {
				progressBar(true, "Please Wait...");
				setTimeout(() => {
					var rcd = ajaxCall(ctx + "/PayCalculator.do?cmd=prcP_CPN_CAL_EMP_INS", queryStringToJson(targetParam()), false);
					if (rcd && rcd.Result && rcd.Result.Code != null) {
						if (rcd.Result.Code == '0') {
							alert('급여대상자 생성 되었습니다.');
							targetAction('Search');
							getPayAction();
						} else if (rcd.Result.Message && rcd.Result.Message != '') {
							alert(rcd.Result.Message);
						}
					} else {
						alert('급여대상자 생성 오류입니다.');
					}
					progressBar(false);
				}, 1000);
			}
			break;
		case 'Save':
			if (payAction.closeYn == 'Y') {
				alert('급여가 이미 마감되었습니다.');
				return;
			}
			
			if (targetSheet.RowCount() > 0) {
				for ( var i = targetSheet.HeaderRows(); i < targetSheet.RowCount() + targetSheet.HeaderRows(); i++){
					if(targetSheet.GetCellValue(i, "payActionCd") == "" ) {
						targetSheet.SetCellValue(i, "payActionCd", payAction.payActionCd);
					}
				}
			}
			
			IBS_SaveName(document.targetForm, targetSheet);
			const param = {
				...targetParam(),
				...formToJson($('#targetForm'))
			};
			console.log(param);
			targetSheet.DoSave(ctx + '/PayCalculator.do?cmd=savePayCalcCrePeopleSet', queryStringToJson(param));
			break;
		case 'Insert':
			if (payAction.closeYn == 'Y') {
				alert('급여가 이미 마감되었습니다.');
				return;
			}
			var row = targetSheet.DataInsert(0);
			targetSheet.SetCellValue(row, 'payActionCd', payAction.payActionCd);
			targetSheet.SelectCell(row, 2);
			break;
		case 'Down2Excel':
			var downcol = makeHiddenSkipCol(targetSheet);
			var p = {DownCols: downcol, SheetDesign: 1, Merge: 1};
			targetSheet.Down2Excel(p);
			break;
		case 'DownTemplate':
			targetSheet.Down2Excel({SheetDesign: 1, Merge: 1, DownRows: '0', DownCols: '8'});
			break;
		case 'LoadExcel':
			targetSheet.LoadExcel({});
			break;
		
	}
}

function targetSheet_OnClick(Row, Col, Value) {
	try{
		if (targetSheet.ColSaveName(Col) == "btnPrt" && Row != 0){
			var sabun = targetSheet.GetCellValue( Row, "sabun");
			if(targetSheet.GetCellValue(Row, "status") == "J" && payAction.closeYn != "Y" ){
				calcCancel(sabun);
			}else if(targetSheet.GetCellValue(Row, "status") == "P" && payAction.closeYn != "Y" ){
				calc(sabun);
			}
		}
	} catch(ex){alert("OnClick Event Error : " + ex);}
}

function targetSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
        if (Msg != "") alert(Msg);
        for ( var i = targetSheet.HeaderRows(); i < targetSheet.RowCount()+targetSheet.HeaderRows(); i++){
        	if(payAction.closeYn == 'Y'){
        		targetSheet.SetCellEditable(i,"sDelete", 0);
        	} else if(payAction.closeYn == 'N'){
        		if(targetSheet.GetCellValue(i, "status") == "J"){
        			targetSheet.SetCellEditable(i,"sDelete",0);
                }
                
                if(targetSheet.GetCellValue(i, "status") == "J"){
                	targetSheet.SetCellEditable(i,"sDelete",0);
                	targetSheet.SetCellValue(i, "btnPrt", '<a class="basic">계산취소</a>');
                	targetSheet.SetCellValue(i, "sStatus", 'R');
                }else if(targetSheet.GetCellValue(i, "status") == "P"){
                	targetSheet.SetCellValue(i, "btnPrt", '<a class="basic">계산</a>');
                	targetSheet.SetCellValue(i, "sStatus", 'R');
                }	
        	}
        }
        
        const rcount = targetSheet.RowCount().toLocaleString('ko-KR');
        $('#targetSheetCount').text(rcount);
        if (targetSheet.RowCount() != 0) $('#payActionTarget').html(`대상자: ${rcount}명`);
        else $('#payActionTarget').empty();
        sheetResize();
    } catch (ex) {
        alert("OnSearchEnd Event Error : " + ex);
    }
}

function openTargetAddModal() {
	var url = ctx + '/PayCalculator.do?cmd=viewPayTargetAddLayer';
	var args = { payActionCd: payAction.payActionCd };
	var payTargetAddLayer = new window.top.document.LayerModal({
			id: 'payTargetAddLayer',
			url: url,
			parameters: args,
			width: 800,
			height: 820,
			title: "대상자 검색",
			trigger: [
				{ name: 'payTargetAddLayerTrigger', callback: function(rv) { targetAction('Search'); } }
			]
		});
	payTargetAddLayer.show();
}

function createDataSheet() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, SmartResize:1};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",		Type:noColTy,	Hidden:noColHdn,	Width:noColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:delColTy,	Hidden:1,					Width:delColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",		Type:stColTy,	Hidden:1,					Width:stColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"사업장",		Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"복리후생업무구분", Type:"Combo",     Hidden:0,  					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"benefitBizCd",	KeyField:0, Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"마감상태",		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"closeSt",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"최종작업시간",	Type:"Text",		Hidden:0,	Width:150,			Align:"Center",	ColMerge:0,	SaveName:"chkdate",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },
		{Header:"연계처리",		Type:"CheckBox",	Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }
	]; 
	IBS_InitSheet(dataSheet, initdata); 
	dataSheet.SetCountPosition(0);
	
	// 사업장(TCPN121)
	var tcpn121Cd = convCode(ajaxCall(ctx + "/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
	dataSheet.SetColProperty("businessPlaceCd", {ComboText:tcpn121Cd[0], ComboCode:tcpn121Cd[1]});

	//복리후생업무구분(B10230)
	var benefitBizCdList = convCode( codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList","B10230"), "");
	dataSheet.SetColProperty("benefitBizCd", {ComboText:benefitBizCdList[0], ComboCode:benefitBizCdList[1]} );

	// 마감상태코드(S90003)
	var closeSt = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "S90003"), "");
	dataSheet.SetColProperty("closeSt", {ComboText:closeSt[0], ComboCode:closeSt[1]});
	
	dataAction('Search');
}

function dataAction(action) {
	switch (action) {
		case 'Search':
			dataSheet.DoSearch(ctx + "/PayCalculator.do?cmd=getPayCalcCreCloseList", queryStringToJson(dataParam()), false);
			break;
		case 'PrcP_BEN_PAY_DATA_CREATE_ALL':
			if (payAction.closeYn == 'Y') {
				alert('급여가 이미 마감되었습니다.');
				return;
			}
			if (confirm('모든 복리후생 연계자료의 마감이 취소되고 재생성됩니다. 복리후생 데이터 생성작업을 실행하시겠습니까?')) {
				//show loading
				progressBar(true, "Please Wait...");
				setTimeout(async () => {
					const r = ajaxCall(ctx + "/PayCalculator.do?cmd=prcP_BEN_PAY_DATA_CREATE_ALL", "payActionCd=" + payAction.payActionCd, false);
					if (r && r.Result && r.Result.Code != null) {
						if (r.Result.Code == '0') {
							alert("복리후생 연계자료의 생성이 완료되었습니다. 반드시 급여를 계산하시기 바랍니다.");
							dataAction('Search');
						} else {
							alert(r.Result.Message);
						}
					}
					progressBar(false);
				}, 1000);
			}
			break;
		case 'Down2Excel':
			var downcol = makeHiddenSkipCol(dataSheet);
			var p = {DownCols: downcol, SheetDesign: 1, Merge: 1};
			dataSheet.Down2Excel(p);
			break;
	}
}

function createExSheet() {
	//MASTER SHEET CREATE
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",		Type:noColTy,	Hidden:noColHdn,	Width:noColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:delColTy,	Hidden:0,					Width:delColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",		Type:stColTy,	Hidden:0,					Width:stColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"급여코드",      Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"payActionCd",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
		{Header:"급여년월",      Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"payYm",         KeyField:0,   CalcLogic:"",   Format:"Ym",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:8 },
		{Header:"급여구분코드",  Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payCd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"급여구분",      Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"payNm",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		{Header:"항목코드",      Type:"Text",      Hidden:0,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
		{Header:"항목명",        Type:"Popup",     Hidden:0,  Width:200,  Align:"Center",  ColMerge:0,   SaveName:"elementNm",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50 },
		{Header:"급여일자",      Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"payActionNm",   KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 },
		{Header:"마감여부",      Type:"Text",      Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"closeYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
	]; 
	IBS_InitSheet(exMSheet, initdata);
	exMSheet.SetEditable(exEditable);
	exMSheet.SetVisible(true);
	exMSheet.SetCountPosition(4);

	var userCd 	= convCode( codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "TST01"), "전체");
	exMSheet.SetColProperty("col5", 			{ComboText:"사용|사용안함", ComboCode:"Y|N"} );
	exMSheet.SetColProperty("col6", 			{ComboText:userCd[0], ComboCode:userCd[1]} );
	
	//DETAIL SHEET CREATE
	initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",		Type:noColTy,	Hidden:noColHdn,	Width:noColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:delColTy,	Hidden:0,					Width:delColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",			Sort:0 },
		{Header:"상태",		Type:stColTy,	Hidden:0,					Width:stColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",			Sort:0 },
		{Header:"급여계산코드",	Type:"Text",		Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"payActionCd"  ,  KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"항목코드",	Type:"Combo",		Hidden:0,  Width:150,    Align:"Center",  ColMerge:0,   SaveName:"elementCd",      KeyField:1,   CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"성명",		Type:"Text",		Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"name",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
		{Header:"사번",		Type:"Text",		Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"sabun",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
		{Header:"금액",		Type:"Int",			Hidden:0,  Width:120,  Align:"Right",   ColMerge:0,   SaveName:"paymentMon",     KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
		{Header:"비고",		Type:"Text",		Hidden:0,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"note",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
		{Header:"비고공지여부",	Type:"CheckBox",	Hidden:0,  Width:80 ,  Align:"Center", 	ColMerge:0,	  SaveName:"noteNotifyYn",	 KeyField:0,   CalcLogic:"",   Format:"",			 PointCount:0,	 UpdateEdit:1, InsertEdit:1, EditLen:50,TrueValue:"Y", FalseValue:"N"},
		{Header:"마감여부",	Type:"Text",		Hidden:1,  Width:150,  Align:"Center",  ColMerge:0,   SaveName:"closeYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }  ];
	
	IBS_InitSheet(exDSheet, initdata);
	exDSheet.SetEditable(exEditable);
	exDSheet.SetVisible(true);
	exDSheet.SetCountPosition(4);
	
	var elementCd = convCode( ajaxCall(ctx + "/CommonCode.do?cmd=getCommonNSCodeList","queryId=getElementCdList",false).codeList, "");	//일반테이블
	exDSheet.SetColProperty("elementCd", {ComboText:"|"+elementCd[0], ComboCode:"|"+elementCd[1]} );
	
	$(exDSheet).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue) {
					var rv = $.parseJSON('{' + returnValue+ '}');
					exDSheet.SetCellValue(gPRow, "name", rv["name"]);
					exDSheet.SetCellValue(gPRow, "sabun", rv["sabun"]);
				}
			}
		]
	});
	
	exMAction('Search');
}

function initExTabEvent() {
	$("#exName").on("keyup", function(e) {
		if (e.keyCode === 13) {
			exMAction('Search');
		}
	});
}


function exSearch() {
	var name = $('#exName').val();
	if (name) {
		exDAction('Search');
	} else {
		exMAction('Search');
	}
}

function exParam(div) {
	return div == 'M' ? {
		searchPayActionCdHidden: payAction.payActionCd,
		searchElementNm: $('#exElementNm').val()
	} : {
		searchPayActionCd2: payAction.payActionCd,
		searchName: $('#exName').val()
	};
}

function exMAction(action) {
	switch (action) {
		case 'Search':
			exMSheet.DoSearch( ctx + "/PayCalculator.do?cmd=getExceAllowMgrFirstList", queryStringToJson(exParam('M'))); 
			exDSheet.RemoveAll();
			break;
		case 'Save':
			if (!dupChk(exMSheet, 'payActionCd|elementCd', false, true)) { break; }
			IBS_SaveName(document.exForm, exMSheet);
			exMSheet.DoSave(ctx + 'PayCalculator.do?cmd=saveExceAllowMgrFirst', $('#exForm').serialize());
			break;
		case 'Insert':
			var row = exMSheet.DataInsert(0);
			exMSheet.SetCellValue(row, "payActionCd", payAction.payActionCd);
			exMSheet.SetCellValue(row, "payActionNm", payAction.payActionNm);
			break;
		case 'Copy':		exMSheet.DataCopy(); break;
		case 'Clear':		exMSheet.RemoveAll(); break;
		case 'Down2Excel' : exMSheet.Down2Excel(); break;
		case 'LoadExel':	var params = {Mode: 'HeaderMatch', WorkSheetNo: 1}; exMSheet.LoadExcel(params); break;
	}
}

function exDAction(action) {
	switch (action) {
		case 'Search':
			var payActionCd = exMSheet.GetCellValue(exMSheet.GetSelectRow(), 'payActionCd');
			var element = exMSheet.GetCellValue(exMSheet.GetSelectRow(), 'elementCd');
			const p = {
				...exParam('D'),
				searchPayActionCd2: payActionCd,
				searchElementCd2: element
			};
			exDSheet.DoSearch( ctx + "/PayCalculator.do?cmd=getExceAllowMgrSecondList", queryStringToJson(p));
			break;
		case 'Save':
			for (var r = 1; r <= exMSheet.RowCount(); r++) {
				exDSheet.SetCellValue(r, "payActionCd", exMSheet.GetCellValue( exMSheet.GetSelectRow(), "payActionCd"));
				exDSheet.SetCellValue(r, "elementCd", exMSheet.GetCellValue( exMSheet.GetSelectRow(), "elementCd"));
			}
			
			if (!dupChk(exDSheet, 'payActionCd|elementCd|sabun', false, true)) { break; }
			IBS_SaveName(document.exForm, exDSheet);
			exDSheet.DoSave(ctx + '/PayCalculator.do?cmd=saveExceAllowMgrSecond', $('#exForm').serialize());
			break;
		case 'Insert':
			if (exMSheet.RowCount() == 0) {
				alert('MASTER 데이터를 선택하세요.');
				return;
			} else {
				var row = exDSheet.DataInsert(0);
				exDSheet.SetCellValue(row, "payActionCd", exMSheet.GetCellValue( exMSheet.GetSelectRow(), "payActionCd"));
				exDSheet.SetCellValue(row, "elementCd", exMSheet.GetCellValue( exMSheet.GetSelectRow(), "elementCd"));
			}
			break;
		case "Copy":		exDSheet.DataCopy(); break;
		case "Clear":		exDSheet.RemoveAll(); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(exDSheet);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			exDSheet.Down2Excel(param); break;
		case "LoadExcel":
			if(exMSheet.RowCount()==0){
        		alert("Master 데이터를 선택 하세요.");
        		return;
        	}
			var params = {};
			exDSheet.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			exDSheet.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|name|paymentMon|note"});
			break;
	}
}

function exMSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	if (Msg != '') { alert(Msg); }
	sheetResize();
	exDAction('Search');
}

function exMSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); }  exMAction('Search'); exDSheet.RemoveAll(); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function exMSheet_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		// Insert KEY
		if (Shift == 1 && KeyCode == 45) {
			exMAction("Insert");
		}
		//Delete KEY
		if (Shift == 1 && KeyCode == 46 && exMSheet.GetCellValue(Row, "sStatus") == "I") {
			exMSheet.SetCellValue(Row, "sStatus", "D");
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

function exMSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
	exDAction('Search');
}

function exMSheet_OnPopupClick(Row, Col) {
	var colname = exMSheet.ColSaveName(Col);
	var args = {
		elementCd: exMSheet.GetCellValue(Row, "elementCd"),
		elementNm: exMSheet.GetCellValue(Row, "elementNm")
	};
	
	if (colname == 'elementNm') {
		if (!isPopup()) return;
    	let layerModal = new window.top.document.LayerModal({
			id : 'payElementLayer', 
			url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=' + authPg, 
			parameters : args, 
			width : 840, 
			height : 520, 
			title : '수당,공제 항목', 
			trigger :[
				{
					name : 'payTrigger', 
					callback : function(rv){
						exMSheet.SetCellValue(Row, "elementCd", rv["resultElementCd"] );
						exMSheet.SetCellValue(Row, "elementNm", rv["resultElementNm"] );
					}
				}
			]
		});
		layerModal.show();
	}
	
}

function exDSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

function exDSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		exDAction('Search');
		exMSheet.SetCellValue(exMSheet.GetSelectRow(),"sStatus","R");
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

function exDSheet_OnLoadExcel() {
	if (exMSheet.RowCoun() == 0) {
		alert('MASTER 데이터를 선택하세요.');
		exDSheet.RemoveAll();
		return;
	} else {
		for (var i = 1; i <= exDSheet.RowCount(); i++) {
			exDSheet.SetCellValue(i, "payActionCd", exMSheet.GetCellValue( exMSheet.GetSelectRow(), "payActionCd"));
			exDSheet.SetCellValue(i, "elementCd", exMSheet.GetCellValue( exMSheet.GetSelectRow(), "elementCd"));
		}
	}
}

function exDSheet_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		// Insert KEY
		if (Shift == 1 && KeyCode == 45) {
			exDAction("Insert");
		}
		//Delete KEY
		if (Shift == 1 && KeyCode == 46 && exDSheet.GetCellValue(Row, "sStatus") == "I") {
			exDSheet.SetCellValue(Row, "sStatus", "D");
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

function exDSheet_OnPopupClick(Row, Col) {
	var colname = exDSheet.ColSaveName(Col);
	const args = {
		name: exDSheet.GetCellValue(Row, 'name'),
		sabun: exDSheet.GetCellValue(Row, 'sabun')
	};
	
	if (colname == 'name') {
		if (!isPopup()) return;
		gPRow = Row;
		pGubun = "employeePopup";
		openPopup("/Popup.do?cmd=employeePopup&authPg=" + authPg, args, "840", "520");
	}
}

//항목명 팝업
// function openPayElementPopup(){
// 	if (!isPopup()) return;
// 	gPRow = '';
// 	pGubun = 'payElementPopup';
// 	openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=" + authPg, {}, "940", "520");
// }
//항목명 팝업
function openPayElementPopup(){
	gPRow = '';
	pGubun = 'payElementPopup';
	let layerModal = new window.top.document.LayerModal({
		id : 'payElementLayer'
		, url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=' + authPg
		// , parameters : {
		// 	searchElementLinkType: "C",
		// 	isSep : 'Y'
		// }
		, width : 940
		, height : 520
		, title : '수당,공제 항목'
		, trigger :[
			{
				name : 'payTrigger'
				, callback : function(result){
					// $("#elementCd").val(result.resultElementCd);
					// $("#elementNm ").val(result.resultElementNm);
					getReturnValue(result);
				}
			}
		]
	});
	layerModal.show();

}


function getReturnValue(rv) {
	// var rv = $.parseJSON('{' + returnValue+ '}');
	if (pGubun == 'payElementPopup') {
		console.log(rv)
		$('#exElementNm').val(rv["resultElementNm"]);
		$('#exName').val('');
		exMAction('Search');
	} else if (pGubun == 'employeePopup') {
		exDSheet.SetCellValue(gPRow, "name",   rv["name"] );
		exDSheet.SetCellValue(gPRow, "sabun",  rv["sabun"] );
	} else if (pGubun == 'payElementPopup2') {
		exMSheet.SetCellValue(gPRow, "elementCd",   rv["elementCd"] );
		exMSheet.SetCellValue(gPRow, "exElementNm",  rv["elementNm"] );
	}
}

function createCalcSheet() {
	var titles = ajaxCall(ctx + "/PayCalculator.do?cmd=getPayCalcReCreTitleList", 'payActionCd=' + payAction.payActionCd, false);
	
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:11};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",		Type:noColTy,	Hidden:noColHdn,	Width:noColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:delColTy,	Hidden:0,					Width:delColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:stColTy,	Hidden:0,					Width:stColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"세부\n내역",	Type:"Image",		Hidden:0,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"detail",				Cursor:"Pointer",	EditLen:1 },
		{Header:"급여계산코드",	Type:"Text",		Hidden:1,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"payActionCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"재계산",		Type:"CheckBox",	Hidden:0,					Width:65,			Align:"Center",	ColMerge:0,	SaveName:"reCre",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"대상상태",		Type:"Combo",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatus",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"대상상태",		Type:"Text",		Hidden:1,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"payPeopleStatusNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"사번",		Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sabun",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",		Type:"Text",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"name",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"소속",		Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"orgNm",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"계약유형",	Type:"Combo",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직구분",		Type:"Combo",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"workType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"급여유형",	Type:"Combo",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"payType",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"호봉",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"salClass",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
		{Header:"직급",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"입사일",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"그룹입사일",	Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",				KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
	];
	
	var elementCd = "";
	for(var i=0; i<titles.DATA.length; i++) {
		elementCd = convCamel(titles.DATA[i].elementCd);
		initdata.Cols[i+16] = {Header:titles.DATA[i].elementNm,Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:elementCd,	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
	}
	
	IBS_InitSheet(calcSheet, initdata); 
	calcSheet.SetCountPosition(0);
	calcSheet.SetDataLinkMouse("detail", 1);
	calcSheet.SetImageList(0, ctx + "/common/images/icon/icon_popup.png");

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직구분코드(H10050)
	var workType = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H10050"), "");
	calcSheet.SetColProperty("workType", {ComboText:"|"+workType[0], ComboCode:"|"+workType[1]});
	
	// 계약유형코드(H10030)
	var manageCd = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
	calcSheet.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});
	
	// 급여유형코드(H10110)
	var payType = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H10110"), "");
	calcSheet.SetColProperty("payType", {ComboText:"|"+payType[0], ComboCode:"|"+payType[1]});	

	// 급여대상자상태(C00125)
	var payPeopleStatus = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "C00125"), "");
	calcSheet.SetColProperty("payPeopleStatus", {ComboText:payPeopleStatus[0], ComboCode:payPeopleStatus[1]});

	// 직급코드(H20010)
	var jikgubCd = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	calcSheet.SetColProperty("jikgubCd", {ComboText:jikgubCd[0], ComboCode:jikgubCd[1]});

	// 직책코드(H20020)
    var jikchakCd = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
    calcSheet.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

    // 직위코드(H20030)
    var jikweeCd = convCode(codeList(ctx + "/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
    calcSheet.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});
	calcAction('Search');
}

function initCalcTabEvent() {
	$("#calcName").on("keyup", function(e) {
		if (e.keyCode === 13) {
			calcAction('Search');
		}
	});
}

function calcParam() {
	return {
		payActionCd: payAction.payActionCd,
		closeYn: payAction.closeYn,
		businessPlaceCd: $('#calcBusinessPlaceCd').val(),
		sabunName: $('#calcName').val()
	};
}

function calcAction(action) {
	switch (action) {
		case 'Search':
			calcSheet.ClearHeaderCheck();
			calcSheet.DoSearch('/PayCalculator.do?cmd=getPayCalcReCreList', queryStringToJson(calcParam()));
			break;
		case 'PrcP_CPN_CAL_PAY_MAIN':
			getPayAction();
			if (payAction.closeYn === 'Y') {
				alert('이미 마감되었습니다.');
				return;
			} else if (confirm('[급여계산] 작업을 수행하시겠습니까?')) {
				const ing = ajaxCall('/CommonCode.do?cmd=getCommonNSCodeList&searchBizCd=CPN&searchPrgCd=P_CPN_CAL_PAY_MAIN&searchPayActionCd=' + payAction.payActionCd, 'queryId=getPayCalcMsgYn', false);
				if (ing.codeList[0].code == 'N') {
					if (confirm('이미 실행중입니다. /nClear 후 진행하시겠습니까?')) {
						ajaxCall('/PayCalculator.do?cmd=deleteTSYS904ForPayCalcCre&searchBizCd=CPN&searchPrgCd=P_CPN_CAL_PAY_MAIN&searchPayActionCd=' + payAction.payActionCd, 'queryId=deleteTSYS904ForPayCalcCre', false);
					} else return;
				}
				const p = {
					payActionCd: payAction.payActionCd,
					businessPlaceCd: $('#calcBusinessPlaceCd').val()
				};
				
				$.ajax({
					url: ctx + '/PayCalculator.do?cmd=prcP_CPN_CAL_PAY_MAIN',
					type: 'post',
					dataType: 'json',
					async: true,
					data:  queryStringToJson(p),
					success: (r) => {
						if (r && r.Result && r.Result.Code != null) {
							if (r.Result.Code == '0') {
								progressPop = openProcessBar("1");
							} else if (r.Result.Message && r.Result.Message != '') {
								alert(r.Result.Message);
								calcAction('Search');
							}
						} else {
							alert("급여계산 오류입니다.");
							calcAction('Search');
						}
					},
					error: (jqXHR, ajaxSettings, thrownError) => {
						ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
					}
				});
				
				
			}
			break;
		case 'PrcP_CPN_CAL_PAY_CANCEL':
			getPayAction();
			if (payAction.closeYn == 'Y') {
				alert('이미 마감되었습니다.');
				return;
			}
			
			if (confirm('[급여계산] 작업취소를 수행하시겠습니까?')) {
				const p = {
					payActionCd: payAction.payActionCd,
					businessPlaceCd: $('#calcBusinessPlaceCd').val()
				};
				
				const r = ajaxCall(ctx + "/PayCalcCre.do?cmd=prcP_CPN_CAL_PAY_CANCEL", queryStringToJson(p), false);
				if (r && r.Result && r.Result.Code != null) {
					if (r.Result.Code == '0') {
						alert('급여계산이 취소되었습니다.');
					} else if (r.Result.Message != '') {
						alert(r.Result.Message);
					}
				} else {
					alert('급여계산 취소 중 오류가 발생하였습니다.');
				}
				calcAction('Search');
			}
			break;
		case 'Recalc':
			getPayAction();
			if (payAction.closeYn == 'Y') {
				alert('이미 마감되었습니다.');
				return;
			}
			var count = calcSheet.FindCheckedRow('reCre', { ReturnArray: 1 }).length;
			if (count == 0) {
				alert('선택된 대상자가 없습니다.');
			} else if (confirm('월급여 재계산을 실행하시겠습니까?')) {
				IBS_SaveName(document.calcForm, calcSheet);
				calcSheet.DoSave(ctx + "/PayCalculator.do?cmd=savePayCalcReCre", $("#calcForm").serialize());
			}
			break;
		case 'prcP_CPN_RETRY_PAY_MAIN':
			const p = {
				payActionCd: payAction.payActionCd,
				businessPlaceCd: $('#calcBusinessPlaceCd').val()
			};
			
			const r = ajaxCall(ctx + "/PayCalculator.do?cmd=prcP_CPN_RETRY_PAY_MAIN", queryStringToJson(p), false);
			if (r && r.Result && r.Result.Code != null) {
				if (r.Result.Code == '0') {
					alert('월급여 재계산 되었습니다.');
					calcAction('Search');
				} else if (r.Result.Message != '') {
					alert(r.Result.Message);
				}
			} else {
				alert('월급여 재계산 중 오류가 발생하였습니다.');
			}
			break;
		case 'Close':
			getPayAction();
			if (payAction.closeYn == 'Y') {
				alert('이미 마감되었습니다.');
				return;
			}
			if (basic.peopleSubCnt != basic.peopleJCnt) {
				alert('대상인원과 작업완료인원이 일치하지 않습니다.\n마감할 수 없습니다.');
				return;
			}
			if (confirm('[마감] 작업을 수행하시겠습니까?')) {
				const r = ajaxCall(ctx + "/PayCalculator.do?cmd=saveCpnQuery", "queryId=saveCpnCloseYn&closeYn=Y&payActionCd="+payAction.payActionCd, false);
				if (r && r.Result && r.Result.Code != '') {
					if (r.Result.Message && r.Result.Message != '') {
						alert(r.Result.Message);
					}
					if (parseInt(r.Result.Code) > 0) {
						getPayAction();
						calcAction('Search');
					}
				} else {
					alert('마감 오류입니다.');
				}
			}
			break;
		case 'CancelClose':
			getPayAction();
			if (payAction.closeYn == 'N') {
				alert('마감되지 않은 급여계산 작업입니다.');
				return;
			}
			
			if (confirm('[마감취소] 작업을 수행하시겠습니까?')) {
				const r = ajaxCall(ctx + "/PayCalculator.do?cmd=saveCpnQuery", "queryId=saveCpnCloseYn&procNm=2&closeYn=N&payActionCd="+payAction.payActionCd, false);
				if (r && r.Result && r.Result.Code != '') {
					if (r.Result.Message && r.Result.Message != '') {
						alert(r.Result.Message);
					}
					if (parseInt(r.Result.Code) > 0) {
						getPayAction();
						calcAction('Search');
					}
				} else {
					alert('마감취소 오류입니다.');
				}
			}
			break;
			
	}
}

function calcComplete() {
	alert('급여계산 작업이 완료되었습니다.');
	progressPop.close();
	progressPop = null;
	calcAction('Search');
}

//작업 프로그램 진행현황 팝업
function openProcessBar(actYn) {
	if(!isPopup()) {return;}
	var args    = {
		prgCd: "P_CPN_CAL_PAY_MAIN",
		payActionCd: payAction.payActionCd,
		payActionNm: payAction.payActionNm,
		businessPlaceCd: $('#calcBusinessPlaceCd').val(),
		actYn: actYn
	};
	let layerModal = new window.top.document.LayerModal({
		id : 'processBarLayer', 
		url : '/CpnComPopup.do?cmd=viewCpnProcessBarComLayer&authPg=R', 
		parameters :args, 
		width : 470, 
		height : 375, 
		title : "진행상태",
		trigger: [
			{
				name: 'processBarLayerTrigger',
				callback: function() {
					calcAction('Search');
				}
			}
		]
	});
	layerModal.show();
}

function calcSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		var nocalcCount = 0;
        if (Msg != "") alert(Msg);
        for ( var i = calcSheet.HeaderRows(); i < calcSheet.RowCount() + calcSheet.HeaderRows(); i++){
        	if(payAction.closeYn == 'Y'){
        		calcSheet.SetCellEditable(i,"sDelete", 0);
        	} else if(payAction.closeYn == 'N'){
        		if(calcSheet.GetCellValue(i, "payPeopleStatus") == "J"){
        			calcSheet.SetCellEditable(i,"sDelete", 0);
                } else {
                	nocalcCount++;
                }
        	}
        }
        
        if (nocalcCount == 0) {
        	$('#calcBtn').hide();
        	$('#calcCancelBtn').show();
        	$('#calcSummaryBtn').show();
        } else {
        	$('#calcBtn').show();
        	$('#calcCancelBtn').hide();
        	$('#calcSummaryBtn').hide();
        }
        
        sheetResize();
    } catch (ex) {
        alert("OnSearchEnd Event Error : " + ex);
    }
}

function calcSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
	console.log('Save End Code', Code);
	if (parseInt(Code) > 0) calcAction('prcP_CPN_RETRY_PAY_MAIN');
	else if (Msg != '') alert(Msg);
}

function calcSheet_OnClick(Row, Col, Value) {
	var colname = calcSheet.ColSaveName(Col);
	if (Row > 0 && colname == 'detail') {
		var sabun = calcSheet.GetCellValue(Row, 'sabun');
		//openPerPayPartiAdminStaSubMain(sabun);
		openPayCalcPopup(sabun);
	}
}

function calcSheet_OnChange(Row, Col, Value) {
	var colName = calcSheet.ColSaveName(Col);
	if (Row > 0) {
		if (colName == "reCre") {
			if (calcSheet.GetCellValue(Row, "reCre") == "1") {
				// 급여대상자상태(C.대상 E.에러 J.작업완료 M.재계산 P.작업대상 PM.작업대상(재계산) W.미확정)
				if (calcSheet.GetCellValue(Row,"payPeopleStatus") == "J") {
					calcSheet.SetCellValue(Row, "payPeopleStatus", "M");
				} else {
					calcSheet.SetCellValue(Row, "payPeopleStatus", "PM");
				}
			} else {
				if (calcSheet.GetCellValue(Row,"payPeopleStatus") == "M") {
					calcSheet.SetCellValue(Row, "payPeopleStatus", "J");
				} else {
					calcSheet.SetCellValue(Row, "payPeopleStatus", "P");
				}
			}
		}
	}
}

function calc(sabun) {
	if (confirm('[급여계산] 작업을 수행하시겠습니까?')) {
		//작업중인 급여 로그가 있는지 확인
		var p = {
			searchBizCd: 'CPN',
			searchPrgCd: 'P_CPN_CAL_PAY_MAIN',
			searchPayActionCd: payAction.payActionCd,
			queryId: 'getPayCalcMsgYn'
		};
		
		var ingYn = ajaxCall('/CommonCode.do?cmd=getCommonNSCodeList', queryStringToJson(p), false);
		if (ingYn.codeList[0].code && ingYn.codeList[0].code == 'N') {
			if (confirm('이미 실행중입니다.\nClear 후 진행하시겠습니까?')) {
				p.queryId = 'deleteTSYS904ForPayCalcCre';
				ajaxCall('/PayCalculator.do?cmd=deleteTSYS904ForPayCalcCre', queryStringToJson(p), false);
			} else {
				return;
			}
		}
		
		var calcparam = {
			payActionCd: payAction.payActionCd,
			businessPlaceCd: $('#targetBusinessPlaceCd').val(),
			sabun: sabun
		};
		
		const d = ajaxCall(ctx + '/PayCalculator.do?cmd=prcP_CPN_CAL_PAY_MAIN2', calcparam, false);
		if (d && d.Result && d.Result.Code != null) {
			if (d.Result.Code == '0') {
				alert('급여계산 되었습니다.');
				targetAction('Search');
				getPayAction();
			} else if (d.Result.Message && d.Result.Message != '') {
				alert(d.Result.Message);
			}
		} else {
			alert('급여계산 오류입니다.');
		}
	}
}

function calcCancel(sabun) {
	if (confirm("[급여계산] 작업취소를 수행하시겠습니까?")) {
		const p = {
			payActionCd: payAction.payActionCd,
			businessPlaceCd: $('#targetBusinessPlaceCd').val(),
			sabun: sabun
		};
		// 작업취소
		var rs = ajaxCall(ctx + "/PayCalculator.do?cmd=prcP_CPN_CAL_PAY_CANCEL2", queryStringToJson(p), false);
		if (rs && rs.Result && rs.Result.Code != null) {
			if (rs.Result.Code == '0') {
				alert('급여계산이 취소되었습니다.');
				targetAction('Search');
				getPayAction();
			} else if (rs.Result.Message && rs.Result.Message != '') {
				alert(rs.Result.Message);
			}
		} else {
			alert("급여계산취소 오류입니다.");
		}
	}
}

function openCalCompleteModal() {
	const url = ctx + '/PayCalculator.do?cmd=viewPayCalcSummaryLayer';
	const { payActionCd, paymentYmd, payActionNm } = payAction;
	const p = { payActionCd, paymentYmd, payActionNm };
	var payCalcSummaryLayer = new window.top.document.LayerModal({
		id: 'payCalcSummaryLayer',
		url: url,
		parameters: p,
		width: 600,
		height: 690,
		title: "급여계산완료"
	});
	payCalcSummaryLayer.show();
}

//개인별급여세부내역 호출
function openPerPayPartiAdminStaSubMain(sabun) {
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "viewPerPayPartiTermAStaPopup";
	var w		= 950;
	var h		= 540;
	var url		= ctx + "/PerPayPartiTermASta.do?cmd=viewPerPayPartiTermAStaPopup";
	var args	= { payActionCd: payAction.payActionCd, sabun: sabun };
	openPopup(url+"&authPg=R", args, w, h);
}

//개인별급여 세부내역 신규 팝업 호출
function openPayCalcPopup(sabun) {
	if(!isPopup()) {return;}
	var w		= 648;
	var h		= 800;
	const args = { payActionCd: payAction.payActionCd, searchSabun: sabun };
	const url = ctx + '/PayCalculator.do?cmd=viewPayCalcLayer';
	var payCalcLayer = new window.top.document.LayerModal({
		id: 'payCalcLayer',
		url: url,
		parameters: args,
		width: w,
		height: h,
		title: "급여계산완료"
	});
	payCalcLayer.show();
	//openPopup(url, args, w, h);
}

//이체자료 SHEET 생성
function createTransSheet() {
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",		Type:noColTy,	Hidden:noColHdn,	Width:noColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",		Type:delColTy,	Hidden:0,					Width:delColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
		{Header:"상태",		Type:stColTy,	Hidden:0,					Width:stColWdt,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
		{Header:"은행코드",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bankCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
		{Header:"은행명",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bankNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
		{Header:"계좌번호",		Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"accountNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
		{Header:"사번",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
		{Header:"성명",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
		{Header:"이체금액",		Type:"AutoSum",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"mon",				KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
	];
	
	IBS_InitSheet(transSheet, initdata);
	transSheet.SetEditable(exEditable);
	transSheet.SetVisible(true);
	transSheet.SetCountPosition(4);
	transAction('Search');
}

function transAction(action) {
	switch (action) {
		case 'Search':
			const p = {
				searchPayActionCd: payAction.payActionCd,
				searchAccountNo: 'N',
				businessPlaceCd: $('#transBusinessPlaceCd').val(),
				searchWord: $('#transName').val()
			};
			transSheet.DoSearch(ctx + '/PayCalculator.do?cmd=getPaymentTransferInfo', queryStringToJson(p));
			transSheet.SetCellValue(transSheet.LastRow(), 3, '합계 : ');
			break;
		case 'Down2Excel':
			var downcol = makeHiddenSkipCol(transSheet);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			transSheet.Down2Excel(param);
			break;
	}
}
