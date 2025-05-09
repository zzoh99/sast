<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104238' mdef='인사기본(자격)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var searchUserId = '';
	var searchUserEnterCd = '';
	$(function() {
		createIBSheet3(document.getElementById('psnalLicenseLayerSheet-wrap'), "psnalLicenseLayerSheet", "100%", "100%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('psnalLicenseLayer');
		searchUserId = modal.parameters.userId || '';
		searchUserEnterCd = modal.parameters.userEnterCd || '';

		$("#hdnSabun").val(searchUserId);
		$("#hdnEnterCd").val(searchUserEnterCd);

		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm113"] = psnalLicenseLayerSheet;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:8, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		//var headers = [
		//	{Text:"No|삭제|상태|사번|일련번호|자격증구분|자격증코드|자격증명|등급|취득일|갱신일\n(교부일)|만료일|발행기관|자격증번호|수당지급\n시작일|수당지급\n종료일|수당지급여부|비고|파일첨부|파일번호",Align:"Center"}
		//];

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>", Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>", Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>", Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>", Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>", Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='licenseCd' mdef='자격증코드'/>",Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"licenseCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='licenseNm' mdef='자격증명'/>", Type:"Popup",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"licenseNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='grade' mdef='등급'/>", Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"licenseGrade",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='licenseGubun' mdef='자격증구분'/>", Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"licenseGubun",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='licSYmd' mdef='취득일'/>", Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"licSYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='licUYmd' mdef='갱신일\n(교부일)'/>", Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"licUYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='licEYmd' mdef='만료일'/>", Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"licEYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발급기관", Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"officeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='licenseNo' mdef='자격증번호'/>", Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"licenseNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"자격수당금액", Type:"Int",		Hidden:1,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"allowAmount",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='allowSymd' mdef='수당지급\n시작일'/>", Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"allowSymd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='allowEymd' mdef='수당지급\n종료일'/>", Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"allowEymd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='allowYnV1' mdef='수당여부'/>", Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"allowYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"관련근거", Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"licenseBigo",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='btnFileV1' mdef='파일첨부'/>", Type:"Html",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeqV1' mdef='파일번호'/>", Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
		];


		IBS_InitSheet(psnalLicenseLayerSheet, initdata1);

		//psnalLicenseLayerSheet.SetConfig(config);
		//psnalLicenseLayerSheet.InitHeaders(headers, info);
		//psnalLicenseLayerSheet.InitColumns(cols);

		psnalLicenseLayerSheet.SetEditable("${editable}");
		psnalLicenseLayerSheet.SetVisible(true);
		psnalLicenseLayerSheet.SetCountPosition(0);

		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			psnalLicenseLayerSheet.SetEditable(0);
			$(".enterAuthBtn").hide();
		}
		var enterCd = "&enterCd="+$("#hdnEnterCd").val();

		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H20170"), "");

		psnalLicenseLayerSheet.SetColProperty("licenseGubun", 	{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		psnalLicenseLayerSheet.SetColProperty("allowYn", 	{ComboText:"|Y|N", ComboCode:"|Y|N"} );

		let sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
		psnalLicenseLayerSheet.SetSheetHeight(sheetHeight);

		doAction1("Search");

	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()
						+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			psnalLicenseLayerSheet.DoSearch( "${ctx}/PsnalLicense.do?cmd=getPsnalLicenseList", param );
			break;
		case "Save":
			IBS_SaveName(document.psnalLicenseLayerSheetForm,psnalLicenseLayerSheet);
			psnalLicenseLayerSheet.DoSave( "${ctx}/PsnalLicense.do?cmd=savePsnalLicense", $("#psnalLicenseLayerSheetForm").serialize());
			break;
		case "Insert":
			var row = psnalLicenseLayerSheet.DataInsert(0);

			psnalLicenseLayerSheet.SetCellValue(row,"sabun",$("#hdnSabun").val());

			//파일첨부 시작
			psnalLicenseLayerSheet.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			//파일첨부 끝
			break;
		case "Copy":
			var row = psnalLicenseLayerSheet.DataCopy();
			psnalLicenseLayerSheet.SetCellValue(row,"seq","");
			psnalLicenseLayerSheet.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalLicenseLayerSheet.SetCellValue(row, "fileSeq", '');
			break;
		case "Clear":
			psnalLicenseLayerSheet.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(psnalLicenseLayerSheet);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			psnalLicenseLayerSheet.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function psnalLicenseLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var i = 0; i < psnalLicenseLayerSheet.RowCount(); i++) {

				//파일 첨부 시작
				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(psnalLicenseLayerSheet.GetCellValue(i+1,"fileSeq") == ''){
						psnalLicenseLayerSheet.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						psnalLicenseLayerSheet.SetCellValue(i+1, "sStatus", 'R');
					}else{
						psnalLicenseLayerSheet.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalLicenseLayerSheet.SetCellValue(i+1, "sStatus", 'R');
					}
				}else{
					if(psnalLicenseLayerSheet.GetCellValue(i+1,"fileSeq") != ''){
						psnalLicenseLayerSheet.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalLicenseLayerSheet.SetCellValue(i+1, "sStatus", 'R');
					}
				}
				//파일 첨부 끝
			}


			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function psnalLicenseLayerSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function psnalLicenseLayerSheet_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(psnalLicenseLayerSheet.GetCellEditable(Row,Col) == true) {
				if(psnalLicenseLayerSheet.ColSaveName(Col) == "licenseNm" && KeyCode == 46) {
					psnalLicenseLayerSheet.SetCellValue(Row,"licenseCd","");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function psnalLicenseLayerSheet_OnPopupClick(Row,Col) {
		try {
			if(psnalLicenseLayerSheet.ColSaveName(Col) == "licenseNm") {
				/*if(psnalLicenseLayerSheet.GetCellValue(Row,"licenseGubun") == "") {
					alert("<msg:txt mid='110446' mdef='자격구분을 선택하여 주십시오.'/>");
					return;
				}

				var gubun = psnalLicenseLayerSheet.GetCellValue(Row,"licenseGubun");

				var param = [];
				param["gubun"] = gubun;
				*/

				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "licensePopup";

				licensePopup(Row,Col);
				//var win = openPopup("/PsnalLicense.do?cmd=viewHrmLicensePopup&authPg=${authPg}", "", "850","820");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}
	
    // 자격증검색 팝입
    function licensePopup(Row, Col) {
        let layerModal = new window.top.document.LayerModal({
              id : 'hrmLicenseLayer'
            , url : '/PsnalLicense.do?cmd=viewHrmLicenseLayer&authPg=${authPg}'
            , parameters : {
                gubun : psnalLicenseLayerSheet.GetCellValue(Row,"licenseGubun")
              }
            , width : 800
            , height : 520
            , title : '자격증 검색'
            , trigger :[
                {
                      name : 'hrmLicenseTrigger'
                    , callback : function(result){
                        psnalLicenseLayerSheet.SetCellValue(gPRow, "licenseCd", result.code);
                        psnalLicenseLayerSheet.SetCellValue(gPRow, "licenseNm", result.codeNm);
                        psnalLicenseLayerSheet.SetCellValue(gPRow, "licenseGubun", result.note1);
                        psnalLicenseLayerSheet.SetCellValue(gPRow, "licenseBigo", result.note2);
                    }
                }
            ]
        });
        layerModal.show();
    }
    
	// 셀 값이 바뀔때 발생
	function psnalLicenseLayerSheet_OnChange(Row, Col, Value) {
		try{
			if( psnalLicenseLayerSheet.ColSaveName(Col) == "licSYmd" || psnalLicenseLayerSheet.ColSaveName(Col) == "licEYmd"  ) {
				if(psnalLicenseLayerSheet.GetCellValue(Row,"licSYmd") != "" && psnalLicenseLayerSheet.GetCellValue(Row,"licEYmd") != "") {
					if(psnalLicenseLayerSheet.GetCellValue(Row,"licSYmd") > psnalLicenseLayerSheet.GetCellValue(Row,"licEYmd")) {
						alert("<msg:txt mid='110447' mdef='만료일은 취득일 이후 날짜로 입력하여 주십시오.'/>");
						psnalLicenseLayerSheet.SetCellValue(Row,"licEYmd","");
					}
				}
			} else if( psnalLicenseLayerSheet.ColSaveName(Col) == "allowSymd" || psnalLicenseLayerSheet.ColSaveName(Col) == "allowEymd"  ) {
				if(psnalLicenseLayerSheet.GetCellValue(Row,"allowSymd") != "" && psnalLicenseLayerSheet.GetCellValue(Row,"allowEymd") != "") {
					if(psnalLicenseLayerSheet.GetCellValue(Row,"allowSymd") > psnalLicenseLayerSheet.GetCellValue(Row,"allowEymd")) {
						alert("<msg:txt mid='109878' mdef='수당지급 종료일은 시작일 이후 날짜로 입력하여 주십시오.'/>");
						psnalLicenseLayerSheet.SetCellValue(Row,"allowEymd","");
					}
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function psnalLicenseLayerSheet_OnClick(Row, Col, Value) {
		try{
			if(psnalLicenseLayerSheet.ColSaveName(Col) == "btnFile" && Row >= psnalLicenseLayerSheet.HeaderRows()){

				if(psnalLicenseLayerSheet.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup";

					fileMgrPopup(Row, Col);
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

    // 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}&uploadType=license'
            , parameters : {
            	fileSeq : psnalLicenseLayerSheet.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(result.fileCheck == "exist"){
                            psnalLicenseLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                            psnalLicenseLayerSheet.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            psnalLicenseLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                            psnalLicenseLayerSheet.SetCellValue(gPRow, "fileSeq", "");
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

        if(pGubun == "licensePopup"){
        	psnalLicenseLayerSheet.SetCellValue(gPRow, "licenseCd", rv["code"]);
        	psnalLicenseLayerSheet.SetCellValue(gPRow, "licenseNm", rv["codeNm"]);
        	psnalLicenseLayerSheet.SetCellValue(gPRow, "licenseGubun", rv["note1"]);
        	psnalLicenseLayerSheet.SetCellValue(gPRow, "licenseBigo", rv["note2"]);
        	
        } else if(pGubun == "fileMgrPopup") {
			if(rv["fileCheck"] == "exist"){
				psnalLicenseLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				psnalLicenseLayerSheet.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				psnalLicenseLayerSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				psnalLicenseLayerSheet.SetCellValue(gPRow, "fileSeq", "");
			}
        }
	}
</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<form id="psnalLicenseLayerSheetForm" name="psnalLicenseLayerSheetForm">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
</form>
<div class="wrapper modal_layer">
	<div class="modal_body">
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="btn _thrm113">
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
		<%--	<script type="text/javascript"> createIBSheet("psnalLicenseLayerSheet", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
		<div id="psnalLicenseLayerSheet-wrap"></div>
	</div>
</div>
</body>
</html>
