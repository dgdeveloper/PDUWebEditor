using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace PDU_Web_Editor.DAL
{
    public class UnitOfWork:IDisposable
    {
        private PDUDbContext _context = new PDUDbContext();
        private AssetRepository _assetRepository;
        private PDURepository _pduRepository;
        private RecordRepository _RecordRepostiory;
        private bool disposed = false;

        public UnitOfWork()
        {
            //
        }

        public AssetRepository AssetRepository
        {
            get
            {
                if (this._assetRepository == null)
                {
                    this._assetRepository = new AssetRepository(_context);
                }
                return _assetRepository;
            }

        }

        public RecordRepository RecordRepostiory
        {
            get
            {
                if (this._RecordRepostiory == null)
                {
                    this._RecordRepostiory = new RecordRepository(_context);
                }
                return _RecordRepostiory;
            }
            
        }

        public PDURepository PDURepository
        {
            get
            {
                if (this._pduRepository == null)
                {
                    this._pduRepository = new PDURepository(_context);
                }
                return _pduRepository;
            }
            
        }


        public void Save()
        {
            _context.SaveChanges();
        }
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    _context.Dispose();
                }
            }
            this.disposed = true;
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}

