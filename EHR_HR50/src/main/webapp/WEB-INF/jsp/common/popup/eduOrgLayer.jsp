<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='eduOrgPop' mdef='교육기관 리스트 조회'/></title>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('eduOrgLayer');
		var arg = modal.parameters;
		if( arg != undefined ) {
			$("#searchEduOrgNm").val( arg["searchEduOrgNm"]);
		}
		createIBSheet3(document.getElementById('eduOrgLayerSht1-wrap'), "eduOrgLayerSht1", "100%", "100%","${ssnLocaleCd}");

		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='dbItemDesc' mdef='세부\n내역'/>",				Type:"Image",     Hidden:0,  Width:40,	 Align:"Center",  ColMerge:0,   SaveName:"detail",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='eduOrgCdV1' mdef='교육기관코드'/>",			Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"eduOrgCd",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='eduOrgNmV1' mdef='교육기관명'/>",				Type:"Text",      Hidden:0,  Width:180,  Align:"Left",    ColMerge:0,   SaveName:"eduOrgNm",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='mainEduOrgYn' mdef='주요교육\n기관여부'/>",		Type:"CheckBox",  Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"mainEduOrgYn",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100, TrueValue:"Y", FalseValue:"N" },
            {Header:"<sht:txt mid='nationalCdV3' mdef='국가코드'/>",				Type:"Combo",     Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"nationalCd",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"<sht:txt mid='zip' mdef='우편번호'/>",				Type:"Popup",     Hidden:1,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"zip",                  KeyField:0,   CalcLogic:"",   Format:"PostNo",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
            {Header:"<sht:txt mid='addr' mdef='주소'/>",					Type:"Text",      Hidden:1,  Width:200,  Align:"Left",    ColMerge:0,   SaveName:"curAddr1",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='addr2' mdef='상세주소'/>",				Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"curAddr2",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='bigoV1' mdef='교육기관특성'/>", 			Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"bigo",                 KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='chargeNameV2' mdef='담당자'/>", 				Type:"Text",      Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"chargeName",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='orgNmV10' mdef='소속명'/>", 				Type:"Text",      Hidden:1,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",               KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>", 					Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"jikweeNm",            KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='telNoV4' mdef='전화'/>", 					Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"telNo",               KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
            {Header:"<sht:txt mid='handPhoneV2' mdef='핸드폰'/>",					Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"telHp",               KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
            {Header:"<sht:txt mid='faxNoV2' mdef='팩스'/>", 					Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"faxNo",               KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:13 },
		    {Header:"<sht:txt mid='email' mdef='E-mail주소'/>", 			Type:"Text",      Hidden:1,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"email",                KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:50 },
            {Header:"<sht:txt mid='companyNum' mdef='사업자등록번호'/>", 			Type:"Text",      Hidden:0,  Width:180,  Align:"Left",  ColMerge:0,   SaveName:"companyNum",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='companyHead' mdef='대표자명'/>", 				Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"companyHead",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='businessPart' mdef='업태'/>", 					Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"businessPart",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:40 },
            {Header:"<sht:txt mid='businessType' mdef='종목'/>", 					Type:"Text",      Hidden:1,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"businessType",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:40 },
            {Header:"<sht:txt mid='accountNo' mdef='계좌번호'/>", 				Type:"Text",      Hidden:1,  Width:200,  Align:"Center",  ColMerge:0,   SaveName:"bankNum",             KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"<sht:txt mid='bankCd' mdef='은행명'/>", 				Type:"Combo",     Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"bankCd",              KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:20 },
            {Header:"주요교육n기관여부_STR", 	Type:"Text",      Hidden:1,  Width:45,   Align:"Center",  ColMerge:0,   SaveName:"mainEduOrgYn_STR",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
        ]; IBS_InitSheet(eduOrgLayerSht1, initdata);eduOrgLayerSht1.SetEditable(false);eduOrgLayerSht1.SetVisible(true);eduOrgLayerSht1.SetCountPosition(4);eduOrgLayerSht1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		var nationalCdList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20290"), "");	//소재국가
		var bankCdList 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H30001"), "");	//은행구분

		eduOrgLayerSht1.SetColProperty("nationalCd", 			{ComboText:"|"+nationalCdList[0], ComboCode:"|"+nationalCdList[1]} );	//소재국가
		eduOrgLayerSht1.SetColProperty("bankCd", 			{ComboText:"|"+bankCdList[0], ComboCode:"|"+bankCdList[1]} );	//은행구분

		$("#searchEduOrgNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		$("#searchEduEnterCd").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		eduOrgLayerSht1.SetDataLinkMouse("detail", 1);
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
	    switch(sAction){
	        case "Search":      //조회

	        	eduOrgLayerSht1.DoSearch( "${ctx}/Popup.do?cmd=getEduInstiMgrList", $("#eduOrgLayerSht1Form").serialize() );
	            break;

	        case "Insert":      //입력

	            //var Row = eduOrgLayerSht1.DataInsert(0);
	            //eduOrgLayerSht1.SetCellValue(Row, "nationalCd","001");
	            eduInstiMgrDetPopup("", "A") ;
	            break;

	        case "Down2Excel":  //엑셀내려받기

	            eduOrgLayerSht1.Down2Excel();
	            break;

	        case "LoadExcel":   //엑셀업로드

				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				eduOrgLayerSht1.LoadExcel(params);
	            break;

	    }
	}
	</script>

	<!-- 조회 후 에러 메시지 -->
	<script language="javascript">
	  function eduOrgLayerSht1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
	  try{
	    if (ErrMsg != ""){
	        alert(ErrMsg);
	    }
	    //setSheetSize(this);
	  }catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}
	</script>

	<script language="javascript">
	  function eduOrgLayerSht1_OnClick(Row, Col, Value){
	  try{

	    if(Row > 0 && eduOrgLayerSht1.ColSaveName(Col) == "detail"){
	    	eduInstiMgrDetPopup(Row, "R") ;
	    }

	  }catch(ex){alert("OnClick Event Error : " + ex);}
	}
	</script>

	<script>

	/**
	 * 상세내역 window open event
	 */
	function eduInstiMgrDetPopup(Row, authPg){
		if(!isPopup()) {return;}

		var w 		= 860;
		var h 		= 750;
		var args 	= new Array();

		gPRow = Row;
		pGubun = "viewEduInstiMgrDetPopup";

		if ( Row != "" ){

				args["eduOrgCd"]         =   eduOrgLayerSht1.GetCellValue(Row, "eduOrgCd"         );
				args["eduOrgNm"]         =   eduOrgLayerSht1.GetCellValue(Row, "eduOrgNm"         );
				args["mainEduOrgYn"]     =   eduOrgLayerSht1.GetCellValue(Row, "mainEduOrgYn"     );
				args["nationalCd"]       =   eduOrgLayerSht1.GetCellValue(Row, "nationalCd"       );
				args["zip"]              =   eduOrgLayerSht1.GetCellValue(Row, "zip"              );
				args["curAddr1"]         =   eduOrgLayerSht1.GetCellValue(Row, "curAddr1"         );
				args["curAddr2"]         =   eduOrgLayerSht1.GetCellValue(Row, "curAddr2"         );
				args["bigo"]             =   eduOrgLayerSht1.GetCellValue(Row, "bigo"             );
				args["chargeName"]       =   eduOrgLayerSht1.GetCellValue(Row, "chargeName"       );
				args["orgNm"]            =   eduOrgLayerSht1.GetCellValue(Row, "orgNm"            );
				args["jikweeNm"]         =   eduOrgLayerSht1.GetCellValue(Row, "jikweeNm"         );
				args["telNo"]            =   eduOrgLayerSht1.GetCellValue(Row, "telNo"            );
				args["telHp"]            =   eduOrgLayerSht1.GetCellValue(Row, "telHp"            );
				args["faxNo"]            =   eduOrgLayerSht1.GetCellValue(Row, "faxNo"            );
				args["email"]            =   eduOrgLayerSht1.GetCellValue(Row, "email"            );
				args["companyNum"]       =   eduOrgLayerSht1.GetCellValue(Row, "companyNum"       );
				args["companyHead"]      =   eduOrgLayerSht1.GetCellValue(Row, "companyHead"      );
				args["businessPart"]     =   eduOrgLayerSht1.GetCellValue(Row, "businessPart"     );
				args["businessType"]     =   eduOrgLayerSht1.GetCellValue(Row, "businessType"     );
				args["bankNum"]          =   eduOrgLayerSht1.GetCellValue(Row, "bankNum"          );
				args["bankCd"]           =   eduOrgLayerSht1.GetCellValue(Row, "bankCd"           );
				args["mainEduOrgYn_STR"] =   eduOrgLayerSht1.GetCellValue(Row, "mainEduOrgYn_STR" );
		}

		let layerModal = new window.top.document.LayerModal({
			id: 'eduInstiMgrDetLayer',
			url: '/Popup.do?cmd=viewEduInstiMgrDetLayer&authPg=' + authPg,
			parameters: args,
			width: w,
			height: h,
			title: '교육기관관리 세부내역',
			trigger :[
				{
					name : 'eduInstiMgrDetLayerTrigger',
					callback : function(rv){
						doAction1("Search");
					}
				}
			]
		});

		layerModal.show();
	}

	function eduOrgLayerSht1_OnDblClick(Row, Col){
		var rv = new Array(5);
		rv["eduOrgCd"]	= eduOrgLayerSht1.GetCellValue(Row, "eduOrgCd");
		rv["eduOrgNm"]	= eduOrgLayerSht1.GetCellValue(Row, "eduOrgNm");

		const modal = window.top.document.LayerModalUtility.getModal('eduOrgLayer');
		modal.fire('eduOrgLayerTrigger', rv).hide();
	}
</script>


</head>
<body class="bodywrap">

	<div class="wrapper modal_layer">
        <div class="modal_body">
		<form id="eduOrgLayerSht1Form" name="eduOrgLayerSht1Form" tabindex="1">
            <input type="hidden" id="searchEnterCd" name="searchEnterCd" />
            <input type="hidden" id="chkVisualYn" name="chkVisualYn" value="Y" />
			<div class="sheet_search outer">
				<div>
				<table>
				<tr>
					<th><tit:txt mid='112690' mdef='교육기관코드'/></th>
                       <td> 
                            <input type="text" id="searchEduEnterCd" name="searchEduEnterCd" class="text" value="" />
                       </td>
                       <th><tit:txt mid='113426' mdef='교육기관명'/></th>
					   <td>  <input id="searchEduOrgNm" name ="searchEduOrgNm" type="text" class="text" /> </td>
                       <td>
						<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
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
						<li id="txt" class="txt"><tit:txt mid='eduOrgPopV1' mdef='교육기관'/></li>
						<li class="btn">
							<btn:a href="javascript:doAction1('Insert')" css="basic authA" mid='110700' mdef="입력"/>
						</li>
					</ul>
					</div>
				</div>
				<div id="eduOrgLayerSht1-wrap"></div>
				</td>
			</tr>
		</table>

		</div>
		<div class="modal_footer">
			<btn:a href="javascript:closeCommonLayer('eduOrgLayer');" css="btn outline_gray" mid='110881' mdef="닫기"/>
		</div>
</div>
</body>
</html>
