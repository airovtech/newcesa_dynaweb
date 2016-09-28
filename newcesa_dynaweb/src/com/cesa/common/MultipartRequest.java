/*=========================================================================
 * @BusinessType : Common
 * @File : MultipartRequest.java
 * @FileName : Multipart Form ó���� ���� ��ƿ �Լ�
 *
 * Note :
 *
 * Change History
 * @LastModifyDate : 20041230
 * @LastModifier   : 
 * @LastVersion    : 1.0
 *
 * 	2004-12-30 ���ʻ���
 *
 ========================================================================*/
package com.cesa.common;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;

public class MultipartRequest {

  private static final int DEFAULT_MAX_POST_SIZE = 1024 * 1024 * 10;  // 10 Meg
  private static final String NO_FILE = "unknown";

  private HttpServletRequest req;
  private File dir;
  private int maxSize;
  private String ErrorMessage;

  private Hashtable parameters = new Hashtable();  // name - Vector of values
  private Hashtable files = new Hashtable();       // name - UploadedFile
  private Vector sfiles = new Vector();

  /**
   * ������
   *
   * @param request ��Request
   * @param saveDirectory ������ ����� ���丮
   * @exception IOException 
   */
  public MultipartRequest(HttpServletRequest request,
                          String saveDirectory) throws Exception {
    this(request, saveDirectory, DEFAULT_MAX_POST_SIZE);
  }

  /**
   * ������
   *
   * @param request ��Request
   * @param saveDirectory ������ ����� ���丮
   * @param maxPostSize ���ε�������ũ������
   * @exception IOException 
   */
  public MultipartRequest(HttpServletRequest request,
                          String saveDirectory,
                          int maxPostSize) throws Exception {
	super();

    ErrorMessage=new String();
	  // Sanity check values
    if (request == null)
      throw new IllegalArgumentException("request cannot be null");
    if (maxPostSize <= 0) {
      throw new IllegalArgumentException("maxPostSize must be positive");
    }

    // Save the request, dir, and max size
    req = request;
	maxSize = maxPostSize;

	if(saveDirectory != null){
		dir = new File(saveDirectory);

		// Check saveDirectory is truly a directory
		if (!dir.isDirectory())
		  throw new IllegalArgumentException("Not a directory: " + saveDirectory);

		// Check saveDirectory is writable
		if (!dir.canWrite())
		  throw new IllegalArgumentException("Not writable: " + saveDirectory);
	}
	else dir = null;

    // Now parse the request saving data to "parameters" and "files";
    // write the file contents to the saveDirectory
    readRequest();
  }

  /**
   * ������
   *
   * @param request <code>ServletRequest</code> ������
   * @param saveDirectory ������ ����� ���丮
   * @exception IOException 
   */
  public MultipartRequest(ServletRequest request,
                          String saveDirectory) throws Exception {
    this((HttpServletRequest)request, saveDirectory);
  }


  /**
   * ������
   *
   * @param request <code>ServletRequest</code> ������
   * @param saveDirectory ������ ����� ���丮
   * @param maxPostSize ���ε�������ũ������
   * @exception IOException 
   */
  public MultipartRequest(ServletRequest request,
                          String saveDirectory,
                          int maxPostSize) throws Exception {
    this((HttpServletRequest)request, saveDirectory, maxPostSize);
  }

  /**
   * �Ķ���� �̸����� �����´�. 
   *
   * @return �Ķ�����̸�(Enumeration)
   */
  public Enumeration getParameterNames() {
    return parameters.keys();
  }


  /**
   * ���ϸ���� �����´�. 
   *
   * @return ���ϸ�(Enumeration)
   */
  public Enumeration getFileNames() {
    return files.keys();
  }

  /**
   * �����̸��� �����ؼ� �����´�. 
   *
   * @return ���õ����ϸ�(Vector)
   */
  public Vector getSortedFileNames(){
	  return sfiles;
  }

  /**
   * ���Ķ���͸� �����´�. null�� ��� �����������Ѵ�. 
   *
   * @param name �Ķ���� �̸�
   * @return �Ķ���� �� 
   */
  public String getStrParam(String name) throws Exception {
	  String ret = getParameter(name);
	  return ( ret == null ? "": ret );
  }

  /**
   * ���������� ���Ķ���͸� �����´�. null�� ��� 0�� �����Ѵ�. 
   *
   * @param name �Ķ���� �̸�
   * @return �Ķ���� ��(����)
   * @exception NumberFormatException ������ȯ�� ������ ��� 
   */
  public int getIntParam(String name) throws Exception {
	  String ret = getParameter(name);
	  if(ret != null && ret.length() > 0){
		  return Integer.parseInt(ret);
	  }
	  else return 0;
  }

  /**
   * <pre>
   * �������͸� �����´�.
   * null �� ��� "" �� �����ϰ�, �����Ҷ� UTF-8�� ���ڵ��Ѵ�. 
   * </pre>
   *
   * @param name �Ķ���� �̸�
   * @return �Ķ���� �� 
   */
  public String getParameter(String name) throws Exception {
	  Vector values = (Vector)parameters.get(name);
	  if (values == null || values.size() == 0) {
		  return null;
	  }
	  String value = (String)values.elementAt(values.size() - 1);
	  //return (value==null ? "" : new String(value.getBytes("ISO-8859-1"),"KSC5601"));
	  return (value==null ? "" : new String(value.getBytes("ISO-8859-1"),"UTF-8"));
  }

  /**
   * <pre>
   * �Ķ���� ������ String Array �� �����Ѵ�. 
   * ���� �̸����� ���� ���ڵ��� �Ѱ��� �� ����Ѵ�. 
   * </pre>
   *
   * @param name �Ķ���� �̸�
   * @return �Ķ���� �� (Array)
   */
  public String[] getParameterValues(String name) throws Exception {
	  Vector values = (Vector)parameters.get(name);
	  if (values == null || values.size() == 0) {
		return null;
	  }
	  String[] valuesArray = new String[values.size()];
	  values.copyInto(valuesArray);
	  return valuesArray;
  }

  /**
   * ���ε� �� ������ ���ϸ��� �����´�. 
   *
   * @param name ������ argument�̸� 
   * @return ���ε�� ������ �̸�
   */
  public String getFilesystemName(String name) throws Exception {
      UploadedFile file = (UploadedFile)files.get(name);
      return (file==null? null:file.getFilesystemName());  // may be null
  }

  /**
   * ������ ContentType�� �����´�. 
   *
   * @param name ������ argument �̸�
   * @return ������ ContentType
   */
  public String getContentType(String name) throws Exception {
      UploadedFile file = (UploadedFile)files.get(name);
      return file.getContentType();  // may be null
  }

  /**
   * ���ε��� ������ File ��ü�� �����Ѵ�. 
   *
   * @param name ������ argument �̸�
   * @return ������ File ��ü
   */
  public File getFile(String name) throws Exception {
      UploadedFile file = (UploadedFile)files.get(name);
      return file.getFile();  // may be null
  }

  /**
   * ������ �߻��� ��� ���� �޽����� �����´�. 
   *
   * @return �����޽���
   */
  public String getErrorMessage()
  {
	  if(ErrorMessage==null)
		  return "";
	  else
		  return ErrorMessage;
  }

  /**
   * Request �� �о multipart �� ó���Ѵ�. 
   * @exception IOException ���ε� ó������ ������ �߻��� ���
   */
  protected void readRequest() throws Exception {
    // Check the content length to prevent denial of service attacks
    int length = req.getContentLength();
    if (length > maxSize) {
      throw new IOException("Posted content length of " + length + 
                            " exceeds limit of " + maxSize);
    }

    // Check the content type to make sure it's "multipart/form-data"
    // Access header two ways to work around WebSphere oddities
    String type = null;
    String type1 = req.getHeader("Content-Type");
    String type2 = req.getContentType();
    // If one value is null, choose the other value
    if (type1 == null && type2 != null) {
      type = type2;
    }
    else if (type2 == null && type1 != null) {
      type = type1;
    }
    // If neither value is null, choose the longer value
    else if (type1 != null && type2 != null) {
      type = (type1.length() > type2.length() ? type1 : type2);
    }

    if (type == null || 
        !type.toLowerCase().startsWith("multipart/form-data")) {
      throw new IOException("Posted content type isn't multipart/form-data");
    }

    // Get the boundary string; it's included in the content type.
    // Should look something like "------------------------12012133613061"
    String boundary = extractBoundary(type);
    if (boundary == null) {
      throw new IOException("Separation boundary was not specified");
    }

    // Construct the special input stream we'll read from
    MultipartInputStreamHandler in =
      new MultipartInputStreamHandler(req.getInputStream(), length);


    // Read the first line, should be the first boundary
	// modified by tallboy 
	do{
		String line = in.readLine();
		if (line == null) {
		  throw new IOException("Corrupt form data: premature ending");
		}
		if (line.startsWith(boundary)) {
		  break; // success
		}
	}while(true);

    // Now that we're just beyond the first boundary, loop over each part
    boolean done = false;
    while (!done) {
      done = readNextPart(in, boundary);

    }
  }

  /**
   * Multipart�� nextpart�� �о���δ�. 
   * @param in ��Ƽ��Ʈ��Ʈ���ڵ鷯
   * @param boundary ��Ƽ��Ʈ���� boundary
   * @exception IOException ���ε� ó������ ������ �߻��� ���
   */
  protected boolean readNextPart(MultipartInputStreamHandler in,
                                 String boundary) throws Exception 
  {
    // Read the first line, should look like this:
    // content-disposition: form-data; name="field1"; filename="file1.txt"
    String line = in.readLine();
    if (line == null) {
      // No parts left, we're done
      return true;
    }
    else if (line.length() == 0) {
		while(true)
		{
			line=in.readLine();
			if(line!=null && line.length()>0)
				break;
		}
    }

    // Parse the content-disposition line
    String[] dispInfo = null;
    String disposition = null;
    String name = null;
    String filename = null;
    
	// length==0�� �ٿ��� ���� �ٷ� �Ѿ�ö�, extractDisposition�� ����������
	// line skip
	while(true)
	{
		try{
			dispInfo = extractDispositionInfo(line);
			disposition = dispInfo[0];
			name = dispInfo[1];
			filename = dispInfo[2];
			break;
		}
		catch(IOException e)
		{
			ErrorMessage+=e+"<br>";
			line=in.readLine();
		}

		if(line==null)
			return true;
	}

    // Now onto the next line.  This will either be empty 
    // or contain a Content-Type and then an empty line.
    line = in.readLine();
    if (line == null) {
      // No parts left, we're done
      return true;
    }


    // Get the content type, or null if none specified
    String contentType = extractContentType(line);
    if (contentType != null) {
      // Eat the empty line
      line = in.readLine();
      if (line == null || line.length() > 0) {  // line should be empty
        throw new 
          IOException("Malformed line after content type: " + line);
      }
    }
    else {
      // Assume a default content type
      contentType = "application/octet-stream";
    }

    // Now, finally, we read the content (end after reading the boundary)
    if (filename == null) {
      // This is a parameter, add it to the vector of values
      String value = readParameter(in, boundary);
      if (value.equals("")) {
        value = null;  // treat empty strings like nulls
      }
      Vector existingValues = (Vector)parameters.get(name);
      if (existingValues == null) {
        existingValues = new Vector();
        parameters.put(name, existingValues);
      }
      existingValues.addElement(value);
    }
    else {
      // This is a file
	  //filename = new String(filename.getBytes("ISO-8859-1"), "KSC5601");
	  filename = new String(filename.getBytes("ISO-8859-1"), "UTF-8");

      if (filename.equals(NO_FILE)) {
        files.put(name, new UploadedFile(null, null, null));
		sfiles.add("");
      }
      else {
		if(dir == null){
			String path = getParameter("path");
			if(path != null){

				dir = new File(path);

				if (!dir.isDirectory()){
				  //throw new IllegalArgumentException("Not a directory: " + dir.toString());
				  dir.mkdirs();
				}

				// Check saveDirectory is writable
				if (!dir.canWrite())
				  throw new IllegalArgumentException("Not writable: " + dir.toString());
			}
			else
			{
			    throw new IllegalArgumentException("Speicify form argument 'path' : " + dir.toString());
			}
		}
        String newFile = readAndSaveFile(in, boundary, filename, contentType);
        files.put(name,
          new UploadedFile(dir.toString(), newFile, contentType));

		sfiles.add(name);
      }
    }
    return false;  // there's more to read
  }

  /**
   * <pre>
   * boundary �Ķ���͸� �о���δ�. 
   * boundary ���� ������ \r\n �� �����Ѵ�. 
   * </pre>
   *
   * @param in ��Ƽ��Ʈ��Ʈ���ڵ鷯
   * @param boundary ����boundary
   * @return ã�� boundary
   * @exception IOException ���ε� ó������ ������ �߻��� ���
   *
   */
  protected String readParameter(MultipartInputStreamHandler in,
                                 String boundary) throws IOException {
    StringBuffer sbuf = new StringBuffer();
    String line;

    while ((line = in.readLine()) != null) {
      if (line.startsWith(boundary)) break;
      sbuf.append(line + "\r\n");  // add the \r\n in case there are many lines
    }

    if (sbuf.length() == 0) {
      return null;  // nothing read
    }

    sbuf.setLength(sbuf.length() - 2);  // cut off the last line's \r\n
    return sbuf.toString();  // no URL decoding needed
  }

  /**
   * ������ �����Ѵ�. 
   *
   * @param in ��Ƽ��Ʈ��Ʈ���ڵ鷯
   * @param boundary ����boundary
   * @param filename �����̸�
   * @param contentType ����ƮType
   * @return ��������ϸ�
   * @exception IOException ���ε� ó������ ������ �߻��� ���
   */
  protected String readAndSaveFile(MultipartInputStreamHandler in,
                                 String boundary,
                                 String filename,
                                 String contentType) throws IOException 
  {

	  String writing_filename = filename;

	  if( writing_filename.indexOf(" ")>-1 ) {
			writing_filename = writing_filename.replace(" ", "_");	
	  }

	String tmpFile = null;
    OutputStream out = null;
    // A filename of NO_FILE means no file was sent, so just read to the
    // next boundary and ignore the empty contents
    if (filename.equals(NO_FILE)) {
      out = new ByteArrayOutputStream();  // write to nowhere
    }
    // A MacBinary file goes through a decoder
    else if (contentType.equals("application/x-macbinary")){

	  int count=0;
	  File f = null;

	  do{
	      tmpFile = writing_filename;
	      if(count > 0){
		      tmpFile = ""+count+"-"+writing_filename;
		  }
	      f = new File(dir + File.separator + tmpFile);
		  count++;
      }while(f.exists());
	  
      out = new MacBinaryDecoderOutputStream(
            new BufferedOutputStream(
            new FileOutputStream(f), 8 * 1024));
    }
    // A real file's contents are written to disk
    else {
	  int count = 0;
      File f = null;

	  do{
	      tmpFile = writing_filename;

	      if(count > 0){
		      tmpFile = ""+count+"-"+writing_filename;
		  }
	      f = new File(dir + File.separator + tmpFile);
		  count++;
      }while(f.exists());

      out = new BufferedOutputStream(new FileOutputStream(f), 8 * 1024);
    }

    byte[] bbuf = new byte[100 * 1024];  // 100K
    int result;
    String line;

    // ServletInputStream.readLine() has the annoying habit of 
    // adding a \r\n to the end of the last line.  
    // Since we want a byte-for-byte transfer, we have to cut those chars.
    boolean rnflag = false;
    while ((result = in.readLine(bbuf, 0, bbuf.length)) != -1) {
      // Check for boundary
      if (result > 2 && bbuf[0] == '-' && bbuf[1] == '-') { // quick pre-check
        line = new String(bbuf, 0, result, "ISO-8859-1");
        if (line.startsWith(boundary)) break;
      }
      // Are we supposed to write \r\n for the last iteration?
      if (rnflag) {
        out.write('\r'); out.write('\n');
        rnflag = false;
      }
      // Write the buffer, postpone any ending \r\n
      if (result >= 2 && 
          bbuf[result - 2] == '\r' && 
          bbuf[result - 1] == '\n') {
        out.write(bbuf, 0, result - 2);  // skip the last 2 chars
        rnflag = true;  // make a note to write them on the next iteration
      }
      else {
        out.write(bbuf, 0, result);
      }
    }
    out.flush();
    out.close();

	return tmpFile;
  }

  /**
   * ���ڿ����� boundary ��ū�� �и��س���
   *
   * @param line boundary ��ū�� �����ϴ� ���ڿ�
   * @return �и��س� boundary
   */
  private String extractBoundary(String line) {
    int index = line.lastIndexOf("boundary=");
    if (index == -1) {
      return null;
    }
	String boundary = line.substring(index + 9);  // 9 for "boundary="
	if (boundary.charAt(0) == '"') {
		index = boundary.lastIndexOf('"');
		boundary = boundary.substring(1, index);
	}
    boundary = "--" + boundary;

    return boundary;
  }

  /**
   * <pre>
   * Extracts and returns disposition info from a line, as a String array
   * with elements: disposition, name, filename.  Throws an IOException 
   * if the line is malformatted.
   * </pre>
   * @param line ������ line
   * @return ����� disposition info
   * @exception IOException ó������ �б���� �߻�
   */
  private String[] extractDispositionInfo(String line) throws IOException {
    // Return the line's data as an array: disposition, name, filename
    String[] retval = new String[3];

    // Convert the line to a lowercase string without the ending \r\n
    // Keep the original line for error messages and for variable names.
    String origline = line;
    line = origline.toLowerCase();

    // Get the content disposition, should be "form-data"
    int start = line.indexOf("content-disposition: ");
    int end = line.indexOf(";");
    if (start == -1 || end == -1) {
      throw new IOException("Content disposition corrupt: " + origline);
    }
    String disposition = line.substring(start + 21, end);
    if (!disposition.equals("form-data")) {
      throw new IOException("Invalid content disposition: " + disposition);
    }

    // Get the field name
    start = line.indexOf("name=\"", end);  // start at last semicolon
    end = line.indexOf("\"", start + 7);   // skip name=\"

    int startOffset = 6;
	if(start == -1 || end == -1){
		start = line.indexOf("name=", end);
		end = line.indexOf(";", start + 6);
		if (start == -1) {
			throw new IOException("Content disposition corrupt: " + origline);
		}
		else if (end == -1) {
			end = line.length();
		}
		startOffset = 5;  // without quotes we have one fewer char to skip
	}

    String name = origline.substring(start + 6, end);

    // Get the filename, if given
    String filename = null;
    start = line.indexOf("filename=\"", end + 2);  // start after name
    end = line.indexOf("\"", start + 10);          // skip filename=\"
    if (start != -1 && end != -1) {                // note the !=
      filename = origline.substring(start + 10, end);
      // The filename may contain a full path.  Cut to just the filename.
      int slash =
        Math.max(filename.lastIndexOf('/'), filename.lastIndexOf('\\'));
      if (slash > -1) {
        filename = filename.substring(slash + 1);  // past last slash
      }
      if (filename.equals("")) filename = NO_FILE; // sanity check
    }

    // Return a String array: disposition, name, filename
    retval[0] = disposition;
    retval[1] = name;
    retval[2] = filename;
    return retval;
  }

  /**
   * ContentType�� �����Ѵ�. 
   * @param line ������ line
   * @return ����� ContentType
   * @exception IOException line �� �ùٸ��� ���� ��� 
   */
  private String extractContentType(String line) throws IOException {
    String contentType = null;

    // Convert the line to a lowercase string
    String origline = line;
    line = origline.toLowerCase();

    // Get the content type, if any
    if (line.startsWith("content-type")) {
      int start = line.indexOf(" ");
      if (start == -1) {
        throw new IOException("Content type corrupt: " + origline);
      }
      contentType = line.substring(start + 1);
    }
    else if (line.length() != 0) {  // no content type, so should be empty
      throw new IOException("Malformed line after disposition: " + origline);
    }

    return contentType;
  }
}


class UploadedFile {

  private String dir;
  private String filename;
  private String type;

  UploadedFile(String dir, String filename, String type) {
    this.dir = dir;
    this.filename = filename;
    this.type = type;
  }

  public String getContentType() {
    return type;
  }

  public String getFilesystemName() {
    return filename;
  }

  public File getFile() {
    if (dir == null || filename == null) {
      return null;
    }
    else {
      return new File(dir + File.separator + filename);
    }
  }
}

/**
 * <pre>
 * A class to aid in reading multipart/form-data from a ServletInputStream.
 * It keeps track of how many bytes have been read and detects when the
 * Content-Length limit has been reached.  This is necessary since some 
 * servlet engines are slow to notice the end of stream.
 * Mac users: The Mac doesn't like class names which exceed 32 characters
 * (including the ".class") so while this class is usable from a JAR 
 * anywhere, it won't compile on a Mac.
 * </pre>
 */
class MultipartInputStreamHandler {

  ServletInputStream in;
  int totalExpected;
  int totalRead = 0;
  byte[] buf = new byte[8 * 1024];

  /**
   * ������ 
   *
   * @param in <code>ServletInputStream</code>
   * @param totalExpected ��ü����
   *
   */
  public MultipartInputStreamHandler(ServletInputStream in,
                                     int totalExpected) {
    this.in = in;
    this.totalExpected = totalExpected;
  }

  /**
   * <pre>
   * Reads the next line of input.  Returns null to indicate the end
   * of stream.
   * </pre>
   *
   * @return �о���� ������
   * @exception IOException �дµ��߿����� �߻�
   */
  public String readLine() throws IOException 
  {
    StringBuffer sbuf = new StringBuffer();
    int result;
    String line;

    do {
      result = this.readLine(buf, 0, buf.length);  // this.readLine() does +=
      if (result != -1) {
        sbuf.append(new String(buf, 0, result, "ISO-8859-1"));
      }
    } while (result == buf.length);  // loop only if the buffer was filled

    if (sbuf.length() == 0) {
      return null;  // nothing read, must be at the end of stream
    }

	int len = sbuf.length();
	if (len >= 2 && sbuf.charAt(len - 2) == '\r') {
		sbuf.setLength(len - 2);  // cut \r\n
	}
	else if (len >= 1 && sbuf.charAt(len - 1) == '\n') {
		sbuf.setLength(len - 1);  // cut \n
	}

    return sbuf.toString();
  }


  /**
   * <pre>
   * A pass-through to ServletInputStream.readLine() that keeps track
   * of how many bytes have been read and stops reading when the 
   * Content-Length limit has been reached.
   * </pre>
   * @param b ����Ʈ �迭(����������)
   * @param off ������ġ 
   * @param len ���� ���� 
   * @return �о���� ������
   * @exception IOException �дµ��߿����� �߻�
   */
  public int readLine(byte b[], int off, int len) throws IOException {
    if (totalRead >= totalExpected) {
      return -1;
    }
    else {
      if (len > (totalExpected - totalRead)) {
        len = totalExpected - totalRead;  // keep from reading off end
      }
      int result = in.readLine(b, off, len);
      if (result > 0) {
        totalRead += result;
      }
      return result;
    }
  }
}


/**
 * Class to filters MacBinary files to normal files on the fly
 * Optimized for speed more than readability
 */
class MacBinaryDecoderOutputStream extends FilterOutputStream {

  int bytesFiltered = 0;
  int dataForkLength = 0;

  /**
   * ������ 
   *
   * @param out <code>OutputStream</code>
   */
  public MacBinaryDecoderOutputStream(OutputStream out) {
    super(out);
  }

  /**
   * int�� write �Ѵ� 
   *
   * @param b write �� int 
   * @exception IOException ����
   */
  public void write(int b) throws IOException {
    // Bytes 83 through 86 are a long representing the data fork length
    // Check <= 86 first to short circuit early in the common case
    if (bytesFiltered <= 86 && bytesFiltered >= 83) {
      int leftShift = (86 - bytesFiltered) * 8;
      dataForkLength = dataForkLength | (b & 0xff) << leftShift;
    }
    // Bytes 128 up to (128 + dataForkLength - 1) are the data fork
    else if (bytesFiltered < (128 + dataForkLength) && bytesFiltered >= 128) {
      out.write(b);
    }
    bytesFiltered++;
  }


  /**
   * byte array �� write �Ѵ� 
   *
   * @param b write �� byte array
   * @exception IOException ����
   */
  public void write(byte b[]) throws IOException {
    write(b, 0, b.length);
  }

  /**
   * byte array �� write �Ѵ� 
   *
   * @param b write �� byte array
   * @param off offset
   * @param len ����
   * @exception IOException ����
   */
  public void write(byte b[], int off, int len) throws IOException {
    // If the write is for content past the end of the data fork, ignore
    if (bytesFiltered >= (128 + dataForkLength)) {
      bytesFiltered += len;
    }
    // If the write is entirely within the data fork, write it directly
    else if (bytesFiltered >= 128 && 
             (bytesFiltered + len) <= (128 + dataForkLength)) {
      out.write(b, off, len);
      bytesFiltered += len;
    }
    // Otherwise, do the write a byte at a time to get the logic above
    else {
      for (int i = 0 ; i < len ; i++) {
        write(b[off + i]);
      }
    }
  }
}
