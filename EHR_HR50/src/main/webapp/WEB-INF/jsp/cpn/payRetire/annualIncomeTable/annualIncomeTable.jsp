<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연간소득현황</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var searchAdjustType = "";

	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

		$("#srchYear").mask("0000");

		$("#srchYear").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});

		$("#srchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});

		$("#sumYnCheckbox").bind("change",function(event){
			doAction1("Search");
		});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='appraisalYy' mdef='년도'/>",					Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,SaveName:"workYy",			KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:4},
			{Header:"<sht:txt mid='LAN_V69' mdef='정산구분'/>",					Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,SaveName:"adjustType",		KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:10},
			{Header:"<sht:txt mid='payYmV8' mdef='년월'/>",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ym",				KeyField:0,				Format:"Ym",		PointCount:0,UpdateEdit:0,InsertEdit:1,EditLen:7 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,SaveName:"sabun",			KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:13},
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,SaveName:"name",				KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:100},
			{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",					Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,SaveName:"resNo",				KeyField:0,CalcLogic:"",Format:"IdNo",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:13},
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",					Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,SaveName:"orgNm",			KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:100},
			{Header:"급여액",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"payMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"상여액",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"bonusMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"인정상여",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"etcBonusMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"주식매수선택권\n행사이익",		Type:"AutoSum",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,SaveName:"stockBuyMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"우리사주조합\n인출금",		Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"stockUnionMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"임원퇴직소득금액\n한도초과액",	Type:"AutoSum",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,SaveName:"imwonRetOverMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"<sht:txt mid='totEarningMon_V1' mdef='총급여'/>",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"total",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:0,InsertEdit:0,EditLen:35,CalcLogic:"|payMon|+|bonusMon|+|etcBonusMon|+|stockBuyMon|+|stockUnionMon|"},
			{Header:"생산\n비과세",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxWorkMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"국외\n비과세",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxAbroadMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"식대\n비과세",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxFoodMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"차량\n비과세",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxCarMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"외국인\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxFornMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"연구활동\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxResearchMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"출산보육\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxBabyMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"지정\n비과세",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxEtcMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"일직료\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxNightdutyMon",KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"취재수당\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxReporterMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"비과세계",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxTotal",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:0,InsertEdit:0,EditLen:35,CalcLogic:"|notaxWorkMon|+|notaxAbroadMon|+|notaxFoodMon|+|notaxCarMon|+|notaxFornMon|+|notaxResearchMon|+|notaxBabyMon|+|notaxEtcMon|+|notaxNightdutyMon|+|notaxReporterMon|"},
			{Header:"<sht:txt mid='gubun3' mdef='국민연금'/>",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"penMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"사립학교교직원연금",			Type:"AutoSum",		Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,SaveName:"etcMon1",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"공무원연금",				Type:"AutoSum",		Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,SaveName:"etcMon2",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"군인연금",					Type:"AutoSum",		Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,SaveName:"etcMon3",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"별정우체국연금",				Type:"AutoSum",		Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,SaveName:"etcMon4",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"<sht:txt mid='gubun4' mdef='건강보험'/>",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"helMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"<sht:txt mid='eiEeMonV1' mdef='고용보험'/>",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"empMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"<sht:txt mid='element1070' mdef='소득세'/>",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"incomeTaxMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"<sht:txt mid='element1080' mdef='지방소득세'/>",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"inhbtTaxMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"<sht:txt mid='ataxMon' mdef='농특세'/>",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"ruralTaxMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"감면\n세액",				Type:"AutoSum",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"exmptTaxMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"외국인납세보전",				Type:"AutoSum",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"frgnTaxPlusMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"국외지급일자",				Type:"Date",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"frgnPayYmd",		KeyField:0,CalcLogic:"",Format:"Ymd",		PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:10},
			{Header:"외화",					Type:"AutoSum",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"frgnMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"원화",					Type:"AutoSum",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"frgnNtaxMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35},
			{Header:"기부금",					Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"laborMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		getCommonCodeList();
		$("#srchYear").change(function (){
			getCommonCodeList();
		});

		$(window).smartresize(sheetResize); sheetInit();

	});

	function getCommonCodeList() {
		let searchYear = $("#srchYear").val();
		let baseSYmd = searchYear + "-01-01";
		let baseEYmd = searchYear + "-12-31";
		searchAdjustType = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","C00303", baseSYmd, baseEYmd), "");// 정산구분(C00303)
		sheet1.SetColProperty("adjustType", 		{ComboText:"|"+searchAdjustType[0], ComboCode:"|"+searchAdjustType[1]} );
		$("#srchAdjustType").html(searchAdjustType[2]);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if (!chkInVal(sAction)) {break;}
						searchHeaderList();
						sheet1.DoSearch( "${ctx}/AnnualIncomeTable.do?cmd=getAnnualIncomeTableList", $("#sendForm").serialize() );
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
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

	function searchHeaderList(){

		var dataList = ajaxCall("${ctx}/AnnualIncomeTable.do?cmd=getAnnualIncomeTableHeaderList", $("#sendForm").serialize(), false);

		sheet1.Reset();

		var v = 0;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};;
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};

		initdata1.Cols = [];

		initdata1.Cols[v++] = {Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",					Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='sStatus' mdef='상태'/>",					Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 };

		initdata1.Cols[v++] = {Header:"<sht:txt mid='appraisalYy' mdef='년도'/>",					Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,SaveName:"workYy",			KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:4};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='LAN_V69' mdef='정산구분'/>",				Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,SaveName:"adjustType",		KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:10};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='payYmV8' mdef='년월'/>",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ym",				KeyField:0,				Format:"Ym",		PointCount:0,UpdateEdit:0,InsertEdit:1,EditLen:7 };
		initdata1.Cols[v++] = {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,SaveName:"sabun",			KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:13};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",					Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,SaveName:"name",				KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:100};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",					Type:"Text",		Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,SaveName:"resNo",				KeyField:0,CalcLogic:"",Format:"IdNo",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:13};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",					Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,SaveName:"orgNm",			KeyField:0,CalcLogic:"",Format:"",			PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:100};
		initdata1.Cols[v++] = {Header:"급여액",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"payMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"상여액",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"bonusMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"인정상여",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"etcBonusMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"주식매수선택권\n행사이익",	Type:"AutoSum",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,SaveName:"stockBuyMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"우리사주조합\n인출금",		Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"stockUnionMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"임원퇴직소득금액\n한도초과액",	Type:"AutoSum",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,SaveName:"imwonRetOverMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='totEarningMon_V1' mdef='총급여'/>",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"total",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:0,InsertEdit:0,EditLen:35,CalcLogic:"|payMon|+|bonusMon|+|etcBonusMon|+|stockBuyMon|+|stockUnionMon|"};
		initdata1.Cols[v++] = {Header:"생산\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxWorkMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"국외\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxAbroadMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"식대\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxFoodMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"차량\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxCarMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"외국인\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxFornMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"연구활동\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxResearchMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"출산보육\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxBabyMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"지정\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxEtcMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"일직료\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxNightdutyMon",KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"취재수당\n비과세",			Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxReporterMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"비과세계",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"notaxTotal",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:0,InsertEdit:0,EditLen:35,CalcLogic:"|notaxWorkMon|+|notaxAbroadMon|+|notaxFoodMon|+|notaxCarMon|+|notaxFornMon|+|notaxResearchMon|+|notaxBabyMon|+|notaxEtcMon|+|notaxNightdutyMon|+|notaxReporterMon|"};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='gubun3' mdef='국민연금'/>",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"penMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"사립학교교직원연금",		Type:"AutoSum",		Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,SaveName:"etcMon1",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"공무원연금",				Type:"AutoSum",		Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,SaveName:"etcMon2",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"군인연금",				Type:"AutoSum",		Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,SaveName:"etcMon3",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"별정우체국연금",			Type:"AutoSum",		Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,SaveName:"etcMon4",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='gubun4' mdef='건강보험'/>",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"helMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='eiEeMonV1' mdef='고용보험'/>",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"empMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='element1070' mdef='소득세'/>",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"incomeTaxMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='element1080' mdef='지방소득세'/>",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"inhbtTaxMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"<sht:txt mid='ataxMon' mdef='농특세'/>",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"ruralTaxMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"감면\n세액",				Type:"AutoSum",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"exmptTaxMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"외국인납세보전",			Type:"AutoSum",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"frgnTaxPlusMon",	KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"국외지급일자",			Type:"Date",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"frgnPayYmd",		KeyField:0,CalcLogic:"",Format:"Ymd",		PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:10};
		initdata1.Cols[v++] = {Header:"외화",					Type:"AutoSum",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"frgnMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"원화",					Type:"AutoSum",		Hidden:1,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"frgnNtaxMon",		KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
		initdata1.Cols[v++] = {Header:"기부금",				Type:"AutoSum",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,SaveName:"laborMon",			KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};

		if ( dataList != null && dataList.DATA != null ){

			for(var i=0; i < dataList.DATA.length; i++) {
				initdata1.Cols[v++] = {Header:dataList.DATA[i].codeNm,	Type:"AutoSum",	Hidden:0,Width:170,Align:"Right",ColMerge:0,SaveName:dataList.DATA[i].camelCode,KeyField:0,CalcLogic:"",Format:"Integer",	PointCount:0,UpdateEdit:1,InsertEdit:1,EditLen:35};
			}
		}

		IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(0);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		checkboxHidden();

		sheet1.SetColProperty("adjustType", 		{ComboText:"|"+searchAdjustType[0], ComboCode:"|"+searchAdjustType[1]} );

	}

	function checkboxHidden(){

		if ($("#sumYnCheckbox").is(":checked")) {
			$("#sumYn").val("Y");
			sheet1.SetColHidden("ym",1);
		}else{
			$("#sumYn").val("N");
			sheet1.SetColHidden("ym",0);
		}
	}

	function chkInVal(sAction) {
		if ($("#srchYear").val() == "") {
			alert("<msg:txt mid='110276' mdef='년도를 입력하십시오.'/>");
			$("#srchYear").focus();
			return false;
		}

		return true;
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='113322' mdef='년도'/></th>
			<td>
				<input id="srchYear" name ="srchYear" type="text" class="text center required" maxlength="4" style="width:60px" value="${curSysYear}"/>
			</td>
			<th><tit:txt mid='114504' mdef='작업구분'/></th>
			<td>
				<select id="srchAdjustType" name ="srchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="srchSbNm" name ="srchSbNm" type="text" class="text" maxlength="15" style="width:100px; ime-mode:active;" />
			</td>
			<th><tit:txt mid='104481' mdef='합계'/></th>
			<td>  <input type="checkbox" id="sumYnCheckbox" name="sumYnCheckbox" /><input type="hidden" id="sumYn" name="sumYn" value="" /> </td>
			<td>
				<a href="javascript:doAction1('Search');" class="button"><tit:txt mid='104081' mdef='조회'/></a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">연간소득현황</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
