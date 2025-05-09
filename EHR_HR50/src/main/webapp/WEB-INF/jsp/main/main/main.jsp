<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/jsp/common/include/taglibs.jsp"%>
<!DOCTYPE html>
<html lang="ko">
<head>
	<%@ include file="/WEB-INF/jsp/common/include/meta.jsp"%>
	<%@ include file="/WEB-INF/jsp/common/include/ibSheetScript.jsp"%>
	<title>${ ssnAlias }</title>
	<!-- FONT PRELOAD -->
	<link rel="preload" href="/assets/fonts/google_icons/MaterialIcons-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous">
	<link rel="preload" href="/assets/fonts/google_icons/MaterialIconsOutlined-Regular.woff2" as="font" type="font/woff2" crossorigin="anonymous">
	<link rel="preload" href="/assets/fonts/font.css" as="style">

	<!--   STYLE START	 -->
	<link rel="stylesheet" type="text/css" href="/common/css/${wfont}.css">
	<link rel="stylesheet" type="text/css" href="/common/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/util.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/override.css" />
	<link rel="stylesheet" type="text/css" href="/common/css/mainSub.css" />

	<!-- HR UX 개선 신규 CSS -->
	<link rel="stylesheet" type="text/css" href="/assets/css/_reset.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/modal.css" />
	<link rel="stylesheet" type="text/css" href="/assets/fonts/font.css" />
	<link rel="stylesheet" href="/assets/plugins/swiper-10.2.0/swiper-bundle.min.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/common.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/widget.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/chart.css">
	<link rel="stylesheet" type="text/css" href="/assets/css/hrux_fit.css">
	<link rel="stylesheet" type="text/css" href="/assets/css/themes/colors.css" />
	<link rel="stylesheet" type="text/css" href="/assets/css/themes/theme.css" />

	<!--   STYLE END      -->
	<!--   JQUERY - Critical JS	 -->
	<script src="${ctx}/common/js/jquery/3.6.1/jquery.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/ui/1.13.2/jquery-ui.min.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/common.js" type="text/javascript" charset="UTF-8"></script>
	<script src="${ctx}/common/js/lang.js" type="text/javascript" charset="utf-8"></script>
	<script src="${ctx}/common/js/cookie.js" type="text/javascript"></script>

	<script type="text/javascript" src="${ctx}/common/js/main.js"></script>
	<script type="text/javascript" src="${ctx}/common/js/submain.js"></script>
	<script type="text/javascript" src="${ctx}/common/js/maincom.js"></script>
	<script type="text/javascript" src="${ctx}/common/js/commonHeader.js"></script>
	<script type="text/javascript" src="${ctx}/assets/js/util.js"></script>

	<script type="text/javascript">
		/**
		 * 지연 로딩을 위한 DeferredLoader 객체
		 * 페이지 성능 최적화를 위해 중요도가 낮은 JS 파일들을 필요할 때 동적으로 로드
		 */
		const DeferredLoader = {
			// 지연 로딩할 JS 파일 목록
			resources: [
				'${ctx}/common/js/crypto-js/4.2.0/crypto-js.min.js',
				'${ctx}/assets/plugins/fullcalendar-6.1.8/main.js',
				'${ctx}/common/js/jquery/jquery.selectbox-0.2.min.js'
			],

			// 이미 로드된 스크립트 추적을 위한 Set
			loadedScripts: new Set(),

			/**
			 * 개별 스크립트 파일을 동적으로 로드하는 함수
			 * @param {string} url - 로드할 스크립트 파일의 URL
			 * @returns {Promise} 스크립트 로드 완료를 나타내는 Promise
			 */
			loadScript: function(url) {
				// 이미 로드된 스크립트는 다시 로드하지 않음
				if (this.loadedScripts.has(url)) return Promise.resolve();

				return new Promise((resolve, reject) => {
					const script = document.createElement('script');
					script.type = 'text/javascript';
					script.src = url;
					script.async = true;
					script.charset = 'utf-8';

					// 스크립트 로드 완료 시 처리
					script.onload = () => {
						this.loadedScripts.add(url);
						resolve();
					};

					// 스크립트 로드 실패 시 처리
					script.onerror = () => reject(new Error(`Script load error: ${url}`));
					document.body.appendChild(script);
				});
			},

			/**
			 * 모든 리소스를 순차적으로 로드하는 함수
			 */
			loadAll: async function() {
				try {
					for (const url of this.resources) {
						await this.loadScript(url);
					}
					this.initializeComponents();
				} catch (error) {
					console.error('리소스 로딩 중 오류 발생:', error);
				}
			},
			
			/**
			 * 모든 스크립트 로드 완료 후 실행되는 초기화 함수
			 * 각종 UI 컴포넌트와 기능들을 초기화
			 */
			initializeComponents: function() {
				// 모든 스크립트 로드 후 초기화 함수들 실행
				headerSTimeInit();
				headerCTimeInit();
				setThemeEvent();
				createAuthList();
				createMainMenu();
				$('#errorAcc').hide();
				
				if ("${ssnLocaleCd}" !== '' && "${ssnLangUseYn}" === "1") {
					selectLanguage("${ssnLocaleCd}");
				}
			}
		};

		/**
		 * 페이지 로드 시 iframe 가시성 감지 및 리소스 로드
		 * IntersectionObserver를 사용하여 iframe이 화면에 보일 때만 리소스를 로드
		 */
		document.addEventListener('DOMContentLoaded', function() {
			const observer = new IntersectionObserver((entries) => {
				entries.forEach(entry => {
					if (entry.isIntersecting) {  // iframe이 화면에 보이면
						DeferredLoader.loadAll(); // 리소스 로드 시작
						observer.disconnect();     // 감시 중단
					}
				});
			});

			// vueMainFrame iframe 감시 시작
			observer.observe(document.getElementById('vueMainFrame'));
		});
		var _pageObj = [];
		var gPRow = "";
		var pGubun = "";

		var _connect_E_ = "${ssnEnterCd}";
		var _connect_A_ = "${authPg}";
		var _connect_I_ = "${ssnSabun}";

		const defaultTime = "${sessionScope.ssnTimeLock}";
		const localeCd    = "${ssnLocaleCd}";
		const enterCd     = "${ssnEnterCd}";
		const session_theme = '${theme}';
		const session_font = '${wfont}';
		const session_mainT = '${maintype}';


		function showWidgetLayer(url, data, opt, title, cW, cH, top, left){
			let widgetLayer = new window.top.document.LayerModal({
				id : 'widgetLayer' //식별자ID
				, url : '/CommonCodeLayer.do?cmd=viewCommonRdLayer' //팝업에 띄울 화면 jsp
				, parameters : {
					"p" : result.DATA.path,
					"d" : result.DATA.encryptParameter,
					"o" : opt,
					"u" : url,
					"ud": data
				}
				, width : (cW != null && cW != undefined)?cW:1000
				, height : (cH != null && cH != undefined)?cH:800
				, top : (top != null && top != undefined) ? top : 0
				, left : (left != null && left != undefined) ? left : 0
				, title : (title != null && title != undefined)?title:'-'
				, trigger :[ //콜백
					{
						name : 'widgetLayerTrigger'
						, callback : function(rv){
						}
					}
				]
			});
			widgetLayer.show();
		}
	</script>
</head>
<body class="main-body">
<%@ include file="/WEB-INF/jsp/common/include/header.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/lnb.jsp"%>
<!-- 신규 LEFT MENU END -->

<main id="container">
	<div>
		<iframe id="vueMainFrame" src="/RedirectVue.do"  frameborder='0' class='tab_iframes vueLayout'></iframe>
	</div>
</main>
<!-- 공통코드 레이어 팝업  -->
<%@ include file="/WEB-INF/jsp/common/include/commonLayerPopup.jsp"%>
<%@ include file="/WEB-INF/jsp/common/include/commonLayer.jsp"%>
</body>
</html>