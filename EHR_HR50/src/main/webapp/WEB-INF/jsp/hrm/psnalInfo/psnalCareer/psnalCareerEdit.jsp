<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103836' mdef='인사기본(경력)'/></title>
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
	var initdata2 = {};
	initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
	initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata2.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
		{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
		{Header:"<sht:txt mid='cmpCd' mdef='직장코드'/>",			Type:"Popup",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"cmpCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='cmpNm' mdef='직장명'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"cmpNm",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='edateV1' mdef='퇴사일'/>",			Type:"Date",		Hidden:0,					Width:90,			Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='jobCdV2' mdef='담당직무코드'/>",		Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
		{Header:"<sht:txt mid='jobNm_V1931' mdef='담당직무'/>",			Type:"Popup",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='jobNmBef' mdef='담당직무\n(과거)'/>",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jobNmBef",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
		{Header:"<sht:txt mid='businessNm' mdef='직무상세'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"businessNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		{Header:"<sht:txt mid='workYmCntV1' mdef='근속기간'/>",			Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"workYmCnt",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
		{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",			Type:"Html",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
		{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
		{Header:"<sht:txt mid='bigo_V2854' mdef='비고(변경내역메모)'/>",	Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"bigo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }
	]; IBS_InitSheet(sheet2, initdata2);sheet2.SetCountPosition(4);

	sheet2.SetFocusAfterProcess(false);

	$("#hdnSabun").val($("#searchUserId",parent.document).val());

	$(window).smartresize(sheetResize);
	sheetInit();

	doAction2("Search");
});

function doAction2(sAction) {
	switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val();
			sheet2.DoSearch( "${ctx}/PsnalCareer.do?cmd=getPsnalCareerList", param );
			break;

		case "Insert":
			var row = sheet2.DataInsert(0);
			sheet2.SetCellValue(row,"sabun",$("#hdnSabun").val());
			//파일첨부 시작
			sheet2.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			//파일첨부 끝
			break;

		case "Save":
			IBS_SaveName(document.sheet1Form,sheet2);
			sheet2.DoSave( "${ctx}/PsnalCareer.do?cmd=savePsnalCareer", $("#sheet1Form").serialize());
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
	}
}

// 조회 후 에러 메시지
function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}

		//파일 첨부 시작
		for(var i = 0; i < sheet2.RowCount(); i++) {

			if(sheet2.GetCellValue(i+1,"fileSeq") == ''){
				sheet2.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				sheet2.SetCellValue(i+1, "sStatus", 'R');
			}else{
				sheet2.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				sheet2.SetCellValue(i+1, "sStatus", 'R');
			}
		}

		sheetResize();

		//파일 첨부 끝
	} catch (ex) {
		alert("OnSearchEnd Event Error : " + ex);
	}
}

// 저장 후 메시지
function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}


		doAction2("Search");
	} catch (ex) {
		alert("OnSaveEnd Event Error " + ex);
	}
}

// 셀에서 키보드가 눌렀을때 발생하는 이벤트
function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
	try {
		if(sheet2.GetCellEditable(Row,Col) == true) {
			if(sheet2.ColSaveName(Col) == "jobNm" && KeyCode == 46) {
            	sheet2.SetCellValue(Row, "jobCd", "");
            	sheet2.SetCellValue(Row, "jobNm", "");
			}
		}
	} catch (ex) {
		alert("OnKeyDown Event Error : " + ex);
	}
}

// 팝업 클릭시 발생
function sheet2_OnPopupClick(Row,Col) {
	try {
		if(sheet2.ColSaveName(Col) == "cmpCd") {
			var param = [];
			param["grpCd"] = "H20450";

            var rst = openPopup("/Popup.do?cmd=commonCodePopup&authPg=R", param, "740","620");
            if(rst != null){
            	sheet2.SetCellValue(Row, "cmpCd", rst["code"]);
            	sheet2.SetCellValue(Row, "cmpNm", rst["codeNm"]);
            }
		} else if(sheet2.ColSaveName(Col) == "jobNm") {
			var args = new Array();
			args["searchJobType"] = "10050"; // 직무

            var rst = openPopup("/Popup.do?cmd=jobPopup&authPg=R", args, "740","620");
            if(rst != null){
            	sheet2.SetCellValue(Row, "jobCd", rst["jobCd"]);
            	sheet2.SetCellValue(Row, "jobNm", rst["jobNm"]);
            }
		}
	} catch (ex) {
		alert("OnPopupClick Event Error : " + ex);
	}
}

// 파일 신청
function sheet2_OnClick(Row, Col, Value) {
	try{
		if(sheet2.ColSaveName(Col) == "btnFile"){
			var param = [];
			param["fileSeq"] = sheet2.GetCellValue(Row,"fileSeq");
			if(sheet2.GetCellValue(Row,"btnFile") != ""){
				var authPgTemp="A";
				var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=career", param, "740","620");
				if(rv != null){
					if(rv["fileCheck"] == "exist"){
						sheet2.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						sheet2.SetCellValue(Row, "fileSeq", rv["fileSeq"]);
					}else{
						sheet2.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						sheet2.SetCellValue(Row, "fileSeq", "");
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
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='114694' mdef='전근무지 이력 변경'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction2('Insert');"		css="basic" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction2('Save');"			css="basic" mid='110708' mdef="저장"/>
				<a href="javascript:doAction2('Down2Excel');"	class="basic"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
