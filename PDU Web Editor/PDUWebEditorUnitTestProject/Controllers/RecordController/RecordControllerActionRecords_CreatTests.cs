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
using System.Web;
using System.Security.Principal;
using Moq;
using System.Web.Mvc;
using Kendo.Mvc.UI;
namespace PDU_Web_Editor.ControllersTestSet.Tests
{
    [TestClass()]
    public class RecordControllerActionRecords_CreatTests
    {
        private readonly InMemoryUnitOfWork _inMemoryUnitOfWork;
        private readonly RecordController _recordController;

        public RecordControllerActionRecords_CreatTests()
        {
            _inMemoryUnitOfWork = new InMemoryUnitOfWork();
            _recordController = new RecordController(_inMemoryUnitOfWork);
        }
        #region Test Initialize

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

            #region mock for http user identity

            var fakeHttpContext = new Mock<HttpContextBase>();
            var fakeIdentity = new GenericIdentity(@"connex\unitTestUser");
            var principal = new GenericPrincipal(fakeIdentity, null);

            fakeHttpContext.Setup(t => t.User).Returns(principal);
            var controllerContext = new Mock<ControllerContext>();
            controllerContext.Setup(t => t.HttpContext).Returns(fakeHttpContext.Object);

            _recordController.ControllerContext = controllerContext.Object;
            #endregion

        } 
        #endregion

        [TestMethod()]
        public void Records_Create_SuccessfullyAddRecordToRepository()
        {
            //Arrange
            var kendoDataRequest = new DataSourceRequest();
            
            Record toBeAddedRecord = new Record()
            {
                Rec_RecordId = 100000,
                Rec_RecordName = "new record name",
                Rec_RecordStartDate = DateTime.Today,
                Rec_RecordEndDate = DateTime.Today,
                Rec_RecordWeight = 3,
                Rec_AssetFileName = "new asset file name",
                Rec_PDUUniqueId = 1 //add a record to pdu(id=1)
            };
            //Act
            _recordController.Records_Create(kendoDataRequest, toBeAddedRecord,1); //add a record to pdu(id=1)
            //Assert
            Assert.IsNotNull(_inMemoryUnitOfWork.RecordRepostiory.GetByID(0)); //id is auto generated, no matter what id you pass in
            Assert.IsTrue(_inMemoryUnitOfWork.PDURepository.GetByID(1).Pdu_UpdateByWho == @"connex\unitTestUser");
        }
    }
}
