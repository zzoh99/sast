<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>건강보험 퇴직정산</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 건강보험 퇴직정산
 * @author JM
-->
<script type="text/javascript">
$(function() {
	
	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:7, MergeSheet:msHeaderOnly};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
	initdata.Cols = [
		{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"사번",				Type:"Text",		Hidden:0,				Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"성명",				Type:"Text",		Hidden:0,				Width:80,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"주민번호",			Type:"Text",		Hidden:0, Width:120, Align:"Center",	ColMerge:0,	SaveName:"resNo",		KeyField:0,	Format:"IdNo",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"소속",				Type:"Text",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"직책",				Type:"Text",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"직위",				Type:"Text",		Hidden:1,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"직급",				Type:"Text",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"호봉",				Type:"Text",		Hidden:1,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"salClass",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"직무",				Type:"Text",		Hidden:1,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"사원구분",			Type:"Text",		Hidden:0,				Width:100,			Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"입사일",			Type:"Date",		Hidden:0,				Width:90,			Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"그룹입사일",		Type:"Date",		Hidden:0,				Width:90,			Align:"Center",	ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0 },
		{Header:"근무일수",		Type:"Text",		Hidden:0,				Width:80,			Align:"Center",	ColMerge:0,	SaveName:"workDay",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
		{Header:"임원가산배수",		Type:"Text",		Hidden:0,				Width:80,			Align:"Center",	ColMerge:0,	SaveName:"imwonAddRate",	KeyField:0,	Format:"float",			PointCount:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"기산시작일",		Type:"Date",		Hidden:0,				Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sepSymd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"기산종료일",		Type:"Date",		Hidden:0,				Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sepEymd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"급여(1년)",		Type:"Int",			Hidden:0,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"year1Mon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"상여(1년)",		Type:"Int",			Hidden:0,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"year1Bonus",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"미사용 연차수당\n(전년)",	Type:"Int",			Hidden:0,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"prevYeonchaMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"합계",			Type:"Int",			Hidden:0,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"hapMon",			KeyField:0, CalcLogic:"|year1Mon|+|year1Bonus|+|prevYeonchaMon|", 	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"당월추계액",		Type:"Int",			Hidden:0,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"thisRetMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"전월추계액",		Type:"Int",			Hidden:0,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"prevRetMon",		KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"당월불입액\n(당월-전월)",			Type:"Int",			Hidden:0,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"chaMon", KeyField:0,	CalcLogic:"|thisRetMon|-|prevRetMon|", Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"근속1년\n이상여부", Type:"CheckBox",	Hidden:1,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"over1yearYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
		{Header:"비고",				Type:"Text",		Hidden:0,				Width:100,			Align:"Left",	ColMerge:0,	SaveName:"bigo",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
		{Header:"마감",				Type:"CheckBox",	Hidden:0,				Width:100,			Align:"Right",	ColMerge:0,	SaveName:"magamYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" }
	]; IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(0);

	
	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 최근급여일자 조회
	getCpnLatestPaymentInfo();
	
	//Autocomplete	
	$(sheet1).sheetAutocomplete({
		Columns: [
			{
				ColSaveName  : "name",
				CallbackFunc : function(returnValue) {
					var rv = $.parseJSON('{' + returnValue+ '}');
					sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
					sheet1.SetCellValue(gPRow, "name", rv["name"]);
					sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
					sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
					sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
					sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
					sheet1.SetCellValue(gPRow, "salClass", rv["salClass"]);
					sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"]);
					sheet1.SetCellValue(gPRow, "manageNm", rv["manageNm"]);
					sheet1.SetCellValue(gPRow, "empYmd", rv["empYmd"]);
					sheet1.SetCellValue(gPRow, "gempYmd", rv["gempYmd"]);
				}
			}
		]
	});

	$(window).smartresize(sheetResize);
	sheetInit();

	$("#searchSabunName, #searchOrgNm").bind("keyup",function(event){
		if (event.keyCode == 13) {
			doAction("Search");
		}
	});
});

function chkInVal(sAction) {
	if ($("#payActionCd").val() == "" ) {
        alert("정산일자를 선택하시기 바랍니다.");
        $("#searchBaseYmd").focus();
        return false;
    } 
	return true;
}

function doAction(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			sheet1.DoSearch("${ctx}/SepDcCalcMgr.do?cmd=getSepDcCalcMgrList", $("#sheet1Form").serialize());
			break;

		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/SepDcCalcMgr.do?cmd=saveSepDcCalcMgr", $("#sheet1Form").serialize());
			break;

		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SelectCell(Row, 2);
			break;

		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 2);
			sheet1.SetCellValue(Row, "seq","");
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
			
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"3|15|16|17|18|19|20|21|22|23|24|25|27"});
			break;
	}
}


// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try { 
		
		if (Msg != "") 
		{
			alert(Msg); 
		} else {
			
			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				if(sheet1.GetCellValue(i, "magamYn") == "Y") {
					sheet1.SetRowEditable(i, 0);
					sheet1.SetCellEditable(i, "magamYn", 1); 
				}
			}
			
		}
		sheetResize();
	
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

// 저장 후 메시지
function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try { 
		if (Msg != "") { 
			alert(Msg); 
		}
		doAction("Search");
	} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
}

function sheet1_OnPopupClick(Row, Col) {
	try{
	}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
}

function sheet1_OnChange(Row, Col, Value) {
}


//급여일자 검색 팝입
function payActionSearchPopup() {
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "payDayPopup";

	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			payCd : 'S7' // 급여구분(00004.퇴직금)
		}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					$("#payActionCd").val(result.payActionCd);
					$("#payActionNm").val(result.payActionNm);

					if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
						doAction("Search");
					}
				}
			}
		]
	});
	layerModal.show();


}

	// 초기화
function clearCode(num) {

	if(num == 1) {
		//급여일자
		$('#payActionCd').val("");
	}
}

function getReturnValue(returnValue) {
}

//최근급여일자 조회
function getCpnLatestPaymentInfo() {
	var procNm = "최근급여일자";
	// 급여구분(C00001-00004.퇴직금)
	var paymentInfo = ajaxCall("${ctx}/SepDcCalcMgr.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&runType=&procNm="+procNm+"&payCd=S7", false);

	if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
		$("#payActionCd").val(paymentInfo.DATA[0].payActionCd);
		$("#payActionNm").val(paymentInfo.DATA[0].payActionNm);

		if ($("#payActionCd").val() != null && $("#payActionCd").val() != "") {
			doAction("Search");
		}
	} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
		alert(paymentInfo.Message);
	}
}

function callProc(gubun) {
	
	if (!chkInVal("")) {
		return;
	} else{
		
		var temp = "";
		if(gubun == "1") {temp = "연차기산일 생성";}
		 else if (gubun == "2")  {temp = "급/상여 생성";}
		 else if (gubun == "3")  {temp = "추계액 계산";}
		 else if (gubun == "4")  {temp = "마감";}
		 else if (gubun == "5")  {temp = "마감취소";}
		 else if (gubun == "6")  {temp = "전체삭제";}
		 else {temp = "정산금액 계산"}
		
		if(sheet1.RowCount("U") + sheet1.RowCount("I") + sheet1.RowCount("D") > 0 ) {
			alert("저장되지 않은 항목이 있습니다. ");
			return;
		}
		
		
		if (confirm(temp + " 작업을 진행하시겠습니까?")) {
			var params = "payActionCd="+$("#payActionCd").val() ;
				params +=  "&gubun="+gubun;
			
			var ajaxCallCmd = "callP_CPN_SEP_DC_MON";
			
			var data = ajaxCall("/SepDcCalcMgr.do?cmd="+ajaxCallCmd, params, false);
	
			if(data.Result.Code == null) {
				msg = "작업이 완료 되었습니다." ;
				doAction("Search");
			} else {
				msg = temp + "작업 도중 : "+data.Result.Message;
			}
		}
	}
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>급여일자</th>
                        <td> 
                        	<input type="hidden" id="payActionCd" name="payActionCd" value="" />
							<input type="text" id="payActionNm" name="payActionNm" class="text required readonly w180" value="" readonly />
							<a href="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<input type="hidden" id="payPeopleStatus" name="payPeopleStatus" value="" />
							<input type="hidden" id="payCd" name="payCd" value="" />
							<input type="hidden" id="closeYn" name="closeYn" value="" />
                        </td>
                        <th>사번/성명 </th>
                        <td>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
	                    </td>
	                    <th>소속</th>
                        <td>
	                        <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" />
	                    </td>
	                    <td><a href="javascript:doAction('Search')" id="btnSearch" class="btn dark">조회</a></td>
                    </tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">DC퇴직추계계산</li>
							<li class="btn">
								<a href="javascript:callProc('1')"				class="btn filled authA">1. 연차기산일생성</a>
								<a href="javascript:callProc('2')"				class="btn filled authA">2. 급/상여 생성</a>
								<a href="javascript:callProc('3')"				class="btn filled authA">3. 추계액 계산</a>
								<a href="javascript:callProc('4')"				class="btn filled authA">마감</a>
								<a href="javascript:callProc('5')"				class="btn filled authA">마감취소</a>
								<a href="javascript:doAction('LoadExcel')" 		class="btn outline_gray authA">업로드</a>
								<a href="javascript:doAction('DownTemplate')"	class="btn outline_gray authA">양식다운로드</a>
								<a href="javascript:doAction('Insert')"			class="btn outline_gray authA">입력</a>
								<a href="javascript:doAction('Copy')"			class="btn outline_gray authA">복사</a>
								<a href="javascript:doAction('Save')"			class="btn filled authA">저장</a>
								<a href="javascript:doAction('Down2Excel')"		class="btn outline_gray authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
