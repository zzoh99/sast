<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html><html><head><title>사내공모관리 팝업</title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ajax.jsp"%>
<style type="text/css">
</style>
<script type="text/javascript">

var gPRow = "";
var pGubun = "";

$(function(){

	const modal =  window.top.document.LayerModalUtility.getModal('pubcMgrLayer');
	
	var pubcDivCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1026"), " ");	//공모구분
	var pubcStatCd 		= convCode( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","CD1027"), " ");	//공모상태

	$("#pubcDivCd").html(pubcDivCd[2]);
	$("#pubcStatCd").html(pubcStatCd[2]);

	$("#applStaYmd").datepicker2({startdate:"applEndYmd"});
	$("#applEndYmd").datepicker2({enddate:"applStaYmd"});
	
	let pubcId         = modal.parameters.pubcId || '';
	let pubcNm         = modal.parameters.pubcNm || '';
	let applStaYmd     = modal.parameters.applStaYmd || '';
	let applEndYmd     = modal.parameters.applEndYmd || '';
	let pubcContent    = modal.parameters.pubcContent || '';
	let note           = modal.parameters.note || '';
	let jobCd          = modal.parameters.jobCd || '';
	let jobNm          = modal.parameters.jobNm || '';
	let fileSeq		   = modal.parameters.fileSeq || '';
	let sStatus = modal.parameters.sStatus || '';

	let pubcOrgCd = modal.parameters.pubcOrgCd || '';
	let pubcOrgNm = modal.parameters.pubcOrgNm || '';
	let pubcChiefSabun = modal.parameters.pubcChiefSabun || '';
	let pubcChiefName = modal.parameters.pubcChiefName || '';

	pubcDivCd      = modal.parameters.pubcDivCd || '';
	pubcStatCd     = modal.parameters.pubcStatCd || '';

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
	$("#pubcOrgCd").val(pubcOrgCd) ;
	$("#pubcOrgNm").val(pubcOrgNm) ;
	$("#pubcChiefSabun").val(pubcChiefSabun) ;
	$("#pubcChiefName").val(pubcChiefName) ;
	
	$("#fileSeq").val(fileSeq);
	initFileUploadIframe("pubcMgrLayerUploadForm", fileSeq, "", "${authPg}");
	
	//최초 입력일 경우 강사버튼 제어
/*	if(sStatus == "I"){
		$(".btn").hide();
	} else {
		$(".btn").show();
	}*/
});

function pubcMgrLayerSetValue() {
	
	$("#srchFrm>#fileSeq").val(getFileUploadContentWindow("pubcMgrLayerUploadForm").getFileSeq());
	/*
	  if(supSheet.RowCount()==0){
		$("#srchFrm>#fileSeq").val("");
	}*/

	let p = {
		pubcId : $("#pubcId").val(),
		pubcNm : $("#pubcNm").val(),
		pubcDivCd : $("#pubcDivCd").val(),
		pubcStatCd : $("#pubcStatCd").val(),
		applStaYmd : $("#applStaYmd").val(),
		applEndYmd : $("#applEndYmd").val(),
		pubcContent : $("#pubcContent").val(),
		note : $("#note").val(),
		jobCd : $("#jobCd").val(),
		fileSeq : $("#fileSeq").val(),
		pubcOrgCd : $("#pubcOrgCd").val(),
		pubcOrgNm : $("#pubcOrgNm").val(),
		pubcChiefSabun : $("#pubcChiefSabun").val(),
		pubcChiefName : $("#pubcChiefName").val()
	};

	const modal =  window.top.document.LayerModalUtility.getModal('pubcMgrLayer');

	modal.fire('pubcMgrLayerTrigger', p).hide();
}

//  소속 팝업
function orgSearchPopup(){
	try{
		if(!isPopup()) {return;}
		gPRow = "";
		pGubun = "orgBasicPopup";

		let layerModal = new window.top.document.LayerModal({
			id : 'orgLayer'
			, url : '/Popup.do?cmd=viewOrgBasicLayer&authPg=${authPg}'
			, parameters : {}
			, width : 740
			, height : 520
			, title : '<tit:txt mid='orgSchList' mdef='조직 리스트 조회'/>'
			, trigger :[
				{
					name : 'orgTrigger'
					, callback : function(result){
						if(!result.length) return;
						$("#pubcOrgNm").val(result[0].orgNm);
						$("#pubcOrgCd").val(result[0].orgCd);
						$("#pubcChiefSabun").val(result[0].chiefSabun);
						$("#pubcChiefName").val(result[0].chiefName);
					}
				}
			]
		});
		layerModal.show();
	}catch(ex){alert("Open Popup Event Error : " + ex);}
}

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
						$("#pubcChiefName").val(result["name"]);
						$("#pubcChiefSabun").val(result["sabun"]);
					}
				}
			]
		});
		layerModal.show();
	}catch(ex){alert("Open Popup Event Error : " + ex);}
}

//팝업 클릭시 발생
function jobPopup() {
	if(!isPopup()) {return;}
	var args    = new Array();
	
	pGubun = "viewJobPopup";
	// openPopup("/Popup.do?cmd=jobPopup&authPg={authPg}", args, "740","720");

	var layer = new window.top.document.LayerModal({
		id : 'jobPopupLayer'
		, url : "${ctx}/Popup.do?cmd=jobPopup&authPg=${authPg}"
		, parameters: args
		, width : 740
		, height : 720
		, title : "직무 리스트 조회"
		, trigger :[
			{
				name : 'jobPopupTrigger'
				, callback : function(rv){
					getReturnValue(rv);
				}
			}
		]
	});
	layer.show();
}

//팝업 콜백 함수.
function getReturnValue(rv) {
    if(pGubun == "viewJobPopup"){
    	$("#jobCd").val(rv.jobCd);
    	$("#jobNm").val(rv.jobNm);
    }
}
</script>
</head>
<body>
	<div class="wrapper modal_layer">
		<div class="modal_body">
			<form id="srchFrm" name="srchFrm" method="post">
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
						<th>공모부서</th>
						<td>
							<input id="pubcOrgCd" name="pubcOrgCd" type="hidden" class="text w50"/>
							<input id="pubcOrgNm" name="pubcOrgNm" type="text" class="text w70p w-half" readonly/>
							<a href="javascript:orgSearchPopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
						</td>

						<th>부서장</th>
						<td>
							<input id="pubcChiefSabun" name="pubcChiefSabun" type="hidden" class="text w50"/>
							<input id="pubcChiefName" name="pubcChiefName" type="text" class="text w70p w-half" readonly/>
							<a href="javascript:employeePopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
						</td>
						<th>공모직무</th>
						<td>
							<input id="jobCd" name="jobCd" type="hidden" class="text w50"/>
							<input id="jobNm" name="jobNm" type="text" class="text w70p w-half" readonly/>
							<a href="javascript:jobPopup();" class="button6"><img src="/common/images/common/btn_search2.gif"/></a>
						</td>
					</tr>
					<tr>
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

			<iframe id="pubcMgrLayerUploadForm" name="pubcMgrLayerUploadForm" frameborder="0" class="author_iframe" style="height:200px;"></iframe>
		</div>

		<div class="modal_footer">
			<c:if test="${authPg == 'A'}">
			<btn:a href="javascript:pubcMgrLayerSetValue();" css="btn filled" mid='ok' mdef="확인"/>
			</c:if>
			<btn:a href="javascript:closeCommonLayer('pubcMgrLayer');" css="btn outline_gray" mid='close' mdef="닫기"/>
		</div>
	</div>
</body>
</html>
