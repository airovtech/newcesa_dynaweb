
/*============================================================================
 * File Name : WebUtil.java
 * package   : com.adlinker.common
 * Desc      : Web ���� ��ƿ��Ƽ
 * Auther    : ����ȣ
 * Date      : 2007-01-02 �����ۼ�
 * Copyright (c) 2007 dnt7.com. All Rights Reserved.
 *
 * ��������
 *
 ============================================================================*/

package com.cesa.util;

import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.net.URLEncoder;
import java.net.URLDecoder;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.apache.commons.lang.StringUtils;

import com.cesa.common.*;
import com.cesa.db.*;

public class WebUtil {
	
	/**
     * Constructor
     */
	private WebUtil() { }
	
	/**
	 * max page ���� ��ȯ�Ѵ�.
	 *
	 * @param request HttpServletRequest
	 * @return max page ��
	 */
	public static int getDbMaxPage(HttpServletRequest request) {

		String maxPage = (String)request.getAttribute("__maxPage__");
		if(maxPage == null || "".equals(maxPage.trim()))
			return 1;

		return Integer.parseInt(maxPage.trim());

	}

	/**
	 * ���� ������ ��ȣ�� ��ȯ�Ѵ�.
	 *
	 * @param request HttpServletRequest
	 * @return ���� ������ ��ȣ
	 */
	public static int getDbPageNumber(HttpServletRequest request) {

		String pageNumber = (String)request.getAttribute("__pageNumber__");
		if(pageNumber != null && !"".equals(pageNumber.trim()))
			return Integer.parseInt(pageNumber);

		String strPagNum = request.getParameter("_pageNumber_");
		if(strPagNum != null && !"".equals(strPagNum.trim()))
			return Integer.parseInt(strPagNum.trim());

		return 1;
	}


	/**
	 * ������ ������ �����Ѵ�.
	 *
	 * @param request HttpServletRequest
	 * @param rowSet RowSetMapper
	 */
	public static void setDbPage(HttpServletRequest request, RowSetMapper rowSet) {

		request.setAttribute("__maxPage__", rowSet.getQueryManager().getMaxPageSize()+"");
		request.setAttribute("__pageNumber__", rowSet.getQueryManager().getCurrPage()+"");

	}
	
	/**
	 * ���ϸ����� Ȯ���ڿ� ���� �̹��� ���ϸ� ����
	 *
	 * @param fileName ���ϸ�
	 * @return Ȯ���ں� �̹��� ���ϸ�
	 */
	public static String getExtensionImage(String fileName)
	{
		if(fileName != null && fileName.length()>0){
			int index = fileName.lastIndexOf(".");
			if(index != -1)
			{
				String extension = fileName.substring(index+1).toLowerCase();
				if(extension.equals("doc")) return "word.gif";
				else if(extension.equals("xls")) return "xls.gif";
				else if(extension.equals("ppt")) return "ppt.gif";
				else if(extension.equals("ra")) return "ra.gif";
				else if(extension.equals("txt")) return "txt.gif";
				else if(extension.equals("exe")) return "exe.gif";
				else if(extension.equals("gif")) return "gif.gif";
				else if(extension.equals("pdf")) return "pdf.gif";

				else if(extension.equals("htm") || extension.equals("html")) return "html.gif";
				else if(extension.equals("zip") || extension.equals("gz") 
							|| extension.equals("tgz") || extension.equals("alz")
							|| extension.equals("lzh") || extension.equals("rar")
							|| extension.equals("tar"))
				{
					return "compressed.gif";
				}
				else if(extension.equals("jpeg") || extension.equals("jpg")) return "jpg.gif";
				else if(extension.equals("ra")  || extension.equals("ram")) return "ra.gif";
				else if(extension.equals("mpg")  || extension.equals("mpeg")
							|| extension.equals("asf") || extension.equals("wmv")
							|| extension.equals("avi"))
				{
					return "movie.gif";
				}
				else if(extension.equals("pcx")) return "pcx.gif";
				else if(extension.equals("bat")) return "bat.gif";
				else if(extension.equals("wav")) return "wav.gif";
				else if(extension.equals("mp3")) return "mp3.gif";
			}
			return "unknown.gif";
		}
		return null;
	}
	
	/**
	 * ���ϸ����� Ȯ���� ����
	 *
	 * @param fileName ���ϸ�
	 * @return Ȯ����
	 */
	public static String getExtension(String fileName)
	{
		if(fileName != null && fileName.length()>0){
			int index = fileName.lastIndexOf(".");
			if(index != -1)
			{
				String extension = fileName.substring(index+1).toLowerCase();

				return extension;
			}
		}
		return null;
	}

	/**
	 * HTML�ڵ尡 ���󿡼� �״�� ��µ� �� �ֵ��� �����Ѵ�. 
	 * @param org HTML���ڿ�
	 * @return �ֿ��±װ� ġȯ�� ���ڿ�
	 */
	public static String convertHtml(String org){
		int len = org.length();
		StringBuffer sb = new StringBuffer();
		char c = 0;

		for(int i=0; i<len; i++){
			c = org.charAt(i);
			if(c=='<')  sb.append("&lt;");
			else if(c=='>')  sb.append("&gt;");
			else if(c=='\"') sb.append("&quot;");
			else if(c=='\'') sb.append("&#39;");
			else if(c=='\"') sb.append("&#34;");
			else if(c=='\t') sb.append("&nbsp;&nbsp;&nbsp;&nbsp;");
			else sb.append(c);
		}
		return sb.toString();
	}

	/**
	 * URL�� ���ڵ��Ѵ� 
	 *
	 * @param url ���ڵ��� URL
	 * @return ���ڵ��� URL
	 */
	public static String encodeURL(String url) throws Exception {
		return URLEncoder.encode(url);
	}

	/**
	 * URL�� ���ڵ��Ѵ�. 
	 *
	 * @param url ���ڵ��� URL
	 * @return ���ڵ��� URL
	 */
	public static String decodeURL(String url) throws Exception {
		return URLDecoder.decode(url);
	}

	/**
	 * ��Ű���� �����´�. 
	 *
	 * @param CookieName ��Ű��
	 * @return ��Ű��
	 * @exception UnsupportedEncodingException
	 */
	public static String getCookie(HttpServletRequest request, String CookieName) throws UnsupportedEncodingException {
		int i;
		String retString = null;

		Cookie[] cookies = request.getCookies();

		if(cookies != null){
			for(i=0; i < cookies.length; i++){
				if(cookies[i].getName().equals(CookieName)){
					retString = URLDecoder.decode(cookies[i].getValue());
					break;
				}
			}
		}
		return retString;
	}


    // MD5 Hash
	public static String makeMD5(String param) {
		StringBuffer md5 = new StringBuffer();

		try {
			byte[] digest = java.security.MessageDigest.getInstance("MD5").digest(param.getBytes());

			for (int i = 0; i < digest.length; i++) {
				md5.append(Integer.toString((digest[i] & 0xf0) >> 4, 16));
				md5.append(Integer.toString(digest[i] & 0x0f, 16));
			}
		} catch(java.security.NoSuchAlgorithmException ne) {
			ne.printStackTrace();
		}
	return md5.toString();
	}


	public static String xssFilter(String param){

		String pattern = "<(script|embed|object|iframe|applet)[\\s\\S]*?<(\\/)?(script|embed|object|iframe|applet)?>|<?(script|embed|object|iframe|applet)(.*)";
		
        Pattern pFilter = Pattern.compile(pattern);
        Matcher mFilter = null;
        String strParam = null;
        String tempParam = null;
        
		strParam = param;
		
		//�ҹ��ڷ� ��ȯ �Ͽ� ã�´�.
		tempParam = strParam.toLowerCase();
		tempParam = StringUtils.replace(tempParam, " ","");
		mFilter = pFilter.matcher(tempParam);
		if(mFilter.find()){
			tempParam = mFilter.replaceAll("xssFilter");
			strParam = tempParam;
		}
		
		strParam = StringUtils.replace(strParam, "%27", "&#39;");
		strParam = StringUtils.replace(strParam, "--", "&#45;&#45;");
		strParam = StringUtils.replace(strParam, "\\", "&#92;");
		
		strParam = StringUtils.replace(strParam, "$" ,"&#36;");
		strParam = StringUtils.replace(strParam, "%" ,"&#37;");
		strParam = StringUtils.replace(strParam, "'" ,"&#39;");
		strParam = StringUtils.replace(strParam, "\\" ,"&#92;");
		
		strParam = StringUtils.replace(strParam, "<" ,"&lt;");
		strParam = StringUtils.replace(strParam, ">" ,"&gt;");
            
        
		return strParam;

	}

	/**
	 * <pre>
	 * ���͸� <BR> �±׷� ��ȯ
	 * </pre>
	 *
	 * @param instr ����
	 * @return String
	 */
	public static String putsBR(String inStr){

		if (inStr == null) return null;

		char c=(char)0;
		char prevchar=(char)0;
		StringBuffer sb = new StringBuffer();

		for (int i=0; i < inStr.length() ; i++) {
			c = inStr.charAt(i);
			if((c==13 && prevchar != 10) || (c==10 && prevchar != 13)) sb.append("<br>");
			else sb.append(c);

			prevchar=c;
		}

		return sb.toString();
	}

	public static String getFileContents(String fileName) {
        File aFile = new File(fileName);
        StringBuilder contents = new StringBuilder();
 
        try {
            BufferedReader input = new BufferedReader(new FileReader(aFile));
            try {
                String line = null;
                while ((line = input.readLine()) != null) {
                    contents.append(line);
                    contents.append(System.getProperty("line.separator"));
                }
            } finally {
                input.close();
            }
        } catch (IOException ex) {
            ex.printStackTrace();
        }
 
        return contents.toString();
    }

	public static String addLink(String str) {

		String regex = "([\\p{Alnum}]+)://([a-z0-9.\\-&/%=?:@#$(),.+;~\\_]+)";

		Pattern p = Pattern.compile(regex, Pattern.CASE_INSENSITIVE);   
		Matcher m = p.matcher(str);   
		String s = m.replaceAll("<a href='http://$2' target=_blank>http://$2</a>");   

		return s;
	}

	// 100,200,300 �� ���� �迭�ȿ� Ư�� key�� �����ϴ��� ������
	public static boolean containsKey(String list, int key) {

		boolean result = false;

		if(list==null)
			return result;

		try {

			String [] arr = list.split(",");

			for(int i=0; i<arr.length; i++) {

				if(arr[i].length()==0)
					continue;

				if(Integer.parseInt(arr[i])==key)
					return true;
			}

		}catch (Exception e) {
			e.printStackTrace();
		}

		return result;


	}

	// ��ü���߿��� ��÷�ڼ��� �־ Ȯ�������� �����
	public static boolean isWin(int total, int success) {

		boolean result = false;

		try {

			Random r = new Random();

			int rint = r.nextInt(total);

			if(rint < success)
				return true;

		}catch (Exception e) {
			e.printStackTrace();
		}

		return result;

	}

	public static String convertDate(String d)
	{
		if(d==null)
			return null;

		if(d.length()==0)
			return d;

		if(d.endsWith(" AM"))
			return d.substring(0, d.length()-3);
		
		if(d.endsWith(" a.m."))
			return d.substring(0, d.length()-5);

		if(d.endsWith(" PM")) {

			String s = d.substring(0, d.length()-3);

			// �ð��ڸ��� ����� 12�� ���Ѵ�.
			int hour = Integer.parseInt(s.substring(11,13));
			hour += 12;

			s = s.substring(0,11) + hour + s.substring(13);

			return s;

		}
		
		if(d.endsWith(" p.m.")) {

			String s = d.substring(0, d.length()-5);

			// �ð��ڸ��� ����� 12�� ���Ѵ�.
			int hour = Integer.parseInt(s.substring(11,13));
			hour += 12;

			s = s.substring(0,11) + hour + s.substring(13);

			return s;

		}


		return d;
	}

	// [�� �����ϰ� ]�� ������ ����� ���� [�� ��������� �����Ѵ�.
	public static String encodeJSON(String org) throws Exception{

		if(!org.endsWith("]"))
			return org;

		// �޸��� ���� ��쵵 ���������� JSON���� ���ڿ��� ó���ȴ�.
		if(org.indexOf(",")==-1)
			return org;

		while(true) {

			if(org.startsWith("["))
				org = org.substring(1);
			else 
				break;
		}

		return org;
	}

	// �ٸ� ��Ƽ�����δ� rename�� �� ��
	public static boolean moveFile(String input, String output){

		File inputFile = new File (input);
		File outputFile = new File (output);

		if(inputFile.renameTo(outputFile)==false){

			return true;
			//copyBinary(input, output);
			//inputFile.delete();
		}

		return false;
	}

}

