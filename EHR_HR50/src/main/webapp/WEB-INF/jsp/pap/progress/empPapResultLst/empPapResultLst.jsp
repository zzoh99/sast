<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">

var gPRow = "";
var pGubun = "";

	$(function() {

		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
		{Header:"No|No"			,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
		//{Header:"삭제"			,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
		{Header:"기준년도|평가년도",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appraisalYy",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
		{Header:"기준년도|성명",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"name",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
		{Header:"기준년도|사번",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"sabun",         KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
		{Header:"기준년도|호칭",               	Type:"Text", Hidden:Number("${aliasHdn}"), Width:80 , Align:"Center", ColMarge:1,  SaveName:"alias",         KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"기준년도|소속",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"orgNm",           KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"기준년도|직급",               	Type:"Text", Hidden:Number("${jgHdn}"), Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikgubNm",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"기준년도|직위",               	Type:"Text", Hidden:Number("${jwHdn}"), Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikweeNm",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"기준년도|직책",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikchakNm",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"기준년도|입사일",              Type:"Date", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"gempYmd",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},

 		{Header:"년도2|평가ID",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appraisalCd2",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|평가년도",               Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appraisalYy2",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|소속코드",            	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appOrgCd2",           KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|소속",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appOrgNm2",           KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|직급코드",              	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikgubCd2",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|직급",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikgubNm2",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|직위코드",              	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikweeCd2",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|직위",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikweeNm2",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|직책",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikchakNm2",     KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|KPI",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"finalMboClassNm2",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|역량",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"finalCompClassNm2",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|종합",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"finalClassNm2",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도2|상세보기",				Type:"Image",Hidden:0, Width:50 , Align:"Center", ColMerge:1,  SaveName:"detail2",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },

 		{Header:"년도1|평가ID",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appraisalCd1",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|평가년도",               Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appraisalYy1",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|소속코드",            	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appOrgCd1",           KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|소속",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appOrgNm1",           KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|직급코드",              	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikgubCd1",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|직급",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikgubNm1",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|직위코드",              	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikweeCd1",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|직위",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikweeNm1",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|직책",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikchakNm1",     KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|KPI",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"finalMboClassNm1",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|역량",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"finalCompClassNm1",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|종합",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"finalClassNm1",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도1|상세보기",				Type:"Image",Hidden:0, Width:50 , Align:"Center", ColMerge:1,  SaveName:"detail1",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },

 		{Header:"년도0|평가ID",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appraisalCd0",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|평가년도",               Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appraisalYy0",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|소속코드",            	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appOrgCd0",           KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|소속",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"appOrgNm0",           KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|직급코드",              	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikgubCd0",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|직급",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikgubNm0",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|직위코드",              	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikweeCd0",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|직위",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikweeNm0",      KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|직책",               	Type:"Text", Hidden:1, Width:80 , Align:"Center", ColMarge:1,  SaveName:"jikchakNm0",     KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|KPI",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"finalMboClassNm0",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|역량",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"finalCompClassNm0",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|종합",               	Type:"Text", Hidden:0, Width:80 , Align:"Center", ColMarge:1,  SaveName:"finalClassNm0",          KeyField:0,   CalcLogic:"", Format:"",        PointCount:0, UpdateEdit:0, InsertEdit:0, EditLen:50},
 		{Header:"년도0|상세보기",				Type:"Image",Hidden:0, Width:50 , Align:"Center", ColMerge:1,  SaveName:"detail0",				KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		sheet1.SetMergeSheet( msHeaderOnly);

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");
		sheet1.SetDataLinkMouse("detail2",1);
		sheet1.SetDataLinkMouse("detail1",1);
		sheet1.SetDataLinkMouse("detail0",1);


		var sOption = "";
		var nowYY = parseInt("${curSysYear}", 10);
		for(var i = nowYY-5 ; i < nowYY+5; i++) {
			if ( i == nowYY ) sOption += "<option value='"+ i +"' selected>"+ i +"</option>";
			else sOption += "<option value='"+ i +"'>"+ i +"</option>";
		}
		$("#appraisalYy").html(sOption);


        $("#searchNmSabun").bind("keyup",function(event){
			if( event.keyCode == 13){
		 		doAction1("Search");
			}
		});

		$(window).smartresize(sheetResize); sheetInit();

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			//doAction2("Clear");
			sheet1.SetCellText(0, "finalMboClassNm2", $("#appraisalYy").val() - 2 +"년도");
			sheet1.SetCellText(0, "finalMboClassNm1", $("#appraisalYy").val() - 1 +"년도");
			sheet1.SetCellText(0, "finalMboClassNm0", $("#appraisalYy").val() +"년도");
			sheet1.DoSearch( "${ctx}/EmpPapResultLst.do?cmd=getEmpPapResultLst", $("#srchFrm").serialize() );
			break;

		case "Down2Excel":
			sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") alert(Msg);

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY

		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
			if(sheet1.ColSaveName(Col) == "detail0" || sheet1.ColSaveName(Col) == "detail1" || sheet1.ColSaveName(Col) == "detail2"){
				if(!isPopup()) {return;}

				var w 		= 1024;
				var h 		= 900;
				var url 	= "${ctx}/EmpPapResultLst.do?cmd=viewEmpPapResultLayer";
				
				var colIdx;
				if(sheet1.ColSaveName(Col) == "detail0"){
					colIdx = "0";
				}else if(sheet1.ColSaveName(Col) == "detail1"){
					colIdx = "1";
				}else if(sheet1.ColSaveName(Col) == "detail2"){
					colIdx = "2";
				}
				
				var p = {
						appraisalCd : sheet1.GetCellValue(Row,"appraisalCd"+colIdx),
						appraisalYy : sheet1.GetCellValue(Row,"appraisalYy"+colIdx),
						appOrgCd : sheet1.GetCellValue(Row,"appOrgCd"+colIdx),
						sabun : sheet1.GetCellValue(Row,"sabun"),
						name : sheet1.GetCellValue(Row,"name"),
						appOrgNm : sheet1.GetCellValue(Row,"appOrgNm"+colIdx),
						jikgubNm : sheet1.GetCellValue(Row,"jikgubNm"+colIdx),
						jikgubCd : sheet1.GetCellValue(Row,"jikgubCd"+colIdx),
						jikweeNm : sheet1.GetCellValue(Row,"jikweeNm"+colIdx),
						jikweeCd : sheet1.GetCellValue(Row,"jikweeCd"+colIdx),
						jikchakNm : sheet1.GetCellValue(Row,"jikchakNm"+colIdx),
						gempYmd : sheet1.GetCellText(Row,"gempYmd"),
						//args["jikweeYeuncha"] = sheet1.GetCellValue(Row,"jikweeYeuncha");
						finalClassNm : sheet1.GetCellValue(Row,"finalClassNm"+colIdx)	
				}
				
				var layer = new window.top.document.LayerModal({
		      		id : 'empPapResultLayer'
		          , url : url
		          , parameters: p
		          , width : w
		          , height : h
		          , title : "<tit:txt mid='empPapResultLayer' mdef='평가결과'/>"
		          , trigger :[
		              {
		                    name : 'empPapResultLayerTrigger'
		                  , callback : function(rv){
		                  }
		              }
		          ]
		      });
		  	layer.show();
				
			/* 	레이어 팝업으로 변경
				var colIdx;
				if(sheet1.ColSaveName(Col) == "detail0"){
					colIdx = "0";
				}else if(sheet1.ColSaveName(Col) == "detail1"){
					colIdx = "1";
				}else if(sheet1.ColSaveName(Col) == "detail2"){
					colIdx = "2";
				}

				var args = new Array();
				args["appraisalCd"] = sheet1.GetCellValue(Row,"appraisalCd"+colIdx);
				args["appraisalYy"] = sheet1.GetCellValue(Row,"appraisalYy"+colIdx);
				args["appOrgCd"] = sheet1.GetCellValue(Row,"appOrgCd"+colIdx);
				args["sabun"] = sheet1.GetCellValue(Row,"sabun");
				args["name"] = sheet1.GetCellValue(Row,"name");
				args["appOrgNm"] = sheet1.GetCellValue(Row,"appOrgNm"+colIdx);
				args["jikgubNm"] = sheet1.GetCellValue(Row,"jikgubNm"+colIdx);
				args["jikgubCd"] = sheet1.GetCellValue(Row,"jikgubCd"+colIdx);
				args["jikweeNm"] = sheet1.GetCellValue(Row,"jikweeNm"+colIdx);
				args["jikweeCd"] = sheet1.GetCellValue(Row,"jikweeCd"+colIdx);
				args["jikchakNm"] = sheet1.GetCellValue(Row,"jikchakNm"+colIdx);
				args["gempYmd"] = sheet1.GetCellText(Row,"gempYmd");
				//args["jikweeYeuncha"] = sheet1.GetCellValue(Row,"jikweeYeuncha");
				args["finalClassNm"] = sheet1.GetCellValue(Row,"finalClassNm"+colIdx);

				openPopup("${ctx}/EmpPapResultLst.do?cmd=viewEmpPapResultPop", args, "1024","900"); */
			}
		}catch(ex){
			alert("OnClick Event Error : " + ex);
		}
	}

	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete) {
		try {
		} catch (ex) {
			alert("OnSelectCell Event Error : " + ex);
		}
	}

	// 소속 팝업
	function orgSearchPopup() {
		if(!isPopup()) {return;}

		var args	= {};
		args["baseDate"] = $("#appraisalYy").val()+"-01-01";
		args["authPg"] = "R";

		gPRow = "";
		pGubun = "searchOrgBasicPopup";

		var layer = new window.top.document.LayerModal({
			id : 'searchOrgBasicPopupLayer'
			, url : "${ctx}/Popup.do?cmd=orgBasicPopup"
			, parameters: args
			, width : 680
			, height : 520
			, title : "조직 리스트 조회"
			, trigger :[
				{
					name : 'searchOrgBasicPopupTrigger'
					, callback : function(rv){
						getReturnValue(rv);
					}
				}
			]
		});
		layer.show();

	}


	//팝업 콜백 함수.
	function getReturnValue(rv) {
        if(pGubun == "searchOrgBasicPopup"){
			$("#searchOrgCd").val(rv["orgCd"]);
			$("#searchOrgNm").val(rv["orgNm"]);
			doAction1("Search");
        }
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
		<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" value=""/>
		<div class="sheet_search outer">
			<div>
				<table>
					<tr>
						<td>
							<span>평가년도</span>
							<SELECT id="appraisalYy" name="appraisalYy" class="box"></SELECT>
						</td>

						<td><span>소속 </span>
							<input id="searchOrgCd" name="searchOrgCd" type="hidden" class="text" readOnly />
							<input id="searchOrgNm" name="searchOrgNm" type="text" class="text readonly w100" readOnly />
							<a onclick="javascript:orgSearchPopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
							<a onclick="$('#searchOrgCd,#searchOrgNm').val('');" class="button7"><img src="/common/images/icon/icon_undo.png"/></a>
						</td>
						<td>
							<span>성명/사번</span>
							<input id="searchNmSabun" name ="searchNmSabun" type="text" class="text" />
						</td>
						<td>
							<a href="javascript:doAction1('Search')" id="btnSearch" class="btn dark">조회</a>
						</td>
					</tr>
				</table>
			</div>
		</div>
	</form>
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">직원평가결과조회</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR">다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
</div>
</body>
</html>