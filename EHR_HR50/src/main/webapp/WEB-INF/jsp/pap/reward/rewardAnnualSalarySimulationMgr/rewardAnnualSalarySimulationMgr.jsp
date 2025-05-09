<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var entercdVal = "${ssnEnterCd}";
var gradeList = new Array();
	$(function() {
		// 공통코드 조회
		var rewardSimulCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getRewardSimulCdList&annualPsTypeCd=10",false).codeList, "");
		var grpCds = "H20030";
	    var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
	    $("#searchJikweeCd").html("<option></option>" + codeLists["H20030"][2]);
		//var enterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getEnterCdAllList&enterCd=" + entercdVal,false).codeList, "");
		//var compResultCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L90050"));
		//var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00004&searchUseYn=Y",false).codeList, "");

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",	Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가년도|평가년도",							Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"title",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:20 },
			{Header:"인건비재원|인건비예산",						Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"personPay",	KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"인건비재원|총연봉",							Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"",			KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"인건비재원|잔여예산",							Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"",			KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"평가등급별 연봉 조절율|S",						Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"increPayS",	KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"평가등급별 연봉 조절율|E",						Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"increPayE",	KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"평가등급별 연봉 조절율|G",						Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"increPayG",	KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"평가등급별 연봉 조절율|N",						Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"increPayN",	KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"평가등급별 연봉 조절율|U",						Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"increPayU",	KeyField:0,	CalcLogic:"",	Format:"###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"평가등급별 연봉 조절율|실제평균인상률",		Type:"Int",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"yearIncre",	KeyField:0,	CalcLogic:"",	Format:"###\\%",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"PS시뮬레이션|PS시뮬레이션",					Type:"Combo",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"psSimulId",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			
			{Header:"",												Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"",												Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"simulId",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"",												Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"note",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"",												Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"year",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		var year = "${curSysYear}";
		var splitYear = year.substr(2, 2);
		var pervYear = Number(year) - 1;
		var perv2Year = Number(year) - 2;
		var nextYear = Number(year) + 1;
		
		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"사번",							Type:"Text",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"성명",							Type:"Text",	Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직원구분",						Type:"Text",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"입사일",						Type:"Date",	Hidden:0,		Width:90,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,				Format:"Ymd",	UpdateEdit:0,	InsertEdit:0},
			{Header:"직위",							Type:"Text",	Hidden:0,		Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"연차",							Type:"Text",	Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeYear",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직책",							Type:"Text",	Hidden:0,		Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"본부",							Type:"Text",	Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgNm1",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"실",							Type:"Text",	Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgNm2",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"팀",							Type:"Text",	Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgNm3",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			
			{Header: perv2Year+"\n연봉",				Type:"Int",	Hidden:1,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"prev2AnnualIncome",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: perv2Year+"→\n"+pervYear+"인상률",	Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"",			KeyField:0,CalcLogic:"|prevAnnualIncome| - |prev2AnnualIncome| / |prev2AnnualIncome| * 100",Format:"###\\%",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header: pervYear+"\n연봉",					Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"prevAnnualIncome",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: pervYear+"→\n"+year+"인상률",		Type:"Int",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"",			KeyField:0,CalcLogic:"((|bfAnnualIncome|-|prevAnnualIncome|) / |prevAnnualIncome|) * 100)", Format:"###\\%",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header: year+" 연봉\n(정기상여제외)",		Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfAnnualIncome",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: year+"\n근무율",					Type:"Int",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTermRate",KeyField:0,	CalcLogic:"",Format:"###\\%",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header: year+" 평가등급",					Type:"Combo",Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"grade",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header: "등급 변환",						Type:"Combo",Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chgGrade",	KeyField:0,				UpdateEdit:1,	InsertEdit:0},
			{Header: "연봉인상액",						Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"raisePay",	KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: "추가인상분",						Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"addRaisePay",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: "연봉인상률",						Type:"Int",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"",			KeyField:0,CalcLogic:"Math.ceil((|raisePay| / |bfAnnualIncome|) * 100)",Format:"###\\%",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header: nextYear+" 연봉\n(정기상여제외)",	Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"finIncome",	KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: nextYear+"\n정기상여",				Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"regulBonus",	KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: nextYear+"\n총연봉",				Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"",			KeyField:0,CalcLogic:"|finIncome| + |regulBonus|",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: year+"\nPS",						Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"psPay",		KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: nextYear+"\n총 보상",				Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totPay",		KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: "계산제외여부",					Type:"CheckBox",Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"calNotYn",	KeyField:0,	CalcLogic:"",Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N"},
			{Header: "비고사유",						Type:"Text",	Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"note",	KeyField:0,CalcLogic:"",Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1000 },			
			
			
			{Header:"",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"simulId",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);

		//sheet2.SetColProperty("appSeqCd",		{ComboText:appSeqCdList[0], ComboCode:appSeqCdList[1]} );
		//sheet2.SetColProperty("appEnterCd",		{ComboText:enterCdList[0], ComboCode:enterCdList[1]} );
			
		var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCodeList&searchYear=" + year, false).codeList, "");
		var comboText = "";
		var comboCode = "";
		var comboText2 = "|S|E|G|N|U";
		var comboCode2 = "|S|E|G|N|U";
		if (classCdList[0].length > 0) {
			comboText = "|" + classCdList[0];
			comboCode = "|" + classCdList[1];
		} else {
			comboText = "|S|E|G1|G2|G3|N|U";
			comboCode = "|S|E|G1|G2|G3|N|U";
		}
		sheet2.SetColProperty("grade",		   {ComboText:comboText, ComboCode:comboCode} );
		sheet2.SetColProperty("chgGrade",		   {ComboText:comboText2, ComboCode:comboCode2} );
		$(window).smartresize(sheetResize); sheetInit();

		// 조회조건 이벤트
		$("#searchSimulId").bind("change", function(e){
			var year = ""; 
			var value = e.target.value;
			var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getRewardSimulCdList&annualPsTypeCd=10&simulId="+value,false);
			if (data && data.codeList.length > 0 && data.codeList[0].year) {
				year = data.codeList[0].year
			}
			
			initsheet2(year);
			// 평가명 변경시마다 조회, 시트1 저장시 조회
			var dataRate = ajaxCall("${ctx}/RewardAnnualSalarySimulationMgr.do?cmd=getRewardAnnualSalarySimulationMgrPayRateList", $("#srchFrm").serialize(), false);
			if (dataRate && dataRate.DATA.length > 0) {
				gradeList = dataRate.DATA;
			}			
			$("#searchYear").val(year);
			doSearch();
		});

		$("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doSearch(); $(this).focus();
			}
		});

		
		
		// 조회조건 값 setting
		$("#searchSimulId").html(rewardSimulCdList[2]);

		// 조회
		//doAction1("Search");
		$("#searchSimulId").change();
	});
	
	function initsheet2(year) {
		var year = year;
		var splitYear = year.substr(2, 2);
		var pervYear = Number(year) - 1;
		var perv2Year = Number(year) - 2;
		var nextYear = Number(year) + 1;
		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		sheet2.Reset();
		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"사번",							Type:"Text",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"성명",							Type:"Text",	Hidden:0,		Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직원구분",						Type:"Text",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"입사일",						Type:"Date",	Hidden:0,		Width:90,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,				Format:"Ymd",	UpdateEdit:0,	InsertEdit:0},
			{Header:"직위",							Type:"Text",	Hidden:0,		Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"연차",							Type:"Text",	Hidden:0,		Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeYear",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"직책",							Type:"Text",	Hidden:0,		Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"본부",							Type:"Text",	Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgNm1",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"실",							Type:"Text",	Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgNm2",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header:"팀",							Type:"Text",	Hidden:0,		Width:80,	Align:"Left",	ColMerge:0,	SaveName:"orgNm3",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			
			{Header: perv2Year+"\n연봉",				Type:"Int",	Hidden:1,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"prev2AnnualIncome",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: perv2Year+"→\n"+pervYear+"인상률",	Type:"Int",Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"",KeyField:0,CalcLogic:"((|prevAnnualIncome|-|prev2AnnualIncome|) / |prev2AnnualIncome|) * 100",Format:"###\\%",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header: pervYear+"\n연봉",				Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"prevAnnualIncome",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: pervYear+"→\n"+year+"인상률",	Type:"Int",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"",KeyField:0,CalcLogic:"((|bfAnnualIncome|-|prevAnnualIncome|) / |prevAnnualIncome|) * 100", Format:"###\\%",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header: year+" 연봉\n(정기상여제외)",	Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfAnnualIncome",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: year+"\n근무율",				Type:"Int",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTermRate",KeyField:0,	CalcLogic:"",Format:"###\\%",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header: year+" 평가등급",				Type:"Combo",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"grade",		KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header: "등급 변환",					Type:"Combo",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chgGrade",	KeyField:0,				UpdateEdit:1,	InsertEdit:0},
			{Header: "연봉인상액",					Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"raisePay",	KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: "추가인상분",					Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"addRaisePay",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: "연봉인상률",					Type:"Int",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"",			KeyField:0,CalcLogic:"Math.ceil((|raisePay| / |bfAnnualIncome|) * 100)",Format:"###\\%",	PointCount:1,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header: nextYear+" 연봉\n(정기상여제외)",Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"finIncome",	KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: nextYear+"\n정기상여",			Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"regulBonus",	KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: nextYear+"\n총연봉",			Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totalPay",	KeyField:0,CalcLogic:"|finIncome| + |regulBonus|",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: year+"\nPS",					Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"psPay",		KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: nextYear+"\n총 보상",			Type:"Int",	Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totPay",		KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:15 },
			{Header: "계산제외여부",				Type:"CheckBox",Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"calNotYn",	KeyField:0,	CalcLogic:"",Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N"},
			{Header: "비고사유",					Type:"Text",	Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,CalcLogic:"",Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1000 },			
			
			
			{Header:"",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"simulId",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);
			
		var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCodeList&searchYear=" + year, false).codeList, "");
		var comboText = "";
		var comboCode = "";
		var comboText2 = "|S|E|G|N|U";
		var comboCode2 = "|S|E|G|N|U";
		if (classCdList[0].length > 0) {
			comboText = "|" + classCdList[0];
			comboCode = "|" + classCdList[1];
		} else {
			comboText = "|S|E|G1|G2|G3|N|U";
			comboCode = "|S|E|G1|G2|G3|N|U";
		}
		sheet2.SetColProperty("grade",		   {ComboText:comboText, ComboCode:comboCode} );
		sheet2.SetColProperty("chgGrade",		   {ComboText:comboText2, ComboCode:comboCode2} );
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	// 대상자생성
	function create(){
		if (confirm("기존 대상자는 삭제 됩니다. 대상자를 생성 하시겠습니까?")) {
	    	var data = ajaxCall("${ctx}/RewardAnnualSalarySimulationMgr.do?cmd=prcRewardAnnualSalarySimulation",$("#srchFrm").serialize(),false);
			if(data.Result.Code == null) {
				alert("<msg:txt mid='alertCreateOk1' mdef='대상자생성이 완료되었습니다.'/>");
				doSearch();
	    	} else {
		    	alert(data.Result.Message);
	    	}
		}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
	}
	
	function popup(opt){
		pGubun = opt;
		if(opt == "org"){
			openPopup("/Popup.do?cmd=orgTreePopup&authPg=R&authYn=Y", "", "740","520");	
		}
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "org") {
	    	$("#searchOrgCd").val(rv["orgCd"]);
	    	$("#searchOrgNm").val(rv["orgNm"]);
	    	$("#searchOrgSdate").val(rv["sdate"]);
	    }
	}
	
	function clearCode(num) {
		if(num == 1) {
			$("#searchOrgCd").val("");
			$("#searchOrgNm").val("");
			//doAction1("Search");
		}
	}
	
	function doSearch() {
		doAction1("Search");
		doAction2("Search");
	}
	
</script>

<!-- sheet1 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet1.DoSearch( "${ctx}/RewardAnnualSalarySimulationMgr.do?cmd=getRewardAnnualSalarySimulationMgrList", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				for (var i=sheet1.GetDataFirstRow();i <= sheet1.GetDataLastRow(); i++ ) {
					var simulId = sheet1.GetCellValue(i, "simulId");
					if (simulId) {
						sheet1.SetCellValue(i, "sStatus", "U")
					} else {
						sheet1.SetCellValue(i, "sStatus", "R")
					}
	            }
				IBS_SaveName(document.srchFrm,sheet1);
				//sheet1.DoSave( "${ctx}/RewardPsIncreaseSimulationMgr.do?cmd=saveCompAppPeopleMng1", $("#srchFrm").serialize() );
				sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveRewardAnnualSalarySimulationMgr", $("#srchFrm").serialize()); break;
				break;
			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;
		}
	}

	//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			var firstRow = sheet1.GetDataFirstRow();
			sheet1.SetRowEditable(firstRow, 1);
			sheet1.SetCellEditable(firstRow, "personPay", 1);
			sheet1.SetCellEditable(firstRow, "increPayS", 1);
			sheet1.SetCellEditable(firstRow, "increPayE", 1);
			sheet1.SetCellEditable(firstRow, "increPayG", 1);
			sheet1.SetCellEditable(firstRow, "increPayN", 1);
			sheet1.SetCellEditable(firstRow, "increPayU", 1);
			sheet1.SetCellEditable(firstRow, "psSimulId", 1);
			for (var i=sheet1.GetDataFirstRow();i <= sheet1.GetDataLastRow(); i++ ) {
				var year = sheet1.GetCellValue(i, "year");
				var simulCode = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getRewardSimulCdList&annualPsTypeCd=20&year="+year,false).codeList, "");
				sheet1.InitCellProperty(i, "psSimulId",	{Type:"Combo", ComboText:"|"+simulCode[0], ComboCode:"|"+simulCode[1]} );
            }
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	//<!-- 저장 후 에러 메시지 -->
	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}
			var dataRate = ajaxCall("${ctx}/RewardAnnualSalarySimulationMgr.do?cmd=getRewardAnnualSalarySimulationMgrPayRateList", $("#srchFrm").serialize(), false);
			if (dataRate && dataRate.DATA.length > 0) {
				gradeList = dataRate.DATA;
			}				
			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

	//<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}

	// Click 시
	function sheet1_OnClick(Row, Col, Value){
		try{

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	//<!--셀에 마우스 클릭했을때 발생하는 이벤트-->
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			var Row = NewRow;

			if ( sheet1.GetCellValue(Row, "sStatus") == "I" ) return;
			if ( OldRow == NewRow ) return;
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	function sheet1_OnChange(Row, Col) {
		try{
			/*
			var colName = sheet1.ColSaveName(Col);
			var firstRow = sheet1.GetDataFirstRow();
			var setRow = firstRow + 1;
			if (colName == "payRateS") {
				var tS = sheet1.GetCellValue(firstRow, "payRateS") ? Number(sheet1.GetCellValue(firstRow, "payRateS")) : 0;
				var tE = sheet1.GetCellValue(firstRow, "payRateE") ? Number(sheet1.GetCellValue(firstRow, "payRateE")) : 0;
				sheet1.SetCellValue(setRow, "payRateS", tS - tE, false);
			}*/
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
</script>

<!-- sheet2 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction2(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet2.DoSearch( "${ctx}/RewardAnnualSalarySimulationMgr.do?cmd=getRewardAnnualSalarySimulationMgrList2", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				//if(sheet2.FindStatusRow("I") != ""){
				//	if(!dupChk(sheet2,"wEnterCd|sabun|compAppraisalCd|appEnterCd|appSabun", true, true)){break;}
				//}
				IBS_SaveName(document.srchFrm,sheet2);
				sheet2.DoSave( "${ctx}/SaveData.do?cmd=saveRewardAnnualSalarySimulationMgr2", $("#srchFrm").serialize()); break;
				break;

			case "Clear":		//Clear
				sheet2.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet2.Down2Excel({DownCols:makeHiddenSkipCol(sheet2),SheetDesign:1,Merge:1});
				break;
		}
	}

//<!-- 조회 후 에러 메시지 -->
	function sheet2_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

//<!-- 저장 후 에러 메시지 -->
	function sheet2_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

//<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}

	function sheet2_OnChange(Row, Col, Value) {
		try{
			var colName = sheet2.ColSaveName(Col);
			if (colName == "bfAnnualIncome") { // 연봉
				sheet2.SetCellValue(Row, "finIncome", resultColumnCalcValue(Row,"finIncome"), false);
				sheet2.SetCellValue(Row, "regulBonus", resultColumnCalcValue(Row,"regulBonus"), false);
				sheet2.SetCellValue(Row, "totPay", resultColumnCalcValue(Row,"totPay"), false);
			} else if (colName == "chgGrade") {
				sheet2.SetCellValue(Row, "raisePay", resultColumnCalcValue(Row,"raisePay"), false);
				sheet2.SetCellValue(Row, "finIncome", resultColumnCalcValue(Row,"finIncome"), false);
				sheet2.SetCellValue(Row, "regulBonus", resultColumnCalcValue(Row,"regulBonus"), false);
				sheet2.SetCellValue(Row, "totPay", resultColumnCalcValue(Row,"totPay"), false);
			} else if (colName == "raisePay") {
				sheet2.SetCellValue(Row, "finIncome", resultColumnCalcValue(Row,"finIncome"), false);
				sheet2.SetCellValue(Row, "regulBonus", resultColumnCalcValue(Row,"regulBonus"), false);
				sheet2.SetCellValue(Row, "totPay", resultColumnCalcValue(Row,"totPay"), false);
			} else if (colName == "addRaisePay") {
				sheet2.SetCellValue(Row, "finIncome", resultColumnCalcValue(Row,"finIncome"), false);
				sheet2.SetCellValue(Row, "regulBonus", resultColumnCalcValue(Row,"regulBonus"), false);
				sheet2.SetCellValue(Row, "totPay", resultColumnCalcValue(Row,"totPay"), false);
			} else if (colName == "finIncome") {
				sheet2.SetCellValue(Row, "finIncome", resultColumnCalcValue(Row,"finIncome"), false);
				sheet2.SetCellValue(Row, "regulBonus", resultColumnCalcValue(Row,"regulBonus"), false);
				sheet2.SetCellValue(Row, "totPay", resultColumnCalcValue(Row,"totPay"), false);
			} else if (colName == "regulBonus") {
				sheet2.SetCellValue(Row, "regulBonus", resultColumnCalcValue(Row,"regulBonus"), false);
				sheet2.SetCellValue(Row, "totPay", resultColumnCalcValue(Row,"totPay"), false);
			} else if (colName == "psPay") {
				sheet2.SetCellValue(Row, "totPay", resultColumnCalcValue(Row,"totPay"), false);
			}
		}catch(ex){alert("sheet2_OnChange Event Error : " + ex);}
	}
	
	// 컬럼에 따른 값 계산후 리턴
	function resultColumnCalcValue(Row, psColumn) {
		var result = null;
		if (psColumn == "raisePay") { // 연봉인상액
			var grade = sheet2.GetCellValue(Row, "chgGrade");
			gradeList.forEach(function(item, idx, arr){
				if (item.colNm == grade) {
					result = item.colVal; 
				} 
			});
		} else if (psColumn == "finIncome") { // 현재년도 연봉
			var bfAnnualIncome = sheet2.GetCellValue(Row, "bfAnnualIncome") ? Number(sheet2.GetCellValue(Row, "bfAnnualIncome")) : 0;
			var raisePay = sheet2.GetCellValue(Row, "raisePay") ? Number(sheet2.GetCellValue(Row, "raisePay")) : 0;
			var addRaisePay = sheet2.GetCellValue(Row, "addRaisePay") ? Number(sheet2.GetCellValue(Row, "addRaisePay")) : 0;
			result = Math.ceil((bfAnnualIncome + raisePay + addRaisePay) * 0.001) * 1000;
		} else if (psColumn == "regulBonus") { // 정기상여  (CEIL((((B.BF_ANNUAL_INCOME + C.RAISE_PAY) / 12) * 0.6) * 0.1) * 10)
			//var bfAnnualIncome = sheet2.GetCellValue(Row, "bfAnnualIncome") ? Number(sheet2.GetCellValue(Row, "bfAnnualIncome")) : 0;
			//var gradeRate = sheet2.GetCellValue(Row, "raisePay") ? Number(sheet2.GetCellValue(Row, "raisePay")) : 0;
			
			var finIncome = sheet2.GetCellValue(Row, "finIncome") ? Number(sheet2.GetCellValue(Row, "finIncome")) : 0;
			result = Math.ceil((((finIncome) / 12) * 0.6) * 0.1) * 10;   
		}  else if ("totPay") { // 총보상
			var finIncome = sheet2.GetCellValue(Row, "finIncome") ? Number(sheet2.GetCellValue(Row, "finIncome")) : 0;
			var regulBonus = sheet2.GetCellValue(Row, "regulBonus") ? Number(sheet2.GetCellValue(Row, "regulBonus")) : 0;
			var psPay = sheet2.GetCellValue(Row, "psPay") ? Number(sheet2.GetCellValue(Row, "psPay")) : 0;
			result = finIncome + regulBonus + psPay;
		}  else {
			result = null;
		}
		return result;
	}
	
	function visibleUpSheet() {
		if ($("#sheet_up").css("display") == "none") {
			$("#toggleBtn").text("접기");
	        $("#DIV_"+sheet1.id).show();
	        $("#sheet_up").addClass("outer");
	        $("#sheet_up").show();
	        $("#DIV_"+sheet2.id).css("height", "calc(100% - " + $("#sheet_up").css("height") + "px)");
	        sheetResize();
		} else {
			$("#toggleBtn").text("펼치기");
			$("#DIV_"+sheet1.id).hide();
	        $("#sheet_up").hide();
	        $("#sheet_up").removeClass("outer");
	        $("#DIV_"+sheet2.id).css("height", "calc(100%)");
	        sheetResize();
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" name="searchYear" id="searchYear" >
	<input type="hidden" name="searchOrgCd" id="searchOrgCd" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<SELECT id="searchSimulId" name="searchSimulId" class="box"></SELECT>
						</td>
						<td>
							<span>조직</span>
							<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" readonly/>
							<a onclick="javascript:popup('org')" class="button6" ><img src='/common/${theme}/images/btn_search2.gif'/></a>
							<a href="javascript:clearCode(1)" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td>
							<span>직위구분</span>
							<select name="searchJikweeCd" id="searchJikweeCd">
							</select>
						</td>
						<td>
							<span>성명/사번</span>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" />
						</td>
						<td>
							<a href="javascript:doSearch()" id="btnSearch" class="button">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table name="sheet_up" id="sheet_up" border="0" cellspacing="0" cellpadding="0" class="sheet_main outer">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">연봉기준</li>
							<li class="btn">
								<a href="javascript:doAction1('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "200px","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
	<div class="outer" style="display: flex; height: 35px; align-items: center; text-align: center;justify-content: center;">
		<a id="toggleBtn" href="javascript:visibleUpSheet()" id="" class="basic"  style="padding: 3px 10px;">접기</a>
	</div>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='compAppPeopleMng2' mdef='PS 산정'/></li>
							<li class="btn">
								<a href="javascript:create()" class="button authA"><tit:txt mid='112692' mdef='연봉대상자 생성'/></a>
								<a href="javascript:doAction2('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction2('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>