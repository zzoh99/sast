<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html class="hidden"> <head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
<title><tit:txt mid='103897' mdef='신청결재 관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>

<% request.setAttribute("uploadType", "appl"); %>

<script type="text/javascript">
//서명출력 여부
var signViewYnData = convCode( ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList&searchStdCd=HRI_SIGN_VIEW_YN", "queryId=getSystemStdData",false).codeList, "");
var signViewYn = "status";
if(signViewYnData[0] != "") {
	if( signViewYnData[0] == "Y" ) {
		signViewYn = "status";
	} else if( signViewYnData[0] == "N" ) {
		signViewYn = "hide";
	}
}

var authorLeft 	= "";
	authorLeft += "<td><table class='#clsNm#'>";
	authorLeft += "<tr><th id='hTypeCdNm'>	#typeCdNm#</th></tr>";
	authorLeft += "<tr><td id='hOrgNm' 		class='name'>#orgNm#</td></tr>";
	authorLeft += "<tr><td id='hJikchakNm'	class='hide'>#jikchakNm#</td></tr>";
	authorLeft += "<tr><td id='hJikweeNm' 	class='status'>#jikweeNm#</td></tr>";
	authorLeft += "<tr><td id='hName'		class='status' 	alt='#sabun#' 	title='#title#'>#name#</td></tr>";
	authorLeft += "<tr><td id='hDate'		class='date' 	alt='#hms#' 	title='#hms#'>#ymd#</td></tr>";
	authorLeft += "<tr><td id='hSabun' 		class='hide'>#sabun#</td></tr>";
	authorLeft += "<tr><td id='hJikweeCd' 	class='hide'>#jikweeCd#</td></tr>";
	authorLeft += "<tr><td id='hJikchakCd' 	class='hide'>#jikchakCd#</td></tr>";
	authorLeft += "<tr><td id='hOrgCd' 		class='hide'>#orgCd#</td></tr>";
	authorLeft += "<tr><td id='hTypeCd' 	class='hide'>#typeCd#</td></tr>";
	authorLeft += "<tr><td id='hAgreeSeq' 	class='hide'>#agreeSeq#</td></tr>";
	authorLeft += "<tr><td id='hMemo' 		class='hide'>#memo#</td></tr>";
	
	authorLeft += "<tr><td id='orgAppYn' 	class='hide'>#orgAppYn#</td></tr>";
	authorLeft += "<tr><td id='sign' class='"+signViewYn+"'><img src=#signPath# height='30' name='signPath' style='margin: 1px 0px 0px 0px'></td></tr>";
	authorLeft += "<tr><td id='hHms' 		class='hide'>#hms#</td></tr>";
	authorLeft += "</table></td>";
var emptyLeft 	= "<td><div class='arrow'>&nbsp;</div></td>";

var memoInput	= "<tr style='display:none;'>";
	memoInput  += "<th>#orgNm# / #jikchak# / #name#</th>";
	memoInput  += "<td><input id='agreeUserMemo' name='agreeUserMemo' type='text' class='text w100p'/></td></tr>";

var memo		= "<tr><th>#orgNm# / #jikchak# / #name#</th><td>#memo#</td></tr>";

var referOri	= "<tr id='referOriTr' class='delTr'>";
 	referOri   += "<td>#orgNm# / #jikchak# / #name#<br/><span style='font-family:verdana;font-size:11px;letter-spacing:-1px'>";
	referOri   += "#date#</span></td>";
	referOri   += "<td id='referTd#inSabun#'>#referUser#</td></tr>";

var referNew	= "<tr id='referTr' class='delTr'>";
 	referNew   += "<td>#orgNm# / #jikchak# / #name#<br/><span style='font-family:verdana;font-size:11px;letter-spacing:-1px'>";
	referNew   += "#date#</span></td>";
	referNew   += "<td id='referTd#inSabun#'>#referUser#</td></tr>";

var applList 	= null;
var referList	= null;
var iframeLoad 	= false;

var agreeChange = false;
var agreeSabun 	= "";
var agreeSeq	= "";

var oriLeftSabun = "";
var oriReferSabun= "";

var leftSave 	= false;
var referSave 	= false;
var referAllList= null;
var referAgreeSeq= "";
var p 			= eval("${popUpStatus}");

var _detExist	= false;
	$(function() {
		//var fileSeq2 = "";
		var detailPrgCd = "${uiInfo.detailPrgCd}";
		if(detailPrgCd != "") {
			_detExist = true;
		}
		if(_detExist) {
			//해당 신청코드에 세부프로그램Code가 있는 경우
			//업무 화면 로딩
			submitCall($("#authorForm"),"authorFrame","post","${ctx}${uiInfo.detailPrgCd}");
		}else {
			//해당 신청코드에 세부프로그램Code가 없는 경우
			iframeOnLoad("0px");
		}
		//화면 기본 설정
		if("${uiInfo.agreeYn}" == "N" && "${uiInfo.recevYn}" == "N"){
			$("#author_info").hide();
		}
		if("${uiInfo.printYn}" 	== "Y") $(".print").show();
		if("${uiInfo.fileYn}" 	== "Y") $("#uploadDiv").show();
		if("${uiInfo.etcNoteYn}" == "Y") {
			$("#etcCommentDiv").show();
		}
		

		/*
		 * 교육신청시 반려일 경우 재사용 버튼 추가
		 * ---------------------------------------
		 * 2021-06-16	JWS
		 */
		if('${uiInfo.reUseYn}' == 'Y'){
			$("#reUseBtn").show();
		}
		
		//의견등록 yn여부에 따라 show, hidde
		if("${uiInfo.commentYn}" == "Y") {
            $("#trComments").show(); // 의견작성창 show
            
            //의견댓글 html 활성화
            searchComment();
		}
		else {
			$("#trComments").hide();
		}

        //웹출력여부 --2020.01.30
        if("${uiInfo.webPrintYn}"  == "Y") $(".windowPrint").show();

		$("a#uploadBtn").hide();
		$("a#deleteBtn").hide();
		$("div#DIV_mainUpload").hide();

		$(".close").click(function() 	{ p.popReturnValue(); p.self.close(); });
	    $(".print>a").click(function(e) { e.stopPropagation(); });

	    //title
	    $("#applTitle").html("${applMasterInfo.title}");

	    //결재 코드
// 		var applStatusCode 	= convCodeIdx( codeList("${ctx}/CommonCode.do?cmd=getCommonCodeList","R10010"), "",-1);
// 		$("#statusCd").html(applStatusCode[2]);
// 		$("#statusCd").val("${applMasterInfo.applStatusCd}");
		if("${param.adminYn}" == "Y"){
			$.ajax({
				url 		: "${ctx}/CommonCode.do?cmd=getCommonCodeList",
				type 		: "post", dataType 	: "json", async 		: false, data 		: "grpCd=R10010&useYn=Y",
				success : function(rv) {
					var applStatusCode 	= convCodeIdx( rv.codeList, "",-1);
					$("#statusCd").html(applStatusCode[2]);
					$("#statusCd").val("${applMasterInfo.applStatusCd}");
					$("#statusTable").show();
					$("#adminBtn").show();
				},
				error : function(jqXHR, ajaxSettings, thrownError) {
					ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
				}
			});
		}
	    $.ajax({
			url 		: "${ctx}/ApprovalMgrResult.do?cmd=getApprovalMgrResultTHRI107",
			type 		: "post", dataType 	: "json", async 		: false, data 		: $("#authorForm").serialize(),
			success : function(rv) {
				applList = rv.DATA;
				chgApplSaveList(applList);
			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});

	    $.ajax({
			url 		: "${ctx}/ApprovalMgrResult.do?cmd=getApprovalMgrResultTHRI125",
			type 		: "post", dataType 	: "json", async 		: false, data 		: $("#authorForm").serialize(),
			success : function(rv) {
				referList = rv.DATA;
				chgReferSaveList(referList);
			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});

	    $.ajax({
			url 		: "${ctx}/ApprovalMgrResult.do?cmd=getApprovalMgrResultReferAllList",
			type 		: "post", dataType 	: "json", async 		: false, data 		: $("#authorForm").serialize(),
			success : function(rv) {
				referAllList = rv.DATA;
			},
			error : function(jqXHR, ajaxSettings, thrownError) {
				ajaxJsonErrorAlert(jqXHR, ajaxSettings, thrownError);
			}
		});

		//파일 초기화
		upLoadInit("${applMasterInfo.fileSeq}","");
		//if(fileSeq2 != null && fileSeq2 != ""){
			//upLoadInit2(fileSeq2,"${hri}");
		//}

		if("${applMasterInfo.applInSabun}" == "${ssnSabun}"){
			if("${cancelButton.cancel}" == "YES") $("#cancelBtn").show();
		}

		$('#authorFrame').on("load", function() {
			setIframeHeight(this.id);
		});

	});

	//의견댓글 list  
    function searchComment(){

		var table_html1="<table class=\"table\" style=\"border:2px solid #dae1e6;\">"
			+"<colgroup>"
			+"<col width=\"15%\" />"
			+"<col width=\"70%\" />"
			+"<col width=\"15%\" />"
			+"</colgroup>"
			+"<tr id=\"commentWrite\">"
			+"<th class=\"center\" style=\"border:1px solid #ebeef0;\">의견달기</td>"
			+"<th style=\"border:1px solid #ebeef0;\">"
			+"<form id=\"cmtFrm\" name=\"cmtFrm\" >"
			+"<textarea id=\"comments\" name=\"comments\" rows=\"3\" style=\"width:100%\" maxlength=\"4000\"></textarea>"
			+"</form>"
			+"</th>"
			+"<th class=\"center middle\" style=\"border:1px solid #ebeef0;\">"
			+"<span><a href=\"javascript:doSaveComment()\" class=\"basic large\">의견등록</a></span>"
			+"</th>"
			+"</tr>"
			var table_html2="</table>";
    	
    	var comments_html="";
		var cmtData = ajaxCall("${ctx}/ApprovalMgrResult.do?cmd=getCommentList",$("#srchFrm").serialize(),false);
		if (cmtData != null && cmtData.DATA != null) {
			for(var j = 0; j < cmtData.DATA.length; j++) {
				var empName = cmtData.DATA[j].empName;
				var sabun = cmtData.DATA[j].sabun;
				var applCd = cmtData.DATA[j].applCd;
				var comments = cmtData.DATA[j].comments;
					comments = comments.split('\\n').join("<br>");				
				var comments_seq = cmtData.DATA[j].commentsSeq;
				var chkdate = cmtData.DATA[j].chkdate;

				comments_html += "<table class='default' style='margin-bottom:2px' >\n";
				comments_html += "	<colgroup>\n";
				comments_html += "		<col width=\"10%\"/>\n";
				comments_html += "		<col width=\"70%\"/>\n";
				comments_html += "		<col width=\"15%\"/>\n";
				comments_html += "	</colgroup>\n";

				if(sabun == "${sessionScope.ssnSabun}"){
					comments_html += "	<tr style='height:25px'>\n";
					comments_html += "		<td class='center'><a name=\"commentDel\" href=\"#\" onclick='profilePopup(\""+sabun+"\")' class='center tBlue'>" + empName + "</a></td>\n";
					comments_html += "		<td style=\"background:#fff;\">" +comments+ "</td>\n";
					comments_html += "		<td class='tBlue'>" +chkdate+"&nbsp;&nbsp;&nbsp;<a name=\"commentDel\" href=\"javascript:DelComment('"+comments_seq+"')\" onclick='' class='button7'><img src='/common/images/icon/icon_basket.png'/></a></td>\n" ;
					comments_html += "	</tr>\n";
				}
				else {

					comments_html += "	<tr style='height:25px'>\n";
					comments_html += "		<td class='center'><a name=\"commentDel\" href=\"#\" onclick='profilePopup(\""+sabun+"\")' class='center tBlue'>" + empName + "</a></td>\n";
					comments_html += "		<td style=\"background:#fff;\">" +comments+ "</td>\n";
					comments_html += "		<td class='tBlue'>" +chkdate+"</td>\n" ;
					comments_html += "	</tr>\n";
				}
				comments_html += "</table>\n";
			}

			if (comments_html != ""){
				comments_html = "<th colspan=\"3\" id=\"tdComments\" align=\"center\">"
				+ comments_html
				+ "</th>";
			}
			
			$("#spanTable").html(table_html1 + comments_html + table_html2);
		}
    	
    }

    //의견등록 save
    function doSaveComment(){
		$("#comments").val($("#comments").val().replace(/(?:\r\n|\r|\n)/g, '\\n'));
		ajaxCall("${ctx}/ApprovalMgrResult.do?cmd=saveComment",$("#srchFrm").serialize()+"&"+$("#cmtFrm").serialize(),false);
		$("#comments").val("");
		searchComment();
   	}
		
  
    
  	//의견댓글 삭제
    function DelComment(cmtSeq) {
    	if(confirm("의견을 삭제하시겠습니까?")) {
    		var rtn = ajaxCall("${ctx}/ApprovalMgrResult.do?cmd=delComment&commentsSeq="+cmtSeq,$("#srchFrm").serialize(),false);
    		searchComment();
    	} else {
    		return;
    	}
    }

    function profilePopup(paramSabun){
    	isPopup()
    	var w 		= 610;
    	var h 		= 260;
    	var url 	= "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
    	var args 	= new Array();
    	args["sabun"] 		= paramSabun;
    	var rv = openPopup(url,args,w,h);
    }

	//----------------------------------------------------------/
	function setIframeHeight(id) {
		var ifrm = document.getElementById(id);

		var doc = ifrm.contentDocument? ifrm.contentDocument: ifrm.contentWindow.document;
		ifrm.style.visibility = 'hidden';
		//ifrm.style.height = "10px"; // reset to minimal height ...
		// IE opt. for bing/msn needs a bit added or scrollbar appears
		ifrm.style.height = getDocHeight( doc ) + 20 + "px";
		ifrm.style.visibility = 'visible';
	}

	function getDocHeight(doc) {
		doc = doc || document;
		// stackoverflow.com/questions/1145850/
		var body = doc.body, html = doc.documentElement;
		var height = Math.max( body.scrollHeight, body.offsetHeight, html.clientHeight, html.scrollHeight, html.offsetHeight );
		return height;
	}

	//----------------------------------------------------------/

	function chgReferSaveList(referUserList){
		var oldSeq 			= 0;
		var referUser 		= "";
		var tmpRefer		= "";
		var referUserOriEtc = "";

		for(var i=0; i<referUserList.length; i++){
			oriReferSabun  += referUserList[i].ccSabun+",";
			if(i==0)oldSeq	= referUserList[i].agreeSeq;

			if( oldSeq !=referUserList[i].agreeSeq){
				referUser 	= referUser.substring(0, 	referUser.length-2);
				tmpRefer 	= referOri
					.replace(/#orgNm#/g,		referUserList[i-1].inOrgNm)
					.replace(/#jikchak#/g,		referUserList[i-1].inJikchakNm)
					.replace(/#name#/g,			referUserList[i-1].inName)
					.replace(/#date#/g,			referUserList[i-1].chkdate)
					.replace(/#inSabun#/g,		referUserList[i].inSabun)
					.replace(/#referUser#/g,	referUser)
				;
				$("#referTable").append(tmpRefer);

				oldSeq 		= referUserList[i].agreeSeq;
				referUser 	= "";
				referUser  += referUserList[i].ccOrgNm+" "+referUserList[i].name+"("+referUserList[i].ccSabun+") / ";

				if(i == referUserList.length-1){
					referUser 	= referUser.substring(0, 	referUser.length-2);

					tmpRefer 	= referOri
						.replace(/#orgNm#/g,		referUserList[i].inOrgNm)
						.replace(/#jikchak#/g,		referUserList[i].inJikchakNm)
						.replace(/#name#/g,			referUserList[i].inName)
						.replace(/#date#/g,			referUserList[i].chkdate)
						.replace(/#inSabun#/g,		referUserList[i].inSabun)
						.replace(/#referUser#/g,	referUser)
					;
					$("#referTable").append(tmpRefer);
				}

			}else if(i == referUserList.length-1){
				referUser  += referUserList[i].ccOrgNm+" "+referUserList[i].name+"("+referUserList[i].ccSabun+") / ";
				referUser 	= referUser.substring(0, 	referUser.length-2);

				tmpRefer 	= referOri
					.replace(/#orgNm#/g,		referUserList[i].inOrgNm)
					.replace(/#jikchak#/g,		referUserList[i].inJikchakNm)
					.replace(/#name#/g,			referUserList[i].inName)
					.replace(/#date#/g,			referUserList[i].chkdate)
					.replace(/#inSabun#/g,		referUserList[i].inSabun)
					.replace(/#referUser#/g,	referUser)
				;
				$("#referTable").append(tmpRefer);
			}else{
				referUser 	+= referUserList[i].ccOrgNm+" "+referUserList[i].name+"("+referUserList[i].ccSabun+") / ";
			}

			referUserOriEtc	+= referUserList[i].ccOrgNm+","+referUserList[i].ccOrgCd+","+referUserList[i].name+","+referUserList[i].ccSabun+","+referUserList[i].ccJikweeCd+","+referUserList[i].ccJikweeNm+",";

			if(referUserList[i].ccJikchakCd == "") jikchakTmp = " "; else jikchakTmp = referUserList[i].ccJikchakCd;
	    	referUserOriEtc	+= jikchakTmp+",";

	    	if(referUserList[i].ccJikchakNm == "") jikchakTmp = " "; else jikchakTmp = referUserList[i].ccJikchakNm;
	    	referUserOriEtc	+= jikchakTmp+"@";

		}
		referUserOriEtc = referUserOriEtc.substring(0,referUserOriEtc.length-1);
		$("#referUserOriEtc").val(referUserOriEtc);
	}

	 var signImg20_0 = "/common/images/common/defaultApp.gif";
	 var signImg20_3 = "/common/images/common/defaultRcv.gif";
	 var signImg30 = "/common/images/common/defaultRtn.gif";
	 var signImgNo = "/common/images/common/blank.gif";

	function chgApplSaveList(applList){
		var tempLeft		="";
		var tempRight		="";
		var tempMemo		="";
		var tempMemoInput	="";
		var referShow		= false;
		var memoShow 		= false;
		if(applList.length > 0 )$("#pathSeq").val(applList[0].pathSeq);

		for(var i=0; i<applList.length; i++){

			if(applList[i].agreeSabun == "${ssnSabun}") referAgreeSeq = applList[i].agreeSeq;

			if(applList[i].agreeStatusCd == "10"){
				agreeSabun	= applList[i].agreeSabun;
				agreeSeq 	= applList[i].agreeSeq;

				if(applList[i].deputyYn =="Y" || applList[i].deputyName !=""){
					if(applList[i].deputySabun == "${ssnSabun}"){
						var tJikchak = applList[i].deputyJikchakNm==""?" ":applList[i].deputyJikchakNm;
						var dpsi = ""+applList[i].deputySabun+","+applList[i].deputyOrgNm+","+tJikchak+","+applList[i].deputyJikweeNm;

						$("#deputyInfo").val(dpsi);
						//$("a#applChgBtn").show();
                        $("#applBtn").show();$("#applBtnTop").show(); //[결재][반려] 버튼
						//$("a#addChgBtn").show();
						memoShow = true;

						tempMemoInput = memoInput
							.replace(/#orgNm#/g,	applList[i].deputyOrgNm)
							.replace(/#jikchak#/g,	applList[i].deputyJikchakNm==""?applList[i].deputyJikweeNm:applList[i].deputyJikchakNm)
							.replace(/#name#/g,		applList[i].deputyEmpAlias)
						;

						$("#searchSabun").val("${ssnSabun}");
					}
				}else if(applList[i].agreeSabun == "${ssnSabun}"){
					//$("a#applChgBtn").show();
                    $("#applBtn").show();$("#applBtnTop").show(); //[결재][반려] 버튼
					//$("a#addChgBtn").show();
					memoShow = true;

					tempMemoInput = memoInput
						.replace(/#orgNm#/g,	"${userInfo.orgNm}")
						.replace(/#jikchak#/g,	"${userInfo.jikchakNm}"==""?"${userInfo.jikweeNm}":"${userInfo.jikchakNm}")
						.replace(/#name#/g,		"${userInfo.name}")
					;
				}
				//수신담당이 조직일 경우
				else if(applList[i].agreeSabun == "${ssnOrgCd}"){
					   $("#applBtn").show();$("#applBtnTop").show(); //[결재][반려] 버튼
						//$("a#addChgBtn").show();
						memoShow = true;

						tempMemoInput = memoInput
							.replace(/#orgNm#/g,	"${userInfo.orgNm}")
							.replace(/#jikchak#/g,	"${userInfo.jikchakNm}"==""?"${userInfo.jikweeNm}":"${userInfo.jikchakNm}")
							.replace(/#name#/g,		"${userInfo.name}")
						;
				} 
				
				applUser = true;
			}
			if(applList[i].agreeStatusCd == "20"){
				if(applList[i].agreeSabun == "${ssnSabun}"){
					//$("a#addReferBtn").show();
				}
			}
			if( applList[i].gubun != "3") {
				//if(applList[i].agreeSabun == "${ssnSabun}") referShow = true;
				$(".author_left").css("background-color", "#e3f0f6");
				var yms 	= "";
				var hms 	= "";
				var statusNm= "";
				var agreeStatusNm = "";

				if(applList[i].agreeStatusCd != "10"){
					if(applList[i].deputyYn !="Y"){
						yms = applList[i].agreeYmd;
						hms = applList[i].agreeHms;
					}
				}
				if( applList[i].deputyName =="") statusNm  = applList[i].applTypeCdNm;

				//서명 출력을 위한 처리
				var signPath = "/common/images/common/defaultApp.gif";
				if( applList[i].agreeStatusCd != "" && applList[i].signYn =="Y") {
					if(applList[i].agreeStatusCd =="20") {
						signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun;
						if(applList[i].deputyYn =="Y" || applList[i].deputyName !=""){
							signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].deptySabun;
						}
					} else if(applList[i].agreeStatusCd =="30") {
						signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun;
						if(applList[i].deputyYn =="Y" || applList[i].deputyName !=""){
							signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].deptySabun;
						}
					} else {
						signPath  = signImgNo;
					}
				} else {
					if(applList[i].agreeStatusCd =="20") {
						signPath  = signImg20_0;
					} else if(applList[i].agreeStatusCd =="30") {
						signPath  = signImg30;
					} else {
						signPath  = signImgNo;
					}
				}


				var refAgreeYmd = "";
				var refSignPath = "";
				if(applList[i].deputyYn =="Y" || applList[i].deputyName !=""){
					refAgreeYmd = "";
					refSignPath = signImgNo;
				} else {
					refAgreeYmd = applList[i].agreeYmd;
					refSignPath = signPath;
				}
				tempLeft+=authorLeft
					.replace(/#clsNm#/g,	"author")
					.replace(/#typeCdNm#/g,	applList[i].applTypeCdNm)
					.replace(/#orgNm#/g,	applList[i].agreeOrgNm)
					.replace(/#jikchakNm#/g,applList[i].agreeJikchakNm)
					.replace(/#sabun#/g,	applList[i].agreeSabun)
					.replace(/#title#/g,	applList[i].agreeSabun)
					.replace(/#name#/g,		applList[i].agreeName)
					.replace(/#ymd#/g,		refAgreeYmd)
					.replace(/#hms#/g,		applList[i].agreeHms)
					.replace(/#jikweeNm#/g,	applList[i].agreeJikweeNm)
					.replace(/#typeCd#/g,	applList[i].applTypeCd)
					.replace(/#agreeSeq#/g,	applList[i].agreeSeq)
					.replace(/#orgAppYn#/g,	applList[i].orgAppYn)
					.replace(/#signPath#/g,	refSignPath)
				;

				oriLeftSabun += applList[i].agreeSabun+",";

				if( applList[i].deputyYn =="Y" || applList[i].deputyName !=""){
					tempLeft+=authorLeft
						.replace(/#clsNm#/g,	"author instead")
						.replace(/#typeCdNm#/g,	"대결")
						.replace(/#orgNm#/g,	applList[i].deputyOrgNm)
						.replace(/#jikchakNm#/g,applList[i].deputyJikchakNm)
						.replace(/#sabun#/g,	applList[i].deputySabun)
						.replace(/#title#/g,	applList[i].deputySabun)
						.replace(/#name#/g,		applList[i].deputyName)
						.replace(/#ymd#/g,		applList[i].agreeYmd)
						.replace(/#hms#/g,		applList[i].agreeHms)
						.replace(/#jikweeNm#/g,	applList[i].deputyJikweeNm)
						.replace(/#orgCd#/g,	applList[i].deputyaOrgCd)
						.replace(/#typeCd#/g,	applList[i].applTypeCd)
						.replace(/#agreeSeq#/g,	applList[i].agreeSeq)
						.replace(/#orgAppYn#/g,	applList[i].orgAppYn)
						.replace(/#signPath#/g,	signPath)
					;
					oriLeftSabun += applList[i].deputySabun+",";

					if( applList[i].memo != ""){
						tempMemo += memo
							.replace(/#orgNm#/g,applList[i].deputyOrgNm)
							.replace(/#jikchak#/g,applList[i].deputyJikchakNm==""?applList[i].deputyJikweeNm:applList[i].deputyJikchakNm)
							.replace(/#name#/g,applList[i].deputyEmpAlias)
							.replace(/#memo#/g,applList[i].memo)
						;
					}
				} else{
					if( applList[i].memo != ""){
						tempMemo += memo
							.replace(/#orgNm#/g,applList[i].agreeOrgNm)
							.replace(/#jikchak#/g,applList[i].agreeJikchakNm==""?applList[i].agreeJikweeNm:applList[i].agreeJikchakNm)
							.replace(/#name#/g,applList[i].agreeEmpAlias)
							.replace(/#memo#/g,applList[i].memo)
						;
					}
				}
				if( applList.length == i+1) break;
				if( applList[i+1].gubun != "3") tempLeft+=emptyLeft;
			} else {
				
				$(".author_right").css("background-color", "#fbf3f8");

				//서명 출력을 위한 처리
				var signPath = "/common/images/common/defaultRcv.gif";
				if( applList[i].agreeStatusCd != "" && applList[i].signYn =="Y") {
					if(applList[i].agreeStatusCd =="20") {
						signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun;
						if(applList[i].deputyYn =="Y" || applList[i].deputyName !=""){
							signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].deputySabun;
						}
					} else if(applList[i].agreeStatusCd =="30") {
						signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun;
						if(applList[i].deputyYn =="Y" || applList[i].deputyName !=""){
							signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].deputySabun;
						}
					} else {
						signPath  = signImgNo;
					}
				} else {
					if(applList[i].agreeStatusCd =="20") {
						signPath  = signImg20_3;
					} else if(applList[i].agreeStatusCd =="30") {
						signPath  = signImg30;
					} else {
						signPath  = signImgNo;
					}
				}

				var refAgreeYmd = "";
				var refSignPath = "";
				if(applList[i].deputyYn =="Y" || applList[i].deputyName !=""){
					refAgreeYmd = "";
					refSignPath = signImgNo;
				} else {
					refAgreeYmd = applList[i].agreeYmd;
					refSignPath = signPath;
				}

				tempRight+=authorLeft
					.replace(/#clsNm#/g,	"author")
					.replace(/#typeCdNm#/g,	applList[i].applTypeCdNm)
					.replace(/#orgNm#/g,	applList[i].agreeOrgNm)
					.replace(/#jikchakNm#/g,applList[i].agreeJikchakNm)
					.replace(/#sabun#/g,	applList[i].agreeSabun)
					.replace(/#title#/g,	applList[i].agreeSabun)
					.replace(/#name#/g,		applList[i].agreeName)
					.replace(/#ymd#/g,		refAgreeYmd)
					.replace(/#hms#/g,		applList[i].agreeHms)
					.replace(/#jikweeNm#/g,	applList[i].agreeJikweeNm)
					.replace(/#typeCd#/g,	applList[i].applTypeCd)
					.replace(/#agreeSeq#/g,	applList[i].agreeSeq)
					.replace(/#signPath#/g,	refSignPath)
				;

				//if(applList[i].deputyYn =="Y" || applList[i].deputyName !=""){
				if((applList[i].deputyYn =="Y" || applList[i].deputyName !="") && applList[i].orgAppYn == "N"){
					tempRight+=authorLeft
						.replace(/#clsNm#/g,	"author instead")
						//.replace(/#typeCdNm#/g,	applList[i].applTypeCdNm)
						.replace(/#typeCdNm#/g,	"대결")
						.replace(/#orgNm#/g,	applList[i].deputyOrgNm)
						.replace(/#jikchakNm#/g,applList[i].deputyJikchakNm)
						.replace(/#sabun#/g,	applList[i].deputySabun)
						.replace(/#title#/g,	applList[i].deputySabun)
						.replace(/#name#/g,		applList[i].deputyName)
						.replace(/#ymd#/g,		applList[i].agreeYmd)
						.replace(/#hms#/g,		applList[i].agreeHms)
						.replace(/#jikweeNm#/g,	applList[i].deputyJikweeNm)
						.replace(/#typeCd#/g,	applList[i].applTypeCd)
						.replace(/#agreeSeq#/g,	applList[i].agreeSeq)
						.replace(/#orgAppYn#/g,	applList[i].orgAppYn)
						.replace(/#signPath#/g,	signPath)
					;
					if( applList[i].memo != ""){
						tempMemo += memo
							.replace(/#orgNm#/g,applList[i].deputyOrgNm)
							.replace(/#jikchak#/g,applList[i].deputyJikchakNm)
							.replace(/#name#/g,applList[i].deputyEmpAlias)
							.replace(/#memo#/g,applList[i].memo)
						;
					}
				} else{
					if( applList[i].memo != ""){
						tempMemo += memo
							.replace(/#orgNm#/g,applList[i].agreeOrgNm)
							.replace(/#jikchak#/g,applList[i].agreeJikchakNm)
							.replace(/#name#/g,applList[i].agreeEmpAlias)
							.replace(/#memo#/g,applList[i].memo)
						;
					}
				}
				if(i != applList.length-1) tempRight+=emptyLeft;
			}
	    }
		$("#atleft").html(tempLeft);
		$("#atright").html(tempRight);
		$("#memoTable").append(tempMemo);

		if(memoShow) $("#memoTable").append(tempMemoInput);

		oriLeftSabun =  oriLeftSabun.substring(0, oriLeftSabun.length-1);

	}

	function chgApplPopup(){
		if(!isPopup()) {return;}

		var url 	= "${ctx}/ApprovalMgrResult.do?cmd=viewApprovalMgrResultChgApplPopup";
		var rv = openPopup(url,self,1200,750);
	}

	function chgApplReferPopup(){
		if(!isPopup()) {return;}

		var url 	= "${ctx}/ApprovalMgrResult.do?cmd=viewApprovalMgrResultChgReferPopup";
		var rv = openPopup(url,self,1200,750);
	}

	function getApplSeqForRefer(){
		return $("#searchApplSeq").val();
	}

	function chApplPopupRetrunPrc(sheet4,sheet5,debutyUserList,applCdList){
		var applTypeCd		= applCdList[1].split("|");
		var applTypeCdNm	= applCdList[0].split("|");
		var typeCdNm 		= "";
		var typeCd 			= "";
		var tempLeft		= "";
		var compareLeftSabun= "";
		var pCnt			= 0;
		var tempRefer		= "";
		for(var i=0; i<applList.length; i++){

			//서명 출력을 위한 처리
			var signPath = "/common/images/common/defaultApp.gif";
			if( applList[i].agreeStatusCd != "" && applList[i].signYn =="Y") {
				if(applList[i].agreeStatusCd =="20") {
					signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun;
				} else if(applList[i].agreeStatusCd =="30") {
					signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun;
				} else {
					signPath  = "";
				}
			} else {
				if(applList[i].agreeStatusCd =="20") {
					signPath  = signImg20_0;
				} else if(applList[i].agreeStatusCd =="30") {
					signPath  = signImg30;
				} else {
					signPath  = signImgNo;
				}
			}

			if( applList[i].gubun != "3") {

				tempLeft+=authorLeft
					.replace(/#clsNm#/g,	"author")
					.replace(/#typeCdNm#/g,	applList[i].applTypeCdNm)
					.replace(/#orgNm#/g,	applList[i].agreeOrgNm)
					.replace(/#jikchakNm#/g,applList[i].agreeJikchakNm)
					.replace(/#sabun#/g,	applList[i].agreeSabun)
					.replace(/#title#/g,	applList[i].agreeSabun)
					.replace(/#name#/g,		applList[i].agreeName)
					.replace(/#ymd#/g,		applList[i].agreeYmd)
					.replace(/#hms#/g,		applList[i].agreeHms)
					.replace(/#jikweeNm#/g,	applList[i].agreeJikweeNm)
					.replace(/#typeCd#/g,	applList[i].applTypeCd)
					.replace(/#agreeSeq#/g,	applList[i].agreeSeq)
					.replace(/#signPath#/g,		signPath)
				;
				compareLeftSabun += applList[i].agreeSabun+",";

				if(applList[i].deputyYn =="Y" || applList[i].deputyName !=""){
					tempLeft+=authorLeft
						.replace(/#clsNm#/g,	"author instead")
						.replace(/#typeCdNm#/g,	applList[i].applTypeCdNm)
						.replace(/#orgNm#/g,	applList[i].deputyOrgNm)
						.replace(/#jikchakNm#/g,applList[i].deputyJikchakNm)
						.replace(/#sabun#/g,	applList[i].deputySabun)
						.replace(/#title#/g,	applList[i].deputySabun)
						.replace(/#name#/g,		applList[i].deputyName)
						.replace(/#ymd#/g,		applList[i].agreeYmd)
						.replace(/#hms#/g,		applList[i].agreeHms)
						.replace(/#jikweeNm#/g,	applList[i].deputyJikweeNm)
						.replace(/#orgCd#/g,	applList[i].deputyaOrgCd)
						.replace(/#typeCd#/g,	applList[i].applTypeCd)
						.replace(/#agreeSeq#/g,	applList[i].agreeSeq)
						.replace(/#signPath#/g,	signPath)
					;
					compareLeftSabun += applList[i].deputySabun+",";
				}
			}
			sheet4.RowDelete(1, 0);
			if(applList[i].agreeStatusCd == "10" ) break;

			tempLeft+=emptyLeft;
	    }
		if(sheet4.RowCount()> 0 ) {tempLeft+=emptyLeft;}

		for(var i=1; i<sheet4.LastRow()+1; i++){

			typeCd 	= sheet4.GetCellValue(i,"applTypeCd");

			if(sheet4.GetCellValue(i,"applTypeCdNm") != ""){
				typeCdNm 	= sheet4.GetCellValue(i,"applTypeCd");
				typeCd 		= sheet4.GetCellValue(i,"applTypeCdNm");
			}else{
				for(var x=0; x<applTypeCd.length; x++){
					if(applTypeCd[x] == sheet4.GetCellValue(i,"applTypeCd")){
						typeCdNm=applTypeCdNm[x]; break;
					}
				}
			}

			//서명 출력을 위한 처리
			var signPath = "/common/images/common/defaultRcv.gif";
			if( applList[i].agreeStatusCd != "" && applList[i].signYn =="Y") {
				if(applList[i].agreeStatusCd =="20") {
					signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun;
				} else if(applList[i].agreeStatusCd =="30") {
					signPath  = "${ctx}/EmpPhotoOut.do?type=2&searchKeyword="+applList[i].agreeSabun;
				} else {
					signPath  = "";
				}
			} else {
				if(applList[i].agreeStatusCd =="20") {
					signPath  = signImg20_3;
				} else if(applList[i].agreeStatusCd =="30") {
					signPath  = signImg30;
				} else {
					signPath  = signImgNo;
				}
			}

			tempLeft+=authorLeft
				.replace(/#clsNm#/g,"author")
				.replace(/#typeCdNm#/g,	typeCdNm)
				.replace(/#agreeSeq#/g, sheet4.GetCellValue(i,"agreeSeq"))
				.replace(/#orgNm#/g,	sheet4.GetCellValue(i,"orgNm"))
				.replace(/#jikchakNm#/g,sheet4.GetCellValue(i,"jikchakNm"))
				.replace(/#sabun#/g,	sheet4.GetCellValue(i,"agreeSabun"))
				.replace(/#title#/g,	sheet4.GetCellValue(i,"agreeSabun"))
				.replace(/#name#/g,		sheet4.GetCellValue(i,"agreeName"))
				.replace(/#date#/g,		"")
				.replace(/#jikweeNm#/g,	sheet4.GetCellValue(i,"jikweeNm"))
				.replace(/#jikweeCd#/g,	sheet4.GetCellValue(i,"jikweeCd"))
				.replace(/#jikchakCd#/g,sheet4.GetCellValue(i,"jikchakCd"))
				.replace(/#orgCd#/g,	typeCd)
				.replace(/#typeCd#/g,	sheet4.GetCellValue(i,"applTypeCd"))
				.replace(/#ymd#/g,		sheet4.GetCellValue(i,"date"))
				.replace(/#hms#/g,		sheet4.GetCellValue(i,"hms"))
				.replace(/#signPath#/g,	signPath)
			;
			compareLeftSabun += sheet4.GetCellValue(i,"agreeSabun")+",";
			if(i != Number(sheet4.LastRow())) {tempLeft+=emptyLeft;}
	    } $("#atleft").html(tempLeft);


	    compareLeftSabun = compareLeftSabun.substring(0, compareLeftSabun.length-1);

	    if(compareLeftSabun != oriLeftSabun) leftSave = true;

		var referUser 	= "";
	    var referUserEtc= "";
	    var deli		= ",";
	    var jikchakTmp 	= "";
		for(var i=1; i<sheet5.LastRow()+1; i++){

			if(sheet5.GetCellValue(i,"addYn") != "Y") continue;

	    	referUser 	+= sheet5.GetCellValue(i,"orgNm");
	    	referUser 	+= " "+sheet5.GetCellValue(i,"name");
	    	referUser 	+= "("+sheet5.GetCellValue(i,"ccSabun")+") / ";

	    	referUserEtc+= sheet5.GetCellValue(i,"orgNm")+deli;
	    	referUserEtc+= sheet5.GetCellValue(i,"orgCd")+deli;
	    	referUserEtc+= sheet5.GetCellValue(i,"name")+deli;
	    	referUserEtc+= sheet5.GetCellValue(i,"ccSabun")+deli;
	    	referUserEtc+= sheet5.GetCellValue(i,"jikweeCd")+deli;
	    	referUserEtc+= sheet5.GetCellValue(i,"jikweeNm")+deli;

	    	if(sheet5.GetCellValue(i,"jikchakCd") == "") jikchakTmp = " "; else jikchakTmp = sheet5.GetCellValue(i,"jikchakCd");
	    	referUserEtc+= jikchakTmp+deli;

	    	if(sheet5.GetCellValue(i,"jikchakNm") == "") jikchakTmp = " "; else jikchakTmp = sheet5.GetCellValue(i,"jikchakNm");
	    	referUserEtc+= jikchakTmp+"@";
	    }

		referUser 		= referUser.substring(0, referUser.length-2);
	    referUserEtc 	= referUserEtc.substring(0, referUserEtc.length-1);

		tempRefer = referNew
			.replace(/#orgNm#/g,"${userInfo.orgNm}")
			.replace(/#jikchak#/g,"${userInfo.jikchakNm}"==""?"${userInfo.jikweeNm}":"${userInfo.jikchakNm}")
			.replace(/#name#/g,"${userInfo.name}")
			.replace(/#date#/g,"<fmt:formatDate value='${now}' pattern='yyyy.MM.dd' />")
			.replace(/#referUser#/g,referUser)
		;
		if(referUserEtc != ""){
			$("#referTr").remove();
			$("#referTable").append(tempRefer);
			$("#referUserNewEtc").val(referUserEtc);
			referSave = true;
		}else{
			$("#referTr").remove();
			$("#referUserNewEtc").val("");
			referSave = false;
		}
	}

	function chReferPopupRetrunPrc(sheet5){
		$(".delTr").remove();
		referList 	= ajaxCall("${ctx}/ApprovalMgrResult.do?cmd=getApprovalMgrResultTHRI125",		$("#authorForm").serialize(),false).DATA;
	    chgReferSaveList(referList);

	    return;

		var tempRefer	= "";
		var referUser 	= "";
	    var referUserEtc= "";
	    var deli		= ",";
	    var jikchakTmp 	= "";
		for(var i=1; i<sheet5.LastRow()+1; i++){
			if(sheet5.GetCellValue(i,"addYn") != "Y") continue;
			compareReferSabun += sheet5.GetCellValue(i,"ccSabun")+",";

	    	referUser 	+= sheet5.GetCellValue(i,"orgNm");
	    	referUser 	+= " "+sheet5.GetCellValue(i,"name");
	    	referUser 	+= "("+sheet5.GetCellValue(i,"ccSabun")+") / ";

	    	referUserEtc+= sheet5.GetCellValue(i,"orgNm")+deli;
	    	referUserEtc+= sheet5.GetCellValue(i,"orgCd")+deli;
	    	referUserEtc+= sheet5.GetCellValue(i,"name")+deli;
	    	referUserEtc+= sheet5.GetCellValue(i,"ccSabun")+deli;
	    	referUserEtc+= sheet5.GetCellValue(i,"jikweeCd")+deli;
	    	referUserEtc+= sheet5.GetCellValue(i,"jikweeNm")+deli;

	    	if(sheet5.GetCellValue(i,"jikchakCd") == "") jikchakTmp = " "; else jikchakTmp = sheet5.GetCellValue(i,"jikchakCd");
	    	referUserEtc+= jikchakTmp+deli;
	    	if(sheet5.GetCellValue(i,"jikchakNm") == "") jikchakTmp = " "; else jikchakTmp = sheet5.GetCellValue(i,"jikchakNm");
	    	referUserEtc+= jikchakTmp+"@";
	    }

		referUser 		= referUser.substring(0, referUser.length-2);
	    referUserEtc 	= referUserEtc.substring(0, referUserEtc.length-1);

		tempRefer = referNew
			.replace(/#orgNm#/g,"${userInfo.orgNm}")
			.replace(/#jikchak#/g,"${userInfo.jikchakNm}"==""?"${userInfo.jikweeNm}":"${userInfo.jikchakNm}")
			.replace(/#name#/g,"${userInfo.name}")
			.replace(/#date#/g,"<fmt:formatDate value='${now}' pattern='yyyy.MM.dd' />")
			.replace(/#referUser#/g,referUser)
		;
		if(referUserEtc != ""){
			$("#referTr").remove();
			$("#referTable").append(tempRefer);
			$("#referUserNewEtc").val(referUserEtc);
			referSave = true;
		}else{
			$("#referTr").remove();
			$("#referUserNewEtc").val("");
			referSave = false;
		}
	}

	function getInUserHtmlToPaser(){
		var paserArray = new Array(3);
		var str 		= "";
		var strDebuty 	= "";
		var deli		= ",";

		$('#atright>td>table').each(function(){
			var jikchakTmp = "";
			if( $(this).attr("class") == "author"){
				str += $(this).find("#hAgreeSeq").html()+deli;
				str += $(this).find("#hTypeCdNm").html()+deli;
				str += $(this).find("#hTypeCd").html()+deli;
				str += $(this).find("#hOrgNm").html()+deli;
				str += $(this).find("#hOrgCd").html()+deli;
				str += $(this).find("#hName").html()+deli;
				str += $(this).find("#hSabun").html()+deli;
				str += $(this).find("#hJikweeCd").html()+deli;
				str += $(this).find("#hJikweeNm").html()+deli;
				str += $(this).find("#orgAppYn").html()+deli;
				
				if($(this).find("#hJikchakNm").html() == "") jikchakTmp = " "; else jikchakTmp = $(this).find("#hJikweeNm").html();

				str += jikchakTmp;
				str 		+= "@";
			}else{
				strDebuty += $(this).find("#hSabun").html()+deli;
				strDebuty += $(this).find("#hJikweeNm").html()+deli;
				if($(this).find("#hJikchakNm").html() == "") jikchakTmp = " "; else jikchakTmp = $(this).find("#hJikweeNm").html();
				strDebuty += jikchakTmp+deli;
				strDebuty += $(this).find("#hOrgNm").html()+deli;
				strDebuty += $(this).find("#hAgreeSeq").html();
				strDebuty 	+= "@";
			}
		});

		str 			= str.substring(0, str.length-1);
		strDebuty		= strDebuty.substring(0, strDebuty.length-1);
		paserArray[0] = str;
		paserArray[1] = strDebuty;

		return paserArray;
	}

	function getApplHtmlToJson() {
		var data = {
			appls: [],
			deputys: [],
			inusers: [],
			refers: [],
		};

		const deputyInfo = $('#deputyInfo').val() == '' ? 
							null:{inSabun: $('#deputyInfo').val().split(',')[0]
						   		, inOrg: $('#deputyInfo').val().split(',')[1]
						   		, inJikchak: $('#deputyInfo').val().split(',')[2]
						   		, inJikwee: $('#deputyInfo').val().split(',')[3]};
						   		
		var author = {}; 
		$('#atleft > td > table').each(function() {
			if ( $(this).hasClass('author') ) {
				const seq = $(this).find("#hAgreeSeq").html();
				const typeCd = $(this).find("#hTypeCd").html();
				const gubun = typeCd == '30' ? '0':'1';

				if (agreeSeq == seq) {
					if (deputyInfo) {
						author = deputyInfo;
					} else {
						author['inSabun'] = $(this).find("#hSabun").html();
						author['inOrg'] = $(this).find("#hOrgNm").html();
						author['inJikchak'] = $(this).find("#hJikchakNm").html();
						author['inJikwee'] = $(this).find("#hJikweeNm").html();
						author['agreeSeq'] = $(this).find("#hAgreeSeq").html();
					}
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
				applTypeCd: $(this).find("#hTypeCd").html(),
				gubun: '3',
				org: $(this).find("#hOrgNm").html(),
				jikchak: $(this).find("#hJikchakNm").html(),
				jikwee: $(this).find("#hJikweeNm").html(),
				orgAppYn: $(this).find("#orgAppYn").html()
			});
		});

		

		if (referSave) {
			var refers = $("#referUserNewEtc").html() != '' ? $("#referUserNewEtc").html().split(deli2):[]; 
			data.refers = refers.map(str => {
					var t = str.split(deli);
					return {
						...author,
						agreeSeq: agreeSeq,
						referSabun: t[3],
						referOrg: t[0],
						referJickchak: t[7],
						referJicwee: t[5],
					};
				});
		}
	
		return data;
	}

	function getApplHtmlToPaser(){
		var paserArray = new Array(17);
		var str 		= "";
		var strDebuty 	= "";
		var deli		= ",";

		$('#atleft>td>table').each(function(){
			var jikchakTmp 	= "";
			var hAgreeSeq	= "";

			if( $(this).attr("class") == "author"){
				str += $(this).find("#hAgreeSeq").html()+deli;
				str += $(this).find("#hTypeCdNm").html()+deli;
				str += $(this).find("#hTypeCd").html()+deli;
				str += $(this).find("#hOrgNm").html()+deli;
				str += $(this).find("#hOrgCd").html()+deli;
				str += $(this).find("#hName").html()+deli;
				str += $(this).find("#hSabun").html()+deli;
				str += $(this).find("#hJikweeCd").html()+deli;
				str += $(this).find("#hJikweeNm").html()+deli;
				str += $(this).find("#orgAppYn").html()+deli;
				
				if($(this).find("#hJikchakCd").html() == "") jikchakTmp = " "; else jikchakTmp = $(this).find("#hJikchakCd").html();
				str += jikchakTmp+deli;

				if($(this).find("#hJikchakNm").html() == "") jikchakTmp = " "; else jikchakTmp = $(this).find("#hJikchakNm").html();
				str += jikchakTmp+deli;

				if($(this).find("#hAgreeSeq").html()!="" && Number($(this).find("#hAgreeSeq").html()) > Number(agreeSeq) ){
					str += " "+deli;
					str += " ";
				}else{
					str += $(this).find("#hDate").html()+deli;
					str += $(this).find("#hHms").html();
				}
				str += "@";

			}else{
				strDebuty += $(this).find("#hSabun").html()+deli;
				strDebuty += $(this).find("#hJikweeNm").html()+deli;

				if($(this).find("#hJikchakNm").html() == "") jikchakTmp = " "; else jikchakTmp = $(this).find("#hJikchakNm").html();

				strDebuty += jikchakTmp+deli;
				strDebuty += $(this).find("#hOrgNm").html()+deli;
				strDebuty += $(this).find("#hAgreeSeq").html();
				strDebuty 	+= "@";
			}
		});

		str 			= str.substring(0, str.length-1);

		if(strDebuty.length > 0) strDebuty		= strDebuty.substring(0, strDebuty.length-1);

		paserArray[4]	= str;
		paserArray[1]	= str.split("@");

		paserArray[5]	= $("#referUserOriEtc").val();
		paserArray[2]	= $("#referUserOriEtc").val().split("@");
		paserArray[9]	= $("#referUserNewEtc").val();
		paserArray[10]	= $("#referUserNewEtc").val().split("@");

		paserArray[6]	= strDebuty;

		paserArray[7]   = $("#searchSabun").val();

		paserArray[8]   = agreeSeq;
		paserArray[11]	= $("#searchApplSeq").val();
		paserArray[12]	= "${userInfo.sabun}";
		paserArray[13]	= "${userInfo.orgNm}";
		paserArray[14]	= "${userInfo.jikchakNm}";
		paserArray[15]	= "${userInfo.jikweeNm}";
		paserArray[16]	= referAgreeSeq;
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
				$("#authorFrame").height(h);
			}else{
				$("#authorFrame").height(ih);
			}
			iframeLoad = true;
		}catch(e){
			$("#authorFrame").height(ih);
			iframeLoad = true;
		}
	}

    function commentPopup(status){
		if(!iframeLoad){return alert("<msg:txt mid="alertFrameLoad" mdef="업무 화면이 로딩 되지 않았습니다.\n 로딩완료후 다시 시도 하십시오." />");}

		/* 근로시간단축 신청 */
		if("${searchApplCd}" == "300"){

			var rtn;

			if(status == 1){
				rtn = $("#authorFrame").get(0).contentWindow.adminDoSave2('0');
			}else{
				rtn = $("#authorFrame").get(0).contentWindow.adminDoSave2('2');
			}


			if(rtn == 0){
				hideOverlay();
				return;
			}
		}

		$("#agreeUserStatus").val(status);
		if( status == "0" ){
			$("#appCmtTitle").html("반려의견");
			$("#cmtBtn").html("반려");
		}else{
			$("#appCmtTitle").html("결재의견");
			$("#cmtBtn").html("결재");
		}

		$(".layer-cmt").show();
		$("#comment").focus();
		$("#comment").html("");
		
		/*
		if(!isPopup()) {return;}

		var url 	= "${ctx}/ApprovalMgrResult.do?cmd=viewApprovalMgrResultCommentPopup";
		var args 	= new Array();
        args["status"] = status;
		pGubun = "AppCommentPopup";
		var win	= openPopup(url,args,400,170);
		*/
	}

	function doSave(status){
		if(!iframeLoad){return alert("업무 화면이 로딩 되지 않았습니다.n 로딩완료후 다시 시도 하십시오!");}
		showOverlay(500);

		if(!setValue(status)){
			hideOverlay();
			return;
		}

		$("#agreeGubun").val(status);
		var saveUserArray 	= getApplHtmlToPaser();
		$("#applUserStr").val(	saveUserArray[4]);
		$("#referUserStr").val(	saveUserArray[9]);
		$("#deputyUserStr").val(saveUserArray[6]);
		var saveInUserArray = getInUserHtmlToPaser();
		$("#inUserStr").val(		saveInUserArray[0]);
		$("#deputyInUserStr").val(	saveInUserArray[1]);
		if(leftSave) 	$("#applSave").val("Save"); 	else $("#applSave").val("");
		if(referSave) 	$("#referSave").val("Save"); 	else $("#referSave").val("");
		$("#agreeSeq").val(agreeSeq);
		$("#authorForm>#fileSeq").val($("#uploadForm>#fileSeq").val());

		const param = {
				...formToJson($("#authorForm")),
				...getApplHtmlToJson()
			};

		var rtn = ajaxTypeJson("${ctx}/ApprovalMgrResult.do?cmd=saveApprovalMgrResult", param, false);
		if(rtn){
			var msg = "";
			if(Number(rtn.cnt) > 0 ){
				if(status == 1) {
					msg = "<msg:txt mid='alertOkAppl' mdef='결재 되었습니다.'/>";
				}
				else msg = "<msg:txt mid='alertRestoreOk' mdef='반려 되었습니다.'/>";
			}else{
				if(status == 1) msg = "<msg:txt mid='alertErrorAppl' mdef='결재 실패 하였습니다.'/>";
				else msg = "<msg:txt mid='alertErrorCompanion' mdef='반려 실패 하였습니다.'/>";
			}
			
			if(Number(rtn.cnt) > 0 ) {
				try{
					ajaxCall("${ctx}/Send.do?cmd=callMailAppl","applSeq="+$("#searchApplSeq").val()+"&applStatusCd="+status+"&firstDiv=N",false);
				}catch(e){
					alert("메일전송 중 오류가 발생 했습니다.");
				}
			}
			alert(msg);
		}

		hideOverlay();
        try { p.popReturnValue(); } catch (ex) { }
        setTimeout(function() { p.self.close(); }, 100);
	}

<c:if test="${adminYn=='Y'}">
	function adminDoSave(status){
		showOverlay(500);

		/* 근로시간단축 신청 */
		if("${searchApplCd}" == "300"){
			/* 결재처리중(근무시간 조정) */
			if($("#statusCd").val() == '21' || $("#statusCd").val() == '31'){
				var rtn = $("#authorFrame").get(0).contentWindow.adminDoSave2('1');

				if(rtn == 0){
					hideOverlay();
					return;
				}
			}
			/* 결재반려 */
			if($("#statusCd").val() == '23' || $("#statusCd").val() == '33'){
				var rtn = $("#authorFrame").get(0).contentWindow.adminDoSave2('2');

				if(rtn == 0){
					hideOverlay();
					return;
				}
			}
		}


		if(!setValue(status)){
			hideOverlay();
			return;
		}

		$("#agreeSeq").val(agreeSeq);
		var rtn = ajaxCall("${ctx}/ApprovalMgrResult.do?cmd=updateStatusCd",$("#authorForm").serialize(),false);

		if(Number(rtn.cnt) > 0) {
			alert( $("#statusCd option:selected").text()+" 되었습니다." );
			if($("#statusCd").val() == "99"){
				//ajaxCall("${ctx}/Send.do?cmd=callMailApp","applSeq="+$("#searchApplSeq").val()+"&applStatusCd="+$("#statusCd").val(),false);
			}
			/* 관리자는 상태를 마구 바꾸는 것이 가능하므로 메일 또는 SMS를 보내지 않는다, 다만 관리자가 한것도 모두 보내고 싶다면 아래 주석만 풀면 된다.  by JSG
			ajaxCall("${ctx}/Send.do?cmd=callSmsType2","applSeq="+$("#searchApplSeq").val(),false);
			ajaxCall("${ctx}/Send.do?cmd=callMailType4","applSeq="+$("#searchApplSeq").val(),false);
			*/
		}

		hideOverlay();

        try { p.popReturnValue(); } catch (ex) {  }
        setTimeout(function() { p.self.close(); }, 100);
	}
</c:if>
	function ReportPopup(width, height){
		if(!isPopup()) {return;}

		var w 					= width;
		var h 					= height;
		var url 				= "${ctx}/RdPopup.do";
		var args 				= new Array();
		var rdPath  			="${uiInfo.prtRsc}";

		args["rdTitle"] 		= "${uiInfo.applTitle}";// "신청서 명칭" ;//rd Popup제목
		args["rdMrd"] 			= rdPath ;//( 공통경로 /html/report/는 공통에서 처리)업무경로+rd파일명
		args["rdParam"] 		= "[${ssnEnterCd}] ["+$("#searchApplSeq").val()+"] ["+"${uiInfo.applTitle}"+"]" ;//rd파라매터

		args["rdParamGubun"] 	= "rp" ;//파라매터구분(rp/rv)
		args["rdToolBarYn"] 	= "Y" ;//툴바여부
		args["rdZoomRatio"] 	= "100" ;//확대축소비율

		args["rdSaveYn"] 		= "Y" ;//기능컨트롤_저장
		args["rdPrintYn"] 		= "Y" ;//기능컨트롤_인쇄
		args["rdExcelYn"] 		= "Y" ;//기능컨트롤_엑셀
		args["rdWordYn"] 		= "Y" ;//기능컨트롤_워드
		args["rdPptYn"] 		= "Y" ;//기능컨트롤_파워포인트
		args["rdHwpYn"] 		= "Y" ;//기능컨트롤_한글
		args["rdPdfYn"] 		= "Y" ;//기능컨트롤_PDF
		var rv = openPopup(url,args,w,h);
	}

	function cancelSave(){
		showOverlay(500);

		var rtn = ajaxCall("${ctx}/ApprovalMgrResult.do?cmd=updateCancelStatusCd","searchApplSeq=${searchApplSeq}&statusCd=11",false);
		if(Number(rtn.cnt) > 0 ) alert("신청서가 회수 되었습니다.");
		else	alert("신청서 회수 시 오류가 발생 했습니다.");

		hideOverlay();

        try { p.popReturnValue(); } catch (ex) {  }
        setTimeout(function() { p.self.close(); }, 100);
	}


	var pGubun = "";

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "AppCommentPopup"){
			if(rv["rtn"] == "ok") {
				setTimeout(function() {
					$("#agreeUserMemo").val(rv["comment"]);
					doSave(rv["status"]);
				}, 100);
			}
        }
	}	

	//신청서 인쇄
	function printPage(){
        var args = new Array();

        $("#printForm").append("<input type='hidden' id='prgCd' name='prgCd' value='" + "${ctx}${uiInfo.detailPrgCd}" + "' />");

        var winHeight = document.body.clientHeight; // 현재창의 높이
        var winWidth = document.body.clientWidth; // 현재창의 너비

        var winX = window.screenX || window.screenLeft || 0; // 현재창의 x좌표
        var winY = window.screenY || window.screenTop || 0; // 현재창의 y좌표

        var popX = winX + (winWidth - 900) / 2;
        var popY = winY + (winHeight - 900) / 2;

        globalWindowPopup = window.open("", "ApprovalMgrPrint", "width=815px,height=900px,top="+popY+",left="+popX+",scrollbars=no,resizable=yes,menubar=no");
        $("#printForm").attr({
        	"method": "post",
            "target": "ApprovalMgrPrint",
            "action": "/ApprovalMgr.do?cmd=viewApprovalMgrPrint"
        }).submit();
        globalWindowPopup.focus();


        return;
	}
	
	//결재의견 닫기
	function closePopCmt(){
		$(".layer-cmt").hide();
		$("#comment").html("");
		hideOverlay();
	}

	function returnCmtVal(){
		var returnValue = new Array(3);
		var tmp = replaceAll($("#comment").val(), "\n", "<br>");
		$("#agreeUserMemo").val(tmp);
		//$("#agreeUserMemo").val($("#comment").val());
		
		showOverlay(500);
		
		doSave($("#agreeUserStatus").val());
		closePopCmt();
	}

	/*
	 * 결재문서 재사용
	 */
	function reUse(){
		var param = "searchApplCd="+"${searchApplCd}"
					+"&searchApplSeq="+$("#searchApplSeq").val()
					+"&adminYn=N"
					+"&authPg=A"
					+"&searchSabun="+"${searchSabun}" // 신청 내용을 입력 하는 사람
					+"&searchApplSabun="+$("#searchApplSabun").val()	// 대상자 사번
					+"&searchApplYmd="+"${searchApplYmd}"
					+"&reUseYn=Y"
					+"&etc03="+"${etc03}"
					;
		var url ="/ApprovalMgr.do?cmd=viewApprovalMgr&"+param;
		location.replace(url);
	}
</script>



<body>
<div class="wrapper popup_scroll">
	<div class="popup_title">
		<ul>
			<li><span id="applTitle"></span></li>
            <li class="close"></li>
			</li>
		</ul>
	</div>

	<div class="popup_main" style="padding-top:0;">
		<div class="h10"></div>
        <div id="author_info">
			<div id="applBtnTop" class="popup_button" style="text-align:right;padding:0 0 10px 0;display:none;">
				<ul>
					<li>
						<!-- 
						<btn:a href="javascript:commentPopup('1');" 	css="pink large" mid='appl' id="appl" mdef="결재"/>
						<btn:a href="javascript:commentPopup('0');" 	css="gray large" mid='applCancel' id="applCancel" mdef="반려"/>
						 -->
					</li>
				</ul>
			</div>
        
        	<!-- 
			<div class="sheet_title">
				<ul>
					<span  style="float:left;margin-top:13px;"><tit:txt mid='112147' mdef='* 성명 컬럼에 마우스 오버시 해당 사번 확인 가능'/></span>
					<li class="btn">
						<a id="applChgBtn" href="javascript:chgApplPopup();" class="basic" style="display:none"><tit:txt mid='113557' mdef='결재선 변경'/></a>
					</li>
				</ul>
			</div>
			 -->
			<div class="author_left">
				<table>
					<tr id="atleft"> </tr>
				</table>
			</div>
			<div class="author_right">
				<table>
					<tr id="atright"> </tr>
				</table>
			</div>
		</div>
<!-- 		<div class="auto_info"> -->
<!-- 			<ul> -->
<!-- 				<li class="info_txt">* 성명, 날자컬럼에 마우스 오버 시 사번, 시간을 확인 하실 수 있습니다.<br/>* 결재라인 7명 이상 시 두줄형태로 배치됨니다.</li> -->
<!-- 				<li class="info_color"> -->
<!-- 					<span class="box_green"></span> 신청 -->
<!-- 					<span class="box_blue"></span> 대결 -->
<!-- 					<span class="box_aqua"></span> 담당. -->
<!-- 				</li> -->
<!-- 			</ul> -->
<!-- 		</div> -->

		<div class="clear"></div>
		<div class="sheet_title">
			<ul>
				<li class="txt"><tit:txt mid='201706090000001' mdef='신청자'/></li>
				<li class="btn">
					<a style="display:none;" href="javascript:ReportPopup('900',' 600');" class="basic rdPrint">Report인쇄</a>
					<a style="display:none;" href="javascript:printPage();" class="basic windowPrint">WEB인쇄</a>
				</li>
			</ul>
		</div>
            
		<div class="app_header">
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
					<td> ${userApplInfo.orgNm} </td>
					<th> 사번 </th>
					<td> ${userApplInfo.sabun} </td>
					<th><tit:txt mid='114252' mdef=' 성명 '/></th>
					<td> ${userApplInfo.name} </td>
				</tr>
			</table>
			<div class="h5"></div>
        </div>

		<!-- <div style="width:100%; text-align:right; margin-bottom:1px;">
			<a style="display:none;" href="javascript:ReportPopup('900',' 600');" class="basic rdPrint">Report인쇄</a>
			<a style="display:none;" href="javascript:printPage();" class="basic windowPrint">WEB인쇄</a>
		</div> -->
		<div class="h5"></div>
		<iframe id="authorFrame" name="authorFrame" frameborder="0" class="author_iframe" style="height:100px;"></iframe>
		
		<div id="uploadDiv" style="display:none">
			<%@ include file="/WEB-INF/jsp/common/popup/uploadMgrForm.jsp"%>
		</div>
		
		<table class="sheet_main" id="etcCommentDiv" style="display:none;">
		<tr>
			<td class="bottom outer">
				<div class="explain">
					<div class="title"><tit:txt mid='appInstruction' mdef='신청시 유의사항'/></div>
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
		<div class="h15"></div>
		<form id="srchFrm" name="form">
        	<div>
	            <input id="searchApplCd"    name="searchApplCd"     type="hidden" value="${searchApplCd}"/>
	            <input id="searchApplSeq"   name="searchApplSeq"    type="hidden" value="${searchApplSeq}"/>
			</div>  
	    
	    <!-- 의견달기 -->
	    <table class="sheet_main" id="trComments" style="display:none;">
			<tr>
				<td>
					<span id="spanTable"></span>

				</td>
			</tr>
        </table>
       </form>
		
		<div id="applBtn" class="popup_button popup_sub_button" style="display:none">
			<ul>
				<li>
					<btn:a href="javascript:commentPopup('1');" 	css="pink large" mid='111177' id="appl" mdef="결재"/>
					<btn:a href="javascript:commentPopup('0');" 	css="gray large" mid='110821' id="applCancel" mdef="반려"/>
				</li>
			</ul>
		</div>
		<form id="authorForm" name="form">
        	<div id="authorFormAttr">
				<input id="searchApplCd" 	name="searchApplCd" 	type="hidden" value="${searchApplCd}"/>
				<input id="searchApplSeq" 	name="searchApplSeq" 	type="hidden" value="${searchApplSeq}"/>
				<input id="searchApplSabun" name="searchApplSabun" 	type="hidden" value="${searchApplSabun}"/>
				<input id="adminYn" 		name="adminYn" 			type="hidden" value="${param.adminYn}"/>
				<input id="authPg" 			name="authPg" 			type="hidden" value="${authPg}"/>
				<input id="searchApplYmd" 	name="searchApplYmd" 	type="hidden" value="${searchApplYmd}"/>
				<input id="searchSabun" 	name="searchSabun" 		type="hidden" value="${searchSabun}"/>
	
				<input id="applUserStr" 	name="applUserStr" 		type="hidden" value=""/>
				<input id="deputyUserStr" 	name="deputyUserStr" 	type="hidden" value=""/>
				<input id="inUserStr" 		name="inUserStr" 		type="hidden" value=""/>
				<input id="deputyInUserStr" name="deputyInUserStr" 	type="hidden" value=""/>
				<input id="referUserStr" 	name="referUserStr" 	type="hidden" value=""/>
				<input id="applStatusCd" 	name="applStatusCd" 	type="hidden" value="${applMasterInfo.applStatusCd}"/>
				<input id="fileSeq"			name="fileSeq"			type="hidden" value=""/>
				<input id="agreeSeq"		name="agreeSeq"			type="hidden" value=""/>
				<input id="agreeGubun"		name="agreeGubun"		type="hidden" value=""/>
				<input id="referUserOriEtc"	name="referUserOriEtc"	type="hidden" value=""/>
				<input id="referUserNewEtc"	name="referUserNewEtc"	type="hidden" value=""/>
				<input id="applSave" 		name="applSave" 		type="hidden" value=""/>
				<input id="referSave" 		name="referSave" 		type="hidden" value=""/>
				<input id="pathSeq" 		name="pathSeq" 			type="hidden" value=""/>
				<input id="gubun" 			name="gubun" 			type="hidden" value="${gubun}"/>
				<input id="procExecYn"      name="procExecYn"       type="hidden" value="${uiInfo.procExecYn}"/>
		        <input id="afterProcStatusCd"name="afterProcStatusCd"type="hid
		        den" value="${applMasterInfo.applStatusCd}"/> <!-- 이전신청서 상태코드  2020.01.14 -->
		        
				<input id="etc01"			name="etc01"			type="hidden" value="${etc01}"/>
				<input id="etc02"			name="etc02"			type="hidden" value="${etc02}"/>
				<input id="etc03"			name="etc03"			type="hidden" value="${etc03}"/>
	
				<input id="deputyInfo"		name="deputyInfo"		type="hidden" value=""/>
				<input id="agreeUserStatus"	name="agreeUserStatus"	type="hidden" value=""/> <!-- 결재/반려 여부 -->
				
	            <input id="applYn"          name="applYn"           type="hidden" value="${applYn}"/> <!-- 현 결재자와 세션사번이 같은지 여부 -->
			</div>
<!--
			<div class="sheet_title">
				<ul id="commentDiv">
					<li class="txt"><tit:txt mid='104446' mdef='결재의견'/></li>
				</ul>
			</div>
-->
			<table id="memoTable" border="0" cellpadding="0" cellspacing="0" class="settle mat20">
				<colgroup>
					<col width="25%" />
					<col width="75%" />
				</colgroup>
			</table>

			<div id="refDiv" class="sheet_title mat10">
				<ul>
					<li class="txt">수신참조 내역
						<a id="addChgBtn" href="javascript:chgApplPopup();" class="cute_basic" style="display:none"><tit:txt mid='112153' mdef='추가/변경'/></a>
						<a id="addReferBtn" href="javascript:chgApplReferPopup();" class="cute_basic" style="display:none"><tit:txt mid='112153' mdef='추가/변경'/></a>
					</li>
				</ul>
			</div>

			<table id="referTable" border="0" cellpadding="0" cellspacing="0" class="settle mat10">
				<colgroup>
					<col width="20%" />
					<col width="80%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='113912' mdef='권한추가자'/></th>
					<th><tit:txt mid='112372' mdef='참조자'/></th>
				</tr>
			</table>
			
			<table id="statusTable" border="0" cellpadding="0" cellspacing="0" class="settle mat10" style="display:none">
				<colgroup>
					<col width="15%" />
					<col width="85%" />
				</colgroup>
				<tr>
					<th><tit:txt mid='112999' mdef='결재상태'/></th>
					<td>
						<select id="statusCd" name="statusCd" >
						</select>
					</td>
				</tr>
			</table>

			<div id="" class="popup_button notPrint">
				<ul>
					<li>
						<a id="cancelBtn" href="javascript:cancelSave();" class="pink large" style="display:none">회수</a>
						<a id="reUseBtn" href="javascript:reUse();" class="pink large" style="display:none">재사용</a>
						<a id="adminBtn" href="javascript:adminDoSave(3);" class="pink large" style="display:none"><tit:txt mid='104476' mdef='저장'/></a>
						<a href="javascript:/*p.popReturnValue();*/ p.self.close();" class="gray large"><tit:txt mid='104157' mdef='닫기'/></a>
					</li>
				</ul>
			</div>
		</form>
	</div>
</div>

<form id="printForm" name="printForm"></form>
<!-- 결재의견 팝업 -->
<div class="layer-cmt layer-pop-back"></div>
<div class="layer-cmt layer-pop-body" style="top:50%; height:200px;margin-top:-100px;">
	<div class="layer-pop-body-div" style="width:450px; height:220px;margin-left:-200px;">

		<div class="popup_title">
			<ul>
				<li id="appCmtTitle">결재의견</li>
				<li class="close2" onclick="closePopCmt()"></li>
			</ul>
		</div>
		<div style="padding:20px; background-color:#FFF; ">
			<form id="popFrm" name="popFrm" >
			<table class="default">
			<tr>
				<td class="content">
					<textarea id="comment" name="comment" rows="3" class="${textCss} w100p"></textarea>
				</td>
			</tr>
			</table>
			</form>
			<div class="popup_button">
				<ul>
					<li>
						<btn:a id="cmtBtn" href="javascript:returnCmtVal();" mid="ok" mdef="확인" css="pink large"/>
						<btn:a href="javascript:closePopCmt();" mid="close" mdef="닫기" css="gray large"/>
					</li>
				</ul>
			</div>
		</div>
	</div>
</div>

</body>
</html>
