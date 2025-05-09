<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html> <html><head> <title><tit:txt mid='104037' mdef='워크플로우관리'/></title>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
<style type="text/css">
.w15p {width:15% !important}
.w20p {width:20% !important}
.w30p {width:30% !important}
#wrapSub {width:auto;height:100%;/*;background:#f5f5f5;border:1px solid #e9eaec;padding:10px*/}
.wrap_Htable {overflow:hidden;border:0px solid #b8c6cc}
table.Htable th {color:#fff;font-size:14px;font-weight:bold;text-align:left; letter-spacing:-1px;line-height:15px;padding:14px 20px 8px 12px;padding:13px 19px 9px 11px/9;height:46px;}
table.Htable th.process {position:relative;width:195px;background:#57cdd1 url(/common/images/sub/ico_arrow2.png) 97% center no-repeat;border-radius:12px; border: none;}
table.Htable th.arrow {width:10px;padding:0;padding:0/9/*background:url(/common/images/sub/img_process_arrow.png) center center no-repeat*/; border: none;}
table.Htable th.process div {position:absolute; left:12px; top:8px;}
/*table.Htable th.process span {display:none}*/
div.step1 { display:inline-block;width:45px;height:12px;background:url(/common/images/sub/txt_step01.png) no-repeat}
div.step2 { display:inline-block;width:45px;height:12px;background:url(/common/images/sub/txt_step02.png) no-repeat}
div.step3 { display:inline-block;width:45px;height:12px;background:url(/common/images/sub/txt_step03.png) no-repeat}
div.step4 { display:inline-block;width:45px;height:12px;background:url(/common/images/sub/txt_step04.png) no-repeat}
div.step5 { display:inline-block;width:45px;height:12px;background:url(/common/images/sub/txt_step05.png) no-repeat}
div.step6 { display:inline-block;width:45px;height:12px;background:url(/common/images/sub/txt_step06.png) no-repeat}
div.step7 { display:inline-block;width:45px;height:12px;background:url(/common/images/sub/txt_step07.png) no-repeat}
div.step8 { display:inline-block;width:45px;height:12px;background:url(/common/images/sub/txt_step08.png) no-repeat}
div.step9 { display:inline-block;width:45px;height:12px;background:url(/common/images/sub/txt_step09.png) no-repeat}
div.step10 { display:inline-block;width:45px;height:12px;background:url(/common/images/sub/txt_step10.png) no-repeat}
table.Gtable {width:100%;border-right:1px solid #dae1e6;border-bottom:1px solid #dae1e6;}
table.Gtable th {color:#333;text-align:center;background:#ebeef0;border-left:1px solid #dae1e6;border-top:1px solid #dae1e6;font-weight:normal;padding:6px 9px 6px 9px;padding:7px 9px 7px 9px/9}
table.Gtable td {background:#f7f9fc;border-left:1px solid #dae1e6;border-top:1px solid #dae1e6;padding:3px 4px 3px 4px;padding:4px 4px 4px 4px/9}
table.Gtable td.first {color:#667780;font-weight:bold;background:#eef1f3}
table.Gtable td a {text-decoration:none;color:#21aabb}
table.Gtable td a:focus, a:active {text-decoration:none;color:#666}
table.Gtable td a:hover {text-decoration:underline;color:#21aabb}
table.Gtable td input {margin:1px 0}
.textArea {line-height:18px;border:1px solid #eef1f3;background:#fafcfd;padding:15px;}
</style>

<script type="text/javascript">

	$(function() {
		$("#surl").val(parent.$("#surl").val());

		var workflowProCdList = convCode(ajaxCall("${ctx}/CommonCode.do?cmd=getCommonNSCodeList", "queryId=getWorkflowProCdList", false).codeList, "");
		$("#searchProCd").html(workflowProCdList[2]);

		$("#searchProCd").on("change", function(e) {
			setContents();
		})

		setContents();
	});

	function setContents() {

		$("#contents").html("");
		$("#trProcess").html("");
		$("#tableProgram").html("");

		var prgData = ajaxCall("${ctx}/Workflow.do?cmd=getWorkflowViewPrgList",$("#workflowFrm").serialize(),false);
		var contData = ajaxCall("${ctx}/Workflow.do?cmd=getWorkflowMap",$("#workflowFrm").serialize(),false);
		var contents = "";

		if(contData.map == null){
			$("#contents").html("");
			$("#trProcess").html("");
			$("#tableProgram").html("");
		} else {
			contents = contData.map.contents;
			$("#contents").html(contents);

			if(prgData.DATA != null) {
				var prgList = prgData.DATA;
				var subProList = [];
				var convPrgList = [];

				var pushCnt = 0;
				$(prgList).each(function(index,obj) {
					if($.inArray(obj.subProCd, subProList) === -1) {
						subProList.push(obj.subProCd);
						convPrgList.push(
							{
								"subProCd":obj.subProCd
								, "subProNm":obj.subProNm
								, "subProMemo":obj.subProMemo
								, "prgList":[]
							}
						);
						pushCnt++;
					}
					convPrgList[pushCnt-1].prgList.push(obj);
				});

				var templateProcess1 = "\n<th class='process' title='#subProMemo#'><div class='step#stepIndex#'></div>#subProNm#</th>";
				var templateProcess2 = "\n<th class='arrow'></th><th class='process' title='#subProMemo#'><div class='step#stepIndex#'></div>#subProNm#</th>";
				var templateProgram1 = "\n<tr>"
					+ "<td class='w15p center first' rowspan='#prgLen#'>#subProNm#</td>"
					+ `<td class='w20p'><a href='javascript:window.top.goOtherSubPage("", "", "", "", "#prgCd#")'>#prgNm#</a></td>`
					+ "<td>#prgMemo#</td>"
					+ "</tr>";
				var templateProgram2 = "\n<tr>"
					+ `<td class='w20p'><a href='javascript:window.top.goOtherSubPage("", "", "", "", "#prgCd#")'>#prgNm#</a></td>`
					+ "<td>#prgMemo#</td>"
					+ "</tr>";

				var htmlProcess = "";
				var htmlProgram = "";
				$(convPrgList).each(function(index, obj) {
					if(index == 0) {
						htmlProcess = templateProcess1.replace(/\#subProNm\#/g, obj.subProNm.replace(/\n/gi,"<br>"))
									.replace(/\#subProMemo\#/g, obj.subProMemo)
									.replace(/\#stepIndex\#/g, index+1);
					} else {
						htmlProcess += templateProcess2.replace(/\#subProNm\#/g,obj.subProNm.replace(/\n/gi,"<br>"))
									.replace(/\#subProMemo\#/g, obj.subProMemo)
									.replace(/\#stepIndex\#/g, index+1);
					}

					htmlProgram += templateProgram1.replace(/\#prgLen\#/g,obj.prgList.length)
								.replace(/\#subProNm\#/g, obj.subProNm.replace(/\n/gi,"<br>"))
								.replace(/\#prgCd\#/g, obj.prgList[0].prgCd)
								.replace(/\#prgNm\#/g, obj.prgList[0].prgNm.replace(/\n/gi,"<br>"))
								.replace(/\#prgMemo\#/g, obj.prgList[0].prgMemo.replace(/\n/gi,"<br>"));

					for(var i = 1; i < obj.prgList.length; i++) {
						htmlProgram += templateProgram2.replace(/\#subProNm\#/g,obj.subProNm.replace(/\n/gi,"<br>"))
									.replace(/\#prgCd\#/g, obj.prgList[i].prgCd)
									.replace(/\#prgNm\#/g, obj.prgList[i].prgNm.replace(/\n/gi,"<br>"))
									.replace(/\#prgMemo\#/g, obj.prgList[i].prgMemo.replace(/\n/gi,"<br>"));
					}

				});

				$("#trProcess").append(htmlProcess);
				$("#tableProgram").append(htmlProgram);

			}
		}
	}

	function goPage(prgCd) {

		$("#prgCd").val(prgCd);
		var prgData = ajaxCall("${ctx}/Workflow.do?cmd=getWorkflowOpenPrgMap",$("#workflowFrm").serialize(),false);

		if(prgData.map == null) {
			alert("<msg:txt mid='109611' mdef='권한이 없거나 존재하지 않는 메뉴입니다.'/>");
			return;
		}

		var lvl 		= prgData.map.lvl;
		//var mainMenuCd 	= prgData.map.mainMenuCd;
		//var priorMenuCd = prgData.map.priorMenuCd;
		//var menuCd 		= prgData.map.menuCd;
		//var menuSeq 	= prgData.map.menuSeq;
		//var grpCd 		= prgData.map.grpCd;
		//var type	 	= prgData.map.type;
		var menuNm 		= prgData.map.menuNm;
		var menuNmPath	= prgData.map.menuNmPath;
		var prgCd 		= prgData.map.prgCd;
		//var srchSeq	    = prgData.map.srchSeq;
		//var dateTrackYn = prgData.map.dateTrackYn;
		var mainMenuNm 	= prgData.map.mainMenuNm;
		//var popupUseYn 	= prgData.map.popupUseYn;
		//var dataRwType 	= prgData.map.dataRwType;
		//var cnt 		= prgData.map.cnt;
		//var dataPrgType	= prgData.map.dataPrgType;
		//var helpUseYn	= prgData.map.helpUseYn;
		//var myMenu      = prgData.map.myMenu;
		var surl      	  = prgData.map.surl;

		var location = "";

		$(menuNmPath.split(">")).each(function(index, value) {
			if(lvl == 1) {
				location = mainMenuNm+" > <span>"+value+"</span>";
			} else if(lvl > 1) {
				if(index == 0) {
					location = mainMenuNm+" > "+value;
				} else if(lvl-1 == index) {
					location += " > <span>"+value+"</span>";
				} else {
					location += " > "+value;
				}
			}
		});
		parent.openContent(menuNm,prgCd,location,surl)
	}

</script>
</head>
<body>
<div id="wrapSub">

	<form id="workflowFrm" name="workflowFrm" >
	<input type=hidden name=surl id=surl value="${param.surl}">
	<input type=hidden name=prgCd id=prgCd>

	<div class="inner">
		<div class="sheet_title">
			<ul>
				<li class="txt">업무종류&nbsp;&nbsp;<select id="searchProCd" name="searchProCd"></select> </li>
			</ul>
		</div>
	</div>

	<div id="topLine" class="wrap_Htable">
		<table border="0" cellpadding="0" cellspacing="0" class="Htable"><tr id="trProcess"></tr></table>
	</div>
	<!-- CONTENTs:START -->
	<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
	<tr>
		<td>

			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='104328' mdef='프로그램설명'/></li>
				</ul>
				</div>
			</div>
			<!-- Sheet:START -->
            <table id="tableProgram" border="0" cellspacing="0" cellpadding="0" class="Gtable">
            <tr>
            	<th class="w15p"><tit:txt mid='103997' mdef='구분'/></th>
                <th class="w20p"><tit:txt mid='104233' mdef='메뉴명'/></th>
                <th><tit:txt mid='timWorkCount2' mdef='설명'/></th>
            </tr>
            </table>
            <!-- //Sheet:END -->

            <div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt"><tit:txt mid='104532' mdef='기타설명'/></li>
				</ul>
				</div>
			</div>
			<!-- TextArea:START -->
           	<div class="textArea" id="contents">
           	</div>
            <!-- TextArea:END -->

		</td>
	</tr>
	</table>
	</form>
	<!-- CONTENTs:END -->

</div>

</body>
</html>
