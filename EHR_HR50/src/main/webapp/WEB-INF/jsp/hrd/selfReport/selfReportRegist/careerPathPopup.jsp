<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var searchCareerTargetCd = "";
	var showCareerPath         = true;

	var EnterKeyEvent = function(control, searchFunc, searchParam){
		$(control).bind("keyup", function(event) {
			if (event.keyCode == 13) {
				searchFunc(searchParam);
				$(control).focus();
			}
		});
	};

	var SelectChangeEvent = function(control, searchFunc, searchParam){
		$(control).on("change", function() {
			searchFunc(searchParam);
			$(control).focus();
		});
	};

	var SelectChangeEvent = function(control, searchFunc, searchParam){
		sheet.SetColuProperty(columnName, {ComboText:"|"+ lookupList[0], ComboCode:"|"+lookupList[1]});
	};

	$(function() {
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			searchCareerTargetCd = arg["searchCareerTargetCd" ];
			showCareerPath       = arg["showCareerPath"       ];
		}else{
			if ( p.popDialogArgument("searchCareerTargetCd" ) !=null ) { searchCareerTargetCd		= p.popDialogArgument("searchCareerTargetCd" ); }
			if ( p.popDialogArgument("showCareerPath"       ) !=null ) { showCareerPath	            = p.popDialogArgument("showCareerPath"       ); }
		}

		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'                mdef='No'				/>", Type:"${sNoTy}"  , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete'            mdef='삭제'				/>", Type:"${sDelTy}" , Hidden:1                  , Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete" ,Sort:0 ,HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus'            mdef='상태'				/>", Type:"${sSttTy}" , Hidden:1                  , Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus" ,Sort:0},
			{Header:"<sht:txt mid='careerTargetNm'     mdef='경력목표'				/>", Type:"Text"      , Hidden:0                  , Width:150         , Align:"Center", ColMerge:0, SaveName:"careerTargetNm"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='limitCnt'           mdef='적정인원'				/>", Type:"Text"      , Hidden:0                  , Width:30          , Align:"Center", ColMerge:0, SaveName:"limitCnt"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='enterCd'            mdef='회사코드'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"enterCd"           , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='careerTargetCd'     mdef='careerTargetCd'	/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"careerTargetCd"    , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='careerTargetType'   mdef='careerTargetType'	/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"careerTargetType"  , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='careerTargetTypeNm' mdef='careerTargetTypeNm'/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"careerTargetTypeNm", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='careerTargetDesc'   mdef='careerTargetDesc'	/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"careerTargetDesc"  , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='startYmd'           mdef='시작일자'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"startYmd"          , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='endYmd'             mdef='종료익자'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"endYmd"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='regYmd'             mdef='등록익자'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"regYmd"            , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='useYn'              mdef='사용여부'				/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"useYn"             , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='g1StepDesc'         mdef='g1StepDesc'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"g1StepDesc"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='g1NeedDesc'         mdef='g1NeedDesc'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"g1NeedDesc"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='g2StepDesc'         mdef='g2StepDesc'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"g2StepDesc"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='g2NeedDesc'         mdef='g2NeedDesc'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"g2NeedDesc"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='g3StepDesc'         mdef='g3StepDesc'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"g3StepDesc"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='g3NeedDesc'         mdef='g3NeedDesc'		/>", Type:"Text"      , Hidden:1                  , Width:50          , Align:"Center", ColMerge:0, SaveName:"g3NeedDesc"        , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" }
		];
		IBS_InitSheet(sheet1, initdata);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100};
		initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:0, HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'          mdef='No'	/>", Type:"${sNoTy}"  , Hidden:1, Width:"${sNoWdt}" , Align:"Center", ColMerge:0, SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete'      mdef='삭제'	/>", Type:"${sDelTy}" , Hidden:1, Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0, HeaderCheck:0},
			{Header:"<sht:txt mid='sStatus'      mdef='상태'	/>", Type:"${sSttTy}" , Hidden:1, Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0},
			{Header:"<sht:txt mid='careerPathCd' mdef='단계'	/>", Type:"Text"      , Hidden:0, Width:25          , Align:"Center", ColMerge:0, SaveName:"careerPathCd", KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jobNm04'      mdef='업무'	/>", Type:"Text"      , Hidden:0, Width:100         , Align:"Center", ColMerge:0, SaveName:"jobNm"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='jobCd'        mdef='업무'	/>", Type:"Text"      , Hidden:1, Width:100         , Align:"Center", ColMerge:0, SaveName:"jobCd"       , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='exeTerm04'    mdef='경력'	/>", Type:"Text"      , Hidden:0, Width:30          , Align:"Center", ColMerge:0, SaveName:"exeTerm"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" },
			{Header:"<sht:txt mid='detail1'      mdef='보기'	/>", Type:"Image"     , Hidden:0, Width:30          , Align:"Center", ColMerge:0, SaveName:"detail1"     , KeyField:0, UpdateEdit:0, InsertEdit:0, EditLen:0, MultiLineText:0, PointCount:0, CalcLogic:"", Format:"" }
		];
		IBS_InitSheet(sheet2, initdata);
		sheet2.SetVisible(true);
		sheet2.SetCountPosition(4);
		sheet2.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		sheet2.SetDataLinkMouse("detail1", 1);

		loadUI();
		loadEvent();

		sheetInit();

		doAction1("Search");
	});

	function loadUI(){
		$(window).smartresize(sheetResize);

	}

	function loadEvent(){
		$("input:text").each(function(index){
			EnterKeyEvent(this, doAction1, "Search")
		});

		$("select").each(function(index){
			SelectChangeEvent(this, doAction1, "Search");
		})
	}

	function loadLookupCombo(sheet, fieldName, codeList){
		sheet.SetColProperty(fieldName, {ComboText:"|"+codeList[0], ComboCode:"|"+codeList[1]} );
	}


	function doAction1(sAction){
		switch (sAction) {
			case "Search":
				var params = "searchCareerTargetCd=" + searchCareerTargetCd;
				sheet1.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getCareerPathPopupList", params);
				break;
		}
	}

	function doAction2(sAction){
		switch (sAction) {
			case "Search":
				var row = sheet1.GetSelectRow();
				var careerTargetCd = sheet1.GetCellValue(row, "careerTargetCd");
				var params = "searchCareerTargetCd=" + careerTargetCd;
				sheet2.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getCareerPathPopupDetailList", params);
				break;
		}
	}

	function sheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") 
				alert(msg);

			if (sheet1.RowCount() > 0) {
				sheet1.SetSelectRow(sheet1.HeaderRows());
				doAction2("Search");
			}
			
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			if ( sheet1.ColSaveName(col) == "colName") {
				//TODO something
				return;
			}

			doAction2("Search");

		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}


	function sheet1_OnDblClick(Row, Col){
		try{
			returnCareerPath(Row,Col);
		}
		catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
		finally{
			p.self.close();;
		}
	}

	function sheet2_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") 
				alert(msg);

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet2_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			if( ( row > 0 ) &&
				(sheet2.ColSaveName(col) == "detail1")){
				var searchJobCd = "";

// 				if (sheet2.ColSaveName(col) == "detail04")
// 					searchJobCd = sheet2.GetCellValue(row, "jobCd04");
// 				else if (sheet2.ColSaveName(col) == "detail05")
// 					searchJobCd = sheet2.GetCellValue(row, "jobCd05");
// 				else if (sheet2.ColSaveName(col) == "detail06")
// 					searchJobCd = sheet2.GetCellValue(row, "jobCd06");
// 				else if (sheet2.ColSaveName(col) == "detail07")
// 					searchJobCd = sheet2.GetCellValue(row, "jobCd07");

				searchJobCd = sheet2.GetCellValue(row, "jobCd");
				
				if ( searchJobCd == "" )
					return;
				
				workAssignPopup(searchJobCd);
			}
			if ( sheet2.ColSaveName(col) == "colName") {
				//TODO something
				return;
			}

			//doAction2("Search");

		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function workAssignPopup(jobCd){
		try {
			if(!isPopup()) {return;}

			var args = new Array();
			args["searchJobCd"] = jobCd;

			gPRow = "";
			pGubun = "searchWorkAssignPopup";

			openPopup("${ctx}/SelfReportRegist.do?cmd=viewWorkAssignListPopup", args, "800","700");

		} catch(ex) { alert("Open Popup Event Error : " + ex); }
	}
	
	function returnCareerPath(Row,Col){
		var returnValue = new Array(7);

		returnValue["enterCd"           ] = sheet1.GetCellValue(Row, "enterCd"           );
		returnValue["careerTargetCd"    ] = sheet1.GetCellValue(Row, "careerTargetCd"    );
		returnValue["careerTargetNm"    ] = sheet1.GetCellValue(Row, "careerTargetNm"    );
		returnValue["careerTargetType"  ] = sheet1.GetCellValue(Row, "careerTargetType"  );
		returnValue["careerTargetTypeNm"] = sheet1.GetCellValue(Row, "careerTargetTypeNm");
		returnValue["careerTargetDesc"  ] = sheet1.GetCellValue(Row, "careerTargetDesc"  );
		returnValue["startYmd"          ] = sheet1.GetCellValue(Row, "startYmd"          );
		returnValue["endYmd"            ] = sheet1.GetCellValue(Row, "endYmd"            );

		if(p.popReturnValue) p.popReturnValue(returnValue);
		p.self.close();
	}
</script>
</head>
<body class="hidden">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='2020021200006' mdef='경력목표조회'/></li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main" style="padding-bottom:10px;">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<colgroup>
					<col width="30%" />
					<col width="2%" />
					<col width="68%" />
				</colgroup>
				<tr>
					<td>
						<form id="sheet1Form" name="sheet1Form"></form>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt1" class="txt"><tit:txt mid='2020021200001' mdef='경력목표'/></li>
									<li class="btn">

									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
					</td>
					<td>

					</td>
					<td>
						<form id="sheet2Form" name="sheet2Form"></form>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt2" class="txt"><tit:txt mid='2020021200002' mdef='직무'/></li>
									<li class="btn">

									</li>
								</ul>
							</div>
						</div>
						<script type="text/javascript">createIBSheet("sheet2", "100%", "100%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
		</div>
		<div class="popup_button outer" style="padding-top:0px;">
			<ul>
				<li>
					<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>
