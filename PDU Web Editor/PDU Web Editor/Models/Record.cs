using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;
using PDU_Web_Editor.Common;
using PDU_Web_Editor.DAL.Interface;

namespace PDU_Web_Editor.Models
{
    /// <summary>
    /// a Entity type for tbl_Records database table
    /// </summary>
    public class Record : IEntity
    {
        [Key]
        public int Rec_RecordId { get; set; }

        [Required]
        [DisplayName("Record Name")]
        [StringLength(255)]
        public string Rec_RecordName { get; set; }

        [Required]
        [DisplayName("Start Date of the Record")]
        [DataType(DataType.Date)]
        //[FutureDateOnly(ErrorMessage = "Can't select a date before Today")]
        public System.DateTime Rec_RecordStartDate { get; set; }

        [Required]
        [DisplayName("End Date of the Record")]
        [DataType(DataType.Date)]
        //[FutureDateOnly(ErrorMessage = "Can't select a date before Today")]
        [GreaterDate(EarlierDateField = "Rec_RecordStartDate", ErrorMessage = "End date should be after start date")]
        public System.DateTime Rec_RecordEndDate { get; set; }

        [DisplayName("Weight of the Record")]
        [Range(1,5)]
        public int Rec_RecordWeight { get; set; }

        [Required]
        [DisplayName("Asset File")]
        [ForeignKey("Asset")]
        public String Rec_AssetFileName { get; set; }
        public virtual Asset Asset { get; set; }
  
        [ForeignKey("PDU")]
        public int Rec_PDUUniqueId { get; set; }
        public virtual PDU PDU { get; set; }

        #region IEntity Members

        public string Id
        {
            get { return this.Rec_RecordId.ToString(); }
        }

        #endregion
    }
}
