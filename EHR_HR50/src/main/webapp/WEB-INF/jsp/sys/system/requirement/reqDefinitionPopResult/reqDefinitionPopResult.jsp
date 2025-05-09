<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>테스트관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		$("input[type='text']").keydown(function(event){
			if(event.keyCode == 27){
				return false;
			}
		});

//=========================================================================================================================================

		let searchMainMenuCd  = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrMainMenuCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");//메뉴코드
		let searchGrpCd       = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionMgrGrpCdList",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");//메뉴코드
		let searchProSecCd    = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99992"), "");//처리상태(S99992)
		let searchProNameList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","S99997"), "<tit:txt mid='103895' mdef='전체'/>");//모듈코드(S99995)
		let searchEnterCd       = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReqDefinitionPopMgrEnterCdList&",false).codeList, "<tit:txt mid='103895' mdef='전체'/>");//메뉴코드

		$("#searchEnterCd").html(searchEnterCd[2]);
		$("#searchMainMenuCd").html(searchMainMenuCd[2]);
		$("#searchGrpCd").html(searchGrpCd[2]);
		$("#searchProSecCd").html(searchProSecCd[2]+"<option value='empty'>미입력</option>");
		$("#searchProSecCd").select2({placeholder:"<tit:txt mid='103895' mdef='전체'/>"});
		$("#searchProName").html(searchProNameList[2]);
		
//========================================================================================================================================

		var sheetHidden = "${ ssnErrorAdminYn eq 'Y' ? 0 : 1 }";

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:100,MergeSheet:msAll/* , FrozenCol:10 */, FrozenColRight:1};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='enterCd' mdef='회사명'/>",					Type:"Combo",		Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"메인메뉴",					Type:"Combo",		Hidden:0,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"mainMenuCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"상위메뉴코드",				Type:"Text",		Hidden:1,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"priorMenuCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"상위메뉴명",				Type:"Text",		Hidden:0,			Width:140,	Align:"Left",	ColMerge:0,	SaveName:"priorMenuNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"메뉴코드",					Type:"Text",		Hidden:1,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"menuCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='prgNmV2' mdef='메뉴명'/>",					Type:"PopupEdit",	Hidden:0,			Width:130,	Align:"Left",	ColMerge:0,	SaveName:"menuNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"메뉴SEQ",				Type:"Int",			Hidden:1,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"menuSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"권한",					Type:"Combo",		Hidden:0,			Width:100,	Align:"Left",	ColMerge:0,	SaveName:"grpCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>",					Type:"Text",		Hidden:1,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seqNo",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='prgCd_V6500' mdef='프로그램ID'/>",				Type:"Text",		Hidden:1,			Width:250,	Align:"Left",	ColMerge:0,	SaveName:"prgCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"등록내용",					Type:"Text",		Hidden:0,			Width:400,	Align:"Left",	ColMerge:0,	SaveName:"regNote",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000, MultiLineText:1, Wrap:1, ToolTip:0 },
			{Header:"<sht:txt mid='chkId' mdef='등록자'/>",					Type:"Text",		Hidden:0,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"regName",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='chkdate' mdef='등록일'/>",					Type:"Text",		Hidden:0,			Width:100,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"등록구분",					Type:"Text",		Hidden:0,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"regSecNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"등록구분",					Type:"Text",		Hidden:1,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"regSecCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"처리상태",					Type:"Text",		Hidden:1,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"proSecCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"처리상태",					Type:"Text",		Hidden:0,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"proSecNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"첨부파일",			Type:"Html",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"첨부번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='bigo_V5697' mdef='처리내용'/>",					Type:"Text",		Hidden:0,			Width:250,	Align:"Left",	ColMerge:0,	SaveName:"proNote",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4000, MultiLineText:1, Wrap:1, ToolTip:0 },
			{Header:"<sht:txt mid='applYmd_V5706' mdef='처리일'/>",					Type:"Text",		Hidden:0,			Width:100,	Align:"Center",	ColMerge:0,	SaveName:"proYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='chkdateV2' mdef='최종수정시간'/>",				Type:"Text",		Hidden:1,			Width:150,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"최종수정자",				Type:"Text",		Hidden:1,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chkid",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"처리자",					Type:"Text",		Hidden:0,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"proName",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"surl",					Type:"Text",		Hidden:1,			Width:80,	Align:"Center",	ColMerge:0,	SaveName:"surl",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }

		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetDataLinkMouse("menuNm", 1);
		sheet1.SetColProperty("mainMenuCd", 	{ComboText:"|"+searchMainMenuCd[0], 	ComboCode:"|"+searchMainMenuCd[1]} );
		sheet1.SetColProperty("grpCd", 			{ComboText:"|"+searchGrpCd[0], 			ComboCode:"|"+searchGrpCd[1]} );
		sheet1.SetColProperty("proSecCd", 		{ComboText:"|"+searchProSecCd[0], 		ComboCode:"|"+searchProSecCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		$("#searchMenuNm, #searchRegName, #searchProName").bind("keyup",function(event){
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
						sheet1.RemoveAll();
						$("#multiProSecCd").val(getMultiSelect($("#searchProSecCd").val()));
						sheet1.DoSearch( "${ctx}/ReqDefinitionPopMgr.do?cmd=getReqDefinitionPopMgrList", $("#sendForm").serialize() );

						break;
		case "Save":
						//if(!dupChk(sheet1,"mainMenuCd|priorMenuCd|menuCd|menuSeq|grpCd|seqNo", true, true)){break;}
						IBS_SaveName(document.sendForm,sheet1);
						sheet1.DoSave( "${ctx}/ReqDefinitionPopMgr.do?cmd=saveReqDefinitionPopMgr", $("#sendForm").serialize());
						break;
		case "Insert":
						var row = sheet1.DataInsert(0);
						break;
		case "Copy":
						var row = sheet1.DataCopy();
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"40"};
						sheet1.Down2Excel(param);

						break;
		case "LoadExcel":
						var params = {Mode:"HeaderMatch", WorkSheetNo:1};
						sheet1.LoadExcel(params);
						break;
		case "DownTemplate":
						sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0", DownCols:"",ExcelFontSize:"9",ExcelRowHeight:"40"});
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

	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		try{
			var sSaveName = sheet1.ColSaveName(Col);
			//처리상태 변경시 처리일자 오늘로 적용
			if(sSaveName == "proSecCd"){
				if(Value.length){
					sheet1.SetCellValue(Row, "proYmd", "${curSysYyyyMMdd}");
				}
			}
		}catch(ex){alert("OnChange Event Error : " + ex);}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {

			if(sheet1.ColSaveName(Col) == "menuNm") {

				if(!isPopup()) {return;}
				if(Row = 0){return;}

				var args    = new Array();
				//gPRow = Row;
				gPRow = sheet1.GetSelectRow();
				pGubun = "searchMenuNmPopup";

				openPopup("/ReqDefinitionMgr.do?cmd=viewReqDefinitionMgrPop", args, "780","520");
			}

		} catch(ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// row 더블클릭시 발생
	function sheet1_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {

			if(sheet1.ColSaveName(Col) == "menuNm") {
				var title = sheet1.GetCellValue(Row, "menuNm");
				var url = sheet1.GetCellValue(Row, "prgCd");
				var location = sheet1.GetCellText(Row, "mainMenuCd") + " > " + sheet1.GetCellValue(Row, "priorMenuNm") + " > " + sheet1.GetCellValue(Row, "menuNm");
				var surl = sheet1.GetCellValue(Row, "surl");
				
				parent.openContent(title, url, location, surl);
			}

		} catch(ex) {
			alert("OnDblClick Event Error : " + ex);
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

	function getMonthEndDate(year, month) {
		var dt = new Date(year, month, 0);
		return dt.getDate();
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "btnFile" && Value != ""){
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}
					fileMgrPopup(Row, Col);
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 파일첨부/다운로드 팝입
	function fileMgrPopup(Row, Col) {
		let layerModal = new window.top.document.LayerModal({
			id : 'fileMgrLayer'
			, url : '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&uploadType=contact&authPg=R'
			, parameters : {
				fileSeq : sheet1.GetCellValue(Row,"fileSeq")
			}
			, width : 740
			, height : 420
			, title : '파일 업로드'
			, trigger :[
				{
					name : 'fileMgrTrigger'
					, callback : function(result){

					}
				}
			]
		});
		layerModal.show();
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sendForm" id="sendForm" method="post">
	<input type="hidden" id="multiProSecCd" name="multiProSecCd" value="empty" />
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<td class="${ ssnErrorAdminYn eq 'Y' ? 'show' : 'hide' }">
				<span><tit:txt mid='104371' mdef='회사명'/></span>
				<input id="searchEnterCd" name="searchEnterCd" value='${ssnEnterCd}' type="text" class="text" style="ime-mode:active;" readonly/>
			</td>
			<td>
				<span><tit:txt mid='113332' mdef='메인메뉴'/></span>
				<select id="searchMainMenuCd" name="searchMainMenuCd" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td>
				<span>등록구분</span>
				<select id="searchRegSecCd" name="searchRegSecCd" value="A" class="box">
					<option value="A">오류</option>
				</select>
			</td>
			<td>
				<span>권한</span>
				<input id="searchGrpCd" name="searchGrpCd" type="text" class="text"  value="${ssnGrpCd}" style="ime-mode:active; display: none;"/>
				<input id="searchGrpNm" name="searchGrpNm" type="text" class="text"  value="${ssnGrpNm}" readonly disabled/>
			</td>
		</tr>
		<tr>
			<td>
				<span><tit:txt mid='104233' mdef='메뉴명'/></span>
				<input id="searchMenuNm" name="searchMenuNm" type="text" class="text" style="ime-mode:active;" />
			</td>
			<td>
				<span>등록자</span>
				<input id="regName" name="regName" value="${ssnName}" type="text" class="text" style="ime-mode:active;" readonly disabled/>
				<input id="searchRegName" name="searchRegName" value="${ssnSabun}" type="text" class="text" style="ime-mode:active; display: none;"/>
			</td>
			<td>
				<span>처리자</span>
				<select id="searchProName" name="searchProName" class="box" onchange="javascript:doAction1('Search');"></select>
			</td>
			<td>
				<span><tit:txt mid='112641' mdef='처리상태'/></span>
				<select id="searchProSecCd" name="searchProSecCd" class="box" onchange="javascript:doAction1('Search');" multiple ></select>
			</td>
			<td>
				<a href="javascript:doAction1('Search');" class="button"><tit:txt mid='104081' mdef='조회'/></a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt">테스트관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 		class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
