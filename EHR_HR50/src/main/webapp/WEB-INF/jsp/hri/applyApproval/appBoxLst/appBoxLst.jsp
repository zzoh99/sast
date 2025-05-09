<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='104199' mdef='기안한문서'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
	    //var applCdList	= convCodeIdx( ajaxCall("${ctx}/AppBoxLst.do?cmd=getAppBoxLstApplCdList","",false).DATA, "<tit:txt mid='103895' mdef='전체'/>",-1);
	    var applCdList	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppBoxLstApplCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");
	    var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:3, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",	 	Type:"CheckBox",    Hidden:1,  Width:45,   Align:"Center",  ColMerge:0,   SaveName:"chkbox",       	Cursor:"Pointer", Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",		Type:"Image",     	Hidden:0,  Width:45,   Align:"Center",  ColMerge:0,   SaveName:"detail",       	Cursor:"Pointer", Sort:0 },
			{Header:"<sht:txt mid='applCdV1' mdef='신청서종류'/>",		Type:"Text",      	Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"applNm", 		UpdateEdit:0  },
			{Header:"<sht:txt mid='title' mdef='제목'/>",		Type:"Text",      	Hidden:0,  Width:160,  Align:"Left",    ColMerge:0,   SaveName:"title",      	UpdateEdit:0  },
			{Header:"<sht:txt mid='applYmd' mdef='기안일'/>",		Type:"Text",      	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"applYmdA",     	UpdateEdit:0  },
			{Header:"<sht:txt mid='applYmdV4' mdef='신청일2'/>",		Type:"Text",      	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"applYmd",     	UpdateEdit:0  },
			{Header:"<sht:txt mid='applInSabunName' mdef='기안자'/>",		Type:"Text",     	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"applName",		UpdateEdit:0  },
			{Header:"기안자호칭",		Type:"Text",     	Hidden:Number("${aliasHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"applAlias",		UpdateEdit:0  },
			{Header:"기안자직급",		Type:"Text",     	Hidden:Number("${jgHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"applJikgubNm",		UpdateEdit:0  },
			{Header:"기안자직위",		Type:"Text",     	Hidden:Number("${jwHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"applJikweeNm",		UpdateEdit:0  },
			{Header:"<sht:txt mid='agreeName' mdef='결재자성명'/>",		Type:"Text",     	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"agreeName",		UpdateEdit:0  },
			{Header:"결재자호칭",		Type:"Text",     	Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"agreeAlias",		UpdateEdit:0  },
			{Header:"결재자직급",		Type:"Text",     	Hidden:Number("${jgHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"agreeJikgubNm",		UpdateEdit:0  },
			{Header:"<sht:txt mid='agreeJikweeNm' mdef='결재자직위'/>",		Type:"Text",     	Hidden:Number("${jwHdn}"),  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"agreeJikweeNm",		UpdateEdit:0  },
			{Header:"<sht:txt mid='agreeYmdA' mdef='결재일'/>",		Type:"Text",     	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"agreeYmdA",		UpdateEdit:0  },
			{Header:"<sht:txt mid='applStatusCdNmV1' mdef='진행상태'/>",		Type:"Text",     	Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"applStatusCdNm",UpdateEdit:0  },
			{Header:"<sht:txt mid='applSeqV1' mdef='신청서번호'/>",		Type:"Text",     	Hidden:1,  Width:130,  Align:"Center",  ColMerge:0,   SaveName:"applSeq",		UpdateEdit:0  },
			{Header:"<sht:txt mid='applSabunV3' mdef='신청대상자사번'/>",	Type:"Text",     	Hidden:1,  Width:130,  Align:"Center",  ColMerge:0,   SaveName:"applSabun",		UpdateEdit:0  },
			{Header:"<sht:txt mid='applInSabunV1' mdef='신청자사번'/>",		Type:"Text",     	Hidden:1,  Width:130,  Align:"Center",  ColMerge:0,   SaveName:"applInSabun",	UpdateEdit:0  },
			{Header:"<sht:txt mid='applCd' mdef='신청서코드'/>",		Type:"Text",     	Hidden:1,  Width:130,  Align:"Center",  ColMerge:0,   SaveName:"applCd",		UpdateEdit:0  },
			{Header:"<sht:txt mid='applStatusCdV1' mdef='신청서상태코드'/>",	Type:"Text",     	Hidden:1,  Width:130,  Align:"Center",  ColMerge:0,   SaveName:"applStatusCd",		UpdateEdit:0  }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);
	    sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");

		$("#appCd, #appCdNm, #sDate, #eDate").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});

		$("#applCd").bind("change", function() {
			doAction("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		$("#applCd").html(applCdList[2]);
		$("#sDate").datepicker2({startdate:"eDate"});
		$("#eDate").datepicker2({enddate:"sDate"});

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
			sheet1.DoSearch( "${ctx}/AppBoxLst.do?cmd=getAppBoxLstList", $("#sheet1Form").serialize());
			break;
		//case "applBatch":  	sheet1.DoSave( "${ctx}/AppBoxLst.do?cmd=saveAppBoxLst", ""); doAction("Search"); break;
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
		    	var sCd = sheet1.GetCellValue(Row,"applStatusCd");
		    	var url = "";
		    	var initFunc = '';
		    	if(sCd == "11") { url = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer"; initFunc = 'initLayer'}
		    	else { url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer"; initFunc = 'initResultLayer' }
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
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		//신청서 오류 해결
		if(returnValue && Object.keys(returnValue).length != 0) {
			var rv = $.parseJSON('{' + returnValue+ '}');
		}
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
								<input type="text" id="sDate" name="sDate" class="date" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-12)%>" />
								~
								<input type="text" id="eDate" name="eDate" class="date disabled" value="<%= DateUtil.getCurrentTime("yyyyMMdd") %>" />
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
								<li id="txt" class="txt"><tit:txt mid='appBox' mdef='기안한 문서'/></li>
							</ul>
						</div>
					</div>
					<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>



