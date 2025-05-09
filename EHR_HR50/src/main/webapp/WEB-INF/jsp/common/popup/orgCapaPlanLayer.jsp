<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>인력충원 계획 팝업</title>

<script type="text/javascript">
	var srchBizCd = null;
	
	/*Sheet 기본 설정 */
	$(function() {
        createIBSheet3(document.getElementById('orgCapaPlanLayerSheet-wrap'), "orgCapaPlanLayerSheet", "100%", "100%", "kr");

        var searchOrgCd 	= "";
        var searchOrgNm 	= "";
        var searchBaseDate 	= "";
        var searchMonth 	= "";

        var modal = window.top.document.LayerModalUtility.getModal('orgCapaPlanLayer');
        var { searchOrgCd, searchOrgNm, searchBaseDate, searchMonth } = modal.parameters;
        var titleTxt = searchOrgNm + " " + searchBaseDate.substring(0,4) + "년 " + searchMonth + "월 계획인원";
        searchMonth = searchBaseDate.substring(0,4)+searchMonth;

        $('#modal-orgCapaPlanLayer').find('div.layer-modal-header span.layer-modal-title').text(titleTxt);
        $("#searchOrgCd").val(searchOrgCd);
        $("#searchBaseDate").val(searchBaseDate);
        $("#searchMonth").val(searchMonth);
        
		//배열 선언				
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"세부내역",  		Type:"Image", 	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"신청자",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name", 			UpdateEdit:0 },
			{Header:"충원요청인원",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"totReqCnt",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
   			{Header:"신청일자",  		Type:"Text",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },   			
   			{Header:"신청순번", 		Type:"Text",  	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
   			{Header:"신청자사번",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"대상자사번",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		];                  
		IBS_InitSheet(orgCapaPlanLayerSheet, initdata); orgCapaPlanLayerSheet.SetCountPosition(4);orgCapaPlanLayerSheet.SetEditableColorDiff (0);
		orgCapaPlanLayerSheet.SetImageList(0,"/common/images/icon/icon_info.png");
		orgCapaPlanLayerSheet.SetDataLinkMouse("ibsImage", 1);

		$(window).smartresize(sheetResize);
		sheetInit();

        var sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 2;
        orgCapaPlanLayerSheet.SetSheetHeight(sheetHeight);
		
		doAction("Search");

        $("#searchKeyword").bind("keyup",function(event){
            if( event.keyCode == 13){
                doAction("Search");
            }
        });
	});
	
	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
				orgCapaPlanLayerSheet.DoSearch( "${ctx}/OrgCapaPlanPopup.do?cmd=getOrgCapaPlanList", $("#mySheetForm").serialize() );
	            break;
		}
    } 
	
	// 	조회 후 에러 메시지 
	function orgCapaPlanLayerSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
			if (ErrMsg != "") {
				alert(ErrMsg);
			}

			sheetResize();
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	
	// 셀 클릭시 발생
	function orgCapaPlanLayerSheet_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( orgCapaPlanLayerSheet.ColSaveName(Col) == "ibsImage" 	&& Row >= orgCapaPlanLayerSheet.HeaderRows() ) {

		    	var applSabun = orgCapaPlanLayerSheet.GetCellValue(Row,"applSabun");
	    		var applSeq = orgCapaPlanLayerSheet.GetCellValue(Row,"applSeq");
	    		var applInSabun = orgCapaPlanLayerSheet.GetCellValue(Row,"applInSabun");
	    		var applYmd = orgCapaPlanLayerSheet.GetCellValue(Row,"applYmd");

	    		showApplPopup("R",applSeq,applSabun,applInSabun,applYmd);

		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	//신청 팝업
	function showApplPopup(auth,seq,applSabun,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}
		var url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
		var initFunc = 'initResultLayer';
		var p = {
				searchApplCd: '141'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: applSabun
			  , searchApplYmd: applYmd 
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '근태신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						//getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
		//window.top.openLayer(url, p, 800, 815, initFunc, getReturnValue);
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="mySheetForm" name="mySheetForm">
                <input type="hidden" id="searchStatusCd" name="searchStatusCd" value="RA"/> 
                <input type="hidden" id="searchEmpType" name="searchEmpType" value="P"/> <!-- 팝업에서 사용 -->
                <input type="hidden" id="searchUserId" name="searchUserId" /> 
                <input type="hidden" id="searchOrgCd" name="searchOrgCd" />
                <input type="hidden" id="searchBaseDate" name="searchBaseDate" />
                <input type="hidden" id="searchMonth" name="searchMonth" />
	        </form>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">인력충원 계획 팝업</li>
				</ul>
				</div>
			</div>
<%--			<script type="text/javascript">createIBSheet("orgCapaPlanLayerSheet", "100%", "100%","kr"); </script>--%>
            <div id="orgCapaPlanLayerSheet-wrap"></div>

            <div class="modal_footer">
                <a href="javascript:closeCommonLayer('orgCapaPlanLayer');" class="gray large">닫기</a>
            </div>
        </div>
    </div>
</body>
</html>
