<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title>선물신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script src="${ctx}/common/js/employeeHeader.js" type="text/javascript" charset="utf-8"></script>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
		//Sheet 초기화
		init_sheet();
		
		//사번셋팅
		setEmpPage();
	});

	//Sheet 초기화
	function init_sheet(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo",		Sort:0 },
			{Header:"삭제",		Type:"${sDelTy}",	Hidden:1,    Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"상태",		Type:"${sSttTy}",	Hidden:1,    Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"제목",			Type:"Text",	Hidden:0, Width:150, Align:"Center",	ColMerge:0,	SaveName:"title",		KeyField:0,	Format:"",		Edit:0},
			{Header:"시작일",			Type:"Date",	Hidden:0, Width:70,	 Align:"Center",	ColMerge:0,	SaveName:"sdate",		KeyField:0,	Format:"Ymd",	Edit:0},
			{Header:"종료일",			Type:"Date",	Hidden:0, Width:70,	 Align:"Center",	ColMerge:0,	SaveName:"edate",		KeyField:0,	Format:"Ymd",	Edit:0},
			{Header:"선물신청",		Type:"Html",	Hidden:0, Width:55,  Align:"Center",	ColMerge:0,	SaveName:"btnApp",  	Sort:0 },
			
			{Header:"선물명",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"giftNm",		Edit:0 },
			{Header:"신청일자",		Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applYmd",		Format:"Ymd", 		Edit:0 },
			{Header:"이름",			Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"recName",		Edit:0 },
			{Header:"연락처",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"recPhone",	Edit:0 },
			{Header:"주소",			Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"recAddr",		Edit:0 },
			{Header:"배송요청사항",		Type:"Text",	Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"note",		Edit:0 },
			
  			//Hidden
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"giftSeq"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"giftCd"},
  			{Header:"Hidden",	Type:"Text",   Hidden:1, SaveName:"appYn"},

  		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
  		
		sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함

		$(window).smartresize(sheetResize); sheetInit();

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				var sXml = sheet1.GetSearchData("${ctx}/GiftApp.do?cmd=getGiftAppList", $("#sheet1Form").serialize() );
				//sXml = replaceAll(sXml,"shtcolEdit", "Edit");
				sheet1.LoadSearchData(sXml );
	        	break;	
	        case "Down2Excel":
				var downcol = makeHiddenSkipCol(sheet1, ['Html']);
				var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
				sheet1.Down2Excel(param); 
				break;
		}
	}
	
	//-----------------------------------------------------------------------------------
	//		sheet1 이벤트
	//-----------------------------------------------------------------------------------
	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}


	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
			if( Row < sheet1.HeaderRows() ) return;
			
		    if( sheet1.ColSaveName(Col) == "btnApp" &&  sheet1.GetCellValue(Row, "appYn") == "Y" ) {
		    	
				if(!isPopup()) {return;}
				gPRow = Row;
				pGubun = "giftAppDetPopup";

				var args 	= new Array();
				args["giftSeq"] = sheet1.GetCellValue(Row, "giftSeq");
				args["applSabun"] = $("#searchSabun").val();
				
				
				//var rv = openPopup("/GiftApp.do?cmd=viewGiftAppDet", args, "850","700");
		    
		        let layerModal = new window.top.document.LayerModal({
	                id : 'giftAppDetLayer'
	              , url : '/GiftApp.do?cmd=viewGiftAppDetLayer'
	              , parameters : args 
	              , width : 850
	              , height : 700
	              , title : '선물신청'
	              , trigger :[
	                  {
	                      name : 'giftAppDetTrigger'
	                      , callback : function(result){
	                    	  getReturnValue(result);
	                      }
	                  }
	              ]
	          });
	          layerModal.show();
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	
	//신청 팝업에서  리턴
	function getReturnValue(returnValue) {
		doAction1("Search");
	}

	//인사헤더에서 이름 변경 시 호출 됨 
    function setEmpPage() {
    	$("#searchSabun").val($("#searchUserId").val());
    	doAction1("Search");
    }
	
</script>
</head>
<body class="hidden">
<div class="wrapper">
	<!-- include 기본정보 page TODO -->
	<%@ include file="/WEB-INF/jsp/common/include/employeeHeader.jsp"%>
	
	<form id="sheet1Form" name="sheet1Form" >
		<input type="hidden" id="searchSabun" name="searchSabun" value=""/>
	</form>
	
	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">선물신청</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray" >다운로드</a>
					<a href="javascript:doAction1('Search')" 		class="btn dark" >조회</a>
				</li>
			</ul>
		</div>
	</div>
	<script type="text/javascript">createIBSheet("sheet1", "100%", "100%"); </script>

</body>
</html>
