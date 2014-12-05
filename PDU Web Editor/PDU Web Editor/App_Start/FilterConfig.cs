using System.Web;
using System.Web.Mvc;

namespace PDU_Web_Editor
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new HandleErrorAttribute());
            filters.Add(new OutputCacheAttribute
            {
                VaryByParam = "*",
                Duration = 0,
                NoStore = true,
            });
            //allow authorized user to access web site
            filters.Add(new System.Web.Mvc.AuthorizeAttribute());
        }
    }
}