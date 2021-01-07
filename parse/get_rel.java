//file: ListIt.java
import java.io.*;
import java.util.*;

class getRel 
{
    public static void main ( String args[] ) throws Exception {
        File file =  new File( args[0] );
        
        if ( !file.exists() || !file.canRead(  ) ) {
            System.out.println( "Can't read " + file );
            return;
        }
        
        if ( file.isDirectory(  ) ) {
            String [] files = file.list(  );
            for (int i=0; i< files.length; i++)
                System.out.println( files[i] );
        }
        else
            try {
                FileReader fr = new FileReader ( file );
                BufferedReader in = new BufferedReader( fr );
                String line;
                int n;

                while ((line = in.readLine(  )) != null)
                    {
                        StringTokenizer tok = new StringTokenizer (line, "% ");

                        n = tok.countTokens();
                        String parent = tok.nextToken();
                        // this is to skip first field (coordination?)
                        // n.: loop starts from 2 for this reason
                        tok.nextToken();

                        for ( int i = 2; i < n; i++)
                            {
                                System.out.println(parent + 
                                                   " " + 
                                                   tok.nextToken());
                            }

                        n = 0;

                    }
            }
        catch ( FileNotFoundException e ) {
            System.out.println( "File Disappeared" );
        }
    }
}
