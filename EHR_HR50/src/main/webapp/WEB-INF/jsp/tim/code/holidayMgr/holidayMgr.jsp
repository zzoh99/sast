<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>근태코드관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='\n삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='businessPlaceNm' mdef='사업장'/>",Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"businessPlaceCd",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='appraisalYy' mdef='년도'/>",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"yy",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"<sht:txt mid='2021072200126' mdef='월'/>",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"mm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"<sht:txt mid='2021072200127' mdef='일'/>",					Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"dd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2 },
			{Header:"<sht:txt mid='2021072200125' mdef='공휴일여부'/>",	Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"holidayYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='replaceHoliday' mdef='대체휴일'/>",	Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"replaceHoliday",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='seq' mdef='일련번호'/>",			Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"holidayCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='holidayNm' mdef='휴일명'/>",		Type:"Text",		Hidden:0,	Width:90,	Align:"Left",	ColMerge:0,	SaveName:"holidayNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='languageCd' mdef='어휘코드'/>",	Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",	Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='gubun_V1131' mdef='구분'/>",		Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"gubun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='festiveYn' mdef='명절구분'/>",	Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"festiveYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='payYnV4' mdef='유급여부'/>",	Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"payYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
		}
		var bizPlaceCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장

		var allOpt = "<option value=''>전체</option>";
		$("#searchBizPlaceCd").html(bizPlaceCdList[2]);
		$("#fromBizPlaceCd").html(allOpt + bizPlaceCdList[2]);
		$("#toBizPlaceCd").html(allOpt + bizPlaceCdList[2]);

		var mStr = "<tit:txt mid='113805' mdef='월'/>";
		var dStr = "<tit:txt mid='day' mdef='일'/>";
		var mmNm =  "01" + mStr + "|02" + mStr + "|03" + mStr + "|04" + mStr+ "|05" + mStr
		         + "|06" + mStr + "|07" + mStr + "|08" + mStr + "|09" + mStr+ "|10" + mStr
		         + "|11" + mStr + "|12" + mStr;
		var mmCd = "01|02|03|04|05|06|07|08|09|10|11|12";
		var ddNm =  "01" + dStr + "|02" + dStr + "|03" + dStr + "|04" + dStr + "|05" + dStr
		         + "|06" + dStr + "|07" + dStr + "|08" + dStr + "|09" + dStr + "|10" + dStr
		         + "|11" + dStr + "|12" + dStr + "|13" + dStr + "|14" + dStr + "|15" + dStr
		         + "|16" + dStr + "|17" + dStr + "|18" + dStr + "|19" + dStr + "|20" + dStr
		         + "|21" + dStr + "|22" + dStr + "|23" + dStr + "|24" + dStr + "|25" + dStr
		         + "|26" + dStr + "|27" + dStr + "|28" + dStr + "|29" + dStr + "|30" + dStr
		         + "|31" + dStr;
		var ddCd = "01|02|03|04|05|06|07|08|09|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28|29|30|31";

		sheet1.SetColProperty("mm", 			{ComboText:mmNm, ComboCode:mmCd} );
		sheet1.SetColProperty("dd", 			{ComboText:ddNm, ComboCode:ddCd} );
		sheet1.SetColProperty("gubun",			{ComboText:"<tit:txt mid='113576' mdef='양력'/>|<tit:txt mid='113577' mdef='음력'/>", ComboCode:"1|2"} );
		sheet1.SetColProperty("holidayYn",		{ComboText:"N|Y", ComboCode:"N|Y"} );
		sheet1.SetColProperty("festiveYn",		{ComboText:"N|Y", ComboCode:"N|Y"} );
		sheet1.SetColProperty("payYn",			{ComboText:"N|Y", ComboCode:"N|Y"} );

		sheet1.SetColProperty("businessPlaceCd",	{ComboText:bizPlaceCdList[0], ComboCode:bizPlaceCdList[1]} );



		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {

        $("#searchYear").bind("keyup",function(event){
        	makeNumber(this,"A");
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

        $("#searchBizPlaceCd").bind("change",function(event){
			doAction1("Search");
		});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($("#searchYear").val() == "") {
				alert("<msg:txt mid='alertHolidayMgr1' mdef='년도를 입력하여 주십시오.'/>");
				return;
			}

			sheet1.DoSearch( "${ctx}/HolidayMgr.do?cmd=getHolidayMgrList", $("#sheet1Form").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/HolidayMgr.do?cmd=saveHolidayMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":

			if($("#searchYear").val() == "") {
				alert("<msg:txt mid='alertHolidayMgr1' mdef='년도를 입력하여 주십시오.'/>");
				return;
			}

			var row = sheet1.DataInsert(0);

			sheet1.SetCellValue(row, "yy",$("#searchYear").val());
			sheet1.SetCellValue(row, "mm","${curSysMon}");
			sheet1.SetCellValue(row, "dd","${curSysDay}");

			sheet1.SelectCell(row, "holidayNm");

			break;
		case "CopyYear":

			if($("#fromYear").val() == "") {
				alert("원본 대상년도를 입력 해주세요.");
				$("#fromYear").focus();
				return;
			}

			if($("#toYear").val() == "") {
				alert("대상년도를 입력 해주세요.");
				$("#fromYear").focus();
				return;
			}

			if($("#fromBizPlaceCd").val() == "" && $("#toBizPlaceCd").val() != "" ){
				alert("원본 사업장을 선택 해주세요.");
				$("#fromBizPlaceCd").focus();
				return;
			}

			/* 2020.03.16 막음
			if($("#fromBizPlaceCd").val() != "" && $("#toBizPlaceCd").val() == "" ){
				alert("사업장을 선택 해주세요.");
				$("#toBizPlaceCd").focus();
				return;
			}
			*/

			if($("#fromYear").val() == $("#toYear").val() && $("#fromBizPlaceCd").val() == $("#toBizPlaceCd").val() ) {
				alert("원본과 대상이 같습니다.");
				$("#toBizPlaceCd").focus();
				return;
			}


			//원본 데이터가 있는지 확인
			var data = ajaxCall("${ctx}/HolidayMgr.do?cmd=getHolidayMgrCnt",$("#sheet1Form").serialize(), false);
			if ( data != null && data.DATA != null ){

				if(data.DATA.cnt == 0) {
					alert($("#fromYear").val()+"<msg:txt mid='alertHolidayMgr3' mdef='년도에 데이터가 없습니다.'/>");
					return;
				}
			}

			if(!confirm("복사 하시겠습니끼? \n기존 데이터는 삭제됩니다.")) {
				return;
			}

			ajaxCall2("${ctx}/HolidayMgr.do?cmd=copyHolidayMgr"
					, $("#sheet1Form").serialize()
					, true
					, function() {
						progressBar(true, "복사 중입니다.");
					}, function(data) {
						progressBar(false);
						if (data && data.Result) {

							alert(data.Result.Message);

							if (data.Result.Code > 0) {

								//일근무갱신 (비동기)
								$.ajax({
									url: "${ctx}/HolidayMgr.do?cmd=prcReplaceHoliday",
									type: "post",
									dataType: "json",
									async: true,
									data: $("#sheet1Form").serialize()
								});

								$("#searchYear").val($("#toYear").val());
								$("#searchBizPlaceCd").val( (($("#toBizPlaceCd").val()) ? $("#toBizPlaceCd").val() : $("#searchBizPlaceCd").val()) );
								doAction1("Search");
							}
						} else {
							alert("복사 실패 하였습니다. 관리자에게 문의 바랍니다.");
						}
					}, function() {
						progressBar(false);
						alert("복사 실패 하였습니다. 관리자에게 문의 바랍니다.");
					})
			break;
		case "Copy":
			var row = sheet1.DataCopy();

			sheet1.SetCellValue(row, "holidayCd","");
			sheet1.SelectCell(row, "holidayNm");
			sheet1.SetCellValue(row, "languageCd", "" );
			sheet1.SetCellValue(row, "languageNm", "" );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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
			if( Code > -1 ) {
				
				//일근무갱신 (비동기)
                $.ajax({
                    url: "${ctx}/HolidayMgr.do?cmd=prcReplaceHoliday",
                    type: "post",
                    dataType: "json",
                    async: true,
                    data: $("#sheet1Form").serialize()
                });
				
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if (sheet1.ColSaveName(Col) == "languageNm") {
				lanuagePopup(Row, "sheet1", "ttim001", "languageCd", "languageNm", "holidayNm");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form id="sheet1Form" name="sheet1Form">
	<div class="sheet_search outer">
		<div>
			<table>
				<colgroup>
				    <col width="8%" />
				    <col width="8%" />
				    <col width="8%" />
				    <col width="10%" />
				    <col width="8%" />
				    <col width="8%" />
				    <col width="8%" />
				    <col width="8%" />
				    <col width="8%" />
				    <col width="*%" />
				</colgroup>
				<tbody>
					<tr>
						<th><tit:txt mid='104305' mdef='년도'/></th>
						<td>
							<input id="searchYear" name="searchYear" type="text" maxlength="4" class="text required w60 center" value="${curSysYear}" maxlength="4" numberOnly/>
						</td>
						<td colspan="3"></td>
						<th><tit:txt mid='114399' mdef='사업장'/></th>
						<td>
							<select id="searchBizPlaceCd" name="searchBizPlaceCd"> </select>
						</td>
						<td colspan="2"></td>
						<td class="right">
							<btn:a href="javascript:doAction1('Search');" css="btn dark" mid="search" mdef="조회"/>
						</td>
					</tr>
				</tbody>
				
			</table>
		</div>
	</div>
	<div class="h10 outer"></div>
	<table class="table outer">
		<colgroup>
		    <col width="8%" />
		    <col width="8%" />
		    <col width="8%" />
		    <col width="10%" />
		    <col width="8%" />
		    <col width="8%" />
		    <col width="8%" />
		    <col width="8%" />
		    <col width="8%" />
		    <col width="*%" />
		</colgroup>
		<tbody>
			<tr>
				<th>원본 대상년도</th>
				<td><input id="fromYear" name="fromYear" type="text" maxlength="4" class="text required w60 left" value="${curSysYear}" maxlength="4" numberOnly/>
				<th>원본 사업장</th>
				<td><select id="fromBizPlaceCd" name="fromBizPlaceCd" class="required"> </select></td>
				<td class="center"><img src="/common/images/sub/ico_arrow2.png"/></td>
				<th>년도</th>
				<td><input id="toYear" name="toYear" type="text" maxlength="4" class="text required w60 left" value="${curSysYear}" maxlength="4" numberOnly/>
				<th>사업장</th>
				<td><select id="toBizPlaceCd" name="toBizPlaceCd" class="required"> </select></td>
				<td align="right">
					<a href="javascript:doAction1('CopyYear');" class="btn filled authA">복사실행</a>
				</td>
			</tr>
		</tbody>
	</table>
</form>

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='holidayMgr' mdef='휴일관리'/></li>
			<li class="btn">
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