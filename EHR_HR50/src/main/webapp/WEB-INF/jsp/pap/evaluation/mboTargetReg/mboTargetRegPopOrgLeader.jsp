<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>조직KPI</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>

<script type="text/javascript">
	var authPg	= "";
	var modal = "";
	
	$(function() {
		createIBSheet3(document.getElementById('mysheet-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");

		modal = window.top.document.LayerModalUtility.getModal('mboTargetRegPopOrgLeaderLayer');
		$(".close").click(function() 	{ closeCommonLayer('mboTargetRegPopOrgLeaderLayer'); });

	    if( modal.parameters != undefined ) {
		    $("#searchAppraisalCd", "#mboTargetRegPopOrgLeaderFrm").val(modal.parameters.searchAppraisalCd);
		    $("#searchEvaSabun", "#mboTargetRegPopOrgLeaderFrm").val(modal.parameters.searchEvaSabun);
		    $("#searchAppStepCd", "#mboTargetRegPopOrgLeaderFrm").val(modal.parameters.searchAppStepCd);
		    $("#searchAppOrgCd", "#mboTargetRegPopOrgLeaderFrm").val(modal.parameters.searchAppOrgCd);
		    $("#searchAppStatusCd", "#mboTargetRegPopOrgLeaderFrm").val(modal.parameters.searchAppStatusCd);
		    authPg = modal.parameters.authPg;
		}

		// 190529 IDS 코드 조회
		var mboTypeCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P10009"), ""); // 목표구분(P10009)

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,MergeSheet:msAll,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
//			{Header:"삭제|삭제",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
//			{Header:"상태|상태",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			//{Header:"\n선택|\n선택",								Type:"DummyCheck",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"chk",				KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"평가자|성명",								Type:"Text",		Hidden:0,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"name",			KeyField:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"평가자|직책",								Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"평가자|차수",								Type:"Text",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:0,	UpdateEdit:0,	InsertEdit:1,	},
			{Header:"순서|순서",									Type:"Int",			Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"구분|구분",									Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appIndexGubunCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"구분|구분",									Type:"Text",		Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"appIndexGubunNm",	KeyField:0,	UpdateEdit:0,	InsertEdit:1,	},

			{Header:"목표구분|목표구분",							Type:"Combo",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mboType",			KeyField:0,	UpdateEdit:0,	InsertEdit:1,	ComboText: mboTypeCdList[0], ComboCode: mboTypeCdList[1]},
			{Header:"목표항목|목표항목",							Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"mboTarget",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	MultiLineText:1,	EditLen:1000},
			{Header:"비중(%)|비중(%)",							Type:"AutoSum",	Hidden:0,	Width:60,	Align:"Right",	ColMerge:0,	SaveName:"weight",			KeyField:0,	Format:"",	PointCount:1,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"목표달성을 위한 핵심 요인|목표달성을 위한 핵심 요인",	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"kpiNm",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	MultiLineText:1,	EditLen:1000},
			{Header:"달성목표(정량,최종)|달성목표(정량,최종)",		Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"formula",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	MultiLineText:1,	EditLen:1000},
			{Header:"중점추진 Activity|중점추진 Activity",			Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"remark",			KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	MultiLineText:1,	EditLen:1500},

			{Header:"추진일정|From",								Type:"Date",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"deadlineType",	KeyField:0,	Format:"Ym",	UpdateEdit:0,	InsertEdit:1 },
			{Header:"추진일정|To",								Type:"Date",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"deadlineTypeTo",	KeyField:0,	Format:"Ym",	UpdateEdit:0,	InsertEdit:1 },
			{Header:"측정기준|측정기준",							Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"baselineData",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300},

			{Header:"평가등급기준|S등급",							Type:"Text",	Hidden:1, 	Width:100, 	Align:"Center", ColMerge:0, SaveName:"sGradeBase", KeyField:1, UpdateEdit:0, InsertEdit:0, MultiLineText:1, EditLen:300},
			{Header:"평가등급기준|A등급",							Type:"Text",	Hidden:1, 	Width:100, 	Align:"Center", ColMerge:0, SaveName:"aGradeBase", KeyField:1, UpdateEdit:0, InsertEdit:0, MultiLineText:1, EditLen:300},
			{Header:"평가등급기준|B등급",							Type:"Text",	Hidden:1, 	Width:100, 	Align:"Center", ColMerge:0, SaveName:"bGradeBase", KeyField:1, UpdateEdit:0, InsertEdit:0, MultiLineText:1, EditLen:300},
			{Header:"평가등급기준|C등급",							Type:"Text",	Hidden:1, 	Width:100, 	Align:"Center", ColMerge:0, SaveName:"cGradeBase", KeyField:1, UpdateEdit:0, InsertEdit:0, MultiLineText:1, EditLen:300},
			{Header:"평가등급기준|D등급",							Type:"Text",	Hidden:1, 	Width:100, 	Align:"Center", ColMerge:0, SaveName:"dGradeBase", KeyField:1, UpdateEdit:0, InsertEdit:0, MultiLineText:1, EditLen:300},

			{Header:"평가ID",									Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd"},
			{Header:"평가소속",									Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd"},
			{Header:"사원번호",									Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabun"},
			{Header:"생성구분코드",								Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"mkGubunCd"},
			{Header:"SEQ",										Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq"}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);
		sheet1.SetEditEnterBehavior("newline");
		sheet1.SetMergeSheet(1);

		sheet1.SetAutoSumPosition(1);
		sheet1.SetSumValue("sNo", "합계") ;

		var appIndexGubunCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00011"),""); // 평가지표구분
		sheet1.SetColProperty("appIndexGubunCd", {ComboText: appIndexGubunCdList[0], ComboCode: appIndexGubunCdList[1]} );

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail",1);
		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝행 배경색 동일하게-Edit불가/가능 구분 위해.

		if ($("#searchAppStatusCd", "#mboTargetRegPopOrgLeaderFrm").val() != "11" && $("#searchAppStatusCd", "#mboTargetRegPopOrgLeaderFrm").val()!= "23" && $("#searchAppStatusCd", "#mboTargetRegPopOrgLeaderFrm").val()!= "33" && $("#searchAppStatusCd", "#mboTargetRegPopOrgLeaderFrm").val()!= "43") {
			sheet1.SetEditable(0);
			$("#btnConfrim").hide();
		}

		sheet1.SetAutoRowHeight(1);
		setAppClassCd();

		$(window).smartresize(sheetResize); sheetInit();

		var sheetHeight = $(".modal_body").height() - $("#mboTargetRegPopOrgLeaderFrm").height() - 2;
		sheet1.SetSheetHeight(sheetHeight);

		doAction1("Search");
	});


	function setAppClassCd(){
		/*
		//평가등급기준 -- 평가종류에 따라 다른 등급을 가져옴.
		var saveNameLst = ["sGradeBase", "aGradeBase", "bGradeBase", "cGradeBase", "dGradeBase"];
		var classCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppClassCdList&searchAppraisalCd="+$("#searchAppraisalCd").val(),false).codeList, ""); // 평가등급
		var clsLst = classCdList[0].split("|");

		for( var i=0; i<clsLst.length ; i++){
			sheet1.SetColHidden(saveNameLst[i], 0 );
			sheet1.SetCellValue(1, saveNameLst[i], clsLst[i] );
		}
		var len = clsLst.length;
		if(classCdList[0] == "" ) len = 0;
		for( var i=len; i<saveNameLst.length ; i++){
			sheet1.SetColHidden(saveNameLst[i], 1 );
		}
		*/
	}

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/EvaMain.do?cmd=getMboTargetRegPopOrgLeader", $("#mboTargetRegPopOrgLeaderFrm").serialize() );
			var info = [{StdCol:"appIndexGubunCd", SumCols:"weight", ShowCumulate:0, CaptionCol:3}];
			//sheet1.ShowSubSum (info);
			break;
		case "Clear":
			sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		}


	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet1.ColSaveName(Col) == "detail" ){
				showDetailPopup(Row);
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	function sheet1_OnDblClick(Row, Col){
		selectConfirm();
	}

	function  selectConfirm(){
		const p = {
				orderSeq : sheet1.GetCellValue(sheet1.GetSelectRow(), "orderSeq"),
				appIndexGubunNm : sheet1.GetCellValue(sheet1.GetSelectRow(), "appIndexGubunNm"),
				appIndexGubunCd : sheet1.GetCellValue(sheet1.GetSelectRow(), "appIndexGubunCd"),
				mboTarget : sheet1.GetCellValue(sheet1.GetSelectRow(), "mboTarget"),
				kpiNm : sheet1.GetCellValue(sheet1.GetSelectRow(), "kpiNm"),
				formula : sheet1.GetCellValue(sheet1.GetSelectRow(), "formula"),
				baselineData : sheet1.GetCellValue(sheet1.GetSelectRow(), "baselineData"),
				sGradeBase : sheet1.GetCellValue(sheet1.GetSelectRow(), "sGradeBase"),
				aGradeBase : sheet1.GetCellValue(sheet1.GetSelectRow(), "aGradeBase"),
				bGradeBase : sheet1.GetCellValue(sheet1.GetSelectRow(), "bGradeBase"),
				cGradeBase : sheet1.GetCellValue(sheet1.GetSelectRow(), "cGradeBase"),
				dGradeBase : sheet1.GetCellValue(sheet1.GetSelectRow(), "dGradeBase"),
				weight : sheet1.GetCellValue(sheet1.GetSelectRow(), "weight"),
				remark : sheet1.GetCellValue(sheet1.GetSelectRow(), "remark"),
				seq : sheet1.GetCellValue(sheet1.GetSelectRow(), "seq"),
				mkGubunCd : sheet1.GetCellValue(sheet1.GetSelectRow(), "mkGubunCd"),
				mboType : sheet1.GetCellValue(sheet1.GetSelectRow(), "mboType"),
				mboTypeNm : sheet1.GetCellText(sheet1.GetSelectRow(), "mboType"),
				deadlineType : sheet1.GetCellValue(sheet1.GetSelectRow(), "deadlineType"),
				deadlineTypeTo : sheet1.GetCellValue(sheet1.GetSelectRow(), "deadlineTypeTo"),
				appraisalCd : $("#searchAppraisalCd", "#mboTargetRegPopOrgLeaderFrm").val(),
				sabun : $("#searchEvaSabun", "#mboTargetRegPopOrgLeaderFrm").val(),
				appOrgCd : $("#searchAppOrgCd", "#mboTargetRegPopOrgLeaderFrm").val(),
				detail : "0"
			};

		var modal = window.top.document.LayerModalUtility.getModal('mboTargetRegPopOrgLeaderLayer');
		modal.fire('mboTargetRegPopOrgLeaderTrigger', p).hide();

		/* if( sheet1.CheckedRows("chk") > 0 ){
			var sRow  = sheet1.FindCheckedRow("chk");
			var arrRow = sRow.split("|");

			openerSheet.RenderSheet(0);

			// 기 등록 여부 체크
			for(var k=0; k<arrRow.length; k++){
				isAllowAdd = true;
				for( var j = openerSheet.HeaderRows(); j <= openerSheet.LastRow(); j++) {
					//console.log("Seq Information", "openerSheet : " + openerSheet.GetCellValue(j, "seq") + ", sheet : " + sheet1.GetCellValue(arrRow[k], "seq"));
					if( openerSheet.GetCellValue(j, "seq") == sheet1.GetCellValue(arrRow[k], "seq")) {
						//console.log("Already Exists Seq..");
						isAllowAdd = false;
						break;
					}
				}

				if( !isAllowAdd ) {
					break;
				}
			}

			if(isAllowAdd) {
				for(var k=0; k<arrRow.length; k++){
					var iRow = openerSheet.DataInsert(0);
					for (var i=0; i<paramName.length; i++) {
						//무신사 조직장 KPI 추가시 구분값 변경 및 삽입
						if( paramName[i] == "mkGubunCd" ) {
							openerSheet.SetCellValue(iRow, paramName[i], "C" );
							openerSheet.SetCellValue(iRow, "designateAppSabun", sheet1.GetCellValue(arrRow[k],"sabun"));
						} else {
							openerSheet.SetCellValue(iRow, paramName[i], sheet1.GetCellValue(arrRow[k],paramName[i] ));
						}
						openerSheet.SetCellEditable(iRow, paramName[i], 0);
					}
					openerSheet.SetCellValue(iRow, "appraisalCd", $("#searchAppraisalCd").val());
					openerSheet.SetCellValue(iRow, "sabun", $("#searchEvaSabun").val());
					openerSheet.SetCellValue(iRow, "appOrgCd", $("#searchAppOrgCd").val());
					openerSheet.SetCellValue(iRow, "detail", "0");
				}
			} else {
				alert("이미 추가된 조직 KPI가 있습니다.");
			}

			openerSheet.RenderSheet(1);
		}

		if(isAllowAdd) {
		} */

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="mboTargetRegPopOrgLeaderFrm" name="mboTargetRegPopOrgLeaderFrm" >
		<input id="searchAppraisalCd" name="searchAppraisalCd" type="hidden" />
		<input id="searchEvaSabun" name="searchEvaSabun" type="hidden" />
		<input id="searchAppStepCd" name="searchAppStepCd" type="hidden" />
		<input id="searchAppOrgCd" name="searchAppOrgCd" type="hidden" />
		<input id="searchAppStatusCd" name="searchAppStatusCd" type="hidden" />
		</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div id="mysheet-wrap"></div>
					</td>
				</tr>
			</table>

	</div>
	<div class="modal_footer">
		<%-- <a href="javascript:selectConfirm();" id="btnConfrim" class="btn filled"><tit:txt mid='104435' mdef='확인'/></a> --%>
		<a href="javascript:closeCommonLayer('mboTargetRegPopOrgLeaderLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	</div>
</div>
</body>
</html>