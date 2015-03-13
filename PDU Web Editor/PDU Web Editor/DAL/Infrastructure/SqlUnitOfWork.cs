using PDU_Web_Editor.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Linq;
using System.Web;

namespace PDU_Web_Editor.DAL
{
    public class SqlUnitOfWork:IUnitOfWork
    {
        private DbContext _context;
        private IRepository<Asset> _assetRepository;
        private IRepository<PDU> _pduRepository;
        private IRepository<Record> _RecordRepostiory;
        private bool disposed = false;

        public SqlUnitOfWork(DbContext context)
        {
            this._context = context;
        }

        #region IUnitOfWork Member
        public IRepository<Asset> AssetRepository
        {
            get
            {
                if (this._assetRepository == null)
                {
                    this._assetRepository = new DbRepositoryBase<Asset>(_context);
                }
                return _assetRepository;
            }

        }

        public IRepository<Record> RecordRepostiory
        {
            get
            {
                if (this._RecordRepostiory == null)
                {
                    this._RecordRepostiory = new DbRepositoryBase<Record>(_context);
                }
                return _RecordRepostiory;
            }
            
        }

        public IRepository<PDU> PDURepository
        {
            get
            {
                if (this._pduRepository == null)
                {
                    this._pduRepository = new DbRepositoryBase<PDU>(_context);
                }
                return _pduRepository;
            }
            
        }

        public void Save()
        {
            _context.SaveChanges();
        }

        #endregion

        #region IDisposable Member
        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    _pduRepository.Dispose();
                    _assetRepository.Dispose();
                    _RecordRepostiory.Dispose();
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
        #endregion
      
    }
}

