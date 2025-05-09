<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title>다면평가역량PopUp</title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
	var p = eval("${popUpStatus}");
	var authPg = "${authPg}";

	$(function() {
		// 조회조건 값 setting
		var arg = p.window.dialogArguments;
	    if( arg != undefined ) {
	    	$("#tdWEnterNm").html( arg["wEnterNm"] );
			$("#tdSabun").html( arg["empId"] );
			$("#tdSabunOrgNm").html( arg["sabunOrgNm"] );
			$("#tdName").html( arg["name"] );
			$("#tdSabunJikchakNm").html( arg["sabunJikchakNm"] );

			$("#searchWEnterCd").val( arg["wEnterCd"] );
			$("#searchCompAppraisalCd").val( arg["CompAppraisalCd"] );
			$("#searchEmpId").val( arg["empId"] );
			$("#searchAppEmpId").val( arg["appEmpId"] );
			$("#searchAppEnterCd").val( arg["appEnterCd"] );
			$("#searchLdsAppStatusCd").val( arg["ldsAppStatusCd"] );

	    }else{
	    	if(p.popDialogArgument("wEnterNm")!=null)		$("#tdWEnterNm").html(p.popDialogArgument("wEnterNm"));
	    	if(p.popDialogArgument("empId")!=null)			$("#tdSabun").html(p.popDialogArgument("empId"));
	    	if(p.popDialogArgument("sabunOrgNm")!=null)		$("#tdSabunOrgNm").html(p.popDialogArgument("sabunOrgNm"));
	    	if(p.popDialogArgument("name")!=null)			$("#tdName").html(p.popDialogArgument("name"));
	    	if(p.popDialogArgument("sabunJikchakNm")!=null)	$("#tdSabunJikchakNm").html(p.popDialogArgument("sabunJikchakNm"));

	    	if(p.popDialogArgument("CompAppraisalCd")!=null)	$("#searchCompAppraisalCd").val(p.popDialogArgument("CompAppraisalCd"));
	    	if(p.popDialogArgument("wEnterCd")!=null)			$("#searchWEnterCd").val(p.popDialogArgument("wEnterCd"));
	    	if(p.popDialogArgument("empId")!=null)				$("#searchEmpId").val(p.popDialogArgument("empId"));
	    	if(p.popDialogArgument("appEmpId")!=null)			$("#searchAppEmpId").val(p.popDialogArgument("appEmpId"));
	    	if(p.popDialogArgument("appEnterCd")!=null)			$("#searchAppEnterCd").val(p.popDialogArgument("appEnterCd"));
	    	if(p.popDialogArgument("ldsAppStatusCd")!=null)		$("#searchLdsAppStatusCd").val(p.popDialogArgument("ldsAppStatusCd"));
	    }
	    
		$(".close, #close").click(function() {
			if( $('#aComment').val() != $('#searchAComment').val() || $('#cComment').val() != $('#searchCComment').val() ){
				if(!confirm("입력한 내역이 있습니다. 창을 닫으시겠습니까?")) return;
			}

			p.self.close();
		});

		$("#aComment").maxbyte(2000);
		$("#cComment").maxbyte(2000);

		// 공통코드조회
// 		var appResultList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","L90010"), "");
		var appPointtList = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P90002"), "");
		var mainAppType 	= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","P00007"), "");	//역량구분


		// sheet init
		var initdata = {};
		initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:100,MergeSheet:msAll};
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

		]; IBS_InitSheet(sheet1, initdata);sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetUnicodeByte(3);

 		sheet1.SetColProperty("appResult",	{ComboText:appPointtList[0], ComboCode:appPointtList[1]} );
 		sheet1.SetColProperty("mainAppType", 			{ComboText:mainAppType[0], ComboCode:mainAppType[1]} );	//역량구분
 		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
 		sheet1.SetDataLinkMouse("ldsComment", 10);
 		
		$(window).smartresize(sheetResize); sheetInit();
		
	    //authPg가 R이면 모든 케이스 수정 불가능하게
	    if(authPg == "R"){
	    	$('#btnSave1, #btnSave2, #btnFinish').hide();
	    	$('#aComment, #cComment').addClass('readonly');
	    	$('#aComment, #cComment').attr('readonly', true);
	    	sheet1.SetEditable(0);
	    }

		// 조회
		doAction1("Search");
		doCommentSearch();
	});
</script>

<!-- sheet1 -->
<script type="text/javascript">
	/**
	 * Sheet 각종 처리
	 */
	function doAction1(sAction){
		switch(sAction){
			case "Search":		//조회
				sheet1.DoSearch( "${ctx}/CompAppraisal.do?cmd=getCompAppraisalPopList", $("#srchFrm").serialize() );
				break;

			case "Save":		//저장

				IBS_SaveName(document.srchFrm,sheet1);


				var saveStr = sheet1.GetSaveString(1);
				var saveStr2 =$("#srchFrm").serialize();

				if(saveStr == "KeyFieldError" || saveStr == ""){
					break;
				}


				var rtn = eval("("+sheet1.GetSaveData("${ctx}/CompAppraisal.do?cmd=saveCompAppraisalPop1",saveStr+"&"+saveStr2)+")");

				if(rtn.Result.Code < 1) {
					alert(rtn.Result.Message);
					break;
				}
				//doCommentSave();
				sheet1.LoadSaveData(rtn);
				
				var rv = new Array(1);
	    		rv["ldsAppStatusCd"] = "Y";

	    		p.popReturnValue(rv);
	    		p.window.close();
				

				break;

			case "Down2Excel":	//엑셀내려받기
				sheet1.Down2Excel({DownCols:makeHiddenSkipCol(sheet1),SheetDesign:1,Merge:1});
				break;

		}
	}

	//<!-- 조회 후 에러 메시지 -->
	function sheet1_OnSearchEnd(Code, ErrMsg, StCode, StMsg){
		try{
			if (ErrMsg != ""){
				alert(ErrMsg);
			}
			if ( sheet1.RowCount() > 0 ){
				sheet1.SelectCell(1, 'ldsCompetencyNm');
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
</script>

<!-- 진단완료, 하단 comment -->
<script type="text/javascript">
	//진단완료
	function doFinish(){
/*
		if ( sheet1.FindStatusRow("I|U|D") != "" ) {
			alert("입력 또는 수정중인 항목이 존재합니다. 저장 먼저 해주세요.");
			return;
		}
*/
		if ( sheet1.RowCount() > 0 ){
			var appResult = "";
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows(); i++){
				appResult = sheet1.GetCellValue(i, "appResult");
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
			    	
			    	//sheet1.SetEditable(0);
			    	sheet1.SetColEditable("appResult",0);
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
	function sheet1_OnClick(Row, Col, Value){
		try{
		    if (Row > 0 && sheet1.ColSaveName(Col) == "ldsComment") {
		    	if(!isPopup()) {return;}
		    	gPRow = "";
		    	pGubun = "viewCompAppraisalCommentPop";

				var authPg = "${authPg}";
				//if ( sheet1.GetCellValue(Row,"ldsAppStatusCd") == "Y" ) authPg = "R";
				
				var args = new Array();
				args["compAppraisalCd"] = sheet1.GetCellValue(Row,"compAppraisalCd");
				args["wEnterCd"] = sheet1.GetCellValue(Row,"wEnterCd");
				args["sabun"] = sheet1.GetCellValue(Row,"sabun");
				args["appSabun"] = sheet1.GetCellValue(Row,"appSabun");
				args["appEnterCd"] = sheet1.GetCellValue(Row,"appEnterCd");
				args["ldsCompetencyCd"] = sheet1.GetCellValue(Row,"ldsCompetencyCd");
				args["seq"] = sheet1.GetCellValue(Row,"seq");
				args["ldsCompetencyNm"] = sheet1.GetCellValue(Row,"ldsCompetencyNm");

				openPopup("${ctx}/CompAppraisal.do?cmd=viewCompAppraisalCommentPop&authPg="+ authPg,args,"740","400");

			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
</script>
</head>
<body class="bodywrap">
	<div class="wrapper">
		<div class="popup_title">
			<ul>
				<li>대상자 정보</li>
				<li class="close"></li>
			</ul>
		</div>

		<div class="popup_main">
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
		<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>


		<div class="outer">
			<div class="sheet_title">
				<ul>
					<li id="txt" class="txt">종합의견</li>
				</ul>
			</div>
			
		
			<table class="table">
			<tr>
				<td>
					<table class="table w100p">
						<tr>
							<td align="center"  style=" background-color: #bbdefb;"><span class="strong"><font color="blue">강점</font></span></td>
						</tr>
						<tr>
							<td >
								<textarea id="aComment" name="aComment" rows="6" class="w100p ${required}"></textarea>
								<input type="hidden" id="searchAComment" name="searchAComment" />
							</td>
						</tr>
					</table>
				</td>
				<td>
					<table class="table w100p">
						<tr>
							<td align="center" style=" background-color: #bbdefb;"><span class="strong"><font color="blue">개선점</font></span></td>
						</tr>
						<tr>
							<td >
								<textarea id="cComment" name="cComment" rows="6" class="w100p ${required}"></textarea>
								<input type="hidden" id="searchCComment" name="searchCComment" />
							</td>
						</tr>
					</table>
				</td>
			</tr>
			</table>
		</div>
		</form>

		<div class="popup_button outer">
		<ul>
			<li>
				<a href="javascript:doFinish()" id="btnSave1" class="blue large"><tit:txt mid='114380' mdef='저장'/></a>
				<a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
				<!-- <a href="javascript:doFinish()" id="btnFinish" class="blue large"><tit:txt mid='114380' mdef='평가완료'/></a> -->
			</li>
		</ul>
		</div>

	</div>
	
	
</div>
</body>
</html>
