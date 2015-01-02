using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using PDU_Web_Editor.ControllersTestSet;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Web;
using System.Web.Mvc;
using PDUWebEditorUnitTestProject.DAL.Infrastructure;
using PDUWebEditorUnitTestProject.Helper;
using PDU_Web_Editor.Models;
using Kendo.Mvc.UI;
namespace PDU_Web_Editor.ControllersTestSet.Tests
{
    [TestClass()]
    public class AssetControllerActionAssets_ReadTests
    {
        private readonly InMemoryUnitOfWork _inMemoryUnitOfWork;
        private readonly AssetController _assetController;

        public AssetControllerActionAssets_ReadTests()
        {
            _inMemoryUnitOfWork = new InMemoryUnitOfWork();
            _assetController = new AssetController(_inMemoryUnitOfWork);
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
        public void Assets_ReadTest_AllAssetsAreLoad()
        {
            //Arrange
            var kendoDataRequest = new DataSourceRequest();
            //act
            JsonResult viewResult = _assetController.Assets_Read(kendoDataRequest) as JsonResult;
            //assert
            DataSourceResult kendoDataSourceResult = viewResult.Data as DataSourceResult;
            List<Asset> expAssetRecords = _inMemoryUnitOfWork.AssetRepository.Get() as List<Asset>;
            Assert.AreEqual(expAssetRecords.Count, kendoDataSourceResult.Total);
        }
    }
}
