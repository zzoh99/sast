<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%-- ibSheet file 업로드용 --%>
<%@ include file="/WEB-INF/jsp/common/include/ibFileUpload.jsp"%>
<script type="text/javascript">
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
		// $("#searchFrom").datepicker2({startdate:"searchTo"});
		// $("#searchTo").datepicker2({enddate:"searchFrom"});

		$("#srchPunishYmdS").datepicker2({ startdate:"srchPunishYmdE"});
		$("#srchPunishYmdE").datepicker2({ enddate:"srchPunishYmdS"});
		$("#srchPunishYmdS").val(addDate("m", -12, "${curSysYyyyMMddHyphen}", "-"));
		$("#srchPunishYmdE").val("${curSysYyyyMMddHyphen}");

		var initdata = {};

		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",	Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='seqV5' mdef='SEQ'/>",           Type:"Text",      Hidden:1,  Width:10,   Align:"Center",  ColMerge:0,   SaveName:"seq",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",           Type:"Text",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"name",              KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",           Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"sabun",             KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",           Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"orgNm2",            KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",           Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikgubNm2",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>", 		   Type:"Text",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikchakNm2",        KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='punishYmd' mdef='징계일자'/>",       Type:"Date",      Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"punishYmd",         KeyField:1, Format:"Ymd",   PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='punishCd' mdef='징계명'/>",         Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"punishCd",          KeyField:1, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='sdate_V5555' mdef='징계\n시작일'/>",   Type:"Date",      Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"sdate",             KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, EndDateCol: "edate"},
			{Header:"<sht:txt mid='edate_V5556' mdef='징계\n종료일'/>",   Type:"Date",      Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"edate",             KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10, StartDateCol: "sdate" },
			{Header:"<sht:txt mid='punishTerm' mdef='징계기간(개월)'/>", Type:"Int",      Hidden:0,  Width:120,  Align:"Right",   ColMerge:0,   SaveName:"punishTerm",        KeyField:0, Format:"NullInteger",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='inOutCd' mdef='사내/외\n구분'/>",  Type:"Combo",     Hidden:0,  Width:60,  Align:"Center",  ColMerge:0,   SaveName:"inOutCd",           KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='suggestOrgCd' mdef='발의부서코드'/>",   Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"suggestOrgCd",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='suggestOrgNm' mdef='발의부서'/>",       Type:"Popup",     Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"suggestOrgNm",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='punishSuggestYmd' mdef='징계발의일'/>",     Type:"Date",      Hidden:0,  Width:100,   Align:"Center",  ColMerge:0,   SaveName:"punishSuggestYmd",  KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='punishOffice' mdef='발의기관'/>",       Type:"Text",      Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"punishOffice",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='openYn' mdef='공개여부'/>",       Type:"Combo",     Hidden:0,  Width:50,  Align:"Center",    ColMerge:0,   SaveName:"displayYn",          KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, DefaultValue:"Y"  },
			{Header:"<sht:txt mid='punishMemo' mdef='징계사유'/>", 	   Type:"Text",     Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"punishMemo",    KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='memo_V5564' mdef='징계세부내용'/>",   Type:"Text",      Hidden:0,  Width:150,  Align:"Left",    ColMerge:0,   SaveName:"memo",              KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='committeeCd' mdef='인사위원회'/>",     Type:"Combo",     Hidden:1,  Width:120,  Align:"Center",  ColMerge:0,   SaveName:"committeeCd",       KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='problemSymd' mdef='사고\n근무시작일'/>", Type:"Date",    Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"problemSymd",       KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='problemEymd' mdef='사고\n근무종료일'/>", Type:"Date",    Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"problemEymd",       KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='orgNm_V2937' mdef='사고시\n소속'/>",     Type:"Text",    Hidden:1,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",             KeyField:0, Format:"",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikchakNm_V2938' mdef='사고시\n직책'/>", 	 Type:"Text",    Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"jikchakNm",         KeyField:0, Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='punishDelYmd' mdef='징계사면일'/>",       Type:"Date",    Hidden:0,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"punishDelYmd",      KeyField:0, Format:"Ymd",   PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='deleteReason' mdef='사면근거'/>", 		 Type:"Text",    Hidden:0,  Width:120,  Align:"Left",    ColMerge:0,   SaveName:"deleteReason",      KeyField:0, Format:"",      PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",		 Type:"Html",	  Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,  SaveName:"btnFile",		        KeyField:0,	Format:"",	 	  PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",		 Type:"Text",	  Hidden:1,	Width:100,	 Align:"Center",	ColMerge:0,	 SaveName:"fileSeq",		        KeyField:0,	Format:"",	 	  PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		//var punishCd    =     ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getPunishCdComboList", false).codeList;
		var punishCd    = 	  codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20270");
		var committeeCd =     ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommitteeCdComboListPunishMgr",false).codeList; // 인사위원회

		var punishCdSheet    = convCode( punishCd , "");
		var committeeCdSheet = convCode( committeeCd , ""); // 인사위원회
		var inOutCd 	     = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20271"), "");	//사내외구분
		//var punishReasonCd 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20740"), "");	//징계세부내용

		sheet1.SetColProperty("punishCd", 			{ComboText:"|"+punishCdSheet[0], ComboCode:"|"+punishCdSheet[1]} );	            // 징계구분
		sheet1.SetColProperty("inOutCd", 			    {ComboText:"|"+inOutCd[0], ComboCode:"|"+inOutCd[1]} );	            // 사내외구분
		//sheet1.SetColProperty("punishReasonCd", 		{ComboText:"|"+punishReasonCd[0], ComboCode:"|"+punishReasonCd[1]} ); //  징계세부내용
		sheet1.SetColProperty("committeeCd", 		{ComboText:"|"+committeeCdSheet[0], ComboCode:"|"+committeeCdSheet[1]} ); //  인사위원회
		sheet1.SetColProperty("displayYn", 		{ComboText:"|Y|N", ComboCode:"|Y|N"} ); //  공개여부


		punishCd     = convCode(punishCd, "<tit:txt mid='103895' mdef='전체'/>");
		committeeCd = convCode(committeeCd, "<tit:txt mid='103895' mdef='전체'/>");

		$("#srchPunishCd").html(punishCd[2]);
		$("#srchCommitteeCd").html(committeeCd[2]);

		$("#srchPunishCd").change(function(){
			doAction1("Search");
		});

		$("#srchCommitteeCd").change(function(){
			doAction1("Search");
		});

		$("#searchSaNm, #srchPunishYmdS, #srchPunishYmdE").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
		
		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "name", rv["name"]);
						sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow, "orgNm2", rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm2",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm2", rv["jikchakNm"]);
					}
				}
			]
		});		
	});


	/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
    switch(sAction){
        case "Search":      //조회

			clearFileListArr('sheet1'); // 파일 목록 변수의 초기화

			var srchPunishYmdS = $("#srchPunishYmdS").val();
			var srchPunishYmdE = $("#srchPunishYmdE").val();

			//if(gfn_isEmpty(srchPunishYmdS)) {  srchPunishYmdS = "00000000";  }
			//if(gfn_isEmpty(srchPunishYmdE)) {  srchPunishYmdE = "99991231";  }

			if(srchPunishYmdS == "") {  srchPunishYmdS = "00000000";  }
			if(srchPunishYmdE == "") {  srchPunishYmdE = "99991231";  }

			srchPunishYmdS = replaceAll(srchPunishYmdS, "-","");
			srchPunishYmdE = replaceAll(srchPunishYmdE, "-","");

			var param = "&srchPunishYmdS="  + srchPunishYmdS
					  + "&srchPunishYmdE="  + srchPunishYmdE
					  + "&srchPunishCd="    + $("#srchPunishCd").val()
					  + "&srchCommitteeCd=" + $("#srchCommitteeCd").val()
					  + "&searchSaNm=" + $("#searchSaNm").val()
					  ;

        	sheet1.DoSearch( "${ctx}/PunishMgr.do?cmd=getPunishMgrList", param );
            break;
        case "Save":        //저장
			if(!dupChk(sheet1,"sabun|punishYmd|punishCd", true, true)){break;}
        	IBS_SaveName(document.srchFrm,sheet1);
        	sheet1.DoSave( "${ctx}/PunishMgr.do?cmd=savePunishMgr", $("#srchFrm").serialize() );
            break;
        case "Insert":      //입력
            var Row = sheet1.DataInsert(2);

			sheet1.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			sheet1.SetCellValue(Row, "suggestOrgCd", "${ssnOrgCd}");
			sheet1.SetCellValue(Row, "suggestOrgNm", "${ssnOrgNm}");
			sheet1.SetCellValue(Row, "punishCd", "M0");
			sheet1.SelectCell(Row, "name");
            break;
        case "Copy":        //행복사

            var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row,"seq","");
			sheet1.SelectCell(Row, "punishCd");

            break;
        case "Clear":        //Clear

            sheet1.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기

			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
            break;
        case "LoadExcel":   //엑셀업로드

			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
            break;
    }
}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {

			if (Msg != "") { alert(Msg); }
			for(var i = 0; i < sheet1.RowCount(); i++) {
				//파일 첨부 시작
				if("${authPg}" == 'A'){
					if(sheet1.GetCellValue(i+1,"fileSeq") == ''){
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}else{
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}
				}else{
					if(sheet1.GetCellValue(i+1,"fileSeq") != ''){
						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						sheet1.SetCellValue(i+1, "sStatus", 'R');
					}
				}
				//파일 첨부 끝
			}
			sheetResize();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	//저장 후 에러 메시지
	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}
			doAction1("Search");

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

	function sheet1_OnPopupClick(Row, Col){
		try{
			if(sheet1.ColSaveName(Col) == "suggestOrgNm") {
				if(!isPopup()) {return;}
				pGubun = "suggestOrgPopup";
				gPRow = Row;

				let layerModal = new window.top.document.LayerModal({
					id : 'orgLayer'
					, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
					, parameters : {}
					, width : 740
					, height : 520
					, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
					, trigger :[
						{
							name : 'orgTrigger'
							, callback : function(result){
								if(!result.length) return;
								sheet1.SetCellValue(gPRow, "suggestOrgCd",  result[0].orgCd );
								sheet1.SetCellValue(gPRow, "suggestOrgNm",  result[0].orgNm );
							}
						}
					]
				});
				layerModal.show();
			}

		} catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {

			if(sheet1.ColSaveName(Col) == "btnFile"	&& Row >= sheet1.HeaderRows()){
				var param = [];
				param["fileSeq"] = sheet1.GetCellValue(Row,"fileSeq");

				if(sheet1.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					gPRow = Row;
					pGubun = "fileMgrPopup";

					fileMgrPopup(Row, Col);
				}
			}

		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 파일첨부/다운로드 팝업
	function fileMgrPopup(Row, Col) {
		let layerModal = new window.top.document.LayerModal({
			id : 'fileMgrLayer'
			, url : '/fileuploadJFileUpload.do?cmd=viewIbFileMgrLayer&uploadType=justice&authPg=${authPg}'
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

	function sheet1_OnChange(Row, Col, Value){
		try{

		}catch(ex){alert("sheet1_OnChange Event Error : " + ex);}
	}

	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift){
		try{

		}catch(ex){alert("OnKeyDown Event Error : " + ex);}
	}

	function sheet1_OnValidation(Row, Col, Value){
		try{
		}catch(ex){alert("OnValidation Event Error : " + ex);}
	}
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th><tit:txt mid='113198' mdef='징계일자'/></th>
						<td>
							<input id="srchPunishYmdS" name="srchPunishYmdS" type="text" class="date2" /> ~
							<input id="srchPunishYmdE" name="srchPunishYmdE" type="text" class="date2" />
						</td>
						<th><tit:txt mid='113909' mdef='징계코드'/></th>
						<td>
							<select id="srchPunishCd" name="srchPunishCd" class="${textCss}">

							</select>
						</td>
						<%--
						<th><tit:txt mid='111894' mdef='인사위원회'/></th>
						<td>
							<select id="srchCommitteeCd" name="srchCommitteeCd" class="${textCss}">

							</select>
						</td> --%>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>
							<input id="searchSaNm" name="searchSaNm" type="text" class="text"/>
						</td>
						<td>
							<btn:a href="javascript:doAction1('Search');" css="btn dark" mid='110697' mdef="조회"/>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='113551' mdef='징계내역관리'/></li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
					<btn:a href="javascript:doAction1('Copy');" css="btn outline-gray authA" mid='110696' mdef="복사"/>
					<btn:a href="javascript:doAction1('Insert')" css="btn outline-gray authA" mid='110700' mdef="입력"/>
					<btn:a href="javascript:doAction1('Save')" 	css="btn filled authA" mid='110708' mdef="저장"/>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
