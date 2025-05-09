<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<!-- <link rel="stylesheet" href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />   -->
<script type="text/javascript">
	$(function() {
		/* var research = convCodeIdx( ajaxCall("${ctx}/ResearchSta.do?cmd=getResearchStaResearchList","",false).DATA, "",-1);
		var question = convCodeIdx( ajaxCall("${ctx}/ResearchSta.do?cmd=getResearchStaQuestionList","",false).DATA, "선택하세요",-1); */
		var research = convCodeIdx( ajaxCall("${ctx}/ResearchResultLst.do?cmd=getResearchResultLstResearchList","",false).DATA, "선택하세요",-1);
		var question = convCodeIdx( ajaxCall("${ctx}/ResearchResultLst.do?cmd=getResearchResultLstQuestionList","",false).DATA, "선택하세요",-1);
		var initdata = {};
		initdata.Cfg = {FrozenCol:4, SearchMode:smLazyLoad,Page:22,MergeSheet:msAll}; 
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",      Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"<sht:txt mid='sDelete' mdef='삭제'/>",    Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='statusCd' mdef='상태'/>",    Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='questionNm' mdef='설문선택지'/>",	Type:"Text",		Hidden:0,	Width:300,		Align:"Left",	ColMerge:1,	SaveName:"questionNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='itemNm' mdef='선택지내용'/>",		Type:"Text",		Hidden:0,	Width:60,		Align:"Left",	ColMerge:0,	SaveName:"itemNm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='itemNm_V2' mdef='질문유형'/>",		Type:"Text",		Hidden:0,	Width:40,		Align:"Left",	ColMerge:0,	SaveName:"itemCdNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"<sht:txt mid='totalPerson' mdef='응답'/>",			Type:"Text",		Hidden:0,	Width:50,		Align:"Center",	ColMerge:0,	SaveName:"totalPerson",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='answer' mdef='답변'/>",			Type:"Text",		Hidden:0,	Width:50,		Align:"Center",	ColMerge:0,	SaveName:"answerCnt",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='score' mdef='점수'/>",			Type:"Text",		Hidden:0,	Width:50,		Align:"Center",	ColMerge:0,	SaveName:"sumPoint",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"응답률\r\n(%)",										Type:"Text",		Hidden:0,	Width:50,		Align:"Center",	ColMerge:0,	SaveName:"answerAverage",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"설문선택지\r\n평균",								Type:"Text",		Hidden:1,	Width:50,		Align:"Center",	ColMerge:0,	SaveName:"answerAverage",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		];IBS_InitSheet(sheet1, initdata);sheet1.SetCountPosition(4);
		$(window).smartresize(sheetResize); 
		sheetInit();
// 		doAction1("Search");
// 		$("#researchNm").bind("keyup",function(e){
// 			if(e.keyCode==13)doAction1("Search");
// 		});
/* 		$("#rSeq").html(research[2]);
		$("#qSeq").html(question[2]);
		$("#rSeq").change(function(){
			question = convCodeIdx( ajaxCall("${ctx}/ResearchSta.do?cmd=getResearchStaQuestionList",$("#sheetForm").serialize(),false).DATA, "선택하세요",-1);
			$("#qSeq").html(question[2]);
		}); */
		if($("#rSeq").val() != "") {
			$("#qSeq").html(question[2]);	
		}
		
	});
	
	//Sheet Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":		sheet1.DoSearch( "${ctx}/ResearchSta.do?cmd=getResearchStaList", $("#sheetForm").serialize() ); break;
		case "Down2Excel":  sheet1.Down2Excel(); break;
		}
	}
	
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize();} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	function sheet1_OnClick(Row, Col, Value){
		try{
			if(Row < 1) return;
			
			if(sheet1.ColSaveName(Col) == "detail1"){
				if(sheet1.GetCellImage(Row,"detail1")!= "")
					researchAppDetail1Popup();
			}else if(sheet1.ColSaveName(Col) == "detail2"){
				if(sheet1.GetCellImage(Row,"detail2")!= "")
					researchAppDetail2Popup();
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	//---------------------------------------------------------------------------------------------------------------
	// 팝업 콜백 함수.
	//---------------------------------------------------------------------------------------------------------------
	function getReturnValue(rv) {
		if (pGubun == "researchNmPopup") {  //교육상세 팝업
			$('#rSeq').val(rv.code);
			$('#searchResearchNm').val(rv.codeNm);
			
			if($('#searchResearchNm').val() == "") {
				$("#qSeq").html("<option value=''><tit:txt mid='112923' mdef='선택하세요.'/></option>");	
			} else{
				var question = convCodeIdx( ajaxCall("${ctx}/ResearchResultLst.do?cmd=getResearchResultLstQuestionList",$("#sheetForm").serialize(),false).DATA, "선택하세요",-1);
				$("#qSeq").html(question[2]);
			}
			
		}
	}

	// 검색 조건 초기화
	function fnSearchRefresh() {
		$('#searchResearchNm, #rSeq').val('');
		$("#qSeq").html("<option value=''><tit:txt mid='112923' mdef='선택하세요.'/></option>");
		return false;
	}

	//검색 - 설문명 검색 팝업
	function doSearchResearchNm() {
		if (!isPopup()) {
			return;
		}

		gPRow = "";
		pGubun = "researchNmPopup";

		// openPopup("/Popup.do?cmd=researchAppPopup&authPg=R", "", "750", "520");
		var w = 750;
		var h = 520;
		var url = "/Popup.do?cmd=researchAppLayer&authPg=R"

		var researchAppLayer = new window.top.document.LayerModal({
			id: 'researchAppLayer',
			url: url,
			parameters: '',
			width: w,
			height: h,
			title: '설문 리스트 조회',
			trigger: [
				{
					name: 'researchAppLayerTrigger',
					callback: function(rv) {
						getReturnValue(rv);
					}
				}
			]
		});
		researchAppLayer.show();
	}

	</script>
</head>
<body class="bodywrap">

<div class="wrapper">

	<form id="sheetForm" name="sheetForm">
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<th><tit:txt mid='113298' mdef='설문명'/></th>
					<td>	
						<input id="searchResearchNm" name ="searchResearchNm" type="text" class="text w200" readonly />
						<a href="javascript:doSearchResearchNm();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<a onclick="fnSearchRefresh();" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
						<input id="rSeq" name ="rSeq" type="hidden" />
					</td>
					<th><tit:txt mid='112576' mdef='설문선택지'/></th>
					<td>
						<select id="qSeq" name="qSeq">
							<option value=""><tit:txt mid='112923' mdef='선택하세요.'/></option>
						</select>
					</td>
					<td>
						<btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='search' mdef="조회"/>
					</td>
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
							<li class="txt"><tit:txt mid='114734' mdef='설문조사통계 '/></li>
								<li class="btn">
									<a href="javascript:doAction1('Down2Excel')" class="btn outline-gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
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
