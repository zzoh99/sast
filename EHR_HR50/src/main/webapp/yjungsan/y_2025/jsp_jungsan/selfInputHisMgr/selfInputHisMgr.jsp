<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>수기등록내역관리</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>
<%String ssnSearchType = (String)session.getAttribute("ssnSearchType");
%>
<script type="text/javascript">
	var templeteTitle1 = "업로드시 이 행은 삭제 합니다\n\n";
	var addFileYn = "";
	var arrDown = "";
	var adjustTypeList = null;
	var fileTypeList = null;
	$(function() {
        //엑셀,파일다운 시 화면명 저장(교보증권) - 2021.10.26
        $("#menuNm").val($(document).find("title").text()); //엑셀,CURD
		$("#searchYear").val("<%=yeaYear%>") ;

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:7,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0,SizeMode:2};
		initdata.Cols = [
			{Header:"No|No",			Type:"<%=sNoTy%>",	Hidden:Number("<%=sNoHdn%>"),	Width:"<%=sNoWdt%>",	Align:"Center", ColMerge:0,	SaveName:"sNo" },
			{Header:"대상년도|대상년도",		Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"work_yy",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"정산구분|정산구분",		Type:"Combo",		Hidden:0, 	Width:110,	Align:"Center",	ColMerge:1,	SaveName:"adjust_type",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"성명|성명",			Type:"Text",		Hidden:0, 	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"name",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사번|사번",			Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sabun",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"사업장|사업장",		Type:"Text",		Hidden:1, 	Width:0,	Align:"Center",	ColMerge:1,	SaveName:"business_place_cd",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사업장|사업장",		Type:"Text",		Hidden:0, 	Width:80,	Align:"Center",	ColMerge:1,	SaveName:"business_place_nm",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"인적공제|기본공제",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"dpndnt_cnt",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"인적공제|등록건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"per_his_cnt",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"인적공제|증빙건수",     Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"per_evd_doc_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"보험료|등록건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"ins_his_cnt",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"보험료|증빙건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"ins_evd_doc_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"주택자금|등록건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"house_his_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"주택자금|증빙건수",     Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"house_evd_doc_cnt",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"저축|등록건수",  	    Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sav_his_cnt",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"저축|증빙건수",  	    Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"sav_evd_doc_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"연금계좌|등록건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"pen_his_cnt",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"연금계좌|증빙건수",     Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"pen_evd_doc_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"의료비|등록건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"med_his_cnt",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"의료비|증빙건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"med_evd_doc_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"교육비|등록건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"edu_his_cnt",			KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"교육비|증빙건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"edu_evd_doc_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"기부금|등록건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"dona_his_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"기부금|증빙건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"dona_evd_doc_cnt",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"신용카드|등록건수",  	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"card_his_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"신용카드|증빙건수",     Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"card_evd_doc_cnt",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"종전근무지|등록건수", 	Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"be_com_his_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"종전근무지|증빙건수",    Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"be_com_evd_doc_cnt",	KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100},
			{Header:"기타|기타", 			Type:"Text",		Hidden:0, 	Width:60,	Align:"Center",	ColMerge:1,	SaveName:"etc_evd_doc_cnt",		KeyField:0, Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100}
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("<%=editable%>");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var initdata2 = {};
        initdata2.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata2.Cols = [
            {Header:"No",    Type:"<%=sNoTy%>",  Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",    Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"선택",   Type:"DummyCheck",  Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"ibsCheck",    KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100, TrueValue:"Y", FalseValue:"N" },
            {Header:"성명",   Type:"Text",        Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"name",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사번",   Type:"Text",        Hidden:0,   Width:40,   Align:"Center", ColMerge:0, SaveName:"sabun",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"조직명",  Type:"Text",        Hidden:0,   Width:120,  Align:"Center", ColMerge:0, SaveName:"org_nm",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사업장",  Type:"Combo",       Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"biz_place_cd",KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"귀속년도", Type:"Text",        Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"work_yy",     KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"정산구분", Type:"Combo",       Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"adjust_type", KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"파일구분", Type:"Combo",       Hidden:0,   Width:120,  Align:"Center", ColMerge:0, SaveName:"file_type",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"파일순번", Type:"Text",        Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"file_seq",    KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"파일경로", Type:"Text",        Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"file_path",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"파일명",  Type:"Text",        Hidden:1,   Width:80,   Align:"Center", ColMerge:0, SaveName:"file_name",   KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"파일명",  Type:"Text",        Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"attr1",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }
        ]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable(true);sheet2.SetVisible(true);sheet2.SetCountPosition(4);
        sheetInit();

		adjustTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>", "C00303"), "전체" );
		// 사업장(권한 구분)
		var ssnSearchType  = "<%=ssnSearchType%>";
		var bizPlaceCdList = "";

		fileTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&useYn=Y&searchYear=<%=yeaYear%>", "YEA001"), "전체" );

		if(ssnSearchType == "A"){
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getBizPlaceCdList","",false).codeList, "전체");
		}else{
			bizPlaceCdList = stfConvCode( ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getBizPlaceCdAuthList&queryId=getBizPlaceCdAuthList","",false).codeList, "");
		}

		var adjInputTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList&searchYear=<%=yeaYear%>","C00325"), "");
		$("#searchInputType").html("<option value=''>전체</option><option value='01,02'>직원입력+담당자변경</option>"+adjInputTypeList[2]);
		//연말정산 파일첨부탭 기능 사용 여부 조회
		var getAddFileYn = ajaxCall("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&searchStdCd=CPN_YEA_ADD_FILE_YN&searchWorkYy="+$("#searchYear").val(), "queryId=getYeaSystemStdData",false).codeList;
		if(getAddFileYn != null && getAddFileYn.length > 0) {
			addFileYn = getAddFileYn[0].code_nm;
		}

		//sheet1
		sheet1.SetColProperty("business_place_cd", {ComboText:"|"+bizPlaceCdList[0], ComboCode:"|"+bizPlaceCdList[1]});
		//sheet2
		sheet2.SetColProperty("adjust_type",    {ComboText:"|"+adjustTypeList[0], ComboCode:"|"+adjustTypeList[1]} );
		sheet2.SetColProperty("file_type",    {ComboText:"|"+fileTypeList[0], ComboCode:"|"+fileTypeList[1]} );
		sheet2.SetColProperty("biz_place_cd",    {ComboText:"|"+bizPlaceCdList[0], ComboCode:"|"+bizPlaceCdList[1]} );

        $("#searchBizPlaceCd").html(bizPlaceCdList[2]);
        $("#searchFileType1").html(fileTypeList[2]).val("");
        $("#searchFileType").html(fileTypeList[2]).val("");
        $("#visibleTd").hide();

        //증빙자료 내역(파일첨부탭 기능 사용여부)및 증빙건수 비활성화
        if(addFileYn == "N"){
        	$("#addFileYnDiv").hide();
        	sheet1.SetColHidden("per_evd_doc_cnt"   ,1);
        	sheet1.SetColHidden("ins_evd_doc_cnt"   ,1);
        	sheet1.SetColHidden("house_evd_doc_cnt" ,1);
        	sheet1.SetColHidden("sav_evd_doc_cnt"   ,1);
        	sheet1.SetColHidden("pen_evd_doc_cnt"   ,1);
        	sheet1.SetColHidden("med_evd_doc_cnt"   ,1);
        	sheet1.SetColHidden("edu_evd_doc_cnt"   ,1);
        	sheet1.SetColHidden("dona_evd_doc_cnt"  ,1);
        	sheet1.SetColHidden("card_evd_doc_cnt"  ,1);
        	sheet1.SetColHidden("be_com_evd_doc_cnt",1);
        	sheet1.SetSheetHeight(600);
        	sheet1.SetSheetWidth(2000);
        }else{
        	$("#addFileYnDiv").show();
        }
        $(window).smartresize(sheetResize); sheetInit();
        
        getCprBtnChk();
        
      	//doAction1("Search");
	});

	$(function() {
		$("#searchSbNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
				$(this).focus();
			}
		});
	});

	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			sheet1.DoSearch( "<%=jspPath%>/selfInputHisMgr/selfInputHisMgrRst.jsp?cmd=selectSelfInputHisMgrList", $("#sheetForm").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,menuNm:$(document).find("title").text()};
			sheet1.Down2Excel(param);
			break;
		}
	}
	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
			if(addFileYn != "N"){
			    doAction2("Search");
			}
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}
    //저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try {
            alertMessage(Code, Msg, StCode, StMsg);
            if(Code == 1) {
                doAction1("Search");
            }
        } catch (ex) {
            alert("OnSaveEnd Event Error " + ex);
        }
    }
	//상세조회
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
		try{
			if(sheet1.GetSelectRow() > 0 && OldRow != NewRow){
				if(addFileYn != "N"){
				    doAction2("Search");
				}
			}
		} catch(ex){
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = $("#sheetForm").serialize();
				param += "&searchYear="+sheet1.GetCellValue(sheet1.GetSelectRow(), "searchYear");
				param += "&searchSb="+sheet1.GetCellValue(sheet1.GetSelectRow(), "sabun");
				param += "&searchAdjustType="+ sheet1.GetCellValue(sheet1.GetSelectRow(), "adjust_type");
				param += "&searchFileType="+ $("#searchFileType").val();
			sheet2.DoSearch( "<%=jspPath%>/selfInputHisMgr/selfInputHisMgrRst.jsp?cmd=selectSelfEvidDocMgrList", param);
			break;
		case "PDF":
			downloadFile('A', '0');
			break;
		}
	}
	//조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//파일 다운로드
	function downloadFile(type, row) {
		arrDown = new Array();
		var obj = new Object();

		if(type == 'A') {
			var sCheckRow = sheet2.FindCheckedRow("ibsCheck");
			if ( sCheckRow == "" ){
				alert("선택된 내역이 없습니다.");
				return;
			}
			$(sCheckRow.split("|")).each(function(index,value){
				obj = new Object();
				obj.fileType = sheet2.GetCellValue(value,"file_type");
				obj.fileName = sheet2.GetCellValue(value,"attr1");
				obj.dbFileName = sheet2.GetCellValue(value,"file_name");
				obj.sabun = sheet2.GetCellValue(value,"sabun");
				arrDown.push(obj);
			});
		} else {
			obj.fileType = sheet2.GetCellValue(row,"file_type");
			obj.fileName = sheet2.GetCellValue(row,"attr1");
			obj.dbFileName = sheet2.GetCellValue(row,"file_name");
			obj.sabun = sheet2.GetCellValue(row,"sabun");
			arrDown.push(obj);
		}
	    /*************************************************************
	    * 2021.04.14 로그관리
	    * 사유 저장 팝업 오픈
	    *************************************************************/
		if(arrDown.length > 0){
	        if(!isPopup()) {return;}

	        //최초 다운로드 버튼 클릭시 다운로드 사유 여부 조회
	        //IE에서는 인코딩 문제로  logStdCd => encodeURI(logStdCd)으로 변경
	        var bFlag = false;
            var logStdCd = "CPN_YEA_FILE_LOG_YN";
            var reasonMap = ajaxCall("../auth/beforeDownloadPopupRst.jsp?cmd=getDownReasonYn&logStdCd="+encodeURI(logStdCd), "queryId=getDownReasonYn",false).codeList;
            if(reasonMap[0].log_yn_cd == "Y"){ // 다운로드 사유
                bFlag = true;
            }

	        if(bFlag){
	        // 사유 Popup open
		        var args = new Array();
		        args["type"] = 'Sheet';
		        args["type2"] = 'F'; //E: 엑셀다운로드 , F: 파일다운로드, P: 출력물인쇄
		        args["menuNm"] = $(document).find("title").text();
	            openPopup("../auth/beforeDownloadPopup.jsp", args, "450","280");
	        }else{
	            $("#pWorkYy").val($("#searchYear").val());
	            $("#pValue").val(JSON.stringify(arrDown));
	            $("#pfrm").attr("action", "<%=jspPath%>/evidenceDocMgr/evidenceFileDownload.jsp");
	            $("#pfrm").submit();
	        }
        }
	}
    /*************************************************************
    * 2021.04.14 로그관리
    * callDownFile 함수 추가
    * 사유 저장 후 콜백
    *************************************************************/
	function callDownFile(returnValue){
        $("#pWorkYy").val($("#searchYear").val());
        $("#pValue").val(JSON.stringify(arrDown));
        $("#pfrm").attr("action", "<%=jspPath%>/evidenceDocMgr/evidenceFileDownload.jsp");
        $("#pfrm").submit();
	}

	//구분
	function typeColor(){
		if($("#searchFileType1").val() == "5"){
			sheet1.SetColBackColor(8, "#FAD5E6");
			sheet1.SetColBackColor(9, "#FAD5E6");
		}else{
			sheet1.SetColBackColor(8, "") ;
			sheet1.SetColBackColor(9, "") ;
		}
		if($("#searchFileType1").val() == "10"){
			sheet1.SetColBackColor(10, "#FAD5E6") ;
			sheet1.SetColBackColor(11, "#FAD5E6") ;
		}else{
			sheet1.SetColBackColor(10, "") ;
			sheet1.SetColBackColor(11, "") ;
		}
		if($("#searchFileType1").val() == "15"){
			sheet1.SetColBackColor(12, "#FAD5E6") ;
			sheet1.SetColBackColor(13, "#FAD5E6") ;
		}else{
			sheet1.SetColBackColor(12, "") ;
			sheet1.SetColBackColor(13, "") ;
		}
		if($("#searchFileType1").val() == "20"){
			sheet1.SetColBackColor(14, "#FAD5E6") ;
			sheet1.SetColBackColor(15, "#FAD5E6") ;
		}else{
			sheet1.SetColBackColor(14, "") ;
			sheet1.SetColBackColor(15, "") ;
		}
		if($("#searchFileType1").val() == "25"){
			sheet1.SetColBackColor(16, "#FAD5E6") ;
			sheet1.SetColBackColor(17, "#FAD5E6") ;
		}else{
			sheet1.SetColBackColor(16, "") ;
			sheet1.SetColBackColor(17, "") ;
		}
		if($("#searchFileType1").val() == "30"){
			sheet1.SetColBackColor(18, "#FAD5E6") ;
			sheet1.SetColBackColor(19, "#FAD5E6") ;
		}else{
			sheet1.SetColBackColor(18, "") ;
			sheet1.SetColBackColor(19, "") ;
		}
		if($("#searchFileType1").val() == "35"){
			sheet1.SetColBackColor(20, "#FAD5E6") ;
			sheet1.SetColBackColor(21, "#FAD5E6") ;
		}else{
			sheet1.SetColBackColor(20, "") ;
			sheet1.SetColBackColor(21, "") ;
		}
		if($("#searchFileType1").val() == "40"){
			sheet1.SetColBackColor(22, "#FAD5E6") ;
			sheet1.SetColBackColor(23, "#FAD5E6") ;
		}else{
			sheet1.SetColBackColor(22, "") ;
			sheet1.SetColBackColor(23, "") ;
		}
		if($("#searchFileType1").val() == "42"){
			sheet1.SetColBackColor(24, "#FAD5E6") ;
			sheet1.SetColBackColor(25, "#FAD5E6") ;
		}else{
			sheet1.SetColBackColor(24, "") ;
			sheet1.SetColBackColor(25, "") ;
		}
		if($("#searchFileType1").val() == "45"){
			sheet1.SetColBackColor(26, "#FAD5E6") ;
			sheet1.SetColBackColor(27, "#FAD5E6") ;
		}else{
			sheet1.SetColBackColor(26, "") ;
			sheet1.SetColBackColor(27, "") ;
		}
		if($("#searchFileType1").val() == "50"){
			sheet1.SetColBackColor(28, "#FAD5E6") ;
		}else{
			sheet1.SetColBackColor(28, "") ;
		}
		doAction1('Search');
	}
	//자료등록여부 변경
	function srhOnChange(){
		//if($("#srhSelfInputYn").val() == "" && $("#srhEvidYn").val() == ""){
		if($("#srhEvidYn").val() == ""){
			$("#searchFileType1").val("");
			$("#visibleTd").hide();
			typeColor();
		}else{
			$("#visibleTd").show();
		}
		doAction1('Search');
	}

	//수정(이력) 관련 세팅
	function getCprBtnChk(){
        var params = "&cmbMode=all"
                   + "&searchWorkYy=" + $("#searchYear").val() 
                   + "&searchAdjustType="
                   + "&searchSabun=" ;
		
        //재계산 차수 값 조회
		var strUrl = "<%=jspPath%>/common/commonCode.jsp?cmd=getCommonNSCodeList&queryId=getReCalcSeq884" + params ;
		var searchReCalcSeq = stfConvCode( codeList(strUrl,"") , "");
		
		if(searchReCalcSeq == null || searchReCalcSeq == "" || searchReCalcSeq[0] == "") {
			$("#searchAdjustType").html("");
		} else {   			
			$("#searchAdjustType").html("<option value=''>전체</option>" + searchReCalcSeq[2].replace(/<option value='1'>/g, "<option value='1' selected>"));
			sheet1.SetColProperty("adjust_type", {ComboText:"|"+searchReCalcSeq[0], ComboCode:"|"+searchReCalcSeq[1]});
		}
	}

</script>
</head>
<body class="bodywrap" style="overflow-y: auto;">
<div class="wrapper">
	<form id="sheetForm" name="sheetForm" >
	<input type="hidden" id="menuNm" name="menuNm" value="" />
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<td><span>년도</span>
				<%-- 무의미한 분기문 주석 처리 20240919
				if(!"SH".equals(session.getAttribute("ssnEnterCd")) && !"GT".equals(session.getAttribute("ssnEnterCd")) && !"FMS".equals(session.getAttribute("ssnEnterCd")) && !"CSM".equals(session.getAttribute("ssnEnterCd")) && !"SHN".equals(session.getAttribute("ssnEnterCd"))){
				--%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%-- 무의미한 분기문 주석 처리 20240919}else{%>
					<input id="searchYear" name ="searchYear" type="text" class="text center readonly" maxlength="4" style="width:35px" readonly/>
				<%}--%>
				</td>
				<td><span>정산구분</span>
					<select id="searchAdjustType" name ="searchAdjustType" onChange="javascript:doAction1('Search')" class="box"></select>
				</td>
                <td>
                    <span>사업장</span>
                    <select id="searchBizPlaceCd" name ="searchBizPlaceCd" class="box" onChange="javascript:doAction1('Search')" ></select>
                </td>
                <td id="visibleTd">
                    <span>구분</span>
                    <select id="searchFileType1" name ="searchFileType1" class="box" onChange="javascript:typeColor();" ></select>
                </td>
<!--                 <td> -->
<!--                     <span>수기자료등록여부</span> -->
<!--                     <select id="srhSelfInputYn" name ="srhSelfInputYn" class="box" onChange="javascript:srhOnChange();" > -->
<!--                     	<option value="">전체</option> -->
<!--                     	<option value="Y">Y(직원입력,담당자변경)</option> -->
<!--                     	<option value="N">N</option> -->
<!--                     </select> -->
<!--                 </td> -->
                <td><span>자료입력유형</span>
                    <select id="searchInputType" name ="searchInputType" onChange="javascript:doAction1('Search')" class="box"></select>
                </td>
			</tr>
			<tr>
                <td>
                    <span>증빙자료등록여부</span>
                    <select id="srhEvidYn" name ="srhEvidYn" class="box" onChange="javascript:srhOnChange();" >
                        <option value="">전체</option>
                    	<option value="Y">Y</option>
                    	<option value="N">N</option>
                    </select>
                </td>
				<td><span>사번/성명</span>
				<input id="searchSbNm" name ="searchSbNm" type="text" class="text" maxlength="15" style="width:100px"/> </td>
				<td><a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a></td>
			</tr>
		</table>
		</div>
	</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">수기등록내역관리</li>
			<li Class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="basic btn-download authR">다운로드</a>
			</li>
		</ul>
		</div>
	</div>
    <script type="text/javascript"> createIBSheet("sheet1", "100%", "400px");</script>
	<div id="addFileYnDiv">
    <div class="outer">
        <div class="sheet_title">
        <ul>
            <li class="txt">증빙자료내역</li>
            <li class="btn">
			<span id="sheet2Btn" name="sheet2Btn">
				<span>파일구분</span>
				<select id="searchFileType" name ="searchFileType" onChange="javascript:doAction2('Search')" class="box"></select>
				<a href="javascript:doAction2('PDF');"	class="basic btn-download authA">파일다운로드</a>
		</span>
            </li>
        </ul>
        </div>
    </div>
    <script type="text/javascript"> createIBSheet("sheet2", "100%", "200px");</script>
    </div>
</div>
<iframe name="hiddenIframe" id="hiddenIframe" style="display:none;"></iframe>
<form id="pfrm" name="pfrm" target="hiddenIframe" action="" method="post" >
<input type="hidden" id="pValue" name="pValue" />
<input type="hidden" id="pWorkYy" name="pWorkYy" />
</form>
</body>
</html>