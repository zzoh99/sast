<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	$(function() {

		$("#searchRetSYmd").datepicker2({startdate:"searchRetEYmd"});
		$("#searchRetEYmd").datepicker2({enddate:"searchRetSYmd"});

		$("input[id='statusCd']").click(function(){
			// if($(this).val() == "RA") {
			//	$("#hdnYmd").hide();
			// } else {
			//	$("#hdnYmd").show();
			// }
			if($(this).val() == "RA") {
				$(".hdnYmd").hide();
			} else {
				$(".hdnYmd").show();
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

		doAction1("Search");
  		
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			
			$("#searchJikchakChb").is(":checked") == true ? $("#searchJikchakYn").val("Y")  : $("#searchJikchakYn").val("N") ;
			
			//sheet1 헤더 생성
			searchTitleList();

			sheet1.DoSearch( "${ctx}/EmergencyContact.do?cmd=getEmergencyContactList", $("#srchFrm").serialize() );
	  		
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			//var param  = {DownCols:downcol,SheetDesign:1,Merge:1,DownRows:"0|1|2"};
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
		break;
		}
	}
	
	function searchTitleList(){
		var param = "", cmd="";
		 
		cmd = "getEmergencyContacTitletList";
		param = "";
		
		var titleList = ajaxCall("${ctx}/EmergencyContact.do?cmd="+cmd, param, false);
		if (titleList != null && titleList.DATA != null) {
			sheet1.Reset();
			var initdata = {};
			initdata.Cfg = {SearchMode:smLazyLoad, Page:22, MergeSheet:msHeaderOnly, FrozenCol:7};
			initdata.HeaderMode = {Sort:0, ColMove:0, ColResize:1, HeaderCheck:0};
			initdata.Cols = [];
			var v = 0 ;
			
			initdata.Cols[v++] = {Header:"No|No",         Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
			initdata.Cols[v++] = {Header:"삭제|삭제",       Type:"${sDelTy}",   Hidden:1,                   Width:"${sDelWdt}", Align:"Center", ColMerge:0, SaveName:"sDelete", Sort:0 },
			initdata.Cols[v++] = {Header:"상태|상태",       Type:"${sSttTy}",   Hidden:1,                   Width:"${sSttWdt}", Align:"Center", ColMerge:0, SaveName:"sStatus", Sort:0 },
			initdata.Cols[v++] = {Header:"사진|사진",       Type:"Image",   Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"photo",       UpdateEdit:0, ImgWidth:50, ImgHeight:60 },
			initdata.Cols[v++] = {Header:"사번|사번",       Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"sabun",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			initdata.Cols[v++] = {Header:"성명|성명",       Type:"Text",    Hidden:0,   Width:60,   Align:"Center", ColMerge:0, SaveName:"name",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			initdata.Cols[v++] = {Header:"호칭|호칭",       Type:"Text",    Hidden:Number("${aliasHdn}"),   Width:70,   Align:"Center", ColMerge:0, SaveName:"alias",        KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			initdata.Cols[v++] = {Header:"소속|소속",       Type:"Text",    Hidden:0,   Width:100,  Align:"Center", ColMerge:0, SaveName:"orgNm",       KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			initdata.Cols[v++] = {Header:"재직상태|재직상태", Type:"Text",    Hidden:0,   Width:70,   Align:"Center", ColMerge:0, SaveName:"statusNm",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			initdata.Cols[v++] = {Header:"직책|직책",       Type:"Text",    Hidden:0,   Width:50,   Align:"Center", ColMerge:0, SaveName:"jikchakNm",   KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
			initdata.Cols[v++] = {Header:"직위|직위",       Type:"Text",    Hidden:Number("${jwHdn}"),   Width:50,  Align:"Center", ColMerge:0, SaveName:"jikweeNm",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
			initdata.Cols[v++] = {Header:"직급|직급",       Type:"Text",    Hidden:Number("${jgHdn}"),   Width:50,   Align:"Center", ColMerge:0, SaveName:"jikgubNm",    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }

			var title = "";
			var code = "";
			var widthSize = "";
			var text = "";
			var findStr = "";
			
			for(i = 0 ; i<titleList.DATA.length; i++) {
				
				title = titleList.DATA[i].codeNm;
				code = (titleList.DATA[i].code).toLowerCase();

				if(code == "im"){
					widthSize = "120";
				}else{
					widthSize = "60";
				}
				
				text = title;
				findStr = "비상연락망";
				var colText = title;
				if (text.indexOf(findStr) != -1) {
					if(colText != "비상연락망") {
						colText = title.replace(findStr, "");
						widthSize = "60";
					} else {
						widthSize = "120";
					}
				}

			
				if (text.indexOf(findStr) != -1) {
					initdata.Cols[v++] = {Header:"비상연락망"+"|"+ colText,       Type:"Text",    Hidden:0,   Width:widthSize,   Align:"Center", ColMerge:0, SaveName:code,    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100};
				}else {
					initdata.Cols[v++] = {Header:title+"|"+title,       Type:"Text",    Hidden:0,   Width:widthSize,   Align:"Center", ColMerge:0, SaveName:code,    KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100};
				}
		
			}
			
			initdata.Cols[v++] = {Header:"등록여부|등록여부",   Type:"Text",    Hidden:1,   Width:100,  Align:"Center", ColMerge:0, SaveName:"fileYn",      KeyField:0, Format:"",  PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, Cursor:"Pointer" }

			IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(0);sheet1.SetCountPosition(0);
			sheet1.SetEditableColorDiff(0); //편집불가 배경색 적용안함
	  		sheet1.SetFocusAfterProcess(0); //조회 후 포커스를 두지 않음

			$(window).smartresize(sheetResize);
	  		clearSheetSize(sheet1);sheetInit();
			
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
					<td>  <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
					<th class="hide"><tit:txt mid='113553' mdef='직책자 '/></th>
					<td class="hide">
						<input id="searchJikchakChb" name="searchJikchakChb" type="checkbox"  class="checkbox" />
						<input id="searchJikchakYn" name="searchJikchakYn" type="hidden" value="" />
					</td>
					<td>
						<input id="statusCd" name="statusCd" type="radio" value="RA" checked>퇴직자제외
						<input id="statusCd" name="statusCd"  type="radio" value="" >퇴직자포함
					</td>
				<th class="hdnYmd" style="display:none;"><tit:txt mid='113397' mdef='퇴직일자'/></th>
				<td class="hdnYmd" style="display:none;">
					<input id="searchRetSYmd" name="searchRetSYmd" type="text" class="date2" style="width:60px"> ~
					<input id="searchRetEYmd" name="searchRetEYmd" type="text" class="date2" style="width:60px">
				</td>
				<td>
				 <btn:a href="javascript:doAction1('Search')" id="btnSearch" css="btn dark" mid='110697' mdef="조회"/> </td>
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
							<li id="txt" class="txt"><tit:txt mid='emergencyContact' mdef='비상연락망'/></li>
							<li class="btn">
								<btn:a href="javascript:doAction1('Down2Excel')" 	css="btn outline-gray authR" mid='110698' mdef="다운로드"/>
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
