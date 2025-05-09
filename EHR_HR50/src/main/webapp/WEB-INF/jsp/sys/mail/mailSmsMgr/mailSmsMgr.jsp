<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var divSearchHtml;
		if ( "${map.bizCd}" == "PAP"){  // 평가
			divSearchHtml = "<table><tr>"
					+ "<td> <span><tit:txt mid='114019' mdef='평가명'/></span>	<select id='searchNoteItem1'	name='searchNoteItem1'	class='w200'></select> </td>"
					+ "<td> <span><tit:txt mid='113317' mdef='평가단계'/></span>	<select id='searchNoteItem2'	name='searchNoteItem2'	class='w100'></select> </td>"
					+ "<td> <span><tit:txt mid='113314' mdef='평가차수'/></span>	<select id='searchNoteItem3'	name='searchNoteItem3'	class='w80' ></select> </td>"
					+ "<td> <a href='javascript:doAction(\"Search\");' id='btnSearch' class='button' >Lookup</a> </td>"
					+ "</tr></table>";
			$("#divSearch").html(divSearchHtml);


			$("#searchNoteItem1, #searchNoteItem2, #searchNoteItem3").bind("change",function(event){
				doAction("Search");
			});

			var searchNoteItem1List = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, "");
			$("#searchNoteItem1").html(searchNoteItem1List[2]);

			var searchNoteItem2List = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00005"), "");
			$("#searchNoteItem2").html(searchNoteItem2List[2]);

			var searchNoteItem3List = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00003"), "");
			$("#searchNoteItem3").html(searchNoteItem3List[2]);


		} else if ( "${map.bizCd}" == "STF"){  // 채용
			divSearchHtml = "<table><tr>"
				+ "<td> <span><tit:txt mid='114419' mdef='채용년도'/></span>	<select id='searchRecYyyy'		name='searchRecYyyy'	class='w100'></select> </td>"
				+ "<td> <span><tit:txt mid='114056' mdef='채용공고'/></span>	<select id='searchNoteItem1'	name='searchNoteItem1'	class='w200'></select> </td>"
				+ "<td> <span><tit:txt mid='104119' mdef='지원분야'/></span>	<select id='searchNoteItem2'	name='searchNoteItem2'	class='w150'></select> </td>"
				+ "</tr></table>   <table><tr>"
				+ "<td> <span><tit:txt mid='113758' mdef='면접전형'/></span>	<select id='searchNoteItem3'	name='searchNoteItem3'	class='w100'></select> </td>"
				+ "<td> <span><tit:txt mid='112964' mdef='합격상태'/></span>	<select id='searchNoteItem4'	name='searchNoteItem4'	class='w100'></select> </td>"
				+ "<td> <span><tit:txt mid='113302' mdef='성명      '/></span> <input type='text' id='searchName' name='searchName' class='text w100' /></td>"
				+ "<td> <a href='javascript:doAction(\"Search\");' id='btnSearch' class='button' >Lookup</a> </td>"
				+ "</tr></table>";
			$("#divSearch").html(divSearchHtml);

			$("#searchName").bind("keyup",function(event){
				if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
			});

			$("#searchRecYyyy").bind("change",function(event){
				var searchNoteItem1List = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getStfRecSeqList&"+ $("#sheetForm").serialize(), false).codeList, "");
				$("#searchNoteItem1").html(searchNoteItem1List[2]);	$("#searchNoteItem1").change();
			});

			$("#searchNoteItem1").bind("change",function(event){
				var searchNoteItem2List = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getStfJobCdList&searchRecSeq="+$("#searchNoteItem1").val() +"&"+ $("#sheetForm").serialize(), false).codeList, "");
				$("#searchNoteItem2").html(searchNoteItem2List[2]);	$("#searchNoteItem2").change();
			});

			$("#searchNoteItem2").bind("change",function(event){
				//&searchAppYn=Y
				var searchNoteItem3List = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getStfStepSeqList&searchRecSeq="+$("#searchNoteItem1").val() +"&searchJobCd="+ $("#searchNoteItem2").val() +"&"+ $("#sheetForm").serialize(), false).codeList, "");
				$("#searchNoteItem3").html(searchNoteItem3List[2]);	$("#searchNoteItem3").change();
			});

			$("#searchNoteItem3, #searchNoteItem4").bind("change",function(event){
				doAction1("Search");
			});

			// 채용년도 코드
			var recYyyyList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getStfRecYyyyList", false).codeList, "");
			$("#searchRecYyyy").html(recYyyyList[2]);	$("#searchRecYyyy").change();

			// 합격여부
			var searchNoteItem4List = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","F50063"), "");
			$("#searchNoteItem4").html(searchNoteItem4List[2]);
		}

		initSheet1();
		initSheet2();

		doAction("Search");
	});

	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			doAction1("Search"); break;
		}
	}

</script>
<script type="text/javascript">
	function initSheet1() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), 	Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
			{Header:"발송Title",			Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:1,	SaveName:"title",			KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sendType' mdef='발송구분|발송구분'/>",				Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"sendType",		KeyField:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sendName' mdef='발신자명|발신자명'/>",				Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sendName",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sendMail' mdef='발신메일|발신메일'/>",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sendMail",		KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sendHp' mdef='발신번호|발신번호'/>",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sendHp",			KeyField:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='detail_V2507' mdef='발송내용|상세'/>",				Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"detail",			KeyField:0,	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='detailYn_V2506' mdef='발송내용|등록여부'/>",				Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"detailYn",		KeyField:0,	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='creButton1' mdef='대상자|생성'/>",					Type:"Html",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"creButton1",		KeyField:0,	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='userCnt1' mdef='대상자|대상자수'/>",				Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"userCnt1",		KeyField:0,	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='userCnt2' mdef='대상자|발송내용미설정자'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"userCnt2",		KeyField:0,	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='creButton2' mdef='대상자|발송내용일괄설정'/>",			Type:"Html",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:1,	SaveName:"creButton2",		KeyField:0,	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='creButton3' mdef='발송|발송'/>",					Type:"Html",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"creButton3",		KeyField:0,	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='sendYn' mdef='발송완료여부|발송완료여부'/>",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sendYn",			KeyField:0,	CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
			{Header:"sendSeq|sendSeq",			Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"sendSeq",			KeyField:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"bizCd|bizCd",				Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"bizCd",			KeyField:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"noteItem1|noteItem1",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"noteItem1",		KeyField:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"noteItem2|noteItem2",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"noteItem2",		KeyField:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"noteItem3|noteItem3",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"noteItem3",		KeyField:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"noteItem4|noteItem4",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"noteItem4",		KeyField:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"noteItem5|noteItem5",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"noteItem5",		KeyField:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		//발송구분(0:메일 1:SMS)
        sheet1.SetColProperty("sendType",		{ComboText:"|메일|SMS",	ComboCode:"|0|1" } );
        sheet1.SetColProperty("sendYn",			{ComboText:"|Y|N",	ComboCode:"|Y|N" } );
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 0);

		$(window).smartresize(sheetResize); sheetInit();
	}
	function initSheet2() {
		var headerReceiveSabun = "";

		if ( "${map.bizCd}" == "PAP"){  // 평가
			headerReceiveSabun = "수신자사번|수신자사번";
		} else if ( "${map.bizCd}" == "STF"){  // 채용
			headerReceiveSabun = "지원번호|지원번호";
		}

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
    		{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0, HeaderCheck:1},
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },
   			{Header:headerReceiveSabun,			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"receiveSabun",	KeyField:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='nameV3' mdef='성명|성명'/>",					Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"receiveName",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='mailAddr_V2282' mdef='메일주소|메일주소'/>",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"receiveMail",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='receiveHp' mdef='핸드폰|핸드폰'/>",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"receiveHp",		KeyField:1,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='detail_V2507' mdef='발송내용|상세'/>",				Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"detail",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='detailYn_V2506' mdef='발송내용|등록여부'/>",				Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"detailYn",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='contents_V2' mdef='발송내용|내용'/>",				Type:"Text",		Hidden:0,	Width:40,	Align:"Left",	ColMerge:1,	SaveName:"contents",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='sendStatusCd_V1' mdef='발송상태|발송상태'/>",				Type:"Combo",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"sendStatusCd",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
			{Header:"<sht:txt mid='sendDate_V1' mdef='발송시간|발송시간'/>",				Type:"Date",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"sendDate",		KeyField:0,   CalcLogic:"",   Format:"YmdHms",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10},
   			{Header:"seq|seq",					Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	UpdateEdit:0,	InsertEdit:1 },
   			{Header:"mailType|mailType",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"mailType",		KeyField:0,	UpdateEdit:0,	InsertEdit:1 },
   			{Header:"sendType|sendType",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"sendType",		KeyField:0,	UpdateEdit:0,	InsertEdit:1 },
   			{Header:"bizDetailNm|bizDetailNm",	Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"bizDetailNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:1 },
   			{Header:"ccMail|ccMail",			Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"ccMail",			KeyField:0,	UpdateEdit:0,	InsertEdit:1 },
   			{Header:"sendSabun|sendSabun",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"sendSabun",		KeyField:0,	UpdateEdit:0,	InsertEdit:1 },
   			{Header:"sendName|sendName",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"sendName",		KeyField:0,	UpdateEdit:0,	InsertEdit:1 },
   			{Header:"sendMail|sendMail",		Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"sendMail",		KeyField:0,	UpdateEdit:0,	InsertEdit:1 },
   			{Header:"sendHp|sendHp",			Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"sendHp",			KeyField:0,	UpdateEdit:0,	InsertEdit:1 },
   			{Header:"title|title",				Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"title",			KeyField:0,	UpdateEdit:0,	InsertEdit:1 },
   			{Header:"refSeq|refSeq",			Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"refSeq",			KeyField:0,	UpdateEdit:0,	InsertEdit:1 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

        sheet2.SetColProperty("sendStatusCd",		{ComboText:"|임시|발송|발송대기|발송실패",	ComboCode:"|T|Y|N|F" } );

		sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetDataLinkMouse("detail", 0);
		$(window).smartresize(sheetResize); sheetInit();
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/MailSmsMgr.do?cmd=getMailSmsMgrList1", $("#sheetForm").serialize() );
			break;
		case "Save":
			// 수정건..

            var sRow = sheet1.FindStatusRow("U|I");
			var arrRow = sRow.split(";");
        	for(var i = 0; i < arrRow.length; i++) {
				var sendType = sheet1.GetCellValue(arrRow[i], "sendType");
				var sendMail = sheet1.GetCellValue(arrRow[i], "sendMail");
				var sendHp   = sheet1.GetCellValue(arrRow[i], "sendHp");

				if(sendType == "0"){  //email
					if (sendMail == ""){
						sheet1.SelectCell(arrRow[i], "sendMail");
						alert("<msg:txt mid='109468' mdef='발신메일을 입력하셔야 합니다. '/>");
						return;
					}
				} else if(sendType == "1"){ // SMS
					if (sendHp == ""){
						sheet1.SelectCell(arrRow[i], "sendHp");
						alert("<msg:txt mid='110519' mdef='발신번호를 입력하셔야 합니다. '/>");
						return;
					}

				}
			}

			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/MailSmsMgr.do?cmd=saveMailSmsMgr1", $("#sheetForm").serialize());
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "noteItem1", $("#searchNoteItem1").val());
			sheet1.SetCellValue(Row, "noteItem2", $("#searchNoteItem2").val());
			sheet1.SetCellValue(Row, "noteItem3", $("#searchNoteItem3").val());
			sheet1.SetCellValue(Row, "noteItem4", $("#searchNoteItem4").val());
			sheet1.SetCellValue(Row, "noteItem5", $("#searchNoteItem5").val());
			break;
		case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row, "sendSeq", "");
			sheet1.SetCellValue(Row, "sendYn", "");
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
			break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":

			$("#searchRefSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "sendSeq"))
			sheet2.DoSearch( "${ctx}/MailSmsMgr.do?cmd=getMailSmsMgrList2", $("#sheetForm").serialize() );
			break;
		case "Save":
			//if(!dupChk(sheet1,"faqSeq|subject", false, true)){break;}
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave( "${ctx}/MailSmsMgr.do?cmd=saveMailSmsMgr2", $("#sheetForm").serialize());
			break;
		case "Insert":
			var sheet1Row = sheet1.GetSelectRow();
			if( sheet1.GetCellValue(sheet1Row,"sStatus") == "D"){
	        	alert("<msg:txt mid='110371' mdef='발송ID 삭제시에는 처리하실 수 없습니다.'/>");
	        	return;
	        }
			if( sheet1.GetCellValue(sheet1Row,"sStatus") != "R"){
	        	alert("<msg:txt mid='110372' mdef='발송ID 저장을 먼저하세요.'/>");
	        	return;
	        }

			var Row       = sheet2.DataInsert(0);
			sheet2.SetCellValue(Row, "mailType", "${map.bizCd}");
			sheet2.SetCellValue(Row, "bizDetailNm", "알림메일(SMS)");
			sheet2.SetCellValue(Row, "title",    sheet1.GetCellValue(sheet1Row, "title"));
			sheet2.SetCellValue(Row, "sendType", sheet1.GetCellValue(sheet1Row, "sendType"));
			sheet2.SetCellValue(Row, "sendName", sheet1.GetCellValue(sheet1Row, "sendName"));
			sheet2.SetCellValue(Row, "sendMail", sheet1.GetCellValue(sheet1Row, "sendMail"));
			sheet2.SetCellValue(Row, "sendHp",   sheet1.GetCellValue(sheet1Row, "sendHp"));
			sheet2.SetCellValue(Row, "refSeq",   sheet1.GetCellValue(sheet1Row, "sendSeq"));


		//	SEND_SABUN


			break;
		case "Copy":
			var Row = sheet2.DataCopy();
			sheet2.SetCellValue(Row, "seq", "");
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;

		case "DownTemplate":  //양식다운로드
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:"receiveSabun|receiveName|receiveMail|receiveHp", SheetDesign:1, Merge:1, DownRows:"0|1"};

			sheet2.Down2Excel(param);
			break;

		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
		case "LoadExcel":
			var sheet1Row = sheet1.GetSelectRow();
			if( sheet1.GetCellValue(sheet1Row,"sStatus") == "D"){
	        	alert("<msg:txt mid='110371' mdef='발송ID 삭제시에는 처리하실 수 없습니다.'/>");
	        	return;
	        }
			if( sheet1.GetCellValue(sheet1Row,"sStatus") != "R"){
	        	alert("<msg:txt mid='110372' mdef='발송ID 저장을 먼저하세요.'/>");
	        	return;
	        }

			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet2.LoadExcel(params);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();

			doAction2("Search");

			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				sheet1.SetCellValue(i, "creButton1", '<btn:a css="basic" mid='110883' mdef="생성"/>');
				sheet1.SetCellValue(i, "creButton2", '<btn:a css="basic" mid='111857' mdef="발송내용일괄설정"/>');
				sheet1.SetCellValue(i, "creButton3", '<a class="basic"><tit:txt mid='112992' mdef='발송'/></a>');
				sheet1.SetCellValue(i, "sStatus", 'R');
			}

		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			if (Code != "-1") { doAction1("Search"); }
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 새부 내역 클릭시 팝업
	function sheet1_OnClick(Row, Col, Value) {
		try{

			if (Row > 0){

				var colSaveName = sheet1.ColSaveName(Col);
				if (colSaveName == "detail" || colSaveName == "creButton1" || colSaveName == "creButton2" || colSaveName == "creButton3"){
					if( sheet1.GetCellValue(Row,"sStatus") == "D"){
			        	alert("<msg:txt mid='110520' mdef='삭제시에는 처리하실 수 없습니다.'/>");
			        	return;
			        }
					if( sheet1.GetCellValue(Row,"sStatus") != "R"){
			        	alert("<msg:txt mid='alertBeSaveReflectCheckV1' mdef='저장을 먼저하세요.'/>");
			        	return;
			        }

					if( colSaveName == "detail"){
						// 상세 팝업
						regPopup("1", sheet1.GetCellValue(Row, "sendType"), sheet1.GetCellValue(Row, "sendSeq"));
					} else if( colSaveName == "creButton1"){
						// 대상자 생성 프로시저 호출
						callProc("prcMailSmsMgr1", Row);
					} else if( colSaveName == "creButton2"){
						// 발송내용일괄설정 프로시저 호출
						callProc("prcMailSmsMgr2", Row);
					} else if( colSaveName == "creButton3"){
						// 발송
						callProc("saveMailSmsMgrSendFlag", Row);
					}
				}
			}

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
	    try {
	        if(OldRow == NewRow ) {
	        	return;
	        } else if(sheet1.GetCellValue(NewRow, "sStatus") == "I") {
	        	return;
	        }

	        doAction2("Search");

	    } catch (ex) {
	        alert("OnSelectCell Event Error : " + ex);
	    }
	}



	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();

		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			if (Code != "-1") { doAction1("Search"); }
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 새부 내역 클릭시 팝업
	function sheet2_OnClick(Row, Col, Value) {
		try{
			if (Row > 0){
				var colSaveName = sheet2.ColSaveName(Col);
				if (colSaveName == "detail"){
					if( sheet2.GetCellValue(Row,"sStatus") == "D"){
			        	alert("<msg:txt mid='110520' mdef='삭제시에는 처리하실 수 없습니다.'/>");
			        	return;
			        }
					if( sheet2.GetCellValue(Row,"sStatus") != "R"){
			        	alert("<msg:txt mid='alertBeSaveReflectCheckV1' mdef='저장을 먼저하세요.'/>");
			        	return;
			        }

					// 상세 팝업
					regPopup("2", sheet2.GetCellValue(Row, "sendType"), sheet2.GetCellValue(Row, "seq"));
				}
			}

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function sheet2_OnLoadExcel(result) {
		var sheet1Row = sheet1.GetSelectRow();

		for(var Row = sheet2.HeaderRows(); Row<sheet2.RowCount()+sheet2.HeaderRows(); Row++){
			sheet2.SetCellValue(Row, "mailType", "${map.bizCd}");
			sheet2.SetCellValue(Row, "bizDetailNm", "알림메일(SMS)");
			sheet2.SetCellValue(Row, "title",    sheet1.GetCellValue(sheet1Row, "title"));
			sheet2.SetCellValue(Row, "sendType", sheet1.GetCellValue(sheet1Row, "sendType"));
			sheet2.SetCellValue(Row, "sendName", sheet1.GetCellValue(sheet1Row, "sendName"));
			sheet2.SetCellValue(Row, "sendMail", sheet1.GetCellValue(sheet1Row, "sendMail"));
			sheet2.SetCellValue(Row, "sendHp",   sheet1.GetCellValue(sheet1Row, "sendHp"));
			sheet2.SetCellValue(Row, "refSeq",   sheet1.GetCellValue(sheet1Row, "sendSeq"));
		}
	}


	// 상세 팝업
	function regPopup(popupPageFlag, sendType, seq){
		var page    = (sendType=="0")?"Mail":"Sms";
		var url 	= "${ctx}/MailSmsMgr.do?cmd=viewMailSmsMgrPopup"+page+"&popupPageFlag="+popupPageFlag+"&searchSendSeq="+seq+"&searchBizCd="+$("#searchBizCd").val();

		var args    = new Array();
        args["bizCd"]   = "${map.bizCd}";

		pGubun      = "viewMailSmsMgrPopup"+page+ popupPageFlag;
		//sendType 0:메일용 / 1:sms용
		if ( popupPageFlag == "1" ) {
			openPopup(url, args, "850","740", regPopupAfter1);
		} else {
			openPopup(url, args, "850","740", regPopupAfter2);
		}

	}

	function regPopupAfter1(rv) {
		if ( rv != null && rv != undefined ) {
			if ( rv["reload"] == "Y" ) {
				doAction1("Search");
			}
		}
	}

	function regPopupAfter2(rv) {
		if ( rv != null && rv != undefined ) {
			if ( rv["reload"] == "Y" ) {
				doAction2("Search");
			}
		}
	}

	function callProc(procName, Row) {

		var msg = "발송Title [ " + sheet1.GetCellValue(Row, "title") + " ]";

		if (procName == "prcMailSmsMgr1"){
			// 대상자 생성 프로시저 호출
			msg += "\n기존 설정되어 있는 대상자를 삭제하고 대상자를 생성합니다.\n실행하시겠습니까?";
		} else if (procName == "prcMailSmsMgr2"){
			// 발송내용일괄설정 프로시저 호출
			msg += "\n기존 설정되어 발송내용을 삭제하고 발송내용을 생성합니다.\n실행하시겠습니까?";
		} else if (procName == "saveMailSmsMgrSendFlag"){
			// 발송
			if (sheet1.GetCellValue(Row, "sendYn") == "Y" ){
				alert("<msg:txt mid='110098' mdef='이미 발송완료된 건은 발송완료처리 하실 수 없습니다.'/>");
				return;
			}

			// 메일 전송대상자가 100건이 넘을 경우 09시에서 17시30분 사이에는 전송 불가
			if (sheet1.GetCellValue(Row, "sendType") == "0"
			 && Number(sheet1.GetCellValue(Row, "userCnt1")) > 100){

				var dateTimeMap = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCurrentDateTime",false).codeList[0];	//현재시간,휴일여부
				if (dateTimeMap.holidayGb == "1" && dateTimeMap.hm >= "0900" && dateTimeMap.hm <= "1730"){
					alert("<msg:txt mid='110099' mdef='휴일을 제외한 09시부터 17시30분까지는 1회 메일발송 건수를 100건이하로 제한합니다.'/>");
					return;
				}
			}

			if (sheet1.GetCellValue(Row, "userCnt2") != "0" && sheet1.GetCellValue(Row, "userCnt2") != "" ){
				alert("<msg:txt mid='109469' mdef='발송내용미설정자수가 0 인 경우만 발송 하실 수 있습니다.'/>");
				return;
			}

			msg += "\n이메일(또는 SMS)를 발송 하시겠습니까?";
		} else {
			alert("<msg:txt mid='110083' mdef='작업이 취소되었습니다.'/>");
			return;
		}

		if (!confirm( msg )) {
			alert("<msg:txt mid='110083' mdef='작업이 취소되었습니다.'/>");
			return;
		}

		$("#searchSendSeq").val(sheet1.GetCellValue(Row, "sendSeq"));

	    var data = ajaxCall( "${ctx}/MailSmsMgr.do?cmd="+procName, $("#sheetForm").serialize(), false );
		if(data == null || data.Result == null) {
			msg = procName+"를 사용할 수 없습니다." ;
		}

		alert( data.Result.Message ) ;

		if (data.Result.Code == null){
			doAction1("Search");
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
	<input type="hidden" id="searchBizCd"   name="searchBizCd"  value="${map.bizCd}">
	<input type="hidden" id="searchSendSeq" name="searchSendSeq">
	<input type="hidden" id="searchRefSeq"  name="searchRefSeq" >

		<div class="sheet_search outer">
			<div id="divSearch" name="divSearch">

			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td class="sheet_top">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='114738' mdef='발송ID설정'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')" 		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Copy')"			css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<tr>
			<td class="sheet_bottom">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='103863' mdef='대상자'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction2('DownTemplate')" 	css="basic authA" mid='110702' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction2('LoadExcel')" 	css="basic authA" mid='110703' mdef="업로드"/>
								<btn:a href="javascript:doAction2('Insert')" 		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction2('Copy')"			css="basic authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction2('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction2('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
