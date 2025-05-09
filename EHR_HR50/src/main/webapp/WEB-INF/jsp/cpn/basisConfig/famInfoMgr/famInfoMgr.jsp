<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<title><tit:txt mid='famInfoMgr' mdef='부양가족정보생성'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var gPRow = "";
var pGubun = "";
    $(function() {
        var initdata = {};
        initdata.Cfg = {SearchMode:smLazyLoad,Page:22};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,FrozenCol:6,HeaderCheck:1};
        initdata.Cols = [
            {Header:"<sht:txt mid='sNo' mdef='No'/>",        Type:"${sNoTy}",    Hidden:Number("${sNoHdn}"),   Width:"${sNoWdt}",  Align:"Center", ColMerge:0,   SaveName:"sNo" },
            {Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",      Type:"${sDelTy}",   Hidden:Number("${sDelHdn}"),  Width:"${sDelWdt}", Align:"Center", ColMerge:0,   SaveName:"sDelete" , Sort:0},
            {Header:"<sht:txt mid='resultV2' mdef='결과'/>",      Type:"${sRstTy}",   Hidden:Number("${sRstHdn}"),  Width:"${sRstWdt}", Align:"Center", ColMerge:0,   SaveName:"sResult" , Sort:0},
            {Header:"<sht:txt mid='sStatus' mdef='상태'/>",      Type:"${sSttTy}",   Hidden:Number("${sSttHdn}"),  Width:"${sSttWdt}", Align:"Center", ColMerge:0,   SaveName:"sStatus" , Sort:0},
            {Header:"<sht:txt mid='appOrgNmV5' mdef='소속'/>",                   Type:"Text",      Hidden:0,  Width:100,  Align:"Left",    ColMerge:0,   SaveName:"orgNm",          KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='agreeSabun' mdef='사번'/>",                   Type:"Text",      Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"sabun",          KeyField:1,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"<sht:txt mid='appNameV1' mdef='성명'/>",                   Type:"Text", Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"name",           KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='hochingNm' mdef='호칭'/>",                 Type:"Text",      Hidden:Number("${aliasHdn}"),  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"alias",           KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='jikgubCd' mdef='직급'/>",                 Type:"Text",      Hidden:Number("${jgHdn}"),  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikgubNm",           KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='applJikweeNm' mdef='직위'/>",                 Type:"Text",      Hidden:Number("${jwHdn}"),  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"jikweeNm",           KeyField:0,   CalcLogic:"",   Format:"",           PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"<sht:txt mid='statusCdV5' mdef='재직상태'/>",               Type:"Combo",     Hidden:0,  Width:80,   Align:"Center",  ColMerge:0,   SaveName:"statusCd",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"<sht:txt mid='foreignYnV2' mdef='해외근로\n과세'/>",         Type:"Combo",     Hidden:0,  Width:60,   Align:"Center",  ColMerge:0,   SaveName:"foreignYn",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='handicapYn' mdef='장애인\n근로자'/>",         Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"handicapYn",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='womanYn' mdef='부녀자'/>",                 Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"womanYn",        KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='spouseYn' mdef='배우자\n공제'/>",           Type:"Combo",     Hidden:0,  Width:50,   Align:"Center",  ColMerge:0,   SaveName:"spouseYn",       KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:1 },
            {Header:"<sht:txt mid='familyCnt1' mdef='부양자\n(60,55세이상)'/>",  Type:"Int",       Hidden:0,  Width:85,   Align:"Right",   ColMerge:0,   SaveName:"familyCnt1",     KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"<sht:txt mid='familyCnt2' mdef='부양자\n(20세이하)'/>",     Type:"Int",       Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"familyCnt2",     KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"<sht:txt mid='addChildCnt' mdef='부양자 자녀 중\n8세이상 20세이하'/>",               Type:"Int",       Hidden:0,  Width:80,   Align:"Right",   ColMerge:0,   SaveName:"addChildCnt",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"<sht:txt mid='oldCnt1' mdef='경로우대\n(65세이상)'/>",   Type:"Int",       Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"oldCnt1",        KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"<sht:txt mid='oldCnt2' mdef='경로우대\n(70세이상)'/>",   Type:"Int",       Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"oldCnt2",        KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"<sht:txt mid='handicapCnt' mdef='장애인'/>",                 Type:"Int",       Hidden:0,  Width:50,   Align:"Right",   ColMerge:0,   SaveName:"handicapCnt",    KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"<sht:txt mid='childCnt' mdef='자녀양육비\n공제자'/>",     Type:"Int",       Hidden:0,  Width:70,   Align:"Right",   ColMerge:0,   SaveName:"childCnt",       KeyField:0,   CalcLogic:"",   Format:"Integer",     PointCount:0,   UpdateEdit:1,   InsertEdit:1,   EditLen:2 },
            {Header:"<sht:txt mid='sYmd' mdef='시작일자'/>",        Type:"Date",     Hidden:0,  					Width:80,  			Align:"Center",  ColMerge:0,   SaveName:"sdate",    KeyField:1, Format:"Ymd", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 },
            {Header:"<sht:txt mid='eYmd' mdef='종료일자'/>",        Type:"Date",     Hidden:0,  					Width:80,  			Align:"Center",  ColMerge:0,   SaveName:"edate",    KeyField:0, Format:"Ymd", PointCount:0,   UpdateEdit:0,   InsertEdit:1,   EditLen:100 }
        ];

		IBS_InitSheet(sheet1, initdata);sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);

        var statusCdList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");

        var statusCdGridList  = convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","H10010"), "");

        sheet1.SetColProperty("statusCd", {ComboText:statusCdGridList[0], ComboCode:statusCdGridList[1]} );

        sheet1.SetColProperty("foreignYn", {ComboText:"Y|N", ComboCode:"Y|N"} );
        sheet1.SetColProperty("handicapYn", {ComboText:"Y|N", ComboCode:"Y|N"} );
        sheet1.SetColProperty("womanYn", {ComboText:"Y|N", ComboCode:"Y|N"} );
        sheet1.SetColProperty("spouseYn", {ComboText:"Y|N", ComboCode:"Y|N"} );
        
		// 이름 입력 시 자동완성
		$(sheet1).sheetAutocomplete({
			Columns: [
				{
					ColSaveName  : "name",
					CallbackFunc : function(returnValue){
						var rv = $.parseJSON('{' + returnValue+ '}');
						sheet1.SetCellValue(gPRow, "name", rv["name"]);
						sheet1.SetCellValue(gPRow, "sabun", rv["sabun"]);
						sheet1.SetCellValue(gPRow, "orgNm", rv["orgNm"]);
						sheet1.SetCellValue(gPRow, "alias", rv["alias"]);
						sheet1.SetCellValue(gPRow, "jikgubNm",	rv["jikgubNm"]);
						sheet1.SetCellValue(gPRow, "jikweeNm",	rv["jikweeNm"]);
						sheet1.SetCellValue(gPRow, "jikchakNm", rv["jikchakNm"]);
						sheet1.SetCellValue(gPRow, "statusCd", rv["statusCd"]);
					}
				}
			]
		});		

		// 재직상태
		$("#searchStatusCd").html(statusCdList[2]);
		$("#searchStatusCd").select2({
			placeholder: "<tit:txt mid='111914' mdef='선택'/>"
		});
        // 대상년도
        $("#searchWorkYy").val("${curSysYear}");

        // 숫자만 입력 받기
        $("#searchWorkYy").bind("keyup",function(event){
        	makeNumber(this,"A");
            if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
        });

//         $("#searchWorkYy").bind("keyup",function(event){
//             if( event.keyCode == 13){ doAction("Search"); $(this).focus(); }
//         });
        $(window).smartresize(sheetResize); sheetInit();
//         doAction("Search");

        sheet1.SetCellBackColor(0, "familyCnt1",  "#FFD7FD");
        sheet1.SetCellBackColor(0, "familyCnt2",  "#FFD7FD");
        sheet1.SetCellBackColor(0, "addChildCnt", "#FFD7FD");
        sheet1.SetCellBackColor(0, "spouseYn",    "#FFD7FD");
    });

    //Sheet Action
    function doAction(sAction) {
        switch (sAction) {
        case "Search":
			$("#searchStatusCdHidden").val(getMultiSelectValue($("#searchStatusCd").val()));
        	sheet1.DoSearch( "${ctx}/FamInfoMgr.do?cmd=getFamInfoMgrList", $("#sheet1Form").serialize() ); break;
        case "Save":
        	if(!dupChk(sheet1,"sabun|sdate", false, true)){break;}
        	IBS_SaveName(document.sheet1Form,sheet1);
        	sheet1.DoSave( "${ctx}/FamInfoMgr.do?cmd=saveFamInfoMgr", $("#sheet1Form").serialize()); break;
        case "Insert":      //sheet1.SelectCell(sheet1.DataInsert(0), 4);
                             var Row = sheet1.DataInsert(0);
                             sheet1.SetCellValue(Row, "statusCd","");
                             break;
        case "Copy":
			var Row = sheet1.DataCopy();
			sheet1.SelectCell(Row, 6);
			sheet1.SetCellValue(Row, "name", "");
			sheet1.SetCellValue(Row, "sabun", "");
			sheet1.SetCellValue(Row, "orgNm", "");
			sheet1.SetCellValue(Row, "alias", "");
			sheet1.SetCellValue(Row, "jikgubNm", "");
			sheet1.SetCellValue(Row, "jikweeNm", "");
			sheet1.SetCellValue(Row, "jikchakNm", "");
			sheet1.SetCellValue(Row, "statusCd", "");
            break;
        case "Clear":       sheet1.RemoveAll(); break;
		case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1,ExcelFontSize:"9",ExcelRowHeight:"20"};
			sheet1.Down2Excel(param);
			break;
		case "LoadExcel":   //엑셀업로드
			var params = {Mode:"HeaderMatch", WorkSheetNo:1};
			sheet1.LoadExcel(params);
			break;
		case "Down2Template":
			downCols = "sabun|foreignYn|handicapYn|womanYn|spouseYn|familyCnt1|familyCnt2|oldCnt1|oldCnt2|handicapCnt|childCnt|addChildCnt|sdate|edate";
			var param  = {DownCols:downCols,SheetDesign:1,Merge:1,DownRows:'0',ExcelFontSize:"9",TextToGeneral:1};
			sheet1.Down2Excel(param);
			break;
        }
    }

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } sheetResize(); } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }

    // 저장 후 메시지
    function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
        try { if (Msg != "") { alert(Msg); } } catch (ex) { alert("OnSaveEnd Event Error " + ex); }
    }

    // 셀에서 키보드가 눌렀을때 발생하는 이벤트
    function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
        try {
            // Insert KEY
            if (Shift == 1 && KeyCode == 45) {
                doAction("Insert");
            }
            //Delete KEY
            if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
                sheet1.SetCellValue(Row, "sStatus", "D");
            }
        } catch (ex) {
            alert("OnKeyDown Event Error : " + ex);
        }
    }

    function sheet1_OnClick(Row, Col, Value, CellX, CellY, CellW, CellH) {
    }

    //  Type이 POPUP인 셀에서 팝업버튼을 눌렀을때 발생하는 이벤트
    function sheet1_OnPopupClick(Row, Col){
        try{

          var colName = sheet1.ColSaveName(Col);
          // var args    = new Array();
		  //
          // args["name"]   = sheet1.GetCellValue(Row, "name");
          // args["sabun"]  = sheet1.GetCellValue(Row, "sabun");
		  //
          // var rv = null;

          if(colName == "name") {
			  let layerModal = new window.top.document.LayerModal({
				  id : 'employeeLayer'
				  , url : '/Popup.do?cmd=viewEmployeeLayer&authPg=${authPg}'
				  , parameters : {
					  name : sheet1.GetCellValue(Row, "name")
					  , sabun : sheet1.GetCellValue(Row, "sabun")
				  }
				  , width : 840
				  , height : 520
				  , title : '사원조회'
				  , trigger :[
					  {
						  name : 'employeeTrigger'
						  , callback : function(result){
							  sheet1.SetCellValue(Row, "name",   result.name);
							  sheet1.SetCellValue(Row, "alias",   result.alias);
							  sheet1.SetCellValue(Row, "sabun",   result.sabun);
							  sheet1.SetCellValue(Row, "jikgubNm",   result.jikgubNm);
							  sheet1.SetCellValue(Row, "jikweeNm",   result.jikweeNm);
							  sheet1.SetCellValue(Row, "orgNm",   result.orgNm);
							  sheet1.SetCellValue(Row, "statusCd",   result.statusCd);
						  }
					  }
				  ]
			  });
			  layerModal.show();



        	  <%--if(!isPopup()) {return;}--%>
        	  <%--gPRow = Row;--%>
        	  <%--pGubun = "employeePopup";--%>
              <%--var rv = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", args, "840","520");--%>
              /*
              if(rv!=null){
                  sheet1.SetCellValue(Row, "name",   rv["name"] );
                  sheet1.SetCellValue(Row, "sabun",  rv["sabun"] );

                  sheet1.SetCellValue(Row, "orgNm",     rv["orgNm"] );
                  sheet1.SetCellValue(Row, "statusCd",  rv["statusCd"] );
              }
              */
          }

        }catch(ex){alert("OnPopupClick Event Error : " + ex);}
    }

	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

	    if(pGubun == "employeePopup"){
            sheet1.SetCellValue(gPRow, "name",   rv["name"] );
            sheet1.SetCellValue(gPRow, "alias",   rv["alias"] );
            sheet1.SetCellValue(gPRow, "sabun",   rv["sabun"] );
            sheet1.SetCellValue(gPRow, "jikgubNm",   rv["jikgubNm"] );
            sheet1.SetCellValue(gPRow, "jikweeNm",   rv["jikweeNm"] );
            sheet1.SetCellValue(gPRow, "orgNm",   rv["orgNm"] );
            sheet1.SetCellValue(gPRow, "statusCd",   rv["statusCd"] );
	    }else if(pGubun == "orgBasicPopup"){
	    	$("#searchWorkOrgNm").val(rv["orgNm"]);
	    }
	}

    //  소속 조회 팝입
    function openOrgSchemePopup(){
        try{

			let layerModal = new window.top.document.LayerModal({
				id : 'orgLayer'
				, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
				, parameters : {}
				, width : 740
				, height : 520
				, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
				, trigger :[
					{
						name : 'orgTrigger'
						, callback : function(result){
							if(!result.length) return;
							$("#searchWorkOrgNm").val(result[0].orgNm);
						}
					}
				]
			});
			layerModal.show();


        	<%--var args    = new Array();--%>
        	<%--if(!isPopup()) {return;}--%>
        	<%--gPRow = "";--%>
        	<%--pGubun = "orgBasicPopup";--%>
            <%--var rv = openPopup("/Popup.do?cmd=orgBasicPopup&authPg=${authPg}", args, "740","520");--%>
            /*
            if(rv!=null){

            	$("#searchWorkOrgNm").val(rv["orgNm"]);
            }
            */
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

    // 숫자입력
    function checkNumber(event){
        if($(this).val()!="" && $(this).val().match(/[^0-9]/g) != null){
            $(this).val($(this).val().replace(/[^0-9]/g, ''));
            $(this).focus();
        }
    }

    function familyInfoCreate(){

        if($("#searchWorkYy").val() == "")
        {
            alert("<msg:txt mid='109674' mdef='대상년도를 입력하세요!'/>");
            return;
        }else{
        	var befWorkYy = parseInt($("#searchWorkYy").val(),10) - 1;
	        if (confirm(befWorkYy + " 년도 연말정산부양가족정보를 " + $("#searchWorkYy").val() +" 년도 개인별부양정보자료로 반영하시겠습니까?")) {

	        	var data = ajaxCall("/FamInfoMgr.do?cmd=prcFamilyInfoCreateCall","searchWorkYy="+$("#searchWorkYy").val(), false);
                alert("["+data.Result.pCnt+"]건의 자료가 생성되었습니다.");
	        }
        }
    }


    function getMultiSelectValue( value ) {
    	if( value == null || value == "" ) return "";
    	if (value.indexOf("m") == -1) return value+","; // 선택된 값이 한개일 경우 Dao에서 배열로 바뀌지 않아서 오류남 콤마 추가
    	////return "'"+String(value).split(",").join("','")+"'";
		return value;
    }

</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="sheet1Form" name="sheet1Form" >
	<input type="hidden" id="searchStatusCdHidden" name="searchStatusCdHidden" value="" />
            <div class="sheet_search outer">
		        <div>
		        <table>
		        <tr>
	                <th><tit:txt mid='104279' mdef='소속'/></th>
		            <td>
		                <input id="searchWorkOrgNm" name="searchWorkOrgNm" type="text" class="text" readOnly />
		                <a onclick="javascript:openOrgSchemePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
						<a onclick="$('#searchWorkOrgNm').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
		            </td>
	                <th><tit:txt mid='104330' mdef='사번/성명'/></th>
		            <td>
		                <input id="searchSabunName" name="searchSabunName" type="text" class="text" />
		            </td>
	                <th><tit:txt mid='104472' mdef='재직상태'/></th>
		            <td>
		                <select id="searchStatusCd" name ="searchStatusCd" multiple=""></select>
		            </td>
		            <td>
		                <btn:a css="button" onclick="javascript:doAction('Search');" mid='110697' mdef="조회"/>
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
                            <li id="txt" class="txt"><tit:txt mid='famInfoMgr' mdef='부양가족정보생성'/></li>
                            <li class="btn">
                            	<tit:txt mid='113461' mdef='대상년도'/><input id="searchWorkYy" name="searchWorkYy" maxlength="4" type="text" class="text date" />
                                <btn:a href="javascript:familyInfoCreate()" css="basic authA" mid='111651' mdef="부양가족정보 재생성"/>
                                <btn:a href="javascript:doAction('Down2Template')"			css="basic authA" mid='110702' mdef="양식다운로드"/>
								<btn:a href="javascript:doAction('LoadExcel')" 			css="basic authA" mid='110703' mdef="업로드"/>
                                <btn:a href="javascript:doAction('Insert')" css="basic authA" mid='110700' mdef="입력"/>
                                <btn:a href="javascript:doAction('Copy')"   css="basic authA" mid='110696' mdef="복사"/>
                                <btn:a href="javascript:doAction('Save')"   css="basic authA" mid='110708' mdef="저장"/>
                                <btn:a href="javascript:doAction('Down2Excel')"   css="basic authR" mid='110698' mdef="다운로드"/>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
            </td>
        </tr>
    </table>

</div>
</body>
</html>
