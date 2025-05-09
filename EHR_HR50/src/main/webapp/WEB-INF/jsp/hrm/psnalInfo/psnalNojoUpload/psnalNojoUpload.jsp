
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head> <title><tit:txt mid='114280' mdef='노조관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">

	var gPRow = "";
	var pGubun = "";


	$(function() {

		// 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
		initIbFileUpload($("#srchFrm"));

		// 파일 목록 변수의 초기화 작업 시점 정의
		// clearBeforeFunc(function object)
		// 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
		//		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
		//	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
		sheet1_OnSearchEnd = clearBeforeFunc(sheet1_OnSearchEnd);
		sheet1_OnSaveEnd = clearBeforeFunc(sheet1_OnSaveEnd)

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:6,DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",			Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='photoV1' mdef='사진'/>",			Type:"Image",       Hidden:0, Width:50,  Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='sabun' mdef='사번'/>",			Type:"Text",        Hidden:0, Width:70,  Align:"Center", ColMerge:0, SaveName:"sabun",			KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='teacherNm' mdef='성명'/>",		Type:"Text",        Hidden:0, Width:70,  Align:"Center", ColMerge:0, SaveName:"name",			KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='orgNm' mdef='소속'/>",			Type:"Text",        Hidden:0, Width:90,  Align:"Center", ColMerge:0, SaveName:"orgNm",			KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakCd' mdef='직책'/>",		Type:"Combo",       Hidden:0, Width:90,  Align:"Center", ColMerge:0, SaveName:"jikchakCd",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 },
			{Header:"<sht:txt mid='jikweeCd' mdef='직위'/>",		Type:"Combo",       Hidden:0, Width:90,  Align:"Center", ColMerge:0, SaveName:"jikweeCd",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",		Type:"Combo",       Hidden:0, Width:90,  Align:"Center", ColMerge:0, SaveName:"jikgubCd",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:30 },
			{Header:"<sht:txt mid='salClass' mdef='호봉'/>",		Type:"Text",        Hidden:0, Width:90,  Align:"Center", ColMerge:0, SaveName:"salClass",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='statusCd' mdef='재직상태'/>",	Type:"Combo",		Hidden:0, Width:50,  Align:"Center", ColMerge:0, SaveName:"statusCd",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='manageCd' mdef='계약유형'/>",	Type:"Combo",		Hidden:0, Width:50,  Align:"Center", ColMerge:0, SaveName:"manageCd",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='sexType' mdef='성별'/>",			Type:"Combo",		Hidden:0, Width:50,  Align:"Center", ColMerge:0, SaveName:"sexType",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",	Type:"Date",		Hidden:0, Width:90,  Align:"Center", ColMerge:0, SaveName:"gempYmd",		KeyField:0, Format:"Ymd",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='empYmd' mdef='입사일'/>",		Type:"Date",        Hidden:0, Width:90,  Align:"Center", ColMerge:0, SaveName:"empYmd",			KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='base3Cd' mdef='구소속'/>",		Type:"Combo",		Hidden:0, Width:90,  Align:"Center", ColMerge:0, SaveName:"base3Cd",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"조합",											Type:"Combo",		Hidden:0, Width:120, Align:"Center", ColMerge:0, SaveName:"nojoCd",			KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='sdate' mdef='가입일'/>",			Type:"Date",        Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"sdate",			KeyField:1, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='edate' mdef='탈퇴일'/>",			Type:"Date",        Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"edate",			KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='nojoPositionCd' mdef='조합신분'/>",	Type:"Combo",       Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"nojoPositionCd",	KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='nojoJikchakCd' mdef='조합직책'/>",	Type:"Combo",       Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"nojoJikchakCd",	KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='appointYmd' mdef='임명일'/>",		Type:"Date",        Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"appointYmd",		KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='retireYmd' mdef='퇴임일'/>",			Type:"Date",        Hidden:0, Width:100, Align:"Center", ColMerge:0, SaveName:"retireYmd",		KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='payDeductYn' mdef='노조비\n공제여부'/>",	Type:"CheckBox",    Hidden:1, Width:75,  Align:"Center", ColMerge:0, SaveName:"payDeductYn",	KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1,      TrueValue:"Y", FalseValue:"N" },
			{Header:"<sht:txt mid='memo' mdef='비고'/>",			Type:"Text",        Hidden:0, Width:100, Align:"Left",   ColMerge:0, SaveName:"memo",			KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1300 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",		Type:"Html",        Hidden:0, Width:70,  Align:"Center", ColMerge:0, SaveName:"btnFile",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",		Type:"Text",        Hidden:1, Width:100, Align:"Center", ColMerge:0, SaveName:"fileSeq",		KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:35 }
		];
		IBS_InitSheet(sheet1, initdata1);
		$(window).smartresize(sheetResize);
		sheet1.SetEditable("${editable}");
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		//$("#searchFromSdate").datepicker2({startdate:"searchToSdate"});
		//$("#searchToSdate").datepicker2({enddate:"searchFromSdate"});

		$("#searchFromSdate").datepicker2({
			startdate : "searchToSdate"
		});
		$("#searchToSdate").datepicker2({
			enddate : "searchFromSdate"
		});

		$("#searchFromEdate").datepicker2({
			startdate : "searchToEdate"
		});
		$("#searchToEdate").datepicker2({
			enddate : "searchFromEdate"
		});
		
		// 직책코드(H20020)
		var jikchakCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020"), "");
		sheet1.SetColProperty("jikchakCd", {ComboText:"|"+jikchakCd[0], ComboCode:"|"+jikchakCd[1]});
		$("#searchJikchakCd").html(jikchakCd[2]);
		$("#searchJikchakCd").select2({placeholder:" 선택"});
		
		// 직위코드(H20030)
		var jikweeCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030"), "");
		sheet1.SetColProperty("jikweeCd", {ComboText:"|"+jikweeCd[0], ComboCode:"|"+jikweeCd[1]});
		$("#searchJikweeCd").html(jikweeCd[2]);
		$("#searchJikweeCd").select2({placeholder:" 선택"});
		
		// 직급코드(H20010)
		var jikgubCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010"), "");
		sheet1.SetColProperty("jikgubCd", {ComboText:"|"+jikgubCd[0], ComboCode:"|"+jikgubCd[1]});
		$("#searchJikgubCd").html(jikgubCd[2]);
		$("#searchJikgubCd").select2({placeholder:" 선택"});
		
		// 재직상태코드(H10010)
		var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010"), "");
		sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});
		$("#searchStatusCd").html(statusCd[2]);
		$("#searchStatusCd").select2({placeholder:" 선택"});

		// 계약유형(H10030)
		var manageCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10030"), "");
		sheet1.SetColProperty("manageCd", {ComboText:"|"+manageCd[0], ComboCode:"|"+manageCd[1]});
		$("#searchManageCd").html(manageCd[2]);
		$("#searchManageCd").select2({placeholder:" 선택"});
		
		// 성별(H00010)
		var sexType = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H00010"), "");
		sheet1.SetColProperty("sexType", {ComboText:"|"+sexType[0], ComboCode:"|"+sexType[1]});
		
		//노조관리
		var userCd2 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90019"), "");
		sheet1.SetColProperty("nojoCd",	  {ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} );
		$("#searchNojoCd").html(userCd2[2]);
		$("#searchNojoCd").select2({placeholder:" 선택"});
		
		//노조신분
		var nojoPositionCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90018"), "");
		sheet1.SetColProperty("nojoPositionCd",	  {ComboText:"|"+nojoPositionCd[0], ComboCode:"|"+nojoPositionCd[1]} );
		$("#searchNojoPositionCd").html(nojoPositionCd[2]);
		$("#searchNojoPositionCd").select2({placeholder:" 선택"});
		
		//노조직책
		var userCd1 = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H90011"), "");
		sheet1.SetColProperty("nojoJikchakCd",	  {ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		$("#searchNojoJikchakCd").html(userCd1[2]);
		$("#searchNojoJikchakCd").select2({placeholder:" 선택"});
		
		//구소속
		var base3Cd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","W90091"), "<tit:txt mid='111914' mdef='전체'/>");
		sheet1.SetColProperty("base3Cd",	  {ComboText:"|"+base3Cd[0], ComboCode:"|"+base3Cd[1]} );
		$("#searchBase1Cd").html(base3Cd[2]);
		
		//노조비 지급여부
		//$("#searchPayDeductYn").html("<option value=''><tit:txt mid='103895' mdef='전체'/></option> <option value='Y'><tit:txt mid='perPayMasterMgrException1' mdef='지급'/></option> <option value='N'><tit:txt mid='114669' mdef='미지급'/></option>");

		$("#searchOrgNm, #searchName, #searchFromSdate, #searchToSdate, #searchFromEdate, #searchToEdate").bind("keyup",function(event){
			if( event.keyCode == 13) {
				doAction1("Search");
				$(this).focus();
			}
		});

		$("#searchBase1Cd, #searchNojoYn").change(function(){
			doAction1("Search");
		});
		
		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});

		$("#searchPhotoYn").attr('checked', 'checked');
		
		//자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "photo",		rv["photo"]);
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow, "jikweeCd",	rv["jikweeCd"]);
						sheet1.SetCellValue(gPRow, "jikgubCd",	rv["jikgubCd"]);
						sheet1.SetCellValue(gPRow, "salClass",	rv["salClass"]);
						sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						sheet1.SetCellValue(gPRow, "manageCd",	rv["manageCd"]);
						sheet1.SetCellValue(gPRow, "sexType",	rv["sexType"]);
						sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
						sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						sheet1.SetCellValue(gPRow, "base3Cd",	rv["base3Cd"]);
					}
				}
			]
		});		

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			if(!checkList()) return ;

			clearFileListArr('sheet1'); // 파일 목록 변수의 초기화

			$("#searchJikchakCdHidden").val(getMultiSelect($("#searchJikchakCd").val()));
			$("#searchJikweeCdHidden").val(getMultiSelect($("#searchJikweeCd").val()));
			$("#multiJikgubCd").val(getMultiSelect($("#searchJikgubCd").val()));
			$("#multiManageCd").val(getMultiSelect($("#searchManageCd").val()));
			$("#multiStatusCd").val(getMultiSelect($("#searchStatusCd").val()));
			$("#multiNojoCd").val(getMultiSelect($("#searchNojoCd").val()));
			$("#multiNojoPositionCd").val(getMultiSelect($("#searchNojoPositionCd").val()));
			$("#multiNojoJikchakCd").val(getMultiSelect($("#searchNojoJikchakCd").val()));
			
			sheet1.DoSearch( "${ctx}/PsnalNojoUpload.do?cmd=getPsnalNojoUploadList", $("#srchFrm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|sdate", false, true)){break;}
			IBS_SaveName(document.srchFrm,sheet1);
			sheet1.DoSave( "${ctx}/PsnalNojoUpload.do?cmd=savePsnalNojoUpload", $("#srchFrm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);

			sheet1.SetCellValue(row, "payDeductYn", 'Y');
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='attachFile' mdef="첨부"/>');

			break;
		case "Copy":
			var row = sheet1.DataCopy();
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1, ['Html']);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":   var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet1.LoadExcel(params);
		//파일 첨부 시작
			break;
		case "DownTemplate":
			// 양식다운로드
			var templeteTitle1 = "업로드시 이 행은 삭제 합니다";
			templeteTitle1 += "\n가입일, 탈퇴일, 임명일은 하이픈('-')을 입력하여 주시기 바랍니다.(ex: 2015-12-31)";
			var d = new Date();
			var fName = "노조관리(업로드양식)_" + d.getTime();
			sheet1.Down2Excel({ fileName: fName, SheetDesign:1, Merge:1, DownRows:"0", DownCols:"sabun|name|nojoCd|sdate|edate|nojoPositionCd|nojoJikchakCd|appointYmd|retireYmd|memo"
			,TitleText:templeteTitle1,UserMerge :"0,0,1,10"
			});
			break;
		}
	}



	function sheet1_OnLoadExcel() {

		for(var r = sheet1.HeaderRows(); r<sheet1.LastRow()+sheet1.HeaderRows(); r++){

			sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='attachFile' mdef="첨부"/>');
		}
	}


	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			//파일 첨부 시작
			for(var r = sheet1.HeaderRows(); r<sheet1.LastRow()+sheet1.HeaderRows(); r++){
				if("${authPg}" == 'A'){
					if(sheet1.GetCellValue(r,"fileSeq") == ''){
						sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='attachFile' mdef="첨부"/>');
						sheet1.SetCellValue(r, "sStatus", 'R');
					}else{
						sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='down2excel' mdef="다운로드"/>');
						sheet1.SetCellValue(r, "sStatus", 'R');
					}
				}else{
					if(sheet1.GetCellValue(r,"fileSeq") != ''){
						sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='down2excel' mdef="다운로드"/>');
						sheet1.SetCellValue(r, "sStatus", 'R');
					}
				}
			}

			if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);

			}else{
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
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

	//파일 신청 시작
	function sheet1_OnClick(Row, Col, Value) {
		try{

			if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){

				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup";

					fileMgrPopup(Row, Col);
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	//파일 신청 끝

	// 파일첨부/다운로드 팝업
	function fileMgrPopup(Row, Col) {
		let layerModal = new window.top.document.LayerModal({
			id : 'fileMgrLayer'
			, url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&authPg=${authPg}'
			, parameters : {
				fileSeq : sheet1.GetCellValue(Row,"fileSeq"),
				fileInfo: getFileList(sheet1.GetCellValue(Row,"fileSeq")) // 파일 목록 동기화 처리를 위함
			}
			, width : 740
			, height : 420
			, title : '파일 업로드'
			, trigger :[
				{
					name : 'fileMgrTrigger'
					, callback : function(result){
						addFileList(sheet1, Row, result); // 작업한 파일 목록 업데이트
						if(result.fileCheck == "exist"){
							sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic">다운로드</a>');
							sheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
						}else{
							sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic">첨부</a>');
							sheet1.SetCellValue(gPRow, "fileSeq", "");
						}
					}
				}
			]
		});
		layerModal.show();
	}
	// 파일첨부/다운로드 팝업 끝

	function sheet1_OnPopupClick(Row, Col) {
		try{
			var colName = sheet1.ColSaveName(Col);
			if (Row > 0) {
				if(colName == "name") {
					// 사원검색 팝업
					empSearchPopup(Row, Col);
				}
			}
		}catch(ex) {alert("OnPopupClick Event Error : " + ex);}
	}


	// 사원검색 팝업
	function empSearchPopup(Row, Col) {
		if(!isPopup()) {return;}
		gPRow  = Row;
		pGubun = "employeePopup";
		var w	   = 840;
		var h	   = 520;
		var url	 = "/Popup.do?cmd=employeePopup";
		var args	= new Array();
		var result = openPopup(url+"&authPg=R", args, w, h);

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

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		debugger;
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "employeePopup"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);

			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
			sheet1.SetCellValue(gPRow, "empYmd", rv["empYmd"]);
			sheet1.SetCellValue(gPRow, "retYmd", rv["retYmd"]);
		}

		if(pGubun == "filePopup"){
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='down2excel' mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='attachFile' mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		}
		
		if(pGubun == "sheetAutocompleteEmp"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
			sheet1.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
			sheet1.SetCellValue(gPRow, "jikgubCd", rv["jikgubCd"]);
			sheet1.SetCellValue(gPRow, "salClass", rv["salClass"]);
			sheet1.SetCellValue(gPRow, "retYmd", rv["retYmd"]);
			sheet1.SetCellValue(gPRow, "statusCd", rv["statusCd"]);
			sheet1.SetCellValue(gPRow, "manageCd", rv["manageCd"]);
			sheet1.SetCellValue(gPRow, "sexType", rv["sexType"]);
			sheet1.SetCellValue(gPRow, "gempYmd", rv["gempYmd"]);
			sheet1.SetCellValue(gPRow, "empYmd", rv["empYmd"]);
		}
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='' mdef='소속'/></th>
						<td>
							<input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" />
						</td>
						<th><tit:txt mid='112862' mdef='성명/사번'/></th>
						<td>
							<input id="searchName" name ="searchName" type="text" class="text" />
						</td>
						<th><tit:txt mid='' mdef='계약유형'/></th>
						<td>
							<select id="searchManageCd" name="searchManageCd" multiple></select>
							<input type="hidden" id="multiManageCd" name="multiManageCd" />
						</td>
						<th><tit:txt mid='114198' mdef='재직상태'/></th>
						<td>
							<select id="searchStatusCd" name="searchStatusCd" multiple></select>
							<input type="hidden" id="multiStatusCd" name="multiStatusCd" />
						</td>
					</tr>
					<tr>	
						<th><tit:txt mid='' mdef='직책'/></th>  
						<td>
							<select id="searchJikchakCd" name="searchJikchakCd" multiple></select>
							<input type="hidden" id="searchJikchakCdHidden" name="searchJikchakCdHidden" />
						</td>
						<th><tit:txt mid='' mdef='직위'/></th> 
						<td> 
							<select id="searchJikweeCd" name="searchJikweeCd" multiple></select>
							<input type="hidden" id="searchJikweeCdHidden" name="searchJikweeCdHidden" />
						</td>
						<th><tit:txt mid='' mdef='직급'/></th>  
						<td>
							<select id="searchJikgubCd" name="searchJikgubCd" multiple></select>
							<input type="hidden" id="multiJikgubCd" name="multiJikgubCd" />
						</td>
						<th><tit:txt mid='' mdef='구소속'/></th>
						<td>
							<select id="searchBase1Cd" name="searchBase1Cd"></select>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='' mdef='조합'/></th>
						<td>
							<select id="searchNojoCd" name="searchNojoCd" multiple></select>
							<input type="hidden" id="multiNojoCd" name="multiNojoCd" />
						</td>
						<th><tit:txt mid='' mdef='조합신분'/></th>
						<td>
							<select id="searchNojoPositionCd" name="searchNojoPositionCd" multiple></select>
							<input type="hidden" id="multiNojoPositionCd" name="multiNojoPositionCd" />
						</td>
						<th><tit:txt mid='' mdef='조합직책'/></th>
						<td>
							<select id="searchNojoJikchakCd" name="searchNojoJikchakCd" multiple></select>
							<input type="hidden" id="multiNojoJikchakCd" name="multiNojoJikchakCd" />
						</td>	
						<th><tit:txt mid='' mdef='현조합원'/></th>					
						<td>
							<select id="searchNojoYn" name ="searchNojoYn" class="box" title="기준일을 기준으로 노조 가입 상태를 체크합니다.">
								<option value="">전체</option>
								<option value="Y">현조합원</option>
								<option value="N">탈퇴조합원</option>
							</select>
						</td>
					</tr>
					<tr>
						<th><tit:txt mid='' mdef='가입일'/></th>
						<td colspan="2">
							<input id="searchFromSdate" name ="searchFromSdate" type="text" class="date2" /> ~ <input id="searchToSdate" name ="searchToSdate" type="text" class="date2" />
						</td>
						<th><tit:txt mid='' mdef='탈퇴일'/></th>
						<td colspan="2">
							<input id="searchFromEdate" name ="searchFromEdate" type="text" class="date2" /> ~ <input id="searchToEdate" name ="searchToEdate" type="text" class="date2" />
						</td>
						<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
						<td>
							<input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
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
							<li id="txt" class="txt"><tit:txt mid='112519' mdef='노조관리'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')"	css="btn outline-gray authR" mid='download' mdef='다운로드'/>
								<btn:a href="javascript:doAction1('DownTemplate')"  css="btn outline-gray authA" mid='down2ExcelV1' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction1('LoadExcel')"	 css="btn outline-gray authA" mid='upload' mdef="업로드"/>
								<btn:a href="javascript:doAction1('Copy')"		  css="btn outline-gray authA" mid='copy' mdef="복사"/>
								<btn:a href="javascript:doAction1('Insert')"		css="btn outline-gray authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction1('Save')"		  css="btn filled authA" mid='save' mdef="저장"/>
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
