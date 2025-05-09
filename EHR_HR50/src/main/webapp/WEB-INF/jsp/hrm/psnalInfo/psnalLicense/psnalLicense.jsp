<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104238' mdef='인사기본(자격)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		// 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
		initIbFileUpload($("#sheet1Form"));

		// 파일 목록 변수의 초기화 작업 시점 정의
		// clearBeforeFunc(function object)
		// 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
		//		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
		//	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
		sheet1_OnSearchEnd = clearBeforeFunc(sheet1_OnSearchEnd);
		sheet1_OnSaveEnd = clearBeforeFunc(sheet1_OnSaveEnd)

		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm113"] = sheet1;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:8, DataRowMerge:0};
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


		IBS_InitSheet(sheet1, initdata1);

		//sheet1.SetConfig(config);
		//sheet1.InitHeaders(headers, info);
		//sheet1.InitColumns(cols);

		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		$("#hdnEnterCd").val($("#searchUserEnterCd",parent.document).val());
		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			sheet1.SetEditable(0);
			$(".enterAuthBtn").hide();
		}
		var enterCd = "&enterCd="+$("#hdnEnterCd").val();

		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H20170"), "");
		//var userCd2 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20161"), "");
		//var userCd3 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20175"), "");

		sheet1.SetColProperty("licenseGubun", 	{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		//sheet1.SetColProperty("licenseGrade", 	{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
		//sheet1.SetColProperty("officeCd", 		{ComboText:"|"+userCd3[0], ComboCode:"|"+userCd3[1]} );
		sheet1.SetColProperty("allowYn", 	{ComboText:"|Y|N", ComboCode:"|Y|N"} );

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");

	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
			var param = "sabun="+$("#hdnSabun").val()
						+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			sheet1.DoSearch( "${ctx}/PsnalLicense.do?cmd=getPsnalLicenseList", param );
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PsnalLicense.do?cmd=savePsnalLicense", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);

			sheet1.SetCellValue(row,"sabun",$("#hdnSabun").val());

			//파일첨부 시작
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
			//파일첨부 끝
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"seq","");
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
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

			for(var i = 0; i < sheet1.RowCount(); i++) {
				/*var code = sheet1.GetCellValue(i+1,"licenseGubun");
alert(code);
				if(code == "") {
					sheet1.SetCellValue(i+1,"licenseNm","");
					sheet1.SetColEditable("licenseNm",false);
				} else if(code != "99") {
					var info = {Type: "Popup", Align: "Left", Edit:1};
					sheet1.InitCellProperty(i+1, "licenseNm", info);
					sheet1.SelectCell(i+1,"licenseNm");
				} else {
					var info = {Type: "Text", Align: "Left", Edit:1};
					sheet1.InitCellProperty(i+1, "licenseNm", info);
					sheet1.SelectCell(i+1,"licenseNm");
				}*/


				//파일 첨부 시작
				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(sheet1.GetCellValue(i+1,"fileSeq") == ''){
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}else{
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}
				}else{
					if(sheet1.GetCellValue(i+1,"fileSeq") != ''){
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
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

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "licenseNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"licenseCd","");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "licenseNm") {
				/*if(sheet1.GetCellValue(Row,"licenseGubun") == "") {
					alert("<msg:txt mid='110446' mdef='자격구분을 선택하여 주십시오.'/>");
					return;
				}

				var gubun = sheet1.GetCellValue(Row,"licenseGubun");

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
                gubun : sheet1.GetCellValue(Row,"licenseGubun")
              }
            , width : 800
            , height : 520
            , title : '자격증 검색'
            , trigger :[
                {
                      name : 'hrmLicenseTrigger'
                    , callback : function(result){
                        sheet1.SetCellValue(gPRow, "licenseCd", result.code);
                        sheet1.SetCellValue(gPRow, "licenseNm", result.codeNm);
                        sheet1.SetCellValue(gPRow, "licenseGubun", result.note1);
                        sheet1.SetCellValue(gPRow, "licenseBigo", result.note2);
                    }
                }
            ]
        });
        layerModal.show();
    }
    
	// 셀 값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			/*
			if( sheet1.ColSaveName(Col) == "licenseGubun"  ) {
				var code = sheet1.GetCellValue( Row,Col);

				sheet1.SetCellValue(Row,"licenseCd","");
				sheet1.SetCellValue(Row,"licenseNm","");

				if(code == "") {
					sheet1.SetColEditable("acaSchNm",false);
				} else if(code != "99") {
					var info = {Type: "Popup", Align: "Left", Edit:1};
					sheet1.InitCellProperty(Row, "licenseNm", info);
					sheet1.SelectCell(Row,"licenseNm");
				} else {
					var info = {Type: "Text", Align: "Left", Edit:1};
					sheet1.InitCellProperty(Row, "licenseNm", info);
					sheet1.SelectCell(Row,"licenseNm");
				}
		    }
			*/
			if( sheet1.ColSaveName(Col) == "licSYmd" || sheet1.ColSaveName(Col) == "licEYmd"  ) {
				if(sheet1.GetCellValue(Row,"licSYmd") != "" && sheet1.GetCellValue(Row,"licEYmd") != "") {
					if(sheet1.GetCellValue(Row,"licSYmd") > sheet1.GetCellValue(Row,"licEYmd")) {
						alert("<msg:txt mid='110447' mdef='만료일은 취득일 이후 날짜로 입력하여 주십시오.'/>");
						sheet1.SetCellValue(Row,"licEYmd","");
					}
				}
			} else if( sheet1.ColSaveName(Col) == "allowSymd" || sheet1.ColSaveName(Col) == "allowEymd"  ) {
				if(sheet1.GetCellValue(Row,"allowSymd") != "" && sheet1.GetCellValue(Row,"allowEymd") != "") {
					if(sheet1.GetCellValue(Row,"allowSymd") > sheet1.GetCellValue(Row,"allowEymd")) {
						alert("<msg:txt mid='109878' mdef='수당지급 종료일은 시작일 이후 날짜로 입력하여 주십시오.'/>");
						sheet1.SetCellValue(Row,"allowEymd","");
					}
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){
				//var param = [];
				//param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				//var param = { "fileSeq": sheet1.GetCellValue(Row,"fileSeq")};

				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup";

					var authPgTemp="${authPg}";
					//var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=license", param, "740","620");
					fileMgrPopup(Row, Col);
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

    // 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&authPg=${authPg}&uploadType=license' // url 변경
            , parameters : {
            	fileSeq : sheet1.GetCellValue(Row,"fileSeq"),
				fileInfo: getFileList(sheet1.GetCellValue(Row,"fileSeq")) // 파일 목록 동기화 처리를 위함
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
						addFileList(sheet1, gPRow, result); // 작업한 파일 목록 업데이트

                        if(result.fileCheck == "exist"){
                            sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
                            sheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
                            sheet1.SetCellValue(gPRow, "fileSeq", "");
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
        	sheet1.SetCellValue(gPRow, "licenseCd", rv["code"]);
        	sheet1.SetCellValue(gPRow, "licenseNm", rv["codeNm"]);
        	sheet1.SetCellValue(gPRow, "licenseGubun", rv["note1"]);
        	sheet1.SetCellValue(gPRow, "licenseBigo", rv["note2"]);
        	
        } else if(pGubun == "fileMgrPopup") {
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
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
<div class="wrapper">
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='license' mdef='자격'/></li>
			<li class="btn _thrm113">
				<btn:a href="javascript:doAction1('Search');" css="btn dark authR" mid='110697' mdef="조회"/>
			<c:if test="${authPg == 'A'}">
				<btn:a href="javascript:doAction1('Insert');" css="btn outline_gray authA enterAuthBtn" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="btn outline_gray authA enterAuthBtn" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="btn filled authA enterAuthBtn" mid='110708' mdef="저장"/>
			</c:if>
				<btn:a href="javascript:doAction1('Down2Excel');" css="btn outline_gray authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
