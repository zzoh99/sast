<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script type="text/javascript">
var _layerPop_gubun = "";
//공통코드 팝업
function init_LayerPop(){
	
	if( $("#DIV_sheetPop").html().length > 0 ) {
		sheetPop.Reset();
	}else{

		$("#searchBaseDate").datepicker2({
			onReturn:function(date){
				doAction_LayerPop("Search");
			}
		});
		
		$("#searchText").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction_LayerPop("Search"); $(this).focus();
			}
		});
	}

	var initdata = {};
	initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
	initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
	initdata.Cols = [
		{Header:"<sht:txt mid='sNo' mdef='No' />",				Type:"${sNoTy}",	Hidden:0,  Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
		{Header:"<sht:txt mid='sDelete' mdef='삭제' />",			Type:"${sDelTy}",	Hidden:1,  Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
		{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empSabun", UpdateEdit:0 },
		{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",			Type:"Text",		Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"empName", UpdateEdit:0 },
		{Header:"<sht:txt mid='codeNm' mdef='코드명' />",			Type:"Text",      	Hidden:0,  Width:350,   		Align:"Left",  	ColMerge:0, SaveName:"codeNm", 	Cursor:"Pointer"},
		{Header:"<sht:txt mid='code' mdef='코드' />",				Type:"Text",  		Hidden:0,  Width:80,   			Align:"Center", ColMerge:0, SaveName:"code", 	Cursor:"Pointer"},
		{Header:"<sht:txt mid='orgNmV9' mdef='부서명' />",		Type:"Text",      	Hidden:1,  Width:150,   		Align:"Left",  	ColMerge:0, SaveName:"orgNm", 	Cursor:"Pointer"},
		{Header:"<sht:txt mid='orgCdV8' mdef='부서코드' />",		Type:"Text",      	Hidden:1,  Width:150,   		Align:"Left",  	ColMerge:0, SaveName:"orgCd", 	Cursor:"Pointer"},
		{Header:"<sht:txt mid='jikgubNm' mdef='직급' />",			Type:"Text",      	Hidden:1,  Width:100,   		Align:"Left",  	ColMerge:0, SaveName:"jikgubNm",Cursor:"Pointer"},
		{Header:"<sht:txt mid='jikgubCd' mdef='직급코드' />",		Type:"Text",      	Hidden:1,  Width:100,   		Align:"Left",  	ColMerge:0, SaveName:"jikgubCd",Cursor:"Pointer"} 
		
	]; IBS_InitSheet(sheetPop, initdata);sheetPop.SetVisible(true);sheetPop.SetEditable(0);
	sheetPop.SetEditableColorDiff(0); //편집불가 배경색 적용안함
	sheetPop.SetFocusAfterProcess(0);
	sheetPop.SetFocusAfterRowTransaction(0); 
}

function doAction_LayerPop(sAction) {
	switch (sAction) {
	case "Search":
		doAction_LayerPop(_layerPop_gubun);
		break;
	case "emp": //사원선택 팝업 조회
		if( $("#searchText").val() == "" ){
			alert('<msg:txt mid="109421" mdef="성명을 입력하세요" />');
			$("#searchText").focus();
			return;
		}
		var param = "searchKeyword="+$("#searchText").val()+"&searchEmpType=T";
		sheetPop.DoSearch( "${ctx}/Employee.do?cmd=employeeList", param );
		break;
		
	case "org": //조직선택 팝업 조회
		sheetPop.DoSearch( "${ctx}/Popup.do?cmd=getLayerOrgCodeList", $("#layerForm").serialize() );
		break;
		
	case "job"://직무선택 팝업 조회
		sheetPop.DoSearch( "${ctx}/Popup.do?cmd=getLayerJobCodeList", $("#layerForm").serialize() );
		break;
		
	case "SelectPop":
		var selRow = sheetPop.GetSelectRow();

		if( selRow == "" ) {
			alert('<msg:txt mid="L19080200065" mdef="선택 해주세요." />');
			return;
		}

		//var rv = new Array(2);
		//rv["code"] 		= sheetPop.GetCellValue(selRow, "code");
		//rv["codeNm"]	= sheetPop.GetCellValue(selRow, "codeNm");
		
		var rv= "\"sabun\":\""+sheetPop.GetCellValue(selRow, "empSabun")+"\""
		      + ",\"name\":\""+sheetPop.GetCellValue(selRow, "empName")+"\""
			  + ",\"code\":\""+sheetPop.GetCellValue(selRow, "code")+"\""
		      + ",\"codeNm\":\""+sheetPop.GetCellValue(selRow, "codeNm")+"\""
		      + ",\"orgCd\":\""+sheetPop.GetCellValue(selRow, "orgCd")+"\""
		      + ",\"orgNm\":\""+sheetPop.GetCellValue(selRow, "orgNm")+"\""
		      + ",\"jikgubCd\":\""+sheetPop.GetCellValue(selRow, "jikgubCd")+"\""
		      + ",\"jikgubNm\":\""+sheetPop.GetCellValue(selRow, "jikgubNm")+"\"";

		getReturnValue(rv);
		
		closeLayerPop();
		break;		
		
	}
}

//레이어팝업 호출
function openLayerPop(gubun, itop){
	_layerPop_gubun = gubun;
	init_LayerPop();
	var txt = "";
	var info = {TreeCol:0, LevelSaveName:"sLevel"};
	$("#searchBaseDate").removeAttr("readonly");
	
	switch(_layerPop_gubun){
	case "emp":
		info = {Width:100,Align:"Center"};
		sheetPop.SetColHidden("orgNm", 0);
		sheetPop.SetColHidden("jikgubNm", 0);
		txt = '<tit:txt mid="L19080200066" mdef="사원" />';
		break;
	case "org": 
		info = {TreeCol:1, LevelSaveName:"sLevel"};
		sheetPop.SetColProperty(0, "code" ,info);
		txt = '<tit:txt mid="orgNm" mdef="조직" />';
		break;
	case "job":
		sheetPop.SetColProperty(0, "code" ,info);
		txt = '<tit:txt mid="103973" mdef="직무" />';
		break;
	}

	$(".layer-pop").show();
	if(_layerPop_gubun == "emp"){
		sheetPop.SetColHidden("code", 1);
		sheetPop.SetColHidden("codeNm", 1);
		sheetPop.SetColHidden("orgNm", 0);
		sheetPop.SetColHidden("jikgubNm", 0);
		$("#title-pop").html(txt+'<tit:txt mid="111914" mdef="선택" />');
		$("#search-pop").html('<tit:txt mid="103880" mdef="성명" />');
	}else{
		sheetPop.SetColHidden("empSabun", 1);
		sheetPop.SetColHidden("empName", 1);
		sheetPop.SetColProperty(0, "codeNm" ,info);
		sheetPop.SetCellValue(0, "code", txt+'<tit:txt mid="114640" mdef="코드" />' );
		sheetPop.SetCellValue(0, "codeNm", txt+'<tit:txt mid="L19080200067" mdef="명" />' );
		$("#title-pop").html(txt+'<tit:txt mid="111914" mdef="선택" />');
		$("#search-pop").html(txt+'<tit:txt mid="L19080200067" mdef="명" />');
		doAction_LayerPop("Search");
	}
	if( itop != "undefined"){
		$(".layer-pop-body").css("top",itop);	
	}

	clearSheetSize(sheetPop);sheetInit();
	$("#searchText").focus();
	setTimeout(function(){$("#searchText").focus();}, 100);
}


//레이어팝업 닫기 
function closeLayerPop(){
	$(".layer-pop").hide();
	$("#searchText").val("");
	sheetPop.RemoveAll();
}
//--------------------------------------------------------------------------------
//  sheetPop 이벤트
//--------------------------------------------------------------------------------
// 조회 후 에러 메시지
function sheetPop_OnSearchEnd(Code, Msg, StCode, StMsg) {
	try {
		if (Msg != "") {
			alert(Msg);
		}
		sheetResize();
		setTimeout(function(){$("#searchText").focus();}, 100);
	} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
}

function sheetPop_OnDblClick(Row, Col, Value, CellX, CellY, CellW, CellH) {   
	try {
		doAction_LayerPop("SelectPop");
	} catch (ex) { alert("OnDblClick Event Error : " + ex); }
} 

</script>

<!-- 공통코드 팝업-->
<div class="layer-pop layer-pop-back"></div>
<div class="layer-pop layer-pop-body" style="top:88px; height:450px;">
	<div class="layer-pop-body-div" style="width:650px; height:430px;margin-left:-330px;"> 
	
		<div class="popup_title">
			<ul>
				<li id="title-pop"><tit:txt mid="111914" mdef="선택" /></li>
				<li class="close" onclick="closeLayerPop()"></li>
			</ul>
		</div>
		<div style="padding:10px 20px; background-color:#FFF; ">
			<form id="layerForm" name="layerForm">
			<div class="sheet_search sheet_search_s">
				<table>
				<tr>
					<th><tit:txt mid="103906" mdef="기준일자 " /></th>
					<td> 
						<input type="text" id="searchBaseDate" name="searchBaseDate" class="date2 w80" value="${curSysYyyyMMddHyphen}"/>
					</td>
					<th id="search-pop"></th>
					<td> 
						<input type="text" id="searchText" name="searchText" class="textCss w80" ${readonly}/>
					</td>
					<td>
						<a href="javascript:doAction_LayerPop('Search')" class="button " style="padding:10px;"><tit:txt mid="104081" mdef="조회" /></a>
					</td>
				</tr>
				</table>
			</div>
			</form>
			<div class="h10"></div>
			<script type="text/javascript"> createIBSheet("sheetPop", "100%", "220px"); </script> 
				
			<div class="popup_button">
				<ul>
					<li>
						<a href="javascript:doAction_LayerPop('SelectPop');" class="button" ><tit:txt mid="111914" mdef="선택" /></a>
						<a href="javascript:closeLayerPop();" class="gray" ><tit:txt mid="104157" mdef="닫기" /></a>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>
