/**  
//  =============================================================
//
//  Purpose: builds an html pages after querying come db
//           for a given old_id
//
//  Usage:   http://wwwdev.ebi.ac.uk:8080/servlets/contrino/come?gn=z
//
//  $Source: /home/contrino/come/webapp/contrino/come/RCS/come.java,v $
//  $Date: 2004/03/15 15:27:58 $
//  $Author: contrino $
//
//  _____________________________________________________________
//
//  $Log: come.java,v $
//  Revision 1.19  2004/03/15 15:27:58  contrino
//  *** empty log message ***
//
//  Revision 1.18  2004/03/15 13:02:02  contrino
//  untabified
//
//  Revision 1.17  2003/10/17 11:59:33  contrino
//  added path links
//
//  Revision 1.16  2003/02/13 17:06:24  contrino
//  -added formula (graph) display
//
//  Revision 1.15  2002/10/23 13:09:09  contrino
//  - now uses property file.
//  - destroy called at the end.
//
//  Revision 1.14  2002/07/17 15:38:51  contrino
//  added some links
//
//  Revision 1.13  2002/07/11 14:22:04  contrino
//  added doc link
//
//  Revision 1.12  2002/07/11 10:10:42  contrino
//  change of url (www2)
//
//  Revision 1.11  2001/11/06 16:36:57  contrino
//  changed mailto in footer
//
//  Revision 1.10  2001/09/14 13:49:33  contrino
//  added coordination
//
//  Revision 1.9  2001/08/24 09:38:29  contrino
//  - corrected display of dbxref
//  - changed colors
//
//  =============================================================
*/

// package and import declaration

import java.sql.*;
import java.io.*;
import java.util.*;
import javax.servlet.*;
import javax.servlet.http.*;
import org.postgresql.Driver.*;
//import oracle.jdbc.driver.*;

// class declaration

public class come extends HttpServlet {
    
    private String dbDriver;
    private String dbURL;   
    private String dbUser;  
    private String dbPassword;  

    private String comeLink;  
    private String allPathLink;  
    private String css;  
    private String home;  
    private String formulae;  
    private String dags;  
    private String footer;  
    
    private static PreparedStatement query_entry = null;
    private static PreparedStatement query_db = null;
    private static PreparedStatement query_instance = null;
    private static PreparedStatement query_parents  = null;
    private static PreparedStatement query_children = null;
    private static PreparedStatement query_date = null;
    
    static Connection con = null;
    
    /**
       doGet is called for each GET request
    */
    public void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException {
    
    String gn = req.getParameter("gn");
    
    res.setContentType("text/html");
    PrintWriter out = res.getWriter();       
    
    checkConnection();
 
try {
    
    //
    // setting up cursors
    //
     
    query_entry = con.prepareStatement
/* oracle version
        ("SELECT distinct l.name, l.id, l.coordination, c.description, l.formula " +
         "FROM entry l, coordination c " +
         "WHERE l.old_id = upper('" + gn + "')" +
         "AND l.coordination = c.coordination (+)");
    //   "ORDER BY l.id");
*/


	("SELECT distinct l.name, l.id, l.coordination, c.description, l.formula "
	+ " FROM entry l LEFT JOIN coordination c "
        + " ON l.coordination = c.coordination "
        + " WHERE l.old_id = upper('" + gn + "')");
	
	  
    query_db = con.prepareStatement
        ("SELECT distinct dd.dbabbrev, d.dbid, dd.dblink, dd.link_end " +
         "FROM database dd, db_xref d " +
         "WHERE dd.dbcode = d.dbcode " + 
         "and d.id_come = ?");
    
    query_instance = con.prepareStatement
        ("SELECT distinct i.instance, i.id_instance, "+
         "i.species, i.state, i.centre " +
         "FROM instance i " +
         "WHERE i.id = ?");
    
    query_parents = con.prepareStatement
        ("SELECT distinct e.name, e.id, e.old_id, r.type " +
         "FROM entry e, relations r " +
         "WHERE r.parent = e.id " +
         "and r.id = ? " +
         "order by r.type"); 
    
    query_children = con.prepareStatement
        ("SELECT distinct e.name, e.id, e.old_id, r.ptoc " +
         "FROM entry e, relations r " +
         "WHERE r.id = e.id " +
         "and r.parent = ? " + 
         "order by r.ptoc"); 
    
    query_date = con.prepareStatement
        //("SELECT substr(sysdate,1,11) from dual ");
        ("SELECT current_date ");
    
    // print header of html page
    out.println("<html><head>" + 
                // no underlined links
                //"<style><!-- A{text-decoration:none} --></style>" +
                "<link rel=\"stylesheet\" href=\"" + css + "\" type=\"text/css\">" +
                "<title>*"+ gn + "*</title></head>"); 
    
    //
    // getting the results
    //
    
    int id  = 0;
    int idi = 0;
    int cpid = 0;
    int ccid = 0;
    int ci  = 0;     //instance counter
    
    boolean prx = false;
    
    String name     = null; // come entry  
    String dbid     = null; 
    String db       = null;
    String coorcode = "";
    String coordesc = "";
    String formula  = null; //flag 'is there a drawing?'
    String instance = "";
    String species  = "";
    String state    = "";
    String centre   = "";
    String pold_id  = "";   // parent old_id
    String cold_id  = "";   // child  old_id
    String pname    = "";   
    String cname    = "";
    String link     = "";
    String linkEnd  = "";
    String prel     = "";   // relationship (child->parent)
    String crel     = "";   // relationship (child<-parent)
    String date = null;


    // are we processing a protein?
    if ( gn.substring(0,2).toUpperCase().equals("PR")) prx = true; 

    //
    // getting the results
    //
    ResultSet entry_cursor = query_entry.executeQuery();
    while(entry_cursor.next()){
        name = entry_cursor.getString(1);
        id   = entry_cursor.getInt(2);
        coorcode = entry_cursor.getString(3);
        coordesc = entry_cursor.getString(4);
        formula  = entry_cursor.getString(5);
    }
          
    // getting db
    query_db.setInt( 1, id);
    ResultSet db_cursor = query_db.executeQuery();
    while( db_cursor.next()){
        db    = db_cursor.getString(1);
        dbid  = db_cursor.getString(2);
        link  = db_cursor.getString(3);
        linkEnd  = db_cursor.getString(4);
    }
    
    if ( id == 0 )
        out.println("Sorry, no record found for identifier <b>" + gn + "</b>.");
    // *** add link to beginning of tree 9prx00001?
    
    else
        {
            //beginning of html     
            out.println("<center><nobr class=\"pagetitle\">COMe entry " + gn + 
                        //"<td class=\"tablegreen\">" +
                        //"<span class=\"whitetitle\">" + gn + "</span></tr>" +
                        "<table>"+
                        "<tr><td align=center colspan=2 class=\"tablegreen\"><span class=\"whitetitle\">" + name + "</span></tr>" +
                        "</table></center><p>");
            
            //display coordination (if any)
            if ( coorcode != null )
                out.println("<center><b>" + coorcode +
                            "</b> " + coordesc + " coordination </center><p>"); 
            
            if ( formula != null )
                out.println("<center><IMG id=\""+gn+"\" " +  
                            "SRC=\""+ formulae +
                            gn.toUpperCase() + "." + formula+ "\"" +  
                            "BORDER=0 >");
            
            if ( dbid != null )
                {
                    if ( db.toUpperCase().equals("MEROPS"))
                        link = link + dbid.toLowerCase().replace('.','p') + ".htm";
                    else link = link + dbid;
                    out.println("see also: <a href=\"" + link);
                    if ( linkEnd != null ) out.println( linkEnd ); 
                    out.println( "\">" + db + " " + dbid + "</a>");
                }
            
            out.println("<p>");
            
            // getting instance
            query_instance.setInt( 1, id);     
            ResultSet instance_cursor = query_instance.executeQuery();
            while( instance_cursor.next()) 
                {
                    instance = instance_cursor.getString(1);
                    idi      = instance_cursor.getInt(2);
                    if ( prx )
                        {
                            species  = instance_cursor.getString(3);
                            state    = instance_cursor.getString(4);
                            centre   = instance_cursor.getString(5);
                            if ( species == null ) species = "<pre> </pre>";
                            if ( state == null ) state = "<pre> </pre>";
                            if ( centre == null ) centre = "<pre> </pre>";
                        }
                    ci++;
                    if ( ci == 1 )
                        {
                            out.println("<table width=\"100%\" class=\"tabletop\">" +
                                        "<tr class=\"tablebody\"><td><b>Instance</b></td>");
                            if ( prx )
                                out.println("<td><b>Species</td><td><b>State</td><td><b>Centre</td>");
                        }
                    
                    // getting db for instances
                    query_db.setInt( 1, idi);
                    StringBuffer dbibuf = new StringBuffer();
                    ResultSet dbi_cursor = query_db.executeQuery();
                    
                    int cdx = 0;   // dbxref counter (for each instance)
                    while( dbi_cursor.next()){
                        cdx++;
                        
                        if ( ci * cdx == 1 )  out.println("<td><b>External reference</td>");    
                        if ( cdx == 1 ) dbibuf.append("<td>");
                        
                        db   = db_cursor.getString(1);
                        dbid = db_cursor.getString(2);
                        link = db_cursor.getString(3);
                        linkEnd = db_cursor.getString(4);
                        
                        // deal with merops naming..
                        if ( db.toUpperCase().equals("MEROPS"))
                            link = link + dbid.toLowerCase().replace('.','p') + ".htm";
                        else link = link + dbid;
                        
                        dbibuf.append("<a href=\"" + link );
                        if ( linkEnd != null ) dbibuf.append( linkEnd ); 
                        dbibuf.append( "\">" + db + ":" + dbid + "</a><br>");
                    }
                    
                    out.println("</tr><tr><td>" + instance + "</td>");
                    
                    if ( prx )
                        out.println("<td>" + species + "</td><td>" + state + "</td><td>" + centre + "</td>");
                    out.println( dbibuf.toString());
                }
            
            if (ci > 0 )  out.println("</tr></table>");
            
            out.println("<p>");
            
            // getting parents' ids
            query_parents.setInt( 1, id);     
            StringBuffer parbuf = new StringBuffer();
            ResultSet parents_cursor = query_parents.executeQuery();
            while( parents_cursor.next()){
                pname    = parents_cursor.getString(1);
                pold_id  = parents_cursor.getString(3);
                prel     = parents_cursor.getString(4);
                if ( cpid > 0 ) parbuf.append("<tr>");
                parbuf.append("<td>" + prel + "<td>" + pname + 
                              "<td><a href=\"" + comeLink + pold_id + "\">" + pold_id + "</a>" + 
                              "</tr>" );
                cpid++;
            }
            
            // getting children's ids
            query_children.setInt( 1, id);     
            StringBuffer carbuf = new StringBuffer();
            ResultSet children_cursor = query_children.executeQuery();
            while( children_cursor.next()){
                cname    = children_cursor.getString(1);
                cold_id  = children_cursor.getString(3);
                crel     = children_cursor.getString(4);
                if ( ccid > 0 ) carbuf.append("<tr>");
                carbuf.append("<td>" + crel + "<td>" + cname + 
                              "<td><a href=\"" + comeLink + cold_id + "\">" + cold_id + "</a>" + 
                              "</tr>" );
                ccid++;
            }
            
      // 
      // html display
      //
      // the blank is for avoiding the merge of empty cells
      //

      // ontology header
      if ( cpid + ccid > 0 )    
          out.println("<hr><center><table><tr><td class=\"tablegreen\">" + 
                      "<span class=\"whitetitle\">COMe ONtology</span></table></center>");
      
      // parents table
      if ( cpid > 0 )
          {
              out.println("<table width=\"100%\">" +
                          "<colgroup><col width=\"15%\"><col width=\"70%\"><col width=\"15%\">"); 
              out.println("<tr>" 
                          + parbuf.toString() +"</table>");
              out.println("<center><IMG id=\"up\" " +  
                          "SRC=\"" + home + "icons/up.gif\"" +  
                          "BORDER=0  ALT=\"up\">");
          }
      
      // entry
      if ( cpid + ccid > 0 )    
          out.println("<center><table bgcolor=lightyellow>" +
                      "<th>" + name + " </tr> </table></center>"); 
      
      // children table
      if ( ccid > 0 )
          {
              out.println("<center><IMG id=\"down\" " +  
                          "SRC=\"" + home + "icons/down.gif\"" +  
                          "BORDER=0  ALT=\"down\">");
              
              out.println("<table width=\"100%\">"); 
              out.println("<colgroup><col width=\"15%\"><col width=\"70%\"><col width=\"15%\">"); 
              out.println("<tr>" + 
                          carbuf.toString() +"</table>");
          }
        }
    
    // get the date from oracle
    ResultSet date_cursor = query_date.executeQuery();
    while(date_cursor.next()){
        date = date_cursor.getString(1);
    } 
    
    
    //to paths
    out.println("<hr><table width=\"100%\">" +
                "<colgroup><col width=\"50%\"><col width=\"50%\">"); 
/* removed because of memory problems    
    out.println("<tr align=center class=\"tabletop\">" +
                "<td><a class=\"black\" href=\"" +
                allPathLink + gn + "\">" +
                "All COMe paths through " +
                gn + "</a></td><td>");
*/
    out.println("<tr align=center class=\"tabletop\"><td>");

    
    //files too big.. needs something cleverer
    if ( !(gn.toUpperCase().equals("PRX000001") ||
           gn.toUpperCase().equals("PRX000002") ||
           gn.toUpperCase().equals("PRX000230") ||
           gn.toUpperCase().equals("PRX000004")) )
        {
            out.println("<a class=\"black\" href=\"" +
                        dags + gn.toUpperCase() + ".html\">" +
                        "Graphical view</a>");
        }
    out.println("</td></table>");
    
    
    // footer 
    out.println(footer);
    out.println("</center><i><font class=small>This report was created:" + date + "</font></i>");
    
    out.println("</body></html>");
}

catch (SQLException sqle){
    out.println("<i>Sorry, there was an SQLError: "+sqle+"</i>");
}

out.close();
destroy();
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
        
        // try to get a connection 
        dbConnect();
    }
    
    
    /**
       destroy is called once when the servlet is not required any more.
    */
    public void destroy(){
        // close any open connections
        dbDisconnect();
    }
    
    
    /**
       try to connect to the database
    */
    void dbConnect() throws ServletException {
        
        try {
            
            // load (and therefore register) the JDBC driver
            // might trow a ClassNotFoundException
            Class.forName(this.dbDriver);
            //Class.forName(dbDriver).newInstance();
            
            //  DriverManager.registerDriver(new oracle.jdbc.driver.OracleDriver());
            
            // get a connection to database
            // might throw a SQLException
            
            con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            
            // for debugging: report successful connection
            log(this.getClass().getName()+": Connected");
            
        }catch (ClassNotFoundException cnfe){
            log("Driver not found");
            throw new UnavailableException("Driver not found");
        } catch (SQLException sqle){
            log("Cant connect to database");
            throw new UnavailableException("Cant connect to database");
        } catch (Exception anything){
            log("Other exception:" + anything);
            throw new UnavailableException("Can't connect to database");
        } 
    }
    
    /**
       check if our connection is alive
    */
    void checkConnection() throws ServletException {
        try {
            con.setAutoCommit(false);
        } catch (Exception ignored){
            dbConnect();
        }
        if (con == null) 
            throw new UnavailableException("Can't connect to database");
    }
    
  /**
     close the connection if there is one
  */
    synchronized void dbDisconnect() {
        try {
            if (con != null){
                con.close();
                con = null;
                // for debugging: report successful connection
                log(this.getClass().getName()+": Disconnected");
            }
        } catch (SQLException ignore){}
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
            this.dbDriver = p.getProperty("dbDriver");
            this.dbURL = p.getProperty("dbURL");
            this.dbUser = p.getProperty("dbUser");
            this.dbPassword = p.getProperty("dbPassword");
            
            this.comeLink = p.getProperty("comeLink");
            this.css = p.getProperty("css");
            this.home = p.getProperty("home");
            this.formulae = p.getProperty("formulae");
            this.dags = p.getProperty("dags");
            this.allPathLink = p.getProperty("allPathLink");
            this.footer = p.getProperty("footer");
            
        } catch (Exception e) {
            throw new RuntimeException("UNABLE TO INITIALIZE, EXITING...");
        }
    }   
}
