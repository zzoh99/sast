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

	$(function() {
		// 파일 업로드 초기 설정을 위한 함수 호출 initIbFileUpload(form object)
		initIbFileUpload($("#sheet1Form"));

		// 파일 목록 변수의 초기화 작업 시점 정의
		// clearBeforeFunc(function object)
		// 	-> 파일 목록 변수의 초기화 작업은 매개 변수로 넘긴 함수가 호출되기 전에 전처리 단계에서 수행
		//		ex. sheet1_OnSearchEnd 를 인자로 넘긴 경우, sheet1_OnSearchEnd 함수 호출 직전 파일 목록 변수 초기화
		//	기본적으로 [sheet]_OnSearchEnd, [sheet]_OnSaveEnd 에는 필수로 적용해 주어야 함.
		sheet1_OnSearchEnd = clearBeforeFunc(sheet1_OnSearchEnd);
		sheet1_OnSaveEnd = clearBeforeFunc(sheet1_OnSaveEnd)

		var initdata1 = {};
		initdata1.Cfg = {FrozenCol:6,SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),		Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"삭제", 			Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),	Width:"${sDelWdt}", Align:"Center",	ColMerge:0, SaveName:"sDelete", Sort:0},
   			{Header:"상태", 			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}", Align:"Center",	ColMerge:0, SaveName:"sStatus", Sort:0},
   			{Header:"소속",      		Type:"Text",		Hidden:0,   					Width:70,			Align:"Center",	ColMerge:0, SaveName:"orgNm",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
   			{Header:"사번",      		Type:"Text",		Hidden:0,   					Width:60,			Align:"Center",	ColMerge:0, SaveName:"sabun",		KeyField:1, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
   			{Header:"성명",      		Type:"Text",		Hidden:0,   					Width:60,			Align:"Center",	ColMerge:0, SaveName:"name",		KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },   			
   			{Header:"직급",			Type:"Text",		Hidden:Number("${jgHdn}"),		Width:60,			Align:"Center",	ColMerge:0, SaveName:"jikgubNm",	KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			
			{Header:"<sht:txt mid='fileSeqV5' mdef='일련번호'/>", Type:"Text",		Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='licenseCd' mdef='자격증코드'/>",Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"licenseCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='licenseNm' mdef='자격증명'/>", Type:"Popup",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"licenseNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='grade' mdef='등급'/>", Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"licenseGrade",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='licenseGubun' mdef='자격증구분'/>", Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"licenseGubun",KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='licSYmd' mdef='취득일'/>", Type:"Date",		Hidden:0,	Width:85,	Align:"Center",	ColMerge:0,	SaveName:"licSYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='licUYmd' mdef='갱신일\n(교부일)'/>", Type:"Date",		Hidden:0,	Width:85,	Align:"Center",	ColMerge:0,	SaveName:"licUYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='licEYmd' mdef='만료일'/>", Type:"Date",		Hidden:0,	Width:85,	Align:"Center",	ColMerge:0,	SaveName:"licEYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"발급기관", Type:"Text",		Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"officeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='licenseNo' mdef='자격증번호'/>", Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"licenseNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"자격수당금액", Type:"Int",		Hidden:1,	Width:100,	Align:"Right",	ColMerge:0,	SaveName:"allowAmount",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='allowSymd' mdef='수당지급\n시작일'/>", Type:"Date",		Hidden:0,	Width:85,	Align:"Center",	ColMerge:0,	SaveName:"allowSymd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='allowEymd' mdef='수당지급\n종료일'/>", Type:"Date",		Hidden:0,	Width:85,	Align:"Center",	ColMerge:0,	SaveName:"allowEymd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='allowYnV1' mdef='수당여부'/>", Type:"Combo",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"allowYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"관련근거", Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"licenseBigo",	KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000 },
			{Header:"<sht:txt mid='btnFileV1' mdef='파일첨부'/>", Type:"Html",		Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeqV1' mdef='파일번호'/>", Type:"Text",		Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			];IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		var licenseList		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20160"), "전체");
		$("#searchLicenseGubun").html(licenseList[2]);


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

		$("#searchBizPlaceCd, #searchLicenseGubun,#searchStatusCd").bind("change",function(event){
			doAction1("Search");
		});

		var userCd1 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20170"), "");

		sheet1.SetColProperty("licenseGubun", 	{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		sheet1.SetColProperty("allowYn", 	{ComboText:"|Y|N", ComboCode:"|Y|N"} );

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

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			clearFileListArr('sheet1'); // 파일 목록 변수의 초기화
			sheet1.DoSearch( "${ctx}/PsnalLicenseMgr.do?cmd=getPsnalLicenseMgrList", $("#sheet1Form").serialize() );
			break;
		case "Save":
			if(!dupChk(sheet1,"sabun|licenseCd|licenseNm", true, true)){break;}
			setFileListArr('sheet1');
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "${ctx}/PsnalLicenseMgr.do?cmd=savePsnalLicenseMgr", $("#sheet1Form").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			//파일첨부 시작
			sheet1.SetCellValue(row, "btnFile", '<btn:a css="btn outline_gray thinner" mid='110922' mdef="첨부"/>');
			//파일첨부 끝
			break;
		case "Copy":
			var row = sheet1.DataCopy();
			sheet1.SetCellValue(row,"seq","");
			break;
		case "Clear":
			sheet1.RemoveAll();
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({
					TitleText:"*자격증일괄업로드       "
						+ "*필수입력항목을 꼭 입력해 주세요.     "
						+ "*파일업로드시에는 이 행을 삭제해야 합니다."
					, SheetDesign:1,Merge:0,DownCombo:"TEXT",UserMerge:"0,0,1,8",DownRows:"0",DownCols:"sabun|licenseCd|licenseNm|licSYmd|licUYmd|licEYmd|officeCd|licenseNo|licenseBigo"});
			break;
		case "LoadExcel":
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			for(var i = 0; i < sheet1.RowCount(); i++) {
				/*var code = sheet1.GetCellValue(i+1,"licenseGubun");
alert(code);
				if(code == "") {
					sheet1.SetCellValue(i+1,"licenseNm","");
					sheet1.SetColEditable("licenseNm",false);
				} else if(code != "99") {
					var info = {Type: "Popup", Align: "Left", Edit:1};
					sheet1.InitCellProperty(i+1, "licenseNm", info);
					sheet1.SelectCell(i+1,"licenseNm");
				} else {
					var info = {Type: "Text", Align: "Left", Edit:1};
					sheet1.InitCellProperty(i+1, "licenseNm", info);
					sheet1.SelectCell(i+1,"licenseNm");
				}*/

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

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			if(sheet1.GetCellEditable(Row,Col) == true) {
				if(sheet1.ColSaveName(Col) == "licenseNm" && KeyCode == 46) {
					sheet1.SetCellValue(Row,"licenseCd","");
				}
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "licenseNm") {
				
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "licensePopup";

				<%--var win = openPopup("/PsnalLicenseMgr.do?cmd=viewHrmLicensePopup&authPg=${authPg}", "", "850","820");--%>
				licensePopup(Row);
			} else if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}

				sheet1.SelectCell(Row,"name");

				openPopup("${ctx}/Popup.do?cmd=employeePopup", "", "740","520", function (rv){
		        	sheet1.SetCellValue(Row, "sabun", rv["sabun"]);
		        	sheet1.SetCellValue(Row, "orgNm", rv["orgNm"]);
		        	sheet1.SetCellValue(Row, "name", rv["name"]);
		        	sheet1.SetCellValue(Row, "jikgubNm", rv["jikgubNm"]);
				});
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// 셀 값이 바뀔때 발생
	function sheet1_OnChange(Row, Col, Value) {
		try{
			if( sheet1.ColSaveName(Col) == "licSYmd" || sheet1.ColSaveName(Col) == "licEYmd"  ) {
				if(sheet1.GetCellValue(Row,"licSYmd") != "" && sheet1.GetCellValue(Row,"licEYmd") != "") {
					if(sheet1.GetCellValue(Row,"licSYmd") > sheet1.GetCellValue(Row,"licEYmd")) {
						alert("<msg:txt mid='110447' mdef='만료일은 취득일 이후 날짜로 입력하여 주십시오.'/>");
						sheet1.SetCellValue(Row,"licEYmd","");
					}
				}
			} else if( sheet1.ColSaveName(Col) == "allowSymd" || sheet1.ColSaveName(Col) == "allowEymd"  ) {
				if(sheet1.GetCellValue(Row,"allowSymd") != "" && sheet1.GetCellValue(Row,"allowEymd") != "") {
					if(sheet1.GetCellValue(Row,"allowSymd") > sheet1.GetCellValue(Row,"allowEymd")) {
						alert("<msg:txt mid='109878' mdef='수당지급 종료일은 시작일 이후 날짜로 입력하여 주십시오.'/>");
						sheet1.SetCellValue(Row,"allowEymd","");
					}
				}
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");

				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup";

					var authPgTemp="${authPg}";
					fileMgrPopup(Row, Col);
					//var rv = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp+"&uploadType=license", param, "740","620");
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
    // 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {
        var authPgTemp="${authPg}";
        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&uploadType=license&authPg=${authPg}'
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
	//팝업 콜백 함수.
	function getReturnValue(rv) {

        if(pGubun == "licensePopup"){
        	sheet1.SetCellValue(gPRow, "licenseCd", rv["code"]);
        	sheet1.SetCellValue(gPRow, "licenseNm", rv["codeNm"]);
        	sheet1.SetCellValue(gPRow, "licenseGubun", rv["note1"]);
        	sheet1.SetCellValue(gPRow, "licenseBigo", rv["note2"]);
        } else if(pGubun == "sheetAutocompleteEmp"){
            sheet1.SetCellValue(gPRow, "name",   	rv["name"] );
            sheet1.SetCellValue(gPRow, "sabun",   	rv["sabun"] );
            sheet1.SetCellValue(gPRow, "orgNm",   	rv["orgNm"] );
            sheet1.SetCellValue(gPRow, "manageNm",   rv["manageNm"] );
            sheet1.SetCellValue(gPRow, "jikgubNm",   rv["jikgubNm"] );
            sheet1.SetCellValue(gPRow, "statusNm",   rv["statusNm"] );
	    }        
	}


	// 자격증검색 팝입
	function licensePopup(Row, Col) {
		let layerModal = new window.top.document.LayerModal({
			id : 'hrmLicenseLayer'
			, url : '/PsnalLicense.do?cmd=viewHrmLicenseLayer&authPg=${authPg}'
			, parameters : {
				gubun : sheet1.GetCellValue(Row,"licenseGubun")
			}
			, width : 800
			, height : 520
			, title : '자격증 검색'
			, trigger :[
				{
					name : 'hrmLicenseTrigger'
					, callback : function(result){
						getReturnValue(result);
					}
				}
			]
		});
		layerModal.show();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th>사업장</th>
			<td>
				<select id="searchBizPlaceCd" name="searchBizPlaceCd"> </select>
			</td>
			<th>자격증명</th>
			<td>
				<select id="searchLicenseGubun" name="searchLicenseGubun"> </select>
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
					<li class="txt">개인별자격관리</li>
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
