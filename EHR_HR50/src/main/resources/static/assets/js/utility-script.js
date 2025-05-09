/**
 * 유틸리티 공통 스크립트
 * author : cjopark
 */
;(function(window, document, $){
    'use strict';
    if(!window.Utils) window.Utils = new UtilityScript();

    function UtilityScript(){}

    ///////////////////////////////////
    // etc
    ///////////////////////////////////
    UtilityScript.prototype.encase = function(str){
        return '[' + str + ']';
    };
    UtilityScript.prototype.isEmpty = function(obj){
        return obj === '' || obj === null || obj === undefined;
    };
    UtilityScript.prototype.isNull = function(obj){
        return obj === null || obj === undefined;
    }
    UtilityScript.prototype.forEach = function(arr, callback){
        for(let i=0; i<arr.length; i++){
            callback(arr[i], i);
        }
    };
    UtilityScript.prototype.comma = function(num){
        return num.replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ',');
    };

    ///////////////////////////////////
    // Promise
    ///////////////////////////////////
    /**
     * 비동기 callback
     * @param callback
     * @returns {*}
     */
    UtilityScript.prototype.promise = function(callback){
        const deferred = $.Deferred();
        try{
            callback();
            deferred.resolve();
        }catch(error){
            deferred.reject(error);
        }
        return deferred.promise();
    }

    ///////////////////////////////////
    // HTTP
    ///////////////////////////////////
    UtilityScript.prototype.createRequestParameter = function(obj){
        if(typeof obj !== 'object') return obj;
        let result = [];
        for(let key in obj){
            result.push(key + '=' + obj[key]);
        }
        return result.join('&');
    };

    ///////////////////////////////////
    // Calendar
    ///////////////////////////////////
    /**
     * id로 캘린더 데이터를 검색한다
     * @param calendar
     * @param id
     * @returns {{}|*}
     */
    UtilityScript.prototype.resource = function(calendar, id){
        const resources = calendar.getEventSources();
        if(resources.length === 0 || !id) return {};

        const raw = calendar.getEventSources()[0].internalEventSource._raw;
        for(let i=0; i<raw.length; i++){
            if(raw[i].id === id) return raw[i];
        }
        return {};
    };
    /**ㅇ
     * 캘린더의 모든 데이터를 검색한다
     * @param calendar
     * @returns {*}
     */
    UtilityScript.prototype.resources = function(calendar){
        return calendar.getEventSources();
    };

    ///////////////////////////////////
    // Date
    ///////////////////////////////////
    /**
     * Date 객체의 현재 년도를 구한다
     * @param date
     * @returns {number}
     */
    UtilityScript.prototype.dateYear = function(date){
        return date.getFullYear() + '';
    };
    /**
     * Date 객체의 현재 월을 구한다
     * @param date
     * @returns {string}
     */
    UtilityScript.prototype.dateMonth = function(date){
        const month = date.getMonth() + 1;
        return (month < 10) ? '0' + month : month + '';
    }
    /**
     * Date 객체의 현재 일자를 구한다
     * @param date
     * @returns {*}
     */
    UtilityScript.prototype.dateDay = function(date){
        const day = date.getDate();
        return (day < 10) ? '0' + day : day + '';
    };
    /**
     * 현재 년월일을 구한다
     * @param separator
     * @returns {string}
     */
    UtilityScript.prototype.currentDate = function(separator){
        const separate = separator || '';
        const today = new Date();
        const year = this.dateYear(today);
        let month = this.dateMonth(today);
        let day = this.dateDay(today);
        return year + separate
            + lpad(month, '0', 2) + separate
            + lpad(day, '0', 2);
    };
    /**
     * Date 객체를 string 타입으로 변경한다
     * @param date
     * @param separator
     * @returns {string}
     */
    UtilityScript.prototype.parseDate = function(date, separator){
        if(typeof date === 'string') date = new Date(date);
        const separate = separator || '';
        const year = this.dateYear(date);
        let month = this.dateMonth(date);
        let day = this.dateDay(date);
        return year + separate
            + month.padStart(2, '0') + separate
            + day.padStart(2, '0');
        /*
        return year + separate
            + ((month < 10) ? '0' + month : month) + separate
            + ((day < 10) ? '0' + day : day);

         */
    };
    /**
     * 현재 년/월의 첫번째 일자를 구한다
     * @param separator
     * @returns {string}
     */
    UtilityScript.prototype.firstDayMonth = function(separator){
        return this.parseFirstDayMonth(new Date(), separator);
    };
    /**
     * 현재 년/월의 마지막 일자를 구한다
     * @param separator
     * @returns {string}
     */
    UtilityScript.prototype.lastDayMonth = function(date, separator){
        return this.parseLastDayMonth(date, separator);
    };
    /**
     * Date 년/월의 첫번째 일자를 구한다
     * @param date
     * @param separator
     * @returns {string}
     */
    UtilityScript.prototype.parseFirstDayMonth = function(date, separator){
        if(typeof date === 'string') date = new Date(date);
        const separate = separator || '';
        return this.parseDate(
            new Date(date.getFullYear(), date.getMonth(), 1)
            , separate
        );
    };
    /**
     * Date 년도의 첫번째 달 첫번째 일자를 구한다
     * @param date
     * @param separator
     * @returns {string}
     */
    UtilityScript.prototype.parseFirstDayYear = function(date, separator){
        if(typeof date === 'string') date = new Date(date);
        const separate = separator || '';
        return this.parseDate(
            new Date(date.getFullYear(), 0, 1)
            , separate
        );
    };
    /**
     * Date 년/월의 마지막 일자를 구한다
     * @param date
     * @param separator
     * @returns {string}
     */
    UtilityScript.prototype.parseLastDayMonth = function(date, separator){
        if(typeof date === 'string') date = new Date(date);
        const separate = separator || '';
        return this.parseDate(
            new Date(date.getFullYear(), date.getMonth() + 1, 0)
            , separate
        );
    };
    /**
     * Date 에 구분자를 추가한다
     * @param date
     * @param separator
     * @returns {*|string}
     */
    UtilityScript.prototype.addDateSeparator = function(date, separator){
        if(typeof date === 'object') return date;
        date = date.replace(/[\{\}\[\]\/?.,;:|\)*~`!^\-_+<>@\#$%&\\\=\(\'\"]/g, '');
        while(date.length === 8) date += '0';

        const separate = separator || '';
        const year = date.substring(0, 4);
        const month = date.substring(4, 6);
        const day = date.substring(6, 8);
        return year + separate + month + separate + day;
    }

})(window, document, jQuery);