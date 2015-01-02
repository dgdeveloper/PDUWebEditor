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
namespace PDU_Web_Editor.ControllersTestSet.Tests
{
    [TestClass()]
    public class PDUControllerActionPDUs_DeleteTests
    {
        private readonly InMemoryUnitOfWork _inMemoryUnitOfWork;
        private readonly PDUController _pduController;

        public PDUControllerActionPDUs_DeleteTests()
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
        } 
        #endregion
        [TestMethod()]
        public void PDUs_DeleteTest_SuccessullyDeleteAPDU()
        {
            //Arrange
            var kendoDataRequest = new DataSourceRequest();
            PDU pduToBeDeleted = _inMemoryUnitOfWork.PDURepository.GetByID(1);
            //Act
            _pduController.PDUs_Delete(kendoDataRequest, pduToBeDeleted);
            //Assert
            CollectionAssert.DoesNotContain(_inMemoryUnitOfWork.PDURepository.Get() as List<PDU>, pduToBeDeleted);
        }
        [TestMethod()]
        [ExpectedException(typeof(ArgumentOutOfRangeException))]
        public void PDUs_DeleteTest_ReturnArgumentOutOfRangeExceptionWhenDeleteNoExistPDU()
        {
            //Arrange
            var kendoDataRequest = new DataSourceRequest();
            PDU noExistPDIToBeDeleted = new PDU
            {
                Pdu_PDUUniqueId = 10000,
                Pdu_FileName = "noExistPDIToBeDeleted",
                Pdu_UpdateByWho = @"CONNEX\xiguo",
                Pdu_UpdateOnDate = new DateTime(2014, 08, 25, 10, 2, 58),
                Pdu_Type = "Hospitality",
                Pdu_ScreenSize = "FullScreen",
                Records = new List<Record>(),
            };
            //Act
            _pduController.PDUs_Delete(kendoDataRequest, noExistPDIToBeDeleted);
            //Assert
            // assert is handled by ExpectedException
        }
    }
}
