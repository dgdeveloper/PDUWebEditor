using PDU_Web_Editor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace PDU_Web_Editor.DAL
{
    public interface IRecordRepository : IRepository<Record>, IDisposable
    {
    }
}
