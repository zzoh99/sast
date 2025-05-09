<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html>	<html class="bodywrap">	<head>
<%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");
	$(function() {
		var searchSabun  		= "";
		var searchGrpCd  		= "";
		var authScopeCd			= "";
		var arg = p.window.dialogArguments;
		
	    if( arg != undefined ) {
			searchSabun = arg["searchSabun"];
			searchGrpCd = arg["searchGrpCd"];
			authScopeCd	= arg["authScopeCd"];
	    }else{
	    	if(p.popDialogArgument("searchSabun")!=null)		searchSabun  	= p.popDialogArgument("searchSabun");
	    	if(p.popDialogArgument("searchGrpCd")!=null)		searchGrpCd  	= p.popDialogArgument("searchGrpCd");
	    	if(p.popDialogArgument("authScopeCd")!=null)		authScopeCd  	= p.popDialogArgument("authScopeCd");
	    }
		
		$("#searchSabun").val(searchSabun);
		$("#searchGrpCd").val(searchGrpCd);
		$("#authScopeCd").val(authScopeCd);
		
		//Cancel 버튼 처리 
		$(".close").click(function(){
			p.self.close(); 
		});			
		
		$("#findOrg").bind("keyup",function(event){
			if( event.keyCode == 13){ findOrg(); $(this).focus(); }
		});		
		
		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});

		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});

		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});

		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});		

		var initdata = {};
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='priorOrgCd' mdef='상위소속코드'/>",	Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"scopeValueTop",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",	Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"scopeValue",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },   
			{Header:"<sht:txt mid='orgNmV10' mdef='소속명'/>",	Type:"Text", 		Hidden:0,  Width:250, Align:"Left",  ColMerge:0,   SaveName:"scopeValueNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,    TreeCol:1 },
			{Header:"<sht:txt mid='chkV1' mdef='등록'/>",				Type:"CheckBox",  Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"chk",        		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Example Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/AuthGrpUserMgr.do?cmd=getAuthGrpUserMgrScopeOrgPopupList", $("#srchFrm").serialize() ); break;
		case "Save": 		for(i=1; i<=sheet1.LastRow(); i++){
						        if( sheet1.GetCellValue(i,"chk") == "1" ) {
						        	sheet1.SetCellValue(i,"sStatus", "I");
						        } else {
						        	sheet1.SetCellValue(i,"sStatus", "D");
						        }			
							};
							IBS_SaveName(document.srchFrm,sheet1);
							sheet1.DoSave( "${ctx}/AuthGrpUserMgr.do?cmd=saveAuthGrpUserMgrScopePopup", $("#srchFrm").serialize()); break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":	sheet1.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	function sheet1_OnChange(Row, Col, Value){
	  try{
	    if( sheet1.ColSaveName(Col) == "chk" && Row == sheet1.GetSelectRow() ) {
	        if( Row == 1 ) {
	            for( i = 1 ; i <= sheet1.RowCount(); i++) {
	                sheet1.SetCellValue(i, "chk",sheet1.GetCellValue(Row, "chk"));
	            }
	        }
	        else {        
	            for( i = Row+1 ; i <= sheet1.RowCount(); i++) {
	                if(  sheet1.GetCellValue(i, "scopeValueTop") != sheet1.GetCellValue(Row, "scopeValueTop") && sheet1.GetRowLevel(i) > sheet1.GetRowLevel(Row) ) {
	                    sheet1.SetCellValue(i, "chk",sheet1.GetCellValue(Row, "chk"));
	                }
	                else {
	                    break;
	                }
	            }
	        }
	    }    
	  }catch(ex){alert("OnChange Event Error : " + ex);}
	}	
	
	function findOrg(){
	    if($("#findOrg").val() == "") return;
	    
	    var Row = 0;
	    if(sheet1.GetSelectRow() < sheet1.LastRow()){
	        Row = sheet1.FindText("scopeValueNm", $("#findOrg").val(), sheet1.GetSelectRow()+1, 2,false); 
	        
	    }else{
	        Row = -1;
	    }
	    
	    if(Row > 0){
	        sheet1.SelectCell(Row,"scopeValueNm");
	    }else if(Row == -1){
	        if(sheet1.GetSelectRow() > 1){
	            Row = sheet1.FindText("scopeValueNm", $("#findOrg").val(), 1, 2,false); 
	            if(Row > 0){
	                sheet1.SelectCell(Row,"scopeValueNm");
	            }
	        }
	    }
	    $("#findOrg").focus();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='authGrpUserMgrScopeOrg' mdef='사용자 권한범위 설정(소속)'/></li>
		<li class="close"></li>
	</ul>
	</div>
	
	<div class="popup_main">
		<form id="srchFrm" name="srchFrm">
	        <input type="hidden" id="searchSabun"	name="searchSabun">
	        <input type="hidden" id="searchGrpCd"	name="searchGrpCd">
	        <input type="hidden" id="authScopeCd"	name="authScopeCd">		
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='104499' mdef='소속명'/></th>
				<td> 
					<input id="findOrg" name ="findOrg" type="text" class="text" />
				</td>
               	<td>
				<btn:a href="javascript:findOrg();" id="btnSearch" css="button" mid='111684' mdef="찾기"/>
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
						<li id="txt" class="txt">소속도
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
							<btn:a href="javascript:doAction1('Save')" css="basic" mid='110708' mdef="저장"/>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
		</table>
		
		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
			</li>
		</ul>
		</div>
	</div>
</div>

</body>
</html>
