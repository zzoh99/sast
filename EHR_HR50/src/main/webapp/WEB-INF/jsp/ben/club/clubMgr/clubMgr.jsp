<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>동호회관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";
	var pGubunSabun = "";

	$(function() {
		
		$("#searchClubNm, #searchYmd").on("keyup", function(event) {
			if( event.keyCode == 13) {
				doAction2("Search");
			}
		});
		
		$("#searchTempYn").on("change", function(e) {
			doAction2("Search");
		});
		
		$("#searchDateYear").keyup(function() {
			makeNumber(this,'A');
			if( event.keyCode == 13) {
				doAction2("Search");
			}
		});
		
		$("#searchYmd").datepicker2({
			onReturn:function(){
				doAction2("Search");
			}
		});

		//Sheet 초기화
		init_sheet1(); init_sheet2();
		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
		
		doAction2("Search");
		
	      // 이름 입력 시 자동완성
        $(sheet2).sheetAutocomplete({
            Columns: [
                {
                    ColSaveName  : "sabunAName",
                    CallbackFunc : function(returnValue){
                        var rv = $.parseJSON('{' + returnValue+ '}');
                        sheet2.SetCellValue(gPRow, 'sabunAName', rv["name"] );
                        sheet2.SetCellValue(gPRow, 'sabunA',     rv["sabun"] );
                    }
                },
				{
					ColSaveName  : "sabunBName",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet2.SetCellValue(gPRow, 'sabunBName', rv["name"] );
						sheet2.SetCellValue(gPRow, 'sabunB',     rv["sabun"] );
					}
				},
                {
                    ColSaveName  : "sabunCName",
                    CallbackFunc : function(returnValue){
                        var rv = $.parseJSON('{' + returnValue+ '}');
                        sheet2.SetCellValue(gPRow, 'sabunCName', rv["name"] );
                        sheet2.SetCellValue(gPRow, 'sabunC',     rv["sabun"] );
                    }
                }
            ]
        }); 

	});

	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [

			{Header:"No|No",					Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo",		Sort:0 },
			{Header:"상태|상태",				Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"구분|구분", 				Type:"Text", 	 Hidden:0, Width:100,  Align:"Center", SaveName:"codeNm", 	KeyField:1, Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"시작월일|시작월일", 		Type:"Text", 	 Hidden:0, Width:100,  Align:"Center", SaveName:"note1", 	KeyField:1, Format:"Md", 	UpdateEdit:1, InsertEdit:0 },
			{Header:"종료월일|종료월일", 		Type:"Text", 	 Hidden:0, Width:100,  Align:"Center", SaveName:"note2", 	KeyField:1, Format:"Md", 	UpdateEdit:1, InsertEdit:0 },
			{Header:"비고|비고", 				Type:"Text",   	 Hidden:0, Width:100,  Align:"Left",   SaveName:"note3",	KeyField:0,	Format:"", 		UpdateEdit:1, InsertEdit:0 },

			//Hidden
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"code"},


		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(0);

		sheet1.SetDataAlternateBackColor(sheet1.GetDataBackColor()); //홀짝 배경색 같게

	}

	function init_sheet2(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [

			{Header:"No|No",			Type:"${sNoTy}",  Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	SaveName:"sNo",		Sort:0 },
			{Header:"삭제|삭제",		Type:"${sDelTy}", Hidden:0,						Width:"${sDelWdt}",	Align:"Center",	SaveName:"sDelete",	Sort:0 },
			{Header:"상태|상태",		Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"상세|상세",		Type:"Image",  	  Hidden:0, Width:45,  	Align:"Center", ColMerge:0,  SaveName:"detail",     	Edit:0, Cursor:"Pointer"  },

			{Header:"동호회명|동호회명", 			Type:"Text",  Hidden:0, Width:140,	Align:"Left", 	SaveName:"clubNm", 	KeyField:1, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"임시등록여부|임시등록여부", 	Type:"Combo",  Hidden:0, Width:75,	Align:"Center", SaveName:"tempYn", 	KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"시작일자|시작일자", 			Type:"Date",  Hidden:0, Width:85,	Align:"Center", SaveName:"sdate", 	KeyField:1, Format:"Ymd", 	UpdateEdit:1, InsertEdit:1 , EndDateCol:"edate"},
			{Header:"종료일자|종료일자", 			Type:"Date",  Hidden:0, Width:85,	Align:"Center", SaveName:"edate", 	KeyField:1, Format:"Ymd", 	UpdateEdit:1, InsertEdit:1 , StartDateCol:"sdate"},
			
			{Header:"동호회비|동호회비", 			Type:"Int",   Hidden:0, Width:70, 	Align:"Center", SaveName:"clubFee", 		KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"회원수|회원수", 				Type:"Int",   Hidden:0, Width:50,  	Align:"Center", SaveName:"clubMemCnt", 		KeyField:0, Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"기준년도|기준년도\n가입자수", 	Type:"Int",   Hidden:0, Width:50, 	Align:"Center",	SaveName:"clubMemInCnt", 	KeyField:0, Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"기준년도|기준년도\n탈퇴자수", 	Type:"Int",   Hidden:0, Width:50, 	Align:"Center",	SaveName:"clubMemOutCnt", 	KeyField:0, Format:"", 		UpdateEdit:0, InsertEdit:0 },
			{Header:"회장|회장", 					Type:"Text", Hidden:0, Width:70, 	Align:"Center", SaveName:"sabunAName", 		KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"회장사번|회장사번", 			Type:"Text",  Hidden:1, Width:0, 	Align:"Center", SaveName:"sabunA", 			KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"고문|고문", 					Type:"Popup", Hidden:1, Width:70, 	Align:"Center", SaveName:"sabunBName", 		KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"고문사번|고문사번", 			Type:"Text",  Hidden:1, Width:0, 	Align:"Center", SaveName:"sabunB", 			KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"총무|총무", 					Type:"Text",  Hidden:0, Width:70, 	Align:"Center",	SaveName:"sabunCName", 		KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"총무사번|총무사번", 			Type:"Text",  Hidden:1, Width:0, 	Align:"Center", SaveName:"sabunC", 			KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"예금주|예금주", 				Type:"Text",  Hidden:0, Width:70, 	Align:"Center", SaveName:"accHolder", 		KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"은행명|은행명", 				Type:"Combo", Hidden:0, Width:100, 	Align:"Center", SaveName:"bankCd", 			KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			{Header:"계좌번호|계좌번호", 			Type:"Text",  Hidden:0, Width:120, 	Align:"Left", 	SaveName:"accNo", 			KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			
			{Header:"복리후생마감 급여항목|복리후생마감 급여항목",Type:"Popup",		Hidden:0, 	Width:150,  Align:"Center",	ColMerge:0,	SaveName:"elementNm",		KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
  			{Header:"복리후생마감 급여항목|복리후생마감 급여항목",Type:"Text",		Hidden:1, 	Width:150,  Align:"Center",	ColMerge:0,	SaveName:"elementCd",		KeyField:0,	Format:"", 			UpdateEdit:1,   InsertEdit:1 },
  			
  			{Header:"비고|비고", 					Type:"Text",  Hidden:0, Width:150, 	Align:"Left", 	SaveName:"note", 			KeyField:0, Format:"", 		UpdateEdit:1, InsertEdit:1 },
			
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"clubSeq"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"applSeq"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"sabun"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"applYmd"},
			{Header:"Hidden", Type:"Text", Hidden:1, SaveName:"applInSabun"},

		]; IBS_InitSheet(sheet2, initdata1);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");sheet2.SetDataLinkMouse("detail", 1);
		sheet2.SetDataAlternateBackColor(sheet2.GetDataBackColor()); //홀짝 배경색 같게

		sheet2.SetColProperty("tempYn", {ComboText:"Y|N", ComboCode:"Y|N"});
	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var sXml = sheet1.GetSearchData("${ctx}/ClubMgr.do?cmd=getClubMgrPerList", $("#sheet1Form").serialize() );
				sheet1.LoadSearchData(sXml );
				break;
			case "Save":
				IBS_SaveName(document.sheet1Form,sheet1);
				sheet1.DoSave( "${ctx}/ClubMgr.do?cmd=saveClubMgrPer", $("#sheet1Form").serialize());
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
		}
	}


	function chkInVal(sheet, sdate, edate) {
		// 시작일자와 종료일자 체크
		for (var i=sheet.HeaderRows(); i<=sheet.LastRow(); i++) {
			if (sheet.GetCellValue(i, "sStatus") == "I" || sheet.GetCellValue(i, "sStatus") == "U") {
				if (sheet.GetCellValue(i, edate) != null && sheet.GetCellValue(i, edate) != "") {
					var sdate = sheet.GetCellValue(i, sdate);
					var edate = sheet.GetCellValue(i, edate);
					if (parseInt(sdate) > parseInt(edate)) {
						alert("<msg:txt mid='110396' mdef='시작일자가 종료일자보다 큽니다.'/>");
						sheet.SelectCell(i, edate);
						return false;
					}
				}
			}
		}
		return true;
	}


	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
			case "Search":
				getCommonCodeList();
				var sXml = sheet2.GetSearchData("${ctx}/ClubMgr.do?cmd=getClubMgrList", $("#sheet1Form").serialize() );
				sheet2.LoadSearchData(sXml );
				break;
			case "Save":
				if(!chkInVal(sheet2, "sdate", "edate")){break;}
				IBS_SaveName(document.sheet1Form, sheet2);
				sheet2.DoSave( "${ctx}/ClubMgr.do?cmd=saveClubMgr", $("#sheet1Form").serialize());
				break;
			case "Insert":
				var row = sheet2.DataInsert(0);
				sheet2.SetCellValue(row, "tempYn",	"Y" );
				break;
			case "Copy":
				var row = sheet2.DataCopy();
				sheet2.SetCellValue(row, "tempYn",	"Y" );
				sheet2.SetCellValue(row, "clubSeq", "");
				sheet2.SetCellValue(row, "applSeq", "");
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet2);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet2.Down2Excel(param);
				break;
		}
	}

	function getCommonCodeList() {
		//은행코드
		var cdList = convCode(codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H30001", $("#searchYmd").val()), "");
		sheet2.SetColProperty("bankCd", {ComboText:cdList[0], ComboCode:cdList[1]} ); //동호회명
	}

	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
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
			if( Code > -1 ) doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {

		try{

			var sSaveName = sheet1.ColSaveName(Col);

			//대출금 상환납입월일 변경
			if(sSaveName == "note2"){

				//적용기간 종료일이 적용기간 시작일보다 작으면 리턴 - 그러면 안됨
				if( sheet1.GetCellValue( Row, "note1") > Value ){
					alert('<msg:txt mid="110396" mdef="시작일자가 종료일자보다 큽니다." />');
					sheet1.SetCellValue(Row, Col, OldValue, 0);
					return;
				}

			}

		}catch(ex){alert("OnChange Event Error : " + ex);}

	}
	
	//---------------------------------------------------------------------------------------------------------------
	// sheet2 Event
	//---------------------------------------------------------------------------------------------------------------
	
	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction2("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	// 셀 클릭시 발생
	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet2.HeaderRows() ) return;

			if( sheet2.ColSaveName(Col) == "detail" && Value ) {
				// 상세보기 팝업
				showClubMgrPop(Row);

			}
		}
		catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	
	// 셀 팝업 클릭 시
	function sheet2_OnPopupClick(Row, Col) {
		try {

			var rv = null;

			if (sheet2.ColSaveName(Col) == "sabunAName" || sheet2.ColSaveName(Col) == "sabunBName" || sheet2.ColSaveName(Col) == "sabunCName") {  //대상자 선택

				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "employeePopup";
				pGubunSabun = sheet2.ColSaveName(Col);
				var args    = new Array();
				
				openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");
			
			}else if(sheet2.ColSaveName(Col) == "elementNm") { //급여항목

				if(!isPopup()) {return;}

				var args 	= new Array();
				gPRow = Row;
				pGubun = "payElementPopup";
				//var rv = openPopup("/PayElementPopup.do?cmd=payElementPopup&authPg=${authPg}", args, "1020","520");
			    let layerModal = new window.top.document.LayerModal({
			          id : 'payElementLayer'
			        , url : '/PayElementPopup.do?cmd=viewPayElementLayer&authPg=${authPg}'
			        , parameters : args
			        , width : 1020
			        , height : 520
			        , title : '수당,공제 항목'
			        , trigger :[
			            {
			                  name : 'payTrigger'
			                , callback : function(result){
			        			sheet2.SetCellValue(gPRow, "elementCd", result.resultElementCd, 0);
			        			sheet2.SetCellValue(gPRow, "elementNm", result.resultElementNm);
			                }
			            }
			        ]
			    });
			    layerModal.show();
			}

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function sheet2_OnChange(Row, Col, Value, OldValue, RaiseFlag) {

		try{

			var sSaveName = sheet2.ColSaveName(Col);

			// 회장, 총무, 예금주의 성명을 삭제한 경우 사번정보도 삭제되도록함
			if(sSaveName == "sabunAName" || sSaveName == "sabunBName" || sSaveName == "sabunCName"){
				if(Value == "") {
					sheet2.SetCellValue(Row, sSaveName.substring(0, 6), '');
				}
			}

		}catch(ex){alert("OnChange Event Error : " + ex);}

	}
	//---------------------------------------------------------------------------------------------------------------
	// 팝업 콜백 함수.
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(rv) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "employeePopup"){
			sheet2.SetCellValue(gPRow, pGubunSabun,	rv["name"] );
			sheet2.SetCellValue(gPRow, pGubunSabun.substr(0,6),		rv["sabun"] );

		}else if (pGubun == "payElementPopup") { // 급여항목 팝업
			sheet2.SetCellValue(gPRow, "elementCd", rv["elementCd"], 0);
			sheet2.SetCellValue(gPRow, "elementNm", rv["elementNm"]);
		}
		

	}
	
	//동호회 재등록 상세 팝업
	function showClubMgrPop(Row) {
		
		var args = new Array(5);
		
		args["applStatusCd"] = sheet1.GetCellValue(Row, "applStatusCd");
		var url = '/ApprovalMgrResult.do?cmd=viewApprovalMgrResultLayer';
		const p = {
				searchApplCd: '711',
				searchApplSeq: sheet2.GetCellValue(Row,"applSeq"),
				adminYn: 'N',
				authPg: 'R',
				searchSabun: sheet2.GetCellValue(Row,"applInSabun"),
				searchApplSabun: sheet2.GetCellValue(Row, "sabun"),
				searchApplYmd: sheet2.GetCellValue(Row,"applYmd")
			};
		var approvalMgrLayer = new window.top.document.LayerModal({
			id: 'approvalMgrLayer',
			url: url,
			parameters: p,
			width: 800,
			height: 815,
			title: '동호회(재)등록신청',
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
		//window.top.openLayer(url, p, 800, 815, 'initResultLayer', getReturnValue);
	}
</script>
<style type="text/css">
table.table01 th { border:0;padding-right:10px;}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
<form name="sheet1Form" id="sheet1Form" method="post">
	<div class="sheet_search outer">
		<table>
		<tr>
			<th>기준일자</th>
			<td>
				<input type="text" id="searchYmd" name="searchYmd" class="date2 w80" value=""/>
			</td>
			<th>동호회명</th>
			<td>
				<input type="text" id="searchClubNm" name="searchClubNm" class="text w80" value=""/>
			</td>
			<th>등록구분</th>
			<td>
				<select id="searchTempYn" name="searchTempYn">
					<option value="">전체</option>
					<option value="N">정상등록</option>
					<option value="Y">임시등록</option>
				</select>
			<td>
				<a href="javascript:doAction2('Search')" class="btn dark">조회</a>
			</td>
		</tr>
		</table>
	</div>

	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt">동호회 기간 관리</li>
			<li class="btn">
				<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
				<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
			</li>
		</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "200px"); </script>
	</div>

	<div class="sheet_title inner">
	<ul>
		<li class="txt">동호회 관리</li>
		<li class="btn">
		<span>기준년도 </span><input id="searchDateYear" name="searchDateYear" maxlength="4"  class="text w70 center" value="${curSysYear}">
			<a href="javascript:doAction2('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
			<a href="javascript:doAction2('Copy')" 			class="btn outline-gray authA">복사</a>
			<a href="javascript:doAction2('Insert')" 		class="btn outline-gray authA">입력</a>
			<a href="javascript:doAction2('Save');" 		class="btn filled authA">저장</a>
		</li>
	</ul>
	</div>
	<script type="text/javascript"> createIBSheet("sheet2", "100%", "100%"); </script>
</form>
</div>
</body>
</html>
