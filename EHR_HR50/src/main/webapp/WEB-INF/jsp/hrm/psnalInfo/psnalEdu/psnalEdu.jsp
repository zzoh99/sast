<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112278' mdef='인사기본(교육)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	$(function() {
		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		$("#hdnEnterCd").val($("#searchUserEnterCd",parent.document).val());
		var enterCd = "&enterCd="+$("#hdnEnterCd").val();
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:13,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",			Type:"Image",     Hidden:1,  Width:60,   Align:"Center",  ColMerge:1,   SaveName:"selectImg",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",				Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sabun",           KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"PopupEdit", Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"name",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",				Type:"Text",      Hidden:1,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",				Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='eduSeq' mdef='과정순서'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"eduSeq",          KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='eduCourseCd' mdef='과정코드'/>",			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"eduCourseCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduCourseNm' mdef='과정명'/>",				Type:"Text",      Hidden:0,  Width:300,  Align:"Left",    ColMerge:0,   SaveName:"eduCourseNm",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",				Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"eduSYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",				Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"eduEYmd",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"이벤트순번",			Type:"Text",      Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"eduEventSeq",     KeyField:1,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='eduEventNm' mdef='회차명'/>",				Type:"PopupEdit", Hidden:1,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"eduEventNm",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='eduEventSub' mdef='회차명(부제)'/>",		Type:"Text",      Hidden:1,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"eduEventSub",     KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='eduOrgCd' mdef='기관코드'/>",			Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"eduOrgCd",        KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"사내/외",				Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"inOutType",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='eduBranchCd' mdef='교육구분'/>",			Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",    ColMerge:0,   SaveName:"eduBranchCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:2000 },
			{Header:"<sht:txt mid='eduMBranchCd' mdef='교육분류'/>",			Type:"Combo",     Hidden:0,  Width:150,   Align:"Left",    ColMerge:0,   SaveName:"eduMBranchCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:2000 },
			{Header:"<sht:txt mid='eduMethodCd' mdef='시행방법'/>",			Type:"Combo",     Hidden:0,  Width:100,   Align:"Center",    ColMerge:0,   SaveName:"eduMethodCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:2000 },
			{Header:"<sht:txt mid='essentialYn' mdef='필수여부'/>",			Type:"Combo",     Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"mandatoryYn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:"<sht:txt mid='eduOrgNm' mdef='교육기관'/>",			Type:"Popup",     Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"eduOrgNm",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='eduPlace' mdef='교육장소'/>",			Type:"Text",      Hidden:1,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"eduPlace",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='eduPlaceEtc' mdef='교육장소(기타)'/>",		Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"eduPlaceEtc",     KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='eduCntDate' mdef='교육일수'/>",			Type:"Text",      Hidden:1,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"eduDay",          KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='eduHour' mdef='교육시간'/>",			Type:"Float",     Hidden:1,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"eduHour",         KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='memoV1' mdef='수강월'/>",				Type:"Text",      Hidden:1,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"memo",            KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='currencyCd' mdef='통화단위'/>",			Type:"Combo",     Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"currencyCd",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"교육비",												Type:"Float",     Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"realExpenseMon",   KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='perExpenseMon' mdef='인당교육비'/>",			Type:"Float",     Hidden:1,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"perExpenseMon",   KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='laborApplyYn' mdef='고용보험\n적용여부'/>",	Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"laborReturnYn",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:"<sht:txt mid='laborMon' mdef='환급금액'/>",			Type:"Float",     Hidden:1,  Width:60,   Align:"Right",   ColMerge:0,   SaveName:"laborMon",        KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='eduRewardCd' mdef='보상종류'/>",			Type:"Combo",     Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"eduRewardCd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='eduRewardCnt' mdef='보상내역'/>",			Type:"Float",     Hidden:1,  Width:100,  Align:"Right",   ColMerge:0,   SaveName:"eduRewardCnt",    KeyField:0,   CalcLogic:"",   Format:"NullFloat",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='eduAppLevel' mdef='교육평가\n등급'/>",		Type:"Text",      Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"eduAppLevel",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:3 },
			{Header:"<sht:txt mid='eduAppPoint' mdef='교육평가\n점수'/>",		Type:"Int",       Hidden:1,  Width:60,   Align:"Right",   ColMerge:0,   SaveName:"eduAppPoint",     KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:3 },
			{Header:"<sht:txt mid='eduConfirmType' mdef='교육수료\n구분'/>",		Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"eduConfirmType",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
			{Header:"<sht:txt mid='unconfirmReason' mdef='미수료사유'/>",			Type:"Text",      Hidden:1,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"unconfirmReason", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:2000 },
			{Header:"<sht:txt mid='eduResult1' mdef='교육결과보고'/>",		Type:"Image",     Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"eduResult1",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='eduResult2' mdef='미이수보고'/>",			Type:"Text",      Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"eduResult2",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='receiptYn' mdef='영수증\n제출여부'/>",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"receiptYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:2000 },
			{Header:"<sht:txt mid='certiYn' mdef='수료증\n제출여부'/>",	Type:"Combo",     Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"certiYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:2000 },
			{Header:"<sht:txt mid='allowanceYn' mdef='연수보조비\n여부'/>",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"allowanceYn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:2000 },
			{Header:"<sht:txt mid='employmentYn' mdef='고용보험\n증빙'/>",		Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"employmentYn",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:2000 },
			{Header:"<sht:txt mid='apApplSeq' mdef='결과보고신청서순번'/>",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"apApplSeq",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:2000 },
			{Header:"<sht:txt mid='apApplSeqV2' mdef='신청서순번'/>",			Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"applSeq1",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:2,   UpdateEdit:0,   InsertEdit:0,   EditLen:2000 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

        sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
        
		//공통코드 한번에 조회
		var grpCds = "L10010,L10015,L10050,L20020,L20040,P00001,S10030,L10110";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds + enterCd,false).codeList, "전체");
		
		var list1 = codeLists["L10010"]; /* 교육구분 */
		var list2 = codeLists["L10015"]; /* 교육분류맵핑 */
		var list3 = codeLists["L10050"]; /* 시행방법 */
		var list4 = codeLists["L20020"]; /* 사내외구분 */
		var list5 = codeLists["L20040"]; /* 교육장소 */
		var list6 = codeLists["P00001"]; /* 평가등급 */
		var list7 = codeLists["S10030"]; /* 통화단위 */
		var list8 = codeLists["L10110"]; /* 보상내역 */

		sheet1.SetColProperty("inOutType", 		{ComboText:"|"+list4[0], ComboCode:"|"+list4[1]} );
		sheet1.SetColProperty("eduPlace", 		{ComboText:"|"+list5[0], ComboCode:"|"+list5[1]} );
		sheet1.SetColProperty("mandatoryYn",	{ComboText:"|YES|NO", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("currencyCd", 	{ComboText:"|"+list7[0], ComboCode:"|"+list7[1]} );
		sheet1.SetColProperty("laborReturnYn", 	{ComboText:"|YES|NO", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("eduRewardCd", 	{ComboText:"|"+list8[0], ComboCode:"|"+list8[1]} );
		sheet1.SetColProperty("eduConfirmType", {ComboText:("${ssnLocaleCd}" != "en_US" ? "수료|미수료" : "Completion|Non-completion"), ComboCode:"1|0"} );
		sheet1.SetColProperty("eduBranchCd", 	{ComboText:"|"+list1[0], ComboCode:"|"+list1[1]} );
		sheet1.SetColProperty("eduMethodCd", 	{ComboText:"|"+list3[0], ComboCode:"|"+list3[1]} );
		sheet1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+list2[0], ComboCode:"|"+list2[1]} );
		sheet1.SetColProperty("eduAppLevel", 	{ComboText:"|"+list6[0], ComboCode:"|"+list6[1]} );
		sheet1.SetColProperty("certiYn", 		{ComboText:"YES|NO", ComboCode:"Y|N"} );
		sheet1.SetColProperty("allowanceYn", 	{ComboText:"YES|NO", ComboCode:"Y|N"} );
		sheet1.SetColProperty("receiptYn", 		{ComboText:"YES|NO", ComboCode:"Y|N"} );
		sheet1.SetColProperty("employmentYn", 	{ComboText:"YES|NO", ComboCode:"Y|N"} );

/*
		var rst = ajaxCall("${ctx}/PsnalBasic.do?cmd=getPsnalBasicList", "sabun="+$("#hdnSabun").val(), false);
		var stYear = rst.DATA[0].empYmd.substring(0,4);
		for(var year = ${curSysYear}+1 ; year >= stYear;year--){
			$("<option/>").attr("value",year).text(year).appendTo($("#year"));
		}
		$("#year").val( "${curSysYear}" ) ;
*/
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");

	});

	$(function() {
		/* $("#year").change(function(){
			doAction1("Search");
		}); */
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()
			+"&searchUserEnterCd="+$("#hdnEnterCd").val();
						/* +"&year="+$("#year").val(); */
			sheet1.DoSearch( "${ctx}/PsnalEdu.do?cmd=getPsnalEduList", param );
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
			/*
			$("#txtStdScore").text(sheet1.GetEtcData("stdScore"));
			$("#txtTotScore").text(sheet1.GetEtcData("totScore"));
			*/
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

	function goPop(){

		var args	= new Array();
		args["searchYyyy"] 	= $("#year").val();
		args["sabun"] 	= $("#hdnSabun").val();

		var rv = openPopup("/Popup.do?cmd=eduPointStdPopup", args, "750","520");
		/*
		if(rv!=null){
			sheet1.SetCellValue(Row,"appOrgNm",(rv["orgNm"]));
			sheet1.SetCellValue(Row,"appOrgCd",(rv["orgCd"]));
		}
		*/
	}
</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='edu' mdef='교육'/></li>
			<li class="btn">
				<!-- 교육년도
				<select id="year" name="year" class="required">
				<option value="">전체</option>
				</select> -->
				<btn:a href="javascript:doAction1('Search');" css="btn dark authR" mid='110697' mdef="조회"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<table border="0" cellpadding="0" cellspacing="0" class="default outer hide">
	<colgroup>
		<col width="20%" />
		<col width="30%" />
		<col width="20%" />
		<col width="" />
	</colgroup>
	<tr>
		<th><tit:txt mid='114395' mdef='필수이수학점'/></th>
		<td>
			<span id="txtStdScore"></span>
		</td>
		<th><tit:txt mid='113336' mdef='연간인정학점합계'/></th>
		<td>
			<span id="txtTotScore"></span>
		</td>
	</tr>
	</tr>
	</table>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
