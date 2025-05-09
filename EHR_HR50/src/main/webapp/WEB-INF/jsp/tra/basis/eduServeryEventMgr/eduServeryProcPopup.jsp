<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"><head> <title><tit:txt mid='114098' mdef='승진기준관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<script type="text/javascript">
	var p = eval("${popUpStatus}");
	$(function() {

		$(".close, #close").click(function() {
			p.self.close();
		});

		$("#prcCall").click(function() {

			if(!confirm("기존데이터를 삭제하고 원본 데이터로 생성 됩니다. \n 계속하시겠습니까?")) {
				return;
			}

			var data = ajaxCall("/EduServeryEventMgr.do?cmd=prcEduServery",$("#mySheetForm").serialize(),false);
	    	if(data.Result.Code == null) {
	    		alert("<msg:txt mid='110120' mdef='처리되었습니다.'/>");
	    		p.self.close();
	    	} else {
		    	alert(data.Result.Message);
	    	}

		});

	});

	var showDetailPopupPrev = function () {
		var rst = showDetailPopupProc();
		if(rst != null){
			//팝업 더블클릭시 조회해온것 input 에 셋팅
			$("#searchEduEventSeq").val(rst["eduEventSeq"]);
			$("#searchEduEventNm").val(rst["eduEventNm"]);
		}
	};

	var showDetailPopupNext = function () {
		var rst = showDetailPopupProc();
		if(rst != null){
			//팝업 더블클릭시 조회해온것 input 에 셋팅
			$("#searchPNEduEventCd").val(rst["eduEventSeq"]);
			$("#searchPNEduEventNm").val(rst["eduEventNm"]);
		}
	};

	var showDetailPopupProc = function () {

		var url = "/View.do?cmd=viewEduEventMgrPopup2";
		var args	= new Array(2);

		var rst = openPopup(url,args,700,700);

		return rst;
	};

</script>
</head>
<body class="bodywrap">
<div class="wrapper">
	<div class="popup_title">
	<ul>
		<li>설문항목복사</li>
		<li class="close"></li>
	</ul>
	</div>

	<div class="popup_main">
		<form id="mySheetForm" name="mySheetForm" >
		<div class="sheet_search outer">
			<div>
			<table>
			<tr>
				<th><tit:txt mid='113608' mdef='원본'/></th>
				<td>
					<input id="searchEduEventSeq" name="searchEduEventSeq" type="hidden" class="text w100" />
					<input id="searchEduEventNm" name="searchEventNm" type="text" class="text w100" readonly="readonly"/>
					<a onclick="javascript:showDetailPopupPrev();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
				<td>

				</td>
				<th><tit:txt mid='112875' mdef='대상'/></th>
				<td>
					<input id="searchPNEduEventCd" name="searchPNEduEventCd" type="hidden" class="text w100" />
					<input id="searchPNEduEventNm" name="searchPNEduEventNm" type="text" class="text w100" readonly="readonly"/>
					<a onclick="javascript:showDetailPopupNext();return false;" class="button6"><img src="/common/${theme}/images/btn_search2.gif"/></a>
				</td>
			</tr>
			</table>
			</div>
		</div>
		</form>

		<div class="popup_button outer">
		<ul>
			<li>
				<a id="prcCall" class="pink large"><tit:txt mid='104335' mdef='복사'/></a>
				<a id="close" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
			</li>
		</ul>
		</div>
	</div>
</div>
</body>
</html>
