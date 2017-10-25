<%@ Page Language="C#" debug="true"%>
<%Response.AppendHeader("Access-Control-Allow-Origin", "*");
    Response.AppendHeader("Content-type", "application/json");%>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        int id = Request.QueryString["id"]==null ? 0 : Convert.ToInt16(Request.QueryString["id"]);
        
        bool result = user.delete(id);

        string output = "{\"result\":\""+result.ToString() +"\"}";

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

