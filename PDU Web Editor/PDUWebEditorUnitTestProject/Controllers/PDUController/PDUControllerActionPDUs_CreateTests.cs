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
using Kendo.Mvc.UI;
using Moq;
using System.Web;
using System.Security.Principal;
using System.Web.Mvc;
namespace PDU_Web_Editor.ControllersTestSet.Tests
{
    [TestClass()]
    public class PDUControllerActionPDUs_CreateTests
    {
        private readonly InMemoryUnitOfWork _inMemoryUnitOfWork;
        private readonly PDUController _pduController;
        
        public PDUControllerActionPDUs_CreateTests()
        {
            _inMemoryUnitOfWork = new InMemoryUnitOfWork();
            _pduController = new PDUController(_inMemoryUnitOfWork);
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

            _pduController.ControllerContext = controllerContext.Object;
            #endregion
        } 
        #endregion
        [TestMethod()]
        public void PDUs_CreateTest_SuccessfullyAddPDUToRepository()
        {
            //Arrange
            var kendoDataRequest = new DataSourceRequest();

            PDU toBeAddedPDU = new PDU()
            {
                Pdu_PDUUniqueId = 1000,
                Pdu_FileName = "PDUDemo1",
                Pdu_UpdateByWho = @"CONNEX\xiguo",
                Pdu_UpdateOnDate = new DateTime(2014, 08, 25, 10, 2, 58),
                Pdu_Type = "Hospitality",
                Pdu_ScreenSize = "FullScreen"
            };
            //Act
            _pduController.PDUs_Create(kendoDataRequest, toBeAddedPDU); 
            //Assert
            Assert.IsNotNull(_inMemoryUnitOfWork.PDURepository.GetByID(0)); //id is auto generated, no matter what id you pass in
            Assert.IsTrue(_inMemoryUnitOfWork.PDURepository.GetByID(0).Pdu_UpdateByWho == @"connex\unitTestUser");
        }
    }
}
