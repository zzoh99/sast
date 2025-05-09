// 자료등록(관리자)에서 수정시 [담당자확인] column만 수정한 경우 자료입력유형은 변하지 않는다.
function tab_setAdjInputType(pOrgAuthPg, pSheet) {
	if(pOrgAuthPg != "A") return;

	for(var i = pSheet.HeaderRows(); i <= pSheet.LastRow(); i++){
		if(pSheet.GetCellValue(i, "sStatus") != "U") continue;

		for(var j=0; j < pSheet.LastCol(); j++ ) {
			if ( pSheet.ColSaveName(j) == "sNo" ) continue;
			if ( pSheet.ColSaveName(j) == "sDelete" ) continue;
			if ( pSheet.ColSaveName(j) == "sStatus" ) continue;
			if ( pSheet.ColSaveName(j) == "feedback_type" ) continue; //담당자확인

			if ( pSheet.GetCellValue(i, j) != pSheet.CellSearchValue(i, j) ) {
				pSheet.SetCellValue(i, "adj_input_type", "02") ;
				break;
			}
		}

	}
}

// 자료등록, 자료등록(관리자)에서 [자료입력유형]에 따른 row별 공통 editable 제어. Row Editable return.
function tab_setAuthEdtitable(pOrgAuthPg, pSheet, pRow) {
	var rtn = true;

	if (pSheet.GetCellValue(pRow, "adj_input_type") == "03" //일괄반영
		|| pSheet.GetCellValue(pRow, "adj_input_type") == "04" //자동계산
		|| pSheet.GetCellValue(pRow, "adj_input_type") == "07" //PDF
	) {
		pSheet.SetRowEditable(pRow, 0);
		rtn = false;
	}

	if (pSheet.GetCellValue(pRow, "adj_input_type") == "02") { //담당자입력
		if(pOrgAuthPg == "A") {
			pSheet.SetCellEditable(pRow, "input_mon", 0);
			pSheet.SetCellEditable(pRow, "appl_mon", 1);
			pSheet.SetCellEditable(pRow, "input_mon_isa", 0);
			pSheet.SetCellEditable(pRow, "appl_mon_isa", 1);
		} else {
			pSheet.SetCellEditable(pRow, "input_mon", 0);
			pSheet.SetCellEditable(pRow, "appl_mon", 0);
			pSheet.SetCellEditable(pRow, "input_mon_isa", 0);
			pSheet.SetCellEditable(pRow, "appl_mon_isa", 0);
		}
	}

	if(pOrgAuthPg == "A") {
		pSheet.SetCellEditable(pRow, "feedback_type", 1);
	} else {
		pSheet.SetCellEditable(pRow, "feedback_type", 0);
	}

	if( pSheet.GetCellValue(pRow, "adj_input_type") == "07" ) {
		if( pSheet.GetCellValue(pRow, "contribution_cd") == "20" || pSheet.GetCellValue(pRow, "contribution_cd") == "42" ) {
			pSheet.SetCellEditable(pRow, "contribution_sup_mon", 0);
		} else {
			pSheet.SetCellEditable(pRow, "contribution_sup_mon", 1);
		}
		//PDF에 대해서 삭제체크 및 저장을 이용한 각 화면 별 반영제외를 할 수 있다.
		pSheet.SetCellEditable(pRow, "sDelete", 1);
	}

	return rtn;
}

// 자료등록, 자료등록(관리자)에서 [자료입력유형]에 따른 삭제 check click시 안내멘트
function tab_clickDelete(pSheet, pRow) {
	if(pSheet.GetCellValue(pRow,"adj_input_type")=="03" || pSheet.GetCellValue(pRow,"adj_input_type")=="04"){
		alert('일괄반영 및 자동계산분은 삭제/수정이 불가능합니다. 담당자에게 문의하시기 바랍니다.');

	}/* else if(pSheet.GetCellValue(pRow,"adj_input_type")=="07"){
		if( confirm('PDF업로드자료는 PDF등록 탭에서 반영제외하면 현재 화면에서 삭제됩니다.\nPDF등록 탭으로 이동하시겠습니까?') ) {
			parent.tabObj.tabs( "option", "active", 2 );
		}
	}*/
}

// 자료등록, 자료등록(관리자)에서 [입력] click 시 [자료입력유형] 및 editable setting
function tab_clickInsert(pOrgAuthPg, pSheet, pRow) {
	if( pOrgAuthPg == "A" ) {
		pSheet.SetCellValue(pRow, "adj_input_type", "02");
		pSheet.SetCellEditable(pRow, "feedback_type", 1);
	} else {
		pSheet.SetCellValue(pRow, "adj_input_type", "01");
		pSheet.SetCellEditable(pRow, "feedback_type", 0);
	}

	pSheet.SelectCell(pRow, 2);
}