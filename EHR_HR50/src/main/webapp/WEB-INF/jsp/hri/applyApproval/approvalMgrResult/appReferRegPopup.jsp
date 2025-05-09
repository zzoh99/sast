<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='appReferReg' mdef='수신참조자 변경'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var applList 	= null;
var referOriList= null;
var referNewList= null;
var applCdList 	= null;
var parentSabun = null;
var referOriStr	= null;
var referNewStr	= null;
var da 			= null;
var p = eval("${popUpStatus}");
	$(function() {
		//da = dialogArguments;
		da = p.popDialogArgumentAll();
		if(da) da = p.opener;

		var rt = da.getApplHtmlToPaser();
		applList 	= rt[1];

		referOriList= rt[2];
		referOriStr = rt[5];

		parentSabun = rt[7];

		$("#applSeq").val(rt[11]);
		$("#inSabun").val(rt[12]);
		$("#inOrgNm").val(rt[13]);
		$("#inJikchakNm").val(rt[14]);
		$("#inJikweeNm").val(rt[15]);
		$("#agreeSeq").val(rt[16]);

	    applCdList 	= convCodeIdx( ajaxCall("${ctx}/ApprovalMgr.do?cmd=getR10052CodeList","",false).DATA, "",-1);

	    var initdata = {};
	    //###########################조직도
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:0,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
	       	{Header:"<sht:txt mid='orgChartNmV1' mdef='조직도명'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgChartNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='priorOrgCdV1' mdef='상위조직코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgNmV6' mdef='조직도'/>",		Type:"Text",	Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,    TreeCol:1 },
			{Header:"<sht:txt mid='grpIdV1' mdef='조직코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable(false);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		//###########################결재자
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:"CheckBox", 	Hidden:0,  Width:30,	Align:"Center",  ColMerge:0,   SaveName:"chkbox", 		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",      	Hidden:0,  Width:40,  	Align:"Center",  ColMerge:0,   SaveName:"name",  		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='departmentV1' mdef='부서'/>",		Type:"Text",     	Hidden:0,  Width:120,   Align:"Center",  ColMerge:0,   SaveName:"orgNm",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",  		Hidden:1,  Width:120,   Align:"Center",  ColMerge:0,   SaveName:"orgCd",     	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",      	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",      	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text", 		Hidden:1,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",  		Hidden:1,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			]; IBS_InitSheet(sheet3, initdata); sheet3.SetEditable(true);sheet3.SetCountPosition(4);sheet3.SetVisible(true);
		//###########################수신참조내역
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:5, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",  	Hidden:1,   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}", 	Hidden:0,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
	       	{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",	Type:"Text",     	Hidden:0,  Width:40,   	Align:"Center",  ColMerge:0,   SaveName:"name",		KeyField:0,   CalcLogic:"",   Format:"", 	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",	Type:"Text",      	Hidden:0,  Width:80,   	Align:"Center",  ColMerge:0,   SaveName:"ccSabun", 	KeyField:1,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",	Type:"Text",      	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",	Type:"Text",      	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text", 	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikchakCd",KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",   	Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"jikweeCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgNmV9' mdef='부서명'/>",	Type:"Text",   	Hidden:0,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgNm",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='orgCdV8' mdef='부서코드'/>",	Type:"Text",    Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"orgCd",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='addYn' mdef='추가여부'/>",	Type:"Text",    Hidden:1,  Width:50,  	Align:"Center",  ColMerge:0,   SaveName:"addYn",	KeyField:0,   CalcLogic:"",   Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

		]; IBS_InitSheet(sheet5, initdata); sheet5.SetEditable(true);sheet5.SetVisible(true);

		$(window).smartresize(sheetResize); sheetInit();

		$("input[name=radio]").change(function() {
	    	var radioValue = $(this).val();
	    	if( radioValue == "Y" ) {
	    		$("#orgMain").addClass("hide");
	    		$("#listMain").removeClass("w25p");
	    		$("#listMain").addClass("w50p");
	    		$("#name").attr("disabled",false);
	    		$("#orgNm").attr("disabled",false);
	    		$("#btnOrg").attr("disabled",false);
	    	}
	    	else {
	    		$("#orgMain").removeClass("hide");
	    		$("#listMain").removeClass("w50p");
	    		$("#listMain").addClass("w25p");
	    		$("#name").val("").attr("disabled",true);
	    		$("#orgNm").val("").attr("disabled",true);
	    		$("#btnOrg").attr("disabled",true);
	    	}
	    	sheetResize();
	    });

		$("#name, #orgNm").bind("keyup",function(event){
			if( event.keyCode == 13){orgList(); $(this).focus(); }
		});
		$(".close").click(function() { p.self.close(); });

// 		$("#sabun").val("${ssnSabun}");
// 		$("#sabun").val("P10062");
		$("#sabun").val(parentSabun);
		doAction2("Search");
		doAction3("Search");
		doAction5("Search");
		$("#sabun").val("");
	});

    function doAction2(sAction) {
		switch (sAction) { case "Search":  sheet2.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathOrgList", $("#sheetForm").serialize()); break; }
    }
	function doAction3(sAction) {
		switch (sAction) { case "Search":  sheet3.DoSearch( "${ctx}/AppPathReg.do?cmd=getAppPathRegOrgUserList", $("#sheetForm").serialize()); break; }
	}
    function doAction5(sAction) {
		switch (sAction) {
		case "Search":
// 			sheet5.DoSearch( "${ctx}/GetDataList.do?cmd=getAppPathRegReferList", $("#sheetForm").serialize()); break;
			var Row 	= "";
			var RowData = null;
			if(referOriStr == "") break;
			for(var i=0; i<referOriList.length; i++){
				Row 	= sheet5.DataInsert(sheet5.LastRow()+1);
				RowData = referOriList[i].split(",");
				sheet5.SetCellValue(Row,"name", 		RowData[2]);
				sheet5.SetCellValue(Row,"ccSabun",		RowData[3]);
				sheet5.SetCellValue(Row,"jikchakNm",	RowData[7]);
				sheet5.SetCellValue(Row,"jikchakCd",	RowData[6]);
				sheet5.SetCellValue(Row,"jikweeNm",		RowData[5]);
				sheet5.SetCellValue(Row,"jikweeCd",		RowData[4]);
				sheet5.SetCellValue(Row,"orgNm",		RowData[0]);
				sheet5.SetCellValue(Row,"orgCd",		RowData[1]);
				sheet5.SetCellValue(Row,"addYn",		"N");
				sheet5.SetCellValue(Row,"sStatus",		"");
				sheet5.SetRowEditable(Row, 0);
			}
// 			if(referNewStr == "") break;
// 			for(var i=0; i<referNewList.length; i++){
// 				Row 	= sheet5.DataInsert(sheet5.LastRow()+1);
// 				RowData = referNewList[i].split(",");
// 				sheet5.SetCellValue(Row,"name", 		RowData[2]);
// 				sheet5.SetCellValue(Row,"ccSabun",		RowData[3]);
// 				sheet5.SetCellValue(Row,"jikchakNm",	RowData[7]);
// 				sheet5.SetCellValue(Row,"jikchakCd",	RowData[6]);
// 				sheet5.SetCellValue(Row,"jikweeNm",		RowData[5]);
// 				sheet5.SetCellValue(Row,"jikweeCd",		RowData[4]);
// 				sheet5.SetCellValue(Row,"orgNm",		RowData[0]);
// 				sheet5.SetCellValue(Row,"orgCd",		RowData[1]);
// 				sheet5.SetCellValue(Row,"addYn",		"Y");
// 				sheet5.SetRowBackColor(Row,"#6FD0FF");
// 			}
			break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet5);
			sheet5.DoSave("${ctx}/ApprovalMgrResult.do?cmd=insertApprovalMgrResultReferAddUser", $("#sheetForm").serialize() );
			break;
		}
    }

	function sheet5_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg);
			returnChgList();
		} catch (ex) { alert("OnSaveEnd Event Error : " + ex); }
	}

	function sheet2_OnClick(Row, Col, Value) {
		try{
			if(Row > 0) {
				$("#orgCd").val(sheet2.GetCellValue(Row,"orgCd"));
				$("#name").val("");
				$("#orgNm").val("");
				doAction3("Search");
			}
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	function toggleSheet() {
		if( $("#toggleBtn").text() == "접기" ) hideSheet();
		else showSheet();
	}
	function mvRefer(){
		var chkRow = sheet3.FindCheckedRow("chkbox");
		if(chkRow == ""){ alert("<msg:txt mid='110029' mdef='참조자를 선택 하세요!'/>");return; }
		var chkArry = chkRow.split("|");

		var chkdupTxt = "";
		var dupText  = "";
		var cnt = 1;
		for(var i=0; i<chkArry.length; i++){
			chkdupTxt = sheet5.FindText("ccSabun",sheet3.GetCellValue(chkArry[i],"sabun"));
			if(chkdupTxt == -1){
				var Row = sheet5.DataInsert(sheet5.LastRow()+1); sheet5.SelectCell(Row, 2);
				sheet5.SetCellValue(Row,"name",		sheet3.GetCellValue(chkArry[i],"name") );
				sheet5.SetCellValue(Row,"ccSabun",	sheet3.GetCellValue(chkArry[i],"sabun") );
				sheet5.SetCellValue(Row,"orgCd",	sheet3.GetCellValue(chkArry[i],"orgCd") );
				sheet5.SetCellValue(Row,"orgNm",	sheet3.GetCellValue(chkArry[i],"orgNm") );
				sheet5.SetCellValue(Row,"jikchakNm",sheet3.GetCellValue(chkArry[i],"jikchakNm") );
				sheet5.SetCellValue(Row,"jikweeNm",	sheet3.GetCellValue(chkArry[i],"jikweeNm") );
				sheet5.SetCellValue(Row,"jikchakCd",sheet3.GetCellValue(chkArry[i],"jikchakCd") );
				sheet5.SetCellValue(Row,"jikweeCd",	sheet3.GetCellValue(chkArry[i],"jikweeCd") );
				sheet5.SetCellValue(Row,"addYn",	"Y");
				sheet5.SetRowBackColor(Row,"#6FD0FF");
			}else{
				dupText+= cnt+"."+sheet3.GetCellValue(chkArry[i],"sabun")+"\n";
				cnt++;
			}
		}
		sheet3.CheckAll("chkbox", 0);
// 		if(dupText != "") alert("중복된 사번 제외 복사\n"+dupText);

		if(dupText != "") alert("<msg:txt mid='alertExistsEmpIdV1' mdef='중복된 사번이 존재 합니다.'/>");
	}

	function orgList(){
		 if( $(".radio:checked").val()=="Y"){
			 $("#orgCd").val("");
			 doAction3("Search");
		 }
	}
	function returnChgList(){
		if(da.chReferPopupRetrunPrc(sheet5)){
			//alert("TRUE");
		}
		p.window.close();
	}
</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='appReferReg' mdef='수신참조자 변경'/></li>
		<li class="close"></li>
	</ul>
	</div>
	<div class="popup_main">
		<div class="outer">
		</div>

		<div id="gap" class="h15 outer"></div>

		<div class="sheet_search outer">
			<form id="sheetForm" name="sheetForm">
				<input id="orgCd" 		name="orgCd" 		type="hidden" />
				<input id="sabun" 		name="sabun"		type="hidden" />
				<input id="applSeq" 	name="applSeq"		type="hidden" />
				<input id="agreeSeq" 	name="agreeSeq"		type="hidden" />
				<input id="inSabun" 	name="inSabun"		type="hidden" />
				<input id="inOrgNm" 	name="inOrgNm"		type="hidden" />
				<input id="inJikchakNm" name="inJikchakNm"	type="hidden" />
				<input id="inJikweeNm" 	name="inJikweeNm"	type="hidden" />
				<div>
				<table>
				<tr>
					<th><tit:txt mid='103880' mdef='성명'/></th>
					<td>
						<input id="name" name="name" type="text" class="text" />
					</td>
					<th><tit:txt mid='104279' mdef='소속'/></th>
					<td>
						<input id="orgNm" name="orgNm" type="text" class="text" />
					</td>
					<td>
						<input id="radio" name="radio" type="radio" class="radio" value="Y" checked/> 리스트
						<input id="radio" name="radio" type="radio" class="radio" value="N"/> 조직도
					</td>
					<td id="btnOrg"  class="">
						<a href="javascript:orgList();" class="button"><tit:txt mid='104081' mdef='조회'/></a>
					</td>
				</tr>
				</table>
				</div>
			</form>
		</div>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td id="orgMain" class="sheet_left w25p hide">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='orgSchemeMgr' mdef='조직도'/></li>
						<li class="btn">
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "25%", "100%"); </script>
			</td>
			<td id="listMain" class="sheet_left w50p">
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='schAppSabun' mdef='결재자 검색'/></li>
						<li class="btn">
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet3", "25%", "100%"); </script>
			</td>
			<td class="sheet_arrow"></td>
			<td class="sheet_right w50p">

				<div class="sheet_button2">
					<div class="arrow_button">
						<a href="javascript:mvRefer();"	class="pink"><tit:txt mid='114241' mdef='참조&gt;'/></a>
					</div>
					<div class="inner">
						<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='schRefDetail' mdef='참조 내역'/></li>
							<li class="btn">
							</li>
						</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet5", "50%", "100%"); </script>
				</div>

			</td>
		</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:doAction5('Save');" class="pink large"><tit:txt mid='104476' mdef='저장'/></a>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
