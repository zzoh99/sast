<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='114503' mdef='근무지검색'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('locationCodeLayer');
		var arg = modal.parameters;
		createIBSheet3(document.getElementById('locationCodeLayerSht1-wrap'), "locationCodeLayerSht1", "100%", "100%", "${ssnLocaleCd}");

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:0};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",		Type:"Text",		Hidden:0,	Width:140,	Align:"Center",	ColMerge:0,	SaveName:"code",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='codeNm' mdef='코드명'/>",		Type:"Text",		Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"codeNm",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(locationCodeLayerSht1, initdata1);locationCodeLayerSht1.SetEditable(false);locationCodeLayerSht1.SetVisible(true);locationCodeLayerSht1.SetCountPosition(4);

		locationCodeLayerSht1.FocusAfterProcess = false;

		// sheet 높이 계산
		let sheetHeight = $(".modal_body").height() - $("#locationCodeLayerSht1Form").height() - $(".sheet_title").height() - 2;
		locationCodeLayerSht1.SetSheetHeight(sheetHeight);

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {
        $("#codeNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});
	});

	/*Sheet Action*/
	function doAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
		    locationCodeLayerSht1.DoSearch( "${ctx}/LocationCodePopup.do?cmd=getLocationCodePopupList", $("#locationCodeLayerSht1Form").serialize());
            break;
        case "Clear":        //Clear
            locationCodeLayerSht1.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기
            locationCodeLayerSht1.Down2Excel();
            break;
		}
    }

	// 조회 후 에러 메시지
	function locationCodeLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	// 더블클릭시 발생
	function locationCodeLayerSht1_OnDblClick(Row, Col){
		try{
			returnFindUser(Row,Col);
		}catch(ex){
			alert("OnDblClick Event Error : " + ex);
		}
	}

	function returnFindUser(Row,Col){

    	var returnValue = new Array(1);
 		returnValue["code"] = locationCodeLayerSht1.GetCellValue(Row,"code");
 		returnValue["codeNm"] = locationCodeLayerSht1.GetCellValue(Row,"codeNm");

		const modal = window.top.document.LayerModalUtility.getModal('locationCodeLayer');
		modal.fire('locationCodeLayerTrigger', returnValue).hide();
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="locationCodeLayerSht1Form" name="locationCodeLayerSht1Form" onsubmit="return false;">
				<input id="gubun" name="gubun" type="hidden" value="">
                <div class="sheet_search outer">
                    <div>
                    <table>
                    <tr>
						<th><tit:txt mid='112698' mdef='근무지명'/></th>
                        <td>
                        	<input id="codeNm" name ="codeNm" type="text" class="text" />
                        </td>
                        <td>
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a>
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
	                        <li id="txt" class="txt"><tit:txt mid='114136' mdef='근무지조회'/></li>
	                    </ul>
	                    </div>
	                </div>
					<div id="locationCodeLayerSht1-wrap"></div>
	                </td>
	            </tr>
			</table>
        </div>
		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('locationCodeLayer')" class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
		</div>
    </div>
</body>
</html>



