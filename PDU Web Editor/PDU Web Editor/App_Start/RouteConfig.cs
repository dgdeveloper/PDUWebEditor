using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace PDU_Web_Editor
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "packageDownload",
                url: "Package/Package_Download/{Pkg_Uri}",
                defaults: new { controller = "Package", action = "Package_Download" }
           );

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "PDU", action = "Index", id = UrlParameter.Optional }
            );


        }
    }
}