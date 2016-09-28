/*============================================================================
 * @BusinessType : Common
 * @File : HTMLUtil.java
 * @FileName : Jsp���ð�����Ƽ��Ƽ�� ��� ����
 *
 * Note:
 *
 * Change history
 * @LastModifyDate : 20050220
 * @LastModifier   :
 * @LastVersion    : 1.0
 *   2005-01-03 ���ʻ���
 ============================================================================*/
package com.cesa.util;

import java.io.*;
import java.util.*;
import java.text.*;
import java.net.URLEncoder;
import java.net.URLDecoder;

import javax.servlet.*;
import javax.servlet.jsp.*;
import javax.servlet.http.*;
import com.cesa.common.*;

/**
 * out, req, res �� ���ڷ� �����Ƿ�, ���� ���õ�
 * ��� ������ �� Ŭ�������� ó���� �� �ִ�.
 *
 * @version 1.0
 */
public class HTMLUtil
{
	/**
	 * jsp���� ���޹��� <code>HttpServletRequest</code>
	 */
    private HttpServletRequest req;

	/**
	 * jsp���� ���޹��� <code>HttpServletResponse</code>
	 */
    private HttpServletResponse res;

	/**
	 * jsp���� ���޹��� <code>JspWriter</code>
	 */
    private JspWriter out;

	/**
	 * jsp���� ���޹��� <code>HttpSession</code>
	 */
    private HttpSession session;


	/**
	 * ������
	 */
    public HTMLUtil(){
        super();
    }

	/**
	 * ������
	 *
	 * @param req <code>HttpServletRequest</code>
	 * @param res <code>HttpServletResponse</code>
	 * @param out <code>JspWriter</code>
	 * @param session <code>HttpSession</code>
	 */
    public HTMLUtil(HttpServletRequest req,
                   HttpServletResponse res,
                   JspWriter out,
                   HttpSession session){

		synchronized(this){
			this.req = req;
			this.res = res;
			this.out = out;
			this.session = session;
		}
    }

	/**
	 * <pre>
	 * ������ �׺�����͸� out �� ���� ����Ѵ�.
	 * �ʺ�,�������� ��±� �������� Config�� ����� ���� �����
	 *
	 * Config.BORRD_LIST_CNT
	 * Config.BOARD_PAGE_CNT
	 *
	 * </pre>
	 *
	 * @param pageCommonUrl ���α׷� �̸��� argument ����
	 * @param totCount ��ü �Խñ� ī��Ʈ
	 * @param currPage ���� ������ ��ȣ
	 */
	public void printDividedPage( String pageCommonUrl,
									int totCount,
									int currPage) throws Exception {

		SiteContext sc = SiteContext.getInstance();
		printDividedPage(pageCommonUrl,totCount,currPage,
				sc.getInt("front.list.cnt"),sc.getInt("front.page.cnt"));
	}

	/**
	 * ������ �׺�����͸� out �� ���� ����Ѵ�.
	 *
	 * @param pageCommonUrl ���α׷� �̸��� argument ����
	 * @param totCount ��ü �Խñ� ī��Ʈ
	 * @param currPage ���� ������ ��ȣ
	 * @param articlesPerPage �������� ��� �� ����
	 * @param pagesPerScreen ��ũ���� Page ����
	 * @param tableWidth ���̺� �ʺ� ( 500, 100% )
	 */
	public void printDividedPage(String pageCommonUrl,
									int totCount,
									int currPage,
									int articlesPerPage,
									int pagesPerScreen) throws Exception {

		int pages  = (totCount-1)/articlesPerPage + 1;
        int lpages = (pages-1)/pagesPerScreen + 1;
		int lpage  = (currPage-1)/pagesPerScreen + 1;
		int tmpLpage;


        if(pageCommonUrl != null){
            if(pageCommonUrl.indexOf("?") == -1) pageCommonUrl += "?";
            else pageCommonUrl += "&";
        }
        else return;

		// �������� ����Ѵ�.

		// prev button
		if(lpage>=2){
			out.println("<a href='"+pageCommonUrl+"_currPage="+(((lpage-2)*pagesPerScreen)+1)+"><img src='/images/front/button/page_prev01.gif' class='pointer' style='vertical-align:middle;' alt='firstPage' /></a>&nbsp;");
		}
		else{
			out.println("<img src='/images/front/button/page_prev01.gif' class='pointer' style='vertical-align:middle;' alt='firstPage' />&nbsp;");
		}

		if(currPage > 1) {
            if((currPage%5)==0)
	            tmpLpage = lpages - 1;
            else
                tmpLpage = lpages;

            out.println("<a href='"+pageCommonUrl+"_currPage="+(currPage-1)+"&amp;lpage="+tmpLpage+"' ><img src='/images/front/button/page_prev02.gif' class='pointer' style='vertical-align:middle;' alt='prevPage' /></a>&nbsp;");
        }
		else{
			out.println("<img src='/images/front/button/page_prev02.gif' class='pointer' style='vertical-align:middle;' alt='prevPage' />&nbsp;");
		}

		int pageCnt = 0;
		String pageClass = "";
		for(int i=(lpage-1)*pagesPerScreen+1; i<=pages && i<=lpage*pagesPerScreen; i++){
			if(i==(lpage-1)*pagesPerScreen+1){
				pageClass = " class='sta'";
			}else{
				pageClass = "";
			}
			if(i==currPage){
				out.println("<font style='font-size:12px; color:#4d4d4d;'>"+i+"</font>&nbsp;");
			}
			else{
				out.println("<a href='"+pageCommonUrl+"_currPage="+i+"' class='paging'>"+i+"</a>&nbsp;");
			}
		}

		if(currPage<pages) {
	        if((currPage%5)==0)
	            tmpLpage = lpage + 1;
            else
                tmpLpage = lpage;

            out.println("<a href='"+pageCommonUrl+"_currPage="+(currPage+1)
                        +"&amp;lpage="+tmpLpage+"' ><img src='/images/front/button/page_next01.gif' class='pointer' style='vertical-align:middle;' alt='nextPage' /></a>&nbsp;");
        }
		else{
			out.println("<img src='/images/front/button/page_next01.gif' class='pointer' style='vertical-align:middle;' alt='nextPage' />&nbsp;");
		}

		// next button
		if(lpage<lpages){
			out.println("<a href='"+pageCommonUrl+"_currPage="+((lpage*pagesPerScreen)+1)+"'><img src='/images/front/button/page_next02.gif' class='pointer' style='vertical-align:middle;' alt='lastPage' /></a>");
		}
		else{
			out.println("<img src='/images/front/button/page_next02.gif' class='pointer' style='vertical-align:middle;' alt='lastPage' />");
		}
	}

	/**
	 * ������ �׺�����͸� out �� ���� ����Ѵ�.
	 *
	 * @param pageCommonUrl ���α׷� �̸��� argument ����
	 * @param totCount ��ü �Խñ� ī��Ʈ
	 * @param currPage ���� ������ ��ȣ
	 * @param articlesPerPage �������� ��� �� ����
	 * @param pagesPerScreen ��ũ���� Page ����
	 * @param tableWidth ���̺� �ʺ� ( 500, 100% )
	 */
	public void printDividedPage2(String pageCommonUrl,
									int totCount,
									int currPage,
									int articlesPerPage,
									int pagesPerScreen) throws Exception {

		int pages  = (totCount-1)/articlesPerPage + 1;
        int lpages = (pages-1)/pagesPerScreen + 1;
		int lpage  = (currPage-1)/pagesPerScreen + 1;
		int tmpLpage;


        if(pageCommonUrl == null) return;

		// �������� ����Ѵ�.

		// prev button
		if(lpage>=2){
			out.println("<a href='"+pageCommonUrl+",\""+(((lpage-2)*pagesPerScreen)+1)+"\")'><img src='/images/front/button/page_prev01.gif' class='pointer' style='vertical-align:middle;' alt='firstPage' /></a>&nbsp;");
		}
		else{
			out.println("<img src='/images/front/button/page_prev01.gif' class='pointer' style='vertical-align:middle;' alt='firstPage' />&nbsp;");
		}

		if(currPage > 1) {
            if((currPage%5)==0)
	            tmpLpage = lpages - 1;
            else
                tmpLpage = lpages;

            out.println("<a href='"+pageCommonUrl+",\""+(currPage-1)+"\")'><img src='/images/front/button/page_prev02.gif' class='pointer' style='vertical-align:middle;' alt='prevPage' /></a>&nbsp;");
        }
		else{
			out.println("<img src='/images/front/button/page_prev02.gif' class='pointer' style='vertical-align:middle;' alt='prevPage' />&nbsp;");
		}

		int pageCnt = 0;
		String pageClass = "";
		for(int i=(lpage-1)*pagesPerScreen+1; i<=pages && i<=lpage*pagesPerScreen; i++){
			if(i==(lpage-1)*pagesPerScreen+1){
				pageClass = " class='sta'";
			}else{
				pageClass = "";
			}
			if(i==currPage){
				out.println("<font style='font-size:12px; color:#4d4d4d;'>"+i+"</font>&nbsp;");
			}
			else{
				out.println("<a href='"+pageCommonUrl+",\""+i+"\")' class='paging'>"+i+"</a>&nbsp;");
			}
		}

		if(currPage<pages) {
	        if((currPage%5)==0)
	            tmpLpage = lpage + 1;
            else
                tmpLpage = lpage;
            out.println("<a href='"+pageCommonUrl+",\""+(currPage+1)+"\")'><img src='/images/front/button/page_next01.gif' class='pointer' style='vertical-align:middle;' alt='nextPage' /></a>&nbsp;");
        }
		else{
			out.println("<img src='/images/front/button/page_next01.gif' class='pointer' style='vertical-align:middle;' alt='nextPage' />&nbsp;");
		}

		// next button
		if(lpage<lpages){
			out.println("<a href='"+pageCommonUrl+",\""+((lpage*pagesPerScreen)+1)+"\")'><img src='/images/front/button/page_next02.gif' class='pointer' style='vertical-align:middle;' alt='lastPage' /></a>");
		}
		else{
			out.println("<img src='/images/front/button/page_next02.gif' class='pointer' style='vertical-align:middle;' alt='lastPage' />");
		}
	}

	/**
	 * <pre>
     * ������ �׺�����͸� out �� ���� ����Ѵ�.
     * �ʺ�,�������� ��±� �������� Config�� ����� ���� �����
     *
     * Config.BORRD_LIST_CNT
     * Config.BOARD_PAGE_CNT
     *
     * </pre>
     *
     * @param pageCommonUrl ���α׷� �̸��� argument ����
     * @param totCount ��ü �Խñ� ī��Ʈ
     * @param currPage ���� ������ ��ȣ
     */
    public void printDividedPageAdmin( String pageCommonUrl,
	     							 int totCount,
         							 int currPage) throws Exception {


		SiteContext sc = SiteContext.getInstance();
         printDividedPageAdmin(pageCommonUrl,totCount,currPage,
	         	 sc.getInt("admin.list.cnt"), sc.getInt("admin.page.cnt"));
    }

	/**
     * ������ �׺�����͸� out �� ���� ����Ѵ�.
     *
     * @param pageCommonUrl ���α׷� �̸��� argument ����
     * @param totCount ��ü �Խñ� ī��Ʈ
     * @param currPage ���� ������ ��ȣ
     * @param articlesPerPage �������� ��� �� ����
     * @param pagesPerScreen ��ũ���� Page ����
     * @param tableWidth ���̺� �ʺ� ( 500, 100% )
	*/
    public void printDividedPageAdmin(String pageCommonUrl,
	                                int totCount,
                                    int currPage,
                                    int articlesPerPage,
                                    int pagesPerScreen) throws Exception {

		int pages  = (totCount-1)/articlesPerPage + 1;
        int lpages = (pages-1)/pagesPerScreen + 1;
        int lpage  = (currPage-1)/pagesPerScreen + 1;
        int tmpLpage;

        if(pageCommonUrl != null){
            if(pageCommonUrl.indexOf("?") == -1) pageCommonUrl += "?";
            else pageCommonUrl += "&amp;";
        }
        else return;

        // �������� ����Ѵ�.

        // prev button
        if(lpage>=2){
	        out.println("<a href='"+pageCommonUrl+"_currPage="+(((lpage-2)*pagesPerScreen)+1)+"'><img src='http://ui.dnt7.com/backoffice/images/btn/pre_dubble_button.png' alt='prePage' /></a>");
        }
        else{
            out.println("<img src='http://ui.dnt7.com/backoffice/images/btn/pre_dubble_button.png' alt='prePage' />");
        }

        if(currPage > 1) {
	        if((currPage%5)==0)
	            tmpLpage = lpages - 1;
            else
                tmpLpage = lpages;
            out.println("<a href='"+pageCommonUrl+"_currPage="+(currPage-1)+"&amp;lpage="+tmpLpage+"' ><img src='http://ui.dnt7.com/backoffice/images/btn/pre_button.png' alt='prePage'/></a>");
        }
        else{
            out.println("<img src='http://ui.dnt7.com/backoffice/images/btn/pre_button.png' alt='prePage' />");
        }

        // Print Pages

        int pageCnt = 0;
        for(int i=(lpage-1)*pagesPerScreen+1; i<=pages && i<=lpage*pagesPerScreen; i++){
            if(i==currPage){
	            out.println("<font class='f_b'>"+i+"</font>");
            }
            else{
                out.println("<font class='f_b'><a href='"+pageCommonUrl+"_currPage="+i+"'>"+i+"</a></font>");
            }
        }

        if(currPage<pages) {
	        if((currPage%5)==0)
	            tmpLpage = lpage + 1;
            else
                tmpLpage = lpage;
            out.println("<a href='"+pageCommonUrl+"_currPage="+(currPage+1)
                        +"&amp;lpage="+tmpLpage+"' ><img src='http://ui.dnt7.com/backoffice/images/btn/next_button.png' alt='nextPage' /></a>");
        }
        else{
            out.println("<img src='http://ui.dnt7.com/backoffice/images/btn/next_button.png' alt='nextPage' />");
        }

        // next button
        if(lpage<lpages){
	        out.println("<a href='"+pageCommonUrl+"_currPage="+((lpage*pagesPerScreen)+1)+"'><img src='http://ui.dnt7.com/backoffice/images/btn/next_dubble_button.png' alt='nextPage' /></a>");
        }
        else{
            out.println("<img src='http://ui.dnt7.com/backoffice/images/btn/next_dubble_button.png' alt='nextPage' />");
        }
    }


	/**
	 * ���� ���ε� ���� ����Ѵ�.
	 * @param inptName	file input�� �̸�
	 * @param del ������ ��ϵ� ���ϸ�(������ ����)
	 *
	 */
	public void printFileUpload(String inptName, String file_name) throws Exception {
		printFileUpload(inptName, file_name, 350);
	}

	public void printFileUpload(String inptName, String file_name, int inptSize) throws Exception {
		String fileName = file_name;

		if( fileName==null ) fileName = "";
		out.println("<table cellspacing=0 cellpadding=0 border=0>");
		out.println("   <tr>");
		out.println("       <td style=\"padding:0px 0px 0px 0px;border-bottom:0px;\">");
		out.println("           <input type=hidden name=\"" + inptName + "_origin\" value=\"" + fileName + "\">");
		out.println("           <input type=text style='width:" + inptSize + "px;' name='" + inptName + "_show' value=\"" + fileName + "\" readonly  class='txt'>&nbsp;");
		out.println("       </td>");
		out.println("		<td style=\"padding:0px 0px 0px 0px;border-bottom:0px;\">");
		out.println("			<span style=\"width:65px;height:18px;background:url(/images/btn/bts_search.gif) no-repeat 0px 0px;cursor:hand;\">");
		out.println("			<div style='overflow:hidden;width:63px;height18px;'><input type=\"file\" name=\""+inptName+"\" style=\"width:0;height:18px;filter:alpha(opacity=0);border-width:0;cursor:hand;border:0px;\" onchange=\""+inptName+"_show.value=this.value;\">");
		out.println("		</td>");
		/*
		out.println("       <td>");
		out.println("           <span style='overflow:hidden; width:63px; height:18px; background-image:url(/images/btn/bts_search.gif);' OnMouseOver=\"this.style.backgroundImage='url(/images/btn/bts_search.gif)';\" OnMouseOut=\"this.style.backgroundImage='url(/images/btn/bts_search.gif)';\">    ");
		out.println("           <div height='22px' style='overflow:hidden;width:68px;height:22px;filter:alpha(opacity=0)'>");
		out.println("           <input type='file' name='" + inptName + "' style='width:0;' OnChange='" + inptName + "_show.value=this.value' style='cursor:hand;'>");
		out.println("           </div></span>");
		out.println("       </td>");
		*/
		out.println("   </tr>");
		out.println("</table>");
	}
}
