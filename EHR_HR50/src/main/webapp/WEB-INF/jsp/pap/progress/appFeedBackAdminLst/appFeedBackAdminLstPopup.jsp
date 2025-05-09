<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var arg = p.window.dialogArguments;

	$(function() {
		if ( arg != "undefined"){
			$("#searchSabun").val(arg["searchSabun"]);
			//$("#searchAppraisalCd").val(arg["searchAppraisalCd"]);
			$("#searchYear").val(arg["searchYear"]);
		}

		var initdata = {};
		initdata.Cfg = {/* FrozenCol:6 ,*/SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가ID코드",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사원번호",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"1차 평가의견",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"appAppMemo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100  , MultiLineText:1, ToolTip:1},
			{Header:"2차 평가의견",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"appAppMemo2",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100  , MultiLineText:1, ToolTip:1}

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {

		switch (sAction) {

		 	case "Search": 	 	sheet1.DoSearch( "${ctx}/AppFeedBackAdminLst.do?cmd=getAppFeedBackAdminLstPopupList", $("#srchFrm").serialize() ); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">

	<div class="popup_title">
		<ul>
			<li>평가의견</li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
	            <form id="srchFrm" name="srchFrm">

	            	<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	                <input type="hidden" id="searchAppSabun" name="searchAppSabun" value=""/>
	                <input type="hidden" id="searchYear" name="searchYear" value=""/>
	                <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
		        </form>

        	<div id="tabs">
				<ul class="outer tab_bottom">
				</ul>

					<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
						<tr>
							<td>
								<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
								<div class="inner">
				<table class="w100p">
					<colgroup>
						<col width="50%" />
						<col width="50%" />
					</colgroup>
					<tr>
						<td>
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">1차평가의견</li>
								</ul>
							</div>
						</td>
						<td>
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt">2차평가의견</li>
								</ul>
							</div>
						</td>
					</tr>
				</table>

				<table class="table w100p" id="htmlTable">
					<tr>
						<td>
							<textarea id="appAppMemo" name="appAppMemo" class="w100p" rows="5"></textarea>
						</td>
						<td>
							<textarea id="appAppMemo2" name="appAppMemo2" class="w100p" rows="5"></textarea>
						</td>
					</tr>
				</table>
			</div>
							</td>
						</tr>
					</table>
			</div>

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