var userSabun 	= "";
var enterCd 	= "";

var headerInfoList;
var hiddenInfoList;

var headerDataMappingColumn = null;

$(function() {

	/*EmployeeHeader컬럼 구성정보 2015.03.20 Kosh*/
	headerInfoList = ajaxCall("/Employee.do?cmd=employeeHeaderColInfo",$("#empForm").serialize(),false);
	if(headerInfoList.DATA != null && headerInfoList.DATA != "undefine") headerInfoList = headerInfoList.DATA;
	hiddenInfoList = ajaxCall("/Employee.do?cmd=employeeHiddenInfo",$("#empForm").serialize(),false);
	if(hiddenInfoList.DATA != null && hiddenInfoList.DATA != "undefine") hiddenInfoList = hiddenInfoList.DATA;
	headerDataMap = ajaxCall("/Employee.do?cmd=getEmployeeHeaderColDataMap",$("#empForm").serialize(),false);
	if(headerDataMap.DATA != null && headerDataMap.DATA != "undefine") {
		$("#empForm").append("<input type='hidden' id='selectColumn' name='selectColumn' value='"+headerDataMap.DATA.selectColumn+"'/>");
		headerDataMappingColumn = JSON.parse("{" + headerDataMap.DATA.mappingColumn + "}");
		//console.log('headerDataMappingColumn', headerDataMappingColumn);
	}

	getUser();
	var inputId = "searchKeyword";
	var url = "/Employee.do?cmd=employeeList";
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
							label: item.empSabun + ", " + item.enterCd  + ", " + item.enterNm
							,searchNm : $("#"+inputId).val()
							,enterNm :	item.enterNm	// 회사명
							,enterCd :	item.enterCd	// 회사코드
							,empName :	item.empName	// 사원명
							,empAlias:	item.empAlias	// 호칭
							,empSabun :	item.empSabun	// 사번
							,orgNm :	item.orgNm		// 조직명
							,jikweeNm :	item.jikweeNm	// 직위
							//,resNo : 	item.resNo		// 주민번호
							//,resNoStr:	item.resNoStr	// 주민번호 앞자리
							,statusNm :	item.statusNm	// 재직/퇴직
							,value :	item.empName
							//,alias :    item.alias
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
	+"<span class='list_txt0'>"+String(item.empName).split(item.searchNm).join('<b class="f_gray_3 f_bold">'+item.searchNm+'</b>')+"</span>"
	// +"<span style='display:inline-block;width:50px;'>"+item.resNoStr+"</span>"
	+"<span class='list_txt1'>"+String(item.empSabun).split(item.searchNm).join('<b class="f_gray_3 f_bold">'+item.searchNm+'</b>')+"</span>"
	+"<span class='list_txt5'>"+item.enterNm+"</span>"
	+"<span class='list_txt2'>"+item.orgNm+"</span>"
	+"<span class='list_txt3'>"+item.jikweeNm+"</span>"
	+"<span class='list_txt4'>"+item.statusNm+"</span>"
	//+"<span class='list_txt6'>"+item.alias+"</span>"
	+"</a>").appendTo(ul);
}

function employeeResponse() {
	return {
		label: item.empName + ", " + item.enterCd  + ", " + item.enterNm,
		searchNm : $("#"+inputId).val(),
		empName :	item.empName,	// 회사명
		enterCd :	item.enterCd,	// 회사코드
		enterNm :	item.enterNm,	// 사원명
		empSabun :	item.empSabun,	// 사번
		empAlias:	item.empAlias,	// 호칭
		orgNm :		item.orgNm,		// 조직명
		jikweeNm :	item.jikweeNm,	// 직위
		//resNo : 	item.resNo,		// 주민번호
		//resNoStr:	item.resNoStr,	// 주민번호 앞자리
		statusNm :	item.statusNm,	// 재직/퇴직
		value :		item.empName
	};
}

// 리턴 값
function employeeReturn( event, ui ) {
	$("#searchUserId").val(ui.item.empSabun);
	$("#searchUserEnterCd").val(ui.item.enterCd);
	$("#searchUserStatusCd").val(ui.item.statusCd);
	getUser();

	//각 페이지 함수 호출
	setEmpPage();
}

function getUser(){
	var user = ajaxCall("/Employee.do?cmd=getEmployeeHeaderDataMap",$("#empForm").serialize(),false);
	if(user.DATA != null && user.DATA != "undefine") user = user.DATA;
	var headerSeq = 0;
	$("#searchKeyword").val(user.name);
	$("#span_searchKeyword").html(user.name);
	//$("#td1_2").html(user.sabun);
	$("#tdSabun").html(user.sabun); //기존소스에서 참조하는 부분이 남아 있음[ 점차적으로 줄여야함]
	for(var i = 1; i <= 5; i++) {
		for(var j = 1; j <= 4; j++) {
			//헤더의 1,2,번째 항목란에는 성명, 사번을 고정으로 처리 하므로 패쓰함
			if(i == 1 && j <=  1) {
				continue;
			} else {
				// headerInfoList의 데이터가 더이상 없는 경우 에러발생. 데이터가 없을경우 빈칸으로 채움. by kwook. 2018.04.10
				if(!headerInfoList[headerSeq]) {
					$("#th"+i+"_"+j).html("");
				} else {
					$("#th"+i+"_"+j).html(headerInfoList[headerSeq].eleNm);
				}

				var tdHtml = "";
				var addText = "";

				// headerInfoList의 데이터가 더이상 없는 경우 에러발생. by kwook. 2018.04.10
				if(headerInfoList[headerSeq] && headerInfoList[headerSeq].addText != "") {
					addText = headerInfoList[headerSeq].addText;
					for(var x = 0 ; x < hiddenInfoList.length ; x++) {
						addText = addText.replace("@@"+hiddenInfoList[x].eleId+"@@", eval("user." + convCamel(hiddenInfoList[x].eleId) + hiddenInfoList[x].eleCd));
					}
				}

				// headerInfoList의 데이터가 더이상 없는 경우 에러발생. 데이터가 없을경우 빈칸으로 채움. by kwook. 2018.04.10
				if(headerInfoList[headerSeq]) {
					tdHtml = eval("user." + convCamel(headerInfoList[headerSeq].eleId) + headerInfoList[headerSeq].eleCd);
					/*
					if( comBtnAuthPg != undefined && comBtnAuthPg != null && comBtnAuthPg == "R" ) {
						if( headerInfoList[headerSeq].eleNm == "성명" ) {
							tdHtml = tdHtml.substring(0,1) + "*" + tdHtml.substring(2, tdHtml.length);
						}
						if( headerInfoList[headerSeq].eleNm == "휴대폰" ) {
							if(tdHtml.indexOf("-") > -1) {
								if( tdHtml.indexOf("-", 5) > 7 ) {
									tdHtml  = tdHtml.substring(0,2) + "*-****-" + tdHtml.substring(tdHtml.indexOf("-", 5) + 1, tdHtml.length);
								} else {
									tdHtml  = tdHtml.substring(0,2) + "*-***-" + tdHtml.substring(tdHtml.indexOf("-", 5) + 1, tdHtml.length);
								}
							} else {
								tdHtml = tdHtml.substring(0,2) + "****" + tdHtml.substring(tdHtml.length - 4, tdHtml.length);
							}
						}
					}
					*/
				} else {
					tdHtml = "";
				}
				
				if($.trim(tdHtml) != "") {
					// headerInfoList의 데이터가 더이상 없는 경우 에러발생. by kwook. 2018.04.10
					if(headerInfoList[headerSeq] && headerInfoList[headerSeq].eleType == "Int") {
						$("#td"+i+"_"+j).html(tdHtml.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ","));
					} else {
						$("#td"+i+"_"+j).html(tdHtml);
					}
				}

				// 직원 데이터를 조회할 때 데이터가 없을 경우 이미 이전 직원 데이터가 그대로 표시되는 경우 발생. else 부분 추가. by kwook. 2018.03.13
				else {
					$("#td"+i+"_"+j).html(tdHtml);
				}

				if(addText != ""){
					$("#td"+i+"_"+j).html($("#td"+i+"_"+j).html()+addText);
				}
				headerSeq++;
			}
		}
	}
	
	$("dt").each(function() {
		if ( !($("#setEmpLocaleCd").val() == "" || $("#setEmpLocaleCd").val() == "ko_KR")){
			$(this).css("width","140px");
		}
	});
	
	var hiddenContent = "";
	for(var i = 0 ; i < hiddenInfoList.length ; i++) {
		hiddenContent += "<input type='hidden' id='" + hiddenInfoList[i].eleId + "' value='" + eval("user." + convCamel(headerInfoList[i].eleId) + headerInfoList[i].eleCd) + "'/>";
	}
	$("#hiddenEle").html(hiddenContent);
	
	$("#searchEmpPayType"   ).val(user.payType);
	$("#searchCurrJikgubYmd").val(user.currJikgubYmd);
	$("#searchWorkYyCnt"    ).val(user.workYyCnt);
	$("#searchWorkMmCnt"    ).val(user.workMmCnt);
	$("#headName"           ).val(user.name);
	$("#headJikweeCd"       ).val(user.jikweeCd);
	$("#headJikweeNm"       ).val(user[ getEmployeeHeaderColumnMappingKey("직위명") ]);
	$("#headJikgubCd"       ).val(user.jikgubCd);
	$("#headJikgubNm"       ).val(user[ getEmployeeHeaderColumnMappingKey("직급명") ]);
	$("#headJikchakCd"      ).val(user.jikchakCd);
	$("#headJikchakNm"      ).val(user[ getEmployeeHeaderColumnMappingKey("직책명") ]);
	$("#headStatusCd"       ).val(user.statusCd);
	$("#headStatusNm"       ).val(user[ getEmployeeHeaderColumnMappingKey("재직상태명") ]);
	$("#headJobCd"          ).val(user.jobCd);
	$("#headJobNm"          ).val(user[ getEmployeeHeaderColumnMappingKey("직무명") ]);
	$("#headOrgCd"          ).val(user.orgCd);
	$("#headOrgNm"          ).val(user[ getEmployeeHeaderColumnMappingKey("부서명") ]);
	
	$("#headManageNm"       ).val(user[ getEmployeeHeaderColumnMappingKey("사원구분명") ]);
	$("#headHandPhone"      ).val(user[ getEmployeeHeaderColumnMappingKey("핸드폰번호") ]);
	$("#headMailId"         ).val(user[ getEmployeeHeaderColumnMappingKey("메일주소") ]);
	
	$("#searchSabunRef"     ).val(user.sabun);
	
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

	//$("#userFace").attr("src","/EmpPhotoOut.do?t=" + (new Date()).getTime() + "&enterCd="+enterCd+"&searchKeyword="+userSabun);
	$("#userFace").attr("src","/EmpPhotoOut.do?enterCd="+enterCd+"&searchKeyword="+userSabun+"&t=" + (new Date()).getTime());

}

/**
 * 조회된 항목들의 user 객체에서의 키명 반환
 * @param colNm
 * @returns
 */
function getEmployeeHeaderColumnMappingKey(colNm) {
	var key = null;
	if( headerDataMappingColumn != null && headerDataMappingColumn != undefined && headerDataMappingColumn[colNm] != null && headerDataMappingColumn[colNm] != undefined ) {
		key = headerDataMappingColumn[colNm].toLowerCase();
	}
	return key;
}