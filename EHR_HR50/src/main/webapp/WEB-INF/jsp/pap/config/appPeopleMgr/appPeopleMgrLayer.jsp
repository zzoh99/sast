<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>평가그룹팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

	<script type="text/javascript">
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('appPeopleMgrLayer');
		var arg = modal.parameters;
	    if( arg != undefined ) {
		    $("#searchAppraisalCd", "#appPeopleMgrLayerSht1Form").val(arg["searchAppraisalCd"]);
		    $("#searchAppSeqCd", "#appPeopleMgrLayerSht1Form").val(arg["searchAppSeqCd"]);
	    }
	});

	$(function() {
		createIBSheet3(document.getElementById('appPeopleMgrLayerSht1-wrap'), "appPeopleMgrLayerSht1", "100%", "100%", "${ssnLocaleCd}");

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
				{Header:"No"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제"			,Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center", ColMerge:0,	SaveName:"sDelete" },
				{Header:"상태"			,Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center", ColMerge:0,	SaveName:"sStatus" },

				{Header:"평가그룹"		,Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appGroupNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
				{Header:"평가그룹코드"		,Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"appGroupCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 }
		]; IBS_InitSheet(appPeopleMgrLayerSht1, initdata);appPeopleMgrLayerSht1.SetEditable(false);appPeopleMgrLayerSht1.SetVisible(true);appPeopleMgrLayerSht1.SetCountPosition(4);appPeopleMgrLayerSht1.SetUnicodeByte(3);

		$(window).smartresize(sheetResize); sheetInit();
		doLayerAction1("Search");

		$("#searchAppGroupNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doLayerAction1("Search");
			}
		});

	});

	function doLayerAction1(sAction){
		//removeErrMsg();
		switch(sAction){
			case "Search":		//조회
				appPeopleMgrLayerSht1.DoSearch("${ctx}/AppPeopleMgr.do?cmd=getAppPeopleMgrPopList", $("#appPeopleMgrLayerSht1Form").serialize());
				break;
		}
	}

	//조회 후 에러 메시지
	function appPeopleMgrLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function appPeopleMgrLayerSht1_OnDblClick(Row, Col){
		try{
			setValue();
		} catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}

	function setValue() {
		var rv = new Array();

		rv["appGroupCd"] = appPeopleMgrLayerSht1.GetCellValue(appPeopleMgrLayerSht1.GetSelectRow(), "appGroupCd");
		rv["appGroupNm"] = appPeopleMgrLayerSht1.GetCellValue(appPeopleMgrLayerSht1.GetSelectRow(), "appGroupNm");

		const modal = window.top.document.LayerModalUtility.getModal('appPeopleMgrLayer');
		modal.fire('appPeopleMgrLayerTrigger', rv).hide();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="appPeopleMgrLayerSht1Form" name="appPeopleMgrLayerSht1Form" >
		<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" />
		<input id="searchAppSeqCd" name="searchAppSeqCd" type="hidden" />

		<div class="sheet_search outer">
            <div>
            <table>
            <tr>
                <td> <span>평가그룹</span> <input type="text" name="searchAppGroupNm" id="searchAppGroupNm" type="text" class="text" /> </td>
                <td>
                    <a href="javascript:doLayerAction1('Search')" id="btnSearch" class="btn dark">조회</a>
                </td>
            </tr>
            </table>
            </div>
        </div>
		</form>
		<div class="inner">
			<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">평가그룹조회</li>
			</ul>
			</div>
		</div>
		<div id="appPeopleMgrLayerSht1-wrap"></div>

	</div>
	<div class="modal_footer">
		<a href="javascript:setValue();" id="prcCall" class="btn filled">확인</a>
		<a href="javascript:closeCommonLayer('appPeopleMgrLayer')" class="btn outline_gray">닫기</a>
	</div>
</div>
</body>
</html>