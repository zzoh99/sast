<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title>근무지검색</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">

	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('appmtSaveErrorLayer');
		arg = modal.parameters;

		createIBSheet3(document.getElementById('appmtSaveErrorLayerSht1-wrap'), "appmtSaveErrorLayerSht1", "100%", "100%","${ssnLocaleCd}");
		
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
		initdata1.Cols = [
			{Header:"No",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"20",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },		     			

			{Header:"발령",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordTypeCd",		KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령상세",	Type:"Combo",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailCd",		KeyField:0,	Format:"",			CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령일",		Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"ordYmd",			KeyField:0,	Format:"Ymd",		CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"발령순번",	Type:"Text",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"applySeq",		KeyField:0,	Format:"Number",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },

			{Header:"사번",		Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13 },
			{Header:"성명",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"name",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:50 },

			{Header:"발령번호",	Type:"Text",	Hidden:0,	Width:60,	Align:"Left",	ColMerge:0,	SaveName:"dupProcessNo",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"발령제목",	Type:"Text",	Hidden:0,	Width:100,	Align:"Left",	ColMerge:0,	SaveName:"dupProcessTitle",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"발령\n확정",	Type:"Text",	Hidden:0,	Width:30,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 , TrueValue:"Y", FalseValue:"N"},
			{Header:"에러메시지",	Type:"Text",	Hidden:0,	Width:250,	Align:"Left",	ColMerge:0,	SaveName:"ordError",			KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:2000, ToolTip:1}
		]; IBS_InitSheet(appmtSaveErrorLayerSht1, initdata1);appmtSaveErrorLayerSht1.SetEditable(false);appmtSaveErrorLayerSht1.SetVisible(true);appmtSaveErrorLayerSht1.SetCountPosition(4);

		appmtSaveErrorLayerSht1.FocusAfterProcess = false;

		var userCd1 = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdTypeCdManagerList",false).codeList, "전체");	//발령종류
		appmtSaveErrorLayerSht1.SetColProperty("ordTypeCd", 		{ComboText:"|"+userCd1[0], ComboCode:"|"+userCd1[1]} );
		$("#searchOrdTypeCd").html(userCd1[2]);//검색조건의 발령
		
		$(window).smartresize(sheetResize); sheetInit();
		
		//opener 의 argument	
		if(arg["errorList"]){
			$("#appmtSaveErrorLayerSht1Form").hide();
			//에러목록을 직접 받아서 뿌려주는경우 
			const errorList = $.parseJSON(unescapeXss(arg["errorList"]));
			
			for(var ind in errorList){
				var row = appmtSaveErrorLayerSht1.DataInsert(-1);
				for(var colInd in initdata1.Cols){
					var colName = initdata1.Cols[colInd].SaveName;
					if(errorList[ind][colName]){
						if(colName=="ordYn" || colName=="sNo")continue;
						appmtSaveErrorLayerSht1.SetCellValue(row, colName, errorList[ind][colName]);
					}
				}
			}
		}else{
			$("#appmtSaveErrorLayerSht1Form").show();
			// 에러목록을 db에서 조회하는 경우 
			for(var key in arg){
				if($("#"+key,$("#appmtSaveErrorLayerSht1Form"))){
					$("#"+key,$("#appmtSaveErrorLayerSht1Form")).val(arg[key]);
				}
			}
			$("#searchErrorYn",$("#appmtSaveErrorLayerSht1Form")).val("Y");
			doAppmtSaveErrorLayerAction1("Search");
		}
	});

	$(function() {
		$("#searchSabun").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAppmtSaveErrorLayerAction1("Search");
			}
		});

		$("#searchOrdYmdFrom").datepicker2({startdate:"searchOrdYmdTo"});
		$("#searchOrdYmdTo").datepicker2({enddate:"searchOrdYmdFrom"});

		$("#popupProcessNo").click(function(){
			pGubun = "processNoMgr";
			showProcessPop();
		});

        $(".close").click(function() {
			closeCommonLayer('appmtSaveErrorLayer');
	    });
	});

	/*Sheet Action*/
	function doAppmtSaveErrorLayerAction1(sAction) {
		switch (sAction) {
		case "Search": //조회
			appmtSaveErrorLayerSht1.DoSearch( "${ctx}/ExecAppmt.do?cmd=getExecAppmtList2",$("#appmtSaveErrorLayerSht1Form").serialize());
            break;
        case "Clear":        //Clear
            appmtSaveErrorLayerSht1.RemoveAll();
            break;
        case "Down2Excel":  //엑셀내려받기
            appmtSaveErrorLayerSht1.Down2Excel();
            break;
		}
    }

	// 조회 후 에러 메시지
	function appmtSaveErrorLayerSht1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try{
			if(Msg != "") alert(Msg);
			sheetResize();
	  	}catch(ex){
	  		alert("OnSearchEnd Event Error : " + ex);
	  	}
	}

	// 더블클릭시 발생
	function appmtSaveErrorLayerSht1_OnDblClick(Row, Col){
		try{
			
		}catch(ex){
			alert("OnDblClick Event Error : " + ex);
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

	//popup return
	function getReturnValue(rv) {
		
		if(pGubun == "processNoMgr") {
	    	$("#searchProcessNo").val(rv.processNo);
	    	$("#searchProcessTitle").val(rv.processTitle);
	    	doAppmtSaveErrorLayerAction1("Search");
	    }

	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="appmtSaveErrorLayerSht1Form" name="appmtSaveErrorLayerSht1Form" onsubmit="return false;" style="display:none;">
            	<input type="hidden" id="searchErrorYn" name="searchErrorYn"/>
                <div class="sheet_search outer">
                    <div>
                    <table>
						<tr>
							<th>발령번호</th>
							<td>
								<input type="text" id="searchProcessNo" name="searchProcessNo" class="text readonly" readonly />
								<a class='button6'><img id="popupProcessNo"src='/common/images/common/btn_search2.gif'/></a>
								<input type="text" id="searchProcessTitle" name="searchProcessTitle" class="text readonly" style="width:150px;" readonly />
								
							</td>
							<th>발령일</th>
							<td>
								<input id="searchOrdYmdFrom" name="searchOrdYmdFrom" type="text" size="10" class="date2" value=""/> ~
								<input id="searchOrdYmdTo" name="searchOrdYmdTo" type="text" size="10" class="date2" value=""/>
							</td>
							
						</tr>
						<tr>
							<th>발령</th>
							<td>
								<select id="searchOrdTypeCd" name="searchOrdTypeCd"></select>
							</td>
							
							<th>사번/성명</th>
							<td>
								<input id="searchSabun" name="searchSabun" type="text" class="text" />
							</td>
							
							<td>
								<a href="javascript:doAppmtSaveErrorLayerAction1('Search');" class="button">조회</a>
							</td>
						</tr>
						</table>
                    </div>
                </div>
	        </form>

	        <table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	            <tr>
	                <td>
	    
	                <div class=inner>
	                    <div class="sheet_title">
	                    <ul>
	                        <li id="txt" class="txt">발령 에러메시지 조회</li>
		                    <li class="btn" style="padding-top:5px;">
								<a href="javascript:doAppmtSaveErrorLayerAction1('Down2Excel');" class="basic authR">다운로드</a>
							</li>
						</ul>
	                    </div>
	                </div>
					<div id="appmtSaveErrorLayerSht1-wrap"></div>
	                </td>
	            </tr>
	        </table>
        </div>

		<div class="modal_footer">
			<a href="javascript:closeCommonLayer('appmtSaveErrorLayer')" class="btn outline_gray">닫기</a>
		</div>
    </div>
</body>
</html>
