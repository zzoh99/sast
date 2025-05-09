package com.hr.common.classPath;

import com.hr.common.logger.Log;
import com.hr.common.util.classPath.CoreClassPathResolver;
import org.apache.commons.lang3.StringUtils;
import org.apache.commons.lang3.exception.ExceptionUtils;
import org.springframework.stereotype.Component;
import org.springframework.util.ResourceUtils;

/**
 * ClassPath 하위의 물리 경로를 취득하기 위한 Util
 */
@Component
public class ClassPathUtilImpl implements CoreClassPathResolver {
	/**
	 * 내장 톰캣 사용시 상수 값 Sample
	* */
	private static final String STATIC_PATH = "static";
	private static final String HRFILE_PATH = STATIC_PATH + "/hrfile";
	private static final String OPTI_PATH = "opti";
	private static final String FILEUPLOAD_PATH = "fileupload";
	private static final String LICENSE_ENC = "6feee20077cbfac997b68d6ab20a85a07b0c1993ff68cd3fe46832bc3b811036";

	/**
	 * AS-IS (외부 WAS 사용시 상수 값 Sample)
	 * */
//	private static final String STATIC_PATH = "/static";
//	private static final String HRFILE_PATH = STATIC_PATH + "/hrfile/";
//	private static final String OPTI_PATH = "/opti";
//	private static final String FILEUPLOAD_PATH = "/fileupload";
//	private static final String LICENSE_ENC = "c38f27b8666fe49f67babdd7662d6e0b5692d21e882c5d4a2d67a4b806afa2a5";

	@Override
	public String getClassPath(String path) {
		try {
			return ResourceUtils.getFile(ResourceUtils.CLASSPATH_URL_PREFIX + path).getAbsolutePath();
		} catch (Exception e) {
			Log.Debug(ExceptionUtils.getStackTrace(e));
			return StringUtils.EMPTY;
		}
	}

	@Override
	public String getClassPathRoot() {
		return getClassPath(StringUtils.EMPTY);
	}

	@Override
	public String getClassPathStatic() {
		return getClassPath(STATIC_PATH);
	}

	@Override
	public String getClassPathHrfile() {
		return getClassPath(HRFILE_PATH);
	}

	@Override
	public String getOptiPropertiesPath() {
		return OPTI_PATH;
	}

	@Override
	public String getFileuploadPropertiesPath() {
		return FILEUPLOAD_PATH;
	}

	@Override
	public String getLicenseEnc() {
		return LICENSE_ENC;
	}

	@Override
	public String getCPath() {
		return "static/c.js";
	}
}
