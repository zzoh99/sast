<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html>
<html>
<head>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp" %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script type="text/javascript">
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
		createIBSheet3(document.getElementById('careerPathLayerSheet1-wrap'), "careerPathLayerSheet1", "100%", "100%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('careerPathLayerSheet2-wrap'), "careerPathLayerSheet2", "100%", "100%", "${ssnLocaleCd}");

		const modal = window.top.document.LayerModalUtility.getModal('careerPathLayer');

		searchCareerTargetCd = modal.parameters.searchCareerTargetCd || '';
		showCareerPath = modal.parameters.showCareerPath || true;

		var initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100, AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		IBS_InitSheet(careerPathLayerSheet1, initdata);
		careerPathLayerSheet1.SetVisible(true);
		careerPathLayerSheet1.SetCountPosition(4);

		initdata = {};
		initdata.Cfg = {FronzenCol:0, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly, Page:100, AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		IBS_InitSheet(careerPathLayerSheet2, initdata);
		careerPathLayerSheet2.SetVisible(true);
		careerPathLayerSheet2.SetCountPosition(4);
		careerPathLayerSheet2.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		careerPathLayerSheet2.SetDataLinkMouse("detail1", 1);

		loadEvent();

		var sheetHeight = $(".modal_body").height() - ($(".sheet_title").height()) - 2;
		careerPathLayerSheet1.SetSheetHeight(sheetHeight);
		careerPathLayerSheet2.SetSheetHeight(sheetHeight);

		doAction1("Search");
	});

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
				careerPathLayerSheet1.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getCareerPathPopupList", params);
				break;
		}
	}

	function doAction2(sAction){
		switch (sAction) {
			case "Search":
				var row = careerPathLayerSheet1.GetSelectRow();
				var careerTargetCd = careerPathLayerSheet1.GetCellValue(row, "careerTargetCd");
				var params = "searchCareerTargetCd=" + careerTargetCd;
				careerPathLayerSheet2.DoSearch( "${ctx}/SelfReportRegist.do?cmd=getCareerPathPopupDetailList", params);
				break;
		}
	}

	function careerPathLayerSheet1_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") 
				alert(msg);

			if (careerPathLayerSheet1.RowCount() > 0) {
				careerPathLayerSheet1.SetSelectRow(careerPathLayerSheet1.HeaderRows());
				doAction2("Search");
			}
			
			// sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function careerPathLayerSheet1_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			if ( careerPathLayerSheet1.ColSaveName(col) == "colName") {
				//TODO something
				return;
			}

			doAction2("Search");

		} catch(ex) {
			alert("OnClick Event Error : " + ex);
		}
	}


	function careerPathLayerSheet1_OnDblClick(Row, Col){
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

	function careerPathLayerSheet2_OnSearchEnd(code, msg, stCode, stMsg){
		try{
			if (msg !="") 
				alert(msg);

			// sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function careerPathLayerSheet2_OnClick(row, col, value, cellX, cellY, cellW, cellH){
		try{
			if( ( row > 0 ) &&
				(careerPathLayerSheet2.ColSaveName(col) == "detail1")){
				var searchJobCd = "";

				searchJobCd = careerPathLayerSheet2.GetCellValue(row, "jobCd");
				
				if ( searchJobCd == "" )
					return;
				
				workAssignPopup(searchJobCd);
			}
			if ( careerPathLayerSheet2.ColSaveName(col) == "colName") {
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

			gPRow = "";
			pGubun = "searchWorkAssignPopup";
			// openPopup("${ctx}/SelfReportRegist.do?cmd=viewWorkAssignListPopup", args, "800","700");

			let w = 800;
			let h = 700;
			let url = "/SelfReportRegist.do?cmd=viewWorkAssignListLayer";
			let p = {
				searchJobCd : jobCd
			};

			const workAssignListLayer = new window.top.document.LayerModal({
				id : 'workAssignListLayer'
				, url : url
				, parameters : p
				, width : w
				, height : h
				, title : '<tit:txt mid='payDayPop' mdef='직무별단위업무'/>'
				, trigger :[
					{
						name : 'workAssignListLayerTrigger'
						, callback : function(result){
						}
					}
				]
			});
			workAssignListLayer.show();

		} catch(ex) { alert("Open Popup Event Error : " + ex); }
	}
	
	function returnCareerPath(Row,Col){
		let p = {
			enterCd            : careerPathLayerSheet1.GetCellValue(Row, "enterCd"           ),
			careerTargetCd     : careerPathLayerSheet1.GetCellValue(Row, "careerTargetCd"    ),
			careerTargetNm     : careerPathLayerSheet1.GetCellValue(Row, "careerTargetNm"    ),
			careerTargetType   : careerPathLayerSheet1.GetCellValue(Row, "careerTargetType"  ),
			careerTargetTypeNm : careerPathLayerSheet1.GetCellValue(Row, "careerTargetTypeNm"),
			careerTargetDesc   : careerPathLayerSheet1.GetCellValue(Row, "careerTargetDesc"  ),
			startYmd           : careerPathLayerSheet1.GetCellValue(Row, "startYmd"          ),
			endYmd             : careerPathLayerSheet1.GetCellValue(Row, "endYmd"            )
		}

		const modal = window.top.document.LayerModalUtility.getModal('careerPathLayer');

		modal.fire('careerPathLayerTrigger', p).hide();
	}
</script>
</head>
<body class="hidden">
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<colgroup>
					<col width="30%" />
					<col width="2%" />
					<col width="68%" />
				</colgroup>
				<tr>
					<td>
						<form id="careerPathLayerSheet1Form" name="careerPathLayerSheet1Form"></form>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt1" class="txt"><tit:txt mid='2020021200001' mdef='경력목표'/></li>
									<li class="btn">

									</li>
								</ul>
							</div>
						</div>
						<div id="careerPathLayerSheet1-wrap"></div>
<%--						<script type="text/javascript">createIBSheet("careerPathLayerSheet1", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
					</td>
					<td>

					</td>
					<td>
						<form id="careerPathLayerSheet2Form" name="careerPathLayerSheet2Form"></form>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt2" class="txt"><tit:txt mid='2020021200002' mdef='직무'/></li>
									<li class="btn">

									</li>
								</ul>
							</div>
						</div>
						<div id="careerPathLayerSheet2-wrap"></div>
<%--						<script type="text/javascript">createIBSheet("careerPathLayerSheet2", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
					</td>
				</tr>
			</table>
		</div>
		<div class="modal_footer" style="padding-top:0px;">
			<btn:a href="javascript:closeCommonLayer('careerPathLayer');" css="gray large" mid='110881' mdef="닫기"/>
		</div>
	</div>

</body>
</html>
