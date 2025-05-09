<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var gPRow = "";
	var pGubun = "";

	$(function() {

		var arg = p.popDialogArgumentAll();

		 if( arg != undefined ) {

			    $("#searchItemNm").text(arg["searchItemNm"]);
			    $("#searchUseGubun").val(arg["searchUseGubun"]);
			    $("#searchItemValue1").val(arg["searchItemValue1"]);
			    $("#searchItemValue2").val(arg["searchItemValue2"]);
			    $("#searchItemValue3").val(arg["searchItemValue3"]);
		    }

		var initdata = {};
		//###########################범위
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",	Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"범위코드", 		Type:"Text",      	Hidden:1,  Width:0,    	Align:"Left",    ColMerge:0,   SaveName:"authScopeCd",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"범위", 			Type:"Text",      	Hidden:0,  Width:130,  	Align:"Left",    ColMerge:0,   SaveName:"authScopeNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"범위적용구분", 	Type:"Text",      	Hidden:1,  Width:0,    	Align:"Center",  ColMerge:0,   SaveName:"scopeType",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"프로그램URL", 	Type:"Text",      	Hidden:1,  Width:0,    	Align:"Left",    ColMerge:0,   SaveName:"prgUrl",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"SQL문", 		Type:"Text",      	Hidden:1,  Width:0,    	Align:"Left",    ColMerge:0,   SaveName:"sqlSyntax",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
			{Header:"필드명", 		Type:"Text",      	Hidden:1,  Width:0,    	Align:"Left",    ColMerge:0,   SaveName:"tableNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//###########################범위항목
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",	Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center",  ColMerge:0,   SaveName:"sNo" },
			{Header:"삭제",	Type:"${sDelTy}", 	Hidden:1,  Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태",	Type:"${sSttTy}", 	Hidden:1,  Width:"${sSttWdt}", Align:"Center",  ColMerge:0,   SaveName:"sStatus" },
			{Header:"범위항목값",	Type:"Text",      	Hidden:0,  Width:50,  	Align:"Left",    ColMerge:0,   SaveName:"scopeValue",    KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"범위항목명",	Type:"Text",      	Hidden:0,  Width:110,	Align:"Left",    ColMerge:0,   SaveName:"scopeValueNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:4000 },
            {Header:"등록",		Type:"CheckBox",  	Hidden:0,  Width:35,  	Align:"Center",  ColMerge:0,   SaveName:"chk",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 }
            ]; IBS_InitSheet(sheet2, initdata);sheet2.SetEditable("${editable}");sheet1.SetVisible(true);sheet2.SetCountPosition(4);


            $(window).smartresize(sheetResize); sheetInit();

		$("#name, #orgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ $("#orgCd").val(); orgList(); $(this).focus(); }
		});

		doAction1("Search");

		//close 처리
		$(".close").click(function(){
			p.self.close();
		});

	});
	function orgList(){
			// $("#orgCd").val("");
			 doAction3("Search");
	}
    function doAction1(sAction) {
		switch (sAction) { case "Search":  sheet1.DoSearch( "${ctx}/FlexibleWorkOrgMgrPop.do?cmd=getFlexibleWorkOrgMgrPopList1", $("#sheetForm").serialize()); break; }
    }
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/FlexibleWorkOrgMgrPop.do?cmd=getFlexibleWorkOrgMgrPopList2", $("#sheetForm").serialize());
			break;
		case "Save":
			for(i=1; i<=sheet2.LastRow(); i++){
		        if( sheet2.GetCellValue(i,"chk") == "1" ) {
		        	sheet2.SetCellValue(i,"sStatus", "I");
		        } else {
		        	sheet2.SetCellValue(i,"sStatus", "D");
		        }
			};
			IBS_SaveName(document.sheetForm,sheet2);
			sheet2.DoSave( "${ctx}/FlexibleWorkOrgMgrPop.do?cmd=saveFlexibleWorkOrgMgrPop", $("#sheetForm").serialize());
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}
			if(sheet1.RowCount() > 0){
				$("#searchSqlSyntax").val(sheet1.GetCellValue(sheet1.HeaderRows(), "sqlSyntax"));
				$("#searchAuthScopeCd").val(sheet1.GetCellValue(sheet1.HeaderRows(), "authScopeCd"));
				//doAction2("Search");
			}


			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		 try{
			    selectSheet = sheet1;

			    $("#searchSqlSyntax").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "sqlSyntax"));
			    $("#searchAuthScopeCd").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "authScopeCd"));

			    if( sheet1.GetCellValue(sheet1.GetSelectRow(), "scopeType") == "SQL"  ) {

			    	doAction2("Search");

			    } else if( sheet1.GetCellValue(sheet1.GetSelectRow(), "scopeType") == "PROGRAM"  ) {

			        sheet2.RemoveAll();
			        if( sheet1.GetCellValue(sheet1.GetSelectRow(), "authScopeCd") == "W10"  ) {
			        	if(!isPopup()) {return;}

			        	var args = new Array();
				        args["searchUseGubun"]   = $("#searchUseGubun").val();
				        args["searchItemValue1"] = $("#searchItemValue1").val();
				        args["searchItemValue2"] = $("#searchItemValue2").val();
				        args["searchItemValue3"] = $("#searchItemValue3").val();
				        args["searchAuthScopeCd"] = $("#searchAuthScopeCd").val();

						openPopup("/FlexibleWorkOrgMgrPop.do?cmd=viewFlexibleWorkOrgMgrOrgPop&authPg=${authPg}",args,"740","700");
			        }

			        if( sheet1.GetCellValue(sheet1.GetSelectRow(), "authScopeCd") == "W20"  ) {
			        	if(!isPopup()) {return;}

			        	var args = new Array();
				        args["searchUseGubun"]   = $("#searchUseGubun").val();
				        args["searchItemValue1"] = $("#searchItemValue1").val();
				        args["searchItemValue2"] = $("#searchItemValue2").val();
				        args["searchItemValue3"] = $("#searchItemValue3").val();
				        args["searchAuthScopeCd"] = $("#searchAuthScopeCd").val();

						openPopup("/FlexibleWorkOrgMgrPop.do?cmd=viewFlexibleWorkOrgMgrPersonPop&authPg=${authPg}",args,"1000","700");
			        }
			    }
			  }catch(ex){alert("sht1_OnSelectCell Event Error : " + ex);}
	}


	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			doAction2("Search");

		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
	}

</script>

</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
		<ul>
			<li>범위 설정 [설정대상:<span id="searchItemNm"></span>]</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<form id="sheetForm" name="sheetForm">
			<input id="searchUseGubun" 		name="searchUseGubun" 		type="hidden" />
			<input id="searchItemValue1" 		name="searchItemValue1" 		type="hidden" />
			<input id="searchItemValue2" 		name="searchItemValue2" 		type="hidden" />
			<input id="searchItemValue3" 		name="searchItemValue3" 		type="hidden" />
			<input id="searchSqlSyntax" 		name="searchSqlSyntax" 			type="hidden" />
			<input id="searchAuthScopeCd" 		name="searchAuthScopeCd" 		type="hidden" />
		</form>
		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td id="orgMain" class="sheet_left w30p">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">범위</li>
							<li class="btn">
								<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR">다운로드</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
			</td>
			<td id="listMain" class="sheet_left w70p">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">범위항목</li>
							<li class="btn">
								<a href="javascript:doAction2('Search')" id="btnSearch" class="button">조회</a>
								<a href="javascript:doAction2('Save')" 			class="basic authA">저장</a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
			</td>
		</tr>
	</table>
	<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>