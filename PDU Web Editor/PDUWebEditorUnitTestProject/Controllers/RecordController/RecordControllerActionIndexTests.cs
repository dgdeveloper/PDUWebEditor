using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using PDUWebEditorUnitTestProject.DAL.Infrastructure;
using PDUWebEditorUnitTestProject.Helper;
using PDU_Web_Editor.Models;
using System.Web.Mvc;


namespace PDU_Web_Editor.ControllersTestSet.Tests
{
    [TestClass()]
    public class RecordControllerActionIndexTests
    {
        private readonly InMemoryUnitOfWork _inMemoryUnitOfWork;
        private readonly RecordController _recordController;

        public RecordControllerActionIndexTests()
        {
            _inMemoryUnitOfWork = new InMemoryUnitOfWork();
            _recordController = new RecordController(_inMemoryUnitOfWork);
        }

        
        [TestInitialize()]
        public void setupRepositories()
        {
            //associate a pdu with records
            foreach (PDU pdu in TestDataFactory.PDUs)
            {
                foreach (Record record in TestDataFactory.Records)
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
                foreach (Record record in TestDataFactory.Records)
                {
                    if (record.Rec_AssetFileName == asset.Ast_FileName)
                    {
                        asset.Records.Add(record);
                    }
                }
                _inMemoryUnitOfWork.AssetRepository.Insert(asset);
            }

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
        }

        [TestMethod()]
        public void IndexTest_ReturnRecordsWithExistPDUId()
        {
            //Arrange
             
            //Act
            ViewResult viewResult = _recordController.Index(1) as ViewResult;
            //Assert
            PDU pdu = viewResult.Model as PDU;
            Assert.IsTrue(pdu.Id == "1");
            IEnumerable<Asset> act = (IEnumerable<Asset>)viewResult.ViewData["assets"];
            List<Asset> exp =_inMemoryUnitOfWork.AssetRepository.Get().ToList();
            Assert.IsTrue(act.Count() == exp.Count());
     
        }

        [TestMethod()]
        public void IndexTest_ReturnNullWithNoExistPDUId()
        {
            //Arrange

            //Act
            ViewResult actionResult = _recordController.Index(0) as ViewResult;
            //Assert
            Assert.IsNull(actionResult.Model);
        }
    }
}
