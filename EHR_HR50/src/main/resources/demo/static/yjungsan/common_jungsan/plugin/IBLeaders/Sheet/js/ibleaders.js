/*
 * http://www.ibleaders.co.kr
 * Call (02)2621-2288~9
 *
 *  Copyright 2016 IB LEADERS CO. LTD.
 */
var ibleaders;
ibleaders = ibleaders || {};

ibleaders = {
    /**
     * licenseType
     *
     * enum [ "file", "value" ] default 'value'
     *
     * file로 사용할 경우 licenseType 을 명시하고 해당 프로퍼티 value로 "file" 을 설정한다.
     *
     */
    licenseType: "value",
    /**
     * license
     *
     * licenseType이 "value" 일 경우 라이선스 값을 기입한다.
     * licenseType이 "file" 일 경우 라이선스 파일 명을 기입한다.
     */
    //license: "W2FtSztPKCVyajYxYjJxbn8SYkI6RnUtOGc1emswdyJraV57HikObDUua2F+LG47JTBtVn8ZKAB2Ijo0dSd7NWRoOm0TZRZwHTdiKns+f2QuJyU3dQU9USUVZWcwYw==",
    //license: "W2FtSztPKCJyajYwYjJxbn8SYkI6RnUtOGc1emswdyJraV57HikObDUua2F+LG47JTBtVn8ZKAB2Ijo0dSd7NWRoOm0TZRZwHTdiKns+f2QuJyU3dQU8USUVZmcwYw==",
    //license: "W2FtSztPKCRzajYwYjJxbn8QYkI6RjBzODhiejdmMX8hKhknWD1XYS4gLDZpM2wrIzM/Fm5cawphfy4idCdraGJiIDEUbVw7VXVzbSgrJ3toNHMvKxx9Em1WISZpf2oqdWgiKmFsVyFLKkZ6ZTNja3RrNjJ1M3JY",
    //license: "W2FtSztPKCJyazY2YjJxbn9SMVxtHykrc3wlLXUgcDg8dUZtE3UVcGlzOS4layg+e2JjEiMdZUF4aSMieCd3NXg1PC4ZbAF8CnAoP35wPWxtL2JgLjpLKD9ZYWMzLTJ3Ij1jcDRx",
    license: "W2FtSztPKCNybDc2YjJxbn9NNREsEWIyZXElIXU8LT5/f096H2JSOnx2d2wtLH4rPDdyV2AXchxsfyIiaHptK3R/ISsZJ1wuRStveX9wJ3EuGFJIbQU8VydZbWU1YTF1ID4=",
    /*
     * iborg license value
     *
     * ibleaders.js의 ibleaders.license 를 공용으로 사용할 환경이 되지 않을 경우
     * iborg를 위한 개별 license 를 이곳에 지정한다.
     *
     */
    iborg: {
        /**
         * license
         *
         * licenseType이 "value" 일 경우 라이선스 값을 기입한다.
         * licenseType이 "file" 일 경우 라이선스 파일 명을 기입한다.
         */

        //license: "W2FtSztPKCVyajYxYjJxbn8SYkI6RnUtOGc1emswdyJraV57HikObDUua2F+LG47JTBtVn8ZKAB2Ijo0dSd7NWRoOm0TZRZwHTdiKns+f2QuJzNmNDZLKGgQYmZ8ZTV2ID1icjY="
        //license: "W2FtSztPKCdzaTYxYjJxbn8RdEIsTClxJDl5ezx/dzluNQEyRilNO3ZyNDZgLHsreyx5BSIGdQB9YDYybjgtaSsxJysAJ1kuGyxobThlNn8qdD87bA1hHTtXP3tyPiskYyImJ2AxEDROZARyOHl/JnVrKTN3MGxbKQVlTSx6PmhjZS12YDBPEiMtFTFKemcncmw2MWAw"
        //license: "W2FtSztPKCZxaTYwYjJxbn9UKR1qEGYleWR5ezx/dzluNQEyA3QSfSo9YGs9LHsreyx5BSJGM0ElPGZ/MWQzaCErYmxTMllgByMoL24wYD52ayEvdkk4TyQVZXovay8zeHBzJXYMOlIdaxg1LDRgJnZrNTJ1"
        //license: "W2FtSztPKCJyajYwYjJxbn8SYkI6RnUtOGc1emswdyJraV57HikObDUua2F+LG47JTBtVn8ZKAB2Ijo0dSd7NWRoOm0TZRZwHTdiKns+f2QuJzNmNDZLKGgQYmZ8ZDV2ID5icjY="
        //license: "W2FtSztPKCJyazY2YjJxbn9SMVxtHykrc3wlLXUgcDg8dUZtE3UVcGlzOS4layg+e2JjEiMdZUF4aSMieCd3NXg1PC4ZbAF8CnAoP35wPWxtL2JgLjpLKD9ZYWMzLTJ3Ij1jcDRx"
        //license: "W2FtSztPKCJwazY2YjJxbn9SMVxtHykrc3wlLXUgcDg8dUZtE3UVcGlzOS4layg+e2JjEiMdZUF4aSMieCd3NXg1PC4ZbAF8CnAoP35wPWxlPGJOBDB1VCIWKGIyYzR0Ijxi"
        //license: "W2FtSztPKCRzazY2YjJxbn8RdEIsTClxJDl5ezx/dzluNQEyRilNO3ZyNDZgLHsreyx5BSIGdQB9YDYybjgtaSsxJysAJ1kuGyxobThlNn8qdD87bA1hHTsdbGU4azZ+PjlicCpxSipPbBw0fypqPTMyeyEgcw0oUldgSjApMXMlPGJnN3A="
        license: "W2FtSztPKCNybDc2YjJxbn9NNREsEWIyZXElIXU8LT5/f096H2JSOnx2d2wtLH4rPDdyV2AXchxsfyIiaHptK3R/ISsZJ1wuRStveXdjJ18EEmw0cEp1WCQQZGEyYTc="
    }
};