<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="bodywrap"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">

	var p = eval("${popUpStatus}");
	var sheet = null;
	var selectRow   = "0";
	var checkedRow  = "0";
	var editFlag 	= "${editFlag}";
	var adminFlag 	= "${adminFlag}";
	var checkType = "CheckBox";

	$(function() {
		var arg = p.popDialogArgumentAll();
		if( arg != undefined ) {
			sheet 	= p.popDialogSheet(arg["sheet"]);
		}

        var selectRow	= sheet.GetSelectRow();
		var operator	= sheet.GetCellText(selectRow, "operator").toUpperCase();

		if(operator == "=") {
			checkType = "Radio";
		}

		//sheet = dialogArguments["sheet"];
		var initdata = {};
		initdata.Cfg = {SearchMode:smLazyLoad, MergeSheet:0, Page:22, FrozenCol:3, DataRowMerge:0};
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",		Type:"${sNoTy}",Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='benefitElemCd' mdef='항목코드'/>",	Type:"Text",	Hidden:0,	Width:100,			Align:"Center",	ColMerge:0,	SaveName:"code",	UpdateEdit:0},
			{Header:"<sht:txt mid='benefitElemNm' mdef='항목명'/>",		Type:"Text",	Hidden:0,	Width:470,			Align:"Left",	ColMerge:0,	SaveName:"codeNm",	UpdateEdit:0 },
			{Header:"<sht:txt mid='check' mdef='선택'/>",		Type:checkType,Hidden:0,	Width:50,			Align:"Center",	ColMerge:0,	SaveName:"sCheck",	Sort:0, KeyField:0,Format:"", 	PointCount:0,   UpdateEdit:1,   InsertEdit:0,   EditLen:2 }
		];
		IBS_InitSheet(sheet1, initdata); sheet1.SetEditable("${editable}");sheet1.SetVisible(true);sheet1.SetCountPosition(4);sheet1.SetEditableColorDiff (0);
	   // doAction("Search");
	   display();
	   //$(".date").datepicker2();

	   $( "#ym" ).datepicker2({ymonly:true});
	   $( "#sYm" ).datepicker2({ymonly:true});
	   $( "#eYm" ).datepicker2({ymonly:true});
	   $( "#ymd" ).datepicker2();
	   $( "#sYmd" ).datepicker2({startdate:"eYmd"});
	   $( "#eYmd" ).datepicker2({enddate:"sYmd"});

		$(".close").click(function() { p.self.close(); });
		$(window).smartresize(sheetResize); sheetInit();

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
		case "Search" : sheet1.DoSearch( "${ctx}/PwrSrchInputValuePopup.do?cmd=getPwrSrchInputValueTmpList", $("#sheet1Form").serialize() ); break;
		}
	}

	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") { alert(Msg); }
			sheetResize();
			/* 체크박스 세팅 */
			setCheckFromOpener() ;
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
	}

	function findName(){
        if( $("#findNm").val() == "") return;

        var Row = 0;
        if(sheet1.GetSelectRow() < sheet1.LastRow()){
            Row = sheet1.FindText("codeNm", $("#findNm").val(), sheet1.GetSelectRow()+1, 2);
        }else{
            Row = -1;
        }

        if(Row > 0){
            sheet1.SetCellEditable(Row,"codeNm",true);
            sheet1.SelectCell(Row, "codeNm");
            sheet1.SetCellEditable(Row,"codeNm",false);
        }else if(Row == -1){
            if(sheet1.GetSelectRow() > 1){
                Row = sheet1.FindText("codeNm", document.all.findName.value, 1, 2);
                if(Row > 0){
                    sheet1.SetCellEditable(Row,"codeNm",true);
                    sheet1.SelectCell(Row,"codeNm");
                    sheet1.SetCellEditable(Row,"codeNm",false);
                }
            }
        }
        document.all.findName.focus();
    }
	/**
     * 오프너에 상태에 따라 화면 Display 변경
     */
    function display(){

        var selectRow	= sheet.GetSelectRow();
		var operator	= sheet.GetCellText(selectRow, "operator").toUpperCase();
		var valueType	= sheet.GetCellValue(selectRow, "valueType");
		var searchItemCd= sheet.GetCellValue(selectRow, "searchItemCd");


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
        for(row = 1 ; row <= sheet1.LastRow() ; row++){
            sheet1.SetCellValue(row, "sCheck","0");
        }
        //$("#srchNm").val("");
        $("#eVal,#sVal,#eYmd,#sYmd,#eYm,#sYm,#ymd,#ym,#resNo,#vall,#srchNm").val("");
        $("#etcData,#valDesc").html("");
        //alert(2);
    }
    function checkLike(str,opt){
        var selectRow = sheet.GetSelectRow();
        if(sheet.GetCellText(selectRow, "operator").toUpperCase() == "LIKE"
           || sheet.GetCellText(selectRow, "operator").toUpperCase() == "NOT LIKE" ){
            if(opt == "front"){
                str = "'"+str+"%'";
            }else if(opt == "rear"){
                str = "'%"+str+"'";
            }else{
                str = "'%"+str+"%'";
            }
        }else if(sheet.GetCellText(selectRow, "operator").toUpperCase() == "IN"
           || sheet.GetCellText(selectRow, "operator").toUpperCase() == "NOT IN" ){
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

    function sheet1_OnCheckAllEnd(Col, Value){
    	if(sheet1.ColSaveName(Col) == "sCheck") {
    		for(var i = 1 ; i <= sheet1.LastRow() ; i++){
    			sheet1_OnClick(i, Col, Value);
    		}
    	}
    }

    function sheet1_OnClick(Row, Col, Value){
   		try{
    		selectRow = Row;
    	    var selectRow = sheet.GetSelectRow();
    	    if(sheet1.ColSaveName(Col) == "sCheck") {
    	        if(sheet.GetCellText(selectRow, "operator").toUpperCase() == "IN"
    	        || sheet.GetCellText(selectRow, "operator").toUpperCase() == "NOT IN"
    	        //|| adminFlag == "yes" //Admin이 호출한 경우=> adminFlag 사용할경우 무조건 ()
    	        ){
    	        	//alert(sheet.GetCellText(selectRow, "operator") + "<=====>"+ adminFlag);
    	            codeVal = "";
    	            codeDesc = "";
    	            for(row = 1 ; row <= sheet1.LastRow() ; row++){
    	                if(row != sheet1.GetSelectRow()){
    	                    if(sheet1.GetCellValue(row, "sCheck") == "1"){
    	                        codeVal = codeVal +",'"+ sheet1.GetCellValue(row, "code")+"'";
    	                        codeDesc = codeDesc +","+ sheet1.GetCellValue(row, "codeNm")+"";
    	                    }
    	                }else{
    	                    if(sheet1.GetCellValue(sheet1.GetSelectRow(), "sCheck") == "1"){
    	                        codeVal = codeVal +",'"+ sheet1.GetCellValue(sheet1.GetSelectRow(), "code")+"'";
    	                        codeDesc = codeDesc +","+ sheet1.GetCellValue(sheet1.GetSelectRow(), "codeNm")+"";
    	                    }
    	                }
    	            }

    	            if(sheet1.GetCellValue(sheet1.GetSelectRow(), "sCheck") == "0"){
    	            	$("#vall").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "code"));
    	            	$("#valDesc").html(sheet1.GetCellValue(sheet1.GetSelectRow(), "codeNm"));
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
   	                    sheet1.SetCellValue(checkedRow, "sCheck","0");
   	                }
   	                if(sheet1.GetCellValue(sheet1.GetSelectRow(), "sCheck") == "1"){
   	                	$("#vall").val(sheet1.GetCellValue(sheet1.GetSelectRow(), "code"));
    	            	$("#valDesc").html(sheet1.GetCellValue(sheet1.GetSelectRow(), "codeNm"));;
   	                }else{
   	                	$("#vall").val("");
    	            	$("#valDesc").html("");
   	                }
   	                checkedRow = sheet1.GetSelectRow();
    	     	}
    		}
    	}catch(ex){alert("OnClick Event Error : " + ex);}
 	}

    function winClose(){
    	p.window.close();
    }
    function setColVal(){
    	var ymd 		= $("#ymd").val();
    	var ym			= $("#ym").val();
    	var sYmd 		= $("#sYmd").val();
    	var eYmd 		= $("#eYmd").val();
    	var sYm 		= $("#sYm").val();
    	var eYm 		= $("#eYm").val();
    	var sVal 		= $("#sVal").val();
    	var eVal 		= $("#eVal").val();
    	var vall 		= $("#vall").val();
    	var valDesc 	= $("#valDesc").html();
    	var resNo		= $("#resNo").val();
        var etcData 	= $("#etcData").val();
        var likeOpt 	= $("input:radio[name='likeOpt']:checked").val()==""?"all":$("input:radio[name='likeOpt']:checked").val();
        var selectRow 	= sheet.GetSelectRow();

        if(sheet.GetCellText(selectRow, "operator").toUpperCase() == "BETWEEN"){
            if(sheet.GetCellValue(selectRow, "valueType") == "dfDateYmd"){
                if(sYmd != "" && eYmd != ""){
                    if(checkDateCtl("",sYmd, eYmd)){
                        sheet.SetCellValue(selectRow, "inputValue","'"+sYmd.split("-").join("")+"'" + " AND " + "'"+eYmd.split("-").join("")+"'");
                        sheet.SetCellValue(selectRow, "inputValueDesc",sYmd + "일에서 " + eYmd+"일까지");
                    }else{
                        return;
                    }
                }else if(sYmd == "" && eYmd == ""){
                    sheet.SetCellValue(selectRow, "inputValue",checkLike('','all'));
                    sheet.SetCellValue(selectRow, "inputValueDesc","");
                }else{
                    alert("<msg:txt mid='alertInputSdateEdate' mdef='시작일과 종료일을 입력하세요.'/>");
                    $("#eYmd").focus();
                    return;
                }
            }else if(sheet.GetCellValue(selectRow, "valueType") == "dfDateYm"){
                if(sYm != "" && eYm != ""){
                    if(checkDateCtl("",sYm, eYm)){
                        sheet.SetCellValue(selectRow, "inputValue","'"+sYm.split("-").join("")+"'" + " AND " + "'"+eYm.split("-").join("")+"'");
                        sheet.SetCellValue(selectRow, "inputValueDesc",sYm + "월에서 " + eYm+"월까지");
                    }else{
                        return;
                    }
                }else if(sYm == "" && eYm == ""){
                    sheet.SetCellValue(selectRow, "inputValue",checkLike('','all'));
                    sheet.SetCellValue(selectRow, "inputValueDesc","");
                }else{
                    alert("<msg:txt mid='alertInputSdateEdate' mdef='시작일과 종료일을 입력하세요.'/>");
                    document.all.eDateYm.focus();
                    return;
                }
            }else{
                sheet.SetCellValue(selectRow, "inputValue","'"+sVal+"'" + " AND " + "'"+eVal+"'");
                sheet.SetCellValue(selectRow, "inputValueDesc",sVal + "에서 " + eVal+"까지");
            }
        }else{
             if(sheet.GetCellValue(selectRow, "searchItemCd") != ""){
                sheet.SetCellValue(selectRow, "inputValue",checkLike(vall, likeOpt ));
                sheet.SetCellValue(selectRow, "inputValueDesc",valDesc);
            }else{
                if(sheet.GetCellValue(selectRow, "valueType") == "dfDateYmd"){
                    sheet.SetCellValue(selectRow, "inputValue","'"+ymd.split("-").join("")+"'");
                    sheet.SetCellValue(selectRow, "inputValueDesc",ymd);
                }else if(sheet.GetCellValue(selectRow, "valueType") == "dfDateYm"){
                    sheet.SetCellValue(selectRow, "inputValue","'"+ym.split("-").join("")+"'");
                    sheet.SetCellValue(selectRow, "inputValueDesc",ym);
                }else if(sheet.GetCellValue(selectRow, "valueType") == "dfIdNo"){
                    sheet.SetCellValue(selectRow, "inputValue","'"+resNo+"'");
                    sheet.SetCellValue(selectRow, "inputValueDesc",resNo);
                }else if(sheet.GetCellValue(selectRow, "valueType") == "dfNumber"){
                	sheet.SetCellValue(selectRow, "inputValue",etcData);
                    sheet.SetCellValue(selectRow, "inputValueDesc",etcData);
                }else{
                    if(sheet.GetCellText(selectRow, "operator").toUpperCase() == "IN"
                    || sheet.GetCellText(selectRow, "operator").toUpperCase() == "NOT IN"){
                        sheet.SetCellValue(selectRow, "inputValue","("+etcData+")");
                    }else{
                        sheet.SetCellValue(selectRow, "inputValue",checkLike(etcData,  likeOpt));
                    }
                    sheet.SetCellValue(selectRow, "inputValueDesc",etcData);
                }
            }
        }
        p.window.moveTo(2000,2000);
        winClose();
    }

	function setCheckFromOpener() {
		/* 코드항목 조회시 부모창의 값을 그대로 들고 와서 찍어보여준다. 편의성.. by JSG */
		if( sheet.GetCellValue(sheet.GetSelectRow(), "valueType") == "dfCode" ) {
			var codeList = "" ;
			var row = sheet.GetSelectRow();

			if(sheet.GetCellText(row, "operator").toUpperCase() == "IN"
            || sheet.GetCellText(row, "operator").toUpperCase() == "NOT IN")
			{

				/* IN 옵션의 경우는 괄호가 들어가므로 따로 분리 */
				deleteInOption = sheet.GetCellValue(row, "inputValue").substr( 1, sheet.GetCellValue(row, "inputValue").length-2 ) ;
				codeList = deleteInOption.replace(/'/g, "") ;
			}else{
				deleteInOption = sheet.GetCellValue(row, "inputValue") ;
				codeList = deleteInOption.replace(/'/g, "") ;
			}


			/* 체크 세팅 */
			codeList = codeList.split(",") ;
			for(var i = 0; i < codeList.length; i++) {
				sheet1.SetCellValue(sheet1.FindText("code", codeList[i]), "sCheck", 1) ;
			}

			var Row = 0;
			if (sheet1.GetSelectRow() <= sheet1.LastRow()) {Row = sheet1.FindText("code", codeList[0], 0, 2, 0);}
			if (Row > 0) {sheet1.SelectCell(Row,"code");}
			$("#srchNm").focus();

			/* HTML 박스 세팅 */
			//if(sheet.GetCellText(sheet.GetSelectRow(), "operator").toUpperCase() == "IN"
	        //    || sheet.GetCellText(sheet.GetSelectRow(), "operator").toUpperCase() == "NOT IN") {

			if(checkType == "Radio") {
				$("#vall").val( sheet.GetCellValue(row, "inputValue").replace(/'/g, ""));
			} else {
				$("#vall").val( sheet.GetCellValue(row, "inputValue") );
			}
           	$("#valDesc").html( sheet.GetCellValue(row, "inputValueDesc") );
			//}

		}
	}

	// 검색한 항목명을 sheet에서 선택
	function findName() {
		if ($("#srchNm").val() == "") return;
		var Row = 0;
		if (sheet1.GetSelectRow() <= sheet1.LastRow()) {
			Row = sheet1.FindText("codeNm", $("#srchNm").val(), sheet1.GetSelectRow()+ 1, 2, 0);
		}
		if (Row > 0) {sheet1.SelectCell(Row,"codeNm");}
		else {
			Row = sheet1.FindText("codeNm", $("#srchNm").val(), 0, 2, 0);
			if (Row > 0) {sheet1.SelectCell(Row,"codeNm");}
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
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li><tit:txt mid='114535' mdef='조회업무 조회'/></li>
		<li class="close"></li>
	</ul>
	</div>
	<form name="sheet1Form" id="sheet1Form">
		<input type="hidden" name="sqlSyntax" id="sqlSyntax">
		<input type="hidden" name="searchItemCd" id="searchItemCd" value="${searchItemCd}">
	</form>
	<div class="popup_main">
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

			<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%", "${ssnLocaleCd}"); </script>

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
<!-- 				<tr id="val2" class="hide"> -->
<!-- 					<th><tit:txt mid='selDataValue' mdef='선택값'/></th> -->
<!-- 					<td><textarea id="valDesc" row="4" style="width:98%" readonly></textarea></td> -->
<!-- 				</tr> -->
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

		<div class="popup_button outer">
		<ul>
			<li>
				<btn:a href="javascript:setColVal();" css="pink large" mid='110716' mdef="확인"/>
				<btn:a href="javascript:p.self.close();" css="gray large" mid='110881' mdef="닫기"/>
				<btn:a href="javascript:init();" css="gray large" mid='110754' mdef="초기화"/>
			</li>
		</ul>
		</div>
	</div>

</div>

</body>
</html>
