<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>중도상환</title>
<script type="text/javascript">

    var p = eval("${popUpStatus}");

    $(function() {
        
        const modal = window.top.document.LayerModalUtility.getModal('loanMgrRepLayer');
        
        $(".close").click(function() {
            //p.self.close();
            closeLayerModal();
        });

        arg = modal.parameters;
        console.log("init arg:" + arg);

        if ( undefined != arg.sabun || "" != arg.sabun) {
            $("#sabun").val(arg.sabun);
            $("#searchSabun").val(arg.sabun);
            $("#searchName").val(arg.name);
            setLoanCdCombo();   
        }
        
        /*
        var arg = p.popDialogArgumentAll();
        if( arg != undefined ) {
            $("#sabun").val(arg["sabun"]);
            $("#searchSabun").val(arg["sabun"]);
            $("#searchName").val(arg["name"]);
            setLoanCdCombo();    
            
        }*/
        
        
        $("#repYmd").datepicker2({
            onReturn:function(date){
                var intDays = f_sys_between_ymd($("#applySdate").val(), date.replace(/-/g, ''), "dd", "Y");
                if( !(intDays.indexOf("-") > 0 || intDays == "00") ) {
                    $("#applyDay").val(intDays);
                    $("#span_applyDay").html(intDays + "일");
                } else {
                    $("#applyDay").val("");
                    $("#span_applyDay").html("");
                }
            }
        });
        
        $('#repMon').blur(function(){
            if($(this).val() != "") {
                calcIntMon();
            }
        });
        
        $("#intMon").blur(function(){

            var repMon = ($('#repMon').val() != "" ) ? Number($('#repMon').val().replace(/,/g, '')) : 0;
            var intMon = ($(this).val() != "") ? Number($(this).val().replace(/,/g, '')) : 0;
            var totMon = repMon + intMon;

            $("#span_totMon").html(makeComma(totMon)+" 원" );
        });
        
        $('#repMon').mask('000,000,000,000,000', {reverse: true});
        $('#intMon').mask('000,000,000,000,000', {reverse: true});
        
        // 대출구분 콤보 change event
        $("#selectLoan").change(function() {
            var obj = $("#selectLoan option:selected");
            $("#applSeq").val(obj.attr("applSeq"));
            $("#span_loanYmd").html(obj.attr("applySdate"));
            $("#span_loanMon").html(makeComma(obj.attr("loanMon"))+" 원" );
            $("#span_loanRemMon").html(makeComma(obj.attr("remMon"))+" 원" );
            //$("#repMon").val(obj.attr("repMon"));
            $("#intRate").val(obj.attr("intRate"));
            $("#applySdate").val(obj.attr("applySdate"));
            $("#loanCd").val(obj.attr("loanCd"));
        });
        
        if( $("#searchSabun").val() != "" ) {
            $("#selectLoan").change();
        }
    });


    //사원 팝업
    function employeePopup(){
        try{
            var args    = new Array();
            pGubun = "employeePopup";
            //openPopup("/Popup.do?cmd=employeePopup", args, "740","520");
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
                                  $("#searchName").val(result["name"]);
                                  $("#searchSabun").val(result["sabun"]);
                                  $("#sabun").val(result["sabun"]);
                                  
                                  setLoanCdCombo();
                                  $("#selectLoan").change();
                              }
                          }
                      ]
                  });
                  layerModal.show();
        }catch(ex){alert("Open Popup Event Error : " + ex);}
    }

    //팝업 콜백 함수.
    function getReturnValue(returnValue) {
        var rv = $.parseJSON('{' + returnValue+ '}');
        if(pGubun == "employeePopup")  {
            $("#searchName").val(rv["name"]);
            $("#searchSabun").val(rv["sabun"]);
            $("#sabun").val(rv["sabun"]);
            
            setLoanCdCombo();
            $("#selectLoan").change();
        }
    }

    function doSaveData() {

        if($("#repMon").val() == ""){
            alert("상환금액을 입력하세요.");
            $("#repMon").focus();
            return;
        }
        if($("#repYmd").val() == ""){
            alert("상환일자를 입력하세요.");
            $("#repYmd").focus();
            return;
        }
        if($("#applSeq").val() == ""){
            alert("대출을 선택하세요.");
            $("#selectLoan").focus();
            return;
        }
        
        if( parseInt(replaceAll($("#repMon").val(), ",","")) > parseInt(replaceAll($("#span_loanRemMon").html(), ",","") )){
            alert("상환금액은 대출잔액 "+$("#span_loanRemMon").html()+"을 넘길 수 없습니다.");
            $("#repMon").focus();
            return;
        }
        
        if (confirm($("#repMon").val() +"원 중도상환을 진행하겠습니까?")) {
            $("#btnSave").addClass("hide");
            progressBar(true) ;
            
            setTimeout(
                function(){
                    var param = "sabun=" + $("#sabun").val();
                        param += "&applSeq=" + $("#applSeq").val();
                        param += "&loanCd=" + $("#loanCd").val();
                        param += "&intRate=" + $("#intRate").val();
                        param += "&applySdate=" + $("#applySdate").val();
                        param += "&applyDay=" + $("#applyDay").val();
                        param += "&repYmd=" + $("#repYmd").val().replace(/-/gi,"");
                        param += "&repMon=" + $("#repMon").val().replace(/,/gi,"");
                        param += "&intMon=" + $("#intMon").val().replace(/,/gi,"");
                        param += "&note=" + $("#note").val();
                    
                    var data = ajaxCall("/LoanMgr.do?cmd=prcLoanMgrRepReg", param, false);
                    if(data.Result.Message == null) {
                        alert("중도상환 처리가  완료되었습니다.");
                        progressBar(false);
                        //top.opener.doAction1("Search");
                        //p.self.close();
                        const modal = window.top.document.LayerModalUtility.getModal('loanMgrRepLayer');
                        modal.fire('loanMgrRepTrigger', {}).hide();
                    } else {
                        alert("중도상환 진행중 : " + data.Result.Message);
                        progressBar(false);
                        $("#btnSave").removeClass("hide");
                    }
                }
                , 100
            );
        } else {
            return;
        }
    }

    // 대출종류 콤보 셋팅
    function setLoanCdCombo() {
        
        if ( $("#searchSabun").val() != ""){
             var param = "&searchApplSabun="+$("#searchSabun").val();
             var selectLoanList = convCodeCols(ajaxCall("${ctx}/LoanRepApp.do?cmd=getLoanRepAppDetLoanInfo", param, false).DATA
                                    , "loanCd,intRate,applySdate,repMon,loanMon,applSeq,loanEndYmd,remMon"
                                    , "");
             $("#selectLoan").html(selectLoanList[2]);
             $("#selectLoan").change();
        }
    }
    
    // 이자 계산
    function calcIntMon() {
    	
        if( $("#repYmd").val() != "" && $("#repMon").val() != "" ) {
        	
            var param = "repMon=" + $("#repMon").val().replace(/,/g, '');
                param += "&intRate=" + $("#intRate").val();
                param += "&repYmd=" + $("#repYmd").val();
                param += "&applySdate=" + $("#applySdate").val();
            var data = ajaxCall( "${ctx}/LoanRepApp.do?cmd=getLoanRepAppDetIntMon", param ,false);
            
            if ( data != null && data.DATA != null ){ 
                $("#intMon").val(makeComma(data.DATA.intMon));
                $("#applyDay").val(data.DATA.applyDay);
                $("#span_applyDay").html(data.DATA.applyDay+" 일" );
                $("#span_totMon").html(makeComma(data.DATA.totMon)+" 원" );
            }else{
                alert("이자 계산 시 오류가 발생 했습니다. 입력 정보를 확인 해주세요.");
                $("#repYmd").val("");
            }
        }
    }
    
    function closeLayerModal(){
        const modal = window.top.document.LayerModalUtility.getModal('loanMgrRepLayer');
        modal.hide();
    }
    
</script>

<body class="bodywrapper">
    <div class="wrapper modal_layer">
        <div class="modal_body">
            <form id="dataForm" name="dataForm" >
                <input id="searchSabun" name ="searchSabun" type="hidden" />
                <!-- add hidden -->
                <input type="hidden" id="applSeq"       name="applSeq"        value="" />
                <input type="hidden" id="loanCd"        name="loanCd"         value="" />
                <input type="hidden" id="intRate"       name="intRate"        value="" />
                <input type="hidden" id="applySdate"    name="applySdate"     value="" />
                <input type="hidden" id="applyDay"      name="applyDay"       value="" />
                <input type="hidden" id="repayType"     name="repayType"      value="02" />
            
                <div class="modal_layer">
                <!-- 
                    <div class="popup_title">
                    <ul>
                        <li>중도상환</li>
                        <li class="close"></li>
                    </ul>
                    </div>
                 -->
                    <div class="outer">
                        <div class="sheet_title">
                        <ul>
                            <li class="txt">중도상환</li>
                            <li class="btn">
                            <!--
                                <a href="javascript:doSaveData();"     class="basic">저장</a>
                                 -->
                            </li>
                        </ul>
                        </div>
                    </div>
                    <table class="table">
                        <colgroup>
                            <col width="15%" />
                            <col width="35%" />
                            <col width="15%" />
                            <col width="35%" />
                        </colgroup>
                        <tr>
                            <th>사번/성명</th>
                            <td>
                                <input id="searchName" name ="searchName" type="text" class="text required readOnly w100" readOnly />
                                <a onclick="javascript:employeePopup();" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
                                <!--
                                <a onclick="$('#searchSabun,#searchName').val('');" class="button7"><img src="/common/${theme}/images/icon_undo.gif"/></a>
                                -->
                            </td>
                            <th>사번</th>
                            <td>
                                <input id="sabun" name ="sabun" type="text" class="text required readOnly w100" readOnly />
                            </td>
                        </tr>
                        <tr>
                            <th>대출구분</th>
                            <td>
                                <select id="selectLoan" name="selectLoan" class="required" ></select>
                            </td>
                            <th>대출일자</th>
                            <td>
                                <span id="span_loanYmd"></span>
                            </td>
                        </tr>
                        <tr>
                            <th>대출금액</th>
                            <td>
                                <span id="span_loanMon"></span>
                            </td>
                            <th>대출잔액</th>
                            <td>
                                <span id="span_loanRemMon"></span>
                            </td>
                        </tr>
                        <tr>
                            <th align="center">상환일자</th>
                            <td>
                                <input id="repYmd" name="repYmd" type="text" size="10" class="date2 required" />
                            </td>
                            <th>적용일수</th>
                            <td>
                                <span id="span_applyDay">&nbsp;</span>
                            </td>
                        </tr>
                        <tr>
                            <th>상환금액</th>
                            <td>
                                <input id="repMon" name ="repMon" type="text" class="text required right w150" />
                                <a href="javascript:calcIntMon();" class="btn filled authR">이자계산</a>
                            </td>
                            <th>이자금액</th>
                            <td>
                                <input id="intMon" name ="intMon" type="text" class="text required right w150" />
                            </td>
                        </tr>
                        <tr>
                            <th>계</th>
                            <td colspan="3">
                                <span id="span_totMon">&nbsp;</span>
                            </td>
                        </tr>
                        <tr>
                            <th>비고</th>
                            <td colspan="3"><textarea id="note" name="note" rows="3" class="${textCss} w100p" ${readonly}  maxlength="1000"></textarea></td>
                        </tr>
                    </table>
                </div>
            </form>
        </div>
        <div class="modal_footer">
            <a href="javascript:closeLayerModal();" class="btn outline_gray">닫기</a>
            <a href="javascript:doSaveData();"   class="btn filled" id="btnSave">저장</a>
        </div>
    </div>
</body>
</html>