<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8"%>
<%@ page import="yjungsan.util.*"%>
<!DOCTYPE html> <html class="hidden"><head> <title></title>
<%@ include file="../common/include/session.jsp"%>
<%@ include file="../common/include/meta.jsp"%><!-- Meta -->
<%@ include file="../common/include/jqueryScript.jsp"%>
<%@ include file="../common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
    var p = eval("<%=popUpStatus%>");
    $(function() {
    	$("#workYy").val("<%=yeaYear%>") ;
        $('.close').on('click', function() {
            fnCansel();
        });

        var arg = p.window.dialogArguments;
        var type                    = "";
        var type2                   = "";
        var menuNm                  = "";

        if( arg != undefined ) {
            type                = arg["type"];
            type2               = arg["type2"];
            menuNm              = arg["menuNm"];
        }else{
            if ( p.popDialogArgument("type") !=null )           { type              = p.popDialogArgument("type"); }
            if ( p.popDialogArgument("type2") !=null )          { type2             = p.popDialogArgument("type2"); }
            if ( p.popDialogArgument("menuNm") !=null )          { menuNm             = p.popDialogArgument("menuNm"); }
        }
        $("#type").val(type);
        $("#type2").val(type2);
        $("#menuNm").val(menuNm);
        $("#reason").focus();
    });
    //사유 저장
    function fnSave() {

        var returnValue = false;
        try {
            if(!checkList(status)) return;

            if(!lengthChk($("#reason").val())) return;

            var params = $("#dataForm").serialize();
            var rtn = ajaxCall("<%=jspPath%>/auth/beforeDownloadPopupRst.jsp?cmd=saveDownReasonCont",params,false);

            if(rtn.Result.Code < 1) {
                alert(rtn.Result.Message);
                returnValue = false;
            } else {
                returnValue = true;
            }
            if(p.saveReasonReValue) p.saveReasonReValue(returnValue,$("#type2").val());
            p.self.close();

        } catch (ex){
            alert("저장 중 오류발생." + ex);
            returnValue = false;
        }

        return returnValue;
    }
    // 입력시 조건 체크
    function checkList(status) {
        var ch = true;
        // 화면의 개별 입력 부분 필수값 체크
        $(".required").each(function(index){
            if($(this).val() == null || $(this).val() == ""){
                alert($(this).parent().prev().text()+"은(는) 필수값입니다.");
                $(this).focus();
                ch =  false;
                return false;
            }

            return ch;
        });

        if(!ch) return ch;
        return ch;
    }
    function fnCansel() {
        p.self.close();
    }
    function lengthChk(reason){
    	var lenChk = true;
    	if(reason.length > 1000){
    		lenChk = false;
    	      alert("최대 입력 글자수를 초과하였습니다");
    	}
    	return lenChk;
    }
</script>
</head>

<body class="bodywrap">
<form name="dataForm" id="dataForm" method="post">
    <input type="hidden" id="type" name="type" />
    <input type="hidden" id="type2" name="type2" />
    <input type="hidden" id="workYy" name="workYy" />
    <input type="hidden" id="menuNm" name="menuNm" />
<div class="wrapper">
    <div class="outer">
        <div class="popup_title">
            <ul>
                <li>개인정보 다운로드 사유 입력</li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
            <div class="inner">
                <div class="sheet_title">
                <ul>
                    <li id="txt" class="txt">개인정보가 포함 될 경우 사유를 입력해야만 다운로드 됩니다.</li>
                </ul>
                </div>
            </div>
            <div>
                <table class="table">
                    <colgroup>
                        <col width="15%" />
                        <col width="*" />
                    </colgroup>
                    <tr>
                        <th>사유</th>
                        <td>
                            <textarea id="reason" name="reason" class="<%=removeXSS(textCss, '1')%> required w100p" rows="5" placeholder="내용을 입력해주세요(최대 1000자)"></textarea>
                        </td>
                    </tr>
                </table>
            </div>
            <div class="popup_button outer">
                <ul>
                    <li>
                        <a href="javascript:fnSave()"    class="gray large">저장</a>
                        <a href="javascript:fnCansel()"    class="gray large">닫기</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
    </div>
</form>
</body>
</html>