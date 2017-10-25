<%@ Page Language="C#" debug="true"%>
<%Response.AppendHeader("Access-Control-Allow-Origin", "*");
    Response.AppendHeader("Content-type", "application/json");%>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        int id = Request.QueryString["id"]==null ? 0 : Convert.ToInt16(Request.QueryString["id"]);

        string output = "";

        user u = new user();

        if (u.load(id))
        {
            output = "{\"result\":\"success\",\"id\":\"" + u.id + "\",\"name\":\"" + u.name + "\",\"surname\":\"" + u.surname + "\",\"email\":\"" + u.email + "\",\"timestamp\":\"" + u.timestamp + "\"}";
        }
        else
        {
            output = "{\"result\":\"error\"}";
        }
               
        //if (output.Length > 0) { output = output.Substring(0, output.Length - 1);}
        //output = "{\"recordcount\":\""+HttpContext.Current.Session["pages"].ToString()+"\",\"records\":[" + output + "]}";
        Response.Write(output);
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

