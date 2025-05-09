<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
	$(function() {

		$("#searchFrom").datepicker2({startdate:"searchTo", onReturn: getCommonCodeList});
		$("#searchTo").datepicker2({enddate:"searchFrom", onReturn: getCommonCodeList});

		//종료일 2개월 더하기
		$("#searchTo").val(addDate("m", 2,"${curSysYyyyMMdd}", "-"));

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",      		Type:"${sNoTy}",		Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",    		Type:"${sDelTy}",		Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",    		Type:"${sSttTy}",		Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },

	  			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",			Type:"Combo",	Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"code",				KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1 },
	  			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"sabun",				KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:50},
	  			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",	Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"name",				KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:50},
	  			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",		Type:"Text",	Hidden:0, Width:70,  Align:"Center", ColMerge:0,  SaveName:"statusNm",			KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:50},
	  			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",			Type:"Text",	Hidden:0, Width:120, Align:"Center", ColMerge:0,  SaveName:"orgNm",				KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:50},
	  			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",			Type:"Text",	Hidden:0, Width:80 , Align:"Center", ColMerge:0,  SaveName:"jikchakNm", 		KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:50},
	  			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",			Type:"Text",	Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"jikweeNm",			KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:50},
	  			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",	Hidden:1, Width:80,  Align:"Center", ColMerge:0,  SaveName:"jikgubNm",			KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:50},
	  			{Header:"<sht:txt mid='mailcont' mdef='내용'/>",			Type:"Text",	Hidden:0, Width:80 , Align:"Center", ColMerge:0,  SaveName:"ordTypeReasonNm", 	KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:50},
	  			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",	Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"sdate" ,  			KeyField:0,   CalcLogic:"", Format:"Ymd",  		PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:50},
	  			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",			Type:"Date",	Hidden:0, Width:80,  Align:"Center", ColMerge:0,  SaveName:"edate" , 			KeyField:0,   CalcLogic:"", Format:"Ymd",  		PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:50},
  			];

		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		getCommonCodeList();

		$(window).smartresize(sheetResize); sheetInit();
 		doAction1("Search");
	});

	function getCommonCodeList() {
		let baseSYmd = $("#searchFrom").val();
		let baseEYmd = $("#searchTo").val();
		//H60300
		var code		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H60300", baseSYmd, baseEYmd),"");//구분
		sheet1.SetColProperty("code", 			{ComboText:code[0], ComboCode:code[1]} );
		$("#searchCode").html(code[2]);
		$("#searchCode").select2({placeholder:" 전체"});

		// 재직상태
		var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd, baseEYmd), "");
		select2MultiChoose(statusCd[2], "AA", "searchStatusCd", "<tit:txt mid='103895' mdef='전체'/>");
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$("#multiSearchCode").val(getMultiSelect($("#searchCode").val()));
			$("#multiStatusCd").val(getMultiSelect($("#searchStatusCd").val()));

			sheet1.DoSearch( "${ctx}/RenewalLst.do?cmd=getRenewalLstList", $("#sheet1Form").serialize() ); break;
        case "Save":
        	IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/RenewalLst.do?cmd=saveRenewalLst", $("#sheet1Form").serialize()); break;
        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
				var d = new Date();
				var fName = "갱신예정기한조회_" + d.getTime();
				sheet1.Down2Excel($.extend(param, { FileName:fName, SheetDesign:1, Merge:1 })); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search"); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	var pGubun = "";
//  소속 팝입
	function orgSearchPopup(){
		try{
			if(!isPopup()) {return;}

			pGubun		= "orgSearchPopup";
			// var rv = openPopup("/Popup.do?cmd=orgBasicPopup", args, "740","520");

			var w = 740;
			var h = 520;
			var url = "/Popup.do?cmd=viewOrgBasicLayer";

			let layerModal = new window.top.document.LayerModal({
				id : 'orgLayer'
				, url : url
				, parameters : {}
				, width : w
				, height : h
				, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
				, trigger :[
					{
						name : 'orgTrigger'
						, callback : function(result){
							getReturnValue(result);
						}
					}
				]
			});
			layerModal.show();

		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}


//  사원 팝입
	function employeePopup(){
		try{
			if(!isPopup()) {return;}

			pGubun		= "employeePopup";
			var w = 840;
			var h = 520;
			var url = "/Popup.do?cmd=viewEmployeeLayer";

			// var rv = openPopup("/Popup.do?cmd=employeePopup", args, "840","520");

			let layerModal = new window.top.document.LayerModal({
				id : 'employeeLayer'
				, url : url
				, parameters : ''
				, width : w
				, height : h
				, title : '사원조회'
				, trigger :[
					{
						name : 'employeeTrigger'
						, callback : function(result){
							getReturnValue(result);
						}
					}
				]
			});
			layerModal.show();

		}catch(ex){alert("Open Popup Event Error : " + ex);}
	}



	function getReturnValue(rv) {

		if( pGubun == "orgSearchPopup" ){
			$("#searchOrgCd").val(rv[0].orgCd);
			$("#searchOrgNm").val(rv[0].orgNm);
		}
		if( pGubun = "employeePopup" ){
			$("#searchName").val(rv.name);
			$("#searchSabun").val(rv.sabun);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="multiSearchCode" name="multiSearchCode" value="" />
		<input type="hidden" id="multiStatusCd" name="multiStatusCd" />

	<!-- 조회조건 -->
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='103997' mdef='구분'/></th>
						<td>
							<select id="searchCode" name="searchCode" multiple=""></select>
						</td>
						<th><tit:txt mid='104295' mdef='소속 '/></th>
						<td>
							<input id="searchOrgCd" name="searchOrgCd" type="hidden" class="text" readonly />
							<input id="searchOrgNm" name="searchOrgNm" type="text" class="text" readonly />
							<a onclick="javascript:orgSearchPopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<th><tit:txt mid='104450' mdef='성명 '/></th>
						<td>
							<input id="searchName" name="searchName" type="text" class="text" readonly />
							<input type="hidden" id="searchSabun" name="searchSabun" value="" />
							<a onclick="javascript:employeePopup();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchSabun,#searchName').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='111909' mdef='종료일'/></th>
						<td>
							<input type="text" id="searchFrom" name="searchFrom" class="date2" value="${curSysYyyyMMddHyphen}">&nbsp;~&nbsp;
							<input type="text" id="searchTo" name="searchTo" class="date2" value="">
						</td>
						<th><tit:txt mid='104472' mdef='재직상태'/></th>
						<td>
							<select id="searchStatusCd" name="searchStatusCd" multiple></select>
						</td>
						<td colspan="2"> <a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a> </td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='114621' mdef='갱신예정기한조회'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
