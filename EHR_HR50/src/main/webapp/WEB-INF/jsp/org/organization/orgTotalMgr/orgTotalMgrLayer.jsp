<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114485' mdef='코드검색'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script type="text/javascript">
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('orgTotalMgrLayer');

		createIBSheet3(document.getElementById('orgTotalMgrLayerSht1-wrap'), "orgTotalMgrLayerSht1", "100%", "100%","${ssnLocaleCd}");


		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"", 	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='orgChartNmV1' mdef='조직도명'/>",	Type:"Text",		Hidden:1,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"", 	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgChartNmV1' mdef='조직도명'/>",	Type:"Text",		Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"orgChartNm",	KeyField:0,	Format:"", 	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"기준일",											Type:"Text",		Hidden:1,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"baseYmd",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(orgTotalMgrLayerSht1, initdata1);orgTotalMgrLayerSht1.SetEditable(false);orgTotalMgrLayerSht1.SetVisible(true);orgTotalMgrLayerSht1.SetCountPosition(4);

		orgTotalMgrLayerSht1.FocusAfterProcess = false;

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	$(function() {

        $(".close").click(function() {
			closeCommonLayer('orgTotalMgrLayer');
	    });
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
		    orgTotalMgrLayerSht1.DoSearch( "${ctx}/OrgTotalMgr.do?cmd=getorgTotalMgrOrgChartNmTORG103", $("#orgTotalMgrLayerSht1Form").serialize());
            break;
        case "Clear":        //Clear
            orgTotalMgrLayerSht1.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기
            orgTotalMgrLayerSht1.Down2Excel();
            break;
		}
    }

	// 조회 후 에러 메시지
	function orgTotalMgrLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	// 더블클릭시 발생
	function orgTotalMgrLayerSht1_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		}catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}

	function returnFindUser(Row,Col){

    	var returnValue = new Array();

    	var sdate      = orgTotalMgrLayerSht1.GetCellValue(Row, "sdate");
    	var orgChartNm = orgTotalMgrLayerSht1.GetCellText(Row,  "orgChartNm");
    	var baseYmd	   = orgTotalMgrLayerSht1.GetCellText(Row,  "baseYmd");

 		returnValue["sdate"]      = sdate;
 		returnValue["orgChartNm"] = orgChartNm;
 		returnValue["baseYmd"] 	  = baseYmd;

		const modal = window.top.document.LayerModalUtility.getModal('orgTotalMgrLayer');
		modal.fire('orgTotalMgrLayerTrigger', returnValue).hide();
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="orgTotalMgrLayerSht1Form" name="orgTotalMgrLayerSht1Form">
	        </form>

	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>
	                <div class="inner">
	                    <div class="sheet_title">
	                    <ul>
	                        <li id="txt" class="txt">조직도 이력</li>
	                    </ul>
	                    </div>
	                </div>
					<div id="orgTotalMgrLayerSht1-wrap"></div>
	                </td>
	            </tr>
	        </table>
        </div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('orgTotalMgrLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a
		</div>
    </div>
</body>
</html>



