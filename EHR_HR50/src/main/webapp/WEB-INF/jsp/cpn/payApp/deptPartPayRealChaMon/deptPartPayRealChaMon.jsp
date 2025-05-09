<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
    $(function() {

//========================================================================================================================

		// 수당명 
		var deptPartPayAppBnCd = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getDeptPartPayAppBnCdList", false).codeList, "전체");
		$("#searchBenefitBizCd").html(deptPartPayAppBnCd[2]);
        
        // 최근급여일자 조회
		getCpnLatestPaymentInfo();

//========================================================================================================================

        var initdata = {};
        initdata.Cfg = {FrozenCol:4,SearchMode:smLazyLoad,Page:100};
        initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};
        initdata.Cols = [
            {Header:"No",					Type:"${sNoTy}",		Hidden:Number("${sNoHdn}"), Width:"${sNoWdt}",  Align:"Center", ColMerge:0, SaveName:"sNo" },
            {Header:"성명",					Type:"Text",				Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"name",				KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"사번",					Type:"Text",				Hidden:0,  Width:70,   Align:"Center",  ColMerge:0,   SaveName:"sabun",				KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:13 },
            {Header:"직위",					Type:"Text",			Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"jikweeNm",			KeyField:0,	Format:"",			PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:100 },
            {Header:"소속",					Type:"Text",				Hidden:0,  Width:140, Align:"Left",  ColMerge:0,   		SaveName:"orgNm",        		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"수당명",				Type:"Text",				Hidden:0,  Width:60,  	Align:"Center",  ColMerge:0,   SaveName:"benefitBizNm",  KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"지급총액",			Type:"Int",				Hidden:0,  Width:120,   Align:"Right",  ColMerge:0,   SaveName:"sumMon",      		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"급여일자",			Type:"Text",				Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,			SaveName:"payActionNm",	KeyField:0,	Format:"",	PointCount:0,	UpdateEdit:0,	InsertEdit:1,	EditLen:100 },
            {Header:"급여지급\n수당명",	Type:"Text",			Hidden:0,  Width:140, Align:"Left",  ColMerge:0,			SaveName:"elementNm",     KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:100 },
            {Header:"실지급금액",			Type:"Int",			Hidden:0,  Width:120,   Align:"Right",  ColMerge:0,   SaveName:"payMon205",      KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 },
            {Header:"차액",					Type:"Int",				Hidden:0,  Width:120,   Align:"Right",  ColMerge:0,   SaveName:"chaMon",      		KeyField:0,   CalcLogic:"",   Format:"",            PointCount:0,   UpdateEdit:0,   InsertEdit:0,   EditLen:10 }
            ];
        IBS_InitSheet(sheet1, initdata);
        sheet1.SetEditable("${editable}"); sheet1.SetEditableColorDiff(0); //편집불가 상관없이 기본색상 출력
		sheet1.SetVisible(true);sheet1.SetCountPosition(4);
        
		// 키업 조회
        $("#searchSabunName").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
        $("#searchOrgNm").bind("keyup",function(event){
            if( event.keyCode == 13){ doAction1("Search"); $(this).focus(); }
        });
        
        $(window).smartresize(sheetResize); sheetInit();
    });

    //Sheet1 Action
    function doAction1(sAction) {
        switch (sAction) {
        case "Search":			
        	// 필수값/유효성 체크
			if (!chkInVal(sAction)) {
				break;
			}
			
            sheet1.DoSearch( "${ctx}/GetDataList.do?cmd=getDeptPartPayRealChaMonList", $("#srchFrm").serialize() ); break;
        case "Down2Excel":
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param); break;	
		break;
        }
    }

    function chkInVal(sAction) {
        if ($("#searchPayActionCd").val() == "" ) {
            alert("급여일자를 선택하시기 바랍니다.");
            $("#searchPayActionNm").focus();
            return false;
        }
    
        return true;
    }
    

    // 최근급여일자 조회
	function getCpnLatestPaymentInfo() {
		var procNm = "최근급여일자";
		// 급여구분(C00001-00001.급여)
		var paymentInfo = ajaxCall("${ctx}/CpnQuery.do?cmd=getCpnQueryList", "queryId=getCpnLatestPaymentInfoMap&procNm="+procNm+"&runType=00001", false);

		if (paymentInfo.DATA != null && paymentInfo.DATA != "" && typeof paymentInfo.DATA[0] != "undefined") {
			$("#searchPayActionCd").val(paymentInfo.DATA[0].payActionCd);
			$("#searchPayActionNm").val(paymentInfo.DATA[0].payActionNm);

			if ($("#searchPayActionCd").val() != null && $("#searchPayActionNm").val() != "") {
				doAction1("Search");
			}
		} else if (paymentInfo.Message != null && paymentInfo.Message != "") {
			alert(paymentInfo.Message);
		}
	}
    
	// 급여일자 검색 팝입
	function payActionSearchPopup() {
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "payDayPopup";
		
		var w		= 850;
		var h		= 520;
		var url		= "/PayDayPopup.do?cmd=payDayPopup";
		var args	= new Array();

		args["runType"] = "00001"; // 급여구분(C00001-00001.급여)

		var result = openPopup(url+"&authPg=R", args, w, h);
		/*
		if (result) {
			var payActionCd	= result["payActionCd"];
			var payActionNm	= result["payActionNm"];

			$("#payActionCd").val(payActionCd);
			$("#payActionNm").val(payActionNm);
		}
		*/
    }

    	// 초기화
	function clearCode(num) {

		if(num == 1) {
			//급여일자
			$('#searchPayActionCd').val("");
			$('#searchPayActionNm').val("");
		}
    }
    
    function getReturnValue(returnValue) {

		var rv = $.parseJSON('{'+ returnValue+'}');

		if(pGubun == "payDayPopup"){
			$("#searchPayActionCd").val(rv["payActionCd"]);
			$("#searchPayActionNm").val(rv["payActionNm"]);
	    }		
	}  

    // 조회 후 에러 메시지
    function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
    	
        try {
            if (Msg != "") {
                alert(Msg);
            }
            sheetResize();
            
            // 차액 발생시 붉은색 적용
			for(var i=1 ; i<sheet1.RowCount()+1; i++){
				if( sheet1.GetCellValue(i,"chaMon") != '0'){
					sheet1.SetRowFontColor(i, "#FF0000");
				}
			}

        } catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
    }
    
    
    function sheet1_OnClick(Row, Col, Value) {
        try{

        }catch(ex){alert("OnClick Event Error : " + ex);}
    }


</script>
</head>
<body class="hidden">
<div class="wrapper">
    <form id="srchFrm" name="srchFrm" >
    <!-- 조회조건 -->    
        <div class="sheet_search outer">
            <div>
                <table>
                    <tr>
                     	<th>급여일자</th>
                        <td> 
                            <input type="hidden" id="searchPayActionCd" name="searchPayActionCd" value="" />
                            <input type="text" id="searchPayActionNm" name="searchPayActionNm" class="text required readonly" value="" readonly style="width:180px" />
                            <a href="javascript:payActionSearchPopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a> 
                            <a href="javascript:clearCode(1)" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
                        </td>
                        <th>수당명</th>
                        <td>
                            <select id="searchBenefitBizCd" name="searchBenefitBizCd" onchange="javascript:doAction1('Search');"></select>
                        </td>
                        <th>사번/성명 </th>
                        <td>
	                        <input id="searchSabunName" name ="searchSabunName" type="text" class="text" />
	                    </td>
	                    <th>소속</th>
                     	<td>
	                        <input id="searchOrgNm" name ="searchOrgNm" type="text" class="text" />
	                    </td>
	                    <th>차액분</th>
                        <td>
                            <input id="searchChaMon" name ="searchChaMon" type="checkbox"  value="Y"  class="text" />
                            <a href="javascript:doAction1('Search')" id="btnSearch" class="button">조회</a>
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
                            <li id="txt" class="txt">수당지급분급여일자비교</li>
                            <li class="btn">
                                <a href="javascript:doAction1('Down2Excel')" class="basic authR">다운로드</a>
                            </li>
                        </ul>
                    </div>
                </div>
                <script type="text/javascript">createIBSheet("sheet1", "100%", "100%","kr"); </script>
            </td>
        </tr>
    </table>
</div>
</body>
</html>