<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>User Mgr (Admin)</title>

<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var pRow = "";
	var pGubun = "";
	/*Sheet 기본 설정 */
	$(function() {


		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22, FrozenCol:0};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		//InitColumns + Header Title
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='grpEmpType' mdef='권한구분|권한구분'/>",		Type:"Combo",	Hidden:0,	Width:60,	Align:"Center",	SaveName:"grpEmpType",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='frEnterCd' mdef='소속회사|소속회사'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	SaveName:"frEnterCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='sabun_V3457' mdef='소속회사|사번'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"sabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='name_V3458' mdef='소속회사|성명'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	SaveName:"name",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"소속회사|호칭",			Type:"Text",	Hidden:Number("${aliasHdn}"),	Width:80,	Align:"Center",	SaveName:"alias",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속회사|직급",			Type:"Text",	Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	SaveName:"jikgubNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"소속회사|직위",			Type:"Text",	Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	SaveName:"jikweeNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='orgNm_V3459' mdef='소속회사|소속'/>",			Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='toEnterCd' mdef='권한대상회사|권한대상회사'/>",	Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	SaveName:"toEnterCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='hrDataYn' mdef='로그인정보생성|생성여부'/>",	Type:"Text",	Hidden:0,	Width:40,	Align:"Center",	SaveName:"hrDataYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 , Sort:0},
			{Header:"<sht:txt mid='createImg' mdef='로그인정보생성|생성'/>",		Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	SaveName:"createImg",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 , Sort:0},
		];IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);
	 	sheet1.SetMergeSheet( msHeaderOnly);
		sheet1.SetCountPosition(0);
		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_info.png");

		var grpEmpTypeCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&useYn=Y","R90000"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("grpEmpType",{ComboText:"|"+grpEmpTypeCd[0], ComboCode:"|"+grpEmpTypeCd[1]} );
		$("#searchGrpEmpType").html(grpEmpTypeCd[2]);

		$("#searchGrpEmpType").bind("change",function(event){
			doAction("Search");
		});

		$("#searchKeyWord").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction("Search");
			}
		});

		var toEnterCd   = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&enterCd=", "queryId=getEnterCdAllList", false).codeList, "");
		sheet1.SetColProperty("frEnterCd",{ComboText:"|"+toEnterCd[0], ComboCode:"|"+toEnterCd[1]} );
		sheet1.SetColProperty("toEnterCd",{ComboText:"|"+toEnterCd[0], ComboCode:"|"+toEnterCd[1]} );

		$(window).smartresize(sheetResize);sheetInit();
		doAction("Search");
		
  		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "grpEmpType",	rv["grpEmpType"]);
						sheet1.SetCellValue(gPRow, "frEnterCd",	rv["enterCd"]);
						sheet1.SetCellValue(gPRow, "sabun",	rv["sabun"]);
						sheet1.SetCellValue(gPRow, "orgNm",	rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "name",	rv["name"]);
					}
				}
			]
		});
	});

	/**
	 *조회조건 에터키 입력시 조회
	 */
	function check_Enter(){
	    if (event.keyCode==13) doAction("Search");
	}

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
		case "Search": //조회
			sheet1.DoSearch( "${ctx}/GroupAuthorityUserMgr.do?cmd=getGroupAuthorityUserMgrList", $("#mySheetForm").serialize() );
		break;
		case "Save":        //저장
			if (!dupChk(sheet1, "grpEmpType|frEnterCd|sabun|name|toEnterCd", false, true)) {break;}
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave("${ctx}/GroupAuthorityUserMgr.do?cmd=saveGroupAuthorityUserMgr", $("#mySheetForm").serialize() );

            break;
        case "Insert":      //입력
			sheet1.DataInsert(0);
            break;
        case "Copy":        //행복사
        	var Row = sheet1.DataCopy();
        	sheet1.SetCellValue(Row, "hrDataYn", "");
        	sheet1.SetCellValue(Row, "createImg", "");
            break;
        case "Down2Excel":  //엑셀내려받기
            sheet1.Down2Excel();
            break;
		}
    }


	function sheet1_OnClick(Row, Col, Value) {
		try{
		    if(Row > 1 && sheet1.ColSaveName(Col) == "createImg"){
		    	if( sheet1.GetCellValue(Row,"hrDataYn")=="Y" ){
		    		alert('이미 로그인 정보가 생성되어 있습니다.');
		    	}else{
		    		if(confirm('로그인 정보를 생성 하시겠습니까?')){
		    			var param ="grpEmpType="+sheet1.GetCellValue(Row,"grpEmpType")+
		    						"&frEnterCd="+sheet1.GetCellValue(Row,"frEnterCd")+
		    						"&frEnterNm="+sheet1.GetCellValue(Row,"frEnterNm")+
		    						"&toEnterCd="+sheet1.GetCellValue(Row,"toEnterCd")+
		    						"&sabun="+sheet1.GetCellValue(Row,"sabun")+
		    						"&gubun=I";
		    			var result = ajaxCall('${ctx}/GroupAuthorityUserMgr.do?cmd=loginInfoCreate', param, false);
		    			if (result != null && result["Result"] != null && result["Result"]["Code"] != null) {
		    					alert(result["Result"]["Message"]);
		    			}else{
		    					alert('로그인 정보가 생성되었습니다.');
		    					doAction('Search');
		    			}
		    		}
		    	}
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}



	// 	조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if(Msg != "") alert(Msg); sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}


	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") {
				alert(Msg);
			}
			if(Code > 0){
				doAction("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}


  	function sheet1_OnPopupClick(Row, Col){
  	  	try{
  	    	if(sheet1.ColSaveName(Col) == "sabun" || sheet1.ColSaveName(Col) == "name") {
  	      		empSearchPopup(Row,Col);
  	    	}
  	  	}catch(ex){alert("OnPopupClick Event Error : " + ex);}
  	}


  	function empSearchPopup(Row, Col){
  		if(!isPopup()) {return;}
  		pRow = Row;
  		pGubun = "employeePopup";
		var url 	= "/Popup.do?cmd=employeePopup&authPg=${authPg}";
		var args 	= new Array();
		args["name"] 	= sheet1.GetCellValue(Row, "name");
		args["sabun"] 	= sheet1.GetCellValue(Row, "sabun");
		args["sType"] 		= "G";
		args["searchEnterCdView"] 	= "Y";

		var result = openPopup(url, args, "840","520");
// 		if(result != null){
// 			var sabun 	= result["sabun"];
// 	  		var name 	= result["name"];
// 	  		var enterNm = result["enterNm"];
// 	  		var enterCd = result["enterCd"];
// 	  		var orgNm 	= result["orgNm"];

// 	  	  	sheet1.SetCellValue(sheet1.GetSelectRow(), "sabun",sabun);
// 		    sheet1.SetCellValue(sheet1.GetSelectRow(), "name",name);
// 		    sheet1.SetCellValue(sheet1.GetSelectRow(), "frEnterNm",enterNm);
// 		    sheet1.SetCellValue(sheet1.GetSelectRow(), "frEnterCd",enterCd);
// 		    sheet1.SetCellValue(sheet1.GetSelectRow(), "orgNm",orgNm);
// 		}
  	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');
		if(pGubun == "employeePopup"){
			sheet1.SetCellValue(pRow, "sabun",rv["sabun"]);
			sheet1.SetCellValue(pRow, "name",rv["name"]);
			sheet1.SetCellValue(pRow, "alias", rv["alias"]);
			sheet1.SetCellValue(pRow, "jikgubNm", rv["jikgubNm"]);
			sheet1.SetCellValue(pRow, "jikweeNm", rv["jikweeNm"]);
			sheet1.SetCellValue(pRow, "frEnterNm",rv["enterNm"]);
			sheet1.SetCellValue(pRow, "frEnterCd",rv["enterCd"]);
			sheet1.SetCellValue(pRow, "orgNm",rv["orgNm"]);
		}
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
			<th><tit:txt mid='114012' mdef='권한구분 '/></th>
			<td>
				<select id="searchGrpEmpType" name="searchGrpEmpType" >
				</select>
			</td>
			<th><tit:txt mid='104330' mdef='사번/성명'/></th>
			<td>
				<input id="searchKeyWord" name="searchKeyWord" type="text" class="text" />
			</td>
			<td>
				<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
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
				<li id="txt" class="txt"><tit:txt mid='112933' mdef='그룹사권한사용자관리'/></li>
				<li class="btn">
					<btn:a href="javascript:doAction('Down2Excel');" css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
					<btn:a href="javascript:doAction('Copy');" css="btn outline-gray authA" mid='110696' mdef="복사"/>
					<btn:a href="javascript:doAction('Insert');" css="btn outline-gray authA" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doAction('Save');" css="btn filled authA" mid='110708' mdef="저장"/>
				</li>
			</ul>
			</div>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</div>
</body>
</html>
