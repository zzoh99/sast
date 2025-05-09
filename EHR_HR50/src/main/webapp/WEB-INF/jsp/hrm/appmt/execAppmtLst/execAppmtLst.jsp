<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='111905' mdef='발령처리현황'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	//발령관련 변수
	var POST_ITEMS = {};
	var POST_ITEMS_CD = {};
	var POST_ITEMS_COL_CD = {};

	var gPRow = "";
	var pGubun = "";


	$(function() {
		// 발령항목
		var ordTypeCd 	= convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeCdManagerList&useYn=Y",false).codeList, "전체");	//발령종류
		$("#searchOrdTypeCd").html(ordTypeCd[2]);

		$("#searchOrdYmdFrom").datepicker2({startdate:"searchOrdYmdTo"});
		$("#searchOrdYmdTo").datepicker2({enddate:"searchOrdYmdFrom"});

		$("#searchSabun ,#searchOrdYmdFrom ,#searchOrdYmdTo").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

		$("#searchPhotoYn").click(function() {
			doAction1("Search");
		});

		$("#searchOrdYn").change(function(){
			doAction1("Search");
		});

		$("#searchOrdTypeCd").change(function(){
			$(this).bind("selected").val();

			var searchOrdTypeCd = $(this).val();

			var searchOrdDetailCd = "";
			var searchOrdReasonCd = "";

			if(searchOrdTypeCd != null){
				searchOrdDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdManagerList&useYn=Y&ordTypeCd="+searchOrdTypeCd ,false).codeList, "전체");
				searchOrdReasonCd  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList&note1="+searchOrdTypeCd, "H40110"), "전체");
			}
			$("#searchOrdDetailCd").html(searchOrdDetailCd[2]);
			$("#searchOrdReasonCd").html(searchOrdReasonCd[2]);
		});

		$("#popupProcessNo").click(function(){
			pGubun = "processNoMgr";
			showProcessPop();
			// openPopup("/Popup.do?cmd=viewAppmtProcessNoMgrPopup&authPg=R", "", "1000","600");
		});

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:16,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No|No'/>",						Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			//{Header:"<sht:txt mid='temp2' mdef='세부\n내역'/>",		Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='enterCd_V6917' mdef='회사코드'/>",	Type:"Text",	Hidden:1,	Width:0,	Align:"Center",	ColMerge:0,	SaveName:"enterCd",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='companyV1' mdef='회사|회사'/>",		Type:"Text",	Hidden:1,	Width:130,	Align:"Center",	ColMerge:0,	SaveName:"enterNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='ordYn' mdef='발령\n확정여부|발령\n확정여부'/>",	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='ordTypeCd' mdef='발령|발령'/>",			Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ordTypeNm' mdef='발령|발령'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ordDetailCd' mdef='발령상세|발령상세'/>",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='ordDetailNm' mdef='발령상세|발령상세'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='ordReasonCd' mdef='발령\n세부사유|발령\n세부사유'/>",	Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonCd",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10 },
			{Header:"<sht:txt mid='ordReasonNm' mdef='발령\n세부사유|발령\n세부사유'/>",	Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordReasonNm",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:100 },
			{Header:"<sht:txt mid='sabun' mdef='사번'/>",				Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun1",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='ordYmd' mdef='발령일|발령일'/>",		Type:"Date",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='applySeq' mdef='발령순번|발령순번'/>",Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='photo' mdef='대상자|사진'/>",						Type:"Image",		Hidden:0,  	MinWidth:55, Align:"Center", ColMerge:0,		SaveName:"photo",			UpdateEdit:0, ImgMinWidth:50, ImgHeight:60 },
			{Header:"<sht:txt mid='sabun' mdef='대상자|사번'/>",	    				Type:"Text",		Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='name' mdef='대상자|성명'/>",	    				Type:"Text",		Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 }

		];
		// 발령항목 조회
		var POST_ITEMS = ajaxCall("${ctx}/AppmtItemMapMgr.do?cmd=getAppmtItemMapMgrList","searchUseYn=Y",false).DATA;

		// 발령항목 SHEET에 PUSH
		for(var ind in POST_ITEMS){
			var postItem = POST_ITEMS[ind];

			// 조직장권한등록 예외처리
			if(convCamel(postItem.columnCd ) == "chiefYn") continue;

			//sheet header init
			if(postItem.cType == "D") {
				if (postItem.postItem != "ITEM24") {
					initdata1.Cols.push({Header:postItem.postItemNm+"|"+postItem.postItemNm,	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_") ,		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:postItem.limitLength});
//					initdata1.Cols.push({Header:postItem.postItemNm+"|"+postItem.postItemNm,	Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName: "item"+(postItem.num) ,		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:postItem.limitLength});
				}
			} else if (postItem.cType == "C" || postItem.cType == "P"){
				initdata1.Cols.push({Header:postItem.postItemNm+"|"+postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_"),		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:"200"});
//				initdata1.Cols.push({Header:postItem.postItemNm+"|"+postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:70,	Align:"Center",	ColMerge:0,	SaveName: "item"+(postItem.num),		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:"200"});
			}else{
				initdata1.Cols.push({Header:postItem.postItemNm+"|"+postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName: convCamel(postItem.postItem+"_"),		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:postItem.limitLength});
//				initdata1.Cols.push({Header:postItem.postItemNm+"|"+postItem.postItemNm,	Type:"Text",	Hidden:0,	Width:70,	Align:"Left",	ColMerge:0,	SaveName: "item"+(postItem.num),		KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:postItem.limitLength});
			}
		}
		IBS_InitSheet(sheet1, initdata1);
		 
		//sheet1.SetColProperty("ordYn", 		{ComboText:"미확정|확정", ComboCode:"N|Y"} );
		sheet1.SetEditable(false);
		sheet1.SetVisible(true);
		sheet1.SetCountPosition(4);

		$(window).smartresize(sheetResize); sheetInit();

		doAction1("Search");

	});

	$(function() {
		
		
		//sheet1.SetColHidden("item4", 1);
		//sheet1.SetColHidden("item20", 1);

        $("#paYn,#mainYn").bind("change",function(event){
        	doAction1("Search");
		});
     
	});

	//Sheet0 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			/*
			if($("#searchProcessNo").val() == "" ){
				alert("발령번호를 먼저 선택후 수행하세요.");
				return;
			}
			*/
			if($("#searchOrdYmdFrom").val() == "") {
				alert("발령일을 입력하여 주십시오.");
				$("#searchOrdYmdFrom").focus();
				return;
			}
			if($("#searchOrdYmdTo").val() == "") {
				alert("발령일을 입력하여 주십시오.");
				$("#searchOrdYmdTo").focus();
				return;
			}

			sheet1.DoSearch( "${ctx}/ExecAppmtLst.do?cmd=getExecAppmtLstList", $("#sendForm").serialize());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "ProcessClear":
			$("#searchProcessNo").val("");
			$("#searchProcessTitle").val("");
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

			if($("#searchPhotoYn").is(":checked") == true){
				sheet1.SetDataRowHeight(60);
				sheet1.SetColHidden("photo", 0);
			}else{
				sheet1.SetAutoRowHeight(0);
				sheet1.SetDataRowHeight(24);
				sheet1.SetColHidden("photo", 1);
			}

		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = returnValue;


		if(pGubun == "processNoMgr") {
	    	$("#searchProcessNo").val(rv.processNo);
	    	$("#searchProcessTitle").val(rv.processTitle);
	    	doAction1("Search");
	    }
	}


	// 발령번호 선택 팝업
	function showProcessPop() {
		if(!isPopup()) {return;}

		//openPopup("/Popup.do?cmd=viewAppmtProcessNoMgrPopup&authPg=R", "", "1000","600");
		let layerModal = new window.top.document.LayerModal({
			id : 'appmtConfirmLayer'
			, url : '/Popup.do?cmd=viewAppmtProcessNoMgrLayer&authPg=R'
			, parameters : ""
			, width : 1000
			, height : 600
			, title : '발령번호 검색'
			, trigger :[
				{
					name : 'appmtConfirmTrigger'
					, callback : function(result){
						getReturnValue(result);
					}
				}
			]
		});
		layerModal.show();
	}

</script>
</head>
<body class="bodywrap">

<div class="wrapper">
	<form id="sendForm" name="sendForm" >
		<input type="hidden" id="searchPageSize" name="searchPageSize"/>
		<input type="hidden" id="searchPage" name="searchPage"/>
		<input type="hidden" id="famNm" name="famNm" value=""/>
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th>발령일</th>
				<td>
					<input id="searchOrdYmdFrom" name="searchOrdYmdFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-30)%>"/> ~
					<input id="searchOrdYmdTo" name="searchOrdYmdTo" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),+30)%>"/>
				</td>
				<th>사번/성명</th>
				<td>
					<input id="searchSabun" name="searchSabun" type="text" class="text" />
				</td>
				<th>발령번호</th>
				<td>
					<input type="text" id="searchProcessNo" name="searchProcessNo" class="text" readonly />
					<a class='button6' id="popupProcessNo"><img src='/common/images/common/btn_search2.gif'/></a>
					<input type="text" id="searchProcessTitle" name="searchProcessTitle" class="text w150" readonly />
					<a onclick="javascript:doAction1('ProcessClear');" class="button7"><img src="/common/images/icon/icon_undo.png"></a>
				</td>
			</tr>
			<tr>
				<th>발령</th>
				<td>
					<select id="searchOrdTypeCd" name="searchOrdTypeCd"><option value=''>전체</option></select>
					<select id="searchOrdDetailCd" name="searchOrdDetailCd"><option value=''>전체</option></select>
					<!-- <select id="searchOrdReasonCd" name="searchOrdReasonCd"><option value=''>전체</option></select> -->
				</td>
				<th>확정여부</th>
				<td>
					<select id="searchOrdYn" name="searchOrdYn">
						<option value="">전체</option>
						<option value="Y">확정</option>
					    <option value="N" selected="selected">미확정</option>
					</select>
				</td>
				<th><tit:txt mid='112988' mdef='사진포함여부 '/></th>
				<td>
					 <input id="searchPhotoYn" name="searchPhotoYn" type="checkbox"  class="checkbox" />
				</td>
				<td>
					<a href="javascript:doAction1('Search');" class="button">조회</a>
				</td>
			</tr>
			</table>
			</div>
		</div>
	</form>
	<div class="outer">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='ordDetail' mdef='발령'/></li>
			<li class="btn">
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>
	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

</div>
</body>
</html>
