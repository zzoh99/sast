<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:0,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='eduSeqV5' mdef='교육과정순번'/>",	Type:"Text",	Hidden:1,  Width:120,	Align:"Center",  ColMerge:0,   SaveName:"eduSeq",			KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='eduCourseNm_V1023' mdef='교육과정'/>",		Type:"Text",	Hidden:0,  Width:120,	Align:"Center",  ColMerge:0,   SaveName:"eduCourseNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
			{Header:"<sht:txt mid='eduEventSeq_V1116' mdef='교육회차seq'/>",	Type:"Text",	Hidden:1,  Width:50,	Align:"Center",  ColMerge:0,   SaveName:"eduEventSeq",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='eduEventNm_V1115' mdef='교육회차'/>",		Type:"Text",	Hidden:0,  Width:120,	Align:"Center",  ColMerge:0,   SaveName:"eduEventNm",		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='agreeSeq' mdef='순서'/>",			Type:"Int",		Hidden:0,  Width:50,	Align:"Center",  ColMerge:0,   SaveName:"seq",				KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='deductionType' mdef='항목분류'/>",		Type:"Combo",	Hidden:0,  Width:60,	Align:"Center",  ColMerge:0,   SaveName:"surveyItemType",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
			{Header:"<sht:txt mid='deductionType' mdef='항목분류'/>",		Type:"Combo",	Hidden:1,  Width:60,	Align:"Center",  ColMerge:0,   SaveName:"surveyItemType2",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:22 },
			{Header:"<sht:txt mid='surveyItemCd' mdef='설문항목코드'/>",	Type:"Text",	Hidden:1,  Width:100,	Align:"Left",    ColMerge:0,   SaveName:"surveyItemCd",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:22 },
			{Header:"<sht:txt mid='surveyItemNm' mdef='설문항목명'/>",		Type:"Popup",	Hidden:0,  Width:200,	Align:"Left",    ColMerge:0,   SaveName:"surveyItemNm",		KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='description' mdef='설명'/>",			Type:"Text",	Hidden:0,  Width:150,	Align:"Left",    ColMerge:0,   SaveName:"surveyItemDesc",	KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:4000 }
        ]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");

        var list1 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L10230"), "");

		sheet1.SetColProperty("surveyItemType", 			{ComboText:"|"+list1[0], ComboCode:"|"+list1[1]} );

		$("#searchSurveyItemNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});
		sheet1.SetDataLinkMouse("detail", 1);
		$(window).smartresize(sheetResize); sheetInit();
		//doAction1("Search");
	});

/**
 * Sheet 각종 처리
 */
function doAction1(sAction){
    switch(sAction){
        case "Search":      //조회

        	sheet1.DoSearch( "${ctx}/EduServeryEventMgr.do?cmd=getEduServeryEventMgrList", $("#srchFrm").serialize() );
            break;
        case "Save":        //저장
        	// 중복체크
			if (!dupChk(sheet1, "eduCourseNm|eduEventNm|surveyItemType|surveyItemCd", false, true)) {break;}
			IBS_SaveName(document.srchFrm,sheet1);
            sheet1.DoSave( "${ctx}/EduServeryEventMgr.do?cmd=saveEduServeryEventMgr", $("#srchFrm").serialize() );
            break;

        case "Insert":      //입력

            var Row = sheet1.DataInsert(0);
            sheet1.SetCellValue(Row, "startYmd","<%=DateUtil.getCurrentTime("yyyyMMdd")%>" );
            sheet1.SetCellValue(Row, "endYmd","99991231");
            break;

        case "Copy":        //행복사

            var Row = sheet1.DataCopy();
        	//sheet1.SetCellValue( Row, "eduEventSeq", "" );
            break;

        case "Clear":        //Clear

            sheet1.RemoveAll();
            break;

        case "Down2Excel":  //엑셀내려받기

            sheet1.Down2Excel();
            break;

        case "LoadExcel":   //엑셀업로드

			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
            break;

    }
}
</script>

<!-- 조회 후 에러 메시지 -->
<script type="text/javascript">
  function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
  try{
    if (ErrMsg != ""){
        alert(ErrMsg);
    }
    //setSheetSize(this);
  }catch(ex){alert("OnSearchEnd Event Error : " + ex);}
}
</script>

<script type="text/javascript">
  function sheet1_OnResize(lWidth, lHeight){
  try{
    //높이 또는 너비가 변경된 경우 각 컬럼의 너비를 새로 맞춘다.
    //setSheetSize(this);
  }catch(ex){alert("OnResize Event Error : " + ex);}
}
</script>

<!-- 저장 후 에러 메시지 -->
<script type="text/javascript">
  function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
  try{
    if (ErrMsg != ""){
        alert(ErrMsg) ;
        doAction1("Search") ;
    }
  }catch(ex){alert("OnSaveEnd Event Error : " + ex);}
}
</script>

<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
<script type="text/javascript">
  function sheet1_OnKeyDown(Row, Col, KeyCode, Shift){
  try{
    // Insert KEY
    if(Shift == 1 && KeyCode == 45){
        doAction1("Insert");
    }

    //Delete KEY
    if(Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row,"sStatus") == "I"){
        sheet1.SetCellValue(Row,"sStatus","D");
    }
  }catch(ex){alert("OnKeyDown Event Error : " + ex);}
}
</script>


<!--셀에 마우스 클릭했을때 발생하는 이벤트-->
<script type="text/javascript">
  function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol){
  try{
    selectSheet = sheet1;
  }catch(ex){alert("OnSelectCell Event Error : " + ex);}
}
</script>

<script type="text/javascript">
  function sheet1_OnClick(Row, Col, Value){
  try{

  }catch(ex){alert("OnClick Event Error : " + ex);}
}
</script>

<script type="text/javascript">
  function sheet1_OnPopupClick(Row, Col){
  try{
		if(sheet1.ColSaveName(Col) == "eduEventNm") {
			var rst = showDetailPopup1();
			if(rst != null){
			//팝업 더블클릭시 조회해온것 input 에 셋팅
				sheet1.SetCellValue(Row,	"eduCourseNm",	rst["eduCourseNm"]	);
				sheet1.SetCellValue(Row,	"eduEventSeq",	rst["eduEventSeq"]	);
				sheet1.SetCellValue(Row,	"eduEventNm",	rst["eduEventNm"]	);
			}
		}

		if(sheet1.ColSaveName(Col) == "surveyItemNm"){
			if(!isPopup()) {return;}

			var args	= new Array();
			args["eduSeq"]	= sheet1.GetCellValue( Row, "eduSeq" );

			var layer = new window.top.document.LayerModal({
				id : 'eduServeryItemMgrLayer'
				, url : "${ctx}/Popup.do?cmd=viewEduServeryItemMgrLayer&authPg=${authPg}"
				, parameters: args
				, width : 600
				, height : 700
				, title : "설문항목명"
				, trigger :[
					{
						name : 'eduServeryItemMgrLayerTrigger'
						, callback : function(rv){
							sheet1.SetCellValue(Row,	"surveyItemType",	rv["surveyItemType"]	);
							sheet1.SetCellValue(Row,	"surveyItemCd",		rv["surveyItemCd"]		);
							sheet1.SetCellValue(Row,	"surveyItemNm",		rv["surveyItemNm"]		);
						}
					}
				]
			});
			layer.show();
		}
  }catch(ex){alert("OnPopupClick Event Error : " + ex);}
}
</script>

<script type="text/javascript">
  function sheet1_OnValidation(Row, Col, Value){
  try{
  }catch(ex){alert("OnValidation Event Error : " + ex);}
}
</script>

<script type="text/javascript">

var showDetailPopup1 = function () {

	var url = "/EduServeryEventMgr.do?cmd=viewEduEventMgrPopup2";
	var args	= new Array(2);

	var rst = openPopup(url,args,700,700);

	return rst;
};

var showDetailPopup2 = function () {

	var args	= new Array(2);

	var layer = new window.top.document.LayerModal({
		id : 'eduServeryItemMgrLayer'
		, url : "${ctx}/Popup.do?cmd=viewEduServeryItemMgrLayer&authPg=${authPg}"
		, parameters: args
		, width : 600
		, height : 700
		, title : "설문항목명"
		, trigger :[
			{
				name : 'eduServeryItemMgrLayerTrigger'
				, callback : function(rv){

				}
			}
		]
	});
	layer.show();


};

var doSearchEduEvent = function() {
    var rst = showDetailPopup();
    if(rst != null){
      	 //팝업 더블클릭시 조회해온것 input 에 셋팅
       	$("#searchEduEventSeq").val ( rst["eduEventSeq"] );
       	$("#searchEduEventNm" ).val( rst["eduEventNm" ] );
    }
};

var showDetailPopup = function () {

	var url = "/EduAppDet.do?cmd=viewEduAppDetPopup";
	var args	= new Array(2);

	args["checkType"] = "N";

	var rst = openPopup(url,args,700,700);

	return rst;
};

// 대상자생성
var createServeryProcPopup = function (){
	var args	=	new Array();
	var rv		=	openPopup("/EduServeryEventMgr.do?cmd=viewEduServeryProcPopup", args, "740","520");
	doAction1("Search");
};
</script>

</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<th>회차명 </th>
						<td> 
							<input id="searchEduEventSeq" name ="searchEduEventSeq" type="hidden" class="text w100" />
							<input id="searchEduEventNm" name ="searchEduEventNm" type="text" class="text w100" />
							<a onclick="javascript:doSearchEduEvent();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							<a onclick="$('#searchEduEventNm').val('');return false;" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
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
							<li id="txt" class="txt">교육만족도항목관리_회차별</li>
							<li class="btn">
								<a href="javascript:createServeryProcPopup();" class="button">설문항목복사</a>
								<a href="javascript:doAction1('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Copy')" 	class="basic authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction1('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
