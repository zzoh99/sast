<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var isValid = true;

	$(function() {

		$("#searchEduSYmd").datepicker2({startdate:"searchEduEYmd", onReturn: getCommonCodeList});
		$("#searchEduEYmd").datepicker2({enddate:"searchEduSYmd", onReturn: getCommonCodeList});

		$("#searchEduSYmd").val( addDate("d", -30, "${curSysYyyyMMddHyphen}", "-") ) ;
		$("#searchEduEYmd").val("${curSysYyyyMMddHyphen}") ;

		$("#searchEduBranchCd, #searchEduMBranchCd, #searchInOutType, #searchFinishYn, #searchEduMethodCd, #searchEduConfirmType").bind("change", function() {
			doAction1("Search");
		});

		$("#searchEduCourseNm, #searchName, #searchEduEventNm, #searchEduSYmd, #searchEduEYmd, #searchOrgNm, #searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});



		$("#eduConfirmType").html("<option value='0'>미수료</option><option value='1'>수료</option>");

		var msg = {};
		//msg.chk = "체크해주세요";
		setValidate( $("#sheet1Form"),msg );


		init_sheet();
		
		doAction1("Search");
	});

	

	function init_sheet(){ 
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:8,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, FrozenColRight:4};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
				
			{Header:"교육\n신청", 		Type:"Image",  		Hidden:0, Width:45,  	Align:"Center", ColMerge:0,  SaveName:"detail1",     	Edit:0, Cursor:"Pointer" },
			{Header:"결과\n보고", 		Type:"Image",  		Hidden:0, Width:45,  	Align:"Center", ColMerge:0,  SaveName:"detail2",     	Edit:0, Cursor:"Pointer" },

			{Header:"사번",			Type:"Text",   		Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"sabun", 			KeyField:1,	Edit:0},
			{Header:"성명",			Type:"Text",   		Hidden:0, Width:80,		Align:"Center", ColMerge:0,  SaveName:"name", 			UpdateEdit:0,	InsertEdit:1 },
			{Header:"부서",			Type:"Text",   		Hidden:0, Width:120, 	Align:"Left",   ColMerge:0,  SaveName:"orgNm", 			Edit:0},
			{Header:"직책",			Type:"Text",   		Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		Edit:0},
			{Header:"직위",			Type:"Text",   		Hidden:Number("${jwHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikweeNm", 		Edit:0},
			{Header:"직급",			Type:"Text",   		Hidden:Number("${jgHdn}"), Width:80, 	Align:"Center", ColMerge:0,  SaveName:"jikgubNm", 		Edit:0},
			{Header:"직군",			Type:"Text",   		Hidden:0, Width:80, 	Align:"Center", ColMerge:0,  SaveName:"worktypeNm", 		Edit:0},
			
			{Header:"과정코드",		Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduSeq",			KeyField:1,	Format:"",		Edit:0},
			{Header:"과정명",		Type:"Popup",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:0,	Format:"",		UpdateEdit:0,	InsertEdit:1 },
			{Header:"교육시작일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduSYmd",			KeyField:1,	Format:"Ymd",	Edit:0},	
			{Header:"교육종료일",		Type:"Date",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"eduEYmd",			KeyField:1,	Format:"Ymd",	Edit:0},	
			{Header:"사내/외",		Type:"Combo",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"inOutType",		KeyField:0,	Format:"",		Edit:0},
			{Header:"시행방법",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduMethodCd",		KeyField:0,	Format:"",		Edit:0},
			{Header:"교육구분",		Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduBranchCd",		KeyField:0,	Format:"",		Edit:0},
			{Header:"교육분류",		Type:"Combo",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduMBranchCd",	KeyField:0,	Format:"",		Edit:0},
			{Header:"교육기관",		Type:"Text",		Hidden:0,	Width:110,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgNm",		KeyField:0,	Format:"",		Edit:0},
			{Header:"직무코드",		Type:"Text",		Hidden:0,	Width:110,	Align:"Left",	ColMerge:0,	SaveName:"jobCd",			KeyField:0,	Format:"",		Edit:0},
			{Header:"직무명",		Type:"Popup",		Hidden:0,	Width:110,	Align:"Left",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"강의난이도",		Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduLevel",		KeyField:0,	Format:"",		Edit:0},
			{Header:"교육비용",		Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"realExpenseMon",	KeyField:0,	Format:"",		Edit:0},
			{Header:"고용보험\n적용여부",	Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"laborApplyYn",	KeyField:0,	Format:"",		Edit:0},	
			
			//Hidden
  			{Header:"Hidden",	Hidden:1, SaveName:"eduEventSeq"},
  			{Header:"Hidden",	Hidden:1, SaveName:"eduOrgCd"},
  			{Header:"Hidden",	Hidden:1, SaveName:"jobCd"},
  			{Header:"Hidden",	Hidden:1, SaveName:"applSeq"},
  			{Header:"Hidden",	Hidden:1, SaveName:"applSeq2"},
  			{Header:"Hidden",	Hidden:1, SaveName:"mailId"},
  		
			{Header:"선택",			Type:"DummyCheck",	Hidden:0,	Width:55,	Align:"Center",	ColMerge:0,	SaveName:"chk",				KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"수료\n여부",		Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduConfirmType",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1 },
			{Header:"미수료사유",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"unconfirmReason",	KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
			{Header:"비고",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",		UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
			
			
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(2,"${ctx}/common/images/icon/icon_x.png");

		
		//공통코드 한번에 조회
		getCommonCodeList();
		sheet1.SetColProperty("laborApplyYn",	{ComboText:"|YES|NO", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("eduConfirmType",	{ComboText:"|수료|미수료", ComboCode:"|1|0"} );

		$(window).smartresize(sheetResize); sheetInit();
		
		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name", rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
					}
				}
			]
		});
	}

	function getCommonCodeList() {
		let grpCds = "L20020,L10010,L10015,L10050,L10190,S10030,L10110,L10090";
		let params = "useYn=Y&grpCd=" + grpCds + "&baseSYmd=" + $("#searchEduSYmd").val() + "&baseEYmd=" + $("#searchEduEYmd").val();
		codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists", params, false).codeList, "전체");

		sheet1.SetColProperty("inOutType", 		{ComboText:"|"+codeLists["L20020"][0], ComboCode:"|"+codeLists["L20020"][1]} );// L20020 사내/외 구분
		sheet1.SetColProperty("eduBranchCd", 	{ComboText:"|"+codeLists["L10010"][0], ComboCode:"|"+codeLists["L10010"][1]} );// L10010 교육구분코드
		sheet1.SetColProperty("eduMBranchCd", 	{ComboText:"|"+codeLists["L10015"][0], ComboCode:"|"+codeLists["L10015"][1]} );// L10015 교육분류코드
		sheet1.SetColProperty("eduMethodCd", 	{ComboText:"|"+codeLists["L10050"][0], ComboCode:"|"+codeLists["L10050"][1]} );// L10050 교육시행방법코드
		sheet1.SetColProperty("eduLevel", 		{ComboText:"|"+codeLists["L10090"][0], ComboCode:"|"+codeLists["L10090"][1]} );// L10090 강의난이도

		$("#searchInOutType").html(codeLists["L20020"][2]);
		$("#searchEduBranchCd").html(codeLists["L10010"][2]);
		$("#searchEduMBranchCd").html(codeLists["L10015"][2]);
		$("#searchEduMethodCd").html(codeLists["L10050"][2]);
	}

	function chkInVal() {

		if ($("#searchEduSYmd").val() == "" && $("#searchEduEYmd").val() != "") {
			alert('교육시작일을 입력하세요.');
			return false;
		}

		if ($("#searchEduSYmd").val() != "" && $("#searchEduEYmd").val() == "") {
			alert('교육종료일을 입력하세요.');
			return false;
		}

		if ($("#searchEduSYmd").val() != "" && $("#searchEduEYmd").val() != "") {
			if (!checkFromToDate($("#searchEduSYmd"),$("#searchEduEYmd"),"교육일자","교육일자","YYYYMMDD")) {
				return false;
			}
		}
		return true;
	}
	/**
	* Sheet 각종 처리
	*/
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				if(!chkInVal()){break;}
				sheet1.DoSearch( "${ctx}/EduHistoryLst.do?cmd=getEduHistoryLstList", $("#sheet1Form").serialize() );
				break;
			case "Save":		//저장
				isValid = true;
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/EduHistoryLst.do?cmd=saveEduHistoryLst", $("#sheet1Form").serialize() );
				break;

			case "Insert":		//입력
				var Row = sheet1.DataInsert(0);
				sheet1.SelectCell(Row, "name");
				break;

			case "Copy":		//행복사
				var Row = sheet1.DataCopy();
				sheet1.SelectCell(Row, "name");
				sheet1.SetCellValue(Row, "detail1", "");
				sheet1.SetCellValue(Row, "detail2", "");
				break;
				
			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드
			
				if( $("#upEduSeq").val() == ""){
					alert("업로드할 교육과정을 선택 해주세요.");
					return;
				}

				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
			
				break;

			case "DownTemplate":
				var downcol = "sabun|eduSeq|eduSYmd|eduEYmd|jobCd|eduConfirmType|note";
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:downcol});
				break;

		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			
			progressBar(false);
			
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "detail1" && Value != ""  ) {
		    	showApplPopup( Row );
		    	
		    }else if( sheet1.ColSaveName(Col) == "detail2" && Value != "" ) {
			   	showApplPopup2( Row );
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 셀 팝업 클릭 시
	function sheet1_OnPopupClick(Row, Col) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
			if (sheet1.ColSaveName(Col) == "eduCourseNm") {  //과정선택
				
				if (!isPopup()) {  return; }
				let modalLayer = new window.top.document.LayerModal({
					id: 'eduCourseEvtLayer',
					url: '/Popup.do?cmd=viewEduCourseEvtLayer&authPg=R',
					parameters: {},
					width: 950,
					height: 620,
					title: '필수교육과정 선택',
					trigger: [
						{
							name: 'eduCourseEvtLayerTrigger',
							callback: function(rv) {
								sheet1.SetCellValue(gPRow, "eduSeq", 		rv["eduSeq"]);
								sheet1.SetCellValue(gPRow, "eduEventSeq", 	rv["eduEventSeq"]);
								sheet1.SetCellValue(gPRow, "eduSYmd", 		rv["eduSYmd"]);
								sheet1.SetCellValue(gPRow, "eduEYmd", 		rv["eduEYmd"]);
								sheet1.SetCellValue(gPRow, "eduCourseNm", 	rv["eduCourseNm"]);
								sheet1.SetCellValue(gPRow, "eduBranchCd", 	rv["eduBranchCd"]);
								sheet1.SetCellValue(gPRow, "eduMBranchCd", 	rv["eduMBranchCd"]);
								sheet1.SetCellValue(gPRow, "inOutType", 	rv["inOutType"]);
								sheet1.SetCellValue(gPRow, "eduMethodCd", 	rv["eduMethodCd"]);
								sheet1.SetCellValue(gPRow, "jobCd", 		rv["jobCd"]);
								sheet1.SetCellValue(gPRow, "jobNm", 		rv["jobNm"]);
								sheet1.SetCellValue(gPRow, "eduOrgCd", 		rv["eduOrgCd"]);
								sheet1.SetCellValue(gPRow, "eduOrgNm", 		rv["eduOrgNm"]);
								sheet1.SetCellValue(gPRow, "eduLevel", 		rv["eduLevel"]);
								sheet1.SetCellValue(gPRow, "realExpenseMon",rv["realExpenseMon"]);
								sheet1.SetCellValue(gPRow, "laborApplyYn", 	rv["laborApplyYn"]);
							}
						}
					]
				});
				modalLayer.show();

			} else if (sheet1.ColSaveName(Col) == "jobNm") {  //관련직무
				if (!isPopup()) {  return; }
				gPRow = Row;

				new window.top.document.LayerModal({
					id : 'jobPopupLayer'
					, url : '/Popup.do?cmd=jobPopup&authPg=R'
					, parameters: {}
					, width : 800
					, height : 800
					, title : "직무 리스트 조회"
					, trigger :[
						{
							name : 'jobPopupTrigger'
							, callback : function(rv){
								sheet1.SetCellValue(gPRow, "jobCd", rv["jobCd"]);
								sheet1.SetCellValue(gPRow, "jobNm", rv["jobNm"]);
							}
						}
					]
				}).show();
			}

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// 엑셀업로드 후 저장 처리
	function sheet1_OnLoadExcel(result) {
		try {
			if(result) {

				isValid = false;

				progressBar(true, "처리 중입니다. 잠시만 기다려주세요.");
				
				setTimeout(
					function(){
			            IBS_SaveName(document.sheet1Form, sheet1);
						var params = $("#sheet1Form").serialize()+"&"+sheet1.GetSaveString(0);
						var sXml = sheet1.GetSearchData("${ctx}/EduHistoryLst.do?cmd=getEduHistoryLstChk", params );
						sheet1.LoadSearchData(sXml );
					}
				, 100);
				
				
			} else {
				alert("엑셀파일 로드 중 오류가 발생하였습니다.");
			}

		} catch (ex) {
			alert("OnLoadExcel Event Error : " + ex);
		}
	}

	// 저장전 체크
	function sheet1_OnValidation(Row, Col, Value) {
		try {
			if( !isValid ) return;
			if( sheet1.ColSaveName(Col) == "eduEventSeq" && Value == ""  ) {
				alert("해당 과정의 회차가 없어 등록할 수 없습니다.");
				sheet1.ValidateFail(1);
				sheet1.SetRowBackColor(Row, "#fdf0f5");
			}
		} catch (ex) {
			alert("OnValidation Event Error " + ex);
		}
	}
	//-----------------------------------------------------------------------------------
	//		신청 팝업
	//-----------------------------------------------------------------------------------
	function showApplPopup( Row ) {
		if(!isPopup()) {return;}
		var args = new Array(5);
		var url = "/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
		var p = {
				searchApplCd: '130'
			  , searchApplSeq: sheet1.GetCellValue(Row,"applSeq")
			  , adminYn: 'N'
			  , authPg: 'R'
			  , searchSabun: ''
			  , searchApplSabun: ''
			  , searchApplYmd: '' 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '신청서',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
					}
				}
			]
		});
		approvalMgrLayer.show();
	}


	//-----------------------------------------------------------------------------------
	//		 결과보고
	//-----------------------------------------------------------------------------------
	function showApplPopup2( Row ) {
		if(!isPopup()) {return;}
		var args = new Array(5);
		var url = '/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer';
		var initFunc = 'initResultLayer';
		var p = {
				searchApplCd: '131'
			  , searchApplSeq: sheet1.GetCellValue(Row,"applSeq2")
			  , adminYn: 'N'
			  , authPg: 'R'
			  , searchSabun: ''
			  , searchApplSabun: ''
			  , searchApplYmd: '' 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '신청서',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
					}
				}
			]
		});
		approvalMgrLayer.show();
	}

	function setEduConfirmType() {
		var rowsSerialize = sheet1.FindCheckedRow("chk");
		if (rowsSerialize=="") {
			alert("선택 된 값이 없습니다.");
		} else {
			var rows = rowsSerialize.split('|');
			for (var i = 0; i < rows.length; i++) {
				sheet1.SetCellValue(rows[i], "eduConfirmType", $("#eduConfirmType").val());
			}
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchEduSeq" name="searchEduSeq">
	<input type="hidden" id="searchEduEventSeq" name="searchEduEventSeq" >
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>교육종료일</th>
			<td>
				<input id="searchEduSYmd" name="searchEduSYmd" type="text" size="10" class="date2" value=""/>
				~ <input id="searchEduEYmd" name="searchEduEYmd" type="text" size="10" class="date2" value=""/>
			</td>
			<th>교육구분</th>
			<td>
				<select id="searchEduBranchCd" name="searchEduBranchCd"></select>
			</td>
			<th>교육분류</th>
			<td>
				<select id="searchEduMBranchCd" name="searchEduMBranchCd"></select>
			</td>
		</tr>
		<tr>
			<th>사내/외</th>
			<td>
				<select id="searchInOutType" name="searchInOutType"></select>
			</td>
			<th>시행방법</th>
			<td>
				<select id="searchEduMethodCd" name="searchEduMethodCd"></select>
			</td>
			<th>수료여부 </th>
			<td>
				<select id="searchEduConfirmType" name="searchEduConfirmType">
					<option value="">  전체  </option>
					<option value="1"> 수료 </option>
					<option value="0"> 미수료 </option>
				</select>
			</td>
		</tr>
		<tr>
			<th>소속</th>
			<td>
				<input type="text" id="searchOrgNm" name="searchOrgNm" class="text w150" style="ime-mode:active;"/>
			</td>
			<th>사번/성명</th>
			<td>
				<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
			</td>
			<th>과정명</th>
			<td>
				<input type="text" id="searchEduCourseNm" name="searchEduCourseNm" class="text w150" style="ime-mode:active;"/>
			</td>
			<td>
				<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>
	<!-- 조회조건 끝 -->
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">교육이력관리</li>
				<li class="btn">
					수료여부&nbsp;&nbsp;<select id="eduConfirmType" name="eduConfirmType"></select>
					<a href="javascript:setEduConfirmType()" class="btn outline-gray authA">적용</a>
					&nbsp;
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('DownTemplate')"	class="btn outline-gray authA">양식다운로드</a>
					<a href="javascript:doAction1('LoadExcel')"		class="btn outline-gray authA">엑셀업로드</a>
					<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save')" 			class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
	
</div>
</body>
</html>
