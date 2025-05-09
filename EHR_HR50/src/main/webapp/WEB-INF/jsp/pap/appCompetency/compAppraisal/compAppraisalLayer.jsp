<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>다면평가역량PopUp</title>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var authPg = "${authPg}";

	$(function() {
		createIBSheet3(document.getElementById('mysheet-wrap'), "compAppraisalLayerSheet", "100%", "100%", "${ssnLocaleCd}");
		// 조회조건 값 setting
		var modal = window.top.document.LayerModalUtility.getModal('compAppraisalLayer');
	    //if( arg != undefined ) {
	    	$("#tdWEnterNm").html( modal.parameters.wEnterNm );
			$("#tdSabun").html( modal.parameters.empId );
			$("#tdSabunOrgNm").html( modal.parameters.sabunOrgNm );
			$("#tdName").html( modal.parameters.name );
			$("#tdSabunJikchakNm").html( modal.parameters.sabunJikchakNm );

			$("#searchWEnterCd").val( modal.parameters.wEnterCd );
			$("#searchCompAppraisalCd").val( modal.parameters.CompAppraisalCd );
			$("#searchEmpId").val( modal.parameters.empId );
			$("#searchAppEmpId").val( modal.parameters.appEmpId );
			$("#searchAppEnterCd").val( modal.parameters.appEnterCd );
			$("#searchLdsAppStatusCd").val( modal.parameters.ldsAppStatusCd );

	    // }else{
	    // 	if(p.popDialogArgument("wEnterNm")!=null)		$("#tdWEnterNm").html(p.popDialogArgument("wEnterNm"));
	    // 	if(p.popDialogArgument("empId")!=null)			$("#tdSabun").html(p.popDialogArgument("empId"));
	    // 	if(p.popDialogArgument("sabunOrgNm")!=null)		$("#tdSabunOrgNm").html(p.popDialogArgument("sabunOrgNm"));
	    // 	if(p.popDialogArgument("name")!=null)			$("#tdName").html(p.popDialogArgument("name"));
	    // 	if(p.popDialogArgument("sabunJikchakNm")!=null)	$("#tdSabunJikchakNm").html(p.popDialogArgument("sabunJikchakNm"));
		//
	    // 	if(p.popDialogArgument("CompAppraisalCd")!=null)	$("#searchCompAppraisalCd").val(p.popDialogArgument("CompAppraisalCd"));
	    // 	if(p.popDialogArgument("wEnterCd")!=null)			$("#searchWEnterCd").val(p.popDialogArgument("wEnterCd"));
	    // 	if(p.popDialogArgument("empId")!=null)				$("#searchEmpId").val(p.popDialogArgument("empId"));
	    // 	if(p.popDialogArgument("appEmpId")!=null)			$("#searchAppEmpId").val(p.popDialogArgument("appEmpId"));
	    // 	if(p.popDialogArgument("appEnterCd")!=null)			$("#searchAppEnterCd").val(p.popDialogArgument("appEnterCd"));
	    // 	if(p.popDialogArgument("ldsAppStatusCd")!=null)		$("#searchLdsAppStatusCd").val(p.popDialogArgument("ldsAppStatusCd"));
	    // }
	    //

		$("#aComment").maxbyte(2000);
		$("#cComment").maxbyte(2000);

		// 공통코드조회
// 		var appResultList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L90010"), "");
		var appPointtList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P90002"), "");
		var mainAppType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");	//역량구분


		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:100,MergeSheet:msAll, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata.Cols = [

			//{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='appEnterCdV4' mdef='hidden'/>",	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV4' mdef='hidden'/>",	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:1,	SaveName:"ldsCompetencyCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV4' mdef='hidden'/>",	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"seq",				KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV4' mdef='hidden'/>",	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"wEnterCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV4' mdef='hidden'/>",	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"compAppraisalCd",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV4' mdef='hidden'/>",	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV4' mdef='hidden'/>",	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appEnterCd",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='appEnterCdV4' mdef='hidden'/>",	Type:"Text",	Hidden:1,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"appSabun",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			
			{Header:"주관식\n의견",										Type:"Image",	Hidden:1, Width:40,		Align:"Center",	ColMerge:1,	SaveName:"ldsComment",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10, Cursor:"Pointer"},
			{Header:"<sht:txt mid='comGubunCd' mdef='역량구분'/>",  		Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",    ColMerge:1,   SaveName:"mainAppType",     	KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
			{Header:"역량명",											Type:"Text",	Hidden:0,	  Width:100,	Align:"Center",	ColMerge:1,	SaveName:"ldsCompetencyNm",	KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, Wrap : 1, MultiLineText:1 },
			{Header:"<sht:txt mid='ldsCompBenmV2' mdef='문항'/>",		Type:"Text",	Hidden:0,	  Width:300,	Align:"Left",	ColMerge:0,	SaveName:"ldsCompBenm",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1000, Wrap : 1, MultiLineText:1 },
			{Header:"척도",										Type:"Combo",	Hidden:0,	  Width:70,		Align:"Center",	ColMerge:0,	SaveName:"appResult",		KeyField:0,	CalcLogic:"",	Format:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 }

		]; IBS_InitSheet(compAppraisalLayerSheet, initdata);compAppraisalLayerSheet.SetVisible(true);compAppraisalLayerSheet.SetCountPosition(4);compAppraisalLayerSheet.SetUnicodeByte(3);

 		compAppraisalLayerSheet.SetColProperty("appResult",	{ComboText:appPointtList[0], ComboCode:appPointtList[1]} );
 		compAppraisalLayerSheet.SetColProperty("mainAppType", 			{ComboText:mainAppType[0], ComboCode:mainAppType[1]} );	//역량구분
 		compAppraisalLayerSheet.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		compAppraisalLayerSheet.SetDataLinkMouse("ldsComment", 10);
 		
		$(window).smartresize(sheetResize); sheetInit();

		compAppraisalLayerSheet.SetSheetHeight("300");
	    //authPg가 R이면 모든 케이스 수정 불가능하게
	    if(authPg == "R"){
	    	$('#btnSave1, #btnSave2, #btnFinish').hide();
	    	$('#aComment, #cComment').addClass('readonly');
	    	$('#aComment, #cComment').attr('readonly', true);
	    	compAppraisalLayerSheet.SetEditable(0);
	    }

		// 조회
		doAction1("Search");
		doCommentSearch();
	});
</script>

<!-- compAppraisalLayerSheet -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				compAppraisalLayerSheet.DoSearch( "${ctx}/CompAppraisal.do?cmd=getCompAppraisalPopList", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장

				IBS_SaveName(document.srchFrm,compAppraisalLayerSheet);


				var saveStr = compAppraisalLayerSheet.GetSaveString(1);
				var saveStr2 =$("#srchFrm").serialize();

				if(saveStr == "KeyFieldError" || saveStr == ""){
					break;
				}


				var rtn = eval("("+compAppraisalLayerSheet.GetSaveData("${ctx}/CompAppraisal.do?cmd=saveCompAppraisalPop1",saveStr+"&"+saveStr2)+")");

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					break;
				}
				//doCommentSave();
				compAppraisalLayerSheet.LoadSaveData(rtn);
				
				var rv = new Array(1);
	    		rv["ldsAppStatusCd"] = "Y";

	    		returnValue();
	    		//p.popReturnValue(rv);
	    		//closeCommonLayer('compAppraisalLayer');
				

				break;

			case "Down2Excel":	//엑셀내려받기
				compAppraisalLayerSheet.Down2Excel({DownCols:makeHiddenSkipCol(compAppraisalLayerSheet),SheetDesign:1,Merge:1});
				break;

		}
	}

	//<!-- 조회 후 에러 메시지 -->
	function compAppraisalLayerSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			if ( compAppraisalLayerSheet.RowCount() > 0 ){
				compAppraisalLayerSheet.SelectCell(1, 'ldsCompetencyNm');
			}
			
			sheetResize();
		}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	//<!-- 저장 후 에러 메시지 -->
	function compAppraisalLayerSheet_OnSaveEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg) ;
			}
			if ( Code != "-1" ) doAction1("Search") ;

		}catch(ex){alert("OnSaveEnd Event Error : " + ex);}
	}
</script>

<!-- 진단완료, 하단 comment -->
<script type="text/javascript">
	//진단완료
	function doFinish(){
/*
		if ( compAppraisalLayerSheet.FindStatusRow("I|U|D") != "" ) {
			alert("입력 또는 수정중인 항목이 존재합니다. 저장 먼저 해주세요.");
			return;
		}
*/
		if ( compAppraisalLayerSheet.RowCount() > 0 ){
			var appResult = "";
			for(var i = compAppraisalLayerSheet.HeaderRows(); i < compAppraisalLayerSheet.RowCount()+compAppraisalLayerSheet.HeaderRows(); i++){
				appResult = compAppraisalLayerSheet.GetCellValue(i, "appResult");
				if(appResult == null || appResult == ''){
					//alert('평가되지않은 문항이 존재합니다.\n모든 문항을 평가한 후 평가완료 해주세요');
					alert('평가되지않은 문항이 존재합니다.\n모든 문항을 평가한 후 저장 해주세요');
					return;
				}
			}
		}

		//76,77 문항 체크
		/*
		if( $('#aComment').val().trim() == '' ){
			alert('[장점]을 입력하세요.');
			$('#aComment').focus();
			return;
		}
		
 		if( $('#cComment').val().trim() == '' ){
			alert('[개선점]을 입력하세요.');
			$('#cComment').focus();
			return;
		}
 		*/
/*
		if( $('#aComment').val() != $('#searchAComment').val() || $('#cComment').val() != $('#searchCComment').val()){
			alert("주관식의견을 저장 후 평가완료 해주세요");
			return;
		}
*/
/* 		if( $('#cComment').val() != $('#searchCComment').val() ){
			alert("[개선해야할 점]을 저장 후 평가완료 해주세요");
			return;
		} */

	    if( !confirm('저장 하시겠습니까?')){
			return;
		}
		
		doAction1('Save');
		
		/*
	    var data = ajaxCall("${ctx}/CompAppraisal.do?cmd=saveCompAppraisalPop3",$("#srchFrm").serialize(),false);
		if(data.Result.Code == -1) {
			alert(data.Result.Message);
    	} else {
    		alert("평가완료하였습니다.");

    		var rv = new Array(1);
    		rv["ldsAppStatusCd"] = "Y";

    		p.popReturnValue(rv);
    		p.window.close();
    	}+*/
	}

	// 하단조회
	function doCommentSearch(){
		try{
			$("#aComment").val("");	$("#searchAComment").val("");
			$("#cComment").val("");	$("#searchCComment").val("");
			
			var data = ajaxCall("${ctx}/CompAppraisal.do?cmd=getCompAppraisalPopMap",$("#srchFrm").serialize(),false);
			if(data != null && data.DATA != null) {
				
				$("#aComment").val(data.DATA.aComment);	$("#searchAComment").val(data.DATA.aComment);
				$("#cComment").val(data.DATA.cComment);	$("#searchCComment").val(data.DATA.cComment);
				
				var chkYn = data.DATA.ldsAppStatusCd
				if( chkYn == 'Y' ){
			    	$('#btnSave1, #btnSave2, #btnFinish').hide();
			    	$('#aComment, #cComment').addClass('readonly');
			    	$('#aComment, #cComment').attr('readonly', true);
			    	
			    	//compAppraisalLayerSheet.SetEditable(0);
			    	compAppraisalLayerSheet.SetColEditable("appResult",0);
				}
				
			}
		} catch (ex) {
			alert("getComment Error : " + ex);
		}
	}

	// 하단저장
	function doCommentSave(){

		if( $('#aComment').val() == '' ){
			alert('[장점]을 입력하세요.');
			$('#aComment').focus();
			return;
		}
 		if( $('#cComment').val() == '' ){
			alert('[개선점]을 입력하세요.');
			$('#cComment').focus();
			return;
		}

		var data = ajaxCall("${ctx}/CompAppraisal.do?cmd=saveCompAppraisalPop2",$("#srchFrm").serialize(),false);
		//alert(data.Result.Message);
		if(data.Result.Code > -1) {
    		doCommentSearch();
    	}
	}
	
	// 의견항목 클릭 시
	function compAppraisalLayerSheet_OnClick(Row, Col, Value){
		try{
		    if (Row > 0 && compAppraisalLayerSheet.ColSaveName(Col) == "ldsComment") {
		    	if(!isPopup()) {return;}
		    	gPRow = "";
		    	pGubun = "viewCompAppraisalCommentPop";

				var authPg = "${authPg}";
				//if ( compAppraisalLayerSheet.GetCellValue(Row,"ldsAppStatusCd") == "Y" ) authPg = "R";
				
				var args = new Array();
				args["compAppraisalCd"] = compAppraisalLayerSheet.GetCellValue(Row,"compAppraisalCd");
				args["wEnterCd"] = compAppraisalLayerSheet.GetCellValue(Row,"wEnterCd");
				args["sabun"] = compAppraisalLayerSheet.GetCellValue(Row,"sabun");
				args["appSabun"] = compAppraisalLayerSheet.GetCellValue(Row,"appSabun");
				args["appEnterCd"] = compAppraisalLayerSheet.GetCellValue(Row,"appEnterCd");
				args["ldsCompetencyCd"] = compAppraisalLayerSheet.GetCellValue(Row,"ldsCompetencyCd");
				args["seq"] = compAppraisalLayerSheet.GetCellValue(Row,"seq");
				args["ldsCompetencyNm"] = compAppraisalLayerSheet.GetCellValue(Row,"ldsCompetencyNm");

				openPopup("${ctx}/CompAppraisal.do?cmd=viewCompAppraisalCommentPop&authPg="+ authPg,args,"740","400");

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}

	function closeLayer(){
		if( $('#aComment').val() != $('#searchAComment').val() || $('#cComment').val() != $('#searchCComment').val() ){
			if(!confirm("입력한 내역이 있습니다. 창을 닫으시겠습니까?")) return;
		}

		closeCommonLayer('compAppraisalLayer');
	}
	
	function returnValue(){
		const modal = window.top.document.LayerModalUtility.getModal('compAppraisalLayer');
        modal.fire('compAppraisalLayerTrigger', {
        	ldsAppStatusCd : 'Y'
        }).hide();
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper modal_layer">

		<div class="modal_body">
			<form id="srchFrm" name="srchFrm">
				<input id="searchWEnterCd" 			name="searchWEnterCd" 		type="hidden" value="" />
				<input id="searchCompAppraisalCd" 	name="searchCompAppraisalCd"type="hidden" value="" />
				<input id="searchEmpId" 			name="searchEmpId" 			type="hidden" value="" />
				<input id="searchAppEnterCd" 		name="searchAppEnterCd" 	type="hidden" value="" />
				<input id="searchAppEmpId" 			name="searchAppEmpId" 		type="hidden" value="" />
				<input id="searchLdsAppStatusCd" 	name="searchLdsAppStatusCd" type="hidden" value="" />

				<div class="outer">
					<table class="table">
						<tbody>
							<colgroup>
								<col width="10%" />
								<col width="23%" />
								<col width="10%" />
								<col width="23%" />
								<col width="10%" />
								<col width="%" />
							</colgroup>
							<tr>
								<th align="center">회사</th><td id="tdWEnterNm"></td>
								<th align="center">성명</th><td id="tdName"></td>
								<th align="center">사번</th><td id="tdSabun"></td>
							</tr>
							<tr>
								<th align="center">소속</th><td id="tdSabunOrgNm"></td>
								<th align="center">직책</th><td colspan="3" id="tdSabunJikchakNm"></td>
							</tr>
						</tbody>
					</table>
				</div>

				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">다면평가</li>
						</ul>
					</div>
				</div>
				<div id="mysheet-wrap"></div>
<%--				<script type="text/javascript">createIBSheet("compAppraisalLayerSheet", "100%", "100%","${ssnLocaleCd}"); </script>--%>


				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt">종합의견</li>
						</ul>
					</div>
					<table class="table">
						<tr>
							<th class="text-center"><span class="strong">강점</span></th>
							<th class="text-center"><span class="strong">개선점</span></th>
						</tr>
						<tr>
							<td >
								<textarea id="aComment" name="aComment" rows="6" class="w100p ${required}"></textarea>
								<input type="hidden" id="searchAComment" name="searchAComment" />
							</td>
							<td >
								<textarea id="cComment" name="cComment" rows="6" class="w100p ${required}"></textarea>
								<input type="hidden" id="searchCComment" name="searchCComment" />
							</td>
						</tr>
					</table>
				</div>
			</form>

		</div>
		<div class="modal_footer">
			<a href="javascript:doFinish()" id="btnSave1" class="btn filled"><tit:txt mid='114380' mdef='저장'/></a>
			<a href="javascript:closeLayer();" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
	</div>
</body>
</html>
