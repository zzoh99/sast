<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='113773' mdef='임직원 조회 팝업'/></title>
<script type="text/javascript">
	var srchBizCd = null;
	var searchEnterCdView  	= "";
	var ssnSearchType = "";

	/*Sheet 기본 설정 */
	$(function() {
		createIBSheet3(document.getElementById('hrmStaLayerSheet-wrap'), "hrmStaLayerSheet", "100%", "100%", "kr");

		const modal = window.top.document.LayerModalUtility.getModal('hrmStaLayer');

		var schDate 	= modal.parameters.schDate || '';
		var schType 	= modal.parameters.schType || '';
		var schOrgCd	= modal.parameters.orgCd || '';
		var schCode		= modal.parameters.code || '';

		var schOrgNm	= modal.parameters.orgNm || '';
		var schTitle1	= modal.parameters.schTitle1 || '';
		var schTitle2	= modal.parameters.schTitle2 || '';

		$("#schDate").val(schDate);
		$("#schType").val(schType);
		$("#schOrgCd").val(schOrgCd);
		$("#schCode").val(schCode);

		var titleTxt = schOrgNm + " "+ schDate + " " + schTitle1 + " (" +schTitle2 +")";
		$('#modal-hrmStaLayer').find('div.layer-modal-header span.layer-modal-title').text(titleTxt);
		
		ssnSearchType = "${ssnSearchType}";

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:0, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"프로필",			Type:"Image",		Hidden:1,	Width:40,			Align:"Center",	ColMerge:1,	SaveName:"detail0",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0},
 			{Header:"회사코드",		Type:"Text",		Hidden:1,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"enterCd", UpdateEdit:0 },
 			{Header:"회사",			Type:"Text",		Hidden:1,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"enterNm", UpdateEdit:0 },
 			{Header:"사진",			Type:"Image",		Hidden:0,	Width:90,			Align:"Center",	ColMerge:0,	SaveName:"photo",	UpdateEdit:0, ImgWidth:80, ImgHeight:90 },
			{Header:"사번",			Type:"Text",		Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sabun", UpdateEdit:0 },
			{Header:"성명",			Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"name", UpdateEdit:0 },
			{Header:"재직상태",		Type:"Text",		Hidden:1,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"statusNm", UpdateEdit:0 },			
			{Header:"소속",			Type:"Text",		Hidden:0,	Width:130,			Align:"Center",	ColMerge:0,	SaveName:"orgNm", UpdateEdit:0 },
			{Header:"직책",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm", UpdateEdit:0 },
			{Header:"직위",			Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikweeNm", UpdateEdit:0 },
			{Header:"직급",			Type:"Text",		Hidden:Number("${jgHdn}"),		Width:60,		Align:"Center",	ColMerge:0,	SaveName:"jikgubNm", UpdateEdit:0 },
			{Header:"직군",			Type:"Text",		Hidden:0,	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"workTypeNm", UpdateEdit:0 },
			{Header:"사원구분",		Type:"Text",		Hidden:0,	Width:80,			Align:"Center",	ColMerge:0,	SaveName:"manageNm", UpdateEdit:0 },
			{Header:"조회권한",		Type:"Text",		Hidden:1,	Width:45,			Align:"Center",	ColMerge:0,	SaveName:"authYn", UpdateEdit:0 }
		];
		IBS_InitSheet(hrmStaLayerSheet, initdata); hrmStaLayerSheet.SetCountPosition(4);hrmStaLayerSheet.SetEditableColorDiff (0);

		var sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
		hrmStaLayerSheet.SetSheetHeight(sheetHeight);

		hrmStaLayerSheet.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		hrmStaLayerSheet.SetDataLinkMouse("detail0",1);

		doAction("Search");

	});

	function doAction(sAction) {
	/*Sheet Action*/
		switch (sAction) {
		case "Search": //조회
		    hrmStaLayerSheet.DoSearch( "${ctx}/HrmSta.do?cmd=getHrmStaPopupList", $("#mySheetForm").serialize(), 1);
            break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(hrmStaLayerSheet);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			hrmStaLayerSheet.Down2Excel(param);
			break;
		}
    }

	// 	조회 후 에러 메시지
	function hrmStaLayerSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
		    if (ErrMsg != "") {
				alert(ErrMsg);
			}

			sheetResize();
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	
	
	
	function hrmStaLayerSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		
		var authYn = hrmStaLayerSheet.GetCellValue(Row, "authYn");
		if(hrmStaLayerSheet.ColSaveName(Col) == "detail0" && Value != "") {
			
			if(ssnSearchType == "A"){
	            if( "${profilePopYn}"=="Y"){
	            	
					// 인사기본 팝업 
					var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
		            var args    = new Array();
		            args["sabun"]      = hrmStaLayerSheet.GetCellValue(Row, "sabun");
		            args["enterCd"]    = hrmStaLayerSheet.GetCellValue(Row, "enterCd");
		            args["empName"]    = hrmStaLayerSheet.GetCellValue(Row, "name");
		            openPopup(url,args,"1300","780");
	            	
	            }else{
	            	
					// 부모창 인사 기본으로 이동
					var returnValue    = new Array(2);
		            returnValue["sabun"]       = hrmStaLayerSheet.GetCellValue(Row, "sabun");
					returnValue["enterCd"]     = hrmStaLayerSheet.GetCellValue(Row, "enterCd");
	
					if(p.popReturnValue) p.popReturnValue(returnValue);
					p.self.close();
	            }
	            
			}else if(ssnSearchType == "P"){
				// 프로필 화면 팝업 띄우기
				var url     = "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
	            var args    = new Array();
	            args["sabun"]       = hrmStaLayerSheet.GetCellValue(Row, "sabun");
	            args["enterCd"]     = hrmStaLayerSheet.GetCellValue(Row, "enterCd");
	            
				openPopup(url,args,"610","350");
				
			}else if(ssnSearchType == "B"){
				/*
				// 부모창 인사 기본으로 이동
				var returnValue    = new Array(2);
	            returnValue["sabun"]       = hrmStaLayerSheet.GetCellValue(Row, "sabun");
				returnValue["enterCd"]     = hrmStaLayerSheet.GetCellValue(Row, "enterCd");

				if(p.popReturnValue) p.popReturnValue(returnValue);
				p.self.close();
				*/	
			}else if(ssnSearchType == "O"){
				/*
				var chkVal = "N";
				var chkOrg = hrmStaLayerSheet.GetCellValue(Row, "orgCd");
				if(authYn == "Y"){
					if( "${profilePopYn}"=="Y"){
						// 인사기본 팝업 
						var url     = "${ctx}/EisEmployeePopup.do?cmd=viewEmployeeProfilePopup&authPg=R";
			            var args    = new Array();
			            args["sabun"]      = hrmStaLayerSheet.GetCellValue(Row, "sabun");
			            args["enterCd"]    = hrmStaLayerSheet.GetCellValue(Row, "enterCd");
			            args["empName"]    = hrmStaLayerSheet.GetCellValue(Row, "name");
			            openPopup(url,args,"1250","780");
					}else{
						// 부모창 인사 기본으로 이동
						var returnValue    = new Array(2);
			            returnValue["sabun"]       = hrmStaLayerSheet.GetCellValue(Row, "sabun");
						returnValue["enterCd"]     = hrmStaLayerSheet.GetCellValue(Row, "enterCd");

						if(p.popReturnValue) p.popReturnValue(returnValue);
						p.self.close();
						
					}
				}else{
					 var url     = "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
	                 var args    = new Array();
	                 args["sabun"]       = hrmStaLayerSheet.GetCellValue(Row, "sabun");
	                 args["enterCd"]     = hrmStaLayerSheet.GetCellValue(Row, "enterCd");
	                 
	                 openPopup(url,args,"610","350");
				}
				*/	
			}
			
			
		}
	}
	

</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="mySheetForm" name="mySheetForm">	    
                <input type="hidden" id="schDate" name="schDate" />
                <input type="hidden" id="schType" name="schType" />
                <input type="hidden" id="schOrgCd" name="schOrgCd" />
                <input type="hidden" id="schCode" name="schCode" />
 	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='schEmployee' mdef='사원조회'/></li>
					<li class="btn"><btn:a href="javascript:doAction('Down2Excel')" 	css="basic authR" mid='down2excel' mdef="다운로드"/></li>
				</ul>
				</div>
			</div>
			<div id="hrmStaLayerSheet-wrap"></div>
		<%--			<script type="text/javascript">createIBSheet("hrmStaLayerSheet", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
        </div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('hrmStaLayer');" css="gray large" mid='close' mdef="닫기"/>
		</div>
    </div>
</body>
</html>
