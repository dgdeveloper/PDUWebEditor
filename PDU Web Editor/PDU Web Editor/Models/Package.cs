using PDU_Web_Editor.DAL.Interface;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace PDU_Web_Editor.Models
{
    public class Package : IEntity
    {
        [Key]
        public int Pkg_PkgUniqueId { get; set; }

        [Required]
        [StringLength(255)]
        [DisplayName("Package Name")]
        public String Pkg_Name { get; set; }

        public string Pkg_UpdateByWho { get; set; }

        public System.DateTime Pkg_UpdateOnDate { get; set; }

        [Required]
        [DisplayName("Hospitality Full Ad")]
        public String Pkg_HospitalityFullAd { get; set; }

        [Required]
        [DisplayName("Hospitality vSplit Ad")]
        public String Pkg_HospitalityVSplitAd { get; set; }

        [Required]
        [DisplayName("Retail Full Ad")]
        public String Pkg_RetailFullAd { get; set; }

        [Required]
        [DisplayName("Hospitality vSplit Ad")]
        public String Pkg_RetailVSplitAd { get; set; }

        public String Pkg_Uri { get; set; }
 
        #region IEntity Members

        public string Id
        {
            get { return this.Pkg_Name; }
        }

        #endregion
    }
}