<%@ Page Language="C#" debug="true"%>
<%Response.AppendHeader("Access-Control-Allow-Origin", "*");
    Response.AppendHeader("Content-type", "application/json");%>
<script runat="server">
    void Page_Load(object sender, EventArgs e)
    {
        int id = Request.Form["id"]==null ? 0 : Convert.ToInt16(Request.Form["id"]);
        string name = Request.Form["name"]==null ? "" : Request.Form["name"];
        string surname = Request.Form["surname"]==null ? "" : Request.Form["surname"];
        string email = Request.Form["email"]==null ? "" : Request.Form["email"];
        string output = "";

        user u = new user();

        if (id > 0)
        {

            if (u.load(id))
            {
                u.name = name;
                u.surname = surname;
                u.email = email;
                if (u.save() == id)
                {
                    output = "{\"result\":\"success\"}";
                }
                else
                {
                    output = "{\"result\":\"error\",\"reason\":\"failed to save\"}";
                }
            }
            else
            {
                output = "{\"result\":\"error\",\"reason\":\"failed to load - " + id + " / " + name + "\"}";
            }
        }else if (id == -1)
        {
                u.name = name;
                u.surname = surname;
                u.email = email;
                if (u.save() > 0)
                {
                    output = "{\"result\":\"success\"}";
                }
                else
                {
                    output = "{\"result\":\"error\",\"reason\":\"failed to create\"}";
                }
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

