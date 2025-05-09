<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@	include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='langMgr' mdef='언어관리'/></title>

<%@	include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@	include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script	type="text/javascript">
	$(function() {
		$("#searchSdate").datepicker2();

		/* 좌측시트 */
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",		ColMerge:0,		SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",		ColMerge:0,		SaveName:"sDelete",		Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",		ColMerge:0,		SaveName:"sStatus",		Sort:0 },
			{Header:"<sht:txt mid='langCd' mdef='언어'/>",				Type:"Combo",		Hidden:0,						Width:65,			Align:"Left",		ColMerge:0,		SaveName:"langCd",		KeyField:1,	Format:"",			UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='countryCd' mdef='언어사용국가'/>",	Type:"Combo",		Hidden:0,						Width:90,			Align:"Left",		ColMerge:0,		SaveName:"countryCd",	KeyField:1,	Format:"",			UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",			Type:"Int",			Hidden:0,						Width:0,			Align:"Center",		ColMerge:0,		SaveName:"seq",			KeyField:1,	Format:"Integer",	  UpdateEdit:1,	InsertEdit:1,	EditLen:5	},
			//{Header:"<sht:txt mid='tmpUseYn' mdef='사용여부'/>",		Type:"Combo",		Hidden:0,						Width:0,			Align:"Center",		ColMerge:0,		SaveName:"useYn",		KeyField:1,	Format:"",			  UpdateEdit:1,	InsertEdit:1,	EditLen:1	}
			{Header:"<sht:txt mid='useYnV3' mdef='사용\n여부'/>",		Type:"CheckBox",	Hidden:0,						Width:40,			Align:"Center",		ColMerge:0,		SaveName:"useYn",		KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"1",	FalseValue:"0" }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var langCd		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L00100"), ""); //언어관리
		var countryCd	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLangCountryList",false).codeList, "<sht:txt mid='check' mdef='선택'/>"); //사용언어국가선택

		//sheet1.SetColProperty("useYn",		{ComboText:"|Y|N", ComboCode:"|Y|N"} ); //사용여부
		sheet1.SetColProperty("langCd",			{ComboText:"|"+langCd[0], ComboCode:"|"+langCd[1]} ); //언어관리
		sheet1.SetColProperty("countryCd",		{ComboText:"|"+countryCd[0], ComboCode:"|"+countryCd[1]} ); //언어관리


		/* 우측시트 */
		var initdata = {};
			initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0, SaveName:"sDelete", Sort:0 },
				{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0, SaveName:"sStatus", Sort:0 },
				{Header:"<sht:txt mid='langCdV1' mdef='언어코드'/>",		Type:"Combo",		Hidden:0,						Width:65,			Align:"Center",	ColMerge:0,	SaveName:"langCd",	KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
				{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",			Type:"Int",			Hidden:0,						Width:0,			Align:"Center",	ColMerge:0,	SaveName:"seq",		KeyField:1,	CalcLogic:"",	Format:"Integer",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:5 },
			//  {Header:"<sht:txt mid='tmpUseYn' mdef='사용여부'/>",		Type:"Combo",		Hidden:0,						Width:0,			Align:"Center",	ColMerge:0,	SaveName:"useYn",	KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
				{Header:"<sht:txt mid='useYnV3' mdef='사용\n여부'/>",		Type:"CheckBox",	Hidden:0,						Width:40,			Align:"Center",	ColMerge:0,	SaveName:"useYn",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"1", FalseValue:"0" },
//				{Header:"<sht:txt mid='defaultYn' mdef='기본여부'/>",		Type:"Combo",		Hidden:0,						Width:0,			Align:"Center",	ColMerge:0,	SaveName:"defaultYn",		KeyField:1,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 }
				{Header:"<sht:txt mid='defaultYn_V307' mdef='기본'/>",		Type:"Radio",		Hidden:0,						Width:50,			Align:"Center",	ColMerge:0,	SaveName:"defaultYn",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
				
				{Header:"<sht:txt mid='countryCd' mdef='언어사용국가'/>",   Type:"Text", Hidden:1,SaveName:"countryCd"}
			]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

			//var mainAppType = convCode(ajaxCall("${ctx}/LangId.do?cmd=getLangIdCodeList","",false).DATA,"<tit:txt mid='103895' mdef='전체'/>");	//언어코드
			var sheet2_langCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getUseLangCd",false).codeList, "<sht:txt mid='check' mdef='선택'/>"); //사용언어국가선택

			//sheet2.SetColProperty("useYn",			{ComboText:"|Y|N",	ComboCode:"|Y|N"} ); //사용여부
			//sheet2.SetColProperty("defaultYn",		{ComboText:"|Y|N",	ComboCode:"|Y|N"} ); //기본여부
			sheet2.SetColProperty("langCd",			{ComboText:sheet2_langCd[0], ComboCode:sheet2_langCd[1]} ); //사용언어코드

			$(window).smartresize(sheetResize); sheetInit();
			sheet2.SetFocusAfterProcess(0);

			doAction1("Search");
			doAction2("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/LangMgr.do?cmd=getLangMgrList", $("#sheetForm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/LangMgr.do?cmd=saveLangMgr", $("#sheetForm").serialize() );
			break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Down2Excel":
			sheet1.Down2Excel();
			break;
		case "test1":
			sheet1.DataCopy();
			break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/LangMgr.do?cmd=getUseLangMgrList", $("#sheetForm").serialize() );
			break;
		case "Save":		//if(default_Check()){
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave( "${ctx}/LangMgr.do?cmd=saveUseLangMgr", $("#sheetForm").serialize() );
			break;
							//}else{
							//	  break;
							//}
		case "Insert":
			var Row = sheet2.DataInsert(0);
			changeCountry(Row);		
			break;
		}
	}

	// LEFT 조회 후 에러	메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// RIGHT 조회	후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// LEFT 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} if( Number(Code) > 0){ doAction1("Search");

		//var mainAppType	  = convCode(ajaxCall("${ctx}/LangMgr.do?cmd=getUseLangMgrCodeList","",false).DATA,"<tit:txt mid='103895' mdef='전체'/>"); //언어코드
		//sheet2.SetColProperty("langId",			 {ComboText:mainAppType[0],	ComboCode:mainAppType[1]} );   //언어코드

		doAction2("Search");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	// RIGHT 저장	후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} if( Number(Code) > 0){ doAction2("Search");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}
	
	//RIGHT 입력 또는 수정 시 메시지
	function sheet2_OnChange(Row, Col, Value, OldValue, RaiseFlag){
		try{
			if( Row < sheet2.HeaderRows() ) return;
			
			if(sheet2.ColSaveName(Col) == "langCd") {
				changeCountry(Row);
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
	
	//sheet2 언어코드 변경 시 언어국가 설정
	function changeCountry(Row){
		var langCd = sheet2.GetCellValue(Row,"langCd");
		console.log(langCd);
		
		for(var i = 1; i <= sheet1.LastRow(); i++){
			if(sheet1.GetCellValue(i,"langCd") == langCd){	
				var countryCd = sheet1.GetCellValue(i,"countryCd");
				console.log(countryCd);
				sheet2.SetCellValue(Row,"countryCd",countryCd); 
			}
		}
	}
/*
	function default_Check(){
		var	default_cnt=0;
		for(i=0; i<sheet2.RowCount(); i++){
			if(sheet2.GetCellValue(i+1,6)=='Y'){
				default_cnt++;
			}
		}

		if(default_cnt == 0){
			alert("<msg:txt mid='alertLangMgr1' mdef='기본으로 설정할 언어(기본여부)를 선택하세요.'/>");
			return false;
		}else if(default_cnt > 1){
			alert("<msg:txt mid='alertLangMgr2' mdef='기본으로 설정할 언어(기본여부)는 한 개만 가능합니다.'/>");
			return false;
		}else{
			return true;
		}
	}
*/
 

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<div class="explain position_top outer">
		<div class="title"><tit:txt mid='112541' mdef='다국어 사용 설정 '/></div>
		<div class="txt">
			<ul>

				<li><tit:txt mid='114308' mdef='1. [작업1] 설정테이블에 다국어 사용여부 체크.'/></li>
				<li><tit:txt mid='113264' mdef='2. [작업2] 법인설정 메뉴에서 회사별 다국어 사용여부 체크.'/></li>
				<li><tit:txt mid='112216' mdef='3. [작업3] 어휘관리에서 적용 버튼 클릭.'/></li>
				<li><tit:txt mid='112895' mdef='3. [작업4] 로그아웃 후 재로그인 .'/></li>

				<!--
				<li><br></li>

				<li display:none>
				<a href="javascript:doAction1('lanJob1')" id="btnS1" class="gray <c:if test="${map.baseLan=='Y'}" >basic</c:if> large">작업1</a>
				<a href="javascript:doAction1('lanJob2')" id="btnS2" class="gray <c:if test="${map.orgLan=='Y'}" >basic</c:if> large">작업2</a>
				<a href="javascript:doAction1('lanJob3')" id="btnS3" class="orange large"><tit:txt mid='114309' mdef='메모리 적용'/></a>
				<a href="javascript:doAction1('lanJob4')" id="btnS4" class="pink  large"><tit:txt mid='114568' mdef='로그아웃'/></a>
				</li>
				 -->

			</ul>
		</div>
	</div>

	<form id="sheetForm" name="sheetForm"> </form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="55%" />
			<col width="45%" />
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='langMgr' mdef='언어관리'/></li>
							<li class="btn">
								<!--
								<btn:a href="javascript:doAction1('Down2Excel');" mid="110698" mdef="다운로드" css="btn outline-gray authR"/>
								 -->
								<btn:a href="javascript:doAction1('Insert');" mid="110700" mdef="입력" css="btn outline-gray authA"/>
								<btn:a href="javascript:doAction1('Save');" mid="110708" mdef="저장" css="btn filled authA"/>
								<btn:a href="javascript:doAction1('Search');" mid="110697" mdef="조회" css="btn dark authR"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
			<td	class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='langMgrV1' mdef='사용언어관리'/></li>
							<li class="btn">
								<!--
								<btn:a href="javascript:doAction2('Down2Excel');" mid="110698" mdef="다운로드" css="btn outline-gray authR"/>
								 -->
								<btn:a href="javascript:doAction2('Insert');" mid="110700" mdef="입력" css="btn outline-gray authA"/>
								<btn:a href="javascript:doAction2('Save');" mid="110708" mdef="저장" css="btn filled authA"/>
								<btn:a href="javascript:doAction2('Search');" mid="110697" mdef="조회" css="btn dark authR"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>


</div>
</body>
</html>
