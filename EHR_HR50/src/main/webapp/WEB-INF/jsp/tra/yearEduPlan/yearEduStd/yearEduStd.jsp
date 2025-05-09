<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연간교육계획기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
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
		//Sheet 초기화
		init_sheet1();
		
		doAction1("Search");

	});

	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [

			{Header:"No|No",					Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo",		Sort:0 },
			{Header:"삭제|삭제",				Type:"${sDelTy}", Hidden:0,						Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"기준년도|기준년도", 		Type:"Int", 	 Hidden:0, Width:90,  Align:"Center", SaveName:"year", 		KeyField:1, Format:"####", 		UpdateEdit:1, InsertEdit:1, EditLen:4 , MinLen:4},
			{Header:"신청기간|시작일자", 		Type:"Date", 	 Hidden:0, Width:90,  Align:"Center", SaveName:"sdate", 	KeyField:1, Format:"Ymd", 	UpdateEdit:1, InsertEdit:1, EndDateCol:"edate" },
			{Header:"신청기간|종료일자", 		Type:"Date",   	 Hidden:0, Width:90,  Align:"Center", SaveName:"edate",		KeyField:1,	Format:"Ymd",	UpdateEdit:1, InsertEdit:1, StartDateCol:"sdate" },
			{Header:"비고|비고",				Type:"Text", 	 Hidden:0, Width:200, Align:"Left",   SaveName:"note", 		KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일|첨부파일'/>",			Type:"Html",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },

			//Hidden
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }


		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		
		$(window).smartresize(sheetResize); sheetInit();

	}

	function chkInVal() {
		// 시작일자와 종료일자 체크
		for (var i = sheet1.HeaderRows() ; i < sheet1.HeaderRows() + sheet1.RowCount() ; i++) {
			if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
				if (sheet1.GetCellValue(i, "edate") != null && sheet1.GetCellValue(i, "edate") != "") {
					var sdate = sheet1.GetCellValue(i, "sdate");
					var edate = sheet1.GetCellValue(i, "edate");
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet1.SelectCell(i, "edate");
						return false;
					}
				}
			}
		}
		return true;
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
				var sXml = sheet1.GetSearchData("${ctx}/YearEduStd.do?cmd=getYearEduStdList", $("#sheet1Form").serialize() );
				sheet1.LoadSearchData(sXml );
				break;
			case "Save":
				if(!chkInVal()){break;}
				result = sheet1.ColValueDup("year",{"IncludeDelRow" : 0});
		  		if(result>0){
		  		    alert("중복된 기준년도가 존재합니다");
		  		    sheet1.SetSelectRow(result);
		  		  	break;
		  	 	}
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/YearEduStd.do?cmd=saveYearEduStd", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet1.DataInsert(0);
				sheet1.SelectCell(row, "year");
				sheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				break;
			case "Copy":
				var row = sheet1.DataCopy();
				sheet1.SetCellValue(row, "year", "");
				sheet1.SetCellValue(tempSelectRow, "fileSeq", "");
				sheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				sheet1.SelectCell(row, "year");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			//파일 첨부 시작
			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				if("${authPg}" == 'A'){
					if(sheet1.GetCellValue(r,"fileSeq") == ''){
						sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						sheet1.SetCellValue(r, "sStatus", 'R');
					}else{
						sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(r, "sStatus", 'R');
					}
				}else{
					if(sheet1.GetCellValue(r,"fileSeq") != ''){
						sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(r, "sStatus", 'R');
					}
				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//파일 신청 시작
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "btnFile"){
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup";

					fileMgrPopup(Row, Col);
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	//파일 신청 끝

	// 파일첨부/다운로드 팝업
	function fileMgrPopup(Row, Col) {
		let layerModal = new window.top.document.LayerModal({
			id : 'fileMgrLayer'
			, url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&uploadType=eduCourse&authPg=${authPg}'
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
							sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic">다운로드</a>');
							sheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
						}else{
							sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic">첨부</a>');
							sheet1.SetCellValue(gPRow, "fileSeq", "");
						}
					}
				}
			]
		});
		layerModal.show();
	}
	//파일 팝업 끝

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀 선택시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
	    } catch (ex) { alert("OnSelectCell Event Error " + ex); }
	}
	
	function getFileUploadEnd(){
		sheet1.SetCellValue(gPRow,"fileSeq",    $("#uploadForm>#fileSeq").val());
	}
	
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form name="sheet1Form" id="sheet1Form" method="post"></form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">연간교육계획기준관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
				<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
				<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>
