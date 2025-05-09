package com.hr.api.common.wrapper;

import com.hr.api.common.util.AES256;
import com.hr.common.util.CryptoUtil;
import org.apache.commons.io.IOUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.HttpMethod;
import org.springframework.util.StringUtils;

import javax.servlet.ReadListener;
import javax.servlet.ServletInputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletRequestWrapper;
import java.io.*;
import java.nio.charset.Charset;
import java.security.GeneralSecurityException;
import java.security.NoSuchAlgorithmException;
import java.util.*;
import java.util.stream.Stream;

public class Api50RequestWrapper extends HttpServletRequestWrapper {

    private final Logger logger = LoggerFactory.getLogger(this.getClass());
    private final Charset encoding;
    private byte[] rawData;
    private Map<String, String[]> params = new HashMap<>();

    private HttpServletRequest request;
    private ResettableServletInputStream servletStream;
    private String aesKey;

    /**
     * Constructs a request object wrapping the given request.
     *
     * @param request
     * @throws IllegalArgumentException if the request is null
     */
    public Api50RequestWrapper(HttpServletRequest request) {
        super(request);
        this.encoding = Charset.forName("UTF-8");
    }
    public Api50RequestWrapper(HttpServletRequest request, String aesKey) {
        super(request);
        this.request = request;
        this.servletStream = new ResettableServletInputStream();
        this.encoding = Charset.forName("UTF-8");
        this.aesKey = aesKey; // getAuthorization(request);
        String body = null;
        try {
            body = IOUtils.toString(this.getReader());
            logger.debug(":: body :: {} ", body);
        } catch (IOException e1) {
            e1.printStackTrace();
        }

        if(HttpMethod.GET.name().equals(((HttpServletRequest) request).getMethod())){
            Enumeration<String> e = ((HttpServletRequest) request).getParameterNames();
            while(e.hasMoreElements()) {
                String fieldName = e.nextElement();
                String value = request.getParameter(fieldName);
                setParameter(fieldName, value);
            }
        } else {
            if (!StringUtils.isEmpty(body)) {
                try {
                    JSONArray oldJsonArray = new JSONArray(body);
                    JSONArray newJsonArray = new JSONArray();
                    oldJsonArray.forEach(item -> {
                        if (item instanceof JSONObject) {
                            String strObject = item.toString();
                            JSONObject jsonObject = CryptoUtil.cryptoParameter(strObject, "D", this.aesKey, request);
                            newJsonArray.put(jsonObject);
                        } else {
                            newJsonArray.put(item);
                        }
                    });
                    this.resetInputStream(newJsonArray.toString().getBytes(this.encoding));
                } catch(JSONException e) {
                    JSONObject newJsonObject = CryptoUtil.cryptoParameter(body, "D", this.aesKey, request);
                    this.resetInputStream(newJsonObject.toString().getBytes(this.encoding));
                }
            }
        }


        logger.debug(":::: body ::: {} ", body);

    }


    public void resetInputStream(byte[] newRawData) {
        servletStream.stream = new ByteArrayInputStream(newRawData);
    }

    @Override
    public ServletInputStream getInputStream() throws IOException {
        if (rawData == null) {
            rawData = IOUtils.toByteArray(this.request.getReader());
            servletStream.stream = new ByteArrayInputStream(rawData);
        }
        return servletStream;
    }

    @Override
    public BufferedReader getReader() throws IOException {
        if (rawData == null) {
            rawData = IOUtils.toByteArray(this.request.getReader());
            servletStream.stream = new ByteArrayInputStream(rawData);
        }
        return new BufferedReader(new InputStreamReader(servletStream));
    }

    @Override
    public String getParameter(String name) {
        String[] paramArray = getParameterValues(name);
        if (paramArray != null && paramArray.length > 0) {
            return paramArray[0];
        } else {
            return null;
        }
    }

    @Override
    public Map<String, String[]> getParameterMap() {
        return Collections.unmodifiableMap(params);
    }

    @Override
    public Enumeration<String> getParameterNames() {
        return Collections.enumeration(params.keySet());
    }

    @Override
    public String[] getParameterValues(String name) {
        String[] result = null;
        String[] dummyParamValue = params.get(name);

        if (dummyParamValue != null) {
            result = new String[dummyParamValue.length];
            System.arraycopy(dummyParamValue, 0, result, 0, dummyParamValue.length);
        }
        return result;
    }

    public void setParameter(String name, String value) {
        try {
            if(name != null && Arrays.asList(CryptoUtil.encParam).contains(name.toLowerCase()) && !StringUtils.isEmpty(value) && this.aesKey != null) {
                AES256 aes = new AES256(this.aesKey);
                value = aes.decrypt(value);
            }
				/*
				else if ("category".equals(name) && (value.contains("& #40;") || value.contains("& #41;"))) {
					value = value.replaceAll("& #40;", "(").replaceAll("& #41;", ")");
				}
				*/
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        } catch (GeneralSecurityException e) {
            e.printStackTrace();
        } catch (UnsupportedEncodingException e) {
            e.printStackTrace();
        } catch (IllegalArgumentException e) {
            e.printStackTrace();
        }

        String[] param = null;
        if (params.containsKey(name)) {
            param = Stream.concat(Arrays.stream(params.get(name)), Arrays.stream(new String[] { value })).toArray(String[]::new);
        } else {
            param = new String[] { value };
        }

        setParameter(name, param);
    }

    public void setParameter(String name, String[] values) {
        params.put(name, values);
    }

    private class ResettableServletInputStream extends ServletInputStream {

        private InputStream stream;

        @Override
        public int read() throws IOException {
            return stream.read();
        }

        @Override
        public boolean isFinished() {
            // TODO Auto-generated method stub
            return false;
        }

        @Override
        public boolean isReady() {
            // TODO Auto-generated method stub
            return false;
        }

        @Override
        public void setReadListener(ReadListener listener) {
            // TODO Auto-generated method stub

        }
    }

}
