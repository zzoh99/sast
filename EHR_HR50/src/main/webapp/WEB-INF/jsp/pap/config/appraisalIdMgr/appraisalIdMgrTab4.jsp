<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<script type="text/javascript">

	$(function() {

		$("#searchAppraisalCd").val($("#searchAppraisalCd", parent.document).val());

		var initdata2 = {};
		initdata2.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata2.Cols = [
		{Header:"No"				,Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
		{Header:"삭제"				,Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center", ColMerge:0,   SaveName:"sDelete" },
		{Header:"상태"				,Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center", ColMerge:0,   SaveName:"sStatus" },
		{Header:"평가ID"				,Type:"Text",	  	Hidden:1,  Width:50,Align:"Center",  ColMerge:0,   SaveName:"appraisalCd",	KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
        {Header:"평가단계"				,Type:"Combo",	  	Hidden:0,  Width:50,Align:"Center",  ColMerge:0,   SaveName:"appStepCd",	KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
		{Header:"이의제기\n시작일"		,Type:"Date",	  	Hidden:0,  Width:80,Align:"Center",  ColMerge:0,   SaveName:"appAsYmd",	 	KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		{Header:"이의제기\n종료일"		,Type:"Date",	  	Hidden:0,  Width:80,Align:"Center",  ColMerge:0,   SaveName:"appAeYmd",		KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		{Header:"상시이의제기\n시작일"	,Type:"Date",	  	Hidden:0,  Width:80,Align:"Center",  ColMerge:0,   SaveName:"appWorkAsYmd",	KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		{Header:"상시이의제기\n종료일"	,Type:"Date",	  	Hidden:0,  Width:80,Align:"Center",  ColMerge:0,   SaveName:"appWorkAeYmd",	KeyField:0,   CalcLogic:"",   Format:"Ymd",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
		]; IBS_InitSheet(sheet2, initdata2);sheet2.SetEditable("${editable}");sheet2.SetVisible(true);sheet2.SetCountPosition(4);
		sheet2.SetUnicodeByte(3);

		//평가단계
		var comboList3 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00005"));
		sheet2.SetColProperty("appStepCd", 			{ComboText:comboList3[0], ComboCode:comboList3[1]} );

		//평가차수
		var comboList4 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getAppraisalIdMgrTab4CdList&useYn=Y&searchAppraisalCd=" + $("#searchAppraisalCd").val(),false).codeList, "");
		sheet2.SetColProperty("appraisalSeq", 			{ComboText:comboList4[0], ComboCode:comboList4[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction2("Search");

	});


	//Sheet1 Action
	function doAction2(sAction) {
		var appraisalCd = $("#searchAppraisalCd").val();
        var parentRow = parent.sheet1.GetSelectRow();
		switch (sAction) {
		case "Search": 	 	sheet2.DoSearch( "${ctx}/AppraisalIdMgr.do?cmd=getAppraisalIdMgrTab4", "appraisalCd="+appraisalCd ); break;
		case "Save":
            if(chkDate(sheet2.GetSelectRow()) == 1){
                return;
            }
			if(sheet2.FindStatusRow("I") != ""){
				if(!dupChk(sheet2,"appraisalCd|appStepCd", true, true)){break;}
			}else if(parent.sheet1.GetCellValue(parentRow, 'exceptionYn') != 'Y'){
                alert("이의제기 여부를 설정해주세요!");
                return;
            }
			IBS_SaveName(document.srchFrm,sheet2);
			sheet2.DoSave( "${ctx}/AppraisalIdMgr.do?cmd=saveAppraisalIdMgrTab4", $("#srchFrm").serialize()); break;
		case "Insert":
			if ( appraisalCd == "" ) {
				alert("평가ID를 선택해 주세요");
				return;
			}else if(parent.sheet1.GetCellValue(parentRow, 'exceptionYn') != 'Y') {
				alert("이의제기 여부를 설정해주세요!");
      	    	return;
			}
			var row = sheet2.DataInsert(0);
			sheet2.SetCellValue(row, "appraisalCd", appraisalCd);
			sheet2.SetCellValue(row, "appStepCd", "5");
			break;
		case "Copy":
			var row = sheet2.DataCopy();

			//sheet2.SetCellValue(row,"appraisalCd","");
			break;
		case "Clear":		sheet2.RemoveAll(); break;
		case "Down2Excel":
		    if(sheet2.RowCount() == 0){
		        alert('엑셀 출력할 내역이 없습니다!');
		        return;
            }
			sheet2.Down2Excel({DownCols:makeHiddenSkipCol(sheet2), SheetDesign:1, Merge:1});
			break;
		case "LoadExcel":	var params = {Mode:"HeaderMatch", WorkSheetNo:1}; sheet2.LoadExcel(params); break;
		}
	}

	// 조회 후 에러 메시지
	function sheet2_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != ""){
				alert(Msg);
			}

			sheetResize();
		}catch(ex){
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet2_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != ""){
				alert(Msg);
			}
			if ( Code != "-1" ) doAction2("Search");
		}catch(ex){
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet2_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction2("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet2.GetCellValue(Row, "sStatus") == "I") {
				sheet2.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	function sheet2_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {}

	/* 이의제기 일자 유효성 체크 */
	function chkDate(Row){
        var parentRow 		= parent.sheet1.GetSelectRow();
        var parentSdate 	= parent.sheet1.GetCellValue(parentRow, "appSYmd");
        var parentEdate		= parent.sheet1.GetCellValue(parentRow, "appEYmd");
        
        if(parentSdate > sheet2.GetCellValue(Row,"appAsYmd")){
            alert("평가시작일보다 이의제기 시작일이 작을 수 없습니다!\n평가시작일로 설정됩니다.");
            sheet2.SetCellValue(Row, "appAsYmd", parentSdate);
            return 1;
        }else if(parentEdate < sheet2.GetCellValue(Row,"appAeYmd")){
            alert("평가종료일보다 이의제기 종료일이 클 수 없습니다!\n평가종료일로 설정됩니다");
            sheet2.SetCellValue(Row, "appAeYmd", parentEdate);
            return 1;
        }
        
        if(sheet2.GetCellValue(Row,"appWorkAsYmd") != "" && (parentSdate > sheet2.GetCellValue(Row,"appWorkAsYmd"))){
            alert("평가시작일보다 상시성과 이의제기 시작일이 작을 수 없습니다!\n평가시작일로 설정됩니다.");
            sheet2.SetCellValue(Row, "appAsYmd", parentSdate);
            return 1;
        }else if(sheet2.GetCellValue(Row,"appWorkAeYmd") != "" && (parentEdate < sheet2.GetCellValue(Row,"appWorkAeYmd"))){
            alert("평가종료일보다 상시성과 이의제기 종료일이 클 수 없습니다!\n평가종료일로 설정됩니다");
            sheet2.SetCellValue(Row, "appAeYmd", parentEdate);
            return 1;
        }
        
        return 0;
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<input type="hidden" id="searchAppraisalCd" name="searchAppraisalCd" />
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li id="txt" class="txt">이의제기일정</li>
				<li class="btn">
					<a href="javascript:doAction2('Search')" class="basic authR">조회</a>
					<a href="javascript:doAction2('Insert')" class="basic authA">입력</a>
					<a href="javascript:doAction2('Save')" 	class="basic authA">저장</a>
					<a href="javascript:doAction2('Down2Excel')" 	class="basic authR">다운로드</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet2", "100%", "100%","kr"); </script>
	</form>
</div>
</body>
</html>