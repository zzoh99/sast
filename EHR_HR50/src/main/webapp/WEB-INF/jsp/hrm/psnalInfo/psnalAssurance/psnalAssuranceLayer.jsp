<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104038' mdef='인사기본(보증)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<!-- <script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script> -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var searchUserId = '';
	var searchUserEnterCd = '';
	$(function() {
		createIBSheet3(document.getElementById('psnalAssuranceLayerSheet1-wrap'), "psnalAssuranceLayerSheet1", "100%", "100%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('psnalAssuranceLayerSheet2-wrap'), "psnalAssuranceLayerSheet2", "0%", "0%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('psnalAssuranceLayer');
		searchUserId = modal.parameters.userId || '';
		searchUserEnterCd = modal.parameters.userEnterCd || '';

		$("#hdnSabun").val(searchUserId);
		$("#hdnEnterCd").val(searchUserEnterCd);

		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm119"] = psnalAssuranceLayerSheet1;
		//EMP_INFO_CHANGE_TABLE_SHEET["thrm119"] = psnalAssuranceLayerSheet2;

		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",      Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='type_V2671' mdef='보증타입'/>",   Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"type",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='warrantyCd' mdef='보험회사'/>",   Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"warrantyCd",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='warrantyNo' mdef='증권번호'/>",   Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"warrantyNo",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
			{Header:"<sht:txt mid='warrantySYmd' mdef='보증기간\n시작일'/>",  	Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"warrantySYmd",	KeyField:1,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='warrantyEYmd' mdef='보증기간\n종료일'/>",  	Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"warrantyEYmd",	KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='currencyCd' mdef='통화단위'/>",   Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"currencyCd",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='dedYm' mdef='공제년월'/>",		Type:"Date",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"dedYm",		Format:"Ym", 	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
			{Header:"<sht:txt mid='warrantyMon_V1' mdef='보증금액'/>",   Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"warrantyMon",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='jobGbnCd' mdef='보증구분'/>",   Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobGbnCd",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",     	Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",	Type:"Html",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(psnalAssuranceLayerSheet1, initdata);psnalAssuranceLayerSheet1.SetEditable("${editable}");psnalAssuranceLayerSheet1.SetVisible(true);psnalAssuranceLayerSheet1.SetCountPosition(0);

		psnalAssuranceLayerSheet1.SetMergeSheet( msHeaderOnly);

		var initdata2 = {};
		initdata2.Cfg = {FrozenCol:8,SearchMode:smLazyLoad,Page:22, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>", 				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>", 				Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='type_V2671' mdef='보증타입'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"type",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='warrantySYmd' mdef='보증기간\n시작일'/>",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"warrantySYmd",	KeyField:1,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='warrantyEYmd' mdef='보증기간\n종료일'/>",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"warrantyEYmd",	KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"warrantyNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='famCd_V1004' mdef='관계'/>",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"relNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='accResNoV1' mdef='주민번호'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"resNo",			KeyField:0,	Format:"IdNo",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200 },
			{Header:"<sht:txt mid='telNo' mdef='연락처'/>",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"telNo",			KeyField:0,	Format:"PhoneNo",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='zip' mdef='우편번호'/>",			Type:"Popup",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"zip",				KeyField:0,	Format:"PostNo",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
			{Header:"<sht:txt mid='addr' mdef='주소'/>",				Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"addr1",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"<sht:txt mid='addr2' mdef='상세주소'/>",			Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"addr2",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"<sht:txt mid='warrantyMon' mdef='납세내역'/>",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"warrantyMon",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",				Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",			Type:"Html",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(psnalAssuranceLayerSheet2, initdata2);psnalAssuranceLayerSheet2.SetEditable("${editable}");psnalAssuranceLayerSheet2.SetVisible(true);psnalAssuranceLayerSheet2.SetCountPosition(0);

		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			psnalAssuranceLayerSheet1.SetEditable(0);
			psnalAssuranceLayerSheet2.SetEditable(0);
			$(".enterAuthBtn").hide();
		}
		var enterCd = "&enterCd="+$("#hdnEnterCd").val();

		//공통코드 한번에 조회
		var grpCds = "H20380,H60140,S10030";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds + enterCd,false).codeList, "");

		var userCd1    = codeLists["H20380"];
		var userCd2    = codeLists["H60140"];
		var currencyCd = codeLists["S10030"];

		psnalAssuranceLayerSheet1.SetColProperty("warrantyCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		psnalAssuranceLayerSheet1.SetColProperty("jobGbnCd", 		{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
		psnalAssuranceLayerSheet1.SetColProperty("currencyCd", 		{ComboText:"|"+currencyCd[0], ComboCode:"|"+currencyCd[1]} );

		let sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
		psnalAssuranceLayerSheet1.SetSheetHeight(sheetHeight);

		doAction1("Search");
		// doAction2("Search");
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&type=1"+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			psnalAssuranceLayerSheet1.DoSearch( "${ctx}/PsnalAssurance.do?cmd=getPsnalAssuranceWarrantyList", param );
			break;
		case "Save":
			if(!dupChk(psnalAssuranceLayerSheet1,"sabun|type|warrantySYmd", true, true)){break;}
			IBS_SaveName(document.psnalAssuranceLayerSheet1Form,psnalAssuranceLayerSheet1);
			psnalAssuranceLayerSheet1.DoSave( "${ctx}/PsnalAssurance.do?cmd=savePsnalAssuranceWarranty", $("#psnalAssuranceLayerSheet1Form").serialize());
			break;
		case "Insert":
			var row = psnalAssuranceLayerSheet1.DataInsert(0);
			psnalAssuranceLayerSheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalAssuranceLayerSheet1.SetCellValue(row,"sabun",$("#hdnSabun").val());
			psnalAssuranceLayerSheet1.SetCellValue(row,"type","1");
			break;
		case "Copy":
			var row = psnalAssuranceLayerSheet1.DataCopy();
			psnalAssuranceLayerSheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalAssuranceLayerSheet1.SetCellValue(row, "fileSeq", '');
			break;
		case "Clear":
			psnalAssuranceLayerSheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(psnalAssuranceLayerSheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			psnalAssuranceLayerSheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet0 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&type=3"+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			psnalAssuranceLayerSheet2.DoSearch( "${ctx}/PsnalAssurance.do?cmd=getPsnalAssuranceWarrantyUserList", param );
			break;
		case "Save":
			if(!dupChk(psnalAssuranceLayerSheet2,"sabun|type|warrantySYmd", true, true)){break;}
			IBS_SaveName(document.psnalAssuranceLayerSheet1Form,psnalAssuranceLayerSheet2);
			psnalAssuranceLayerSheet2.DoSave( "${ctx}/PsnalAssurance.do?cmd=savePsnalAssuranceWarrantyUser", $("#psnalAssuranceLayerSheet1Form").serialize());
			break;
		case "Insert":
			var row = psnalAssuranceLayerSheet2.DataInsert(0);
			psnalAssuranceLayerSheet2.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalAssuranceLayerSheet2.SetCellValue(row,"sabun",$("#hdnSabun").val());
			psnalAssuranceLayerSheet2.SetCellValue(row,"type","3");
			break;
		case "Copy":
			psnalAssuranceLayerSheet2.DataCopy();
			break;
		case "Clear":
			psnalAssuranceLayerSheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(psnalAssuranceLayerSheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			psnalAssuranceLayerSheet2.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function psnalAssuranceLayerSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			//파일 첨부 시작
			for(var r = psnalAssuranceLayerSheet1.HeaderRows(); r<psnalAssuranceLayerSheet1.RowCount()+psnalAssuranceLayerSheet1.HeaderRows(); r++){
				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(psnalAssuranceLayerSheet1.GetCellValue(r,"fileSeq") == ''){
						psnalAssuranceLayerSheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						psnalAssuranceLayerSheet1.SetCellValue(r, "sStatus", 'R');
					}else{
						psnalAssuranceLayerSheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalAssuranceLayerSheet1.SetCellValue(r, "sStatus", 'R');
					}
				}else{
					if(psnalAssuranceLayerSheet1.GetCellValue(r,"fileSeq") != ''){
						psnalAssuranceLayerSheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalAssuranceLayerSheet1.SetCellValue(r, "sStatus", 'R');
					}
				}
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function psnalAssuranceLayerSheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
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
	function psnalAssuranceLayerSheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var r = psnalAssuranceLayerSheet2.HeaderRows(); r<psnalAssuranceLayerSheet2.RowCount()+psnalAssuranceLayerSheet1.HeaderRows(); r++){
				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(psnalAssuranceLayerSheet2.GetCellValue(r,"fileSeq") == ''){
						psnalAssuranceLayerSheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						psnalAssuranceLayerSheet2.SetCellValue(r, "sStatus", 'R');
					}else{
						psnalAssuranceLayerSheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalAssuranceLayerSheet2.SetCellValue(r, "sStatus", 'R');
					}
				}else{
					if(psnalAssuranceLayerSheet2.GetCellValue(r,"fileSeq") != ''){
						psnalAssuranceLayerSheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalAssuranceLayerSheet2.SetCellValue(r, "sStatus", 'R');
					}
				}
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function psnalAssuranceLayerSheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 팝업 클릭시 발생
	function psnalAssuranceLayerSheet2_OnPopupClick(Row,Col) {
		try {
			if(psnalAssuranceLayerSheet2.ColSaveName(Col) == "zip") {
				if(!isPopup()) {return;}

				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "ZipCodePopup";

 				openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");

				/**
				var temp = openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");
				if(temp != null){
					psnalAssuranceLayerSheet2.SetCellValue(Row, "zip", temp["zip"]);
					psnalAssuranceLayerSheet2.SetCellValue(Row, "addr1", temp["resDoroFullAddr"]);
					psnalAssuranceLayerSheet2.SetCellValue(Row, "addr2", "");
				}
				**/
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//파일 신청 시작
	function psnalAssuranceLayerSheet1_OnClick(Row, Col, Value) {
		try{

			if(psnalAssuranceLayerSheet1.ColSaveName(Col) == "btnFile" && Row >= psnalAssuranceLayerSheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = psnalAssuranceLayerSheet1.GetCellValue(Row,"fileSeq");
				if(psnalAssuranceLayerSheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup1";

					var authPgTemp="${authPg}";
				    //var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=assurance", param, "740","620");
				    fileMgrPopup1(Row, Col);
				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	   // 파일첨부/다운로드 팝입
    function fileMgrPopup1(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : 'fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}&uploadType=assurance'
            , parameters : {
                fileSeq : psnalAssuranceLayerSheet1.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(result.fileCheck == "exist"){
                            psnalAssuranceLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                            psnalAssuranceLayerSheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            psnalAssuranceLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                            psnalAssuranceLayerSheet1.SetCellValue(gPRow, "fileSeq", "");
                        }
                    }
                }
            ]
        });
        layerModal.show();
    }
	//파일 신청 끝

	//파일 신청 시작
	function psnalAssuranceLayerSheet2_OnClick(Row, Col, Value) {
		try{
			if(psnalAssuranceLayerSheet2.ColSaveName(Col) == "btnFile" && Row >= psnalAssuranceLayerSheet2.HeaderRows()){
				var param = [];
				param["fileSeq"] = psnalAssuranceLayerSheet2.GetCellValue(Row,"fileSeq");
				
				if(psnalAssuranceLayerSheet2.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup2";

					var authPgTemp="${authPg}";
					fileMgrPopup2(Row, Col);
					//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=assurance", param, "740","620");
				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
    // 파일첨부/다운로드 팝입
    function fileMgrPopup2(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}&uploadType=assurance'
            , parameters : {
                fileSeq : psnalAssuranceLayerSheet2.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(result.fileCheck == "exist"){
                            psnalAssuranceLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                            psnalAssuranceLayerSheet2.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            psnalAssuranceLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                            psnalAssuranceLayerSheet2.SetCellValue(gPRow, "fileSeq", "");
                        }
                    }
                }
            ]
        });
        layerModal.show();
    }
	//파일 신청 끝

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "fileMgrPopup1") {
			if(rv["fileCheck"] == "exist"){
				psnalAssuranceLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				psnalAssuranceLayerSheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				psnalAssuranceLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				psnalAssuranceLayerSheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		} else if(pGubun == "fileMgrPopup2") {
			if(rv["fileCheck"] == "exist"){
				psnalAssuranceLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				psnalAssuranceLayerSheet2.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				psnalAssuranceLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				psnalAssuranceLayerSheet2.SetCellValue(gPRow, "fileSeq", "");
			}
		} else if ( pGubun == "ZipCodePopup" ){
			psnalAssuranceLayerSheet2.SetCellValue(gPRow, "zip", rv["zip"]);
			psnalAssuranceLayerSheet2.SetCellValue(gPRow, "addr1", rv["doroFullAddr"]);
			psnalAssuranceLayerSheet2.SetCellValue(gPRow, "addr2", "");
		}
	}
</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<form id="psnalAssuranceLayerSheet1Form" name="psnalAssuranceLayerSheet1Form">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
</form>
<div class="wrapper modal_layer">
	<div class="modal_body">
		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li class="btn _thrm119">
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
		<%--	<script type="text/javascript"> createIBSheet("psnalAssuranceLayerSheet1", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
		<div id="psnalAssuranceLayerSheet1-wrap"></div>
		<div class="outer" style="display: none;">
			<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='103937' mdef='보증인'/></li>
					<li class="btn _thrm119_">
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
		<div class="hide">
			<%--		<script type="text/javascript"> createIBSheet("psnalAssuranceLayerSheet2", "100%", "50%", "${ssnLocaleCd}"); </script>--%>
			<div id="psnalAssuranceLayerSheet2-wrap"></div>
		</div>
	</div>
</div>
</body>
</html>
