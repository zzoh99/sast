<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCtype html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {
		
		var mainMenuCd = "";
		var athGrpCd   = "";
		
		var arg = p.window.dialogArguments;
		
	    if( arg != undefined ) {
	    	mainMenuCd  = arg["mainMenuCd"];
	    	athGrpCd    = arg["athGrpCd"];
	    }else{
	    	if(p.popDialogArgument("mainMenuCd")!=null)		mainMenuCd  	= p.popDialogArgument("mainMenuCd");
	    	if(p.popDialogArgument("athGrpCd")!=null)		athGrpCd  		= p.popDialogArgument("athGrpCd");
	    }
		$("#mainMenuCd").val(mainMenuCd);
		$("#athGrpCd").val(athGrpCd);
		
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, ChildPage:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",	Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='mainMenuCd' mdef='메인메뉴코드'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"mainMenuCd", 	KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='priorMenuCd' mdef='상위메뉴'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"priorMenuCd",	KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='menuCd' mdef='메뉴'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuCd",		KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduSeqV8' mdef='순번'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"menuSeq",		KeyField:1,	Format:"",	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",				Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"type",		KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='koKrV5' mdef='메뉴/프로그램명'/>",	Type:"Text",	Hidden:0,	Width:160,	Align:"Left",	ColMerge:0,	SaveName:"menuNm",		KeyField:1,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:100, TreeCol:1  },
			{Header:"<sht:txt mid='prgCdV2' mdef='프로그램'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"prgCd",		KeyField:0,	Format:"",	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='searchSeqV2' mdef='조건검색코드'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"searchSeq",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='searchDescV1' mdef='조건검색'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"searchDesc",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='dataPrgTypeV2' mdef='프로그램\n권한'/>",	Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"dataPrgType",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='dataPrgType' mdef='적용권한'/>",			Type:"Text",	Hidden:0,	Width:65,	Align:"Center",	ColMerge:0,	SaveName:"dataRwType",	KeyField:0,	Format:"",	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='cnt' mdef='ONEPAGE\nROWS'/>",	Type:"Int",		Hidden:0,  	Width:120,  Align:"Right",	ColMerge:0,	SaveName:"cnt",       	KeyField:0, Format:"Integer",UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",		Hidden:0,  	Width:120,  Align:"Right",	ColMerge:0,	SaveName:"seq",      	KeyField:0, Format:"Integer",UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
		]; IBS_InitSheet(mySheet, initdata); mySheet.SetCountPosition(4);
		$(window).smartresize(sheetResize); sheetInit();
		doAction("Search");
		$(".close").click(function() {
	    	p.self.close();
	    });
	});

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	mySheet.DoSearch( "${ctx}/AthGrpMenuMgr.do?cmd=getAthGrpMenuMgrNoneRegPopupList", $("#mySheetForm").serialize() ); break;
		}
	}
	function mySheet_OnSearchEnd(Code, Msg, StCode, StMsg){
    	try{
	      if (Msg != ""){
	      	alert(Msg);
	      }
	      mySheet.SetRowEditable(1,false);
	      mySheet.ShowTreeLevel(0);
	      mySheet.SetRowEditable(1,false);
    	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
  	}
</script>
</head>
<body class="bodywrap">
	<form id="mySheetForm">
		<input id="mainMenuCd" 	name="mainMenuCd" 	type="hidden"/>
		<input id="athGrpCd" 	name="athGrpCd"		type="hidden"/>
	</form>
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li><tit:txt mid='athGrpMenuMgrNone' mdef='권한별 등록 가능 프로그램 세부내역'/></li>
				<li class="close"></li>
			</ul>
		</div>
		<div class="popup_main">
			<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
				<tr>
					<td>
						<div class="inner">
							<div class="sheet_title">
								<ul>
									<li id="txt" class="txt"><tit:txt mid='athGrpMenuMgrNone' mdef='권한별 등록 가능 프로그램 세부내역'/></li>
									<li class="btn">
										<a href="javascript:doAction('Search');" 		class="basic authR"><tit:txt mid='104081' mdef='조회'/></a>
									</li>
								</ul>
							</div>
						</div> <script type="text/javascript">createIBSheet("mySheet", "100%", "100%", "${ssnLocaleCd}"); </script>
					</td>
				</tr>
			</table>
		</div>
		<div class="popup_button outer">
			<ul>
				<li><btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</body>
</html>



