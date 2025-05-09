<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>평가자</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">
	//var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";
	var isSave = false;

	$(function() {
		createIBSheet3(document.getElementById('DIV_apmaslSheet1'), "apmaslSheet1", "100%", "100%", "${ssnLocaleCd}");
		var modal = window.top.document.LayerModalUtility.getModal('appPeopleMgrAppSabunLayer');
		//var arg = p.popDialogArgumentAll();
	    //if( arg != undefined ) {
		    $("#searchAppraisalCd").val(modal.parameters.searchAppraisalCd);
		    $("#searchAppStepCd").val(modal.parameters.searchAppStepCd);
		    $("#searchAppOrgCd").val(modal.parameters.searchAppOrgCd);
		    $("#searchAppOrgNm").html(modal.parameters.searchAppOrgNm);
		    $("#searchSabun").val(modal.parameters.searchSabun);
		    $("#searchName").html(modal.parameters.searchName);
		    $("#appTypeCd").val(modal.parameters.appTypeCd);
		    $("#searchAppraisalNm").html(modal.parameters.searchAppraisalNm);
	    //}

		if ($("#searchAppraisalCd").val() == "" || $("#searchAppStepCd").val() == "" || $("#searchAppOrgCd").val() == "" || $("#searchSabun").val() == "") {
			alert("평가대상자가 존재하지 않습니다. \n팝업을 닫고 평가대상자를 입력하시기 바랍니다.");
			p.self.close();
		}
	});
	$(function() {

  		var seqCdParam = "", pHdn = 0;
  		if( $("#appTypeCd").val() == "D"){ //다면평가
  			seqCdParam = "&searchNote4=Y";
  			pHdn = 1; //다면평가는 평가그룹이 없음.
  		}else{
  			seqCdParam = "&searchNote3=Y";
  			pHdn = ($("#searchAppStepCd").val() == "5" )?0:1;
  		}

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata.Cols = [
			{Header:"No"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제"			,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태"			,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },

			{Header:"차수"			,Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appSeqCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"성명"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appName",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:500 },
			{Header:"사번"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appSabun",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"소속"			,Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:1,	SaveName:"orgNm",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikgubNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직책"			,Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"jikchakNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가그룹"		,Type:"Popup",		Hidden:pHdn,Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appGroupNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"평가ID"			,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appraisalCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"평가단계"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appStepCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"평가소속코드"	,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appOrgCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"appOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"사원번호"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직위코드"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"jikweeCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"직급코드"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"jikgubCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"직책코드"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"jikchakCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"직위"			,Type:"Text",		Hidden:1,	Width:80,	Align:"Left",	ColMerge:1,	SaveName:"jikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"조직코드"		,Type:"Text",		Hidden:1,	Width:50,	Align:"Left",	ColMerge:1,	SaveName:"orgCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"평가대상그룹"	,Type:"Text",		Hidden:1,	Width:80,	Align:"Left",	ColMerge:1,	SaveName:"appGroupCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
  		]; IBS_InitSheet(apmaslSheet1, initdata);apmaslSheet1.SetEditable("${editable}");apmaslSheet1.SetVisible(true);apmaslSheet1.SetCountPosition(4);apmaslSheet1.SetUnicodeByte(3);

		//Autocomplete	
		$(apmaslSheet1).sheetAutocompleteLayer({
			Columns: [
				{
					ColSaveName  : "appName",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						apmaslSheet1.SetCellValue(gPRow,"appName",(rv["name"]));
						apmaslSheet1.SetCellValue(gPRow,"appSabun",(rv["sabun"]));
						apmaslSheet1.SetCellValue(gPRow,"orgCd",(rv["orgCd"]));
						apmaslSheet1.SetCellValue(gPRow,"orgNm",(rv["orgNm"]));
						apmaslSheet1.SetCellValue(gPRow,"jikgubNm",(rv["jikgubNm"]));
						apmaslSheet1.SetCellValue(gPRow,"jikgubCd",(rv["jikgubCd"]));
						apmaslSheet1.SetCellValue(gPRow,"jikweeNm",(rv["jikweeNm"]));
						apmaslSheet1.SetCellValue(gPRow,"jikweeCd",(rv["jikweeCd"]));
						apmaslSheet1.SetCellValue(gPRow,"jikchakNm",(rv["jikchakNm"]));
						apmaslSheet1.SetCellValue(gPRow,"jikchakCd",(rv["jikchakCd"]));
						apmaslSheet1.SetCellValue(gPRow,"jobCd",(rv["jobCd"]));
						apmaslSheet1.SetCellValue(gPRow,"jobNm",(rv["jobNm"]));
					}
				}
			]
		});

 		var appSeqCdList	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00003&searchUseYn=Y"+seqCdParam,false).codeList, "");
		apmaslSheet1.SetColProperty("appSeqCd",	{ComboText:"|"+appSeqCdList[0], ComboCode:"|"+appSeqCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		var sheetHeight = $(".modal_body").height() - $("#apmaslSheet1Form").height() - $(".sheet_title").height() - 2;
		apmaslSheet1.SetSheetHeight(sheetHeight);

		doAction1("Search");
	});


	function doAction1(sAction){
		//removeErrMsg();
		switch(sAction){
		case "Search":		//조회
			if ($("#searchAppraisalCd").val() == "" || $("#searchAppStepCd").val() == "" || $("#searchAppOrgCd").val() == "" || $("#searchSabun").val() == "") {
				alert("평가대상자가 존재하지 않습니다. \n팝업을 닫고 평가대상자를 입력하시기 바랍니다.");
				return;
			}
			apmaslSheet1.DoSearch("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrList2", $("#apmaslSheet1Form").serialize());
			break;

		case "Save":		//저장
			if(apmaslSheet1.FindStatusRow("I") != ""){
				if(!dupChk(apmaslSheet1,"appraisalCd|appStepCd|sabun|appOrgCd|appSeqCd|appSabun", true, true)){break;}
			}
			 //상사평가 갯수 체크
			var chk = 0;
			for(var i = apmaslSheet1.HeaderRows(); i < apmaslSheet1.RowCount()+apmaslSheet1.HeaderRows() ; i++) {
				if( apmaslSheet1.GetCellValue(i, "sStatus") != "D" && apmaslSheet1.GetCellValue(i, "appSeqCd") == "3" ){
					chk++;
				}
			}
			/*
			if( chk > 1 ){
				alert("상사평가자는 1명만 등록 가능합니다.");
				return;
			}
			*/
			IBS_SaveName(document.apmaslSheet1Form,apmaslSheet1);
			apmaslSheet1.DoSave( "${ctx}/AppPeopleMgr.do?cmd=saveAppPeopleMgr2" , $("#apmaslSheet1Form").serialize());
			break;

		case "Insert":		//입력
			if ($("#searchAppraisalCd").val() == "" || $("#searchAppStepCd").val() == "" || $("#searchAppOrgCd").val() == "" || $("#searchSabun").val() == "") {
				alert("평가대상자가 존재하지 않습니다. \n팝업을 닫고 평가대상자를 입력하시기 바랍니다.");
				return;
			}

			var Row = apmaslSheet1.DataInsert(0);
			apmaslSheet1.SetCellValue(Row, "appraisalCd",	$("#searchAppraisalCd").val());
			apmaslSheet1.SetCellValue(Row, "sabun",		$("#searchSabun").val());
			apmaslSheet1.SetCellValue(Row, "appOrgCd",	$("#searchAppOrgCd").val());
			apmaslSheet1.SetCellValue(Row, "appStepCd",	$("#searchAppStepCd").val());
			apmaslSheet1.SetCellValue(Row, "appOrgNm",	$("#searchAppOrgNm").val());
			break;

		case "Copy":		//행복사
			var Row = apmaslSheet1.DataCopy();
			break;

		case "Clear":		//Clear
			apmaslSheet1.RemoveAll();
			break;

		case "Down2Excel":	//엑셀내려받기
			apmaslSheet1.Down2Excel({DownCols:makeHiddenSkipCol(apmaslSheet1),SheetDesign:1,Merge:1});
			break;

		case "LoadExcel":	//엑셀업로드
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			apmaslSheet1.LoadExcel(params);
			break;
		}
	}

	//조회 후 에러 메시지
	function apmaslSheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function apmaslSheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg);
			}
			if ( Code != "-1" ) {
				isSave = true;
				doAction1("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
	function apmaslSheet1_OnPopupClick(Row, Col){
		try{
			if( apmaslSheet1.ColSaveName(Col) == "appName" ) {
				if(!isPopup()) {return;}

				var args	= new Array();

				gPRow = Row;
				pGubun = "employeePopup";

				openPopup("/Popup.do?cmd=employeePopup", args, "740","520");

			}else if( apmaslSheet1.ColSaveName(Col) == "appGroupNm" ) {
				if(!isPopup()) {return;}

				var args = new Array();
				args["searchAppraisalCd"] = apmaslSheet1.GetCellValue(Row, "appraisalCd");
				args["searchAppSeqCd"] = apmaslSheet1.GetCellValue(Row, "appSeqCd");

				let modalLayer = new window.top.document.LayerModal({
					id: 'appPeopleMgrLayer',
					url: '${ctx}/AppPeopleMgr.do?cmd=viewAppPeopleMgrLayer',
					parameters: args,
					width: 500,
					height: 600,
					title: '평가그룹조회',
					trigger: [
						{
							name: 'appPeopleMgrLayerTrigger',
							callback: function(rv) {
								apmaslSheet1.SetCellValue(Row,"appGroupCd",(rv["appGroupCd"]));
								apmaslSheet1.SetCellValue(Row,"appGroupNm",(rv["appGroupNm"]));
							}
						}
					]
				});
				modalLayer.show();
			}

		}catch(ex){
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		//var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup"){
			apmaslSheet1.SetCellValue(gPRow,"appName",(rv["name"]));
			apmaslSheet1.SetCellValue(gPRow,"appSabun",(rv["sabun"]));
			apmaslSheet1.SetCellValue(gPRow,"orgCd",(rv["orgCd"]));
			apmaslSheet1.SetCellValue(gPRow,"orgNm",(rv["orgNm"]));
			apmaslSheet1.SetCellValue(gPRow,"jikgubNm",(rv["jikgubNm"]));
			apmaslSheet1.SetCellValue(gPRow,"jikgubCd",(rv["jikgubCd"]));
			apmaslSheet1.SetCellValue(gPRow,"jikweeNm",(rv["jikweeNm"]));
			apmaslSheet1.SetCellValue(gPRow,"jikweeCd",(rv["jikweeCd"]));
			apmaslSheet1.SetCellValue(gPRow,"jikchakNm",(rv["jikchakNm"]));
			apmaslSheet1.SetCellValue(gPRow,"jikchakCd",(rv["jikchakCd"]));
			apmaslSheet1.SetCellValue(gPRow,"jobCd",(rv["jobCd"]));
			apmaslSheet1.SetCellValue(gPRow,"jobNm",(rv["jobNm"]));
        } else if(pGubun == "appPeopleMgrPop") {
			apmaslSheet1.SetCellValue(gPRow,"appGroupCd",(rv["appGroupCd"]));
			apmaslSheet1.SetCellValue(gPRow,"appGroupNm",(rv["appGroupNm"]));
		}
	}

	function setValue() {
		const p = {};
		var modal = window.top.document.LayerModalUtility.getModal('appPeopleMgrAppSabunLayer');
		modal.fire(LAYER.Trigger, p).hide();

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">

	<div class="modal_body">
		<form id="apmaslSheet1Form" name="apmaslSheet1Form" >
			<input type="hidden" name="searchAppraisalCd" id="searchAppraisalCd" value="">
			<input type="hidden" name="searchAppStepCd" id="searchAppStepCd" value="">
			<input type="hidden" name="searchAppOrgCd" id="searchAppOrgCd" value="">
			<input type="hidden" name="searchSabun" id="searchSabun" value="">
			<input type="hidden" name="appTypeCd" id="appTypeCd" value="">

			<div class="sheet_search outer">
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<span id="searchAppraisalNm" class="txt" style="font-weight:normal"></span>
						</td>
						<td>
							<span>평가대상자</span>
							<span id="searchName" class="txt" style="font-weight:normal"></span>
						</td>
						<td>
							<span>평가소속</span>
							<span id="searchAppOrgNm" class="txt" style="font-weight:normal"></span>
						</td>
						<td>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
					<div class="inner">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt">평가자</li>
								<li class="txt sub-txt point-red">*상사평가,동료평가의 평가자 변경 시 역량평가표를 재생성 해야 합니다.</li>
								<li class="btn">
									<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
									<a href="javascript:doAction1('Copy')" 	class="btn outline-gray authA">복사</a>
									<a href="javascript:doAction1('Insert')" class="btn outline-gray authA">입력</a>
									<a href="javascript:doAction1('Save')" 	class="btn filled authA">저장</a>
								</li>
							</ul>
						</div>
					</div>
					<div id="DIV_apmaslSheet1"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<a href="javascript:closeCommonLayer('appPeopleMgrAppSabunLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>