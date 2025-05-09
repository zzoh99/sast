<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>계약서</title>
<link rel="stylesheet" href="/common/${theme}/css/style.css" />
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22, FrozenCol:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'           mdef='No'/>",     	Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:Number("${sNoWdt}"),  Align:"Center", ColMerge:0,   SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5'    mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:1,  Width:Number("${sDelWdt}"), Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
			{Header:"<sht:txt mid='sStatus'       mdef='상태'/>",       Type:"${sSttTy}",   Hidden:1,  Width:Number("${sSttWdt}"), Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
			
			{Header:"<sht:txt mid='sdateV19'      mdef='기준일자'/>",		Type:"Date",    Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"stdDate",      KeyField:0,   CalcLogic:"",   Format:"Ymd",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='2017082800789' mdef='계약서 유형'/>",	Type:"Combo",   Hidden:0,  Width:100,  Align:"Center",  ColMerge:1,   SaveName:"contType",     KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"계약서",   											Type:"Image",   Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"detail",       KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1 },
			{Header:"<sht:txt mid='agreeSabun'    mdef='사번'/>",		Type:"Text",    Hidden:1,  Width:60,   Align:"Center",  ColMerge:1,   SaveName:"sabun",        KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='agreeYnV1'     mdef='동의'/>",		Type:"CheckBox",Hidden:0,  Width:60,   Align:"Center",  ColMerge:1,   SaveName:"agreeYn",      KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:10,  TrueValue:"Y", FalseValue:"N" },
			{Header:"동의일자",											Type:"Text",    Hidden:0,  Width:60,   Align:"Center",  ColMerge:1,   SaveName:"agreeDate", KeyField:0,   CalcLogic:"",   Format:"YmdHms",   PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='2017082800798' mdef='RD경로'/>",		Type:"Text",    Hidden:1,  Width:100,  Align:"Rigth",   ColMerge:0,   SaveName:"rdMrd",        KeyField:0,   CalcLogic:"",   Format:"",         PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			
			//hidden
			{Header:"서명사용여부", Hidden:1, SaveName:"signUseYn"},
			{Header:"fileSeq",  Hidden:1, SaveName:"fileSeq"},
			{Header:"rk",  Hidden:1, SaveName:"rk"}
		] ; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("detail", 1);

		// 급여구분
		var contTypeList 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","Z00001"), "<tit:txt mid='103895' mdef='전체'/>");
		sheet1.SetColProperty("contType", 			{ComboText:"|"+contTypeList[0], ComboCode:"|"+contTypeList[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		setEmpPage();
	});

	function setEmpPage() {
		$("#searchSabun").val($("#searchUserId").val());
		doAction("Search");
	}

	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search": 	 	
			//sheet1.DoSearch( "${ctx}/PerEmpContractSrch.do?cmd=getPerEmpContractSrchList", $("#sheetForm").serialize() );
			var sXml = sheet1.GetSearchData("${ctx}/PerEmpContractSrch.do?cmd=getPerEmpContractSrchList", $("#sheetForm").serialize() );
			sXml = replaceAll(sXml,"shtcolEdit", "Edit");
			sheet1.LoadSearchData(sXml );
			
			break;
		case "Save":
			IBS_SaveName(document.sheetForm,sheet1);
			sheet1.DoSave( "${ctx}/PerEmpContractSrch.do?cmd=savePerEmpContractSrch", $("#sheetForm").serialize(), -1, 0); break;
		case "Insert":
			sheet1.SelectCell(sheet1.DataInsert(0), ""); break;
		case "Copy":
			sheet1.SelectCell(sheet1.DataCopy(), 4);
			break;
		case "Clear":		sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param); break;
		case "LoadExcel":
			// 업로드
			var params = {};
			sheet1.LoadExcel(params);
			break;
		case "DownTemplate":
			// 양식다운로드
			sheet1.Down2Excel({ SheetDesign:1, Merge:1, DownRows:"0|1", DownCols:"5|6|7|8|9|10|11|12|13|14|15|16|17|18|19|20|21|22|23|24|25|26|27|28"});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); } sheetResize();

		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { alert(Msg); } 
			if( Code > -1 ) doAction("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	function sheet1_OnBeforeCheck(Row, Col) {
		try { 
			if(sheet1.GetCellValue(Row,"agreeYn") == "Y") {
				sheet1.SetAllowCheck(false); 
			}
		} catch (ex) { alert("OnBeforeCheck Event Error " + ex); }
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			if( sheet1.ColSaveName(Col) == "detail"  && Row >= sheet1.HeaderRows() ) {
				/*계약서 RD팝업*/
				showRd(Row) ;
				
			}else if( sheet1.ColSaveName(Col) == "agreeYn" && sheet1.GetCellValue(Row, "sStatus") == "U" ) {
				if( confirm("동의 하시겠습니까?\n(동의 후에는 본인이 취소할 수 없습니다.") ) {
					doAction("Save");
					return;
				}else{
					sheet1.SetCellValue(Row, "agreeYn", "N");
					sheet1.SetCellValue(Row, "sStatus", "R");
				}
				
			}
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}
	/**
	 * 출력 window open event
	 * 레포트 공통에 맞춘 개발 코드 템플릿
	 * by JSG
	 */
	function rdPopup(Row){
		if(!isPopup()) {return;}

  		var w 		= 840;
		var h 		= 1000;
		var url 	= "${ctx}/RdPopup.do";
		var args 	= new Array();


		gPRow = Row;
		pGubun = "rdPopup";
		if( sheet1.GetCellValue(Row, "signUseYn") == "Y" && sheet1.GetCellValue(Row, "agreeYn") != "Y" ){
			url 	= "${ctx}/RdSignPopup.do";
			pGubun = "rdSignPopup";
		}
		
		// args의 Y/N 구분자는 없으면 N과 같음

		args["rdTitle"] = sheet1.GetCellText(Row, "contType")+"-계약서" ;//rd Popup제목
		args["rdMrd"] = sheet1.GetCellValue(Row, "rdMrd");//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
// 		args["rdMrd"] = "cpn/personalPay/SalaryContract.mrd";//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
//		args["rdParam"] = "[${ssnEnterCd}] ["+$("#searchSabun").val()+"] ["+sheet1.GetCellValue(Row, "contType")+"] ["+sheet1.GetCellValue(Row, "stdDate")+"] [${baseURL}]" ; //rd파라매터
		args["rdParam"] = "[${ssnEnterCd}] [(('"+$("#searchSabun").val()+"','"+sheet1.GetCellValue(Row, "contType")+"','"+sheet1.GetCellValue(Row, "stdDate")+"'))] [${baseURL}]" ; //rd파라매터
		args["rdParamGubun"] = "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] = "Y" ;//툴바여부
		args["rdZoomRatio"] = "100" ;//확대축소비율

		args["rdSaveYn"] 	= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 	= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 	= "N" ;//기능컨트롤_엑셀
		args["rdWordYn"] 	= "N" ;//기능컨트롤_워드
		args["rdPptYn"] 	= "N" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 	= "N" ;//기능컨트롤_한글
		args["rdPdfYn"] 	= "Y" ;//기능컨트롤_PDF
		
		var rv = openPopup(url,args,w,h);//알디출력을 위한 팝업창

		/*
		if(rv!=null){
			//return code is empty
		}
		*/
	}

function showRd(Row){

	gPRow = Row;
	pGubun = "rdPopup";

	const data = {
		rk : sheet1.GetCellValue(Row, "rk"),
		mrdPath : sheet1.GetCellValue(Row, "rdMrd"),
		rp : {
			stdDate : sheet1.GetCellValue(Row, "stdDate")
		}
	};

	const opt = {
		//rdTitle :sheet1.GetCellText(Row, "contType")+"-계약서",//rd Popup제목
		rdToolBarYn :"Y", //툴바여부
		rdZoomRatio :"100",//확대축소비율
		rdSaveYn :"Y",//기능컨트롤_저장
		rdPrintYn :"Y",//기능컨트롤_인쇄
		rdExcelYn :"N",//기능컨트롤_엑셀
		rdWordYn :"N",//기능컨트롤_워드
		rdPptYn :"N",//기능컨트롤_파워포인트
		rdHwpYn :"N",//기능컨트롤_한글
		rdPdfYn :"Y"//기능컨트롤_PDF
	};

	if( sheet1.GetCellValue(Row, "signUseYn") == "Y" && sheet1.GetCellValue(Row, "agreeYn") != "Y" ){

		pGubun = "rdSignPopup";

		let layerModal = new window.top.document.LayerModal({
			id : 'perEmpContractSrchLayer' //식별자ID
			, url : '/PerEmpContractSrch.do?cmd=viewPerEmpContractSrchLayer' //팝업에 띄울 화면 jsp
			, parameters : {
				"data" : data,
				"opt" : opt
			}
			, width : 1000
			, height : 800
			, title : sheet1.GetCellText(Row, "contType")+"-계약서"
			, trigger :[ //콜백
				{
					name : 'perEmpContractSrchLayerTrigger'
					, callback : function(rv){
						sheet1.SetCellValue(Row, "agreeYn", "Y");
						sheet1.SetCellValue(Row, "fileSeq", rv.FileSeq);
						sheet1.SetCellValue(Row, "sStatus", "U");
						doAction('Save');
					}
				}
			]
		});
		layerModal.show();

	}else{
		window.top.showRdLayer('/PerEmpContractSrch.do?cmd=getEncryptRd', data, opt, sheet1.GetCellText(Row, "contType")+"-계약서", 1000, 800);
		// var signPadLayer = function(){
		// 	let layerModal2 = new window.top.document.LayerModal({
		// 		id : 'signPadLayer' //식별자ID
		// 		, url : '/PerEmpContractSrch.do?cmd=viewSignPadLayer' //팝업에 띄울 화면 jsp
		// 		, parameters : {
		// 		}
		// 		, width : 500
		// 		, height : 380
		// 		, title : "서명하기"
		// 		, trigger :[ //콜백
		// 			{
		// 				name : 'signPadLayerTrigger'
		// 				, callback : function(rv){
		// 					var modal = window.top.document.LayerModalUtility.getModal("perEmpContractSrchLayer");
		// 					modal.fire('perEmpContractSrchLayerTrigger', rv).hide();
		// 				}
		// 			}
		// 		]
		// 	});
		// 	layerModal2.show();
		// }
		// var item_Param = {
		// 	index : 20, //툴바 버튼 위치, 숫자를 지정하여 위치 변경 가능
		// 	id : 'sign' ,
		// 	//툴바 아이콘은 svg 형식의 이미지를 지원함.
		// 	svg : '<?xml version="1.0" encoding="utf-8"?><!-- Generator: Adobe Illustrator 28.2.0, SVG Export Plug-In . SVG Version: 6.00 Build 0)  --> <svg version="1.1" id="레이어_1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px"y="0px" viewBox="0 0 32 32" style="enable-background:new 0 0 32 32;" xml:space="preserve"> <style type="text/css">.st0{fill:none;}.st1{fill:#FF5C5C;} </style> <rect x="-2" y="-2" class="st0" width="36" height="36"/> <path class="st1" d="M26.8,13.2l1.4-1.4c1.1-1.1,1.1-3,0-4.1l-2.1-2.1c-1.1-1.1-3-1.1-4.1,0L20.6,7L26.8,13.2z M18.6,9.1L4.8,22.8V29H11l13.8-13.8L18.6,9.1z M5.8,17.7c-1.8-0.8-2.9-2-2.9-3.7c0-2.5,2.7-3.9,5.1-5c1.6-0.8,3.7-1.8,3.7-2.7c0-0.7-1.3-1.5-2.9-1.5C6.9,4.8,6.1,5.7,6,5.7C5.5,6.3,4.6,6.4,4,5.9c-0.6-0.5-0.7-1.4-0.2-2c0.2-0.2,1.7-2,4.9-2c2.8,0,5.8,1.6,5.8,4.4s-2.8,4.1-5.3,5.3c-1.4,0.7-3.4,1.7-3.4,2.4c0,0.6,0.9,1.1,2.3,1.5L5.8,17.7z M24.5,19.6c1.6,0.9,2.6,2.2,2.6,4c0,3.8-4.7,5.3-7.3,5.3c-0.8,0-1.5-0.7-1.5-1.5s0.7-1.5,1.5-1.5c1.5,0,4.4-0.9,4.4-2.4c0-0.8-0.7-1.4-1.9-1.9L24.5,19.6z"/> </svg>',
		// 	title : '서명하기',  //마우스 포인터를 아이콘에 위치 시켰을 때 발생하는 문구
		// 	separator : true,
		// 	handler :  signPadLayer
		// };
		//
		// window.top.showRdLayerAddToolbar('/PerEmpContractSrch.do?cmd=getEncryptRd', data, opt, item_Param);

	}

}


</script>
</head>
<body class="hidden">
<div class="wrapper">
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>

	<form id="sheetForm" name="sheetForm" >
		<input id="searchSabun"		name="searchSabun"		type="hidden">
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">계약서확인</li>
							<li class="btn">
								<btn:a href="javascript:doAction('Down2Excel')" css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
								<btn:a href="javascript:doAction('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
