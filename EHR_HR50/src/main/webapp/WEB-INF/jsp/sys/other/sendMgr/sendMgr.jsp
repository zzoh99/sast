<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		
		
		$("#searchName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction2("Search"); $(this).focus(); }
		});

		var sendMailFl = "N";
		var sendSMSFl = "N";

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='orgChartNm' mdef='소속도명'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgChartNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='priorOrgCd' mdef='상위소속코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,    TreeCol:1 },
			{Header:"<sht:txt mid='orgCdV3' mdef='팀'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.ShowTreeLevel(-1);

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22};
		initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"  },
			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"DummyCheck",Hidden:0,  Width:40,   Align:"Center",  ColMerge:0,   SaveName:"chk",      KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,	Width:120,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",	UpdateEdit:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"sabun",	UpdateEdit:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Popup",		Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"name",	UpdateEdit:0 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:Number("${aliasHdn}"),	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"alias",	UpdateEdit:0 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Combo",		Hidden:Number("${jgHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Combo",		Hidden:Number("${jwHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Combo",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",UpdateEdit:0 },
			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",		Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"statusNm",UpdateEdit:0 },
			{Header:"<sht:txt mid='mailAddr' mdef='이메일'/>",		Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"mailId",UpdateEdit:0 },
			{Header:"<sht:txt mid='handPhoneV1' mdef='휴대폰'/>",		Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"handPhone",UpdateEdit:0 }
		]; IBS_InitSheet(sheet2, initdata); sheet2.SetCountPosition(4); sheet2.SetEditableColorDiff (0);


		var jikweeNm 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20030"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet2.SetColProperty("jikweeCd", 		{ComboText:"|"+jikweeNm[0], ComboCode:"|"+jikweeNm[1]} );
		$("#searchJikweeCd").html(jikweeNm[2]);

		var jikgubNm 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet2.SetColProperty("jikgubCd", 		{ComboText:"|"+jikgubNm[0], ComboCode:"|"+jikgubNm[1]} );
		$("#searchJikgubCd").html(jikgubNm[2]);

		var jikchakNm 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20020"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet2.SetColProperty("jikchakCd", 		{ComboText:"|"+jikchakNm[0], ComboCode:"|"+jikchakNm[1]} );
		$("#searchJikchakCd").html(jikchakNm[2]);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
		
		

	});



	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/SendMgr.do?cmd=getSendMgrOrgList", $("#mySheetForm").serialize(),1 );
			break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "orgCd="+sheet1.GetCellValue(sheet1.GetSelectRow(),"orgCd");
				param+= "&searchJikweeCd="+$("#searchJikweeCd").val();
				param+= "&searchJikchakCd="+$("#searchJikchakCd").val();
				param+= "&searchName="+encodeURIComponent($("#searchName").val());
			if(document.getElementById("searchType").checked == true){
				param = param +"&searchType=1";
			}
			else {
				param = param +"&searchType=0";
			}

			if(document.getElementById("searchRet").checked == true){
				param = param +"&searchRet=1";
			}
			else {
				param = param +"&searchRet=0";
			}

			sheet2.DoSearch( "${ctx}/SendMgr.do?cmd=getSendMgrOrgUserList", param,1);

			break;
		}
	}


	function sendSMS(){
		//정보 세팅
		getEmployeeInfo('sms');
		//메일발송 플래그 변경
		sendMailFl = "N";
		sendSMSFl = "Y";
	}

	/**
	 * Mail 발송 팝업 창 호출
	 */
	function fnSendMailPop(names,mailIds){
		if(!isPopup()) {return;}

		var args 	= new Array();

		args["saveType"] = "insert";
		args["names"] = names;
		args["mailIds"] = mailIds;
		args["sender"] = "${ssnName}";
		args["bizCd"] = "ETC";  //기본적으로 ETC를 넘기면 됨[직접입력 서식]
		args["authPg"] = "${authPg}";

		let layerModal = new window.top.document.LayerModal({
            id : 'mailMgrLayer'
          , url : '${ctx}/SendPopup.do?cmd=viewMailMgrLayer'
          , parameters : args
          , width : 870
          , height : 780
          , title : 'MAIL 발신'
          , trigger :[
              {
                    name : 'mailMgrTrigger'
                  , callback : function(result){
                	  callBackFnSendMail(result);
                  }
              }
           ]
        });
        layerModal.show();
	}

	/**
	 * SMS 발송 팝업 창 호출
	 */
	function fnSendSmsPop(names,handPhones){
		if(!isPopup()) {return;}

		var args 	= new Array();

		args["saveType"] = "insert";
		args["names"] = names;
		args["handPhones"] = handPhones;
		args["bizCd"] = "CPN";
		args["authPg"] = "${authPg}";

		//var url = "${ctx}/SendPopup.do?cmd=smsMgrPopup";
		//var rv = openPopup(url, args, "500","480");
        let layerModal = new window.top.document.LayerModal({
            id : 'smsMgrLayer'
          , url : '${ctx}/SendPopup.do?cmd=viewSmsMgrLayer'
          , parameters : args
          , width : 500
          , height : 480
          , title : 'SMS 발신'
          , trigger :[
              {
                    name : 'smsMgrTrigger'
                  , callback : function(result){
                	  callBackFnSendSms(result);
                  }
              }
           ]
	    });
	    layerModal.show();
	}

	/**
	* SMS발송 후처리
	* result : Y (발신성공), N(발신 실패)
	*/
	function callBackFnSendSms(result){
		var successFl = "Y";
		for(var i=0; i<result.length;i++){
			if(result[i] != "Y"){
				successFl = "N";
			}
		}

		if(successFl != "Y"){
			alert("<msg:txt mid='110366' mdef='발신처리에 실패하였습니다.\n관리자에게 문의 해 주세요.'/>");
		}else{
			alert("<msg:txt mid='errorSmsSendOk' mdef='발신처리에 성공하였습니다.'/>");
		}
	}

	function sendMail(){
		//정보 세팅
		getEmployeeInfo('mail');
		//메일발송 플래그 변경
		sendMailFl = "Y";
		sendSMSFl = "N";
	}

	/**
	* mail 발송 후 처리
	* result : Y(발신성공),
	*          N(발신실패),
	*          E1(수신자정보 오류),
	*		   E2(발신처리 실패)
	*          E3(메일의 내용이 100000byte보다 큼-> html태그 + 메일 본문길이)
	*
	*/
	function callBackFnSendMail(result){
		if(result == "Y"){
			alert("<msg:txt mid='errorSmsSendOk' mdef='발신처리에 성공하였습니다.'/>");
		}else{
			if(result == "E1"){
				alert("<msg:txt mid='errorEmailRecipient' mdef='수신자 정보를 확인 해 주세요.'/>");
			}else if(result == "E2"){
				alert("<msg:txt mid='110366' mdef='발신처리에 실패하였습니다.\n관리자에게 문의 해 주세요.'/>");
			}else if(result == "E3"){
				alert("<msg:txt mid='errorEmailLength' mdef='메일의 내용의 길이를 확인 해 주세요.'/>");
			}else if(result == "N"){
				alert("<msg:txt mid='110366' mdef='발신처리에 실패하였습니다.\n관리자에게 문의 해 주세요.'/>");
			}
		}
	}

	/**
	* 메일정보 구하기
	*/
	function getEmployeeInfo(job){
		var sabuns = [];

		if(sheet2.RowCount() > 0 && sheet2.CheckedRows("chk") > 0){
			var sRow = sheet2.FindCheckedRow("chk");
			var arrRow = sRow.split("|");

			for(var i = 0; i < arrRow.length; i++) {
				if(arrRow[i] != "") {
					if( (job == "mail" && sheet2.GetCellValue( arrRow[i], "mailId" ) != "")
						|| (job == "sms" && sheet2.GetCellValue( arrRow[i], "handPhone" ) != "") ) {
						//sabuns += sheet2.GetCellValue( arrRow[i], "sabun" ) + ",";
						sabuns[i] = sheet2.GetCellValue( arrRow[i], "sabun" );
					}
				}
			}
		}else{
			alert("<msg:txt mid='alertNotSubject' mdef='대상자가 존재하지 않습니다.'/>");
			return;
		}

		if(sabuns.length == 0) {
			if (job == "mail")
				alert("<msg:txt mid='alertNotSubject' mdef='이메일 정보가 존재하지 않습니다.'/>");
			else if (job == "sms")
				alert("<msg:txt mid='alertNotSubject' mdef='휴대폰 정보가 존재하지 않습니다.'/>");

			return;
		}

		//sabuns = sabuns.substr(0,sabuns.length-1);

		$("#receiverSabuns").val(sabuns);
	    
		// 발송대상
		var obj = ajaxCall("/SendMgr.do?cmd=getMailInfo", $("#srchFrm").serialize(),false).result;
			
		if(obj != null && obj.length <= 0) {
			alert("<msg:txt mid='errorMacUser' mdef='매칭되는 인원이 없습니다.'/>");
			return;
		}
		var names = "";
		var handPhones = "";
		var mailIds = "";
		for (i = 0; i < obj.length; i++) {1
			names += obj[i].name + "|";
			handPhones += obj[i].handPhone + "|";
			mailIds += obj[i].mailId + "|";
		}
		names = names.substr(0, names.length - 1);
		handPhones = handPhones.substr(0, handPhones.length - 1);
		mailIds = mailIds.substr(0, mailIds.length - 1);

		(job=="mail")? fnSendMailPop(names,mailIds) : fnSendSmsPop(names,handPhones) ;
		//fnSendPop(infoArray,job);
		
		return;
	}



	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col) {
		try{
			if(sheet2.ColSaveName(Col)=="name") {
				empSearchPopup(Row,Col);
			}
		}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
	}

	function empSearchPopup(Row, Col) {
		if(!isPopup()) {return;}

		var w		= 840;
		var h		= 520;
		var url		= "/Popup.do?cmd=employeePopup";
		var args	= new Array();

		args["name"] = "";
		args["sabun"] = "";

		gPRow = Row;
		pGubun = "employeePopup";

		var win = openPopup(url+"&authPg=${authPg}", args, w, h);
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

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {
				if(OldRow != NewRow) {
					doAction2("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "workType", rv["workType"]);
			sheet1.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
			sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
			sheet1.SetCellValue(gPRow, "jikgubCd", rv["jikgubCd"]);
        }
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" name="mailReceiverNms" id="mailReceiverNms" 	value="">
	<input type="hidden" name="mailReceiverMails" id="mailReceiverMails"	value="">
	<input type="hidden" name="smsReceiverCells" id="smsReceiverCells"	value="">
	<input type="hidden" name="smsReceiverNms" id="smsReceiverNms"	value="">
	<input type="hidden" name="receiverSabuns" id="receiverSabuns">

	<input type="hidden" name="searchStatusCd" id="searchStatusCd" value="RA"  >
	<input type="hidden" name="printScoreYN" id="printScoreYN" value="Y"  >
	<input type="hidden" name="searchAdminYn" id="searchAdminYn" value="${authPg}">

	</form>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="300px" />
			<col width="*" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='114458' mdef='메일전송'/></li>
							<li class="btn">
								<input type="checkbox" class="checkbox" id="searchRet" name="searchRet" onclick="doAction2('Search');" style="vertical-align:middle;"/>퇴사자포함
								<input type="checkbox" class="checkbox" id="searchType" name="searchType" onclick="doAction2('Search');" style="vertical-align:middle;"/><tit:txt mid='104304' mdef='하위조직포함'/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">보낼사람</li>
						<li class="btn">
							<span><tit:txt mid='112277' mdef='사번/성명 '/></span>
							<input id="searchName" name="searchName" type="text" class="text" />
							<span><tit:txt mid='103785' mdef='직책'/></span>
							<select id="searchJikchakCd" name="searchJikchakCd" onChange="doAction2('Search');">
							</select>

							<btn:a href="javascript:sendMail();" css="btn filled authA" mid='sendMail' mdef="메일발송"/>
							<btn:a href="javascript:sendSMS();" css="btn filled authA" mid='110966' mdef="SMS발송"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
