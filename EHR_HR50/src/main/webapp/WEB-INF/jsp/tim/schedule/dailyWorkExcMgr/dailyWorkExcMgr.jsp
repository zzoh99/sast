<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>일근무제외자관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow    = "";
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:7, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
     			{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
    			{Header:"삭제|삭제",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
    			{Header:"상태|상태",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
    			{Header:"근무지|근무지",					Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"locationCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
    			{Header:"소속|소속",					Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"사번|사번",					Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"성명|성명",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"직급|직급",					Type:"Text",		Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직위|직위",					Type:"Text",		Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"사원구분|사원구분",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"직종|직종",					Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"급여유형|급여유형",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"payTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"대상기간|시작일",					Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
				{Header:"대상기간|종료일",					Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"출근시간|출근시간",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"inHm",		KeyField:1,	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
				{Header:"퇴근시간|퇴근시간",				Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"outHm",		KeyField:1,	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
				{Header:"기본인정\n근무시간|기본인정\n근무시간",	Type:"Text",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"stdApplyHour",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"적용근무\n코드|적용근무\n코드",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workCd",					KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
				{Header:"사유|사유",					Type:"Combo",		Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	                        SaveName:"reasonCd",	    KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }

				]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

				getCommonCodeList();

				var workCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","getWorkCdList"), "<tit:txt mid='2017082900840' mdef='해당없음'/>");
				sheet1.SetColProperty("workCd", 	{ComboText:workCdList[0], ComboCode:workCdList[1]} );
		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var businessPlaceCd = "";
		if(allFlag) {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장
		} else {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchBizPlaceCd").html(businessPlaceCd[2]);

		//근무지 관리자권한만 전체근무지 보이도록, 그외는 권한근무지만.
		url     = "queryId=getLocationCdListAuth";
		allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var locationCdList = "";
		if(allFlag) {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장
		} else {
			locationCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
		}
		$("#searchLocationCd").html(locationCdList[2]);
		sheet1.SetColProperty("locationCd", {ComboText:"|"+locationCdList[0], ComboCode:"|"+locationCdList[1]});
		$("#searchOrgCd, #searchBizPlaceCd, #searchReasonCd").bind("change",function(event){
			doAction1("Search");
		});


		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

        $("#searchYmd").datepicker2({
   			onReturn:function(date){
				getCommonCodeList();
   				doAction1("Search");
   			}
        });
		$("#searchYmd, #searchSabun").on("keyup", function(event) {
			if(event.keyCode === 13) {
				doAction1("Search");
				$(this).focus();
			}
		});
		
		//Autocomplete	
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"] );
						sheet1.SetCellValue(gPRow, "name",			rv["name"] );
						sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"] );
						sheet1.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"] );
						sheet1.SetCellValue(gPRow, "jikweeNm",		rv["jikweeNm"] );
						sheet1.SetCellValue(gPRow, "manageNm",		rv["manageNm"] );
						sheet1.SetCellValue(gPRow, "workTypeNm",	rv["workTypeNm"] );
						sheet1.SetCellValue(gPRow, "payTypeNm",		rv["payTypeNm"] );
						sheet1.SetCellValue(gPRow, "locationCd",	rv["locationCd"] );

					}
				}
			]
		});

	});

	function getCommonCodeList() {
		let baseSYmd = $("#searchYmd").val();

		var reasonCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "T90100", baseSYmd), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("reasonCd", 		{ComboText:"|"+reasonCdList[0], ComboCode:"|"+reasonCdList[1]} );
		$("#searchReasonCd").html(reasonCdList[2]);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/DailyWorkExcMgr.do?cmd=getDailyWorkExcMgrList", $("#sheet1Form").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|sdate", false, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/DailyWorkExcMgr.do?cmd=saveDailyWorkExcMgr", $("#sheet1Form").serialize()); break;
		case "Insert":
			//신규로우 생성 및 변경
 			var newRow = sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"sabun|sdate|edate|inHm|outHm"});
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); }
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
				doAction1('Search');
			}

		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function clearCode() {
		$("#searchOrgCd").val("");
		$("#searchOrgNm").val("");
		doAction1("Search");
	}

//  소속 팝업
	function orgSearchPopup(){
	    try{
			const p = {runType: "00001,00002,00003,R0001,R0002,R0003"}
			let layerModal = new window.top.document.LayerModal({
				id : 'orgLayer'
				, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
				, parameters : p
				, width : 740
				, height : 520
				, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
				, trigger :[
					{
						name : 'orgTrigger'
						, callback : function(result){
							if(!result.length) return;
							$("#searchOrgNm").val(result[0].orgNm);
							$("#searchOrgCd").val(result[0].orgCd);
						}
					}
				]
			});
			layerModal.show();
	    }catch(ex){alert("Open Popup Event Error : " + ex);}
	}
	</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='104535' mdef='기준일'/> </th>
						<td>
							<input type="text" id="searchYmd" name="searchYmd"  class="date2 required" value="${curSysYyyyMMdd}" />
						</td>
						<th><tit:txt mid='104279' mdef='소속'/> </th>
						<td>
							<input type="hidden" id="searchOrgCd" name="searchOrgCd" />
							<input type="text" id="searchOrgNm" name="searchOrgNm"  class="text readonly" readonly/>
							<a href="javascript:orgSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a href="javascript:clearCode()" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
							<input id="searchOrgType" name="searchOrgType" type="checkbox" class="checkbox" value="Y" checked/><tit:txt mid='112471' mdef='하위포함'/>
						</td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>
							<input id="searchSabun" name="searchSabun" type="text" class="text" />
						</td>
						<th><tit:txt mid='104281' mdef='근무지'/></th>
						<td>
							<select id="searchLocationCd" name="searchLocationCd"> </select>
						</td>
							<th><tit:txt mid='114399' mdef='사업장'/></th>
						<td>
							<select id="searchBizPlaceCd" name="searchBizPlaceCd"> </select>
						</td>
						<th class="hide"><tit:txt mid='104467' mdef='사유'/></th>
						<td class="hide">
							<select id="searchReasonCd" name="searchReasonCd"> </select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='search' mdef="조회"/>
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
							<li id="txt" class="txt"><tit:txt mid='2017082900917' mdef='일근무제외자관리'/></li>
							<li class="btn">
								<a href="javascript:doAction1('DownTemplate')" 	class="btn outline_gray authA">양식다운로드</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="btn outline_gray authA">업로드</a>
								<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save');" css="btn filled authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='download' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>