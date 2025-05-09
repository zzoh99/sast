<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
var entercdVal = "${ssnEnterCd}";
	$(function() {
		// 공통코드 조회
		var compAppraisalCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getCompAppraisalCdList",false).codeList, "");
		var enterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getEnterCdAllList&enterCd=" + entercdVal,false).codeList, "");
		var compResultCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L90050"));
		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00004&searchUseYn=Y",false).codeList, "");

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='enterCdV3' mdef='ENTER_CD|ENTER_CD'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"다면평가ID|다면평가ID",										Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"compAppraisalCd",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"대상자(피평가자)|회사",										Type:"Combo",	Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"wEnterCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자(피평가자)|성명",										Type:"Popup",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"대상자(피평가자)|사번",										Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"대상자(피평가자)|조직코드",									Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"orgCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"대상자(피평가자)|소속",										Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"대상자(피평가자)|직급",										Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"대상자(피평가자)|직급명",										Type:"Text",	Hidden:Number("${jgHdn}"),	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자(피평가자)|직위",										Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"대상자(피평가자)|직위명",										Type:"Text",	Hidden:Number("${jwHdn}"),	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자(피평가자)|직책",										Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상자(피평가자)|직책명",										Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가포함\n여부|평가포함\n여부",								Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appYn",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='manName' mdef='상사comment|성명'/>",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"manName",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='manSabun' mdef='상사comment|사번'/>",		Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"manSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='manJikchakNm' mdef='상사comment|직책'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"manJikchakNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='compResultCd' mdef='결과|값'/>",			Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compResultCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='qOrgCd' mdef='본부코드|본부코드'/>",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"qOrgCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='qOrgNmV1' mdef='본부명|본부명'/>",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"qOrgNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='jobCdV3' mdef='직무코드|직무코드'/>",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jobCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jobNmV3' mdef='직무명|직무명'/>",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jobNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='jobGroupCd' mdef='직군코드|직군코드'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jobGroupCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='jobGroupNm' mdef='직군명|직군명'/>",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jobGroupNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='finalComment' mdef='최종의견|최종의견'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"finalComment",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000 },
			{Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",					Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='201707270000002' mdef='진행상태|진행상태'/>",	Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appStatus",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetColProperty("wEnterCd",		{ComboText:enterCdList[0], ComboCode:enterCdList[1]} );
		sheet1.SetColProperty("compResultCd",	{ComboText:compResultCdList[0], ComboCode:compResultCdList[1]} );
		sheet1.SetColProperty("appYn",			{ComboText:"|Y|N", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("appStatus",		{ComboText:"미완료|완료", ComboCode:"N|Y"} );

		initdata.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

   			{Header:"다면평가ID",										Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"compAppraisalCd",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"대상자회사",								Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"wEnterCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
   			{Header:"대상자성명",								Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"대상자사번",								Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
   			{Header:"<sht:txt mid='appSeqCd' mdef='차수'/>",			Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='appEnterCdV1' mdef='회사'/>",		Type:"Combo",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appEnterCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
   			{Header:"평가자성명",										Type:"Popup",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appName",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='appSabunV3' mdef='평가자사번'/>",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
   			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"orgCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",			Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='jikgubNmV1' mdef='직급명'/>",		Type:"Text",	Hidden:Number("${jgHdn}"),	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='jikweeNmV1' mdef='직위명'/>",		Type:"Text",	Hidden:Number("${jwHdn}"),	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
   			{Header:"<sht:txt mid='jikchakNmV1' mdef='직책명'/>",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
   			{Header:"<sht:txt mid='jikchakNmV1' mdef='그룹명'/>",		Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appGroup",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='completionV1' mdef='완료여부'/>",	Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ldsAppStatusCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='qOrgCdV1' mdef='본부코드'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"qOrgCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='qOrgNmV2' mdef='본부명'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"qOrgNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
   			{Header:"<sht:txt mid='jikgubNmV1' mdef='직급명'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
   			{Header:"<sht:txt mid='aComment' mdef='장점의견'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"aComment",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000 },
   			{Header:"<sht:txt mid='cComment' mdef='개선점의견'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"cComment",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }
   		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet2.SetColProperty("appSeqCd",		{ComboText:appSeqCdList[0], ComboCode:appSeqCdList[1]} );
		sheet2.SetColProperty("appEnterCd",		{ComboText:enterCdList[0], ComboCode:enterCdList[1]} );
		sheet2.SetColProperty("ldsAppStatusCd",	{ComboText:"N|Y", ComboCode:"N|Y"} );

		$(window).smartresize(sheetResize); sheetInit();

		// 조회조건 이벤트
		$("#searchCompAppraisalCd, #searchAppYn, #searchAppStatus").bind("change", function(){
			doAction1("Search");
		});

		$("#searchCondition").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search"); $(this).focus();
			}
		});

		// 조회조건 값 setting
		$("#searchCompAppraisalCd").html(compAppraisalCdList[2]);

		// 조회
		doAction1("Search");
	});

	// 대상자생성
	function create(){
		if (confirm("기존 대상자는 삭제 됩니다. 대상자를 생성 하시겠습니까?")) {
	    	var data = ajaxCall("${ctx}/CompAppPeopleMng.do?cmd=prcCompAppPeopleMng",$("#srchFrm").serialize(),false);
			if(data.Result.Code == null) {
				alert("<msg:txt mid='alertCreateOk1' mdef='대상자생성이 완료되었습니다.'/>");
				doAction1("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}
		}
	}

</script>

<!-- sheet1 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				$("#searchCompAppraisalCd2").val("");
				$("#searchSabun2").val("");
				$("#searchWEnterCd2").val("");

				doAction2("Clear");

				sheet1.DoSearch( "${ctx}/CompAppPeopleMng.do?cmd=getCompAppPeopleMngList1", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				if(sheet1.FindStatusRow("I") != ""){
					if(!dupChk(sheet1,"compAppraisalCd|wEnterCd|sabun", true, true)){break;}
				}

				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/CompAppPeopleMng.do?cmd=saveCompAppPeopleMng1", $("#srchFrm").serialize() );
				break;

			case "Insert":		//입력
				var Row = sheet1.DataInsert(0);
				sheet1.SetCellValue(Row, "compAppraisalCd", $("#searchCompAppraisalCd").val());
				break;

			case "Copy":		//행복사
				var Row = sheet1.DataCopy();
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
			sheetResize();
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

	// Click 시
	function sheet1_OnClick(Row, Col, Value){
		try{

		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	//<!--셀에 마우스 클릭했을때 발생하는 이벤트-->
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			var Row = NewRow;

			if ( sheet1.GetCellValue(Row, "sStatus") == "I" ) return;
			if ( OldRow == NewRow ) return;

			$("#searchCompAppraisalCd2").val(sheet1.GetCellValue(Row, "compAppraisalCd"));
			$("#searchSabun2").val(sheet1.GetCellValue(Row, "sabun"));
			$("#searchWEnterCd2").val(sheet1.GetCellValue(Row, "wEnterCd"));
			$("#searchName2").val(sheet1.GetCellValue(Row, "name"));

		    doAction2('Search');
		}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}

	// 팝업 클릭시
	function sheet1_OnPopupClick(Row, Col){
		try{
			if(sheet1.ColSaveName(Col) == "name") {

				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "employeePopup";

				<%--var args = new Array();--%>
				<%--args["searchEnterCd"] = sheet1.GetCellValue(Row, "wEnterCd");--%>
				<%--openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "840","520");--%>

				let layerModal = new window.top.document.LayerModal({
					id : 'employeeLayer'
					, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
					, parameters : { searchEnterCd : sheet1.GetCellValue(Row, "wEnterCd")}
					, width : 840
					, height : 520
					, title : '사원조회'
					, trigger :[
						{
							name : 'employeeTrigger'
							, callback : function(rv){
								getReturnValue(rv);
							}
						}
					]
				});
				layerModal.show();
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function sheet1_OnChange(Row, Col) {
		try{
			if(sheet1.ColSaveName(Col) == "wEnterCd") {
				sheet1.SetCellValue(Row, "sabun","");
				sheet1.SetCellValue(Row, "name","");
				sheet1.SetCellValue(Row, "orgCd","");
				sheet1.SetCellValue(Row, "orgNm","");
				sheet1.SetCellValue(Row, "jikweeCd","");
				sheet1.SetCellValue(Row, "jikweeNm","");
				sheet1.SetCellValue(Row, "jikchakCd","");
				sheet1.SetCellValue(Row, "jikchakNm","");
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function getReturnValue(rv) {
		//var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "wEnterCd",	rv["enterCd"] );
			sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
			sheet1.SetCellValue(gPRow, "name",		rv["name"] );
			sheet1.SetCellValue(gPRow, "alias",		rv["alias"] );
			sheet1.SetCellValue(gPRow, "orgCd",		rv["orgCd"] );
			sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
			sheet1.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"] );
			sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
			sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"] );
			sheet1.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"] );
			sheet1.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"] );
			sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"] );

	    }else if(pGubun == "employeePopup2"){
			sheet2.SetCellValue(gPRow, "appEnterCd",rv["enterCd"] );
			sheet2.SetCellValue(gPRow, "appSabun",	rv["sabun"] );
			sheet2.SetCellValue(gPRow, "appName",	rv["name"] );
			sheet2.SetCellValue(gPRow, "appAlias",	rv["alias"] );
			sheet2.SetCellValue(gPRow, "orgCd",		rv["orgCd"] );
			sheet2.SetCellValue(gPRow, "orgNm",		rv["orgNm"] );
			sheet2.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"] );
			sheet2.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"] );
			sheet2.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"] );
			sheet2.SetCellValue(gPRow, "jikchakNm",	rv["jikchakNm"] );
			sheet2.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"] );
			sheet2.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"] );
	    }
	}
</script>

<!-- sheet2 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction2(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet2.DoSearch( "${ctx}/CompAppPeopleMng.do?cmd=getCompAppPeopleMngList2", $("#srchFrm2").serialize() );
				break;

			case "Save":		//저장
				if(sheet2.FindStatusRow("I") != ""){
					if(!dupChk(sheet2,"wEnterCd|sabun|compAppraisalCd|appEnterCd|appSabun", true, true)){break;}
				}

				IBS_SaveName(document.srchFrm2,sheet2);
				sheet2.DoSave( "${ctx}/CompAppPeopleMng.do?cmd=saveCompAppPeopleMng2", $("#srchFrm2").serialize() );
				break;

			case "Insert":		//입력
				if ($("#searchCompAppraisalCd2").val() == "") {
					alert("대상자가 존재하지 않습니다. \n대상자를 선택 또는 입력하시기 바랍니다.");
					return;
				}

				var Row = sheet2.DataInsert(0);
				sheet2.SetCellValue(Row, "compAppraisalCd", $("#searchCompAppraisalCd2").val());
				sheet2.SetCellValue(Row, "wEnterCd", $("#searchWEnterCd2").val());
				sheet2.SetCellValue(Row, "sabun", $("#searchSabun2").val());
				sheet2.SetCellValue(Row, "name", $("#searchName2").val());
				sheet2.SetCellValue(Row, "ldsAppStatusCd", "N");

				break;

			case "Copy":		//행복사
				var Row = sheet2.DataCopy();
				break;

			case "Clear":		//Clear
				sheet2.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet2.Down2Excel({DownCols:makeHiddenSkipCol(sheet2),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet2.LoadExcel(params);
				break;
		}
	}

//<!-- 조회 후 에러 메시지 -->
	function sheet2_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

//<!-- 저장 후 에러 메시지 -->
	function sheet2_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

//<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift){
		try{
			// Insert KEY
			if(Shift == 1 && KeyCode == 45){
				doAction2("Insert");
			}

			//Delete KEY
			if(Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row,"sStatus") == "I"){
				sheet2.SetCellValue(Row,"sStatus","D");
			}
		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}

	// 팝업 클릭시
	function sheet2_OnPopupClick(Row, Col){
		try{
			if(sheet2.ColSaveName(Col) == "appName") {
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "employeePopup2";

				<%--var args = new Array();--%>
				<%--args["searchEnterCdView"] = "Y";--%>
				<%--openPopup("${ctx}/Popup.do?cmd=employeePopup", args, "840","520");--%>

				let layerModal = new window.top.document.LayerModal({
					id : 'employeeLayer'
					, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
					, parameters : { searchEnterCdView : "Y"}
					, width : 840
					, height : 520
					, title : '사원조회'
					, trigger :[
						{
							name : 'employeeTrigger'
							, callback : function(rv){
								getReturnValue(rv);
							}
						}
					]
				});
				layerModal.show();

			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
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
							<span>평가명</span>
							<SELECT id="searchCompAppraisalCd" name="searchCompAppraisalCd" class="box"></SELECT>
						</td>
						<td>
							<span>대상자(피평가자)</span>
							<input type="radio" id="searchConditionType1" name="searchConditionType" value="NAME" class="radio" checked/> <label for="searchConditionType1">성명</label>
							<input type="radio" id="searchConditionType2" name="searchConditionType" value="SABUN" class="radio" /> <label for="searchConditionType2">사번</label>
							<input type="text" id="searchCondition" name="searchCondition" class="text" />
						</td>
						<td>
							<span><tit:txt mid='112194' mdef='평가포함여부'/></span>
							<SELECT id="searchAppYn" name="searchAppYn" class="box">
								<option value="" selected>전체</option>
								<option value="Y" >Y</option>
								<option value="N" >N</option>
							</SELECT>
						</td>
						<td>
							<span><tit:txt mid='cpnProcessBarPop' mdef='진행상태'/></span>
							<SELECT id="searchAppStatus" name="searchAppStatus" class="box">
								<option value="" selected>전체</option>
								<option value="Y" >완료</option>
								<option value="N" >미완료</option>
							</SELECT>
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
							<li id="txt" class="txt">대상자(피평가자)</li>
							<li class="btn">
								<a href="javascript:create()" class="button authA"><tit:txt mid='112692' mdef='대상자생성'/></a>
								<a href="javascript:doAction1('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction1('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>

	<form id="srchFrm2" name="srchFrm2" >
		<input type="hidden" id="searchCompAppraisalCd2" name="searchCompAppraisalCd" value="" />
		<input type="hidden" id="searchSabun2" name="searchSabun" value="" />
		<input type="hidden" id="searchWEnterCd2" name="searchWEnterCd" value="" />
		<input type="hidden" id="searchName2" name="searchName2" value="" />
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='compAppPeopleMng2' mdef='평가자'/></li>
							<li class="btn">
								<a href="javascript:doAction2('Search')" class="button"><tit:txt mid='104081' mdef='조회'/></a>
								<a href="javascript:doAction2('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction2('Copy')" 	class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction2('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction2('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
