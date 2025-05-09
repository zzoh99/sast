<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {

		$("#searchSYm").datepicker2({ymonly:true});
		$("#searchEYm").datepicker2({ymonly:true});
		
		$("#searchSYm").val(addDate("m", -2,"${curSysYyyyMMdd}", "-"));
    	$("#searchEYm").val("${curSysYear}"+"-"+"${curSysMon}");

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"지급일자",	Type:"Date",      	Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"paymentYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"귀속년월",	Type:"Date",      	Hidden:0,  Width:100,	Align:"Center",  ColMerge:0,   SaveName:"payYm",		KeyField:0,   CalcLogic:"",   Format:"Ym",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:7 },
			{Header:"",     	Type:"Text",      	Hidden:1,  Width:100,	Align:"Left",  ColMerge:0,   SaveName:"payActionCd",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"계산명",     	Type:"Text",      	Hidden:0,  Width:100,	Align:"Left",  ColMerge:0,   SaveName:"payActionNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"성명",      	Type:"Text",      	Hidden:0,  Width:80,	Align:"Center",  ColMerge:0,   SaveName:"name",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:30 },
			{Header:"사번",		Type:"Text",      	Hidden:0,  Width:90,	Align:"Center",  ColMerge:0,   SaveName:"sabun",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
			{Header:"소속",     Type:"Text",      	Hidden:0,  Width:120,	Align:"Left",  ColMerge:0,   SaveName:"orgNm",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
			{Header:"직급",     Type:"Text",      	Hidden:0,  Width:120,	Align:"Left",  ColMerge:0,   SaveName:"jikgubNm",       	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
			{Header:"전체",      	Type:"CheckBox",  	Hidden:0,  Width:40,	Align:"Center",  ColMerge:0,   SaveName:"checked",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10, TrueValue:"Y", FalseValue:"N" },
			{Header:"rk",                 Type:"Text",      Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"rk",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		//sheet1.SetColProperty("mapTypeCd", 			{ComboText:orgMappingGbn[0], ComboCode:orgMappingGbn[1]} );	//소속맵핑구분

		//사업장 코드
		<c:choose>
			<c:when test="${ssnSearchType == 'A'}">
				var searchBizPlaceCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "전체");
			</c:when>
			<c:otherwise>
				var searchBizPlaceCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getTcpn121List", false).codeList, "");
			</c:otherwise>
		</c:choose>
		$("#searchBizPlaceCd").html(searchBizPlaceCd[2]);

		$("#searchText, #searchSYm, #searchEYm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		var msg = {};
		setValidate($("#srchFrm"),msg);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
							sheet1.DoSearch( "${ctx}/RetMonPayAdjust.do?cmd=getRetMonRptStaList", $("#srchFrm").serialize() );
							break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	function showRd() {
		//출력 대상자 rk 추출
		let rkList = [];
		let checkedRows = sheet1.FindCheckedRow('checked');
		if (checkedRows === "") {
			alert("선택된 대상자가 없습니다.");
			return;
		}

		$(checkedRows.split("|")).each(function(index,value){
			rkList.push(sheet1.GetCellValue(value, 'rk'));
		});

		const data = {
			rk : rkList
		};
		window.top.showRdLayer('/RetMonPayAdjust.do?cmd=getEncryptRd', data);

	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchOrgCd" name="searchOrgCd" value =""/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>대상년월</th>
						<td> 
							<input type="text" id="searchSYm" name="searchSYm" class="date2"  /> ~
						    <input type="text" id="searchEYm" name="searchEYm" class="date2"  />
					    </td>
					    <th class="hide">사업장</th>
	                    <td class='hide'><select id="searchBizPlaceCd" name="searchBizPlaceCd"  onChange="javascript:doAction1('Search')"></select></td>
	                    <th>사번/성명</th>
	                    <td>
							<input type="text" id="searchText" name ="searchText" onChange="javascript:doAction1('Search')" class="text">
						</td>
						<td><a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a></td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="*"/>
			<col width="252px"/>
		</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">퇴직종합정산서</li>
							<li class="btn">
								<a href="javascript:showRd()" 	class="btn outline_gray authA">출력</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
			<td class="sheet_right">
			    <!-- 팁 시작 -->
			    <table>
			    <tr><td>&nbsp;</td></tr>
			    <tr><td>&nbsp;</td></tr>
			    <tr>
			    <td>
				    <div class="explain w100p">
				    <dl>
				        <dd>1. [퇴직종합정산서] 발행화면입니다.</dd>
				        <dd>2. [전체]를 선택하면 선택된 사원에 관계없이<br/><span>&nbsp;&nbsp;&nbsp;모든 사원에 대해 출력됩니다.</span></dd>
				        <dd>3. 특정 사원에 대해서만 출력하려면,<br /><span>&nbsp;&nbsp;&nbsp;[전체] 선택을 해지한 후,</span><br /><span>&nbsp;&nbsp;&nbsp;원하는 사원을 선택하시면 됩니다.</span></dd>
				    </dl>
				    </div>
				</td>
				</tr>
				</table>
			    <!-- 팁 종료 -->
			</td>
		</tr>
	</table>
</div>
</body>
</html>