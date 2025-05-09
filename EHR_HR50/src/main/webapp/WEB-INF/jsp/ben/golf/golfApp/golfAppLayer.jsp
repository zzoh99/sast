<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head><title>골프장예약신청</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->

<script type="text/javascript">
var gPRow = "";
var pGubun = "";
	$(function() {
		
		const modal = window.top.document.LayerModalUtility.getModal('golfAppLayer');
        var selectDate = modal.parameters.selectDate ;
        var applSeq = modal.parameters.applSeq ;
        var viewYn = modal.parameters.viewYn ;
        var golfList = modal.parameters.golfList ;
        
		// 입력폼 처리
		$("#golfCd").html(golfList);
		$("#golfCd").change(function(){
			$("#span_golfAddr").html($("#golfCd option:selected").attr("golfAddr"));
			$("#span_golfMon").html($("#golfCd option:selected").attr("golfMon"));
			$("#span_note").html(replaceAll($("#golfCd option:selected").attr("note"), "\n", "<br>"));
		}).change();
		//시간
		$("#reqTimeSt").mask("00:00", {reverse: true});
		$("#reqTimeEd").mask("00:00", {reverse: true});
		detailPopup(applSeq, selectDate, viewYn);
	    
	});


	// 상세/등록	
	function detailPopup(applSeq, selectDate, viewYn){
		$("#popFrm")[0].reset();
		if(applSeq != ""){
			if( viewYn == "N" ) return;
			// 상세정보 셋팅
			
			var map = ajaxCall("${ctx}/GolfApp.do?cmd=getGolfAppMap", "searchApplSeq="+applSeq, false);
			$("#applSeq", "#popFrm").val(map.DATA.applSeq);
			$("#reqYmd", "#popFrm").val(map.DATA.reqYmd);
			$("#span_reqYmd").html(formatDate(map.DATA.reqYmd,"-"));
			
			$("#golfCd", "#popFrm").val(map.DATA.golfCd).change();
			$("#reqSabun", "#popFrm").val(map.DATA.reqSabun);
			$("#reqUser", "#popFrm").val(map.DATA.reqUser);
			$("#span_reqUser", "#popFrm").html(map.DATA.reqUser);
			$("#userTypeCd", "#popFrm").val(map.DATA.userTypeCd);
			$("#userNm", "#popFrm").val(map.DATA.userNm);
			$("#phoneNo", "#popFrm").val(map.DATA.phoneNo);
			$("#mailId", "#popFrm").val(map.DATA.mailId);
			$("#note", "#popFrm").val(map.DATA.note);
			$("#cancelReason", "#popFrm").val(map.DATA.cancelReason);
			$("#statusCd", "#popFrm").val(map.DATA.statusCd);
			$("#span_statusCd", "#popFrm").html(map.DATA.statusNm);
			$("#reqTimeSt", "#popFrm").val(map.DATA.reqTimeSt).mask("00:00", {reverse: true});
			$("#reqTimeEd", "#popFrm").val(map.DATA.reqTimeEd).mask("00:00", {reverse: true});
			$("#confTime", "#popFrm").val(map.DATA.confTime).mask("00:00", {reverse: true});

			if( "${curSysYyyyMMdd}" >= map.DATA.reqYmd ) { //과거일자 수정 불가.
				
				$("#addBtn,#modifyBtn,#delBtn").hide();
				setFormEnable(0);
			}else{
				if(map.DATA.statusCd == '21'){ //신청처리중
					// 삭제 가능
					$("#delBtn").show();
					$("#addBtn,#modifyBtn").hide();
					$("#cancelReason-wrap", "#popFrm").hide();
					setFormEnable(0);
				}else if(map.DATA.statusCd == '99' ){ //예약완료
					// 취소요청 가능
					$("#modifyBtn").show();
					$("#addBtn,#delBtn").hide();
					setFormEnable(3);
				}else{
					$("#addBtn,#modifyBtn,#delBtn").hide();
					$("#cancelReason-wrap", "#popFrm").hide();
					setFormEnable(0);
				}
			}
		}else if(selectDate != ""){

			$("#applSeq", "#popFrm").val("");
			$("#span_statusCd", "#popFrm").html("");
			$("#cancelReason-wrap", "#popFrm").hide();

			var reqYmd = selectDate;

			var param = "golfCd="+$("#searchGolfCd").val()+"&reqYmd="+reqYmd;
	    	var dup = ajaxCall("/GolfApp.do?cmd=getGolfAppUserDupCheck", param,false);

	    	if(Number(dup.DATA.dupCnt) > 0){
	    		alert("해당일자에 예약건이 존재합니다.");
	    		return;
	    	}else{
		    	
				$("#addBtn").show();
				$("#modifyBtn,#delBtn").hide();
				$("#reqSeq", "#popFrm").val("");
				setFormEnable(1);
				
				// 세션사용자의 연락저 정보
				var user = ajaxCall( "${ctx}/GolfApp.do?cmd=getGolfAppUserMap", "",false);
				if ( user != null && user.DATA != null ){ 
					$("#phoneNo", "#popFrm").val(user.DATA.phoneNo );
					$("#mailId", "#popFrm").val(user.DATA.mailId );
				}
			
				// 신규예약
				$("#reqYmd", "#popFrm").val(reqYmd);
				
				$("#span_golfCd").html($("#searchGolfCd option:selected").text());
				$("#span_reqYmd").html(reqYmd);
				
				
				//기본으로 신청자정보는 본인 정보
				$("#reqSabun", "#popFrm").val("${ssnSabun}");
				$("#userNm", "#popFrm").val("${ssnName}");
				$("#reqUser", "#popFrm").val("${ssnName} / ${ssnOrgNm}");
				$("#span_reqUser", "#popFrm").html("${ssnName} / ${ssnOrgNm}");
				
				// 검색조건에 회의실선택된 경우 기본값으로 셋팅.
				if($("#searchGolfCd").val() != ""){
					$("#golfCd", "#popFrm").val($("#searchGolfCd").val());
				}
			}
	    	return;
		}else{
			return;
		}
	}
	
	function setFormEnable(enable){
		var arr = ["golfCd", "reqTimeSt", "reqTimeEd", "reqUser", "userTypeCd", "userNm", "phoneNo", "mailId", "note", "cancelReason"];
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
		}else {
			$("#employeePopBtn").hide();
		}
		//취소신청시
		if(enable == 3){
			$("#cancelReason", "#popFrm").removeAttr("readonly").removeClass("transparent").removeClass("readonly").addClass("required");
		}else{
			$("#cancelReason", "#popFrm").attr("readonly", true).addClass("transparent").addClass("readonly").removeClass("required");
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
		
    	var dup = ajaxCall("/GolfApp.do?cmd=getGolfAppUserDupCheck", $("#popFrm").serialize(),false);
    	if(Number(dup.DATA.dupCnt) > 0){
    		alert("해당일자에 예약건이 존재합니다.");
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
        	}else if( sStatus == "U" ){
        		if( $.trim($("#cancelReason", "#popFrm").val()) == "" ){
        			alert("취소사유를 입력 해주세요.");
        			$("#cancelReason", "#popFrm").focus();
        			return;
        		}
        	}
			
        	var result = ajaxCall("/GolfApp.do?cmd=saveGolfApp", $("#popFrm").serialize(),false);
        	if(result != null && result.Result.Code != null){
                const modal = window.top.document.LayerModalUtility.getModal('golfAppLayer');
                modal.fire('golfAppTrigger', {}).hide();
                alert("처리되었습니다.");
        	}else{
        		alert("처리 중 오류가 발생했습니다.");
        	}

        }catch(ex){alert("Save Event Error : " + ex);}
	}
	
	// 사원 팝업
	function showEmployeePopup() {
		pGubun = "employeePopup";
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
        const modal = window.top.document.LayerModalUtility.getModal('golfAppLayer');
        modal.hide();
    }
    
</script>
<style type="text/css">
body { font-size: 11px !important; }
textarea.transparent {
	border:none !important;
	background:none !important;
}

.fc-event-title {line-height:18px;}
.fc-event-title:hover {text-decoration: underline; cursor:pointer;}
.fc-day:hover {cursor:pointer; background-color:#eefaff;}

.confInfo th {background-color:#fbf3f8 !important; }	
.golfInfo th {background-color:#f9fcfe !important; }	

.color-black { color: #fff; background-color:#808080; }
.color-blue { color: blue; background-color:#ffff00;  }
.color-purple { color: purple; }
.color-gray { color: gray;  text-decoration:line-through!important;}
.color-red { color: red; }
</style>
</head>
<body class="bodywrap">
<div class="wrapper modal_layer">
	<!-- 상세조회(등록) 팝업 -->
	<div class="modal_body">
		<form id="popFrm" name="popFrm" >
			<input type="hidden" id="applSeq" name="applSeq" />
			<input type="hidden" id="sStatus" name="sStatus" />
			<input type="hidden" id="statusCd" name="statusCd" />
			<input type="hidden" id="reqYmd" name="reqYmd" />
			<table class="default golfInfo">
			<colgroup>
				<col width="120"/>
				<col width="200"/>
				<col width="120"/>
				<col/>
			</colgroup>
			<tr>
				<th>골프장명</th>
				<td>
					<select id="golfCd" name="golfCd"></select>
				</td>
				<th>이용요금</th>
				<td>
					<span id="span_golfMon"></span>
				</td>
			</tr>
			<tr>
				<th>골프장주소</th>
				<td colspan="3">
					<span id="span_golfAddr"></span>
				</td>
			</tr>
			<tr>
				<th>유의사항</th>
				<td colspan="3">
					<span id="span_note"></span>
				</td>
			</tr>
			</table>
			<div class="h10"></div>
			<table class="default">
			<colgroup>
				<col width="120"/>
				<col width="200"/>
				<col width="120"/>
				<col/>
			</colgroup>
			<tr>
				<th>신청일자</th>
				<td>
					<span id="span_reqYmd"></span>
				</td>
				<th>신청상태</th>
				<td>
					<span id="span_statusCd" style="color:blue;"></span>
				</td>
			</tr>
			<tr>
				<th>희망시간대</th>
				<td>
					<input type="text" id="reqTimeSt" name="reqTimeSt" class="w50 text required" maxlength="5"/> ~
					<input type="text" id="reqTimeEd" name="reqTimeEd" class="w50 text required" maxlength="5"/> 
				</td>
				<th>신청자</th>
				<td>
					<input type="hidden" id="reqSabun" name="reqSabun" />
						<c:choose>
							<c:when test="${ssnGrpCd == '10'}">						
												<input type="text" id="reqUser" class="text readonly required w80p" readonly vtxt='신청자'/>&nbsp;<a id="employeePopBtn" href="javascript:showEmployeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
							</c:when>
							<c:otherwise>
												<span id="span_reqUser"></span>
							</c:otherwise>
						</c:choose>	
				</td>
			</tr>
			<tr>
				<th>이용자구분</th>
				<td>
					<select id="userTypeCd" name="userTypeCd">
						<option value="0">본인</option>
						<option value="1">거래처</option>
					</select>
				</td>
				<th>이용자명(거래처명)</th>
				<td>
					<input type="text" id="userNm" name="userNm" class="w100p text required " />
				</td>
			</tr>
			<tr>
				<th>연락처</th>
				<td>
					<input type="text" id="phoneNo" name="phoneNo" class="w100p text required" />
				</td>
				<th>메일주소</th>
				<td>
					<input type="text" id="mailId" name="mailId" class="w100p text required" />
				</td>
			</tr>
			<tr>
				<th>기타요청사항</th>
				<td class="content" colspan="3">
					<textarea id="note" name="note" rows="2" class="${textCss} w100p"></textarea>
				</td>
			</tr>
			<tr id="cancelReason-wrap">
				<th>취소사유</th>
				<td class="content" colspan="3">
					<textarea id="cancelReason" name="cancelReason" rows="2" class="${textCss} w100p"></textarea>
				</td>
			</tr>
			</table>
			<div class="h10"></div>
			<table class="default confInfo">
			<colgroup>
				<col width="120"/>
				<col/>
			</colgroup>
			<tr>
				<th>확정시간</th>
				<td>
					<input type="text" id="confTime" name="confTime" class="w70 text readonly" readonly />
				</td>
			</tr>
			</table>
		</form>
	</div>
    <div class="modal_footer">
	    <a href="javascript:doSave('I');"       class="btn filled" id="addBtn">신청</a>
	    <a href="javascript:doSave('U');"       class="btn filled" id="modifyBtn">취소신청</a>
	    <a href="javascript:doSave('D');"       class="btn filled" id="delBtn">회수</a>
	    <a href="javascript:closeLayerModal();"  class="btn outline_gray">닫기</a>  
     </div>
</div>

</body>
</html>