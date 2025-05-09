<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var applCd		= null;
var ymdCd 		= null;
var TypeCd	= null;
var reasonCd 	= null;
	$(function() {
		applCd		= convCode( ajaxCall("${ctx}/TimeOffStdMgr.do?cmd=getTimeOffStdMgrApplCodeList","",false).DATA, "전체");
		ymdCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getComCodeNoteList&searchGrcodeCd=S10050&searchNote1=1",false).codeList, "전체");	//일반테이블		
		TypeCd 		= convCode( ajaxCall("${ctx}/TimeOffStdMgr.do?cmd=getTimeOffStdMgrTypeCodeList","ordType=20,30",false).DATA, "");
		reasonCd 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H40110"), "");
		
		
		$("#applCdi").html(applCd[2]);
		
		var initdata = {};
		initdata.Cfg = {FrozenCol:5, SearchMode:smLazyLoad,MergeSheet:msHeaderOnly,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDeleteV1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatusV1' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='applCd_V6968' mdef='휴복직명|휴복직명'/>",				Type:"Combo",		Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"applCd",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sdate_V3644' mdef='시작일|시작일'/>",					Type:"Date",		Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='edate_V5135' mdef='종료일|종료일'/>",					Type:"Date",		Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100	},
			{Header:"<sht:txt mid='limitTerm' mdef='년간최대신청기간(일)|년간최대신청기간(일)'/>",	Type:"Int",			Hidden:0,	Width:70,		Align:"Center",	ColMerge:0,	SaveName:"limitTerm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='limitUnit' mdef='단위|단위'/>",							Type:"Combo",		Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"limitUnit",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ordTypeCd_V2480' mdef='발령처리|발령형태'/>",			Type:"Combo",		Hidden:0,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"ordTypeCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ordDetailCd' mdef='발령처리|발령상세'/>",							Type:"Combo",		Hidden:0,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"ordDetailCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='applCd2' mdef='휴복직코드|휴복직코드'/>",				Type:"Text",		Hidden:1,	Width:70,		Align:"Center", ColMerge:0,	SaveName:"applCd2",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);
		
		sheet1.SetColProperty("applCd", 	{ComboText:applCd[0], 	ComboCode:applCd[1]} );
		sheet1.SetColProperty("limitUnit", 	{ComboText:ymdCd[0], 	ComboCode:ymdCd[1]} );
		sheet1.SetColProperty("ordTypeCd", 	{ComboText:TypeCd[0], 	ComboCode:TypeCd[1]} );
		//sheet1.SetColProperty("ordReasonCd",{ComboText:reasonCd[0], ComboCode:reasonCd[1]} );
		
		$(window).smartresize(sheetResize); 
		sheetInit();
		doAction1("Search");
		$("#researchNm").bind("keyup",function(e){
			if(e.keyCode==13)doAction1("Search");
		});
		$("#applCdi").change(function(){
			doAction1("Search");
		});
	});
	
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":		sheet1.DoSearch( "${ctx}/TimeOffStdMgr.do?cmd=getTimeOffStdMgrList", $("#sheetForm").serialize() ); break;
		case "Save": 		
			if(sheet1.FindStatusRow("I|U") != ""){ 
			    if(!dupChk(sheet1,"applCd|sdate", true, true)){break;}
			}
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave("${ctx}/TimeOffStdMgr.do?cmd=saveTimeOffStdMgr", $("#sheetForm").serialize() );  break;
		case "Copy":      	sheet1.DataCopy();	break;
		case "Insert":
			var newRow = sheet1.DataInsert(0); 
			sheet1.SetCellValue(newRow, "ordTypeCd", "");
			sheet1.SelectCell(newRow, 2);
			break;
		case "Down2Excel":	sheet1.Down2Excel({Merge:1}); break;
		}
	}
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); } 
			
			for(var i = sheet1.HeaderRows(); i<sheet1.RowCount()+sheet1.HeaderRows(); i++){
				if(sheet1.GetCellValue(i, "ordTypeCd") !=""){
					var lOrdReasonCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd="+ sheet1.GetCellValue(i, "ordTypeCd"),false).codeList, " ");	//발령상세종류
	
					sheet1.InitCellProperty(i,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
				}
			}
			
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	// 셀 값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "ordTypeCd" ) {
				var lOrdReasonCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&ordTypeCd="+ sheet1.GetCellValue(Row, "ordTypeCd"),false).codeList, " ");	//발령상세종류

				sheet1.InitCellProperty(Row,"ordDetailCd", {Type:"Combo", ComboCode:"|"+lOrdReasonCd[1], ComboText:"|"+lOrdReasonCd[0]});
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm">
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th><tit:txt mid='113625' mdef='휴복직명'/></th>
					<td>	
						<select id="applCdi" name="applCdi">
						</select>
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
							<li class="txt"><tit:txt mid='112894' mdef='휴직기준관리 '/></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<btn:a href="javascript:doAction1('Copy')" css="btn outline-gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" css="btn filled authA" mid='save' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
