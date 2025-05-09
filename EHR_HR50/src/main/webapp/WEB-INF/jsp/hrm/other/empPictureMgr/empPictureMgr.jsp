<%@page import="com.hr.common.util.fileupload.impl.FileUploadConfig"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%
String uploadType = "pht001";
request.setAttribute("uploadType", uploadType);
FileUploadConfig fConfig = new FileUploadConfig(uploadType);
request.setAttribute("fConfig", fConfig.getPropertyByJSON());
%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='104507' mdef='개인사진관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- <script src="http://malsup.github.com/jquery.form.js"></script>  -->
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>

<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	var signViewYnData;
	var signViewYn = "status";


	$(function() {
		signViewYnData = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=HRI_SIGN_VIEW_YN", "queryId=getSystemStdData",false).codeList, "");
		if(signViewYnData[0] != "") {
			if( signViewYnData[0] == "Y" ) {
				signViewYn = "0";
			} else if( signViewYnData[0] == "N" ) {
				signViewYn = "1";
			}
		}

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='orgChartNm' mdef='소속도명'/>",		Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"orgChartNm",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Left",	ColMerge:0,	SaveName:"sdate",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='priorOrgCd' mdef='상위소속코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"priorOrgCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='grpNmV2' mdef='조직명'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100,    TreeCol:1 },
			{Header:"<sht:txt mid='orgCdV3' mdef='팀'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='photoV1' mdef='사진'/>",			Type:"Image",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"photo", 		UpdateEdit:0, ImgWidth:40, ImgHeight:60 },
			{Header:"<sht:txt mid='signV1' mdef='서명'/>",			Type:"Image",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sign", 		UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",	Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"orgCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",		Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"orgNm",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"sabun",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"name",        KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",		    	Type:"Text",      Hidden:Number("${aliasHdn}"),  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"alias",        KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCdV2' mdef='직책코드'/>",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikchakCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikchakNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV2' mdef='직위코드'/>",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikweeCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",		Type:"Text",      Hidden:Number("${jwHdn}"),  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikweeNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCdV2' mdef='직급코드'/>",	Type:"Text",      Hidden:1,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikgubCd",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Text",      Hidden:Number("${jgHdn}"),  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"jikgubNm",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='fileYnV1' mdef='사진\n등록'/>",	Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fileYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer" },
			{Header:"<sht:txt mid='signYnV1' mdef='서명\n등록'/>",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"signYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer" }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);

		sheet2.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력

		sheet2.SetImageList(0,"/common/images/icon/icon_upload.png");
		sheet2.SetImageList(1,"/common/images/icon/icon_upload.png");

		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		sheet2.SetAutoRowHeight(0);
		sheet2.SetDataRowHeight(60);

		var statusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");
		sheet2.SetColProperty("statusCd", 			{ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]} );

		$("#statusCd").change(function() {
			doAction2("Search");
		});

		//사진크기 추가 -- 2020.06.01 jylee
		$("#searchPhotoYn").attr('checked', 'checked');
		$("#searchPhotoYn, #photoSize").bind("change",function(){
			
			if($("#searchPhotoYn").is(":checked") == true){

				var iwid = parseInt($("#photoSize").val());
				var ihei = parseInt($("#photoSize option:selected").attr("height"));

				var info = {Width:iwid+10, ImgWidth:iwid, ImgHeight:ihei};
				sheet2.SetColProperty(0, "photo" ,info);
				sheet2.SetDataRowHeight(ihei);
				sheet2.SetColHidden("photo", 0);
				if(signViewYn == "Y") {
					sheet2.SetColHidden("sign", 0);
				}

			}else{
				sheet2.SetDataRowHeight(24);
				sheet2.SetColHidden("photo", 1);
				sheet2.SetColHidden("sign", 1);
			}
			
			clearSheetSize(sheet2);sheetResize();
			//doAction2("Search");
			
		});

		sheet1.ShowTreeLevel(-1);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
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

	    $("#findText").bind("keyup",function(event){
	    	if( event.keyCode == 13){ findOrgNm() ; }
	    });
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/EmpPictureMgr.do?cmd=getEmpPictureMgrOrgList","",1 );
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			sheet2.DoSearch( "${ctx}/EmpPictureMgr.do?cmd=getEmpPictureMgrUserList",$("#mySheetForm").serialize() );

			break;
		case "Down2Excel":

			//if($("#searchPhotoYn").is(":checked") == true){
			//	alert("<msg:txt mid='errorNotPhotoDown' mdef='사진이 포함된 상태에서는 다운로드 하실 수 없습니다.'/>") ;
			//	return ;
			//}

			var downcol = makeHiddenSkipCol(sheet2);
			//var param  = {DownCols:downcol,SheetDesign:1,Merge:0};
			var param  = {DownCols:downcol,SheetDesign:1,Merge:0,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param); break;
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

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {

				$("#orgCd").val(sheet1.GetCellValue(NewRow,"orgCd"));

				if(OldRow != NewRow) {
					doAction2("Search");
				}
			}
		} catch (ex) {
			alert("OnSelectCell Event Error " + ex);
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
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
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {

		var colName = sheet2.ColSaveName(Col);
        var args    = new Array();


        args["sabun"]  = sheet2.GetCellValue(Row, "sabun");
        args["name"]  = sheet2.GetCellValue(Row, "name");

        if(colName == "fileYn" && Row > 0) {
			if(!isPopup()) {return;}

        	gPRow = Row;
        	pGubun = "phtRegPopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'phtRegLayer'
				, url : '/Popup.do?cmd=viewPhtRegLayer'
				, parameters : args
				, width : 500
				, height : 410
				, title : ' 사진등록'
				, trigger :[
					{
						name : 'phtRegTrigger'
						, callback : function(result){
						}
					}
				]
			});
			layerModal.show();
        }
        if(colName == "signYn" && Row > 0) {
			if(!isPopup()) {return;}

        	gPRow = Row;
        	pGubun = "signRegPopup";

			let layerModal = new window.top.document.LayerModal({
				id : 'signRegLayer'
				, url : '/Popup.do?cmd=viewSignRegLayer'
				, parameters : args
				, width : 500
				, height : 650
				, title : '서명등록'
				, trigger :[
					{
						name : 'signRegTrigger'
						, callback : function(result){
						}
					}
				]
			});
			layerModal.show();
        }
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "phtRegPopup"){
            var chkVal = ajaxCall("${ctx}/ImageExistYn.do", "sabun="+sheet2.GetCellValue(gPRow,"sabun"), false);

            if($("#searchPhotoYn").is(":checked") == true){
				sheet2.SetCellValue(gPRow,"photo",sheet2.GetCellValue(gPRow,"photo")+"&temp="+secureRandom());
            }

            if(chkVal.map.exgstYn == "Y"){
            	sheet2.SetCellValue(gPRow, "fileYn",1);
            }else{
            	sheet2.SetCellValue(gPRow, "fileYn",0);
            }
        } else if(pGubun == "signRegPopup") {
            var chkVal = ajaxCall("${ctx}/imageSignExistYn.do", "sabun="+sheet2.GetCellValue(gPRow,"sabun"), false);

            if($("#searchPhotoYn").is(":checked") == true){
            	sheet2.SetCellValue(gPRow,"sign",sheet2.GetCellValue(gPRow,"sign")+"&temp="+secureRandom());
            }

            if(chkVal.map.exgstYn == "Y"){
            	sheet2.SetCellValue(gPRow, "signYn",1);
            }else{
            	sheet2.SetCellValue(gPRow, "signYn",0);
            }
        }
	}

	/*엔터검색 by JSG*/
	function findOrgNm() {
		var startRow = sheet1.GetSelectRow()+1 ;
		startRow = (startRow >= sheet1.LastRow() ? 1 : startRow ) ;
		var selectPosition = sheet1.FindText("orgNm", $("#findText").val(), startRow, 2) ;
		if(selectPosition == -1) {
			sheet1.SetSelectRow(1) ;
			alert("<msg:txt mid='alertOrgTotalMgrV2' mdef='마지막에 도달하여 최상단으로 올라갑니다.'/>") ;
		} else {
			sheet1.SetSelectRow(selectPosition) ;
		}
		$('#searchOrgCd').val(sheet1.GetCellValue(selectPosition,"orgCd"));
		getSheetData();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form id="mySheetForm" name="mySheetForm" >
<input type="hidden" id="orgCd" name="orgCd">
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<colgroup>
		<col width="30%" />
		<col width="70%" />
	</colgroup>
	<tr>
		<td class="sheet_left">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li id="txt" class="txt"><tit:txt mid='orgSchemeMgr' mdef='조직도'/>&nbsp;
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
						<tit:txt mid='201705020000185' mdef='명칭검색'/>
						<input id="findText" name="findText" type="text" class="text" class="text" >
					</li>
				</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "30%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right">
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='orgEmpNm' mdef='조직원'/></li>
					<li class="btn">
						<b><input id="statusCd" name="statusCd" type="radio" value="RA" checked><tit:txt mid='113521' mdef='퇴직자 제외'/>
						<input id="statusCd" name="statusCd"  type="radio" value="" ><tit:txt mid='114221' mdef='퇴직자 포함'/></b>
						&nbsp;
						<input type="checkbox" class="checkbox" id="searchPhotoYn" name="searchPhotoYn" style="vertical-align:middle;"/><b><tit:txt mid='112988' mdef='사진포함여부'/></b>
					    &nbsp;
						<b>사진크기</b>
						<select id="photoSize" id="photoSize">
							<option value="48" height="60" selected>소</option>
							<option value="100" height="125">중</option>
							<option value="160" height="200">대</option>
						</select>
					    &nbsp;
					    <input type="checkbox" class="checkbox" id="lower" name="lower" value="1" onclick="doAction2('Search');" style="vertical-align:middle;"/><b><tit:txt mid='104304' mdef='하위조직포함'/></b>
						&nbsp;
						<btn:a href="javascript:doAction2('Search')" 	css="btn dark authR" mid='110697' mdef="조회"/>
						<a href="javascript:doAction2('Down2Excel')" 	class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
					</li>
				</ul>
				</div>
			</div>

			<script type="text/javascript"> createIBSheet("sheet2", "70%", "100%", "${ssnLocaleCd}"); </script>
		</td>
	</tr>
	</table>
</form>
</div>
</body>
</html>
