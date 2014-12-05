using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;
using System.Xml.Linq;
using System.IO;
using System.Web.Mvc;
namespace PDU_Web_Editor.Models
{
    /// <summary>
    /// representation of extraData.xml file
    /// </summary>
    public sealed class ExtraDataConfigurationManager
    {
         
        private static readonly Lazy<ExtraDataConfigurationManager> _extradDataConfigManager = new Lazy<ExtraDataConfigurationManager>(() => new ExtraDataConfigurationManager(System.Web.HttpContext.Current.Server.MapPath("~/tmp/ExtraData.xml"))); 
        private XDocument _extradDataConfigXMLFile;
        private string _CDCDate;
        private string _retailerType;
        private string _extraDataConfigPath;

        private ExtraDataConfigurationManager()
        {

            _extraDataConfigPath = System.Web.HttpContext.Current.Server.MapPath("~/tmp/ExtraData.xml");
            _extradDataConfigXMLFile = XDocument.Load(_extraDataConfigPath);
        }
        private ExtraDataConfigurationManager(String extraDataConfigPath)
        {
            _extraDataConfigPath = extraDataConfigPath;
            _extradDataConfigXMLFile = XDocument.Load(_extraDataConfigPath);
        }
        public static ExtraDataConfigurationManager ExtraDataConfiguration
        {
            get
            {
                return _extradDataConfigManager.Value;
            }
        }

        public string CDCDate 
        { 
            get
            {
                var query = _extradDataConfigXMLFile.Descendants("Data").Select(s => new
                {
                    CDCDateElement = s.Element("CDCDate").Value
                }).FirstOrDefault();
                _CDCDate = query.CDCDateElement;

                return _CDCDate;
            }
            set
            {
                _CDCDate = value;
                var CDCDateElement = _extradDataConfigXMLFile.Descendants("Data").Select(s => s.Element("CDCDate")).FirstOrDefault();
                CDCDateElement.SetValue(_CDCDate);
            }
        }

        public string RetailerType
        {
            get
            {
                var query = _extradDataConfigXMLFile.Descendants("Data").Select(s => new
                {
                    retailerTypeElement = s.Element("RetailerType").Value
                }).FirstOrDefault();
                _retailerType = query.retailerTypeElement;

                return _CDCDate;
            }
            set
            {
                _retailerType = value;
                var retailerTypeElement = _extradDataConfigXMLFile.Descendants("Data").Select(s => s.Element("RetailerType")).FirstOrDefault();
                retailerTypeElement.SetValue(_retailerType);
            }
        }

        public void Save()
        {
            _extradDataConfigXMLFile.Save(_extraDataConfigPath);
        }

    }
}