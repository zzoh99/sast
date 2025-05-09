<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='113160' mdef='급여변동내역(개인별-항목별)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!--
 * 급여변동내역(개인별-항목별)
 * @author JM
-->
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
$(function() {

	$("input[type='text'], textarea").keydown(function(event){
		if(event.keyCode == 27){
			return false;
		}
	});

	$("#searchNm").bind("keyup",function(event){
		if( event.keyCode == 13){
			doAction1("Search");
		}
	});

	var initdata1 = {};
	initdata1.Cfg = {SearchMode:smLazyLoad, Page:22};
	initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};
	initdata1.Cols = [
	          		{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
	        		{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 },
	        		{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 },
	        		{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	        		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
	        		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	        		{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
	        		{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
	        		{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Combo",		Hidden:Number("${jgHdn}"),					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
	        		{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Combo",		Hidden:Number("${jwHdn}"),					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
	]; IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);

	//------------------------------------- 그리드 콤보 -------------------------------------//
	// 직책코드(H20020)
	var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
	sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

	// 직급코드(H20010)
	var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
	sheet1.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});

	// 직위코드(H20030)
	var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
	sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});

	//$(window).smartresize(sheetResize);
	sheetInit();

});

function chkInVal(sAction) {
	if ($("#payActionCd1").val() == "" || $("#payActionCd2").val() == "") {
		alert("<msg:txt mid='110014' mdef='급여일자1 및 급여일자2를 선택하시기 바랍니다.'/>");
		$("#payActionNm1").focus();
		return false;
	}else{
		var payActionCds = $("#payActionCd1").val()+","+$("#payActionCd2").val();
		$("#payActionCds").val(payActionCds);
	}

	return true;
}

function doAction1(sAction) {
	switch (sAction) {
		case "Search":
			// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}

			searchTitleList();

			sheet1.DoSearch("${ctx}/PayChgMonPerEleSta2.do?cmd=getPayChgMonPerEleSta2List", $("#sheet1Form").serialize());
			break;

		case "Clear":
			sheet1.RemoveAll();
			break;

		case "Down2Excel":
			//삭제/상태/hidden 지우고 엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
	}
}


function searchTitleList() {
	// 급여구분별 항목리스트 조회
	var titleList = ajaxCall("${ctx}/PayChgMonPerEleSta2.do?cmd=getPayChgMonPerEleSta2TitleList", $("#sheet1Form").serialize(), false);

	if (titleList != null && titleList.DATA != null) {

		// IBSheet에 설정된 모든 기본 속성을 제거하고 초기상태로 변경한다.
		sheet1.Reset();

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:10};
		initdata1.HeaderMode = {Sort:1, ColMove:1, ColResize:1, HeaderCheck:0};

		var jj=0;
		initdata1.Cols = [];
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",		Sort:0 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",		Sort:0 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",		Hidden:0,					Width:120,			Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",	Type:"Text",		Hidden:Number("${aliasHdn}"),					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"alias",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Combo",		Hidden:Number("${jgHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };
		initdata1.Cols[jj++] = {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Combo",		Hidden:Number("${jwHdn}"),	Width:60,			Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 };

		var elementCd = "";
		var j=0;

		for(var i=0; i<titleList.DATA.length; i++) {
			elementCd = convCamel(titleList.DATA[i].elementCd);

			initdata1.Cols[j+jj] = {Header:titleList.DATA[i].elementNm+"\n(급여일자1)",Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:elementCd,	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			initdata1.Cols[(j+1)+jj] = {Header:titleList.DATA[i].elementNm+"\n(급여일자2)",Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:elementCd+"b",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			initdata1.Cols[(j+2)+jj] = {Header:titleList.DATA[i].elementNm+"\n(차액)",Type:"AutoSum",	Hidden:0,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:elementCd+"c",	KeyField:0,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 };
			j = j+3;

		}
		IBS_InitSheet(sheet1, initdata1); sheet1.SetCountPosition(0);
		//$(window).smartresize(sheetResize);
		//sheetInit();

		//------------------------------------- 그리드 콤보 -------------------------------------//

		// 직책코드(H20020)
		var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
		sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});

		// 직급코드(H20030)
		var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
		sheet1.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});

		// 직위코드(H20030)
		var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
		sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});
	}
}

// 조회 후 에러 메시지
function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
			if (Msg != "") {
				alert(Msg);
			}
			//sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
}

// 급여일자 검색 팝입
function payActionSearchPopup(id) {
	if(!isPopup()) {return;}
	gPRow = "";
	pGubun = "payDayPopup"+id;

	let layerModal = new window.top.document.LayerModal({
		id : 'payDayLayer'
		, url : '/PayDayPopup.do?cmd=viewPayDayLayer&authPg=R'
		, parameters : {
			runType : '00001,00002,00003,R0001,R0002,R0003'
		}
		, width : 840
		, height : 520
		, title : '<tit:txt mid='payDayPop' mdef='급여일자 조회'/>'
		, trigger :[
			{
				name : 'payDayTrigger'
				, callback : function(result){
					getReturnValue(result)
				}
			}
		]
	});
	layerModal.show();
}

function getReturnValue(rv) {
    if(pGubun == "payDayPopup1"){
		$("#payActionCd1").val(rv["payActionCd"]);
		$("#payActionNm1").val(rv["payActionNm"]);
    } else if(pGubun == "payDayPopup2"){
		$("#payActionCd2").val(rv["payActionCd"]);
		$("#payActionNm2").val(rv["payActionNm"]);
    }
}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<input type="hidden" id="payActionCds" name="payActionCds" value="" />
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113161' mdef='급여일자1'/></th>
						<td> 
							<input type="hidden" id="payActionCd1" name="payActionCd1" value="" />
							<input type="text" id="payActionNm1" name="payActionNm1" class="text required readonly" value="" readonly style="width:180px" />
							<a onclick="javascript:payActionSearchPopup('1');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
						<th><tit:txt mid='114595' mdef='급여일자2'/></th>
						<td> 
							<input type="hidden" id="payActionCd2" name="payActionCd2" value="" />
							<input type="text" id="payActionNm2" name="payActionNm2" class="text required readonly" value="" readonly style="width:180px" />
							<a onclick="javascript:payActionSearchPopup('2');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='113162' mdef='수당/공제'/></th>
						<td>
							<select id="elementType" name="elementType">
								<option value="" selected><tit:txt mid='103895' mdef='전체'/></option>
								<option value="A"><tit:txt mid='114403' mdef='수당'/></option>
								<option value="D"><tit:txt mid='perPayMasterMgrException2' mdef='공제'/></option>
							</select>
						</td>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td> 
							<input id="searchNm" name ="searchNm" type="text" class="text" />
							<btn:a href="javascript:doAction1('Search')"	css="button authR" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='113163' mdef='급여변동내역(당전차)'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')"	css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
