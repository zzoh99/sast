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

	$(function() {
		// 공통코드 조회
		var eduBranchCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10010"));
		var eduMBranchCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10015"));
		var eduMethodCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10050"));
		var inOutTypeCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L20020"));

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='payYmV3' mdef='대상년월'/>",			Type:"Date",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"uploadYm",		KeyField:0,	CalcLogic:"",	Format:"Ym",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"자료반영\n처리여부",	Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"closeYn",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",				Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"Popup",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"영문약자",			Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"alias",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",				Type:"Text",	Hidden:Number("${jgHdn}"),	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",				Type:"Text",	Hidden:Number("${jwHdn}"),	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduCourseNmV1' mdef='교육과정명'/>",			Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduCourseNm",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='eduSYmdV1' mdef='교육시작일'/>",			Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"eduSYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduEYmdV1' mdef='교육종료일'/>",			Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"eduEYmd",			KeyField:1,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduOrgNm' mdef='교육기관'/>",			Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgNm",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='companyNum' mdef='사업자등록번호'/>",		Type:"Text",	Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"companyNum",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:50 },
			{Header:"<sht:txt mid='eduPlace' mdef='교육장소'/>",			Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"eduPlace",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='eduBranchCd' mdef='교육구분'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduBranchCd",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduMBranchCd' mdef='교육분류'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduMBranchCd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduMethodCd' mdef='시행방법'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduMethodCd",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='essentialYn' mdef='필수여부'/>",			Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"mandatoryYn",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y",FalseValue:"N" },
			{Header:"<sht:txt mid='inOutTypeV1' mdef='사내외구분'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"inOutType",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='unconfirmReason' mdef='미수료사유'/>",			Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"unconfirmReason",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
			{Header:"<sht:txt mid='eduHourV4' mdef='총시간'/>",			Type:"Int",		Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"eduHour",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 },
			{Header:"교육비용",			Type:"Text",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"perExpenseMon",	KeyField:0,	CalcLogic:"",	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 },
			{Header:"<sht:txt mid='laborApplyYnV3' mdef='고용보험\n환급여부'/>",	Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"laborApplyYn",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 },
			{Header:"<sht:txt mid='laborMon' mdef='환급금액'/>",			Type:"Text",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"laborMon",		KeyField:0,	CalcLogic:"",	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 },
			{Header:"<sht:txt mid='eduCost' mdef='실교육비'/>",			Type:"Text",	Hidden:0,	Width:70,	Align:"Right",	ColMerge:0,	SaveName:"realExpenseMon",	KeyField:0,	CalcLogic:"",	Format:"Number",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 },
			{Header:"<sht:txt mid='eduRewardCntV4' mdef='이수학점'/>",			Type:"Text",	Hidden:1,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"eduRewardCnt",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22 },
			{Header:"교육수료상태",		Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"eduConfirmType",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",				Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
			{Header:"<sht:txt mid='finishYnV2' mdef='교육이수여부'/>",		Type:"Combo",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"finishYn",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },

			{Header:"<sht:txt mid='hidEduMBranchCd' mdef='임시분류코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"hidEduMBranchCd",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='comboBrancdMCd' mdef='hiddenHead'/>",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"tEduMBranchCd",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000},
			{Header:"<sht:txt mid='comboBrancdMCd' mdef='hiddenHead'/>",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"comboBrancdMCd",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},
			{Header:"<sht:txt mid='comboBrancdMCd' mdef='hiddenHead'/>",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"comboBrancdMNm",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},
			{Header:"<sht:txt mid='comboBrancdMCd' mdef='hiddenHead'/>",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduEventSeq",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000},
			{Header:"<sht:txt mid='comboBrancdMCd' mdef='hiddenHead'/>",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"eduSeq",	KeyField:0,	CalcLogic:"",	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4000}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		sheet1.SetColProperty("eduBranchCd",	{ComboText: "|"+eduBranchCdList[0],  ComboCode: "|"+eduBranchCdList[1]} );
		sheet1.SetColProperty("eduMBranchCd",	{ComboText: "|"+eduMBranchCdList[0], ComboCode: "|"+eduMBranchCdList[1]} );
		sheet1.SetColProperty("eduMethodCd",	{ComboText: "|"+eduMethodCdList[0],  ComboCode: "|"+eduMethodCdList[1]} );
		sheet1.SetColProperty("finishYn",		{ComboText:"|Yes|No", ComboCode:"|1|0"} );
		sheet1.SetColProperty("eduConfirmType",	{ComboText:"|수료|미수료", ComboCode:"|1|0"} );
		sheet1.SetColProperty("laborApplyYn",	{ComboText:"|N|Y", ComboCode:"|N|Y"} );
		sheet1.SetColProperty("closeYn",		{ComboText:"|Yes|No", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("mandatoryYn",	{ComboText:"|Yes|No", ComboCode:"|Y|N"} );
		sheet1.SetColProperty("inOutType",		{ComboText: "|"+inOutTypeCdList[0],  ComboCode: "|"+inOutTypeCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		// 조회조건 이벤트
		$("#searchYmView").bind("keyup",function(event) {
			if (event.keyCode == 13) {
				doAction1("Search");
			}
		});

		$("#searchYmView").datepicker2({ymonly:true});

		// 조회조건 값 setting
		$("#searchYmView").val("${curSysYyyyMMHyphen}");

		doAction1("Search");
	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		$("#searchYm").val( $("#searchYmView").val().replace("-", "") );

		switch(sAction){
			case "Search":		//조회
				sheet1.DoSearch( "${ctx}/CyberEduLoad.do?cmd=getCyberEduLoadList", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
			    /**
				if(sheet1.FindStatusRow("I") != ""){
					if(!dupChk(sheet1,"sabun|eduCourseNm|eduSYmd", true, true)){break;}
				}
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveCyberEduLoad", $("#srchFrm").serialize() );
				break;
				**/
/*
				if(sheet1.FindStatusRow("I") != ""){
					if(!dupChk(sheet1,"sabun|eduCourseNm|eduSYmd", true, true)){break;}
				} */

				if(!dupChk(sheet1,"sabun|eduCourseNm|eduSYmd|eduEYmd|eduOrgNm|companyNum|eduBranchCd|eduMBranchCd|eduMethodCd|inOutType", true, true)){break;}

				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/CyberEduLoad.do?cmd=saveCyberEduLoad", $("#srchFrm").serialize() );
				break;

			case "Insert":		//입력
				if($("#searchYm").val() == ""){
					alert("조회조건 대상년월을 입력 후 입력 하시기 바랍니다.");
					$("#searchYm").focus();
					return;
				}

				var Row = sheet1.DataInsert(0);
				sheet1.SetCellValue(Row, "compAppraisalCd", $("#searchCompAppraisalCd").val());
				sheet1.SetCellValue(Row, "scope", "0");
				sheet1.SelectCell(Row, 4);
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
				if($("#searchYm").val() == ""){
					alert("조회조건 대상년월을 입력 후 업로드 하시기 바랍니다.");
					$("#searchYm").focus();
					return;
				}

				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;

			case "DownTemplate":  //양식다운로드
				var arrHiddenCol = ["sNo", "sDelete", "sStatus", "name", "closeYn"];

				for (var i=0; i<arrHiddenCol.length; i++){ sheet1.SetColHidden(arrHiddenCol[i],true); }

				sheet1.Down2Excel({
					TitleText:""
					, DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1,DownRows:0
				});

				for (var i=0; i<arrHiddenCol.length; i++){ sheet1.SetColHidden(arrHiddenCol[i],false); }

				break;

			case "Update":		//자료반영
				if($("#searchYm").val() == ""){
					alert("조회조건 대상년월을 입력 후 자료반영하시기 바랍니다.");
					$("#searchYm").focus();
					return;
				}

				if(sheet1.RowCount == 0){
					alert("<msg:txt mid='alertCyberEduLoad2' mdef='해당월의 작업 대상자료가 존재하지 않습니다. <br> [자료가져오기]작업 선행 후 교육이력반영 작업을 실행하시기 바랍니다.'/>");
					return;
				}

				if( !confirm("교육이력반영을 하시겠습니가?\n해당 작업년월에 대해 자동 마감처리가 됩니다.") ) return;

		    	var data = ajaxCall("${ctx}/CyberEduLoad.do?cmd=prcCyberEduLoad",$("#srchFrm").serialize(),false);
				if(data.Result.Code == null) {
					alert("<msg:txt mid='alertCyberEduLoad4' mdef='교육자료 반영이 완료되었습니다.'/>");
					doAction1("Search");
		    	} else {
			    	alert(data.Result.Message);
		    	}

				break;
		}
	}

	//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			/*
			for (var i=sheet1.HeaderRows(); i<=sheet1.LastRow(); i++) {
				sheet1.CellComboItem(i, "eduMBranchCd",	{"ComboCode": "|"+sheet1.GetCellValue(i, "comboBrancdMCd"),"ComboText": "|"+sheet1.GetCellValue(i, "comboBrancdMNm")});
				sheet1.SetCellValue(i, "eduMBranchCd", sheet1.GetCellValue(i, "tEduMBranchCd"));
			}
			*/
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

	// 팝업 클릭시
	function sheet1_OnPopupClick(Row,Col) {
		try{
			if ( sheet1.ColSaveName(Col) == "name" ) {
				if(!isPopup()) {return;}

				let layerModal = new window.top.document.LayerModal({
					id : 'employeeLayer'
					, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
					, parameters : {}
					, width : 840
					, height : 520
					, title : '사원조회'
					, trigger :[
						{
							name : 'employeeTrigger'
							, callback : function(rv){
								sheet1.SetCellValue(Row, "sabun",		rv["sabun"] );
								sheet1.SetCellValue(Row, "name",		rv["name"] );
								sheet1.SetCellValue(Row, "alias",		rv["alias"] );
								sheet1.SetCellValue(Row, "jikgubNm",		rv["jikgubNm"] );
								sheet1.SetCellValue(Row, "jikweeNm",		rv["jikweeNm"] );
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
						<th><tit:txt mid='114444' mdef='대상년월'/></th>
						<td>
							<input type="text" id="searchYmView" name="searchYmView" class="date2" value="" />
							<input type="hidden" id="searchYm" name="searchYm" />
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="explain">
	  <div class="title">※ 도움말</div>
	     <div class="txt">
	       <table>
			 <tr>
			 	<td id="etcComment">
			       <li><b>업로드한 자료를 잘못 반영했을시 아래 화면에서 삭제 작업 수행.</b></font></li>
				   <li>1. 개인과정종합관리 > 교육이력관리</li>
				   <li>2. 교육과정관리 > 교육기관관리/교육과정관리/교육회차관리</li>
			    </td>
			 </tr>
			</table>
	  </div>
	 </div>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='cyberEduLoad' mdef='사이버교육Load'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Update')" 		css="button authA" mid='111886' mdef="자료반영"/>
								<btn:a href="javascript:doAction1('DownTemplate')"	css="basic authA" mid='110702' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction1('LoadExcel')"		css="basic authA" mid='110997' mdef="자료업로드"/>
								<btn:a href="javascript:doAction1('Insert')"		css="basic authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')"			css="basic authA" mid='110708' mdef="저장"/>
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="basic authR" mid='110698' mdef="다운로드"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "80%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
