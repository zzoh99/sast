<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<script src="${ctx}/common/plugin/ckeditor5/ckeditor.js"></script>
<!DOCTYPE html><html><head><title><tit:txt mid='112673' mdef='도움말등록PopUp'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp" %>

<script type="text/javascript">
	var arg = null;
	var tabIdx;
	var isPreload = false;
	var menuList = null;

	$(function(){
		//TAB EVENT
		$('div#tabs ul.tab_bottom li').on('click', function() {
			$('div#tabs ul.tab_bottom li').removeClass('active');
			$(this).addClass('active');
			var index = $(this).index();
			tabIdx = index;
			$('div#tabs div.content').addClass('hide');
			$('div#tabs div.content:eq(' + index + ')').removeClass('hide');
		});
        const modal = window.top.document.LayerModalUtility.getModal('mainMuPrgLayer');
        arg =  modal.parameters;
        $("#searchPrgCd").val(arg.prgCd);
        $("#spanMenuNm").html( arg.menuNm );
        $("#searchMainMenuCd").val(arg.mainMenuCd);
        $("#searchPriorMenuCd").val(arg.priorMenuCd);
        $("#searchMenuCd").val(arg.menuCd);
        $("#searchMenuSeq").val(arg.menuSeq);
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
		doSearch();

		let titleTxt = "[" + arg.menuNm + "] 도움말 등록";
		$('#modal-mainMuPrgLayer').find('div.layer-modal-header span.layer-modal-title').text(titleTxt);

	});
	
	function doSearch(){
		try{
			var data = ajaxCall("${ctx}/MainMuPrg.do?cmd=getMainMuPrgPopMap",$("#srchFrm").serialize(),false);
			if(data.DATA == null){
				$('#modifyContents1').val("");
				$('#modifyContents2').val("");
			} else {
				$('#modifyContents1').val(nvlStr(data.DATA.mgrHelp));
				$('#modifyContents2').val(nvlStr(data.DATA.empHelp));

				if ( data.DATA.mgrHelpYn == "Y" )	$("#mgrHelpYn").attr("checked", true);
				else								$("#mgrHelpYn").attr("checked", false);

				if ( data.DATA.empHelpYn == "Y" )	$("#empHelpYn").attr("checked", true);
				else								$("#empHelpYn").attr("checked", false);

				$("#mgrHelp").val( nvlStr(data.DATA.mgrHelp) );
				$("#empHelp").val( nvlStr(data.DATA.empHelp) );
				$("#fileSeq").val(data.DATA.fileSeq);
			}

			callIframeBody("authorForm1", "authorFrame1");
			callIframeBody("authorForm2", "authorFrame2");

			initFileUploadIframe("mainMuPrgLayerUploadForm", $("#fileSeq").val(), "", "${authPg}");
			// 연관메뉴관리 세팅
			doAction1("Search");
			doAction2('Search');
			
		}catch(e){
			alert("doSearch Error:" + e);
		}
	}

	function doSave() {
		// ckReadySave("authorFrame");
		$("#mgrHelp").val(ckGetContent("authorFrame1"));
		$("#empHelp").val(ckGetContent("authorFrame2"));
		try{
			$("#srchFrm>#fileSeq").val(getFileUploadContentWindow("mainMuPrgLayerUploadForm").getFileSeq());

			var data = ajaxCall("${ctx}/MainMuPrg.do?cmd=saveMainMuPrgPop",$("#srchFrm").serialize(),false);
			alert(data.Result.Message);
			if(data.Result.Code != "-1"){
				const modal = window.top.document.LayerModalUtility.getModal('mainMuPrgLayer');
				modal.fire('mainMuPrgTrigger', {resuleCode: '1'}).hide();
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
		createIBSheet3(document.getElementById('mainMenuSheet-wrap'), "mainMenuSheet", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, DataRowMerge:0, ChildPage:5, AutoFitColWidth:'init|search|resize|rowtransaction'};
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
		IBS_InitSheet(mainMenuSheet, initdata);mainMenuSheet.SetEditable("${editable}"); mainMenuSheet.SetVisible(true); mainMenuSheet.SetCountPosition(4); mainMenuSheet.SetUnicodeByte(3);

		let sheetHeight = $('.modal_body').height() - $('.tab_bottom').height();
		mainMenuSheet.SetSheetHeight(sheetHeight);
	}
	
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search": mainMenuSheet.DoSearch( "${ctx}/MainMuPrg.do?cmd=getMainMuPrgList", $("#mainMenuSheetForm").serialize() + "&excludeTab=Y" ); break;
			case "Add"   :
				var count = 0;
				for(var i = 1 ; i <= mainMenuSheet.RowCount(); i++) {
					if( mainMenuSheet.GetCellValue(i, "selectChk") == "Y" ) {
						mainMenuSheet.SetCellValue(i,"sStatus", "U");
						count++;
					}
				}
				if(count == 0) {
					alert("등록 대상 메뉴를 선택해주십시오.");
				} else {
					IBS_SaveName(document.mainMenuSheetDataForm,mainMenuSheet);
					mainMenuSheet.DoSave( "${ctx}/RelMainMnPrgMgr.do?cmd=addRelMainMnPrgMgr" , $("#mainMenuSheetDataForm").serialize()); break;
				}
				break;
		}
	}

	// 조회 후 에러 메시지
	function mainMenuSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
 		try{
			if (Msg != ""){
				alert(Msg);
			}
			mainMenuSheet.SetRowEditable(1, false);
			mainMenuSheet.ShowTreeLevel(-1);
			mainMenuSheet.SetRowEditable(1,false);
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	// 저장 후 메시지
	function mainMenuSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "")alert(Msg);
			doAction1('Search');
			doAction2('Search');
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function initSheet2() {
		createIBSheet3(document.getElementById('relationSheet-wrap'), "relationSheet", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, DataRowMerge:0, ChildPage:5, AutoFitColWidth:'init|search|resize|rowtransaction'};
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
			{Header:"메인메뉴",				Type:"Text",  Hidden:1, SaveName:"mainMenuCd"         },
			{Header:"상위프로그램",			Type:"Text",  Hidden:1, SaveName:"priorMenuCd"        },
			{Header:"메뉴코드",				Type:"Text",  Hidden:1, SaveName:"menuCd"             },
			{Header:"메뉴SEQ",			Type:"Text",  Hidden:1, SaveName:"menuSeq"            },
			{Header:"연관메뉴-상위프로그램",	Type:"Text",  Hidden:1, SaveName:"relPriorMenuCd"     },
			{Header:"연관메뉴-메뉴코드",		Type:"Text",  Hidden:1, SaveName:"relMenuCd"          },
			{Header:"연관메뉴-메뉴SEQ",		Type:"Text",  Hidden:1, SaveName:"relMenuSeq"         },
			{Header:"연관메뉴-메뉴SEQ",		Type:"Text",  Hidden:1, SaveName:"relMenuDescription" }
		];
		IBS_InitSheet(relationSheet, initdata);relationSheet.SetEditable("${editable}"); relationSheet.SetVisible(true); relationSheet.SetCountPosition(4); relationSheet.SetUnicodeByte(3);
		relationSheet.SetColProperty("relMainMenuCd",  {ComboText:menuList[0], ComboCode:menuList[1]} );

		let sheetHeight = $('.modal_body').height() - $('.tab_bottom').height();
		relationSheet.SetSheetHeight(sheetHeight);
	}
	
	//Sheet Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search": relationSheet.DoSearch( "${ctx}/RelMainMnPrgMgr.do?cmd=getRelMainMnPrgMgrList", $("#mainMenuSheetDataForm").serialize() ); break;
			case "Save"  :
				IBS_SaveName(document.mainMenuSheetDataForm,relationSheet);
				relationSheet.DoSave( "${ctx}/RelMainMnPrgMgr.do?cmd=saveRelMainMnPrgMgr" , $("#mainMenuSheetDataForm").serialize()); break;
				break;
			case "SaveDesc" :
				var saveData = ajaxCall("${ctx}/RelMainMnPrgMgr.do?cmd=updateRelMainMnPrgMgrRelMenuDescription" , $("#mainMenuSheetDataForm").serialize() + "&" + $("#relationSheetDataForm").serialize(), false);
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
	function relationSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
 		try{
			if (Msg != ""){
				alert(Msg);
			}
			$(window).smartresize(sheetResize); sheetInit();
		}catch(ex){alert("relationSheet_OnSearchEnd Event Error : " + ex);}
	}

	// 저장 후 메시지
	function relationSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "")alert(Msg);
			doAction2('Search');
		}catch(ex){
			alert("relationSheet_OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀 선택시 이벤트
	function relationSheet_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try{
			if( OldRow != NewRow ) {
				$("#relMainMenuCd").val(relationSheet.GetCellValue(NewRow, "relMainMenuCd"));
				$("#relPriorMenuCd").val(relationSheet.GetCellValue(NewRow, "relPriorMenuCd"));
				$("#relMenuCd").val(relationSheet.GetCellValue(NewRow, "relMenuCd"));
				$("#relMenuSeq").val(relationSheet.GetCellValue(NewRow, "relMenuSeq"));
				$("#relMenuDescription").val(relationSheet.GetCellValue(NewRow, "relMenuDescription"));
			}
		}catch(ex){
			alert("relationSheet_OnSelectCell Event Error " + ex);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<div id="tabs" class="tab">
			<ul class="tab_bottom mb-16">
				<li class="active"><a href="#tabs-1">도움말</a></li>
				<li><a href="#tabs-2">첨부파일</a></li>
				<li><a href="#tabs-3">연관메뉴</a></li>
			</ul>
			<div id="tabs-1" class="content">
				<div>
					<form id="authorForm1" name="authorForm1">
						<input type="hidden" id="modifyContents1" name="modifyContents"	/>
						<input type="hidden" name="height" value="300" />
					</form>
					<form id="authorForm2" name="authorForm2">
						<input type="hidden" id="modifyContents2" name="modifyContents"	/>
						<input type="hidden" name="height" value="300" />
					</form>
					<form id="srchFrm" name="srchFrm" method="post">
						<input type=hidden id="searchPrgCd"	name="searchPrgCd" value=""/>
						<input type=hidden id="fileSeq"		name="fileSeq" />
						<input type=hidden id="height"		name="height" value="180"/>
						<input type="hidden" id="ckEditorContentArea" name="content">

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
													<li id="txt" class="txt mt-0">
														<tit:txt mid='mngHelfTitle' mdef='담당자용 도움말' />
													</li>
													<li class="btn h15">
														<input type="checkbox" id="mgrHelpYn" name="mgrHelpYn" class="form-checkbox type2 ${readonly}" ${disabled} value="Y" />
														<label for="mgrHelpYn" class="bg-none">사용여부</label>
													</li>
												</ul>
											</div>
										</li>
										<li id="area_ifrm1" class="bd_top_solid">
											<div class="include mat10 mal5 bg_white editor-container">
												<input type="hidden" id="mgrHelp" name="mgrHelp" />
												<iframe id="authorFrame1" name="authorFrame1" frameborder="0" class="author_iframe" style="height: 450px"></iframe>
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
													<li id="txt" class="txt mt-0"><tit:txt mid='userHelfTitle' mdef='직원용 도움말'/></li>
													<li class="btn h15">
														<input type="checkbox" id="empHelpYn" name="empHelpYn" class="form-checkbox type2 ${readonly}" ${disabled} value="Y" />
														<label for="empHelpYn" class="bg-none">사용여부</label>
													</li>
												</ul>
											</div>
										</li>
										<li class="bd_top_solid">
											<div class="include mat10 mal5 bg_white editor-container">
												<input type="hidden" id="empHelp" name="empHelp" />
												<iframe id="authorFrame2" name="authorFrame2" frameborder="0" class="author_iframe" style="height: 450px"></iframe>
											</div>
										</li>
									</ul>
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
			<div id="tabs-2" class="content hide">
				<div>
					<iframe id="mainMuPrgLayerUploadForm" name="mainMuPrgLayerUploadForm" frameborder="0" class="author_iframe" style="height:200px;"></iframe>
				</div>
			</div>
			<div id="tabs-3" class="content hide">
				<div>
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
												<form id="mainMenuSheetForm" name="mainMenuSheetForm" >
													<input type="hidden" id="mainMenuNm" name="mainMenuNm" />
													<select id="mainMenuCd" name="mainMenuCd"> </select>
												</form>
											</li>
										</ul>
									</div>
								</div>
								<form method="post" id="mainMenuSheetDataForm" name="mainMenuSheetDataForm">
									<input type="hidden" id="searchMainMenuCd"  name="searchMainMenuCd"  />
									<input type="hidden" id="searchPriorMenuCd" name="searchPriorMenuCd" />
									<input type="hidden" id="searchMenuCd"      name="searchMenuCd"      />
									<input type="hidden" id="searchMenuSeq"     name="searchMenuSeq"     />
								</form>
								<!-- <script type="text/javascript">createIBSheet("mainMenuSheet", "27%", "580px","kr"); </script> -->
								<div id="mainMenuSheet-wrap"></div>
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
												<btn:a href="javascript:doAction2('Save');"   mid="110708" mdef="저장" css="btn filled authA"/>
												<btn:a href="javascript:doAction2('Search');" mid="110697" mdef="조회" css="btn dark"/>
											</li>
										</ul>
									</div>
								</div>
								<!-- <script type="text/javascript">createIBSheet("relationSheet", "39%", "580px","kr"); </script>-->
								<div id="relationSheet-wrap"></div>
							</td>
							<td class="valignT padl15">
								<form method="post" id="relationSheetDataForm" name="relationSheetDataForm">
									<input type="hidden" id="relMainMenuCd"     name="relMainMenuCd"     />
									<input type="hidden" id="relPriorMenuCd"    name="relPriorMenuCd"    />
									<input type="hidden" id="relMenuCd"         name="relMenuCd"         />
									<input type="hidden" id="relMenuSeq"        name="relMenuSeq"        />
									<div class="sheet_title">
										<ul>
											<li id="txt" class="txt">메뉴 설명</li>
											<li class="btn">
												<btn:a href="javascript:doAction2('SaveDesc');" mid="110708" mdef="설명 저장" css="btn filled authA"/>
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
	</div>
	<div class="modal_footer">
		<btn:a href="javascript:doSave();"		css="btn filled" mid='110708' mdef="저장"/>
		<btn:a href="javascript:closeCommonLayer('mainMuPrgLayer');"	css="btn outline_gray" mid='110881' mdef="닫기"/>
	</div>
</div>
</body>
</html>
