<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html class="">
<head>
	<base target="_self" />
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<title><tit:txt mid='113563' mdef='게시판 조회'/></title>
	<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<link href="${ctx}/common/css/ckeditor.css" rel="stylesheet">
	<link href="${ctx}/common/css/ckeditor5.css" rel="stylesheet">
	<%
		request.setAttribute("uploadType", "board001");
	%>
	<script type="text/javascript">
		$(function(){

			$("#burl").val("${map.burl}");
			$("#bbsSeq").val("${map.bbsSeq}");
			$("#saveType").val("${map.saveType}");
			$("#bbsCd").val("${map.bbsCd}");

			htmlLoad();

			//파일첨부
			if("${map.fileYn}" === "Y" ) {
				initFileUploadIframe("boardReadUploadForm", $("#fileSeq").val(), "board001", "${authPg}");
			}
			//이전 다음
// 	if($("#prevSeq").val()==""){$('#prev').hide();}
// 	if($("#nextSeq").val()==""){$('#next').hide();}

			//첨부파일 버튼 숨김
			$('.btn table').hide();

			divHeight();
<c:if test="${map.commentYn == 'Y'}">
			doAction1("CmtSearch");
</c:if>
		});


		//본문높이
		function divHeight(){
			//var Cheight = $(window).height()- ("${map.minusHeight}");
			//$('#contents').css({'height':Cheight+'px'});
		}


		function htmlLoad(){
			// 입력 폼 값 셋팅
			var data = ajaxCall("${ctx}/Board.do?cmd=getBoardContent",$("#srchFrm").serialize(),false);

			$("#title").text(data.boMap.title);
			$("#regName").html(data.boMap.name);
			$("#regDate").html(data.boMap.regDate);
			$("#contents").html(data.boMap.contents);
			$("#fileSeq").val(data.boMap.fileSeq);
			$("#notifyTerm").html(data.boMap.notifyTerm);

			//공지여부가 Y일때
			if("${map.notifyYn}"!="Y" ){
				$('#notifyTermTr').hide();
			}

			//if(data.map.name=="${sessionScope.ssnSabun}"){
			ajaxCall("${ctx}/Board.do?cmd=viewMileageMgr",$("#srchFrm").serialize(),false);
			//}

		}


		//Sheet1 Action
		function doAction1(sAction) {
			switch (sAction) {
				case "List":
					submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=getListBoard");
					break;
					<c:if test="${map.checkYn=='Y'}">
				case "Delete":
					if (!confirm("<msg:txt mid="alertDelete" mdef="삭제하시겠습니까?"/>"))
						return;

					$("#saveType").val("delelte");
					submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=delBoard");
					break;
				case "Edit":
					$("#saveType").val("update");
					submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardWrite");
					break;
					</c:if>
				case "Reply":
					$("#saveType").val("reply");

					submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardWrite");
					break;
				case "Prev":
					$("#saveType").val("select");
					$("#bbsSeq").val($("#prevSeq").val());
					submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardRead");
					break;
				case "Next":
					$("#saveType").val("select");
					$("#bbsSeq").val($("#nextSeq").val());
					submitCall($("#srchFrm"),"_self","POST","${ctx}/Board.do?cmd=viewBoardRead");
					break;
<c:if test="${map.commentYn == 'Y'}">
				case "CmtSearch":
					$("#tdComments tr").remove();
					var cmtData = ajaxCall("${ctx}/Board.do?cmd=getCmtList",$("#srchFrm").serialize(),false);
					if (cmtData != null && cmtData.DATA != null) {
						for(var j = 0; j < cmtData.DATA.length; j++) {
							var empAlias = cmtData.DATA[j].empAlias;
							var sabun = cmtData.DATA[j].sabun;
							var comments = cmtData.DATA[j].comments;
							var comments_seq = cmtData.DATA[j].commentsSeq;
							var chkdate = cmtData.DATA[j].chkdate;
							let cmtRow =
									$(`<tr style=\"height:25px\" data-seq=\"${'${comments_seq}'}\">
								           <td class='center'><a name=\"commentDel\" href=\"#\" onclick='profilePopup(\"${'${sabun}'}\")' class='center tBlue'>${'${empAlias}'}</a></td>
								           <td style=\"background:#fff;\" name=\"comment\"></td>
								       </tr>`);

							if (sabun == "${sessionScope.ssnSabun}") {
								cmtRow.append(`<td class='tBlue'>${'${chkdate}'}&nbsp;&nbsp;&nbsp;<a name=\"commentDel\" href=\"javascript:DelCmt('${'${comments_seq}'}')\" onclick='' class='button7'><img src='/common/images/icon/icon_basket.png'/></a></td>`);
							} else {
								cmtRow.append(`<td class='tBlue'>${'${chkdate}'}</td>`);
							}
							$("#tdComments").append(cmtRow);
							$("#tdComments tr[data-seq=" + comments_seq + "]").find("td[name=comment]").text(comments);
						}
					}

					break;
				case "CmtSave":

					$("#comments").val($("#comments").val().replace(/\n/gi,"<br>"));
					const cmtRet = ajaxCall("${ctx}/Board.do?cmd=saveCmt",$("#srchFrm").serialize()+"&"+$("#cmtFrm").serialize(),false);
					if (cmtRet.code > 0) {
						$("#comments").val("");
						doAction1("CmtSearch");
					} else {
						const msg = cmtRet.message ? cmtRet.message : "덧글 저장에 실패하였습니다.";
						alert(msg);
					}
					break;
</c:if>
			}
		}

<c:if test="${map.commentYn == 'Y'}">
		function DelCmt(cmtSeq) {
			if(confirm("덧글을 삭제하시겠습니까?")) {
				ajaxCall("${ctx}/Board.do?cmd=delCmt&commentsSeq="+cmtSeq,$("#srchFrm").serialize(),false);
				doAction1("CmtSearch");
			} else {
				return;
			}
		}
</c:if>

		function profilePopup(paramSabun){
			isPopup()
			var w 		= 610;
			var h 		= 260;
			var url 	= "${ctx}/EmpProfilePopup.do?cmd=viewEmpProfile&authPg=${authPg}";
			var args 	= new Array();
			args["sabun"] 		= paramSabun;
			var rv = openPopup(url,args,w,h);
		}


	</script>
</head>

<body class="">
<c:set value="N" var="fileBtn"/>
<div class="wrapper">
	<table class="sheet_main" id=main>
		<tr>
			<td>
				<div class="inner">
					<c:if test="${map.referer=='List'}">
						<div class="sheet_title">
							<ul>
								<li id="txt" class="txt"> ${map.bbsNm}</li>

								<li class="btn">
									<!-- Sort 변경으로 일반게시판과 다름
								<a href="javascript:doAction1('Prev')" 	 id="prev"	 class="basic authA"><tit:txt mid='113564' mdef='이전'/></a>
								<a href="javascript:doAction1('Next')" 	 id="next"	 class="basic authA"><tit:txt mid='112495' mdef='다음'/></a>
								<a href="javascript:doAction1('Reply')"  id="Reply"  class="basic"><tit:txt mid='113916' mdef='답글'/></a>
								-->
									<c:if test="${map.checkYn=='Y'}">
										<c:set var="authPg"	value="A" />
										<btn:a href="javascript:doAction1('Delete')" id="del" 	 css="basic" mid='110763' mdef="삭제"/>
										<btn:a href="javascript:doAction1('Edit')" 	 id="111372" 	 css="basic" mid='edit' mdef="수정"/>
									</c:if>
									<btn:a href="javascript:doAction1('List')" 	 			 css="basic" mid='110938' mdef="목록"/>
								</li>

							</ul>
						</div>
					</c:if>
				</div>

				<form id="srchFrm" name="srchFrm" >


					<input type=hidden id="burl" name="burl"	>
					<input type=hidden id="saveType"    	name="saveType"	>
					<input type=hidden id="bbsCd" 	  		name="bbsCd">
					<input type=hidden id="bbsSeq"	  		name="bbsSeq">

					<!--
                                    <input type=hidden id="authPg" 	  		name="authPg">
                                    <input type=hidden id="depth"      		name="depth">
                    -->
					<!--

                    -->
					<!--
                                    <input type=hidden id="priorBbsSeq"		name="priorBbsSeq">
                                    <input type=hidden id="masterBbsSeq"	name="masterBbsSeq">
                                    <input type=hidden id="bbsSort"   name="bbsSort">

                                    <input type=hidden id="prevSeq"   name="prevSeq">
                                    <input type=hidden id="nextSeq"   name="nextSeq">
                    -->
					<input type="hidden" id="fileSeq"   name="fileSeq">

					<table class="table" style="table-layout:fixed">
						<colgroup>
							<col width="15%" />
							<col width="35%" />
							<col width="15%" />
							<col width="35%" />
						</colgroup>
						<tr>
							<th class="center"><tit:txt mid='113562' mdef='제목${msg}'/></th>
							<td colspan=3 id="title" style="background:#fff;"></td>
						</tr>

						<tr <c:if test="${map.contactYn!='Y'}">style="display:none"</c:if>>
							<th class="center"><tit:txt mid='manager' mdef='담당자'/></th>
							<td colspan=3 id="contact" style="background:#fff;"></td>
						</tr>

						<tr>
							<th class="center"><tit:txt mid='113375' mdef='작성자'/></th>
							<td id="regName" style="background:#fff;"></td>
							<th class="center"><tit:txt mid='112163' mdef='작성일시'/></th>
							<td id="regDate" style="background:#fff;"></td>
						</tr>
						<tr id="notifyTermTr">
							<th class="center"><tit:txt mid='113374' mdef='공지기간'/></th>
							<td id="notifyTerm" colspan="3" style="background:#fff;"></td>
						</tr>

						<%--	CkEditor Setting : class="ck-content"	--%>
						<tr>
							<th class="center"><tit:txt mid='104429' mdef='내용'/></th>
							<td colspan=3 style="background:#fff;vertical-align: top;" height="550;">
								<div id="contents" class="ck-content" style="overflow:auto;"></div>
							</td>
						</tr>
						<tr class="hide" style="display:none;">
							<%-- <tr <c:if test="${map.tagYn!='Y'}">style="display:none""</c:if>> --%>
							<!-- <th class="center">Tag</th> -->
							<td colspan=3 id="boardTag" style="background:#fff;"></td>
						</tr>

					</table>
				</form>
				<div  style="clear:both;overflow:hidden;<c:if test="${map.fileYn!='Y'}">display:none</c:if>" >
					<iframe id="boardReadUploadForm" name="boardReadUploadForm" frameborder="0" class="author_iframe" style="height:200px;"></iframe>
				</div>

			</td>
		</tr>

<c:if test="${map.commentYn == 'Y'}">
		<tr id="trComments">
			<td><br>
				<table class="table">
					<colgroup>
						<col width="15%" />
						<col width="70%" />
						<col width="15%" />
					</colgroup>
					<tr>
						<th class='center' style="border:1px solid #ebeef0;">덧글달기</td>
						<th style="border:1px solid #ebeef0;">
							<form id="cmtFrm" name="cmtFrm" >
								<textarea id="comments" name="comments" rows="3" style="width:100%"></textarea>
							</form>
						</th>
						<th class='center middle' style="border:1px solid #ebeef0;">
							<span><btn:a href="javascript:doAction1('CmtSave')" css="basic large" mid='111526' mdef="덧글등록"/></span>
						</th>
					</tr>
					<tr>
						<th colspan="3" align='center'>
							<table id="tdComments" class='default' style='margin-bottom:2px' >
								<colgroup>
									<col width="10%"/>
									<col width="70%"/>
									<col width="15%"/>
								</colgroup>
							</table>
						</th>
					</tr>
				</table>
			</td>
		</tr>
</c:if>
	</table>
</div>
<div id="hiddenContent" Style="display:none">

</div>
<c:remove var="fileBtn"/>
</body>
</html>