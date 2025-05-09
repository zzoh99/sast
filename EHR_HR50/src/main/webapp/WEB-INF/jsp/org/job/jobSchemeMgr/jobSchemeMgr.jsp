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
			$("#searchSdate").datepicker2();

			$("#btnPlus").toggleClass("minus");

			// 트리레벨 정의
			$("#btnStep1").click(function()	{
				$("#btnPlus").removeClass("minus");
				sheet1.ShowTreeLevel(0, 1);
			});
			$("#btnStep2").click(function()	{
				$("#btnPlus").removeClass("minus");
				sheet1.ShowTreeLevel(1,2);
			});
			$("#btnStep3").click(function()	{
				if(!$("#btnPlus").hasClass("minus")){
					$("#btnPlus").toggleClass("minus");
					sheet1.ShowTreeLevel(-1);
				}
			});
			$("#btnPlus").click(function() {
				$("#btnPlus").toggleClass("minus");
				$("#btnPlus").hasClass("minus")?sheet1.ShowTreeLevel(-1):sheet1.ShowTreeLevel(0, 1);
			});
		});

		$(function() {
			var initdata = {};
			initdata.Cfg = {FrozenCol:8,SearchMode:smGeneral,Page:22, ChildPage:10};
			initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
			initdata.Cols = [
				{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"<sht:txt mid='statusCd' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"<sht:txt mid='detailV5' mdef='직무\n기술서'/>",	Type:"Image",     Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"detail", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	Cursor:"Pointer" },
				{Header:"<sht:txt mid='priorJobCd' mdef='직무상위코드'/>",	Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"priorJobCd",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='moveJikgunJobCd' mdef='직무코드'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jobCd",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,  	EditLen:10 },
				{Header:"<sht:txt mid='jobNmV2' mdef='직무명'/>",			Type:"Popup",     Hidden:0,  Width:150,  Align:"Left",    	ColMerge:0,   SaveName:"jobNm",         KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100,	TreeCol:1,  LevelSaveName:"sLevel" },
				{Header:"<sht:txt mid='jobEngNm' mdef='직무명(영문)'/>", 	Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    	ColMerge:0,   SaveName:"jobEngNm",    	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,  	EditLen:100 },
				{Header:"<sht:txt mid='jobType' mdef='직무형태'/>",		Type:"Combo",     Hidden:0,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jobType",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,  	EditLen:10 },
				{Header:"<sht:txt mid='memoV12' mdef='개요'/>",			Type:"Text",      Hidden:1,  Width:0,  	 Align:"Left",    	ColMerge:0,   SaveName:"memo",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
				{Header:"<sht:txt mid='jobDefine' mdef='직무정의'/>",		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"jobDefine",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,  	EditLen:4000 },
				{Header:"<sht:txt mid='sYmdV1' mdef='시작일'/>",			Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"sdate",         KeyField:1,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
				{Header:"<sht:txt mid='edate' mdef='종료일'/>", 		Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"edate",         KeyField:0,   CalcLogic:"",   Format:"Ymd",         PointCount:0,   UpdateEdit:1,   InsertEdit:1,  	EditLen:10 },
				{Header:"<sht:txt mid='jikgubReq' mdef='직급요건'/>",  		Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"jikgubReq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='academyReq' mdef='학력요건'/>", 		Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"academyReq",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='majorReq' mdef='전공요건'/>", 		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"majorReq",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
				{Header:"<sht:txt mid='careerReq' mdef='경력요건'/>",  		Type:"Combo",     Hidden:1,  Width:0,    Align:"Center",    ColMerge:0,   SaveName:"careerReq",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
				{Header:"<sht:txt mid='otherJobReq' mdef='경력요건(타직무)'/>", Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"otherJobReq",  	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,  	EditLen:100 },
				{Header:"<sht:txt mid='keyPositionYn' mdef='핵심\n포지션'/>",	Type:"CheckBox",  Hidden:0,  Width:50,   Align:"Center",  	ColMerge:0,   SaveName:"keyPositionYn", KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, TrueValue:"Y", FalseValue:"N"},
				{Header:"<sht:txt mid='note' mdef='비고'/>",  		Type:"Text",      Hidden:1,  Width:0,    Align:"Left",    	ColMerge:0,   SaveName:"note",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
				{Header:"<sht:txt mid='seqV2' mdef='순서'/>", 			Type:"Int",  	  Hidden:0,  Width:30,   Align:"Center",  	ColMerge:0,   SaveName:"seq",     		KeyField:0,   CalcLogic:"",   Format:"NullInteger", PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

			$("#searchSdate").bind("keyup",function(event){
				if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
			});

			$(window).smartresize(sheetResize); sheetInit();
			doAction1("Search");
		});

		function getCommonCodeList() {
			var jobType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30010", $("#searchSdate").val()), "");	//직무형태
			var jikgubReq 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30019", $("#searchSdate").val()), "");	//직급요건
			var academyReq 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30018", $("#searchSdate").val()), "");	//학력요건
			var careerReq 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W30020", $("#searchSdate").val()), "");	//경력요건

			sheet1.SetColProperty("jobType", 			{ComboText:jobType[0], ComboCode:jobType[1]} );	//직무형태
			sheet1.SetColProperty("jikgubReq", 			{ComboText:"|"+jikgubReq[0], ComboCode:"|"+jikgubReq[1]} );	//직급요건
			sheet1.SetColProperty("academyReq", 		{ComboText:"|"+academyReq[0], ComboCode:"|"+academyReq[1]} );	//학력요건
			sheet1.SetColProperty("careerReq", 			{ComboText:"|"+careerReq[0], ComboCode:"|"+careerReq[1]} );	//경력요건
		}

		//Sheet1 Action
		function doAction1(sAction) {
			switch (sAction) {
				case "Search":
					getCommonCodeList();
					sheet1.DoSearch( "${ctx}/JobSchemeMgr.do?cmd=getJobSchemeMgrList", $("#srchFrm").serialize() );
					break;
				case "Save": 		if(!dupChk(sheet1,"jobCd", true, true)){break;}
					IBS_SaveName(document.srchFrm,sheet1);
					sheet1.DoSave( "${ctx}/JobSchemeMgr.do?cmd=saveJobSchemeMgr", $("#srchFrm").serialize() ); break;
				case "Insert":
					if( sheet1.GetCellValue(sheet1.GetSelectRow(), "jobCd") == "" ) {
						alert("<msg:txt mid='109914' mdef='직무를 선택 하세요.'/>");
						sheet1.SelectCell(sheet1.GetSelectRow(), "jobNm");
						return;
					}
					var Row = sheet1.DataInsert();
					sheet1.SetCellValue(Row,"priorJobCd", sheet1.GetCellValue(Row-1, "jobCd"));
					sheet1.SetCellValue(Row, "sdate", <%=DateUtil.getCurrentTime("yyyyMMdd")%>);
					sheet1.SelectCell(Row, "jobNm");
					break;
				case "Copy":		sheet1.DataCopy(); break;
				case "Clear":		sheet1.RemoveAll(); break;
				case "Down2Excel":	sheet1.Down2Excel(); break;
				case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
			}
		}

		// 조회 후 에러 메시지
		function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
			try { 	if (Msg != "") { alert(Msg); }
// 			sheet1.ShowTreeLevel(1, 2);
				sheet1.SetRowEditable(1, false);
				sheetResize();
			} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
		}

		// 저장 후 메시지
		function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
		}

		// 팝업 클릭시 발생
		function sheet1_OnPopupClick(Row,Col) {
			try {
				if(sheet1.ColSaveName(Col) == "jobNm") {
					jobPopup(Row) ;
				}
			} catch (ex) {
				alert("OnKeyDown Event Error : " + ex);
			}
		}

		function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
			try{
				if( Row == 1 ) {
					return;
				}

				if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
					jobMgrPopup(Row);
				}
			}catch(ex){alert("OnClick Event Error : " + ex);}
		}

		//  직무코드 조회
		function jobPopup(Row){
			var args    = new Array();

			gPRow = Row;
			pGubun = "jobPopup";

			var layer = new window.top.document.LayerModal({
				id : 'jobPopupLayer'
				, url : "${ctx}/Popup.do?cmd=jobPopup&authPg=${authPg}"
				, parameters: args
				, width : 740
				, height : 720
				, title : "직무 리스트 조회"
				, trigger :[
					{
						name : 'jobPopupTrigger'
						, callback : function(rv){
							getReturnValue(rv);
						}
					}
				]
			});
			layer.show();
		}

		/**
		 * 직무기술서 팝업
		 */
		function jobMgrPopup(Row){
			if(!isPopup()) {return;}

			var w 		= 1000;
			var h 		= 720;
			<%--var url 	= "${ctx}/JobMgr.do?cmd=viewJobMgrPopup&authPg=R";--%>
			var url = "/Popup.do?cmd=viewJobMgrLayer&authPg=R";
			// var args 	= new Array();
			// args["jobCd"] 		= sheet1.GetCellValue(Row, "jobCd");
			var p = {
				jobCd : sheet1.GetCellValue(Row, "jobCd")
			};

			// openPopup(url,args,w,h);
			var jobMgrLayer = new window.top.document.LayerModal({
				id: 'jobMgrLayer',
				url: url,
				parameters: p,
				width: w,
				height: h,
				title: '직무기술서',
				trigger: [
					{
						name: 'jobMgrLayerTrigger',
						callback: function(rv) {
							getReturnValue(rv);
						}
					}
				]
			});

			jobMgrLayer.show();
		}

		//팝업 콜백 함수.
		function getReturnValue(returnValue) {
			var rv = returnValue;

			if(pGubun == "jobPopup"){
				sheet1.SetCellValue(gPRow, "jobCd",		rv["jobCd"]);
				sheet1.SetCellValue(gPRow, "jobNm",		rv["jobNm"]);
				sheet1.SetCellValue(gPRow, "jobEngNm",	rv["jobEngNm"]);
				sheet1.SetCellValue(gPRow, "jobType",	rv["jobType"]);
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
						<th><tit:txt mid='103906' mdef='기준일자 '/> </th>
						<td>  <input id="searchSdate" name="searchSdate" type="text" size="10" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>"/> </td>
						<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='jobSchemeV1' mdef='직무분류표'/>&nbsp;
								<div class="util">
									<ul>
										<li	id="btnPlus"></li>
										<li	id="btnStep1"></li>
										<li	id="btnStep2"></li>
										<li	id="btnStep3"></li>
									</ul>
								</div>
							</li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='down2excel' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
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