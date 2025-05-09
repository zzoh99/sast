
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var result = convCode( codeList("/AiEmpRcmd.do?cmd=getAiEmpRcmdGubunList"), "<tit:txt mid='103895' mdef='전체'/>");
		$("#empRcmdType").html(result[2]);

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:4, SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0},
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0},
			{Header:"<sht:txt mid='rGubun' mdef='인재추천구분'/>",		Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"rGubun",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100, Edit:1 },
			{Header:"<sht:txt mid='rPrompt' mdef='프롬프트'/>",			Type:"Image",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"detail",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1},
			{Header:"<sht:txt mid='useYn' mdef='사용여부'/>",			Type:"CheckBox",	Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1,	TrueValue:"Y",	FalseValue:"N" },
		];IBS_InitSheet(sheet1, initdata1);sheet1.SetCountPosition(0);
		// IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);

		// 세부내역 Image setting 및 mouseover 시 cursor 변경
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);

		var initdata2 = {};
		initdata2.Cfg = {FrozenCol:4, SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='seq' mdef='SEQ'/>",				Type:"Text",		Hidden:1,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"seq",	UpdateEdit:0,	InsertEdit:0,	KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	EditLen:500, Edit: 0 },
			{Header:"<sht:txt mid='iGubun' mdef='점수구분명'/>",		Type:"Combo",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"iGubun",		UpdateEdit:0,	InsertEdit:1,	KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	EditLen:500, Edit: 1 },
			{Header:"<sht:txt mid='iRatio' mdef='가중치'/>",			Type:"Text",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"iRatio",		UpdateEdit:1,	InsertEdit:1,	KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	EditLen:500, Edit: 1 },
			{Header:"<sht:txt mid='memo' mdef='추가 커맨트'/>",		Type:"Text",		Hidden:0,					Width:100, 			Align:"Center",	ColMerge:0,	SaveName:"memo",		UpdateEdit:1, 	InsertEdit:1,	KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	EditLen:500, Edit: 1 },
			{Header:"<sht:txt mid='searchDesc' mdef='조건검색'/>",	Type:"PopupEdit",	Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"searchDesc",	UpdateEdit:1,	InsertEdit:1,	KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	EditLen:500, Edit: 1 },
			{Header:"<sht:txt mid='searchSeq' mdef='검색설명코드'/>",	Type:"Text",      	Hidden:1,  					Width:80,   		Align:"Center", ColMerge:0, SaveName:"searchSeq",   UpdateEdit:1,   InsertEdit:1,   KeyField:0,   	CalcLogic:"",   Format:"",  PointCount:0,   EditLen:10 },
			{Header:"<sht:txt mid='icon' mdef='Icon'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"icon",	UpdateEdit:1,	InsertEdit:1,	KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	EditLen:500, Edit: 1 },
			{Header:"<sht:txt mid='preview' mdef='미리보기'/>",		Type:"Html",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"preview",	UpdateEdit:0,	InsertEdit:0,	KeyField:0,		CalcLogic:"",	Format:"",	PointCount:0,	EditLen:500, Edit: 1 },
		];
// 		sheetSplice(initdata.Cols,7,	"${localeCd2}",	"세부코드명",	true);
		IBS_InitSheet(sheet2, initdata2);sheet2.SetCountPosition(0);

		//공통코드 한번에 조회
		var grpCds = "H88100";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, "");
		sheet2.SetColProperty("iGubun",  	{ComboText:"|"+codeLists["H88100"][0], ComboCode:"|"+codeLists["H88100"][1]} );

 		$(window).smartresize(sheetResize);
		sheetInit();sheetResize();

		doAction1("Search");
	});

	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			$('#rGubun').val($('#empRcmdType :selected').val())
			sheet1.DoSearch( "${ctx}/AiEmpRcmdMgr.do?cmd=getAiEmpRcmdMgrType", $("#sheet1Form").serialize());
			break;
		case "Save":
			IBS_SaveName(document.sheet1Form, sheet1);
			sheet1.DoSave("${ctx}/AiEmpRcmdMgr.do?cmd=saveAiEmpRcmdMgrType", $("#sheet1Form").serialize() );
			doAction1("Search");
		    break;
		case "Insert":      sheet1.SelectCell(sheet1.DataInsert(0), 2); break;
		case "Copy":		sheet1.DataCopy();break;
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch("${ctx}/AiEmpRcmdMgr.do?cmd=getAiEmpRcmdMgrScoreInfo", $("#sheet1Form").serialize());

			break;
		case "Save":
			var message = '';

			// 필수값/유효성 체크
			if (!chkInVal()) {
				break;
			}
			var rowCnt = sheet2.RowCount();
			for (var i=1; i<=rowCnt; i++) {
				//폰트 생성 및 적용
				if(sheet2.GetCellValue(i, "icon")) {
					sheet2.SetCellValue(i, "preview", '<i class="mdi-ico">'+sheet2.GetCellValue(i, "icon")+'</i>');
				}else{
					sheet2.SetCellValue(i, "preview", '');
				}
			}
			IBS_SaveName(document.sheet1Form, sheet2);
			sheet2.DoSave("${ctx}/AiEmpRcmdMgr.do?cmd=saveAiEmpRcmdMgrScoreInfo", $("#sheet1Form").serialize());
			// doAction2("Search");
            break;
			case "Insert":      sheet2.SelectCell(sheet2.DataInsert(0), 2); break;
			case "Copy":		sheet2.DataCopy();break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
		console.log('sheet1_OnSearchEnd');
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	//  저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }

		doAction2("Search");
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		if(OldRow == NewRow || sheet1.GetCellValue(NewRow, "sStatus") == "I") return;
		$("#rGubun").val( sheet1.GetCellValue(NewRow, "rGubun") );
		if( OldRow != NewRow ){
			doAction2("Search");
		}
	}

	function sheet1_OnClick(Row, Col, Value){
		try {
			if( sheet1.ColSaveName(Col) == "detail" ) {
				showApplPopup(Row);
			}
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	// LEFT 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			// <i class="mdi-ico">assignment_ind</i>
			// <i class="mdi-ico">badge</i>
			if (Msg != "") { alert(Msg); } sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// RIGHT 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg);} if( Number(Code) > 0){doAction2("Search");} } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function sheet2_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		selectSheet = sheet2;
	}

	function sheet2_OnPopupClick(Row, Col){
		try{
			var colName = sheet2.ColSaveName(Col);

			if(colName == "searchDesc") {
				let layerModal = new window.top.document.LayerModal({
					id : 'pwrSrchMgrLayer'
					, url : '/Popup.do?cmd=viewPwrSrchMgrLayer&authPg=R'
					, parameters : {
						searchSeq : sheet2.GetCellValue(Row, "searchSeq")
						, searchDesc : sheet2.GetCellValue(Row, "searchDesc")
					}
					, width : 1100
					, height : 520
					, title : '<tit:txt mid='112392' mdef='조건 검색 관리'/>'
					, trigger :[
						{
							name : 'pwrTrigger'
							, callback : function(result){
								// sheet2.SetCellValue(Row, "seq",   result.searchSeq);
								sheet2.SetCellValue(Row, "searchSeq",   result.searchSeq);
								sheet2.SetCellValue(Row, "searchDesc", result.searchDesc);
							}
						}
					]
				});
				layerModal.show();
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function sheet2_OnChange(Row, Col, Value){
		try {
		} catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	// 셀 팝업 클릭 시
	function showApplPopup(Row) {
		try {
			var rv = null;

			if(!isPopup()) {return;}
			var args 	= new Array();
			args["rGubun"] 		= sheet1.GetCellValue(Row, "rGubun");
			let layerModal = new window.top.document.LayerModal({
				id : 'aiEmpRcmdMgrLayer'
				, url : '/AiEmpRcmdMgr.do?cmd=viewAiEmpRcmdMgrLayer'
				, parameters : args
				, width : 600
				, height : 400
				, title : '프롬프트'
				, trigger :[
					{
						name : 'aiEmpRcmdMgrLayerTrigger'
						, callback : function(result){
							console.log(result)
						}
					}
				]
			});
			layerModal.show();

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//팝업 콜백 함수
	function getReturnValue(rv) {
		console.log(rv);
	}

	function chkInVal() {
		// 유효성 체크
		var rowCnt = sheet2.RowCount();
		for (var i=1; i<=rowCnt; i++) {
			if (sheet2.GetCellValue(i, "sStatus") == "I" || sheet2.GetCellValue(i, "sStatus") == "U") {
				var seq = sheet2.GetCellValue(i, "seq");
				var searchSeq = sheet2.GetCellValue(i, "searchSeq");
				var iGubun = sheet2.GetCellValue(i, "iGubun");
				var iRatio = sheet2.GetCellValue(i, "iRatio");
				if(iGubun == null || iGubun == "") {
					alert("<msg:txt mid='iGubun' mdef='점수구분명을 입력하십시오.'/>");
					return false;
				}
				if(iRatio == null || iRatio == "") {
					alert("<msg:txt mid='iRatio' mdef='가중치를 입력하십시오.'/>");
					return false;
				}
				if(searchSeq == null || searchSeq == "") {
					alert("<msg:txt mid='seq' mdef='조건검색을 선택하십시오.'/>");
					return false;
				}
			}
		}

		return true;
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
		<input type="hidden" id="rGubun" name="rGubun" value="" />
		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><sch:txt mid='aiEmpRcmdMgr' mdef='AI인재추천 기준관리'/></li>
				</ul>
			</div>
			<div class="sheet_search ">
				<table>
					<colgroup>
						<col width="120px">
						<col width="260px">
						<col width="*">
					</colgroup>
					<tr>
						<th><sch:txt mid='empRcmdType' mdef='인재추천구분'/></th>
						<td>
							<select id="empRcmdType" name="empRcmdType" class="custom_select" style="width: 160px;">
								<option value="" selected><sch:txt mid='all' mdef='전체'/> </option>
							</select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" id="srchBtn"  mid="110697" mdef="조회" css="btn dark"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<table class="sheet_main">
		<colgroup>
			<col width="30%">
			<col width="70%">
		</colgroup>
		<tr>
			<td class="sheet_left">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='empRcmdType' mdef='추천구분'/></li>
							<li class="btn">
<%--								<btn:a href="javascript:doAction1('Delete');" id="Btn1" mid="110763" mdef="삭제" css="btn outline-gray authA"/>--%>
								<btn:a href="javascript:doAction1('Insert');" id="Btn1" mid="110700" mdef="입력" css="btn outline-gray authA"/>
								<btn:a href="javascript:doAction1('Copy');" id="Btn1" mid="110696" mdef="복사" css="btn outline-gray authA"/>
								<btn:a href="javascript:doAction1('Save');" id="Btn1" mid="110708" mdef="저장" css="btn filled authA"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "50%", "100%","${ssnLocaleCd}"); </script>
			</td>
			<td class="sheet_right">
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li class="txt">
								<p>
									<tit:txt mid='scoreInfo' mdef='점수화정보 '/>
									(Icon 참고 URL : <a class="link" href="https://fonts.google.com/icons" target="_blank">구글 디자인 아이콘</a>)
									<strong class="point-red">가중치의 합이 100</strong>이 되어야 추천 기능이 정상적으로 작동합니다.
								</p>
							</li>
							<li class="btn _hideArea">
<%--								<btn:a href="javascript:doAction2('Delete');" id="Btn1" mid="110763" mdef="삭제" css="btn outline-gray authA"/>--%>
								<btn:a href="javascript:doAction2('Insert');" id="Btn2" mid="110700" mdef="입력" css="btn outline-gray authA"/>
								<btn:a href="javascript:doAction2('Copy');" id="Btn2" mid="110696" mdef="복사" css="btn outline-gray authA"/>
								<btn:a href="javascript:doAction2('Save');" id="Btn2" mid="110708" mdef="저장" css="btn filled authA"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript"> createIBSheet("sheet2", "50%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
<%--	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">--%>
<%--		<tr>--%>
<%--			<td>--%>
<%--				<div class="inner">--%>
<%--					<div class="sheet_title">--%>
<%--					<ul>--%>
<%--						<li class="txt"><tit:txt mid='empRcmdType' mdef='추천구분'/></li>--%>
<%--						<li class="btn">--%>
<%--							<btn:a href="javascript:doAction1('Insert');" id="Btn1" mid="110700" mdef="입력" css="btn outline-gray authA"/>--%>
<%--							<btn:a href="javascript:doAction1('Copy');" id="Btn1" mid="110696" mdef="복사" css="btn outline-gray authA"/>--%>
<%--							<btn:a href="javascript:doAction1('Save');" id="Btn1" mid="110708" mdef="저장" css="btn outline-gray authA"/>--%>
<%--						</li>--%>
<%--					</ul>--%>
<%--					</div>--%>
<%--				</div>--%>
<%--				<script type="text/javascript"> createIBSheet("sheet1", "100%", "50%", "${ssnLocaleCd}"); </script>--%>
<%--			</td>--%>
<%--		</tr>--%>
<%--		<tr>--%>
<%--			<td>--%>
<%--				<div class="sheet_title inner">--%>
<%--				<ul>--%>
<%--					<li class="txt"><tit:txt mid='scoreInfo' mdef='점수화정보 '/></li>--%>
<%--					<li class="btn">--%>
<%--						<btn:a href="javascript:doAction2('Insert');" id="Btn2" mid="110700" mdef="입력" css="btn outline-gray authA"/>--%>
<%--						<btn:a href="javascript:doAction2('Copy');" id="Btn2" mid="110696" mdef="복사" css="btn outline-gray authA"/>--%>
<%--						<btn:a href="javascript:doAction2('Save');" id="Btn2" mid="110708" mdef="저장" css="btn outline-gray authA"/>--%>
<%--					</li>--%>
<%--				</ul>--%>
<%--				</div>--%>
<%--				<script type="text/javascript"> createIBSheet("sheet2", "100%", "50%", "${ssnLocaleCd}"); </script>--%>
<%--			</td>--%>
<%--		</tr>--%>
<%--	</table>--%>
</div>
</body>
</html>
