using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PDU_Web_Editor.DAL;
using PDU_Web_Editor.Models;

namespace PDUWebEditorUnitTestProject.DAL.Infrastructure
{
    class InMemoryUnitOfWork : IUnitOfWork
    {
        private InMemoryRepositoryBase<Asset> _assetRepository;
        private InMemoryRepositoryBase<PDU> _pduRepository;
        private InMemoryRepositoryBase<Record> _RecordRepostiory;
        private InMemoryRepositoryBase<Package> _PackageRepostiory;
        private bool disposed = false;

        public InMemoryUnitOfWork()
        {
            this._assetRepository = new InMemoryRepositoryBase<Asset>();
            this._pduRepository = new InMemoryRepositoryBase<PDU>();
            this._RecordRepostiory = new InMemoryRepositoryBase<Record>();
            this._PackageRepostiory = new InMemoryRepositoryBase<Package>();
        }

        #region IUnitOfWork Members

        public IRepository<Asset> AssetRepository
        {
            get { return _assetRepository; }
        }

        public IRepository<Record> RecordRepostiory
        {
            get { return _RecordRepostiory; }
        }

        public IRepository<PDU> PDURepository
        {
            get { return _pduRepository; }
        }

        public IRepository<Package> PackageRepository
        {
            get { return _PackageRepostiory; }
        }
        public void Save()
        {
            //nothing 
        }

        #endregion

        #region IDisposable Members

        protected virtual void Dispose(bool disposing)
        {
            if (!this.disposed)
            {
                if (disposing)
                {
                    //do nothing
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
