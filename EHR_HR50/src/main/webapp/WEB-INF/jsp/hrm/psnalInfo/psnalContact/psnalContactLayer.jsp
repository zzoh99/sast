<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='103837' mdef='인사기본(신상)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>

<!-- <script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script> -->

<%@ include file="/WEB-INF/jsp/hrm/psnalInfo/psnalBasicInf/psnalBasicDefined.jsp"%>
<script type="text/javascript">
	var pGubun = "";
	var gPRow = "";
	var searchUserId = '';
	var searchUserEnterCd = '';
	$(function() {
		const modal = window.top.document.LayerModalUtility.getModal('psnalContactLayer');
		searchUserId = modal.parameters.userId || '';
		searchUserEnterCd = modal.parameters.userEnterCd || '';

		$("#hdnSabun").val(searchUserId);
		$("#hdnEnterCd").val(searchUserEnterCd);

		createIBSheet3(document.getElementById('psnalTelSheet-wrap'), "psnalTelSheet", "0%", "0%", "${ssnLocaleCd}");
		createIBSheet3(document.getElementById('psnalAddrSheet-wrap'), "psnalAddrSheet", "100%", "50%", "${ssnLocaleCd}");

		//사용자 정보 수정요청 시 필요한 SHEET 정보를 SET
		///WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp 를 SCRIPT> 마지막에 꼭  INCLUDE 필요
		// BUTTON 을 싸고있는 LI (OR DIV)에 _테이블명 클래서를 정의해줌 예 : <li class='_thrm123'>
		// sheet 에 keyField 를 명확히 입력해야 그정보를 수정시 key로 사용함.
		EMP_INFO_CHANGE_TABLE_SHEET["thrm124"] = psnalTelSheet;
		EMP_INFO_CHANGE_TABLE_SHEET["thrm123"] = psnalAddrSheet;

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:0,DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' 		mdef='No'/>",			Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sStatus' 	mdef='상태'/>",			Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"<sht:txt mid='agreeSabun' 	mdef='사번'/>",			Type:"Text",	Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabun",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='contType' 	mdef='연락처구분코드'/>",	Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"contType",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='contTypeNm' 	mdef='연락처구분명'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"contTypeNm",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='telNo' 		mdef='연락처'/>",			Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"contAddress",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='type' 		mdef='연락처타입'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"type",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='refCd' 		mdef='참조코드'/>",		Type:"Text",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"refCd",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:100 },
		]; IBS_InitSheet(psnalTelSheet, initdata1);psnalTelSheet.SetEditable(false);psnalTelSheet.SetVisible(true);psnalTelSheet.SetCountPosition(0);

		var initdata2 = {};
		initdata2.Cfg = {SearchMode:smLazyLoad,MergeSheet:0,Page:22,FrozenCol:5,DataRowMerge:0, AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata2.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata2.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",		Type:"${sDelTy}",	Hidden:Number("${sDelHdn}"),Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",		Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",		Type:"Text",      	Hidden:1,  Width:0,    Align:"Center",  ColMerge:0,   SaveName:"sabun",		KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
			{Header:"<sht:txt mid='addType' mdef='주소구분'/>",	Type:"Combo",      	Hidden:0,  Width:80,   Align:"Left",  ColMerge:0,   SaveName:"addType",	KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:10 },
			{Header:"<sht:txt mid='zip' mdef='우편번호'/>",	Type:"Popup",      	Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"zip", 		KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:7 },
			{Header:"<sht:txt mid='addr' mdef='주소'/>",		Type:"Text",      	Hidden:0,  Width:180,  Align:"Left",    ColMerge:0,   SaveName:"addr1",     KeyField:1,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:1000 },
			{Header:"<sht:txt mid='addr2' mdef='상세주소'/>",	Type:"Text",      	Hidden:0,  Width:100,  Align:"Left",  ColMerge:0,   SaveName:"addr2",  	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='addrEng' mdef='영문주소'/>",	Type:"Text",      	Hidden:1,  Width:100,  Align:"Left",  ColMerge:0,   SaveName:"addrEng",  	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1000 },
			{Header:"<sht:txt mid='armyMemo' mdef='비고'/>",		Type:"Text",      	Hidden:0,  Width:100,  Align:"Left",  ColMerge:0,   SaveName:"note",   	KeyField:0,   CalcLogic:"",   Format:"",		PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:500 },
			{Header:"<sht:txt mid='btnFile' mdef='첨부파일'/>",	Type:"Html",		Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"btnFile",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 },
			{Header:"<sht:txt mid='fileSeq' mdef='첨부번호'/>",	Type:"Text",		Hidden:1,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"fileSeq",			KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:35 }
		];  IBS_InitSheet(psnalAddrSheet, initdata2);psnalAddrSheet.SetEditable("${editable}");psnalAddrSheet.SetVisible(true);psnalAddrSheet.SetCountPosition(0);

		psnalAddrSheet.SetFocusAfterProcess(false);

		if('${ssnEnterCd}' != $("#hdnEnterCd").val()) {
			psnalAddrSheet.SetEditable(0);
			$(".enterAuthBtn").hide();
			// 연락처 input 들 readonly화
			$("#infoFrom input").each(function(idx, obj) {
				if(idx >= 3) {
					$(obj).attr("readonly", true);
					$(obj).addClass("readonly");
				}
			});
		}
		var enterCd = "&enterCd="+$("#hdnEnterCd").val();

		//주소구분
		var userCd3 = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList"+enterCd, "H20185"), "");

		psnalAddrSheet.SetColProperty("addType", 		{ComboText:userCd3[0], ComboCode:userCd3[1]} );

		doAction1("Search");
		doAction2('Search');

		let sheetHeight = $(".modal_body").height() - $(".sheet_title").height() - 230;
		psnalAddrSheet.SetSheetHeight(sheetHeight);
	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			psnalTelSheet.DoSearch( "${ctx}/PsnalContact.do?cmd=getPsnalContactUserList", param );
			break;
		case "Save":

			var row = psnalTelSheet.LastRow();
			for(var i = 1;i <= row; i++){
				val = psnalTelSheet.GetCellValue(i,"contAddress");
				if(val!='' && psnalTelSheet.GetCellValue(i,"sStatus") != "R"){
					type = psnalTelSheet.GetCellValue(i,"type");
					contType = psnalTelSheet.GetCellValue(i,"contType");
					input = $("input[name="+contType+"]");
					switch(type){
						case "TEL":
							if(!telCheck(input)){
								return;
							}
							break;
						case "MAIL":
							if(!emailCheck(input)){
								return;
							}
							break;
					}
					psnalTelSheet.SetCellValue(i,"sabun",$("#hdnSabun").val());
				}
			}

			IBS_SaveName(document.infoFrom,psnalTelSheet);
			psnalTelSheet.DoSave( "${ctx}/PsnalContact.do?cmd=savePsnalContactTel", $("#infoFrom").serialize());
			break;
		}
	}

	//Sheet2 Action
	function doAction2(sAction) {
		switch (sAction) {
		case "Search":
			var param = "sabun="+$("#hdnSabun").val()+"&searchUserEnterCd="+$("#hdnEnterCd").val();
			psnalAddrSheet.DoSearch( "${ctx}/PsnalContact.do?cmd=getPsnalContactAddressList", param );
			break;
		case "Save":
			if(!dupChk(psnalAddrSheet,"addType", true, true)){break;}
			IBS_SaveName(document.infoFrom,psnalAddrSheet);
			psnalAddrSheet.DoSave( "${ctx}/PsnalContact.do?cmd=savePsnalContactAddress", $("#infoFrom").serialize());
			break;
		case "Insert":
			var row = psnalAddrSheet.DataInsert(0);
			psnalAddrSheet.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalAddrSheet.SetCellValue(row,"sabun",$("#hdnSabun").val());
			break;
		case "Copy":
			var row = psnalAddrSheet.DataCopy();
			psnalAddrSheet.SetCellValue(row, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
			psnalAddrSheet.SetCellValue(row, "fileSeq", '');

			psnalAddrSheet.SetCellValue(row,"sabun",$("#hdnSabun").val());
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(psnalAddrSheet);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			psnalAddrSheet.Down2Excel(param);
			break;
		}
	}

	function telCheck(obj) {
		var regExp = /^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})-?[0-9]{3,4}-?[0-9]{4}$/;
			if (!regExp.test(obj.val())) {
					alert("<msg:txt mid='2017082300226' mdef='잘못된 전화번호입니다'/>");
					obj.focus();
					obj.select();
					return false;
			}
			return true;
	}

	function emailCheck(obj) {
				var regExp = /([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$/;

			if (!regExp.test(obj.val())) {
				alert("<msg:txt mid='alertMonPayMailCre2' mdef='이메일 주소가 유효하지 않습니다'/>");
					obj.focus();
					obj.select();
					return false;
			}
			return true;
	}

	// 조회 후 에러 메시지
	function psnalTelSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
			getSheetData();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function psnalTelSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 조회 후 에러 메시지
	function psnalAddrSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			for(var r = psnalAddrSheet.HeaderRows(); r<psnalAddrSheet.RowCount()+psnalTelSheet.HeaderRows(); r++){
				if("${authPg}" == 'A' && '${ssnEnterCd}' == $("#hdnEnterCd").val()){
					if(psnalAddrSheet.GetCellValue(r,"fileSeq") == ''){
						psnalAddrSheet.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
						psnalAddrSheet.SetCellValue(r, "sStatus", 'R');
					}else{
						psnalAddrSheet.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalAddrSheet.SetCellValue(r, "sStatus", 'R');
					}
				}else{
					if(psnalAddrSheet.GetCellValue(r,"fileSeq") != ''){
						psnalAddrSheet.SetCellValue(r, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
						psnalAddrSheet.SetCellValue(r, "sStatus", 'R');
					}
				}
			}
			sheetResize();
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function psnalAddrSheet_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 팝업 클릭시 발생
	function psnalAddrSheet_OnPopupClick(Row,Col) {
		try {
			if(psnalAddrSheet.ColSaveName(Col) == "zip") {

				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "ZipCodePopup";

 				openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "740","620");

			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// 시트에서 폼으로 세팅.
	function getSheetData() {

		var row = psnalTelSheet.LastRow();
		var tbody = $("#addressTable tbody").html('');
		var tr = "";
		var td = "";
		for(var i = 1;i <= row; i++){
			if(i%3 == 1){
				tr = $("<tr/>");
			}
			tmp = "<th>"+psnalTelSheet.GetCellValue(i,"contTypeNm")+"</th>";

			// 20200902 비상연락망관계는 콤보박스로 표시
			var refCd = psnalTelSheet.GetCellValue(i, "refCd");
			if( !isEmpty(refCd) ) {
				var codeLists   = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", refCd);
				var contAddress = psnalTelSheet.GetCellValue(i, "contAddress"); // 비상연락망관계

				tmp+= "<td>"
				tmp+= "<select name='"+psnalTelSheet.GetCellValue(i,"contType")+"' class='${textCss} w100p'>";

				for(var j in codeLists) {
					if(codeLists[j].codeNm == contAddress) {
						tmp += "<option value='" + codeLists[j].codeNm +"' selected>" + codeLists[j].codeNm + "</option>";
					} else {
						tmp += "<option value='" + codeLists[j].codeNm + "'>" + codeLists[j].codeNm + "</option>";
					}
				}

				tmp+= "</select>";
				tmp+= "</td>";
			} else {
				tmp+= "<td><input  name='"+psnalTelSheet.GetCellValue(i,"contType")+"' type='text' class='${textCss} w100p' ${readonly} value='"+psnalTelSheet.GetCellValue(i,"contAddress")+"'/></td>";
			}

			$(tmp).appendTo(tr);
			if(i%3 == 0 || i == row){
				tr.appendTo(tbody);
			}
		}
		tbody.find("input, select").each(function(idx,ele){ //생성된 input에서 값 입력시 시트 컬럼에 반영
			//$(ele).on("keyup",function(){
			//$(ele).on("keyup change",function(){
			$(ele).on("keyup click",function(e){
				psnalTelSheet.SetCellValue((idx+1), "contAddress", this.value);
				// 시트에 SetSelectRow 시 타이핑 및 붙여넣기가 불가능하여 SelectRow 값을 hdnSelectRow에 넣어서 처리하도록 변경
				//psnalTelSheet.SetSelectRow((idx+1));
				$("#hdnSelectRow").val((idx+1));
				$("#hdnkeyup").val(this.value);
			});
		});
	}

	// 날짜 포맷을 적용한다..
	function formatDate(strDate, saper) {
		if(strDate == "") {
			return strDate;
		}

		if(strDate.length == 10) {
			return strDate.substring(0,4)+saper+strDate.substring(5,7)+saper+strDate.substring(8,10);
		} else if(strDate.length == 8) {
			return strDate.substring(0,4)+saper+strDate.substring(4,6)+saper+strDate.substring(6,8);
		}
	}

	//파일 신청 시작
	function psnalAddrSheet_OnClick(Row, Col, Value) {
		try{
			if(psnalAddrSheet.ColSaveName(Col) == "btnFile" && Row >= psnalAddrSheet.HeaderRows()){
				var param = [];
				param["fileSeq"] = psnalAddrSheet.GetCellValue(Row,"fileSeq");
				
				if(psnalAddrSheet.GetCellValue(Row,"btnFile") != ""){
					if(!isPopup()) {return;}

					pGubun = "fileMgrPopup";
					gPRow = Row;

					
					//var win = openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&uploadType=contact&authPg="+authPgTemp, param, "740","620");
					fileMgrPopup(Row, Col);
				}
			}
		}catch(ex){alert("OnClick Event Error : " + ex);}
	}
    // 파일첨부/다운로드 팝입
    function fileMgrPopup(Row, Col) {

        let layerModal = new window.top.document.LayerModal({
              id : 'fileMgrLayer'
            , url : '/fileuploadJFileUpload.do?cmd=viewFileMgrLayer&uploadType=contact&authPg=${authPg}'
            , parameters : {
                fileSeq : psnalAddrSheet.GetCellValue(Row,"fileSeq")
              }
            , width : 740
            , height : 420
            , title : '파일 업로드'
            , trigger :[
                {
                      name : 'fileMgrTrigger'
                    , callback : function(result){
                        if(result.fileCheck == "exist"){
                            psnalAddrSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
                            psnalAddrSheet.SetCellValue(gPRow, "fileSeq", result.fileSeq);
                        }else{
                            psnalAddrSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
                            psnalAddrSheet.SetCellValue(gPRow, "fileSeq", "");
                        }
                    }
                }
            ]
        });
        layerModal.show();
    }
	//파일 신청 끝

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

		if(pGubun == "fileMgrPopup") {
			if(rv["fileCheck"] == "exist"){
				psnalAddrSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110698' mdef="다운로드"/>');
				psnalAddrSheet.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]);
			}else{
				psnalAddrSheet.SetCellValue(gPRow, "btnFile", '<btn:a css="basic" mid='110922' mdef="첨부"/>');
				psnalAddrSheet.SetCellValue(gPRow, "fileSeq", "");
			}
		}else if ( pGubun == "ZipCodePopup" ){
			psnalAddrSheet.SetCellValue(gPRow, "zip", rv["zip"]);
			psnalAddrSheet.SetCellValue(gPRow, "addr1", rv["doroAddr"]);
			psnalAddrSheet.SetCellValue(gPRow, "addr2", rv["detailAddr"]);
 			//psnalAddrSheet.SetCellValue(gPRow, "addr1", rv["doroFullAddr"]);
			//psnalAddrSheet.SetCellValue(gPRow, "addr2", "");
		}
	}
</script>
<%@ include file="/WEB-INF/jsp/hrm/other/empInfoChangeMgr/empInfoChange.jsp"%>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<div class="modal_body">
		<input id="hdnSabun"  name="hdnSabun"  type="hidden">
		<input id="hdnEnterCd" name="hdnEnterCd" type="hidden">
		<input id="hdnAuthPg" name="hdnAuthPg" type="hidden" value="${authPg}">
		<input id="hdnkeyup"  name="hdnkeyup"  type="hidden">
		<input id="hdnSelectRow"  name="hdnSelectRow"  type="hidden">
		<div id="psnalTelSheetContent">
			<form id="infoFrom" name="infoFrom">
				<div class="outer">
					<div class="sheet_title">
						<ul>
							<li class="txt"><tit:txt mid='contact' mdef='연락처'/></li>
							<li class="btn _thrm124">
								<btn:a href="javascript:doAction1('Search');" css="basic authR" mid='110697' mdef="조회"/>
								<c:if test="${authPg == 'A'}">
									<btn:a href="javascript:doAction1('Save');" css="basic authA enterAuthBtn" mid='110708' mdef="저장" />
								</c:if>
							</li>
						</ul>
					</div>
				</div>
				<table border="0" cellpadding="0" cellspacing="0" class="default outer" id="addressTable">
					<colgroup>
						<col width="11%" />
						<col width="11%" />
						<col width="11%" />
						<col width="11%" />
						<col width="11%" />
						<col width="11%" />
						<col width="" />
					</colgroup>
					<tbody>
					</tbody>
				</table>
				<div class="hide">
					<%--		<script type="text/javascript"> createIBSheet("psnalTelSheet", "0", "0", "${ssnLocaleCd}"); </script>--%>
					<div id="psnalTelSheet-wrap"></div>
				</div>
			</form>
		</div>
		<div id="psnalAddrSheetContent">
			<div class="inner">
				<div class="sheet_title">
					<ul>
						<li class="txt"><tit:txt mid='address' mdef='주소'/></li>
						<li class="btn _thrm123">
							<btn:a href="javascript:doAction2('Search');" css="basic authR" mid='110697' mdef="조회"/>
							<c:if test="${authPg == 'A'}">
								<btn:a href="javascript:doAction2('Insert');" css="basic authA enterAuthBtn" mid='110700' mdef="입력"/>
								<btn:a href="javascript:doAction2('Copy');" css="basic authA enterAuthBtn" mid='110696' mdef="복사"/>
								<btn:a href="javascript:doAction2('Save');" css="basic authA enterAuthBtn" mid='110708' mdef="저장" />
							</c:if>
							<btn:a href="javascript:doAction2('Down2Excel');" css="basic authR" mid='110698' mdef="다운로드"/>
						</li>
					</ul>
				</div>
			</div>
			<%--				<script type="text/javascript"> createIBSheet("psnalAddrSheet", "100%", "100%", "${ssnLocaleCd}"); </script>--%>
			<div id="psnalAddrSheet-wrap"></div>
		</div>
	</div>
</div>
</body>
</html>
