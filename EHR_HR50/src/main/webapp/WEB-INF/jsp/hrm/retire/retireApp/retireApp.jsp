<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>퇴직신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script src="/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:msHeaderOnly, Page:22, FrozenCol:0, DataRowMerge:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
  			{Header:"No|No",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제|삭제",				Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
   			{Header:"상태|상태",				Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"삭제|삭제",				Type:"Html",  		Hidden:0,	Width:45, 	Align:"Center", ColMerge:1, SaveName:"btnDel",		Format:"",		UpdateEdit:0, InsertEdit:0, Sort:0, Cursor:"Pointer" },
			{Header:"세부\n내역|세부\n내역",		Type:"Image",		Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"사직원|사직원",			Type:"Html",  		Hidden:0,	Width:50, 	Align:"Center", ColMerge:0, SaveName:"btnPrt",		Format:"",		UpdateEdit:0, InsertEdit:0 },
			{Header:"사번|사번",				Type:"Text",		Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"신청일|신청일",			Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"신청상태|신청상태",		    Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applStatusCd",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종출근일|최종출근일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"finWorkYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"퇴직희망일|퇴직희망일",		Type:"Date",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retSchYmd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"퇴직일|퇴직일",			Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"retYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"비밀유지서약서|비밀유지서약서",		Type:"Image",		Hidden:Number("${retAgreeHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"agreeImage",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"퇴직설문|퇴직설문",			Type:"Image",		Hidden:Number("${retSurveyHdn}"),	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"surveyImage",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"퇴직사유|퇴직사유",			Type:"Text",		Hidden:1,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"retReasonNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:4 },
			{Header:"인수인계서|등록여부",		Type:"CheckBox",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"takeoverFileYn",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"인수인계서|첨부파일",		Type:"Html",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"첨부번호|첨부번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"takeoverFileSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },			
			{Header:"대상자사번|대상자사번",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"신청순번|신청순번",			Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"신청자사번|신청자사번",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"applInSabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			
			{Header:"비밀유지첨부서명|비밀유지첨부서명",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"signFileSeq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"사직원첨부서명|사직원첨부서명",		Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"signFileSeq1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"rk",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"rk",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			{Header:"rk2",						Type:"Text",		Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"rk2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0},
			]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetCountPosition(0);
		sheet1.SetImageList(0,"/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("ibsImage", 1);
		sheet1.SetDataLinkMouse("agreeImage", 1);
		sheet1.SetDataLinkMouse("surveyImage", 1);
		var applStatusCd = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "");

		sheet1.SetColProperty("applStatusCd", 	{ComboText:applStatusCd[0], ComboCode:applStatusCd[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#searchUserId").val();
			sheet1.DoSearch( "${ctx}/RetireApp.do?cmd=getRetireAppList",param );
			break;
			
		case "Save":
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/RetireApp.do?cmd=saveRetireApp", $("#sheet1Form").serialize(), -1, 0);
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
			
			//파일 첨부 시작
			for(var r = sheet1.HeaderRows(); r<sheet1.RowCount()+sheet1.HeaderRows(); r++){
				
				sheet1.SetCellValue(r, "btnPrt", '<a class="basic" onclick="rdPopup('+r+')">출력</a>');
				sheet1.SetCellValue(r, "sStatus","R");
				
				if(sheet1.GetCellValue(r,"takeoverFileSeq") == ''){
					sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid="attachFile" mdef="첨부"/>');
					sheet1.SetCellValue(r, "sStatus", 'R');					
				}else{
					sheet1.SetCellValue(r, "btnFile", '<btn:a css="basic" mid="down2excel" mdef="다운로드"/>');
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
				//alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "ibsImage" && Row >= sheet1.HeaderRows()) {

		    	var auth = "R";
		    	if(sheet1.GetCellValue(Row, "applStatusCd") == "11") {
		    		//신청 팝업
		    		auth = "A";
		    	} else {
		    		//결재팝업
		    		auth = "R";
		    	}

	    		showApplPopup(auth,sheet1.GetCellValue(Row,"applSeq"),sheet1.GetCellValue(Row,"applInSabun"),sheet1.GetCellValue(Row,"applYmd"));

		    } else if(sheet1.ColSaveName(Col) == "btnFile"){
		    	//인수인계서 파일첨부
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"takeoverFileSeq");
				//param["msgDiv"] = 100; // alert 창 안뛰우게 수정
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup1";

					var authPgTemp="${authPg}";
					var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=assurance", param, "1024","400");
				}
			} else if( sheet1.ColSaveName(Col) == "agreeImage" && Row >= sheet1.HeaderRows()) {
				//비밀유지서약서
				if(!isPopup()) {return;}
				// var Row = sheet1.LastRow();
				const data = {
					rk : sheet1.GetCellValue(Row, 'rk'),
					type : 1
				};
				window.top.showRdLayer('/RetireApp.do?cmd=getEncryptRd', data, null,"비밀유지서약서");

		    } else if( sheet1.ColSaveName(Col) == "surveyImage" && Row >= sheet1.HeaderRows()) {
		    	//설문지
		    	if(!isPopup()) {return;}
		    	var auth = "R";
		    	if(sheet1.GetCellValue(Row, "applStatusCd") == "11") {
		    		//신청 팝업
		    		auth = "A";
		    	} else {
		    		//결재팝업
		    		auth = "R";
		    	}

		    	<%--var url    = "${ctx}/RetireApp.do?cmd=viewRetireSurveyPopup&authPg=" + auth;--%>
		        <%--var args    = new Array();--%>

				<%--var	sabun 	= sheet1.GetCellValue(Row,"sabun");--%>
				<%--var	reqDate = sheet1.GetCellValue(Row,"applYmd");--%>
				<%--var	applSeq = sheet1.GetCellValue(Row,"applSeq");--%>

		        <%--args["sabun"]    = sabun;--%>
		        <%--args["reqDate"]  = reqDate;--%>
		        <%--args["applSeq"]  = applSeq;--%>

		        <%--openPopup(url, args, "820","900");--%>
				var url    = "${ctx}/RetireApp.do?cmd=viewRetireSurveyLayer&authPg=" + auth;
				var w = 835, h = 700;
				var title = '퇴직설문지';
				var sabun, reqDate, applSeq;
				sabun 	= sheet1.GetCellValue(Row,"sabun");
				reqDate = sheet1.GetCellValue(Row,"applYmd");
				applSeq = sheet1.GetCellValue(Row,"applSeq");

				var p = {	sabun, reqDate, applSeq  };
				var layer = new window.top.document.LayerModal({
					id: 'retireSurveyLayer',
					url,
					parameters: p,
					width: w,
					height: h,
					title: title,
					trigger: [
						{
							name: 'retireSurveyLayerTrigger',
							callback: function(rv) {
								$("#surveyYn").val(rv.surveyYn);
								if(rv.surveyYn == "Y") {
									$("#surveyText").text("제출");
									$("#surveyText").css("color","##008fd5");
								}
							}
						}
					]
				});
				layer.show();
		    } else if( sheet1.ColSaveName(Col) == "btnDel" && Value != ""){
		    	if( !confirm("삭제하시겠습니까?")) { initDelStatus(sheet1); return;}
				sheet1.SetCellValue(Row, "sStatus", "D");
				doAction1("Save");
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 체크 되기 직전 발생.
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
			/* sheet1.SetAllowCheck(true);
		    if(sheet1.ColSaveName(Col) == "sDelete") {
		        if(sheet1.GetCellValue(Row, "applStatusCd") != "11") {
		            alert("임시저장일 경우만 삭제할 수 있습니다.");
		            sheet1.SetAllowCheck(false);
		            return;
		        }
		    } */
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}

	// 헤더에서 호출
	function setEmpPage() {
		doAction1("Search");
	}

	//신청 팝업
	function showApplPopup(auth,seq,applInSabun,applYmd) {
		if(!isPopup()) {return;}

		if(auth == "") {
			alert("권한을 입력하여 주십시오.");
			return;
		}

		pGubun = "approvalMgr";
		var p = {
				searchApplCd: '99'
			  , searchApplSeq: seq
			  , adminYn: 'N'
			  , authPg: auth
			  , searchSabun: applInSabun
			  , searchApplSabun: $('#searchUserId').val()
			  , searchApplYmd: applYmd 
			};
		var url = "";
		var initFunc = '';
		if(auth == "A") {
			url     = "/ApprovalMgr.do?cmd=viewApprovalMgrLayer";
			initFunc = 'initLayer';
		} else {
			url ="/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer";
			initFunc = 'initResultLayer';
		}

		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 1100,
			height: 815,
			title: '퇴직원작성/신청',
			trigger: [
				{
					name: 'approvalMgrLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		approvalMgrLayer.show();
	}

 
	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		if(pGubun == "approvalMgr") {
			doAction1("Search");
		} else if(pGubun == "fileMgrPopup1") {
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid="down2excel" mdef="다운로드"/>');
				sheet1.SetCellValue(gPRow, "takeoverFileSeq", rv["fileSeq"]);
				sheet1.SetCellValue(gPRow, "takeoverFileYn", "Y");
				
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid="attachFile" mdef="첨부"/>');
				sheet1.SetCellValue(gPRow, "takeoverFileSeq", "");
				sheet1.SetCellValue(gPRow, "takeoverFileYn", "N");
			}
			if(sheet1.GetCellValue(gPRow, "sStatus") != 'R'){
				doAction1("Save");
			};
		}
	}

	
	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(row){
		if(!isPopup()) {return;}

		// var Row = sheet1.LastRow();
		const data = {
			rk : sheet1.GetCellValue(row, 'rk2'),
			type : 2
		};
		window.top.showRdLayer('/RetireApp.do?cmd=getEncryptRd', data, null, "사직원");
	}

 
</script>
</head>
<body class="bodywrap">
<form id="sheet1Form" name="sheet1Form"></form>
<div class="wrapper">

	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">퇴직신청</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" class="btn outline-gray">다운로드</a>
				<btn:a href="javascript:showApplPopup('A','','${ssnSabun}','${curSysYyyyMMdd}');" css="btn filled" mid='applButton' mdef="신청"/>
				<a href="javascript:doAction1('Search')" 		class="btn dark">조회</a>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
