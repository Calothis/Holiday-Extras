<%@ Page Language="C#" debug="true"%>
<%Response.AppendHeader("Access-Control-Allow-Origin", "*");
    Response.AppendHeader("Content-type", "application/json");%>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        int limit = Request.QueryString["limit"]==null ? 0 : Convert.ToInt16(Request.QueryString["limit"]);
        int page = Request.QueryString["page"]==null ? 1 : Convert.ToInt16(Request.QueryString["page"]);
        string orderby = (Request.QueryString["orderby"]==null ||  Request.QueryString["orderby"]=="") ? "id desc" : Request.QueryString["orderby"];

        OdbcDataReader dr;
        string output = "";

        dr = user.list(limit, page, orderby);

        while (dr.Read())
        {
            output += "{\"id\":\"" + dr[0].ToString() + "\",\"name\":\"" + dr[1].ToString() + "\",\"surname\":\"" + dr[2].ToString() + "\",\"email\":\"" + dr["email"].ToString() + "\",\"dt\":\""+dr["dt"].ToString()+"\"},";
        }
        db.closeconnection();
        if (output.Length > 0) { output = output.Substring(0, output.Length - 1);}
        output = "{\"recordcount\":\""+HttpContext.Current.Session["pages"].ToString()+"\",\"records\":[" + output + "]}";
        Response.Write(RemoveLineEndings(output));
    }

    public static string RemoveLineEndings(string value)
    {
        if(String.IsNullOrEmpty(value))
        {
            return value;
        }
        string lineSeparator = ((char) 0x2028).ToString();
        string paragraphSeparator = ((char)0x2029).ToString();

        return value.Replace("\r\n", string.Empty).Replace("\n", string.Empty).Replace("\r", string.Empty).Replace(lineSeparator, string.Empty).Replace(paragraphSeparator, string.Empty);
    }

</script>

