<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104544' mdef='인사기본(어학)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var fTestCdList;
	var searchUserId = '';
	var searchUserEnterCd = '';
	var searchEnterCd = '';

	$(function() {
		createIBSheet3(document.getElementById('psnalLangLayerSheet1-wrap'), "psnalLangLayerSheet1", "100%", "100%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('psnalLangLayerSheet2-wrap'), "psnalLangLayerSheet2", "0%", "0%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('psnalLangLayer');
		searchUserId = modal.parameters.userId || '';
		searchUserEnterCd = modal.parameters.userEnterCd || '';

		$("#hdnSabun").val(searchUserId);
		$("#hdnEnterCd").val(searchUserEnterCd);
		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm125"] = psnalLangLayerSheet1;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:7,DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"<sht:txt mid='sNo'        mdef='No'/>",		 Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		 Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus'    mdef='상태'/>",		 Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		 Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='fileSeqV5'  mdef='일련번호'/>",	     Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },

			{Header:"<sht:txt mid='fTestCd'    mdef='어학시험명'/>",	 Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fTestCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='foreignCd'  mdef='외국어구분'/>",	 Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"foreignCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"<sht:txt mid='applyYmd'   mdef='시험일자'/>",	     Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applyYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='staYmd'     mdef='수당지급시작일'/>", Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"staYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='endYmd'     mdef='수당지급종료일'/>", Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"endYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"<sht:txt mid='grade'      mdef='등급'/>",		 Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"testPoint",	KeyField:0,	Format:"",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='etcPoint'   mdef='점수'/>",		 Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"passScores",	KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },

			{Header:"<sht:txt mid='fullScores' mdef='만점'/>",		 Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fullScores",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='fTestOrgNm' mdef='기관명'/>",		 Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"fTestOrgNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='btnFile'    mdef='첨부파일'/>",	     Type:"Html",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq'    mdef='첨부번호'/>",	     Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(psnalLangLayerSheet1, initdata1);psnalLangLayerSheet1.SetEditable("${editable}");psnalLangLayerSheet1.SetVisible(true);psnalLangLayerSheet1.SetCountPosition(0);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
  			{Header:"<sht:txt mid='sNo' 		mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"<sht:txt mid='sDelete V5' 	mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' 	mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
 			{Header:"<sht:txt mid='agreeSabun' 	mdef='사번'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
 			{Header:"<sht:txt mid='fileSeqV5' 	mdef='일련번호'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
 			{Header:"<sht:txt mid='getYmd' 		mdef='취득일자'/>",	Type:"Date",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"getYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 			{Header:"<sht:txt mid='sYmd' 		mdef='시작일자'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 			{Header:"<sht:txt mid='eYmd' 		mdef='종료일자'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 			{Header:"<sht:txt mid='foreignCd' 	mdef='외국어구분'/>",	Type:"Combo",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"foreignCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 			{Header:"<sht:txt mid='etcPoint' 	mdef='점수'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"score",		KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
 			{Header:"수준",											Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"grade",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 			{Header:"<sht:txt mid='btnFile' 	mdef='첨부파일'/>",	Type:"Html",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' 	mdef='첨부번호'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(psnalLangLayerSheet2, initdata2);psnalLangLayerSheet2.SetEditable("${editable}");psnalLangLayerSheet2.SetVisible(true);psnalLangLayerSheet2.SetCountPosition(4);

		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			psnalLangLayerSheet1.SetEditable(0);
			$(".enterAuthBtn").hide();
		}
		searchEnterCd = "&enterCd=" + $("#hdnEnterCd").val();
		
		//공통코드 한번에 조회
		var grpCds = "H20300,H20307,H20309";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds + searchEnterCd,false).codeList, "");

		var userCd1 = codeLists["H20300"];
		var userCd2 = codeLists["H20307"];
		var userCd3 = codeLists["H20309"];

		psnalLangLayerSheet1.SetColProperty("foreignCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		psnalLangLayerSheet1.SetColProperty("fTestCd", 		{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
		//psnalLangLayerSheet1.SetColProperty("testPoint", 		{ComboText:"|A+|A|B+|B|C+|C", ComboCode:"|1|2|3|4|5|6"} );
		psnalLangLayerSheet2.SetColProperty("foreignCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		psnalLangLayerSheet2.SetColProperty("grade", 			{ComboText:"|"+userCd3[0], ComboCode:"|"+userCd3[1]} );

		//fTestCdList = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20307");
		let sheetHeight = $(".modal_body").height() - $(".sheet_title").height();
		psnalLangLayerSheet1.SetSheetHeight(sheetHeight);

		doAction1("Search");
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			psnalLangLayerSheet1.DoSearch( "${ctx}/PsnalLang.do?cmd=getPsnalLangForeignList", param );
			break;
		case "Save":
			IBS_SaveName(document.psnalLangLayerSheet1Form,psnalLangLayerSheet1);
			psnalLangLayerSheet1.DoSave( "${ctx}/PsnalLang.do?cmd=savePsnalLangForeign", $("#psnalLangLayerSheet1Form").serialize());
			break;
		case "Insert":
			var row = psnalLangLayerSheet1.DataInsert(0);
			psnalLangLayerSheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalLangLayerSheet1.SetCellValue(row,"sabun",$("#hdnSabun").val(),0);
			//psnalLangLayerSheet1.CellComboItem(row,"fTestCd",{ComboText:" ", ComboCode:" "});
			break;
		case "Copy":
			var row = psnalLangLayerSheet1.DataCopy();
			psnalLangLayerSheet1.SetCellValue(row,"seq","",0);
			psnalLangLayerSheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalLangLayerSheet1.SetCellValue(row, "fileSeq", '');
			break;
		case "Clear":
			psnalLangLayerSheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(psnalLangLayerSheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			psnalLangLayerSheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet0 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			psnalLangLayerSheet2.DoSearch( "${ctx}/PsnalLang.do?cmd=getPsnalLangGlobalList", param );
			break;
		case "Save":
			IBS_SaveName(document.psnalLangLayerSheet1Form,psnalLangLayerSheet2);
			psnalLangLayerSheet2.DoSave( "${ctx}/PsnalLang.do?cmd=savePsnalLangGlobal", $("#psnalLangLayerSheet1Form").serialize());
			break;
		case "Insert":
			var row = psnalLangLayerSheet2.DataInsert(0);
			psnalLangLayerSheet2.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalLangLayerSheet2.SetCellValue(row,"sabun",$("#hdnSabun").val(),0);
			break;
		case "Copy":
			var row = psnalLangLayerSheet2.DataCopy();
			psnalLangLayerSheet2.SetCellValue(row,"seq","",0);
			break;
		case "Clear":
			psnalLangLayerSheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(psnalLangLayerSheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			psnalLangLayerSheet2.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function psnalLangLayerSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();

			for(var i = 0; i < psnalLangLayerSheet1.RowCount(); i++) {
				var row = i+1;
				var foreignCd = psnalLangLayerSheet1.GetCellValue(row,"foreignCd");
				var fTestCd = psnalLangLayerSheet1.GetCellValue(row,"fTestCd");
				var comboItemCd = " ";
				var comboItemNm = " ";

				//파일 첨부 시작
				for(var r = psnalLangLayerSheet1.HeaderRows(); r<psnalLangLayerSheet1.RowCount()+psnalLangLayerSheet1.HeaderRows(); r++){
					if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
						if(psnalLangLayerSheet1.GetCellValue(r,"fileSeq") == ''){
							psnalLangLayerSheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
							psnalLangLayerSheet1.SetCellValue(r, "sStatus", 'R');
						}else{
							psnalLangLayerSheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
							psnalLangLayerSheet1.SetCellValue(r, "sStatus", 'R');
						}
					}else{
						if(psnalLangLayerSheet1.GetCellValue(r,"fileSeq") != ''){
							psnalLangLayerSheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
							psnalLangLayerSheet1.SetCellValue(r, "sStatus", 'R');
						}
					}
				}

			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function psnalLangLayerSheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 값이 바뀔때 발생
	function psnalLangLayerSheet1_OnChange(Row, Col, Value) {
		try{
			setForeignCdCombo(psnalLangLayerSheet1.ColSaveName(Col), Row);
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function setForeignCdCombo(colName, Row) {
		if(colName == "fTestCd") {
			var fTestCd     = psnalLangLayerSheet1.GetCellValue(Row,"fTestCd");
			var fTestCdList = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+searchEnterCd,"H20307");

			$.each(fTestCdList, function(idx, value) {
				if(fTestCd == value.code) {
					psnalLangLayerSheet1.SetCellValue(Row,"foreignCd",$.trim(value.note1));
				}
			});
		}
	}

	// 조회 후 에러 메시지
	function psnalLangLayerSheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var r = psnalLangLayerSheet2.HeaderRows(); r<psnalLangLayerSheet2.RowCount()+psnalLangLayerSheet1.HeaderRows(); r++){
				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(psnalLangLayerSheet2.GetCellValue(r,"fileSeq") == ''){
						psnalLangLayerSheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						psnalLangLayerSheet2.SetCellValue(r, "sStatus", 'R');
					}else{
						psnalLangLayerSheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalLangLayerSheet2.SetCellValue(r, "sStatus", 'R');
					}
				}else{
					if(psnalLangLayerSheet2.GetCellValue(r,"fileSeq") != ''){
						psnalLangLayerSheet2.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalLangLayerSheet2.SetCellValue(r, "sStatus", 'R');
					}
				}
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function psnalLangLayerSheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 값이 바뀔때 발생
	function psnalLangLayerSheet2_OnChange(Row, Col, Value) {
		try{
			if( psnalLangLayerSheet2.ColSaveName(Col) == "sdate" || psnalLangLayerSheet2.ColSaveName(Col) == "edate"  ) {
				if(psnalLangLayerSheet2.GetCellValue(Row,"sdate") != "" && psnalLangLayerSheet2.GetCellValue(Row,"edate") != "") {
					if(psnalLangLayerSheet2.GetCellValue(Row,"sdate") > psnalLangLayerSheet2.GetCellValue(Row,"edate")) {
						alert("<msg:txt mid='errEdate' mdef='종료일은 시작일 이후 날짜로 입력하여 주십시오.'/>");
						psnalLangLayerSheet2.SetCellValue(Row,"edate","");
					}
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	//파일 신청 시작
	function psnalLangLayerSheet1_OnClick(Row, Col, Value) {
		try{

			if(psnalLangLayerSheet1.ColSaveName(Col) == "btnFile" && Row >= psnalLangLayerSheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = psnalLangLayerSheet1.GetCellValue(Row,"fileSeq");
				if(psnalLangLayerSheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup1";

					var authPgTemp="${authPg}";
					//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=lang", param, "740","620");
				    fileMgrPopup1(Row, Col);

				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
    // 파일첨부/다운로드 팝입
    function fileMgrPopup1(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : 'fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}&uploadType=lang'
            , parameters : {
                fileSeq : psnalLangLayerSheet1.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(result.fileCheck == "exist"){
                            psnalLangLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                            psnalLangLayerSheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            psnalLangLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                            psnalLangLayerSheet1.SetCellValue(gPRow, "fileSeq", "");
                        }
                    }
                }
            ]
        });
        layerModal.show();
    }
	//파일 신청 끝

	//파일 신청 시작
	function psnalLangLayerSheet2_OnClick(Row, Col, Value) {
		try{
			if(psnalLangLayerSheet2.ColSaveName(Col) == "btnFile" && Row >= psnalLangLayerSheet2.HeaderRows()){
				var param = [];
				param["fileSeq"] = psnalLangLayerSheet2.GetCellValue(Row,"fileSeq");
				if(psnalLangLayerSheet2.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup2";

					var authPgTemp="${authPg}";
					fileMgrPopup2(Row, Col);
					//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=lang", param, "740","620");
				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
    // 파일첨부/다운로드 팝입
    function fileMgrPopup2(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}&uploadType=lang'
            , parameters : {
                fileSeq : psnalLangLayerSheet2.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(result.fileCheck == "exist"){
                            psnalLangLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                            psnalLangLayerSheet2.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            psnalLangLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                            psnalLangLayerSheet2.SetCellValue(gPRow, "fileSeq", "");
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
				psnalLangLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				psnalLangLayerSheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				psnalLangLayerSheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				psnalLangLayerSheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		} else if(pGubun == "fileMgrPopup2") {
			if(rv["fileCheck"] == "exist"){
				psnalLangLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				psnalLangLayerSheet2.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				psnalLangLayerSheet2.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				psnalLangLayerSheet2.SetCellValue(gPRow, "fileSeq", "");
			}
        }
	}

</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<form id="psnalLangLayerSheet1Form" name="psnalLangLayerSheet1Form"></form>
<div class="wrapper modal_layer">
	<div class="modal_body">
		<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
		<input id="hdnSabun" name="hdnSabun" type="hidden">
		<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li class="btn _thrm125">
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
		<%--	<script type="text/javascript"> createIBSheet("psnalLangLayerSheet1", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
		<div id="psnalLangLayerSheet1-wrap"></div>
		<!-- 	<div class="outer" style="display:none"> -->
		<div style="display:none">
			<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='gbCoordinator' mdef='글로벌 코디네이터'/></li>
					<li class="btn">
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
			<div id="psnalLangLayerSheet2-wrap"></div>

		</div>
		<%--	<script type="text/javascript"> createIBSheet("psnalLangLayerSheet2", "0", "0", "${ssnLocaleCd}"); </script>--%>
	</div>
</div>
</body>
</html>
