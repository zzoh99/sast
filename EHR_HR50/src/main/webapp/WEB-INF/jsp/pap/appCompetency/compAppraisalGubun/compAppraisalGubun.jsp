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
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"다면평가명",		Type:"Combo",	Hidden:0,	Width:160,	Align:"Left",	ColMerge:0,	SaveName:"compAppraisalCd",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"다면평가항목코드",		Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompetencyCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"다면평가항목명",		Type:"Popup",	Hidden:0,	Width:180,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompetencyNm",	KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='colSeq' mdef='헤더순서'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"colSeq",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='scopeGubun' mdef='범위구분'/>",			Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"scopeGubun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='scope' mdef='범위적용'/>",			Type:"Image",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"scope",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='nassignApplyYn' mdef='비보직자적용여부'/>",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"nassignApplyYn",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		sheet1.SetColProperty("compAppraisalCd",	{ComboText:compAppraisalCdList[0], ComboCode:compAppraisalCdList[1]} );
		sheet1.SetColProperty("colSeq",				{ComboText:colSeqList[0], ComboCode:colSeqList[1]} );
		sheet1.SetColProperty("scopeGubun",			{ComboText:"전체|해당직무|범위적용", ComboCode:"A|J|O"} );

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("scope",1);

		$(window).smartresize(sheetResize); sheetInit();

		// 조회조건 이벤트
		$("#searchCompAppraisalCd").bind("change", function(){
			doAction1("Search");
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
				sheet1.DoSearch( "${ctx}/CompAppraisalGubun.do?cmd=getCompAppraisalGubunList", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				if(sheet1.FindStatusRow("I") != ""){
					if(!dupChk(sheet1,"compAppraisalCd|ldsCompetencyCd", true, true)){break;}

					if(!dupChk(sheet1,"colSeq", true, true)){break;}
				}

				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/CompAppraisalGubun.do?cmd=saveCompAppraisalGubun", $("#srchFrm").serialize() );
				break;

			case "Insert":		//입력
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

	// 팝업 클릭시
	function sheet1_OnPopupClick(Row,Col) {
		try{
			if ( sheet1.ColSaveName(Col) == "ldsCompetencyNm" ) {
				<%--var args = new Array();--%>
				<%--openPopup("${ctx}/LDSCompetencyMng.do?cmd=viewLDSCompetencyMngPop", args, "900","500", function(rv) {--%>
				<%--	if(rv!=null){--%>
				<%--		sheet1.SetCellValue(Row, "ldsCompetencyCd",	rv["ldsCompetencyCd"] );--%>
				<%--		sheet1.SetCellValue(Row, "ldsCompetencyNm",	rv["ldsCompetencyNm"] );--%>
				<%--	}--%>
				<%--});--%>

				var layer = new window.top.document.LayerModal({
					id : 'competencyMngLayer'
					, url : '/CompAppraisalGubun.do?cmd=viewCompetencyMngLayer'
					, parameters: {}
					, width : 900
					, height : 500
					, title : "역량항목"
					, trigger :[
						{
							name : 'competencyMngLayerTrigger'
							, callback : function(rv){
								sheet1.SetCellValue(Row, "ldsCompetencyCd",	rv.ldsCompetencyCd );
								sheet1.SetCellValue(Row, "ldsCompetencyNm",	rv.ldsCompetencyNm );
							}
						}
					]
				});
				layer.show();

			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// Click 시
	function sheet1_OnClick(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "scope"  && Row >= sheet1.HeaderRows()) {
				if( sheet1.GetCellValue(Row,"sStatus") == "I" ) {
					alert("<msg:txt mid='alertCompAppraisalGubun1' mdef='입력 상태에서는 범위설정을 하실 수 없습니다.'/>");
					return;
				}
				if(sheet1.GetCellValue(Row,"scopeGubun") != "O") {
					alert("<msg:txt mid='alertCompAppraisalGubun2' mdef='범위구분에서 [범위적용]으로 선택했을 경우만 조회를 할 수 있습니다.'/>");
					return;
				}

				<%--var args = new Array();--%>
				<%--args["searchUseGubun"] = "C";--%>
				<%--args["searchItemValue1"] = sheet1.GetCellValue(Row,"compAppraisalCd");--%>
				<%--args["searchItemValue2"] = sheet1.GetCellValue(Row,"ldsCompetencyCd");--%>
				<%--args["searchItemValue3"] = "0";--%>
				<%--args["searchItemNm"] = sheet1.GetCellValue(Row,"ldsCompetencyNm");--%>

				<%--var result = openPopup("${ctx}/AppGroupMgrRngPop.do?cmd=viewAppGroupMgrRngPop&authPg=${authPg}",args,"940","700");--%>

				var layer = new window.top.document.LayerModal({
					id : 'compAppraisalGubunRngLayer'
					, url : '/CompAppraisalGubun.do?cmd=viewCompAppraisalGubunRngLayer&authPg=${authPg}'
					, parameters: {
						searchUseGubun : "C",
						searchItemValue1 : sheet1.GetCellValue(Row,"compAppraisalCd"),
						searchItemValue2 : sheet1.GetCellValue(Row,"ldsCompetencyCd"),
						searchItemValue3 : "0",
						searchItemNm : sheet1.GetCellValue(Row,"ldsCompetencyNm")
					}
					, width : 940
					, height : 700
					, title : "범위설정"
					, trigger :[
						{
							name : 'compAppraisalGubunRngLayerTrigger'
							, callback : function(rv){

							}
						}
					]
				});
				layer.show();
			}

		}catch(ex){alert("OnClick Event Error : " + ex);}
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
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a>
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
							<li id="txt" class="txt">리더십평가항목정의</li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction1('Copy')" 	class="btn outline_gray authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction1('Insert')" class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Save')" 	class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
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
