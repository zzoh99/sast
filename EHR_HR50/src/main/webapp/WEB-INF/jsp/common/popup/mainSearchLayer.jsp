<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- ajax error -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script>
var arg = JSON.parse('${layerArgument}');

//임직원 검색 SHEET
var searchModalEmployeeSheet;

$(function() {
	var tabs = ['searchModalMenuResult', 'searchModalProcessMapResult', 'searchModalEmployeeResult'];
	tabs.filter((a, i) => i != 0).forEach(a => $("#" + a).hide());

	$("#mainSearchModalTab .tab_menu").on("click", function () {
      $("#mainSearchModalTab .tab_menu").removeClass("active");
      $(this).addClass("active");
      var index = $(this).index();
	  var tabs = ['searchModalMenuResult', 'searchModalProcessMapResult', 'searchModalEmployeeResult'];
	  tabs.filter((a, i) => i != index).forEach(a => $("#" + a).hide());
      $('#' + tabs[index]).show();
      if (index == 2) sheetResize();
    });

	$('#searchModalWithOutRA').change(function() {
		employeeAction('Search');
	});
    
  	createSearchModalEmployeeSheet();

  	if (arg && arg.searchWord) {
		$('#mainModalSearchInput').val(arg.searchWord);
		mainModalSearch();
	}
});

/*
//초기화 함수
function initLayer(id) {
	searchLayerId = id;
	//var layerId = 'commonLayer_' + id
	//$('#' + layerId).addClass('search_modal');
	//TAB_BODY ID
	var tabs = ['searchModalMenuResult', 'searchModalProcessMapResult', 'searchModalEmployeeResult'];
	tabs.filter((a, i) => i != 0).forEach(a => $("#" + a).hide());
	
    $("#mainSearchModalTab .tab_menu").on("click", function () {
      $("#mainSearchModalTab .tab_menu").removeClass("active");
      $(this).addClass("active");
      var index = $(this).index();
	  var tabs = ['searchModalMenuResult', 'searchModalProcessMapResult', 'searchModalEmployeeResult'];
	  tabs.filter((a, i) => i != index).forEach(a => $("#" + a).hide());
      $('#' + tabs[index]).show();
      if (index == 2) sheetResize();
    });

	$('#searchModalWithOutRA').change(function() {
		employeeAction('Search');
	});
    
  	createSearchModalEmployeeSheet();

  	var commonLayer = commonLayerList.find(cl => cl.id == id);
	if (commonLayer) {
		commonLayer['rtn'] = () => {
			$('#' + layerId).removeClass('search_modal');
			searchModalEmployeeSheet.DisposeSheet();
		}
	}

	if (arg && arg.searchWord) {
		$('#mainModalSearchInput').val(arg.searchWord);
		mainModalSearch();
	}
}
*/

function searchLayerClose() {
	const modal = window.top.document.LayerModalUtility.getModal('mainSearchModal');
	modal.hide();
}

function createSearchModalEmployeeSheet() {
	createIBSheet3($('#searchModalIbSheet').get(0), "searchModalEmployeeSheet", "100%", "165px", "kr");
	var initdata = {};
	initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
	initdata.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata.Cols = [
		{Header:"No",	Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"삭제",	Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
		{Header:"상태",	Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
		{Header:"소속",	Type:"Text",     	Hidden:0,  Width:220,   Align:"Center",  SaveName:"orgNm",   	KeyField:0},
		{Header:"성명",	Type:"Text",      	Hidden:0,  Width:180,  	Align:"Center",  SaveName:"empName",  		KeyField:0},
		{Header:"직책",	Type:"Text",      	Hidden:0,  Width:120,   	Align:"Center",  SaveName:"jikchakNm",	KeyField:0},
		{Header:"직급",	Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", UpdateEdit:0 },
		{Header:"직위",	Type:"Text",      	Hidden:1,  Width:0,   	Align:"Center",  SaveName:"jikweeNm",	KeyField:0},
		{Header:"사번",	Type:"Text",      	Hidden:1,  Width:0,   	Align:"Center",  SaveName:"empSabun",	KeyField:0},
		{Header:"OFFITEL",	Type:"Text",      	Hidden:1,  Width:0,   	Align:"Center",  SaveName:"officeTel",	KeyField:0},
		{Header:"EMAIL",	Type:"Text",      	Hidden:1,  Width:0,   	Align:"Center",  SaveName:"mailId",	KeyField:0},
		{Header:"HP",	Type:"Text",      	Hidden:1,  Width:0,   	Align:"Center",  SaveName:"handPhone",	KeyField:0}
	];
	IBS_InitSheet(searchModalEmployeeSheet, initdata, 1);
	searchModalEmployeeSheet.SetConfig();
	searchModalEmployeeSheet.SetEditable(false);
	searchModalEmployeeSheet.SetVisible(true);
	searchModalEmployeeSheet.SetEditableColorDiff(0);
	searchModalEmployeeSheet.SetFocusAfterProcess(0);

	$(window).smartresize(sheetResize);
}

function mainModalSearch() {
	var word = $('#mainModalSearchInput').val();
	if (word.length > 1) {
		const p = { searchText: word };
		const d = ajaxCall('/SearchMenuLayer.do?cmd=getSearchMenuLayerList', queryStringToJson(p), false).DATA;
		var menuHtml = d.length > 0 ? d.reduce((a, c) => {
				a += '<div class="result">\n'
				   + '	<span prgCd="' + c.prgCd
						+ '" mainMenuCd="' + c.mainMenuCd
						+ '" menuNm="' + c.menuNm
						+ '" murl="' + c.murl
						+ '" surl="' + c.surl
						+ '" menuId="' + c.menuId
						+ '" location="' + c.menuPath +'"" >' + c.searchPath + '</span>\n'
				   + '</div>\n';
				return a;
			},''):'<div class="result">검색 결과가 없습니다.</div>'; 
		$('#searchModalMenuResult').html(menuHtml);
		getProcessMap();
		employeeAction('Search');
		mainModalEvent();
	} else {
		alert('검색어는 최소 2글자 이상 입력하여야 합니다.');
	}
}

function mainModalEvent() {
	$('#searchModalMenuResult span').off().on('click', function() {
		/**
		 * 2024-08-13 수정
		 * 검색 레이어 메뉴 선택 시
		 * 탭 초기화 부분 수정
		 */
		//탭 생성
		var code = $(this).attr('mainMenuCd');
		var prgCd = $(this).attr('prgCd');
		if($("#subForm").length > 0 ){
			//추가 탭 생성
			window.top.goOtherSubPage("", "", "", "", prgCd);
		}else{
			//신규 탭 생성
			openSubPage(code, '', '', '', prgCd);
		}
		//레이어 닫기
		closeCommonLayer('mainSearchModal');
	});

	$('#searchModalProcessMapResult div.process_map').off().on('click', function() {
		var mmcd = $(this).attr('mainMenuCd');
		var prgcd = $(this).attr('prgCd');
		var pmseq = $(this).attr('procMapSeq');
		var pseq = $(this).attr('procSeq');
		openSubPage(mmcd, '', '', '', prgcd, pmseq, pseq);
	});
}

function getProcessMap() {
	var word = $('#mainModalSearchInput').val();
	const p = { searchWord: word };
	const d = ajaxCall('/Popup.do?cmd=getMainSearchProcessMap', queryStringToJson(p), false).DATA;

	var prmhtml = d.reduce((a, c) => {
			a += '<div class="process_map"'
			   + '	   prgCd="' + c.prgCd + '" '
			   + '	   mainMenuCd="' + c.mainMenuCd + '" '
			   + '	   procMapSeq="' + c.procMapSeq + '" '
			   + '	   procSeq="' + c.procSeq + '" '
			   + '>\n'
			   + '	<span>' + c.txt + '</span>\n'
			   + '</div>\n';
			return a;
		}, '');
	$('#searchModalProcessMapResult').html(prmhtml);
}

function employeeAction(action) {
	switch (action) {
		case 'Search':
			var word = $('#mainModalSearchInput').val();
			var status = $('#searchModalWithOutRA').is(':checked') ? 'ALL':'RA';
			const p = { searchWord: word, searchStatusCd: status };
			searchModalEmployeeSheet.DoSearch('/Employee.do?cmd=getMainEmployeeSearch', queryStringToJson(p), false);
			break;
	}
}

function searchModalEmployeeSheet_OnSearchEnd(Code) {
	var count = searchModalEmployeeSheet.RowCount();
	$('#searchModalEmployeeCount').text(count);
	if (count == 0) {
		$('#searchModalImage').empty();
		$('#searchModalName').text('-');
		$('#searchModalOrgNm').text('-');
		$('#searchModalJikweeNm').text('-');
		$('#searchModalJikupNm').text('-');
		$('#searchModalTelNo').text('-');
		$('#searchModalPhone').text('-');
		$('#searchModalEmail').text('-');
	} else {
		searchModalEmployeeSheet.SetSelectRow(searchModalEmployeeSheet.GetDataFirstRow());
	}
}

function searchModalEmployeeSheet_OnSelectCell(or, oc, nr, nc) {
	var data = searchModalEmployeeSheet.GetRowData(nr);
	var image = '<img src="/EmpPhotoOut.do?enterCd=${ssnEnterCd}&searchKeyword=' + data.empSabun + '" alt="" />';
	$('#searchModalImage').html(image);
	$('#searchModalName').text(data.empName);
	$('#searchModalOrgNm').text(data.orgNm);
	$('#searchModalJikweeNm').text(data.jikweeNm);
	$('#searchModalJikupNm').text(data.jikgubNm);
	$('#searchModalTelNo').text(data.officeTel);
	$('#searchModalPhone').text(data.handPhone);
	$('#searchModalEmail').text(data.mailId);
}

function keydownSearchModal(e) {
	if (window.event.keyCode == 13) mainModalSearch();
}
</script>
<div class="search_modal">
	<!-- 
	<div class="modal_header">
	  <span>검색</span><i class="mdi-ico" onclick="searchLayerClose()">close</i>
	</div>
	 -->
	<div class="modal_sub_header">
	  <div class="search">
	    <input id="mainModalSearchInput" type="text" class="" placeholder="검색어를 입력해 주세요." onkeydown="keydownSearchModal()">
	    <button class="btn filled" onclick="mainModalSearch()">검색</button>
	  </div>
	  <div id="mainSearchModalTab" class="tab_wrap">
	    <div class="tab_menu menu active">메뉴검색</div>
	    <div class="tab_menu process_map">프로세스맵</div>
	    <div class="tab_menu employee">임직원</div>
	  </div>
	</div>
	<div class="modal_body">
	  <!-- 개발 시 참고: 메뉴 검색 결과 -->
	  <div id="searchModalMenuResult" class="menu_result"></div>
	  <!-- 개발 시 참고: 프로세스맵 검색 결과 -->
	  <div id="searchModalProcessMapResult" class="process_map_result">
	  </div>
	  <!-- 개발 시 참고: 임직원 검색 결과 -->
	  <div id="searchModalEmployeeResult" class="employee_result">
	    <div class="count_area">
	      <div>
	        <span class="count_label">검색된 임직원</span><span id="searchModalEmployeeCount" class="count">-</span>
	      </div>
	      <div>
	        <input type="checkbox" class="form-checkbox type2" id="searchModalWithOutRA"/>
	        <label for="searchModalWithOutRA">퇴직자포함</label>
	      </div>
	    </div>
	    <div id="searchModalIbSheet" class="sheet_area"></div>
	    <div class="employee_box">
	      <div>
	        <span id="searchModalImage" class="profile_img">
	        </span>
	        <div class="profile_desc">
	          <div>
	            <span id="searchModalName" class="name">-</span>
	          </div>
	          <span id="searchModalOrgNm" class="department">-</span>
	        </div>
	      </div>
	    </div>
	    <div class="employee_desc">
	      <div>
	        <span class="label">직위</span><span id="searchModalJikweeNm" class="content">-</span>
	      </div>
	      <div>
	        <span class="label">직급</span><span id="searchModalJikupNm" class="content">-</span>
	      </div>
	      <div>
	        <span class="label">사내전화</span><span id="searchModalTelNo" class="content">-</span>
	      </div>
	      <div>
	        <span class="label">핸드폰</span><span id="searchModalPhone" class="content">-</span>
	      </div>
	      <div>
	        <span class="label">이메일</span><span id="searchModalEmail" class="content">-</span>
	      </div>
	    </div>
	  </div>
	</div>
</div>