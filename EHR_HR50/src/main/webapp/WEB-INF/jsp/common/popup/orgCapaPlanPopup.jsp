<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>인력충원 계획 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var srchBizCd = null;
	
	/*Sheet 기본 설정 */
	$(function() {
    
		var searchOrgCd 	= "";
        var searchOrgNm 	= "";
        var searchBaseDate 	= "";
        var searchMonth 	= "";

        var arg = p.window.dialogArguments;
	    if( arg != undefined ) {
			searchOrgCd 	= arg["orgCd"];
	        searchOrgNm 	= arg["orgNm"];
	        searchBaseDate 	= arg["baseDate"];
	        searchMonth 	= arg["month"];

	    }else{
	    	if(p.popDialogArgument("orgCd")!=null)		searchOrgCd  	= p.popDialogArgument("orgCd");
	    	if(p.popDialogArgument("orgNm")!=null)		searchOrgNm  	= p.popDialogArgument("orgNm");
	    	if(p.popDialogArgument("baseDate")!=null)	searchBaseDate  = p.popDialogArgument("baseDate");
	    	if(p.popDialogArgument("month")!=null)		searchMonth  	= p.popDialogArgument("month");
	    }
	    
        var titleTxt = searchOrgNm + " " + searchBaseDate.substring(0,4) + "년 " + searchMonth + "월 계획인원";
        searchMonth = searchBaseDate.substring(0,4)+searchMonth;
        	
        $("#searchOrgCd").val(searchOrgCd);
        $("#titleTxt").html(titleTxt);
        $("#searchBaseDate").val(searchBaseDate);
        $("#searchMonth").val(searchMonth);
        
		//배열 선언				
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
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
		IBS_InitSheet(sheet1, initdata); sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);
		
		sheet1.SetImageList(0,"/common/images/icon/icon_info.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);

		$(window).smartresize(sheetResize);
		sheetInit();
		
		doAction("Search");

        $(".close").click(function() {
	    	p.self.close();
	    });
	});
	
	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
				sheet1.DoSearch( "${ctx}/OrgCapaPlanPopup.do?cmd=getOrgCapaPlanList", $("#mySheetForm").serialize() );
	            break;
		}
    } 
	
	// 	조회 후 에러 메시지 
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
			if (ErrMsg != "") {
				alert(ErrMsg);
			}

			sheetResize();
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	
	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "ibsImage" 	&& Row >= sheet1.HeaderRows() ) {

		    	var applSabun = sheet1.GetCellValue(Row,"applSabun");
	    		var applSeq = sheet1.GetCellValue(Row,"applSeq");
	    		var applInSabun = sheet1.GetCellValue(Row,"applInSabun");
	    		var applYmd = sheet1.GetCellValue(Row,"applYmd");

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
						getReturnValue(rv);
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

    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li id="titleTxt" name="titleTxt"></li>
                <li class="close"></li>
            </ul>
        </div>
        
        <div class="popup_main">
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
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>

	        <div class="popup_button outer">
	            <ul>
	                <li>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>
