<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head><title>교육만족도조사 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/applCommon.jsp"%>
<script type="text/javascript">
	
	$(function() {

		const modal = window.top.document.LayerModalUtility.getModal('eduSurveryLayer');
		$("#searchApplSabun").val(modal.parameters.searchApplSabun);
		$("#searchEduEventSeq").val(modal.parameters.searchEduEventSeq);
		$("#searchApplSeq").val(modal.parameters.searchApplSeq);
		$("#searchEduSeq").val(modal.parameters.searchEduSeq);
		$("#memo").maxbyte(4000);
		$("#memo2").maxbyte(4000);

		//Sheet 초기화
		createIBSheet3(document.getElementById('eduSurveryLayerSht-wrap'), "eduSurveryLayerSht", "100%", "100%","${ssnLocaleCd}");

		init_eduSurveryLayerSht();
		var sheetHeight = $(".modal_body").height() - $(".outer").height() - 57;
		eduSurveryLayerSht.SetSheetHeight(sheetHeight);
		doAction1("Search");
	});

	/*
	 * sheet Init
	 */
	function init_eduSurveryLayerSht(){
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msBaseColumnMerge + msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",					Type:"${sNoTy}",  Hidden:1,	 Width:"${sNoWdt}",		Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",					Type:"${sDelTy}", Hidden:1,	 Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",					Type:"${sSttTy}", Hidden:1,	 Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"교육순번|교육순번",			Type:"Int",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"eduEventSeq",		KeyField:0,	UpdateEdit:1,   InsertEdit:1 },
			{Header:"순서|순서",					Type:"Int",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	UpdateEdit:1,   InsertEdit:1 },
			{Header:"분류|분류",					Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"surveyItemType",	KeyField:0,	UpdateEdit:0,   InsertEdit:0 },
			{Header:"구분|구분",					Type:"Combo",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"surveyItemType2",	KeyField:0,	UpdateEdit:0,   InsertEdit:0 },
			{Header:"설문항목코드|설문항목코드",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:1,	SaveName:"surveyItemCd",	KeyField:1,	UpdateEdit:0,   InsertEdit:0 },
			{Header:"설문항목명|설문항목명",		Type:"Text",	Hidden:0,	Width:400,	Align:"Left",	ColMerge:0,	SaveName:"surveyItemNm",	KeyField:0,	UpdateEdit:0,   InsertEdit:0 },
			{Header:"항목점수|10",				Type:"CheckBox",Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point10",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N" },
			{Header:"항목점수|9",				Type:"CheckBox",Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point9",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N"  },
			{Header:"항목점수|8",				Type:"CheckBox",Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point8",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N"  },
			{Header:"항목점수|7",				Type:"CheckBox",Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point7",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N"  },
			{Header:"항목점수|5",				Type:"CheckBox",Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point6",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N"  },
			{Header:"매우 그렇다|매우 그렇다",		Type:"CheckBox",Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point5",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N"  },
			{Header:"그렇다|그렇다",				Type:"CheckBox",Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point4",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N"  },
			{Header:"보통이다|보통이다",			Type:"CheckBox",Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point3",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N"  },
			{Header:"아니다|아니다",				Type:"CheckBox",Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point2",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N"  },
			{Header:"매우 아니다|매우 아니다",		Type:"CheckBox",Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point1",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N"  },
			{Header:"포인트|포인트",				Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"point",			KeyField:0,	UpdateEdit:1,   InsertEdit:1,   TrueValue:"Y", FalseValue:"N"  }
		]; IBS_InitSheet(eduSurveryLayerSht, initdata);eduSurveryLayerSht.SetEditable("${editable}");eduSurveryLayerSht.SetVisible(true);eduSurveryLayerSht.SetCountPosition(0);

		eduSurveryLayerSht.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음
		eduSurveryLayerSht.SetEditableColorDiff(0); //편집불가 배경색 적용안함
		eduSurveryLayerSht.SetDataAlternateBackColor(eduSurveryLayerSht.GetDataBackColor()); //홀짝 배경색 같게

		/* 항목분류 */
		var surveyItemType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10230"), "");
		eduSurveryLayerSht.SetColProperty("surveyItemType", 			{ComboText:surveyItemType[0], ComboCode:surveyItemType[1]} );

		var surveyItemType2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10231"), "");
		eduSurveryLayerSht.SetColProperty("surveyItemType2", 			{ComboText:surveyItemType2[0], ComboCode:surveyItemType2[1]} );

		$(window).smartresize(sheetResize);
		sheetInit();
	}
	

	//저장 시 체크  
	function checkList(){
		var row = -1;
		for(var i = eduSurveryLayerSht.HeaderRows(); i < eduSurveryLayerSht.RowCount()+eduSurveryLayerSht.HeaderRows() ; i++) {
			if( eduSurveryLayerSht.GetCellValue(i, "point") == "" ){
				row = i;
				eduSurveryLayerSht.SetRangeBackColor(i,eduSurveryLayerSht.SaveNameCol("point10"),i, eduSurveryLayerSht.SaveNameCol("point1"), "#fdf0f5");
			}else{
				eduSurveryLayerSht.SetRangeBackColor(i,eduSurveryLayerSht.SaveNameCol("point10"),i, eduSurveryLayerSht.SaveNameCol("point1"), "#FFFFFF");
			}
		}

		if( row > -1 ) {
			alert("설문조사에 누락된 항목이 존재합니다.");
			return false;
		}else{
			return true;
		}
	}
	
	/*Sheet1 Action*/
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": 		//조회
				eduSurveryLayerSht.DoSearch( "${ctx}/EduApp.do?cmd=getEduSurveryPopupList", $("#eduSurveryLayerShtForm").serialize() );
				break;
			case "Save": 		//임시저장
				$("#eduSurveyYn").val("N");

	            IBS_SaveName(document.eduSurveryLayerShtForm, eduSurveryLayerSht);
				var params = $("#eduSurveryLayerShtForm").serialize()+"&"+eduSurveryLayerSht.GetSaveString(0);
	            var rtn = eval("("+eduSurveryLayerSht.GetSaveData("${ctx}/EduApp.do?cmd=saveEduSurveryLst", params )+")");
				alert(rtn.Result.Message);
	           
				break;
			case "SaveFin": //설문조사완료
				if( !checkList() ) return;
				$("#eduSurveyYn").val("Y");

	            IBS_SaveName(document.eduSurveryLayerShtForm, eduSurveryLayerSht);
				var params = $("#eduSurveryLayerShtForm").serialize()+"&"+eduSurveryLayerSht.GetSaveString(0);
	            var rtn = eval("("+eduSurveryLayerSht.GetSaveData("${ctx}/EduApp.do?cmd=saveEduSurveryLst", params )+")");
				alert(rtn.Result.Message);

				closeLayerModal();
				break;
		}
    }

	// 	조회 후 에러 메시지
	function eduSurveryLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != ""){
				alert(Msg);
			}

			$("#memo").val(eduSurveryLayerSht.GetEtcData("memo"));
			$("#memo2").val(eduSurveryLayerSht.GetEtcData("memo2"));

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function eduSurveryLayerSht_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
 			if (Msg != "") {
				alert(Msg);
			}
 			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 변경시 발생
	function eduSurveryLayerSht_OnChange(Row, Col, Value, OldValue, RaiseFlag){
		try {
			var saveName = eduSurveryLayerSht.ColSaveName(Col);
			if( saveName.substring(0,5) == "point" && Value == "Y"){
				eduSurveryLayerSht.SetCellValue(Row, "point", saveName.substring(5), 0);
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	// 체크전 이벤트
	function eduSurveryLayerSht_OnBeforeCheck(Row, Col) {
		try {
			var saveName = eduSurveryLayerSht.ColSaveName(Col);
			if( saveName.substring(0,5) == "point" ){
				for( var i=eduSurveryLayerSht.SaveNameCol("point10"); i<=eduSurveryLayerSht.SaveNameCol("point1") ; i++){
					if(eduSurveryLayerSht.GetColHidden(i) == 0) {
						eduSurveryLayerSht.SetCellValue(Row, i, "N",0); //전체 체크 해제
					}
				}
				eduSurveryLayerSht.SetCellValue(Row, "point", "", 0);
			}
		} catch (ex) {
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}

	function closeLayerModal(){
		const modal = window.top.document.LayerModalUtility.getModal('eduSurveryLayer');
		modal.fire('eduSurveryTrigger', {}).hide();
	}
</script>


</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="eduSurveryLayerShtForm" name="eduSurveryLayerShtForm" >
		<input type="hidden" id="searchApplSabun" 	name="searchApplSabun" 		value=""/>
		<input type="hidden" id="searchEduEventSeq" name="searchEduEventSeq" 	value=""/>
		<input type="hidden" id="searchApplSeq" 	name="searchApplSeq" 		value=""/>
		<input type="hidden" id="searchEduSeq" 		name="searchEduSeq" 		value=""/>
		<input type="hidden" id="eduSurveyYn" 		name="eduSurveyYn" 			value="N"/>

		<div class="sheet_title">
			<ul>
				<li class="txt">설문조사항목</li>
				<li class="btn"></li>
			</ul>
		</div>
		<div id="eduSurveryLayerSht-wrap"></div>

		<table class="outer" style="width:100%;">
		<colgroup>
			<col width="50%" />
			<col width="" />
		</colgroup>
		<tr>
			<td>
				<div class="sheet_title">
					<ul>
						<li class="txt">교육소감</li>
					</ul>
				</div>
				<table class="table w100p">
					<tr>
						<td>
							<textarea id="memo" name="memo" rows="4" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		<tr>
			<td>
				<div class="sheet_title">
					<ul>
						<li class="txt">건의사항</li>
					</ul>
				</div>
				<table class="table w100p">
					<tr>
						<td>
							<textarea id="memo2" name="memo2" rows="4" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea>
						</td>
					</tr>
				</table>
			</td>
		</tr>
		</table>
		</form>
	</div>
	<div class="modal_footer">
		<c:if test="${authPg=='A'}">
		<a href="javascript:doAction1('SaveFin');" 	class="btn filled">설문조사완료</a>
		<a href="javascript:doAction1('Save');" 	class="btn filled">임시저장</a>
		</c:if>
		<a href="javascript:closeLayerModal();" 	class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>
