<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	const tabSizeWidePossibleIds = ['processMap'];
	const tabSize22PossibleIds = ['listBox20'];
	const tabSizeFullPossibleIds = ['listBox301', 'listBox1201'];

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"권한그룹",		Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"grpCd", Edit:0},
			{Header:"메인메뉴코드",		Type:"Text",		Hidden:1,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"mainMenuCd", Edit:0},
			{Header:"위젯코드",		Type:"Text",		Hidden:0,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"tabId", Edit:0},
			{Header:"<sht:txt mid='tabName' mdef='[ 등록 위젯명 ]'/>",	Type:"Text",	Hidden:0,		Width:200,			Align:"Left",	ColMerge:0,	SaveName:"tabName",	UpdateEdit:0,	InsertEdit:0},
			{Header:"<sht:txt mid='tabSize' mdef='위젯크기' />", 		Type:'Combo', 	Hidden:0,		Width:50,			Align:"Center",	ColMerge:0,	SaveName:"tabSize", Edit:1},
			{Header:"순서",			Type:"Text",		Hidden:0,					Width:45,			Align:"Center",	ColMerge:0,	SaveName:"seq", Edit:1}
		];
		IBS_InitSheet(mySheetLeft, initdata);
		mySheetLeft.SetCountPosition(4);

		var texts = ['1X1', '1X2'];
		var codes = ['11', '12'];
		mySheetLeft.SetColProperty('tabSize', { ComboText: texts.join('|'), ComboCode: codes.join('|') });

		initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:0,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"등록",			Type:"${sDelTy}",	Hidden:0,					Width:45,	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"위젯코드",		Type:"Text",		Hidden:0,					Width:0,			Align:"Left",	ColMerge:0,	SaveName:"tabId" , Edit:0},
			{Header:"<sht:txt mid='tabName' mdef='[ 등록 위젯명 ]'/>",	Type:"Text",		Hidden:0,					Width:185,			Align:"Left",	ColMerge:0,	SaveName:"tabName",	UpdateEdit:0,	InsertEdit:0},
		];
		IBS_InitSheet(mySheetRight, initdata);
		mySheetRight.SetCountPosition(4);

		var menuList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getMainMuPrgMainMenuList", false).codeList, "");
		var authGrp = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&", "queryId=getWidgetGrpMenuMgrGrpCdList", false).codeList, "");
		$("#athGrpCd").html(authGrp[2]);
		$("#athGrpCd").change(function(){ doAction("SearchLeft"); doAction("SearchRight"); });
		$('#mainMenuCd').html("<option value='00'>메인</option>" + menuList[2]);
		$('#mainMenuCd').change(function() { doAction("SearchLeft"); doAction("SearchRight"); });
		
		$("#oldGrpCd").html(authGrp[2]);		
		$("#copyGrpCd").html(("<option value=''>선택</option>"+authGrp[2]));
		$("#hdnCopyGrpCd").hide();
		sheetInit();
		doAction("SearchLeft");
		doAction("SearchRight");
		$("#ibs").show();
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "SearchLeft":		mySheetLeft.DoSearch("${ctx}/WidgetGrpMenuMgr.do?cmd=getWidgetGrpMenuMgrLeftList", $("#mySheetForm").serialize()); break;
		case "SearchRight":		mySheetRight.DoSearch("${ctx}/WidgetGrpMenuMgr.do?cmd=getWidgetGrpMenuMgrRightList", $("#mySheetForm").serialize()); break;
		case "Down2ExcelLeft":	mySheetLeft.Down2Excel(); break;
		case "Down2ExcelRight":	mySheetRight.Down2Excel(); break;
		case "Reg":
			IBS_SaveName(document.mySheetForm, mySheetRight);
			mySheetRight.DoSave("${ctx}/WidgetGrpMenuMgr.do?cmd=insertWidgetGrpMenuMgr", $("#mySheetForm").serialize()); break;
        case "Save":
			IBS_SaveName(document.mySheetForm, mySheetLeft);
			mySheetLeft.DoSave("${ctx}/WidgetGrpMenuMgr.do?cmd=saveWidgetGrpMenuMgr", $("#mySheetForm").serialize()); break;
        case "Del":
			IBS_SaveName(document.mySheetForm, mySheetLeft);
			mySheetLeft.DoSave("${ctx}/WidgetGrpMenuMgr.do?cmd=deleteWidgetGrpMenuMgr", $("#mySheetForm").serialize()); break;
        case "Cre":
			if(!confirm("["+$("#athGrpCd option:selected").text()+"]권한의 개인별 위젯을 일괄 생성 하시겠습니까?")) { return ;}
			progressBar(true) ;
			setTimeout(
				function(){
					var data = ajaxCall("${ctx}/WidgetGrpMenuMgr.do?cmd=prcWidgetGrpMenuMgrCre", $("#mySheetForm").serialize(),false);
			    	if(data.Result.Code == null) {
			    		alert("<msg:txt mid='109663' mdef='정상적으로 처리되었습니다.'/>");
				    	progressBar(false) ;
			    	} else {
				    	alert("처리중 오류가 발생했습니다.\n"+data.Result.Message);
				    	progressBar(false) ;
			    	}
				}
			, 100);
        	break;
		}
	}
	
	//그룹간 복사
	function doAction1(sAction) {
		switch (sAction) {
		case "View":
						$("#hdnCopyGrpCd").show();
						$("#oldGrpCd").val($("#athGrpCd").val());
						break;
		case "Copy":
						var tarGrpCd = $("select[name=copyGrpCd] option:selected").val();
						var tarGrpCdText = $("select[name=copyGrpCd] option:selected").text();
						var oldGrpCd = $("select[name=oldGrpCd] option:selected").val();
						var oldGrpCdText = $("select[name=oldGrpCd] option:selected").text();
						
						if(!tarGrpCd){ break; }
						if (confirm(oldGrpCdText+" 그룹의 등록위젯메뉴 정보를 \n"+tarGrpCdText+" 그룹으로 복사 하시겠습니까?\n(기존 데이터는 삭제됩니다.)")) {
							
							// 메인관리 그룹간 복사
							var result = ajaxCall("${ctx}/WidgetGrpMenuMgr.do?cmd=copyWidgetGrpMenuMgr", "oldGrpCd="+oldGrpCd+"&tarGrpCd="+tarGrpCd, false);
	
							if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
								if (parseInt(result["Result"]["Code"]) >= 0) {
									alert("등록위젯메뉴 정보를 복사 하였습니다.");
									$("#athGrpCd").val(tarGrpCd);
									doAction("SearchLeft");
									doAction("SearchRight");
								} else if (result["Result"]["Message"] != null) {
									alert(result["Result"]["Message"]);
								}
							} else {
								alert("등록위젯메뉴 정보 복사 오류입니다.");
							}
						}
						$("#copyGrpCd").val("");
						$("#hdnCopyGrpCd").hide();
						break;
		}
	}

	// LEFT 조회 후 에러 메시지
	function mySheetLeft_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { alert(Msg); return; }
			tabSize22PossibleIds.forEach(id => {
				mySheetLeft.CellComboItem(mySheetLeft.FindText('tabId', id), 'tabSize', { ComboText: '1X1|1X2|2X2', ComboCode: '11|12|22' });
			});

			tabSizeFullPossibleIds.forEach(id => {
				mySheetLeft.CellComboItem(mySheetLeft.FindText('tabId', id), 'tabSize', { ComboText: '2X4', ComboCode: '24' });
			});

			tabSizeWidePossibleIds.forEach(id => {
				mySheetLeft.CellComboItem(mySheetLeft.FindText('tabId', id), 'tabSize', { ComboText: '1X4|2X4', ComboCode: '14|24' });
			});
		} catch (ex) {
			 alert("OnSearchEnd Event Error : " + ex); 
		}
	}
	// LEFT 조회 후 에러 메시지
	function mySheetRight_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	// RIGHT 저장 후 메시지
	function mySheetLeft_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction("SearchLeft");doAction("SearchRight");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}
	// RIGHT 저장 후 메시지
	function mySheetRight_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); doAction("SearchLeft");doAction("SearchRight");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="mySheetForm" name="mySheetForm">
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th>권한그룹</th>
					<td>
						<select id="athGrpCd" name="athGrpCd"></select>
					</td>
					<th>메뉴</th>
					<td>
						<select id="mainMenuCd" name="mainMenuCd"></select>
					</td>
					<td> <btn:a href="javascript:doAction('SearchLeft');doAction('SearchRight');" id="btnSearch" css="btn dark" mid='search' mdef="조회"/> </td>
					<td colspan="2">
						<a href="javascript:doAction1('View');" class="btn filled authA"><tit:txt mid='110696' mdef='권한복사'/></a>
					</td>
				</tr>
				<tr id="hdnCopyGrpCd">
					<th>From</th>
					<td>
						<select id="oldGrpCd" name="oldGrpCd" class="box" ></select>
					</td>
					<td style="padding-left: 35px;"><img src="/common/images/sub/ico_arrow2.png"/></td>
					<th>To</th>
					<td>
						<select id="copyGrpCd" name="copyGrpCd" class="box" onchange="javascript:doAction1('Copy');"></select>
					</td>
				</tr>
			</table>
			</div>
		</div>
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<colgroup>
			<col width="50%" />
			<col width="45px" />
			<col width="50%" />
		</colgroup>
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">등록위젯메뉴 </li>
						<li class="btn">
							<a href="javascript:doAction('Save');" class="btn soft authA">저장</a>
							<a href="javascript:doAction('Cre');" class="btn filled authA" >개인별 위젯 일괄생성</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("mySheetLeft", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_arrow">
				<div>
					<a href="javascript:doAction('Del');" class="btn outline_gray">&gt;</a><br/><br/>
					<a href="javascript:doAction('Reg');" class="btn outline_gray">&lt;</a>
				</div>
			</td>
			<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="txt">등록가능위젯메뉴 </li>
						<li class="btn">
							<a href="javascript:doAction('Reg');" class="btn soft">등록</a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("mySheetRight", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>

</div>
</body>
</html>
