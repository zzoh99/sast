<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='114242' mdef='결재할 문서'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		//var applCdList	= convCodeIdx( ajaxCall("${ctx}/AppBeforeLst.do?cmd=getAppBeforeLstApplCdList","",false).DATA, "<tit:txt mid='103895' mdef='전체'/>",-1);
		var applCdList	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppBeforeLstApplCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");

	    var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:22, FrozenCol:3, FrozenColRight:1};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  SaveName:"sDelete", Sort:0 },
			{Header:"상태|상태",			Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  SaveName:"sStatus", Sort:0 },
			{Header:"세부\n내역|세부\n내역",	Type:"Image",     	Hidden:0,  					Width:45,   Align:"Center",  SaveName:"detail",       	Cursor:"Pointer" , Sort:0},
			{Header:"신청서종류|신청서종류",	Type:"Text",      	Hidden:0,  					Width:100,  Align:"Center",  SaveName:"applNm", 		Edit:0 },
			{Header:"제목|제목",			Type:"Text",      	Hidden:0,  					Width:160,  Align:"Left",    SaveName:"title",      	Edit:0 },
			
			{Header:"신청일|신청일",		Type:"Text",      	Hidden:0,  					Width:70,   Align:"Center",  SaveName:"applYmd",     	Format:"Ymd", Edit:0 },
			{Header:"기안자|성명",			Type:"Text",     	Hidden:0,  					Width:70,   Align:"Center",  SaveName:"applSabunName",	Edit:0 },
			{Header:"기안자|부서",			Type:"Text",     	Hidden:0,  					Width:120,  Align:"Center",  SaveName:"applOrgNm",		Edit:0 },
			{Header:"기안자|직급",			Type:"Text",     	Hidden:Number("${jgHdn}"),  Width:70,   Align:"Center",  SaveName:"applJikgubNm",	Edit:0 },
			{Header:"기안자|직위",			Type:"Text",     	Hidden:Number("${jwHdn}"),  Width:70,   Align:"Center",  SaveName:"applJikweeNm",	Edit:0 },
			
			{Header:"신청입력자|성명",		Type:"Text",     	Hidden:1,  					Width:70,   Align:"Center",  SaveName:"applInSabunName",Edit:0 },
			{Header:"신청입력자|부서",		Type:"Text",     	Hidden:1,  					Width:120,  Align:"Center",  SaveName:"applInOrgNm",	Edit:0 },
			{Header:"신청입력자|직급",		Type:"Text",     	Hidden:1,  					Width:70,   Align:"Center",  SaveName:"applInJikgubNm",	Edit:0 },
			{Header:"신청입력자|직위",		Type:"Text",     	Hidden:1,  					Width:70,   Align:"Center",  SaveName:"applInJikweeNm",	Edit:0 },
			
			{Header:"진행상태|진행상태",		Type:"Text",     	Hidden:0,  					Width:70,   Align:"Center",  SaveName:"applStatusCdNm",	Edit:0 },
			{Header:"\n선택|\n선택",		Type:"CheckBox",    Hidden:0, 					Width:55,   Align:"Center",  SaveName:"chkbox",       	Cursor:"Pointer" , Sort:0, BackColor:"#ffffb9"},
			
  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applInSabun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"agreeSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"gubun"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"applCd"},
  			
			
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);
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
			sheet1.DoSearch( "${ctx}/AppBeforeLst.do?cmd=getAppBeforeLstList", $("#sheet1Form").serialize());
			break;
		case "applBatch":

			var chkCnt = 0;
			var rowCnt = sheet1.RowCount();
						
			for (var i = sheet1.HeaderRows(); i <= sheet1.HeaderRows() + rowCnt; i++) {
				if (sheet1.GetCellValue(i, "chkbox") == "1") {
					chkCnt++;
				}
			}
			
			if (chkCnt <= 0) {
				alert("<msg:txt mid='alertNotSelectAppl' mdef='선택된 문서가 없습니다.'/>");
				break;
			}

			if (!confirm("선택한 문서에 대해 일괄결재를 진행합니다. \n계속하시겠습니까?")) return;

			progressBar(true) ;

			setTimeout(
				function(){

					$("#agreeUserMemo").val("[일괄결재]결재가 완료되었습니다.");

					var compCnt = 0;
					var errorCnt = 0;

					//for (var i=1; i<=rowCnt; i++) {
					for (var i = sheet1.HeaderRows(); i <= sheet1.HeaderRows() + rowCnt; i++) {	
						if (sheet1.GetCellValue(i, "chkbox") == "1") {
							var applSeq = sheet1.GetCellValue(i, "applSeq");

							var params = "searchApplSabun="+ sheet1.GetCellValue(i, "applSabun")
							           + "&searchApplSeq="+ sheet1.GetCellValue(i, "applSeq")
							           + "&searchApplCd="+ sheet1.GetCellValue(i, "applCd")
							           + "&agreeSeq="+ sheet1.GetCellValue(i, "agreeSeq")
							           + "&agreeGubun="+ sheet1.GetCellValue(i, "gubun")
							           + "&agreeUserMemo="+ $("#agreeUserMemo").val();


					    	var data = ajaxCall("/AppBeforeLst.do?cmd=prcAppBeforeLstProcCall", params, false);

					    	if(data.Result.Code == null || data.Result.Code == "OK") {
					    		// 정상처리시, 메일전송
					    		compCnt ++;
					    		ajaxCall("${ctx}/Send.do?cmd=callMailAppl","applSeq="+applSeq+"&applStatusCd=&firstDiv=N",false);
					    	} else {
						    	//msg = "Error : "+data.Result.Message;
					    		errorCnt ++;
					    	}
						}
					}
					var msg = "정상처리건수 : " + compCnt + " 건";
					if (errorCnt > 0){
						alert(msg + ", 오류건수 : "+ errorCnt + "건");
					} else {
						alert(msg + " 처리완료했습니다.");
					}

					progressBar(false) ;
					doAction("Search");



				}
				, 1000);

			//IBS_SaveName(document.sheet1Form,sheet1);
			//$("#agreeUserMemo").val("[일괄결재]결재가 완료되었습니다.");
			//sheet1.DoSave( "${ctx}/AppBeforeLst.do?cmd=saveAppBeforeLst", $("#sheet1Form").serialize());
			//doAction("Search");
		
			break;
		case "allCheck": //전체 체크 하기
			sheet1.CheckAll("chkbox", 1, false );
			break;
		}
    }

	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); doAction("Search");
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(Row ==0) return;
		    if(sheet1.ColSaveName(Col)=="detail"){
		    	if(!isPopup()) {return;}
				var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
				var initFunc = 'initResultLayer';
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
			<input id="agreeUserMemo"	name="agreeUserMemo"	type="hidden"/>
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th><tit:txt mid='104494' mdef='기안종류'/></th>
							<td>
								<select id="applCd" name="applCd"> </select>
							</td>
							<th><tit:txt mid='104495' mdef='결재일자'/></th>
							<td>
								<input type="text" id="sDate" name="sDate" class="date" value="<%= DateUtil.addMonths(DateUtil.getCurrentTime("yyyy-MM-dd"),-12)%>"/>
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
								<li id="txt" class="txt"><tit:txt mid='114242' mdef='결재할 문서'/></li>
								<li class="btn">
									<a href="javascript:doAction('allCheck')" class="btn outline-gray">전체선택</a>
									<a href="javascript:doAction('applBatch')" class="btn filled"><tit:txt mid='112831' mdef='일괄 결재'/></a>
								</li>
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
