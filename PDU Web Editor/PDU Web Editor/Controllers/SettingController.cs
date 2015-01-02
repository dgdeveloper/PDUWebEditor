using Kendo.Mvc.UI;
using PDU_Web_Editor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;


namespace PDU_Web_Editor.ControllersTestSet
{
    public class SettingController : Controller
    {
        private ExtraDataConfigurationManager _extradDataConfigManager = ExtraDataConfigurationManager.ExtraDataConfiguration;
        [HttpGet]
        public ActionResult index()
        {
            ViewBag.CDCDate = CDCToDate(int.Parse(_extradDataConfigManager.CDCDate));
             return View();
        }
        [HttpPost]
        public ActionResult index(DateTime CDCDate)
        {
            int cdcDate = DateToCDC(CDCDate);
            _extradDataConfigManager.CDCDate = cdcDate.ToString();
            _extradDataConfigManager.Save();
            ViewBag.CDCDate = CDCToDate(int.Parse(_extradDataConfigManager.CDCDate));
            return View();
        }

        private int DateToCDC(DateTime date)
        {
            DateTime dayZero = new DateTime(1982, 6, 2);
            TimeSpan ts = date.Subtract(dayZero);
            return ts.Days;
        }

        private DateTime CDCToDate(int cdc)
        {
            DateTime dayZero = new DateTime(1982, 6, 2);
            return dayZero.AddDays(cdc);
        } 
    }
}
