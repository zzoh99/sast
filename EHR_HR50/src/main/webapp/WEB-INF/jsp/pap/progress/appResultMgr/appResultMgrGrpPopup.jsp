<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>평가인원상세조회</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var arg = p.popDialogArgumentAll();

	var searchAppraisalCd = arg['searchAppraisalCd'];

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"평가그룹|평가그룹",	Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appGroupNm",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"등급부여계획|S",	Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appGroupSCnt",	KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"등급부여계획|A",	Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appGroupACnt",	KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"등급부여계획|B",	Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appGroupBCnt",	KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"등급부여계획|C",	Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCCnt",	KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"등급부여계획|D",	Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appGroupDCnt",	KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가결과|S",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sCntR",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가결과|A",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"aCntR",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가결과|B",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"bCntR",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가결과|C",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"cCntR",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가결과|D",		Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"dCntR",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.FocusAfterProcess = false;

		$('#searchAppraisalCd').val(searchAppraisalCd);
		setAppClassCd();


		//평가종류
		var searchAppTypeCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getPapAppGroupTypeList&searchAppraisalCd="+searchAppraisalCd,false).codeList, ""); // 평가명
		$("#searchAppTypeCd").html(searchAppTypeCdList[2]);


		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $(".close").click(function() {
	    	p.self.close();
	    });

        $("#searchAppTypeCd").change(function() {
        	doAction1("Search");
        });
	});


	function setAppClassCd(){

		//평가등급기준 -- 평가종류에 따라 다른 등급을 가져옴.

		var saveNameLst1 = ["sCntR", "aCntR", "bCntR", "cCntR", "dCntR"];
		var saveNameLst2 = ["appGroupSCnt", "appGroupACnt", "appGroupBCnt", "appGroupCCnt", "appGroupDCnt"];

		classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, ""); // 평가등급
    	clsLst = classCdList[0].split("|");

		for( var i=0; i<clsLst.length ; i++){
			sheet1.SetColHidden(saveNameLst1[i], 0 );
			sheet1.SetCellValue(1, saveNameLst1[i], clsLst[i] );
			sheet1.SetColHidden(saveNameLst2[i], 0 );
			sheet1.SetCellValue(1, saveNameLst2[i], clsLst[i] );
		}
		var len = clsLst.length;
		if(classCdList[0] == "" ) len = 0;
		for( var i=len; i<saveNameLst1.length ; i++){
			sheet1.SetColHidden(saveNameLst1[i], 1 );
			sheet1.SetColHidden(saveNameLst2[i], 1 );
		}

	}

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
		    sheet1.DoSearch( "${ctx}/AppResultMgr.do?cmd=getAppResultMgrGrpPopupList", $("#sheet1Form").serialize());
            break;
        case "Clear":        //Clear
            sheet1.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
            break;
		}
    }

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") {
				alert(Msg);
			}

			sheetResize();

			var col1 = ["appGroupSCnt","appGroupACnt","appGroupBCnt","appGroupCCnt","appGroupDCnt"];
			var col2 = ["sCntR","aCntR","bCntR","cCntR","dCntR"];

			for (var i = sheet1.HeaderRows(); i < sheet1.RowCount() + sheet1.HeaderRows(); i++) {
				for(var j = 0; j < col1.length; j++) {
					if(sheet1.GetCellValue(i,col1[j]) != sheet1.GetCellValue(i,col2[j])) {
						sheet1.SetCellBackColor(i,col1[j],"#FF0000");
						sheet1.SetCellBackColor(i,col2[j],"#FF0000");
					}
				}
			}

	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	/*
	// 더블클릭시 발생
	function sheet1_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		}catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}
	*/
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>평가그룹별 평가결과</li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>
	                <div class="inner">
	                    <div class="sheet_title">
	                    <ul>
				            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
							<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" value="">
	                        <li id="txt" class="txt">
	                        	평가종류 :
	                        	<select name="searchAppTypeCd" id="searchAppTypeCd"></select>
	                        	<span>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;*상대평가 대상자에 대한 결과 내용입니다.</span>
	                        </li>
					        </form>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
							</li>
	                    </ul>
	                    </div>
	                </div>
	                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
	                </td>
	            </tr>
	        </table>
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



