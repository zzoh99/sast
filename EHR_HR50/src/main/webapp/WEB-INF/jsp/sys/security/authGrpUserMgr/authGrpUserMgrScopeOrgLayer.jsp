<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html>	<html class="bodywrap">	<head>
<%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script type="text/javascript">
	var authGrpUserMgrScopeOrgLayer = {id:'authGrpUserMgrScopeOrgLayer'};
	$(function() {
		createIBSheet3(document.getElementById('authOrgSheet-wrap'), "authOrgSheet", "100%", "100%", "${ssnLocaleCd}");
		var modal = window.top.document.LayerModalUtility.getModal(authGrpUserMgrScopeOrgLayer.id);
		var {searchSabun, searchGrpCd, authScopeCd} = modal.parameters;
		$("#authOrgFrm [id='searchSabun']").val(searchSabun);
		$("#authOrgFrm [id='searchGrpCd']").val(searchGrpCd);
		$("#authOrgFrm [id='authScopeCd']").val(authScopeCd);
		
		$("#findOrg").bind("keyup",function(event){
			if( event.keyCode == 13){ findOrg(); $(this).focus(); }
		});		
		
		$("#btnPlus").click(function() {
			authOrgSheet.ShowTreeLevel(-1);
		});

		$("#btnStep1").click(function()	{
			authOrgSheet.ShowTreeLevel(0, 1);
		});

		$("#btnStep2").click(function()	{
			authOrgSheet.ShowTreeLevel(1,2);
		});

		$("#btnStep3").click(function()	{
			authOrgSheet.ShowTreeLevel(-1);
		});		

		var initdata = {};
		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='priorOrgCd' mdef='상위소속코드'/>",	Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"scopeValueTop",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",	Type:"Text",		Hidden:1,  Width:0,   Align:"Center",  ColMerge:0,   SaveName:"scopeValue",        	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },   
			{Header:"<sht:txt mid='orgNmV10' mdef='소속명'/>",	Type:"Text", 		Hidden:0,  Width:250, Align:"Left",  ColMerge:0,   SaveName:"scopeValueNm",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100,    TreeCol:1 },
			{Header:"<sht:txt mid='chkV1' mdef='등록'/>",				Type:"CheckBox",  Hidden:0,  Width:80,  Align:"Center",  ColMerge:0,   SaveName:"chk",        		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 }
		]; 
		IBS_InitSheet(authOrgSheet, initdata);authOrgSheet.SetEditable("${editable}");authOrgSheet.SetVisible(true);authOrgSheet.SetCountPosition(4);
		doAction1("Search");
	});

	//Example Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	authOrgSheet.DoSearch( "${ctx}/AuthGrpUserMgr.do?cmd=getAuthGrpUserMgrScopeOrgPopupList", $("#authOrgFrm").serialize() ); break;
		case "Save": 		for(i=1; i<=authOrgSheet.LastRow(); i++){
						        if( authOrgSheet.GetCellValue(i,"chk") == "1" ) {
						        	authOrgSheet.SetCellValue(i,"sStatus", "I");
						        } else {
						        	authOrgSheet.SetCellValue(i,"sStatus", "D");
						        }			
							};
							IBS_SaveName(document.authOrgFrm,authOrgSheet);
							authOrgSheet.DoSave( "${ctx}/AuthGrpUserMgr.do?cmd=saveAuthGrpUserMgrScopePopup", $("#authOrgFrm").serialize()); break;
		case "Clear":		authOrgSheet.RemoveAll(); break;
		case "Down2Excel":	authOrgSheet.Down2Excel(); break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; authOrgSheet.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function authOrgSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	// 저장 후 메시지
	function authOrgSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1("Search");} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	
	function authOrgSheet_OnChange(Row, Col, Value){
	  try{
	    if( authOrgSheet.ColSaveName(Col) == "chk" && Row == authOrgSheet.GetSelectRow() ) {
	        if( Row == 1 ) {
	            for( i = 1 ; i <= authOrgSheet.RowCount(); i++) {
	                authOrgSheet.SetCellValue(i, "chk",authOrgSheet.GetCellValue(Row, "chk"));
	            }
	        }
	        else {        
	            for( i = Row+1 ; i <= authOrgSheet.RowCount(); i++) {
	                if(  authOrgSheet.GetCellValue(i, "scopeValueTop") != authOrgSheet.GetCellValue(Row, "scopeValueTop") && authOrgSheet.GetRowLevel(i) > authOrgSheet.GetRowLevel(Row) ) {
	                    authOrgSheet.SetCellValue(i, "chk",authOrgSheet.GetCellValue(Row, "chk"));
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
	    if(authOrgSheet.GetSelectRow() < authOrgSheet.LastRow()){
	        Row = authOrgSheet.FindText("scopeValueNm", $("#findOrg").val(), authOrgSheet.GetSelectRow()+1, 2,false); 
	        
	    }else{
	        Row = -1;
	    }
	    
	    if(Row > 0){
	        authOrgSheet.SelectCell(Row,"scopeValueNm");
	    }else if(Row == -1){
	        if(authOrgSheet.GetSelectRow() > 1){
	            Row = authOrgSheet.FindText("scopeValueNm", $("#findOrg").val(), 1, 2,false); 
	            if(Row > 0){
	                authOrgSheet.SelectCell(Row,"scopeValueNm");
	            }
	        }
	    }
	    $("#findOrg").focus();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id="authOrgFrm" name="authOrgFrm">
	        <input type="hidden" id="searchSabun"	name="searchSabun">
	        <input type="hidden" id="searchGrpCd"	name="searchGrpCd">
	        <input type="hidden" id="authScopeCd"	name="authScopeCd">		
			<div class="sheet_search outer">
				<div>
				<table>
					<tr>
						<th>
							<tit:txt mid='104499' mdef='소속명'/>
						</th>
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
				<div id="authOrgSheet-wrap"></div>
				<!-- <script type="text/javascript"> createIBSheet("authOrgSheet", "100%", "100%", "${ssnLocaleCd}"); </script> -->
			</td>
		</tr>
		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('authGrpUserMgrScopeOrgLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>

</body>
</html>
