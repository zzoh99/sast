<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22, MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"\n선택|\n선택",		Type:"DummyCheck",	Hidden:1,					Width:40,			Align:"Center",	ColMerge:0,	SaveName:"check",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"피평가자|사번",		Type:"Text",		Hidden:1,					Width:70,			Align:"Center",	ColMerge:1,	SaveName:"sabun",			Edit:0 },
			{Header:"피평가자|성명",		Type:"Text",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:1,	SaveName:"name",			Edit:0 },
			{Header:"피평가자|소속",		Type:"Text",		Hidden:0,					Width:100,			Align:"Left",	ColMerge:1,	SaveName:"appOrgNm",		Edit:0 },
			{Header:"피평가자|직급",		Type:"Text",		Hidden:Number("${jgHdn}"),	Width:50,			Align:"Center",	ColMerge:1,	SaveName:"jikgubNm",		Edit:0 },
			{Header:"피평가자|직위",		Type:"Text",		Hidden:Number("${jwHdn}"),	Width:50,			Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",		Edit:0 },
			{Header:"피평가자|직책",		Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",		Edit:0 },
			{Header:"진행상태|진행상태",	Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:1,	SaveName:"statusNm",		Edit:0 },
			{Header:"평가그룹|1차",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:1,	SaveName:"appGroupNm1",		Edit:0 },
			{Header:"평가그룹|2차",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:1,	SaveName:"appGroupNm2",		Edit:0 },
			{Header:"평가그룹|3차",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:1,	SaveName:"appGroupNm3",		Edit:0 },

			{Header:"평가ID",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:1,	SaveName:"appraisalCd"},
			{Header:"평가소속",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:1,	SaveName:"appOrgCd"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata.Cols = [
   			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
   			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
   			{Header:"\n선택|\n선택",			Type:"DummyCheck",	Hidden:1,					Width:40,	Align:"Center",	ColMerge:0,	SaveName:"check",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

   			{Header:"평가차수|평가차수",		Type:"Text",		Hidden:0,					Width:70,	Align:"Center",	ColMerge:1,	SaveName:"appSeqNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"평가자|사번",			Type:"Text",		Hidden:1,					Width:70,	Align:"Center",	ColMerge:1,	SaveName:"appSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"평가자|성명",			Type:"Text",		Hidden:0,					Width:70,	Align:"Center",	ColMerge:1,	SaveName:"appName",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"평가자|소속",			Type:"Text",		Hidden:0,					Width:100,	Align:"Left",	ColMerge:1,	SaveName:"appOrgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"평가자|직급",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"평가자|직위",			Type:"Text",		Hidden:Number("${jwHdn}"),	Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"평가자|직책",			Type:"Text",		Hidden:0,					Width:50,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가자|평가그룹",		Type:"Text",		Hidden:0,					Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appGroupNm",		Edit:0 },
			{Header:"완료\n여부|완료\n여부",	Type:"CheckBox",	Hidden:0,					Width:50,	Align:"Center",	ColMerge:1,	SaveName:"appraisalYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },

			{Header:"평가ID|평가ID",			Type:"Text",		Hidden:1,					Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appraisalCd"},
			{Header:"평가단계|평가단계",		Type:"Text",		Hidden:1,					Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appStepCd"},
			{Header:"평가차수|평가차수",		Type:"Text",		Hidden:1,					Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appSeqCd"},
			{Header:"피평가자|사번",			Type:"Text",		Hidden:1,					Width:100,	Align:"Center",	ColMerge:1,	SaveName:"sabun"},
			{Header:"피평가자|소속",			Type:"Text",		Hidden:1,					Width:100,	Align:"Center",	ColMerge:1,	SaveName:"appOrgCd"}
   		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
	});

	$(function() {

		$("#searchAppraisalCd").change(function(){

			if($("#searchAppraisalCd").val() != ""){
				var data   = ajaxCall("${ctx}/AppAdjStausMng.do?cmd=getBaseYmd","&searchAppraisalCd="+$("#searchAppraisalCd").val(),false);

				if(data.map != null && data.map != ""){
					$("#baseYmd").val(data.map.baseYmd);
					$("#appTypeCd").val(data.map.appTypeCd);

					var seqCdParam = "&searchNote3=Y";
					if( $("#appTypeCd").val()  == "D" ){
						seqCdParam = "&searchNote4=Y";
					}
					//평가차수
					var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y"+seqCdParam,false).codeList, "전체");
					$("#searchAppSeqCd").html(appSeqCdList[2]);

					if ($("#appTypeCd").val() == "D") {
						$("#searchAppGroupNm1").val("").attr("readonly", true).addClass("readonly");
						$("#searchAppGroupNm2").val("").attr("readonly", true).addClass("readonly");
						$("#searchAppGroupNm3").val("").attr("readonly", true).addClass("readonly");
					} else {
						$("#searchAppGroupNm1").attr("readonly", false).removeClass("readonly");
						$("#searchAppGroupNm2").attr("readonly", false).removeClass("readonly");
						$("#searchAppGroupNm3").attr("readonly", false).removeClass("readonly");
					}

					doAction1("Search");
				}

			}

		});

		$("#searchAppStatusCd, #searchAppSeqCd").change(function(){

			doAction1("Search");
		});

		$("#searchNameSabun, #searchAppNameSabun, #searchAppGroupNm1, #searchAppGroupNm2, #searchAppGroupNm3").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCdList[2]);

		//진행상태
		var appStatusCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10018"), "전체");
		if ( !appStatusCdList ) $("#searchAppStatusCd").html("");
    	else $("#searchAppStatusCd").html(appStatusCdList[2]);

		$("#searchAppraisalCd").change();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if( $("#appTypeCd").val()  == "D" ){
				sheet1.DoSearch( "${ctx}/AppAdjStausMng.do?cmd=getAppAdjStausMngList3D", $("#srchFrm").serialize() );
			}else{
				sheet1.DoSearch( "${ctx}/AppAdjStausMng.do?cmd=getAppAdjStausMngList3", $("#srchFrm").serialize() );
			}
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			doAction2("Clear");

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg);
			}
			if ( Code != "-1" ) {
				doAction1("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀이 선택 되었을때 발생한다
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
			if(OldRow == NewRow || sheet1.GetCellValue(NewRow, "sStatus") == "I" || NewRow < 2) return;

			doAction2("Search");
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var Row = sheet1.GetSelectRow();
			$("#searchAppraisalCd2").val( sheet1.GetCellValue(Row, "appraisalCd"));
			$("#searchSabun").val( sheet1.GetCellValue(Row, "sabun"));
			$("#searchAppOrgCd").val( sheet1.GetCellValue(Row, "appOrgCd"));
			sheet2.DoSearch( "${ctx}/AppAdjStausMng.do?cmd=getAppAdjStausMngList4", $("#srchFrm2").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.srchFrm2,sheet2);
			sheet2.DoSave( "${ctx}/AppAdjStausMng.do?cmd=saveAppAdjStausMng3", $("#srchFrm2").serialize() + "&appTypeCd=" + $("#appTypeCd").val());
			break;
		case "Clear":
			sheet2.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet2.Down2Excel(param);
			break;
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
		try{
			if(Msg != "") {
				alert(Msg);
			}
			if ( Code != "-1" ) {
				doAction2("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	function sheet2_OnChange(Row, Col, Value) {
		try{
			//상사평가, 동료평가 제외
			if( sheet2.GetCellValue(Row, "appSeqCd") == "3" || sheet2.GetCellValue(Row, "appSeqCd") == "4"  ) return;
			var saveAppYnCnt = 0;
			var sSaveName = sheet2.ColSaveName(0, Col);
			if( sSaveName == "appraisalYn" ){
				for(var i = sheet2.HeaderRows(); i <= sheet2.RowCount()+sheet2.HeaderRows() ; i++) {
					if( i < Row){
						sheet2.SetCellValue(i, "appraisalYn", "Y", 0);
					}else if( i > Row){
						sheet2.SetCellValue(i, "appraisalYn", "N", 0);
					}

					if( sheet2.GetCellValue(i, "appraisalYn") == "Y" ) saveAppYnCnt++;
				}
			}
			$("#saveAppYnCnt").val(saveAppYnCnt);


		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}



	/**
	* 메일전송
	*/
	function sendMail(sheetGb){
		var sheet = (sheetGb==1)?sheet1:sheet2;
		var frm = document.form;
		var sabunArr = [];
		var sabuns = "";
		if(sheet.RowCount() > 0 && sheet.CheckedRows("check") > 0){
			var sRow = sheet.FindCheckedRow("check");
			var arrRow = sRow.split("|");

			for(var i = 0; i < arrRow.length; i++) {
				if(arrRow[i] != "") {
					sabunArr.push( sheet.GetCellValue( arrRow[i], "sabun" ));
				}
			}
		}else{
			alert("메일전송 대상자를 선택하여 주세요.");
			return;
		}
		sabuns = sabunArr.join(",");

		$("#receiverSabuns").val(sabuns);

		// 발송대상
		var obj = ajaxCall("/SendMgr.do?cmd=getMailInfo", $("#srchFrm").serialize(),false).result;

		if(obj != null && obj.length <= 0) {
			alert("메일정보를 찾을 수 없습니다.");
			return;
		}
		var names = "";
		var mailIds = "";
		var nameArr = [];
		var mailIdArr = [];
		for (i = 0; i < obj.length; i++) {1
			nameArr.push( obj[i].name );
			mailIdArr.push( obj[i].mailId );
		}
		names = nameArr.join("|");
		mailIds = mailIdArr.join("|");

		if(!isPopup()) {return;}

		var args 	= new Array();

		args["saveType"] = "insert";
		args["names"]    = names;
		args["mailIds"]  = mailIds;
		args["sender"]   = "${ssnName}";
		args["bizCd"]    = "PAP";  //기본적으로 ETC를 넘기면 됨[직접입력 서식]
		args["authPg"]   = "${authPg}";

		var url = "${ctx}/SendPopup.do?cmd=viewMailMgrPopup";
		var rv = openPopup(url, args, "900","750");
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" name="baseYmd" id="baseYmd">
	<input type="hidden" name="appTypeCd" id="appTypeCd">
	<input type="hidden" name="mailReceiverNms" id="mailReceiverNms" 	value="">
	<input type="hidden" name="mailReceiverMails" id="mailReceiverMails"	value="">
	<input type="hidden" name="receiverSabuns" id="receiverSabuns">
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd">
							</select>
						</td>
						<td>
							<span>피평가자 성명/사번</span>
							<input id="searchNameSabun" name ="searchNameSabun" value="" type="text" class="text" />
						</td>
						<td>
							<span>진행상태</span>
							<select name="searchAppStatusCd" id="searchAppStatusCd"></select>
						</td>
						<td></td>
						<td></td>
						<td></td>
					</tr>
					<tr>
						<td>
							<span>평가차수</span>
							<select name="searchAppSeqCd" id="searchAppSeqCd" ></select>
						</td>
						<td>
							<span>평가자 성명/사번</span>
							<input id="searchAppNameSabun" name="searchAppNameSabun" value="" type="text" class="text" />
						</td>
						<td>
							<span>1차평가그룹</span>
							<input id="searchAppGroupNm1" name="searchAppGroupNm1" value="" type="text" class="text" />
						</td>
						<td>
							<span>2차평가그룹</span>
							<input id="searchAppGroupNm2" name="searchAppGroupNm2" value="" type="text" class="text" />
						</td>
						<td>
							<span>3차평가그룹</span>
							<input id="searchAppGroupNm3" name="searchAppGroupNm3" value="" type="text" class="text" />
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="48%" />
		<col width="15px" />
		<col width="%" />
	</colgroup>
	<tr>
		<td class="">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">피평가자</li>
						<li class="btn">
							<!-- a href="javascript:sendMail(1);" class="button authA">메일발송</a -->
							<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
		</td>
		<td></td>
		<td class="">
			<form id="srchFrm2" name="srchFrm2" >
			<input type="hidden" id="searchAppraisalCd2" name="searchAppraisalCd2" />
			<input type="hidden" id="searchSabun" name="searchSabun" />
			<input type="hidden" id="searchAppOrgCd" name="searchAppOrgCd" />
			<input type="hidden" id="saveAppYnCnt" name="saveAppYnCnt" />
			</form>
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt">평가자</li>
						<li class="btn">
							<!--a href="javascript:sendMail(2);" class="button authA">메일발송</a -->
							<a href="javascript:doAction2('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
							<a href="javascript:doAction2('Save');" 	class="btn filled authA">저장</a>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","kr"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>