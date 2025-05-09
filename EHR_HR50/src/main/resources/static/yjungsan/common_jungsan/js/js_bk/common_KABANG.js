/**
 * 공통 코드 조회에서 조회된 데이터를 IBsheet에서 Combo형태로 쓰는 형태로 구성 [0] name: A|B|C|D|E [1] cd:
 * 1|2|3|4|5 [2] <option value="cd">name<option>
 *
 * @param obj
 * @param str
 * @returns Array
 */
function convCode(obj, str) {
    // JNS 수정 : 코드 리스트가 없을 경우 empty Data 생성후 리턴
    // modify Date : 2014-01-20
    //	if (null == obj || obj == 'undefine') return false;
    //	if (obj.length < 1) return false;
    var convArray = new Array("", "", "");
    if (null == obj || obj == 'undefine') {

        convArray[0] = "";
        convArray[1] = "";
        convArray[2] = "<option value=''>" + str + "</option>";
        return convArray;
    }
    if (obj.length < 1) {

        convArray[0] = "";
        convArray[1] = "";
        convArray[2] = "<option value=''>" + str + "</option>";
        return convArray;
    }


    if (str != "") convArray[2] += "<option value=''>" + str + "</option>";

    for (i = 0; i < obj.length; i++) {
        convArray[0] += obj[i].codeNm + "|";
        convArray[1] += obj[i].code + "|";
        convArray[2] += "<option value='" + obj[i].code + "'>" + obj[i].codeNm + "</option>";
        convArray[3] += "<option value='" + obj[i].code + "'>[" + obj[i].code + "]" + obj[i].codeNm + "</option>";
        convArray[4] += "[" + obj[i].code + "]" + obj[i].codeNm + "|";
    }
    convArray[0] = convArray[0].substr(0, convArray[0].length - 1);
    convArray[1] = convArray[1].substr(0, convArray[1].length - 1);
    convArray[4] = convArray[4].substr(0, convArray[4].length - 1);

    return convArray;
}