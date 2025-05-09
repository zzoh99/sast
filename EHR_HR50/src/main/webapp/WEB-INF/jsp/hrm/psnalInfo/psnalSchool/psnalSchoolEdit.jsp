<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='113951' mdef='인사기본(학력)변경'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>
<!--
 * 인사기본(학력)변경
 * @author JM
-->
<script type="text/javascript">
$(function() {
	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:8};
	initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

	initdata1.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
		{Header:"<sht:txt mid='201704200000001' mdef='학력구분'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"acaCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='acaSchCd' mdef='학교코드'/>",		Type:"Text",		Hidden:1,					Width:150,			Align:"Left",	ColMerge:0,	SaveName:"acaSchCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='acaSchNm' mdef='학교명'/>",		Type:"Popup",		Hidden:0,					Width:150,			Align:"Left",	ColMerge:0,	SaveName:"acaSchNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='acamajCd' mdef='전공코드'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"acamajCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='acamajNm' mdef='전공'/>",		Type:"Popup",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"acamajNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='submajCd' mdef='부전공코드'/>",	Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"submajCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='submajNm' mdef='부전공'/>",		Type:"Popup",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"submajNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='acaPlaceNm' mdef='소재지'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"acaPlaceCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='acaSYm_V4622' mdef='입학연월'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"acaSYm",		KeyField:1,	Format:"Ym",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
		{Header:"<sht:txt mid='acaEYm_V5122' mdef='졸업연월'/>",		Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"acaEYm",		KeyField:1,	Format:"Ym",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8 },
		{Header:"<sht:txt mid='acaYn' mdef='졸업구분'/>",		Type:"Combo",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"acaYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='acaType_V5884' mdef='최종학력여부'/>",	Type:"CheckBox",	Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"acaType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
		{Header:"<sht:txt mid='gradeNo' mdef='학위번호'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"gradeNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },
		{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",		Type:"Html",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
		{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
		{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='bigo_V2854' mdef='비고(변경내역메모)'/>",Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"bigo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }
	]; IBS_InitSheet(sheet1, initdata1);sheet1.SetCountPosition(4);

	var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20130"), "");
	var userCd3 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F64140"), "");
	var userCd4 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20140"), "");

	sheet1.SetColProperty("acaCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
	sheet1.SetColProperty("acaPlaceCd", {ComboText:"|"+userCd3[0], ComboCode:"|"+userCd3[1]} );
	sheet1.SetColProperty("acaYn", 		{ComboText:"|"+userCd4[0], ComboCode:"|"+userCd4[1]} );

	$("#hdnSabun").val($("#searchUserId",parent.document).val());

	$(window).smartresize(sheetResize);
	sheetInit();

	doAction1("Search");
});

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val();
			sheet1.DoSearch( "${ctx}/PsnalSchool.do?cmd=getPsnalSchoolEditList", param );
			break;

		//case "Save":
		//	IBS_SaveName(document.sheet1Form,sheet1);
		//	sheet1.DoSave( "${ctx}/PsnalSchool.do?cmd=savePsnalSchoolEdit", $("#sheet1Form").serialize());
		//	break;

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
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
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
			} else if(code == "11" || code == "12" || code == "21" || code == "31" ) {
				var info = {Type: "Popup", Align: "Left", Edit:1};
				sheet1.InitCellProperty(i+1, "acaSchNm", info);
				sheet1.SelectCell(i+1,"acaSchNm");
			} else {
				var info = {Type: "Text", Align: "Left", Edit:1};
				sheet1.InitCellProperty(i+1, "acaSchNm", info);
				sheet1.SelectCell(i+1,"acaSchNm");
			}
			//파일 첨부 시작
			if(sheet1.GetCellValue(i+1,"fileSeq") == ''){
				sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				sheet1.SetCellValue(i+1, "sStatus", 'R');
			}else{
				sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				sheet1.SetCellValue(i+1, "sStatus", 'R');
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

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		if(sheet1.GetCellEditable(Row,Col) == true) {
			if(sheet1.ColSaveName(Col) == "acaSchNm" && KeyCode == 46) {
				sheet1.SetCellValue(Row,"acaSchCd","");
			} else if(sheet1.ColSaveName(Col) == "acamajNm" && KeyCode == 46) {
				sheet1.SetCellValue(Row,"acamajCd","");
			} else if(sheet1.ColSaveName(Col) == "submajNm" && KeyCode == 46) {
				sheet1.SetCellValue(Row,"submajCd","");
			}
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

// 팝업 클릭시 발생
function sheet1_OnPopupClick(Row,Col) {
	try {
		if(sheet1.ColSaveName(Col) == "acaSchNm") {
			if(sheet1.GetCellValue(Row,"acaCd") == "") {
				alert("<msg:txt mid='109879' mdef='학력구분을 선택하여 주십시오.'/>");
				return;
			}

			var code = sheet1.GetCellValue( Row, "acaCd" );
			var gubun = "";
			if(code == "41") {
				gubun = "H";
			} else {
				gubun = "U";
			}

			var param = [];
			param["gubun"] = gubun;

            var rst = openPopup("/HrmSchoolPopup.do?cmd=viewHrmSchoolPopup&authPg=A", param, "740","620");
            if(rst != null){
            	sheet1.SetCellValue(Row, "acaSchCd", rst["code"]);
            	sheet1.SetCellValue(Row, "acaSchNm", rst["codeNm"]);
            }
		} else if(sheet1.ColSaveName(Col) == "acamajNm") {
			var param = [];

            var rst = openPopup("/HrmAcaMajPopup.do?cmd=viewHrmAcaMajPopup&authPg=A", param, "740","620");
            if(rst != null){
            	sheet1.SetCellValue(Row, "acamajCd", rst["code"]);
            	sheet1.SetCellValue(Row, "acamajNm", rst["codeNm"]);
            }
		} else if(sheet1.ColSaveName(Col) == "submajNm") {
			var param = [];

            var rst = openPopup("/HrmAcaMajPopup.do?cmd=viewHrmAcaMajPopup&authPg=A", param, "740","620");
            if(rst != null){
            	sheet1.SetCellValue(Row, "submajCd", rst["code"]);
            	sheet1.SetCellValue(Row, "submajNm", rst["codeNm"]);
            }
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
			} else if(code == "11" || code == "12" || code == "21" || code == "31" || code == "41" ) {
				var info = {Type: "Popup", Align: "Left", Edit:1};
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
		if(sheet1.ColSaveName(Col) == "btnFile"){
			var param = [];
			param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
			if(sheet1.GetCellValue(Row,"btnFile") != ""){
				var authPgTemp="A";
				var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=school", param, "740","620");
				if(rv != null){
					if(rv["fileCheck"] == "exist"){
						sheet1.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(Row, "fileSeq", rv["fileSeq"]);
					}else{
						sheet1.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						sheet1.SetCellValue(Row, "fileSeq", "");
					}
				}
			}
		}
	}catch(ex){alert("OnClick Event Error : " + ex);}
}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="A">
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112872' mdef='학력 변경'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Insert');"		css="basic" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');"			css="basic" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');"			css="basic" mid='110708' mdef="저장"/>
				<a href="javascript:doAction1('Down2Excel');"	class="basic"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
