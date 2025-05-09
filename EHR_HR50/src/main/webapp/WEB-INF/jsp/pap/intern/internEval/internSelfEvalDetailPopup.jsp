<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>타인평가상세팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var param = {};	
	var convertParam = {};
	var vaViewIds;
	var pGubun;
	var gPRow;
	
	$(function() {
		//$("#detailList").css("height", window.innerHeight - 40);
		$("#detailList").css("height", "95vh");
	})
	
	
	$(function() {
		param = '${Param}';
		convertParam = convertMap(param);
		var appStatus = convertParam.appStatus;// 구분값
		$("#sabun").val(convertParam.sabun)
		$("#appStatus").val(convertParam.appStatus);
		$("#appraisalCd").val(convertParam.appraisalCd);
		$("#appSabun").val(convertParam.appSabun);
		if (appStatus == "1") {
			$("#sheet_btn").show();
			$("#sheet_btn2").hide();
		} else if (appStatus == "3") {
			$("#sheet_btn").hide();
			$("#sheet_btn2").show();
		} 
		var title = param.title + "|" + param.title;
		var isHidden = appStatus != "1";
		var initdata = {};
		initdata.Cfg = {SizeMode:0,FrozenCol:0, SearchMode:smLazyLoad,Page:22,MergeSheet:msFixedMerge + msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",			Hidden:1, 	Width:0,	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",    		Type:"${sDelTy}",			Hidden:1,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sDel",	Sort:0 },	
			{Header:"상태",			Type:"${sSttTy}",			Hidden:isHidden,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"선택",			Type:"DummyCheck",			Hidden:1, 	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"chk",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TrueValue:"Y", FalseValue:"N" },
			
			{Header:"평가주기",				Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"examDt",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"작성기간",				Type:"Text",		Hidden:0,	Width:160,	Align:"Left",	ColMerge:0,	SaveName:"appDt",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"진행상태", 			Type:"Combo",  		Hidden:0, 	Width:60, 	Align:"Left", 	ColMerge:0, SaveName:"appStatCd", 	Format:"", 				UpdateEdit:0, 	InsertEdit:0 },
			{Header:"업무내용 및 진행방법",	Type:"Text",		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"weekMemo",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1,	VAlign:"Top"},
			{Header:"개선점 및 교육",		Type:"Text",		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"weekFeed",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		MultiLineText:1, Wrap:1,	VAlign:"Top"},
			{Header:"첨부파일",				Type:"Html",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",	PointCount:0, UpdateEdit:1,	 InsertEdit:0,	 EditLen:35 },
			{Header:"파일순번", 			Type:"Text", 		Hidden:1, 	Width:0, 	Align:"Center", ColMerge:0,	SaveName:"fileSeq", 	KeyField:0, Format:"", 	UpdateEdit:1, InsertEdit:0 },
			
			{Header:"",						Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sabun",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"",						Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"",						Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"appStepCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"",						Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"appSeqDetail",KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"",						Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"appSabun",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"",						Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"memo",		KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:4000},
			{Header:"",						Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"enableYn",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"",						Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"evalAppStatCd",KeyField:0,			UpdateEdit:0,	InsertEdit:0,		EditLen:100},
			{Header:"",						Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"defaultSelectYn",KeyField:0,			UpdateEdit:0,	InsertEdit:0,		EditLen:100},
		];
		if (appStatus == "3") {
			initdata.Cols.push({Header:"",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"evalAppraisalCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100});
			initdata.Cols.push({Header:"",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"evalSabun",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100});
			initdata.Cols.push({Header:"",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"evalAppStepCd",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100});
			initdata.Cols.push({Header:"",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"evalAppSeqDetail",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100});
			initdata.Cols.push({Header:"",	Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"evalAppSabun",	KeyField:0,				UpdateEdit:0,	InsertEdit:0,		EditLen:100});
		}
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(0);sheet1.SetUnicodeByte(3);
		//sheet1.FocusAfterProcess = false;
		//sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		//sheet1.FitColWidth();
		sheet1.SetDataRowHeight(60);
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		//if (appStatus == "3") {
		//	sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		//}
        
		var appStatCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20021"), "");	//P20021:평가진행상태
		sheet1.SetColProperty("appStatCd",		{ComboText:appStatCdList[0], ComboCode:appStatCdList[1]} );
		$(window).smartresize(sheetResize); 
		sheetInit();
		doAction1("Search");
	});
	
	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": //조회
				var url = "${ctx}/InternEval.do?cmd=getInternSelfEvalDetailPopupList";
				if ($("#appStatus").val() == 3) {
					url = "${ctx}/InternEval.do?cmd=getInternSelfEvalDetailPopupList2";
				}
			    sheet1.DoSearch(url, $("#empForm").serialize());
	            break;
			case "Agree2":
				var row = sheet1.GetSelectRow();
				sheet1.SetCellValue(row, "memo", $("#txtMemo").val());
			case "Save":
			case "Agree":
			
				var btn = sAction == "Save" ? "btnSave" : sAction == "Agree" ? "btnAgree" : sAction == "Agree2" ? "btnAgree2" : "";
				if (!confirm($("#"+btn).html() + "을(를) 진행하시겠습니까?")) return false;
				
				IBS_SaveName(document.empForm,sheet1);                                                                           
				sheet1.DoSave("${ctx}/InternEval.do?cmd=saveInternSelfEvalDetailPopup&action="+sAction, $("#empForm").serialize(), 0, 0);
				break;
		}
    } 
	
	// 조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg); 
			}
			var isEnableData = false;
			var btnFileTxt = "";
			var selectRow = null;
			if (isPgmStatus("1")) {
				for(var i = sheet1.GetDataFirstRow(); i <= sheet1.GetDataLastRow() ; i++) {
					btnFileTxt = "다운로드";
					//sheet1.SetRowEditable(i, 1);
					if (sheet1.GetCellValue(i, "enableYn") == "Y") { // 입력가능한 	
						sheet1.SetRowBackColor(i, "#FFFFFF");
						sheet1.SetCellFontColor(i, "examDt", "blue");
						sheet1.SetCellFontColor(i, "appDt", "blue");
						sheet1.SetCellFontColor(i, "appStatCd", "blue");
						sheet1.SetRowEditable(i, 0);
						sheet1.SetCellEditable(i, "weekMemo", 1);
						sheet1.SetCellEditable(i, "weekFeed", 1);
						btnFileTxt = "업로드";
						isEnableData = true;
						selectRow = i;
					}
					if (sheet1.GetCellValue(i, "defaultSelectYn") == "Y" && !selectRow) {
						selectRow = i;
					}
					
					sheet1.SetCellValue(i, "btnFile", '<btn:a id="btn" css="basic" mid='110698' mdef="'+btnFileTxt+'"/>', false);
					sheet1.SetCellValue(i, "sStatus", 'R', false);
					
					if (selectRow) {
						sheet1.SelectCell(selectRow, "weekMemo", 1);
					}
				}
				
				if (isEnableData) {
					$("#btnSave, #btnAgree").show();
					$("#txtComent").hide();
				} else {
					$("#btnSave, #btnAgree").hide();
					$("#txtComent").show();
				}
			} else if (isPgmStatus("3")) {
				for(var i = sheet1.GetDataFirstRow(); i <= sheet1.GetDataLastRow() ; i++) {
					btnFileTxt = "다운로드";
					//sheet1.SetRowEditable(i, 1);
					if (sheet1.GetCellValue(i, "enableYn") == "Y") { // 입력가능한 데이터
						//sheet1.SetRowBackColor(i, "#FFFFFF");
						sheet1.SetCellFontColor(i, "examDt", "blue");
						sheet1.SetCellFontColor(i, "appDt", "blue");
						sheet1.SetCellFontColor(i, "appStatCd", "blue");
						//sheet1.SetRowEditable(i, 0);
						sheet1.SelectCell(i, "weekMemo", 1);
						//sheet1.SetSelectRow(i);
						isEnableData = true;
					}
					sheet1.SetCellValue(i, "btnFile", '<btn:a id="btn" css="basic" mid='110698' mdef="'+btnFileTxt+'"/>', false);
					sheet1.SetCellValue(i, "sStatus", 'R', false);
				}
			}
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
	
	// 클릭 시 
	function sheet1_OnClick(Row, Col, Value, a, b, c) {
		try{
			if (Row < sheet1.GetDataFirstRow() || Row > sheet1.GetDataLastRow()) return false;
			
			if(sheet1.ColSaveName(Col) == "btnFile"){
				if (event.target.id != "btn") return;
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				gPRow = Row;
				pGubun = "fileUpload";
				var authPg = isPgmStatus("1") && sheet1.GetCellValue(Row,"enableYn") == "Y" ? "A" : "R";
				//window.top.openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPg+"&uploadType=internWeek", param, "740","620");
				this.openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPg+"&uploadType=internWeek", param, "740","500");
			}
			
	  	}catch(ex){
	  		alert("OnClick Event Error : " + ex);
	  	}
	}
	
	//<!--셀에 마우스 클릭했을때 발생하는 이벤트-->
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			var Row = NewRow;
			if (Row < sheet1.GetDataFirstRow() || Row > sheet1.GetDataLastRow()) return false;
			if ( OldRow == NewRow ) return;
			$("#txtMemo").val(sheet1.GetCellValue(Row, "memo"));
			
			if (isPgmStatus("3") && sheet1.GetCellValue(Row, "enableYn") == "Y") { // 기간및 활성화여부에 따른 입력 컨트롤 활성화
				$("#txtMemo").attr("readonly", false);
				$("#txtMemo").removeClass("transparent");
				$("#btnAgree2").show();
				$("#txtComent2").hide();
			} else {
				$("#txtMemo").attr("readonly", true);
				$("#txtMemo").addClass("transparent");
				$("#btnAgree2").hide();
				$("#txtComent2").show();
			}
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	
	function isPgmStatus(pStatus) {
		return $("#appStatus").val() == pStatus;
	}
	
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { 
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	
	function onView(){
		//console.log("searchMenuLayer.jsp onView()");
		
		sheetResize();
		//setTimeout(function(){ sheetResize(); $("#searchText").focus();},100);
	}
	
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "fileUpload"){
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		}
	}
	
</script>
<style type="text/css">
	#timelineBox {
		display: flex;
		height: 100%;
	}

	.sheet_search, .cbp_tmtimeline * {
		box-sizing:initial;
	}
	
	#detailList {
		background-color:#f7f7f7;
		padding:0px;
		border:0px solid #ebeef3;
		overflow-x:hidden;
		overflow-y:auto;
		min-width:200px;
	}
	
	.tile-stats.card-profile {
		padding:0px;
		cursor:pointer;
		display: flex;
		font-weight: normal;
	}
	
	.tile-stats.card-profile.choose {
		background-color:#fad5e6;
		font-weight: bold;
	}
	
	.tile-stats.card-profile .profile_info {
		width:calc(100% - 81px);
	}
	
	.tile-stats.card-profile .profile_info .profile_desc {
		width:100%;
	}
	
	.profile_desc {
		margin-left: 20px;
		margin-top: 5px;
	}
	
	.profile_desc>li {
		margin-bottom: 2px;
	}
	
	.tile-stats.card-profile .profile_info .profile_desc li.full {
		width:100%;
	}
	
	.tile-stats.card-profile .profile_img img {
		width:50px;
		height:60px;
	}
	
	.table tr:eq(1) tr:eq(0) th {
		text-align: center;
	}
	
	#divSch {
		display: flex;
	}
	
	#txtSch {
		color: #495057;
		font-weight: bold;
		margin-left: auto;
		/*justify-content: flex-end;*/
	}
	
	#divContent {
		min-width: 400px;
		border:1px solid #ebeef3; 
		padding:10px; 
		height:calc(100% - 25px);
		width:100%;
		display: flow;
	}
	
	#txtSch.on {
		color: red;
		animation: blink-effect 1s step-end infinite;
	}
	@keyframes blink-effect {
    50%{
        opacity:0.5;
    	}
	}
	
	span.required::before {
		content: '* ';
	    color: red;
	}
	
	.resizeVertical { 
		resize: vertical;
		overflow: hidden;
		vertical-align: top;
	}
	
	
	#divHeaderInfo tr th {
		text-align:center;
	}
	
	.tableTarget {
		width: 100%;
		min-height: 65px;  
	}
	
	table#tableFinInfo tr th {
		width: 100px;
	}
</style>
</head>
<body>
<div class="wrapper">
	<form id="empForm" name="empForm" style="height:100%; width:100%;">
		<input type="hidden" id="searchYmd" name="searchYmd" value="${ curSysYyyyMMdd }" />
		<input type="hidden" id="sabun" name="sabun"/>
		<input type="hidden" id="appStatus" name="appStatus"/>
		<input type="hidden" id="appraisalCd" name="appraisalCd"/>
		<input type="hidden" id="appSabun" name="appSabun"/>
		<div id="timelineBox" border="0" cellspacing="0" cellpadding="0" style="height:100%; width:100%;">
			<div name="divContent" id="divContent" class="list_box" style="height:100%; width:100%;"">
				<div id="layout"  style="height:calc(100% - 180px); width:100%;">
					<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
						<tr>
							<td>
								<div class="inner">
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">수습 OJT 주간일지</li>
											<li id="sheet_btn" class="btn" style="display: none;">
											<!-- <a href="javascript:doAction1('Search')" class="basic">조회</a> -->
											<a href="javascript:doAction1('Save')" id="btnSave" class="basic pink">임시저장</a>
											<a href="javascript:doAction1('Agree')" id="btnAgree" class="basic pink">확인요청</a>
											<span id="txtComent" style="padding: 5px 5px;color: white;background-color: darkgray;border-radius: 10px; display: none;">주간일지 작성기간이 아닙니다.</span>
											</li>
										</ul>
									</div>
								</div>
								<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
							</td>
						</tr>
					</table>	
				</div>
				<div class="outer" style="height:calc(100% - (100% - 180px))">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">주간 업무평가 및 업무 참고사항 (수습사원에게 하는 조언)</li>
							<li id="sheet_btn2" class="btn" style="display: none;">
								<!-- <a href="javascript:doAction1('Search')" class="basic">조회</a> -->
								<a href="javascript:doAction1('Agree2')" id="btnAgree2" class="basic pink">작성완료</a>
								<span id="txtComent2" style="padding: 5px 5px;color: white;background-color: darkgray;border-radius: 10px; display: none;">의견 작성기간이 아닙니다.</span>
							</li>
						</ul>
					</div>
					<div style="height:calc(100% - 40px); width:100%; overflow-y: auto;">
						<table name="tableInfo" id="tableInfo" border="0" cellpadding="0" cellspacing="0" class="default" style="width:100%; height:100%;">
								<colgroup>
									<col width="*" />
								</colgroup>	
								<td><textarea id="txtMemo" name="txtMemo" class="${textCss} w100p required" ${readonly}  maxlength="4000" style="width:100%; height:90%;"></textarea></td>
						</table>
					</div>
					<!-- <textarea id="txtMemo" name="txtMemo" rows="7" class=" w100p required" ${readonly}  maxlength="4000" ></textarea> -->
				</div>							
			</div>
		</div>
	</form>
</div>
</body>
</html>



