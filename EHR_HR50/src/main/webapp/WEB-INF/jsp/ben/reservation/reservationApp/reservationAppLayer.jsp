<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head><title>자원예약신청</title>


<script type="text/javascript">
     $(function() {
    	 
         const modal = window.top.document.LayerModalUtility.getModal('reservationAppLayer');
         var selectDate = modal.parameters.selectDate ;
         var applSeq = modal.parameters.applSeq ;
         var reqParam = modal.parameters.reqParam ;

         //신청일자
		 $("#eYmd").datepicker2({enddate:"sYmd"});
         //시간
         
         $("#sTime").mask("00:00", {reverse: true});
         $("#eTime").mask("00:00", {reverse: true});
        
         //종일 체크 시
         $("#dayYnChk").change(function() {

             if( $("#dayYnChk").is(':checked') ){
                 $("#dayYn").val("Y");

                 $("#sTime, #eTime").removeClass("required").attr("readonly","readonly").val("");
             }else{
                 $("#dayYn").val("N");
                 $("#sTime, #eTime").addClass("required").removeAttr("readonly");
             }

         });

		 detailPopup(applSeq, selectDate);
         setResSeqCombo(reqParam);
     });
     
     function setResSeqCombo(reqParam){
         //자원명
         var resSeqList = convCodeCols( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList","queryId=getReservationAppResCdList"+reqParam,false).codeList
                       , "note,resTypeNm,resLocationNm", "");
         
         $("#resSeq").html(resSeqList[2]);
         $("#resSeq").change(function(){
             $("#span_note").html(replaceAll($("#resSeq option:selected").attr("note"), "\n", "<br>"));
             $("#span_resTypeNm").html($("#resSeq option:selected").attr("resTypeCd"));
             $("#span_resLocationNm").html($("#resSeq option:selected").attr("resLocationNm"));
         
         });
         $("#resSeq").change();
     }
     
     
	// 상세/등록	
	function detailPopup(applSeq, selectDate){
		$("#popFrm")[0].reset();
		
		if(applSeq != ""){
			// 상세정보 셋팅
			var map = ajaxCall("${ctx}/ReservationApp.do?cmd=getReservationAppMap", "searchApplSeq="+applSeq, false);

			$("#applSeq", "#popFrm").val(map.DATA.applSeq);
			$("#resSeq", "#popFrm").val(map.DATA.resSeq).change();
			
			$("#reqSabun", "#popFrm").val(map.DATA.reqSabun);
			$("#reqUser", "#popFrm").val(map.DATA.reqUser);
			$("#span_reqUser", "#popFrm").html(map.DATA.reqUser);
			$("#phoneNo", "#popFrm").val(map.DATA.phoneNo);
			$("#mailId", "#popFrm").val(map.DATA.mailId);
			$("#title", "#popFrm").val(map.DATA.title);
			$("#contents", "#popFrm").val(map.DATA.contents);

			$("#sYmd", "#popFrm").val(formatDate(map.DATA.sYmd,"-"));
			$("#eYmd", "#popFrm").val(formatDate(map.DATA.eYmd,"-"));

			$("#sTime", "#popFrm").val(map.DATA.sTime).mask("00:00", {reverse: true});
			$("#eTime", "#popFrm").val(map.DATA.eTime).mask("00:00", {reverse: true});
			$("#dayYn", "#popFrm").val(map.DATA.dayYn);
			if( map.DATA.dayYn =="Y" ){ //종일
				$("#dayYnChk").attr("checked", true);
				$("#timeGb").hide();
			}else{
				$("#dayYnChk").attr("checked", false);
				$("#timeGb").show();	
			}
			
			if( "${curSysYyyyMMdd}" >= map.DATA.eYmd ) { //과거일자 수정 불가.
				$("#addBtn,#delBtn").hide();
				setFormEnable(0);
			}else{
				// 삭제 가능
				if( map.DATA.editYn == "Y" ) $("#delBtn").show();
				$("#addBtn").hide();
				setFormEnable(0);
			}
			
			return;
		}else if(selectDate != ''){ //신규신청

			$("#applSeq", "#popFrm").val("");
			
			/* var d = String(selectDate.getDate());
			var m = String(selectDate.getMonth()+1);
			var y = String(selectDate.getFullYear());
			d = d.length == 1? "0"+d : d;
			m = m.length == 1? "0"+m : m;
			var reqYmd = y+"-"+m+"-"+d; */

			var reqYmd = selectDate;

			$("#searchResSeq").val();
		    	
			$("#addBtn").show();
			$("#delBtn").hide();
			$("#resSeq", "#popFrm").val($("#resSeq", "#popFrm").val(""));
			$("#span_note, #span_resTypeNm, #span_resLocationNm").html("");
			
			$("#dayYnChk").attr("checked", false);
			$("#sTime, #eTime").addClass("required").removeAttr("readonly");
			setFormEnable(1);

			// 세션사용자의 연락저 정보
			var user = ajaxCall( "${ctx}/ReservationApp.do?cmd=getReservationAppUserMap", "",false);
			if ( user != null && user.DATA != null ){ 
				$("#phoneNo", "#popFrm").val(user.DATA.phoneNo );
				$("#mailId", "#popFrm").val(user.DATA.mailId );
			}
		
			// 신규예약
			$("#sYmd", "#popFrm").val(reqYmd);
			$("#eYmd", "#popFrm").val(reqYmd);
			
			//기본으로 신청자정보는 본인 정보
			$("#reqSabun", "#popFrm").val("${ssnSabun}");
			$("#userNm", "#popFrm").val("${ssnName}");
			$("#reqUser", "#popFrm").val("${ssnName} / ${ssnOrgNm}");
			$("#span_reqUser", "#popFrm").html("${ssnName} / ${ssnOrgNm}");

			$("#timeGb").show();
			
			return;
		}else{
			return;
		}
	}

    function setFormEnable(enable){
        
        var arr = ["resSeq", "eYmd", "sTime", "eTime", "title", "contents", "phoneNo", "mailId", "reqUser"];
        for( var i=0; i < arr.length; i++){
            if( $("#"+arr[i]).prop("tagName") == "SELECT" ){

                if(enable == 1){
                    $("#"+arr[i], "#popFrm").removeAttr("disabled").removeClass("transparent").addClass("required").removeClass("hideSelectButton");
                }else {
                    $("#"+arr[i], "#popFrm").attr("disabled", true).addClass("transparent").removeClass("required").addClass("hideSelectButton");
                }
                
            }else if( $("#"+arr[i]).prop("tagName") == "INPUT" || $("#"+arr[i]).prop("tagName") == "TEXTAREA" ){

                if(enable == 1){
                    $("#"+arr[i], "#popFrm").removeAttr("readonly").removeClass("transparent").removeClass("readonly");
                }else {
                    $("#"+arr[i], "#popFrm").attr("readonly", true).addClass("transparent").addClass("readonly");
                }
            }
        }
        if(enable == 1){
            $("#employeePopBtn").show();
            $(".ui-datepicker-trigger", "#popFrm").show();
            $("#dayYnChk").removeAttr("disabled");//종일체크
        }else {
            $("#employeePopBtn").hide();
            $(".ui-datepicker-trigger", "#popFrm").hide();
            $("#dayYnChk").attr("disabled", true); //종일체크
        }
    }

     // 저장
    function checkList(){
        var ch = true;
        // 화면의 개별 입력 부분 필수값 체크
        $(".required").each(function(index){
            if($(this).val() == null || $(this).val() == ""){
                alert($(this).parent().prev().text()+"<msg:txt mid='required2' mdef='은(는) 필수값입니다.' />");
                $(this).focus();
                ch =  false;
                return false;
            }

            return ch;
        });
        
        if(!ch) return false;

		// 시작일자와 종료일자 체크
		if ($("#sYmd").val() != "" && $("#eYmd").val() != "") {
			if (!checkFromToDate($("#sYmd"),$("#eYmd"),"신청일자","신청일자","YYYYMMDD")) {
				return false;
			}
		}
        
        if( $("#dayYn").val() == "N" && $("#sTime").val().length != 5){
			alert("<msg:txt mid='sTimeErrMsg' mdef='신청 시작시간을 잘못 입력 했습니다.'/>")
            $("#sTime").focus();
            return false;
        } 
        if( $("#dayYn").val() == "N" && $("#eTime").val().length != 5){
			alert("<msg:txt mid='eTimeErrMsg' mdef='신청 종료시간을 잘못 입력 했습니다.'/>")
            $("#eTime").focus();
            return false;
        } 

        var params = "resSeq="+$("#resSeq").val() 
                   + "&sYmd="+$("#sYmd").val().replace(/-/gi,"")
                   + "&eYmd="+$("#eYmd").val().replace(/-/gi,"");
        if( $("#dayYn").val() == "Y" ){
            params += "&sTime=0000&eTime=2400";
        }else{
            params += "&sTime="+$("#sTime").val().replace(/:/gi,"")
                   + "&eTime="+$("#eTime").val().replace(/:/gi,"");
        }
                
        var dup = ajaxCall("/ReservationApp.do?cmd=getReservationAppUserDupCheck", params,false);
        if(dup.DATA.dupCnt > 0){
			alert("<msg:txt mid='dupReservationErrMsg' mdef='해당일자에 예약건이 존재합니다.'/>")
            return false;
        }
        return true;
    }
    // 저장
    function doSave(sStatus){
        try{
            $("#sStatus").val(sStatus);
            
            if( sStatus == "I" ){
                if ( !checkList() ) {
                    return;
                }
            }else if( sStatus == "D" ){
                if( !confirm("<msg:txt mid='cancleResMsgV1' mdef='예약을 취소하시겠습니까?'/>") ) return;
            }
            
            var result = ajaxCall("/ReservationApp.do?cmd=saveReservationApp", $("#popFrm").serialize(),false);
            if(result != null && result.Result.Code != null){
            	
            	const modal = window.top.document.LayerModalUtility.getModal('reservationAppLayer');
                modal.fire('reservationAppTrigger', {}).hide();
				alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
            }else{
				alert("<msg:txt mid='109651' mdef='처리 시 오류가 발생하였습니다.'/>");
            }

        }catch(ex){alert("Save Event Error : " + ex);}
    }

    // 사원 팝업
    function showEmployeePopup() {
        //openPopup("/Popup.do?cmd=employeePopup&authPg=R&sType=T", "", "740","520");
        try{
            var args    = new Array();
            pGubun = "employeePopup";
               let layerModal = new window.top.document.LayerModal({
                      id : 'employeeLayer'
                      , url : '/Popup.do?cmd=viewEmployeeLayer'
                      , parameters : args
                      , width : 740
                      , height : 520
                      , title : '사원조회'
                      , trigger :[
                          {
                              name : 'employeeTrigger'
                              , callback : function(result){
                                  getReturnValue(result);
                              }
                          }
                      ]
                  });
                  layerModal.show();
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }
    
    function getReturnValue(rv) {
        //var rv = $.parseJSON('{' + returnValue+ '}');
        if(pGubun == "employeePopup"){
            $("#reqSabun", "#popFrm").val(rv["sabun"]  );
            $("#reqUser", "#popFrm").val(rv["name"] + " / " + rv["orgNm"]);
            $("#phoneNo", "#popFrm").val(rv["handPhone"] );
            $("#mailId", "#popFrm").val(rv["mailId"] );
        }
    }
    
    function closeLayerModal(){
        const modal = window.top.document.LayerModalUtility.getModal('reservationAppLayer');
        modal.hide();
    }
    
</script>
<style type="text/css">
body { font-size: 11px !important; }
textarea.transparent {
    border:none !important;
    background:none !important;
}
    
.resInfo th {background-color:#f9fcfe !important; }

/*---- checkbox ----*/
input[type="checkbox"]  { 
    display:inline-block; width:20px; height:20px; cursor:pointer; appearance:none; 
    -moz-appearance:checkbox; -webkit-appearance:checkbox; margin-top:2px;background:none;
    border: 5px solid red;
}
label {
    vertical-align:-2px;padding-right:10px;
}   
</style>
</head>
<body class="bodywrap">
    <div class="wrapper modal_layer">
        <div class="modal_body">
		<!-- 상세조회(등록) 팝업 -->	

			<form id="popFrm" name="popFrm" >
				<input type="hidden" id="applSeq" name="applSeq" />
				<input type="hidden" id="sStatus" name="sStatus" />
				<input type="hidden" id="dayYn" name="dayYn" />
				<table class="default resInfo">
				<colgroup>
					<col width="100"/>
					<col width="300"/>
					<col width="100"/>
					<col/>
				</colgroup>
				<tr>
					<th><tit:txt mid='resSeqNm' mdef='자원명'/></th>
					<td colspan="3">
						<select id="resSeq" name="resSeq"></select>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='psnlWorkScheduleMgr2' mdef='유의사항'/></th>
					<td colspan="3">
						<span id="span_note"></span>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104084' mdef='신청일자'/></th>
					<td>
						<input type="text" id="sYmd" name="sYmd" class="date2" value="" readonly/> ~
						<input type="text" id="eYmd" name="eYmd" class="date2 required" value=""/>
					</td>
					<th><tit:txt mid='workHmV1' mdef='신청시간'/></th>
					<td>
						<input type="text" id="sTime" name="sTime" class="w60 text required center" maxlength="5"/><span id="timeGb"> ~ </span>
						<input type="text" id="eTime" name="eTime" class="w60 text required center" maxlength="5"/>
					</td>
				<tr>
					<th><tit:txt mid='L1706090000001' mdef='신청자' /></th>
					<td>
						<input type="hidden" id="reqSabun" name="reqSabun" />
						<input type="text" id="reqUser" class="text readonly required w80p" readonly vtxt='신청자'/>&nbsp;<a id="employeePopBtn" href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
					</td>
					<th><tit:txt mid='allDay' mdef='하루종일'/></th>
					<td>
						<input type="checkbox" id="dayYnChk" name="dayYnChk" style="vertical-align:middle;" class="${required}" ${disabled}/>
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='contact' mdef='연락처'/></th>
					<td>
						<input type="text" id="phoneNo" name="phoneNo" class="w100p text required" />
					</td>
					<th><tit:txt mid='mailId' mdef='메일주소'/></th>
					<td>
						<input type="text" id="mailId" name="mailId" class="w100p text required" />
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='resTitle' mdef='예약제목'/></th>
					<td colspan="3">
						<input type="text" id="title" name="title" class="w100p text required" />
					</td>
				</tr>
				<tr>
					<th><tit:txt mid='104429' mdef='내용'/></th>
					<td class="content" colspan="3">
						<textarea id="contents" name="contents" rows="3" class="${textCss} w100p"></textarea>
					</td>
				</tr>
				</table>
			</form>

		</div>
        <div class="modal_footer">
	        <a href="javascript:closeLayerModal();"  class="btn outline_gray"><tit:txt mid='104157' mdef='닫기'/></a>
	        <a href="javascript:doSave('D');"       class="btn filled" id="delBtn"><tit:txt mid='112396' mdef='취소'/></a>
	        <a href="javascript:doSave('I');"       class="btn filled" id="addBtn"><tit:txt mid='appComLayout' mdef='신청'/></a>
        </div>
    </div>
</body>
</html>