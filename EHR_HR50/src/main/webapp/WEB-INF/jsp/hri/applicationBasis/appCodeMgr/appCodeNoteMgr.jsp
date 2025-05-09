<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head><title>유의사항관리</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";

	$(function() {
	    var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, Page:22, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [
		    //수정시 줄좀 맞춥시다..
			{Header:"<sht:txt mid='sNo'           mdef='No'/>",				Type:"${sNoTy}",  	Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", SaveName:"sNo" },
			{Header:"<sht:txt mid='statusCd'      mdef='상태'/>",			Type:"${sSttTy}", 	Hidden:0,  Width:"${sSttWdt}", Align:"Center", SaveName:"sStatus" },
			{Header:"<sht:txt mid='bizCdV1'       mdef='업무구분코드'/>",		Type:"Combo",		Hidden:0,  Width:80,   Align:"Center", SaveName:"bizCd",   KeyField:0, Edit:0 },
			{Header:"<sht:txt mid='applCd_V3737'  mdef='신청서코드'/>",		Type:"Text",		Hidden:0,  Width:80,   Align:"Center", SaveName:"applCd",  KeyField:0, Edit:0 },
			{Header:"<sht:txt mid='applNm'        mdef='신청서명'/>",			Type:"Text",		Hidden:0,  Width:150,  Align:"Center", SaveName:"applNm",  KeyField:0, Edit:0 },
			
			{Header:"<sht:txt mid='etcNoteYn'     mdef='유의사항\n필요여부'/>",	Type:"CheckBox",	Hidden:0,  Width:60,   Align:"Center", SaveName:"etcNoteYn",  UpdateEdit:1,   InsertEdit:0, TrueValue:"Y", FalseValue:"N"},
			{Header:"<sht:txt mid='etcNote2'      mdef='유의사항\n등록'/>",	Type:"Image",		Hidden:0,  Width:60,   Align:"Center", SaveName:"etcNote2",   Cursor:"Pointer"},

			{Header:"fileSeq",		Type:"Text", Hidden:1,  Width:50,   Align:"Center", SaveName:"fileSeq" },
			{Header:"etcNote",		Type:"Text", Hidden:1,  Width:50,   Align:"Center", SaveName:"etcNote" },
			{Header:"etcNoteEng",	Type:"Text", Hidden:1,  Width:50,   Align:"Center", SaveName:"etcNoteEng" },
			{Header:"etcNoteChn",	Type:"Text", Hidden:1,  Width:50,   Align:"Center", SaveName:"etcNoteChn" }
		]; IBS_InitSheet(sheet1, initdata); sheet1.SetEditable(true);sheet1.SetCountPosition(4);sheet1.SetVisible(true);
		
	    sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_write.png");
	    sheet1.SetDataLinkMouse("etcNote2",1);

	    var grCobmboList 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10020"), "<tit:txt mid='103895' mdef='전체' />",-1);
	    sheet1.SetColProperty("bizCd", 		{ComboText:grCobmboList[0], 	ComboCode:grCobmboList[1]} );
	    $("#searchBizCd").html(grCobmboList[2]);
	    
		$("#appCd, #appCdNm").bind("keyup",function(event){
			if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
		});

		$("#searchBizCd").bind("change",function(){
			doAction1("Search");
		});
		$(window).smartresize(sheetResize); sheetInit();
		
		var sh = sheet1.GetSheetHeight()-293;
		$("#contents").height(sh);
		doAction1("Search");
	});
	
	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":  
			sheet1.DoSearch( "${ctx}/AppCodeMgr.do?cmd=getAppCodeMgrList", $("#sheet1Form").serialize()); 
			break;
		case "Save":
			sheet1.SetCellValue(gPRow,"etcNote",    $("#contents").val());
			sheet1.SetCellValue(gPRow,"etcNoteEng", $("#contentsEng").val());
			sheet1.SetCellValue(gPRow,"fileSeq",    $("#uploadForm>#fileSeq").val());
			
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave("${ctx}/AppCodeMgr.do?cmd=saveAppCodeNoteMgr", $("#sheet1Form").serialize() );
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
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
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
	
	function sheet1_OnClick(Row, Col, Value) {
		try{
		    
	  	}catch(ex){alert("OnClick Event Error : " + ex);}
	}
	
	function sheet1_OnSelectCell(OldRow, OldCol, NewRow, NewCol,isDelete){
		try {
			//log.debug($(".sheet_right > #contents").length);
			gPRow = NewRow;
			$("#contents").val(sheet1.GetCellValue(NewRow,"etcNote"));
			$("#contentsEng").val(sheet1.GetCellValue(NewRow,"etcNoteEng"));
			
			var fileSeq = sheet1.GetCellValue(NewRow,"fileSeq");
			
			// fileSeq 값이 없는 경우 신규 발급받아 업로드폼 세팅함.
			if( !fileSeq || fileSeq == null || fileSeq == "" ) {
				// fileSeq 신규값 조회
				var seqData = ajaxCall("${ctx}/fileuploadJFileUpload.do?cmd=getFileSeq", "", false);
				if( seqData && seqData != null && seqData.data && seqData.data != null ) {
					fileSeq = seqData.data;
					sheet1.SetCellValue(NewRow, "fileSeq", fileSeq);
					sheet1.SetCellValue(NewRow, "sStatus", "R");
					var saveData = ajaxCall("${ctx}/AppCodeMgr.do?cmd=saveAppAttFile", $.param({
						"searchApplCd" : sheet1.GetCellValue(NewRow, "applCd"),
						"fileSeq"      : fileSeq
					}),false);
					if(saveData != null && saveData.Result != null && saveData.Result.Code < 1) {
						alert(data.Result.Message);
					}
				} else {
					alert("첨부파일 업로드 양식 설정 중 오류가 발생하였습니다.\n관리자에 문의하시기 바랍니다.");
					fileSeq = "";
				}
			}
			
			if( fileSeq && fileSeq != null && fileSeq != "" ) {
				$("#fileDiv").show();
				$("#fileSeq").val(fileSeq);
				//파일 초기화
				doIBUAction("removeall");
				upLoadInit(fileSeq,"");
			} else {
				$("#fileDiv").hide();
			}
		} catch (ex) { alert("OnSelectCell Event Error : " + ex); }
	}
	
	function filePopup(){
		if(!isPopup()) {return;}

		var param = [];
		param["fileSeq"] = $("#fileSeq").val();

		var authPgTemp="A";
		pGubun = "filePopup";

		openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg="+authPgTemp, param, "740","620");
	}

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "filePopup") {
			$("#fileSeq").val(rv["fileSeq"]);
			sheet1.SetCellValue(gPRow,"fileSeq",    $("#fileSeq").val());	
		}
	}
	function getFileUploadEnd(){
		sheet1.SetCellValue(gPRow,"fileSeq",    $("#uploadForm>#fileSeq").val());
	}


</script>
<style type="text/css">
textarea { padding:5px; line-height:22px;}
</style>
</head>
<body class="bodywrap">
<div class="wrapper">
	<form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="srchUseYn" name="srchUseYn" value="Y" />
	<input type="hidden" id="fileSeq" name="fileSeq"/>
	<!-- 조회조건 -->
	<div class="sheet_search outer">
		<table>
		<tr>
			<th><tit:txt mid='114394' mdef='업무구분' /></th>
			<td>
				<select id="searchBizCd" name="searchBizCd"></select>
			</td>
			<th><tit:txt mid='114633' mdef='신청서코드'/></th>
			<td>
				<input id="appCd" name ="appCd" type="text" class="text"/>
			</td>
			<th><tit:txt mid='114237' mdef='신청서코드명'/></th>
			<td>
				<input id="appCdNm" name ="appCdNm" type="text" class="text"/>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search')" mid="search" mdef="조회" css="btn dark"/>
			</td>
		</tr>
		</table>
	</div>
	</form>
	
	<table class="sheet_main">
	<colgroup>
		<col width="" />
		<col width="30px" />
		<col width="700px" />
	</colgroup>
	<tr>
		<td>
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li id="txt" class="txt"><tit:txt mid="L190828000043" mdef="유의사항관리" /></li> 
						<li class="btn">
							<btn:a href="javascript:doAction1('Save');" 	css="btn filled authA" mid='save'      mdef="저장"/>
						</li>
					</ul>
				</div>
			</div>
			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
		</td>
		<td class="sheet_right"><div style="padding-top:200px;" class="setBtn"><img src="/common/images/sub/ico_arrow.png"/></div></td>
		<td class="sheet_right" style="padding:0 10px 0 5px;">
			<table class="sheet_main">
			<tr>
				<td>
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='112983' mdef='한글'/></li> 
							<li class="btn">
								<!-- btn:a href="javascript:filePopup();"           css="basic authA" mid='btnFileV1' mdef="파일첨부"/ -->
								<btn:a href="javascript:doAction1('Save');" 	css="btn filled authA" mid='save'      mdef="저장"/>
							</li>
						</ul>
					</div>
				</td>
			</tr>
			<tr>
				<td>
					<textarea id="contents" name="contents" class="text required w100p" rows="10"></textarea>
				</td>
			</tr>
			<tr class="hide">
				<td>
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><tit:txt mid='113341' mdef='영문'/></li>
							<li class="btn">&nbsp;</li>
						</ul>
					</div>
					<textarea id="contentsEng" name="contentsEng" class="text required w100p" rows="10"></textarea>
				</td>
			</tr>
			<tr>
				<td>
					<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>
				</td>
			</tr>
			</table>		
		</td>
	</tr>
	</table>

</div>
</body>
</html>



