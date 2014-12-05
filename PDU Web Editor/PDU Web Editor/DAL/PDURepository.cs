using PDU_Web_Editor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PDU_Web_Editor.DAL
{
    public class PDURepository:RepositoryBase<PDU>
    {
        public PDURepository(PDUDbContext context)
            : base(context)
        {
        }       
    }
}