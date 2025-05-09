<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html class="bodywrap"><head><title><tit:txt mid='113773' mdef='임직원 조회 팝업'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">
	var commonEmployeeLayer = { id: 'commonEmployeeLayer', params: null };
	/*Sheet 기본 설정 */
	$(function() {
		createIBSheet3(document.getElementById('empsheet_wrap'), "empsheet", "100%", "100%", "${ssnLocaleCd}");
		const modal = window.top.document.LayerModalUtility.getModal(commonEmployeeLayer.id);
		commonEmployeeLayer.params = modal.parameters;
		commonEmployeeLayer.params = { ...commonEmployeeLayer.params, searchEmpType: 'P' };
		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:0,ColMove:0,ColResize:1,HeaderCheck:0};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
 			{Header:"<sht:txt mid='enterCd' mdef='회사명'/>",		Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"enterNm", UpdateEdit:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"empSabun", UpdateEdit:0 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"empName", UpdateEdit:0 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empAlias", UpdateEdit:0 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,	Width:250,			Align:"Left",	ColMerge:0,	SaveName:"orgNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",		Hidden:0,	Width:120,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm", UpdateEdit:0 },
			{Header:"<sht:txt mid='statusCdV1' mdef='재직\n상태'/>",	Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"statusNm", UpdateEdit:0 }
		];
		IBS_InitSheet(empsheet, initdata); empsheet.SetCountPosition(4); empsheet.SetEditableColorDiff(0); empsheet.SetSheetHeight(550);

		// sheet 높이 계산
		let sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
		empsheet.SetSheetHeight(sheetHeight);

		//검색어 있을경우 검색
		doAction("Search");
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
			    empsheet.DoSearch( "${ctx}/Employee.do?cmd=commonEmployeeList", queryStringToJson(commonEmployeeLayer.params), 1);
			    break;
		}
    }

	function empsheet_OnDblClick(Row, Col){
		try{
			if ( Row >= empsheet.HeaderRows() ){
				returnFindUser(Row,Col);
			}
		}
		catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
		finally{
			closeCommonLayer(commonEmployeeLayer.id);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
    function empsheet_OnKeyDown(Row, Col, KeyCode, Shift) {
        try {
            if (KeyCode == 13) { returnFindUser(Row,Col); }
        } catch (ex) {
            alert("OnKeyDown Event Error : " + ex);
        }
    }

	function returnFindUser(Row, Col){
    	var returnValue = new Array();
    	$("#searchUserId").val(empsheet.GetCellValue(Row,"empSabun"));
    	var user = ajaxCall("/Employee.do?cmd=getBaseEmployeeDetail", $("#mySheetForm").serialize(), false);
    	if(user.map != null && user.map != "undefine") user = user.map;
    	const modal = window.top.document.LayerModalUtility.getModal(commonEmployeeLayer.id);
		modal.fire(commonEmployeeLayer.id + 'Trigger', user).hide();
	}
</script>
</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid='schEmployee' mdef='사원조회'/></li>
					</ul>
				</div>
			</div>
			<div id="empsheet_wrap"></div>
        </div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('commonEmployeeLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
    </div>
</body>
</html>
