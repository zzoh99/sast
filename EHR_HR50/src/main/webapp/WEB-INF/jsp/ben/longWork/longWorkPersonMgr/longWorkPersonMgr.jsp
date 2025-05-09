<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>

<script type="text/javascript">
	$(function() {
		if("${pictureHdn}" == "Y"){
			$("#searchPhotoYn").attr('checked', true);
		}else{
			$("#searchPhotoYn").attr('checked', false);
		}		
		
		var initdata = {};
		initdata.Cfg = {
			SearchMode:smLazyLoad,
			Page:22,
			MergeSheet:msHeaderOnly
		};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"No|No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
        	{Header:"상태|상태",			Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"선택|선택", 			Type:"DummyCheck",	Hidden:0,	Width:55,	Align:"Center", ColMerge:0, SaveName:"processYn",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:1 },
        	{Header:"기준일자|기준일자",	Type:"Text",		Hidden:1,	Width:80,	Align:"Center", ColMerge:0, SaveName:"basicYyyy",	KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
        	{Header:"포상구분|포상구분",	Type:"Combo",		Hidden:0,	Width:130,	Align:"Center", ColMerge:0, SaveName:"prizeCd",		KeyField:1,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"확정\n여부|확정\n여부", 	Type:"CheckBox",	Hidden:0,	Width:55,	Align:"Center", ColMerge:0, SaveName:"confirmYn",	KeyField:0,	Format:"",	PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10,	FalseValue:"N", TrueValue:"Y", HeaderCheck:1 },
			
			{Header:"대상자 (포상일자 기준)|사진",			Type:"Image",		Hidden:0,  	Width:60, 		Align:"Center", ColMerge:0,		SaveName:"photo",			UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
			{Header:"대상자 (포상일자 기준)|사번",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center", ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"대상자 (포상일자 기준)|성명",			Type:"Text",		Hidden:0,					Width:60,	Align:"Center", ColMerge:0,	SaveName:"name",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자 (포상일자 기준)|소속코드",		Type:"Text",		Hidden:1,					Width:80,	Align:"Center", ColMerge:0,	SaveName:"orgCd",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상자 (포상일자 기준)|소속",			Type:"Text",		Hidden:0,					Width:120,	Align:"Center", ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },			
			{Header:"대상자 (포상일자 기준)|직책코드",		Type:"Text",		Hidden:1,					Width:80,	Align:"Center", ColMerge:0,	SaveName:"jikchakCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상자 (포상일자 기준)|직책",			Type:"Text",		Hidden:0,					Width:80,	Align:"Center", ColMerge:0,	SaveName:"jikchakNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"대상자 (포상일자 기준)|직위코드",		Type:"Text",		Hidden:1,					Width:80,	Align:"Center", ColMerge:0,	SaveName:"jikweeCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상자 (포상일자 기준)|직위",			Type:"Text",		Hidden:Number("${jwHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"대상자 (포상일자 기준)|직급",			Type:"Text",		Hidden:Number("${jgHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"대상자 (포상일자 기준)|그룹입사일",		Type:"Date",		Hidden:Number("${gempYmdHdn}"),					Width:80,	Align:"Center", ColMerge:0,	SaveName:"gempYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상자 (포상일자 기준)|입사일",			Type:"Date",		Hidden:0,					Width:80,	Align:"Center", ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"대상자 (포상일자 기준)|근속\n년수",		Type:"Int",			Hidden:0,					Width:50,	Align:"Center",	ColMerge:0,	SaveName:"contYear",	KeyField:1,	Format:"Integer",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"대상자 (포상일자 기준)|근속\n년월",		Type:"Text",		Hidden:0,					Width:80,	Align:"Center",	ColMerge:0,	SaveName:"contYearNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },			
			{Header:"현재직상태|현재직상태",		Type:"Combo",		Hidden:0,	MinWidth:80,	Align:"Center",	ColMerge:0,	SaveName:"statusCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			
			
			{Header:"포상일자|포상일자",	Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"prizeYmd",		KeyField:1,	Format:"Ymd",		PointCount:0, UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"포상번호|포상번호",	Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"prizeNo",			KeyField:0,	Format:"",			PointCount:0, UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"포상기관|포상기관",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"prizeOfficeNm",	KeyField:0,	Format:"",			PointCount:0, UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"보상종류|보상종류",	Type:"Text",		Hidden:1,	Width:10,	Align:"Center",	ColMerge:0,	SaveName:"wkpGift",			KeyField:0,	Format:"",			PointCount:0, UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"포상금액|포상금액",	Type:"Int",			Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"wkpMon",			KeyField:0,	Format:"Integer",	PointCount:0, UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"휴가일수|휴가일수",	Type:"Int",			Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"wkpDay",			KeyField:0,	Format:"Integer",	PointCount:0, UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"휴가\n사용여부|휴가\n사용여부",	Type:"CheckBox",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"wkpDayYn",	KeyField:0,	Format:"",		PointCount:0, UpdateEdit:1,	InsertEdit:1,   EditLen:1,	FalseValue:"N", TrueValue:"Y", HeaderCheck:1 },
			
			{Header:"포상사유|포상사유",	Type:"Text",		Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"prizeReason",	KeyField:0,	Format:"",		PointCount:0, UpdateEdit:1,	InsertEdit:1,	EditLen:200 }
		];
		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		//사업장
		var businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getBusinessPlaceCdList",false).codeList, "");	//소속구분항목(급여사업장)
		$("#searchBusinessPlaceCd").html(businessPlaceCd[2]);
		$("#searchBusinessPlaceCd").select2({
			placeholder: "<tit:txt mid='2017040700020' mdef='전체'/>"
			, maximumSelectionSize:100
		});

		//근무지
		var locationCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLocationCdList",false).codeList, "");	//Location코드
		$("#searchLocationCd").html(locationCd[2]);
		$("#searchLocationCd").select2({
			placeholder: "<tit:txt mid='2017040700020' mdef='전체'/>"
			, maximumSelectionSize:100
		});

		// 포상구분
		var prizeCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLongWorkPrizeCdList",false).codeList, "");	//지표구분
		sheet1.SetColProperty("prizeCd", {ComboText:"|"+prizeCd[0], ComboCode:"|"+prizeCd[1]} );

		// 근속포상기준일
		$("#searchPrizeYmd").datepicker2();
		//$("#searchPrizeYmd").datepicker2({ymonly:true});
		$("#sdate").datepicker2({startdate:"edate", onReturn: getCommonCodeList2});
		$("#edate").datepicker2({enddate:"sdate", onReturn: getCommonCodeList2});
		
		// 기준년도
		$("#searchYear").mask('1111', {reverse:true});
		
		$("#searchFrom").datepicker2({ymonly:true});
		$("#searchTo").datepicker2({ymonly:true});
		
		//근속년수 
		var searchLongWorkCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getLongWorkCdList",false).codeList, "<tit:txt mid='111914' mdef='전체'/>");
		$("#searchContYear").html(searchLongWorkCd[2]);

		getCommonCodeList2();

		//조회조건
		$("#searchOrgNm, #searchSabunName, #searchYear, #searchContYear").on("keyup", function(e){
			if( e.keyCode == 13) {
				doAction1("Search");
				$(this).focus();
			}
		});

		$("#searchConfirmYn, #searchJikchakCd, #searchJikweeCd, #searchJikgubCd, #searchContYear").on("change", function(e) {
			doAction1("Search");
		});


		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});
			
		//$("#searchPhotoYn").attr('checked', 'checked');

		$(sheet1).sheetAutocomplete({
		  	Columns: [{ ColSaveName : "name" }]
		}); 
				
		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	function getCommonCodeList1() {
		let baseSYmd = $("#sdate").val();
		let baseEYmd = $("#edate").val();

		// 재직상태코드(H10010)
		var statusCd = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H10010", baseSYmd, baseEYmd), "");
		sheet1.SetColProperty("statusCd", {ComboText:"|"+statusCd[0], ComboCode:"|"+statusCd[1]});

	}
	function getCommonCodeList2() {
		let baseSYmd = $("#sdate").val();
		let baseEYmd = $("#edate").val();

		// 직책, 직위, 직급
		var jikchakCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20020", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		var jikweeCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20030", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		var jikgubCdList = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20010", baseSYmd, baseEYmd), "<tit:txt mid='103895' mdef='전체'/>");
		$("#searchJikchakCd").html(jikchakCdList[2]);
		$("#searchJikweeCd").html(jikweeCdList[2]);
		$("#searchJikgubCd").html(jikgubCdList[2]);
	}
	function doAction1(sAction) {
		switch (sAction) {
	    case "Search":
			getCommonCodeList1();
			sheet1.RemoveAll();
			if (!$("#searchYear").val()) {
				alert("기준년도는 필수 입니다");
				return false;
			}
	    	$("#businessPlaceCd").val(($("#searchBusinessPlaceCd").val()==null?"":getMultiSelect($("#searchBusinessPlaceCd").val())));
			$("#locationCd").val(($("#searchLocationCd").val()==null?"":getMultiSelect($("#searchLocationCd").val())));
	        sheet1.DoSearch( "${ctx}/LongWorkPersonMgr.do?cmd=getLongWorkPersonMgrList", $("#srchFrm").serialize() );
	        
	        break;
	    case "Insert":
	    	var Row = sheet1.DataInsert(0);
	    	sheet1.SetCellValue(Row, "basicYyyy", $("#searchYear").val());
	    	break;
	    case "Copy":
	    	var Row = sheet1.DataCopy();
	    	//sheet1.SetCellValue( Row, "basicYyyy", $("#searchYear").val());
	    	break;
	    case "Save":
	        //저장
	        if(!dupChk(sheet1, "basicYyyy|prizeCd|sabun", false, true)) {break;}
	        IBS_SaveName(document.srchFrm, sheet1);
	        sheet1.DoSave("${ctx}/LongWorkPersonMgr.do?cmd=saveLongWorkPersonMgr", $("#srchFrm").serialize());
	        break;
	    case "Down2Excel":
	    	var downCols = "sNo|basicYyyy|prizeCd|confirmYn|sabun|name|orgNm|jikchakNm|jikweeNm|jikgubNm|empYmd|contYear|prizeYmd|wkpGift|prizeReason";
	    	var params = { DownCols:downCols, Merge:1 };
	        var d = new Date();
	        var fName = "근속포상대상자관리_" + d.getTime();
	        sheet1.Down2Excel($.extend(params, { FileName:fName, SheetDesign:1, Merge:1 }));
	        break;
		case "confBatch":
			var chkCnt = 0;
			var rowCnt = sheet1.RowCount();
			for (var i=sheet1.HeaderRows(); i<=rowCnt+sheet1.HeaderRows(); i++) {
				if (sheet1.GetCellValue(i, "processYn") == "1") {
					sheet1.SetCellValue(i, "sStatus", 'U');
					chkCnt++;
				}
			}
			if (chkCnt <= 0) {
				alert("<msg:txt mid='alertNotSelectAppl' mdef='선택된 대상자가 없습니다.'/>");
				break;
			}
			if (confirm("근속포상대상자를 확정처리합니다. 진행하시겠습니까?")) {
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/LongWorkPersonMgr.do?cmd=prcConfirmLongWorkPersonMgr", {Param:$("#srchFrm").serialize(),Quest:0});
				break;
			}else{
				break;
			}
		case "cancelBatch":
			var chkCnt = 0;
			var rowCnt = sheet1.RowCount();
			for (var i=sheet1.HeaderRows(); i<=rowCnt+sheet1.HeaderRows(); i++) {
				if (sheet1.GetCellValue(i, "processYn") == "1") {
					sheet1.SetCellValue(i, "sStatus", 'U');
					chkCnt++;
				}
			}
			if (chkCnt <= 0) {
				alert("<msg:txt mid='alertNotSelectAppl' mdef='선택된 대상자가 없습니다.'/>");
				break;
			}
			if (confirm("근속포상대상자 생성내역을 확정취소합니다. 진행하시겠습니까?")) {
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/LongWorkPersonMgr.do?cmd=prcCancelLongWorkPersonMgr", {Param:$("#srchFrm").serialize(),Quest:0});
				break;
			}else{
				break;
			}
		}
	}

	// 시트 조회 후 이벤트
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			
			if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			}else{
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}
			
			if(sheet1.RowCount() > 0) {
				for(var i = sheet1.HeaderRows() ; i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
					if(sheet1.GetCellValue(i, "confirmYn") != "N") {
						sheet1.SetRowEditable(i,false);
						sheet1.SetCellEditable(i,"processYn",true);  
					} else {
						sheet1.SetRowEditable(i,true);
					}
				}
			}
			
			//setSheetSettings();
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	/**
	 * 조회 후 특정 항목에 따라 수정 가능여부 처리
	 */
	function setSheetSettings() {
		for(var i = sheet1.HeaderRows() ; i < sheet1.RowCount() + sheet1.HeaderRows() ; i++) {
			if(sheet1.GetCellValue(i, "confirmYn") == "Y") {
				sheet1.SetRowEditable(i, 0);
			}
		}
	}

	// 시트 저장 후 이벤트
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
	
	// 사번으로 근속년수 구하는 메소드
	function getWorkYear(sabun) {
		var ret = ajaxCall("${ctx}/LongWorkPersonMgr.do?cmd=getLongWorkPersonMgrWorkYear", "searchYmd=" + $("#searchYear").val() + "1231&searchSabun=" + sabun, false).DATA;
		if(ret) {
			return Number(ret.workYear);
		}
		
		return 0;
	}

	/**
	 * 근속포상대상자 생성 함수
	 */
	function creLongWorkPersonList() {
		
		var searchGempEmp = $(':radio[name="searchGempEmp"]:checked').val();
		
		// 근속포상기준일 기준으로 근속포상대상자 생성
		var searchPrizeYmd = $("#searchPrizeYmd").val();
		if(searchPrizeYmd == "") {
			alert("근속포상기준일를 입력하세요.");
			return;
		}
		var conf = confirm("근속포상기준일 " + searchPrizeYmd + "을 대상으로 근속포상대상자를 생성합니다. 생성하시겠습니까?");
		if(conf) {
			// 근속포상대상자 생성
			// 포상일자 기준으로 근속포상대상자 생성
			var data = ajaxCall("${ctx}/LongWorkPersonMgr.do?cmd=prcP_HRM_LONG_WORK_PERSON_CREATE", "searchYmd="+searchPrizeYmd.replace(/-/gi, "")+"&calType="+searchGempEmp, false);
			
			if(data.Result.Code == null) {
				msg = "근속포상대상자가 생성되었습니다." ;
				doAction1("Search") ;
			} else {
				msg = "근속포상대상자 생성도중 : "+data.Result.Message;
			}

			alert(msg) ;
		}
	}

	/**
	 * 근속포상대상자 확정처리
	 */
	function confLongWorkPersonMgr() {
		var searchYear = $("#searchYear").val();
		var searchPrizeYmd = $("#searchPrizeYmd").val();
		
		if(searchYear == "") {
			alert("기준년도를 입력해주세요.");
			return;
		}
		
		if(searchPrizeYmd == "") {
			alert("근속포상기준일를 입력해주세요.");
			return;
		}
		
		
        var conf = confirm(searchYear + "년도 데이터를 대상으로 포상일자가 " + searchPrizeYmd + "인 근속포상대상자를 확정처리합니다. 진행하시겠습니까?");
        if(conf) {
	        var res = ajaxCall("${ctx}/LongWorkPersonMgr.do?cmd=prcP_HRM_LONG_WORK_PERSON_CONFIRM", "searchYear="+searchYear+"&searchPrizeYmd="+searchPrizeYmd.replace(/-/gi, ""), false);
	        if (res != null && res["Result"] != null && res["Result"]["Code"] != null) {
				if (res["Result"]["Code"] == "01") {
					alert("근속포상대상자 생성내역이 확정되었습니다.");
					// 프로시저 호출 후 재조회
					doAction1("Search");
				} else if (res["Result"]["Message"] != null && res["Result"]["Message"] != "") {
					alert(res["Result"]["Message"]);
				}
			} else {
				alert("근속포상대상자 생성내역 확정처리 오류입니다.");
			}
        }
	}

	/**
	 * 근속포상대상자 확정취소
	 */
	function cancelLongWorkPersonMgr() {
		var searchYear = $("#searchYear").val();
		var searchPrizeYmd = $("#searchPrizeYmd").val();
		
		if(searchYear == "") {
			alert("기준년도를 입력해주세요.");
			return;
		}
		
		if(searchPrizeYmd == "") {
			alert("근속포상기준일를 입력해주세요.");
			return;
		}
		
        var conf = confirm(searchYear + "년도 데이터를 대상으로 포상일자가 " + searchPrizeYmd + "인 근속포상대상자 생성내역을 확정취소합니다. 진행하시겠습니까?");
        if(conf) {
	        var res = ajaxCall("${ctx}/LongWorkPersonMgr.do?cmd=prcP_HRM_LONG_WORK_PERSON_CANCEL", "searchYear="+searchYear+"&searchPrizeYmd="+searchPrizeYmd.replace(/-/gi, ""), false);
	        if (res != null && res["Result"] != null && res["Result"]["Code"] != null) {
				if (res["Result"]["Code"] == "01") {
					alert("해당 포상일자에 해당하는 근속포상대상자 데이터가 확정취소되었습니다.");
					// 프로시저 호출 후 재조회
					doAction1("Search");
				} else if (res["Result"]["Message"] != null && res["Result"]["Message"] != "") {
					alert(res["Result"]["Message"]);
				}
			} else {
				alert("근속포상대상자 생성내역 확정취소 오류입니다.");
			}
        }
	}
	
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "sheetAutocomplete"){
			sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
			sheet1.SetCellValue(gPRow, "name", rv["name"]);
			sheet1.SetCellValue(gPRow, "orgCd", rv["orgCd"]);
			sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
			sheet1.SetCellValue(gPRow, "jikchakCd", rv["jikchakCd"]);
			sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
			sheet1.SetCellValue(gPRow, "jikweeCd", rv["jikweeCd"]);
			sheet1.SetCellValue(gPRow, "jikweeNm", rv["jikweeNm"]);
			sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
			sheet1.SetCellValue(gPRow, "empYmd", rv["empYmd"]);
			sheet1.SetCellValue(gPRow, "gempYmd", rv["gempYmd"]);
		}
	}
</script>
</head>
<body class="bodywrap">
    <div class="wrapper">
    	<form id="srchFrm" name="srchFrm">
	    	<div class="sheet_search outer">
	    		<div>
	    			<table>
	    				<tr>
							<th class="hide">기준년월</th>
	    					<td  colspan="2" class="hide">
								<input type="text" id="searchFrom" name="searchFrom" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>"> ~
								<input type="text" id="searchTo" name="searchTo" class="date2" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
							</td>
							<th>기준년도</th>
	    					<td>
								<input type="text" id="searchYear" name="searchYear" maxlength="4" class="date2 required w40" value="${curSysYear}" required>
							</td>
						
							<th class="hide">사업장</th>
							<td class="hide">
								<select id="searchBusinessPlaceCd" name="searchBusinessPlaceCd" multiple></select>
								<input type="hidden" id="businessPlaceCd" name="businessPlaceCd" value=""/>
							</td>
							<th class="hide">근무지</th>
							<td class="hide">
								<select id="searchLocationCd" name="searchLocationCd" multiple></select>
								<input type="hidden" id="locationCd" name="locationCd" value=""/>
							</td>	
							<th>소속</th>						
							<td>
								<input type="text" class="text" id="searchOrgNm" name="searchOrgNm" />
							</td>
							<th>사번/성명</th>
							<td>
								<input type="text" class="text" id="searchSabunName" name="searchSabunName"/>
							</td>
							<td colspan="2">
								<input type="radio" id="gempEmp1" name="gempEmp" value="Gemp" class="hide"> <!-- 그룹	 -->
								<input type="radio" id="gempEmp2" name="gempEmp" value="Emp" checked class="hide">
							</td>
							<th>입사일</th>
							<td><input id="sdate" name="sdate" maxlength="10" type="text" class="text date2" value=""/>
								~
								<input id="edate" name="edate" maxlength="10" type="text" class="text date2" value=""/></td>
						</tr>
						<tr>
							<th>직책</th>
							<td>
								<select id="searchJikchakCd" name="searchJikchakCd" class="w100"></select>
							</td>
							<th>직위</th>
							<td>
								<select id="searchJikweeCd" name="searchJikweeCd" class="w100"></select>
							</td>
							<th>직급</th>
							<td>
								<select id="searchJikgubCd" name="searchJikgubCd" class="w100"></select>
							</td>
							<th>근속년수</th>
							<td>
								<select id="searchContYear" name="searchContYear" class="w100"></select>
								<!-- <input type="text" id="searchContYear" name="searchContYear" maxlength="4" class="date2 w40" value=""> -->
							</td>		
							<th>확정여부</th>					
							<td>
								<select name="searchConfirmYn" id="searchConfirmYn">
									<option value="" selected>전체</option>
									<option value="Y">확정</option>
									<option value="N">미확정</option>
								</select>
							</td>	
							<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>						
							<td>
								 <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
							</td>
							<td>
								<a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
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
								<li class="txt">근속포상대상자관리</li>
								<li class="btn">
									<span class="hide">
									<input type="radio" id="searchGempEmp" name="searchGempEmp" value="G" checked> 그룹입사일 기준
									<input type="radio" id="searchGempEmp" name="searchGempEmp" value="E"> 입사일 기준&nbsp;&nbsp;&nbsp;
									</span>
									<span>근속포상기준일</span>
									<input type="text" id="searchPrizeYmd" name="searchPrizeYmd" class="date2 required" value="<%//=DateUtil.getCurrentTime("yyyy-MM-dd")%>">
									<a id="btnCreLongWorkPerson" onclick="javascript:creLongWorkPersonList()" class="btn soft authA">근속포상 대상자 생성</a>
									<btn:a href="javascript:doAction1('Save')" css="btn soft authA" mid='save' mdef="저장"/>
									<a href="javascript:doAction1('confBatch')" class="btn filled authA"><tit:txt mid='' mdef='확정처리'/></a>
									<a href="javascript:doAction1('cancelBatch')" class="btn filled authA"><tit:txt mid='' mdef='확정취소'/></a>
									<btn:a href="javascript:doAction1('Down2Excel')" css="btn outline-gray authA" mid='down2excel' mdef="다운로드"/>
									<btn:a href="javascript:doAction1('Copy')" css="btn outline-gray authA" mid='copy' mdef="복사"/>
									<a href="javascript:doAction1('Insert')" class="btn outline-gray authA">입력</a>
		                        </li>
							</ul>
						</div>
					</div>
					<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
				</td>
			</tr>
		</table>
	</div>
</body>
</html>