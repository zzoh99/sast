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

		$("#srchPrizeYmdS").datepicker2({ startdate:"srchPrizeYmdE"});
		$("#srchPrizeYmdE").datepicker2({ enddate:"srchPrizeYmdS"});
		$("#srchPrizeYmdS").val(addDate("m", -12, "${curSysYyyyMMddHyphen}", "-"));
		$("#srchPrizeYmdE").val("${curSysYyyyMMddHyphen}");

		var initdata = {};
		//initdata.Cfg = {SearchMode:smServerPaging,Page:100,FrozenCol:8};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:5};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:1,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='seqV5' mdef='SEQ'/>",				Type:"Text",		Hidden:1,					Width:10,			Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:20 },
			{Header:"<sht:txt mid='prizeYmd' mdef='포상일자'/>",			Type:"Date",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"prizeYmd",		KeyField:1,	Format:"Ymd",			PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='prizeCd' mdef='포상명'/>",				Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"prizeCd",			KeyField:1,	Format:"",				PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",			Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:1,	Format:"",				PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",				Type:"Text",		Hidden:0,					Width:70,			Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",					Type:"Text",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",				Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",		KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",				Type:"Text",		Hidden:0,					Width:80,			Align:"Center",	ColMerge:0,	SaveName:"jikchakNm",		KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='memo2V1' mdef='포상사유'/>",			Type:"Text",		Hidden:0,					Width:150,			Align:"Center",	ColMerge:0,	SaveName:"memo2",			KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='prizeOfficeNm_V5157' mdef='주관처'/>",	Type:"Text",		Hidden:0,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"prizeOfficeNm",	KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='apizeMemo' mdef='포상\n세부내용'/>",		Type:"Text",		Hidden:0,					Width:150,			Align:"Left",	ColMerge:0,	SaveName:"apizeMemo",		KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='inOutCd' mdef='사내/외\n구분'/>"	,		Type:"Combo",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"inOutCd",			KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='committeeCd' mdef='인사위원회'/>",		Type:"Combo",		Hidden:0,					Width:120,			Align:"Center",	ColMerge:0,	SaveName:"committeeCd",		KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='prizeMon_V6471' mdef='포상금'/>",		Type:"Int",			Hidden:0,					Width:80,			Align:"Right",	ColMerge:0,	SaveName:"prizeMon",		KeyField:0,	Format:"NullInteger",	PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='openYn' mdef='공개여부'/>",				Type:"Combo",		Hidden:0,					Width:50,			Align:"Center",	ColMerge:0,	SaveName:"displayYn",		KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1, DefaultValue:"Y"  },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",				Type:"Text",		Hidden:0,					Width:150,			Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	Format:"",				PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",			Type:"Html",		Hidden:0,					Width:60,			Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",			Type:"Text",		Hidden:1,					Width:100,			Align:"Center",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	Format:"",				PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 }

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

		var prizeCd     = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20250");
		var committeeCd =     ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getCommitteeCdComboListRewardMgr",false).codeList; // 인사위원회

		var committeeCdSheet = convCode( committeeCd , ""); // 인사위원회
		var prizeCdSheet 	 = convCode( prizeCd , "");	//포상명(H20250)
		//var prizeReasonCd 	 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20730"), "");	//포상사유코드(H20730)
		var inOutCd         = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H20271"), "");  // 사내외구분

		sheet1.SetColProperty("prizeCd", 			{ComboText:"|"+prizeCdSheet[0], ComboCode:"|"+prizeCdSheet[1]} );	            // 포상명
		//sheet1.SetColProperty("prizeReasonCd", 	{ComboText:"|"+prizeReasonCd[0], ComboCode:"|"+prizeReasonCd[1]} );	// 포상사유코드
		sheet1.SetColProperty("committeeCd", 	{ComboText:"|"+committeeCdSheet[0], ComboCode:"|"+committeeCdSheet[1]} ); //  인사위원회
		sheet1.SetColProperty("inOutCd", 	{ComboText:"|"+inOutCd[0], ComboCode:"|"+inOutCd[1]} ); //  사내외구분
		sheet1.SetColProperty("displayYn", 		{ComboText:"|Y|N", ComboCode:"|Y|N"} ); //  공개여부


		prizeCd     = convCode(prizeCd, "<tit:txt mid='103895' mdef='전체'/>");
		committeeCd = convCode(committeeCd, "<tit:txt mid='103895' mdef='전체'/>");

		$("#srchPrizeCd").html(prizeCd[2]);
		$("#srchCommitteeCd").html(committeeCd[2]);

		$("#srchPrizeCd").change(function(){
			doAction1("Search");
		});

		$("#srchCommitteeCd").change(function(){
			doAction1("Search");
		});

		$("#searchSaNm").bind("keyup",function(event){
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
						sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
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

				var srchPrizeYmdS = $("#srchPrizeYmdS").val();
				var srchPrizeYmdE = $("#srchPrizeYmdE").val();

				if(srchPrizeYmdS == "" || srchPrizeYmdE == "") {
					alert("<msg:txt mid='110193' mdef='조회할 포상일자를 입력하세요.'/>");

					if(srchPrizeYmdS == "" ) {
						$("#srchPrizeYmdS").focus();
					}
					if(srchPrizeYmdE == ""){
						$("#srchPrizeYmdE").focus();
					}
					return;
				}

				srchPrizeYmdS = replaceAll(srchPrizeYmdS, "-","");
				srchPrizeYmdE = replaceAll(srchPrizeYmdE, "-","");

				var param = "&srchPrizeYmdS="  + srchPrizeYmdS
						  + "&srchPrizeYmdE="  + srchPrizeYmdE
						  + "&srchPrizeCd="    + $("#srchPrizeCd").val()
						  + "&srchCommitteeCd=" + $("#srchCommitteeCd").val()
						  + "&searchSaNm=" + $("#searchSaNm").val()
						  + "&authPg=${authPg}"
				  ;

			sheet1.DoSearch( "${ctx}/RewardMgr.do?cmd=getRewardMgrList&defaultRow=100", param );
            break;
        case "Save":        //저장
			if(!dupChk(sheet1,"seq|sabun|prizeYmd|prizeCd", false, true)){break;}
        	IBS_SaveName(document.srchFrm,sheet1);
        	sheet1.DoSave( "${ctx}/RewardMgr.do?cmd=saveRewardMgr", $("#srchFrm").serialize() );
            break;
        case "Insert":      //입력
            var Row = sheet1.DataInsert();

			sheet1.SetCellValue(Row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			sheet1.SelectCell(Row, "name");
            break;
        case "Copy":        //행복사

            var Row = sheet1.DataCopy();
			sheet1.SetCellValue(Row,"seq","");
			sheet1.SelectCell(Row, "prizeCd");

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
		case "Down2Template":
			var downCols = "sabun|prizeYmd|prizeCd|inOutCd|prizeOfficeNm|prizeMon|memo2|displayYn";
			var d = new Date();
			var fName = "포상내역관리(업로드)_" + d.getTime();
			var param  = {FileName:fName, DownCols:downCols,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9"};
			sheet1.Down2Excel(param);
			break;
    }
}




//	<!-- ====================== sheet1 ============================== -->

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {

			if (Msg != "") { alert(Msg); }

// 			for(var i = 0; i < sheet1.RowCount(); i++) {
// 				//파일 첨부 시작
// 				if("${authPg}" == 'A'){
// 					if(sheet1.GetCellValue(i+1,"fileSeq") == ''){
// 						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
// 						sheet1.SetCellValue(i+1, "sStatus", 'R');
// 					}else{
// 						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
// 						sheet1.SetCellValue(i+1, "sStatus", 'R');
// 					}
// 				}else{
// 					if(sheet1.GetCellValue(i+1,"fileSeq") != ''){
// 						sheet1.SetCellValue(i+1, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
// 						sheet1.SetCellValue(i+1, "sStatus", 'R');
// 					}
// 				}
// 				//파일 첨부 끝
// 			}

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

//	<!--셀에 마우스 클릭했을때 발생하는 이벤트-->
	function sheet1_OnPopupClick(Row, Col){
		try{

			if(sheet1.ColSaveName(Col) == "name") {
				if(!isPopup()) {return;}
				pGubun = "empPopup";
				gPRow = Row;
				var empPopup = openPopup("/Popup.do?cmd=employeePopup", "", "840","520");
			}

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {

			if(sheet1.ColSaveName(Col) == "btnFile" && Row >= sheet1.HeaderRows()){

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

//	<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
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
						<th><tit:txt mid='112480' mdef='포상기간'/></th>
						<td>
							<input id="srchPrizeYmdS" name="srchPrizeYmdS" type="text" class="date2"  /> ~
							<input id="srchPrizeYmdE" name="srchPrizeYmdE" type="text" class="date2"  />
						</td>
						<th><tit:txt mid='113552' mdef='포상코드'/></th>
						<td>
							<select id="srchPrizeCd" name="srchPrizeCd" class="${textCss}">

							</select>
						</td>
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
				<li class="txt"><tit:txt mid='112150' mdef='포상내역관리'/></li>
				<li class="btn">
					<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
					<btn:a href="javascript:doAction1('Down2Template')" css="btn outline-gray authA" mid='110702' mdef="양식다운로드"/>
					<btn:a href="javascript:doAction1('LoadExcel')" 	css="btn outline-gray authA" mid='110703' mdef="업로드"/>
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
