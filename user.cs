using System;
using System.Collections.Generic;
using System.Web;
using System.Data;
using System.Data.Odbc;
using System.Net;
using System.IO;


public class user
{
    protected int iID;
    protected string sName;
    protected string sSurname;
    protected string sEmail;
    protected DateTime dDt;

    protected string sErrMsg;

    protected Boolean bdirty; // tracks whether the user details have been updated
    protected Boolean bnew; // tracks whether this is a new user (as opposed to a record that has been loaded from the db)
    
    public user()
	{
        //initialise variables
        iID = 0;
        sName = "";
        sSurname = "";
        sEmail = "";
        dDt = DateTime.Now;

        bdirty = false;
        bnew = true;
	}

    public int id
    {
        get{return iID;}
    }

    public string name
    {
        get {return sName;}
        set { sName = value; bdirty = true; }
    }
    
    public string surname
    {
        get { return sSurname; }
        set { sSurname = value; bdirty = true; }
    }

    public string email
    {
        get { return sEmail; }
        set { sEmail = value; bdirty = true; }
    }
      
    public string timestamp
    {
        get { return Convert.ToString(dDt); }
        set { dDt = Convert.ToDateTime(value); }
    }

    public string errorMessage
    {
        get { return sErrMsg; }
    }

    public int save()
    {
        string sql;
        OdbcConnection con = db.connect();
        OdbcCommand cmd;
        OdbcDataReader dr;
        try
        {
            if (bdirty)
            {
                if (bnew)
                {
                    //Create a new record
                    sql = "insert into user(name,surname,email) values" +
                        "('" + name + "','" + surname + "','" + email + "')";
                        
                    cmd = new OdbcCommand(sql, con);
                    cmd.ExecuteNonQuery();

                    //Get the new ID:
                    sql = "select id from user order by id desc limit 1";
                    cmd = new OdbcCommand(sql, con);
                    dr = cmd.ExecuteReader();

                    if (dr.HasRows)
                    {
                        dr.Read();
                        iID = Convert.ToInt16(dr[0]);
                    }
                    else
                    {
                        iID = 0;
                    }

                    con.Close();
                    bdirty = false;

                    return iID;
                }
                else
                {

                    //Update the details on the database
                    sql = "update user set " +
                    " name = '" + name + "'," +
                    " surname = '" + surname + "'," +
                    " email = '" + email + "'" +
                    " where id = " + iID.ToString();

                    cmd = new OdbcCommand(sql, con);
                    cmd.ExecuteNonQuery();
                    con.Close();
                    bdirty = false;
                    return iID;
                }
            }
            else
            {
                return 0;
            }
        }
        catch (Exception e)
        {
            //Oops! Something went wrong...
            sErrMsg = e.Message;
            return 0;
        }
        finally
        {
            if (con.State == ConnectionState.Open) { con.Close(); }
        }
    }

    public bool load(int ID)
    {
        OdbcConnection con = db.connect();
        string sql = "select * from user where id = " + ID;
        OdbcCommand cmd = new OdbcCommand(sql, con);
        OdbcDataReader dr = cmd.ExecuteReader();
        
        if (dr.HasRows){
            dr.Read();
            sName = Convert.ToString(dr["name"]);
            sSurname = Convert.ToString(dr["surname"]);
            sEmail = Convert.ToString(dr["email"]);
            dDt = Convert.ToDateTime(dr["dt"]);
            iID = Convert.ToInt32(dr["id"]);

            bnew = false;
            bdirty = false;
            return true;
        }else{
            return false;
        }
    }

    public static bool delete(int ID)
    {
        OdbcConnection con = db.connect();
        string sql = "select * from user where id = " + ID;
        OdbcCommand cmd = new OdbcCommand(sql, con);
        OdbcDataReader dr = cmd.ExecuteReader();

        if (dr.HasRows)
        {
            sql = "delete from user where id = " + ID;
            cmd = new OdbcCommand(sql, con);
            cmd.ExecuteNonQuery();
            return true;
        }
        else
        {
            return false;
        }
    }

    public static OdbcDataReader list(int limit, int page, string orderby)
    {
        string sql;
        string sql2;
        string lmt = "";
        int pages;
        
        if (limit > 0 && page > 0)
        {
            lmt = " limit " + ((page - 1) * limit).ToString() + ", " + limit.ToString();
        }

        OdbcConnection con = db.connect();
        OdbcCommand cmd;
        OdbcDataReader dr;
     
        sql2 = "select count(*) from user";
        cmd = new OdbcCommand(sql2, con);
        dr = cmd.ExecuteReader();
        dr.Read();

        //store the current page (although not necessary if we are using an Angular front end that keeps track of this on its own...)
        HttpContext.Current.Session["pages"] = Convert.ToInt16(dr[0]);

        sql = "select * from user order by " + orderby + lmt;
      
        cmd = new OdbcCommand(sql, con);

        dr = cmd.ExecuteReader();

        return dr;
    }


}
