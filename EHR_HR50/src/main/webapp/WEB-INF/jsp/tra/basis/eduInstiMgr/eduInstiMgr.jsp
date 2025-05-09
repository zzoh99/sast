<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='fileCnt' mdef='파일'/>",			Type:"Image",		Hidden:1,	Width:45,	Align:"Center",	ColMerge:0,	SaveName:"fileCnt",	UpdateEdit:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",		Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"detail",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eduOrgCdV1' mdef='교육기관코드'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='eduOrgNmV1' mdef='교육기관명'/>",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"eduOrgNm",		KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='nationalCdV3' mdef='국가코드'/>",		Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"nationalCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='zip' mdef='우편번호'/>",		Type:"Popup",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"zip",				KeyField:0,	CalcLogic:"",	Format:"PostNo",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
			{Header:"<sht:txt mid='addr' mdef='주소'/>",			Type:"Text",		Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"curAddr1",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:500 },
			{Header:"<sht:txt mid='addr2' mdef='상세주소'/>",		Type:"Text",		Hidden:1,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"curAddr2",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:500 },
			{Header:"<sht:txt mid='bigoV1' mdef='교육기관특성'/>",		Type:"Text",		Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"bigo",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='chargeNameV2' mdef='담당자'/>",			Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"chargeName",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='orgNmV10' mdef='소속명'/>",			Type:"Text",		Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='telNoV4' mdef='전화'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"telNo",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='handPhoneV2' mdef='핸드폰'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"telHp",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='faxNoV2' mdef='팩스'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"faxNo",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13 },
			{Header:"<sht:txt mid='email' mdef='E-mail주소'/>",		Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"email",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:50 },
			{Header:"<sht:txt mid='companyNum' mdef='사업자등록번호'/>",	Type:"Text",		Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"companyNum",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:20, AcceptKeys:"N|[-]" },
			{Header:"<sht:txt mid='companyHead' mdef='대표자명'/>",		Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"companyHead",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='businessPart' mdef='업태'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessPart",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"<sht:txt mid='businessType' mdef='종목'/>",			Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"businessType",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:40 },
			{Header:"<sht:txt mid='accountNo' mdef='계좌번호'/>",		Type:"Text",		Hidden:0,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"bankNum",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='bankCd' mdef='은행명'/>",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bankCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:20 },
			{Header:"<sht:txt mid='fileSeqV3' mdef='FILESEQ'/>",		Type:"Text",		Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"fileSeq",	UpdateEdit:0 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		var nationalCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), "");	//소재국가
		var bankCdList 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "");	//은행구분
		
		sheet1.SetColProperty("nationalCd",	{ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );	//소재국가
		sheet1.SetColProperty("bankCd",		{ComboText:"|"+bankCdList[0], ComboCode:"|"+bankCdList[1]} );	//은행구분
		
		$("#searchEduOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchEduEnterCd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		sheet1.SetDataLinkMouse("detail", 1);
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회

			sheet1.DoSearch("${ctx}/EduInstiMgr.do?cmd=getEduInstiMgrList", $("#srchFrm").serialize());
			break;
		case "Save": //저장

			IBS_SaveName(document.srchFrm, sheet1);
			sheet1.DoSave("${ctx}/EduInstiMgr.do?cmd=saveEduInstiMgr", $("#srchFrm").serialize());
			break;

		case "Insert": //입력

			var Row = sheet1.DataInsert(0);
			sheet1.SetCellValue(Row, "nationalCd", "001");
			eduInstiMgrPopup(Row);
			break;

		case "Copy": //행복사

			var Row = sheet1.DataCopy();

			sheet1.SetCellValue(Row, "eduOrgCd", "");
			eduInstiMgrPopup(Row);

			break;

		case "Clear": //Clear

			sheet1.RemoveAll();
			break;

		case "Down2Excel": //엑셀내려받기

			sheet1.Down2Excel({ DownCols : makeHiddenSkipCol(sheet1), SheetDesign : 1, Merge : 1 });
			break;

		case "LoadExcel": //엑셀업로드

			var params = { Mode : "HeaderMatch", WorkSheetNo : 1 };
			sheet1.LoadExcel(params);
			break;

		}
	}

	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				alert(ErrMsg);
			}
			//setSheetSize(this);
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function sheet1_OnResize(lWidth, lHeight) {
		try {
			//높이 또는 너비가 변경된 경우 각 컬럼의 너비를 새로 맞춘다.
			//setSheetSize(this);
		} catch (ex) {
			alert("OnResize Event Error : " + ex);
		}
	}

	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg) {
		try {
			if (ErrMsg != "") {
				alert(ErrMsg);
			}

			if (Code > 0) {
				doAction1("Search");
			}

		} catch (ex) {
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			selectSheet = sheet1;
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try {

			if (Row > 0 && sheet1.ColSaveName(Col) == "detail") {
				eduInstiMgrPopup(Row);
			}

		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function sheet1_OnPopupClick(Row, Col) {
		try {
			if (sheet1.ColSaveName(Col) == "zip") {
				if (!isPopup()) {
					return;
				}

				gPRow = Row;
				pGubun = "ZipCodePopup";

				var zipCodeLayer = new window.top.document.LayerModal({
					id: 'zipCodeLayer',
					url: '/ZipCodePopup.do?cmd=viewZipCodeLayer&authPg=${authPg}',
					parameters: {},
					width: 740,
					height: 620,
					title: '<tit:txt mid='zipCode' mdef='우편번호검색'/>',
					trigger :[
						{
							name : 'zipCodeLayerTrigger',
							callback : function(result){
								const rv = {
											zip : result.zip,
											doroAddr : result.doroAddr,
											detailAddr : result.detailAddr,
											resDoroFullAddrEng	 : result.resDoroFullAddrEng,
											doroFullAddr : result.doroFullAddr
										   };
								getReturnValue(rv);
							}
						}
					]
				});
				zipCodeLayer.show();
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function sheet1_OnValidation(Row, Col, Value) {
		try {
		} catch (ex) {
			alert("OnValidation Event Error : " + ex);
		}
	}

	/**
	 * 상세내역 window open event
	 */
	function eduInstiMgrPopup(Row) {
		if (!isPopup()) {
			return;
		}

		var eduOrgCd = sheet1.GetCellValue(Row, "eduOrgCd");
		var eduOrgNm = sheet1.GetCellValue(Row, "eduOrgNm");
		var nationalCd = sheet1.GetCellValue(Row, "nationalCd");
		var zip = sheet1.GetCellValue(Row, "zip");
		var curAddr1 = sheet1.GetCellValue(Row, "curAddr1");
		var curAddr2 = sheet1.GetCellValue(Row, "curAddr2");
		var bigo = sheet1.GetCellValue(Row, "bigo");
		var chargeName = sheet1.GetCellValue(Row, "chargeName");
		var orgNm = sheet1.GetCellValue(Row, "orgNm");
		var jikweeNm = sheet1.GetCellValue(Row, "jikweeNm");
		var telNo = sheet1.GetCellValue(Row, "telNo");
		var telHp = sheet1.GetCellValue(Row, "telHp");
		var faxNo = sheet1.GetCellValue(Row, "faxNo");
		var email = sheet1.GetCellValue(Row, "email");
		var companyNum = sheet1.GetCellValue(Row, "companyNum");
		var companyHead = sheet1.GetCellValue(Row, "companyHead");
		var businessPart = sheet1.GetCellValue(Row, "businessPart");
		var businessType = sheet1.GetCellValue(Row, "businessType");
		var bankNum = sheet1.GetCellValue(Row, "bankNum");
		var bankCd = sheet1.GetCellValue(Row, "bankCd");

		const p = { eduOrgCd, eduOrgNm, nationalCd, zip, curAddr1, curAddr2, bigo, chargeName, orgNm, jikweeNm
					, telNo, telHp, faxNo, email, companyNum, companyHead, businessPart, businessType, bankNum, bankCd};

		gPRow = Row;
		pGubun = "eduInstiMgrPopup";
		var eduInstiMgrLayer = new window.top.document.LayerModal({
			id: 'eduInstiMgrLayer',
			url: '/EduInstiMgr.do?cmd=viewEduInstiMgrPopup&authPg=${authPg}',
			parameters: p,
			width: 860,
			height: 800,
			title: '<tit:txt mid='eduInstiMgr' mdef='교육기관관리 세부내역'/>',
			trigger :[
				{
					name : 'eduInstiMgrTrigger',
					callback : function(result){
						const rv = { eduOrgCd        : result.eduOrgCd,
									 eduOrgNm        : result.eduOrgNm,
									 nationalCd      : result.nationalCd,
									 zip             : result.zip,
									 curAddr1        : result.curAddr1,
									 curAddr2        : result.curAddr2,
									 bigo            : result.bigo,
									 chargeName      : result.chargeName,
									 orgNm           : result.orgNm,
									 jikweeNm        : result.jikweeNm,
									 telNo           : result.telNo,
									 telHp           : result.telHp,
									 faxNo           : result.faxNo,
									 email           : result.email,
									 companyNum      : result.companyNum,
									 companyHead     : result.companyHead,
									 businessPart    : result.businessPart,
									 businessType    : result.businessType,
									 bankNum         : result.bankNum,
									 bankCd          : result.bankCd
								   };
						getReturnValue(rv);
					}
				}
			]
		});
		eduInstiMgrLayer.show();
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = returnValue;

		if (pGubun == "ZipCodePopup") {
			sheet1.SetCellValue(gPRow, "zip", rv["zip"]);
			sheet1.SetCellValue(gPRow, "curAddr1", rv["doroFullAddr"]);
		} else if (pGubun == "eduInstiMgrPopup") {
			sheet1.SetCellValue(gPRow, "eduOrgCd", rv["eduOrgCd"]);
			sheet1.SetCellValue(gPRow, "eduOrgNm", rv["eduOrgNm"]);
			sheet1.SetCellValue(gPRow, "nationalCd", rv["nationalCd"]);
			sheet1.SetCellValue(gPRow, "zip", rv["zip"]);
			sheet1.SetCellValue(gPRow, "curAddr1", rv["curAddr1"]);
			sheet1.SetCellValue(gPRow, "curAddr2", rv["curAddr2"]);
			sheet1.SetCellValue(gPRow, "bigo", rv["bigo"]);
			sheet1.SetCellValue(gPRow, "chargeName", rv["chargeName"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
			sheet1.SetCellValue(gPRow, "telNo", rv["telNo"]);
			sheet1.SetCellValue(gPRow, "telHp", rv["telHp"]);
			sheet1.SetCellValue(gPRow, "faxNo", rv["faxNo"]);
			sheet1.SetCellValue(gPRow, "email", rv["email"]);
			sheet1.SetCellValue(gPRow, "companyNum", rv["companyNum"]);
			sheet1.SetCellValue(gPRow, "companyHead", rv["companyHead"]);
			sheet1.SetCellValue(gPRow, "businessPart", rv["businessPart"]);
			sheet1.SetCellValue(gPRow, "businessType", rv["businessType"]);
			sheet1.SetCellValue(gPRow, "bankNum", rv["bankNum"]);
			sheet1.SetCellValue(gPRow, "bankCd", rv["bankCd"]);
		}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>교육기관명 </th>
						<td>  <input id="searchEduOrgNm" name ="searchEduOrgNm" type="text" class="text w100" /> </td>
						<th>교육기관코드 </th>
						<td>  <input id="searchEduEnterCd" name ="searchEduEnterCd" type="text" class="text w100" /> </td>
						<td><btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='eduInstiMgr' mdef='교육기관관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction1('Copy')" 	css="btn outline-gray authA" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
