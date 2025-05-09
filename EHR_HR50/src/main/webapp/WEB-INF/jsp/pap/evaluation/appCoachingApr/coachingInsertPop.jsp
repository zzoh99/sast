<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<script type="text/javascript">
var p = eval("${popUpStatus}");


var authPg = "";

var appSeqCdNm = "";
var appName = "";
var editable = "";
var appraisalCd = "";
var sabun = "";
var appOrgCd = "";
var appSeqCd = "";
var appSabun = "";
var coaYmd = "";

	$(function() {
		$(".close").click(function() {
			p.self.close();
	    });

		var arg = p.popDialogArgumentAll();

	    if( arg != undefined ) {
	    	appSeqCdNm = arg["appSeqCdNm"];
	    	appName = arg["appName"];
	    	editable = arg["editable"];
	    	appraisalCd = arg["appraisalCd"];
	    	sabun = arg["sabun"];
	    	appOrgCd = arg["appOrgCd"];
	    	appSeqCd = arg["appSeqCd"];
	    	appSabun = arg["appSabun"];
	    	authPg = arg["authPg"];
	    	coaYmd = arg["coaYmd"];
	    }

	    $("#appSeqCdNm").val(appSeqCdNm);
	    $("#appName").val(appName);
	    $("#appraisalCd").val(appraisalCd);
	    $("#sabun").val(sabun);
	    $("#appOrgCd").val(appOrgCd);
	    $("#appSeqCd").val(appSeqCd);
	    $("#appSabun").val(appSabun);
	    $("#coaYmd").val(coaYmd);

		if(authPg=="A"){
			$("#tdYmd").datepicker2();
	    }else{
		    $("#tdYmd").attr("disabled", true);
	    }

		//$("#memo").attr("disabled", true);

		if(authPg != "A"){

			var data = ajaxCall("${ctx}/AppCoachingApr.do?cmd=getAppCoachingAprMap",$("#srchFrm").serialize(),false).DATA;

			if(data != null){
				$("#tdYmd").val(data.tdYmd.substr(0,4)+"-"+data.tdYmd.substr(4,2)+"-"+data.tdYmd.substr(6,2));
			    $("#coaPlace").val(data.coaPlace);
			    $("#memo").val(data.memo);
			}
		};

	});

	// 입력시 조건 체크
	function checkList(){

		var ch = true;

			if($("#tdYmd").val().length == 0){
				alert("날짜는 필수 입력사항 입니다.");
				$("#tdYmd").focus();
				ch =  false;
				return ch;
			}

			if(authPg == "A"){

				var data = ajaxCall("${ctx}/AppCoachingApr.do?cmd=getCoachingAprDupChk",$("#srchFrm").serialize(),false);

				if(data.map != null && data.map != ""){
					if(data.map.cnt > 0) {
						alert("동일일자에  코칭내역이 있습니다.");
						ch = false;
						return ch;
			    	}
				}
			}
		return ch;
	}

	function change(){

		if(!checkList()){
			return;
		}

		if(confirm("저장 하시겠습니까?")){
			$("#tdYmd").attr("disabled", false);
			var data = ajaxCall("${ctx}/AppCoachingApr.do?cmd=saveCoachingAprPop",$("#srchFrm").serialize(),false);

			if(data.Result.Code > 0) {
				alert("처리되었습니다.");
				var rv = new Array();
				rv["Code"] = "1";
				p.popReturnValue(rv);
				p.self.close();
	    	} else {
		    	alert(data.Result.Message);
	    	}
		}

	}
</script>
</head>
<body class="bodywrap">
<div class="wrapper">
        <div class="popup_title">
            <ul>
                <li>Coaching 내역 상세</li>
                <li class="close"></li>
            </ul>
        </div>
        <div class="popup_main">
            <form id="srchFrm" name="srchFrm">
	        <input type="hidden" id="appSeqCdNm" 			name="appSeqCdNm"       value=""/>
	        <input type="hidden" id="appName" 		name="appName"      value=""/>
	        <input type="hidden" id="appraisalCd" 		name="appraisalCd"    value=""/>
	        <input type="hidden" id="sabun" 		name="sabun"    value=""/>
	        <input type="hidden" id="appOrgCd" 		name="appOrgCd"   	  value=""/>
	    	<input type="hidden" id="appSeqCd" 	name="appSeqCd"  value=""/>
	    	<input type="hidden" id="appSabun" 	name="appSabun"  value=""/>
	    	<input type="hidden" id="coaYmd" 	name="coaYmd"  value=""/>

            <div class="inner">
			<table border="0" cellpadding="0" cellspacing="0" class="default outer">
			<colgroup>
				<col width="15%" />
				<col width="85%" />
				<%--
				<col width="25%" />
				<col width="25%" />
				--%>
			</colgroup>
			<tr>
				<th align="center">날짜</th>
				<td>
					<input id="tdYmd" name="tdYmd" class="date2 ${readonly} ${required} required " />
				</td>

			</tr>

			<tr>
				<th align="center">장소</th>
				<td>
					<input type="text" id="coaPlace" name="coaPlace" class = "text w100p">
				</td>
			</tr>
			<tr>
				<th align="center">내용</th>
				<td>
					<textarea rows="12" id="memo" name="memo" class="w100p" style="overflow:auto"></textarea>
				</td>
			</tr>
			<tr class="hide">
				<td colspan="4" height="50px">
				</td>
			</tr>

		</table>
				</div>
	        </form>
	        <div class="popup_button outer">
	            <ul>
	                <li>
						<a href="javascript:change();" 	class="gray large">저장</a>
	                    <a href="javascript:p.self.close();" class="gray large">닫기</a>
	                </li>
	            </ul>
	        </div>
        </div>
    </div>
</body>
</html>