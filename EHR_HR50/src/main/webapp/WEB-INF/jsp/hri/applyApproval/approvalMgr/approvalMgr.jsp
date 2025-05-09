<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='103897' mdef='신청결재 관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<% request.setAttribute("uploadType", "appl"); %>

<script type="text/javascript">
//20220527. 부서명 등에 ,@등의 특수문자가 포함된 경우 문자열 split이 정상 동작하지 않음. 구분자의 복잡도를 올려서 해결함.
//var deli		= ",";
//var deli2		= "@";
var deli		= ",,,,,";
var deli2		= "@@@@@";

var authorLeft	= "";
	authorLeft	+="<td><table class='#clsNm#'>";
	authorLeft	+="<tr><th id='hTypeCdNm'>	#typeCdNm#</th></tr>";
	authorLeft	+="<tr><td id='hOrgNm' 		class='name'>#orgNm#</td></tr>";
	authorLeft	+="<tr><td id='hJikchakNm'	class='hide'>#jikchakNm#</td></tr>";
	authorLeft	+="<tr><td id='hJikweeNm' 	class='status'>#jikweeNm#</td></tr>";
	authorLeft	+="<tr><td id='hName'		class='status' alt='#sabun#' title='#title#'>#name#</td></tr>";
	authorLeft	+="<tr><td id='hSabun' 		class='hide'>#sabun#</td></tr>";
	authorLeft	+="<tr><td id='hJikweeCd' 	class='hide'>#jikweeCd#</td></tr>";
	authorLeft	+="<tr><td id='hJikchakCd' 	class='hide'>#jikchakCd#</td></tr>";
	authorLeft	+="<tr><td id='hOrgCd' 		class='hide'>#orgCd#</td></tr>";
	authorLeft	+="<tr><td id='hTypeCd' 	class='hide'>#typeCd#</td></tr>";
	authorLeft	+="<tr><td id='hAgreeSeq' 	class='hide'>#agreeSeq#</td></tr>";
	authorLeft	+="<tr><td id='hAgreeSabun' class='hide'>#agreeSabun#</td></tr>";
	authorLeft	+="<tr><td id='hEmpEtc' 	class='hide'>#name#</td></tr>";
	authorLeft	+="<tr><td id='orgAppYn' 	class='hide'>#orgAppYn#</td></tr>";
	//authorLeft += "<tr><td id='sign'><img src=#signPath# height='30'></td></tr>";
	authorLeft	+="</table></td>";

var authorDeputyLeft	= "";
	authorDeputyLeft	+="<td style='display:none;'><table class='#clsNm#'>";
	authorDeputyLeft	+="<tr><th id='hTypeCdNm'>	#typeCdNm#</th></tr>";
	authorDeputyLeft	+="<tr><td id='hOrgNm' 		class='name'>#orgNm#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hJikchakNm'	class='hide'>#jikchakNm#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hJikweeNm' 	class='status'>#jikweeNm#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hName'		class='status' alt='#sabun#' title='#title#'>#name#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hSabun' 		class='hide'>#sabun#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hJikweeCd' 	class='hide'>#jikweeCd#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hJikchakCd' 	class='hide'>#jikchakCd#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hOrgCd' 		class='hide'>#orgCd#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hTypeCd' 	class='hide'>#typeCd#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hAgreeSeq' 	class='hide'>#agreeSeq#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hAgreeSabun' class='hide'>#agreeSabun#</td></tr>";
	authorDeputyLeft	+="<tr><td id='hEmpEtc'	class='hide'>#name#</td></tr>";
	authorDeputyLeft	+="<tr><td id='orgAppYn' 	class='hide'>#orgAppYn#</td></tr>";
	//authorDeputyLeft 	+="<tr><td id='sign'><img src=#signPath# height='60'></td></tr>";
	authorDeputyLeft	+="</table></td>";

var emptyLeft 	="<td><div class='arrow'>&nbsp;</div></td>";
var applSeq 	= "";
var applList 	= null;
var inApplList		= null;
var referList 	= null;
var iframeLoad 	= false;
var applMasterInfo 	= false;
var nUser		= false;
var _detExist = false;
var execLvlCode = true;

var p = eval("${popUpStatus}");
	$(function() {
		var fileSeq2 = "";
		//화면 기본 설정
		if("${uiInfo.printYn}" == "Y") $(".print").show();
		if("${uiInfo.appPathYn}" == "Y") $("#btnAppPath").show();
		if("${uiInfo.orgLevelYn}" == "Y") $("#lvlCode").show();
		if("${uiInfo.fileYn}" == "Y") $("#uploadDiv").show();

		//2020.05.29 결재선변경이 없을 시 
		if("${uiInfo.appPathYn}" != "Y" && "${uiInfo.orgLevelYn}" != "Y" ) {$("#applLineTitle").hide();$("#applLineTitle_blank").show();}
		
		//결재처리여부, 수신처리여부가 N이면 결재라인 숨김  2020.10.26
		if("${uiInfo.agreeYn}" == "N" && "${uiInfo.recevYn}" == "N"){
			$("#author_info").hide();
		}
		
		if("${uiInfo.etcNoteYn}" == "Y") {

			$("#etcCommentDiv").show();

			if("${uiInfo.etcNoteFileCnt}" > 0) {
				$("#etcNoteFileSeq").val("${uiInfo.etcNoteFileSeq}");
				$("#etcNoteFile").show();
			}
		}

		$(".close").click(function() 	{ p.popReturnValue(); p.self.close(); });
		$(".print>a").click(function(e) { e.stopPropagation(); });
		
		// 결재선 변경 설정
		$("#lvlCode").change(function(){
			if( execLvlCode ) {
				$.ajax({
					url      : "${ctx}/ApprovalMgr.do?cmd=getApprovalMgrApplChgList",
					type     : "post",
					dataType : "json",
					async    : false,
					data     : $("#authorForm").serialize(),
					success  : function(rv) {
						applList = rv.DATA;
						chgApplList(applList);
					},
					error : function(jqXHR, ajaxSettings, thrownError) {
						ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
					}
				});
				$.ajax({
					url      : "${ctx}/ApprovalMgr.do?cmd=getApprovalMgrReferUserChgList",
					type     : "post",
					dataType : "json",
					async    : false,
					data     : $("#authorForm").serialize(),
					success  : function(rv) {
						referList = rv.DATA;
						chgReferList(referList);
					},
					error : function(jqXHR, ajaxSettings, thrownError) {
						ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
					}
				});
				
			}
			execLvlCode = true;
		});
		
		var fileSeq = "";

		//신청서타이틀
		$("#applTitle").val("${uiInfo.applTitle}"); //무조건 thri101에서 가져오게 변경(다국어땜에)
		$("#span_applTitle").html("${uiInfo.applTitle}");

		$.ajax({
			url      : "${ctx}/ApprovalMgr.do?cmd=getApprovalMgrLevelCodeList",
			type     : "post",
			dataType : "json",
			async    : false,
			data     : $("#authorForm").serialize(),
			success  : function(rv) {
				var lvlCodeList	= convCodeIdx( rv.DATA,"",-1);
				//chgLvlList(lvlCodeList);
				$("#lvlCode").html( lvlCodeList[2] );// 결재선 레벨 정보 셋팅
				$("#lvlCode").val("${orgLvl.orgLvl}");	// 결재선 지정
			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});
		
		//applSeq가 있는경우와 없는 경우
		if("${applSeqExist}"  == "N"){
			$("#applTitle").val("${uiInfo.applTitle}");
			$("#span_applTitle").html("${uiInfo.applTitle}");

			$.ajax({
				url      : "${ctx}/ApprovalMgr.do?cmd=getApprovalMgrApplChgList",
				type     : "post",
				dataType : "json",
				async    : false,
				data     : "searchApplSabun=${searchApplSabun}&lvlCode=${orgLvl.orgLvl}",
				success  : function(rv) {
					applList = rv.DATA;
					chgApplList(applList);
					$(".author_left").css("background-color", "#e3f0f6");
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});

			$.ajax({
				url      : "${ctx}/ApprovalMgr.do?cmd=getApprovalMgrReferUserChgList",
				type     : "post",
				dataType : "json",
				async    : false,
				data     : $("#authorForm").serialize(),
				success  : function(rv) {
					referList = rv.DATA;
					chgReferList(referList);
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});
			
			$.ajax({
				url      : "${ctx}/ApprovalMgr.do?cmd=getApprovalMgrInList",
				type     : "post",
				dataType : "json",
				async    : false,
				data     : $("#authorForm").serialize(),
				success  : function(rv) {
					inApplList = rv.DATA;
					chgInList(rv.DATA);
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});

			$("#applStatusCd").val("");
		}else{
			$.ajax({
				url      : "${ctx}/ApprovalMgr.do?cmd=getApprovalMgrTHRI103",
				type     : "post",
				dataType : "json",
				async    : false,
				data     : $("#authorForm").serialize(),
				success  : function(rv) {
					applMasterInfo = rv.DATA;
					fileSeq = applMasterInfo.fileSeq;
					$("#applTitle").val(applMasterInfo.title);
					$("#span_applTitle").html(applMasterInfo.title);
					$("#applStatusCd").val(applMasterInfo.applStatusCd);
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});
			$.ajax({
				url      : "${ctx}/ApprovalMgr.do?cmd=getApprovalMgrTHRI107",
				type     : "post",
				dataType : "json",
				async    : false,
				data     : $("#authorForm").serialize(),
				success  : function(rv) {
					applList = rv.DATA;
					if( applList && applList != null && applList.length > 0 ) {
						execLvlCode = false;
					}
					$("#lvlCode").val(applList[0].pathSeq);
					chgApplSaveList(applList);
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});
			$.ajax({
				url      : "${ctx}/ApprovalMgr.do?cmd=getApprovalMgrTHRI125",
				type     : "post",
				dataType : "json",
				async    : false,
				data     : $("#authorForm").serialize(),
				success  : function(rv) {
					referList = rv.DATA;
					chgReferSaveList(referList);
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});

			/* 임시저장을 다시열었을 때 화면을 위하여 중복코드 세팅 */
			if("${uiInfo.agreeYn}" == "N") {
				/* 결재처리여부가 N이면 0단계(본인)결재선만 박고 화면에 안보이게 처리하고 멈춤  by JSG 2013.10.08 In JejuAir */
				$("#lvlCode").val("0"); /*결재선 0으로*/
				$("#atleft").addClass("hide");
				$("#applLineTitle").addClass("hide");
				if("${uiInfo.recevYn}" == "Y") {
					$("#applSpaceLine").removeClass("hide");
				}
			}
		}
		
		if($.trim( $("#atleft").html() ) =="" ){
			nUser = true;
			nullUser();
		}

		iframeCal();
		//파일 초기화
		upLoadInit(fileSeq,"");

		if(fileSeq2 != null && fileSeq2 != ""){
			upLoadInit2(fileSeq2,"");
		}

		$('#authorFrame').on("load", function() {
			setIframeHeight(this.id);
		});


	});

	function iframeCal() {
		var detailPrgCd = "${uiInfo.detailPrgCd}";
		if(detailPrgCd != "") {
			_detExist = true;
		}

		if(_detExist) {
			//해당 신청코드에 세부프로그램Code가 있는 경우
			//업무 화면 로딩
			submitCall($("#authorForm"),"authorFrame","post","${ctx}"+ detailPrgCd);
		}else {
			//해당 신청코드에 세부프로그램Code가 없는 경우
			iframeOnLoad("0px");
		}
	}



	//----------------------------------------------------------/
	function setIframeHeight(id) {

		var ifrm = document.getElementById(id);

		var doc = ifrm.contentDocument? ifrm.contentDocument: ifrm.contentWindow.document;
		ifrm.style.visibility = 'hidden';
		//ifrm.style.height = "10px"; // reset to minimal height ...
		// IE opt. for bing/msn needs a bit added or scrollbar appears
		//높이 측정방식 변경. hyungyu@ildong.
		//ifrm.style.height = getDocHeight( doc ) + 20 + "px";
		ifrm.style.height = $("#"+id).contents().height() + "px";//getDocHeight( doc ) + 20 + "px";

		ifrm.style.visibility = 'visible';
	}

	function getDocHeight(doc) {
		doc = doc || document;
		// stackoverflow.com/questions/1145850/
		var body = doc.body, html = doc.documentElement;
		var height = Math.max( body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight );
		return height;
	}

	//----------------------------------------------------------/



	function chgUser(userInfo){
// 		$("#user").html(	"${userInfo.name}");
// 	    $("#orgNm").html(	"${userInfo.orgNm}");
// 	    $("#jikwee").html(	"${userInfo.jikweeNm}");
// 	    $("#telPhone").html("${userInfo.officeTel}");
	}

	function chgReferList(referUserList){
		var referUser 	= "";
		var referUserEtc= "";
		var jikchakTmp 	= "";
		var jikweeTmp 	= "";

		for(var i=0; i<referUserList.length; i++){
			referUser 	+= referUserList[i].orgNm+" "+referUserList[i].ccName+"("+referUserList[i].ccSabun+") / ";
			referUserEtc+= referUserList[i].orgNm+","+referUserList[i].orgCd+","+referUserList[i].ccName+","+referUserList[i].ccSabun+",";

			if(referUserList[i].jikweeCd == "") jikweeTmp = " "; else jikweeTmp = referUserList[i].jikweeCd;
			referUserEtc+= jikweeTmp+",";
			if(referUserList[i].jikweeNm == "") jikweeTmp = " "; else jikweeTmp = referUserList[i].jikweeNm;
			referUserEtc+= jikweeTmp+",";

			if(referUserList[i].jikchakCd == "") jikchakTmp = " "; else jikchakTmp = referUserList[i].jikchakCd;
			referUserEtc+= jikchakTmp+",";
			if(referUserList[i].jikchakNm == "") jikchakTmp = " "; else jikchakTmp = referUserList[i].jikchakNm;
			referUserEtc+= jikchakTmp+deli2;
		}
		if( referUserList.length > 0){
			referUser 		= referUser.substring(0, 	referUser.length-2);
			referUserEtc 	= referUserEtc.substring(0, referUserEtc.length-1);
		}

		$("#referUser").html(referUser);
		$("#referUserEtc").html(referUserEtc);
	}
	function chgReferSaveList(referUserList){
		var referUser 	= "";
		var referUserEtc= "";
		var jikchakTmp 	= "";
		var jikweeTmp 	= "";

		for(var i=0; i<referUserList.length; i++){
			referUser 	+= referUserList[i].ccOrgNm+" "+referUserList[i].ccName+"("+referUserList[i].ccSabun+") / ";
			referUserEtc+= referUserList[i].ccOrgNm+","+" "+","+referUserList[i].ccName+","+referUserList[i].ccSabun+",";
			referUserEtc+= " "+",";
			if(referUserList[i].ccJikweeNm == "") jikweeTmp = " "; else jikweeTmp = referUserList[i].ccJikweeNm;
			referUserEtc+= " "+", ,";
			if(referUserList[i].ccJikchakNm == "") jikchakTmp = " "; else jikchakTmp = referUserList[i].ccJikchakNm;
			referUserEtc+= jikchakTmp+",";

			referUserEtc+= referUserList[i].ccEmpAlias+",@";
		}

		referUser 		= referUser.substring(0, 	referUser.length-2);
		referUserEtc 	= referUserEtc.substring(0, referUserEtc.length-1);

		$("#referUser").html(referUser);
		$("#referUserEtc").html(referUserEtc);
	}
	function chgApplList(applList){
		var tempLeft="";

		for(var i=0; i<applList.length; i++){
			tempLeft+=authorLeft
				.replace(/#clsNm#/g,	"author")
				.replace(/#typeCdNm#/g,	applList[i].applTypeCdNm)
				.replace(/#orgNm#/g,	applList[i].agreeOrgNm)
				.replace(/#jikchakNm#/g,applList[i].agreeJikchakNm)
				.replace(/#sabun#/g,	applList[i].agreeSabun)
				.replace(/#title#/g,	applList[i].agreeSabun)
				.replace(/#empAlias#/g,	applList[i].agreeEmpAlias)
				.replace(/#name#/g,		applList[i].agreeName)
				.replace(/#date#/g,"")
				.replace(/#jikweeNm#/g,	applList[i].agreeJikweeNm)
				.replace(/#jikweeCd#/g,	applList[i].agreeJikweeCd)
				.replace(/#jikchakCd#/g,applList[i].agreeJikchakCd)
				.replace(/#orgCd#/g,	applList[i].agreeOrgCd)
				.replace(/#typeCd#/g,	applList[i].applTypeCd)
				.replace(/#agreeSeq#/g,	applList[i].agreeSeq)
				.replace(/#signPath#/g,		"${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun)
			;
			if(applList[i].deputySabun !=""){
				tempLeft+=authorDeputyLeft
					.replace(/#clsNm#/g,	"author instead")
					.replace(/#typeCdNm#/g,		applList[i].applTypeCdNm)
					.replace(/#orgNm#/g,		applList[i].deputyOrgNm)
					.replace(/#jikchakNm#/g,	applList[i].deputyJikchakNm)
					.replace(/#sabun#/g,		applList[i].deputySabun)
					.replace(/#title#/g,		applList[i].deputySabun)
					.replace(/#empAlias#/g,	    applList[i].deputyEmpAlias)
					.replace(/#name#/g,			applList[i].deputyName)
					.replace(/#date#/g,"")
					.replace(/#jikweeNm#/g,		applList[i].deputyJikweeNm)
					.replace(/#jikweeCd#/g,		applList[i].deputyJikweeCd)
					.replace(/#jikchakCd#/g,	applList[i].deputyJikchakCd)
					.replace(/#orgCd#/g,		applList[i].deputyaOrgCd)
					.replace(/#typeCd#/g,		applList[i].applTypeCd)
					.replace(/#agreeSabun#/g,	applList[i].agreeSabun)
				;
			}
			if(i != applList.length-1) tempLeft+=emptyLeft;
			if("${uiInfo.agreeYn}" == "N") {
				
				/* 결재처리여부가 N이면 0단계(본인)결재선만 박고 화면에 안보이게 처리하고 멈춤  by JSG 2013.10.08 In JejuAir */
				$("#lvlCode").val("0"); /*결재선 0으로*/
				//$("#atleft").addClass("hide");  //결재처리여부가 N이어도 기안자는 나오도록 수정( 결재안하고 수신결재만 한경우 기안자가 나와야함 ) 2020.08.10
				$("#applLineTitle").addClass("hide");
				if("${uiInfo.recevYn}" == "Y") {
					$("#applSpaceLine").removeClass("hide");
				}
				$("#atleft").html(tempLeft);
				return ;
			}
			} $("#atleft").html(tempLeft);
	}
	function nullUser(){
		var tempLeft="";

		tempLeft+=authorLeft
			.replace(/#clsNm#/g,	"author")
			.replace(/#typeCdNm#/g,	"기안")
			.replace(/#orgNm#/g,	"${userInfo.orgNm}")
			.replace(/#jikchakNm#/g,"${userInfo.jikchakNm}")
			.replace(/#sabun#/g,	"${userInfo.sabun}")
			.replace(/#title#/g,	"${userInfo.sabun}")
			.replace(/#name#/g,		"${userInfo.name}")
			.replace(/#empAlias#/g,	"${userInfo.empAlias}")
			.replace(/#date#/g,"")
			.replace(/#jikweeNm#/g,	"${userInfo.jikweeNm}")
			.replace(/#jikweeCd#/g,	"${userInfo.jikweeCd}")
			.replace(/#jikchakCd#/g,"${userInfo.jikchakCd}")
			.replace(/#orgCd#/g,	"${userInfo.orgCd}")
			.replace(/#typeCd#/g,	"30")
			.replace(/#agreeSeq#/g,	"1")
		;
		$("#atleft").html(tempLeft);
	}
	function chgApplSaveList(applList){
		var tempLeft="";
		var tempRight="";
		for(var i=0; i<applList.length; i++){
			if( applList[i].gubun != "3") {
				tempLeft+=authorLeft
					.replace(/#clsNm#/g,	"author")
					.replace(/#typeCdNm#/g,	applList[i].applTypeCdNm)
					.replace(/#orgNm#/g,	applList[i].agreeOrgNm)
					.replace(/#jikchakNm#/g,applList[i].agreeJikchakNm)
					.replace(/#sabun#/g,	applList[i].agreeSabun)
					.replace(/#title#/g,	applList[i].agreeSabun)
					.replace(/#empAlias#/g,	applList[i].agreeEmpAlias)
					.replace(/#name#/g,		applList[i].agreeName)
					.replace(/#date#/g,"")
					.replace(/#jikweeNm#/g,	applList[i].agreeJikweeNm)
					.replace(/#typeCd#/g,	applList[i].applTypeCd)
					.replace(/#agreeSeq#/g,	applList[i].agreeSeq)
					.replace(/#signPath#/g,		"${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun)
				;
				if(applList[i].deputyYn =="Y"){
					tempLeft+=authorDeputyLeft
						.replace(/#clsNm#/g,	"author instead")
						.replace(/#typeCdNm#/g,		applList[i].applTypeCdNm)
						.replace(/#orgNm#/g,		applList[i].deputyOrgNm)
						.replace(/#jikchakNm#/g,	applList[i].deputyJikchakNm)
						.replace(/#sabun#/g,		applList[i].deputySabun)
						.replace(/#title#/g,		applList[i].deputySabun)
						.replace(/#name#/g,			applList[i].deputyName)
						.replace(/#empAlias#/g,		applList[i].deputyEmpAlias)
						.replace(/#date#/g,"")
						.replace(/#jikweeNm#/g,		applList[i].deputyJikweeNm)
						.replace(/#orgCd#/g,		applList[i].deputyaOrgCd)
						.replace(/#typeCd#/g,		applList[i].applTypeCd)
						.replace(/#agreeSabun#/g,	applList[i].agreeSabun)
					;
				}
				if( applList.length == i+1) continue;
				if( applList[i+1].gubun != "3") tempLeft+=emptyLeft;

			}else{
				tempRight+=authorLeft
					.replace(/#clsNm#/g,	"author")
					.replace(/#typeCdNm#/g,	applList[i].applTypeCdNm)
					.replace(/#orgNm#/g,	applList[i].agreeOrgNm)
					.replace(/#jikchakNm#/g,applList[i].agreeJikchakNm)
					.replace(/#sabun#/g,	applList[i].agreeSabun)
					.replace(/#title#/g,	applList[i].agreeSabun)
					.replace(/#name#/g,		applList[i].agreeName)
					.replace(/#empAlias#/g,	applList[i].agreeEmpAlias)
					.replace(/#date#/g,"")
					.replace(/#jikweeNm#/g,	applList[i].agreeJikweeNm)
					.replace(/#typeCd#/g,	applList[i].applTypeCd)
					.replace(/#agreeSeq#/g,	applList[i].agreeSeq)
					.replace(/#orgAppYn#/g,	applList[i].orgAppYn)
					.replace(/#signPath#/g,		"${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun)
				;
				if(applList[i].deputyYn =="Y"){
					tempRight+=authorDeputyLeft
						.replace(/#clsNm#/g,	"author instead")
						.replace(/#typeCdNm#/g,		applList[i].applTypeCdNm)
						.replace(/#orgNm#/g,		applList[i].deputyOrgNm)
						.replace(/#jikchakNm#/g,	applList[i].deputyJikchakNm)
						.replace(/#sabun#/g,		applList[i].deputySabun)
						.replace(/#title#/g,		applList[i].deputySabun)
						.replace(/#name#/g,			applList[i].deputyName)
						.replace(/#empAlias#/g,		applList[i].deputyEmpAlias)
						.replace(/#date#/g,"")
						.replace(/#jikweeNm#/g,		applList[i].deputyJikweeNm)
						.replace(/#orgCd#/g,		applList[i].deputyaOrgCd)
						.replace(/#typeCd#/g,		applList[i].applTypeCd)
						.replace(/#agreeSabun#/g,	applList[i].agreeSabun)
						.replace(/#orgAppYn#/g,		applList[i].orgAppYn)
					;

				}
				if(i != applList.length-1) tempRight+=emptyLeft;
			}
			}
		$("#atleft").html(tempLeft);
		$("#atright").html(tempRight);
	}

	function chgInList(inApplList){
		if("${uiInfo.recevYn}" == "N") { 
			return ; 
		}else{
			if ( inApplList.length == 0 ){
				$(".author_right").css("background-color", "white");
			}else{
				$(".author_right").css("background-color", "#fbf3f8");
			}
		}
		
		/* 수신결재여부가 N이면 수신결재자 세팅처리를 하지 않는다. by JSG 2013.10.08 In JejuAir */
		var tempRight		= "";

		var agreeSabun 		= "";
		for(var i=0; i<inApplList.length; i++){
			agreeSabun 	+= inApplList[i].sabun+",";
		}
		agreeSabun = agreeSabun.substring(0,agreeSabun.length-1);
		//var debutyUserList 	= ajaxCall("${ctx}/ApprovalMgr.do?cmd=getApprovalMgrDeputyUserChgList","agreeSabun="+agreeSabun ,false).DATA;

		for(var i=0; i<inApplList.length; i++){
			tempRight+=authorLeft
				.replace(/#clsNm#/g,	"author")
				.replace(/#typeCdNm#/g,	inApplList[i].applTypeCdNm)
				.replace(/#orgNm#/g,	inApplList[i].orgNm)
				.replace(/#jikweeNm#/g,	inApplList[i].jikweeNm)
				.replace(/#jikchakNm#/g,inApplList[i].jikchakNm)
				.replace(/#sabun#/g,	inApplList[i].sabun)
				.replace(/#title#/g,	inApplList[i].sabun)
				.replace(/#name#/g,		inApplList[i].name)
				.replace(/#empAlias#/g,	inApplList[i].empAlias)
				.replace(/#typeCd#/g,	inApplList[i].applTypeCd)
				.replace(/#orgAppYn#/g,	inApplList[i].orgAppYn)
				.replace(/#date#/g,"");
			;

			if(i != inApplList.length-1)
				tempRight+=emptyLeft;
		}
		$("#atright").html(tempRight);
	}

	function chgApplPopup(){
		if(!isPopup()) {return;}

		var args = {};
		args.orgCd = "${userInfo.orgCd}";

		//var url 	= "${ctx}/ApprovalMgrResult.do?cmd=viewApprovalMgrResultChgApplPopup";
		var url 	= "${ctx}/ApprovalMgr.do?cmd=viewApprovalMgrChgApplPopup";
		openPopup(url,args,1200,750);
	}

	function chApplPopupRetrunPrc(sheet4,sheet5,sheet6,debutyUserList,applCdList){
	//function chApplPopupRetrunPrc(sheet4,sheet5,debutyUserList,applCdList){
		var typeCdNm 	= "";
		var typeCd 		= "";
		var tempLeft	= "";
		var tempRight	= "";
		//결재순서역순처리 2022.03.14
		//for(var i=1; i<sheet4.LastRow()+1; i++){
		for(var i=sheet4.LastRow() ; i >= 1; i--){
			typeCd 	= sheet4.GetCellValue(i,"applTypeCd");
			typeCdNm 	= sheet4.GetCellText(i,"applTypeCd");

			tempLeft+=authorLeft
				.replace(/#clsNm#/g,"author")
				.replace(/#typeCdNm#/g,	typeCdNm)
				.replace(/#orgNm#/g,	sheet4.GetCellValue(i,"orgNm"))
				.replace(/#jikchakNm#/g,sheet4.GetCellValue(i,"jikchakNm"))
				.replace(/#sabun#/g,	sheet4.GetCellValue(i,"agreeSabun"))
				.replace(/#title#/g,	sheet4.GetCellValue(i,"agreeSabun"))
				.replace(/#name#/g,		sheet4.GetCellValue(i,"name"))
				.replace(/#empAlias#/g,	sheet4.GetCellValue(i,"empAlias"))
				.replace(/#date#/g,		"")
				.replace(/#jikweeNm#/g,	sheet4.GetCellValue(i,"jikweeNm"))
				.replace(/#jikweeCd#/g,	sheet4.GetCellValue(i,"jikweeCd"))
				.replace(/#jikchakCd#/g,sheet4.GetCellValue(i,"jikchakCd"))
				.replace(/#orgCd#/g,	sheet4.GetCellValue(i,"orgCd"))
				.replace(/#typeCd#/g,	typeCd)
				.replace(/#agreeSeq#/g,	sheet4.GetCellValue(i,"agreeSeq"))
			;
			//결재순서역순처리 2022.03.14
			if(i != 1) {tempLeft+=emptyLeft;}
		}

		$("#atleft").html(tempLeft);

		//결재순서역순처리 2022.03.14
 		//for(var i=1; i<sheet6.LastRow()+1; i++){
 		for(var i=sheet6.LastRow() ; i >= 1; i--){
			typeCd 	= sheet6.GetCellValue(i,"applTypeCd");
			typeCdNm 	= sheet6.GetCellText(i,"applTypeCd");
			var orgAppYn = 'N';
			if(sheet6.GetCellValue(i,"name") == "")	orgAppYn = 'Y';
			
			tempRight+=authorLeft
				.replace(/#clsNm#/g,"author")
				.replace(/#typeCdNm#/g,	typeCdNm)
				.replace(/#orgNm#/g,	sheet6.GetCellValue(i,"orgNm"))
				.replace(/#jikweeNm#/g,	sheet6.GetCellValue(i,"jikweeNm"))
				.replace(/#jikchakNm#/g,sheet6.GetCellValue(i,"jikchakNm"))
				.replace(/#sabun#/g,	sheet6.GetCellValue(i,"agreeSabun"))
				.replace(/#title#/g,	sheet6.GetCellValue(i,"agreeSabun"))
				.replace(/#name#/g,		sheet6.GetCellValue(i,"name"))
				.replace(/#empAlias#/g,	sheet6.GetCellValue(i,"empAlias"))
				.replace(/#jikweeCd#/g,	sheet6.GetCellValue(i,"jikweeCd"))
				.replace(/#jikchakCd#/g,sheet6.GetCellValue(i,"jikchakCd"))
				.replace(/#orgCd#/g,	sheet6.GetCellValue(i,"orgCd"))
				.replace(/#typeCd#/g,	typeCd)
				.replace(/#date#/g,		"")
				.replace(/#orgAppYn#/g,		orgAppYn)
			;
			//결재순서역순처리 2022.03.14
			if(i != 1) {tempRight+=emptyLeft;}
		}

		$("#atright").html(tempRight);
		
		var referUser 	= "";
		var referUserEtc= "";
		var jikchakTmp = "";
		var jikweeTmp = "";

		for(var i=1; i<sheet5.LastRow()+1; i++){
			referUser 	+= sheet5.GetCellValue(i,"orgNm");
			referUser 	+= " "+sheet5.GetCellValue(i,"name");
			referUser 	+= "("+sheet5.GetCellValue(i,"ccSabun")+") / ";// 2016.12.15 참조사번 보이지 않도록 처리

			referUserEtc+= sheet5.GetCellValue(i,"orgNm")+deli;
			referUserEtc+= sheet5.GetCellValue(i,"orgCd")+deli;
			referUserEtc+= sheet5.GetCellValue(i,"name")+deli;
			referUserEtc+= sheet5.GetCellValue(i,"ccSabun")+deli;
			//referUserEtc+= sheet5.GetCellValue(i,"jikweeCd")+deli;
			//referUserEtc+= sheet5.GetCellValue(i,"jikweeNm")+deli;

			if(sheet5.GetCellValue(i,"jikweeCd") == "") jikweeTmp = " "; else jikweeTmp = sheet5.GetCellValue(i,"jikweeCd");
			referUserEtc+= jikweeTmp+deli;
			if(sheet5.GetCellValue(i,"jikweeNm") == "") jikweeTmp = " "; else jikweeTmp = sheet5.GetCellValue(i,"jikweeNm");
			referUserEtc+= jikweeTmp+deli;

			if(sheet5.GetCellValue(i,"jikchakCd") == "") jikchakTmp = " "; else jikchakTmp = sheet5.GetCellValue(i,"jikchakCd");
			referUserEtc+= jikchakTmp+deli;
			if(sheet5.GetCellValue(i,"jikchakNm") == "") jikchakTmp = " "; else jikchakTmp = sheet5.GetCellValue(i,"jikchakNm");
			referUserEtc+= jikchakTmp+deli;

			referUserEtc+= sheet5.GetCellValue(i,"empAlias")+deli+deli2;
		}
		referUser 		= referUser.substring(0, referUser.length-2);
		referUserEtc 	= referUserEtc.substring(0, referUserEtc.length-1);
		$("#referUser").html(referUser);
		$("#referUserEtc").html(referUserEtc);
	}

	function getApplHtmlToJson() {
		var data = {
			appls: [],
			deputys: [],
			inusers: [],
			refers: [],
		};

		var author = {}; 
		$('#atleft > td > table').each(function() {
			if ( $(this).attr("class") == "author" ) {
				const typeCd = $(this).find("#hTypeCd").html();
				const gubun = typeCd == '30' ? '0':'1';

				if (gubun == '1') {
					author['inSabun'] = $(this).find("#hSabun").html();
					author['inOrg'] = $(this).find("#hOrgNm").html();
					author['inJikchak'] = $(this).find("#hJikchakNm").html();
					author['inJikwee'] = $(this).find("#hJikweeNm").html();
					author['agreeSeq'] = $(this).find("#hAgreeSeq").html();
				}

				data.appls.push({
					agreeSeq : $(this).find("#hAgreeSeq").html(),
					agreeSabun: $(this).find("#hSabun").html(),
					applTypeCd: typeCd,
					gubun: gubun,
					org: $(this).find("#hOrgNm").html(),
					jikwee: $(this).find("#hJikweeNm").html(),
					jikchak: $(this).find("#hJikchakNm").html()
				});
			} else {
				data.deputys.push({
					sabun: $(this).find("#hSabun").html(),
					org: $(this).find("#hOrgNm").html(),
					agreeSabun: $(this).find("#hAgreeSabun").html(),
					jikwee: $(this).find("#hJikweeNm").html(),
					jikchak: $(this).find("#hJikchakNm").html()
				});
			}
		});

		$('#atright > td > table').each(function() {
			data.inusers.push({
				agreeSabun: $(this).find("#hSabun").html(),
				//agreeSeq: $(this).find("#hAgreeSeq").html(),
				applTypeCd: $(this).find("#hTypeCd").html(),
				gubun: '3',
				org: $(this).find("#hOrgNm").html(),
				jikchak: $(this).find("#hJikchakNm").html(),
				jikwee: $(this).find("#hJikweeNm").html(),
				orgAppYn: $(this).find("#orgAppYn").html()
			});
		});

		var refers = $("#referUserEtc").html() != '' ? $("#referUserEtc").html().split(deli2):[]; 
		data.refers = refers.map(str => {
				var t = str.split(deli);
				return {
					...author,
					referSabun: t[3],
					referOrg: t[0],
					referJickchak: t[7],
					referJicwee: t[5],
				};
			});
	
		return data;
	}
	
	function getApplHtmlToPaser(){
		var paserArray = new Array(10);
		var str 		= "";
		var strDebuty 	= "";
		
		paserArray[0]	= $("#lvlCode").val();
		$('#atleft>td>table').each(function(){
			var jikchakTmp = "";
			var jikweeTmp = "";

			if( $(this).attr("class") == "author"){
				str += $(this).find("#hAgreeSeq").html()+deli;
				str += $(this).find("#hTypeCdNm").html()+deli;
				str += $(this).find("#hTypeCd").html()+deli;
				str += $(this).find("#hOrgNm").html()+deli;
				str += $(this).find("#hOrgCd").html()+deli;
				str += $(this).find("#hEmpEtc").html()+deli;
				str += $(this).find("#hSabun").html()+deli;
				//str += $(this).find("#hJikweeCd").html()+deli;
				//str += $(this).find("#hJikweeNm").html()+deli;
				if($(this).find("#hJikweeCd").html() == "") jikweeTmp = " "; else jikweeTmp = $(this).find("#hJikweeCd").html();
				str += jikweeTmp+deli;
				if($(this).find("#hJikweeNm").html() == "") jikweeTmp = " "; else jikweeTmp = $(this).find("#hJikweeNm").html();
				str += jikweeTmp+deli;

				if($(this).find("#hJikchakCd").html() == "") jikchakTmp = " "; else jikchakTmp = $(this).find("#hJikchakCd").html();
				str += jikchakTmp+deli;
				if($(this).find("#hJikchakNm").html() == "") jikchakTmp = " "; else jikchakTmp = $(this).find("#hJikchakNm").html();
				str += jikchakTmp+deli;
				str += $(this).find("#hName").html();
				str 		+= deli2;
			}else{
				strDebuty += $(this).find("#hSabun").html()+deli;
				//strDebuty += $(this).find("#hJikweeNm").html()+deli;
				if($(this).find("#hJikweeNm").html() == "") jikweeTmp = " "; else jikweeTmp = $(this).find("#hJikweeNm").html();
				strDebuty += jikweeTmp+deli;
				if($(this).find("#hJikchakNm").html() == "") jikchakTmp = " "; else jikchakTmp = $(this).find("#hJikchakNm").html();
				strDebuty += jikchakTmp+deli;
				strDebuty += $(this).find("#hOrgNm").html()+deli;
				strDebuty += $(this).find("#hAgreeSabun").html();
				strDebuty 	+= deli2;
			}
		});

		str 			= str.substring(0, str.length-1);
		paserArray[4]	= str;
		paserArray[1]	= str.split(deli2);

		if(strDebuty.length > 0)
			strDebuty	= strDebuty.substring(0, strDebuty.length-1);

		str 			= $("#referUserEtc").html();
		paserArray[5]	= str;
		paserArray[2]	= str.split(deli2);
		paserArray[6]	= strDebuty;
		paserArray[7]   = $("#searchSabun").val();
		paserArray[11]   = "${searchApplSabun}" ;
		return paserArray;
	}

	function setValue(status){
		var rtn = false;
		if(_detExist) {
			//해당 신청코드에 세부프로그램Code가 있는 경우
			rtn = $("#authorFrame").get(0).contentWindow.setValue(status);
		}else {
			//해당 신청코드에 세부프로그램Code가 없는 경우
			rtn = true;
		}
		return rtn;
	}
	function iframeOnLoad(ih){
		//$("#authorFrame").height(ih);
		//iframeLoad = true;
		
		//Sheet 높이를 100%으로 잡았을 때 프레임 높이가 고정이어야 하므로
		// 요청높이보다 실제 크기가 클때만 실제 크기로 설정 해줌. 2020.05.27 jylee
		try{
			var ih2 = parseInt((""+ih).split("px").join(""));
			var h = $("#authorFrame").contents().height();
			if( h > ih2) {
				// hr-50 디자인으로 테이블 스타일 수정 시 높이가 잘려서 수정. 2023.10.24 snow2
				$("#authorFrame").height(h+40);
			}else{
				$("#authorFrame").height(ih);
			}
			iframeLoad = true;
		}catch(e){
			$("#authorFrame").height(ih);
			iframeLoad = true;
		}
	}
	function getInUserHtmlToPaser(){
		var paserArray = new Array(2);
		var str 		= "";

		var jikchakTmp = "";
		$('#atright>td>table').each(function(){
			jikchakTmp = "";
			str += $(this).find("#hAgreeSeq").html()+deli;
			str += $(this).find("#hTypeCdNm").html()+deli;
			str += $(this).find("#hTypeCd").html()+deli;
			str += $(this).find("#hOrgNm").html()+deli;
			str += $(this).find("#hOrgCd").html()+deli;
			str += $(this).find("#hEmpEtc").html()+deli;
			str += $(this).find("#hSabun").html()+deli;
			//str += $(this).find("#hJikweeCd").html()+deli;
			//str += $(this).find("#hJikweeNm").html()+deli;
			if($(this).find("#hJikweeCd").html() == "") jikweeTmp = " "; else jikweeTmp = $(this).find("#hJikweeCd").html();
			str += jikweeTmp+deli;
			jikweeTmp = "";
			if($(this).find("#hJikweeNm").html() == "") jikweeTmp = " "; else jikweeTmp = $(this).find("#hJikweeNm").html();
			str += jikweeTmp+deli;

			if($(this).find("#hJikchakCd").html() == "") jikchakTmp = " "; else jikchakTmp = $(this).find("#hJikchakCd").html();
			str += jikchakTmp+deli;
			jikchakTmp = "";
			if($(this).find("#hJikchakNm").html() == "") jikchakTmp = " "; else jikchakTmp = $(this).find("#hJikchakNm").html();
			str += jikchakTmp+deli;
			str += $(this).find("#hName").html()+deli;
			str += $(this).find("#orgAppYn").html();
			str 		+= deli2;
		});
		str 			= str.substring(0, str.length-1);
		paserArray[0]	= str;
		paserArray[1]	= str.split(deli2);

		return paserArray;
	}
	function doSave(status){
		//신청시 확인메세지가 있으면 물어보게 수정 2020.11.12
		if(status == "21" && $.trim("${uiInfo.confirmMsg}")){
			if(!confirm("${uiInfo.confirmMsg}")){return;};
		}
		$("#applStatusCd").val(status);
		if(!iframeLoad){return alert("<msg:txt mid='109888' mdef='업무 화면이 로딩 되지 않았습니다.n 로딩완료후 다시 시도 하십시오!'/>");}
		var attFileCnt = $('#myUpload').IBUpload('fileList');
		//첨부파일 필수여부 체크 (임시저장일 경우 제외)
		if("${uiInfo.fileEssentialYn}" == 'Y' && attFileCnt == 0 && status != "11") {
			if ($('#fileReqYn').val() != "N") {
				alert("파일 첨부가 필요한 신청입니다.");
				return;
			}
		}
		
		var saveUserArray = getApplHtmlToPaser();
		
		// 결재선이 지정되지 않은 경우
		if(saveUserArray == null || saveUserArray == undefined || saveUserArray[4] == "" || saveUserArray[4] == null || saveUserArray[4] == undefined) {
			return alert("결재선이 지정되어 있지 않습니다.\n결재선을 지정해 주시기 바랍니다.");
		}

		//본인결재 허용여부 체크
		if("${uiInfo.pathSelfCloseYn}" == "N" &&  saveUserArray[1].length == 1 ) {
			alert('결재선이 본인만 지정되었습니다. 결재자를 추가로 지정하여 신청해 주십시오.');
			return;
		}

		/*
		 * 하위 문서의 applseq를 새로운 applseq로 셋팅해줌
		 */
		if($("#reApplSeq").val() != '' && $("#reApplSeq").val() != null){
			if($('#authorFrame').contents().find('#searchApplSeq')){
				$('#authorFrame').contents().find('#searchApplSeq').val($("#reApplSeq").val());
			}
		}
		
		//저장(신청) 시 대기중 이미지가 나오게 수정 2020.08.18
		progressBar(true, "Please Wait...");
		setTimeout( function(){
			if(!setValue(status)){
				progressBar(false);//hideOverlay();
				return;
			}
			var saveInUserArray = getInUserHtmlToPaser();
			$("#pathSeq").val(saveUserArray[0]);
			$("#applUserStr").val(saveUserArray[4]);
			$("#referUserStr").val(saveUserArray[5]);
			$("#deputyUserStr").val(saveUserArray[6]);


			$("#inUserStr").val(saveInUserArray[0]);
	
			$("#authorForm>#fileSeq").val($("#uploadForm>#fileSeq").val());
			if($("#reApplSeq").val() != '' && $("#reApplSeq").val() != null){
				$("#searchApplSeq").val($("#reApplSeq").val());
			}

			const param = {
				...formToJson($("#authorForm")),
				...getApplHtmlToJson()
			};

			var rtn = ajaxTypeJson("${ctx}/ApprovalMgr.do?cmd=saveApprovalMgr", param, false);
			if(rtn){
				var msg = "";
				switch(rtn.Code){
				case 1:
					msg = (status == 11)?"저장 되었습니다.":"신청 되었습니다.";
					break;
				case 0:
					msg = (status == 11)?"저장된 내용이 없습니다.":"신청된 내용이 없습니다.";
					break;
				case -1:
					msg = (status == 11)?"저장에 실패 하였습니다.":"신청에 실패하였습니다.";
					break;
	
				}
				if(status != "11" && Number(rtn.cnt) > 0 ) {
					if(status == "21"){
						try{
							ajaxCall("${ctx}/Send.do?cmd=callMailAppl","applSeq="+$("#searchApplSeq").val()+"&applStatusCd="+status+"&firstDiv=Y",false);
						}catch(e){
							alert("메일전송 중 오류가 발생 했습니다.");
						}
					}
				}	
				
				alert(msg);
			}

			progressBar(false);
			p.popReturnValue([]);
			p.self.close();
		//----- setTimeout:e --------------------------------------------------------------------------- 
		}, 100);

	}

	function filePopup() {
		if(!isPopup()) {return;}

		var param = [];
		param["fileSeq"] = $("#etcNoteFileSeq").val();
		openPopup("/fileuploadJFileUpload.do?cmd=fileMgrPopup&authPg=R", param, "740","420", function(rv) {
			$("#fileSeq").val(rv["fileSeq"]);
		});
	}

</script>

<body>
<div class="wrapper popup_scroll" id="approvalMgrPage">
	<div class="popup_title">
		<ul>
			<li><span id="span_applTitle"></span></li>
			<li class="close">
<!-- 				<div class="print" style="display:none"> -->
<!-- 					<a class="basic"><tit:txt mid='104146' mdef='인쇄'/></a> -->
<!-- 				</div> -->
			</li>
		</ul>
	</div>
	<div class="popup_main" style="padding-top:0;">
<!-- 		<form id="_ehr_authForm" name="_ehr_authForm"> -->
		<form id="jejuForm" name="jejuForm"></form>
		<form id="authorForm" name="form">
			<input id="searchApplCd" 	name="searchApplCd" 	type="hidden" value="${searchApplCd}"/>
			<input id="searchApplSeq" 	name="searchApplSeq" 	type="hidden" value="${searchApplSeq}"/>
			<input id="reApplSeq" 		name="reApplSeq" 		type="hidden" value="${reApplSeq}"/>
			<input id="searchApplSabun" name="searchApplSabun" 	type="hidden" value="${searchApplSabun}"/><!-- 신청자 대상자 사번 -->
			<input id="searchApplName" 	name="searchApplName" 	type="hidden" value="${userInfo.name}"/>  <!-- 신청자 대상자 성명 -->
			<input id="adminYn" 		name="adminYn" 			type="hidden" value="${adminYn}"/>
			<input id="authPg" 			name="authPg" 			type="hidden" value="${authPg}"/>
			<input id="searchApplYmd" 	name="searchApplYmd" 	type="hidden" value="${searchApplYmd}"/>
			<input id="searchSabun" 	name="searchSabun" 		type="hidden" value="${searchSabun}"/><!-- 신청 내용을 입력 하는 사람 -->

			<input id="applUserStr" 	name="applUserStr" 		type="hidden" value=""/>
			<input id="inUserStr" 		name="inUserStr" 		type="hidden" value=""/>
			<input id="deputyUserStr" 	name="deputyUserStr" 	type="hidden" value=""/>
			<input id="referUserStr" 	name="referUserStr" 	type="hidden" value=""/>
			<input id="pathSeq" 		name="pathSeq" 			type="hidden" value=""/>
			<input id="applStatusCd" 	name="applStatusCd" 	type="hidden" value=""/>
			<input id="fileSeq"			name="fileSeq"			type="hidden" value=""/>
			<input id="gubun" 			name="gubun" 			type="hidden" value="${gubun}"/>
			
			<input id="procExecYn" 			name="procExecYn" 			type="hidden" value="${uiInfo.procExecYn}"/>
			<input id="afterProcStatusCd"	name="afterProcStatusCd"	type="hidden" value=""/> <!-- 이전신청서 상태코드  2020.01.14 -->

			<input id="etc01"			name="etc01"			type="hidden" value="${etc01}"/>
			<input id="etc02"			name="etc02"			type="hidden" value="${etc02}"/>
			<input id="etc03"			name="etc03"			type="hidden" value="${etc03}"/>

			<input id="applTitle"       name="applTitle"        type="hidden" />

			<div class="h10" id="applLineTitle_blank" style="display:none"></div>
			
        	<div id="author_info">
	
				<div class="sheet_title" id="applLineTitle" style="padding-top:0;">
					<ul>
						<li style="float:left;"></li>
						<li class="btn">
							<select id="lvlCode" name="lvlCode" style="display:none"></select>
							<a href="javascript:chgApplPopup();" id="btnAppPath" class="basic" style="display:none"><tit:txt mid='113557' mdef='결재선 변경'/></a>
						</li>
					</ul>
				</div>
				
				<div class="sheet_title hide" id="applSpaceLine">
					<ul>
						<li style="float:left;margin-top:13px;"></li>
					</ul>
				</div>
	
				<div class="author_left">
					<table>
						<tr id="atleft">
						</tr>
					</table>
				</div>
				<div class="author_right">
					<table>
						<tr id="atright">
						</tr>
					</table>
				</div>
			</div>	

<!-- 			<div class="auto_info"> -->
<!-- 				<ul> -->
<!-- 					<li class="info_txt">* 성명, 날자컬럼에 마우스 오버 시 사번, 시간을 확인 하실 수 있습니다.<br/>* 결재라인 7명 이상 시 두줄형태로 배치됨니다.</li> -->
<!-- 					<li class="info_color"> -->
<!-- 						<span class="box_green"></span> 신청 -->
<!-- 						<span class="box_blue"></span> 대결 -->
<!-- 						<span class="box_aqua"></span> 담당. -->
<!-- 					</li> -->
<!-- 				</ul> -->
<!-- 			</div> -->

			<div class="clear"></div>
			<table border="0" cellpadding="0" cellspacing="0" class="settle">
				<colgroup>
					<col width="15%" />
					<col width="85%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='113550' mdef=' 수신참조 '/></th>
					<td id="referUser"> </td>
					<td id="referUserEtc" class="hide"></td>
				</tr>
			</table>
			
			<!-- <div class="h15"></div> -->
			<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='201706090000001' mdef='신청자'/></li>
			</ul>
			</div>
			
			<table border="0" cellpadding="0" cellspacing="0" class="settle">
				<colgroup>
		            <col width="80px" />
		            <col width="100px" />
		            <col width="80px" />
		            <col width="150px" />
		            <col width="80px" />
		            <col width="100px" />
		            <col width="80px" />
		            <col width="" />
				</colgroup>
				<tr>
					<th><tit:txt mid='104084' mdef='신청일자'/></th>
					<td> ${userInfo.applYmd} </td>
					<th><tit:txt mid='114648' mdef=' 소속 '/></th>
					<td> ${userInfo.orgNm} </td>
					<th> 사번 </th>
					<td> ${userInfo.sabun} </td>
					<th><tit:txt mid='114252' mdef=' 성명 '/></th>
					<td> ${userInfo.name} </td>
				</tr>
			</table>

			<div class="h5"></div>
			<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe" style="height:100px;"></iframe>
		</form>
		<table class="sheet_main" id="etcCommentDiv" style="display:none;">
		<tr>
			<td class="bottom outer">
				<div class="explain">
					<div class="title">
						<tit:txt mid='appInstruction' mdef='신청시 유의사항'/>
						<input id="etcNoteFileSeq" name="etcNoteFileSeq" type="hidden" value="${etcNoteFileSeq}"/>
						<span style="float:right;margin-top:-5px;">
							<btn:a href="javascript:filePopup();" css="basic" mid='201707120000001' mdef="파일다운로드" id="etcNoteFile" style="display:none;background-color:#fff;"/>
						</span>
					</div>
					<div class="txt">
					<table>
						<tr>
							<td id="etcComment">${uiInfo.etcNote}</td>
						</tr>
					</table>
					</div>
				</div>
			</td>
		</tr>
		</table>

		<div id="uploadDiv" style="display:none;">
		<%//@ include file="/WEB-INF/jsp/common/popup/uploadMgrPopup.jsp"%>
		<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>
		</div>

		<div class="popup_button">
			<ul>
				<li>
					<btn:a href="javascript:doSave('11');" 		css="gray large" mid='111109' id="appTemporary" mdef="임시저장"/>
					<btn:a href="javascript:doSave('21');" 		css="pink large" mid='applButton' id="applButton" mdef="신청" />
					<btn:a href="javascript:p.self.close();" 	css="gray large" mid='110881' id="close" mdef="닫기"/>
				</li>
			</ul>
		</div>
	</div>
</div>
</body>
</html>
