<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103841' mdef='인사기본(상벌)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var searchUserId = '';
	var searchUserEnterCd = '';
	//포상
	var prizeList = ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&searchGrcodeCd=H20250", "queryId=getComCodeNoteList", false) ;
	//징계
	var punishList = ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&searchGrcodeCd=H20270", "queryId=getComCodeNoteList", false) ;

	$(function() {
		createIBSheet3(document.getElementById('psnalJusticeLayerSheet1-wrap'), "psnalJusticeLayerSheet1", "100%", "50%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('psnalJusticeLayerSheet2-wrap'), "psnalJusticeLayerSheet2", "100%", "50%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('psnalJusticeLayer');
		searchUserId = modal.parameters.userId || '';
		searchUserEnterCd = modal.parameters.userEnterCd || '';

		$("#hdnSabun").val(searchUserId);
		$("#hdnEnterCd").val(searchUserEnterCd);

		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm128"] = psnalJusticeLayerSheet1;
		EMP_INFO_CHANGE_TABLE_SHEET["thrm129"] = psnalJusticeLayerSheet2;
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:8,DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='prizeGrdCd' mdef='상격'/>",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"prizeGrdCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='prizeYmd' mdef='포상일자'/>",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"prizeYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='prizeCd' mdef='포상명'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"prizeCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='inOutCd' mdef='사내/외\n구분'/>",	Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"inOutCd",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"당시부서",	Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"당시직급",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"당시직책",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"당시직원유형",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

			{Header:"<sht:txt mid='prizeOfficeNm' mdef='포상기관'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"prizeOfficeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"포상번호",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"prizeNo",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
			{Header:"<sht:txt mid='prizeMon' mdef='포상금액'/>",	Type:"Int",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"prizeMon",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='payYmV1' mdef='지급년월'/>",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"paymentYm",		KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },

			{Header:"<sht:txt mid='sPoint' mdef='상벌점'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"sPoint",			KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"<sht:txt mid='sgPointV1' mdef='승진\n포인트'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"sgPoint",			KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"<sht:txt mid='sFromYmd' mdef='반영시작일'/>",	Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sFromYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='sToYmd' mdef='반영종료일'/>",	Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sToYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"<sht:txt mid='memo2V1' mdef='포상사유'/>",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"memo2",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",	Type:"Html",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 }
		]; IBS_InitSheet(psnalJusticeLayerSheet1, initdata1);psnalJusticeLayerSheet1.SetEditable("${editable}");psnalJusticeLayerSheet1.SetVisible(true);psnalJusticeLayerSheet1.SetCountPosition(0);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:7,DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
  			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
 			{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
 			{Header:"<sht:txt mid='punishYmd' mdef='징계일자'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"punishYmd",	KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 			{Header:"<sht:txt mid='punishCd' mdef='징계명'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"punishCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

 			{Header:"당시부서",	Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"당시직급",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"당시직책",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"당시직원유형",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manageNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
 			{Header:"징계기관",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"punishOffice",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"감사기관",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"auditOffice",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300 },

 			{Header:"<sht:txt mid='sdateV3' mdef='징계시작일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 			{Header:"<sht:txt mid='edateV2' mdef='징계종료일'/>",		Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 			{Header:"<sht:txt mid='paySYmd' mdef='급여반영\n시작월'/>",	Type:"Date",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"paySYmd",		KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
 			{Header:"<sht:txt mid='payEYmd' mdef='급여반영\n종료월'/>",	Type:"Date",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"payEYmd",		KeyField:0,	Format:"Ym",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
 			{Header:"징계번호",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"punishNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
 			{Header:"<sht:txt mid='sPoint' mdef='상벌점'/>",			Type:"Text",	Hidden:1,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"sPoint",			KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
 			{Header:"<sht:txt mid='sgPointV1' mdef='승진\n포인트'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"sgPoint",			KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },

			{Header:"<sht:txt mid='sFromYmd' mdef='반영시작일'/>",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sFromYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='sToYmd' mdef='반영종료일'/>",		Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sToYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 			{Header:"<sht:txt mid='punishMemo' mdef='징계사유'/>",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"punishMemo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"인사기록카드\n출력여부",		Type:"CheckBox",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
 			{Header:"개인프로파일\n출력여부",		Type:"CheckBox",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"profileYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
 			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",		Type:"Html",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(psnalJusticeLayerSheet2, initdata2);psnalJusticeLayerSheet2.SetEditable("${editable}");psnalJusticeLayerSheet2.SetVisible(true);psnalJusticeLayerSheet2.SetCountPosition(0);

		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			psnalJusticeLayerSheet1.SetEditable(0);
			psnalJusticeLayerSheet2.SetEditable(0);
			$(".enterAuthBtn").hide();
		}
		var enterCd = "&enterCd="+$("#hdnEnterCd").val();

		//공통코드 한번에 조회
		var grpCds = "H20260,H20271,H20250,H20270";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds + enterCd,false).codeList, "");

		var userCd1 = codeLists["H20260"];
		var userCd2 = codeLists["H20271"];
		var userCd3 = codeLists["H20250"];
		var userCd4 = codeLists["H20270"];

		psnalJusticeLayerSheet1.SetColProperty("prizeGrdCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		psnalJusticeLayerSheet1.SetColProperty("inOutCd", 			{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
		psnalJusticeLayerSheet1.SetColProperty("prizeCd", 			{ComboText:"|"+userCd3[0], ComboCode:"|"+userCd3[1]} );
		psnalJusticeLayerSheet2.SetColProperty("punishCd", 			{ComboText:"|"+userCd4[0], ComboCode:"|"+userCd4[1]} );


		doAction1("Search");
		doAction2("Search");

		let sheetHeight = $(".modal_body").height() - $(".sheet_title").height();
		psnalJusticeLayerSheet1.SetSheetHeight(sheetHeight / 2);
		psnalJusticeLayerSheet2.SetSheetHeight(sheetHeight / 2);
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			psnalJusticeLayerSheet1.DoSearch( "${ctx}/PsnalJustice.do?cmd=getPsnalJusticePrizeList", param );
			break;
		case "Save":
			IBS_SaveName(document.psnalJusticeLayerSheet1Form,psnalJusticeLayerSheet1);
			psnalJusticeLayerSheet1.DoSave( "${ctx}/PsnalJustice.do?cmd=savePsnalJusticePrize", $("#psnalJusticeLayerSheet1Form").serialize());
			break;
		case "Insert":
			var row = psnalJusticeLayerSheet1.DataInsert(0);
			psnalJusticeLayerSheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalJusticeLayerSheet1.SetCellValue(row,"sabun",$("#hdnSabun").val());
			break;
		case "Copy":
			var row = psnalJusticeLayerSheet1.DataCopy();
			psnalJusticeLayerSheet1.SetCellValue(row,"seq","");
			psnalJusticeLayerSheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalJusticeLayerSheet1.SetCellValue(row, "fileSeq", '');
			break;
		case "Clear":
			psnalJusticeLayerSheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(psnalJusticeLayerSheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			psnalJusticeLayerSheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet0 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			psnalJusticeLayerSheet2.DoSearch( "${ctx}/PsnalJustice.do?cmd=getPsnalJusticePunishList", param );
			break;
		case "Save":
			IBS_SaveName(document.psnalJusticeLayerSheet1Form,psnalJusticeLayerSheet2);
			psnalJusticeLayerSheet2.DoSave( "${ctx}/PsnalJustice.do?cmd=savePsnalJusticePunish", $("#psnalJusticeLayerSheet1Form").serialize());
			break;
		case "Insert":
			var row = psnalJusticeLayerSheet2.DataInsert(0);
			psnalJusticeLayerSheet2.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalJusticeLayerSheet2.SetCellValue(row,"sabun",$("#hdnSabun").val());
			break;
		case "Copy":
			var row = psnalJusticeLayerSheet2.DataCopy();
			psnalJusticeLayerSheet2.SetCellValue(row,"seq","");
			psnalJusticeLayerSheet2.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalJusticeLayerSheet2.SetCellValue(row, "fileSeq", '');
			break;
		case "Clear":
			psnalJusticeLayerSheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(psnalJusticeLayerSheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			psnalJusticeLayerSheet2.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function psnalJusticeLayerSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			//파일 첨부 시작
			for(var r = psnalJusticeLayerSheet1.HeaderRows(); r<psnalJusticeLayerSheet1.RowCount()+psnalJusticeLayerSheet1.HeaderRows(); r++){
				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(psnalJusticeLayerSheet1.GetCellValue(r,"fileSeq") == ''){
						psnalJusticeLayerSheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						psnalJusticeLayerSheet1.SetCellValue(r, "sStatus", 'R');
					}else{
						psnalJusticeLayerSheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalJusticeLayerSheet1.SetCellValue(r, "sStatus", 'R');
					}
				}else{
					if(psnalJusticeLayerSheet1.GetCellValue(r,"fileSeq") != ''){
						psnalJusticeLayerSheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalJusticeLayerSheet1.SetCellValue(r, "sStatus", 'R');
					}
				}
			}


			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function psnalJusticeLayerSheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 조회 후 에러 메시지
	function psnalJusticeLayerSheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var r = psnalJusticeLayerSheet2.HeaderRows(); r<psnalJusticeLayerSheet2.RowCount()+psnalJusticeLayerSheet1.HeaderRows(); r++){
				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(psnalJusticeLayerSheet2.GetCellValue(r,"fileSeq") == ''){
						psnalJusticeLayerSheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						psnalJusticeLayerSheet2.SetCellValue(r, "sStatus", 'R');
					}else{
						psnalJusticeLayerSheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalJusticeLayerSheet2.SetCellValue(r, "sStatus", 'R');
					}
				}else{
					if(psnalJusticeLayerSheet2.GetCellValue(r,"fileSeq") != ''){
						psnalJusticeLayerSheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalJusticeLayerSheet2.SetCellValue(r, "sStatus", 'R');
					}
				}
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function psnalJusticeLayerSheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 값이 바뀔때 발생
	function psnalJusticeLayerSheet1_OnChange(Row, Col, Value) {
		try{
			if( psnalJusticeLayerSheet1.ColSaveName(Col) == "prizeCd" ) {
				if( prizeList != null ) {
					for( var i = 0; i < prizeList.codeList.length; i++) {
						if( prizeList.codeList[i].code == psnalJusticeLayerSheet1.GetCellValue(Row, "prizeCd") ) {
							psnalJusticeLayerSheet1.SetCellValue(Row, "sPoint", prizeList.codeList[i].note1) ;
							psnalJusticeLayerSheet1.SetCellValue(Row, "sgPoint", prizeList.codeList[i].note2) ;
							break;
						}
					}
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	// 셀 값이 바뀔때 발생
	function psnalJusticeLayerSheet2_OnChange(Row, Col, Value) {
		try{
			if( psnalJusticeLayerSheet2.ColSaveName(Col) == "sdate" || psnalJusticeLayerSheet2.ColSaveName(Col) == "edate"  ) {
				if(psnalJusticeLayerSheet2.GetCellValue(Row,"sdate") != "" && psnalJusticeLayerSheet2.GetCellValue(Row,"edate") != "") {
					if(psnalJusticeLayerSheet2.GetCellValue(Row,"sdate") > psnalJusticeLayerSheet2.GetCellValue(Row,"edate")) {
						alert("<msg:txt mid='errorDisciplineEYmd' mdef='징계종료일은 시작일 이후 날짜로 입력하여 주십시오.'/>");
						psnalJusticeLayerSheet2.SetCellValue(Row,"edate","");
					}
				}
			}
			if( psnalJusticeLayerSheet2.ColSaveName(Col) == "punishCd" ) {
				if( punishList != null ) {
					for( var i = 0; i < punishList.codeList.length; i++) {
						if( punishList.codeList[i].code == psnalJusticeLayerSheet2.GetCellValue(Row, "punishCd") ) {
							psnalJusticeLayerSheet2.SetCellValue(Row, "sPoint", punishList.codeList[i].note1) ;
							psnalJusticeLayerSheet2.SetCellValue(Row, "sgPoint", punishList.codeList[i].note2) ;
							break;
						}
					}
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	//파일 신청 시작
	function psnalJusticeLayerSheet1_OnClick(Row, Col, Value) {
		try{

			if(psnalJusticeLayerSheet1.ColSaveName(Col) == "btnFile" && Row >= psnalJusticeLayerSheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = psnalJusticeLayerSheet1.GetCellValue(Row,"fileSeq");
				if(psnalJusticeLayerSheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup1";

					var authPgTemp="${authPg}";
					//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=justice", param, "740","620");
					fileMgrPopup1(Row, Col);
					
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
    function fileMgrPopup1(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : 'fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}&uploadType=justice'
            , parameters : {
                fileSeq : psnalJusticeLayerSheet1.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(result.fileCheck == "exist"){
                            psnalJusticeLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                            psnalJusticeLayerSheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            psnalJusticeLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                            psnalJusticeLayerSheet1.SetCellValue(gPRow, "fileSeq", "");
                        }
                    }
                }
            ]
        });
        layerModal.show();
    }
	//파일 신청 끝


	//파일 신청 시작
	function psnalJusticeLayerSheet2_OnClick(Row, Col, Value) {
		try{
			if(psnalJusticeLayerSheet2.ColSaveName(Col) == "btnFile" && Row >= psnalJusticeLayerSheet2.HeaderRows()){
				var param = [];
				param["fileSeq"] = psnalJusticeLayerSheet2.GetCellValue(Row,"fileSeq");
				if(psnalJusticeLayerSheet2.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup2";

					var authPgTemp="${authPg}";
					//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=justice", param, "740","620");
					fileMgrPopup2(Row, Col);
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	//파일 신청 끝

	// 파일첨부/다운로드 팝입
    function fileMgrPopup2(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}&uploadType=justice'
            , parameters : {
                fileSeq : psnalJusticeLayerSheet2.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(result.fileCheck == "exist"){
                            psnalJusticeLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                            psnalJusticeLayerSheet2.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            psnalJusticeLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                            psnalJusticeLayerSheet2.SetCellValue(gPRow, "fileSeq", "");
                        }
                    }
                }
            ]
        });
        layerModal.show();
    }
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "fileMgrPopup1") {
			if(rv["fileCheck"] == "exist"){
				psnalJusticeLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				psnalJusticeLayerSheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				psnalJusticeLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				psnalJusticeLayerSheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		} else if(pGubun == "fileMgrPopup2") {
			if(rv["fileCheck"] == "exist"){
				psnalJusticeLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				psnalJusticeLayerSheet2.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				psnalJusticeLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				psnalJusticeLayerSheet2.SetCellValue(gPRow, "fileSeq", "");
			}
        }
	}

</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<form id="psnalJusticeLayerSheet1Form" name="psnalJusticeLayerSheet1Form">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
</form>
<div class="wrapper modal_layer">
	<div class="modal_body">
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td class="top">
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='prize' mdef='포상사항'/></li>
								<li class="btn _thrm128">
									<btn:a href="javascript:doAction1('Search');" css="basic authR" mid='110697' mdef="조회"/>
									<c:if test="${authPg == 'A'}">
										<btn:a href="javascript:doAction1('Insert');" css="basic authA enterAuthBtn" mid='110700' mdef="입력"/>
										<btn:a href="javascript:doAction1('Copy');" css="basic authA enterAuthBtn" mid='110696' mdef="복사"/>
										<btn:a href="javascript:doAction1('Save');" css="basic authA enterAuthBtn" mid='110708' mdef="저장"/>
									</c:if>
									<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
								</li>
							</ul>
						</div>
					</div>
<%--					<script type="text/javascript"> createIBSheet("psnalJusticeLayerSheet1", "100%", "50%", "${ssnLocaleCd}"); </script>--%>
					<div id="psnalJusticeLayerSheet1-wrap"></div>
				</td>
			</tr>
		</table>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td class="top">
					<div class="outer">
						<div class="sheet_title">
							<ul>
								<li class="txt"><tit:txt mid='discipline' mdef='징계사항'/></li>
								<li class="btn _thrm129">
									<btn:a href="javascript:doAction2('Search');" css="basic authR" mid='110697' mdef="조회"/>
									<c:if test="${authPg == 'A'}">
										<btn:a href="javascript:doAction2('Insert');" css="basic authA enterAuthBtn" mid='110700' mdef="입력"/>
										<btn:a href="javascript:doAction2('Copy');" css="basic authA enterAuthBtn" mid='110696' mdef="복사"/>
										<btn:a href="javascript:doAction2('Save');" css="basic authA enterAuthBtn" mid='110708' mdef="저장"/>
									</c:if>
									<btn:a href="javascript:doAction2('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
								</li>
							</ul>
						</div>
					</div>
<%--					<script type="text/javascript"> createIBSheet("psnalJusticeLayerSheet2", "100%", "50%", "${ssnLocaleCd}"); </script>--%>
					<div id="psnalJusticeLayerSheet2-wrap"></div>
				</td>
			</tr>
		</table>
	</div>
</div>
</body>
</html>
