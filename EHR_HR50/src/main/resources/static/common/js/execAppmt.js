



var pPostitem = undefined, pPostitemNm = undefined, pPopupType = "";
var POST_ITEMS_PROP = {};
var getOrdType ="";



function setPostItemTable(data, sht, frm, ctx){

//	$("#ordTypeCd").editableCombo();
	// define func.

	var punishVal = convCode( ajaxCall(ctx+"/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=PUNISH_ORD_DETAIL_CD", "queryId=getSystemStdValue",false).codeList, "");
	var holVal = convCode( ajaxCall(ctx+"/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=REST_CHILD_ORD_DETAIL_CD", "queryId=getSystemStdValue",false).codeList, "");


	// 발령 종류별 각 항목이 필수여부, 항목여부를 조회해서 발령종류 > 발령항목 으로 계층구조로 정리한다.
	/****************************************************************************************************/
	var multiOrdTypeCd = function(){
		var rvalue = "";
		$("#ordTypeCd option", frm).each(function(){
			//console.log($(this).val());
			rvalue += ","+$(this).val();
		});
		if(rvalue.length>1)rvalue = rvalue.substring(1);
		return rvalue;
	};
	var tmpPostItemPropList = ajaxCall(ctx+"/ExecAppmt.do?cmd=getPostItemPropList","multiOrdTypeCd="+multiOrdTypeCd(),false).DATA;
	var tmpPostDetailTypeList = ajaxCall(ctx+"/ExecAppmt.do?cmd=getPostDetailTypeList","useYn=Y&multiOrdTypeCd="+multiOrdTypeCd(),false).DATA;//발령

	for(var val in tmpPostItemPropList){
		// 조회된 값을 발령종류 > 발령항목으로 정리한다.
		var step1key = tmpPostItemPropList[val].ordTypeCd;
		var step2key = tmpPostItemPropList[val].postItem;
		if(!POST_ITEMS_PROP[step1key])POST_ITEMS_PROP[step1key] = {};
		POST_ITEMS_PROP[step1key][step2key] = tmpPostItemPropList[val];
		step1key = null, step2key = null;
	}
	for(var val in tmpPostDetailTypeList){
		var step1key = tmpPostDetailTypeList[val].ordTypeCd;
		var step2key = "ordReasonList";
		if(!POST_ITEMS_PROP[step1key])POST_ITEMS_PROP[step1key] = {};
		if(!POST_ITEMS_PROP[step1key][step2key])POST_ITEMS_PROP[step1key][step2key] = [];
		POST_ITEMS_PROP[step1key][step2key].push(tmpPostDetailTypeList[val]);
		step1key = null, step2key = null;
	}
	tmpPostItemPropList = null, tmpPostDetailTypeList= null;
	/****************************************************************************************************/

	var tbl = frm.find("._postTable");
	//console.log(tbl);
	var obj = "", td = "", attr = "";
	var tdInd = 0;
	for(var i in data){
		var postItemId = convCamel(data[i].postItem+"_VALUE"), postItemNmId = convCamel(data[i].postItem+"_NM_VALUE");
		attr = "";
		if(tdInd==0) td = "<tr class='_postItemTr'>";
		td += "<th width='84px'>"+data[i].postItemNm+"</th>";
		//console.log(data[i]);
		// 읽기전용 여부
		if(data[i].readOnlyYn == "Y") attr += " disabled";
		//
		switch(data[i].cType){//COMBO,TEXT,CHECKBOX,POPUP,DATE //C|T|H|P|D
		case "C":
			var comboVals = convCode( codeList(ctx+"/CommonCode.do?cmd=getCommonCodeList",data[i].popupType), "");
			obj = "<select id='"+postItemId+"' name='"+postItemId+"' style='width:150px;' title='"+data[i].postItemNm+"' class='_postItem' "+attr+">"
				+ "<option value=''></option>"+comboVals[2];
				+ "</select>";
			obj += "<input type='text' id='"+postItemId+"_ronly' name='"+postItemId+"_ronly' class='text _postItem _ronly' readonly style='display:none;width:50px;'/>&nbsp;";
			obj += "<input type='text' id='"+postItemNmId+"' name='"+postItemNmId+"' class='text _postItem _ronly' readonly style='display:none;'/>";
			break;
		case "T":
			obj = "<input type='text' id='"+postItemId+"' name='"+postItemId+"' title='"+data[i].postItemNm+"' class='text _postItem' style='width:150px;' maxlength='"+data[i].limitLength+"' "+attr+"/>";
			break;
		case "H":
			obj = "<input type='checkbox' id='"+postItemId+"' name='"+postItemId+"' data='"+data[i].columnCd+"' title='"+data[i].postItemNm+"' class='_postItem' style='width:150px;' "+attr+"/>";
			break;
		case "P"://popup
			obj = " <input id='"+postItemId+"' name='"+postItemId+"' type='text' class='text _postItem' style='width:50px;' readonly />&nbsp;";
			obj += "<input id='"+postItemNmId+"' name='"+postItemNmId+"' type='text' class='text postItemPopupNm _postItem' style='width:"+(data[i].readOnlyYn != "Y"?"80":"130")+"px;' "+attr+"/>";
			if(data[i].readOnlyYn != "Y"){

				obj += " <a class='button6 postItemPopup _postItem'><img class='' data='"+data[i].popupType+"' src='/common/images/common/btn_search2.gif'/></a>";
				//obj += " <a href='#' class='button7'><img class='postItemPopup _clsPopup' src='/common/images/icon/icon_undo.png'/></a>";
			}

			break;
		case "D"://Date
			obj = "<input id='"+postItemId+"' name='"+postItemId+"' type='text' size='10' class='text date2 postItemDate _postItem' value=''/>";
			break;
		case "A"://textarea
			obj = "<textarea id='"+postItemId+"' name='"+postItemId+"' title='"+data[i].postItemNm+"' "+attr+"  class='_postItem' style='width:90%;' rows=2></textarea>";
			break;

		}
		if(data[i].mergeYn=="Y" && tdInd%2 == 0){
			tdInd++;
			td += "<td colspan=3>"+obj+"</td>";
		}else td += "<td>"+obj+"</td>";

		//tr level로 table에 append해준다.
		if(tdInd%2 == 1 || i == data.length){
			tbl.append(td+"</tr>");

			if(td.indexOf("colspan=3")>-1){ // merge 된 항목이 있으면 width 를 늘린다.

				$("#"+data[i].postItem).css({"width":"90%"});
			}
			td = "<tr class='_postItemTr'>";
		}
		tdInd ++;
	}
	 

	//event 등록

	// 공통팝업관련 event
	$(".postItemPopup", tbl).click(function(){

		if($(this).hasClass("_clsPopup")){
			// 공통팝업의 clear 버튼 클릭
			var tmp = $(this).parent().prev().prev(":input");//code input tag id
			tmp.val("").change();
			tmp.prev(":input").val("").change();
			tmp = null;
		}else if($(this).hasClass("_clsEmp")){
			$("#searchKeyword",tbl).val("").change();
			$("#sabun",tbl).val("").change();
			$("#name",tbl).val("").change();
			//사원조회의 clear 버튼 클릭
			$("._postItemTr :input",tbl).each(function(){
				try {
					if($(this).attr("disabled") != "disabled") {
						//console.log($(this).attr("disabled") + ":" + $(this)[0].tagName);
						$(this).val("").change();
					}
				} catch(e) {
					//console.log(e);
				}

			});

		}else{
			
			pGubun = "";
			pPostitem = $(this).prev(":input").prev(":input").attr("id");//code input tag id
			pPostitemNm = $(this).prev(":input").attr("id");
			var popupType = POST_ITEMS_CD[pPostitem].popupType;
			switch(popupType){
			case "JOB":
				//var param = {"findJob":$("#"+pPostitemNm).val()};
				//openPopup("/Popup.do?cmd=jobSchemePopup&authPg=R", param, "740","800");
				let p = {};
				if(pEnterKey=="Y"){
					p = {
						searchJobNm : $("#"+pPostitemNm).val()
					};
				}

				// openPopup("/popup.do?cmd=jobPopup&authPg=R", param, "800","800");

				var jobPopupLayer = new window.top.document.LayerModal({
					id : 'jobPopupLayer'
					, url : '/Popup.do?cmd=jobPopup&authPg=R'
					, parameters: p
					, width : 800
					, height : 800
					, title : "직무 리스트 조회"
					, trigger :[
						{
							name : 'jobPopupTrigger'
							, callback : function(result){
								console.log('result', result);
								$("#"+pPostitem).val(result.jobCd).change();
								$("#"+pPostitem).next(":input").val(result.jobNm).change();
							}
						}
					]
				});
				jobPopupLayer.show();

				break;
			case "ORG":

				// openPopup("/Popup.do?cmd=orgBasicPopup&authPg=R", param, "840","800");

				let orgLayer = new window.top.document.LayerModal({
					id : 'orgLayer'
					, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=R'
					, parameters : {
						searchOrgNm : $("#"+pPostitemNm).val()
					}
					, width : 840
					, height : 800
					, title : '조직 리스트 조회'
					, trigger :[
						{
							name : 'orgTrigger'
							, callback : function(result){
								$("#"+pPostitem).val(result[0].orgCd).change();
								$("#"+pPostitem).next(":input").val(result[0].orgNm).change();
								$("#"+convCamel(POST_ITEMS_COL_CD["LOCATION_CD"]+"_value")).val(result[0].locationCd);
								$("#"+convCamel(POST_ITEMS_COL_CD["LOCATION_CD"]+"_value")).change();
							}
						}
					]
				});
				orgLayer.show();
				
				break;
			case "LOCATION":
				//var param = {"codeNm":$("#"+pPostitemNm).val()}
				var param = "";
				if(pEnterKey=="Y"){
					param = {"codeNm":$("#"+pPostitemNm).val()}
				}
				// openPopup("/LocationCodePopup.do?cmd=viewLocationCodePopup&authPg=R", param, "740","800");

				let locationLayer = new window.top.document.LayerModal({
					id : 'locationCodeLayer'
					, url : "/LocationCodePopup.do?cmd=viewLocationCodeLayer&authPg=R"
					, parameters: {}
					, width : 450
					, height : 700
					, title : "근무지검색"
					, trigger :[
						{
							name : 'locationCodeLayerTrigger'
							, callback : function(rv){
								$("#"+pPostitem).val(rv["code"]).change();
								$("#"+pPostitem).next(":input").val(rv["codeNm"]).change();
							}
						}
					]
				});
				locationLayer.show();

				break;
			case "ENTER":
				//var param = {"codeNm":$("#"+pPostitemNm).val()}
				var param = "";
				
				if(pEnterKey=="Y"){
					param = {"codeNm":$("#"+pPostitemNm).val()}
				}
				
				openPopup("/Popup.do?cmd=viewCorpInfoPopup&authPg=R", param, "740","520");
				break;
			case "WORKORG":
				//var param = {"findOrg":$("#"+pPostitemNm).val()};
				var param = "";
				
				if(pEnterKey=="Y"){
					param = {"findOrg":$("#"+pPostitemNm).val()}
				}
				
				openPopup("/View.do?cmd=viewOrgTreeSubPopup&authPg=R", param, "740","800");
				break;
			case "GRP":

				let authGrpLayer = new window.top.document.LayerModal({
					  id : 'authGrpLayer'
					, url : '/Popup.do?cmd=viewAuthGrpLayer'
					, parameters : {}
					, width : 640
					, height : 460
					, title : '권한 그룹 조회'
					, trigger :[
						{
							name : 'authGrpTrigger'
							, callback : function(result){
								$("#"+pPostitem).val(result.grpCd).change();
								$("#"+pPostitem).next(":input").val(result.grpNm).change();
								$("#"+convCamel(POST_ITEMS_COL_CD["GRP_CD"]+"_value")).val(result.grpCd);
								$("#"+convCamel(POST_ITEMS_COL_CD["GRP_CD"]+"_value")).change();
							}
						}
					]
				});
				authGrpLayer.show();
				break;

			default:
				var param = {"codeNm":"", "grpCd":popupType}
				
				if(pEnterKey=="Y"){
					param = {"codeNm":$("#"+pPostitemNm).val(), "grpCd":popupType}
					
				}
				openPopup("/Popup.do?cmd=commonCodePopup&authPg=R", param, "740","800");


			}
		}
		pEnterKey ="";
	});
	
	// change event
	$(":input",tbl).change(function(){
		if(sht.GetSelectRow()>1){
			if($(this).attr("id") == "ordTypeCd"){
				setOrdTypeCd($(this),tbl, sht.GetCellValue(sht.GetSelectRow(),"ordDetailCd")); // 선택한 발령값에 따라 필수여부 , 입력항목(enable or disable) 처리

				//var ordReasonCd ;
				var ordType = $(this).val();
				if(sht.GetCellValue (sht.GetSelectRow(), "sStatus") == "I" && ordType == 'A') {
					alert("채용발령은 채용기본사항등록 후 발령연계처리로 발령처리 하여아 합니다.");
					$(this).val("");					
					//모든 발령 항목 disable 시키기
					$("._postItemTr :input",tbl).attr("disabled",true).removeClass("required");
					$("._postItemTr img",tbl).hide();
					$("._postItemTr a",tbl).hide();
					return;
				}
				
				if(ordType != ""){
					var ordTypeYn = ajaxCall(ctx+"/ExecAppmt.do?cmd=getOrdTypeYn","ordTypeCd="+ordType,false).DATA.ordTypeYn;
					if(sht.GetCellValue (sht.GetSelectRow(), "sStatus") == "I"  && ordTypeYn =='N'){
						alert("해당발령의 발령 담당자가 아닙니다. \n\n [ 발령처리 담당자 지정 ] \n 1. 전체발령 담당자 지정 : 인사관리>발령정보>기본설정>발령처리담당자관리 등록 \n 2. 발령별 담당자 지정 : 인사관리>발령정보>기본설정>발령코드관리>발령처리담당자 등록");
						$(this).val("");
						return;
					}
					
					/* 버그 수정 [발령처리]
					- 입사, 휴직, 복직, 퇴직 : 재직상태가 변경되는 발령의 경우, 화면에 자동 세팅되지 않고 프로시저에서 THRM151.STATUS_CD강제 조정
					- 이슈 : 담당자가 발령처리 시, 재직상태를 지정하지 않으면 데이터가 상이해짐. THRM223(재직) ≠ THRM151, THRM191(휴직) 
					=> 조치 : 발령코드가 변경되면, 재직상태 자동세팅 */
					if(!$(this).is(":disabled")) { //ordTypeCd를 확정하여 저장하면 PK이기 때문에 수정불가=>좌측시트의 클릭 이벤트에 따라 기존 자료를 조회한 때에는 사용자가 지정했던 재직상태 유지 20220530
					    var param = "ordTypeCd=" + ordType
					                + "&sabun=" + sht.GetCellValue (sht.GetSelectRow(), "sabun")
					                + "&ordYmd=" + $("#ordYmd").val() ;
					    var retData = ajaxCall(ctx+"/ExecAppmt.do?cmd=getOrdTypeStatusCd",param,false);
					    if (retData != null && retData != "") {
					    	if (retData.DATA.statusCd != null && retData.DATA.statusCd != "") {
								sht.SetCellValue (sht.GetSelectRow(), convCamel(retData.DATA.itemFieldValue), retData.DATA.statusCd);
								sht.SetCellValue (sht.GetSelectRow(), convCamel(retData.DATA.itemFieldNm), retData.DATA.statusNm);
								$("#" + convCamel(retData.DATA.itemFieldValue)).val(retData.DATA.statusCd);
							}
						}
					}
				}
				
				/**주부서 체크 */
				/*
				var sabun =sht.GetCellValue (sht.GetSelectRow(), "sabun");
				var mainCnt = ajaxCall(ctx+"/ExecAppmt.do?cmd=getMainDeptCnt","searchSabun="+sabun,false).DATA.mainDeptCnt;
				
				if(mainCnt >0){
						$("#item19Value",tbl).attr("disabled",true);
						
				}else{
					
					$("#item19Value",tbl).attr("disabled",false);
				}
					*/
				/*
				if(ordType != null){
					ordReasonCd  = convCode( codeList(ctx+"/CommonCode.do?cmd=getCommonCodeList&note1="+ordType, "H40110"), " ");
				}
				$("#ordReasonCd").html(ordReasonCd[2]);
				*/
				// 징계발령
				

				//alert("푸니쉬: " + punishVal[0])
				//alert("홀: " + holVal[0])
				
				//if($(this).val() == "W"){
				if($(this).val() == punishVal[0]){
					$("#dataTable").show();
				}else{
					$("#dataTable").hide();
				}
				

			}

			// 육아휴직
			
			if($(this).attr("id") == "ordDetailCd"){
				//if($(this).val() == "C01"){
				if($(this).val() == holVal[0]){
					$("#dataGdaTable").show();
				}else{
					$("#dataGdaTable").hide();
				}
			}
			
			
			/* 
			if($(this).attr("id") == "item19Value"){
				
				if($(this).prop("checked")){
					var sabun =sht.GetCellValue (sht.GetSelectRow(), "sabun");
					var mainCnt = ajaxCall(ctx+"/ExecAppmt.do?cmd=getMainDeptCnt","searchSabun="+sabun,false).DATA.mainDeptCnt;
					
					if(mainCnt >0){
						alert("주부서 여부가 타사에 등록되어있습니다.");	
						$(this).attr('checked',false);
						return;
					}
				}
			}
			*/

			if($(this).attr("id") == "ordYmd" || $(this).attr("id") == "ordDetailCd" ){
				setAddOrdDetail();
			}
			
			
			
			if($(this).attr("id") == "sabun"){
				
				var sabun = $(this).val();
				var mainCnt = ajaxCall(ctx+"/ExecAppmt.do?cmd=getMainDeptCnt","searchSabun="+sabun,false).DATA.mainDeptCnt;
				
				if(mainCnt >0){
					
					$("#item19Value",tbl).attr("disabled",true);
				}else{
					$("#item19Value",tbl).attr("disabled",false);
				}
				
			}

			if(sht.GetCellValue(sht.GetSelectRow(),"sStatus") == "I" && ( $(this).attr("id") == "ordYmd" || $(this).attr("id") == "sabun" ) ){

				setApplySeq(tbl, ctx, sht);
			}
			var cellId = $(this).attr("id");
			if($(this).hasClass("postItemDate")){
				
				//숫자키 입력시 오류 -> blur event에서 처리하는것으로 수정
				//sht.SetCellValue(sht.GetSelectRow(),cellId,$(this).val());
				
			} else{
				if($(this).is("select") && POST_ITEMS_CD[cellId]){
					var postItemNmId = convCamel(POST_ITEMS_CD[cellId].postItem+"_NM_VALUE");
					if(postItemNmId) sht.SetCellValue(sht.GetSelectRow(),postItemNmId,$(this).find(":selected").text());
				}

				if($(this).attr('type') == "checkbox"){

					if($(this).prop("checked")){
						sht.SetCellValue(sht.GetSelectRow(),cellId,'Y');
					}else{
						sht.SetCellValue(sht.GetSelectRow(),cellId,'N');
					}

				}else{
					sht.SetCellValue(sht.GetSelectRow(),cellId,$(this).val());
					if($(this).hasClass("postItemPopupNm")){
						var postItemNmId = cellId.replace("Nm", "");						
						if($(this).val() == "") {if(postItemNmId) sht.SetCellValue(sht.GetSelectRow(),postItemNmId,"");}
					}
				}
			}
		}
		/*
		console.log(convCamel($(this).attr("id"))+"");
		console.log(sht.GetSelectRow());
		console.log($(this).val());
		*/
	});
	//달력
	$(".postItemDate", tbl).each(function(){
		$(this).datepicker2({
			onReturn:function (d) {
				if($(this).attr("id") == "ordYmd") {
					sht.SetCellValue(sht.GetSelectRow(), "ordYmd", d);
					setAddOrdDetail();
					setApplySeq(tbl, ctx, sht);
				} else {
					sht.SetCellValue(sht.GetSelectRow(), $(this).attr("id"), d);
				}
			}
		});
	});
	
	//날짜 입력
	$(".postItemDate", tbl).bind("blur",function(date){
		var cellId = $(this).attr("id");
		sht.SetCellValue(sht.GetSelectRow(),cellId,$(this).val());
	});
	
	var pEnterKey="";
	//팝업 keyup event
	$(".postItemPopupNm", tbl).bind("keypress",function(event){
		$(this).prev(":input").val("");
		if( event.keyCode == 13){
			pEnterKey ="Y";
			$(this).next("a").trigger("click");
			
		}
	});
	/**********************************************************************************************************/
	//사원검색
	var inputId = "searchKeyword";
	//var url = "/Employee.do?cmd=employeeList&searchSheetYn=Y";
	var url = "/Employee.do?cmd=employeeList&searchEnterCd=" + ssnEnterCd;
	var formId = frm.attr("id");
	$("#"+inputId, frm).autocomplete(postEmployeeOption(inputId,url,formId,function(){
		//employeeResponse
		return {
			label: item.empName + ", " + item.enterCd  + ", " + item.enterNm,
			searchNm : $("#"+inputId).val(),
			empName :	item.empName,	// 회사명
			enterCd :	item.enterCd,	// 회사코드
			enterNm :	item.enterNm,	// 사원명
			empSabun :	item.empSabun,	// 사번
			orgNm :		item.orgNm,		// 조직명
			jikweeNm :	item.jikweeNm,	// PAYBAND
			resNo : 	item.resNo,		// 주민번호
			resNoStr:	item.resNoStr,	// 주민번호 앞자리
			statusNm :	item.statusNm,	// 재직/퇴직
			birDt :	item.birDt,	// 재직/퇴직
			value :		item.empName
		};
	},function(event, ui, frm){
		//var frm = $("#"+formId);
		//employeeReturn
		$("#sabun",frm).val(ui.item.empSabun).change();
		$("#name",frm).val(ui.item.empName).change();
		getPostInfo(ui.item.empSabun,frm);
	}))
	.data("uiAutocomplete")
	._renderItem = function(ul,item){
		return $("<li />")
		.data("item.autocomplete", item)
		.append("<a class='employeeLIst'>"
		//+"<span class='list_txt0'>"+item.empName+"</span>"
		//+"<span class='list_txt0'>"+String(item.empName).split(item.searchNm).join('<b>'+item.searchNm+'</b>')+item.birDt+"</span>"
		// +"<span style='display:inline-block;width:50px;'>"+item.resNoStr+"</span>"
		// +"<span style='display:inline-block;width:100px;'>"+item.enterNm+"</span>"
//		+"<span class='list_txt1'>"+item.empSabun+"</span>"
//		+"<span class='list_txt2'>"+item.orgNm+"</span>"
//		+"<span class='list_txt3'>"+item.jikweeNm+"</span>"
//		+"<span class='list_txt4'>"+item.statusNm+"</span>"
//		+"</a>").appendTo(ul);
		
		+"<div class='inner-wrap'>"
        +"<span class='name'>"+String(item.empName).split(item.searchNm).join('<b class="f_blue f_bold">'+item.searchNm+'</b>')+"<br/>"+item.orgNm+"</span><span class='sabun'>["+item.empSabun+"]<br/>"+item.jikweeNm+"</span>"
        +"<span class='ml-auto status'>"+item.statusNm+"</span>"
        +"</div>"
        +"</a>").appendTo(ul);
	};
	/**********************************************************************************************************/

	//최초 로드시 발령항목 disable 함
	clearAndDisable(tbl);




}

function setApplySeq(tbl, ctx, sht) {
	if( $("#ordYmd",tbl).val().length == 10 && $("#sabun",tbl).val() != "" ){
		
		if($("#ordTypeCd").val() == "" || $("#ordTypeCd").val() == null) {
		    //발령 코드가 지정되지 않은 상태면 항목별 수정가능 여부가 아직 세팅되지 않았기 때문에, 사용자가 등록한 항목이 없음. 발령정보를 곧바로 초기화한다.
			getPostInfo($("#sabun",tbl).val());
		} else if(confirm($("#name").val() + "님의 " + $("#ordYmd").val() + " 기준 발령정보를 불러올까요?")) {
		    //발령 코드가 지정된 상태면, 사용자가 변경한 항목이 있을 수 있기 때문에 confirm창을 띄운다.
		  	getPostInfo($("#sabun",tbl).val());
		}
        
		var params = {"ordYmd":$("#ordYmd",tbl).val(), "ordTypeCd":$("#ordTypeCd",tbl).val(), "sabun":$("#sabun",tbl).val()};
		var applySeq = ajaxCall(ctx+"/ExecAppmt.do?cmd=getMaxApplySeq",params,false).DATA.applySeq;
		var arrRows = sht.FindStatusRow("I").split(";");
		//console.log(arrRows);
		for(var i in arrRows){
			var row = arrRows[i];
			if(row == sht.GetSelectRow())continue;

			if(sht.GetCellValue(row,"sabun") == $("#sabun",tbl).val()
					&& sht.GetCellText(row,"ordYmd") == $("#ordYmd",tbl).val()){
				if( Number(sht.GetCellValue(row,"applySeq")) >= Number(applySeq) ){
					applySeq = Number(sht.GetCellValue(row,"applySeq"))+1;
				}
			}
		}
		sht.SetCellValue(sht.GetSelectRow(),"applySeq",applySeq);
	}
}

//선택한 사원의 최근발령정보 조회 후 화면에 보여줌
function getPostInfo(sabun,frm){
//alert("asdf");
	//var params = "cmd=getEmployeePostInfo&sabun="+sabun+"&sortYn=N";
	var strOrdYmd = $("#ordYmd").val().replace(/-/gi, "");
	var params = "cmd=getEmployeePostInfo&sabun="+sabun+"&sortYn=N&ordYmd="+strOrdYmd;
	//alert(params)
	// EncParams 함수를 통한 파라미터 보안 처리
	//params = EncParams(params);

	$.ajax({
		url :"ExecAppmt.do?cmd=getEmployeePostInfo",
		dateType : "json",
		type:"post",
		data: params,
		async: false,
		success: function( data ) {
			//console.log(data)
			//alert(JSON.stringify(data))
			if(data.DATA && data.DATA.length>0){
				$("._postItemTr :input",$("#dataForm")).each(function(){

					//조직장(권한)등록 필드 제외
					if($(this).attr("id") == "item18Value") {
						$(this).prop("checked", false).change();
						return true;
					}

					if($(this).prop("type") == "checkbox") {
						if(data.DATA[0][$(this).attr("id")+""] == "Y") {
							$(this).prop("checked", true).change();
						}
					} else {
						$(this).val(data.DATA[0][$(this).attr("id")+""]);
						try {
							$(this).change();
							$(this).blur();
						} catch(e) {}
					}
				});
			}

		}
	});
	//
}
//발령사원검색
function postEmployeeOption(inputId,url,formId,employeeResponse,employeeReturn) {
	return {
		source: function( request, response ) {

			var params = $("#"+formId).serialize();

			// EncParams 함수를 통한 파라미터 보안 처리
			//params = EncParams(params);

			$.ajax({
				url :url,
				dateType : "json",
				type:"post",
				data: params,
				async: false,
				success: function( data ) {
					response( $.map( data.DATA, function( item ) {
						return {
							label: item.empSabun + ", " + item.enterCd  + ", " + item.enterNm,
							searchNm : $("#"+inputId).val(),
							enterNm :	item.enterNm,	// 회사명
							enterCd :	item.enterCd,	// 회사코드
							empName :	item.empName,	// 사원명
							empSabun :	item.empSabun,	// 사번
							orgNm :		item.orgNm,		// 조직명
							jikweeNm :	item.jikweeNm,	// PAYBAND
							resNo : 	item.resNo,		// 주민번호
							resNoStr:	item.resNoStr,	// 주민번호 앞자리
							statusNm :	item.statusNm,	// 재직/퇴직
							birDt :	item.birDt,	// 재직/퇴직
							value :		item.empName
						};
					}));
				}
			});
		},
		delay:50,
		minLength: 1,
		select: employeeReturn,
		focus: function() {
			return false;
		},
		open: function() {
			$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
		},
		close: function() {
			$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
		}
	};
}
//popup return
function getReturnValue(returnValue) {
	var popupType = POST_ITEMS_CD[pPostitem].popupType;

	if (popupType == "ORG") {
		$("#"+pPostitem).val(returnValue.orgCd).change();
		$("#"+pPostitem).next(":input").val(returnValue.orgNm).change();
		$("#"+convCamel(POST_ITEMS_COL_CD["LOCATION_CD"]+"_value")).val(returnValue.locationCd);
		$("#"+convCamel(POST_ITEMS_COL_CD["LOCATION_CD"]+"_value")).change();
	} else {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun == "processNoMgr") {
			$("#searchProcessNo").val(rv.processNo);
			$("#searchProcessTitle").val(rv.processTitle);
			doAction1("Search");
		}else if(pGubun == "officeSearchPopup"){
			$("#punishOffice").val(rv["code"]);
			$("#punishOfficeNm").val(rv["codeNm"]);
		} else if ( pGubun == "punishReasonPopup"){
			$("#punishReasonCd").val(rv["code"]);
			$("#punishReasonNm").val(rv["codeNm"]);
		} else if ( pGubun == "punishGbPopup"){
			$("#punishGb").val(rv["code"]);
			$("#punishGbNm").val(rv["codeNm"]);
		}else{
			var popupType = POST_ITEMS_CD[pPostitem].popupType;

			if(popupType == "JOB" || popupType == "ENTER" || popupType == "WORKORG"){
				popupType = convCamel(popupType);
				$("#"+pPostitem).val(rv[popupType+"Cd"]).change();
				$("#"+pPostitem).next(":input").val(rv[popupType+"Nm"]).change();
			}else{
				$("#"+pPostitem).val(rv["code"]).change();
				$("#"+pPostitem).next(":input").val(rv["codeNm"]).change();

				/*	//직책 선택시 공통코드의 note4값으로 직책그룹 값이 자동선택되도록, 한투 사용하지 않음
                            if(POST_ITEMS_CD[pPostitem].columnCd == "JIKCHAK_CD"){
                                $("#"+convCamel(POST_ITEMS_COL_CD["WORK_TYPE"]+"_value")).val(rv["note4"]);
                                $("#"+convCamel(POST_ITEMS_COL_CD["WORK_TYPE"]+"_value")).change();
                            }
                */
			}
		}
    }

}

//발령항목 change event
var setOrdTypeCd = function(obj, tbl, ordDetailCd){
	if(obj.val() == ""){
		//모든 발령 항목 disable 시키기
		$("._postItemTr :input",tbl).attr("disabled",true).removeClass("required");
		$("._postItemTr img",tbl).hide();
		$("._postItemTr a",tbl).hide();
	}else{
		var postItemProp = POST_ITEMS_PROP[obj.val()];
		if(postItemProp){
			for(var key in postItemProp){
				var objVal = $("#"+convCamel(key+"_VALUE"),tbl);
				var objNm = $("#"+convCamel(key+"_NM_VALUE"),tbl);
				if(postItemProp[key].mandatoryYn == "Y"){
					objVal.addClass("required");
					objNm.addClass("required");
				}else{
					objVal.removeClass("required");
					objNm.removeClass("required");
				}
				objNm.attr("disabled",true);
				if(postItemProp[key].visibleYn == "Y"){
					objVal.attr("disabled",false);
					objNm.attr("disabled",false);
					objVal.parent().find("img,a").show();
				}else{
					objVal.attr("disabled",true);
					objNm.attr("disabled",true);
					objVal.parent().find("img,a").hide();
				}

				objVal = null, objNm = null;
			}
		}else{
			//모든 발령 항목 disable 시키기
			$("._postItemTr :input",tbl).attr("disabled",true).removeClass("required");
			$("._postItemTr img",tbl).hide();
			$("._postItemTr a",tbl).hide();
		}
		postItemProp = null;

		$("#ordDetailCd",tbl).children().remove();
		if(POST_ITEMS_PROP[obj.val()] && POST_ITEMS_PROP[obj.val()].ordReasonList){
			$("#ordDetailCd",tbl).append("<option value=''>");
			for(var ind in POST_ITEMS_PROP[obj.val()].ordReasonList){
				$("#ordDetailCd",tbl).append("<option value='"+POST_ITEMS_PROP[obj.val()].ordReasonList[ind].code+"'>"+POST_ITEMS_PROP[obj.val()].ordReasonList[ind].codeNm);
				getOrdType = POST_ITEMS_PROP[obj.val()].ordReasonList[ind].ordType;

			}
		}
		if(ordDetailCd) $("#ordDetailCd",tbl).val(ordDetailCd);
		$("#ordDetailCd").trigger('change');
	}

}
function isValidPostItemMandatory(sht, row){

	if(row){
		var ordTypeCd = sht.GetCellValue(row, "ordTypeCd");
		var postItemProp = POST_ITEMS_PROP[ordTypeCd];
		for(var key in postItemProp){
			var tid = convCamel(postItemProp[key].postItem+"_VALUE");
			if(postItemProp[key].mandatoryYn == "Y"){
				if(sht.GetCellValue(row, tid)==""){
					alert(sht.GetCellValue(row, "sNo") +"번째 행의 ["+ POST_ITEMS_CD[tid].postItemNm+"](은)는 필수 입력 항목입니다.");
					return false;
				}

			}
		}
		//sheet1.
	}
	return true;
}

var clearAndDisable = function(obj){
	obj.find(":input, span").val("");
	andDisable(obj);
}
var andDisable = function(obj){
	obj.find(":input").attr("disabled",true);
	obj.find("img,a").hide();
}
var andEnable = function(obj){
	obj.find(":input").attr("disabled",false);
	obj.find("img,a").show();
}

function setAppmtParamSet(pi,sht,rs,f){
	//pi :post item list, sht: sheet obj
	//rs :param을 만들 rows
	if(sht.RowCount()==0)return;
	if(!rs){
		//rs = (sht.FindStatusRow("I|U")+"").split(";");
		rs = (sht.FindStatusRow("I|U|D")+"").split(";");
	}
	if(rs.length==0)return;
	var postItemsNames1 = "", postItemsNames2 = "";
	var str = "";
	for(var i in rs){
		for(var ind in pi){
			var postItem = pi[ind];
			if(i==0){
				postItemsNames1 += ","+convCamel(postItem.postItem+"_VALUE");
				if(postItem.columnCd.indexOf("_CD")>-1){
					postItemsNames1 += ","+convCamel(postItem.postItem+"_VALUE_NM");
				}
				postItemsNames2 += ","+postItem.postItem;
			}
			if(sht.GetCellValue(rs[i],convCamel(postItem.columnCd+""))!="-1"){
				str += "&"+convCamel(postItem.postItem+"_VALUE")+"="+sht.GetCellValue(rs[i],convCamel(postItem.columnCd+""));
			}else{
				str += "&"+convCamel(postItem.postItem+"_VALUE")+"=";
			}
			if(postItem.columnCd.indexOf("_CD")>-1){
				var nm = postItem.columnCd.substring(0,postItem.columnCd.indexOf("_CD"))+"_NM";
				if(sht.GetCellValue(rs[i],convCamel(nm))!="-1"){
					str += "&"+convCamel(postItem.postItem+"_VALUE_NM")+"="+sht.GetCellValue(rs[i],convCamel(nm));
				}else{
					str += "&"+convCamel(postItem.postItem+"_VALUE_NM")+"=";
				}
			}
		}
	}
	/*** 주의 IBS_SaveName 을 수행 후 이 func.을 수행해야 s_SAVENAME에 값이 Set 됨*/
	$("#s_SAVENAME").val($("#s_SAVENAME").val()+postItemsNames1);
	$("#s_SAVENAME2",f).remove();
    f.append("<input type='hidden' id='s_SAVENAME2' name='s_SAVENAME2'/>");
    $("#s_SAVENAME2",f).val(postItemsNames2.substring(1));
    return str;

}


function officeSearchPopup(grpCode) {
	if(!isPopup()) {return;}
	//gPRow = Row;
	if(grpCode =="H20272"){
		pGubun = "officeSearchPopup";
	}else if(grpCode =="H20273"){
		pGubun = "punishReasonPopup";
	}else if(grpCode =="H20274"){
		pGubun = "punishGbPopup";
	}

	var args = new Array();

	args["grpCd"]   = grpCode;

	openPopup("/Popup.do?cmd=commonCodePopup&authPg=R", args, "440","520");
}

function setAddOrdDetail() {

	var OrdDetailCd = $("#ordDetailCd").val();
	var ordYmd = $("#ordYmd").val();

	if( ordYmd != "" && OrdDetailCd != null){
		var pMonth;
		var promotionLimitYmd;
		var subOrdDetailCd = OrdDetailCd.substr(0,2);
		var endOrdDetailCd = OrdDetailCd.substr(2,1);

		if(OrdDetailCd == "NAA"){
			pMonth = 0;
			promotionLimitYmd = 6;
		}
		if(OrdDetailCd == "NFA" || OrdDetailCd == "NFD" || OrdDetailCd == "NIB"){
			pMonth = 0;
			promotionLimitYmd = 0;
		}
		if(OrdDetailCd == "NJA"){
			pMonth = 6;
			promotionLimitYmd = 24;
		}

		if(subOrdDetailCd == "NB" || subOrdDetailCd == "NC" ){
			if(endOrdDetailCd == "A"){
				pMonth = 1;
			}else if(endOrdDetailCd == "B"){
				pMonth = 2;
			}else if(endOrdDetailCd == "C"){
				pMonth = 3;
			}else if(endOrdDetailCd == "D"){
				pMonth = 4;
			}else if(endOrdDetailCd == "E"){
				pMonth = 5;
			}else if(endOrdDetailCd == "F"){
				pMonth = 6;
			}
			if(subOrdDetailCd == "NB"){
				promotionLimitYmd = pMonth +12;
			}
			if(subOrdDetailCd == "NC"){
				promotionLimitYmd = pMonth +18;
			}
		}

		if( pMonth != null && pMonth != "undefined" ) {
			$("#punishDelYmd").val(dateFormatToString(add_months(ordYmd.replace(/-/g, '') , pMonth), "-"));
			$("#promotionLimitYmd").val(dateFormatToString(add_months(ordYmd.replace(/-/g, '') , promotionLimitYmd), "-"));
			$("#paySYmd").val(ordYmd);
			$("#payEYmd").val(dateFormatToString(add_months(ordYmd.replace(/-/g, '') , pMonth), "-"));
		}else{
			$("#punishDelYmd").val("");
			$("#promotionLimitYmd").val("");
			$("#paySYmd").val("");
			$("#payEYmd").val("");
		}

	}
}
 