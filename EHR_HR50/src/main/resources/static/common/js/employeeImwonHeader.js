var userSabun 	= "";
var enterCd 	= "";

var headerInfoList;
var hiddenInfoList;

$(function() {

	/*EmployeeHeader컬럼 구성정보 2015.03.20 Kosh*/
	headerInfoList = ajaxCall("/Employee.do?cmd=employeeHeaderColInfo",$("#empForm").serialize(),false);
	if(headerInfoList.DATA != null && headerInfoList.DATA != "undefine") headerInfoList = headerInfoList.DATA;
	hiddenInfoList = ajaxCall("/Employee.do?cmd=employeeHiddenInfo",$("#empForm").serialize(),false);
	if(hiddenInfoList.DATA != null && hiddenInfoList.DATA != "undefine") hiddenInfoList = hiddenInfoList.DATA;

	getUser();
	var inputId = "searchKeyword";
	var url = "/Employee.do?cmd=employeeImwonList";
	var formId = "empForm";
	initEmployeeHeader(inputId,url,formId,employeeResponse,employeeReturn);

	/*	EmployeeHeader 에서 읽기/쓰기 권한과 관계 없이 권한범위에 따라 사원을 조회 할 수 있어야 함, 추후 논의 필요. CBS, 2014-01-19
	if(comBtnAuthPg=="R"){
		$("#searchKeyword").addClass("transparent");
		$("#searchKeyword").attr("readonly","readonly");
	}
	 */
	$("#searchKeyword").click(function() {
		$(this).select();
	});
});

function initEmployeeHeader(inputId,url,formId,employeeResponse,employeeReturn) {
	$("#"+inputId).autocomplete(employeeOption(inputId,url,formId,employeeResponse,employeeReturn)).data("uiAutocomplete")._renderItem = employeeRenderItem;
}

function employeeOption(inputId,url,formId,employeeResponse,employeeReturn) {
	return {
		source: function( request, response ) {
			$.ajax({
				url :url,
				dateType : "json",
				type:"post",
				data: $("#"+formId).serialize(),
				async: false,
				success: function( data ) {
					response( $.map( data.DATA, function( item ) {
						return {
							label: item.empSabun + ", " + item.enterCd  + ", " + item.enterNm,
							searchNm : $("#"+inputId).val(),
							enterNm :	item.enterNm,	// 회사명
							enterCd :	item.enterCd,	// 회사코드
							empName :	item.empName,	// 사원명
							empSabun :	item.empSabun,	// 사번
							orgCd :		item.orgCd,		// 조직코드
							orgNm :		item.orgNm,		// 조직명
							jikweeCd :	item.jikweeCd,	// 직위코드
							jikweeNm :	item.jikweeNm,	// 직위
							resNo : 	item.resNo,		// 주민번호
							resNoStr:	item.resNoStr,	// 주민번호 앞자리
							statusNm :	item.statusNm,	// 재직/퇴직
							value :		item.empName,
							alias :     item.alias
						};
					}));
				}
			});
		},
		delay:50,
		autoFocus: true,
		minLength: 1,
		select: employeeReturn,
		focus: function() {
			return false;
		},
		open: function() {
			$( this ).removeClass( "ui-corner-all" ).addClass( "ui-corner-top" );
		},
		close: function() {
			$( this ).removeClass( "ui-corner-top" ).addClass( "ui-corner-all" );
		}
	};
}

function employeeRenderItem(ul, item) {
	return $("<li />")
		.data("item.autocomplete", item)
		.append("<a class='employeeLIst'>"
		+"<span class='list_txt0'>"+String(item.empName).split(item.searchNm).join('<b>'+item.searchNm+'</b>')+"</span>"
		// +"<span style='display:inline-block;width:50px;'>"+item.resNoStr+"</span>"
		// +"<span style='display:inline-block;width:100px;'>"+item.enterNm+"</span>"
		+"<span class='list_txt1'>"+item.empSabun+"</span>"
		+"<span class='list_txt2'>"+item.orgNm+"</span>"
		+"<span class='list_txt3'>"+item.jikweeNm+"</span>"
		+"<span class='list_txt4'>"+item.statusNm+"</span>"
		+"<span class='list_txt6'>"+item.alias+"</span>"
		+"</a>").appendTo(ul);
}

function employeeResponse() {
	return {
		label: item.empName + ", " + item.enterCd  + ", " + item.enterNm,
		searchNm : $("#"+inputId).val(),
		enterNm :	item.enterNm,	// 회사명
		enterCd :	item.enterCd,	// 회사코드
		empName :	item.empName,	// 사원명
		empSabun :	item.empSabun,	// 사번
		orgCd :		item.orgCd,		// 조직코드
		orgNm :		item.orgNm,		// 조직명
		jikweeCd :	item.jikweeCd,	// 직위코드
		jikweeNm :	item.jikweeNm,	// 직위
		resNo : 	item.resNo,		// 주민번호
		resNoStr:	item.resNoStr,	// 주민번호 앞자리
		statusNm :	item.statusNm,	// 재직/퇴직
		value :		item.empName

	};
}

// 리턴 값
function employeeReturn( event, ui ) {
	$("#searchUserId").val(ui.item.empSabun);
	$("#searchEnterCd").val(ui.item.enterCd);

	getUser();
	//각 페이지 함수 호출
	setEmpPage();
}

function getUser(){
	var user = ajaxCall("/Employee.do?cmd=baseEmployeeImwonDetail",$("#empForm").serialize(),false);
	if(user.map != null && user.map != "undefine") user = user.map;
	var headerSeq = 0;
	$("#searchKeyword").val(user.name);
	$("#td1_2").html(user.sabun);
	$("#tdSabun").html(user.sabun); //기존소스에서 참조하는 부분이 남아 있음[ 점차적으로 줄여야함]
	for(var i = 1; i <= 4; i++) {
		for(var j = 1; j <= 4; j++) {
			//헤더의 1,2,번째 항목란에는 성명, 사번을 고정으로 처리 하므로 패쓰함
			if(i == 1 && j <=  2) {
				continue;
			} else {
				$("#th"+i+"_"+j).html(headerInfoList[headerSeq].eleNm);
				var tdHtml = "";
				var addText = "";
				//tdHtml = eval("user." + headerInfoList[headerSeq].eleCd);
				if(headerInfoList[headerSeq].addText != "") {
					addText = headerInfoList[headerSeq].addText;
					for(var x = 0 ; x < hiddenInfoList.length ; x++) {
						addText = addText.replace("@@"+hiddenInfoList[x].eleId+"@@", eval("user." + hiddenInfoList[x].eleCd));
					}
				}
				//$("#td"+i+"_"+j).html(eval("user." + headerInfoList[headerSeq].eleCd));
				$("#td"+i+"_"+j).html(eval("user." + headerInfoList[headerSeq].eleCd));
				if(addText != "") $("#td"+i+"_"+j).html($("#td"+i+"_"+j).html()+addText);
				headerSeq++;
			}
		}
	}

	var hiddenContent = "";
	for(var i = 0 ; i < hiddenInfoList.length ; i++) {
		hiddenContent += "<input type='hidden' id='" + hiddenInfoList[i].eleId + "' value='" + eval("user." + hiddenInfoList[i].eleCd) + "'/>";
	}
	$("#hiddenEle").html(hiddenContent);

	$("#searchEmpPayType"     ).val(user.payType);
	$("#searchCurrJikgubYmd"     ).val(user.currJikgubYmd);
	$("#searchWorkYyCnt"     ).val(user.workYyCnt);
	$("#searchWorkMmCnt"     ).val(user.workMmCnt);
	$("#headName"      ).val(user.name);
	$("#headJikweeCd"  ).val(user.jikweeCd);
	$("#headJikweeNm"  ).val(user.jikweeNm);
	$("#headJikgubCd"  ).val(user.jikgubCd);
	$("#headJikgubNm"  ).val(user.jikgubNm);
	$("#headJikchakCd"  ).val(user.jikchakCd);
	$("#headJikchakNm"  ).val(user.jikchakNm);
	$("#headStatusCd"  ).val(user.statusCd);
	$("#headStatusNm"  ).val(user.statusNm);
	$("#headJobCd"     ).val(user.jobCd);
	$("#headJobNm"     ).val(user.jobNm);
	$("#headOrgCd"     ).val(user.orgCd);
	$("#headOrgNm"     ).val(user.orgNm);

	$("#headEmpYmd"     ).val(user.empYmd);

	$("#headHandPhone"     ).val(user.handPhone);

	$("#searchSabunRef"     ).val(user.sabun);

	$("#searchEnterCd").val(user.enterCd);

/*
	$("#searchKeyword" ).val(user.name);
	$("#tdSabun"       ).html(user.sabun);
	$("#tdManageNm"    ).html(user.manageNm);
	$("#tdStatusCd"    ).val(user.statusCd);  //삭제대상 => headStatusCd 로 대체
	$("#tdStatusNm"    ).html(user.statusNm);
	$("#tdWorkTypeNm"  ).html(user.workTypeNm);
	$("#tdJikweeNm"    ).html(user.jikweeNm);
	$("#tdJikgubNm"    ).html(user.jikgubNm);
	$("#tdJikhakNm"    ).html(user.jikchakNm);
	$("#tdLocationNm"  ).html(user.locationNm);
	$("#tdGempYmd"     ).html(user.gempYmd);
	$("#tdEmpYmd"      ).html(user.empYmd);
	$("#tdRetYmd"      ).html(user.retYmd);
	$("#tdJobNm"       ).html(user.jobNm);


	//변경시작
	$("#tdOrgNm"     ).html(user.orgNm);
//	$("#tdOrgPath"     ).html(user.orgPath);
	//추가시작
	$("#tdStfTypeNm").html(user.stfTypeNm);
	$("#tdCurrOrgYmd"     ).html(user.currOrgYmd);
	$("#tdCurrJikgubYmd"     ).html(user.currJikgubYmd);
	$("#searchEmpPayType"     ).val(user.payType);

	$("#searchCurrJikgubYmd"     ).val(user.currJikgubYmd);
	$("#searchWorkYyCnt"     ).val(user.workYyCnt);
	$("#searchWorkMmCnt"     ).val(user.workMmCnt);

	//추가 종료

	//변경종료


	//add Info .. addPlz
	$("#headName"      ).val(user.name);
	$("#headJikweeCd"  ).val(user.jikweeCd);
	$("#headJikweeNm"  ).val(user.jikweeNm);
	$("#headJikgubCd"  ).val(user.jikgubCd);
	$("#headJikgubNm"  ).val(user.jikgubNm);
	$("#headStatusCd"  ).val(user.statusCd);
	$("#headStatusNm"  ).val(user.statusNm);
	$("#headJobCd"     ).val(user.jobCd);
	$("#headJobNm"     ).val(user.jobNm);
	$("#headOrgCd"     ).val(user.orgCd);
	$("#headOrgNm"     ).val(user.orgNm);

	if (typeof $("#tdRmidYmd").html() != "undefined") {
		$("#tdRmidYmd").html(user.rmidYmd);
	}
	if (typeof $("#tdYearYmd").html() != "undefined") {
		$("#tdYearYmd").html(user.yearYmd);
	}
*/
	userSabun = user.sabun;
	enterCd  = user.enterCd;

	$("#userFace").attr("src","/EmpPhotoOut.do?t=" + (new Date()).getTime() + "&enterCd="+enterCd+"&sabun="+userSabun);

}