<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"삭제", 		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0},
			{Header:"상태", 		Type:"${sSttTy}", 	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},

			{Header:"회의실번호",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"meetRoomNo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:23 },
			{Header:"회의실명",	Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"meetRoomNm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
			{Header:"사용용도",	Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"meetUse",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:400 },
  			{Header:"사용여부",	Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"useYn",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"사업장",		Type:"Combo",		Hidden:1,	Width:120,	Align:"Center",	ColMerge:0, SaveName:"businessPlaceCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"담당부서코드",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chargeOrgCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"담당부서",	Type:"Popup",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chargeOrgNm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"담당자사번",	Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chargeSabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"담당자",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chargeName",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"비고",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:400 },
			{Header:"순서",		Type:"Int",			Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",		KeyField:0,	Format:"NullInteger",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:23 }
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// 사업장
		var businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getBusinessPlaceCdList", false).codeList, "");
		sheet1.SetColProperty("businessPlaceCd", {ComboText:businessPlaceCd[0], ComboCode:businessPlaceCd[1]} );
		$("#searchBusinessPlaceCd").html(businessPlaceCd[2]);
		$("#searchBusinessPlaceCd").select2({
			placeholder: "전체"
			, maximumSelectionSize:100
		});

		// 시트 자동완성
		//setSheetAutocompleteEmp( "sheet1", "chargeName");

		// 성명 입력시 자동완성 처리
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "chargeName",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "chargeSabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "chargeName",		rv["name"]);
						sheet1.SetCellValue(gPRow, "chargeOrgCd",		rv["orgCd"]);
						sheet1.SetCellValue(gPRow, "chargeOrgNm",		rv["orgNm"]);
						//sheet1.SetCellValue(gPRow, "manageCd",	rv["manageCd"]);
						//sheet1.SetCellValue(gPRow, "workType",	rv["workType"]);
						//sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
						//sheet1.SetCellValue(gPRow, "resNo",		rv["resNo"]);
						//sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						//sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						//sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
					}
				}
			]
		});		

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#businessPlaceCd").val(($("#searchBusinessPlaceCd").val()==null?"":getMultiSelect($("#searchBusinessPlaceCd").val())));
			sheet1.DoSearch( "${ctx}/MeetRoomMgr.do?cmd=getMeetRoomMgrList", $("#srchFrm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/MeetRoomMgr.do?cmd=saveMeetRoomMgr", $("#srchFrm").serialize());
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SelectCell(Row, "meetRoomNm");
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			sheet1.Down2Excel();
			break;
		}
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

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{

          var colName = sheet1.ColSaveName(Col);
          var args    = new Array();

          args["orgCd"]   = sheet1.GetCellValue(Row, "chargeOrgCd");
          args["orgNm"]  = sheet1.GetCellValue(Row, "chargeOrgNm");

          var rv = null;

          if(colName == "chargeOrgNm") {
        	  	if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "searchOrgBasicPopup";

				openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "sheetAutocompleteEmp") {

        	sheet1.SetCellValue(gPRow, "chargeSabun", rv["sabun"]);
        	sheet1.SetCellValue(gPRow, "chargeName", rv["name"]);
        	sheet1.SetCellValue(gPRow, "chargeOrgCd", rv["orgCd"]);
        	sheet1.SetCellValue(gPRow, "chargeOrgNm", rv["orgNm"]);
        	/*
        	sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
        	sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
        	sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
        	sheet1.SetCellValue(gPRow, "statusCd", rv["statusCd"]);
        	*/
        }
    }

	// 해당 Row에 Seq 할당
	/*
	function setSeq(Row) {
		var data = ajaxCall("GetDataMap.do?cmd=getMaxSeqOccStd", "", false);
		sheet1.SetCellValue( Row, "seq", (data.DATA.maxSeq + sheet1.RowCount("I")) );
	}*/

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<!--
						<th>사업장</th>
						<td>
							<select id="searchBusinessPlaceCd" name="searchBusinessPlaceCd" multiple></select>
							<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" value=""/>
						</td>
						 -->
						<th>회의실명</th>
						<td>
							<input id="searchMeetRoomNm" name="searchMeetRoomNm" type="text" class="text">
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
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
							<li id="txt" class="txt">회의실관리</li>
							<li class="btn">
								<a href="javascript:doAction1('Insert')" class="basic authA">입력</a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA">복사</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>