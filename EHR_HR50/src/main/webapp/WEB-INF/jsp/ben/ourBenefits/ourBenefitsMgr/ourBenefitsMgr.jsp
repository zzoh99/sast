<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="hidden">
<head>
	<title>우리회사 복리후생 관리</title>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

	<script type="text/javascript">
		$(function() {

			//Sheet 초기화
			init_sheet1();
			$(window).smartresize(sheetResize); sheetInit();
			doAction1("Search");

			//직군구분코드 선택 시
			$("#searchBnftNm").on("keyup", function(e) {
				if (e.keyCode === 13)
					doAction1("Search");
			});

		});

		//Sheet 초기화
		function init_sheet1() {
			var kf = 1;
			var initdata1 = {};
			initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
			initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

<c:if test="${authPg == 'R' }">
			kf = 0;
</c:if>
			initdata1.Cols = [
				{Header:"No",					Type:"${sNoTy}",	Hidden:0,				Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
				{Header:"삭제",					Type:"${sDelTy}",	Hidden:"${sDelHdn}",	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
				{Header:"상태",					Type:"${sSttTy}",	Hidden:"${sSttHdn}",	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

				{Header:"복리후생코드",			Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"bnftCd",		KeyField:0,		UpdateEdit:0,	InsertEdit:0 },
				{Header:"복리후생명",				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"bnftNm",		KeyField:kf,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },

				{Header:"카테고리명",				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"categoryNm",	KeyField:0,		UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
				{Header:"순서",					Type:"Int",			Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,		UpdateEdit:1,	InsertEdit:1 },
				{Header:"사용여부",				Type:"CheckBox",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"useYn",		KeyField:0,		UpdateEdit:1,	InsertEdit:1,	TrueValue:"Y",	FalseValue:"N" },
				{Header:"아이콘",				Type:"Combo",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"icon",		KeyField:0,		UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
				{Header:"이동URL",				Type:"Text",		Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"redirectUrl",	KeyField:0,		UpdateEdit:0,	InsertEdit:0 },
				{Header:"비고",					Type:"Text",		Hidden:0,	Width:150,	Align:"Left",	ColMerge:0,	SaveName:"note",		KeyField:0,		UpdateEdit:1,	InsertEdit:1,	EditLen:1000 }
			];
			IBS_InitSheet(sheet1, initdata1);
			sheet1.SetEditable("${editable}");
			sheet1.SetVisible(true);
			sheet1.SetCountPosition(4);

			sheet1.SetColProperty("icon", {ComboText:"|welfase_01|welfase_02|welfase_03|welfase_04|welfase_05|welfase_06|welfase_07|welfase_08|welfase_09", ComboCode:"|welfase_01|welfase_02|welfase_03|welfase_04|welfase_05|welfase_06|welfase_07|welfase_08|welfase_09"} );

<c:if test="${authPg == 'R' }">
			sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
</c:if>
		}

		//Sheet1 Action
		function doAction1(sAction) {
			switch (sAction) {
				case "Search":
					sheet1.DoSearch( "${ctx}/OurBenefitsMgr.do?cmd=getOurBenefitsMgr", $("#sheet1Form").serialize() );
					break;
				case "Save":
					if(!dupChk(sheet1,"bnftNm", true, true)){break;}
					IBS_SaveName(document.sheet1Form,sheet1);
					sheet1.DoSave( "${ctx}/OurBenefitsMgr.do?cmd=saveOurBenefitsMgr", $("#sheet1Form").serialize());
					break;
				case "Insert":
					var row = sheet1.DataInsert(0);
					sheet1.SetCellValue(row, "useYn", "Y");
					break;
				case "Copy":
					sheet1.DataCopy();
					break;
				case "Down2Excel":
					var downcol = makeHiddenSkipCol(sheet1);
					var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
					sheet1.Down2Excel(param);
					break;
			}
		}


		//---------------------------------------------------------------------------------------------------------------
		// sheet1 Event
		//---------------------------------------------------------------------------------------------------------------

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

		// 저장 후 메시지
		function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
			try {
				if (Msg != "") {
					alert(Msg);
				}
				if( Code > -1 ) doAction1("Search");
			} catch (ex) {
				alert("OnSaveEnd Event Error " + ex);
			}
		}


	</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<form name="sheet1Form" id="sheet1Form" method="post">
			<div class="sheet_search outer">
				<table>
				<tr>
					<th>복리후생명</th>
					<td>
						<input type="text" id="searchBnftNm" name="searchBnftNm" class="text"/>
					</td>
					<td>
						<a href="javascript:doAction1('Search')" class="btn dark">조회</a>
					</td>
				</tr>
				</table>
			</div>
		</form>

		<div class="sheet_title inner">
			<ul>
				<li class="txt">우리회사 복리후생 관리</li>
				<li class="btn">
					<a href="javascript:doAction1('Down2Excel');" 	class="btn outline-gray authR">다운로드</a>
					<a href="javascript:doAction1('Copy')" 			class="btn outline-gray authA">복사</a>
					<a href="javascript:doAction1('Insert')" 		class="btn outline-gray authA">입력</a>
					<a href="javascript:doAction1('Save');" 		class="btn filled authA">저장</a>
				</li>
			</ul>
		</div>
		<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>

	</div>
</body>
</html>
