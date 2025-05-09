<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head> <title><tit:txt mid='113072' mdef='사원번호 수정신청'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style>

</style>
<script type="text/javascript">
	var p              = eval("${popUpStatus}");
	var pGubun         = {};
	var EMP_FIELD_INFO = {};
	var arg            = null;
	var presentTable   = "";
	//window.scrollbars.visible;
	$(function() {
		arg = p.popDialogArgumentAll();

// 		var sabun ;

// 	    if( arg != undefined ) {
// 	    	sabun 	   = arg["sabun"];
// 	    }else{
// 			if ( p.popDialogArgument("sabun") !=null ) { sabun			   				= p.popDialogArgument("sabun"); }
// 	    }
// 	    alert(sabun);

		//공통변수 set

		//$("#empForm").append("<input type='hidden' id='s_SAVENAME' name='s_SAVENAME'/>");
		$("#empForm").append("<input type='hidden' id='empTable' name='empTable' value='"+arg.empTable+"'/>");
		$("#empForm").append("<input type='hidden' id='applType' name='applType' value='"+arg.transType+"'/>");
		$("#empForm").append("<input type='hidden' id='applYmd' name='applYmd' value='${curSysYyyyMMdd}'/>");
		$("#empForm").append("<input type='hidden' id='applStatusCd' name='applStatusCd' value='1'/>");//1:신청

		console.log('arg', arg);

		// 항목에 따른 값 화면에 display
		setField(arg, $("#empTable"),2);

		//20200902 연락처 입력/삭제 신청 시 display
		if(arg.empTable == "thrm124") {
			// 해당 건의 값이 있으면 조회 후 display
			if(arg.transType!="I"
			&& arg.transType!="D") {
				setData(arg, $("#empTable"));
			} else {
				//입력 또는 삭제일 때는 사번만 set
				$("#sabun").val(arg.sabun);
				$("#v_sabun").val(arg.sabun);
				$("#contType").val(arg.contType);

				$("select[name='contType']").change(function() {
					if(this.value == "GP1") { // 연락처의 비상연락망관계
						var codeLists   = codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList", "H20120");
						var selectHtml  = "<select id='contAddress' name='contAddress' style='min-width:150px;'>";

						for(var j in codeLists) {
							selectHtml += "<option value='" + codeLists[j].codeNm + "'>" + codeLists[j].codeNm + "</option>";
						}

						selectHtml += "</select>";
						$("#span_contAddress").html(selectHtml);
					} else {
						// 연락처 삭제 신청 시 연락처 항목 제외
						if(arg.transType != "D") {
							var textHtml = "<input type='text' id='contAddress' name='contAddress' title='연락처' class='text' style='width:150px;'>";
							$("#span_contAddress").html(textHtml);
						}
					}
				});
			}
		} else {
			// 해당 건의 값이 있으면 조회 후 display
			if(arg.transType!="I") setData(arg, $("#empTable"));
			else {
				//입력일때는 사번만 set
				$("#sabun").val(arg.sabun);
				$("#v_sabun").val(arg.sabun);
			}
		}

		// event
        $(".close").click(function() {
	    	p.self.close();
	    });
	});

	function setData(arg, tbl) {
		var tmpargs = {};
		for(var i in arg){
			tmpargs[i] = arg[i];
		}

		var data = ajaxCall("${ctx}/PsnalBasicInf.do?cmd=getEmpInfoList",tmpargs,false).DATA;
		if(data[0]){
			//console.log('data[0]', data[0]);
			$(":input",$(tbl)).each(function(){
				var oid = $(this).attr("id");
				if(oid.indexOf("v_")==0){
					oid = oid.substring(2);
				}
				
				var fInfo = EMP_FIELD_INFO[oid], value;
				
				if($(this).attr("type")!="checkbox") {
					// 20200902 연락처 변경 신청 시 데이터 세팅 로직 추가
					if(tmpargs.empTable == "thrm124" && oid == "contAddress") {
						$(this).val(tmpargs.selectedValue);
					} else {
						//console.log('oid', oid, 'data[0][oid]', data[0][oid], 'fInfo', fInfo);
						value = data[0][oid];
						if( fInfo && fInfo != null ) {
							// 해당컬럼타입이 날짜형인 경우
							if( fInfo.cType == "D" ) {
								// 입력값의 길이가 제한 길이와 다를 경우 입력값 세팅 시 형식 오류 발생하여 길이에 따라 월 혹은 일 정보 추가하여 값 삽입 처리
								if( fInfo.limitLength != value.replace(/-/g, '').length ) {
									if( value.replace(/-/g, '').length == 4 ) {
										value = value + "-01-01";
									} else if( value.replace(/-/g, '').length == 6 ) {
										value = value + "-01";
									}
								}
							}
						}
						$(this).val(value).focusout();
					}
				}
				if($(this).attr("type")=="checkbox" && data[0][oid] == "Y"){
					$(this).attr("checked",true);
				}

				//첨부파일
				if(fInfo && fInfo.cType == "F" && $(this).val()!=""){
					$(this).next().text("다운로드");
				}

				if(fInfo && arg.transType=="U" && fInfo.cType == "F" && $(this).val()!=""){
					//첨부파일이 존재하면 복사본 만들기
					//cmd=copyEmpInfoAttachFile
					// 사용 안함
// 					var result = ajaxCall("${ctx}/PsnalBasicInf.do?cmd=copyEmpInfoAttachFile","fileSeq="+$(this).val()+"&work=${hrm}",false).fileSeq;
// 					$(this).val(result);
				}
			});
		}
	}

	function setField(arg, tbl, wCnt) {
		//title 수정
		var transType = arg.transType;
		presentTable  = arg.empTable;

		if(transType == "I") 	  transType = "등록";
		else if(transType == "U") transType = "수정";
		else if(transType == "D") transType = "삭제";
		$("._popTitle").text(arg.eTableNm +" "+transType + " 신청");
		$("#regBtn").text(transType+" 신청");

		//공통코드 조회
		var grcodeCds = "";
		var grcodes = {};
		//부모항목에 종속된 공통코드조회 항목
		var dypopupTypes = {};//id:종속된 항목 id, value:부모항목 id

		var empFields = ajaxCall("${ctx}/PsnalBasicInf.do?cmd=getEmpInfoChangeFieldMgrList","searchUseYn=Y&searchEmpTable="+arg.empTable,false).DATA;

		//20200902 연락처 입력/변경/삭제 신청 시 비상연락망관계는 콤보박스로 표시 추가
		if(arg.empTable == "thrm124" && arg.contType == "GP1") { // 연락처의 비상연락망관계
			empFields[2].cType     = "C";
			empFields[2].popupType = "H20120";
		}

		var obj = "", th = "", attr = "", tdind = 0;
		var tr = [];
		var gccd = "";
		var t = "";
		for(var i in empFields) {
			// 연락처 삭제 신청 시 연락처 항목 제외
			if(presentTable          == "thrm124"
			&& arg.transType         == "D"
			&& empFields[i].columnCd == "CONT_ADDRESS") {
				continue;
			}

			var objid = convCamel(empFields[i].columnCd+"");
			EMP_FIELD_INFO[objid] = empFields[i];
			//1. 항목의 html code 조회
			obj += "<span id='span_"+objid+"'>";
			obj += getObjCod(empFields[i].cType, objid, empFields[i].columnNm, empFields[i].popupType, empFields[i].limitLength, empFields[i].readOnlyYn, empFields[i].pkType, empFields[i].notNullYn);
			obj += "</span>";
			
			//2. (popup or combo 의) 공통코드가 부모값에 종속되어 변경되는 경우 부모항목에 change event 추가 하기위해 변수에 저장
			// 모든항목에 append된 후 event를 추가해야 event가 먹는다.
			if(empFields[i].popupType && empFields[i].popupType.indexOf(".")>-1){// popupType이 부모항목[columnCd.컬럼명] 형식으로 입력되어있는경우 ( 예:ACA_CD.NOTE1 )
				var sepInd = empFields[i].popupType.indexOf(".");
				var pojbid = convCamel(empFields[i].popupType.substring(0, sepInd)+"");
				var ptcc =  convCamel(empFields[i].popupType.substring(sepInd+1)+"")[0];
				dypopupTypes[pojbid] = {"objId":objid, "popupTypeColumnCd":ptcc};

			}
			if(empFields[i].cType == "N") continue; // hidden 객체는 td, tr 계산필요 없으므로 skip

			//td, tr 그리기
			if(th=="") th = '<th>'+empFields[i].columnNm+'</th>';

			if(empFields[i].columnCd == empFields[i].groupColumnCd) gccd = empFields[i].groupColumnCd;
			else if(empFields[i].groupColumnCd=="")gccd = "";

			if(empFields[i].groupColumnCd == "" || (empFields[Number(i)+1] && gccd != empFields[Number(i)+1].groupColumnCd) || Number(i)+1== empFields.length){

			}
			else if(gccd == empFields[i].groupColumnCd ){
				if(empFields[i].groupSeparator!="") obj+= empFields[i].groupSeparator+"&nbsp;";
				continue;
			}

			tr[tdind % wCnt] = {"th":th,"obj":obj};
			//td += th+"<td>"+obj+"</td>";

			if(tdind % wCnt == wCnt-1 || (!empFields[Number(i)+1]) || empFields[i].mergeYn == "Y"){
				var tmp = "";
				/* console.log(tr.length); */
				for(var ii in tr){
					/* console.log(ii);	 */

					tmp += tr[ii].th;
					if(tr.length < wCnt && tr.length == (Number(ii)+1)) tmp += '<td colspan="'+((wCnt - tr.length)*2)+1+'">';
					else tmp += '<td>';
					tmp += tr[ii].obj+'</td>';

				}
				tbl.append("<tr>"+tmp+"</tr>");
				//tr += "<tr>"+td+"</tr>";
				tr = [];
			}
			if(empFields[i].mergeYn == "Y"){
				tdind += (wCnt-(tdind % wCnt));
				$("#"+objid).css({"width":"70%"});

			}else tdind++;

			th = "", obj = "";
		}

//		setComboValues(empFields);//combobox option set
		// 20200902 매개변수 presentTable 추가
		setComboValues(empFields, presentTable);//combobox option set
		setDynamicPopupType(tbl,  dypopupTypes);//dynamic combobox option set

		//달력
    	$(".date2", $("#empTable")).each(function(){
    		if($(this).attr("disabled")){
    			if($(this).hasClass("dateYm")){
    				$(this).mask("0000-00");
    			}else{
    				$(this).mask("0000-00-00");
    			}
    		}else{
	    		if($(this).hasClass("dateYm")){
	    			$(this).datepicker2({ymonly:true});
	    		}else $(this).datepicker2();
    		}
    	});
		
		// INT keyup event
    	$(".input_int", $("#empTable")).each(function(){
    		$(this).mask('000000000000000');
    	});
		
    	//팝업 keyup event
    	$("._popup", $("#empTable")).bind("keyup",function(event){
    		//연관필드 clear

    		var relcolcds = (convCamel(EMP_FIELD_INFO[$(this).attr("id")].relColumnCd)).split(",");
    		for(var i in relcolcds){
				if(!relcolcds[i])continue;
				if($("#"+relcolcds[i]))$("#"+relcolcds[i]).val("");
				if($("#v_"+relcolcds[i]))$("#v_"+relcolcds[i]).val("");
    		}

    		//$(this).prev(":input").val("");
    		if( event.keyCode == 13){
    			$(this).parent().find("a").trigger("click");
    		}
    	});

		empFields = null;

	}
	
	function setDynamicPopupType(tbl, dpt){
		for(var key in dpt){
			/* var objid = $("#"+dpt[key].objId); // 종속된 자식obj
			var colcd = dpt[key].popupTypeColumnCd; */
			var pobj = $("#"+key); // 부모 obj
			pobj.change(function(){
				var popupType = "";
				var objid = dpt[$(this).attr("id")].objId;//종속된 자식obj
				if($(this).is("select")){
					popupType = $("option:selected",$(this)).data()[dpt[$(this).attr("id")].popupTypeColumnCd];

				}else{

					popupTypeObjid = convCamel(objid+"_"+dpt[$(this).attr("id")].popupTypeColumnCd);
					popupType = $("#"+popupTypeObjid);
				}

				$("#span_"+objid).html("");
				var empField = EMP_FIELD_INFO[objid];
				if(!popupType || popupType == ""){
					$("#span_"+objid).append(getObjCod("T", objid, empField.columnNm, popupType, empField.limitLength, empField.readOnlyYn, empField.pkType, empField.notNullYn));
				}else $("#span_"+objid).append(getObjCod(empField.cType, objid, empField.columnNm, popupType, empField.limitLength, "Y", empField.pkType, empField.notNullYn));

				//obj를 새로 생성했으므로 event를 선언해줘야함.
				$("._popup", $("#empTable")).bind("keyup",function(event){
					clearRelCols($(this).attr("id"));
		    		if( event.keyCode == 13){
		    			$(this).parent().find("a").trigger("click");
		    		}
		    	});
				//중속된 자식필드는 obj를 다시만들고 종속된 자식필드의 연관필드 값은 clear시킴
				clearRelCols(objid);

			});
			pobj.change();// change event를 싱행해줘서 자식 obj를 다시 생성한다.
		}
	}
	//연관필드 값 clear func.
	function clearRelCols(id){
		//연관필드 clear
		var relcolcds = (convCamel(EMP_FIELD_INFO[id].relColumnCd)).split(",");
		for(var i in relcolcds){
			if(!relcolcds[i])continue;
			if($("#"+relcolcds[i]))$("#"+relcolcds[i]).val("");
			if($("#v_"+relcolcds[i]))$("#v_"+relcolcds[i]).val("");
		}
	}

//	function setComboValues(ef) {
	function setComboValues(ef , presentTable) {
		var tmp = {};
		var ptstr = "";
		for(var i in ef){
			if(ef[i].cType == "C"){
				var tmp2 = [];
				if(tmp[ef[i].popupType])tmp2 = tmp[ef[i].popupType];

				if($("#"+convCamel(ef[i].columnCd+"")).attr('type') == "hidden")tmp2.push("v_"+convCamel(ef[i].columnCd));
				else tmp2.push(convCamel(ef[i].columnCd+""));
				/* if(ef[i].readOnlyYn == "Y" || ef[i].pkType == "P")tmp2.push("v_"+convCamel(ef[i].columnCd));
				else tmp2.push(convCamel(ef[i].columnCd+"")); */

				tmp[ef[i].popupType] = tmp2;

				if(ef[i].popupType == "ORG"){

				}else if(ef[i].popupType == "LOCATION"){

				}else if(ef[i].popupType == "JOB"){

				}else{
					ptstr += ","+ef[i].popupType+"";
				}
			}
		}

		if(ptstr.length>1){
			ptstr = ptstr.substring(1);
//			var codeLists = convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","grpCd="+ptstr,false).codeList, " ",tmp, 2);
//				codeLists = null;
			/* for(var key in tmp){
				$("#"+tmp[key]).html(codeLists[key][2]);
			} */
			if(presentTable=="thrm124") {
				convCodeForSelected(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","useYn=Y&grpCd="+ptstr,false).codeList, " ", tmp, 2, arg.selectedValue);
			} else {
				convCodes(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonCodeLists","useYn=Y&grpCd="+ptstr,false).codeList, " ", tmp, 2);
			}
		}
	}

	function getObjCod(ctype, objid, objnm, popupType, limilen, readonly, pk, notnull) {
		var objcod = "";
		var width = 135;
		if(limilen< (width/10)) width = limilen*10;
		if(limilen<3) width = 30;
		var readonly = (readonly=="Y"?"disabled":"");
		readonly = ((pk=="P" && (arg.transType)!="I")?"disabled":readonly);
		var pk = (pk=="P"?"required":"");
		if(notnull == "Y")pk="required";
		if($("#applType").val()=="D") {
			readonly = "disabled";
		}

		// 20200902 연락처 삭제 신청 시 연락처 항목 활성화
		if(arg.empTable         == "thrm124"
		&& $("#applType").val() == "D"
		&& objid                == "contType") {
			readonly = "";
		}

		var org_objid = objid;
		if(readonly=="disabled"){
			objid = "v_"+objid;
			objcod = "<input type='hidden' id='"+org_objid+"' name='"+org_objid+"'/>";
		}

		switch(ctype){//COMBO,TEXT,CHECKBOX,POPUP,DATE,INT //C|T|H|P|D|I
			case "C":
				objcod += "<select id='"+objid+"' name='"+objid+"' title = '"+objnm+"' style='min-width:"+width+"px;' class='"+pk+"' "+readonly+"></select>&nbsp;";
				break;
			case "T":
				objcod += "<input type='text' id='"+objid+"' name='"+objid+"' title = '"+objnm+"' class='text "+pk+"' style= 'width:"+width+"px;' "+readonly+"/>&nbsp;";
				break;
			case "P":
				objcod += "<input type='text' id='"+objid+"' name='"+objid+"' title = '"+objnm+"' class='text "+pk+" _popup' style= 'width:"+width+"px;' "+readonly+"/>&nbsp;";
				objcod += "<input type='hidden' id='"+objid+"Note1' name='"+objid+"Note1'/>";
				objcod += "<input type='hidden' id='"+objid+"Note2' name='"+objid+"Note2'/>";
				objcod += "<input type='hidden' id='"+objid+"Note3' name='"+objid+"Note3'/>";
				//if(popupType== "POST"){
					objcod += "<a onclick=\"javascript:empInfoPopup('"+objid+"', '"+popupType+"');return false;\" class=\"button6\"><img src='/common/${theme}/images/btn_search2.gif'/></a>&nbsp;";
				//}else objcod = "";
				break;
			case "D"://date
				objcod += "<input type='text' id='"+objid+"' name='"+objid+"' title = '"+objnm+"' size='10' class='text date2 "+pk+"' "+readonly+"/>&nbsp;";
				break;
			case "M"://월력
				objcod += "<input type='text' id='"+objid+"' name='"+objid+"' title = '"+objnm+"' size='10' class='text date2 dateYm "+pk+"' "+readonly+"/>&nbsp;";
				break;
			case "H":
				objcod += "<input type='checkbox' id='"+objid+"' name='"+objid+"' title = '"+objnm+"' value='Y' class='"+pk+"' "+readonly+">&nbsp;";
				break;
			case "F"://첨부파일
				objcod += "<input type='hidden' id='"+objid+"' name='"+objid+"' title = '"+objnm+"' class='"+pk+"'/><a href=\"javascript:doAttachFile('"+objid+"');\" class=\"basic\"><tit:txt mid='104241' mdef='첨부'/></a>&nbsp;";
				break;
			case "N"://hidden
				objcod += "<input type='hidden' id='"+objid+"' name='"+objid+"' title = '"+objnm+"'/>";
				break;
			case "A"://textarea
				objcod += "<textarea id='"+objid+"' name='"+objid+"' title = '"+objnm+"' class='text "+pk+"' style= 'width:"+width+"px;' "+readonly+" rows=5></textarea>";
				break;
			case "I"://INT
				objcod += "<input type='text' id='"+objid+"' name='"+objid+"' title = '"+objnm+"' class='text input_int "+pk+"' style= 'width:"+width+"px;' "+readonly+"/>&nbsp;";
				break;
		}

		return objcod+"";
	}
	//첨부파일 popup
	function doAttachFile(objid){

		if(objid || $("#applType").val()!="D"){
			pGubun = {"popupType":"fileMgrPopup","objid":objid};
			var param = [];
			param["fileSeq"] = $("#"+objid).val();
			var popupType = EMP_FIELD_INFO[objid].popupType;
			if($("#applType").val()=="D") openPopup("/Upload.do?cmd=fileMgrPopup&authPg=R&uploadType="+popupType, param, "740","620");
			else openPopup("/Upload.do?cmd=fileMgrPopup&authPg=A&uploadType="+popupType, param, "740","620");
		}else{
			pGubun = {};
			alert("<msg:txt mid='110267' mdef='첨부된 파일이 없습니다.'/>");
		}
	}
	function empInfoPopup(objid, popuptype){
		pGubun = {"objid":objid};
		switch(popuptype){
			case "POST":
				var win = openPopup("/ZipCodePopup.do?cmd=viewZipCodePopup&authPg=${authPg}", "", "870","630");
				break;
			case "JOB":
				openPopup("/Popup.do?cmd=jobSchemePopup&authPg=R", "", "740","520");
				break;
			case "ORG":
				openPopup("/Popup.do?cmd=orgTreePopup&authPg=R", "", "740","520");
				break;
			case "LOCATION":
				openPopup("/LocationCodePopup.do?cmd=viewLocationCodePopup&authPg=R", "", "740","520");
				break;
			default:
				var param = {"codeNm" : $("#"+objid).val(),"grpCd":popuptype};
				if(popuptype.indexOf(".")==-1) openPopup("/Popup.do?cmd=commonCodePopup&authPg=R", param, "740","620");
				else empInfoDynamicPopup(objid,popuptype);


		}
	}
	function empInfoDynamicPopup(objid,popuptype){
		var pobjid = convCamel(popuptype.substring(0,popuptype.indexOf(".")));

		if($("#"+pobjid).val() == ""){
			alert(($("#"+pobjid).attr("title"))+"을(를) 먼저 입력후 수행하세요.");
			$("#"+pobjid).select();
		}else{
			//$("#"+pobjid).
			//empInfoPopup(objid,)
		}
	}
	//popup return
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');
		if(pGubun.objid.indexOf("v_")>-1)pGubun.objid = pGubun.objid.substring(2);
		var empInfo = EMP_FIELD_INFO[pGubun.objid];

		var popPrefix = "", popSurfix = "", relPrefix = "", relSurfix = "Cd";
		var popCd = "", popNm = "";

		if(pGubun.popupType == "fileMgrPopup"){
			if(rv["fileCheck"] == "exist"){
				$("#"+(pGubun.objid)).val(rv["fileSeq"]);
				/* sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic"><tit:txt mid='download' mdef='다운로드'/></a>');
				sheet1.SetCellValue(gPRow, "fileSeq", rv["fileSeq"]); */
			}else{
				/* sheet1.SetCellValue(gPRow, "btnFile", '<a class="basic"><tit:txt mid='104241' mdef='첨부'/></a>');
				sheet1.SetCellValue(gPRow, "fileSeq", ""); */
				$("#"+(pGubun.objid)).val("");
			}


		}else{
			if(empInfo.popupType=="POST"){


				$("#"+pGubun.objid).val(rv["zip"]);
				//alert("111")
				/* sheet2.SetCellValue(gPRow, "zip", rv["zip"]);
				sheet2.SetCellValue(gPRow, "addr1", rv["addr1"]);
				sheet2.SetCellValue(gPRow, "addr2", rv["addr2"]);
				sheet2.SetCellValue(gPRow, "mnBldno", rv["mnBldno"]);
				sheet2.SetCellValue(gPRow, "subBldno", rv["subBldno"]);
				sheet2.SetCellValue(gPRow, "refIt", rv["refIt"]); */
			}else if(empInfo.popupType == "ORG" || empInfo.popupType == "LOCATION" || empInfo.popupType == "JOB"){
				popCd = convCamel(empInfo.popupType)+"Cd";
				popNm = convCamel(empInfo.popupType)+"Nm";
			}
			else{
				popCd = "code";
				popNm = "codeNm"
				/* popPrefix = "code";

				if((pGubun.objid).indexOf("Cd")>-1){
					relPrefix = (pGubun.objid).substring(0,(pGubun.objid).indexOf("Cd"));
					popSurfix = "";
					relSurfix = "Cd";
				}else if((pGubun.objid).indexOf("Nm")>-1){

					popSurfix = "Nm";
					relSurfix = "Nm"
					relPrefix = (pGubun.objid).substring(0,(pGubun.objid).indexOf("Nm"));
				}
				//$("#"+colid).val(rv[popPrefix +""+ relSurfix]);
				//console.log(empInfo.popupType); */
			}

			//if(empInfo.relColumnCd){
				var relcolcds = (convCamel(empInfo.relColumnCd)+","+pGubun.objid).split(",");
				//acaSchCd, acaSchNm
				for(var i in relcolcds){
					if(!relcolcds[i])continue;
					var colid = relcolcds[i];//convCamel(relcolcds[i]+"");
					var popVal = rv[popPrefix +""+ relSurfix];

					if(colid.substring(colid.length-2) == "Cd"){
						popVal = rv[popCd];
					}else if(colid.substring(colid.length-2) == "Nm"){
						popVal = rv[popNm];
					}else if(colid == "addr1"){
						popVal = rv["doroAddr"];
					}else if(colid == "addr2"){
						popVal = rv["detailAddr"];	
					}else{
						for(var key in rv){
							var t_colid = colid.toLowerCase();
							var t_key = key.toLowerCase();
							if(t_colid.length == key.length && t_colid == t_key){
								popVal = rv[key];
								break;
							}else if(t_colid.length != key.length && t_colid.indexOf(t_key) == (t_colid.length-t_key.length-1)){
								popVal = rv[key];
								break;
							}
								//homeAddr1 9-4-1
								//addr1
						}

					}

					$("#"+colid).val(popVal);
					if($("#v_"+colid))$("#v_"+colid).val(popVal);
				}
			//}
		}
	}

	function doAction1(sAction){
		switch (sAction) {
			case "Save":
				//1. 필수항목 체크
				var isValid = true;
				$("#empForm :input").each(function(){
					if($(this).hasClass("required") && $(this).val() == ""){
						isValid = false;
						alert($(this).attr("title")+" 값은 필수입력입니다.");
						$(this).focus();
						return false;
					}
					if($(this).attr("type")=="checkbox" && $(this).val() !='Y') $(this).val("N");
				});

				if(isValid){
					//ajaxCall2(url, params, async, beforeFn, successFn)
// 					var result = ajaxCall2("${ctx}/PsnalBasicInf.do?cmd=saveEmpInfoReq",$("#empForm").serializeObjet(),true
					var result = ajaxCall2("${ctx}/PsnalBasicInf.do?cmd=saveEmpInfoReq",$("#empForm").serialize(),true
							,function(){
								progressBar(true) ;
							}
							,function(data){
								progressBar(false) ;

								alert(data.Result.Message);
								if(data.Result.Code>0)p.self.close();
							}

					);

					//console.log(result);
				}
			break;
		}
	}
</script>

</head>
<body class="bodywrap">
    <div class="wrapper">
        <div class="popup_title">
            <ul>
                <li class="_popTitle"></li>
                <li class="close"></li>
            </ul>

        </div>
		<div class="popup_main">
			<div class="sheet_title">
			<ul>
				<li class="txt _popTitle"></li>
				<li class="btn">

				</li>
			</ul>
			</div>

	        <div class="popup_main">
	        	<div  style="overflow-y:auto;overflow-x:hidden;height:300px;">
	            <form id="empForm" name="empForm">
		        <table border="0" cellpadding="0" cellspacing="0" class="default" id="empTable">
					<!-- <colgroup>
						<col width="100px;" />
						<col width="40%" />
						<col width="10%" />
						<col width="" />
					</colgroup> -->
				</table>
				</form>
				</div>
		        <div class="popup_button outer">
		            <ul>
		                <li>
		                	<a href="javascript:doAction1('Save');" class="pink large" id="regBtn" ><tit:txt mid='appComLayout' mdef='신청'/></a>
		                    <a href="javascript:p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
		                </li>
		            </ul>
		        </div>
	        </div>
	    </div>
	</div>
</body>
</html>



