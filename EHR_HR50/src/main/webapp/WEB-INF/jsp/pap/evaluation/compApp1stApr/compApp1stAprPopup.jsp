<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");

	$(function() {

		var arg = p.window.dialogArguments;
		var t_searchAppraisalCd;

		if( arg != undefined ) {
	    	$("#searchAppSabun").val(arg["searchSabun"]);
	    	t_searchAppraisalCd = arg["searchAppraisalCd"];
	    }

		//평가진행상태
		 var result = ajaxCall("/CompAppSelfReg.do?cmd=getCompAppSelfRegSearchAppraisalCdMap","searchAppraisalCd="+t_searchAppraisalCd + "&searchAppTypeCd=F",false);

		 if(result != null && result.map != null){
			$("#searchAppraisalCd").val(result.map.searchAppraisalCd);
		 }

	     $(".close").click(function() {
		    	p.self.close();
	     });

		var initdata = {};
		initdata.Cfg = {/* FrozenCol:6 ,*/SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"평가ID코드(TPAP101)",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appraisalCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"사원번호",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가소속코드",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appOrgCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가차수코드",			Type:"Text",	Hidden:1,	Width:200,	Align:"Center",	ColMerge:0,	SaveName:"appSeqCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"평가자사번",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"코칭일자",				Type:"Date",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"coaYmd",			KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"코칭장소",				Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"coaPlace",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1330 },
			{Header:"코칭내용",				Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"memo",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1330,  MultiLineText:1,Wrap:1, ToolTip:1  }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");


		var coboCodeList1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalCdListMobOrgTargetReg&searchAppStepCd=3&searchAppTypeCd=F&searchAppraisalSeq=0",false).codeList, "");	//평가명
		var coboCodeList2 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppIndexGubunCdList",false).codeList, "");	//지표구분
		$("#searchAppraisalCd").html(coboCodeList1[2]);
		sheet1.SetColProperty("appIndexGubunCd", 			{ComboText:coboCodeList2[0], ComboCode:coboCodeList2[1]} );

		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": 	 	case "Search": 	 	sheet1.DoSearch( "${ctx}/MboCoachingApr.do?cmd=getMboCoachingAprList2", $("#srchFrm").serialize() ); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try { if (Msg != "") { alert(Msg); } doAction1('Search'); } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "zip") {
	            var rst = openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");
	            if(rst != null){
	            	sheet1.SetCellValue(Row, "zip", rst["zip"]);
	            	sheet1.SetCellValue(Row, "addr", rst["sido"]+ " "+ rst["gugun"] +" " + rst["dong"]);
	            	sheet1.SetCellValue(Row, "detailAddr", rst["bunji"]);
	            }
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try{
		    if(Row > 0 && sheet1.ColSaveName(Col) == "detail"){
		    	locationMgrPopup(Row);
		    }
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">

	<div class="popup_title">
		<ul>
			<li>코칭확인</li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
	            <form id="srchFrm" name="srchFrm">
	                <input type="hidden" id="searchAppSabun" name="searchAppSabun" value=""/>
	                <input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
		        </form>

        	<div id="tabs">
				<ul class="outer tab_bottom">
				</ul>

					<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
						<tr>
							<td>
								<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
							</td>
						</tr>
					</table>
			</div>

			<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large">닫기</a>
				</li>
			</ul>
			</div>
		</div>

</div>
</body>
</html>