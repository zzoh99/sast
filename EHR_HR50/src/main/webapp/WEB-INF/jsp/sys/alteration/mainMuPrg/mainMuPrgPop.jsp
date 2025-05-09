<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head><title><tit:txt mid='112673' mdef='도움말등록PopUp'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p 	= eval("${popUpStatus}");
	var arg = p.window.dialogArguments;
	
	var tabIdx;
	
	var isPreload = false;
	var menuList = null;

	$(function(){
		$(".close").click(function() 	{ p.self.close(); });
		
		$( "#tabs" ).tabs({
			beforeActivate: function(event, ui) {
				tabIdx = ui.newTab.index();
				sheetResize();
			}
		});

		if( arg != undefined ) {
			$("#searchPrgCd").val(arg["prgCd"]);
			$("#spanMenuNm").html( arg["menuNm"] );
			$("#searchMainMenuCd").val(arg["mainMenuCd"]);
			$("#searchPriorMenuCd").val(arg["priorMenuCd"]);
			$("#searchMenuCd").val(arg["menuCd"]);
			$("#searchMenuSeq").val(arg["menuSeq"]);
		}else{
			if(p.popDialogArgument("prgCd")!=null)			$("#searchPrgCd").val(p.popDialogArgument("prgCd"));
			if(p.popDialogArgument("menuNm")!=null)			$("#spanMenuNm").html(p.popDialogArgument("menuNm"));
			if(p.popDialogArgument("mainMenuCd")!=null)		$("#searchMainMenuCd").val(p.popDialogArgument("mainMenuCd"));
			if(p.popDialogArgument("priorMenuCd")!=null)	$("#searchPriorMenuCd").val(p.popDialogArgument("priorMenuCd"));
			if(p.popDialogArgument("menuCd")!=null)			$("#searchMenuCd").val(p.popDialogArgument("menuCd"));
			if(p.popDialogArgument("menuSeq")!=null)		$("#searchMenuSeq").val(p.popDialogArgument("menuSeq"));
		}
		
		progressBar(true);
		isPreload = true;

		menuList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getMainMuPrgMainMenuList",false).codeList, "");
		$("#mainMenuCd").html(menuList[2]);
		$("#mainMenuCd").change(function(){
			$("#mainMenuNm").val($("#mainMenuCd option:selected").text());
			doAction1("Search");
		});
		$("#mainMenuNm").val( $("#mainMenuCd option:selected").text() );
		
		// 연관메뉴관리 세팅
		initSheet1();
		initSheet2();
		
		submitCall($("#srchFrm"),"ifrm1","post","/MainMuPrg.do?cmd=viewIframeEditor");
		
		$("#ifrm1").on('load', function(){
			submitCall($("#srchFrm"),"ifrm2","post","/MainMuPrg.do?cmd=viewIframeEditor");
		});

		$("#ifrm2").on('load',function(){
			doSearch();
		});
	});
	
	function doSearch(){
		try{
			var data = ajaxCall("${ctx}/MainMuPrg.do?cmd=getMainMuPrgPopMap",$("#srchFrm").serialize(),false);

			if(data.DATA == null){
				$("#ifrm1")[0].contentWindow.Editor.modify({
					"content": ""+ " "
				});
				$("#ifrm2")[0].contentWindow.Editor.modify({
					"content": ""+ " "
				});
			} else {
				$("#ifrm1")[0].contentWindow.Editor.modify({
					"content": ""+ nvlStr(data.DATA.mgrHelp)
				});
				$("#ifrm2")[0].contentWindow.Editor.modify({
					"content": ""+ nvlStr(data.DATA.empHelp)
				});

				if ( data.DATA.mgrHelpYn == "Y" )	$("#mgrHelpYn").attr("checked", true);
				else								$("#mgrHelpYn").attr("checked", false);

				if ( data.DATA.empHelpYn == "Y" )	$("#empHelpYn").attr("checked", true);
				else								$("#empHelpYn").attr("checked", false);

				$("#mgrHelp").val( nvlStr(data.DATA.mgrHelp) );
				$("#empHelp").val( nvlStr(data.DATA.empHelp) );
				$("#fileSeq").val(data.DATA.fileSeq);
			}
			upLoadInit($("#fileSeq").val(),"");
			
			// 연관메뉴관리 세팅
			doAction1("Search");
			doAction2('Search');
			
		}catch(e){
			alert("doSearch Error:" + e);
		}
	}

	function doSave() {
		try{
			$("#srchFrm>#fileSeq").val($("#uploadForm>#fileSeq").val());
			$("#mgrHelp").val($('#ifrm1')[0].contentWindow.Editor.getContent());
			$("#empHelp").val($('#ifrm2')[0].contentWindow.Editor.getContent());

			var data = ajaxCall("${ctx}/MainMuPrg.do?cmd=saveMainMuPrgPop",$("#srchFrm").serialize(),false);
			alert(data.Result.Message);
			if(data.Result.Code != "-1"){
				var returnValue = new Array(1);
				returnValue["resultCode"] = "1";
				//p.window.returnValue = returnValue;
				if(p.popReturnValue) p.popReturnValue(returnValue);
				p.self.close();
		 	}
		}catch(e){
			alert("doSave Error:" + e);
		}
	}

	function nvlStr(pVal) {
		if (pVal == null) return "";
		return pVal;
	}
	
</script>
<script type="text/javascript">
	function initSheet1() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"상태",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"메인메뉴코드",		Type:"Text",		Hidden:1,	Width:10,	Align:"Left",	ColMerge:0,	SaveName:"mainMenuCd", 	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"상위메뉴",			Type:"Text",		Hidden:1,	Width:10,	Align:"Left",	ColMerge:0,	SaveName:"priorMenuCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"메뉴",			Type:"Text",		Hidden:1,	Width:10,	Align:"Left",	ColMerge:0,	SaveName:"menuCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"순번",			Type:"Text",		Hidden:1,	Width:10,	Align:"Left",	ColMerge:0,	SaveName:"menuSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"선택",			Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"selectChk",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"메뉴/프로그램명",	Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"menuNm",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, TreeCol:1  },
			{Header:"프로그램",			Type:"Text",		Hidden:1,	Width:10,	Align:"Left",	ColMerge:0,	SaveName:"prgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}"); sheet1.SetVisible(true); sheet1.SetCountPosition(4); sheet1.SetUnicodeByte(3);
		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": sheet1.DoSearch( "${ctx}/MainMuPrg.do?cmd=getMainMuPrgList", $("#sheet1Form").serialize() + "&excludeTab=Y" ); break;
			case "Add"   :
				var count = 0;
				for(var i = 1 ; i <= sheet1.RowCount(); i++) {
					if( sheet1.GetCellValue(i, "selectChk") == "Y" ) {
						sheet1.SetCellValue(i,"sStatus", "U");
						count++;
					}
				}
				
				if(count == 0) {
					alert("등록 대상 메뉴를 선택해주십시오.");
				} else {
					IBS_SaveName(document.sheet1DataForm,sheet1);
					sheet1.DoSave( "${ctx}/RelMainMnPrgMgr.do?cmd=addRelMainMnPrgMgr" , $("#sheet1DataForm").serialize()); break;
				}
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
 		try{
			if (Msg != ""){
				alert(Msg);
			}
			
			sheet1.SetRowEditable(1, false);
			sheet1.ShowTreeLevel(-1);
			sheet1.SetRowEditable(1,false);
			
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "")alert(Msg);
			doAction1('Search');
			doAction2('Search');
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function initSheet2() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"상태",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			// SHOW
			{Header:"메인메뉴",				Type:"Combo", Hidden:0, Width:80,  Align:"Center", ColMerge:0, SaveName:"relMainMenuCd", KeyField:0, Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0 },
			{Header:"메뉴/프로그램명",		Type:"Text",  Hidden:0, Width:300, Align:"Left",   ColMerge:0, SaveName:"menuNm",        KeyField:0, Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0 },
			{Header:"프로그램",				Type:"Text",  Hidden:1, Width:80,  Align:"Left",   ColMerge:0, SaveName:"prgCd",         KeyField:0, Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0 },
			{Header:"순서",				Type:"Int",   Hidden:0, Width:40,  Align:"Center", ColMerge:0, SaveName:"seq",           KeyField:0, Format:"Integer", PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:20 },
			// HIDDEN
			{Header:"메인메뉴",				Type:"Text",  Hidden:1, WSaveName:"mainMenuCd"         },
			{Header:"상위프로그램",			Type:"Text",  Hidden:1, SaveName:"priorMenuCd"        },
			{Header:"메뉴코드",				Type:"Text",  Hidden:1, SaveName:"menuCd"             },
			{Header:"메뉴SEQ",			Type:"Text",  Hidden:1, SaveName:"menuSeq"            },
			{Header:"연관메뉴-상위프로그램",	Type:"Text",  Hidden:1, SaveName:"relPriorMenuCd"     },
			{Header:"연관메뉴-메뉴코드",		Type:"Text",  Hidden:1, SaveName:"relMenuCd"          },
			{Header:"연관메뉴-메뉴SEQ",		Type:"Text",  Hidden:1, SaveName:"relMenuSeq"         },
			{Header:"연관메뉴-메뉴SEQ",		Type:"Text",  Hidden:1, SaveName:"relMenuDescription" }
		];
		IBS_InitSheet(sheet2, initdata);sheet1.SetEditable("${editable}"); sheet2.SetVisible(true); sheet2.SetCountPosition(4); sheet2.SetUnicodeByte(3);
		
		sheet2.SetColProperty("relMainMenuCd",  {ComboText:menuList[0], ComboCode:menuList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
	}
	
	//Sheet Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search": sheet2.DoSearch( "${ctx}/RelMainMnPrgMgr.do?cmd=getRelMainMnPrgMgrList", $("#sheet1DataForm").serialize() ); break;
			case "Save"  :
				IBS_SaveName(document.sheet1DataForm,sheet2);
				sheet2.DoSave( "${ctx}/RelMainMnPrgMgr.do?cmd=saveRelMainMnPrgMgr" , $("#sheet1DataForm").serialize()); break;
				break;
			case "SaveDesc" :
				var saveData = ajaxCall("${ctx}/RelMainMnPrgMgr.do?cmd=updateRelMainMnPrgMgrRelMenuDescription" , $("#sheet1DataForm").serialize() + "&" + $("#sheet2DataForm").serialize(), false);
				if( saveData != null && saveData != undefined ) {
					alert(saveData.Result.Message);
					if( saveData.Result.Code > -1 ) {
						doAction2('Search');
					}
				}
				break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
 		try{
			if (Msg != ""){
				alert(Msg);
			}
			
			if( isPreload ) {
				progressBar(false);
				isPreload = false;
			}
			
			$(window).smartresize(sheetResize); sheetInit();
		}catch(ex){alert("sheet2_OnSearchEnd Event Error : " + ex);}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "")alert(Msg);
			doAction2('Search');
		}catch(ex){
			alert("sheet2_OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀 선택시 이벤트
	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try{
			if( OldRow != NewRow ) {
				$("#relMainMenuCd").val(sheet2.GetCellValue(NewRow, "relMainMenuCd"));
				$("#relPriorMenuCd").val(sheet2.GetCellValue(NewRow, "relPriorMenuCd"));
				$("#relMenuCd").val(sheet2.GetCellValue(NewRow, "relMenuCd"));
				$("#relMenuSeq").val(sheet2.GetCellValue(NewRow, "relMenuSeq"));
				$("#relMenuDescription").val(sheet2.GetCellValue(NewRow, "relMenuDescription"));
			}
		}catch(ex){
			alert("sheet2_OnSelectCell Event Error " + ex);
		}
	}

</script>
</head>
<body>
<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li>[<span id="spanMenuNm">&nbsp;</span>] 도움말 등록</li>
			<li class="close"></li>
		</ul>
	</div>
	<div class="popup_main">
		<div id="tabs" class="tab" style="min-height: calc(100vh - 150px);">
			<ul class="outer">
				<li><a href="#tabs-1">도움말</a></li>
				<li><a href="#tabs-2">첨부파일</a></li>
				<li><a href="#tabs-3">연관메뉴</a></li>
			</ul>
			<div id="tabs-1">
				<div class='layout_tabs overflow_hide_y'>
					<form id="srchFrm" name="srchFrm" method="post">
						<input type=hidden id="searchPrgCd"	name="searchPrgCd" value=""/>
						<input type=hidden id="fileSeq"		name="fileSeq" />
						<input type=hidden id="height"		name="height" value="180"/>
						<table class="sheet_main">
							<colgroup>
								<col width="*" />
								<col width="20px" />
								<col width="*" />
							</colgroup>
							<tr>
								<td class="valignT">
									<ul>
										<li class="bd_top_solid bg_gray_e">
											<div class="sheet_title mal5">
												<ul>
													<li id="txt" class="txt">
														<tit:txt mid='mngHelfTitle' mdef='담당자용 도움말' />
													</li>
													<li class="btn h15" style="line-height: 18px;">
														<input type="checkbox" id="mgrHelpYn" name="mgrHelpYn" class="${readonly}" ${disabled} value="Y" />
														<label for="mgrHelpYn" class="valignM">사용여부</label>
													</li>
												</ul>
											</div>
										</li>
										<li id="area_ifrm1" class="bd_top_solid">
											<div class="include mat10 mal5 bg_white">
												<input type="hidden" id="mgrHelp" name="mgrHelp" />
												<iframe id="ifrm1" name="ifrm1" width="99%" height="700" style="border:0px;"></iframe>
											</div>
										</li>
									</ul>
								</td>
								<td></td>
								<td class="valignT">
									<ul>
										<li class="bd_top_solid bg_gray_e">
											<div class="sheet_title mal5">
												<ul>
													<li id="txt" class="txt"><tit:txt mid='userHelfTitle' mdef='직원용 도움말'/></li>
													<li class="btn h15" style="line-height: 18px;">
														<input type="checkbox" id="empHelpYn" name="empHelpYn" class="${readonly}" ${disabled} value="Y" />
														<label for="empHelpYn" class="valignM">사용여부</label>
													</li>
												</ul>
											</div>
										</li>
										<li class="bd_top_solid">
											<div class="include mat10 mal5 bg_white">
												<input type="hidden" id="empHelp" name="empHelp" />
												<iframe id="ifrm2" name="ifrm2" width="99%" height="700" style="border:0px;"></iframe>
											</div>
										</li>
									</ul>
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
			<div id="tabs-2">
				<div class='layout_tabs'>
					<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>
				</div>
			</div>
			<div id="tabs-3">
				<div class='layout_tabs'>
					<table class="sheet_main">
						<colgroup>
							<col width="25%" />
							<col width="4%" />
							<col width="39%" />
							<col width="32%" />
						</colgroup>
						<tr>
							<td class="valignT">
								<div class="outer">
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">메인메뉴 프로그램</li>
											<li class="btn">
												<form id="sheet1Form" name="sheet1Form" >
													<input type="hidden" id="mainMenuNm" name="mainMenuNm" />
													<select id="mainMenuCd" name="mainMenuCd"> </select>
												</form>
											</li>
										</ul>
									</div>
								</div>
								<form method="post" id="sheet1DataForm" name="sheet1DataForm">
									<input type="hidden" id="searchMainMenuCd"  name="searchMainMenuCd"  />
									<input type="hidden" id="searchPriorMenuCd" name="searchPriorMenuCd" />
									<input type="hidden" id="searchMenuCd"      name="searchMenuCd"      />
									<input type="hidden" id="searchMenuSeq"     name="searchMenuSeq"     />
								</form>
								<script type="text/javascript">createIBSheet("sheet1", "27%", "580px","kr"); </script>
							</td>
							<td align=center>
								<a href="javascript:doAction1('Add');"><img src="/common/images/common/arrow_right1.gif"/></a>
							</td>
							<td class="valignT">
								<div class="outer">
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">연관메뉴</li>
											<li class="btn">
												<btn:a href="javascript:doAction2('Search');" mid="110697" mdef="조회" css="basic"/>
												<btn:a href="javascript:doAction2('Save');"   mid="110708" mdef="저장" css="basic authA"/>
											</li>
										</ul>
									</div>
								</div>
								<script type="text/javascript">createIBSheet("sheet2", "39%", "580px","kr"); </script>
							</td>
							<td class="valignT padl15">
								<form method="post" id="sheet2DataForm" name="sheet2DataForm">
									<input type="hidden" id="relMainMenuCd"     name="relMainMenuCd"     />
									<input type="hidden" id="relPriorMenuCd"    name="relPriorMenuCd"    />
									<input type="hidden" id="relMenuCd"         name="relMenuCd"         />
									<input type="hidden" id="relMenuSeq"        name="relMenuSeq"        />
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">메뉴 설명</li>
											<li class="btn">
												<btn:a href="javascript:doAction2('SaveDesc');" mid="110708" mdef="설명 저장" css="basic authA"/>
											</li>
										</ul>
									</div>
									<textarea id="relMenuDescription" name="relMenuDescription" rows="36" class="${textCss} w100p" style="height: 580px;"></textarea>
								</form>
							</td>
						</tr>
					</table>
				</div>
			</div>
		</div>
		
		<div class="popup_button outer bd_top_solid point_bg_lite pad-y-15 pos_fix" style="left: 0px; bottom: 0px; z-index: 100;">
			<ul>
				<li>
					<btn:a href="javascript:doSave();"		css="pink large authA" mid='110708' mdef="저장"/>
					<btn:a href="javascript:p.self.close();"	css="gray large" mid='110881' mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
