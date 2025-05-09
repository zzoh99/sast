<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title>연말정산 재계산 대상자 선정</title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");

    $(function() {
    	$("#menuNm").val($(document).find("title").text());
        var arg = p.window.dialogArguments;

        if( arg != undefined ) {
            $("#searchWorkYy").val(arg["searchWorkYy"]);
            $("#searchAdjustType").val(arg["searchAdjustType"]);
            $("#searchSabun").val(arg["searchSabun"]);
            $("#searchPayActionCd").val(arg["searchPayActionCd"]);
            $("#searchPayActionNm").val(arg["searchPayActionNm"]);
            $("#searchBusinessCd").val(arg["searchBizPlaceCd"]);
            $("#popFlag").val(arg["popFlag"]);
        }else{
            var searchWorkYy        = "";
            var searchAdjustType    = "";
            var searchSabun         = "";
            var searchPayActionCd   = "";
            var searchPayActionNm   = "";
            var searchBusinessCd    = "";
            var popFlag             = "";

            searchWorkYy      = p.popDialogArgument("searchWorkYy");
            searchAdjustType  = p.popDialogArgument("searchAdjustType");
            searchSabun       = p.popDialogArgument("searchSabun");
            searchPayActionCd = p.popDialogArgument("searchPayActionCd");
            searchPayActionNm = p.popDialogArgument("searchPayActionNm");
            searchBusinessCd  = p.popDialogArgument("searchBizPlaceCd");
            popFlag           = p.popDialogArgument("popFlag");

            $("#searchWorkYy").val(searchWorkYy);
            $("#searchAdjustType").val(searchAdjustType);
            $("#searchSabun").val(searchSabun);
            $("#searchPayActionCd").val(searchPayActionCd);
            $("#searchPayActionNm").val(searchPayActionNm);
            $("#searchBusinessCd").val(searchBusinessCd);
            $("#popFlag").val(popFlag);
        }

        var initdata1 = {};
        initdata1.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, DataRowMerge:0};
        initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
        initdata1.Cols = [
            {Header:"No",                    Type:"<%=sNoTy%>",    Hidden:Number("<%=sNoHdn%>"),   Width:"<%=sNoWdt%>",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"상태",                  Type:"<%=sSttTy%>",   Hidden:Number("<%=sSttHdn%>"),  Width:"<%=sSttWdt%>", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"년도",                  Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"work_yy",               KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"정산구분",              Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"adjust_type",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"재계산",                Type:"CheckBox",  Hidden:0,  Width:80,   Align:"Center",        ColMerge:0,   SaveName:"check_nm",              KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:100 },
            {Header:"대상상태",              Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"pay_people_status",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"성명",                  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"name",                  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, FontColor:"#0000ff" },
            {Header:"사번",                  Type:"Text",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"sabun",                 KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사업장코드",            Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"business_place_cd",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"정산코드",              Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"pay_action_cd",         KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"조직코드",              Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"org_cd",                KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"부서명",                Type:"Text",      Hidden:0,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"org_nm",                KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"외국인\n단일세율적용",  Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"foreign_tax_type",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"우편번호",              Type:"Text",      Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"zip",                   KeyField:0,   CalcLogic:"",   Format:"",      PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"주소1",                 Type:"Text",      Hidden:0,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"addr1",                 KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"주소2",                 Type:"Text",      Hidden:0,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"addr2",                 KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"inputCloseYn",          Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"input_close_yn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"apprvYn",               Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"apprv_yn",              KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"마감여부",              Type:"CheckBox",  Hidden:1,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"final_close_yn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100, TrueValue:"Y", FalseValue:"N"},
            {Header:"houseOwnerYn",          Type:"Text",      Hidden:1,  Width:100,  Align:"Left",          ColMerge:0,   SaveName:"house_owner_yn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"세액계산방식",          Type:"Combo",     Hidden:0,  Width:100,  Align:"Center",        ColMerge:0,   SaveName:"tax_type",              KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:35 }
        ]; IBS_InitSheet(sheet1, initdata1); sheet1.SetEditable("<%=editable%>"); sheet1.SetCountPosition(4);

        var payPeopleStatusList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00125"), "");
        var foreignTaxTypeList  = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00170"), "");
        var taxTypeList = stfConvCode( codeList("<%=jspPath%>/common/commonCode.jsp?cmd=getCommonCodeList","C00450"), "");

        sheet1.SetColProperty("pay_people_status",    {ComboText:"|"+payPeopleStatusList[0], ComboCode:"|"+payPeopleStatusList[1]} );
        sheet1.SetColProperty("foreign_tax_type",    {ComboText:"|"+foreignTaxTypeList[0], ComboCode:"|"+foreignTaxTypeList[1]} );
        sheet1.SetColProperty("tax_type",    {ComboText:"|"+taxTypeList[0], ComboCode:"|"+taxTypeList[1]} );

        $(window).smartresize(sheetResize); sheetInit();

        doAction1("Search");
    });

    $(function(){
        $(".close").click(function() {
            p.self.close();
        });
    });

    //대상자 찾기
    function findName(){
        if($("#findName").val() == "") return;

        var Row = 0;
        if(sheet1.GetSelectRow() < sheet1.LastRow()){
            Row = sheet1.FindText("name", $("#findName").val(), sheet1.GetSelectRow()+1, 2);
           	// 사번
            if(Row == -1){
            	Row = sheet1.FindText("sabun", $("#findName").val(), sheet1.GetSelectRow()+1, 2);
            }

            if(Row > 0){
                sheet1.SelectCell(Row,"sabun");
            }else if(Row == -1){
                if(sheet1.GetSelectRow() > 1){
                    Row = sheet1.FindText("sabun", $("#findName").val(), 1, 2);
                    if(Row > 0){
                        sheet1.SelectCell(Row,"sabun");
                    }
                }
            }
        }else{
            Row = -1;
        }

        if(Row > 0){
            sheet1.SelectCell(Row,"name");
        } else if(Row == -1){
            if(sheet1.GetSelectRow() > 1){
                Row = sheet1.FindText("name", $("#findName").val(), 1, 2);
                if(Row > 0){
                    sheet1.SelectCell(Row,"name");
                }
            }
        }
        $("#findName").focus();
    }

    function check_Enter(){
        if (event.keyCode==13) findName();
    }

    /*Sheet Action*/
    function doAction1(sAction) {
        switch (sAction) {
        case "Search"://조회
            sheet1.DoSearch( "<%=jspPath%>/yeaCalcCre/yeaCalcCreRePeoplePopupRst.jsp?cmd=selectYeaCalcCreRePopupList", $("#sheetForm").serialize() );
            break;
        case "Save"://저장
            sheet1.DoSave( "<%=jspPath%>/yeaCalcCre/yeaCalcCreRePeoplePopupRst.jsp?cmd=saveYeaCalcCreRePopup", $("#sheetForm").serialize() );
			break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param = {
				DownCols : downcol,
				SheetDesign : 1,
				Merge : 1
			};
			sheet1.Down2Excel(param);
			break;
		}
	}

	//값이 바뀔때 발생.
	function sheet1_OnChange(Row, Col, Value) {
		try {

			if (sheet1.ColSaveName(Col) == "check_nm") {
				if (sheet1.GetCellValue(Row, "check_nm") == "1") {
					if (sheet1.GetCellValue(Row, "pay_people_status") == "J") {
						sheet1.SetCellValue(Row, "pay_people_status", "M");
					} else {
						sheet1.SetCellValue(Row, "pay_people_status", "PM");
					}
				} else if (sheet1.GetCellValue(Row, "check_nm") == "0") {
					if (sheet1.GetCellValue(Row, "pay_people_status") == "M") {
						sheet1.SetCellValue(Row, "pay_people_status", "J");
					} else {
						sheet1.SetCellValue(Row, "pay_people_status", "P");
					}
				}
			}


		} catch (ex) {
			alert("OnChange Event Error : " + ex);
		}
	}

	//조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);
			sheetResize();

			//연말정산 마감여부가 true일때 그리드 비활성화
			if($("#popFlag").val() == "true"){
				for(var i = 1; i < sheet1.RowCount()+1; i++){
					sheet1.SetCellEditable(i,"check_nm", 0);
					sheet1.SetCellEditable(i,"tax_type", 0);
				}
			}
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	//저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			alertMessage(Code, Msg, StCode, StMsg);

			if (Code == 1) {
				doAction1("Search");
				//return
				if (p.popReturnValue) p.popReturnValue("");
			}
		} catch (ex) {
			alert("OnSaveEnd Event Error " + ex);
		}
	}
</script>

</head>
<body class="bodywrap">
	<form id="sheetForm" name="sheetForm">
		<input type="hidden" id="searchGubun" name="searchGubun" value="" />
		<input type="hidden" id="searchWorkYy" name="searchWorkYy" value="" />
		<input type="hidden" id="searchAdjustType" name="searchAdjustType"value="" />
		<input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="">
		<input type="hidden" id="searchBusinessCd" name="searchBusinessCd" value="">
		<input type="hidden" id="popFlag" name="popFlag" value="">
		<input type="hidden" id="menuNm" name="menuNm" value="" />
		<div class="wrapper">
			<div class="popup_title">
				<ul>
					<li id="strTitle">연말정산 재계산 대상자 선정</li>
					<!-- <li class="close"></li>  -->
				</ul>
			</div>

			<div class="popup_main">
				<div>
					<table border="0" cellpadding="0" cellspacing="0"
						class="default outer">
						<colgroup>
							<col width="20%" />
							<col width="30%" />
							<col width="20%" />
							<col width="" />
						</colgroup>
						<tr>
							<th class="left">작업일자</th>
							<td class="left">
								<input type="text" id="searchPayActionNm" name="searchPayActionNm" value="" class="text w100p readonly transparent" readonly>
							</td>
							<th class="left">대상자 찾기</th>
							<td class="left">
								<input id="findName" name="findName" type="text" class="text w150" onKeyUp="check_Enter();" />
                                <a onclick="javascript:findName();" onFocus="this.blur()" href="javascript:void(0);" class="basic btn-white ico-search no-text"></a>
							</td>
						</tr>
					</table>
				</div>
				<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
					<tr>
						<td class="top">
							<div class="outer">
								<div class="sheet_title">
									<ul>
										<li id="strSheetTitle" class="txt">연말정산 재계산 대상자 선정</li>
										<li class="btn">
											<a href="javascript:doAction1('Search')" class="basic authR">조회</a>
											<a href="javascript:doAction1('Save')" class="basic btn-save authA">저장</a>
											<a href="javascript:doAction1('Down2Excel')" class="basic btn-download authR">다운로드</a>
										</li>
									</ul>
								</div>
							</div>

							<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
						</td>
					</tr>
				</table>
				<!-- <div class="popup_button outer">
					<ul>
						<li><a href="javascript:p.self.close();" class="gray large">닫기</a>
						</li>
					</ul>
				</div> -->
			</div>
		</div>
	</form>
</body>
</html>



