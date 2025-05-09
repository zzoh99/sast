<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<script type="text/javascript">
	var pId = "";
	var pGubun = "";

	function init_form(){

		//Sheet 초기화
		init_sheet1();
		
		doAction1("Search");

	}

	//Sheet 초기화
	function init_sheet1(){

		var initdata1 = {};
		initdata1.Cfg = {SearchMode:smLazyLoad,Page:22,MergeSheet:msHeaderOnly};
		initdata1.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:0};

		initdata1.Cols = [
			{Header:"컬럼명",		Hidden:0, SaveName:"columnNm" },
			{Header:"컬럼형태",	Hidden:0, SaveName:"columnTypeCd" },
			{Header:"컬럼형태",	Hidden:0, SaveName:"columnFormat" },
			{Header:"필수여부",	Hidden:0, SaveName:"keyfieldYn" }, 
			{Header:"컬럼넓이",	Hidden:0, SaveName:"columnWidth" , Format:"Number"},
			{Header:"입력최대값",	Hidden:0, SaveName:"maxLength" },
			{Header:"기본값",		Type:"Text", Hidden:0, SaveName:"defValue" },
			{Header:"컬럼위치",	Hidden:0, SaveName:"layoutSeq" },
			
			{Header:"Hidden",	Hidden:1, SaveName:"applCd" },
			{Header:"Hidden",	Hidden:1, SaveName:"seq" },
			{Header:"Hidden",	Hidden:1, SaveName:"searchItemCd" },
			{Header:"Hidden",	Hidden:1, SaveName:"popupItemCd" },
			{Header:"Hidden",	Hidden:1, SaveName:"nextSeq" },
			{Header:"Hidden",	Hidden:1, SaveName:"saveValue" },
			{Header:"Hidden",	Hidden:1, SaveName:"saveText" },
		]; IBS_InitSheet(sheet1, initdata1);

	}

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
			case "Search":
				sheet1.DoSearch( "${ctx}/ComAppFormMgr.do?cmd=getComAppFormMgrColViewList", $("#dataForm").serialize() );
				break;
		}
	}


	//---------------------------------------------------------------------------------------------------------------
	// sheet1 Event
	//---------------------------------------------------------------------------------------------------------------

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}
			$("#viewTable").html("");
			$("#hiddenList").html("");
			var strHtml = '<colgroup><col width="120px" /><col width="40%" /><col width="120px" /><col width="" /></colgroup><tr>';
			var hiddenList = ""; //히든
			
			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				if( sheet1.GetCellValue(i, "columnNm") != "" ){
					strHtml +="<th>"+sheet1.GetCellValue(i, "columnNm") +"</th>";
					if( sheet1.GetCellValue(i, "nextSeq") == "" ){
						strHtml +="<td colspan='3'>";	
					} else{
						strHtml +="<td>";
					}
					//=====================================================================
					var id = "data"+sheet1.GetCellValue(i , "layoutSeq");
					var _required = "";
					var _maxlength = "";
					var _columnWidth = "w90p";
					if( sheet1.GetCellValue(i, "keyfieldYn") == "Y" ) _required = " ${required}";
					if( sheet1.GetCellValue(i, "maxLength") != "" ) _maxlength = ' maxlength="'+sheet1.GetCellValue(i, "maxLength")+'"';
					if( sheet1.GetCellValue(i, "columnWidth") != "" && sheet1.GetCellValue(i, "columnWidth") <= 100) _columnWidth = ' w'+sheet1.GetCellValue(i, "columnWidth")+'"';
						
					switch (sheet1.GetCellValue(i , "columnTypeCd")) {
						case "Label": //라벨
							strHtml    += "<span id='span_"+id+"'>" + sheet1.GetCellValue(i, "defValue") + "</span>";
							hiddenList += '<input type="hidden" id="'+id+'" name="'+id+'" value="'+sheet1.GetCellValue(i, "defValue")+'"/>';
							break;
						case "Text": //텍스트
							strHtml += '<input type="text" id="'+id+'" name="'+id+'" class="${textCss} '+_required+' '+_columnWidth+'" ${readonly} '+_maxlength+' value="'+sheet1.GetCellValue(i, "defValue")+'"/>'; 
							break;
						case "Combo": //콤보박스
							var param = "searchItemCd="+sheet1.GetCellValue(i , "searchItemCd");
							var comboList = convCodeIdx( ajaxCall("${ctx}/PwrSrchInputValuePopup.do?cmd=getPwrSrchInputValueTmpList", param,false).data, " ",-1);
							strHtml += '<select id="'+id+'" name="'+id+'" class="${selectCss} '+_required+'" ${disabled}>';
							strHtml += comboList[2]+"</select>";
							break;
						case "TextArea": //텍스트
							strHtml += '<textarea id="'+id+'" name="'+id+'" rows="3" class="${textCss} w100p" ${readonly} '+_maxlength+'></textarea>';
							break;
						case "Popup": //팝업
							hiddenList += '<input type="hidden" id="'+id+'" name="'+id+'" value="'+sheet1.GetCellValue(i, "defValue")+'"/>';
							strHtml += '<input type="text" id="'+id+'Nm" name="'+id+'Nm" class="${textCss} '+_required+' '+_columnWidth+'" ${readonly} '+_maxlength+' value="" readonly />'; 
							strHtml += "<a href=\"javascript:onPopup('"+id+"','"+sheet1.GetCellValue(i, "popupItemCd")+"');\" class=\"button6\"><img src=\"/common/${theme}/images/btn_search2.gif\"/></a>"; 
							break;
					}
										
					

					//=====================================================================
					strHtml +="</td>";
				}	
				
				if( parseInt( sheet1.GetCellValue(i, "layoutSeq")) % 2 == 0 ){
					strHtml +="</tr><tr>";
				}							
			}
			if( strHtml.substring( strHtml.length -4) == "<tr>"){
				strHtml = strHtml.substring( 0, strHtml.length - 4);
			}else if( strHtml.substring( strHtml.length -5) == "</td>"){
				strHtml +="</tr>";
			}
			strHtml = replaceAll(strHtml, "<tr></tr>", "");
			
			$("#viewTable").html(strHtml);
			$("#hiddenList").html(hiddenList);
			

			for(var i = sheet1.HeaderRows(); i < sheet1.RowCount()+sheet1.HeaderRows() ; i++) {
				if( sheet1.GetCellValue(i, "columnNm") != "" && sheet1.GetCellValue(i, "columnFormat") != "N" ){  
					var id = "data"+sheet1.GetCellValue(i , "layoutSeq");
					switch (sheet1.GetCellValue(i , "columnFormat")) {
						case "Ymd": 
							$("#"+id).datepicker2();
							break;
						case "Ym": 
							$("#"+id).datepicker2({ymonly:true});
							break;
						case "Number": 
							$("#"+id).keyup(function() {
								makeNumber(this,'A');
							});
							break;
						case "Amt": 
							$("#"+id).mask('000,000,000,000,000', {reverse: true});
							break;
					}
				}
			}
			
		} catch (ex) {
			alert("OnSearchEnd Event Error : " + ex);
		}
		try{
			fnFormLoadEnd();
		} catch (e1) {}
	}
	
	function onPopup(id, gubun) {
		try {

			if(!isPopup()) {return;}

			if (gubun === "emp") {
				empSearchLayer(id);
			} else if (gubun === "org") {
				orgSearchLayer(id);
			} else if (gubun === "job") {
				jobSearchLayer(id);
			}
		} catch(e) {
			alert(e);
		}
	}

	// 사원검색 팝입
	function empSearchLayer(targetId) {
		new window.top.document.LayerModal({
			id : 'employeeLayer'
			, url : '/Popup.do?cmd=viewEmployeeLayer&authPg=R&sType=T'
			, parameters : {}
			, width : 840
			, height : 520
			, title : '사원 리스트 조회'
			, trigger :[
				{
					name : 'employeeTrigger'
					, callback : function(result){
						$("#"+targetId+"Nm").val(result.name);
						$("#"+targetId).val(result.sabun);
					}
				}
			]
		}).show();
	}

	// 조직검색 팝업
	function orgSearchLayer(targetId) {
		new window.top.document.LayerModal({
			id : 'orgLayer'
			, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R'
			, parameters : {}
			, width : 840
			, height : 800
			, title : '조직 리스트 조회'
			, trigger :[
				{
					name : 'orgTrigger'
					, callback : function(result){
						$("#"+targetId+"Nm").val(result[0].orgNm);
						$("#"+targetId).val(result[0].orgCd);
					}
				}
			]
		}).show();
	}

	// 직무검색 팝업
	function jobSearchLayer(targetId) {
		new window.top.document.LayerModal({
			id : 'jobPopupLayer'
			, url : '/Popup.do?cmd=jobPopup&authPg=R'
			, parameters: {}
			, width : 800
			, height : 800
			, title : "직무 리스트 조회"
			, trigger :[
				{
					name : 'jobPopupTrigger'
					, callback : function(result){
						$("#"+targetId+"Nm").val(result.jobNm);
						$("#"+targetId).val(result.jobCd);
					}
				}
			]
		}).show();
	}

</script>
	
        <div>
			<form name="dataForm" id="dataForm" method="post">
				<input type="hidden" id="searchApplCd" name="searchApplCd" />
				<div id="hiddenList" ></div>
		
				<table id="viewTable" class="table"></table>
			</form>
			<div class="hide">
				<script type="text/javascript"> createIBSheet("sheet1", "100%", "100%"); </script>
			</div>
        </div>
	
