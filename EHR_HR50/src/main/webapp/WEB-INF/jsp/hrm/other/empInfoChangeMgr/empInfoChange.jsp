<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<script>
var EMP_INFO_CHANGE_TABLE_SHEET = {};
$(function() {
	//console.log(EMP_INFO_CHANGE_TABLE_SHEET["thrm100"].GetSelectRow());
	var prgCd = "<%=sec_relUrl%>".substring("<%=sec_relUrl%>".indexOf("=view")+5).replace("Layer", "");
	prgCd = prgCd.replace(/\//g, "");
	//prgCd = "PsnalBasic";
	var empTables = ajaxCall("${ctx}/PsnalBasicInf.do?cmd=getEmpInfoChangeTableMgrList","searchUseYn=Y&searchPrgCd="+prgCd,false).DATA;
	if(empTables != null && empTables != undefined && empTables.length > 0) {
		var userEnterCd = $("#searchUserEnterCd", parent.document).val();
		var userId = $("#searchUserId", parent.document).val();

        if (userEnterCd == undefined || userId == undefined) {
            userEnterCd = searchUserEnterCd;
            userId = searchUserId;
        }

		for(var ind in empTables){
			// 검색한 직원이 현재 세션 회사의 직원이 아닐경우 정보 변경 신청 버튼을 보여주지 않음.
			if(empTables[ind].enterCd != userEnterCd) {
				break;
			}
			
			// 검색한 직원이 현재 세션  직원이 아닐경우 정보 변경 신청 버튼을 보여주지 않음.
			if("${ssnSabun}" != userId) {
				break;
			}
	
			//console.log(empTables[ind]);
			var empTable = empTables[ind].empTable.toLowerCase();
			var buttonarea = $("._"+empTable);
			var transTypes = empTables[ind].transType.split("");
			var buttons = "";
	
			for(var i in transTypes){
				if(transTypes[i] == "I"){
					buttons += "<a href=\"javascript:doEmpInfoChangeReq('"+transTypes[i]+"', '"+empTable+"', '"+empTables[ind].empTableNm+"', '"+empTables[ind].multirowYn+"');\" class=\"btn outline_gray thinner\">"+"입력신청</a>";
				}else if(transTypes[i] == "U"){
					buttons += "<a href=\"javascript:doEmpInfoChangeReq('"+transTypes[i]+"', '"+empTable+"', '"+empTables[ind].empTableNm+"', '"+empTables[ind].multirowYn+"');\" class=\"btn outline_gray thinner\">"+"수정신청</a>";
				}else if(transTypes[i] == "D"){
					buttons += "<a href=\"javascript:doEmpInfoChangeReq('"+transTypes[i]+"', '"+empTable+"', '"+empTables[ind].empTableNm+"', '"+empTables[ind].multirowYn+"');\" class=\"btn outline_gray thinner\">"+"삭제신청</a>";
				}
			}
			if(empTable=="thrm100")buttons = "<a href=\"javascript:doSignImgChangeReq();\" class=\"btn outline_gray\">"+"서명등록</a>" + buttons;
			if(empTable=="thrm100")buttons = "<a href=\"javascript:doEmpInfoChangeReq('picture', '', '개인이미지');\" class=\"btn outline_gray\">"+"개인 이미지 변경 신청</a>" + buttons;
			if(buttonarea.find("a").length>0){
				$(buttonarea.find("a")[0]).before(buttons);
			}
			/*
			console.log(transTypes);
			console.log(sheet1.GetCellValue(0, "empTable"));
			console.log(sheet1.GetCellProperty(0, "empTable", "KeyField"));
			*/
	
		}
	}
});
// 연락처 변경 신청 화면에서 시트에 SetSelectRow 시 타이핑 및 붙여넣기가 불가능하여 SelectRow 값을 hdnSelectRow에 넣어서 처리하도록 변경
var selectRow = -1;
function doEmpInfoChangeReq(tType, eTable, eTableNm, multirowYn){
// 	if($("#hdnSabun").val()!="${ssnSabun}"){
// 		alert("로그인한 사용자의 정보만 변경 신청할 수 있습니다.");
// 		return;
// 	}

/* 	var data = ajaxCall("${ctx}/AppSelfImWon.do?cmd=updateAppSelfImWonConfirm", "eTable=" + eTable + "&" + $.extend(param,getKeyValues(sht)),false);

	if(data.Result != null && data.Result.Code > 0) {
		alert(data.Result.Message);
		return;
	}
 */

	//var sht = sheet1;
	var sht = (eTable && eTable != null && eTable != "") ? EMP_INFO_CHANGE_TABLE_SHEET[eTable] : null;
	if( sht && sht != null ) {
		selectRow = sht.GetSelectRow();
	}
	
	//20200902 연락처 변경 신청 시 체크 추가
	var selectedValue = "";
	if(eTable =="thrm124") {
		selectedValue = $("#hdnkeyup").val();
		selectRow = $("#hdnSelectRow").val();
	}

	//20200902 연락처 변경 신청 시 체크 추가
	var param = "";
	if(eTable=="thrm124") {
		param = {"empTable":eTable, "eTableNm":eTableNm, "transType":tType, "sabun":$("#hdnSabun").val(), "name":$("#name").val(), "selectedValue": selectedValue};
	} else {
		param = {"empTable":eTable, "eTableNm":eTableNm, "transType":tType, "sabun":$("#hdnSabun").val(), "name":$("#name").val()};
	}

	if ( tType != "picture" && tType != "I" && sht.RowCount() > 0 ){

		var data = ajaxCall("${ctx}/PsnalBasicInf.do?cmd=getEmpInfoChangeMgrDupChk"+ "&empTable=" + eTable, sht.GetRowJson(selectRow),false).DATA;

		if ( data.cnt > 0 ){
			alert("기존 신청건이 있습니다.\r\n승인 또는 반려 후에 신청하시기 바랍니다.");
			return;
		}
	}
	
	if ( tType == "picture" ){

		var data = ajaxCall("${ctx}/PsnalBasicInf.do?cmd=getEmpPictureChangeMgrDupChk", "searchSabun=" + $("#hdnSabun").val(),false).DATA;

		if ( data.cnt > 0 ){
			alert("신청건이 있습니다.\r\n승인 또는 반려 후에 신청하시기 바랍니다.");
			return;
		}
	}


	//////////////////////////////////////
//  	alert(EMP_INFO_CHANGE_TABLE_SHEET[eTable]);
//  	alert(eTable);
//  	alert(eTableNm);
//  	alert(tType);
//  	alert($("#hdnSabun").val());
//  	alert($("#name").val());
//  	alert(sht.RowCount());
//  	alert(sht.GetSelectRow());
	/////////////////////////////////////
    var  url = null;
	switch(tType){
		case "picture":
			//openPopup("/Popup.do?cmd=viewEmpPictureChangeReqPopup&authPg=A", param, "540","520");
			 url = '/Popup.do?cmd=viewEmpPictureChangeReqLayer&authPg=A'
			 empPictureChangeReqPopup(url, param);
			break;
		case "I":
			if(sht.RowCount()>0 && multirowYn!="Y" && eTable.toUpperCase() != "THRM124"){
				alert("이미 입력되어있습니다. 변경을 원하실 경우 '변경신청'을 하세요.");
				break;
			}
			
			if(eTable.toUpperCase() == "THRM124") {
				// 20200902 연락처 입력 신청 시 주석 처리 - 오작동
				// 연락처의 경우 실데이터 체크를 통해 입력하도록 함. by kwook
				/*
				if(sht.GetCellValue(selectRow, "realData") == "Y") {
					alert("이미 입력되어있습니다. 수정을 원하실 경우 '수정신청'을 하세요.");
					break;
				}
				*/
				
				if( selectedValue != undefined && selectedValue != "" ) {
					alert("입력 신청 대상 항목이 아닙니다. 입력 신청 할 항목을 선택 후 수행하세요.");
					break;
				}
			}

			if(eTable.toUpperCase() == "THRM124") {
				/*
				openPopup("/Popup.do?cmd=viewEmpInfoChangeReqPopup&authPg=A"
						, $.extend(param, {
							"contType" : sht.GetCellValue(selectRow, "contType")
						})
						, "740","520");
                url = '/Popup.do?cmd=viewEmpInfoChangeReqPopup&authPg=A';*/
                url = '/Popup.do?cmd=viewEmpInfoChangeReqLayer&authPg=A';
                param =  $.extend(param, {"contType" : sht.GetCellValue(selectRow, "contType")});
                empInfoChangeReqPopup(url, param);
			} else {
				//openPopup("/Popup.do?cmd=viewEmpInfoChangeReqPopup&authPg=A", param, "740","520");
	            url = '/Popup.do?cmd=viewEmpInfoChangeReqLayer&authPg=A';
	            param =  $.extend(param, {"contType" : sht.GetCellValue(selectRow, "contType")});
	            empInfoChangeReqPopup(url, param);
			}
			break;
		case "U":
			if(sht.RowCount()==0 && multirowYn!="Y"){
				alert("변경신청할 수 없습니다.");
				break;
			}

			// 20200902 연락처 입력 신청 시 주석 처리 - 오작동
			// 연락처의 경우 실데이터 체크를 통해 수정하도록 함. by kwook
			/*
			if(eTable.toUpperCase() == "THRM124") {
				if(sht.GetCellValue(selectRow, "realData") != "Y") {
					alert("변경신청할 수 없습니다. 먼저 입력신청하세요.");
					break;
				}
			}
			*/

			//20200902 연락처 변경 신청 시 체크 추가
			if(eTable.toUpperCase() == "THRM124") {
				if(selectedValue == "") {
					alert("변경신청 대상 항목이 아닙니다. 변경신청 할 항목을 선택 후 수행하세요.");
					break;
				}
			}

			if(sht.GetCellValue(selectRow,"sStatus")=="I"){
				alert("입력상태인건은 수정신청 할 수 없습니다.");
				break;
			}else if(selectRow<1){
				alert("수정신청 할 항목을 선택 후 수행하세요.");
				break;
			}

			//openPopup("/Popup.do?cmd=viewEmpInfoChangeReqPopup&authPg=A", $.extend(param,getKeyValues(sht)), "740","520");
			url = 'Popup.do?cmd=viewEmpInfoChangeReqLayer&authPg=A';
            param =  $.extend(param,getKeyValues(sht));
            empInfoChangeReqPopup(url, param);
			break;
		case "D":
			if(sht.RowCount()==0 && multirowYn!="Y"){
				alert("삭제신청할 수 없습니다.");
				break;
			}
			if(sht.GetCellValue(selectRow,"sStatus")=="I"){
				alert("입력상태인건은 삭제신청 할 수 없습니다.");
				break;
			}else if(selectRow<1){
				alert("삭제신청 할 항목을 선택 후 수행하세요.");
				break;
			}
			
			if(eTable.toUpperCase() == "THRM124") {
				if( selectedValue != undefined && selectedValue == "" ) {
					alert("삭제신청 대상 항목이 아닙니다. 삭제신청 할 항목을 선택 후 수행하세요.");
					break;
				}
			}

			//20200902 연락처 삭제 신청 시
			if(eTable.toUpperCase() == "THRM124") {
				/*
				openPopup("/Popup.do?cmd=viewEmpInfoChangeReqPopup&authPg=A"
						,  $.extend(param, {
							"contType" : sht.GetCellValue(selectRow, "contType")
						})
						, "740","520");*/
		        url = '/Popup.do?cmd=viewEmpInfoChangeReqLayer&authPg=A';
		        param =   $.extend(param, {"contType" : sht.GetCellValue(selectRow, "contType")});
		        empInfoChangeReqPopup(url, param);
			} else {
				//openPopup("/Popup.do?cmd=viewEmpInfoChangeReqPopup&authPg=A", $.extend(param,getKeyValues(sht)), "740","520");
                url = '/Popup.do?cmd=viewEmpInfoChangeReqLayer&authPg=A';
                param = $.extend(param,getKeyValues(sht));
                empInfoChangeReqPopup(url, param);
			}

			break;
	}
	sht = null;

}

/**
 * 비밀번호 확인이 필요한 신청 건
 * @param param 파라미터
 * @returns {boolean}
 */
const isNeedCheckPassword = (param) => {
    return (param.transType === "U" && param.empTable === "thrm100");
}

/**
 * 인사 정보 레이어 팝업 layer popup
 * @param pUrl
 * @param param
 */
function empInfoChangeReqPopup(pUrl, param) {
	var transTypeNm = ""
    if(param.transType  == "I")      transTypeNm = "등록";
    else if(param.transType  == "U") transTypeNm = "수정";
    else if(param.transType  == "D") transTypeNm = "삭제";

    if (isNeedCheckPassword(param)) {
        // 비밀번호 체크가 필요한 신청이면 비밀번호 레이어팝업이 우선 표시됨.
        new window.top.document.LayerModal({
            id : 'pwConLayer'
            , url : '/Popup.do?cmd=pwConLayer'
            , parameters : ""
            , width : 500
            , height : 300
            , title : '비밀번호 확인'
            , trigger :[
                {
                    name : 'pwConLayerTrigger'
                    , callback : function(result){
                        if (result.result === "Y") {
                            new window.top.document.LayerModal({
                                id : 'empInfoChangeReqLayer'
                                , url : pUrl
                                , parameters : param
                                , width : 740
                                , height : 520
                                , title : param.eTableNm + ' ' + transTypeNm +' 신청'
                                , trigger :[
                                    {
                                        name : 'empInfoChangeReqTrigger'
                                        , callback : function(result){
                                        }
                                    }
                                ]
                            }).show();
                        }
                    }
                }
            ]
        }).show();
    } else {
        new window.top.document.LayerModal({
            id : 'empInfoChangeReqLayer'
            , url : pUrl
            , parameters : param
            , width : 740
            , height : 520
            , title : param.eTableNm + ' ' + transTypeNm +' 신청'
            , trigger :[
                {
                    name : 'empInfoChangeReqTrigger'
                    , callback : function(result){
                    }
                }
            ]
        }).show();
    }
}

//개인 이미지 변경 레이어 팝업 layer popup
function empPictureChangeReqPopup(pUrl, param) {

	 let layerModal = new window.top.document.LayerModal({
	       id : 'empPictureChangeReqLayer'
	     , url : pUrl
	     , parameters : param
	     , width : 540
	     , height : 620
	     , title : '개인 이미지 수정 신청'
	     , trigger :[
	         {
	               name : 'empPictureChangeReqTrigger'
	             , callback : function(result){
	             }
	         }
	     ]
	 });
	 layerModal.show();
}


function getKeyValues(sht){
	var ret = {}
	var srow = selectRow;
	if(srow<1) return ret;

	for(var i=0 ; i<sht.LastCol(); i++){
		/* if(sht.GetCellProperty(srow, i, "KeyField") == 1){//key field인 경우
			ret[sht.GetCellProperty(srow, i, "SaveName")] = sht.GetCellValue(srow, i, sht.GetCellProperty(srow, i, "SaveName"));

		} */
		// 자동으로 등록되는 seq의 경우에는 key field로 등록하지 않기 때문에 가져올 수 없음. 그냥 모든 값을 가지고 empInfoChangeReqPopup에서 pk 체크해서 값 가져와야함. by kwook
		ret[sht.GetCellProperty(srow, i, "SaveName")] = sht.GetCellValue(srow, i, sht.GetCellProperty(srow, i, "SaveName"));
	}

	return ret;
}

//개인서명이미지 등록 2020.08.06
function doSignImgChangeReq(){

	if(!isPopup()) {return;}

	pGubun = "doSignImgChangeReq";

    var args    = new Array();

    args["sabun"]  = $("#hdnSabun").val();
    args["name"]  = $("#name").val();

    //var win = openPopup("/Popup.do?cmd=signRegPopup", args, "500","590");
    url = '/Popup.do?cmd=viewSignRegLayer';
    signRegPopup(url, args);
    
}

//개인 서명이미지 변경 레이어 팝업 layer popup
function signRegPopup(pUrl, param) {

     let layerModal = new window.top.document.LayerModal({
           id : 'signRegLayer'
         , url : pUrl
         , parameters : param
         , width : 500
         , height : 650
         , title : '서명등록'
         , trigger :[
             {
                   name : 'signRegTrigger'
                 , callback : function(result){
                 }
             }
         ]
     });
     layerModal.show();
}
</script>
