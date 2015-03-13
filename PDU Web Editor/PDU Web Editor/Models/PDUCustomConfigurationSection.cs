using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Web;

namespace PDU_Web_Editor.Models
{
    public class PDUCustomConfigurationSection : ConfigurationSection
    {
        [ConfigurationProperty("PDUFolder")]
        public PDUFolderElement PDUFolder
        {
            get
            {
                return (PDUFolderElement)this["PDUFolder"];
            }
            set
            { this["PDUFolder"] = value; }
        }

        [ConfigurationProperty("TempFolder")]
        public TempFolderElement TempFolder
        {
            get
            {
                return (TempFolderElement)this["TempFolder"];
            }
            set
            { this["TempFolder"] = value; }
        } 
  
    }
    public class PDUFolderElement : ConfigurationElement
    {
        [ConfigurationProperty("Path", IsRequired = true)]
        public String Path
        {
            get
            {
                return (String)this["Path"];
            }
            set
            {
                this["Path"] = value;
            }
        }
    }
    public class TempFolderElement : ConfigurationElement
    {
        [ConfigurationProperty("Path", IsRequired = true)]
        public String Path
        {
            get
            {
                return (String)this["Path"];
            }
            set
            {
                this["Path"] = value;
            }
        }
    }
}