<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"평가ID코드",Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"조직코드",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"grpId",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"조직명",	Type:"Popup",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"grpNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"평가등급",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appClassCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"비고",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"note",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000}

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var classCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00002"), " ");
		sheet1.SetColProperty("appClassCd", 	{ComboText:"|"+classCdList[0], ComboCode:"|"+classCdList[1]} );

		$(window).smartresize(sheetResize); sheetInit();

		$("#searchAppraisalCd").change(function(){
			$("#searchCloseYn").val("");

			var data = ajaxCall("${ctx}/AppOrgResultMgr.do?cmd=getAppOrgResultMgrMap",$("#srchFrm").serialize(),false);

			if(data != null && data.map != null) {
				$("#searchCloseYn").val(data.map.closeYn);
			}

			doAction1("Search");
		});

		$("#searchNameSabun").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		//평가코드
		var appraisalCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdList",false).codeList, "");
		$("#searchAppraisalCd").html(appraisalCd[2]);
		$("#searchAppraisalCd").change();
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getAppOrgResultMgrList", $("#srchFrm").serialize() ); break;
		case "Insert":
			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "appraisalCd", $("#searchAppraisalCd").val());
			break;
		case "Save":
							if ( $("#searchCloseYn").val() == "Y" ) {
								alert("해당 평가가 마감되었습니다.");
								return;
							}
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/SaveData.do?cmd=saveAppOrgResultMgr", $("#srchFrm").serialize()); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"4|5|6|7|8"});
			break;
		}
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			if ( Code != "-1" ) doAction1("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col) {
		orgSearchPopup(Row);
	}

	// 소속 팝업
	function orgSearchPopup(Row) {
		if(!isPopup()) {return;}

		var w		= 680;
		var h		= 520;
		var url		= "${ctx}/Popup.do?cmd=orgBasicPopup";
		var args	= new Array();

		gPRow = Row;
		pGubun = "orgBasicPopup";

		openPopup(url+"&authPg=R", args, w, h);
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "orgBasicPopup"){
			sheet1.SetCellValue(gPRow, "grpId", rv["orgCd"]);
			sheet1.SetCellValue(gPRow, "grpNm", rv["orgNm"]);
        }
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchCloseYn" name="searchCloseYn" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가명</span>
							<select name="searchAppraisalCd" id="searchAppraisalCd">
							</select>
						</td>
						<td><span>부서코드 </span>
							<input id="searchGrpId" name="searchGrpId" type="text" class="text" />
						</td>
						<td><span>부서명</span>
							<input id="searchGrpNm" name="searchGrpNm" type="text" class="text" />
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a> </td>
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
							<li id="txt" class="txt">조직평가결과관리</li>
							<li class="btn">
								<a href="javascript:doAction1('DownTemplate')" 	class="basic authA">양식다운로드</a>
								<a href="javascript:doAction1('LoadExcel')" 	class="basic authA">업로드</a>
								<a href="javascript:doAction1('Insert')" 	class="basic authA">입력</a>
								<a href="javascript:doAction1('Save')" 		class="basic authA">저장</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>