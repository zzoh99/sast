<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='111900' mdef='승진대상자명단'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	var vSearchEvlYy = "";

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly,FrozenCol:7};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",		Type:"${sDelTy}",	Hidden:Number("0"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",		Type:"${sSttTy}",	Hidden:Number("0"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='appraisalCd_V3585' mdef='승진/승급대상자|평가ID코드(TPAP101)'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='appStepCd_V3586' mdef='승진/승급대상자|평가단계(P00005)'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appStepCd",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='promotionGubun' mdef='승진/승급대상자|승진구분'/>",					Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"promotionGubun",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10},
			{Header:"<sht:txt mid='sabun_V3562' mdef='승진/승급대상자|사원번호'/>",					Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13},
			{Header:"<sht:txt mid='name_V3563' mdef='승진/승급대상자|성명'/>",						Type:"Popup",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13},
			{Header:"<sht:txt mid='orgCd_V3569' mdef='승진/승급대상자|조직코드(TORG101)'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='orgNm_V3564' mdef='승진/승급대상자|소속'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='jikweeCd_V3577' mdef='승진/승급대상자|직위(H20030)'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='jikweeNm_V3' mdef='승진/승급대상자|직위'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='jobCd_V3575' mdef='승진/승급대상자|직무코드(TORG201)'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='jobNm_V3574' mdef='승진/승급대상자|직무명'/>",					Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"승진/승급대상자|직군코드(H10050)",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"승진/승급대상자|직군명",					Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workTypeNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='jikchakCd_V3581' mdef='승진/승급대상자|직책(H20020)'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='jikchakNm_V3580' mdef='승진/승급대상자|직책'/>",						Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='jikgubCd_V3573' mdef='승진/승급대상자|직급(H20010)'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='jikgubNm_V3572' mdef='승진/승급대상자|직급'/>",						Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='appGroupCd_V3587' mdef='승진/승급대상자|평가대상그룹(P00017)'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appGroupCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='appSheetType_V3567' mdef='승진/승급대상자|업적평가유형((P20005)'/>",		Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSheetType",KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='appYn_V3588' mdef='승진/승급대상자|평가포함여부'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1},
			{Header:"<sht:txt mid='chkDate' mdef='승진/승급대상자|최종수정시간'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chkDate",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='chkId_V3583' mdef='승진/승급대상자|최종수정자'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"chkId",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:13},
			{Header:"<sht:txt mid='qOrgCd_V3561' mdef='승진/승급대상자|배분율부서코드'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"qOrgCd",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='qOrgNm_V3560' mdef='승진/승급대상자|배분율부서명'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"qOrgNm",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='jobGroupCd_V3571' mdef='승진/승급대상자|직군코드(TORG201)_사용안함'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobGroupCd",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='jobGroupNm_V3570' mdef='승진/승급대상자|직군명_사용안함'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"jobGroupNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='app1StEndYn' mdef='승진/승급대상자|1차평가종료여부'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"app1StEndYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1},
			{Header:"<sht:txt mid='empYmd_V3568' mdef='승진/승급대상자|입사일'/>",					Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='base3Ymd' mdef='승진/승급대상자|경력인정일'/>",				Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"base3Ymd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='lastSkYmd' mdef='승진/승급대상자|최종진급일'/>",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"lastSkYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='promotionYmd' mdef='승진/승급대상자|승진/승급기준일'/>",			Type:"Date",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"promotionYmd",KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='workYear' mdef='승진/승급대상자|근속년수'/>",					Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workYear",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='workMonth' mdef='승진/승급대상자|근속월수'/>",					Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"workMonth",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='appCnt_V1' mdef='인사평가뱐영횟수(P20020)'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appCnt",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"<sht:txt mid='appOrgCd1_V2817' mdef='부서코드(TORG101)'/>",						Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd1",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='appOrgCd2_V2739' mdef='본부코드(TORG101)'/>",						Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd2",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='appOrgCd3' mdef='부분코드(TORG101)'/>",						Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd3",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='appOrgType_V1' mdef='평가조직유형(W20010)'/>",					Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgType",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10},
			{Header:"",										Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"hrConfYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:1},
			{Header:"<sht:txt mid='bigo' mdef='비고|비고'/>",								Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100},
			{Header:"<sht:txt mid='btnFile ' mdef='파일첨부|파일첨부'/>",						Type:"Html",	Hidden:0,	Width:100, Align:"Center", ColMerge:0,  SaveName:"btnFile" ,  	KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50},
			{Header:"<sht:txt mid='btnFile ' mdef='파일첨부|파일첨부'/>",						Type:"Text",	Hidden:1,	Width:150, Align:"Center", ColMerge:0,  SaveName:"fileSeq" ,  	KeyField:0,   CalcLogic:"", Format:"Number", 	PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50},
			{Header:"<sht:txt mid='pfmChk _V1' mdef='실적확인|실적확인'/>",						Type:"Image",	Hidden:0,	Width:100, Align:"Center", ColMerge:0,  SaveName:"pfmChk" ,  	KeyField:0,   CalcLogic:"", Format:"",     		PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:50}

		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable(true);sheet1.SetVisible(true);

		var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchEvlYy="+$("#searchEvlYy").val()+"&searchAppTypeCd=Z,",false).codeList, "");

		sheet1.SetColProperty("appraisalCd", {ComboText:famList[0], ComboCode:famList[1]} );

		$("#searchAppraisalCd").html(famList[2]);

		var promotionGubun = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P20060"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("promotionGubun", 		{ComboText:promotionGubun[0], ComboCode:promotionGubun[1]} );
		$("#searchPromotionGubun").html(promotionGubun[2]);

/* 		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20010"), "<tit:txt mid='103895' mdef='전체'/>");
		var userCd2 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H00010"), "");

		sheet1.SetColProperty("jikweeCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		sheet1.SetColProperty("tarJikweeCd", 	{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		sheet1.SetColProperty("sexType", 		{ComboText:"|"+userCd2[0], ComboCode:"|"+userCd2[1]} ); */

		$("#searchEvlYy").bind("keyup",function(){
			if($(this).val().length == 4 && vSearchEvlYy != $(this).val()){
				//초기화
				$("#searchAppraisalCd").html("");

				var famList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getAppraisalCdListAppType&searchEvlYy="+$("#searchEvlYy").val()+"&searchAppTypeCd=Z,",false).codeList, "");
				//option 입력
				$("#searchAppraisalCd").html(famList[2]);
				sheet1.SetColProperty("appraisalCd", {ComboText:famList[0], ComboCode:famList[1]} );

				//화살표 조회 방지용
				vSearchEvlYy = $("#searchEvlYy").val();
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			/* var param = "promotionCd="+$("#promotionCd").val()
						+"&choiceYn="+$("#choiceYn").val()
						+"&tarJikweeCd="+$("#tarJikweeCd").val(); */

			sheet1.DoSearch( "${ctx}/PromTargetLst.do?cmd=getPromTargetLstList", $("#mySheetForm").serialize() );
			break;
		case "Save":

			if(!dupChk(sheet1,"promotionCd|sabun", true, true)){break;}
			IBS_SaveName(document.mySheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PromTargetLst.do?cmd=savePromTargetLst", $("#mySheetForm").serialize());
			break;
		case "Insert":
 			if($("#searchAppraisalCd").val() == null || $("#searchAppraisalCd").val() == "") {
				alert("<msg:txt mid='110445' mdef='평가명을 선택하여 주십시오.'/>");
				return;
			}
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "appraisalCd" , $("#searchAppraisalCd").val());
			sheet1.SetCellValue(row, "promotionGubun" , "S");
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			break;
		case "Copy":
			sheet1.DataCopy();
			break;
		case "Proc":
			if(!confirm("대상자를 생성 하시겠습니까? 기존 대상자는 삭제됩니다.")) {
				return;
			}

	    	var data = ajaxCall("/PromTargetLst.do?cmd=prcPromTargetLst","promotionCd="+$("#promotionCd").val(),false);

	    	if(data.Result.Code == "1") {
	    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
	    		doAction1("Search");
	    	} else {
		    	alert(data.Result.Message);
	    	}
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				var promotionGubun	=	sheet1.GetCellValue(r, "promotionGubun");

				if( promotionGubun == 'S'){
					//파일 첨부 시작
					if("${authPg}" == 'A'){
						if(sheet1.GetCellValue(r,"fileSeq") == ''){
							sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
							sheet1.SetCellValue(r, "sStatus", 'R');

						}else{
							sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
							sheet1.SetCellValue(r, "sStatus", 'R');
						}
					}else{
						if(sheet1.GetCellValue(r,"fileSeq") != ''){
							sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
							sheet1.SetCellValue(r, "sStatus", 'R');
						}
					}
					//파일 첨부 끝
				}else{
					sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
					sheet1.SetDataLinkMouse("pfmChk",1);
					sheet1.SetCellValue(r,"pfmChk","0");
					sheet1.SetCellValue(r, "sStatus", 'R');
				}
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

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "btnFile"){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");

				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					var authPgTemp="${authPg}";
					var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp, param, "740","620");

					if(rv != null){
						if(rv["fileCheck"] == "exist"){
							sheet1.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
							sheet1.SetCellValue(Row, "fileSeq", rv["fileSeq"]);
						}else{
							sheet1.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
							sheet1.SetCellValue(Row, "fileSeq", "");
						}
					}
				}
			}
			if(sheet1.ColSaveName(Col) == "pfmChk"){
				if (sheet1.GetCellValue (Row,"promotionGubun") == "G" ){
					var year = "${curSysYear}";
					var args				=	new	Array();
					args["searchSabun"]			=	sheet1.GetCellValue(Row, "sabun");
					args["searchAppraisalCd"]   = 	year.substring(2, 4)+"B01";
					var rv	= openPopup("/CompApp1stApr.do?cmd=viewPfmcCoachingPrizeChk", args, "740","800");

				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "name") {
	            var rst = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "840","520");
	            //var rst = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup", "", "740","520");
	            if(rst != null){
	                sheet1.SetCellValue(Row, "sabun",		rst["sabun"] );
	                sheet1.SetCellValue(Row, "name",		rst["name"] );
	                sheet1.SetCellValue(Row, "sexType",		rst["sexType"] );
	                sheet1.SetCellValue(Row, "age",			rst["age"] );
	                sheet1.SetCellValue(Row, "empYmd",		rst["empYmd"] );
	                sheet1.SetCellValue(Row, "orgCd",  		rst["orgCd"] );
	                sheet1.SetCellValue(Row, "orgNm",  		rst["orgNm"] );
	                sheet1.SetCellValue(Row, "jikchakCd",  	rst["jikchakCd"] );
	                sheet1.SetCellValue(Row, "jikchakNm",  	rst["jikchakNm"] );
	                sheet1.SetCellValue(Row, "jikweeCd",  	rst["jikgubCd"] );
	                sheet1.SetCellValue(Row, "jikweeNm",  	rst["jikweeNm"] );
	                sheet1.SetCellValue(Row, "jobCd",  		rst["jobCd"] );
	                sheet1.SetCellValue(Row, "jobNm",  		rst["jobNm"] );
	                sheet1.SetCellValue(Row, "empYmd",  	rst["empYmd"] );
	                sheet1.SetCellValue(Row, "twkpYCnt",  	rst["empYeuncha"] );
	                sheet1.SetCellValue(Row, "wkpYCnt",  	rst["jikgubYeuncha"] );
	                sheet1.SetCellValue(Row, "lastSkYmd",  	rst["currJikgubYmd"] );
	                sheet1.SetCellValue(Row, "workYear",  	rst["workYyCnt"] );
	                sheet1.SetCellValue(Row, "workMonth",  	rst["workMmCnt"] );
/* 	                rv["currJikgubYmd"]
	                rv["workYyCnt"]
	                rv["workMmCnt"]  */
	            }
			}
		} catch (ex) {
			alert("OnPopupClick Event Error " + ex);
		}

	}
	 // 대상자생성
	 function createRcpt(){
		 var args    = new Array();
		 args["searchAppStepCd"] = '5';
		 args["searchAppraisalCd"] = $("#searchAppraisalCd").val();
		// alert(args["searchAppStepCd"]);
		// alert(args["searchAppraisalCd"]);
	     var rv = openPopup("/AppPeopleMgr.do?cmd=viewAppPeopleMgrPop", args, "740","520");
	     doAction1('Search');
	 }
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='114382' mdef='평가년도'/></th>
						<td>
							<input id="searchEvlYy" name ="searchEvlYy" type="text" class="text" maxlength="4"  value="${curSysYear}" />
						</td>
						<th><tit:txt mid='114019' mdef='평가명'/></th>
						<td>
							<select name="searchAppraisalCd" id="searchAppraisalCd" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<th><tit:txt mid='113241' mdef='승진구분'/></th>
						<td>
							<select name="searchPromotionGubun" id="searchPromotionGubun" onChange="javascript:doAction1('Search');">
							</select>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="button" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>

	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='113242' mdef='승진급대상자관리'/></li>
			<li class="btn">
				<btn:a href="javascript:createRcpt()" id="btnSearch" css="button authA" mid='110728' mdef="대상자생성"/>
				<btn:a href="javascript:doAction1('Insert');" css="basic authA" mid='110700' mdef="입력"/>
				<btn:a href="javascript:doAction1('Copy');" css="basic authA" mid='110696' mdef="복사"/>
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='110708' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
