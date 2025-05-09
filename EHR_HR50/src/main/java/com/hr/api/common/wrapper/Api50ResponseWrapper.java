package com.hr.api.common.wrapper;

import org.springframework.util.StringUtils;

import javax.servlet.ServletOutputStream;
import javax.servlet.WriteListener;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServletResponseWrapper;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStreamWriter;
import java.io.PrintWriter;

public class Api50ResponseWrapper extends HttpServletResponseWrapper {
    /**
     * Original response object
     */
    private HttpServletResponse originalResponse;
    /**
     * Output stream of cache response body (low level stream)
     */
    private ByteArrayOutputStream baos;
    /**
     * Advanced flow of output response body
     */
    private ServletOutputStream out;
    /**
     * Character stream of output response body
     */
    private PrintWriter writer;

    /**
     * Building a new response object
     *
     * @param resp Original response object
     */
    //@SneakyThrows
    public Api50ResponseWrapper(HttpServletResponse resp) {
        super(resp);
        this.originalResponse = resp;
        this.baos = new ByteArrayOutputStream();
        this.out = new SubServletOutputStream(baos);
        this.writer = new PrintWriter(new OutputStreamWriter(baos));
    }

    /**
     * GET ORI RESPONSE
     *
     * @return
     */
    public HttpServletResponse getOriginalResponse() {
        return this.originalResponse;
    }

    /**
     * Get output stream
     *
     * @return
     */
    @Override
    public ServletOutputStream getOutputStream() {
        return out;
    }

    /**
     * Get output stream (character)
     *
     * @return
     */
    @Override
    public PrintWriter getWriter() {
        return writer;
    }

    /**
     * Get response body
     *
     * @return
     * @throws IOException
     */
    public String getResponseBody() throws IOException {
        return this.getResponseBody(null);
    }

    /**
     * Get the response body through the specified character set
     *
     * @param charset Character set that specifies the encoding format of the response body
     * @return
     * @throws IOException
     */
    public String getResponseBody(String charset) throws IOException {
        /**
         * The application layer uses ServletOutputStream or PrintWriter character stream to output the response
         * The data in these two streams need to be forced to be flushed to the stream ByteArrayOutputStream, otherwise the response data cannot be retrieved or the data is incomplete
         */
        out.flush();
        writer.flush();
        return new String(baos.toByteArray(), StringUtils.isEmpty(charset) ? this.getCharacterEncoding() : charset);
    }

    /**
     * Output stream, which is used by application layer to write response body
     */
    class SubServletOutputStream extends ServletOutputStream {
        private ByteArrayOutputStream baos;

        public SubServletOutputStream(ByteArrayOutputStream baos) {
            this.baos = baos;
        }

        @Override
        public void write(int b) {
            baos.write(b);
        }

        @Override
        public void write(byte[] b) {
            baos.write(b, 0, b.length);
        }

        @Override
        public boolean isReady() {
            return false;
        }

        @Override
        public void setWriteListener(WriteListener writeListener) {

        }
    }

}