<%@	page language="java" contentType="text/html; charset=UTF-8"	pageEncoding="UTF-8"%>
<%@	include	file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html>	<html class="bodywrap">	<head>
<%@	include	file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@	include	file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">
    var d = "<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>";

	$(function() {
		$("#stdDate").datepicker2();

		const modal = window.top.document.LayerModalUtility.getModal('payWorkTimeRewardTabOrgLayer');
		$("#searchUseGubun").val(modal.parameters.searchUseGubun);
		$("#searchItemValue1").val(modal.parameters.searchItemValue1);
		$("#searchItemValue2").val(modal.parameters.searchItemValue2);
		$("#searchItemValue3").val(modal.parameters.searchItemValue3);
		$("#searchAuthScopeCd").val("W10");

		createIBSheet3(document.getElementById('sheet1-wrap'), "sheet1", "100%", "100%", "${ssnLocaleCd}");

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
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}", 	Hidden:1,  					Width:"${sDelWdt}", Align:"Center",  ColMerge:0,   SaveName:"sDelete" },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"상위소속코드",	Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"scopeValueTop",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"소속코드",	Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"scopeValue",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"소속명",		Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"scopeValueNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,	TreeCol:1 },
			{Header:"등록",		Type:"CheckBox",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chk",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		// sheet 높이 재계산
		const sheetHeight = $('.modal_body').height() - $('.sheet_search').height() - $('.inner').height();
		sheet1.SetSheetHeight(sheetHeight);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	//Example Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/PayWorkTimeRewardTab.do?cmd=getPayWorkTimeRewardTabOrgLayerList", $("#srchFrm").serialize() ); break;
		case "Save":
			for(i=1; i<=sheet1.LastRow(); i++){
				if( sheet1.GetCellValue(i,"chk") == "1" ) {
					//sheet1.SetCellValue(i,"sStatus", "I");
				} else {
					sheet1.SetCellValue(i,"sStatus", "D");
				}
			};
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/PayWorkTimeRewardTab.do?cmd=savePayWorkTimeRewardTabOrgLayer", $("#srchFrm").serialize());
			break;

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
		try {
			if(Msg != "") {
				alert(Msg);
			}
			const modal = window.top.document.LayerModalUtility.getModal('payWorkTimeRewardTabOrgLayer');
			modal.fire('payWorkTimeRewardTabOrgTrigger').hide();
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
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
		if($("#stdDate").val() != d){
			d = $("#stdDate").val();
			doAction1("Search");
		}else{

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
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<form id=srchFrm name=srchFrm>
			<input id="searchUseGubun" 		name="searchUseGubun" 		type="hidden" />
			<input id="searchItemValue1" 		name="searchItemValue1" 		type="hidden" />
			<input id="searchItemValue2" 		name="searchItemValue2" 		type="hidden" />
			<input id="searchItemValue3" 		name="searchItemValue3" 		type="hidden" />
			<input id="searchAuthScopeCd" 		name="searchAuthScopeCd" 		type="hidden" />
			<div class="sheet_search outer">
				<div>
					<table>
						<tr>
							<th>기준일자</th>
							<td>
								<input type="text" id="stdDate" name="stdDate" class="date2" value="<%=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
							</td>
							<th>소속명</th>
							<td>
								<input id="findOrg" name ="findOrg" type="text" class="text" />
							</td>
							<td>
								<a href="javascript:findOrg();" id="btnSearch" class="button">찾기</a>
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
									<a href="javascript:doAction1('Save')" class="basic">저장</a>
								</li>
							</ul>
						</div>
					</div>
					<div id="sheet1-wrap"></div>
				</td>
			</tr>
		</table>
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:closeCommonLayer('payWorkTimeRewardTabOrgLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>

</body>
</html>