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
		var rewardSimulCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getRewardSimulCdList&annualPsTypeCd=20",false).codeList, "");
		var grpCds = "H20030";
	    var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
	    $("#searchJikweeCd").html("<option></option>" + codeLists["H20030"][2]);
		//var enterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getEnterCdAllList&enterCd=" + entercdVal,false).codeList, "");
		//var compResultCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L90050"));
		//var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00004&searchUseYn=Y",false).codeList, "");

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",	Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가등급|평가등급",							Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"title",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"S|S",											Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"payRateS",	KeyField:0,	CalcLogic:"",	Format:"###\\%",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:5 },
			{Header:"E|E",											Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"payRateE",	KeyField:0,	CalcLogic:"",	Format:"###\\%",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:5 },
			{Header:"G|G1",											Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"payRateG1",	KeyField:0,	CalcLogic:"",	Format:"###\\%",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:5 },
			{Header:"G|G2",											Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"payRateG2",	KeyField:0,	CalcLogic:"",	Format:"###\\%",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:5 },
			{Header:"G|G3",											Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"payRateG3",	KeyField:0,	CalcLogic:"",	Format:"###\\%",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:5 },
			{Header:"N|N",											Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"payRateN",	KeyField:0,	CalcLogic:"",	Format:"###\\%",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:5 },
			{Header:"U|U",											Type:"Int",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"payRateU",	KeyField:0,	CalcLogic:"",	Format:"###\\%",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:5 },
			
			{Header:"",												Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"",												Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"simulId",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No'/>",			Type:"${sNoTy}",	Hidden:1,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"PS 총 재원",									Type:"Int",		Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"totIncome",	KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"정기상여금 지급",								Type:"Int",		Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"fixBonusPay",	KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"잔여 PS 재원",									Type:"Int",		Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"resultIncome",KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"PS 지급",										Type:"Int",		Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"finPsPay",	KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"재적전출",										Type:"Int",		Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"moveTotPay",	KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"잔액",											Type:"Int",		Hidden:0,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"totResult",	KeyField:0,	CalcLogic:"",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			{Header:"",												Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"",												Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"simulId",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);
		
		var year = "${curSysYear}"
		var splitYear = year.substr(2, 2);
		var pervYear = Number(year) - 1
		
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
			{Header: year+"연봉\n(정기상여 제외)",		Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfAnnualIncome",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header: pervYear+ " 평가등급",			Type:"Combo",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"finClassCd1",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header: year+" 평가등급",				Type:"Combo",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"grade",		KeyField:0,				UpdateEdit:1,	InsertEdit:0},
			{Header:"평가등급\n지급율",				Type:"Int",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gradeRate",	KeyField:0,	CalcLogic:"",Format:"###\\%",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"평가등급\n산출액",				Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"gradePay",	KeyField:0,	CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"영업\n인센티브\n가감율",		Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"busiIncenRate",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"영업\n인센티브\n산출액",		Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"busiIncenPay",KeyField:0,	CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"재직기간\n산정율",				Type:"Int",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTermRate",KeyField:0,	CalcLogic:"",Format:"###\\%",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header: pervYear+"\n영업 인센티브",	Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"prevGradePay",KeyField:0,CalcLogic:"",Format:"#,###",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header: pervYear+"\nPS\n("+splitYear+" 2월 지급)",		
													Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totalPs",		KeyField:0,	CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header: pervYear+" 정기상여\n("+splitYear+" 9월 지급)",
													Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totalBonus",	KeyField:0,	CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header: pervYear+"\nPS+정기상여",		Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"",			KeyField:0,	CalcLogic:"|totalPs| + |totalBonus|",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"전년대비\nPS 증감액",			Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"",			KeyField:0,	CalcLogic:"|finPsPay| - |totalPs|",		Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header: year+"\nPS",					Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"finPsPay",	KeyField:0,	CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header: "계산제외여부",				Type:"CheckBox",Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"calNotYn",	KeyField:0,	CalcLogic:"",Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N"},
			{Header: "비고사유",					Type:"Text",	Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	CalcLogic:"",Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1000 },
			
			
			{Header:"",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"simulId",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			
   		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);sheet3.SetUnicodeByte(3);

		//sheet3.SetColProperty("appSeqCd",		{ComboText:appSeqCdList[0], ComboCode:appSeqCdList[1]} );
		//sheet3.SetColProperty("appEnterCd",		{ComboText:enterCdList[0], ComboCode:enterCdList[1]} );
		//sheet3.SetColProperty("ldsAppStatusCd",	{ComboText:"N|Y", ComboCode:"N|Y"} );
		var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCodeList&searchYear=" + year, false).codeList, "");
		var comboText = "";
		var comboCode = "";
		if (classCdList[0].length > 0) {
			comboText = "|" + classCdList[0];
			comboCode = "|" + classCdList[1];
		} else {
			comboText = "|S|E|G1|G2|G3|N|U";
			comboCode = "|S|E|G1|G2|G3|N|U";
		}
		sheet3.SetColProperty("finClassCd1",		   {ComboText:comboText, ComboCode:comboCode} );
		sheet3.SetColProperty("grade",		   {ComboText:comboText, ComboCode:comboCode} );
		$(window).smartresize(sheetResize); sheetInit();

		// 조회조건 이벤트
		$("#searchSimulId").bind("change", function(e){
			var year = ""; 
			var value = e.target.value;
			var data = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getRewardSimulCdList&annualPsTypeCd=20&simulId="+value,false);
			if (data && data.codeList.length > 0 && data.codeList[0].year) {
				year = data.codeList[0].year
			}
			
			initSheet3(year);
			// 평가명 변경시마다 조회, 시트1 저장시 조회
			var dataRate = ajaxCall("${ctx}/RewardPsIncreaseSimulationMgr.do?cmd=getRewardPsIncreaseSimulationMgrPayRateList", $("#srchFrm").serialize(), false);
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
	
	function initSheet3(year) {
		var year = year
		var splitYear = year.substr(2, 2);
		var pervYear = Number(year) - 1
		var initdata = {};
		initdata.Cfg = {FrozenCol:5,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		
		sheet3.Reset();
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
			{Header: year+"연봉\n(정기상여 제외)",		Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfAnnualIncome",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header: pervYear+ " 평가등급",			Type:"Combo",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"finClassCd1",	KeyField:0,				UpdateEdit:0,	InsertEdit:0},
			{Header: year+" 평가등급",				Type:"Combo",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"grade",		KeyField:0,				UpdateEdit:1,	InsertEdit:0},
			{Header:"평가등급\n지급율",				Type:"Int",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"gradeRate",	KeyField:0,	CalcLogic:"",Format:"###\\%",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header:"평가등급\n산출액",				Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"gradePay",	KeyField:0,	CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"영업\n인센티브\n가감율",		Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"busiIncenRate",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"영업\n인센티브\n산출액",		Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"busiIncenPay",KeyField:0,	CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"재직기간\n산정율",				Type:"Int",		Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"workTermRate",KeyField:0,	CalcLogic:"",Format:"###\\%",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			{Header: pervYear+"\n영업 인센티브",	Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"prevGradePay",KeyField:0,CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header: pervYear+"\nPS\n("+splitYear+" 2월 지급)",		
													Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totalPs",		KeyField:0,	CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header: pervYear+" 정기상여\n("+splitYear+" 9월 지급)",
													Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"totalBonus",	KeyField:0,	CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header: pervYear+"\nPS+정기상여",		Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"",			KeyField:0,	CalcLogic:"|totalPs| + |totalBonus|",	Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"전년대비\nPS 증감액",			Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"",			KeyField:0,	CalcLogic:"|finPsPay| - |totalPs|",		Format:"#,###",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header: year+"\nPS",					Type:"Int",		Hidden:0,		Width:80,	Align:"Right",	ColMerge:0,	SaveName:"finPsPay",	KeyField:0,	CalcLogic:"",Format:"#,###",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header: "계산제외여부",				Type:"CheckBox",	Hidden:0,		Width:80,	Align:"Center",	ColMerge:0,	SaveName:"calNotYn",	KeyField:0,	CalcLogic:"",Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:0,	TrueValue:"Y",	FalseValue:"N"},
			{Header: "비고사유",					Type:"Text",		Hidden:0,		Width:300,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,CalcLogic:"",Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1000 },
			
			{Header:"",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"simulId",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			
   			
   		]; IBS_InitSheet(sheet3, initdata);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);sheet3.SetUnicodeByte(3);
		
		var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCd&searchYear=" + year, false).codeList, "");
		var comboText = "";
		var comboCode = "";
		if (classCdList[0].length > 0) {
			comboText = "|" + classCdList[0];
			comboCode = "|" + classCdList[1];
		} else {
			comboText = "|S|E|G1|G2|G3|N|U";
			comboCode = "|S|E|G1|G2|G3|N|U";
		}
		sheet3.SetColProperty("finClassCd1",		   {ComboText:comboText, ComboCode:comboCode} );
		sheet3.SetColProperty("grade",		   {ComboText:comboText, ComboCode:comboCode} );
		
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	// 대상자생성
	function create(){
		if (confirm("기존 대상자는 삭제 됩니다. 대상자를 생성 하시겠습니까?")) {
	    	var data = ajaxCall("${ctx}/RewardPsIncreaseSimulationMgr.do?cmd=prcRewardPsIncreaseSimulation",$("#srchFrm").serialize(),false);
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
		doAction3("Search");
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
				$("#searchSimulId2").val("");
				$("#searchSabun2").val("");
				$("#searchWEnterCd2").val("");

				sheet1.DoSearch( "${ctx}/RewardPsIncreaseSimulationMgr.do?cmd=getRewardPsIncreaseSimulationMgrList", $("#srchFrm").serialize() );
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
				sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveRewardPsIncreaseSimulationMgr", $("#srchFrm").serialize()); break;
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
			sheet1.SetCellEditable(firstRow, "payRateS", 1);
			sheet1.SetCellEditable(firstRow, "payRateE", 1);
			sheet1.SetCellEditable(firstRow, "payRateG1", 1);
			sheet1.SetCellEditable(firstRow, "payRateG2", 1);
			sheet1.SetCellEditable(firstRow, "payRateG3", 1);
			sheet1.SetCellEditable(firstRow, "payRateN", 1);
			sheet1.SetCellEditable(firstRow, "payRateU", 1);
			
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	//<!-- 저장 후 에러 메시지 -->
	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}
			var dataRate = ajaxCall("${ctx}/RewardPsIncreaseSimulationMgr.do?cmd=getRewardPsIncreaseSimulationMgrPayRateList", $("#srchFrm").serialize(), false);
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
			var colName = sheet1.ColSaveName(Col);
			var firstRow = sheet1.GetDataFirstRow();
			var setRow = firstRow + 1;
			if (colName == "payRateS") {
				var tS = sheet1.GetCellValue(firstRow, "payRateS") ? Number(sheet1.GetCellValue(firstRow, "payRateS")) : 0;
				var tE = sheet1.GetCellValue(firstRow, "payRateE") ? Number(sheet1.GetCellValue(firstRow, "payRateE")) : 0;
				sheet1.SetCellValue(setRow, "payRateS", tS - tE, false);
			}
			if (colName == "payRateE") {
				var tS = sheet1.GetCellValue(firstRow, "payRateS") ?  Number(sheet1.GetCellValue(firstRow, "payRateS")) : 0;
				var tE = sheet1.GetCellValue(firstRow, "payRateE") ?  Number(sheet1.GetCellValue(firstRow, "payRateE")) : 0;
				var tG1= sheet1.GetCellValue(firstRow, "payRateG1") ? Number(sheet1.GetCellValue(firstRow, "payRateG1")) : 0;
				sheet1.SetCellValue(setRow, "payRateS", tS - tE, false);
				sheet1.SetCellValue(setRow, "payRateE", tE - tG1, false);
			}
			if (colName == "payRateG1") {
				var tE = sheet1.GetCellValue(firstRow, "payRateE") ? Number(sheet1.GetCellValue(firstRow, "payRateE")) : 0;
				var tG1= sheet1.GetCellValue(firstRow, "payRateG1") ? Number(sheet1.GetCellValue(firstRow, "payRateG1")) : 0;
				var tG2= sheet1.GetCellValue(firstRow, "payRateG2") ? Number(sheet1.GetCellValue(firstRow, "payRateG2")) : 0;
				sheet1.SetCellValue(setRow, "payRateE", tE - tG1, false);
				sheet1.SetCellValue(setRow, "payRateG1", tG1 - tG2, false);
			}
			if (colName == "payRateG2") {
				var tG1= sheet1.GetCellValue(firstRow, "payRateG1") ? Number(sheet1.GetCellValue(firstRow, "payRateG1")) : 0;
				var tG2= sheet1.GetCellValue(firstRow, "payRateG2") ? Number(sheet1.GetCellValue(firstRow, "payRateG2")) : 0;
				var tG3= sheet1.GetCellValue(firstRow, "payRateG3") ? Number(sheet1.GetCellValue(firstRow, "payRateG3")) : 0;
				sheet1.SetCellValue(setRow, "payRateG1", tG1 - tG2, false);
				sheet1.SetCellValue(setRow, "payRateG2", tG2 - tG3, false);
			}
			if (colName == "payRateG3") {
				var tG2= sheet1.GetCellValue(firstRow, "payRateG2") ? Number(sheet1.GetCellValue(firstRow, "payRateG2")) : 0;
				var tG3= sheet1.GetCellValue(firstRow, "payRateG3") ? Number(sheet1.GetCellValue(firstRow, "payRateG3")) : 0;
				var tN= sheet1.GetCellValue(firstRow, "payRateN") ?   Number(sheet1.GetCellValue(firstRow, "payRateN")) : 0;
				sheet1.SetCellValue(setRow, "payRateG2", tG2 - tG3, false);
				sheet1.SetCellValue(setRow, "payRateG3", tG3 - tN, false);
			}
			if (colName == "payRateN") {
				var tG3= sheet1.GetCellValue(firstRow, "payRateG3") ? Number(sheet1.GetCellValue(firstRow, "payRateG3")) : 0;
				var tN= sheet1.GetCellValue(firstRow, "payRateN") ?   Number(sheet1.GetCellValue(firstRow, "payRateN")) : 0;
				var tU= sheet1.GetCellValue(firstRow, "payRateU") ?   Number(sheet1.GetCellValue(firstRow, "payRateU")) : 0;
				sheet1.SetCellValue(setRow, "payRateG3", tG3 - tN, false);
				sheet1.SetCellValue(setRow, "payRateN", tN - tU, false);
			}
			if (colName == "payRateU") {
				var tN= sheet1.GetCellValue(firstRow, "payRateN") ? Number(sheet1.GetCellValue(firstRow, "payRateN")) : 0;
				var tU= sheet1.GetCellValue(firstRow, "payRateU") ? Number(sheet1.GetCellValue(firstRow, "payRateU")) : 0;
				sheet1.SetCellValue(setRow, "payRateN", tN - tU, false);
			}
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
				sheet2.DoSearch( "${ctx}/RewardPsIncreaseSimulationMgr.do?cmd=getRewardPsIncreaseSimulationMgrList2", $("#srchFrm").serialize() );
				break;
			case "Save":		//저장
				//if(sheet2.FindStatusRow("I") != ""){
				//	if(!dupChk(sheet2,"wEnterCd|sabun|compAppraisalCd|appEnterCd|appSabun", true, true)){break;}
				//}
				IBS_SaveName(document.srchFrm,sheet2);
				sheet2.DoSave( "${ctx}/SaveData.do?cmd=saveRewardPsIncreaseSimulationMgr2", $("#srchFrm").serialize()); break;
				//sheet2.DoSave( "${ctx}/RewardPsIncreaseSimulationMgr.do?cmd=saveCompAppPeopleMng2", $("#srchFrm").serialize() );
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

	function sheet2_OnChange(Row, Col) {
		try{
			var colName = sheet2.ColSaveName(Col);
			var firstRow = sheet2.GetDataFirstRow();
			if (colName == "totIncome" || colName == "fixBonusPay") {
				var t1 = sheet1.GetCellValue(firstRow, "totIncome") ? Number(sheet1.GetCellValue(firstRow, "totIncome")) : 0;
				var t2 = sheet1.GetCellValue(firstRow, "fixBonusPay") ? Number(sheet1.GetCellValue(firstRow, "fixBonusPay")) : 0;
				var t3 = sheet1.GetCellValue(firstRow, "finPsPay") ? Number(sheet1.GetCellValue(firstRow, "finPsPay")) : 0;
				sheet1.SetCellValue(firstRow, "resultIncome", t1 - t2, false);
				sheet1.SetCellValue(firstRow, "totResult", (t1 - t2) - t3, false);
			}
			
			
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}	
</script>


<!-- sheet3 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction3(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet3.DoSearch( "${ctx}/RewardPsIncreaseSimulationMgr.do?cmd=getRewardPsIncreaseSimulationMgrList3", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				//if(sheet3.FindStatusRow("I") != ""){
				//	if(!dupChk(sheet3,"wEnterCd|sabun|compAppraisalCd|appEnterCd|appSabun", true, true)){break;}
				//}
				IBS_SaveName(document.srchFrm,sheet3);
				sheet3.DoSave( "${ctx}/SaveData.do?cmd=saveRewardPsIncreaseSimulationMgr3", $("#srchFrm").serialize()); break;
				break;

			case "Clear":		//Clear
				sheet3.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet3.Down2Excel({DownCols:makeHiddenSkipCol(sheet3),SheetDesign:1,Merge:1});
				break;
		}
	}

//<!-- 조회 후 에러 메시지 -->
	function sheet3_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

//<!-- 저장 후 에러 메시지 -->
	function sheet3_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

//<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
	function sheet3_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}

	function sheet3_OnChange(Row, Col, Value) {
		try{
			var colName = sheet3.ColSaveName(Col);
			if (colName == "bfAnnualIncome") { // 연봉
				var bfAnnualIncome = sheet3.GetCellValue(Row, "bfAnnualIncome") ? Number(sheet3.GetCellValue(Row, "bfAnnualIncome")) : 0;
				sheet3.SetCellValue(Row, "gradePay", resultColumnCalcValue(Row,"gradePay"), false);
				sheet3.SetCellValue(Row, "busiIncenPay", resultColumnCalcValue(Row,"busiIncenPay"), false);
				sheet3.SetCellValue(Row, "finPsPay", resultColumnCalcValue(Row,"finPsPay"), false);
			} else if (colName == "grade") {
				sheet3.SetCellValue(Row, "gradeRate", resultColumnCalcValue(Row,"gradeRate"), false);
				sheet3.SetCellValue(Row, "gradePay", resultColumnCalcValue(Row,"gradePay"), false);
				sheet3.SetCellValue(Row, "busiIncenPay", resultColumnCalcValue(Row,"busiIncenPay"), false);
				sheet3.SetCellValue(Row, "finPsPay", resultColumnCalcValue(Row,"finPsPay"), false);
			} else if (colName == "gradeRate") {
				sheet3.SetCellValue(Row, "gradePay", resultColumnCalcValue(Row,"gradePay"), false);
				sheet3.SetCellValue(Row, "busiIncenPay", resultColumnCalcValue(Row,"busiIncenPay"), false);
				sheet3.SetCellValue(Row, "finPsPay", resultColumnCalcValue(Row,"finPsPay"), false);
			} else if (colName == "busiIncenRate") {
				sheet3.SetCellValue(Row, "busiIncenPay", resultColumnCalcValue(Row,"busiIncenPay"), false);
				sheet3.SetCellValue(Row, "finPsPay", resultColumnCalcValue(Row,"finPsPay"), false);
			} else if (colName == "busiIncenPay") {
				sheet3.SetCellValue(Row, "finPsPay", resultColumnCalcValue(Row,"finPsPay"), false);
			} else if (colName == "workTermRate") {
				sheet3.SetCellValue(Row, "busiIncenPay", resultColumnCalcValue(Row,"busiIncenPay"), false);
				sheet3.SetCellValue(Row, "finPsPay", resultColumnCalcValue(Row,"finPsPay"), false);
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
	
	// 컬럼에 따른 값 계산후 리턴
	function resultColumnCalcValue(Row, psColumn) {
		var result = null;
		if (psColumn == "gradeRate") {
			var grade = sheet3.GetCellValue(Row, "grade");
			gradeList.forEach(function(item, idx, arr){
				if (item.colNm == grade) {
					result = item.colVal; 
				} 
			});
		} else if (psColumn == "gradePay") { // 평가등급 산출액 ROUNDUP(L320/12*O320,-1)
			var bfAnnualIncome = sheet3.GetCellValue(Row, "bfAnnualIncome") ? Number(sheet3.GetCellValue(Row, "bfAnnualIncome")) : 0;
			var gradeRate = sheet3.GetCellValue(Row, "gradeRate") ? Number(sheet3.GetCellValue(Row, "gradeRate")) : 0;
			result = Math.ceil(((bfAnnualIncome / 12) * (gradeRate * 0.01)) * 0.1) * 10;   			
		} else if (psColumn == "busiIncenPay") { // 영업인센티브가감율 =IFERROR(ROUNDUP(ROUNDUP(L319/12*O319*S319,-1)*Q319*S319,-1),0)
			var bfAnnualIncome = sheet3.GetCellValue(Row, "bfAnnualIncome") ? Number(sheet3.GetCellValue(Row, "bfAnnualIncome")) : 0;
			var gradeRate = sheet3.GetCellValue(Row, "gradeRate") ? Number(sheet3.GetCellValue(Row, "gradeRate")) : 0;
			var workTermRate = sheet3.GetCellValue(Row, "workTermRate") ? Number(sheet3.GetCellValue(Row, "workTermRate")) : 0;
			var busiIncenRate = sheet3.GetCellValue(Row, "busiIncenRate") ? Number(sheet3.GetCellValue(Row, "busiIncenRate")) : 0;
			result = Math.ceil((Math.ceil((((bfAnnualIncome / 12) * (gradeRate * 0.01) ) * (workTermRate * 0.01)) * 0.1) * 10) * busiIncenRate * (workTermRate * 0.01));   
		}  else if ("finPsPay") { // 2023PS =IFERROR(ROUNDUP(L260/12*O260*S260,-1)+R260,0)
			var bfAnnualIncome = sheet3.GetCellValue(Row, "bfAnnualIncome") ? Number(sheet3.GetCellValue(Row, "bfAnnualIncome")) : 0;
			var gradeRate = sheet3.GetCellValue(Row, "gradeRate") ? Number(sheet3.GetCellValue(Row, "gradeRate")) : 0;
			var workTermRate = sheet3.GetCellValue(Row, "workTermRate") ? Number(sheet3.GetCellValue(Row, "workTermRate")) : 0;
			var busiIncenPay = sheet3.GetCellValue(Row, "busiIncenPay") ? Number(sheet3.GetCellValue(Row, "busiIncenPay")) : 0;
			result = (Math.ceil((((bfAnnualIncome / 12) * (gradeRate * 0.01) ) * (workTermRate * 0.01)) * 0.1) * 10) + busiIncenPay;
		}  else {
			result = null;
		}
		return result;
	}
	
	function visibleUpSheet() {
		if ($("#sheet_up").css("display") == "none") {
			$("#toggleBtn").text("접기");
	        $("#DIV_"+sheet1.id).show();
	        $("#DIV_"+sheet2.id).show();
	        $("#sheet_up").addClass("outer");
	        $("#sheet_up").show();
	        $("#DIV_"+sheet3.id).css("height", "calc(100% - " + $("#sheet_up").css("height") + "px)");
	        sheetResize();
		} else {
			$("#toggleBtn").text("펼치기");
			$("#DIV_"+sheet1.id).hide();
	        $("#DIV_"+sheet2.id).hide();
	        $("#sheet_up").hide();
	        $("#sheet_up").removeClass("outer");
	        $("#DIV_"+sheet3.id).css("height", "calc(100%)");
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
							<li id="txt" class="txt">PS 재원</li>
							<li class="btn">
								<a href="javascript:doAction1('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "200px","${ssnLocaleCd}"); </script>
			</td>
			<td style="width:10px;">
			</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">평가 등급</li>
							<li class="btn">
								<a href="javascript:doAction2('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction2('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "200px","${ssnLocaleCd}"); </script>
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
								<a href="javascript:create()" class="button authA"><tit:txt mid='112692' mdef='PS대상자 생성'/></a>
								<a href="javascript:doAction3('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction3('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet3", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>