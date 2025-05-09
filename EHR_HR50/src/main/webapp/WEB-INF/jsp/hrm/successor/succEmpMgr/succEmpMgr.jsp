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

<c:set var="popUpStyle"  value="" />
<c:if test="${fn:length(param.searchSabun) > 0}">
    <c:set var="ssnSabun"  value="${param.searchSabun}" />
    <c:set var="popUpStyle"  value="padding:0px;" />
</c:if>
<!-- <script src="http://malsup.github.com/jquery.form.js"></script>  -->
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.form.js"></script>
<script type="text/javascript" src="/common/plugin/Fileupload/jquery/jquery.fileupload.js"></script>

<!-- Custom Theme Style -->
<link href="${ ctx }/common/css/cmpEmp/custom.min.css" rel="stylesheet">
<link href="${ ctx }/common/css/cmpEmp/isu_dashboard.css" rel="stylesheet">	

<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/jquery_ui_style.css" />
<link rel="stylesheet" type="text/css" href="/common/plugin/Fileupload/css/fileuploader_style.css" />
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	var signViewYnData;
	var signViewYn = "status";
	

	$(function() {
		signViewYnData = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=HRI_SIGN_VIEW_YN", "queryId=getSystemStdData",false).codeList, "");
		
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
			{Header:"Key Position",			Type:"CheckBox",            Hidden:0,  Width:50,    Align:"Center",    ColMerge:0,   SaveName:"succYn",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, TrueValue:"Y", FalseValue:"N"  },
			{Header:"<sht:txt mid='orgCdV3' mdef='팀'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='photoV1' mdef='사진'/>",			Type:"Image",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"photo", 		UpdateEdit:0, ImgWidth:40, ImgHeight:60 },
			{Header:"<sht:txt mid='signV1' mdef='서명'/>",			Type:"Image",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"sign", 		UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"회사코드",	Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"enterCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appOrgCdV5' mdef='소속코드'/>",	Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"orgCd",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"년도",	Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  	ColMerge:0,   SaveName:"yy",       KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
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
			{Header:"승계기준",		         Type:"Combo", 	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"succCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"직무체류기간",          Type:"Text",   Hidden:0,   Width:80,  Align:"Center", ColMerge:0, SaveName:"jobTerm",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"3개년도 역량평가",      Type:"Text",   Hidden:0,   Width:80,  Align:"Center", ColMerge:0, SaveName:"eva3y",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"자격갯수",              Type:"Text",   Hidden:0,   Width:50,  Align:"Center", ColMerge:0, SaveName:"qualifiedCnt",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"상세보기",			Type:"Image",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"btnPrt",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer"  },
			{Header:"의견",		Type:"Text",      Hidden:0,  Width:70,   Align:"Center",  	ColMerge:0,   SaveName:"note",    KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",		Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='fileYnV1' mdef='사진\n등록'/>",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fileYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer" },
			{Header:"<sht:txt mid='signYnV1' mdef='서명\n등록'/>",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"signYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100, Cursor:"Pointer" }
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(true);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		
		sheet2.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
		sheet2.SetImageList(0,"/common/images/icon/icon_upload.png");
		sheet2.SetImageList(1,"/common/images/icon/icon_popup.png");
		sheet2.SetImageList(2,"/common/images/icon/icon_upload.png");

		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		sheet2.SetAutoRowHeight(0);
		sheet2.SetDataRowHeight(60); 

		var statusCd = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");
		sheet2.SetColProperty("statusCd", 			{ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]} );
		
		sheet2.SetColProperty("succCd", 			{ComboText:"|즉시대체 가능|1~2년내 대체가능", ComboCode:"|1|2"} );

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
	    
	    $("#searchKeyword").click(function(){
			$(this).focus();
		});
		
	    /*
		$("#searchKeyword").bind("keyup",function(event){
			if( event.keyCode == 13){
				$(this).blur();
				if(!isPopup()) {return;}
				var args 	= new Array();
				args["searchKeyword"] = $(this).val();
				openPopup("/Popup.do?cmd=keywordPopup&authPg=R", args, "1300","900");
			}
		});*/
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "${ctx}/SuccEmpMgr.do?cmd=getSuccEmpMgrOrgList","",1 );
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			findOwner();
			sheet2.DoSearch( "${ctx}/SuccEmpMgr.do?cmd=getSuccEmpMgrUserList",$("#mySheetForm").serialize() );

			break;
		case "Save":		
			IBS_SaveName(document.mySheetForm,sheet2);
			sheet2.DoSave( "${ctx}/SuccEmpMgr.do?cmd=saveSuccEmpMgrUserList", $("#mySheetForm").serialize() ); 
			break ;
		
		case "Down2Excel":

			//if($("#searchPhotoYn").is(":checked") == true){
			//	alert("<msg:txt mid='errorNotPhotoDown' mdef='사진이 포함된 상태에서는 다운로드 하실 수 없습니다.'/>") ;
			//	return ;
			//}

			var downcol = makeHiddenSkipCol(sheet2);
			//var param  = {DownCols:downcol,SheetDesign:1,Merge:0};
			var param  = {DownCols:downcol,SheetDesign:1,Merge:0,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet2.Down2Excel(param); break;
			
		case "Create":
			callProcCreate();
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

	// 셀 변경시 발생
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol) {
		try {
			if(sheet1.GetSelectRow() > 0) {

				$("#srchOrgCd").val(sheet1.GetCellValue(NewRow,"orgCd"));
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

        if(colName == "btnPrt" && Row > 0) {
// 			if(!isPopup()) {return;}

        	gPRow = Row;
        	pGubun = "rdPopup";

            showRd(Row);
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
        } else if(pGubun == "compareEmpPopup"){
			arrSabun = new Array();
			for (var i=0; i < Object.keys(rv).length; i++) {
				if(rv[i] != null || rv[i] != ""){
					arrSabun[i] = rv[i];
				}
			}
			
			insertPopData(arrSabun);
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
	
	function findOwner(){
		var data = ajaxCall("${ctx}/SuccEmpMgr.do?cmd=getSuccEmpMgrMap", $("#mySheetForm").serialize(), false);
		/* 데이터 세팅 */
		if( data != null && data != undefined && data.DATA != null && data.DATA != undefined ) {
				item = data.DATA;
				setImgFile(item.sabun) ;
				/*
			 	$("#tdSabun").html("사번 : " + item.sabun) ;
			 	$("#tdName").html(item.name) ;
			 	$("#tdOrgNm").html("소속 : " + item.orgNm) ;
			 	$("#tdEmpYmd").html("입사일 : " + item.empYmd) ;
			 	$("#tdBirthYmd").html("생년월일 : " + item.birYmd) ;
			 	$("#tdJikweeNm").html("직위 : " + item.jikweeNm) ;
			 	$("#tdJikchakNm").html("직책 : " + item.jikchakNm) ;
			 	$("#tdCareerCnt").html("근속년수 : " + item.careerCnt) ;*/
			 	$("#tdSabun").html(item.sabun) ;
			 	$("#profile_summary_name").html(item.name) ;
			 	$("#searchSabun").val(item.sabun);
				$("#searchUserId").val(item.sabun);

				getUser();

		}
	}
	
	//사진파일 적용 by
	function setImgFile(sabun){
		$("#photo").attr("src", "${ctx}/EmpPhotoOut.do?searchKeyword="+sabun);
	}

	
	function empComparePopup(){
		if(!isPopup()) {return;}

		var w 		= 1200; 
		var h 		= 650;
		var url 	= "${ctx}/CompareEmp.do?cmd=viewCompareEmpPopup&authPg=${authPg}";
		var args 	= new Array();
		
		pGubun = "compareEmpPopup";
		
		openPopup(url,args,w,h);
	}

	function insertPopData(arrSabun){

		for(var i = 0; i < arrSabun.length; i++){
			var data = ajaxCall("${ctx}/SuccEmpMgr.do?cmd=getSuccEmpMap", "sabun=" + arrSabun[i], false);
			var row = sheet2.DataInsert(0);
			var item = data.DATA;
			
			sheet2.SetCellValue(row, "sabun", item.sabun);
			sheet2.SetCellValue(row, "yy", $("#srchYear").val());
			sheet2.SetCellValue(row, "orgCd", $("#srchOrgCd").val());
			sheet2.SetCellValue(row, "orgNm", item.orgNm);
			sheet2.SetCellValue(row, "name", item.name);
			sheet2.SetCellValue(row, "jikweeNm", item.jikweeNm);
			sheet2.SetCellValue(row, "jikchakNm", item.jikchakNm);
			
		}
	}
	
	
	function showRd(Row){
		var imgPath = " " ;
		var enterCdSabun = "";
		var searchSabun = "";
		enterCdSabun += ",('" + sheet2.GetCellValue(Row,"enterCd") +"','" + sheet2.GetCellValue(Row,"sabun") + "')";
		searchSabun  += "," + sheet2.GetCellValue(Row,"sabun");

		var rdParam ="";
		
		rdParam += "["+ enterCdSabun +"] "; //회사코드, 사번
		rdParam += "[${baseURL}] ";//이미지위치---3
		rdParam += "[Y] "; //개인정보 마스킹
		rdParam += "[${ssnEnterCd}] ";
		rdParam += "[ '${ssnSabun}' ] ";//rdParam  += "["+searchSabun+"]"; // 사번list->세션사번으로 변경(2016.04.14)
		rdParam += "[${ssnLocaleCd}] ";	// 10.다국어코드
		rdParam += "['"+ searchSabun +"'] "; //사번
		/*
		const data = {
			rdMrd : '/cpn/payReport/TaxClearanceCertificate.mrd'
			, parameterType : 'rp'//rp 또는 rv
			, parameters : parameters
		};
		window.top.showRdLayer(data);*/
        const data = {
                parameters : rdParam
        };
        window.top.showRdLayer('/SuccEmpMgr.do?cmd=getEncryptRd', data);
	}
	
    function callProcCreate() {
        
        if(!confirm("대상자 생성하시겠습니까? \n기존데이터는 지워집니다.")) { return ; }
        
        var params = "srchYear="+$("#srchYear").val()+"&srchOrgCd="+$("#srchOrgCd").val() ;
        var ajaxCallCmd = "callP_HRM_SUCCESSOR_EMP_CRE" ;
        
        var data = ajaxCall("/SuccEmpMgr.do?cmd="+ajaxCallCmd,params,false);
        
        if(data.Result.Code == null) {
            msg = "대상자가 생성되었습니다." ;

        } else {
            msg = "대상자 생성도중 : "+data.Result.Message;
        }
        
        alert(msg) ;
        doAction2("Search") ;
    }
    
</script>
<style type="text/css">
	.sheet_search, .cbp_tmtimeline * {
		box-sizing:initial;
	}
	
	#detailList {
		background-color:#f7f7f7;
		padding:10px;
		border:1px solid #ebeef3;
		overflow-x:hidden;
		overflow-y:auto;
		min-width:240px;
	}
	
	.tile-stats.card-profile {
		padding:15px;
	}
	
	.tile-stats.card-profile.choose {
		background-color:#efefef;
	}
	
	.tile-stats.card-profile .profile_info {
		width:calc(100% - 81px);
	}
	
	.tile-stats.card-profile .profile_info .profile_desc {
		width:100%;
	}
	
	.tile-stats.card-profile .profile_info .profile_desc li.full {
		width:100%;
	}
	
	.tile-stats.card-profile .profile_img img {
		width:66px;
		height:99px;
	}
	
	.member_search_wrap {
		position: relative;
		height:50px !important;
		font-size:12px;
		z-index:30;
		letter-spacing: 0px !important;
		text-align:center;
	}
	.member_search_wrap h1>a {
		display: block;
		position:relative;
		top: 0px;
		cursor: pointer;
	}
	.member_search_wrap .member_search {
		float: left;
		position: relative;
		margin: 0px 0px 0px 0px;
		width:97%;
	}
	.member_search_wrap .member_search input {
		position:relative;
		box-sizing: border-box;
		border: 1px solid #e3e7ea;
		border-radius: 50px;
		width: 100%;
		padding: 8px 15px;
		color: #95999c;
		font-size: 12px;
		outline: none;
		z-index:31;
	}
	.member_search_wrap .member_search a { display: inline-block; position:relative;  z-index:32; }
	.member_search_wrap .pointer { cursor:pointer;}
	
</style>
</head>
<body class="bodywrap">
<div class="wrapper">

	<div class="sheet_search outer">
		<table>
		<tr>
			<td>
				<span><tit:txt mid='113322' mdef='년도'/></span>
				<input id="srchYear" name ="srchYear" type="text" class="text center required" maxlength="4" style="width:60px" value="${curSysYear}"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/>
			</td>
		</tr>
		</table>
	</div>

	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main" style="table-layout: fixed;">
		<colgroup>
			<col width="30%" />
			<col width="*" />
		</colgroup>
		<tr>
			<td class="sheet_left" >
				<div class="sheet_title inner">
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
						<li class="btn">
	<!-- 						<btn:a href="javascript:doAction1('Search');" css="button" mid='110697' mdef="조회"/> -->
						</li>
					</ul>
				</div>
				<div>
				    <script type="text/javascript"> createIBSheet("sheet1", "100%", "695px", "${ssnLocaleCd}"); </script>
				</div> 
			</td>
			
			<td class="sheet_right">
			     <div class="sheet_title">
                    <ul>
                        <li class="txt">조직장</li>
                        <li class="btn"></li>
                    </ul>
                </div>

                <div style="${popUpStyle}">
                    <%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
                 </div>

                    
                <form id="mySheetForm" name="mySheetForm" >
                    <input type="hidden" id="srchOrgCd" name="srchOrgCd">
                    <input type="hidden" id="searchSabun" name="searchSabun"/>
    
                    <div class="sheet_title inner">
                        <ul>
                            <li class="txt">후보자</li>
                            <li class="btn">
                                &nbsp;
                                <input type="checkbox" class="checkbox" id="lower" name="lower" value="1" onclick="doAction2('Search');" style="vertical-align:middle;"/><b><tit:txt mid='104304' mdef='하위조직포함'/></b>
                                &nbsp;
                                <btn:a href="javascript:doAction2('Create');"   css="basic authR" mid='' mdef="대상자생성"/>
                                <btn:a href="javascript:doAction2('Search')"    css="basic authR" mid='110697' mdef="조회"/>
                                <btn:a href="javascript:doAction2('Save')"  css="basic authA" mid='110708' mdef="저장"/>
                                <a href="javascript:doAction2('Down2Excel')"    class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
                            </li>
                        </ul>
                    </div>
                </form>
                <script type="text/javascript"> createIBSheet("sheet2", "100%", "89%", "${ssnLocaleCd}"); </script>

			</td>
			
		</tr>
    </table>

</div>
</body>
</html>
