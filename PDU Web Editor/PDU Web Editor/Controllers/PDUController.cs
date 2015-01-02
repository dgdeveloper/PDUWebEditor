
using Kendo.Mvc.UI;
using Kendo.Mvc.Extensions;
using PDU_Web_Editor.DAL;
using PDU_Web_Editor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Xml.Linq;
using System.IO;

namespace PDU_Web_Editor.ControllersTestSet
{
    public class PDUController : Controller
    {
        private IUnitOfWork _unitOfWork;

        public PDUController() : this(new SqlUnitOfWork(new PDUDbContext())) { }

        public PDUController(IUnitOfWork unitOfWork)
        {
            this._unitOfWork = unitOfWork;

        }
        
        public ActionResult Index()
        {
            ViewBag.Message = "Home Page - PDUs List";
            return View("Index");
        }
        
        public ActionResult PDUs_Read([DataSourceRequest]DataSourceRequest request)
        {
            using (var pduRepository = _unitOfWork.PDURepository)
            {
                IQueryable<PDU> pdus = pduRepository.Get().AsQueryable();
                DataSourceResult result = pdus.ToDataSourceResult(request, p => new
                {//avoid circular reference
                    Pdu_PDUUniqueId = p.Pdu_PDUUniqueId,
                    Pdu_FileName = p.Pdu_FileName,
                    Pdu_UpdateByWho = p.Pdu_UpdateByWho,
                    Pdu_UpdateOnDate = p.Pdu_UpdateOnDate,
                    Pdu_Type = p.Pdu_Type,
                    Pdu_ScreenSize = p.Pdu_ScreenSize,

                });
                return Json(result);
            }
        }
      
        public ActionResult PDUs_Delete([DataSourceRequest]DataSourceRequest request,PDU pdu)
        {
            if (ModelState.IsValid)
            {
                using (var pduRepository = _unitOfWork.PDURepository)
                {
                    PDU pduToBeDeleted = new PDU
                    {
                        Pdu_PDUUniqueId = pdu.Pdu_PDUUniqueId,
                        Pdu_FileName = pdu.Pdu_FileName,
                        Pdu_UpdateByWho = pdu.Pdu_UpdateByWho,
                        Pdu_UpdateOnDate = pdu.Pdu_UpdateOnDate,
                        Pdu_Type = pdu.Pdu_Type,
                        Pdu_ScreenSize = pdu.Pdu_ScreenSize,
                    };
                    pduRepository.Delete(pduToBeDeleted);
                    pduRepository.Save();
                }
            }
            return Json(new[] { pdu }.ToDataSourceResult(request, ModelState));
        }
        //Go to Records editor page
        public ActionResult PDURecords_Update(int id)
        {
            int pduId = id;
            return RedirectToAction("Index", "Record", new { id = pduId });
        }

        public ActionResult PDUs_Update([DataSourceRequest]DataSourceRequest request, PDU pdu)
        {
            if (ModelState.IsValid && pdu != null)
            {
                //update pdu 
                using (var pduRepository = _unitOfWork.PDURepository)
                {
                    PDU pduToBeUpdated = new PDU
                                       {
                                           Pdu_PDUUniqueId = pdu.Pdu_PDUUniqueId,
                                           Pdu_FileName = pdu.Pdu_FileName,
                                           Pdu_UpdateByWho = pdu.Pdu_UpdateByWho,
                                           Pdu_UpdateOnDate = pdu.Pdu_UpdateOnDate,
                                           Pdu_Type = pdu.Pdu_Type,
                                           Pdu_ScreenSize = pdu.Pdu_ScreenSize,
                                       };
                    pduRepository.Update(pduToBeUpdated);
                    pduRepository.Save();
                }


            }
            return Json(new[] { pdu }.ToDataSourceResult(request, ModelState));
        }
        [HttpPost]
        [ValidateAntiForgeryToken]
        public ActionResult PDUs_Update(PDU pdu)
        {
            if (ModelState.IsValid && pdu != null)
            {
                //update pdu 
                using (var pduRepository = _unitOfWork.PDURepository)
                {
                    PDU pduToBeUpdated = new PDU
                    {
                        Pdu_PDUUniqueId = pdu.Pdu_PDUUniqueId,
                        Pdu_FileName = pdu.Pdu_FileName,
                        Pdu_UpdateByWho = HttpContext.User.Identity.Name,
                        Pdu_UpdateOnDate = DateTime.Now,
                        Pdu_Type = pdu.Pdu_Type,
                        Pdu_ScreenSize = pdu.Pdu_ScreenSize,
                    };
                    pduRepository.Update(pduToBeUpdated);
                    pduRepository.Save();
                }


            }
            return RedirectToAction("Index", "PDU");
        }




        public ActionResult PDUs_Create([DataSourceRequest]DataSourceRequest request, PDU pdu)
        {
            if (ModelState.IsValid)
            {
                //update pdu 
                using (var pduRepository = _unitOfWork.PDURepository)
                {
                    PDU pduToBeCreated = new PDU
                    {
                        Pdu_FileName = pdu.Pdu_FileName,
                        Pdu_UpdateByWho = HttpContext.User.Identity.Name,
                        Pdu_UpdateOnDate = DateTime.Now,
                        Pdu_Type = pdu.Pdu_Type,
                        Pdu_ScreenSize = pdu.Pdu_ScreenSize,

                    };
                    pduRepository.Insert(pduToBeCreated);
                    pduRepository.Save();
                    pdu.Pdu_PDUUniqueId = pduToBeCreated.Pdu_PDUUniqueId;
                }
            }
            return Json(new[] { pdu }.ToDataSourceResult(request, ModelState));
        }



        public FileResult PDU_Download(int id)
        {
            int pduId = id;
            string pduFileName ="FailedToDownLoad";
            MemoryStream stream = new MemoryStream();

            using (var pduRepository = _unitOfWork.PDURepository)
            {
                PDU pdu = pduRepository.GetByID(pduId);
                pduFileName = pdu.Pdu_FileName + "_" + pdu.Pdu_Type + "_" + pdu.Pdu_ScreenSize + "_" + DateTime.Now.ToString("G");
                XDocument pduXMLFile = ouputPDUinXML(pdu);
                pduXMLFile.Save(stream);
                stream.Position = 0;
            }
            return File(stream, "application/xml", pduFileName+".xml");
        }

        public ActionResult PDU_Preview(int id)
        {
            int pduId = id;
            String xmlFileName = string.Empty;
            String destinationPath = string.Empty;
            string pduType;
            string pduScreenSize;

            ExtraDataConfigurationManager _extradDataConfigManager = ExtraDataConfigurationManager.ExtraDataConfiguration;           

            using (var pduRepository = _unitOfWork.PDURepository)
            {
                PDU pdu = pduRepository.GetByID(pduId);
                ViewBag.pruRecordCnt = pdu.Records.Count();

                if (pdu.Pdu_Type == "Hospitality")
                {
                    if (pdu.Pdu_ScreenSize == "VSplit")
                    {
                        xmlFileName = "HOSPITALITYVSplitAdSchedule.xml";
                    }
                    else if (pdu.Pdu_ScreenSize == "FullScreen")
                    {
                        xmlFileName = "HOSPITALITYAdSchedule.xml";
                    }
                }
                else if (pdu.Pdu_Type == "Retail")
                {
                    if (pdu.Pdu_ScreenSize == "VSplit")
                    {
                        xmlFileName = "RETAILVSplitAdSchedule.xml";
                    }
                    else if (pdu.Pdu_ScreenSize == "FullScreen")
                    {
                        xmlFileName = "RETAILAdSchedule.xml";
                    }
                }
                pduType = pdu.Pdu_Type == "Hospitality" ? "HN" : "RN";
                //save pdu type to Extradata xml , so main.swf will load corresponding xml files
                _extradDataConfigManager.RetailerType = pduType;
                _extradDataConfigManager.Save();

                //return to View to show full screen preview or VSplit screeN
                pduScreenSize  = pdu.Pdu_ScreenSize == "FullScreen" ? "FullScreen" : "VSplit";
                ViewBag.pduScreenSize = pduScreenSize;
                string basePath = Server.MapPath("~/tmp/");
                //create a transaction.xml depending on the screen size
                if (pduScreenSize == "FullScreen")
                {
                    if (System.IO.File.Exists(Path.Combine(basePath + "transaction.xml")))
                    {
                        makeACopyOfFile(Path.Combine(basePath + "transaction.xml"), Path.Combine(basePath + "transaction.xml.old"));
                    }

                }
                else if (pduScreenSize == "VSplit")
                {
                    if (System.IO.File.Exists(Path.Combine(basePath + "transaction.xml.old")))
                    {
                        makeACopyOfFile(Path.Combine(basePath + "transaction.xml.old"), Path.Combine(basePath + "transaction.xml"));
                    }

                }

                XDocument pduXMLFile = ouputPDUinXML(pdu);
                destinationPath = Path.Combine(Server.MapPath("~/PDURunTime/pduv4500/webshow/pdu/XML"), xmlFileName);
                pduXMLFile.Save(destinationPath);
            }

            return View();
        }
        /// <summary>
        /// convert date to CDC date
        /// </summary>
        /// <param name="date">a date</param>
        /// <returns></returns>
        private int DateToCDC(DateTime date)
        {
            DateTime dayZero = new DateTime(1982, 6, 2);
            TimeSpan ts = date.Subtract(dayZero);
            return ts.Days;
        } 

        private XDocument ouputPDUinXML(PDU pdu)
        {
            XDocument pduXML = new XDocument(new XElement("Schedule"));
            var records = pdu.Records;
              
            if (records != null)
            {
                var query = new XDocument(new XElement("Schedule",
                                                        from r in records
                                                        select new XElement("Product",
                                                                                new XElement("ID", r.Rec_RecordId),
                                                                                new XElement("Name", r.Rec_RecordName),
                                                                                new XElement("Location", r.Asset.Ast_FileLocation),
                                                                                new XElement("StartDate", DateToCDC(r.Rec_RecordStartDate)),
                                                                                new XElement("LastDate", DateToCDC(r.Rec_RecordEndDate)),
                                                                                new XElement("Weight", r.Rec_RecordWeight)
                                                                            )
                                                        )
                                            );
                 pduXML = query;
            }   
  
            return pduXML;
        }

        public ActionResult PurchaseTransaction()
        {
            RenameTransactionFile();
            return Content("Purchase Transaction is called");
        }
        /// <summary>
        /// create a copy of the source file, and remove the source
        /// </summary>
        /// <param name="sourceFile"></param>
        /// <param name="destinationFile"></param>
        private void makeACopyOfFile(string sourceFile, string destinationFile)
        {
                System.IO.File.Copy(sourceFile, destinationFile, true);
                System.IO.File.Delete(sourceFile);
        }
        /// <summary>
        /// rename transaction.xml file in tmp folder in order to show VSplit screen
        /// </summary>
        private void RenameTransactionFile()
        {
            string sourceFileName = "transaction.xml";
            string destinationFileName = "transaction.xml.old";
            string basePath = Server.MapPath("~/tmp/");

            if (System.IO.File.Exists(Path.Combine(basePath, "transaction.xml")))
            {
                sourceFileName = Path.Combine(basePath, "transaction.xml");
                destinationFileName = Path.Combine(basePath, "transaction.xml.old");
            }
            else
            {
                sourceFileName = Path.Combine(basePath, "transaction.xml.old");
                destinationFileName = Path.Combine(basePath, "transaction.xml");
             
            }
            makeACopyOfFile(sourceFileName, destinationFileName);
        }

        protected override void Dispose(bool disposing)
        {
            _unitOfWork.Dispose();
            base.Dispose(disposing);
        }
    }
}
