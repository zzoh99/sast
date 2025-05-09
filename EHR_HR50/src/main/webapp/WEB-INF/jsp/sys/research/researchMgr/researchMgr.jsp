<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var stateCd = null;
var qType = null;
var sRow2 = null;
var gPRow = "";
var pGubun = "";

	$(function() {
		stateCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H60270"), "");
		qType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H60280"), "");

		var initdata = {};
		initdata.Cfg = {FrozenCol:4, SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",      Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",    Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",    Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='temp2' mdef='세부\r\n내역'/>",	Type:"Image",		Hidden:0,	Width:40,		Align:"Center",	ColMerge:0,	SaveName:"detail",			Sort:0, Cursor:"Pointer" },
			{Header:"<sht:txt mid='researchSeq' mdef='설문지순번'/>",	Type:"Text",		Hidden:1,	Width:0,		Align:"Center",	ColMerge:0,	SaveName:"researchSeq",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='noticeLvl' mdef='조사레벨'/>",		Type:"Combo",		Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"noticeLvl",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='researchNm_V1' mdef='설문지'/>",		Type:"Text",		Hidden:0,	Width:150,		Align:"Left",	ColMerge:0,	SaveName:"researchNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"<sht:txt mid='memoV6' mdef='설명'/>",			Type:"Image",		Hidden:0,	Width:0,		Align:"Center",	ColMerge:0,	SaveName:"desc",			Sort:0, Cursor:"Pointer" },
			{Header:"<sht:txt mid='memoV4' mdef='메모'/>",			Type:"Text",		Hidden:1,	Width:0,		Align:"Center",	ColMerge:0,	SaveName:"memo",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='researchSymd' mdef='설문시작일'/>",	Type:"Date",		Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"researchSymd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, EndDateCol:"researchEymd" },
			{Header:"<sht:txt mid='researchEymd' mdef='설문종료일'/>",	Type:"Date",		Hidden:0,	Width:90,		Align:"Center", ColMerge:0,	SaveName:"researchEymd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, StartDateCol:"researchSymd" },
			{Header:"<sht:txt mid='applStatusCdNmV1' mdef='진행상태'/>",		Type:"Combo",		Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"stateCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='signYn_V1618' mdef='기명여부'/>",		Type:"Combo",		Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"signYn",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='openYn' mdef='공개여부'/>",		Type:"Combo",		Hidden:0,	Width:60,		Align:"Center", ColMerge:0,	SaveName:"openYn",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='seqNo' mdef='파일순번'/>",		Type:"Text",		Hidden:1,	Width:30,		Align:"Center", ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);
		sheet1.SetColProperty("noticeLvl", {ComboText:"선택형|소속(소속)|직급|직책|직위", ComboCode:"ALL|ORG|H20010|H20020|H20030"} );
		sheet1.SetColProperty("stateCd", 	{ComboText:stateCd[0], 		ComboCode:stateCd[1]} );
		sheet1.SetColProperty("signYn", 	{ComboText:"기명|무기명", 	ComboCode:"Y|N"} );
		sheet1.SetColProperty("openYn", 	{ComboText:"공개|비공개", 	ComboCode:"Y|N"} );
		sheet1.SetImageList(1,"/common/images/icon/icon_popup.png");

		initdata = {};
		initdata.Cfg = {FrozenCol:4, SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",      Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",    Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",    Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='researchSeq' mdef='설문지순번'/>",	Type:"Text",		Hidden:1,	Width:0,		Align:"Left",	ColMerge:0,	SaveName:"researchSeq",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"<sht:txt mid='questionSeq' mdef='질문순번'/>",		Type:"Text",		Hidden:1,	Width:0,		Align:"Left",	ColMerge:0,	SaveName:"questionSeq",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"<sht:txt mid='questionNo' mdef='질문번호'/>",		Type:"Int",			Hidden:0,	Width:40,		Align:"Center",	ColMerge:0,	SaveName:"questionNo",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='questionNm_V1' mdef='질문'/>",			Type:"Text",		Hidden:0,	Width:150,		Align:"Center",	ColMerge:0,	SaveName:"questionNm",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='itemNm_V2' mdef='질문유형'/>",		Type:"Combo",		Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"questionItemCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='detail_V3274' mdef='선택지설정'/>",	Type:"Image",		Hidden:0,	Width:50,		Align:"Center",	ColMerge:0,	SaveName:"detail",			Sort:0, Cursor:"Pointer" }
		];IBS_InitSheet(sheet2, initdata);sheet2.SetCountPosition(4);
		sheet2.SetColProperty("questionItemCd", {ComboText:qType[0], ComboCode:qType[1]} );
		sheet2.SetImageList(1,"/common/images/icon/icon_o.png");
		sheet2.SetImageList(2,"/common/images/icon/icon_x.png");
		$(window).smartresize(sheetResize);
		sheetInit();
		doAction1("Search");
		$("#researchNm").bind("keyup",function(e){
			if(e.keyCode==13)doAction1("Search");
		});
	});

function chkInVal() {
	// 시작일자와 종료일자 체크
	var rowCnt = sheet1.RowCount();
	for (var i=1; i<=rowCnt; i++) {
		if (sheet1.GetCellValue(i, "sStatus") == "I" || sheet1.GetCellValue(i, "sStatus") == "U") {
			if (sheet1.GetCellValue(i, "researchEymd") != null && sheet1.GetCellValue(i, "researchEymd") != "") {
				var sdate = sheet1.GetCellValue(i, "researchSymd");
				var edate = sheet1.GetCellValue(i, "researchEymd");
				if (parseInt(sdate) > parseInt(edate)) {
					alert("설문 시작일자가 종료일자보다 큽니다.");
					sheet1.SelectCell(i, "researchEymd");
					return false;
				}
			}
		}
	}

	return true;
}

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":	sheet1.DoSearch( "${ctx}/ResearchMgr.do?cmd=getResearchMgrList", $("#sheetForm").serialize() ); break;
		case "Save":
			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/ResearchMgr.do?cmd=saveResearchMgr", $("#sheetForm").serialize() );  break;
		case "Insert":  sheet1.SelectCell(sheet1.DataInsert(0), 2); break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			$("#rsSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"researchSeq"));
			sheet2.DoSearch( "${ctx}/ResearchMgr.do?cmd=getResearchMgrDetailList", $("#sheetForm").serialize());
			break;
		case "Save":
// 			if(sheet2.FindStatusRow("I|U") != ""){
// 			    if(!dupChk(sheet2,"questionSeq", true, true)){break;}
// 			}
			$("#rsSeq").val(sheet1.GetCellValue(sheet1.GetSelectRow(),"researchSeq"));
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave("${ctx}/ResearchMgr.do?cmd=saveResearchMgrDetail", $("#sheetForm").serialize() );
            break;
		case "Insert":
			var iRow = sheet2.DataInsert(sheet2.LastRow()+1);
			sheet2.SetCellImage(iRow,"detail",1);
			sheet2.SetCellValue(iRow, "researchSeq",sheet1.GetCellValue(sheet1.GetSelectRow(),"researchSeq"));
			sheet2.SelectCell(iRow, 'questionNo');
			break;
		case "Copy":
			var cRow = sheet2.DataCopy();
			sheet2.SetCellValue(cRow, "questionSeq","");
			break;

		}
	}

	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} doAction1("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} if( Number(Code) > 0){doAction2("Search");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	function sheet1_OnClick(Row, Col, Value){
		try{
			if(Row < 1) return;

			if(sheet1.ColSaveName(Col) == "detail"){
				if(sheet1.GetCellValue(Row,"sStatus")=="I"){
					alert("<msg:txt mid='109799' mdef='해당 설문지를 먼저 자장하여 주십시오.'/>");
					return;
				}
				researchMgrDetailPopup(Row);
			}else if(sheet1.ColSaveName(Col) == "desc"){
				researchMgrDescPopup(Row);
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	function sheet2_OnClick(Row, Col, Value){
		try{
			if(Row < 1) return;

			if(sheet2.ColSaveName(Col) == "detail"){
				if(sheet2.GetCellValue(Row,"sStatus")=="I"){
					alert("<msg:txt mid='110101' mdef='입력상태에서는 선택지 설정을 할 수 없습니다.n저장후 선택지 설저을 해 주세요.'/>");
					return;
				}
				if(sheet2.GetCellValue(Row,"questionItemCd")=="30"){
					alert("<msg:txt mid='109952' mdef='서술형은 선택지 설정을 할수 없습니다.'/>");
					return;
				}
				researchMgrDetailTypePopup(Row);
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	function sheet2_OnChange(Row, Col, Value){
		try{
			if(Row < 1) return;
			if( sheet2.ColSaveName(Col) != "questionItemCd") return;
			if(Value == "30") sheet2.SetCellImage(Row,"detail",2);
			else sheet2.SetCellImage(Row,"detail",1);
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		sRow2 = NewRow;
		if(OldRow != NewRow)doAction2("Search");

	}

	function researchMgrDetailPopup(Row){
		if(!isPopup()) {return;}
  		var w 		= 940;
		var h 		= 780;
		var url 	= "${ctx}/ResearchMgr.do?cmd=researchMgrDetailLayer&authPg=${authPg}";

		var p = {
			researchSymd :  sheet1.GetCellValue(Row,"researchSymd"),
			researchEymd :  sheet1.GetCellValue(Row,"researchEymd"),
			noticeLvl :  sheet1.GetCellValue(Row,"noticeLvl"),
			signYn :  sheet1.GetCellValue(Row,"signYn"),
			openYn :  sheet1.GetCellValue(Row,"openYn"),
			stateCd :  sheet1.GetCellValue(Row,"stateCd"),
			researchNm :  sheet1.GetCellValue(Row,"researchNm"),
			memo :  sheet1.GetCellValue(Row,"memo"),
			researchSeq :  sheet1.GetCellValue(Row,"researchSeq"),
			fileSeq :  sheet1.GetCellValue(Row,"fileSeq"),
			comboStateCd :  stateCd[2]
		};

		gPRow = Row;
		pGubun = "researchMgrDetailPopup";
		// openPopup(url,args,w,h);

		var researchMgrDetailLayer = new window.top.document.LayerModal({
			id: 'researchMgrDetailLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: '설문조사 세부내역',
			trigger: [
				{
					name: 'researchMgrDetailLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});

		researchMgrDetailLayer.show();
	}
	function researchMgrDescPopup(Row){
		if(!isPopup()) {return;}
  		var w 		= 600;
		var h 		= 350;
		var url 	= "${ctx}/ResearchMgr.do?cmd=researchMgrDescLayer&authPg=${authPg}";
		var p = {
			memo : sheet1.GetCellValue(Row,"memo")
		};

		gPRow = Row;
		pGubun = "researchMgrDescPopup";
		// openPopup(url,args,w,h);

		var researchMgrDescLayer = new window.top.document.LayerModal({
			id: 'researchMgrDescLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: '설문조사 설명',
			trigger: [
				{
					name: 'researchMgrDescLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});

		researchMgrDescLayer.show();
	}
	function researchMgrDetailTypePopup(Row){
		if(!isPopup()) {return;}
  		var w 		= 940;
		var h 		= 500;
		var url 	= "${ctx}/ResearchMgr.do?cmd=researchMgrDetailTypeLayer&authPg=${authPg}";

		var p = {
			researchSeq : sheet2.GetCellValue(Row,"researchSeq"),
			questionSeq : sheet2.GetCellValue(Row,"questionSeq")
		};
		gPRow = Row;
		pGubun = "researchMgrDetailTypePopup";
		// openPopup(url,args,w,h);

		var researchMgrDetailTypeLayer = new window.top.document.LayerModal({
			id: 'researchMgrDetailTypeLayer',
			url: url,
			parameters: p,
			width: w,
			height: h,
			title: '질문선택지 설정',
			trigger: [
				{
					name: 'researchMgrDetailTypeLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});

		researchMgrDetailTypeLayer.show();
	}

	//팝업 콜백 함수.
	function getReturnValue(rv) {
        if(pGubun == "researchMgrDetailPopup"){
        	sheet1.SetCellValue(gPRow, "researchSymd", rv.researchSymd);
        	sheet1.SetCellValue(gPRow, "researchEymd", rv.researchEymd);
        	sheet1.SetCellValue(gPRow, "noticeLvl", rv.noticeLvl);
        	sheet1.SetCellValue(gPRow, "signYn", rv.signYn);
        	sheet1.SetCellValue(gPRow, "openYn", rv.openYn);
        	sheet1.SetCellValue(gPRow, "stateCd", rv.stateCd);
        	sheet1.SetCellValue(gPRow, "researchNm", rv.researchNm);
        	sheet1.SetCellValue(gPRow, "memo", rv.memo);
        } else if(pGubun == "researchMgrDescPopup") {
        	sheet1.SetCellValue(gPRow, "memo", rv.memo);
        } else if(pGubun == "researchMgrDetailTypePopup") {
        }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<input id="rsSeq" name="rsSeq" type="hidden" />
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th><tit:txt mid='104133' mdef='설문지명'/></th>
					<td>
						<input id="researchNm" name="researchNm" type="text" class="text w200" />
					</td>
					<td>
						<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
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
							<li class="txt"><tit:txt mid='104427' mdef='설문지 '/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" css="btn filled authA" mid='save' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='113290' mdef='설문지 질문'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction2('Copy')" css="btn ouline-gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction2('Insert')" css="btn ouline-gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction2('Save')" css="btn filled authA" mid='save' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
