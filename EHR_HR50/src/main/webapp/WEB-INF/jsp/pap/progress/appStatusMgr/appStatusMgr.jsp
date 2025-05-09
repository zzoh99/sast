<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title>목표진행상태관리</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:11,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"선택|선택",						Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"check",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|사번",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|성명",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|호칭",					Type:"Text",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|소속",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직급",					Type:"Text",		Hidden:Number("${jgHdn}"),	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직위",					Type:"Text",		Hidden:Number("${jwHdn}"),	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|직책",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"진행상태|목표",					Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"targetStatusNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"진행상태|중간점검",				Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"middleStatusNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"1차평가|사번",					Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"1차평가|성명",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appName",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"2차평가|사번",					Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appSabun2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"2차평가|성명",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appName2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"3차평가|사번",					Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appSabun3",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"3차평가|성명",					Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appName3",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },

			{Header:"평가ID|평가ID",					Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가단계|평가단계",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appStepCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속|평가소속",				Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"목표진행상태|목표진행상태",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"targetStatusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"중간점검진행상태|중간점검진행상태",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"middleStatusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 헤더 머지
		sheet1.SetMergeSheet( msHeaderOnly);
		$(window).smartresize(sheetResize); sheetInit();
	});

	$(function() {
		$("#searchAppraisalCd").change(function(){
			var appStepCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList"
					,"queryId=getAppStepCdList"
						+ "&searchAppraisalCd="+$("#searchAppraisalCd").val()
						+ "&searchAppStepCdNot=5,"
					, false).codeList, "");
			$("#searchAppStepCd").html(appStepCdList[2]);
			$("#searchAppStepCd").change();
		});

		$("#searchAppStepCd").change(function(){
			doAction1("Search");
		});

		$("#searchAppStatusCd").change(function(){
			doAction1("Search");
		});

		$("#searchNameSabun, #searchOrgNmCd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var appStatusCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10018"), "전체");
		if ( !appStatusCdList ) $("#searchAppStatusCd").html("");
		else                    $("#searchAppStatusCd").html(appStatusCdList[2]);

		//평가명
		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList&searchAppTypeCd=A,B,C",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCdList[2]);
		$("#searchAppraisalCd").change();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AppStatusMgr.do?cmd=getAppStatusMgrList", $("#srchFrm").serialize() ); break;
		case "Save":
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AppStatusMgr.do?cmd=saveAppStatusMgr", $("#srchFrm").serialize()); break;
		case "Insert":		var row = sheet1.DataInsert(0);
							break;
		case "Copy":		var row = sheet1.DataCopy();
							break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		
		case "Print": //출력
			rdPopup();
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
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//취소
	function Cancel(){
		if(sheet1.RowCount() > 0){
			try{
				if(!isPopup()) {return;}

			    var rowCnt = sheet1.CheckedRows("check");

			    if(rowCnt == 0) {
			    	alert("대상자를 선택하여 주세요.");
			    	return;
			    }

			    var rows = sheet1.FindCheckedRow("check");
			    var arrRow = rows.split("|");
				var args    = new Array();

				for(var i = 0; i < arrRow.length; i++) {
					if( i == 0 ) {
						args["appraisalCd"] = sheet1.GetCellValue(arrRow[i],"appraisalCd");
						args["sabun"]       = sheet1.GetCellValue(arrRow[i],"sabun");
						args["appOrgCd"]    = sheet1.GetCellValue(arrRow[i],"appOrgCd");
						args["appStepCd"]   = sheet1.GetCellValue(arrRow[i],"appStepCd");

						if( $("#searchAppStepCd").val()=='1'){
							args["appStatusCd"] = sheet1.GetCellValue(arrRow[i],"targetStatusCd");
						}else if( $("#searchAppStepCd").val()=='3'){
							args["appStatusCd"] = sheet1.GetCellValue(arrRow[i],"middleStatusCd");
						}

					} else {
						args["appraisalCd"] += ","+sheet1.GetCellValue(arrRow[i],"appraisalCd");
						args["sabun"]       += ","+sheet1.GetCellValue(arrRow[i],"sabun");
						args["appOrgCd"]    += ","+sheet1.GetCellValue(arrRow[i],"appOrgCd");
						args["appStepCd"]   += ","+sheet1.GetCellValue(arrRow[i],"appStepCd");
					}
				}

				let modalLayer = new window.top.document.LayerModal({
					id: 'appStatusMgrLayer',
					url: "${ctx}/AppStatusMgr.do?cmd=viewAppStatusMgrLayer&authPg=${authPg}",
					parameters: args,
					width: 750,
					height: 250,
					title: '진행상태변경작업',
					trigger: [
						{
							name: 'appStatusMgrLayerTrigger',
							callback: function(rv) {
								if(rv["Code"] == "1") {
									doAction1("Search");
								}
							}
						}
					]
				});
				modalLayer.show();
		    }catch(ex){alert("Cancel Event Error : " + ex);}
		}else{
			alert("취소작업을 할 대상이 존재 하지 않습니다.");
		}
	}

	/**
	* 메일전송
	*/
	function sendMail(){
		var frm = document.form;
		var sabunArr = [];
		var sabuns = "";

		if(sheet1.RowCount() > 0 && sheet1.CheckedRows("check") > 0){
			var sRow = sheet1.FindCheckedRow("check");
			var arrRow = sRow.split("|");

			for(var i = 0; i < arrRow.length; i++) {
				if(arrRow[i] != "") {
					sabunArr.push( sheet1.GetCellValue( arrRow[i], "sabun" ));
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
		var rv = openPopup(url, args, "900","720");
	}

	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(){
		if(!isPopup()) {return;}

		var sabunAppOrgCd = "";
		for(var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
			if ( sheet1.GetCellValue(i, "check") == 0 ) continue;

			sabunAppOrgCd += "('"+ sheet1.GetCellValue(i, "sabun") +"', '"+ sheet1.GetCellValue(i, "appOrgCd") +"'),";
		}
		if ( 0 < sabunAppOrgCd.length ) sabunAppOrgCd = sabunAppOrgCd.substr(0, sabunAppOrgCd.length-1);

		if ( sabunAppOrgCd == "" ) {
			alert("선택한 항목이 없습니다.");
			return;
		}

		var w 		= 1200;
		var h 		= 920;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();
		// args의 Y/N 구분자는 없으면 N과 같음

		//var rdMrd   = "pap/progress/AppReport.mrd";
		var rdMrd	= "";
		var rdTitle = "";
		var rdParam = "";

		if($("#searchAppStepCd").val() == "1") {
			//목표승인
			rdMrd = "pap/progress/MboTargetStep1.mrd";
			rdTitle = "목표등록출력물";
		} else {
			//중간점검승인
			rdMrd = "pap/progress/MboTargetStep2.mrd";
			rdTitle = "중간점검출력물";
		}

		rdParam  = rdParam +"[${ssnEnterCd}] "; //회사코드
		rdParam  = rdParam +"["+ $("#searchAppraisalCd").val() +"] "; //평가ID
		rdParam  = rdParam +"["+ sabunAppOrgCd +"] "; //피평가자 사번, 평가소속

		const data = {
			parameters : rdParam,
			rdMrd : rdMrd
		};

		window.top.showRdLayer('/EvaMain.do?cmd=getEncryptRd', data, null, rdTitle);
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
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
							<span>평가단계</span>
							<select name="searchAppStepCd" id="searchAppStepCd">
							</select>
						</td>
						<td>
							<span>진행상태</span>
							<select name="searchAppStatusCd" id="searchAppStatusCd">
							</select>
						</td>
					</tr>
					<tr>
						<td>
							<span>성명 /사번</span>
							<input id="searchNameSabun" name ="searchNameSabun" value="" type="text" class="text" />

						</td>
						<td>
							<span>평가소속</span>
							<input id="searchOrgNmCd" name ="searchOrgNmCd" type="text" class="text w100"/>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a> </td>
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
							<li id="txt" class="txt">목표진행상태관리</li>
							<li class="btn">
								<!--a href="javascript:sendMail();" class="button authA">메일발송</a-->
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
								<a href="javascript:doAction1('Print');" 	class="btn outline_gray authA">출력</a>
								<a href="javascript:Cancel();" 	class="btn filled authA">진행상태변경작업</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>