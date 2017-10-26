using System;
using System.Data;
using System.Data.Odbc;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

/// <summary>
/// Summary description for db
/// </summary>
public class db
{
    public static OdbcConnection myConnection;

	public db()
	{
		//
		// TODO: Add constructor logic here
		//
	}

    public static void openConnection(){
        //string ConnectionString = @"driver={MySQL ODBC 3.51 Driver};server=79.99.43.20;database=hydrahomes1;uid=hydrahomes1;pwd=s37776;";
        string ConnectionString = @"driver={MySQL ODBC 3.51 Driver};server=localhost;database=snig_db;uid=snig_usr;pwd=snigger1;";
        //string ConnectionString = @"driver={MySQL ODBC 3.51 Driver};server=localhost;database=hydrahomes;uid=root;pwd=red;";
    if ((object)myConnection == null){
        if(myConnection.State == ConnectionState.Closed){
            myConnection = new OdbcConnection(ConnectionString);
        }
        }
        myConnection.Open();
    }

    public static OdbcConnection connect()
    {
        //int i = killConnections();

        //string ConnectionString = @"driver={MySQL ODBC 3.51 Driver};server=79.99.43.20;database=hydrahomes1;uid=hydrahomes1;pwd=s37776;";
        string ConnectionString = @"driver={MySQL ODBC 3.51 Driver};server=localhost;database=snig_db;uid=snig_usr;pwd=snigger1;";
        //string ConnectionString = @"driver={MySQL ODBC 3.51 Driver};server=localhost;database=hydrahomes;uid=root;pwd=red;";
    if ((object)myConnection == null){
        myConnection = new OdbcConnection(ConnectionString);
        }
        if (myConnection.State == ConnectionState.Closed)
        {
            myConnection.Open();
        }
        return myConnection;
    }

    public static int killConnections(){
         OdbcConnection con = connect();
         int i = 0;
         string sql = "show full processlist";

         OdbcCommand cmd = new OdbcCommand(sql, con);
         OdbcCommand cmd2;

         OdbcDataReader dr = cmd.ExecuteReader();

         while (dr.Read())
         {
             if (Convert.ToInt16(dr["Time"]) > 60)
             {
                 sql = "kill " + dr["Id"].ToString();
                 i++;
                 cmd2 = new OdbcCommand(sql, con);
                 cmd2.ExecuteNonQuery();
             }
         }
         return i;
    }

    public static bool closeconnection()
    {
        try
        {
            myConnection.Close();
            return true;
        }
        catch
        {
            return false;
        }
    }

    public static OdbcDataReader alerts(int start, int limit)
    {
        string sql;
        sql = "select * from alert limit " + start + ", " + limit;

        OdbcConnection con = db.connect();
        OdbcCommand cmd = new OdbcCommand(sql, con);

        OdbcDataReader dr = cmd.ExecuteReader();

        return dr;

    }

    public static int alertslength()
    {
        string sql;
        sql = "select count(*) from alert";

        OdbcConnection con = db.connect();
        OdbcCommand cmd = new OdbcCommand(sql, con);

        OdbcDataReader dr = cmd.ExecuteReader();

        dr.Read();

        return Convert.ToInt16(dr[0]);

    }

    public static bool bot(string user_agent)
    {
        try
        {
            string sql;
            sql = "select count(*) from bot where ua = '" + user_agent + "'";

            OdbcConnection con = db.connect();
            OdbcCommand cmd = new OdbcCommand(sql, con);

            OdbcDataReader dr = cmd.ExecuteReader();

            dr.Read();
            if(Convert.ToInt32(dr[0])==0){
                sql = "insert into bot(dt,ua) values(now(),'"+user_agent+"')";

                cmd = new OdbcCommand(sql, con);
                cmd.ExecuteNonQuery();
                
            }
            return true;
        }
        catch
        {
            return false;
        }
    }
}
