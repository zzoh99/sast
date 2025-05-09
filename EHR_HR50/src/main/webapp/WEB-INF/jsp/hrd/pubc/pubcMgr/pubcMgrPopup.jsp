<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head><title>사내공모관리 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">

var p = eval("${popUpStatus}");
var gPRow = "";
var pGubun = "";

$(function(){

	//Cancel 버튼 처리
	$(".close").click(function(){
		p.self.close();
	});
	
	var pubcDivCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1026"), " ");	//공모구분
	var pubcStatCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1027"), " ");	//공모상태

	$("#pubcDivCd").html(pubcDivCd[2]);
	$("#pubcStatCd").html(pubcStatCd[2]);

	$("#applStaYmd").datepicker2({startdate:"applEndYmd"});
	$("#applEndYmd").datepicker2({enddate:"applStaYmd"});
	
	var arg = p.popDialogArgumentAll();
	var pubcId         = arg["pubcId"]        ;
	var pubcNm         = arg["pubcNm"]        ;
	var pubcDivCd      = arg["pubcDivCd"]     ;
	var pubcStatCd     = arg["pubcStatCd"]    ;
	var applStaYmd     = arg["applStaYmd"]    ;
	var applEndYmd     = arg["applEndYmd"]    ;
	var pubcContent    = arg["pubcContent"]   ;
	var note           = arg["note"]          ;
	var jobCd          = arg["jobCd"]         ;
	var jobNm          = arg["jobNm"]         ;

	$("#pubcId").val(pubcId        			) ;
	$("#pubcNm").val(pubcNm        			) ;
	$("#pubcDivCd").val(pubcDivCd   	   	) ;
	$("#pubcStatCd").val(pubcStatCd         ) ;
	$("#applStaYmd").val(applStaYmd        	) ;
	$("#applEndYmd").val(applEndYmd        	) ;
	$("#pubcContent").val(pubcContent       ) ;
	$("#note").val(note      				) ;
	$("#jobCd").val(jobCd      				) ;
	$("#jobNm").val(jobNm      				) ;
	
	$("#fileSeq").val( arg["fileSeq"] );
	upLoadInit($("#fileSeq").val(),"");
	
	//최초 입력일 경우 강사버튼 제어
	if(arg["sStatus"] == "I"){
		$(".btn").hide();
	} else {
		$(".btn").show();
	}
});

function setValue() {
	
	$("#srchFrm>#fileSeq").val($("#uploadForm>#fileSeq").val());
	/*
	  if(supSheet.RowCount()==0){
		$("#srchFrm>#fileSeq").val("");
	}*/
	
	var rv = new Array();
	rv["pubcId"]        = $("#pubcId").val() ;
	rv["pubcNm"]        = $("#pubcNm").val() ;
	rv["pubcDivCd"]     = $("#pubcDivCd").val() ;
	rv["pubcStatCd"]    = $("#pubcStatCd").val() ;
	rv["applStaYmd"]    = $("#applStaYmd").val() ;
	rv["applEndYmd"]    = $("#applEndYmd").val() ;
	rv["pubcContent"]   = $("#pubcContent").val() ;
	rv["note"]      	= $("#note").val() ;
	rv["jobCd"]      	= $("#jobCd").val() ;
	rv["fileSeq"]      	= $("#fileSeq").val() ;

	p.popReturnValue(rv);
	p.window.close();
}

//팝업 클릭시 발생
function jobPopup() {
	if(!isPopup()) {return;}
	var args    = new Array();
	
	pGubun = "viewJobPopup";
	openPopup("/Popup.do?cmd=jobPopup&authPg={authPg}", args, "740","720");
}

//팝업 콜백 함수.
function getReturnValue(returnValue) {
	var rv = $.parseJSON('{' + returnValue+ '}');

    if(pGubun == "viewJobPopup"){
    	$("#jobCd").val(rv["jobCd"]);
    	$("#jobNm").val(rv["jobNm"]);
    }
}

</script>
</head>
<body>
	<div class="wrapper popup_scroll">
		<div class="popup_title">
			<ul>
				<li>사내공모관리 세부내역</li>
				<li class="close"></li>
			</ul>
		</div>
	
		
		<div class="popup_main">
			<form id="srchFrm" name="srchFrm" method="post">
				<input type="hidden" id="pubcId" name="pubcId"/>
				<input type="hidden" id="fileSeq" name="fileSeq" />
				<table class="table">
					<colgroup>
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="20%" />
						<col width="13%" />
						<col width="*" />
					</colgroup>
					<tr>
						<th>공모명</th>
						<td>
							<input id="pubcId" name="pubcId" type="hidden" class="text" style="width:50%;"/>
							<input id="pubcNm" name="pubcNm" type="text" class="text" style="width:99%;"/>
						</td>
						<th>공모구분</th>
						<td>
							<select id="pubcDivCd" name="pubcDivCd" class=""></select>
						</td>
						<th>공모상태</th>
						<td>
							<select id="pubcStatCd" name="pubcStatCd" class=""></select>
						</td>
					</tr>
					<tr>
						<th>공모직무</th>
						<td>
							<input id="jobCd" name="jobCd" type="hidden" class="text w50"/>
							<input id="jobNm" name="jobNm" type="text" class="text w70p" readonly/>
							<a href="javascript:jobPopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
						</td>
						<th>시작일</th>
						<td>
							<input id="applStaYmd" name="applStaYmd" type="text" class="date2 w70p ${readonly}" ${readonly} vtxt="시작일"/>
						</td>
						<th>종료일</th>
						<td>
							<input id="applEndYmd" name="applEndYmd" type="text" class="date2 w70p ${readonly}" ${readonly} vtxt="종료일"/>
						</td>
					</tr>
					<tr>
						<th>공모내용</th>
						<td colspan="5">
							<textarea id="pubcContent" name="pubcContent" rows="3" class="w100p"></textarea>
						</td>
					</tr>
					<tr>
						<th>비고</th>
						<td colspan="5">
							<input id="note" name="note" type="text" class="text" style="width:99%;"/>
						</td>
					</tr>
				</table>
			</form>
			
			<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>
			<div class="popup_button">
				<ul>
					<li>
						<btn:a href="javascript:setValue();" css="pink large authA" mid='ok' mdef="확인"/>
						<btn:a href="javascript:p.self.close();" css="gray large authR" mid='close' mdef="닫기"/>
					</li>
				</ul>
			</div>
		</div>
	</div>
</body>
</html>
