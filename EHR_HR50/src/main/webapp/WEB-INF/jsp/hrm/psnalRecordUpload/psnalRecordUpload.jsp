<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='112882' mdef='인사기록사항관리(업로드)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">
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

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='ccrYmd' mdef='면담일자'/>",	Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"ccrYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ccrCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='memo_V1777' mdef='내용(줄바꿈 Shift+Enter)'/>",		Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:330, MultiLineText:1, ToolTip:1},
			{Header:"<sht:txt mid='adviserSabun' mdef='면담자사번'/>",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adviserSabun",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='adviser' mdef='면담자'/>",		Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"adviser",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",	Type:"Html",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='reqYmd' mdef='입력일자'/>",	Type:"Text",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='chkNm' mdef='입력자'/>",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"chkNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		getCommonCodeList();
		$("#fromSdate").datepicker2({startdate:"toSdate", onReturn: getCommonCodeList});
		$("#toSdate").datepicker2({enddate:"fromSdate", onReturn: getCommonCodeList});
// 		$("#fromSdate").val("${curSysYyyyMMHyphen}-01") ;
// 		$("#toSdate").val("${curSysYyyyMMHyphen}-31") ;
        $("#searchSaNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search") ;

		// 성명, 면담자 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",	rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",	rv["orgNm"]);
					}
				},
				{
					ColSaveName  : "adviser",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "adviser",	rv["name"]);
						sheet1.SetCellValue(gPRow, "adviserSabun",	rv["sabun"]);
					}
				}
			]
		});		

	});

	function getCommonCodeList() {
		let baseSYmd = $("#fromSdate").val();
		let baseEYmd = $("#toSdate").val();
		const userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90009", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("ccrCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		$("#searchGntCd").html(userCd1[2]);
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
			sheet1.DoSearch( "${ctx}/PsnalRecordUpload.do?cmd=getPsnalRecordUploadList",$("#sheet1Form").serialize() );
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
			break;
		case "Save":
// 			if(!dupChk(sheet1,"sabun|gntCd|applYmd", true, true)){break;}
			setFileListArr('sheet1');
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PsnalRecordUpload.do?cmd=savePsnalRecordUpload" ,$("#sheet1Form").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row, "chkdate", "");
			sheet1.SetCellValue(row, "chkNm",	"");
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({
					TitleText:"*기록사항자료업로드"
						+ "\n*필수입력항목 : 면담일자, 구분(면담/특이사항/기타), 사번"
						+ "\n*[면담자] 필드는 필히 해당 면담자 사번을 등록바랍니다."
						+ "\n*파일로드시에는 이 행을 삭제해야 합니다."
					, SheetDesign:1,Merge:1,DownRows:0,DownCols:"ccrYmd|ccrCd|sabun|memo|adviserSabun|adviser"});
			break;
		case "LoadExcel":
/* 			if($("#searchGntCd").val() == ""){
				alert("<msg:txt mid='109722' mdef='구분을 선택해주세요.'/>");
				break;
			}
			sheet1.RemoveAll(); */
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	function sheet1_OnLoadExcel() {

		for(var i = 1; i < sheet1.LastRow()+1; i++) {
			if(sheet1.GetCellValue(i,"ccrCd") == "") {
				sheet1.SetCellValue(i, "ccrCd", $("#searchGntCd").val()) ;
			}
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
				if("${authPg}" == 'A'){
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

	function sheet1_OnChange(Row, Col, Value) {
		try{
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	var gPRow = "";
    var pGubun = "";
	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name" || sheet1.ColSaveName(Col) == "adviser") {
				if(!isPopup()) {return;}

				if(sheet1.ColSaveName(Col) == "adviser"){
					pGubun = "adviser";
				}else{
					pGubun = "name";
				}
				gPRow = Row;
	            var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "840","520");
	            if(rst != null){
// 	                sheet1.SetCellValue(Row, "sabun",		rst["sabun"]);
// 	                sheet1.SetCellValue(Row, "name",		rst["name"]);
// 					sheet1.SetCellValue(Row, "orgCd",		rst["orgCd"]);
// 		        	sheet1.SetCellValue(Row, "orgNm",		rst["orgNm"]);
	            }
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "fileMgr") {
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110698' mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		}else if( pGubun == "adviser" ){
	        sheet1.SetCellValue(gPRow, "adviser",   rv["name"] );
	        sheet1.SetCellValue(gPRow, "adviserSabun",   rv["sabun"] );
		}else if( pGubun == "name" ){
            sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
            sheet1.SetCellValue(gPRow, "name",		rv["name"] );
            sheet1.SetCellValue(gPRow, "alias",		rv["alias"] );
            sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
        }
	}

	//파일 신청 시작
	function sheet1_OnClick(Row, Col, Value) {
		try{
			gPRow = Row;
			if(sheet1.ColSaveName(Col) == "btnFile"	&& Row >= sheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					pGubun = "fileMgr";
					if(!isPopup()) {return;}

					var authPgTemp="${authPg}";
					fileMgrPopup(Row, Col);
					// openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=ccr", param, "740","620");
				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	// 파일첨부/다운로드 팝입
	function fileMgrPopup(Row, Col) {
		var authPgTemp="${authPg}";
		let layerModal = new window.top.document.LayerModal({
			id : 'fileMgrLayer'
			, url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&authPg=${authPg}'
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
							sheet1.SetCellValue(gPRow, "btnFile", '<a class="btn outline_gray thinner">다운로드</a>');
							sheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
						}else{
							sheet1.SetCellValue(gPRow, "btnFile", '<a class="btn outline_gray thinner">첨부</a>');
							sheet1.SetCellValue(gPRow, "fileSeq", "");
						}
					}
				}
			]
		});
		layerModal.show();
	}
	//파일 신청 끝
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='103997' mdef='구분'/></th>
			<td>
				<select id="searchGntCd" name="searchGntCd" onChange="doAction1('Search')"></select>
			</td>
			<th><tit:txt mid='112528' mdef='면담일자'/></th>
			<td colspan="2">  <input type="text" id="fromSdate" name="fromSdate" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-365)%>" /> ~
			<input type="text" id="toSdate" name="toSdate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/> </td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchSaNm" name="searchSaNm" type="text" class="text"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='112882' mdef='인사기록사항관리(업로드)'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline_gray authR" mid='110702' mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline_gray authR" mid='110703' mdef="업로드"/>
				<btn:a href="javascript:doAction1('Insert');" 		css="btn outline_gray authA" mid='110700' mdef="입력"/>
<!-- 				<btn:a href="javascript:doAction1('Copy');" 		css="basic authA" mid='110696' mdef="복사"/> -->
				<btn:a href="javascript:doAction1('Save');" 		css="btn filled authA" mid='110708' mdef="저장"/>
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
