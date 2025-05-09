<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<%@ page import="com.hr.common.util.DateUtil" %>
<!DOCTYPE html>
<html class="bodywrap">
<head>
<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%><!-- Meta -->
<title><tit:txt mid='104100' mdef='이수시스템(주)'/></title>
<%@ include file="/WEB-INF/jsp/common/include/jqueryScript.jsp"%><!-- Jquery -->
<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%><!-- IBSheet -->
<script src="https://ssl.daumcdn.net/dmaps/map_js_init/postcode.v2.js"></script>
<script type="text/javascript">
	$(function() {

		//날짜검색기간 달력 세팅
		$("#searchFrom").datepicker2({startdate:"searchTo"});
		$("#searchTo").datepicker2({enddate:"searchFrom"});

		// 배열 선언
		var initdata = {};
		// ######## 시트 기본 설정 ########
		// SearchMode
		//  1. smGeneral(전체 보기용)
		//  2. smClientPaging(페이징 조회)
		//  3. smLazyLoad (스크롤 조회(권장))
		//  4. smServerPaging : 서버 스크롤 페이징 조회 5000건 이상 대용량
		// Page         : SearchMode가 1또는 2인 경우 한번에 표시할 행의 개수
		// FrozenCol    : 고정컬럼의 수
		// MergeSheet   : 머지 종류를 설정(인자는 MergeSheet Method 설명 참조)
		// DataRowMerge : 전체행의 가로머지 허용여부 (Default:0)
		// ToolTip      : 셀의 풍선도움말을 표시한다.
		// SumPosition  : 합계행 위치(1: 하단 고정, 0: 상단 고정)
		// SizeMode     : 사이즈 방식 설정(0: 사이즈 고정, 1: 높이를 스크롤 없이 자동 설정, 2: 너비를 스크롤 없이 자동 설정, 3: 높이, 너비를 스크롤 없이 자동 설정
		initdata.Cfg = {SearchMode:smLazyLoad,Page:22};

		// ######## 헤어 정보 설정 ########
		// Sort       : 헤더 클릭 시 소트 가능 여부 (Default:1)
		// ColMove    : 헤더 컬럼 이동 가능 여부 (Default:1)
		// ColResize  : 컬럼 너비 ReSize 여부 (Default:1)
		// HeaderCheck:  헤더에 전체 체크 표시 여부 (Default:1)
		initdata.HeaderMode = {Sort:1,ColMove:1,ColResize:1,HeaderCheck:1};

		// InitColumns + Header Title
		// ######## 컬럼 정보 설정 ########
		// Type             : 해당 컬럼에 대한 Type 설정으로 다음과 같은 값을 설정 할 수 있다.
		//  1 . Text       - 기본 문자열 데이터
		//  2 . Status     - 트랜잭션 상태를 표시하고, 담고 있는 데이터
		//  3 . DelCheck   - 삭제 처리만 담당하는 CheckBox 형태 데이터
		//  4 . CheckBox   - CheckBox 형태 데이터
		//  5 . DummyCheck - CheckBox 형태이나 체크/언체크시 상태를 변화시키지 않음.
		//  6 . Radio      - 데이터 행 중 하나의 데이터만 체크되는 형태
		//  7 . Combo      - Edit 불가능 Combo 데이터
		//  8 . ComboEdit  - 자동완성형태의 Combo 데이터
		//  9 . AutoSum    - 자동 합계 계산을 위한 데이터, 기본포맷은 Integer
		//  10. AutoAvg    - 자동 평균 계산을 위한 데이터, 기본포맷은 Integer
		//  11. Image      - Edit 불가능한 단순 이미지 표현 형태 데이터
		//  12. Int        - 정수형 타입
		//  13. Float      - 실수형 타입
		//  14. Date       - 날짜형 타입
		//  15. Popup      - 팝업을 사용한 데이터
		//  16. PopupEdit  - 키보드 Edit도 가능하고 팝업도 사용하는 데이터
		//  17. Pass       - 패스워드 형태 데이터
		//  18. Seq        - DB의 시퀀스처럼 무조건 값이 증가하는 값이며, Edit가 불가능한 형태의 데이터

		// Width            : 컬럼에 대한 픽셀 단위 너비 설정으로 설정하지 않을 경우 헤더 Text의 너비에 맞게 자동 설정된다.

		// Align            : 데이터에 대한 정렬 설정 Left, Center, Right 값을 설정한다.
		//  1. Left   - 좌측정렬 데이터 (default)
		//  2. Center - 가운데 정렬 데이터
		//  3. Right  - 우측 정렬 데이터

		// SaveName         : 데이터를 저장할 때 사용하는 변수 명을 설정한다. 변수명을 설정하지 않을 경우 기본적으로 컬럼 순서대로 C1, C2, … 로 설정된다.
		// Edit             : 데이터의 편집가능 여부를 설정한다. 기본적으로 1이 설정된다.
		// EditLen          : 데이터의 입력 가능한 글자 수를 설정한다.

		// Format           : 데이터에 대한 Mask 적용 형태를 설정하는 것으로 다음과 같은 값을 설정한다. 포맷 설정은 기본제공 외에 사용자가 직접 정의 해서 설정 할 수 있으며 ( (ex) Format="#,###.#0"  or "######-*******" or "yy.MM.dd") Type 값에 따라 설정한 Format이 적용 된다.
		//  1 .Ymd         - "년월일" 형태. Ibmsg의 SYS_d 포맷을 따른다       Type[ Date,Text,Popup,PopupEdit ]
		//  2 .Ym          - "년월" 형태, ibmsg의 SYS_m 포맷을 따른다.        Type[ Date,Text,Popup,PopupEdit ]
		//  3 .Md          - "월일" 형태. ibmsg의 SYS_M 포맷을 따른다.        Type[ Date,Text,Popup,PopupEdit ]
		//  4 .Hms         - "시분초" 형태. ibmsg의 SYS_T 포맷을 따른다.      Type[ Date,Text,Popup,PopupEdit ]
		//  5 .Hm          - "시분" 형태. ibmsg의 SYS_t 포맷을 따른다.        Type[ Date,Text,Popup,PopupEdit ]
		//  6 .YmdHms      - "년월일시분초" 형태. Ibmsg의 SYS_G 포맷을 따른다 Type[ Date,Text,Popup,PopupEdit ]
		//  7 .YmdHm       - "년월일시분" 형태. Ibmsg의 SYS_g 포맷을 따른다   Type[ Date,Text,Popup,PopupEdit ]
		//  8 .Integer     - 정수 형태, 기본 0                                Type[ Int,AutoSum,AutoAvg       ]
		//  9 .NullInteger - 널 정수 형태, 기본 널                            Type[ Int,AutoSum,AutoAvg       ]
		//  10.Float       - 실수 형태, 기본 0                                Type[ Float,AutoSum,AutoAvg     ]
		//  11.NullFloat   - 널 실수 형태, 기본 널                            Type[ Float,AutoSum,AutoAvg     ]
		//  12.IdNo        - 주민등록번호 형태                                Type[ Text                      ]
		//  13.SaupNo      - 사업자번호 형태                                  Type[ Text                      ]
		//  14.PostNo      - 우편번호 형태                                    Type[ Text                      ]
		//  15.CardNo      - 카드번호 형태                                    Type[ Text                      ]

		// ComboText          : Type이 "Combo" 또는 "ComboEdit"인 경우 화면에 보여질 문자열 항목을 "|"로 연결하여 구성한다.
		// ComboCode          : Type이 "Combo" 또는 "ComboEdit"인 경우 저장될 코드 항목을 "|"로 연결하여 구성하며 위의 ComboText 항목의 개수와 동일 하여야 한다.
		// MultiLineText      : Type이 "Text"인 경우 다중라인 입력여부를 설정한다. 기본적으로 0값이 설정된다.
		// Wrap               : 컬럼너비에 따라 자동 줄바꿈 여부를 설정한다. 기본적으로 0값이 설정된다.
		// TreeCol            : 트리형태 조회의 경우 기준컬럼 여부를 설정한다.
		// KeyField           : 데이터의 필수입력 항목 여부를 설정하는 것으로 1인 경우 저장 함수 호출 시 셀에 데이터가 없는 경우 경고 메시지를 표시하고, Edit 하도록 유도한다. 기본적으로 0값이 설정된다.
		// CalcLogic          : 해당 데이터에 대한 계산 공식을 설정한다. 컬럼 데이터의 값이 공식에 사용 되는 경우 "|"로 감사서 공식에 설정한다. 기본적으로 공식없은 "" 으로 설정된다.
		//                      예를 들어, 5컬럼 값에 2를 곱해서 3컬럼 값을 더해야 한다면 공식은 "|5| * 2 + |3|"와 같이 설정된다. 공식이 설정 된 경우 다른 컬럼의 값이 바뀌었거나 조회했을 때 자동으로 계산 처리한다.
		//                      컬럼번호가 아니라 다른컬럼의 SaveName 을 사용하여 공식을 작성할 수도 있다. 예를 들어 위 공식에서 5컬럼의 SaveName이 "pay"였다고 하면 공식은 "|pay|*2+|3|"이라고 설정해도 같은 효과를 볼 수 있다.
		// ColMerge           : 데이터 컬럼에 대한 세로 머지 가능 여부를 설정한다. 기본적으로 1값이 설정된다.
		// Hidden             : 데이터 컬럼 숨김 여부를 설정한다.
		// ImgWidth           : Type이 "Image" 인 경우 표시되는 이미지의 너비값을 설정한다. 기본적으로 0값이 설정되며 0으로 설정하는 경우 표시되는 이미지는 원본 사이즈로 표시된다.
		// ImgHeight          : Type이 "Image" 인 경우 표시되는 이미지의 높이값을 설정한다. 기본적으로 0값이 설정되며 0으로 설정하는 경우 표시되는 이미지는 원본 사이즈로 표시된다.
		// PopupText          : 컬럼팝업을 설정시 컬럼팝업을 표시할 문자열 항목을 "|"로 연결하여 구성한다.
		// PopupCode          : 컬럼팝업을 설정시 PopupText에 대한 Code를 "|"로 연결하여 구성하며 PopupText 항목의 개수와 동일하여야 한다.
		// PopupCheckEdit     : 컬럼팝업을 설정했을경우 선택한 행의 데이타 편집가능 여부를 확인하여 편집가능한 데이터만 변경하는 경우는 1로 설정한다. 기본적으로 0 값이 설정된다. 
		// UpdateEdit         : 트랜잭션 상태가 조회인 데이터에 대해 Edit 가능 여부를 설정하며, 기본적으로 1값이 설정된다.
		// InsertEdit         : 트랜잭션 상태가 입력인 데이터에 해서 Edit 가능 여부를 설정하며, 기본적으로 1값이 설정된다.
		// LevelSaveName      : 트리 형태의 조회인 경우 데이터를 저장할 때 사용하는 트리 베벨의 변수 명을 설정한다. 변수명을 설정하지 않을 경우 해당 행의 트리레벨은 서버로 전달되지 않는다.
		// ButtonUrl          : 컬럼타입이 Popup,PopupEdit 일때 Format이 날짜포맷일 경우 해당 버튼이미지를 변경하는 속성이다. 기본적으로 날짜버튼이미지로 설정된다.(변경할 이미지는 테마폴더 안에 넣는다. 이미지 사이즈는 12*12)
		// TrueValue          : 1 이외의 CheckBox 형태 컬럼의 True 값 지정. "M" 으로 지정한 경우 1 대신 "M"을 True 값으로 사용 가능.
		// FalseValue         : 1 이외의 CheckBox 형태 컬럼의 False 값 지정. "F" 으로 지정한 경우 0 대신 "F"룰 False 값으로 사용 가능.
		// MaximumValue       : Format이 숫자와 관련된 포멧인 Integer, Float, NullInteger, NullFloat 일때, 편집시 입력할 수 있는 최대값을 설정한다.
		// MinimumValue       : Format이 숫자와 관련된 포멧인 Integer, Float, NullInteger, NullFloat 일때, 편집시 입력할 수 있는 최소값을 설정한다.
		// PointCount         : 컬럼타입이 Float 인 경우 소수점 이하의 자리수를 설정한다. 설정하지 않은 경우 Format 설정값을 따르며 설정한 경우 Format 설정값은 무시되고 재설정 된다.
		// FullInput          : 컬럼타입이 단일행 문자열인 경우 EditLen 만큼 모두 입력해야 하는 경우 설정한다. 기본적으로 0값이 설정된다.
		// ToolTipText        : 풍선 도움말에 설정할 문자열
		// Ellipsis           : 컬럼 텍스트의 표시글자가 잘릴경우 말줄임 여부를 설정한다. 기본적으로 0값이 설정된다
		// BackColor          : 컬럼의 배경색상을 설정한다.
		// FontColor          : 폰트 색상
		initdata.Cols = [
			{Header:"<sht:txt mid='sNo' mdef='No'/>",				Type:"${sNoTy}",	Hidden:0,	Width:"${sNoWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sNo" },
			{Header:"<sht:txt mid='sDelete V5' mdef='삭제'/>",				Type:"${sDelTy}",	Hidden:0,	Width:"${sDelWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sDelete",	Sort:0 },
			{Header:"<sht:txt mid='sStatus' mdef='상태'/>",				Type:"${sSttTy}",	Hidden:0,	Width:"${sSttWdt}",	Align:"Center",	ColMerge:0,	SaveName:"sStatus",	Sort:0 },

			{Header:"SEQUENCE",						Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"seq",			KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:22},
			{Header:"<sht:txt mid='appSabunV6' mdef='사원번호'/>",						Type:"Popup",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"sabun",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:13},
			{Header:"<sht:txt mid='appNameV1' mdef='성명'/>",							Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"name",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:200},
			{Header:"<sht:txt mid='authScopeCd' mdef='코드'/>",							Type:"Combo",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tstCode",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"암복호화",						Type:"Text",	Hidden:0,	Width:200,	Align:"Left",	ColMerge:0,	SaveName:"tstEncrypt",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
			{Header:"날짜(YYYY-MM-DD)",				Type:"Date",	Hidden:0,	Width:150,	Align:"Center",	ColMerge:0,	SaveName:"tstYyyymmdd",	KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:10},
			{Header:"시간(MI:SS)",					Type:"Text",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tstMiss",		KeyField:0,	CalcLogic:"",	Format:"Hm",	PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:4},
			{Header:"체크박스",						Type:"CheckBox",Hidden:0,	Width:100,	Align:"Center",	ColMerge:0,	SaveName:"tstCheck",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1, TrueValue:"Y", FalseValue:"N"},
			{Header:"숫자 8자리",						Type:"Int",		Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:"tstNum",		KeyField:0,	CalcLogic:"",	Format:"########",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:8},
			{Header:"숫자(콤마사용)",					Type:"Int",		Hidden:0,	Width:120,	Align:"Right",	ColMerge:0,	SaveName:"tstNumComma",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:22},
			{Header:"문자",							Type:"Text",	Hidden:0,	Width:300,	Align:"Left",	ColMerge:0,	SaveName:"tstStr",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:200},
			{Header:"MultiLineText 문자(Enter사용)",	Type:"Text",	Hidden:0,	Width:500,	Align:"Left",	ColMerge:0,	SaveName:"tstLongStr",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:2000, MultiLineText:1, Wrap:1},
			{Header:"<sht:txt mid='zip' mdef='우편번호'/>",						Type:"Popup",	Hidden:0,	Width:80,	Align:"Center",	ColMerge:0,	SaveName:"tstZipcode",	KeyField:0,	CalcLogic:"",	Format:"PostNo",PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:7},
			{Header:"<sht:txt mid='addr' mdef='주소'/>",							Type:"Text",	Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"tstAddr",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:300},
			{Header:"<sht:txt mid='addr2' mdef='상세주소'/>",						Type:"Text",	Hidden:0,	Width:350,	Align:"Left",	ColMerge:0,	SaveName:"tstAddrDtl",	KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:1,	InsertEdit:1,	EditLen:1000},
			{Header:"최종수정자사번",					Type:"Text",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"chkid",		KeyField:0,	CalcLogic:"",	Format:"",		PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:13},
			{Header:"최종수정일자",						Type:"Date",	Hidden:0,	Width:120,	Align:"Center",	ColMerge:0,	SaveName:"chkdate",		KeyField:0,	CalcLogic:"",	Format:"Ymd",	PointCount:0,	UpdateEdit:0,	InsertEdit:0,	EditLen:7}
		];
		// 초기화
		IBS_InitSheet(sheet1, initdata);

		// 전체적인 Edit 허용 여부를 확인하거나 설정한다. 0 or 1
		sheet1.SetEditable(1);

		// IBSheet의 표시 여부를 설정하거나 확인한다. 0으로 설정하면 건수 정보를 포함한 모든 것이 숨겨져서 보이지 않으며, 1로 설정하면 모든 정보를 볼수 있다.
		sheet1.SetVisible(1);

		// CountPosition Method : 0-표시하지 않음 1-좌측상단 2-우측상단 3-좌측하단 4-우측하단
		sheet1.SetCountPosition(4);

		//데이터를 Edit 후 Enter 키를 눌렀을 때 동작을 확인하거나 설정한다. MultiLineText가 1인 컬럼은 enter누르면 행바꿈
		sheet1.SetEditEnterBehavior("newline");

		sheet1.SetImageList(0,"${ctx}/common/images/icon/icon_popup.png");
		sheet1.SetImageList(1,"${ctx}/common/images/icon/icon_popup.png");
		// 검색 조건의 항목중에 Keyup으로 이벤트가 발생 했을떄 엔터키가 들어오면 조회하게 끔 할것인지 설정
		$("#viewNm").bind("keyup",function(event){
			if( event.keyCode == 13){
				doAction1("Search");
			}
			return $(this).focus();
		});

		//Commbo Box Set
		var comboList1   = convCode( codeList("/CommonCode.do?cmd=getCommonCodeList","ZTST001"), "");
		sheet1.SetColProperty("tstCode",         {ComboText:comboList1[0],    ComboCode:comboList1[1]} );

		//검색창 Commbo BoxSet
		var comboList2   = convCode( codeList("/CommonCode.do?cmd=getCommonCodeList","ZTST001"), "<tit:txt mid='103895' mdef='전체'/>");	//전체 가능
		$("#searchCode").html(comboList2[2]);


		// 리사이즈 설정
		$(window).smartresize(sheetResize);

		// 시트 사이즈 초기화
		sheetInit();

		//검색 조건에서 입력 후, 엔터를 누를 때 Action
		$("#searchFrom, #searchTo, #searchSabunName").bind("keyup",function(event){
			if( event.keyCode == 13) {
				doAction1("Search");
				$(this).focus();
			}
		});

		//검색 조건에서 검색 조건을 변경하였을 때 Action
		$("#searchYn, #searchCode").on("change", function(e) {
			doAction1("Search");
		});

		// 화면셋팅후 자동으로 조회
		doAction1("Search");

	});

	//Sheet1 Action
	function doAction1(sAction) {
		switch (sAction) {
		case "Search":	//조회
			// "<c:url value='주소'/>" 형태로 선언
			// 조회시 request에 담을때에는 Form과 보낼 변수를 input hidden으로 선언하여 한번에 보냄 -> $("보낼 Form").serialize()
			sheet1.DoSearch( "/Sample.do?cmd=getSampleList", $("#sheet1Form").serialize() ); break;
		case "Save":	//저장
			// "${ctx}+Mapping Url" 형태로 선언
			// 저장시 request에 담을때에는 Form과 보낼 변수를 input hidden으로 선언하여 한번에 보냄 -> $("보낼 Form").serialize()
			// update, insert는 MERGE 사용 이외는 Delete
			IBS_SaveName(document.sheet1Form,sheet1);
			sheet1.DoSave( "/Sample.do?cmd=saveSample", $("#sheet1Form").serialize());
			break;
		case "Insert":	//입력
			// 입력 버튼이 눌려 졌을때 호출 되며 시트위 젤 위에 공백인 행을 만들어 준다
			// 만들어 지고 난후 컬럼ID에 해당하는 Field에 포커스가 가도록 한다.
			sheet1.DataInsert(0); break;
		case "Copy":	//복사
			// 입력 버튼이 눌려 졌을때 호출 되며 시트위 젤 위에 공백인 행을 만들어 준다
			var Row = sheet1.DataCopy();
		    sheet1.SetCellValue(Row,"seq","");
		    break;
		case "Down2Excel":	//엑셀내려받기
			var downcol = makeHiddenSkipCol(sheet1);
			var param  = {DownCols:downcol,SheetDesign:1,Merge:1};
			sheet1.Down2Excel(param);
			break;
		case "SamplePrcCall":
			// 자료생성
			if(confirm("테스트 프로시저를 실행하시겠습니까?")) {
				var data = ajaxCall("/Sample.do?cmd=samplePrcCall","",false);
				if(data.Result.Code == null) {
		    		alert("프로시저 실행이 완료되었습니다.");
		    		doAction1("Search");
		    	} else {
			    	alert(data.Result.Message);
		    	}
			}
			break;
		case "sampleView":

			var win = openPopup("${ctx}/html/sample/source_sample1.html", "", "1200","400");

			break;
		}
	}

	// 조회 후 에러 메시지
	function sheet1_OnSearchEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			sheetResize();
		} catch (ex) { alert("OnSearchEnd Event Error : " + ex); }
	}

	// 저장 후 메시지
	function sheet1_OnSaveEnd(Code, Msg, StCode, StMsg) {
		try {
			if (Msg != "") {
				alert(Msg);
			}

			doAction1("Search");

		} catch (ex) { alert("OnSaveEnd Event Error " + ex); }
	}

	// 셀에서 키보드가 눌렀을때 발생하는 이벤트
	function sheet1_OnKeyDown(Row, Col, KeyCode, Shift) {
		try {
			// Insert KEY
			if (Shift == 1 && KeyCode == 45) {
				doAction1("Insert");
			}
			//Delete KEY
			if (Shift == 1 && KeyCode == 46 && sheet1.GetCellValue(Row, "sStatus") == "I") {
				sheet1.SetCellValue(Row, "sStatus", "D");
			}
		} catch (ex) {
			alert("OnKeyDown Event Error : " + ex);
		}
	}

	// 팝업 클릭시 발생
	function sheet1_OnPopupClick(Row,Col) {
		try {
			if(sheet1.ColSaveName(Col) == "sabun") {
				if(!isPopup()) {return;}

				gPRow = Row;
				pGubun = "employeePopup";

	            var win = openPopup("/Popup.do?cmd=employeePopup&authPg=${authPg}", "", "840","520");

			}else if(sheet1.ColSaveName(Col) == "tstZipcode"){
		    	if(!isPopup()) {return;}
				var postPopup = new daum.Postcode({
					oncomplete : function(data) {
						if(data.userSelectedType == "J"){
						 	addr1 = data.jibunAddress;
						}else{
							addr1 = data.roadAddress;
							if(data.buildingName !=""){
								addr1 = addr1 + " (" + data.buildingName + ")";
							}
						}
						sheet1.SetCellValue(Row, "tstZipcode", data.zonecode);
						sheet1.SetCellValue(Row, "tstAddr", addr1);
						//sheet1.SetCellValue(Row, "addr2", "");
					}
				}).open();
	    	}

		} catch (ex) {
			alert("OnPopupClick Event Error : " + ex);
		}
	}

	//팝업 콜백 함수.
	function getReturnValue(returnValue) {
		var rv = $.parseJSON('{' + returnValue+ '}');

        if(pGubun == "employeePopup") {
            sheet1.SetCellValue(gPRow, "sabun",		rv["sabun"] );
            sheet1.SetCellValue(gPRow, "name",		rv["name"] );
        }
	}

</script>

</head>
<body class="bodywrap">
	<div class="wrapper">
	<!-- 	Form 생성 시작 -->
		<form id="sheet1Form" name="sheet1Form">
			<div class="sheet_search outer">
				<div>
				<table>
					<tr>
						<th><tit:txt mid='104330' mdef='사번/성명'/></th>
						<td>
							<input id="searchSabunName" name="searchSabunName" type="text" class="text" />
						</td>
						<th>searchCode</th>
						<td> 
							 <select id="searchCode" name="searchCode">
							 </select>
						</td>
						<th>날짜검색기간</th>
						<td>
							<input type="text" id="searchFrom" name="searchFrom" class="date2" value="">&nbsp;~&nbsp;
							<input type="text" id="searchTo" name="searchTo" class="date2" value="">
						</td>
						<th>문자검색</th>
						<td> 
							<input id="searchString" name ="searchString" type="text" class="text w100" />
						</td>
						<td> <a href="javascript:doAction1('Search')" id="btnSearch" class="button"><tit:txt mid='104081' mdef='조회'/></a> </td>
					</tr>
				</table>
				</div>
			<!-- 	Condtion 생성 시작 -->
			</div>
		</form>
		<!-- 	Form 생성 시작 -->

		<table border="0" cellspacing="0" cellpadding="0" class="sheet_main">
		<tr>
			<td>
			<div class="inner">
				<div class="sheet_title">
				<ul>
					<li class="txt">기본화면 가이드( sampleTab.jsp )</li>
					<!-- 	Button 생성 시작 -->
					<li class="btn">
						<a href="javascript:doAction1('sampleView')" class="button">기본 소스 폼</a>

						<a href="javascript:doAction1('SamplePrcCall')" class="button">프로시저실행</a>
						<a href="javascript:doAction1('Insert')" class="basic"><tit:txt mid='104267' mdef='입력'/></a>
						<a href="javascript:doAction1('Copy')" 	class="basic"><tit:txt mid='104335' mdef='복사'/></a>
						<a href="javascript:doAction1('Save');" class="basic"><tit:txt mid='104476' mdef='저장'/></a>
						<a href="javascript:doAction1('Down2Excel');" class="basic"><tit:txt mid='download' mdef='다운로드'/></a>
					</li>
					<!-- 	Button 생성 종료 -->
				</ul>
				</div>
			</div>
			<!-- 	sheet 생성 시작 -->
			<!--    createIBSheet(sheetid,width,height,[lang]) -->
			<!--    sheetid로 화면에 ID를 부여 하며 해당 아이디로 이벤트가 생성 된다 -->
			<!--    ex) sheetid_OnClick으로 클릭이벤트가 맵핑된다. -->
			<!--    width,height는 Default 100% -->
			<!--    lang Default kr -->
			<script type="text/javascript">createIBSheet("sheet1", "100%", "100%","${ssnLocaleCd}"); </script>
			<!-- sheet 생성 종료 -->
			</td>
		</tr>
		</table>
	</div>
</body>
</html>
