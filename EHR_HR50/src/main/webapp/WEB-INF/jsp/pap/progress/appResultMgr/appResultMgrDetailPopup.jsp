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
	var searchSabun = arg['searchSabun'];

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No|No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"평가소속|평가소속",	Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appOrgNm",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"본인|업적",			Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mboTAppSelfPoint",	KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"본인|역량",			Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"compTSelfPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"1차|업적",			Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mboTApp1stPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"1차|역량",			Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"compT1stPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"2차|업적",			Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mboTApp2ndPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"2차|역량",			Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"compT2ndPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"3차|업적",			Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mboTApp3rdPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"3차|역량",			Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"compT3rdPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"합산점수|업적",		Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"mboAppSumPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"합산점수|역량",		Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"compAppSumPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"합산점수(부서이동)|업적",Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"lastMboPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"합산점수(부서이동)|역량",Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"lastCompPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조정점수|업적",		Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"adtMboPoint",			KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"조정점수|역량",		Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"adtCompPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"최종점수|업적",		Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"finalMboPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"최종점수|역량",		Type:"Float",		Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"finalCompPoint",		KeyField:0,	Format:"NullFloat",	PointCount:2,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"반영비율|반영비율",		Type:"Text",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appMRate",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.FocusAfterProcess = false;

		$('#searchAppraisalCd').val(searchAppraisalCd);
		$('#searchSabun').val(searchSabun);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
		    sheet1.DoSearch( "${ctx}/AppResultMgr.do?cmd=getAppResultMgrDetailPopupList", $("#sheet1Form").serialize());
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
			if(Msg != "") alert(Msg);
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>점수상세</li>
                <li class="close"></li>
            </ul>
        </div>

        <div class="popup_main">
            <form id="sheet1Form" name="sheet1Form" onsubmit="return false;">
				<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" value="">
				<input id="searchSabun" name="searchSabun" type="hidden" value="">
	        </form>

	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>
	                <div class="inner">
	                    <div class="sheet_title">
	                    <ul>
	                        <li id="txt" class="txt">점수상세</li>
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



