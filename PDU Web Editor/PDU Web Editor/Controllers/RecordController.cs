using Kendo.Mvc.UI;
using Kendo.Mvc.Extensions;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using PDU_Web_Editor.DAL;
using PDU_Web_Editor.Models;

namespace PDU_Web_Editor.ControllersTestSet
{
    public class RecordController : Controller
    {
        private IUnitOfWork _unitOfWork;

        public RecordController() : this(new SqlUnitOfWork(new PDUDbContext())) { }

        public RecordController(IUnitOfWork unitOfWork)
        {
            this._unitOfWork = unitOfWork;

        }
        public ActionResult Index(int id)
        {
            ViewBag.Message = "Records Page";
            ViewBag.pduId = id;
            //populate for asset drop down list data binding
            PopulateAssets();
            PDU pdu = _unitOfWork.PDURepository.GetByID(id);
            return View("Index",pdu);
        }
        
        private void PopulateAssets()
        {
            var assetRepository = _unitOfWork.AssetRepository;

            var assets = assetRepository.Get().Select(e => new Asset
            {//avoid circular reference
                Ast_FileName = e.Ast_FileName,
                Ast_UpdatedByWho = e.Ast_UpdatedByWho,
                Ast_UpdatedOnDate = e.Ast_UpdatedOnDate,
                Ast_FileLocation = e.Ast_FileLocation,
                Ast_ScreenSize = e.Ast_ScreenSize,
            });
            ViewData["assets"] = assets;    
        }

        public ActionResult Records_Read([DataSourceRequest]DataSourceRequest request, int pduId)
        {
          
            using (var pduRepository = _unitOfWork.PDURepository)
            {
                IQueryable<Record> records = pduRepository.GetByID(pduId).Records.AsQueryable();
                DataSourceResult result = records.ToDataSourceResult(request, r => new
                {//avoid circular reference
                    Rec_RecordId = r.Rec_RecordId,
                    Rec_RecordName = r.Rec_RecordName,
                    Rec_RecordStartDate = r.Rec_RecordStartDate,
                    Rec_RecordEndDate = r.Rec_RecordEndDate,
                    Rec_RecordWeight = r.Rec_RecordWeight,
                    Rec_AssetFileName = r.Rec_AssetFileName,
                    Rec_PDUUniqueId = r.Rec_PDUUniqueId,               
                });
                return Json(result);
            }
        }

        public ActionResult Records_Update([DataSourceRequest]DataSourceRequest request, Record record, int pduId)
        {
            if (ModelState.IsValid && record != null)
            {
                //update record
                using (var recordRepository = _unitOfWork.RecordRepostiory)
                {
                    Record recordToBeUpdated = new Record
                    {
                        Rec_RecordId = record.Rec_RecordId,
                        Rec_RecordName = record.Rec_RecordName,
                        Rec_RecordStartDate = record.Rec_RecordStartDate,
                        Rec_RecordEndDate = record.Rec_RecordEndDate,
                        Rec_RecordWeight = record.Rec_RecordWeight,
                        Rec_AssetFileName = record.Rec_AssetFileName,
                        Rec_PDUUniqueId = record.Rec_PDUUniqueId,
                     };
                    recordRepository.Update(recordToBeUpdated);
                    recordRepository.Save();
                    //update pdu 
                    using (var pduRepository = _unitOfWork.PDURepository)
                    {
                        if (pduRepository.GetByID(recordToBeUpdated.Rec_PDUUniqueId) != null)
                        {
                            PDU pdu = pduRepository.GetByID(recordToBeUpdated.Rec_PDUUniqueId);
                            pdu.Pdu_UpdateByWho = HttpContext.User.Identity.Name;
                            pdu.Pdu_UpdateOnDate = DateTime.Now;
                            pduRepository.Save();
                        }   
                    }
                }
        
            }
            return Json(new[] { record }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult Records_Delete([DataSourceRequest]DataSourceRequest request, Record record)
        {
            if (ModelState.IsValid && record != null)
            {
                using (var recordRepository = _unitOfWork.RecordRepostiory)
                {
                    Record recordToBeDeleted = new Record
                    {
                        Rec_RecordId = record.Rec_RecordId,
                        Rec_RecordName = record.Rec_RecordName,
                        Rec_RecordStartDate = record.Rec_RecordStartDate,
                        Rec_RecordEndDate = record.Rec_RecordEndDate,
                        Rec_RecordWeight = record.Rec_RecordWeight,
                        Rec_AssetFileName = record.Rec_AssetFileName,
                        Rec_PDUUniqueId = record.Rec_PDUUniqueId,
                    };
                    recordRepository.Delete(recordToBeDeleted);
                    recordRepository.Save();
                }
            }
            return Json(new[] { record }.ToDataSourceResult(request, ModelState));
        }


        public ActionResult Records_Create([DataSourceRequest]DataSourceRequest request, Record record, int pduId)
        {
            if (ModelState.IsValid)
            {
                //create a new record
                using (var recordRepository = _unitOfWork.RecordRepostiory)
                {
                    Record recordToBeCreated = new Record
                    {
                        Rec_RecordName = record.Rec_RecordName,
                        Rec_RecordStartDate = record.Rec_RecordStartDate,
                        Rec_RecordEndDate = record.Rec_RecordEndDate,
                        Rec_RecordWeight = record.Rec_RecordWeight,
                        Rec_AssetFileName = record.Rec_AssetFileName,
                        Rec_PDUUniqueId = pduId,
                    };
                    recordRepository.Insert(recordToBeCreated);
                    recordRepository.Save();
                    /* datasource update its internal data*/
                    // Get the Rec_PDUUniqueId from the database
                    record.Rec_PDUUniqueId = recordToBeCreated.Rec_PDUUniqueId;
                    //Get the Rec_RecordId generated by the database
                    record.Rec_RecordId = recordToBeCreated.Rec_RecordId;
                    //update pdu 
                    using (var pduRepository = _unitOfWork.PDURepository)
                    {
                        if (pduRepository.GetByID(recordToBeCreated.Rec_PDUUniqueId) != null)
                        {
                            PDU pdu = pduRepository.GetByID(recordToBeCreated.Rec_PDUUniqueId);
                            pdu.Pdu_UpdateByWho = HttpContext.User.Identity.Name;
                            pdu.Pdu_UpdateOnDate = DateTime.Now;
                            pduRepository.Save();
                        }
                    }
                }

            }
            return Json(new[] { record }.ToDataSourceResult(request, ModelState));
        }

        protected override void Dispose(bool disposing)
        {
            _unitOfWork.Dispose();
            base.Dispose(disposing);
        }
    }
}
