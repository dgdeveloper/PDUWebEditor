using PDU_Web_Editor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PDU_Web_Editor.DAL
{
    public class AssetRepository:RepositoryBase<Asset>,IAssetRepository
    {
        public AssetRepository(PDUDbContext context)
            : base(context)
        {
        }
    }
}