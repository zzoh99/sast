<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='104198' mdef='모든문서'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		//var applCdList	= convCodeIdx( ajaxCall("${ctx}/AppAfterLst.do?cmd=getAppAfterLstApplCdList","",false).DATA, "<tit:txt mid='103895' mdef='전체'/>",-1);
		var applCdList	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppAfterLstApplCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
	    var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:3, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",	Type:"Image",     	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"detail",       	Cursor:"Pointer"},
			{Header:"<sht:txt mid='applCdV1' mdef='신청서종류'/>",	Type:"Text",      	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"applNm", 			KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='title' mdef='제목'/>",			Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"title",      		KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applYmd' mdef='기안일'/>",		Type:"Date",      	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applYmd",     		KeyField:0,	CalcLogic:"",   Format:"Ymd",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applInSabunName' mdef='기안자'/>",		Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applName",			KeyField:0,	CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기안자호칭",	Type:"Text",     	Hidden:Number("${aliasHdn}"),  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applAlias",		KeyField:0,	CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기안자직급",	Type:"Text",     	Hidden:Number("${jgHdn}"),  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applJikgubNm",		KeyField:0,	CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"기안자직위",	Type:"Text",     	Hidden:Number("${jwHdn}"),  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applJikweeNm",		KeyField:0,	CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applTypeCdNmV1' mdef='본인결재구분'/>",	Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applTypeCdNm",		KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeYmd' mdef='본인결재일'/>",	Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"agreeYmd",			KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='curName' mdef='현재결재자'/>",	Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"curName",			KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"현재결재자호칭",	Type:"Text",     	Hidden:Number("${aliasHdn}"),  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"curAlias",		KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"현재결재자직급",	Type:"Text",     	Hidden:Number("${jgHdn}"),  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"curJikgubNm",		KeyField:0,	CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"현재결재자직위",	Type:"Text",     	Hidden:Number("${jwHdn}"),  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"curJikweeNm",		KeyField:0,	CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applStatusCdNmV1' mdef='진행상태'/>",		Type:"Text",     	Hidden:0,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applStatusCdNm",	KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='apApplSeqV2' mdef='신청서순번'/>",	Type:"Text",     	Hidden:1,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applSeq",			KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV1' mdef='신청자사번'/>",	Type:"Text",     	Hidden:1,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applSabun",		KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applInSabunV2' mdef='신청입력자사번'/>",Type:"Text",     	Hidden:1,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applInSabun",		KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applCd' mdef='신청서코드'/>",	Type:"Text",     	Hidden:1,  Width:80,  	Align:"Center",  ColMerge:0,   SaveName:"applCd",			KeyField:0,	CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetVisible(true);
	    sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		$(window).smartresize(sheetResize); sheetInit();
		$("#applCd").html(applCdList[2]);
		$("#sDate").datepicker2({startdate:"eDate"});
		$("#eDate").datepicker2({enddate:"sDate"});

		$("#sDate, #eDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

		$("#applCd").bind("change", function() {
			doAction("Search");
		});

		doAction("Search");
	});

	function chkInVal() {

		if ($("#sDate").val() != "" && $("#eDate").val() != "") {
			if (!checkFromToDate($("#sDate"),$("#eDate"),"결재일자","결재일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}

	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			if(!chkInVal()){break;}
			$("#sdt").val($("#sDate").val());
			$("#edt").val($("#eDate").val());
			sheet1.DoSearch( "${ctx}/AppAfterLst.do?cmd=getAppAfterLstList", $("#sheet1Form").serialize());
			break;
		}
    }
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(Row ==0) return;
		    if(sheet1.ColSaveName(Col)=="detail"){
		    	if(!isPopup()) {return;}
		    	var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		    	var initFunc = 'initLayer';
		    	var p = {
						searchApplCd: sheet1.GetCellValue(Row, "applCd")
					  , searchApplSeq: sheet1.GetCellValue(Row, "applSeq")
					  , adminYn: 'N'
					  , authPg: 'R'
					  , searchSabun: sheet1.GetCellValue(Row, "applInSabun")
					  , searchApplSabun: sheet1.GetCellValue(Row, "applSabun")
					  , searchApplYmd: sheet1.GetCellValue(Row, "applYmd") 
					};
		    	var approvalMgrLayer = new window.top.document.LayerModal({
					id: 'approvalMgrLayer',
					url: url,
					parameters: p,
					width: 800,
					height: 815,
					title: '근태신청',
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
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function getReturnValue(returnValue) {
		doAction("Search");
	}
</script>
</head>
<body class="bodywrap">

	<div class="wrapper">
		<form id="sheet1Form" name="sheet1Form">
			<input id="searchApplSeq" 	name="searchApplSeq" 	type="hidden"/>
			<input id="searchApplSabun" name="searchApplSabun" 	type="hidden"/>
			<input id="searchSabun" 	name="searchSabun" 		type="hidden"/>
			<input id="searchApplCd" 	name="searchApplCd" 	type="hidden"/>
			<input id="adminYn" 		name="adminYn" 			type="hidden"/>
			<input id="authPg" 			name="authPg" 			type="hidden"/>
			<input id="searchApplYmd" 	name="searchApplYmd" 	type="hidden"/>
			<input id="edt" 			name="edt" 				type="hidden"/>
			<input id="sdt" 			name="sdt" 				type="hidden"/>
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='104494' mdef='기안종류'/></th>
							<td>
								<select id="applCd" name="applCd"> </select>
							</td>
							<th>결재일자</th>
							<td>
								<input type="text" id="sDate" name="sDate" class="date" value="<%=(DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-7)).replaceAll("-","") %>"/>
								~
								<input type="text" id="eDate" name="eDate" class="date disabled" value="<%=DateUtil.getCurrentTime("yyyyMMdd") %>"/>
							</td>
							<td>
								<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
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
								<li id="txt" class="txt"><tit:txt mid='appAfter' mdef='모든 문서'/></li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>

