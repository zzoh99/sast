<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='111905' mdef='인사기본(발령)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>

<script type="text/javascript">
	var searchUserId = '';
	var searchUserEnterCd = '';
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('psnalPostLayer');
		searchUserId = modal.parameters.userId || '';
		searchUserEnterCd = modal.parameters.userEnterCd || '';

		$("#hdnSabun").val(searchUserId);
		$("#hdnEnterCd").val(searchUserEnterCd);

		createIBSheet3(document.getElementById('psnalPostLayer-wrap'), "psnalPostLayer", "100%", "100%", "${ssnLocaleCd}");

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:11, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			//{Header:"<sht:txt mid='temp2' mdef='세부\n내역'/>",		Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },			
			{Header:"<sht:txt mid='enterCd_V6917' mdef='회사코드'/>",			Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='companyV1' mdef='회사'/>",				Type:"Text",	Hidden:1,	Width:130,	Align:"Center",	ColMerge:0,	SaveName:"enterNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='ordTypeNm' mdef='발령'/>",				Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='ordReasonCd' mdef='발령상세코드'/>",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='ordReasonNm' mdef='발령상세'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailNm",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='ordReasonCd' mdef='발령세부사유코드'/>",		Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='ordReasonCdV2' mdef='발령세부사유'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },			
			{Header:"<sht:txt mid='sabun' mdef='사번'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='ordYmd' mdef='발령일자'/>",		Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='applySeq' mdef='적용\n순서'/>",	Type:"Text",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 }
		]; 

		// 발령항목 조회
		var POST_ITEMS = ajaxCall("${ctx}/PsnalBasicInf.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;

		// 발령항목 SHEET에 PUSH
		for(var ind in POST_ITEMS){
			var postItem = POST_ITEMS[ind];
			
			// 조직장권한등록 예외처리
			if(convCamel(postItem.columnCd ) == "chiefYn") continue;			
			
			//sheet header init
			if(postItem.cType == "D") {
					initdata1.Cols.push({Header:postItem.postItemNm,	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.columnCd+"_" ),		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:postItem.limitLength});
			} else if (postItem.cType == "C" || postItem.cType == "P"){
				initdata1.Cols.push({Header:postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.nmColumnCd+"_"),		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:"200"});												
			}else{
				if(postItem.postItemNm =="비고"){
					initdata1.Cols.push({Header:postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName: convCamel(postItem.columnCd+"_"),		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:postItem.limitLength});
				}else{
					initdata1.Cols.push({Header:postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.columnCd+"_"),		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:postItem.limitLength});
					
				}
			}
		}

		IBS_InitSheet(psnalPostLayer, initdata1);
		psnalPostLayer.SetEditable("${editable}");
		psnalPostLayer.SetVisible(true);
		psnalPostLayer.SetCountPosition(4);

		let sheetHeight = $(".modal_body").height() - $(".sheet_title").height();
		psnalPostLayer.SetSheetHeight(sheetHeight);

		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			$("#btnSave").hide();
		} 

		$('input:checkbox[name="paYn"]').each(function(){
		    //this.checked = true;
		});
		
		doAction1("Search");

	});

	$(function() {
		psnalPostLayer.SetColHidden("applySeq", 1);
		psnalPostLayer.SetColHidden("resignReasonNm", 1);
		
//		psnalPostLayer.SetColHidden("jikgubNm", 1);
		psnalPostLayer.SetColHidden("jikgubYear", 1);

        $("#paYn,#mainYn").bind("change",function(event){
        	doAction1("Search");
		});
        
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()
						+"&searchUserEnterCd="+$("#hdnEnterCd").val()
						//+"&ordTypeCd="+$("#ordTypeCd").val()
						+"&mainYn="+($("#mainYn").is(":checked")==true?"Y":"")
						+"&paYn="+($("#paYn").is(":checked")==true?"Y":"")
						+"&searchPreSrchYn="+'${ssnPreSrchYn}';

			psnalPostLayer.DoSearch( "${ctx}/PsnalPost.do?cmd=getPsnalPostList", param );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(psnalPostLayer);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			psnalPostLayer.Down2Excel(param);
			break;
		}
	}

	// 조회 후 에러 메시지
	function psnalPostLayer_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 셀 클릭시 발생
	function psnalPostLayer_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {

			if(psnalPostLayer.ColSaveName(Col) == "processNo" && psnalPostLayer.GetCellValue(Row,"processNo") != "") {
		    	var applSabun = psnalPostLayer.GetCellValue(Row,"applSabun");
	    		var applSeq = psnalPostLayer.GetCellValue(Row,"processNo");
	    		var applInSabun = psnalPostLayer.GetCellValue(Row,"applSabun");
	    		var applYmd = psnalPostLayer.GetCellValue(Row,"applYmd");

// 	    		showApplPopup("R",applSeq,applSabun,applInSabun,applYmd);
			} 
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	function getReturnValue(returnValue) {
	}

</script>
</head>
<body class="bodywrap">

<div class="wrapper modal_layer">
	<div class="modal_body">
		<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
		<input id="hdnSabun" name="hdnSabun" type="hidden">
		<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
		<div class="inner">
			<div class="sheet_title">
				<ul>
					<li class="btn">
						<%--
                            <span><tit:txt mid='ordType' mdef='발령'/></span>
                            <span>
                                <select id="ordTypeCd" name="ordTypeCd">
                                </select>
                            </span>
                             --%>
						<input id="mainYn" name="mainYn" type="checkbox" class="checkbox" style="vertical-align:middle;" >
						<label for="mainYn">
							<tit:txt mid='keyOrdDetail' mdef='주요발령'/>
						</label>
						<span id="psnalCheckBox" class="hide">
					<span>
						<input id="paYn" name="paYn" type="checkbox" class="checkbox" style="vertical-align:middle;" checked>
					</span>
					<span>
						<tit:txt mid='202005180000022' mdef='그룹전체포함'/>
					</span>
				</span>
						<btn:a href="javascript:doAction1('Search');" css="basic authR" mid='search' mdef="조회"/>
						<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
					</li>
				</ul>
			</div>
		</div>
		<div id="psnalPostLayer-wrap"></div>
<%--		<script type="text/javascript"> createIBSheet("psnalPostLayer", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
	</div>

</div>
</body>
</html>
