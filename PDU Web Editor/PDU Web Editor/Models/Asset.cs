using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.Linq;
using System.Web;

namespace PDU_Web_Editor.Models
{
    /// <summary>
    /// a Entity type for tbl_Assets database table
    /// </summary>
    public class Asset
    {

        [Key]
        public string Ast_FileName { get; set; }
        public string Ast_UpdatedByWho { get; set; }
        public string Ast_UpdatedOnDate { get; set; }
        public string Ast_FileLocation { get; set; }
        public string Ast_ScreenSize { get; set; }
        public virtual ICollection<Record> Records { get; set; }
          
    }
}
