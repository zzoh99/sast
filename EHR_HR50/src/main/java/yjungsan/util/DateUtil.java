package yjungsan.util;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.hr.common.logger.Log;

/**
 * Class Name	: DateUtil
 * Description  : 날짜(양력)와 시각에 관련된 유틸리트 함수를 모아놓은 클래스
 * @since		: 2012/12/15
 * @version		: 1.0
 * @author Copyright (c) 2011 by LIG-SYSTEM, Inc. All rights reserved.
 */

public final class DateUtil {

	private static final Logger log = LoggerFactory.getLogger(DBConn.class);

	/**
	 * 기본 날짜시각 포맷형식
	 */
	//public static final String DEFAULT_DATETIME_FORMAT = "yyyy-MM-dd HH:mm:ss";
	public static final String DEFAULT_DATETIME_FORMAT = "yyyyMMddHHmmss";

	/**	Format pattern HTTP = "EEE, dd MMM yyyy HH:mm:ss 'GMT'"  	*/
	public static final int HTTP = 1;

	/** Format pattern XLF = "yyyy/MMM/dd HH:mm:ss" 				*/
	public static final int XLF = 2;

	/** Format pattern CLF = "dd/MMM/yyyy:HH:mm:ss" 				*/
	public static final int CLF = 3;

	/** Format pattern ROLLOVER = "yyyyMMdd_HHmmss" 				*/
	public static final int ROLLOVER = 4;

	/** Format pattern STANDARD = "yyyy/MM/dd HH:mm:ss z" 		*/
	public static final int STANDARD = 5;

	/** Format pattern SIMPLE = "yyyy/MM/dd HH:mm:ss" 			*/
	public static final int SIMPLE = 6;


	/**
	 * 우리나라 기본 휴일(양력만)을 저장하고 있는 문자열 배열로, <br>
	 * 1. 신　정="0101", <br>
	 * 2. 삼일절="0301", <br>
	 * ... <br>
	 * 9. 성탄절="1225" <br>
	 * 가 있음. <br>
	 * ※ 웅진의 '창립기념일' 등을 여기에 추가할 수 있음.
	 */
	public static final String[] HOLIDAYS = {
		"0101", //신　정
		"0301", //삼일절
		"0405", //식목일
		"0505", //어린이 날
		"0606", //현충일
		"0717", //제헌절
		"0815", //광복절
		"1003", //개천절
		"1225"  //성탄절
	};

	/**
	 * 입력받은 날짜(양력) 값을 가진 '달력 객체(java.util.Calendar)'를 구함.
	 * 입력되는 날짜값이 잘못되어 달력객체 생성주 오류(exception)이 발생하면,
	 * 현재 시각으로 달력객체를 설정함. (시각은 0시 0분 1초로 설정됨)
	 *
	 * @param	yyyyMMdd	날짜(양력)로 반드시 'yyyyMMdd'형만 가능
	 * @return	해당 날짜(양력 값을 가진 '달력 객체(java.util.Calendar)'(시간은 0시 0분 1초)
	 */
	public static Calendar getCalendar(String yyyyMMdd) {
		if ( yyyyMMdd==null || yyyyMMdd.trim().length()<8 ) {
			yyyyMMdd = DateUtil.getDate(); //오늘의 양력날짜를 구함(yyyyMMdd형)
		}

		Calendar cal  = Calendar.getInstance();

		try {
			String trimedDT = yyyyMMdd.trim();
			int year  = Integer.parseInt( trimedDT.substring(0, 4) );
			int month = Integer.parseInt( trimedDT.substring(4, 6) );
			int date  = Integer.parseInt( trimedDT.substring(6, 8) );
			int hour = 0, min = 0, sec = 1;

			if ( trimedDT.length() >= 10 ) { //HH 값이 있으면 (H)는 무시함
				hour = Integer.parseInt( trimedDT.substring(8, 10) );
			}
			if ( trimedDT.length() >= 12 ) { //mm 값이 있으면 (m)은 무시함
				min = Integer.parseInt( trimedDT.substring(10, 12) );
			}
			if ( trimedDT.length() >= 14 ) { //ss 값이 있으면 (s)은 무시함
				sec = Integer.parseInt( trimedDT.substring(12, 14) );
			}

			cal.set( year, month-1, date, hour, min, sec); //달은 0부터 시작하는 값임.
		}
		catch(Exception e) {
			cal.setTimeInMillis( System.currentTimeMillis() ); //디폴트 현재 시각
		}

		return cal;
	}
	/**
	 * 입력받은 날짜(양력) 값을 가진 '달력 객체(java.util.Calendar)'를 구함.
	 * 만약 입력되는 해당 필드(년/월/일) 값이 잘못된 경우 현재 시각의 필드값으로 달력객체를 설정하며,
	 * 2006/02/31 같이 입력되는 경우는 정확한 날짜인 2005/02/28로 설정하여 반환
	 * (시각은 0시 0분 1초로 설정됨)
	 *
	 * @param	year	년도 (1900 ~ 2100 사이만 허용)
	 * @param	month	월 (1 ~ 12 만 허용)
	 * @param	date	일 (1 ~ 31 만 허용)
	 * @return	달력객체
	 */
	public static Calendar getCalendar(int year, int month, int date) {
		Calendar cal = Calendar.getInstance();

		if (year< 1900 || year>2100)
			year = cal.get(Calendar.YEAR); //범위를 벗어난 년도면 현재 년도로 설정
		if (month<1 || month>12)
			month = cal.get(Calendar.MONTH) + 1; //범위를 벗어난 월이면 현재 월로 설정
		if (date<1 || date>31)
			date = cal.get(Calendar.DATE); //범위를 벗어난 일이면 현재 일로 설정

		cal.set(year, month-1, date, 0, 0, 1); //달력은 0~11 까지이므로 1을 뺌

		int tmpMonth = cal.get(Calendar.MONTH) + 1;
		int tmpDate  = 28; //마지막 날짜

		//달력객체에 날짜를 설정한 결과 넘어온 달과 다르면
		//즉, (2006년 2월 31일) 로 입력값이 넘어오면 달력객체는 2006년 3월 3일로 됨.
		//이런 경우 입력자의 오류로 보고, 2월의 말일(28일 또는 29일)로 설정함.
		if (month!=tmpMonth) {
			tmpDate = getLastDate(year, month); //년월의 마지막날짜를 구함
			cal.set(year, month-1, tmpDate, 0, 0, 1); //달력은 0~11 까지이므로 1을 뺌
		}

		return cal;
	}

	/**
	 * 입력받은 (년/월) 값을 가진 '달력 객체(java.util.Calendar)'를 구함.
	 * 이때 날짜는 시스템의 오늘날짜(1~31)로 설정하지만,
	 * 만약 입력 년/월에 오늘 날짜가 없는 경우
	 * (예, 오늘=1월 31일이고, 입력은 2006년/2월 로 하면, 2월/31일은 없으므로
	 *  2월 28일로 설정해야 맞음)
	 * 해당월의 마지막 날짜로 설정(시각은 0시 0분 1초로 설정됨)
	 *
	 * @param	year	년도 (1900 ~ 2100 사이만 허용)
	 * @param	month	월 (1 ~ 12 만 허용)
	 * @return	달력객체
	 */
	public static Calendar getCalendar(int year, int month) {
		Calendar cal = Calendar.getInstance();

		if (year< 1900 || year>2100)
			year = cal.get(Calendar.YEAR); //범위를 벗어난 년도면 현재 년도로 설정
		if (month<1 || month>12)
			month = cal.get(Calendar.MONTH) + 1; //범위를 벗어난 월이면 현재 월로 설정

		int toDate   = cal.get(Calendar.DATE); //날짜는 오늘(시스템날짜)

		cal.set(year, month-1, toDate, 0, 0, 1); //달력은 0~11 까지이므로 1을 뺌

		int tmpMonth = cal.get(Calendar.MONTH) + 1;
		int tmpDate  = 28; //마지막 날짜

		//달력객체에 날짜를 설정한 결과 넘어온 달과 다르면
		//즉, 오늘이 1월 31일이여서 (2006년 2월) 로 달력을 설정하고자 하면,
		//달력객체는 2006년 2월 28일로 설정되어야 정확한 것임.
		if (month!=tmpMonth) {
			tmpDate = getLastDate(year, month); //해당 년월의 마지막날짜를 구함
			cal.set(year, month-1, tmpDate, 0, 0, 1); //달력은 0~11 까지이므로 1을 뺌
		}

		return cal;
	}

	/**
	 * 밀리초(Milli-Second)를 읽기 원하는 형식의 문자열로 구성하여 반환 <p>
	 *
	 * [형식 예] <br>
	 * 1. "yyyy-MM-dd HH:mm:ss" = "2004-01-31 09:31:01" <br>
	 * 2. "HH:mm:ss(SSS)" = "09:31:01(099)" <br>
	 * 3. 기타 자바 형식이 지원하는 Date-Format (see : java.util.Calendar, java.text.SimpleDateFormat)
	 *
	 * @param timeMillis      밀리초 타입의 구하려는 날짜시각
	 * @param wantedFormat    반환되는 날짜의 포맷형(null이면 기본 yyyy-MM-dd HH:mm:ss 형)
	 * @return	원하는 형식으로 포맷된 날짜시각 문자열
	 */
	public static String getDateTime(long timeMillis, String wantedFormat) {
		if (wantedFormat==null || wantedFormat.trim().equals(""))
			wantedFormat = DEFAULT_DATETIME_FORMAT;

		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(timeMillis);

		SimpleDateFormat sdf;
		String formatted;
		try {
			sdf = new SimpleDateFormat(wantedFormat, Locale.KOREA);
			formatted = sdf.format( cal.getTime() );
		}
		catch(IllegalArgumentException iae) {
            sdf = new SimpleDateFormat(DEFAULT_DATETIME_FORMAT, Locale.KOREA);
			formatted = sdf.format( cal.getTime() );
		}

        return formatted;
	}

	/**
	 * 현재 시스템 날짜시각을 '원하는' 형식의 문자열로 반환
	 *
	 * @return	원하는 형식으로 포맷된 현재 날짜시각 문자열
	 */
	public static String getDateTime(String wantedFormat) {
		return getDateTime(System.currentTimeMillis(), wantedFormat);
	}

	/**
	 * 입력받은 달력객체의 값을 원하는 날짜표현 형식으로 반환 <p>
	 *
	 * [형식 예] <br>
	 * 1. "yyyy-MM-dd HH:mm:ss" = "2004-01-31 09:31:01" <br>
	 * 2. "HH:mm:ss(SSS)" = "09:31:01(099)" <br>
	 * 3. 기타 자바 형식이 지원하는 Date-Format (see : java.util.Calendar, java.text.SimpleDateFormat)
	 *
	 * @param calendar      달력객체
	 * @param wantedFormat	반환되는 날짜의 포맷형(null이면 기본 yyyy-MM-dd HH:mm:ss 형)
	 * @return	원하는 형식으로 포맷된 날짜시각 문자열
	 */
	public static String getDateTime(Calendar calendar, String wantedFormat) {
		if (wantedFormat==null || wantedFormat.trim().equals(""))
			wantedFormat = DEFAULT_DATETIME_FORMAT;
		if (calendar==null)
			calendar = Calendar.getInstance(); //달력객체가 null이면 새로운 인스턴스를 만듬

		SimpleDateFormat sdf;
		String formatted;
		try {
			sdf = new SimpleDateFormat(wantedFormat, Locale.KOREA);
			formatted = sdf.format( calendar.getTime() );
		}
		catch(IllegalArgumentException iae) {
            sdf = new SimpleDateFormat(DEFAULT_DATETIME_FORMAT, Locale.KOREA);
			formatted = sdf.format( calendar.getTime() );
		}

        return formatted;
	}

	/**
	 * 현재 시스템 날짜시각을 "yyyyMMddHHmmss" 형식의 문자열로 반환
	 *
	 * @return	"yyyyMMddHHmmss" 형식의 현재 시스템 날짜시각 문자열
	 */
	public static String getDateTime() {
		return getDateTime(System.currentTimeMillis(), "yyyyMMddHHmmss");
	}

	/**
	 * 현재 시스템 날짜시각을 "yyyyMMdd" 형식의 문자열로 반환
	 *
	 * @return	"yyyyMMdd" 형식의 현재 시스템 날짜시각 문자열
	 */
	public static String getDate() {
		return getDateTime(System.currentTimeMillis(), "yyyyMMdd");
	}

	/**
	 * 현재 시스템 날짜시각을 "HHmmss" 형식의 문자열로 반환
	 *
	 * @return	"HHmmss" 형식의 현재 시스템 날짜시각 문자열
	 */
	public static String getTime() {
		return getDateTime(System.currentTimeMillis(), "HHmmss");
	}

	/**
	 * 해당 년월의 마지막 날짜를 구하여 반환
	 *
	 * @return	"HHmmss" 형식의 현재 시스템 날짜시각 문자열
	 *
	 * @param	year	년도(1900~2100) 까지만 허용
	 * @param	month	월(1~12)까지 범위
	 * @return
	 */
	public static int getLastDate(int year, int month) {
		Calendar cal = Calendar.getInstance();

		if (year< 1900 || year>2100)
			year = cal.get(Calendar.YEAR); //범위를 벗어난 년도면 현재 년도로 설정
		if (month<1 || month>12)
			month = cal.get(Calendar.MONTH) + 1; //범위를 벗어난 월이면 현재 월로 설정

		cal.set(year, month-1, 28); //달력은 0~11 까지이므로 1을 뺌

		//28, 29, 30, 31일중 하나임
		for(int i=28; i<31; i++) {
			cal.add(Calendar.DATE, 1); //하루를 더함
			int newMonth = cal.get(Calendar.MONTH) + 1; //달의 수를 구함 (1~12)
			if (month!=newMonth) { //하루를 더한결과 달이 바뀌었다면 해당일자가 그달의 마지막 날짜임
				return i;
			}
		}

		return 31;
	}

	/**
	 * 해당 년월의 마지막 날짜를 구하여 반환
	 *
	 * @return	"HHmmss" 형식의 현재 시스템 날짜시각 문자열
	 *
	 * @param	cal		달력객체(null일 경우 시스템 현재시각으로 설정함)
	 * @return	해당 달력객체의 '월'의 마지막 날짜(28 ~ 31일)
	 */
	public static int getLastDate(Calendar cal) {
		if (cal==null)
			cal = Calendar.getInstance();

		int orgMonth = cal.get(Calendar.MONTH);
		Calendar calTmp = (Calendar)cal.clone(); //입력객체의 복사본을 만들어 날짜 조작함.
		calTmp.set(Calendar.DATE, 28); //복사본 객체에 28일로 설정

		//28, 29, 30, 31일중 하나임
		for(int i=28; i<31; i++) {
			calTmp.add(Calendar.DATE, 1); //하루를 더함
			int newMonth = calTmp.get(Calendar.MONTH); //달의 수를 구함
			if (orgMonth!=newMonth) { //하루를 더한 결과 달이 바뀌었다면 해당일자가 그달의 마지막 날짜임
				return i;
			}
		}

		return 31;
	}

	/**
	 * 해당 년월에 입력받은 숫자만큼 월을 증가/감소
	 *
	 * @return	"yyyy-mm" 형식의 년월 문자열
	 *
	 * @param	year	년도(1900~2100) 까지만 허용
	 * @param	month	월(1~12)까지 범위
	 * @return
	 */
	public static String getMonthAdd(String sYear, String sMonth, int add) {

		int year = Integer.parseInt(sYear);
		int month = Integer.parseInt(sMonth);

		int yr, mt;
		if (month<=0)
			mt = 1;
		else if (month>12)
			mt = 12;
		else
			mt = month;

		yr = year;

		Calendar cal = Calendar.getInstance();
		cal.set(yr, mt-1, 28); //달력은 0~11 까지이므로 1을 뺌
		cal.add(Calendar.MONTH, add);

		String mm = String.valueOf(cal.get(Calendar.MONTH) + 1);
		if ((cal.get(Calendar.MONTH) + 1) < 10)	mm = "0" + String.valueOf(cal.get(Calendar.MONTH) + 1);

		String yyyy = String.valueOf(cal.get(Calendar.YEAR));

		return yyyy + "-" + mm;
	}

	/**
	 * 해당 년월에 입력받은 숫자만큼 월을 증가/감소
	 *
	 * @return	"yyyymm" 형식의 년월 문자열
	 *
	 * @param	year	년도(1900~2100) 까지만 허용
	 * @param	month	월(1~12)까지 범위
	 * @return
	 */
	public static String getMonthAddTight(String sYear, String sMonth, int add) {

		int year = Integer.parseInt(sYear);
		int month = Integer.parseInt(sMonth);

		int yr, mt;
		if (month<=0)
			mt = 1;
		else if (month>12)
			mt = 12;
		else
			mt = month;

		yr = year;

		Calendar cal = Calendar.getInstance();
		cal.set(yr, mt-1, 28); //달력은 0~11 까지이므로 1을 뺌
		cal.add(Calendar.MONTH, add);

		String mm = String.valueOf(cal.get(Calendar.MONTH) + 1);
		if ((cal.get(Calendar.MONTH) + 1) < 10)	mm = "0" + String.valueOf(cal.get(Calendar.MONTH) + 1);

		String yyyy = String.valueOf(cal.get(Calendar.YEAR));

		return yyyy + mm;
	}

	/**
	 * 입력 (년/월/일)에 따라 '월'을 증가하여 원하는 날짜 포맷으로 반환함.
	 *
	 * @param currYear	입력 년도
	 * @param currMonth	입력 월(1 ~ 12임, 0~11이 아님)
	 * @param currDate	입력 일(1~31)
	 * @param add		월 증감분(음수값이면 이전 월)
	 * @param format	반환할 날짜 포맷으로 null이면 기본 "yyyyMMddHHmmss"
	 * @return	입력 (년/월/일)에 월을 증감하여 최종 계산된 날짜의 원하는 포맷 문자열
	 * @see		DateUtil#getCalendar(int, int)
	 */
	public static String addMonth(int currYear, int currMonth, int currDate,
								  int add, String format) {
		Calendar cal = DateUtil.getCalendar( currYear, currMonth, currDate );

		cal.add(Calendar.MONTH, add);

		return getDateTime(cal, format);
	}

	/**
	 * 입력 (년/월/일)에 따라 '월'을 증가하여 "yyyyMMdd" 날짜 포맷으로 반환함.
	 *
	 * @param currYear	입력 년도
	 * @param currMonth	입력 월(1 ~ 12임, 0~11이 아님)
	 * @param currDate	입력 일(1~31)
	 * @param add		월 증감분(음수값이면 이전 월)
	 * @return	입력 (년/월/일)에 월을 증감하여 최종 계산된 날짜의 원하는 포맷 문자열
	 * @see		DateUtil#getCalendar(int, int)
	 */
	public static String addMonth(int currYear, int currMonth, int currDate, int add) {
		Calendar cal = DateUtil.getCalendar( currYear, currMonth, currDate );

		cal.add(Calendar.MONTH, add);

		return getDateTime(cal, "yyyyMMdd");
	}

	/**
	 * 입력 (년/월)에 따라 '월'을 증가하여 원하는 날짜 포맷으로 반환함.
	 * 일자는 시스템 오늘 날짜를 설정함.
	 *
	 * @param currYear	입력 년도
	 * @param currMonth	입력 월(1 ~ 12임, 0~11이 아님)
	 * @param add		월 증감분(음수값이면 이전 월)
	 * @param format	반환할 날짜 포맷으로 null이면 기본 "yyyyMMddHHmmss"
	 * @return	입력 (년/월)에 월을 증감하여 최종 계산된 날짜의 원하는 포맷 문자열
	 * @see		DateUtil#getCalendar(int, int)
	 */
	public static String addMonth(int currYear, int currMonth, int add, String format) {
		Calendar cal = DateUtil.getCalendar( currYear, currMonth );

		cal.add(Calendar.MONTH, add);

		return getDateTime(cal, format);
	}

	/**
	 * 밀리초(Milli-Second)를 읽기 원하는 형식의 문자열로 구성하여 반환, 추가된 날짜 더하기 <p>
	 *
	 * [형식 예] <br>
	 * 1. "yyyy-MM-dd HH:mm:ss" = "2004-01-31 09:31:01" <br>
	 * 2. "HH:mm:ss(SSS)" = "09:31:01(099)" <br>
	 * 3. 기타 자바 형식이 지원하는 Date-Format (see : java.util.Calendar, java.text.SimpleDateFormat)
	 *
	 * @param timeMillis   밀리초 타입의 구하려는 날짜시각
	 * @param wantedFormat 반환되는 날짜의 포맷형(null이면 기본 yyyy-MM-dd HH:mm:ss 형)
	 * @param add		   날짜(일,DATE) 증감값(1이면 위 밀리초의 1일후)
	 * @return	원하는 형식으로 포맷된 날짜시각 문자열
	 */
	public static String getDateTime(long timeMillis, String wantedFormat, int add) {
		if (wantedFormat==null || wantedFormat.trim().equals(""))
			wantedFormat = DEFAULT_DATETIME_FORMAT;

		Calendar cal = Calendar.getInstance();
		cal.setTimeInMillis(timeMillis);
		cal.add(Calendar.DATE,add);

		SimpleDateFormat sdf;
		String formatted;
		try {
			sdf = new SimpleDateFormat(wantedFormat, Locale.KOREA);
			formatted = sdf.format( cal.getTime() );
		}
		catch(IllegalArgumentException iae) {
            sdf = new SimpleDateFormat(DEFAULT_DATETIME_FORMAT, Locale.KOREA);
			formatted = sdf.format( cal.getTime() );
		}

        return formatted;
	}

	/**
	 * 현재 시스템 날짜시각을 '원하는' 형식의 문자열로 반환, 추가된 날짜 더하기 <p>
	 *
	 * @param wantedFormat    반환되는 날짜의 포맷형(null이면 기본 yyyy-MM-dd HH:mm:ss 형)
	 * @param add		      추가된 날짜(음수형 가능)
	 * @return	원하는 형식으로 포맷된 현재 날짜시각 문자열
	 */
	public static String getDateTime(String wantedFormat, int add) {
		return getDateTime(System.currentTimeMillis(), wantedFormat, add);
	}

	/**
	 * 해당 날짜(yyyyMMdd 문자열)의 요일을 반환 <p>
	 *
	 * @param	yyyyMMdd    해당 날짜(yyyyMMdd 문자열)
	 * @return	해당 날짜(yyyyMMdd 문자열)의 요일(1=일요일, 2=월요일, ..., 7=토요일)
	 */
	public static int getDayOfWeek(String yyyyMMdd) {
		if ( yyyyMMdd==null || yyyyMMdd.trim().length()!=8  ) {
			yyyyMMdd = DateUtil.getDate(); //오늘날짜를 구함
		}
		Calendar cal = Calendar.getInstance();
		try {
			int year  = Integer.parseInt( yyyyMMdd.substring(0, 4) );
			int month = Integer.parseInt( yyyyMMdd.substring(4, 6) );
			int date  = Integer.parseInt( yyyyMMdd.substring(6) );
			cal.set( year, month-1, date ); //달은 0부터 시작하는 값임.
		}
		catch(Exception e) {
			Log.Debug(e.getLocalizedMessage());
		}
		int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);

		return dayOfWeek;
	}

	/**
	 * 해당 날짜(yyyyMMdd 문자열)가 토요일|일요일인지 판단 <p>
	 *
	 * @param	yyyyMMdd    해당 날짜(yyyyMMdd 문자열)
	 * @return	해당 날짜(yyyyMMdd 문자열)가 토요일|일요일이면 true를 반환
	 */
	public static boolean isWeekend(String yyyyMMdd) {
		int dayOfWeek = getDayOfWeek(yyyyMMdd);

		return (dayOfWeek==Calendar.SATURDAY || dayOfWeek==Calendar.SUNDAY);
	}

	/**
	 * 해당 달력객체의 날짜가 토요일|일요일인지 판단 <p>
	 *
	 * @param	cal    달력객체
	 * @return	해당 날짜(yyyyMMdd 문자열)가 토요일|일요일이면 true를 반환
	 */
	public static boolean isWeekend(Calendar cal) {
		int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);

		return (dayOfWeek==Calendar.SATURDAY || dayOfWeek==Calendar.SUNDAY);
	}

	/**
	 * 입력되는 2개의 달력객체의 '년/월/일'이 같으면 true를 반환
	 *
	 * @param	c1	달력객체 1
	 * @param	c2	달력객체 2
	 * @return	'년/월/일'이 같으면 true
	 */
	public static boolean isSameDate(Calendar c1, Calendar c2) {
		if (c1==null || c2==null)
			return false;
		if ( c1 == c2 )
			return true; //같은 객체(같은 주소를 가르킴)이면 true : equals 는 객체의 값을 비교함

		if ( c1.get(Calendar.YEAR) != c2.get(Calendar.YEAR) )
			return false; //년도가 다르면 false
		if ( c1.get(Calendar.MONTH) != c2.get(Calendar.MONTH) )
			return false; //월이 다르면 false
		if ( c1.get(Calendar.DATE) != c2.get(Calendar.DATE) )
			return false; //날짜가 다르면 false
		return true; //년도 & 월 & 날짜가 같으면 true
	}

	/**
	 * 입력되는 달력객체와 날짜 문자열(yyyyMMdd 이상)의 '년/월/일'이 같으면 true를 반환
	 *
	 * @param	c1	달력객체 1
	 * @param	yyyyMMdd	날짜 문자열(yyyyMMdd 이상의 날짜값을 가져야 함)
	 * @return	'년/월/일'이 같으면 true
	 */
	public static boolean isSameDate(Calendar c1, String yyyyMMdd) {
		if (c1==null || yyyyMMdd==null)
			return false;
		if (yyyyMMdd.trim().length()<6)
			return false;

		Calendar c2 = DateUtil.getCalendar(yyyyMMdd);
		return isSameDate( c1,  c2 );
	}

	/**
	 * 입력받은 달력 객체의 월/일이 해당월의 마지막날인지 판단
	 *
	 * @param	cal	달력 객체
	 * @return	해당월의 마지막 날이면 true를 반환
	 */
	public static boolean isLastDate(Calendar cal) {
		int month = cal.get(Calendar.MONTH);

		Calendar clone = (Calendar)cal.clone(); //복사본으로 날짜를 조작해야함.
		clone.add(Calendar.DATE, 1); //하루를 더함

		int monthOfNextDay = clone.get( Calendar.MONTH ); //다음날의 '월'
		boolean b = false;

		if (monthOfNextDay!=month)
			b = true; //다음 날의 달이 바뀌면 이날이 이번달의 마지막날 임
		else
			b = false; //다음날의 달이 바뀌지 않으면  이날이 이번달의 마지막날이 아님(X)
		return b;
	}

	/**
	 * 두개의 String 형태의 날짜를 입력받아 월의 차이를 리턴한다.
	 *
	 * @param	cal1 String 형태 날짜
	 * @param	cal2 String 형태 날짜
	 * @return	cal1과 cal2의 월으 차이를 리턴
	 */
	public static int getMonthBetween(String cal1, String cal2) {
		if (cal1 == null || cal2 == null || cal1.length() == 0 || cal2.length() == 0) {
			return 0;
		}

		return getMonthBetween(getCalendar(cal1), getCalendar(cal2)) ;
	}

	/**
	 * 두개의 Calendar를 입력받아 월의 차이를 리턴한다.
	 *
	 * @param	cal1 달력 객체
	 * @param	cal2 달력 객체
	 * @return	cal1과 cal2의 월으 차이를 리턴
	 */
	public static int getMonthBetween(Calendar cal1, Calendar cal2) {
		if (cal1 == null || cal2 == null) {
			return 0;
		}

		int m1 = cal1.get(Calendar.YEAR) * 12 + cal1.get(Calendar.MONTH);
		int m2 = cal2.get(Calendar.YEAR) * 12 + cal2.get(Calendar.MONTH);

		return m2 - m1;
	}
}
