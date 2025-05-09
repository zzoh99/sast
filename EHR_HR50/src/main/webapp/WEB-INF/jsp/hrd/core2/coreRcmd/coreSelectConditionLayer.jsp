<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<% request.setCharacterEncoding("utf-8"); %>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>

<script type="text/javascript">
	var openerCodeList = "" ;
	/*Sheet 기본 설정 */
	$(function() {
		createIBSheet3(document.getElementById('selectConditionLayerSheet-wrap'), "selectConditionLayerSheet", "100%", "100%", "${ssnLocaleCd}");
		var sTitle = "";
		var sShtTitle = "";
		var sHeader = "";
		var sGrpCd = "";
		var codeList = "";

		const modal = window.top.document.LayerModalUtility.getModal('selectConditionLayer');
		var {sTitle, sShtTitle, sHeader, sGrpCd, codeList} = modal.parameters;

		$('#modal-selectConditionLayer').find('div.layer-modal-header span.layer-modal-title').text(sTitle);
		$("#sheetTitle").html(sShtTitle) ;
		$("#searchGrpCd").val(sGrpCd) ;

		/*코드리스트 세팅*/
		openerCodeList = codeList.replace(/'/g, "") ;

		// 직무일때만 트리형태
		var treeCol = 0;
		if ( sGrpCd == "H10060" ) {
			treeCol = 1;

			// 트리레벨 정의
			$("#btnPlus").click(function() {
				selectConditionLayerSheet.ShowTreeLevel(-1);
			});
			$("#btnStep1").click(function()	{
				selectConditionLayerSheet.ShowTreeLevel(0, 1);
			});
			$("#btnStep2").click(function()	{
				selectConditionLayerSheet.ShowTreeLevel(1,2);
			});
			$("#btnStep3").click(function()	{
				selectConditionLayerSheet.ShowTreeLevel(2, 3);
			});
		} else {
			treeCol = 0;
			$(".util").hide();
		}

		//배열 선언
		var initdata = {};
		//SetConfig
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:4, DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		//HeaderMode
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",			Type:"${sDelTy}",	Hidden:1,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete" },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",			Type:"${sSttTy}",	Hidden:1,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus" },
			{Header:"<sht:txt mid='check' mdef='선택'/>",			Type:"DummyCheck",	Hidden:0,	Width:40,			Align:"Center",	ColMerge:0,	SaveName:"dummyCheck" },
 			{Header:sHeader,		Type:"Text",		Hidden:0,	Width:120,			Align:"Left",	ColMerge:0,	SaveName:"codeNm", UpdateEdit:0 ,	TreeCol:treeCol,  LevelSaveName:"sLevel" },
			{Header:"code",			Type:"Text",		Hidden:1,	Width:0,			Align:"Center",	ColMerge:0,	SaveName:"code", UpdateEdit:0 }
		];
		IBS_InitSheet(selectConditionLayerSheet, initdata); selectConditionLayerSheet.SetCountPosition(4);selectConditionLayerSheet.SetEditableColorDiff (0);

		var sheetHeight = $(".modal_body").height() - $(".sheet_title").height();
		selectConditionLayerSheet.SetSheetHeight(sheetHeight);

		//검색어 있을경우 검색
		if($("#searchGrpCd").val() != ""){
			doAction("Search");
		}
	});

	/*Sheet Action*/
	function doAction(sAction) {
		switch (sAction) {
			case "Search": //조회
			    selectConditionLayerSheet.DoSearch( "${ctx}/CoreRcmd.do?cmd=getCoreRcmdLayerList", $("#mySheetForm").serialize() );
	            break;
		}
    }

	// 	조회 후 에러 메시지
	function selectConditionLayerSheet_OnSearchEnd(Code, ErrMsg, StCode, StMsg) {
		try{
			selectConditionLayerSheet.ShowTreeLevel(-1);

			setCodeList( openerCodeList ) ;
	  	}catch(ex){alert("OnSearchEnd Event Error : " + ex);}
	}

	function selectConditionLayerSheet_OnResize(lWidth, lHeight) {
		try {
		} catch (ex) {
			alert("OnResize Event Error : " + ex);
		}
	}
	function selectConditionLayerSheet_OnDblClick(Row, Col){
		try{
			selectConditionLayerSheet.GetCellValue(Row, "dummyCheck") == "1" ? selectConditionLayerSheet.SetCellValue(Row, "dummyCheck", "0") : selectConditionLayerSheet.SetCellValue(Row, "dummyCheck", "1");
		}catch(ex){alert("OnDblClick Event Error : " + ex);}
	}

	function setValue(){
    	var returnValue = new Array(26);
		var codeStr = "" ;
		var codeNmStr = "" ;
    	for(var i = 1; i < selectConditionLayerSheet.LastRow()+1; i++) {
    		if( selectConditionLayerSheet.GetCellValue(i, "dummyCheck") == "1" ) {
	   			codeNmStr = codeNmStr + selectConditionLayerSheet.GetCellValue(i, "codeNm") + ",";
	   			codeStr = codeStr + selectConditionLayerSheet.GetCellValue(i, "code") + ",";
    		}
    	}
    	codeNmStr = codeNmStr.substr(0, codeNmStr.length-1)  ;
    	codeStr = codeStr.substr(0, codeStr.length-1)  ;

		const modal = window.top.document.LayerModalUtility.getModal('selectConditionLayer');
		modal.fire('selectConditionLayerTrigger', {
			code : codeStr,
			codeNm : codeNmStr
		}).hide();
	}

	function setCodeList(codeList) {
		codeList = codeList.split(",") ;
		for(var i = 0; i < codeList.length; i++) {
			selectConditionLayerSheet.SetCellValue(selectConditionLayerSheet.FindText("code", codeList[i]), "dummyCheck", 1) ;
		}
	}
</script>

    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="mySheetForm" name="mySheetForm">
                <input type="hidden" id="searchGrpCd" name="searchGrpCd" value=""/> 
	        </form>

				<div class="inner">
					<div class="sheet_title">
						<ul>
							<li id="txt" class="txt"><span id="sheetTitle"></span>
								<div class="util">
									<ul>
										<li	id="btnPlus"></li>
										<li	id="btnStep1"></li>
										<li	id="btnStep2"></li>
										<li	id="btnStep3"></li>
									</ul>
								</div>
							</li>
						</ul>
					</div>
				</div>
				<%--			<script type="text/javascript">createIBSheet("selectConditionLayerSheet", "100%", "100%","${ssnLocaleCd}"); </script>--%>
				<div id="selectConditionLayerSheet-wrap"></div>

        </div>
		<div class="modal_footer">
			<a href="javascript:setValue();" class="pink large"><tit:txt mid='104435' mdef='확인'/></a>
			<a href="javascript:closeCommonLayer('selectConditionLayer');" class="gray large">닫기</a>
		</div>
    </div>
