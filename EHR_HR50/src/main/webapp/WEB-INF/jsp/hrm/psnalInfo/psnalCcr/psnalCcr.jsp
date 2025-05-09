<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103841' mdef='인사기본(상벌)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">
//ccrCd
var gPRow = "";
var pGubun = "";
var ccrCdList = "";

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

		ccrCdList = ajaxCall("/CommonCode.do?cmd=getCommonNSCodeList&searchGrcodeCd=H90009", "queryId=getComCodeNoteList", false) ;
		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm185"] = sheet1;
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:6,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
   			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
   			{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>",	Type:"Int",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"Number",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
   			{Header:"<sht:txt mid='ymdV9' mdef='일자'/>",		Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"ccrYmd",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",		Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"ccrCd",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:330, MultiLineText:1, ToolTip:1},
			{Header:"<sht:txt mid='sPoint' mdef='상벌점'/>",		Type:"Int",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ccrPoint",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='sgPointV1' mdef='승진\n포인트'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Right",	ColMerge:0,	SaveName:"sgPoint",			KeyField:0,	Format:"Number",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4 },
			{Header:"<sht:txt mid='adviser_V1' mdef='상담자'/>",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"adviser",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",	Type:"Html",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetEditEnterBehavior("newline");

		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		$("#hdnEnterCd").val($("#searchUserEnterCd",parent.document).val());
		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			sheet1.SetEditable(0);
			$(".enterAuthBtn").hide();
		}
		var enterCd = "&enterCd="+$("#hdnEnterCd").val();

		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd,"H90009"), "");

		sheet1.SetColProperty("ccrCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");


	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			sheet1.DoSearch( "${ctx}/PsnalCcr.do?cmd=getPsnalCcrList", param );
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PsnalCcr.do?cmd=savePsnalCcr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
			sheet1.SetCellValue(row,"sabun",$("#hdnSabun").val());
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

			//파일 첨부 시작
			for(var r = sheet1.HeaderRows(); r<sheet1.LastRow()+sheet1.HeaderRows(); r++){
				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(sheet1.GetCellValue(r,"fileSeq") == ''){
						sheet1.SetCellValue(r, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
						sheet1.SetCellValue(r, "sStatus", 'R');
					}else{
						sheet1.SetCellValue(r, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(r, "sStatus", 'R');
					}
				}else{
					if(sheet1.GetCellValue(r,"fileSeq") != ''){
						sheet1.SetCellValue(r, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(r, "sStatus", 'R');
					}
				}
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

	// 셀 값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "ccrCd" ) {
				if( ccrCdList != null ) {
					for( var i = 0; i < ccrCdList.codeList.length; i++) {
						if( ccrCdList.codeList[i].code == sheet1.GetCellValue(Row, "ccrCd") ) {
							sheet1.SetCellValue(Row, "ccrPoint", ccrCdList.codeList[i].note1) ;
							sheet1.SetCellValue(Row, "sgPoint", ccrCdList.codeList[i].note2) ;
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
	function sheet1_OnClick(Row, Col, Value) {
		try{

			if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){
				//var param = [];
				//param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				var param = { "fileSeq": sheet1.GetCellValue(Row,"fileSeq")};
				if(sheet1.GetCellValue(Row,"btnFile") != ""){

					gPRow = Row;
					pGubun = "viewPopup";

					var authPgTemp="${authPg}";
					fileMgrPopup(Row, Col);
					//openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=ccr", param, "740","620");
				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
    // 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {
        var authPgTemp="${authPg}";
        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&authPg=${authPg}&uploadType=ccr'
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
						addFileList(sheet1, Row, result); // 작업한 파일 목록 업데이트
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
	//파일 신청 끝

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "viewPopup"){
			if(rv != null){
				if(rv["fileCheck"] == "exist"){
					sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
					sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
				}else{
					sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
					sheet1.SetCellValue(gPRow, "fileSeq", "");
				}
			}
	    }

	}

</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112890' mdef='기록사항'/></li>
			<li class="btn _thrm185">
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
