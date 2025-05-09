<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title></title>
<script type="text/javascript">
	var eduSeq = "";
	var eduEventSeq = "";
	var eduCourseNm = "";
	var eduEventNm = "";

	var authPg = "R";
	var gPRow = "";

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('eduServeryEventMgrLayer');
		var arg = modal.parameters;

		if( arg != undefined ) {
			eduSeq			=	arg["eduSeq"		];
			eduCourseNm		=	arg["eduCourseNm"	];
			eduEventSeq		=	arg["eduEventSeq"	];
			eduEventNm		=	arg["eduEventNm"	];
			authPg			=	arg["authPg"		];
		}

		$("#searchEduSeq").val(eduSeq);
		$("#searchEduEventSeq").val(eduEventSeq);
		$("#eduInfo").html(eduCourseNm +" - "+eduEventNm);

		createIBSheet3(document.getElementById('eduServeryEventMgrLayerSht-wrap'), "eduServeryEventMgrLayerSht", "100%", "100%", "${ssnLocaleCd}");
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",				Type:"Int",       Hidden:1,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"seq",             KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='surveyItemType' mdef='분류'/>",				Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"surveyItemType",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='bizCdV2' mdef='구분'/>",				Type:"Combo",     Hidden:1,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"surveyItemType2",  KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='surveyItemNm' mdef='설문항목명'/>",			Type:"Popup",     Hidden:0,  Width:600,  Align:"Left",    ColMerge:0,   SaveName:"surveyItemNm",    KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:1000 },
			
			{Header:"<sht:txt mid='eduSeqV5' mdef='교육과정순번'/>",			Type:"Text",      Hidden:1,  Width:100,  Align:"Center",  ColMerge:0,   SaveName:"eduSeq",         KeyField:0,   CalcLogic:"",   Format:"",             PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"교육이벤트순번",		Type:"Text",      Hidden:1,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"eduEventSeq",    KeyField:0,   CalcLogic:"",   Format:"",             PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"<sht:txt mid='surveyItemCd' mdef='설문항목코드'/>",			Type:"Text",      Hidden:1,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"surveyItemCd",   KeyField:0,   CalcLogic:"",   Format:"",             PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			
			{Header:"<sht:txt mid='eduCourseNmV3' mdef='eduCourseNm'/>",		Type:"Text",      Hidden:1,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"eduCourseNm",    KeyField:0,   CalcLogic:"",   Format:"",             PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='eduEventNmV3' mdef='eduEventNm'/>",		Type:"Text",      Hidden:1,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"eduEventNm",     KeyField:0,   CalcLogic:"",   Format:"",             PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='surveyItemDesc' mdef='surveyItemDesc'/>",	Type:"Text",      Hidden:1,  Width:90,   Align:"Center",  ColMerge:0,   SaveName:"surveyItemDesc", KeyField:0,   CalcLogic:"",   Format:"",             PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 }

		]; IBS_InitSheet(eduServeryEventMgrLayerSht, initdata);eduServeryEventMgrLayerSht.SetEditable("${editable}");eduServeryEventMgrLayerSht.SetVisible(true);eduServeryEventMgrLayerSht.SetCountPosition(4);eduServeryEventMgrLayerSht.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		
		var list1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10230"), "");
		var list2 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10231"), "");

		eduServeryEventMgrLayerSht.SetColProperty("surveyItemType", {ComboText:"|"+list1[0], ComboCode:"|"+list1[1]} );
		eduServeryEventMgrLayerSht.SetColProperty("surveyItemType2", 			{ComboText:list2[0], ComboCode:list2[1]} );
		
		$(window).smartresize(sheetResize); sheetInit();

		if ( authPg == "R" ){
			$("#spanBtn").hide();
			eduServeryEventMgrLayerSht.SetEditable(0);
		}
		
		doEduServeryEventMgrAction1("Search");

	});

	/*Sheet1 Action*/
	function doEduServeryEventMgrAction1(sAction) {
		switch (sAction) {
        case "Search":      //조회
        	eduServeryEventMgrLayerSht.DoSearch( "${ctx}/Popup.do?cmd=getEduServeryEventMgrList", $("#eduServeryEventMgrLayerFrm").serialize() );
            break;
        case "SearchAll":      //조회
			var sXml = eduServeryEventMgrLayerSht.GetSearchData("${ctx}/Popup.do?cmd=getEduServeryItemMgrList", $("#eduServeryEventMgrLayerFrm").serialize() );
			sXml = replaceAll(sXml,"tmp", "sStatus");
			var opt = { Append : 1 };
			eduServeryEventMgrLayerSht.LoadSearchData(sXml, opt);
        	
            break;
        case "Save":        //저장
        	if(eduServeryEventMgrLayerSht.FindStatusRow("I") != ""){
				if(!dupChk(eduServeryEventMgrLayerSht,"eduSeq|eduEventSeq|surveyItemCd", true, true)){break;}
			}

        	IBS_SaveName(document.eduServeryEventMgrLayerFrm,eduServeryEventMgrLayerSht);
            eduServeryEventMgrLayerSht.DoSave( "${ctx}/Popup.do?cmd=saveEduServeryEventMgr", $("#eduServeryEventMgrLayerFrm").serialize() );
            break;

        case "Insert":      //입력
            var Row = eduServeryEventMgrLayerSht.DataInsert(0);

        	eduServeryEventMgrLayerSht.SetCellValue(Row, "eduSeq", $("#searchEduSeq").val());
        	eduServeryEventMgrLayerSht.SetCellValue(Row, "eduEventSeq", $("#searchEduEventSeq").val());
        	eduServeryEventMgrLayerSht.SetCellValue(Row, "surveyItemType2", "50");
            break;

        case "Copy":        //행복사
            var Row = eduServeryEventMgrLayerSht.DataCopy();
            break;

        case "Clear":        //Clear
            eduServeryEventMgrLayerSht.RemoveAll();
            break;

        case "Down2Excel":  //엑셀내려받기
            eduServeryEventMgrLayerSht.Down2Excel();
            break;

        case "LoadExcel":   //엑셀업로드
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			eduServeryEventMgrLayerSht.LoadExcel(params);
            break;		}
    }

	// 	조회 후 에러 메시지
	function eduServeryEventMgrLayerSht_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if(Msg != "") alert(Msg);
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 에러 메시지
	function eduServeryEventMgrLayerSht_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != "") alert(ErrMsg) ;
			if ( Code != "-1" ) doEduServeryEventMgrAction1("Search") ;
		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

	// 팝업 클릭
	function eduServeryEventMgrLayerSht_OnPopupClick(Row, Col){
		try{
			if(!isPopup()) {return;}

			var args	= new Array();
			args["eduSeq"]	= eduServeryEventMgrLayerSht.GetCellValue( Row, "eduSeq" );
			args["surveyItemType"] = eduServeryEventMgrLayerSht.GetCellValue( Row, "surveyItemType" );

			var layer = new window.top.document.LayerModal({
				id : 'eduServeryItemMgrLayer'
				, url : "${ctx}/Popup.do?cmd=viewEduServeryItemMgrLayer&authPg=R"
				, parameters: args
				, width : 600
				, height : 700
				, title : "설문항목명"
				, trigger :[
					{
						name : 'eduServeryItemMgrLayerTrigger'
						, callback : function(rv){
							eduServeryEventMgrLayerSht.SetCellValue(Row,	"surveyItemType",	rv["surveyItemType"]	);
							eduServeryEventMgrLayerSht.SetCellValue(Row,	"surveyItemCd",		rv["surveyItemCd"]		);
							eduServeryEventMgrLayerSht.SetCellValue(Row,	"surveyItemNm",		rv["surveyItemNm"]		);
						}
					}
				]
			});
			layer.show();
		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	// 셀 클릭시 발생
	function eduServeryEventMgrLayerSht_OnChange(Row, Col, Value) {
		try{

			var colName = eduServeryEventMgrLayerSht.ColSaveName(Col);

			if( colName == "surveyItemType" ) {
				eduServeryEventMgrLayerSht.SetCellValue(Row, "surveyItemNm", "");
				eduServeryEventMgrLayerSht.SetCellValue(Row, "surveyItemCd", "");
			}
		}catch(ex){
			alert("OnChange Event Error : " + ex);
		}
	}
</script>


</head>
<body class="bodywrap">
<form id="eduServeryEventMgrLayerFrm" name="eduServeryEventMgrLayerFrm" >
	<input type="hidden" id="searchEduSeq" name="searchEduSeq" value=""/>
	<input type="hidden" id="searchEduEventSeq" name="searchEduEventSeq" value=""/>
</form>

	<div class="wrapper modal_layer">
        <div class="modal_body">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="eduInfo" class="txt"></li>
						<li id="spanBtn" class="btn">
							<a href="javascript:doEduServeryEventMgrAction1('Down2Excel')" 	class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
							<a href="javascript:doEduServeryEventMgrAction1('Copy')" 	class="btn outline-gray authA"><tit:txt mid='104335' mdef='복사'/></a>
							<a href="javascript:doEduServeryEventMgrAction1('Insert')" class="btn outline-gray authA"><tit:txt mid='104267' mdef='입력'/></a>
							<a href="javascript:doEduServeryEventMgrAction1('SearchAll')" class="btn soft authA">전체생성</a>
							<a href="javascript:doEduServeryEventMgrAction1('Save')" 	class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
						</li>
					</ul>
				</div>
			</div>
			<div id="eduServeryEventMgrLayerSht-wrap"></div>

		</div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('eduServeryEventMgrLayer');" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
	</div>
</body>
</html>
