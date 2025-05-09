<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='113242' mdef='승진급대상자관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
var gPRow = "";
var pGubun = "";

var p = eval("${popUpStatus}");
var baseYmd = "";

	$(function() {

		var arg = p.popDialogArgumentAll();
		
		if( arg != undefined ) {
			baseYmd = arg["baseYmd"];
			$("#searchBaseYmd").val(baseYmd);
		}
		
		$("input[type='text']").keydown(function(event){ 
			if(event.keyCode == 27){
				return false;
			}
		});

		$(".close").click(function() {
			p.self.close();
		});
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNoV1' mdef='No|No'/>",				Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V1' mdef='삭제|삭제'/>",				Type:"${sDelTy}",	Hidden:1,					Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus V4' mdef='상태|상태'/>",				Type:"${sSttTy}",	Hidden:1,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"승진기준일|승진기준일",	Type:"Date",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"proYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:10 },
			{Header:"본사구분|본사구분",		Type:"Text",	Hidden:0,	Width:110,	Align:"Center",	ColMerge:0,	SaveName:"enterNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='sabunV2' mdef='사번|사번'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='appOrgNmV6' mdef='소속|소속'/>",			Type:"Text",	Hidden:0,	Width:120,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='jikweeCdV1' mdef='직위|직위'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='nameV3' mdef='성명|성명'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='empYmdV1' mdef='입사일|입사일'/>",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",			KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"최종승진일|최종승진일",	Type:"Text",  	Hidden:0, Width:100,	Align:"Center", ColMerge:0, SaveName:"currJikweeYmd",	KeyField:0, Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },

			{Header:"조정전|직급",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubCd",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"조정전|호봉",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"salClass",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"조정전|기본급",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfMon1",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정전|시간외수당",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfMon2",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정전|기본급",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfMon12",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정전|업적기본급",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfMon3",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정전|업적시간외",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfMon4",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정전|업적급",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfMon34",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정전|월 지급 계",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfMon1234",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정후|직급",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"riseJikgubCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"조정후|호봉",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"riseSalClass",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"조정후|기본급",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"atMon1",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정후|시간외수당",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"atMon2",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정후|기본급",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"atMon12",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정후|업적기본급",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"atMon3",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정후|업적시간외",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"atMon4",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정후|업적급",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"atMon34",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정후|월 지급 계",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"atMon1234",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정내역|기본급",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfatMon12",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정내역|업적급",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfatMon34",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정내역|조정계",		Type:"Int",		Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfatMon1234",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"조정내역|조정율",		Type:"Float",	Hidden:0,	Width:80,	Align:"Right",	ColMerge:0,	SaveName:"bfatRate",		KeyField:0,	Format:"",		PointCount:2,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable(false);sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();
		
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
						if(!checkList()) return ;
						sheet1.RemoveAll();
						sheet1.DoSearch( "${ctx}/PromTargetMgr.do?cmd=getPromTargetMgrChoPopList", $("#sendForm").serialize() );
						break;
		case "Down2Excel":
						var downcol = makeHiddenSkipCol(sheet1);
						var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
						sheet1.Down2Excel(param);
			
						break;
		}
	}

	// 조회 후 에러 메시지
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

	// 입력시 조건 체크
	function checkList(){
		var ch = true;
		var exit = false;
		if(exit){return false;}
			// 화면의 개별 입력 부분 필수값 체크
		$(".required").each(function(index){
			if($(this).val() == null || $(this).val() == ""){
				alert($(this).parent().prepend().find("span:first-child").text()+"은(는) 필수값입니다.");
				$(this).focus();
				ch =  false;
				return false;
			}
		});
		return ch;
	}

	function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">

	<div class="popup_title">
		<ul>
			<li>승급초임대장</li>
			<li class="close"></li>
		</ul>
	</div>

	<div class="popup_main">
<form name="sendForm" id="sendForm" method="post">
	<input id="searchBaseYmd" name="searchBaseYmd" type="hidden" />
</form>

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
			<tr>
				<td>
				<div class="inner">
					<div class="sheet_title">
					<ul>
						<li class="btn">
							<a href="javascript:doAction1('Search');" 			class="basic authR"><tit:txt mid='104081' mdef='조회'/></a>
							<a href="javascript:doAction1('Down2Excel');" 		class="basic authR"><tit:txt mid='download' mdef='다운로드'/></a>
						</li>
					</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
				</td>
			</tr>
		</table>

		<div class="popup_button outer">
			<ul>
				<li>
					<a href="javascript:p.self.close();" class="gray large" ><tit:txt mid='104157' mdef='닫기'/></a>
				</li>
			</ul>
		</div>
	
	</div>
</div>
</body>
</html>
