using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PDU_Web_Editor.ControllersTestSet;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using PDUWebEditorUnitTestProject.DAL.Infrastructure;
using PDUWebEditorUnitTestProject.Helper;
using PDU_Web_Editor.Models;
using System.Web.Mvc;
using System.IO;
namespace PDU_Web_Editor.ControllersTestSet.Tests
{
    [TestClass()]
    public class PDUControllerActionPDU_DownloadTests
    {
        private readonly InMemoryUnitOfWork _inMemoryUnitOfWork;
        private readonly PDUController _pduController;

        public PDUControllerActionPDU_DownloadTests()
        {
            _inMemoryUnitOfWork = new InMemoryUnitOfWork();
            _pduController = new PDUController(_inMemoryUnitOfWork);
        }
        #region Test Initialize

        [TestInitialize()]
        public void setupRepositories()
        {
            //associate a record with PDU and asset
            foreach (Record record in TestDataFactory.Records)
            {
                foreach (PDU pdu in TestDataFactory.PDUs)
                {
                    if (record.Rec_PDUUniqueId == pdu.Pdu_PDUUniqueId)
                    {
                        record.PDU = pdu;
                        break;
                    }
                }
                foreach (Asset asset in TestDataFactory.Assets)
                {
                    if (record.Rec_AssetFileName == asset.Ast_FileName)
                    {
                        record.Asset = asset;
                        break;
                    }
                }
                _inMemoryUnitOfWork.RecordRepostiory.Insert(record);
            }

            //associate a pdu with records
            foreach (PDU pdu in TestDataFactory.PDUs)
            {
                IEnumerable<Record> records = _inMemoryUnitOfWork.RecordRepostiory.Get();
                foreach (Record record in records)
                {
                    if (record.Rec_PDUUniqueId == pdu.Pdu_PDUUniqueId)
                    {
                        pdu.Records.Add(record);
                    }
                }
                _inMemoryUnitOfWork.PDURepository.Insert(pdu);
            }
            //associate a assets with records
            foreach (Asset asset in TestDataFactory.Assets)
            {
                IEnumerable<Record> records = _inMemoryUnitOfWork.RecordRepostiory.Get();
                foreach (Record record in records)
                {
                    if (record.Rec_AssetFileName == asset.Ast_FileName)
                    {
                        asset.Records.Add(record);
                    }
                }
                _inMemoryUnitOfWork.AssetRepository.Insert(asset);
            }
        } 
        #endregion
        [TestMethod()]
        public void PDU_DownloadTest_xmlDisplayForExistPDU()
        {
            //Arrange
            PDU pduToBeDownload = _inMemoryUnitOfWork.PDURepository.GetByID(1);
            //Act
            FileResult xml = _pduController.PDU_Download(pduToBeDownload.Pdu_PDUUniqueId) as FileResult;
            //Assert
            Assert.IsNotNull(xml);

        }
        [TestMethod()]
        [ExpectedException(typeof(NullReferenceException))]
        public void PDU_DownloadTest_xmlDisplayForNoExistPDU()
        {
            //Arrange
            PDU pduToBeDownload = _inMemoryUnitOfWork.PDURepository.GetByID(0);
            //Act
            FileResult xml = _pduController.PDU_Download(pduToBeDownload.Pdu_PDUUniqueId) as FileResult;
            //Assert
            // assert is handled by ExpectedException
   

        }
    }
}
