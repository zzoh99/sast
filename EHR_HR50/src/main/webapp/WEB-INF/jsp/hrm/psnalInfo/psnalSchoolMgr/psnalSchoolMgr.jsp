<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>

<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
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

		//IBsheet1 init
		var initdata = {};
		initdata.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
   			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제", 				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}", Align:"Center",	ColMerge:0, SaveName:"sDelete", Sort:0},
   			{Header:"상태", 				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}", Align:"Center",	ColMerge:0, SaveName:"sStatus", Sort:0},
   			{Header:"소속",      			Type:"Text",		Hidden:0,   					Width:70,			Align:"Center",	ColMerge:0, SaveName:"orgNm",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
   			{Header:"사번",      			Type:"Text",		Hidden:0,   					Width:60,			Align:"Center",	ColMerge:0, SaveName:"sabun",		KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
   			{Header:"성명",      			Type:"Text",		Hidden:0,   					Width:60,			Align:"Center",	ColMerge:0, SaveName:"name",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
   			{Header:"직급",				Type:"Text",		Hidden:Number("${jgHdn}"),		Width:60,			Align:"Center",	ColMerge:0, SaveName:"jikgubNm",	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },

   			{Header:"일련번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"학력구분",			Type:"Combo",		Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"acaCd",		KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"학위구분",			Type:"Combo",		Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"acaDegCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"학교코드",			Type:"Text",		Hidden:1,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"acaSchCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"학교명",				Type:"PopupEdit",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"acaSchNm",	KeyField:1,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"전공코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acamajCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"전공",				Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"acamajNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"복수전공",			Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"doumajNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"부전공코드",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"submajCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"부전공",				Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"submajNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"학점",				Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"acaPoint",	KeyField:0,	Format:"Float",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"학점만점",			Type:"Text",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"acaPointManjum",	KeyField:0,	Format:"Float",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

			{Header:"입학년월",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"acaSYm",		KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
			{Header:"졸업년월",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"acaEYm",		KeyField:0,	Format:"Ym",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7 },
			{Header:"졸업구분",			Type:"Combo",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"acaYn",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"학위번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"gradeNo",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:30 },

			{Header:"소재지코드",			Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acaPlaceCd",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"소재지",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"acaPlaceNm",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"본분교",				Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"eType",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"주야간",				Type:"Combo",		Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"dType",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"편입\n여부",			Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"entryType",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },
			{Header:"최종학력\n여부",		Type:"CheckBox",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"acaType",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N" },

			{Header:"비고",				Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"첨부파일",			Type:"Html",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"첨부번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
			];  IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		var acaCdList		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20130"), "전체");
		var acaDegCdList	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20140"),"전체");
		var acaPlaceCdList	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F64140"), "전체");
		var acaYnList		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","F20140"), "전체");

		sheet1.SetColProperty("acaCd", 				{ComboText:"|"+acaCdList[0],		ComboCode:"|"+acaCdList[1]} );
		sheet1.SetColProperty("acaDegCd", 			{ComboText:"|"+acaDegCdList[0],		ComboCode:"|"+acaDegCdList[1]} );
		sheet1.SetColProperty("acaPlaceCd", 		{ComboText:"|"+acaPlaceCdList[0],	ComboCode:"|"+acaPlaceCdList[1]} );
		sheet1.SetColProperty("acaYn", 				{ComboText:"|"+acaYnList[0],		ComboCode:"|"+acaYnList[1]} );
		sheet1.SetColProperty("eType", 				{ComboText:("${ssnLocaleCd}" != "en_US" ? "|본교|분교" : "|Main School|Branch School"), ComboCode:"|Y|N"} );
		sheet1.SetColProperty("dType", 				{ComboText:("${ssnLocaleCd}" != "en_US" ? "|주간|야간" : "|Weekly|Night"), ComboCode:"|Y|N"} );
		$("#searchAcaCd").html(acaCdList[2]);

		//재직상태(디폴트값 : 재직)
		var statusCdList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "전체");
		$("#searchStatusCd").html(statusCdList[2]);
		$("#searchStatusCd").val("AA").prop("selected", true);

		//사업장코드 관리자권한만 전체사업장 보이도록, 그외는 권한사업장만.
		var url     = "queryId=getBusinessPlaceCdList";
		var allFlag = true;
		if ("${ssnSearchType}" != "A"){
			url    += "&searchChkPlace=Y&sabun=${ssnSabun}&grpCd=${ssnGrpCd}";
			allFlag = false;
		}
		var businessPlaceCd = "";
		if(allFlag) {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "전체");	//사업장
		} else {
			businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "전체");	//사업장
		}
		$("#searchBizPlaceCd").html(businessPlaceCd[2]);

		$("#searchSabunNameAlias").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchBizPlaceCd, #searchAcaCd, #searchStatusCd").bind("change",function(event){
			doAction1("Search");
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");

		//setSheetAutocompleteEmp( "sheet1", "name");
		//Autocomplete
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikchakCd",	rv["jikchakCd"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "statusCd",	rv["statusCd"]);
						sheet1.SetCellValue(gPRow, "statusNm",	rv["statusNm"]);
						sheet1.SetCellValue(gPRow, "empYmd",	rv["empYmd"]);
						sheet1.SetCellValue(gPRow, "gempYmd",	rv["gempYmd"]);
					}
				}
			]
		});
		
	});

	/* IB시트 함수 */
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
			sheet1.DoSearch( "${ctx}/PsnalSchoolMgr.do?cmd=getPsnalSchoolMgrList", $("#srchFrm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|acaSYm|acaCd|acaSchNm", true, true)){break;}
			setFileListArr('sheet1');
        	IBS_SaveName(document.srchFrm,sheet1);
        	sheet1.DoSave( "${ctx}/PsnalSchoolMgr.do?cmd=savePsnalSchoolMgr", $("#srchFrm").serialize());
        	break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "btnFile", '<a class="basic" >첨부</a>');
			sheet1.SelectCell(row, "컬럼명");
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"seq","");
			sheet1.SetCellValue(row, "btnFile", '<a class="basic" >첨부</a>');			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({
					TitleText:"*학력관리 일괄업로드   "
						+ "*필수입력항목을 꼭 입력해 주세요. 최종학력여부/편입여부는 0 또는 1로 기입 해주세요.     "
						+ "*파일업로드시에는 이 행을 삭제해야 합니다."
					, SheetDesign:1,Merge:0,DownCombo:"TEXT",UserMerge:"0,0,1,16",DownRows:"0",DownCols:"sabun|acaCd|acaSchNm|acamajNm|doumajNm|submajNm|acaPoint|acaPointManjum|acaSYm|acaEYm|acaYn|acaPlaceNm|eType|dType|entryType|acaType|note"});
			break;
		}
	}

	// 조회 후 이벤트
// 	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
// 		try {
// 			if (Msg != "") alert(Msg);

// 			//파일첨부
// 			for(var r = sheet1.HeaderRows(); r<=sheet1.RowCount(); r++) {
// 				var code = sheet1.GetCellValue(i+1,"acaCd");

// 				if(code == "") {
// 					sheet1.SetCellValue(i+1,"acaSchNm","");
// 					sheet1.SetColEditable("acaSchNm",false);
// 				} else if(code=="DS3" || code == "DS4" || code == "DS5" || code == "DS6" || code == "DS7") {
// 					var info = {Type: "PopupEdit", Align: "Left", Edit:1};
// 					sheet1.InitCellProperty(i+1, "acaSchNm", info);
// 					sheet1.SelectCell(i+1,"acaSchNm");
// 				} else {
// 					var info = {Type: "Text", Align: "Left", Edit:1};
// 					sheet1.InitCellProperty(i+1, "acaSchNm", info);
// 					sheet1.SelectCell(i+1,"acaSchNm");
// 				}
// 			}

// 			sheetResize();
// 		} catch(ex) {
// 			alert("OnSearchEnd Event Error : " + ex);
// 		}
// 	}

	// 조회 후 이벤트
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") alert(Msg);

			//파일첨부
			for(var r = sheet1.HeaderRows(); r<=sheet1.RowCount(); r++) {
				var code = sheet1.GetCellValue(r+1,"acaCd");

				if(code == "") {
					sheet1.SetCellValue(r+1,"acaSchNm","");
					sheet1.SetColEditable("acaSchNm",false);
				} else {
					var info = {Type: "PopupEdit", Align: "Left", Edit:1};
					sheet1.InitCellProperty(r+1, "acaSchNm", info);
				}
			}

			sheetResize();
		} catch(ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 이벤트
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			//작업
			if ( Code > -1){
				doAction1("Search");
			}
		}catch(ex){
			alert("OnSaveEnd Event Error : " + ex);
		}
	}

	// 팝업 클릭시 이벤트
	function sheet1_OnPopupClick(Row, Col){
		try{
			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}

				sheet1.SelectCell(Row,"name");

				openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "740","520", function (rv){
		        	sheet1.SetCellValue(Row, "sabun", rv["sabun"]);
		        	sheet1.SetCellValue(Row, "orgNm", rv["orgNm"]);
		        	sheet1.SetCellValue(Row, "name", rv["name"]);
		        	sheet1.SetCellValue(Row, "jikgubNm", rv["jikgubNm"]);
				});
			} else if(sheet1.ColSaveName(Col) == "acaSchNm") {
				if(!isPopup()) {return;}

				if(sheet1.GetCellValue(Row,"acaCd") == "") {
					alert("<msg:txt mid='109879' mdef='학력구분을 선택하여 주십시오.'/>");
					return;
				}

				gPRow = Row;
				pGubun = "schoolPopup";

				let defaultArgs = {"grpCd": "H20145"};

				let layerModal = new window.top.document.LayerModal({
					id : 'commonCodeLayer',
					url : '/CommonCodeLayer.do?cmd=viewCommonCodeLayer&authPg=R',
					parameters: defaultArgs,
					width : 650,
					height : 620,
					title : "학교검색",
					trigger :[
						{
							name : 'commonCodeTrigger',
							callback : function(result){
								getReturnValue(result);
							}
						}
					]
				});
				layerModal.show();
			} else if(sheet1.ColSaveName(Col) == "acamajNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "acaMajPopup";

				var param = [];

	            var win = openPopup("/HrmAcaMajPopup.do?cmd=viewHrmAcaMajPopup&authPg=${authPg}", param, "740","620");
			} else if(sheet1.ColSaveName(Col) == "submajNm") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "subAcaMajPopup";

				var param = [];

	            var win = openPopup("/HrmAcaMajPopup.do?cmd=viewHrmAcaMajPopup&authPg=${authPg}", param, "740","620");
			}

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 셀 클릭시 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "acaCd"  ) {
				var code = sheet1.GetCellValue( Row,Col);

				sheet1.SetCellValue(Row,"acaSchCd","");
				sheet1.SetCellValue(Row,"acaSchNm","");


				if(code == "") {
					sheet1.SetColEditable("acaSchNm",false);
				} else {
					var info = {Type: "PopupEdit", Align: "Left", Edit:1};
					sheet1.InitCellProperty(Row, "acaSchNm", info);
					sheet1.SelectCell(Row,"acaSchNm");
				}
		    }
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "btnFile" && Value != ""){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");
				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					pGubun = "fileMgrPopup";
					gPRow = Row;

					var authPgTemp="${authPg}";
					fileMgrPopup(Row, Col);
					//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&uploadType=contact&authPg="+authPgTemp, param, "740","620");
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	// 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {
        var authPgTemp="${authPg}";
        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&uploadType=school&authPg=${authPg}'
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
    //파일 신청 끝
    
    
	// 팝업 리턴 함수
	function getReturnValue(rv) {

       	if(pGubun == "schoolPopup") {
           	sheet1.SetCellValue(gPRow, "acaSchCd", rv["code"]);
           	sheet1.SetCellValue(gPRow, "acaSchNm", rv["codeNm"]);
    	} else if(pGubun == "acaMajPopup") {
           	sheet1.SetCellValue(gPRow, "acamajCd", rv["code"]);
           	sheet1.SetCellValue(gPRow, "acamajNm", rv["codeNm"]);
    	} else if(pGubun == "subAcaMajPopup") {
           	sheet1.SetCellValue(gPRow, "submajCd", rv["code"]);
           	sheet1.SetCellValue(gPRow, "submajNm", rv["codeNm"]);
    	} else if(pGubun == "fileMgrPopup") {
 			if(rv["fileCheck"] == "exist"){
 				sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic">다운로드</a>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
	 		}else{
	 			sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic">첨부</a>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
	 		}
    	} else if(pGubun == "employeePopup") {
           	sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
           	sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
           	sheet1.SetCellValue(gPRow, "name", rv["name"]);
           	sheet1.SetCellValue(gPRow, "jikgubNm", rv["jikgubNm"]);
        }
       	
	    if(pGubun == "sheetAutocompleteEmp"){
            sheet1.SetCellValue(gPRow, "name",   	rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",   	rv["sabun"] );
            sheet1.SetCellValue(gPRow, "orgNm",   	rv["orgNm"] );
            sheet1.SetCellValue(gPRow, "manageNm",   rv["manageNm"] );
            sheet1.SetCellValue(gPRow, "jikgubNm",   rv["jikgubNm"] );
            sheet1.SetCellValue(gPRow, "statusNm",   rv["statusNm"] );
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
			<th>사업장</th>
			<td>
				<select id="searchBizPlaceCd" name="searchBizPlaceCd"> </select>
			</td>
			<th>학력</th>
			<td>
				<select id="searchAcaCd" name="searchAcaCd"> </select>
			</td>
			<th>재직상태</th>
			<td>
				<select id="searchStatusCd" name="searchStatusCd"> </select>
			</td>
			<th>사번/성명</th>
			<td>
				<input id="searchSabunNameAlias" name="searchSabunNameAlias" type="text" class="text" />
			</td>
			<td><a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark" >조회</a></td>
		</tr>
		</table>
		</div>
	</div>

	</form>

	<table class="sheet_main">
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">개인별학력관리</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Insert')" css="btn outline_gray authA" mid='insert' mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy')" 	css="btn outline_gray authA" mid='copy' mdef="복사"/>
						<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='save' mdef="저장"/>
						<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline_gray authR" mid='down2ExcelV1' mdef="양식다운로드"/>
						<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline_gray authR" mid='upload' mdef="업로드"/>
						<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR" >다운로드</a>
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