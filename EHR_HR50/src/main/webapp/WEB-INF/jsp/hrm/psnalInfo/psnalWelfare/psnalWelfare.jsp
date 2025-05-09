<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head> <title><tit:txt mid='104044' mdef='인사기본(병역/보훈/장애)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var fTestCdList;

	$(function() {
		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm121"] = sheet1;
		EMP_INFO_CHANGE_TABLE_SHEET["thrm122"] = sheet2;
		EMP_INFO_CHANGE_TABLE_SHEET["thrm120"] = sheet3;
		EMP_INFO_CHANGE_TABLE_SHEET["thrm132"] = sheet4;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
   			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='transferCd' mdef='병역구분'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"transferCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='transferNm' mdef='병역구분명'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"transferNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyCd' mdef='군별'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyNm' mdef='군별명'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyGradeCd' mdef='계급'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyGradeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyGradeNm' mdef='계급명'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyGradeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyNo' mdef='군번'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyDCd' mdef='병과'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyDCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyDisCd' mdef='전역사유'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dischargeCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyDisCd' mdef='전역사유'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"dischargeCdNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='rotcYn' mdef='ROTC 여부'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"rotcYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyDNm' mdef='병과명'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyDNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armySYmd' mdef='복무시작일'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armySYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyEYmd' mdef='복무종료일'/>",	Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"armyEYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyYear' mdef='복무기간년'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"armyYear",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyMonth' mdef='복무기간월'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"armyMonth",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"armyMemo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
  			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
 			{Header:"<sht:txt mid='bohunCd' mdef='보훈구분'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bohunCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='bohunNm' mdef='보훈구분명'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bohunNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='famCdV1' mdef='보훈관계'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='famNmV1' mdef='보훈관계명'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"famNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='bohunNo' mdef='보훈번호'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bohunNo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

 			{Header:"<sht:txt mid='bohunNo' mdef='보훈번호'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"bohunPNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='bohunNo' mdef='보훈번호'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empOrderNo",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

 			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
 			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		var initdata3 = {};
		initdata3.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata3.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata3.Cols = [
  			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
 			{Header:"<sht:txt mid='handicapNm' mdef='장애유형'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"장애유형명",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='jangYmd' mdef='장애인정일'/>",	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='jangGradeCd' mdef='장애등급'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangGradeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='jangGradeNm' mdef='장애등급명'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangGradeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='jangNo' mdef='장애번호'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangNo",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
 			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"jangMemo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

 			{Header:"장애인정구분코드",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangType",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
 			{Header:"장애인정구분코드명",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"장애인정기관",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jangOrgNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300 }
		]; IBS_InitSheet(sheet3, initdata3);sheet3.SetEditable("${editable}");sheet3.SetVisible(true);sheet3.SetCountPosition(4);

		var initdata4 = {};
		initdata4.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata4.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata4.Cols = [
  			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
 			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
 			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",	Hidden:0,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
 			{Header:"<sht:txt mid='targetYn' mdef='병특대상여부'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"targetYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='armyEduYn' mdef='군사교육수료여부'/>",	Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyEduYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='sdateV5' mdef='특례편입일'/>",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='edateV4' mdef='특례만료일'/>",		Type:"Date",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"군사교육_시작일",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"armyEduSymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"군사교육_만료일",		Type:"Date",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyEduEymd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='armyEduYear' mdef='군사교육기간년'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyEduYear",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='armyEduMonth' mdef='군사교육기간월'/>",	Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyEduMonth",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
 			{Header:"<sht:txt mid='armyEduNm' mdef='훈련부대명'/>",		Type:"Text",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"armyEduNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet4, initdata4);sheet4.SetEditable("${editable}");sheet4.SetVisible(true);sheet4.SetCountPosition(4);

		$("#hdnSabun").val($("#searchUserId",parent.document).val());
		$("#hdnEnterCd").val($("#searchUserEnterCd",parent.document).val());
		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			$(".enterAuthBtn").hide();
			$("#wrapper ,input,select,textarea").each(function(idx, obj) {
				$(obj).attr("readonly", true);
				$(obj).addClass("readonly");
			});
		}
 		var enterCd = "&enterCd="+$("#hdnEnterCd").val();

		//공통코드 한번에 조회
		var grpCds = "H20200,H20230,H20220,H20310,H20120,H20320,H20330,H20210,H20240,H20336";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists&useYn=Y&visualYn=Y","grpCd="+grpCds + enterCd,false).codeList, " ");

		var userCd1 = codeLists["H20200"];
		var userCd2 = codeLists["H20230"];
		var userCd3 = codeLists["H20220"];
		var userCd4 = codeLists["H20310"];
		var userCd5 = codeLists["H20120"];
		var userCd6 = codeLists["H20320"];
		var userCd7 = codeLists["H20330"];
		var userCd8 = codeLists["H20210"];
		var userCd9 = codeLists["H20240"];
		var userCd10= codeLists["H20336"];

		if($("#hdnAuthPg").val() == 'A') {
			$("#transferCd").html(userCd1[2]);
			$("#armyCd").html(userCd2[2]);
			$("#armyGradeCd").html(userCd3[2]);
			$("#armyDCd").html(userCd8[2]);
			$("#bohunCd").html(userCd4[2]);
			$("#famCd").html(userCd5[2]);
			$("#jangCd").html(userCd6[2]);
			$("#jangGradeCd").html(userCd7[2]);

			$("#dischargeCd").html(userCd9[2]);

			$("#jangType").html(userCd10[2]);
		}

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		doAction2("Search");
		doAction3("Search");
		doAction4("Search");

	});

	$(function() {

		if($("#hdnAuthPg").val() == 'A') {
			$( "#armySYmd,#armyEYmd,#jangYmd,#sdate,#edate,#armyEduSymd,#armyEduEymd" ).datepicker2();

			$("#transferCd").bind("change",function(){
				$("#transferNm").val($(this).find(":selected").text());
			});
			$("#armyCd").bind("change",function(){
				$("#armyNm").val($(this).find(":selected").text());
			});
			$("#armyGradeCd").bind("change",function(){
				$("#armyGradeNm").val($(this).find(":selected").text());
			});
			$("#armyDCd").bind("change",function(){
				$("#armyDNm").val($(this).find(":selected").text());
			});
			$("#bohunCd").bind("change",function(){
				$("#bohunNm").val($(this).find(":selected").text());
			});
			$("#famCd").bind("change",function(){
				$("#famNm").val($(this).find(":selected").text());
			});
			$("#jangCd").bind("change",function(){
				$("#jangNm").val($(this).find(":selected").text());
			});
			$("#jangGradeCd").bind("change",function(){
				$("#jangGradeNm").val($(this).find(":selected").text());
			});
			$("#jangType").bind("change",function(){
				$("#jangTypeNm").val($(this).find(":selected").text());
			});
			$("#targetYn").bind("change",function(){
				$("#targetYnNm").val($(this).find(":selected").text());
			});
			$("#armyEduYn").bind("change",function(){
				$("#armyEduYnNm").val($(this).find(":selected").text());
			});
			$("#dischargeCd").bind("change",function(){
				$("#dischargeNm").val($(this).find(":selected").text());
			});
			$("#rotcYn").bind("change",function(){
				$("#rotcNm").val($(this).find(":selected").text());
			});
		}
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			sheet1.DoSearch( "${ctx}/PsnalWelfare.do?cmd=getPsnalWelfareArmyList", param );
			break;
		case "Save":
			/*
			if( $("#transferCd").val() == "" ) {
				alert("<msg:txt mid='errorTransferCd' mdef='병역구분은 필수 입력 사항입니다.'/>");
				return;
			}
			*/
			if(sheet1.RowCount() == 0) {
				var row = sheet1.DataInsert(0);
				sheet1.SetCellValue(row,"sabun",$("#hdnSabun").val());
			}
			if(setSheetValue(sheet1,1)) {
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/PsnalWelfare.do?cmd=savePsnalWelfareArmy", $("#sheet1Form").serialize());
			}
			break;
		case "Delete":
			if(sheet1.RowCount() == 0) {
				alert("<msg:txt mid='errorDeleteZero' mdef='삭제할 내역이 없습니다.'/>");
				return;
			}else {
				sheet1.SetCellValue(1,"sStatus","D");
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/PsnalWelfare.do?cmd=savePsnalWelfareArmy", $("#sheet1Form").serialize());
			}
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			sheet2.DoSearch( "${ctx}/PsnalWelfare.do?cmd=getPsnalWelfareBohunList", param );
			break;
		case "Save":
			/*
			if( $("#bohunNo").val() == "" ) {
				alert("<msg:txt mid='errorBohunNo' mdef='보훈번호는 필수 입력 사항입니다.'/>");
				return;
			}
			*/
			if(sheet2.RowCount() == 0) {
				var row = sheet2.DataInsert(0);
				sheet2.SetCellValue(row,"sabun",$("#hdnSabun").val());
			}

			if(setSheetValue(sheet2,2)) {
				IBS_SaveName(document.sheet1Form,sheet2);
				sheet2.DoSave( "${ctx}/PsnalWelfare.do?cmd=savePsnalWelfareBohun", $("#sheet1Form").serialize());
			}
			break;
		case "Delete":
			if(sheet2.RowCount() == 0) {
				alert("<msg:txt mid='errorDeleteZero' mdef='삭제할 내역이 없습니다.'/>");
				return;
			}else {
				sheet2.SetCellValue(1,"sStatus","D");
				IBS_SaveName(document.sheet1Form,sheet2);
				sheet2.DoSave( "${ctx}/PsnalWelfare.do?cmd=savePsnalWelfareBohun", $("#sheet1Form").serialize());
			}
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet2);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param);
			break;
		}
	}

	//Sheet3 Action
	function doAction3(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			sheet3.DoSearch( "${ctx}/PsnalWelfare.do?cmd=getPsnalWelfareJangList", param );
			break;
		case "Save":
			/*
			if( $("#jangNo").val() == "" ) {
				alert("<msg:txt mid='errorJangNo' mdef='장애번호는 필수 입력 사항입니다.'/>");
				return;
			}
			*/
			if(sheet3.RowCount() == 0) {
				var row = sheet3.DataInsert(0);
				sheet3.SetCellValue(row,"sabun",$("#hdnSabun").val());
			}
			if(setSheetValue(sheet3,3)) {
				IBS_SaveName(document.sheet1Form,sheet3);
				sheet3.DoSave( "${ctx}/PsnalWelfare.do?cmd=savePsnalWelfareJang", $("#sheet1Form").serialize());
			}
			break;
		case "Delete":
			if(sheet3.RowCount() == 0) {
				alert("<msg:txt mid='errorDeleteZero' mdef='삭제할 내역이 없습니다.'/>");
				return;
			}else {
				sheet3.SetCellValue(1,"sStatus","D");
				IBS_SaveName(document.sheet1Form,sheet3);
				sheet3.DoSave( "${ctx}/PsnalWelfare.do?cmd=savePsnalWelfareJang", $("#sheet1Form").serialize());
			}
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet3);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet3.Down2Excel(param);
			break;
		}
	}

	//Sheet4 Action
	function doAction4(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			sheet4.DoSearch( "${ctx}/PsnalWelfare.do?cmd=getPsnalWelfareArmyEduList", param );
			break;
		case "Save":
			if(sheet4.RowCount() == 0) {
				var row = sheet4.DataInsert(0);
				sheet4.SetCellValue(row,"sabun",$("#hdnSabun").val());
			}
			if(setSheetValue(sheet4,4)){
				IBS_SaveName(document.sheet1Form,sheet4);
				sheet4.DoSave( "${ctx}/PsnalWelfare.do?cmd=savePsnalWelfareArmyEdu", $("#sheet1Form").serialize());
			}
			break;
		case "Delete":
			if(sheet4.RowCount() == 0) {
				alert("<msg:txt mid='errorDeleteZero' mdef='삭제할 내역이 없습니다.'/>");
				return;
			}else {
				sheet4.SetCellValue(1,"sStatus","D");
				IBS_SaveName(document.sheet1Form,sheet4);
				sheet4.DoSave( "${ctx}/PsnalWelfare.do?cmd=savePsnalWelfareArmyEdu", $("#sheet1Form").serialize());
			}
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet4);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet4.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			getSheetValue(sheet1,1);
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			getSheetValue(sheet2,2);
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet3_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			getSheetValue(sheet3,3);
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet3_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction3("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet4_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			getSheetValue(sheet4,4);
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet4_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction4("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function getSheetValue(sht,shtNum) {

		var row = sht.LastRow();

		if(row == 0) {
			if(shtNum == 1) {

				$("#transferCd").val("");
				$("#transferNm").val("");
				$("#armyCd").val("");
				$("#armyNm").val("");
				$("#armyGradeCd").val("");
				$("#armyGradeNm").val("");
				$("#armyNo").val("");
				$("#armyDCd").val("");
				$("#armyDNm").val("");
				$('#armySYmd').val("");
				$('#armyEYmd').val("");
				$("#armyMemo").val("");

				$("#armyYearMonth").text("");

				$("#dischargeCd").val("");
				$("#rotcYn").val("");

			} else if(shtNum==2) {

				$("#bohunCd").val("");
				$("#bohunNm").val("");
				$("#famCd").val("");
				$("#famNm").val("");
				$("#bohunNo").val("");
				$("#note").val("");

				$("#bohunPNm").val("");
				$("#empOrderNo").val("");

				$("#filebtn1").text("첨부");
				$("#fileSeq1").val("");

				var authPgTemp="${authPg}";
				if(authPgTemp != 'A'){
					$("#filebtn1").hide();
				}

			} else if(shtNum==3) {

				$("#jangCd").val("");
				$("#jangNm").val("");
				$('#jangYmd').val("");
				$("#jangGradeCd").val("");
				$("#jangGradeNm").val("");
				$("#jangNo").val("");
				$("#jangMemo").val("");

				$("#jangType").val("");
				$("#jangTypeNm").val("");
				$("#jangOrgNm").val("");

				$("#filebtn2").text("첨부");
				$("#fileSeq2").val("");


				var authPgTemp="${authPg}";
				if(authPgTemp != 'A'){
					$("#filebtn2").hide();
				}

			} else if(shtNum==4) {


				$("#targetYn").val("");
				$("#targetYnNm").val("");
				$("#armyEduYn").val("");
				$("#armyEduYnNm").val("");
				$('#sdate').val("");
				$('#edate').val("");
				$('#armyEduSymd').val("");
				$('#armyEduEymd').val("");
				$("#armyEduNm").val("");

				$("#armyEduYearMonth").text("");

			}

			return false;
		}

		if(shtNum == 1) {

			$("#transferCd").val(sht.GetCellValue(row,"transferCd"));
			$("#transferNm").val(sht.GetCellValue(row,"transferNm"));
			$("#armyCd").val(sht.GetCellValue(row,"armyCd"));
			$("#armyNm").val(sht.GetCellValue(row,"armyNm"));
			$("#armyGradeCd").val(sht.GetCellValue(row,"armyGradeCd"));
			$("#armyGradeNm").val(sht.GetCellValue(row,"armyGradeNm"));
			$("#armyNo").val(sht.GetCellValue(row,"armyNo"));
			$("#armyDCd").val(sht.GetCellValue(row,"armyDCd"));
			$("#armyDNm").val(sht.GetCellValue(row,"armyDNm"));
			$('#armySYmd').val(sht.GetCellText(row,"armySYmd"));
			$('#armyEYmd').val(sht.GetCellText(row,"armyEYmd"));
			$("#armyMemo").val(sht.GetCellValue(row,"armyMemo"));

			//병역구분이 면제인 경우 required 클래스 제거
			if($("#transferCd").find(":selected").val() == '7'){
				$('#armyCd').removeClass('required');
				$('#armyGradeCd').removeClass('required');
			}
			var armyYearMonth = "";
			if(sht.GetCellValue(row,"armyYear") != "") {
				armyYearMonth += sht.GetCellValue(row,"armyYear")+"년 ";
			}

			if(sht.GetCellValue(row,"armyMonth") != "") {
				armyYearMonth += sht.GetCellValue(row,"armyMonth")+"개월 ";
			}

			$("#armyYearMonth").text(armyYearMonth);
			$("#dischargeCd").val(sht.GetCellValue(row,"dischargeCd"));
			$("#dischargeCdNm").val(sht.GetCellValue(row,"dischargeCdNm"));
			$("#rotcYn").val(sht.GetCellValue(row,"rotcYn"));


			if ($("#transferCd").val() == ""){
				$("#transferCd").append("<option value='"+sht.GetCellValue(row,"transferCd")+"'>"+sht.GetCellValue(row,"transferNm")+"</option");
				$("#transferCd").val(sht.GetCellValue(row,"transferCd"));
			}
			if ($("#armyCd").val() == ""){
				$("#armyCd").append("<option value='"+sht.GetCellValue(row,"armyCd")+"'>"+sht.GetCellValue(row,"armyNm")+"</option");
				$("#armyCd").val(sht.GetCellValue(row,"armyCd"));
			}
			if ($("#armyGradeCd").val() == ""){
				$("#armyGradeCd").append("<option value='"+sht.GetCellValue(row,"armyGradeCd")+"'>"+sht.GetCellValue(row,"armyGradeNm")+"</option");
				$("#armyGradeCd").val(sht.GetCellValue(row,"armyGradeCd"));
			}
			if ($("#armyDCd").val() == ""){
				$("#armyDCd").append("<option value='"+sht.GetCellValue(row,"armyDCd")+"'>"+sht.GetCellValue(row,"armyDNm")+"</option");
				$("#armyDCd").val(sht.GetCellValue(row,"armyDCd"));
			}
			if ($("#dischargeCd").val() == ""){
				$("#dischargeCd").append("<option value='"+sht.GetCellValue(row,"dischargeCd")+"'>"+sht.GetCellValue(row,"dischargeCdNm")+"</option");
				$("#dischargeCd").val(sht.GetCellValue(row,"dischargeCd"));
			}

		} else if(shtNum==2) {

			$("#bohunCd").val(sht.GetCellValue(row,"bohunCd"));
			$("#bohunNm").val(sht.GetCellValue(row,"bohunNm"));
			$("#famCd").val(sht.GetCellValue(row,"famCd"));
			$("#famNm").val(sht.GetCellValue(row,"famNm"));
			$("#bohunNo").val(sht.GetCellValue(row,"bohunNo"));
			$("#note").val(sht.GetCellValue(row,"note"));

			$("#bohunPNm").val(sht.GetCellValue(row,"bohunPNm"));
			$("#empOrderNo").val(sht.GetCellValue(row,"empOrderNo"));

			if ($("#bohunCd").val() == ""){
				$("#bohunCd").append("<option value='"+sht.GetCellValue(row,"bohunCd")+"'>"+sht.GetCellValue(row,"bohunNm")+"</option");
				$("#bohunCd").val(sht.GetCellValue(row,"bohunCd"));
			}
			if ($("#famCd").val() == ""){
				$("#famCd").append("<option value='"+sht.GetCellValue(row,"famCd")+"'>"+sht.GetCellValue(row,"famNm")+"</option");
				$("#famCd").val(sht.GetCellValue(row,"famCd"));
			}

			if(sht.GetCellValue(row,"fileSeq") != ""){
				$("#filebtn1").text("다운로드");
				$("#fileSeq1").val(sht.GetCellValue(row,"fileSeq"));
			}else{
				$("#filebtn1").text("첨부");
				$("#fileSeq1").val("");
			}

			var authPgTemp="${authPg}";
			if(authPgTemp != 'A'){
				if(sht.GetCellValue(row,"fileSeq") == ""){
					$("#filebtn1").hide();
				}
			}


		} else if(shtNum==3) {

			$("#jangCd").val(sht.GetCellValue(row,"jangCd"));
			$("#jangNm").val(sht.GetCellValue(row,"jangNm"));
			$('#jangYmd').val(sht.GetCellText(row,"jangYmd"));
			$("#jangGradeCd").val(sht.GetCellValue(row,"jangGradeCd"));
			$("#jangGradeNm").val(sht.GetCellValue(row,"jangGradeNm"));
			$("#jangNo").val(sht.GetCellValue(row,"jangNo"));
			$("#jangMemo").val(sht.GetCellValue(row,"jangMemo"));
			if(sht.GetCellValue(row,"fileSeq") != ""){
				$("#filebtn2").text("다운로드");
				$("#fileSeq2").val(sht.GetCellValue(row,"fileSeq"));
			}else{
				$("#filebtn2").text("첨부");
				$("#fileSeq2").val("");
			}

			if ($("#jangCd").val() == ""){
				$("#jangCd").append("<option value='"+sht.GetCellValue(row,"jangCd")+"'>"+sht.GetCellValue(row,"jangNm")+"</option");
				$("#jangCd").val(sht.GetCellValue(row,"jangCd"));
			}
			if ($("#jangGradeCd").val() == ""){
				$("#jangGradeCd").append("<option value='"+sht.GetCellValue(row,"jangGradeCd")+"'>"+sht.GetCellValue(row,"jangGradeNm")+"</option");
				$("#jangGradeCd").val(sht.GetCellValue(row,"jangGradeCd"));
			}

			if ($("#jangType").val() == ""){
				$("#jangType").append("<option value='"+sht.GetCellValue(row,"jangType")+"'>"+sht.GetCellValue(row,"jangTypeNm")+"</option");
				$("#jangType").val(sht.GetCellValue(row,"jangType"));
			}
			
			$("#jangTypeNm").val(sht.GetCellValue(row,"jangTypeNm"));
			
			$("#jangOrgNm").val(sht.GetCellValue(row,"jangOrgNm"));

			var authPgTemp="${authPg}";
			if(authPgTemp != 'A'){
				if(sht.GetCellValue(row,"fileSeq") == ""){
					$("#filebtn2").hide();
				}
			}

		} else if(shtNum==4) {


			$("#targetYn").val(sht.GetCellValue(row,"targetYn"));
			$("#targetYnNm").val( sht.GetCellValue(row,"targetYn")==""? "" : (sht.GetCellValue(row,"targetYn")=="Y"?"대상":"비대상"));
			$("#armyEduYn").val(sht.GetCellValue(row,"armyEduYn"));
			$("#armyEduYnNm").val( sht.GetCellValue(row,"armyEduYn")==""? "" : (sht.GetCellValue(row,"armyEduYn")=="Y"?"수료":"미수료"));
			$('#sdate').val(sht.GetCellText(row,"sdate"));
			$('#edate').val(sht.GetCellText(row,"edate"));
			$('#armyEduSymd').val(sht.GetCellText(row,"armyEduSymd"));
			$('#armyEduEymd').val(sht.GetCellText(row,"armyEduEymd"));
			$("#armyEduNm").val(sht.GetCellValue(row,"armyEduNm"));

			var armyEduYearMonth = "";
			if(sht.GetCellValue(row,"armyEduYear") != "") {
				armyEduYearMonth += sht.GetCellValue(row,"armyEduYear")+"년 ";
			}

			if(sht.GetCellValue(row,"armyEduMonth") != "") {
				armyEduYearMonth += sht.GetCellValue(row,"armyEduMonth")+"개월 ";
			}

			$("#armyEduYearMonth").text(armyEduYearMonth);
		}

		return true;
	}

	function setSheetValue(sht,shtNum) {

		var row = sht.LastRow();

		if(row == 0) {
			return false;
		}

		if(shtNum == 1) {

			if($("#armySYmd").val() != "" && $("#armyEYmd").val() != "") {
				if(formatDate($("#armySYmd").val(),"") > formatDate($("#armyEYmd").val(),"")) {
					alert("<msg:txt mid='errorArmySYmd' mdef='복무종료일은 복무시작일 이후로 입력하여 주십시오.'/>");
					$("#armyEYmd").focus();
					return false;
				}
			}

			if($('#transferCd').val() == "") {
				alert("병역구분을 입력하여 주십시오.");
				$('#transferCd').focus();
				return;
			}

			//병역구분이 면제인 경우 필수값에 군별 제외
			if($('#transferCd').val() != "7" && $('#armyCd').val() == "") {
				alert("군별을 입력하여 주십시오.");
				$('#armyCd').focus();
				return;
			}

			//병역구분이 면제인 경우 필수값에 계급 제외
			if($('#transferCd').val() != "7" && $('#armyGradeCd').val() == "") {
				alert("계급을 입력하여 주십시오.");
				$('#armyGradeCd').focus();
				return;
			}

			sht.SetCellValue(row,"transferCd",$("#transferCd").val());
			sht.SetCellValue(row,"transferNm",$("#transferNm").val());
			sht.SetCellValue(row,"armyCd",$("#armyCd").val());
			sht.SetCellValue(row,"armyNm",$("#armyNm").val());
			sht.SetCellValue(row,"armyGradeCd",$("#armyGradeCd").val());
			sht.SetCellValue(row,"armyGradeNm",$("#armyGradeNm").val());
			sht.SetCellValue(row,"armyNo",$("#armyNo").val());
			sht.SetCellValue(row,"armyDCd",$("#armyDCd").val());
			sht.SetCellValue(row,"armyDNm",$("#armyDNm").val());
			sht.SetCellValue(row,"armySYmd",formatDate($('#armySYmd').val(),""));
			sht.SetCellValue(row,"armyEYmd",formatDate($('#armyEYmd').val(),""));
			sht.SetCellValue(row,"armyMemo",$("#armyMemo").val());

			sht.SetCellValue(row,"dischargeCd",$("#dischargeCd").val());
			sht.SetCellValue(row,"rotcYn",$("#rotcYn").val());

		} else if(shtNum==2) {

			if($('#bohunCd').val() == "") {
				alert("보훈구분을 입력하여 주십시오.");
				$('#bohunCd').focus();
				return;
			}

			sht.SetCellValue(row,"bohunCd",$("#bohunCd").val());
			sht.SetCellValue(row,"bohunNm",$("#bohunNm").val());
			sht.SetCellValue(row,"famCd",$("#famCd").val());
			sht.SetCellValue(row,"famNm",$("#famNm").val());
			sht.SetCellValue(row,"bohunNo",$("#bohunNo").val());
			sht.SetCellValue(row,"note",$("#note").val());

			sht.SetCellValue(row,"fileSeq",$("#fileSeq1").val());

			sht.SetCellValue(row,"bohunPNm",$("#bohunPNm").val());
			sht.SetCellValue(row,"empOrderNo",$("#empOrderNo").val());

		} else if(shtNum==3) {

			if($('#jangCd').val() == "") {
				alert("장애유형을 입력하여 주십시오.");
				$('#jangCd').focus();
				return;
			}

			if($('#jangGradeCd').val() == "") {
				alert("장애등급을 입력하여 주십시오.");
				$('#jangGradeCd').focus();
				return;
			}

			sht.SetCellValue(row,"jangCd",$("#jangCd").val());
			sht.SetCellValue(row,"jangNm",$("#jangNm").val());
			sht.SetCellValue(row,"jangYmd",formatDate($('#jangYmd').val(),""));
			sht.SetCellValue(row,"jangGradeCd",$("#jangGradeCd").val());
			sht.SetCellValue(row,"jangGradeNm",$("#jangGradeNm").val());
			sht.SetCellValue(row,"jangNo",$("#jangNo").val());
			sht.SetCellValue(row,"jangMemo",$("#jangMemo").val());

			sht.SetCellValue(row,"fileSeq",$("#fileSeq2").val());

			sht.SetCellValue(row,"jangType",$("#jangType").val());
			sht.SetCellValue(row,"jangTypeNm",$("#jangTypeNm").val());
			sht.SetCellValue(row,"jangOrgNm",$("#jangOrgNm").val());

		} else if(shtNum==4) {

			if($("#sdate").val() != "" && $("#edate").val() != "") {
				if(formatDate($("#sdate").val(),"") > formatDate($("#edate").val(),"")) {
					alert("<msg:txt mid='sdate1' mdef='특례만료일은 특례편입일 이후로 입력하여 주십시오.'/>");
					$("#edate").focus();
					return false;
				}
			}

			if($("#armyEduSymd").val() != "" && $("#armyEduEymd").val() != "") {
				if(formatDate($("#armyEduSymd").val(),"") > formatDate($("#armyEduEymd").val(),"")) {
					alert("군사교육 종료일은 군사교육 시작일 이후로 입력하여 주십시오.");
					$("#armyEduEymd").focus();
					return false;
				}
			}

			sht.SetCellValue(row,"targetYn",$("#targetYn").val());
			sht.SetCellValue(row,"armyEduYn",$("#armyEduYn").val());
			sht.SetCellValue(row,"sdate",formatDate($('#sdate').val(),""));
			sht.SetCellValue(row,"edate",formatDate($('#edate').val(),""));
			sht.SetCellValue(row,"armyEduSymd",formatDate($('#armyEduSymd').val(),""));
			sht.SetCellValue(row,"armyEduEymd",formatDate($('#armyEduEymd').val(),""));
			sht.SetCellValue(row,"armyEduNm",$("#armyEduNm").val());
		}

		return true;
	}

	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "") {
			return strDate;
		}

		if(strDate.length == 10) {
			return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
		} else if(strDate.length == 8) {
			return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
		}
	}

	function attachFile(seq){
		if(!isPopup()) {return;}

		gPRow = seq;

		let args = {"fileSeq": $("#fileSeq"+seq).val()};
		let authPgTemp="${authPg}";
		let layerModal = new window.top.document.LayerModal({
			id : 'fileMgrLayer'
			, url : '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&authPg='+authPgTemp
			, parameters : args
			, width : 740
			, height : 420
			, title : '파일 업로드'
			, trigger :[
				{
					name : 'fileMgrTrigger'
					, callback : function(result){
						getReturnValue(result);
					}
				}
			]
		});
		layerModal.show();
	}

	//팝업 콜백 함수.
	function getReturnValue(rv) {
		if(rv["fileCheck"] == "exist"){
			$("#filebtn"+gPRow+" > a").text("다운로드");
			$("#fileSeq"+gPRow).val(rv["fileSeq"]);
		}else{
			$("#filebtn"+gPRow+" > a").text("첨부");
			$("#fileSeq"+gPRow).val("");
		}
	}

</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body>
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">
	<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
	<input id="hdnSabun" name="hdnSabun" type="hidden">
	<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">

	<input id="fileSeq1" name="fileSeq1" type="hidden" value="">
	<input id="fileSeq2" name="fileSeq2" type="hidden" value="">

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="50%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='104545' mdef='병역사항'/></li>
				<li class="btn _thrm121">
					<btn:a href="javascript:doAction1('Search');" css="btn dark thinner authR" mid='110697' mdef="조회"/>
				<c:if test="${authPg == 'A'}">
					<btn:a href="javascript:doAction1('Save');" css="btn filled thinner authA enterAuthBtn" mid='110708' mdef="저장"/>
					<btn:a href="javascript:doAction1('Delete');" css="btn outline_gray thinner authA enterAuthBtn" mid='110763' mdef="삭제"/>
				</c:if>
				</li>
			</ul>
			</div>

			<table border="0" cellpadding="0" cellspacing="0" class="table">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th><tit:txt mid='104239' mdef='병역구분'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="transferCd" name="transferCd" class="required">
					</select>
					<input id="transferNm" name="transferNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="transferCd" name="transferCd" type="hidden" class="${textCss}" ${readonly}>
					<input id="transferNm" name="transferNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
				<th><tit:txt mid='103926' mdef='군별'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="armyCd" name="armyCd" class="required">
					</select>
					<input id="armyNm" name="armyNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="armyCd" name="armyCd" type="hidden" class="${textCss}" ${readonly}>
					<input id="armyNm" name="armyNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104219' mdef='계급'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="armyGradeCd" name="armyGradeCd" class="required">
					</select>
					<input id="armyGradeNm" name="armyGradeNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="armyGradeCd" name="armyGradeCd" type="hidden" class="${textCss}" ${readonly}>
					<input id="armyGradeNm" name="armyGradeNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
				<th><tit:txt mid='104045' mdef='군번'/></th>
				<td>
					<input id="armyNo" name="armyNo" type="text" class="${textCss}" maxlength=30 ${readonly}>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103842' mdef='병과'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="armyDCd" name="armyDCd">
					</select>
					<input id="armyDNm" name="armyDNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="armyDCd" name="armyDCd" type="hidden" class="${textCss}" ${readonly}>
					<input id="armyDNm" name="armyDNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
				<th><tit:txt mid='112193' mdef='전역사유'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="dischargeCd" name="dischargeCd">
					</select>
					<input id="dischargeCdNm" name="dischargeCdNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="dischargeCd" name="dischargeCd" type="hidden" class="${textCss}" ${readonly}>
					<input id="dischargeCdNm" name="dischargeCdNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
			</tr>
			<tr class="hide">
				<th><tit:txt mid='113952' mdef='ROTC 여부'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="rotcYn" name="rotcYn">
						<option value=""></option>
						<option value="Y">Y</option>
						<option value="N">N</option>
					</select>
					<input id="rotcNm" name="rotcNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="rotcYn" name="rotcYn" type="hidden" class="${textCss}" ${readonly}>
					<input id="rotcNm" name="rotcNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104518' mdef='복무기간'/></th>
				<td colspan="3">
					<input id="armySYmd" name="armySYmd" type="text" class="${dateCss}">
					~
					<input id="armyEYmd" name="armyEYmd" type="text" class="${dateCss}">
					( <span id="armyYearMonth" name="armyYearMonth"></span> )
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103783' mdef='비고'/></th>
				<td colspan="3">
					<textarea id="armyMemo" name="armyMemo" rows="3" cols="" class="w100p ${readonly}" ${readonly}></textarea>
				</td>
			</tr>
			</table>
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='milService' mdef='병역특례'/></li>
				<li class="btn _thrm132">
					<btn:a href="javascript:doAction4('Search');" css="btn dark thinner authR" mid='110697' mdef="조회"/>
				<c:if test="${authPg == 'A'}">
					<btn:a href="javascript:doAction4('Save');" css="btn filled thinner authA enterAuthBtn" mid='110708' mdef="저장"/>
					<a href="javascript:doAction4('Delete');" class="btn outline_gray thinner authA enterAuthBtn"><tit:txt mid='113460' mdef='삭제'/></a>
				</c:if>
				</li>
			</ul>
			</div>

			<table border="0" cellpadding="0" cellspacing="0" class="table">
			<colgroup>
				<col width="15%" />
				<col width="35%" />
				<col width="15%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th><tit:txt mid='103845' mdef='병특대상여부'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="targetYn" name="targetYn">
						<option value=""></option>
						<option value="N">비대상</option>
						<option value="Y">대상</option>
					</select>
					<input id="targetYnNm" name="targetYnNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="targetYn" name="targetYn" type="hidden" class="${textCss}" ${readonly}>
					<input id="targetYnNm" name="targetYnNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
				<th><tit:txt mid='104047' mdef='군사교육수료여부'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="armyEduYn" name="armyEduYn">
						<option value=""></option>
						<option value="N">미수료</option>
						<option value="Y">수료</option>
					</select>
					<input id="armyEduYnNm" name="armyEduYnNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="armyEduYn" name="armyEduYn" type="hidden" class="${textCss}" ${readonly}>
					<input id="armyEduYnNm" name="armyEduYnNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103846' mdef='특례편입일'/></th>
				<td>
					<input id="sdate" name="sdate" type="text" class="${dateCss}">
				</td>
				<th><tit:txt mid='104142' mdef='특례만료일'/></th>
				<td>
					<input id="edate" name="edate" type="text" class="${dateCss}">
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104143' mdef='군사교육기간'/></th>
				<td colspan="3">
					<input id="armyEduSymd" name="armySYmd" type="text" class="${dateCss}">
					~
					<input id="armyEduEymd" name="armyEYmd" type="text" class="${dateCss}">

					<span id="armyEduYearMonth" name="armyEduYearMonth" class="hide"></span>

				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104144' mdef='훈련부대명'/></th>
				<td colspan="3">
					<input id="armyEduNm" name="armyEduNm" type="text" class="${textCss} w100p" maxlength="100" ${readonly}>
				</td>
			</tr>
			</table>
		</td>
		<td class="sheet_right">
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='veterans' mdef='보훈사항'/></li>
				<li class="btn _thrm122">
					<btn:a href="javascript:doAction2('Search');" css="btn dark thinner authR" mid='110697' mdef="조회"/>
				<c:if test="${authPg == 'A'}">
					<btn:a href="javascript:doAction2('Save');" css="btn filled thinner authA enterAuthBtn" mid='110708' mdef="저장"/>
					<btn:a href="javascript:doAction2('Delete');" css="btn outline_gray thinner authA enterAuthBtn" mid='110763' mdef="삭제"/>
				</c:if>
					<btn:a href="javascript:attachFile('1');" id="filebtn1" css="btn outline_gray thinner" mid='attachFile' mdef="첨부"/>
				</li>
			</ul>
			</div>

			<table border="0" cellpadding="0" cellspacing="0" class="table">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th><tit:txt mid='103843' mdef='보훈구분'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="bohunCd" name="bohunCd" class="required">
					</select>
					<input id="bohunNm" name="bohunNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="bohunCd" name="bohunCd" type="hidden" class="${textCss}" ${readonly}>
					<input id="bohunNm" name="bohunNm" type="text" class="${textCss} w100p" readonly>
				</c:otherwise>
			</c:choose>
				</td>
				<th><tit:txt mid='104141' mdef='보훈관계'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="famCd" name="famCd">
					</select>
					<input id="famNm" name="famNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="famCd" name="famCd" type="hidden" class="${textCss}" ${readonly}>
					<input id="famNm" name="famNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='104414' mdef='보훈번호'/></th>
				<td colspan="3">
					<input id="bohunNo" name="bohunNo" type="text" class="${textCss}" maxlength="30" ${readonly}>
				</td>
			</tr>
			<tr>
				<th>유공자성명</th>
				<td>
					<input id="bohunPNm" name="bohunPNm" type="text" class="${textCss}" maxlength="100" ${readonly}>
				</td>
				<th>고용명령번호</th>
				<td>
					<input id="empOrderNo" name="empOrderNo" type="text" class="${textCss}" maxlength="100" ${readonly} style="ime-mode:active;" />
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103783' mdef='비고'/></th>
				<td colspan="3">
					<textarea id="note" name="note" rows="4" cols="" class="w100p ${readonly}" ${readonly}></textarea>
				</td>
			</tr>
			</table>

			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='obstacle' mdef='장애사항'/></li>
				<li class="btn _thrm120">
					<btn:a href="javascript:doAction3('Search');" css="btn dark thinner authR" mid='110697' mdef="조회"/>
				<c:if test="${authPg == 'A'}">
					<btn:a href="javascript:doAction3('Save');" css="btn filled thinner authA enterAuthBtn" mid='110708' mdef="저장"/>
					<btn:a href="javascript:doAction3('Delete');" css="btn outline_gray thinner authA enterAuthBtn" mid='110763' mdef="삭제"/>
				</c:if>
					<btn:a href="javascript:attachFile('2');" id="filebtn2" css="btn outline_gray thinner" mid='attachFile' mdef="첨부"/>
				</li>
			</ul>
			</div>

			<table border="0" cellpadding="0" cellspacing="0" class="table">
			<colgroup>
				<col width="20%" />
				<col width="30%" />
				<col width="20%" />
				<col width="*" />
			</colgroup>
			<tr>
				<th><tit:txt mid='103927' mdef='장애유형'/></th>
				<td>
			<c:choose>
				<c:when test="${authPg == 'A'}">
					<select id="jangCd" name="jangCd" class="required">
					</select>
					<input id="jangNm" name="jangNm" type="hidden" ${readonly}>
				</c:when>
				<c:otherwise>
					<input id="jangCd" name="jangCd" type="hidden" class="${textCss}" ${readonly}>
					<input id="jangNm" name="jangNm" type="text" class="${textCss}" readonly>
				</c:otherwise>
			</c:choose>
				</td>
				<th><tit:txt mid='112877' mdef='장애인정일'/></th>
				<td>
					<input id="jangYmd" name="jangYmd" type="text" class="${dateCss}">
				</td>
			</tr>
			<tr>
				<th>장애등급</th>
				<td>
				<c:choose>
					<c:when test="${authPg == 'A'}">
						<select id="jangGradeCd" name="jangGradeCd" class="required">
						</select>
						<input id="jangGradeNm" name="jangGradeNm" type="hidden" ${readonly}>
					</c:when>
					<c:otherwise>
						<input id="jangGradeCd" name="jangGradeCd" type="hidden" class="${textCss}" ${readonly}>
						<input id="jangGradeNm" name="jangGradeNm" type="text" class="${textCss}" readonly>
					</c:otherwise>
				</c:choose>
				</td>
				<th>장애번호</th>
				<td>
					<input id="jangNo" name="jangNo" type="text" class="${textCss} w100p" maxlength="80" ${readonly}>
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103844' mdef='장애구분'/></th>
				<td>
				<c:choose>
					<c:when test="${authPg == 'A'}">
						<select id="jangType" name="jangType" class="required">
						</select>
						<input id="jangTypeNm" name="jangTypeNm" type="hidden" ${readonly}>
					</c:when>
					<c:otherwise>
						<input id="jangType" name="jangType" type="hidden" class="${textCss}" ${readonly}>
						<input id="jangTypeNm" name="jangTypeNm" type="text" class="${textCss}" readonly>
					</c:otherwise>
				</c:choose>
				</td>
				<th>장애인정기관</th>
				<td>
					<input id="jangOrgNm" name="jangOrgNm" type="text" class="${textCss} w100p" maxlength="300" ${readonly} style="ime-mode:active;" />
				</td>
			</tr>
			<tr>
				<th><tit:txt mid='103783' mdef='비고'/></th>
				<td colspan="3">
					<textarea id="jangMemo" name="jangMemo" rows="4" cols="" class="w100p ${readonly}" ${readonly}></textarea>
				</td>
			</tr>
			</table>


		</td>
	</tr>
	</table>

	<div class="hide">
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
		<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
		<script type="text/javascript"> createIBSheet("sheet3", "100%", "50%", "${ssnLocaleCd}"); </script>
		<script type="text/javascript"> createIBSheet("sheet4", "100%", "50%", "${ssnLocaleCd}"); </script>
	</div>

</div>
</body>
</html>

