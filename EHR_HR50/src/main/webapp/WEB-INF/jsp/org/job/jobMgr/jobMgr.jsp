<%@ page language="java" contentType="text/html; charset=UTF-8"
		 pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<script src="/assets/js/utility-script.js?ver=7"></script>
	<script type="text/javascript">
		var gPRow = "";
		var pGubun = "";

		$(function() {
			$("#searchSdate").datepicker2({
				onReturn: function () {
					var jobType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30010", $("#searchSdate").val()), "선택");	//직무형태
					$("#searchJobType").html(jobType[2]);
				}
			});

			var initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msNone};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",    Type:"DummyCheck",  Hidden:0,                   Width:30,           Align:"Center", ColMerge:0, SaveName:"ibsCheck", PointCount:0,  UpdateEdit:1,  InsertEdit:1,  EditLen:1   },
				{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"<sht:txt mid='temp2' mdef='세부\n내역'/>",		Type:"Image",     Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
				{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",		Type:"Text",      Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jobCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='jobNmV2' mdef='직무명'/>",			Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    	ColMerge:0,   SaveName:"jobNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='languageCd' mdef='어휘코드'/>",			Type:"Text",	Hidden:1,	Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
				{Header:"<sht:txt mid='languageNm' mdef='어휘코드명'/>",		Type:"Popup",	Hidden:Number("${sLanHdn}"),Width:"${sLanWdt}",Align:"Center",	ColMerge:0,	SaveName:"languageNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
				{Header:"<sht:txt mid='jobEngNm' mdef='직무명(영문)'/>", 	Type:"Text",      Hidden:1,  Width:150,  Align:"Left",    	ColMerge:0,   SaveName:"jobEngNm",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='jobType' mdef='직무형태'/>",		Type:"Combo",     Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jobType",       KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='memoV8' mdef='직무목표'/>",		Type:"Text",      Hidden:1,  Width:0,  	 Align:"Left",    	ColMerge:0,   SaveName:"memo",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
				{Header:"<sht:txt mid='jobDefine' mdef='직무정의'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"jobDefine",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
				{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edate' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='jikgubReq' mdef='직급요건'/>",  		Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jikgubReq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='academyReq' mdef='학력요건'/>", 		Type:"Combo",     Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"academyReq",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='majorReq' mdef='전공요건'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"majorReq",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='careerReq' mdef='경력요건'/>",  		Type:"Combo",     Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"careerReq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='otherJobReq' mdef='경력요건(타직무)'/>", Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"otherJobReq",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='note' mdef='비고'/>",  			Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"note",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
				{Header:"<sht:txt mid='seqV2' mdef='순서'/>", 			Type:"Int",  	  Hidden:1,  Width:30,   Align:"Center",  	ColMerge:1,   SaveName:"seq",     		KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:3 },

				{Header:"<sht:txt mid='majorReq2' mdef='전공요건2'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"majorReq2",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='majorNeed' mdef='전공필수여부'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"majorNeed",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='majorNeed2' mdef='전공필수여부2'/>", 	Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"majorNeed2",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
				{Header:"<sht:txt mid='rk' mdef='rk'/>",                        Type:"Text",      Hidden:1,  Width:0,    Align:"Left",      ColMerge:0,   SaveName:"rk",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }

			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
			sheet1.SetMergeSheet(msAll);

			var jobType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30010", $("#searchSdate").val()), "선택");	//직무형태
			$("#searchJobType").html(jobType[2]);

			$("#searchJobCd,#searchJobNm,#searchSdate").bind("keyup",function(event){
				if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
			});

			$("#searchJobType").bind("change", function() {
				doAction1("Search");
			});

			$(window).smartresize(sheetResize); sheetInit();
			doAction1("Search");
		});

		function getCommonCodeList() {
			var jobType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30010", $("#searchSdate").val()), "선택");	//직무형태
			var jikgubReq 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30019", $("#searchSdate").val()), "");	//직급요건
			var academyReq 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30018", $("#searchSdate").val()), "");	//학력요건
			var careerReq 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30020", $("#searchSdate").val()), "");	//경력요건


			sheet1.SetColProperty("jobType", 			{ComboText:"|"+jobType[0], ComboCode:"|"+jobType[1]} );	//직무형태
			sheet1.SetColProperty("jikgubReq", 			{ComboText:"|"+jikgubReq[0], ComboCode:"|"+jikgubReq[1]} );	//직급요건
			sheet1.SetColProperty("academyReq", 		{ComboText:"|"+academyReq[0], ComboCode:"|"+academyReq[1]} );	//학력요건
			sheet1.SetColProperty("careerReq", 			{ComboText:"|"+careerReq[0], ComboCode:"|"+careerReq[1]} );	//경력요건
		}

		//Sheet1 Action
		function doAction1(sAction) {
			switch (sAction) {
				case "Search":
					getCommonCodeList();
					sheet1.DoSearch( "${ctx}/JobMgr.do?cmd=getJobMgrList", $("#srchFrm").serialize() );
					sheet1.SetMergeSheet(msAll);
					break;
				case "Save":
					IBS_SaveName(document.srchFrm,sheet1);
					sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveJobMgr", $("#srchFrm").serialize() ); break;
				case "Insert":		var Row = sheet1.DataInsert(0);
					sheet1.SetCellValue(Row, "sdate", "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>");
					//sheet1.SetCellValue(Row, "edate", "99991231");
					sheet1.SelectCell(Row, "jobCd");
					break;
				case "Copy":
					var Row = sheet1.DataCopy();
					sheet1.SetCellValue(Row, "languageCd", "");
					sheet1.SetCellValue(Row, "languageNm", "");
					break;
				case "Clear":
					sheet1.RemoveAll();
					break;
				case "Down2Excel":
					sheet1.Down2Excel();
					break;
				case "LoadExcel":
					var params = {
						Mode : "HeaderMatch",
						WorkSheetNo : 1
					};
					sheet1.LoadExcel(params);
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
			} catch (ex) {
				alert("OnSaveEnd Event Error " + ex);
			}
		}

		function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
			try {
				if (Row > 0 && sheet1.ColSaveName(Col) == "detail") {
					jobMgrPopup(Row);
				}
			} catch (ex) {
				alert("OnClick Event Error : " + ex);
			}
		}

		/**
		 * 상세내역 window open event
		 */
		function jobMgrPopup(Row) {
			if (!isPopup()) {
				return;
			}

			var w = 1000;
			var h = 720;
			var url = "/Popup.do?cmd=viewJobMgrLayer&authPg=${authPg}";
			<%--var url = "${ctx}/JobMgr.do?cmd=viewJobMgrPopup&authPg=${authPg}";--%>
			var p = {
				jobCd : sheet1.GetCellValue(Row, "jobCd"),
				jobNm : sheet1.GetCellValue(Row, "jobNm"),
				jobEngNm : sheet1.GetCellValue(Row, "jobEngNm"),
				jobType : sheet1.GetCellValue(Row, "jobType"),
				memo : sheet1.GetCellValue(Row, "memo"),
				jobDefine : sheet1.GetCellValue(Row, "jobDefine"),
				sdate : sheet1.GetCellText(Row, "sdate"),
				edate : sheet1.GetCellText(Row, "edate"),
				academyReq : sheet1.GetCellValue(Row, "academyReq"),
				majorReq : sheet1.GetCellValue(Row, "majorReq"),
				careerReq : sheet1.GetCellValue(Row, "careerReq"),
				otherJobReq : sheet1.GetCellValue(Row, "otherJobReq"),
				note : sheet1.GetCellValue(Row, "note"),
				seq : sheet1.GetCellValue(Row, "seq"),
				majorReq2 : sheet1.GetCellValue(Row, "majorReq2"),
				majorNeed : sheet1.GetCellValue(Row, "majorNeed"),
				majorNeed2 : sheet1.GetCellValue(Row, "majorNeed2")
			}

			gPRow = Row;
			pGubun = "jobMgrPopup";
			// openPopup(url, args, w, h);

			var jobMgrLayer = new window.top.document.LayerModal({
				id: 'jobMgrLayer',
				url: url,
				parameters: p,
				width: w,
				height: h,
				title: '직무기술서',
				trigger: [
					{
						name: 'jobMgrLayerTrigger',
						callback: function(rv) {
							getReturnValue(rv);
						}
					}
				]
			});

			jobMgrLayer.show();
		}

		//팝업 콜백 함수.
		function getReturnValue(rv) {
			// var rv = $.parseJSON('{' + returnValue + '}');

			if (pGubun == "jobMgrPopup") {
				sheet1.SetCellValue(gPRow, "jobCd", rv["jobCd"]);
				sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"]);
				sheet1.SetCellValue(gPRow, "jobEngNm", rv["jobEngNm"]);
				sheet1.SetCellValue(gPRow, "jobType", rv["jobType"]);
				sheet1.SetCellValue(gPRow, "memo", rv["memo"]);
				sheet1.SetCellValue(gPRow, "jobDefine", rv["jobDefine"]);
				sheet1.SetCellValue(gPRow, "sdate", rv["sdate"]);
				sheet1.SetCellValue(gPRow, "edate", rv["edate"]);
				sheet1.SetCellValue(gPRow, "academyReq", rv["academyReq"]);
				sheet1.SetCellValue(gPRow, "majorReq", rv["majorReq"]);
				sheet1.SetCellValue(gPRow, "careerReq", rv["careerReq"]);
				sheet1.SetCellValue(gPRow, "otherJobReq", rv["otherJobReq"]);
				sheet1.SetCellValue(gPRow, "note", rv["note"]);
				sheet1.SetCellValue(gPRow, "seq", rv["seq"]);
				sheet1.SetCellValue(gPRow, "majorReq2", rv["majorReq2"]);
				sheet1.SetCellValue(gPRow, "majorNeed", rv["majorNeed"]);
				sheet1.SetCellValue(gPRow, "majorNeed2", rv["majorNeed2"]);
			}
		}

		function sheet1_OnPopupClick(Row, Col) {
			try {
				if (sheet1.ColSaveName(Col) == "languageNm") {
					lanuagePopup(Row, "sheet1", "torg201", "languageCd",
							"languageNm", "jobNm");
				}
			} catch (ex) {
				alert("OnPopupClick Event Error : " + ex);
			}
		}

		// RD 출력 함수
		function print(){
			var jobcds = "";
			var jobcdSdates = "";
			var stamps = "";
			var sdates = "";
			if(sheet1.RowCount() != 0) {
				for(i=1; i<=sheet1.LastRow(); i++) {
					var chk = sheet1.GetCellValue(i, "ibsCheck");
					if (chk == "1") {
						jobcds += "'"+sheet1.GetCellValue( i, "jobCd" ) + "',";
						sdates += "'"+sheet1.GetCellValue( i, "sdate" ) + "',";

						jobcdSdates += "'"+sheet1.GetCellValue( i, "jobCd" ) + "|"+sheet1.GetCellValue( i, "sdate" ) +"',";
					}
				}


				if (jobcds.length > 1) {
					jobcds = jobcds.substr(0,jobcds.length-1);
					sdates = sdates.substr(0,sdates.length-1);
					jobcdSdates = jobcdSdates.substr(0,jobcdSdates.length-1);
				}
			}

			if (jobcds.length < 1) {
				alert("선택된 직무가 없습니다.");
				return;
			}

			var checkedRowsCount = sheet1.CheckedRows('ibsCheck');

			showRd(jobcdSdates);
		}


		function showRd(jobcdSdates){


			let parameters = Utils.encase('${ssnEnterCd}') + ' ';
			parameters += Utils.encase(jobcdSdates) + ' ';
			parameters += Utils.encase('${imageBaseUrl}') + ' ';

			//출력 대상자 rk 추출
			let rkList = [];
			let checkedRows = sheet1.FindCheckedRow('ibsCheck');
			$(checkedRows.split("|")).each(function(index,value){
				rkList[index] = sheet1.GetCellValue(value, 'rk');
			});

			const data = {
				rk : rkList
			};

			window.top.showRdLayer('/JobMgr.do?cmd=getEncryptRd', data, null, '직무기술서');

		}
	</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113239' mdef='직무코드 ' /></th>
						<td> <input
								id="searchJobCd" name="searchJobCd" type="text" class="text" />
						</td>
						<th><tit:txt mid='114292' mdef='직무명 ' /></th>
						<td><input
								id="searchJobNm" name="searchJobNm" type="text" class="text" />
						</td>
						<th><tit:txt mid='103906' mdef='기준일자 ' /></th>
						<td><input
								id="searchSdate" name="searchSdate" type="text" size="10"
								class="date2"
								value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>" />
						</td>
						<th><tit:txt mid='112523' mdef='직무형태 ' /></th>
						<td><select
								id="searchJobType" name="searchJobType"></select>
						</td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회" /></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='jobMgr' mdef='직무기술서' /></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" css="btn outline-gray authR" mid='down2excel' mdef="다운로드" />
								<btn:a href="javascript:print();" css="btn outline-gray authA" mid='print' id="print" mdef="출력"/>
								<btn:a href="javascript:doAction1('Copy')" css="btn outline-gray authA" mid='copy' mdef="복사" />
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력" />
								<btn:a href="javascript:doAction1('Save')" css="btn filled authA" mid='save' mdef="저장" />
							</li>
						</ul>
					</div>
				</div> <script type="text/javascript">
				createIBSheet("sheet1", "100%", "100%",
						"${ssnLocaleCd}");
			</script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>