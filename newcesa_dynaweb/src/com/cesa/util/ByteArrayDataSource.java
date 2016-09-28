package com.cesa.util;

import java.io.*;
import javax.activation.*;

/**
 * DataSource interface�� �� ������ ������ �ҽ� 

 * @version 1.0
 */
public class ByteArrayDataSource implements DataSource {
    private byte[] data;	// data
    private String type;	// content-type

    /** 
	 * <pre>
	 * ������
	 * <code>InputStream</code>���� <code>DataSource</code>�� �����. 
	 * </pre>
	 *
	 * @param is InputStream
	 * @param type content-type
	 */
    public ByteArrayDataSource(InputStream is, String type) {
        this.type = type;
        try 
		{ 
            ByteArrayOutputStream os = new ByteArrayOutputStream();
			int ch;

			while ((ch = is.read()) != -1) os.write(ch);
			data = os.toByteArray();

        } 
		catch(IOException ioex){}
    }

    /** 
	 * <pre>
	 * ������
	 * byte array �� <code>DataSource</code>�� �����. 
	 * </pre>
	 *
	 * @param data ������(byte[])
	 * @param type content-type
	 */
    public ByteArrayDataSource(byte[] data, String type) {
        this.data = data;
		this.type = type;
    }

    /** 
	 * <pre>
	 * ������
	 * String ���� <code>DataSource</code>�� �����. 
	 * </pre>
	 *
	 * @param data ������(String)
	 * @param type content-type
	 */
    public ByteArrayDataSource(String data, String type) {
		try {
			// String �� byte array �� �޴´�. 
			this.data = data.getBytes("iso-8859-1");
		} 
		catch(UnsupportedEncodingException uex){}
		this.type = type;
    }

    /**
	 * <pre>
     * �����Ϳ� ���� <code>InputStream</code>�� �����Ѵ�. 
     * Note - a new stream must be returned each time.
	 * </pre>
	 *
	 * @return InputStream ���οƮ��
	 * @exception IOException �����Ͱ����� ���
     */
    public InputStream getInputStream() throws IOException {
		if (data == null)
			throw new IOException("no data");
		return new ByteArrayInputStream(data);
    }

	/**
	 * <pre>
	 * OutputStream �� ������ �� ����. 
	 * </pre>
	 * @exception IOException �׻� Exception �� return �Ѵ�. 
	 */
    public OutputStream getOutputStream() throws IOException {
		throw new IOException("cannot do this");
    }

	/**
	 * content-type �� ��´�. 
	 *
	 * @return content-type
	 */
    public String getContentType() {
        return type;
    }


	/**
	 * name �� ��´�. 
	 *
	 * @return 'paran shopping'
	 */
    public String getName() {
        return "paran shopping";
    }
}
