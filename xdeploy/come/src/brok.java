/**  
//  =============================================================
//
//  Purpose: dispatch html form requests 
//
//  Usage:   http://www.ebi.ac.uk/come..
//
//  $Source: /home/contrino/come/webapp/contrino/come/RCS/brok.java,v $
//  $Date: 2004/03/15 13:04:01 $
//  $Author: contrino $
//
//  _____________________________________________________________
//
//  $Log: brok.java,v $
//  Revision 1.3  2004/03/15 13:04:01  contrino
//  untabified
//
//  Revision 1.2  2003/05/09 15:18:17  contrino
//  added comeX and comeIns
//
//  =============================================================
*/

// package and import declaration

//import java.sql.*;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
//import oracle.jdbc.driver.*;


// class declaration

public class brok extends HttpServlet {
    

    private String comeLink;  
    private String css;  
    private String home;  
    
    //    private static PreparedStatement query_entry = null;
        
    /**
    doGet is called for each GET request
    */
    public void doGet(HttpServletRequest req, HttpServletResponse res)
        throws IOException, ServletException {
 
        String qt    = req.getParameter("query_term");
        String view  = req.getParameter("view");
 
        res.setContentType("text/html");
        PrintWriter out = res.getWriter();       

        //.getRequestDispatcher("/servlet/ItemServlet?item="+item)
        // print header of html page
        out.println("<html><head>" + 
                    // no underlined links
                    //"<style><!-- A{text-decoration:none} --></style>" +
                    "<link rel=\"stylesheet\" href=\"" + css + "\" type=\"text/css\">" +
                    "<title>"+ view +": "+ qt + "</title></head>"); 
        
        if ( view.equals("entry"))
            {
                getServletContext()
                    .getRequestDispatcher("/entry?gn="+qt)
                    .include(req, res);
            }
        else if (view.equals("pathrough"))
            {
                getServletContext()
                    .getRequestDispatcher("/pathrough?gn="+qt)
                    .include(req, res);
            }
        else if (view.equals("comePath"))
            {
                getServletContext()
                    .getRequestDispatcher("/path?nr="+qt)
                    .include(req, res);
            }
        else if (view.equals("findIns"))
            {
                getServletContext()
                    .getRequestDispatcher("/findIns?gn="+qt)
                    .include(req, res);
            }
        else if (view.equals("byXref"))
            {
                getServletContext()
                    .getRequestDispatcher("/byXref?gn="+qt)
                    .include(req, res);
            }
        else 
            {
                getServletContext()
                    .getRequestDispatcher("/find?gn="+qt)
                    .include(req, res);
         }
        out.println("</body></html>");
        
        out.close();
    }
    
    
    /**
       doPost is called for each POST request
    */
    public void doPost(HttpServletRequest req, HttpServletResponse res)
 throws IOException, ServletException {
 // we simply map POSTs to GETs
 doGet(req, res);
    }
    
    
    /**
       init is called once for when the servlet is requested for the
    first time.
    */
    public void init(ServletConfig config) throws ServletException {
 // call init of HttpServlet first
 super.init(config); 

 // get properties
 getProperties();

    }
  
    
    /**
       get properties
    */
    synchronized void getProperties() {
        try {
            // figure out the name of the props file
            String propertiesfile = "come.props";
     
            // this approach will read from the top of any CLASSPATH entry
            InputStream is = getClass().getResourceAsStream("./" + propertiesfile);
          
            Properties p = new Properties();
            // load the file into the Properties object
                 p.load(is);

            // set the properties
            this.comeLink = p.getProperty("comeLink");
            this.css = p.getProperty("css");
            this.home = p.getProperty("home");
            
        } catch (Exception e) {
            throw new RuntimeException("UNABLE TO INITIALIZE, EXITING...");
        }
    }
}
