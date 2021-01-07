/**  
 //  =============================================================
 //
 //  Purpose: fill the path table
 //
 //  Usage:   java buildPaths
 //
 //  Prerequisite: tables path, relations, entry
 //
 //  sc
 //  =============================================================
 */

// package and import declaration

import java.sql.*;
import java.io.*;
import java.util.*;

// class declaration

public class buildPaths  {
    
    private static final String dbDriver = "org.postgresql.Driver";
    private static final String dbUrl    = "jdbc:postgresql://bert:5432/come";
    private static final String dbUser   = "sc";
    private static final String dbPass   = "sc";
    
    private static PreparedStatement get_leaves  = null;
    private static PreparedStatement get_parents = null;
    private static PreparedStatement store_pathItem  = null;
    private static PreparedStatement trunca_path  = null;
        
    static Connection con = null;

    //static Vector v_aStep;   //id, ptoc, child
    static Vector v_aPath;   //vector of aStep
    static Vector v_LIFO;    //vector of aPath
    static int ipath = 0;    //set the pathid     
    
    public static void main (String[] args)
        throws IOException, SQLException, ClassNotFoundException 
    { 
        try {
            Class.forName(dbDriver);
        }
        catch( Exception e ){
            e.printStackTrace();
            return;
        }
 
        try {
            con = DriverManager.getConnection(dbUrl, dbUser, dbPass);
    
            //System.out.println("connected!!");
     
            //
            // setting up cursors
            //
     
            get_leaves = con.prepareStatement
                ("select distinct e.id, e.old_id, e.name " +
                 "from relations r, entry e " +
                 "where e.id = r.id " + 
                 "and e.id not in " +
                 "(select distinct parent from relations)");
    
            get_parents = con.prepareStatement
                ("select distinct r.parent, e.old_id, e.name, r.ptoc " +
                 "from relations r, entry e " +
                 "where e.id = r.parent " +
                 "and r.id = ? ");
    
            store_pathItem = con.prepareStatement
                ("insert into path " +
                 "(path, id, rel, child, len) " +
                 "values (?, ?, ?, ?, ?)");
     
            trunca_path = con.prepareStatement
                ("truncate table path ");

            trunca_path.execute();
            System.out.println("== table truncated ==");

            //v_aStep = new Vector(50);
            v_aPath = new Vector(50);
            v_LIFO  = new Vector(50);
            int stopper=0;       // we can remove that

            //
            // getting the results
            //
            ResultSet c_leaves = get_leaves.executeQuery();
            while(c_leaves.next()){
                stopper++;
                int    leaf_id   = c_leaves.getInt(1);
                String leaf_kid  = c_leaves.getString(2);
                String leaf_name = c_leaves.getString(3);
      
                System.out.println(leaf_id+": "+leaf_kid+"::"+leaf_name);
                System.out.println("==========================");
      
                exploreBranch(leaf_id);
                while (!v_LIFO.isEmpty())
                    {
                        // let's put last FIFO in a_path
                        int last = v_LIFO.size() -1;
                        System.out.println("\nLIFO"+last);
                        v_aPath = (Vector)((Vector)v_LIFO).remove(last);
        
                        // get the id to explore...
                        //Integer id =(Integer) ((Vector)v_aPath.get(0)).get(0);
                        Vector v1 = ((Vector)v_aPath.lastElement());
                        Integer id =(Integer) v1.get(0);
                        exploreBranch(id.intValue());
                    }
                if (stopper > 1000) break;
            }
        }
        catch( Exception e ){
            e.printStackTrace();
            return;
        }
    }

    
    static void exploreBranch(int i)
        throws SQLException {
        int query_id = i;
        System.out.println("------>exploring "+i+"<-------");
    
        while (query_id > 0){
            // getting parents
            int nr_of_rows = 0;

            int child_id = query_id;

            get_parents.setInt( 1, query_id);
            ResultSet c_parents = get_parents.executeQuery();

            Vector v_aPathCopy = new Vector(50);

            while(c_parents.next()){
                int id   = c_parents.getInt(1);
                String kid  = c_parents.getString(2);
                String name = c_parents.getString(3);
                String ptoc = c_parents.getString(4);

                Vector v_aStep = new Vector(50);   //id, ptoc, child
                v_aStep.addElement(new Integer(id));
                v_aStep.addElement(new String(ptoc));
                //v_aStep.addElement(new Integer(query_id));
                v_aStep.addElement(new Integer(child_id));
      
                nr_of_rows++;      
                if (nr_of_rows == 1 )
                    {
                        System.out.println(query_id+" get "+id+ " [" + kid + "]..");
                        // do a copy of the path up to now
                        //v_aPathCopy = (Vector)v_aPath.clone();
                        v_aPathCopy = copyPath(v_aPath);

                        // add last step to path and move up pointer in the path
                        //addToPath();
                        v_aPath.addElement(new Vector(v_aStep));
                        query_id = id;
                    }
                if (nr_of_rows > 1)
                    { 
                        // we have more than 1 parent: branch the path

                        System.out.println(".. and "+id+" ("+nr_of_rows+") [" + kid + "]");

                        Vector v_thisPathCopy = new Vector(50);

                        v_thisPathCopy = copyPath(v_aPathCopy);
                        v_thisPathCopy.addElement(new Vector(v_aStep));
        
                        //addToLIFO();      
                        v_LIFO.addElement(new Vector(v_thisPathCopy));
                    }

                // clean v_aStep
                v_aStep.removeAllElements();
            }
            // if no parents found, this path is done..
            if (nr_of_rows == 0)
                {
                    ipath++;
                    storePath(v_aPath);
                    //showPath(v_aPath);
                    v_aPath.removeAllElements();
                    //v_aPathCopy.removeAllElements();
                    query_id =0;  
                }
        }
    }
    
    static void storePath(Vector v)
        throws SQLException {     
        // 
        int depth = v.size() -1;
        int level = 0;

        System.out.println("-----------------------");
        System.out.println(">  path "+ ipath );
        System.out.println("-----------------------");

        for ( int i=depth; i>=0; i-- )
            {  
                Integer id    = (Integer)((Vector)v.get(i)).get(0);
                String rel    =  (String)((Vector)v.get(i)).get(1);
                Integer child = (Integer)((Vector)v.get(i)).get(2);
  
                System.out.println(id +"|"+rel+"|"+child+"|");

                store_pathItem.setInt( 1, ipath );
                store_pathItem.setInt( 2, id.intValue());
                store_pathItem.setString( 3, rel);
                store_pathItem.setInt( 4, child.intValue());
                store_pathItem.setInt( 5, level);
  
                store_pathItem.executeUpdate();
                //int storedRows = store_pathItem.getUpdateCount();
                level ++; 
                if (i ==0 )
                    {
                        // let's store the leaf too as id (not only child)
                        // note: id=child
                        store_pathItem.setInt( 1, ipath );
                        store_pathItem.setInt( 2, child.intValue());
                        store_pathItem.setString( 3, "=");
                        store_pathItem.setInt( 4, child.intValue());
                        store_pathItem.setInt( 5, level);
   
                        store_pathItem.executeUpdate();
                    }
            }
    }
    
    
    static void showPath(Vector v){
        int depth = v.size() -1;
        int level = 0;
        System.out.println("-------------------------");
 
        for ( int i=depth; i>=0; i-- )
            {  
                Integer id    = (Integer)((Vector)v.get(i)).get(0);
                String rel    =  (String)((Vector)v.get(i)).get(1);
                Integer child = (Integer)((Vector)v.get(i)).get(2);

                StringBuffer showbuf  = new StringBuffer();
                showbuf.append ("["+i+"]"+id+"|"+rel+"|"+child);
                System.out.println(showbuf.toString());
            }
    }

    static Vector copyPath(Vector v){

        Vector v_aCopy = new Vector(50);

        for ( int i=0; i < v.size(); i++ )
            {  
                Integer id    = (Integer)((Vector)v.get(i)).get(0);
                String  rel   =  (String)((Vector)v.get(i)).get(1);
                Integer child = (Integer)((Vector)v.get(i)).get(2);

                Vector v_aStep2 = new Vector(50);
      
                v_aStep2.addElement(id);
                v_aStep2.addElement(rel);
                v_aStep2.addElement(child);

                v_aCopy.addElement(new Vector(v_aStep2));
            }
        return v_aCopy;
    }

}
