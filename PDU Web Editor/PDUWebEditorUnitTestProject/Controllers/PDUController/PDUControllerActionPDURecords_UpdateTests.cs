﻿using System;
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
namespace PDU_Web_Editor.ControllersTestSet.Tests
{
    [TestClass()]
    public class PDUControllerActionPDURecords_UpdateTests
    {
                private readonly InMemoryUnitOfWork _inMemoryUnitOfWork;
        private readonly PDUController _pduController;

        public PDUControllerActionPDURecords_UpdateTests()
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
        public void PDURecords_UpdateTest_RedirectToRecordIndexPageForExistPDU()
        {
            //Arrange
            PDU pduToBeUpdated = _inMemoryUnitOfWork.PDURepository.GetByID(1);
            //Act
            RedirectToRouteResult redirectViewResult = _pduController.PDURecords_Update(pduToBeUpdated.Pdu_PDUUniqueId) as RedirectToRouteResult;
            //Assert
            StringAssert.Equals("Index", redirectViewResult.RouteValues["action"]);
            StringAssert.Equals("Record", redirectViewResult.RouteValues["controller"]);
        }
        [TestMethod()]
        public void PDURecords_UpdateTest_RedirectToRecordIndexPageForNonExistPDU()
        {
            //Arrange
            
            //Act
            RedirectToRouteResult redirectViewResult = _pduController.PDURecords_Update(0) as RedirectToRouteResult;
            //Assert
            StringAssert.Equals("Index", redirectViewResult.RouteValues["action"]);
            StringAssert.Equals("Record", redirectViewResult.RouteValues["controller"]);
        }
    }
}