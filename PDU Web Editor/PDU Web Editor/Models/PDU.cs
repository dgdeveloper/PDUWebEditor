using PDU_Web_Editor.DAL.Interface;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Text;


namespace PDU_Web_Editor.Models
{
    /// <summary>
    /// a Entity type for tbl_PUDs database table
    /// </summary>
    public class PDU : IEntity
    {
        [Key]
        public int Pdu_PDUUniqueId { get; set; }
        [Required]
        [DisplayName("PDU FileName")]
        [StringLength(255)]
        public string Pdu_FileName { get; set; }
        public string Pdu_UpdateByWho { get; set; }
        public System.DateTime Pdu_UpdateOnDate { get; set; }
        [Required]
        [DisplayName("PDU Type")]
        [StringLength(255)]
        [UIHint("_PDUTypeEditor")]
        public string Pdu_Type { get; set; }
        [Required]
        [DisplayName("PDU ScreenSize")]
        [UIHint("_ScreenSizeEditor")]
        public string Pdu_ScreenSize { get; set; }

        public virtual ICollection<Record> Records { get; set; }

        #region IEntity Members

        public string Id
        {
            get { return this.Pdu_PDUUniqueId.ToString(); }
        }

        #endregion
    }
}
