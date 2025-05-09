<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var sheet = null;
	var selectRow   = "0";
	var checkedRow  = "0";
	var editFlag 	= "${editFlag}";
	var adminFlag 	= "${adminFlag}";
	var checkType = "CheckBox";
	var arg = "";
    var operator  ="";
    var valueType  = "";
    var searchItemCd= ""; 
    var inputValue = "";
    var inputValueDesc = "";
    	
	$(function() {
		
        const modal = window.top.document.LayerModalUtility.getModal('pwrSrchInputValueLayer');
        arg = modal.parameters;
        
        operator  = arg.operator || "";
        valueType = arg.valueType || "";
        searchItemCd= arg.searchItemCd || "";
        inputValue = arg.inputValue.replace(/['"()]/g, "") || "";
        inputValueDesc= arg.inputValueDesc || "";

		if(arg.operator == "=") {
			checkType = "Radio";
		}

	    createIBSheet3(document.getElementById('pwrSrchInputValueLayerSheet-wrap'), "pwrSrchInputValueLayerSheet", "100%", "100%", "${ssnLocaleCd}");
	     
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:3, DataRowMerge:0 , AutoFitColWidth:'init|search|resize|rowtransaction'};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",	Type:"Text",	Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"code",	UpdateEdit:0},
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Text",	Hidden:0,	Width:470,			Align:"Left",	ColMerge:0,	SaveName:"codeNm",	UpdateEdit:0 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:checkType,			Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sCheck",	Sort:0, KeyField:0,Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:2 }
		];
		IBS_InitSheet(pwrSrchInputValueLayerSheet, initdata); pwrSrchInputValueLayerSheet.SetEditable("${editable}");pwrSrchInputValueLayerSheet.SetVisible(true);pwrSrchInputValueLayerSheet.SetCountPosition(4);pwrSrchInputValueLayerSheet.SetEditableColorDiff (0);
	   // doAction("Search");
	   display();
	   //$(".date").datepicker2();

	   $( "#ym" ).datepicker2({ymonly:true});
	   $( "#sYm" ).datepicker2({ymonly:true});
	   $( "#eYm" ).datepicker2({ymonly:true});
	   $( "#ymd" ).datepicker2();
	   $( "#sYmd" ).datepicker2({startdate:"eYmd"});
	   $( "#eYmd" ).datepicker2({enddate:"sYmd"});

		$(window).smartresize(sheetResize); sheetInit();
		
		var sheetHeight = $(".modal_body").height() - $(".sheet_search ").height()
				- $(".explain.inner").height() - 15;
		pwrSrchInputValueLayerSheet.SetSheetHeight(sheetHeight);
		
// 	   $(".hide").show();
// 	   $("#typeOne").hide();

		$("#srchNm").bind("keyup",function(event){if( event.keyCode == 13){findName();}});
	});

	function check_Enter(){
		if (event.keyCode==13){
			findName();
		}
	}

	function doAction1(sAction) {
		switch (sAction) {
		case "Search" : pwrSrchInputValueLayerSheet.DoSearch( "${ctx}/PwrSrchInputValuePopup.do?cmd=getPwrSrchInputValueTmpList", $("#pwrSrchInputValueLayerSheetForm").serialize() ); break;
		}
	}

	function pwrSrchInputValueLayerSheet_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			// sheetResize();
			/* 체크박스 세팅 */
			setCheckFromOpener() ;
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function findName(){
        if( $("#findNm").val() == "") return;

        var Row = 0;
        if(pwrSrchInputValueLayerSheet.GetSelectRow() < pwrSrchInputValueLayerSheet.LastRow()){
            Row = pwrSrchInputValueLayerSheet.FindText("codeNm", $("#findNm").val(), pwrSrchInputValueLayerSheet.GetSelectRow()+1, 2);
        }else{
            Row = -1;
        }

        if(Row > 0){
            pwrSrchInputValueLayerSheet.SetCellEditable(Row,"codeNm",true);
            pwrSrchInputValueLayerSheet.SelectCell(Row, "codeNm");
            pwrSrchInputValueLayerSheet.SetCellEditable(Row,"codeNm",false);
        }else if(Row == -1){
            if(pwrSrchInputValueLayerSheet.GetSelectRow() > 1){
                Row = pwrSrchInputValueLayerSheet.FindText("codeNm", document.all.findName.value, 1, 2);
                if(Row > 0){
                    pwrSrchInputValueLayerSheet.SetCellEditable(Row,"codeNm",true);
                    pwrSrchInputValueLayerSheet.SelectCell(Row,"codeNm");
                    pwrSrchInputValueLayerSheet.SetCellEditable(Row,"codeNm",false);
                }
            }
        }
        document.all.findName.focus();
    }
	/**
     * 오프너에 상태에 따라 화면 Display 변경
     */
    function display(){

        //var selectRow	= sheet.GetSelectRow();
	///var operator	= sheet.GetCellText(selectRow, "operator").toUpperCase();
		//var valueType	= arg.valueType || "";//sheet.GetCellValue(selectRow, "valueType");
		//var searchItemCd= arg.searchItemCd || "";// sheet.GetCellValue(selectRow, "searchItemCd");


// 		alert(operator+"_"+valueType+"_"+searchItemCd);
        if(operator == "BETWEEN"){
            if(valueType == "dfDateYmd"){ 		$("#betweenDateYmd").removeClass("hide");}
            else if(valueType == "dfDateYm"){ 	$("#betweenDateYm").removeClass("hide");}
            else{ 								$("#betweenValue").removeClass("hide"); }
            $("#typeTwo").removeClass("hide");
        }else{
        	if(searchItemCd != ""){
        		$("#searchItemCd").val(searchItemCd);
        		$("#typeOne").removeClass("hide");
        		doAction1("Search");


            }else{
                if(valueType == "dfDateYmd"){		$("#dateYmd").removeClass("hide");}
                else if(valueType == "dfDateYm"){	$("#dateYm").removeClass("hide");}
                else if(valueType == "dfIdNo"){		$("#res").removeClass("hide");}
                else{							$("#etc").removeClass("hide");}
                $("#typeTwo").removeClass("hide");
            }

        }
    }
    function init(){
    	//alert(1);
        for(row = 1 ; row <= pwrSrchInputValueLayerSheet.LastRow() ; row++){
            pwrSrchInputValueLayerSheet.SetCellValue(row, "sCheck","0");
        }
        //$("#srchNm").val("");
        $("#eVal,#sVal,#eYmd,#sYmd,#eYm,#sYm,#ymd,#ym,#resNo,#vall,#srchNm").val("");
        $("#etcData,#valDesc").html("");
        //alert(2);
    }
    function checkLike(str,opt){
    	
       // var selectRow = sheet.GetSelectRow();
        if(operator == "LIKE"
           || operator == "NOT LIKE" ){
            if(opt == "front"){
                str = "'"+str+"%'";
            }else if(opt == "rear"){
                str = "'%"+str+"'";
            }else{
                str = "'%"+str+"%'";
            }
        }else if(operator == "IN"
           || operator == "NOT IN" ){
            if(str.substring(0,1).indexOf("(") == -1 && str.substring(str.length-1).indexOf(")") == -1){
                str = "'"+str+"'";
            }else{
                str = str;
            }
        }else{// LIKE, NOT LIKE, IN, NOT IN이 아닐 시
            str = "'"+str+"'";
        }
        return str;
    }

    function pwrSrchInputValueLayerSheet_OnCheckAllEnd(Col, Value){
    	if(pwrSrchInputValueLayerSheet.ColSaveName(Col) == "sCheck") {
    		for(var i = 1 ; i <= pwrSrchInputValueLayerSheet.LastRow() ; i++){
    			pwrSrchInputValueLayerSheet_OnClick(i, Col, Value);
    		}
    	}
    }

    function pwrSrchInputValueLayerSheet_OnClick(Row, Col, Value){
    	
   		try{
   			
    		//selectRow = Row;
    	    //var selectRow = sheet.GetSelectRow();
    	    if(pwrSrchInputValueLayerSheet.ColSaveName(Col) == "sCheck") {
    	        if(operator == "IN" || operator == "NOT IN"
    	        //|| adminFlag == "yes" //Admin이 호출한 경우=> adminFlag 사용할경우 무조건 ()
    	        ){
    	        	//alert(sheet.GetCellText(selectRow, "operator") + "<=====>"+ adminFlag);
    	            codeVal = "";
    	            codeDesc = "";
    	            for(row = 1 ; row <= pwrSrchInputValueLayerSheet.LastRow() ; row++){
    	                if(row != pwrSrchInputValueLayerSheet.GetSelectRow()){
    	                    if(pwrSrchInputValueLayerSheet.GetCellValue(row, "sCheck") == "1"){
    	                        codeVal = codeVal +",'"+ pwrSrchInputValueLayerSheet.GetCellValue(row, "code")+"'";
    	                        codeDesc = codeDesc +","+ pwrSrchInputValueLayerSheet.GetCellValue(row, "codeNm")+"";
    	                    }
    	                }else{
    	                    if(pwrSrchInputValueLayerSheet.GetCellValue(pwrSrchInputValueLayerSheet.GetSelectRow(), "sCheck") == "1"){
    	                        codeVal = codeVal +",'"+ pwrSrchInputValueLayerSheet.GetCellValue(pwrSrchInputValueLayerSheet.GetSelectRow(), "code")+"'";
    	                        codeDesc = codeDesc +","+ pwrSrchInputValueLayerSheet.GetCellValue(pwrSrchInputValueLayerSheet.GetSelectRow(), "codeNm")+"";
    	                    }
    	                }
    	            }

    	            if(pwrSrchInputValueLayerSheet.GetCellValue(pwrSrchInputValueLayerSheet.GetSelectRow(), "sCheck") == "0"){
    	            	$("#vall").val(pwrSrchInputValueLayerSheet.GetCellValue(pwrSrchInputValueLayerSheet.GetSelectRow(), "code"));
    	            	$("#valDesc").html(pwrSrchInputValueLayerSheet.GetCellValue(pwrSrchInputValueLayerSheet.GetSelectRow(), "codeNm"));
    	            }
    	            if(codeVal.length > 1){
    	                $("#vall").val("("+codeVal.substring(1, codeVal.length)+")");
    	            	$("#valDesc").html(codeDesc.substring(1, codeDesc.length));
    	            }else{
    	            	$("#vall").val("");
    	            	$("#valDesc").html("");
    	            }
    	        }else{

   	                if(checkedRow != "" && checkedRow != 0){
   	                    pwrSrchInputValueLayerSheet.SetCellValue(checkedRow, "sCheck","0");
   	                }
   	                if(pwrSrchInputValueLayerSheet.GetCellValue(pwrSrchInputValueLayerSheet.GetSelectRow(), "sCheck") == "1"){
   	                	$("#vall").val(pwrSrchInputValueLayerSheet.GetCellValue(pwrSrchInputValueLayerSheet.GetSelectRow(), "code"));
    	            	$("#valDesc").html(pwrSrchInputValueLayerSheet.GetCellValue(pwrSrchInputValueLayerSheet.GetSelectRow(), "codeNm"));;
   	                }else{
   	                	$("#vall").val("");
    	            	$("#valDesc").html("");
   	                }
   	                checkedRow = pwrSrchInputValueLayerSheet.GetSelectRow();
    	     	}
    		}
    	}catch(ex){alert("OnClick Event Error : " + ex);}
    	
 	}

    function setColVal(){
    	
    	var returnValue = [];
    	
    	returnValue["ymd"]		= $("#ymd").val();
        returnValue["ym"]       = $("#ym").val();
        returnValue["sYmd"]     = $("#sYmd").val();
        returnValue["eYmd"]     = $("#eYmd").val();
        returnValue["sYm "]     = $("#sYm").val();
        returnValue["eYm "]     = $("#eYm").val();
        returnValue["sVal"]     = $("#sVal").val();
        returnValue["eVal"]     = $("#eVal").val();
        returnValue["vall"]     = $("#vall").val();
        returnValue["valDesc"]  = $("#valDesc").html();
        returnValue["resNo"]    = $("#resNo").val();
        returnValue["etcData"]  = $("#etcData").val();
        returnValue["likeOpt"]  = $("input:radio[name='likeOpt']:checked").val()==""?"all":$("input:radio[name='likeOpt']:checked").val();

        const modal = window.top.document.LayerModalUtility.getModal('pwrSrchInputValueLayer');
        modal.fire('pwrSrchInputValueTrigger', returnValue).hide();  

    }

	function setCheckFromOpener() {
		/* 코드항목 조회시 부모창의 값을 그대로 들고 와서 찍어보여준다. 편의성.. by JSG */
		
		if(valueType == "dfCode" ) {
			var codeList = "" ;

			/* 체크 세팅 */
			codeList = inputValue.split(",") ;
			for(var i = 0; i < codeList.length; i++) {
				pwrSrchInputValueLayerSheet.SetCellValue(pwrSrchInputValueLayerSheet.FindText("code", codeList[i]), "sCheck", 1) ;
			}

			var Row = 0;
			if (pwrSrchInputValueLayerSheet.GetSelectRow() <= pwrSrchInputValueLayerSheet.LastRow()) {Row = pwrSrchInputValueLayerSheet.FindText("code", codeList[0], 0, 2, 0);}
			if (Row > 0) {pwrSrchInputValueLayerSheet.SelectCell(Row,"code");}
			$("#srchNm").focus();

			if(checkType == "Radio") {
				$("#vall").val( inputValue);
			} else {
				$("#vall").val( inputValue );
			}
           	$("#valDesc").html( inputValueDesc );
		}
			
		
	}

	// 검색한 항목명을 sheet에서 선택
	function findName() {
		if ($("#srchNm").val() == "") return;
		var Row = 0;
		if (pwrSrchInputValueLayerSheet.GetSelectRow() <= pwrSrchInputValueLayerSheet.LastRow()) {
			Row = pwrSrchInputValueLayerSheet.FindText("codeNm", $("#srchNm").val(), pwrSrchInputValueLayerSheet.GetSelectRow()+ 1, 2, 0);
		}
		if (Row > 0) {pwrSrchInputValueLayerSheet.SelectCell(Row,"codeNm");}
		else {
			Row = pwrSrchInputValueLayerSheet.FindText("codeNm", $("#srchNm").val(), 0, 2, 0);
			if (Row > 0) {pwrSrchInputValueLayerSheet.SelectCell(Row,"codeNm");}
		}
		$("#srchNm").focus();
	}


	$(function(){
	  	$("#resNo:text").keydown(function(e){
	  		var position = 7;
			var text = $("#resNo").val();
			if(e.keyCode != 8 && e.keyCode != 9 && e.keyCode != 37 && e.keyCode != 39 && e.keyCode != 46){
		   		if(e.keyCode <= 48 || (e.keyCode > 57 && e.keyCode < 96) || e.keyCode > 105 || e.keyCode == 229){
			   		return false;
		   		}

				if(text.length == position-1){
					$("#resNo").val(text +"-");
				}
	   		}else{
	   			return false;
	   		}
	  	});
	});

	function checkDateCtl( message, sData, eData){
		if ( sData.split("-").join("") > eData.split("-").join("") ) {
			return false;
		}

		return true;
	}

</script>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<form name="pwrSrchInputValueLayerSheetForm" id="pwrSrchInputValueLayerSheetForm">
		<input type="hidden" name="sqlSyntax" id="sqlSyntax">
		<input type="hidden" name="searchItemCd" id="searchItemCd" value="${searchItemCd}">
	</form>
	<div class="modal_body">
		<!-- step1 -->
		<div id="typeOne" class="hide">
			<div class="sheet_search inner">
				<div>
					<table>
					<tr>
						<th><tit:txt mid='113804' mdef='찾을 항목명'/></th>
						<td>
							<input id="srchNm" type="text" class="text" />
						</td>
						<td>
							<a href="javascript:findName();" class="button"><tit:txt mid='104081' mdef='조회'/></a>
							<span class="info"><tit:txt mid='112389' mdef='글자를 입력 후 찾기를 누르면 해당 글자의 항목으로 포커스가 이동 됩니다.'/></span>
						</td>
					</tr>
					</table>
				</div>
			</div>

			<div class="h15 inner"></div>
            <div id="pwrSrchInputValueLayerSheet-wrap"></div>
			<!-- <script type="text/javascript"> createIBSheet("pwrSrchInputValueLayerSheet", "100%", "100%", "${ssnLocaleCd}"); </script> -->

			<div class="explain inner">
				<div class="title"><tit:txt mid='selDataValue' mdef='선택값'/></div>
				<div class="txt">
				<ul>
					<li>
					<div id="valDesc" class="scroll" style="height:60px;">
					</div>
					<input id="vall" type="hidden"/>
					</li>
				</ul>
				</div>
			</div>
		</div>

		<!-- step2 -->

		<!-- step3 -->
		<div id="typeTwo" class="hide">
			<div class="ibsheet" fixed="false" sheet_count="1" realHeight="100">
				<table class="table">
				<colgroup>
					<col width="120px" />
					<col width="" />
				</colgroup>

				<tr id="res" class="hide">
					<th><tit:txt mid='104206' mdef='주민등록번호'/></th>
					<td><input id="resNo" type="text" class="text" maxlength="14" style="width:20%"/></td>
				</tr>
				<tr id="etc" class="hide">
					<th><tit:txt mid='selDataValue' mdef='선택값'/></th>
					<td>
						<input id="etcData" type="text" class="text" size="30" maxlength="1000"  >
	                    <input name="likeOpt" type="radio" class="radio" value="all" checked>
	                    전체에서
	                    <input name="likeOpt" type="radio" class="radio" value="front">
	                    처음에서
	                    <input name="likeOpt" type="radio" class="radio" value="rear">
	                    끝에서
					</td>
				</tr>
				<tr id="dateYm" class="hide">
					<th><tit:txt mid='112390' mdef='년-월'/></th>
					<td><input id="ym" type="text" class="date2" />월</td>
				</tr>
				<tr id="dateYmd" class="hide">
					<th><tit:txt mid='114160' mdef='년-월-일'/></th>
					<td><input id="ymd" type="text" class="date2" />일</td>
				</tr>
				<tr id="betweenDateYm"  class="hide">
					<th><tit:txt mid='104420' mdef='기간'/></th>
					<td>
						<input id="sYm" type="text" class="date2" />월 부터
						<input id="eYm" type="text" class="date2" />월 까지
					</td>
				</tr>
				<tr id="betweenDateYmd" class="hide">
					<th><tit:txt mid='104420' mdef='기간'/></th>
					<td>
						<input id="sYmd" type="text" class="date2" />일 부터
						<input id="eYmd" type="text" class="date2" />일 까지
					</td>
				</tr>
				<tr id="betweenValue" class="hide">
					<th><tit:txt mid='104420' mdef='기간'/></th>
					<td>
						<input id="sVal" type="text" class="text" />부터
						<input id="eVal" type="text" class="text" />까지
					</td>
				</tr>
				</table>
			</div>
		</div>
	</div>
    <div class="modal_footer">
		<a href="javascript:closeCommonLayer('pwrSrchInputValueLayer');" class="btn outline_gray">닫기</a>
		<a href="javascript:setColVal();" class="btn filled">확인</a>
		<a href="javascript:init();" class="btn filled">초기화</a>
    </div>
</div>

</body>
</html>
