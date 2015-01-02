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
using Kendo.Mvc.UI;
using Kendo.Mvc.Extensions;


namespace PDU_Web_Editor.ControllersTestSet.Tests
{
    [TestClass()]
    public class RecordControllerActionRecord_ReadTests
    {
        private readonly InMemoryUnitOfWork _inMemoryUnitOfWork;
        private readonly RecordController _recordController;

        public RecordControllerActionRecord_ReadTests()
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
        public void Record_ReadTest_ReturnRecordsForExistPDUId()
        {
            //Arrange
            var kendoDataRequest = new DataSourceRequest();
            
            //Act
            JsonResult viewResult = _recordController.Records_Read(kendoDataRequest, 1) as JsonResult;
            //Assert
            DataSourceResult kendoDataSourceResult = viewResult.Data as DataSourceResult;
           // List<Record> actRecords = kendoDataSourceResult.Data as List<Record>;
            List<Record> expRecords = _inMemoryUnitOfWork.PDURepository.GetByID(1).Records as List<Record>;
            Assert.AreEqual(expRecords.Count, kendoDataSourceResult.Total);
        }

        [TestMethod()]
        [ExpectedException (typeof(NullReferenceException))]
        public void Record_ReadTest_ReturnNullReferenceExceptionForNoExistPDUId()
        {
            //Arrange
            var kendoDataRequest = new DataSourceRequest();

            //Act
            JsonResult viewResult = _recordController.Records_Read(kendoDataRequest, 0) as JsonResult;
            //Assert
            // assert is handled by ExpectedException
        }
    }
}
