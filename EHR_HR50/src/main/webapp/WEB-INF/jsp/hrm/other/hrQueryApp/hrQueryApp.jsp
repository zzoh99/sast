<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var applCd		= null;
	$(function() {
		$("#searchFromYmd").datepicker2({startdate:"searchToYmd", onReturn: getGubun});
		$("#searchToYmd").datepicker2({enddate:"searchFromYmd", onReturn: getGubun});

		var initdata = {};
		initdata.Cfg = {FrozenCol:5, SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",      	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",    	Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",    	Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",			Type:"Image",	Hidden:0,	Width:40,		Align:"Center",	ColMerge:0,	SaveName:"detail",		Sort:0, Cursor:"Pointer" },
			{Header:"<sht:txt mid='applStatusCd_V4976' mdef='접수현황'/>",			Type:"Combo",	Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",			Type:"Combo",	Hidden:0,	Width:100,		Align:"Center",	ColMerge:0,	SaveName:"gubun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='applYmdV5' mdef='신청일'/>",			Type:"Date",	Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"reqDate",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='attatchSymdV1' mdef='접수일'/>",			Type:"Date",	Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"revDate",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='revEmpAlias' mdef='접수자'/>",			Type:"Text",	Hidden:0,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"revEmpAlias",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='processData' mdef='처리결과'/>",			Type:"Text",	Hidden:0,	Width:200,		Align:"Left",	ColMerge:0,	SaveName:"processData",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='apApplSeqV2' mdef='신청서순번'/>",		Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applSeq",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV2' mdef='신청입력자사번'/>",		Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applInSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV1' mdef='신청자사번'/>",		Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applCd' mdef='신청서코드'/>",		Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applYmdV5' mdef='신청일'/>",			Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applYmd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");

		getGubun();

		$("#searchGubun").change(function(){
			doAction1("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		setEmpPage();
	});

	function getGubun() {
		let baseSYmd = $("#searchFromYmd").val();
		let baseEYmd = $("#searchToYmd").val();

		const gubunList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y", "B10800", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");		//구분
		$("#searchGubun").html(gubunList[2]);
	}

	function getCommonCodeList() {
		let baseSYmd = $("#searchFromYmd").val();
		let baseEYmd = $("#searchToYmd").val();

		const gubunList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","B10800", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");		//구분
		sheet1.SetColProperty("gubun", 			{ComboText:gubunList[0], ComboCode:gubunList[1]} );

		const applStatusCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010", baseSYmd, baseEYmd), "");		//구분
		sheet1.SetColProperty("applStatusCd", 			{ComboText:applStatusCdList[0], ComboCode:applStatusCdList[1]} );
	}

	function setEmpPage() {
		$("#searchApplSabun").val($("#searchUserId").val());
		doAction1("Search");
	}
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			getCommonCodeList();
			sheet1.DoSearch( "${ctx}/HrQueryApp.do?cmd=getHrQueryAppList", $("#sheetForm").serialize() ); break;
		case "Save":
			if(sheet1.FindStatusRow("I|U") != ""){
			    if(!dupChk(sheet1,"sabun|applSeq", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/HrQueryApp.do?cmd=saveHrQueryApp", $("#sheetForm").serialize() );  break;
		case "Copy":      	sheet1.DataCopy();	break;
		case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), 2); break;
		case "Down2Excel":	sheet1.Down2Excel({Merge:1}); break;
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
		try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	//신청 팝업
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
		var url = "";
		var initFunc = '';
		if(auth == "A") {
			url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
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
			title: '개인고충',
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

// 	function showApplPopup(auth,seq,applInSabun,applYmd) {
// 		if(auth == "") {
// 			alert("<msg:txt mid='alertInputAuth' mdef='권한을 입력하여 주십시오.'/>");
// 			return;
// 		}

// 		var param = "searchApplCd=100"
// 					+"&searchApplSeq="+seq
// 					+"&adminYn=N"
// 					+"&authPg="+auth
// 					+"&searchApplSabun="+$("#searchUserId").val()
// 					+"&searchSabun="+applInSabun
// 					+"&searchApplYmd="+applYmd;
// 		var url = "";
// 			url ="/ApprovalMgr.do?cmd=viewApprovalMgr&"+param;
// 		var result = openPopup(url,"",900,600);
// 		doAction1("Search");
// 	}

	//신청 임시저장 팝업
	function showApplPopup2(auth,seq,applCd,applSabun,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		var statusCd = sheet1.GetCellValue(sheet1.GetSelectRow(), "applStatusCd");
		if(statusCd == "11") { auth = "A";}
		var p = {
				searchApplCd: applCd
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd 
			};

		var url = '';
		var initFunc = '';
		if(statusCd == "11") {
			url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
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
<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input id="searchApplSabun" name="searchApplSabun" value="" type="hidden"/>
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th>신청일자</th>
					<td>
						<input id="searchFromYmd" 	name="searchFromYmd" type="text" size="10" class="date2" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-365)%>"/> ~
						<input id="searchToYmd" 	name="searchToYmd" type="text" size="10" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/>
					</td>
					<th><tit:txt mid='103997' mdef='구분'/></th>
					<td>
						<select id="searchGubun" name="searchGubun">
						</select>
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
							<li class="txt"><tit:txt mid='112116' mdef='HR문의요청 '/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Save')" 	css="btn soft authR" mid='110708' mdef="저장"/>
								<btn:a href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}');" css="btn filled" mid='110819' mdef="신청"/>
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
