<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var p = eval("${popUpStatus}");
var gPRow = "";
var pGubun = "";

$(function() {

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='fiYear' mdef='회계년도'/>",			Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  ColMerge:1,   SaveName:"fiYear",          KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduSeqV3' mdef='과정순번'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:1,   SaveName:"eduSeq",          KeyField:1,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='eduMBranchCd' mdef='교육분류'/>", 			Type:"Combo",     Hidden:1,  Width:120,  Align:"Center",  ColMerge:1,   SaveName:"eduMBranchCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eduCourseCd' mdef='과정코드'/>",			Type:"Text",      Hidden:1,  Width:80,   Align:"Left",    ColMerge:1,   SaveName:"eduCourseCd",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eduCourseNm' mdef='과정명'/>",				Type:"Text",      Hidden:0,  Width:150,	 Align:"Left",    ColMerge:1,   SaveName:"eduCourseNm",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",			Type:"Image",     Hidden:1,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"selectImg",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='eduOrgCdV1' mdef='교육기관코드'/>",		Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:1,   SaveName:"eduOrgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eduOrgNmV1' mdef='교육기관명'/>",			Type:"Popup",     Hidden:1,  Width:80,   Align:"Left",    ColMerge:1,   SaveName:"eduOrgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='eduTarget' mdef='교육대상'/>",			Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:1,   SaveName:"eduTarget",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eduCourseSub' mdef='교육과정\n(부제)'/>",	Type:"Text",      Hidden:1,  Width:150,	 Align:"Left",    ColMerge:1,   SaveName:"eduCourseSub",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='eduStatusCdV3' mdef='과정상태'/>",			Type:"Combo",     Hidden:1,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"eduStatusCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='bizCdV2' mdef='구분'/>", 				Type:"Combo",     Hidden:1,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"inOutType",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='eduMethodCd' mdef='시행방법'/>", 			Type:"Combo",     Hidden:1,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"eduMethodCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eduBranchCdV2' mdef='교육형태구분'/>", 		Type:"Combo",     Hidden:1,  Width:120,  Align:"Center",  ColMerge:1,   SaveName:"eduBranchCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eduTermV1' mdef='기간'/>", 				Type:"Float",     Hidden:1,  Width:50,   Align:"Right",   ColMerge:1,   SaveName:"eduTerm",         KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='danwi' mdef='단위'/>",				Type:"Combo",     Hidden:1,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"eduUnitCd",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eduHourV4' mdef='총시간'/>", 			Type:"Float",     Hidden:1,  Width:50,   Align:"Right",   ColMerge:1,   SaveName:"eduHour",         KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
		    {Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>", 			Type:"Date",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"eduSYmd",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>", 			Type:"Date",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:1,   SaveName:"eduEYmd",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='minPersonV1' mdef='최소'/>", 				Type:"Float",     Hidden:1,  Width:50,   Align:"Right",   ColMerge:1,   SaveName:"minPerson",       KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"<sht:txt mid='maxPersonV3' mdef='최대'/>", 				Type:"Float",     Hidden:1,  Width:50,   Align:"Right",   ColMerge:1,   SaveName:"maxPerson",       KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='essentialYn' mdef='필수여부'/>", 			Type:"Combo",     Hidden:1,  Width:60,   Align:"Center",  ColMerge:1,   SaveName:"mandatoryYn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N" },
            {Header:"<sht:txt mid='foreignCdV2' mdef='진행언어'/>", 			Type:"Combo",     Hidden:1,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"foreignCd",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='payYn' mdef='급여공제'/>", 			Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"payYn",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='genCredit' mdef='일반'/>", 				Type:"Text",      Hidden:1,  Width:70,   Align:"Right",   ColMerge:1,   SaveName:"genCredit",       KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"<sht:txt mid='wmCredit' mdef='WM'/>", 				Type:"Text",      Hidden:1,  Width:70,   Align:"Right",   ColMerge:1,   SaveName:"wmCredit",        KeyField:0,   CalcLogic:"",   Format:"Float",       PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4 },
            {Header:"<sht:txt mid='eduRewardCdV2' mdef='종류'/>",			 	Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"eduRewardCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eduRewardCntV2' mdef='내역'/>", 				Type:"Text",      Hidden:1,  Width:50,   Align:"Right",   ColMerge:1,   SaveName:"eduRewardCnt",    KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='chargeSabunV1' mdef='담당자사번'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:1,   SaveName:"chargeSabun",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
            {Header:"<sht:txt mid='chargeNameV1' mdef='담당자성명'/>", 		Type:"PopupEdit", Hidden:1,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"chargeName",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='orgCdV10' mdef='담당자\n소속코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:1,   SaveName:"orgCd",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='orgNmV13' mdef='담당자\n소속명'/>", 		Type:"PopupEdit", Hidden:1,  Width:100,  Align:"Left",    ColMerge:1,   SaveName:"orgNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='chargeTelV1' mdef='담당자\n전화번호'/>", 	Type:"Text", 	  Hidden:1,  Width:100,  Align:"Left",    ColMerge:1,   SaveName:"chargeTel",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='eduBudgetV1' mdef='과정예산'/>", 			Type:"Int",       Hidden:1,  Width:60,   Align:"Left",    ColMerge:1,   SaveName:"eduBudget",       KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
            {Header:"<sht:txt mid='eduMemoV1' mdef='과정내용'/>", 			Type:"Text",      Hidden:1,  Width:300,  Align:"Left",    ColMerge:1,   SaveName:"eduMemo",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
            {Header:"<sht:txt mid='eduCourseGoal' mdef='과정목표'/>", 			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:1,   SaveName:"eduCourseGoal",   KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
            {Header:"<sht:txt mid='eduCourseThema' mdef='과정테마'/>", 			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:1,   SaveName:"eduCourseThema",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:200 },
            {Header:"<sht:txt mid='finishCondition' mdef='이수조건'/>", 			Type:"Text",      Hidden:1,  Width:50,   Align:"Left",    ColMerge:1,   SaveName:"finishCondition", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:400 },
            {Header:"<sht:txt mid='cntV1' mdef='주요교육'/>", 			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    ColMerge:1,   SaveName:"cnt",             KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var list1 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10010"), ""); //교육체계구분 res2
		var list2 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10050"), ""); //시행방법
		var list3 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10170"), ""); //과정상태 res1
		var list4 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10110"), ""); //보상종류
		var list5 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20300"), ""); //진행언어
		var list6 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10020"), ""); //교육기간단위
		var list7 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L20020"), ""); //사내외구분
		var list8 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10015"), "<tit:txt mid='103895' mdef='전체'/>"); //교육영역
		var list9 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L20030"), "<tit:txt mid='103895' mdef='전체'/>"); //필수여부   res3

		sheet1.SetColProperty("inOutType", 		{ComboText:"|"+list7[0], ComboCode:"|"+list7[1]} );
		sheet1.SetColProperty("eduMethodCd", 	{ComboText:"|"+list2[0], ComboCode:"|"+list2[1]} );
		sheet1.SetColProperty("eduStatusCd", 	{ComboText:"|"+list3[0], ComboCode:"|"+list3[1]} );
		sheet1.SetColProperty("eduUnitCd", 		{ComboText:"|"+list6[0], ComboCode:"|"+list6[1]} );
		sheet1.SetColProperty("eduRewardCd", 	{ComboText:"|"+list4[0], ComboCode:"|"+list4[1]} );
		sheet1.SetColProperty("foreignCd", 		{ComboText:"|"+list5[0], ComboCode:"|"+list5[1]} );
		sheet1.SetColProperty("eduBranchCd", 	{ComboText:"|"+list1[0], ComboCode:"|"+list1[1]} );
		sheet1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+list8[0], ComboCode:"|"+list8[1]} );
		sheet1.SetColProperty("mandatoryYn", 	{ComboText:"|"+list9[0], ComboCode:"|"+list9[1]} );

		//$("#searchEduStatusCd").html(list3[2]);
		$("#searchEduMBranchCd").html(list8[2]);
		$("#searchMandatoryYN").html(list9[2]);

		$("#searchEduCourseNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchEduOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchChargeName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchFiYear").bind("keyup",function(event){
			makeNumber(this,"A");
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		sheet1.SetDataLinkMouse("selectImg", 1);
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		//Cancel 버튼 처리
		$(".close").click(function(){
			p.self.close();
		});
	});
/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
    switch(sAction){
        case "Search":      //조회

        	sheet1.DoSearch( "${ctx}/EduCourseMgr.do?cmd=getEduCourseMgrList", $("#srchFrm").serialize() );
            break;

        case "Down2Excel":  //엑셀내려받기

            sheet1.Down2Excel();
            break;

        case "LoadExcel":   //엑셀업로드

			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
            break;

    }
}

</script>

<script language="javascript">
  function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
  try{
    if (ErrMsg != ""){
        alert(ErrMsg) ;
    }else{

        for( i = 1; i<=sheet1.LastRow(); i++) {
            if( sheet1.GetCellValue(i, "cnt") != "0" ) {
                sheet1.SetCellEditable(i, "sDelete",false);
            }
        }

    }
	$(window).smartresize(sheetResize); sheetInit();
  }catch(ex){alert("OnSearchEnd Event Error : " + ex);}
}

function sheet1_OnDblClick(Row, Col){
	var rv = new Array();
	//rv["eduCourseCd"]	= sheet1.GetCellValue(Row, "eduCourseCd");
	rv["eduCourseNm"]	= sheet1.GetCellValue(Row, "eduCourseNm");
	rv["eduSeq"]		= sheet1.GetCellValue(Row, "eduSeq");
	rv["eduOrgCd"]		= sheet1.GetCellValue(Row, "eduOrgCd");
	rv["eduOrgNm"]		= sheet1.GetCellValue(Row, "eduOrgNm");
	rv["eduSYmd"]		= sheet1.GetCellValue(Row, "eduSYmd");
	rv["eduEYmd"]		= sheet1.GetCellValue(Row, "eduEYmd");
	rv["maxPerson"]		= sheet1.GetCellValue(Row, "maxPerson");
	rv["eduTerm"]		= sheet1.GetCellValue(Row, "eduTerm");
	rv["eduHour"]		= sheet1.GetCellValue(Row, "eduHour");
	rv["eduRewardCd"]	= sheet1.GetCellValue(Row, "eduRewardCd");
	rv["eduRewardCnt"]	= sheet1.GetCellValue(Row, "eduRewardCnt");
	rv["chargeName"]	= sheet1.GetCellValue(Row, "chargeName");
	rv["orgNm"]			= sheet1.GetCellValue(Row, "orgNm");
	rv["orgCd"]			= sheet1.GetCellValue(Row, "orgCd");
	rv["eduMBranchCd"]	= sheet1.GetCellValue(Row, "eduMBranchCd");
	rv["eduBranchCd"]	= sheet1.GetCellValue(Row, "eduBranchCd");

	p.popReturnValue(rv);
	p.window.close();
}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
			<ul>
				<li><tit:txt mid='eduCoursePop' mdef='교육과정 리스트 조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
        <form id="srchFrm" name="srchFrm" tabindex="1">
            <input type="hidden" id="searchEnterCd" name="searchEnterCd" />
            <input type="hidden" id="chkVisualYn" name="chkVisualYn" value="Y" />
	<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th class="hide"><tit:txt mid='112022' mdef='과정코드 '/></th>
						<td class="hide"> 
						    <input id="searchEduCourseCd" name ="searchEduCourseCd" type="text" class="text w50" maxlength="10"/> </td>
					    <th><tit:txt mid='114492' mdef='과정명 '/></th>
						<td> 
						    <input id="searchEduCourseNm" name ="searchEduCourseNm" type="text" class="text w100" /> </td>
						<td>
						<a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
					</td>
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
							<li id="txt" class="txt"><tit:txt mid='eduCoursePopV1' mdef='교육과정'/></li>

						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
	<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
</div>
</body>
</html>
