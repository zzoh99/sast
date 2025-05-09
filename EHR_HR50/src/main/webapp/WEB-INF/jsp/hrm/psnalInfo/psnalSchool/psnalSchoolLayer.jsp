<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104432' mdef='인사기본(학력)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var searchUserId = '';
	var searchUserEnterCd = '';
	$(function() {
		createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('psnalSchoolLayer');
		searchUserId = modal.parameters.userId || '';
		searchUserEnterCd = modal.parameters.userEnterCd || '';

		$("#hdnSabun").val(searchUserId);
		$("#hdnEnterCd").val(searchUserEnterCd);
		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm115"] = sheet1;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:9, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='201704200000001' mdef='학력구분'/>",		Type:"Combo",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"acaCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='acaDegCd' mdef='학위구분'/>",		Type:"Combo",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"acaDegCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='acaSchCd' mdef='학교코드'/>",		Type:"Text",	Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"acaSchCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='acaSchNm' mdef='학교명'/>",			Type:"PopupEdit",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"acaSchNm",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"<sht:txt mid='acamajCd' mdef='전공코드'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acamajCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='acamajNm' mdef='전공'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"acamajNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='doumajNm' mdef='복수전공'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"doumajNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='submajCd' mdef='부전공코드'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"submajCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='submajNm' mdef='부전공'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"submajNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='acaPoint' mdef='학점'/>",			Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"acaPoint",	KeyField:0,	Format:"Float",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='acaPointManjum' mdef='학점만점'/>",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"acaPointManjum",	KeyField:0,	Format:"Float",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"입학연월",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"acaSYm",		KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
			{Header:"졸업연월",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"acaEYm",		KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
			{Header:"<sht:txt mid='acaYn' mdef='졸업구분'/>",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"acaYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='gradeNo' mdef='학위번호'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gradeNo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },

			{Header:"<sht:txt mid='acaPlaceCd' mdef='소재지코드'/>",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acaPlaceCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='acaPlaceNm' mdef='소재지'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acaPlaceNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='eType' mdef='본분교'/>",			Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"eType",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='dType' mdef='주야간'/>",			Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"dType",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='entryType' mdef='편입\n여부'/>",		Type:"CheckBox",Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"entryType",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='acaType' mdef='최종학력\n여부'/>",	Type:"CheckBox",Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"acaType",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },

			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",		Type:"Html",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);

		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			sheet1.SetEditable(0);
			$(".enterAuthBtn").hide();
		}
		var enterCd = "&enterCd="+$("#hdnEnterCd").val();
		
		//공통코드 한번에 조회
		var grpCds = "H20130,H20140,F64140,F20140";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds + enterCd,false).codeList, "");

		var userCd1 = codeLists["H20130"];
		var userCd2 = codeLists["H20140"];
		var userCd3 = codeLists["F64140"];
		var userCd4 = codeLists["F20140"];

		sheet1.SetColProperty("acaCd", 				{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		sheet1.SetColProperty("acaDegCd", 			{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
		sheet1.SetColProperty("acaPlaceCd", 		{ComboText:"|"+userCd3[0], ComboCode:"|"+userCd3[1]} );
		sheet1.SetColProperty("acaYn", 				{ComboText:"|"+userCd4[0], ComboCode:"|"+userCd4[1]} );
		sheet1.SetColProperty("eType", 				{ComboText:("${ssnLocaleCd}" != "en_US" ? "|본교|분교" : "|Main School|Branch School"), ComboCode:"|Y|N"} );
		sheet1.SetColProperty("dType", 				{ComboText:("${ssnLocaleCd}" != "en_US" ? "|주간|야간" : "|Weekly|Night"), ComboCode:"|Y|N"} );

		let sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
		sheet1.SetSheetHeight(sheetHeight);

		doAction1("Search");

	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()
						+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			sheet1.DoSearch( "${ctx}/PsnalSchool.do?cmd=getPsnalSchoolList", param );
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PsnalSchool.do?cmd=savePsnalSchool", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);

			sheet1.SetCellValue(row,"sabun",$("#hdnSabun").val());
			//파일첨부 시작
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			//파일첨부 끝
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"seq","");
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			sheet1.SetCellValue(row, "fileSeq", '');
			break;
		case "Clear":
			sheet1.RemoveAll();
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

			sheetResize();

			for(var i = 0; i < sheet1.RowCount(); i++) {
				var code = sheet1.GetCellValue(i+1,"acaCd");
				if(code == "") {
					sheet1.SetCellValue(i+1,"acaSchNm","");
					sheet1.SetColEditable("acaSchNm",false);
				} else if(code == "4" || code == "5" || code == "6" || code == "7") {					
					var info = {Type: "PopupEdit", Align: "Left", Edit:1};
					sheet1.InitCellProperty(i+1, "acaSchNm", info);
					sheet1.SelectCell(i+1,"acaSchNm");
				} else {
					var info = {Type: "Text", Align: "Left", Edit:1};
					sheet1.InitCellProperty(i+1, "acaSchNm", info);
					sheet1.SelectCell(i+1,"acaSchNm");
				}
				
				//파일 첨부 시작
				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(sheet1.GetCellValue(i+1,"fileSeq") == ''){
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}else{
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}
				}else{
					if(sheet1.GetCellValue(i+1,"fileSeq") != ''){
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}
				}
				//파일 첨부 끝
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
			if(sheet1.ColSaveName(Col) == "acaSchNm") {
				if(!isPopup()) {return;}

				if(sheet1.GetCellValue(Row,"acaCd") == "") {
					alert("<msg:txt mid='109879' mdef='학력구분을 선택하여 주십시오.'/>");
					return;
				}

				var gubun = "H20145";
				/*
				if(sheet1.GetCellValue(Row,"acaCd") == "03")	gubun = "H";	//고등학교
				if(sheet1.GetCellValue(Row,"acaCd") == "04")	gubun = "U";	//전문대학
				if(sheet1.GetCellValue(Row,"acaCd") == "05")	gubun = "U";	//대학교
				if(sheet1.GetCellValue(Row,"acaCd") == "06")	gubun = "U";	//대학원
				if(sheet1.GetCellValue(Row,"acaCd") == "07")	gubun = "U";	//대학원
				*/
				gPRow = Row;
				pGubun = "schoolPopup";

				var param = [];
				param["gubun"] = gubun;

	            var win = openPopup("/HrmSchoolPopup.do?cmd=viewHrmSchoolPopup&authPg=${authPg}", param, "650","620");
			} else if(sheet1.ColSaveName(Col) == "acamajNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "acaMajPopup";

				var param = [];

	            var win = openPopup("/HrmAcaMajPopup.do?cmd=viewHrmAcaMajPopup&authPg=${authPg}", param, "740","620");
			} else if(sheet1.ColSaveName(Col) == "submajNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "subAcaMajPopup";

				var param = [];

	            var win = openPopup("/HrmAcaMajPopup.do?cmd=viewHrmAcaMajPopup&authPg=${authPg}", param, "740","620");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "acaCd"  ) {
				var code = sheet1.GetCellValue( Row,Col);

				sheet1.SetCellValue(Row,"acaSchCd","");
				sheet1.SetCellValue(Row,"acaSchNm","");

				if(code == "") {
					sheet1.SetColEditable("acaSchNm",false);
				} else if(code == "4" || code == "5" || code == "6" || code == "7") {
					var info = {Type: "PopupEdit", Align: "Left", Edit:1};
					sheet1.InitCellProperty(Row, "acaSchNm", info);
					sheet1.SelectCell(Row,"acaSchNm");
				} else {
					var info = {Type: "Text", Align: "Left", Edit:1};
					sheet1.InitCellProperty(Row, "acaSchNm", info);
					sheet1.SelectCell(Row,"acaSchNm");
				}
		    }
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup";

					var authPgTemp="${authPg}";
					//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=school", param, "740","620");
					fileMgrPopup(Row, Col);
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
    // 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg=${authPg}&uploadType=school'
            , parameters : {
                fileSeq : sheet1.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(pGubun == "schoolPopup") {
                            sheet1.SetCellValue(gPRow, "acaSchCd", result.code);
                            sheet1.SetCellValue(gPRow, "acaSchNm", result.codeNm);
                        } else if(pGubun == "acaMajPopup") {
                            sheet1.SetCellValue(gPRow, "acamajCd", result.code);
                            sheet1.SetCellValue(gPRow, "acamajNm", result.codeNm);
                        } else if(pGubun == "subAcaMajPopup") {
                            sheet1.SetCellValue(gPRow, "submajCd", result.code);
                            sheet1.SetCellValue(gPRow, "submajNm", result.codeNm);
                        } else if(pGubun == "fileMgrPopup") {
                            if(result["fileCheck"] == "exist"){
                                sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                                sheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                            }else{
                                sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                                sheet1.SetCellValue(gPRow, "fileSeq", "");
                            }
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

   		if(pGubun == "schoolPopup") {
           	sheet1.SetCellValue(gPRow, "acaSchCd", rv["code"]);
           	sheet1.SetCellValue(gPRow, "acaSchNm", rv["codeNm"]);
   		} else if(pGubun == "acaMajPopup") {
           	sheet1.SetCellValue(gPRow, "acamajCd", rv["code"]);
           	sheet1.SetCellValue(gPRow, "acamajNm", rv["codeNm"]);
   		} else if(pGubun == "subAcaMajPopup") {
           	sheet1.SetCellValue(gPRow, "submajCd", rv["code"]);
           	sheet1.SetCellValue(gPRow, "submajNm", rv["codeNm"]);
   		} else if(pGubun == "fileMgrPopup") {
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
   		}
	}
</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
</form>
<div class="wrapper modal_layer">
	<div class="modal_body">
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="btn _thrm115">
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
<%--		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
		<div id="sheet1-wrap"></div>
	</div>
</div>
</body>
</html>
