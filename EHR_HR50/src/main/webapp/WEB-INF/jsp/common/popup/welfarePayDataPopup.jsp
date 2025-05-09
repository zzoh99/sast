<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='payDayPop' mdef='급여일자 조회'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		var closeCd = "";
		var arg = p.window.dialogArguments;

		if( arg != undefined ) {
			closeCd = arg["closeCd"];
		}else{
	    	if(p.popDialogArgument("closeCd")!=null)		closeCd  	= p.popDialogArgument("closeCd");
	    }	
		
		$("#closeCd").val(closeCd);
		
		$("#searchYear").keyup(function() {
			makeNumber(this,'A');
		});
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='payYmV3' mdef='대상년월'/>",       Type:"Date",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"ym",               KeyField:1,   CalcLogic:"",   Format:"Ym",          PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:7 },
			{Header:"<sht:txt mid='closeYnV1' mdef='마감여부'/>",       Type:"Combo",     Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"closeSt",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",           Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"bigo",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2000 },
			{Header:"<sht:txt mid='closeCd_V2236' mdef='마감코드'/>",       Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  ColMerge:1,   SaveName:"closeCd",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 }
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);sheet1.SetCountPosition(4);


		// 급여코드
		//------------------------------------- 그리드 콤보 -------------------------------------//
		// 마감항목코드(S90001)
		var closeCdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "S90001"), "");
		sheet1.SetColProperty("closeCd", {ComboText:"|"+closeCdList[0], ComboCode:"|"+closeCdList[1]});
	
		// 마감상태코드(S90003)
		var closeSt = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "S90003"), "");
		sheet1.SetColProperty("closeSt", {ComboText:"|"+closeSt[0], ComboCode:"|"+closeSt[1]});
	
		$("#searchYear").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
	    $(".close").click(function() {
	    	p.self.close();
	    });
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	sheet1.DoSearch( "${ctx}/WelfarePayDataPopup.do?cmd=getWelfarePayDataPopupList", $("#mySheetForm").serialize() ); break;
		case "Save": 		
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/WelfarePayDataPopup.do?cmd=saveWelfarePayDataPopup", $("#mySheetForm").serialize()); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);	} sheetResize(); 
		
		for(var i = 1; i <= sheet1.RowCount(); i++){
			if(sheet1.GetCellValue(i, "closeSt") == "10005"){
				sheet1.SetRowEditable(i,0);
			}
		}
		
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

</script>
</head>
<div class="wrapper">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='113812' mdef='마감확인'/></li>
				<li class="close"></li>
			</ul>
		</div>
        <div class="popup_main">
		<form id="mySheetForm" name="mySheetForm">
		<input id="closeCd" name="closeCd" type="hidden" >
				<div class="sheet_search outer">
					<div>
					<table>
					<tr>
						<th><tit:txt mid='113461' mdef='대상년도 '/></th>
                        <td>  <input id="searchYear" name ="searchYear" class="text" maxlength="4" value="<%= DateUtil.getThisYear() %>"/></td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
						<li id="txt" class="txt"><tit:txt mid='113813' mdef='마감여부 조회'/></li>
						<li class="btn">
							<a href="javascript:doAction1('Save')" 	class="basic authR"><tit:txt mid='104476' mdef='저장'/></a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>
		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
       </div>
	</div>
</div>
</html>
