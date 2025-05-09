<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='sabunCreAppmt' mdef='사번생성/가발령'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var gPRow = "";
	var pGubun = "";

	$(function() {
		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,FrozenCol:7};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		initdata1.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",					Type:"${sNoTy}",	Hidden:Number("${sNoHdn}"),	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
   			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:Number("${sSttHdn}"),Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },
			{Header:"<sht:txt mid='ibsImage1V2' mdef='기본\n내역'/>",		Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='ibsImage2V2' mdef='발령\n내역'/>",		Type:"Image",	Hidden:0,	Width:40,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage2",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='seq' mdef='일련번호'/>",				Type:"Text",	Hidden:1,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"receiveNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='regYmd' mdef='입력일'/>",				Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"regYmd",		KeyField:1,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='name' mdef='성명'/>",					Type:"Text",	Hidden:0,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
			{Header:"<sht:txt mid='empYmdYn' mdef='입사일'/>",			Type:"Date",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"empYmd",		KeyField:0,	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='sabunType' mdef='사번생성룰구분'/>",		Type:"Combo",	Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"sabunType",	KeyField:1,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:10 },
			{Header:"<sht:txt mid='chargeSabun' mdef='사번'/>",			Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:13 },
			{Header:"<sht:txt mid='checkSabun' mdef='사번생성\n선택'/>",	Type:"DummyCheck",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"checkSabun",		KeyField:0,	Format:"",	CalcLogic:"",	PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='sabunYn' mdef='사번\n확정'/>",			Type:"CheckBox",Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sabunYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='processNo' mdef='품의번호'/>",			Type:"Text",	Hidden:1,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"processNo",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:20 },
			{Header:"<sht:txt mid='ibsCheck1' mdef='선택'/>",				Type:"DummyCheck",Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsCheck1",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='prePostYnV1' mdef='가발령\n적용'/>",	Type:"CheckBox",Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"prePostYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='ordDetailYnV1' mdef='발령사항\n입력'/>",	Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ordDetailYn",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='ibsImage2V1' mdef='발령확정'/>",		Type:"Text",	Hidden:1,	Width:60,	Align:"Center",	ColMerge:0,	SaveName:"ordYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='ordDetailYnV1' mdef='발령사항\n입력'/>",	Type:"Image",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage3",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='ibsImage2V1' mdef='발령확정'/>",		Type:"Image",	Hidden:0,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"ibsImage4",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='autoYnV1' mdef='사번자동생성여부'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"autoYn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:1 },
			{Header:"<sht:txt mid='fixGbnV1' mdef='사번생성구분'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fixGbn",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='fixValV1' mdef='사번생성구분값'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fixVal",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='fixVal2' mdef='사번생성구분값2'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"fixVal2",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='autonumV1' mdef='사번생성자릿수'/>",		Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"autonum",		KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"<sht:txt mid='autoSabun' mdef='사번생성'/>",			Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"autoSabun",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:35 },
			{Header:"포인트",												Type:"Text",	Hidden:1,	Width:50,	Align:"Center",	ColMerge:0,	SaveName:"sgPoint",	KeyField:0,	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 }
		]; IBS_InitSheet(sheet1, initdata1);sheet1.SetEditable("${editable}");sheet1.SetVisible(false);sheet1.SetCountPosition(4);

		sheet1.SetImageList(0,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(1,"/common/images/icon/icon_x.png");
		sheet1.SetImageList(2,"/common/images/icon/icon_o.png");
		sheet1.SetImageList(3,"/common/images/icon/icon_info.png");
		sheet1.SetDataLinkMouse("ibsImage1", 1);
		sheet1.SetDataLinkMouse("ibsImage2", 1);

		var ordDetailCd = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getOrdDetailCdList",false).codeList, "");	//발령종류
		var sabunType = stfConvCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10160"), "");

		sheet1.SetColProperty("ordDetailCd", 		{ComboText:"|"+ordDetailCd[0], ComboCode:"|"+ordDetailCd[1]} );
		sheet1.SetColProperty("lunType", 			{ComboText:"양력|음력", ComboCode:"1|2"} );
		sheet1.SetColProperty("sabunType", 			{ComboText:"|"+sabunType[0], ComboCode:"|"+sabunType[1]} );

		$(window).smartresize(sheetResize); sheetInit();
		doAction1("Search");
	});

	$(function() {

        $("#name").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
		});

        $("#sabunYn").bind("change", function(event) {
        	doAction1("Search");
        });

		$("#regYmdFrom").datepicker2({startdate:"regYmdTo"});
		$("#regYmdTo").datepicker2({enddate:"regYmdFrom"});

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":

			if($("#regYmdFrom").val() == "") {
				alert("<msg:txt mid='110186' mdef='입력일을 입력하여 주십시오.'/>");
				$("#regYmdFrom").focus();
				return;
			}
			if($("#regYmdTo").val() == "") {
				alert("<msg:txt mid='110186' mdef='입력일을 입력하여 주십시오.'/>");
				$("#regYmdTo").focus();
				return;
			}

			sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getSabunCreAppmtList",$("#sendForm").serialize() );
			break;
		case "Save":
			IBS_SaveName(document.sendForm,sheet1);
			sheet1.DoSave( "${ctx}/SabunCreAppmt.do?cmd=saveSabunCreAppmt",$("#sendForm").serialize());
			break;
		case "Insert":
			var row = sheet1.DataInsert(0);
			showDetailPop(row);
			break;
		case "SabunCre":
			if(sheet1.RowCount() > 0) {
				if(sheet1.RowCount("U") > 0) {
					alert("<msg:txt mid='alertSabunUpdateCheck' mdef='수정된 데이터가 존재합니다. 저장후 사번을 생성하십시오.'/>");
					return;
				}

				/*
				if($("#regYmdFrom").val() == "") {
					alert("<msg:txt mid='110186' mdef='입력일을 입력하여 주십시오.'/>");
					$("#regYmdFrom").focus();
					return;
				}
				if($("#regYmdTo").val() == "") {
					alert("<msg:txt mid='110186' mdef='입력일을 입력하여 주십시오.'/>");
					$("#regYmdTo").focus();
					return;
				}
				*/

		        var cnt = 0;
		        var keys = "";

		        for(var i = 1; i < sheet1.RowCount()+1; i++) {
		            if(sheet1.GetCellValue(i, "sabun") == "" && sheet1.GetCellValue(i, "checkSabun") == "1") {
		                cnt++;

		                keys = keys + sheet1.GetCellValue(i, "receiveNo")+ ",";
		            }
		        }

		        if(cnt == 0) {
		        	alert("<msg:txt mid='110324' mdef='사번을 생성할 데이터가 존재하지 않습니다.'/>");
		        }

				if(!confirm(cnt + "건의 사번을 생성하시겠습니까?")) {
					return;
				}

				keys = keys.substring(0, keys.length-1);

				var param = {};
				param.regYmdFrom = $("#regYmdFrom").val().replace(/-/gi,"");
				param.regYmdTo = $("#regYmdTo").val().replace(/-/gi,"");
				param.receiveNo = keys;

				var data = ajaxCall("${ctx}/SabunCreAppmt.do?cmd=prcSabunCreAppmtSave&regYmdFrom=",$.param(param),false);

				if(data.Result != null ){
			    	alert(data.Result.Message);
			    	doAction1("Search");
				} else {
					alert("알수 없는 에러가 발생하였습니다.\n 관리자에게 문의 바랍니다." );
					doAction1("Search");
				}
			}
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
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

			if(sheet1.RowCount() > 0) {
				for(var i = 1; i < sheet1.RowCount()+1; i++) {
					if(sheet1.GetCellValue(i, "ordDetailYn") != "2"
							|| sheet1.GetCellValue(i, "prePostYn") != "0"
							|| sheet1.GetCellValue(i, "ordYn") != "0") {
						sheet1.SetRowEditable(i,false);
					} else {
						sheet1.SetRowEditable(i,true);

						if(sheet1.GetCellValue(i, "sabunYn") == "1" ) {
							sheet1.SetCellEditable(i,"sabun",false);
						}
					}

					if(sheet1.GetCellValue(i, "sabun") != "") {
						sheet1.SetCellEditable(i,"checkSabun", false);
					}
				}
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			doAction1("Search");
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}

	// 셀 클릭시 발생
	function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
		try {
		    if( sheet1.ColSaveName(Col) == "ibsImage1" ) {
				if(!isPopup()) {return;}

				var param = [];
				param["receiveNo"] = sheet1.GetCellValue(Row,"receiveNo");

		        var win = openPopup("/RecBasicInfoReg.do?cmd=viewRecBasicInfoRegPop&authPg=R", param, "740","500");
		    } else if(sheet1.ColSaveName(Col) == "ibsImage2") {
				if(!isPopup()) {return;}

				var param = [];
				param["receiveNo"] = sheet1.GetCellValue(Row,"receiveNo");

		        var win = openPopup("/SabunCreAppmt.do?cmd=viewSabunCreAppmtPop&authPg=R", param, "740","420");
		    }

            sheet1.SetAllowCheck(true);

		    if(sheet1.ColSaveName(Col) == "sabunYn") {
		        if(sheet1.GetCellValue(Row, "sabunYn") == "1") {
		        	if(sheet1.GetCellValue(Row, "sabun") == "") {
			            alert("<msg:txt mid='109894' mdef='사번이 없는 상태에서는 사번확정을 하실 수 없습니다.'/>");
			            sheet1.SetAllowCheck(false);
		        	} else {
		        		sheet1.SetCellEditable(Row,"sabun",false);
		        	}
		        } else {
		        	
	        		//sheet1.SetCellEditable(Row,"sabun",true);
		        }
		    } else if(sheet1.ColSaveName(Col) == "prePostYn") {
		        if(sheet1.GetCellValue(Row, "prePostYn") == "0") {
		        	
		        	if(sheet1.GetCellValue(Row, "sabunYn") == "0") {
		        		//alert("<msg:txt mid='alertSabunYn2' mdef='가발령은 사번이 확정 되어야만 하실 수 있습니다.'/>");
			            //sheet1.SetAllowCheck(false);
		        	} else {
		        		sheet1.SetCellEditable(Row,"sabunYn",true);
		        	}
		        	
		        } else {
		        	if(sheet1.GetCellValue(Row, "sabunYn") == "1") {
		        		sheet1.SetCellEditable(Row,"sabunYn",false);
		        	} else {
		        		sheet1.SetCellEditable(Row,"sabunYn",true);
		        	}
		        }
		    }
		} catch (ex) {
			alert("OnClick Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "processNo") {
				if(!isPopup()) {return;}

		    	gPRow = Row;
		    	pGubun = "appmtConfirmPopup";

	            var win = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=R", "", "740","500");
			}
		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	// 체크 되기 직전 발생.
	function sheet1_OnBeforeCheck(Row, Col) {
		try{
            sheet1.SetAllowCheck(true);

		    if(sheet1.ColSaveName(Col) == "sabunYn") {
		        if(sheet1.GetCellValue(Row, "sabunYn") == "0") {
		        	if(sheet1.GetCellValue(Row, "sabun") == "") {
			            //alert("<msg:txt mid='109894' mdef='사번이 없는 상태에서는 사번확정을 하실 수 없습니다.'/>");
			            sheet1.SetAllowCheck(false);
		        	} else {
		        		sheet1.SetCellEditable(Row,"sabun",false);
		        	}
		        } else {
	        		sheet1.SetCellEditable(Row,"sabun",true);
		        }
		    } else if(sheet1.ColSaveName(Col) == "prePostYn") {
		        if(sheet1.GetCellValue(Row, "prePostYn") == "0") {
		        	if(sheet1.GetCellValue(Row, "sabunYn") == "0") {
		        		//alert("<msg:txt mid='alertSabunYn2' mdef='가발령은 사번이 확정 되어야만 하실 수 있습니다.'/>");
			            //sheet1.SetAllowCheck(false);
		        	} else {
		        		sheet1.SetCellEditable(Row,"sabunYn",false);
		        	}
		        } else {
	        		sheet1.SetCellEditable(Row,"sabunYn",true);
		        }
		    }
		}catch(ex){
			alert("OnBeforeCheck Event Error : " + ex);
		}
	}

	//사번 중복 체크
	function sheet1_OnChange(Row, Col, Value, OldValue, RaiseFlag) {
		if(sheet1.ColSaveName(Col) == "sabun"){
			if(Value != ""){
				var objCnt = ajaxCall('${ctx}/GetDataMap.do?cmd=getSabunCreAppmtCnt', "&sabun="+Value, false);

				if (objCnt.Map != null) {
					if(objCnt.Map.cnt > 0){
						alert("<msg:txt mid='alertSabunCheck' mdef='해당 사번은 이미 사용중입니다.'/>");
						if( sheet1.GetCellValue(Row, "sStatus") == "I" ) sheet1.SetCellValue(Row, "sabun", "");
						else sheet1.ReturnData(Row);
					}
				}
			}
		}
	}

	// 품의번호 팝업
	function showProcessNoPop(inputId) {
		if(!isPopup()) {return;}

    	gPRow = inputId;
    	pGubun = "searchAppmtConfirmPopup";

        var win = openPopup("/AppmtConfirmPopup.do?cmd=viewAppmtConfirmPopup&authPg=R", "", "740","700");
	}

	// 품의 일괄적용
	function setProcessNo() {
		var processNo = $("#allProcessNo").val();

		if(processNo == "") {
			alert("<msg:txt mid='alertProcessNoSelect' mdef='품의번호를 선택하여 주십시오.'/>");
		} else if(sheet1.RowCount() > 0 && sheet1.CheckedRows("ibsCheck1") > 0) {
			var sRow = sheet1.FindCheckedRow("ibsCheck1");
			var arrRow = sRow.split("|");

			for(var i = 0; i < arrRow.length; i++) {
				if(arrRow[i] != "") {
					sheet1.SetCellValue(arrRow[i],"processNo",processNo);
				}
			}
			alert("<msg:txt mid='alertProcessNoAll' mdef='품의번호가 일괄적용 되었습니다.'/>");
		} else {
			alert("<msg:txt mid='alertNoSelect' mdef='선택된 행이 없거나 데이터가 없습니다.'/>");
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "appmtConfirmPopup"){
            sheet1.SetCellValue(gPRow, "processNo", rv["processNo"] );
        } else if(pGubun == "searchAppmtConfirmPopup") {
           	$("#"+gPRow).val(rv["processNo"]);
        }
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
<form id=sendForm name="sendForm" method="post">
	<div class="sheet_search outer">
		<div>
		<table>
		<tr>
			<th><tit:txt mid='112113' mdef='입력일'/></th>
			<td>
				<input id="regYmdFrom" name="regYmdFrom" type="text" size="10" class="date2 required" value="<%= DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"),-365)%>"/> ~
				<input id="regYmdTo" name="regYmdTo" type="text" size="10" class="date2 required" value="<%=DateUtil.addDays(DateUtil.getCurrentTime("yyyy-MM-dd"), 365)%>"/>
			</td>
			<th><tit:txt mid='103880' mdef='성명'/></th>
			<td>
				<input id="name" name="name" type="text" class="text"/>
			</td>
			<th><tit:txt mid='112117' mdef='사번확정'/></th>
			<td>
				<select id="sabunYn" name="sabunYn">
					<option value=""><tit:txt mid='103895' mdef='전체'/></option>
					<option value="1"><tit:txt mid='114030' mdef='확정'/></option>
					<option value="0"><tit:txt mid='114219' mdef='미확정'/></option>
				</select>
			</td>
			<td>
				<btn:a href="javascript:doAction1('Search');" css="button" mid='search' mdef="조회"/>
			</td>
		</tr>
		<tr class="hide">
			<th><tit:txt mid='113517' mdef='품의번호'/></th>
			<td>
				<input id="schProcessNo" name="schProcessNo" type="text" class="text"/>
				<a href="javascript:showProcessNoPop('schProcessNo');" class="button6" title=""><img src="/common/${theme}/images/btn_search2.gif"/></a>
			</td>
		</tr>
		</table>
		</div>
	</div>
</form>
	<div class="inner">
		<div class="sheet_title">
		<ul>
			<li class="txt"><tit:txt mid='sabunCreAppmt' mdef='사번생성/가발령'/></li>
			<li class="btn">
				<!--
				품의번호
				<input id="allProcessNo" name="allProcessNo" type="text" class="text  w200"/>
				<a href="javascript:showProcessNoPop('allProcessNo');" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				<btn:a href="javascript:setProcessNo();" css="button authR" mid='allProcessNo' mdef="품의번호일괄적용"/>
				 -->
				<btn:a href="javascript:doAction1('SabunCre');" css="basic authA" mid='sabunCre' mdef="사번생성"/>
				<btn:a href="javascript:doAction1('Save');" css="basic authA" mid='save' mdef="저장"/>
				<btn:a href="javascript:doAction1('Down2Excel');" css="basic authR" mid='down2excel' mdef="다운로드"/>
			</li>
		</ul>
		</div>
	</div>

	<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>
</div>
</body>
</html>
