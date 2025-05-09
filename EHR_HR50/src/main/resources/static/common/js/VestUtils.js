/**
 * Vest Utils
 *
 * <pre>
 * YettieSoft Vest 난독화 관련 유틸
 *
 * Vest 난독화 유틸을 이용하여 ajax 통신을 위한 공통 처리 작업
 * HTML5 표준 XMLHttpRequest 를 override 하여 모든 통신(ajax, IBSheet doSearch 등...) 시 전처리로 Vest 난독화 작업을 진행 처리해준다.
 *
 * [2024.06.12 Update]
 *  1. 서버 페이징을 사용할 이유가 없어 JSP -> 정적 javascript 로 변경.
 *  2. 중복 로드로 인한 스크립트 오류 방지 코드 추가.
 *
 * [2025.04.09 Update]
 *  1. Fetch API 사용 시에도 난독화 처리될 수 있도록 소스 추가.
 * </pre>
 */

var VestUtils = {

    // Vest 난독화 여부
    ENC_YN: true,

    /**
     * 파라미터 난독화
     *
     * @param param 난독화할 파라미터
     * @returns 난독화된 파라미터
     */
    encParam: function(param) {
        //console.log("not encrypted params", param);
        if (this.isEmptyObj(param)) return "";

        if (this.isJsonObject(param)) {
            if (typeof VestAjaxJson !== 'function') return param; // 난독화 관련 function 존재 여부

            return JSON.stringify(VestAjaxJson(param));
        } else {
            if (typeof VestAjaxExt !== 'function') return param; // 난독화 관련 function 존재 여부

            return VestAjaxExt(this.getRemovedFirstAtParamString(param));
        }
    },

    /**
     * JSON 객체 여부 취득
     *
     * @param obj JSON 객체 여부롤 판단할 객체
     * @returns boolean JSON 객체 여부
     */
    isJsonObject: function(obj) {
        try {
            let json;
            if (typeof obj === 'object') {
                json = JSON.parse(JSON.stringify(obj));
            } else {
                json = JSON.parse(obj);
            }

            return (typeof json === 'object');
        } catch (e) {
            return false;
        }
    },

    /**
     * 빈 객체 여부 취득
     *
     * @param obj 빈 객체 여부롤 판단할 객체
     * @returns boolean 빈 객체 여부
     */
    isEmptyObj: function(obj) {
        return obj === undefined || obj === null || obj === '';
    },

    /**
     * 난독화 여부 조회.
     * 난독화 제외 case
     * 1. 파라미터 중 vestEncYn 값이 N일 경우
     * 2. 파일첨부일 경우
     * 3. 파라미터에 NOT_INCLUDE_KEYS 에 포함된 key 값을 가진 경우
     *
     * @param argStr 파라미터 String
     * @return boolean 난독화여부
     */
    isEnc: function(argStr) {
        const NOT_INCLUDE_KEYS = ["mrd_path", "rk"]; // 파라미터에 해당 키를 가지고 있는 경우 난독화하지 않는다. (RD 출력물 등을 위해)

        if (argStr instanceof FormData) return false; // 파일첨부의 경우 난독화 실행하지 않음.
        if (typeof argStr !== "string") return this.ENC_YN;

        if (this.isJsonObject(argStr)) {
            // JSON Object 형태의 파라미터 String 인 경우
            const jsonObj = JSON.parse(argStr);
            const isEncByChk = (Object.keys(jsonObj).filter(key => NOT_INCLUDE_KEYS.includes(key) || (key === "vestEncYn" && jsonObj["vestEncYn"] === "N")).length === 0);
            return isEncByChk && this.ENC_YN;
        } else {
            // 일반 파라미터 String 인 경우
            const isEncByChk = (argStr.split("&").filter(str => NOT_INCLUDE_KEYS.includes(str.split("=")[0]) || (str === "vestEncYn=N")).length === 0);
            return isEncByChk && this.ENC_YN;
        }
    },

    /**
     * JSON 을 QueryString 으로 변환
     *
     * @param objJson QueryString 으로 변환할 JSON 객체
     * @returns String QueryString 으로 변환된 문자열
     */
    convertJsonToQueryString: function(objJson) {
        if (this.isEmptyObj(objJson)) return "";

        try {
            return Object.entries(objJson).map(([key, value]) => (value && encodeURIComponent(key) + '=' + encodeURIComponent(value))).filter(v => v).join('&');
        } catch (e) {
            return "";
        }
    },

    /**
     * String 형태의 파라미터 제일 앞에 & 이 있는 경우 삭제하여 반환. 복호화 시 가장 앞에 & 표기가 있을 경우 에러를 발생함.
     * @param paramStr 파라미터 String
     * @returns {*|string} 반환된 값
     */
    getRemovedFirstAtParamString: function(paramStr) {
        if (typeof paramStr !== 'string') return paramStr;

        if (paramStr.indexOf("&") === 0) return paramStr.substring(1);
        else return paramStr;
    }
};


(function(open, send) {
    // 중복 로드로 인한 오류 방지
    if (!window.isLoadedVestUtils) window.isLoadedVestUtils = true;
    else return;


    // HTML5 표준 XMLHttpRequest open, send function 의 prototype 을 재정의.
    // GET 메소드의 경우 open 시에 파라미터를 URL 과 같이 전달하기 때문에 open 에서 난독화를 진행한다.
    XMLHttpRequest.prototype.open = function(method, url, async) {
        // method 가 GET 인 경우 파라미터가 url 에 붙어 오기 때문에 open 시에도 url 난독화를 진행한다.
        if (method.toUpperCase() === "GET" && arguments[1]) {
            const urlArray = arguments[1].split("?");
            if (urlArray[1] && VestUtils.isEnc(urlArray[1])) {
                arguments[1] = urlArray[0] + "?" + VestUtils.encParam(urlArray[1]);
            }
        }

        open.apply(this, arguments);
    }

    // POST 메소드의 경우 send 시에 파라미터 데이터를 body 로 전달하기 때문에 send 에서 난독화 처리를 해야한다.
    XMLHttpRequest.prototype.send = function(body) {
        const callback = this.onreadystatechange;
        this.onreadystatechange = function() {
            if (callback) {
                callback.apply(this, arguments);
            }
        }

        const onload = this.onload;
        this.onload = function() {
            if (onload) {
                onload.apply(this, arguments);
            }
        }

        const onloadstart = this.onloadstart;
        this.onloadstart = function() {
            if (onloadstart) {
                onloadstart.apply(this, arguments);
            }
        }

        try {
            if (VestUtils.isEnc(arguments[0])) {
                // 난독화
                arguments[0] = VestUtils.encParam(arguments[0]);
            }
        } catch(e) {
            console.error(e);
        }

        send.apply(this, arguments);
    }
}(XMLHttpRequest.prototype.open, XMLHttpRequest.prototype.send));

/**
 * Fetch API 에서 VestWeb 난독화 솔루션을 적용하기 위한 재정의
 */
var {fetch: origFetch} = window;
window.fetch = async (...args) => {
    const isGETMethod = (args[1].method === "GET");
    if (isGETMethod) {
        // method 가 GET 인 경우 파라미터가 url 에 붙어 오기 때문에 url에서 난독화를 진행한다.
        const urlArray = args[0].split("?");
        if (urlArray[1] && VestUtils.isEnc(urlArray[1])) {
            args[0] = urlArray[0] + "?" + VestUtils.encParam(urlArray[1]);
        }
    } else {
        const body = args[1].body;
        if (body && VestUtils.isEnc(body)) {
            // 난독화
            args[1].body = VestUtils.encParam(body);
        }
    }
    return await origFetch(...args);
}
