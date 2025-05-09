<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112876' mdef='승진대상자품의처리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='pmtCd_V1' mdef='승진명부코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"pmtCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:15 },
			{Header:"<sht:txt mid='pmtNm_V1' mdef='승진명부명'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"pmtNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sdateV13' mdef='기준일'/>",			Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"baseYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='cntV2' mdef='대상인원'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"targetNum",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='pmtNum' mdef='승진인원'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pmtNum",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='ordTypeCdV1' mdef='발령형태'/>",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='ordYmd' mdef='발령일자'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='processNo' mdef='품의번호'/>",		Type:"Popup",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"processNo",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:20 },
			{Header:"<sht:txt mid='processYn' mdef='품의처리여부'/>",	Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"processYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(false);sheet1.SetCountPosition(4);

		//발령형태
		var userCd1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppmtCodeMgrCodeList",false).codeList, "");
		//승진대상명부
		var userCd2 = stfConvCode( codeList("${ctx}/PromStdMgr.do?cmd=getPromStdCodeList",""), "");

		sheet1.SetColProperty("ordTypeCd", 		{ComboText:userCd1[0], ComboCode:userCd1[1]} );
		sheet1.SetColProperty("processYn", 		{ComboText:"처리전|처리완료", ComboCode:"N|Y"} );

		$("#pmtCd").html(userCd2[2]);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getPromTargetAppmtList", "pmtCd="+$("#pmtCd").val() );
			break;
		case "Save":
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PromTargetAppmt.do?cmd=updatePromTargetAppmt", $("#mySheetForm").serialize());
			break;
		case "Proc":
			if(sheet1.RowCount() < 1) {
				return;
			}

			if(sheet1.GetCellValue(1,"processYn") == "Y") {
				alert("<msg:txt mid='109718' mdef='품의처리가 완료된 상태입니다.'/>");
				return;
			}

			if(!confirm("품의번호를 적용 하시겠습니까?")) {
				return;
			}

			var param = "pmtCd="+sheet1.GetCellValue(1,"pmtCd")
						+"&processNo="+sheet1.GetCellValue(1,"processNo");

	    	var data = ajaxCall("/PromTargetAppmt.do?cmd=prcPromTargetAppmt",param,false);

	    	if(data.Result.Code == "1") {
	    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
	    		doAction1("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}
			break;
		case "Clear":
			sheet1.RemoveAll();
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

			if(sheet1.SearchRows() > 0) {
				for(var i = 0; i < sheet1.SearchRows(); i++) {
					if(sheet1.GetCellValue(i+1,"processYn") == "Y") {
						sheet1.SetCellEditable(i+1,"ordTypeCd",false);
						sheet1.SetCellEditable(i+1,"ordYmd",false);
						sheet1.SetCellEditable(i+1,"processNo",false);
					}
				}
			}

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

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "processNo") {
	            var rst = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=${authPg}", "", "740","520");
	            if(rst != null){
	                sheet1.SetCellValue(Row, "processNo",		rst["processNo"] );
	            }
			}
		} catch (ex) {
			alert("OnPopupClick Event Error " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='114677' mdef='승진대상자명부'/></th>
				<td>
					<select id="pmtCd" name="pmtCd"></select>
				</td>
				<td>
					<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112876' mdef='승진대상자품의처리'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Proc');" css="basic authA" mid='110928' mdef="품의번호적용"/>
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='save' mdef="저장"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
