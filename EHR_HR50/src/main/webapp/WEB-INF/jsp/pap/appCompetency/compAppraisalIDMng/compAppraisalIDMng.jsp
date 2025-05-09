<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

var gPRow = "";
var pGubun = "";

	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"\n선택",								Type:"DummyCheck",	Hidden:1,	Width:40,	Align:"Center",	ColMerge:1,	SaveName:"chk",				KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y", FalseValue:"N" },
			{Header:"회사코드",	Type:"Text",	Hidden:1,	Width:50,	Align:"Left",	ColMerge:0,	SaveName:"enterCd",			KeyField:1,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='appraisalYy' mdef='년도'/>",		Type:"Text",	  Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"appraisalYy",		KeyField:1,	CalcLogic:"",	Format:"Number", PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:4 },
			{Header:"다면평가ID",										Type:"Text",	  Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"compAppraisalCd",	KeyField:0,	CalcLogic:"",	Format:"",		 PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"다면평가ID명",										Type:"Text",	  Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"compAppraisalNm",	KeyField:0,	CalcLogic:"",	Format:"",		 PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='eduSYmd' mdef='시작일'/>",			Type:"Date",	  Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appSYmd",			KeyField:0,	CalcLogic:"",	Format:"Ymd",	 PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='eYmdV1' mdef='종료일'/>",			Type:"Date",	  Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"appEYmd",			KeyField:0,	CalcLogic:"",	Format:"Ymd",	 PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='conYn' mdef='합산여부'/>",			Type:"Text",	  Hidden:1,	Width:80,	Align:"Left",	ColMerge:0,	SaveName:"conYn",			KeyField:0,	CalcLogic:"",	Format:"",		 PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='closeYnV1' mdef='마감여부'/>",		Type:"Combo",	  Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"closeYn",			KeyField:0,	CalcLogic:"",	Format:"",		 PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",			Type:"Text",	  Hidden:1,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"note",			KeyField:0,	CalcLogic:"",	Format:"",		 PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='searchSeqV4' mdef='검색설명'/>",	Type:"Text",      Hidden:1, Width:80,   Align:"Center", ColMerge:0, SaveName:"searchSeq",     	KeyField:0, CalcLogic:"",   Format:"",       PointCount:0,  UpdateEdit:1,   InsertEdit:1,   EditLen:10 },
            {Header:"대상자",											Type:"Popup", 	  Hidden:1, Width:230,  Align:"Left",   ColMerge:0, SaveName:"searchSeqNm",   	KeyField:0, CalcLogic:"",   Format:"",       PointCount:0,  UpdateEdit:1,   InsertEdit:1,   EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

		sheet1.SetColProperty("closeYn",	{ComboText:"|N|Y", ComboCode:"|N|Y"} );

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");
	});

	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet1.DoSearch( "${ctx}/CompAppraisalIDMng.do?cmd=getCompAppraisalIDMngList", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장
				IBS_SaveName(document.srchFrm,sheet1);
				sheet1.DoSave( "${ctx}/CompAppraisalIDMng.do?cmd=saveCompAppraisalIDMng", $("#srchFrm").serialize() );
				break;

			case "Insert":		//입력
				var Row = sheet1.DataInsert(0);
				break;

			case "Copy":		//행복사
				var Row = sheet1.DataCopy();
				sheet1.SetCellValue(Row, "compAppraisalCd", "");
				break;

			case "Clear":		//Clear
				sheet1.RemoveAll();
				break;

			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;

			case "LoadExcel":	//엑셀업로드
				var params = {Mode:"HeaderMatch", WorkSheetNo:1};
				sheet1.LoadExcel(params);
				break;
		}
	}

//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

//<!-- 저장 후 에러 메시지 -->
	function sheet1_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}

			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}

//<!--셀에서 키보드가 눌렀을때 발생하는 이벤트-->
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

	function sheet1_OnPopupClick(Row, Col){
		try{

		  var colName = sheet1.ColSaveName(Col);
		  var args    = new Array();

		  args["searchSeq"]   = sheet1.GetCellValue(Row, "searchSeq");
          args["searchDesc"]  = sheet1.GetCellValue(Row, "searchSeqNm");

		  var rv = null;

		  if(colName == "searchSeqNm") {
			  if(!isPopup()) {return;}
			  gPRow = Row;
			  pGubun = "pwrSrchMgrPopup";
			  var rv = openPopup("/Popup.do?cmd=pwrSrchMgrPopup&authPg=${authPg}", args, "1100","520");
		  }

		}catch(ex){alert("OnPopupClick Event Error : " + ex);}
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "pwrSrchMgrPopup"){
            sheet1.SetCellValue(gPRow, "searchSeq",   rv["searchSeq"] );
            sheet1.SetCellValue(gPRow, "searchSeqNm", rv["searchDesc"] );
	    }
	}

	function sendPush(){
		var chkRows = sheet1.FindCheckedRow("chk");
		var saveArr = chkRows.split("|");

		if(chkRows == "") {
			alert("대상 ID를 선택해주세요."); return;
		}else{
			if(!confirm("리더십평가대상에게 알림Push를 전송하시겠습니까?")) return;
			for(var i=0; i < saveArr.length; i++){
				if(sheet1.GetCellValue(saveArr[i],"closeYn") == "Y") {
					alert("이미 마감된 평가입니다.(" + sheet1.GetCellValue(saveArr[i],"compAppraisalNm") + ")"); return;
				}
				var paramTmp = "searchCompAppraisalCd=" + sheet1.GetCellValue(saveArr[i],"compAppraisalCd");
				var enterCd = sheet1.GetCellValue(saveArr[i],"enterCd");
				var pushTarget = new Array();
				var title, content;
				//대상자 가져오기
				var data = ajaxCall("${ctx}/CompAppraisalIDMng.do?cmd=getAppPeopleList", paramTmp, false);
				if(data.DATA != null){
					for(var j=0; j < data.DATA.length; j++) {
						pushTarget[j] = data.DATA[j].pushTarget;
					}
				}else{
					alert(sheet1.GetCellValue(saveArr[i],"compAppraisalNm") + " 대상자가 존재하지 않습니다.");
					return;
				}

				title = sheet1.GetCellValue(saveArr[i],"compAppraisalNm")  + "일정 알림";
				content = "새로운 리더십평가 일정이 등록되었습니다. e-HR에서 확인하시기 바랍니다.";
				//push 알림 전송
				var param = {
					"enterCd"	 : enterCd,
					"title"	 	 : title,
					"content"	 : content,
					"target"	 : pushTarget
				};

				$.ajax({
					url: "${ctx}/sendPush.do",
					type: "post",
					async:true,
					data:JSON.stringify(param),
					contentType : "application/json; charset=utf-8",
					success : function(rv) {
						alert("전송이 완료되었습니다.");
					},
					error : function(jqXHR, ajaxSettings, thrownError) {
						console.log(JSON.stringify(param));
						alert("push error");
					}
				});
			}
		}
	}
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	</form>
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">리더십평가ID관리</li>
							<li class="btn">
<%--								<a href="javascript:sendPush()" class="button">sendPush</a>--%>
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline_gray authR"><tit:txt mid='download' mdef='다운로드'/></a>
								<a href="javascript:doAction1('Copy')" 	class="btn outline_gray authA"><tit:txt mid='104335' mdef='복사'/></a>
								<a href="javascript:doAction1('Insert')" class="btn outline_gray authA"><tit:txt mid='104267' mdef='입력'/></a>
								<a href="javascript:doAction1('Save')" 	class="btn filled authA"><tit:txt mid='104476' mdef='저장'/></a>
								<a href="javascript:doAction1('Search')" class="btn dark"><tit:txt mid='104081' mdef='조회'/></a>
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
