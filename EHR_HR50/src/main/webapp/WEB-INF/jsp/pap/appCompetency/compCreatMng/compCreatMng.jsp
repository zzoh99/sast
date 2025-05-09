<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		// 공통코드 조회
		var compAppraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getCompAppraisalCdList",false).codeList, "");
		var colSeqList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L90070"));

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='enterCd' mdef='hidden|hidden'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='wEnterCd' mdef='hidden|hidden'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"wEnterCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='wEnterNm' mdef='회사|회사'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"wEnterNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|성명",			Type:"Popup",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"피평가자|사번",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"영문약자|영문약자",			Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='appResult' mdef='hidden|hidden'/>",	Type:"Text",	Hidden:1,	Width:160,	Align:"Left",	ColMerge:0,	SaveName:"compAppraisalCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"피평가자|소속",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"sabunOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|직책",			Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabunJikchakNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCdV1' mdef='직급|직급'/>",			Type:"Text",	Hidden:Number("${jgHdn}"),	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabunJikweeNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"피평가자|직위",			Type:"Text",	Hidden:Number("${jwHdn}"),	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabunJikgubNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCd' mdef='평가자|hidden'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appEnterCd",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterNm' mdef='평가자|회사'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appEnterNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appName' mdef='평가자|성명'/>",			Type:"Popup",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appName",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appSabun' mdef='평가자|사번'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"평가자|영문약자",			Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appAlias",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='appOrgNm' mdef='평가자|소속'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appJikweeNm' mdef='평가자|직급'/>",			Type:"Text",	Hidden:Number("${jgHdn}"),	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appJikgubNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeNm_V16' mdef='평가자|직위'/>",			Type:"Text",	Hidden:Number("${jwHdn}"),	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appJikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appJikchakNm' mdef='평가자|직책'/>",			Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appJikchakNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='ldsCompetencyCd' mdef='hidden|hidden'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompetencyCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"문항\n번호|문항\n번호",			Type:"Text",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ldsCompetencyNmV2' mdef='역량|역량'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompetencyNm",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='ldsCompBenmV1' mdef='지표|지표'/>",			Type:"Text",	Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompBenm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appResult' mdef='hidden|hidden'/>",	Type:"Text",	Hidden:1,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"appResult",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",			Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		$(window).smartresize(sheetResize); sheetInit();

		// 조회조건 이벤트
		$("#searchCompAppraisalCd").bind("change", function(){
			doAction1("Search");
		});

		$("#searchCondition").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		// 조회조건 값 setting
		$("#searchCompAppraisalCd").html(compAppraisalCdList[2]);

		doAction1("Search");
	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet1.DoSearch( "${ctx}/CompCreatMng.do?cmd=getCompCreatMngList", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/CompCreatMng.do?cmd=saveCompCreatMng", $("#srchFrm").serialize() );
				break;

			case "Insert":		//입력
				var Row = sheet1.DataInsert(0);
				break;

			case "Copy":		//행복사
				var Row = sheet1.DataCopy();
				sheet1.SetCellValue(Row, "compApprasialCd", "");
				break;

			case "Clear":		//Clear
				sheet1.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;
		}
	}

	//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
		//setSheetSize(this);
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	//<!-- 저장 후 에러 메시지 -->
	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

	//<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
			// Insert KEY
			if(Shift == 1 && KeyCode == 45){
				doAction1("Insert");
			}

			//Delete KEY
			if(Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row,"sStatus") == "I"){
				sheet1.SetCellValue(Row,"sStatus","D");
			}
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}

	function createSht(){
    	var data = ajaxCall("${ctx}/CompCreatMng.do?cmd=prcCompCreatMng",$("#srchFrm").serialize() + "&searchSabun=",false);
		if(data.Result.Code == null) {
			alert("다면평가항목 생성이 완료되었습니다.");
			doAction1("Search");
    	} else {
	    	alert(data.Result.Message);
    	}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>다면평가명</span>
							<SELECT id="searchCompAppraisalCd" name="searchCompAppraisalCd" class="box"></SELECT>
						</td>
						<td>
							<span>대상자(피평가자)</span>
							<input type="radio" id="searchConditionType1" name="searchConditionType" value="NAME" class="radio" checked/> <label for="searchConditionType1">성명</label>
							<input type="radio" id="searchConditionType2" name="searchConditionType" value="SABUN" class="radio" /> <label for="searchConditionType2">사번</label>
							<input type="text" id="searchCondition" name="searchCondition" class="text" />
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
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
							<li id="txt" class="txt">평가항목관리</li>
							<li class="btn">
								<a href="javascript:createSht()" 	class="button authA">다면평가항목생성</a>
								<a href="javascript:doAction1('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
