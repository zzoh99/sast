<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var applCd		= null;
	$(function() {

		$("#searchFromYmd").datepicker2({startdate:"searchToYmd", onReturn: getCommonCodeList});
		$("#searchToYmd").datepicker2({enddate:"searchFromYmd", onReturn: getCommonCodeList});

		var initdata = {};
		initdata.Cfg = {FrozenCol:6, FrozenColRight:7, SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",      	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",    	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",    	Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",			Type:"Image",	Hidden:0,	Width:50,		Align:"Center",	ColMerge:0,	SaveName:"detail",		Sort:0, Cursor:"Pointer" },
			{Header:"<sht:txt mid='applYmdV5' mdef='신청일'/>",			Type:"Date",	Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"reqDate",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",			Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Popup",	Hidden:0,	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			    Type:"Text",	Hidden:0,	Width:80,		Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",	Hidden:Number("${jwHdn}"),	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",	Hidden:Number("${jgHdn}"),	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Text",	Hidden:1,	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",			Type:"Date",	Hidden:1,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='workYmCntV1' mdef='근속기간'/>",			Type:"Text",	Hidden:1,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"workPeriod",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applStatusCd_V4976' mdef='결재상태'/>",			Type:"Combo",	Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",			Type:"Combo",	Hidden:0,	Width:150,		Align:"Center",	ColMerge:0,	SaveName:"gubun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='attatchSymdV1' mdef='접수일'/>",			Type:"Date",	Hidden:0,	Width:100,		Align:"Center",	ColMerge:0,	SaveName:"revDate",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='revEmpAlias' mdef='접수자'/>",			Type:"Text",	Hidden:0,	Width:80,		Align:"Center",	ColMerge:0,	SaveName:"revEmpAlias",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='processData' mdef='처리결과'/>",			Type:"Text",	Hidden:0,	Width:170,		Align:"Center",	ColMerge:0,	SaveName:"processData",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='apApplSeqV2' mdef='신청서순번'/>",		Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applSeq",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV2' mdef='신청입력자사번'/>",		Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applInSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV1' mdef='신청자사번'/>",		Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applCd' mdef='신청서코드'/>",		Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");

		getCommonCodeList();

		$("#searchGubun, #searchApplStatusCd").change(function(){
			doAction1("Search");
		});

		$("#searchOrgNm, #searchSabunName").on("keyup", function(e) {
			if(e.keyCode == 13) {
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
// 		setEmpPage();
	});

	function getSheetCommonCodeList() {
		let baseSYmd = $("#searchFromYmd").val();
		let baseEYmd = $("#searchToYmd").val();

		const gubunList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B10800", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");		//구분
		sheet1.SetColProperty("gubun", 			{ComboText:gubunList[0], ComboCode:gubunList[1]} );

		const applStatusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");		//구분
		sheet1.SetColProperty("applStatusCd", 			{ComboText:applStatusCdList[0], ComboCode:applStatusCdList[1]} );
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchFromYmd").val();
		let baseEYmd = $("#searchToYmd").val();

		var gubunList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","B10800", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");		//구분
		$("#searchGubun").html(gubunList[2]);

		var applStatusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");		//구분
		$("#searchApplStatusCd").html(applStatusCdList[2]);
	}

	function setEmpPage() {
// 		$("#searchApplSabun").val($("#searchUserId").val());
		doAction1("Search");
	}
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			getSheetCommonCodeList();
			sheet1.DoSearch( "${ctx}/HrQueryApr.do?cmd=getHrQueryAprList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(sheet1.FindStatusRow("I|U") != ""){
			    if(!dupChk(sheet1,"sabun|applSeq", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/HrQueryApr.do?cmd=saveHrQueryApr" , $("#sheetForm").serialize());  break;
		case "Copy":      	sheet1.DataCopy();	break;
		case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), 2); break;
		case "Down2Excel":
							var downcol = makeHiddenSkipCol(sheet1);
							var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
							sheet1.Down2Excel(param);
				
							break;		case "Down2Excel":	sheet1.Down2Excel({Merge:1}); break;
		}
	}


	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(Row<1) return;
			if( sheet1.ColSaveName(Col) == "detail" ) {
				if(sheet1.GetCellImage(Row,"detail")!= ""){

					var applSeq		= sheet1.GetCellValue(Row,"applSeq");
					var applSabun 	= sheet1.GetCellValue(Row,"applSabun");
					var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
					var applCd 		= sheet1.GetCellValue(Row,"applCd");
					var applYmd 	= sheet1.GetCellValue(Row,"reqDate");

					showApplPopup2("R",applSeq,applCd,applSabun,applInSabun,applYmd);
				}
			}
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg);}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function showApplPopup(auth,seq,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("<msg:txt mid='alertInputAuth' mdef='권한을 입력하여 주십시오.'/>");
			return;
		}

		var p = {
				searchApplCd: '100'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			};

		var url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
		var initFunc = 'initLayer';
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: 'HR문의요청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}

	//신청 임시저장 팝업
	function showApplPopup2(auth,seq,applCd,applSabun,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		var statusCd = sheet1.GetCellValue(sheet1.GetSelectRow(), "applStatusCd");
		if(statusCd == "11") { auth = "A";}
		var p = {
				searchApplCd: applCd
			  , searchApplSeq: seq
			  , adminYn: 'Y'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd 
			};
		
		if(statusCd == "11") {
			url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: 'HR문의요청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}

	function sheet1_OnBeforeCheck(Row, Col) {
		try{
			sheet1.SetAllowCheck(true);
			if(sheet1.ColSaveName(Col) == "sDelete") {
				if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
					alert("<msg:txt mid='alertAppDelChk' mdef='임시저장일 경우만 삭제할 수 있습니다.'/>");
					sheet1.SetAllowCheck(false);
					return;
				}
			}
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(rv) {
		doAction1("Search");
	}


</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input id="searchApplSabun" name="searchApplSabun" value="" type="hidden"/>
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th>신청일</th>
					<td>
						<input id="searchFromYmd" 	name="searchFromYmd" type="text" size="10" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-365)%>"/> ~
						<input id="searchToYmd" 	name="searchToYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
					</td>
					<th><tit:txt mid='103997' mdef='구분'/></th>
					<td>
						<select id="searchGubun" name="searchGubun">
						</select>
					</td>
				</tr>
				<tr>
					<th>결재상태</th>
					<td>
						<select id="searchApplStatusCd" name="searchApplStatusCd" class="text">
						</select>					
					</td>					
					<th>소속</th>
					<td>
						<input type="text" id="searchOrgNm" name="searchOrgNm" class="text" value="" />	
					</td>				
					<th>사번/성명</th>
					<td>
						<input type="text" id="searchSabunName" name="searchSabunName" class="text" value="" />
					</td>			
					<td>
						<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
					</td>
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
							<li class="txt"><tit:txt mid='112810' mdef='HR문의접수 '/></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel');" class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<btn:a href="javascript:doAction1('Save');" css="btn filled" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
