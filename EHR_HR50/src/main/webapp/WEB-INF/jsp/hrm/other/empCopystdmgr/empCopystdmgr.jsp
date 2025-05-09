<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>인사정보복사기준관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = ""; 
var pGubun = "";

var chk = false;

	$(function() {

		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"세부\n내역",			Type:"Image",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			
			{Header:"테이블명",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"tableName",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:30 },
			{Header:"테이블코멘트",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"tableComment",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:300 },
			{Header:"사용여부(Y/N)",	Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"useYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"작업순서",		Type:"Int",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"orderSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		initdata1.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"테이블명",		Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"tableName",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:30 },
			{Header:"컬럼명",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"columnName",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"컬럼코멘트",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"columnComment",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:300 },
			{Header:"사용여부(Y/N)",	Type:"CheckBox",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"useYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
			{Header:"PK여부",			Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"pkYn",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetDataLinkMouse("detail",1);
		
		$(window).smartresize(sheetResize); sheetInit();
		
		chk = true;
		doAction1("Search");

		$("#searchTableName").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if(!checkList()) return ;
						$("#searchTableNameHidden").val("");
						sheet1.RemoveAll();
						sheet2.RemoveAll();
						sheet1.DoSearch( "${ctx}/EmpCopystdmgr.do?cmd=getEmpCopystdmgrLeftList", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!dupChk(sheet1,"tableName", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet1);
						sheet1.DoSave( "${ctx}/EmpCopystdmgr.do?cmd=saveEmpCopystdmgrLeft", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet1.Down2Excel(param);

						break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
						if(!checkList()) return ;
						sheet2.RemoveAll();
						sheet2.DoSearch( "${ctx}/EmpCopystdmgr.do?cmd=getEmpCopystdmgrRightList", $("#sendForm").serialize() );
						break;
		case "Save":
						if(!dupChk(sheet2,"tableName|columnName", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet2);
						sheet2.DoSave( "${ctx}/EmpCopystdmgr.do?cmd=saveEmpCopystdmgrRight", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet2.DataInsert(0);
						sheet2.SetCellValue( row, "tableName", $("#searchTableNameHidden").val());
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet2);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet2.Down2Excel(param);

						break;
		}
	}
	
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
			
			//if ( chk ){
				$("#searchTableNameHidden").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "tableName"));
				doAction2("Search");
			//}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀에 마우스 클릭했을때 발생하는 이벤트
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{

			var saveName = sheet1.ColSaveName(NewCol);
			
			//if( OldRow != NewRow && saveName == "detail" ) {
				$("#searchTableNameHidden").val(sheet1.GetCellValue(NewRow, "tableName"));
				doAction2("Search");
			//}

	  	}catch(ex){alert("OnSelectCell Event Error : " + ex);}
	}
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<input type="hidden" id="searchTableNameHidden" name="searchTableNameHidden">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>테이블명</th>
			<td>
				<input id="searchTableName" name="searchTableName" type="text" class="text" />
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>

<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="50%" />
		<col width="50%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">인사정보복사Master</li>
					<li class="btn">
						<a href="javascript:doAction1('Down2Excel');" 		class="btn outline-gray authR">다운로드</a>
						<a href="javascript:doAction1('Insert');" 			class="btn outline-gray authA">입력</a>
						<a href="javascript:doAction1('Save');" 			class="btn filled authA">저장</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocalCd}"); </script>
		</td>
	
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">인사정보복사Detail</li>
					<li class="btn">
						<!-- <a href="javascript:doAction2('Insert');" 			class="basic authA">입력</a> -->
						<a href="javascript:doAction2('Down2Excel');" 		class="btn outline-gray authR">다운로드</a>
						<a href="javascript:doAction2('Save');" 			class="btn filled authA">저장</a>
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%", "${ssnLocalCd}"); </script>
		</td>
</div>
</body>
</html>
