<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
	.extIncom {
		color: #868686 !important;
	}
	.incomingMgrPopup {
		color: #018ed3 !important;
		color: var(--txt_color_base, #018ed3) !important;
	}
	.incomingMgrPopup:hover {
		text-decoration: underline;
	}
</style>
<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		
		$("#searchGradeCd, #searchGrpWork, #searchYyyy").on("change", function(e){
			doAction("Search");
		});
		$("#searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
		});
		
		// 기준년도 코드 목록 조회
		var baseYearCdList = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&","queryId=getCoreMgrBaseYearCdList",false).codeList, ""); //척도코드
		$("#searchYyyy").html(baseYearCdList[2]);

		var initdata = {};
		initdata.Cfg = {FrozenCol:0/*9*/, SearchMode:smLazyLoad, MergeSheet:msHeaderOnly,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
			{Header:"No|No",    Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo"},
			{Header:"삭제|삭제",   	Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete", Sort:0 },
			{Header:"상태|상태",   	Type:"${sSttTy}",	Hidden:0,					Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus", Sort:0 },
			
			{Header:"기준일|기준일",							Type:"Date",	Hidden:0,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"basicYmd",	KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"사번|사번",							Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명|성명",							Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
			{Header:"부서|부서",							Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"orgNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직급|직급",							Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikgubNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"직군|직군",							Type:"Combo",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"grpWork",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			
			/* 평가 사용 안함
			{Header:"평가|10",							Type:"Combo",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"y10",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평가|9",								Type:"Combo",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"y9",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평가|8",								Type:"Combo",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"y8",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평가|7",								Type:"Combo",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"y7",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평가|6",								Type:"Combo",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"y6",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평가|5",								Type:"Combo",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"y5",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평가|4",								Type:"Combo",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"y4",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평가|3",								Type:"Combo",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"y3",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평가|2",								Type:"Combo",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"y2",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평가|1",								Type:"Combo",	Hidden:1,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"y1",			KeyField:0,	F0ormat:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"B+이상\n받은비율(%)|B+이상\n받은비율(%)",	Type:"Text",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"aGrade1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			{Header:"평점\n(5점만점)|평점\n(5점만점)",			Type:"Text",	Hidden:1,	Width:90,	Align:"Center",	ColMerge:0,	SaveName:"aGrade2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:8 },
			*/

			{Header:"승계 후임자|1순위",						Type:"Html",	Hidden:0,	Width:165,	Align:"Center",	ColMerge:0,	SaveName:"incom1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"승계 후임자|2순위",						Type:"Html",	Hidden:0,	Width:165,	Align:"Center",	ColMerge:0,	SaveName:"incom2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	},
			{Header:"승계 후임자|3순위",						Type:"Html",	Hidden:0,	Width:165,	Align:"Center",	ColMerge:0,	SaveName:"incom3",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100	}

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);
		
		/* 평가 사용 안함
		sheet1.SetColProperty("y1", 		{ComboText:"|"+codeLists["L30050"][0], ComboCode:"|"+codeLists["L30050"][1]} );
		sheet1.SetColProperty("y2", 		{ComboText:"|"+codeLists["L30050"][0], ComboCode:"|"+codeLists["L30050"][1]} );
		sheet1.SetColProperty("y3", 		{ComboText:"|"+codeLists["L30050"][0], ComboCode:"|"+codeLists["L30050"][1]} );
		sheet1.SetColProperty("y4", 		{ComboText:"|"+codeLists["L30050"][0], ComboCode:"|"+codeLists["L30050"][1]} );
		sheet1.SetColProperty("y5", 		{ComboText:"|"+codeLists["L30050"][0], ComboCode:"|"+codeLists["L30050"][1]} );
		sheet1.SetColProperty("y6", 		{ComboText:"|"+codeLists["L30050"][0], ComboCode:"|"+codeLists["L30050"][1]} );
		sheet1.SetColProperty("y7", 		{ComboText:"|"+codeLists["L30050"][0], ComboCode:"|"+codeLists["L30050"][1]} );
		sheet1.SetColProperty("y8", 		{ComboText:"|"+codeLists["L30050"][0], ComboCode:"|"+codeLists["L30050"][1]} );
		sheet1.SetColProperty("y9", 		{ComboText:"|"+codeLists["L30050"][0], ComboCode:"|"+codeLists["L30050"][1]} );
		sheet1.SetColProperty("y10", 		{ComboText:"|"+codeLists["L30050"][0], ComboCode:"|"+codeLists["L30050"][1]} );
		*/
		
		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"]);
						sheet1.SetCellValue(gPRow, "orgNm",		rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "name",		rv["name"]);
					}
				}
			]
		});

		$("#searchYyyy").change(function () {
			getCommonCodeList();
		})

		$(window).smartresize(sheetResize); sheetInit();
		getCommonCodeList();
		doAction("Search");
	});

	function getCommonCodeList() {
		// 그룹코드 조회
		//var grpCds = "'CD1200','L30050', 'CD1050'";
		var grpCds = "CD1200";
		var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+grpCds,false).codeList, (("${ssnLocaleCd}" == "ko_KR" || "${ssnLocaleCd}" == "") ? "전체" : "All"));
		//$("#searchGradeCd").html(codeLists["CD1050"][2]).val("5").find("option:eq(0)").remove();	// '전체' 옵션 엘레먼트 제거
		$("#searchGrpWork").html(codeLists["CD1200"][2]);
		sheet1.SetColProperty("grpWork", 	{ComboText:"|"+codeLists["CD1200"][0], ComboCode:"|"+codeLists["CD1200"][1]} );

	}
	
	//Sheet Action
	function doAction(sAction) {
		switch (sAction) {
		case "Search":
			// getCommonCodeList();
			if($("#searchYyyy").val() == "" || $("#searchYyyy").val().length < 4) {
				alert("기준년도를 입력해 주세요.");
				return;
			}
			
			var searchGradeCd = $("#searchGradeCd").val();
			var searchYyyy = $("#searchYyyy").val();
			
			/*
			//5년(1,2,3,4,5) ,3년(1,2,3) 보여야함
			//평가 전체컬럼 숨기고 평가년도(10, 5, 3 등)로 들어온 컬럼만큼 보이도록 수정
			for(var i = 1; i <= 10; i++) {
				sheet1.SetColHidden("y"+i, 1);
			}
			for(var i = 1; i <= searchGradeCd; i++) {
				sheet1.SetCellText(1, "y"+i, searchYyyy - (i-1)); 
				sheet1.SetColHidden("y"+i, 0);
				sheet1.SetColWidth("y"+i,50); //컬럼 width값 고정(평가년도 컬럼의 width가 동일하지 않아서 넣어줌)
			}
			
			//평가년도에 따라 컬럼명 수정
			sheet1.SetCellText(0, "aGrade1", searchGradeCd + "년간 B+이상\n받은비율(%)");
			sheet1.SetCellText(1, "aGrade1", searchGradeCd + "년간 B+이상\n받은비율(%)");
			sheet1.SetCellText(0, "aGrade2", searchGradeCd + "년간 평점\n(5점만점)");
			sheet1.SetCellText(1, "aGrade2", searchGradeCd + "년간 평점\n(5점만점)");
			
			// 시트 사이즈 초기화
			sheetInit();
			*/
			
			sheet1.DoSearch( "${ctx}/CoreMgr.do?cmd=getCoreMgrList", $("#empForm").serialize() );
			break;
		case "Save":
			if (!dupChk(sheet1, "sabun|basicYmd", false, true)) {break;}
			IBS_SaveName(document.empForm,sheet1);
			sheet1.DoSave("${ctx}/CoreMgr.do?cmd=saveCoreMgr" , $("#empForm").serialize());  break;
		case "Copy":      	sheet1.DataCopy();	break;
		case "Insert":
			var iRow =  sheet1.DataInsert(0);
			sheet1.SelectCell(iRow, 5);
			sheet1.SetCellValue(iRow, "basicYmd", "${curSysYyyyMMddHyphen}");
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);

			break;
		}
	}

	// 승계 후임자 출력 html 반환
	function getIncomHtml(data) {
		var arr, aIncom = "", vIncom = "";
		if( data && data != null && data != "" ) {
			if( typeof data === "string" ) {
				arr = data.split(",");
				for (var i = 0; i < arr.length; i++) {//1순위후보
					if(arr[i] != null && arr[i] != ""){
						if(aIncom != "") aIncom += "<br/>";
						vIncom = arr[i].split("^^")[5];
						if( vIncom == "EXT_INCOM" ) {
							aIncom += "<span class='extIncom'>외부영입</span>";
						} else {
							aIncom += "<a class='incomingMgrPopup' href=\"javascript:openIncomingMgrPopup('" + arr[i] + "');\">" + vIncom + "<i class='fas fa-search mal5'></i></a>";
						}
					}
				}
			}
		}
		return aIncom;
	}
	
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try { 
			if (Msg != "") { alert(Msg); }
		
			//승계포지션 1,2,3순위후보 클릭시 상세보기 나오도록 수정
			if(sheet1.RowCount() > 0){
				for(var i = sheet1.HeaderRows(); i < sheet1.LastRow() + 1; i++){
					sheet1.SetCellValue(i, "incom1", getIncomHtml(sheet1.GetCellValue(i, "incom1")));
					sheet1.SetCellValue(i, "incom2", getIncomHtml(sheet1.GetCellValue(i, "incom2")));
					sheet1.SetCellValue(i, "incom3", getIncomHtml(sheet1.GetCellValue(i, "incom3")));
					sheet1.SetCellValue(i, "sStatus","R");
				}
			}
			
			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}
	
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			if( Code > -1 ) doAction("Search");
		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
	}

	//후보자(1~3순위) 팝업을 띄운다.
	function openIncomingMgrPopup(Row) {
		
		if(!isPopup()) {return;}
		
		let w = 1100;
		let h = 700;
		let url = "${ctx}/IncomingMgr.do?cmd=viewIncomingMgrLayer&authPg=A";
		let dataArr = Row.split("^^");

		let p = {
			enterCd : dataArr[0],
			sabun : dataArr[1],
			incomId : dataArr[2],
			incomSeq : dataArr[3]
		};
		
		gPRow  = Row;
		pGubun = "incomName" + dataArr[1];
		// openPopup(url,args,w,h);

		let layerModal = new window.top.document.LayerModal({
			id : 'incomingMgrLayer'
			, url : url
			, parameters : p
			, width : w
			, height : h
			, title : '후임자관리 세부내역'
			, trigger :[
				{
					name : 'incomingMgrLayerTrigger'
					, callback : function(result){
					}
				}
			]
		});
		layerModal.show();
	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="empForm" name="empForm" >
		<div class="sheet_search outer">
			<div>
			<table>
				<tr>
					<td>
						<span>기준년도</span>
						<select id="searchYyyy" name="searchYyyy"></select>
					</td>
					<td>
						<span>직군</span>
						<select id="searchGrpWork" name="searchGrpWork"></select>
					</td>
					<td class="hide">
						<span>평가년도</span>
						<select id="searchGradeCd" name="searchGradeCd"></select>
					</td>
					<td>
						<span>사번/성명</span>
						<input type="text" id="searchSabunName" name="searchSabunName" class="text" style="ime-mode:active;" />
					</td>
					<td>
						<btn:a href="javascript:doAction('Search')" id="btnSearch" css="button" mid='search' mdef="조회" />
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
							<li class="txt">핵심인재관리</li>
							<li class="btn">
								<btn:a href="javascript:doAction('Insert')" 		css="basic authA" mid='insert' mdef="입력"/>
								<btn:a href="javascript:doAction('Save')" 			css="basic authA" mid='save' mdef="저장"/>
								<btn:a href="javascript:doAction('Down2Excel')" 	css="basic authA" mid='down2excel' mdef="다운로드"/>
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
