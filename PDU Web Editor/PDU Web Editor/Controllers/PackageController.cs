using Kendo.Mvc.UI;
using Kendo.Mvc.Extensions;
using PDU_Web_Editor.DAL;
using PDU_Web_Editor.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.IO;
using System.IO.Compression;
using System.Xml.Linq;



namespace PDU_Web_Editor.ControllersTestSet
{
    public class PackageController : Controller
    {
        private IUnitOfWork _unitOfWork;

        public PackageController() : this(new SqlUnitOfWork(new PDUDbContext())) { }


        public PackageController(IUnitOfWork unitOfWork)
        {
            this._unitOfWork = unitOfWork;

        }

        public ActionResult Index()
        {
            ViewBag.Message = "Package Page";
            return View("Index");
        }

        public JsonResult getPDUAdByPDUTypeAndScreenSize(String pduType, String screenSize)
        {
            var pduRepository = _unitOfWork.PDURepository;

            var pdus = pduRepository.Get().Select(p => new PDU
            {//avoid circular reference
                    Pdu_PDUUniqueId = p.Pdu_PDUUniqueId,
                    Pdu_FileName = p.Pdu_FileName,
                    Pdu_UpdateByWho = p.Pdu_UpdateByWho,
                    Pdu_UpdateOnDate = p.Pdu_UpdateOnDate,
                    Pdu_Type = p.Pdu_Type,
                    Pdu_ScreenSize = p.Pdu_ScreenSize,
            });

            var results = pdus.Where(p => p.Pdu_Type == pduType && p.Pdu_ScreenSize == screenSize);

            return Json(results, JsonRequestBehavior.AllowGet);
        }

        public ActionResult Packages_Read([DataSourceRequest]DataSourceRequest request)
        {
            using (var packageRepository = _unitOfWork.PackageRepository)
            {
                IQueryable<Package> packages = packageRepository.Get().AsQueryable();
                DataSourceResult result = packages.ToDataSourceResult(request, p => new
                {//avoid circular reference
                    Pkg_PkgUniqueId = p.Pkg_PkgUniqueId,
                    Pkg_Name = p.Pkg_Name,
                    Pkg_UpdateByWho = p.Pkg_UpdateByWho,
                    Pkg_UpdateOnDate = p.Pkg_UpdateOnDate,
                    Pkg_HospitalityFullAd = p.Pkg_HospitalityFullAd,
                    Pkg_HospitalityVSplitAd = p.Pkg_HospitalityVSplitAd,
                    Pkg_RetailFullAd = p.Pkg_RetailFullAd,
                    Pkg_RetailVSplitAd = p.Pkg_RetailVSplitAd,
                    Pkg_Uri = p.Pkg_Uri,
                });
                return Json(result);
            }
        }

        public ActionResult Packages_Update([DataSourceRequest]DataSourceRequest request, Package package)
        {
            if (ModelState.IsValid && package != null)
            {
                //update record
                using (var packageRepository = _unitOfWork.PackageRepository)
                {
                    Package packageToBeUpdated = new Package
                    {
                        Pkg_PkgUniqueId = package.Pkg_PkgUniqueId,
                        Pkg_Name = package.Pkg_Name,
                        Pkg_HospitalityFullAd = package.Pkg_HospitalityFullAd,
                        Pkg_HospitalityVSplitAd = package.Pkg_HospitalityVSplitAd,
                        Pkg_RetailFullAd = package.Pkg_RetailFullAd,
                        Pkg_RetailVSplitAd = package.Pkg_RetailVSplitAd,
                        Pkg_UpdateByWho =  HttpContext.User.Identity.Name,
                        Pkg_UpdateOnDate = DateTime.Now,
                        Pkg_Uri = package.Pkg_Uri,
                
                    };
                    packageRepository.Update(packageToBeUpdated);
                    packageRepository.Save();

                }

            }
            return Json(new[] { package }.ToDataSourceResult(request, ModelState));
        }

        public ActionResult Packages_Delete([DataSourceRequest]DataSourceRequest request, Package package)
        {
            if (ModelState.IsValid && package != null)
            {
                //delete from database
                using (var packageRepository = _unitOfWork.PackageRepository)
                {
                    Package packageToBeDeleted = new Package
                    {
                        Pkg_PkgUniqueId = package.Pkg_PkgUniqueId,
                        Pkg_Name = package.Pkg_Name,
                        Pkg_HospitalityFullAd = package.Pkg_HospitalityFullAd,
                        Pkg_HospitalityVSplitAd = package.Pkg_HospitalityVSplitAd,
                        Pkg_RetailFullAd = package.Pkg_RetailFullAd,
                        Pkg_RetailVSplitAd = package.Pkg_RetailVSplitAd,
                        Pkg_UpdateByWho = HttpContext.User.Identity.Name,
                        Pkg_UpdateOnDate = DateTime.Now,
                        Pkg_Uri = package.Pkg_Uri,
                      
                    };
                    packageRepository.Delete(packageToBeDeleted);
                    packageRepository.Save();

                }
                //delete zip file
                PDUCustomConfigurationSection _pdyCustomConfig = (PDUCustomConfigurationSection)System.Configuration.ConfigurationManager.GetSection("PDUCustomConfigurationGroup/PDUCustomConfiguration");

                string destinationPath = Path.Combine(Server.MapPath(@"~/PackageDownload"), package.Pkg_Uri + @".zip");

                if (!System.IO.File.Exists(destinationPath))
                {

                    return this.Json(new DataSourceResult
                    {
                        Errors = "the package zip file doesn't exist"
                    });
                }
                //delete the physical file
                System.IO.File.Delete(destinationPath);
            }
            return Json(new[] { package }.ToDataSourceResult(request, ModelState));
        }


        public ActionResult Packages_Create([DataSourceRequest]DataSourceRequest request, Package package)
        {
            if (ModelState.IsValid)
            {
                //create a new record
                using (var packageRepository = _unitOfWork.PackageRepository)
                {
                    Package packageToBeCreated = new Package
                    {
                        Pkg_PkgUniqueId = package.Pkg_PkgUniqueId,
                        Pkg_Name = package.Pkg_Name,
                        Pkg_HospitalityFullAd = package.Pkg_HospitalityFullAd,
                        Pkg_HospitalityVSplitAd = package.Pkg_HospitalityVSplitAd,
                        Pkg_RetailFullAd = package.Pkg_RetailFullAd,
                        Pkg_RetailVSplitAd = package.Pkg_RetailVSplitAd,
                        Pkg_UpdateByWho = HttpContext.User.Identity.Name,
                        Pkg_UpdateOnDate = DateTime.Now,
                        Pkg_Uri = package.Pkg_Uri,

                    };


                    //Create a package zip file
                    String packageUri = CreatePackageZipFile(packageToBeCreated);
                    //update uri of the package
                    packageToBeCreated.Pkg_Uri = packageUri;
                    packageRepository.Insert(packageToBeCreated);
                    packageRepository.Save();
                }

                

            }
            return Json(new[] { package }.ToDataSourceResult(request, ModelState));
        }

         /// <summary>
        /// Zip given package into a zip folder
        /// </summary>
        /// <param name="package">package object</param>
        /// <returns>uri path of the zip folder</returns>
        private String CreatePackageZipFile(Package package)
        {
            String pakcageUri = String.Empty;
            string sourcePath = Server.MapPath(@"~/PDURunTime/pduv4500");
            string destinationPath = Server.MapPath(@"~/PackageDownload");
            string zipName = package.Pkg_Name + "_" + DateTime.Now.ToFileTime() ;
            string zipPath = Path.Combine(destinationPath,zipName + @".zip");


            //generate four pdu xml files: hospitality and retail ((Full Screen and vSplit)  
            using (var pduRepository = _unitOfWork.PDURepository)
            {
                String Pkg_HospitalityFullAd = package.Pkg_HospitalityFullAd;
                String Pkg_HospitalityVSplitAd = package.Pkg_HospitalityVSplitAd;
                String Pkg_RetailFullAd = package.Pkg_RetailFullAd;
                String Pkg_RetailVSplitAd = package.Pkg_RetailVSplitAd;
                PDUCustomConfigurationSection _pdyCustomConfig = (PDUCustomConfigurationSection)System.Configuration.ConfigurationManager.GetSection("PDUCustomConfigurationGroup/PDUCustomConfiguration");

                XDocument pduXMLFile = new XDocument();
                PDU pdu = new PDU();
      
                //Generate Hospitality Full screen xml file
                pdu = pduRepository.Get(p => p.Pdu_FileName == Pkg_HospitalityFullAd).FirstOrDefault();
                pduXMLFile = ouputPDUinXML(pdu);
                destinationPath = Path.Combine(Server.MapPath(_pdyCustomConfig.PDUFolder.Path + "/XML"), "HOSPITALITYAdSchedule.xml");
                pduXMLFile.Save(destinationPath);

                //Generate Hospitality Full screen xml file
                pdu = pduRepository.Get(p => p.Pdu_FileName == Pkg_HospitalityVSplitAd).FirstOrDefault();
                pduXMLFile = ouputPDUinXML(pdu);
                destinationPath = Path.Combine(Server.MapPath(_pdyCustomConfig.PDUFolder.Path + "/XML"), "HOSPITALITYVSplitAdSchedule.xml");
                pduXMLFile.Save(destinationPath);

                //Generate Retail Full screen xml file
                pdu = pduRepository.Get(p => p.Pdu_FileName == Pkg_RetailFullAd).FirstOrDefault();
                pduXMLFile = ouputPDUinXML(pdu);
                destinationPath = Path.Combine(Server.MapPath(_pdyCustomConfig.PDUFolder.Path + "/XML"), "RETAILAdSchedule.xml");
                pduXMLFile.Save(destinationPath);

                //Generate Retail Full screen xml file
                pdu = pduRepository.Get(p => p.Pdu_FileName == Pkg_RetailVSplitAd).FirstOrDefault();
                pduXMLFile = ouputPDUinXML(pdu);
                destinationPath = Path.Combine(Server.MapPath(_pdyCustomConfig.PDUFolder.Path + "/XML"), "RETAILVSplitAdSchedule.xml");
                pduXMLFile.Save(destinationPath);
           }
     
            //zip the folder
            ZipFile.CreateFromDirectory(sourcePath, zipPath, CompressionLevel.Fastest, true);
            pakcageUri = zipName;

            return pakcageUri;
        }
        public FileResult Package_Download(String Pkg_Uri)
        {          
            string destinationPath = Server.MapPath(@"~/PackageDownload");
            string zipPath = Path.Combine(destinationPath, Pkg_Uri + @".zip");

            return File(zipPath, "application/zip", Pkg_Uri + ".zip");
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

        protected override void Dispose(bool disposing)
        {
            _unitOfWork.Dispose();
            base.Dispose(disposing);
        }
    }
}
