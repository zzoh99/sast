<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var confirmYn = true;
	var popupGubun = "";
	var gPRow = "";
	var pGubun = "";
	let sheet1SelectedRow = "";
	let sheet1SelectedCol = "";

	// 차수별평가등급
	var orgGradeCdList = "";

	$(function() {

		// 트리레벨 정의
		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});
		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});

		//del, backspace 입력 시 평가배분조직명 초기화
		document.addEventListener("keyup", function(event) {
			if( event.keyCode == 8 || event.keyCode == 46){
				if(sheet1SelectedRow != "" && sheet1SelectedCol != ""){
					if(sheet1SelectedCol == "appGroupOrgNm"){
						sheet1.SetCellValue(sheet1SelectedRow, "appGroupOrgCd", "");
						sheet1.SetCellValue(sheet1SelectedRow, "appGroupOrgNm", "");
					}
				}
			}
		});
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smGeneral,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:25,	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"상위조직코드|상위조직코드",		Type:"Text",		Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"priorOrgCd",    KeyField:1,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"조직코드|조직코드",				Type:"Text",		Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"appOrgCd",      KeyField:1,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"조직명|조직명",				Type:"Popup",		Hidden:0,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"appOrgNm",      KeyField:1,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:50,    TreeCol:1,  LevelSaveName:"sLevel" },
			{Header:"조직평가|구분",				Type:"Combo",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"orgGubunCd",    KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10 }, //조직평가구분은 조직정보 저장 후 수정하는 로직으로 처리
			{Header:"조직평가|등급",				Type:"Combo",		Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"orgGradeCd",    KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10 }, //조직평가등급은 조직정보 저장 후 수정하는 로직으로 처리
			{Header:"조직장|성명",					Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"name",          KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"조직장|사번",					Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"sabun",         KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"조직장|직급",					Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",      KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"조직장|직책",					Type:"Text",		Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",     KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"순서|순서",					Type:"Int",			Hidden:0,  Width:35,   Align:"Right",   ColMerge:0,   SaveName:"seq",           KeyField:0,		CalcLogic:"",   Format:"Integer",   PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:3 },
			{Header:"평가배분조직코드|평가배분조직코드",	Type:"Text",		Hidden:1,  Width:0,    Align:"Left",    ColMerge:0,   SaveName:"appGroupOrgCd", KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"평가배분조직명|평가배분조직명",	Type:"Popup",		Hidden:1,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"appGroupOrgNm", KeyField:0,   	CalcLogic:"",   Format:"",          PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
			{Header:"평가배분조직명|평가배분조직명",	Type:"Image",		Hidden:1,  Width:20,   Align:"Left",    ColMerge:0,   SaveName:"appGrpOrgReset", Cursor:"Pointer" },

			{Header:"조직구분|조직구분",				Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"objectType"},
			{Header:"조직유형|조직유형",				Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"orgType"},
			{Header:"평가ID|평가ID",				Type:"Text",		Hidden:1,  Width:50,   Align:"Center",	ColMerge:1,	  SaveName:"appraisalCd"},
			{Header:"평가단계|평가단계",				Type:"Text",		Hidden:1,  Width:50,   Align:"Center",	ColMerge:1,	  SaveName:"appStepCd"},
			{Header:"조직순서|조직순서",				Type:"Text",		Hidden:1,  Width:50,   Align:"Center",  ColMerge:1,   SaveName:"orgSeq"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_undo.png");
		sheet1.SetDataLinkMouse("appGrpOrgReset",0);

		var appraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdList",false).codeList, "");	//평가명
		$("#searchAppraisalCd").html(appraisalCdList[2]);

		// 조직구분
		var orgGubunCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00006"), ""); // 조직구분(P00006)
		sheet1.SetColProperty("orgGubunCd", 	{ComboText:"|"+orgGubunCdList[0], ComboCode:"|"+orgGubunCdList[1]} );

		// 차수별평가등급
		orgGradeCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getAppSeqClassCode&" + $("#srchFrm").serialize(), false).codeList, ""); //차수별평가등급
		sheet1.SetColProperty("orgGradeCd", 	{ComboText:"|"+orgGradeCdList[0], ComboCode:"|"+orgGradeCdList[1]} );

		// Autocomplete 성명 자동완성 처리
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue) {
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow,"name", rv["name"]);
						sheet1.SetCellValue(gPRow,"sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow,"jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow,"jikgubNm", rv["jikgubNm"]);
					}
				}
			]
		});

		$(window).smartresize(sheetResize); sheetInit();
	});

	$(function() {
		$("#searchAppraisalCd").bind("change",function(event){
			var appStepCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppStepCdList&searchAppraisalCd=" + $(this).val(),false).codeList, "");
			if ( appStepCdList == false ) {
				$("#searchAppStepCd").html("<option value=''>선택하세요</option>");
			} else {
				$("#searchAppStepCd").html(appStepCdList[2]);
				
				// 차수별평가등급
				orgGradeCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getAppSeqClassCode&" + $("#srchFrm").serialize(), false).codeList, ""); //차수별평가등급
				sheet1.SetColProperty("orgGradeCd", 	{ComboText:"|"+orgGradeCdList[0], ComboCode:"|"+orgGradeCdList[1]} );
			}

			doAction1("Search");
		});

		$("#searchAppStepCd").bind("change", function() {
			doAction1("Search");
		});

		$("#searchAppraisalCd").change();
	});

	//Example sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if ($("#searchAppraisalCd").val() == "") {
				alert("평가명을 선택하세요.");
				return;
			}
			if ($("#searchAppStepCd").val() == "") {
				alert("평가단계를 선택하세요.");
				return;
			}
			sheet1.DoSearch( "${ctx}/AppOrgSchemeMgr.do?cmd=getAppOrgSchemeMgrList", $("#srchFrm").serialize(),1 );
			break;
		case "Save":
			if(!dupChk(sheet1,"appOrgCd", true, true)){break;}
			
			//조직평가 구분에 따른 체크로직 추가
			var appraisalCount = 0;
			var text = $("#searchAppraisalCd").val();
			var searchChar = "A";
			var pos = text.indexOf(searchChar);
			while(pos !== -1){
				appraisalCount++;
				pos = text.indexOf(searchChar, pos + 1); // 첫 번째 a 이후의 인덱스부터 a를 찾습니다.
			}

			if(sheet1.RowCount() > 0) {
				for (var i = sheet1.HeaderRows(); i < sheet1.RowCount() + sheet1.HeaderRows(); i++) {
					if(sheet1.GetCellValue( i, "sStatus") == "I" || sheet1.GetCellValue( i, "sStatus") == "U") {
						if( (appraisalCount == "1" && sheet1.GetCellValue( i, "orgGubunCd") != "10") ) { //임원업적평가인 경우 사업부만 가능
							if(sheet1.GetCellValue( i, "orgGubunCd") != ""){
								//alert(sheet1.GetCellValue( i, "appOrgNm")+" 조직평가 구분은 사업부로 변경해주세요.");
								alert("조직평가 구분은 사업부로 변경해주세요.");
								return;
							}
						}
						
						/* if( (appraisalCount == "2" && sheet1.GetCellValue( i, "orgGubunCd") == "10") ) { //MIP/상시평가인 경우 CIC만 가능
							if(sheet1.GetCellValue( i, "orgGubunCd") != ""){
								//alert(sheet1.GetCellValue( i, "appOrgNm")+" 조직평가 구분은 사업부로 변경해주세요.");
								alert("조직평가 구분은 CIC로 변경해주세요.");
								return;
							}
						} */
					}
				}
			}
			
			isNotSaveMsg = false;
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/AppOrgSchemeMgr.do?cmd=saveAppOrgSchemeMgr", $("#srchFrm").serialize() );
			break;
		case "Insert":

			if($("#searchAppraisalCd").val() == "") {
				alert("평가명을 선택하세요.");
				return;
			}

			if($("#searchAppStepCd").val() == "") {
				alert("평가단계를 선택하세요.");
				return;
			}

			if(sheet1.RowCount() > 0 && sheet1.GetCellValue(sheet1.GetSelectRow(), "appOrgCd") == "") {
				alert("조직을 먼저 입력하여 주세요");
				return;
			}

			var Row = sheet1.DataInsert();

			sheet1.SetCellValue(Row,"appraisalCd",$("#searchAppraisalCd").val());
			sheet1.SetCellValue(Row,"appStepCd",$("#searchAppStepCd").val());
			if( Row == 2 ) {
				sheet1.SetCellValue(Row,"priorOrgCd","0");
			} else {
				sheet1.SetCellValue(Row,"priorOrgCd",sheet1.GetCellValue(Row-1, "appOrgCd"));
			}

			sheet1.SelectCell(Row, "appOrgNm");
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "PrcCopy":
			const p = {
				searchAppraisalCd : $("#searchAppraisalCd").val(),
				searchAppStepCd : $("#searchAppStepCd").val()
			};

			var layer = new window.top.document.LayerModal({
				id : 'appOrgCopyLayer'
				, url : '/AppOrgSchemeMgr.do?cmd=viewAppOrgCopyLayer'
				, parameters: p
				, width : 600
				, height : 200
				, title : "조직도복사"
				, trigger :[
					{
						name : 'appOrgCopyLayerTrigger'
						, callback : function(rv){
							doAction1("Search");
						}
					}
				]
			});
			layer.show();

			<%--if(!isPopup()) {return;}--%>

			<%--if ( $("#searchAppraisalCd").val() == "" ) {--%>
			<%--	alert("평가명을 선택해 주세요");--%>
			<%--	return;--%>
			<%--}--%>

			<%--if ( $("#searchAppStepCd").val() == "" ) {--%>
			<%--	alert("평가단계를 선택해 주세요");--%>
			<%--	return;--%>
			<%--}--%>

			<%--var args = new Array();--%>
			<%--args["searchAppraisalCd"] 	= $("#searchAppraisalCd").val();--%>
			<%--args["searchAppStepCd"] 	= $("#searchAppStepCd").val();--%>

			<%--gPRow = "";--%>
			<%--pGubun = "appOrgCopyPop";--%>

			<%--openPopup("${ctx}/AppOrgSchemeMgr.do?cmd=viewAppOrgCopyPop", args, "600","200");--%>
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,TreeLevel:0};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
			break;
		}
	}

	// 조회 후 에러 메시지
	var isNotSaveMsg = false;
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			// 몰래 ORG_SEQ 저장
			var updRow = sheet1.FindStatusRow("U");
			if( updRow != "" && updRow != "-1" ){
				isNotSaveMsg = true;
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/AppOrgSchemeMgr.do?cmd=saveAppOrgSchemeMgr", $("#srchFrm").serialize(), -1, 0 );
			}
			
			//평가단계 최종평가인 경우에만 조직평가 구분/등급을 입력하기 때문에 목표등록인 경우에는 숨김처리하고 최종평가에만 보여지게 처리
			if($("#searchAppStepCd").val() == "5") {
				//sheet1.SetColHidden("orgGubunCd", 0);
				//sheet1.SetColHidden("orgGradeCd", 0);
				//sheet1.SetColHidden("appGroupOrgNm", 0);
				//sheet1.SetColHidden("appGrpOrgReset", 0);
			} else {
				sheet1.SetColHidden("orgGubunCd", 1);
				sheet1.SetColHidden("orgGradeCd", 1);
				sheet1.SetColHidden("appGroupOrgNm", 1);
				sheet1.SetColHidden("appGrpOrgReset", 1);
			}
			
			//평가ID/일정관리에 평가배분유형에 따라 화면 컨트롤 될수 있도록 처리
			var result = ajaxCall( "${ctx}/AppOrgSchemeMgr.do?cmd=getAppOrgSchemeTypeInfo", $("#srchFrm").serialize(),false);
			var appGroupOrgType = "";
			if ( result != null && result.DATA != null ){ 
				appGroupOrgType = result.DATA.appGroupOrgType;
			}
			$("#appGroupOrgType").val(appGroupOrgType);
			
			//1레벨과 2레벨을 제외하고 나머지 레벨인 경우에 유형이 같아야지 등록할 수 있도록 처리
			/* if(sheet1.RowCount() > 0) {
				for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++) {
					if( sheet1.GetCellValue(i, "orgType") == "V" || sheet1.GetCellValue(i, "orgType") == "T" || appGroupOrgType == sheet1.GetCellValue(i, "orgType") ) {
						sheet1.SetCellEditable(i, "orgGubunCd", true);
						sheet1.SetCellEditable(i, "orgGradeCd", true);
						sheet1.SetCellEditable(i, "appGroupOrgNm", false);
					} else {
						sheet1.SetCellEditable(i, "orgGubunCd", false);
						sheet1.SetCellEditable(i, "orgGradeCd", false);
						sheet1.SetCellEditable(i, "appGroupOrgNm", true);
					}
				}
			} */
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if( !isNotSaveMsg  ){
				if (Msg != "") {
					alert(Msg);
				}
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if( sheet1.ColSaveName(Col) == "appOrgNm") {

				new window.top.document.LayerModal({
					id : 'orgLayer'
					, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
					, parameters : {}
					, width : 800
					, height : 720
					, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
					, trigger :[
						{
							name : 'orgTrigger'
							, callback : function(result){
								if(!result.length) return;
								sheet1.SetCellValue(Row, "appOrgCd", result[0].orgCd);
								sheet1.SetCellValue(Row, "appOrgNm", result[0].orgNm);
								sheet1.SetCellValue(Row, "objectType", result[0].objectType);
								sheet1.SetCellValue(Row, "orgType", result[0].orgType);
								sheet1.SetCellValue(Row, "sabun", result[0].chiefSabun);
								sheet1.SetCellValue(Row, "name", result[0].chiefName);
							}
						}
					]
				}).show();
			} else if(sheet1.ColSaveName(Col) == "appGroupOrgNm"){

				new window.top.document.LayerModal({
					id : 'orgLayer'
					, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
					, parameters : {}
					, width : 800
					, height : 720
					, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
					, trigger :[
						{
							name : 'orgTrigger'
							, callback : function(result){
								if(!result.length) return;
								sheet1.SetCellValue(Row, "appGroupOrgCd", result[0].orgCd);
								sheet1.SetCellValue(Row, "appGroupOrgNm", result[0].orgNm);
							}
						}
					]
				}).show();
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;

			let sSaveName = sheet1.ColSaveName(Col);

			if(sSaveName == "appGroupOrgNm"){
				sheet1SelectedRow = Row;
				sheet1SelectedCol = sSaveName;
			} else if(sSaveName == "appGrpOrgReset"){
				sheet1.SetCellValue(Row, "appGroupOrgCd", "");
				sheet1.SetCellValue(Row, "appGroupOrgNm", "");
			}else{
				sheet1SelectedRow = "";
				sheet1SelectedCol = "";
			}

		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="appGroupOrgType" name="appGroupOrgType" />
	
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
						<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
					</td>
				</tr>
			</table>
		</div>
	</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li id="txt" class="txt">평가조직관리&nbsp;
				<div class="util">
				<ul>
					<li	id="btnPlus"></li>
					<li	id="btnStep1"></li>
					<li	id="btnStep2"></li>
					<li	id="btnStep3"></li>
				</ul>
				</div>
			</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
				<a href="javascript:doAction1('Insert')" class="btn outline_gray authA">입력</a>
				<a href="javascript:doAction1('Save')" 	class="btn soft authA">저장</a>
				<a href="javascript:doAction1('PrcCopy')" class="btn filled authA">조직도복사</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>