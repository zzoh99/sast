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
		var enterCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getEnterCdAllList&enterCd=",false).codeList, "");
		var appSeqCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getComCodeNoteList&searchGrcodeCd=P00004&searchUseYn=Y",false).codeList, "");

		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='enterCdV3' mdef='회사코드|회사코드'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"다면평가명|다면평가명",										Type:"Combo",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"compAppraisalCd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"대상자(피평가자)|회사",										Type:"Combo",	Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"wEnterCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자(피평가자)|성명",										Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"대상자(피평가자)|사번",										Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"대상자(피평가자)|소속",										Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"대상자(피평가자)|직급",										Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"대상자(피평가자)|직급명",										Type:"Text",	Hidden:Number("${jgHdn}"),	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자(피평가자)|직위",										Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikweeCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"대상자(피평가자)|직위명",										Type:"Text",	Hidden:Number("${jwHdn}"),	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자(피평가자)|직책",										Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"jikchakCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상자(피평가자)|직책명",										Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"평가포함\n여부|평가포함\n여부",								Type:"Combo",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appYn",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);sheet2.SetUnicodeByte(3);sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet2.SetColProperty("compAppraisalCd",	{ComboText:compAppraisalCdList[0], ComboCode:compAppraisalCdList[1]} );
		sheet2.SetColProperty("wEnterCd",		{ComboText:enterCdList[0], ComboCode:enterCdList[1]} );
		sheet2.SetColProperty("appYn",			{ComboText:"|Y|N", ComboCode:"|Y|N"} );

		
		
		
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"다면평가명|다면평가명",	Type:"Combo",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"compAppraisalCd",	KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"대상자(피평가자)|회사",		Type:"Combo",	Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"wEnterCd",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"대상자(피평가자)|사번",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"대상자(피평가자)|성명",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자(피평가자)|소속",		Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자(피평가자)|직급",		Type:"Text",	Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자(피평가자)|직위",		Type:"Text",	Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자(피평가자)|직책",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV2' mdef='평가자정보|회사'/>",			Type:"Combo",	Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"appEnterCd",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='appSeqCdV1' mdef='평가자정보|차수'/>",			Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='appSabunV2' mdef='평가자정보|사번'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:1,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='appNameV2' mdef='평가자정보|성명'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appName",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appNameV2' mdef='평가자정보|평가그룹'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appGroup",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			
			
			{Header:"평가자정보|영문약자",			Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"appAlias",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV1' mdef='평가자정보|소속'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"appOrgNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='appJikweeNmV1' mdef='평가자정보|직급'/>",			Type:"Text",	Hidden:Number("${jgHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appJikgubNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가자정보|직위",			Type:"Text",	Hidden:Number("${jwHdn}"),	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appJikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		sheet1.SetColProperty("compAppraisalCd",	{ComboText:compAppraisalCdList[0], ComboCode:compAppraisalCdList[1]} );
		sheet1.SetColProperty("wEnterCd",			{ComboText:enterCdList[0], ComboCode:enterCdList[1]} );
		sheet1.SetColProperty("appEnterCd",			{ComboText:enterCdList[0], ComboCode:enterCdList[1]} );
		sheet1.SetColProperty("appSeqCd",			{ComboText:appSeqCdList[0], ComboCode:appSeqCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		// 조회조건 이벤트
		$("#searchCompAppraisalCd").bind("change", function(){
			doAction1("Search");
		});

		$("#searchName, #searchAppName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction2("Search");
				doAction1("Search"); 
				
				$(this).focus();
			}
		});

		// 조회조건 값 setting
		$("#searchCompAppraisalCd").html(compAppraisalCdList[2]);

		//doAction1("Search");
		doSearch()
	});

	/**
	 * Sheet 각종 처리
	 */
	 
	 
	function doSearch(){
		doAction2("Search");
		doAction1("Search");
	}
	
	 
	 
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet1.DoSearch( "${ctx}/CompAppPeopleMngdUpload.do?cmd=getCompAppPeopleMngdUploadList", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				if(sheet1.FindStatusRow("I") != ""){
					if(!dupChk(sheet1,"wEnterCd|sabun|compAppraisalCd|appEnterCd|appSabun", true, true)){break;}
				}

				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/CompAppPeopleMngdUpload.do?cmd=saveCompAppPeopleMngdUpload", $("#srchFrm").serialize() );
				break;

			case "Insert":		//입력
				var Row = sheet1.DataInsert(0);
				break;

			case "Copy":		//행복사
				var Row = sheet1.DataCopy();
				break;

			case "Clear":		//Clear
				sheet1.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				if ( sheet1.RowCount() == 0 ) {
					alert("<msg:txt mid='109801' mdef='조회된 건이 없습니다.'/>");
					return;
				}

				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드

				if ( $("#searchCompAppraisalCd option:selected").val() == "" ){
					alert("다면평가명을 선택해주세요.");
					break;
				}
				var params = {Mode:"HeaderMatch"};
				sheet1.LoadExcel(params);
				break;
			case "DownTemplate": // 양식 다운로드
				sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"wEnterCd|sabun|compAppraisalCd|appEnterCd|appSeqCd|appSabun|appGroup"});
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

	function sheet1_OnLoadExcel() {

		for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
			sheet1.SetCellValue(i,"appraisalCd",$("#searchAppraisalCd").val());
			sheet1.SetCellValue(i,"wEnterCd","${ssnEnterCd}");
			sheet1.SetCellValue(i,"appEnterCd","${ssnEnterCd}");
		}

	}
	
	
	
	/**
	 * Sheet2 각종 처리
	 */
	function doAction2(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet2.DoSearch( "${ctx}/CompAppPeopleMngdUpload.do?cmd=getCompAppPeopleMngdUploadList2", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				if(sheet2.FindStatusRow("I") != ""){
					if(!dupChk(sheet2,"enterCd|compAppraisalCd|wEnterCd|sabun", true, true)){break;}
				}

				IBS_SaveName(document.srchFrm,sheet2);
				sheet2.DoSave( "${ctx}/CompAppPeopleMngdUpload.do?cmd=saveCompAppPeopleMngdUpload2", $("#srchFrm").serialize() );
				break;

			case "Insert":		//입력
				var Row = sheet2.DataInsert(0);
				break;

			case "Copy":		//행복사
				var Row = sheet2.DataCopy();
				break;

			case "Clear":		//Clear
				sheet2.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				if ( sheet2.RowCount() == 0 ) {
					alert("<msg:txt mid='109801' mdef='조회된 건이 없습니다.'/>");
					return;
				}

				sheet2.Down2Excel({DownCols:makeHiddenSkipCol(sheet2),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드

				if ( $("#searchCompAppraisalCd option:selected").val() == "" ){
					alert("역량평가명을 선택해주세요.");
					break;
				}
				var params = {Mode:"HeaderMatch"};
				sheet2.LoadExcel(params);
				break;
			case "DownTemplate": // 양식 다운로드
				sheet2.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"enterCd|compAppraisalCd|wEnterCd|sabun|appYn"});
				break;
		}
	}

	//<!-- 조회 후 에러 메시지 -->
	function sheet2_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
		//setSheetSize(this);
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

	function sheet2_OnLoadExcel() {

		for(var i = sheet2.HeaderRows(); i<sheet2.RowCount()+sheet2.HeaderRows(); i++){
			sheet2.SetCellValue(i,"compAppraisalCd",$("#searchAppraisalCd").val());
			sheet2.SetCellValue(i,"wEnterCd","${ssnEnterCd}");
			sheet2.SetCellValue(i,"enterCd","${ssnEnterCd}");
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
							<span>평가명</span>
							<SELECT id="searchCompAppraisalCd" name="searchCompAppraisalCd" class="box"></SELECT>
						</td>
						<td>
							<span>대상자(피평가자)</span>
							<input type="text" id="searchName" name="searchName" class="text" />
						</td>
						<td>
							<span><tit:txt mid='compAppPeopleMng2' mdef='평가자'/></span>
							<input type="text" id="searchAppName" name="searchAppName" class="text" />
						</td>
						<td>
							<a href="javascript:doSearch()" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
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
							<li id="txt" class="txt">대상자(피평가자)업로드</li>
							<li class="btn">
								<a href="javascript:doAction2('DownTemplate')" 	class="basic authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
								<a href="javascript:doAction2('Down2Excel')" 	class="basic authA"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction2('LoadExcel')" 	class="basic authA"><tit:txt mid='104242' mdef='업로드'/></a>
								<a href="javascript:doAction2('Save')" 			class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet2", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">평가자업로드
								<span><font color="red" style="font-size:8pt;">* 업로드 파일 작성시 필수 항목은 다면평가명, 대상자(피평가자)/평가자  회사,사번 입니다.</font></span>
							</li>
							<li class="btn">
								<a href="javascript:doAction1('DownTemplate')" 	class="basic authA"><tit:txt mid='113684' mdef='양식다운로드'/></a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authA"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA"><tit:txt mid='104242' mdef='업로드'/></a>
								<a href="javascript:doAction1('Save')" 			class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "50%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
