<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>


<script>
//대상검색 SHEET, 대상선택SHEET (다중선택 MODAL)
var payTargetAddLayer = { id: 'payTargetAddLayer', payActionCd: null };
var searchTargetSheet, selectTargetSheet;
$(function() {
	const modal = window.top.document.LayerModalUtility.getModal(payTargetAddLayer.id);
	payTargetAddLayer.payActionCd = modal.parameters.payActionCd;
	
	createSearchTargetSheet();
	createSelectTargetSheet();

	$('#paySearchTargetWord').on('keyup', function(e) {
		if (e.keyCode == 13) searchTargetAction('Search');
	});
});

function closePayTargetAddLayer() {
	searchTargetSheet.RemoveAll();
	selectTargetSheet.RemoveAll();
	$('#paySearchTargetWord').val('');
	const modal = window.top.document.LayerModalUtility.getModal(payTargetAddLayer.id);
	modal.hide();
}

//다중 인원 조회 SHEET
function createSearchTargetSheet() {
	createIBSheet2($('#searchTargetSheetArea').get(0), 'searchTargetSheet', '367px', '559px', '${ssnLocaleCd}');
	//createIBSheet3($('#searchTargetSheetArea').get(0), 'searchTargetSheet', '50%', '100%', '${ssnLocaleCd}');
	var initdata = {};
	initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0,AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",	Type:"${sNoTy}",  	Hidden:"${sNoHdn}",   Width:"${sNoWdt}",  Align:"Center",  SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  SaveName:"sDelete" },
		{Header:"상태",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  SaveName:"sStatus" },
		{Header:"소속",	Type:"Text",     	Hidden:0,  Width:120,   Align:"Center",  SaveName:"orgNm",   	KeyField:0},
		{Header:"직책",	Type:"Text",      	Hidden:0,  Width:60,   	Align:"Center",  SaveName:"jikchakNm",	KeyField:0},
		{Header:"직위",	Type:"Text",      	Hidden:0,  Width:60,   	Align:"Center",  SaveName:"jikweeNm",	KeyField:0},
		{Header:"성명",	Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"name",  		KeyField:0},
		{Header:"TOKEN",Type:"Text",      	Hidden:1,  Width:0,  	Align:"Center",  SaveName:"tSabun",  	KeyField:0},
		{Header:"사업장",Type:"Text",      	Hidden:1,  Width:0,  	Align:"Center",  SaveName:"businessPlaceCd",  	KeyField:0}
	];
	IBS_InitSheet(searchTargetSheet, initdata, 1);
	searchTargetSheet.SetConfig();
	searchTargetSheet.SetEditable(false);
	searchTargetSheet.SetVisible(true);
	searchTargetSheet.SetEditableColorDiff(0);
	searchTargetSheet.SetFocusAfterProcess(0);
}

function createSelectTargetSheet() {
	createIBSheet2($('#selectTargetSheetArea').get(0), 'selectTargetSheet', '367px', '620px', '${ssnLocaleCd}');
	//createIBSheet3($('#selectTargetSheetArea').get(0), 'selectTargetSheet', '50%', '100%', '${ssnLocaleCd}');
	initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0,AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",	Type:"${sNoTy}",  	Hidden:"${sNoHdn}",   Width:"${sNoWdt}",  Align:"Center",  SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  SaveName:"sDelete" },
		{Header:"상태",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  SaveName:"sStatus" },
		{Header:"소속",	Type:"Text",     	Hidden:0,  Width:120,   Align:"Center",  SaveName:"orgNm",   	KeyField:0},
		{Header:"직책",	Type:"Text",      	Hidden:0,  Width:60,   	Align:"Center",  SaveName:"jikchakNm",	KeyField:0},
		{Header:"직위",	Type:"Text",      	Hidden:0,  Width:60,   	Align:"Center",  SaveName:"jikweeNm",	KeyField:0},
		{Header:"성명",	Type:"Text",      	Hidden:0,  Width:80,  	Align:"Center",  SaveName:"name",  		KeyField:0},
		{Header:"TOKEN",Type:"Text",      	Hidden:1,  Width:0,  	Align:"Center",  SaveName:"tSabun",  	KeyField:0},
		{Header:"사업장",Type:"Text",      	Hidden:1,  Width:0,  	Align:"Center",  SaveName:"businessPlaceCd",  	KeyField:0}
	];
	IBS_InitSheet(selectTargetSheet, initdata, 1);
	selectTargetSheet.SetConfig();
	selectTargetSheet.SetEditable(false);
	selectTargetSheet.SetVisible(true);
	selectTargetSheet.SetEditableColorDiff(0);
	selectTargetSheet.SetFocusAfterProcess(0);
}

function searchTargetAction(action) {
	switch (action) {
		case 'Search':
			const searchWord = $('#paySearchTargetWord').val();
			if (searchWord && searchWord.length > 2) {
				searchTargetSheet.DoSearch('/PayCalculator.do?cmd=getPaySearchTargetList', queryStringToJson({searchWord: searchWord, payActionCd: payTargetAddLayer.payActionCd}));
			} else {
				alert('검색어는 필수요소이며 최소 3글자 이상 입력하여야 합니다.');
			}
			break;
	}
}

function selectTargetAction(action) {
	switch (action) {
		case 'AddTarget':
			const rows = selectTargetSheet.GetSaveJson();
			const param = {
				...rows,
				p: { payActionCd: payTargetAddLayer.payActionCd }
			};
			const r = ajaxTypeJson('/PayCalculator.do?cmd=saveSelectTarget', param, false);
			
			if (r && r.Result && r.Result.Code != null) {
				if (r.Result.Code == 0) {
					alert('저장되었습니다.');
					const modal = window.top.document.LayerModalUtility.getModal(payTargetAddLayer.id);
					modal.fire(payTargetAddLayer.id + 'Trigger').hide();
				} else {
					alert(r.Result.Message);
				}
			} else {
				alert('대상 저장 중 오류가 발생하였습니다.');
			}
			break;
	}
}

function searchTargetSheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
	//선택 SHEET에 현재 사번 정보가 있는지 조회
	var token = searchTargetSheet.GetCellValue(NewRow, 'tSabun');
	var idx = selectTargetSheet.FindText(7, token);
	if (idx == -1) {
		//선택 SHEET에 추가
		var d = searchTargetSheet.GetRowData(NewRow);
		const opt = {Focus: 0, CellEvent: 0};
		var row = selectTargetSheet.DataInsert(0, '', opt);
		selectTargetSheet.SetRowData(row, d);
	} else {
		alert('이미 선택된 정보입니다.');
	}
}

function selectTargetSheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
	if (confirm('해당 데이터를 삭제하시겠습니까?')) {
		selectSheet.RowDelete(NewRow);
	}
}

</script>
<div class="wide target_add_modal">
  <div class="modal_body">
    <div class="body_content">
      <div>
        <div class="search_area">
          <div class="search_input">
            <input
            	id="paySearchTargetWord"
              class="form-input"
              type="text"
              placeholder="소속이나 이름으로 검색"
            />
            <i class="mdi-ico" onClick="searchTargetAction('Search')">search</i>
          </div>
        </div>
        <div class="sheet_area left" id="searchTargetSheetArea"></div>
      </div>
      <div class="sheet_area" id="selectTargetSheetArea"></div>
    </div>
  </div>
  <div class="modal_footer">
    <button id="modal_cancel_btn" class="btn outline_gray" onclick="closeTargetAddModal()">취소</button>
    <button id="modal_submit_btn" class="btn filled" onclick="selectTargetAction('AddTarget')">추가하기</button>
  </div>
</div>