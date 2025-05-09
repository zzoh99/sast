<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var confirmYn = true;
	var popupGubun = "";
	var gPRow = "";
	var pGubun = "";

	$(function() {
		// 트리레벨 정의
		$("#btnPlus").click(function() {
			sheet1.ShowTreeLevel(-1);
		});
		$("#btnStep1").click(function()	{
			sheet1.ShowTreeLevel(0, 1);
		});
		$("#btnStep2").click(function()	{
			sheet1.ShowTreeLevel(1,2);
		});
		$("#btnStep3").click(function()	{
			sheet1.ShowTreeLevel(-1);
		});
	});

	$(function() {
		var initdata = {};
		initdata.Cfg = {SearchMode:smGeneral,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo'        mdef='No'		 />", Type:"${sNoTy}" , Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete'    mdef='삭제'		 />", Type:"${sDelTy}", Hidden:Number("${sDelHdn}"),Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태'		 />", Type:"${sSttTy}", Hidden:Number("${sSttHdn}"),Width:30,	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='BLANK'      mdef='코드'		 />", Type:"Text"  , Hidden:0, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"code"       , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10    },
			{Header:"<sht:txt mid='BLANK'      mdef='상위기술코드'	 />", Type:"Text"  , Hidden:0, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"priorCode"  , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:10    },
			{Header:"<sht:txt mid='BLANK'      mdef='IT Skill'	 />", Type:"Text"  , Hidden:0, Width:170, Align:"Left"  , ColMerge:0, SaveName:"codeNm"     , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:100 , TreeCol:1, LevelSaveName:"sLevel" },
			{Header:"<sht:txt mid='BLANK'      mdef='기술분류'		 />", Type:"Text"  , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"codeType"   , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1     },
			{Header:"<sht:txt mid='BLANK'      mdef='기술분류2'	 	 />", Type:"Text"  , Hidden:1, Width:0  , Align:"Left"  , ColMerge:0, SaveName:"techBizType", KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:1     },
			{Header:"<sht:txt mid='BLANK'      mdef='TRM등록'		 />", Type:"Image" , Hidden:1, Width:40 , Align:"Center", ColMerge:0, SaveName:"trmCd"      , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:1, EditLen:1     },
			{Header:"<sht:txt mid='BLANK'      mdef='세부내역'		 />", Type:"Text"  , Hidden:0, Width:460, Align:"Left"  , ColMerge:0, SaveName:"codeDesc"   , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:1, InsertEdit:1, EditLen:4000  },
			{Header:"<sht:txt mid='BLANK'      mdef='TRM등록여부'	 />", Type:"Text"  , Hidden:1, Width:460, Align:"Left"  , ColMerge:0, SaveName:"trmYn"      , KeyField:0, CalcLogic:"", Format:""       , PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:1     },
			{Header:"<sht:txt mid='seq'        mdef='순서'		 />", Type:"Int"   , Hidden:0, Width:35 , Align:"Right" , ColMerge:0, SaveName:"seq"        , KeyField:0, CalcLogic:"", Format:"Integer", PointCount:0, UpdateEdit:1, InsertEdit:0, EditLen:3     }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_x.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetDataLinkMouse("trmCd" , 1);
		
		//TRM코드 라디오버튼
		var html_trmCd = "";
		var trmCdList = ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getTrmCdList",false).codeList;
		for (i = 0; i < trmCdList.length; i++) {
			html_trmCd += "<input type='radio' id='searchTechBizType"+trmCdList[i].code+"' name='searchTechBizType' value='"+trmCdList[i].code+"' onClick=setMode('"+trmCdList[i].code+"'); " + (i == 0 ? "checked='checked'" : "") + ">"
						 +"<label for='searchTechBizType"+trmCdList[i].code+"'>"+trmCdList[i].codeNm+"</label>";
		}
		$("#DIV_trmCd").html(html_trmCd);
		
		if(trmCdList.length > 0){
			$("#searchTechBizType1").attr("checked","checked");
		}
		
		$(window).smartresize(sheetResize); sheetInit();
		
		setMode("S");
	});

	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				 var sMode = $("#searchBizType").val();
				sheet1.SetCellText(0,"codeNm",$("label[for ='searchTechBizType"+sMode+"']").text());
				sheet1.SetCellText(0,"sStatus","상태");
				
				if (sMode == "S") {
					sheet1.DoSearch( "${ctx}/TRMManage.do?cmd=getSkillList"	, $("#srchFrm").serialize(),1 );
				}else{
					sheet1.DoSearch( "${ctx}/TRMManage.do?cmd=getKnowledgeList", $("#srchFrm").serialize(),1 );
					
				}
				break;
			case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,TreeLevel:0,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param);
				break;
			case "Insert":
				if(sheet1.GetRowLevel(sheet1.GetSelectRow()) > 0){
					return;
				}
				var Row = sheet1.DataInsert();
				if( sheet1.GetRowLevel(sheet1.GetSelectRow()) == 0 ) {
					sheet1.SetCellValue(Row,"priorCode","0");
				} else {
					sheet1.SetCellValue(Row,"priorCode",sheet1.GetCellValue(Row-1, "code"));
					sheet1.SetCellValue(Row,"code", getColMaxValue(sheet1, 3));
				}

				if($("#searchBizType").val() == "S"){
					sheet1.SetCellValue(Row,"codeType","S");
				}else if($("#searchBizType").val() == "T"){
					sheet1.SetCellValue(Row,"techBizType","T");
					sheet1.SetCellValue(Row,"codeType","K");
				}else if($("#searchBizType").val() == "B"){
					sheet1.SetCellValue(Row,"techBizType","B");
					sheet1.SetCellValue(Row,"codeType","K");
				}
				
				sheet1.SelectCell(Row, "codeNm");	
				
				sheet1.SetRowEditable(Row, 1) ;
				
				break;
			case "Save":
				if(!dupChk(sheet1,"code", true, true)){break;}

				isNotSaveMsg = false;
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/TRMManage.do?cmd=saveTcdpwTree", $("#srchFrm").serialize() );
				break;
			case "CtgInsert":
				sheet1.SetSelectRow(1);
				var Row = sheet1.DataInsert(0);
				sheet1.SetRowLevel(Row,0);
				sheet1.SetCellValue(Row,"codeType","C");
				sheet1.SetCellValue(Row,"priorCode","0");
				sheet1.SetCellValue(Row,"code", getColMaxValue(sheet1, 3));

				sheet1.SelectCell(Row, "codeNm");	
				
				if($("#searchBizType").val() == "T"){
					sheet1.SetCellValue(Row,"techBizType","T");
				}else if($("#searchBizType").val() == "B"){
					sheet1.SetCellValue(Row,"techBizType","B");
				}else{
				}
				
				break;
		}
	}

	function setMode(str) {
		$("#searchBizType").val(str);
		doAction1("Search");
	}


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

	function sheet1_OnClick(Row, Col, Value) {
		try{
			if(sheet1.ColSaveName(Col)=="trmCd" && sheet1.GetCellValue(Row, "priorCode") != "0" && sheet1.GetCellValue(Row,"sStatus") != "I") {
				trmRegPopup(Row);
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function trmRegPopup(Row) {
		if (!isPopup()) {
			return;
		}

		var w = 1000;
		var h = 800;
		var url = "${ctx}/TRMManage.do?cmd=viewTRMRegPopup&authPg=${authPg}";
		var args = new Array();

		args["searchTrmType" ] = $("#searchBizType").val();
		args["searchCode"	] = sheet1.GetCellValue(Row, "code");
		args["searchCategory"] = sheet1.GetCellValue(Row, "priorCode");
		args["searchCodeNm"  ] = sheet1.GetCellValue(Row, "codeNm");


		gPRow = Row;
		pGubun = "trmRegPopup";

		openPopup(url, args, w, h);
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "trmRegPopup"){
			//
		}
	}
	
	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if( !isNotSaveMsg  ){
				if (Msg != "") {
					alert(Msg);
				}
				doAction1("Search");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
	
	function sheet1_OnBeforeCheck(Row, Col) {
		
		if(sheet1.ColSaveName(Col)=="sDelete" && sheet1.GetCellValue(Row,"trmYn") == "Y"){
			alert("등록된 TRM정보가 있습니다. 삭제 후 진행해주세요");
			sheet1.SetAllowCheck(false);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >

		<input type="hidden" id="searchBizType" name="searchBizType" value="" />

		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<div id="DIV_trmCd">
							</div>
<!--							 <input type="radio" id="searchTechBizTypeS" name="searchTechBizType" value="S" onClick="setMode('S');"  checked  ><label for="searchTechBizTypeS">IT Skill</label> -->
<!--							 <input type="radio" id="searchTechBizTypeT" name="searchTechBizType" value="T" onClick="setMode('T');" ><label for="searchTechBizTypeT">IT Knowledge</label> -->
<!--							 <input type="radio" id="searchTechBizTypeB" name="searchTechBizType" value="B" onClick="setMode('B');" ><label for="searchTechBizTypeB">Business Knowledge</label> -->
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">TRM&nbsp;
					<div class="util">
						<ul>
							<li	id="btnPlus"></li>
							<li	id="btnStep1"></li>
							<li	id="btnStep2"></li>
							<li	id="btnStep3"></li>
						</ul>
					</div>
				</li>
				<li class="btn">
					<a href="javascript:doAction1('CtgInsert')" class="button authA"><tit:txt mid='104267' mdef='카테고리 추가'/></a>
					<a href="javascript:doAction1('Insert')" class="basic authA"><tit:txt mid='104267' mdef='입력'/></a>
					<a href="javascript:doAction1('Save')" 	class="basic authA"><tit:txt mid='104476' mdef='저장'/></a>
					<a href="javascript:doAction1('Down2Excel')" 	class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
</div>
</body>
</html>
