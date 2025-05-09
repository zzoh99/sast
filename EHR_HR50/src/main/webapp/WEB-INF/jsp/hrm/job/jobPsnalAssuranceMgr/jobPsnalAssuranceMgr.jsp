<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104038' mdef='인사기본(보증)'/></title>
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

		$("#searchStdDate").datepicker2();
		$("#searchStdDate,#searchSabunNameAlias").keypressEnter(function(){
			doAction1("Search");
		});
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",      Type:"Text",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"orgNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",      Type:"Text",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikchakNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",      Type:"Popup",   Hidden:0,   Width:60,  Align:"Center",   ColMerge:0, SaveName:"name",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",      Type:"Text",   Hidden:Number("${aliasHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"alias",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",      Type:"Text",   Hidden:Number("${jgHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikgubNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",      Type:"Text",   Hidden:Number("${jwHdn}"),   Width:60,  Align:"Center",   ColMerge:0, SaveName:"jikweeNm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:20 },
			{Header:"<sht:txt mid='type_V2671' mdef='보증타입'/>",   Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"type",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='warrantyCd' mdef='보험회사'/>",   Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"warrantyCd",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='warrantyNo' mdef='증권번호'/>",   Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"warrantyNo",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
			{Header:"<sht:txt mid='warrantySYmd' mdef='보증기간\n시작일'/>",  	Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"warrantySYmd",	KeyField:1,	Format:"Ymd",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='warrantyEYmd' mdef='보증기간\n종료일'/>",  	Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"warrantyEYmd",	KeyField:0,	Format:"Ymd",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='currencyCd' mdef='통화단위'/>",   Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"currencyCd",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='warrantyMon_V1' mdef='보증금액'/>",   Type:"Int",		Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"warrantyMon",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='jobGbnCd' mdef='보증구분'/>",   Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobGbnCd",		KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",     	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",	Type:"Html",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);

		sheet1.SetMergeSheet( msHeaderOnly);
		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20380"), "");

		sheet1.SetColProperty("warrantyCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );

		var userCd2 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H60140"), "");

		var currencyCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S10030"), "");

		sheet1.SetColProperty("jobGbnCd", 		{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
		sheet1.SetColProperty("currencyCd", 		{ComboText:"|"+currencyCd[0], ComboCode:"|"+currencyCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});
	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
			sheet1.DoSearch( "${ctx}/JobPsnalAssuranceMgr.do?cmd=getJobPsnalAssuranceMgrList",  $("#sheet1Form").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|warrantySYmd", true, true)){break;}
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/JobPsnalAssuranceMgr.do?cmd=saveJobPsnalAssuranceMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			//sheet1.SetCellValue(row,"type","1");
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "DownTemplate":
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|warrantySYmd|warrantyEYmd|warrantyCd|warrantyNo|currencyCd|warrantyMon|jobGbnCd|note"});
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1,ExtendParam:"type=1"};
			sheet1.LoadExcel(params);
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1('Search');
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name"){			//사원검색
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "employeePopup1";

				let layerModal = new window.top.document.LayerModal({
					id : 'employeeLayer'
					, url : '/Popup.do?cmd=viewEmployeeLayer'
					, parameters : {}
					, width : 840
					, height : 520
					, title : '사원조회'
					, trigger :[
						{
							name : 'employeeTrigger'
							, callback : function(result){
								getReturnValue(result);
							}
						}
					]
				});
				layerModal.show();
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//파일 신청 시작
	function sheet1_OnClick(Row, Col, Value) {
		try{

			if(sheet1.ColSaveName(Col) == "btnFile"){
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup1";

					let layerModal = new window.top.document.LayerModal({
						id : 'fileMgrLayer'
						, url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&uploadType=assurance&authPg=${authPg}'
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
									getReturnValue(result);
								}
							}
						]
					});
					layerModal.show();
				}

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	//파일 신청 끝

	//팝업 콜백 함수.
	function getReturnValue(rv) {
		if(pGubun == "fileMgrPopup1") {
			addFileList(sheet1, gPRow, rv); // 작업한 파일 목록 업데이트
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		} else if (pGubun == "employeePopup1"){
        	sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
        	sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
        	sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
        	sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
        	sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
        	sheet1.SetCellValue(gPRow, "name", rv["name"]);
        	sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
		}
	}
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form">
<div class="wrapper">
	<input id="type" name="type" type="hidden"/>
	<input id="sType" name="sType" type="hidden" value="1"/>
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}"/>
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='103906' mdef='기준일자 '/></th>
			<td>
				 <input id="searchStdDate" name="searchStdDate" size="10" type="text" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>" />
			</td>
			<th><tit:txt mid='112277' mdef='사번/성명 '/></th>
			<td>
				 <input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
		</div>
	</div>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='104329' mdef='보증보험'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="basic authA" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='110708' mdef="저장"/>
				<btn:a href="javascript:doAction1('DownTemplate')" 	css="basic authR" mid='110702' mdef="양식다운로드"/>
				<btn:a href="javascript:doAction1('LoadExcel')" 	css="basic authR" mid='110703' mdef="업로드"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</form>
</body>
</html>
