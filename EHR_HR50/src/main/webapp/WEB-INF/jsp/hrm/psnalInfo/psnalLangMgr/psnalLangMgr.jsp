<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	var colShowYn = 0;
	if("${ssnAdminYn}" == "Y") {
		colShowYn = 0;
	} else {
		colShowYn = 1;
	}

	//20200910 조회 속도 개선으로 로직 변경
	var gradeCdAllList=[];

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
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
   			{Header:"No",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제", 				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}", Align:"Center",	ColMerge:0, SaveName:"sDelete", Sort:0},
   			{Header:"상태", 				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}", Align:"Center",	ColMerge:0, SaveName:"sStatus", Sort:0},
   			{Header:"소속",      			Type:"Text",		Hidden:0,   					Width:60,			Align:"Center",	ColMerge:0, SaveName:"orgNm",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:50 },
   			{Header:"사번",      			Type:"Text",		Hidden:0,   					Width:60,			Align:"Center",	ColMerge:0, SaveName:"sabun",		KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
   			{Header:"성명",      			Type:"Text",		Hidden:0,   					Width:60,			Align:"Center",	ColMerge:0, SaveName:"name",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
   			{Header:"직급",				Type:"Text",		Hidden:Number("${jgHdn}"),		Width:60,			Align:"Center",	ColMerge:0, SaveName:"jikgubNm",	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:15 },

			{Header:"일련번호",			Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:35 },
			{Header:"어학시험명",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fTestCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"외국어구분",			Type:"Combo",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"foreignCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"시험일자",			Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"applyYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"수당지급시작일", 		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"staYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"수당지급종료일", 		Type:"Date",		Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"endYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },

			{Header:"등급",				Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"testPoint",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"점수",				Type:"Text",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"passScores",	KeyField:0,	Format:"",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"만점",				Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fullScores",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"기관명",				Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"fTestOrgNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"첨부파일",			Type:"Html",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"첨부번호",			Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
			]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

			var foreignCdList	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20300"), "전체");
			var fTestCdList		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20307"), "전체");
			var testPointList	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20305"), "");

			$("#searchForeignCd").html(foreignCdList[2]);

			sheet1.SetColProperty("foreignCd", {ComboText:"|"+foreignCdList[0],	ComboCode:"|"+foreignCdList[1]});
			sheet1.SetColProperty("fTestCd",   {ComboText:"|"+fTestCdList[0],	ComboCode:"|"+fTestCdList[1]} );
			sheet1.SetColProperty("testPoint", {ComboText:"|"+testPointList[0],	ComboCode:"|"+testPointList[1]});

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
				businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, ("${ssnLocaleCd}" != "en_US" ? "전체" : "All"));	//사업장
			} else {
				businessPlaceCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList",url,false).codeList, "");	//사업장
			}
			$("#searchBizPlaceCd").html(businessPlaceCd[2]);


			$("#searchSabunNameAlias").bind("keyup",function(event){
				if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
			});

			$("#searchBizPlaceCd, #searchForeignCd,#searchStatusCd").bind("change",function(event){
				doAction1("Search");
			});

			gradeCdAllList = ajaxCall("${ctx}/PsnalLangMgr.do?cmd=getForeignGradeMgrList3", "", false).DATA;

			$(window).smartresize(sheetResize); sheetInit();
			doAction1("Search");
			
			// 이름 입력 시 자동완성
			$(sheet1).sheetAutocomplete({
				Columns: [
					{
						ColSaveName  : "name",
						CallbackFunc : function(returnValue){
							var rv = $.parseJSON('{' + returnValue+ '}');
							sheet1.SetCellValue(gPRow, "orgNm",			rv["orgNm"]);
							sheet1.SetCellValue(gPRow, "sabun",			rv["sabun"]);
							sheet1.SetCellValue(gPRow, "name",			rv["name"]);
							sheet1.SetCellValue(gPRow, "jikgubNm",		rv["jikgubNm"]);
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
			sheet1.DoSearch( "${ctx}/PsnalLangMgr.do?cmd=getPsnalLangMgrList", $("#srchFrm").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|foreignCd|fTestCd|applyYmd", false, true)){break;}
			setFileListArr('sheet1');
			IBS_SaveName(document.srchFrm,sheet1);
        	sheet1.DoSave( "${ctx}/PsnalLangMgr.do?cmd=savePsnalLangMgr", $("#srchFrm").serialize());
        	break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			sheet1.SetCellValue(row, "btnFile", '<a class="btn outline_gray thinner" >첨부</a>');
			sheet1.SelectCell(row, "컬럼명");
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"seq","");
			sheet1.SetCellValue(row, "btnFile", '<a class="btn outline_gray thinner" >첨부</a>');
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {DownCols:downcol, SheetDesign:1, Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "DownTemplate":
			sheet1.Down2Excel({
				TitleText:"*어학관리 일괄업로드       "
					+ "*필수입력항목을 꼭 입력해 주세요.     "
					+ "*파일업로드시에는 이 행을 삭제해야 합니다."
				, SheetDesign:1,Merge:0,DownCombo:"TEXT",UserMerge:"0,0,1,7",DownRows:"0", DownCols:"sabun|foreignCd|fTestCd|applyYmd|testPoint|passScores|staYmd|endYmd|officeNm"});
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	// 조회 후 이벤트
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			var rowCnt = sheet1.RowCount();

			for (var k=1; k<=rowCnt; k++) {
				setGradeCombo("fTestCd", k);
			}

			sheetResize();
		}catch(ex){
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
			//사원검색
			switch(sheet1.ColSaveName(Col)){
				case "name":
					if(!isPopup()) {return;}

					sheet1.SelectCell(Row,"name");

					openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "740","520", function (rv){
			        	sheet1.SetCellValue(Row, "sabun", 	 rv["sabun"]);
			        	sheet1.SetCellValue(Row, "orgNm", 	 rv["orgNm"]);
			        	sheet1.SetCellValue(Row, "name", 	 rv["name"]);
			        	sheet1.SetCellValue(Row, "jikgubNm", rv["jikgubNm"]);
					});
					break;
			}
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
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

	// 엑셀 업로드 후 이벤트
	function sheet1_OnLoadExcel() {
		for(var i = sheet1.HeaderRows(); i <= sheet1.LastRow(); i++) {
			setGradeCombo("passScores", i);
		}
	}

    // 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {
        var authPgTemp="${authPg}";
        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&uploadType=lang&authPg=${authPg}'
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
                            sheet1.SetCellValue(gPRow, "btnFile", '<a class="btn outline_gray thinner">다운로드</a>');
                            sheet1.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            sheet1.SetCellValue(gPRow, "btnFile", '<a class="btn outline_gray thinner">첨부</a>');
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
	function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "fileMgrPopup") {
			if(rv["fileCheck"] == "exist"){
				sheet1.SetCellValue(gPRow, "btnFile", '<a class="btn outline_gray thinner">다운로드</a>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				sheet1.SetCellValue(gPRow, "btnFile", '<a class="btn outline_gray thinner">첨부</a>');
				sheet1.SetCellValue(gPRow, "fileSeq", "");
			}
		}
    }

	// 셀 값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			setForeignCdCombo(sheet1.ColSaveName(Col), Row);
			setGradeCombo(sheet1.ColSaveName(Col), Row);
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function setForeignCdCombo(colName, Row) {
		if(colName == "fTestCd") {
			var fTestCd     = sheet1.GetCellValue(Row,"fTestCd");
			var fTestCdList = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20307");

			$.each(fTestCdList, function(idx, value) {
				if(fTestCd == value.code) {
					sheet1.SetCellValue(Row,"foreignCd",$.trim(value.note1));
				}
			});
		}
	}

// 	function setGradeCombo(colName, Row) {

// 		if(colName == "fTestCd") {
// 			var fTestCd = sheet1.GetCellValue(Row,"fTestCd");
// 			var gradeCd = ajaxCall("${ctx}/ForeignGradeMgr.do?cmd=getForeignGradeMgrList2","searchFTestCd="+fTestCd,false).DATA;

// 			// 조회조건 테이블명 셋팅
// 			var comboValueTxt = "";
// 			var comboNameTxt = "";

// 			if(gradeCd[0] != undefined) {
// 				if(gradeCd[0].pointType == "C") {
// 					for(var i=0; i<gradeCd.length; i++) {
// 						if(i > 0 ) {
// 							comboValueTxt += "|";
// 							comboNameTxt  += "|";
// 						}
// 						comboValueTxt += gradeCd[i].minPoint;
// 						comboNameTxt  += gradeCd[i].minPoint;
// 					}
// 					var info = {Type: "Combo", Align: "Center", "ComboCode":comboValueTxt,"ComboText":comboNameTxt};
// 					sheet1.InitCellProperty(Row, "passScores", info);
// 				} else {
// 					var info = {Type: "Text", Align: "Center", Format:"Number"};
// 					sheet1.InitCellProperty(Row, "passScores", info);
// 				}
// 			}
// 		} else if(colName == "passScores") {
// 			var fTestCd    = sheet1.GetCellValue(Row,"fTestCd");
// 			var passScores = sheet1.GetCellValue(Row,"passScores");
// 			var gradeNm    = ajaxCall("${ctx}/PsnalLang.do?cmd=getForeignGradeNm","searchFTestCd="+fTestCd+"&searchPassScores=" + passScores,false).DATA.testPoint;

// 			sheet1.SetCellValue(Row, "testPoint", gradeNm);
// 		}
// 	}

	//20200910 조회 속도 개선으로 로직 변경
	function setGradeCombo(colName, Row) {

		if(colName == "fTestCd") {
			var fTestCd = sheet1.GetCellValue(Row,"fTestCd");
			var gradeCd = new Array();
			for(var i=0;i<gradeCdAllList.length;i++) {
				if(gradeCdAllList[i].fTestCd == fTestCd) {
					gradeCd.push(gradeCdAllList[i]);
				}
			}

			// 조회조건 테이블명 셋팅
			var comboValueTxt = "";
			var comboNameTxt  = "";

			if(gradeCd[0] != undefined) {
				if(gradeCd[0].pointType == "C") {
					for(var i=0; i<gradeCd.length; i++) {
						if(i > 0 ) {
							comboValueTxt += "|";
							comboNameTxt  += "|";
						}
						comboValueTxt += gradeCd[i].minPoint;
						comboNameTxt  += gradeCd[i].minPoint;
					}
					var info = {Type: "Combo", Align: "Center", "ComboCode":comboValueTxt,"ComboText":comboNameTxt};
					sheet1.InitCellProperty(Row, "passScores", info);
				} else {
					var info = {Type: "Text", Align: "Center", Format:""};
					sheet1.InitCellProperty(Row, "passScores", info);
				}
			}
		} else if(colName == "passScores") {

			let type = sheet1.GetCellProperty(Row,"passScores", "Type");
			var fTestCd    = sheet1.GetCellValue(Row,"fTestCd");
			var passScores = sheet1.GetCellValue(Row,"passScores");
			var gradeNm    = ajaxCall("${ctx}/PsnalLang.do?cmd=getForeignGradeNm","searchFTestCd="+fTestCd+"&searchPassScores=" + passScores,false).DATA;

			// testPoint 값이 있는 경우에만 조회결과 입력
			if(gradeNm != null && typeof gradeNm.testPoint != 'undefined') {
				sheet1.SetCellValue(Row, "testPoint", gradeNm.testPoint);
			} else {
				sheet1.SetCellValue(Row, "testPoint", "");
			}

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
			<th>외국어</th>
			<td>
				<select id="searchForeignCd" name="searchForeignCd"> </select>
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
					<li class="txt">개인별어학관리</li>
					<li class="btn">
						<btn:a href="javascript:doAction1('Insert')" 		css="btn outline_gray authA" mid='insert' 		 mdef="입력"/>
						<btn:a href="javascript:doAction1('Copy')" 			css="btn outline_gray authA" mid='copy' 		 mdef="복사"/>
						<btn:a href="javascript:doAction1('Save')" 			css="btn filled authA" mid='save' 		 mdef="저장"/>
						<btn:a href="javascript:doAction1('DownTemplate')" 	css="btn outline_gray authR" mid='down2ExcelV1' mdef="양식다운로드"/>
						<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline_gray authR" mid='upload' 		 mdef="업로드"/>
						<a href="javascript:doAction1('Down2Excel')" 		class="btn outline_gray authR" >다운로드</a>
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