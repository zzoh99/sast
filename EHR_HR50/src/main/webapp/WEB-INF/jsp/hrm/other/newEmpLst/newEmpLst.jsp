<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {
		var initdata = {};
		initdata.Cfg = {FrozenCol:7,SearchMode:smLazyLoad,Page:22};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [

			{Header:"<sht:txt mid='sNo' mdef='No'/>",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",       Type:"${sDelTy}",   Hidden:1,                   Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",       Type:"${sSttTy}",   Hidden:1,                   Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			{Header:"<sht:txt mid='photoV1' mdef='사진'/>",       Type:"Image",   Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",       Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"sabun",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",       Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"name",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",       Type:"Text",    Hidden:Number("${aliasHdn}"),   Width:70,   Align:"Center", ColMerge:0, SaveName:"alias",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",       Type:"Text",    Hidden:0,   Width:140,  Align:"Center", ColMerge:0, SaveName:"orgNm",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",       Type:"Text",    Hidden:Number("${jwHdn}"),   Width:100,  Align:"Center", ColMerge:0, SaveName:"jikweeNm",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			{Header:"<sht:txt mid='applJikgubNmV1' mdef='직책'/>",       Type:"Text",    Hidden:0,   Width:90,   Align:"Center", ColMerge:0, SaveName:"jikchakNm",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",       Type:"Text",    Hidden:Number("${jgHdn}"),   Width:80,   Align:"Center", ColMerge:0, SaveName:"jikgubNm",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='empYmd_V1948' mdef='당사입사일'/>",       Type:"Date",    Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"empYmd",    KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='gempYmd' mdef='그룹입사일'/>",       Type:"Date",    Hidden:0,   Width:80,   Align:"Center", ColMerge:0, SaveName:"gempYmd",    KeyField:0, Format:"Ymd",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='officeTelV1' mdef='사내전화'/>",   Type:"Text",    Hidden:0,   Width:90,   Align:"Center", ColMerge:0, SaveName:"officeTel",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='handPhoneV2' mdef='핸드폰'/>",     Type:"Text",    Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"handPhone",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='mailIdV2' mdef='E-MAIL'/>",     Type:"Text",    Hidden:0,   Width:200,  Align:"Center", ColMerge:0, SaveName:"mailId",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			{Header:"<sht:txt mid='fileYnV1' mdef='등록여부'/>",   Type:"Text",    Hidden:1,   Width:100,  Align:"Center", ColMerge:0, SaveName:"fileYn",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"Pointer" },
			{Header:"<sht:txt mid='photoIndex' mdef='사진인덱스'/>", Type:"Text",    Hidden:1,   Width:170,  Align:"Center", ColMerge:0, SaveName:"photoIndex",  KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 },
			{Header:"<sht:txt mid='photoSrc' mdef='사진파일'/>",   Type:"Text",    Hidden:1,   Width:170,  Align:"Center", ColMerge:0, SaveName:"photoSrc",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:200 }


		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}"); sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);

		$("#searchRetSYmd").datepicker2({startdate:"searchRetEYmd"});
		$("#searchRetEYmd").datepicker2({enddate:"searchRetSYmd"});

		$("input[id='statusCd']").click(function(){
			if($(this).val() == "RA") {
				$("#hdnYmd").hide();
			} else {
				$("#hdnYmd").show();
			}
		});

		$("#searchJikchakChb").click(function() {
			doAction1("Search");
		});

		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});

		$("#searchPhotoYn").attr('checked', 'checked');

		$("#searchOrgNm,#searchName,#searchJikchakYn").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		/* 다운로드시 페이지 랜더링(화면에 올림)을 하기 위하여 자동 Row높이설정을 false로 준다. */
		sheet1.SetAutoRowHeight(0);
		sheet1.SetDataRowHeight(60);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			$("#searchJikchakChb").is(":checked") == true ? $("#searchJikchakYn").val("Y")  : $("#searchJikchakYn").val("N") ;

			sheet1.DoSearch( "${ctx}/NewEmpLst.do?cmd=getNewEmpLstList", $("#srchFrm").serialize() ); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			//var param  = {DownCols:downcol,SheetDesign:1,Merge:1,DownRows:"0|1|2"};
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
		break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if (Msg != "") {
				alert(Msg);
			}

			if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);

			}else{
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}

			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

</script>
</head>
<body class="hidden">
<div class="wrapper">
	<form id="srchFrm" name="srchFrm" >
	<div class="sheet_search outer">
		<div>
		<table>
			<tr>
				<th><tit:txt mid='104295' mdef='소속 '/></th>
				<td>   <input id="searchOrgNm" name="searchOrgNm" type="text" class="text" /> </td>
				<th><tit:txt mid='104450' mdef='성명 '/></th>
				<td>   <input id="searchName" name="searchName" type="text" class="text" /> </td>
				<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
				<td>  <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" /></td>
			 	<td> <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='114220' mdef='신규입사자 - 최근 3개월 내 입사자 명단'/></li>
							<li class="btn">
								<a href="javascript:doAction1('Down2Excel')" 	class="btn outline-gray authR hide"><tit:txt mid='download' mdef='다운로드'/></a>
							</li>
						</ul>
					</div>
				</div>
				<script type="text/javascript">createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
			</td>
		</tr>
	</table>
</div>
</body>
</html>
